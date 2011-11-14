--[[

$Revision: 49 $

(C) Copyright 2007,2009 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Initialization

local L = LibStub("AceLocale-3.0"):NewLocale("Analyst", "zhTW", false)


----------------------------------------------------------------------
-- Translations

if L then
-- Slsah commands
L["SLASH_COMMANDS"] = { "analyst" }
L["ECONOMY"] = "經濟分析面板"
L["ECONOMY_DESC"] = "開啟/關閉 經濟分析面板。"
L["START_DAY_OF_WEEK"] = "週起始日"
L["START_DAY_OF_WEEK_DESC"] = "設定週的起始日(1-7)，1 代表週一。"
L["SHOW_GOLD"] = "顯示金錢變化"
L["SHOW_GOLD_DESC"] = "設定是否在標題中顯示金錢獲取/花費之數量。"
L["ECONOMY_FRAME_HINT"] = "|cFFFFFF00點擊|r - 開啟/關閉 經濟分析面板."

-- Bindings
L["BINDING_HEADER_ANALYST"] = "經濟活動分析"
L["BINDING_NAME_ECONOMY"] = "開啟/關閉 經濟分析面板"
	
-- Purchases
L["BANK_SLOT"] = "銀行欄位"
L["PETITION"] = "申請"
L["GUILD_CHARTER"] = "公會登記表"
L["GUILD_CREST"] = "公會徽章"
L["STABLE_SLOT"] = "寵物存放欄位"
L["GUILD_BANK_TAB"] = "公會銀行欄頁"
	
-- Capture
L["GROUPED"] = "(隊伍/團隊)"
	
-- Measures
L["MONEY_GAINED_TOTAL"] = "獲得總額"
L["MONEY_GAINED_QUESTING"] = "任務"
L["MONEY_GAINED_LOOTING"] = "拾取"
L["MONEY_GAINED_OPENING"] = "開啟"
L["MONEY_GAINED_SELLING"] = "商人-賣出"
L["MONEY_GAINED_AUCTION"] = "拍賣場"
L["MONEY_GAINED_GUILD_BANKING"] = "公會銀行"
L["MONEY_GAINED_TRADING"] = "交易"
L["MONEY_GAINED_RECEIVING"] = "郵件"
L["MONEY_GAINED_MISCELLANEOUS"] = "雜項"
L["MONEY_SPENT_TOTAL"] = "花費總額"
L["MONEY_SPENT_QUESTING"] = "任務"
L["MONEY_SPENT_BUYING"] = "商人-購入"
L["MONEY_SPENT_TRAINING"] = "訓練師"
L["MONEY_SPENT_PURCHASING"] = "購買"
L["MONEY_SPENT_REPAIRING"] = "修復"
L["MONEY_SPENT_TAXI"] = "空運"
L["MONEY_SPENT_AUCTION"] = "拍賣場"
L["MONEY_SPENT_GUILD_BANKING"] = "公會銀行"
L["MONEY_SPENT_TRADING"] = "交易"
L["MONEY_SPENT_SENDING"] = "郵件"
L["MONEY_SPENT_MISCELLANEOUS"] = "雜項"
L["ITEM_CONSUMED_QUESTING"] = "任務"
L["ITEM_CONSUMED_CASTING"] = "施放"
L["ITEM_CONSUMED_USING"] = "使用"
L["ITEM_CONSUMED_OPENING"] = "開啟"
L["ITEM_CONSUMED_CRAFTING"] = "專業技能"
L["ITEM_CONSUMED_SOCKETING"] = "寶石插槽" -- need check
L["ITEM_CONSUMED_DESTROYING"] = "摧毀"
L["ITEM_CONSUMED_SENDING"] = "寄送郵件"
L["ITEM_CONSUMED_MISCELLANEOUS"] = "雜項"
L["ITEM_PRODUCED_QUESTING"] = "任務"
L["ITEM_PRODUCED_CASTING"] = "施放"
L["ITEM_PRODUCED_USING"] = "使用"
L["ITEM_PRODUCED_OPENING"] = "開啟"
L["ITEM_PRODUCED_CRAFTING"] = "專業技能"
L["ITEM_PRODUCED_GATHERING"] = "採集"
L["ITEM_PRODUCED_LOOTING"] = "拾取"
L["ITEM_PRODUCED_BATTLEFIELD"] = "戰場"
L["ITEM_PRODUCED_RECEIVING"] = "接收郵件"
L["ITEM_PRODUCED_MISCELLANEOUS"] = "雜項"
L["QUESTING_FINISHED"] = "完成任務"
L["QUESTING_MONEY_GAINED"] = "獲得金額"
L["QUESTING_MONEY_SPENT"] = "花費金額"
L["QUESTING_ITEM_PRODUCED"] = "拾取物品"
L["QUESTING_ITEM_CONSUMED"] = "消耗物品"
L["LOOTING_MOB"] = "怪物"
L["LOOTING_MONEY"] = "金錢"
L["LOOTING_ITEM"] = "物品"
L["LOOTING_ITEM_VENDOR_VALUE"] = "商人收購價"
L["MERCHANT_MONEY_GAINED"] = "賣出"
L["MERCHANT_MONEY_SPENT_BUYING"] = "購入"
L["MERCHANT_MONEY_SPENT_REPAIRING"] = "修復"
L["MERCHANT_ITEM_SOLD"] = "物品賣出"
L["MERCHANT_ITEM_BOUGHT"] = "物品購入"
L["MERCHANT_ITEM_SWAPED"] = "物品交易"
L["AUCTION_POSTED"] = "拍賣-公告"
L["AUCTION_SOLD"] = "拍賣-賣出"
L["AUCTION_EXPIRED"] = "拍賣-過期"
L["AUCTION_CANCELLED"] = "拍賣-取消"
L["AUCTION_MONEY_GAINED"] = "收款金額"
L["AUCTION_DEPOSIT_PAID"] = "公告保證金"
L["AUCTION_DEPOSIT_CREDITED"] = "退回保證金"
L["AUCTION_CONSIGNMENT"] = "拍賣費"
L["AUCTION_BID"] = "拍賣-出價"
L["AUCTION_BOUGHT"] = "拍賣-購入"
L["AUCTION_OUTBID"] = "拍賣-競價"
L["AUCTION_MONEY_SPENT"] = "付費金額"
L["GUILD_BANKING_MONEY_WITHDRAWN"] = "提款"
L["GUILD_BANKING_MONEY_DEPOSITED"] = "存款"
L["GUILD_BANKING_ITEM_WITHDRAWN"] = "提領物品"
L["GUILD_BANKING_ITEM_DEPOSITED"] = "存入物品"
L["TRADING_MONEY_RECEIVED"] = "獲取金額"
L["TRADING_MONEY_GIVEN"] = "贈與金額"
L["TRADING_ITEM_RECEIVED"] = "獲取物品"
L["TRADING_ITEM_GIVEN"] = "贈與物品"
L["CRAFTING_TOTAL"] = "專業技能活動"
L["CRAFTING_ALCHEMY"] = "鍊金術"
L["CRAFTING_BLACKSMITHING"] = "鍛造"
L["CRAFTING_COOKING"] = "烹飪"
L["CRAFTING_DISENCHANTING"] = "分解"
L["CRAFTING_ENCHANTING"] = "附魔"
L["CRAFTING_FIRST_AID"] = "急救"
L["CRAFTING_JEWELCRAFTING"] = "珠寶設計"
L["CRAFTING_LEATHERWORKING"] = "製皮"
L["CRAFTING_PROSPECTING"] = "勘探"
L["CRAFTING_SMELTING"] = "熔煉"
L["CRAFTING_TAILORING"] = "裁縫"
L["GATHERING_TOTAL"] = "採集活動"
L["GATHERING_EXTRACT_GAS"] = "提煉氣體雲"
L["GATHERING_FISHING"] = "釣魚"
L["GATHERING_HERB_GATHERING"] = "採集草藥"
L["GATHERING_MINING"] = "採礦"
L["GATHERING_SKINNING"] = "剝皮"
	
-- Measures
L["AUTOMATED"] = "(自動化)"
	
-- Reports
L["OVERVIEW"] = "綜覽"
L["MONEY_GAINED"] = "獲得金額"
L["MONEY_SPENT"] = "花費金額"
L["ITEM_CONSUMED"] = "消耗物品"
L["ITEM_PRODUCED"] = "獲得物品"
L["QUESTING"] = "任務"
L["LOOTING"] = "拾取"
L["MERCHANT"] = "商人"
L["AUCTION"] = "拍賣場"
L["GUILD_BANK"] = "公會銀行"
L["TRADING"] = "交易"
L["CRAFTING"] = "專業技能"
L["GATHERING"] = "採集"
	
-- Measure
L["TALENT_WIPING"] = "遺忘天賦"
	
-- Periods
L["TODAY"] = "今天"
L["YESTERDAY"] = "昨天"
L["THIS_WEEK"] = "本週"
L["THIS_MONTH"] = "本月"
L["LAST_7_DAYS"] = "最後 7 天"
L["LAST_30_DAYS"] = "最後 30 天"
	
-- Economy frame
L["ECONOMY_FRAME_TITLE"] = "經濟活動分析"
L["ALL_CHARACTERS"] = "所有角色"
L["ALL_CHARACTERS_TOOLTIP"] = "如選取，顯示所有角色的帳目資料。如未選取，僅顯示目前角色的帳目資料。"
L["NO_DETAIL_INFO"] = "無可用的詳細資訊。"
L["CONSUMED"] = "消耗"
L["PRODUCED"] = "拾取"
end
