
local GetTime = QuestHelper_GetTime

QuestHelper_File["upgrade.lua"] = "5.0.5.267r"
local my_version = QuestHelper_File["upgrade.lua"]

QuestHelper_Loadtime["upgrade.lua"] = GetTime()

QuestHelper_Zones =
  {
   {[0]="Kalimdor",
    [1]="Ahn'Qiraj: The Fallen Kingdom",
    [2]="Ammen Vale",
    [3]="Ashenvale",
    [4]="Azshara",
    [5]="Azuremyst Isle",
    [6]="Bloodmyst Isle",
    [8]="Darkshore",
    [9]="Darnassus",
    [10]="Desolace",
    [11]="Durotar",
    [12]="Dustwallow Marsh",
    [14]="Felwood",
    [15]="Feralas",
    [16]="Moonglade",
    [17]="Mount Hyjal",
    [18]="Mulgore",
    [19]="Northern Barrens",
    [20]="Orgrimmar",
    [22]="Silithus",
    [23]="Southern Barrens",
    [24]="Stonetalon Mountains",
    [25]="Tanaris",
    [26]="Teldrassil",
    [27]="The Exodar",
    [28]="Thousand Needles",
    [29]="Thunder Bluff",
    [30]="Uldum",
    [31]="Un'Goro Crater",
    [33]="Winterspring"
   },
   {[0]="Eastern Kingdoms",
    [1]="Abyssal Depths",
    [2]="Arathi Highlands",
    [3]="Badlands",
    [4]="Blasted Lands",
    [5]="Burning Steppes",
    [7]="Deadwind Pass",
    [9]="Dun Morogh",
    [10]="Duskwood",
    [11]="Eastern Plaguelands",
    [12]="Elwynn Forest",
    [13]="Eversong Woods",
    [14]="Ghostlands",
    [15]="Hillsbrad Foothills",
    [16]="Ironforge",
    [17]="Isle of Quel'Danas",
    [18]="Kelp'thar Forest",
    [19]="Loch Modan",
    [21]="Northern Stranglethorn",
    [23]="Redridge Mountains",
    [24]="Ruins of Gilneas",
    [25]="Gilneas", -- Actually "Ruins of Gilneas City", but this fixes issues with some non-English clients that have the two zones named the same.
    [26]="Searing Gorge",
    [27]="Shimmering Expanse",
    [28]="Silvermoon City",
    [29]="Silverpine Forest",
    [30]="Stormwind City",
    [31]="Stranglethorn Vale",
    [33]="Swamp of Sorrows",
    [34]="The Cape of Stranglethorn",
    [35]="The Hinterlands",
    [36]="Tirisfal Glades",
    [37]="Tol Barad",
    [38]="Tol Barad Peninsula",
    [39]="Twilight Highlands",
    [40]="Undercity",
    [41]="Vashj'ir",
    [42]="Western Plaguelands",
    [43]="Westfall",
    [44]="Wetlands"
   },
   {[0]="Outland",
    [1]="Blade's Edge Mountains",
    [2]="Hellfire Peninsula",
    [3]="Nagrand",
    [4]="Netherstorm",
    [5]="Shadowmoon Valley",
    [6]="Shattrath City",
    [7]="Terokkar Forest",
    [8]="Zangarmarsh"
  },
  {[0]="Northrend",
    [1]="Borean Tundra",
    [2]="Crystalsong Forest",
    [3]="Dalaran",
    [4]="Dragonblight",
    [5]="Grizzly Hills",
    [6]="Howling Fjord",
    [7]="Hrothgar's Landing",
    [8]="Icecrown",
    [9]="Sholazar Basin",
    [10]="The Storm Peaks",
    [11]="Wintergrasp",
    [12]="Zul'Drak",
  },
  {[0]="The Maelstrom Continent",
   [1]="Deepholm",
   [2]="Kezan",
   [3]="The Lost Isles",
   [4]="The Maelstrom"
  },
  [-77]={[0]="ScarletEnclave_Continent", [1]="ScarletEnclave"},
}


