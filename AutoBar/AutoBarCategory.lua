--
-- AutoBarProfile
-- Copyright 2007+ Toadkiller of Proudmoore.
--
-- Categories for AutoBar
-- A Category encapsulates a list of items / spells etc. along with metadata describing their use.
-- http://muffinmangames.com
--

--	PeriodicGroup
--		description
--		texture
--		targeted
--		nonCombat
--		location
--		battleground
--		notUsable (soul shards, arrows, etc.)
--		flying

--	AutoBar
--		spell
--		limit

local AutoBar = AutoBar
local spellNameList = AutoBar.spellNameList
local spellIconList = AutoBar.spellIconList

local REVISION = tonumber(("$Revision: 1.4 $"):match("%d+"))
if AutoBar.revision < REVISION then
	AutoBar.revision = REVISION
	AutoBar.date = ('$Date: 2010/12/22 04:28:17 $'):match('%d%d%d%d%-%d%d%-%d%d')
end


AutoBarCategoryList = {}

local L = AutoBar.locale
local PT = LibStub("LibPeriodicTable-3.1")
local AceOO = AceLibrary("AceOO-2.0")
local _

-- List of categoryKey, category.description pairs for button categories
AutoBar.categoryValidateList = {}

	--DeathKnight
	spellNameList["Bone Shield"] = AutoBar:LoggedGetSpellInfo(49222)
	spellNameList["Horn of Winter"] = AutoBar:LoggedGetSpellInfo(57330)
	
	--Druid
	spellNameList["Barkskin"] = AutoBar:LoggedGetSpellInfo(22812)
	spellNameList["Disorienting Roar"] = AutoBar:LoggedGetSpellInfo(99)
	spellNameList["Faerie Fire"] = AutoBar:LoggedGetSpellInfo(770)
	spellNameList["Mark of the Wild"], _, spellIconList["Mark of the Wild"] = AutoBar:LoggedGetSpellInfo(1126)
	spellNameList["Nature's Grasp"] = AutoBar:LoggedGetSpellInfo(16689)
	spellNameList["Ironbark"] = AutoBar:LoggedGetSpellInfo(102342)
	spellNameList["Heart of the Wild"] = AutoBar:LoggedGetSpellInfo(108288)

	--Hunter
	spellNameList["Aspect of the Cheetah"] = AutoBar:LoggedGetSpellInfo(5118)
	spellNameList["Aspect of the Hawk"], _, spellIconList["Aspect of the Hawk"] = AutoBar:LoggedGetSpellInfo(13165)
	spellNameList["Aspect of the Pack"] = AutoBar:LoggedGetSpellInfo(13159)
	spellNameList["Aspect of the Iron Hawk"] = AutoBar:LoggedGetSpellInfo(109260)
	spellNameList["Kill Command"] = AutoBar:LoggedGetSpellInfo(34026)
	spellNameList["Bestial Wrath"] = AutoBar:LoggedGetSpellInfo(19574)
	spellNameList["Mend Pet"] = AutoBar:LoggedGetSpellInfo(136)
	spellNameList["Intimidation"] = AutoBar:LoggedGetSpellInfo(7093)
	spellNameList["Master's Call"] = AutoBar:LoggedGetSpellInfo(53271)
	spellNameList["Feed Pet"], _, spellIconList["Feed Pet"] = AutoBar:LoggedGetSpellInfo(6991)

	--Mage
	spellNameList["Arcane Brilliance"] = AutoBar:LoggedGetSpellInfo(1459)
	spellNameList["Dalaran Brilliance"] = AutoBar:LoggedGetSpellInfo(61316)
	spellNameList["Ice Ward"] = AutoBar:LoggedGetSpellInfo(111264)
	spellNameList["Frost Armor"] = AutoBar:LoggedGetSpellInfo(7302)
	spellNameList["Ice Barrier"], _, spellIconList["Ice Barrier"] = AutoBar:LoggedGetSpellInfo(11426)
	spellNameList["Mage Armor"] = AutoBar:LoggedGetSpellInfo(6117)
	spellNameList["Temporal Shield"] = AutoBar:LoggedGetSpellInfo(115610)
	spellNameList["Incanter's Ward"] = AutoBar:LoggedGetSpellInfo(1463)
	spellNameList["Molten Armor"] = AutoBar:LoggedGetSpellInfo(30482)
	spellNameList["Slow Fall"] = AutoBar:LoggedGetSpellInfo(130)
	spellNameList["Conjure Refreshment"] = AutoBar:LoggedGetSpellInfo(42955)
	spellNameList["Conjure Refreshment Table"] = AutoBar:LoggedGetSpellInfo(43987)
	spellNameList["Conjure Mana Gem"] = AutoBar:LoggedGetSpellInfo(759)

	--Monk
	spellNameList["Legacy of the Emperor"] = AutoBar:LoggedGetSpellInfo(115921)
	spellNameList["Legacy of the White Tiger"] = AutoBar:LoggedGetSpellInfo(116781)

	--Paladin
	spellNameList["Blessing of Kings"] = AutoBar:LoggedGetSpellInfo(20217) --*
	spellNameList["Blessing of Might"] = AutoBar:LoggedGetSpellInfo(19740) --*
	spellNameList["Divine Protection"] = AutoBar:LoggedGetSpellInfo(498) --*
	spellNameList["Divine Shield"] = AutoBar:LoggedGetSpellInfo(642) --*
	spellNameList["Hand of Freedom"] = AutoBar:LoggedGetSpellInfo(1044) --*
	spellNameList["Hand of Protection"] = AutoBar:LoggedGetSpellInfo(1022) --*
	spellNameList["Hand of Sacrifice"] = AutoBar:LoggedGetSpellInfo(6940) --*
	spellNameList["Hand of Salvation"] = AutoBar:LoggedGetSpellInfo(1038) --*
	spellNameList["Seal of Insight"], _, spellIconList["Seal of Insight"] = AutoBar:LoggedGetSpellInfo(20165)
	spellNameList["Seal of Justice"] = AutoBar:LoggedGetSpellInfo(20164)
	spellNameList["Seal of Righteousness"] = AutoBar:LoggedGetSpellInfo(20154)
	spellNameList["Seal of Truth"] = AutoBar:LoggedGetSpellInfo(31801)

	--Priest
	spellNameList["Fear Ward"] = AutoBar:LoggedGetSpellInfo(6346)
	spellNameList["Inner Fire"] = AutoBar:LoggedGetSpellInfo(588)
	spellNameList["Inner Will"] = AutoBar:LoggedGetSpellInfo(73413)
	spellNameList["Power Word: Fortitude"] = AutoBar:LoggedGetSpellInfo(13864)
	spellNameList["Power Word: Shield"] = AutoBar:LoggedGetSpellInfo(17)
	
	--Rogue
	spellNameList["Evasion"] = AutoBar:LoggedGetSpellInfo(4086)
	spellNameList["Deadly Poison"], _, spellIconList["Deadly Poison"] = AutoBar:LoggedGetSpellInfo(2823)
	spellNameList["Wound Poison"] = AutoBar:LoggedGetSpellInfo(8679)
	spellNameList["Crippling Poison"] = AutoBar:LoggedGetSpellInfo(3408)
	spellNameList["Mind-numbing Poison"], _, spellIconList["Mind-numbing Poison"] = AutoBar:LoggedGetSpellInfo(5761)
	spellNameList["Leeching Poison"] = AutoBar:LoggedGetSpellInfo(108211)
	spellNameList["Paralytic Poison"] = AutoBar:LoggedGetSpellInfo(108215)

	--Shaman
	spellNameList["Earth Shield"] = AutoBar:LoggedGetSpellInfo(379)
	spellNameList["Lightning Shield"] = AutoBar:LoggedGetSpellInfo(324)
	spellNameList["Water Shield"] = AutoBar:LoggedGetSpellInfo(52127)
	spellNameList["Water Walking"] = AutoBar:LoggedGetSpellInfo(546)
	spellNameList["Feral Spirit"] = AutoBar:LoggedGetSpellInfo(51533)
	spellNameList["Ancestral Swiftness"] = AutoBar:LoggedGetSpellInfo(16188)

	--Warlock
	spellNameList["Curse of Exhaustion"] = AutoBar:LoggedGetSpellInfo(18223)
	spellNameList["Curse of Enfeeblement"], _, spellIconList["Curse of Enfeeblement"] = AutoBar:LoggedGetSpellInfo(109466)
	spellNameList["Curse of the Elements"] = AutoBar:LoggedGetSpellInfo(1490)
	spellNameList["Twilight Ward"] = AutoBar:LoggedGetSpellInfo(6229)
	spellNameList["Sacrificial Pact"] = AutoBar:LoggedGetSpellInfo(108416)
	spellNameList["Dark Bargain"] = AutoBar:LoggedGetSpellInfo(110913)
	spellNameList["Unending Resolve"] = AutoBar:LoggedGetSpellInfo(104773)
	spellNameList["Soul Link"] = AutoBar:LoggedGetSpellInfo(108415)
	spellNameList["Unending Breath"] = AutoBar:LoggedGetSpellInfo(5697)
	spellNameList["Dark Intent"] = AutoBar:LoggedGetSpellInfo(109773) 
	spellNameList["Soulstone"] = AutoBar:LoggedGetSpellInfo(20707) 
	spellNameList["Command Demon"] = AutoBar:LoggedGetSpellInfo(119898) 
	spellNameList["Grimoire of Service"] = AutoBar:LoggedGetSpellInfo(108501) 
	spellNameList["Grimoire of Sacrifice"] = AutoBar:LoggedGetSpellInfo(108503) 
	
	--Warrior
	spellNameList["Shield Block"] = AutoBar:LoggedGetSpellInfo(2565) --*
	spellNameList["Shield Wall"] = AutoBar:LoggedGetSpellInfo(871) --*
	spellNameList["Demoralizing Shout"] = AutoBar:LoggedGetSpellInfo(1160)
	spellNameList["Battle Shout"] = AutoBar:LoggedGetSpellInfo(6673)
	spellNameList["Commanding Shout"] = AutoBar:LoggedGetSpellInfo(469)
	spellNameList["Berserker Stance"], _, spellIconList["Berserker Stance"] = AutoBar:LoggedGetSpellInfo(2458)
	spellNameList["Defensive Stance"] = AutoBar:LoggedGetSpellInfo(71)
	spellNameList["Battle Stance"] = AutoBar:LoggedGetSpellInfo(2457)




local function sortList(a, b)
	local x = tonumber(a[2]);
	local y = tonumber(b[2]);

	if (x == y) then
		if (a[3]) then
			return false;
		else
			if (b[3]) then
				return true;
			else
				return false;
			end
		end
	else
		return x < y;
	end
end


local function castListPairs(castList)
	local i = -1

	return function ()
		i = i + 2
		if (castList[i]) then
			return i, castList[i], castList[i + 1]
		end
	end
end


-- Mandatory attributes:
--		description - localized description
--		texture - display icon texture
-- Optional attributes:
--		targeted, nonCombat, location, battleground, notUsable
AutoBarCategory = AceOO.Class()
AutoBarCategory.virtual = true

function AutoBarCategory.prototype:init(description, texture)
	AutoBarCategory.super.prototype.init(self) -- Mandatory init.
	self.categoryKey = description

	self.description = L[description]
	self.texture = texture
end

-- True if items can be targeted
function AutoBarCategory.prototype:SetTargeted(targeted)
	self.targeted = targeted
end

-- True if only usable outside combat
function AutoBarCategory.prototype:SetNonCombat(nonCombat)
	self.nonCombat = nonCombat
end

-- True if item is location specific
function AutoBarCategory.prototype:SetLocation(location)
	self.location = location
end

-- True if item is usable anywhere, including battlegrounds
function AutoBarCategory.prototype:SetAnywhere(anywhere)
	self.anywhere = anywhere
end

-- True if item is for battlegrounds only
function AutoBarCategory.prototype:SetBattleground(battleground)
	self.battleground = battleground
end

-- True if item is not usable (soul shards, arrows, etc.)
function AutoBarCategory.prototype:SetNotUsable(notUsable)
	self.notUsable = notUsable
end

-- True if item is not usable (soul shards, arrows, etc.)
function AutoBarCategory.prototype:SetNoSpellCheck(noSpellCheck)
	self.noSpellCheck = noSpellCheck
end


-- Convert rawList to a simple array of itemIds, ordered by their value in the set, and priority if any
function AutoBarCategory.prototype:RawItemsConvert(rawList)
	local itemArray = {}
	table.sort(rawList, sortList)
	for i, j in ipairs(rawList) do
		itemArray[i] = j[1]
	end
	return itemArray
end


