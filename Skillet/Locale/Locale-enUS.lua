--[[

Skillet: A tradeskill window replacement.
Copyright (c) 2007 Robert Clark <nogudnik@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]--

local L = LibStub("AceLocale-3.0"):NewLocale("Skillet", "enUS")
if not L then return end

L[" days"] = true
L["ABOUTDESC"] = "Prints info about Skillet"
L["APPEARANCEDESC"] = "Options that control how Skillet is displayed"
L["About"] = true
L["Appearance"] = true
L["Blizzard"] = true
L["Buy Reagents"] = true
L["By Difficulty"] = true
L["By Item Level"] = true
L["By Level"] = true
L["By Name"] = true
L["By Quality"] = true
L["By Skill Level"] = true
L["CONFIGDESC"] = "Opens a config window for Skillet"
L["Clear"] = true
L["Collapse all groups"] = true
L["Config"] = true
L["Could not find bag space for"] = true
L["Crafted By"] = "Crafted by"
L["Create"] = true
L["Create All"] = true
L["DISPLAYREQUIREDLEVELDESC"] = "If the item to be crafted requires a minimum level to use, that level will be displayed along with the recipe"
L["DISPLAYREQUIREDLEVELNAME"] = "Display required level"
L["DISPLAYSGOPPINGLISTATAUCTIONDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSGOPPINGLISTATAUCTIONNAME"] = "Display shopping list at auctions"
L["DISPLAYSHOPPINGLISTATBANKDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATBANKNAME"] = "Display shopping list at banks"
L["DISPLAYSHOPPINGLISTATGUILDBANKDESC"] = "Display a shopping list of the items that are needed to craft queued recipes but are not in your bags"
L["DISPLAYSHOPPINGLISTATGUILDBANKNAME"] = "Display shopping list at guild banks"
L["Delete"] = true
L["ENHANCHEDRECIPEDISPLAYDESC"] = "When enabled, recipe names will have one or more '+' characters appeneded to their name to inidcate the difficulty of the recipe."
L["ENHANCHEDRECIPEDISPLAYNAME"] = "Show recipe difficulty as text"
L["Enabled"] = true
L["Enchant"] = true
L["Expand all groups"] = true
L["FEATURESDESC"] = "Optional behavior that can be enabled and disabled"
L["Features"] = true
L["Filter"] = true
L["Glyph "] = true
L["Gold earned"] = true
L["Grouping"] = true
L["Hide trivial"] = true
L["Hide uncraftable"] = true
L["INVENTORYDESC"] = "Inventory Information"
L["Include alts"] = true
L["Inventory"] = true
L["LINKCRAFTABLEREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, clicking the reagent will take you to its recipe."
L["LINKCRAFTABLEREAGENTSNAME"] = "Make reagents clickable"
L["Library"] = true
L["Load"] = true
L["Move Down"] = true
L["Move Up"] = true
L["Move to Bottom"] = true
L["Move to Top"] = true
L["No Data"] = true
L["No such queue saved"] = true
L["None"] = true
L["Notes"] = true
L["Number of items to queue/create"] = true
L["Options"] = true
L["Pause"] = true
L["Process"] = true
L["Purchased"] = true
L["QUEUECRAFTABLEREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, and don't have enough, then that reagent will be added to the queue"
L["QUEUECRAFTABLEREAGENTSNAME"] = "Queue craftable reagents"
L["QUEUEGLYPHREAGENTSDESC"] = "If you can create a reagent needed for the current recipe, and don't have enough, then that reagent will be added to the queue. This option is separate for Glyphs only."
L["QUEUEGLYPHREAGENTSNAME"] = "Queue reagents for Glyphs"
L["Queue"] = true
L["Queue All"] = true
L["Queue is empty"] = true
L["Queue is not empty. Overwrite?"] = true
L["Queue with this name already exsists. Overwrite?"] = true
L["Queues"] = true
L["Really delete this queue?"] = true
L["Rescan"] = true
L["Retrieve"] = true
L["SCALEDESC"] = "Scale of the tradeskill window (default 1.0)"
L["SHOPPINGLISTDESC"] = "Display the shopping list"
L["SHOWBANKALTCOUNTSDESC"] = "When calculating and displaying craftable item counts, include items from your bank and from your other characters"
L["SHOWBANKALTCOUNTSNAME"] = "Include bank and alt character contents"
L["SHOWCRAFTCOUNTSDESC"] = "Show the number of times you can craft a recipe, not the total number of items producable"
L["SHOWCRAFTCOUNTSNAME"] = "Show craftable counts"
L["SHOWCRAFTERSTOOLTIPDESC"] = "Display the alternate characters that can craft an item in the item's tooltip"
L["SHOWCRAFTERSTOOLTIPNAME"] = "Show crafters in tooltips"
L["SHOWDETAILEDRECIPETOOLTIPDESC"] = "Displays a tooltip when hovering over recipes in the left hand panel"
L["SHOWDETAILEDRECIPETOOLTIPNAME"] = "Display tooltip for recipes"
L["SHOWFULLTOOLTIPDESC"] = "Display all informations about an item to be crafted. If you turn it off you will only see compressed tooltip (hold Ctrl to show full tooltip)"
L["SHOWFULLTOOLTIPNAME"] = "Use standard tooltips"
L["SHOWITEMNOTESTOOLTIPDESC"] = "Adds notes you provide for an item to the tool tip for that item"
L["SHOWITEMNOTESTOOLTIPNAME"] = "Add user specified notes to tooltip"
L["SHOWITEMTOOLTIPDESC"] = "Display craftable item tooltip, instead of a recipe tooltip."
L["SHOWITEMTOOLTIPNAME"] = "Display item tooltip when possible"
L["SORTASC"] = "Sort the recipe list from highest (top) to lowest (bottom)"
L["SORTDESC"] = "Sort the recipe list from lowest (top) to highest (bottom)"
L["STANDBYDESC"] = "Toggle standby mode on/off"
L["STANDBYNAME"] = "standby"
L["SUPPORTEDADDONSDESC"] = "Supported add ons that can or are being used to track inventory"
L["Save"] = true
L["Scale"] = true
L["Scan completed"] = true
L["Scanning tradeskill"] = true
L["Select skill difficulty threshold"] = true
L["Selected Addon"] = true
L["Sells for "] = true
L["Shopping List"] = true
L["Skillet Trade Skills"] = true
L["Skipping"] = true
L["Sold amount"] = true
L["Sorting"] = true
L["Source:"] = true
L["Start"] = true
L["Supported Addons"] = true
L["TRANSPARAENCYDESC"] = "Transparency of the main trade skill window"
L["This merchant sells reagents you need!"] = true
L["Total Cost:"] = true
L["Total spent"] = true
L["Trained"] = true
L["Transparency"] = true
L["Unknown"] = true
L["VENDORAUTOBUYDESC"] = "If you have queued recipes and talk to a vendor that sells something needed for those reicpes, it will be automatically purchased."
L["VENDORAUTOBUYNAME"] = "Automatically buy reagents"
L["VENDORBUYBUTTONDESC"] = "Display a button when talking to vendors that will allow you to be the needed reagents for all queued recipes."
L["VENDORBUYBUTTONNAME"] = "Show reagent purchase button at vendors"
L["View Crafters"] = true
L["alts"] = true
L["bank"] = true
L["buyable"] = true
L["can be created from reagents in your inventory"] = true
L["can be created from reagents in your inventory and bank"] = true
L["can be created from reagents on all characters"] = true
L["click here to add a note"] = true
L["craftable"] = true
L["have"] = true
L["is now disabled"] = true
L["is now enabled"] = true
L["need"] = true
L["not yet cached"] = true
L["reagents in inventory"] = true

