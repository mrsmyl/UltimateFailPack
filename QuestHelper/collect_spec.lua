
local GetTime = QuestHelper_GetTime

QuestHelper_File["collect_spec.lua"] = "5.0.5.267r"
QuestHelper_Loadtime["collect_spec.lua"] = GetTime()

local Bitstream

local classlookup = {
  ["DEATHKNIGHT"] = "K",
  ["DRUID"] = "D",
  ["HUNTER"] = "H",
  ["MAGE"] = "M",
  ["PALADIN"] = "N",
  ["PRIEST"] = "P",
  ["ROGUE"] = "R",
  ["SHAMAN"] = "S",
  ["WARLOCK"] = "L",
  ["WARRIOR"] = "W",
  ["MONK"] = "O"
};

local racelookup = {
  ["Draenei"] = "R",
  ["Gnome"] = "G",
  ["Dwarf"] = "D",
  ["Human"] = "H",
  ["NightElf"] = "E",
  ["Worgen"] = "W",
  
  ["Orc"] = "O",
  ["Troll"] = "T",
  ["Tauren"] = "N",
  ["Undead"] = "U",
  ["BloodElf"] = "B",
  ["Goblin"] = "L",
  ["Pandaren"] = "P"
  -- lol i spelled nub
}

local function GetSpecBolus()
  local _, id = UnitClass("player")
  local level = UnitLevel("player")
  local _, race = UnitRace("player")
  
  --[[ assert(racelookup[race]) ]]
 --[[ 
  --local bso = Bitstream.Output(8)
  local talents = {}
  
  --local points = (GetUnspentTalentPoints() or 0)
  local talents_learned = false
  for t = 1, GetNumTalentTabs() do -- come on. Is this ever not going to be 3? Seriously? Perhaps someday, but not as of Cat.
    local _, tab, _, _, p, _, _, yn = GetTalentTabInfo(t)
    p = p or 0
    talents_learned = true
    talents[tab] = {}
    for ta = 1, GetNumTalents(t) do
      local talent, _, _, _, rank, _ = GetTalentInfo(t, ta)
      if talent then talents[tab][talent] = rank end
    end
  end
]]
  local spec = {}
 -- spec.talents = talents
  spec.class = id
  spec.race = race
  spec.level = level
  --return string.format("(2%s,%s,%02d)", classlookup[id], racelookup[race] or "", level) .. talstr
  return spec
end

function QH_Collect_Spec_Init(_, API)
  Bitstream = API.Utility_Bitstream
  QuestHelper: Assert(Bitstream)
  
  API.Utility_GetSpecBolus = GetSpecBolus
end
