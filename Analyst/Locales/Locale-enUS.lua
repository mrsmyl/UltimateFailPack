--[[

$Revision: 81 $

(C) Copyright 2007,2010 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Initialization

local L = LibStub("AceLocale-3.0"):NewLocale("Analyst", "enUS", true)


----------------------------------------------------------------------
-- Translations

if L then
-- Slsah commands
L["ANALYST"] = "Analyst"
L["SLASH_COMMANDS"] = { "analyst" }
L["PROFILES"] = "Profiles"
L["ECONOMY"] = "Economy Panel"
L["ECONOMY_DESC"] = "Toggles the Economy panel."
L["OPTIONS"] = "Options"
L["OPTIONS_DESC"] = "Shows the options."
L["MINIMAP"] = "Minimap Icon"
L["MINIMAP_DESC"] = "Toggles the minimap icon of this add-on."
L["START_DAY_OF_WEEK"] = "Start Day of Week"
L["START_DAY_OF_WEEK_DESC"] = "Sets the start day of the week (1-7), with 1 representing Monday."
L["RESET_SESSION"] = "Reset Session"
L["RESET_SESSION_DESC"] = "Resets the current session, clearing all session statistics."
L["ECONOMY_FRAME_HINT"] = "|cFFFFFF00Click|r to toggle the Economy panel."

-- Bindings
L["BINDING_HEADER_ANALYST"] = "Analyst"
L["BINDING_NAME_ECONOMY"] = "Toggle Economy Panel"
	
-- Purchases
L["BANK_SLOT"] = "Bank Slot"
L["PETITION"] = "Petition"
L["GUILD_CHARTER"] = "Guild Charter"
L["GUILD_CREST"] = "Guild Crest"
L["STABLE_SLOT"] = "Stable Slot"
L["GUILD_BANK_TAB"] = "Guild Bank Tab"
	
-- Capture
L["GROUPED"] = "(Grouped)"
L["LOOT_CURRENCY"] = "You receive currency: %s."
L["LOOT_CURRENCY_MULTIPLE"] = "You receive currency: %s x%d."
	
-- Measures
L["MONEY_GAINED_TOTAL"] = "Total Gold Gained"
L["MONEY_GAINED_QUESTING"] = "Questing"
L["MONEY_GAINED_LOOTING"] = "Looting"
L["MONEY_GAINED_OPENING"] = "Opening"
L["MONEY_GAINED_SELLING"] = "Vendor Selling"
L["MONEY_GAINED_AUCTION"] = "Auctions"
L["MONEY_GAINED_GUILD_BANKING"] = "Guild Bank"
L["MONEY_GAINED_TRADING"] = "Trading"
L["MONEY_GAINED_RECEIVING"] = "Mail"
L["MONEY_GAINED_MISCELLANEOUS"] = "Miscellaneous"
L["MONEY_SPENT_TOTAL"] = "Total Gold Spent"
L["MONEY_SPENT_QUESTING"] = "Questing"
L["MONEY_SPENT_BUYING"] = "Vendor Buying"
L["MONEY_SPENT_TRAINING"] = "Trainer"
L["MONEY_SPENT_PURCHASING"] = "Purchases"
L["MONEY_SPENT_REPAIRING"] = "Repairing"
L["MONEY_SPENT_TAXI"] = "Flights"
L["MONEY_SPENT_AUCTION"] = "Auctions"
L["MONEY_SPENT_GUILD_BANKING"] = "Guild Bank"
L["MONEY_SPENT_TRADING"] = "Trading"
L["MONEY_SPENT_SENDING"] = "Mail"
L["MONEY_SPENT_MISCELLANEOUS"] = "Miscellaneous"
L["ITEM_CONSUMED_QUESTING"] = "Questing"
L["ITEM_CONSUMED_CASTING"] = "Casting"
L["ITEM_CONSUMED_USING"] = "Using"
L["ITEM_CONSUMED_OPENING"] = "Opening"
L["ITEM_CONSUMED_CRAFTING"] = "Crafting"
L["ITEM_CONSUMED_SOCKETING"] = "Socketing"
L["ITEM_CONSUMED_DESTROYING"] = "Destroyed"
L["ITEM_CONSUMED_SENDING"] = "Sent by Mail"
L["ITEM_CONSUMED_MISCELLANEOUS"] = "Miscellaneous"
L["ITEM_PRODUCED_QUESTING"] = "Questing"
L["ITEM_PRODUCED_CASTING"] = "Casting"
L["ITEM_PRODUCED_USING"] = "Using"
L["ITEM_PRODUCED_OPENING"] = "Opening"
L["ITEM_PRODUCED_CRAFTING"] = "Crafting"
L["ITEM_PRODUCED_GATHERING"] = "Gathering"
L["ITEM_PRODUCED_LOOTING"] = "Looting"
L["ITEM_PRODUCED_RECEIVING"] = "Received by Mail"
L["ITEM_PRODUCED_MISCELLANEOUS"] = "Miscellaneous"
L["CURRENCY_GAINED_TOTAL"] = "Total Currency Gained"
L["CURRENCY_GAINED_QUESTING"] = "Gained Questing"
L["CURRENCY_GAINED_OPENING"] = "Gained Opening"
L["CURRENCY_GAINED_LOOTING"] = "Gained Looting"
L["CURRENCY_GAINED_MISCELLANEOUS"] = "Gained Miscellaneous"
L["CURRENCY_SPENT_QUESTING"] = "Spent Questing"
L["CURRENCY_SPENT_BUYING"] = "Spent Vendor Buying"
L["CURRENCY_HONORABLE_KILL"] = "Honorable Kills"
L["QUESTING_FINISHED"] = "Quests Finished"
L["QUESTING_MONEY_GAINED"] = "Gold Gained"
L["QUESTING_MONEY_SPENT"] = "Gold Spent"
L["QUESTING_ITEM_PRODUCED"] = "Items Produced"
L["QUESTING_ITEM_CONSUMED"] = "Items Consumed"
L["QUESTING_CURRENCY_GAINED"] = "Currency Gained"
L["QUESTING_CURRENCY_SPENT"] = "Currency Spent"
L["LOOTING_MOB"]= "Mobs"
L["LOOTING_MONEY"] = "Gold"
L["LOOTING_ITEM"] = "Items"
L["LOOTING_ITEM_VENDOR_VALUE"] = "Vendor Value"
L["LOOTING_CURRENCY"] = "Currency"
L["MERCHANT_MONEY_GAINED"] = "Sales"
L["MERCHANT_MONEY_SPENT_BUYING"] = "Buying"
L["MERCHANT_MONEY_SPENT_REPAIRING"] = "Repairing"
L["MERCHANT_ITEM_SOLD"] = "Items Sold"
L["MERCHANT_ITEM_BOUGHT"] = "Items Bought"
L["MERCHANT_ITEM_SWAPED"] = "Items Swaped"
L["MERCHANT_CURRENCY_SPENT"] = "Currency Spent"
L["AUCTION_POSTED"] = "Auctions Posted"
L["AUCTION_SOLD"] = "Auctions Sold"
L["AUCTION_EXPIRED"] = "Auctions Expired"
L["AUCTION_CANCELLED"] = "Auctions Cancelled"
L["AUCTION_MONEY_GAINED"] = "Gold Gained"
L["AUCTION_DEPOSIT_PAID"] = "Deposit"
L["AUCTION_DEPOSIT_CREDITED"] = "Credit"
L["AUCTION_CONSIGNMENT"] = "Consignment"
L["AUCTION_BID"] = "Auctions Bid"
L["AUCTION_BOUGHT"] = "Auctions Bought"
L["AUCTION_OUTBID"] = "Auctions Outbid"
L["AUCTION_MONEY_SPENT"] = "Gold Spent"
L["GUILD_BANKING_MONEY_WITHDRAWN"] = "Gold Withdrawn"
L["GUILD_BANKING_MONEY_DEPOSITED"] = "Gold Deposited"
L["GUILD_BANKING_ITEM_WITHDRAWN"] = "Items Withdrawn"
L["GUILD_BANKING_ITEM_DEPOSITED"] = "Items Deposited"
L["TRADING_MONEY_RECEIVED"] = "Gold Received"
L["TRADING_MONEY_GIVEN"] = "Gold Given"
L["TRADING_ITEM_RECEIVED"] = "Items Received"
L["TRADING_ITEM_GIVEN"] = "Items Given"
L["CRAFTING_TOTAL"] = "Crafting Activity"
L["CRAFTING_ALCHEMY"] = "Alchemy"
L["CRAFTING_BLACKSMITHING"] = "Blacksmithing"
L["CRAFTING_COOKING"] = "Cooking"
L["CRAFTING_DISENCHANTING"] = "Disenchanting"
L["CRAFTING_ENCHANTING"] = "Enchanting"
L["CRAFTING_ENGINEERING"] = "Engineering"
L["CRAFTING_FIRST_AID"] = "First Aid"
L["CRAFTING_INSCRIPTION"] = "Inscription"
L["CRAFTING_JEWELCRAFTING"] = "Jewelcrafting"
L["CRAFTING_LEATHERWORKING"] = "Leatherworking"
L["CRAFTING_MILLING"] = "Milling"
L["CRAFTING_PROSPECTING"] = "Prospecting"
L["CRAFTING_SMELTING"] = "Smelting"
L["CRAFTING_TAILORING"] = "Tailoring"
L["GATHERING_TOTAL"] = "Gathering Activity"
L["GATHERING_ARCHAEOLOGY"] = "Archaeology"
L["GATHERING_ENGINEERING"] = "Engineering"
L["GATHERING_EXTRACT_GAS"] = "Extract Gas"
L["GATHERING_FISHING"] = "Fishing"
L["GATHERING_HERB_GATHERING"] = "Herb Gathering"
L["GATHERING_MINING"] = "Mining"
L["GATHERING_SKINNING"] = "Skinning"
	
-- Measures
L["AUTOMATED"] = "(Automated)"
	
-- Reports
L["OVERVIEW"] = "Overview"
L["MONEY_GAINED"] = "Gold Gained"
L["MONEY_SPENT"] = "Gold Spent"
L["ITEM_CONSUMED"] = "Items Consumed"
L["ITEM_PRODUCED"] = "Items Produced"
L["CURRENCY"] = "Currency"
L["QUESTING"] = "Questing"
L["LOOTING"] = "Looting"
L["MERCHANT"] = "Vendor"
L["AUCTION"] = "Auction House"
L["GUILD_BANK"] = "Guild Bank"
L["TRADING"] = "Trading"
L["CRAFTING"] = "Crafting"
L["GATHERING"] = "Gathering"
	
-- Measure
L["TALENT_WIPING"] = "Talent Wiping"
	
-- Periods
L["SESSION"] = "Session"
L["TODAY"] = "Today"
L["YESTERDAY"] = "Yesterday"
L["THIS_WEEK"] = "This Week"
L["THIS_MONTH"] = "This Month"
L["LAST_7_DAYS"] = "Last 7 Days"
L["LAST_30_DAYS"] = "Last 30 Days"
	
-- Economy frame
L["ECONOMY_FRAME_TITLE"] = "Economy"
L["ALL_CHARACTERS"] = "All Characters"
L["ALL_CHARACTERS_TOOLTIP"] = "If checked, data is shown for all characters on this account. If unchecked, data is shown for the currently logged in character."
L["NO_DETAIL_INFO"] = "No detail information available."
L["CONSUMED"] = "Consumed"
L["PRODUCED"] = "Produced"
end