-- ---------------------------------------------------------------------------------------
-- 					TradeSkillMaster_Destroying - AddOn by Geemoney			   --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_destroying.aspx --
--																	   --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/	   --
-- 	Please contact the license holder (Sapu) via email at	sapu94@gmail.com with any   --
--		questions or concerns regarding this license.				 		   --
-- ---------------------------------------------------------------------------------------
--TSMAPI:RegisterSlashCommand("destroying", GUI:Load, "/TSM Destroying", notLoadFunc)

-- loads the localization table --
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying") 

-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0", "AceHook-3.0")--TSM:NewModule("GUI", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

--Useful Globals--
local current = 1 --the currently select mat
local matTable ={}
local destroying = false
local itemST
local expand = false

--Professions--
local prospecting = 31252
local milling = 51005
local disenchanting = 13262

--So I can get to it in lootframe.
local parentcontainer
local action, mat
local CurrentFilter

--usefull globals for updating results--
local ResultsTable={}
local today = date("%m/%d/%y")
local MatName

--usefull gloabls for DE--
DestroyableGear = {}

local update = CreateFrame("Frame") 

function GUI:Load(parent)
	
	local tabGroupTable={}
	local select = 1
	CurrentFilter = TSM.db.factionrealm.filter
	
	--find which spells are known--
	if IsSpellKnown(disenchanting) then
		table.insert(tabGroupTable, {text=L["Disenchanting"], value=3} )
		select = 3
	end
	if IsSpellKnown(milling) then
		table.insert(tabGroupTable, {text=L["Milling"], value=2} )
		select = 2
	end
	if IsSpellKnown(prospecting) then
		table.insert(tabGroupTable, {text=L["Prospecting"], value=1} )
	end


	local simpleGroup = AceGUI:Create("TSMSimpleGroup")
	simpleGroup:SetLayout("Fill")
	parent:AddChild(simpleGroup)
	
	--containers--
	local tabGroup = AceGUI:Create("TSMTabGroup")
	tabGroup:SetLayout("Fill")

	tabGroup:SetTabs(tabGroupTable)
	
	tabGroup:SetCallback("OnGroupSelected", function(self, _, value)
			tabGroup:ReleaseChildren()		
			--GUI:HideScrollingTables()
			if value == 1  then
				action = "Prospecting"
				mat = "Prospectable"
				ResultsTable = TSM.db.factionrealm.prospectingData.Days
				GUI:setToggles(self, TSM.db.global.destroyingMode)
				GUI:HideScrollingTables()			
				GUI:DrawScrollFrame(self)
			elseif value == 2  then
				action = "Milling"
				mat = "Millable"
				ResultsTable = TSM.db.factionrealm.millingData.Days
				GUI:setToggles(self,TSM.db.global.destroyingMode)
				GUI:HideScrollingTables()
				GUI:DrawScrollFrame(self)
			elseif value == 3 then
				action = "Disenchanting"
				mat = "Disenchantable"
				ResultsTable = TSM.db.factionrealm.deData.Days
				GUI:HideScrollingTables()
				GUI:DeSetToggles(self,TSM.db.global.destroyingMode)
			end
			parentcontainer = self		
		end)
	
	simpleGroup:AddChild(tabGroup)	
	tabGroup:SelectTab(select)
	
	GUI:HookScript(simpleGroup.frame, "OnHide", function() 
		GUI:UnhookAll() 
		GUI:HideScrollingTables() 
	end)
end

function GUI:setToggles(container, speed)
	container:ReleaseChildren()	
	if speed == "slow" then 
		GUI:DrawUI(container, true,false,false,speed)
	elseif speed == "normal" then 
		GUI:DrawUI(container, false,true,false,speed)
	elseif speed == "fast" then 
		GUI:DrawUI(container, false,false,true,speed)
	end
	TSM.db.global.destroyingMode=speed
end

