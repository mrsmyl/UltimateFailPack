-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "itIT")
if not L then return end

-- L["Add this location to Cartographer_Waypoints"] = "Add this location to Cartographer_Waypoints"
-- L["Add this location to TomTom waypoints"] = "Add this location to TomTom waypoints"
-- L["Always show"] = "Always show"
-- L["Archaeology"] = "Archaeology"
-- L["Archaeology filter"] = "Archaeology filter"
-- L["Are you sure you want to delete all nodes from this database?"] = "Are you sure you want to delete all nodes from this database?"
-- L["Are you sure you want to delete all of the selected node from the selected zone?"] = "Are you sure you want to delete all of the selected node from the selected zone?"
-- L["Auto Import"] = "Auto Import"
-- L["Auto import complete for addon "] = "Auto import complete for addon "
-- L["Automatically import when ever you update your data module, your current import choice will be used."] = "Automatically import when ever you update your data module, your current import choice will be used."
-- L["Cataclysm"] = "Cataclysm"
-- L["Cleanup Complete."] = "Cleanup Complete."
-- L["Cleanup Database"] = "Cleanup Database"
-- L["Cleanup_Desc"] = "Over time, your database might become crowded. Cleaning up your database involves looking for nodes of the same profession type that are near each other and determining if they can be collapsed into a single node."
-- L["Cleanup radius"] = "Cleanup radius"
-- L["CLEANUP_RADIUS_DESC"] = "The radius in yards where duplicate nodes should be removed. The default is |cffffd20050|r yards for Extract Gas and |cffffd20015|r yards for everything else. These settings are also followed when adding nodes."
-- L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "Cleanup your database by removing duplicates. This takes a few moments, be patient."
-- L["Clear database selections"] = "Clear database selections"
-- L["Clear node selections"] = "Clear node selections"
-- L["Clear zone selections"] = "Clear zone selections"
-- L["Color of the tracking circle."] = "Color of the tracking circle."
-- L["Control various aspects of node icons on both the World Map and Minimap."] = "Control various aspects of node icons on both the World Map and Minimap."
-- L["Conversion_Desc"] = "Convert Existing GatherMate data to GatherMate2 format."
-- L["Convert Databses"] = "Convert Databses"
-- L["Database locking"] = "Database locking"
-- L["Database Locking"] = "Database Locking"
-- L["DATABASE_LOCKING_DESC"] = "The database locking feature allows you to freeze a database state. Once locked you will no longer be able to add, delete or modify the database. This includes cleanup and imports."
-- L["Database Maintenance"] = "Database Maintenance"
-- L["Databases to Import"] = "Databases to Import"
-- L["Databases you wish to import"] = "Databases you wish to import"
-- L["Delete"] = "Delete"
-- L["Delete Entire Database"] = "Delete Entire Database"
-- L["DELETE_ENTIRE_DESC"] = "This will ignore Database Locking and remove all nodes from all zones from the selected database."
-- L["Delete selected node from selected zone"] = "Delete selected node from selected zone"
-- L["DELETE_SPECIFIC_DESC"] = "Remove all of the selected node from the selected zone. You must disable Database Locking for this to work."
-- L["Delete Specific Nodes"] = "Delete Specific Nodes"
-- L["Display Settings"] = "Display Settings"
-- L["Engineering"] = "Engineering"
-- L["Expansion"] = "Expansion"
-- L["Expansion Data Only"] = "Expansion Data Only"
-- L["Failed to load GatherMateData due to "] = "Failed to load GatherMateData due to "
-- L["FAQ"] = "FAQ"
--[==[ L["FAQ_TEXT"] = [=[|cffffd200
I just installed GatherMate, but I see no nodes on my maps. What am I doing wrong?
|r
GatherMate does not come with any data by itself. When you gather herbs, mine ore, collect gas or fish, GatherMate will then add and update your map accordingly. Also, check your Display Settings.

|cffffd200
I am seeing nodes on my World Map but not on my Minimap! What am I doing wrong now?
|r
|cffffff78Minimap Button Bag|r (and possibly other similar addons) likes to eat all the buttons we put on the Minimap. Disable them.

|cffffd200
How or where can I get existing data?
|r
You can import existing data into GatherMate in these ways:

1. |cffffff78GatherMate_Data|r - This LoD addon contains a WowHead datamined copy of all the nodes and is updated weekly. There are auto-updating options

2. |cffffff78GatherMate_CartImport|r - This addon allows you to import your existing databases in |cffffff78Cartographer_<Profession>|r modules into GatherMate. For this to work, both your |cffffff78Cartographer_<Profession>|r modules and GatherMate_CartImport must be loaded and active.

Note that importing data into GatherMate is not an automatic process. You must actively go to the Import Data section and click on the "Import" button.

This differs from |cffffff78Cartographer_Data|r in that the user is given the choice in how and when you want your data to be modified, |cffffff78Cartographer_Data|r when loaded will simply overwrite your existing databases without warning and destroy all new nodes that you have found.

|cffffd200
Can you add support for showing the locations of things like mailboxes and flightmasters?
|r
The answer is no. However, another addon author could create an addon or module for this purpose, the core GatherMate addon will not do this.

|cffffd200
I've found a bug! Where do I report it?
|r
You can report bugs or give suggestions at |cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r

Alternatively, you can also find us on |cffffff78irc://irc.freenode.org/wowace|r

When reporting a bug, make sure you include the |cffffff78steps on how to reproduce the bug|r, supply any |cffffff78error messages|r with stack traces if possible, give the |cffffff78revision number|r of GatherMate the problem occured in and state whether you are using an |cffffff78English client or otherwise|r.

|cffffd200
Who wrote this cool addon?
|r
Kagaro, Xinhuan, Nevcairiel and Ammo]=] ]==]
-- L["Filter_Desc"] = "Select node types that you want displayed in the World and Minimap. Unselected node types will still be recorded in the database."
-- L["Filters"] = "Filters"
-- L["Fishes"] = "Fishes"
-- L["Fish filter"] = "Fish filter"
-- L["Fishing"] = "Fishing"
-- L["Frequently Asked Questions"] = "Frequently Asked Questions"
-- L["Gas Clouds"] = "Gas Clouds"
-- L["Gas filter"] = "Gas filter"
-- L["GatherMate2Data has been imported."] = "GatherMate2Data has been imported."
-- L["GatherMate Conversion"] = "GatherMate Conversion"
-- L["GatherMate data has been imported."] = "GatherMate data has been imported."
-- L["GatherMateData has been imported."] = "GatherMateData has been imported."
-- L["GatherMate Pin Options"] = "GatherMate Pin Options"
-- L["General"] = "General"
-- L["Herbalism"] = "Herbalism"
-- L["Herb Bushes"] = "Herb Bushes"
-- L["Herb filter"] = "Herb filter"
-- L["Icon Alpha"] = "Icon Alpha"
-- L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."
-- L["Icons"] = "Icons"
-- L["Icon Scale"] = "Icon Scale"
-- L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."
-- L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."] = "Icon scaling, this lets you enlarge or shrink your icons on the Minimap."
-- L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."] = "Icon scaling, this lets you enlarge or shrink your icons on the World Map."
-- L["Import Data"] = "Import Data"
-- L["Import GatherMate2Data"] = "Import GatherMate2Data"
-- L["Import GatherMateData"] = "Import GatherMateData"
-- L["Importing_Desc"] = "Importing allows GatherMate to get node data from other sources apart from what you find yourself in the game world. After importing data, you may need to perform a database cleanup."
-- L["Import Options"] = "Import Options"
-- L["Import Style"] = "Import Style"
-- L["Keybind to toggle Minimap Icons"] = "Keybind to toggle Minimap Icons"
-- L["Load GatherMate2Data and import the data to your database."] = "Load GatherMate2Data and import the data to your database."
-- L["Load GatherMateData and import the data to your database."] = "Load GatherMateData and import the data to your database."
-- L["Merge"] = "Merge"
-- L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"
-- L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"
-- L["Mine filter"] = "Mine filter"
-- L["Mineral Veins"] = "Mineral Veins"
-- L["Minimap Icon Scale"] = "Minimap Icon Scale"
-- L["Minimap Icon Tooltips"] = "Minimap Icon Tooltips"
-- L["Mining"] = "Mining"
-- L["Never show"] = "Never show"
-- L["Only import selected expansion data from WoWDB"] = "Only import selected expansion data from WoWDB"
-- L["Only import selected expansion data from WoWhead"] = "Only import selected expansion data from WoWhead"
-- L["Only while tracking"] = "Only while tracking"
-- L["Only with digsite"] = "Only with digsite"
-- L["Only with profession"] = "Only with profession"
-- L["Overwrite"] = "Overwrite"
-- L["Processing "] = "Processing "
-- L["Select All"] = "Select All"
-- L["Select all databases"] = "Select all databases"
-- L["Select all nodes"] = "Select all nodes"
-- L["Select all zones"] = "Select all zones"
-- L["Select Database"] = "Select Database"
-- L["Select Databases"] = "Select Databases"
-- L["Selected databases are shown on both the World Map and Minimap."] = "Selected databases are shown on both the World Map and Minimap."
-- L["Select Node"] = "Select Node"
-- L["Select None"] = "Select None"
-- L["Select the archaeology nodes you wish to display."] = "Select the archaeology nodes you wish to display."
-- L["Select the fish nodes you wish to display."] = "Select the fish nodes you wish to display."
-- L["Select the gas clouds you wish to display."] = "Select the gas clouds you wish to display."
-- L["Select the herb nodes you wish to display."] = "Select the herb nodes you wish to display."
-- L["Select the mining nodes you wish to display."] = "Select the mining nodes you wish to display."
-- L["Select the treasure you wish to display."] = "Select the treasure you wish to display."
-- L["Select Zone"] = "Select Zone"
-- L["Select Zones"] = "Select Zones"
-- L["Show Archaeology Nodes"] = "Show Archaeology Nodes"
-- L["Show Databases"] = "Show Databases"
-- L["Show Fishing Nodes"] = "Show Fishing Nodes"
-- L["Show Gas Clouds"] = "Show Gas Clouds"
-- L["Show Herbalism Nodes"] = "Show Herbalism Nodes"
-- L["Show Minimap Icons"] = "Show Minimap Icons"
-- L["Show Mining Nodes"] = "Show Mining Nodes"
-- L["Show Nodes on Minimap Border"] = "Show Nodes on Minimap Border"
-- L["Shows more Nodes that are currently out of range on the minimap's border."] = "Shows more Nodes that are currently out of range on the minimap's border."
-- L["Show Tracking Circle"] = "Show Tracking Circle"
-- L["Show Treasure Nodes"] = "Show Treasure Nodes"
-- L["Show World Map Icons"] = "Show World Map Icons"
-- L["The Burning Crusades"] = "The Burning Crusades"
-- L["The distance in yards to a node before it turns into a tracking circle"] = "The distance in yards to a node before it turns into a tracking circle"
-- L["The Frozen Sea"] = "The Frozen Sea"
-- L["The North Sea"] = "The North Sea"
-- L["Toggle showing archaeology nodes."] = "Toggle showing archaeology nodes."
-- L["Toggle showing fishing nodes."] = "Toggle showing fishing nodes."
-- L["Toggle showing gas clouds."] = "Toggle showing gas clouds."
-- L["Toggle showing herbalism nodes."] = "Toggle showing herbalism nodes."
-- L["Toggle showing Minimap icons."] = "Toggle showing Minimap icons."
-- L["Toggle showing Minimap icon tooltips."] = "Toggle showing Minimap icon tooltips."
-- L["Toggle showing mining nodes."] = "Toggle showing mining nodes."
-- L["Toggle showing the tracking circle."] = "Toggle showing the tracking circle."
-- L["Toggle showing treasure nodes."] = "Toggle showing treasure nodes."
-- L["Toggle showing World Map icons."] = "Toggle showing World Map icons."
-- L["Tracking Circle Color"] = "Tracking Circle Color"
-- L["Tracking Distance"] = "Tracking Distance"
-- L["Treasure"] = "Treasure"
-- L["Treasure filter"] = "Treasure filter"
-- L["World Map Icon Scale"] = "World Map Icon Scale"
-- L["Wrath of the Lich King"] = "Wrath of the Lich King"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "itIT")
if not NL then return end

