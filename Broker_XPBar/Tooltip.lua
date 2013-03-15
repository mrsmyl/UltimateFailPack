local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local BrokerXPBar = _G.BrokerXPBar

-- tooltip library
local QT		= LibStub:GetLibrary("LibQTip-1.0")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale( ADDON )

-- local functions
local floor = math.floor

local UnitXP          = _G.UnitXP
local UnitXPMax       = _G.UnitXPMax
local GetXPExhaustion = _G.GetXPExhaustion

local _

-- constants
local FORMAT_NUMBER_PREFIX = "TT"

-- icons
local ICON_PLUS	 = [[|TInterface\BUTTONS\UI-PlusButton-Up:16:16|t]]
local ICON_MINUS = [[|TInterface\BUTTONS\UI-MinusButton-Up:16:16|t]]

local tooltip

-- callbacks
local function BXP_ToggleDetails(cell, option)
	BrokerXPBar:ToggleSetting(option)
	BrokerXPBar:DrawTooltip()
	tooltip:Show()
end

function BrokerXPBar:CreateTooltip(obj)
	tooltip = QT:Acquire( ADDON.."TT", 3 )
	tooltip:Hide()
	tooltip:Clear()
	tooltip:SetScale(1)
		
	self:DrawTooltip()

	tooltip:SetAutoHideDelay(0.1, obj)
	tooltip:EnableMouse()
	tooltip:SmartAnchorTo(obj)
	tooltip:Show()
end

function BrokerXPBar:RemoveTooltip()
	if tooltip then
		tooltip:Hide()
		QT:Release(tooltip)
		tooltip = nil
	end
end

