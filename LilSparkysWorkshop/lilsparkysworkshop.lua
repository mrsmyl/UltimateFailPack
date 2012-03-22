

-- LilSparky's Workshop -- Addon for WOW Trade Skill frames
-- Lilsparky of Lothar


local REV = ("119")
local LSW_VERSION = "LSW r"..REV
local LSW_VERSION_LONG = "LilSparky's Workshop r"..REV


LSWConfig = { }
LSWPrices = {value={}, valueSamples={},cost={},costSamples={}}


local defaultConfig = {
	residualValueFactor = 50,
	vendorOverride = {},
--	itemBOP = {},
	fixedPrice = {},
}


LSW = { rev = tonumber(string.match(REV,"(%d+)")) or 9999 }

itemBOP = {}


local function EasyMenu_Initialize( frame, level, menuList )
	if type(menuList)=="function" then
		menuList = menuList()
	end

	for index = 1, #menuList do
		local value = menuList[index]
		if (value.text) then
			value.index = index;
			UIDropDownMenu_AddButton( value, level );
		end
	end
end

local function EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay )
	if ( displayMode == "MENU" ) then
		menuFrame.displayMode = displayMode;
	end
	UIDropDownMenu_Initialize(menuFrame, EasyMenu_Initialize, displayMode, nil, menuList);
	ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList);
end




do
	local menuList = {}


	local tipBackDrop = {
		bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
		tile=true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 4 }
	}


	local menuInputBox = CreateFrame("Frame", nil, UIParent)

	menuInputBox:SetBackdrop(tipBackDrop)
	menuInputBox:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	menuInputBox:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)

	menuInputBox:SetHeight(40)
	menuInputBox:SetWidth(150)
	menuInputBox:Hide()

	do
		local label = menuInputBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		label:SetPoint("TOPLEFT",5,-5)
		label:SetHeight(13)
		label:SetPoint("RIGHT",-5,0)
		label:SetJustifyH("LEFT")

		menuInputBox.label = label

		local editBox = CreateFrame("EditBox",nil,menuInputBox)
		editBox:SetPoint("BOTTOMLEFT",5,5)
		editBox:SetHeight(13)
		editBox:SetPoint("RIGHT",-5,0)
		editBox:SetJustifyH("LEFT")

		editBox:SetAutoFocus(true)

		editBox:SetScript("OnEnterPressed",function(f) menuInputBox:Hide() EditBox_ClearFocus(f) menuInputBox:SetVariable(f:GetText()) end)
		editBox:SetScript("OnEscapePressed", function(f) menuInputBox:Hide() EditBox_ClearFocus(f) end)
		editBox:SetScript("OnEditFocusLost", EditBox_ClearHighlight)
		editBox:SetScript("OnEditFocusGained", EditBox_HighlightText)

		editBox:EnableMouse(true)
		editBox:SetFontObject("GameFontHighlightSmall")

		menuInputBox.editBox = editBox

		menuInputBox:SetScript("OnUpdate", function(p)
			UIDropDownMenu_StopCounting(p.button:GetParent())
		end)


		menuInputBox:SetScript("OnHide", function(p)
			p:Hide()
		end)


		menuInputBox:SetClampedToScreen(true)
	end


	local function DoTextEntry(button, option)
		local defaultText

		if option.default then
			if type(option.default) == "function" then
				defaultText = option.default(option)
			else
				defaultText = option.default
			end
		end

		menuInputBox.label:SetText(option.name)
		menuInputBox.editBox:SetText(option.optionTable[option.variable] or defaultText or "")
		menuInputBox:Show()
		menuInputBox:SetPoint("TOPLEFT",button,"TOPRIGHT",10,0)

		menuInputBox.option = option
		menuInputBox.button = button


--		UIDropDownMenu_StopCounting(button:GetParent())
--		menuInputBox:SetParent(button)
	end


	function menuInputBox:SetVariable(value)
		local option = self.option

		option.optionTable[option.variable] = value

		if option.callback then
			option.callback(button, option)
		end

		local defaultText

		if option.default then
			if type(option.default) == "function" then
				defaultText = option.default(option)
			else
				defaultText = option.default
			end
		end

		option.entry.text = string.format(option.formatString, option.name, option.optionTable[option.variable] or defaultText or "--")
		self.button:SetText(option.entry.text)
	end



	local function RegisterToggle(menu, name, optionTable, variable, callback)
		local o = {}

		o.name = name
		o.optionTable = optionTable
		o.variable = variable
		o.type = "toggle"
		o.callback = callback

		table.insert(menu.options, o)
	end


	local function RegisterValue(menu, name, formatString, optionTable, variable, callback, default)
		local o = {}

		o.name = name
		o.optionTable = optionTable
		o.variable = variable
		o.type = "value"
		o.callback = callback
		o.formatString = formatString
		o.default = default

		table.insert(menu.options, o)
	end




	local function GenerateMenuTable(menu)
		local menuTable = {}

		for i = 1, #menu.options do
			local o = menu.options[i]

			if o.type == "toggle" then
				local button = {
					text = o.name,
					func = function(b)
						o.optionTable[o.variable] = not o.optionTable[o.variable]
						menuTable[i].checked = o.optionTable[o.variable]
						o.callback(b, o)
					end,
					value = i,
					checked = o.optionTable[o.variable],
				}
				o.entry = button

				table.insert(menuTable, button)
			elseif o.type == "value" then
				local defaultText

				if o.default then
					if type(o.default) == "function" then
						defaultText = o.default(o)
					else
						defaultText = o.default
					end
				end

				local button = {
					text = string.format(o.formatString, o.name, o.optionTable[o.variable] or defaultText or "--"),
					arg1 = o,
					func = DoTextEntry,
					keepShownOnClick = true,
					value = i,
				}

				button.notCheckable = true
				button.isNotRadio = true

				o.entry = button

				table.insert(menuTable, button)
			elseif o.type == "radioButton" then
				local button = {
					text = o.name,
					func = function(b)
						o.optionTable[o.variable] = o.value

						local p = o.menuParent

						p.entry.text = p.name..o.name
						if p.selected then
							p.subMenu.options[p.selected].entry.checked = false
						end
						p.selected = i

						menuTable[i].checked = true

						o.callback(b, o)
					end,
					value = i,
					checked = (o.optionTable[o.variable] == o.value),
				}
				o.entry = button

				table.insert(menuTable, button)
			elseif o.type == "subMenu" then
				local subTable = o.subMenu:GenerateMenuTable()

				local button = {
					text = o.text,
					menuList = subTable,
					value = i,
					arg1 = o,
					hasArrow = true,
					notCheckable = true,
					isNotRadio = true,
				}
				o.entry = button

				table.insert(menuTable, button)
			end
		end

		return menuTable
	end


	local function RegisterSubMenu(menu, name, optionTable, variable, subMenuEntries, callback, default)
		local subMenu = LSW:RegisterMenu(name.."-subMenu")
		local m = {}
		local setting = subMenuEntries[optionTable[variable]] or optionTable[variable] or default or "???"
		local selected

		for value, name in pairs(subMenuEntries) do
			local o = {}

			o.name = name
			o.optionTable = optionTable
			o.variable = variable
			o.type = "radioButton"
			o.value = value
			o.menuParent = m
			o.callback = callback
			o.default = default

			table.insert(subMenu.options, o)

			if setting == name then
				selected = #subMenu.options
			end
		end

		m.text = name..setting
		m.name = name
		m.optionTable = optionTable
		m.variable = variable
		m.type = "subMenu"
		m.subMenu = subMenu
		m.selected = selected


		table.insert(menu.options, m)
	end



	function LSW:RegisterMenu(menuName)
		menuList[menuName] = {}
		menuList[menuName].options = {}

		menuList[menuName].name = menuName

		menuList[menuName].GenerateMenuTable = GenerateMenuTable
		menuList[menuName].RegisterToggle = RegisterToggle
		menuList[menuName].RegisterSubMenu = RegisterSubMenu
		menuList[menuName].RegisterValue = RegisterValue

		return menuList[menuName]
	end
end


do
	local algorithms = {}
	local algorithmsIndex = {}

	local defaultAlgorithm

	function LSW:RegisterAlgorithm(name, func)
		if name and func then

			local a = {}
			a.name = name
			a.func = func

			local i = algorithmsIndex[name]

			if i then
				algorithms[i] = a
			else
				table.insert(algorithms, a)

				algorithmsIndex[name] = #algorithms
			end

			if not defaultAlgorithm then
				defaultAlgorithm = a
			end

			return a
		end
	end

	function LSW:GetAlgorithms()
		return algorithms, algorithmsIndex
	end

	function LSW:GetAlgorithmFunction(name)
		if name then
			local index = algorithmsIndex[name]
			if index then
				return algorithms[index].func, algorithms[index].name
			end
		end

		if defaultAlgorithm then
			return defaultAlgorithm.func, defaultAlgorithm.name
		else
			return function () return 0 end, "no auction support"
		end
	end


	function LSW:SetDefaultAlgorithm(algo)
		if algo and algo.fun and algo.name then
			defaultAlgorithm = algo
		end
	end

	function LSW:GetAuctionValue(link, a)
		return algorithms[algorithmsIndex[a]].func(link)
	end


	function LSW:GenerateAlgorithmMenu(checkedName, callback)
		local menu = {}
		local oldButton

		for i = 1, #algorithms do
			local name = algorithms[i].name


			local button = {
				text = name,
				func = function(b)
					if oldButton then
						oldButton.checked = false
					end
					menu[i].checked = true
					oldButton = menu[i]
					callback(b, name)
				end,
				value = i,
				checked = (checkedName == name),
			}

			table.insert(menu, button)

			if checkedName == name then
				oldButton = menu[i]
			end
		end

		return menu
	end

