--[[
DHUD4_Player.lua
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

local MODNAME = "DHUD4_Player"
local DHUD4_Player = DHUD4:NewModule(MODNAME, "AceEvent-3.0")
local VERSION = tonumber(("$Rev: 85 $"):match("%d+"))

local unpack = unpack
local pairs = pairs
local type = type
local _G = _G
local string_match = string.match
local string_len = string.len


local ICONS = {
    rest = {
        42,
        128,--12,
        30,
        30,
    },
    combat = {
        42,
        128,
        30,
        30,
    },
    leader = {
        48,
        71,
        20,
        20,
        "Interface\\GroupFrame\\UI-Group-LeaderIcon"
    },
    loot = {
        43,
        51,
        20,
        20,
        "Interface\\GroupFrame\\UI-Group-MasterLooter"
    },
    pvp = {
        50,
        101,
        21,
        21,
    },
}

--FIN

--Local Defaults
local db
local defaults = {
    profile = {
        blizPlayer = true,
        player = "c",
        layout = "HLPR",
        combatIcon = true,
        pvpIcon = true,
        pvpIconTimer = true,
        swapPet = false,
        restIcon = true,
        leaderIcon = true,
        lootIcon = true,
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
	            f = {r=1,g=0.4,b=0},
	            h = {r=1,g=0.4,b=0},
	            l = {r=1,g=0.4,b=0}
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
            spell = {r=179/255,g=31/255,b=234/255},
            delay = {r=1,g=0,b=0},
            cast = {
                f = {r=0,g=1,b=1},
                h = {r=0,g=0,b=1},
                l = {r=1,g=0,b=1}
            },
        },
        cast = true,
        blizCast = true,
        castSide = "r",
        castPos = "i",
        castRev = false,
        castSpell = true,
        castTimer = true,
        castDelay = true,
        castTextSize = 12;
    },
}
--FIN

-- Functions required by the configuration options table
local OptGetter, OptSetter, ColorGetter, ColorSetter, SelectGetter, SelectSetter
local layoutType, colorOptions
do
    local mod = DHUD4_Player
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
        mod:Refresh();
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
            arg = MODNAME,
            name = L["Player Module"],
            order = 2,
            get = OptGetter,
            set = OptSetter,
            --childGroups  = "tab",
            args = {
                header = {
                    order = 1,
                    type = 'description',
                    name = L["The player module manages player bars and text, and rest, combat, leader and loot icons"],
                },
                enabled = {
                    order = 2,
                    type = "toggle",
                    name = L["Enable Player Module"],
                    get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
                    set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
                },
                layout = {
                    order = 4,
                    type = 'group',
                    name = L["Layout"],
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    args = {
                        blizPlayer = {
                            order = 0,
                            type ='toggle',
                            name = L["Player Frame"],
                            desc = L["Show Blizzard's player frame"],
                        },
                        player = {
                            order = 1,
                            type = 'select',
                            name = L["Player/Target Bars"],
                            desc = L["Place the Player's bars. Target's bars will be set accordingly"],
                            set = function (info, value)
                                    db[info[#info]] = value
                                    if string_match(value, "c") then
                                        db.layout = "HLPR";
                                    else
                                        db.layout = "HIPM";
                                    end
                                    DHUD4_Player:Refresh();
                                end,
                            values = DHUD4.layoutType,
                        },
                        layout = {
                            order = 2,
                            type = 'select',
                            name = L["Bar Layout"],
                            values = function ()
                                    if string_match(db.player, "c") then
                                        return { ["HLPR"] = L["Health Left/Power Right"], ["HRPL"] = L["Health Right/Power Left"] }
                                    else
                                        return { ["HIPM"] = L["Health Inner/Power Outer"], ["HMPI"] = L["Health Outer/Power Inner"] }
                                    end
                                end,
                        },
                        swapPet = {
                            order = 3,
                            type = 'toggle',
                            name = L["In vehicle bar swap"],
                            desc = L["Swap player's bars for pet's when using vehicles"],
                            --enabled = DHUD4:GetModuleEnabled("DHUD4_Pet"),
                        },
                        icons = {
                            order = 4,
                            type = 'header',
                            name = L["Status Icons"],
                        },
                        combatIcon = {
                            order = 5,
                            type = 'toggle',
                            name = L["In Combat"],
                            desc = L["Show/Hide"],
                        },
                        restIcon = {
                            order = 6,
                            type = 'toggle',
                            name = L["Resting"],
                            desc = L["Show/Hide"],
                        },
                        leaderIcon = {
                            order = 7,
                            type = 'toggle',
                            name = L["Party Leader"],
                            desc = L["Show/Hide"],
                        },
                        lootIcon = {
                            order = 8,
                            type = 'toggle',
                            name = L["Master Looter"],
                            desc = L["Show/Hide"],
                        },
                        pvpIcon = {
                            order = 9,
                            type = 'toggle',
                            name = L["PvP Flag"],
                            desc = L["Show/Hide"],
                        },
                        pvpTimer = {
                            order = 10,
                            type = 'header',
                            name = L["PvP Timer"],
                        },
                        pvpIconTimer = {
                            order = 11,
                            type = 'toggle',
                            name = L["PvP Timer"],
                            desc = L["Show/Hide"],
                            disabled  = function() return not db.pvpIcon; end,
                        },
                    },
                },
                barText = DHUD4:StatusBarMenuOptions(5, not DHUD4:GetModuleEnabled(MODNAME), db),
                cast = {
                    order = 6,
                    type = "group",
                    name = L["Cast Bar"],
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    get = OptGetter,
                    set = OptSetter,
                    args = {
                        blizCast = {
                            type ='toggle',
                            order = 0,
                            get = function() return db.blizCast; end,
                            set = function(info, value) db.blizCast = value; end,
                            name = L["Blizz Cast Bar"],
                            desc = L["Show/Hide Blizzard's PLayer Cast Bar."],
                        },
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
                            desc = L["Side to show the cast bar, Player bar has presedence"],
                            values = {["l"] = L["Left"], ["r"] = L["Right"]},
                            disabled  = function() return not db.cast end,
                        },
                        castPos = {
                            order = 3,
                            type = 'select',
                            name = L["Position"],
                            desc = L["Position of the cast bar, Player bar has presedence"],
                            values = {["i"] = L["Inner"], ["m"] = L["Middle"]},
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
                    type = 'group',
                    order = 7,
                    name = L["Bar Colors"],
                    get = ColorGetter,
                    set = ColorSetter,
                    disabled = function() return not DHUD4:GetModuleEnabled(MODNAME); end,
                    args = {
                        ["7"] = {
                            type = 'group',
                            name = L["Health"],
                            order = 1,
                            args = DHUD4.colorOptions,
                        },
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
                        ["2"] = {
                            type = 'group',
                            name = L["Focus"],
                            args = DHUD4.colorOptions,
                        },
                    },
                },
            },
        }
        options.args.barText.args.barText.get = SelectGetter
        options.args.barText.args.barText.set = SelectSetter
        options.args.cast.args.colors.args.cast.get = ColorGetter
        options.args.cast.args.colors.args.cast.set = ColorSetter
    end
    return options
end
--FIN

-- Local Functions
local ConfigLayout, CreateRestIcon, CreateCombatIcon, CreateLeaderIcon, CreateLootIcon, CreatePvpIcon, CreateIcon, SwapVehicle, UpdatePlayerPvP
-- Local Varaibles
local restIcon, combatIcon, leaderIcon, lootIcon, pvpIcon
local healthBar, powerBar, castBar
do
    -- Config Bars and Icons
    function ConfigLayout()
        local hbar, hpar, pbar, ppar, iconSide
        --DHUD4:Debug("ConfigBars");
        if string_match(db.player, "c") then
            if string_match(db.layout, "HLPR") then
                hbar, hpar, pbar, ppar = "fl3", DHUD4_LeftFrame, "fr3", DHUD4_RightFrame
                --DHUD4_Player.auraSide = "r";
                iconSide = "l";
            else
                hbar, hpar, pbar, ppar = "fr3", DHUD4_RightFrame, "fl3", DHUD4_LeftFrame
                iconSide = "r";
            end
        elseif string_match(db.player, "l") then
            iconSide = "l";
            if string_match(db.layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fl3", DHUD4_LeftFrame, "fl4", DHUD4_LeftFrame
            else
                hbar, hpar, pbar, ppar = "fl4", DHUD4_LeftFrame, "fl3", DHUD4_LeftFrame
            end
        else
            iconSide = "r";
            if string_match(db.layout, "HIPM") then
                hbar, hpar, pbar, ppar = "fr3", DHUD4_RightFrame, "fr4", DHUD4_RightFrame
            else
                hbar, hpar, pbar, ppar = "fr4", DHUD4_RightFrame, "fr3", DHUD4_RightFrame
            end
        end
        -- Health bar
        healthBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        healthBar:InitStatusBar(hbar, hpar)
        healthBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.healthBarText then
            healthBar:InitStatusBarText(hbar, DHUD4:GetPosition(hbar))
            healthBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.healthCustomTextStyle) > 0) and db.healthCustomTextStyle or db.healthTextStyle, "player")
        end
        healthBar.frame:SetScript("OnShow", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
            end)
        healthBar.frame:SetScript("OnHide", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
            end)
        healthBar:TrackUnitHealth("player", db.colors[tostring(7)])

        -- Power bar
        powerBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
        powerBar:InitStatusBar(pbar, ppar)
        powerBar:PlaceTextures(DHUD4:GetCurrentTexture())
        if db.powerBarText then
            powerBar:InitStatusBarText(pbar, DHUD4:GetPosition(pbar))
            powerBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.powerCustomTextStyle) > 0) and db.powerCustomTextStyle or db.powerTextStyle, "player")
        end
        powerBar.frame:SetScript("OnShow", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
            end)
        powerBar.frame:SetScript("OnHide", function (this)
                DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
            end)

        powerBar:TrackUnitPower("player", db.colors[tostring(UnitPowerType("player"))], UnitPowerType("player"))

        -- Icons
        if db.restIcon then
            CreateRestIcon(iconSide)
            SetIconTexture(restIcon)
            DHUD4_Player:RegisterEvent("PLAYER_UPDATE_RESTING")
            DHUD4_Player:RegisterEvent("PLAYER_ENTERING_WORLD", DHUD4_Player.PLAYER_UPDATE_RESTING)
        end
        if db.combatIcon then
            CreateCombatIcon(iconSide)
            SetIconTexture(combatIcon)
            DHUD4_Player:RegisterEvent("PLAYER_REGEN_ENABLED")
            DHUD4_Player:RegisterEvent("PLAYER_REGEN_DISABLED")
        end
        if db.leaderIcon then
            CreateLeaderIcon(iconSide)
            SetIconTexture(leaderIcon)
            DHUD4_Player:RegisterEvent("PARTY_MEMBERS_CHANGED", DHUD4_Player.UpdatePlayerLeader)
            DHUD4_Player:RegisterEvent("PARTY_LEADER_CHANGED", DHUD4_Player.UpdatePlayerLeader)
        end
        if db.lootIcon then
            CreateLootIcon(iconSide)
            SetIconTexture(lootIcon)
            DHUD4_Player:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
        end
        if db.pvpIcon then
            CreatePvpIcon(iconSide)
            DHUD4_Player:RegisterEvent("UNIT_FACTION")
        end
        
        -- Cast Bar
        if db.cast then
            --BlizzFrames
            if(not db.blizCast) then
                CastingBarFrame:UnregisterAllEvents()
                CastingBarFrame:Hide()
            end
            local bar, parent
            bar = (db.castSide == "r") and "cr" or "cl"
            bar = (db.castPos == "i") and bar.."3" or bar.."4"
            parent = (db.castSide == "r") and DHUD4_RightFrame or DHUD4_LeftFrame
            castBar:InitCastBar(bar, parent, db.castRev)
            castBar:InitCastBarText(bar, db.castTimer, db.castSpell, db.castDelay, db.colors.spell, db.colors.delay)
            castBar:ConfigBarText(DHUD4:GetFont(), db.castTextSize * DHUD4.GetScale())
            castBar:TrackUnitCast("player", db.colors.cast)
        end
    end

    function CreateRestIcon(side)

        if ( (restIcon == nil) or (restIcon.side ~= side) ) then
            restIcon = CreateIcon("rest", side)
            restIcon.background:SetTexCoord(0,1,0,1)
            restIcon.side = side
            restIcon.name = "rest"
            restIcon:Hide()
        end
    end

    function CreateCombatIcon(side)

        if ( (combatIcon == nil) or (combatIcon.side ~= side) ) then
            combatIcon = CreateIcon("combat", side)
            combatIcon.background:SetTexCoord(0,1,0,1)
            combatIcon.side = side
            combatIcon.name = "combat"
            combatIcon:Hide()
        end
    end

    function CreateLeaderIcon(side)

        if ( (leaderIcon == nil) or (leaderIcon.side ~= side) ) then
            leaderIcon = CreateIcon("leader", side)
            leaderIcon.background:SetTexCoord(0,1,0,1)
            leaderIcon.side = side
            leaderIcon.name = "leader"
            leaderIcon:Hide()
        end
    end

    function CreateLootIcon(side)

        if ( (lootIcon == nil) or (lootIcon.side ~= side) ) then
            lootIcon = CreateIcon("loot", side)
            lootIcon.background:SetTexCoord(0,1,0,1)
            lootIcon.side = side
            lootIcon.name = "loot"
            lootIcon:Hide()
        end
    end

    function CreatePvpIcon(side)

        if ( (pvpIcon == nil) or (pvpIcon.side ~= side) ) then
            pvpIcon = CreateIcon("pvp", side)
            pvpIcon.background:SetTexCoord(0,0.6,0,0.6)
            pvpIcon:SetScript("OnEnter", function(this)
                if not ( this:IsVisible() )  or ( this:GetEffectiveAlpha() == 0 ) then
					return;
				end
				local left = GetPVPTimer();
                local text;
                if ( left == 301000 ) then
                    text = "PvP On";
                else
                    text = DHUD4:FormatTime(left/1000);
                end
                if this.side == "r" then
                    GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT");
                else
                    GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
                end
                GameTooltip:SetText(text, 1, 0, 0);
            end)
			pvpIcon:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
            pvpIcon.side = side
            pvpIcon.texture = nil
            pvpIcon.name = "pvp"
            pvpIcon:Hide()
        end
    end

    function CreateIcon(icon, side)
        local x, y, width, height, texture = unpack(ICONS[icon]);
        local parent = DHUD4_LeftFrame
        if side == "r" then
            x = -x
            parent = DHUD4_RightFrame
        end
        local frame = CreateFrame("Button", "DHUD4_"..icon, parent)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", parent, "CENTER", x, y)
        frame:SetHeight(height)
        frame:SetWidth(width)
        frame:EnableMouse(false)
        local bgt = frame:CreateTexture("DHUD4_"..icon.."_Texture", "BACKGROUND")
        bgt:ClearAllPoints()
        bgt:SetPoint("CENTER", frame, "CENTER", 0, 0)
        bgt:SetHeight(height)
        bgt:SetWidth(width)
        frame.background = bgt
        frame.texture = texture
        return frame
    end

    function UpdatePlayerPvP()

        local texture = DHUD4:GetPvpTexture("player")
        if ( texture ) then
            pvpIcon.background:SetTexture(texture)
            pvpIcon:Show()
        else
            pvpIcon:Hide()
        end
    end

    function SetIconTexture(icon)

        icon.background:SetTexture(nil)
        icon.background:SetTexture(DHUD4:GetCurrentTexture()..icon.name)
        if ( not icon:GetNormalTexture() ) then
            if icon.texture then
                icon.background:SetTexture(icon.texture)
            else
                icon.background:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\"..icon.name)
            end
        end
    end

    function SwapVehicle(unit)

        healthBar:Disable(true)
        powerBar:Disable(true)

        healthBar:TrackUnitHealth(unit, db.colors[tostring(7)])
        healthBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.healthCustomTextStyle) > 0) and db.healthCustomTextStyle or db.healthTextStyle, unit)
        powerBar:TrackUnitPower(unit, db.colors[tostring(UnitPowerType("player"))], UnitPowerType("player"))
        powerBar:ConfigBarText(DHUD4:GetFont(), db.barTextSize * DHUD4.GetScale(), (string_len(db.powerCustomTextStyle) > 0) and db.powerCustomTextStyle or db.powerTextStyle, unit)
    end

