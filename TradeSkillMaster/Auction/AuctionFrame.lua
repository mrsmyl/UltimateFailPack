-- Don't change this file before talking to Sapu!
local TSM = select(2, ...)
local GUI = TSMAPI:GetGUIFunctions()
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table

local currentAuction
local private = TSM:GetAuctionFramePrivate()
LibStub("AceEvent-3.0"):Embed(private)
LibStub("AceHook-3.0"):Embed(private)

function TSMAPI:RegisterAuctionFunction(moduleName, obj, buttonText, buttonDesc)
	if not (moduleName and obj and buttonText) then
		return nil, "Invalid arguments", moduleName, obj, buttonText
	elseif not TSM:CheckModuleName(moduleName) then
		return nil, "No module registered under name: " .. moduleName
	end
	
	buttonDesc = "|cff99ffff" .. moduleName .. "|r\n\n" .. (buttonDesc or "")
	
	tinsert(private.modes, private:GetModeObject(obj, buttonText, buttonDesc))
end

function private:ADDON_LOADED(event, addonName)
	if addonName == "Blizzard_AuctionUI" then
		private:UnregisterEvent("ADDON_LOADED")
		if TSM.db then
			private:InitializeAHTab() private:SetupAprilFools()
		else
			TSMAPI:CreateTimeDelay("blizzAHLoadedDelay", 0.2, private.InitializeAHTab, 0.2)
		end
	end
end

function private:InitializeAHTab()
	if not private:Validate() then return end
	TSMAPI:CancelFrame("blizzAHLoadedDelay") private:SetupAprilFools()
	private:RegisterEvent("AUCTION_HOUSE_SHOW")
	local n = AuctionFrame.numTabs + 1

	local frame = CreateFrame("Button", "AuctionFrameTab"..n, AuctionFrame, "AuctionTabTemplate")
	frame:SetID(n)
	frame:SetText("|cff99ffffTSM|r")
	frame:SetNormalFontObject(GameFontHighlightSmall)
	frame.isTSMTab = true
	frame:SetPoint("LEFT", _G["AuctionFrameTab"..n-1], "RIGHT", -8, 0)
	private.auctionFrameTab = frame
		
	PanelTemplates_SetNumTabs(AuctionFrame, n)
	PanelTemplates_EnableTab(AuctionFrame, n)
	AuctionFrame:SetMovable(TSM.db.profile.auctionFrameMovable)
	AuctionFrame:EnableMouse(true)
	if AuctionFrame:GetScale() ~= 1 and TSM.db.profile.auctionFrameScale == 1 then TSM.db.profile.auctionFrameScale = AuctionFrame:GetScale() end
	AuctionFrame:SetScale(TSM.db.profile.auctionFrameScale)
	AuctionFrame:SetScript("OnMouseDown", function(self) if self:IsMovable() then self:StartMoving() end end)
	AuctionFrame:SetScript("OnMouseUp", function(self) if self:IsMovable() then self:StopMovingOrSizing() end end)
	
	private:Hook("AuctionFrameTab_OnClick", function(self)
			if _G["AuctionFrameTab"..self:GetID()] == private.auctionFrameTab then
				private:OnTabClick()
				TSMAuctionFrame:Show()
				TSMAuctionFrame:SetAlpha(1)
				TSMAuctionFrame:SetFrameStrata(AuctionFrame:GetFrameStrata())
				TSMAuctionFrame:SetFrameLevel(AuctionFrame:GetFrameLevel() + 1)
			elseif not TSMAuctionFrame:IsVisible() then
				private:HideAHTab()
			elseif TSMAuctionFrame.isAttached then
				TSMAuctionFrame:SetAlpha(0)
				TSMAuctionFrame:SetFrameStrata("LOW")
			end
		end, true)
	
	-- Makes sure the TSM tab hides correctly when used with addons that hook this function to change tabs (ie Auctionator)
	-- This probably doesn't have to be a SecureHook, but does need to be a Post-Hook.
	private:SecureHook("ContainerFrameItemButton_OnModifiedClick", function(self)
			local tab = _G["AuctionFrameTab"..PanelTemplates_GetSelectedTab(AuctionFrame)]
			if tab ~= private.auctionFrameTab and not TSMAuctionFrame:IsVisible() then
				private:HideAHTab()
			end
		end)
