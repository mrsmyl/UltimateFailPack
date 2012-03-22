-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


--load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Gather = TSM:NewModule("Gather", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Gathering")

local function debug(...)
	TSM:Debug(...)
end

local totalGather = {}

function Gather:OnInitialize()
	Gather:RegisterEvent("BANKFRAME_OPENED", "EventHandler")
	Gather:RegisterEvent("GUILDBANKFRAME_OPENED", "EventHandler")
end

local delay = CreateFrame("frame")
delay:Hide()
delay.func = function() end
delay.timeLeft = 0.5
delay:SetScript("OnShow", function(self) self.timeLeft = 0.5 end)
delay:SetScript("OnUpdate", function(self, elapsed)
		self.timeLeft = self.timeLeft - elapsed
		if self.timeLeft <= 0 then
			delay.func()
			self:Hide()
		end
	end)
	
local doneGathering = CreateFrame("frame")
doneGathering:Hide()
doneGathering.timeout = 0.2
doneGathering.type = nil
doneGathering:SetScript("OnUpdate", function(self, elapsed)
		self.timeLeft = self.timeLeft - elapsed
		if self.timeLeft <= 0 then
			self:Hide()
			Gather:DoneGathering(self.type)
		end
	end)
doneGathering:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
doneGathering:RegisterEvent("BAG_UPDATE")
doneGathering:SetScript("OnEvent", function(self) self.timeLeft = self.timeout end)

function Gather:EventHandler(event)
	-- probably way overcomplicating it here...
	local rEvent = strsplit("_", event)
	rEvent = gsub(rEvent, "FRAME", "")
	
	if TSM.tasks[1] and TSM.tasks[1].location == rEvent then
		Gather:RegisterMessage("TSM"..rEvent, "GatherMaterials")
	end
end

function Gather:GatherMaterials(bType, bankItems)
	TSM.Data:GetBagData()
	debug("gather mat start", bType)
	totalGather = {}
	local currentPlayer = UnitName("player")
	for itemID, quantity in pairs(TSM.tasks[1].items) do
		local numInBags = TSM.characters[currentPlayer].bags[itemID] or 0
		totalGather[itemID] = {inBags=(numInBags + quantity), toGather=quantity}
		debug("iT", itemID, quantity, totalGather[itemID].inBags)
	end
	Gather:UnregisterMessage(bType)

	if bType == "TSMGUILDBANK" then
		delay.func = function() Gather:GatherGBank(bankItems) end
		delay:Show()
	elseif bType == "TSMBANK" then
		delay.func = function() Gather:GatherBank(bankItems) end
		delay:Show()
	end
end

function Gather:GetEmptySlots()
	local emptySlots = {}
	for bag=NUM_BAG_SLOTS, 0, -1 do
		if GetContainerNumFreeSlots(bag) > 0 then
			for slot=GetContainerNumSlots(bag), 1, -1 do
				if not GetContainerItemInfo(bag, slot) then
					tinsert(emptySlots, {bag, slot})
				end
			end
		end
	end
	
	return emptySlots
end

function Gather:GatherGBank(bankItems)
	debug("starting gbank")
	local emptySlots = Gather:GetEmptySlots()
	local initialTab = GetCurrentGuildBankTab()

	if not (TSM.tasks[1] and TSM.tasks[1].items) then return end
	for itemID, quantityNeeded in pairs(TSM.tasks[1].items) do
		debug("S", itemID, quantityNeeded, bankItems[itemID] and #bankItems[itemID])
		if bankItems[itemID] then
			for _, item in pairs(bankItems[itemID]) do
				local num
				if item.quantity > quantityNeeded then
					num = quantityNeeded
					quantityNeeded = 0
				else
					quantityNeeded = quantityNeeded - item.quantity 
					num = item.quantity
				end
				
				if select(5, GetGuildBankTabInfo(item.tab)) > 0 or IsGuildLeader(UnitName("player")) then
					QueryGuildBankTab(item.tab)
					debug(item.tab, item.slot, num, emptySlots[#emptySlots][1], emptySlots[#emptySlots][2])
					SplitGuildBankItem(item.tab, item.slot, num)
					PickupContainerItem(unpack(tremove(emptySlots)))
				end
				
				if quantityNeeded == 0 or #emptySlots == 0 then break end
			end
			if #emptySlots == 0 then break end
		end
		TSM.tasks[1].items[itemID] = nil
	end
	
	QueryGuildBankTab(initialTab)
	debug("DONE GBANK")
	doneGathering.type = "GUILDBANK"
	doneGathering.timeLeft = doneGathering.timeout
	doneGathering:Show()
end

function Gather:GatherBank(bankItems)
	local emptySlots = Gather:GetEmptySlots()

	if not TSM.tasks[1].items then return end
	for itemID, quantityNeeded in pairs(TSM.tasks[1].items) do
		if bankItems[itemID] and #emptySlots > 0 then
			for _, item in pairs(bankItems[itemID]) do
				local num
				if item.quantity > quantityNeeded then
					num = quantityNeeded
					quantityNeeded = 0
				else
					num = item.quantity
					quantityNeeded = quantityNeeded - item.quantity
				end
				SplitContainerItem(item.bag, item.slot, num)
				PickupContainerItem(unpack(tremove(emptySlots)))
				
				if quantityNeeded == 0 or #emptySlots == 0 then break end
			end
		end
		TSM.tasks[1].items[itemID] = nil
	end
	
	doneGathering.type = "BANK"
	doneGathering.timeLeft = doneGathering.timeout
	doneGathering:Show()
end

function Gather:DoneGathering(event)
	local gotEverything = true
	local stillNeed, gathered = {}, {}
	TSM.Data:GetBagData()

	local currentPlayer = UnitName("player")
	for itemID, data in pairs(totalGather) do
		local inBags = TSM.characters[currentPlayer].bags[itemID] or 0
		gathered[itemID] = data.toGather - (data.inBags - inBags)
		TSM.tasks[1].items[itemID] = data.inBags - inBags
		if inBags < data.inBags then
			stillNeed[itemID] = data.inBags - inBags
			local _,name = GetItemInfo(itemID)
			debug("stillNeed", name, stillNeed[itemID], data.inBags, inBags)
			gotEverything = false
		end
	end
	
	if gotEverything then
		if event == "BANK" then
			TSM:Print(L["Finished gathering from bank."])
		elseif event == "GUILDBANK" then
			TSM:Print(L["Finished gathering from guild bank."])
		end
		TSM:NextTask()
		return
	end

	local freeSlots = 0
	for bag=0, NUM_BAG_SLOTS do
		freeSlots = freeSlots + GetContainerNumFreeSlots(bag)
	end
	
	if freeSlots == 0 then
		local onPlayer = UnitName("player")
		for i, task in ipairs(TSM.tasks) do
			onPlayer = task.player or onPlayer
			if task.location == "MAIL" and onPlayer == currentPlayer then
				for itemID, quantity in pairs(gathered) do
					if task.items[itemID] then
						task.items[itemID] = task.items[itemID] - quantity
						if task.items[itemID] <= 0 then
							tremove(task.items, itemID)
						end
					end
				end
			end
		end
		local canMail = false
		for itemID, quantity in pairs(gathered) do
			if quantity > 0 then
				canMail = true
				break
			end
		end
		
		if canMail then
			tinsert(TSM.tasks, 1, {location="MAIL", items=gathered})
		else
			TSM:Print(L["Your bags are full and nothing in your bags is ready to be mailed. Please clear some items from your bags and try again."])
		end
	else
		doneGathering.type = event
		doneGathering.timeLeft = doneGathering.timeout
		doneGathering:Show()
		return
	end
	
	TSM.GUI:UpdateFrame()
end

function Gather:StopGathering()
	wipe(TSM.tasks)
	doneGathering:Hide()
	TSM.GUI:UpdateFrame()
end
