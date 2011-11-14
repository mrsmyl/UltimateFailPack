--[[Author:		Cyprias 
	License:	All Rights Reserved
	Contact:	Cyprias on Curse.com or WowAce.com

	Only Curse.com and Wowace.com have permission to host this addon.
	I have not given permission for My Sales to be used in any addon compilation or UI pack.]]
-- global lookup
local GetInboxNumItems_ = GetInboxNumItems
local GetInboxHeaderInfo_ = GetInboxHeaderInfo
local GetInboxInvoiceInfo_ = GetInboxInvoiceInfo
local date_ = date
local table_getn = table.getn
local table_insert = table.insert
local InterfaceOptionsFrame_OpenToCategory_ = InterfaceOptionsFrame_OpenToCategory
local GetGuildRosterInfo_ = GetGuildRosterInfo
local GetNumGuildMembers_ = GetNumGuildMembers
local table_remove = table.remove
local GetItemInfo_ = GetItemInfo
local GetItemQualityColor_ = GetItemQualityColor
local strsplit_ = strsplit
local pairs_ = pairs

--~ local MS_DB = MS_DB --our DB table.
 
local folder, core = ...
MS = core --global table

-- Isolate the environment
local _G = getfenv(0)
setmetatable(MS, {__index = _G})
setfenv(1, MS)
-- local

local curseVersion = GetAddOnMetadata(folder, "X-Curse-Packaged-Version")
local curseRevision = GetAddOnMetadata(folder, "X-Curse-Packaged-Revision") -- 41
if curseVersion and curseRevision and curseVersion ~= "r"..curseRevision then
	curseVersion = curseVersion.." (r"..curseRevision..")" --alpha versions will show "r99", tagged versions will show "1.2.3beta (r99)"
end

title		= GetAddOnMetadata(folder, "Title")
version	= curseVersion or "[dev]"

titleFull	= title.." "..version

LibStub("AceAddon-3.0"):NewAddon(core, folder, "AceConsole-3.0", "AceSerializer-3.0", "AceHook-3.0", "AceEvent-3.0") 
local ScrollingTable = LibStub("ScrollingTable")
L = LibStub("AceLocale-3.0"):GetLocale(folder, true)

local regEvents = {
	"GUILD_ROSTER_UPDATE",
	"FRIENDLIST_UPDATE",
	"MAIL_CLOSED",
}
P	= {} --db.profile
fR	= {} --db.factionrealm
G	= {} --db.global
db	= {}
sales	= {}
defaultSettings	= {
	char = {},
	factionrealm = {
		PoI = {},
	},
	profile = {},
	global = {
		itemColour = {},
	}
}
guildMembers = {}
friendsList = {}
local copperMade = 0
local mailOpen = 0
local onlineColorTable = {r = 0.8, g = 0.8, b = 0.8, a = 1.0 } --gray buyer name


local whiteText			= "|cffffffff%s|r"

function core:OnInitialize()
	db = LibStub("AceDB-3.0"):New("MS_DB", defaultSettings, true)
	CoreOptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)--save option profile or load another chars opts.
	db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")
	self:RegisterChatCommand("ms", "MySlashProcessorFunc")
	
	self:BuildAboutMenu()
	
	local config = LibStub("AceConfig-3.0")
	local dialog = LibStub("AceConfigDialog-3.0")
	config:RegisterOptionsTable(title, CoreOptionsTable)
	coreOpts = dialog:AddToBlizOptions(title, titleFull)
end

--~ local realmKey = GetRealmName()
--~ local charKey = UnitName("player") .. " - " .. realmKey
--~ local factionKey = UnitFactionGroup("player")
--~ local factionrealmKey = factionKey .. " - " .. realmKey


function GetSalesKeys()--	/run MS.GetSalesKeys()
	local keys = {}
	
	if MS_DB.char then
		for charName, data in pairs(MS_DB.char) do 
			if data.sales then
				keys[charName] = data.sales
			end
		end	
	end
	
	if MS_DB.factionrealm then
		for factionrealm, data in pairs(MS_DB.factionrealm) do 
			if data.sales  then
				keys[factionrealm] = data.sales
			end
		end
	end
