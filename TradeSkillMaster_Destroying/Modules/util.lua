-- loads the localization table --
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying") 

-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local util = TSM:NewModule("util", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

--delay frame--
local delay = CreateFrame("Frame") 
delay.mats = {}

local currentItem
local mergeTable={}

local DestroyTable = {}

---------------------------------------------------------
--
--searchAndDestroy and newSearch handle searching the users bags
--and returning a value to Sapu's super cool button.
--
--current is the item that was selected in the dropdown
--
---------------------------------------------------------
function util:searchAndDestroy(current,previous, mats)

	destroyTable,mergeTable,total = util:newSearch(current, previous,mats) 

	_,previousSize,_=GetContainerItemInfo(previous.bag, previous.slot)

	if #destroyTable >0 then
		DestroyTable = destroyTable[1]	
	elseif  previousSize ~= nil and previousSize>=5 then --to take care of Sapu's "potentail bug"
		if current == GetContainerItemID(previous.bag, previous.slot) or current == -1 then DestroyTable = previous end 
	end
    return total
end--end searchAndDestroy

function util:getLocations() return DestroyTable end

function util:newSearch(current,previous,mats)
	local bagsNum = 4
	local total=0
    local totalOverAll = 0
	local destroyTable={}
	local stackSize
	local itemId
	local len

	currentItem = current --need to save this so I don't lose it when I call delay	

	if (current == 1) then
		len = #mats
	else
		current = current-1
		len = current
	end 
	
	for i=current, len do
		mergeTable={} --need to reset otherwise WOW will freak out, and try to merge stacks forever
		itemId = mats[i] 	
		for bagId=0,bagsNum do --bags		
			for slotId = 1,GetContainerNumSlots(bagId) do
				if itemId == GetContainerItemID(bagId, slotId) then
					_,stackSize,_=GetContainerItemInfo(bagId, slotId)
					total = total + stackSize	
					if  previous == nil or (bagId ~= previous.bag or slotId ~= previous.slot) then 
						if stackSize>4 then
							temp = { bag=bagId, slot=slotId}
							table.insert(destroyTable,temp)	
						else
							--print ("bag ",bagId, "slot ",slotId, "item ",itemId)
							temp = { bagId, slotId, itemId}
							table.insert(mergeTable,temp)	--new
						end --end if/else
					end --end previous if
				end--end big if	
			end--end slots
		end--end bags
		
		if (destroyAll and #mergeTable >= 2) or (#mergeTable >= 2) then delay.mats=mats; delay:Show()
		elseif destroyAll and #mergeTable < 2 then mergeTable={} end  
        
        if total >4 then totalOverAll= total+totalOverAll end
        total = 0
  
	end--big for
	return  destroyTable,mergeTable, totalOverAll
end

--------------------------------
--
--This is the set of functions that handle merging.
-- delay
-- GUI:MergeItems
-- checkLocks
--
---------------------------------

delay:Hide() 
delay:SetScript("OnUpdate", 
	
	function(self, elapsed)

		
		if #mergeTable < 2 then
			self:Hide()
		else
			util:newSearch(currentItem, nil,self.mats)
			self:Hide() -- hide the delay to stop OnUpdate from firing 
		end --end if
				
		--check locks--
		coLocked = coroutine.create(checkLocks)
		coroutine.resume(coLocked, mergeTable)
		while coroutine.status(coLocked) == "suspended" do coroutine.resume(coLocked, mergeTable) end 
		
		util:mergeItems(mergeTable) 
		ClearCursor()

	end --end function

) 

function util:mergeItems (iTable)
	for i = 1, #iTable-1 do --> array start to end
		source=iTable[i]
		destination=iTable[i+1]
		
		--these lines magically merge the stacks--
		PickupContainerItem(source[1],source[2]) --(bag, slot)
		PickupContainerItem(destination[1], destination[2]) 
		
		delay:Show()
	end--end for
	
end

function checkLocks(iTable)

	for i = 1, #iTable do
		tmp = iTable[i]
		_,_,locked=GetContainerItemInfo(tmp[1], tmp[2])--bag, slot
		if locked then i=i-1; coroutine.yield() end
	end
	--return false
end


