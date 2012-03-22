



-- auctionmaster support

do
	local auctionMasterSupport = {}

	auctionMasterSupport.isNeutral = false

	function scanUpdated()
		LSW:FlushPriceData()
	end

	local function GetItemLink(itemID)
		if itemID then
			local _,link = GetItemInfo(itemID)
			return link
		end

		return nil
	end


	local function AuctionPrice(itemID)
		local link = GetItemLink(itemID)

		if not link then
			return nil
		end

--		local _, sellPrice = AuctionMaster.Statistic:GetAuctionInfo(link, auctionMasterSupport.isNeutral)

		local avgBid, avgBuy, numBid, numBuy = AucMasGetAuctionInfo(link, auctionMasterSupport.isNeutral)

		return avgBuy or 0, numBuy or 0
	end



	local function AuctionPriceCurrent(itemID)
		local link = GetItemLink(itemID)

		if not link then
			return nil
		end

--[[
		local result = AuctionMaster.Scanner:GetScanSet(auctionMasterSupport.isNeutral, link)

		local totalBuyout = 0
		local numItems = 0

		if (result and result:Size() > 0) then
			for i = 1, result:Size() do
				local itemLinkKey, time, timeLeft, count, minBid, minIncrement, buyout = result:Get(i)

				if buyout then
					numItems = numItems + count
					totalBuyout = totalBuyout + buyout
				end
			end
		end

		if numItems>0 then
			return floor(totalBuyout/numItems), numItems
		else
			return nil, 0
		end

]]--

		local avgBid, avgBuy, minBid, minBuy, maxBid, maxBuy, numBid, numBuy = AucMasGetCurrentAuctionInfo(link, auctionMasterSupport.isNeutral, auctionMasterSupport.adjustPrices)

		return avgBuy or 0, numBuy or 0
	end


	local function AuctionPriceMinBuyout(itemID)
		local link = GetItemLink(itemID)

		if not link then
			return nil
		end

--[[
		local result = AuctionMaster.Scanner:GetScanSet(auctionMasterSupport.isNeutral, link)

		local minBuyout
		local numItems = 0

		if (result and result:Size() > 0) then
			for i = 1, result:Size() do
				local itemLinkKey, time, timeLeft, count, minBid, minIncrement, buyout = result:Get(i)

				if buyout then
					buyout = buyout / count

					numItems = numItems + count

					if (not minBuyout) or (minBuyout > buyout) then
						minBuyout = buyout
					end
				end
			end
		end

		return minBuyout, numItems
]]--

		local avgBid, avgBuy, minBid, minBuy, maxBid, maxBuy, numBid, numBuy = AucMasGetCurrentAuctionInfo(link, auctionMasterSupport.isNeutral, auctionMasterSupport.adjustPrices)

		return minBuy or 0, numBuy or 0
	end






	local function Init()
		local faction = UnitFactionGroup("player")
--		LSW:ChatMessage("LilSparky's Workshop adding AuctionMaster support")

--		AuctionMaster.Scanner:AddScanSnapshotListener(auctionMasterSupport)

		AucMasRegisterStatisticCallback(scanUpdated)

		local function redraw(button, opt)
			CloseDropDownMenus()
			LSW:CreateTimer("updateData-Redraw", 0.05, LSW.UpdateData)
		end

		local optionsMenu = LSW:RegisterMenu("Display Options")

		local optionsMenu = LSW:RegisterMenu("AuctionMaster Options")
		optionsMenu:RegisterToggle("AuctionMaster: Neutral Data", auctionMasterSupport, "isNeutral", redraw)
		optionsMenu:RegisterToggle("AuctionMaster: Remove Extremes", auctionMasterSupport, "adjustPrices", redraw)

		local optionsMenuTable = optionsMenu:GenerateMenuTable(function(button, opt)
			CloseDropDownMenus()
			LSW:FlushPriceData()
		end)


		LSW:RegisterAlgorithm("AuctionMaster Historical", AuctionPrice)
		LSW:RegisterAlgorithm("AuctionMaster Current", AuctionPriceCurrent)
		LSW:RegisterAlgorithm("AuctionMaster Min Buyout", AuctionPriceMinBuyout)


		return optionsMenuTable
	end


	local function Test(index)
		if IsAddOnLoaded("AuctionMaster") and (AucMasStatisticVersion and AucMasStatisticVersion.major==1) then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("AuctionMaster", Test, Init)
end