--~ 	for key, data in pairs(keys) do 
--~ 		print("key", "||", key, data)
--~ 	end
	
	return keys
end

function UpdateShownSales()
	local keys = GetSalesKeys()
	if keys[P.showSales] then
		sales = keys[P.showSales]
	end
end

function core:OnEnable()
	P = db.profile
	fR = db.factionrealm
	G = db.global
	
	if not db[P.saveSales].sales then
		db[P.saveSales].sales = {}
	end
	
	UpdateShownSales()
	
--~ 	sales = db[P.saveSales].sales
	
	self:Hook("TakeInboxMoney", true)
	self:Hook("AutoLootMailItem", true)
	
--~ 	self:Hook("TakeInboxItem", true)
	

	for i, event in pairs_(regEvents) do 
		self:RegisterEvent(event)
	end
	
	BuildPoIList()
	
	self:FRIENDLIST_UPDATE("FRIENDLIST_UPDATE")
	
--~ 	CreateOurFrames()
end

function core:MAIL_CLOSED(event, ...)
	if P.salesMadeMessage == true and mailOpen > 0 then
		echo(L.receviedMail:format(mailOpen, CopperToCoins(copperMade)))
		mailOpen = 0
		copperMade = 0
	end
end


function core:OnDisable()
	
end


function core:GUILD_ROSTER_UPDATE(event, ...)
	guildMembers = {} --reset
	local numGuildMembers = GetNumGuildMembers_(true)
	local name
	for i=1, numGuildMembers do 
		name = GetGuildRosterInfo_(i);
		if name then
			guildMembers[name] = true
		end
	end
end


function core:FRIENDLIST_UPDATE(event, ...)
	friendsList = {} --reset
	local numberOfFriends = GetNumFriends()
	local name
	for i=1, numberOfFriends do 
		 name = GetFriendInfo(i)
		 if name then
			friendsList[name] = true
		end
	end
end


function GetBuyerColour(data, cols, realrow, column, table)
	local buyerName = data[realrow].cols[column].value

	if guildMembers[buyerName] then
		return P.guildColour
	elseif friendsList[buyerName] then
		return P.friendColour
	elseif fR.PoI[buyerName] then
		return P.PoIColour
	end
	return onlineColorTable
end


function GetItemColour(data, cols, realrow, column, table)
	local itemName = data[realrow].cols[column].value
	if G.itemColour[itemName] then
		if type(G.itemColour[itemName]) == "number" then
			local r, g, b, hex = GetItemQualityColor_(G.itemColour[itemName] or 0)
			return {r=r,g=g,b=b}
		else
			G.itemColour[itemName] = nil --old version saved RGB colour as a string.
		end
	end

	local _, _, iRarity = GetItemInfo_(itemName);
	local r, g, b, hex = GetItemQualityColor_(iRarity or 0)

	if iRarity then
		G.itemColour[itemName] = iRarity
	end
	return {r=r,g=g,b=b}
end

----------------------------------------------------------------------
function core:OnProfileChanged(...)									--
-- User has reset proflie, so we reset our spell exists options.	--
----------------------------------------------------------------------
	-- Shut down anything left from previous settings
	self:Disable()
	-- Enable again with the new settings
	self:Enable()
end

----------------------------------------------
function core:MySlashProcessorFunc(input)	--
-- /da function brings up the UI options.	--
----------------------------------------------
--~ 	InterfaceOptionsFrame_OpenToCategory_(profitUI)--Expands the menu.
	if input then
		if input:lower() == "config" then
			InterfaceOptionsFrame_OpenToCategory_(coreOpts)
			return
		elseif input:lower() == "window" then
			CreateOurFrames()
			displayFrame.frame:Show()
			return
		end
	end
	
	echo(whiteText:format(title).." "..L["slash commands"])
	echo("    "..whiteText:format("/ms config").." - "..L["Open config window"])
	echo("    "..whiteText:format("/ms window").." - "..L["Open sales window"])
end

function core:TakeInboxMoney(...)
	local mailIndex  = ...