function GUI:DrawUI(container,chkSlow, chkNorm, chkFast,speed)

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			children = 
			{
				{	--Prospecting DD
					type = "Dropdown",
					relativeWidth = 0.25,
					list = GUI:populateMenu(mat),
					value = current,
					callback =	function(this, event, item) current = item; end			
				}, 	-- End Prospecting DD

				{	--Destroy Button
					type = "DestroyButton",
					text = L["Destroy"],
					relativeWidth = 0.25,
					spell = action,
					mode = speed,
					locfunction = function(previous) 
						
                        destroying = true 
						total =TSM.util:searchAndDestroy(current, previous, matTable)--to set DestroyTable

                        if total >0 then
                            dTable=TSM.util:getLocations()
                            _,_,_,_,_,_,itemLink = GetContainerItemInfo(dTable.bag, dTable.slot);
                            MatName=GetItemInfo(itemLink)
                            
                            return TSM.util:getLocations()
                        end
					end					
				}, 	-- End Destory Button

				{	--ClearButton
					type = "Button",
					text = L["Clear Results"],
					relativeWidth = 0.25,
					callback = function() 
						clearCurrentTable();
						GUI:HideScrollingTables()  
						GUI:DrawScrollFrame (container)
					end					
				}, 	-- End ClearButton
				{	--FilterButton
					type = "Button",
					text = L["Filter by Mat/Date"],
					relativeWidth = 0.25,
					callback = function() 
						if CurrentFilter == "mats" then
							TSM.db.factionrealm.filter = "dates"
						else
							TSM.db.factionrealm.filter = "mats"
						end
						CurrentFilter = TSM.db.factionrealm.filter
						GUI:HideScrollingTables()  
						GUI:DrawScrollFrame (container)
					end					
				}, 	-- End ClearButton
				{	--Slow Speed--
					type="CheckBox",
					label =  L["Slow Speed (Single Click)"],
					relativeWidth = 0.33,
					value = chkSlow,
					callback = function () GUI:setToggles(container,"slow", action, mat); end
				},	--end Slow Speed--

				{	--Normal Speed--
					type="CheckBox",
					label =  L["Normal Speed(Double Click)"],
					relativeWidth = 0.33,
					value = chkNorm,
					callback = function () GUI:setToggles(container,"normal",action, mat); end
				},	--end Normal Speed--

				{	--Fast Speed--
					type="CheckBox",
					label =  L["Fast Speed (Double Click Advanced)"],
					relativeWidth = 0.33,
					value = chkFast,
					callback = function () GUI:setToggles(container,"fast",action, mat); end
				}, --end Fast Speed--
                {	--sum toogle--
                    type="CheckBox",
                    label =  L["Sum Loot (Uncheck if do not wish to display loot)"],
                    relativeWidth = 1,
                    value = TSM.db.global.SumLoot,
                    callback = function () 
                        if TSM.db.global.SumLoot  then
                            TSM.db.global.SumLoot = false
                        else
                            TSM.db.global.SumLoot = true
                        end

                        GUI:setToggles(parentcontainer, TSM.db.global.destroyingMode) 
                        GUI:HideScrollingTables()
                        GUI:DrawScrollFrame(parentcontainer)

                    end
                },	--end sum toogle--  

			}--end childern
		}--end 
	}--end local page
	TSMAPI:BuildPage(container, page)
end

function GUI:HideScrollingTables()
	if itemST then
		itemST:Hide()
	end
	if deitemST then
		deitemST:Hide()
	end
	if safegearST then
		safegearST:Hide()
	end
	if gearST then
		gearST:Hide()
	end
end

function GUI:populateMenu(action)

	local itemName
	local menuTable={}
	local tmpTable={}
	
	ore={}
	herbs={}
	
	table.insert ( menuTable, string.format(L["Destroy All !!"] ) )
	for bagId=0,4 do --bags		
		for slotId = 1,GetContainerNumSlots(bagId) do
			_,stackSize,_=GetContainerItemInfo(bagId, slotId)
			
				if stackSize and IsDestroyable(bagId,slotId,action) then 
					
					itemId = GetContainerItemID(bagId, slotId)
					itemName = GetItemInfo(itemId)
					index = searchTable(tmpTable, itemName)
					
					if index == -1 then
						tmp ={name=itemName, num=stackSize, id=itemId}
						table.insert(tmpTable, tmp)
					else
					 	tmpTable[index].num = tmpTable[index].num + stackSize
					end						

				end -- end if
		end --end slots
	end --end bags

	for i = 1, #tmpTable do 
		if tmpTable[i].num >= 5 then
			table.insert ( menuTable, string.format("%s  ( %d )", tmpTable[i].name ,tmpTable[i].num) )
			table.insert ( matTable, tmpTable[i].id )
		end --end if
	end--end for

	return menuTable

