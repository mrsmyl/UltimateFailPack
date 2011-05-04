-----------------------------------------------------------
-- DO NOT MODIFY!!!
-- NOT MY CODE. Got it here: http://www.wowwiki.com/Wait on July 5th, 2009
-----------------------------------------------------------
local waitTable = {};
local waitFrame = nil;

function AchScreens__wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end
-------------------------------------------------------------
-- END OF DO NOT MODIFY!!
-------------------------------------------------------------

local AS_player_faction_id;
AS_settings = {};

function AchScreens_OnLoad(panel)
	if( AS_DEBUG ) then
		print( "AchScreens_OnLoad(panel)... ");
	end
	
	panel:RegisterEvent( "ADDON_LOADED");		-- for retrieving the saved variables
	panel:RegisterEvent( "PLAYER_LOGOUT" );		-- for updating the mod version in the saved variables table
	panel:RegisterEvent( "SCREENSHOT_SUCCEEDED" ); -- for re-showing the UI after hiding it
	panel:RegisterEvent( "ACHIEVEMENT_EARNED" ); -- for achievement screenshots
	panel:RegisterEvent( "PLAYER_LEVEL_UP" );    -- for leveling up screenshots
	panel:RegisterEvent( "CHAT_MSG_SYSTEM" );    -- for reputation milestone screenshots
	panel:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" ); -- for end of bgs and arenas
	-- panel:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" ); -- for boss kills
	
	AS_config_options( panel );
end

function AchScreens_OnEvent( self, event, ... )
	-- if( AS_DEBUG ) then
		-- print( "AchScreens_OnEvent() ... event = ", event );
	-- end

	if( event == "ADDON_LOADED" ) then
		AS_addon_loaded( select(1,...) );
	elseif( event == "PLAYER_LOGOUT" ) then
		AS_player_logout();
	elseif( event == "SCREENSHOT_SUCCEEDED" ) then
		AS_screenshot_succeeded();
	elseif( event == "ACHIEVEMENT_EARNED" and AS_settings.AS_ss_achs ) then
		AS_achievement_earned();
    elseif( event == "PLAYER_LEVEL_UP" and AS_settings.AS_ss_levels ) then
		AS_player_level_up();
	elseif( event == "CHAT_MSG_SYSTEM" and AS_settings.AS_ss_reps ) then
		AS_chat_msg_system( select(1,...) );
	elseif( event == "UPDATE_BATTLEFIELD_STATUS" and (AS_settings.AS_ss_bgs or AS_settings.AS_ss_arenas) ) then
		AS_update_battlefield_status();
	-- elseif( event == "COMBAT_LOG_EVENT_UNFILTERED" and UnitInRaid("player") ) then
		-- if( select(2,...) == "UNIT_DIED") then
			-- AS_combat_log_event( select(6,...) );
		-- end
	end
end

function AS_addon_loaded( modName )
	if( AS_DEBUG ) then
		print( "AS_addon_loaded(modName), modName =", modName );
	end
	if( modName == AS_MOD_NAME_NO_SPACES ) then
		print( AS_MOD_NAME .. " v." .. AS_MOD_VERSION .. " has loaded." );
		
		--print("AS_settings.AS_saved_mod_version == ", AS_settings.AS_saved_mod_version);
		if( AS_settings.AS_saved_mod_version == nil ) then
			AS_Default_Options();
		end
		
		if( UnitFactionGroup("player") == "Horde" ) then
			AS_player_faction_id = AS_HORDE_ID;
		else
			AS_player_faction_id = AS_ALLIANCE_ID;
		end
	end
end

function AS_player_logout()
	if( AS_DEBUG ) then
		print( "AS_player_logout()" );
	end
	AS_settings.AS_saved_mod_version = AS_MOD_VERSION;
end

function AS_screenshot_succeeded()
	if( AS_DEBUG ) then
		print( "AS_screenshot_succeeded()" );
	end
	
	AS_myShow();
end

function AS_achievement_earned()
	if( AS_DEBUG ) then
		print( "AS_achievement_earned()" );
	end
	AS_take_screenshot(1);
end

function AS_player_level_up()
	if( AS_DEBUG ) then
		print( "AS_player_level_up()" );
	end
	AS_take_screenshot(1);
end

function AS_chat_msg_system( msg )
	if( AS_DEBUG ) then
		print( "AS_chat_msg_system(msg)" );
	end
	
	if( string.find( msg, "You are now") and string.find( msg, "with") ) then
		if( not AS_exalted_only ) then
			AS_take_screenshot(1);
		elseif( string.find( msg, "Exalted" ) ) then
			AS_take_screenshot(1);
		end
	end
