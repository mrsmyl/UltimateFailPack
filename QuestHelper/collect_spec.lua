QuestHelper_File["collect_spec.lua"] = "4.0.6.161r"
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
  ["WARRIOR"] = "W"
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
  ["Goblin"] = "L"
  -- lol i spelled nub
}

local function GetSpecBolus()
  local _, id = UnitClass("player")
  local level = UnitLevel("player")
  local _, race = UnitRace("player")
  
  --[[ assert(racelookup[race]) ]]
  
  --local bso = Bitstream.Output(8)
  local talents = {}
  
  local points = (GetUnspentTalentPoints() or 0)
  local talents_learned = false
  for t = 1, GetNumTalentTabs() do -- come on. Is this ever not going to be 3? Seriously? Perhaps someday, but not as of Cat.
    local _, tab, _, _, p, _, _, yn = GetTalentTabInfo(t)
    p = p or 0
    if not yn or p == 0 then talents[tab] = 0 -- No point if locked or no points spent (assuming unlocked even if all possible points spent [available and/or max points for tab]), so we set it to a scalar value of 0, to tell the compiler that it can just assume that everything is 0. I suppose I should collect all talents, but meh.
    else
      talents_learned = true
      talents[tab] = {}
      for ta = 1, GetNumTalents(t) do
        local talent, _, _, _, rank, _ = GetTalentInfo(t, ta)
        if rank > 0 then talents[tab][talent] = rank end -- Let's limit to actual talents
      end
    end
  end

  local spec = {}
  if talents_learned then spec.talents = talents -- If any talent tree has a talent that has been learned, then keep our work.
  else spec.talents = 0 -- Otherwise, ditch our work to save space.
  end
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
