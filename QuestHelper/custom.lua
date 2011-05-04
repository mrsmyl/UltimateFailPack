QuestHelper_File["custom.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["custom.lua"] = GetTime()

local search_frame = CreateFrame("Button", nil, UIParent)
search_frame.text = search_frame:CreateFontString()
search_frame.text:SetFont(QuestHelper.font.sans, 15)
search_frame.text:SetTextColor(1, 1, 1)
search_frame.text:SetJustifyH("CENTER")
search_frame.text:SetJustifyV("MIDDLE")
search_frame.text:SetDrawLayer("OVERLAY")
search_frame.text:SetAllPoints()
search_frame.text:Show()
search_frame.background = search_frame:CreateTexture()
search_frame.background:SetTexture(0, 0, 0, 0.5)
search_frame.background:SetDrawLayer("BACKGROUND")
search_frame.background:SetAllPoints()
search_frame.background:Show()
search_frame:SetPoint("CENTER", UIParent, "CENTER")
search_frame:Hide()

search_frame.results = {}

function search_frame:SetText(text)
  self.text:SetText(text)
  self:SetWidth(self.text:GetWidth()+10)
  self:SetHeight(self.text:GetHeight()+10)
end

function search_frame:OnUpdate()
  if self.routine and coroutine.status(self.routine) ~= "dead" then
    local no_error, display = coroutine.resume(self.routine, self, self.query)
    if no_error then
      self:SetText(display)
    else
      QuestHelper:TextOut("Searching co-routine just exploded: "..display)
    end
  else
    self:ShowResults()
    self.routine = nil
    QH_Hook(self, "OnUpdate", nil)
    self:Hide()
  end
end

function QuestHelper:PerformCustomSearch(func)
  if not search_frame:GetScript("OnUpdate") then
    search_frame:Show()
    QH_Hook(search_frame, "OnUpdate", func)
  end
end

function QuestHelper:StopCustomSearch()
  if not search_frame.routine then
    search_frame:Hide()
    QH_Hook(search_frame, "OnUpdate", nil)
  end
end

  
do return end

-- This next bit of stuff is for fuzzy string comarisons.


local row, prow = {}, {}

local difftable = {}

for i = 65,90 do
  local a = {}
  difftable[i-64] = a
  for j = 65,90 do
    a[j-64] = i==j and 0 or 1
  end
end

local function setgroup(a, w)
  for i = 1,string.len(a)-1 do
    for j = i+1,string.len(a) do
      local c1, c2 = string.byte(a,i)-64, string.byte(a,j)-64
      
      difftable[c1][c2] = math.min(w, difftable[c1][c2])
      difftable[c2][c1] = math.min(w, difftable[c2][c1])
    end
  end
end

-- Characters that sound similar. At least in my opinion.
setgroup("BCDFGHJKLMNPQRSTVWXZ", 0.9)
setgroup("AEIOUY", 0.6)
setgroup("TD", 0.6)
setgroup("CKQ", 0.4)
setgroup("MN", 0.4)
setgroup("EIY", 0.3)
setgroup("UO", 0.2)
setgroup("SZ", 0.6)

local function diffness(a, b)
  if a >= 65 and a <=90 then
    if b >= 65 and b <= 90 then
      return difftable[a-64][b-64]
    else
      return 1
    end
  elseif b >= 65 and b <= 90 then
    return 1
  else
    return 0
  end
end

local function fuzzyCompare(a, b)
  local m, n = string.len(a), string.len(b)
  
  if n == 0 or m == 0 then
    return n == m and 0 or 1
  end
  
  for j = 1,n+1 do
    row[j] = j-1
  end
  
  for i = 1,m do
    row, prow = prow, row
    row[1] = i
    
    for j = 1,n do
      row[j+1] = math.min(prow[j+1]+1, row[j]+.4, prow[j]+diffness(string.byte(a,i), string.byte(b,j)))
    end
  end
  
  return row[n+1]/math.max(n,m)
end

function QuestHelper:ToggleUserObjective(cat, what)
  local objective = self:GetObjective(cat, what)
  
  if self.user_objectives[objective] then
    self:TextOut(QHFormat("REMOVED_OBJ", self.user_objectives[objective]))
    self:RemoveObjectiveWatch(objective, self.user_objectives[objective])
    self.user_objectives[objective] = nil
  elseif objective:Known() then
    local name
    if cat == "loc" then
      local _, _, i, x, y = string.find(what, "^(%d+),([%d%.]+),([%d%.]+)$")
      name = QHFormat("USER_OBJ", self:HighlightText(QuestHelper_NameLookup[tonumber(i)])..": "..self:HighlightText(x*100)..", "..self:HighlightText(y*100))
    else
      name = QHFormat("USER_OBJ", self:HighlightText(string.gsub(cat, "^(.)", string.upper))..": "..self:HighlightText(what))
    end
    
    objective.priority = 1
    self.user_objectives[objective] = name
    self:AddObjectiveWatch(objective, name)
    
    self:TextOut(QHFormat("CREATED_OBJ", name))
  else
    self:TextOut(QHText("UNKNOWN_OBJ"))
  end
end

function search_frame:CreateResultItem(r, menu)
  local item
  
  if r.cat == "loc" then
    local _, _, i, x, y = string.find(r.what, "^(%d+),([%d%.]+),([%d%.]+)$")
    item = QuestHelper:CreateMenuItem(menu, QuestHelper_NameLookup[tonumber(i)]..": "..(x*100)..", "..(y*100).." ["..QuestHelper:PercentString(1-r.w).."]")
    item:AddTexture(QuestHelper:CreateIconTexture(item, 6), true)
  else
    item = QuestHelper:CreateMenuItem(menu, r.what .. " ["..QuestHelper:PercentString(1-r.w).."]")
    item:AddTexture(QuestHelper:CreateIconTexture(item, (r.cat == "monster" and 1) or 2), true)
  end
  
  item:SetFunction(QuestHelper.ToggleUserObjective, QuestHelper, r.cat, r.what)
  
  return item
end

function search_frame:ShowResults()
  local menu = QuestHelper:CreateMenu()
  QuestHelper:CreateMenuTitle(menu, QHText("RESULTS_TITLE"))
  
  if #self.results == 0 then
    QuestHelper:CreateMenuItem(menu, QHText("NO_RESULTS"))
  else
    for i, r in ipairs(self.results) do
      self:CreateResultItem(r, menu)
    end
  end
  
  menu:ShowAtCursor()
  self:ClearResults()
end

function search_frame:ClearResults()
  while #self.results > 0 do
    QuestHelper:ReleaseTable(table.remove(self.results))
  end
end

function search_frame:AddResult(cat, what, w)
  local r = self.results
  local mn, mx = 1, #r+1
  
  while mn ~= mx do
    local m = math.floor((mn+mx)*0.5)
    
    if r[m].w < w then
      mn = m+1
    else
      mx = m
    end
  end
  
  if mn <= 20 then
    if r[mn] and r[mn].cat == cat and r[mn].what == what then
      -- Don't add the same item twice.
      -- Might miss it if multiple items have the same score. Dont care.
      return
    end
    
    if #r >= 20 then
      QuestHelper:ReleaseTable(table.remove(r, 20))
    end
    
    local obj = QuestHelper:CreateTable()
    obj.cat = cat
    obj.what = what
    obj.w = w
    table.insert(r, mn, obj)
  end
end

local function searchNPC(input, yield_countdown, yield_countdown_max)
  local list = QuestHelper_Objectives_Local["monster"]
  if list then 
    for n in pairs(list) do
      self:AddResult("monster", n, fuzzyCompare(input, string.upper(n)))
      yield_countdown = yield_countdown - 1
      if yield_countdown == 0 then
        yield_countdown = yield_countdown_max
        coroutine.yield(QHFormat("SEARCHING_STATE", QHFormat("SEARCHING_LOCAL", QHText("SEARCHING_NPCS"))))
      end
    end 
  end
    
  list = QuestHelper_StaticData[QuestHelper.locale].objective
  list = list and list.monster
  if list then 
    for n in pairs(list) do
      self:AddResult("monster", n, fuzzyCompare(input, string.upper(n)))
      yield_countdown = yield_countdown - 1
      if yield_countdown == 0 then
        yield_countdown = yield_countdown_max
        coroutine.yield(QHFormat("SEARCHING_STATE", QHFormat("SEARCHING_STATIC", QHText("SEARCHING_NPCS"))))
      end
    end 
  end

  return yield_countdown
end

local elders = {
  ["Alliance"] = {
    ["Bladeswift"] = "Darnassus 39 32",
    ["Bronzebeard"] = "Ironforge 29 16",
    ["Hammershout"] = "Elwynn Forest 34 50"
  },
  ["Horde"] = {
    ["Darkhorn"] = "Orgrimmar 52 60",
    ["Wheathoof"] = "Thunder Bluff 72 33",
    ["Darkcore"] = "Undercity 67 38"
  },
  ["Kalimdor"] = {
    ["Riversong"] = "Ashenvale 35 48",
    ["Skygleam"] = "Azshara 64 79",
    ["High Mountain"] = "Southern Barrens 41 47", -- 41.5 47.5
    ["Moonwarden"] = "Northern Barrens 48 59", -- 48.5 59.2
    ["Windtotem"] = "Northern Barrens 68 69",
    ["Starweave"] = "Darkshore 49 19", -- 49.5 19.0
    ["Runetotem"] = "Durotar 54 44",
    ["Nightwind"] = "Felwood 37 52",
    ["Grimtotem"] = "Feralas 76 37",
    ["Mistwalker"] = "Feralas 62 31",
    ["Bloodhoof"] = "Mulgore 48 53",
    ["Bladesing"] = "Silithus 53 35",
    ["Primestone"] = "Silithus 30 13", -- 30.7 13.3
    ["Dreamseer"] = "Tanaris 50 28",
    ["Ragetotem"] = "Tanaris 36 80",
    ["Bladeleaf"] = "Teldrassil 57 53",
    ["Skyseer"] = "Thousand Needles 45 50",
    ["Morningdew"] = "Thousand Needles 77 75", -- 77.0 75.6
    ["Thunderhorn"] = "Un'Goro Crater 51 75",
    ["Brightspear"] = "Winterspring 53 56", -- 53.0 56.7
    ["Stonespire"] = "Winterspring 60 50", -- 60.0 50.0
  },
  ["Eastern Kingdoms"] = {
    ["Bellowrage"] = "Blasted Lands 54 49",
    ["Rumblerock"] = "Burning Steppes 70 45",
    ["Dawnstrider"] = "Burning Steppes 53 24",
    ["Goldwell"] = "Dun Morogh 53 49",
    ["Windrun"] = "Eastern Plaguelands 35 68",
    ["Snowcrown"] = "Eastern Plaguelands 75 54",
    ["Stormbrow"] = "Elwynn Forest 40 63",
    ["Highpeak"] = "Hinterlands 50 48",
    ["Silvervein"] = "Loch Modan 33 46",
    ["Ironband"] = "Searing Gorge 21 79",
    ["Obsidian"] = "Silverpine Forest 45 41",
    ["Starglade"] = "Stranglethorn Vale 63 22", -- Jungle 71 34
    ["Winterhoof"] = "Stranglethorn Vale 37 79", -- Cape 39 72
    ["Graveborn"] = "Tirisfal Glades 61 53",
    ["Moonstrike"] = "Western Plaguelands 69 73",
    ["Meadowrun"] = "Western Plaguelands 63 36",
    ["Skychaser"] = "Westfall 56 47"
  },
  ["Northrend"] = {
    ["Arp"] = "Borean Tundra 57 44",
    ["Northal"] = "Borean Tundra 34 34",
    ["Pamuya"] = "Borean Tundra 43 50",
    ["Sardis"] = "Borean Tundra 59 66",
    ["Morthie"] = "Dragonblight 30 56",
    ["Skywarden"] = "Dragonblight 35 48",
    ["Thoim"] = "Dragonblight 49 78",
    ["Beldak"] = "Grizzly Hills 61 28",
    ["Lunaro"] = "Grizzly Hills 81 37",
    ["Whurain"] = "Grizzly Hills 64 47",
    ["Bluewolf"] = "Wintergrasp 49 14",
    ["Sandrene"] = "Sholazar Basin 50 64",
    ["Wanikaya"] = "Sholazar Basin 64 49",
    ["Fargal"] = "Storm Peaks 29 74",
    ["Graymane"] = "Storm Peaks 41 85",
    ["Muraco"] = "Storm Peaks 64 51",
    ["Stonebeard"] = "Storm Peaks 31 38",
    ["Tauros"] = "Zul'Drak 59 56"
  }
}

local function searchItem(input, yield_countdown, yield_countdown_max)
  local list = QuestHelper_Objectives_Local["item"]
  if list then 
    for n in pairs(list) do
      self:AddResult("item", n, fuzzyCompare(input, string.upper(n)))
      yield_countdown = yield_countdown - 1
      if yield_countdown == 0 then
        yield_countdown = yield_countdown_max
        coroutine.yield(QHFormat("SEARCHING_STATE", QHFormat("SEARCHING_LOCAL", QHText("SEARCHING_ITEMS"))))
      end
    end 
  end
    
  list = QuestHelper_StaticData[QuestHelper.locale].objective
  list = list and list.item
  if list then 
    for n in pairs(list) do
      self:AddResult("item", n, fuzzyCompare(input, string.upper(n)))
      yield_countdown = yield_countdown - 1
      if yield_countdown == 0 then
        yield_countdown = yield_countdown_max
        coroutine.yield(QHFormat("SEARCHING_STATE", QHFormat("SEARCHING_STATIC", QHText("SEARCHING_ITEMS"))))
      end
    end 
  end

  return yield_countdown
end

local function searchLoc(input, yield_countdown, yield_countdown_max)
  local _, _, region, x, y = string.find(input, "^%s*([^%d%.]-)%s*([%d%.]+)%s*[,;:]?%s*([%d%.]+)%s*$")
    
  if region then
    x, y = tonumber(x), tonumber(y)
    if x and y then
      x, y = x*0.01, y*0.01
        
      if region == "" then
        self:AddResult("loc", string.format("%d,%.3f,%.3f", QuestHelper.i, x, y), 0)
      else
        for i, name in pairs(QuestHelper_NameLookup) do
          self:AddResult("loc", string.format("%d,%.3f,%.3f", i, x, y), fuzzyCompare(region, string.upper(name)))
          yield_countdown = yield_countdown - 1
          if yield_countdown == 0 then
            yield_countdown = yield_countdown_max
            coroutine.yield(QHFormat("SEARCHING_STATE", QHText("SEARCHING_ZONES")))
          end
        end
      end
    end
  end

  return yield_countdown
end

local function searchElders(input, yield_countdown, yield_countdown_max)
  local yc = yield_countdown
  local achievement_match, elder_match = false, false
  for achievement, eldrs in pairs(elders) do
    if input and input ~= "" then
      if input == string.upper(achievement) then achievement_match = true end
    end

    for elder, elder_loc in pairs(eldrs) do
      if input and input ~= "" then
        if achievement_match then -- just add it
          yc = searchLoc(string.upper(elder_loc), yc, yield_countdown_max)
        elseif input == string.upper(elder) then -- We have input and it's not an achievement, so it must be an elder.
          elder_match = true
          yc = searchLoc(string.upper(elder_loc), yc, yield_countdown_max)
          break -- We've found him or her.
        end -- No need for else here. We've got input so we either have an achievement or we have an elder.
      else -- We came in without an input, therefore we add all.
        yc = searchLoc(string.upper(elder_loc), yc, yield_countdown_max)
      end
    end

    if achievement_match or elder_match then break end -- We've done our match.
  end

  return yc
end

function search_frame:SearchRoutine(input)
  if input == "" then
    for obj in pairs(QuestHelper.user_objectives) do
      self:AddResult(obj.cat, obj.obj, 0)
    end
    return
  end
  
  input = string.upper(input)
  local _, _, command, argument = string.find(input, "^%s*([^%s]-)%s+(.-)%s*$")
  
  local search_item, search_npc, search_loc, search_elders = false, false, false, false
  
  local yield_countdown_max = math.max(1, math.floor(2000/string.len(input)+0.5))
  local yield_countdown = yield_countdown_max

  if command and argument then
    if command == "ITEM" then
      searchItem(argument, yield_countdown, yield_countdown_max)
    elseif command == "NPC" or command == "MONSTER" then
      searchNPC(argument, yield_countdown, yield_countdown_max)
    elseif command == "LOCATION" or command == "LOC" then
      searchLoc(argument, yield_countdown, yield_countdown_max)
    elseif command == "ELDER" or command == "ELDERS" then
      searchElders(argument, yield_countdown, yield_countdown_max)
    else
      yield_countdown = searchItem(input, yield_countdown, yield_countdown_max)
      yield_countdown = searchNPC(input, yield_countdown, yield_countdown_max)
      searchLoc(input, yield_countdown, yield_countdown_max)
    end
  else
    yield_countdown = searchItem(input, yield_countdown, yield_countdown_max)
    yield_countdown = searchNPC(input, yield_countdown, yield_countdown_max)
    searchLoc(input, yield_countdown, yield_countdown_max)
  end

  return QHText("SEARCHING_DONE")
end

local function ReturnArgument(x)
  return x
end

function search_frame:PerformSearch(input)
  QuestHelper:TextOut("/qh find is currently disabled. Sorry! I'll get it back in once I can.")
  do return end
  if not self.routine then
    self.query = string.gsub(input, "|c.-|H.-|h%[(.-)%]|h|r", ReturnArgument)
    self.routine = coroutine.create(self.SearchRoutine)
    self:Show()
    QH_Hook(self, "OnUpdate", self.OnUpdate)
  end
end

function QuestHelper:PerformSearch(query)
  search_frame:PerformSearch(query)
end

SLASH_QuestHelperFind1 = "/qhfind"
SLASH_QuestHelperFind2 = "/find"
SlashCmdList["QuestHelperFind"] = function (text) QuestHelper:PerformSearch(text) end
