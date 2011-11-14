--[[

$Revision: 81 $

(C) Copyright 2007,2010 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Initialization

local L = LibStub("AceLocale-3.0"):NewLocale("Analyst", "deDE", false)


----------------------------------------------------------------------
-- Translations

if L then
-- Slsah commands
L["ANALYST"] = "Analyst"
L["SLASH_COMMANDS"] = { "analyst" }
L["PROFILES"] = "Profile"
L["ECONOMY"] = "Ökonomie-Panel"
L["ECONOMY_DESC"] = "Blendet das Ökonomie-Panel ein oder aus."
L["MINIMAP"] = "Minimap Icon"
L["MINIMAP_DESC"] = "Schaltet das Minimap-Icon dieses Add-Ons an oder aus."
L["START_DAY_OF_WEEK"] = "Anfangstag der Woche"
L["START_DAY_OF_WEEK_DESC"] = "Bestimmt den Anfangstag der Woche (1-7), wobei 1 für Montag steht."
L["RESET_SESSION"] = "Session zurücksetzen"
L["RESET_SESSION_DESC"] = "Setzt die laufende Session zurück und löscht alle Session-Statistiken."
L["ECONOMY_FRAME_HINT"] = "|cFFFFFF00Klicken|r, um das Ökonomie-Panel ein- oder auszublenden."
	
-- Bindings
L["BINDING_HEADER_ANALYST"] = "Analyst"
L["BINDING_NAME_ECONOMY"] = "Ökonomie-Panel ein- oder ausblenden"
	
-- Purchases
L["BANK_SLOT"] = "Bank-Slot"
L["PETITION"] = "Gesuch"
L["GUILD_CHARTER"] = "Gildensatzung"
L["GUILD_CREST"] = "Gildenwappen"
L["STABLE_SLOT"] = "Stall-Slot"
L["GUILD_BANK_TAB"] = "Gildenbankreiter"
	
-- Capture
L["GROUPED"] = "(Gruppiert)"
	
-- Measures
L["MONEY_GAINED_TOTAL"] = "Total Gold verdient"
L["MONEY_GAINED_QUESTING"] = "Questen"
L["MONEY_GAINED_LOOTING"] = "Looten"
L["MONEY_GAINED_OPENING"] = "Öffnen"
L["MONEY_GAINED_SELLING"] = "Händlerverkauf"
L["MONEY_GAINED_AUCTION"] = "Auktionen"
L["MONEY_GAINED_GUILD_BANKING"] = "Gildenbank"
L["MONEY_GAINED_TRADING"] = "Handeln"
L["MONEY_GAINED_RECEIVING"] = "Post"
L["MONEY_GAINED_MISCELLANEOUS"] = "Verschiedenes"
L["MONEY_SPENT_TOTAL"] = "Total Gold ausgegeben"
L["MONEY_SPENT_QUESTING"] = "Questen"
L["MONEY_SPENT_BUYING"] = "Händlerkauf"
L["MONEY_SPENT_TRAINING"] = "Trainer"
L["MONEY_SPENT_PURCHASING"] = "Beschaffung"
L["MONEY_SPENT_REPAIRING"] = "Reparieren"
L["MONEY_SPENT_TAXI"] = "Flüge"
L["MONEY_SPENT_AUCTION"] = "Auktionen"
L["MONEY_SPENT_GUILD_BANKING"] = "Gildenbank"
L["MONEY_SPENT_TRADING"] = "Handeln"
L["MONEY_SPENT_SENDING"] = "Post"
L["MONEY_SPENT_MISCELLANEOUS"] = "Verschiedenes"
L["ITEM_CONSUMED_QUESTING"] = "Questen"
L["ITEM_CONSUMED_CASTING"] = "Wirken"
L["ITEM_CONSUMED_USING"] = "Benutzen"
L["ITEM_CONSUMED_OPENING"] = "Öffnen"
L["ITEM_CONSUMED_CRAFTING"] = "Verarbeitung"
L["ITEM_CONSUMED_SOCKETING"] = "Sockeln"
L["ITEM_CONSUMED_DESTROYING"] = "Zerstört"
L["ITEM_CONSUMED_SENDING"] = "Versandt per Post"
L["ITEM_CONSUMED_MISCELLANEOUS"] = "Verschiedenes"
L["ITEM_PRODUCED_QUESTING"] = "Questen"
L["ITEM_PRODUCED_CASTING"] = "Wirken"
L["ITEM_PRODUCED_USING"] = "Benutzen"
L["ITEM_PRODUCED_OPENING"] = "Öffnen"
L["ITEM_PRODUCED_CRAFTING"] = "Verarbeitung"
L["ITEM_PRODUCED_GATHERING"] = "Sammeln"
L["ITEM_PRODUCED_LOOTING"] = "Looten"
L["ITEM_PRODUCED_BATTLEFIELD"] = "Schlachtfeld"
L["ITEM_PRODUCED_RECEIVING"] = "Erhalten per Post"
L["ITEM_PRODUCED_MISCELLANEOUS"] = "Verschiedenes"
L["CURRENCY_GAINED_TOTAL"] = "Total Abzeichen verdient"
L["CURRENCY_GAINED_QUESTING"] = "Verdient Questen"
L["CURRENCY_GAINED_OPENING"] = "Verdient Öffnen"
L["CURRENCY_GAINED_LOOTING"] = "Verdient Looten"
L["CURRENCY_GAINED_MISCELLANEOUS"] = "Verdient Verschiedenes"
L["CURRENCY_SPENT_QUESTING"] = "Ausgeg. Questen"
L["CURRENCY_SPENT_BUYING"] = "Ausgeg. Händlerkauf"
L["CURRENCY_HONORABLE_KILL"] = "Ehrenhafte Siege"
L["QUESTING_FINISHED"] = "Quests abgeschlossen"
L["QUESTING_MONEY_GAINED"] = "Gold verdient"
L["QUESTING_MONEY_SPENT"] = "Gold ausgegeben"
L["QUESTING_ITEM_PRODUCED"] = "Gegenstände hergest."
L["QUESTING_ITEM_CONSUMED"] = "Gegenstände verbr."
L["QUESTING_CURRENCY_GAINED"] = "Abzeichen verdient"
L["QUESTING_CURRENCY_SPENT"] = "Abzeichen ausgeg."
L["LOOTING_MOB"]= "Mobs"
L["LOOTING_MONEY"] = "Gold"
L["LOOTING_ITEM"] = "Gegenstände"
L["LOOTING_ITEM_VENDOR_VALUE"] = "Händlerwert"
L["LOOTING_CURRENCY"] = "Abzeichen"
L["MERCHANT_MONEY_GAINED"] = "Verkäufe"
L["MERCHANT_MONEY_SPENT_BUYING"] = "Einkäufe"
L["MERCHANT_MONEY_SPENT_REPAIRING"] = "Reparieren"
L["MERCHANT_ITEM_SOLD"] = "Gegenstände verkauft"
L["MERCHANT_ITEM_BOUGHT"] = "Gegenstände gekauft"
L["MERCHANT_ITEM_SWAPED"] = "Gegenstände getauscht"
L["MERCHANT_CURRENCY_SPENT"] = "Abzeichen ausgegeben"
L["AUCTION_POSTED"] = "Auktionen erstellt"
L["AUCTION_SOLD"] = "Auktionen verkauft"
L["AUCTION_EXPIRED"] = "Auktionen abgelaufen"
L["AUCTION_CANCELLED"] = "Auktionen abgebrochen"
L["AUCTION_MONEY_GAINED"] = "Gold verdient"
L["AUCTION_DEPOSIT_PAID"] = "Anzahlung"
L["AUCTION_DEPOSIT_CREDITED"] = "Gutschrift"
L["AUCTION_CONSIGNMENT"] = "Gebühr"
L["AUCTION_BID"] = "Auktionen geboten"
L["AUCTION_BOUGHT"] = "Auktionen gekauft"
L["AUCTION_OUTBID"] = "Auktionen überboten"
L["AUCTION_MONEY_SPENT"] = "Gold ausgegeben"
L["GUILD_BANKING_MONEY_WITHDRAWN"] = "Gold entnommen"
L["GUILD_BANKING_MONEY_DEPOSITED"] = "Gold eingelagert"
L["GUILD_BANKING_ITEM_WITHDRAWN"] = "Gegenstände entn."
L["GUILD_BANKING_ITEM_DEPOSITED"] = "Gegenstände eingel."
L["TRADING_MONEY_RECEIVED"] = "Gold erhalten"
L["TRADING_MONEY_GIVEN"] = "Gold gegeben"
L["TRADING_ITEM_RECEIVED"] = "Gegenstände erhalten"
L["TRADING_ITEM_GIVEN"] = "Gegenstände gegeben"
L["CRAFTING_TOTAL"] = "Verarbeitungsaktivität"
L["CRAFTING_ALCHEMY"] = "Alchimie"
L["CRAFTING_BLACKSMITHING"] = "Schmiedekunst"
L["CRAFTING_COOKING"] = "Kochen"
L["CRAFTING_DISENCHANTING"] = "Entzaubern"
L["CRAFTING_ENCHANTING"] = "Verzauberkunst"
L["CRAFTING_ENGINEERING"] = "Ingenieurskunst"
L["CRAFTING_FIRST_AID"] = "Erste Hilfe"
L["CRAFTING_INSCRIPTION"] = "Schriftkunde"
L["CRAFTING_JEWELCRAFTING"] = "Juwelenschleifen"
L["CRAFTING_LEATHERWORKING"] = "Lederverarbeitung"
L["CRAFTING_MILLING"] = "Mahlen"
L["CRAFTING_PROSPECTING"] = "Sondieren"
L["CRAFTING_SMELTING"] = "Schmelzen"
L["CRAFTING_TAILORING"] = "Schneiderei"
L["GATHERING_TOTAL"] = "Sammelaktivität"
L["GATHERING_ARCHAEOLOGY"] = "Archäologie"
L["GATHERING_ENGINEERING"] = "Ingenieurskunst"
L["GATHERING_EXTRACT_GAS"] = "Gas extrahieren"
L["GATHERING_FISHING"] = "Fischen"
L["GATHERING_HERB_GATHERING"] = "Kräuterkunde"
L["GATHERING_MINING"] = "Bergbau"
L["GATHERING_SKINNING"] = "Kürschnerei"
	
-- Measures
L["AUTOMATED"] = "(Automatisiert)"
	
-- Reports
L["OVERVIEW"] = "Übersicht"
L["MONEY_GAINED"] = "Gold verdient"
L["MONEY_SPENT"] = "Gold ausgegeben"
L["ITEM_CONSUMED"] = "Gegenstände verbraucht"
L["ITEM_PRODUCED"] = "Gegenstände hergestellt"
L["CURRENCY"] = "Abzeichen"
L["QUESTING"] = "Questen"
L["LOOTING"] = "Looten"
L["MERCHANT"] = "Händler"
L["AUCTION"] = "Auktionshaus"
L["GUILD_BANK"] = "Gildenbank"
L["TRADING"] = "Handeln"
L["CRAFTING"] = "Verarbeitung"
L["GATHERING"] = "Sammeln"
	
-- Measure
L["TALENT_WIPING"] = "Talente löschen"
	
-- Periods
L["SESSION"] = "Session"
L["TODAY"] = "Heute"
L["YESTERDAY"] = "Gestern"
L["THIS_WEEK"] = "Diese Woche"
L["THIS_MONTH"] = "Dieser Monat"
L["LAST_7_DAYS"] = "Letzte 7 Tage"
L["LAST_30_DAYS"] = "Letzte 30 Tage"
	
-- Economy frame
L["ECONOMY_FRAME_TITLE"] = "Ökonomie"
L["ALL_CHARACTERS"] = "Alle Charaktere"
L["ALL_CHARACTERS_TOOLTIP"] = "Wenn angewählt, dann werden die Daten für alle Charaktere auf diesem Konto angezeigt. Wenn abgewählt, dann werden die Daten für eingelogten Charakter angezeigt."
L["NO_DETAIL_INFO"] = "Keine Detailinformationen verfügbar."
L["CONSUMED"] = "Verbraucht"
L["PRODUCED"] = "Hergestellt"
end