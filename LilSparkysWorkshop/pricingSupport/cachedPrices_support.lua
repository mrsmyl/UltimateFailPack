






-- cached auction support support

do
	local function SaveCachedPrices()
		for id in pairs(LSW.itemCache) do
			LSWPrices.value[id], LSWPrices.valueSamples[id] = LSW.auctionValue(id)
			LSWPrices.cost[id], LSWPrices.costSamples[id] = LSW.auctionCost(id)
		end

		for id in pairs(LSWPrices.value) do
			LSWPrices.value[id], LSWPrices.valueSamples[id] = LSW.auctionValue(id)
			LSWPrices.cost[id], LSWPrices.costSamples[id] = LSW.auctionCost(id)
		end
	end



	local function CachedValue(itemID)
		if not itemID then
			return nil
		end

		return LSWPrices.value[itemID], LSWPrices.valueSamples[itemID]
	end


	local function CachedCost(itemID)
		if not itemID then
			return nil
		end

		return LSWPrices.cost[itemID], LSWPrices.costSamples[itemID]
	end


	local function Init()
		LSW:RegisterAlgorithm("Cached Value", CachedValue)
		LSW:RegisterAlgorithm("Cached Cost", CachedCost)


		local f = CreateFrame("Frame")

		f:RegisterEvent("PLAYER_LOGOUT")

		f:SetScript("OnEvent", function(f,event)
			if event == "PLAYER_LOGOUT" then
				SaveCachedPrices()
			end
		end)
	end


	local function Test(index)
		return true
	end

	LSW:RegisterPricingSupport("Cached Prices", Test, Init)
end



