-- This file contains all the APIs regarding TSM's main frame (what shows when you type '/tsm').

local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local private = {icons={}, currentIcon=0}
local lib = TSMAPI


--- Sets the width and height of the main TSM frame.
-- This will also refresh the layout of the icons and reset the frame to the center of the screen.
-- @param width The width to set the main TSM frame to.
-- @param height The height to set the main TSM frame to.
function lib:SetFrameSize(width, height)
	TSM.Frame:SetWidth(width)
	TSM.Frame:SetHeight(height)
	TSM.Frame.localstatus.width = width
	TSM.Frame.localstatus.height = height
	TSM:BuildIcons()
	TSM.Frame:ClearAllPoints()
	TSM.Frame:SetPoint("CENTER", UIParent, "CENTER")
end

--- Sets the status text of the main TSM window. This is the text that shows up to the left of the "Close" button.
-- @param statusText The string to set as the status text. A nil or empty string will reset the status text to showing tips.
function lib:SetStatusText(statusText)
	if statusText and statusText:trim() ~= "" then
		TSM.Frame:SetStatusText(statusText)
	else
		TSM.Frame:SetStatusText("|cffffd200"..L["Tip:"].." |r"..TSM:GetTip())
	end
end

--- Opens the main TSM window.
function lib:OpenFrame()
	TSM.Frame:Show()
	TSM:BuildIcons()
end

--- Closes the main TSM window.
function lib:CloseFrame()
	TSM.Frame:Hide()
end

--- Registers a new icon to be displayed in the main TSM window.
-- @param displayName The text that shows when the user hovers over the icon (localized).
-- @param icon The texture to use for the icon.
-- @param loadGUI A function that will get called when the user clicks on the icon.
-- @param moduleName The name of the module that's registering this icon (unlocalized).
-- @param side The side of the main TSM frame to put the icon on. The options are "crafting" (left side), "module" (bottom), and "options" (right side).
-- @return Returns an error message as the second return value upon error.
function lib:RegisterIcon(displayName, icon, loadGUI, moduleName, side)
	if not (displayName and icon and loadGUI and moduleName) then
		return nil, "invalid args", displayName, icon, loadGUI, moduleName
	end
	
	if not TSM:CheckModuleName(moduleName) then
		return nil, "No module registered under name: " .. moduleName
	end
	
	if side and not (side == "module" or side == "crafting" or side == "options") then
		return nil, "invalid side", side
	end
	
	tinsert(private.icons, {name=displayName, moduleName=moduleName, icon=icon, loadGUI=loadGUI, side=(strlower(side or "module"))})
end

--- Selects an icon in the main TSM window once it's open.
-- @param moduleName Which module the icon belongs to (unlocalized).
-- @param iconName The text that shows in the tooltip of the icon to be clicked (localized).
-- @return Returns an error message as the second return value upon error.
function lib:SelectIcon(moduleName, iconName)
	if not moduleName then return nil, "no moduleName passed" end
	
	if not TSM:CheckModuleName(moduleName) then
		return nil, "No module registered under name: " .. moduleName
	end
	
	for _, data in ipairs(private.icons) do
		if not data.frame then return nil, "not ready yet" end
		if data.moduleName == moduleName and data.name == iconName then
			data.frame:Click()
		end
	end
end


function TSM:CreateMainFrame()
	TSM.Frame = AceGUI:Create("TSMMainFrame")
	TSM.Frame:SetLayout("Fill")
	TSM.Frame:SetWidth(TSM.FRAME_WIDTH)
	TSM.Frame:SetHeight(TSM.FRAME_HEIGHT)
	
	local oldWidthSet = TSM.Frame.OnWidthSet
	TSM.Frame.OnWidthSet = function(self, width)
			TSM.Frame.localstatus.width = width
			oldWidthSet(self, width)
			TSM:BuildIcons()
		end
	local oldHeightSet = TSM.Frame.OnHeightSet
	TSM.Frame.OnHeightSet = function(self, height)
			TSM.Frame.localstatus.height = height
			oldHeightSet(self, height)
			TSM:BuildIcons()
		end
		
	TSM.Frame.helpButton = TSM:CreateHelpButton()
end

