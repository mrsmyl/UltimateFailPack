local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local BrokerXPBar = _G.BrokerXPBar

-- tooltip library
local QT		= LibStub:GetLibrary("LibQTip-1.0")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale( ADDON )

-- coloring tools
local Crayon	= LibStub:GetLibrary("LibCrayon-3.0")

-- local functions
local floor = math.floor

local UnitXP          = _G.UnitXP
local UnitXPMax       = _G.UnitXPMax
local GetFactionInfo  = _G.GetFactionInfo
local GetXPExhaustion = _G.GetXPExhaustion

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
	local toLevelXPPercent = floor((currentXP / totalXP) * 100)

	-- add header
	local lineNum = tooltip:AddHeader( " " )
	tooltip:SetCell( lineNum, 1, NS:Colorize("White", self.FULLNAME), "CENTER", colcount )

	-- add xp data
	if self:GetSetting("ShowXP") then
		-- show current data
		tooltip:AddLine( " " )
		
		if self.playerLvl < self.MAX_LEVEL then
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self.playerLvl, "LEFT" )
		
			local exhaustion = GetXPExhaustion()

			local xpEx, xpExPercent
			
			if exhaustion then
				xpEx = exhaustion
				
				if xpEx - toLevelXP > 0 then
					xpExPercent = floor(((xpEx - toLevelXP) / totalXP) * 100)
				else
					xpExPercent = floor((xpEx / totalXP) * 100)
				end
				
				xpEx        = self:FormatNumberTip(xpEx)
				xpExPercent = xpExPercent
					
				if Crayon then
					local hexColor = Crayon:GetThresholdHexColor(xpExPercent, 1, 25, 50, 75, 100)
					
					xpEx           = "|cff" .. hexColor .. xpEx .. "|r"
					xpExPercent    = "|cff" .. hexColor .. xpExPercent .. "|r"
				end
				
				if exhaustion - toLevelXP > 0 then
					xpExPercent = "100% + "..xpExPercent
				end
			end
			
			currentXP = self:FormatNumberTip(currentXP)
			toLevelXP = self:FormatNumberTip(toLevelXP)
			
			if Crayon then
				local hexColor   = Crayon:GetThresholdHexColor(toLevelXPPercent, 1, 25, 50, 75, 100)
				
				currentXP        = "|cff" .. hexColor .. currentXP .. "|r"
				toLevelXP        = "|cff" .. hexColor .. toLevelXP .. "|r"
				toLevelXPPercent = "|cff" .. hexColor .. toLevelXPPercent .. "|r"
			end
			
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Current XP"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, string.format("%s/%s (%s%%)", currentXP, self:FormatNumberTip(totalXP), toLevelXPPercent), "LEFT" )

			if exhaustion then
				lineNum = tooltip:AddLine( " " )
				tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Rested XP"]), "LEFT" )
				tooltip:SetCell( lineNum, 2, string.format("%s (%s%%)", xpEx, xpExPercent), "LEFT" )
			end
			
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["To next level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, toLevelXP, "LEFT" )
		
			-- toggle history data +/-
			tooltip:SetCell( lineNum, 3, self:GetSetting("TTHideXPDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", BXP_ToggleDetails, "TTHideXPDetails")
		else
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, tostring(self.playerLvl) .. " " .. L["(max. Level)"], "LEFT" )
		end
		
		-- show history data
		if not self:GetSetting("TTHideXPDetails") and self.playerLvl < self.MAX_LEVEL then
			self.History:Process()
			
			local kph  = self.History:GetKillsPerHour()
			local xpph = self.History:GetXPPerHour()
			
			if kph then
				kph = floor(kph)
			else
				kph = "~"
			end

			if xpph then
				xpph = floor(xpph)
			else
				xpph = "~"
			end

			tooltip:AddLine( " " )
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Session XP"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self:FormatNumberTip(self.History.totalXP), "LEFT" )
			
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Session kills"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self.History.totalKills, "LEFT" )
			
			tooltip:AddLine( " " )
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["XP per hour"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self:FormatNumberTip(xpph), "LEFT" )

			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Kills per hour"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, kph, "LEFT" )
			
			tooltip:AddLine( " " )
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Time to level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self.History:GetTimeToLevel(), "LEFT" )
			
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Blueish", L["Kills to level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, NS:Colorize("Red", self.History:GetKillsToLevel() ), "LEFT" )		
		end
		
	end
	
	-- add reputation data
	if self:GetSetting("ShowRep") and self.faction ~= 0 then
		lineNum = tooltip:AddLine( " " )
	
		local name, desc, standing, minRep, maxRep, currentRep = GetFactionInfo(self.faction)
		local r, g, b, a = self:GetBlizzardReputationColor(standing)
		
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Faction"]), "LEFT" )
		tooltip:SetCell( lineNum, 2, name, "LEFT" )

		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Standing"]), "LEFT" )
		tooltip:SetCell( lineNum, 2, "|cff"..string.format("%02x%02x%02x", r*255, g*255, b*255)..getglobal("FACTION_STANDING_LABEL"..standing).."|r", "LEFT" )		

		if not self.atMaxRep then
			local fullLevelRep = maxRep - minRep
			local toLevelRep   = maxRep - currentRep
			local atLevelRep   = fullLevelRep - toLevelRep
			local percentRep   = floor((atLevelRep / fullLevelRep) * 100)

			atLevelRep = self:FormatNumberTip(atLevelRep)
			toLevelRep = self:FormatNumberTip(toLevelRep)
				
			if Crayon then
				local hexColor   = Crayon:GetThresholdHexColor(percentRep, 1, 25, 50, 75, 100)
				
				atLevelRep = "|cff" .. hexColor .. atLevelRep .. "|r"
				toLevelRep = "|cff" .. hexColor .. toLevelRep .. "|r"
				percentRep = "|cff" .. hexColor .. percentRep .. "|r"
			end

			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Current reputation"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, string.format("%s/%s (%s%%)", atLevelRep, self:FormatNumberTip(fullLevelRep), percentRep), "LEFT" )

			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["To next standing"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, toLevelRep, "LEFT" )

			-- toggle history data +/-
			tooltip:SetCell(lineNum, 3, self:GetSetting("TTHideRepDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", BXP_ToggleDetails, "TTHideRepDetails")
		end
		
		-- show history data
		if not self:GetSetting("TTHideRepDetails") and not self.atMaxRep then
			self.ReputationHistory:Process()
			
			local total = self.ReputationHistory:GetTotalRep(self.faction) or L["no data"]
			local repph = self.ReputationHistory:GetRepPerHour(self.faction)
			
			if repph then
				repph = floor(repph)
			else
				repph = "~"
			end
			
			tooltip:AddLine( " " )
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Session rep"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self:FormatNumberTip(total), "LEFT" )
			
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Rep per hour"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self:FormatNumberTip(repph), "LEFT" )

			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Orange", L["Time to level"]), "LEFT" )
			tooltip:SetCell( lineNum, 2, self.ReputationHistory:GetTimeToLevel(self.faction) or L["no data"], "LEFT" )
		end
		
	end
	
	-- add hint
	if not self:GetSetting("HideHint") then
		tooltip:AddLine( " " )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1,  NS:Colorize("Brownish", L["Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current XP to an open editbox."] ), nil, "LEFT", colcount)
		if self.faction ~= 0 then
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, NS:Colorize("Brownish", L["Shift-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current reputation to an open editbox."] ), nil, "LEFT", colcount )
		end
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, NS:Colorize("Brownish", L["Right-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Open option menu."] ), nil, "LEFT", colcount )
	end
	
end