-- This will be translated to [LOCALE_NAME] = INDEX by QuestHelper_BuildZoneLookup.
-- Additionally, [CONT_INDEX][ZONE_INDEX] = INDEX will also be added.
QuestHelper_IndexLookup =
 {
  ["Orgrimmar"] = {321, 1, 17},
  ["Ashenvale"] = {43, 1, 2},
  ["AzuremystIsle"] = {464, 1, 4},
  ["Desolace"] = {101, 1, 8},
  ["Silithus"] = {261, 1, 18},
  ["StonetalonMountains"] = {81, 1, 20},
  ["Durotar"] = {4, 1, 9},
  ["Tanaris"] = {161, 1, 21},
  ["BloodmystIsle"] = {476, 1, 5},
  ["Dustwallow"] = {141, 1, 10},
  ["Barrens"] = {11, 1, 16},
  ["TheExodar"] = {471, 1, 23},
  ["Felwood"] = {182, 1, 11},
  ["ThousandNeedles"] = {61, 1, 24},
  ["Aszhara"] = {181, 1, 3},
  ["Darkshore"] = {42, 1, 6},
  ["Feralas"] = {121, 1, 12},
  ["UngoroCrater"] = {201, 1, 27},
  ["Winterspring"] = {281, 1, 28},
  ["Moonglade"] = {241, 1, 13},
  ["Darnassus"] = {381, 1, 7},
  ["Mulgore"] = {9, 1, 15},
  ["ThunderBluff"] = {362, 1, 25},
  ["Teldrassil"] = {41, 1, 22},
  ["Ironforge"] = {341, 2, 14},
  ["Badlands"] = {17, 2, 3},
  ["DunMorogh"] = {27, 2, 7},
  ["LochModan"] = {35, 2, 17},
  ["Redridge"] = {36, 2, 19},
  ["Duskwood"] = {34, 2, 8},
  ["SearingGorge"] = {28, 2, 22},
  ["BlastedLands"] = {19, 2, 4},
  ["EasternPlaguelands"] = {23, 2, 9},
  ["Silverpine"] = {21, 2, 25},
  ["StormwindCity"] = {301, 2, 26},
  ["Elwynn"] = {30, 2, 10},
  ["StranglethornVale"] = {689, 2, 27},
  ["Arathi"] = {16, 2, 2},
  ["BurningSteppes"] = {29, 2, 5},
  ["EversongWoods"] = {462, 2, 11},
  ["Hinterlands"] = {26, 2, 30},
  ["Tirisfal"] = {20, 2, 31},
  ["Ghostlands"] = {463, 2, 12},
  ["Undercity"] = {382, 2, 35},
  ["SwampOfSorrows"] = {38, 2, 28},
  ["DeadwindPass"] = {32, 2, 6},
  ["HillsbradFoothills"] = {24, 2, 13},
  ["Westfall"] = {39, 2, 38},
  ["WesternPlaguelands"] = {22, 2, 37},
  ["Wetlands"] = {40, 2, 39},
  ["SilvermoonCity"] = {480, 2, 24},
  ["ShadowmoonValley"] = {473, 3, 5},
  ["BladesEdgeMountains"] = {475, 3, 1},
  ["TerokkarForest"] = {478, 3, 7},
  ["Hellfire"] = {465, 3, 2},
  ["Zangarmarsh"] = {467, 3, 8},
  ["Nagrand"] = {477, 3, 3},
  ["Netherstorm"] = {479, 3, 4},
  ["ShattrathCity"] = {481, 3, 6},
  ["Kalimdor"] = {13, 1, 0},
  ["Azeroth"] = {-1, 2, 0},
  ["Expansion01"] = {466, 3, 0},
  ["Sunwell"] = {499, 2, 15},  
  ["BoreanTundra"] = {486, 4, 1},
  ["CrystalsongForest"] = {510, 4, 2},
  ["Dalaran"] = {504, 4, 3},
  ["Dragonblight"] = {488, 4, 4},
  ["GrizzlyHills"] = {490, 4, 5},
  ["HowlingFjord"] = {491, 4, 6},
  ["IcecrownGlacier"] = {492, 4, 8},
  ["SholazarBasin"] = {493, 4, 9},
  ["TheStormPeaks"] = {495, 4, 10},
  ["LakeWintergrasp"] = {501, 4, 11},
  ["ZulDrak"] = {496, 4, 12},
  ["Northrend"] = {485, 4, 0},

  ["HrothgarsLanding"] = {541, 4, 7}, -- wooo consecutive numbering

  ["AhnQirajTheFallenKingdom"] = {772, 1, 1}, 
  ["Hyjal"] = {606, 1, 14}, -- Check
  ["SouthernBarrens"] = {607, 1, 19},
  ["Uldum"] = {720, 1, 26}, -- Check
  ["Uldum_terrain1"] = {720, 1, 26}, -- Check
  ["VashjirDepths"] = {614, 2, 1}, -- Check
  ["VashjirKelpForest"] = {610, 2, 16}, -- Check
  ["StranglethornJungle"] = {37, 2, 18},
  ["RuinsofGilneas"] = {684, 2, 20},
  ["RuinsofGilneasCity"] = {685, 2, 21},
  ["VashjirRuins"] = {615, 2, 23}, -- Check
  ["TheCapeOfStranglethorn"] = {673, 2, 29},
  ["TolBarad"] = {708, 2, 32},
  ["TolBaradDailyArea"] = {709, 2, 33},
  ["TwilightHighlands_terrain1"] = {700, 2, 34},
  ["Vashjir"] = {613, 2, 36}, -- Check
  ["Deepholm"] = {640, 5, 1},
  ["Kezan"] = {605, 5, 2},
  ["TheLostIsles"] = {544, 5, 3},
  ["TheLostIsles_terrain1"] = {544, 5, 3},
  ["TheLostIsles_terrain2"] = {544, 5, 3},
  ["TheMaelstrom"] = {737, 5, 4},
  ["TheMaelstromContinent"] = {751, 5, 0},
  ["TwilightHighlands"] = {700, 2, 34},
  ["Hyjal_terrain1"] = {606, 1, 14},
  ["ScarletEnclave_Continent"] = {-502, -77, 0}, ["ScarletEnclave"]={502,-77,1},
}

