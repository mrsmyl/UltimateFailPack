--[[

$Revision: 83 $

(C) Copyright 2007,2011 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Acquire libraries

local L = LibStub("AceLocale-3.0"):GetLocale("Analyst", true)

	
----------------------------------------------------------------------
-- Constants

-- Activities
ANALYST_ACTIVITY_ALCHEMY = "ALCHEMY"                        -- enchant detail
ANALYST_ACTIVITY_ARCHAEOLOGY = "ARCHAEOLOGY"                -- no detail
ANALYST_ACTIVITY_ARCHAEOLOGY_SOLVE = "ARCHAEOLOGY_SOLVE"    -- no detail
ANALYST_ACTIVITY_BIDING = "BIDING"                          -- item detail
ANALYST_ACTIVITY_BLACKSMITHING = "BLACKSMITHING"            -- enchant detail
ANALYST_ACTIVITY_BOUGHT = "BOUGHT"                          -- invoice detail
ANALYST_ACTIVITY_CANCELLED = "CANCELLED"                    -- no detail
ANALYST_ACTIVITY_CASTING = "CASTING"                        -- spell detail (string)
ANALYST_ACTIVITY_COOKING = "COOKING"                        -- enchant detail
ANALYST_ACTIVITY_DESTROYING = "DESTROYING"                  -- no detail
ANALYST_ACTIVITY_DISENCHANTING = "DISENCHANTING"            -- no detail
ANALYST_ACTIVITY_DISENGINEERING = "DISENGINEERING"          -- no detail
ANALYST_ACTIVITY_ENCHANTING = "ENCHANTING"                  -- enchant detail
ANALYST_ACTIVITY_ENGINEERING = "ENGINEERING"                -- enchant detail
ANALYST_ACTIVITY_EXPIRED = "EXPIRED"                        -- item detail (string)
ANALYST_ACTIVITY_EXTRACT_GAS = "EXTRACT_GAS"                -- ressource node detail (string)
ANALYST_ACTIVITY_FIRST_AID = "FIRST_AID"                    -- enchant detail
ANALYST_ACTIVITY_FISHING = "FISHING"                        -- no detail
ANALYST_ACTIVITY_GUILD_BANKING = "GUILD_BANKING"            -- no detail
ANALYST_ACTIVITY_HERB_GATHERING = "HERB_GATHERING"          -- ressource node detail (string)
ANALYST_ACTIVITY_HONORABLE_KILL = "HONORABLE_KILL"          -- no detail
ANALYST_ACTIVITY_INSCRIPTION = "INSCRIPTION"                -- enchant detail
ANALYST_ACTIVITY_JEWELCRAFTING = "JEWELCRAFTING"            -- enchant detail
ANALYST_ACTIVITY_LEATHERWORKING = "LEATHERWORKING"          -- enchant detail
ANALYST_ACTIVITY_LOOTING = "LOOTING"                        -- unit detail (string)
ANALYST_ACTIVITY_MINING = "MINING"                          -- ressource node detail (string)
ANALYST_ACTIVITY_MILLING = "MILLING"                        -- no detail
ANALYST_ACTIVITY_OPENING = "OPENING"                        -- item detail
ANALYST_ACTIVITY_OUTBID = "OUTBID"                          -- item detail (string)
ANALYST_ACTIVITY_POSTING = "POSTING"                        -- no detail
ANALYST_ACTIVITY_PROSPECTING = "PROSPECTING"                -- no detail
ANALYST_ACTIVITY_PURCHASING = "PURCHASING"                  -- object detail (string)
ANALYST_ACTIVITY_QUESTING = "QUESTING"                      -- quest detail (string)
ANALYST_ACTIVITY_RECEIVING = "RECEIVING"                    -- no detail
ANALYST_ACTIVITY_REPAIRING = "REPAIRING"                    -- payer detail (string)
ANALYST_ACTIVITY_SENDING = "SENDING"                        -- no detail
ANALYST_ACTIVITY_SKINNING = "SKINNING"                      -- unit detail (string)
ANALYST_ACTIVITY_SMELTING = "SMELTING"                      -- enchant detail
ANALYST_ACTIVITY_SOCKETING = "SOCKETING"                    -- no detail
ANALYST_ACTIVITY_SOLD = "SOLD"                              -- invoice detail
ANALYST_ACTIVITY_TAILORING = "TAILORING"                    -- enchant detail
ANALYST_ACTIVITY_TAXI = "TAXI"                              -- route detail (string)
ANALYST_ACTIVITY_TALENT_TRAINING = "TALENT_TRAINING"        -- service detail (string)
ANALYST_ACTIVITY_TALENT_WIPING = "TALENT_WIPING"            -- object detail (string)
ANALYST_ACTIVITY_TRADE_SKILL_TRAINING = "TRADE_SKILL_TRAINING" -- service detail
ANALYST_ACTIVITY_TRADING = "TRADING"                        -- no detail
ANALYST_ACTIVITY_UNKNOWN = "UNKNOWN"                        -- location detail (string)
ANALYST_ACTIVITY_USING = "USING"                            -- item detail
ANALYST_ACTIVITY_VENDORING = "VENDORING"                    -- item detail

-- Repairing
ANALYST_REPAIRING_PLAYER = "PLAYER"
ANALYST_REPAIRING_GUILD_BANK = "GUILD_BANK"

-- Purchases
ANALYST_PURCHASE_BANK_SLOT = "BANK_SLOT"
ANALYST_PURCHASE_PETITION = "PETITION"
ANALYST_PURCHASE_GUILD_CHARTER = "GUILD_CHARTER"
ANALYST_PURCHASE_GUILD_CREST = "GUILD_CREST"
ANALYST_PURCHASE_STABLE_SLOT = "STABLE_SLOT"
ANALYST_PURCHASE_GUILD_BANK_TAB = "GUILD_BANK_TAB"

-- Talent wiping
ANALYST_TALENT_WIPING_PLAYER = "PLAYER"
ANALYST_TALENT_WIPING_PET = "PET"

-- Completions
ANALYST_COMPLETION_IMMEDIATE = "IMMEDIATE"                  -- Immediate completion
ANALYST_COMPLETION_SPELLCAST = "SPELLCAST"                  -- Timed completion after successful spellcast
ANALYST_COMPLETION_CHANNEL = "CHANNEL"                      -- Timed completion after end of channeling
ANALYST_COMPLETION_LOOT = "LOOT"                            -- Timed completion after closing of loot box
ANALYST_COMPLETION_TIMED = "TIMED"                          -- Timed completion
ANALYST_COMPLETION_CONTROL = "CONTROL"                      -- Completion after re-gaining control

-- Object types
ANALYST_OTYPE_ITEM = "ITEM"
ANALYST_OTYPE_MONEY = "MONEY"
ANALYST_OTYPE_STRING = "STRING"
ANALYST_OTYPE_ENCHANT = "ENCHANT"
ANALYST_OTYPE_INVOICE = "INVOICE"
ANALYST_OTYPE_CURRENCY = "CURRENCY"


----------------------------------------------------------------------
-- Subsystem

-- One-time initialization
function Analyst:InitializeCapture ()
	-- Client information
	self.db.global.buildInfo = GetBuildInfo()
	self.db.global.locale = GetLocale()
	
	-- Logged in
	self.loggedIn = false
	self.inWorld = false

	-- Timer
	self.finishEventTimer = nil
	
	-- Mouseover
	self.mouseoverName = ""
	self.mouseoverUnit = false
	self.mouseoverObj = ""
	
	-- Spellcast
	self.spellcastMouseoverObj = ""
	self.channeledSpell = ""
	
	-- Pending event
	self.pendingSpell = ""
	self.pendingActivity = ""
	self.pendingDetail = ""
	self.pendingConsumed = ""
	self.pendingProduced = ""
	self.pendingCompletion = ""
	
	-- Current event
	self.activity = ""
	self.detail = ""
	self.consumed = ""
	self.produced = ""
	self.completion = ""
	
	-- Interaction states
	self.merchant = false
	self.bank = false
	self.guildBank = false
	self.trade = false
	self.tradeEnchant = false

	-- Spellls
	self.spells = {
		-- Trade skill lines
		ALCHEMY = GetSpellInfo(2259),
		BLACKSMITHING = GetSpellInfo(2018),
		COOKING = GetSpellInfo(2550),
		ENCHANTING = GetSpellInfo(7411),
		ENGINEERING = GetSpellInfo(4036),
		FIRST_AID = GetSpellInfo(3273),
		INSCRIPTION = GetSpellInfo(45357),
		JEWELCRAFTING = GetSpellInfo(25229),
		LEATHERWORKING = GetSpellInfo(2108),
		TAILORING = GetSpellInfo(3908),
			
		-- Trade skill spells
		ARCHAEOLOGY = GetSpellInfo(73979),
		DISENCHANTING = GetSpellInfo(13262),
		DISENGINEERING = GetSpellInfo(49383),
		EXTRACT_GAS = GetSpellInfo(30427),
		FISHING = GetSpellInfo(7620),
		HERB_GATHERING = GetSpellInfo(2366),
		MILLING = GetSpellInfo(51005),
		MINING = GetSpellInfo(2575),
		PROSPECTING = GetSpellInfo(31252),
		SKINNING = GetSpellInfo(8613),
		
		-- Generic spells
		OPENING = GetSpellInfo(3365),
		OPENING_NO_TEXT = GetSpellInfo(22810)
	}
	
	-- Manage activities
	if not self.db.char.activities then
		self.db.char.activities = { }
	end
	local expireBefore = date("%Y%m%d", self:GetDate() - ANALYST_DATA_LIFETIME * 86400)
	for day in pairs(self.db.char.activities) do
		if day < expireBefore then
			self.db.char.activities[day] = nil
		end
	end
	
	-- Pre-register PLAYER_LOGIN event (may be missed otherwise)
	self:RegisterEvent("PLAYER_LOGIN")
end

-- Handles (re-)enabling of the capture subsystem
function Analyst:EnableCapture ()
	-- Register events
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_CLOSED")
	self:RegisterEvent("LFG_COMPLETION_REWARD")
	self:RegisterEvent("CHAT_MSG_MONEY")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("PLAYER_MONEY")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("GUILDBANKFRAME_OPENED")
	self:RegisterEvent("GUILDBANKFRAME_CLOSED")
	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")
	self:RegisterEvent("TRADE_SHOW")
	self:RegisterEvent("TRADE_CLOSED")
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")
	
	-- Hook the WOW API
	self:HookScript(GameTooltip, "OnShow")
	self:SecureHook("UseContainerItem")
	self:SecureHook("PickupContainerItem")
	self:SecureHook("UseInventoryItem")
	self:SecureHook("PickupInventoryItem")
	self:SecureHook("UseAction")
	self:SecureHook("DoTradeSkill")
	self:SecureHook("SolveArtifact")
	self:SecureHook("PickupMerchantItem")
	self:SecureHook("BuyMerchantItem")
	self:SecureHook("BuybackItem")
	self:SecureHook("RepairAllItems")
	self:SecureHook("AcceptQuest")
	self:SecureHook("GetQuestReward")
	self:SecureHook("AbandonQuest")
	self:SecureHook("TakeInboxItem")
	self:SecureHook("TakeInboxMoney", "TakeInboxItem")
	self:SecureHook("AutoLootMailItem", "TakeInboxItem")
	self:SecureHook("SendMail")
	self:SecureHook("StartAuction")
	self:SecureHook("PlaceAuctionBid")
	self:SecureHook("DepositGuildBankMoney")
	self:SecureHook("WithdrawGuildBankMoney")
	self:SecureHook("PickupGuildBankItem")
	self:SecureHook("AutoStoreGuildBankItem")
	self:SecureHook("TakeTaxiNode")
 	self:SecureHook("BuyTrainerService")
	self:SecureHook("ConfirmTalentWipe")
	self:SecureHook("AcceptSockets")
	self:SecureHook("PurchaseSlot")
	--self:SecureHook("BuyPetition")
	self:SecureHook("BuyGuildCharter")
	self:SecureHook(TabardModel, "Save")
	--self:SecureHook("BuyStableSlot")
	self:SecureHook("BuyGuildBankTab")
	self:SecureHook("DeleteCursorItem")
	
	-- Initialization
	self:InitContainers()
	self:InitMoney()
	self:InitCurrencies()
end

-- Handles disabling of the capture subsystem
function Analyst:DisableCapture ()
end


----------------------------------------------------------------------
-- Player

-- Handles the login of a player
function Analyst:PLAYER_LOGIN ()
	-- Logged in
	self.loggedIn = true
end


-- Handles the logout of a player
function Analyst:PLAYER_LOGOUT ()
	-- Logged out
	self.loggedIn = false
	
	-- Finish any pending event
	self:FinishEvent()
end

-- Handles the player entering world event
function Analyst:PLAYER_ENTERING_WORLD ()
	self:ScheduleTimer("EnteredWorld", 6.0)
end

-- Handles the player leaving world event
function Analyst:PLAYER_LEAVING_WORLD ()
	self.inWorld = false
end

-- Player has entered world
function Analyst:EnteredWorld ()
	-- Scan containers
	self:InitContainers()
	self:InitMoney()
	self:InitCurrencies()
	
	-- Update player data
	self.db.char.realmName = GetRealmName()
	self.db.char.name = UnitName("player")
	self.db.char.level = UnitLevel("player")
	self.db.char.race = UnitRace("player")
	self.db.char.class = UnitClass("player")
	self.db.char.professions = { }
	for i = 1, 2 do
		local professionId = select(i, GetProfessions())
		if professionId then
			local profession = GetProfessionInfo(professionId)
			table.insert(self.db.char.professions, profession)
		end
	end
	
	-- In world
	self.inWorld = true
end


----------------------------------------------------------------------
-- Mouseover objects

-- Get information on current mouseover unit or ressource node
function Analyst:OnShow (tooltip, ...)
	-- Set current mouseover obj
	local firstLine = getglobal("GameTooltipTextLeft1");
	if firstLine then
		self.mouseoverName = firstLine:GetText()
		self.mouseoverUnit = UnitExists("mouseover")
		self.mouseoverObj = self:CreateString(self.mouseoverName)
	end
end


----------------------------------------------------------------------
-- Spellcast

-- Handles entry into combat
function Analyst:PLAYER_REGEN_DISABLED ()
	-- Performance optimization for raids, really
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	
	-- Clear the pending event
	self:ClearPendingEvent()
end

-- Handles exit from combat
function Analyst:PLAYER_REGEN_ENABLED ()
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
end

-- Handles start of spellcast (sent to server)
function Analyst:UNIT_SPELLCAST_SENT (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end
	
	-- Save the mouseoverobj at the time of start of spellcast
	self.spellcastMouseoverObj = self.mouseoverObj
end

-- Handles start of channeled spell
function Analyst:UNIT_SPELLCAST_CHANNEL_START (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end
	
	-- Set the channeled spell
	self.channeledSpell = spell

	-- Check for pending spell or generic casting
	if self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		self:SetEvent(
			ANALYST_ACTIVITY_CASTING,
			self:CreateString(spell),
			"",
			"",
			ANALYST_COMPLETION_CHANNEL)
	end
end

-- Handles stop of channeled spell
function Analyst:UNIT_SPELLCAST_CHANNEL_STOP (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end
	
	-- Clear the channeledSpell
	self.channeledSpell = ""

	-- Check for channeled spell
	if self.completion == ANALYST_COMPLETION_CHANNEL then
		self:ScheduleFinishEvent()
	end
end

-- Handles successful spellcast
function Analyst:UNIT_SPELLCAST_SUCCEEDED (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end

	-- Check for profession activities resulting in loot
	if spell == self.spells.ARCHAEOLOGY then
		self:SetEvent(
			ANALYST_ACTIVITY_ARCHAEOLOGY,
			"",
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.DISENCHANTING then
		self:SetEvent(
			ANALYST_ACTIVITY_DISENCHANTING,
			"",
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.DISENGINEERING then
		self:SetEvent(
			ANALYST_ACTIVITY_DISENGINEERING,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.EXTRACT_GAS then
		self:SetEvent(
			ANALYST_ACTIVITY_EXTRACT_GAS,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.HERB_GATHERING then
		self:SetEvent(
			ANALYST_ACTIVITY_HERB_GATHERING,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.MINING then
		self:SetEvent(
			ANALYST_ACTIVITY_MINING,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.MILLING then
		self:SetEvent(
			ANALYST_ACTIVITY_MILLING,
			"",
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.PROSPECTING then
		self:SetEvent(
			ANALYST_ACTIVITY_PROSPECTING,
			"",
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif spell == self.spells.SKINNING then
		self:SetEvent(
			ANALYST_ACTIVITY_SKINNING,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	end
	
	-- Check for pending spell, opening, or generic casting
	if spell == self.pendingSpell then
		self:SetEventFromPending()
	elseif spell == self.spells.OPENING or spell == self.spells.OPENING_NO_TEXT then
		self:SetEvent(
			ANALYST_ACTIVITY_OPENING,
			self.spellcastMouseoverObj,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	elseif self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		self:SetEvent(
			ANALYST_ACTIVITY_CASTING,
			self:CreateString(spell),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	end
	if self.completion == ANALYST_COMPLETION_SPELLCAST then
		self:ScheduleFinishEvent()
	end
end

-- Handles interrupted spellcasts
function Analyst:UNIT_SPELLCAST_INTERRUPTED (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end
	
	-- Clear the pending event
	self:ClearPendingEvent()
end

-- Handles failed spellcasts
function Analyst:UNIT_SPELLCAST_FAILED (event, unit, spell)
	-- Don't process foreign events
	if unit ~= "player" or not self.loggedIn or not self.inWorld then
		return
	end
	
	-- Clear the pending event
	self:ClearPendingEvent()
end


----------------------------------------------------------------------
-- Loot

-- Handles the opening of the loot box
function Analyst:LOOT_OPENED ()
	-- Handle fishing
	if self.channeledSpell == self.spells.FISHING then
		self:SetEvent(
			ANALYST_ACTIVITY_FISHING,
			"",
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	end

	-- Handle loot resulting from use
	if self.activity == ANALYST_ACTIVITY_USING then
		self:SetEvent(
			ANALYST_ACTIVITY_OPENING,
			self.detail,
			"",
			"",
			ANALYST_COMPLETION_LOOT)
	end
	
	-- Handle cases where we do not know yet what is looted
	if self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		local unitName = UnitName("target")
		if unitName then
			-- Corpse loot
			self:SetEvent(
				ANALYST_ACTIVITY_LOOTING,
				self:CreateString(unitName),
				"",
				"",
				ANALYST_COMPLETION_LOOT)
		end
	end
end

-- Handels the completion of an LFG goal.
function Analyst:LFG_COMPLETION_REWARD ()
	-- Setup a loot event - just in case nothing else happens which opens
	-- such an event.
	self:SetEvent(
		ANALYST_ACTIVITY_LOOTING,
		self:CreateString(GetLFGCompletionReward()),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Intercepts the closing of the loot box
function Analyst:LOOT_CLOSED ()
	if self.completion == ANALYST_COMPLETION_LOOT then
		self:ScheduleFinishEvent()
	end
end

-- Handles party/raid money loots
function Analyst:CHAT_MSG_MONEY (event, message)
	if (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 1) and
		self:MatchFormat(message, LOOT_MONEY_SPLIT) then
		self:SetEvent(
			ANALYST_ACTIVITY_LOOTING,
			self:CreateString(L["GROUPED"]),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end

-- Handles loots
function Analyst:CHAT_MSG_LOOT (event, message)
	-- Handle grouped loots and pushes.
	if (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 1) and
			(self:MatchFormat(message, LOOT_ITEM_SELF)
			or self:MatchFormat(message, LOOT_ITEM_SELF_MULTIPLE)
			or self:MatchFormat(message, LOOT_ITEM_PUSHED_SELF)
			or self:MatchFormat(message, LOOT_ITEM_PUSHED_SELF_MULTIPLE)) then
		self:SetEvent(
			ANALYST_ACTIVITY_LOOTING,
			self:CreateString(L["GROUPED"]),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
	
	-- Handle currency gains
	if self:MatchFormat(message, L["LOOT_CURRENCY"]) 
			or self:MatchFormat(message, L["LOOT_CURRENCY_MULTIPLE"]) then
		self:SetEvent(
			ANALYST_ACTIVITY_UNKNOWN,
			self:CreateString(self:CreateLocation()),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end


----------------------------------------------------------------------
-- Container and inventory

-- Initializes the container tracking
function Analyst:InitContainers ()
	self.container = { }
	self:ScanContainers(false)
end

-- Detects container changes
function Analyst:ScanContainers (processDelta)
	-- Prepare
	for itemId in pairs(self.container) do
		self.container[itemId].lastCount = self.container[itemId].count
		self.container[itemId].count = 0
	end

	-- Get current counts
	self:ScanContainer(0) -- backpack
	for i = 1, NUM_BAG_SLOTS do -- regular bags
		self:ScanContainer(i)
	end
	self:ScanContainer(KEYRING_CONTAINER) -- key ring
	if self.bank then
		self:ScanContainer(BANK_CONTAINER) -- bank window
		for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do -- bank bags
			self:ScanContainer(i)
		end
	end
	for i = 0, 19 do -- inventory
		local itemLink = GetInventoryItemLink("player", i)
		if itemLink then
			local itemId = self:GetItemId(self:GetItemString(itemLink))
			local itemCount = GetInventoryItemCount("player", i)
			if not self.container[itemId] then
				self.container[itemId] = { }
				self.container[itemId].lastCount = 0
				self.container[itemId].count = itemCount
			else
				self.container[itemId].count = self.container[itemId].count + itemCount
			end
		end
	end
	
	-- Check for differences
	if processDelta then
		for itemId in pairs(self.container) do
			local count = self.container[itemId].count
			local lastCount = self.container[itemId].lastCount
			if count > lastCount then
				self:AddEventProduced(self:CreateItem(itemId, count - lastCount))
			elseif count < lastCount then
				self:AddEventConsumed(self:CreateItem(itemId, lastCount - count))
			end
		end
	end
end

-- Scans a single container
function Analyst:ScanContainer (bagId)
	local numSlots = GetContainerNumSlots(bagId)
	for i = 1, numSlots do
		local itemLink = GetContainerItemLink(bagId, i)
		if itemLink then
			local itemId = self:GetItemId(self:GetItemString(itemLink))
			local _, itemCount = GetContainerItemInfo(bagId, i)
			if not self.container[itemId] then
				self.container[itemId] = { }
				self.container[itemId].lastCount = 0
				self.container[itemId].count = itemCount
			else
				self.container[itemId].count = self.container[itemId].count + itemCount
			end
		end
	end
end

-- Handles changes in the player containers
function Analyst:BAG_UPDATE ()
	if not self.loggedIn or not self.inWorld  then
		return
	end
	self:ScanContainers(true)
end

-- Handles the use of a container item, i.e. right click
function Analyst:UseContainerItem (bag, slot)
	-- Make sure there is an item
	local itemLink = GetContainerItemLink(bag, slot)
	if not itemLink then
		return
	end
	
	-- Handle special interactions
	if self.merchant then
		if InRepairMode() then
			self:SetEvent(
				ANALYST_ACTIVITY_REPAIRING,
				self:CreateString(ANALYST_REPAIRING_PLAYER),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
		else
			self:SetEvent(ANALYST_ACTIVITY_VENDORING, "", "", "", ANALYST_COMPLETION_TIMED)
		end
		return
	elseif self.guildBank then
		self:SetEvent(ANALYST_ACTIVITY_GUILD_BANKING, "", "", "", ANALYST_COMPLETION_TIMED)
		return
	end
	
	-- Handle only cases where we do not know yet what the item is used for
	if self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		local itemId = self:GetItemId(self:GetItemString(itemLink))
		self:SetEvent(
			ANALYST_ACTIVITY_USING,
			self:CreateItem(itemId, 1),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end

-- Handles the pickup of a container item, i.e. left click
function Analyst:PickupContainerItem (bag, slot)
	-- Handle special interactions
	if self.merchant then
		if InRepairMode() then
			self:SetEvent(
				ANALYST_ACTIVITY_REPAIRING,
				self:CreateString(ANALYST_REPAIRING_PLAYER),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
		end
	elseif self.guildBank then
		self:SetEvent(
			ANALYST_ACTIVITY_GUILD_BANKING,
			"",
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end

-- Handles the use of an inventory item, i.e. right click
function Analyst:UseInventoryItem (slot)
	-- Make sure there is an item
	local itemLink = GetInventoryItemLink("player", slot)
	if not itemLink then
		return
	end
	
	-- Handle merchant interaction
	if self.merchant then
		if InRepairMode() then
			self:SetEvent(
				ANALYST_ACTIVITY_REPAIRING,
				self:CreateString(ANALYST_REPAIRING_PLAYER),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
			return
		end
	end
	
	-- Handle only cases where we do not know yet what the item is used for
	if self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		local itemId = self:GetItemId(self:GetItemString(itemLink))
		self:SetEvent(
			ANALYST_ACTIVITY_USING,
			self:CreateItem(itemId, 1),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end

-- Handles pickup of inventory item, i.e. left click
function Analyst:PickupInventoryItem (slot)
	-- Handle merchant interaction
	if self.merchant then
		if InRepairMode() then
			self:SetEvent(
				ANALYST_ACTIVITY_REPAIRING,
				self:CreateString(ANALYST_REPAIRING_PLAYER),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
		end
	end
end


----------------------------------------------------------------------
-- Actions

-- Handles the use of an action
function Analyst:UseAction (slot)
	-- Handle only cases where we do not know yet what the item is used for
	if self.activity == "" or self.completion == ANALYST_COMPLETION_TIMED then
		local type, itemId = GetActionInfo(slot)
		if type == "item" then
			self:SetEvent(
				ANALYST_ACTIVITY_USING,
				self:CreateItem(itemId, 1),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
		end
	end
end


----------------------------------------------------------------------
-- Money

-- Initializes the money tracking
function Analyst:InitMoney ()
	self.money = GetMoney()
end

-- Handles changes in the player money
function Analyst:PLAYER_MONEY ()
	if not self.loggedIn or not self.inWorld then
		return
	end
	local money = GetMoney()
	if money > self.money then
		self:AddEventProduced(self:CreateMoney(money - self.money))
	elseif money < self.money then
		self:AddEventConsumed(self:CreateMoney(self.money - money))
	end
	self.money = money
end


----------------------------------------------------------------------
-- Currency

-- Initializes the currencies
function Analyst:InitCurrencies ()
	self.currencies = { }
	self:ScanCurrencies()
end

-- Scans the currencies
function Analyst:ScanCurrencies (processDelta)
	-- Regular currencies
	local size = GetCurrencyListSize()
	local name, isHeader, count
	for i = 1, size do
		local name, isHeader, _, _, _, count = GetCurrencyListInfo(i)
		if name and not isHeader then
			local lastCount = self.currencies[name] or 0
			self.currencies[name] = count
			if processDelta then
				if count > lastCount then
					self:AddEventProduced(self:CreateCurrency(name, count - lastCount))
				elseif count < lastCount then
					self:AddEventConsumed(self:CreateCurrency(name, lastCount - count))
				end
			end
		end
	end
	
	-- Archaeology
	for i = 1, GetNumArchaeologyRaces() do
		if GetNumArtifactsByRace(i) > 0 then
			local name = GetArchaeologyRaceInfo(i)
			SetSelectedArtifact(i)
			local base, adjust, totalCost = GetArtifactProgress()
			local count = base + adjust
			local lastCount = self.currencies[name] or 0
			self.currencies[name] = count
			if processDelta then
				if count > lastCount then
					self:AddEventProduced(self:CreateCurrency(name, count - lastCount))
				elseif count < lastCount then
					self:AddEventConsumed(self:CreateCurrency(name, lastCount - count))
				end
			end
		end
	end
end

-- Handles changes in the currencies
function Analyst:CURRENCY_DISPLAY_UPDATE ()
	if not self.loggedIn or not self.inWorld then
		return
	end
	self:ScanCurrencies(true)
end


----------------------------------------------------------------------
-- Trade skill

-- Handles the start of trade skill activity
function Analyst:DoTradeSkill (index)
	local tradeSkillLine = GetTradeSkillLine()
	if tradeSkillLine == self.spells.ALCHEMY then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_ALCHEMY,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.BLACKSMITHING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_BLACKSMITHING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.COOKING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_COOKING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.ENCHANTING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_ENCHANTING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.ENGINEERING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_ENGINEERING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.FIRST_AID then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_FIRST_AID,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.INSCRIPTION then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_INSCRIPTION,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.JEWELCRAFTING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_JEWELCRAFTING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.LEATHERWORKING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_LEATHERWORKING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.MINING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_SMELTING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	elseif tradeSkillLine == self.spells.TAILORING then
		self:SetPendingEvent(
			ANALYST_ACTIVITY_TAILORING,
			self:CreateEnchant(self:GetEnchantId(self:GetEnchantString(GetTradeSkillRecipeLink(index)))),
			"",
			"",
			ANALYST_COMPLETION_SPELLCAST)
	end
	self.pendingSpell = GetTradeSkillInfo(index)
end

-- Handles artifact solving
function Analyst:SolveArtifact ()
	self:SetPendingEvent(
		ANALYST_ACTIVITY_ARCHAEOLOGY_SOLVE,
		"",
		"",
		"",
		ANALYST_COMPLETION_SPELLCAST)
	self.pendingSpell = GetSelectedArtifactInfo()
end

----------------------------------------------------------------------
-- Merchant

-- Handles the opening of the merchant window
function Analyst:MERCHANT_SHOW ()
	-- Set merchant flag
	self.merchant = true
	
	-- Fix-up pending event from auto-sell add-on
	if self.activity == ANALYST_ACTIVITY_USING then
		self.activity = ANALYST_ACTIVITY_VENDORING
	end
end

-- Handles the closing of the merchant window
function Analyst:MERCHANT_CLOSED ()
	self.merchant = false
end

-- Handles special case of merchant item pickup
function Analyst:PickupMerchantItem (index)
	if index == 0 then
		-- This implies selling
		self:SetEvent(ANALYST_ACTIVITY_VENDORING, "", "", "", ANALYST_COMPLETION_TIMED)
	end
end

-- Handles the buying of an item
function Analyst:BuyMerchantItem ()
	self:SetEvent(ANALYST_ACTIVITY_VENDORING, "", "", "", ANALYST_COMPLETION_TIMED)
end

-- Handles the buyback of an item
function Analyst:BuybackItem ()
	self:SetEvent(ANALYST_ACTIVITY_VENDORING, "", "", "", ANALYST_COMPLETION_TIMED)
end

-- Handles the repair of all items
function Analyst:RepairAllItems (guildBank)
	local repairAllCost = GetRepairAllCost()
	if repairAllCost == 0 then
		return
	end
	if guildBank then
		self:SetEvent(
			ANALYST_ACTIVITY_REPAIRING,
			self:CreateString(ANALYST_REPAIRING_GUILD_BANK),
			self:CreateMoney(repairAllCost),
			"",
			ANALYST_COMPLETION_IMMEDIATE)
	else
		self:SetEvent(
			ANALYST_ACTIVITY_REPAIRING,
			self:CreateString(ANALYST_REPAIRING_PLAYER),
			self:CreateMoney(repairAllCost),
			"",
			ANALYST_COMPLETION_IMMEDIATE)
		self.money = self.money - repairAllCost
	end
end


----------------------------------------------------------------------
-- Questing

-- Handles the acceptance of quests
function Analyst:AcceptQuest ()
	self:SetEvent(
		ANALYST_ACTIVITY_QUESTING,
		self:CreateString(GetTitleText()),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the completion of quests
function Analyst:GetQuestReward ()
	self:SetEvent(
		ANALYST_ACTIVITY_QUESTING,
		self:CreateString(GetTitleText()),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the abandoning of quests
function Analyst:AbandonQuest ()
	self:SetEvent(
		ANALYST_ACTIVITY_QUESTING,
		self:CreateString(GetTitleText()),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end


---------------------------------------------------------------------
-- Mail

-- Handles the removal of items from inbox items
function Analyst:TakeInboxItem (index)
	-- Check if thre is an invoice
	local invoiceType, itemName, _, bid, buyout, deposit, consignment = GetInboxInvoiceInfo(index)
	if invoiceType == "seller" then
		-- Seller invoice
		self:SetEvent(
			ANALYST_ACTIVITY_SOLD,
			self:CreateInvoice(itemName, bid, buyout, deposit, consignment),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
		return
	end
	if invoiceType == "buyer" then
		-- Buyer invoice
		self:SetEvent(
			ANALYST_ACTIVITY_BOUGHT,
			self:CreateInvoice(itemName, bid, buyout, deposit, consignment),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
		return
	end
	
	-- Check for well-known auction messages
	local _, _, sender, subject = GetInboxHeaderInfo(index)
	if sender and string.find(sender, "%s") then
		-- Sender contains white space
		local found, itemName = self:MatchFormat(subject, AUCTION_EXPIRED_MAIL_SUBJECT)
		if found then
			-- Auction expired (seller)
			self:SetEvent(
				ANALYST_ACTIVITY_EXPIRED,
				self:CreateString(itemName),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
			return
		end
		found, itemName = self:MatchFormat(subject, AUCTION_REMOVED_MAIL_SUBJECT)
		if found then
			-- Auction cancelled (seller)
			self:SetEvent(
				ANALYST_ACTIVITY_CANCELLED,
				self:CreateString(itemName),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
			return
		end
		found, itemName = self:MatchFormat(subject, AUCTION_OUTBID_MAIL_SUBJECT)
		if found then
			-- Outbid on auction (buyer)
			self:SetEvent(
				ANALYST_ACTIVITY_OUTBID,
				self:CreateString(itemName),
				"",
				"",
				ANALYST_COMPLETION_TIMED)
			return
		end
	end
	
	-- Default
	self:SetEvent(ANALYST_ACTIVITY_RECEIVING, "", "", "", ANALYST_COMPLETION_TIMED)
end

-- Handles the sending of mail
function Analyst:SendMail (target, subject, body)
	if GetSendMailItem() or GetSendMailMoney() then
		self:SetEvent(ANALYST_ACTIVITY_SENDING, "", "", "", ANALYST_COMPLETION_TIMED)
	end
end


----------------------------------------------------------------------
-- Auction house

-- Handles the start of an auction
function Analyst:StartAuction (minBid, buyout, runTime)
	self:SetEvent(ANALYST_ACTIVITY_POSTING, "", "", "", ANALYST_COMPLETION_TIMED)
end

-- Handles the placing of a bid in the auction house
function Analyst:PlaceAuctionBid (type, index, bid)
	local itemLink = GetAuctionItemLink(type, index)
	local _, _, count = GetAuctionItemInfo(type, index)
	if itemLink then
		local itemId = self:GetItemId(self:GetItemString(itemLink))
		self:SetEvent(
			ANALYST_ACTIVITY_BIDING,
			self:CreateItem(itemId, count),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end


---------------------------------------------------------------------
-- Bank

-- Handles the opening of the bank window
function Analyst:BANKFRAME_OPENED ()
	self.bank = true
	self:InitContainers()
end

-- Handles the closing of the bank windoww
function Analyst:BANKFRAME_CLOSED ()
	self.bank = false
	self:InitContainers()
end


---------------------------------------------------------------------
-- Guild bank

-- Handles the opening of the guild bank window
function Analyst:GUILDBANKFRAME_OPENED ()
	self.guildBank = true
end

-- Handles the closing of the guild bank windoww
function Analyst:GUILDBANKFRAME_CLOSED ()
	self.guildBank = false
end

-- Handles the deposit of guild bank money
function Analyst:DepositGuildBankMoney (copper)
	self:SetEvent(
		ANALYST_ACTIVITY_GUILD_BANKING,
		"",
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the withdrawal of guild bank money
function Analyst:WithdrawGuildBankMoney (copper)
	self:SetEvent(
		ANALYST_ACTIVITY_GUILD_BANKING,
		"",
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the picking up of a guild bank item
function Analyst:PickupGuildBankItem ()
	self:SetEvent(
		ANALYST_ACTIVITY_GUILD_BANKING,
		"",
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the picking up of a guild bank item
function Analyst:AutoStoreGuildBankItem ()
	self:SetEvent(
		ANALYST_ACTIVITY_GUILD_BANKING,
		"",
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end


----------------------------------------------------------------------
-- Taxi

-- Handles taxi
function Analyst:TakeTaxiNode (slot)
	-- Process reachable nodes only
	if TaxiNodeGetType(slot) ~= "REACHABLE" then
		return
	end
	
	-- Find route
	local route = "";
	for i = 1, NumTaxiNodes() do
		if TaxiNodeGetType(i) == "CURRENT" then
			route = self:GetTaxiNodeLocalName(TaxiNodeName(i))
			break
		end
	end
	route = route .. " - " .. self:GetTaxiNodeLocalName(TaxiNodeName(slot))
	self:SetEvent(
		ANALYST_ACTIVITY_TAXI,
		self:CreateString(route),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Returns the local part of a taxi node name
function Analyst:GetTaxiNodeLocalName (taxiNodeName)
	local pos = string.find(taxiNodeName, ",")
	if pos then
		return string.sub(taxiNodeName, 1, pos - 1)
	end
	return taxiNodeName
end
	
-- Handles the loss of control of the player
function Analyst:PLAYER_CONTROL_LOST ()
	if self.activity == ANALYST_ACTIVITY_TAXI then
		if self.completion == ANALYST_COMPLETION_TIMED then
			self:UnscheduleFinishEvent()
			self.completion = ANALYST_COMPLETION_CONTROL
		end
	end
end

-- Handles the regaining of control of the player
function Analyst:PLAYER_CONTROL_GAINED ()
	if self.completion == ANALYST_COMPLETION_CONTROL then
		self:FinishEvent()
	end
end


----------------------------------------------------------------------
-- Trainer

-- Handles the buying of trainer services
function Analyst:BuyTrainerService (index)
	-- Trade skill trainer
	local serviceName = GetTrainerServiceInfo(index)
	if IsTradeskillTrainer() then
		self:SetEvent(
			ANALYST_ACTIVITY_TRADE_SKILL_TRAINING,
			self:CreateString(serviceName),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	else
		self:SetEvent(
			ANALYST_ACTIVITY_TALENT_TRAINING,
			self:CreateString(serviceName),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
end

-- Handles the unlearning of talents
function Analyst:ConfirmTalentWipe ()
	self:SetEvent(
		ANALYST_ACTIVITY_TALENT_WIPING,
		self:CreateString(ANALYST_TALENT_WIPING_PLAYER),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end


----------------------------------------------------------------------
-- Socketing

-- Handles socketing
function Analyst:AcceptSockets ()
	self:SetEvent(ANALYST_ACTIVITY_SOCKETING, "", "", "", ANALYST_COMPLETION_TIMED)
end


----------------------------------------------------------------------
-- Trade

-- Handles begin of trading
function Analyst:TRADE_SHOW ()
	self.trade = true
	self.tradeEnchant = false
end

-- Handles close of trading
function Analyst:TRADE_CLOSED ()
	self.trade = false
end

-- Handles the change of a trade target item
function Analyst:TRADE_TARGET_ITEM_CHANGED (event, slot)
	if slot == 7 then
		-- Untraded slot
		local _, _, _, _, _, tradeEnchant = GetTradeTargetItemInfo(slot)
		self.tradeEnchant = tradeEnchant ~= nil
	end
end

-- Handles completion of trading
function Analyst:UI_INFO_MESSAGE (event, msg)
	if self:MatchFormat(msg, ERR_TRADE_COMPLETE) then
		if not self.tradeEnchant then
			self:SetEvent(ANALYST_ACTIVITY_TRADING, "", "", "", ANALYST_COMPLETION_TIMED)
		else
			-- We consider the trade an Enchanting activity
		end
	end
end


----------------------------------------------------------------------
-- Special purchases

-- Handles the purchase of a bank slot
function Analyst:PurchaseSlot ()
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_BANK_SLOT),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the purchase of a petition
function Analyst:BuyPetition ()
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_PETITION),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the purchase of a guild chater
function Analyst:BuyGuildCharter (guildName)
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_GUILD_CHARTER),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the purchase of a guild crest
function Analyst:Save ()
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_GUILD_CREST),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

-- Handles the purchase of stable slots
function Analyst:BuyStableSlot ()
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_STABLE_SLOT),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end

function Analyst:BuyGuildBankTab ()
	self:SetEvent(
		ANALYST_ACTIVITY_PURCHASING,
		self:CreateString(ANALYST_PURCHASE_GUILD_BANK_TAB),
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end


----------------------------------------------------------------------
-- PvP

-- Handles an honorable kill
function Analyst:PLAYER_PVP_KILLS_CHANGED ()
	-- Count kill immediately
	self:SetEvent(
		ANALYST_ACTIVITY_HONORABLE_KILL,
		"",
		"",
		self:CreateCurrency("Honorable Kill", 1),
		ANALYST_COMPLETION_IMMEDIATE)
end


----------------------------------------------------------------------
-- Destroying

-- Handles destruction of an item
function Analyst:DeleteCursorItem ()
	self:SetEvent(
		ANALYST_ACTIVITY_DESTROYING,
		"",
		"",
		"",
		ANALYST_COMPLETION_TIMED)
end


----------------------------------------------------------------------
-- Event management

-- Sets the pending event
function Analyst:SetPendingEvent (activity, detail, consumed, produced, completion)
	self.pendingActivity = activity
	self.pendingDetail = detail
	self.pendingConsumed = consumed
	self.pendingProduced = produced
	self.pendingCompletion = completion
	self:DebugPendingEvent()
end

-- Clears the pending event
function Analyst:ClearPendingEvent ()
	self.pendingSpell = ""
	self.pendingActivity = ""
	self.pendingDetail = ""
	self.pendingConsumed = ""
	self.pendingProduced = ""
	self.pendingCompletion = ""
end

-- Sets the activity in the pending event
function Analyst:SetPendingEventActivity (activity)
	self.pendingActivity = activity
	self:DebugPendingEvent()
end

-- Sets the detail in the pending event
function Analyst:SetPendingEventDetail (detail)
	self.pendingDetail = detail
	self:DebugPendingEvent()
end

-- Sets the consumed object in the pending event
function Analyst:SetPendingEventConsumed (consumed)
	self.pendingConsumed = consumed
	self:DebugPendingEvent()
end

-- Sets the produced object in the pending event
function Analyst:SetPendingEventProduced (produced)
	self.pendingProduced = produced
	self:DebugPendingEvent()
end

-- Sets the completion in the pending event
function Analyst:SetPendingEventCompletion (completion)
	self.pendingCompletion = completion
	self:DebugPendingEvent()
end

-- Debugs the pending event
function Analyst:DebugPendingEvent ()
	if self:IsDebugging() then
		self:LevelDebug(3, string.format(
			"Pending event [activity=%s] [detail=%s] [consumed=%s] [produced=%s] [completion=%s]",
			self.pendingActivity,
			self:FormatObjects(self.pendingDetail),
			self:FormatObjects(self.pendingConsumed),
			self:FormatObjects(self.pendingProduced),
			self.pendingCompletion))
	end
end

-- Sets the event
function Analyst:SetEvent (activity, detail, consumed, produced, completion)
	-- Finish the open event, if there is a change in the event type (activity, detail completion)
	if activity ~= self.activity or detail ~= self.detail or completion ~= self.completion then
		self:FinishEvent()
	end
	
	-- Set event
	self.activity = activity
	self.detail = detail
	self.consumed = self.consumed .. consumed
	self.produced = self.produced .. produced
	self.completion = completion
	self:DebugEvent()

	-- Handle completions
	if self.completion == ANALYST_COMPLETION_IMMEDIATE then
		self:FinishEvent()
	elseif self.completion == ANALYST_COMPLETION_TIMED then
		self:ScheduleFinishEvent()
	end
end

-- Sets the event from the pending event
function Analyst:SetEventFromPending ()
	self:SetEvent(
		self.pendingActivity,
		self.pendingDetail,
		self.pendingConsumed,
		self.pendingProduced,
		self.pendingCompletion)
end

-- Adds a consumed object to the event
function Analyst:AddEventConsumed (obj)
	-- Handle unknown activities
	if self.activity == "" then
		self:SetEvent(
			ANALYST_ACTIVITY_UNKNOWN,
			self:CreateString(self:CreateLocation()),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
	
	-- Process
	self.consumed = self.consumed .. obj
	self:DebugEvent()
end

-- Adds a produced object to the event
function Analyst:AddEventProduced (obj)
	-- Handle unknown activities
	if self.activity == "" then
		self:SetEvent(
			ANALYST_ACTIVITY_UNKNOWN,
			self:CreateString(self:CreateLocation()),
			"",
			"",
			ANALYST_COMPLETION_TIMED)
	end
	
	-- Process
	self.produced = self.produced .. obj
	self:DebugEvent()
end

-- Schedules finishing of the current event
function Analyst:ScheduleFinishEvent ()
	self.completion = ANALYST_COMPLETION_TIMED
	if self.finishEventTimer and self:TimeLeft(self.finishEventTimer) >= 5.0 then
		return -- prevent high-rate rescheduling
	end
	self:UnscheduleFinishEvent()
	self.finishEventTimer = self:ScheduleTimer("FinishEvent", 5.5)
end

-- Cancels scheduled event finalization
function Analyst:UnscheduleFinishEvent ()
	if self.finishEventTimer then
		self:CancelTimer(self.finishEventTimer)
		self.finishEventTimer = nil
	end
end

-- Finishes the current event
function Analyst:FinishEvent ()
	-- Unschedule any other pending finishings
	self:UnscheduleFinishEvent()
	
	-- Check if the event complete
	if self.activity ~= "" and (self.produced ~= "" or self.consumed ~= "") then
		if self:IsDebugging() then
			self:LevelDebug(2, string.format(
				"Finishing event [activity=%s] [detail=%s] [consumed=%s] [produced=%s]",
				self.activity,
				self:FormatObjects(self.detail),
				self:FormatObjects(self.consumed),
				self:FormatObjects(self.produced)))
		end
		local day = date("%Y%m%d")
		if not self.db.char.activities[day] then
			self.db.char.activities[day] = { }
		end
		table.insert(
			self.db.char.activities[day],
			string.format("%s|%s|%s|%s", self.activity, self.detail, self.consumed, self.produced))
		self:SendMessage("ANALYST_CAPTURE", day, self.activity, self.detail, self.consumed, self.produced)
	end
	
	-- Clear
	self.activity = ""
	self.detail = ""
	self.consumed = ""
	self.produced = ""
	self.completion = ""
end

-- Debugs the event
function Analyst:DebugEvent ()
	if self:IsDebugging() then
		self:LevelDebug(3, string.format(
			"Event [activity=%s] [detail=%s] [consumed=%s] [produced=%s] [completion=%s]",
			self.activity,
			self:FormatObjects(self.detail),
			self:FormatObjects(self.consumed),
			self:FormatObjects(self.produced),
			self.completion))
	end
end


----------------------------------------------------------------------
-- Objects

-- Creates an item object
function Analyst:CreateItem (itemId, count)
	-- Normalize values
	if itemId < 0 then
		self:LevelDebug(1, "Negative item ID")
		return ""
	end
	if itemId > 999999 then
		self:LevelDebug(1, "Item ID too large")
		return ""
	end
	if count < 0 then
		self:LevelDebug(1, "Negative count")
		return ""
	end
	if count > 9999 then
		self:LevelDebug(1, "Count too large")
		return ""
	end
	
	-- Format
	if count == 1 then
		return string.format("I%.6d", itemId)
	else
		return string.format("N%.6d%.4d", itemId, count)
	end
end

-- Create a money object
function Analyst:CreateMoney (copper)
	-- Normalize
	if copper > 999999999 then
		self:LevelDebug(1, "Money too large")
		return ""
	end
	
	-- Format
	return string.format("M%.9d", copper)
end

-- Creates a string object
function Analyst:CreateString (s)
	-- Normalize
	local length = string.len(s)
	if length > 99 then
		s = string.sub(s, 1, 99)
		length = 99
	end
	
	-- Format
	return string.format("S%.2d%s", length, s)
end

-- Creates an enchant object
function Analyst:CreateEnchant (enchantId)
	-- Normalize
	if enchantId < 0 then
		self:LevelDebug(1, "Negative enchant ID")
		return
	end
	if enchantId > 999999 then
		self:LevelDebug(1, "Enchant ID too large")
		return
	end
	
	-- Format
	return string.format("E%.6d", enchantId)
end

-- Creates an invoice object
function Analyst:CreateInvoice (itemName, bid, buyout, deposit, consignment)
	-- Normalize
	local length = string.len(itemName)
	if length > 99 then
		itemName = string.sub(itemName, 1, 99)
		length = 99
	end
	if bid < 0 then
		self:LevelDebug(1, "Negativ bid")
		return ""
	end
	if bid > 999999999 then
		self:LevelDebug(1, "Bid too large")
		return ""
	end
	if buyout < 0 then
		self:LevelDebug(1, "Negativ buyout")
		return ""
	end
	if buyout > 999999999 then
		self:LevelDebug(1, "Buyout too large")
		return ""
	end
	if deposit < 0 then
		self:LevelDebug(1, "Negativ deposit")
		return ""
	end
	if deposit > 999999999 then
		self:LevelDebug(1, "Deposit too large")
		return ""
	end
	if consignment < 0 then
		self:LevelDebug(1, "Negativ consignment")
		return ""
	end
	if consignment > 999999999 then
		self:LevelDebug(1, "Consignment too large")
		return ""
	end
	
	-- Format
	return string.format("V%.2d%s%.9d%.9d%.9d%.9d", length, itemName, bid, buyout, deposit, consignment)
end

-- Creates a currency object
function Analyst:CreateCurrency (name, count)
	-- Normalize
	local length = string.len(name)
	if length > 99 then
		name = string.sub(name, 1, 99)
		length = 99
	end
	if count < 0 then
		self:LevelDebug(1, "Negative count")
		return ""
	end
	if count > 999999 then
		self:LevelDebug(1, "Count too large")
		return ""
	end
	
	-- Format
	return string.format("C%.2d%s%.6d", length, name, count)
end
	
-- Parses a single object
function Analyst:ParseObject (objs)
	return self:ParseObjects(objs)[1]
end

-- Parses objects
function Analyst:ParseObjects (objs)
	local result = { }
	if not objs then
		return result
	end
	local pos = 1
	local length = string.len(objs)
	while pos <= length do
		local key = string.sub(objs, pos, pos)
		if key == "I" then
			-- Item
			pos = pos + 1
			local itemId = tonumber(string.sub(objs, pos, pos + 5))
			pos = pos + 6
			local obj = {
				objType = ANALYST_OTYPE_ITEM,
				itemId = itemId,
				itemName = self:GetItemInfo(itemId),
				count = 1
			}
			table.insert(result, obj)
		elseif key == "N" then
			-- Multiple items
			pos = pos + 1
			local itemId = tonumber(string.sub(objs, pos, pos + 5))
			pos = pos + 6
			local count = tonumber(string.sub(objs, pos, pos + 3))
			pos = pos + 4
			local obj = {
				objType = ANALYST_OTYPE_ITEM,
				itemId = itemId,
				itemName = self:GetItemInfo(itemId),
				count = count
			}
			table.insert(result, obj)
		elseif key == "M" then
			-- Money
			pos = pos + 1
			local copper = tonumber(string.sub(objs, pos, pos + 8))
			pos = pos + 9
			local obj = {
				objType = ANALYST_OTYPE_MONEY,
				copper = copper
			}
			table.insert(result, obj)
		elseif key == "S" then
			-- String
			pos = pos + 1
			local stringLength = tonumber(string.sub(objs, pos, pos + 1))
			pos = pos + 2
			local s = string.sub(objs, pos, pos + stringLength - 1)
			pos = pos + stringLength
			local obj = {
				objType = ANALYST_OTYPE_STRING,
				s = s
			}
			table.insert(result, obj)
		elseif key == "E" then
			-- Enchant
			pos = pos + 1
			local enchantId = tonumber(string.sub(objs, pos, pos + 5))
			pos = pos + 6
			local obj = {
				objType = ANALYST_OTYPE_ENCHANT,
				enchantId = enchantId,
				enchantName = self:GetEnchantInfo(enchantId)
			}
			table.insert(result, obj)
		elseif key == "V" then
			-- Invoice
			pos = pos + 1
			local itemNameLength = tonumber(string.sub(objs, pos, pos + 1))
			pos = pos + 2
			local itemName = string.sub(objs, pos, pos + itemNameLength - 1)
			pos = pos + itemNameLength
			local bid = tonumber(string.sub(objs, pos, pos + 8))
			pos = pos + 9
			local buyout = tonumber(string.sub(objs, pos, pos + 8))
			pos = pos + 9
			local deposit = tonumber(string.sub(objs, pos, pos + 8))
			pos = pos + 9
			local consignment = tonumber(string.sub(objs, pos, pos + 8))
			pos = pos + 9
			local obj = {
				objType = ANALYST_OTYPE_INVOICE,
				itemName = itemName,
				bid = bid,
				buyout = buyout,
				deposit = deposit,
				consignment = consignment
			}
			table.insert(result, obj)
		elseif key == "C" then
			-- Currency
			pos = pos + 1
			local nameLength = tonumber(string.sub(objs, pos, pos + 1))
			pos = pos + 2
			local name = string.sub(objs, pos, pos + nameLength - 1)
			pos = pos + nameLength
			local count = tonumber(string.sub(objs, pos, pos + 5))
			pos = pos + 6
			local obj = {
				objType = ANALYST_OTYPE_CURRENCY,
				currencyName = name,
				count = count
			}
			table.insert(result, obj)
		else
			self:LevelDebug(1, "Object decoding error")
			break
		end
	end
	return result
end

-- Filters objects for the specified type
function Analyst:FilterObjects (objs, objType)
	local result = { }
	for i in ipairs(objs) do
		if objs[i].objType == objType then
			table.insert(result, objs[i])
		end
	end
	return result
end


-- Decodes objects
function Analyst:FormatObjects (objs)
	local out = ""
	local objects = self:ParseObjects(objs)
	for i in ipairs(objects) do
		if i > 1 then
			out = out .. ", "
		end
		if objects[i].objType == ANALYST_OTYPE_ITEM then
			local _, itemLink = self:GetItemInfo(objects[i].itemId)
			out = out .. itemLink
			if objects[i].count ~= 1 then
				out = out .. "x" .. tostring(objects[i].count)
			end
		elseif objects[i].objType == ANALYST_OTYPE_MONEY then
			out = out .. self:FormatCopper(objects[i].copper)
		elseif objects[i].objType == ANALYST_OTYPE_STRING then
			out = out .. "<" .. objects[i].s .. ">"
		elseif objects[i].objType == ANALYST_OTYPE_ENCHANT then
			local _, enchantLink = self:GetEnchantInfo(objects[i].enchantId)
			out = out .. enchantLink
		elseif objects[i].objType == ANALYST_OTYPE_INVOICE then
			out = out .. string.format(
				"Invoice for %s (bid %s, buyout %s, deposit %s, consignment %s)",
				objects[i].itemName,
				self:FormatCopper(objects[i].bid),
				self:FormatCopper(objects[i].buyout),
				self:FormatCopper(objects[i].deposit),
				self:FormatCopper(objects[i].consignment))
		elseif objects[i].objType == ANALYST_OTYPE_CURRENCY then
			out = out .. "{" .. objects[i].currencyName .. "}"
			if objects[i].count ~= 1 then
				out = out .. "x" .. tostring(objects[i].count)
			end
		else
			out = out .. "(decoding error)"
			break
		end
	end
	return out
end


----------------------------------------------------------------------
-- Helpers

-- Matches a message against a format and returns the first expression (if any)
function Analyst:MatchFormat (msg, fmt)
	-- Create pattern
	local pattern = string.gsub(fmt, "%.", "%.")
	pattern = string.gsub(pattern, "%%s", "(.+)")
	pattern = string.gsub(pattern, "%%d", "(%d+)")
	pattern = "^" .. pattern .. "$"
	
	-- Match
	local found, _, capture = string.find(msg, pattern)
	return found, capture
end

-- Returns the item string given an item link
function Analyst:GetItemString (itemLink)
	local found, _, itemString = string.find(itemLink, "|c%x+|H(.+)|h%[.*%]|h|r")
	if found then
		return itemString
	else
		return nil
	end
end

-- Returns the item ID from an item string
function Analyst:GetItemId (itemString)
	local _, itemId = strsplit(":", itemString)
	return tonumber(itemId)
end

-- Returns item information
function Analyst:GetItemInfo (itemId)
	-- Query client
	local itemName, itemLink = GetItemInfo(itemId)
	if itemName and itemLink then
		return itemName, itemLink
	end
	
	-- Handle lookup failure
	return
		tostring(itemId),
		string.format("|cffff0000|Hitem:%d:0:0:0:0:0:0:0|h[%d]|h|r", itemId, itemId)
end

-- Returns the enchant string from an enchant link
function Analyst:GetEnchantString (enchantLink)
	local found, _, enchantString = string.find(enchantLink, "|c%x+|H(.+)|h%[.*%]|h|r")
	if found then
		return enchantString
	end
	return nil
end

-- Returns the enchant ID from an enchant string
function Analyst:GetEnchantId (enchantString)
	local _, enchantId = strsplit(":", enchantString)
	return tonumber(enchantId)
end

-- Returns enchant information
function Analyst:GetEnchantInfo (enchantId)
	local enchantName = GetSpellInfo(enchantId)
	return
		enchantName,
		string.format("|cffffd000|Henchant:%d|h[%s]|h|r", enchantId, enchantName)
end

-- Creates a string with the current location
function Analyst:CreateLocation ()
	local zoneText = GetRealZoneText()
	SetMapToCurrentZone()
	local x, y = GetPlayerMapPosition("player")
	return string.format("%s (%.0f,%.0f)", zoneText, x * 100.0, y * 100.0)
end