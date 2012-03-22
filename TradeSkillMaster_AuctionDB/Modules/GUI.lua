-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table
local GUIUtil = TSMAPI:GetGUIFunctions()

local professions = {
	Enchanting = L["Enchanting"],
	Inscription = L["Inscription"],
	Jewelcrafting = L["Jewelcrafting"],
	Alchemy = L["Alchemy"],
	Blacksmithing = L["Blacksmithing"],
	Leatherworking = L["Leatherworking"],
	Tailoring = L["Tailoring"],
	Engineering = L["Engineering"],
	Cooking = L["Cooking"],
}
	
local private = {}

function GUI:OnInitialize()
	TSMTEST = TSMAPI:RegisterAuctionFunction("TradeSkillMaster_AuctionDB", GUI, L["Run Scan"], L["Scan the auction house with AuctionDB to update its market value and min buyout data."])end

function GUI:Show(frame)
	private.statusBar = private.statusBar or private:CreateStatusBar(frame.content)
	private.statusBar:Show()
	GUI:UpdateStatus("", 0, 0)
	
	private.startScanContent = private.startScanContent or private:CreateStartScanContent(frame.content)
	private.startScanContent:Show()
end

function GUI:Hide()
	private.statusBar:Hide()
	private.startScanContent:Hide()
	
	TSMAPI:StopScan()
end

function GUI:UpdateStatus(text, major, minor)
	if text then
		private.statusBar:SetStatusText(text)
	end
	if major or minor then
		private.statusBar:UpdateStatus(major, minor)
	end
end

function private:CreateStatusBar(parent)
	local function UpdateStatus(self, majorStatus, minorStatus)
		if majorStatus then
			self.majorStatusBar:SetValue(majorStatus)
		end
		if minorStatus then
			self.minorStatusBar:SetValue(minorStatus)
		end
	end
	
	local function SetStatusText(self, text)
		self.text:SetText(text)
	end

	local level = parent:GetFrameLevel()
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(30)
	frame:SetPoint("TOPLEFT", 0, -1)
	frame:SetPoint("TOPRIGHT", 0, -1)
	frame:SetFrameLevel(level+1)
	frame.UpdateStatus = UpdateStatus
	frame.SetStatusText = SetStatusText
	
	-- minor status bar (gray one)
	local statusBar = CreateFrame("STATUSBAR", "TSMAuctionDBMinorStatusBar", frame, "TextStatusBar")
	statusBar:SetOrientation("HORIZONTAL")
	statusBar:SetMinMaxValues(0, 100)
	statusBar:SetPoint("TOPLEFT", 4, -4)
	statusBar:SetPoint("BOTTOMRIGHT", -4, 4)
	statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
	statusBar:SetStatusBarColor(0.85, 0.85, 1, 0.5)
	statusBar:SetFrameLevel(level+2)
	frame.minorStatusBar = statusBar
	
	-- major status bar (main blue one)
	local statusBar = CreateFrame("STATUSBAR", "TSMAuctionDBMajorStatusBar", frame, "TextStatusBar")
	statusBar:SetOrientation("HORIZONTAL")
	statusBar:SetMinMaxValues(0, 100)
	statusBar:SetPoint("TOPLEFT", 4, -4)
	statusBar:SetPoint("BOTTOMRIGHT", -4, 4)
	statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
	statusBar:SetStatusBarColor(0.71, 0.71, 0.89, 0.9)
	statusBar:SetFrameLevel(level+3)
	frame.majorStatusBar = statusBar
	
	local textFrame = CreateFrame("Frame", nil, frame)
	textFrame:SetFrameLevel(level+4)
	textFrame:SetAllPoints(frame)
	-- Text for the StatusBar
	local tFile, tSize = GameFontNormal:GetFont()
	local text = textFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetFont(tFile, tSize, "OUTLINE")
	text:SetPoint("CENTER")
	frame.text = text
	
	GUIUtil:AddHorizontalBar(frame, -25, parent)
	
	return frame
end

