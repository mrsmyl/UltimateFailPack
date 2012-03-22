-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


--load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Mail = TSM:NewModule("Mail", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Gathering")

local function debug(...)
	TSM:Debug(...)
end

local lockedItems, itemsToMail = {}, {}
local numItems, canSendMail

local throttle = CreateFrame("frame")
throttle:SetScript("OnUpdate", function(self, elapsed)
	if itemTimer then
		itemTimer = itemTimer - elapsed
		if itemTimer <= 0 then
			itemTimer = nil
			Mail:Send()
		end
	elseif mailTimer then
		mailTimer = mailTimer - elapsed
		if mailTimer <= 0 then
			mailTimer = nil
			Mail:AttachItems()
		end
	end
	
	if not (itemTimer or mailTimer) then
		self:Hide()
	end
end)
throttle:Hide()

function Mail:OnInitialize()
	Mail:RegisterEvent("MAIL_SHOW")
end

function Mail:MAIL_SHOW()
	if TSM.tasks[1] and TSM.tasks[1].location == "MAIL" then
		TSMAPI:CreateTimeDelay("GatheringSendMail", 0.5, Mail.StartMailing)
		Mail:RegisterEvent("MAIL_CLOSED")
	end
end

function Mail:MAIL_CLOSED()
	Mail:StopMailing()
end

function Mail:StartMailing()
	MailFrameTab2:Click()
	SendMailNameEditBox:SetText(TSM.db.factionrealm.currentCrafter)
	
	wipe(itemsToMail)
	numItems = 0
	canSendMail = true
	
	itemsToMail = TSM.tasks[1].items
	for _ in pairs(TSM.tasks[1].items) do
		numItems = numItems+1
	end
	
	mailTimer = 0.5
	throttle:Show()
end

function Mail:AttachItems()
	local moreItems = false
	for itemID, quantity in pairs(itemsToMail) do
		if quantity == 0 then
			itemsToMail[itemID] = nil
		else
			moreItems = true
		end
	end
	if not moreItems then
		return Mail:StopMailing()
	end

	-- see if we can send anything off
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			local itemID = TSMAPI:GetItemID(GetContainerItemLink(bag, slot))
			if itemsToMail[itemID] then
				local quantity, locked = select(2, GetContainerItemInfo(bag, slot))
				local slotString = tostring(bag).."$"..tostring(slot)
				
				if not locked then lockedItems[slotString] = nil end
				
				if locked and lockedItems[slotString] and lockedItems[slotString] ~= quantity then
					lockedItems[slotString] = quantity
					itemTimer = 3
					throttle:Show()
				elseif not locked then
					-- Not locked, let's add it up!
					local attachments = Mail:GetPendingAttachments()
					
					-- Too many attached, nothing we can do yet
					if #(attachments) >= ATTACHMENTS_MAX_SEND then return end

					PickupContainerItem(bag, slot)
					ClickSendMailItemButton()
					
					lockedItems[slotString] = quantity

					-- Hit cap, send us off
					if (#(attachments) + 1) >= ATTACHMENTS_MAX_SEND then
						Mail:Send()
					end
				end
			end
		end
	end
	
	if canSendMail then
		Mail:Send()
	end
end

function Mail:GetPendingAttachments()
	local attachments = {}
	for i=1, ATTACHMENTS_MAX_SEND do
		local name, _, num = GetSendMailItem(i)
		if name then
			tinsert(attachments, {itemID=TSMAPI:GetItemID(GetSendMailItemLink(i)), quantity=num})
		end
	end
	
	return attachments
end

function Mail:Send()
	if not canSendMail then
		itemTimer = 0.2
		throttle:Show()
		return
	end

	Mail:RegisterEvent("MAIL_SEND_SUCCESS", "SentEventHandler")
	Mail:RegisterEvent("MAIL_FAILED", "SentEventHandler")
	currentAttachments = Mail:GetPendingAttachments()
	SendMail(TSM.db.factionrealm.currentCrafter, SendMailSubjectEditBox:GetText() or "Mass mailing", "")
	itemTimer = nil
	canSendMail = false
	mailTimer = 0.2
	throttle:Show()
end

function Mail:SentEventHandler(event)
	-- the items sent successfully so remove them from the list
	if event == "MAIL_SEND_SUCCESS" then
		TSM:Print(format(L["Mailed items off to %s!"], TSM.db.factionrealm.currentCrafter))
		for _, item in pairs(currentAttachments) do
			if itemsToMail[item.itemID] and item.quantity then
				itemsToMail[item.itemID] = itemsToMail[item.itemID] - item.quantity
				if itemsToMail[item.itemID] <= 0 then
					itemsToMail[item.itemID] = nil
					numItems = numItems - 1
				end
			end
		end
	end
	
	canSendMail = true
	Mail:AttachItems()
end

function Mail:StopMailing()
	local doneMailing = true
	for _ in pairs(itemsToMail) do
		doneMailing = false
	end
	
	itemsToMail = {}
	throttle:Hide()
	if doneMailing then
		Mail:UnregisterEvent("MAIL_CLOSED")
		Mail:UnregisterEvent("MAIL_SEND_SUCCESS", "SentEventHandler")
		Mail:UnregisterEvent("MAIL_FAILED", "SentEventHandler")
		TSM:NextTask()
	end
end