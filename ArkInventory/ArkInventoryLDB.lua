ArkInventory.LDB = {
	Bags = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Bags" ), {
		type = "data source",
		icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Bag].Texture,
		text = ArkInventory.Const.Slot.Data[ArkInventory.Const.Location.Bag].name,
	} ),
	Money = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Money" ), {
		type = "data source",
		icon = [[Interface\Icons\INV_Misc_Coin_02]],
		text = "Money",
	} ),
	Companion = { },
	Pets = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Pets" ), {
		type = "data source",
		icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Pet].Texture,
		text = "",
	} ),
	Mounts = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Mounts" ), {
		type = "data source",
		icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Texture,
		text = "",
	} ),
	Tracking_Currency = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s_%s", ArkInventory.Const.Program.Name, "Tracking", "Currency" ), {
		type = "data source",
		icon = nil,
		text = "Tracking - Currency",
	} ),
	Tracking_Item = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s_%s", ArkInventory.Const.Program.Name, "Tracking", "Item" ), {
		type = "data source",
		icon = nil,
		text = "Tracking - Items",
	} ),
}

local companionTable = { }



function ArkInventory.LDB.Bags:OnClick( button )
	if button == "RightButton" then
		ArkInventory.MenuLDBBagsOpen( self )
	else
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Bag )
	end
end

function ArkInventory.LDB.Bags:Update( )
	local loc_id = ArkInventory.Const.Location.Bag
	--ArkInventory.LDB.Bags.icon = ArkInventory.Global.Location[loc_id].Texture
	self.text = ArkInventory.Frame_Status_Update_Empty( loc_id, ArkInventory.Global.Me, true )
end



function ArkInventory.LDB.Money:Update( )
	self.text = ArkInventory.MoneyText( GetMoney( ) )
end

function ArkInventory.LDB.Money.OnTooltipShow( frame )
	ArkInventory.MoneyFrame_Tooltip( frame )
end



function ArkInventory.LDB.Tracking_Currency:Update( )
	
	self.text = ""
	local hasText = false
	
	local numTokenTypes = GetCurrencyListSize( )
	
	-- expand all token headers
	for j = numTokenTypes, 1, -1 do
		name, isHeader, isExpanded = GetCurrencyListInfo( j )
		if isHeader and not isExpanded then
			ExpandCurrencyList( j, 1 )
		end
	end
	
	numTokenTypes = GetCurrencyListSize( )
	
	for j = 1, numTokenTypes do
		
		local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo( j )
		
		if not isHeader then
			if ArkInventory.db.char.option.ldb.tracking.currency.tracked[name] then
				self.text = string.format( "%s  |T%s:0|t %d", self.text, icon or ArkInventory.Const.Texture.Missing, count or 0 )
				hasText = true
			end
		end
		
	end
	
	if hasText then
		self.text = string.trim( self.text )
	else
		self.text = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Token].Texture )
	end
	
end

function ArkInventory.LDB.Tracking_Currency.OnClick( frame, button )
	if button == "RightButton" then
		ArkInventory.MenuLDBTrackingCurrencyOpen( frame )
	else
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Token )
	end
end

function ArkInventory.LDB.Tracking_Currency:OnTooltipShow( )
	
	self:AddLine( string.format( "%s: %s", ArkInventory.Localise["LDB_TRACKING"], ArkInventory.Localise["LDB_TRACKING_CURRENCY"] ) )
	
	local numTokenTypes = GetCurrencyListSize( )
	
	-- expand all token headers
	for j = numTokenTypes, 1, -1 do
		name, isHeader, isExpanded = GetCurrencyListInfo( j )
		if isHeader and not isExpanded then
			ExpandCurrencyList( j, 1 )
		end
	end
	
	numTokenTypes = GetCurrencyListSize( )
	
	for j = 1, numTokenTypes do
		
		local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo( j )
		
		if isHeader then
			self:AddLine( " " )
			self:AddLine( name )
		else
			if ArkInventory.db.char.option.ldb.tracking.currency.tracked[name] then
				self:AddDoubleLine( name, count, 0, 1, 0, 0, 1, 0 )
			else
				self:AddDoubleLine( name, count, 1, 1, 1, 1, 1, 1 )
			end
		end
		
	end
	
	self:Show( )
	
end



