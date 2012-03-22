-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Gathering")

local function debug(...)
	TSM:Debug(...)
end

local FRAME_WIDTH = 250
local FRAME_HEIGHT = 185 -- ERR_INV_FULL
local MAX_TASKS = 10

-- color codes
local CYAN = "|cff99ffff"
local BLUE = "|cff5555ff"
local GREEN = "|cff00ff00"
local RED = "|cffff0000"
local WHITE = "|cffffffff"
local GOLD = "|cffffbb00"
local YELLOW = "|cffffd000"

function GUI:OnInitialize()
	GUI:RegisterEvent("MERCHANT_SHOW", "CreateMerchantBuyButton")
end

local function ShowTooltip(frame, tooltip)
	if tooltip then
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end
end

local function HideTooltip()
	GameTooltip:Hide()
end

function GUI:Create()
	-- Gathering GUI
	local frame = CreateFrame("Frame")
	frame:SetWidth(FRAME_WIDTH)
	frame:SetHeight(FRAME_HEIGHT)
	frame:SetPoint("RIGHT", UIParent, "RIGHT", -10, 10)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", frame.StartMoving)
	frame:SetScript("OnMouseUp", frame.StopMovingOrSizing)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	frame:SetBackdropColor(0, 0, 0.05, 1)
	frame:SetBackdropBorderColor(0,0,1,1)
	
	-- title frame
	local titleFrame = CreateFrame("Frame", nil, frame)
	titleFrame:EnableMouse(true)
	titleFrame:SetScript("OnMouseDown", function(self) self:GetParent():StartMoving() end)
	titleFrame:SetScript("OnMouseUp", function(self) self:GetParent():StopMovingOrSizing() end)
	titleFrame:SetWidth(FRAME_WIDTH-50)
	titleFrame:SetHeight(25)
	titleFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 12,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
	})
	titleFrame:SetBackdropColor(0, 0, 0.05, 1)
	titleFrame:SetBackdropBorderColor(0, 0, 0.7, 1)
	titleFrame:SetPoint("TOP", 0, 23)
	
	-- title text for title frame
	local tFile, tSize = GameFontNormalSmall:GetFont()
	local titleText = titleFrame:CreateFontString(nil, "Overlay", "GameFontNormalSmall")
	titleText:SetFont(tFile, tSize+1, "OUTLINE")
	titleText:SetTextColor(1, 1, 1, 1)
	titleText:SetAllPoints(titleFrame)
	titleText:SetText("TSM_Gathering " .. TSM.version)
	
	local tFile, tSize = GameFontHighlight:GetFont()
	local label = frame:CreateFontString(nil, "Overlay", "GameFontHighlight")
	label:SetFont(tFile, tSize-1)
	label:SetTextColor(1, 1, 1, 1)
	label:SetJustifyH("CENTER")
	label:SetJustifyV("TOP")
	label:SetPoint("TOPLEFT", 10, -15)
	label:SetPoint("TOPRIGHT", -10, -15)
	frame.label = label
	
	local horizontalBarFrame = CreateFrame("Frame", nil, frame)
	horizontalBarFrame:SetPoint("LEFT", frame, "TOPLEFT", 5, -35)
	horizontalBarFrame:SetPoint("RIGHT", frame, "TOPRIGHT", -5, -35)
	horizontalBarFrame:SetHeight(6)

	local horizontalBarTex = horizontalBarFrame:CreateTexture()
	horizontalBarTex:SetAllPoints(horizontalBarFrame)
	horizontalBarTex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	horizontalBarTex:SetTexCoord(0.577, 0.683, 0.145, 0.309)
	horizontalBarTex:SetVertexColor(0, 0, 0.7, 1)
	
	local tFile, tSize = GameFontHighlight:GetFont()
	local currentTask = frame:CreateFontString(nil, "Overlay", "GameFontHighlight")
	currentTask:SetFont(tFile, tSize)
	currentTask:SetTextColor(1, 1, 1, 1)
	currentTask:SetJustifyH("LEFT")
	currentTask:SetJustifyV("TOP")
	currentTask:SetPoint("TOPLEFT", horizontalBarFrame, "TOPLEFT", 4, -10)
	currentTask:SetPoint("TOPRIGHT", horizontalBarFrame, "TOPRIGHT", -4, -10)
	local ttFrame = CreateFrame("Frame")
	ttFrame:SetScript("OnEnter", function(self) ShowTooltip(self, currentTask.tooltip) end)
	ttFrame:SetScript("OnLeave", HideTooltip)
	ttFrame:SetAllPoints(currentTask)
	currentTask.frame = frame
	frame.currentTask = currentTask
	
	local horizontalBarFrame2 = CreateFrame("Frame", nil, frame)
	horizontalBarFrame2:SetPoint("LEFT", horizontalBarFrame, "TOPLEFT", 0, -30)
	horizontalBarFrame2:SetPoint("RIGHT", horizontalBarFrame, "TOPRIGHT", 0, -30)
	horizontalBarFrame2:SetHeight(6)

	local horizontalBarTex2 = horizontalBarFrame2:CreateTexture()
	horizontalBarTex2:SetAllPoints(horizontalBarFrame2)
	horizontalBarTex2:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	horizontalBarTex2:SetTexCoord(0.577, 0.683, 0.145, 0.309)
	horizontalBarTex2:SetVertexColor(0, 0, 0.7, 1)
	
	local stopButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	stopButton:SetHeight(25)
	stopButton:SetText(L["Stop Gathering"])
	stopButton:GetFontString():SetPoint("CENTER")
	local tFile, tSize = GameFontNormal:GetFont()
	stopButton:GetFontString():SetFont(tFile, tSize, "OUTLINE")
	stopButton:GetFontString():SetTextColor(1, 1, 1, 1)
	stopButton:SetPushedTextOffset(0, 0)
	stopButton:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 20,
		insets = {left = 2, right = 2, top = 4, bottom = 4},
	})
	stopButton:SetScript("OnDisable", function(self) self:GetFontString():SetTextColor(0.5, 0.5, 0.5, 1) end)
	stopButton:SetScript("OnEnable", function(self) self:GetFontString():SetTextColor(1, 1, 1, 1) end)	
	stopButton:SetScript("OnClick", function() TSM.Gather:StopGathering() end)
	stopButton:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 10, 2)
	stopButton:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -10, 2)
	
	frame.stopButton = stopButton
	
	local texture = "Interface\\TokenFrame\\UI-TokenFrame-CategoryButton"
	local offset = 6
	
	local normalTex = stopButton:CreateTexture()
	normalTex:SetTexture(texture)
	normalTex:SetPoint("TOPRIGHT", stopButton, "TOPRIGHT", -offset, -offset)
	normalTex:SetPoint("BOTTOMLEFT", stopButton, "BOTTOMLEFT", offset, offset)
	
	local disabledTex = stopButton:CreateTexture()
	disabledTex:SetTexture(texture)
	disabledTex:SetPoint("TOPRIGHT", stopButton, "TOPRIGHT", -offset, -offset)
	disabledTex:SetPoint("BOTTOMLEFT", stopButton, "BOTTOMLEFT", offset, offset)
	disabledTex:SetVertexColor(0.1, 0.1, 0.1, 1)
	
	local highlightTex = stopButton:CreateTexture()
	highlightTex:SetTexture(texture)
	highlightTex:SetPoint("TOPRIGHT", stopButton, "TOPRIGHT", -offset, -offset)
	highlightTex:SetPoint("BOTTOMLEFT", stopButton, "BOTTOMLEFT", offset, offset)
	
	local pressedTex = stopButton:CreateTexture()
	pressedTex:SetTexture(texture)
	pressedTex:SetPoint("TOPRIGHT", stopButton, "TOPRIGHT", -offset, -offset)
	pressedTex:SetPoint("BOTTOMLEFT", stopButton, "BOTTOMLEFT", offset, offset)
	pressedTex:SetVertexColor(1, 1, 1, 0.5)
	normalTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
	disabledTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
	highlightTex:SetTexCoord(0.005, 0.994, 0.613, 0.785)
	highlightTex:SetVertexColor(0.3, 0.3, 0.3, 0.7)
	pressedTex:SetTexCoord(0.0256, 0.743, 0.017, 0.158)
	
	stopButton:SetPushedTextOffset(0, -3)
	stopButton:SetNormalTexture(normalTex)
	stopButton:SetDisabledTexture(disabledTex)
	stopButton:SetHighlightTexture(highlightTex)
	stopButton:SetPushedTexture(pressedTex)
	
	GUI.rows = {}
	
	for i=1, MAX_TASKS do
		local tFile, tSize = GameFontHighlight:GetFont()
		local task = frame:CreateFontString(nil, "Overlay", "GameFontHighlight")
		task:SetFont(tFile, tSize-3)
		task:SetTextColor(1, 1, 1, 1)
		task:SetJustifyH("LEFT")
		task:SetJustifyV("TOP")
		
		local frame = CreateFrame("Frame")
		frame:SetScript("OnEnter", function(self) ShowTooltip(self, task.tooltip) end)
		frame:SetScript("OnLeave", HideTooltip)
		task.frame = frame
		
		if not GUI.rows[i-1] then
			task:SetPoint("TOPLEFT", horizontalBarFrame2, "BOTTOMLEFT", 2, -2)
			task:SetPoint("TOPRIGHT", horizontalBarFrame2, "BOTTOMRIGHT", -2, -2)
		else
			task:SetPoint("TOPLEFT", GUI.rows[i-1], "BOTTOMLEFT", 0, -2)
			task:SetPoint("TOPRIGHT", GUI.rows[i-1], "BOTTOMRIGHT", 0, -2)
		end
		frame:SetAllPoints(task)
		GUI.rows[i] = task
	end
	
	GUI.frame = frame
	GUI.frame:Hide()
