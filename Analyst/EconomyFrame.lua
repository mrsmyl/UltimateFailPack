--[[

$Revision: 79 $

(C) Copyright 2007,2010 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

]]


----------------------------------------------------------------------
-- Acquire libraries and declare add-on

local L = LibStub("AceLocale-3.0"):GetLocale("Analyst", true)


----------------------------------------------------------------------
-- Constants

-- Periods
ANALYST_PERIOD_SESSION = "SESSION"
ANALYST_PERIOD_TODAY = "TODAY"
ANALYST_PERIOD_YESTERDAY = "YESTERDAY"
ANALYST_PERIOD_THIS_WEEK = "THIS_WEEK"
ANALYST_PERIOD_THIS_MONTH = "THIS_MONTH"
ANALYST_PERIOD_LAST_7_DAYS = "LAST_7_DAYS"
ANALYST_PERIOD_LAST_30_DAYS = "LAST_30_DAYS"
ANALYST_PERIODS = {
	ANALYST_PERIOD_SESSION,
	ANALYST_PERIOD_TODAY,
	ANALYST_PERIOD_YESTERDAY,
	ANALYST_PERIOD_THIS_WEEK,
	ANALYST_PERIOD_THIS_MONTH,
	ANALYST_PERIOD_LAST_7_DAYS,
	ANALYST_PERIOD_LAST_30_DAYS
}


---------------------------------------------------------------------
-- Subsystem

-- Initializes the economy frame subsystem
function Analyst:InitializeEconomyFrame ()
	-- Make the economy frame pushable
	UIPanelWindows["EconomyFrame"] = {
		area = "left",
		pushable = 0,
		xoffset = -16,
        yoffset = 12, 
		whileDead = 1
	}
	
	-- Translations
	EconomyFrameTitleText:SetText(L["ECONOMY_FRAME_TITLE"])
	EconomyFrameAllCharactersText:SetText(L["ALL_CHARACTERS"])

	-- All characters checkbox
	EconomyFrameAllCharacters:SetChecked(self.db.profile.economyFrameAllCharacters)
	
	-- Period drop down
	UIDropDownMenu_Initialize(EconomyFramePeriodDropDown,
			self.InitializePeriods)
	UIDropDownMenu_SetWidth(EconomyFramePeriodDropDown, 100)
	
	-- Report drop downs
	UIDropDownMenu_Initialize(EconomyFrameLeftStatsReportDropDown,
			self.InitializeReports)
	UIDropDownMenu_SetWidth(EconomyFrameLeftStatsReportDropDown, 133)
	UIDropDownMenu_Initialize(EconomyFrameRightStatsReportDropDown,
			self.InitializeReports)
	UIDropDownMenu_SetWidth(EconomyFrameRightStatsReportDropDown, 133)
end

-- Enable the economy frame subsystem
function Analyst:EnableEconomyFrame ()
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	self:RegisterMessage("ANALYST_FACTS_CHANGED")
end

-- Disables the economy frame subsystem
function Analyst:DisableEconomyFrame ()
end


----------------------------------------------------------------------
-- EconomyFrame

-- OnShow handler
function Analyst:OnShowEconomyFrame (frame)
	PlaySound("igCharacterInfoOpen")
	SetPortraitTexture(EconomyFramePortrait, "player")
	self:UpdateEconomyFrame()
end

-- OnHide handler
function Analyst:OnHideEconomyFrame (frame)
	PlaySound("igCharacterInfoClose")
end

-- Handles the UNIT_PORTRAIT_UPDATE event
function Analyst:UNIT_PORTRAIT_UPDATE (unit)
	if unit == "player" then
		SetPortraitTexture(EconomyFramePortrait, "player")
	end
end

-- Handles the ANALYST_FACTS_CHANGED event
function Analyst:ANALYST_FACTS_CHANGED ()
	if EconomyFrame:IsShown() then
		self:UpdateEconomyFrame()
	end
	self:Update()
end


----------------------------------------------------------------------
-- All characters check box

-- Iterates over the current character
function Analyst:CurrentCharacterIterator (charID)
	if not charID then
		charID = self:GetCharID()
		return charID, AnalystDB.char[charID]
	end
end

-- Returns an iterator for the selected characters
function Analyst:GetCharacterIterator ()
	if self.db.profile.economyFrameAllCharacters then
		return next, AnalystDB.char, nil
	else
		return self.CurrentCharacterIterator, self, nil
	end
end

-- Handles character selection
function Analyst:OnAllCharactersClick (frame)
	self.db.profile.economyFrameAllCharacters = EconomyFrameAllCharacters:GetChecked()
	self:UpdateEconomyFrame()
	self:Update()
end

