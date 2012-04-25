--[[-----------------------------------------------------------------------------
Selection List Widget
Provides two scroll lists with buttons to move selected items from one list to the other.
-------------------------------------------------------------------------------]]
local TSM = select(2, ...)
local Type, Version = "TSMSelectionList", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local ROW_HEIGHT = 16


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function ShowIcon(row)
	row.iconFrame:Show()
	row.label:SetPoint("TOPLEFT", 20, 0)
	row.label:SetPoint("BOTTOMRIGHT")
end

local function HideIcon(row)
	row.iconFrame:Hide()
	row.label:SetPoint("TOPLEFT", 0, 0)
	row.label:SetPoint("BOTTOMRIGHT")
end

local function UpdateScrollFrame(self)
	local rows = self.rows
	-- clear all the rows
	for _, v in pairs(rows) do
		v.value = nil
		v.label:SetText("")
		v.iconFrame.icon:SetTexture("")
		v:Hide()
	end
	
	local rowData = self:GetParent().list
	local maxRows = floor((self.height-5)/(ROW_HEIGHT+2))
	
	FauxScrollFrame_Update(self, #(rowData), maxRows-1, ROW_HEIGHT)
	
	local offset = FauxScrollFrame_GetOffset(self)
	local displayIndex = 0
	
	-- make the rows bigger if the scroller isn't showing
	if self:IsVisible() then
		rows[1]:SetPoint("TOPRIGHT", self:GetParent(), -26, 0)
	else
		rows[1]:SetPoint("TOPRIGHT", self:GetParent(), -10, 0)
	end
	
	for index, data in ipairs(rowData) do
		if index >= offset and displayIndex < maxRows then
			displayIndex = displayIndex + 1
			local row = rows[displayIndex]
			
			row.label:SetText(data.text)
			row.value = data.value
			row.data = data
			
			if data.selected then
				row:LockHighlight()
			else
				row:UnlockHighlight()
			end
			
			if data.icon then
				row.iconFrame.icon:SetTexture(data.icon)
				ShowIcon(row)
			else
				HideIcon(row)
			end
			row:Show()
		end
	end
end

local function UpdateRows(parent)
	local numRows = floor((parent.height-5)/(ROW_HEIGHT+2))
	parent.rows = parent.rows or {}
	for i=1, numRows do
		if not parent.rows[i] then
			local row = CreateFrame("Button", parent:GetName().."Row"..i, parent:GetParent())
			row:SetHeight(ROW_HEIGHT)
			row:SetScript("OnClick", function(self)
				self.data.selected = not self.data.selected
				if self.data.selected then
					self:LockHighlight()
				else
					self:UnlockHighlight()
				end
			end)
			row:SetScript("OnEnter", function(self)
				if not self.data.tooltip then return end
				
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("LEFT", parent:GetParent():GetParent(), "RIGHT")
				
				if type(self.data.tooltip) == "number" then
					GameTooltip:SetHyperlink("item:" .. self.data.tooltip)
				else
					GameTooltip:AddLine(self.data.tooltip, 1, 1, 1, 1)
				end
				GameTooltip:Show()
			end)
			row:SetScript("OnLeave", function() GameTooltip:Hide() end)
			
			if i > 1 then
				row:SetPoint("TOPLEFT", parent.rows[i-1], "BOTTOMLEFT", 0, -2)
				row:SetPoint("TOPRIGHT", parent.rows[i-1], "BOTTOMRIGHT", 0, -2)
			else
				row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
				row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 4, 0)
			end
			
			-- highlight / selection texture for the row
			local highlightTex = row:CreateTexture()
			highlightTex:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight")
			highlightTex:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
			highlightTex:SetPoint("BOTTOMLEFT")
			highlightTex:SetAlpha(0.7)
			row:SetHighlightTexture(highlightTex)
			
			-- icon that goes to the left of the text
			local iconFrame = CreateFrame("Frame", nil, row)
			iconFrame:SetHeight(ROW_HEIGHT-2)
			iconFrame:SetWidth(ROW_HEIGHT-2)
			iconFrame:SetPoint("TOPLEFT")
			row.iconFrame = iconFrame
			
			-- texture that goes inside the iconFrame
			local iconTexture = iconFrame:CreateTexture(nil, "BACKGROUND")
			iconTexture:SetAllPoints(iconFrame)
			iconTexture:SetVertexColor(1, 1, 1)
			iconFrame.icon = iconTexture
			
			local label = row:CreateFontString(nil, "OVERLAY", GameFontHighlight)
			local tFile, tSize = GameFontHighlight:GetFont()
			label:SetFont(tFile, tSize-2)
			label:SetJustifyH("LEFT")
			label:SetJustifyV("CENTER")
			label:SetTextColor(1, 1, 1, 1)
			label:SetPoint("TOPLEFT", 20, 0)
			label:SetPoint("BOTTOMRIGHT", 10, 0)
			row.label = label
			
			parent.rows[i] = row
		end
	end
	UpdateScrollFrame(parent)