end


local progressBar = {}

do
	function progressBar:Init(parentFrame, text)
		if not progressBar.frame then
			progressBar.frame = CreateFrame("Frame", nil, parentFrame)

			progressBar.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
												edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
												tile = true, tileSize = 16, edgeSize = 16,
												insets = { left = 4, right = 4, top = 4, bottom = 4 }});
			progressBar.frame:SetBackdropColor(0,0,0,1);


			progressBar.frame:SetFrameStrata("DIALOG")

			progressBar.frame:SetWidth(310)
			progressBar.frame:SetHeight(30)


			progressBar.fg = progressBar.frame:CreateTexture()
			progressBar.fg:SetTexture(.2,.7,.2,.5)
			progressBar.fg:SetPoint("LEFT",progressBar.frame,"LEFT",5,0)
			progressBar.fg:SetHeight(20)
			progressBar.fg:SetWidth(300)

			progressBar.textLeft = progressBar.frame:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
			progressBar.textLeft:SetText(text)
			progressBar.textLeft:SetPoint("LEFT",10,0)

			progressBar.textRight = progressBar.frame:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
	--		progressBar.textRight:SetText("0%")
			progressBar.textRight:SetPoint("RIGHT",-10,0)
		end

		progressBar.frame:SetPoint("BOTTOM",parentFrame,"TOP",0,0)
		progressBar.isShown = false
		progressBar.initTime = GetTime()
	end


	function progressBar:Show(progress, text)
		if progressBar.frame then
--			progressBar.frame:Show()
--			if not LSW:GetTimer("showProgressBar") and not progressBar.frame:IsVisible() then
--				LSW:CreateTimer("showProgressBar", 0.25, function() progressBar.frame:Show() end)
--			end

			if not progressBar.isShown and progress > 0.1 then			-- if the bar is not currently shown and it's at least 10% complete then decide whether to show the bar
				local elapsed = GetTime() - progressBar.initTime

				if (elapsed / progress) > 1 then						-- only show if the expected time to complete is longer than 1 second
					progressBar.isShown = true
					progressBar.frame:Show()
				end
			end

			progressBar.textRight:SetFormattedText("%d%%", progress*100)
			progressBar.fg:SetWidth(300*progress)

			if text then
				progressBar.textLeft:SetText(text)
			end
		end
	end

	function progressBar:Hide()
		if progressBar.frame then
--			LSW:DeleteTimer("showProgressBar")

			progressBar.isShown = false
			progressBar.frame:Hide()
		end
	end
end


do
	LSW.version = LSW_VERSION

	local PROCESS_COLOR_HEX = "|cffa040ff"

	local frameSupportList = {}
	local pricingSupportList = {}

	local supportMenuList = {}


	local periodicTable


	local timerList = {}

	local pricingInitialized = false;

	local LSW_MINIMUM_REAGENT_AUCTIONS = 10
	local LSW_MINIMUM_ITEM_AUCTIONS = 1

	local ENCHANT_ID="?"		-- enchants have no item fate

	local itemFateColor={
		["d"]="ff008000",
		["a"]="ff909050",
		["v"]="ff206080",
		["?"]="ff800000",
	}

--	local LSW_itemFateColor[LSW_ENCHANT_ID]="ffffffff";
	local priceDataSync = 1
	local recipeCache={ names = {}, results = {}, reagents = {}, canCraft = {}, enchants = {}, sync = {}, cost = {} }
	local itemCache={}

	LSW.recipeCache = recipeCache
	LSW.itemCache = itemCache


	local globalFate = 0
	local globalFateMax = 2
	local valueAsPercent = false 	-- display % for values

	local globalSource = 0

	local currentSkillLevel = 1

	local curentRecipe

	-- these could certainly be made language specific if needed
	local itemFateList={"a", "v", "d"}

	local fateString={["a"]="Auction", ["v"]="Vendor", ["d"]="Disenchant"}

--	local LSWTooltip = CreateFrame("GameTooltip", "LSWTooltipFrame", UIParent, "GameTooltipTemplate")
--			LSWTooltip:SetScale(0.8)
	local LSWTooltip = GameTooltip


	local BOP_STRING = "|cffff0000-BOP-|r"
	local NO_DE_STRING = "|cffff0000NO DE|r"


	local aucAlgorithm = "Market"

	local aucEngines = {}


	local buttonValueList = {}
	local buttonCostList = {}
	local buttonLevelList = {}

	local LSWMenuFrame = CreateFrame("Frame", "LSWMenuFrame", UIParent, "UIDropDownMenuTemplate")

	local profitMenu = {}

	local valueMenu =
	{
	}

	local COST_BASIS_RESALE = "resale"
	local COST_BASIS_PURCHASE = "purchase"
	local COST_BASIS_SKILLUP = "skillup"

	local costBasisMenu

	local costMenu =
	{
	}


	local itemMenuTable = {}
	local itemMenu = {}


	local function flushAndRedraw(button, opt)
		CloseDropDownMenus()
		LSW:FlushPriceData()
	end

	local function redraw(button, opt)
		CloseDropDownMenus()
		LSW:CreateTimer("updateData-Redraw", 0.05, LSW.UpdateData)
	end

	local function convertToCopper(button, opt)
		local valNum = tonumber(opt.optionTable[opt.variable])

		opt.optionTable[opt.variable] = valNum

		flushAndRedraw(button, opt)
	end


	local function assignOverride(button, opt)
		if LSWConfig.vendorOverride[opt.variable] == "nil" then
			LSWConfig.vendorOverride[opt.variable] = nil
		end

		flushAndRedraw(button, opt)
	end


	local function DeleteOverride(menuEntry, opt)
		LSWConfig.vendorOverride[opt.variable] = nil
	end


	local function GetItemCost(option)
		local itemID = option.variable

		return LSW:GetItemCost(itemID)/10000
	end


	local function GenerateItemMenu(itemID)
		if not itemMenuTable[itemID] then
			local menu = LSW:RegisterMenu(GetItemInfo(itemID))

			local b = menu:RegisterSubMenu("Availability: ", LSWConfig.vendorOverride, itemID, {[true] = "|cff206080Vendor", [false] = "|cff909050Auction", ["nil"] = "Default"}, assignOverride, "Default")

			local b = menu:RegisterValue("Fixed Price", "%s: |cffc0ff80%sg", LSWConfig.fixedPrice, itemID, convertToCopper, GetItemCost)



			itemMenu[itemID] = menu

			itemMenuTable[itemID] = menu:GenerateMenuTable()
		end

		itemMenuTable[itemID][1].notCheckable = false

		if LSWConfig.vendorOverride[itemID] ~= nil then
--[[
			if LSWConfig.vendorOverride[itemID] then
				itemMenuTable[itemID][1].text = "Availability: |cff206080Vendor"
			else
				itemMenuTable[itemID][1].text = "Availability: |cff909050Auction"
			end
]]
			itemMenuTable[itemID][1].func = nil
			itemMenuTable[itemID][1].checked = true
		else
--			itemMenuTable[itemID][1].text = "Adjust Item Availabilty"
			itemMenuTable[itemID][1].func = nil
			itemMenuTable[itemID][1].checked = false
		end


		itemMenuTable[itemID][2].notCheckable = nil
		itemMenuTable[itemID][2].checked = LSWConfig.fixedPrice[itemID] ~= nil
	end



	local function GenerateReagentOverrideMenu()
		local reagentList = recipeCache.reagents[currentRecipe]

		local menu = {}

		for itemID in pairs(reagentList) do

			GenerateItemMenu(itemID)

			local button = {
				text = GetItemInfo(itemID),
				menuList = itemMenuTable[itemID],
				hasArrow = true,
				notCheckable = true,
			}

			table.insert(menu, button)
		end

		return menu
	end





	function LSW:ChatMessage(msg)
		DEFAULT_CHAT_FRAME:AddMessage("|cff80d060"..(msg or "nil"));
	end

	function LSW:ErrorMessage(msg)
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000"..(msg or "nil"));
	end

	function LSW:DebugMessage(flag, msg)
		if flag then
			DEFAULT_CHAT_FRAME:AddMessage("|cfff0f030"..(msg or "nil"))
		end
	end


	function LSW:FindID(link)
		if not link then return end

		local id = string.match(link,"item:([%-%d]+)") or string.match(link,"enchant:([%-%d]+)") or string.match(link,"spell:([%-%d]+)")

		return tonumber(id)
	end


	function LSW:QueryServerInfo(link)
		local id = self:FindID(link);

		if (not id) then
			id = self:FindID(link)

			if ( id) then
				id = "e"..id
			end
		end

		if (id and not self.linkCache[id]) then
			self.linkCache[id] = true;


			if (not GetItemInfo(link)) then
				self:ErrorMessage("no local cache info for "..link);
	--			GameTooltip:SetHyperlink(link);
			end
		end
	end


	function LSW:FormatMoney(moneyString,hilight)
		if not moneyString then
			return nil, "?"
		end
		local neg

		local money = tonumber(moneyString)


		if (money < 0) then