end

function DHUD4_Player:OnInitialize()

    --DHUD4:Debug(MODNAME..":OnInitialize");
    self.db = DHUD4.db:RegisterNamespace(MODNAME, defaults)
    db = self.db.profile
    self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME))
    DHUD4:RegisterModuleOptions(MODNAME, GetOptions, L["Player"])
    self.layout = false

    -- Bars
    healthBar = DHUD4:CreateStatusBar()
    powerBar = DHUD4:CreateStatusBar()
    castBar = DHUD4:CreateCastBar()

end

function DHUD4_Player:OnEnable()

    --DHUD4:Debug("DHUD4_Player:OnEnable")
    if not self:IsEnabled() then return end
    self:Refresh()
end

function DHUD4_Player:OnDisable()

    self:UnregisterAllEvents();
    healthBar:Disable()
    powerBar:Disable()
    castBar:Disable()
    self:DisableIcon(restIcon)
    self:DisableIcon(combatIcon)
    self:DisableIcon(leaderIcon)
    self:DisableIcon(lootIcon)
    self:DisableIcon(pvpIcon)

end

function DHUD4_Player:Refresh()

    --DHUD4:Debug(MODNAME, "Refresh", DHUD4_Player:IsEnabled())
    db = self.db.profile

    --BlizzFrames
    if ( not db.blizPlayer and PlayerFrame:IsShown() ) then
        PlayerFrame:UnregisterAllEvents()
        ComboFrame:UnregisterAllEvents()
        ComboFrame:Hide()
        PlayerFrame:Hide()
    end

    healthBar:Disable()
    powerBar:Disable()
    castBar:Disable()
    self:DisableIcon(restIcon)
    self:DisableIcon(combatIcon)
    self:DisableIcon(leaderIcon)
    self:DisableIcon(lootIcon)
    self:DisableIcon(pvpIcon)

    ConfigLayout()
    if (self.layout) then
        self:SetLayout()
    else
        -- Rest status
        if IsResting() and db.restIcon then
            restIcon:Show()
        end

         if ( IsPartyLeader() ) then
            leaderIcon:Show()
        end

        if db.lootIcon then
            local lootMethod, lootMaster = GetLootMethod();
            if ( lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) ) then
                lootIcon:Show()
            else
                lootIcon:Hide()
            end
        end

        -- PvP Status
        if db.pvpIcon then
            local texture = DHUD4:GetPvpTexture("player")
            if ( texture ) then
                pvpIcon.background:SetTexture(texture)
                pvpIcon:Show()
            else
                pvpIcon:Hide()
            end
        end

        -- Events
        self:RegisterEvent("UNIT_DISPLAYPOWER") --ESTO LO DEBE HACE EL MODULO QUE CREA LA BARRA

        -- Pet Swap
        if db.swapPet then
            if ( DHUD4:GetModuleEnabled("DHUD4_Pet") ) then
                local pet = DHUD4:GetModule("DHUD4_Pet")
                pet:SwapPet(true)
            end
            self:RegisterEvent("UNIT_ENTERED_VEHICLE")
            self:RegisterEvent("UNIT_EXITED_VEHICLE")
            if ( UnitInVehicle("player")) then
                SwapVehicle("vehicle")
            end
        else
            self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
            self:UnregisterEvent("UNIT_EXITED_VEHICLE")
            if ( DHUD4:GetModuleEnabled("DHUD4_Pet") ) then
                local pet = DHUD4:GetModule("DHUD4_Pet")
                pet:SwapPet(false)
            end
        end
    end
    -- Since the target layout depends on the Player, refresh the Target module if enabled
    if ( DHUD4:GetModuleEnabled("DHUD4_Target") ) then
        DHUD4:GetModule("DHUD4_Target"):Refresh()
    end
