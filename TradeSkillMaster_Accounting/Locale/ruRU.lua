-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Accounting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/TradeSkillMaster_Accounting.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Accounting Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Accounting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Accounting", "ruRU")
if not L then return end

L["Accounting"] = "Accounting" -- Needs review
L["Activity Log"] = "Журнал активности" -- Needs review
L["Activity Type"] = "Тип активности" -- Needs review
L["Auctions"] = "Лоты" -- Needs review
L["Average Prices:"] = "Средняя цена:" -- Needs review
L["Avg Buy Price"] = "Средн. цена выкупа" -- Needs review
L["Avg Resale Profit"] = "Средн. прибыль от перепродажи" -- Needs review
L["Avg Sell Price"] = "Средн. цена продажи" -- Needs review
L["Back to Previous Page"] = "Назад к пред. странице" -- Needs review
L["Bought"] = "Куплено" -- Needs review
L["Buyer/Seller"] = "Покупатель/продавец" -- Needs review
-- L["Clear Old Data"] = ""
L["Click for a detailed report on this item."] = "Нажмите для вывода подробного отчета об этом предмете" -- Needs review
-- L["Click this button to permanently remove data older than the number of days selected in the dropdown."] = ""
L["Common Quality Items"] = "Предметы обычного качества" -- Needs review
-- L["Data older than this many days will be deleted when you click on the button to the right."] = ""
-- L["Days:"] = ""
L["DD/MM/YY HH:MM"] = "ДД/ММ/ГГ ЧЧ:ММ" -- Needs review
L["Earned Per Day:"] = "Заработано за день" -- Needs review
L["Epic Quality Items"] = "Предметы превосходного качества" -- Needs review
L["General Options"] = "Общие настройки" -- Needs review
L["Gold Earned:"] = "Заработано золота:" -- Needs review
L["Gold Spent:"] = "Потрачено золота:" -- Needs review
L["_ Hr _ Min ago"] = "_ Ч _ Мин назад" -- Needs review
-- L["If checked, the average purchase price that shows in the tooltip will be the average price for the most recent X you have purchased, where X is the number you have in your bags / bank / gbank using data from the ItemTracker module. Otherwise, a simple average of all purchases will be used."] = ""
L["If checked, the number you have purchased and the average purchase price will show up in an item's tooltip."] = "Показывать количество и среднюю цену покупки предмета в подсказке." -- Needs review
L["If checked, the number you have sold and the average sale price will show up in an item's tooltip."] = "Показывать количество и среднюю цену продажи предмета в подсказке." -- Needs review
L["Item Name"] = "Название предмета" -- Needs review
L["Items"] = "Предметы" -- Needs review
L["Items in an Auctioning Group"] = "Предметы в аукционных группах" -- Needs review
L["Items NOT in an Auctioning Group"] = "Предметы не в аукционных группах" -- Needs review
-- L["Items/Resale Price Format"] = ""
L["Last 30 Days:"] = "Последние 30 дней:" -- Needs review
L["Last 7 Days:"] = "Последние 7 дней:" -- Needs review
L["Last Purchase"] = "Последняя покупка" -- Needs review
L["Last Sold"] = "Последняя продажа" -- Needs review
L["Market Value"] = "Рыночная цена" -- Needs review
L["Market Value Source"] = "Откуда брать рыночную цену" -- Needs review
L["MM/DD/YY HH:MM"] = "ММ/ДД/ГГ ЧЧ:ММ" -- Needs review
-- L["MySales Import Complete! Imported %s sales. Was unable to import %s sales."] = ""
-- L["MySales Import Progress"] = ""
-- L["MySales is currently disabled. Would you like Accounting to enable it and reload your UI so it can transfer settings?"] = ""
-- L["none"] = ""
L["Options"] = "Настройки" -- Needs review
L["Price Per Item"] = "Цена за предмет" -- Needs review
L["Purchase"] = "Покупка" -- Needs review
L["Purchase Data"] = "Дата покупки" -- Needs review
L["Purchased (Avg Price): %s (%s)"] = "Куплено (средн. цена): %s (%s)" -- Needs review
-- L["Purchased (Smart Avg): %s (%s)"] = ""
L["Purchases"] = "Покупки" -- Needs review
L["Quantity"] = "Количество" -- Needs review
L["Quantity Bought:"] = "Куплено количество:" -- Needs review
L["Quantity Sold:"] = "Продано количество:" -- Needs review
L["Rare Quality Items"] = "Предметы редкого качества" -- Needs review
-- L["Removed a total of %s old records and %s items with no remaining records."] = ""
-- L["Remove Old Data (No Confirmation)"] = ""
L["Resale"] = "Перепродажа" -- Needs review
L["%s ago"] = "% назад" -- Needs review
L["Sale"] = "Продажа" -- Needs review
L["Sale Data"] = "Дата продажи" -- Needs review
L["Sales"] = "Продажи" -- Needs review
L["Search"] = "Поиск" -- Needs review
-- L["Select how you would like prices to be shown in the \"Items\" and \"Resale\" tabs; either average price per item or total value."] = ""
L["Select what format Accounting should use to display times in applicable screens."] = "Выберите формат показа данных на" -- Needs review
L["Select where you want Accounting to get market value info from to show in applicable screens."] = "Выберите откуда брать данные о средней рыночной цене для показа на" -- Needs review
L["Show purchase info in item tooltips"] = "Показывать информацию о покупках предмета в подсказке" -- Needs review
L["Show sale info in item tooltips"] = "Показывать информацию о продажах предмета в подсказке" -- Needs review
L["Sold"] = "Продано" -- Needs review
L["Sold (Avg Price): %s (%s)"] = "Продано (средн. цена): %s (%s)" -- Needs review
L["Special Filters"] = "Спец. фильтры" -- Needs review
L["Spent Per Day:"] = "Потрачено в день" -- Needs review
L["Stack Size"] = "Размер стака" -- Needs review
-- L["Starting to import MySales data. This requires building a large cache of item names which will take about 20-30 seconds. Please be patient."] = ""
L["Summary"] = "Итого" -- Needs review
L["There is no purchase data for this item."] = "Нет данных о покупке этого предмета." -- Needs review
L["There is no sale data for this item."] = "Нет данных о продаже этого предмета." -- Needs review
L["Time"] = "Время" -- Needs review
L["Time Format"] = "Формат времени" -- Needs review
L["Tooltip Options"] = "Настройки подсказки" -- Needs review
L["Top Buyers:"] = "Рейтинг покупателей" -- Needs review
-- L["Top Item by Gold:"] = ""
-- L["Top Item by Quantity:"] = ""
-- L["Top Sellers:"] = ""
L["Total:"] = "Итого:" -- Needs review
-- L["Total Buy Price"] = ""
-- L["Total Price"] = ""
-- L["Total Sale Price"] = ""
L["Total Spent:"] = "Всего потрачено:" -- Needs review
-- L["Total Value"] = ""
-- L["TradeSkillMaster_Accounting has detected that you have MySales installed. Would you like to transfer your data over to Accounting?"] = ""
-- L["Uncommon Quality Items"] = ""
-- L["Use smart average for purchase price"] = ""
--[==[ L[ [=[You can use the options below to clear old data. It is recommened to occasionally clear your old data to keep Accounting running smoothly. Select the minimum number of days old to be removed in the dropdown, then click the button.

NOTE: There is no confirmation.]=] ] = "" ]==]
L["YY/MM/DD HH:MM"] = "ГГ/ММ/ДД ЧЧ:ММ" -- Needs review
 