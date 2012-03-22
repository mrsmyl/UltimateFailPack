

LilSparky's Workshop


version 0.80
nov.22.2008





LilSparky's Workshop is a tradeskill addon designed to plug into the World of Warcraft trade skill and crafting frames (also supports Slarti's "Advanced Trade Skill Window" mod as well as "Skillet").

Using data from the Auctioneer addon (and Enchantrix if available), LilSparky's Workshop will calculate how much a crafted item might be worth (its value) and how much it costs to craft or enchant an item (its cost). As an added convenience, the character level requirements for any crafted item are also displayed.


===Layout===

The data is layed out as follows:

Level.....Skill-Name........Value....Cost



--Level--

Level is pretty self explanatory. Enchant item level requirements are not represented here, just player levels for items.

Item levels are color coded based on item rarity.



--Value--

Value is determined by querying Auctioneer for a market price and vendor price, then querying Enchantrix (which also queries Auctioneer) for a disenchant value (if any). The results are compared and an item's "fate" is determined -- basically, which of the three prices is highest. The value has a single letter suffix to indicate the fate of the item: 'a' for auction, 'v' for vendor, 'd' for disenchanting.

Left clicking on the value column will cycle the displayed value (best price, auction price, vendor price, disenchant price) should you wish to see any particular value (for example, if you're just interested in disenchant values).

Right clicking on the value column will give you the option to view values as a percentage of cost.

Items worth more than their cost have the value highlighted.

Crafting recipes (ie, enchanting) often don't have values.

Items that are bind on pick-up are listed as BOP when looking at their auction value.


--Cost--

Cost is determined by iterating through the materials needed to create the item or enchant. Auction data is used to find market prices. Where auction data is unavailable, vendor selling prices are used (that is, how much it would cost to purchase that item from a vendor). The better your auctioneer database, the more accurate the cost.

Mousing over the cost for any skill will give you a breakdown of that cost in a tooltip.

If LibPeriodicTable-3.1 is loaded, it will be queried to determine if any of the reagents are available from vendors and if so, the vendor price will be favored over the auction price.

Reagents that are bind on pick-up are listed as BOP and don't contribute to the cost.


===Dependencies===

LilSparky's Workshop relies on an auction scanner to get auction prices and vendor price lists for the vendor pricing system.


--Auctioneer--

Auctioneer has support for multiple modules (whichever are loaded).  Right-click the cost or value price to select from a drop down of possible pricing modules.  "Market" is the default.  "Appraiser" will use whatever module you have selected with the Appaiser module.



--AuctionLite--

AuctionLite is fully supported.



--AuctionMaster--

AuctionMaster is fully supported.



--KC Items--

KC_Items/SellValues/AuctionSpy is currently supported as beta with mixed results.




===Optional Dependencies===

LilSparky's workshop is designed to take advantage of a number of other mods.



--Enchantrix--


To get disenchant values, Enchantrix must be loaded, but LilSparky's Workshop will run fine without it -- of course, only vendor and auction prices will be considered.



--Advanced Trade Skill Window--

LilSparky's Workshop will integrate seamlessly with Slarti's Advanced Trade Skill Window.



--Skillet--

LilSparky's Workshop is fully Skillet aware and has the added benefit of plugging into the Skillet sort method system to provide four additional sorting schemes:

    Item Level (highest items first)

    Item Value (currently displayed value -- ie, best, auction, vendor, or disenchant; most expensive first)

    Reagent Cost (cheapest first)

    Item Profit (in terms simple terms of (best item value) - (reagent cost); highest first)



===Bug Reports / Feature Requests===

http://www.wowace.com/forums/index.php?topic=9379.0



Enjoy and happy crafting.

LilSparky of Lothar




version history:
v0.1 - oct.09,2007
- initial release

v0.2 - oct.11,2007
- fixed skill value computation (no longer reports inflated values)
- removed dependency on advanced tradeskill window
- fixed bug where addon initialized prior to auctioneer loading
- now loads on demand

v0.3 -- oct.12,2007
- added skillet support
- additional bug fixes in auctioneer queries

v0.31 -- oct.12,2007
- added support for resizable skillet window

v0.32 -- oct.18,2007
- support for latest skillet features (sorting)

v0.33 -- oct.22,2007
- added value as percent toggle
- added KC_Items support (initial)

v0.34 -- oct.26,2007
- added support for "GetSellValue()" api as fallback for when Informant or SellValues is not loaded

v0.40 -- oct.29,2007
- bug fixes

v0.41 -- oct.31, 2007
- fixed informant bug for purchase price of stacked items (like vials)
- added price sanity check routine for skill costs

v0.42 -- nov.05, 2007
- added detailed info to value tooltip

v0.43 -- nov.17, 2007
- updated toc for 2.3

v0.44 -- dec.10, 2007
- fixed enchanting values losing parenting

v0.50 -- dec.20, 2007
- added tradeskillinfoui support

v0.51 -- jan.10, 2008
- added support for periodic table interface to determine reagent availability at vendors
- identifies BOP items when displaying auction item values and reagent purchase prices

v0.52 -- jan.19, 2008
- added tooltip info for known recipes (note that only information that has been cached will show up here)

v0.71 -- oct.23, 2008
- reworked for 3.0 api (skillet support semi-functional)

v0.72 -- nov.2, 2008
- support for skillet reworked, should support standard skillet as well as my updated branch

v0.80 -- nov.22, 2008
- reworked support for all known tradeskill ui's (blizzard, advanced tradeskill window, skillet)
- removed support for tradeskill info ui (project is apparently defunct)

v0.90 -- feb.1, 2009
- added support for AuctionLite and AuctionMaster (finally)
- added support for Multiple Auctioneer pricing Modules
