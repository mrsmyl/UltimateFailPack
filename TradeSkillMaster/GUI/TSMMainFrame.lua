-- Much of this code is copied from .../AceGUI-3.0/widgets/AceGUIContainer-Frame.lua
-- This Frame container is based on AceGUI's Frame container but modified to fit the TSM theme
local TSM = select(2, ...)
local Type, Version = "TSMMainFrame", 1
local AceGUI = LibStub("AceGUI-3.0")
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame)
	PlaySound("gsTitleOptionExit")
	frame.obj:Hide()
end

local function Frame_OnClose(frame)
	frame.obj:Fire("OnClose")
end

local function Frame_OnMouseDown(frame)
	AceGUI:ClearFocus()
end

local function Title_OnMouseDown(frame)
	frame:GetParent():StartMoving()
	AceGUI:ClearFocus()
end

local function MoverSizer_OnMouseUp(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
end

local function SizerSE_OnMouseDown(frame)
	frame:GetParent():StartSizing("BOTTOMRIGHT")
	AceGUI:ClearFocus()
end

local function SizerS_OnMouseDown(frame)
	frame:GetParent():StartSizing("BOTTOM")
	AceGUI:ClearFocus()
end

local function SizerE_OnMouseDown(frame)
	frame:GetParent():StartSizing("RIGHT")
	AceGUI:ClearFocus()
end

local function StatusBar_OnEnter(frame)
	frame.obj:Fire("OnEnterStatusBar")
end

local function StatusBar_OnLeave(frame)
	frame.obj:Fire("OnLeaveStatusBar")
end

local function ApplyButtonTextures(button)
	local normalTex = button:CreateTexture()
	normalTex:SetTexture("Interface\\Buttons\\UI-AttributeButton-Encourage-Hilight")
	normalTex:SetPoint("TOPRIGHT", button, "TOPRIGHT", -5, -5)
	normalTex:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 5, 5)
	normalTex:SetTexCoord(0.041, 0.975, 0.129, 1.00)
	button:SetNormalTexture(normalTex)
	
	local disabledTex = button:CreateTexture()
	disabledTex:SetTexture("Interface\\Buttons\\UI-AttributeButton-Encourage-Hilight")
	disabledTex:SetPoint("TOPRIGHT", button, "TOPRIGHT", -5, -5)
	disabledTex:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 5, 5)
	disabledTex:SetVertexColor(0.1, 0.1, 0.1, 1)
	disabledTex:SetTexCoord(0.049, 0.931, 0.008, 0.121)
	button:SetDisabledTexture(disabledTex)
	
	local highlightTex = button:CreateTexture()
	highlightTex:SetTexture("Interface\\Buttons\\UI-AttributeButton-Encourage-Hilight")
	highlightTex:SetPoint("TOPRIGHT", button, "TOPRIGHT", -5, -5)
	highlightTex:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 5, 5)
	highlightTex:SetTexCoord(0, 1, 0, 1)
	highlightTex:SetVertexColor(0.9, 0.9, 0.9, 0.9)
	button:SetHighlightTexture(highlightTex)
	
	local pressedTex = button:CreateTexture()
	pressedTex:SetTexture("Interface\\Buttons\\UI-AttributeButton-Encourage-Hilight")
	pressedTex:SetPoint("TOPRIGHT", button, "TOPRIGHT", -5, -5)
	pressedTex:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 5, 5)
	pressedTex:SetVertexColor(1, 1, 1, 0.5)
	pressedTex:SetTexCoord(0.035, 0.981, 0.014, 0.670)
	button:SetPushedTextOffset(0, -1)
	button:SetPushedTexture(pressedTex)
end