function BrokerXPBar:DrawTooltip()
	tooltip:Hide()
	tooltip:Clear()
	
	local colcount = tooltip:GetColumnCount()	
	
	local totalXP = UnitXPMax("player")
	local currentXP = UnitXP("player")
	local toLevelXP = totalXP - currentXP
	local toLevelXPPercent = floor(((currentXP / totalXP) * 100) + 0.5)

	-- add header
	local lineNum = tooltip:AddHeader( " " )
	tooltip:SetCell(lineNum, 1, NS:Colorize("White", self.FULLNAME), "CENTER", colcount)

	-- add xp data
	if self:GetSetting("ShowXP") then
		-- show current data
		tooltip:AddLine(" ")
		
		if self.playerLvl < self.MAX_LEVEL then
			currentXP = self:FormatNumber(currentXP, FORMAT_NUMBER_PREFIX)
			toLevelXP = self:FormatNumber(toLevelXP, FORMAT_NUMBER_PREFIX)
			
			currentXP, toLevelXP, toLevelXPPercent = NS:ColorizeByValue(toLevelXPPercent, 0, 100, currentXP, toLevelXP, toLevelXPPercent)
			
			local exhaustion = GetXPExhaustion()

			local xpEx, xpExPercent
			
			if exhaustion then
				xpEx = self:FormatNumber(exhaustion, FORMAT_NUMBER_PREFIX)
				
				xpExPercent = floor(((exhaustion / totalXP) * 100) + 0.5)
				
				xpEx, xpExPercent = NS:ColorizeByValue(xpExPercent, 0, 150, xpEx, xpExPercent)
			end
						
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self.playerLvl, "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Current XP"]), "LEFT")
			tooltip:SetCell(lineNum, 2, string.format("%s/%s (%s%%)", currentXP, self:FormatNumber(totalXP, FORMAT_NUMBER_PREFIX), toLevelXPPercent), "LEFT")

			if exhaustion then
				lineNum = tooltip:AddLine(" ")
				tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Rested XP"]), "LEFT")
				tooltip:SetCell(lineNum, 2, string.format("%s (%s%%)", xpEx, xpExPercent), "LEFT")
			end
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["To next level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, toLevelXP, "LEFT")
		
			-- toggle history data +/-
			tooltip:SetCell(lineNum, 3, self:GetSetting("TTHideXPDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", BXP_ToggleDetails, "TTHideXPDetails")
		else
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, tostring(self.playerLvl) .. " " .. L["(max. Level)"], "LEFT")
		end
		
		-- show history data
		if not self:GetSetting("TTHideXPDetails") and self.playerLvl < self.MAX_LEVEL then
			self.History:Process()
			
			local kph  = floor(self.History:GetKillsPerHour())
			local xpph = floor(self.History:GetXPPerHour())
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Session XP"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self:FormatNumber(self.History.totalXP, FORMAT_NUMBER_PREFIX), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Session kills"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self.History.totalKills, "LEFT")
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["XP per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self:FormatNumber(xpph, FORMAT_NUMBER_PREFIX), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Kills per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, kph, "LEFT")
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Time to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self.History:GetTimeToLevel(), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Kills to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, NS:Colorize("Red", self.History:GetKillsToLevel() ), "LEFT")		
		end
		
	end
	
	-- add reputation data
	if self:GetSetting("ShowRep") and self.faction ~= 0 then
		lineNum = tooltip:AddLine(" ")
	
		local name, desc, standing, minRep, maxRep, currentRep, _, _, _, _, _, _, _, _, friendID = NS:GetFactionInfo(self.faction)
		local r, g, b, a = self:GetBlizzardReputationColor(standing, friendID)
		
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Faction"]), "LEFT")
		tooltip:SetCell(lineNum, 2, name, "LEFT")

		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Standing"]), "LEFT")
		tooltip:SetCell(lineNum, 2, "|cff" .. string.format("%02x%02x%02x", r*255, g*255, b*255) .. NS:GetStandingLabel(standing, friendID) .. "|r", "LEFT")		

		if not self.atMaxRep then
			local fullLevelRep = maxRep - minRep
			local toLevelRep   = maxRep - currentRep
			local atLevelRep   = fullLevelRep - toLevelRep
			local percentRep   = floor((atLevelRep / fullLevelRep) * 100)

			atLevelRep = self:FormatNumber(atLevelRep, FORMAT_NUMBER_PREFIX)
			toLevelRep = self:FormatNumber(toLevelRep, FORMAT_NUMBER_PREFIX)
				
			atLevelRep, toLevelRep, percentRep = NS:ColorizeByValue(percentRep, 0, 100, atLevelRep, toLevelRep, percentRep)

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Current reputation"]), "LEFT")
			tooltip:SetCell(lineNum, 2, string.format("%s/%s (%s%%)", atLevelRep, self:FormatNumber(fullLevelRep, FORMAT_NUMBER_PREFIX), percentRep), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["To next standing"]), "LEFT")
			tooltip:SetCell(lineNum, 2, toLevelRep, "LEFT")

			-- toggle history data +/-
			tooltip:SetCell(lineNum, 3, self:GetSetting("TTHideRepDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", BXP_ToggleDetails, "TTHideRepDetails")
		end
		
		-- show history data
		if not self:GetSetting("TTHideRepDetails") and not self.atMaxRep then
			self.ReputationHistory:ProcessFaction(self.faction)
			
			local total = self.ReputationHistory:GetTotalRep(self.faction)
			local repph = floor(self.ReputationHistory:GetRepPerHour(self.faction))
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Session rep"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self:FormatNumber(total, FORMAT_NUMBER_PREFIX), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Rep per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self:FormatNumber(repph, FORMAT_NUMBER_PREFIX), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Time to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, self.ReputationHistory:GetTimeToLevel(self.faction), "LEFT")
		end
		
	end
	
	-- add hint
	if not self:GetSetting("HideHint") then
		tooltip:AddLine(" ")
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1,  NS:Colorize("Brownish", L["Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current XP to an open editbox."] ), nil, "LEFT", colcount)
		if self.faction ~= 0 then
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Shift-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current reputation to an open editbox."] ), nil, "LEFT", colcount )
		end
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Right-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Open option menu."] ), nil, "LEFT", colcount )
	end
	
end

