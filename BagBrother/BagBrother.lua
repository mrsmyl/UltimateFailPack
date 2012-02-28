--[[
Copyright 2011-2012 João Cardoso
BagBrother is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of LibItemCache.

BagBrother is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BagBrother is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with BagBrother. If not, see <http://www.gnu.org/licenses/>.
--]]

local Brother = CreateFrame('Frame', 'BagBrother')
Brother:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
Brother:RegisterEvent('ADDON_LOADED')
Brother:RegisterEvent('PLAYER_LOGIN')
BrotherBags = BrotherBags or {}

local Player = UnitName('player')
local Realm = GetRealmName()

local VERSION = 1
local VAULT_SLOTS = 80


--[[ Locals ]]--

local function SaveItem(link, count)
  if link then
    link = link:sub(18, -9)
    if link:match('0:0:0:0:0:0:[^:]+:[^:]+:0') then
      link = link:match('^(%d+)')
    else
      link = link:match('^(.+)%|')
    end

    if count and count > 1 then
      link = link .. ';' .. count
    end
    return link
  end
end

local function SaveEquip(i, count)
  local link = GetInventoryItemLink('player', i)
  local count = count or GetInventoryItemCount('player', i)

  Player.equip[i] = SaveItem(link, count)
end

local function SaveBag(bag, onlyItems)
  local size = GetContainerNumSlots(bag)
  if size > 0 then
    local items = {}
    for slot = 1, size do
      local _, count, _,_,_,_, link = GetContainerItemInfo(bag, slot)
      items[slot] = SaveItem(link, count)
    end

    if not onlyItems then
      SaveEquip(ContainerIDToInventoryID(bag), size)
    end

    Player[bag] = items
  else
    Player[bag] = nil
  end
end


--[[ Startup ]]--

function Brother:ADDON_LOADED()
	-- Start Cache
	BrotherBags[Realm] = BrotherBags[Realm] or {}
	BrotherBags[Realm][Player] = BrotherBags[Realm][Player] or {equip = {}}

	-- Set Variables
	Realm = BrotherBags[Realm]
	Player = Realm[Player]

	-- Start Player
	Player.class = select(2, UnitClass('player'))
	Player.race = select(2, UnitRace('player'))
	Player.sex = UnitSex('player')
	
	-- Done
	self:UnregisterEvent('ADDON_LOADED')
	self.ADDON_LOADED = nil
end

function Brother:PLAYER_LOGIN()
	-- Register Events
	self:RegisterEvent('UNIT_INVENTORY_CHANGED')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('BAG_UPDATE')

	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	self:RegisterEvent('VOID_STORAGE_OPEN')
	self:RegisterEvent('VOID_STORAGE_CLOSE')

	self:UnregisterEvent('PLAYER_LOGIN')
	self.PLAYER_LOGIN = nil

	-- Save All
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		self:BAG_UPDATE(i)
	end

	self:UNIT_INVENTORY_CHANGED('player')
	self:PLAYER_MONEY()
end


--[[ Events ]]--

function Brother:BAG_UPDATE(bag)
	if bag > BANK_CONTAINER and bag <= NUM_BAG_SLOTS then
  		SaveBag(bag, bag == BACKPACK_CONTAINER)
	end
end

function Brother:UNIT_INVENTORY_CHANGED(unit)
  if unit == 'player' then
    for i = 1, INVSLOT_LAST_EQUIPPED do
      SaveEquip(i)
    end
  end
end

function Brother:PLAYER_MONEY()
  Player.money = GetMoney()
end

function Brother:BANKFRAME_OPENED()
  self.atBank = true
end

function Brother:BANKFRAME_CLOSED()
  if self.atBank then
    for i = 1 + NUM_BAG_SLOTS, NUM_BANKBAGSLOTS + NUM_BAG_SLOTS do
      SaveBag(i)
    end

    SaveBag(BANK_CONTAINER, true)
    self.atBank = nil
  end
end

function Brother:VOID_STORAGE_OPEN()
  self.atVault = true
end

function Brother:VOID_STORAGE_CLOSE()
  if self.atVault then
  	Player.vault = {}
	self.atVault = nil

  	for i = 1, VAULT_SLOTS do
    	Player.vault[i] = GetVoidItemInfo(i)
  	end
  end
end