--			return "   --"
			neg = true
			money = -money
		end

		local GSC_GOLD = "ff807000"
		local GSC_SILVER = "ff808080"
		local GSC_COPPER = "ff643016"

		if (hilight) then
			GSC_GOLD="ffffd100"
			GSC_SILVER="ffe6e6e6"
			GSC_COPPER="ffc8602c"
		end

		local g, s, c;
		local digits = 0

		g = math.floor(money/10000);
		s = math.fmod(math.floor(money/100),100);
		c = math.fmod(money,100);


		digits = math.floor(math.log10(money)+1)

		if neg then
			if ( digits < 3 ) then
				gsc = string.format("  |c%s%3d|r",  GSC_COPPER, -c);
			elseif ( digits < 4 ) then
				gsc = string.format("|c%s%2d |c%s%02d|r", GSC_SILVER, -s, GSC_COPPER, c)
			elseif ( digits < 6 ) then
				gsc = string.format("|c%s%2d |c%s%02d|r", GSC_GOLD, -g, GSC_SILVER, s)
			elseif ( digits < 8 ) then
				gsc = string.format("|c%s%5d|r", GSC_GOLD, -g)
			else
				gsc = string.format("|c%s%2.1fk|r", GSC_GOLD, -g/1000)
			end

			return gsc
		else
			if ( digits < 3 ) then
				gsc = string.format("   |c%s%2d|r",  GSC_COPPER, c);
			elseif ( digits < 5 ) then
				gsc = string.format("|c%s%2d|r |c%s%02d|r", GSC_SILVER, s, GSC_COPPER, c)
			elseif ( digits < 7 ) then
				gsc = string.format("|c%s%2d|r |c%s%02d|r", GSC_GOLD, g, GSC_SILVER, s)
			elseif ( digits < 9 ) then
				gsc = string.format("|c%s%5d|r", GSC_GOLD, g)
			else
				gsc = string.format("|c%s%2.1fk|r", GSC_GOLD, g/1000)
			end

			return gsc
		end
	end


	function LSW:GetTradeSkillData(id)
		local skillName, skillType = GetTradeSkillInfo(id)
		local itemLink = GetTradeSkillItemLink(id)
		local recipeLink = GetTradeSkillRecipeLink(id)

		local itemID = LSW:FindID(itemLink)
		local recipeID = LSW:FindID(recipeLink)

		if itemID and recipeID then
			local scroll = LSW.scrollData[recipeID]

			if scroll then
				itemID = scroll					-- for enchants, the item created is a scroll

--				scrollVellum = 38682 					-- was scroll.vellumID but as of 4.0.1, there are no longer different vellum types
			else
				if itemID == recipeID then
					itemID = -recipeID
				end
			end
		end

		return skillName, skillType, itemLink, recipeLink, itemID, recipeID
	end


	local function itemBOPCheck(itemID)
		if not itemID or itemID<0 then
			return
		end

		if itemBOP[itemID] then
			return itemBOP[itemID]
		end

		local tooltip = LSWParsingTooltip
		local bop = false

		if tooltip == nil then
			tooltip = CreateFrame("GameTooltip", "LSWParsingTooltip", ANCHOR_NONE, "GameTooltipTemplate")
			tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		end

		tooltip:SetHyperlink("item:"..itemID)

		local tiplines = tooltip:NumLines()

		for i=1, tiplines, 1 do
			local lineText = string.lower(_G["LSWParsingTooltipTextLeft"..i]:GetText() or " ")

			if (string.find(lineText, "binds when picked up")) then
				bop = true
				break
			end
		end

		itemBOP[itemID] = bop

		return bop
	end




	local function InitializePricing()
		globalFateMax = 2

		local function flushAndRedraw(button, opt)
			CloseDropDownMenus()
			LSW:FlushPriceData()
		end

		local function redraw(button, opt)
			CloseDropDownMenus()
			LSW:CreateTimer("updateData-Redraw", 0.05, LSW.UpdateData)
		end

		local function convertToNumber(button, opt)
			local valNum = tonumber(opt.optionTable[opt.variable]) or 0

			opt.optionTable[opt.variable] = valNum

			flushAndRedraw(button, opt)
		end

		if periodicTable and not LSW.vendorAvailability then

			LSW.vendorAvailability = function(itemID)

				if itemID > 0 then
					if periodicTable:ItemInSet(itemID,"Tradeskill.Mat.BySource.Vendor") then
						return true
					end
				end

				return false
			end
		end


		local optionsMenu = LSW:RegisterMenu("Display Options")

		optionsMenu:RegisterToggle("Show Value as Percent", LSWConfig, "valueAsPercent", redraw)
		optionsMenu:RegisterToggle("Single Column", LSWConfig, "singleColumn", redraw)
		optionsMenu:RegisterToggle("Show Item Levels", LSWConfig, "showLevel", redraw)

		local optionsMenuTable = optionsMenu:GenerateMenuTable()

		if #optionsMenuTable>0 then
			local button = { text = optionsMenu.name, menuList = optionsMenuTable, hasArrow = true, notCheckable = true }
			table.insert(costMenu, button)
			table.insert(valueMenu, button)
			table.insert(profitMenu, button)
		end




		local costBasisMenu = LSW:RegisterMenu("Cost Basis Options")

		costBasisMenu:RegisterSubMenu("Cost Basis: ", LSWConfig, "costBasis", {[COST_BASIS_RESALE] = "Resale Value", [COST_BASIS_PURCHASE] = "Purchase Cost"}, flushAndRedraw)
		costBasisMenu:RegisterSubMenu("Residual Material Value: ", LSWConfig, "residualPricing", {[COST_BASIS_RESALE] = "Resale Value", [COST_BASIS_PURCHASE] = "Purchase Cost"}, flushAndRedraw)
		costBasisMenu:RegisterValue("Residual Value Factor", "%s: |cffc0ff80%s%%", LSWConfig, "residualValueFactor", convertToNumber)
		costBasisMenu:RegisterToggle("Always Craft", LSWConfig, "forceCraft", flushAndRedraw)
		costBasisMenu:RegisterToggle("Personal Craftability Only", LSWConfig, "personalCraftability", flushAndRedraw)
		costBasisMenu:RegisterToggle("Add Vellum Costs For Scrolls", LSWConfig, "addVellumCost", flushAndRedraw)

		if periodicTable then
			costBasisMenu:RegisterToggle("Factor Skill Up%", LSWConfig, "factorSkillUp", redraw)
		end

		local costBasisMenuTable = costBasisMenu:GenerateMenuTable()


		if #costBasisMenuTable>0 then
			local button = { text = costBasisMenu.name, menuList = costBasisMenuTable, hasArrow = true, notCheckable = true }
			table.insert(costMenu, button)

			table.insert(profitMenu, button)
		end

		local reagentOverrides = LSW:RegisterMenu("Reagent Cost Overrides")

		local button = { text = "Reagent Cost Overrides", menuList = GenerateReagentOverrideMenu, hasArrow = true, notCheckable = true }
		table.insert(costMenu, button)

		table.insert(profitMenu, button)



		for menuName, menuTable in pairs(supportMenuList) do
			if #menuTable>0 then
				local button = { text = menuName.." Options", menuList = menuTable, hasArrow = true, notCheckable = true }
				table.insert(costMenu, button)
				table.insert(valueMenu, button)
				table.insert(profitMenu, button)
			end
		end


		local algorithms, algorithmsIndex = LSW:GetAlgorithms()
		local costName, valueName

		LSW.auctionCost, costName = LSW:GetAlgorithmFunction(LSWConfig.costAlgorithm)
		LSW.auctionValue, valueName = LSW:GetAlgorithmFunction(LSWConfig.valueAlgorithm)






		local i = #valueMenu + 1
		local j = #profitMenu + 1

		local temp = LSW:GenerateAlgorithmMenu(valueName, function(button, algo)
			valueMenu[i].text = "Value Module: "..algo
			profitMenu[j].text = "Value Module: "..algo

			LSWConfig.valueAlgorithm = algo
			LSW.auctionValue = LSW:GetAlgorithmFunction(algo)
			CloseDropDownMenus()
			LSW:FlushPriceData()
		end)

		table.insert(valueMenu,{ text = "Value Module: "..valueName, menuList = temp, hasArrow = true, notCheckable = true  })
		table.insert(profitMenu, { text = "Value Module: "..valueName, menuList = temp, hasArrow = true, notCheckable = true  })


		local i = #costMenu + 1
		local j = #profitMenu + 1

		local temp = LSW:GenerateAlgorithmMenu(costName, function(button, algo)
			costMenu[i].text = "Cost Module: "..algo
			profitMenu[j].text = "Cost Module: "..algo

			LSWConfig.costAlgorithm = algo
			LSW.auctionCost = LSW:GetAlgorithmFunction(algo)
			CloseDropDownMenus()
			LSW:FlushPriceData()
		end)

		table.insert(costMenu,{ text = "Cost Module: "..costName, menuList = temp, hasArrow = true, notCheckable = true })
		table.insert(profitMenu, { text = "Cost Module: "..costName, menuList = temp, hasArrow = true, notCheckable = true  })







		if LSW.getDisenchantValue then
			globalFateMax = 3
		end


		return true
	end


	local function AddToItemCache(itemID, recipeID, numMade)
--LSW:ChatMessage("add item "..tostring(itemID))
		if itemID and not itemCache[itemID] then
			itemCache[itemID] = {}


			itemCache[itemID].vendorCost = LSW.vendorCost(itemID) or 0

			itemCache[itemID].vendorValue = LSW.vendorValue(itemID) or 0

