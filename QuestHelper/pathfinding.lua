
QuestHelper_File["pathfinding.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["pathfinding.lua"] = GetTime()

-- This section for whenever from-player's-location-to pathing can be implimented.

local static_alliance_landings = 
    {
        {12, 0.476, 0.598, "Exodar via portal"}, -- Exodar
        {21, 0.435, 0.787, "Darnassus via portal"}, -- Darnassus
        -- Need Stormwind Port In coordinates
        -- Need Ironforge Port In coordinates
        -- Need Theramore Port In coordinates
    }
    

local static_horde_landings =
    {
        {1, 0.483, 0.645, "Orgrimmar via portal"}, -- Orgrimmar
        {23, 0.222, 0.169, "Thunder Bluff via portal"}, -- Thunder Bluff
        {45, 0.845, 0.163, "Undercity via portal"}, -- Undercity
        {52, 0.583, 0.192, "Silvermoon City via portal"}, -- Silvermoon City
        {46, 0.498, 0.558, "Stonard via portal"}, -- Stonard
    }
    

local static_shared_landings =
    {
        -- Need Shattrath Port In cooordinates
        -- Need Dalaran Port In coordinates
        -- Need Tol Barad Port In coordinates
    }

-- Unchecked
local SHATTRATH_CITY_PORTAL_IN = {60,0.530,0.492, "Shattrath City via portal"}
local DALARAN_PORTAL_IN = {67,0.500,0.394, "Dalaran via portal"}

QuestHelper:Assert(UnitClass("player"), "Pathfinding Druid Check - too soon")
QuestHelper:Assert(UnitLevel("player"), "Pathfinding Druid Check - too soon")
if UnitClass("player") == "Druid" and UnitLevel("player") > 14 then
    local static_druid_landings = {20,0.563,0.324, "Moonglade via spell"} -- Moonglade landing
end

-- end whimsey


local BLASTED_LANDS_PORTAL_IN = {33,0.539,0.461, "Blasted Lands via portal"}

local static_horde_routes = 
  {
    -- Portals
        {{1,0.471,0.618}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Orgrimmar --> Dark Portal
        {{45,0.853,0.171}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Undercity --> Dark Portal
        {{23,0.232,0.135}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Thunder Bluff --> Dark Portal
        {{52,0.584,0.210}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Silvermoon --> Dark Portal

        {{56, 0.886, 0.477}, {1, 0.483, 0.645}, 60, true, level_limit = 58},  -- Hellfire Peninsula --> Orgrimmar
        
        -- Orgrimmar --> Tol Barad
        -- Orgrimmar --> Maelstrom
        

    -- Zepplins
        {{1, 0.526, 0.529}, {168, 0.372, 0.525}, 210}, -- Orgrimmar <--> Grom'gol Base Camp
        {{1, 0.449, 0.619}, {65, 0.414, 0.536}, 210, false, level_limit = 68}, -- Orgrimmar <--> Warsong Hold
        {{1, 0.506, 0.561}, {43, 0.607, 0.588}, 210}, -- Orgrimmar <--> Tirisfal Glades
        {{168, 0.374, 0.509}, {43, 0.619, 0.591}, 210}, -- Grom'gol Base Camp <--> Tirisfal Glades




    -- Partially checked
        {{1, 0.428, 0.653}, {23, 0.148, 0.258}, 210}, -- Orgrimmar <--> Thunder Bluff
        {{43, 0.590, 0.590}, {70, 0.777, 0.283}, 210, false, level_limit = 68}, -- Tirisfal Glades <--> Vengeance Landing

    -- Unchecked
        {{45, 0.549, 0.11}, {52, 0.495, 0.148}, 60}, -- Undercity <--> Silvermoon City
  }


local static_alliance_routes = 
  {
    -- Portals
        {{21,0.440,0.782}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Darnassus --> Dark Portal
        {{12,0.482,0.630}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Exodar --> Dark Portal
        {{25,0.273,0.070}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Ironforge --> Dark Portal
        {{36,0.490,0.874}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Stormwind --> Dark Portal
    
--        {{56, 0.886, 0.528}, STORMWIND_CITY_PORTAL_IN, 60, true, level_limit = 58},  -- Hellfire Peninsula --> Stormwind
        {{21, 0.442, 0.788}, {12, 0.476, 0.598}, 60, true}, -- Darnassus --> Exodar
        {{12, 0.476, 0.619}, {21, 0.435, 0.787}, 60, true}, -- Exodar --> Darnassus

        -- Stormwind --> Tol Barad?
        -- Stormwind --> Maelstrom?


    -- Ships
        {{36, 0.180, 0.285}, {65, 0.597, 0.694}, 210, false, level_limit = 68}, -- Stormwind <--> Valiance Keep


    -- Deeprun Tram (Wonder if this needs to be handled differently because of it's nature but this will suffice for now)
        {{36, 0.696, 0.311}, {25, 0.770, 0.513}, 180}, -- Stormwind <--> Ironforge




    -- Partially checked


    -- Unchecked (Do these still exist?)
        {{10, 0.718, 0.565}, {51, 0.047, 0.636}, 210}, -- Theramore Isle <--> Menethil Harbor
        {{51, 0.047, 0.571}, {70, 0.612, 0.626}, 210}, -- Menethil <--> Daggercap Bay


   -- Nate's Cataclysm content
   {{207, 0.54, 0.60}, {205, 0.30, 0.72}, 10}, -- Gilneas Zone <--> Greymane Court, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{207, 0.55, 0.42}, {205, 0.28, 0.21}, 5}, -- Gilneas Zone <--> Cathedral Square, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{207, 0.66, 0.42}, {205, 0.67, 0.20}, 5}, -- Gilneas Zone <--> Merchant Square, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{207, 0.68, 0.62}, {205, 0.69, 0.82}, 10}, -- Gilneas Zone <--> Military District, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{207, 0.42, 0.36}, {24, 0.52, 0.89}, 86400}, -- Gilneas Zone <--> Teldrassil. Exists solely to fix some pathing crashes. 24-hour boat ride :D (This will be deleted later, when we can create the "official" path.)

  }

local static_shared_routes = 
  {
    -- Portals
        {{67, 0.268, 0.447}, {67, 0.240, 0.394}, 60}, -- Dalaran (Violet Citadel) <--> Dalaran (Purple Parlor)
        {{67, 0.559, 0.468}, {66, 0.158, 0.428}, 60}, -- Dalaran <--> Violet Stand

        {{24, 0.551, 0.885}, {21, 0.369, 0.584}, 5}, -- Rut'Theran Village <--> Darnassus

        {{60, 0.486, 0.420}, {64, 0.482, 0.345}, 60, true}, -- Shattrath --> Isle of Quel'Danas


    -- Ships (To keep QH from self-destructing)
        {{3, 0.203, 0.540}, {24, 0.522, 0.895}, 210}, -- Azuremyst Isle <--> Teldrassil
        {{36, 0.223, 0.560}, {24, 0.550, 0.938}, 210}, -- Stormwind <--> Teldrassil




    -- Partially checked
        {{11, 0.638, 0.387}, {174, 0.390, 0.670}, 210}, -- Ratchet <--> Booty Bay
        {{67, 0.255, 0.514}, {8, 0.659, 0.498}, 5, true}, -- Dalaran --> Caverns of Time


    -- Unchecked
   {{40, 0.318, 0.503}, {32, 0.347, 0.84}, 130}, -- Burning Steppes <--> Searing Gorge
   {{70, 0.235, 0.578}, {68, 0.496, 0.784}, 210}, -- Kamagua <--> Moa'ki
   {{65, 0.789, 0.536}, {68, 0.480, 0.787}, 210}, -- Unu'pe <--> Moa'ki
   -- Route to new zone. Not valid, exists only to keep routing from exploding if you don't have the flight routes there.
   {{41, 0.5, 0.5}, {64, 0.484, 0.251}, 7200}, -- Eversong Woods <--> Sunwell
   {{34, 0.817, 0.461}, {78, 0.492, 0.312}, 86400}, -- EPL Ebon Hold <--> Scarlet Enclave Ebon Hold. Exists solely to fix some pathing crashes. 24-hour boat ride :D
   


   -- Nate's Cataclysm content
   {{178, 0.83, 0.34}, {167, 0.45, 0.23}, 210, true}, -- Vash'jir --> Vash'jir Kelp Forest (One time, One way)
   {{167, 0.69, 0.60}, {178, 0.80, 0.30}, 5}, -- Vash'jir Kelp Forest <--> Vash'jir
   {{178, 0.84, 0.23}, {62, 0.37, 0.58}, 5}, -- Vash'jir <--> The Great Sea (EK Continent, zone 0)
   {{62, 0.39, 0.60}, {28, 0.00, 0.20}, 5}, -- The Great Sea (EK Continent, zone 0) <--> Dun Morogh
   {{167, 0.40, 0.64}, {171, 0.56, 0.14}, 5}, -- VKF <--> SE
   {{178, 0.50, 0.28}, {165, 0.72, 0.04}, 5}, -- Vash <--> Vash'jir Depths
   {{198, 0.85, 0.41}, {19, 0.58, 0.91}, 5}, -- Hyjal <--> Winterspring
   {{185, 0.85, 0.41}, {19, 0.58, 0.91}, 5}, -- Hyjal <--> Winterspring
   {{169, 0.5, 0.5}, {170, 0.5, 0.5}, 5}, -- Ruins of Gilneas <--> Ruins of Gilneas City (Meta info, map doesn't change properly as of 2010-12-11-0156UET)
   {{179, 0.5, 0.5}, {180, 0.5, 0.5}, 86400}, -- DeepHolm <--> Kezan (Meta info for when major error is fixed.)
   {{181, 0.24, 0.77}, {180, 0.22, 0.17}, 90}, -- The Lost Isles <--> Kezan (Meta info for when major error is fixed.)
   {{208, 0.24, 0.77}, {180, 0.22, 0.17}, 90}, -- The Lost Isles <--> Kezan (Meta info for when major error is fixed.)
   {{209, 0.24, 0.77}, {180, 0.22, 0.17}, 90}, -- The Lost Isles <--> Kezan (Meta info for when major error is fixed.)
   {{181, 0.5, 0.5}, {182, 0.5, 0.5}, 86400}, -- The Lost Isles <--> The Maelstrom (Meta info for when major error is fixed.)
   {{183, 0.5, 0.5}, {182, 0.5, 0.5}, 86400}, -- The Maelstrom Continent <--> The Maelstrom (Meta info for when major error is fixed.)
   {{183, 0.5, 0.5}, {1, 0.5, 0.5}, 86400}, -- The Maelstrom Continent <--> Orgrimmar (Meta info for when major error is fixed.)

   {{164, 0.84, 0.41}, {8, 0.37, 0.82}, 5}, -- Uldum <--> Tanaris
   {{164, 0.70, 0.22}, {8, 0.25, 0.66}, 5}, -- Uldum <--> Tanaris
   {{210, 0.84, 0.41}, {8, 0.37, 0.82}, 5}, -- Uldum <--> Tanaris
   {{210, 0.70, 0.22}, {8, 0.25, 0.66}, 5}, -- Uldum <--> Tanaris

   {{35, 0.45, 0.85}, {169, 0.60, 0.09}, 5}, -- Silverpine <--> Ruins of Gilneas

   -- Wrath instance entrances
   {{80, 0.693, 0.730}, {70, 0.573, 0.467}, 5}, -- UK
   {{86, 0.362, 0.880}, {65, 0.275, 0.260}, 5}, -- Nexus
   {{92, 0.094, 0.933}, {68, 0.260, 0.508}, 5}, -- AN
   {{94, 0.900, 0.791}, {68, 0.285, 0.517}, 5}, -- AK
   {{96, 0.294, 0.810}, {75, 0.286, 0.869}, 5}, -- Draktharon
   {{100, 0.469, 0.780}, {67, 0.679, 0.694}, 5}, -- VH
   {{102, 0.590, 0.309}, {75, 0.764, 0.214}, 5}, -- Gundrak NW
   {{102, 0.344, 0.312}, {75, 0.810, 0.286}, 5}, -- Gundrak SE
   {{104, 0.344, 0.362}, {73, 0.397, 0.269}, 5}, -- HoS
   {{106, 0.020, 0.538}, {73, 0.453, 0.216}, 5}, -- HoL
   {{110, 0.613, 0.476}, {65, 0.275, 0.266}, 5}, -- Oculus
   {{120, 0.875, 0.712}, {8, 0.614, 0.626}, 5}, -- CoT
   {{124, 0.445, 0.161}, {70, 0.573, 0.467}, 5}, -- UP
   {{126, 0.500, 0.500}, {74, 0.500, 0.115}, 5}, -- VoA, zone-in link is incorrect
   {{128, 0.500, 0.500}, {68, 0.873, 0.510}, 5}, -- Naxx, zone-in link is incorrect (but might be close)
   {{140, 0.635, 0.501}, {68, 0.600, 0.566}, 5}, -- Sarth
   {{142, 0.500, 0.500}, {65, 0.275, 0.267}, 5}, -- Malygos, zone-in link is incorrect (not that it matters with malygos)
   {{144, 0.500, 0.500}, {73, 0.416, 0.179}, 5}, -- Ulduar, zone-in link is incorrect
   {{155, 0.426, 0.203}, {71, 0.548, 0.899}, 5}, -- Forge of Souls
   {{157, 0.410, 0.801}, {71, 0.547, 0.916}, 5}, -- Pit of Saron
   
   -- Wrath in-zone links, all currently incorrect
    -- UK
    {{80, 0.500, 0.500}, {82, 0.500, 0.500}, 5},
    {{80, 0.500, 0.500}, {84, 0.500, 0.500}, 5},
    
    -- AN
    {{88, 0.500, 0.500}, {90, 0.500, 0.500}, 5},
    {{88, 0.500, 0.500}, {92, 0.500, 0.500}, 5},
    
    -- Drak
    {{96, 0.500, 0.500}, {98, 0.500, 0.500}, 5},
    
    -- HoL
    {{106, 0.500, 0.500}, {108, 0.500, 0.500}, 5},
    
    -- Oculus
    {{110, 0.500, 0.500}, {112, 0.500, 0.500}, 5},
    {{110, 0.500, 0.500}, {114, 0.500, 0.500}, 5},
    {{110, 0.500, 0.500}, {116, 0.500, 0.500}, 5},
    
    -- CoT
    {{120, 0.500, 0.500}, {118, 0.500, 0.500}, 5},
    
    -- UP
    {{122, 0.500, 0.500}, {124, 0.500, 0.500}, 5},
    
    -- Naxx
    {{128, 0.500, 0.500}, {130, 0.500, 0.500}, 5},
    {{128, 0.500, 0.500}, {132, 0.500, 0.500}, 5},
    {{128, 0.500, 0.500}, {134, 0.500, 0.500}, 5},
    {{128, 0.500, 0.500}, {136, 0.500, 0.500}, 5},
    {{128, 0.500, 0.500}, {138, 0.500, 0.500}, 5},
    
    -- Ulduar
    {{144, 0.500, 0.500}, {146, 0.500, 0.500}, 5},
    {{144, 0.500, 0.500}, {148, 0.500, 0.500}, 5},
    {{144, 0.500, 0.500}, {150, 0.500, 0.500}, 5},
    {{144, 0.500, 0.500}, {152, 0.500, 0.500}, 5},
  }

-- Darkportal is handled specially, depending on whether or not you're level 58+ or not.
local dark_portal_route = {{33, 0.550, 0.541}, {56, 0.898, 0.502}, 60}

local static_zone_transitions =
  {
    -- Eastern Kingdoms

    
    
    -- Kalimdor
    
    
    
    --Outland
    
    
    
    --Northrend
        {65, 72, 0.527, 0.322}, -- Borean Tundra <--> Scholazar Basin
        
    
    
    
    --Cataclysm zones
    







    -- Work
        {7, 1, 0.117, 0.936}, -- Durotar <--> Orgrimmar.Front
        {7, 1, 0.366, 0.253}, -- Durotar <--> Orgrimmar.Side
        {15, 1, 0.792, 0.017}, -- Azshara <--> Orgrimmar.Back
    




--    {{174, 0.61, 0.20}, {168, 0.50, 0.74}, 5}, -- CoS <--> NS (Both part of STV)
   {2, 11, 0.687, 0.872}, -- Ashenvale <--> Northern Barrens
   {2, 6, 0.423, 0.711}, -- Ashenvale <--> Stonetalon Mountains
   {2, 15, 0.954, 0.484}, -- Ashenvale <--> Azshara
   {2, 16, 0.289, 0.144}, -- Ashenvale <--> Darkshore
   {2, 13, 0.557, 0.29}, -- Ashenvale <--> Felwood
   {21, 24, 0.894, 0.358}, -- Darnassus <--> Teldrassil
   {22, 203, 0.697, 0.604}, -- Mulgore <--> Southern Barrens
   {22, 23, 0.376, 0.33}, -- Mulgore <--> Thunder Bluff
   {22, 23, 0.403, 0.193}, -- Mulgore <--> Thunder Bluff
   {3, 12, 0.247, 0.494}, -- Azuremyst Isle <--> The Exodar
   {3, 12, 0.369, 0.469}, -- Azuremyst Isle <--> The Exodar
   {3, 12, 0.310, 0.487}, -- Azuremyst Isle <--> The Exodar
   {3, 12, 0.335, 0.494}, -- Azuremyst Isle <--> The Exodar
   {3, 9, 0.42, 0.013}, -- Azuremyst Isle <--> Bloodmyst Isle
   {4, 6, 0.539, 0.032}, -- Desolace <--> Stonetalon Mountains
   {4, 17, 0.428, 0.976}, -- Desolace <--> Feralas
   {5, 18, 0.865, 0.115}, -- Silithus <--> Un'Goro Crater
  {7, 11, 0.341, 0.424}, -- Durotar <--> Northern Barrens
   {8, 18, 0.269, 0.516}, -- Tanaris <--> Un'Goro Crater
   {8, 14, 0.512, 0.21}, -- Tanaris <--> Thousand Needles
   {10, 14, 0.50, 0.94}, -- Dustwallow Marsh <--> Thousand Needles
   {10, 203, 0.287, 0.472}, -- Dustwallow Marsh <--> Southern Barrens
   {10, 203, 0.531, 0.104}, -- Dustwallow Marsh <--> Southern Barrens
   {203, 11, 0.367, 0.048}, -- Southern Barrens <--> Northern Barrens
   {203, 14, 0.43, 0.96}, -- Southern Barrens <--> Thousand Needles
   {13, 19, 0.685, 0.06}, -- Felwood <--> Winterspring
   {13, 20, 0.669, -0.063}, -- Felwood <--> Moonglade
   {17, 14, 0.899, 0.46}, -- Feralas <--> Thousand Needles
   {6, 203, 0.29, 0.08}, -- Stonetalon Mountains <--> The Barrens
   {39, 51, 0.454, 0.89}, -- Arathi Highlands <--> Wetlands
   {39, 48, 0.2, 0.293}, -- Arathi Highlands <--> Hillsbrad Foothills
   {27, 29, 0.47, 0.071}, -- Badlands <--> Loch Modan
   {27, 32, 0.05, 0.53}, -- Badlands <--> Searing Gorge
   {33, 46, 0.519, 0.051}, -- Blasted Lands <--> Swamp of Sorrows
   {40, 30, 0.79, 0.842}, -- Burning Steppes <--> Redridge Mountains
   {47, 31, 0.324, 0.363}, -- Deadwind Pass <--> Duskwood
   {47, 46, 0.605, 0.41}, -- Deadwind Pass <--> Swamp of Sorrows
   {28, 25, 0.534, 0.349}, -- Dun Morogh <--> Ironforge
   {28, 29, 0.863, 0.514}, -- Dun Morogh <--> Loch Modan
   {28, 29, 0.844, 0.31}, -- Dun Morogh <--> Loch Modan
   {31, 37, 0.801, 0.158}, -- Duskwood <--> Elwynn Forest
   {31, 37, 0.15, 0.214}, -- Duskwood <--> Elwynn Forest
   {31, 38, 0.447, 0.884}, -- Duskwood <--> Stranglethorn Vale
   {31, 38, 0.209, 0.863}, -- Duskwood <--> Stranglethorn Vale
   {31, 30, 0.941, 0.103}, -- Duskwood <--> Redridge Mountains
   {31, 49, 0.079, 0.638}, -- Duskwood <--> Westfall
   {34, 50, 0.077, 0.661}, -- Eastern Plaguelands <--> Western Plaguelands
   {34, 44, 0.575, 0.000}, -- Eastern Plaguelands <--> Ghostlands
   {37, 36, 0.321, 0.493}, -- Elwynn Forest <--> Stormwind City   -- Don't need to convert because it's in Elwynn coordinates, not Stormwind coordinates
   {37, 49, 0.202, 0.804}, -- Elwynn Forest <--> Westfall
   {37, 30, 0.944, 0.724}, -- Elwynn Forest <--> Redridge Mountains
   {41, 52, 0.567, 0.494}, -- Eversong Woods <--> Silvermoon City
   {41, 44, 0.486, 0.916}, -- Eversong Woods <--> Ghostlands
   {35, 43, 0.678, 0.049}, -- Silverpine Forest <--> Tirisfal Glades
   {42, 50, 0.217, 0.264}, -- The Hinterlands <--> Western Plaguelands
   {43, 45, 0.619, 0.651}, -- Tirisfal Glades <--> Undercity
   {43, 50, 0.851, 0.703}, -- Tirisfal Glades <--> Western Plaguelands
   {38, 49, 0.292, 0.024}, -- Stranglethorn Vale <--> Westfall
   {48, 35, 0.137, 0.458}, -- Hillsbrad Foothills <--> Silverpine Forest
   {48, 42, 0.899, 0.253}, -- Hillsbrad Foothills <--> The Hinterlands
   {51, 184, 0.80, 0.47}, -- Wetlands <--> Twilight Highlands
   {29, 51, 0.252, 0}, -- Loch Modan <--> Wetlands
   
   -- Outland
   {58, 60, 0.783, 0.545}, -- Nagrand <--> Shattrath City   -- this is aldor-only
   {60, 55, 0.782, 0.492}, -- Shattrath City <--> Terokkar Forest
   {54, 59, 0.842, 0.284}, -- Blade's Edge Mountains <--> Netherstorm
   {54, 57, 0.522, 0.996}, -- Blade's Edge Mountains <--> Zangarmarsh
   {54, 57, 0.312, 0.94}, -- Blade's Edge Mountains <--> Zangarmarsh
   {56, 55, 0.353, 0.901}, -- Hellfire Peninsula <--> Terokkar Forest
   {56, 57, 0.093, 0.519}, -- Hellfire Peninsula <--> Zangarmarsh
   {58, 55, 0.8, 0.817}, -- Nagrand <--> Terokkar Forest
   {58, 57, 0.343, 0.159}, -- Nagrand <--> Zangarmarsh
   {58, 57, 0.754, 0.331}, -- Nagrand <--> Zangarmarsh
   {53, 55, 0.208, 0.271}, -- Shadowmoon Valley <--> Terokkar Forest
   {55, 57, 0.341, 0.098}, -- Terokkar Forest <--> Zangarmarsh
   
   -- Northrend
   {65, 68, 0.967, 0.359}, -- Borean Tundra <--> Dragonblight
   {74, 72, 0.208, 0.191}, -- Wintergrasp <--> Sholazar 
   {68, 74, 0.250, 0.410}, -- Dragonblight <--> Wintergrasp
   {68, 71, 0.359, 0.155}, -- Dragonblight <--> Icecrown
   {68, 66, 0.612, 0.142}, -- Dragonblight <--> Crystalsong
   {68, 75, 0.900, 0.200}, -- Dragonblight <--> Zul'Drak
   {68, 69, 0.924, 0.304}, -- Dragonblight <--> Grizzly Hills
   {68, 69, 0.931, 0.634}, -- Dragonblight <--> Grizzly Hills
   {70, 69, 0.540, 0.042}, -- Howling Fjord <--> Grizzly Hills
   {70, 69, 0.233, 0.074}, -- Howling Fjord <--> Grizzly Hills
   {70, 69, 0.753, 0.060}, -- Howling Fjord <--> Grizzly Hills
   {69, 75, 0.432, 0.253}, -- Grizzly Hills <--> Zul'Drak
   {69, 75, 0.583, 0.136}, -- Grizzly Hills <--> Zul'Drak
   {66, 75, 0.967, 0.599}, -- Crystalsong <--> Zul'Drak
   {66, 71, 0.156, 0.085}, -- Crystalsong <--> Icecrown
   {66, 73, 0.706, 0.315}, -- Crystalsong <--> Storm Peaks
   {66, 73, 0.839, 0.340}, -- Crystalsong <--> Storm Peaks
   {71, 73, 0.920, 0.767}, -- Icecrown <--> Storm Peaks
}

if QuestHelper:IsWrath32() then
  table.insert(static_zone_transitions, {153, 71, 0.5, 0.5}) -- Hrothgar's Landing <--> Icecrown
end

local function convertLostIsles(current, other1, other2)
  if QuestHelper_ZoneLookup[current] then return current end
  if QuestHelper_ZoneLookup[other1] then return other1 end
  if QuestHelper_ZoneLookup[other2] then return other2 end
  QuestHelper: Assert(false, "LostIsles is not working.")
end

function load_graph_links()
  local function convert_coordinate(coord)
    QuestHelper: Assert(coord[1] and coord[2] and coord[3])
    
    -- I hate Blizzard... They can't make up their mind weather we are on Hyjal or Hyjal_terrain1, but we only seem to be on one or the other.
    if coord[1] == 198 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 185
    elseif coord[1] == 185 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 198
    end

    -- I hate Blizzard... They can't make up their mind weather we are on Uldum or Uldum_terrain1, but we only seem to be on one or the other.
    if coord[1] == 164 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 210
    elseif coord[1] == 210 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 164
    end

    -- I hate Blizzard... They can't make up their mind whether we are on LostIsles, LostIsles_terrain1 or LostIsles_terrain2, but we only seem to be on one.
    
    -- Create a lookup table.
    local converter = {}
    converter[181] = function() return convertLostIsles(181, 208, 209) end
    converter[208] = function() return convertLostIsles(208, 181, 209) end
    converter[209] = function() return convertLostIsles(209, 181, 208) end

    -- Use the lookup table to get the real coordinate.
    if converter[coord[1]] then coord[1] = converter[coord[1]]() end

    local QHZL = QuestHelper_ZoneLookup
    local test = QHZL[181] or QHZL[208] or QHZL[209]
    QuestHelper: Assert(test, "Umm, something is seriously wrong... We're missing a LostIsles terrain.")
    QuestHelper: Assert(QuestHelper_ZoneLookup[coord[1]], string.format("Coord[1] = %d", coord[1]))
    local c, x, y = QuestHelper.Astrolabe:GetAbsoluteContinentPosition(QuestHelper_ZoneLookup[coord[1]][1], QuestHelper_ZoneLookup[coord[1]][2], coord[2], coord[3])
    QuestHelper: Assert(c)
    return {x = x, y = y, p = coord[1], c = c}
  end

  local function do_routes(routes)
    for k, v in ipairs(routes) do
      if not v.level_limit or v.level_limit <= UnitLevel("player") then
QuestHelper:Assert(v[1], tostring(k) .. " is the key, v[1].")
QuestHelper:Assert(v[2], tostring(k) .. " is the key, v[2]. v[1] is " .. tostring(v[1])) -- breaks here
        local src = convert_coordinate(v[1])
        local dst = convert_coordinate(v[2])
        QuestHelper: Assert(src.x and dst.x)
        src.map_desc = {QHFormat("WAYPOINT_REASON", QuestHelper_NameLookup[v[2][1]])}
        dst.map_desc = {QHFormat("WAYPOINT_REASON", QuestHelper_NameLookup[v[1][1]])}
        
        local rev_cost = v[3]
        if v[4] then rev_cost = nil end
        QH_Graph_Plane_Makelink("static_route", src, dst, v[3], rev_cost) -- this couldn't possibly fail
      end
    end
  end
  
-- Generating landing_db for potential use in adding Mage portals and Hearthstone to routing
  local faction_db
  local landing_db
  if UnitFactionGroup("player") == "Alliance" then
    faction_db = static_alliance_routes
    landing_db = static_alliance_landings
  else
    faction_db = static_horde_routes
    landing_db = static_horde_landings
  end
  
-- Not adding landing_db or static_shared_landings here because it depend on implimentation
  do_routes(faction_db)
  do_routes(static_shared_routes)
  
  for k, v in ipairs(static_zone_transitions) do
QuestHelper:Assert(v[1], tostring(k) .. " is the key, v[1]-2.")
QuestHelper:Assert(v[3], tostring(k) .. " is the key, v[3]-2.")
QuestHelper:Assert(v[4], tostring(k) .. " is the key, v[4]-2.")
    local src = convert_coordinate({v[1], v[3], v[4]})
    local dst = convert_coordinate({v[1], v[3], v[4]})
    dst.p = v[2]
    src.map_desc = {QHFormat("WAYPOINT_REASON", QHFormat("ZONE_BORDER_SIMPLE", QuestHelper_NameLookup[v[2]]))}
    dst.map_desc = {QHFormat("WAYPOINT_REASON", QHFormat("ZONE_BORDER_SIMPLE", QuestHelper_NameLookup[v[1]]))}
    QH_Graph_Plane_Makelink("static_transition", src, dst, 0, 0)
  end
  
  do
QuestHelper:Assert(dark_portal_route[1], "DPR1")
QuestHelper:Assert(dark_portal_route[2], "DPR2")
    local src = convert_coordinate(dark_portal_route[1])
    local dst = convert_coordinate(dark_portal_route[2])
    src.map_desc = {QHFormat("WAYPOINT_REASON", QHFormat("ZONE_BORDER_SIMPLE", QuestHelper_NameLookup[dark_portal_route[2]]))}
    dst.map_desc = {QHFormat("WAYPOINT_REASON", QHFormat("ZONE_BORDER_SIMPLE", QuestHelper_NameLookup[dark_portal_route[1]]))}
    QH_Graph_Plane_Makelink("dark_portal", src, dst, 15, 15)
  end
end
