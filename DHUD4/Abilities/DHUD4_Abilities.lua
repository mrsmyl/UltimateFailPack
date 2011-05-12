--[[
DHUD4_Abilities.lua $Rev: 81 $
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
local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4")
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4")

local string_find = string.find
local math_ceil = math.ceil
local math_floor = math.floor
local _G = _G

local RUNETYPE_BLOOD = 1;
local RUNETYPE_UNHOLY = 2;
local RUNETYPE_FROST = 3;
local RUNETYPE_DEATH = 4;

local RUNE_TEXTURES = {
	[RUNETYPE_BLOOD] = "Runes\\blood",
	[RUNETYPE_UNHOLY] = "Runes\\unholy",
	[RUNETYPE_FROST] = "Runes\\frost",
	[RUNETYPE_DEATH] = "Runes\\death",
}

local UPDATE_INTERVAL = 0.5

local Abilities = {
    defaults = {
        profile = {
            side = "l",
            scale = 1,
            fontSize = 10,
            tips = true,
            vehiCombos = true,
            colors = {
                border = {
                    f = {r=1,g=1,b=1},
                    h = {r=255/255,g=1125/255,b=125/255},
                    l = {r=255/255,g=165/255,b=0}
                },
            },
        },
    },
}
DHUD4.Abilities = Abilities

local visibleBars = {
}

local colors
local options
function Abilities:GetOptions()
	if not options then
        --Options table
    	options = {
    		type = "group",
			name = L["Abilities Module"],
            --childGroups = "tab",
			args = {
                header = {
                    order = 1,
                    type = 'description',
                    name = L["The abilities module manages specific class abilities tracking."],
                },
                enabled = {
                    order = 2,
                    type = "toggle",
                    name = L["Enable Abilities"],
                    get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
                    set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
                },
				general = {
					order = 3,
					type = 'group',
					name = L["General"],
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Configure general functionality"],
						},
						side = {
							order = 1,
							type = 'select',
							name = L["Abilities Side"],
							desc = L["This setting will only be available if the Auras Module is disabled"],
							values = {["r"] = L["Right"], ["l"] = L["Left"]},
							disabled = function() return DHUD4:GetModuleEnabled("DHUD4_Auras"); end,
						},
						tips = {
							order = 2,
							type = 'toggle',
							name = L["Show Abilities tips"],
						},
						fontSize = {
							order = 3,
							type = 'range',
							name = L["Font size"],
							min = 6,
							max = 25,
							step = 1,
						},
                        scale = {
							order = 4,
							type = "range",
							name = L["Set Abilities' scale"],
							min = 0.5,
							max = 1,
							step = 0.05,
						},
						colors = {
							order = 5,
							type = 'group',
							name = L["Border Color"],
                            inline = true,
							args = {
								f = {
									type = 'color',
									name = L["Unavailable"],
									order = 1,
								},
								h = {
									type = 'color',
									name = L["Half Time"],
									order = 2,
								},
								l = {
									type = 'color',
									name = L["Ready"],
									order = 3,
								},
							},
						},

					},
				},
            },
		}
	end
	return options
end

-- On update event for abilities
local function OnUpdateAura(self, elapsed)

    self.auraTimer = self.auraTimer + elapsed
    if self.auraTimer >= UPDATE_INTERVAL then
        local timeLeft = 0;
        self.left = self.left - self.auraTimer
        if self.left <= 0 then
            self.id = 0
            self.hasAura = false
            self:SetScript("OnUpdate", nil)
            self:SetScript("OnEnter", nil)
            return self:SetAlpha(0)
        end
        self.auraTimer = 0
        if (self.timer) then
            frameText = _G[self:GetName().."Timer"]
            frameText:SetText(DHUD4:FormatTime(self.left));
        end
        Abilities:Colorize(self.id)
        local w = frameText:GetStringWidth() + 10;
        frameText:SetWidth(w);
        if ( GameTooltip:IsOwned(self) ) then
            GameTooltip:SetUnitAura("target", self.id, self.filter);
        end
    end
end

