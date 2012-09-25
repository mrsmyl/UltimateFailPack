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

local GetNumGroupMembers    = _G.GetNumGroupMembers
local GetNumSubgroupMembers = _G.GetNumSubgroupMembers
local GetXPExhaustion       = _G.GetXPExhaustion
local IsInRaid              = _G.IsInRaid
local UnitXP                = _G.UnitXP
local UnitXPMax             = _G.UnitXPMax

local LE_PARTY_CATEGORY_HOME = _G.LE_PARTY_CATEGORY_HOME

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

local History = {
	-- data
	totalKills    = 0,
	totalXP       = 0,
	activityKills = 0,
	activityXP    = 0,
	xpPerKill     = 0,
	grpXpPerKill  = 0,
	raidPenaltyPerKill = 0,
	startTime     = nil,
	endRestTime   = nil,
	startXP       = 0,
	lvlMaxXP      = 0,
	doneLvlXP     = 0,
	activeBucket  = floor(time() / 60) - 1,
	taintedXP     = true,
	taintedMobs   = false,
	historyXP     = {},
	historyMobs   = {},
	
	-- params
	weight        = 0.5,
	timeframe     = 60,
}

Addon.History = History

function History:Initialize()
	self.startTime = time()
	
	if (GetXPExhaustion() or 0) == 0 then
		self.endRestTime  = self.startTime
	end
	
	self.totalKills    = 0
	self.totalXP       = 0
	self.activityKills = 0
	self.activityXP    = 0
	self.startXP       = UnitXP("player")
	self.lvlMaxXP      = UnitXPMax("player")
	
	for key in pairs(self.historyXP) do
		self.historyXP[key]= nil
	end
	
	for key in pairs(self.historyMobs) do
		self.historyMobs[key]= nil
	end	
end

