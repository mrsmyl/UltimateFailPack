






-- GetSellValue support


do

	local function VendorCost(itemID)
		if itemID then
			local value = GetSellValue(itemID)

			if value then
				return value * 4
			end
		end
	end


	local function VendorValue(itemID)
		if itemID then
			local value = GetSellValue(itemID)

			if value then
				return value
			end
		end
	end


	local function Init()
		LSW.vendorValue = VendorValue
		LSW.vendorCost = VendorCost
	end


	local function Test(index)
		if GetSellValue then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("GetSellValue", Test, Init)
end