QuestHelper_RestrictedZones = { -- Everything defaults to "nil"
  [78] = 1,
  [205] = 1,
  [207] = 1,
}

local next_index = 1
for i, j in pairs(QuestHelper_IndexLookup) do next_index = math.max(next_index, j[1]+1) end

-- Maps zone names and indexes to a two element array, containing zone index a continent/zone
QuestHelper_ZoneLookup = {}

-- Maps indexes to zone names.
QuestHelper_NameLookup = {}

-- Maps plane indexes to the ultimate continent parents
QuestHelper_ParentLookup = {}

local built = false

function QuestHelper_BuildZoneLookup()
  if built then return end
  built = true
  
  if GetMapContinents and GetMapZones then
    -- Called from inside the WoW client.
    
    local original_lookup, original_zones = QuestHelper_IndexLookup, QuestHelper_Zones
    QuestHelper_IndexLookup = {}
    QuestHelper_Zones = {}
    
    for c, cname in pairs(QuestHelper.Astrolabe:GetMapVirtualContinents()) do
      QuestHelper_Zones[c] = {}
      local tpx = QuestHelper.Astrolabe:GetMapVirtualZones(c)
      tpx[0] = cname

      for z, zname in pairs(tpx) do
        
        local base_name = QuestHelper.Astrolabe:GetMapTexture(c, z)

        local index = original_lookup[base_name] and original_lookup[base_name][1]
        local altered_index = "!!! QuestHelper_IndexLookup entry needs update: [%q] = {%s, %s, %s}"
        local altered_zone = "!!! QuestHelper_Zones entry needs update: [%s][%s] = %q -- was %s"
        
        if not index and my_version == "5.0.5.$svnversion\$" then
          --QuestHelper_ErrorCatcher_ExplicitError(false, altered_index:format(tostring(base_name), tostring(next_index), tostring(c), tostring(z)))
          QuestHelper:TextOut(false, altered_index:format(tostring(base_name), tostring(next_index), tostring(c), tostring(z)))
          next_index = next_index + 1
        else
          if QuestHelper_Locale == "enUS" and my_version == "5.0.5.267r" then
            if original_lookup[base_name][2] ~= c or original_lookup[base_name][3] ~= z then
              --QuestHelper_ErrorCatcher_ExplicitError(false, altered_index:format(base_name, index, c, z))
              QuestHelper:TextOut(false, altered_index:format(base_name, index, c, z))
            end
            
            if not original_zones[c] or original_zones[c][z] ~= zname then
              QuestHelper_ErrorCatcher_ExplicitError(false, altered_zone:format(c, z, zname, original_zones[c] and original_zones[c][z] or "missing"))
              --QuestHelper:TextOut(altered_zone:format(c, z, zname, original_zones[c] and original_zones[c][z] or "missing"))
            end
          end
          
          local pair = {c, z}
          if not QuestHelper_IndexLookup[c] then QuestHelper_IndexLookup[c] = {} end
          QuestHelper_IndexLookup[c][z] = index
          QuestHelper_IndexLookup[zname] = index
          
          QuestHelper_NameLookup[index] = zname
          
          QuestHelper_ZoneLookup[zname] = pair
          QuestHelper_ZoneLookup[index] = pair
          
          QuestHelper_Zones[c][z] = zname
        end
      end
    end
    
    for name, index in pairs(original_lookup) do
      if index[2] == -1 then
        --assert(not QuestHelper_IndexLookup[name])
        QuestHelper_IndexLookup[name] = index[1]
      end
    end
    
    for k, v in pairs(QuestHelper_ZoneLookup) do
      if type(k) == "number" then
        --QuestHelper:TextOut(tostring(k) .. " " .. tostring(v[1]))
        if v[1] == 1 or v[1] == 2 or v[1] == 4 or v[1] == 5 then  -- weh
          QuestHelper_ParentLookup[k] = 0
        else
          QuestHelper_ParentLookup[k] = v[1]
        end
      end
    end