-- Handles mouse enter on character selection
function Analyst:OnAllCharactersEnter (frame)
	GameTooltip:SetOwner(frame, "ANCHOR_LEFT")
	GameTooltip:SetText(L["ALL_CHARACTERS_TOOLTIP"], nil, nil, nil, nil, 1)
end

-- Handles mouse leave on character selection
function Analyst:OnAllCharactersLeave (frame)
	GameTooltip:Hide()
end


----------------------------------------------------------------------
-- Period drop down

-- Initializes the period drop down on load (callback)
function Analyst:InitializePeriods ()
	self = Analyst
	for _, period in ipairs(ANALYST_PERIODS) do
		self:AddPeriodSelection(period)
	end
end

-- Adds an option to the period drop down
function Analyst:AddPeriodSelection (name)
	local info = UIDropDownMenu_CreateInfo()
	info.text = L[name]
	info.value = name
	info.func = Analyst_OnPeriodClick
	info.arg1 = self
	info.owner = UIDROPDOWNMENU_INIT_MENU
	UIDropDownMenu_AddButton(info)
end

-- Handles selection of a period
function Analyst_OnPeriodClick (button, self)
	UIDropDownMenu_SetSelectedID(button.owner, button:GetID())
	self.db.profile.economyFramePeriod = button.value
	self:UpdateEconomyFrame()
	self:Update()
end

-- Returns the start and finish dates for the selected period
function Analyst:GetPeriodStartFinish ()
	-- Evaluate period
	local today = self:GetDate()
	local start
	local finish = today
	local period = self.db.profile.economyFramePeriod
	if period == ANALYST_PERIOD_SESSION then
		return nil, nil
	elseif period == ANALYST_PERIOD_TODAY then
		start = today
	elseif period == ANALYST_PERIOD_YESTERDAY then
		start = today - 86400
		finish = start
	elseif period == ANALYST_PERIOD_THIS_WEEK then
		local components = date("*t", today)
		local dayOfWeek = components.wday - 1
		if dayOfWeek == 0 then
			dayOfWeek = 7
		end
		local startDayOfWeek = self.db.profile.startDayOfWeek
		if dayOfWeek >= startDayOfWeek then
			start = today - (dayOfWeek - startDayOfWeek) * 86400
		else
			start = today - (dayOfWeek + 7 - startDayOfWeek) * 86400
		end
	elseif period == ANALYST_PERIOD_THIS_MONTH then
		local dayOfMonth = tonumber(date("%d", today))
		start = today - (dayOfMonth - 1) * 86400
	elseif period == ANALYST_PERIOD_LAST_7_DAYS then
		start = today - 6 * 86400
	elseif period == ANALYST_PERIOD_LAST_30_DAYS then
		start = today - 29 * 86400
	end
	if not start then
		self:LevelDebug(1, "Unknown period")
		start = today
	end
	return start, finish
end

-- Returns the ID of a period given its name
function Analyst:GetPeriodId (name)
	for i in ipairs(ANALYST_PERIODS) do
		if ANALYST_PERIODS[i] == name then
			return i
		end
	end
	return nil
end


----------------------------------------------------------------------
-- Report drop down

-- Initializes the period drop down on load (callback)
function Analyst:InitializeReports ()
	self = Analyst
	local reports = self:GetReports()
	for i in ipairs(reports) do
		if reports[i].name ~= ANALYST_REPORT_OVERVIEW then
			self:AddReportSelection(reports[i].name)
		end
	end
end

-- Adds an option to the period drop down
function Analyst:AddReportSelection (name)
	local info = UIDropDownMenu_CreateInfo()
	info.text = L[name]
	info.value = name
	info.func = Analyst_OnReportClick
	info.arg1 = self
	info.owner = UIDROPDOWNMENU_INIT_MENU
	UIDropDownMenu_AddButton(info)
end

-- Handles selection of a period
function Analyst_OnReportClick (button, self)
	UIDropDownMenu_SetSelectedID(button.owner, button:GetID())
	if button.owner:GetName() == "EconomyFrameLeftStatsReportDropDown" then
		self.db.profile.economyFrameLeftReport = button.value
	elseif button.owner:GetName() == "EconomyFrameRightStatsReportDropDown" then
		self.db.profile.economyFrameRightReport = button.value
	end
	self:UpdateEconomyFrame()
end


----------------------------------------------------------------------
-- Data management

