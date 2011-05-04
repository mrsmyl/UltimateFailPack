--[[
DHUD4_Paladin.lua
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

local MODNAME = "DHUD4_DeathKnight"
local DHUD4_DeathKnight = DHUD4:NewModule(MODNAME, DHUD4.Abilities, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 30 $"):match("%d+"))


local string_match = string.match
local string_len = string.len
local string_find = string.find

local db
local OptGetter, OptSetter, ColorGetter, ColorSetter, runeDisplay
do
	local mod = DHUD4_DeathKnight
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

    runeDisplay = { ["rr"] = L["Round Robin"],
                    ["bu"] = L["Bottom Up"],
                    ["ha"] = L["Half'n'Away"],
                    ["c"] = L["Centered"]}

end

local defaults = {
    profile = {
        runes = true,
		layout = "bu",
		hideOnCD = false,
    }
}


local options, mana
local function getOptions()
    if not options then
        --Options table
        options = DHUD4_DeathKnight:GetOptions()
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
            name = L["Death Knight"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            args = {
                runes = {
                    type = 'toggle',
                    order = 1,
                    name = L["Death Knight Runes"],
                    desc = L["Track Death Knight Runes"],
                    hidden = false,
                },
                hideOnCD = {
                    type = 'toggle',
                    order = 3,
                    name = L["Hide on Cool down"],
                    desc = L["Hide runes that are on cool down."],
                    disabled = timerDisabled,
                    hidden = false,
                },
                layout = {
                    type = 'select',
                    order = 4,
                    name = L["Rune Layout"],
                    desc = L["Set how to display the runes. Round Robin places them in a single vertical row, runes rotate moving used ones to the top of the line. Bottom up places them at the lower side of the bars, grouped in pairs. Half'n'Away places them at the center of the bar, in vertical pairs positioned away from the bar. Centered places the runes in the center of the HUD, above the target's name plate (in this mode side setting for abilities won't have any difference)."],
                    values = runeDisplay,
                    hidden = false,
                },
            },
        }
    end
    return options
end


local ConfigLayout
do

end

function DHUD4_DeathKnight:OnInitialize()

    local _, englishClass = UnitClass("player")
    if (englishClass == "DEATHKNIGHT") then
        self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
        self.defaults = DHUD4:TableMerge(self.defaults, defaults)
        self.db = DHUD4.db:RegisterNamespace(MODNAME, self.defaults)
        db = self.db.profile
        self.layout = false
        DHUD4:RegisterModuleOptions(MODNAME, getOptions, L["Death Knight Abilities"])
    else
        self:SetEnabledState(false)
        --DHUD4:SetModuleEnabled(MODNAME, false)
    end
end

function DHUD4_DeathKnight:OnEnable()

    DHUD4:Debug(MODNAME..":OnEnable", self:IsEnabled())
    if not self:IsEnabled() then return end
    if ( DHUD4:GetModuleEnabled("DHUD4_Auras") ) then
        local auras = DHUD4:GetModule("DHUD4_Auras")
        self.db.profile.side = (auras:GetSide() == "r") and "l" or "r"
    end
    self:Refresh()
    -- Listen to bar pops
	self:RegisterMessage("DHUD4_BAR")
end

function DHUD4_DeathKnight:OnDisable()

    DHUD4:Debug(MODNAME..":OnDisable")
	self:UnregisterAllEvents()
    self:HideAll()
end


function DHUD4_DeathKnight:Refresh()

    if not self:IsEnabled() then return end
    db = self.db.profile
    self.side = db.side
    self.scale = db.scale
    self.fontSize = db.fontSize
    self:_Refresh()
    if (self.layout) then
        self:SetLayout()
    else
        self:SetUpRunes(db.layout, db.timer)
        if ( db.layout == "rr" ) then
            self:RegisterEvent("RUNE_POWER_UPDATE", "RunePowerRR");
            self:RegisterEvent("RUNE_TYPE_UPDATE");
        else
            self:RegisterEvent("RUNE_POWER_UPDATE");
            self:RegisterEvent("RUNE_TYPE_UPDATE");
        end
        self:RegisterEvent("PLAYER_UNGHOST");
        if ( db.layout ~= "c" ) then
            -- Listen to bar pops
            self:RegisterMessage("DHUD4_BAR")
        end
    end

end

function DHUD4_DeathKnight:RUNE_POWER_UPDATE(event, ...)

    -- The rune is usable or unusable
    local runeIndex, isEnergize = ...;
    --DHUD4:Debug("DHUD4_DeathKnight:RUNE_POWER_UPDATE", runeIndex, isEnergize)
	self:UpdateRune(runeIndex, isEnergize, db.hideOnCD, db.layout)

end

function DHUD4_DeathKnight:RUNE_TYPE_UPDATE(event, ...)

	-- Rune type changed
	local rune = ...
    --DHUD4:Debug("DHUD4_DeathKnight:RUNE_TYPE_UPDATE", rune)
    self:UpdateRuneType(rune)
end

function DHUD4_DeathKnight:RunePowerRR(event, ...)

    -- The rune is usable or unusable
    local runeIndex, isEnergize = ...;
    --DHUD4:Debug("DHUD4_DeathKnight:RUNE_POWER_UPDATE", runeIndex, isEnergize)
	DHUD4_DeathKnight:UpdateRune(runeIndex, isEnergize, db.hideOnCD, db.layout, true)
end

--[[
    PLAYER_UNGHOST: Event function.
]]
function DHUD4_DeathKnight:PLAYER_UNGHOST()

    for i = 1, 6 do
        self:UpdateRune(i)
    end
end

function DHUD4_DeathKnight:SetLayout()

    self.layout = true
    self:UnregisterAllEvents()
    self:HideAll()
    self:_SetLayout(6, true, db.layout)
end

function DHUD4_DeathKnight:EndLayout()

    self.layout = false
    self:Refresh()
end
