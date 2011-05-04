QuestHelper_File["director_find.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["director_find.lua"] = GetTime()

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

local function generate_objective(dbi)
  local clooster = {}

  local why = {desc = dbi.name, tracker_desc = dbi.name}
  for _, v in ipairs(dbi.loc) do
    QuestHelper: Assert(QuestHelper_ParentLookup)
    QuestHelper: Assert(QuestHelper_ParentLookup[v.p], v.p)
    if v.p == 26 then v.p = 48 end
    table.insert(clooster, {loc = {x = v.x, y = v.y, c = QuestHelper_ParentLookup[v.p], p = v.p}, cluster = clooster, tracker_hidden = true, why = why, map_desc = {QuestHelper:HighlightText(dbi.name)}, tracker_desc = dbi.name, map_suppress_ignore = true, map_custom_menu = function (menu) QuestHelper:CreateMenuItem(menu, QHText("FIND_REMOVE")):SetFunction(function () QH_Route_ClusterRemove(clooster) end) end})
  end
  
  QH_Route_ClusterAdd(clooster)
end

local msfires = {desc = QHText("FIND_CUSTOM_LOCATION"), tracker_desc = QHText("FIND_CUSTOM_LOCATION")}

local function QH_FindCoord(locx, locy, locz, label)
  if not type(locz) == "number" then -- If it is a number, we are probably doing an elder right now.
    for z, nam in pairs(QuestHelper_NameLookup) do
      if nam:lower():find(locz:lower()) then
        locz = z
        break
      end
    end
  end
    
  if type(locz) == "number" then
    local ec, ez = unpack(QuestHelper_ZoneLookup[locz])
    local c, x, y = QuestHelper.Astrolabe:GetAbsoluteContinentPosition(ec, ez, locx / 100, locy / 100)
    local node = {loc = {x = x, y = y, p = locz, c = QuestHelper_ParentLookup[locz]}, why = {desc = label, tracker_desc = label}, map_desc = {label}, tracker_desc = label, tracker_hidden = true}
    local cluster = {node}
    node.cluster = cluster
        
    node.map_suppress_ignore = true
    node.map_custom_menu = function (menu) QuestHelper:CreateMenuItem(menu, QHText("FIND_REMOVE")):SetFunction(function () QH_Route_ClusterRemove(cluster) end) end
        
    QH_Route_ClusterAdd(cluster)
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
  ["Alliance"] = {
    ["Bladeswift"] = {21, 39, 32}, --"Darnassus 39 32",
    ["Bronzebeard"] = {25, 29, 16}, --"Ironforge 29 16",
    ["Hammershout"] = {37, 2, 10}, --"Elwynn Forest 34 50"
  },
  ["Horde"] = {
    ["Darkhorn"] = {1, 52, 60}, --"Orgrimmar 52 60",
    ["Wheathoof"] = {23, 73.0, 23.3}, --"Thunder Bluff 73.0 23.3",
    ["Darkcore"] = {45, 67, 38}, --"Undercity 67 38"
  },
  ["Kalimdor"] = {
    ["Riversong"] = {2, 35.5, 48.9}, --"Ashenvale 35.5 48.9",
    ["Skygleam"] = {15, 64.8, 79.3}, --"Azshara 64.8 79.3",
    ["High Mountain"] = {203, 41.5, 47.5}, --"Southern Barrens 41.5 47.5",
    ["Moonwarden"] = {11, 48.5, 59.2}, --"Northern Barrens 48.5 59.2",
    ["Windtotem"] = {11, 68.4, 70}, --"Northern Barrens 68.4 70",
    ["Starweave"] = {16, 49.5, 19.0}, --"Darkshore 49.5 19.0", NOTE TO SELF -- CONVERTING TO LOOKUP VALUES DON'T FORGET TO CHANGE THE FUNCTION!!!!!!!
    ["Runetotem"] = {7, 53.2, 43.6}, --"Durotar 53.2 43.6",
    ["Nightwind"] = {13, 38.3, 52.9}, --"Felwood 38.3 52.9",
    ["Grimtotem"] = {17, 76.7, 37.9}, --"Feralas 76.7 37.9",
    ["Mistwalker"] = {17, 62.6, 31.1}, --"Feralas 62.6 31.1",
    ["Bloodhoof"] = {22, 48, 53}, --"Mulgore 48 53",
    ["Bladesing"] = {5, 53, 35}, --"Silithus 53 35",
    ["Primestone"] = {5, 30.7, 13.3}, --"Silithus 30.7 13.3",
    ["Dreamseer"] = {8, 50, 28}, --"Tanaris 50 28",
    ["Ragetotem"] = {8, 36, 80}, --"Tanaris 36 80",
    ["Bladeleaf"] = {24, 56.8, 53.1}, --"Teldrassil 56.8 53.1",
    ["Skyseer"] = {14, 46.3, 51.0}, --"Thousand Needles 46.3 51.0",
    ["Morningdew"] = {14, 77.0, 75.6}, --"Thousand Needles 77.0 75.6",
    ["Thunderhorn"] = {18, 51, 75}, --"Un'Goro Crater 51 75",
    ["Brightspear"] = {19, 53.0, 56.7}, --"Winterspring 53.0 56.7",
    ["Stonespire"] = {19, 60.0, 50.0}, --"Winterspring 60.0 50.0",
  },
  ["Eastern Kingdoms"] = {
    ["Bellowrage"] = {33, 54, 49}, --"Blasted Lands 54 49",
    ["Rumblerock"] = {40, 70, 45}, --"Burning Steppes 70 45",
    ["Dawnstrider"] = {40, 53, 24}, --"Burning Steppes 53 24",
    ["Goldwell"] = {28, 53.9, 49.9}, --"Dun Morogh 53 49",
    ["Windrun"] = {34, 35.6, 68.8}, --"Eastern Plaguelands 35 68",
    ["Snowcrown"] = {34, 75.7, 54.5}, --"Eastern Plaguelands 75.7 54.5",
    ["Stormbrow"] = {37, 40, 63}, --"Elwynn Forest 40 63",
    ["Highpeak"] = {42, 50, 48}, --"Hinterlands 50 48",
    ["Silvervein"] = {29, 33, 46}, --"Loch Modan 33 46",
    ["Ironband"] = {32, 21, 79}, --"Searing Gorge 21 79",
    ["Obsidian"] = {35, 45, 41}, --"Silverpine Forest 45 41",
    ["Starglade"] = {38, 63, 22}, --"Stranglethorn Vale 63 22", -- Jungle 71 34
    ["Winterhoof"] = {38, 37, 39}, --"Stranglethorn Vale 37 79", -- Cape 39 72
    ["Graveborn"] = {43, 61, 53}, --"Tirisfal Glades 61 53",
    ["Moonstrike"] = {50, 69, 73}, --"Western Plaguelands 69 73",
    ["Meadowrun"] = {50, 63.5, 36.2}, --"Western Plaguelands 63 36",
    ["Skychaser"] = {49, 56, 47}, --"Westfall 56 47"
  },
  ["Northrend"] = {
    ["Arp"] = {65, 57, 44}, --"Borean Tundra 57 44",
    ["Northal"] = {65, 34, 34}, --"Borean Tundra 34 34",
    ["Pamuya"] = {65, 43, 50}, --"Borean Tundra 43 50",
    ["Sardis"] = {65, 59, 66}, --"Borean Tundra 59 66",
    ["Morthie"] = {68, 30, 56}, --"Dragonblight 30 56",
    ["Skywarden"] = {68, 35, 48}, --"Dragonblight 35 48",
    ["Thoim"] = {68, 49, 78}, --"Dragonblight 49 78",
    ["Beldak"] = {69, 61, 28}, --"Grizzly Hills 61 28",
    ["Lunaro"] = {69, 81, 37}, --"Grizzly Hills 81 37",
    ["Whurain"] = {69, 64, 47}, --"Grizzly Hills 64 47",
    ["Bluewolf"] = {74, 49, 14}, --"Wintergrasp 49 14",
    ["Sandrene"] = {72, 50, 64}, --"Sholazar Basin 50 64",
    ["Wanikaya"] = {72, 64, 49}, --"Sholazar Basin 64 49",
    ["Fargal"] = {73, 29, 74}, --"Storm Peaks 29 74",
    ["Graymane"] = {73, 41, 85}, --"Storm Peaks 41 85",
    ["Muraco"] = {73, 64, 51}, --"Storm Peaks 64 51",
    ["Stonebeard"] = {73, 31, 38}, --"Storm Peaks 31 38",
    ["Tauros"] = {75, 59, 56}, --"Zul'Drak 59 56"
  }
}

