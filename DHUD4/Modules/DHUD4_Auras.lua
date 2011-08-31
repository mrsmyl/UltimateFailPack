--[[
DHUD4_Auras.lua
Copyright (c) 2006 by Markus Inger, 2006 by Caeryn Dryad, 2007-2010 by Horacio Hoyos

This file is part of DHUD4.

    DHUD4 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    DHUD4 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DHUD4.  If not, see <http://www.gnu.org/licenses/>.
]]

local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4");
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4");

local MODNAME = "DHUD4_Auras";
local DHUD4_Auras = DHUD4:NewModule(MODNAME, "AceEvent-3.0");
local VERSION = tonumber(("$Rev: 103 $"):match("%d+"));

local _G = _G
local math_ceil = math.ceil
local string_find = string.find

local UPDATE_INTERVAL = 0.1;
--Fonts
local MAXFONT = 25
local MINFONT = 6

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
}

-- Local Variables
local db, parentFrame
local visibleBars = {
}

--Defaults
local defaults = {
	profile = {
        side = "r",
		scale = 1,
        onlyMine = false,
        filter = false,
        filterTime = 30,
		tips = true,
		fontSize = 18,
        weapon = true,
        weaponForce = true, -- Alwyas save space for weapon buffs
		weaponOrder = "last",
        expMin = 0,
        expSec = 59,
        colors = {
            f = {r=1,g=1,b=1},
            h = {r=255/255,g=1125/255,b=125/255},
            l = {r=255/255,g=165/255,b=0}
        },
    }
}