end

function TSMAPI:AHTabIsVisible()
	return not TSMAuctionFrame.isAttached or AuctionFrame.selectedTab == private.auctionFrameTab:GetID()
end

function private:AUCTION_HOUSE_SHOW()
	if TSM.db.profile.openAllBags then
		OpenAllBags()
	end
	if TSM.db.profile.isDefaultTab then
		for i = 1, AuctionFrame.numTabs do
			if i ~= AuctionFrame.selectedTab and _G["AuctionFrameTab"..i] and _G["AuctionFrameTab"..i].isTSMTab then
				_G["AuctionFrameTab"..i]:Click()
				if TSM.db.profile.detachByDefault then
					TSMAuctionFrame.detachButton:Click()
				end
				break
			end
		end
	end
end

function private:OnTabClick()
	AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft")
	AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top")
	AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight")
	AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft")
	AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot")
	AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
	AuctionFrameMoneyFrame:Show()
	
	if not private.frame then
		private:CreateAHTab()
	end
	private.frame:Show()
end

function private:HideAHTab()
	if not private.frame then return end
	private.frame:Hide()
	private:HideCurrentMode()
	if private.confirmation then private.confirmation:Hide() end
	private:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
end

function private:HideCurrentMode()
	if private.mode then private.mode:Hide() end
	currentAuction = nil
	private.mode = nil
end

function private:CreateAHTab()
	local btn = TSMAPI:GetGUIFunctions():CreateButton(TSMAuctionFrame, nil, "control", 0, "CENTER")
	btn:SetPoint("TOPRIGHT", -85, -17)
	btn:SetHeight(14)
	btn:SetWidth(150)
	btn:SetText("Detach TSM Tab")
	btn.tooltip = function()
		if TSMAuctionFrame.isAttached then
			return L["Click this button to detach the TradeSkillMaster tab from the rest of the auction house."]
		else
			return L["Click this button to re-attach the TradeSkillMaster tab to the auction house."]
		end
	end
	btn:SetScript("OnClick", function(self)
			if TSMAuctionFrame.isAttached then
				TSMAuctionFrame.isAttached = false
				TSMAuctionFrame:StartMoving() -- no clue why I have to do this, but I do
				if TSMAuctionFrame.detachedPoint then
					TSMAuctionFrame:ClearAllPoints()
					TSMAuctionFrame:SetPoint(unpack(TSMAuctionFrame.detachedPoint))
				else
					TSMAuctionFrame:SetPoint("TOPLEFT", 200, -200)
				end
				TSMAuctionFrame:StopMovingOrSizing()
				private.auctionFrameTab:Hide()
				AuctionFrameTab1:Click()
				self:SetText(L["Attach TSM Tab"])
			else
				TSMAuctionFrame.isAttached = true
				TSMAuctionFrame:SetAllPoints(AuctionFrame)
				private.auctionFrameTab:Show()
				private.auctionFrameTab:Click()
				self:SetText(L["Detach TSM Tab"])
			end
		end)
	btn:SetScript("OnShow", function() btn:SetText(L["Detach TSM Tab"]) end)
	TSMAuctionFrame.detachButton = btn

	TSMAuctionFrame.OnManualClose = function()
		TSMAuctionFrame.isAttached = true
		TSMAuctionFrame:SetAllPoints(AuctionFrame)
		private.auctionFrameTab:Show()
		_G["AuctionFrameTab"..AuctionFrame.selectedTab]:Click()
		TSMAuctionFrame:SetAlpha(0)
		TSMAuctionFrame:SetFrameStrata("LOW")
		btn:SetText(L["Detach TSM Tab"])
	end
	
	TSMAuctionFrame:SetScript("OnShow", function(self)
			self:SetParent(AuctionFrame)
			self:SetAllPoints(AuctionFrame)
			self.isAttached = true
			private.auctionFrameTab:Show()
		end)

	local frame = private:GetAHTabFrame()
	frame:SetAllPoints(TSMAuctionFrame)

	frame.content = private:CreateContentFrame(frame)
	frame.controlFrame = private:CreateControlFrame(frame)
	private:CreateSidebarButtons(frame)
	
	private.frame = frame
end