function TSM:BuildIcons()
	local numItems = {left=0, right=0, bottom=0}
	local count = {left=0, right=0, bottom=0}
	local spacing = {}
	
	for _, data in ipairs(private.icons) do
		if data.frame then 
			data.frame:Hide()
		end
		if data.side == "crafting" then
			numItems.left = numItems.left + 1
		elseif data.side == "options" then
			numItems.right = numItems.right + 1
		else
			numItems.bottom = numItems.bottom + 1
		end
	end
	
	spacing.left = min(lib:SafeDivide(TSM.Frame.craftingIconContainer:GetHeight() - 10, numItems.left), 200)
	spacing.right = min(lib:SafeDivide(TSM.Frame.optionsIconContainer:GetHeight() - 10, numItems.right), 200)
	spacing.bottom = min(lib:SafeDivide(TSM.Frame.moduleIconContainer:GetWidth() - 10, numItems.bottom), 200)

	for i=1, #(private.icons) do
		local frame = nil
		if private.icons[i].frame then
			frame = private.icons[i].frame
			frame:Show()
		else
			frame = CreateFrame("Button", nil, TSM.Frame.frame)
			frame:SetScript("OnClick", function()
					if #(TSM.Frame.children) > 0 then
						TSM.Frame:ReleaseChildren()
						lib:SetStatusText("")
					end
					local name, version
					for _, module in ipairs(TSM.registeredModules) do
						if module.name == private.icons[i].moduleName then
							name = module.name
							version = module.version
						end
					end
					lib:SetCurrentHelpInfo()
					TSM.Frame:SetTitle((name or private.icons[i].moduleName) .. " " .. version)
					private.icons[i].loadGUI(TSM.Frame)
					private.currentIcon = i
				end)
			frame:SetScript("OnEnter", function(self)
					if private.icons[i].side == "options" then
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, -20)
					elseif private.icons[i].side == "crafting" then
						GameTooltip:SetOwner(self, "ANCHOR_LEFT", -5, -20)
					else
						GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
					end
					GameTooltip:SetText(private.icons[i].name)
					GameTooltip:Show()
				end)
			frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

			local image = frame:CreateTexture(nil, "BACKGROUND")
			image:SetWidth(40)
			image:SetHeight(40)
			image:SetPoint("TOP")
			frame.image = image

			local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
			highlight:SetAllPoints(image)
			highlight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
			highlight:SetTexCoord(0, 1, 0.23, 0.77)
			highlight:SetBlendMode("ADD")
			frame.highlight = highlight
			
			frame:SetHeight(40)
			frame:SetWidth(40)
			frame.image:SetTexture(private.icons[i].icon)
			frame.image:SetVertexColor(1, 1, 1)
			
			private.icons[i].frame = frame
		end
		
		if private.icons[i].side == "crafting" then
			count.left = count.left + 1
			frame:SetPoint("BOTTOMLEFT", TSM.Frame.craftingIconContainer, "TOPLEFT", 10, -((count.left-1)*spacing.left)-50)
		elseif private.icons[i].side == "options" then
			count.right = count.right + 1
			frame:SetPoint("BOTTOMLEFT", TSM.Frame.optionsIconContainer, "TOPLEFT", 11, -((count.right-1)*spacing.right)-50)
		else
			count.bottom = count.bottom + 1
			frame:SetPoint("BOTTOMLEFT", TSM.Frame.moduleIconContainer, "BOTTOMLEFT", ((count.bottom-1)*spacing.bottom)+10, 7)
		end
	end
	local minHeight = max(max(numItems.left, numItems.right)*50, 200)
	local minWidth = max(numItems.bottom*50, 400)
	TSM.Frame.frame:SetMinResize(minWidth, minHeight)
end

function TSM:SelectInitialIcon()
	if not private.icons[private.currentIcon] then
		for i=1, #(private.icons) do
			if private.icons[i].name==L["Status"] then
				private.icons[i].loadGUI(TSM.Frame)
				local name, version
				for _, module in ipairs(TSM.registeredModules) do
					if module.name == private.icons[i].moduleName then
						name = module.name
						version = module.version
						break
					end
				end
				TSM.Frame:SetTitle((name or private.icons[i].moduleName) .. " " .. version)
				break
			end
		end
	else
		private.icons[private.currentIcon].loadGUI(TSM.Frame)
		local name, version
		for _, module in ipairs(TSM.registeredModules) do
			if module.name == private.icons[private.currentIcon].moduleName then
				name = module.name
				version = module.version
				break
			end
		end
		TSM.Frame:SetTitle(name .. " " .. version)
	end
end

function TSM:GetCurrentIcon()
	return private.icons[currentIcon] and private.icons[currentIcon].moduleName
end