-- Sanity is failing BEFORE exiting the function... Duplicate indices... owa tagu siam. This is now true ONLY for non enUS version (grumble).
    QuestHelper:Assert(QuestHelper:ZoneSanity())
  else
    -- Called from some lua script.
    local original_lookup = QuestHelper_IndexLookup
    QuestHelper_IndexLookup = {}
    
    for base_name, i in pairs(original_lookup) do
      local index = i[1]
      local pair = {i[2], i[3]}
      local name = QuestHelper_Zones[pair[1]][pair[2]]
      
      --assert(index and name)
      
      if not QuestHelper_IndexLookup[pair[1]] then QuestHelper_IndexLookup[pair[1]] = {} end
      QuestHelper_IndexLookup[pair[1]][pair[2]] = index
      QuestHelper_IndexLookup[name] = index
      
      QuestHelper_NameLookup[index] = name
      
      QuestHelper_ZoneLookup[name] = pair
      QuestHelper_ZoneLookup[index] = pair
    end
    QuestHelper:Assert(QuestHelper:ZoneSanity())
  end
  
  -- We are broken by the time we get here. Time to turn these TextOut's to Errors.
  QuestHelper:Assert(QuestHelper:ZoneSanity())
end

local convert_lookup =
 {{2, 15, 3, 9, 16, 21, 4, 7, 10, 13, 17, 20, 22, 1, 5, 6, 8, 24, 11, 12, 14, 23, 18, 19},
  {26, 39, 27, 33, 40, 47, 28, 31, 34, 37, 41, 44, 48, 25, 29, 30, 32, 52, 35, 36, 38, 46, 42, 43, 45, 50, 49, 51},
  {54, 56, 58, 59, 53, 60, 55, 57}}

