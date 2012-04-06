local TSM = select(2, ...)
local Search = TSM:NewModule("Search", "AceEvent-3.0", "AceHook-3.0")
local GUI = TSMAPI:GetGUIFunctions()
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

function Search:OnInitialize()
	Search.auctions = {}
	TSMAPI:RegisterAuctionFunction("TradeSkillMaster_Shopping", Search, "Search", "Replacement for the \"Browse\" tab of the auction house. Displays all auctions that match your specified filters and allows you to buy them.")
end


-- ------------------------------------------------ --
--					GUI Creation functions					 --
-- ------------------------------------------------ --

function Search:Show(frame)
	Search.searchBar = Search.searchBar or Search:CreateSearchBar(frame)
	Search.searchBar:Show()
	Search.searchBar.editBox:SetFocus()
	Search.searchBar:Enable()
	
	Search.searchST = Search.searchST or Search:CreateSearchST(frame.content)
	Search.searchST:Show()
	
	Search.topLabel = Search.topLabel or Search:CreateTopLabel(frame.content)
	if not Search.searchBar.suggestionFrame:IsVisible() then Search.topLabel:Show() end
	if strfind(Search.topLabel.text:GetText() or "", L["Scanning"]) then Search.topLabel.text:SetText("") end
	
	Search:RegisterMessage("TSM_SHOPPING_AH_EVENT")
	TSM.AuctionControl:Show(frame)
	TSMAPI:ShowPricePerCheckBox()
end

function Search:ShowAutomaticFrames(parent)
	Search:Show(parent)
	Search.searchBar:Hide()
	Search.searchST:SetData({})
end

function Search:Hide()
	if not Search.searchBar then return end
	Search.searchST:Hide()
	Search.searchBar:Hide()
	Search.topLabel:Hide()
	TSMAPI:StopScan()
	Search:UnregisterAllMessages()
	TSM.AuctionControl:Hide()
end

