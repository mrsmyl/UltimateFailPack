--[[
DHUD4_Pet.lua
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
--]]
local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4");
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4");
local DogTag = LibStub("LibDogTag-3.0");

local MODNAME = "DHUD4_Pet";
local DHUD4_Pet = DHUD4:NewModule(MODNAME, "AceEvent-3.0");
local VERSION = tonumber(("$Rev: 105 $"):match("%d+"));

local unpack = unpack
local _G = _G
local string_match = string.match
local string_len = string.len

--Fonts
local MAXFONT = 25
local MINFONT = 6

local TEXTURES = {
    {--unHappy
        0.375,0.5625,0,0.359375
    },
    { --normal
        0.1875,0.375,0,0.359375
    },
    { --happy
        0,0.1875,0,0.359375
    }
}

--Local Defaults
local db
local defaults = {
	profile = {
        blizPet = true,
        pet = "c",
		--icon = true,
		layout = "HLPR",
		healthBarText = true,
		powerBarText = true,
		healthTextStyle = "[FractionalHP] ([PercentHP:Percent])",
		healthCustomTextStyle = "",
		powerTextStyle = "[FractionalMP] ([PercentMP:Percent])",
		powerCustomTextStyle = "",
		vehicle = true,
		vehBars =  "player",
		barTextSize = 10,
		colors = {
			["0"] = {
                f = {r=0,g=1,b=1},
                h = {r=0,g=0,b=1},
                l = {r=1,g=0,b=1},
            },
            ["1"] = {
                f = {r=1,g=0,b=0},
                h = {r=1,g=0.23,b=0.23},
                l = {r=1,g=0.42,b=0.42},
            },
            ["2"] = {
	            f = {r=0.67,g=0.27,b=0},
	            h = {r=0.67,g=0.27,b=0},
	            l = {r=0.67,g=0.27,b=0}
	        },
            ["3"] = {
                f = {r=1,g=1,b=0},
                h = {r=1,g=1,b=0.23},
                l = {r=1,g=1,b=0.42},
            },
            ["6"] = {
                f = {r=0,g=0.68,b=0.87},
                h = {r=0.23,g=0.71,b=0.84},
                l = {r=0.47,g=0.75,b=0.81},
            },
            ["7"] = {
                f = {r=0,g=1,b=0},
                h = {r=1,g=1,b=0},
                l = {r=1,g=0,b=0},
            },
		},
	}
}


