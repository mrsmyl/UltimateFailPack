
local GetTime = QuestHelper_GetTime

QuestHelper_File["director_find.lua"] = "5.0.5.267r"
QuestHelper_Loadtime["director_find.lua"] = GetTime()

if not QH_API then QH_API = {} end

local function getitall(name)
  local segments = {}
  for i = 1, #name - 1 do
    local sub = name:sub(i, i + 1):lower()
    if not sub:find(" ") then
      local dbi = DB_GetItem("find", sub:byte(1) * 256 + sub:byte(2), true)
      --print("inserting", sub)
      if not dbi then return {} end
      segments[dbi] = true
    end
  end
  
  local segwork = {}
  for k in pairs(segments) do
    table.insert(segwork, {k, 1, k[1]})
  end
  
  local found = {}
  
  while true do
    local lowest = segwork[1][3]
    local highest = segwork[1][3]
    local lid = 1
    for i = 2, #segwork do
      local v = segwork[i][3]
      --print("loop", i, lowest, highest, v, segwork[i][2])
      if v < lowest then
        --print("lower")
        lowest, lid = v, i
      end
      if v > highest then
        --print("higher")
        highest = v
      end
    end
    
    if lowest == highest then
      table.insert(found, lowest)
      segwork[1][2] = segwork[1][2] + 1
      if not segwork[1][1][segwork[1][2]] then break end
      segwork[1][3] = segwork[1][3] + segwork[1][1][segwork[1][2]]
    else
      while segwork[lid][3] < highest do
        segwork[lid][2] = segwork[lid][2] + 1
        if not segwork[lid][1][segwork[lid][2]] then break end
        segwork[lid][3] = segwork[lid][3] + segwork[lid][1][segwork[lid][2]]
      end
    end
    
    if not segwork[lid][1][segwork[lid][2]] then break end
  end
  
  return found
end

local custom_find = {}

local function generate_objective(dbi)
  if not custom_find[dbi.name] then
    local clooster = {}

    local why = {desc = dbi.name, tracker_desc = dbi.name}
    for _, v in ipairs(dbi.loc) do
      QuestHelper: Assert(QuestHelper_ParentLookup)
      QuestHelper: Assert(QuestHelper_ParentLookup[v.p], v.p)
      table.insert(clooster, {loc = {x = v.x, y = v.y, c = QuestHelper_ParentLookup[v.p], p = v.p}, cluster = clooster, tracker_hidden = true, why = why, map_desc = {QuestHelper:HighlightText(dbi.name)}, tracker_desc = dbi.name, map_suppress_ignore = true, map_custom_menu = function (menu) QuestHelper:CreateMenuItem(menu, QHText("FIND_REMOVE")):SetFunction(function () QH_Route_ClusterRemove(clooster) end) end})
    end
  
    QH_Route_ClusterAdd(clooster)
    custom_find[dbi.name] = clooster
  else
    QH_Route_ClusterRemove(custom_find[dbi.name])
    custom_find[dbi.name] = nil
  end
end

local msfires = {desc = QHText("FIND_CUSTOM_LOCATION"), tracker_desc = QHText("FIND_CUSTOM_LOCATION")}

local function QH_FindCoord(locx, locy, locz, label)
  if type(locz) ~= "number" then -- If it is a number, we are probably doing an elder right now.
    label = locz .. " (" .. locx .. ", " .. locy .. ")"
    for z, nam in pairs(QuestHelper_NameLookup) do
      if nam:lower():find(locz:lower()) then
        locz = z
        break
      end
    end
  end
    
  if type(locz) == "number" then
    if not custom_find[label] then 
      local ec, ez = unpack(QuestHelper_ZoneLookup[locz])
      local c, x, y = QuestHelper.Astrolabe:GetAbsoluteContinentPosition(ec, ez, locx / 100, locy / 100)
      local node = {loc = {x = x, y = y, p = locz, c = QuestHelper_ParentLookup[locz]}, why = {desc = label, tracker_desc = label}, map_desc = {label}, tracker_desc = label, tracker_hidden = true}
      local cluster = {node}
      node.cluster = cluster

	  custom_find[label] = cluster        
      node.map_suppress_ignore = true
      node.map_custom_menu = function (menu) QuestHelper:CreateMenuItem(menu, QHText("FIND_REMOVE")):SetFunction(function () QH_Route_ClusterRemove(cluster); custom_find[cluster.tracker_desc] = nil end) end
        
      QH_Route_ClusterAdd(cluster)
    else
      QH_Route_ClusterRemove(custom_find[label])
      custom_find[label] = nil
    end
  end
