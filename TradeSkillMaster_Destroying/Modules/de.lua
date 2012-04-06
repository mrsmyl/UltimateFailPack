-- loads the localization table --
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying") 

-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local de = TSM:NewModule("de", "AceEvent-3.0", "AceHook-3.0")--TSM:NewModule("GUI", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries


de.dObj = {
    bag = 0,
    slot = 1,
    Item = nil,
}

local function canDE(id)
    _,_,q = GetItemInfo(id)
   
    if id and IsEquippableItem(id) and ( q>= 2 and q <= 4 ) and not TSM.db.global.safeList[id] then
        return true
    end
    return false
end

local bagsNum = 4
function de:searchAndDestroy(pre) 
    for bag = de.dObj.bag, bagsNum do --bags		
        for slot = de.dObj.slot, GetContainerNumSlots(bag) do
            id = GetContainerItemID(bag, slot)
            if  pre == nil or (bag ~= pre.bag or slot ~= pre.slot) then 
                if id and canDE(id) then
                    de.dObj.bag  = bag
                    de.dObj.slot = slot
                    return {bag = bag, slot = slot}
                end
            end
        end--end slots
    end--end bags
    
    de.dObj.bag  = 0
    de.dObj.slot = 1
end 