-- Add items from set to rawList
-- If priority is true, the items will have priority over non-priority items with the same values
function AutoBarCategory.prototype:RawItemsAdd(rawList, set, priority)
	if (not rawList) then
		rawList = {}
	end
	if (set) then
		local cacheSet = PT:GetSetTable(set)
		if (cacheSet) then
			local index = # rawList + 1
			for itemId, value in PT:IterateSet(set) do
				if (not value or type(value) == "boolean") then
					value = 0;
				end
				value = tonumber(value)
				rawList[index] = {itemId, value, priority}
				index = index + 1
			end
		else
			print("AutoBar could not find the PT3.1 set ", set, ".  Make sure you have all the libraries AutoBar needs to function.")
		end
	end
	return rawList
end

-- Return nil or list of spells matching player class
-- itemsPerLine defaults to 2 (class type, spell).
-- Only supports 2 & 3 for now.
-- ToDo: generalize for more per line.
function AutoBarCategory:FilterClass(castList, itemsPerLine)
	local spellName, index, filteredList2, filteredList3
	if (not itemsPerLine) then
		itemsPerLine = 2
	end

	-- Filter out CLASS spells from castList
	index = 1
	for i = 1, # castList, itemsPerLine do
		if (AutoBar.CLASS == castList[i] or "*" == castList[i]) then
			spellName = castList[i + 1]
			if (not filteredList2) then
				filteredList2 = {}
			end
			if (itemsPerLine == 3 and not filteredList3) then
				filteredList3 = {}
			end
			filteredList2[index] = spellName
			if (itemsPerLine == 3) then
				spellName = castList[i + 2]
				filteredList3[index] = spellName
			end
			index = index + 1
		end
	end
	return filteredList2, filteredList3
end

-- Convert list of negative numbered spellId to spellName.
function AutoBarCategory:FilterPTSpells(castList)
	local spellName
--print("AutoBarCategory:FilterClass castList " .. tostring(castList))

	-- Filter out CLASS spells from castList
	for i = 1, # castList do
		local spellId = castList[i] * -1
		spellName = GetSpellInfo(spellId)
		castList[i] = spellName
	end
	return castList
end

-- Top castable item from castList will cast on RightClick
function AutoBarCategory.prototype:SetCastList(castList)
--AutoBar:Print("AutoBarCategory.prototype:SetCastList " .. description .. " castList " .. tostring(castList))
	if (castList) then
		self.spells = castList
		local noSpellCheck = self.noSpellCheck
		for index, spellName in ipairs(castList) do
--AutoBar:Print("AutoBarCategory.prototype:SetCastList " .. tostring(spellName))
			AutoBarSearch:RegisterSpell(spellName, noSpellCheck)
			if (AutoBarSearch:CanCastSpell(spellName)) then	-- TODO: update on leveling in case new spell aquired
--AutoBar:Print("AutoBarCategory.prototype:SetCastList castable " .. tostring(spellName))
				self.castSpell = spellName
			end
		end
	else
		self.spells = nil
		self.castSpell = nil
	end
end

-- Reset the item list based on changed settings.
-- So pet change, Spellbook changed for spells, etc.
function AutoBarCategory.prototype:Refresh()
end

-- Add a spell to the list.
-- spellNameRight specifies a separate spell to cast on right click
function AutoBarCategory.prototype:AddSpell(spellNameLeft, spellNameRight, itemsIndex)
	local noSpellCheck = self.noSpellCheck
	if (spellNameLeft) then
		if (not noSpellCheck) then
			spellNameLeft = GetSpellInfo(spellNameLeft)
		end
		if (not self.items) then
			self.items = {}
		end
	end
	if (spellNameRight) then
		if (not noSpellCheck) then
			spellNameRight = GetSpellInfo(spellNameRight)
		end
		if (not self.itemsRightClick) then
			self.itemsRightClick = {}
		end
	end

	if (spellNameLeft) then
		AutoBarSearch:RegisterSpell(spellNameLeft, noSpellCheck)
		self.items[itemsIndex] = spellNameLeft
		if (spellNameRight) then
			AutoBarSearch:RegisterSpell(spellNameRight, noSpellCheck)
			self.itemsRightClick[spellNameLeft] = spellNameRight
--AutoBar:Print("AutoBarCategory.prototype:AddSpell castable spellNameLeft " .. tostring(spellNameLeft) .. " spellNameRight " .. tostring(spellNameRight))
--		else
--			self.itemsRightClick[spellNameLeft] = spellNameLeft
--AutoBar:Print("AutoBarCategory.prototype:AddSpell castable spellNameLeft " .. tostring(spellNameLeft))
		end
		itemsIndex = itemsIndex + 1
	elseif (spellNameRight) then
		AutoBarSearch:RegisterSpell(spellNameRight, noSpellCheck)
		self.items[itemsIndex] = spellNameRight
		self.itemsRightClick[spellNameRight] = spellNameRight
		itemsIndex = itemsIndex + 1
	end
	return itemsIndex
end


-- Category consisting of regular items, defined by PeriodicTable sets
AutoBarItems = AceOO.Class(AutoBarCategory)

-- ptItems, ptPriorityItems are PeriodicTable sets
-- priorityItems sort higher than items at the same value
function AutoBarItems.prototype:init(description, shortTexture, ptItems, ptPriorityItems)
	AutoBarItems.super.prototype.init(self, description, "Interface\\Icons\\" .. shortTexture) -- Mandatory init.
	self.ptItems = ptItems
	self.ptPriorityItems = ptPriorityItems

	local rawList = nil
	rawList = self:RawItemsAdd(rawList, ptItems, false)
	if (ptPriorityItems) then
		rawList = self:RawItemsAdd(rawList, ptPriorityItems, true)
	end
	self.items = self:RawItemsConvert(rawList)
end

-- Reset the item list based on changed settings.
function AutoBarItems.prototype:Refresh()
end


local spellFeedPet = AutoBar:LoggedGetSpellInfo(6991)

-- Category consisting of regular items
AutoBarPetFood = AceOO.Class(AutoBarItems)

-- ptItems, ptPriorityItems are PeriodicTable sets
-- priorityItems sort higher than items at the same value
function AutoBarPetFood.prototype:init(description, shortTexture, ptItems, ptPriorityItems)
	AutoBarPetFood.super.prototype.init(self, description, "Interface\\Icons\\" .. shortTexture, ptItems, ptPriorityItems)

	self.castSpell = spellFeedPet
end

-- Reset the item list based on changed settings.
function AutoBarPetFood.prototype:Refresh()
end


-- Category consisting of spells
AutoBarSpells = AceOO.Class(AutoBarCategory)

-- castList, is of the form:
-- { "DRUID", "Flight Form", "DRUID", "Swift Flight Form", ["<class>", "<localized spell name>",] ... }
-- rightClickList, is of the form:
-- { "DRUID", "Mark of the Wild", "Gift of the Wild", ["<class>", "<localized spell name left click>", "<localized spell name right click>",] ... }
-- Pass in only one of castList, rightClickList
-- Icon from castList is used unless not available but rightClickList is
function AutoBarSpells.prototype:init(description, texture, castList, rightClickList, ptItems)
	AutoBarSpells.super.prototype.init(self, description, texture) -- Mandatory init.
	local spellName, index

--	AutoBar:StupidLogEnable(description == "Spell.Class.Buff")	
--	AutoBar:StupidLog("\nAutoBarSpells.prototype:init " .. description .. " castList " .. tostring(castList) .. "\n")
--	AutoBar:StupidLog(AutoBar:Dump(castList))

	-- Filter out non CLASS spells from castList and rightClickList
	if (castList) then
		self.castList = AutoBarCategory:FilterClass(castList)
--		AutoBar:StupidLog("\n\nFiltered List:\n")
--		AutoBar:StupidLog(AutoBar:Dump(self.castList))
	end
	if (rightClickList) then
		self.castList, self.rightClickList = AutoBarCategory:FilterClass(rightClickList, 3)
	end
	if (pt3List) then
		local rawList = nil
		rawList = self:RawItemsAdd(rawList, ptItems, false)
		self.castList = self:RawItemsConvert(rawList)
		self.castList = AutoBarCategory:FilterPTSpells(self.castList)
	end

	-- Populate items based on currently castable spells
	self.items = {}
	if (self.rightClickList and not self.itemsRightClick) then
		self.itemsRightClick = {}
	end
	self:Refresh()
	
--		AutoBar:StupidLogEnable(false)	

end

-- Reset the item list based on changed settings.
function AutoBarSpells.prototype:Refresh()
	local itemsIndex = 1
assert(self.items, "AutoBarSpells.prototype:Refresh wtff")
	if (self.castList and self.rightClickList) then
		for spellName in pairs(self.itemsRightClick) do
			self.itemsRightClick[spellName] = nil
		end

		for i = 1, # self.castList, 1 do
			local spellNameLeft, spellNameRight = self.castList[i], self.rightClickList[i]
--AutoBar:Print("AutoBarSpells.prototype:Refresh spellNameLeft " .. tostring(spellNameLeft) .. " spellNameRight " .. tostring(spellNameRight))
			itemsIndex = AutoBarSpells.super.prototype.AddSpell(self, spellNameLeft, spellNameRight, itemsIndex)
		end
		for i = itemsIndex, # self.items, 1 do
			self.items[i] = nil
		end
	elseif (self.castList) then
		for i, spellName in ipairs(self.castList) do
			if (spellName) then
				itemsIndex = AutoBarSpells.super.prototype.AddSpell(self, spellName, nil, itemsIndex)
			end
		end
		for i = itemsIndex, # self.items, 1 do
			self.items[i] = nil
		end
	end
end


-- Custom Category
AutoBarCustom = AceOO.Class(AutoBarCategory)

-- Return a unique key to use
function AutoBarCustom:GetCustomKey(customCategoryName)
	local newKey = "Custom" .. customCategoryName
	return newKey
end

-- Select an Icon to use
-- Add description verbatim to localization
function AutoBarCustom.prototype:init(customCategoriesDB)
	local description = customCategoriesDB.name
	if (not L[description]) then
		L[description] = description
	end

	-- Icon is first item found that is not an invalid spell
	local itemList = customCategoriesDB.items
	local itemType, itemId, itemInfo, spellName, spellClass, texture
	for index = # itemList, 1, -1 do
		local itemDB = itemList[index]
		itemType = itemDB.itemType
		itemId = itemDB.itemId
		itemInfo = itemDB.itemInfo
		spellName = itemDB.spellName
		spellClass = itemDB.spellClass
		texture = itemDB.texture
		if ((not spellClass) or (spellClass == AutoBar.CLASS)) then
			break
		end
	end
	if (itemType == "item") then
		_,_,_,_,_,_,_,_,_, texture = GetItemInfo(tonumber(itemId))
	elseif (itemType == "spell") then
		if (spellName) then
			_, _, texture = GetSpellInfo(spellName)
		end
	elseif (itemType == "macro") then
		if (itemId) then
			_, texture = GetMacroInfo(itemId)
		end
	elseif (itemType == "macroCustom") then
		texture = texture or "Interface\\Icons\\INV_Misc_Gift_05"
	else
		texture = "Interface\\Icons\\INV_Misc_Gift_01"
	end

	AutoBarCustom.super.prototype.init(self, description, texture)
	self.customCategoriesDB = customCategoriesDB

--AutoBar:Print("AutoBarCustom.prototype:init customCategoriesDB " .. tostring(customCategoriesDB) .. " self.customCategoriesDB " .. tostring(self.customCategoriesDB))
	self.customKey = AutoBarCustom:GetCustomKey(description)
--AutoBar:Print("AutoBarCustom.prototype:init description " .. tostring(description) .. " customKey " .. tostring(self.customKey))
	self.items = {}
	self:Refresh()
end

-- If not used yet, change name to newName
-- Return the name in use either way
function AutoBarCustom.prototype:ChangeName(newName)
	local newCategoryKey = AutoBarCustom:GetCustomKey(newName)
	if (not AutoBarCategoryList[newCategoryKey]) then
		local oldCustomKey = self.customKey
		self.customKey = newCategoryKey
--AutoBar:Print("AutoBarCustom.prototype:ChangeName oldCustomKey " .. tostring(oldCustomKey) .. " newCategoryKey " .. tostring(newCategoryKey))
		AutoBarCategoryList[newCategoryKey] = AutoBarCategoryList[oldCustomKey]
		AutoBarCategoryList[oldCustomKey] = nil
		-- Update categoryValidateList
		AutoBar.categoryValidateList[newCategoryKey] = self.description
		AutoBar.categoryValidateList[oldCustomKey] = nil

		self.customCategoriesDB.name = newName
		self.customCategoriesDB.desc = newName
		self.customCategoriesDB.categoryKey = newCategoryKey
		self.description = newName
		self.categoryKey = newCategoryKey

		local customCategories = AutoBar.db.account.customCategories
		customCategories[newCategoryKey] = customCategories[oldCustomKey]
		customCategories[oldCustomKey] = nil
	end
	return self.customCategoriesDB.name
