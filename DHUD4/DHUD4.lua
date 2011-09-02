--[[
DHUD4
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
--Addon Mix
--@non-debug@
DHUD4 = LibStub("AceAddon-3.0"):NewAddon("DHUD4", "AceEvent-3.0", "AceConsole-3.0");
--@end-non-debug@
--[===[@debug@
DHUD4 = LibStub("AceAddon-3.0"):NewAddon("DHUD4", "AceEvent-3.0", "AceConsole-3.0", "LibDebugLog-1.0");
--@end-debug@]===]


--ACE Version
local VERSION = tonumber(("$Rev: 105 $"):match("%d+"));
DHUD4.revision = "r" .. VERSION;
DHUD4.versionstring = "1.6.3-%s";
DHUD4.version = DHUD4.versionstring:format(VERSION);
DHUD4.date = ("$Date: 2011-08-19 01:08:20 +0000 (Fri, 19 Aug 2011) $"):match("%d%d%d%d%-%d%d%-%d%d");
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4");
local LSM3 = LibStub("LibSharedMedia-3.0");

local unpack = unpack;
local pairs = pairs;
local type = type;
local _G = _G;
local string_format = string.format;
local string_len = string.len;
local string_find = string.find;
local string_sub = string.sub;

local isSetup = false
local settingLayout = false
local currentAlphaValue = { false, false, false, false, false }
local regenAlphaVotes = {false, false}


--Local Defaults
local db
local defaults = {
    profile = {
        blizPet = false,
        texture = "DHUD",
        deadAlpha = 0,
        combatAlpha = 1,
        castAlpha = 0.8,
        selectAlpha = 0.6,
        regenAlpha = 0.4,
        oocAlpha = 0.1,
        useBorders = true,
        showEmpty = true,
        miniMap = true,
        minimapPos = 190,
        frameSpacing = 30,
        frameVertical = 0,
        font = "Arial Narrow",
        scale = 1,
        customTexture = "",
        positions = {},
        modules = {
            DHUD4_Target = true,
            DHUD4_Player = true,
            DHUD4_Outer = true,
            DHUD4_Pet = true,
            DHUD4_Auras = true,
        },
    }
}

local OptGetter, OptSetter;
do
    --[[
        OptGetter: Get the current option setting in the DB
        arguments:
            info: option to query
        returns:
            option setting in DB
    ]]
    function OptGetter(info)
        local key = info[#info]
        return db[key]
    end

    --[[
        OptSetter: Set the option new value in the DB. The HUD is refreshed after the setting is done
        arguments:
            info: option to chagne value
            value: new value
    ]]
    function OptSetter(info, value)
        local key = info[#info]
        db[key] = value
        DHUD4:Refresh()
    end
end

--Local Options
local options, moduleOptions = nil, {}
local function GetOptions()
    if not options then
        --Options table
        options = {
            type = 'group',
            name = 'DHUD4',
            order = 1,
            args = {
                layout = {
                    type = 'group',
                    name = L["General Options"],
                    order = 1,
                    get = OptGetter,
                    set = OptSetter,
                    args = {
                        layout = {
                            order = 0,
                            type = "execute",
                            name = function()
                                    return settingLayout and L["Lock Layout"] or L["Config Layout"]
                                end,
                            func = function()
                                    if (settingLayout) then
                                        DHUD4:EndLayout()
                                    else
                                        DHUD4:SetLayout()
                                    end
                                end
                        },
                        renaitre = {
                            order = 0,
                            type = "execute",
                            name = L["Load Renaitre profile"],
                            func = function()
                                    DHUD4:LoadRenaitreProfile()
                                   end,
                            --[[disabled = function()
                                        local profiles = DHUD4.db:GetProfiles()
                                        for _, value in pairs(profiles) do
                                            if value == "Renaitre" then
                                                return true
                                            end
                                        end
                                       end]]
                        },
                        miniMap = {
                            order = 1,
                            type = 'toggle',
                            name = L["Show Minimap Button"],
                        },
                        scale = {
                            order = 3,
                            type = 'range',
                            name = L["Set DHUD4's scale"],
                            min = 0.2,
                            max = 2,
                            step = 0.1,
                        },
                        frameSpacing = {
                            order = 4,
                            type = 'range',
                            name = L["Center Spacing"],
                            min = 0,
                            max = 500,
                            step = 10,
                        },
                        frameVertical = {
                            order = 5,
                            type = 'range',
                            name = L["Vertical position"],
                            min = -300,
                            max = 300,
                            step = 10,
                        },
                        gral = {
                            type = 'group',
                            name = L["General"],
                            inline = true,
                            order = 6,
                            args = {
                                desc = {
                                    order = 1,
                                    type = "description",
                                    name = L["Configure bar's border functionality"],
                                },
                                useBorders = {
                                    order = 2,
                                    type = "toggle",
                                    name = L["Show Bar Borders"],
                                    desc = L["Show/hide borders"],
                                },
                                showEmpty = {
                                    order = 3,
                                    type = "toggle",
                                    name = L["Show Bars when empty"],
                                    desc = L["Show/hide empty (0 value) bars"],
                                    disabled = function()
                                            return not db.useBorders
                                        end,
                                },
                                font = {
                                    order = 4,
                                    type = 'select',
                                    dialogControl = 'LSM30_Font',
                                    name = L["Bar font"],
                                    desc = L["The font used by all Modules"],
                                    values = LSM3:HashTable("font"),
                                },
                                texture = {
                                    type = 'select',
                                    order = 5,
                                    name = L["Texture"],
                                    values = {["DHUD"] = "DHUD", ["Renaitre"] = "Renaitre"}
                                },
                                customTexture = {
                                    type = 'input',
                                    order = 6,
                                    name = L["Custom Texture"],
                                    desc = L["Name of the texture's folder"],
                                    usage = L["The folder must exist in .../DHUD4/textures/. Leave blank to use on of the default textures"],
                                },
                                --[[click = {
                                    type ='toggle',
                                    order = 7,
                                    name = L["Click Trough Frames"],
                                    desc = L["Cheking this option will prevent tooltips, frame moving and menu popping"],
                                },--]]
                            },
                        },
                        alphas = {
                            order = 7,
                            type = "group",
                            name = L["Alphas"],
                            inline = true,
                            args = {
                                desc = {
                                    order = 1,
                                    type = "description",
                                    name = L["Set the HUD's situation alpha. The order shown is the precedence order, i.e. Combat alpha will override Selection alpha"],
                                },
                                deadAlpha = {
                                    order = 2,
                                    type = "range",
                                    name = L["Death"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                                combatAlpha = {
                                    order = 3,
                                    type = "range",
                                    name = L["Combat"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                                castAlpha = {
                                    order = 4,
                                    type = "range",
                                    name = L["Casting"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                                selectAlpha = {
                                    order = 5,
                                    type = "range",
                                    name = L["Selection"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                                regenAlpha = {
                                    order = 6,
                                    type = "range",
                                    name = L["Regeneracy"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                                oocAlpha = {
                                    order = 7,
                                    type = "range",
                                    name = L["Out of Combat"],
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                },
                            },
                        },
                    },
                }
            }
        }
        for k,v in pairs(moduleOptions) do
            options.args[k] = (type(v) == "function") and v() or v
        end
    end
    return options
end

-- DogTags
local DogTags = {
    health = {
        ["[FractionalHP] ([PercentHP:Percent])"] = L["Current/Max (Percent%)"],
        ["[FractionalHP]"] = L["Current/Max"],
        ["[HP] ([PercentHP:Percent])"] = L["Current (Percent%)"],
        ["[PercentHP:Percent]"] = L["Percent%"],
        ["[HP]"] = L["Current"]
    },
    power = {
        ["[FractionalMP] ([PercentMP:Percent])"] = L["Current/Max (Percent%)"],
        ["[FractionalMP]"] = L["Current/Max"],
        ["[MP] ([PercentMP:Percent])"] = L["Current (Percent%)"],
        ["[PercentMP:Percent]"] = L["Percent%"],
        ["[MP]"] = L["Current"]
    },
    name = {
        ["[Level:DifficultyColor] [Classification] [Name:HostileColor] [isPet ? Creature:ClassColor:Bracket ! isPLayer ? Class:ClassColor:Bracket ! Faction:ClassColor:Bracket]"] = L["<level><elite> <name> [ <class> ]"],
        ["[Level:DifficultyColor] [Classification] [Name:HostileColor]"] = L["<level><elite> <name>"],
        ["[Name:HostileColor] [isPet ? Creature:ClassColor:Bracket ! isPLayer ? Class:ClassColor:Bracket ! Faction:ClassColor:Bracket]"] = L["<name> [ <class> ]"],
        ["[Level:DifficultyColor] [Name:HostileColor]"] = L["<level> <name>"],
    }
}

-- Layout and Colors
DHUD4.layoutType = {["c"] = L["Centered"], ["r"] = L["Right"], ["l"] = L["Left"]}
DHUD4.colorOptions = {
        f = {
            type = 'color',
            name = L["Full"],
            order = 1,
        },
        h = {
            type = 'color',
            name = L["Med"],
            order = 2,
        },
        l = {
            type = 'color',
            name = L["Low"],
            order = 3,
        },
    }

--FIN

-- Local Functions
local MyAddons;
do
    function MyAddons()

        if (myAddOnsFrame_Register) then
            local DHUD4_mya = {
                ["name"]         = "DHUD4",
                ["version"]      = versionstring,
                ["author"]       = "Arcanefoam (Horacio Hoyos)",
                ["category"]     = MYADDONS_CATEGORY_COMBAT,
                ["email"]        = "arcanefoam@gmail.com",
                ["website"]      = "http://www.wowace.com/projects/DHUD4/",
            };
            myAddOnsFrame_Register(DHUD4_mya);
        end
    end
end

--[[
    UpdateAlpha: Set the HUD's alpha acording to the state of the player. A module can set any of the levels to true or false. The highest level that has it's value in true will be chosen.
    arguments:
        level: level to set the value
                                5 = dead
                                4 = combat
                                3 = cast
                                2 = select (targeting)
                                1 = regeneration
        state: state to put the level on (true = on, false = off)
        vote: For regeneration alpha, the alpha is set if any of the health or power bars requests it. This avoids that the bar toggles between ooc and regen while regenerating
]]
function DHUD4:UpdateAlpha(level, state, vote)
    
    if level == 1 then
        regenAlphaVotes[vote] = state;
        if (regenAlphaVotes[1] or regenAlphaVotes[2]) then
            currentAlphaValue[1] = true;
        else
            currentAlphaValue[1] = false;
        end
    else
        currentAlphaValue[level] = state;
    end
    local alpha;
    if ( currentAlphaValue[5] ) then
        alpha = "deadAlpha";
    elseif ( currentAlphaValue[4] ) then
        alpha = "combatAlpha";
    elseif ( currentAlphaValue[3] ) then
        alpha = "castAlpha";
    elseif ( currentAlphaValue[2] ) then
        alpha = "selectAlpha";
    elseif ( currentAlphaValue[1] ) then
        alpha = "regenAlpha";
    else
        alpha = "oocAlpha";
    end
    DHUD4_MainFrame:SetAlpha(DHUD4.db.profile[alpha]);
end

--[[
    Rgb2hex: Transform a RGB color to a HEX color
        arguments:
            r, g, b: RGB values
        returns:
            Hex value for the RGB
]]
function DHUD4:Rgb2hex(r, g, b)

    local hexr, hexg, hexb;
    hexr = string_format("%x", r * 255);
    hexr = string_len(hexr) == 1 and "0"..hexr or hexr;
    hexg = string_format("%x", g * 255);
    hexg = string_len(hexg) == 1 and "0"..hexg or hexg;
    hexb = string_format("%x", b * 255);
    hexb = string_len(hexb) == 1 and "0"..hexb or hexb;
    return hexr..hexg..hexb;
end



 --[[
    UnitIsNPC: Check if the unit is a NPC
        arguments:
            unit: unit to check
        returns:
            true if the unit is a NPC
]]
function DHUD4:UnitIsNPC(unit)

    return not (UnitIsPlayer(unit) or UnitPlayerControlled(unit) or UnitCanAttack("player", unit));
end

--[[
    UnitIsPet: Check if the unit is a pet
        arguments:
            unit: unit to check
        returns:
            true if the unit is a pet
]]
function DHUD4:UnitIsPet(unit)

    return not self:UnitIsNPC(unit) and not UnitIsPlayer(unit) and UnitPlayerControlled(unit);
end

--[[
    FormatTime: Format a time in seconds to Hours, minutes, seconds
        arguments:
            secs: time in seconds to format
        returns:
            Formated time
]]
function DHUD4:FormatTime(secs)

    if secs >= 86400 then
        return format('%dd', math.ceil(secs/86400));
    elseif secs >= 3600 then
        return format('%dh', math.ceil(secs/3600));
    elseif secs >= 60 then
        return format('%dm', math.ceil(secs/60));
    else
        return format("%d", math.floor(secs));
    end
end

--[[
    GetPvpTexture: Get the texture for unit current PvP status
        arguments:
            unit
        returns:
            Texture path
]]
function DHUD4:GetPvpTexture(unit)
    if ( UnitIsPVPFreeForAll(unit) ) then
        return "Interface\\TargetingFrame\\UI-PVP-FFA"
    elseif ( UnitIsPVP(unit) ) then
        local faction = UnitFactionGroup(unit)
        if ( faction == "Horde" ) then
            return "Interface\\TargetingFrame\\UI-PVP-Horde"
        else
            return "Interface\\TargetingFrame\\UI-PVP-Alliance"
        end
    else
        return false
    end
end

--[[
    OnInitialize: Function called when the addon is initialized
]]
function DHUD4:OnInitialize()

    --[===[@debug@
    DHUD4:ToggleDebugLog(true);
    --@end-debug@]===]

    -- Register some SharedMedia goodies.
    LSM3:Register("font", "ABF", [[Interface\Addons\DHUD4\fonts\ABF.ttf]]);
    LSM3:Register("font", "Accidental Presidency", [[Interface\Addons\DHUD4\fonts\Accidental Presidency.ttf]]);
    LSM3:Register("font", "Adventure", [[Interface\Addons\DHUD4\fonts\Adventure.ttf]]);
    LSM3:Register("font", "Diablo",    [[Interface\Addons\DHUD4\fonts\Avqest.ttf]]);
    LSM3:Register("font", "Bazooka", [[Interface\Addons\DHUD4\fonts\Bazooka.ttf]]);
    LSM3:Register("font", "Big Noodle Oblique", [[Interface\Addons\DHUD4\fonts\BigNoodleTitling-Oblique.ttf]]);
    LSM3:Register("font", "Big Noodle ", [[Interface\Addons\DHUD4\fonts\BigNoodleTitling.ttf]]);
    LSM3:Register("font", "Black Chancery",     [[Interface\Addons\DHUD4\fonts\BlackChancery.ttf]]);
    LSM3:Register("font", "Emblem", [[Interface\Addons\DHUD4\fonts\Emblem.ttf]]);
    LSM3:Register("font", "Enigma 2", [[Interface\Addons\DHUD4\fonts\Enigma__2.ttf]]);
    LSM3:Register("font", "Movie Poster", [[Interface\Addons\DHUD4\fonts\Movie_Poster-Bold.ttf]]);
    LSM3:Register("font", "Porky", [[Interface\Addons\DHUD4\fonts\Porky.ttf]]);
    LSM3:Register("font", "Tangerin", [[Interface\Addons\DHUD4\fonts\Tangerin.ttf]]);
    LSM3:Register("font", "Twenty Century",     [[Interface\Addons\DHUD4\fonts\Tw_Cen_MT_Bold.ttf]]);
    LSM3:Register("font", "Ultima Campagnoli", [[Interface\Addons\DHUD4\fonts\Ultima_Campagnoli.ttf]]);
    LSM3:Register("font", "Vera Serif", [[Interface\Addons\DHUD4\fonts\VeraSe.ttf]]);
    LSM3:Register("font", "Yellow Jacket", [[Interface\Addons\DHUD4\fonts\Yellowjacket.ttf]]);

    -- Main Frame
    --local point, parent, relative, x, y, width, height = unpack(self.layout.MainFrame);
    local parent = CreateFrame ("Frame", "DHUD4_MainFrame", UIParent)
    parent:SetHeight(256)
    parent:SetWidth(512)
    parent:Show()
    -- Left and right frames were the bars and texts, and auras are placed
    ref = CreateFrame ("Frame", "DHUD4_LeftFrame", parent)
    ref:SetHeight(128)
    ref:SetWidth(256)
    ref:Show()
	ref = CreateFrame ("Frame", "DHUD4_RightFrame", parent)
    ref:SetHeight(128)
    ref:SetWidth(256)
    ref:Show()

    --Manage the Database
    self.db = LibStub("AceDB-3.0"):New("DHUD4DB", defaults, "DHUD");
    --self.db.RegisterCallback( DHUD4, "OnProfileChanged", "Refresh" );
    self.db.RegisterCallback( DHUD4, "OnProfileCopied", "Refresh" );
    self.db.RegisterCallback( DHUD4, "OnProfileReset", "Refresh" );
    db = self.db.profile;
    self.optionsFrames = {};
    self.clickTrough = db.clickTrough

    --Add the options table to the addon menu in blizz addon interface (thanks Nevcariel)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DHUD4", GetOptions);
    self.optionsFrames.DHUD4 = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("DHUD4", nil, nil, "layout");
    self:RegisterChatCommand("DHUD4", "ChatCommand");
    -- Add info to the Options array for the Profile Options
    self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles");

    -- MyAddons Support
    MyAddons();
end


--[[
    ChatCommand: Called when the chat command is entered (thanks Nevcariel). The config menu is always called. NO current support for in line command configuration.
]]
function DHUD4:ChatCommand(input)

    --DHUD4:Debug("ChatCommand", input);
    InterfaceOptionsFrame_OpenToCategory(DHUD4.optionsFrames.DHUD4);
end

--[[
    RegisterModuleOptions: Function to register other modules options with the core options table (thanks Nevcariel)
]]
function DHUD4:RegisterModuleOptions(name, optionTbl, displayName)

    moduleOptions[name] = optionTbl;
    self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("DHUD4", displayName, "DHUD4", name);
end

--[[
    OnEnable: Called whent the addon is Enabled (start up or reanable)
]]
function DHUD4:OnEnable()

    --DHUD4:Debug("DHUD4:OnEnable()")
    if ( not isSetup ) then
        db = self.db.profile;
        DHUD4_MainFrame:ClearAllPoints()
        DHUD4_MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, db.frameVertical)
        DHUD4_MainFrame:SetAlpha(db["oocAlpha"])
        DHUD4_MainFrame:SetScale(db.scale)
        DHUD4_MainFrame:Show()
        -- Center Spacing
		DHUD4_LeftFrame:ClearAllPoints()
		DHUD4_LeftFrame:SetPoint("CENTER", DHUD4_MainFrame, "CENTER", -db.frameSpacing - 162, 0)
		DHUD4_RightFrame:ClearAllPoints()
		DHUD4_RightFrame:SetPoint("CENTER", DHUD4_MainFrame, "CENTER", db.frameSpacing + 162, 0)
        if ( db.miniMap ) then
            DHUD4.Minimap:UpdatePosition()
            DHUD4.Minimap:Show()
        else
            DHUD4.Minimap:Hide()
        end
        self:RegisterEvent("PLAYER_ALIVE")
        self:RegisterEvent("PLAYER_DEAD")
        self:RegisterEvent("PLAYER_UNGHOST")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        isSetup = true
        settingLayout = false
    end
end

--[[
    OnDisable: Called when the addon gets disabled. Hide the Main Frame to hide all frames
]]
function DHUD4:OnDisable()

    DHUD4:UnregisterAllEvents()
    DHUD4_MainFrame:Hide()

end

--[[
    GetModuleEnabled: Get the current state of a module
        arguments:
            module: Name of the module who's state we want to query
        returns:
            true: Module is enabled
            false: Modile is not enabled
]]
function DHUD4:GetModuleEnabled(modname)
    
    --self:Debug("GetModuleEnabled", modname, db.modules[modname]);
    if(db.modules[modname] == nil) then
        return false;
    else
        return db.modules[modname]
    end
end

--[[
    SetModuleEnabled: Set the current module state
        arguments:
            module: Name of the module
            value: new enabled state. true = enabled, false = disabled
]]
function DHUD4:SetModuleEnabled(modname, value)

    local old = db.modules[modname]
    db.modules[modname] = value
    if ( old ~= value ) then
        if value then
            self:EnableModule(modname)
        else
            self:DisableModule(modname)
        end
    end
end

--[[
    SetLayout: Display all modules that have movable text, buttons, etc.
        arguments:
]]
function DHUD4:SetLayout()

    settingLayout = true
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("UNIT_COMBAT")
    DHUD4_MainFrame:SetAlpha(1)
    -- Circle all the modules and setlayout the enabled ones.
    for k,v in self:IterateModules() do
        if v:IsEnabled() then
            if type(v.SetLayout) == "function" then
                v:SetLayout();
            end
        end        
    end
end

--[[
    EndLayout: Display all modules that have movable text, buttons, etc.
        arguments:
]]
function DHUD4:EndLayout()

    settingLayout = false
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:UnregisterEvent("UNIT_COMBAT")
    self:UpdateAlpha(5, false)
    -- Circle all the modules and refresh the enabled ones.
    for k,v in self:IterateModules() do
        if v:IsEnabled() then
            if type(v.EndLayout) == "function" then
                v:EndLayout();
            end
        end
    end
end

--[[
    Refresh: Called everytime the configuration of the addon changes. Since this are global configuration values, all the enabled modules are refreshed as well
]]
function DHUD4:Refresh()

    DHUD4_MainFrame:ClearAllPoints()
    DHUD4_MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, db.frameVertical)
    DHUD4_MainFrame:Show()
    if (not settingLayout) then
        DHUD4_MainFrame:SetAlpha(db["oocAlpha"])
    end
    DHUD4_MainFrame:SetScale(db.scale)
    -- Center Spacing
    DHUD4_LeftFrame:ClearAllPoints()
	DHUD4_LeftFrame:SetPoint("CENTER", DHUD4_MainFrame, "CENTER", -db.frameSpacing - 162, 0)
	DHUD4_RightFrame:ClearAllPoints()
	DHUD4_RightFrame:SetPoint("CENTER", DHUD4_MainFrame, "CENTER", db.frameSpacing + 162, 0)
    if ( db.miniMap ) then
        self.Minimap:UpdatePosition()
        self.Minimap:Show()
    else
        self.Minimap:Hide()
    end
    -- Circle all the modules and refresh the enabled ones.
    for k,v in self:IterateModules() do
        if v:IsEnabled() then
            if type(v.Refresh) == "function" then
                v:Refresh()
            end
        end
    end
end

--[[
    GetScale: Get the current HUD's scale
        returns:
            Current scale value (db.scale)
]]
function DHUD4:GetScale()

    return db.scale;
end

--[[
    GetFont: Get the current HUD's font
        returns:
            Name of the current font
]]
function DHUD4:GetFont()

    return LSM3:Fetch('font', db.font);
end

--[[
    GetDisplayOptions: Get the current showEmpty and showBorder values
        returns:
            self.showEmpty, self.useBorders
]]
function DHUD4:GetDisplayOptions()

    return db.showEmpty, db.useBorders
end

function DHUD4:GetCurrentTexture()

    if(string_len(db.customTexture)> 0)then
        return "Interface\\AddOns\\DHUD4\\textures\\".. db.customTexture.."\\"
    else
        return "Interface\\AddOns\\DHUD4\\textures\\".. db.texture.."\\"
    end
end

--[[
    PLAYER_ALIVE: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_ALIVE()

    if ( UnitIsDeadOrGhost("player") ) then
        self:PLAYER_DEAD();
    else
        self:UpdateAlpha(5, false);
    end
end

--[[
    PLAYER_UNGHOST: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_UNGHOST()

    self:UpdateAlpha(5, false)
end

--[[
    PLAYER_DEAD: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_DEAD()

    self:UpdateAlpha(5, true)
end

--[[
    PLAYER_REGEN_ENABLED: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_REGEN_ENABLED()

    self:UpdateAlpha(4, false)
end

--[[
    PLAYER_REGEN_DISABLED: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_REGEN_DISABLED()

    self:UpdateAlpha(4, true)
    if ( settingLayout ) then
        self:EndLayout()
    end
    
end

function DHUD4:UNIT_COMBAT(event, unit)

    if (unit == "player") then
        self:EndLayout()
    end
end

--[[
    PLAYER_TARGET_CHANGED: Event function. Set the HUD's alpha
]]
function DHUD4:PLAYER_TARGET_CHANGED()

    --self:Debug("PLAYER_TARGET_CHANGED")
    if ( UnitExists("target") ) then
        self:UpdateAlpha(2, true);
    else
        self:UpdateAlpha(2, false);
    end
end

--[[
    SetMinimapButtonPosition: Set the minimap button position
        arguments:
            angle = angle to place the buttonm at
]]
function DHUD4:SetMinimapButtonPosition(angle)

    db.minimapPos = angle;
end

--[[
    GetMinimapButtonPosition: Get the minimap button position
]]
function DHUD4:GetMinimapButtonPosition()

    return db.minimapPos;
end

--[[
    SavePosition: Saved the position of a bar's text moved by the user
        Arguments:
            name = identifier of the text to save the position
            position = the new position
]]
function DHUD4:SavePosition(name, position)
    
    db.positions[name] = position
end

--[[
    GetPosition: Saved the position of a bar's text moved by the user
        Arguments:
            name = identifier of the text to save the position
            position = the new position
]]
function DHUD4:GetPosition(name)
    
    return db.positions[name]
end

--[[
    GetTag: Get a predefined set of tags (health, power or name)
        Arguments:
            tagType = type of tag: health, power or name
        Returns
            Table with the tags
]]
function DHUD4:GetTags(tagType)

    return DogTags[tagType]
end            

function DHUD4:GetFrameSpacing()

    return db.frameSpacing
end

function DHUD4:TableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                self:TableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function DHUD4:LoadRenaitreProfile()

    self.db:SetProfile("Renaitre")
    self.db:ResetProfile(false, true)
    self.db.profile.showEmpty = false
    self.db.profile.texture = "Renaitre"
    self.db.profile.font = "Black Chancery"
    self.db.profile.miniMap = false
    self.db.profile.modules.DHUD4_Auras = false
    -- Circle all the modules and set the profile??
    for k,v in self:IterateModules() do
        if v:IsEnabled() then
            if type(v.LoadRenaitreProfile) == "function" then
                v:LoadRenaitreProfile()
            end
        end
    end
    db = self.db.profile
    self:Refresh()
end
