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
local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]
local L = LibStub("AceLocale-3.0"):NewLocale("DHUD4", "enUS", true, not debug)
L["<level> <name>"] = true
L["<level><elite> <name>"] = true
L["<level><elite> <name> [ <class> ]"] = true
L["<name> [ <class> ]"] = true
L["Abilities Module"] = true
L["Abilities Side"] = true
L["About to Expire"] = true
L["Agro"] = true
L["Agro Status"] = true
L["Agro Text Style"] = true
L["Agro Tracking"] = true
L["Alphas"] = true
L["Aura filter options"] = true
L["Auras"] = true
L["Auras Module"] = true
L["Auras Side"] = true
L["Auras' scale"] = true
L["Bar"] = true
L["Bar Colors"] = true
L["Bar Layout"] = true
L["Bar Settings"] = true
L["Bar Text Style"] = true
L["Bar font"] = true
L["Bar to track mana (pet bars are used)"] = true
L["Bar tracks"] = true
L["Bar's Text"] = true
L["Begin"] = true
L["Blizz Cast Bar"] = true
L["Border Color"] = true
L["Bottom"] = true
L["Bottom Up"] = true
L["Breath you"] = true
L["Buffs"] = true
L["By default the buff border starts changing towards <Expiration> when there are 20 seconds remaining."] = true
L["Cast"] = true
L["Cast Bar"] = true
L["Cast bars fills in reverse direction"] = true
L["Casting"] = true
L["Center Spacing"] = true
L["Centered"] = true
L["Change Auras's side"] = true
L["Cheking this option will prevent tooltips, frame moving and menu popping"] = true
L["Choose weapon Auras display order"] = true
L["Click Trough Frames"] = true
L["Colors"] = true
L["Columns"] = true
L["Combat"] = true
L["Combos"] = true
L["Complete"] = true
L["Config Layout"] = true
L["Configure Health and Power (mana/rage/energy/runic) text options"] = true
L["Configure bar's border functionality"] = true
L["Configure general functionality"] = true
L["Current"] = true
L["Current (Percent%)"] = true
L["Current/Max"] = true
L["Current/Max (Percent%)"] = true
L["Custom Agro Style"] = true
L["Custom Health Style"] = true
L["Custom Mana Style"] = true
L["Custom Name Style"] = true
L["Custom Power Style"] = true
L["Custom Text Style"] = true
L["Custom Texture"] = true
L["Death"] = true
L["Death Knight"] = true
L["Death Knight Abilities"] = true
L["Death Knight Runes"] = true
L["Debuffs"] = true
L["Delay Time"] = true
L["Druid"] = true
L["Druid Abilities"] = true
L["Druid Bar Values"] = true
L["Druid Mana"] = true
L["Druid Mana Tracking"] = true
L["Eclipse Lunar Phase"] = true
L["Eclipse Solar Phase"] = true
L["Elite Icon"] = true
L["Enable Abilities"] = true
L["Enable Auras Module"] = true
L["Enable Outer Module"] = true
L["Enable Pet Module"] = true
L["Enable Player Module"] = true
L["Enable Target Module"] = true
L["Enable clicks"] = true
L["Enabling this option will make the whole name plate non click trough"] = true
L["Energy"] = true
L["Enter /dog for in-game LibDogTag-3.0 Tag documentation"] = true
L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."] = true
L["Expiration"] = true
L["Expiration Close"] = true
L["Expiration Minutes"] = true
L["Expiration Seconds"] = true
L["Expiration sets the remaining time on the buff to be displayed by the module"] = true
L["Filter Auras"] = true
L["Filter Auras duration"] = true
L["Filter Auras with a total duration higher than this value (minutes)"] = true
L["Filter long duration Auras"] = true
L["Filters"] = true
L["First"] = true
L["Focus"] = true
L["Focus (Pet)"] = true
L["Focus (pets)"] = true
L["Focus Health"] = true
L["Focus Power"] = true
L["Font size"] = true
L["Full"] = true
L["General"] = true
L["General Options"] = true
L["Half Time"] = true
L["Half'n'Away"] = true
L["Health"] = true
L["Health Inner/Power Outer"] = true
L["Health Left/Power Right"] = true
L["Health Outer/Power Inner"] = true
L["Health Right/Power Left"] = true
L["Health Style"] = true
L["Hear you"] = true
L["Hide on Cool down"] = true
L["Hide runes that are on cool down."] = true
L["High"] = true
L["If set this style will override Agro Text Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Agro Text Style setting.)"] = true
L["If set this style will override Bar Text Style value. Replace H (health) and M (mana/power) on your tags by X and DHUD4 will replace it appropriately depending on the status you are tracking. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Bar Text Style setting.)"] = true
L["If set this style will override Health Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"] = true
L["If set this style will override Mana Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Mana Style setting.)"] = true
L["If set this style will override Name Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"] = true
L["If set this style will override Power Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Power Style setting.)"] = true
L["In Combat"] = true
L["In Vehicle"] = true
L["In vehicle bar swap"] = true
L["Inner"] = true
L["Is Tanking"] = true
L["Lacerates"] = true
L["Lacerates Timer"] = true
L["Last"] = true
L["Layout"] = true
L["Left"] = true
L["Left Bar"] = true
L["Left Inner"] = true
L["Left Outer"] = true
L["Lifebloom"] = true
L["Lifebloom Timer"] = true
L["Lock Layout"] = true
L["Lost you"] = true
L["Low"] = true
L["Mana"] = true
L["Mana Style"] = true
L["Master Looter"] = true
L["Med"] = true
L["Middle"] = true
L["Name Style"] = true
L["Name of the texture's folder"] = true
L["None"] = true
L["Number of Buffs"] = true
L["Number of Debuffs"] = true
L["On Party"] = true
L["Only Mine"] = true
L["Only show buffs cast by me"] = true
L["Only show debuffs applied by me"] = true
L["Only show own auras"] = true
L["Only track Agro while on party/raid"] = true
L["Out of Combat"] = true
L["Out of range"] = true
L["Out of range or unavailable"] = true
L["Outer"] = true
L["Paladin"] = true
L["Paladin Abilities"] = true
L["Party Leader"] = true
L["Percent%"] = true
L["Pet"] = true
L["Pet Frame"] = true
L["Pet Happiness Icon"] = true
L["Pet Module"] = true
L["PetBars"] = true
L["Place the Pet's bars"] = true
L["Place the Player's bars. Target's bars will be set accordingly"] = true
L["Place the Target's bars. PLayer module overrides this setting"] = true
L["Player"] = true
L["Player Frame"] = true
L["Player Module"] = true
L["Player/Target Bars"] = true
L["Position"] = true
L["Position of the cast bar, Player bar has presedence"] = true
L["Power"] = true
L["Power Style"] = true
L["Pull Agro Percent (Total Agro Percent"] = true
L["PvP Flag"] = true
L["PvP Timer"] = true
L["Rage"] = true
L["Raid Icon"] = true
L["Range"] = true
L["Range Colors"] = true
L["Ranges are aproximate and can vary according to class, race, spec, etc."] = true
L["Raw Threat Percent"] = true
L["Ready"] = true
L["Regeneracy"] = true
L["Resting"] = true
L["Reverse"] = true
L["Right"] = true
L["Right Bar"] = true
L["Right Inner"] = true
L["Right Outer"] = true
L["Rogue"] = true
L["Rogue Abilities"] = true
L["Roughly 0 ~ 5 yards"] = true
L["Roughly 25 ~ 45 yards"] = true
L["Roughly 45 ~ 80 yards"] = true
L["Roughly 5 ~ 25 yards"] = true
L["Round Robin"] = true
L["Rune Layout"] = true
L["Runic Power"] = true
L["See you"] = true
L["Selection"] = true
L["Set Abilities' scale"] = true
L["Set DHUD4's scale"] = true
L["Set how to display the runes. Round Robin places them in a single vertical row, runes rotate moving used ones to the top of the line. Bottom up places them at the lower side of the bars, grouped in pairs. Half'n'Away places them at the center of the bar, in vertical pairs positioned away from the bar. Centered places the runes in the center of the HUD, above the target's name plate (in this mode side setting for abilities won't have any difference)."] = true
L["Set the HUD's situation alpha. The order shown is the precedence order, i.e. Combat alpha will override Selection alpha"] = true
L["Show"] = true
L["Show Abilities tips"] = true
L["Show Aura Tips"] = true
L["Show Bar Borders"] = true
L["Show Bar Values"] = true
L["Show Bars when empty"] = true
L["Show Blizzard's Cast Bar."] = true
L["Show Blizzard's pet frame. If you hide the Player's frame no matter your choice here the Pet Frame will be hidden"] = true
L["Show Blizzard's player frame"] = true
L["Show Blizzard's target frame"] = true
L["Show Minimap Button"] = true
L["Show cast delay"] = true
L["Show cast timer"] = true
L["Show spell name"] = true
L["Show target Name plate"] = true
L["Show target of target Name plate"] = true
L["Show/Hide"] = true
L["Show/Hide Auras from weapon enchants"] = true
L["Show/Hide Blizzard's PLayer Cast Bar."] = true
L["Show/Hide Player cast bar"] = true
L["Show/Hide Timer"] = true
L["Show/hide borders"] = true
L["Show/hide empty (0 value) bars"] = true
L["Side"] = true
L["Side to show the cast bar, Player bar has presedence"] = true
L["Size"] = true
L["Spell Name"] = true
L["Status Icons"] = true
L["Sunder Armors"] = true
L["Sunder Armors Timer"] = true
L["Swap Target Auras"] = true
L["Swap player's bars for pet's when using vehicles"] = true
L["Tapped"] = true
L["Target"] = true
L["Target Frame"] = true
L["Target Module"] = true
L["Target Name Plate"] = true
L["Target Of Target Health"] = true
L["Target Of Target Power"] = true
L["Target Range"] = true
L["Target Target Name Plate"] = true
L["Text Size"] = true
L["Texture"] = true
L["The abilities module manages specific class abilities tracking."] = true
L["The auras module manages player buffs display"] = true
L["The folder must exist in .../DHUD4/textures/. Leave blank to use on of the default textures"] = true
L["The font used by all Modules"] = true
L["The outer module manages the outer bars functionality. Track focus, target of target or agro"] = true
L["The pet module manages pet bars and text and happines icon. The pet bars can track druid mana and vehicle status"] = true
L["The player module manages player bars and text, and rest, combat, leader and loot icons"] = true
L["The target module manages target bars and text, buffs and debuffs, and pvp, raid, and elite icons."] = true
L["This setting will only be available if the Auras Module is disabled"] = true
L["This setting will override the side setting for the abilities module"] = true
L["Threat Percent"] = true
L["Threat Status"] = true
L["Timer"] = true
L["Top"] = true
L["Total Agro Percent"] = true
L["Total Agro Percent = Threat Status"] = true
L["Track Agro while pet is active"] = true
L["Track Death Knight Runes"] = true
L["Track Druid lacerates expiration"] = true
L["Track Druid lifebloom expiration"] = true
L["Track druid combo points"] = true
L["Track druid lacerates"] = true
L["Track druid lifebloom"] = true
L["Track druid's mana when shape shifted (requires Pet Module to be enabled)"] = true
L["Track paladin power"] = true
L["Track rogue combo points"] = true
L["Track warrior sunder armors"] = true
L["Track warrior sunder armors expiration"] = true
L["Track your agro status by coloring the bar border"] = true
L["Track your raw threat as a percent of the tank's current threat"] = true
L["Track your total threat as the percent required to pull agro"] = true
L["Unavailable"] = true
L["Use bar border to display rango information"] = true
L["Use pet bars to track vehicle/player stats"] = true
L["Vertical position"] = true
L["Warrior"] = true
L["Warrior Abilities"] = true
L["Weapon Auras order"] = true
L["Weapon Enchants"] = true
L["Weapon enchant display. Weapon auras are displayed in pairs: first two, last two, bottom two or top two slots, regardless of the buffs displayed"] = true
L["Weapons"] = true
L["When NPC"] = true
L["With Pet"] = true