function ArkInventory.LDB.Tracking_Item:Update( )
	
	self.text = ""
	local hasText = false
	
	for k in ArkInventory.spairs( ArkInventory.db.global.option.tracking.items )  do
		if ArkInventory.db.char.option.ldb.tracking.item.tracked[k] then
			local count = GetItemCount( k )
			if k == 6265 then
				-- soul shards for cataclysm
				count = UnitPower( "player", 7 ) or 0
			end
			local icon = select( 10, GetItemInfo( k ) )
			self.text = string.format( "%s  |T%s:0|t %s", self.text, icon or ArkInventory.Const.Texture.Missing, count or 0 )
			hasText = true
		end
	end
	
	if hasText then
		self.text = string.trim( self.text )
	else
		self.text = string.format( "|T%s:0|t", [[Interface\Icons\Ability_Tracking]] )
	end
	
end

function ArkInventory.LDB.Tracking_Item:OnClick( button )
	if button == "RightButton" then
		ArkInventory.MenuLDBTrackingItemOpen( self )
	end
end

function ArkInventory.LDB.Tracking_Item:OnTooltipShow( )
	
	self:AddLine( string.format( "%s: %s", ArkInventory.Localise["LDB_TRACKING"], ArkInventory.Localise["LDB_TRACKING_ITEM"] ) )
	
	self:AddLine( " " )
	
	for k in ArkInventory.spairs( ArkInventory.db.global.option.tracking.items )  do
		
		local count = GetItemCount( k )
		if k == 6265 then
			-- soul shards for cataclysm
			count = UnitPower( "player", 7 ) or 0
		end
		local name = GetItemInfo( k )
		
		local checked = ArkInventory.db.char.option.ldb.tracking.item.tracked[k]
		
		if checked then
			self:AddDoubleLine( name, count, 0, 1, 0, 0, 1, 0 )
		else
			self:AddDoubleLine( name, count, 1, 1, 1, 1, 1, 1 )
		end
		
	end
	
	self:Show( )
	
end



function ArkInventory.LDB.Pets:Update( )
	
	local companionType = "CRITTER"
	
	ArkInventory.LDB.Pets.Cleanup( )
	
	local total = ArkInventory.LDB.Companion.GetTotal( companionType )
	
	if total < 1 then
		self.icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Pet].Texture
		return
	end
	
	local selected = ArkInventory.db.char.option.ldb.pets.selected
	local count = ArkInventory.LDB.Companion.GetSelectedCount( selected )
	
	if count == 0 then
		--all companions
		self.icon = [[Interface\Icons\INV_Misc_Dice_01]]
		return
	end
	
	if count > 1 then
		-- partial selection
		self.icon = [[Interface\Icons\INV_Misc_Dice_02]]
		return
	end
	
	-- just one
	for k, v in pairs( selected ) do
		if v then
			self.icon = select( 3, GetSpellInfo( k ) )
			return
		end
	end
	
end

function ArkInventory.LDB.Pets:OnTooltipShow( )
	
	local companionType = "CRITTER"
	
	local total = ArkInventory.LDB.Companion.GetTotal( companionType )
	
	if total < 1 then
		self:AddLine( ArkInventory.Localise["LDB_COMPANION_NONE"] )
		return
	end
	
	local selected = ArkInventory.db.char.option.ldb.pets.selected
	local count = ArkInventory.LDB.Companion.GetSelectedCount( selected )
	
	if count == 0 then
		-- random all
		self:AddLine( ArkInventory.Localise["RANDOM"] )
		return
	end
	
	if count > 1 then
		-- random selection
		self:AddLine( string.format( "%s (%s/%s)", ArkInventory.Localise["RANDOM"], count, total ) )
		return
	end
	
	-- just the one
	for k, v in pairs( selected ) do
		if v then
			local name = GetSpellInfo( k )
			self:AddLine( name )
			return
		end
	end

end

