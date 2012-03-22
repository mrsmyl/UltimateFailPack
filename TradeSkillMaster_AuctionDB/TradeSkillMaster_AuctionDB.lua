-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_AuctionDB", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

TSM.version = GetAddOnMetadata("TradeSkillMaster_AuctionDB","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Version") -- current version of the addon
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table

local SECONDS_PER_DAY = 60*60*24

local savedDBDefaults = {
	factionrealm = {
		scanData = "",
		time = 0,
		lastAutoUpdate = 0;
	},
	profile = {
		scanSelections = {},
		tooltip = true,
		resultsPerPage = 50,
		resultsSortOrder = "ascending",
		resultsSortMethod = "name",
		hidePoorQualityItems = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_AuctionDBDB", savedDBDefaults, true)

	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end

	TSM:Deserialize(TSM.db.factionrealm.scanData)
	TSM.db.factionrealm.playerAuctions = nil

	TSM:RegisterEvent("PLAYER_LOGOUT", TSM.OnDisable)

	TSMAPI:RegisterReleasedModule("TradeSkillMaster_AuctionDB", TSM.version, GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Author"), GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Notes"))
	TSMAPI:RegisterIcon("AuctionDB", "Interface\\Icons\\Inv_Misc_Platnumdisks", function(...) TSM.Config:Load(...) end, "TradeSkillMaster_AuctionDB")
	TSMAPI:RegisterSlashCommand("adbreset", TSM.Reset, L["Resets AuctionDB's scan data"], true)
	TSMAPI:RegisterData("market", TSM.GetData)
	TSMAPI:RegisterData("seenCount", TSM.GetSeenCount)
	TSMAPI:AddPriceSource("DBMarket", L["AuctionDB - Market Value"], function(itemLink) return TSM:GetData(itemLink) end)
	TSMAPI:AddPriceSource("DBMinBuyout", L["AuctionDB - Minimum Buyout"], function(itemLink) return select(5, TSM:GetData(itemLink)) end)

	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_AuctionDB", function(...) return TSM:LoadTooltip(...) end)
	end
	
	-- update for release version
	TSM.db.profile.scanSelections["Complete AH Scan"] = nil
	TSM.db.profile.scanSelections["Complete AH Scan (slow)"] = nil
	TSM.db.profile.getAll = nil
	TSM.db.profile.blockAuc = nil

	TSM.db.factionrealm.time = 10 -- because AceDB won't save if we don't do this...
end

function TSM:OnEnable()
	if TSM.CheckNewAuctionData then
		TSM:CheckNewAuctionData()
	end
end

function TSM:OnDisable()
	TSM:Serialize(TSM.data)
end

function TSM:LoadTooltip(itemID, quantity)
	local marketValue, _, lastScan, totalSeen, minBuyout = TSM:GetData(itemID)

	local text = {}
	local marketValueText, minBuyoutText
	if marketValue then
		if quantity and quantity > 1 then
			tinsert(text, L["AuctionDB Market Value:"].." "..TSMAPI:FormatTextMoney(marketValue, "|cffffffff").." ("..TSMAPI:FormatTextMoney(marketValue*quantity, "|cffffffff")..")")
		else
			tinsert(text, L["AuctionDB Market Value:"].." "..TSMAPI:FormatTextMoney(marketValue, "|cffffffff"))
		end
	end
	if minBuyout then
		if quantity and quantity > 1 then
			tinsert(text, L["AuctionDB Min Buyout:"].." |cffffffff"..TSMAPI:FormatTextMoney(minBuyout, "|cffffffff").." ("..TSMAPI:FormatTextMoney(minBuyout*quantity, "|cffffffff")..")")
		else
			tinsert(text, L["AuctionDB Min Buyout:"].." |cffffffff"..TSMAPI:FormatTextMoney(minBuyout, "|cffffffff"))
		end
	end
	if totalSeen then
		tinsert(text, L["AuctionDB Seen Count:"].." |cffffffff"..totalSeen)
	end

	return text
end

function TSM:Reset()
	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] = StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] or {
		text = L["Are you sure you want to clear your AuctionDB data?"],
		button1 = YES,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function()
			for i in pairs(TSM.data) do
				TSM.data[i] = nil
			end
			TSM:Print(L["Reset Data"])
		end,
		OnCancel = false,
	}

	StaticPopup_Show("TSMAuctionDBClearDataConfirm")
	for i=1, 10 do
		local popup = _G["StaticPopup" .. i]
		if popup and popup.which == "TSMAuctionDBClearDataConfirm" then
			popup:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