-- TODO: add canCraft to de results
			if LSW.getDisenchantResults then
				local deTable = LSW.getDisenchantResults(itemID)

				if deTable then
					itemCache[itemID].deTable = deTable

					for reagentID, count in pairs(deTable) do
						local cache = AddToItemCache(reagentID)

						if not cache.craftSource then
							cache.craftSource = {}
						end

						cache.craftSource[-itemID] = count


	--					recipeCache[-itemID] = {}

						recipeCache.names[-itemID] = "Disenchant "..(GetItemInfo(itemID) or "item:"..itemID)

						recipeCache.results[-itemID] = deTable

						if recipeCache.reagents[recipeID] then										-- if item is craftable, copy the reagents to the de reagents otherwise just stuff in the itemID as the sole reagent
							recipeCache.reagents[-itemID] = recipeCache.reagents[recipeID]
						else
							recipeCache.reagents[-itemID] = { [itemID] = 1 }
						end
					end

					local itemName, itemLink, itemRarity, itemLevel  = GetItemInfo(itemID)
					local reqLevel = 1

					if itemLevel >= 21 and itemLevel <= 60 then
						reqLevel = (math.ceil(itemLevel/5)-4) * 25
					else
						if itemRarity < 5 then
							if itemLevel < 100 then
								reqLevel = 225
							elseif itemLevel < 130 then
								reqLevel = 275
							elseif itemLevel < 154 then
								reqLevel = 325
							else
								reqLevel = 350
							end
						else
							if itemLevel < 90 then
								reqLevel = 225
							elseif itemLevel < 130 then
								reqLevel = 300
							elseif itemLevel < 154 then
								reqLevel = 325
							elseif itemLevel < 200 then
								reqLevel = 350
							end
						end
					end

					recipeCache.canCraft[-itemID] = { "playerDisenchantLevel", reqLevel }
				end
			end

			itemCache[itemID].BOP = itemBOPCheck(itemID)
		end

		if recipeID then
			if not itemCache[itemID].craftSource then
				itemCache[itemID].craftSource = {}
			end

			itemCache[itemID].craftSource[recipeID] = numMade or 1
		end

		return itemCache[itemID]
	end


	function LSW:AddRecipe(recipeID, name, resultsTable, reagentsTable, canCraft)
--		local recipe = {}

		recipeCache.results[recipeID] = resultsTable

		for itemID, count in pairs(resultsTable) do
			local item = AddToItemCache(itemID, recipeID, count)
			item.canCraft = canCraft
		end

		recipeCache.reagents[recipeID] = reagentsTable
		for itemID, count in pairs(reagentsTable) do
			AddToItemCache(itemID)
		end

		recipeCache.names[recipeID] = name

--		recipeCache[recipeID] = recipe
	end


	local function SetSecondaryLevels()
		if not tradeLinked then
			local spellLink, tradeLink = GetSpellLink(7411)			-- enchanting

			if tradeLink then
				local level = string.match(tradeLink, "trade:%d+:(%d+)")

				LSW.playerDisenchantLevel = tonumber(level)
			end

			local spellLink, tradeLink = GetSpellLink(25229)		-- jewelcrafting

			if tradeLink then
				local level = string.match(tradeLink,"trade:%d+:(%d+)")

				LSW.playerProspectLevel = tonumber(level)
			end

			local spellLink, tradeLink = GetSpellLink(45357)		-- inscription

			if tradeLink then
				local level = string.match(tradeLink,"trade:%d+:(%d+)")

				LSW.playerMillLevel = tonumber(level)
			end
		end
	end



	local function UpdateRecipeCache()
		local numSkills = GetNumTradeSkills()
		local hasNil
		local tradeLinked = IsTradeSkillLinked()

		SetSecondaryLevels()

		for i=1, numSkills do
			local name, skillType = GetTradeSkillInfo(i)

			if skillType ~= "header" then
				local itemLink = GetTradeSkillItemLink(i)
				local itemID = LSW:FindID(itemLink)
				local scrollVellum

				local recipeLink = GetTradeSkillRecipeLink(i)
				local recipeID = LSW:FindID(recipeLink)

				if not recipeID then
					hasNil = true
				else
					if itemID == recipeID then
						local scroll = LSW.scrollData[recipeID]

						if scroll then
							itemID = scroll					-- for enchants, the item created is a scroll
							scrollVellum = 38682
						else
							itemID = -recipeID
						end
					end
				end



				if recipeID and (not recipeCache.results[recipeID]) then

					if itemID then
						local min, max = GetTradeSkillNumMade(i)

--						recipeCache[recipeID] = {}

						recipeCache.results[recipeID] = {[itemID] = (min+max)/2}

						recipeCache.reagents[recipeID] = {}

						if scrollVellum then
							recipeCache.enchants[recipeID] = -recipeID
						end

						for j=1,GetTradeSkillNumReagents(i) do
							local _,_,count = GetTradeSkillReagentInfo(i,j)
							local itemLink = GetTradeSkillReagentItemLink(i,j)
	--LSW:ChatMessage("recipe "..tostring(recipeLink).." reagent "..tostring(itemLink))

							local itemID = LSW:FindID(itemLink)

							if itemID then
								recipeCache.reagents[recipeID][itemID] = count
								AddToItemCache(itemID)
							else
								recipeCache.results[recipeID] = nil
								hasNil = true
								i=numSkills
								break
							end
						end

						AddToItemCache(itemID, recipeID, (min+max)/2)

						if not tradeLinked then
							itemCache[itemID].canCraft = true
						end
					else
						recipeCache.results[recipeID] = nil
						hasNil = true
						i=numSkills
						break
					end
				end

				if scrollVellum and recipeID then
					AddToItemCache(scrollVellum)
					if LSWConfig.addVellumCost then
						recipeCache.reagents[recipeID][scrollVellum] = 1
					else
						recipeCache.reagents[recipeID][scrollVellum] = nil
					end
				end
			end
		end

		if hasNil then
			LSW:CreateTimer("updateData-NilReturned", 1.0, LSW.UpdateData)
		end
	end


	local function UpdateItemValue(itemID)
		local cache = itemCache[itemID]

		if cache then
--			local _, itemLink = GetItemInfo(itemID)

			if cache.syncValue ~= priceDataSync then
				cache.syncValue = priceDataSync

				if not cache.BOP then
					cache.auctionValue, cache.auctionValueCount = LSW.auctionValue(itemID)
				end

				if not cache.auctionValue then
					cache.auctionValue, cache.auctionValueCount = 0, 0
				end

				cache.disenchantValue = (LSW.getDisenchantValue and LSW.getDisenchantValue(itemID))

				local a,d,v = cache.auctionValue, cache.disenchantValue or 0, cache.vendorValue

				if d > a then
					if d > v then
						cache.bestValue = d
						cache.fate = "d"
					else
						cache.bestValue = v
						cache.fate = "v"
					end
				else
					if a > v then
						cache.bestValue = a
						cache.fate = "a"
					else
						cache.bestValue = v
						cache.fate = "v"
					end
				end
			end
		end
	end



	local function UpdateItemCost(itemID)
		local cache = itemCache[itemID]
		local spam

		if cache then
			if LSWConfig.fixedPrice[itemID] then
				cache.bestCost = LSWConfig.fixedPrice[itemID]*10000
				cache.source = "f"
			elseif cache.syncCost ~= priceDataSync then
				cache.syncCost = priceDataSync

				if cache.BOP ~= true then
					cache.auctionCost, cache.auctionCostCount = LSW.auctionCost(itemID)
				end

--LSW:DebugMessage(spam, "can craft? "..tostring(cache.canCraft))

				local bestCost
				local source = "?"

				local itemIsVendorItem = LSW.vendorAvailability and LSW.vendorAvailability(itemID)

				if LSWConfig.vendorOverride[itemID]~=nil then
					itemIsVendorItem = LSWConfig.vendorOverride[itemID]
				end

				if LSWConfig.costBasis == COST_BASIS_PURCHASE then									-- best = least money
					if itemIsVendorItem then
						if not bestCost or (cache.vendorCost and bestCost > cache.vendorCost) then
							bestCost = cache.vendorCost
							if bestCost then
								source = "v"
							end
						end
					end

					if not bestCost or (cache.auctionCost and bestCost > cache.auctionCost) then
						bestCost = cache.auctionCost
						if bestCost then
							source = "a"
						end
					end
				else																				-- best = most money
					if itemIsVendorItem then														-- if item comes from vendor, then figure you need to buy it
						if not bestCost or (cache.vendorCost and bestCost < cache.vendorCost) then
							bestCost = cache.vendorCost
							if bestCost then
								source = "v"
							end
						end
					end

					if not itemIsVendorItem then														-- if it's not a vendor item, then figure you can at least sell it if there's no ah data
						if not bestCost or (cache.vendorValue and bestCost < cache.vendorValue) then
							bestCost = cache.vendorValue
							if bestCost then
								source = "v"
							end
						end

						if not bestCost or (cache.auctionCost and bestCost < cache.auctionCost) then
							bestCost = cache.auctionCost
							if bestCost then
								source = "a"
							end
						end
					end
				end

				cache.source = source
				cache.bestCost = bestCost or 0


				local canCraft = cache.canCraft and (type(cache.canCraft) ~= "table" or (LSW[cache.canCraft[1]] >= cache.canCraft[2]))

				if (not LSWConfig.personalCraftability or canCraft) and (LSWConfig.costBasis == COST_BASIS_PURCHASE or LSWConfig.forceCraft) and cache.craftSource then
					local bestCraftCost
					local bestCraftID
					local bestCraftResidual

--LSW:DebugMessage(spam, "crafting check for "..(itemLink or itemID))

					for recipeID, numMade in pairs(cache.craftSource) do
						if numMade > .1 then								-- don't chase rare results or we'll end up having 100's of crafts to be made

