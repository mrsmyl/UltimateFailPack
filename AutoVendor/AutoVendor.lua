AV = LibStub("AceAddon-3.0"):NewAddon("AutoVendor", "AceConsole-3.0", "AceEvent-3.0")

local options = {
  name = "AutoVendor",
  handler = AV,
  type = 'group',
  args = {
  	enable = {
  		type = 'toggle',
  		order = 1,
  		name = 'Enabled',
  		desc = 'Enable or disable this addon.',
  		set = function(info, val) if (val) then AV:Enable() else AV:Disable() end end,
  		get = function(info) return AV.enabledState end,
  	},
  	empty = {
  		type = 'header',
  		order = 2,
  		cmdHidden = true,
  		dropdownHidden = true,
  		name = "Sales",
  	},
    soulbound = {
    	type = 'toggle',
    	order = 3,
    	name = 'Sell unusable soulbound gear',
    	desc = 'Sell armor and weapons that are soulbound and cannot be used by your class.',
    	disabled = function() return not AV.enabledState end,
    	set = function(info, val) AV.db.profile.soulbound = val; AV:ResetJunkCache() end,
    	get = function(info) return AV.db.profile.soulbound end,
    	width = 'full',
    	confirm = function(info, val) if val then return 'Are you sure you want to automatically sell all soulbound weapons and armor that you can not use?' else return false end end,
    },
    nonoptimal = {
    	type = 'toggle',
    	order = 4,
    	name = 'Sell non-optimal soulbound armor',
    	desc = 'Sell armor that is below your optimal armor (cloth/leather/mail for plate users, cloth/leather for mail users, cloth for leather users). Only works for players level 50 and higher.',
    	disabled = function() return not AV.enabledState end,
    	set = function(info, val) AV.db.profile.nonoptimal = val; AV:ResetJunkCache() end,
    	get = function(info) return AV.db.profile.nonoptimal end,
    	width = 'full',
    	confirm = function(info, val) if val then return 'Are you sure you want to automatically sell all soulbound armor that is not optimal for you?' else return false end end,
    },
    fortunecards = { 
    	type = 'toggle',
    	order = 5,
    	name = 'Sell cheap fortune cards',
    	desc = 'Sell fortune cards (gained by flipping Mysterious Fortune Cards or eating Fortune Cookies) that are cheap (i.e. all except the 1000g and 5000g ones).',
    	disabled = function() return not AV.enabledState end,
    	set = function(info, val) AV.db.profile.sellfortunecards = val; AV:ResetJunkCache() end,
    	get = function(info) return AV.db.profile.sellfortunecards end,
    	width = 'full',
    },
    verbosity = {
      type = 'select',
      order = 6,
      name = 'Verbosity',
      desc = 'How much information is displayed when accessing a vendor.',
      disabled = function() return not AV.enabledState end,
      values = {
      	none = 'None',
      	summary = 'Summary',
      	all = 'All',
      },
      set = 'SetVerbosity',
      get = 'GetVerbosity',
    },
  	empty2 = {
  		type = 'header',
  		order = 7,
  		cmdHidden = true,
  		dropdownHidden = true,
  		name = "Auto repair",
  	},
    autorepair = {
    	type = 'toggle',
    	order = 8,
    	name = 'Automatically repair',
    	desc = 'Automatically repair when visiting a vendor.',
    	disabled = function() return not AV.enabledState end,
    	set = function(info, val) AV.db.profile.autorepair = val end,
    	get = function(info) return AV.db.profile.autorepair end,
    	width = 'full',
    },
    guildbankrepair = {
    	type = 'toggle',
    	order = 9,
    	name = 'Use guild bank',
    	desc = 'Use the guild bank for auto-repair if available',
    	disabled = function() return not AV.enabledState or not AV.db.profile.autorepair end,
    	set = function(info, val) AV.db.profile.guildbankrepair = val end,
    	get = function(info) return AV.db.profile.guildbankrepair end,
    	width = 'full',
    },
    junk = {
    	type = 'input',
    	name = 'Toggle Junk',
    	desc = 'Toggles whether an item is on the "junk" list',
    	guiHidden = true,
    	dialogHidden = true,
    	dropdownHidden = true,
    	get = function() return listFormatWithoutPrint(AV.db.profile.junk) end,
    	set = function(info, val) AV:ToggleJunk(val, editbox) end,
    },
    notjunk = {
    	type = 'input',
    	name = 'Toggle NotJunk',
    	desc = 'Toggles whether an item is on the "not junk" list',
    	guiHidden = true,
    	dialogHidden = true,
    	dropdownHidden = true,
    	get = function() return listFormatWithoutPrint(AV.db.profile.notjunk) end,
    	set = function(info, val) AV:ToggleNotJunk(val, editbox) end,
    },
  },
}