end

local function QH_FindLoc(locd)
  -- I just know some guy's gonna get pissed off because he was trying to find "loc crocolisk" or something, but screw him
  local locx, locy, locz
 
  locx, locy = locd:match("^(%d+) (%d+)$")
  if locx and locy then
    locx, locy = tonumber(locx), tonumber(locy)
    locz = QuestHelper_NameLookup[QuestHelper_IndexLookup[QuestHelper.routing_c][QuestHelper.routing_z]]
  end
 
  if not locx then
    locz, locx, locy = locd:match("^(.+) (%d+) (%d+)$")
    locx, locy = tonumber(locx), tonumber(locy)
  end
 
  if locz then
    QH_FindCoord(locx, locy, locz, QHText("FIND_CUSTOM_LOCATION"))
  end
end

local elders = {
  ["Alliance"] = { -- Achievement 915
    ["Bladeswift"]  = {381, 39, 32, 8718, 1999}, --"Darnassus 39 32",
    ["Bronzebeard"] = {341, 29, 16, 8866, 1997}, --"Ironforge 29 16",
    ["Hammershout"] = { 30,  2, 10, 8646, 1998}, --"Elwynn Forest 34 50"
  },
  ["Horde"] = { -- Achievement 914
    ["Darkhorn"]  = {321, 52,   60,   8677, 1991}, --"Orgrimmar 52 60",
    ["Wheathoof"] = {362, 73.0, 23.3, 8678, 1993}, --"Thunder Bluff 73.0 23.3",
    ["Darkcore"]  = {382, 67,   38,   8648, 1992}, --"Undercity 67 38"
  },
  ["Kalimdor"] = { -- Achievement 911
    ["Bladeleaf"]     = { 41, 56.8, 53.1, 8715, 1951}, --"Teldrassil 56.8 53.1",
    ["Bladesing"]     = {261, 53,   35,   8719, 1966}, --"Silithus 53 35",
    ["Bloodhoof"]     = {  9, 48,   53,   8673, 1953}, --"Mulgore 48 53",
    ["Brightspear"]   = {281, 53.0, 56.7, 8726, 1963}, --"Winterspring 53.0 56.7",
    ["Dreamseer"]     = {161, 50,   28,   8684, 1961}, --"Tanaris 50 28",
    ["Grimtotem"]     = {121, 76.7, 37.9, 8679, 1955}, --"Feralas 76.7 37.9",
    ["High Mountain"] = {607, 41.5, 47.5, 8686, 1919}, --"Southern Barrens 41.5 47.5",
    ["Mistwalker"]    = {121, 62.6, 31.1, 8685, 1956}, --"Feralas 62.6 31.1",
    ["Moonwarden"]    = { 11, 48.5, 59.2, 8717, 1918}, --"Northern Barrens 48.5 59.2",
    ["Morningdew"]    = { 61, 77.0, 75.6, 8724, 1959}, --"Thousand Needles 77.0 75.6",
    ["Nightwind"]     = {182, 38.3, 52.9, 8723, 1957}, --"Felwood 38.3 52.9",
    ["Primestone"]    = {261, 30.7, 13.3, 8654, 1965}, --"Silithus 30.7 13.3",
    ["Ragetotem"]     = {161, 36,   80,   8671, 1960}, --"Tanaris 36 80",
    ["Riversong"]     = { 43, 35.5, 48.9, 8725, 1954}, --"Ashenvale 35.5 48.9",
    ["Runetotem"]     = {  4, 53.2, 43.6, 8670, 1916}, --"Durotar 53.2 43.6",
    ["Skygleam"]      = {181, 64.8, 79.3, 8720, 1917}, --"Azshara 64.8 79.3",
    ["Skyseer"]       = { 61, 46.3, 51.0, 8682, 1958}, --"Thousand Needles 46.3 51.0",
    ["Starweave"]     = { 42, 49.5, 19.0, 8721, 1952}, --"Darkshore 49.5 19.0",
    ["Stonespire"]    = {281, 60.0, 50.0, 8672, 1964}, --"Winterspring 60.0 50.0",
    ["Thunderhorn"]   = {201, 51,   75,   8681, 1962}, --"Un'Goro Crater 51 75",
    ["Windtotem"]     = { 11, 68.4, 70,   8680, 1920}, --"Northern Barrens 68.4 70",
  },
  ["Eastern Kingdoms"] = { -- Achievement 912
    ["Bellowrage"] = {19, 54, 49, 8647}, --"Blasted Lands 54 49",
    ["Rumblerock"] = {29, 70, 45, 8636}, --"Burning Steppes 70 45",
    ["Dawnstrider"] = {29, 53, 24, 8683}, --"Burning Steppes 53 24",
    ["Goldwell"] = {27, 53.9, 49.9, 8653}, --"Dun Morogh 53 49",
    ["Windrun"] = {23, 35.6, 68.8, 8688}, --"Eastern Plaguelands 35 68",
    ["Snowcrown"] = {23, 75.7, 54.5, 8650}, --"Eastern Plaguelands 75.7 54.5",
    ["Stormbrow"] = {30, 40, 63, 8649}, --"Elwynn Forest 40 63",
    ["Highpeak"] = {26, 50, 48, 8643}, --"Hinterlands 50 48",
    ["Silvervein"] = {35, 33, 46, 8642}, --"Loch Modan 33 46",
    ["Ironband"] = {28, 21, 79, 8651}, --"Searing Gorge 21 79",
    ["Obsidian"] = {21, 45, 41, 8645}, --"Silverpine Forest 45 41",
    ["Starglade"] = {37, 71, 34, 8716}, --"Northern Stranglethorn 71 34"
    ["Winterhoof"] = {673, 39, 72, 8674}, --"The Cape of Stranglethorn 39 72"
    ["Graveborn"] = {20, 61, 53, 8652}, --"Tirisfal Glades 61 53",
    ["Moonstrike"] = {22, 69, 73, 8714}, --"Western Plaguelands 69 73",
    ["Meadowrun"] = {22, 63.5, 36.2, 8722}, --"Western Plaguelands 63 36",
    ["Skychaser"] = {39, 56, 47, 8675}, --"Westfall 56 47"
  },
  ["Northrend"] = { -- Achievement 1396
    ["Arp"]        = {486, 57, 44, 13033, 5145}, --"Borean Tundra 57 44",
    ["Northal"]    = {486, 34, 34, 13016, 5146}, --"Borean Tundra 34 34",
    ["Pamuya"]     = {486, 43, 50, 13029, 5157}, --"Borean Tundra 43 50",
    ["Sardis"]     = {486, 59, 66, 13012, 5141}, --"Borean Tundra 59 66",
    ["Morthie"]    = {488, 30, 56, 13014, 5143}, --"Dragonblight 30 56",
    ["Skywarden"]  = {488, 35, 48, 13031, 5159}, --"Dragonblight 35 48",
    ["Thoim"]      = {488, 49, 78, 13019, 5154}, --"Dragonblight 49 78",
    ["Beldak"]     = {490, 61, 28, 13013, 5142}, --"Grizzly Hills 61 28",
    ["Lunaro"]     = {490, 81, 37, 13025, 5149}, --"Grizzly Hills 81 37",
    ["Whurain"]    = {490, 64, 47, 13030, 5158}, --"Grizzly Hills 64 47",
    ["Bluewolf"]   = {501, 49, 14, 13026, 5150}, --"Wintergrasp 49 14",
    ["Sandrene"]   = {493, 50, 64, 13018, 5147}, --"Sholazar Basin 50 64",
    ["Wanikaya"]   = {493, 64, 49, 13024, 5148}, --"Sholazar Basin 64 49",
    ["Fargal"]     = {495, 29, 74, 13015, 5144}, --"Storm Peaks 29 74",
    ["Graymane"]   = {495, 41, 85, 13028, 5155}, --"Storm Peaks 41 85",
    ["Muraco"]     = {495, 64, 51, 13032, 5160}, --"Storm Peaks 64 51",
    ["Stonebeard"] = {495, 31, 38, 13020, 5156}, --"Storm Peaks 31 38",
    ["Tauros"]     = {496, 59, 56, 13027, 5151}, --"Zul'Drak 59 56"
  },
  ["Cataclysm"] = { -- Achievement 6006
	  ["Moonlance"]   = {615, 57, 86, 29738, 18154}, -- Biel'aran Ridge, Shimmering Expanse
	  ["Windsong"]    = {606, 27, 62, 29739, 18156}, -- Sanctuary of Malorne, Hyjal
	  ["Evershade"]   = {606, 63, 23, 29740, 18155}, -- Nordrassil, Hyjal
	  ["Stonebrand"]  = {640, 50, 55, 29735, 18157}, -- Temple of Earth, Deepholm
	  ["Deepforge"]   = {640, 28, 69, 29734, 18158}, -- Stonehearth, Deepholm
	  ["Menkhaf"]     = {720, 66, 19, 29742, 18159}, -- Khartut's Tomb, Uldum
	  ["Sekhemi"]     = {720, 32, 63, 29741, 18160}, -- Ruins of Ammon, Uldum
	  ["Firebeard"]   = {700, 51, 71, 29737, 18161}, -- Dunward Town Square, Dunward Ruins, Twilight Highlands
	  ["Darkfeather"] = {700, 52, 33, 29736, 18162} -- Thundermar Ruins, Twilight Highlands
  },
  --[===[ Placeholder for Elders of the Dungeons. If enabled prior to 2013, stored coordinates should be the map ID of the zone where the instance is located and the coordinates of the entrance. With any luck, by 2013 dungeons will be mapable. Coordinates listed in comment after each elder need to have floor numbers determined, where necessary, ASAP.
  ["Dungeons"] = { -- Achievement 910
  	["Wildmane"]    = {,,,8676,  1910}, -- Zul'Farrak 34.52 39.35
	["Splitrock"]   = {,,,8635,  1912}, -- Maraudon 51.47, 93.7
	["Morndeep"]    = {,,,8619,  1914}, -- Blackrock Depths 50.52 62.97
	["Jarten"]      = {,,,13017, 5259}, -- Utgarde Keep 47.4, 69.54
	["Nurgen"]      = {,,,13022, 5261}, -- Azjol-Nerub 21.78 43.62
	["Ohanzee"]     = {,,,13065, 5263}, -- Gundrak 45.7 61.55
	["Chogan'gada"] = {,,,13067, 5265}, -- Utgarde Pinnacle 47.71 22.99
	["Starsong"]    = {,,,8713,  1911}, -- Sunken Temple 62.92 34.46
	["Stonefort"]   = {,,,8644,  1913}, -- Blackrock Spire 61.82 40
	["Farwhisper"]  = {,,,8727,  1915}, -- Stratholme 78.62 22.14
	["Igasho"]      = {,,,13021, 5260}, -- The Nexus 55.18 64.74
	["Kilias"]      = {,,,13023, 5262}, -- Drak'tharon Keep 68.85 79.17
	["Yurauk"]      = {,,,13066, 5264} -- Halls of Stone 29.39 62.03
  }
  --]===]
}

