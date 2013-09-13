local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Factions module
local Factions = Addon:NewModule("Factions")

-- local functions
local pairs   = pairs
local tinsert = table.insert

local CollapseFactionHeader        = _G.CollapseFactionHeader
local ExpandFactionHeader          = _G.ExpandFactionHeader
local GetFactionInfo               = _G.GetFactionInfo
local GetFriendshipReputation      = _G.GetFriendshipReputation
local GetFriendshipReputationRanks = _G.GetFriendshipReputationRanks
local GetNumFactions               = _G.GetNumFactions

-- aux variables
local _

-- setup libs
local LibStub   = LibStub

-- module data
local moduleData = {
}

local friendStanding = {
	[0] = "Stranger",
	[1] = "Acquaintance",
	[2] = "Buddy",
	[3] = "Friend",
	[4] = "Good Friend",
	[5] = "Best Buddy",
}

local blizzRepColors = {
	[1] = {r=0.80, g=0.13, b=0.13, a=1}, -- hated
	[2] = {r=1.00, g=0.25, b=0.00, a=1}, -- hostile
	[3] = {r=0.93, g=0.40, b=0.13, a=1}, -- unfriendly
	[4] = {r=1.00, g=1.00, b=0.00, a=1}, -- neutral
	[5] = {r=0.00, g=0.70, b=0.00, a=1}, -- friendly
	[6] = {r=0.00, g=1.00, b=0.00, a=1}, -- honoured
	[7] = {r=0.00, g=0.60, b=1.00, a=1}, -- revered
	[8] = {r=0.00, g=1.00, b=1.00, a=1}, -- exalted
}

-- module handling
function Factions:OnInitialize()	
	self:Setup()
end

function Factions:OnEnable()
	-- empty
end

function Factions:OnDisable()
	-- empty
end

function Factions:Setup()
end

function Factions:GetFactionInfo(factionId)
	return self:GetFactionInfoByIdOrIndex(factionId)
end

function Factions:GetFactionInfoByIndex(factionIndex)
	return self:GetFactionInfoByIdOrIndex(nil, factionIndex)
end

-- reputation interface (merging friendship into rep)
function Factions:GetFactionInfoByIdOrIndex(factionId, factionIndex)
	local useId = true

	if type(factionId) ~= "number" or factionId < 1 then
		if type(factionIndex) ~= "number" or factionIndex < 1 or factionIndex > GetNumFactions() then
			return
		else
			useId = false
		end
	end
	
	local name, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild

	if useId then
		name, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfoByID(factionId)		
	else
		name, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionId = GetFactionInfo(factionIndex)
	end
	
	-- faction not found
	if not name then
		return
	end
	
	local currentRank, maxRank = GetFriendshipReputationRanks(factionId)

	local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionId)
	if friendID ~= nil then		
		standingId = currentRank
		
		-- store localized standing text
		friendStanding[standingId] = friendTextLevel
		
		barMin   = friendThreshold
		barMax   = nextFriendThreshold or barMin + 1000
		barValue = friendRep
	end
	
	local atMax = standingId == maxRank and barValue + 1 == barMax
	
	return name, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionId, friendID, atMax
end

-- NOTE: does not restore folding state of ui list because that would invalidate the returned index
function Factions:GetFactionIndex(factionId)
	if not factionId then
		return 0
	end
	
	for index, id in Factions:IterateAllFactions() do
		local _, _, _, _, _, _, _, _, _, _, _, _, _, id = self:GetFactionInfo(id)
		
		if factionId == id then
			return index
		end
	end
	
	return 0
end

-- NOTE: does not restore folding state of ui list because that would invalidate the returned index
function Factions:GetFactionIndexByName(factionName, expand)
	if not factionName then
		return 0
	end
	
	for index, id in Factions:IterateAllFactions() do
		local name = self:GetFactionInfo(id)
		
		if factionName == name then
			return index
		end
	end
	
	return 0
end

function Factions:GetFactionByName(factionName)
	if not factionName then
		return
	end
	
	local factionId
	
	for index, id in Factions:IterateAllFactions() do
		local name, _, _, _, _, _, _, _, _, _, _, _, _, id = self:GetFactionInfo(id)
		
		if factionName == name then
			factionId = id
			
			break
		end
	end
	
	-- restore folding state of factions in ui list
	self:RestoreUI()
	
	return factionId
end

function Factions:GetStandingLabel(standing, friend)
	if friend then
		return friendStanding[standing] or "???"
	else
		return _G["FACTION_STANDING_LABEL"..tostring(standing)] or "???"
	end
end

function Factions:GetBlizzardReputationColor(standing, friendship)
	local r, g, b, a = 0, 0, 0, 0
	
	if type(standing) == "number" then
		if friendship then
			standing = standing + 2
		end
	
		if blizzRepColors[standing] then
			r = blizzRepColors[standing].r
			g = blizzRepColors[standing].g
			b = blizzRepColors[standing].b
			a = blizzRepColors[standing].a
		end
	end
		
	return r, g, b, a
end

function Factions:GetFactionName(faction)
	local name = self:GetFactionInfo(faction) or ""

	return name
end

-- iterators

local unfoldedHeaders = {}

-- iterator that unfolds the ui so all factions can be accessed
function Factions:IterateAllFactions()
	-- in case RestoreUI has not been called
	NS:ClearTable(unfoldedHeaders)
	
	local index  = 0
	local unfold = false
	
	return function()
		if unfold then
			ExpandFactionHeader(index)
			
			tinsert(unfoldedHeaders, index)
		end
		
		index = index + 1
		
		if index <= GetNumFactions() then
			local name, _, _, _, _, _, _, _, isHeader, isCollapsed, _, _, _, factionId = Factions:GetFactionInfoByIndex(index)
			
			unfold = isHeader and isCollapsed
			
			return index, factionId
		end
	end
end

-- function to restore ui state before the last iterator call
function Factions:RestoreUI()
	-- collapse in reverse order
	for index = #unfoldedHeaders, 1, -1 do
		CollapseFactionHeader(unfoldedHeaders[index])
	end
		
	NS:ClearTable(unfoldedHeaders)
end	

-- test
function Factions:Debug(msg)
	Addon:Debug("(Factions) " .. tostring(msg))
end
