--[[

$Revision: 49 $

(C) Copyright 2007,2009 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Initialization

local L = LibStub("AceLocale-3.0"):NewLocale("Analyst", "zhCN", false)


----------------------------------------------------------------------
-- Translations

if L then
-- Slsah commands
L["SLASH_COMMANDS"] = { "analyst" }
L["ECONOMY"] = "经济分析面板"
L["ECONOMY_DESC"] = "开启/关闭 经济分析面板。"
L["START_DAY_OF_WEEK"] = "周起始日"
L["START_DAY_OF_WEEK_DESC"] = "设置周统计起始日(1-7)，1 代表周一。"
L["SHOW_GOLD"] = "显示金钱变化"
L["SHOW_GOLD_DESC"] = "设置是否在标题中显示金钱获取/花费之数量。"
L["ECONOMY_FRAME_HINT"] = "|cFFFFFF00点击|r - 开启/关闭 经济分析面板."

-- Bindings
L["BINDING_HEADER_ANALYST"] = "经济活动分析"
L["BINDING_NAME_ECONOMY"] = "开启/关闭 经济分析面板"
	
-- Purchases
L["BANK_SLOT"] = "银行栏位"
L["PETITION"] = "申请"
L["GUILD_CHARTER"] = "公会登记表"
L["GUILD_CREST"] = "公会徽章"
L["STABLE_SLOT"] = "宠物存放栏位"
L["GUILD_BANK_TAB"] = "公会银行栏页"
	
-- Capture
L["GROUPED"] = "(队伍/团队)"
	
-- Measures
L["MONEY_GAINED_TOTAL"] = "获得总额"
L["MONEY_GAINED_QUESTING"] = "任务"
L["MONEY_GAINED_LOOTING"] = "拾取"
L["MONEY_GAINED_OPENING"] = "开启"
L["MONEY_GAINED_SELLING"] = "商人-卖出"
L["MONEY_GAINED_AUCTION"] = "拍卖行"
L["MONEY_GAINED_GUILD_BANKING"] = "公会银行"
L["MONEY_GAINED_TRADING"] = "交易"
L["MONEY_GAINED_RECEIVING"] = "邮件"
L["MONEY_GAINED_MISCELLANEOUS"] = "杂项"
L["MONEY_SPENT_TOTAL"] = "花费总额"
L["MONEY_SPENT_QUESTING"] = "任务"
L["MONEY_SPENT_BUYING"] = "商人-购入"
L["MONEY_SPENT_TRAINING"] = "训练师"
L["MONEY_SPENT_PURCHASING"] = "购买"
L["MONEY_SPENT_REPAIRING"] = "修复"
L["MONEY_SPENT_TAXI"] = "空运"
L["MONEY_SPENT_AUCTION"] = "拍卖行"
L["MONEY_SPENT_GUILD_BANKING"] = "公会银行"
L["MONEY_SPENT_TRADING"] = "交易"
L["MONEY_SPENT_SENDING"] = "邮件"
L["MONEY_SPENT_MISCELLANEOUS"] = "杂项"
L["ITEM_CONSUMED_QUESTING"] = "任务"
L["ITEM_CONSUMED_CASTING"] = "施放"
L["ITEM_CONSUMED_USING"] = "使用"
L["ITEM_CONSUMED_OPENING"] = "开启"
L["ITEM_CONSUMED_CRAFTING"] = "专业技能"
L["ITEM_CONSUMED_SOCKETING"] = "宝石插槽" -- need check
L["ITEM_CONSUMED_DESTROYING"] = "摧毁"
L["ITEM_CONSUMED_SENDING"] = "寄送邮件"
L["ITEM_CONSUMED_MISCELLANEOUS"] = "杂项"
L["ITEM_PRODUCED_QUESTING"] = "任务"
L["ITEM_PRODUCED_CASTING"] = "施放"
L["ITEM_PRODUCED_USING"] = "使用"
L["ITEM_PRODUCED_OPENING"] = "开启"
L["ITEM_PRODUCED_CRAFTING"] = "专业技能"
L["ITEM_PRODUCED_GATHERING"] = "采集"
L["ITEM_PRODUCED_LOOTING"] = "拾取"
L["ITEM_PRODUCED_BATTLEFIELD"] = "战场"
L["ITEM_PRODUCED_RECEIVING"] = "接收邮件"
L["ITEM_PRODUCED_MISCELLANEOUS"] = "杂项"
L["QUESTING_FINISHED"] = "完成任务"
L["QUESTING_MONEY_GAINED"] = "获得金额"
L["QUESTING_MONEY_SPENT"] = "花费金额"
L["QUESTING_ITEM_PRODUCED"] = "拾取物品"
L["QUESTING_ITEM_CONSUMED"] = "消耗物品"
L["LOOTING_MOB"] = "怪物"
L["LOOTING_MONEY"] = "金钱"
L["LOOTING_ITEM"] = "物品"
L["LOOTING_ITEM_VENDOR_VALUE"] = "商人收购价"
L["MERCHANT_MONEY_GAINED"] = "卖出"
L["MERCHANT_MONEY_SPENT_BUYING"] = "购入"
L["MERCHANT_MONEY_SPENT_REPAIRING"] = "修复"
L["MERCHANT_ITEM_SOLD"] = "物品卖出"
L["MERCHANT_ITEM_BOUGHT"] = "物品购入"
L["MERCHANT_ITEM_SWAPED"] = "物品交易"
L["AUCTION_POSTED"] = "拍卖-公告"
L["AUCTION_SOLD"] = "拍卖-卖出"
L["AUCTION_EXPIRED"] = "拍卖-过期"
L["AUCTION_CANCELLED"] = "拍卖-取消"
L["AUCTION_MONEY_GAINED"] = "收款金额"
L["AUCTION_DEPOSIT_PAID"] = "公告保证金"
L["AUCTION_DEPOSIT_CREDITED"] = "退回保证金"
L["AUCTION_CONSIGNMENT"] = "拍卖费"
L["AUCTION_BID"] = "拍卖-出价"
L["AUCTION_BOUGHT"] = "拍卖-购入"
L["AUCTION_OUTBID"] = "拍卖-竞价"
L["AUCTION_MONEY_SPENT"] = "付费金额"
L["GUILD_BANKING_MONEY_WITHDRAWN"] = "提款"
L["GUILD_BANKING_MONEY_DEPOSITED"] = "存款"
L["GUILD_BANKING_ITEM_WITHDRAWN"] = "提领物品"
L["GUILD_BANKING_ITEM_DEPOSITED"] = "存入物品"
L["TRADING_MONEY_RECEIVED"] = "获取金额"
L["TRADING_MONEY_GIVEN"] = "赠予金额"
L["TRADING_ITEM_RECEIVED"] = "获取物品"
L["TRADING_ITEM_GIVEN"] = "赠予物品"
L["CRAFTING_TOTAL"] = "专业技能活动"
L["CRAFTING_ALCHEMY"] = "炼金术"
L["CRAFTING_BLACKSMITHING"] = "锻造"
L["CRAFTING_COOKING"] = "烹饪"
L["CRAFTING_DISENCHANTING"] = "分解"
L["CRAFTING_ENCHANTING"] = "附魔"
L["CRAFTING_FIRST_AID"] = "急救"
L["CRAFTING_JEWELCRAFTING"] = "珠宝加工"
L["CRAFTING_LEATHERWORKING"] = "制皮"
L["CRAFTING_PROSPECTING"] = "选矿"
L["CRAFTING_SMELTING"] = "熔炼"
L["CRAFTING_TAILORING"] = "裁缝"
L["GATHERING_TOTAL"] = "采集活动"
L["GATHERING_EXTRACT_GAS"] = "提炼气体"
L["GATHERING_FISHING"] = "钓鱼"
L["GATHERING_HERB_GATHERING"] = "采集草药"
L["GATHERING_MINING"] = "采矿"
L["GATHERING_SKINNING"] = "剥皮"
	
-- Measures
L["AUTOMATED"] = "(自动化)"
	
-- Reports
L["OVERVIEW"] = "综览"
L["MONEY_GAINED"] = "获得金额"
L["MONEY_SPENT"] = "花费金额"
L["ITEM_CONSUMED"] = "消耗物品"
L["ITEM_PRODUCED"] = "获得物品"
L["QUESTING"] = "任务"
L["LOOTING"] = "拾取"
L["MERCHANT"] = "商人"
L["AUCTION"] = "拍卖行"
L["GUILD_BANK"] = "公会银行"
L["TRADING"] = "交易"
L["CRAFTING"] = "专业技能"
L["GATHERING"] = "采集"
	
-- Measure
L["TALENT_WIPING"] = "遗忘天赋"
	
-- Periods
L["TODAY"] = "今天"
L["YESTERDAY"] = "昨天"
L["THIS_WEEK"] = "本周"
L["THIS_MONTH"] = "本月"
L["LAST_7_DAYS"] = "最后 7 天"
L["LAST_30_DAYS"] = "最后 30 天"
	
-- Economy frame
L["ECONOMY_FRAME_TITLE"] = "经济活动分析"
L["ALL_CHARACTERS"] = "所有角色"
L["ALL_CHARACTERS_TOOLTIP"] = "如选取，显示所有角色的帐目资料。如未选取，仅显示目前角色的帐目资料。"
L["NO_DETAIL_INFO"] = "無可用的详细资讯。"
L["CONSUMED"] = "消耗"
L["PRODUCED"] = "拾取"
end