--LSW:DebugMessage(spam, "recipe "..(recipeCache.names[recipeID] or GetSpellLink(recipeID) or "no spell").." yields "..numMade)

							local totalCost = 0
							local totalValue = 0
							local recursive


							if recipeCache.results[recipeID] then
								for subItemID, numCrafted in pairs(recipeCache.results[recipeID]) do				-- the recipe might also produce other items so consider them as residual value
									if subItemID ~= itemID then
										if LSWConfig.residualPricing == COST_BASIS_RESALE then
											UpdateItemValue(subItemID)

											local residualValue = (itemCache[subItemID].bestValue or 0) * numCrafted * (LSWConfig.residualValueFactor / 100)

											totalValue = totalValue + residualValue
										else
											UpdateItemCost(subItemID)

											local residualValue = (itemCache[subItemID].bestCost or 0) * numCrafted * (LSWConfig.residualValueFactor / 100)
											totalValue = totalValue + residualValue
										end
	--									UpdateItemValue(subItemID)
	--									totalValue = totalValue + (itemCache[subItemID].bestValue or 0) * numCrafted			-- maybe should use bestCost here?
									end
								end
							end

							if recipeCache.reagents[recipeID] then
								for reagentID, numNeeded in pairs(recipeCache.reagents[recipeID]) do					-- add up the cost of all materials (recursive so avoid loops by breaking when current price is nil)
									UpdateItemCost(reagentID)

									if itemCache[reagentID].bestCost and LSWConfig.costBasis == COST_BASIS_PURCHASE then
										totalCost = totalCost + itemCache[reagentID].bestCost * numNeeded
									else
										recursive = true
										break
									end
								end
							end

							if not recursive and (not bestCraftCost or bestCraftCost > ((totalCost-totalValue)/numMade)) then
								bestCraftCost = (totalCost-totalValue) / numMade
								bestCraftID = recipeID
								bestCraftResidual = totalValue / numMade
							end
						end

						cache.craftCost = bestCraftCost
						cache.craftCostID = bestCraftID
						cache.craftResidual = bestCraftResidual


						if LSWConfig.costBasis == COST_BASIS_PURCHASE then									-- best = least money
							if not bestCost or (cache.craftCost and (bestCost > cache.craftCost or LSWConfig.forceCraft)) then
								bestCost = cache.craftCost
								if bestCost then
									source = "c"
								end
							end
						else																				-- best = most money
							if not itemIsVendorItem then
								if cache.craftCost and LSWConfig.forceCraft then
									bestCost = cache.craftCost
									if bestCost then
										source = "c"
									end
								end
							end
						end
					end
				else
					cache.craftCost = nil
					cache.craftCostID = nil
					cache.craftResidual = nil
				end


				cache.source = source
				cache.bestCost = bestCost or 0
			end
		end
	end


	local function UpdateSingleRecipePrice(recipeID)

		if recipeCache.results[recipeID] and recipeCache.reagents[recipeID] then
			if recipeCache.sync[recipeID] ~= priceDataSync then
				if recipeCache.results[recipeID] then
					for itemID in pairs(recipeCache.results[recipeID]) do
						UpdateItemCost(itemID)
						UpdateItemValue(itemID)
					end
				end

				local buy = 0
				local sell = 0
				local cost = 0

				recipeCache.sync[recipeID] = priceDataSync

	--			for itemID, numNeeded in pairs(cache.reagents) do
	--				buy = buy + numNeeded * math.max(itemCache[itemID].vendorCost or itemCache[itemID].auctionCost, itemCache[itemID].auctionCost)
	--				sell = sell + numNeeded * math.max(itemCache[itemID].vendorValue, itemCache[itemID].auctionValue)
	--			end

				for itemID, numNeeded in pairs(recipeCache.reagents[recipeID]) do
					local itemCost = LSW:GetItemCost(itemID)
					cost = cost + numNeeded * itemCost
--					UpdateItemCost(itemID)
	--				cost = cost + numNeeded * itemCache[itemID].bestCost
				end

				recipeCache.cost[recipeID] = cost

				return true
			end
		end
	end


	local updateIterateSkill = 1
	local updateIterateSkillMax = 1
	local updateIterateStartTime = 0
	local updateIterateRefreshCount = 10

	local function UpdateIterator(timer)
		local count = 0
		local startTime = GetTime()

		while ((GetTime() - startTime) < .025) do
			local index = updateIterateSkill

			local name, skillType = GetTradeSkillInfo(index)

			if skillType ~= "header" then
				local recipeLink = GetTradeSkillRecipeLink(index)
				local recipeID = LSW:FindID(recipeLink)

				if not recipeCache.results[recipeID] or recipeCache.sync[recipeID] ~= priceDataSync then
					UpdateSingleRecipePrice(recipeID)

					count = count + 1
				end
			end

			updateIterateSkill = updateIterateSkill + 1

			if updateIterateSkill > updateIterateSkillMax then
				break
			end
		end

		progressBar:Show(updateIterateSkill/updateIterateSkillMax)

		updateIterateRefreshCount = updateIterateRefreshCount - 1


		if updateIterateRefreshCount < 0 then
			if LSW.parentFrame:IsVisible() then
				LSW:RefreshWindow()
			end
			updateIterateRefreshCount = 10
		end


		if updateIterateSkill > updateIterateSkillMax then
			updateIterateSkill = 1
			LSW:DeleteTimer(timer.name)

			if LSW.parentFrame:IsVisible() then
				LSW:RefreshWindow()
--				LSW:ChatMessage("DONE in "..floor((GetTime() - updateIterateStartTime)*1000)/1000 .." seconds")
			end

			progressBar:Hide()
		end
	end


	local function UpdateRecipePrices()
		local numSkills = GetNumTradeSkills()
		local hasNil

		updateIterateSkill = 1
		updateIterateSkillMax = numSkills
		updateIterateStartTime = GetTime()
		updateIterateRefreshCount = 10

		LSW:CreateTimer("updateIterator", 0.0, UpdateIterator, 0.05)
		progressBar:Init(LSW.parentFrame, "LSW: Caching Prices")
		progressBar:Show(0)

--[[
		for i=1, numSkills do
			local name, skillType = GetTradeSkillInfo(i)

			if skillType ~= "header" then
				local recipeLink = GetTradeSkillRecipeLink(i)
				local recipeID = LSW:FindID(recipeLink)

				UpdateSingleRecipePrice(recipeID)
			end
		end

		LSW:ChatMessage("DONE in "..floor((GetTime() - updateIterateStartTime)*1000)/1000 .." seconds")
]]

	end


	function LSW:FlushPriceData()
		priceDataSync = priceDataSync + 1
--		LSW:UpdateData()
		LSW:CreateTimer("updateData-PriceFlush", 0.05, LSW.UpdateData)
	end


	local updateInProgress

	function LSW:UpdateData()
		if not updateInProgress then
			updateInProgress = true

			_, currentSkillLevel = GetTradeSkillLine()

			if not LSW.pricingInitialized then
				LSW.pricingInitialized = true
				InitializePricing()
			end


			UpdateRecipeCache()
			UpdateRecipePrices()

			updateInProgress = nil

--			if LSW.parentFrame:IsVisible() then
--				LSW:RefreshWindow()
--			end
		end
	end


	function LSW:GetItemCost(itemID)
		if itemID then
			if itemCache[itemID] then
				UpdateItemCost(itemID)
				return itemCache[itemID].bestCost, itemCache[itemID].source
			else
				AddToItemCache(itemID)
				UpdateItemCost(itemID)
				return itemCache[itemID].bestCost, itemCache[itemID].source
			end
		end

		return 0, "?"
	end


	function GetSkillupPercent(spellID)
		local levels = periodicTable:ItemInSet(spellID, "TradeskillLevels")
		local orange, yellow, green, gray;

		if not levels then
			return 0;
		else
			local a,b,c,d = string.split("/",levels)

			local orange, yellow, green, gray  = tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0, tonumber(d) or 0

			if currentSkillLevel >= gray then
				return 0
			elseif currentSkillLevel < yellow then
				return 1
			elseif currentSkillLevel >= yellow and currentSkillLevel < green then
				return 1-(currentSkillLevel - yellow+1)/(green-yellow+1)*.5
			else
				return (1-(currentSkillLevel - green+1)/(gray-green+1))*.5
			end
		end
	end


	function LSW:GetSkillCost(recipeID)
--		local rCache = recipeCache[recipeID]
		if recipeCache.results[recipeID] then
			if periodicTable and LSWConfig.factorSkillUp then
				local itemID = next(recipeCache.results[recipeID])
				local skillUp = GetSkillupPercent(recipeCache.enchants[recipeID] or itemID)

				if skillUp > 0 then
					return recipeCache.cost[recipeID] and recipeCache.cost[recipeID] / skillUp
				else
					return recipeCache.cost[recipeID]
				end
			else
				return recipeCache.cost[recipeID]
			end
		end

		return 0
	end


	function LSW:GetSkillValue(recipeID, fate)
		if not fate then
			fate = globalFate
		end

		local value, itemFate = 0, "?"
--		local rCache = recipeCache[recipeID]

		if recipeCache.results[recipeID] then