-- Functions required by the configuration options table
local OptGetter, OptSetter, ColorGetter, ColorSetter, SelectGetter, SelectSetter;
do
	local mod = DHUD4_Pet
	function OptGetter(info)
		local key = info[#info]
		return db[key]
	end

	function OptSetter(info, value)
		local key = info[#info]
		db[key] = value
		mod:Refresh()
	end

	function SelectGetter (info, select)
        return db[select]
    end

    function SelectSetter (info, select, value)
       db[select] = value
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
        mod:Refresh()
    end
end


--Local Options
local options
local function GetOptions()
	if not options then
        --Options table
    	options = {
    		type = "group",
        name = L["Pet Module"],
        arg = MODNAME,
              order = 3,
        get = OptGetter,
        set = OptSetter,
        --childGroups = "tab",
    		args = {
          header = {
              type = 'description',
              name = L["The pet module manages pet bars and text and happiness icon. The pet bars can track druid mana and vehicle status"],
              order = 1,
          },
          enabled = {
              order = 2,
              type = "toggle",
              name = L["Enable Pet Module"],
              get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
              set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
          },
          layout = {
            type = 'group',
            order = 3,
            name = L["Layout"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            args = {
              blizPet = {
                  type ='toggle',
                  order = 1,
                  name = L["Pet Frame"],
                  desc = L["Show Blizzard's pet frame. If you hide the Player's frame no matter your choice here the Pet Frame will be hidden"],
              },
              pet = {
                type = 'select',
                order = 2,
                name = L["PetBars"],
                desc = L["Place the Pet's bars"],
                set = function (info, value)
                    db[info[#info]] = value
                    if string_match(value, "c") then
                      db.layout = "HLPR";
                    else
                      db.layout = "HIPO";
                    end
                    DHUD4_Pet:Refresh();
                  end,
                values = DHUD4.layoutType,
              },
              layout = {
                type = 'select',
                order = 3,
                name = L["Bar Layout"],
                values = function ()
                    if string_match(db.pet, "c") then
                      return { ["HLPR"] = L["Health Left/Power Right"], ["HRPL"] = L["Health Right/Power Left"] }
                    else
                      return { ["HIPO"] = L["Health Inner/Power Outer"], ["HOPI"] = L["Health Outer/Power Inner"] }
                    end
                  end,
              },
              vehicle = {
                  type = 'toggle',
                  order = 5,
                  name = L["In Vehicle"],
                  desc = L["Use pet bars to track vehicle/player stats"],
              },
            },
          },
          barText = DHUD4:StatusBarMenuOptions(4, not DHUD4:GetModuleEnabled(MODNAME), db),
          colors = {
            type = 'group',
            order = 5,
            name = L["Colors"],
            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
            get = ColorGetter,
            set = ColorSetter,
            args = {
              ["0"] = {
                  type = 'group',
                  name = L["Mana"],
                  args = DHUD4.colorOptions,
              },
              ["1"] = {
                  type = 'group',
                  name = L["Rage"],
                  args = DHUD4.colorOptions,
              },
              ["2"] = {
                  type = 'group',
                  name = L["Focus"],
                  args = DHUD4.colorOptions,
              },
              ["3"] = {
                  type = 'group',
                  name = L["Energy"],
                  args = DHUD4.colorOptions,
              },
              ["6"] = {
                  type = 'group',
                  name = L["Runic Power"],
                  args = DHUD4.colorOptions,
              },
              ["7"] = {
                  type = 'group',
                  name = L["Health"],
                  args = DHUD4.colorOptions,
              },
            },
          },
        },
      }
      options.args.barText.args.barText.get = SelectGetter
      options.args.barText.args.barText.set = SelectSetter
	end
	return options;
end

-- Local functions & Vars
local ConfigLayout, UpdatePetIcon
local happIcon
local healthBar, powerBar
do
	-- Config Bars and Icons
    function ConfigLayout()

        local hbar, hpar, pbar, ppar, iconSide
    	if string_match(db.pet, "c") then
            if string_match(db.layout, "HLPR") then
                hbar, hpar, pbar, ppar = "fl2", DHUD4_LeftFrame, "fr2", DHUD4_RightFrame
                iconSide = "l";
            else
                hbar, hpar, pbar, ppar = "fr2", DHUD4_RightFrame, "fl2", DHUD4_LeftFrame
                iconSide = "r";
            end
        elseif string_match(db.pet, "l") then
            iconSide = "l";
            if string_match(db.layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fl1", DHUD4_LeftFrame, "fl2", DHUD4_LeftFrame
            else
                hbar, hpar, pbar, ppar = "fl2", DHUD4_LeftFrame, "fl1", DHUD4_LeftFrame
            end
        else
            iconSide = "r";
            if string_match(db.layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fr1", DHUD4_RightFrame, "fr2", DHUD4_RightFrame
            else
                hbar, hpar, pbar, ppar = "fr2", DHUD4_RightFrame, "fr1", DHUD4_RightFrame
            end
        end

    	-- Health bar
        healthBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        healthBar:InitStatusBar(hbar, hpar, 0.5)
        healthBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.healthBarText then
            healthBar:InitStatusBarText(hbar, DHUD4:GetPosition(hbar))
        end
        
        -- Power bar
        powerBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        powerBar:InitStatusBar(pbar, ppar, 0.5)
        powerBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.powerBarText then
            powerBar:InitStatusBarText(pbar, DHUD4:GetPosition(pbar))
        end


    end

end

function DHUD4_Pet:OnInitialize()

	self.db = DHUD4.db:RegisterNamespace(MODNAME, defaults)
    db = self.db.profile
	self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
	DHUD4:RegisterModuleOptions(MODNAME, GetOptions, L["Pet"])
    self.layout = false

    -- Bars
    healthBar = DHUD4:CreateStatusBar()
    powerBar = DHUD4:CreateStatusBar()
    DHUD4_Pet.swap = false

end

function DHUD4_Pet:OnEnable()

	--DHUD4:Debug("DHUD4_Pet:OnEnable");
	if not self:IsEnabled() then return end
    self:Refresh()

end

function DHUD4_Pet:OnDisable()

	self:UnregisterAllEvents()
    healthBar:Disable()
    powerBar:Disable()
    self:DisableIcon(happIcon)
end

function DHUD4_Pet:Refresh()

	--DHUD4:Debug(MODNAME, "Refresh");
	if not self:IsEnabled() then return end

    --BlizzFrames
	if ( not db.blizPet and PetFrame:IsShown() ) then
		PetFrame:UnregisterAllEvents();
	    PetFrame:Hide();
	end

    healthBar:Disable()
    powerBar:Disable()
    ConfigLayout()
    if (self.layout) then
        self:SetLayout()
    else
        -- Events of interest
        self:RegisterEvent("UNIT_PET")
        -- Vehicle Swap
        if db.vehicle then
            self:RegisterEvent("UNIT_ENTERED_VEHICLE")
            self:RegisterEvent("UNIT_EXITED_VEHICLE")
        else
            self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
            self:UnregisterEvent("UNIT_EXITED_VEHICLE")
        end
        -- Priority is Pet, Vehicle, Druid
        if ( UnitExists("pet") ) then
            self:UNIT_PET("UNIT_PET", "player")
        elseif ( db.vehicle and UnitInVehicle("player") ) then
            self:UNIT_ENTERED_VEHICLE("UNIT_ENTERED_VEHICLE", "player")
        end
    end
end

function DHUD4_Pet:UNIT_PET(event, who)

	--DHUD4:Debug("Pet", event, who)
	if ((who == "player") and (not UnitInVehicle("player")) ) then
        healthBar:Disable()
        powerBar:Disable()
		if ( UnitExists("pet") ) then
			healthBar:TrackUnitHealth("pet", db.colors[tostring(7)])
            if db.healthBarText then
                healthBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.healthCustomTextStyle) > 0) and db.healthCustomTextStyle or db.healthTextStyle, "pet")
            end
            powerBar:TrackUnitPower("pet", db.colors[tostring(UnitPowerType("pet"))], UnitPowerType("pet"))
            if db.powerBarText then
                powerBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.powerCustomTextStyle) > 0) and db.powerCustomTextStyle or db.powerTextStyle, "pet")
            end
        end
	end
end

function DHUD4_Pet:UNIT_ENTERED_VEHICLE(event, who)

	--DHUD4:Debug("Pet", event, who)
    if who == "player" then
        if ( UnitInVehicle("player") ) then
			--DHUD4:Debug("Pet, PlayerInVehicle")
			self:UnregisterEvent("UNIT_PET")
			self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
			healthBar:Disable()
            powerBar:Disable()
            local unit = self.swap and "player" or "vehicle"
            healthBar:TrackUnitHealth(unit, db.colors[tostring(7)])
            if db.healthBarText then
                healthBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.healthCustomTextStyle) > 0) and db.healthCustomTextStyle or db.healthTextStyle, unit)
            end
            powerBar:TrackUnitPower(unit, db.colors[tostring(UnitPowerType(unit))], UnitPowerType(unit))
            if db.powerBarText then
                powerBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.powerCustomTextStyle) > 0) and db.powerCustomTextStyle or db.powerTextStyle, unit)
            end
        end
    end
end

function DHUD4_Pet:UNIT_EXITED_VEHICLE(event, who)

	--DHUD4:Debug("Pet", event, who)
    if ( who == "player" ) then
		self:RegisterEvent("UNIT_PET")
        healthBar:Disable(true)
        powerBar:Disable(true)
        if ( UnitExists("pet") ) then
            self:UNIT_PET("UNIT_PET", "player")
        end
    end
end


function DHUD4_Pet:SwapPet(swap)
    DHUD4_Pet.swap = swap
end


function DHUD4_Pet:SetLayout()

    self.layout = true
    healthBar:Disable()
    powerBar:Disable()
    healthBar:SetLayout("Pet Health", 100, 80)
    powerBar:SetLayout("Pet Power", 100, 80)
end


function DHUD4_Pet:EndLayout()

    self.layout = false
    self:Refresh()
end

function DHUD4_Pet:LoadRenaitreProfile()
    self.db.profile.powerTextStyle = "[MP]"
    self.db.profile.healthCustomTextStyle = "[HP:Short:Green] [PercentHP:Percent:Paren:HPColor]"
    self.db.profile.barTextSize = 12
    db = self.db.profile
end