-- This is a helper file for displaying tips in the status bar of the main TSM frame.
local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table

local currentTip = {time=0}

local modules = {"tsm", "auctiondb", "auctioning", "crafting", "shopping"}

local tips = {
	tsm = {
		L["There is a checkbox for hiding the minimap icon in the status page of the main TSM window."],
		L["The only required module of TradeSkillMaster is the main one (TradeSkillMaster). All others may be disabled if you are not using them."],
		L["Want more tips? Click on the \"New Tip\" button at the bottom of the status page."],
	},
	auctiondb = {
		L["Have you tried running a GetAll scan? It's the fastest possible way to scan by far so give it a shot!"],
		L["AuctionDB can put market value, min buyout, and seen count info into item tooltips. You can turn this on / off in the options tab of the AuctionDB page."],
		L["\"/tsm adbreset\" will reset AuctionDB's scan data. There is a confirmation prompt."],
	},
	auctioning = {
		L["Auctioning's CancelAll scan can be used to quickly cancel specific items. Anything from items under a certain duration to specific items, to entire groups."],
		L["There is an option for hiding Auctioning's advanced options in the top \"Options\" page of the Auctioning page in the main TSM window."],
	},
	crafting = {
		L["If the Craft Management Window is too big, you can scale it down in the Crafting options."],
		L["Crafting can make Auctioning groups for you. Just click on a profession icon, a category, and then the \"Create Auctioning Groups\" button."],
		L["Any craft that is disabled in the category pages of one of the Crafting profession icons in the main TSM window won't show up in the Craft Management Window."],
		L["Crafting's on-hand queue will queue up the most profitable items you can make from the materials you have in your bags."],
	},
	shopping = {
		L["When using shopping to buy herbs for inks, it will automatically check if it's cheaper to buy herbs for blackfallow ink and trade down (this can be turned off)."],
	},
}

function TSM:GetTip()
	-- new tip every minute at most
	if (GetTime() - currentTip.time) > 60 then
		local totalTips = 0
		for i=1, #modules do
			totalTips = totalTips + #tips[modules[i]]
		end
		
		-- get a new tipNum that's different than the current one
		local tipNum
		while true do
			tipNum = random(1, totalTips)
			if tipNum ~= currentTip.num then
				break
			end
		end
		
		currentTip.num = tipNum
		
		for i=1, #modules do
			local moduleTips = #tips[modules[i]]
			if tipNum <= moduleTips then
				currentTip.text = tips[modules[i]][tipNum]
				break
			else
				tipNum = tipNum - moduleTips
			end
		end
		currentTip.time = GetTime()
	end
	
	return currentTip.text
end

--- Forces a new tip to show up in the bottom status text of the main TSM window.
function TSMAPI:ForceNewTip()
	currentTip.time = 0
	TSMAPI:SetStatusText()
end