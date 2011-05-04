ArkInventoryRulesExample = LibStub( "AceAddon-3.0" ):NewAddon( "ArkInventoryRulesExample" )

function ArkInventoryRulesExample:OnEnable( )
	
	-- register your rule function: test( )
	-- and what function gets called to process the rule
	
	--ArkInventoryRules.Register( self, "test", ArkInventoryRulesExample.Execute )
	
end

function ArkInventoryRulesExample.Execute( ... )

	-- always check for the hyperlink and that it's an actual item, not a spell (pet/mount)
	if not ArkInventoryRules.Item.h or ArkInventoryRules.Item.class ~= "item" then
		return false
	end
	
	local fn = "test" -- your rule name, needs to be set so that error messages are readable
	
	local ac = select( '#', ... )
	
	-- if you need at least 1 argument, this is how you check, if you dont need and argument then you need to remove this part
	if ac == 0 then
		error( string.format( ArkInventory.Localise["RULE_FAILED_ARGUMENT_NONE_SPECIFIED"], fn ), 0 )
	end
	
	for ax = 1, ac do -- loop through the supplied ... arguments
		
		local arg = select( ax, ... ) -- select the argument were going to work with
		
		-- this code checks item quality, either as text or as a number
		-- your best bet is to check the existing system rules to find one thats close to what you need an modify it to suit your needs
		-- all you have to do is ensure that you return true (matched your criteria) or false (failed to match)
		
		if type( arg ) == "number" then
			
			if arg == ArkInventoryRules.Item.q then
				return true
			end
			
		elseif type( arg ) == "string" then
			
			if string.lower( strtrim( arg ) ) == string.lower( _G[string.format( "ITEM_QUALITY%d_DESC", ArkInventoryRules.Item.q )] ) then
				return true
			end
			
		else
			
			error( string.format( ArkInventory.Localise["RULE_FAILED_ARGUMENT_IS_INVALID"], fn, ax, string.format( "%s or %s", ArkInventory.Localise["STRING"], ArkInventory.Localise["NUMBER"] ) ), 0 )
			
		end
		
	end
	
	return false
	
end