local defaults = {
	profile = {
		verbosity = 'summary',
		autorepair = true,
		guildbankrepair = false,
		soulbound = false,
		sellnonoptimal = false,
		sellfortunecards = false,
		not_junk = {
			[1485] = "Pitchfork",
			[39202] = "Rusted Pitchfork",
			[3944] = "Twill Belt",
			[3945] = "Twill Boots",
			[3946] = "Twill Bracers",
			[3947] = "Twill Cloak",
			[8754] = "Twill Cover",
			[3948] = "Twill Gloves",
			[3949] = "Twill Pants",
			[3950] = "Twill Shoulderpads",
			[3951] = "Twill Vest",
			[18230] = "Broken I.W.I.N. Button",
			[33820] = "Weather-Beaten Fishing Hat",
			[38506] = "Don Carlos' Famous Hat",
		},
		junk = {
		},
	}
}

local updateBrokerDisplay = true
local totalSellValue = 0.0
local numSlots = 0
local itemsBOP = {} -- caching items so we don't have to scan tooltips all the time
local itemsJunk = {} -- caching which items are junk
local cheapestJunkItem = {}

function AV:ResetJunkCache()
	itemsJunk = {}
	cheapestJunkItem = {}
	updateBrokerDisplay = true
end

function AV:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AutoVendorDB", defaults)
	local parent = LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoVendor", options, {"autovendor", "av"})
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoVendor", "AutoVendor")
	profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoVendor.profiles", profiles)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoVendor.profiles", "Profiles", "AutoVendor")

	local UPDATEPERIOD, elapsed = 1, 0
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if ldb then
		local avDataObj = ldb:NewDataObject("AutoVendor", {type = "data source", text = "AutoVendor", icon = "Interface\\Icons\\Inv_Misc_MonsterScales_08"})
		local avF = CreateFrame("frame")
	
		avF:SetScript("OnUpdate", function(self, elap)
			elapsed = elapsed + elap
			if elapsed < UPDATEPERIOD then return end
		
			elapsed = 0
			local iconSize = select(2, GetChatWindowInfo(1)) - 2
			local repairCost = GetRepairAllCost()
			if repairCost >= 100 then
				repaircost = math.floor(repairCost / 100) * 100
			end
			if updateBrokerDisplay then
				totalSellValue, numSlots = AV:GetJunkAmount()
				if totalSellValue >= 100 then
					totalSellValue = math.floor(totalSellValue / 100) * 100
				end
				updateBrokerDisplay = false
			end
			avDataObj.text = "Repair: "..GetCoinTextureString(repairCost, iconSize).." / Junk: "..GetCoinTextureString(totalSellValue, iconSize).." ("..numSlots.." slots)"
			avDataObj.label = "AutoVendor"
		end)
	end
end

function AV:GetJunkAmount()
	local totalSellValue = 0
	local numSlots = 0
	
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and AV:IsJunk(link) then
				local itemCount = select(2, GetContainerItemInfo(bag, slot))
				local sellValue = itemCount * select(11, GetItemInfo(link))
				if sellValue > 0 then
					numSlots = numSlots + 1
					totalSellValue = totalSellValue + sellValue
				end

				if cheapestJunkItem["link"] == nil or cheapestJunkItem["price"] > sellValue then
					cheapestJunkItem["link"] = link
					cheapestJunkItem["price"] = sellValue
					cheapestJunkItem["bag"] = bag
					cheapestJunkItem["slot"] = slot
				end
			end
		end
	end
	
	return totalSellValue, numSlots