end

function searchTable (table, item)
	for i = 1, #table do
		if table[i].name == item then return i end 
	end
	return -1
end

--------------------------------------------------
--
--Scroll Table for prospecting/milling
--
---------------------------------------------------

function GUI:DrawScrollFrame (container)
   local ROW_HEIGHT = 20
   local stCols
   if TSM.db.global.SumLoot then
        stCols ={
            {name="", width=0.25},
            {name="Item", width=0.48},
            {name="Quantiy", width=0.25},             
        }
    else
        stCols ={
            {name="", width=1},
        }
    end
    
	local function GetSTColInfo(width)
        local colInfo =CopyTable(stCols)
        for i=1, #colInfo do
                colInfo[i].width = floor(colInfo[i].width*width)
        end
        return colInfo
    end
        
	--if not itemST then
    itemST = TSMAPI:CreateScrollingTable(GetSTColInfo(container.frame:GetWidth()), true)
	--itemST = TSMAPI:CreateScrollingTable(GetSTColInfo(container.frame:GetWidth()))
	--end 
    if TSM.db.global.SumLoot then
        if CurrentFilter == "mats" then 
            itemST:SetData( GUI:createDataTableMatSort() )
        else
            itemST:SetData( GUI:createDataTable() )
        end
    else
            itemST:SetData( GUI:noLoot() )
    end
    
	itemST.frame:SetParent(container.frame)
	itemST.frame:SetPoint("BOTTOMLEFT", container.frame, 10, 10)
	itemST.frame:SetPoint("TOPRIGHT", container.frame, -10, -130)
	itemST.frame:SetScript("OnSizeChanged", function(_,width, height)
			itemST:SetDisplayCols(GetSTColInfo(width))
			itemST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	itemST:Show()

	
end

function GUI:noLoot()
    return{ {

        cols = {
            { 
                value = function() return "You have chosen to turn off sum loot"  end,
                args = {},
            },
        },

    }}
end

function GUI:createDataTableMatSort()
	local dataTable = {} 
	local stTable = {}
	local currentMat
	local found = false

	if #ResultsTable ==0 or (#ResultsTable>0 and ResultsTable[1].mat) then
		for i, r in ipairs(ResultsTable) do
				if #dataTable > 0 then
					for j, d in ipairs(dataTable) do
						if d.name == r.name and d.mat == r.mat then
							d.quan = d.quan + r.quan
							found = true
							break
						end--end if
					end--end for
				end-- end if
				if not found then
					table.insert (dataTable, {name = r.name, quality = r.quality, quan =r.quan, mat = r.mat} )            
				end
				found = false
		end
		sortResultsMats(dataTable)
	
		for i, r in ipairs(dataTable) do
			if r.mat ~= currentMat then
				currentMat = r.mat
				table.insert (stTable,GUI:createMatRow(r))
			end
			table.insert (stTable, GUI:createRow(r))            
		end	
	
    	return stTable
    else
		
     	return{ {

					cols = {

						{
							value = function() return "You must clear the results table."  end,
							args = {},
						},	
						{},
						{},
					},

				}}
    end
end--end mat sort


function GUI:createDataTable()
	local dataTable = {} 
	local stTable = {}
	local currentDate
	local found = false
	
	for i, r in ipairs(ResultsTable) do
		
		if #dataTable > 0 then
			for j, d in ipairs(dataTable) do
				if d.quan and d.name == r.name and d.date == r.date then
					d.quan = d.quan + r.quan
					found = true
					break
				end--end if
			end--end for
		end-- end if

		if not found then
	    	table.insert (dataTable, {name = r.name, quality = r.quality, quan =r.quan, date = r.date} )            
	    end
		found = false	
	    
    end
	sortResults()--dataTable)
	
	for i, r in ipairs(dataTable) do
		if r.date ~= currentDate then
			currentDate = r.date
			table.insert (stTable,GUI:createDateRow(r))
		end
    	table.insert (stTable, GUI:createRow(r))            
    end	

    return stTable
end

function GUI:createDateRow(d)
	return 
	{

		cols = {

			{
				value = function(data) if data then return data end end,
				args = {d.date},
			},	
			{},
			{},
		},

	}
