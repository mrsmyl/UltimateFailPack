






-- informant support

--[[
	note: informant supports the GetSellValue co-operative API, however GetSellValue doesn't provide useful information for vendor item costs in cases where an item can't be sold to a vendor

	for this reason, it's better to use informant's native pricing vs its GetSellValue api hook and then disable the GetSellValue support by unregistering it's initialization sequence
	if GetSellValue support has already been initialized, informant support will over-ride it
]]

do
	local periodicTable

	local function VendorAvailability(itemID)
		local isVendored,isLimited,itemCost,sellPrice,buyStack,maxStack = Informant.getItemVendorInfo(itemID)

--LSW:ChatMessage((GetItemInfo(itemID)).." is vendored? "..tostring(isVendored).." "..tostring(isLimited))

		if isVendored==true and isLimited==false and itemCost and itemCost > 0 then
--DEFAULT_CHAT_FRAME:AddMessage("item "..itemID.." is a vendor item "..tostring(GetItemInfo(itemID)))
			return true
		end
--DEFAULT_CHAT_FRAME:AddMessage("item "..itemID.." is a vendor item "..tostring(GetItemInfo(itemID)))
		return false
	end


	local function VendorCost(itemID)
		local itemInfo

		if (itemID and itemID > 0) and (Informant) then
			itemInfo = Informant.GetItem(itemID)
		end

		if itemInfo then
			return (itemInfo.buy or 0) / (itemInfo.quant or 1)
		end

		return nil
	end


	local function VendorValue(itemID)
		local itemInfo

		if (itemID and itemID > 0) and (Informant) then
			itemInfo = Informant.GetItem(itemID)
		end

		if itemInfo then
			return itemInfo.sell
		end

		return nil
	end


	local function Init()
		LSW.vendorValue = VendorValue
		LSW.vendorCost = VendorCost

		local major, minor = string.match(Informant.version, "(%d+)%.(%d+)%.")

		major = tonumber(major) or 0
		minor = tonumber(minor) or 0

		if Informant.getItemVendorInfo and (major>5 or (major==5 and minor>5)) then			-- if version is not 5.6 or greater, then the availabilty function in informant is buggy so don't use it
			LSW.vendorAvailability = VendorAvailability
		end

		LSW:RegisterPricingSupport("GetSellValue", function() return false end, Init)		-- disable GetSellValue support
	end


	local function Test(index)

		if Informant then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Informant", Test, Init)
end



