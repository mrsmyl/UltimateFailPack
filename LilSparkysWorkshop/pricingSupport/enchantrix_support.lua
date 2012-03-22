


-- enchantrix support
-- deprecated

do
	local function DisenchantValue(itemID)
		local hsp, med, mkt, five = Enchantrix.Storage.GetItemDisenchantTotals(itemID)

		return five or -1
	end


	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding Enchantrix support")

		LSW.getDisenchantValue = DisenchantValue
	end


	local function Test(index)
		if Enchantrix then
			return true
		end

		return false
	end

--	de values now come from internal support
--	LSW:RegisterPricingSupport("Enchantrix", Test, Init)
end