local function OnUpdateRune(self, elapsed)
    if self.flash then
        local fadeAlpha = _G[self:GetName().."Flash"]:GetAlpha() + self.alphaStep
        if fadeAlpha > 1 then
            self.alphaStep = -0.1
        elseif fadeAlpha > 0 then
            _G[self:GetName().."Flash"]:SetAlpha(fadeAlpha)
        else
            self.flash = false
            self.ready = false
            self:SetScript("OnUpdate", nil)
            _G[self:GetName().."Flash"]:Hide()
            --DHUD4:Debug("Rune Flash Hide", self.id);
        end
    end
    if ( self.ready ) then
        --DHUD4:Debug("Rune Ready", self.id);
        self.left = 10
        self.duration = 10
        Abilities:Colorize(self.id)
        --_G[self:GetName().."Timer"]:Hide()
        if(not self.flash) then
            --Flash
            self.flash = true
            self.alphaStep = 0.1
            _G[self:GetName().."Flash"]:SetAlpha(0)
            _G[self:GetName().."Flash"]:Show()
            _G[self:GetName().."Flash"].fadeAlpha = 0
        end
    else
        self.auraTimer = self.auraTimer + elapsed
        if self.auraTimer >= UPDATE_INTERVAL then
            local timeLeft = 0;
            self.left = self.left - self.auraTimer
            if self.left <= 0 then
                self.ready = true
            else
                self.auraTimer = 0
                Abilities:Colorize(self.id)
            end
        end
    end
end


function Abilities:PlaceAbilitiesFrame()

    local b3, b4, b5 = "f"..self.side.."3", "f"..self.side.."4", "f"..self.side.."5"
    local dis = 156 + math.max((visibleBars[b3] and 15 or 0), (visibleBars[b4] and 30 or 0),  (visibleBars[b5] and 45 or 0)) + DHUD4:GetFrameSpacing()
    --dis = dis/self.scale + 25*self.scale
    local anchorPoint = "RIGHT"
    if (self.side == "l") then
        dis = dis * -1
        anchorPoint = "LEFT"
    end
    self.parent:ClearAllPoints()
    self.parent:SetPoint(anchorPoint, DHUD4_MainFrame, "CENTER", dis, 0)
end

function Abilities:_Refresh()

    if (self.parent) then
        self.parent:Hide()
    end
    local newParentFrame = (self.side == "r") and DHUD4_RightAbilities or DHUD4_LeftAbilities
    if (not newParentFrame) then
        local name = (self.side == "r") and "DHUD4_RightAbilities" or "DHUD4_LeftAbilities"
        newParentFrame = CreateFrame("Frame", name, DHUD4_MainFrame)
        newParentFrame:SetHeight(256)
        newParentFrame:SetWidth(128)
    end
    for i = 1, 12 do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        local frameTimer = _G[frameName.."Timer"]
        if (frame) then
            frame:SetScale(self.scale)
            if (self.parent ~= newParentFrame) then
                frame:SetParent(newParentFrame)
            end
        end
        if ( frameTimer ) then
            frameTimer:SetFont(DHUD4:GetFont(), self.db.profile.fontSize * DHUD4.GetScale())
        end
    end
    self.parent = newParentFrame
    if DHUD4:GetModuleEnabled("DHUD4_Player") then
        local player = DHUD4:GetModule("DHUD4_Player")
        local health, power = player:GetBars()
        visibleBars[health] = true
        visibleBars[power] = true
    end
    self:PlaceAbilitiesFrame()
    self.parent:Show()
    colors = self.db.profile.colors.border
end

--[[
        CreateFrame: Creates the frame for an ability
        arguments:
            id: The id (number) of the ability, between 1 and 12.
        returns:
            option setting in DB
    ]]
