-- ------------------------------------------------------------------------------------- --
--   TradeSkillMaster_ItemTracker - AddOn by Sapu94undefined                                       --
--   http://www.curse.com/addons/wow/undefined                         --
--                                                                                       --
--   This addon is licensed under the CC BY-NC-ND 3.0 license as described at the        --
--   following url: http://creativecommons.org/licenses/by-nc-nd/3.0/                    --
--   Please contact the author via email at sapu94@gmail.com with any questions or       --
--   concerns regarding this license.                                                    --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_ItemTracker Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkill-Master/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_ItemTracker", "enUS", true)
if not L then return end

-- TradeSkillMaster_ItemTracker.lua

L["trackerMessage"] = true
L["If you previously used TSM_Gathering, note that inventory data was not transfered to TSM_ItemTracker and will not show up until you log onto each character and visit the bank / gbank / auction house."] = true
L["ItemTracker: %s on player, %s on alts, %s in guild banks, %s on AH"] = true
L["%s: %s (%s in bags, %s in bank, %s on AH)"] = true
L["%s: %s in guild bank"] = true

-- config.lua

L["Options"] = true
L["No Tooltip Info"] = true
L["Simple"] = true
L["Full"] = true
L["Here, you can choose what ItemTracker info, if any, to show in tooltips. \"Simple\" will show only show totals for bags/banks and for guild banks. \"Full\" will show detailed information for every character and guild."] = true
L["Delete Character:"] = true
L["\"%s\" removed from ItemTracker."] = true
L["If you rename / transfer / delete one of your characters, use this dropdown to remove that character from ItemTracker. There is no confirmation. If you accidentally delete a character that still exists, simply log onto that character to re-add it to ItemTracker."] = true