function QuestHelper_ValidPosition(c, z, x, y)
  return type(x) == "number" and type(y) == "number" and x > -0.1 and y > -0.1 and x < 1.1 and y < 1.1 and c and convert_lookup[c] and z and convert_lookup[c][z] and true
end

function QuestHelper_PrunePositionList(list)
  if type(list) ~= "table" then
    return nil
  end
  
  local i = 1
  while i <= #list do
    local pos = list[i]
    if QuestHelper_ValidPosition(unpack(list[i])) and type(pos[5]) == "number" and pos[5] >= 1 then
      i = i + 1
    else
      local rem = table.remove(list, i)
    end
  end
  
  return #list > 0 and list or nil
end

local function QuestHelper_ConvertPosition(pos)
  pos[2] = convert_lookup[pos[1]][pos[2]]
  table.remove(pos, 1)
end

local function QuestHelper_ConvertPositionList(list)
  if list then
    for i, pos in pairs(list) do
      QuestHelper_ConvertPosition(pos)
    end
  end
end

local function QuestHelper_ConvertFaction(faction)
  if faction == 1 or faction == "Alliance" or faction == FACTION_ALLIANCE then return 1
  elseif faction == 2 or faction == "Horde" or faction == FACTION_HORDE then return 2
  else
    --assert(false, "Unknown faction: "..faction.."'")
  end
end

