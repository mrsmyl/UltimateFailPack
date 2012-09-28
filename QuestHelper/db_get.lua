
local GetTime = QuestHelper_GetTime

QuestHelper_File["db_get.lua"] = "5.0.5.262r"
QuestHelper_Loadtime["db_get.lua"] = GetTime()

local dev_mode = (QuestHelper_File["db_get.lua"] == "Development Version")
QHDB_Export = {}
local export = false
-- yoink
--[[
local QHDB_temp = QHDB
QHDB = nil
local QHDB = QHDB_temp]]
QuestHelper: Assert(#QHDB == 4, "Please make sure that you are loading a locale.")

local weak_v = { __mode = 'v' }
local weak_k = { __mode = 'k' }

local cache = {}

local frequencies = setmetatable({}, weak_k)

-- guhhh just want this to work
local freq_group = setmetatable({}, weak_k)
local freq_id = setmetatable({}, weak_k)

local function DBC_Get(group, id)
  if not cache[group] then return end
  return cache[group][id]
end

local function DBC_Put(group, id, item)
  if not cache[group] then cache[group] = setmetatable({}, weak_v) end
  QuestHelper: Assert(not cache[group][id])
  cache[group][id] = item
  
  --DB_how_many_are_used()
end

local function mark(tab, tomark)
  for k, v in pairs(tab) do
    if k ~= "__owner" and type(v) == "table" then
      mark(v, tomark)
    end
  end
  tab.__owner = tomark
end

local function read_adaptint(data, offset)
  local stx = 0
  local acu = 1
  while true do
    local v = strbyte(data, offset)
    QuestHelper: Assert(v, string.format("%d %d", #data, offset))
    stx = stx + acu * math.floor(v / 2)
    offset = offset + 1
    acu = acu * 128
    if mod(v, 2) == 0 then break end
  end
  return stx, offset
end

local function search_index(index, data, item)
  --[[Header format:

    Itemid (0 for endnode)
    Offset
    Length
    Rightlink]]
  
  local cofs = 1
  --[[ assert(index and type(index) == "string") ]]
  --[[ assert(data and type(data) == "string") ]]
  
  while true do
    local idx, ofs, len, rlink
    idx, cofs = read_adaptint(index, cofs)
    if idx == 0 then return end
    ofs, cofs = read_adaptint(index, cofs)
    len, cofs = read_adaptint(index, cofs)
    rlink, cofs = read_adaptint(index, cofs)
    
    if idx == item then
      return strsub(data, ofs, ofs + len)
    end
    
    if idx < item then cofs = cofs + rlink end
  end
end

local initted = false
function DB_Init()
  QuestHelper: Assert(not initted)
  for _, db in ipairs(QHDB) do
    for _, v in pairs(db) do
      --print("db", not not v.__dictionary, not not v.__tokens)
      if v.__dictionary and v.__tokens then
        local redictix = v.__dictionary
        if not redictix:find("\"") then redictix = redictix .. "\"" end
        if not redictix:find(",") then redictix = redictix .. "," end
        if not redictix:find("\\") then redictix = redictix .. "\\" end
        local tokens = loadstring("return {" .. QH_LZW_Decompress_Dicts_Arghhacky(v.__tokens, redictix) .. "}")()
        QuestHelper: Assert(tokens)
        
        local _, _, prep = QH_LZW_Prepare_Arghhacky(v.__dictionary, tokens)
        QuestHelper: Assert(prep)
        
        QuestHelper: Assert(type(prep) == "table")
        
        v.__tokens = prep
      end
    end
  end
  initted = true
  QH_UpdateQuests() -- just in case it's been waiting on us (it has almost certainly been waiting on us)
end

function DB_Ready()
  return initted
end

function DB_HasItem(group, id)
  QuestHelper: Assert(initted)

  if group == "quest" then
    if type(id) == "number" and id > 0 then return true
    else return false
    end
  end
  
  for _, db in ipairs(QHDB) do
    if db[group] then
      if db[group][id] then
        return true
      end
      
      if type(id) == "number" and id > 0 and db[group].__serialize_index and db[group].__serialize_data and search_index(db[group].__serialize_index, db[group].__serialize_data, id) then
        return true
      end
    end
  end
  
  return false
end
local function GetBlizzardQuestInfoFrameMainLoop(qid)
	local POIFrame, questFrame
	QuestMapUpdateAllQuests()
	QuestPOIUpdateIcons()
	WorldMapFrame_UpdateQuests()

	for i = 1, MAX_NUM_QUESTS do
		questFrame = _G["WorldMapQuestFrame" .. i]
		if questFrame then 
			if questFrame.questId == qid then
				POIFrame = questFrame.poiIcon
				break
			end
		end
	end

	return questFrame, POIFrame
end

local function GetBlizzardQuestInfoFrame(qid, map)
	if map then SetMapByID(map) end
	QuestMapUpdateAllQuests()
	QuestPOIUpdateIcons()
	WorldMapFrame_UpdateQuests()

	local POIFrame
	local questFrame
	local dLvl

	if map and GetNumDungeonMapLevels() > 0 then -- Suspicion is that each dungeon level has to be iterated.
		for i = 1, GetNumDungeonMapLevels() do
			SetDungeonMapLevel(i)
			questFrame, POIFrame = GetBlizzardQuestInfoFrameMainLoop(qid)
			if POIFrame then 
				dLvl = i
				break 
			end
		end
	else -- Only need to call once
		questFrame, POIFrame = GetBlizzardQuestInfoFrameMainLoop(qid)
	end

	return questFrame, POIFrame, dLvl or 0
end

local function GetBlizzardQuestInfo(qid)
	local questFrame, POIFrame, qdLvl = GetBlizzardQuestInfoFrame(qid)
	local mapId = GetCurrentMapAreaID()
	local c, z
	local dLvl = false
	local qMapId

	if GetNumDungeonMapLevels() > 0 then dLvl = GetCurrentMapDungeonLevel() end

	if not POIFrame then 
		-- Iterate over all maps to try and find it (we are of course assuming that the player has the quest, otherwise we will be SOL.
		local maps = QuestHelper.LibMapData:GetAllMapIDs()
		for _, map in pairs(maps) do
			if map >= 0 and not QuestHelper.LibMapData:IsContinentMap(map) then

				questFrame, POIFrame, qdLvl = GetBlizzardQuestInfoFrame(qid, map)

				if POIFrame then 
					qMapId = map
					break 
				end
			end
		end
		c, z = GetCurrentMapContinent(), GetCurrentMapZone()
		SetMapByID(mapId)
		if not POIFrame then return nil end -- At this point we either have the quest or we are SOL.
	else
		qMapId = mapId
		c, z = GetCurrentMapContinent(), GetCurrentMapZone()
	end

	local _, _, _, x, y = POIFrame:GetPoint()

	if not x or not y then return nil end

	local frame = WorldMapDetailFrame
	local width, height = frame:GetWidth(), frame:GetHeight()
	local wm_scale, poi_scale =  frame:GetScale(), POIFrame:GetScale()

	-- Convert from yards to %
	local cx = ((x / (wm_scale / poi_scale)) / width)
	local cy = ((-y / (wm_scale / poi_scale)) / height)


	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return nil end
	
	-- Now we want to convert to proper format for QH.
	-- Look at WoWPro:findBlizzCoords(qid) for remainder
	local _, contX, contY = QuestHelper.Astrolabe:GetAbsoluteContinentPosition(c, z, cx, cy)
	--contX, contY = contX / QuestHelper.Astrolabe:GetZoneWidth(c, 0), contY / QuestHelper.Astrolabe:GetZoneHeight(c, 0)

	local solid = { ["continent"] = c, contX - 10, contY - 10, contX + 10, contY - 10, contX + 10, contY + 10, contX - 10, contY + 10 }
	local ret = {}

	ret.solid = solid
	ret.criteria = {}

	local questIdx = GetQuestLogIndexByID(qid)
	local numCrit = GetNumQuestLeaderBoards(questIdx)
	local loc = { ["loc"] = { { ["p"] = qMapId, ["x"] = contX, ["y"] = contY} } }
	for i = 1, numCrit do
		table.insert(ret.criteria, loc)
	end

	ret.name = GetQuestLogTitle(questIdx)
	ret.Blizzard = true
	return ret
end

local function GetLightHeadedQuestInfo(qid)
	if not LightHeaded or type(LightHeaded) ~= "table" then return nil end -- LH not loaded

	local npcid, npcname, stype
	local coords = {}

	_, _, _, _, _, _, _, stype, npcname, npcid = LightHeaded:GetQuestInfo(qid)

	-- Note: If we want the quest giver, we need fields 5, 6 and 7 above, rather than what we have gotten.
	--
	if stype == "npc" then
		local data = LightHeaded:LoadNPCData(tonumber(npcid))
		if not data then return end -- LightHeaded has no clue about the given NPC, despite giving us the id.
		for zid,x,y in data:gmatch("([^,]+),([^,]+),([^:]+):") do
			table.insert(coords, {["p"] = zid, ["x"] = x, ["y"] = y})
		end
	end

	--can't return coordinates until we know more about what we are getting and then convert accordingly.
	for k, v in pairs(coords) do for k1, v1 in pairs(v) do print(k, k1, v1) end end
	--return coords
	return nil
end

local function GetSelfQuestInfo(qid)
	return nil
end

-- Returns x and y in yards relative to something... Continent?
local function GetQuestInfo(qid)
	assert(type(qid) == "number")
	local coords = GetSelfQuestInfo(qid)
	--if not coords then coords = GetLightHeadedQuestInfo(qid) end
	if not coords then 
		coords = GetBlizzardQuestInfo(qid) 
	end

	return coords -- Might still be nil, but if we don't have anything from Blizz, prolly nothing can be done.
end

function DB_GetItem(group, id, silent, register)
  QuestHelper: Assert(initted)

  QuestHelper: Assert(group, string.format("%s %s", tostring(group), tostring(id)))
  QuestHelper: Assert(id, string.format("%s %s", tostring(group), tostring(id)))
  local ite = DBC_Get(group, id)
  
  if not ite and group == "flightpaths" then return nil end

  if not ite and group == "quest" then
	  -- Loop over zones AND floors
	  -- see QuestRouterLite.lua for specific calls.
	  -- In the end, the item returned MUST be "formatted" the same as a true QHDB item.
	ite = GetQuestInfo(id)
  end
  
  if not ite then
    if type(id) == "string" then QuestHelper: Assert(not id:match("__.*")) end
    
    --QuestHelper:TextOut(string.format("%s %d", group, id))
    
    for _, db in ipairs(QHDB) do
      --print(db, db[group], db[group] and db[group][id], type(group), type(id))
      if db[group] then
        local dat
        if db[group][id] then
          dat = db[group][id]
        end
        
        --print(not dat, type(id), id, not not db[group].__serialize_index, not not db[group].__serialize_index)
        if not dat and type(id) == "number" and id > 0 and db[group].__serialize_index and db[group].__serialize_data then
          dat = search_index(db[group].__serialize_index, db[group].__serialize_data, id)
        end
        
        if dat then
          if not ite then ite = QuestHelper:CreateTable("db") end
          
          local srctab
          
          if type(dat) == "string" then
            QuestHelper: Assert(db[group].__tokens == nil or type(db[group].__tokens) == "table")
            srctab = loadstring("return {" .. (db[group].__prefix or "") .. QH_LZW_Decompress_Dicts_Prepared_Arghhacky(dat, db[group].__dictionary, nil, db[group].__tokens) .. (db[group].__suffix or "") .. "}")()
          elseif type(dat) == "table" then
            srctab = dat
          else
            QuestHelper: Assert()
          end
          
          for k, v in pairs(srctab) do
            QuestHelper: Assert(not ite[k] or k == "used")
            ite[k] = v
            if export then 
              if not QHDB_Export[group] then QHDB_Export[group] = {} end
	      if not QHDB_Export[group][id] then QHDB_Export[group][id] = {} end
              QHDB_Export[group][id][k] = v 
            end
          end
        end
      end
    end
    
    if ite then
      --print("marking", group, id, silent, register)
      mark(ite, ite)
      --print("done marking")
      
      DBC_Put(group, id, ite)
      
      freq_group[ite] = group
      freq_id[ite] = id
    else
      if not silent then
        QuestHelper:TextOut(string.format("Tried to get %s/%s, failed", tostring(group), tostring(id)))
      end
    end
  end
  
  if ite then
    frequencies[ite] = (frequencies[ite] or 0) + (register and 1 or 1000000000) -- effectively infinity
  end
 
  return ite
end

local function incinerate(ite, crunchy)
  if dev_mode then return end -- wellllp
  
  if not crunchy[ite] then
    crunchy[ite] = true
    
    for k, v in pairs(ite) do
      if type(k) == "table" then incinerate(k, crunchy) end
      if type(v) == "table" then incinerate(v, crunchy) end
    end
  end
end

function DB_ReleaseItem(ite)
  QuestHelper: Assert(ite)
  frequencies[ite] = frequencies[ite] - 1
  
  if frequencies[ite] == 0 then
    --print("incinerating", freq_group[ite], freq_id[ite])
    if cache[freq_group[ite]] then
      cache[freq_group[ite]][freq_id[ite]] = nil
    end
    freq_group[ite] = nil
    freq_id[ite] = nil
    
    local incin = QuestHelper:CreateTable("incinerate")
    incinerate(ite, incin)
    for k, _ in pairs(incin) do
      QuestHelper:ReleaseTable(k)
    end -- burn baby burn
    QuestHelper:ReleaseTable(incin)
  end
end

function DB_ListItems(group)
  local tab = {}
  for _, db in ipairs(QHDB) do
    if db[group] then
      QuestHelper: Assert(not db.__serialize_index and not db.__serialize_data)
      for k, _ in pairs(db[group]) do
        if type(k) ~= "string" or not k:match("__.*") then
          tab[k] = true
        end
      end
    end
  end
  
  local rv = {}
  for k, _ in pairs(tab) do
    table.insert(rv, k)
  end
  
  return rv
end

function DB_how_many_are_used()
  local count = 0
  for k, v in pairs(cache) do
    for k2, v2 in pairs(v) do
      count = count + 1
    end
  end
  print(count)
end

function DB_DumpItems()
  local dt = {}
  for k, v in pairs(freq_group) do
    dt[string.format("%s/%s", freq_group[k], tostring(freq_id[k]))] = true
  end
  return dt
end