end

local function OnButtonClick(self)
	local selected = {}
	local rows, rowData
	
	if self.type == "Add" then
		rows = self:GetParent().obj.leftFrame.scrollFrame.rows
		rowData = self:GetParent().obj.leftFrame.list
	elseif self.type == "Remove" then
		rows = self:GetParent().obj.rightFrame.scrollFrame.rows
		rowData = self:GetParent().obj.rightFrame.list
	end
	if not rows then error("Invalid type") end
	
	local temp = {}
	for _, row in pairs(rows) do
		if row.data and row.data.selected then
			row.data.selected = false
			row:UnlockHighlight()
			temp[row.value] = true
			tinsert(selected, row.value)
		end
	end
	
	for _, data in pairs(rowData) do
		if data.selected and not temp[data.value] then
			data.selected = false
			tinsert(selected, data.value)
		end
	end

	self:GetParent().obj:Fire("On"..self.type.."Clicked", selected)
end

local illegalChars = {"[", "]", "(", ")"}
local function OnFilterSet(self,_,value)
	AceGUI:ClearFocus()
	if value then
		for _, c in ipairs(illegalChars) do
			value = gsub(value, "%"..c, "%%"..c)
		end
	end
	self.obj:Fire("OnFilterEntered", value)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(500)
		self.buttonFrame.filterFrame:Hide()
	end,

	["OnRelease"] = function(self)
		-- clear any points / other values
		self:UnselectAllItems()
		wipe(self.leftFrame.list)
		wipe(self.rightFrame.list)
		self.frame.leftTitle:SetText("")
		self.frame.rightTitle:SetText("")
	end,
	
	["OnHeightSet"] = function(self, height)
		if self.parent then
			TSMAPI:CreateTimeDelay("selectionListHeight", 0.01, function()
					self.leftScrollFrame.height = self.frame:GetHeight() - 20
					self.rightScrollFrame.height = self.frame:GetHeight() - 20
					UpdateRows(self.leftScrollFrame)
					UpdateRows(self.rightScrollFrame)
				end)
		else
			self.leftScrollFrame.height = self.frame:GetHeight() - 20
			self.rightScrollFrame.height = self.frame:GetHeight() - 20
			UpdateRows(self.leftScrollFrame)
			UpdateRows(self.rightScrollFrame)
		end
	end,
	
	["SetList"] = function(self, side, list)
		if type(list) ~= "table" then return end
		if strlower(side) == "left" then
			self.leftFrame.list = list
			UpdateScrollFrame(self.leftScrollFrame)
		elseif strlower(side) == "right" then
			self.rightFrame.list = list
			UpdateScrollFrame(self.rightScrollFrame)
		else
			error("Invalid side passed. Expected 'left' or 'right'")
		end
	end,
	
	["SetTitle"] = function(self, side, title)
		if strlower(side) == "left" then
			self.frame.leftTitle:SetText("|cffffbb00"..title)
		elseif strlower(side) == "right" then
			self.frame.rightTitle:SetText("|cffffbb00"..title)
		elseif strlower(side) == "filter" and title then
			self.buttonFrame.filterFrame:Show()
			self.buttonFrame.filterFrame.filter:SetLabel(title)
		elseif strlower(side) == "filtertooltip" then
			self.buttonFrame.filterFrame.filter.tooltip = title
		elseif title then
			error("Invalid side passed. Expected 'left' or 'right'")
		end
	end,
	
	["UnselectAllItems"] = function(self)
		for _, data in pairs(self.leftFrame.list) do
			data.selected = false
		end
		for _, data in pairs(self.rightFrame.list) do
			data.selected = false
		end
		UpdateScrollFrame(self.leftFrame.scrollFrame)
		UpdateScrollFrame(self.rightFrame.scrollFrame)
	end,
	
	["SelectItems"] = function(self, itemList)
		local check = {}
		for i=1, #itemList do
			check[itemList[i]] = true
		end
	
		for i=1, #self.leftFrame.list do
			if check[self.leftFrame.list[i].value] then
				self.leftFrame.list[i].selected = true
			end
		end
		for i=1, #self.rightFrame.list do
			if check[self.rightFrame.list[i].value] then
				self.rightFrame.list[i].selected = true
			end
		end
		UpdateScrollFrame(self.leftFrame.scrollFrame)
		UpdateScrollFrame(self.rightFrame.scrollFrame)
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local frameEdge = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 24,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local function Constructor()
	local borderColor = TSM.db.profile.frameBackdropColor
	local name = "TSMSelectionList" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	
	local leftFrame = CreateFrame("Frame", name.."LeftFrame", frame)
	leftFrame:SetPoint("TOPLEFT", 0, -15)
	leftFrame:SetPoint("BOTTOMLEFT")
	leftFrame:SetBackdrop(frameEdge)
	leftFrame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	leftFrame:SetWidth(200)
	leftFrame.list = {}
	frame.leftFrame = leftFrame
	
	local leftTitle = frame:CreateFontString(nil, "OVERLAY", GameFontHighlight)
	local tFile, tSize = GameFontHighlight:GetFont()
	leftTitle:SetFont(tFile, tSize-1)
	leftTitle:SetJustifyH("LEFT")
	leftTitle:SetJustifyV("BOTTOM")
	leftTitle:SetTextColor(1, 1, 1, 1)
	leftTitle:SetHeight(15)
	leftTitle:SetPoint("BOTTOMLEFT", leftFrame, "TOPLEFT", 8, 0)
	leftTitle:SetPoint("BOTTOMRIGHT", leftFrame, "TOPRIGHT", -8, 0)
	frame.leftTitle = leftTitle
	
	local leftSF = CreateFrame("ScrollFrame", name.."LeftFrameScrollFrame", leftFrame, "FauxScrollFrameTemplate")
	leftSF:SetPoint("TOPLEFT", 10, -12)
	leftSF:SetPoint("BOTTOMRIGHT", -28, 8)
	leftSF:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function() UpdateScrollFrame(self) end) 
	end)
	leftFrame.scrollFrame = leftSF
	
	local rightFrame = CreateFrame("Frame", name.."RightFrame", frame)
	rightFrame:SetPoint("TOPRIGHT", 0, -15)
	rightFrame:SetPoint("BOTTOMRIGHT")
	rightFrame:SetBackdrop(frameEdge)
	rightFrame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	rightFrame:SetWidth(200)
	rightFrame.list = {}
	frame.rightFrame = rightFrame
	
	local rightTitle = frame:CreateFontString(nil, "OVERLAY", GameFontHighlight)
	local tFile, tSize = GameFontHighlight:GetFont()
	rightTitle:SetFont(tFile, tSize-1)
	rightTitle:SetJustifyH("LEFT")
	rightTitle:SetJustifyV("BOTTOM")
	rightTitle:SetTextColor(1, 1, 1, 1)
	rightTitle:SetHeight(15)
	rightTitle:SetPoint("BOTTOMLEFT", rightFrame, "TOPLEFT", 8, 0)
	rightTitle:SetPoint("BOTTOMRIGHT", rightFrame, "TOPRIGHT", -8, 0)
	frame.rightTitle = rightTitle
	
	local rightSF = CreateFrame("ScrollFrame", name.."RightFrameScrollFrame", rightFrame, "FauxScrollFrameTemplate")
	rightSF:SetPoint("TOPLEFT", 10, -12)
	rightSF:SetPoint("BOTTOMRIGHT", -28, 8)
	rightSF:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function() UpdateScrollFrame(self) end) 
	end)
	rightFrame.scrollFrame = rightSF
	
	local buttonFrame = CreateFrame("Frame", name.."ButtonFrame", frame)
	buttonFrame:SetPoint("CENTER")
	buttonFrame:SetHeight(200)
	buttonFrame:SetWidth(105)
	leftFrame:SetPoint("RIGHT", buttonFrame, "LEFT")
	rightFrame:SetPoint("LEFT", buttonFrame, "RIGHT")
	
	local ebFrame = CreateFrame("Frame", nil, buttonFrame)
	ebFrame:SetPoint("TOPLEFT")
	ebFrame:SetPoint("TOPRIGHT")
	ebFrame:SetHeight(50)
	buttonFrame.filterFrame = ebFrame
	
	local eb = AceGUI:Create("TSMEditBox")
	eb.frame:SetAllPoints(ebFrame)
	eb.frame:SetParent(ebFrame)
	eb:SetCallback("OnEnterPressed", OnFilterSet)
	eb:SetCallback("OnEnter", function(self)
			if not self.tooltip then return end
			GameTooltip:SetOwner(self.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
	eb:SetCallback("OnLeave", function() GameTooltip:Hide() end)
	eb.frame:Show()
	eb.editbox:Show()
	ebFrame.filter = eb
	
	local btn = AceGUI:Create("TSMButton").frame
	btn.type = "Add"
	btn:SetParent(buttonFrame)
	btn:SetPoint("TOPLEFT", 0, -100)
	btn:SetPoint("TOPRIGHT", 0, -100)
	btn:SetText("|cffffffffAdd>>|r")
	btn:SetHeight(30)
	btn:SetScript("OnEnter", function(self)
			if not self.tooltip then return end
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
	btn:SetScript("OnClick", OnButtonClick)
	btn.tooltip = "Click to add the selected items to the list on the right."
	btn:Show()
	buttonFrame.topButton = btn
	
	local btn = AceGUI:Create("TSMButton").frame
	btn.type = "Remove"
	btn:SetParent(buttonFrame)
	btn:SetPoint("BOTTOMLEFT")
	btn:SetPoint("BOTTOMRIGHT")
	btn:SetText("|cffffffff<<Remove|r")
	btn:SetHeight(30)
	btn:SetScript("OnEnter", function(self)
			if not self.tooltip then return end
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
	btn:SetScript("OnClick", OnButtonClick)
	btn.tooltip = "Click to remove the selected items from the list on the right."
	btn:Show()
	buttonFrame.bottomButton = btn

	local widget = {
		buttonFrame = buttonFrame,
		leftFrame = leftFrame,
		leftScrollFrame = leftSF,
		rightFrame = rightFrame,
		rightScrollFrame = rightSF,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	
	widget.buttonFrame.obj = widget
	widget.buttonFrame.filterFrame.filter.obj = widget
	widget.leftFrame.obj = widget
	widget.rightFrame.obj = widget
	widget.frame.obj = widget

	tinsert(TSM.customContainers, widget)
	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)