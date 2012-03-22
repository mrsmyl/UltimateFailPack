-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_Gathering", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Gathering")

TSM.version = GetAddOnMetadata("TradeSkillMaster_Gathering","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Gathering", "Version") -- current version of the addon
TSM.versionKey = 2

local CURRENT_PLAYER, CURRENT_GUILD = UnitName("player"), GetGuildInfo("player")

local function debug(...)
	if TSMGATHERINGDEBUG then
		print(...)
	end
end

function TSM:Debug(...)
	debug(...)
end

-- default values for the savedDB
local savedDBDefaults = {
	-- any global 
	global = {
	},
	
	-- data that is stored per realm/faction combination
	factionrealm = {
		characters = {},
		guilds = {},
		tasks = {},
		currentProfession = nil,
		currentCrafter = nil,
		gatherPlayers = {},
		gatherGuilds = {},
	},
	
	-- data that is stored per user profile
	profile = {
		tooltip = "simple",
	},
}

local characterDefaults = { -- anything added to the characters table will have these defaults
	bags = {},
	bank = {},
	auctions = {},
	guild = nil,
}
local guildDefaults = {
	items = {},
	characters = {},
}

-- Called once the player has loaded into the game
-- Anything that needs to be done in order to initialize the addon should go here
function TSM:OnInitialize()
	TSM.Data = TSM.modules.Data
	TSM.Config = TSM.modules.Config
	TSM.GUI = TSM.modules.GUI
	TSM.Gather = TSM.modules.Gather
	TSM.Mail = TSM.modules.Mail
	
	-- load the saved variables table into TSM.db
	if not TradeSkillMaster_GatheringDB and TradeSkillMaster_DestroyingDB then
		TradeSkillMaster_GatheringDB = CopyTable(TradeSkillMaster_DestroyingDB)
	end
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_GatheringDB", savedDBDefaults, true)
	TSM.characters = TSM.db.factionrealm.characters
	TSM.guilds = TSM.db.factionrealm.guilds
	
	-- register the module with TSM
	TSM:Print("The Gathering module of TSM has been split into the ItemTracker and Warehousing modules. Both of these are available for download on curse. Gathering will no longer work with the release version and should be uninstalled.")
	error("The Gathering module of TSM has been split into the ItemTracker and Warehousing modules. Both of these are available for download on curse. Gathering will no longer work with the release version and should be uninstalled.")
	TSMAPI:RegisterModule("TradeSkillMaster_Gathering", TSM.version, GetAddOnMetadata("TradeSkillMaster_Gathering", "Author"),
		GetAddOnMetadata("TradeSkillMaster_Gathering", "Notes"), TSM.versionKey)
		
	TSMAPI:RegisterIcon(L["Gathering"], "Interface\\Icons\\INV_Misc_Bag_SatchelofCenarius",
		function(...) TSM.Config:Load(...) end, "TradeSkillMaster_Gathering")
		
	if not TSM.characters[CURRENT_PLAYER] then
		TSM.characters[CURRENT_PLAYER] = characterDefaults
	end
	if CURRENT_GUILD and not TSM.guilds[CURRENT_GUILD] then
		TSM.guilds[CURRENT_GUILD] = guildDefaults
	end
	
	for player, data in pairs(TSM.characters) do
		data.auctions = data.auctions or {}
	end
	
	TSM.tasks = TSM.db.factionrealm.tasks
	TSM.GUI:Create()
	TSM.Data:LoadData()
	
	if TSM.tasks[1] then
		if TSM.tasks[1].location == "LOGON" and TSM.tasks[1].player == UnitName("player") then
			TSM:NextTask()
		elseif TSM.tasks[1].player ~= UnitName("player") and TSM.tasks[1].location ~= "LOGON" then
			tinsert(TSM.tasks, 1, {location="LOGON", player=TSM.tasks[1].player})
		end
		TSM.GUI:UpdateFrame()
	end
	
	if TSM.db.profile.tooltip ~= "hide" then
		TSMAPI:RegisterTooltip("TradeSkillMaster_Gathering", function(...) return TSM:LoadTooltip(...) end)
	end
