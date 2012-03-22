




-- auctionatorsupport


do

	local function DisenchantValue(itemID)
		return Atr_GetDisenchantValue(itemID)
	end


	local function AuctionPrice(itemID)
		return Atr_GetAuctionBuyout(itemID)
	end


	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding Auctionator support")

		LSW:RegisterAlgorithm("Auctionator", AuctionPrice)

		Atr_RegisterFor_DBupdated(function() LSW:FlushPriceData() end)

		LSW.disenchantValue = DisenchantValue
	end


	local function Test(index)
		if Atr_GetAuctionBuyout then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Auctionator", Test, Init)
end
