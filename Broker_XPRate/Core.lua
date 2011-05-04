--[[----------------------------------------------------------------------------------
	Broker_XPRate Core
	
	TODO:   
	
	Credit to Laughlorien and KillMeterFu for some of the per kill code           
------------------------------------------------------------------------------------]]

local expansionlevel = GetAccountExpansionLevel()
if expansionlevel == 0 then
	MAX_LEVEL = 60
elseif expansionlevel == 1 then
	MAX_LEVEL = 70
elseif expansionlevel == 2 then
 MAX_LEVEL = 80
elseif expansionlevel == 3 then
 MAX_LEVEL = 85
else --unknown expansionlevel so no idea but we don't want ppl to hit it
	MAX_LEVEL = 255
end

local UPDATEPERIOD = 1
local keeplast = 12
local frame = CreateFrame("frame")

local elapsed = 0
local starttime = 0
local totalgained = 0
local difftilllevel = 0
local lasttotal = 0
local tipshown
local xpperkill = 0
local totalkills = 0
local playerlevel = 0
Broker_XPRate = LibStub("AceAddon-3.0"):NewAddon("Broker_XPRate", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Broker_XPRate")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local functions = {}

local function checklevel(level)
	level = (level or playerlevel)
	if tonumber(level) >= tonumber(MAX_LEVEL) then
		if not dataobj then return false end
		dataobj.icon = nil
		dataobj.text = nil
		dataobj.OnEnter = nil
		dataobj.OnClick = nil
		dataobj.OnLeave = nil
		frame:SetScript("OnUpdate", nil)
		Broker_XPRate:UnregisterAllEvents()
		return false
	end
	return true
end

local function setup()
	-- setup the addon
	dataobj = ldb:NewDataObject("Broker_XPRate", {
	    type = "data source",
	    icon = "Interface\\Icons\\Inv_Misc_SummerFest_BrazierOrange",
	})

	function functions.round(num, idp)
		local mult = 10^(idp or 2)
		return math.floor(num * mult + 0.5) / mult
	end

	function functions.formattime(stamp)
		local returnstring = ''
		local days = math.floor(stamp/86400)
		if days > 0 then returnstring = returnstring .. days .. " days " else days = 0 end
		local hours = math.floor((stamp - days*86400)/3600)
		if strlen(tostring(hours)) == 1 then hours = "0" .. hours end
		local minutes = math.floor((stamp - days*86400 - hours*3600)/60)
		if strlen(tostring(minutes)) == 1 then minutes = "0" .. minutes end
		return returnstring .. hours .. ":" .. minutes
	end

	function functions.GetTipAnchor(frame)
		local x,y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	function functions.GetAvgXP()
		return totalgained/(time() - starttime)
	end

	function functions.GetKillsPerHour()
		return totalkills/(time() - starttime)
	end

	function functions.UpdateDifftilllevel()
		difftilllevel = UnitXPMax("player") - UnitXP("player")
	end

	function functions.GetTimeToLevel()
		local avg = functions.GetAvgXP()
		local restedleft = GetXPExhaustion() or 0
		if restedleft >= difftilllevel then restedleft = difftilllevel end
		if avg == 0 then return "~" end
		local ttl = difftilllevel/avg
		if (restedleft > 0) then
			ttl = ttl - ((functions.GetKillsPerHour()*xpperkill)/(restedleft/(functions.GetKillsPerHour()*xpperkill*2)))
		end
		return functions.formattime(ttl)
	end

	function functions.GetKillsToLevel()
		functions.UpdateDifftilllevel()
		if xpperkill == 0 then return "~" end
		local restedleft = GetXPExhaustion() or 0
		if (restedleft >= difftilllevel) then
			return functions.round(difftilllevel/(xpperkill * 2), 0)
		else
			return functions.round((restedleft/(xpperkill * 2)) + ((difftilllevel - restedleft)/xpperkill), 0)
		end
	end

	function functions.returncolored(string,color)
		return "|cFF" .. color .. string .. "|r"
	end

	function dataobj:OnEnter()
		tipshown = self
	 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(functions.GetTipAnchor(self))
		GameTooltip:ClearLines()
	
		GameTooltip:AddLine("Broker_XPRate")
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["XP till next level:"], difftilllevel, 0,1,0, 0,1,0)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["XP per hour:"] , functions.round(functions.GetAvgXP()*3600,0), 0,1,0, 0,1,0)
		GameTooltip:AddDoubleLine(L["XP per kill:"], functions.round(xpperkill, 0), 0,1,0, 0,1,0)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(string.format(L["%s time to level"], functions.GetTimeToLevel()))
		GameTooltip:AddLine(string.format(L["%s kills to level"], functions.GetKillsToLevel()))
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(functions.returncolored(L["Click: "], "6ab950") .. functions.returncolored(L["Toggles text options"], "eeeeee"))
		GameTooltip:AddLine(functions.returncolored(L["Ctrl + Click: "], "6ab950") .. functions.returncolored(L["Resets session"], "eeeeee"))
    
		GameTooltip:Show()
	end

	function dataobj:OnLeave()
	    GameTooltip:Hide()
		tipshown = nil
	end

	function functions.resetsession()
		totalgained = 0
		starttime = time()
		Broker_XPRate.db.char.history = {}
		xpperkill = 0
		restedxpperkill = 0
		totalkills = 0
		Broker_XPRate:Print("Session reset")
	end

	function dataobj.OnClick(self, button)
		if IsControlKeyDown() and button == "LeftButton" then
			functions.resetsession()
		elseif button == "LeftButton" then
			if Broker_XPRate.db.profile.display == 1 then
				Broker_XPRate.db.profile.display = 2
			else
				Broker_XPRate.db.profile.display = 1
			end
		end
	end

	frame:SetScript("OnUpdate", function(self, elap)
		elapsed = elapsed + elap
		if elapsed < UPDATEPERIOD then return end
		elapsed = 0
		if Broker_XPRate.db.profile.display == 1 then
			dataobj.text = string.format(L["%s to level"], functions.GetTimeToLevel(), 0)
		else
			dataobj.text = string.format(L["%s kills to level"], functions.GetKillsToLevel())
		end

		if tipshown then dataobj.OnEnter(tipshown) end
	end)

	function functions.GetDiff()
		local oldtotal = lasttotal
		lasttotal = UnitXP("player")
		if (lasttotal - oldtotal <= 0) then
			lasttotal = lasttotal + difftilllevel
		end
		functions.UpdateDifftilllevel()
		return lasttotal - oldtotal
	end

	function Broker_XPRate:PLAYER_XP_UPDATE()
		totalgained = totalgained + functions.GetDiff()
	end

	function Broker_XPRate:PLAYER_LEVEL_UP()
		playerlevel = playerlevel + 1
		checklevel(playerlevel)
	end

	function Broker_XPRate:CHAT_MSG_COMBAT_XP_GAIN(_, combat_string)
		self.db.profile.lastcombatline = combat_string
		local name,xp,rxp
		_,_,name,xp = string.find(combat_string, L["Combat Message Search String"])
		_,_,rxp = string.find(combat_string, L["Combat Message Rested Search String"])
		if (not xp) then return end -- stop if we didn't find the xp gained
		rxp = rxp or 0
		xp = xp - rxp
		totalkills = totalkills + 1
		table.insert(self.db.char.history,1, {
						["name"] = name,
						["xp"] = tonumber(xp),
						["rxp"] = tonumber(rxp)
	                })
		--Now if we have more than keeplast records, remove the oldest
		if (table.getn(self.db.char.history) > keeplast) then
			table.remove(self.db.char.history)
		end
	
		--Now it's time to figure out the regular mean
		local total = 0
		local totalrested = 0
		local	xpmean = 0
		local historylength = table.getn(self.db.char.history)
		for k,v in pairs(self.db.char.history) do
			total = total + v.xp
		end
		xpmean = total/historylength

		--Now it's time to figure out the stddeviations
		local stdev = 0
		local rstdev = 0
		for k,v in pairs(self.db.char.history) do
			stdev = stdev + (v.xp - xpmean)^2
		end
		stdev = math.sqrt(stdev)

		--Now lets figure out the mean of values within the stdev
		total = 0
		local within = 0
		low = xpmean - stdev
		high = xpmean + stdev
		for k,v in pairs(self.db.char.history) do
			if (v.xp >= low) and (v.xp <= high) then
				total = total + v.xp
				within = within + 1
			end
		end
		if (within == 0) then
			xpperkill = 0
		else
			xpperkill = total/within
		end
	end
end		

function Broker_XPRate:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("Broker_XPRateDB", {}, "Default")
    self.db:RegisterDefaults({
        profile = {
			display = 1,
			lastcombatline = ''
        },
		char = {
			history = {}
		},
    })
end

function Broker_XPRate:OnEnable()
	playerlevel = UnitLevel("player")
	if not checklevel() then return end --not high enough stop here
	setup()
	starttime = time() --save timestamp of when enabled
	lasttotal = UnitXP("player")
	functions.UpdateDifftilllevel()
	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
	self:RegisterEvent("PLAYER_LEVEL_UP")
end