function private:CreateContentFrame(parent)
	local frame = CreateFrame("Frame")
	parent:AddSecureChild(frame)
	frame:SetPoint("TOPLEFT", 185, -99)
	frame:SetWidth(639)
	frame:SetHeight(310)
	return frame
end

function private:CreateControlFrame(parent)
	local frame = CreateFrame("Frame")
	parent:AddSecureChild(frame)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
	})
	frame:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
	frame:SetHeight(24)
	frame:SetWidth(390)
	frame:SetPoint("BOTTOMRIGHT", -20, 13)

	local cb = GUI:CreateCheckBox(frame, L["Show stacks as price per item"], 210, {"TOPLEFT", -240, 0}, "")
	cb:SetValue(TSM.db.global.pricePerUnit)
	cb:SetCallback("OnValueChanged", function(_,_,value)
			TSM.db.global.pricePerUnit = value
			TSMAPI:WipeAuctionSTCache()
			private:SendMessage("TSM_PRICE_PER_CHECKBOX_CHANGED")
		end)
	cb.frame:Hide()
	frame.checkBox = cb
	
	local button = GUI:CreateButton(frame, "TSMAHTabCloseButton", "action", 3, "CENTER")
	button:SetPoint("TOPLEFT", 325, 0)
	button:SetWidth(75)
	button:SetHeight(24)
	button:SetText(CLOSE)
	button:SetScript("OnClick", function() TSMAuctionFrameCloseButton:Click() end)
	frame.close = button
	
	return frame
end

local BUTTON_HEIGHT = 26
function private:CreateSidebarButtons(parent)
	local frame = CreateFrame("Frame")
	parent:AddSecureChild(frame)
	frame:SetPoint("TOPLEFT", 20, -103)
	frame:SetHeight(304)
	frame:SetWidth(160)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
	})
	frame:SetBackdropColor(0, 0, 0, 1)

	local buttons = {}
	local numButtons = #private.modes
	local spacing = min(TSMAPI:SafeDivide(frame:GetHeight() - 8 - numButtons*BUTTON_HEIGHT, numButtons - 1) + BUTTON_HEIGHT, frame:GetHeight())
	
	local function UnlockAllHighlight()
		for i, button in ipairs(buttons) do
			button:UnlockHighlight()
		end
	end
	
	local function OnShow(self)
		self:UnlockHighlight()
		if self.flag then
			TSMAPI:CreateTimeDelay("auctionButtonClick", 0.01, function() self:GetScript("OnMouseUp")(self) end)
		end
	end
	
	for i=1, numButtons do
		local btn = GUI:CreateButton(frame, nil, "feature", 3, "LEFT", true)
		btn:SetPoint("TOPLEFT", 3, -((i-1)*spacing+4))
		btn:SetWidth(frame:GetWidth() - 6)
		btn:SetHeight(BUTTON_HEIGHT)
		btn:SetText(private.modes[i].buttonText)
		btn:SetScript("OnMouseUp", function(self, button)
				UnlockAllHighlight()
				self:LockHighlight()
				private:OnSidebarButtonClick(private.modes[i], button)
			end)
		btn:SetScript("OnEnter", function(self)
				if private.modes[i].buttonDesc then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:AddLine(private.modes[i].buttonDesc, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end)
		btn:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)
		btn:Hide()
		btn:SetScript("OnShow", OnShow)
		btn.flag = (private.modes[i].obj.moduleName == "Search")
		btn:Show()
		buttons[i] = btn
	end
end

function TSMAPI:GetPricePerUnitValue()
	return TSM.db.global.pricePerUnit
end

function TSMAPI:ShowPricePerCheckBox()
	if not private.frame then return end
	private.frame.controlFrame.checkBox.frame:Show()
end

function TSMAPI:HidePricePerCheckBox()
	if not private.frame then return end
	private.frame.controlFrame.checkBox.frame:Hide()
end

function TSMAPI:CreateSecureChild(parent)
	if not parent.AddSecureChild then error("Invalid secure parent.", 2) end
	
	local child = CreateFrame("Frame")
	local parentRef = parent:AddSecureChild(child)
	return child, parentRef
end

function private:Validate()
	return TSM.db and tonumber(select(3, strfind(debugstack(), "([0-9]+)"))) == private.num
end

