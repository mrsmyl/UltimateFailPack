-- This module holds some GUI helper functions for modules to use.
-- These functions support the table format for building AceGUI pages created by Sapu94.

local TSM = select(2, ...)
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local lib = TSMAPI

local function AddTooltip(widget, text, title)
	if not text then return end
	widget:SetCallback("OnEnter", function(self)
			GameTooltip:SetOwner(self.frame, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOM", self.frame, "TOP")
			if title then
				GameTooltip:SetText(title, 1, .82, 0, 1)
			end
			if type(text) == "number" then
				GameTooltip:SetHyperlink("item:" .. text)
			elseif tonumber(text) then
				GameTooltip:SetHyperlink("enchant:"..text)
			else
				GameTooltip:AddLine(text, 1, 1, 1, 1)
			end
			GameTooltip:Show()
		end)
	widget:SetCallback("OnLeave", function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end)
end

local Add = {
	InlineGroup = function(parent, args)
			local inlineGroup
			if args.title then
				inlineGroup = AceGUI:Create("TSMInlineGroup")
			else
				inlineGroup = AceGUI:Create("TSMInlineGroupNoTitle")
			end
			inlineGroup:SetLayout(args.layout)
			inlineGroup:SetTitle(args.title)
			inlineGroup:SetFullWidth(true)
			inlineGroup:SetFullHeight(args.fullHeight)
			parent:AddChild(inlineGroup)
			return inlineGroup
		end,
		
	SimpleGroup = function(parent, args)
			local simpleGroup = AceGUI:Create("TSMSimpleGroup")
			simpleGroup:SetLayout(args.layout)
			simpleGroup:SetRelativeWidth(args.relativeWidth or 1)
			simpleGroup:SetFullHeight(args.fullHeight)
			if args.height then simpleGroup:SetHeight(args.height) end
			parent:AddChild(simpleGroup)
			return simpleGroup
		end,
		
	ScrollFrame = function(parent, args)
			local scrollFrame = AceGUI:Create("TSMScrollFrame")
			scrollFrame:SetLayout(args.layout)
			scrollFrame:SetFullWidth(true)
			scrollFrame:SetFullHeight(args.fullHeight)
			parent:AddChild(scrollFrame)
			return scrollFrame
		end,
		
	SelectionList = function(parent, args)
			local selectionList = AceGUI:Create("TSMSelectionList")
			selectionList:SetList("left", args.leftList)
			selectionList:SetTitle("left", args.leftTitle)
			selectionList:SetList("right", args.rightList)
			selectionList:SetTitle("right", args.rightTitle)
			selectionList:SetTitle("filter", args.filterTitle)
			selectionList:SetTitle("filterTooltip", args.filterTooltip)
			if args.fullWidth then
				selectionList:SetFullWidth(args.fullWidth)
			elseif args.width then
				selectionList:SetWidth(args.width)
			elseif args.relativeWidth then
				selectionList:SetRelativeWidth(args.relativeWidth)
			end
			selectionList:SetCallback("OnAddClicked", args.onAdd)
			selectionList:SetCallback("OnRemoveClicked", args.onRemove)
			selectionList:SetCallback("OnFilterEntered", args.onFilter)
			parent:AddChild(selectionList)
			return selectionList
		end,
		
	Label = function(parent, args)
			local labelWidget = AceGUI:Create("Label")
			labelWidget:SetText(args.text)
			labelWidget:SetFontObject(args.fontObject or GameFontNormal)
			if args.fullWidth then
				labelWidget:SetFullWidth(args.fullWidth)
			elseif args.width then
				labelWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				labelWidget:SetRelativeWidth(args.relativeWidth)
			end
			if args.height then labelWidget:SetHeight(args.height) end
			labelWidget:SetColor(args.colorRed, args.colorGreen, args.colorGreen)
			AddTooltip(labelWidget, args.tooltip)
			parent:AddChild(labelWidget)
			return labelWidget
		end,
		
	MultiLabel = function(parent, args)
			local labelWidget = AceGUI:Create("TSMMultiLabel")
			labelWidget:SetLabels(args.labelInfo)
			labelWidget:SetFontObject(args.fontObject or GameFontNormal)
			if args.fullWidth then
				labelWidget:SetFullWidth(args.fullWidth)
			elseif args.width then
				labelWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				labelWidget:SetRelativeWidth(args.relativeWidth)
			end
			labelWidget:SetColor(args.colorRed, args.colorGreen, args.colorGreen)
			AddTooltip(labelWidget, args.tooltip)
			parent:AddChild(labelWidget)
			return labelWidget
		end,
		
	InteractiveLabel = function(parent, args)
			local iLabelWidget = AceGUI:Create("InteractiveLabel")
			iLabelWidget:SetText(args.text)
			iLabelWidget:SetFontObject(args.fontObject)
			if args.width then
				iLabelWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				iLabelWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				iLabelWidget:SetFullWidth(args.fullWidth)
			end
			iLabelWidget:SetCallback("OnClick", args.callback)
			AddTooltip(iLabelWidget, args.tooltip)
			parent:AddChild(iLabelWidget)
			return iLabelWidget
		end,
		
	Button = function(parent, args)
			local buttonWidget = AceGUI:Create("TSMButton")
			buttonWidget:SetText(args.text)
			buttonWidget:SetDisabled(args.disabled)
			if args.width then
				buttonWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				buttonWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				buttonWidget:SetFullWidth(args.fullWidth)
			end
			if args.height then buttonWidget:SetHeight(args.height) end
			buttonWidget:SetCallback("OnClick", args.callback)
			AddTooltip(buttonWidget, args.tooltip, args.text)
			parent:AddChild(buttonWidget)
			return buttonWidget
		end,
		
	--added by Geemoney 9-12-11
	DestroyButton = function(parent, args)
			local buttonWidget = AceGUI:Create("TSMFastDestroyButton")
			buttonWidget:SetText(args.text)
			buttonWidget:SetDisabled(args.disabled)
			buttonWidget:SetMode(args.mode)
			buttonWidget:SetSpell(args.spell)
			buttonWidget:SetLocationsFunc(args.locfunction)
			if args.width then
				buttonWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				buttonWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				buttonWidget:SetFullWidth(args.fullWidth)
			end
			if args.height then buttonWidget:SetHeight(args.height) end
			buttonWidget:SetCallback("OnClick", args.callback)
			buttonWidget:SetCallback("PreClick", args.preclick)
			buttonWidget:SetCallback("PostClick", args.postclick)
			buttonWidget:SetCallback("OnEnter", args.onenter)
			buttonWidget:SetCallback("OnLeave", args.onleave)
			AddTooltip(buttonWidget, args.tooltip, args.text)
			parent:AddChild(buttonWidget)
			return buttonWidget
		end,
		
	MacroButton = function(parent, args)
			local macroButtonWidget = AceGUI:Create("TSMMacroButton")
			macroButtonWidget:SetText(args.text)
			macroButtonWidget:SetDisabled(args.disabled)
			if args.width then
				macroButtonWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				macroButtonWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				macroButtonWidget:SetFullWidth(args.fullWidth)
			end
			if args.height then macroButtonWidget:SetHeight(args.height) end
			macroButtonWidget.frame:SetAttribute("type", "macro")
			macroButtonWidget.frame:SetAttribute("macrotext", args.macroText)
			AddTooltip(macroButtonWidget, args.tooltip, args.text)
			parent:AddChild(macroButtonWidget)
			return macroButtonWidget
		end,
	
	EditBox = function(parent, args)
			local editBoxWidget
			if args.onRightClick then
				editBoxWidget = AceGUI:Create("TSMOverrideEditBox")
				editBoxWidget.disabledFrame.tooltip = args.disabledTooltip
				editBoxWidget.disabledFrame.onRightClick = args.onRightClick
			else
				editBoxWidget = AceGUI:Create("TSMEditBox")
			end
			editBoxWidget:SetText(args.value)
			editBoxWidget:SetLabel(args.label)
			editBoxWidget:SetDisabled(args.disabled)
			if args.width then
				editBoxWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				editBoxWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				editBoxWidget:SetFullWidth(args.fullWidth)
			end
			editBoxWidget:DisableButton(args.onTextChanged)
			editBoxWidget:SetCallback(args.onTextChanged and "OnTextChanged" or "OnEnterPressed", args.callback)
			AddTooltip(editBoxWidget, args.tooltip, args.label)
			parent:AddChild(editBoxWidget)
			return editBoxWidget
		end,
		
	CheckBox = function(parent, args)
			local checkBoxWidget
			if args.onRightClick then
				checkBoxWidget = AceGUI:Create("TSMOverrideCheckBox")
				checkBoxWidget.disabledFrame.tooltip = args.disabledTooltip
				checkBoxWidget.disabledFrame.onRightClick = args.onRightClick
			else
				checkBoxWidget = AceGUI:Create("TSMCheckBox")
			end
			
			if args.quickCBInfo then
				args.value = args.value or args.quickCBInfo[1][args.quickCBInfo[2]]
				local oldCallback = args.callback
				args.callback = function(...)
					args.quickCBInfo[1][args.quickCBInfo[2]] = select(3, ...)
					if oldCallback then oldCallback(...) end
				end
			end
			
			checkBoxWidget:SetType(args.cbType or "checkbox")
			checkBoxWidget:SetValue(args.value)
			checkBoxWidget:SetLabel(args.label)
			checkBoxWidget:SetDisabled(args.disabled)
			if args.fullWidth then
				checkBoxWidget:SetFullWidth(args.fullWidth)
			elseif args.width then
				checkBoxWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				checkBoxWidget:SetRelativeWidth(args.relativeWidth)
			else
				checkBoxWidget:SetRelativeWidth(0.5)
			end
			if args.height then checkBoxWidget:SetHeight(args.height) end
			checkBoxWidget:SetCallback("OnValueChanged", args.callback)
			AddTooltip(checkBoxWidget, args.tooltip, args.label)
			parent:AddChild(checkBoxWidget)
			return checkBoxWidget
		end,
		
	Slider = function(parent, args)
			local sliderWidget
			if args.onRightClick then
				sliderWidget = AceGUI:Create("TSMOverrideSlider")
				sliderWidget.disabledFrame.tooltip = args.disabledTooltip
				sliderWidget.disabledFrame.onRightClick = args.onRightClick
			else
				sliderWidget = AceGUI:Create("TSMSlider")
			end
			sliderWidget:SetValue(args.value)
			sliderWidget:SetSliderValues(args.min, args.max, args.step)
			sliderWidget:SetIsPercent(args.isPercent)
			sliderWidget:SetLabel(args.label)
			if args.width then
				sliderWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				sliderWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				sliderWidget:SetFullWidth(args.fullWidth)
			end
			sliderWidget:SetCallback("OnValueChanged", args.callback)
			sliderWidget:SetDisabled(args.disabled)
			AddTooltip(sliderWidget, args.tooltip, args.label)
			parent:AddChild(sliderWidget)
			return sliderWidget
		end,
		
	Icon = function(parent, args)
			local iconWidget = AceGUI:Create("Icon")
			iconWidget:SetImage(args.image)
			iconWidget:SetImageSize(args.imageWidth, args.imageHeight)
			if args.width then
				iconWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				iconWidget:SetRelativeWidth(args.relativeWidth)
			end
			iconWidget:SetDisabled(args.disabled)
			iconWidget:SetLabel(args.label)
			iconWidget:SetCallback("OnClick", args.callback)
			AddTooltip(iconWidget, args.tooltip)
			parent:AddChild(iconWidget)
			return iconWidget
		end,
		
	Dropdown = function(parent, args)
			local dropdownWidget
			if args.onRightClick then
				dropdownWidget = AceGUI:Create("TSMOverrideDropdown")
				dropdownWidget.disabledFrame.tooltip = args.disabledTooltip
				dropdownWidget.disabledFrame.onRightClick = args.onRightClick
			else
				dropdownWidget = AceGUI:Create("TSMDropdown")
			end
			dropdownWidget:SetText(args.text)
			dropdownWidget:SetLabel(args.label)
			dropdownWidget:SetList(args.list)
			if args.width then
				dropdownWidget:SetWidth(args.width)
			elseif args.relativeWidth then
				dropdownWidget:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				dropdownWidget:SetFullWidth(args.fullWidth)
			end
			dropdownWidget:SetMultiselect(args.multiselect)
			dropdownWidget:SetDisabled(args.disabled)
			if type(args.value) == "table" then
				for name, value in pairs(args.value) do
					dropdownWidget:SetItemValue(name, value)
				end
			else
				dropdownWidget:SetValue(args.value)
			end
			dropdownWidget:SetCallback("OnValueChanged", args.callback)
			AddTooltip(dropdownWidget, args.tooltip, args.label)
			parent:AddChild(dropdownWidget)
			return dropdownWidget
		end,
		
	ColorPicker = function(parent, args)
			local colorPicker = AceGUI:Create("ColorPicker")
			colorPicker:SetLabel(args.label)
			colorPicker:SetHasAlpha(args.hasAlpha)
			colorPicker:SetDisabled(args.disabled)
			if type(args.value) == "table" then
				colorPicker:SetColor(args.value.r, args.value.g, args.value.b, args.hasAlpha and args.value.a)
			end
			if args.width then
				colorPicker:SetWidth(args.width)
			elseif args.relativeWidth then
				colorPicker:SetRelativeWidth(args.relativeWidth)
			elseif args.fullWidth then
				colorPicker:SetFullWidth(args.fullWidth)
			end
			colorPicker:SetCallback("OnValueChanged", args.callback)
			colorPicker:SetCallback("OnValueConfirmed", args.callback)
			AddTooltip(colorPicker, args.tooltip, args.label)
			parent:AddChild(colorPicker)
			return colorPicker
		end,
		
	Spacer = function(parent, args)
			args.quantity = args.quantity or 1
			for i=1, args.quantity do
				local spacer = parent:Add({type="Label", text=" ", fullWidth=true})
			end
		end,
		
	HeadingLine = function(parent, args)
			local heading = AceGUI:Create("Heading")
			heading:SetText("")
			if args.relativeWidth then
				heading:SetRelativeWidth(args.relativeWidth)
			else
				heading:SetFullWidth(true)
			end
			parent:AddChild(heading)
		end,
}

-- creates a widget or container as detailed in the passed table (iTable) and adds it as a child of the passed parent
function lib.AddGUIElement(parent, iTable)
	if not Add[iTable.type] then
		print("Invalid Widget or Container Type: ", iTable.type)
		return
	end
	
	return Add[iTable.type](parent, iTable)
end

-- goes through a page-table and draws out all the containers and widgets for that page
function lib:BuildPage(oContainer, oPageTable, noPause)
	local function recursive(container, pageTable)
		for _, data in pairs(pageTable) do
			local parentElement = container:Add(data)
			if data.children then
				parentElement:PauseLayout()
				-- yay recursive function calls!
				recursive(parentElement, data.children)
				parentElement:ResumeLayout()
				parentElement:DoLayout()
			end
		end
	end
	if not oContainer.Add then
		local container = AceGUI:Create("TSMSimpleGroup")
		container:SetLayout("fill")
		container:SetFullWidth(true)
		container:SetFullHeight(true)
		oContainer:AddChild(container)
		oContainer = container
	end
	if not noPause then
		oContainer:PauseLayout()
		recursive(oContainer, oPageTable)
		oContainer:ResumeLayout()
		oContainer:DoLayout()
	else
		recursive(oContainer, oPageTable)
	end
end

function lib:CreateScrollingTable(colInfo, useTSMColor, ...)
	local st = LibStub("ScrollingTable"):CreateST(colInfo, ...)
	st.frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			tile = false,
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 16,
			insets = {left = 3, right = 3, top = 5, bottom = 3},
		})
	if useTSMColor then
		st.type = "ScrollingTable"
		tinsert(TSM.customContainers, st)
		TSM:UpdateFrameColors()
	else
		st.frame:SetBackdropColor(0, 0, 0.05, 1)
		st.frame:SetBackdropBorderColor(0, 0, 1, 1)
		_G[st.frame:GetName().."ScrollTroughBorder"].background:SetTexture(0, 0, 1, 1)
	end
	
	-- custom functions that may or may not be in lib-st
	if not st.RowIsVisible then
		st.RowIsVisible = function(self, realrow)
			return (realrow > self.offset and realrow <= (self.displayRows + self.offset))
		end
	end
	if not st.SetScrollOffset then
		st.SetScrollOffset = function(self, offset)
			local maxOffset = max(#self.filtered - self.displayRows, 0)
			if not offset or offset < 0 or offset > maxOffset then
				return -- invalid offset
			end
			
			local scrollPercent = TSMAPI:SafeDivide(offset, maxOffset)
			local maxPixelOffset = self.scrollframe:GetVerticalScrollRange() + self.rowHeight
			local pixelOffset = scrollPercent * maxPixelOffset 
			self.scrollframe:SetVerticalScroll(pixelOffset)
			FauxScrollFrame_SetOffset(self.scrollframe, offset)
		end
	end
	
	return st
end