end

function AV:OnEnable()
	self:RegisterEvent("BAG_UPDATE")
  self:RegisterEvent("MERCHANT_SHOW")
  self:RegisterChatCommand("junklist", "JunkList")
  self:RegisterChatCommand("notjunklist", "NotJunkList")
  self:RegisterChatCommand("junk", "ToggleJunk")
  self:RegisterChatCommand("notjunk", "ToggleNotJunk")
  self:RegisterChatCommand("dropcheapest", "DropCheapest")
end

function AV:OnDisable()
end

function AV:SetVerbosity(info, val)
	self.db.profile.verbosity = val
	self:Print("Setting verbosity level to '"..val.."'.")
end

function AV:GetVerbosity(info)
	return self.db.profile.verbosity
end

local function listFormatWithoutPrint(list)
	local tmpList = {}
	for _,v in pairs(list) do
		table.insert(tmpList, v)
	end
	table.sort(tmpList)
	tmpString = ''
	for k,v in pairs(list) do
		local item_link = select(2, GetItemInfo(k))
		if item_link == nil then
			item_link = v
		end
		if #tmpString > 0 and #tmpString + #item_link <= 255 then
			tmpString = tmpString .. ', ' .. item_link
		else
			if #tmpString == 0 then
				tmpString = item_link
			else
				AV:Print(tmpString)
				tmpString = item_link
			end
		end
	end
	return tmpString
end

local function listFormat(list)
	tmpString = listFormatWithoutPrint(list)
	if #tmpString ~= 0 then
		AV:Print(tmpString)
	end
end

local function listRemove(list, item)
	found = false
	for k,v in pairs(list) do
		if string.lower(v) == string.lower(item) then
			list[k] = nil
			found = true
		end
	end
	return found
end

local function listToggle(list, listName, itemId, itemName)
	if list[itemId] then
		list[itemId] = nil
		AV:Print('Removed '..itemName..' from '..listName..'.')
	else
		table.insert(list, itemId, itemName)
		AV:Print('Added '..itemName..' to '..listName..'.')
	end
end

function AV:ToggleJunk(msg, editbox)
	if msg then
		self:ResetJunkCache()
		local itemId = tonumber(strmatch(msg, "item:(%d+)"))
		local itemName = select(1, GetItemInfo(msg))
		if itemId and itemName then
			listToggle(self.db.profile.junk, 'junk list', itemId, itemName)
		else
			if msg and listRemove(self.db.profile.junk, msg) then
				self:Print('Removed '..msg..' from junk list.')
			else
				self:Print('No item (link) supplied!')
			end
		end
	else
		self:Print('No item link supplied!')
	end
end

function AV:ToggleNotJunk(msg, editbox)
	if msg then
		self:ResetJunkCache()
		local itemId = tonumber(strmatch(msg, "item:(%d+)"))
		local itemName = select(1, GetItemInfo(msg))
		if itemId and itemName then
			listToggle(self.db.profile.not_junk, 'not junk list', itemId, itemName)
		else
			if msg and listRemove(self.db.profile.not_junk, msg) then
				self:Print('Removed '..msg..' from not junk list.')
			else
				self:Print('No item (link) supplied!')
			end
		end
	else
		self:Print('No item (link) supplied!')
	end
end

function AV:JunkList(msg, editbox)
	local empty = true
	for _,_ in pairs(self.db.profile.junk) do
		empty = false
	end
	if empty then
		self:Print('The junk list is empty.')
	else
		self:Print('Items in the junk list:')
	end
	listFormat(self.db.profile.junk)
end