function Abilities:CreateFrame(id)

    local frameName = "DHUD4_A"..id
    local frame, frameTexture, frameBorder, frameTimer, frameCooldown
    frame = CreateFrame("Button", frameName, self.parent)
    frame:SetHeight(26)
    frame:SetWidth(26)
    frame:SetScale(self.scale)
    frameTexture = frame:CreateTexture(frameName.."Texture", "BORDER");
    frameTexture:SetVertexColor(1, 1, 1);
    frameTexture:SetPoint("CENTER", frame, "CENTER", 0, 0);
    frameTexture:SetHeight(26);
    frameTexture:SetWidth(26);
    frameTexture:SetTexCoord(0, 1, 0, 1);
    frameBorder = frame:CreateTexture(frameName.."Border", "ARTWORK")
    frameBorder:SetTexture(DHUD4:GetCurrentTexture().."auraborder")
    if ( not frameBorder:GetTexture() ) then
        frameBorder:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\auraborder")
    end
    frameBorder:SetVertexColor(1, 1, 1)
    frameBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frameBorder:SetHeight(26*1.6)
    frameBorder:SetWidth(26*1.6)
    frameBorder:SetTexCoord(0, 1, 0, 1)
    frameBorder:SetBlendMode("BLEND")
    frameBorder:Hide()
    frameTimer = frame:CreateFontString(frameName.."Timer", "OVERLAY")
    frameTimer:SetFontObject(GameFontHighlightSmall)
    frameTimer:ClearAllPoints()
    frameTimer:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frameTimer:SetText("")
    frameTimer:SetJustifyH("CENTER")
    frameTimer:SetJustifyV("CENTER")
    frameTimer:SetWidth(26*2)
    frameTimer:Hide()
    frameCooldown = CreateFrame("Cooldown", frameName.."Cooldown",frame)
    frameCooldown:SetAllPoints(frame)
    frameCooldown:SetFrameStrata("LOW")
    frameCooldown:SetDrawEdge(true)
    frameCooldown:Hide()
    return frame
end

function Abilities:CreateFrameFlash(id, texture)

    local frameName = "DHUD4_A"..id
    local frame = _G[frameName]
    local flash
    if ( frame ) then
        flash = frame:CreateTexture(frameName.."Flash", "OVERLAY")
        flash:SetTexture(DHUD4:GetCurrentTexture()..texture)
        if ( not flash:GetTexture() ) then
            flash:SetTexture("Interface\\AddOns\\DHUD4\\Textures\\DHUD\\"..texture)
        end
        flash:SetPoint("CENTER", frame, "CENTER", 0, 0)
        flash:SetHeight(26*1.6)
        flash:SetWidth(26*1.6)
        flash:SetTexCoord(0, 1, 0, 1)
        flash:SetBlendMode("ADD")
        flash:SetAlpha(0)
     end
     return flash
end

function Abilities:SetAbilitiesPosition(frame, pos, runeLayout)

    local x, y, yPos, point
    local parent = self.parent
	local xCol = 0
    --DHUD4:Debug("Abilities:SetAbilitiesPosition", frame:GetName(), pos);
    if (not runeLayout or (runeLayout == "rr") or (runeLayout == "bu") or (runeLayout == "ha")) then
        if (runeLayout == "bu") then
            -- Same equation, two columns
            if ( pos%2 ~= 0 ) then
                yPos = (-25 + (34 * math_ceil(pos/2)))
                y = (-25 + (34 *  math_ceil(pos/2)))*self.scale
                xCol = 0
            else
                yPos = (-25 + (34 * (pos/2)))
                y = (-25 + (34 * (pos/2)))*self.scale
                xCol = (self.side == "l") and -35 or 35;
            end
        elseif ( runeLayout == "ha" ) then
            -- Same equation, three columns at middle way
            if ( pos%2 ~= 0 ) then
                yPos = (-25 + (34 * 4))
                y = (-25 + (34 * 4))*self.scale
                xCol = math_floor(pos/2) * ( (self.side == "l") and -35 or 35 );
            else
                yPos = (-25 + (34 * 5))
                y = (-25 + (34 * 5))*self.scale
                xCol = ( (pos/2) - 1 ) * ( (self.side == "l") and -35 or 35 );
            end
            if ( self.side == "l" ) then
                x = -38/self.scale;
            else
                x = 38/self.scale;
            end
        else
            yPos = (-25 + (34 * pos))
            y = (-25 + (34 * pos))*self.scale
        end
        if ( self.side == "l" ) then
            -- y = 0,0014x^2 - 0,3482x - 20,468
            xDev = - 30 - 6/self.scale
            x = ((0.0014/self.scale)*y^2 - (0.3482/self.scale)*y - (20.468/self.scale))
            point = "LEFT"
        else
            -- y = -0,0014x^2 + 0,3482x + 20,468
            xDev = 30 + 6/self.scale
            x = (-(0.0014/self.scale)*y^2 + (0.3482/self.scale)*y + (20.468/self.scale))
            point = "RIGHT"
        end
    elseif ( runeLayout == "c" ) then
        xDev = 0;
        yPos = 30/self.scale;
        parent = "DHUD4_MainFrame"
        point = "CENTER"
        if ( self.side == "l" ) then
            xCol = (34 * (pos-1));
            x = -85;
        else
            xCol = (-34 * (pos-1));
            x = 85;
        end
    end
    frame:ClearAllPoints()
	frame:SetPoint(point, parent, "BOTTOM", x + xDev + xCol, yPos)
