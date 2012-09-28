
local GetTime = QuestHelper_GetTime

QuestHelper_File["pathfinding.lua"] = "5.0.5.262r"
QuestHelper_Loadtime["pathfinding.lua"] = GetTime()

-- Update flying for Mount Up guild achievement.
-- Telport/Portal spell for Tol Barad.  Same location as portals in the Earthshrines in the cities?
-- If a transition requires a quest, and the questgiver is at the initial portal location, not implimenting a requirement.


-- This section for whenever from-player's-location-to pathing can be implimented.

    -- Mage teleport spells and druid teleport spell all say "10 sec cast
    -- Hearthstone is also a 10 second cast
    -- So make one general setting for the 10 seconds plus 5 for the world to load

    -- local porttime = 15
    
QueryQuestsCompleted();
local dependancy_quest_list = GetQuestsCompleted()

local static_alliance_landings = 
    {
        {471, 0.476, 0.598, "Exodar via portal"}, -- Exodar
        {381, 0.435, 0.787, "Darnassus via portal"}, -- Darnassus
        {301, 0.496, 0.865, "Stormwind via portal"}, -- Stormwind
        {341, 0.255, 0.084, "Ironforge via portal"}, -- Ironforge
        {141, 0.660, 0.490, "Theramore via portal"}, -- Theramore, Dustwallow Marsh
    }
    
local static_horde_landings =
    {
        {321, 0.483, 0.645, "Orgrimmar via portal"}, -- Orgrimmar
        {362, 0.222, 0.169, "Thunder Bluff via portal"}, -- Thunder Bluff
        {382, 0.845, 0.163, "Undercity via portal"}, -- Undercity
        {480, 0.583, 0.192, "Silvermoon City via portal"}, -- Silvermoon City
        {38, 0.498, 0.558, "Stonard via portal"}, -- Stonard, Swamp of Sorrows
    }
    
local static_shared_landings =
    {
        {504, 0.559, 0.468, "Dalaran via portal"}, -- Dalaran
        {481, 0.550, 0.402, "Shattrath via portal"}, -- Shattrath
        -- Need Tol Barad Port In coordinates
	-- Highly doubtful that Tol Barad Port In Coordinates are the same.
    }

if IsSpellKnown(18960) then
    local static_druid_landings = {241,0.563,0.324, "Moonglade via spell"} -- Moonglade landing
end

-- end whimsey


-- More storage

        -- Contingent on player's faction controlling the zone        
        -- {{501, 0.491, 0.153}, {504, 0.268, 0.447}, 5, true}, -- Wingergrasp Keep --> Dalaran
        -- {{708, 0.472, 0.519}, ORGRIMMAR_CATPORTAL_IN, 60, true}, -- Tol Barad --> Orgrimmar (If Horde Controlled)
        -- {{708, 0.472, 0.519}, STORMWIND_CATPORTAL_IN, 60, true}, -- Tol Barad --> Stormwind (If Alliance Controlled)

-- end storage


local BLASTED_LANDS_PORTAL_IN = {19, 0.539, 0.461, "Blasted Lands via portal"}
local ORGRIMMAR_CATPORTAL_IN = {321, 0.500, 0.377, "Orgrimmar via portal"}
-- local STORMWIND_CATPORTAL_IN