local function CreateIconContainer(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 20,
		insets = {left = 4, right = 1, top = 4, bottom = 4},
	})
	frame:SetBackdropColor(TSMAPI:GetBackdropColor())
	frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	frame:EnableMouse(true)
	frame:SetFrameLevel(1)
	return frame
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self.frame:SetParent(UIParent)
		self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
		self:SetTitle()
		self:SetStatusText()
		self:ApplyStatus()
		self:Show()
	end,

	["OnRelease"] = function(self)
		self.status = nil
		wipe(self.localstatus)
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 34
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 57
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["SetTitle"] = function(self, title)
		self.titletext:SetText(title)
		self.title:SetWidth((self.titletext:GetWidth() or 0) + 20)
	end,

	["SetStatusText"] = function(self, text)
		self.statustext:SetText(text)
	end,

	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,

	-- called to set an external table to store status in
	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
		self:ApplyStatus()
	end,

	["ApplyStatus"] = function(self)
		local status = self.status or self.localstatus
		local frame = self.frame
		self:SetWidth(status.width or 700)
		self:SetHeight(status.height or 500)
		frame:ClearAllPoints()
		if status.top and status.left then
			frame:SetPoint("TOP", UIParent, "BOTTOM", 0, status.top)
			frame:SetPoint("LEFT", UIParent, "LEFT", status.left, 0)
		else
			frame:SetPoint("CENTER")
		end
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local frameBackdrop = {
	bgFile = "Interface\\Buttons\\WHITE8X8",
	tile = false,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 24,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local statusBackdrop  = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local titleBackdrop = {
	bgFile = "Interface\\Buttons\\WHITE8X8",
	tile = false,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 24,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local buttonBackdrop = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 12,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local function Constructor()
	local frameName = "TSMMainFrame"..AceGUI:GetNextWidgetNum(Type)

	local frame = CreateFrame("Frame", frameName, UIParent)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetFrameLevel(2)
	frame:SetBackdrop(frameBackdrop)
	frame:SetBackdropColor(TSMAPI:GetBackdropColor())
	frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	frame:SetMinResize(400, 200)
	frame:SetToplevel(true)
	frame:SetScript("OnHide", Frame_OnClose)
	frame:SetScript("OnMouseDown", Frame_OnMouseDown)
	tinsert(UISpecialFrames, frameName)
	
	local closebutton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	closebutton:SetPoint("BOTTOMRIGHT", -25, 8)
	closebutton:SetHeight(33)
	closebutton:SetWidth(100)
	local tFile, tSize = GameFontHighlight:GetFont()
	closebutton:GetFontString():SetFont(tFile, tSize+2, "OUTLINE")
	closebutton:GetFontString():SetTextColor(1, 1, 1, 1)
	closebutton:SetText(CLOSE)
	closebutton:SetBackdrop(buttonBackdrop)
	closebutton:SetScript("OnClick", Button_OnClick)
	ApplyButtonTextures(closebutton)

	local statusbg = CreateFrame("Button", nil, frame)
	statusbg:SetPoint("BOTTOMLEFT", 10, 8)
	statusbg:SetPoint("BOTTOMRIGHT", -128, 8)
	statusbg:SetHeight(34)
	statusbg:SetBackdrop(statusBackdrop)
	statusbg:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	statusbg:SetScript("OnEnter", StatusBar_OnEnter)
	statusbg:SetScript("OnLeave", StatusBar_OnLeave)

	local statustext = statusbg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	statustext:SetPoint("TOPLEFT", 7, -2)
	statustext:SetPoint("BOTTOMRIGHT", -7, 2)
	statustext:SetHeight(30)
	statustext:SetJustifyH("LEFT")
	statustext:SetText("")
	statustext:SetTextColor(1, 1, 1, 1)

	local title = CreateFrame("Frame", nil, frame)
	title:EnableMouse(true)
	title:SetPoint("TOP", 0, 12)
	title:SetWidth(100)
	title:SetHeight(40)
	title:SetScript("OnMouseDown", Title_OnMouseDown)
	title:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
	title:SetBackdrop(titleBackdrop)
	title:SetBackdropColor(TSMAPI:GetBackdropColor())
	title:SetBackdropBorderColor(TSMAPI:GetBorderColor())

	local titletext = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	local tFile, tSize = GameFontNormal:GetFont()
	titletext:SetFont(tFile, tSize+2, "OUTLINE")
	titletext:SetPoint("CENTER")

	local sizer_se = CreateFrame("Frame", nil, frame)
	sizer_se:SetPoint("BOTTOMRIGHT")
	sizer_se:SetWidth(23)
	sizer_se:SetHeight(23)
	sizer_se:EnableMouse()
	sizer_se:SetScript("OnMouseDown",SizerSE_OnMouseDown)
	sizer_se:SetScript("OnMouseUp", MoverSizer_OnMouseUp)

	local line1 = sizer_se:CreateTexture(nil, "BACKGROUND")
	line1:SetWidth(14)
	line1:SetHeight(14)
	line1:SetPoint("BOTTOMRIGHT", -6, 6)
	line1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	local x = 0.1 * 14/17
	line1:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

	local line2 = sizer_se:CreateTexture(nil, "BACKGROUND")
	line2:SetWidth(8)
	line2:SetHeight(8)
	line2:SetPoint("BOTTOMRIGHT", -6, 6)
	line2:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	local x = 0.1 * 8/17
	line2:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

	local sizer_s = CreateFrame("Frame", nil, frame)
	sizer_s:SetPoint("BOTTOMRIGHT", -25, 0)
	sizer_s:SetPoint("BOTTOMLEFT")
	sizer_s:SetHeight(25)
	sizer_s:EnableMouse(true)
	sizer_s:SetScript("OnMouseDown", SizerS_OnMouseDown)
	sizer_s:SetScript("OnMouseUp", MoverSizer_OnMouseUp)

	local sizer_e = CreateFrame("Frame", nil, frame)
	sizer_e:SetPoint("BOTTOMRIGHT", 0, 25)
	sizer_e:SetPoint("TOPRIGHT")
	sizer_e:SetWidth(25)
	sizer_e:EnableMouse(true)
	sizer_e:SetScript("OnMouseDown", SizerE_OnMouseDown)
	sizer_e:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
	
	-- frame to contain the icons on the right
	local optionsIconContainer = CreateIconContainer(frame)
	optionsIconContainer:SetWidth(60)
	optionsIconContainer:SetPoint("TOPLEFT", frame, "TOPRIGHT", -8, -10)
	optionsIconContainer:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -8, 10)
	
	-- frame to contain the icons on the left
	local craftingIconContainer = CreateIconContainer(frame)
	craftingIconContainer:SetWidth(60)
	craftingIconContainer:SetPoint("TOPRIGHT", frame, "TOPLEFT", 8, -10)
	craftingIconContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 8, 10)
	
	-- frame to contain the icons on the bottom
	local moduleIconContainer = CreateIconContainer(frame)
	moduleIconContainer:SetHeight(60)
	moduleIconContainer:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 10, 8)
	moduleIconContainer:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -10, 8)
	
	--Container Support
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", 10, -27)
	content:SetPoint("BOTTOMRIGHT", -10, 43)

	local widget = {
		localstatus = {},
		titletext = titletext,
		title = title,
		statustext = statustext,
		content = content,
		frame = frame,
		optionsIconContainer = optionsIconContainer,
		craftingIconContainer = craftingIconContainer,
		moduleIconContainer = moduleIconContainer,
		statusbg = statusbg,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	closebutton.obj, statusbg.obj = widget, widget

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)