function TSM:GetData(itemID)
	if itemID and not tonumber(itemID) then
		itemID = TSMAPI:GetItemID(itemID)
	end
	if not itemID then return end
	itemID = TSMAPI:GetNewGem(itemID) or itemID
	if not TSM.data[itemID] then return end
	local newMarketValue = TSM.Data:GetMarketValue(TSM.data[itemID].scans)
	if newMarketValue ~= TSM.data[itemID].marketValue then
		TSM.data[itemID].marketValue = newMarketValue
	end
	
	local marketValue = TSM.data[itemID].marketValue ~= 0 and TSM.data[itemID].marketValue or nil
	
	return marketValue, TSM.data[itemID].currentQuantity, TSM.data[itemID].lastScan, TSM.data[itemID].seen, TSM.data[itemID].minBuyout
end

local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_="
local base = #alpha
local alphaTable = {}
for i=1, base do
	tinsert(alphaTable, strsub(alpha, i, i))
end

local function decode(h)
	if strfind(h, "~") then return end
	local result = 0

	local i = #h - 1
	for w in string.gmatch(h, "([A-Za-z0-9_=])") do
		result = result + (strfind(alpha, w)-1)*(base^i)
		i = i - 1
	end

	return result
end

local function encode(d)
	d = tonumber(d)
	if not d or not (d < math.huge and d > 0) then -- this cannot be simplified since 0/0 is neither less than nor greater than any number
		return "~"
	end
	
	local r = d % base
	local diff = d - r
	if diff == 0 then
		return alphaTable[r+1]
	else
		return encode((diff)/base) .. alphaTable[r+1]
	end
end

function encodeScans(scans)
	local result

	for day, data in pairs(scans) do
		if type(data) == "table" then
			if result then
				result = result .. "!"
			end
			result = (result or "") .. encode(day) .. ":"
			--local dayInfo = {}
			for i=1, #data do
				--dayInfo[i] = encode(data[i])
				result = result .. encode(data[i]) .. (data[i+1] and ";" or "")
			end
			--result = result .. table.concat(dayInfo, ";")
		else
			if result then
				result = result .. "!"
			end
			result = (result or "") .. encode(day) .. ":" .. encode(data)
		end
	end

	return result
end

function decodeScans(rope)
	if rope == "A" then return end
	local scans = {}
	local days = {("!"):split(rope)}
	for _, data in ipairs(days) do
		local day, marketValueData = (":"):split(data)
		day = decode(day)
		scans[day] = {}
		for _, value in ipairs({(";"):split(marketValueData)}) do
			local decodedValue = decode(value)
			if decodedValue ~= "~" then
				tinsert(scans[day], tonumber(decodedValue))
			end
		end
	end
	
	return scans
end

function TSM:Serialize()
	local results, scans = {}, nil
	for id, v in pairs(TSM.data) do
		if v.marketValue then
			tinsert(results, "?"..encode(id)..","..encode(v.seen)..","..encode(v.marketValue)..","..encode(v.lastScan)..","..encode(v.currentQuantity or 0)..","..encode(v.minBuyout)..","..encodeScans(v.scans))
		end
	end
	TSM.db.factionrealm.scanData = table.concat(results)
end

function TSM:Deserialize(data)
	if strsub(data, 1, 1) ~= "?" then
		TSM.data = {}
		return
	end

	TSM.data = TSM.data or {}
	for k,a,b,c,d,f,s in gmatch(data, "?([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^?]+)") do
		local itemID = decode(k)
		TSM.data[itemID] = {seen=decode(a),marketValue=decode(b),lastScan=decode(c),currentQuantity=(decode(d) or 0),minBuyout=decode(f),scans=decodeScans(s)}
	end
end

function TSM:GetSeenCount(itemID)
	return TSM.data[itemID] and TSM.data[itemID].seen
end