local static_horde_routes = 
  {
    -- Portals
        {{321, 0.471, 0.618}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Orgrimmar --> Dark Portal
        {{382, 0.853, 0.171}, BLASTED_LANDS_PORTAL_IN, 5, true, level_limit = 58},  -- Undercity --> Dark Portal
        {{362, 0.232, 0.135}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Thunder Bluff --> Dark Portal
        {{480, 0.584, 0.210}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Silvermoon --> Dark Portal

        -- I'm really not concerned that the landing points are different.  This is a self-contained method.
        -- It won't affect anything that we don't have two one-way paths here.
        {{382, 0.549, 0.113}, {480, 0.495, 0.148}, 60}, -- Undercity <--> Silvermoon City

        {{465, 0.886, 0.477}, {321, 0.483, 0.645}, 60, true},  -- Hellfire Peninsula --> Orgrimmar
        {{700, 0.736, 0.535}, ORGRIMMAR_CATPORTAL_IN, 60, true}, -- Twilight Highlands --> Orgrimmar
        
        {{321, 0.475, 0.392}, {709, 0.560, 0.799}, 60, false, level_limit = 85}, -- Orgrimmar <--> Tol Barad Peninsula

        
        -- Okay, I give.  Since I haven't actually been through these portals, I don't really have a frame
        -- of reference, but from everything I can see, there are a jumble of dependancies woven throughout
        -- the quest chains that open the connections from Cataclysm to and from Orgrimmar, and likewise
        -- Stormwind.  For the time being, I'm just opening the portals, but with level requirements based
        -- on the starting levels for the quest chains, under the assumption that before you could use any
        -- of these portals, you're going to have started the quest chain, which can't happen before the
        -- listed level.  Once I've run these myself and understand just what's going on, then I can start
        -- tying them to the proper quest-completion dependancy.
        
        -- From what I understand, at some point a portal from Orgrimmar to the zone opens in the EarthShrine
        -- area in Orgrimmar.  When exactly is unclear.  Some zones, but not all, have a return portal.
        -- This, too, is unclear.
                
        -- Orgrimmar --> Temple of Earth (Aqua)
            -- Level limit because the quest to open requires level 82.
        {{640, 0.509, 0.531}, ORGRIMMAR_CATPORTAL_IN, 60, true}, -- Temple of Earth (Aqua) --> Orgrimmar

        {{321, 0.508, 0.363}, {640, 0.506, 0.529}, 60, true, level_limit = 82}, -- Orgrimmar --> Deepholm
            -- Level limit because the quest to open requires level 82.
        
        {{321, 0.511, 0.383}, {606, 0.635, 0.234}, 60, true, level_limit = 80}, -- Orgrimmar --> Mount Hyjal
            -- Level limit because the quest to open requires level 80.
            
        {{321, 0.502, 0.394}, {700, 0.736, 0.534}, 60, true, level_limit = 84}, -- Orgrimmar --> Twilight Highlands
            -- Level limit because the quest to open requires level 84.

        {{321, 0.489, 0.386}, {720, 0.549, 0.342}, 5, true, level_limit = 83}, -- Orgrimmar --> Uldum
            -- Level limit because the quest to open requires level 83.

        {{321, 0.492, 0.365}, {613, 0.514, 0.609}, 60, true, level_limit = 80}, -- Orgrimmar --> Vashj'ir
            -- Level limit because the quest to open requires level 80.


    -- Zepplins
        {{321, 0.526, 0.529}, {37, 0.372, 0.525}, 210}, -- Orgrimmar <--> Grom'gol Base Camp
        {{321, 0.506, 0.561}, {20, 0.607, 0.588}, 210}, -- Orgrimmar <--> Tirisfal Glades
        {{321, 0.428, 0.653}, {362, 0.152, 0.257}, 210}, -- Orgrimmar <--> Thunder Bluff
        {{321, 0.449, 0.619}, {486, 0.414, 0.536}, 210}, -- Orgrimmar <--> Warsong Hold, Borean Tundra

        {{20, 0.619, 0.591}, {37, 0.374, 0.509}, 210}, -- Tirisfal Glades <--> Grom'gol Base Camp, Northern Stranglethorn
        {{20, 0.590, 0.590}, {491, 0.777, 0.282}, 210}, -- Tirisfal Glades <--> Vengeance Landing
        
    -- Ships
        {{700, 0.735, 0.528}, {700, 0.767, 0.152}, 210}, -- Dragonmaw Port, Twilight Highlands <--> Krazzworks, Twilight Highlands
-- QuestHelper does not appear to like transitions from within the same zone.  Gonna have to figure this out.

  }


local static_alliance_routes = 
  {
    -- Portals
        {{381,0.440,0.782}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Darnassus --> Dark Portal
        {{471,0.482,0.630}, BLASTED_LANDS_PORTAL_IN, 60, true, level_limit = 58},  -- Exodar --> Dark Portal
        {{341,0.273,0.070}, BLASTED_LANDS_PORTAL_IN, 5, true, level_limit = 58},  -- Ironforge --> Dark Portal
        {{301,0.490,0.874}, BLASTED_LANDS_PORTAL_IN, 5, true, level_limit = 58},  -- Stormwind --> Dark Portal
    
        {{465, 0.886, 0.528}, {301, 0.496, 0.865}, 60, true},  -- Hellfire Peninsula --> Stormwind
        {{381, 0.442, 0.788}, {471, 0.476, 0.598}, 5, true}, -- Darnassus --> Exodar
        {{471, 0.476, 0.619}, {381, 0.435, 0.787}, 5, true}, -- Exodar --> Darnassus

        -- Stormwind --> Tol Barad?

        {{301, 0.734, 0.195}, {640, 0.487, 0.536}, 60, true, level_limit = 82}, -- Stormwind --> Temple of Earth (Amber)
            -- Level limit because the quest to open requires level 82.
        {{640, 0.486, 0.537}, {301, 0.745, 0.183}, 60, true}, -- Temple of Earth (Amber) --> Stormwind
        
        -- Stormwind <--> Deepholm
        -- Stormwind <--> Mount Hyjal
        -- Stormwind <--> Twilight Highlands
        -- Stormwind <--> Uldum
        -- Stormwind <--> Vashj'ir

    -- Ships
        {{301, 0.180, 0.285}, {486, 0.597, 0.694}, 210}, -- Stormwind <--> Valiance Keep, Borean Tundra

    -- Deeprun Tram (Wonder if this needs to be handled differently because of it's nature but this will suffice for now).
    -- As it turns out, the mapid for deeprun tram is sw, so no need to do any special handling.
        {{301, 0.696, 0.311}, {341, 0.770, 0.513}, 180}, -- Stormwind <--> Ironforge

    -- Partially checked

   -- Nate's Cataclysm content
   {{684, 0.54, 0.60}, {685, 0.30, 0.72}, 10}, -- Gilneas Zone <--> Greymane Court, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{684, 0.55, 0.42}, {685, 0.28, 0.21}, 5}, -- Gilneas Zone <--> Cathedral Square, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{684, 0.66, 0.42}, {685, 0.67, 0.20}, 5}, -- Gilneas Zone <--> Merchant Square, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{684, 0.68, 0.62}, {685, 0.69, 0.82}, 10}, -- Gilneas Zone <--> Military District, Gilneas City. Exists solely to fix some pathing crashes. (We want to make an adjustment to the coords though.)
   {{684, 0.42, 0.36}, {41, 0.52, 0.89}, 86400}, -- Gilneas Zone <--> Teldrassil. Exists solely to fix some pathing crashes. 24-hour boat ride :D (This will be deleted later, when we can create the "official" path.)
  }

local static_shared_routes = 
  {
    -- Portals
        {{504, 0.268, 0.447}, {504, 0.240, 0.394}, 5}, -- Dalaran (Violet Citadel) <--> Dalaran (Purple Parlor)
        
        {{504, 0.559, 0.468}, {510, 0.158, 0.428}, 5}, -- Dalaran <--> Crystalsong Forest
        --{{504, 0.559, 0.468}, {510, 0.158, 0.428}, 5, false, level_limit = 68}, -- Dalaran <--> Crystalsong Forest

        {{41, 0.551, 0.885}, {381, 0.369, 0.584}, 5}, -- Rut'Theran Village, Teldrassil <--> Darnassus
        
        {{19, 0.550, 0.541}, {465, 0.898, 0.502}, 60}, -- Blasted Lands <--> Hellfire Peninsula (Dark Portal)

        {{504, 0.255, 0.514}, {161, 0.652, 0.498}, 60, true}, -- Dalaran --> Caverns of Time
        {{481, 0.486, 0.420}, {499, 0.482, 0.345}, 60, true}, -- Shattrath --> Isle of Quel'Danas
        
        {{481, 0.747, 0.316}, {161, 0.652, 0.498}, 60, true}, -- Shattrath --> Caverns of Time
        -- Requires Revered with Keepers of Time

        {{640, 0.493, 0.504}, {640, 0.571, 0.135}, 5, false, level_limit = 81}, -- Temple of Earth <--> Therazane's Throne
            -- Requires Honored with Therazane and dependant on quest #26709
        
    -- Ships
        {{488, 0.497, 0.784}, {491, 0.234, 0.578}, 210}, -- Moa'ki <--> Kamagua
        {{488, 0.479, 0.788}, {486, 0.789, 0.537}, 210}, -- Moa'ki <--> Unu'pe
        {{673, 0.390, 0.670}, {11, 0.702, 0.733}, 210}, -- Booty Bay, Cape of Stranglethorn <--> Ratchet

    -- Leave here to keep QH from self-destructing
        {{41, 0.522, 0.895}, {464, 0.203, 0.540}, 210}, -- Teldrassil <--> Azuremyst Isle
        {{41, 0.550, 0.938}, {301, 0.223, 0.560}, 210}, -- Teldrassil <--> Stormwind

    -- Unchecked
        {{29, 0.318, 0.503}, {28, 0.347, 0.84}, 130}, -- Burning Steppes <--> Searing Gorge

    -- Route to new zone. Not valid, exists only to keep routing from exploding if you don't have the flight routes there.
        {{462, 0.5, 0.5}, {499, 0.484, 0.251}, 7200}, -- Eversong Woods <--> Sunwell
        {{23, 0.817, 0.461}, {502, 0.492, 0.312}, 86400}, -- EPL Ebon Hold <--> Scarlet Enclave Ebon Hold. Exists solely to fix some pathing crashes. 24-hour boat ride :D

   -- Nate's Cataclysm content
   {{613, 0.83, 0.34}, {610, 0.45, 0.23}, 210, true}, -- Vash'jir --> Vash'jir Kelp Forest (One time, One way)
   {{610, 0.69, 0.60}, {613, 0.80, 0.30}, 5}, -- Vash'jir Kelp Forest <--> Vash'jir
   {{613, 0.84, 0.23}, {-1, 0.37, 0.58}, 5}, -- Vash'jir <--> The Great Sea (EK Continent, zone 0)
   {{-1, 0.39, 0.60}, {27, 0.00, 0.20}, 5}, -- The Great Sea (EK Continent, zone 0) <--> Dun Morogh
   {{610, 0.40, 0.64}, {615, 0.56, 0.14}, 5}, -- VKF <--> SE
   {{613, 0.50, 0.28}, {614, 0.72, 0.04}, 5}, -- Vash <--> Vash'jir Depths
   {{606, 0.85, 0.41}, {281, 0.58, 0.91}, 5}, -- Hyjal <--> Winterspring
   {{684, 0.5, 0.5}, {685, 0.5, 0.5}, 5}, -- Ruins of Gilneas <--> Ruins of Gilneas City (Meta info, map doesn't change properly as of 2010-12-11-0156UET)
   {{640, 0.5, 0.5}, {605, 0.5, 0.5}, 86400}, -- DeepHolm <--> Kezan (Meta info for when major error is fixed.)
   {{544, 0.24, 0.77}, {605, 0.22, 0.17}, 90}, -- The Lost Isles <--> Kezan (Meta info for when major error is fixed.)
   {{544, 0.5, 0.5}, {737, 0.5, 0.5}, 86400}, -- The Lost Isles <--> The Maelstrom (Meta info for when major error is fixed.)
   {{751, 0.5, 0.5}, {737, 0.5, 0.5}, 86400}, -- The Maelstrom Continent <--> The Maelstrom (Meta info for when major error is fixed.)
   {{751, 0.5, 0.5}, {321, 0.5, 0.5}, 86400}, -- The Maelstrom Continent <--> Orgrimmar (Meta info for when major error is fixed.)

   {{720, 0.84, 0.41}, {161, 0.37, 0.82}, 5}, -- Uldum <--> Tanaris
   {{720, 0.70, 0.22}, {161, 0.25, 0.66}, 5}, -- Uldum <--> Tanaris

   {{21, 0.45, 0.85}, {684, 0.60, 0.09}, 5}, -- Silverpine <--> Ruins of Gilneas
--[==[
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
    --]==]
  }

-- Darkportal is handled specially, depending on whether or not you're level 58+ or not.
local dark_portal_route = {{19, 0.550, 0.541}, {465, 0.898, 0.502}, 60}

-- Waygate
local ridingLevel = (select(4,GetAchievementInfo(892)) and 300) or (select(4,GetAchievementInfo(890)) and 225) or (select(4,GetAchievementInfo(889)) and 150) or (select(4,GetAchievementInfo(891)) and 75) or 0 -- this is thanks to Maldivia, who is a fucking genius
local has_fmsl = not not GetSpellInfo(GetSpellInfo(90267)) 
if ridingLevel >= 225 and has_fmsl then 
    table.insert(static_shared_routes, {{201, 0.505, 0.078}, {493, 0.403, 0.830}, 60, false, level_limit = 77}) -- Un'Goro Crater <--> Sholazar Basin
        -- Dependant on completion of quest #12613
end 

-- Cataclysm Quest-dependant static routes
-- STILL WORKING ON THESE.  See Notes under Static_Horde.

--    for k, v in ipairs(dependancy_quest_list) do
--        if v[1] == 26709 then table.insert(static_shared_routes, {{179, 0.493, 0.504}, {179, 0.571, 0.135}, 5})  -- Temple of Earth <--> Therazane's Throne
            -- Requires Honored with Therazane?
--    end

-- Horde
    -- If Quest 26840 then Hyjal --> Orgrimmar

local static_zone_transitions =
  {
    -- Eastern Kingdoms

    -- Kalimdor
    
    --Outland
    
    --Northrend
        {486, 493, 0.527, 0.322}, -- Borean Tundra <--> Scholazar Basin
        
    --Cataclysm zones
    
    -- Work
        {4, 321, 0.117, 0.936}, -- Durotar <--> Orgrimmar (Front)
        {4, 321, 0.366, 0.253}, -- Durotar <--> Orgrimmar (Side)
        {181, 321, 0.792, 0.017}, -- Azshara <--> Orgrimmar (Back)
        {772, 261, 0.687, 0.2}, -- Ahn'Qiraj <--> Silithus
        {37, 673, 0.50, 0.61}, -- Northern Stranglethorn <--> Cape of Stranglethorn
        
        --{38, 168, 0, 0}, -- Stranglethorn World Map Wonkiness

   {43, 11, 0.687, 0.872}, -- Ashenvale <--> Northern Barrens
   {43, 81, 0.423, 0.711}, -- Ashenvale <--> Stonetalon Mountains
   {43, 181, 0.954, 0.484}, -- Ashenvale <--> Azshara
   {43, 42, 0.289, 0.144}, -- Ashenvale <--> Darkshore
   {43, 182, 0.557, 0.29}, -- Ashenvale <--> Felwood
   {381, 41, 0.894, 0.358}, -- Darnassus <--> Teldrassil
   {9, 607, 0.697, 0.604}, -- Mulgore <--> Southern Barrens
   {9, 362, 0.376, 0.33}, -- Mulgore <--> Thunder Bluff
   {9, 362, 0.403, 0.193}, -- Mulgore <--> Thunder Bluff
   {464, 471, 0.247, 0.494}, -- Azuremyst Isle <--> The Exodar
   {464, 471, 0.369, 0.469}, -- Azuremyst Isle <--> The Exodar
   {464, 471, 0.310, 0.487}, -- Azuremyst Isle <--> The Exodar
   {464, 471, 0.335, 0.494}, -- Azuremyst Isle <--> The Exodar
   {464, 476, 0.42, 0.013}, -- Azuremyst Isle <--> Bloodmyst Isle
   {101, 81, 0.539, 0.032}, -- Desolace <--> Stonetalon Mountains
   {101, 121, 0.428, 0.976}, -- Desolace <--> Feralas
   {261, 201, 0.865, 0.115}, -- Silithus <--> Un'Goro Crater
  {4, 11, 0.341, 0.424}, -- Durotar <--> Northern Barrens
   {161, 201, 0.269, 0.516}, -- Tanaris <--> Un'Goro Crater
   {161, 61, 0.512, 0.21}, -- Tanaris <--> Thousand Needles
   {141, 61, 0.50, 0.94}, -- Dustwallow Marsh <--> Thousand Needles
   {141, 607, 0.287, 0.472}, -- Dustwallow Marsh <--> Southern Barrens
   {141, 607, 0.531, 0.104}, -- Dustwallow Marsh <--> Southern Barrens
   {607, 11, 0.367, 0.048}, -- Southern Barrens <--> Northern Barrens
   {607, 61, 0.43, 0.96}, -- Southern Barrens <--> Thousand Needles
   {182, 281, 0.685, 0.06}, -- Felwood <--> Winterspring
   {182, 241, 0.669, -0.063}, -- Felwood <--> Moonglade
   {121, 61, 0.899, 0.46}, -- Feralas <--> Thousand Needles
   {81, 11, 0.29, 0.08}, -- Stonetalon Mountains <--> Northern Barrens IS THIS ONE RIGHT?
   {16, 40, 0.454, 0.89}, -- Arathi Highlands <--> Wetlands
   {16, 24, 0.2, 0.293}, -- Arathi Highlands <--> Hillsbrad Foothills
   {17, 35, 0.47, 0.071}, -- Badlands <--> Loch Modan
   {17, 28, 0.05, 0.53}, -- Badlands <--> Searing Gorge
   {19, 38, 0.519, 0.051}, -- Blasted Lands <--> Swamp of Sorrows
   {29, 36, 0.79, 0.842}, -- Burning Steppes <--> Redridge Mountains
   {32, 34, 0.324, 0.363}, -- Deadwind Pass <--> Duskwood
   {32, 38, 0.605, 0.41}, -- Deadwind Pass <--> Swamp of Sorrows
   {27, 341, 0.534, 0.349}, -- Dun Morogh <--> Ironforge
   {27, 35, 0.863, 0.514}, -- Dun Morogh <--> Loch Modan
   {27, 35, 0.844, 0.31}, -- Dun Morogh <--> Loch Modan
   {34, 30, 0.801, 0.158}, -- Duskwood <--> Elwynn Forest
   {34, 30, 0.15, 0.214}, -- Duskwood <--> Elwynn Forest
   {34, 689, 0.447, 0.884}, -- Duskwood <--> Stranglethorn Vale
   {34, 689, 0.209, 0.863}, -- Duskwood <--> Stranglethorn Vale
   {34, 36, 0.941, 0.103}, -- Duskwood <--> Redridge Mountains
   {34, 39, 0.079, 0.638}, -- Duskwood <--> Westfall
   {23, 22, 0.077, 0.661}, -- Eastern Plaguelands <--> Western Plaguelands
   {23, 463, 0.575, 0.000}, -- Eastern Plaguelands <--> Ghostlands
   {30, 301, 0.321, 0.493}, -- Elwynn Forest <--> Stormwind City   -- Don't need to convert because it's in Elwynn coordinates, not Stormwind coordinates
   {30, 39, 0.202, 0.804}, -- Elwynn Forest <--> Westfall
   {30, 36, 0.944, 0.724}, -- Elwynn Forest <--> Redridge Mountains
   {462, 480, 0.567, 0.494}, -- Eversong Woods <--> Silvermoon City
   {462, 463, 0.486, 0.916}, -- Eversong Woods <--> Ghostlands
   {21, 20, 0.678, 0.049}, -- Silverpine Forest <--> Tirisfal Glades
   {26, 22, 0.217, 0.264}, -- The Hinterlands <--> Western Plaguelands
   {20, 382, 0.619, 0.651}, -- Tirisfal Glades <--> Undercity
   {20, 22, 0.851, 0.703}, -- Tirisfal Glades <--> Western Plaguelands
   {689, 39, 0.292, 0.024}, -- Stranglethorn Vale <--> Westfall
   {24, 21, 0.137, 0.458}, -- Hillsbrad Foothills <--> Silverpine Forest
   {24, 26, 0.899, 0.253}, -- Hillsbrad Foothills <--> The Hinterlands
   {40, 700, 0.80, 0.47}, -- Wetlands <--> Twilight Highlands
   {35, 40, 0.252, 0}, -- Loch Modan <--> Wetlands
   
   -- Outland
   {477, 481, 0.783, 0.545}, -- Nagrand <--> Shattrath City   -- this is aldor-only
   {481, 478, 0.782, 0.492}, -- Shattrath City <--> Terokkar Forest
   {475, 479, 0.842, 0.284}, -- Blade's Edge Mountains <--> Netherstorm
   {475, 467, 0.522, 0.996}, -- Blade's Edge Mountains <--> Zangarmarsh
   {475, 467, 0.312, 0.94}, -- Blade's Edge Mountains <--> Zangarmarsh
   {465, 478, 0.353, 0.901}, -- Hellfire Peninsula <--> Terokkar Forest
   {465, 467, 0.093, 0.519}, -- Hellfire Peninsula <--> Zangarmarsh
   {477, 478, 0.8, 0.817}, -- Nagrand <--> Terokkar Forest
   {477, 467, 0.343, 0.159}, -- Nagrand <--> Zangarmarsh
   {477, 467, 0.754, 0.331}, -- Nagrand <--> Zangarmarsh
   {473, 478, 0.208, 0.271}, -- Shadowmoon Valley <--> Terokkar Forest
   {478, 467, 0.341, 0.098}, -- Terokkar Forest <--> Zangarmarsh
   
   -- Northrend
   {486, 488, 0.967, 0.359}, -- Borean Tundra <--> Dragonblight
   {501, 493, 0.208, 0.191}, -- Wintergrasp <--> Sholazar 
   {488, 501, 0.250, 0.410}, -- Dragonblight <--> Wintergrasp
   {488, 492, 0.359, 0.155}, -- Dragonblight <--> Icecrown
   {488, 510, 0.612, 0.142}, -- Dragonblight <--> Crystalsong
   {488, 496, 0.900, 0.200}, -- Dragonblight <--> Zul'Drak
   {488, 490, 0.924, 0.304}, -- Dragonblight <--> Grizzly Hills
   {488, 490, 0.931, 0.634}, -- Dragonblight <--> Grizzly Hills
   {491, 490, 0.540, 0.042}, -- Howling Fjord <--> Grizzly Hills
   {491, 490, 0.233, 0.074}, -- Howling Fjord <--> Grizzly Hills
   {491, 490, 0.753, 0.060}, -- Howling Fjord <--> Grizzly Hills
   {490, 496, 0.432, 0.253}, -- Grizzly Hills <--> Zul'Drak
   {490, 496, 0.583, 0.136}, -- Grizzly Hills <--> Zul'Drak
   {510, 496, 0.967, 0.599}, -- Crystalsong <--> Zul'Drak
   {510, 492, 0.156, 0.085}, -- Crystalsong <--> Icecrown
   {510, 495, 0.706, 0.315}, -- Crystalsong <--> Storm Peaks
   {510, 495, 0.839, 0.340}, -- Crystalsong <--> Storm Peaks
   {492, 495, 0.920, 0.767}, -- Icecrown <--> Storm Peaks
}

if QuestHelper:IsWrath32() then
  table.insert(static_zone_transitions, {541, 492, 0.5, 0.5}) -- Hrothgar's Landing <--> Icecrown
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
   --[==[ 
    -- I hate Blizzard... They can't make up their mind weather we are on TwilightHighlands or TwilightHiglands_terrain1, but we only seem to be on one or the other.
    if coord[1] == 177 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 184
    elseif coord[1] == 184 and not QuestHelper_ZoneLookup[coord[1]] then
      coord[1] = 177
    end

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
  ]==]
    local QHZL = QuestHelper_ZoneLookup
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
