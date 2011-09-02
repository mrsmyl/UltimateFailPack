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

local MODNAME = "DHUD4_Paladin"
local DHUD4_Paladin = DHUD4:NewModule(MODNAME, DHUD4.Abilities, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 51 $"):match("%d+"))

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
end

local defaults = {
    profile = {
        power = true,
    }
}

--Local Options
local options
local function getOptions()
    if not options then
        --Options table
        options = DHUD4_Paladin:GetOptions()
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
            name = L["Paladin"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            args = {
                power = {
                    type = 'toggle',
                    order = 1,
                    name = L["Power"],
                    desc = L["Track paladin power"],
                    hidden = false,
                },
            }
        }
    end
    return options
end

function DHUD4_Paladin:OnInitialize()

    local _, englishClass = UnitClass("player")
    if (englishClass == "PALADIN") then
        self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
        self.defaults = DHUD4:TableMerge(self.defaults, defaults)
        self.db = DHUD4.db:RegisterNamespace(MODNAME, self.defaults)
        db = self.db.profile
        self.layout = false
        DHUD4:RegisterModuleOptions(MODNAME, getOptions, L["Paladin Abilities"])
    else
        self:SetEnabledState(false)
        --DHUD4:SetModuleEnabled(MODNAME, false)
    end
end

function DHUD4_Paladin:OnEnable()

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

function DHUD4_Paladin:OnDisable()

	self:UnregisterAllEvents()
    self:HideAll()
end

function DHUD4_Paladin:Refresh()

    --DHUD4:Debug(MODNAME, "Refresh")
    if not self:IsEnabled() then return end
    self.side = db.side
    self.scale = db.scale
    self.fontSize = db.fontSize
    self:_Refresh()
    if (db.power) then
        --DHUD4:Debug(MODNAME, "track power")
        self:SetupHolyPower()
        if UnitLevel("player") < PALADINPOWERBAR_SHOW_LEVEL then
            self:RegisterEvent("PLAYER_LEVEL_UP")
            self.parent:SetAlpha(0);
        else
            self:UpdatePower("PALADIN")
        end
        self:RegisterEvent("UNIT_POWER");
        self:RegisterEvent("PLAYER_ENTERING_WORLD", "UPDATE_POWER");
        self:RegisterEvent("UNIT_DISPLAYPOWER", "UPDATE_POWER");
    end
end

function DHUD4_Paladin:PLAYER_LEVEL_UP(event, arg1, arg2)

    local level = arg1
    if level >= PALADINPOWERBAR_SHOW_LEVEL then
        self:UnregisterEvent("PLAYER_LEVEL_UP")
        self.parent:SetAlpha(1)
        self:UpdatePower("PALADIN")
    end
end

function DHUD4_Paladin:UNIT_POWER(event, arg1, arg2)

    --DHUD4:Debug(MODNAME, "UNIT_POWER", event, arg1, arg2)
    if ( arg1 == "player" ) then
		if ( arg2 == "HOLY_POWER" ) then
			self:UpdatePower("PALADIN")
		end
    end
end

function DHUD4_Paladin:UPDATE_POWER(event, arg1)

    if ( arg1 == "player" ) then
        self:UpdatePower("PALADIN")
    end
end
