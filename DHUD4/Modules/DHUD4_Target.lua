--[[
DHUD4_Target.lua
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
local DogTag = LibStub("LibDogTag-3.0")

local MODNAME = "DHUD4_Target"
local DHUD4_Target = DHUD4:NewModule(MODNAME, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 106 $"):match("%d+"))

local unpack = unpack
local _G = _G
local string_len = string.len
local string_match = string.match

--Fonts
local MAXFONT = 25
local MINFONT = 6
--FIN

local ICONS =  {
    elite = {
        8,
        -50,
        64,
        128,
        0,
        1,
        0,
        1
    },
    pvp = {
        0,
        20,
        40,
        40,
        0,
        1,
        0,
        1,
    },
    raid = {
        0,
        20,
        25,
        25,
        0.6,
        0,
        0,
        0.6
    },
}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
}

--Local Defaults
local db
local defaults = {
	profile = {
        blizTarget = true,
        bars = true,
		npc = true,
        pvpIcon = true,
		raidIcon = true,
		eliteIcon = true,
        target = "c",
        layout = "HLPR",
        --Name plates
        tName = true,
		tStyle = "[Level:DifficultyColor] [Classification] [Name:HostileColor] [isPet ? Creature:ClassColor:Bracket ! isPLayer ? Class:ClassColor:Bracket ! Faction:ClassColor:Bracket]",
		tCStyle = "",
        tnpClicks = true;
		tnpSize = 10,
        totName = true,
		totStyle = "[Level:DifficultyColor] [Classification] [Name:HostileColor] [isPet ? Creature:ClassColor:Bracket ! isPLayer ? Class:ClassColor:Bracket ! Faction:ClassColor:Bracket]",
		totCStyle = "",
        totClicks = false;
		totnpSize = 10,
        --Auras
        swapAuras = false,
		auraTips = false,
		auraCountColor = { 1, 144/255, 0 },
		auraTimerColor = {
			f = { 0, 1, 0 },
			h = { 1, 1, 0 },
			l = { 1, 0, 0 }
		},
		buffs = true,
		buffsOnlyOwn = false,
		buffsCols = 5,
		buffsSize = 20,
		buffCount = 40,
		buffTimer = true,
		debuffs = true,
		debuffsOnlyOwn = false,
		debuffsCols = 5,
		debuffsSize = 20,
		debuffCount = 40,
        debuffTimer = true,
        --Texts
        healthBarText = true,
		powerBarText = true,
		healthTextStyle = "[FractionalHP] ([PercentHP:Percent])",
		healthCustomTextStyle = "",
		powerTextStyle = "[FractionalMP] ([PercentMP:Percent])",
		powerCustomTextStyle = "",
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
	        ["8"] = {
	            f = {r=0.8,g=0.8,b=0.8 },
	            h = {r=0.73,g=0.73,b=0.73 },
	            l = {r=0.67,g=0.67,b=0.67 }
	        },
            spell = {r=179/255,g=31/255,b=234/255 },
            delay = {r=1,g=0,b=0},
            cast = {
                f = {r=0,g=1,b=1},
                h = {r=0,g=0,b=1},
                l = {r=1,g=0,b=1}
            },
		},
        cast = true,
        castSide = "l",
        castPos = "i",
        castRev = false,
        castSpell = true,
        castTimer = true,
        castDelay = true,
        castTextSize = 12,
        -- Range
        range = true,
        rangeBar = "h",
        rangeColors = {
			["0"] = {r=0,g=1,b=0},--0,255,0
            ["1"] = {r=0,g=0.6,b=0.6},--0,153,153
            ["2"] = {r=0.8,g=1,b=0},--204,255,0
            ["3"] = {r=0.8,g=0.4,b=0.6},--204,102,153
            ["4"] = {r=0.6,g=0,b=0},--153,0,0
        },
        -- Class
        class = true,
        classBar = "p",
    }
}
--FIN

-- Functions required by the configuration options table
local OptGetter, OptSetter, ColorGetter, ColorSetter, SelectGetter, SelectSetter, BarsHidden, NameHidden, TotNameHidden
do
	local mod = DHUD4_Target
	function OptGetter(info)
		local key = info[#info];
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
        mod:Refresh();
    end

    function BarsHidden()
        return not db.bars
    end

    function NameHidden()
        return not db.tName
    end

    function TotNameHidden()
        return not db.totName
    end

    function tDebuffsEnable()
        return not db.tDebuffs;
    end

end
--FIN

--Local Options
local options
local function GetOptions()
	if not options then
        --Options table
    	options = {
    		type = "group",
			name = L["Target Module"],
			arg = MODNAME,
			get = OptGetter,
			set = OptSetter,
            --childGroups = "tab",
    		args = {
                header = {
                    order = 1,
                    type = 'description',
                    name = L["The target module manages target bars and text, buffs and debuffs, and pvp, raid, and elite icons."],
                },
                enabled = {
                    order = 2,
                    type = "toggle",
                    name = L["Enable Target Module"],
                    get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
                    set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
                },
                layout = {
                    order = 3,
                    type = 'group',
                    name = L["Layout"],
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    args = {
                        blizTarget = {
                            order = 0,
                            type ='toggle',
                            name = L["Target Frame"],
                            desc = L["Show Blizzard's target frame"],
                        },
                        target = {
                            order = 1,
                            type = 'select',
                            name = L["Player/Target Bars"],
                            desc = L["Place the Target's bars. Player module overrides this setting"],
                            set = function (info, value)
                                    db[info[#info]] = value
                                    if string_match(value, "c") then
                                        db.layout = "HLPR"
                                    else
                                        db.layout = "HIPM"
                                    end
                                    DHUD4_Target:Refresh()
                                end,
                            disabled  = DHUD4:GetModuleEnabled("DHUD4_Player"),
                            values = DHUD4.layoutType,
                        },
                        layout = {
                            order = 2,
                            type = 'select',
                            name = L["Bar Layout"],
                            disabled  = DHUD4:GetModuleEnabled("DHUD4_Player"),
                            values = function ()
                                    if string_match(db.target, "c") then
                                        return { ["HLPR"] = L["Health Left/Power Right"], ["HRPL"] = L["Health Right/Power Left"] }
                                    else
                                        return { ["HIPM"] = L["Health Inner/Power Outer"], ["HMPI"] = L["Health Outer/Power Inner"] }
                                    end
                                end,
                        },
                        npc = {
                            order = 3,
                            type = 'toggle',
                            name = L["When NPC"],
                            desc = L["Show/Hide"],
                            hidden = BarsHidden,
                        },
                        icons = {
                            order = 5,
                            type = 'header',
                            name = L["Status Icons"],
                        },
                        pvpIcon = {
                            order = 6,
                            type = 'toggle',
                            name = L["PvP Flag"],
                            desc = L["Show/Hide"],
                            hidden = NameHidden,
                        },
                        raidIcon = {
                            order = 7,
                            type = 'toggle',
                            name = L["Raid Icon"],
                            desc = L["Show/Hide"],
                            hidden = NameHidden,
                        },
                        eliteIcon = {
                            order = 8,
                            type = 'toggle',
                            name = L["Elite Icon"],
                            desc = L["Show/Hide"],
                            hidden = BarsHidden,
                        },
                        targetName = {
                            order = 9,
                            type = 'group',
                            inline = true,
                            name = L["Target Name Plate"],
                            args = {
                                tName = {
                                    order = 1,
                                    type = 'toggle',
                                    name = L["Show"],
                                    desc = L["Show target Name plate"],
                                },
                                tStyle = {
                                    order = 2,
                                    type = 'select',
                                    name = L["Name Style"],
                                    hidden = NameHidden,
                                    values = DHUD4:GetTags("name")
                                },
                                tCStyle = {
                                    order = 3,
                                    type = 'input',
                                    name = L["Custom Name Style"],
                                    desc = L["If set this style will override Name Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"],
                                    hidden = NameHidden,
                                    usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                                },
                                tnpClicks = {
                                    order = 4,
                                    type = 'toggle',
                                    name = L["Enable clicks"],
                                    desc = L["Enabling this option will make the whole name plate non click trough"],
                                    hidden = NameHidden,
                                },
                                tnpSize = {
                                    order = 5,
                                    type = 'range',
                                    name = L["Text Size"],
                                    hidden = NameHidden,
                                    min = MINFONT,
                                    max = MAXFONT,
                                    step = 1,
                                },
                            },
                        },
                        totName = {
                            order = 10,
                            type = 'group',
                            name = L["Target Target Name Plate"],
                            inline = true,
                            args = {
                                totName = {
                                    order = 1,
                                    type = 'toggle',
                                    name = L["Show"],
                                    desc = L["Show target of target Name plate"],
                                },
                                totStyle = {
                                    order = 2,
                                    type = 'select',
                                    name = L["Name Style"],
                                    hidden = TotNameHidden,
                                    values = DHUD4:GetTags("name")
                                },
                                totCStyle = {
                                    order = 3,
                                    type = 'input',
                                    name = L["Custom Name Style"],
                                    desc = L["If set this style will override Name Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"],
                                    hidden = TotNameHidden,
                                    usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                                },
                                totClicks = {
                                    order = 5,
                                    type = 'toggle',
                                    name = L["Enable clicks"],
                                    desc = L["Enabling this option will make the whole name plate non click trough"],
                                    hidden = NameHidden,
                                },
                                totnpSize = {
                                    order = 5,
                                    type = 'range',
                                    name = L["Text Size"],
                                    hidden = TotNameHidden,
                                    min = MINFONT,
                                    max = MAXFONT,
                                    step = 1,
                                },
                            },
                        },
                    },
                },
                auras = {
                    order = 4,
                    type = 'group',
                    name = L["Auras"],
                    --childGroups = "tab",
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    hidden = function ()
                            return NameHidden();
                        end,
                    args = {
                        swapAuras = {
                            order = 1,
                            type = 'toggle',
                            name = L["Swap Target Auras"],
                            desc = L["Change Auras's side"],
                        },
                        auraTips = {
                            order = 2,
                            type = 'toggle',
                            name = L["Show Aura Tips"],
                            desc = L["Show/Hide"],
                        },
                        buffs = {
                            order = 3,
                            type = "group",
                            name = L["Buffs"],
                            args = {
                                buffs = {
                                    order = 1,
                                    type = 'toggle',
                                    name = L["Show"],
                                    desc = L["Show/Hide"],
                                },
                                buffsOnlyOwn = {
                                    order = 2,
                                    type = 'toggle',
                                    name = L["Only Mine"],
                                    desc = L["Only show buffs cast by me"],
                                },
                                buffTimer = {
                                    order = 3,
                                    type = 'toggle',
                                    name = L["Timer"],
                                    desc = L["Show/Hide Timer"],
                                },
                                buffCount = {
                                    order = 4,
                                    type = 'range',
                                    name = L["Number of Buffs"],
                                    min = 5,
                                    max = 40,
                                    step = 1,
                                },
                                buffsCols = {
                                    order = 5,
                                    type = 'range',
                                    name = L["Columns"],
                                    min = 3,
                                    max = 10,
                                    step = 1,
                                },
                                buffsSize = {
                                    order = 6,
                                    type = 'range',
                                    name = L["Size"],
                                    min = 10,
                                    max = 50,
                                    step = 2,
                                },
                            },
                        },
                        debuffs = {
                            type = "group",
                            order = 4,
                            name = L["Debuffs"],
                            args = {
                                debuffs = {
                                    order = 1,
                                    type = 'toggle',
                                    name = L["Show"],
                                    desc = L["Show/Hide"],
                                },
                                debuffsOnlyOwn = {
                                    order = 2,
                                    type = 'toggle',
                                    name = L["Only Mine"],
                                    desc = L["Only show debuffs applied by me"],
                                    hidden = NameHidden,
                                },
                                debuffTimer = {
                                    order = 3,
                                    type = 'toggle',
                                    name = L["Timer"],
                                    desc = L["Show/Hide Timer"],
                                },
                                debuffCount = {
                                    order = 4,
                                    type = 'range',
                                    name = L["Number of Debuffs"],
                                    min = 5,
                                    max = 40,
                                    step = 1,
                                },
                                debuffsCols = {
                                    order = 5,
                                    type = 'range',
                                    name = L["Columns"],
                                    min = 3,
                                    max = 10,
                                    step = 1,
                                },
                                debuffsSize = {
                                    order = 6,
                                    type = 'range',
                                    name = L["Size"],
                                    min = 20,
                                    max = 50,
                                    step = 2,
                                },
                            },
                        },

                    },
                },
                barText = DHUD4:StatusBarMenuOptions(5, not DHUD4:GetModuleEnabled(MODNAME), db),
                cast = {
                    type = "group",
                    name = L["Cast Bar"],
                    order = 6,
                    get = OptGetter,
                    set = OptSetter,
                    args = {
                        cast = {
                            order = 1,
                            type = 'toggle',
                            name = L["Cast Bar"],
                            desc = L["Show/Hide Player cast bar"],
                        },
                        castSide = {
                            order = 2,
                            type = 'select',
                            name = L["Side"],
                            desc = L["Side to show the cast bar, Player bar has precedence"],
                            values = function ()
                                    if ( DHUD4:GetModuleEnabled("DHUD4_Player") ) then
                                        local player = DHUD4:GetModule("DHUD4_Player")
                                        local _, _, castSide, castPos = player:GetLayout()
                                        if (castPos == db.castPos) then
                                            if ( castSide == "r" ) then
                                                return {["l"] = L["Left"]}
                                            elseif ( castSide == "l" ) then
                                                return {["r"] = L["Right"]}
                                            end
                                        else
                                            return {["l"] = L["Left"], ["r"] = L["Right"]}
                                        end
                                    else
                                        return {["l"] = L["Left"], ["r"] = L["Right"]}
                                    end
                                end,
                            disabled  = function() return not db.cast end,
                        },
                        castPos = {
                            order = 3,
                            type = 'select',
                            name = L["Position"],
                            desc = L["Position of the cast bar, Player bar has precedence"],
                            values = function ()
                                    if ( DHUD4:GetModuleEnabled("DHUD4_Player") ) then
                                        local player = DHUD4:GetModule("DHUD4_Player")
                                        local _, _, castSide, castPos = player:GetLayout()
                                        if ( castSide == db.castSide ) then
                                            if ( castPos == "m" ) then
                                                return {["i"] = L["Inner"]}
                                            elseif ( castPos == "i" ) then
                                                return {["m"] = L["Middle"]}
                                            end
                                        else
                                            return {["i"] = L["Inner"], ["m"] = L["Middle"]}
                                        end
                                    else
                                        return {["i"] = L["Inner"], ["m"] = L["Middle"]}
                                    end
                                end,
                            disabled = function() return not db.cast end,
                        },
                        castRev = {
                            order = 4,
                            type = 'toggle',
                            name = L["Reverse"],
                            desc = L["Cast bars fills in reverse direction"],
                            disabled = function() return not db.cast end,
                        },
                        castSpell = {
                            order = 5,
                            type = 'toggle',
                            name = L["Show spell name"],
                            disabled = function() return not db.cast end,
                        },
                        castTimer = {
                            order = 6,
                            type = 'toggle',
                            name = L["Show cast timer"],
                            disabled = function() return not db.cast end,
                        },
                        castDelay = {
                            order = 7,
                            type = 'toggle',
                            name = L["Show cast delay"],
                            disabled = function() return not db.cast end,
                        },
                        castTextSize = {
                            order = 8,
                            type = 'range',
                            name = L["Font size"],
                            min = MINFONT,
                            max = MAXFONT,
                            disabled = function() return not db.cast end,
                            hidden = function() return not (db.castSpell or db.castTimer or db.castDelay) end,
                            step = 1,
                        },
                        colors = {
                            order = 9,
                            type = 'group',
                            name = L["Colors"],
                            disabled = function() return not db.cast end,
                            inline = true,
                            get = function (info)
                                    local key1, key2 = info[#info-1], info[#info]
                                    return db[key1][key2].r, db[key1][key2].g, db[key1][key2].b
                                end,
                            set = function (info, r, g, b)
                                    local key1, key2 = info[#info-1], info[#info]
                                    db[key1][key2].r = r
                                    db[key1][key2].g = g
                                    db[key1][key2].b = b
                                    mod:Refresh()
                                end,
                            args = {
                                spell = {
                                    order = 1,
                                    type = 'color',
                                    name = L["Spell Name"],
                                    disabled = function() return not db.castSpell end,
                                },
                                delay = {
                                    order = 2,
                                    type = 'color',
                                    name = L["Delay Time"],
                                    disabled = function() return not db.castDelay end,
                                },
                                cast = {
                                    order = 3,
                                    type = 'group',
                                    name = L["Cast"],
                                    args = {
                                        f = {
                                            order = 1,
                                            type = 'color',
                                            name = L["Complete"],
                                        },
                                        h = {
                                            order = 2,
                                            type = 'color',
                                            name = L["Half Time"],
                                        },
                                        l = {
                                            order = 3,
                                            type = 'color',
                                            name = L["Begin"],
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
                colors = {
                    order = 7,
                    type = 'group',
                    name = L["Bar Colors"],
                    get = ColorGetter,
                    set = ColorSetter,
                    hidden = BarsHidden,
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
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
                        ["8"] = {
                            type = 'group',
                            name = L["Tapped"],
                            args = DHUD4.colorOptions,
                        },
                    },
                },
                range = {
                    order = 8,
                    type = 'group',
                    name = L["Target Range"],
                    hidden = BarsHidden,
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    args = {
                        info = {
                            order = 0,
                            type = "description",
                            name = L["Ranges are approximate and can vary according to class, race, spec, etc."],
                        },
                        range = {
                            order = 1,
                            type = 'toggle',
                            name = L["Range"],
                            desc = L["Use bar border to display range information"],
                        },
                        rangeBar = {
                            order = 2,
                            type = 'select',
                            name = L["Bar"],
                            values = {["h"] = L["Health"], ["p"] = L["Power"]}
                        },
                        rangeColors = {
                            order = 2,
                            type = 'group',
                            name = L["Range Colors"],
                            get = function (info)
                                    local key1, key2 = info[#info-1], info[#info]
                                    return db[key1][key2].r, db[key1][key2].g, db[key1][key2].b
                                end,
                            set = function (info, r, g, b)
                                    local key1, key2 = info[#info-1], info[#info]
                                    db[key1][key2].r = r
                                    db[key1][key2].g = g
                                    db[key1][key2].b = b
                                    DHUD4_Target:Refresh()
                                end,
                            hidden = BarsHidden,
                            disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                            args = {
                                ["0"] = {
                                    type = 'color',
                                    name = L["Breath you"],
                                    desc = L["Roughly 0 ~ 8 yards"],
                                    order = 1,
                                },
                                ["1"] = {
                                    type = 'color',
                                    name = L["Hear you"],
                                    desc = L["Roughly 8 ~ 25 yards"],
                                    order = 2,
                                },
                                ["2"] = {
                                    type = 'color',
                                    name = L["See you"],
                                    desc = L["Roughly 25 ~ 45 yards"],
                                    order = 3,
                                },
                                ["3"] = {
                                    type = 'color',
                                    name = L["Feel you"],
                                    desc = L["Roughly 45 ~ 60 yards"],
                                    order = 4,
                                },
                                ["4"] = {
                                    type = 'color',
                                    name = L["Lost you"],
                                    desc = L["Roughly 60 ~ 80 yards"],
                                    order = 5,
                                },
                            },
                        },
                    }
                },
                class = {
                    order = 9,
                    type = 'group',
                    name = L["Class Color"],
                    hidden = BarsHidden,
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    args = {
                        info = {
                            order = 0,
                            type = "description",
                            name = L["Color the bar border according to the class"],
                        },
                        class = {
                            order = 1,
                            type = 'toggle',
                            name = L["Enabled"],
                            desc = L["Use bar border to display class color"],
                        },
                        classBar = {
                            order = 2,
                            type = 'select',
                            name = L["Bar"],
                            values = {["h"] = L["Health"], ["p"] = L["Power"]}
                        },
                    },
                },--]]
            },
        }
        options.args.barText.args.barText.get = SelectGetter
        options.args.barText.args.barText.set = SelectSetter
        options.args.cast.args.colors.args.cast.get = ColorGetter
        options.args.cast.args.colors.args.cast.set = ColorSetter
    end

    return options;
end
--FIN

-- Local Varaibles and functions
local ConfigLayout, CreatePvpIcon, CreateRaidIcon, CreateEliteIcon, TargetDropDownInit, UpdateTargetAuras, UpdateAuraPositions, UpdateEliteIcon, UpdateTargetPvP, UpdateRaidIcon, CreateNamePlate
local healthBar, powerBar, castBar
local eliteIcon, tnp, totnp, pvpIcon, raidIcon
local buffs, debuffs = {}, {}
do
    function CreateNamePlate(name, y)

        local frame = CreateFrame("Button", "DHUD4_"..name, DHUD4_MainFrame)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", DHUD4_MainFrame, "CENTER", 0, y)
        frame:SetHeight(14)
        frame:SetWidth(256)
        frame:EnableMouse(false)
        local clickFrame = CreateFrame("Button", "DHUD4_"..name.."Click", frame, "SecureUnitButtonTemplate")
        clickFrame:ClearAllPoints()
        clickFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
        clickFrame:SetHeight(14)
        clickFrame:SetWidth(14)
        --local bgt = clickFrame:CreateTexture("DHUD4_"..name.."ClickT", "OVERLAY")
        --bgt:SetBlendMode("BLEND")
        --bgt:ClearAllPoints()
        --bgt:SetAllPoints()
        --bgt:SetTexture("Interface\\AddOns\\DHUD4\\icon")
        frame.clicks = clickFrame
        local font = frame:CreateFontString("DHUD4_"..name.."_Text", "OVERLAY")
        font:SetFontObject(GameFontHighlight)
        font:ClearAllPoints()
        font:SetPoint("CENTER", frame, "CENTER", 0, 0)
        font:SetJustifyH("CENTER")
        font:SetJustifyV("BOTTOM")
        font:SetWidth(246)
        font:Show()
        frame.text = font
        return frame
    end

    -- Config Bars and Icons
    function ConfigLayout()
        --DHUD4:Debug("ConfigBars");
        local hbar, hpar, pbar, ppar, iconSide, layout, target, castSide, castPos
        if DHUD4:GetModuleEnabled("DHUD4_Player") then
            local player = DHUD4:GetModule("DHUD4_Player")
            target, layout = player:GetLayout()
            -- Switch sides, since we are reading the player layout
            if (target == "r" ) then
                target = "l"
            elseif (target == "l") then
                target = "r"
            end
        else
            target, layout = db.target, db.layout
            castSide, castPos = db.castSdie, db.castPos
        end
    	if string_match(target, "c") then
            if string_match(layout, "HLPR") then
                hbar, hpar, pbar, ppar = "fl4", DHUD4_LeftFrame, "fr4", DHUD4_RightFrame
                iconSide = "r";
    		else
                hbar, hpar, pbar, ppar = "fr4", DHUD4_RightFrame, "fl4", DHUD4_LeftFrame
                iconSide = "l";
    		end
    	elseif string_match(target, "l") then
            iconSide = "l";
    	    if string_match(layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fl3", DHUD4_LeftFrame, "fl4", DHUD4_LeftFrame
    		else
                hbar, hpar, pbar, ppar ="fl4", DHUD4_LeftFrame, "fl3", DHUD4_LeftFrame
            end
    	else
            iconSide = "r";
            if string_match(layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fr3", DHUD4_RightFrame, "fr4", DHUD4_RightFrame
            else
                hbar, hpar, pbar, ppar = "fr4", DHUD4_RightFrame, "fr3", DHUD4_RightFrame
            end
        end

        -- Icons
        if db.pvpIcon then
            DHUD4_Target:RegisterEvent("UNIT_FACTION")
            CreatePvpIcon("c")
        else

        end
        if db.raidIcon then
            CreateRaidIcon()
            DHUD4_Target:RegisterEvent("RAID_TARGET_UPDATE")
        end
        if db.eliteIcon then
            CreateEliteIcon(iconSide)
        end

        -- Health bar
        healthBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        healthBar:InitStatusBar(hbar, hpar)
        healthBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.healthBarText then
            healthBar:InitStatusBarText(hbar, DHUD4:GetPosition(hbar))
            healthBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(),
                (string_len(db.healthCustomTextStyle) > 0) and db.healthCustomTextStyle or db.healthTextStyle, "target")
        end
        
        -- Power bar
        powerBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        powerBar:InitStatusBar(pbar, ppar)
        powerBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.powerBarText then
            powerBar:InitStatusBarText(pbar, DHUD4:GetPosition(pbar))
            powerBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(),
                (string_len(db.powerCustomTextStyle) > 0) and db.powerCustomTextStyle or db.powerTextStyle, "target")
        end

        -- Enable bar pop events
        healthBar.frame:SetScript("OnShow", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
            end)
        healthBar.frame:SetScript("OnHide", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
            end)
        powerBar.frame:SetScript("OnShow", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
            end)
        powerBar.frame:SetScript("OnHide", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
            end)

        -- Target and TargetofTarget Tags
        if ( db.tName ) then
            tnp.text:SetFont(DHUD4:GetFont(), db.tnpSize * DHUD4.GetScale())
            local tagCode = (string_len(db.tCStyle) > 0) and db.tCStyle or db.tStyle
            DogTag:AddFontString(tnp.text, tnp, tagCode, "Unit", { unit = "target" } )
            --DogTag:AddCallback(tagCode, DHUD4_Target.AdjustTNPWidth, "Unit", { unit = "target" })
            
            if (db.tnpClicks) then
                SecureUnitButton_OnLoad(tnp.clicks, "target", function()
                    ToggleDropDownMenu(1, nil, TargetFrameDropDown, tnp.clicks, 0, 0)
                end)
                RegisterUnitWatch(tnp.clicks)
                tnp.clicks:RegisterForClicks("AnyUp")
            else
                tnp.clicks:RegisterForClicks("")
                tnp.clicks:Hide()
            end
            --]]
        else
            DogTag:RemoveFontString(tnp.text)
            tnp.clicks:RegisterForClicks("")
            UnregisterUnitWatch(tnp.clicks)
        end
        if ( db.totName ) then
            totnp.text:SetFont(DHUD4:GetFont(), db.totnpSize * DHUD4.GetScale())
            local tagCode = (string_len(db.totCStyle) > 0) and db.totCStyle or db.totStyle
            DogTag:AddFontString(totnp.text, totnp, tagCode, "Unit", { unit = "targettarget" } )
            --DogTag:AddCallback(tagCode, DHUD4_Target.AdjustTNPWidth, "Unit", { unit = "targettarget" })
            
            if (db.totClicks) then
                SecureUnitButton_OnLoad(totnp.clicks, "targettarget", function()
                    ToggleDropDownMenu(1, nil, TargetFrameDropDown, totnp.clicks, 0, 0)
                end)
                RegisterUnitWatch(totnp.clicks)
                totnp.clicks:RegisterForClicks("AnyUp")
            else
                totnp.clicks:RegisterForClicks("")
                totnp.clicks:Hide()
            end
            --]]
        else
            DogTag:RemoveFontString(totnp.text)
            totnp.clicks:RegisterForClicks("")
            UnregisterUnitWatch(totnp.clicks)
        end
        
         -- Cast Bar
        if db.cast then
            local bar, parent
            if ( DHUD4:GetModuleEnabled("DHUD4_Player") ) then
                local player = DHUD4:GetModule("DHUD4_Player")
                local _, _, playerSide, playerPos = player:GetLayout()
                if ( playerSide == db.castSide ) then
                    if ( playerPos == "i" ) then
                        db.castPos = "m"
                    else
                        db.castPos = "i"
                    end
                elseif ( playerPos == db.castPos ) then
                    if ( playerSide == "r" ) then
                        db.castSide = "l"
                    else
                        db.castSide = "r"
                    end
                end
            end
            bar = (db.castSide == "r") and "cr" or "cl"
            bar = (db.castPos == "i") and bar.."3" or bar.."4"
            parent = (db.castSide == "r") and DHUD4_RightFrame or DHUD4_LeftFrame
            castBar:InitCastBar(bar, parent, db.castRev)
            castBar:InitCastBarText(bar, db.castTimer, db.castSpell, db.castDelay, db.colors.spell, db.colors.delay)
            castBar:ConfigBarText(DHUD4:GetFont(), db.castTextSize * DHUD4.GetScale())
        end

        -- Range
        if (db.range) then
            if (db.rangeBar == "h") then
                healthBar:TrackUnitRange(db.rangeColors, "target")
            elseif (db.rangeBar == "p") then
                powerBar:TrackUnitRange(db.rangeColors, "target")
            end
        else
            healthBar:TrackUnitRange()
            powerBar:TrackUnitRange()
        end

        -- Class
        if (db.class) then
            if (db.classBar == "h") then
                healthBar:TrackUnitClass("target")
                DHUD4_Target.class = healthBar
            elseif (db.classBar == "p") then
                powerBar:TrackUnitClass("target")
                DHUD4_Target.class = powerBar
            end
        else
            healthBar:TrackUnitClass()
            powerBar:TrackUnitClass()
            self.class = nil
        end
    end

    function CreatePvpIcon()

        if (pvpIcon == nil) then
            --Target PvP
            pvpIcon = CreateIcon("pvp", "c")
            pvpIcon.name = "pvp"
            pvpIcon:Hide()
        end
    end

    function CreateRaidIcon()

        if (raidIcon == nil) then
            raidIcon = CreateIcon("raid", "c")
            raidIcon.name = "raid"
            raidIcon:Hide()
        end
    end

    function CreateEliteIcon(side)

        if ( (eliteIcon == nil) or (eliteIcon.side ~= side) ) then
            eliteIcon = CreateIcon("elite", side)
            local bgt = eliteIcon:CreateTexture("DHUD4_eliteTexture", "OVERLAY")
            bgt:ClearAllPoints()
            bgt:SetPoint("BOTTOM", eliteIcon, "BOTTOM", 0, 0)
            if (side == "l") then
                bgt:SetTexCoord(1,0,0,1)
            else
                bgt:SetTexCoord(0,1,0,1)
            end
            bgt:SetBlendMode("BLEND")
            eliteIcon.background = bgt
            eliteIcon.side = side
            --eliteIcon.name = "elite"
            eliteIcon:Hide()
        end
    end

    function CreateIcon(icon, side)
        local x, y, width, height, x0, x1, y0, y1 = unpack(ICONS[icon]);
        local parent = DHUD4_LeftFrame
        local point = "BOTTOM"
        local relative = "TOP"
        if side == "r" then
            x = -x
            parent = DHUD4_RightFrame
        elseif side == "c" then
            parent = tnp
            point = "CENTER"
            relative = "CENTER"
        end
        local frame = CreateFrame("Button", "DHUD4_t"..icon, parent);
        frame:ClearAllPoints();
        frame:SetPoint(point, parent, relative, x, y);
        frame:SetHeight(height);
        frame:EnableMouse(false)
        frame:SetWidth(width);
        return frame
    end

    -- Update target auras
    function UpdateTargetAuras()

        --DHUD4:Debug("UpdateTargetAuras");
        local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable
        local frame, frameName
        local frameIcon, frameCount, frameCooldown
        local frameStealable
        local playerIsTarget = UnitIsUnit("player", "target")

        local numBuffs = 0
        -- Buffs
		if db.buffs then
	    	for i = 1, db.buffCount do
                name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff("target", i)
                frameName = "DHUD4_TB"..i
                frame = _G[frameName]
                if ( not frame ) then
                    if ( not icon ) then
                        break
                    else
                        local parent
                        if ( i == 1 ) then
                            parent = tnp
                        else
                            parent = _G["DHUD4_TB"..(i-1)]
                        end
                        frame = CreateFrame("Button", frameName, parent, "TargetBuffFrameTemplate")
                        local frameCount = _G[frameName.."Count"]
                        frameCount:SetFontObject(GameFontWhite)
                        frameCount:SetFont(DHUD4:GetFont(), (db.buffsSize/1.3) * DHUD4.GetScale())
                        frameCount:ClearAllPoints()
                        frameCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -db.buffsSize/10, 0)
                        frame.unit = "target"
                    end
                end
                frame:EnableMouse(db.auraTips)
                if ( icon and not ( db.buffsOnlyOwn and not PLAYER_UNITS[caster]) ) then
                    frame:SetID(i)

					-- set the icon
                    frameIcon = _G[frameName.."Icon"]
                    frameIcon:SetTexture(icon)

                    -- set the count
                    frameCount = _G[frameName.."Count"]
                    if ( count > 1 and db.buffCount ) then
                        frameCount:SetText(count)
                        frameCount:Show()
                    else
                        frameCount:Hide()
                    end

                    -- Handle cooldowns
                    frameCooldown = _G[frameName.."Cooldown"]
                    if ( duration > 0 and db.buffTimer ) then
                        frameCooldown:Show()
                        CooldownFrame_SetTimer(frameCooldown, expirationTime - duration, duration, 1)
                    else
                        frameCooldown:Hide()
                    end

                    -- Show stealable frame if the target is not a player and the buff is stealable.
                    frameStealable = _G[frameName.."Stealable"]
                    if ( not playerIsTarget and isStealable ) then
                        frameStealable:Show()
                    else
                        frameStealable:Hide()
                    end

                    -- set the buff to be big if the target is not the player and the buff is cast by the player or his pet
                    frame.large = (not playerIsTarget and PLAYER_UNITS[caster])

                    numBuffs = numBuffs + 1

                    frame:ClearAllPoints()
                    frame:Show()
                else
                    frame:Hide()
                end
	    	end
        end

    	-- DeBuffs
        local color;
        local frameBorder;
        local numDebuffs = 0;
		if db.debuffs then
	    	for i = 1, db.debuffCount do
                name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitDebuff("target", i)
                frameName = "DHUD4_TD"..i
                frame = _G[frameName]
                if ( not frame ) then
                    if ( not icon ) then
                        break
                    else
                        local parent
                        if ( i == 1 ) then
                            parent = tnp
                        else
                            parent = _G["DHUD4_TD"..(i-1)]
                        end
                        frame = CreateFrame("Button", frameName, parent, "TargetDebuffFrameTemplate")
                        local frameCount = _G[frameName.."Count"]
                        frameCount:SetFontObject(GameFontWhite)
                        frameCount:SetFont(DHUD4:GetFont(), (db.debuffsSize/1.3) * DHUD4.GetScale())
                        frameCount:ClearAllPoints()
                        frameCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -db.buffsSize/10, 0)
                        frame.unit = "target"
                    end
                end
                if ( icon and not ( db.debuffsOnlyOwn and not PLAYER_UNITS[caster]) ) then
                    frame:SetID(i)

                    -- set the icon
                    frameIcon = _G[frameName.."Icon"]
                    frameIcon:SetTexture(icon)

                    -- set the count
                    frameCount = _G[frameName.."Count"]
                    if ( count > 1 and db.debuffCount ) then
                        frameCount:SetText(count)
                        frameCount:Show()
                    else
                        frameCount:Hide()
                    end

                    -- Handle cooldowns
                    frameCooldown = _G[frameName.."Cooldown"]
                    if ( duration > 0 and db.debuffTimer ) then
                        frameCooldown:Show()
                        CooldownFrame_SetTimer(frameCooldown, expirationTime - duration, duration, 1)
                    else
                        frameCooldown:Hide()
                    end

                    -- set debuff type color
                    if ( debuffType ) then
                        color = DebuffTypeColor[debuffType]
                    else
                        color = DebuffTypeColor["none"]
                    end
                    frameBorder = _G[frameName.."Border"]
                    frameBorder:SetVertexColor(color.r, color.g, color.b)

                    -- set the debuff to be big if the buff is cast by the player or his pet
                    frame.large = (PLAYER_UNITS[caster])

                    numDebuffs = numDebuffs + 1

                    frame:ClearAllPoints()
                    frame:Show()
                else
                    frame:Hide()
                end
            end
		end

        UpdateAuraPositions(numBuffs, numDebuffs)
    end

    --Update Aura Positions
	function UpdateAuraPositions(numBuffs, numDebuffs)

		--DHUD4:Debug("UpdateAuraPositions", numBuffs, numDebuffs)
		local point, parent, relative, x, y, fSize
		local scale = DHUD4.GetScale()

        --Buffs
        local size, hasLarge
        for i = 1, numBuffs do
            local buff = _G["DHUD4_TB"..i]
            size = buff.large and (db.buffsSize*1.2) or db.buffsSize
            if i == 1 then
				parent = tnp
				x = 5
				y = 0
                hasLarge = hasLarge or buff.large
			else
				local j = (i-1) % db.buffsCols;
				if j == 0 then
					-- New line
					parent = _G["DHUD4_TB"..tonumber(i-db.buffsCols)]
					local offSet = hasLarge and (db.buffsSize*1.2) or db.buffsSize
                    x = -offSet
					y = -offSet - (hasLarge and 5 or 2)
                    hasLarge = false
                    hasLarge = hasLarge or buff.large
				else
					parent = _G["DHUD4_TB"..tonumber(i-1)]
					x = 3
					y = 0
                    hasLarge = hasLarge or buff.large
				end
			end
			if db.swapAuras then
                relative = "TOPRIGHT"
                point = "TOPLEFT"
            else
                x = x * -1
                relative = "TOPLEFT"
                point = "TOPRIGHT"
			end
            --Frame
            buff:SetPoint(point, parent, relative, x, y)
            buff:SetHeight(size)
			buff:SetWidth(size)
        end

        --Debuffs
        for i = 1, numDebuffs do
            local debuff = _G["DHUD4_TD"..i]
            size = debuff.large and (db.debuffsSize*1.2) or db.debuffsSize
            if i == 1 then
				parent = tnp
				x = 5
				y = 0
                hasLarge = hasLarge or debuff.large
			else
				local j = (i-1) % db.debuffsCols
				if j == 0 then
					-- New line
					parent = _G["DHUD4_TD"..tonumber(i - db.debuffsCols)]
                    local offSet = hasLarge and (db.debuffsSize*1.2) or db.debuffsSize
                    x = -offSet
					y = -offSet - (hasLarge and 5 or 2)
                    hasLarge = false
                    hasLarge = hasLarge or debuff.large
				else
					parent = _G["DHUD4_TD"..tonumber(i-1)]
                    x = 4
					y = 0
                    hasLarge = hasLarge or debuff.large
				end
			end
			if db.swapAuras then
                x = x * -1
                relative = "TOPLEFT"
                point = "TOPRIGHT"
            else
                relative = "TOPRIGHT"
                point = "TOPLEFT"
			end
			--Frame
			debuff:SetPoint(point, parent, relative, x, y)
            debuff:SetHeight(size)
			debuff:SetWidth(size)
            local debuffBorder = _G["DHUD4_TD"..i.."Border"]
            debuffBorder:SetWidth(size + 2)
            debuffBorder:SetHeight(size + 2)
        end

	end

    function UpdateEliteIcon(show)
        if eliteIcon then
            local class = UnitClassification("target")
            local path = nil
            --DHUD4:Debug("UpdateEliteIcon", class)
            if ( class and show ) then
                if class == "worldboss" then
                    path = DHUD4:GetCurrentTexture().."boss"
                elseif class == "rareelite" then
                    path = DHUD4:GetCurrentTexture().."rareelite"
                elseif class == "rare" then
                    path = DHUD4:GetCurrentTexture().."rare"
                elseif class == "elite" then
                    path = DHUD4:GetCurrentTexture().."elite"
                end
                if (path) then
                    eliteIcon.background:SetTexture(path)
                    eliteIcon:Show()
                else
                    eliteIcon:Hide()
                end
            else
                eliteIcon:Hide()
            end
        end
    end

    function UpdateTargetPvP(show)

        if pvpIcon then
            local texture = DHUD4:GetPvpTexture("target")
            if ( texture and show ) then
                pvpIcon:SetNormalTexture(texture)
                pvpIcon:Show()
            else
                pvpIcon:Hide()
            end
       end
    end

    function UpdateRaidIcon(show)
        --DHUD4:Debug("RAID_TARGET_UPDATE")
        if raidIcon then
            local index = GetRaidTargetIndex("target");
            if ( index and show) then
                raidIcon:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..index)
                raidIcon:Show()
            else
                raidIcon:Hide()
            end
        end
    end

end

function DHUD4_Target:OnInitialize()

    --DHUD4:Debug("DHUD4_Target:OnInitialize")
	self.db = DHUD4.db:RegisterNamespace(MODNAME, defaults)
	self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
	DHUD4:RegisterModuleOptions(MODNAME, GetOptions, L["Target"])
    self.layout = false
    db = self.db.profile
    -- Bars
    healthBar = DHUD4:CreateStatusBar()
    powerBar = DHUD4:CreateStatusBar()
    castBar = DHUD4:CreateCastBar()

    -- NamePlates
    tnp = CreateNamePlate("tnp", -160)
    local dis = db.tnpSize * DHUD4.GetScale() * 2
    totnp = CreateNamePlate("totnp", -160 - dis)
    tnp:SetAlpha(0)
    totnp:SetAlpha(0)

end

function DHUD4_Target:OnEnable()

    --DHUD4:Debug("DHUD4_Target:OnEnable")
    if not self:IsEnabled() then return end
    self:Refresh()
end

function DHUD4_Target:OnDisable()

    --self:SendMessage("DHUD4_TARGETBARS_HIDE");
    self:UnregisterAllEvents()
    healthBar:Disable()
    powerBar:Disable()
    castBar:Disable()
    self:DisableIcon(raidIcon)
    self:DisableIcon(pvpIcon)
    self:DisableIcon(eliteIcon)

end

function DHUD4_Target:Refresh()

    --BlizzFrames
    if ( not db.blizTarget ) then
        TargetFrame:UnregisterAllEvents()
        ComboFrame:UnregisterAllEvents()
		if TargetofTargetFrame then
			TargetofTargetFrame:UnregisterAllEvents()
		end
        TargetFrame:Hide()
    end
    healthBar:Disable()
    powerBar:Disable()
    castBar:Disable()
    self:DisableIcon(raidIcon)
    self:DisableIcon(pvpIcon)
    self:DisableIcon(eliteIcon)
    ConfigLayout()
    if (self.layout) then
        self:SetLayout()
    else
        if UnitExists("target") then
            self:PLAYER_TARGET_CHANGED()
        else
            healthBar:Hide()
            powerBar:Hide()
        end
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        local frame, frameName, frameCount
        for i = 1, db.buffCount do
            frameName = "DHUD4_TB"..i
            frame = _G[frameName]
            if(frame) then
                frame:EnableMouse(db.auraTips)
            end
            frameCount = _G[frameName.."Count"]
            if ( frameCount ) then
                frameCount:SetFont(DHUD4:GetFont(), (db.buffsSize/1.3) * DHUD4.GetScale())
            end

        end
        for i = 1, db.debuffCount do
            frameName = "DHUD4_TD"..i
            frame = _G[frameName]
            if(frame) then
                frame:EnableMouse(db.auraTips)
            end
            frameCount = _G[frameName.."Count"]
            if ( frameCount ) then
                frameCount:SetFont(DHUD4:GetFont(), (db.buffsSize/1.3) * DHUD4.GetScale())
            end
        end
        -- Auras
        if( db.buffs or db.debuffs) then
            self:RegisterEvent("UNIT_AURA");
        end
    end
end

function DHUD4_Target:DisableIcon(icon)
    if (icon) then
        icon:UnregisterAllEvents()
        icon:Hide()
    end
end


function DHUD4_Target:PLAYER_TARGET_CHANGED()

    healthBar:Disable(true)
    powerBar:Disable(true)
    castBar:Disable()
    if ( UnitExists("target") and db.bars and not ( DHUD4:UnitIsNPC("target") and not db.npc) ) then
        if ( UnitIsTapped("target") and ( not UnitIsTappedByPlayer("target") ) ) then
            healthBar:TrackUnitHealth("target", db.colors[tostring(8)])
            powerBar:TrackUnitPower("target", db.colors[tostring(8)], UnitPowerType("target"))
        else
            healthBar:TrackUnitHealth("target", db.colors[tostring(7)])
            powerBar:TrackUnitPower("target", db.colors[tostring(UnitPowerType("target"))], UnitPowerType("target"))
		end
        if(db.tName) then
            UpdateTargetAuras()
        end
        UpdateEliteIcon(true)
        UpdateTargetPvP(true)
        UpdateRaidIcon(true)
        if (db.cast) then
            castBar:TrackUnitCast("target", db.colors.cast)
            castBar:startCast()
        end
        tnp:SetAlpha(db.tName and 1 or 0)
        totnp:SetAlpha((db.totName and UnitExists("targettarget")) and 1 or 0)
        if ( UnitIsEnemy("target", "player") ) then
            PlaySound("igCreatureAggroSelect")
        elseif ( UnitIsFriend("player", "target") ) then
            PlaySound("igCharacterNPCSelect")
        else
            PlaySound("igCreatureNeutralSelect")
        end
        if(db.class)then
            self.class:SetClassColor();
        end
    else
        tnp:SetAlpha(0)
        totnp:SetAlpha(0)
        UpdateEliteIcon(false)
        UpdateTargetPvP(false)
        UpdateRaidIcon(false)
    end
end

function DHUD4_Target:UNIT_TARGET(event, unit)

	if ( unit == "target" ) then
        totnp:SetAlpha((db.totName and UnitExists("targettarget")) and 1 or 0)
	end
end

function DHUD4_Target:UNIT_FACTION(event, unit)

    --DHUD4:Debug("DHUD4_Target, UNIT_FACTION", unit)
    if ( unit == "target" ) then
		UpdateTargetPvP(true)
    else
        UpdateTargetPvP(false)
    end
end

function DHUD4_Target:UNIT_AURA(event, unit)

	--self:Debug("UNIT_AURA", unit)
    if ( unit == "target" ) then
	    UpdateTargetAuras()
    end
end

function DHUD4_Target:RAID_TARGET_UPDATE(event)

        UpdateRaidIcon(true)
end

function DHUD4_Target:DisableIcon(icon)

    if (icon) then
        icon:UnregisterAllEvents()
        icon:Hide()
    end
end

function DHUD4_Target:SetLayout()

    self.layout = true
    self:UnregisterAllEvents()
    healthBar:SetLayout("Target Health", 100, 80)
    powerBar:SetLayout("Target Power", 100, 80)
    if(db.cast and castBar) then
        castBar:SetLayout("Target",10, 3.9)
    end
    if (eliteIcon and db.eliteIcon) then
        eliteIcon.background:SetTexture(DHUD4:GetCurrentTexture().."boss")
        eliteIcon:Show()
    end
    if (raidIcon and db.raidIcon) then
        raidIcon:Show()
    end
    if (pvpIcon and db.pvpIcon) then
        pvpIcon:SetNormalTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
        pvpIcon:Show()
    end
    if (tnp) then
        tnp:Show()
    end
    if (totnp) then
        totnp:Show()
    end
    local frame, frameName, frameIcon
    -- Buffs
    for i = 1, 40 do
        frameName = "DHUD4_TB"..i
        frame = _G[frameName]
        if (i <= db.buffCount) then
            if ( not frame ) then
                local parent
                if ( i == 1 ) then
                    parent = tnp
                else
                    parent = _G["DHUD4_TB"..(i-1)]
                end
                frame = CreateFrame("Button", frameName, parent, "TargetBuffFrameTemplate")
                local frameCount = _G[frameName.."Count"]
                frameCount:SetFontObject(GameFontWhite)
                frameCount:SetFont(DHUD4:GetFont(), (db.buffsSize/1.3) * DHUD4.GetScale())
                frameCount:ClearAllPoints()
                frameCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -db.buffsSize/10, 0)
                frame.unit = "target"
            end
            -- set the icon
            frameIcon = _G[frameName.."Icon"]
            frameIcon:SetTexture("Interface\\AddOns\\DHUD4\\icon")
            frame:Show()
        else
            if (frame) then frame:Hide() end
        end
    end
    for i = 1, 40 do
        frameName = "DHUD4_TD"..i
        frame = _G[frameName]
        if (i <= db.debuffCount) then
            if ( not frame ) then
                local parent
                if ( i == 1 ) then
                    parent = tnp
                else
                    parent = _G["DHUD4_TD"..(i-1)]
                end
                frame = CreateFrame("Button", frameName, parent, "TargetDebuffFrameTemplate")
                local frameCount = _G[frameName.."Count"]
                frameCount:SetFontObject(GameFontWhite)
                frameCount:SetFont(DHUD4:GetFont(), (db.debuffsSize/1.3) * DHUD4.GetScale())
                frameCount:ClearAllPoints()
                frameCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -db.buffsSize/10, 0)
                frame.unit = "target"
            end
            -- set the icon
            frameIcon = _G[frameName.."Icon"]
            frameIcon:SetTexture("Interface\\AddOns\\DHUD4\\icon")
            frame:Show()
        else
            if (frame) then frame:Hide() end
        end
    end
    UpdateAuraPositions(db.buffCount, db.debuffCount)

end

function DHUD4_Target:EndLayout()

    self.layout = false
    for i = 1, 40 do
        frameName = "DHUD4_TB"..i
        frame = _G[frameName]
        if (i <= db.buffCount) then
            if (frame) then frame:Hide() end
        end
    end
    for i = 1, 40 do
        frameName = "DHUD4_TD"..i
        frame = _G[frameName]
        if (i <= db.debuffCount) then
            if (frame) then frame:Hide() end
        end
    end
    self:Refresh()
end

function DHUD4_Target:GetBars()
    --DHUD4:Debug("DHUD4_Player:GetBars()", healthBar.bar, powerBar.bar)
    return healthBar.frame:IsVisible(),healthBar.frame.bar, powerBar.frame.bar
end

function DHUD4_Target:LoadRenaitreProfile()
    self.db.profile.auras = false
	self.db.profile.castTextSize = 14
    self.db.profile.pvpIcon = false
    self.db.profile.healthCustomTextStyle = "[HP:Short:Green] [PercentHP:Percent:Paren:HPColor]"
    self.db.profile.totName = false
    self.db.profile.castSide = "r"
    self.db.profile.barTextSize = 14
    self.db.profile.powerTextStyle = "[MP]"
    self.db.profile.rangeColors["1"] = {
							["b"] = 1,
							["g"] = 0,
							["r"] = 0.6,
						}
    self.db.profile.rangeColors["3"] = {
							["b"] = 0,
							["g"] = 0.8196078431372549,
							["r"] = 1,
						}
    self.db.profile.rangeColors["2"] = {
                            ["b"] = 0,
							["g"] = 0.5019607843137255,
							["r"] = 1,
						}
	self.db.profile.tName = false
    self.db.profile.healthTextStyle = "[HP] ([PercentHP:Percent])"
    self.db.profile.colors.spell = {
							["b"] = 0.7019607843137254,
							["g"] = 0.7019607843137254,
							["r"] = 0,
						}
    self.db.profile.eliteIcon = false
    db = self.db.profile
end