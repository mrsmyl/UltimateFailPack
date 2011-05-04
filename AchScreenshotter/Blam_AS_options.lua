----------------------------------------------------------
-- Option Panel Code
-----------------------------------------------------------
function AS_config_options( panel )
	if( AS_DEBUG ) then
		print( "AS_config_options(panel)..." );
	end
	
	panel.name = "Ach Screenshotter";
	panel.okay = function (self) AS_Close_Options(); end;
	panel.default = function (self) AS_Default_Options(); end;
	InterfaceOptions_AddCategory(panel);
end

function AS_Open_Options()
	if( AS_DEBUG ) then
		print( "AS_Open_Options()..." );
	end

	AS_fs_title:SetText( AS_MOD_NAME .. " v." .. AS_MOD_VERSION );
	
	AS_check_hideUI:SetChecked(AS_settings.AS_hideui);
	AS_check_Achs:SetChecked(AS_settings.AS_ss_achs);
	AS_check_Levels:SetChecked(AS_settings.AS_ss_levels);
	AS_check_Reps:SetChecked(AS_settings.AS_ss_reps);
	AS_check_exalted_only:SetChecked(AS_settings.AS_ss_exalted_only);
	AS_check_bgs:SetChecked(AS_settings.AS_ss_bgs);
	AS_check_bgs_wins_only:SetChecked(AS_settings.AS_ss_bgs_wins_only);
	--AS_check_arenas:SetChecked(AS_settings.AS_ss_arenas);
	--AS_check_arenas_wins_only:SetChecked(AS_settings.AS_ss_arenas_wins_only);
	--AS_check_boss_kills:SetChecked(AS_settings.AS_ss_boss_kills);
end

function AS_Default_Options()
	if( AS_DEBUG ) then
		print( "AS_Defualt_Options()..." );
	end
	
	for k, v in pairs(AS_DEFAULT_SETTINGS) do
		AS_settings[k] = v;
	end
end

function AS_Close_Options()
	if( AS_DEBUG ) then
		print( "AS_Close_Options()... " );
	end
	
	AS_settings.AS_hideui = AS_check_hideUI:GetChecked();
	AS_settings.AS_ss_achs = AS_check_Achs:GetChecked();
	AS_settings.AS_ss_levels = AS_check_Levels:GetChecked();
	AS_settings.AS_ss_reps = AS_check_Reps:GetChecked();
	AS_settings.AS_ss_exalted_only = AS_check_exalted_only:GetChecked();
	AS_settings.AS_ss_bgs = AS_check_bgs:GetChecked();
	AS_settings.AS_ss_bgs_wins_only = AS_check_bgs_wins_only:GetChecked();
	--AS_settings.AS_ss_arenas = AS_check_arenas:GetChecked();
	--AS_settings.AS_ss_arenas_wins_only = AS_check_arenas_wins_only:GetChecked();
	--AS_settings.AS_ss_boss_kills = AS_check_boss_kills:GetChecked();
	
	if( AS_settngs.AS_hideui ) then
		print( "Achievement Screenshotter: press Esc to show the UI after the screenshot is taken." );
	end
end

function AS_auto_check_reps()
	if( AS_DEBUG ) then
		print( "AS_auto_check_reps()" );
	end
	
	if( AS_check_exalted_only:GetChecked() and not AS_check_Reps:GetChecked() ) then
		AS_check_Reps:SetChecked(true);
	end
end

-- function AS_auto_check_arenas()
	-- if( AS_check_arenas_wins_only:GetChecked() and not AS_check_arenas:GetChecked() ) then
		-- AS_check_arenas:SetChecked(true);
	-- end
-- end

function AS_auto_check_bgs()
	if( AS_check_bgs_wins_only:GetChecked() and not AS_check_bgs:GetChecked() ) then
		AS_check_bgs:SetChecked(true);
	end
end

function AS_auto_uncheck_exalted_only()
	if( AS_DEBUG ) then
		print( "AS_auto_uncheck_exalted_only()" );
	end
	
	if( AS_check_exalted_only:GetChecked() and not AS_check_Reps:GetChecked() ) then
		AS_check_exalted_only:SetChecked(false);
	end
end

-- function AS_auto_uncheck_arena_wins_only()
	-- if( AS_check_arenas_wins_only:GetChecked() and not AS_check_arenas:GetChecked() ) then
		-- AS_check_arenas_wins_only:SetChecked(false);
	-- end
-- end

function AS_auto_uncheck_bg_wins_only()
	if( AS_check_bgs_wins_only:GetChecked() and not AS_check_bgs:GetChecked() ) then
		AS_check_bgs_wins_only:SetChecked(false);
	end
end