end


function Abilities:HideAll()

    --DHUD4:Debug("Abilities:HideAbilities");
    for i = 1, 12 do
        frameName = "DHUD4_A"..i
        frame = _G[frameName]
        if ( frame ) then
            frame:SetAlpha(0)
            frame:SetScript("OnUpdate", nil)
        end
    end
end

function Abilities:HideRange(from, to)

    --DHUD4:Debug("Abilities:HideAbilities");
    for i = from, to do
        frameName = "DHUD4_A"..i
        frame = _G[frameName]
        if ( frame ) then
            frame:SetAlpha(0)
            frame:SetScript("OnUpdate", nil)
            frame:SetScript("OnLeave", nil)
            frame:SetScript("OnUpdate", nil)
        end
    end
end

--[[
    ColorizeBorder: Set the color of an ability frame border and it's text
        arguments:
            id: The id (number) of the ability, between 1 and 12.
            text: boolean, also colorize text
]]
function Abilities:Colorize(id)

    --DHUD4:Debug("Abilities:Colorize", id, colors)
    local frameName = "DHUD4_A"..id
    local frame = _G[frameName]
    if ( frame ) then
        local r, g, b, diff
        local percent = frame.left / frame.duration
        local threshold1, threshold2  = 0.6, 0.2
        if ( percent <= threshold2 ) then
            r, g, b = colors.l.r, colors.l.g, colors.l.b
        elseif ( percent <= threshold1) then
            diff = 1 - (percent - threshold2) / (threshold1 - threshold2)
            r = colors.h.r - (colors.h.r - colors.l.r) * diff
            g = colors.h.g - (colors.h.g - colors.l.g) * diff
            b = colors.h.b - (colors.h.b - colors.l.b) * diff
        elseif ( percent < 1) then
            diff = 1 - (percent - threshold1) / (1 - threshold1);
            r = colors.f.r - (colors.f.r - colors.h.r) * diff
            g = colors.f.g - (colors.f.g - colors.h.g) * diff
            b = colors.f.b - (colors.f.b - colors.h.b) * diff
        else
            r, g, b = colors.f.r, colors.f.g, colors.f.b
        end
        --self:Debug("colorize", r, g, b)
        if (r < 0) then r = 0; end
        if (r > 1) then r = 1; end
        if (g < 0) then g = 0; end
        if (g > 1) then g = 1; end
        if (b < 0) then b = 0; end
        if (b > 1) then b = 1; end
        frameBorder = _G[frameName.."Border"]
        frameBorder:SetVertexColor(r, g, b)
        --frameText = _G[frameName.."Timer"]
        --frameText:SetTextColor(r, g, b)
    end
end

function Abilities:DHUD4_BAR(event, bar, visible)

    --DHUD4:Debug("Abilities:DHUD4_BAR", bar, visible)
    visibleBars[bar] = visible
    if ( string_find(bar, self.side) ) then
        self:PlaceAbilitiesFrame()
    end
