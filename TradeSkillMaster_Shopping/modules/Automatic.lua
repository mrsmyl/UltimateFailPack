local TSM = select(2, ...)
local Automatic = TSM:NewModule("Automatic", "AceEvent-3.0")
local GUI = TSMAPI:GetGUIFunctions()
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

local parentFrame
local tradeSkills = {{name="Enchanting", spellID=7411}, {name="Inscription", spellID=45357},
	{name="Jewelcrafting", spellID=25229}, {name="Alchemy", spellID=2259},
	{name="Blacksmithing", spellID=2018}, {name="Leatherworking", spellID=2108},
	{name="Tailoring", spellID=3908}, {name="Engineering", spellID=4036},
	{name="Cooking", spellID=2550}}


function Automatic:OnInitialize()
	Automatic.auctions = {}
	Automatic.items = {}
	TSMAPI:RegisterAuctionFunction("TradeSkillMaster_Shopping", Automatic, L["Crafting Mats"], L["Shop for materials required by the Crafting queue."])
end

function Automatic:Show(frame)
	Automatic.introFrame = Automatic.introFrame or Automatic:CreateIntroFrame(frame)
	Automatic.introFrame:Show()
	
	Automatic.infoFrame = Automatic.infoFrame or Automatic:CreateInfoFrame(frame)
	Automatic.infoFrame:Hide()
	
	Automatic.itemFrame = Automatic.itemFrame or Automatic:CreateItemFrame(frame)
	Automatic.itemFrame:Hide()

	parentFrame = frame
	Automatic:RegisterMessage("TSM_AUTOMATIC_SCAN_COMPLETE", "FinishedScanning")
	Automatic:RegisterMessage("TSM_UPDATE_FRAME_COLORS")
	Automatic:TSM_UPDATE_FRAME_COLORS()
end

function Automatic:Hide()
	Automatic.itemFrame:Hide()
	Automatic.introFrame:Hide()
	Automatic.infoFrame:Hide()
	TSMAPI:StopScan()
	Automatic.isSearching = nil
	Automatic:UnregisterAllMessages()
	
	TSM.Destroying:Hide()
	TSM.Search:Hide()
end

function Automatic:CreateItemFrame(parent)
	local frame, parent = TSMAPI:CreateSecureChild(parent)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	TSMAPI:RegisterForColorChanges(frame)
	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", -4, -10)
	frame:SetWidth(350)
	frame:SetHeight(300)
	frame:SetFrameLevel(parent:GetFrameLevel()+6)
	
	-- make the frame draggable
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	
	local title = frame:CreateFontString()
	title:SetFontObject(GameFontHighlight)
	title:SetTextColor(1, 1, 1, 1)
	title:SetPoint("TOP", 0, -8)
	title:SetText(L["Shopping - Crafting Mats"])
	frame.title = title
	
	frame.bar = GUI:AddHorizontalBar(frame, -25)
	
	
	local stEvents = {
		["OnClick"] = function(_, _, data, _, _, rowNum, column, st, button)
			if rowNum then
				if Automatic.isSearching then return true, TSM:Print(L["Cannot change current item while scanning."]) end
			
				-- they clicked on a data row
				if button == "LeftButton" then
					--change the current item to this one
					Automatic:SetCurrentItem(Automatic.items[rowNum], rowNum)
				end
				st:SetSelection(rowNum)
			end
			return true -- prevents the default ST OnClick handler from being called
		end,
		["OnDoubleClick"] = function() end,
		["OnEnter"] = function(_, cellFrame, data, _, _, rowNum, column, st)
			if rowNum and (column ~= 1 or not st.isShowingItemTooltip) then
				GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE")
				GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "TOPLEFT")
				GameTooltip:AddLine(L["Click to shop for this item."])
				
				GameTooltip:Show()
			end
		end,
		["OnLeave"] = function(_, _, data, _, _, rowNum, column, st)
			if rowNum and (column ~= 1 or not st.isShowingItemTooltip) then
				GameTooltip:Hide()
			end
		end,
	}

	local stCols = {
		{name="Item", width=0.54, align="LEFT"},
		{name="Need", width=0.15, align="CENTER"},
		{name="Crafting Cost", width=0.24, align="RIGHT"},
	}
	
	local function GetSTColInfo(width)
		local colInfo = CopyTable(stCols)
		for i=1, #colInfo do
			colInfo[i].width = floor(colInfo[i].width*width)
		end

		return colInfo
	end

	local st = TSMAPI:CreateScrollingTable(GetSTColInfo(frame:GetWidth()), true)
	st.frame:SetParent(frame)
	st.frame:SetPoint("TOPLEFT", 2, -60)
	st.frame:SetPoint("BOTTOMRIGHT", -2, 0)
	st.frame:SetScript("OnSizeChanged", function(_,width, height)
			st:SetDisplayCols(GetSTColInfo(width))
			st:SetDisplayRows(floor(height/18), 18)
		end)
	st:Show()
	st:SetData({})
	st.frame:GetScript("OnSizeChanged")(st.frame, st.frame:GetWidth(), st.frame:GetHeight())
	st:EnableSelection(true)
	
	local font = GameFontHighlightSmall:GetFont()
	for i, row in ipairs(st.rows) do
		row:SetHeight(18)
		if i%2 == 0 then
			local tex = row:CreateTexture()
			tex:SetPoint("TOPLEFT", 4, -2)
			tex:SetPoint("BOTTOMRIGHT", -4, 2)
			tex:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScore-Highlight")
			tex:SetTexCoord(0.017, 1, 0.083, 0.909)
			tex:SetAlpha(0.3)
			row:SetNormalTexture(tex)
		end
		for j, col in ipairs(row.cols) do
			if j == 1 then
				col.text:SetFont(font, 11)
				col.text:SetHeight(18)
			else
				col.text:SetFont(font, 10)
			end
		end
	end

	for j, col in ipairs(st.head.cols) do
		local fontString = col:GetFontString()
		fontString:SetJustifyH("CENTER")
		fontString:SetJustifyV("CENTER")
		col:SetHeight(20)

		local tex = col:CreateTexture()
		tex:SetPoint("TOPLEFT", 0, 0)
		tex:SetPoint("BOTTOMRIGHT", 0, -4)
		tex:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScore-Highlight")
		tex:SetTexCoord(0.017, 1, 0.083, 0.909)
		tex:SetAlpha(0.5)
		col:SetNormalTexture(tex)

		local tex = col:CreateTexture()
		tex:SetPoint("TOPLEFT", 0, 0)
		tex:SetPoint("BOTTOMRIGHT", 0, -4)
		tex:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		tex:SetTexCoord(0.025, 0.957, 0.087, 0.931)
		tex:SetAlpha(0.2)
		col:SetHighlightTexture(tex)
	end
	
	st.head:SetPoint("BOTTOMLEFT", st.frame, "TOPLEFT", 4, 8)
	st.head:SetPoint("BOTTOMRIGHT", st.frame, "TOPRIGHT", -4, 8)
	st.head:SetHeight(15)
	st:RegisterEvents(stEvents)
	frame.st = st
	
	return frame