function Search:CreateSearchSuggestionFrame(parent, contentFrame)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	TSMAPI:RegisterForColorChanges(frame)
	frame:SetAllPoints(contentFrame)
	frame:SetFrameLevel(contentFrame:GetFrameLevel() + 5)
	frame:SetScript("OnShow", function(self)
			parent.savedSearchesButton:SetText(L["Hide Saved Searches"])
			if Search.topLabel then Search.topLabel:Hide() end
			Search:SetGoldText(self.goldText)
		end)
	frame:SetScript("OnHide", function()
			parent.savedSearchesButton:SetText(L["Show Saved Searches"])
			if Search.topLabel then Search.topLabel:Show() end
		end)
	frame:EnableMouse(true)
		
	local goldText = frame:CreateFontString()
	goldText:SetFontObject(GameFontNormal)
	goldText:SetPoint("BOTTOM", frame, "TOP", 0, 0)
	goldText:SetJustifyH("CENTER")
	goldText:SetJustifyV("CENTER")
	goldText:SetHeight(40)
	goldText:SetTextColor(1, 1, 1, 1)
	frame.goldText = goldText

	local recentFrame = CreateFrame("Frame", nil, frame)
	recentFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	TSMAPI:RegisterForColorChanges(recentFrame)
	recentFrame:SetPoint("TOPLEFT")
	recentFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 1, 0)
	
	local buttonHeight = 16
	local numButtons = floor(TSMAPI:SafeDivide(frame:GetHeight()-10, buttonHeight))
	recentFrame.rows = {}
	
	for i=0, numButtons-1 do
		local row = CreateFrame("Button", nil, recentFrame)
		row:RegisterForClicks("AnyDown")
		if i == 0 then
			row:SetPoint("TOPLEFT", 6, -8)
			row:SetHeight(buttonHeight+2)
		else
			row:SetPoint("TOPLEFT", 6, -(10+i*buttonHeight))
			row:SetHeight(buttonHeight)
		end
		row:SetWidth(recentFrame:GetWidth()-12)
		
		row:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then
					Search.searchBar.editBox:SetText(self:GetText())
					Search.searchBar.button:Click()
					Search.searchBar.editBox:HighlightText(0, 0)
				elseif button == "RightButton" then
					if IsShiftKeyDown() then
						TSM:Print("\""..TSM.db.global.previousSearches[i].."\" removed from recent searches.")
						tremove(TSM.db.global.previousSearches, i)
					else
						TSM.Config:CreateNewShoppingList(TSM.db.global.previousSearches[i], true)
					end
				end
			end)
			
		row:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_LEFT")
 				GameTooltip:AddLine(L["Left-Click: |cffffffffRun this recent search.|r"])
				GameTooltip:AddLine(L["Right-Click: |cffffffffCreate shopping list from this recent search.|r"])
				GameTooltip:AddLine(L["Shift-Right-Click: |cffffffffRemove from recent searches.|r"])
 				GameTooltip:Show()
			end)
			
		row:SetScript("OnLeave", function(self)
 				GameTooltip:Hide()
			end)
		
		local tex = row:CreateTexture()
		tex:SetPoint("TOPLEFT", 0, 0)
		tex:SetPoint("BOTTOMRIGHT", 0, 0)
		tex:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
		tex:SetVertexColor(1, 1, 1, 0.3)
		row:SetHighlightTexture(tex)
		
		local text = row:CreateFontString()
		text:SetFontObject(GameFontHighlightSmall)
		text:SetTextColor(1, 1, 1, 1)
		text:SetJustifyH("LEFT")
		text:SetJustifyV("CENTER")
		text:SetPoint("BOTTOMRIGHT")
		text:SetPoint("TOPLEFT")
		row:SetFontString(text)
		
		row.origSetText = row.SetText
		row.SetText = function(self, text)
			local msg, num = gsub(text, "\t", "")
			self:GetFontString():SetPoint("TOPLEFT", 10*num, 0)
			self.origSetText(self, msg)
		end
		
		if i == 0 then
			row:GetFontString():SetFontObject(GameFontHighlight)
			row:GetFontString():SetJustifyH("CENTER")
			row:SetText(L["|cff99ffffRecent Searches"])
			row:Disable()
		end
		
		recentFrame.rows[i] = row
	end
	
	recentFrame:SetScript("OnUpdate", function()
			for i, row in ipairs(recentFrame.rows) do
				row:Show()
				if TSM.db.global.previousSearches[i] then
					row:SetText("\t"..(TSM.db.global.previousSearches[i] or ""))
				else
					row:Hide()
				end
			end
		end)
		
	local savedFrame = CreateFrame("Frame", nil, frame)
	savedFrame:SetPoint("TOPLEFT", frame, "TOP", -1, 0)
	savedFrame:SetPoint("BOTTOMRIGHT")
	
	local infoText = CreateFrame("Frame", nil, savedFrame)
	infoText:SetAllPoints()
	savedFrame.infoText = infoText
	local text = infoText:CreateFontString()
	text:SetFontObject(GameFontNormal)
	text:SetPoint("TOPLEFT", 10, -100)
	text:SetPoint("TOPRIGHT", -10, -100)
	text:SetHeight(100)
	text:SetText(L["|cffffbb11No dealfinding or shopping lists found. You can create shopping/dealfinding lists through the TSM_Shopping options.\n\nTIP: You can search for multiple items at a time by separating them with a semicolon. For example: \"volatile life; volatile earth; volatile water\"|r"])
	
	savedFrame.st = Search:CreateListsST(savedFrame)
	
	savedFrame:SetScript("OnUpdate", function(self)
			local num = 0
			for _ in pairs(TSM.db.profile.shopping) do
				num = num + 1
			end
			for _ in pairs(TSM.db.profile.dealfinding) do
				num = num + 1
			end
			if num == 0 then
				savedFrame.infoText:Show()
				savedFrame.st:Hide()
			else
				savedFrame.infoText:Hide()
				savedFrame.st:Show()
				Search:UpdateListsST(self.st)
			end
		end)
	
	return frame
end