function AV:NotJunkList(msg, editbox)
	local empty = true
	for _,_ in pairs(self.db.profile.not_junk) do
		empty = false
	end
	if empty then
		self:Print('The not-junk list is empty.')
	else
		self:Print('Items in the not junk list:')
	end
	listFormat(self.db.profile.not_junk)
end

function AV:DropCheapest(msg, editbox)
	if cheapestJunkItem["link"] ~= nil then
		self:Print("Throwing away "..cheapestJunkItem["link"]..".")
		if not CursorHasItem() then
			PickupContainerItem(cheapestJunkItem["bag"], cheapestJunkItem["slot"])
			DeleteCursorItem()
		end
	else 
		self:Print("You are not carrying any junk!")
	end
end

function AV:IsJunk(link)
	local itemId = tonumber(strmatch(link, "item:(%d+)"))
	
	if itemId == nil then
		return false
	else
		if itemsJunk[itemId] == nil then
			itemsJunk[itemId] = self:ShouldSell(link)
		end
		
		return itemsJunk[itemId]
	end
end

function AV:ShouldSell(link)
	local itemId = tonumber(strmatch(link, "item:(%d+)"))
	local _, _, itemQuality, itemLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(link)
	
	-- Noboru's Cudgel
	if itemId == 6196 then 
		return false 
	end 
	
	if itemQuality == 5 then
		return false
	end
	
	-- item is in the "always sell" list
	if self.db.profile.junk[itemId] then
		return true
	end
	
	-- item is in the "never sell" list
	if self.db.profile.not_junk[itemId] then
		return false
	end
	
	if self.db.profile.sellfortunecards and AV_FORTUNE_CARDS[itemId] == true then
		return true;
	end
	
	-- item is level 1, don't sell
	if itemLevel == 1 and itemQuality ~= 0 then
		return false
	end

	if self.db.profile.soulbound then
		local _,class = UnitClass('player')
	
		if itemType == 'Weapon' or itemType == 'Armor' then
			if itemsBOP[itemId] == nil then
				local f = CreateFrame('GameTooltip', 'AVTooltip', UIParent, 'GameTooltipTemplate')
				f:SetOwner(UIParent, 'ANCHOR_NONE')
				f:SetHyperlink(link)
				itemsBOP[itemId] = (AVTooltipTextLeft2:GetText() == ITEM_BIND_ON_PICKUP) or (AVTooltipTextLeft3:GetText() == ITEM_BIND_ON_PICKUP) or (AVTooltipTextLeft4:GetText() == ITEM_BIND_ON_PICKUP)
				f:Hide()
			end

			if itemsBOP[itemId] and AV:CannotUse(class, itemType, itemSubType) then
				return true
			end
		end
	end

	if self.db.profile.nonoptimal and UnitLevel('player') > 49 then
		local _,class = UnitClass('player')
		
		if itemType == 'Armor' and itemEquipLoc ~= 'INVTYPE_CLOAK' then
			local f = CreateFrame('GameTooltip', 'AVTooltip', UIParent, 'GameTooltipTemplate')
			f:SetOwner(UIParent, 'ANCHOR_NONE')
			f:SetHyperlink(link)
			if AVTooltipTextLeft2:GetText() == ITEM_BIND_ON_PICKUP or AVTooltipTextLeft3:GetText() == ITEM_BIND_ON_PICKUP or AVTooltipTextLeft4:GetText() == ITEM_BIND_ON_PICKUP then
				if AV:NonOptimal(class, itemType, itemSubType) then
					return true
				end
			end
			
			-- finally hide it again
			f:Hide()
		end
	end
	
	-- item is grey
	if itemQuality == 0 then
		return true
	else
		return false
	end
end