end

function Automatic:CreateIntroFrame(parent)
	local professions = {}

	local function OnFrameShow(self)
		local disabled, ddList = {}, {}
		for i=1, #tradeSkills do
			local name, spellID = tradeSkills[i].name, tradeSkills[i].spellID
			local items = select(2, TSMAPI:GetData("shopping", {name}))
			if #items == 0 then
				disabled[name] = true
			end
			ddList[name] = format("%s (%s items)", GetSpellInfo(spellID), #items)
		end
		self.professionsDropdown:SetList(ddList)
		for key in pairs(ddList) do
			self.professionsDropdown:SetItemDisabled(key, disabled[key])
			self.professionsDropdown:SetItemValue(key, not disabled[key])
			professions[key] = not disabled[key]
		end
		
		local ddList = {}
		local words = {mill=L["Milling"], prospect=L["Prospecting"], disenchant=L["Disenchanting"], transform=L["Transforming"]}
		for key, value in pairs(TSM.db.global.automaticDestroyingModes) do
			ddList[key] = words[key]
		end
		self.destroyingModesDropdown:SetList(ddList)
		for key in pairs(ddList) do
			self.destroyingModesDropdown:SetItemValue(key, TSM.db.global.automaticDestroyingModes[key])
		end
	end
	
	local function OnButtonClick()
		local modes = {}
		for key, value in pairs(professions) do
			if value then
				tinsert(modes, key)
			end
		end
		Automatic:StartNewSearch(modes)
	end

	local frame, parent = TSMAPI:CreateSecureChild(parent)
	frame:SetPoint("TOPLEFT", 120, -45)
	frame:SetHeight(30)
	frame:SetPoint("TOPRIGHT", -20, -45)
	frame:Hide()
	frame:SetScript("OnShow", OnFrameShow)
	
	local dd = GUI:CreateDropdown(frame, L["Professions to Buy Materials for:"], 600, {}, {"TOPLEFT", -40, 8}, L["Select all the professions for which you would like to buy materials."])
	dd:SetCallback("OnValueChanged", function(_,_,key,value) professions[key] = value end)
	dd:SetMultiselect(true)
	frame.professionsDropdown = dd
	
	local btn = GUI:CreateButton(frame, "TSMAHTabCraftingMatsButton", "control", 1, "CENTER")
	btn:SetPoint("TOPLEFT", dd.frame, "TOPRIGHT", 40, -22)
	btn:SetPoint("BOTTOMLEFT", dd.frame, "BOTTOMRIGHT", 40, 2)
	btn:SetText(SEARCH)
	btn:SetWidth(100)
	btn:SetScript("OnClick", OnButtonClick)
	frame.button = btn
	
	local text = frame:CreateFontString()
	text:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, -20)
	text:SetFontObject(GameFontNormal)
	text:SetText("|cff99ffff"..L["Additional Options:"].."|r")
	
	local dd2 = GUI:CreateDropdown(frame, L["Destroying Modes to Use:"], 300, {}, {"TOPLEFT", parent.content, "TOPLEFT", 40, -60}, L["Here you can choose in which situations Shopping should run a destroying search rather than a regular search for the target item."])
	dd2:SetCallback("OnValueChanged", function(_,_,key,value) TSM.db.global.automaticDestroyingModes[key] = value end)
	dd2:SetMultiselect(true)
	frame.destroyingModesDropdown = dd2
	
	local cb = GUI:CreateCheckBox(frame, L["Even Stacks Only (Ore/Herbs)"], 250, {"TOPLEFT", parent.content, "TOPLEFT", 380, -80}, L["If checked, only 5/10/15/20 stacks of ore and herbs will be shown. Note that this setting is the same as the one that shows up when you run a Destroying search."])
	cb:SetValue(TSM.db.profile.evenStacks)
	cb:SetCallback("OnValueChanged", function(_,_,value) TSM.db.profile.evenStacks = value TSM.Destroying:UpdateSearchSTData() end)
	frame.evenStackCB = cb
	
	return frame