end
-- /dump AutoBarCategoryList["Custom.Custom"]
-- /dump AutoBarCategoryList["Custom.XXX"]


-- Return the unique name to use
function AutoBarCustom:GetNewName(baseName, index)
	local newName = baseName .. index
	local newKey = AutoBarCustom:GetCustomKey(newName)
	local customCategories = AutoBar.db.account.customCategories
	while (customCategories[newKey] or AutoBarCategoryList[newKey]) do
		index = index + 1
		newName = baseName .. index
		newKey = AutoBarCustom:GetCustomKey(newName)
	end
	return newName, newKey
end


-- Reset the item list based on changed settings.
function AutoBarCustom.prototype:Refresh()
	local itemList = self.customCategoriesDB.items
	local itemType, itemId
	local itemsIndex = 1

	local items = self.items

	for index, itemDB in ipairs(itemList) do
		itemType = itemDB.itemType
		itemId = itemDB.itemId
		if (itemType == "item") then
			self.items[itemsIndex] = itemId
			itemsIndex = itemsIndex + 1
		elseif (itemType == "spell" and itemDB.spellName) then
			if (itemDB.spellClass == AutoBar.CLASS) then
				itemsIndex = AutoBarCustom.super.prototype.AddSpell(self, itemDB.spellName, nil, itemsIndex)
			end
		elseif (itemType == "macro") then
--AutoBar:Print("AutoBarCustom.prototype:Refresh --> itemDB.itemInfo " .. tostring(itemDB.itemInfo) .. " itemDB.itemId " .. tostring(itemDB.itemId))
			if (not itemDB.itemInfo) then
				itemDB.itemInfo = GetMacroInfo(itemId)
			end
			if (itemDB.itemInfo) then
				itemDB.itemId = GetMacroIndexByName(itemDB.itemInfo)
				itemId = itemDB.itemId
			end
--AutoBar:Print("AutoBarCustom.prototype:Refresh <-- itemDB.itemInfo " .. tostring(itemDB.itemInfo) .. " itemDB.itemId " .. tostring(itemDB.itemId))
			local macroId = "macro" .. itemId
			self.items[itemsIndex] = macroId
			itemsIndex = itemsIndex + 1
			AutoBarSearch:RegisterMacro(macroId, itemId)
		elseif (itemType == "macroCustom" and itemDB.itemInfo) then
			local macroId = "macroCustom" .. self.customCategoriesDB.categoryKey .. itemId
			self.items[itemsIndex] = macroId
			itemsIndex = itemsIndex + 1
			AutoBarSearch:RegisterMacro(macroId, nil, itemId, itemDB.itemInfo)
		end
	end

	-- Trim excess
	for index = itemsIndex, # self.items, 1 do
		self.items[index] = nil
	end
end
-- /dump AutoBarCategoryList["CustomArrangeTest"]


-- Create category list using PeriodicTable data.
function AutoBarCategory:Initialize()
	AutoBarCategoryList["Misc.Hearth"] = AutoBarItems:new(
			"Misc.Hearth", "INV_Misc_Rune_01", "Misc.Hearth")

	AutoBarCategoryList["Consumable.Buff.Free Action"] = AutoBarItems:new(
			"Consumable.Buff.Free Action", "INV_Potion_04", "Consumable.Buff.Free Action")

	AutoBarCategoryList["Consumable.Anti-Venom"] = AutoBarItems:new(
			"Consumable.Anti-Venom", "INV_Drink_14", "Consumable.Anti-Venom")
	AutoBarCategoryList["Consumable.Anti-Venom"]:SetTargeted(true)

	AutoBarCategoryList["Misc.Battle Standard.Guild"] = AutoBarItems:new(
			"Misc.Battle Standard.Guild", "INV_BannerPVP_01", "Misc.Battle Standard.Guild")

	AutoBarCategoryList["Misc.Battle Standard.Battleground"] = AutoBarItems:new(
			"Misc.Battle Standard.Battleground", "INV_BannerPVP_01", "Misc.Battle Standard.Battleground")
	AutoBarCategoryList["Misc.Battle Standard.Battleground"]:SetBattleground(true)

	AutoBarCategoryList["Misc.Battle Standard.Alterac Valley"] = AutoBarItems:new(
			"Misc.Battle Standard.Alterac Valley", "INV_BannerPVP_02", "Misc.Battle Standard.Alterac Valley")
	AutoBarCategoryList["Misc.Battle Standard.Alterac Valley"]:SetLocation(GetMapNameByID(401)) -- Alterac Valley

	AutoBarCategoryList["Misc.Reagent.Ammo.Arrow"] = AutoBarItems:new(
			"Misc.Reagent.Ammo.Arrow", "INV_Ammo_Arrow_02", "Misc.Reagent.Ammo.Arrow")
	AutoBarCategoryList["Misc.Reagent.Ammo.Arrow"]:SetNotUsable(true)

	AutoBarCategoryList["Misc.Reagent.Ammo.Bullet"] = AutoBarItems:new(
			"Misc.Reagent.Ammo.Bullet", "INV_Ammo_Bullet_02", "Misc.Reagent.Ammo.Bullet")
	AutoBarCategoryList["Misc.Reagent.Ammo.Bullet"]:SetNotUsable(true)

	AutoBarCategoryList["Misc.Reagent.Ammo.Thrown"] = AutoBarItems:new(
			"Misc.Reagent.Ammo.Thrown", "INV_Axe_19", "Misc.Reagent.Ammo.Thrown")
	AutoBarCategoryList["Misc.Reagent.Ammo.Thrown"]:SetNotUsable(true)

	AutoBarCategoryList["Misc.Explosives"] = AutoBarItems:new(
			"Misc.Explosives", "INV_Misc_Bomb_08", "Misc.Explosives")
	AutoBarCategoryList["Misc.Explosives"]:SetTargeted(true)

	AutoBarCategoryList["Misc.Engineering.Fireworks"] = AutoBarItems:new(
			"Misc.Engineering.Fireworks", "INV_Misc_MissileSmall_Red", "Misc.Engineering.Fireworks")

	AutoBarCategoryList["Tradeskill.Tool.Fishing.Gear"] = AutoBarItems:new(
			"Tradeskill.Tool.Fishing.Gear", "INV_Helmet_31", "Tradeskill.Tool.Fishing.Gear")

	AutoBarCategoryList["Tradeskill.Tool.Fishing.Lure"] = AutoBarItems:new(
			"Tradeskill.Tool.Fishing.Lure", "INV_Misc_Food_26", "Tradeskill.Tool.Fishing.Lure")
	AutoBarCategoryList["Tradeskill.Tool.Fishing.Lure"]:SetTargeted("WEAPON")

	AutoBarCategoryList["Tradeskill.Tool.Fishing.Other"] = AutoBarItems:new(
			"Tradeskill.Tool.Fishing.Other", "INV_Drink_03", "Tradeskill.Tool.Fishing.Other")

	AutoBarCategoryList["Tradeskill.Tool.Fishing.Tool"] = AutoBarItems:new(
			"Tradeskill.Tool.Fishing.Tool", "INV_Fishingpole_01", "Tradeskill.Tool.Fishing.Tool")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Mana.Other"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Mana.Other", "Spell_Shadow_SealOfKings", "Consumable.Cooldown.Stone.Mana.Other")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Health.Other"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Health.Other", "INV_Misc_Food_55", "Consumable.Cooldown.Stone.Health.Other")

	AutoBarCategoryList["Consumable.Bandage.Basic"] = AutoBarItems:new(
			"Consumable.Bandage.Basic", "INV_Misc_Bandage_Netherweave_Heavy", "Consumable.Bandage.Basic")
	AutoBarCategoryList["Consumable.Bandage.Basic"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Bandage.Battleground.Alterac Valley"] = AutoBarItems:new(
			"Consumable.Bandage.Battleground.Alterac Valley", "INV_Misc_Bandage_12", "Consumable.Bandage.Battleground.Alterac Valley")
	AutoBarCategoryList["Consumable.Bandage.Battleground.Alterac Valley"]:SetTargeted(true)
	AutoBarCategoryList["Consumable.Bandage.Battleground.Alterac Valley"]:SetLocation(GetMapNameByID(401)) -- Alterac Valley

	AutoBarCategoryList["Consumable.Bandage.Battleground.Arathi Basin"] = AutoBarItems:new(
			"Consumable.Bandage.Battleground.Arathi Basin", "INV_Misc_Bandage_12", "Consumable.Bandage.Battleground.Arathi Basin")
	AutoBarCategoryList["Consumable.Bandage.Battleground.Arathi Basin"]:SetTargeted(true)
	AutoBarCategoryList["Consumable.Bandage.Battleground.Arathi Basin"]:SetLocation(GetMapNameByID(461)) -- Arathi Basin

	AutoBarCategoryList["Consumable.Bandage.Battleground.Warsong Gulch"] = AutoBarItems:new(
			"Consumable.Bandage.Battleground.Warsong Gulch", "INV_Misc_Bandage_12", "Consumable.Bandage.Battleground.Warsong Gulch")
	AutoBarCategoryList["Consumable.Bandage.Battleground.Warsong Gulch"]:SetTargeted(true)
	AutoBarCategoryList["Consumable.Bandage.Battleground.Warsong Gulch"]:SetLocation(GetMapNameByID(443)) -- Warsong Gulch

	AutoBarCategoryList["Consumable.Food.Edible.Basic.Non-Conjured"] = AutoBarItems:new(
			"Consumable.Food.Edible.Basic.Non-Conjured", "INV_Misc_Food_23", "Consumable.Food.Edible.Basic.Non-Conjured")
	AutoBarCategoryList["Consumable.Food.Edible.Basic.Non-Conjured"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Edible.Basic.Non-Conjured"] = AutoBarItems:new(
			"Consumable.Food.Edible.Basic.Non-Conjured", "INV_Misc_Food_23", "Consumable.Food.Edible.Basic.Non-Conjured")
	AutoBarCategoryList["Consumable.Food.Edible.Basic.Non-Conjured"]:SetNonCombat(true)

	AutoBarCategoryList["AutoBar.Food.Health.Basic"] = AutoBarItems:new(
			"AutoBar.Food.Health.Basic", "INV_Misc_Food_23", "AutoBar.Food.Health.Basic")
	AutoBarCategoryList["AutoBar.Food.Health.Basic"]:SetNonCombat(true)


	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Arathi Basin.Basic"] = AutoBarItems:new(
			"Consumable.Food.Edible.Battleground.Arathi Basin.Basic", "INV_Misc_Food_33", "Consumable.Food.Edible.Battleground.Arathi Basin.Basic")
	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Arathi Basin.Basic"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Arathi Basin.Basic"]:SetLocation(GetMapNameByID(461)) -- Arathi Basin

	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Warsong Gulch.Basic"] = AutoBarItems:new(
			"Consumable.Food.Edible.Battleground.Warsong Gulch.Basic", "INV_Misc_Food_33", "Consumable.Food.Edible.Battleground.Warsong Gulch.Basic")
	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Warsong Gulch.Basic"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Edible.Battleground.Warsong Gulch.Basic"]:SetLocation(GetMapNameByID(443)) -- Warsong Gulch

	AutoBarCategoryList["Consumable.Food.Combo Health"] = AutoBarItems:new(
			"Consumable.Food.Combo Health", "INV_Misc_Food_33", "Consumable.Food.Combo Health")
	AutoBarCategoryList["Consumable.Food.Combo Health"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Edible.Combo.Non-Conjured"] = AutoBarItems:new(
			"Consumable.Food.Edible.Combo.Non-Conjured", "INV_Misc_Food_95_Grainbread", "Consumable.Food.Edible.Combo.Non-Conjured")
	AutoBarCategoryList["Consumable.Food.Edible.Combo.Non-Conjured"]:SetNonCombat(true)

	AutoBarCategoryList["AutoBar.Food.Combo.Basic"] = AutoBarItems:new(
			"AutoBar.Food.Combo.Basic", "INV_Misc_Food_95_Grainbread", "AutoBar.Food.Combo.Basic")
	AutoBarCategoryList["AutoBar.Food.Combo.Basic"]:SetNonCombat(true)

	AutoBarCategoryList["AutoBar.Food.Health.Buff"] = AutoBarItems:new(
			"AutoBar.Food.Health.Buff", "INV_Misc_Food_95_Grainbread", "AutoBar.Food.Health.Buff")
	AutoBarCategoryList["AutoBar.Food.Health.Buff"]:SetNonCombat(true)

	AutoBarCategoryList["AutoBar.Food.Mana.Buff"] = AutoBarItems:new(
			"AutoBar.Food.Mana.Buff", "INV_Misc_Food_95_Grainbread", "AutoBar.Food.Mana.Buff")
	AutoBarCategoryList["AutoBar.Food.Mana.Buff"]:SetNonCombat(true)