function Search:CreateListsST(parent)
	local events = {
		["OnEnter"] = function(_, cellFrame, _, _, _, rowNum)
			if rowNum then
				GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE")
				GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "TOPLEFT")
				GameTooltip:AddLine(L["Left-Click: |cffffffffRun this shopping/dealfinding list.|r"])
				GameTooltip:AddLine(L["Right-Click: |cffffffffOpen the options for this shopping/dealfinding list|r"])
				GameTooltip:AddLine(L["Shift-Right-Click: |cffffffffDelete this shopping/dealfinding list. Cannot be undone!|r"])
 				GameTooltip:Show()
			end
		end,
		["OnLeave"] = function(_, _, _, _, _, rowNum)
			if rowNum then
				GameTooltip:Hide()
			end
		end,
		["OnClick"] = function(_, _, data, _, _, rowNum, _, _, button)
			if rowNum then
				if button == "LeftButton" then
					local listName = data[rowNum].listName
					if TSM.db.profile.shopping[listName] then
						Search:StartShoppingSearch(listName)
					elseif TSM.db.profile.dealfinding[listName] then
						Search:StartDealfindingSearch(listName)
					end
				elseif button == "RightButton" then
					if IsShiftKeyDown() then
						local listName = data[rowNum].listName
						if TSM.db.profile.shopping[listName] then
							TSM:Printf(L["Shopping list deleted: \"%s\""], listName)
							TSM.db.profile.shopping[listName] = nil
						elseif TSM.db.profile.dealfinding[listName] then
							TSM:Printf(L["Dealfinding list deleted: \"%s\""], listName)
							TSM.db.profile.dealfinding[listName] = nil
						end
					else
						TSMAPI:OpenFrame()
						TSMAPI:SelectIcon("TradeSkillMaster_Shopping", L["Shopping Options"])
						local listName = data[rowNum].listName
						if TSM.db.profile.shopping[listName] then
							TSM.Config.treeGroup:SelectByPath(4, listName)
						elseif TSM.db.profile.dealfinding[listName] then
							TSM.Config.treeGroup:SelectByPath(3, listName)
						end
					end
				end
			end
		end,
	}

	local stCols = {
		{name="|cff99ffff"..L["Shopping/Dealfinding Lists"], width=1, align="CENTER"},
	}
	
	local function GetSTColInfo(width)
		local colInfo = CopyTable(stCols)
		for i=1, #colInfo do
			colInfo[i].width = floor(colInfo[i].width*width)
		end

		return colInfo
	end
	
	local ROW_HEIGHT = 20

	local st = TSMAPI:CreateScrollingTable(GetSTColInfo(parent:GetWidth()), true)
	st.frame:SetParent(parent)
	st.frame:SetPoint("TOPLEFT", 0, -20)
	st.frame:SetPoint("BOTTOMRIGHT")
	st.frame:SetScript("OnSizeChanged", function(_,width, height)
			st:SetDisplayCols(GetSTColInfo(width))
			st:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
		
	local font = GameFontHighlightSmall:GetFont()
	for i, row in ipairs(st.rows) do
		row:SetHeight(ROW_HEIGHT)
		local tex = row:CreateTexture()
		tex:SetPoint("TOPLEFT", 4, -2)
		tex:SetPoint("BOTTOMRIGHT", -4, 2)
		tex:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScore-Highlight")
		tex:SetTexCoord(0.017, 1, 0.083, 0.909)
		tex:SetAlpha(0.3)
		row:SetNormalTexture(tex)
		
		if i%2 == 1 then
			row:GetNormalTexture():SetAlpha(0)
		end
		
		for j, col in ipairs(row.cols) do
			col.text:SetHeight(ROW_HEIGHT)
			col.text:SetFont(font, 10)
		end
	end

	st.scrollframe:SetScript("OnVerticalScroll", function(self, offset)
			FauxScrollFrame_OnVerticalScroll(self, offset, st.rowHeight, function() st:Refresh() end)
			for i, row in ipairs(st.rows) do
				local tex = row:GetNormalTexture()
				if not tex then
					tex = row:CreateTexture()
					tex:SetPoint("TOPLEFT", 4, -2)
					tex:SetPoint("BOTTOMRIGHT", -4, 2)
					tex:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScore-Highlight")
					tex:SetTexCoord(0.017, 1, 0.083, 0.909)
				end
				if i%2 == st.offset%2 then
					tex:SetAlpha(0.3)
				else
					tex:SetAlpha(0)
				end
				row:SetNormalTexture(tex)
			end
		end)
	
	st:Show()
	st:SetData({})
	st:RegisterEvents(events)
	st.frame:GetScript("OnSizeChanged")(st.frame, st.frame:GetWidth(), st.frame:GetHeight())
	st:EnableSelection(false)
	st:Hide()
	return st
end

function Search:UpdateListsST(st)
	local lists = {}
	for listName in pairs(TSM.db.profile.shopping) do
		local text = "|cffffffff"..listName.."|r"
		tinsert(lists, {listName=listName, text=text})
	end
	for listName in pairs(TSM.db.profile.dealfinding) do
		local text = "|cff99ff99"..listName.."|r"
		tinsert(lists, {listName=listName, text=text})
	end
	sort(lists, function(a, b) return a.listName < b.listName end)
	
	
	local rows = {}
	for _, data in ipairs(lists) do
		tinsert(rows, {cols={{value=data.text}}, listName=data.listName})
	end
	st:SetData(rows)
end

function Search:CreateSearchBar(parent)
	local function InsertLink(link)
		local putIntoChat = Search.hooks.ChatEdit_InsertLink(link)
		if not putIntoChat then
			if Search.searchBar:IsVisible() and not Search.searchBar.isDisabled and not Search.searchST.isShowingItemTooltip and TSMAPI:AHTabIsVisible() then
				local name = GetItemInfo(link)
				if name then
					Search.searchBar.editBox:SetText(name)
					Search.searchBar.button:Click()
					return true
				end
			end
		end
		return putIntoChat
	end
	Search:RawHook("ChatEdit_InsertLink", InsertLink, true)
	
	local function RemoveFocusAndHighlight(self)
		self:ClearFocus()
		self:HighlightText(0, 0)
	end

	local function OnEnterPressed(self)
		Search:StartRegularSearch(self:GetText())
	end

	local function OnChar(self)
		local text = self:GetText()
		for i=1, #TSM.db.global.previousSearches do
			local prevSearch = strlower(TSM.db.global.previousSearches[i])
			if strsub(prevSearch, 1, #text) == strlower(text) then
				self:SetText(prevSearch)
				self:HighlightText(#text, -1)
				break
			end
		end
	end
	
	local function OnEditFocusGained(self)
		self:HighlightText()
	end
	
	local function OnEditFocusLost(self)
		self:HighlightText()
	end
	
	local function OnUpdate(self)
		if self:IsEnabled() and not TSMAPI:AHTabIsVisible() then
			self:ClearFocus()
		end
	end
	
	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetMinimumWidth(400)
		GameTooltip:AddLine(L["Enter what you want to search for in this box. You can also use the following options for more complicated searches.\n"], 1, 1, 1, 1)
		GameTooltip:AddLine(L["|cffffff00Multiple Search Terms:|r You can search for multiple things at once by simply separated them with a ';'. For example '|cff99ffffelementium ore; obsidium ore|r' will search for both elementium and obsidium ore.\n"], 1, 1, 1, 1)
		GameTooltip:AddLine(L["|cffffff00Inline Filters:|r You can easily add common search filters to your search such as rarity, level, and item type. For example '|cff99ffffarmor/leather/epic/85/i350/i377|r' will search for all leather armor of epic quality that requires level 85 and has an ilvl between 350 and 377 inclusive. Also, '|cff99ffffinferno ruby/exact|r' will display only raw inferno rubys (none of the cuts).\n"], 1, 1, 1, 1)
		GameTooltip:Show()
	end

	local searchBarFrame, parent = TSMAPI:CreateSecureChild(parent)
	searchBarFrame:Hide()

	local eb = GUI:CreateInputBox(searchBarFrame)
	eb:SetPoint("TOPLEFT", parent, "TOPLEFT", 80, -30)
	eb:SetHeight(36)
	eb:SetWidth(300)
	eb:SetScript("OnShow", eb.SetFocus)
	eb:SetScript("OnEnterPressed", OnEnterPressed)
	eb:SetScript("OnChar", OnChar)
	eb:SetScript("OnEditFocusGained", OnEditFocusGained)
	eb:SetScript("OnEditFocusLost", OnEditFocusLost)
	eb:SetScript("OnEnter", OnEnter)
	eb:SetScript("OnLeave", function() GameTooltip:Hide() end)
	eb:SetScript("OnUpdate", OnUpdate)
	searchBarFrame.editBox = eb
	
	searchBarFrame.suggestionFrame = Search:CreateSearchSuggestionFrame(searchBarFrame, parent.content)
	
	local function OnSearchClick()
		Search:StartRegularSearch(Search.searchBar.editBox:GetText())
	end
	
	local btn = GUI:CreateButton(searchBarFrame, "TSMAHTabSearchButton", "control", 1, "CENTER")
	btn:SetPoint("TOPLEFT", eb, "TOPRIGHT", 2, -10)
	btn:SetPoint("BOTTOMLEFT", eb, "BOTTOMRIGHT", 2, 8)
	btn:SetWidth(70)
	btn:SetText(SEARCH)
	btn:SetScript("OnClick", OnSearchClick)
	searchBarFrame.button = btn
	
	local function OnSavedSearchesButtonClick()
		if searchBarFrame.suggestionFrame:IsVisible() then
			searchBarFrame.suggestionFrame:Hide()
		else
			searchBarFrame.suggestionFrame:Show()
		end
	end
	
	local function OnDealfindingSearchButtonClick()
		local lists = {}
		for listName in pairs(TSM.db.profile.dealfinding) do
			tinsert(lists, listName)
		end
		Search:StartDealfindingSearch(lists)
	end
	
	local btn = GUI:CreateButton(searchBarFrame, nil, "control", 1, "CENTER")
	btn:SetPoint("TOPLEFT", eb, "TOPRIGHT", 80, -10)
	btn:SetPoint("BOTTOMLEFT", eb, "BOTTOMRIGHT", 80, 8)
	btn:SetWidth(170)
	btn:SetText(L["Show Saved Searches"])
	btn:SetScript("OnClick", OnSavedSearchesButtonClick)
	btn.tooltip = L["Show/Hide the saved searches frame. This frame shows all your recent searches as well as your shopping and dealfinding lists."]
	searchBarFrame.savedSearchesButton = btn
	
	local btn = GUI:CreateButton(searchBarFrame, nil, "control", 1, "CENTER")
	btn:SetPoint("TOPLEFT", eb, "TOPRIGHT", 260, -10)
	btn:SetPoint("BOTTOMLEFT", eb, "BOTTOMRIGHT", 260, 8)
	btn:SetWidth(150)
	btn:SetText(L["Dealfinding Search"])
	btn:SetScript("OnClick", OnDealfindingSearchButtonClick)
	btn.tooltip = L["Starts a dealfinding search which searches for all your dealfinding lists at once."]
	searchBarFrame.dealfindingSearchButton = btn
	
	searchBarFrame.Disable = function(self)
		self.isDisabled = true
		RemoveFocusAndHighlight(self.editBox)
		self.editBox:Disable()
		self.button:Disable()
		self.suggestionFrame:Hide()
	end
	searchBarFrame.Enable = function(self)
		self.isDisabled = nil
		self.editBox:Enable()
		self.button:Enable()
	end
	
	return searchBarFrame
end

function Search:CreateTopLabel(parent)
	local frame = CreateFrame("Frame", nil, parent)

	local text = frame:CreateFontString()
	text:SetPoint("BOTTOM", parent, "TOP", 0, 5)
	text:SetFontObject(GameFontNormal)
	text:SetTextColor(1, 1, 1, 1)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("BOTTOM")
	text:SetText("")
	text:SetWidth(600)
	text:SetHeight(30)
	frame.text = text
	
	return frame
end

function Search:CreateSearchST(parent)
	local events = {
		["OnClick"] = function(self, _, data, _, _, rowNum, column, st, button)
			if rowNum then
				if Search.isScanning then return true end
				
				-- they clicked on a data row
				if button == "LeftButton" then
					-- go to the page for this item
					TSM.AuctionControl:SetCurrentAuction(data[rowNum].record)
					TSMAPI:FindAuction(function() end, {itemString=data[rowNum].itemString, buyout=data[rowNum].record.buyout, count=data[rowNum].record.count})
				else
					TSMAPI:GetSTRowRightClickFunction()(self, data[rowNum].record.parent.itemLink)
				end
				st:SetSelection(rowNum)
				return true
			else
				Search:RegisterMessage("TSM_AUCTION_ST_ON_SORT", function()
						Search:UnregisterMessage("TSM_AUCTION_ST_ON_SORT")
						Search:UpdateSearchSTData()
					end)
				st:OnColumnClick(column)
			end
		end,
	}
	
	local function GetPriceColName()
		if TSMAPI:GetPricePerUnitValue() then
			return L["Price Per Item"]
		else
			return L["Price Per Stack"]
		end
	end

	local colInfo = {
		{name="Item", width=0.285},
		{name=L["Item Level"], width=0.06, align="CENTER"},
		{name=L["Auctions"], width=0.085, align="CENTER"},
		{name=L["Stack Size"], width=0.055, align="CENTER"},
		{name=L["Time Left"], width=0.115, align="CENTER"},
		{name=L["Seller"], width=0.12, align="CENTER"},
		{name=GetPriceColName(), width=0.15, align="RIGHT"},
		{name=L["% Market Value"], width=0.1, align="CENTER"},
	}

	local st = TSMAPI:CreateAuctionsST(parent, colInfo, events)
	st:Hide()
	st.expanded = {}
	st.UpdateSTData = Search.UpdateSearchSTData
	st.hasItemLevel = true
	
	local function OnPriceCBChanged()
		if not st.frame:IsVisible() then return end
		Search:UpdateSearchSTData()
		st.head.cols[7]:GetFontString():SetText(GetPriceColName())
	end
	
	st.SetPctColText = function(self, text)
		st.head.cols[8]:GetFontString():SetText(text)
	end
	
	st.head.cols[TSM.db.profile.searchDefaultSort]:Click()
	st.frame:SetScript("OnShow", function() Search:RegisterMessage("TSM_PRICE_PER_CHECKBOX_CHANGED", OnPriceCBChanged) end)
	
	return st
end



-- ------------------------------------------------ --
--				GUI Update / Util functions				 --
-- ------------------------------------------------ --

-- Updates the status label for the Search - gets called by the scan callback handler
function Search:UpdateTopLabel(page, numPages, numLeft)
	local filterNum = Search.currentSearch.num - numLeft + 1
	local temp = {(";"):split(Search.currentSearch.filter)}
	local currentFilter = "\"|cff99ffff"..(temp[filterNum]):trim().."|r\""
	Search.topLabel.text:SetFormattedText(L["Scanning page %s of %s for filter: %s"], page, numPages, currentFilter)
	return filterNum, numPages
end

-- Updates the Search ST
local defaultSortOrderPerItem = {"Percent", "ItemBuyout", "ItemDisplayedBid", "TimeLeft", "Count", "Seller", "NumAuctions", "Name"}
local defaultSortOrderPerStack = {"Percent", "Buyout", "DisplayedBid", "TimeLeft", "Count", "Seller", "NumAuctions", "Name"}
local colSortInfoPerItem = {"Name", "NumAuctions", "Count", "TimeLeft", "Seller", "ItemBuyout", "Percent"}
local colSortInfoPerStack = {"Name", "NumAuctions", "Count", "TimeLeft", "Seller", "Buyout", "Percent"}
function Search:UpdateSearchSTData()
	if not Search.searchST then return end
	
	local sortParams
	if TSMAPI:GetPricePerUnitValue() then
		sortParams = defaultSortOrderPerItem
		tinsert(sortParams, 1, colSortInfoPerItem[Search.searchST.sortInfo.col])
	else
		sortParams = defaultSortOrderPerStack
		tinsert(sortParams, 1, colSortInfoPerStack[Search.searchST.sortInfo.col])
	end

	local results = {}
	for _, auction in pairs(Search.auctions) do
		if auction.searchFlag then
			-- combine auctions with the same buyout / count / seller
			auction:PopulateCompactRecords(sortParams, Search.searchST.sortInfo.order == "asc")
			tinsert(results, auction)
		end
	end
	
	TSMAPI:SetSTData(Search.searchST, results)
end

function Search:SetGoldText(fontString)
	if GetNumAuctionItems("owner") == 0 then
		TSMAPI:CreateTimeDelay("shoppingGoldText", 0.2, function() Search:SetGoldText(fontString) end)
		return
	end

	local total = 0
	local incomingTotal = 0
	for i=1, GetNumAuctionItems("owner") do
		local count, _, _, _, _, _, _, buyoutAmount = select(3, GetAuctionItemInfo("owner", i))
		total = total + buyoutAmount
		if count == 0 then
			incomingTotal = incomingTotal + buyoutAmount
		end
	end
	fontString:SetText(format(L["Total value of your auctions: %s\nIncoming gold: %s"], TSMAPI:FormatTextMoney(total), TSMAPI:FormatTextMoney(incomingTotal)))
end