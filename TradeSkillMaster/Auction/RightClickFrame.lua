local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table

local function CreateRightClickFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	TSMAPI.Design:SetFrameBackdropColor(frame)
	frame:Hide()
	frame:SetFrameStrata("TOOLTIP")
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

local rClickFunctions = {}
local rClickFrame
local function OnRowRightClick(parent, itemLink)
	rClickFrame = rClickFrame or CreateRightClickFrame(parent)
	rClickFrame:Hide()
	rClickFrame:SetParent(parent)
	rClickFrame:SetHeight(33 + 21 * #rClickFunctions)
	rClickFrame:SetWidth(250)
	rClickFrame:Show()
	
	local text = TSMAPI.GUI:CreateLabel(rClickFrame)
	text:SetPoint("TOPLEFT", 2, -2)
	text:SetPoint("TOPRIGHT", -2, 2)
	text:SetHeight(20)
	text:SetText(TSMAPI.Design:GetInlineColor("link")..L["Quick Action Menu:"].."|r")	
	rClickFrame.rows = rClickFrame.rows or {}
	
	for i=1, #rClickFunctions do
		local row = rClickFrame.rows[i] or CreateFrame("Button", nil, rClickFrame)
		row.isTSMRightClickChild = true
		row:RegisterForClicks("AnyDown")
		row:SetPoint("TOPLEFT", 10, -(5+i*(21)))
		row:SetHeight(20)
		row:SetWidth(rClickFrame:GetWidth()-20)
		
		row:SetScript("OnClick", function()
				rClickFunctions[i].callback(parent, itemLink)
				rClickFrame:Hide()
			end)
		
		if not rClickFrame.rows[i] then
			local tex = row:CreateTexture()
			tex:SetPoint("TOPLEFT", 0, 0)
			tex:SetPoint("BOTTOMRIGHT", 0, 0)
			tex:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
			tex:SetVertexColor(1, 1, 1, 0.3)
			row:SetHighlightTexture(tex)
		end
		
		local text = rClickFrame.rows[i] and rClickFrame.rows[i].text or TSMAPI.GUI:CreateLabel(row)
		text:SetJustifyH("LEFT")
		text:SetJustifyV("CENTER")
		text:SetPoint("BOTTOMRIGHT")
		text:SetPoint("TOPLEFT")
		text:SetText(rClickFunctions[i].label)
		row:SetFontString(text)
		row.text = text
		
		rClickFrame.rows[i] = row
	end
end

function TSMAPI:GetSTRowRightClickFunction()
	return OnRowRightClick
end

function TSMAPI:RegisterAuctionSTRightClickFunction(label, callback)
	tinsert(rClickFunctions, {label=label, callback=callback})
end