--	AutoBarCategoryList["Consumable.Food.Edible.Combo.Conjured"] = AutoBarItems:new(
--			"Consumable.Food.Edible.Combo.Conjured", "INV_Misc_Food_100", "Consumable.Food.Edible.Combo.Conjured")
--	AutoBarCategoryList["Consumable.Food.Edible.Combo.Conjured"]:SetNonCombat(true)

	local spellConjureFood, spellConjureFoodIcon
	spellConjureFood, _, spellConjureFoodIcon = AutoBar:LoggedGetSpellInfo(42955)
	AutoBarCategoryList["Consumable.Food.Edible.Combo.Conjured"] = AutoBarItems:new(
			"Consumable.Food.Edible.Combo.Conjured", spellConjureFoodIcon, "Consumable.Food.Edible.Combo.Conjured")
	AutoBarCategoryList["Consumable.Food.Edible.Combo.Conjured"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Edible.Combo.Conjured"]:SetCastList(AutoBarCategory:FilterClass({"MAGE", spellRitualOfRefreshment, "MAGE", spellConjureFood,}))

	AutoBarCategoryList["Consumable.Food.Feast"] = AutoBarItems:new(
			"Consumable.Food.Feast", "INV_Misc_Fish_52", "Consumable.Food.Feast")
	AutoBarCategoryList["Consumable.Food.Feast"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Percent.Basic"] = AutoBarItems:new(
			"Consumable.Food.Percent.Basic", "INV_Misc_Food_60", "Consumable.Food.Percent.Basic")
	AutoBarCategoryList["Consumable.Food.Percent.Basic"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Percent.Bonus"] = AutoBarItems:new(
			"Consumable.Food.Percent.Bonus", "INV_Misc_Food_62", "Consumable.Food.Percent.Bonus")
	AutoBarCategoryList["Consumable.Food.Percent.Bonus"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Combo Percent"] = AutoBarItems:new(
			"Consumable.Food.Combo Percent", "INV_Food_ChristmasFruitCake_01", "Consumable.Food.Combo Percent")
	AutoBarCategoryList["Consumable.Food.Combo Percent"]:SetNonCombat(true)

--	rawList = self:RawItemsAdd(nil, "Consumable.Food.Edible.Bread.Basic", false);
--	rawList = self:RawItemsAdd(rawList, "Consumable.Food.Edible.Bread.Conjured", true);
--	AutoBarCategoryList["Consumable.Food.Pet.Bread"]["items"] = self:RawItemsConvert(rawList);
--	["Consumable.Food.Pet.Bread"] = {
--		["description"] = Consumable.Food.Pet.Bread;
--		["texture"] = "INV_Misc_Food_35";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Bread"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Bread", "INV_Misc_Food_35", "Consumable.Food.Edible.Bread.Basic", "Consumable.Food.Edible.Basic.Conjured")
	AutoBarCategoryList["Consumable.Food.Pet.Bread"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Bread"]:SetTargeted("PET")

--	AutoBarCategoryList["Consumable.Food.Pet.Cheese"]["items"] = self:GetSetItemsArrayPT3("Consumable.Food.Edible.Cheese.Basic");
--	["Consumable.Food.Pet.Cheese"] = {
--		["description"] = Consumable.Food.Pet.Cheese;
--		["texture"] = "INV_Misc_Food_37";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Cheese"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Cheese", "INV_Misc_Food_37", "Consumable.Food.Edible.Cheese.Basic")
	AutoBarCategoryList["Consumable.Food.Pet.Cheese"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Cheese"]:SetTargeted("PET")

--	rawList = self:RawItemsAdd(nil, "Consumable.Food.Inedible.Fish", false);
--	rawList = self:RawItemsAdd(rawList, "Consumable.Food.Edible.Fish.Basic", true);
--	AutoBarCategoryList["Consumable.Food.Pet.Fish"]["items"] = self:RawItemsConvert(rawList);
--	["Consumable.Food.Pet.Fish"] = {
--		["description"] = Consumable.Food.Pet.Fish;
--		["texture"] = "INV_Misc_Fish_22";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Fish"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Fish", "INV_Misc_Fish_22", "Consumable.Food.Inedible.Fish", "Consumable.Food.Edible.Fish.Basic")
	AutoBarCategoryList["Consumable.Food.Pet.Fish"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Fish"]:SetTargeted("PET")

--	AutoBarCategoryList["Consumable.Food.Pet.Fruit"]["items"] = self:GetSetItemsArrayPT3("Consumable.Food.Edible.Fruit.Basic");
--	["Consumable.Food.Pet.Fruit"] = {
--		["description"] = Consumable.Food.Pet.Fruit;
--		["texture"] = "INV_Misc_Food_19";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Fruit"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Fruit", "INV_Misc_Food_19", "Consumable.Food.Edible.Fruit.Basic")
	AutoBarCategoryList["Consumable.Food.Pet.Fruit"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Fruit"]:SetTargeted("PET")

--	AutoBarCategoryList["Consumable.Food.Pet.Fungus"]["items"] = self:GetSetItemsArrayPT3("Consumable.Food.Edible.Fungus.Basic");	-- Now includes senjin combo ;-(
--	["Consumable.Food.Pet.Fungus"] = {
--		["description"] = Consumable.Food.Pet.Fungus;
--		["texture"] = "INV_Mushroom_05";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Fungus"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Fungus", "INV_Mushroom_05", "Consumable.Food.Edible.Fungus.Basic")
	AutoBarCategoryList["Consumable.Food.Pet.Fungus"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Fungus"]:SetTargeted("PET")

--	rawList = self:RawItemsAdd(nil, "Consumable.Food.Inedible.Meat", false);
--	rawList = self:RawItemsAdd(rawList, "Consumable.Food.Edible.Meat.Basic", true);
--	AutoBarCategoryList["Consumable.Food.Pet.Meat"]["items"] = self:RawItemsConvert(rawList);
--	["Consumable.Food.Pet.Meat"] = {
--		["description"] = Consumable.Food.Pet.Meat;
--		["texture"] = "INV_Misc_Food_14";
--		["nonCombat"] = true,
--		["targeted"] = "PET";
--		["castSpell"] = spellFeedPet;
--	},
	AutoBarCategoryList["Consumable.Food.Pet.Meat"] = AutoBarPetFood:new(
			"Consumable.Food.Pet.Meat", "INV_Misc_Food_14", "Consumable.Food.Inedible.Meat", "Consumable.Food.Edible.Meat.Basic")
	AutoBarCategoryList["Consumable.Food.Pet.Meat"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Food.Pet.Meat"]:SetTargeted("PET")

	AutoBarCategoryList["Consumable.Buff Pet"] = AutoBarPetFood:new(
			"Consumable.Buff Pet", "INV_Misc_Food_87_SporelingSnack", "Consumable.Buff Pet")
	AutoBarCategoryList["Consumable.Buff Pet"]:SetTargeted("PET")

	AutoBarCategoryList["Consumable.Food.Bonus"] = AutoBarItems:new(
			"Consumable.Food.Bonus", "INV_Misc_Food_47", "Consumable.Food.Bonus")
	AutoBarCategoryList["Consumable.Food.Bonus"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Agility"] = AutoBarItems:new(
			"Consumable.Food.Buff.Agility", "INV_Misc_Fish_13", "Consumable.Food.Buff.Agility")
	AutoBarCategoryList["Consumable.Food.Buff.Agility"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Attack Power"] = AutoBarItems:new(
			"Consumable.Food.Buff.Attack Power", "INV_Misc_Fish_13", "Consumable.Food.Buff.Attack Power")
	AutoBarCategoryList["Consumable.Food.Buff.Attack Power"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Healing"] = AutoBarItems:new(
			"Consumable.Food.Buff.Healing", "INV_Misc_Fish_13", "Consumable.Food.Buff.Healing")
	AutoBarCategoryList["Consumable.Food.Buff.Healing"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.HP Regen"] = AutoBarItems:new(
			"Consumable.Food.Buff.HP Regen", "INV_Misc_Fish_19", "Consumable.Food.Buff.HP Regen")
	AutoBarCategoryList["Consumable.Food.Buff.HP Regen"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Intellect"] = AutoBarItems:new(
			"Consumable.Food.Buff.Intellect", "INV_Misc_Food_63", "Consumable.Food.Buff.Intellect")
	AutoBarCategoryList["Consumable.Food.Buff.Intellect"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Mana Regen"] = AutoBarItems:new(
			"Consumable.Food.Buff.Mana Regen", "INV_Drink_17", "Consumable.Food.Buff.Mana Regen")
	AutoBarCategoryList["Consumable.Food.Buff.Mana Regen"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Spell Damage"] = AutoBarItems:new(
			"Consumable.Food.Buff.Spell Damage", "INV_Misc_Food_65", "Consumable.Food.Buff.Spell Damage")
	AutoBarCategoryList["Consumable.Food.Buff.Spell Damage"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Spirit"] = AutoBarItems:new(
			"Consumable.Food.Buff.Spirit", "INV_Misc_Fish_03", "Consumable.Food.Buff.Spirit")
	AutoBarCategoryList["Consumable.Food.Buff.Spirit"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Stamina"] = AutoBarItems:new(
			"Consumable.Food.Buff.Stamina", "INV_Misc_Food_65", "Consumable.Food.Buff.Stamina")
	AutoBarCategoryList["Consumable.Food.Buff.Stamina"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Strength"] = AutoBarItems:new(
			"Consumable.Food.Buff.Strength", "INV_Misc_Food_41", "Consumable.Food.Buff.Strength")
	AutoBarCategoryList["Consumable.Food.Buff.Strength"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Food.Buff.Other"] = AutoBarItems:new(
			"Consumable.Food.Buff.Other", "INV_Drink_17", "Consumable.Food.Buff.Other")
	AutoBarCategoryList["Consumable.Food.Buff.Other"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Cooldown.Potion.Combat"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Combat", "INV_Potion_54", "Consumable.Cooldown.Potion.Combat")

	AutoBarCategoryList["AutoBar.Potion.Health"] = AutoBarItems:new(
			"AutoBar.Potion.Health", "INV_Potion_54", "AutoBar.Potion.Health")

	AutoBarCategoryList["AutoBar.Potion.Mana"] = AutoBarItems:new(
			"AutoBar.Potion.Mana", "INV_Potion_76", "AutoBar.Potion.Mana")
			
	AutoBarCategoryList["AutoBar.SunsongRanch"] = AutoBarItems:new(
			"AutoBar.SunsongRanch", "INV_Potion_76", "AutoBar.SunsongRanch")


	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Anywhere"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.Anywhere", "INV_Alchemy_EndlessFlask_06", "Consumable.Cooldown.Potion.Health.Anywhere")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Anywhere"]:SetAnywhere(true)

	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Basic"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.Basic", "INV_Potion_54", "Consumable.Cooldown.Potion.Health.Basic")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.PvP"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.PvP", "INV_Potion_39", "Consumable.Cooldown.Potion.Health.PvP")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.PvP"]:SetBattleground(true)

	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Blades Edge"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.Blades Edge", "INV_Potion_167", "Consumable.Cooldown.Potion.Health.Blades Edge")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Blades Edge"]:SetLocation(GetMapNameByID(475)) -- Blade's Edge Mountains

	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Coilfang"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.Coilfang", "INV_Potion_167", "Consumable.Cooldown.Potion.Health.Coilfang")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Coilfang"]:SetLocation("Coilfang")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Tempest Keep"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Health.Tempest Keep", "INV_Potion_153", "Consumable.Cooldown.Potion.Health.Tempest Keep")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Health.Tempest Keep"]:SetLocation("Tempest Keep")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Anywhere"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Anywhere", "INV_Alchemy_EndlessFlask_04", "Consumable.Cooldown.Potion.Mana.Anywhere")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Anywhere"]:SetAnywhere(true)

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Basic"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Basic", "INV_Potion_76", "Consumable.Cooldown.Potion.Mana.Basic")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Pvp"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Pvp", "INV_Potion_81", "Consumable.Cooldown.Potion.Mana.Pvp")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Pvp"]:SetBattleground(true)

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Blades Edge"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Blades Edge", "INV_Potion_168", "Consumable.Cooldown.Potion.Mana.Blades Edge")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Blades Edge"]:SetLocation(GetMapNameByID(475)) -- Blade's Edge Mountains

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Coilfang"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Coilfang", "INV_Potion_168", "Consumable.Cooldown.Potion.Mana.Coilfang")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Coilfang"]:SetLocation("Coilfang")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Tempest Keep"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Mana.Tempest Keep", "INV_Potion_156", "Consumable.Cooldown.Potion.Mana.Tempest Keep")
	AutoBarCategoryList["Consumable.Cooldown.Potion.Mana.Tempest Keep"]:SetLocation("Tempest Keep")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Combat"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Combat", "INV_Stone_04", "Consumable.Cooldown.Stone.Combat")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Health.Warlock"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Health.Warlock", "INV_Stone_04", "Consumable.Cooldown.Stone.Health.Warlock")

	AutoBarCategoryList["Misc.Booze"] = AutoBarItems:new(
			"Misc.Booze", "INV_Drink_03", "Misc.Booze")
	AutoBarCategoryList["Misc.Booze"]:SetNonCombat(true)

	AutoBarCategoryList["Misc.Minipet"] = AutoBarItems:new(
			"Misc.Minipet", "Ability_Creature_Poison_05", "Misc.Minipet")

	AutoBarCategoryList["Misc.Mount.Normal"] = AutoBarItems:new(
			"Misc.Mount.Normal", "Ability_Mount_JungleTiger", "Misc.Mount.Normal")
	AutoBarCategoryList["Misc.Mount.Normal"]:SetNonCombat(true)