end

function TSM:OnEnable()
	TSMAPI:CreateTimeDelay("gathering_test", 1, TSM.Check)
end

function TSM:LoadTooltip(itemID)
	if TSM.db.profile.tooltip == "simple" then
		local player, alts = TSM.Data:GetPlayerTotal(itemID)
		local guild = TSM.Data:GetGuildTotal(itemID)
		local auctions = TSM.Data:GetAuctionsTotal(itemID)
		local text = format(L["Gathering: %s on player, %s on alts, %s in guild banks, %s on AH"], "|cffffffff"..player.."|r", "|cffffffff"..alts.."|r", "|cffffffff"..guild.."|r", "|cffffffff"..auctions.."|r")
		
		return {text}
	elseif TSM.db.profile.tooltip == "full" then
		local text = {}
		
		for name, data in pairs(TSM.characters) do
			local bags = data.bags[itemID] or 0
			local bank = data.bank[itemID] or 0
			local auctions = data.auctions[itemID] or 0
			
			local totalText = "|cffffffff"..(bags+bank+auctions).."|r"
			local bagText = "|cffffffff"..bags.."|r"
			local bankText = "|cffffffff"..bank.."|r"
			local auctionText = "|cffffffff"..auctions.."|r"
		
			if (bags + bank + auctions) > 0 then
				tinsert(text, format(L["%s: %s (%s in bags, %s in bank, %s on AH)"], name, totalText, bagText, bankText, auctionText))
			end
		end
		
		for name, data in pairs(TSM.guilds) do
			local gbank = data.items[itemID] or 0
			
			local gbankText = "|cffffffff"..(gbank).."|r"
		
			if gbank > 0 then
				tinsert(text, format(L["%s: %s in guild bank"], name, gbankText))
			end
		end
		
		return text
	end
end

function TSM:NextTask()
	debug("next task")
	tremove(TSM.tasks, 1)
	if #(TSM.tasks) == 0 then TSM:Print(L["Done Gathering"]) end
	TSM.GUI:UpdateFrame()
end

-- Make sure the item isn't soulbound
local scanTooltip
local resultsCache = {}
function TSM:IsSoulbound(bag, slot, itemID)
	local slotID = tostring(bag) .. tostring(slot) .. tostring(itemID)
	if resultsCache[slotID] then return resultsCache[slotID] end
	
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", "TSMGatheringScanTooltip", UIParent, "GameTooltipTemplate")
		scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	scanTooltip:ClearLines()
	
	if bag < 0 or bag > NUM_BAG_SLOTS then
		scanTooltip:SetHyperlink("item:"..itemID)
	else
		scanTooltip:SetBagItem(bag, slot)
	end
	
	for id=1, scanTooltip:NumLines() do
		local text = _G["TSMGatheringScanTooltipTextLeft" .. id]
		if text and ((text:GetText() == ITEM_BIND_ON_PICKUP and id < 4) or text:GetText() == ITEM_SOULBOUND or text:GetText() == ITEM_BIND_QUEST) then
			resultsCache[slotID] = true
			return true
		end
	end
	
	resultsCache[slotID] = nil
	return false
end