end

function Automatic:CreateInfoFrame(parent)
	local frame, parent = TSMAPI:CreateSecureChild(parent)
	frame:SetPoint("TOPLEFT", 80, -40)
	frame:SetHeight(30)
	frame:SetPoint("TOPRIGHT", -20, -40)
	frame:Hide()
	frame:SetScript("OnShow", OnFrameShow)
	
	local itemText = frame:CreateFontString()
	itemText:SetPoint("TOPLEFT")
	itemText:SetFontObject(GameFontNormal)
	itemText:SetText(L["Shopping for:"])
	itemText:SetTextColor(1, 1, 1, 1)
	frame.itemText = itemText
	
	local linkText = frame:CreateFontString()
	linkText:SetPoint("LEFT", frame.itemText, "RIGHT", 2, 0)
	linkText:SetFontObject(GameFontNormal)
	linkText:SetTextColor(1, 1, 1, 1)
	linkText:SetText("")
	frame.linkText = linkText
	
	local linkFrame = CreateFrame("Frame", nil, frame)
	linkFrame:SetAllPoints(frame.linkText)
	linkFrame:SetScript("OnEnter", function(self)
			local link = self.text:GetText()
			if link and link ~= "" then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end)
	linkFrame:SetScript("OnLeave", function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end)
	linkFrame.text = linkText
		
	local modeText = frame:CreateFontString()
	modeText:SetPoint("TOPLEFT", 0, -20)
	modeText:SetFontObject(GameFontNormal)
	modeText:SetTextColor(1, 1, 1, 1)
	modeText:SetText("")
	frame.modeText = modeText
	
	local costText = frame:CreateFontString()
	costText:SetPoint("TOPLEFT", 400, 0)
	costText:SetFontObject(GameFontNormal)
	costText:SetTextColor(1, 1, 1, 1)
	costText:SetText("")
	frame.costText = costText
	
	local quantityText = frame:CreateFontString()
	quantityText:SetPoint("TOPLEFT", 400, -20)
	quantityText:SetFontObject(GameFontNormal)
	quantityText:SetTextColor(1, 1, 1, 1)
	quantityText:SetText("")
	frame.quantityText = quantityText
	
	return frame
end

function Automatic:StartNewSearch(modes)
	local list = select(2, TSMAPI:GetData("shopping", modes))
	wipe(Automatic.items)
	
	for i, data in ipairs(list) do
		local itemString, cost
		local itemID, quantity, isVendorBought, inkID, pigPerInk = unpack(data)
		itemID = inkID or itemID
		quantity = inkID and ceil(quantity/pigPerInk) or quantity
		local itemString = TSMAPI:GetItemString(select(2, GetItemInfo(itemID)))
		local cost = TSMAPI:GetData("craftingcost", itemID, true)
		if not isVendorBought then
			tinsert(Automatic.items, {itemID=itemID, quantity=quantity, itemString=itemString, cost=cost})
		end
	end
	
	Automatic.introFrame:Hide()
	Automatic.itemFrame:Show()
	Automatic:UpdateItemSTData()
	Automatic.itemFrame.st.rows[1].cols[1]:Click()