end

function GUI:createMatRow(d)
	return 
	{

		cols = {

			{
				value = function(data) if data then return data end end,
				args = {d.mat},
			},	
			{},
			{},
		},

	}
end

function GUI:createRow(d)
	return  
		{
		
		cols = {
			{},
			{
				value = function(data, qual) if data then return "|cff"..qualityColors[qual]..data.."|r" end end,
				args = {d.name, d.quality},
			},
			{
				value = function(data) return data end,
				args = {d.quan},
			},
			},

		}
end


LootFrame:HookScript("OnShow", function() 

	if destroying then
		local autoLoot = GetCVar("autoLootDefault")	
		--turn off autoloot--
		if autoLoot == 1 then SetCVar( "autoLootDefault", 0 ) end

		for i=1, GetNumLootItems(), 1 do
			_,name,quan,quality,_=GetLootSlotInfo(i)
			--print("date =", today,"mat = ",MatName, "name=",name, "quality =", quality, "quan =", quan)
			table.insert(ResultsTable, {date = today,mat = MatName, name=name, quality = quality, quan = quan } )
			LootSlot(i) 
		end	

		--turn on autoloot--
		if autoLoot == 1 then SetCVar( "autoLootDefault", 1 ) end

        if action == "Disenchanting" then 
            GUI:HideScrollingTables()
            GUI:DrawItemScrollFrame (parentcontainer)
            GUI:DrawGearScrollFrame (parentcontainer)
            GUI:DrawSafeGearScrollFrame (parentcontainer)
        else
            GUI:setToggles(parentcontainer, TSM.db.global.destroyingMode) 
            GUI:HideScrollingTables()
            GUI:DrawScrollFrame(parentcontainer)
        end

		destroying = false
	end
end)
--------------------------------------------------
--
--DE UI Functions
--
-----------------------------------------

function GUI:DrawGearScrollFrame (container)
	--print ("GUI:DrawGearScrollFrame")
	local ROW_HEIGHT = 20
	local stCols = {
		    {name="Destroy Item", width=0.75},
		    {name="Quantiy", width=0.25}
	    
	}
	
	local function GetSTColInfo(width)
        local colInfo = CopyTable(stCols)
        for i=1, #colInfo do
                colInfo[i].width = floor(colInfo[i].width*width)
        end
        return colInfo
    end
        
	if not gearST then
          gearST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()), true )
		--gearST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()) )
	end 

	gearST.frame:SetParent(container.frame)
	gearST.frame:SetPoint("TOPLEFT", container.frame, 20, -130) 
	gearST.frame:SetPoint("BOTTOMRIGHT", container.frame, -container.frame:GetWidth()*.5, container.frame:GetHeight()*.5 ) 
	gearST.frame:SetScript("OnSizeChanged", function(_,width, height)
			gearST:SetDisplayCols(GetSTColInfo(width))
			gearST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
			gearST.frame:SetPoint("TOPLEFT", container.frame, 20, -130) 
			gearST.frame:SetPoint("BOTTOMRIGHT", container.frame, -container.frame:GetWidth()*.5, container.frame:GetHeight()*.5 ) 
		end)
	
	DestroyableGear = TSM.de:getDestroyTable(expand)
	gearST:SetData(DestroyableGear)
	gearST:Show()
	
	gearST:RegisterEvents({
		["OnClick"] = function(_, _, data, _, _, rowNum, _, self,button)
			if button == "RightButton" then--move to safe
			
				if not rowNum then return end
				TSM.de:moveItem (data[rowNum].itemString, "SafeGear") --itemString, dest
				GUI:DrawGearScrollFrame(container)
				GUI:DrawSafeGearScrollFrame (container) 

			elseif button == "LeftButton" then --destroy??
				
			end
		end,
		["OnEnter"] = function(_, self, data, _, _, rowNum)
			if not rowNum then return end

			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink(data[rowNum].itemString) 
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end
	})
end