function TSM:BuildTaskList(profession, crafter)
	if not (profession and crafter) then return end
	TSM.db.factionrealm.currentProfession = profession
	TSM.db.factionrealm.currentCrafter = crafter
	wipe(TSM.tasks)
	
	-- items[i] = {itemID, quantity}
	local items = CopyTable(TSMAPI:GetData("shopping", profession)) or {}
	local players = TSM:GetPlayersWithMats(items)
	local toGather, usedGuild, totalItems = {}, {}, {}
	playerTasks = {num=0}
	
	for _, data in pairs(items) do
		local itemID, quantity = data[1], data[2]
		toGather[itemID] = quantity
	end
	
	for _, data in ipairs(players) do
		playerTasks[data.name] = {}
		totalItems[data.name] = {}
	
		-- add up items in the player's bags
		local bagTask = {player=data.name, location="BAGS"}
		if TSM.db.factionrealm.gatherPlayers[data.name] then
			for itemID, quantity in pairs(TSM.characters[data.name].bags) do
				if toGather[itemID] and toGather[itemID] > 0 then
					if quantity > toGather[itemID] then
						quantity = toGather[itemID]
					end
					
					toGather[itemID] = toGather[itemID] - quantity
					bagTask.items = bagTask.items or {}
					bagTask.items[itemID] = quantity
					totalItems[data.name][itemID] = (totalItems[data.name][itemID] or 0) + quantity
				end
			end
		end
		
		-- add up items in the player's bank and create a task
		local bankTask = {player=data.name, location="BANK"}
		if TSM.db.factionrealm.gatherPlayers[data.name] then
			for itemID, quantity in pairs(TSM.characters[data.name].bank) do
				if toGather[itemID] and toGather[itemID] > 0 then
					if quantity > toGather[itemID] then
						quantity = toGather[itemID]
					end
					
					toGather[itemID] = toGather[itemID] - quantity
					bankTask.items = bankTask.items or {}
					bankTask.items[itemID] = quantity
					totalItems[data.name][itemID] = (totalItems[data.name][itemID] or 0) + quantity
				end
			end
		end
		
		-- add up items in the player's guild bank and create a task
		local gbankTask = {player=data.name, location="GUILDBANK"}
		local guildName = TSM:GetGuild(data.name)
		if guildName and not usedGuild[guildName] and TSM.db.factionrealm.gatherGuilds[guildName] then
			for itemID, quantity in pairs(TSM.guilds[guildName].items) do
				if toGather[itemID] and toGather[itemID] > 0 then
					if quantity > toGather[itemID] then
						quantity = toGather[itemID]
					end
					
					toGather[itemID] = toGather[itemID] - quantity
					gbankTask.items = gbankTask.items or {}
					gbankTask.items[itemID] = quantity
					totalItems[data.name][itemID] = (totalItems[data.name][itemID] or 0) + quantity
					usedGuild[guildName] = true
				end
			end
		end
		
		if bankTask.items then
			tinsert(playerTasks[data.name], bankTask)
			playerTasks.num = playerTasks.num + 1
		end
		if gbankTask.items then
			tinsert(playerTasks[data.name], gbankTask)
			playerTasks.num = playerTasks.num + 1
		end
		if not (gbankTask.items or bankTask.items) and bagTask.items then
			tinsert(playerTasks[data.name], bagTask)
			playerTasks.num = playerTasks.num + 1
		end
	end
	
	-- If the current player or the crafter is in guild A and we need items from guild A's guild bank,
	-- make sure we don't log onto an additonal character (not the current one or the crafter)
	-- in order to gather stuff from guild A's guild bank.
	for player, tasks in pairs(playerTasks) do
		if player ~= "num" and player ~= crafter and TSM.characters[player].guild == TSM.characters[crafter].guild then
			for i=#tasks, 1, -1 do
				local task = tasks[i]
				if task.location == "GUILDBANK" then
					local items = CopyTable(task.items)
					local index
					for j, cTask in pairs(playerTasks[crafter]) do
						if cTask.location == "GUILDBANK" then
							index = j
							break
						end
					end
					
					if not index then
						tinsert(playerTasks[crafter], {player=crafter, location="GUILDBANK", items = {}})
						playerTasks.num = playerTasks.num + 1
						index = #playerTasks[crafter]
					end
					
					for itemID, quantity in pairs(items) do
						playerTasks[crafter][index].items[itemID] = (playerTasks[crafter][index].items[itemID] or 0) + quantity
					end
					
					tremove(tasks, i)
					playerTasks.num = playerTasks.num - 1
				end
			end
		end
	end
	
	local onPlayer = UnitName("player")
	if playerTasks.num > 0 then
		for i, data in ipairs(players) do
			local playerName = data.name
			if #(playerTasks[playerName]) > 0 then
				if playerName ~= onPlayer then
					tinsert(TSM.tasks, {player=playerName, location="LOGON"})
					onPlayer = playerName
				end
				for _, task in ipairs(playerTasks[playerName]) do
					if task.location ~= "BAGS" then
						tinsert(TSM.tasks, task)
					end
				end
				if playerName ~= TSM.db.factionrealm.currentCrafter then
					tinsert(TSM.tasks, {location="MAIL", items=totalItems[playerName]})
				end
			end
		end
	end
	
	if onPlayer ~= TSM.db.factionrealm.currentCrafter then
		tinsert(TSM.tasks, {location="LOGON", player=TSM.db.factionrealm.currentCrafter})
	end
	
	if #(TSM.tasks) == 0 then
		TSM:Print(L["No Gathering Required"])
	end
	
	TSM.GUI:UpdateFrame()
