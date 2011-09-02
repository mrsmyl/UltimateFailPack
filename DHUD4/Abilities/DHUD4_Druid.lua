--[[
DHUD4_Druid.lua
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

local MODNAME = "DHUD4_Druid"
local DHUD4_Druid = DHUD4:NewModule(MODNAME, DHUD4.Abilities, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 105 $"):match("%d+"))


local string_match = string.match
local string_len = string.len
local string_find = string.find

local db
local OptGetter, OptSetter, ColorGetter, ColorSetter, druidTags
do
	local mod = DHUD4_Druid
	function OptGetter(info)
		local key = info[#info]
		return db[key]
	end

	function OptSetter(info, value)
		local key = info[#info]
		db[key] = value
		mod:Refresh()
	end

    function ColorGetter (info)
        local key1, key2, key3 = info[#info-2], info[#info-1], info[#info]
        return db[key1][key2][key3].r, db[key1][key2][key3].g, db[key1][key2][key3].b
    end

    function ColorSetter (info, r, g, b)
        local key1, key2, key3 = info[#info-2], info[#info-1], info[#info]
        db[key1][key2][key3].r = r
        db[key1][key2][key3].g = g
        db[key1][key2][key3].b = b
        mod:Refresh();
    end

	druidManaTags = {
		["[FractionalDruidMP] ([PercentDruidMP:Percent])"] = L["Current/Max (Percent%)"],
		["[FractionalDruidMP]"] = L["Current/Max"],
		["[DruidMP] ([PercentMP:Percent])"] = L["Current (Percent%)"],
		["[PercentDruidMP:Percent]"] = L["Percent%"],
		["[DruidMP]"] = L["Current"]
	}
end


local defaults = {
    profile = {
        combos = true,
        lacerates = true,
        laceratesTimer  = true,
        lifeblooms  = true,
        lifebloomsTimer  = true,
        mana = false,
		manaBar = "fr2d",
		manaBarText = true,
        manaTextSize = 10,
		manaTextStyle = "[FractionalDruidMP] ([PercentDruidMP:Percent])",
		manaCustomTextStyle = "",
        eclipse  = true,
        eclipseBar = "fl2d",
		eclipseBarText = true,
        eclipseTextSize = 10,
        eclipseShowPercent = true,
		colors = {
            mana = {
                f = {r=0,g=1,b=1},
                h = {r=0,g=0,b=1},
                l = {r=1,g=0,b=1},
            },
            lunar = {
                f = {r=0.04,g=0.24,b=0.44},
                h = {r=0.24,g=0.37,b=0.50},
                l = {r=0.39,g=0.49,b=0.59},
            },
            solar = {
	            f = {r=0.98,g=0.92,b=0.07},
	            h = {r=0.82,g=0.79,b=0.19},
	            l = {r=0.92,g=0.88,b=0.58}
	        },
        }
   }
}

--Local Options
local options, mana
local function getOptions()
    if not options then
        --Options table
        options = DHUD4_Druid:GetOptions()
        -- Add function calls
        options.arg = MODNAME
        options.get = OptGetter
        options.set = OptSetter
        options.args.enabled.get = function() return DHUD4:GetModuleEnabled(MODNAME) end
        options.args.enabled.set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end
        options.args.general.disabled = function() return not DHUD4:GetModuleEnabled(MODNAME) end
        options.args.general.args.colors.get = function (info)
                                    local key = info[#info]
                                    return db.colors.border[key].r, db.colors.border[key].g, db.colors.border[key].b
                                end
		options.args.general.args.colors.set = function (info, r, g, b)
                                    local key = info[#info]
                                    db.colors.border[key].r = r
                                    db.colors.border[key].g = g
                                    db.colors.border[key].b = b
                                    DHUD4_Druid:Refresh()
                                end
        -- Add class specifics
    	options.args.class = {
            order = 4,
            type = 'group',
            name = L["Druid"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            args = {
                combos = {
                    type = 'toggle',
                    order = 1,
                    name = L["Combos"],
                    desc = L["Track druid combo points"],
                    hidden = false,
                },
                lacerates = {
                    type = 'toggle',
                    order = 2,
                    name = L["Lacerates"],
                    desc = L["Track druid lacerates"],
                    hidden = false,
                },
                laceratesTimer = {
                    type = 'toggle',
                    order = 3,
                    name = L["Lacerates Timer"],
                    desc = L["Track Druid lacerates expiration"],
                    disabled = timerDisabled,
                    hidden = false,
                },
                lifeblooms = {
                    type = 'toggle',
                    order = 4,
                    name = L["Lifebloom"],
                    desc = L["Track druid lifebloom"],
                    hidden = false,
                },
                lifebloomsTimer = {
                    type = 'toggle',
                    order = 5,
                    name = L["Lifebloom Timer"],
                    desc = L["Track Druid lifebloom expiration"],
                    disabled = timerDisabled,
                    hidden = false,
                },
                manaTracking = {
                    order = 6,
                    type = 'header',
                    name = L["Druid Mana Tracking"],
                },
                mana = {
                    type = 'toggle',
                    order = 7,
                    name = L["Druid Mana"],
                    desc = L["Track druid's mana when shape shifted (requires Pet Module to be enabled)"],
                },
                manaBar = {
                    type = 'select',
                    order = 8,
                    name = L["Side"],
                    desc = L["Bar to track mana (pet bars are used)"],
                    disabled = function () return not db.mana end,
                    values = {["fr2b"] = L["Right Outer"],
                              ["fl2b"] = L["Left Outer"]},
                },
                manaBarText = {
                    type = 'toggle',
                    order = 9,
                    name = L["Druid Bar Values"],
                    disabled = function () return not db.mana end,
                    desc = L["Show/Hide"],
                },
                manaTextSize = {
                    order = 10,
                    type = 'range',
                    name = L["Font size"],
                    hidden = function() return not db.manaTextSize end,
                    min = MINFONT,
                    max = MAXFONT,
                    step = 1,
                },
                manaTextStyle = {
                    type = 'select',
                    order = 11,
                    name = L["Mana Style"],
                    values = druidManaTags,
                    disabled = function () return not db.mana end,
                },
                manaCustomTextStyle = {
                    type = 'input',
                    order = 12,
                    name = L["Custom Mana Style"],
                    disabled = function () return not db.mana end,
                    desc = L["If set this style will override Mana Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Mana Style setting.)"],
                    usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation"],
                },
                colors = {
                    type = 'group',
                    order = 13,
                    name = L["Bar Colors"],
                    get = ColorGetter,
                    set = ColorSetter,
                    inline = true,
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME) end,
                    args = {
                        ["mana"] = {
                            type = 'group',
                            name = L["Mana"],
                            order = 1,
                            args = DHUD4.colorOptions,
                        },
                        --[[["lunar"] = {
                            type = 'group',
                            name = L["Eclipse Lunar Phase"],
                            args = DHUD4.colorOptions,
                        },
                        ["solar"] = {
                            type = 'group',
                            name = L["Eclipse Solar Phase"],
                            args = DHUD4.colorOptions,
                        },--]]
                    },
                },
                eclipse = {
                    type = 'toggle',
                    order = 14,
                    name = L["Druid Eclipse"],
                    desc = L["Track druid's Eclipse"],
                },
                eclipseBar = {
                    type = 'select',
                    order = 15,
                    name = L["Bar"],
                    desc = L["Bar to track eclipse"],
                    disabled = function () return not db.eclipse end,
                    values = {["fr2d"] = L["Right Outer"],
                              ["fl2d"] = L["Left Outer"]},
                },
                eclipseBarText = {
                    type = 'toggle',
                    order = 16,
                    name = L["Eclipse Bar Values"],
                    disabled = function () return not db.eclipse end,
                    desc = L["Show/Hide"],
                },
                eclipseShowPercent = {
                    type = 'toggle',
                    order = 17,
                    disabled = function () return not db.eclipse end,
                    name = L["Eclipse percent"],
                    desc = L["Show Eclipse as percent"],
                },
                eclipseTextSize = {
                    order = 18,
                    type = 'range',
                    name = L["Eclipse Bar Font size"],
                    hidden = function() return not db.eclipseBarText end,
                    min = MINFONT,
                    max = MAXFONT,
                    step = 1,
                },
            },
        }
	end
	return options
end

local moonColors = {
                    f = { r=0.59,g=0.92,b=0.99},
                    h = { r=0,g=0.29,b=0.96},
                    l = { r=0.31,g=0,b=0.94}
                }
local sunColors = {
                    f = { r=1,g=0.99,b=0.73},
                    h = { r=0.89,g=0.96,b=0},
                    l = { r=1,g=0.89,b=0}
                }

ECLIPSE_ICONS =  {};
ECLIPSE_ICONS["moon"] = {
                            norm = { x=23, y=23, left=0.55859375, right=0.64843750, top=0.57031250, bottom=0.75000000 } ,
                            dark  = { x=23, y=23, left=0.55859375, right=0.64843750, top=0.37500000, bottom=0.55468750 } ,
                            big    = { x=43, y=45, left=0.73437500, right=0.90234375, top=0.00781250, bottom=0.35937500 } ,
                        }
ECLIPSE_ICONS["sun"] = {
                            norm = { x=23, y=23, left=0.65625000, right=0.74609375, top=0.37500000, bottom=0.55468750 } ,
                            dark  = { x=23, y=23, left=0.55859375, right=0.64843750, top=0.76562500, bottom=0.94531250 } ,
                            big    = { x=43, y=45, left=0.55859375, right=0.72656250, top=0.00781250, bottom=0.35937500 } ,
                        }

local manaBar, eclipseBar, eclipseIcon
local ConfigLayout
do
	-- Config Bars and Icons
    function ConfigLayout()

        local manaParent
    	-- Mana bar
        if (db.mana) then
            if (string_find(db.manaBar, "r")) then
                manaParent = DHUD4_RightFrame
            else
                manaParent = DHUD4_LeftFrame
            end
            manaBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
            manaBar:InitStatusBar(db.manaBar, manaParent, 0.5)
            manaBar:PlaceTextures(DHUD4:GetCurrentTexture())
            if db.manaBarText then
                manaBar:InitStatusBarText(db.manaBar, DHUD4:GetPosition(db.manaBar))
                local textTag = (string_len(db.manaCustomTextStyle) > 0) and db.manaCustomTextStyle or db.manaTextStyle
                manaBar:ConfigBarText(DHUD4:GetFont(), db.manaTextSize * DHUD4.GetScale(), textTag, "player")
            end
        end

        -- Eclipse bar
        local eclipseParent
        if (db.eclipse) then
            if (string_find(db.eclipseBar, "r")) then
                eclipseParent = DHUD4_RightFrame
            else
                eclipseParent = DHUD4_LeftFrame
            end
            eclipseBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
            eclipseBar:InitStatusBar(db.eclipseBar, eclipseParent, 0.5)
            eclipseBar:PlaceTextures(DHUD4:GetCurrentTexture())
            eclipseBar.unit = "player"
            if db.eclipseBarText then
                eclipseBar:InitStatusBarText(db.eclipseBar, DHUD4:GetPosition(db.eclipseBar))
                eclipseBar:ConfigText(DHUD4:GetFont(), db.eclipseTextSize * DHUD4.GetScale(), 200)
                eclipseBar.showPercent = db.eclipseShowPercent
            end
            -- Bar Flash texture
            local flash  = eclipseBar.frame:CreateTexture("DHUD4_"..eclipseBar.frame.bar.."Flash", "BORDER")
            flash:SetAllPoints()
            flash:SetBlendMode("BLEND")
            eclipseBar.frame.flash = flash
            --Eclipse Icon
            local parent, x = eclipseBar, 40
            if (string_find(db.eclipseBar, "r")) then
                x = -x
            end
            eclipseIcon = _G["DHUD4_EclipseIcon"]
            if(not eclipseIcon) then
                eclipseIcon = CreateFrame("Button", "DHUD4_EclipseIcon", eclipseParent)
                eclipseIcon:SetHeight(20)
                eclipseIcon:SetWidth(20)
            end
            eclipseIcon:ClearAllPoints()
            eclipseIcon:SetPoint("CENTER", eclipseParent, "CENTER", x, 12)
            local texture = eclipseIcon:CreateTexture("DHUD4_EclipseIcon_Texture", "BACKGROUND")
            texture:ClearAllPoints()
            texture:SetAllPoints()
            texture:SetHeight(20)
            texture:SetWidth(20)
            eclipseIcon.texture = texture
            -- Icon flash
            local iconFlash = eclipseIcon:CreateTexture("DHUD4_EclipseIcon_FlashTexture", "BORDER")
            iconFlash:ClearAllPoints()
            iconFlash:SetAllPoints()
            iconFlash:SetHeight(20)
            iconFlash:SetWidth(20)
            eclipseIcon.flash = iconFlash
            -- Animations
            local iconPulse = iconFlash:CreateAnimationGroup("DHUD4_EclipseIconGlow")
            local eclipseIconActivate =  iconPulse:CreateAnimation("Alpha", "DHUD4_eclipseIconActivate")
            eclipseIconActivate:SetChange(1)
            eclipseIconActivate:SetDuration(0.6)
            eclipseIconActivate:SetOrder(1)
            eclipseIconActivate:SetScript("OnPlay", function(self)
                self:GetParent():GetParent():SetAlpha(1)
            end)
            eclipseIconActivate:SetScript("OnStop", function(self)
                self:GetParent():GetParent():SetAlpha(0)
            end)
            local eclipseIconDeactivate =  iconPulse:CreateAnimation("Alpha", "DHUD4_eclipseIconDeactivate")
            eclipseIconDeactivate:SetChange(-1)
            eclipseIconDeactivate:SetDuration(0.6)
            eclipseIconDeactivate:SetOrder(1)
            eclipseIconDeactivate:SetScript("OnPlay", function(self)
                self:GetParent():GetParent():SetAlpha(1)
            end)
            eclipseIconDeactivate:SetScript("OnStop", function(self)
                self:GetParent():GetParent():SetAlpha(0)
            end)
            eclipseIcon.activate = eclipseIconActivate
            eclipseIcon.deactivate = eclipseIconDeactivate
            local barPulse = eclipseBar.frame:CreateAnimationGroup("DHUD4_EclipseBarGlow")
            local eclipseBarActivate =  barPulse:CreateAnimation("Alpha", "DHUD4_eclipseBarActivate")
            eclipseBarActivate:SetChange(1)
            eclipseBarActivate:SetDuration(0.6)
            eclipseBarActivate:SetOrder(1)
            eclipseBarActivate:SetScript("OnPlay", function(self)
                self:GetParent():GetParent().flash:SetAlpha(1)
            end)
            eclipseBarActivate:SetScript("OnStop", function(self)
                self:GetParent():GetParent().flash:SetAlpha(0)
            end)
            local eclipseBarDeactivate =  barPulse:CreateAnimation("Alpha", "DHUD4_eclipseBarDeactivate")
            eclipseBarDeactivate:SetChange(-1)
            eclipseBarDeactivate:SetDuration(0.6)
            eclipseBarDeactivate:SetOrder(1)
            eclipseBarDeactivate:SetScript("OnPlay", function(self)
                self:GetParent():GetParent().flash:SetAlpha(1)
            end)
            eclipseBarDeactivate:SetScript("OnStop", function(self)
                self:GetParent():GetParent().flash:SetAlpha(0)
            end)
            eclipseBar.activate = eclipseBarActivate
            eclipseBar.deactivate = eclipseBarDeactivate
        end
    end

end

function DHUD4_Druid:OnInitialize()

    local _, englishClass = UnitClass("player")
    if (englishClass == "DRUID") then
        self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
        self.defaults = DHUD4:TableMerge(self.defaults, defaults)
        self.db = DHUD4.db:RegisterNamespace(MODNAME, self.defaults)
        db = self.db.profile
        self.layout = false
        DHUD4_Druid:SetBorderColors(db.colors.border)
        DHUD4:RegisterModuleOptions(MODNAME, getOptions, L["Druid Abilities"])
        -- Bars
        manaBar = DHUD4:CreateStatusBar()
        eclipseBar = DHUD4:CreateStatusBar()
    else
        self:SetEnabledState(false)
    end
end

function DHUD4_Druid:OnEnable()

    --DHUD4:Debug(MODNAME..":OnEnable", self:IsEnabled())
    if not self:IsEnabled() then return end
    if ( DHUD4:GetModuleEnabled("DHUD4_Auras") ) then
        local auras = DHUD4:GetModule("DHUD4_Auras")
        self.db.profile.side = (auras:GetSide() == "r") and "l" or "r"
    end
    self:Refresh()
    -- Listen to bar pops
	self:RegisterMessage("DHUD4_BAR")
end

function DHUD4_Druid:OnDisable()

	self:UnregisterAllEvents()
    manaBar:Disable()
    self:UntrackDruidEclipse()
    self:HideAll()
end


function DHUD4_Druid:Refresh()

    --DHUD4:Debug(MODNAME, "Refresh")
    if not self:IsEnabled() then return end
    self.side = db.side
    self.scale = db.scale
    self.fontSize = db.fontSize
    self:_Refresh()

    manaBar:Disable()
    --eclipseBar:Disable()
    ConfigLayout()

    if (self.layout) then
        self:SetLayout()
    else
        local form  = GetShapeshiftFormID();
        if ( db.lacerates or db.lifeblooms or db.eclipse) then
            self:SetUpBuffs(3)
            self:RegisterEvent("UNIT_AURA")
        end
        if ( db.combos or db.vehiCombos ) then
            self:SetUpCombos()
            self:RegisterEvent("UNIT_COMBO_POINTS")
        end
        if ( db.combos or db.lacerates or db.lifeblooms) then
            self:RegisterEvent("PLAYER_TARGET_CHANGED")
            self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
        end
        if (db.eclipse) then
            self:RegisterEvent("PLAYER_TALENT_UPDATE");
            self:RegisterEvent("ECLIPSE_DIRECTION_CHANGE");
            self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
        end
        self:UPDATE_SHAPESHIFT_FORM()
    end
end

function DHUD4_Druid:UNIT_COMBO_POINTS(event, who)
	
	--DHUD4:Debug("Abilities UNIT_COMBO_POINTS");
	if ( who == "player" ) then
		self:UpdateCombos("player")
	end
end

function DHUD4_Druid:PLAYER_TARGET_CHANGED(event)
	
	--DHUD4:Debug("Abiities PLAYER_TARGET_CHANGED");
	if ( UnitExists("target") ) then
		if ( UnitInVehicle("player") and db.vehiCombos ) then
			self:UpdateCombos("player")
		elseif ( db.combos and (GetShapeshiftFormID() == CAT_FORM) ) then
            self:UpdateCombos("player")
        end
    else
        self:HideAll()
	end
end

function DHUD4_Druid:UPDATE_SHAPESHIFT_FORM(event)
	
    local form  = GetShapeshiftFormID()
    if(db.eclipse) then  self:UntrackDruidEclipse() end
    if ( form == 0 ) then
        -- Is Druid
        if (db.lifeblooms) then
            self:UpdateBuff("Lifebloom", db.lifebloomsTimer, db.tips)
        end
        if (db.mana) then self:UntrackDruidMana() end
    elseif ( db.lacerates and (form == BEAR_FORM) ) then
        -- Is Bear
        self:UpdateDebuff("Lacerate", db.laceratesTimer, db.tips)
        if (db.mana) then self:TrackDruidMana() end
    elseif ( db.combos and (form == CAT_FORM) ) then
        -- Is Cat
        self:UpdateCombos("player")
        if (db.mana) then self:TrackDruidMana() end
    elseif ( db.eclipse and (form == MOONKIN_FORM) ) then
        if(db.eclipse) then self:TrackDruidEclipse() end
        if (db.mana) then self:UntrackDruidMana() end
    else
        if (db.mana) then self:UntrackDruidMana() end
    end
end

function DHUD4_Druid:UNIT_AURA(event, who)
    --DHUD4:Debug("Druid: UNIT_AURA", who)
	if who == "target" then
		local powerType = UnitPowerType("player")
        if ( db.lifeblooms and ( powerType == 0 ) ) then
            -- Is Druid
            self:UpdateBuff("Lifebloom", db.lifebloomsTimer, db.tips)
        elseif ( db.lacerates and ( powerType == 1 ) ) then
            -- Is Bear
            self:UpdateDebuff("Lacerate", db.laceratesTimer, db.tips)
        end
    elseif (who == "player") then
        DHUD4_Druid:CheckEclipse()
    end
end

function DHUD4_Druid:PLAYER_TALENT_UPDATE(event)
end

function DHUD4_Druid:ECLIPSE_DIRECTION_CHANGE(event, ...)
    local isLunar = ...;
    if isLunar then
        eclipseBar.baseColors = moonColors
    else
        eclipseBar.baseColors = sunColors
    end
end

function DHUD4_Druid:TrackDruidMana()

    manaBar:TrackUnitPower("player", db.colors.mana, 0)
end

function DHUD4_Druid:UntrackDruidMana()

    manaBar:Disable(true)
end

function DHUD4_Druid:CheckEclipse()

    local hasLunarEclipse = false;
	local hasSolarEclipse = false;

	local unit = PlayerFrame.unit;
	local j = 1;
	local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
	while name do
		if spellID == ECLIPSE_BAR_SOLAR_BUFF_ID then
			hasSolarEclipse = true;
		elseif spellID == ECLIPSE_BAR_LUNAR_BUFF_ID then
			hasLunarEclipse = true;
		end
		j=j+1;
		name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
	end
    DHUD4:Debug("CheckEclipse", hasLunarEclipse, hasSolarEclipse)
	if hasLunarEclipse then
        eclipseBar.baseColors = moonColors
        eclipseBar.frame.flash:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\BarMoonGlow")
        if ( not eclipseBar.frame.flash:GetTexture() ) then
            eclipseBar.frame.flash.texture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\BarMoonGlow")
        end
        if eclipseBar.deactivate:IsPlaying() then
			eclipseBar.deactivate:Stop()
		end
		if not eclipseBar.activate:IsPlaying() and hasLunarEclipse ~= self.hasLunarEclipse then
			eclipseBar.activate:Play()
		end
        eclipseIcon.texture:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\Moon")
        if ( not eclipseIcon.texture:GetTexture() ) then
            eclipseIcon.texture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\Moon")
        end
        eclipseIcon.flash:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\MoonGlow")
        if ( not eclipseIcon.flash:GetTexture() ) then
            eclipseIcon.flash:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\MoonGlow")
        end
        if eclipseIcon.deactivate:IsPlaying() then
			eclipseIcon.deactivate:Stop()
		end
		if not eclipseIcon.activate:IsPlaying() and hasLunarEclipse ~= self.hasLunarEclipse then
			eclipseIcon.activate:Play()
		end
	elseif hasSolarEclipse then
        eclipseBar.baseColors = sunColors
        eclipseBar.frame.flash:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\BarSunGlow")
        if ( not eclipseBar.frame.flash:GetTexture() ) then
            eclipseBar.frame.flash.texture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\BarMoonGlow")
        end
        if eclipseBar.deactivate:IsPlaying() then
			eclipseBar.deactivate:Stop()
		end
		if not eclipseBar.activate:IsPlaying() and hasSolarEclipse ~= self.hasSolarEclipse then
			eclipseBar.activate:Play()
		end
        eclipseIcon.texture:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\Sun")
        if ( not eclipseIcon:GetTexture() ) then
            eclipseIcon.texture:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\Sun")
        end
        eclipseIcon.flash:SetTexture(DHUD4:GetCurrentTexture().."Eclipse\\SunGlow")
        if ( not eclipseIcon.flash:GetTexture() ) then
            eclipseIcon.flash:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Eclipse\\SunGlow")
        end
        if eclipseIcon.deactivate:IsPlaying() then
			eclipseIcon.deactivate:Stop()
		end
		if not eclipseIcon.activate:IsPlaying() and hasSolarEclipse ~= self.hasSolarEclipse then
			eclipseIcon.activate:Play()
		end
	else
		if eclipseBar.activate:IsPlaying() then
			eclipseBar.activate:Stop();
		end
		if not eclipseBar.deactivate:IsPlaying() and ((hasLunarEclipse ~= self.hasLunarEclipse) or (hasSolarEclipse ~= self.hasSolarEclipse)) then
			eclipseBar.deactivate:Play();
		end
        if eclipseIcon.activate:IsPlaying() then
			eclipseIcon.activate:Stop();
		end
		if not eclipseIcon.deactivate:IsPlaying() and ((hasLunarEclipse ~= self.hasLunarEclipse) or (hasSolarEclipse ~= self.hasSolarEclipse)) then
			eclipseIcon.deactivate:Play();
		end
	end
	self.hasLunarEclipse = hasLunarEclipse;
	self.hasSolarEclipse = hasSolarEclipse;

end

function DHUD4_Druid:SetLayout()

    self.layout = true
    self:UnregisterAllEvents()
    self:HideAll()
    if ( db.combos or db.lacerates or db.lifeblooms) then
        self:_SetLayout(db.combos and 5 or 3, db.lacerates or db.lifeblooms)
    end
end

function DHUD4_Druid:EndLayout()

    self.layout = false
    self:Refresh()
end


function DHUD4_Druid:TrackDruidEclipse()
    -- Based on the code from EclipseBarFrame.lua
    local unit = eclipseBar.unit
    eclipseBar.maxVal = UnitPowerMax( unit, SPELL_POWER_ECLIPSE )
    local direction = GetEclipseDirection()
    if ( direction == "moon") then
        eclipseBar.baseColors = moonColors
    else
        eclipseBar.baseColors = sunColors
    end
    local hasLunarEclipse = false
	local hasSolarEclipse = false
	local j = 1;
	local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
	while name do
		if spellID == ECLIPSE_BAR_SOLAR_BUFF_ID then
			hasSolarEclipse = true;
		elseif spellID == ECLIPSE_BAR_LUNAR_BUFF_ID then
			hasLunarEclipse = true;
		end
		j=j+1;
		name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
	end
    --[[if hasLunarEclipse or hasSolarEclipse then
        eclipseBar.frame:SetAlpha(1)
		eclipseIcon:SetAlpha(1)
	else
		eclipseBar.frame:SetAlpha(0)
        eclipseIcon:SetAlpha(0)
	end--]]
    self.hasLunarEclipse = hasLunarEclipse;
	self.hasSolarEclipse = hasSolarEclipse;
    eclipseBar.frame:SetScript("OnUpdate", DHUD4_Druid.EclipseUpdate)
    eclipseBar.frame:Show()
    eclipseBar.text:Show()
    DHUD4_Druid:EclipseUpdate(self)
end

function DHUD4_Druid:EclipseUpdate(self)
    -- Taken from EclipseBarFrame.lua
    local power = UnitPower( eclipseBar.unit, SPELL_POWER_ECLIPSE )
    if eclipseBar.showPercent then
        eclipseBar.text.text:SetText(abs(power/eclipseBar.maxVal*100).."%");
    else
        eclipseBar.text.text:SetText(abs(power));
    end
    eclipseBar.val = power
    eclipseBar:Colorize()
    eclipseBar:Fill()
end

function DHUD4_Druid:UntrackDruidEclipse()

    if (eclipseBar) then
        eclipseBar:Disable()
    end
    if (eclipseIcon) then
        eclipseIcon:Hide()
    end
end
--[[
function DHUD4_Druid:SetLayout()

    self.layout = true
    if ( druidManaBar ) then
        if (druidManaBar ~= healthBar and druidManaBar ~= powerBar) then
            druidBar:Disable()
            druidBar:SetLayout("Druid Mana", 100, 50)
        end
    end
    if ( druidEclipseBar ) then
        if (druidEclipseBar ~= healthBar and druidEclipseBar ~= powerBar) then
            druidEclipseBar:Disable()
            druidEclipseBar:SetLayout("Druid Eclipse", 100, 50)
        end
    end
end
]]

--[[

--]]
