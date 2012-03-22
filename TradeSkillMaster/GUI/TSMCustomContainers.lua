-- This file contains custom TSM containers that are based on AceGUI containers
-- but modified to fit the TSM theme and given a Add method for TSMAPI:BuildPage()
local TSM = select(2, ...)
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

TSM.customContainers = {}

-- Window
do
	local Type, Version = "TSMWindow", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("Window")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		for _, frame in pairs({container.frame:GetRegions()}) do
			if frame.GetVertexColor and frame:GetVertexColor() == 0 then
				frame:SetTexture(0, 0, 0, 1)
				frame:SetVertexColor(0, 0, 0, 0.9)
			end
		end
		
		AceGUI:RegisterAsContainer(container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- TreeGroup
do
	local Type, Version = "TSMTreeGroup", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("TreeGroup")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		container.border:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 4, right = 1, top = 4, bottom = 4},
		})
		container.border:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		container.treeframe:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 4, right = 1, top = 4, bottom = 4},
		})
		container.treeframe:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		
		container.content:SetPoint("TOPLEFT", 6, -6)
		container.content:SetPoint("BOTTOMRIGHT", -6, 6)
		
		AceGUI:RegisterAsContainer(container)
		tinsert(TSM.customContainers, container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- ScrollFrame
do
	local Type, Version = "TSMScrollFrame", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("ScrollFrame")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		AceGUI:RegisterAsContainer(container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- TabGroup
do
	local Type, Version = "TSMTabGroup", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("TabGroup")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		container.border:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 4, right = 1, top = 4, bottom = 4},
		})
		container.border:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		
		container.content:SetPoint("TOPLEFT", 8, -8)
		container.content:SetPoint("BOTTOMRIGHT", -8, 8)
		
		AceGUI:RegisterAsContainer(container)
		tinsert(TSM.customContainers, container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- InlineGroup
do
	local Type, Version = "TSMInlineGroup", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("InlineGroup")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		local frame = container.content:GetParent()
		frame:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 4, right = 1, top = 4, bottom = 4},
		})
		frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		
		AceGUI:RegisterAsContainer(container)
		tinsert(TSM.customContainers, container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- InlineGroup without a title
do
	local Type, Version = "TSMInlineGroupNoTitle", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("InlineGroup")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		
		local frame = container.content:GetParent()
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", 0, 0)
		frame:SetPoint("BOTTOMRIGHT", -1, 10)
		frame:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 20,
			insets = {left = 4, right = 1, top = 4, bottom = 4},
		})
		frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		
		AceGUI:RegisterAsContainer(container)
		tinsert(TSM.customContainers, container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- SimpleGroup
do
	local Type, Version = "TSMSimpleGroup", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

	local function Constructor()
		local container = AceGUI:Create("SimpleGroup")
		container.type = Type
		container.Add = TSMAPI.AddGUIElement
		AceGUI:RegisterAsContainer(container)
		return container
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

function TSM:UpdateFrameColors()
	for _, widget in ipairs(TSM.customContainers) do
		if widget.type == "TSMInlineGroupNoTitle" then
			widget.content:GetParent():SetBackdropBorderColor(TSMAPI:GetBorderColor())
		elseif widget.type == "TSMInlineGroup" then
			widget.content:GetParent():SetBackdropBorderColor(TSMAPI:GetBorderColor())
		elseif widget.type == "TSMTabGroup" then
			widget.border:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		elseif widget.type == "TSMTreeGroup" then
			widget.border:SetBackdropBorderColor(TSMAPI:GetBorderColor())
			widget.treeframe:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		elseif widget.type == "TSMSelectionList" then
			widget.leftFrame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
			widget.rightFrame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		elseif widget.type == "ScrollingTable" then
			widget.frame:SetBackdropColor(TSMAPI:GetBackdropColor())
			widget.frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
			_G[widget.frame:GetName().."ScrollTrough"].background:SetTexture(TSMAPI:GetBackdropColor())
			_G[widget.frame:GetName().."ScrollTroughBorder"].background:SetTexture(TSMAPI:GetBorderColor())
		end
	end
	
	if TSM.Frame then
		TSM.Frame.frame:SetBackdropColor(TSMAPI:GetBackdropColor())
		TSM.Frame.title:SetBackdropColor(TSMAPI:GetBackdropColor())
		TSM.Frame.statusbg:SetBackdropColor(TSMAPI:GetBackdropColor())
		TSM.Frame.optionsIconContainer:SetBackdropColor(TSMAPI:GetBackdropColor())
		TSM.Frame.craftingIconContainer:SetBackdropColor(TSMAPI:GetBackdropColor())
		TSM.Frame.moduleIconContainer:SetBackdropColor(TSMAPI:GetBackdropColor())
	
		TSM.Frame.frame:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		TSM.Frame.title:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		TSM.Frame.statusbg:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		TSM.Frame.optionsIconContainer:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		TSM.Frame.craftingIconContainer:SetBackdropBorderColor(TSMAPI:GetBorderColor())
		TSM.Frame.moduleIconContainer:SetBackdropBorderColor(TSMAPI:GetBorderColor())
	end
	
	TSM:UpdateCustomFrameColors()
	TSM:SendMessage("TSM_UPDATE_FRAME_COLORS")
end