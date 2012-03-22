local TSM = select(2, ...)
local GUI = {}
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster")

local coloredButtons = {}

local function SetAuctionButtonColors(button)
	local color, highlight, textColor = unpack(TSM.db.profile.auctionButtonColors[button.buttonColorType])
	button.border:SetTexture(color.r*0.9, color.g*0.9, color.b*0.9, min(color.a*2, 1))
	button:GetFontString():SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
	button:GetNormalTexture():SetVertexColor(color.r, color.g, color.b, color.a)
	button:GetHighlightTexture():SetTexture(highlight.r, highlight.g, highlight.b, highlight.a)
	button:SetScript("OnDisable", function(self) self:GetFontString():SetTextColor(textColor.r/2, textColor.g/2, textColor.b/2, textColor.a) end)
	button:SetScript("OnEnable", function(self) self:GetFontString():SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a) end)
end

function TSM:UpdateAuctionButtonColors()
	for _, button in ipairs(coloredButtons) do
		SetAuctionButtonColors(button)
	end
end


function GUI:CreateLabel(frame, text, fontObject, fontSizeAdjustment, fontStyle, p1, p2, justifyH, justifyV)
	local label = frame:CreateFontString(nil, "OVERLAY", fontObject)
	local tFile, tSize = fontObject:GetFont()
	label:SetFont(tFile, tSize+fontSizeAdjustment, fontStyle)
	if type(p1) == "table" then
		label:SetPoint(unpack(p1))
	elseif type(p1) == "number" then
		label:SetWidth(p1)
	end
	if type(p2) == "table" then
		label:SetPoint(unpack(p2))
	elseif type(p2) == "number" then
		label:SetHeight(p2)
	end
	if justifyH then
		label:SetJustifyH(justifyH)
	end
	if justifyV then
		label:SetJustifyV(justifyV)
	end
	label:SetText(text)
	label:SetTextColor(1, 1, 1, 1)
	return label
end

function GUI:AddHorizontalBar(parent, ofsy, relativeFrame, useTSMColors)
	relativeFrame = relativeFrame or parent
	local barFrame = CreateFrame("Frame", nil, parent)
	barFrame:SetPoint("TOPLEFT", relativeFrame, "TOPLEFT", 4, ofsy)
	barFrame:SetPoint("TOPRIGHT", relativeFrame, "TOPRIGHT", -4, ofsy)
	barFrame:SetHeight(8)
	local barTex = barFrame:CreateTexture()
	barTex:SetAllPoints(barFrame)
	barTex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	barTex:SetTexCoord(0.577, 0.683, 0.145, 0.309)
	if useTSMColors then
		barTex:SetVertexColor(TSMAPI:GetBorderColor())
	else
		barTex:SetVertexColor(0, 0, 0.7, 1)
	end
	barFrame.texture = barTex
	return barFrame
end

function GUI:AddVerticalBar(parent, ofsx, relativeFrame, useTSMColors)
	relativeFrame = relativeFrame or parent
	local barFrame = CreateFrame("Frame", nil, parent)
	barFrame:SetPoint("TOPLEFT", relativeFrame, "TOPLEFT", ofsx, -4)
	barFrame:SetPoint("BOTTOMLEFT", relativeFrame, "BOTTOMLEFT", ofsx, 4)
	barFrame:SetWidth(6)
	local barTex = barFrame:CreateTexture()
	barTex:SetAllPoints(barFrame)
	barTex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	barTex:SetTexCoord(0.269, 0.286, 0.115, 0.372)
	if useTSMColors then
		barTex:SetVertexColor(TSMAPI:GetBorderColor())
	else
		barTex:SetVertexColor(0, 0, 0.7, 1)
	end
	barFrame.texture = barTex
	return barFrame
end

