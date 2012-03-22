 -- create a local reference to the TradeSkillMaster_Destroying table and register a new module
local TSM = select(2, ...)
local de = TSM:NewModule("de", "AceEvent-3.0","AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying") 
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local action = "Disenchanting"
local mat = "Disenchantable"

local Locations = {} --locations of all the destroyable gear
local DataGearTable ={}
local SafeGear

----------------------------------------
--
--item = itemString
--
-----------------------------------------
function de:moveItem (item, destination)
	
	if destination == "Locations" then
	
		_,_,index = de:getBagSlotSafe(item)
		table.insert (Locations, SafeGear[ index ] )
		table.remove(SafeGear, index)
		
	elseif destination == "SafeGear" then
	
		_,_,index = de:getBagSlot(item)
		table.insert (SafeGear, Locations[ index ] )
		SafeGear[#SafeGear].num =1
		if Locations[index].num == 1 then
			table.remove(Locations, index)
		else
			Locations[index].num=Locations[index].num-1
		end
		
	end--end if

end

function de:getLocations(previous)

	if #Locations >0 then
		return Locations[1]	
	elseif  #previous >0 then --to take care of Sapu's "potentail bug"
		return previous
	end

end --end getLocations

function de:getBagSlotSafe(is)
	
	for i,l in ipairs(SafeGear) do
		if l.itemString == is then
			return l.bag, l.slot, i			
		end
	end

end

function de:getBagSlot(is)

	for i,l in ipairs(Locations) do
		if l.itemString == is then
			return l.bag, l.slot, i			
		end
	end

end


function de:getItemString (bag,slot)  
	--print("item string")
	return string.match(GetContainerItemLink(bag, slot), "item[%-?%d:]+") 
end

function de:getDestroyTable(expand)

	DataGearTable ={}
	Locations = {}
	
	de:searchBagsforGear(expand)
	return DataGearTable

end

function de:getSafeTable(expand)
	DataGearTable ={}
	if not SafeGear then SafeGear = TSM.db.factionrealm.SafeGear end

	for i,l in ipairs(SafeGear) do
		table.insert (DataGearTable, de:createDestoryRow(l.name, l.qual, l.num, l.itemString, expand) )
	end
	return DataGearTable

end

function de:searchBagsforGear(expand)
	SafeGear = TSM.db.factionrealm.SafeGear
	--TSM.db.factionrealm.SafeGear={}
	local found = false
	local locked = false
	
	for bagId=0,4 do --bags		
		for slotId = 1,GetContainerNumSlots(bagId) do
			itemId = GetContainerItemID(bagId, slotId)
			_,_,locked=GetContainerItemInfo(bagId, slotId)
			--print (locked)
			if IsEquippableItem(itemId) and not de:getBagSlotSafe(de:getItemString (bagId,slotId)) and not locked then
				name,_,quality = GetItemInfo(itemId)
				if quality == 2 or quality == 3 or quality == 4  then --DE only Uncommon, Rare, Epic
					if not expand then
						--dont forget to look at the item string!!
						for i,n in ipairs(Locations) do					
							if n.name == name then
								found = true
								n.num=n.num + 1
							end
						end
					
						if not found then 
							table.insert (Locations, {name = name, bag = bagId, slot = slotId, qual = quality, num=1, itemString = de:getItemString (bagId,slotId)})
							de:sortGear(Locations)
						end
						found = false
					else
						table.insert ( Locations, { name = name, bag = bagId, slot = slotId, qual = quality, num=1, itemString = de:getItemString (bagId,slotId) } )
						de:sortGear(Locations)
					end--end expand if
				end--end quality if
			end--end if
		end
	end --end bags search

	for i,l in ipairs(Locations) do
		table.insert (DataGearTable, de:createDestoryRow(l.name, l.qual, l.num, l.itemString, expand) )
	end
	
end --end searchbags

function de:createDestoryRow(name, quality, num, itemString, expand)
	if expand then
		return  
		{	
		cols = {
					{
						value = function(data, qual) if data then return "|cff"..qualityColors[quality]..GetItemInfo(itemString).."|r" end end,
						args = {name, quality},
					},
					{
						value = function(data) return data end,
						args = {num},
					},
				},
				name = name,
				itemString = itemString
		}

	end

	return  
		{	
		cols = {
					{
						value = function(data, qual) if data then return "|cff"..qualityColors[quality]..name.."|r" end end,
						args = {name, quality},
					},
					{
						value = function(data) return data end,
						args = {num},
					},
				},
				name = name,
				itemString = itemString
		}
end

function de:sortGear(t)
	if #t >=2 then swapped = true end

	while swapped do
		swapped = false
		for i=2,#t do
			if t[i-1].qual < t[i].qual then 
				temp = t[i]
				t[i] = t[i-1]
				t[i-1] = temp
				swapped = true
			end --end if
		end--end for
	end --end while

end