end


function Abilities:SetBorderColors(c)
    colors = c
end

function Abilities:updateCountTextures(count, icon, filter, tips, duration, expirationTime)

    --DHUD4:Debug("Abilities:updateCountTextures", count, icon, filter, tips)
    for i = 1, count do
        frameName = "DHUD4_A"..i
        frame = _G[frameName]
        if (frame) then
            frame:EnableMouse(tips)
            frameTexture = _G[frameName.."Texture"]
            if (icon) then
                frameTexture:SetTexture(icon)
            end
            if (filter) then
                frame.filter = filter
                frame.duration = duration
                frame.hasAura = true
                frame.auraTimer = UPDATE_INTERVAL
                frame.id = i
                frame.left = expirationTime - GetTime();
                Abilities:Colorize(i)
                frame:SetScript("OnUpdate", OnUpdateAura);
                if ( tips  ) then
                    frame:SetScript("OnEnter", function(self)
                            if not self:IsVisible() or ( self:GetEffectiveAlpha() == 0 ) then
                                return;
                            end
                            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
                            GameTooltip:SetUnitAura("target", self.id, self.filter);
                        end )
                    frame:SetScript("OnLeave", function()
                            GameTooltip:Hide();
                        end )
                end
            end
            frame:SetAlpha(1)
        end
    end
end

function Abilities:SetTimer(id)

    local frameName = "DHUD4_A"..id
    local frame = _G[frameName]
    if ( frame ) then
        frame.timer = true
        local frameTimer = _G[frameName.."Timer"]
        if ( frameTimer ) then
            frameTimer:SetText(DHUD4:FormatTime(frame.left))
            local w = frameTimer:GetStringWidth() + 10
            frameTimer:SetWidth(w)
            frameTimer:Show()
        end
    end
end

function Abilities:SetUpCombos()

    for i = 1, 5 do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        if ( not frame ) then
            frame = self:CreateFrame(i)
            self:SetAbilitiesPosition(frame, i)
        end
        local frameTexture = _G[frameName.."Texture"]
        frameTexture:SetTexture(DHUD4:GetCurrentTexture().."Abilities\\c"..i)
        if ( not frameTexture:GetTexture() ) then
            frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Abilities\\c"..i)
        end
        frameTexture:Show()
        _G[frameName.."Border"]:Show()
        frame:Show()
        frame:SetAlpha(0)
    end
end

function Abilities:UpdateCombos(who)

    --DHUD4:Debug("Abilities:UpdateCombos", who)
    local points = GetComboPoints(who, "target")
    if (points > 0) then
        self:updateCountTextures(points)
    else
        self:HideRange(1, 5)
    end
end


function Abilities:SetUpBuffs(maxBuffs)

    for i = 1, maxBuffs do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        if ( not frame ) then
            frame = self:CreateFrame(i)
        end
        self:SetAbilitiesPosition(frame, i)
        _G[frameName.."Texture"]:Show()
        _G[frameName.."Border"]:Show()
        frame:Show()
        frame:SetAlpha(0)
    end
end

function Abilities:UpdateBuff(buff, timer, tips, texture)

    --DHUD4:Debug("Abilities:UpdateBuff", buff)
    local r, g, b, hex, button, timeLeft;
    local name, icon, count, duration, expirationTime, unitCaster;
    name, _, icon, count, _, duration, expirationTime, unitCaster = UnitBuff("target", buff, nil, "PLAYER");
    if ( name ) then
        self:updateCountTextures(count, icon, "HELPFUL", tips, duration, expirationTime)
        if (timer) then
            self:SetTimer(1)
        end
    else
        self:HideRange(1, 5)
    end
end

function Abilities:UpdateDebuff(buff, timer, tips, texture)


    local r, g, b, hex, button, timeLeft;
    local name, icon, count, duration, expirationTime, unitCaster;
    name, _, icon, count, _, duration, expirationTime, unitCaster = UnitDebuff("target", buff, nil, "PLAYER");
    if ( name ) then
        self:updateCountTextures(count, icon, "HARMFUL", tips, duration, expirationTime)
        if (timer) then
            self:SetTimer(1)
        end
    else
        self:HideRange(1, 5)
    end