function ArkInventory.LDB.Pets:OnClick( button )

	if button == "RightButton" then
		
		ArkInventory.MenuPetsOpen( self )
		
	else
		
		local companionType = "CRITTER"
		
		if GetNumCompanions( companionType ) == 0 then return end
		
		ArkInventory.LDB.Companion.GetUsable( companionType, true )
		
		if #companionTable == 0 then
			ArkInventory.Output( "no usable pets" )
		elseif #companionTable == 1 then
			CallCompanion( companionType, companionTable[1] )
		else
			ArkInventory.LDB.Companion.GetUsable( companionType )
			CallCompanion( companionType, companionTable[random( 1, #companionTable )] )
		end
		
	end
	
end

function ArkInventory.LDB.Pets.Cleanup( )
	
	local companionType = "CRITTER"
	
	local companionData = ArkInventory.Const.CompanionData
	
	-- remove any selected companions we no longer have
	local selected = ArkInventory.db.char.option.ldb.pets.selected
	for k, v in pairs( selected ) do
		if v ~= nil and not companionData[k] then
			selected[k] = nil
		end
	end
	
	-- if all companions are selected then deselect them all
	local selected = ArkInventory.db.char.option.ldb.pets.selected
	local n1 = ArkInventory.LDB.Companion.GetTotal( companionType )
	local n2 = ArkInventory.LDB.Companion.GetSelectedCount( selected )
	
	--ArkInventory.Output( "pet / ", n1, " / ", n2, " / ", selected )
	
	if n1 == n2 then
		for k, v in pairs( selected ) do
			if v == true then
				selected[k] = nil
			end
		end
	end
	
end


function ArkInventory.LDB.Mounts:Update( useMapZone )
	
	local companionType = "MOUNT"
	
	ArkInventory.LDB.Mounts.Cleanup( )
	ArkInventory.LDB.Mounts.IsFlyable( useMapZone )
	
	local mountType = ArkInventory.LDB.Companion.GetUsable( companionType, true )
	
	if not mountType then
		-- no usable mounts
		self.icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Texture
		return
	end
	
	local total = ArkInventory.LDB.Companion.GetTotal( companionType, mountType )
	
	--ArkInventory.Output( mountType, " / ", #companionTable, " / ", total )
	
	if total < 1 then
		self.icon = ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Texture
		return
	end
	
	local selected = ArkInventory.db.char.option.ldb.mounts[mountType].selected
	local count = ArkInventory.LDB.Companion.GetSelectedCount( selected )
	
	if count == 0 then
		--all companions
		self.icon = [[Interface\Icons\INV_Misc_Dice_01]]
		return
	end
	
	if count > 1 then
		-- partial selection
		self.icon = [[Interface\Icons\INV_Misc_Dice_02]]
		return
	end
	
	-- just one
	for k, v in pairs( selected ) do
		if v then
			self.icon = select( 3, GetSpellInfo( k ) )
			return
		end
	end
	
end

function ArkInventory.LDB.Mounts:OnTooltipShow( ... )
	
	local companionType = "MOUNT"
	
	self:AddDoubleLine( ArkInventory.Localise["LDB_MOUNTS_TOOLTIP_MODE"], ArkInventory.Localise["LDB_MOUNTS_TOOLTIP_SELECTION"] )
	
	for _, mountType in ipairs( { "ground", "flying", "water" } ) do
		
		local mode = ArkInventory.Localise[string.upper( string.format( "LDB_MOUNTS_%s", mountType ) )]
		local total = ArkInventory.LDB.Companion.GetTotal( companionType, mountType )
		
		if total < 1 then
			
			self:AddDoubleLine( mode, ArkInventory.Localise["LDB_COMPANION_NONE"], 1, 1, 1, 1, 0, 0 )
			
		else
	
			local selected = ArkInventory.db.char.option.ldb.mounts[mountType].selected
			local count = ArkInventory.LDB.Companion.GetSelectedCount( selected )
			
			if count == 0 then
				
				-- random all
				self:AddDoubleLine( mode, ArkInventory.Localise["RANDOM"], 1, 1, 1, 1, 1, 1 )
			
			else
				
				if count > 1 then
					
					-- random selection
					self:AddDoubleLine( mode, string.format( "%s (%s/%s)", ArkInventory.Localise["RANDOM"], count, total ), 1, 1, 1, 1, 1, 1 )
					
				else
					
					-- just the one
					for k, v in pairs( selected ) do
						if v then
							local name = GetSpellInfo( k )
							self:AddDoubleLine( mode, name, 1, 1, 1, 1, 1, 1 )
						end
					end
					
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.LDB.Mounts:OnClick( button )
	
	if button == "RightButton" then
		
		ArkInventory.MenuMountsOpen( self )
		
	else
		
		local companionType = "MOUNT"
		
		if GetNumCompanions( companionType ) == 0 then return end
		
		if IsMounted( ) then
			
			if IsFlying( ) then
				if not ArkInventory.db.char.option.ldb.mounts.flying.dismount then
					ArkInventory.OutputWarning( ArkInventory.Localise["LDB_MOUNTS_FLYING_DISMOUNT_WARNING"] )
				else
					Dismount( )
				end
			else
				Dismount( )
			end
			
			return
			
		end
		
		ArkInventory.LDB.Mounts:Update( )
		
		ArkInventory.LDB.Companion.GetUsable( companionType, true )
		
		--ArkInventory.Output( #companionTable, " available mounts" )
		
		if #companionTable == 0 then
			-- no mounts
			return
		end
		
		-- remove auras
		for i = 40, 1, -1 do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura( "player", i, "CANCELABLE" )
			if spellId and ArkInventory.db.char.option.ldb.mounts.aura[spellId] then
				CancelUnitBuff( "player", name, nil )
			end
		end
		
		if #companionTable == 1 then
			CallCompanion( companionType, companionTable[1] )
		else
			ArkInventory.LDB.Companion.GetUsable( companionType )
			CallCompanion( companionType, companionTable[random( 1, #companionTable )] )
		end
		
	end
	
end

function ArkInventory.LDB.Mounts.Cleanup( )
	
	local companionType = "MOUNT"
	
	local companionData = ArkInventory.Const.CompanionData
	
	-- remove any selected companions we no longer have
	for _, mountType in pairs( { "flying", "ground", "water" } ) do
		local selected = ArkInventory.db.char.option.ldb.mounts[mountType].selected
		for k, v in pairs( selected ) do
			if v ~= nil and not companionData[k] then
				selected[k] = nil
			end
		end
	end
	
	-- if all companions are selected then deselect them all
	for _, mountType in pairs( { "flying", "ground", "water" } ) do
		
		local selected = ArkInventory.db.char.option.ldb.mounts[mountType].selected
		local n1 = ArkInventory.LDB.Companion.GetTotal( companionType, mountType )
		local n2 = ArkInventory.LDB.Companion.GetSelectedCount( selected )
		
		--ArkInventory.Output( mountType, " / ", n1, " / ", n2, " / ", selected )
		
		if n1 == n2 then
			for k, v in pairs( selected ) do
				if v == true then
					selected[k] = nil
				end
			end
		end
		
	end
	
end


function ArkInventory.LDB.Mounts.IsFlyable( useMapZone )
	
	-- doing it the long way because relying on blizzard to get it right is not an option
	
	ArkInventory.IsFlyable = IsFlyableArea( )  -- its usually wrong, but it's the only choice we have so we start here
	
	local skill = 0
	
	if ArkInventory.IsFlyable then
		
		-- player level
		
		if UnitLevel( "player" ) < 20 then
			
			ArkInventory.IsFlyable = false
			--ArkInventory.Output( "player level is too low for flying" )
			
		else
		
			-- riding skill, you only have one of them
			
			if GetSpellInfo( ( GetSpellInfo( 33388 ) ) ) then -- apprentice
				skill = 75
				--ArkInventory.Output( "riding skill = ", skill, "/apprentice" )
			elseif GetSpellInfo( ( GetSpellInfo( 33391 ) ) ) then -- journeyman
				skill = 150
				--ArkInventory.Output( "riding skill = ", skill, "/journeyman" )
			elseif GetSpellInfo( ( GetSpellInfo( 34090 ) ) ) then -- expert
				skill = 225
				--ArkInventory.Output( "riding skill = ", skill, "/expert" )
			elseif GetSpellInfo( ( GetSpellInfo( 34091 ) ) ) then -- artisan
				skill = 300
				--ArkInventory.Output( "riding skill = ", skill, "/artisan" )
			elseif GetSpellInfo( ( GetSpellInfo( 90265 ) ) ) then -- master
				skill = 300
				--ArkInventory.Output( "riding skill = ", skill, "/master" )
			end
			
			if skill < 225 then
				
				ArkInventory.IsFlyable = false
				--ArkInventory.Output( "riding skill ", skill, " is too low for flying" )
				
			else
				
				if ( useMapZone ) or ( not WorldMapFrame:IsVisible( ) ) then
					
					-- only set the map zone if the world map is not open or we need to force it
					
					SetMapToCurrentZone( ) -- wont work after a uireload, requires a zone change to kick in
					local zone = GetCurrentMapContinent( )
					
					-- -1 = instance
					--  0 = cosmic
					--  3 = outland
					--  5 = maelstrom (deepholm)
					
					if zone == 1 or zone == 2 then
						
						-- azeroth, need flight masters licence
						
						if not GetSpellInfo( ( GetSpellInfo( 90267 ) ) ) then
							--ArkInventory.Output( "azeroth but you dont know flight masters licence" )
							ArkInventory.IsFlyable = false
						end
						
					elseif zone == 4 then
						
						-- northrend, needs cold weather flying
						
						if not GetSpellInfo( ( GetSpellInfo( 54197 ) ) ) then
							
							--ArkInventory.Output( "northrend but you dont know cold weather flying" )
							ArkInventory.IsFlyable = false
							
						end
						
					end
					
				end
				
			end
			
		end
	
	end
	
	if ArkInventory.IsFlyable then
		
		-- world pvp battle in progress?
		
		for index = 1, GetNumWorldPVPAreas( ) do
			
			local pvpID, pvpZone, isActive = GetWorldPVPAreaInfo( index )
			--ArkInventory.Output( pvpID, " / ", pvpZone, " / ", isActive )
			
			if ArkInventory.IsFlyable and isActive and GetRealZoneText( ) == pvpZone then
				-- ArkInventory.Output( "battle in progress, no flying allowed" )
				ArkInventory.IsFlyable = false
				break
			end
		end
		
	end
	
end

function ArkInventory.LDB.Companion.GetAvailable( companionType, ignoreActive, mountType )
	
	-- gather all usable companions
	
	table.wipe( companionTable )
	
	local n = GetNumCompanions( companionType )
	if n == 0 then return end
	
	local selected
	
	if mountType then
		selected = ArkInventory.db.char.option.ldb.mounts[mountType].selected
	else
		selected = ArkInventory.db.char.option.ldb.pets.selected
	end
	
	local selectedCount = ArkInventory.LDB.Companion.GetSelectedCount( selected )
	
	--ArkInventory.Output( "selected[", selectedCount, "] = ", selected )
	
	local count = 0
	
	for creatureIndex = 1, n do
		
		local companionID, companionName, companionSpellID, texture, active = GetCompanionInfo( companionType, creatureIndex )
		
		if ( not active or ignoreActive ) and ( ( selectedCount == 0 and selected[companionSpellID] ~= false ) or ( selectedCount > 0 and selected[companionSpellID] == true ) ) then
			
			--ArkInventory.Output( creatureIndex, " / ", companionName )
			
			local companionData = ArkInventory.Const.CompanionData[companionSpellID]
			local ok = IsUsableSpell( companionSpellID )
			
			if ok and mountType then
				ok = companionData.usable[mountType] 
			end
			
			if ok then
				count = count + 1
				companionTable[count] = creatureIndex
			end
			
		end
		
	end
	
end

function ArkInventory.LDB.Companion.GetSelectedCount( selected )
	local count = 0				
	for k, v in pairs( selected ) do
		if v then count = count + 1 end
	end
	return count
end

function ArkInventory.LDB.Companion.GetUsable( companionType, ignoreActive )
	
	table.wipe( companionTable )
	
	if companionType == "CRITTER" then
		return ArkInventory.LDB.Companion.GetAvailable( companionType, ignoreActive )
	end
	
	local forceAlternative = IsModifiedClick( )
	
	if IsSwimming( ) then
		if ( not forceAlternative ) then
			--ArkInventory.Output( "check water" )
			ArkInventory.LDB.Companion.GetAvailable( companionType, ignoreActive, "water" )
			if #companionTable > 0 then return "water" end
		else
			--ArkInventory.Output( "ignore water" )
		end
	end
	
	if ArkInventory.IsFlyable then
		--ArkInventory.Output( "can fly here" )
		if ( not forceAlternative ) or ( forceAlternative and IsSwimming( ) ) then
			--ArkInventory.Output( "checking flying" )
			ArkInventory.LDB.Companion.GetAvailable( companionType, ignoreActive, "flying" )
			if #companionTable > 0 then return "flying" end
		else
			--ArkInventory.Output( "ignore flying" )
		end
	end
	
	--ArkInventory.Output( "ground" )
	ArkInventory.LDB.Companion.GetAvailable( companionType, ignoreActive, "ground" )
	if #companionTable > 0 then return "ground" end
	
end

function ArkInventory.LDB.Companion.GetTotal( companionType, mountType )
	
	local n = GetNumCompanions( companionType )
	
	if companionType == "CRITTER" then
		return n
	end
	
	local count = 0
	
	for companionIndex = 1, n do
		
		local companionID, companionName, companionSpellID, texture, active = GetCompanionInfo( companionType, companionIndex )
		local companionData = ArkInventory.Const.CompanionData[companionSpellID]
		
		if companionData and companionData.usable[mountType] then
			count = count + 1
		end
		
	end
	
	return count
	
end