function private:CreateStartScanContent(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetAllPoints(parent)
	frame:Hide()

	local function UpdateGetAllButton()
		if TSM.Scan:IsScanning() then
			frame:Disable()
		elseif not select(2, CanSendAuctionQuery()) then
			local previous = TSM.db.profile.lastGetAll or time()
			if previous > (time() - 15*60) then
				local diff = previous + 15*60 - time()
				local diffMin = math.floor(diff/60)
				local diffSec = diff - diffMin*60
				frame.getAllStatusText:SetText("|cffff0000"..format(L["Ready in %s min and %s sec"], diffMin, diffSec))
			else
				frame.getAllStatusText:SetText("|cffff0000"..L["Not Ready"])
			end
			frame:Enable()
			frame.startGetAllButton:Disable()
		else
			frame:Enable()
			frame.getAllStatusText:SetText("|cff00ff00"..L["Ready"])
			frame.startGetAllButton:Enable()
		end
	end
	
	frame:SetScript("OnShow", function(self)
			TSMAPI:CreateTimeDelay("auctionDBGetAllStatus", 0, UpdateGetAllButton, 0.2)
		end)
	
	frame:SetScript("OnHide", function(self)
			TSMAPI:CancelFrame("auctionDBGetAllStatus")
		end)
		
	frame.Enable = function(self)
		self.startGetAllButton:Enable()
		self.startFullScanButton:Enable()
		self.startProfessionScanButton:Enable()
	end

	frame.Disable = function(self)
		self.startGetAllButton:Disable()
		self.startFullScanButton:Disable()
		self.startProfessionScanButton:Disable()
	end

	local bar = GUIUtil:AddVerticalBar(frame, 0)
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", 415, -31)
	bar:SetHeight(200)
	bar:SetWidth(6)
	
	
	-- first row (getall scan)
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", 10, -45)
	text:SetHeight(40)
	text:SetWidth(400)
	text:SetFont(GameFontHighlight:GetFont(), 12)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	text:SetText(L["A GetAll scan is the fastest in-game method for scanning every item on the auction house. However, it may disconnect you from the game and has a 15 minute cooldown."])
	
	local btn = GUIUtil:CreateButton(frame, nil, "action2", 1, "CENTER")
	btn:SetPoint("TOPLEFT", 425, -45)
	btn:SetHeight(22)
	btn:SetWidth(205)
	btn:SetScript("OnClick", TSM.Scan.StartGetAllScan)
	btn:SetText(L["Run GetAll Scan"])
	frame.startGetAllButton = btn
	
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", 425, -70)
	text:SetHeight(16)
	text:SetWidth(205)
	text:SetFontObject(GameFontNormal)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	text:SetText(" ")
	frame.getAllStatusText = text
	
	GUIUtil:AddHorizontalBar(frame, -95)
	
	
	-- second row (full scan)
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", 10, -110)
	text:SetHeight(40)
	text:SetWidth(400)
	text:SetFont(GameFontHighlight:GetFont(), 12)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	text:SetText(L["A full auction house scan will scan every item on the auction house but is far slower than a GetAll scan. Expect this scan to take several minutes or longer."])
	
	local btn = GUIUtil:CreateButton(frame, nil, "action2", 1, "CENTER")
	btn:SetPoint("TOPLEFT", 425, -120)
	btn:SetHeight(22)
	btn:SetWidth(205)
	btn:SetScript("OnClick", TSM.Scan.StartFullScan)
	btn:SetText(L["Run Full Scan"])
	frame.startFullScanButton = btn
	
	GUIUtil:AddHorizontalBar(frame, -160)
	
	
	-- third row (profession scan)
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", 10, -175)
	text:SetHeight(40)
	text:SetWidth(170)
	text:SetFont(GameFontHighlight:GetFont(), 12)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	text:SetText(L["A profession scan will scan items required/made by a certain profession."])
	
	local bar = GUIUtil:AddVerticalBar(frame, 0)
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", 185, -167)
	bar:SetHeight(61)
	bar:SetWidth(6)

	local dd = GUIUtil:CreateDropdown(frame, L["Professions:"], 200, professions, {"TOPLEFT", 200, -172}, L["Select professions to include in the profession scan."])	dd:SetMultiselect(true)
	for key in pairs(professions) do
		dd:SetItemValue(key, TSM.db.profile.scanSelections[key])
	end
	dd:SetCallback("OnValueChanged", function(_,_,key,value) TSM.db.profile.scanSelections[key] = value end)
	
	local btn = GUIUtil:CreateButton(frame, nil, "action2", 1, "CENTER")
	btn:SetPoint("TOPLEFT", 425, -185)
	btn:SetHeight(22)
	btn:SetWidth(205)
	btn:SetScript("OnClick", TSM.Scan.StartProfessionScan)
	btn:SetText(L["Run Profession Scan"])
	frame.startProfessionScanButton = btn
	
	GUIUtil:AddHorizontalBar(frame, -225)
	
	-- 4th row (auto updater)
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", 10, -235)
	text:SetPoint("TOPRIGHT", -10, -235)
	text:SetHeight(60)
	text:SetFont(GameFontHighlight:GetFont(), 12)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	text:SetText(format("|cff99ffff"..L["Never scan the auction house again!"].."|r "..L["The author of TradeSkillMaster has created an application which uses blizzard's online auction house APIs to update your AuctionDB data automatically. Check it out at the link in TSM_AuctionDB's description on curse or at: %s"], "|cff99ffffhttp://bit.ly/uuiiNL|r"))
	return frame
end