function AV:MERCHANT_SHOW()
	local iconSize = select(2, GetChatWindowInfo(1)) - 2
	local totalSellValue = 0
	local totalItemsSold = 0
	local repairCost = 0
	local usedGuildBankRepair = false

	if self.db.profile.autorepair and CanMerchantRepair() then
		repairCost, canRepair = GetRepairAllCost()
		if canRepair then
			if self.db.profile.guildbankrepair and GetGuildBankWithdrawMoney() >= repairCost then
				usedGuildBankRepair = true
				RepairAllItems(1)
			else
				RepairAllItems(0)
			end
		end
	end

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link then
				local itemId = tonumber(strmatch(link, "item:(%d+)"))
				if AV:IsJunk(link) then
					local itemCount = select(2, GetContainerItemInfo(bag, slot))
					local sellValue = itemCount * select(11, GetItemInfo(link))
					if sellValue > 0 then
						totalSellValue = totalSellValue + sellValue
						totalItemsSold = totalItemsSold + 1
						ShowMerchantSellCursor(1)
						UseContainerItem(bag, slot)
						if self.db.profile.verbosity == 'all' then
							self:Print(format("Selling %sx%d for %s.", link, itemCount, GetCoinTextureString(sellValue, iconSize)))
						end
					else
						if self.db.profile.verbosity == 'all' then
							self:Print(format("%s has no vendor worth, so you might want to destroy it yourself.", link))
						end
					end
				end
			end
		end
	end
	if self.db.profile.verbosity == 'all' or self.db.profile.verbosity == 'summary' then
		if totalItemsSold > 0 then
			local items = 'items'
			if totalItemsSold == 1 then
				items = 'item'
			end
			self:Print(format("Automatically sold %d %s for %s.", totalItemsSold, items, GetCoinTextureString(totalSellValue, iconSize)))
		end
		if repairCost > 0 then
			if usedGuildBankRepair then
				self:Print(format("Repaired all items for %s (from Guild Bank).", GetCoinTextureString(repairCost, iconSize)))
			else
				self:Print(format("Repaired all items for %s.", GetCoinTextureString(repairCost, iconSize)))
			end
		end
	end
end

function AV:BAG_UPDATE()
	cheapestJunkItem = {}
	updateBrokerDisplay = true
end

function AV:CannotUse(class, itemType, itemSubType)
	for _,v in pairs(AV_UNUSABLE_ITEMS[class][itemType]) do
		if itemSubType == v then
			return true
		end
	end
	return false
end

function AV:NonOptimal(class, itemType, itemSubType)
	for _,v in pairs(AV_NON_OPTIMAL_ITEMS[class][itemType]) do
		if itemSubType == v then
			return true
		end
	end
	return false
end

AV_UNUSABLE_ITEMS = {
	['DEATHKNIGHT'] = {
		['Armor'] = { 'Shields', 'Librams', 'Idols', 'Totems' },
		['Weapon'] = { 'Bows', 'Guns', 'Staves', 'Fist Weapons', 'Daggers', 'Thrown', 'Crossbows', 'Wands' },
	},
	['DRUID'] = {
		['Armor'] = { 'Mail', 'Plate', 'Shields', 'Librams', 'Totems', 'Sigils' },
		['Weapon'] = { 'One-Handed Axes', 'Two-Handed Axes', 'Bows', 'Guns', 'One-Handed Swords', 'Two-Handed Swords', 'Thrown', 'Crossbows', 'Wands' },
	},
	['HUNTER'] = {
		['Armor'] = { 'Plate', 'Shields', 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'One-Handed Maces', 'Two-Handed Maces', 'Wands' },
	},
	['MAGE'] = {
		['Armor'] = { 'Leather', 'Mail', 'Plate', 'Shields', 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'One-Handed Axes', 'Two-Handed Axes', 'Bows', 'Guns', 'One-Handed Maces', 'Two-Handed Maces', 'Polearms', 'Two-Handed Swords', 'Fist Weapons', 'Thrown', 'Crossbows' },
	},
	['MONK'] = {
		['Armor'] = { 'Idols', 'Totems', 'Shields', 'Sigils' },
		['Weapon'] = { 'Bows', 'Guns', 'Daggers', 'Thrown', 'Crossbows', 'Wands', 'Two-Handed Axes', 'Two-Handed Swords', 'Two-Handed Maces' },
	},
	['PALADIN'] = {
		['Armor'] = { 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'Bows', 'Guns', 'Staves', 'Fist Weapons', 'Daggers', 'Thrown', 'Crossbows', 'Wands' },
	},
	['PRIEST'] = {
		['Armor'] = { 'Leather', 'Mail', 'Plate', 'Shields', 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'One-Handed Axes', 'Two-Handed Axes', 'Bows', 'Guns', 'Two-Handed Maces', 'Polearms', 'One-Handed Swords', 'Two-Handed Swords', 'Fist Weapons', 'Thrown', 'Crossbows' },
	},
	['ROGUE'] = {
		['Armor'] = { 'Mail', 'Plate', 'Shields', 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'Two-Handed Axes', 'Two-Handed Maces', 'Polearms', 'Two-Handed Swords', 'Staves', 'Wands' },
	},
	['SHAMAN'] = {
		['Armor'] = { 'Plate', 'Librams', 'Idols', 'Sigils' },
		['Weapon'] = { 'Bows', 'Guns', 'Polearms', 'One-Handed Swords', 'Two-Handed Swords', 'Thrown', 'Crossbows', 'Wands' },
	},
	['WARLOCK'] = {
		['Armor'] = { 'Leather', 'Mail', 'Plate', 'Shields', 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'One-Handed Axes', 'Two-Handed Axes', 'Bows', 'Guns', 'One-Handed Maces', 'Two-Handed Maces', 'Polearms', 'Two-Handed Swords', 'Fist Weapons', 'Thrown', 'Crossbows' },
	},
	['WARRIOR'] = {
		['Armor'] = { 'Librams', 'Idols', 'Totems', 'Sigils' },
		['Weapon'] = { 'Wands' },
	},
}