-- Updates the economy frame
function Analyst:UpdateEconomyFrame ()
	-- Update UI
	EconomyFrameAllCharacters:SetChecked(self.db.profile.economyFrameAllCharacters)
	UIDropDownMenu_SetSelectedValue(EconomyFramePeriodDropDown,
			self.db.profile.economyFramePeriod)
	UIDropDownMenu_SetText(EconomyFramePeriodDropDown,
			L[self.db.profile.economyFramePeriod])
	UIDropDownMenu_SetSelectedValue(EconomyFrameLeftStatsReportDropDown,
			self.db.profile.economyFrameLeftReport)
	UIDropDownMenu_SetText(EconomyFrameLeftStatsReportDropDown,
			L[self.db.profile.economyFrameLeftReport])
	UIDropDownMenu_SetSelectedValue(EconomyFrameRightStatsReportDropDown,
			self.db.profile.economyFrameRightReport)
	UIDropDownMenu_SetText(EconomyFrameRightStatsReportDropDown,
			L[self.db.profile.economyFrameRightReport])
	
	-- Get start and finish
	local start, finish = self:GetPeriodStartFinish()
	
	-- Update reports
	self:UpdateReport(EconomyFrameTopStats, 8, ANALYST_REPORT_OVERVIEW, start, finish)
	self:UpdateReport(EconomyFrameLeftStats, 14, self.db.profile.economyFrameLeftReport, start, finish)
	self:UpdateReport(EconomyFrameRightStats, 14, self.db.profile.economyFrameRightReport, start, finish)
end

-- Updates a single report
function Analyst:UpdateReport (frame, maxMeasures, reportName, start, finish)
	-- Get the report
	local report = self:GetReport(reportName)
	if not report then
		self:LevelDebug(1, "Undefined report " .. reportName)
		return
	end
	
	-- Process each measure
	for i in ipairs(report.measures) do
		if i > maxMeasures then
			break
		end
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
		local label = getglobal(frame:GetName() .. i .. "Label")
		label:SetText(measure.label)
		local text = getglobal(frame:GetName() .. i .. "StatText")
		if self:GetMeasureType(measureName) == ANALYST_MTYPE_MONEY then
			text:SetText(self:FormatCopper(facts.value))
		else
			text:SetText(tostring(facts.value))
		end
		local statFrame = getglobal(frame:GetName() .. i)
		statFrame.facts = facts
		statFrame.measure = measure
	end
	for i = #report.measures + 1, maxMeasures do
		local label = getglobal(frame:GetName() .. i .. "Label")
		label:SetText("")
		local text = getglobal(frame:GetName() .. i .. "StatText")
		text:SetText("")
		local statFrame = getglobal(frame:GetName() .. i)
		statFrame.facts = nil
		statFrame.measure = nil
	end
end


----------------------------------------------------------------------
-- Stat tooltip

-- Shows the tooltip upon entry
function Analyst:OnStatEnter (frame)
	local facts = frame.facts
	local measure = frame.measure
	if facts and measure then
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
		GameTooltip:AddLine(
			measure.label,
			HIGHLIGHT_FONT_COLOR.r,
			HIGHLIGHT_FONT_COLOR.g,
			HIGHLIGHT_FONT_COLOR.b)
		self:AddSubFacts(GameTooltip, measure, facts.detail)
		self:AddSubFacts(GameTooltip, measure, facts.consumed, L["CONSUMED"])
		self:AddSubFacts(GameTooltip, measure, facts.produced, L["PRODUCED"])
		GameTooltip:Show()
	end
end

-- Adds sub-facts to the game tooltip
function Analyst:AddSubFacts (gameTooltip, measure, subFacts, label)
	-- No sub facts?
	if not subFacts then
		if not label then
			gameTooltip:AddLine(
				L["NO_DETAIL_INFO"],
				GRAY_FONT_COLOR.r,
				GRAY_FONT_COLOR.g,
				GRAY_FONT_COLOR.b)
		end
		return
	end
	
	-- Prepare data
	local data = { }
	for detail in pairs(subFacts) do
		local element = { }
		element.detail = detail
		element.value = subFacts[detail]
		table.insert(data, element)
	end
	table.sort(
		data,
		function (element1, element2)
			return element1.value > element2.value or
				(element1.value == element2.value and element1.detail < element2.detail)
		end)
	
	-- No data?
	if #data == 0 then
		return
	end
	
	-- Add title
	if label then
		gameTooltip:AddLine(
			label,
			HIGHLIGHT_FONT_COLOR.r,
			HIGHLIGHT_FONT_COLOR.g,
			HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Add values
	for i in ipairs(data) do
		if i > 10 then
			break
		end
		local text
		if self:GetMeasureType(measure.name) == ANALYST_MTYPE_MONEY then
			text = self:FormatCopper(data[i].value)
		else
			text = tostring(data[i].value)
		end
		gameTooltip:AddDoubleLine(
			data[i].detail,
			text,
			NORMAL_FONT_COLOR.r,
			NORMAL_FONT_COLOR.g,
			NORMAL_FONT_COLOR.b,
			HIGHLIGHT_FONT_COLOR.r,
			HIGHLIGHT_FONT_COLOR.g,
			HIGHLIGHT_FONT_COLOR.b)
	end
end

-- Hides the tooltip upon leaveing
function Analyst:OnStatLeave (frame)
	GameTooltip:Hide()
end