--			local itemID = rCache.itemID
			local totalValue = 0

			for itemID,numMade in pairs(recipeCache.results[recipeID]) do
				local cache = itemCache[itemID]

				if cache then
					if fate == 0 then
						value, itemFate = (cache.bestValue or 0), (cache.fate or "?")
					elseif fate == 1 then
						value, itemFate = cache.auctionValue, itemFateList[fate]
					elseif fate == 2 then
						value, itemFate = cache.vendorValue, itemFateList[fate]
					else
						value, itemFate = cache.disenchantValue, itemFateList[fate]
					end

					if value and value > 0 then
						value = value * numMade
					end

					totalValue = totalValue + (value or 0)
--					return value, itemFate
				end
			end

			return totalValue, itemFate
		end

		return 0, "?"
	end


	local function UpdateWindow()
		if LSW.parentFrame and LSW.parentFrame:IsVisible() then
			LSW:RefreshWindow()
		end
	end



	function LSW:SkillButtonShow(button)
		local name = button:GetName()
		local itemLevel = "?"
		local x
		local id
		local alt = IsAltKeyDown()

		id = string.match(name, LSW.buttonNamePattern)
		id = tonumber(id)

		local textButton = _G[LSW.buttonTextNamePattern and string.format(LSW.buttonTextNamePattern, id)] or button

		local buttonValue, buttonCost, buttonLevel = LSW:CreateDynamicButtons(id, name)

		width = LSW:GetSkillListWidth()

		if LSWConfig.singleColumn then
			width = width + buttonCost:GetWidth()
			buttonValue:SetWidth(45)
		else
			buttonValue:SetWidth(40)
		end



		button:SetWidth(width)

		if (not buttonValue) then return; end

		local skillID = button:GetID()

		local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

		LSW:FilterButtonText(textButton, itemID, recipeID)

		buttonCost:SetID(skillID)
		buttonValue:SetID(skillID)
		buttonLevel:SetID(skillID)

		if (recipeID and skillType ~= "header") then
			local costAmount = LSW:GetSkillCost(recipeID)
			local valueAmount, itemFate = LSW:GetSkillValue(recipeID, globalFate)

			local itemFateString = string.format("|c%s%s|r", itemFateColor[itemFate], itemFate)
			local hilight = (costAmount or 0) < (valueAmount or 0)
			local valueText

			if itemFate == "a" and alt then
				local iCache = itemCache[itemID]
				valueText = ((iCache and iCache.auctionValueCount) or 0).." ("..(GetItemCount(itemID) or 0)..")"
			elseif itemFate == "a" and itemCache[itemID] and itemCache[itemID].BOP then
				valueText = BOP_STRING
			elseif itemFate == "d" and itemCache[itemID] and not itemCache[itemID].disenchantValue then
				valueText = NO_DE_STRING
			else
				if LSWConfig.valueAsPercent then
					if (costAmount and costAmount > 0 and valueAmount and valueAmount >= 0) then
						local per = valueAmount / costAmount

						if per < .1 then
							per = math.floor(per*1000)/10
							valueText = string.format("%2.1f%%",per)
						elseif per > 10 then
							per = math.floor(per*10)/10
							valueText = string.format("%2.1fx",per)
						else
							per = math.floor(per*100)
							valueText = per.."%"
						end

						if (hilight) then
							valueText = "|cffd0d0d0"..valueText..itemFateString
						else
							valueText = "|cffd02020"..valueText..itemFateString
						end

					elseif (valueAmount >= 0) then
						valueText = "inf"..itemFateString
					end
				else
					if LSWConfig.singleColumn then
						valueText = (LSW:FormatMoney((valueAmount or 0) - (costAmount or 0),hilight) or "--")..itemFateString
					else
						if valueAmount < 0 then
							valueText = "   --"..itemFateString
						else
							valueText = (LSW:FormatMoney(valueAmount,hilight) or "--")..itemFateString
						end
					end
				end
			end


			buttonValue.text:SetText(valueText)

			if LSWConfig.singleColumn then
				buttonCost:Hide()
			else
				buttonCost.text:SetText((LSW:FormatMoney(costAmount,false) or "").."  ")
				buttonCost:Show()
			end


			if recipeID then
				buttonValue:Show()

				if itemID>0 and LSWConfig.showLevel then
					local _, _, quality, itemLevel, toonLevel = GetItemInfo(itemID)

					if itemLevel then
						local r,g,b,hex = GetItemQualityColor(quality)

						if (toonLevel == 0 or toonLevel==1) then
							buttonLevel.text:SetText("|cff80a0ff"..itemLevel)
						else
							buttonLevel.text:SetText(hex..toonLevel)
						end

						buttonLevel:Show()
					end
				else
					buttonLevel.text:SetText("")
					buttonLevel:Hide()
				end
			else
				buttonValue:Hide()
				buttonLevel:Hide()
			end
		else
			buttonValue:Hide()
			buttonCost:Hide()
			buttonLevel:Hide()
		end
	end




	function LSW:SkillButtonHide(button)
		local name = button:GetName();
		local id = string.match(name, LSW.buttonNamePattern)
		id = tonumber(id)

		local buttonValue, buttonCost, buttonLevel = LSW:CreateDynamicButtons(id, name)

		if (buttonCost) then buttonCost:Hide(); end
		if (buttonValue) then buttonValue:Hide(); end
		if (buttonLevel) then buttonLevel:Hide(); end

	--	LSW_ChatMessage("Hide "..name);
	end



	local function ItemLevelButton_OnEnter(button)
		LSWTooltip:SetOwner(button, "ANCHOR_NONE")

		local spaceLeft = LSW.parentFrame:GetLeft()
		local spaceRight = GetScreenWidth() - LSW.parentFrame:GetRight()

		if spaceRight < spaceLeft then
			LSWTooltip:SetPoint("BOTTOMRIGHT", LSW.parentFrame, "BOTTOMLEFT")
		else
			LSWTooltip:SetPoint("BOTTOMLEFT", LSW.parentFrame, "BOTTOMRIGHT")
		end

--		LSWTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
		LSWTooltip:SetText("Required level to use crafted item.")
		LSWTooltip:Show()
	end

	local function ItemLevelButton_OnLeave()
		LSWTooltip:Hide()
	end



	local function CostButton_AddItem(itemID, numNeeded, level, residualMaterials)
		local iCache = itemCache[itemID]
		local _, reagentName = GetItemInfo(itemID)
		local pad = string.rep("  ", level or 1)

		if not reagentName then
			reagentName = "[item:"..itemID.."]"
		end

		if not iCache then
			return 0
		end

		if level > 10 then			-- hard limit on recursion
			return 0
		end

--[[
		if itemID < 0 then
			reagentName = "Disenchant "..GetItemInfo(itemID)
			iCache = itemCache[-itemID]
			itemID = -itemID
		end
]]

		if iCache.source == "c" then
--			LSWTooltip:AddLine(pad..reagentName.." x "..numNeeded)



			local recipeID = iCache.craftCostID

--			local rCache = recipeCache[recipeID]
			local iterations = math.ceil((numNeeded - (residualMaterials[itemID] or 0))/recipeCache.results[recipeID][itemID])

			if iterations > 0 then
				numNeeded = numNeeded - (residualMaterials[itemID] or 0)
				local recipeName
				local subTotal = 0
				local residuals = 0

				if recipeID < 0 then
					recipeName = recipeCache.names[recipeID] or GetSpellInfo(recipeID)

--					LSWTooltip:AddLine(pad..PROCESS_COLOR_HEX.."["..recipeName.."]".." x "..iterations)
					LSWTooltip:AddDoubleLine(pad..reagentName.."x"..numNeeded, PROCESS_COLOR_HEX.."["..recipeName.."]".."x"..iterations)
				else
					recipeName = GetSpellLink(recipeID)

--					LSWTooltip:AddLine(pad..recipeName.." x "..iterations)
					LSWTooltip:AddDoubleLine(pad..reagentName.."x"..numNeeded, recipeName .."x"..iterations)
				end


	--			LSWTooltip:AddDoubleLine(pad..recipeName.." x "..iterations, LSW:FormatMoney((recipeCost - recipeValue) * iterations, true).." ")

				for subItem, subNeeded in pairs(recipeCache.reagents[recipeID]) do
					subTotal = subTotal + CostButton_AddItem(subItem, iterations * subNeeded, level+1, residualMaterials)
--					UpdateItemCost(subItem)
--					subTotal = subTotal + itemCache[subItem].bestCost * subNeeded * iterations
				end

				for residualID, numCrafted in pairs(recipeCache.results[recipeID]) do
					if residualID ~= itemID then
--[[
						if LSWConfig.residualPricing == COST_BASIS_RESALE then
							UpdateItemValue(residualID)
							residuals = residuals + itemCache[residualID].bestValue * numCrafted * iterations
						else
							UpdateItemCost(residualID)
							residuals = residuals + itemCache[residualID].bestCost * numCrafted * iterations
						end
]]
						residualMaterials[residualID] = (residualMaterials[residualID] or 0) + numCrafted * iterations
					else
						residualMaterials[residualID] = (residualMaterials[residualID] or 0) + numCrafted * iterations - numNeeded
					end
				end

				return subTotal
			else
				residualMaterials[itemID] = (residualMaterials[itemID] or 0) - numNeeded
			end

			return 0