end

function Abilities:SetUpRunes(runeLayout, timer)

    for i = 1, 6 do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        if ( not frame ) then
            frame = self:CreateFrame(i)
            self:CreateFrameFlash(i, "Runes\\runeFlash")
        end
        self:SetAbilitiesPosition(frame, i, runeLayout)
        local runeType = GetRuneType(i)
        frame.runeType = runeType
        local _, duration = GetRuneCooldown(i)
        frame.left = duration
        frame.duration = duration
        Abilities:Colorize(i)
        frame.rune = i
        frame.id = i
        frame.ready = false
        local frameTexture = _G[frameName.."Texture"]
        frameTexture:SetTexture(DHUD4:GetCurrentTexture()..RUNE_TEXTURES[runeType])
        if ( not frameTexture:GetTexture() ) then
            frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Abilities\\"..RUNE_TEXTURES[runeType])
        end
        frameTexture:Show()
        _G[frameName.."Border"]:Show()
        if (timer) then
            frame.timer = timer
            local frameTimer = _G[frameName.."Timer"]
            if ( frameTimer ) then
                frameTimer:SetFont(DHUD4:GetFont(), self.db.profile.fontSize * DHUD4.GetScale())
            end
        end
        frame:Show()
    end
end

function Abilities:UpdateRune(rune, isEnergize, hideOnCD, runeLayout, rr)

    --DHUD4:Debug("Abilities:UpdateRune", rune, isEnergize, hideOnCD, runeLayout, rr);
    local id
    local moved = 0
    for i = 1, 6 do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        frame.moved = false
        if (frame.rune == rune) then
            local start, duration, runeReady = GetRuneCooldown(rune);
            if ( not runeReady ) then
                if ( hideOnCD ) then
                    frame:Hide()
                    frame:SetScript("OnUpdate", nil)
                else
                    frameTexture = _G[frameName.."Texture"]
                    frameTexture:SetTexture(DHUD4:GetCurrentTexture()..RUNE_TEXTURES[frame.runeType])
                    if ( not frameTexture:GetTexture() ) then
                        frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD"..RUNE_TEXTURES[frame.runeType])
                    end
                    frame.left = duration
                    frame.duration = duration
                    frame.auraTimer = UPDATE_INTERVAL
                    self:Colorize(i)
                    -- Handle cooldowns
                    frameCooldown = _G[frameName.."Cooldown"]
                    if start then
                        CooldownFrame_SetTimer(frameCooldown, start, duration, 1);
                    end
                    frame:SetScript("OnUpdate", OnUpdateRune)
                end
                if (rr) then
                    moved = frame.id
                    frame.moved = true
                    frame.id = 6
                    self:SetAbilitiesPosition(frame, frame.id, runeLayout)
                end
            else
                frame.ready = true
                frameCooldown = _G[frameName.."Cooldown"]
                frameCooldown:Hide();
                if (hideOnCD) then
                    frame:Show()
                else
                    frame.left = 1
                    frame.duration = 1
                    Abilities:Colorize(i)
                end
            end
        end
	end
    if (rr and (moved > 0)) then
        for i = 1, 6 do
            local frame = _G["DHUD4_A"..i]
            if ((frame.id > moved) and (not frame.moved)) then
                frame.id = frame.id - 1
                self:SetAbilitiesPosition(frame, frame.id, runeLayout)
            end
        end
    end
end

function Abilities:UpdateRuneType(rune)

    local frameName = "DHUD4_A"..rune
    local frame = _G[frameName]
    local runeType = GetRuneType(rune)
    frame.runeType = runeType
    frameTexture = _G[frameName.."Texture"]
    frameTexture:SetTexture(DHUD4:GetCurrentTexture()..RUNE_TEXTURES[frame.runeType])
    if ( not frameTexture:GetTexture() ) then
        frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD"..RUNE_TEXTURES[frame.runeType])
    end
    if runeType == 4 and frame:IsVIsible() then
		--Flash
		frame.flash = true
		frame.alphaStep = 0.1
		local flash = _G[frameName.."Flash"]
		flash:SetAlpha(0)
		flash:Show()
		flash.fadeAlpha = 0
		frame:SetScript("OnUpdate", OnUpdateRune);
	end