function GUI:DrawSafeGearScrollFrame (container)
	local ROW_HEIGHT = 20
	local stCols = {
		    {name="Safe Item", width=0.75},
		    {name="Quantiy", width=0.25}
	    
	}
	
	local function GetSTColInfo(width)
                local colInfo = CopyTable(stCols)
                for i=1, #colInfo do
                        colInfo[i].width = floor(colInfo[i].width*width)
                end
 
                return colInfo
    end
        
	if not safegearST then
		safegearST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()), true )
        --safegearST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()) )
	end 

	safegearST:SetData(TSM.de:getSafeTable(expand))

	safegearST.frame:SetParent(container.frame)
	safegearST.frame:SetPoint("TOPLEFT", container.frame, 20, -(container.frame:GetHeight()*.5)-20)--TOPRIGHT = right-x, top-y
	safegearST.frame:SetPoint("BOTTOMRIGHT", container.frame, -(container.frame:GetWidth()*.5)  , 20) 
	safegearST.frame:SetScript("OnSizeChanged", function(_,width, height)
			safegearST:SetDisplayCols(GetSTColInfo(width))
			safegearST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
			safegearST.frame:SetPoint("TOPLEFT", container.frame, 20, -(container.frame:GetHeight()*.5)-20)--TOPRIGHT = right-x, top-y
			safegearST.frame:SetPoint("BOTTOMRIGHT", container.frame, -container.frame:GetWidth()*.5, 20) 
		end)
	safegearST:RegisterEvents({
	["OnClick"] = function(_, _, data, _, _, rowNum, _, self,button)
	
		if button == "RightButton" then--move to safe
			if not rowNum then return end
			TSM.de:moveItem (data[rowNum].itemString, "Locations") --itemString, dest
			GUI:DrawGearScrollFrame(container)
			GUI:DrawSafeGearScrollFrame (container)
		elseif button == "LeftButton" then --destroy??
	
		end
	end,
	["OnEnter"] = function(_, self, data, _, _, rowNum)
		if not rowNum then return end

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetHyperlink(data[rowNum].itemString) 
		GameTooltip:Show()
	end,
	["OnLeave"] = function()
		GameTooltip:ClearLines()
		GameTooltip:Hide()
	end
	})
	safegearST:Show()
	
	
end


function GUI:DrawItemScrollFrame (container)
	--print("Item Scroll Frames")
	local ROW_HEIGHT = 20
	local st2Cols 
    
    if TSM.db.global.SumLoot then
        st2Cols = {
            {name="Date", width=0.25},
            {name="Item", width=0.48},
            {name="Quantiy", width=0.25}, 
        }
    else
        st2Cols = {
            {name="", width=1}
        }

    end
	
	local function GetSTColInfo(width)
        local colInfo = CopyTable(st2Cols)
        for i=1, #colInfo do
                colInfo[i].width = floor(colInfo[i].width*width)
        end

        return colInfo
    end
        
	--if not deitemST then
    deitemST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()),true )
	--deitemST = TSMAPI:CreateScrollingTable(GetSTColInfo( container.frame:GetWidth()) )
	--end 
    if TSM.db.global.SumLoot then
        deitemST:SetData( GUI:createDataTable() )
    else
        deitemST:SetData( GUI:noLoot ())
    end
	deitemST.frame:SetParent(container.frame)
	deitemST.frame:SetPoint("TOPLEFT", container.frame, container.frame:GetWidth()*.5, -105 )--TOPRIGHT = right-x, top-y
	deitemST.frame:SetPoint("BOTTOMRIGHT", container.frame, -25  , 20) 
	deitemST.frame:SetScript("OnSizeChanged", function(_,width, height)
			deitemST:SetDisplayCols(GetSTColInfo(width))
			deitemST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
			deitemST.frame:SetPoint("TOPLEFT", container.frame, container.frame:GetWidth()*.5, -105 )--TOPRIGHT = right-x, top-y
			deitemST.frame:SetPoint("BOTTOMRIGHT", container.frame, -25  , 20) 
		end)
	deitemST:Show()
	
end


