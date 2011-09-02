--[[
DHUD4_Warrior.lua
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

local MODNAME = "DHUD4_Warrior"
local DHUD4_Warrior = DHUD4:NewModule(MODNAME, DHUD4.Abilities, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 105 $"):match("%d+"))

local _G = _G
local MAX_SUNDER_ARMOR = 3;

local defaults = {
    profile = {
        sunders = true,
		sundersTimer = true,
    }
}

local db
local OptGetter, OptSetter, ColorGetter, ColorSetter
do
	local mod = DHUD4_Warrior
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

--Local Options
local options
local function getOptions()
    if not options then
        --Options table
        options = DHUD4_Warrior:GetOptions()
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
            name = L["Warrior"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            args = {
                sunders = {
                    type = 'toggle',
                    order = 1,
                    name = L["Sunder Armors"],
                    desc = L["Track warrior sunder armors"],
                    hidden = false,
                },
                sundersTimer = {
                    type = 'toggle',
                    order = 2,
                    name = L["Sunder Armors Timer"],
                    desc = L["Track warrior sunder armors expiration"],
                    disabled = timerDisabled,
                    hidden = false,
                },
            },
        }
	end
	return options
end


function DHUD4_Warrior:OnInitialize()

    local _, englishClass = UnitClass("player")
    if (englishClass == "WARRIOR") then
        self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
        self.defaults = DHUD4:TableMerge(self.defaults, defaults)
        self.db = DHUD4.db:RegisterNamespace(MODNAME, self.defaults)
        db = self.db.profile
        self.layout = false
        DHUD4:RegisterModuleOptions(MODNAME, getOptions, L["Warrior Abilities"])
    else
        self:SetEnabledState(false)
        --DHUD4:SetModuleEnabled(MODNAME, false)
    end
end


function DHUD4_Warrior:OnEnable()

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


function DHUD4_Warrior:OnDisable()

	self:UnregisterAllEvents()
    self:HideAll()
end


function DHUD4_Warrior:Refresh()

    --DHUD4:Debug(MODNAME, "Refresh")
    self.side = db.side
    self.scale = db.scale
    self.fontSize = db.fontSize
    self:_Refresh()

    if (self.layout) then
        self:SetLayout()
    else
        if ( db.sunders ) then
            self:SetUpBuffs(MAX_SUNDER_ARMOR)
            if UnitExists("target") then
                self:PLAYER_TARGET_CHANGED()
            else
                self:HideAll()
            end
            self:RegisterEvent("PLAYER_TARGET_CHANGED")
            self:RegisterEvent("UNIT_AURA")
        end
    end
end


function DHUD4_Warrior:PLAYER_TARGET_CHANGED(event)

	--DHUD4:Debug("DHUD4_Warrior:PLAYER_TARGET_CHANGED")
	if ( UnitExists("target")) then
		self:UpdateDebuff("Sunder Armor", db.sundersTimer, db.tips)
    else
        self:HideAll()
	end
end


function DHUD4_Warrior:UNIT_AURA(event, who)
    
	if (who == "target") then
		self:UpdateDebuff("Sunder Armor", db.sundersTimer, db.tips)
    end
end


function DHUD4_Warrior:SetLayout()

    self.layout = true
    self:UnregisterAllEvents()
    self:HideAll()
    if (db.sunders) then
        self:_SetLayout(MAX_SUNDER_ARMOR, true)
    end
end


function DHUD4_Warrior:EndLayout()

    self.layout = false
    self:Refresh()
end
