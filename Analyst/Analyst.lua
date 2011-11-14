--[[

$Revision: 67 $

(C) Copyright 2007,2010 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Acquire libraries and declare add-on

Analyst = LibStub("AceAddon-3.0"):NewAddon("Analyst",
	"AceConsole-3.0",
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Analyst", true)
local icon = LibStub("LibDBIcon-1.0")

	
----------------------------------------------------------------------
-- Constants

-- Database version
ANALYST_DATABASE_VERSION = 3

-- Data lifetime
ANALYST_DATA_LIFETIME = 30

-- Bindings
BINDING_HEADER_ANALYST = L["BINDING_HEADER_ANALYST"]
BINDING_NAME_ECONOMY = L["BINDING_NAME_ECONOMY"]

-- Ace options
local ACE_OPTS = {
	name = L["ANALYST"],
	handler = Analyst,
	type = "group",
	args = {
		economy = {
			type = "toggle",
			name = L["ECONOMY"],
			desc = L["ECONOMY_DESC"],
			order = 1,
			get = "IsEconomyFrameShown",
			set = "ToggleEconomyFrame",
			guiHidden = true
		},
		options = {
			type = "execute",
			name = L["OPTIONS"],
			desc = L["OPTIONS_DESC"],
			order = 2,
			func = "ShowOptions",
			guiHidden = true
		},
		minimap = {
			name = L["MINIMAP"],
			desc = L["MINIMAP_DESC"],
			order = 3,
			type = "toggle",
			get = "GetMinimap",
			set = "SetMinimap"
		},
		startDayOfWeek = {
			type = "range",
			name = L["START_DAY_OF_WEEK"],
			desc = L["START_DAY_OF_WEEK_DESC"],
			order = 4,
			min = 1,
			max = 7,
			step = 1,
			get = "GetStartDayOfWeek",
			set = "SetStartDayOfWeek"
		},
		resetSession = {
			type = "execute",
			name = L["RESET_SESSION"],
			desc = L["RESET_SESSION_DESC"],
			order = 5,
			func = "ResetSession"
		}
	}
}


----------------------------------------------------------------------
-- Core handlers

-- One-time initialization
function Analyst:OnInitialize()
	-- Options
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Analyst", ACE_OPTS, L["SLASH_COMMANDS"])
	self.options = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Analyst", L["ANALYST"])

	-- Initialize debuggign
	self:SetDebugging(false)
	self:SetDebugLevel(2)
	
	-- Uncomment below for debugging from the start
	--self:SetDebugging(true)
		
	-- Uncomment below for verbose debugging
	--self:SetDebugLevel(3)

	-- Database
	local defaults = {
		profile = {
			minimap = {
				hide = false
			},
			startDayOfWeek = 1,
			economyFrameAllCharacters = false,
			economyFramePeriod = ANALYST_PERIOD_TODAY,
			economyFrameLeftReport = ANALYST_REPORT_MONEY_GAINED,
			economyFrameRightReport = ANALYST_REPORT_MONEY_SPENT
		}
	}
	self.db = LibStub("AceDB-3.0"):New("AnalystDB", defaults, true)
	self:MigrateDatabase(ANALYST_DATABASE_VERSION)
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Analyst-Profiles",
			LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Analyst-Profiles", L["PROFILES"], "Analyst")
	
	-- Subsystems
	self:InitializeCapture()
	self:InitializeMeasure()
	self:InitializeVendorValue()
	self:InitializeEconomyFrame()
		
	-- LDB
	self.dataObject = LibStub("LibDataBroker-1.1"):NewDataObject("Analyst", { 
		type = "data source",
		text = "",
		icon = "Interface\\Icons\\INV_Misc_Spyglass_03.blp",
		OnClick = function (frame, button)
			if button == "RightButton" then
				Analyst:ShowOptions()
			else
				Analyst:ToggleEconomyFrame()
			end
		end,
		OnTooltipShow = function (tt)
			Analyst:OnTooltipShow(tt)
		end })
	self:Update()
	
	-- Minimap icon
	icon:Register("Analyst", self.dataObject, self.db.profile.minimap)
end

-- Handles (re-)enabling of the addon
function Analyst:OnEnable ()
	-- Subsystems
	self:EnableCapture()
	self:EnableMeasure()
	self:EnableVendorValue()
	self:EnableEconomyFrame()
end

-- Handles disabling of the addon
function Analyst:OnDisable ()
	-- Subsystems
	self:DisableEconomyFrame()
	self:DisableVendorValue()
	self:DisableMeasure()
	self:DisableCapture()
end


----------------------------------------------------------------------
-- Settings

-- Returns whether the Economy Frame is shown
function Analyst:IsEconomyFrameShown ()
	return EconomyFrame:IsShown()
end

-- Toggles the Economy Frame
function Analyst:ToggleEconomyFrame ()
	if EconomyFrame:IsShown() then
		HideUIPanel(EconomyFrame)
	else
		ShowUIPanel(EconomyFrame)
	end
end

-- Shows the options
function Analyst:ShowOptions ()
	InterfaceOptionsFrame_OpenToCategory(self.options)
end

-- Returns the status of the minimap icon
function Analyst:GetMinimap ()
	return not self.db.profile.minimap.hide
end

-- Sets the status of the minimap icon
function Analyst:SetMinimap (info, value)
	self.db.profile.minimap.hide = not value
	self:UpdateMinimap()
end

-- Returns the start day of the week
function Analyst:GetStartDayOfWeek ()
	return self.db.profile.startDayOfWeek
end

-- Sets the start day of the week
function Analyst:SetStartDayOfWeek (info, startDayOfWeek)
	self.db.profile.startDayOfWeek = startDayOfWeek
	self:UpdateEconomyFrame()
	self:Update()
end

-- Resets the session
function Analyst:ResetSession ()
	self:ClearSessionFacts()
end


----------------------------------------------------------------------
-- Database

-- Migrates the database
function Analyst:MigrateDatabase (target)
	local current = self.db.global.databaseVersion or
			self.db.global.buildInfo and 1 or target
	
	-- Migrate 1 -> 2
	if current == 1 and target >= 2 then
		-- Move from char to profile
		if AnalystDB.char then
			for char, options in pairs(AnalystDB.char) do
				local profile = AnalystDB.profiles[char]
				if not profile then
					profile = { }
					AnalystDB.profiles[char] = profile
				end
				profile.economyFrameAllCharacters = options.economyFrameAllCharacters
				profile.economyFramePeriod = options.economyFramePeriod
				profile.economyFrameLeftReport = options.economyFrameLeftReport
				profile.economyFrameRightReport = options.economyFrameRightReport
				options.economyFrameAllCharacters = nil
				options.economyFramePeriod = nil
				options.economyFrameLeftReport = nil
				options.economyFrameRightReport = nil
			end
		end
		current = 2
		self.db.global.databaseVersion = current
	end
	
	-- Migrate 2 -> 3
	if current == 2 and target >= 3 then
		-- Remove enchants
		self.db.global.enchants = nil
		current = 3
		self.db.global.databaseVersion = current
	end
end

-- Handles a profile change
function Analyst:ProfileChanged ()
	self:UpdateEconomyFrame()
	self:Update()
	self:UpdateMinimap()
end


----------------------------------------------------------------------
-- Debug

-- Returns whether debugging is enabled
function Analyst:IsDebugging ()
	return self.debugging
end

-- Sets whether the debugging is enabled
function Analyst:SetDebugging (debugging) 
	self.debugging = debugging
end

-- Sets the debug level
function Analyst:SetDebugLevel (debugLevel)
	self.debugLevel = debugLevel
end

-- Prints a debug message
function Analyst:Debug (msg)
	self:LevelDebug(nil, msg)
end

-- Prints a debug message with a level
function Analyst:LevelDebug (level, msg)
	if self:IsDebugging() and (not level or level <= self.debugLevel) then
		self:Print(msg)
	end
end


----------------------------------------------------------------------
-- LDB

-- Updates the data object
function Analyst:Update ()
	local start, finish = self:GetPeriodStartFinish()
	local change = 0
	if start and finish then
		for charID in self:GetCharacterIterator() do
			for t = start, finish, 86400 do
				local day = date("%Y%m%d", t)
				change = change + self:GetFacts(ANALYST_MEASURE_MONEY_GAINED_TOTAL, day, charID).value
				change = change - self:GetFacts(ANALYST_MEASURE_MONEY_SPENT_TOTAL, day, charID).value
			end
		end
	else
		change = change + self:GetFacts(ANALYST_MEASURE_MONEY_GAINED_TOTAL, nil, nil).value
		change = change - self:GetFacts(ANALYST_MEASURE_MONEY_SPENT_TOTAL, nil, nil).value
	end
	local color
	if change >= 0 then
		color = "|cFF00FF00"
	else
		color = "|cFFFF0000"
	end
	self.dataObject.text = color .. self:FormatCopper(math.abs(change))
end

-- Updates the minimap icon
function Analyst:UpdateMinimap ()
	if self.db.profile.minimap.hide then
		icon:Hide("Analyst")
	else
		icon:Show("Analyst")
	end
end

--  Handles tooltip updates
function Analyst:OnTooltipShow (tt)
	local report = self:GetReport(ANALYST_REPORT_OVERVIEW)
	tt:AddLine("Analyst")
	tt:AddLine(L["ECONOMY_FRAME_HINT"])
	tt:AddLine(" ")
	tt:AddLine(report.label, 1.0, 1.0, 1.0)
	local start, finish = self:GetPeriodStartFinish()
	for i in ipairs(report.measures) do
		local measureName = report.measures[i]
		local measure = self:GetMeasure(measureName)
		local facts = { }
		if start and finish then
			for charID in self:GetCharacterIterator() do
				for t = start, finish, 86400 do
					local day = date("%Y%m%d", t)
					local dayFacts = Analyst:GetFacts(measureName, day, charID)
					self:MergeFacts(facts, dayFacts)
				end
			end
		else
			facts = Analyst:GetFacts(measureName, nil, nil)
		end
		local text2
		if self:GetMeasureType(measureName) == ANALYST_MTYPE_MONEY then
			text2 = self:FormatCopper(facts.value)
		else
			text2 = tostring(facts.value)
		end
		tt:AddDoubleLine(measure.label, text2, 1.0, 0.82, 0.0, 1.0, 1.0, 1.0)
	end
end

----------------------------------------------------------------------
-- Helpers

-- Returns today's date
function Analyst:GetDate ()
	local now = time()
	local components = date("*t", now)
	local seconds =	((components.hour * 60) + components.min) * 60 + components.sec
	return now - seconds + 43200
end

-- Returns the CharID of the current character
function Analyst:GetCharID ()
	return UnitName("player") .. " - " .. GetRealmName():trim()
end

-- Formats a copper amount
function Analyst:FormatCopper (copper)
	local prefix
	if copper >= 0 then
		prefix = ""
	else
		prefix = "-"
		copper = math.abs(copper)
	end
	if copper >= 10000 then
		return string.format("%s%.1f G", prefix, copper / 10000.0)
	elseif copper >= 100 then
		return string.format("%s%.1f S", prefix, copper / 100.0)
	else
		return string.format("%s%d C", prefix, copper)
	end
end