-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Gathering Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Gathering/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Gathering", "enUS", true)
if not L then return end

-- TradeSkillMaster_Gathering.lua
L["Gathering: %s on player, %s on alts, %s in guild banks, %s on AH"] = true
L["%s: %s (%s in bags, %s in bank, %s on AH)"] = true
L["%s: %s in guild bank"] = true
L["Gathering"] = true
L["Done Gathering"] = true
L["No Gathering Required"] = true

-- config.lua
L["Enchanting"] = true
L["Inscription"] = true
L["Jewelcrafting"] = true
L["Alchemy"] = true
L["Blacksmithing"] = true
L["Leatherworking"] = true
L["Tailoring"] = true
L["Engineering"] = true
L["Cooking"] = true
L["Gather Mats From Alts"] = true
L["Gathering will create a list of tasks required to collect mats you need for your craft queue from your alts, banks, and guild banks according to the settings below."] = true
L["Profession to gather mats for:"] = true
L["Specify which profession's craft queue you would like to gather mats for."] = true
L["Character you will craft on:"] = true
L["Specify which character you will craft on. All gathered mats will be mailed to this character."] = true
L["Characters (bags/banks) to gather from:"] = true
L["Select which characters you would like to gather mats from. This will include their bags and personal banks."] = true
L["Guilds (guild banks) to gather from:"] = true
L["Select which guild's guild banks you would like to gather mats from."] = true
L["Start Gathering"] = true
L["Creates a task list to gather mats according to the above settings."] = true
L["Options"] = true
L["Tooltip:"] = true
L["No Tooltip Info"] = true
L["Simple"] = true
L["Full"] = true
L["Here, you can choose what Gathering info, if any, to show in tooltips. \"Simple\" will show only show totals for bags/banks and for guild banks. \"Full\" will show detailed information for every character and guild."] = true
L["Delete Character:"] = true
L["\"%s\" removed from Gathering."] = true
L["If you rename / transfer / delete one of your characters, use this dropdown to remove that character from Gathering. There is no confirmation. If you accidentally delete a character that still exists, simply log onto that character to re-add it to Gathering."] = true

-- gather.lua
L["Finished gathering from bank."] = true
L["Finished gathering from guild bank."] = true
L["Your bags are full and nothing in your bags is ready to be mailed. Please clear some items from your bags and try again."] = true


-- gui.lua
L["Stop Gathering"] = true
L["Currently Gathering for:"] = true
L["Log onto %s"] = true
L["Mailing:"] = true
L["Visit the Mailbox"] = true
L["Gathering from Bank:"] = true
L["Visit the Bank"] = true
L["Gathering from Guild Bank:"] = true
L["Visit the Guild Bank"] = true
L["Task:"] = true
L["Buy Merchant Items"] = true

-- mail.lua
L["Mailed items off to %s!"] = true