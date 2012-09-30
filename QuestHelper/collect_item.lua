
local GetTime = QuestHelper_GetTime

QuestHelper_File["collect_item.lua"] = "5.0.5.267r"
QuestHelper_Loadtime["collect_item.lua"] = GetTime()

local debug_output = false
if QuestHelper_File["collect_item.lua"] == "Development Version" then debug_output = true end

local GetItemType

local QHCI

-- We could probably snag data from other locations as well, but at the moment, we're not.
local function Tooltipy(self)
  if not self.GetItem then return end -- ughhhh, inventoryonpar
  
  local _, ilink = self:GetItem()
  if not ilink then return end
  
  local id = GetItemType(ilink)
  
  if not QHCI[id] then QHCI[id] = {} end
  local item = QHCI[id]
  
  local name, _, quality, ilvl, min, itype, isubtype, _, equiploc, _ = GetItemInfo(id)
  
  if name then
    item.name = name
    item.quality = quality
    item.ilevel = ilvl
    item.minlevel = min
    item.type = itype -- Was originally type/subtype, but we can do that during processing. Might want to eventually have it separated, so we separate here.
    item.subtype = isubtype
    
    local loc = string.match(equiploc, "INVTYPE_(.*)")
    if loc then
      item.equiplocation = loc
    else
      item.equiplocation = nil
    end
    
    local lines = GameTooltip:NumLines()
    local openable = false
    for i = 2, lines do
      if _G["GameTooltipTextLeft" .. tostring(i)]:GetText() == ITEM_OPENABLE then
        openable = true
      end
    end
    
    openable = "open_" .. (openable and "yes" or "no")
    item[openable] = (item[openable] or 0) + 1 -- so we're going to add a lot to this if the user keeps whipping their mouse over it. I'll live.
  end
end

function QH_Collect_Item_FactionChange(QHCData)
  if not QHCData.item then QHCData.item = {} end
  QHCI = QHCData.item
end

function QH_Collect_Item_Init(QHCData, API)
  QH_Collect_Item_FactionChange(QHCData)
  API.Registrar_TooltipHook(Tooltipy)
  
  GetItemType = API.Utility_GetItemType
  QuestHelper: Assert(GetItemType)
end