--[===[@debug@
-- Locales from Minimap.lua
-- Locales from DHUD4.lua
L["<level> <name>"] = true
L["<level><elite> <name> [ <class> ]"] = true
L["<level><elite> <name>"] = true
L["<name> [ <class> ]"] = true
L["Alphas"] = true
L["Bar font"] = true
L["Casting"] = true
L["Center Spacing"] = true
L["Centered"] = true
L["Cheking this option will prevent tooltips, frame moving and menu popping"] = true
L["Click Trough Frames"] = true
L["Combat"] = true
L["Config Layout"] = true
L["Configure bar's border functionality"] = true
L["Current (Percent%)"] = true
L["Current"] = true
L["Current/Max (Percent%)"] = true
L["Current/Max"] = true
L["Custom Texture"] = true
L["Death"] = true
L["Full"] = true
L["General Options"] = true
L["General"] = true
L["Left"] = true
L["Lock Layout"] = true
L["Low"] = true
L["Med"] = true
L["Name of the texture's folder"] = true
L["Out of Combat"] = true
L["Percent%"] = true
L["Regeneracy"] = true
L["Right"] = true
L["Selection"] = true
L["Set DHUD4's scale"] = true
L["Set the HUD's situation alpha. The order shown is the precedence order, i.e. Combat alpha will override Selection alpha"] = true
L["Show Bar Borders"] = true
L["Show Bars when empty"] = true
L["Show Minimap Button"] = true
L["Show/hide borders"] = true
L["Show/hide empty (0 value) bars"] = true
L["Texture"] = true
L["The folder must exist in .../DHUD4/textures/. Leave blank to use on of the default textures"] = true
L["The font used by all Modules"] = true
L["Vertical position"] = true
-- Locales from Layout.lua
-- Locales from DHUD4_Bar.lua
-- Locales from DHUD4_StatusBar.lua
L["Bar's Text"] = true
L["Configure Health and Power (mana/rage/energy/runic) text options"] = true
L["Custom Health Style"] = true
L["Custom Power Style"] = true
L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."] = true
L["Font size"] = true
L["Health Style"] = true
L["Health"] = true
L["If set this style will override Health Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"] = true
L["If set this style will override Power Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Power Style setting.)"] = true
L["Power Style"] = true
L["Power"] = true
L["Show Bar Values"] = true
-- Locales from DHUD4_CastBar.lua
-- Locales from DHUD4_Target.lua
L["Auras"] = true
L["Bar Colors"] = true
L["Bar Layout"] = true
L["Bar"] = true
L["Begin"] = true
L["Breath you"] = true
L["Buffs"] = true
L["Cast Bar"] = true
L["Cast bars fills in reverse direction"] = true
L["Cast"] = true
L["Change Auras's side"] = true
L["Colors"] = true
L["Columns"] = true
L["Complete"] = true
L["Custom Name Style"] = true
L["Debuffs"] = true
L["Delay Time"] = true
L["Elite Icon"] = true
L["Enable Target Module"] = true
L["Enable clicks"] = true
L["Enabling this option will make the whole name plate non click trough"] = true
L["Energy"] = true
L["Focus"] = true
L["Half Time"] = true
L["Health Inner/Power Outer"] = true
L["Health Left/Power Right"] = true
L["Health Outer/Power Inner"] = true
L["Health Right/Power Left"] = true
L["Hear you"] = true
L["If set this style will override Name Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"] = true
L["Inner"] = true
L["Layout"] = true
L["Lost you"] = true
L["Mana"] = true
L["Middle"] = true
L["Name Style"] = true
L["Number of Buffs"] = true
L["Number of Debuffs"] = true
L["Only Mine"] = true
L["Only show buffs cast by me"] = true
L["Only show debuffs applied by me"] = true
L["Out of range or unavailable"] = true
L["Out of range"] = true
L["Place the Target's bars. Player module overrides this setting"] = true
L["Player/Target Bars"] = true
L["Position of the cast bar, Player bar has presedence"] = true
L["Position"] = true
L["PvP Flag"] = true
L["Rage"] = true
L["Raid Icon"] = true
L["Range Colors"] = true
L["Range"] = true
L["Ranges are aproximate and can vary according to class, race, spec, etc."] = true
L["Reverse"] = true
L["Roughly 0 ~ 5 yards"] = true
L["Roughly 25 ~ 45 yards"] = true
L["Roughly 45 ~ 80 yards"] = true
L["Roughly 5 ~ 25 yards"] = true
L["Runic Power"] = true
L["See you"] = true
L["Show Aura Tips"] = true
L["Show Blizzard's target frame"] = true
L["Show cast delay"] = true
L["Show cast timer"] = true
L["Show spell name"] = true
L["Show target Name plate"] = true
L["Show target of target Name plate"] = true
L["Show"] = true
L["Show/Hide Player cast bar"] = true
L["Show/Hide Timer"] = true
L["Show/Hide"] = true
L["Side to show the cast bar, Player bar has presedence"] = true
L["Side"] = true
L["Size"] = true
L["Spell Name"] = true
L["Status Icons"] = true
L["Swap Target Auras"] = true
L["Tapped"] = true
L["Target Frame"] = true
L["Target Module"] = true
L["Target Name Plate"] = true
L["Target Range"] = true
L["Target Target Name Plate"] = true
L["Target"] = true
L["Text Size"] = true
L["The target module manages target bars and text, buffs and debuffs, and pvp, raid, and elite icons."] = true
L["Timer"] = true
L["Use bar border to display rango information"] = true
L["When NPC"] = true
-- Locales from DHUD4_Player.lua
L["Blizz Cast Bar"] = true
L["Enable Player Module"] = true
L["In Combat"] = true
L["In vehicle bar swap"] = true
L["Master Looter"] = true
L["Party Leader"] = true
L["Place the Player's bars. Target's bars will be set accordingly"] = true
L["Player Frame"] = true
L["Player Module"] = true
L["Player"] = true
L["PvP Timer"] = true
L["Resting"] = true
L["Show Blizzard's player frame"] = true
L["Show/Hide Blizzard's PLayer Cast Bar."] = true
L["Swap player's bars for pet's when using vehicles"] = true
L["The player module manages player bars and text, and rest, combat, leader and loot icons"] = true
-- Locales from DHUD4_Outer.lua
L["Agro Status"] = true
L["Agro Text Style"] = true
L["Agro Tracking"] = true
L["Agro"] = true
L["Bar Text Style"] = true
L["Bar tracks"] = true
L["Custom Agro Style"] = true
L["Custom Text Style"] = true
L["Enable Outer Module"] = true
L["Focus (Pet)"] = true
L["Focus Health"] = true
L["Focus Power"] = true
L["High"] = true
L["If set this style will override Agro Text Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Agro Text Style setting.)"] = true
L["If set this style will override Bar Text Style value. Replace H (health) and M (mana/power) on your tags by X and DHUD4 will replace it appropriately depending on the status you are tracking. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Bar Text Style setting.)"] = true
L["Is Tanking"] = true
L["Left Bar"] = true
L["None"] = true
L["On Party"] = true
L["Only track Agro while on party/raid"] = true
L["Outer"] = true
L["Pull Agro Percent (Total Agro Percent"] = true
L["Raw Threat Percent"] = true
L["Right Bar"] = true
L["Target Of Target Health"] = true
L["Target Of Target Power"] = true
L["The outer module manages the outer bars functionality. Track focus, target of target or agro"] = true
L["Threat Percent"] = true
L["Threat Status"] = true
L["Total Agro Percent = Threat Status"] = true
L["Total Agro Percent"] = true
L["Track Agro while pet is active"] = true
L["Track your agro status by coloring the bar border"] = true
L["Track your raw threat as a percent of the tank's current threat"] = true
L["Track your total threat as the percent required to pull agro"] = true
L["With Pet"] = true
-- Locales from DHUD4_Pet.lua
L["Enable Pet Module"] = true
L["In Vehicle"] = true
L["Pet Frame"] = true
L["Pet Happiness Icon"] = true
L["Pet Module"] = true
L["Pet"] = true
L["PetBars"] = true
L["Place the Pet's bars"] = true
L["Show Blizzard's pet frame. If you hide the Player's frame no matter your choice here the Pet Frame will be hidden"] = true
L["The pet module manages pet bars and text and happines icon. The pet bars can track druid mana and vehicle status"] = true
L["Use pet bars to track vehicle/player stats"] = true
-- Locales from DHUD4_Auras.lua
L["About to Expire"] = true
L["Aura filter options"] = true
L["Auras Module"] = true
L["Auras Side"] = true
L["Auras' scale"] = true
L["Border Color"] = true
L["Bottom"] = true
L["By default the buff border starts changing towards <Expiration> when there are 20 seconds remaining."] = true
L["Choose weapon Auras display order"] = true
L["Enable Auras Module"] = true
L["Expiration Close"] = true
L["Expiration Minutes"] = true
L["Expiration Seconds"] = true
L["Expiration sets the remaining time on the buff to be displayed by the module"] = true
L["Expiration"] = true
L["Filter Auras duration"] = true
L["Filter Auras with a total duration higher than this value (minutes)"] = true
L["Filter Auras"] = true
L["Filter long duration Auras"] = true
L["Filters"] = true
L["First"] = true
L["Last"] = true
L["Only show own auras"] = true
L["Show/Hide Auras from weapon enchants"] = true
L["The auras module manages player buffs display"] = true
L["This setting will override the side setting for the abilities module"] = true
L["Top"] = true
L["Weapon Auras order"] = true
L["Weapon Enchants"] = true
L["Weapon enchant display. Weapon auras are displayed in pairs: first two, last two, bottom two or top two slots, regardless of the buffs displayed"] = true
L["Weapons"] = true
-- Locales from DHUD4_Paladin.lua
L["Paladin Abilities"] = true
L["Paladin"] = true
L["Track paladin power"] = true
-- Locales from DHUD4_Warrior.lua
L["Sunder Armors Timer"] = true
L["Sunder Armors"] = true
L["Track warrior sunder armors expiration"] = true
L["Track warrior sunder armors"] = true
L["Warrior Abilities"] = true
L["Warrior"] = true
-- Locales from DHUD4_Abilities.lua
L["Abilities Module"] = true
L["Abilities Side"] = true
L["Configure general functionality"] = true
L["Enable Abilities"] = true
L["Ready"] = true
L["Set Abilities' scale"] = true
L["Show Abilities tips"] = true
L["The abilities module manages specific class abilities tracking."] = true
L["This setting will only be available if the Auras Module is disabled"] = true
L["Unavailable"] = true
-- Locales from DHUD4_Rogue.lua
L["Combos"] = true
L["Rogue Abilities"] = true
L["Rogue"] = true
L["Track rogue combo points"] = true
-- Locales from DHUD4_DeathKnight.lua
L["Bottom Up"] = true
L["Death Knight Abilities"] = true
L["Death Knight Runes"] = true
L["Death Knight"] = true
L["Half'n'Away"] = true
L["Hide on Cool down"] = true
L["Hide runes that are on cool down."] = true
L["Round Robin"] = true
L["Rune Layout"] = true
L["Set how to display the runes. Round Robin places them in a single vertical row, runes rotate moving used ones to the top of the line. Bottom up places them at the lower side of the bars, grouped in pairs. Half'n'Away places them at the center of the bar, in vertical pairs positioned away from the bar. Centered places the runes in the center of the HUD, above the target's name plate (in this mode side setting for abilities won't have any difference)."] = true
L["Track Death Knight Runes"] = true
-- Locales from DHUD4_Druid.lua
L["Bar to track mana (pet bars are used)"] = true
L["Custom Mana Style"] = true
L["Druid Abilities"] = true
L["Druid Bar Values"] = true
L["Druid Mana Tracking"] = true
L["Druid Mana"] = true
L["Druid"] = true
L["Eclipse Lunar Phase"] = true
L["Eclipse Solar Phase"] = true
L["Enter /dog for in-game LibDogTag-3.0 Tag documentation"] = true
L["If set this style will override Mana Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Mana Style setting.)"] = true
L["Lacerates Timer"] = true
L["Lacerates"] = true
L["Left Inner"] = true
L["Left Outer"] = true
L["Lifebloom Timer"] = true
L["Lifebloom"] = true
L["Mana Style"] = true
L["Right Inner"] = true
L["Right Outer"] = true
L["Track Druid lacerates expiration"] = true
L["Track Druid lifebloom expiration"] = true
L["Track druid combo points"] = true
L["Track druid lacerates"] = true
L["Track druid lifebloom"] = true
L["Track druid's mana when shape shifted (requires Pet Module to be enabled)"] = true
--@end-debug@]===]