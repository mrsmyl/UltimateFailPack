--[[

$Revision: 35 $

(C) Copyright 2007,2008 Bethink (bethink at naef dot com)
See LICENSE.txt for license terms.

Compliance
- GetSellValue API [http://www.wowwiki.com/GetSellValue]

]]


----------------------------------------------------------------------
-- Subsystem

-- One-time initialization
function Analyst:InitializeVendorValue ()
	-- Initialize table as needed
	if not self.db.global.vendorValues then
		self.db.global.vendorValues = { }
	end
end

-- Handles (re-)enabling of the capture subsystem
function Analyst:EnableVendorValue ()
	-- Hook or set the API
	if getglobal("GetSellValue") then
		self:Hook("GetSellValue", "GetVendorValue")
	else
		setglobal("GetSellValue", function (item) return Analyst:GetVendorValue(item) end)
	end
end

-- Handles disabling of the vendor value subsystem
function Analyst:DisableVendorValue ()
end


----------------------------------------------------------------------
-- Vendor value

-- Returns the vendor value of item.
function Analyst:GetVendorValue (item)
	-- Skip bad arguments
	if not item then
		return nil
	end
	
	-- Get the item ID
	local itemId
	if type(item) == "number" then
		itemId = item
	else
		local _, itemLink = GetItemInfo(item)
		if not itemLink then
			return nil
		end
		itemId = self:GetItemId(self:GetItemString(itemLink))
	end
	
	-- Query own database
	if self.db.global.vendorValues[itemId] then
		return self.db.global.vendorValues[itemId]
	end
	
	-- Query hook chain
	if self.hooks["GetSellValue"] then
		return self.hooks["GetSellValue"](itemId)
	end
	
	-- Not found
	return nil
end

-- Registers a vendor value
function Analyst:RegisterVendorValue (itemId, value)
	self.db.global.vendorValues[itemId] = value;
end