end

function Automatic:UpdateItemSTData()
	local stData = {}
	for _, data in pairs(Automatic.items) do
		local name, link = GetItemInfo(data.itemID)
		tinsert(stData, {
				cols = {
					{
						value = link,
						args = {name, link}
					},
					{
						value = data.quantity,
					},
					{
						value = function(value) return TSMAPI:FormatTextMoney(value, nil, true) end,
						args = {data.cost},
					},
					itemString = data.itemString,
				},
			})
	end
	Automatic.itemFrame.st:SetData(stData)
end

function Automatic:SetCurrentItem(item, rowNum)
	TSM.Search:Hide()
	TSM.Destroying:Hide()

	local _, link = GetItemInfo(item.itemID)
	Automatic.infoFrame:Show()
	Automatic.infoFrame.linkText:SetText(link)
	Automatic.infoFrame.costText:SetText(L["Crafting Cost:"].." "..(TSMAPI:FormatTextMoney(item.cost, "|cff99ffff", true) or "---"))
	Automatic.infoFrame.quantityText:SetText(L["Quantity Needed:"].." |cff99ffff"..item.quantity.."|r")
	
	local destroyingFilters = {TSM.DestroyingUtil:GetFilters(item.itemID)}
	if #destroyingFilters > 0 and TSM.db.global.automaticDestroyingModes[destroyingFilters[1]] then
		-- run a destroy search
		destroyingFilters[4] = item.itemID
		TSM.Destroying:StartNewSearch(destroyingFilters, parentFrame)
		Automatic.infoFrame.modeText:SetText(L["Search Mode: |cff99ffffDestroying Search|r"])
		Automatic.searchMode = "Destroying"
	else
		-- run a regular search
		TSM.Search:StartAutomaticSearch(link, parentFrame)
		Automatic.infoFrame.modeText:SetText(L["Search Mode: |cff99ffffRegular Search|r"])
		Automatic.searchMode = "Search"
	end
	
	Automatic.currItem = item
	Automatic.isSearching = item
	Automatic.rowNum = rowNum
end

function Automatic:FinishedScanning()
	Automatic.isSearching = nil
end

function Automatic:GetAuctionData(itemString)
	return TSM[Automatic.searchMode]:GetAuctionData(itemString)
end

local function GetGemID()
	for _, data in ipairs(Automatic.items) do
		for _, gemID in ipairs(TSM.Destroying.currentSearchData.data.gems or {}) do
			if data.itemID == gemID then
				return gemID
			end
		end
	end
end

function Automatic:ProcessPurchase(itemString, numBought)
	local itemID, num, removeItem
	if Automatic.searchMode == "Destroying" then
		num = TSMAPI:GetDestroyingConversionNum(TSM.Destroying.mode, TSM.Destroying.currentSearchData.itemID, TSMAPI:GetItemID(itemString))
		itemID = TSM.Destroying.currentSearchData.itemID
		if TSM.Destroying.mode == "prospect" then
			itemID = GetGemID()
		end
	else
		num = 1
		itemID = TSMAPI:GetItemID(itemString)
	end
	
	for index, data in ipairs(Automatic.items) do
		if data.itemID == itemID then
			data.quantity = floor((data.quantity - TSMAPI:SafeDivide(numBought, num))*100+0.5)/100
			if data.quantity <= 0 then
				removeItem = index
			end
			break
		end
	end
	
	if removeItem then
		tremove(Automatic.items, removeItem)
	end
	
	Automatic:UpdateItemSTData()
	
	if removeItem then
		local nextIndex = min(#Automatic.itemFrame.st.rows, Automatic.rowNum)
		TSM.AuctionControl:HideAuctionConfirmation()
		TSM.AuctionControl:SetCurrentAuction()
		Automatic.itemFrame.st:ClearSelection()
		TSMAPI:CreateTimeDelay("automaticDoneDelay", 0.5, function()
				TSM.AuctionControl:HideAuctionConfirmation()
				TSM.AuctionControl:SetCurrentAuction()
				Automatic.itemFrame.st:ClearSelection()
				if TSM.AuctionControl:IsBuyingComplete() then
					TSMAPI:CancelFrame("automaticDoneDelay")
					Automatic.itemFrame.st.rows[nextIndex].cols[1]:Click()
				end
			end, 0.2)
		return true
	else
		Automatic.infoFrame.quantityText:SetText(L["Quantity Needed:"].." |cff99ffff"..Automatic.currItem.quantity.."|r")
	end
end

function Automatic:TSM_UPDATE_FRAME_COLORS()
	if Automatic.itemFrame then
		Automatic.itemFrame.bar.texture:SetVertexColor(TSMAPI:GetBorderColor())
	end
end