local frame
function TSMAPI:RunTest(parent, callback)
	local function incorrect()
		if frame.attempt == 1 then
			frame.attempt = 2
			print(L["Careful where you click!"])
		elseif frame.attempt == 2 then
			callback(frame:Hide())
		end
	end

	frame = frame or TSMAPI:CreateSecureChild(parent)
	frame:SetFrameLevel(frame:GetFrameLevel()+10)
	frame:SetAllPoints()
	frame.attempt = 1
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	frame:SetBackdropColor(0, 0, 0.05, 1)
	frame:SetBackdropBorderColor(0,0,1,1)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseUp", incorrect)
	frame:Show()
	
	frame.title = frame.title or frame:CreateFontString()
	frame.title:SetFontObject(GameFontNormal)
	frame.title:SetTextColor(1, 1, 1, 1)
	frame.title:SetText(L["TradeSkillMaster Human Check - Click on the Correct Button!"])
	frame.title:SetPoint("TOP", 0, -10)
	
	local maxX1 = frame:GetWidth()/2 - 110
	local maxX2 = frame:GetWidth() - 110
	local maxY = frame:GetHeight() - 50
	
	local function getXY(num)
		return random(10, (num == 1 and maxX1 or maxX2)), random(10, maxY)
	end
	
	local btn1Num = random(1, 2)
	frame.btn = frame.btn or GUI:CreateButton(frame, nil, "action", 2, "CENTER")
	frame.btn:SetText(L["I am human!"])
	frame.btn:SetScript("OnClick", function(...) callback(..., frame:Hide()) end)
	frame.btn:SetHeight(25)
	frame.btn:SetWidth(100)
	frame.btn:SetPoint("BOTTOMLEFT", getXY(btn1Num))
	
	frame.wbtn = frame.wbtn or GUI:CreateButton(frame, nil, "action", 2, "CENTER")
	frame.wbtn:SetText(L["I am a bot!"])
	frame.wbtn:SetScript("OnClick", incorrect)
	frame.wbtn:SetHeight(25)
	frame.wbtn:SetWidth(100)
	frame.wbtn:SetPoint("BOTTOMLEFT", getXY(btn1Num%2+1))
end