end

function DHUD4_Player:DisableIcon(icon)

    if (icon) then
        icon:UnregisterAllEvents()
        icon:Hide()
    end
end

function DHUD4_Player:UNIT_DISPLAYPOWER(event, unit)
    if unit == "player" then
        powerBar:TrackUnitPower("player", db.colors[tostring(UnitPowerType("player"))], UnitPowerType("player"))
    end

end

function DHUD4_Player:UNIT_FACTION(event, unit)

    --DHUD4:Debug("DHUD4_Player, UNIT_FACTION", unit)
    if ( unit == "player" ) then
		UpdatePlayerPvP()
    end
end

--[[
    UNIT_ENTERED_VEHICLE: Swap bars with pet if enabled
]]
function DHUD4_Player:UNIT_ENTERED_VEHICLE(event, who)

    --DHUD4:Debug("UNIT_ENTERED_VEHICLE");
    if who == "player" then
        if ( UnitInVehicle("player") ) then
            SwapVehicle("vehicle")
        end
    end
end

--[[
    UNIT_EXITED_VEHICLE: Swap bars with pet if enabled
]]
function DHUD4_Player:UNIT_EXITED_VEHICLE(event, who)

    --DHUD4:Debug("UNIT_EXITED_VEHICLE");
    if ( who == "player" ) then
        SwapVehicle("player")
    end