--			if iCache.craftResidual > 0 then
--				LSWTooltip:AddDoubleLine(pad..PROCESS_COLOR_HEX.."Residual Materials Value", "("..LSW:FormatMoney(residuals, true)..")")
--			end
		else
			if iCache.BOP then
				LSWTooltip:AddDoubleLine(pad..reagentName.." x "..numNeeded, BOP_STRING)
				return 0
			else
				LSWTooltip:AddDoubleLine(pad..reagentName.." x "..numNeeded, LSW:FormatMoney((iCache.bestCost or 0) * numNeeded, true)..(iCache.source or "?"))
				return (iCache.bestCost or 0) * numNeeded
			end
		end

		return 0
	end



	local function CostButton_OnEnter(button)
		LSWTooltip:SetOwner(LSW.parentFrame, "ANCHOR_NONE")

		local spaceLeft = LSW.parentFrame:GetLeft()
		local spaceRight = GetScreenWidth() - LSW.parentFrame:GetRight()

		if spaceRight < spaceLeft then
			LSWTooltip:SetPoint("BOTTOMRIGHT", LSW.parentFrame, "BOTTOMLEFT")
		else
			LSWTooltip:SetPoint("BOTTOMLEFT", LSW.parentFrame, "BOTTOMRIGHT")
		end

		local total = 0

		local pad = ""

		if LSWConfig.singleColumn then
			pad = "    "
		end

		if true or LSWConfig.priceSanity then
			local skillID =  button:GetID()
			local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

			if skillType ~= "header" then
				LSWTooltip:AddLine(recipeLink)

				local residualMaterials = {}


--				local rCache = recipeCache[recipeID]

				if recipeCache.reagents[recipeID] then
					local costAmount = LSW:GetSkillCost(recipeID)

					for itemID, numNeeded in pairs(recipeCache.reagents[recipeID]) do
						total = total + CostButton_AddItem(itemID, numNeeded, 1, residualMaterials)
--						local iCache = itemCache[itemID]

--						total = total + ((iCache.bestCost or 0) + (iCache.craftResidual or 0)) * numNeeded
					end
				end

				if LSWConfig.costBasis == COST_BASIS_PURCHASE then
					LSWTooltip:AddDoubleLine("Total estimated purchase cost: ", LSW:FormatMoney(total,true).."  ")
				else
					LSWTooltip:AddDoubleLine("Total estimated reagent value: ", LSW:FormatMoney(total,true).."  ")
				end

				if periodicTable and recipeCache.results[recipeID] then
					local itemID = next(recipeCache.results[recipeID])
					local skillUp = GetSkillupPercent(recipeCache.enchants[recipeID] or itemID)

					if skillUp then
						LSWTooltip:AddDoubleLine("Skill Up Chance: ", math.floor(skillUp*100).."%")
					end
				end


				local residualsShow

				for residualID, residualCount in pairs(residualMaterials) do
					if residualCount > 0 then
						residualsShow = true
					end
				end

				if residualsShow then
					local totalResidualValue = 0

					LSWTooltip:AddLine(" ")

--					LSWTooltip:AddLine("Residual Reagents:")

					if LSWConfig.residualPricing == COST_BASIS_RESALE then
						LSWTooltip:AddLine("Residual Reagents: (priced at "..LSWConfig.residualValueFactor.."% of cost)")
					else
						LSWTooltip:AddLine("Residual Reagents: (priced at "..LSWConfig.residualValueFactor.."% of value)")
					end



					for residualID, residualCount in pairs(residualMaterials) do
						if residualCount > 0.001 then
							local residualValue
							local _, reagentName = GetItemInfo(residualID)

							if LSWConfig.residualPricing == COST_BASIS_RESALE then
								UpdateItemValue(residualID)
								residualValue = itemCache[residualID].bestValue * residualCount
								LSWTooltip:AddDoubleLine("    "..reagentName.." x "..residualCount, LSW:FormatMoney(residualValue, true)..(itemCache[residualID].fate or "?"))
							else
								UpdateItemCost(residualID)
								residualValue = itemCache[residualID].bestCost * residualCount
								LSWTooltip:AddDoubleLine("    "..reagentName.." x "..residualCount, LSW:FormatMoney(residualValue, true)..(itemCache[residualID].source or "?"))
							end

							totalResidualValue = totalResidualValue + residualValue
						end
					end

					totalResidualValue = totalResidualValue * (LSWConfig.residualValueFactor / 100)


					LSWTooltip:AddDoubleLine("Total residual reagent value: ", LSW:FormatMoney(totalResidualValue,true).."  ")
				end
			end
		else
			LSWTooltip:SetText("Estimated cost to use skill.")
		end

		if not LSWConfig.singleColumn then
			LSWTooltip:Show()
		end

		return total
	end


	local function CostButton_OnLeave()
		LSWTooltip:Hide()
	end

	local function CostButton_OnClick(frame, button)
		if (frame:GetText() == " ") then return end

		if (button=="RightButton") then
			local skillID =  frame:GetID()
			local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

			if recipeCache.reagents[recipeID] then
				for itemID in pairs(recipeCache.reagents[recipeID]) do
					GenerateItemMenu(itemID)
				end
			end

			currentRecipe = recipeID

			EasyMenu(costMenu, LSWMenuFrame, frame, 0,0, "MENU", 5)
		end
	end


	local function ValueButton_OnEnter(button)
		if (button:GetText() == " ") then return end

		local pad = ""

		if LSWConfig.singleColumn then
			pad = "    "
		end

		LSWTooltip:SetOwner(LSW.parentFrame, "ANCHOR_NONE")

		local spaceLeft = LSW.parentFrame:GetLeft()
		local spaceRight = GetScreenWidth() - LSW.parentFrame:GetRight()

		if spaceRight < spaceLeft then
			LSWTooltip:SetPoint("BOTTOMRIGHT", LSW.parentFrame, "BOTTOMLEFT")
		else
			LSWTooltip:SetPoint("BOTTOMLEFT", LSW.parentFrame, "BOTTOMRIGHT")
		end

		local skillID = button:GetID()
		local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

		if (skillName and skillType ~= "header") then
			LSWTooltip:ClearLines()

--			local rCache = recipeCache[recipeID]

			if recipeCache.results[recipeID] then
				for itemID, numMade in pairs(recipeCache.results[recipeID]) do
					local iCache = itemCache[itemID]

					local auctionValue = LSW:FormatMoney((iCache.auctionValue or 0)*numMade,(iCache.fate=="a"))
					local vendorValue = LSW:FormatMoney((iCache.vendorValue or 0)*numMade,(iCache.fate=="v"))
					local disenchantValue = LSW:FormatMoney((iCache.disenchantValue or 0)*numMade,(iCache.fate=="d"))

					if iCache.BOP then
						auctionValue = BOP_STRING
					end

					local itemName, itemLink = GetItemInfo(itemID)

					if not itemLink then
						itemLink = GetSpellLink(recipeID)
					end


					if LSWConfig.singleColumn then
						local totalCost = CostButton_OnEnter(button)
						LSWTooltip:AddLine(" ")
		--				LSWTooltip:AddLine("Result:")
						local best = LSW:GetSkillValue(recipeID) or 0

						local bestValue = LSW:FormatMoney(best, true)

						if numMade > 1 then
							LSWTooltip:AddDoubleLine("    "..itemLink.."x"..numMade, bestValue..(iCache.fate or "?"))
							ea = "ea"
						else
							LSWTooltip:AddDoubleLine("    "..itemLink, bestValue..(iCache.fate or "?"))
						end

						LSWTooltip:AddDoubleLine("Total Estimated Profit:", LSW:FormatMoney(best - totalCost, true))
					else

						if numMade > 1 then
							LSWTooltip:AddLine(itemLink.." x "..numMade)
						else
							LSWTooltip:AddLine(itemLink)
						end

						if iCache.auctionValue and iCache.auctionValue > 0 then
							LSWTooltip:AddDoubleLine("|cff909040Auction("..(iCache.auctionValueCount or "?").."): ",auctionValue)
						else
							LSWTooltip:AddDoubleLine("|cff909040Auction: ","??")
						end

						LSWTooltip:AddDoubleLine("|cff206080Vendor: ",vendorValue)

						if itemID > 0 and recipeCache.results[-itemID] then
							LSWTooltip:AddDoubleLine("|cff008000Disenchant: ",disenchantValue)
