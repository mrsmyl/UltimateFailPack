local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Tooltip module
local Tooltip = Addon:NewModule("Tooltip")

-- tooltip library
local QT = LibStub:GetLibrary("LibQTip-1.0")

-- get translations
local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- local functions
local floor    = math.floor
local tostring = tostring

local UnitXP          = _G.UnitXP
local UnitXPMax       = _G.UnitXPMax
local GetXPExhaustion = _G.GetXPExhaustion

-- local variables
local _

local tooltip = nil

-- constants
local FORMAT_NUMBER_PREFIX = "TT"

-- icons
local ICON_PLUS	 = [[|TInterface\BUTTONS\UI-PlusButton-Up:16:16|t]]
local ICON_MINUS = [[|TInterface\BUTTONS\UI-MinusButton-Up:16:16|t]]

-- callbacks
local function ToggleDetails(cell, option)
	local options = Addon:GetModule("Options")
	
	if options then
		options:ToggleSetting(option)
	
		Tooltip:Refresh()
	end
end

-- module handling
function Tooltip:OnInitialize()
	-- empty
end

function Tooltip:OnEnable()
	-- empty
end

function Tooltip:OnDisable()
	self:Remove()
end

function Tooltip:Create(obj)
	if not self:IsEnabled() then
		return
	end

	tooltip = QT:Acquire(ADDON.."TT", 3)
	
	tooltip:Hide()
	tooltip:Clear()
	tooltip:SetScale(1)
		
	self:Draw()

	tooltip:SetAutoHideDelay(0.1, obj)
	tooltip:EnableMouse()
	tooltip:SmartAnchorTo(obj)
	tooltip:Show()
end

function Tooltip:Remove()
	if tooltip then
		tooltip:Hide()
		QT:Release(tooltip)
		tooltip = nil
	end
end

function Tooltip:Refresh()
	if not self:IsEnabled() then
		self:Remove()
		return
	end
	
	self:Draw()
	
	tooltip:Show()
end