local function QH_FindElders(elder_or_achievement, all_elders)
  local achievement_match, elder_match = false, false
  for achievement, eldrs in pairs(elders) do
    if not all_elders then
      if elder_or_achievement == string.upper(achievement) then achievement_match = true end
    end

    for elder, elder_loc in pairs(eldrs) do
      if not all_elders then
        if achievement_match then -- just add it
          local locz, locx, locy = unpack(elder_loc)
          QH_FindCoord(locx, locy, locz, elder)
        elseif elder_or_achievement == string.upper(elder) then -- We have input and it's not an achievement, so it must be an elder.
          elder_match = true
          local locz, locx, locy = unpack(elder_loc)
          QH_FindCoord(locx, locy, locz, elder)
          break -- We've found him or her.
        end -- No need for else here. We alread know we don't need everything so we either have an achievement or we have an elder.
      else -- We came in without an input, therefore we add all.
        local locz, locx, locy = unpack(elder_loc)
        QH_FindCoord(locx, locy, locz, elder)
      end
    end

    if achievement_match or elder_match then break end -- We've done our match.
  end
end

function QH_FindName(name)
  local locd = name:match("^loc (.+)")
  local elder_loc
  
  if not locd then
    if name:find("^elders?") then
      elder_loc = name:match("elders? (.+)")
      if not elder_loc then elder_loc = true end
    end
  end

  if locd then
    QH_FindLoc(locd)
  elseif elder_loc then
    if elder_loc == true then QH_FindElders(nil, true)
    else QH_FindElders(string.upper(elder_loc))
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
        if dbi.loc.p == 26 then dbi.loc.p = 48 end
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