function QuestHelper_UpgradeDatabase(data)
  if data.QuestHelper_SaveVersion == 1 then
    
    -- Reputation objectives weren't parsed correctly before.
    if data.QuestHelper_Objectives["reputation"] then
      for faction, objective in pairs(data.QuestHelper_Objectives["reputation"]) do
        local real_faction = string.find(faction, "%s*(.+)%s*:%s*") or faction
        if faction ~= real_faction then
          data.QuestHelper_Objectives["reputation"][real_faction] = data.QuestHelper_Objectives["reputation"][faction]
          data.QuestHelper_Objectives["reputation"][faction] = nil
        end
      end
    end
    
    -- Items that wern't in the local cache when I read the quest log ended up with empty names.
    if data.QuestHelper_Objectives["item"] then
      data.QuestHelper_Objectives["item"][" "] = nil
    end
    
    data.QuestHelper_SaveVersion = 2
  end
  
  if data.QuestHelper_SaveVersion == 2 then
    
    -- The hashes for the quests were wrong. Damnit!
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.hash = nil
          quest_data.alt = nil
        end
      end
    end
    
    -- None of the information I collected about quest items previously can be trusted.
    -- I also didn't properly mark quest items as such, so I'll have to remove the information for non
    -- quest items also.
    
    if data.QuestHelper_Objectives["item"] then
      for item, item_data in pairs(data.QuestHelper_Objectives["item"]) do
        -- I'll remerge the bad data later if I find out its not used solely for quests.
        item_data.bad_pos = item_data.bad_pos or item_data.pos
        item_data.bad_drop = item_data.bad_drop or item_data.drop
        item_data.pos = nil
        item_data.drop = nil
        
        -- In the future i'll delete the bad_x data.
        -- When I do, either just delete it, or of all the monsters or positions match the monsters and positions of the
        -- quest, merge them into that.
      end
    end
    
    data.QuestHelper_SaveVersion = 3
  end
  
  if data.QuestHelper_SaveVersion == 3 then
    -- We'll go through this and make sure all the position lists are correct.
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.pos = QuestHelper_PrunePositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              data.pos = QuestHelper_PrunePositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        data.pos = QuestHelper_PrunePositionList(data.pos)
      end
    end
    
    if data.QuestHelper_ZoneTransition then
      for c, z1list in pairs(data.QuestHelper_ZoneTransition) do
        for z1, z2list in pairs(z1list) do
          for z2, poslist in pairs(z2list) do
            z2list[z2] = QuestHelper_PrunePositionList(poslist)
          end
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 4
  end
  
  if data.QuestHelper_SaveVersion == 4 then
    -- Zone transitions have been obsoleted by a bug.
    data.QuestHelper_ZoneTransition = nil
    data.QuestHelper_SaveVersion = 5
  end
  
  if data.QuestHelper_SaveVersion == 5 then
    -- For version 6, I'm converting area positions from a continent/zone index pair to a single index.
    
    if data.QuestHelper_FlightRoutes then
      local old_routes = data.QuestHelper_FlightRoutes
      data.QuestHelper_FlightRoutes = {}
      for c, value in pairs(old_routes) do
        data.QuestHelper_FlightRoutes[QuestHelper_IndexLookup[c][0]] = value
      end
    end
    
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          QuestHelper_ConvertPositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            QuestHelper_ConvertPositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            QuestHelper_ConvertPositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              QuestHelper_ConvertPositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        QuestHelper_ConvertPositionList(data.pos)
      end
    end
    
    data.QuestHelper_SaveVersion = 6
  end
  
  if data.QuestHelper_SaveVersion == 6 then
    -- Redoing how flightpaths work, previously collected flightpath data is now obsolete.
    data.QuestHelper_FlightRoutes = {}
    
    -- FlightInstructors table should be fine, will leave it.
    -- Upgrading per-character data is handled in main.lua.
    
    -- Also converting factions to numbers, 1 for Alliance, 2 for Horde.
    local replacement = {}
    for faction, dat in pairs(data.QuestHelper_Quests) do
      replacement[QuestHelper_ConvertFaction(faction)] = dat
    end
    data.QuestHelper_Quests = replacement
    
    replacement = {}
    if data.QuestHelper_FlightInstructors then for faction, dat in pairs(data.QuestHelper_FlightInstructors) do
      replacement[QuestHelper_ConvertFaction(faction)] = dat
    end end
    data.QuestHelper_FlightInstructors = replacement
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if obj.faction then
          obj.faction = QuestHelper_ConvertFaction(obj.faction)
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 7
  end
  
  if data.QuestHelper_SaveVersion == 7 then
    -- It sure took me long enough to discover that I broke vendor objectives.
    -- their factions were strings and didn't match the number value of QuestHelper.faction
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if type(obj.faction) == "string" then
          obj.faction = (obj.faction == "Alliance" and 1) or (obj.faction == "Horde" and 2) or nil
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 8
  end
  
  if data.QuestHelper_SaveVersion == 8 then
    -- Two things we're doing here
    -- First, wrath-ize Stormwind coordinates
    
    --[[
    for cat, list in pairs(QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if obj.pos then
          for i, cpos in pairs(obj.pos) do
            QuestHelper_ConvertCoordsToWrath(cpos, true)
          end
        end
      end
    end]] -- okay we're not actually doing this, coordinates are staying native
    
    -- Second, split up the entire thing into versions
    local function versionize(item)
      --if not item or type(item) ~= "table" then return end  -- blue magician doesn't know what the fuck
      
      local temp = {}
      local foundthings = false
      for k, v in pairs(item) do
        temp[k] = v
        foundthings = true
      end
      if not foundthings then return end -- just to avoid extra keys hanging around in people's tables
      
      for key in pairs(item) do
        item[key] = nil
      end
      
      item["unknown on unknown"] = temp
    end
    
    versionize(data.QuestHelper_Quests)
    versionize(data.QuestHelper_Objectives)
    versionize(data.QuestHelper_FlightInstructors)
    versionize(data.QuestHelper_FlightRoutes)
    
    data.QuestHelper_SaveVersion = 9
  end
  
  if data.QuestHelper_SaveVersion == 9 then
    -- The only thing we're doing here is moving the QuestHelper_ErrorList into QuestHelper_Errors
    data.QuestHelper_Errors = {}
    data.QuestHelper_Errors.crashes = {}
    
    if data.QuestHelper_ErrorList then
      for k, v in pairs(data.QuestHelper_ErrorList) do
        data.QuestHelper_Errors.crashes[k] = v
      end
    end
    
    data.QuestHelper_ErrorList = nil
    
    data.QuestHelper_SaveVersion = 10
  end
end

function QuestHelper_UpgradeComplete()
  -- This function deletes everything related to upgrading, as it isn't going to be needed again.
  built = nil
  next_index = nil
  convert_lookup = nil
  QuestHelper_BuildZoneLookup = nil
  QuestHelper_ValidPosition = nil
  QuestHelper_PrunePositionList = nil
  QuestHelper_ConvertPosition = nil
  QuestHelper_ConvertPositionList = nil
  QuestHelper_ConvertFaction = nil
  QuestHelper_UpgradeDatabase = nil
  QuestHelper_UpgradeComplete = nil
end

-- These are used to convert coordinates back and forth from "Wrath" to "Native". "Force" is used to convert back and forth from "Wrath" to "BC".
-- Both changes the data in-place and returns the data.
function QuestHelper_ConvertCoordsToWrath(data, force)
  if force then
    if data[1] == 36 then -- Stormwind
      data[2] = data[2] * 0.77324 + 0.197
      data[3] = data[3] * 0.77324 + 0.245
    elseif data[1] == 34 then -- EPL
      data[2] = data[2] * 0.960 - 0.0254
      data[3] = data[3] * 0.960 - 0.03532
    end
  end
  return data
end

function QuestHelper_ConvertCoordsFromWrath(data, force)
  if force then
    if data[1] == 36 then -- Stormwind
      data[2] = (data[2] - 0.197) / 0.77324
      data[3] = (data[3] - 0.245) / 0.77324
    elseif data[1] == 34 then -- EPL
      data[2] = (data[2] + 0.0254) / 0.960
      data[3] = (data[3] + 0.03532) / 0.960
    end
  end
  return data
end

local QuestHelper_PrivateServerBlacklist_Find = {
  "WoWFusion",
  "WoWgasm",
  "Egyéb",
  "Reagens/",
}

local QuestHelper_PrivateServerBlacklist_Exact = {
  "WarcraftMMO",
  "TAXI",
  "GeNiuS",
  "Columbian Drug Dealer",
  "PlayBoy Fun Vendor",
  "Gm Vendor",
  "Accessories Vendor",
  "General Goods Vendor",
  "Party Vendor",
  "Potion Vendor",
  "Totem Vendor",
  "Gm Vendor",
  "Misc",
  "Off-Hands Vendor",
  "Ore Vendor",
  "Enchanting Vendor",
  "Gem Vendor",
  "Fooooood and Drinks!",
  "I Sell Consumables",
  "Armor Raid Tier V",
  "world translate",
  "Bobby", -- I have no idea if this is an actual private server NPC
  "Nejeib", -- same
  "Shaman Set Vendor",
  "Warrior Set Vendor",
  "Priest Set Vendor",
  "Warlock Set Vendor",
  "Paladin Set Vendor",
  "Hunter Set Vendor",
  "Mage Set Vendor",  -- yeah yeah this isn't everyone whatever
}

local matchstring = nil

function QuestHelper_IsPolluted(input)
  if not input then input = _G end
  
  for version, data in pairs(input.QuestHelper_Objectives) do
    for cat, name_list in pairs(data) do
      for name, obj in pairs(name_list) do
        for k, v in pairs(QuestHelper_PrivateServerBlacklist_Find) do
          if string.find(name, v) then
            for _, __ in pairs(obj) do
              return true -- if there's nothing actually in the object, the player may not have contributed data, he may have just gotten smacked by old corrupted data.
            end
          end
        end
        for k, v in pairs(QuestHelper_PrivateServerBlacklist_Exact) do
          if name == v then
            for _, __ in pairs(obj) do
              return true -- if there's nothing actually in the object, the player may not have contributed data, he may have just gotten smacked by old corrupted data.
            end
          end
        end
      end
    end
  end
end