local OptGetter, OptSetter, ColorGetter, ColorSetter, WeaponHidden, WeaponBuff
do
	local mod = DHUD4_Auras
	function OptGetter(info)
		local key = info[#info];
		return db[key];
	end

	function OptSetter(info, value)
		local key = info[#info];
		db[key] = value;
		mod:Refresh();
	end

    function ColorGetter (info)
        local key1, key2 = info[#info-1], info[#info]
        return db[key1][key2].r, db[key1][key2].g, db[key1][key2].b
    end

    function ColorSetter (info, r, g, b)
        local key1, key2 = info[#info-1], info[#info]
        db[key1][key2].r = r
        db[key1][key2].g = g
        db[key1][key2].b = b
        mod:Refresh()
    end

	function WeaponHidden()
		return not db.weapon;
	end

    WeaponBuff = {["first"] = L["First"], ["last"] = L["Last"], ["bottom"] = L["Bottom"], ["top"] = L["Top"]}
end

--Local Options
local options
local function getOptions()
	if not options then
        --Options table
    	options = {
    		type = "group",
			name = L["Auras Module"],
			arg = MODNAME,
			get = OptGetter,
			set = OptSetter,
            --childGroups  = "tab",
    		args = {
                header = {
                    type = 'description',
                    name = L["The auras module manages player buffs display"],
                    order = 1,
                },
                enabled = {
                    type = "toggle",
                    order = 2,
                    name = L["Enable Auras Module"],
                    get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
                    set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
                },
				general = {
					type = 'group',
					name = L["General"],
					order = 3,
					disabled  = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
					args = {
						side = {
							type = 'select',
							order = 1,
							name = L["Auras Side"],
							desc = L["This setting will override the side setting for the abilities module"],
							values = {["r"] = L["Right"], ["l"] = L["Left"]},
						},
						tips = {
							type = 'toggle',
							order = 2,
							name = L["Show Aura Tips"],
						},
						fontSize = {
							type = 'range',
							order = 3,
							name = L["Font size"],
							min = MINFONT,
							max = MAXFONT,
							step = 1,
						},
                        scale = {
							type = "range",
							order = 4,
							name = L["Auras' scale"],
							min = 0.5,
							max = 1,
							step = 0.05,
						},
                        expDesc = {
							order = 5,
							type = "description",
							name = L["Expiration sets the remaining time on the buff to be displayed by the module"],
						},
						expMin = {
							type = 'range',
							order = 6,
							name = L["Expiration Minutes"],
							min = 0,
							max = 59,
							step = 1,
						},
				        expSec = {
							type = 'range',
							order = 7,
							name = L["Expiration Seconds"],
							min = 0,
							max = 59,
							step = 1,
						},
                        colDesc = {
							order = 8,
							type = "description",
							name = L["By default the buff border starts changing toward <Expiration> when there are 20 seconds remaining."],
						},
						colors = {
							type = 'group',
							name = L["Border Color"],
							order = 9,
							get = ColorGetter,
		                    set = ColorSetter,
                            inline = true,
							args = {
								f = {
									type = 'color',
									name = L["Expiration"],
									order = 1,
								},
								h = {
									type = 'color',
									name = L["Expiration Close"],
									order = 2,
								},
								l = {
									type = 'color',
									name = L["About to Expire"],
									order = 3,
								},
							},
						},
					},
				},
				filters = {
					type = 'group',
					order = 4,
					name = L["Filters"],
					disabled  = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
					args =  {
						desc = {
							order = 0,
							type = "description",
							name = L["Aura filter options"],
						},
						onlyMine = {
							type = 'toggle',
							order = 1,
							name = L["Only Mine"],
							desc = L["Only show own auras"],
						},
				        filter = {
							type = 'toggle',
							order = 2,
							name = L["Filter Auras"],
							desc = L["Filter long duration Auras"],
						},
						filterTime = {
							type = 'range',
							order = 3,
							name = L["Filter Auras duration"],
							desc = L["Filter Auras with a total duration higher than this value (minutes)"],
							min = 10,
							max = 59,
							step = 1,
							disabled = function() return not db.filter end,
						},
					},
				},
				weapons = {
					type = 'group',
					order = 5,
					name = L["Weapons"],
					disabled  = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Weapon enchant display. Weapon auras are displayed in pairs: first two, last two, bottom two or top two slots, regardless of the buffs displayed"],
						},
				        weapon = {
							type = 'toggle',
							order = 1,
							name = L["Weapon Enchants"],
							desc = L["Show/Hide Auras from weapon enchants"],
						},
				        weaponOrder = {
							type = 'select',
							order = 2,
							name = L["Weapon Auras order"],
							desc = L["Choose weapon Auras display order"],
							values = WeaponBuff,
							disabled = WeaponHidden,
						},
					},
				},
            },
        }
    end

    return options;
end

local UpdatePlayerAuras, HidePlayerBuffs, OnUpdateTimer
do
	function UpdatePlayerAuras()
		--DHUD4:Debug("UpdatePlayerAuras");

	    local timeToEvent = 0;
		local showTime = (db.expMin * 60) + db.expSec;
		local showFilter = db.filterTime * 60;
		local i = 1
        local id, timeLeft
        local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable
        local hasMainHandEnchant, mainHandExpiration, hasOffHandEnchant, offHandExpiration
		local weaponSlots = {}
        local frame, frameName
        local frameIcon, frameBorder, frameCooldown

		if db.weapon then
            hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()
            if ( db.weaponOrder == "first" ) then
				weaponSlots[1] = hasMainHandEnchant and {mainHandExpiration, 16} or (hasOffHandEnchant and {offHandExpiration, 17})
                weaponSlots[2] = hasMainHandEnchant and (hasOffHandEnchant and {offHandExpiration, 17})
			elseif ( db.weaponOrder == "last") then
				weaponSlots[15] = hasMainHandEnchant and {mainHandExpiration, 16} or (hasOffHandEnchant and {offHandExpiration, 17})
                weaponSlots[16] = hasMainHandEnchant and (hasOffHandEnchant and {offHandExpiration, 17})
			elseif ( db.weaponOrder == "bottom" ) then
				weaponSlots[1] = hasMainHandEnchant and {mainHandExpiration, 16} or (hasOffHandEnchant and {offHandExpiration, 17})
                weaponSlots[8] = hasMainHandEnchant and (hasOffHandEnchant and {offHandExpiration, 17})
			elseif ( db.weaponOrder == "top" ) then
				weaponSlots[7] = hasMainHandEnchant and {mainHandExpiration, 16} or (hasOffHandEnchant and {offHandExpiration, 17})
                weaponSlots[16] = hasMainHandEnchant and (hasOffHandEnchant and {offHandExpiration, 17})
			end
		end

		for j = 1, 16 do
            if weaponSlots[i] then
                id = weaponSlots[i][2]
                icon = GetInventoryItemTexture("player", weaponSlots[i][2])
                duration = 0
                timeLeft = weaponSlots[i][1]/1000
                 if ( timeLeft > 0 and timeLeft > showTime ) then
					local newtimeToEvent = timeLeft - showTime
					if ( ( newtimeToEvent < timeToEvent ) or timeToEvent == 0 ) then
						--DHUD4:Debug("Main Hand, timeToEvent", newtimeToEvent);
						timeToEvent = newtimeToEvent;
					end
                    icon = false
				end
            else
                for k = i, 40 do
                    name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff("player", k)
                    if ( icon ) then
                        if ( (duration > 0) and not ( db.filter and ( duration > showFilter )) and not ( db.onlyMine and not PLAYER_UNITS[caster] ) ) then
                            timeLeft = expirationTime - GetTime()
                            if ( timeLeft > 0 and timeLeft <= showTime ) then
                                id = k
                                i = k+1
                                break
                            elseif ( timeLeft > 0 )then
                                local newtimeToEvent = timeLeft - showTime
                                if ( ( newtimeToEvent < timeToEvent ) or timeToEvent == 0 ) then
                                    timeToEvent = math_ceil(newtimeToEvent)
                                end
                            end
                        end
                    else
                        break
                    end
                end
            end
            frameName = "DHUD4_PB"..j
            frame = _G[frameName]
            if ( not frame ) then
                frame = DHUD4_Auras:CreateAura(frameName)
                DHUD4_Auras:SetAuraPosition(frame, j)
                frame:EnableMouse(db.tips)
            end
            if ( icon  ) then
                frame:SetID(id)

                -- set the icon
                frameIcon = _G[frameName.."Icon"]
                frameIcon:SetTexture(icon)

                -- Handle cooldowns
                if ( duration > 0 ) then
                    frame.auraTimer = 0
                    frame.left = timeLeft
                    frameCooldown = _G[frameName.."Cooldown"]
                    if ( frameCooldown ) then
                        frameCooldown:SetText(DHUD4:FormatTime(timeLeft))
                    end
                    --frame.text
                    if weaponSlots[i] then
                        frame:SetScript("OnUpdate", function (self, elapsed)
                                self.auraTimer = self.auraTimer + elapsed
                                if self.auraTimer >= UPDATE_INTERVAL then
                                    local _, mainHandExpiration, _, _, offHandExpiration, _ = GetWeaponEnchantInfo()
                                    if self:GetID() == 16 and mainHandExpiration then
                                        self.left = mainHandExpiration/1000
                                    elseif self:GetID() == 17 and offHandExpiration then
                                        self.left = offHandExpiration/1000
                                    end
                                    if self.left < 0 then
                                        self:SetScript("OnUpdate", nil)
                                        return self:Hide()
                                    end
                                    self.auraTimer = 0
                                    DHUD4_Auras:Colorize(self, self.left/20)
                                    self.text:SetText(DHUD4:FormatTime(self.left))
                                    if ( GameTooltip:IsOwned(self) ) then
                                        GameTooltip:SetInventoryItem("player", self:GetID())
                                    end
                                end
                            end)
                    else
                        frame:SetScript("OnUpdate", function (self, elapsed)
                                self.auraTimer = self.auraTimer + elapsed
                                if self.auraTimer >= UPDATE_INTERVAL then
                                    self.left = self.left - self.auraTimer
                                    if self.left < 0 then
                                        self:SetScript("OnUpdate", nil)
                                        return self:Hide()
                                    end
                                    self.auraTimer = 0
                                    DHUD4_Auras:Colorize(self, self.left/20)
                                    self.text:SetText(DHUD4:FormatTime(self.left))
                                    if ( GameTooltip:IsOwned(self) ) then
                                        GameTooltip:SetUnitBuff("player", self:GetID())
                                    end
                                end
                            end)
                    end
                end
                frame:Show()
            else
                frame:Hide()
            end
        end
	    if timeToEvent > 1 then
            --DHUD4:Debug("Aura Timer", timeToEvent)
	        -- Trigger an event for the buff with closest time to playerBuffTimeFilter
	        parentFrame.buffTimer = timeToEvent
			parentFrame.crono = 0
	        parentFrame.buffTimerOn = true
	        parentFrame:SetScript("OnUpdate", OnUpdateTimer)
	    else
	        --DHUD4:Debug("No Timer")
	        parentFrame.buffTimerOn = false
	        parentFrame:SetScript("OnUpdate", nil)
	    end
	end

	function HidePlayerBuffs()
		for i = 1, 16 do
            _G["DHUD4_PB"..i]:Hide()
		end
	end

	function OnUpdateTimer(self, elapsed)
		self.crono = self.crono + elapsed
		if self.crono >= self.buffTimer then
			self:SetScript("OnUpdate", nil)
			self.buffTimerOn = false
            --DHUD4:Debug("Aura Timer Update")
			UpdatePlayerAuras()
		elseif not self.buffTimerOn then
	        self:SetScript("OnUpdate", nil)
		end
	end

end

function DHUD4_Auras:OnInitialize()

    self.db = DHUD4.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
	DHUD4:RegisterModuleOptions(MODNAME, getOptions, L["Auras"])
    self.layout = false
end

function DHUD4_Auras:OnEnable()

	--DHUD4:Debug("DHUD4_Auras:OnEnable")
	if not self:IsEnabled() then return end
    self:Refresh()
    -- Listen to bar pops
	self:RegisterMessage("DHUD4_BAR")
end

function DHUD4_Auras:OnDisable()

    self:UnregisterAllEvents()
	for i = 1, 16 do
		local frame= _G["DHUD4_PB"..i]
		frame:SetScript("OnUpdate", nil)
		frame:Hide()
	end
    if( parentFrame ) then
        parentFrame:SetScript("OnUpdate", nil)
        parentFrame:Hide()
    end
end

function DHUD4_Auras:Refresh()

	--DHUD4:Debug(MODNAME, "Refresh")
	db = self.db.profile
    if (parentFrame) then
        parentFrame:Hide()
    end
    local newParentFrame
    if(db.side == "r") then
        newParentFrame = DHUD4_RightAura
    else
        newParentFrame = DHUD4_LeftAura
    end
    if (not newParentFrame) then
        local name = (db.side == "r") and "DHUD4_RightAura" or "DHUD4_LeftAura"
        newParentFrame = CreateFrame("Frame", name, DHUD4_MainFrame)
        newParentFrame:SetHeight(256)
        newParentFrame:SetWidth(128)
    end
    parentFrame = newParentFrame
    for j = 1, 16 do
        local frameName = "DHUD4_PB"..j
        local frame = _G[frameName]
        if (frame) then
            frame:SetScale(db.scale)
            frame:SetParent(newParentFrame)
            self:SetAuraPosition(frame, j)
            frame:EnableMouse(db.tips)
        end
        frameCooldown = _G[frameName.."Cooldown"]
        if ( frameCooldown ) then
            frameCooldown:SetFont(DHUD4:GetFont(), db.fontSize * DHUD4.GetScale())
        end
    end
    if DHUD4:GetModuleEnabled("DHUD4_Player") then
        local player = DHUD4:GetModule("DHUD4_Player")
        local health, power = player:GetBars()
        visibleBars[health] = true
        visibleBars[power] = true
    end
    self:PlaceAurasFrame()
    if (self.layout) then
        DHUD4_Auras:SetLayout()
    else
        UpdatePlayerAuras()
        self:RegisterEvent("UNIT_AURA")
    end
    parentFrame:Show()
    -- Since the abilities layout depends on the Auras, refresh the Abilities module if enabled
    if(DHUD4:GetModule("DHUD4_Warrior"):IsEnabled()) then
        DHUD4:GetModule("DHUD4_Warrior"):Refresh()
    end
    if(DHUD4:GetModule("DHUD4_Paladin"):IsEnabled()) then
        DHUD4:GetModule("DHUD4_Paladin"):Refresh()
    end
    if(DHUD4:GetModule("DHUD4_Rogue"):IsEnabled()) then
        DHUD4:GetModule("DHUD4_Rogue"):Refresh()
    end
    if(DHUD4:GetModule("DHUD4_DeathKnight"):IsEnabled()) then
        DHUD4:GetModule("DHUD4_DeathKnight"):Refresh()
    end
    if(DHUD4:GetModule("DHUD4_Druid"):IsEnabled()) then
        DHUD4:GetModule("DHUD4_Druid"):Refresh()
    end
end

function DHUD4_Auras:GetSide()
    return db.side
end

function DHUD4_Auras:UNIT_AURA(event, who)
	----self:Debug("UNIT_AURA", who)
	if who == "player" then
		UpdatePlayerAuras()
    end
end

function DHUD4_Auras:DHUD4_BAR(event, bar, visible)
    
    --DHUD4:Debug("Auras:DHUD4_BAR", bar, visible)
    visibleBars[bar] = visible
    if ( string_find(bar, db.side) ) then
        self:PlaceAurasFrame()
    end
end

function DHUD4_Auras:CreateAura(frameName)

    local frame = CreateFrame("Button", frameName, parentFrame)
    frame:SetHeight(26)
    frame:SetWidth(26)
    frame:SetScale(db.scale)
    frame:SetScript("OnEnter", function(self)
            if not ( self:IsVisible() )  or ( self:GetEffectiveAlpha() == 0 ) then
                return
            end
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetUnitAura("player", self:GetID(), "HELPFUL")
        end )
    frame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end )
    local frameIcon = frame:CreateTexture(frameName.."Icon", "BACKGROUND")
    frameIcon:SetBlendMode("BLEND")
    frameIcon:ClearAllPoints()
    frameIcon:SetAllPoints()
    local frameBorder = frame:CreateTexture(frameName.."Border", "BORDER")
    frameBorder:SetTexture(DHUD4:GetCurrentTexture().."auraborder")
    if ( not frameBorder:GetTexture() ) then
        frameBorder:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\auraborder")
    end
    local color = db.colors.f
    frameBorder:SetVertexColor(color.r, color.g, color.b)
    frameBorder:ClearAllPoints()
    frameBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frameBorder:SetHeight(41)
    frameBorder:SetWidth(41)
    frameBorder:SetTexCoord(0, 1, 0, 1)
    frameBorder:SetBlendMode("BLEND")
    frame.border = frameBorder
    local frameCooldown = frame:CreateFontString(frameName.."Cooldown", "OVERLAY")
    frameCooldown:SetFont(DHUD4:GetFont(), db.fontSize * DHUD4.GetScale())
    frameCooldown:ClearAllPoints()
    frameCooldown:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frameCooldown:SetWidth(41)
    frameCooldown:SetVertexColor(color.r, color.g, color.b)
    frame.text = frameCooldown
    return frame
end

function DHUD4_Auras:SetAuraPosition(frame, id)

    local x, y, yPos, point
	local xCol = 0
    if(id < 9) then
        yPos = (-25 + (34 * id))
        y = (-25 + (34 * id))*db.scale
    else
        xCol = (db.side == "l") and -35 or 35;
        yPos = (-25 + (34 * (id-8)))
        y = (-25 + (34 * (id-8)))*db.scale
    end
    if ( db.side == "l" ) then
        -- y = 0,0014x^2 - 0,3482x - 20,468
        xDev = - 30 - 6/db.scale
        x = ((0.0014/db.scale)*y^2 - (0.3482/db.scale)*y - (20.468/db.scale))
        point = "LEFT"
    else
        -- y = -0,0014x^2 + 0,3482x + 20,468
        xDev = 30 + 6/db.scale
        x = (-(0.0014/db.scale)*y^2 + (0.3482/db.scale)*y + (20.468/db.scale))
        point = "RIGHT"
    end
    frame:ClearAllPoints()
	frame:SetPoint(point, parentFrame, "BOTTOM", x + xDev + xCol, yPos)
end

function DHUD4_Auras:PlaceAurasFrame()

    local b3, b4, b5 = "f"..db.side.."3", "f"..db.side.."4", "f"..db.side.."5"
    local dis = 156 + math.max((visibleBars[b3] and 15 or 0), (visibleBars[b4] and 30 or 0),  (visibleBars[b5] and 45 or 0)) + DHUD4:GetFrameSpacing()
    local anchorPoint = "RIGHT"
    if (db.side == "l") then
        dis = dis * -1
        anchorPoint = "LEFT"
    end
    parentFrame:ClearAllPoints()
    parentFrame:SetPoint(anchorPoint, DHUD4_MainFrame, "CENTER", dis, 0)
end


--[[
    Colorize: Get the bar color according to percent
        returns:
            r, g, b and hex values for the calculated color.
]]
function DHUD4_Auras:Colorize(frame, percent)

    local r, g, b, diff
    local threshold1, threshold2  = 0.6, 0.2
    if (percent > 1) then
        percent = 1
    end
    if ( percent <= threshold2 ) then
        r, g, b = db.colors.l.r, db.colors.l.g, db.colors.l.b
    elseif ( percent <= threshold1) then
        diff = 1 - (percent - threshold2) / (threshold1 - threshold2)
        r = db.colors.h.r - (db.colors.h.r - db.colors.l.r) * diff
        g = db.colors.h.g - (db.colors.h.g - db.colors.l.g) * diff
        b = db.colors.h.b - (db.colors.h.b - db.colors.l.b) * diff
    elseif ( percent < 1) then
        diff = 1 - (percent - threshold1) / (1 - threshold1)
        r = db.colors.f.r - (db.colors.f.r - db.colors.h.r) * diff
        g = db.colors.f.g - (db.colors.f.g - db.colors.h.g) * diff
        b = db.colors.f.b - (db.colors.f.b - db.colors.h.b) * diff
    else
        r, g, b = db.colors.f.r, db.colors.f.g, db.colors.f.b
    end
    --self:Debug("colorize", r, g, b)
    if (r < 0) then r = 0; end
    if (r > 1) then r = 1; end
    if (g < 0) then g = 0; end
    if (g > 1) then g = 1; end
    if (b < 0) then b = 0; end
    if (b > 1) then b = 1; end
    frame.border:SetVertexColor(r, g, b)
    frame.text:SetVertexColor(r, g, b)
end

function DHUD4_Auras:SetLayout()

    local frameName, frame, frameIcon
    self.layout = true
    self:UnregisterEvent("UNIT_AURA")
    for j = 1, 16 do
        frameName = "DHUD4_PB"..j
        frame = _G[frameName]
        if ( not frame ) then
            frame = self:CreateAuraFrame(frameName)
            self:SetAuraPosition(frame, j)
        end
        -- set the icon
        frameIcon = _G[frameName.."Icon"]
        frameIcon:SetTexture("Interface\\AddOns\\DHUD4\\icon")
        -- set the text
        frameCooldown = _G[frameName.."Cooldown"]
        frameCooldown:SetText(j)
        frame:EnableMouse(false)
        frame:SetScript("OnUpdate", nil)
        frame:Show()
    end

end

function DHUD4_Auras:EndLayout()

    self.layout = false
    self:Refresh()
end