-- NL["Abundant Bloodsail Wreckage"] = "Abundant Bloodsail Wreckage"
-- NL["Abundant Firefin Snapper School"] = "Abundant Firefin Snapper School"
-- NL["Abundant Oily Blackmouth School"] = "Abundant Oily Blackmouth School"
-- NL["Adamantite Bound Chest"] = "Adamantite Bound Chest"
-- NL["Adamantite Deposit"] = "Adamantite Deposit"
-- NL["Adder's Tongue"] = "Adder's Tongue"
-- NL["Albino Cavefish School"] = "Albino Cavefish School"
-- NL["Algaefin Rockfish School"] = "Algaefin Rockfish School"
-- NL["Ancient Lichen"] = "Ancient Lichen"
-- NL["Arcane Vortex"] = "Arcane Vortex"
-- NL["Arctic Cloud"] = "Arctic Cloud"
-- NL["Arthas' Tears"] = "Arthas' Tears"
-- NL["Azshara's Veil"] = "Azshara's Veil"
-- NL["Battered Chest"] = "Battered Chest"
-- NL["Battered Footlocker"] = "Battered Footlocker"
-- NL["Blackbelly Mudfish School"] = "Blackbelly Mudfish School"
-- NL["Black Lotus"] = "Black Lotus"
-- NL["Black Trillium Deposit"] = "Black Trillium Deposit"
-- NL["Blindweed"] = "Blindweed"
-- NL["Blood of Heroes"] = "Blood of Heroes"
-- NL["Bloodpetal Sprout"] = "Bloodpetal Sprout"
-- NL["Bloodsail Wreckage"] = "Bloodsail Wreckage"
-- NL["Bloodsail Wreckage Pool"] = "Bloodsail Wreckage Pool"
-- NL["Bloodthistle"] = "Bloodthistle"
-- NL["Bloodvine"] = "Bloodvine"
-- NL["Bluefish School"] = "Bluefish School"
-- NL["Borean Man O' War School"] = "Borean Man O' War School"
-- NL["Bound Adamantite Chest"] = "Bound Adamantite Chest"
-- NL["Bound Fel Iron Chest"] = "Bound Fel Iron Chest"
-- NL["Brackish Mixed School"] = "Brackish Mixed School"
-- NL["Briarthorn"] = "Briarthorn"
-- NL["Brightly Colored Egg"] = "Brightly Colored Egg"
-- NL["Bruiseweed"] = "Bruiseweed"
-- NL["Buccaneer's Strongbox"] = "Buccaneer's Strongbox"
-- NL["Burial Chest"] = "Burial Chest"
-- NL["Cinderbloom"] = "Cinderbloom"
-- NL["Cinder Cloud"] = "Cinder Cloud"
-- NL["Cobalt Deposit"] = "Cobalt Deposit"
NL["Copper Vein"] = "Vena di Rame" -- Needs review
-- NL["Dark Iron Deposit"] = "Dark Iron Deposit"
-- NL["Dark Iron Treasure Chest"] = "Dark Iron Treasure Chest"
-- NL["Dark Soil"] = "Dark Soil"
-- NL["Dart's Nest"] = "Dart's Nest"
-- NL["Deep Sea Monsterbelly School"] = "Deep Sea Monsterbelly School"
-- NL["Deepsea Sagefish School"] = "Deepsea Sagefish School"
-- NL["Dented Footlocker"] = "Dented Footlocker"
-- NL["Draenei Archaeology Find"] = "Draenei Archaeology Find"
-- NL["Dragonfin Angelfish School"] = "Dragonfin Angelfish School"
-- NL["Dragon's Teeth"] = "Dragon's Teeth"
NL["Dreamfoil"] = "Foglia Onirica" -- Needs review
-- NL["Dreaming Glory"] = "Dreaming Glory"
-- NL["Dwarf Archaeology Find"] = "Dwarf Archaeology Find"
-- NL["Earthroot"] = "Earthroot"
-- NL["Elementium Vein"] = "Elementium Vein"
-- NL["Emperor Salmon School"] = "Emperor Salmon School"
-- NL["Everfrost Chip"] = "Everfrost Chip"
-- NL["Fadeleaf"] = "Fadeleaf"
-- NL["Fangtooth Herring School"] = "Fangtooth Herring School"
-- NL["Fathom Eel Swarm"] = "Fathom Eel Swarm"
-- NL["Fel Iron Chest"] = "Fel Iron Chest"
-- NL["Fel Iron Deposit"] = "Fel Iron Deposit"
-- NL["Felmist"] = "Felmist"
-- NL["Felsteel Chest"] = "Felsteel Chest"
-- NL["Feltail School"] = "Feltail School"
-- NL["Felweed"] = "Felweed"
-- NL["Firebloom"] = "Firebloom"
-- NL["Firefin Snapper School"] = "Firefin Snapper School"
-- NL["Firethorn"] = "Firethorn"
-- NL["Flame Cap"] = "Flame Cap"
-- NL["Floating Debris"] = "Floating Debris"
-- NL["Floating Debris Pool"] = "Floating Debris Pool"
-- NL["Floating Shipwreck Debris"] = "Floating Shipwreck Debris"
-- NL["Floating Wreckage"] = "Floating Wreckage"
-- NL["Floating Wreckage Pool"] = "Floating Wreckage Pool"
-- NL["Fool's Cap"] = "Fool's Cap"
-- NL["Fossil Archaeology Find"] = "Fossil Archaeology Find"
-- NL["Frost Lotus"] = "Frost Lotus"
-- NL["Frozen Herb"] = "Frozen Herb"
-- NL["Ghost Iron Deposit"] = "Ghost Iron Deposit"
-- NL["Ghost Mushroom"] = "Ghost Mushroom"
-- NL["Giant Clam"] = "Giant Clam"
-- NL["Giant Mantis Shrimp Swarm"] = "Giant Mantis Shrimp Swarm"
-- NL["Glacial Salmon School"] = "Glacial Salmon School"
-- NL["Glassfin Minnow School"] = "Glassfin Minnow School"
-- NL["Glowcap"] = "Glowcap"
-- NL["Goldclover"] = "Goldclover"
-- NL["Golden Carp School"] = "Golden Carp School"
-- NL["Golden Lotus"] = "Golden Lotus"
NL["Golden Sansam"] = "Sansam Dorato" -- Needs review
-- NL["Goldthorn"] = "Goldthorn"
NL["Gold Vein"] = "Vena d'Oro" -- Needs review
-- NL["Grave Moss"] = "Grave Moss"
-- NL["Greater Sagefish School"] = "Greater Sagefish School"
-- NL["Green Tea Leaf"] = "Green Tea Leaf"
NL["Gromsblood"] = "Sangue di Grom" -- Needs review
-- NL["Heartblossom"] = "Heartblossom"
-- NL["Heavy Fel Iron Chest"] = "Heavy Fel Iron Chest"
-- NL["Highland Guppy School"] = "Highland Guppy School"
-- NL["Highland Mixed School"] = "Highland Mixed School"
-- NL["Huge Obsidian Slab"] = "Huge Obsidian Slab"
-- NL["Icecap"] = "Icecap"
-- NL["Icethorn"] = "Icethorn"
-- NL["Imperial Manta Ray School"] = "Imperial Manta Ray School"
-- NL["Incendicite Mineral Vein"] = "Incendicite Mineral Vein"
-- NL["Indurium Mineral Vein"] = "Indurium Mineral Vein"
NL["Iron Deposit"] = "Deposito di Ferro" -- Needs review
-- NL["Jade Lungfish School"] = "Jade Lungfish School"
-- NL["Jewel Danio School"] = "Jewel Danio School"
-- NL["Khadgar's Whisker"] = "Khadgar's Whisker"
-- NL["Khorium Vein"] = "Khorium Vein"
-- NL["Kingsblood"] = "Kingsblood"
-- NL["Krasarang Paddlefish School"] = "Krasarang Paddlefish School"
-- NL["Kyparite Deposit"] = "Kyparite Deposit"
-- NL["Large Battered Chest"] = "Large Battered Chest"
-- NL["Large Darkwood Chest"] = "Large Darkwood Chest"
-- NL["Large Iron Bound Chest"] = "Large Iron Bound Chest"
-- NL["Large Mithril Bound Chest"] = "Large Mithril Bound Chest"
-- NL["Large Obsidian Chunk"] = "Large Obsidian Chunk"
-- NL["Large Solid Chest"] = "Large Solid Chest"
-- NL["Lesser Bloodstone Deposit"] = "Lesser Bloodstone Deposit"
-- NL["Lesser Firefin Snapper School"] = "Lesser Firefin Snapper School"
-- NL["Lesser Floating Debris"] = "Lesser Floating Debris"
-- NL["Lesser Oily Blackmouth School"] = "Lesser Oily Blackmouth School"
-- NL["Lesser Sagefish School"] = "Lesser Sagefish School"
-- NL["Lichbloom"] = "Lichbloom"
-- NL["Liferoot"] = "Liferoot"
-- NL["Mageroyal"] = "Mageroyal"
-- NL["Mana Thistle"] = "Mana Thistle"
-- NL["Maplewood Treasure Chest"] = "Maplewood Treasure Chest"
NL["Mithril Deposit"] = "Deposito di Mithril" -- Needs review
-- NL["Mogu Archaeology Find"] = "Mogu Archaeology Find"
-- NL["Moonglow Cuttlefish School"] = "Moonglow Cuttlefish School"
-- NL["Mossy Footlocker"] = "Mossy Footlocker"
-- NL["Mountain Silversage"] = "Mountain Silversage"
-- NL["Mountain Trout School"] = "Mountain Trout School"
-- NL["Muddy Churning Water"] = "Muddy Churning Water"
-- NL["Mudfish School"] = "Mudfish School"
-- NL["Musselback Sculpin School"] = "Musselback Sculpin School"
-- NL["Mysterious Camel Figurine"] = "Mysterious Camel Figurine"
-- NL["Nerubian Archaeology Find"] = "Nerubian Archaeology Find"
-- NL["Netherbloom"] = "Netherbloom"
-- NL["Nethercite Deposit"] = "Nethercite Deposit"
-- NL["Netherdust Bush"] = "Netherdust Bush"
-- NL["Netherwing Egg"] = "Netherwing Egg"
-- NL["Nettlefish School"] = "Nettlefish School"
-- NL["Night Elf Archaeology Find"] = "Night Elf Archaeology Find"
-- NL["Nightmare Vine"] = "Nightmare Vine"
-- NL["Obsidian Chunk"] = "Obsidian Chunk"
NL["Obsidium Deposit"] = "Deposito d'Obsidio" -- Needs review
-- NL["Oil Spill"] = "Oil Spill"
-- NL["Oily Blackmouth School"] = "Oily Blackmouth School"
-- NL["Ooze Covered Gold Vein"] = "Ooze Covered Gold Vein"
-- NL["Ooze Covered Mithril Deposit"] = "Ooze Covered Mithril Deposit"
-- NL["Ooze Covered Rich Thorium Vein"] = "Ooze Covered Rich Thorium Vein"
-- NL["Ooze Covered Silver Vein"] = "Ooze Covered Silver Vein"
-- NL["Ooze Covered Thorium Vein"] = "Ooze Covered Thorium Vein"
-- NL["Ooze Covered Truesilver Deposit"] = "Ooze Covered Truesilver Deposit"
-- NL["Orc Archaeology Find"] = "Orc Archaeology Find"
-- NL["Other Archaeology Find"] = "Other Archaeology Find"
-- NL["Pandaren Archaeology Find"] = "Pandaren Archaeology Find"
-- NL["Patch of Elemental Water"] = "Patch of Elemental Water"
-- NL["Peacebloom"] = "Peacebloom"
-- NL["Plaguebloom"] = "Plaguebloom"
-- NL["Pool of Fire"] = "Pool of Fire"
-- NL["Practice Lockbox"] = "Practice Lockbox"
-- NL["Primitive Chest"] = "Primitive Chest"
-- NL["Pure Saronite Deposit"] = "Pure Saronite Deposit"
-- NL["Pure Water"] = "Pure Water"
-- NL["Purple Lotus"] = "Purple Lotus"
-- NL["Pyrite Deposit"] = "Pyrite Deposit"
-- NL["Ragveil"] = "Ragveil"
-- NL["Rain Poppy"] = "Rain Poppy"
-- NL["Ravasaur Matriarch's Nest"] = "Ravasaur Matriarch's Nest"
-- NL["Razormaw Matriarch's Nest"] = "Razormaw Matriarch's Nest"
-- NL["Redbelly Mandarin School"] = "Redbelly Mandarin School"
-- NL["Reef Octopus Swarm"] = "Reef Octopus Swarm"
-- NL["Rich Adamantite Deposit"] = "Rich Adamantite Deposit"
-- NL["Rich Cobalt Deposit"] = "Rich Cobalt Deposit"
-- NL["Rich Elementium Vein"] = "Rich Elementium Vein"
-- NL["Rich Ghost Iron Deposit"] = "Rich Ghost Iron Deposit"
-- NL["Rich Kyparite Deposit"] = "Rich Kyparite Deposit"
-- NL["Rich Obsidium Deposit"] = "Rich Obsidium Deposit"
-- NL["Rich Pyrite Deposit"] = "Rich Pyrite Deposit"
NL["Rich Saronite Deposit"] = "Deposito Ricco di Saronite" -- Needs review
NL["Rich Thorium Vein"] = "Vena Ricca di Torio" -- Needs review
-- NL["Rich Trillium Vein"] = "Rich Trillium Vein"
-- NL["Runestone Treasure Chest"] = "Runestone Treasure Chest"
-- NL["Sagefish School"] = "Sagefish School"
NL["Saronite Deposit"] = "Deposito di Saronite" -- Needs review
-- NL["Scarlet Footlocker"] = "Scarlet Footlocker"
-- NL["School of Darter"] = "School of Darter"
-- NL["School of Deviate Fish"] = "School of Deviate Fish"
-- NL["School of Tastyfish"] = "School of Tastyfish"
-- NL["Schooner Wreckage"] = "Schooner Wreckage"
-- NL["Schooner Wreckage Pool"] = "Schooner Wreckage Pool"
-- NL["Sha-Touched Herb"] = "Sha-Touched Herb"
-- NL["Shipwreck Debris"] = "Shipwreck Debris"
-- NL["Silken Treasure Chest"] = "Silken Treasure Chest"
-- NL["Silkweed"] = "Silkweed"
-- NL["Silverbound Treasure Chest"] = "Silverbound Treasure Chest"
-- NL["Silverleaf"] = "Silverleaf"
NL["Silver Vein"] = "Vena d'Argento" -- Needs review
-- NL["Small Obsidian Chunk"] = "Small Obsidian Chunk"
NL["Small Thorium Vein"] = "Vena Piccola di Torio" -- Needs review
-- NL["Snow Lily"] = "Snow Lily"
-- NL["Solid Chest"] = "Solid Chest"
-- NL["Solid Fel Iron Chest"] = "Solid Fel Iron Chest"
-- NL["Sorrowmoss"] = "Sorrowmoss"
-- NL["Sparse Firefin Snapper School"] = "Sparse Firefin Snapper School"
-- NL["Sparse Oily Blackmouth School"] = "Sparse Oily Blackmouth School"
-- NL["Sparse Schooner Wreckage"] = "Sparse Schooner Wreckage"
-- NL["Spinefish School"] = "Spinefish School"
-- NL["Sporefish School"] = "Sporefish School"
-- NL["Steam Cloud"] = "Steam Cloud"
-- NL["Steam Pump Flotsam"] = "Steam Pump Flotsam"
-- NL["Stonescale Eel Swarm"] = "Stonescale Eel Swarm"
-- NL["Stormvine"] = "Stormvine"
-- NL["Strange Pool"] = "Strange Pool"
-- NL["Stranglekelp"] = "Stranglekelp"
-- NL["Sturdy Treasure Chest"] = "Sturdy Treasure Chest"
NL["Sungrass"] = "Erbasole" -- Needs review
-- NL["Swamp Gas"] = "Swamp Gas"
-- NL["Takk's Nest"] = "Takk's Nest"
-- NL["Talandra's Rose"] = "Talandra's Rose"
-- NL["Tattered Chest"] = "Tattered Chest"
-- NL["Teeming Firefin Snapper School"] = "Teeming Firefin Snapper School"
-- NL["Teeming Floating Wreckage"] = "Teeming Floating Wreckage"
-- NL["Teeming Oily Blackmouth School"] = "Teeming Oily Blackmouth School"
-- NL["Terocone"] = "Terocone"
-- NL["Tiger Gourami School"] = "Tiger Gourami School"
-- NL["Tiger Lily"] = "Tiger Lily"
NL["Tin Vein"] = "Vena di Stagno" -- Needs review
NL["Titanium Vein"] = "Vena di Titanio" -- Needs review
-- NL["Tol'vir Archaeology Find"] = "Tol'vir Archaeology Find"
-- NL["Trillium Vein"] = "Trillium Vein"
-- NL["Troll Archaeology Find"] = "Troll Archaeology Find"
NL["Truesilver Deposit"] = "Deposito di Verargento" -- Needs review
-- NL["Twilight Jasmine"] = "Twilight Jasmine"
-- NL["Un'Goro Dirt Pile"] = "Un'Goro Dirt Pile"
-- NL["Vrykul Archaeology Find"] = "Vrykul Archaeology Find"
-- NL["Waterlogged Footlocker"] = "Waterlogged Footlocker"
-- NL["Waterlogged Wreckage"] = "Waterlogged Wreckage"
-- NL["Waterlogged Wreckage Pool"] = "Waterlogged Wreckage Pool"
-- NL["Whiptail"] = "Whiptail"
-- NL["White Trillium Deposit"] = "White Trillium Deposit"
-- NL["Wicker Chest"] = "Wicker Chest"
-- NL["Wild Steelbloom"] = "Wild Steelbloom"
-- NL["Windy Cloud"] = "Windy Cloud"
-- NL["Wintersbite"] = "Wintersbite"