--	AutoBarCategoryList["Misc.Mount.Ahn'Qiraj"] = AutoBarItems:new(
--			"Misc.Mount.Ahn'Qiraj", "INV_Misc_QirajiCrystal_05", "Misc.Mount.Ahn'Qiraj")
--	AutoBarCategoryList["Misc.Mount.Ahn'Qiraj"]:SetNonCombat(true)
--	AutoBarCategoryList["Misc.Mount.Ahn'Qiraj"]:SetLocation(BZ["Ahn'Qiraj"])

	AutoBarCategoryList["Misc.Mount.Flying"] = AutoBarItems:new(
			"Misc.Mount.Flying", "Ability_Mount_Wyvern_01", "Misc.Mount.Flying")
	AutoBarCategoryList["Misc.Mount.Flying"]:SetNonCombat(true)

	AutoBarCategoryList["Misc.Openable"] = AutoBarItems:new(
			"Misc.Openable", "INV_Misc_Bag_17", "Misc.Openable")

--[[
--	AutoBarCategoryList["Misc.Spell.Mount.Ahn'Qiraj"] = AutoBarSpells:new(
--			"Misc.Spell.Mount.Ahn'Qiraj", "Ability_Mount_Wyvern_01", nil, nil, "Misc.Spell.Mount.Ahn'Qiraj")
--	AutoBarCategoryList["Misc.Mount.Flying"]:SetNonCombat(true)

--	self:AddCategory("Misc.Spell.Mount.Ahn'Qiraj")
	self:AddCategory("Misc.Spell.Mount.Flying.Fast")
	self:AddCategory("Misc.Spell.Mount.Flying.Slow")
	self:AddCategory("Misc.Spell.Mount.Ground.Fast")
	self:AddCategory("Misc.Spell.Mount.Ground.Slow")
--]]
	AutoBarCategoryList["Consumable.Cooldown.Potion.Rejuvenation"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Rejuvenation", "INV_Potion_47", "Consumable.Cooldown.Potion.Rejuvenation")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Health.Statue"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Health.Statue", "INV_Misc_Statue_10", "Consumable.Cooldown.Stone.Health.Statue")

	AutoBarCategoryList["Consumable.Cooldown.Drums"] = AutoBarItems:new(
			"Consumable.Cooldown.Drums", "INV_Misc_Drum_05", "Consumable.Cooldown.Drums")

	AutoBarCategoryList["Consumable.Cooldown.Potion"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion", "INV_Potion_47", "Consumable.Cooldown.Potion")

	AutoBarCategoryList["Consumable.Cooldown.Stone"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone", "INV_Misc_Statue_10", "Consumable.Cooldown.Stone")

	AutoBarCategoryList["Consumable.Leatherworking.Drums"] = AutoBarItems:new(
			"Consumable.Leatherworking.Drums", "INV_Misc_Drum_06", "Consumable.Leatherworking.Drums")

	AutoBarCategoryList["Consumable.Tailor.Net"] = AutoBarItems:new(
			"Consumable.Tailor.Net", "INV_Misc_Net_01", "Consumable.Tailor.Net")

	AutoBarCategoryList["Consumable.Cooldown.Potion.Rejuvenation.Dreamless Sleep"] = AutoBarItems:new(
			"Consumable.Cooldown.Potion.Rejuvenation.Dreamless Sleep", "INV_Potion_83", "Consumable.Cooldown.Potion.Rejuvenation.Dreamless Sleep")

	AutoBarCategoryList["Consumable.Cooldown.Stone.Mana.Mana Stone"] = AutoBarItems:new(
			"Consumable.Cooldown.Stone.Mana.Mana Stone", "INV_Misc_Gem_Sapphire_02", "Consumable.Cooldown.Stone.Mana.Mana Stone")

	AutoBarCategoryList["Consumable.Buff.Rage"] = AutoBarItems:new(
			"Consumable.Buff.Rage", "INV_Potion_24", "Consumable.Buff.Rage")

	AutoBarCategoryList["Consumable.Buff.Energy"] = AutoBarItems:new(
			"Consumable.Buff.Energy", "INV_Drink_Milk_05", "Consumable.Buff.Energy")

	local spellConjureRefreshment, spellConjureRefreshmentIcon
	spellConjureRefreshment, _, spellConjureRefreshmentIcon = AutoBar:LoggedGetSpellInfo(42955)
	AutoBarCategoryList["Consumable.Water.Basic"] = AutoBarItems:new(
			"Consumable.Water.Basic", "INV_Drink_10", "Consumable.Water.Basic", "Consumable.Water.Conjured")
	AutoBarCategoryList["Consumable.Water.Basic"]:SetNonCombat(true)
	AutoBarCategoryList["Consumable.Water.Basic"]:SetCastList(AutoBarCategory:FilterClass({"MAGE", spellConjureRefreshment,}))

	AutoBarCategoryList["AutoBar.Food.Mana.Basic"] = AutoBarItems:new(
			"AutoBar.Food.Mana.Basic", "INV_Drink_10", "AutoBar.Food.Mana.Basic")
	AutoBarCategoryList["AutoBar.Food.Mana.Basic"]:SetNonCombat(true)


	AutoBarCategoryList["Consumable.Water.Conjure"] = AutoBarSpells:new(
			"Consumable.Water.Conjure", spellConjureRefreshmentIcon, {
			"MAGE", spellConjureRefreshment,
			})

	AutoBarCategoryList["Consumable.Food.Conjure"] = AutoBarSpells:new(
			"Consumable.Food.Conjure", spellConjureFoodIcon, {
			"MAGE", spellConjureFood,
			})

	AutoBarCategoryList["Consumable.Water.Percentage"] = AutoBarItems:new(
			"Consumable.Water.Percentage", "INV_Drink_04", "Consumable.Water.Percentage")
	AutoBarCategoryList["Consumable.Water.Percentage"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Water.Buff.Spirit"] = AutoBarItems:new(
			"Consumable.Water.Buff.Spirit", "INV_Drink_16", "Consumable.Water.Buff.Spirit")
	AutoBarCategoryList["Consumable.Water.Buff.Spirit"]:SetNonCombat(true)

	AutoBarCategoryList["Consumable.Water.Buff"] = AutoBarItems:new(
			"Consumable.Water.Buff", "INV_Drink_08", "Consumable.Water.Buff")
	AutoBarCategoryList["Consumable.Water.Buff"]:SetNonCombat(true)


	AutoBarCategoryList["Consumable.Weapon Buff.Oil.Mana"] = AutoBarItems:new("Consumable.Weapon Buff.Oil.Mana", "INV_Potion_100",
			"Consumable.Weapon Buff.Oil.Mana")
	AutoBarCategoryList["Consumable.Weapon Buff.Oil.Mana"]:SetTargeted("WEAPON")

	AutoBarCategoryList["Consumable.Weapon Buff.Oil.Wizard"] = AutoBarItems:new("Consumable.Weapon Buff.Oil.Wizard", "INV_Potion_105",
			"Consumable.Weapon Buff.Oil.Wizard")
	AutoBarCategoryList["Consumable.Weapon Buff.Oil.Wizard"]:SetTargeted("WEAPON")

	AutoBarCategoryList["Consumable.Weapon Buff.Stone.Sharpening Stone"] = AutoBarItems:new("Consumable.Weapon Buff.Stone.Sharpening Stone", "INV_Stone_SharpeningStone_01",
			"Consumable.Weapon Buff.Stone.Sharpening Stone")
	AutoBarCategoryList["Consumable.Weapon Buff.Stone.Sharpening Stone"]:SetTargeted("WEAPON")

	AutoBarCategoryList["Consumable.Weapon Buff.Stone.Weight Stone"] = AutoBarItems:new("Consumable.Weapon Buff.Stone.Weight Stone", "INV_Stone_WeightStone_02",
			"Consumable.Weapon Buff.Stone.Weight Stone")
	AutoBarCategoryList["Consumable.Weapon Buff.Stone.Weight Stone"]:SetTargeted("WEAPON")


	AutoBarCategoryList["Consumable.Buff Group.General.Self"] = AutoBarItems:new("Consumable.Buff Group.General.Self", "INV_Potion_80",
			"Consumable.Buff Group.General.Self")

	AutoBarCategoryList["Consumable.Buff Group.General.Target"] = AutoBarItems:new("Consumable.Buff Group.General.Target", "INV_Potion_80",
			"Consumable.Buff Group.General.Target")
	AutoBarCategoryList["Consumable.Buff Group.General.Target"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff Group.Caster.Self"] = AutoBarItems:new("Consumable.Buff Group.Caster.Self", "INV_Potion_66",
			"Consumable.Buff Group.Caster.Self")

	AutoBarCategoryList["Consumable.Buff Group.Caster.Target"] = AutoBarItems:new("Consumable.Buff Group.Caster.Target", "INV_Potion_66",
			"Consumable.Buff Group.Caster.Target")
	AutoBarCategoryList["Consumable.Buff Group.Caster.Target"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff Group.Melee.Self"] = AutoBarItems:new("Consumable.Buff Group.Melee.Self", "INV_Potion_43",
			"Consumable.Buff Group.Melee.Self")

	AutoBarCategoryList["Consumable.Buff Group.Melee.Target"] = AutoBarItems:new("Consumable.Buff Group.Melee.Target", "INV_Potion_43",
			"Consumable.Buff Group.Melee.Target")
	AutoBarCategoryList["Consumable.Buff Group.Melee.Target"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Other.Self"] = AutoBarItems:new("Consumable.Buff.Other.Self", "INV_Potion_80",
			"Consumable.Buff.Other.Self")

--[[
	AutoBarCategoryList["Consumable.Buff.Other.Target"] = AutoBarItems:new("Consumable.Buff.Other.Target", "INV_Potion_80",
			"Consumable.Buff.Other.Target")
	AutoBarCategoryList["Consumable.Buff.Other.Target"]:SetTargeted(true)
--]]

	AutoBarCategoryList["Consumable.Buff.Chest"] = AutoBarItems:new("Consumable.Buff.Chest", "INV_Misc_Rune_10",
			"Consumable.Buff.Chest")
	AutoBarCategoryList["Consumable.Buff.Chest"]:SetTargeted("CHEST")

	AutoBarCategoryList["Consumable.Buff.Shield"] = AutoBarItems:new("Consumable.Buff.Shield", "INV_Misc_Rune_13",
			"Consumable.Buff.Shield")
	AutoBarCategoryList["Consumable.Buff.Shield"]:SetTargeted("SHIELD")

	AutoBarCategoryList["Consumable.Weapon Buff"] = AutoBarItems:new("Consumable.Weapon Buff", "INV_Misc_Rune_13",
			"Consumable.Weapon Buff")
	AutoBarCategoryList["Consumable.Weapon Buff"]:SetTargeted("WEAPON")

	AutoBarCategoryList["Consumable.Buff.Health"] = AutoBarItems:new("Consumable.Buff.Health", "INV_Potion_43",
			"Consumable.Buff.Health")

	AutoBarCategoryList["Consumable.Buff.Armor"] = AutoBarItems:new("Consumable.Buff.Armor", "INV_Potion_66",
			"Consumable.Buff.Armor")

	AutoBarCategoryList["Consumable.Buff.Regen Health"] = AutoBarItems:new("Consumable.Buff.Regen Health", "INV_Potion_80",
			"Consumable.Buff.Regen Health")

	AutoBarCategoryList["Consumable.Buff.Agility"] = AutoBarItems:new("Consumable.Buff.Agility", "INV_Scroll_02",
			"Consumable.Buff.Agility")
	AutoBarCategoryList["Consumable.Buff.Agility"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Intellect"] = AutoBarItems:new("Consumable.Buff.Intellect", "INV_Scroll_01",
			"Consumable.Buff.Intellect")
	AutoBarCategoryList["Consumable.Buff.Intellect"]:SetTargeted(true)

--	AutoBarCategoryList["BUFF_PROTECTION"] = AutoBarItems:new("Consumable.Buff.Protection", "INV_Scroll_07",
--			"Consumable.Buff.Protection")
--	AutoBarCategoryList["BUFF_PROTECTION"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Spirit"] = AutoBarItems:new("Consumable.Buff.Spirit", "INV_Scroll_01",
			"Consumable.Buff.Spirit")
	AutoBarCategoryList["Consumable.Buff.Spirit"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Stamina"] = AutoBarItems:new("Consumable.Buff.Stamina", "INV_Scroll_07",
			"Consumable.Buff.Stamina")
	AutoBarCategoryList["Consumable.Buff.Stamina"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Strength"] = AutoBarItems:new("Consumable.Buff.Strength", "INV_Scroll_02",
			"Consumable.Buff.Strength")
	AutoBarCategoryList["Consumable.Buff.Strength"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Attack Power"] = AutoBarItems:new("Consumable.Buff.Attack Power", "INV_Misc_MonsterScales_07",
			"Consumable.Buff.Attack Power")
	AutoBarCategoryList["Consumable.Buff.Attack Power"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Attack Speed"] = AutoBarItems:new("Consumable.Buff.Attack Speed", "INV_Misc_MonsterScales_17",
			"Consumable.Buff.Attack Speed")
	AutoBarCategoryList["Consumable.Buff.Attack Speed"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Dodge"] = AutoBarItems:new("Consumable.Buff.Dodge", "INV_Misc_MonsterScales_17",
			"Consumable.Buff.Dodge")
	AutoBarCategoryList["Consumable.Buff.Dodge"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Resistance.Self"] = AutoBarItems:new("Consumable.Buff.Resistance", "INV_Misc_MonsterScales_15",
			"Consumable.Buff.Resistance.Self")

	AutoBarCategoryList["Consumable.Buff.Resistance.Target"] = AutoBarItems:new("Consumable.Buff.Resistance", "INV_Misc_MonsterScales_15",
			"Consumable.Buff.Resistance.Target")
	AutoBarCategoryList["Consumable.Buff.Resistance.Target"]:SetTargeted(true)

	AutoBarCategoryList["Consumable.Buff.Speed"] = AutoBarItems:new("Consumable.Buff.Speed", "INV_Potion_95",
			"Consumable.Buff.Speed")

	AutoBarCategoryList["Consumable.Buff Type.Battle"] = AutoBarItems:new("Consumable.Buff Type.Battle", "INV_Potion_111",
			"Consumable.Buff Type.Battle")

	AutoBarCategoryList["Consumable.Buff Type.Guardian"] = AutoBarItems:new("Consumable.Buff Type.Guardian", "INV_Potion_155",
			"Consumable.Buff Type.Guardian")

	AutoBarCategoryList["Consumable.Buff Type.Flask"] = AutoBarItems:new("Consumable.Buff Type.Flask", "INV_Potion_118",
			"Consumable.Buff Type.Flask")

	AutoBarCategoryList["AutoBar.Trinket"] = AutoBarItems:new("AutoBar.Trinket", "INV_Misc_OrnateBox",
			"AutoBar.Trinket")

	AutoBarCategoryList["Misc.Lockboxes"] = AutoBarItems:new("Misc.Lockboxes", "INV_Trinket_Naxxramas06",
			"Misc.Lockboxes")

	AutoBarCategoryList["Misc.Usable.BossItem"] = AutoBarItems:new("Misc.Usable.BossItem", "INV_BannerPVP_02",
			"Misc.Usable.BossItem")

	AutoBarCategoryList["Misc.Usable.Fun"] = AutoBarItems:new("Misc.Usable.Fun", "INV_Misc_Toy_10",
			"Misc.Usable.Fun")

	AutoBarCategoryList["Misc.Usable.Permanent"] = AutoBarItems:new("Misc.Usable.Permanent", "INV_BannerPVP_02",
			"Misc.Usable.Permanent")

	AutoBarCategoryList["Misc.Usable.Quest"] = AutoBarItems:new("Misc.Usable.Quest", "INV_BannerPVP_02",
			"Misc.Usable.Quest")

	AutoBarCategoryList["Misc.Usable.StartsQuest"] = AutoBarItems:new("Misc.Usable.StartsQuest", "INV_Staff_20",
			"Misc.Usable.StartsQuest")

	AutoBarCategoryList["Misc.Usable.Replenished"] = AutoBarItems:new("Misc.Usable.Replenished", "INV_BannerPVP_02",
			"Misc.Usable.Replenished")


	local spellCreateHealthstone, spellCreateHealthstoneIcon
	spellCreateHealthstone, _, spellCreateHealthstoneIcon = AutoBar:LoggedGetSpellInfo(6201)
	local spellRitualOfSouls, spellRitualOfSoulsIcon
	spellRitualOfSouls, _, spellRitualOfSoulsIcon = AutoBar:LoggedGetSpellInfo(29893)
	AutoBarCategoryList["Spell.Warlock.Create Healthstone"] = AutoBarSpells:new(
			"Spell.Warlock.Create Healthstone", spellCreateHealthstoneIcon, {
			"WARLOCK", spellCreateHealthstone,
			"WARLOCK", spellRitualOfSouls,
			})



	AutoBarCategoryList["Spell.Mage.Conjure Food"] = AutoBarSpells:new(
			"Spell.Mage.Conjure Food", spellConjureFoodIcon, {
			"MAGE", spellNameList["Conjure Refreshment Table"],
			"MAGE", spellNameList["Conjure Refreshment"],
			})
--/script local name, rank, icon, cost = GetSpellInfo(43987); AutoBar:Print("AutoBarCustom.prototype:init GetSpellInfo(43987) name " .. tostring(name) .. " rank " .. tostring(rank) .. " icon " .. tostring(icon) .. " cost " .. tostring(cost))
	AutoBarCategoryList["Spell.Mage.Conjure Mana Stone"] = AutoBarSpells:new(
			"Spell.Mage.Conjure Mana Stone", spellIconList["Conjure Mana Gem"], {
			"MAGE", spellNameList["Conjure Mana Gem"],
			})


	AutoBarCategoryList["Spell.Aspect"] = AutoBarSpells:new(
			"Spell.Aspect", spellIconList["Aspect of the Hawk"], {
			"HUNTER", spellNameList["Aspect of the Cheetah"], --*
			"HUNTER", spellNameList["Aspect of the Hawk"], --*
			"HUNTER", spellNameList["Aspect of the Pack"], --*
			"HUNTER", spellNameList["Aspect of the Iron Hawk"], --*
			})
			
	AutoBarCategoryList["Spell.Poison.Lethal"] = AutoBarSpells:new(
			"Spell.Poison.Lethal", spellIconList["Deadly Poison"], {
			"ROGUE", spellNameList["Deadly Poison"], --*
			"ROGUE", spellNameList["Wound Poison"], --*
			})

	AutoBarCategoryList["Spell.Poison.Nonlethal"] = AutoBarSpells:new(
			"Spell.Poison.Nonlethal", spellIconList["Mind-numbing Poison"], {
			"ROGUE", spellNameList["Mind-numbing Poison"], --*
			"ROGUE", spellNameList["Crippling Poison"], --*
			"ROGUE", spellNameList["Leeching Poison"], --*
			"ROGUE", spellNameList["Paralytic Poison"], --*
			})



	AutoBarCategoryList["Spell.Class.Buff"] = AutoBarSpells:new(
			"Spell.Class.Buff", spellIconList["Mark of the Wild"], {
			"DEATHKNIGHT", spellNameList["Bone Shield"],
			"DEATHKNIGHT", spellNameList["Horn of Winter"],
			"DRUID", spellNameList["Mark of the Wild"],
			"DRUID", spellNameList["Nature's Grasp"],
			"DRUID", spellNameList["Ironbark"],
			"DRUID", spellNameList["Heart of the Wild"],
			"MAGE", spellNameList["Arcane Brilliance"],
			"MAGE", spellNameList["Dalaran Brilliance"],
			"MAGE", spellNameList["Ice Ward"],
			"MAGE", spellNameList["Frost Armor"],
			"MAGE", spellNameList["Mage Armor"],
			"MAGE", spellNameList["Molten Armor"],
			"MAGE", spellNameList["Slow Fall"],
			"MONK", spellNameList["Legacy of the Emperor"],
			"MONK", spellNameList["Legacy of the White Tiger"],
			"PALADIN", spellNameList["Blessing of Kings"],
			"PALADIN", spellNameList["Blessing of Might"],
			"PALADIN", spellNameList["Hand of Freedom"],
			"PALADIN", spellNameList["Hand of Protection"],
			"PALADIN", spellNameList["Hand of Sacrifice"],
			"PALADIN", spellNameList["Hand of Salvation"],
			"PRIEST", spellNameList["Fear Ward"],
			"PRIEST", spellNameList["Inner Fire"],
			"PRIEST", spellNameList["Inner Will"],
			"PRIEST", spellNameList["Power Word: Fortitude"],
			"SHAMAN", spellNameList["Water Walking"],
			"WARLOCK", spellNameList["Dark Intent"],
			"WARLOCK", spellNameList["Unending Breath"],
			"WARLOCK", spellNameList["Soulstone"],
			"WARLOCK", spellNameList["Soul Link"],
			"WARRIOR", spellNameList["Battle Shout"],
			"WARRIOR", spellNameList["Commanding Shout"],
			"WARRIOR", spellNameList["Demoralizing Shout"],

			})

	local spellEagleEye = AutoBar:LoggedGetSpellInfo(6197)
	local spellTameBeast = AutoBar:LoggedGetSpellInfo(1515)
	local spellBeastLore = AutoBar:LoggedGetSpellInfo(1462)
	local spellDismissPet = AutoBar:LoggedGetSpellInfo(2641)
	local spellRevivePet = AutoBar:LoggedGetSpellInfo(982)
	local spellCallPet1 = AutoBar:LoggedGetSpellInfo(883)
	local spellCallPet2 = AutoBar:LoggedGetSpellInfo(83242)
	local spellCallPet3 = AutoBar:LoggedGetSpellInfo(83243)
	local spellCallPet4 = AutoBar:LoggedGetSpellInfo(83244)
	local spellCallPet5 = AutoBar:LoggedGetSpellInfo(83245)
	local spellShadowfiend = AutoBar:LoggedGetSpellInfo(34433)
	
	
	
	--Shaman
	local spellEarthElementalTotem = AutoBar:LoggedGetSpellInfo(2062)
	local spellFireElementalTotem = AutoBar:LoggedGetSpellInfo(2894)

	--Druid
	local spellForceOfNature, spellForceOfNatureIcon
	spellForceOfNature, _, spellForceOfNatureIcon = AutoBar:LoggedGetSpellInfo(106737)

	--Mage
	local spellSummonWaterElemental = AutoBar:LoggedGetSpellInfo(31687)

	--Warlock
	local spellEyeOfKilrogg = AutoBar:LoggedGetSpellInfo(126)
	local spellSummonFelguard = AutoBar:LoggedGetSpellInfo(30146)
	local spellSummonFelhunter = AutoBar:LoggedGetSpellInfo(691)
	local spellSummonImp = AutoBar:LoggedGetSpellInfo(688)
	local spellSummonSuccubus = AutoBar:LoggedGetSpellInfo(712)
	local spellSummonVoidwalker = AutoBar:LoggedGetSpellInfo(697)
	local spellSummonInfernal = AutoBar:LoggedGetSpellInfo(1122)
	local spellSummonDoomguard = AutoBar:LoggedGetSpellInfo(18540)
	
	--DeathKnight
	local spellRuneWeapon = AutoBar:LoggedGetSpellInfo(49028)
	local spellRaiseDead = AutoBar:LoggedGetSpellInfo(46584)
	local spellSummonGargoyle = AutoBar:LoggedGetSpellInfo(49206)


	AutoBarCategoryList["Spell.Class.Pet"] = AutoBarSpells:new(
			"Spell.Class.Pet", spellForceOfNatureIcon, {
			"DEATHKNIGHT", spellRuneWeapon,
			"DEATHKNIGHT", spellRaiseDead,
			"DEATHKNIGHT", spellSummonGargoyle,			
			"DRUID", spellForceOfNature,
			"HUNTER", spellCallPet1, 
			"HUNTER", spellCallPet2, 
			"HUNTER", spellCallPet3, 
			"HUNTER", spellCallPet4, 
			"HUNTER", spellCallPet5, 
			"MAGE", spellSummonWaterElemental,
			"PRIEST", spellShadowfiend,
			"SHAMAN", spellEarthElementalTotem,
			"SHAMAN", spellFireElementalTotem,
			"SHAMAN", spellNameList["Feral Spirit"],
			"WARLOCK", spellSummonDoomguard,
			"WARLOCK", spellEyeOfKilrogg,
			"WARLOCK", spellSummonInfernal,
			"WARLOCK", spellSummonFelguard,
			"WARLOCK", spellSummonFelhunter,
			"WARLOCK", spellSummonImp,
			"WARLOCK", spellSummonSuccubus,
			"WARLOCK", spellSummonVoidwalker,
			})

	AutoBarCategoryList["Spell.Class.Pets2"] = AutoBarSpells:new(
			"Spell.Class.Pets2", spellCallPet1Icon, {
			"HUNTER", spellNameList["Kill Command"],
			"HUNTER", spellNameList["Bestial Wrath"],
			"HUNTER", spellNameList["Master's Call"],
			"HUNTER", spellNameList["Mend Pet"],
			"HUNTER", spellNameList["Intimidation"],
			"WARLOCK", spellNameList["Command Demon"],
			"WARLOCK", spellNameList["Grimoire of Service"],
			"WARLOCK", spellNameList["Grimoire of Sacrifice"],
			})

	AutoBarCategoryList["Spell.Class.Pets3"] = AutoBarSpells:new(	--Misc pet abilities
		"Spell.Class.Pets3", spellIconList["Feed Pet"], {
			"HUNTER", spellDismissPet,
			"HUNTER", spellEagleEye,
			"HUNTER", spellFeedPet,
			"HUNTER", spellRevivePet,
			"HUNTER", spellTameBeast,
	})


	local spellPortalShattrath, spellPortalShattrathIcon
	spellPortalShattrath, _, spellPortalShattrathIcon = AutoBar:LoggedGetSpellInfo(33691)
	local spellTeleportStonard = AutoBar:LoggedGetSpellInfo(49358)
	local spellPortalStonard = AutoBar:LoggedGetSpellInfo(49361)
	local spellTeleportTheramore = AutoBar:LoggedGetSpellInfo(49359)
	local spellPortalTheramore = AutoBar:LoggedGetSpellInfo(49360)
	local spellTeleportUndercity = AutoBar:LoggedGetSpellInfo(3563)
	local spellPortalUndercity = AutoBar:LoggedGetSpellInfo(11418)
	local spellTeleportThunderBluff = AutoBar:LoggedGetSpellInfo(3566)
	local spellPortalThunderBluff = AutoBar:LoggedGetSpellInfo(11420)
	local spellTeleportStormwind = AutoBar:LoggedGetSpellInfo(3561)
	local spellPortalStormwind = AutoBar:LoggedGetSpellInfo(10059)
	local spellTeleportSilvermoon = AutoBar:LoggedGetSpellInfo(32272)
	local spellPortalSilvermoon = AutoBar:LoggedGetSpellInfo(32267)
	local spellTeleportExodar = AutoBar:LoggedGetSpellInfo(32271)
	local spellPortalExodar = AutoBar:LoggedGetSpellInfo(32266)
	local spellTeleportDarnassus = AutoBar:LoggedGetSpellInfo(3565)
	local spellPortalDarnassus = AutoBar:LoggedGetSpellInfo(11419)
	local spellTeleportIronforge = AutoBar:LoggedGetSpellInfo(3562)
	local spellPortalIronforge = AutoBar:LoggedGetSpellInfo(11416)
	local spellTeleportOrgrimmar = AutoBar:LoggedGetSpellInfo(3567)
	local spellPortalOrgrimmar = AutoBar:LoggedGetSpellInfo(11417)
	local spellTeleportShattrath = AutoBar:LoggedGetSpellInfo(35715)
	spellNameList["Teleport: Dalaran"] = AutoBar:LoggedGetSpellInfo(53140)
	spellNameList["Portal: Dalaran"] = AutoBar:LoggedGetSpellInfo(53142)
	spellNameList["Death Gate"] = AutoBar:LoggedGetSpellInfo(50977)
	local spellTeleportMoonglade = AutoBar:LoggedGetSpellInfo(18960)
	local spellAstralRecall = AutoBar:LoggedGetSpellInfo(556)
	local spellRitualOfSummoning = AutoBar:LoggedGetSpellInfo(698)
	local spellTeleportTolBaradH = AutoBar:LoggedGetSpellInfo(88344)
	local spellTeleportTolBaradA = AutoBar:LoggedGetSpellInfo(88342)
	local spellPortalTolBaradH = AutoBar:LoggedGetSpellInfo(88346)
	local spellPortalTolBaradA = AutoBar:LoggedGetSpellInfo(88345)
	local spellTeleportValeofEternalBlossomsA = AutoBar:LoggedGetSpellInfo(132621)
	local spellPortalValeofEternalBlossomsA = AutoBar:LoggedGetSpellInfo(132620)
	local spellTeleportValeofEternalBlossomsH = AutoBar:LoggedGetSpellInfo(132627)
	local spellPortalValeofEternalBlossomsH = AutoBar:LoggedGetSpellInfo(132626)
	AutoBarCategoryList["Spell.Portals"] = AutoBarSpells:new(
			"Spell.Portals", spellPortalShattrathIcon, nil, {
			"MAGE", spellTeleportStonard, spellPortalStonard,
			"MAGE", spellTeleportTheramore, spellPortalTheramore,
			"MAGE", spellTeleportUndercity, spellPortalUndercity,
			"MAGE", spellTeleportThunderBluff, spellPortalThunderBluff,
			"MAGE", spellTeleportStormwind, spellPortalStormwind,
			"MAGE", spellTeleportSilvermoon, spellPortalSilvermoon,
			"MAGE", spellTeleportExodar, spellPortalExodar,
			"MAGE", spellTeleportDarnassus, spellPortalDarnassus,
			"MAGE", spellTeleportIronforge, spellPortalIronforge,
			"MAGE", spellTeleportOrgrimmar, spellPortalOrgrimmar,
			"MAGE", spellTeleportShattrath, spellPortalShattrath,
			"MAGE", spellTeleportTolBaradH, spellPortalTolBaradH,
			"MAGE", spellTeleportTolBaradA, spellPortalTolBaradA,
			"MAGE", spellTeleportValeofEternalBlossomsA, spellPortalValeofEternalBlossomsA,
			"MAGE", spellTeleportValeofEternalBlossomsH, spellPortalValeofEternalBlossomsH,
			"MAGE", spellNameList["Teleport: Dalaran"], spellNameList["Portal: Dalaran"],
			"DEATHKNIGHT", spellNameList["Death Gate"], spellNameList["Death Gate"],
			"DRUID", spellTeleportMoonglade, spellTeleportMoonglade,
			"SHAMAN", spellAstralRecall, spellAstralRecall,
			"WARLOCK", spellRitualOfSummoning, spellRitualOfSummoning,
			})

	AutoBarCategoryList["Spell.Shields"] = AutoBarSpells:new(
			"Spell.Shields", spellIconList["Ice Barrier"], nil, {
			"DEATHKNIGHT", spellNameList["Bone Shield"], spellNameList["Bone Shield"],
			"DRUID", spellNameList["Barkskin"], spellNameList["Barkskin"],
			"MAGE", spellNameList["Ice Barrier"], spellNameList["Ice Barrier"],
			"MAGE", spellNameList["Incanter's Ward"], spellNameList["Incanter's Ward"],
			"MAGE", spellNameList["Temporal Shield"], spellNameList["Temporal Shield"],
			"PALADIN", spellNameList["Divine Protection"], spellNameList["Hand of Sacrifice"],
			"PALADIN", spellNameList["Divine Shield"], spellNameList["Hand of Protection"],
			"PRIEST", spellNameList["Power Word: Shield"], spellNameList["Power Word: Shield"],
			"ROGUE", spellNameList["Evasion"], spellNameList["Evasion"],
			"SHAMAN", spellNameList["Earth Shield"], spellNameList["Earth Shield"],
			"SHAMAN", spellNameList["Lightning Shield"], spellNameList["Lightning Shield"],
			"SHAMAN", spellNameList["Water Shield"], spellNameList["Water Shield"],
			"WARLOCK", spellNameList["Twilight Ward"], spellNameList["Twilight Ward"],
			"WARLOCK", spellNameList["Sacrificial Pact"], spellNameList["Sacrificial Pact"],
			"WARLOCK", spellNameList["Dark Bargain"], spellNameList["Dark Bargain"],
			"WARLOCK", spellNameList["Unending Resolve"], spellNameList["Unending Resolve"],
			"WARRIOR", spellNameList["Shield Block"], spellNameList["Shield Block"],
			"WARRIOR", spellNameList["Shield Wall"], spellNameList["Shield Wall"],
			})
end

-- Create category list using PeriodicTable data.
-- Split up to avoid Lua upValue limitations
function AutoBarCategory:Initialize2()
	AutoBarCategoryList["Spell.Stance"] = AutoBarSpells:new(
			"Spell.Stance", spellIconList["Berserker Stance"], nil, {
			"WARRIOR", spellNameList["Defensive Stance"], spellNameList["Berserker Stance"],
			"WARRIOR", spellNameList["Battle Stance"], spellNameList["Defensive Stance"],
			"WARRIOR", spellNameList["Berserker Stance"], spellNameList["Defensive Stance"],
			})


			
	local spellMobileBanking = AutoBar:LoggedGetSpellInfo(83958)
	local spellMassRessurection = AutoBar:LoggedGetSpellInfo(83968)
	local spellWillTravel = GetSpellInfo(83967)
	AutoBarCategoryList["Spell.Guild"] = AutoBarSpells:new(
			"Spell.Guild", spellEarthElementalTotemIcon, {
			"*", spellMobileBanking,
			"*", spellMassRessurection,
			"*", spellWillTravel,
	})



	local spellEarthElementalTotem, spellEarthElementalTotemIcon
	spellEarthElementalTotem, _, spellEarthElementalTotemIcon = AutoBar:LoggedGetSpellInfo(2062)
	local spellEarthbindTotem = AutoBar:LoggedGetSpellInfo(2484)
	local spellTremorTotem = AutoBar:LoggedGetSpellInfo(8143)
	local spellStoneBulwarkTotem = AutoBar:LoggedGetSpellInfo(108270)
	local spellEarthGrabTotem = AutoBar:LoggedGetSpellInfo(51485)
	AutoBarCategoryList["Spell.Totem.Earth"] = AutoBarSpells:new(
			"Spell.Totem.Earth", spellEarthElementalTotemIcon, {
			"SHAMAN", spellEarthElementalTotem, --*
			"SHAMAN", spellEarthbindTotem, --*
			"SHAMAN", spellTremorTotem, --*
			"SHAMAN", spellStoneBulwarkTotem, --*
			"SHAMAN", spellEarthGrabTotem, --*
			})
			

	spellNameList["Grounding Totem"], _, spellIconList["Grounding Totem"] = AutoBar:LoggedGetSpellInfo(8177)
	local spellCapacitorTotem = AutoBar:LoggedGetSpellInfo(108269)
	local spellStormLashTotem = AutoBar:LoggedGetSpellInfo(120668)
	local spellSpiritLinkTotem = AutoBar:LoggedGetSpellInfo(98008)
	local spellWindwalkTotem = AutoBar:LoggedGetSpellInfo(108273)
	AutoBarCategoryList["Spell.Totem.Air"] = AutoBarSpells:new(
			"Spell.Totem.Air", spellIconList["Grounding Totem"], {
			"SHAMAN", spellNameList["Grounding Totem"], --*
			"SHAMAN", spellCapacitorTotem, --*
			"SHAMAN", spellStormLashTotem, --*
			"SHAMAN", spellSpiritLinkTotem, --*
			"SHAMAN", spellWindwalkTotem, --*
			})

	local spellFireElementalTotem, spellFireElementalTotemIcon
	spellFireElementalTotem, _, spellFireElementalTotemIcon = AutoBar:LoggedGetSpellInfo(2894)
	local spellMagmaTotem = AutoBar:LoggedGetSpellInfo(8190)
	local spellSearingTotem = AutoBar:LoggedGetSpellInfo(3599)
	AutoBarCategoryList["Spell.Totem.Fire"] = AutoBarSpells:new(
			"Spell.Totem.Fire", spellFireElementalTotemIcon, {
			"SHAMAN", spellFireElementalTotem, --*
			"SHAMAN", spellMagmaTotem, --*
			"SHAMAN", spellSearingTotem, --*
			})

	local spellManaTideTotem = AutoBar:LoggedGetSpellInfo(16190)
	local spellHealingStreamTotem, _,  spellHealingStreamTotemIcon = AutoBar:LoggedGetSpellInfo(5394)
	local spellHealingTideTotem = AutoBar:LoggedGetSpellInfo(108280)
	AutoBarCategoryList["Spell.Totem.Water"] = AutoBarSpells:new(
			"Spell.Totem.Water", spellHealingStreamTotemIcon, {
			"SHAMAN", spellHealingStreamTotem, --*
			"SHAMAN", spellHealingTideTotem, --*
			"SHAMAN", spellManaTideTotem, --*
			})

	spellNameList["Windfury Weapon"], _, spellIconList["Windfury Weapon"] = AutoBar:LoggedGetSpellInfo(8232)
	spellNameList["Earthliving Weapon"] = AutoBar:LoggedGetSpellInfo(51730)
	spellNameList["Flametongue Weapon"] = AutoBar:LoggedGetSpellInfo(8024)
	spellNameList["Frostbrand Weapon"] = AutoBar:LoggedGetSpellInfo(8033)
	spellNameList["Rockbiter Weapon"] = AutoBar:LoggedGetSpellInfo(8017)
	
	AutoBarCategoryList["Spell.Buff.Weapon"] = AutoBarSpells:new(
			"Spell.Buff.Weapon", spellIconList["Windfury Weapon"], {
			"ROGUE", spellNameList["Deadly Poison"],
			"ROGUE", spellNameList["Wound Poison"],
			"ROGUE", spellNameList["Crippling Poison"],
			"ROGUE", spellNameList["Mind-numbing Poison"],
			"ROGUE", spellNameList["Leeching Poison"],
			"ROGUE", spellNameList["Paralytic Poison"],
			"SHAMAN", spellNameList["Windfury Weapon"],
			"SHAMAN", spellNameList["Rockbiter Weapon"],
			"SHAMAN", spellNameList["Frostbrand Weapon"],
			"SHAMAN", spellNameList["Flametongue Weapon"],
			"SHAMAN", spellNameList["Earthliving Weapon"],
			})

	spellNameList["First Aid"], _, spellIconList["First Aid"] = AutoBar:LoggedGetSpellInfo(27028)
	spellNameList["Alchemy"] = AutoBar:LoggedGetSpellInfo(28596)
	spellNameList["BasicCampfire"] = AutoBar:LoggedGetSpellInfo(818)
	spellNameList["Blacksmithing"] = AutoBar:LoggedGetSpellInfo(29844)
	spellNameList["Cooking"] = AutoBar:LoggedGetSpellInfo(33359)
	if (GetLocale() == "deDE") then
		spellNameList["Kochen"] = AutoBar:LoggedGetSpellInfo(51296)
		spellNameList["Alchemie"] = AutoBar:LoggedGetSpellInfo(51304)
	end
	spellNameList["Archaeology"] = AutoBar:LoggedGetSpellInfo(78670)
	spellNameList["Disenchant"] = AutoBar:LoggedGetSpellInfo(13262)
	spellNameList["Enchanting"] = AutoBar:LoggedGetSpellInfo(28029)
	spellNameList["Engineering"] = AutoBar:LoggedGetSpellInfo(30350)
	spellNameList["Inscription"] = AutoBar:LoggedGetSpellInfo(45357)
	spellNameList["Jewelcrafting"] = AutoBar:LoggedGetSpellInfo(28897)
	spellNameList["Leatherworking"] = AutoBar:LoggedGetSpellInfo(32549)
	spellNameList["Milling"] = AutoBar:LoggedGetSpellInfo(51005)
	spellNameList["Prospecting"] = AutoBar:LoggedGetSpellInfo(31252)
	spellNameList["Runeforging"] = AutoBar:LoggedGetSpellInfo(53428)
	spellNameList["Smelting"] = AutoBar:LoggedGetSpellInfo(2656)
	spellNameList["Survey"] = AutoBar:LoggedGetSpellInfo(80451)
	spellNameList["Tailoring"] = AutoBar:LoggedGetSpellInfo(26790)
	local craftList = {
		"*", spellNameList["Alchemy"],
		"*", spellNameList["Archaeology"],
		"*", spellNameList["BasicCampfire"],
		"*", spellNameList["Blacksmithing"],
		"*", spellNameList["Cooking"],
		"*", spellNameList["Disenchant"],
		"*", spellNameList["Enchanting"],
		"*", spellNameList["Engineering"],
		"*", spellNameList["First Aid"],
		"*", spellNameList["Inscription"],
		"*", spellNameList["Jewelcrafting"],
		"*", spellNameList["Leatherworking"],
		"*", spellNameList["Milling"],
		"*", spellNameList["Prospecting"],
		"*", spellNameList["Smelting"],
		"*", spellNameList["Survey"],
		"*", spellNameList["Tailoring"],
		"DEATHKNIGHT", spellNameList["Runeforging"],
	}
	if (GetLocale() == "deDE") then
		tinsert(craftList, "*")
		tinsert(craftList, spellNameList["Alchemie"])
		tinsert(craftList, "*")
		tinsert(craftList, spellNameList["Kochen"])
	end

	AutoBarCategoryList["Spell.Crafting"] = AutoBarSpells:new(
			"Spell.Crafting", spellIconList["First Aid"], craftList)

	AutoBarCategoryList["Spell.Debuff.Multiple"] = AutoBarSpells:new(
			"Spell.Debuff.Multiple", spellIconList["Curse of Enfeeblement"], {
			"DRUID", spellNameList["Disorienting Roar"],
			"DRUID", spellNameList["Faerie Fire"],
			"WARLOCK", spellNameList["Curse of Exhaustion"],
			"WARLOCK", spellNameList["Curse of Enfeeblement"],
			"WARLOCK", spellNameList["Curse of the Elements"],
			})

	spellNameList["Hunter's Mark"] = AutoBar:LoggedGetSpellInfo(1130)
	spellNameList["Widow Venom"] = AutoBar:LoggedGetSpellInfo(82654)
	spellNameList["Wyvern Sting"] = AutoBar:LoggedGetSpellInfo(19386)
	spellNameList["Silence"] = AutoBar:LoggedGetSpellInfo(15487)
	spellNameList["Blind"] = AutoBar:LoggedGetSpellInfo(2094)
	spellNameList["Sap"] = AutoBar:LoggedGetSpellInfo(6770)
	AutoBarCategoryList["Spell.Debuff.Single"] = AutoBarSpells:new(
			"Spell.Debuff.Single", spellIconList["Slow"], {
			"HUNTER", spellNameList["Hunter's Mark"], --*
			"HUNTER", spellNameList["Widow Venom"], --*
			"HUNTER", spellNameList["Wyvern Sting"], --*
			})

	spellNameList["Fishing"], _, spellIconList["Fishing"] = AutoBar:LoggedGetSpellInfo(131474)
	AutoBarCategoryList["Spell.Fishing"] = AutoBarSpells:new(
			"Spell.Fishing", spellIconList["Fishing"], {
			"*", spellNameList["Fishing"],
			})

	AutoBarCategoryList["Spell.Seal"] = AutoBarSpells:new(
			"Spell.Seal", spellIconList["Seal of Insight"], {
			"PALADIN", spellNameList["Seal of Insight"], --*
			"PALADIN", spellNameList["Seal of Justice"], --*
			"PALADIN", spellNameList["Seal of Righteousness"], --*
			"PALADIN", spellNameList["Seal of Truth"], --*
			})


	spellNameList["Explosive Trap"] = AutoBar:LoggedGetSpellInfo(13813)
	spellNameList["Freezing Trap"] = AutoBar:LoggedGetSpellInfo(1499)
	spellNameList["Ice Trap"] = AutoBar:LoggedGetSpellInfo(13809)
	spellNameList["Snake Trap"], _, spellIconList["Snake Trap"] = AutoBar:LoggedGetSpellInfo(34600)
	spellNameList["Trap Launcher"] = AutoBar:LoggedGetSpellInfo(77769)

	AutoBarCategoryList["Spell.Trap"] = AutoBarSpells:new(
		"Spell.Trap", spellIconList["Snake Trap"], {
		"HUNTER", spellNameList["Explosive Trap"], --*
		"HUNTER", spellNameList["Freezing Trap"], --*
		"HUNTER", spellNameList["Ice Trap"], --*
		"HUNTER", spellNameList["Snake Trap"], --*
		"HUNTER", spellNameList["Trap Launcher"], --*
	})

	spellNameList["Flight Form"] = AutoBar:LoggedGetSpellInfo(33943)
	spellNameList["Swift Flight Form"] = AutoBar:LoggedGetSpellInfo(40120)
	spellNameList["Travel Form"], _, spellIconList["Travel Form"] = AutoBar:LoggedGetSpellInfo(783)
	spellNameList["GhostWolf"] = AutoBar:LoggedGetSpellInfo(2645)
	spellNameList["Running Wild"] = AutoBar:LoggedGetSpellInfo(87840)
	
	AutoBarCategoryList["Misc.Mount.Summoned"] = AutoBarSpells:new(
			"Misc.Mount.Summoned", spellIconList["Summon Dreadsteed"], {
			"DRUID", spellNameList["Flight Form"],
			"DRUID", spellNameList["Swift Flight Form"],
			"SHAMAN", spellNameList["GhostWolf"],
			"*",spellNameList["Running Wild"],
			})
	AutoBarCategoryList["Misc.Mount.Summoned"]:SetNonCombat(true)
end


local customCategoriesVersion = 3
-- Learned new spells etc.  Refresh all categories
function AutoBarCategory:Upgrade()
	if (not AutoBar.db.account.customCategories) then
		AutoBar.db.account.customCategories = {}
	end
	if (not AutoBar.db.account.customCategoriesVersion) then
		local newCustomCategories = {}
		local categoryKey
		local customCategories = AutoBar.db.account.customCategories
		for index, customCategoryDB in pairs(customCategories) do
			customCategoryDB.name = customCategoryDB.name:gsub("%.", "")
			categoryKey = AutoBarCustom:GetCustomKey(customCategoryDB.name)
			customCategoryDB.categoryKey = categoryKey
			newCustomCategories[categoryKey] = customCategoryDB
		end
		AutoBar.db.account.customCategories = newCustomCategories
		AutoBar.db.account.customCategoriesVersion = 1
	end
	if (AutoBar.db.account.customCategoriesVersion < customCategoriesVersion) then
		local customCategories = AutoBar.db.account.customCategories
		local newCustomCategories = {}
		local categoryKey
		if (AutoBar.db.account.customCategoriesVersion < 3) then
			for index, customCategoryDB in pairs(customCategories) do
				customCategoryDB.name = AutoBar:GetValidatedName(customCategoryDB.name)
				categoryKey = AutoBarCustom:GetCustomKey(customCategoryDB.name)
				if (categoryKey ~= index) then
					customCategoryDB.categoryKey = categoryKey
					AutoBar.Class.Button:RenameCategory(index, categoryKey)
				end
				if (customCategoryDB.categoryKey ~= categoryKey) then
					AutoBar.Class.Button:RenameCategory(customCategoryDB.categoryKey, categoryKey)
					customCategoryDB.categoryKey = categoryKey
				end
				newCustomCategories[categoryKey] = customCategoryDB
			end
			AutoBar.db.account.customCategories = newCustomCategories
			AutoBar.db.account.customCategoriesVersion = 3
		end
	end
end

-- Learned new spells etc.  Refresh all categories
function AutoBarCategory:UpdateCategories()
	for categoryKey, categoryInfo in pairs(AutoBarCategoryList) do
		categoryInfo:Refresh()
	end
end


function AutoBarCategory:UpdateCustomCategories()
	local customCategories = AutoBar.db.account.customCategories

	for categoryKey, customCategoriesDB in pairs(customCategories) do
		assert(customCategoriesDB and (categoryKey == customCategoriesDB.categoryKey), "customCategoriesDB nil or bad categoryKey")
		if (not AutoBarCategoryList[categoryKey]) then
			AutoBarCategoryList[categoryKey] = AutoBarCustom:new(customCategoriesDB)
		end
	end

	for categoryKey, categoryInfo in pairs(AutoBarCategoryList) do
		categoryInfo:Refresh()

		if (categoryInfo.customKey and not customCategories[categoryKey]) then
			AutoBarCategoryList[categoryKey] = nil
		end
	end

	for categoryKey in pairs(AutoBar.categoryValidateList) do
		AutoBar.categoryValidateList[categoryKey] = nil
	end
	for categoryKey, categoryInfo in pairs(AutoBarCategoryList) do
		AutoBar.categoryValidateList[categoryKey] = categoryInfo.description
	end
end


--[[
/dump AutoBarCategoryList["Consumable.Cooldown.Potion.Health.PvP"]
/dump AutoBarCategoryList["Spell.Crafting"].castList
/dump AutoBarCategoryList["Consumable.Buff Group.Caster.Self"]
/dump LibStub("LibPeriodicTable-3.1"):GetSetTable("Consumable.Buff Group.Caster.Self")
/script for itemId, value in LibStub("LibPeriodicTable-3.1"):IterateSet("Consumable.Buff Group.Caster.Self") do AutoBar:Print(itemId .. " " .. value); end
--]]