--~ 	Debug("TakeInboxMoney 0", ...)
	
	if GetInboxNumItems_() >= mailIndex then
		local invoiceType, itemName, playerName, bid, buyout, deposit, consignment = GetInboxInvoiceInfo_(mailIndex);
		if invoiceType and invoiceType == "seller" then
			local _, _, sender, subject, money = GetInboxHeaderInfo_(mailIndex);
			local seral = self:Serialize(itemName, money, playerName, date_("%c"))
			table_insert(sales, #sales+1, seral)
			mailOpen = mailOpen + 1
			copperMade = copperMade + money
--~ 			Debug("TakeInboxMoney 1",itemName, money, playerName, date_("%c"))
--~ 			Debug("TakeInboxMoney 3",seral )
		end
	end
end

--fires on rightclick
function core:AutoLootMailItem(...)
	self:TakeInboxMoney(...)
end


--[[
function core:OpenMailAttachment_OnClick(...)
	Debug("OpenMailAttachment_OnClick 1", ...)
end
function core:InboxFrame_OnModifiedClick(...)
	Debug("InboxFrame_OnModifiedClick 1", ...)
end
]]

--[[COD_CONFIRMATION
function core:StaticPopup_Show(...)
	Debug("StaticPopup_Show 1", ..., "A:"..tostring(GetMoney()))
end]]

--[[
function core:TakeInboxItem(...)
	local mailIndex  = ...
	Debug("TakeInboxItem 1", ...)
	if GetInboxNumItems_() >= mailIndex then
		local _, _, sender, _, _, CODAmount, _,  itemCount = GetInboxHeaderInfo_(mailIndex);
		if CODAmount > 0 then
			Debug("TakeInboxItem 3", "sender:"..tostring(sender), "CODAmount:"..tostring(CODAmount) )
		end
	end
end]]

-----------------------------------------------------

local AceGUI = LibStub("AceGUI-3.0")



salesData = {}
local saleCols = {
	{ name= L["Item"], width = 260, defaultsort = "dsc", },
	{ name= L["Money"], width = 100, defaultsort = "dsc", 
		comparesort = function (self, rowa, rowb, sortbycol)
			if salesData[rowa] and salesData[rowb] then
				if self.cols[sortbycol].sort == "dsc" then
					return salesData[rowa].cols[sortbycol].args[1] < salesData[rowb].cols[sortbycol].args[1]
				else
					return salesData[rowa].cols[sortbycol].args[1] > salesData[rowb].cols[sortbycol].args[1]
				end
			end
		end,
	},
	{ name= L["Buyer"], width = 80, defaultsort = "dsc", },
	{ name= L["When"], width = 110, defaultsort = "dsc",
		comparesort = function (self, rowa, rowb, sortbycol)
			if salesData[rowa] and salesData[rowb] then
				if self.cols[sortbycol].sort == "dsc" then
					return salesData[rowa].cols[sortbycol].args[1] < salesData[rowb].cols[sortbycol].args[1]
				else
					return salesData[rowa].cols[sortbycol].args[1] > salesData[rowb].cols[sortbycol].args[1]
				end
			end
		end,
	},
--~ 	{ name= "Source", width = 120, defaultsort = "dsc", },
};

buyerData = {}
local buyerCols = {
	{ name= L["Buyer"], width = 80, defaultsort = "dsc", },
	{ name= L["Bought"], width = 60, defaultsort = "dsc", },
	{ name= L["Paid"], width = 100, defaultsort = "dsc", 
		comparesort = function (self, rowa, rowb, sortbycol)
			if buyerData[rowa] and buyerData[rowb] then
				if self.cols[sortbycol].sort == "dsc" then
					return buyerData[rowa].cols[sortbycol].args[1] < buyerData[rowb].cols[sortbycol].args[1]
				else
					return buyerData[rowa].cols[sortbycol].args[1] > buyerData[rowb].cols[sortbycol].args[1]
				end
			end
		end,
	},
}


itemsData = {}
local itemsCols = {
	{ name= L["Item"], width = 300, defaultsort = "dsc", },
	{ name= L["Sold"], width = 40, defaultsort = "dsc", },
	{ name= L["Money"], width = 100, defaultsort = "dsc", 
		comparesort = function (self, rowa, rowb, sortbycol)
			if itemsData[rowa] and itemsData[rowb] then
				if self.cols[sortbycol].sort == "dsc" then
					return itemsData[rowa].cols[sortbycol].args[1] < itemsData[rowb].cols[sortbycol].args[1]
				else
					return itemsData[rowa].cols[sortbycol].args[1] > itemsData[rowb].cols[sortbycol].args[1]
				end
			end
		end,
	
	},
	{ name= L["Money"].."/"..L["Sale"], width = 100, defaultsort = "dsc", 
		comparesort = function (self, rowa, rowb, sortbycol)
			if itemsData[rowa] and itemsData[rowb] then
				if self.cols[sortbycol].sort == "dsc" then
					return itemsData[rowa].cols[sortbycol].args[1] < itemsData[rowb].cols[sortbycol].args[1]
				else
					return itemsData[rowa].cols[sortbycol].args[1] > itemsData[rowb].cols[sortbycol].args[1]
				end
			end
		end,
	},
}





local saleST = false
local function DrawSalesGroup(container)--	/run MS.CreateOurFrames()

	if saleST == false then
		local window  = container.frame
		saleST = ScrollingTable:CreateST(saleCols, 20, 16, nil, window)
		saleST.frame:SetPoint("BOTTOMLEFT",window, 10,10)
		saleST.frame:SetPoint("TOP", window, 0, -60)
		saleST.frame:SetPoint("RIGHT", window, -10,0)
	end
	saleST:Show()
	
	local width = 80
	for i, data in pairs_(saleCols) do 
		width = width + data.width
	end
	if container.parent then
		container.parent:SetWidth(width);
	end

	
	UpdateSalesData()
end
--	/run print(MS.displayFrame.children[1].saleST)
-- function that draws the widgets for the second tab

local buyerST = false
local function DrawBuyersGroup(container)
	if buyerST == false then
		local window  = container.frame
		buyerST = ScrollingTable:CreateST(buyerCols, 20, 16, nil, window)
		buyerST.frame:SetPoint("BOTTOMLEFT",window, 10,10)
		buyerST.frame:SetPoint("TOP", window, 0, -60)
		buyerST.frame:SetPoint("RIGHT", window, -10,0)
	end
	buyerST:Show()

	if container.parent then
		local width = 100
		for i, data in pairs_(buyerCols) do 
			width = width + data.width
		end
		container.parent:SetWidth(width);
	end
	
	UpdateBuyerData()
end

local itemsST = false
local function DrawItemsGroup(container)

	if itemsST == false then
		local window  = container.frame
		itemsST = ScrollingTable:CreateST(itemsCols, 20, 16, nil, window)
		itemsST.frame:SetPoint("BOTTOMLEFT",window, 10,10)
		itemsST.frame:SetPoint("TOP", window, 0, -60)
		itemsST.frame:SetPoint("RIGHT", window, -10,0)
	end
	itemsST:Show()

	if container.parent then
		local width = 100
		for i, data in pairs_(itemsCols) do 
			width = width + data.width
		end
		container.parent:SetWidth(width);
	end
	
	UpdateItemsData()
end

function RefreshAllTables()--incase user still has the main window shown, this will update the tables when they change options.
	UpdateSalesData()
	UpdateBuyerData()
	UpdateItemsData()
end


function UpdateSalesData()
	if saleST then
		salesData = {} --reset
		
		local totalCopper = 0
		local success, who, data
		local secSinceWhen
		local totalSales = 0
--~ 		for i=1, table_getn(fR.sales) do 
		for i=1, table_getn(sales) do 
		
--~ 			success, item, money, buyer, when = core:Deserialize(fR.sales[i])
			success, item, money, buyer, when = core:Deserialize(sales[i])
			
			if success then
				secSinceWhen = SecondsSinceDateString(when)
				if P.filterWhen == 0 or secSinceWhen <= P.filterWhen then
					if P.showBuyers == 1 or (P.showBuyers == 2 and guildMembers[buyer]) or (P.showBuyers == 3 and friendsList[buyer]) or( P.showBuyers == 4 and fR.PoI[buyer]) then
				
				
						totalCopper = totalCopper + money
						totalSales = totalSales + 1
						table_insert(salesData, {
							cols = {
								{
									value = item, 
									color = GetItemColour
								}, 
								{
									value = function (copper)
										return CopperToCoins(copper)
									end,
									args = {money},
								},
								{
									value = buyer, 
									color=GetBuyerColour
								},
								{
									value = function (secondsSince, when)
										if P.relativeWhen == true then
											return SecondsToString(secondsSince).." "..L["ago"]
										else
											return when
										end
									end,
									args = {secSinceWhen, when},
								},
								
								--[[{
									value = "XXX", 
									color=onlineColorTable
								},]]
							}
						})
					end
				end
			end
		end

		if saleST.frame:IsShown() then
			displayFrame:SetStatusText(L["Sales"]..": "..whiteText:format(totalSales)..", "..L["Money"]..": "..CopperToCoins(totalCopper))
		end
		
		saleST:SetData(salesData)
	end
end


function UpdateBuyerData()
	if buyerST then
		buyerData = {} --reset
	
		local buyers = {}
		local buyerTotal = 0
		local secSinceWhen
		local success, item, money, buyer, when
--~ 		for i=1, table_getn(fR.sales) do 
		for i=1, table_getn(sales) do 
		
--~ 			success, item, money, buyer, when = core:Deserialize(fR.sales[i])
			success, item, money, buyer, when = core:Deserialize(sales[i])
			if success then
				secSinceWhen = SecondsSinceDateString(when)
				if P.filterWhen == 0 or secSinceWhen <= P.filterWhen then
					if P.showBuyers == 1 or (P.showBuyers == 2 and guildMembers[buyer]) or (P.showBuyers == 3 and friendsList[buyer]) or( P.showBuyers == 4 and fR.PoI[buyer]) then
			
						if not buyers[buyer] then
							buyers[buyer] = {items=0, money=0}
							buyerTotal = buyerTotal + 1
						end
						buyers[buyer].items = buyers[buyer].items + 1
						buyers[buyer].money = buyers[buyer].money + money
					end
				end
			end
		end
	
		for buyer, data in pairs_(buyers) do 
			table_insert(buyerData, {
				cols = {
					{
						value = buyer, 
						color = GetBuyerColour
					}, 
					{value = data.items},
					{
						value = function (copper)
							return CopperToCoins(copper)
						end,
						args = {data.money},
					},
				}
			})
		end
		
		if buyerST.frame:IsShown() then
			displayFrame:SetStatusText(L["Buyers"]..": "..whiteText:format(buyerTotal))
		end
		buyerST:SetData(buyerData)
	end
end

--~ 
function UpdateItemsData()
	if itemsST then
		itemsData = {} --reset
		local itemsTotal = 0
		local items = {}
		local secSinceWhen
		local success, item, money, buyer, when
		
--~ 		for i=1, table_getn(fR.sales) do 
		for i=1, table_getn(sales) do 
--~ 			success, item, money, buyer, when = core:Deserialize(fR.sales[i])
			success, item, money, buyer, when = core:Deserialize(sales[i])
			if success then
				secSinceWhen = SecondsSinceDateString(when)
				if P.filterWhen == 0 or secSinceWhen <= P.filterWhen then
					if P.showBuyers == 1 or (P.showBuyers == 2 and guildMembers[buyer]) or (P.showBuyers == 3 and friendsList[buyer]) or( P.showBuyers == 4 and fR.PoI[buyer]) then
			
						if not items[item] then
							items[item] = {sold=0, money=0}
							itemsTotal = itemsTotal + 1
						end
						items[item].sold = items[item].sold + 1
						items[item].money = items[item].money + money
					end
				end
			end
		end
	
		--Item, Sold, Money
		for itemName, data in pairs_(items) do 
			table_insert(itemsData, {
				cols = {
					{
						value = itemName, 
						color = GetItemColour
					}, 
					{value = data.sold},
					{
						value = function (copper)
							return CopperToCoins(copper)
						end,
						args = {data.money},
					},
					{
						value = function (copper)
							return CopperToCoins(copper)
						end,
						args = {data.money / data.sold},
					},
				}
			})
		end
		
		
		if itemsST.frame:IsShown() then
			displayFrame:SetStatusText(L["Items"]..": "..whiteText:format(itemsTotal))
		end
		itemsST:SetData(itemsData)
	end
end


-- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
   container:ReleaseChildren()
	if buyerST then buyerST:Hide() end
	if itemsST then itemsST:Hide() end
	if saleST then saleST:Hide() end
	
	if group == "tab1" then
		DrawSalesGroup(container)
	elseif group == "tab2" then
		DrawBuyersGroup(container)
	elseif group == "tab3" then
		DrawItemsGroup(container)
	end
end

displayFrame = false
function CreateOurFrames()--	/run MS.CreateOurFrames()
	if not displayFrame then
		-- Create the frame container
		displayFrame = AceGUI:Create("Frame")
		local window = displayFrame.frame;
		displayFrame:SetTitle(title)
		displayFrame:SetStatusText("AceGUI-3.0 Example Container Frame") --lol default text
--~ 		displayFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
		-- Fill Layout - the TabGroup widget will fill the whole frame
		displayFrame:SetLayout("Fill")
	
		window:SetHeight(470);
	
		local width = 80
		for i, data in pairs_(saleCols) do 
			width = width + data.width
		end
		window:SetWidth(width);
		
		-- Create the TabGroup
		local tab =  AceGUI:Create("TabGroup")
		tab:SetLayout("Flow")
		-- Setup which tabs to show
		tab:SetTabs({{text=L["Sales"], value="tab1"}, {text=L["Buyers"], value="tab2"}, {text=L["Items"], value="tab3"}})
		-- Register callback
		tab:SetCallback("OnGroupSelected", SelectGroup)
		-- Set initial Tab (this will fire the OnGroupSelected callback)
		tab:SelectTab("tab1")
		
		-- add to the frame container
		displayFrame:AddChild(tab)
	end

	
end

do
	local tostring = tostring
	local GetAddOnMetadata = GetAddOnMetadata
	local pairs = pairs
	local LibStub = LibStub
	
	function core:BuildAboutMenu()
		local options = core.CoreOptionsTable
		
		options.args.about = {
			type = "group",
			name = L.about,
			order = 99,
			args = {
			}
		}
		
		local fields = {"Author", "X-Category", "X-License", "X-Email", "Email", "eMail", "X-Website", "X-Credits", "X-Localizations", "X-Donate", "X-Bitcoin"}
		local haseditbox = {["X-Website"] = true, ["X-Email"] = true, ["X-Donate"] = true, ["Email"] = true, ["eMail"] = true, ["X-Bitcoin"] = true}
	
		local fNames = {
			["Author"] = L.author,
			["X-License"] = L.license,
			["X-Website"] = L.website,
			["X-Donate"] = L.donate,
			["X-Email"] = L.email,
			["X-Bitcoin"] = L.bitcoinAddress,
		}
		local yellow = "|cffffd100%s|r"
		
		
		
		options.args.about.args.title = {
			type = "description",
			name = yellow:format(L.title..": ")..core.title,
			order = 1,
		}
		options.args.about.args.version = {
			type = "description",
			name = yellow:format(L.version..": ")..core.version,
			order = 2,
		}
		options.args.about.args.notes = {
			type = "description",
			name = yellow:format(L.notes..": ")..tostring(GetAddOnMetadata(folder, "Notes")),
			order = 3,
		}
	
		for i,field in pairs(fields) do
			local val = GetAddOnMetadata(folder, field)
			if val then
				
				if haseditbox[field] then
					options.args.about.args[field] = {
						type = "input",
						name = fNames[field] or field,
						order = i+10,
						desc = L.clickCopy,
						width = "full",
						get = function(info)
							local key = info[#info]
							return GetAddOnMetadata(folder, key)
						end,	
					}
				else
					options.args.about.args[field] = {
						type = "description",
						name = yellow:format((fNames[field] or field)..": ")..val,
						width = "full",
						order = i+10,
					}
				end
		
			end
		end
	
		LibStub("AceConfig-3.0"):RegisterOptionsTable(core.title, options ) --
	end
end