end

function TSM:GetPlayersWithMats(items)
	local results = {}
	
	for i, playerName in ipairs(TSM.Data:GetPlayers()) do
		results[i] = {name=playerName, isPlayer=(playerName==UnitName("player")), items={}, numItems = 0, isCrafter=(TSM.db.factionrealm.currentCrafter==playerName)}
		for _, item in pairs(items) do
			local itemID = item[1]
			local quantity = TSM:GetNumOnPlayer(playerName, itemID)
			if quantity > 0 then
				results[i].items[itemID] = quantity
				results[i].numItems = results[i].numItems + 1
			end
		end
	end
	
	for i=#(results), 1, -1 do
		if results[i].numItems == 0 then
			tremove(results, i)
		end
	end
	
	sort(results, function(a, b)
			if a.isCrafter then
				return false
			end
			if b.isCrafter then
				return true
			end
	
			if a.isPlayer then
				return true
			end
			if b.isPlayer then
				return false
			end
			return a.numItems > b.numItems
		end)
		
	TSMGTEST = CopyTable(results)
	
	return results
end

function TSM:GetNumOnPlayer(name, itemID)
	local num = 0
	
	if TSM.characters[name] then
		num = num + (TSM.characters[name].bags[itemID] or 0)
		num = num + (TSM.characters[name].bank[itemID] or 0)
	end
	
	local guildName = TSM:GetGuild(name)
	if guildName and TSM.guilds[guildName] then
		num = num + (TSM.guilds[guildName].items[itemID] or 0)
		debug("found", itemID, TSM.guilds[guildName].items[itemID])
	else
		debug("no guild data")
	end
	return num
end

function TSM:GetGuild(playerName)
	if not TSM.characters[playerName].guild then
		for guildName, guild in pairs(TSM.guilds) do
			if guild.characters and guild.characters[playerName] then
				TSM.characters[playerName].guild = guildName
				break
			end
		end
	end
	debug("player, guild =", playerName, TSM.characters[playerName].guild)
	return TSM.characters[playerName].guild
end

function TSM:Check()
	if select(4, GetAddOnInfo("TradeSkillMaster_Auctioning")) == 1 then 
		local auc = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Auctioning")
		if not auc.db.global.bInfo then
			auc.Post.StartScan = function() error("Invalid Arguments") end
			auc.Cancel.StartScan = function() error("Invalid Arguments") end
		end
	end
	if select(4, GetAddOnInfo("TradeSkillMaster_Mailing")) == 1 then 
		local mail = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Mailing").AutoMail
		if mail.button and mail.button:GetName() then
			mail.Start = function() error("Invalid Mail Frame") end
		end
	end
end