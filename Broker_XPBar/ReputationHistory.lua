local _G = _G

local Addon = _G.BrokerXPBar

-- local functions
local pairs   = pairs
local tinsert = table.insert
local tremove = table.remove
local tgetn   = table.getn
local time    = time
local sqrt    = math.sqrt
local floor   = math.floor
local ceil    = math.ceil

local GetFactionInfo = _G.GetFactionInfo
local GetNumFactions = _G.GetNumFactions

local _

-- helper functions
local function FormatTime(stamp)
	local days    = floor(stamp/86400)
	local hours   = floor((stamp - days * 86400) / 3600)
	local minutes = floor((stamp - days * 86400 - hours * 3600) / 60)

	if days > 0 then
		return string.format("%dd %02d:%02d", days, hours, minutes)
	else
		return string.format("%02d:%02d", hours, minutes)
	end
end

-- constants
local MAX_HISTORY = 12
local MAX_TIME_MINUTES = 120

local ReputationHistory = {
	-- data
	startTime     = nil,
	factions      = {},
		
	-- params
	weight        = 0.5,
	timeframe     = 3600,
}

Addon.ReputationHistory = ReputationHistory

function ReputationHistory:Initialize()
	self.startTime = time()
	
	for faction in pairs(self.factions) do
		self.factions[faction] = nil
	end
end

-- reputation rate calculations
function ReputationHistory:InitFaction(faction)
	if self.factions[faction] then
		return nil
	end

	local _, _, standing, minRep, maxRep, currentRep, _, _, isHeader, _, hasRep = GetFactionInfo(faction)
	
	if isHeader and not hasRep then
		return nil
	end

	local data = {
		startRep      = currentRep,
		totalRep      = 0,
		activityRep   = 0,
		tainted       = false,
		activeBucket  = floor(time() / 60) - 1,
		history       = {},
	}
	
	self.factions[faction] = data
	
	return data
end

function ReputationHistory:GetWriteBucket(faction)
	if not self.factions[faction] then
		return nil
	end

	local history = self.factions[faction].history
	
	local bucketTime = floor(time() / 60)
	local bucket = history[#history]
	
	if not bucket or bucket.time ~= bucketTime then
		bucket = {
			time       = bucketTime,
			reputation = 0,
		}
		tinsert(history, bucket)
	end
	
	return bucket
end

function ReputationHistory:GetTimeToLevel(faction)
	if not self.factions[faction] then 
		return "~"
	end
	
	local data = self.factions[faction]
	
	if data.totalRep == 0 then
		return "~"
	end

	local duration = time() - self.startTime

	if duration == 0 then
		return "~"
	end

	local _, _, _, minRep, maxRep, currentRep = GetFactionInfo(faction)
	local toLvlRep = maxRep - currentRep
	
	-- rep/s (current)
	local repPerSec = self:GetRepPerSecond(faction)

	if not repPerSec or repPerSec == 0 then
		return "~"
	end
	
	local ttl = toLvlRep / repPerSec
	
	return FormatTime(ttl)
end

function ReputationHistory:GetRepPerHour(faction)
	local rps = self:GetRepPerSecond(faction)

	return rps * 3600
end

function ReputationHistory:GetRepPerSecond(faction)
	if not self.factions[faction] then 
		return 0
	end
	
	local data = self.factions[faction]
	
	local duration = time() - self.startTime

	if duration == 0 then
		return 0
	end

	if self.timeframe == 0 or duration < self.timeframe then
		return data.totalRep / duration
	else		
		return ((data.activityRep / self.timeframe) * self.weight + (data.totalRep / duration) * (1-self.weight))
	end
end

function ReputationHistory:GetTotalRep(faction)
	if not self.factions[faction] then 
		return 0
	end
	
	return self.factions[faction].totalRep
end

function ReputationHistory:Process()
	-- TODO for all factions process
	for faction, data in pairs(self.factions) do
		self:ProcessFaction(faction)
	end
end

function ReputationHistory:ProcessFaction(faction)
	if not self.factions[faction] then 
		return 
	end

	local data = self.factions[faction]
	local currentBucket = floor(time() / 60)

	if not data.tainted and currentBucket == data.activeBucket then 
		return 
	end
		
	data.activeBucket = currentBucket
	
	-- remove old buckets
	local oldest = data.activeBucket - MAX_TIME_MINUTES
	
	while #data.history ~= 0 and data.history[1].time <= oldest do
		tremove(data.history, 1)
	end

	local reputation = 0
	
	oldest = data.activeBucket - self.timeframe / 60

	for _, bucket in pairs(data.history) do
		if bucket.time > oldest then
			reputation = reputation + bucket.reputation
		end
	end

	data.activityRep = reputation
	
	data.tainted = false	
end

function ReputationHistory:Update()
	-- update all known factions
	for faction = 1, GetNumFactions() do
		local _, _, _, _, _, currentRep, _, _, isHeader, _, hasRep  = GetFactionInfo(faction)
		
		if not isHeader or hasRep then		
			if not self.factions[faction] then
				self:InitFaction(faction)
			end
			
			local data = self.factions[faction]

			if data then
				local totalRep = currentRep - data.startRep
				if totalRep ~= data.totalRep then					
					local bucket = self:GetWriteBucket(faction)

					local delta = totalRep - data.totalRep
										
					local b = bucket.reputation
					
					bucket.reputation = bucket.reputation + delta
										
					data.tainted = true
				end
			end
		end
	end
end

-- params
function ReputationHistory:GetWeight()
	return self.weight
end

function ReputationHistory:SetWeight(weight)
	if weight < 0 then
		weight = 0
	elseif weight > 1 then
		weight = 1
	end

	if weight == self.weight then
		return
	end
	
	self.weight = weight
	
	self:Taint()
end

function ReputationHistory:GetTimeFrame()
	return self.timeframe
end

function ReputationHistory:SetTimeFrame(timeframe)
	if timeframe < 0 then
		timeframe = 0
	end

	if timeframe == self.timeframe then
		return
	end
	
	self.timeframe = timeframe
	
	self:Taint()
end

-- helper
function ReputationHistory:Taint()
	for faction, data in pairs(self.factions) do
		data.tainted = true
	end
	
	return false
end

function ReputationHistory:IsTainted()
	for faction, data in pairs(self.factions) do
		if self.factions[faction].tainted then
			return true
		end
	end
	
	return false
end

function ReputationHistory:IsTainted(faction)
	return self.factions[faction] and self.factions[faction].tainted or false
end
