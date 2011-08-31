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
local VERSION = tonumber(("$Rev: 103 $"):match("%d+"))


local string_match = string.match
local string_len = string.len
local string_find = string.find

--MAX_HOLY_POWER = 3;
--PALADINPOWERBAR_SHOW_LEVEL = 9

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
		manaBar = "fr2",
		manaBarText = true,
        manaTextSize = 10,
		manaTextStyle = "[FractionalDruidMP] ([PercentDruidMP:Percent])",
		manaCustomTextStyle = "",
        eclipse  = true,
        eclipseBar = "fl2",
		eclipseBarText = true,
        eclipseTextSize = 10,
		eclipseTextStyle = "[FractionalDruidMP] ([PercentDruidMP:Percent])",
		eclipseCustomTextStyle = "",
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
                    values = {["fr1"] = L["Right Inner"],
                              ["fr2"] = L["Right Outer"],
                              ["fl1"] = L["Left Inner"],
                              ["fl2"] = L["Left Outer"]},
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
                    hidden = function() return not (db.healthBarText or db.powerBarText) end,
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
                        ["lunar"] = {
                            type = 'group',
                            name = L["Eclipse Lunar Phase"],
                            args = DHUD4.colorOptions,
                        },
                        ["solar"] = {
                            type = 'group',
                            name = L["Eclipse Solar Phase"],
                            args = DHUD4.colorOptions,
                        },
                    },
                },
            },
        }
	end
	return options
end

local manaBar, eclipseBar
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
                manaBar:InitStatusBarText(db.manaBar, DHUD4:GetPosition(hbar))
                local textTag = (string_len(db.manaCustomTextStyle) > 0) and db.manaCustomTextStyle or db.manaTextStyle
                manaBar:ConfigBarText(DHUD4:GetFont(), db.manaTextSize * DHUD4.GetScale(), textTag, "player")
            end
        end

        -- Eclipse bar
        --[[powerBar:InitStatusBar(pbar, ppar, 0.5)
        powerBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.powerBarText then
            powerBar:InitStatusBarText(pbar, DHUD4:GetPosition(pbar))
        end
        powerBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        --]]
        --Eclipse Icon
        --[[if ( db.icon and not happIcon) then
            local parent, x = DHUD4_LeftFrame, 40
            if iconSide == "r" then
                x = -x
                parent = DHUD4_RightFrame
            end
            happIcon = CreateFrame("Button", "DHUD4_happ", parent)
            happIcon:ClearAllPoints()
            happIcon:SetPoint("CENTER", parent, "CENTER", x, 12)
            happIcon:SetHeight(20)
            happIcon:SetWidth(20)
            local texture = happIcon:CreateTexture("DHUD4_happ_Texture", "BACKGROUND")
            texture:ClearAllPoints()
			texture:SetAllPoints()
            --texture:SetPoint("TOPLEFT", happIcon, "TOPLEFT", 0, 0)
            --texture:SetPoint("BOTTOMRIGHT", happIcon , "BOTTOMRIGHT", 0, 0)
            texture:SetHeight(20)
            texture:SetWidth(20)
			texture:Show()
            happIcon.texture = texture
        end
        --]]

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
        --eclipseBar = DHUD4:CreateStatusBar()
    else
        self:SetEnabledState(false)
        --DHUD4:SetModuleEnabled(MODNAME, false)
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
    --eclipseBar:Disable()
    --self:DisableIcon(eclipseIcon)
    self:HideAll()
end


function DHUD4_Druid:Refresh()

    --DHUD4:Debug(MODNAME, "Refresh")
    if not self:IsEnabled() then return end
    db = self.db.profile
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
	
    local form  = GetShapeshiftFormID();
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
        --self:UpdateEclipse()
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
        --DHUD4_Druid:CheckEclipse()
    end
end

function DHUD4_Druid:PLAYER_TALENT_UPDATE(event)
end

