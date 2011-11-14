--[[

$Revision: 49 $

(C) Copyright 2009 StingerSoft
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Initialization

local L = LibStub("AceLocale-3.0"):NewLocale("Analyst", "ruRU")


----------------------------------------------------------------------
-- Translations

if L then
-- Slsah commands
L["SLASH_COMMANDS"] = { "analyst" }
L["ECONOMY"] = "панель экономики"
L["ECONOMY_DESC"] = "Переключение панели экономики."
L["OPTIONS"] = "Настройки"
L["OPTIONS_DESC"] = "Показать настройки."
L["START_DAY_OF_WEEK"] = "Начальный День недели"
L["START_DAY_OF_WEEK_DESC"] = "	Устанавливает начало дня недели (1-7)."
L["ECONOMY_FRAME_HINT"] = "|cFFFFFF00Клик|r переключает панель экономики."

-- Bindings
L["BINDING_HEADER_ANALYST"] = "Analyst"
L["BINDING_NAME_ECONOMY"] = "Переключение панели экономики"
	
-- Purchases
L["BANK_SLOT"] = "Слот в банке"
L["PETITION"] = "Петиции"
L["GUILD_CHARTER"] = "Хартия гильдии"
L["GUILD_CREST"] = "Guild Crest"
L["STABLE_SLOT"] = "Слот в стойле"
L["GUILD_BANK_TAB"] = "Закладка гильд банка"
	
-- Capture
L["GROUPED"] = "(Grouped)"
	
-- Measures
L["MONEY_GAINED_TOTAL"] = "Всего полученно золота"
L["MONEY_GAINED_QUESTING"] = "За задания"
L["MONEY_GAINED_LOOTING"] = "С добычи"
L["MONEY_GAINED_OPENING"] = "Открывание"
L["MONEY_GAINED_SELLING"] = "С продажи продавцу"
L["MONEY_GAINED_AUCTION"] = "Аукционов"
L["MONEY_GAINED_GUILD_BANKING"] = "Гильд банк"
L["MONEY_GAINED_TRADING"] = "Торговля"
L["MONEY_GAINED_RECEIVING"] = "Почта"
L["MONEY_GAINED_MISCELLANEOUS"] = "Разное"
L["MONEY_SPENT_TOTAL"] = "Всего потраченно золота"
L["MONEY_SPENT_QUESTING"] = "За задания"
L["MONEY_SPENT_BUYING"] = "На покупки у пратовца"
L["MONEY_SPENT_TRAINING"] = "На тренера"
L["MONEY_SPENT_PURCHASING"] = "Покупки"
L["MONEY_SPENT_REPAIRING"] = "Рестоврация"
L["MONEY_SPENT_TAXI"] = "Полёты"
L["MONEY_SPENT_AUCTION"] = "Аукционы"
L["MONEY_SPENT_GUILD_BANKING"] = "Гильд банк"
L["MONEY_SPENT_TRADING"] = "Торговля"
L["MONEY_SPENT_SENDING"] = "Почта"
L["MONEY_SPENT_MISCELLANEOUS"] = "Разное"
L["ITEM_CONSUMED_QUESTING"] = "За задания"
L["ITEM_CONSUMED_CASTING"] = "Применение"
L["ITEM_CONSUMED_USING"] = "Использование"
L["ITEM_CONSUMED_OPENING"] = "Открывание"
L["ITEM_CONSUMED_CRAFTING"] = "Ремесло"
L["ITEM_CONSUMED_SOCKETING"] = "Socketing"
L["ITEM_CONSUMED_DESTROYING"] = "Уничтожение"
L["ITEM_CONSUMED_SENDING"] = "Высланно по почте"
L["ITEM_CONSUMED_MISCELLANEOUS"] = "Разное"
L["ITEM_PRODUCED_QUESTING"] = "За задания"
L["ITEM_PRODUCED_CASTING"] = "Применение"
L["ITEM_PRODUCED_USING"] = "Использование"
L["ITEM_PRODUCED_OPENING"] = "Открывание"
L["ITEM_PRODUCED_CRAFTING"] = "Ремесло"
L["ITEM_PRODUCED_GATHERING"] = "Собранно"
L["ITEM_PRODUCED_LOOTING"] = "С добычи"
L["ITEM_PRODUCED_RECEIVING"] = "Полученно по почте"
L["ITEM_PRODUCED_MISCELLANEOUS"] = "Разное"
L["CURRENCY_GAINED_TOTAL"] = "Всего получено денег"
L["CURRENCY_GAINED_QUESTING"] = "За задания"
L["CURRENCY_GAINED_LOOTING"] = "С добычи"
L["CURRENCY_GAINED_BATTLEFIELD"] = "С полей сражения"
L["CURRENCY_SPENT_QUESTING"] = "Потрачено на задания"
L["CURRENCY_SPENT_BUYING"] = "Потрачено на покупки"
L["QUESTING_FINISHED"] = "Выполнено заданий"
L["QUESTING_MONEY_GAINED"] = "Получено золота"
L["QUESTING_MONEY_SPENT"] = "Потраченно золота"
L["QUESTING_ITEM_PRODUCED"] = "Изготовленно предметов"
L["QUESTING_ITEM_CONSUMED"] = "Расходованно предметов"
L["QUESTING_CURRENCY_GAINED"] = "Денег получено"
L["QUESTING_CURRENCY_SPENT"] = "Денег потрачено"
L["LOOTING_MOB"]= "Существа"
L["LOOTING_MONEY"] = "Золото"
L["LOOTING_ITEM"] = "Предметы"
L["LOOTING_ITEM_VENDOR_VALUE"] = "Цена у продовца"
L["LOOTING_CURRENCY"] = "Денег"
L["MERCHANT_MONEY_GAINED"] = "Продаж"
L["MERCHANT_MONEY_SPENT_BUYING"] = "Покупок"
L["MERCHANT_MONEY_SPENT_REPAIRING"] = "Рестоврация"
L["MERCHANT_ITEM_SOLD"] = "Предметов продано"
L["MERCHANT_ITEM_BOUGHT"] = "Предметов приобретено"
L["MERCHANT_ITEM_SWAPED"] = "Предметов обменено"
L["MERCHANT_CURRENCY_SPENT"] = "Потраченно золота"
L["AUCTION_POSTED"] = "Созданно аукционов"
L["AUCTION_SOLD"] = "Продаж на аукционе"
L["AUCTION_EXPIRED"] = "Истечение аукционов"
L["AUCTION_CANCELLED"] = "Аукционов отменено"
L["AUCTION_MONEY_GAINED"] = "Получено золота"
L["AUCTION_DEPOSIT_PAID"] = "Вклад"
L["AUCTION_DEPOSIT_CREDITED"] = "Кредит"
L["AUCTION_CONSIGNMENT"] = "Партия товаров"
L["AUCTION_BID"] = "Ставок на аукционе"
L["AUCTION_BOUGHT"] = "Покупок на аукционе"
L["AUCTION_OUTBID"] = "Перебито цен на аукционе"
L["AUCTION_MONEY_SPENT"] = "Потрачено золота"
L["GUILD_BANKING_MONEY_WITHDRAWN"] = "Изъято золота"
L["GUILD_BANKING_MONEY_DEPOSITED"] = "Вложенно золота"
L["GUILD_BANKING_ITEM_WITHDRAWN"] = "Изъято предметов"
L["GUILD_BANKING_ITEM_DEPOSITED"] = "Вложенно предметов"
L["TRADING_MONEY_RECEIVED"] = "Получено золота"
L["TRADING_MONEY_GIVEN"] = "Переданно золота"
L["TRADING_ITEM_RECEIVED"] = "Получено предметов"
L["TRADING_ITEM_GIVEN"] = "Переданно предметов"
L["CRAFTING_TOTAL"] = "Активность ремесла"
L["CRAFTING_ALCHEMY"] = "Алхимия"
L["CRAFTING_BLACKSMITHING"] = "Кузнечное дело"
L["CRAFTING_COOKING"] = "Кулинария"
L["CRAFTING_DISENCHANTING"] = "Распыление"
L["CRAFTING_ENCHANTING"] = "Наложение чар"
L["CRAFTING_FIRST_AID"] = "Первая помощь"
L["CRAFTING_INSCRIPTION"] = "Начертание"
L["CRAFTING_JEWELCRAFTING"] = "Ювелирное дело"
L["CRAFTING_LEATHERWORKING"] = "Кожевничество"
L["CRAFTING_MILLING"] = "Измельчение"
L["CRAFTING_PROSPECTING"] = "Просеивание"
L["CRAFTING_SMELTING"] = "Выплавка металлов"
L["CRAFTING_TAILORING"] = "Портняжное дело"
L["GATHERING_TOTAL"] = "Активность сбора"
L["GATHERING_EXTRACT_GAS"] = "Извлечение газа"
L["GATHERING_FISHING"] = "Рыбная ловля"
L["GATHERING_HERB_GATHERING"] = "Сбор трав"
L["GATHERING_MINING"] = "Горное дело"
L["GATHERING_SKINNING"] = "Снятие шкур"
	
-- Measures
L["AUTOMATED"] = "(Automated)"
	
-- Reports
L["OVERVIEW"] = "Обзор"
L["MONEY_GAINED"] = "Получено золота"
L["MONEY_SPENT"] = "Потрачено золота"
L["ITEM_CONSUMED"] = "Расходованно предметов"
L["ITEM_PRODUCED"] = "Изготовленно предметов"
L["CURRENCY"] = "Деньги"
L["QUESTING"] = "От заданий"
L["LOOTING"] = "Добыча"
L["MERCHANT"] = "Торговец"
L["AUCTION"] = "Аукцион"
L["GUILD_BANK"] = "Банк гильдии"
L["TRADING"] = "Торговля"
L["CRAFTING"] = "Ремесло"
L["GATHERING"] = "Собранно"
	
-- Measure
L["TALENT_WIPING"] = "Сброс талантов"
	
-- Periods
L["TODAY"] = "Сегодня"
L["YESTERDAY"] = "Вчера"
L["THIS_WEEK"] = "На этой неделе"
L["THIS_MONTH"] = "В этом месяце"
L["LAST_7_DAYS"] = "За последних 7д"
L["LAST_30_DAYS"] = "За последних 30д"
	
-- Economy frame
L["ECONOMY_FRAME_TITLE"] = "Экономика"
L["ALL_CHARACTERS"] = "Все персонажы"
L["ALL_CHARACTERS_TOOLTIP"] = "Если флажок установлен, данные будут отображаться для всех персонажей на этой учетной записи. Если ее не отмеченно, данные будут отображаться для текущего персонажа."
L["NO_DETAIL_INFO"] = "Нет подробной информации."
L["CONSUMED"] = "Расходованно"
L["PRODUCED"] = "Изготавленно"
end