end

function DHUD4_Player:UpdatePlayerLeader()
    if ( IsPartyLeader() ) then
        leaderIcon:Show()
    else
        leaderIcon:Hide()
    end
    if (GetNumPartyMembers() == 0) then
        lootIcon:Hide()
    end
end

function DHUD4_Player:PARTY_LOOT_METHOD_CHANGED()

    local lootMethod, lootMaster = GetLootMethod()
    if ( lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) ) then
        lootIcon:Show()
    else
        lootIcon:Hide()
    end
end

function DHUD4_Player:PLAYER_UPDATE_RESTING()

    if ( IsResting() ) then
        restIcon:Show()
    else
        restIcon:Hide()
    end
end

function DHUD4_Player:PLAYER_REGEN_ENABLED()

    combatIcon:Hide()
end

function DHUD4_Player:PLAYER_REGEN_DISABLED()

    combatIcon:Show()
end


function DHUD4_Player:SetLayout()

    self.layout = true
    healthBar:SetLayout("Player Health", 100, 80)
    powerBar:SetLayout("Player Power", 100, 80)
    castBar:SetLayout("Player", 10, 3.9)
    if (restIcon) then restIcon:Show() end
    if (combatIcon) then combatIcon:Show() end
    if (leaderIcon) then leaderIcon:Show() end
    if (lootIcon) then lootIcon:Show() end
    if (pvpIcon) then
        pvpIcon.background:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
        pvpIcon:Show()
    end
end

function DHUD4_Player:EndLayout()

    self.layout = false
    self:Refresh()
end

function DHUD4_Player:GetLayout()
    if (db.cast) then
        return db.player, db.layout, db.castSide, db.castPos
    else
        return db.player, db.layout
    end
end

function DHUD4_Player:GetBars()
    --DHUD4:Debug("DHUD4_Player:GetBars()", healthBar.bar, powerBar.bar)
    return healthBar.frame.bar, powerBar.frame.bar
end