function DHUD4_Druid:ECLIPSE_DIRECTION_CHANGE(event)
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

	if hasLunarEclipse then
        if (DHUD4:GetModuleEnabled("DHUD4_Pet")) then
            DHUD4_Pet:TrackDruidEclipse(db.lunarColors, db.eclipseText, db.eclipseTextStyle)
        end
		self.glow:ClearAllPoints();
		local glowInfo = ECLIPSE_ICONS["moon"].big;
		self.glow:SetPoint("CENTER", self.moon, "CENTER", 0, 0);
		self.glow:SetWidth(glowInfo.x);
		self.glow:SetHeight(glowInfo.y);
		self.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);

		if self.moonDeactivate:IsPlaying() then
			self.moonDeactivate:Stop();
		end

		if not self.moonActivate:IsPlaying() and hasLunarEclipse ~= self.hasLunarEclipse then
			self.moonActivate:Play();
		end
	else
		if self.moonActivate:IsPlaying() then
			self.moonActivate:Stop();
		end

		if not self.moonDeactivate:IsPlaying() and hasLunarEclipse ~= self.hasLunarEclipse then
			self.moonDeactivate:Play();
		end
	end

	if hasSolarEclipse then
        if (DHUD4:GetModuleEnabled("DHUD4_Pet")) then
            DHUD4_Pet:TrackDruidEclipse(db.solarColors, db.eclipseText, db.eclipseTextStyle)
        end

		self.glow:ClearAllPoints();
		local glowInfo = ECLIPSE_ICONS["sun"].big;
		self.glow:SetPoint("CENTER", self.sun, "CENTER", 0, 0);
		self.glow:SetWidth(glowInfo.x);
		self.glow:SetHeight(glowInfo.y);
		self.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);

		if self.sunDeactivate:IsPlaying() then
			self.sunDeactivate:Stop();
		end

		if not self.sunActivate:IsPlaying() and hasSolarEclipse ~= self.hasSolarEclipse then
			self.sunActivate:Play();
		end
	else
		if self.sunActivate:IsPlaying() then
			self.sunActivate:Stop();
		end

		if not self.sunDeactivate:IsPlaying() and hasSolarEclipse ~= self.hasSolarEclipse then
			self.sunDeactivate:Play();
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
function DHUD4_Pet:SetupDruidEclipse(eclipseBar, eclipseBarText)

    if (not druidEclipseBar or (druidEclipseBar.frame.bar ~= eclipseBar)) then
        if (druidEclipseBar) then
            druidEclipseBar:Disable()
        end
        if ( healthBar.frame.bar == eclipseBar) then
            druidEclipseBar = healthBar
        elseif ( powerBar.frame.bar == eclipseBar) then
            druidEclipseBar = powerBar
        elseif (druidManaBar.frame.bar == eclipseBar) then
            druidEclipseBar =  druidManaBar
        else
            druidEclipseBar = DHUD4:CreateStatusBar()
            if string_match(eclipseBar, "r") then
                druidEclipseBar:InitStatusBar(eclipseBar, _G["DHUD4_RightFrame"], 0.5)
            else
                druidEclipseBar:InitStatusBar(eclipseBar, _G["DHUD4_LeftFrame"], 0.5)
            end
            druidEclipseBar:PlaceTextures(DHUD4:GetCurrentTexture())
            druidEclipseBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        end
        -- Create Eclipse Icon and Glow animation
        eclipseIcon = CreateFrame("Button", "DHUD4_Eclipse", druidEclipseBar)
        eclipseIcon:SetHeight(23)
        eclipseIcon:SetWidth(23)
        eclipseIcon:ClearAllPoints()
        if string_match(eclipseBar, "r") then
            eclipseIcon:SetPoint("CENTER", druidEclipseBar.frame, "TOP", -5, 12)
        else
            eclipseIcon:SetPoint("CENTER", druidEclipseBar.frame, "TOP", 5, 12)
        end
        local texture = eclipseIcon:CreateTexture("DHUD4_Eclipse_Texture", "BACKGROUND")
        texture:ClearAllPoints()
        texture:SetAllPoints()
        texture:SetHeight(23)
        texture:SetWidth(23)
        texture:Show()
        eclipseIcon.texture = texture
        druidEclipseBar.frame.glow = texture
        local glow = texture:CreateAnimationGroup("pulse")
        glow:SetLooping("repeat")
        local grow = glow:CreateAnimation("Scale", "grow")
        glow:SetOrder(1)
        glow:SetScale(1.08, 1.08)
        glow:SetDuration(0.5)
        glow:SetSmoothing("IN_OUT")
        local shrink =glow: CreateAnimation("Scale", "shrink")
        shrink:SetOrder(2)
        shrink:SetScale(1.08, 1.08)
        shrink:SetDuration(0.5)
        shrink:SetSmoothing("IN_OUT")
        local eclipseAG = druidEclipseBar.frame:CreateAnimationGroup("eclipseActivate")
        local barAlpha =  alphaAG:CreateAnimation("Alpha", "barAlpha")
        barAlpha:SetOrder(1)
        barAlpha:SetDuration(0.6)
        barAlpha:SetChange(1)
        local glowAlpha =  alphaAG:CreateAnimation("Alpha", "glowAlpha")
        glowAlpha:SetOrder(1)
        glowAlpha:SetDuration(0.6)
        glowAlpha:SetChange(1)
        glowAlpha:SetTarget(texture)
        eclipseAG:SetScript("OnFinished", function (self, event)
                self:GetParent():SetAlpha(1)
                self:GetParent().glow:SetAlpha(1)
                self:GetParent().glow.pulse:Play()
            end)
        --druidEclipseBar:CreateAnimationGroup("sunDeactivate")
        --local moonActivateAG = druidEclipseBar.frame:CreateAnimationGroup("moonActivate")
        --druidEclipseBar:CreateAnimationGroup("moonDeactivate")
    end
    if eclipseBarText then
        druidEclipseBar:InitStatusBarText(eclipseBar, DHUD4:GetPosition(eclipseBar))
    end
end

function DHUD4_Pet:TrackDruidEclipse(colors, useText, textTag)

    druidTrackEclipse = true
    --DHUD4:Debug("TrackDruidEclipse")
    druidEclipseBar:TrackUnitPower("player", colors, 8)
    if (useText and textTag) then
        druidEclipseBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), textTag, "player")
    end
    --
    --eclipseIcon.texture
end


function DHUD4_Pet:UntrackDruidEclipse()

    if (falsedruidEclipseBar) then
        falsedruidEclipseBar:Disable()
    end
    druidTrackEclipse = false

end
--]]