-- xp rate calculations
function History:GetWriteBucket()
	local bucketTime = floor(time() / 60)
	local bucket = self.historyXP[#self.historyXP]
	
	if not bucket or bucket.time ~= bucketTime then
		bucket = {
			time    = bucketTime,
			totalXP = 0,
			kills   = 0
		}
		tinsert(self.historyXP, bucket)
	end
	
	return bucket
end

function History:GetTimeToLevel()
	if self.totalXP == 0 then
		return "~"
	end

	local duration = time() - self.startTime

	if duration == 0 then
		return "~"
	end

	local duration_rest = duration
	
	if self.endRestTime then
		duration_rest = self.endRestTime - self.startTime
	end
	
	local xp_togo = UnitXPMax("player") - UnitXP("player")
	
	-- xp/s (current)
	local xppersec_c
	-- kills/s (current)
	local killspersec_c
	-- fraction of time with rested bonus
	local rest_factor

	if self.timeframe == 0 or duration < self.timeframe then
		xppersec_c    = self.totalXP / duration
		killspersec_c = self.totalKills / duration
		rest_factor   = duration_rest / duration
	else
		xppersec_c    = (self.activityXP / self.timeframe) * self.weight + (self.totalXP / duration) * (1-self.weight)
		killspersec_c = (self.activityKills / self.timeframe) * self.weight + (self.totalKills / duration) * (1-self.weight)
		local duration_rest_activity = duration_rest - (duration - self.timeframe)
		rest_factor   = (duration_rest_activity / self.timeframe) * self.weight + (duration_rest / duration) * (1-self.weight)		
	end

	if xppersec_c == 0 then
		return "~"
	end
	
	-- xp/s (based on mob kills)
	local xppersec_m = self.xpPerKill * killspersec_c
	
	local xp_rested = GetXPExhaustion() or 0
	
	-- fraction of xp/s done by mobkills
	local mob_fraction = xppersec_m / xppersec_c
	
	-- how far does the rested bonus extend 
	-- based on our current fraction of mobkills of xp earned 
	local xp_restrange = 0

	if mob_fraction > 0 then
		xp_restrange = xp_rested / mob_fraction
	end
	
	if xp_restrange > xp_togo then
		xp_restrange = xp_togo
	end

	-- xppersec_c(urrent) = xppersec_nomobs + 2*(xppersec_m(obs))
	local ttl = xp_restrange / xppersec_c + (xp_togo - xp_restrange) / (xppersec_c - (xppersec_m * rest_factor))
	
	return FormatTime( ttl )	
end

function History:GetKillsToLevel()
	if self.xpPerKill == 0 then 
		return "~" 
	end
	
	local rested = GetXPExhaustion() or 0
	local xptogo = UnitXPMax("player") - UnitXP("player")
	
	local bonus = 0
	
	if GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
		if IsInRaid() then
			bonus = self.raidPenaltyPerKill
		else
			bonus = self.grpXpPerKill
		end
	end
	
	-- NOTE: since there is no formula calculating the group bonus available 
	-- we depend on the data we extracted from the combat log
	-- so group bonus is incorrect if the number of players in party/raid changes
	-- but it will adjust faily quick (and we cant take everything into account)
	if rested >= xptogo then
		return ceil(xptogo/(self.xpPerKill * 2 + bonus))
	else
		return ceil((rested/(self.xpPerKill * 2 + bonus)) + ((xptogo - rested)/(self.xpPerKill + bonus)))
	end
end

function History:GetKillsPerHour()
	local duration = time() - self.startTime

	if duration == 0 then
		return nil
	end

	if self.timeframe == 0 or duration < self.timeframe then
		return self.totalKills / duration * 3600
	else
		return ((self.activityKills / self.timeframe) * self.weight + (self.totalKills / duration) * (1-self.weight)) * 3600
	end
end

function History:GetXPPerHour()
	local duration = time() - self.startTime

	if duration == 0 then
		return nil
	end

	if self.timeframe == 0 or duration < self.timeframe then
		return self.totalXP / duration * 3600
	else		
		return ((self.activityXP / self.timeframe) * self.weight + (self.totalXP / duration) * (1-self.weight)) * 3600
	end
end

function History:Process()
	self:ProcessXPHistory()
	self:ProcessMobHistory()
end

function History:ProcessXPHistory()
	local currentBucket = floor(time() / 60)
	if not self.taintedXP and currentBucket == self.activeBucket then 
		return 
	end
	
	self.activeBucket = currentBucket
	
	-- remove old buckets
	while #self.historyXP ~= 0 and self.historyXP[1].time <= (self.activeBucket - self.timeframe) do
		tremove(self.historyXP, 1)
	end

	local xp, mobxp, kills = 0, 0, 0
	
	for _, bucket in pairs(self.historyXP) do
		xp    = xp + bucket.totalXP
		kills = kills + bucket.kills
	end

	self.activityXP    = xp
	self.activityKills = kills
	
	self.taintedXP = false	
end

function History:ProcessMobHistory()
	if not self.taintedMobs then 
		return 
	end
	
	-- regular mean
	local total = 0
	local mean = 0
	local size = tgetn(self.historyMobs)
	for _, xp in pairs(self.historyMobs) do
		total = total + xp.kxp
	end
	mean = total/size

	-- std deviation
	total = 0
	local stdev = 0
	for _, xp in pairs(self.historyMobs) do
		total = total + (xp.kxp - mean)^2
	end
	if size > 1 then
		stdev = sqrt(total/(size-1))
	else
		stdev = 0
	end

	-- mean of values within the stdev
	total = 0
	local group = 0
	local raid = 0
	local count = 0
	
	local low = mean - stdev
	local high = mean + stdev
	
	for _, xp in pairs(self.historyMobs) do
		if xp.kxp >= low and xp.kxp <= high then
			total = total + xp.kxp
			group = group + xp.gxp
			raid  = raid - xp.pxp
			count = count + 1
		end
	end
	
	if count == 0 then
		self.xpPerKill          = 0
		self.grpXpPerKill       = 0
		self.raidPenaltyPerKill = 0
	else
		self.xpPerKill          = total/count
		self.grpXpPerKill       = group/count
		self.raidPenaltyPerKill = raid/count
	end

	self.taintedMobs = false	
end

function History:UpdateXP()
	local bucket = self:GetWriteBucket()

	-- check for lvl up
	if self.lvlMaxXP < UnitXPMax("player") then
		local leftXP = self.lvlMaxXP - (self.totalXP + self.startXP)
		self.totalXP = self.totalXP + leftXP
		bucket.totalXP = bucket.totalXP + leftXP
		self.doneLvlXP = self.totalXP

		self.startXP  = 0
		self.lvlMaxXP = UnitXPMax("player")	
	end

	local lvlTotal = UnitXP("player") - self.startXP
	local delta    = lvlTotal - (self.totalXP - self.doneLvlXP)
	
	-- track activity	
	self.totalXP = lvlTotal + self.doneLvlXP
	bucket.totalXP = bucket.totalXP + delta
	
	if not self.endRestTime and (GetXPExhaustion() or 0) == 0 then
		self.endRestTime  = time()
	end

	self.taintedXP = true
end

function History:AddKill(xp, bonus, penalty)
	-- track activity	
	local bucket = self:GetWriteBucket()
	
	self.totalKills   = self.totalKills + 1
	bucket.kills = bucket.kills + 1

	-- track mob kills
	local mobdata = {
		kxp = xp,
		gxp = bonus,
		pxp = penalty
	}
	
	tinsert(self.historyMobs, 1, mobdata)
				
	-- remove oldest entry if we exceed history size
	if tgetn(self.historyMobs) > MAX_HISTORY then
		tremove(self.historyMobs)
	end
		
	self.taintedMobs = true	
end

-- params
function History:GetWeight()
	return self.weight
end

function History:SetWeight(weight)
	if weight < 0 then
		weight = 0
	elseif weight > 1 then
		weight = 1
	end

	if weight == self.weight then
		return
	end
	
	self.weight = weight
	
	self.taintedXP = true
end

function History:GetTimeFrame()
	return self.timeframe
end

function History:SetTimeFrame(timeframe)
	if timeframe < 0 then
		timeframe = 0
	end

	if timeframe == self.timeframe then
		return
	end
	
	self.timeframe = timeframe
	
	self.taintedXP = true
end

-- helper
function History:IsTainted()
	return self.taintedXP or self.taintedMobs
end