function Tooltip:Draw()
	if not tooltip then
		return
	end

	tooltip:Hide()
	tooltip:Clear()
	
	local colcount = tooltip:GetColumnCount()	
	
	local totalXP = UnitXPMax("player")
	local currentXP = UnitXP("player")
	local toLevelXP = totalXP - currentXP
	local toLevelXPPercent = floor(((currentXP / totalXP) * 100) + 0.5)

	-- add header
	local lineNum = tooltip:AddHeader( " " )
	tooltip:SetCell(lineNum, 1, NS:Colorize("White", Addon.FULLNAME), "CENTER", colcount)

	-- add xp data
	if Addon:GetSetting("ShowXP") then
		-- show current data
		tooltip:AddLine(" ")
		
		if Addon.playerLvl < Addon.MAX_LEVEL then
			currentXP = Addon:FormatNumber(currentXP, FORMAT_NUMBER_PREFIX)
			toLevelXP = Addon:FormatNumber(toLevelXP, FORMAT_NUMBER_PREFIX)
			
			currentXP, toLevelXP, toLevelXPPercent = NS:ColorizeByValue(toLevelXPPercent, 0, 100, currentXP, toLevelXP, toLevelXPPercent)
			
			local exhaustion = GetXPExhaustion()

			local xpEx, xpExPercent
			
			if exhaustion then
				xpEx = Addon:FormatNumber(exhaustion, FORMAT_NUMBER_PREFIX)
				
				xpExPercent = floor(((exhaustion / totalXP) * 100) + 0.5)
				
				xpEx, xpExPercent = NS:ColorizeByValue(xpExPercent, 0, 150, xpEx, xpExPercent)
			end
						
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon.playerLvl, "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Current XP"]), "LEFT")
			tooltip:SetCell(lineNum, 2, string.format("%s/%s (%s%%)", currentXP, Addon:FormatNumber(totalXP, FORMAT_NUMBER_PREFIX), toLevelXPPercent), "LEFT")

			if exhaustion then
				lineNum = tooltip:AddLine(" ")
				tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Rested XP"]), "LEFT")
				tooltip:SetCell(lineNum, 2, string.format("%s (%s%%)", xpEx, xpExPercent), "LEFT")
			end
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["To next level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, toLevelXP, "LEFT")
		
			-- toggle history data +/-
			tooltip:SetCell(lineNum, 3, Addon:GetSetting("TTHideXPDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", ToggleDetails, "TTHideXPDetails")
		else
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, tostring(Addon.playerLvl) .. " " .. L["(max. Level)"], "LEFT")
		end
		
		-- show history data
		if not Addon:GetSetting("TTHideXPDetails") and Addon.playerLvl < Addon.MAX_LEVEL then
			Addon.History:Process()
			
			local kph  = floor(Addon.History:GetKillsPerHour())
			local xpph = floor(Addon.History:GetXPPerHour())
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Session XP"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon:FormatNumber(Addon.History.totalXP, FORMAT_NUMBER_PREFIX), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Session kills"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon.History.totalKills, "LEFT")
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["XP per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon:FormatNumber(xpph, FORMAT_NUMBER_PREFIX), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Kills per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, kph, "LEFT")
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Time to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon.History:GetTimeToLevel(), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Blueish", L["Kills to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, NS:Colorize("Red", Addon.History:GetKillsToLevel() ), "LEFT")		
		end
		
	end
	
	-- add reputation data
	local faction = Addon:GetFaction()
	
	if Addon:GetSetting("ShowRep") and faction ~= 0 then
		lineNum = tooltip:AddLine(" ")
	
		local name, desc, standing, minRep, maxRep, currentRep, _, _, _, _, _, _, _, _, friendID = NS:GetFactionInfo(faction)
		local r, g, b, a = Addon:GetBlizzardReputationColor(standing, friendID)
		
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Faction"]), "LEFT")
		tooltip:SetCell(lineNum, 2, name, "LEFT")

		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Standing"]), "LEFT")
		tooltip:SetCell(lineNum, 2, "|cff" .. string.format("%02x%02x%02x", r*255, g*255, b*255) .. NS:GetStandingLabel(standing, friendID) .. "|r", "LEFT")		

		if not Addon.atMaxRep then
			local fullLevelRep = maxRep - minRep
			local toLevelRep   = maxRep - currentRep
			local atLevelRep   = fullLevelRep - toLevelRep
			local percentRep   = floor((atLevelRep / fullLevelRep) * 100)

			atLevelRep = Addon:FormatNumber(atLevelRep, FORMAT_NUMBER_PREFIX)
			toLevelRep = Addon:FormatNumber(toLevelRep, FORMAT_NUMBER_PREFIX)
				
			atLevelRep, toLevelRep, percentRep = NS:ColorizeByValue(percentRep, 0, 100, atLevelRep, toLevelRep, percentRep)

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Current reputation"]), "LEFT")
			tooltip:SetCell(lineNum, 2, string.format("%s/%s (%s%%)", atLevelRep, Addon:FormatNumber(fullLevelRep, FORMAT_NUMBER_PREFIX), percentRep), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["To next standing"]), "LEFT")
			tooltip:SetCell(lineNum, 2, toLevelRep, "LEFT")

			-- toggle history data +/-
			tooltip:SetCell(lineNum, 3, Addon:GetSetting("TTHideRepDetails") and ICON_PLUS or ICON_MINUS, "RIGHT")
			tooltip:SetCellScript(lineNum, 3, "OnMouseDown", ToggleDetails, "TTHideRepDetails")
		end
		
		-- show history data
		if not Addon:GetSetting("TTHideRepDetails") and not Addon.atMaxRep then
			Addon.ReputationHistory:ProcessFaction(faction)
			
			local total = Addon.ReputationHistory:GetTotalRep(faction)
			local repph = floor(Addon.ReputationHistory:GetRepPerHour(faction))
			
			tooltip:AddLine(" ")
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Session rep"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon:FormatNumber(total, FORMAT_NUMBER_PREFIX), "LEFT")
			
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Rep per hour"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon:FormatNumber(repph, FORMAT_NUMBER_PREFIX), "LEFT")

			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Orange", L["Time to level"]), "LEFT")
			tooltip:SetCell(lineNum, 2, Addon.ReputationHistory:GetTimeToLevel(faction), "LEFT")
		end
		
	end
	
	-- add hint
	if not Addon:GetSetting("HideHint") then
		tooltip:AddLine(" ")
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1,  NS:Colorize("Brownish", L["Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current XP to an open editbox."] ), nil, "LEFT", colcount)
		if faction ~= 0 then
			lineNum = tooltip:AddLine(" ")
			tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Shift-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Send current reputation to an open editbox."] ), nil, "LEFT", colcount )
		end
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Right-Click"] .. ":" ) .. " " .. NS:Colorize("Yellow", L["Open option menu."] ), nil, "LEFT", colcount )
	end
	
end

