-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Gathering Locale - zhTW
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Gathering/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Gathering", "zhTW")
if not L then return end

L["Alchemy"] = "鍊金術" -- Needs review
L["Blacksmithing"] = "鍛造" -- Needs review
L["Buy Merchant Items"] = [=[購入商人產品
better off "購入npc產品"]=] -- Needs review
L["Characters (bags/banks) to gather from:"] = [=[儲存物料的角色
(it means the charater that store materials)]=] -- Needs review
L["Character you will craft on:"] = "你會用來生產的角色" -- Needs review
L["Cooking"] = "烹飪" -- Needs review
L["Creates a task list to gather mats according to the above settings."] = "根據以上設定, 設立工序表及收集物料" -- Needs review
L["Currently Gathering for:"] = [=[收集物料以提供給:
(it means "to collect materials and provide them to" . In Chinese the structure looks like "For XXXX currently gather :". You can't translate it properly without rephrasing it)]=] -- Needs review
L["Done Gathering"] = "收集完成" -- Needs review
L["Enchanting"] = "附魔中" -- Needs review
L["Engineering"] = "工程學" -- Needs review
L["Finished gathering from bank."] = [=[從銀行中提領完成
( -> From bank inside take finished -- it means "finished gathering from bank" but in Chinese structure)]=] -- Needs review
L["Finished gathering from guild bank."] = "從公會銀行中提領完成" -- Needs review
L["Gathering"] = [=[收集
收集物料中.......
(The second one means "gathering materials". In Chinese "collect concentrate" is exactly the same as the present participle "Gathering" in continuous tense )
]=] -- Needs review
L["Gathering will create a list of task required to collect mats you need for your craft queue from your alts, banks, or guild banks according to the settings below."] = [=[集料庫將會根據以下設定來設立所需工序的清單, 以從你的小號,銀行及工會銀行收集製造物品所需的材料
(it means "the collecting wizard will according to below settings to create required task's list, to from your alt, bank and guild bank collect create item required materials" -- again Chinese sentence structure is quite different from English so I kinda rephrased it. The meaning, however, hasn't changed.)]=] -- Needs review
L["Gather Mats From Alts"] = "由小號收集物料" -- Needs review
L["Guilds (guild banks) to gather from:"] = "從以下公會(銀行)中提領" -- Needs review
L["Inscription"] = "銘文學" -- Needs review
L["Jewelcrafting"] = "珠寶學" -- Needs review
L["Leatherworking"] = "製皮" -- Needs review
L["Log onto %s"] = "換號至 %s" -- Needs review
L["Mailed items off to %s!"] = [=[物件寄往 %s
(it means "mail things to %s.)]=] -- Needs review
L["No Gathering Required"] = [=[不必收集物料
(There can be a better translation here as I do not know one of the Chinese charaters)]=] -- Needs review
L["Profession to gather mats for:"] = "為以下專業收集材料" -- Needs review
L["Select which characters you would like to gather mats from. This will include their bags and personal banks."] = "選擇從那個角色收集材料(包含包包及個人銀行)" -- Needs review
L["Select which guild's guild banks you ould like to gather mats from."] = "選擇從那個公會銀行收集材料" -- Needs review
L["Specify which character you will craft on. All gathered mats will be mailed to this character."] = "指明製造的角色, 收集到的材料將會寄到此角色" -- Needs review
L["Specify which profession's craft queue you would like to gather mats for."] = "指明為了那個專業的生產序列收集物料" -- Needs review
L["Start Gathering"] = "開始收集材料" -- Needs review
L["Stop Gathering"] = "停止收集材料" -- Needs review
L["Tailoring"] = "裁縫" -- Needs review
L["Task:"] = "工序" -- Needs review
L["Visit the Bank"] = "到銀行去" -- Needs review
L["Visit the Guild Bank"] = "到公會銀行去" -- Needs review
L["Visit the Mailbox"] = "到郵筒去" -- Needs review
L["Your bags are full and nothing in your bags is ready to be mailed. Please clear some items from your bags and try again."] = "你包包已滿而沒有東西可以寄出, 請先漓包包後再試" -- Needs review