end

function AS_update_battlefield_status()
	local winner = GetBattlefieldWinner();
	if( AS_DEBUG and winner ~= nil) then
		print( "AS_update_battlefield_status()" );
		print( " winner = ", winner );
		print( " AS_ss_bgs_wins_only = ", AS_settings.AS_ss_bgs_wins_only );
	end
	
	if( winner ~= nil ) then
		if( IsActiveBattlefieldArena() ) then
			if( AS_DEBUG ) then
				print( "Player finished Arena" );
			end
			if( AS_settings.AS_ss_arenas and (not AS_settings.AS_ss_arenas_wins_only) ) then
				AS_take_screenshot(1);
			elseif( AS_settings.AS_ss_arenas_wins_only and winner == get_players_team_index() ) then
				AS_take_screenshot(1);
			end
		else	-- they are either looking at the score of a battleground or just teleported out of a battleground
			if( is_player_still_in_bg() ) then
				if( AS_DEBUG ) then
					print( "Player at score screen of battleground." );
					print( "AS_settings.AS_ss_bgs = ", AS_settings.AS_ss_bgs );
					print( "AS_settings.AS_ss_bgs_wins_only", AS_settings.AS_ss_bgs_wins_only );
					
				end
				
				if( not AS_settings.AS_ss_bgs_wins_only ) then
					AS_take_screenshot(1);
				elseif( winner == AS_player_faction_id ) then
					AS_take_screenshot(1);
				end
			end
		end
	end
end

-- function get_players_team_index()
	-- local greenTeamName = GetBattlefieldTeamInfo(0);
	-- for i = 0, AS_MAX_NUM_ARENA_TEAMS do
		-- if( greenTeamName == GetArenaTeam(i) ) then
			-- return 0;
		-- end
	-- end
	-- return 1;
-- end

function is_player_still_in_bg()
	if( AS_DEBUG ) then
		print( "is_player_still_in_bg()" );
	end
	
	for i = 1, #AS_BG_TABLE do
		if( GetRealZoneText() == AS_BG_TABLE[i] ) then
			if( AS_DEBUG ) then
				print( "... returning true. Player IS in bg." );
			end
			return true;
		end
	end
	
	return false;
end

-- function AS_combat_log_event( destGUID )
	-- if( AS_DEBUG ) then
		-- print( "AS_combat_log_event()" );
	-- end
	-- 
		-- if( AS_DEBUG ) then
			-- print( "UNIT_DIED: ", UnitName(destGUID) );
			-- print( "GUID == ", destGUID );
			-- print( "UnitLevel() == ", UnitLevel(destGUID) ); -- returns 0 
			-- print( "UnitClassification() == ", UnitClassification(destGUID) );
			-- print( "UnitCreatureType() == " , UnitCreatureType(destGUID) );-- returns nil
				-- if( UnitLevel(destGUID) == -1 ) then
					-- print( "UnitLevel() == -1" );
				-- end
		-- end
		-- 
		-- if( UnitClassification(destGUID) == "worldboss" or UnitClassification(destGUID) == "rareelite" ) then
			-- AS_take_screenshot(0);
		-- end
	-- 
-- end

function AS_take_screenshot(delay)
	if( AS_DEBUG ) then
		print( "AS_take_screenshot(delay)" );
	end
	
	if( AS_settings.AS_hideui ) then
		AchScreens__wait( delay, AS_myHide );
		AchScreens__wait( delay, Screenshot );
		--UIParent:Show(); -- Doesn't work. I suspect it is related to the delay
		-- funciton I'm using. Until I find a work around, the user will have to
		-- press Esc after the screenshot is taken.
	else
		AchScreens__wait( delay, Screenshot );
	end
end

function AS_myShow()
	UIParent:Show();
end

function AS_myHide()
	UIParent:Hide();
end

-----------------------------------------------------------
-- Slash Command Code
-----------------------------------------------------------
SLASH_SCREENSHOTTER1, SLASH_SCREENSHOTTER2 = '/as', '/screenshotter';
SlashCmdList["SCREENSHOTTER"] = handler;
function SlashCmdList.SCREENSHOTTER( msg, editbox )
	if( AS_DEBUG ) then
		print( "AS_slash_handler()..." );
	end

	InterfaceOptionsFrame_OpenToCategory(AS_Options_Panel);
end
-----------------------------------------------------------