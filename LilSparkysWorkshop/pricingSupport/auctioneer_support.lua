






-- auctioneer support

do
	local algorithm = market

	local SimpleAuctionPrivate


	local function AuctionPriceMarket(link)
		if not link then
			return nil
		end

		local sellPrice, numSeen = AucAdvanced.API.GetMarketValue(link)

		return sellPrice, numSeen
	end


	local function AuctionPriceAppraiser(link)
		if not link then
			return nil
		end

		local sellPrice, numSeen = AucAdvanced.Modules.Util.Appraiser.GetPrice(link)

		return sellPrice, numSeen
	end

	local function AuctionPriceMinBuyout(link)
		if not link then
			return nil
		end

--		local sellPrice, numSeen = AucAdvanced.Modules.Util.Appraiser.GetPrice(link)
		local imgSeen, image, matchBid, matchBuy, lowBid, lowBuy, aveBuy, aSeen = AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(link)

		if imgSeen <= 0 then
			return nil, 0
		end

		return lowBuy, imgSeen
	end


	local function Init()
		LSW:RegisterAlgorithm("Auctioneer Market", AucAdvanced.API.GetMarketValue)

		if AucAdvanced.Modules.Util.Appraiser then
			LSW:RegisterAlgorithm("Auctioneer Appraiser", AucAdvanced.Modules.Util.Appraiser.GetPrice)
		end

		if AucAdvanced.Modules.Util.SimpleAuction then
			SimpleAuctionPrivate = AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems

			LSW:RegisterAlgorithm("Auctioneer Min Buyout", AuctionPriceMinBuyout)
		end

		local engines = AucAdvanced.GetAllModules(nil, "Stat")


		for pos, engineLib in ipairs(engines) do
			local name = engineLib.GetName()

			LSW:RegisterAlgorithm("Auctioneer "..name, function(link)
				return AucAdvanced.API.GetAlgorithmValue(name, link)
			end)
		end

		local lib,parent,private = AucAdvanced.NewModule("Util", "LSWPriceRescan")

		function lib.Processor(callbackType)
			if (callbackType == "scanstats") then
--				LSW:FlushPriceData()
				LSW:UpdateData()
			end
		end
	end


	local function Test(index)
		if AucAdvanced and AucAdvanced.Version then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Auctioneer", Test, Init)
end