--							LSWTooltip:AddLine("|cff008000Disenchant:")

							for itemID, count in pairs(recipeCache.results[-itemID]) do
								UpdateItemValue(itemID)
								local _, itemLink = GetItemInfo(itemID)
								local value, fate = itemCache[itemID].auctionValue

								LSWTooltip:AddDoubleLine("  "..(itemLink or itemID).." |cff808080x "..math.floor(count*1000)/1000,LSW:FormatMoney((value or 0) * count, false).."  ")
							end
						end

						local cycleString

						if (globalFate == 0) then
							cycleString = "[Best Value Shown]"
						else
							cycleString = "["..fateString[itemFateList[globalFate] ].." Value Shown]"
						end

						LSWTooltip:AddLine(cycleString,1,1,1)
					end
				end

				LSWTooltip:Show()
			end
		end
	end



	local function ValueButton_OnClick(frame, button)
		if (frame:GetText() == " ") then return end

		if(button=="LeftButton") then
			globalFate = globalFate + 1;

			if (globalFate > globalFateMax) then
				globalFate = 0;
			end

			ValueButton_OnEnter(frame)

			UpdateWindow()
		elseif (button=="RightButton") then
			if LSWConfig.singleColumn then
				EasyMenu(profitMenu, LSWMenuFrame, frame, 0,0, "MENU", 5)
			else
				EasyMenu(valueMenu, LSWMenuFrame, frame, 0,0, "MENU", 5)
			end
		end
	end


	local function ValueButton_OnLeave()
		LSWTooltip:Hide()
	end




	function LSW:CreateDynamicButtons(id, buttonName)


	--LSW_ErrorMessage("creating button "..id);

		if buttonValueList[id] then
			return buttonValueList[id], buttonCostList[id], buttonLevelList[id]
		end

		local buttonValue = CreateFrame("Button", "LSWTradeSkillValue"..id, self.parentFrame, "LSWTradeSkillValueButtonTemplate")
		buttonValue:SetPoint("TOPLEFT",buttonName,"TOPRIGHT",5,0)

		buttonValue.text = _G["LSWTradeSkillValue"..id.."Text"]
		buttonValue.text:SetText("00 00")
		buttonValue:Hide()
		buttonValue:SetWidth(40)

		buttonValue:RegisterForClicks("AnyUp")
		buttonValue:SetScript("OnClick", ValueButton_OnClick)
		buttonValue:SetScript("OnEnter", ValueButton_OnEnter)
		buttonValue:SetScript("OnLeave", ValueButton_OnLeave)



		local buttonCost = CreateFrame("Button", "LSWTradeSkillCost"..id, self.parentFrame, "LSWTradeSkillCostButtonTemplate")
		buttonCost:SetPoint("TOPLEFT",buttonName,"TOPRIGHT",buttonValue:GetWidth()+15,0)

		buttonCost.text = _G["LSWTradeSkillCost"..id.."Text"]
		buttonCost.text:SetText("00 00")

		buttonCost:SetWidth(40)
		buttonCost:Hide()

		buttonCost:RegisterForClicks("AnyUp")
		buttonCost:SetScript("OnClick", CostButton_OnClick)
		buttonCost:SetScript("OnEnter", CostButton_OnEnter)
		buttonCost:SetScript("OnLeave", CostButton_OnLeave)



		local buttonLevel = CreateFrame("Button", "LSWTradeSkillItemLevel"..id, self.parentFrame, "LSWTradeSkillItemLevelTemplate")
		buttonLevel:SetPoint("TOPLEFT",buttonName,"TOPLEFT",5,0)

		buttonLevel.text = _G["LSWTradeSkillItemLevel"..id.."Text"]
		buttonLevel.text:SetText("00 00")

		buttonLevel:SetText("")
		buttonLevel:Hide()

		buttonLevel:RegisterForClicks("AnyUp")
		buttonLevel:SetScript("OnEnter", ItemLevelButton_OnEnter)
		buttonLevel:SetScript("OnLeave", ItemLevelButton_OnLeave)



		buttonValueList[id] = buttonValue
		buttonCostList[id] = buttonCost
		buttonLevelList[id] = buttonLevel

		return buttonValue, buttonCost, buttonLevel
	end


	LSW.buttonScripts = {
		valueButton = {
			OnClick = ValueButton_OnClick,
			OnEnter = ValueButton_OnEnter,
			OnLeave = ValueButton_OnLeave,
		},
		costButton = {
			OnClick = CostButton_OnClick,
			OnEnter = CostButton_OnEnter,
			OnLeave = CostButton_OnLeave,
		},
		CostButton_AddItem = CostButton_AddItem
	}


-- registers support for a ui
-- name is the name of the support (for record keeping essentially)
-- test is the function used to determine if this ui is present
-- init is the function used to initialize
-- frame support modules should register with this function at load time
	function LSW:RegisterFrameSupport(name, test, init)
		local t = {}

		t.name = name
		t.Test = test
		t.Init = init

		table.insert(frameSupportList, t)

		if LSW.initialized then
			if test(i) then
				init(i)
			end
		end
	end



-- registers support for an auction module
-- name is the name of the support (for record keeping essentially)
-- test is the function used to determine if this ui is present
-- init is the function used to initialize
-- auction support modules should register with this function at load time
	function LSW:RegisterPricingSupport(name, test, init)
		local t = {}

		t.name = name
		t.Test = test
		t.Init = init

--LSW:ChatMessage("registering pricing module "..name);
		table.insert(pricingSupportList, t)

		if LSW.initialized then
			if test(i) then
				init(i)
			end
		end
	end


	function LSW:GetFrameSupportList()
		return frameSupportList
	end


	local function InitializeFrameSupport()
		for i = 1, #frameSupportList do
			if frameSupportList[i].Test(i) then
--				LSW:ChatMessage("LSW: Initializing "..frameSupportList[i].name.." frame support")
				frameSupportList[i].Init(i)
				break
			end
		end
	end


	local function InitializePricingSupport()
		SetSecondaryLevels()

		for i = 1, #pricingSupportList do
--		LSW:ChatMessage("LSW: Checking "..pricingSupportList[i].name.." pricing support")
			if pricingSupportList[i].Test(i) then
--				LSW:ChatMessage("LSW: Initializing "..pricingSupportList[i].name.." pricing support")
				supportMenuList[pricingSupportList[i].name] = pricingSupportList[i].Init(i)
			end
		end

		return optionsMenuList
	end



	local function DeepCopy(src,dst)
		for k,v in pairs(src) do
			if not dst[k] then
				dst[k] = v
			else
				if type(v) == "table" then
					if type(dst[k]) ~= "table" then
						dst[k] = {}
					end

					DeepCopy(v, dst[k])
				end
			end
		end
	end


	local function OnLoad()
		if not LSW.initialized then
			if LibStub then
				periodicTable = LibStub:GetLibrary("LibPeriodicTable-3.1", true)
			end


--			LSW:ItemTableViewInit()
--			LSW:RecipeTableViewInit()

			LSW:ChatMessage(LSW_VERSION_LONG)

--[[
			if not LSWConfig.vendorOverride then
				LSWConfig.vendorOverride = {}
			end
]]

			DeepCopy(defaultConfig, LSWConfig)

			LSWConfig.itemBOP = nil

			InitializePricingSupport()
			InitializeFrameSupport()

			LSW.initialized = true
		end
	end





	LSW.vendorCost = function(itemID)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)

		return (itemSellPrice or 0) * 4
	end

	LSW.vendorValue = function(itemID)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)

		return itemSellPrice or 0
	end


	LSW.auctionCost = function() return nil,0 end
	LSW.auctionValue = function() return nil,0 end




	function LSW:CreateTimer(name, countDown, triggerFunction, repeatTime)
		timerList[name] = {name=name, countDown=countDown, triggerFunction=triggerFunction, repeatTime=repeatTime}
	end

	function LSW:DeleteTimer(name)
		if timerList[name] then
			timerList[name].delete = true
		end
	end

	function LSW:GetTimer(name)
		return timerList[name]
	end


	local function ClearPriceData(itemID)
		local icache = itemCache[itemID]
		if icache and (icache.syncValue or icache.syncCost) then
--print("clear price for", (GetItemInfo(itemID)))
			icache.syncValue = nil
			icache.syncCost = nil

			if icache.craftSource then
				for sourceRecipeID in pairs(icache.craftSource) do
					recipeCache.sync[sourceRecipeID] = nil
--print("clear price for",GetSpellLink(sourceRecipeID))

					if recipeCache.results[sourceRecipeID] then
						for itemID in pairs(recipeCache.results[sourceRecipeID]) do
							ClearPriceData(itemID)
						end
					end
				end
			end
		end
	end


	local function AuctionDataUpdate()
		local num, totalNum = GetNumAuctionItems("list")

		for i=1,num do
			local itemLink = GetAuctionItemLink("list",i)

			if itemLink then
				local itemID = tonumber(string.match(itemLink,"item:(%d+)"))
				ClearPriceData(itemID)
			end
		end
	end


	local master = CreateFrame("Frame", "LSWMasterFrame")
	master:RegisterEvent("TRADE_SKILL_SHOW")


	function LSW:Initialize()
		master:UnregisterEvent("TRADE_SKILL_SHOW")
		OnLoad()
		master:RegisterEvent("TRADE_SKILL_UPDATE")
		master:RegisterEvent("MODIFIER_STATE_CHANGED")
		master:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
		UpdateWindow()

		LSW:CreateTimer("updateData-UpdateEvent", 0.1, LSW.UpdateData)
	end

	master:SetScript("OnEvent", function(frame, event, arg1, arg2)
		if event == "TRADE_SKILL_SHOW" then
			LSW:Initialize()
		end
		if event == "TRADE_SKILL_UPDATE" then
			if GetTradeSkillLine() then
				LSW:CreateTimer("updateData-UpdateEvent", 0.1, LSW.UpdateData)
			end
		end

		if event == "MODIFIER_STATE_CHANGED" then
			UpdateWindow()
		end

		if event == "AUCTION_ITEM_LIST_UPDATE" then
			AuctionDataUpdate()
		end
	end)


	function LSW:DumpFrames()
		local function dumpList ( f, ... )
			if f then
				print(tostring(f:GetName()))

				dumpList(...)
			end
		end

		print("frames registered for ADDON_LOADED:")
		dumpList( GetFramesRegisteredForEvent("ADDON_LOADED") )
	end


	master:SetScript("OnUpdate", function (frame, elapsed)
		if timerList then
			for name,timer in pairs(timerList) do
				if timer.delete then
					timerList[name] = nil
				else
					timer.countDown = timer.countDown - elapsed
					if timer.countDown <= 0 then
						timer:triggerFunction()

						if timer.repeatTime then
--							timer.countDown = timer.countDown + timer.repeatTime
							timer.countDown = timer.repeatTime
						else
							timerList[name] = nil
						end
					end
				end
			end
		end
	end)


	LSW.UpdateItemCost = UpdateItemCost
	LSW.UpdateItemValue = UpdateItemValue
	LSW.UpdateSingleRecipePrice = UpdateSingleRecipePrice
	LSW.AddToItemCache = AddToItemCache
end



