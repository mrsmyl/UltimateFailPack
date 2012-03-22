


-- auctionlite support

do
	local function DisenchantValue(itemID)
		return AuctionLite:GetDisenchantValue(itemID)
	end

	local function AuctionPrice(itemID) -- auctionlite version
		if not itemID then
			return nil
		end

		local hist = AuctionLite:GetHistoricalPriceById(itemID, 0)

		local price, count

		if hist then
			price, count = math.floor(hist.price), math.floor(hist.items)
		end

		return price, count
--		return AuctionLite:GetAuctionValue(itemID)
	end

	local function OnScanComplete()
		LSW:FlushPriceData()
	end

	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding AuctionLite support")

		LSW:RegisterAlgorithm("AuctionLite", AuctionPrice)

		LSW.disenchantValue = DisenchantValue

--		TODO: figure out when to flush the auction data

	end


	local function Test(index)
		if AuctionLite then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("AuctionLite", Test, Init)
end