end

function GUI:UpdateFrame()
	GUI.frame:Show()
	GUI.frame.label:SetText(L["Currently Gathering for:"].." " .. GOLD .. L[TSM.db.factionrealm.currentProfession] .. "|r")
	
	if #(TSM.tasks) == 0 then GUI.frame:Hide() end
	
	for i=1, MAX_TASKS do
		GUI.rows[i]:SetText(i)
		GUI.rows[i]:Hide()
	end
	
	for i=0, min(#(TSM.tasks), MAX_TASKS)-1 do
		local color = (i==0 and GREEN) or RED
		local row = GUI.rows[i] or GUI.frame.currentTask
		local text = (i==0 and "Current") or "Next"
		local location = TSM.tasks[i+1].location
		
		local taskText = ""
		if location == "LOGON" then
			taskText = format(L["Log onto %s"], TSM.tasks[i+1].player)
		elseif location == "MAIL" then
			row.tooltip = GOLD..L["Mailing:"].."|r\n"..WHITE
			for itemID, quantity in pairs(TSM.tasks[i+1].items) do
				local link = select(2, GetItemInfo(itemID)) or itemID
				row.tooltip = row.tooltip..CYAN..quantity.."x"..WHITE..link.."\n"
			end
			taskText = L["Visit the Mailbox"]
		elseif location == "BANK" then
			row.tooltip = GOLD..L["Gathering from Bank:"].."|r\n"..WHITE
			for itemID, quantity in pairs(TSM.tasks[i+1].items) do
				local link = select(2, GetItemInfo(itemID)) or itemID
				row.tooltip = row.tooltip..CYAN..quantity.."x"..WHITE..link.."\n"
			end
			taskText = L["Visit the Bank"]
		elseif location == "GUILDBANK" then
			row.tooltip = GOLD..L["Gathering from Guild Bank:"].."|r\n"..WHITE
			for itemID, quantity in pairs(TSM.tasks[i+1].items) do
				local link = select(2, GetItemInfo(itemID)) or itemID
				row.tooltip = row.tooltip..CYAN..quantity.."x"..WHITE..link.."\n"
			end
			taskText = L["Visit the Guild Bank"]
		end
		
		row:Show()
		row:SetText(color .. text .. " "..L["Task:"].." |r" .. taskText)
	end
end

function GUI:CreateMerchantBuyButton()
	if not GUI.merchantButton then
		local buyButton = CreateFrame("Button", nil, MerchantFrame, "UIPanelButtonTemplate")
		buyButton:SetHeight(25)
		buyButton:SetText("TSM_Gathering - "..L["Buy Merchant Items"])
		buyButton:GetFontString():SetPoint("CENTER")
		local tFile, tSize = GameFontNormal:GetFont()
		buyButton:GetFontString():SetFont(tFile, tSize, "OUTLINE")
		buyButton:GetFontString():SetTextColor(1, 1, 1, 1)
		buyButton:SetPushedTextOffset(0, 0)
		buyButton:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 2, right = 2, top = 4, bottom = 4},
		})
		buyButton:SetScript("OnDisable", function(self) self:GetFontString():SetTextColor(0.5, 0.5, 0.5, 1) end)
		buyButton:SetScript("OnEnable", function(self) self:GetFontString():SetTextColor(1, 1, 1, 1) end)	
		buyButton:SetScript("OnClick", function(self)
				self:Disable()
				TSMAPI:CreateTimeDelay("gathervendor", 5, function() self:Enable() end)
				GUI:BuyFromMerchant()
			end)
		buyButton:SetPoint("TOPLEFT", 70, 10)
		buyButton:SetPoint("TOPRIGHT", -40, 10)
		
		GUI.merchantButton = buyButton
		
		local texture = "Interface\\TokenFrame\\UI-TokenFrame-CategoryButton"
		local offset = 6
		
		local normalTex = buyButton:CreateTexture()
		normalTex:SetTexture(texture)
		normalTex:SetPoint("TOPRIGHT", buyButton, "TOPRIGHT", -offset, -offset)
		normalTex:SetPoint("BOTTOMLEFT", buyButton, "BOTTOMLEFT", offset, offset)
		
		local disabledTex = buyButton:CreateTexture()
		disabledTex:SetTexture(texture)
		disabledTex:SetPoint("TOPRIGHT", buyButton, "TOPRIGHT", -offset, -offset)
		disabledTex:SetPoint("BOTTOMLEFT", buyButton, "BOTTOMLEFT", offset, offset)
		disabledTex:SetVertexColor(0.1, 0.1, 0.1, 1)
		
		local highlightTex = buyButton:CreateTexture()
		highlightTex:SetTexture(texture)
		highlightTex:SetPoint("TOPRIGHT", buyButton, "TOPRIGHT", -offset, -offset)
		highlightTex:SetPoint("BOTTOMLEFT", buyButton, "BOTTOMLEFT", offset, offset)
		
		local pressedTex = buyButton:CreateTexture()
		pressedTex:SetTexture(texture)
		pressedTex:SetPoint("TOPRIGHT", buyButton, "TOPRIGHT", -offset, -offset)
		pressedTex:SetPoint("BOTTOMLEFT", buyButton, "BOTTOMLEFT", offset, offset)
		pressedTex:SetVertexColor(1, 1, 1, 0.5)
		normalTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
		disabledTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
		highlightTex:SetTexCoord(0.005, 0.994, 0.613, 0.785)
		highlightTex:SetVertexColor(0.3, 0.3, 0.3, 0.7)
		pressedTex:SetTexCoord(0.0256, 0.743, 0.017, 0.158)
		
		buyButton:SetPushedTextOffset(0, -3)
		buyButton:SetNormalTexture(normalTex)
		buyButton:SetDisabledTexture(disabledTex)
		buyButton:SetHighlightTexture(highlightTex)
		buyButton:SetPushedTexture(pressedTex)
	end
end

function GUI:BuyFromMerchant()
	local shoppingList = CopyTable(TSMAPI:GetData("shopping")) or {}
	local matList = {}
	for _, data in pairs(shoppingList) do
		matList[data[1]] = data[2]
	end
	
	for i=1, GetMerchantNumItems() do
		local itemID = TSMAPI:GetItemID(GetMerchantItemLink(i))
		if matList[itemID] then
			local maxStack = GetMerchantItemMaxStack(i)
			local toBuy = matList[itemID]
			while toBuy > 0 do
				BuyMerchantItem(i, math.min(toBuy, maxStack))
				toBuy = toBuy - maxStack
			end
		end
	end
end