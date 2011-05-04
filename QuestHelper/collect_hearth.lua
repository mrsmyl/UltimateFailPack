QuestHelper_File["collect_hearth.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["collect_hearth.lua"] = GetTime()

local debug_output = false
if QuestHelper_File["collect_hearth.lua"] == "Development Version" then debug_output = true end

local QHCZ

local GetLoc
local Merger

local last_hearth = 0

local function OnZoneChanged()
  local start, cd, _ = GetItemCooldown(6948)
  if last_hearth + 1800 < GetTime() and cd == 1800 then
    last_hearth = start
    local home = GetBindLocation()
    if not QHCZ[home] then QHCZ[home] = {} end
    QHCZ.Landing = GetLoc()
  end
end

local GetMonsterType

local function OnConfirmBinder(...)
  local new_home = ...
  if not QHCZ[new_home] then QHCZ[new_home] = {} end
  if not QHCZ[new_home].Innkeeper then QHCZ[new_home].Innkeeper = {} end
  QHCZ[new_home].Innkeeper.ID = GetMonsterType(UnitGUID("target"))
end

function QH_Collect_Hearth_Init(QHCData, API)
  if not QHCData.hearth then QHCData.hearth = {} end
  QHCZ = QHCData.hearth
  
  QH_Event("ZONE_CHANGED", OnZoneChanged)
  QH_Event("ZONE_CHANGED_INDOORS", OnZoneChanged)
  QH_Event("ZONE_CHANGED_NEW_AREA", OnZoneChanged)
  QH_Event("CONFIRM_BINDER", OnConfirmBinder)
  
  --API.Registrar_OnUpdateHook(OnUpdate)
  
  GetLoc = API.Callback_LocationBolusCurrent
  QuestHelper: Assert(GetLoc)
  
  Merger = API.Utility_Merger
  QuestHelper: Assert(Merger)

  GetMonsterType = API.Utility_GetMonsterType
  QuestHelper: Assert(GetMonsterType)
end
