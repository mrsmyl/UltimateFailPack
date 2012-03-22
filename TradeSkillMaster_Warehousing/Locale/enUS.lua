-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Warehousing - AddOn by Geemoney
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Warehousing Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Warehousing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Warehousing", "enUS", true)
if not L then return end
L["Guild Bank Timeout"] = true
L["Displays realtime move data."] = true

--gui.lua new
L["Inventory Manager"] = true
L["New Group"] = true
L["Warehousing"] = true
L["Create New Group"] = true
L["How To"] = true
L["Delete Group"] = true
L["Set Increment"] = true
L["Bank UI"] = true
L["Group Behaviors"] = true
L["Crafting"] = true
L["Auctioning"] = true
L["Empty Bags/Restore Bags"] = true
L["   Warehousing will try to get the right number of items, if there are not enough in the bank to fill out order, it will grab all that there is."] = true
L["   Again warehousing will try to fill out the order, but if it is short, it will remember how much it is short by and adjust its counts. So then you can go to another bank or another character and warehousing will grab the difference. Once the order has been completely filled out, warehousing will reset the count back to the original total. You cannot move a Crafting Queue bags->bank, only bank->bags."] = true
L["Warehousing will only keep track of items that you have moved out of you bank and into your bags via the Inventory_Manager.  Finaly if you ever feel the need to reset the counts for a queue simply use the dropdown menu below."] = true
L["   Warehousing will move the difference between your post cap and the number of auctions you have from the source to the destination."] = true
L["   Simply hit empty bags, warehousing will remember what you had so that when you hit restore, it will grab all those items again. If you hit empty bags while your bags are empty it will overwrite the previous bag state, so you will not be able to use restore."] = true
L["To create a Warehousing Group"] = true
L["   1) Type a name in the textbox labeled \"Create New Group\", hit okay"] = true
L["   1.1) You can delete a group by typing in its name and hitting okay."] = true
L["   2) Select that group using the table on the left, you should then see a list of all the items currently in your bags with a quantity"] = true
L["   3) Right click to increase, left click to decrease by the current increment"] = true
L["To move a Group:"] = true
L["   1) Open up a bank (either the gbank or personal bank)"] = true
L["   2) You should see a window on your right with a list of groups"] = true
L["   3) Select a group and hit either"] = true
L["Move Group to Bank"] = true
L["or"] = true
L["Move Group to Bags"] = true
L["   You can toogle the Bank UI by typing the command "] = true
L["Guild Bank"] = true
L["   By default there is a four secound timeout when moving items from the guildbank.  This is nessary to "] = true
L["to ensure consistent results.  If you feel then need you can adjust this.  The timeout can be no less then"] = true
L["one secound and no greater then five.  Be warned I make no promises if you do decide to adjust this.  You have been warned."] = true
L["Toggles the bankui"] =true

L["Reset Crafting Queue"] = true

--bank.ui --maybe done??
L["TradeSkillMaster_Warehousing"] = true
L["Move Group To Bank"] = true
L["Move Group To Bags"] = true
L["Empty Bags"] = true
L["Restore Bags"] = true

--scrollTable.lua
L["Item"] = true
L["Quantity"] = true
L["Groups"] = true

L["Have"] = true
L["Need"] = true
--move.lua
L["Begin"] = true

--data.lua

--searchInventory.lua

--util.lua