AV_NON_OPTIMAL_ITEMS = {
	['DEATHKNIGHT'] = {
		['Armor'] = { 'Cloth', 'Leather', 'Mail' },
	},
	['DRUID'] = {
		['Armor'] = { 'Cloth' },
	},
	['HUNTER'] = {
		['Armor'] = { 'Cloth', 'Leather' },
	},
	['MAGE'] = {
		['Armor'] = { },
	},
	['MONK'] = {
		['Armor'] = { 'Cloth' },
	},
	['PALADIN'] = {
		['Armor'] = { 'Cloth', 'Leather', 'Mail' },
	},
	['PRIEST'] = {
		['Armor'] = { },
	},
	['ROGUE'] = {
		['Armor'] = { 'Cloth' },
	},
	['SHAMAN'] = {
		['Armor'] = { 'Cloth', 'Leather' },
	},
	['WARLOCK'] = {
		['Armor'] = { },
	},
	['WARRIOR'] = {
		['Armor'] = { 'Cloth', 'Leather', 'Mail' },
	},
}

AV_FORTUNE_CARDS = { 
	[62590] = true,
	[60845] = true,
	[62606] = true,
	[60842] = true,
	[60841] = true,
	[62602] = true,
	[62603] = true,
	[62604] = true,
	[62605] = true,
	[60839] = true,
	[62598] = true,
	[62599] = true,
	[62600] = true,
	[62601] = true,
	[62246] = true,
	[62577] = true,
	[62578] = true,
	[62579] = true,
	[62580] = true,
	[62581] = true,
	[62582] = true,
	[62583] = true,
	[62584] = true,
	[62585] = true,
	[62586] = true,
	[62587] = true,
	[62588] = true,
	[62589] = true,
	[60843] = true,
	[62591] = true,
	[62247] = true,
	[62552] = true,
	[62553] = true,
	[62554] = true,
	[62555] = true,
	[62556] = true,
	[62557] = true,
	[62558] = true,
	[62559] = true,
	[62560] = true,
	[62561] = true,
	[62562] = true,
	[62563] = true,
	[62564] = true,
	[62565] = true,
	[62566] = true,
	[62567] = true,
	[62568] = true,
	[62569] = true,
	[62570] = true,
	[62571] = true,
	[62572] = true,
	[62573] = true,
	[62574] = true,
	[62575] = true,
	[62576] = true,
}