trackedElders = {}

local function UpdateElders()
  local elder, elderinfo
  local qid = GetQuestID()
  for elder, elderinfo in pairs(trackedElders) do
    local z, x, y, id = unpack(elderinfo)
    if id == qid then
      QH_FindCoord(x, y, z, elder)
      trackedElders[elder] = nil
      return
    end
  end
end

QH_Event("QUEST_COMPLETE", UpdateElders)

local function QH_FindElders(elder_or_achievement, all_elders, forAchievement)
  if elder_or_achievement == "CLEAR" then
    for elder, elderinfo in pairs(trackedElders) do
      local z, x, y = unpack(elderinfo)
      QH_FindCoord(x, y, z, elder)
    end

    trackedElders = {}
    return
  end

  local achievement_match, elder_match = false, false

  local elderCount = 0

  for achievement, eldrs in pairs(elders) do
    if not all_elders then
      if elder_or_achievement == string.upper(achievement) then achievement_match = true end
    end

    for elder, elder_info in pairs(eldrs) do
      local locz, locx, locy, qid, aid = unpack(elder_info)
      local okToAdd = true
      if forAchievement then
	if aid then
	  local _, _, completed = GetAchievementCriteriaInfo(aid)
	  if completed then okToAdd = false end
	end
      elseif qid and QHQuestsCompleted and QHQuestsCompleted[qid] then
        okToAdd = false
      end
      if okToAdd then

	if not all_elders then
          if achievement_match then -- just add it
            QH_FindCoord(locx, locy, locz, elder)
	    if trackedElders[elder] then trackedElders[elder] = nil
            else 
	      trackedElders[elder] = elder_info
	      elderCount = elderCount + 1
	    end
          elseif elder_or_achievement == string.upper(elder) then -- We have input and it's not an achievement, so it must be an elder.
            elder_match = true
            QH_FindCoord(locx, locy, locz, elder)
	    if trackedElders[elder] then trackedElders[elder] = nil
	    else 
	      trackedElders[elder] = elder_info
	      elderCount = elderCount + 1
	    end

            break -- We've found him or her.
          end -- No need for else here. We alread know we don't need everything so we either have an achievement or we have an elder.
        else -- We came in without an input, therefore we add all.
          QH_FindCoord(locx, locy, locz, elder)
	  if trackedElders[elder] then trackedElders[elder] = nil
	  else 
	    trackedElders[elder] = elder_info
	    elderCount = elderCount + 1
	  end
        end
      end
    end

    if achievement_match or elder_match then break end -- We've done our match.
  end

  if elderCount == 0 then QuestHelper:TextOut("No elders were added.") end