function GUI:DrawDeUI(container,chkSlow, chkNorm, chkFast,speed)

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			children = 
			{
				
				{	--Destroy Button
					type = "DestroyButton",
					text = L["Destroy"],
					relativeWidth = 0.33,
					spell = action,
					mode = speed,
					locfunction = function(previous) 
						destroying = true --for the lootframe				
						if #DestroyableGear>0 then
							return TSM.de:getLocations(previous)  
						end--end if
					end--end locfunctions					
				}, 	-- End Destory Button

				{	--expand/collapse
					type = "Button",
					text = L["Expand/Collapse"],
					relativeWidth = 0.33,
					callback = function()  
						if expand then expand = false
						else expand = true end
						GUI:DrawGearScrollFrame (container)
					end					
				}, 	-- End ClearButton
				{	--ClearButton
					type = "Button",
					text = L["Clear Results"],
					relativeWidth = 0.33,
					callback = function() 
                        clearCurrentTable(); 
                        if deitemST then deitemST:Hide()end  
                        GUI:DrawItemScrollFrame (container); 
                        end					
				}, 	-- End ClearButton
		
				{	--Slow Speed--
					type="CheckBox",
					label =  L["Slow Speed (Single Click)"],
					relativeWidth = 0.33,
					value = chkSlow,
					callback = function () GUI:DeSetToggles(container,"slow", action, mat); end
				},	--end Slow Speed--

				{	--Normal Speed--
					type="CheckBox",
					label =  L["Normal Speed(Double Click)"],
					relativeWidth = 0.33,
					value = chkNorm,
					callback = function () GUI:DeSetToggles(container,"normal",action, mat); end
				},	--end Normal Speed--

				{	--Fast Speed--
					type="CheckBox",
					label =  L["Fast Speed (Double Click Advanced)"],
					relativeWidth = 0.33,
					value = chkFast,
					callback = function () GUI:DeSetToggles(container,"fast",action, mat); end
				},--end Fast Speed--
                {	--sum toogle--
                    type="CheckBox",
                    label =  L["Sum Loot (Uncheck if do not wish to display loot)"],
                    relativeWidth = 1,
                    value = TSM.db.global.SumLoot,
                    callback = function () 
                        if TSM.db.global.SumLoot  then
                            TSM.db.global.SumLoot = false
                        else
                            TSM.db.global.SumLoot = true
                        end
                        GUI:HideScrollingTables()
                        GUI:DrawGearScrollFrame(container)
                        GUI:DrawItemScrollFrame(container)
                        GUI:DrawSafeGearScrollFrame (container)

                    end
                },	--end sum toogle--  
				

			}--end childern
		}--end 
	}--end local page

	TSMAPI:BuildPage(container, page)
end

function GUI:DeSetToggles(container, speed)
	container:ReleaseChildren()	
	--print (speed)
	if speed == "slow" then 
		GUI:DrawDeUI(container, true,false,false,speed)
	elseif speed == "normal" then 
		GUI:DrawDeUI(container, false,true,false,speed)
	elseif speed == "fast" then 
		GUI:DrawDeUI(container, false,false,true,speed)
	end

	GUI:DrawGearScrollFrame(container)
	GUI:DrawItemScrollFrame(container)
	GUI:DrawSafeGearScrollFrame (container)
	
	TSM.db.global.destroyingMode=speed

end


function printDays(t)
	print("Printing resultsTable.Days, ", #ResultsTable," items")
	for i,d in ipairs(t) do
		print (i,".",d.date," item= ",d.name," num= ",d.quan,"qual= ",d.quality)
	end
end
function clearCurrentTable()

	if action == "Prospecting" then
		TSM.db.factionrealm.prospectingData={
				Days = {},
				Mats = {}
			}
	elseif action == "Milling" then 
		TSM.db.factionrealm.millingData={
				Days = {},
				Mats = {}
			}
	elseif action == "Disenchanting" then
		TSM.db.factionrealm.deData={
				Days = {},
				Mats = {}
			}
	end
		print ("Table cleared")
end

function sortResults()
	if #ResultsTable >=2 then swapped = true end
	while swapped do
		swapped = false
		for i=2,#ResultsTable do
			if ResultsTable[i-1].date < ResultsTable[i].date then 
				temp = ResultsTable[i]
				ResultsTable[i] = ResultsTable[i-1]
				ResultsTable[i-1] = temp
				swapped = true
			end --end if
		end--end for
	end --end while
end
function sortResultsMats(t)
	if #t >=2 then swapped = true end
	while swapped do
		swapped = false
		for i=2,#t do
			if t[i-1].mat < t[i].mat then 
				temp = t[i]
				t[i] = t[i-1]
				t[i-1] = temp
				swapped = true
			end --end if
		end--end for
	end --end while
end
