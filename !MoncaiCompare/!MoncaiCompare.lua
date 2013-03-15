-- local addonName, addonTable = ...; 

local ItemRefTooltip = ItemRefTooltip

ItemRefTooltip.UpdateTooltip = function(self)
	if ( not self.comparing) then
		GameTooltip_ShowCompareItem(self);
		self.comparing = true;
--~ 	elseif ( self.comparing and false) then
--~ 		for _, frame in pairs(self.shoppingTooltips) do
--~ 			frame:Hide();
--~ 		end
--~ 		self.comparing = false;
	end
end

ItemRefTooltip:SetScript("OnTooltipSetItem", function(self)


	if (self:IsMouseOver()) then
		GameTooltip_ShowCompareItem(self, 1);
		self.comparing = true;
	end
end 
)

ItemRefTooltip:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing();
	ValidateFramePosition(self);
--~ 	if ( true ) then --We do this to choose where the comparison is shown
		GameTooltip_ShowCompareItem(self, 1);
		self.comparing = true;
--~ 	end
end
)

GameTooltip:SetScript("OnTooltipSetItem", function(self)
	if ( not IsModifiedClick("COMPAREITEMS") and not self:IsEquippedItem() ) then
		GameTooltip_ShowCompareItem(self, 1);
	end
	if (BattlePetTooltip) then
		BattlePetTooltip:Hide();
	end
end
)

local fEncounterJournal_Loot_OnUpdate;
local function JournalHook()
	
	fEncounterJournal_Loot_OnUpdate = EncounterJournal_Loot_OnUpdate;
	EncounterJournal_Loot_OnUpdate = function(self)
		if GameTooltip:IsOwned(self) then
			if (not IsModifiedClick("COMPAREITEMS")) and not IsEquippedItem(self.itemID) then
				GameTooltip_ShowCompareItem();
			else
				ShoppingTooltip1:Hide();
				ShoppingTooltip2:Hide();
				ShoppingTooltip3:Hide();
			end

			if IsModifiedClick("DRESSUP") then
				ShowInspectCursor();
			else
				ResetCursor();
			end
		end	
	end;
end
hooksecurefunc("EncounterJournal_LoadUI", JournalHook)
