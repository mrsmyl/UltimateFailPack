-- Special custom widgets for TSM_Auctioning
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

-- Dropdown
do
	local Type, Version = "TSMOverrideDropdown", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
	
	local function Constructor()
		local dropdown = AceGUI:Create("Dropdown")
		dropdown.type = Type
		
		dropdown.dropdown:SetScript("OnEnter", function(...) dropdown.button:GetScript("OnEnter")(...) end)
		dropdown.dropdown:SetScript("OnLeave", function(...) dropdown.button:GetScript("OnLeave")(...) end)
		dropdown.dropdown:SetScript("OnMouseUp", function(self, ...) self.obj.button:GetScript("OnClick")(self.obj.button, ...) end)
		
		local frame = CreateFrame("Frame", nil, dropdown.dropdown)
		frame:SetPoint("TOPLEFT")
		frame:SetPoint("BOTTOMRIGHT", dropdown.button)
		frame:SetFrameLevel(dropdown.button:GetFrameLevel()+1)
		frame:EnableMouse(true)
		frame:SetScript("OnShow", function(self) self:EnableMouse(self.tooltip and true) end)
		frame:SetScript("OnHide", function(self) self:EnableMouse(false) end)
		frame:SetScript("OnEnter", function(self)
				if not self.tooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		frame:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" and self.onRightClick then
					self.onRightClick(self:GetParent().obj, true)
				end
			end)
		dropdown.disabledFrame = frame
		
		local oldOnClick = dropdown.button:GetScript("OnClick")
		dropdown.button:SetScript("OnMouseUp", function(self, button, ...)
				if button == "RightButton" and self.obj.disabledFrame.onRightClick then
					self.obj.disabledFrame.onRightClick(self.obj, false)
					if self.obj.open then
						oldOnClick(self, button, ...)
					end
				end
			end)
		dropdown.button:SetScript("OnClick", function(self, button, ...)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
					if self.obj.open then
						oldOnClick(self, button, ...)
					end
				else
					oldOnClick(self, button, ...)
				end
			end)
			
		-- show/hide the disabledFrame when the dropdown is disabled/enabled respectively
		local oldSetDisabled = dropdown.SetDisabled
		dropdown.SetDisabled = function(self, disable)
				if disable then
					self.disabledFrame:Show()
				else
					self.disabledFrame:Hide()
				end
				oldSetDisabled(self, disable)
			end
			
		-- put the new tooltip on the pulldown button
		local oldButtonEnter = dropdown.button:GetScript("OnEnter")
		dropdown.button:SetScript("OnEnter", function(self, ...)
				if not self.obj.disabled then
					oldButtonEnter(self, ...)
				else
					self.obj.disabledFrame:GetScript("OnEnter")(self.obj.disabledFrame)
				end
			end)
		local oldButtonLeave = dropdown.button:GetScript("OnLeave")
		dropdown.button:SetScript("OnLeave", function(self, ...)
				if not self.obj.disabled then
					oldButtonLeave(self, ...)
				else
					self.obj.disabledFrame:GetScript("OnLeave")(self.obj.disabledFrame)
				end
			end)
		
		AceGUI:RegisterAsWidget(dropdown)
		return dropdown
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- EditBox
do
	local Type, Version = "TSMOverrideEditBox", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
	
	local function Constructor()
		local editBox = AceGUI:Create("EditBox")
		editBox.type = Type
		
		local frame = CreateFrame("Frame", nil, editBox.editbox)
		frame:SetAllPoints(editBox.editbox)
		frame:EnableMouse(true)
		frame:SetScript("OnShow", function(self) self:EnableMouse(self.tooltip and true) end)
		frame:SetScript("OnHide", function(self) self:EnableMouse(false) end)
		frame:SetScript("OnEnter", function(self)
				if not self.tooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		frame:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" and self.onRightClick then
					self.onRightClick(self:GetParent().obj, true)
				end
			end)
		editBox.disabledFrame = frame
		
		editBox.editbox:SetScript("OnMouseUp", function(self, button, ...)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
				end
			end)
			
		local oldSetDisabled = editBox.SetDisabled
		editBox.SetDisabled = function(self, disable)
				if disable then
					self.disabledFrame:Show()
				else
					self.disabledFrame:Hide()
				end
				oldSetDisabled(self, disable)
			end
		
		return AceGUI:RegisterAsWidget(editBox)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- CheckBox
do
	local Type, Version = "TSMOverrideCheckBox", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
	
	local function Constructor()
		local checkBox = AceGUI:Create("CheckBox")
		checkBox.type = Type
			
		local frame = CreateFrame("Frame", nil, checkBox.frame)
		frame:SetAllPoints(checkBox.frame)
		frame:EnableMouse(true)
		frame:SetScript("OnShow", function(self) self:EnableMouse(self.tooltip and true) end)
		frame:SetScript("OnHide", function(self) self:EnableMouse(false) end)
		frame:SetScript("OnEnter", function(self)
				if not self.tooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		frame:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" and self.onRightClick then
					self.onRightClick(self:GetParent().obj, true)
				end
			end)
		checkBox.disabledFrame = frame
		
		local oldOnClick = checkBox.frame:GetScript("OnMouseUp")
		checkBox.frame:SetScript("OnMouseUp", function(self, button, ...)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
				end
				oldOnClick(self, button, ...)
			end)
			
		local oldSetDisabled = checkBox.SetDisabled
		checkBox.SetDisabled = function(self, disable)
				if disable then
					self.disabledFrame:Show()
				else
					self.disabledFrame:Hide()
				end
				oldSetDisabled(self, disable)
			end
		
		return AceGUI:RegisterAsWidget(checkBox)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-- Slider
do
	local Type, Version = "TSMOverrideSlider", 1
	if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
	
	local function Constructor()
		local slider = AceGUI:Create("Slider")
		slider.type = Type
			
		local frame = CreateFrame("Frame", nil, slider.frame)
		frame:SetAllPoints(slider.frame)
		frame:SetFrameLevel(frame:GetFrameLevel()+1)
		frame:EnableMouse(true)
		frame:SetScript("OnShow", function(self) self:EnableMouse(self.tooltip and true) end)
		frame:SetScript("OnHide", function(self) self:EnableMouse(false) end)
		frame:SetScript("OnEnter", function(self)
				if not self.tooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		frame:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" and self.onRightClick then
					self.onRightClick(self:GetParent().obj, true)
				end
			end)
		slider.disabledFrame = frame
		
		slider.frame:SetScript("OnMouseUp", function(self, button, ...)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
				end
			end)
		
		local oldSliderMouseUp = slider.slider:GetScript("OnMouseUp")
		slider.slider:SetScript("OnMouseUp", function(self, button, ...)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
				else
					oldSliderMouseUp(self, button, ...)
				end
			end)
		slider.editbox:SetScript("OnMouseUp", function(self, button)
				if self.obj.disabledFrame.onRightClick and button == "RightButton" then
					self.obj.disabledFrame.onRightClick(self.obj, false)
					self:ClearFocus()
				end
			end)
			
		local oldSetDisabled = slider.SetDisabled
		slider.SetDisabled = function(self, disable)
				if disable then
					self.disabledFrame:Show()
				else
					self.disabledFrame:Hide()
				end
				oldSetDisabled(self, disable)
			end
		
		return AceGUI:RegisterAsWidget(slider)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end