end

function Abilities:SetupHolyPower()

    local pulse, hpAlphaShow, hpAlphaHide, flashTexture, frameTexture
    for i = 1, MAX_HOLY_POWER do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        if ( not frame ) then
            frame = self:CreateFrame(i)
        end
        self:SetAbilitiesPosition(frame, i)
        frameTexture = _G[frameName.."Texture"]
        frameTexture:SetTexture(DHUD4:GetCurrentTexture().."Abilities\\hp"..i)
        if ( not frameTexture:GetTexture() ) then
            frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Abilities\\hp"..i)
        end
        flashTexture = self:CreateFrameFlash(i, "Abilities\\hpf"..i)
        pulse = flashTexture:CreateAnimationGroup("DHUD4_HolyGlow"..i)
        pulse:SetScript("OnFinished", function(self)
            if not self.stopPulse then
                self:Play()
            end
        end)
        flashTexture.pulse = pulse
        local hpAlphaShow =  pulse:CreateAnimation("Alpha", "DHUD4_hpAlphaShow"..i)
        hpAlphaShow:SetChange(1)
        hpAlphaShow:SetDuration(0.5)
        hpAlphaShow:SetOrder(1)
        local hpAlphaHide =  pulse:CreateAnimation("Alpha", "DHUD4_hpAlphaHide"..i)
        hpAlphaHide:SetChange(-1)
        hpAlphaHide:SetStartDelay(0.3)
        hpAlphaHide:SetDuration(0.6)
        hpAlphaHide:SetOrder(2)
        local frameTexture = _G[frameName.."Texture"]
        if (i<MAX_HOLY_POWER) then
            frameTexture:SetHeight(52)
            frameTexture:SetWidth(52)
            flashTexture:SetHeight(52)
            flashTexture:SetWidth(52)
        else
            frameTexture:SetHeight(26)
            frameTexture:SetWidth(26)
            flashTexture:SetHeight(26)
            flashTexture:SetWidth(26)
        end
        _G[frameName.."Border"]:Hide()
        frame:Show()
        frame:SetAlpha(0)
    end
end

function Abilities:UpdatePower(class)

    local count
    if(class == "PALADIN") then
        count = UnitPower( "player", SPELL_POWER_HOLY_POWER )
        if(count > 0) then
            self:updateCountTextures(count)
        else
            self:HideRange(1,3)
        end
        if count == MAX_HOLY_POWER then
            DHUD4_A1Flash.pulse.stopPulse = false
            DHUD4_A2Flash.pulse.stopPulse = false
            DHUD4_A3Flash.pulse.stopPulse = false
            DHUD4_A1Flash.pulse:Play()
            DHUD4_A2Flash.pulse:Play()
            DHUD4_A3Flash.pulse:Play()
        else
            DHUD4_A1Flash.pulse.stopPulse = true
            DHUD4_A2Flash.pulse.stopPulse = true
            DHUD4_A3Flash.pulse.stopPulse = true
        end
    end
end



function Abilities:_SetLayout(count, showText, layout)

    --DHUD4:Debug("Abilities:_SetLayout", count, showText)
    for i = 1, count do
        local frameName = "DHUD4_A"..i
        local frame = _G[frameName]
        if (frame) then
            -- set the icon
            local frameTexture = _G[frameName.."Texture"]
            frameTexture:SetTexture("Interface\\AddOns\\DHUD4\\icon")
            if (showText) then
                -- set the text
                local frameTimer = _G[frameName.."Timer"]
                frameTimer:SetText(j)
            end
            self:SetAbilitiesPosition(frame, i, layout)
            frame:SetAlpha(1)
        end
    end
end