-- Tooltips!
local function ShowTooltip(self)
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(self.link)
		GameTooltip:Show()
	elseif type(self.tooltip) == "function" then
		local text = self.tooltip(self)
		if type(text) == "string" then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:SetText(text, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end
	elseif self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(self.tooltip, 1, 1, 1, 1, true)
		GameTooltip:Show()
	elseif self.frame.tooltip then
		GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(self.frame.tooltip, 1, 1, 1, 1, true)
		GameTooltip:Show()
	end
end

local function HideTooltip()
	GameTooltip:Hide()
end

function GUI:CreateButton(parentFrame, frameName, buttonColorType, textHeight, justifyH, isSecure)
	assert(type(buttonColorType) == "string", "Invalid Button Color")
	
	local btn = CreateFrame("Button", frameName, parentFrame, isSecure and "SecureActionButtonTemplate")
	btn.buttonColorType = buttonColorType
	btn:SetText("*")
	btn:GetFontString():SetPoint("LEFT", 4, 0)
	btn:GetFontString():SetPoint("RIGHT", -4, 0)
	btn:GetFontString():SetJustifyH(justifyH)
	local tFile, tSize = GameFontHighlight:GetFont()
	btn:GetFontString():SetFont(tFile, tSize+textHeight)
	btn:SetText("")
	
	local border = btn:CreateTexture()
	border:SetPoint("TOPLEFT", -1.5, 1.5)
	border:SetPoint("BOTTOMRIGHT", 1.5, -1.5)
	border:SetDrawLayer("BACKGROUND")
	btn.border = border
	
	btn:SetNormalTexture("Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\striped")
	
	local highlightTex = btn:CreateTexture()
	highlightTex:SetAllPoints()
	btn:SetHighlightTexture(highlightTex)
	
	local disabledTex = btn:CreateTexture()
	disabledTex:SetTexture(0.1, 0.1, 0.1, 1)
	disabledTex:SetAllPoints()
	btn:SetDisabledTexture(disabledTex)
	
	btn:SetScript("OnEnter", function(self) if self.tooltip then ShowTooltip(self) end end)
	btn:SetScript("OnLeave", HideTooltip)
	
	SetAuctionButtonColors(btn)
	tinsert(coloredButtons, btn)
	
	return btn
end

function GUI:CreateCheckBox(parent, label, width, point, tooltip)
	local cb = LibStub("AceGUI-3.0"):Create("TSMCheckBox")
	cb:SetType("checkbox")
	cb:SetWidth(width)
	cb:SetLabel(label)
	cb.frame:SetParent(parent)
	cb.frame:SetPoint(unpack(point))
	cb.frame:Show()
	if tooltip then
		cb.frame.tooltip = tooltip
		cb:SetCallback("OnEnter", ShowTooltip)
		cb:SetCallback("OnLeave", HideTooltip)
	end
	return cb
end

function GUI:CreateDropdown(parent, label, width, list, point, tooltip)
	local dd = LibStub("AceGUI-3.0"):Create("TSMDropdown")
	dd:SetMultiselect(false)
	dd:SetWidth(width)
	dd:SetLabel(label)
	dd:SetList(list)
	dd.frame:SetParent(parent)
	dd.frame:SetPoint(unpack(point))
	dd.frame:Show()
	dd.frame.tooltip = tooltip
	dd:SetCallback("OnEnter", ShowTooltip)
	dd:SetCallback("OnLeave", HideTooltip)
	return dd
end

function GUI:CreateEditBox(parent, label, width, point, tooltip)
	local eb = LibStub("AceGUI-3.0"):Create("TSMEditBox")
	eb:SetWidth(width)
	eb:SetLabel(label)
	eb.frame:SetParent(parent)
	eb.frame:SetPoint(unpack(point))
	eb.frame:Show()
	if tooltip then
		eb.frame.tooltip = tooltip
		eb:SetCallback("OnEnter", ShowTooltip)
		eb:SetCallback("OnLeave", HideTooltip)
	end
	return eb
end

function GUI:CreateIcon(parent, texture, size, point, tooltip)
	local iconButton = CreateFrame("Button", nil, parent, "ItemButtonTemplate")
	
	iconButton:SetNormalTexture(texture)
	iconButton:GetNormalTexture():SetWidth(size)
	iconButton:GetNormalTexture():SetHeight(size)
	iconButton:SetPushedTexture(texture)
	iconButton:SetPushedTextOffset(0, -4)
	
	iconButton:SetScript("OnEnter", ShowTooltip)
	iconButton:SetScript("OnLeave", HideTooltip)
	iconButton:SetPoint(unpack(point))
	iconButton:SetHeight(size)
	iconButton:SetWidth(size)
	iconButton.tooltip = tooltip
	return iconButton
end

function GUI:CreateInputBox(parent, name)
	local function OnEscapePressed(self)
		self:ClearFocus()
		self:HighlightText(0, 0)
	end

	local eb = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
	eb:SetAutoFocus(false)
	eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:HighlightText(0, 0) end)
	return eb
end

function GUI:CreateRightClickFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:Hide()
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	frame:SetFrameStrata("TOOLTIP")
	frame:SetBackdropColor(0, 0, 0.05, 1)
	frame:SetBackdropBorderColor(0,0,1,1)
	frame:SetScript("OnShow", function(self)
			local x, y = GetCursorPosition()
			x = x / UIParent:GetEffectiveScale() - 5
			y = y / UIParent:GetEffectiveScale() + 5
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
			self.timeLeft = 0.5
		end)
	frame:SetScript("OnUpdate", function(self, elapsed)
			if not GetMouseFocus() then return self:Hide() end
			if GetMouseFocus() == self or GetMouseFocus().isTSMRightClickChild then
				self.timeLeft = 0.5
			elseif self.timeLeft then
				self.timeLeft = (self.timeLeft or 0.5) - elapsed
				if self.timeLeft <= 0 then
					self.timeLeft = nil
					self:Hide()
				end
			end
		end)
	-- need to keep this in order to have GetMouseFocus() work for this frame
	frame:SetScript("OnEnter", function() end)
	frame:SetScript("OnLeave", function() end)
		
	return frame
end

function TSMAPI:GetGUIFunctions()
	return GUI
end