end

function QH_FindName(name)
  local locd = name:match("^loc (.+)")
  local forAchievement = false, elder_loc, temp
  
  if not locd then
    if name:find("^elders?") then
      if name:find("^elders? achievement") then 
        forAchievement = true
        elder_loc = name:match("elders? achievement (.+)")
      else
	elder_loc = name:match("elders? (.+)")
      end
    end
  end

  if locd then
    QH_FindLoc(locd)
  elseif elder_loc then
    if elder_loc == true then QH_FindElders(nil, true, forAchievement)
    else QH_FindElders(string.upper(elder_loc), false, forAchievement)
    end
  else
    if not DB_Ready() then
      QuestHelper:TextOut(QHText("FIND_NOT_READY"))
      return
    end
    
    if #name < 2 then
      QuestHelper:TextOut(QHText("FIND_USAGE"))
      return
    end
    
    local found = getitall(name)
    
    local mennix = QuestHelper:CreateMenu()
    QuestHelper:CreateMenuTitle(mennix, QHText("RESULTS_TITLE"))
   
    local made_item = false
    
    local found_db = {}
    local has_name = {}
    local needs_postfix = {}
    
    for _, v in ipairs(found) do
      local dbi = DB_GetItem("monster", v)
      --[[ assert(dbi) ]]
      
      if dbi.loc then
        table.insert(found_db, dbi)
        
        if has_name[dbi.name] then needs_postfix[dbi.name] = true end
        has_name[dbi.name] = true
      end
    end
    
    table.sort(found_db, function (a, b) return a.name < b.name end)
    
    for _, v in ipairs(found_db) do
      made_item = true
    
      local name = v.name
      
      if needs_postfix[name] then name = name .. " (" .. QuestHelper_NameLookup[v.loc[1].p] .. ")" end
      
      local opt = QuestHelper:CreateMenuItem(mennix, name)
      opt:SetFunction(generate_objective, v)
    end
    
    if not made_item then
      QuestHelper:CreateMenuItem(mennix, QHText("NO_RESULTS"))
    end
    
    mennix:ShowAtCursor()
  end
end

QH_API.ARCHY_ADD = function (locx, locy, localizedZoneName, displayText)
  QH_FindCoord(locx, locy, localizedZoneName, displayText)
end

QH_API.ARCHY_REMOVE = function (displayText)
  if not custom_find[displayText] then return end
  QH_Route_ClusterRemove(custom_find[displayText])
  custom_find[displayText] = nil  
end