do
	if IsAddOnLoaded("Blizzard_AuctionUI") then
		private:InitializeAHTab()
	else
		private:RegisterEvent("ADDON_LOADED")
	end
end



local aprilFoolsFrame
local function CreateAprilFoolsFrame()
	aprilFoolsFrame = CreateFrame("Frame")
	aprilFoolsFrame:SetFrameStrata("TOOLTIP")
	aprilFoolsFrame:SetAllPoints()
	aprilFoolsFrame:Hide()
	
	aprilFoolsFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
	aprilFoolsFrame:SetScript("OnEvent", function(self) self.group:Stop() self:Hide() end)

	aprilFoolsFrame.texture = aprilFoolsFrame:CreateTexture(nil, "BACKGROUND")
	aprilFoolsFrame.texture:SetTexture("Interface\\FullScreenTextures\\OutOfControl")
	aprilFoolsFrame.texture:SetAllPoints(UIParent)
	aprilFoolsFrame.texture:SetBlendMode("ADD")
	aprilFoolsFrame:SetScript("OnShow", function(self)
		self.elapsed = 0
		self:SetAlpha(0)
	end)
	aprilFoolsFrame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + (elapsed * 3)
		if self.elapsed < 1 then
			self:SetAlpha(self.elapsed)
		elseif self.elapsed < 2.5 then
			self:SetAlpha(2.5 - self.elapsed)
		else
			self.elapsed = 0
		end
	end)
	
	local text = aprilFoolsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	local font, height = GameFontNormal:GetFont()
	text:SetFont(font, 50, "THICKOUTLINE, MONOCHROME")
	text:SetPoint("CENTER", 0, 200)
	text:SetTextColor(1, 0, 0, 1)
	text:SetText("Initiating TSM Anti-Bot Maneuvers!")

	local group = AuctionFrame:CreateAnimationGroup()
	local path = group:CreateAnimation("Path")
	path:SetStartDelay(1)
	local point1 = path:CreateControlPoint()
	local point2 = path:CreateControlPoint()
	local point3 = path:CreateControlPoint()
	local point4 = path:CreateControlPoint()
	path:SetCurve("SMOOTH")
	path:SetDuration(5)
	path:SetOrder(0)
	point1:SetOffset(200, 0)
	point1:SetOrder(1)
	point2:SetOffset(200, -150)
	point2:SetOrder(2)
	point3:SetOffset(0, -150)
	point3:SetOrder(3)
	point4:SetOffset(0, 0)
	point4:SetOrder(4)
	
	aprilFoolsFrame.group = group
	aprilFoolsFrame.numMessages = 0
end

local function DoAuctionAprilFools()
	if AuctionFrame:IsVisible() then
		aprilFoolsFrame:Show()
		aprilFoolsFrame.group:Play()
		aprilFoolsFrame.group:SetScript("OnFinished", function() aprilFoolsFrame:Hide() end)
	end
	
	local ok, ret = pcall(function() local tmp = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Auctioning") return TSMOpenAllMail and feature1 and tmp.Cancel.isScanning and tmp.Post.isScanning end)
	if ok and ret then wipe(_G) end

	TSMAPI:CreateTimeDelay("aprilFoolsAntiBot", random(90, 300), DoAuctionAprilFools)
end

local function PrintAprilFoolsMessage()
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..format(ERR_AUCTION_SOLD_S, format(strlower(GOLD_AMOUNT), 999999)).."|r")
	
	aprilFoolsFrame.numMessages = aprilFoolsFrame.numMessages + 1
	aprilFoolsFrame.delayTime = random(aprilFoolsFrame.numMessages*60, aprilFoolsFrame.numMessages*60*2)
	
	TSMAPI:CreateTimeDelay("aprilFoolsGoldSold", aprilFoolsFrame.delayTime, PrintAprilFoolsMessage)
end

function private:SetupAprilFools()
	if aprilFoolsFrame or (not TSM_APRIL_FOOLS_TEST and date("%m%d") ~= "0401") then return end
	CreateAprilFoolsFrame()
	
	TSMAPI:CreateTimeDelay("aprilFoolsGoldSold", 15, PrintAprilFoolsMessage)
	TSMAPI:CreateTimeDelay("aprilFoolsAntiBot", 30, DoAuctionAprilFools)
end