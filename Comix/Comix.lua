function Comix_OnLoad()

-- Registering Events --

Comix_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

Comix_Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Comix_Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Comix_Frame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
Comix_Frame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
Comix_Frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
Comix_Frame:RegisterEvent("CHAT_MSG_EMOTE")
Comix_Frame:RegisterEvent("CHAT_MSG_YELL")
Comix_Frame:RegisterEvent("UNIT_HEALTH")
Comix_Frame:RegisterEvent("UNIT_SPELLCAST_SENT")
Comix_Frame:RegisterEvent("RESURRECT_REQUEST")
Comix_Frame:RegisterEvent("PLAYER_ALIVE")
Comix_Frame:RegisterEvent("PLAYER_UNGHOST")
Comix_Frame:RegisterEvent("PLAYER_DEAD")
Comix_Frame:RegisterEvent("READY_CHECK")
Comix_Frame:RegisterEvent("PLAYER_LOGIN")
Comix_Frame:RegisterEvent("OnUpdate")


-- Saying Hello --
  DEFAULT_CHAT_FRAME:AddMessage("Hello you there, this AddOn is enabled by default!",0,0,1);
  
-- Slash Commands --
  SlashCmdList["Comix"] = Comix_Command;
	SLASH_Comix1 = "/Comix";
	SLASH_Comix2 = "/comix";
	
  SlashCmdList["ComixJoke"] = Comix_BadJoke;
	SLASH_ComixJoke1 = "/badjoke";

  SlashCmdList["ComixFail"] = Comix_Fail;
	SLASH_ComixFail1 = "/fail";
	
  SlashCmdList["ComixAwesome"] = Comix_Awesome;
	SLASH_ComixAwesome1 = "/awesome";
	
  SlashCmdList["ComixDrama"] = Comix_Drama;
	SLASH_ComixDrama1 = "/drama";
	
	dontfireonalive = false;
	loaded = false;
	unghosted = false;
	dead = false;
	
-- Setting variables --
	Comix_ShakeEnabled = true;
	Comix_ShakeDuration = 1;
	Comix_ShakeIntensity = 70;
	Comix_ShakeOffset = 1;
  Comix_x_coord = 0;
  Comix_y_coord = 0;
  Comix_Max_Scale = 2;
  ComixCurrentFrameCt = 1;
  ComixCritCount = 0;
  ComixBuffCount = 0;
  ComixAniSpeed = 1;
  ComixMaxCrits = 3;
  ComixKillCount = 0;
  Comix_CritPercent = 100;
  Comix_CritGap = 0;
  Comix_FinishHimGap = 20;
  Comix_Overkill = 75;
  Comix_CurrentImage = nil;

  Comix_Frames = {};
  Comix_FramesScale = {}
  Comix_FramesVisibleTime = {}
  Comix_FramesStatus = {}
  Comix_textures = {};
  Comix_CritSoundsEnabled = true;
  Comix_CritHealsEnabled = true;
  Comix_SpecialsEnabled = true;
  Comix_KillCountEnabled = true;
  Comix_DeathSoundEnabled = true;
  ComixKillCountSoundPlayed = false;
  Comix_HuggedNotFound = false;
  Comix_AddOnEnabled = true;
  Comix_SoundEnabled = true;
  Comix_BS_Update = false;
  Comix_BSEnabled = true;
  Comix_DemoShoutEnabled = true;
  Comix_ZoneEnabled = true;
  Comix_FinishTarget = true;
  Comix_BamEnabled = false;
  Comix_ImagesEnabled = true;
  Comix_FinishhimEnabled = true;

  Comix_CritGapEnabled = false;
  Comix_OverkillEnabled = true;
  Comix_OneHit = false;
 
  Comix_PublicObjections = true;
  Comix_ObjectionSoundsEnabled = true;
  Comix_ObjectionImagesEnabled = true;
  
  Comix_BsShortDuration = true;
  Comix_HealorDmg = true;
  Comix_PlayerClass = UnitClass("player")
  
  Comix_CritFlashEnabled = true;
  Comix_HealFlashEnabled = true;
  Comix_BSSounds = true;
  Comix_DSSounds = true;
  Comix_BounceSoundEnabled = true;
  Comix_JumpCount = 0;
  Comix_ResSoundEnabled = true;
  Comix_ReadySoundEnabled = true;
  
  Comix_AbilitySoundsEnabled = true;
   
  forward = false;
  back = false;
  left = false;
  right = false;
  
  -- Hug Counter Variables --
  Comix_Hugs = {}
  Comix_Hugged = {}
  Comix_HugName = {}
  Comix_HugName[1] = UnitName("player")
  Comix_Hugs[1] = 0
  Comix_Hugged[1] = 0
  
-- Calling functions to Create Frames and Load The Images/Sounds -- 
  Comix_CreateFrames(); 
  Comix_LoaddaShite();
  TimeSinceLastUpdate = 0;
  Comix_DongSound(ComixSpecialSounds, 6);
  
  DefaultWorldFramePoints = {}; -- for making sure the screen shakes are putting the world frame back in the right place
  
end

function startReadyCheck()
	if Comix_AddOnEnabled then
		if Comix_ReadySoundEnabled then
			Comix_DongSound(ComixReadySounds, math.random(1, ComixReadySoundsCt));
		end
	end
end

hooksecurefunc("DoReadyCheck", startReadyCheck)

function PlayBounceSound()
if Comix_AddOnEnabled then
	local boing = false;

	if forward or back or left or right then
		boing = true;
	end

	if IsMounted() then
		if not IsFlying() then
			if boing then
				Comix_JumpCount = Comix_JumpCount + 1;
			end
			if Comix_BounceSoundEnabled and boing then
				Comix_DongSound(ComixSpecialSounds, 8);
			end
		end
	else
			Comix_JumpCount = Comix_JumpCount + 1;
			if Comix_BounceSoundEnabled then
				Comix_DongSound(ComixSpecialSounds, 8);
			end
	end
end

end

hooksecurefunc("JumpOrAscendStart", PlayBounceSound)

function forwardstart()
	forward = true;
end

hooksecurefunc("MoveForwardStart", forwardstart)

function forwardstop()
	forward = false;
end

hooksecurefunc("MoveForwardStop", forwardstop)

function backstart()
	back = true;
end

hooksecurefunc("MoveBackwardStart", backstart)

function backstop()
	back = false;
end

hooksecurefunc("MoveBackwardStop", backstop)

function leftstart()
	left = true;
end

hooksecurefunc("StrafeLeftStart", leftstart)

function leftstop()
	left = false;
end

hooksecurefunc("StrafeLeftStop", leftstop)

function rightstart()
	right = true;
end

hooksecurefunc("StrafeRightStart", rightstart)

function rightstop()
	right = false;
end

hooksecurefunc("StrafeRightStop", rightstop)


function Comix_OnEvent(self, event, ...)
--DEFAULT_CHAT_FRAME:AddMessage("ON EVENT LOLZ",0,0,1);
--local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18 = select(1, ...)
local arg1, arg2 = select(1, ...) -- for non combat related events
local subEvent = select(2, ...)
local sourceName = select(5, ...)
local sourceFlags = select(6, ...)
local destName = select(9, ...)
local spellName = select(13, ...)
local spellSchool = select(14, ...)
local damageAmount = select(15, ...) -- melee damage different arg, modified in code later
local overkillAmount = select(16, ...)
local critical = select(18, ...) -- melee and spell heal crit, spell damage is 21, changed later


if (Comix_AddOnEnabled) then

if event == "PLAYER_LOGIN" then
		--this gets the position of the world frame at player login or during an interface reload so that it knows where it should be
				for i = 1, WorldFrame:GetNumPoints() do
					local point, frame, relPoint, xOffset, yOffset = WorldFrame:GetPoint(i);
					--DEFAULT_CHAT_FRAME:AddMessage("p- "..point..",r- "..relPoint..",xO- "..xOffset..",yO- "..yOffset)
					DefaultWorldFramePoints[i] = {
						["point"] = point,
						["frame"] = frame,
						["relPoint"] = relPoint,
						["xOffset"] = xOffset,
						["yOffset"] = yOffset,
					}
				end
end


if event == "COMBAT_LOG_EVENT_UNFILTERED" then
--DEFAULT_CHAT_FRAME:AddMessage("COMBAT_LOG_EVENT_UNFILTERED fired "..select(2, ...));
--	DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..select(2, ...));
	
		if subEvent == "SPELL_AURA_APPLIED" then
			if sourceName == UnitName("player") then
				--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg10);
				if spellName == COMIX_BS then
					if Comix_BSEnabled then 
			        Comix_Pic(0, 0,ComixSpecialImages[1])
					
					if Comix_BSSounds then
						Comix_DongSound(ComixSpecialSounds,1)
					end
					end
				elseif spellName == COMIX_DS or spellName == COMIX_DR then
					if Comix_DemoShoutEnabled then
					Comix_Pic(0, 0,ComixSpecialImages[2])
			
					if Comix_DSSounds then
						Comix_DongSound(ComixSpecialSounds,math.random(2,3))
					end
					end
				end
			end
		end
	

	if bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
	

		if subEvent == "SPELL_HEAL" then
			if sourceName == UnitName("player") then
				--don't do anything for heals casted by player here
			else
				if destName == UnitName("player") then --someone cast a heal on the player we need to fire on a crit
					if critical == 1 then
					if Comix_CritGapEnabled then
						if damageAmount < Comix_CritGap then
							return --nothin to see here
						end
				
					end
						if math.random(1,100) <= Comix_CritPercent then
							--heal cast on the player crit fire off stuff
							--DEFAULT_CHAT_FRAME:AddMessage("heal crit fire friendly");
							if Comix_HealFlashEnabled then
								Comix_ScreenFlash(0, 1, 0, 1);
								--UIFrameFlash( Comix_FrameFlash2, 0.5, 0.5, 2, false, 1, 0);
							end
							Comix_CallPic(ComixHolyHealImages[math.random(1, ComixHolyHealImagesCt)])
							if Comix_CritHealsEnabled then
								Comix_DongSound(ComixHealingSounds,math.random(1,ComixHealingSoundsCt))
							end
						end
					end
				end
			end
			--DEFAULT_CHAT_FRAME:AddMessage("Spell heal!! firing target = "..arg7);
		end
	end

	if bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		
		
		if subEvent == "PARTY_KILL" then
			--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg2);
			KillCount()
		end
		

	--DEFAULT_CHAT_FRAME:AddMessage("Should fire on self event "..arg2);

		if subEvent == "SPELL_HEAL" then
			--DEFAULT_CHAT_FRAME:AddMessage("Spell heal firing arg11 = "..tostring(arg12).." "..arg13);
				if critical == 1 then
				
				if Comix_CritGapEnabled then
						
					if damageAmount < Comix_CritGap then
						return --nothin to see here
					end
				
				end
				
					if math.random(1,100) <= Comix_CritPercent then
						--DEFAULT_CHAT_FRAME:AddMessage("heal crit fire mine");
						if Comix_HealFlashEnabled then
							if destName == UnitName("player") then
								--UIFrameFlash( Comix_FrameFlash2, 0.5, 0.5, 2, false, 1, 0); --self
								Comix_ScreenFlash(0, 1, 0, 1);
							else
								Comix_ScreenFlash(0, 1, 0, 2);
							--	UIFrameFlash( Comix_FrameFlash4, 0.5, 0.5, 2, false, 1, 0);
							end
						end
						
						Comix_CallPic(ComixHolyHealImages[math.random(1, ComixHolyHealImagesCt)])
						if Comix_CritHealsEnabled then
							Comix_DongSound(ComixHealingSounds,math.random(1,ComixHealingSoundsCt))
						end
					end
				end
		end
		if subEvent == "SPELL_DAMAGE" or subEvent == "RANGE_DAMAGE" then
			--DEFAULT_CHAT_FRAME:AddMessage("spell/range_dmg fired "..arg10.." "..arg11.." "..arg12.." "..arg13.." "..tostring(arg18));
			 --DEFAULT_CHAT_FRAME:AddMessage("spell/range_dmg fired "..arg12 - arg13.." "..arg13 / (arg12 - arg13))
			if Comix_OverkillEnabled then
				if overkillAmount / (damageAmount - overkillAmount) > Comix_Overkill / 100 then
					Comix_CallPic(ComixOverkillImages[math.random(1, ComixOverkillImagesCt)]);
				--DEFAULT_CHAT_FRAME:AddMessage("overkill")
				end
			end
			
			--DEFAULT_CHAT_FRAME:AddMessage("crittest "..tostring(select(21, ...)));
			if select(21, ...) == 1 then -- 21 is crit event
			
			if Comix_CritGapEnabled then
						
				if damageAmount < Comix_CritGap then
					return --nothin to see here
				end
				
			end
			

				if math.random(1,100) <= Comix_CritPercent then
				if Comix_ShakeEnabled then
					Comix_ShakeScreen()
				end
				
				ComixCritCount = ComixCritCount + 1
				
				if ComixCritCount >= ComixMaxCrits then
					if Comix_SpecialsEnabled then
						Comix_DongSound(ComixSpecialSounds,4)
					end
					Comix_Pic(Comix_x_coord+math.random(-15,15),Comix_y_coord+math.random(-20,20),ComixSpecialImages[3])
					ComixCritCount = 0
				end
						
	          
				
				if Comix_CritSoundsEnabled then
					Comix_DongSound(ComixSounds)
				end
				if Comix_CritFlashEnabled then
					Comix_ScreenFlash(1, 0, 0, 2);
					--UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);		 
				end
						if spellSchool == 16 then
						Comix_CallPic(ComixFrostImages[math.random(1,ComixFrostImagesCt)]);
						elseif spellSchool == 20 then
						Comix_CallPic(ComixFrostfireImages[math.random(1,ComixFrostfireImagesCt)]);
						elseif spellSchool == 4 then
						Comix_CallPic(ComixFireImages[math.random(1,ComixFireImagesCt)]);
						elseif spellSchool == 2 then
						Comix_CallPic(ComixHolyDmgImages[math.random(1,ComixHolyDmgImagesCt)]);
						elseif spellSchool == 8 then
						Comix_CallPic(ComixNatureImages[math.random(1,ComixNatureImagesCt)]);
						elseif spellSchool == 32 then
						Comix_CallPic(ComixShadowImages[math.random(1,ComixShadowImagesCt)]);
						elseif spellSchool == 36 then
						Comix_CallPic(ComixShadowflameImages[math.random(1,ComixShadowflameImagesCt)]);
						elseif spellSchool == 48 then
						Comix_CallPic(ComixShadowfrostImages[math.random(1,ComixShadowfrostImagesCt)]);
						elseif spellSchool == 64 then
						Comix_CallPic(ComixArcaneImages[math.random(1,ComixArcaneImagesCt)]);
						elseif spellSchool == 72 then
						Comix_CallPic(ComixSpellstormImages[math.random(1,ComixSpellstormImagesCt)]);
						elseif spellSchool == 1 then
						Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)]);
						end					
						
				end
			else
				ComixCritCount = 0
			end
			

		end
	
	if subEvent == "SWING_DAMAGE" then
		damageAmount = select(12, ...) -- update damage and overkill for swing
		overkillAmount = select(13, ...)
	
		if Comix_OverkillEnabled then
			if overkillAmount / (damageAmount - overkillAmount) > Comix_Overkill / 100 then
				Comix_CallPic(ComixOverkillImages[math.random(1, ComixOverkillImagesCt)]);
		--DEFAULT_CHAT_FRAME:AddMessage("overkill")
			end
		end
	
		if critical == 1 then
		
			if Comix_CritGapEnabled then
						
				if damageAmount < Comix_CritGap then
					return --nothin to see here
				end
				
			end
		

			if math.random(1,100) <= Comix_CritPercent then
			if Comix_ShakeEnabled then
			Comix_ShakeScreen()
			end
			ComixCritCount = ComixCritCount + 1
			
			if ComixCritCount >= ComixMaxCrits then
				if Comix_SpecialsEnabled then
					Comix_DongSound(ComixSpecialSounds,4)
				end
				Comix_Pic(Comix_x_coord+math.random(-15,15),Comix_y_coord+math.random(-20,20),ComixSpecialImages[3])
				ComixCritCount = 0
			end
		
			if Comix_CritSoundsEnabled then
				Comix_DongSound(ComixSounds)
			end
			if Comix_CritFlashEnabled then
				Comix_ScreenFlash(1, 0, 0, 2);
				--UIFrameFlash( Comix_FrameFlash3, 0.5, 0.5, 2, false, 1, 0);		 
			end
			
			Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)])
			end
		else
			ComixCritCount = 0
		end
	end
end

end



  
  if event == "READY_CHECK" then
	
	if Comix_ReadySoundEnabled then
		Comix_DongSound(ComixReadySounds, math.random(1, ComixReadySoundsCt));
	end
  end
  
  if event == "UNIT_HEALTH" then
  -- finish him --
    if Comix_FinishhimEnabled then
      if Comix_FinishTarget then 
        if UnitHealth("target") > 0 and UnitIsFriend("player","target") == nil then
          local TargetHealth = (UnitHealth("target") / UnitHealthMax("target")) * 100
          if TargetHealth < Comix_FinishHimGap then
            Comix_DongSound(ComixSpecialSounds,12)
            Comix_FinishTarget = false
            Comix_OneHit = true;            
          end
        end  
      end    
    end  
  end
  
  
  if event == "PLAYER_DEAD" then
	--DEFAULT_CHAT_FRAME:AddMessage("dead",1,0,0)
	unghosted = false;
	dead = true
	  -- Oh poor guy ... you died ... noob :P --
     if Comix_DeathSoundEnabled then
      --if UnitIsDead("player") and strfind(arg1, getglobal("COMIX_YOUUP")) then
        Comix_CallPic(ComixDeathImages[math.random(1, ComixDeathImagesCt)]);
		Comix_DongSound(ComixDeathSounds,math.random(1,ComixDeathSoundsCt))
        ComixKillCount = 0;
      --end
    end
   
  end
  

  --res sound--
  if event == "RESURRECT_REQUEST" then
	--DEFAULT_CHAT_FRAME:AddMessage("res",1,0,0)
	unghosted = false;
	dontfireonalive = true;
	if Comix_ResSoundEnabled then
		Comix_DongSound(ComixSpecialSounds, 18);
	end
  end
  
  -- zone change sounds --
  if event == "ZONE_CHANGED_NEW_AREA" then
  local ininstance, instancetype = IsInInstance();

  
  if ininstance then
	if instancetype == "party" or instancetype == "raid" then
		if Comix_SpecialsEnabled then
			DEFAULT_CHAT_FRAME:AddMessage("[Dr. Evil] yells: Ladies and Gentlemen, Welcome to my Underground Lair!",1,0,0)
			Comix_DongSound(ComixSpecialSounds, 16); -- if specials are on we want a different sound when entering an instance, whether zone sounds are on or not --
		else
			if Comix_ZoneEnabled then
				Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
			end
		end
	else
		if Comix_ZoneEnabled then
			Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
		end
	end
	else
	if Comix_ZoneEnabled then
			Comix_DongSound(ComixZoneSounds,math.random(1,ComixZoneSoundsCt))
		end
	end
	
  
  end
  
  
	
 
 
    if event == "CHAT_MSG_EMOTE" then
			
	if Comix_SpecialsEnabled then
		if strfind(arg1, COMIX_BADJOKE) then
			Comix_DongSound(ComixSpecialSounds, 17);
		end
		if strfind(arg1, COMIX_DRAMAEMOTE) then
			Comix_DongSound(ComixSpecialSounds, 19);
		end
	end
	
   end

 
 -- Ability Sounds Checks - well besides cannibalize and sprint/dash --
   if event == "UNIT_SPELLCAST_SENT" then
   		   if Comix_DemoShoutEnabled then
				if arg2 == COMIX_DS or arg2 == COMIX_DR then
					Comix_Pic(0, 0,ComixSpecialImages[2])
				end
			end
     if Comix_AbilitySoundsEnabled then  
			if arg2 == COMIX_ICEBLOCK then
				Comix_DongSound(ComixAbilitySounds, 2);
			elseif arg2 == COMIX_CANNIBALIZE then
				Comix_DongSound(ComixAbilitySounds, 1);
			elseif arg2 == COMIX_SPRINT or arg2 == COMIX_DASH then
				Comix_DongSound(ComixSpecialSounds,11)
			elseif arg2 == COMIX_DS or arg2 == COMIX_DR then
			   if Comix_DemoShoutEnabled then
					if Comix_DSSounds then
						Comix_DongSound(ComixSpecialSounds,math.random(2,3))
					end
				end
			end
     end  
   end   

    

  -- Special Target Sounds --
  if event == "PLAYER_TARGET_CHANGED" then
	Comix_FinishTarget = true;
	
	if UnitName("target") == nil then
		return
	end
  
    if UnitName("target") == _G["COMIX_BIGGLESWORTH"] then
      Comix_DongSound(ComixSpecialSounds,5)
      DEFAULT_CHAT_FRAME:AddMessage("[Dr. Evil] yells: That makes me angry and when Dr. Evil gets angry Mr. Bigglesworth gets upset and when Mr. Bigglesworth gets upset...... PPL DIE!!!!!!!!11111oneoneoneoneeleveneleven",1,0,0)
      DEFAULT_CHAT_FRAME:AddMessage("[Venomia] yells: I COMMAND YOU!!! LEAVE THE CAT ALIVE OR YOU GET -50DKP!!!! (rly)",1,0,0)
    
    elseif UnitName("target") == _G["COMIX_REPAIRBOT"] or UnitName("target") == _G["COMIX_REPAIRBOT2"] then
      Comix_DongSound(ComixSpecialSounds,7)
      DEFAULT_CHAT_FRAME:AddMessage("["..UnitName("target").."]".." says: All your base, r belong to us")
	  
	elseif UnitName("target") == _G["COMIX_MUFFIN"] then
		Comix_DongSound(ComixSpecialSounds, 10)
		DEFAULT_CHAT_FRAME:AddMessage("Do you know the Muffin Man???", 0,1,0)
        
    end
      
  end
       
    

  
  -- Hug Coounter .. FU String Manipulation!!! -- 
  if event == "CHAT_MSG_TEXT_EMOTE" then
  
		if strfind(arg1, _G["COMIX_OBJECT"]) or strfind(arg1, _G["COMIX_OBJECTS"]) or strfind(arg1, _G["COMIX_OBJECTTO"]) or strfind(arg1, _G["COMIX_OBJECTSTO"]) then
--			DEFAULT_CHAT_FRAME:AddMessage("OBJECTION from "..arg2.." "..UnitSex(arg2), 0,1,0)

				if UnitInParty(arg2) or UnitInRaid(arg2) then
					if Comix_ObjectionImagesEnabled then
						Comix_CallPic("portrait", arg2)
						Comix_CallPic(ComixSpecialImages[5])
					end
					
					if Comix_ObjectionSoundsEnabled then
						if UnitSex(arg2) == 3 then
							Comix_DongSound(ComixObjectionSounds, math.random(3, 4))
						else
							Comix_DongSound(ComixObjectionSounds, math.random(1, 2))
						end
					end
					
				else
					if Comix_PublicObjections then
						if Comix_ObjectionImagesEnabled then
							Comix_CallPic(ComixSpecialImages[5])
						end
						
						if Comix_ObjectionSoundsEnabled then
							Comix_DongSound(ComixObjectionSounds, math.random(1, 4))
						end
											
					end

				end
				
				
		
		

		

		end
  
	  if strfind(arg1, _G["COMIX_HUG"]) or strfind(arg1,_G["COMIX_HUGS"]) then
      local HuggerNotFound = true
      local HuggedNotFound = true   
      local comix_the_hugged_one = nil
      if strfind(arg1,_G["COMIX_HUGS"]) then
        if GetLocale() == "frFR" then
          comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',13))
        else
          local gappie = tonumber(_G["COMIX_HUGGAP"]) 
          if arg2 == UnitName("player") then
            gappie = gappie + 3 
          else 
            gappie = gappie + strlen(arg2)
          end     
          comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',gappie))
          
        end 
      elseif strfind(arg1,"vous serre ") then
        comix_the_hugged_one = UnitName("player")     
      elseif strfind(arg1, _G["COMIX_HUG"]) then        
        local gappie = tonumber(_G["COMIX_HUGGAP"]) 
        if arg2 == UnitName("player") then
          gappie = gappie + 3 
        else 
          gappie = gappie + strlen(arg2)
        end    
        comix_the_hugged_one = strsub(arg1,strfind(arg1,'%a+',gappie))
                
      end 
    
      if strfind(comix_the_hugged_one, _G["COMIX_YOULOW"]) then
        comix_the_hugged_one = UnitName("player")
      end

        for i, line in ipairs(Comix_HugName) do
          if comix_the_hugged_one == _G["COMIX_YOULOW"] then
            comix_the_hugged_one = UnitName("player")
          end

          if Comix_HugName[i] == arg2 then
            if not strfind(arg1, _G["COMIX_NEED"]) then
              Comix_Hugs[i] = Comix_Hugs[i]+1
              HuggerNotFound = false
            end      
          end
          
          if Comix_HugName[i] == comix_the_hugged_one then
             Comix_Hugged[i] = Comix_Hugged[i]+1    
             HuggedNotFound = false
          end
        
        end
    
        if HuggedNotFound then
          if not strfind(arg1, _G["COMIX_NEED"]) then
            Comix_HugName[getn(Comix_HugName)+1] = comix_the_hugged_one
            Comix_Hugged[getn(Comix_HugName)] = 1
            Comix_Hugs[getn(Comix_HugName)] = 0
            Comix_HuggedNotFound = false;
          end   
        end 
        
        if HuggerNotFound then
          if not strfind(arg1, _G["COMIX_NEED"]) then
            Comix_HugName[getn(Comix_HugName)+1] = arg2
            Comix_Hugs[getn(Comix_HugName)] = 1
            Comix_Hugged[getn(Comix_HugName)] = 0
            Comix_HuggedNotFound = false;
          end 
        end
         
        for i,line in ipairs(Comix_HugName) do
          for j, line in ipairs(Comix_HugName) do
            if Comix_Hugged[i] > Comix_Hugged[j] then
              local Comix_TempHugged = Comix_Hugged[j]
              local Comix_TempHugs = Comix_Hugs[j]
              local Comix_TempHugName = Comix_HugName[j]
              Comix_Hugged[j] = Comix_Hugged[i]
              Comix_Hugs[j] = Comix_Hugs[i]
              Comix_HugName[j] = Comix_HugName[i]
              Comix_Hugged[i] = Comix_TempHugged
              Comix_Hugs[i] = Comix_TempHugs
              Comix_HugName[i] = Comix_TempHugName
            end  
          end
        end   
    end
  end 


  
 
end   
end    

function KillCount()
  if Comix_KillCountEnabled then
      
      --if strfind(arg1,getglobal("COMIX_YOUUP")) then
        ComixKillCount = ComixKillCount +1;
        ComixKillCountSoundPlayed = false; 
      --end    
    
      if ComixKillCountSoundPlayed == false then  
        if ComixKillCount == 2 then
          Comix_DongSound(ComixKillCountSounds,1)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 5 then
          Comix_DongSound(ComixKillCountSounds,2)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 8 then
          Comix_DongSound(ComixKillCountSounds,3)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 10 then
          Comix_DongSound(ComixKillCountSounds,4)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 15 then
          Comix_DongSound(ComixKillCountSounds,5)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 20 then
          Comix_DongSound(ComixKillCountSounds,6)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 30 then
          Comix_DongSound(ComixKillCountSounds,7)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 40 then
          Comix_DongSound(ComixKillCountSounds,8)
          ComixKillCountSoundPlayed = true 
        elseif ComixKillCount == 50 then
          Comix_DongSound(ComixKillCountSounds,9)
          ComixKillCountSoundPlayed = true 
        end    
      end
    end  
end

function Comix_ShakeScreen()
	if Comix_AddOnEnabled then
		if Comix_ShakeEnabled then
			if not IsShaking then
				OldWorldFramePoints = {};
				for i = 1, WorldFrame:GetNumPoints() do
					local point, frame, relPoint, xOffset, yOffset = WorldFrame:GetPoint(i);
					--DEFAULT_CHAT_FRAME:AddMessage("p- "..point..",r- "..relPoint..",xO- "..xOffset..",yO- "..yOffset)
					--need to make sure the offset is the same as the default one
					--DEFAULT_CHAT_FRAME:AddMessage(tostring(DefaultWorldFramePoints[i]["xOffset"]))
					if xOffset ~= DefaultWorldFramePoints[i]["xOffset"] then
						--DEFAULT_CHAT_FRAME:AddMessage("X OFFSET "..xOffset.." WRONG using default "..DefaultWorldFramePoints[i]["xOffset"])
						xOffset = DefaultWorldFramePoints[i]["xOffset"]
						
					end
					
					if yOffset ~= DefaultWorldFramePoints[i]["yOffset"] then
					--	DEFAULT_CHAT_FRAME:AddMessage("Y OFFSET "..yOffset.." WRONG using default "..DefaultWorldFramePoints[i]["yOffset"])
						yOffset = DefaultWorldFramePoints[i]["yOffset"]
					end
					
					
					OldWorldFramePoints[i] = {
						["point"] = point,
						["frame"] = frame,
						["relPoint"] = relPoint,
						["xOffset"] = xOffset,
						["yOffset"] = yOffset,
					}
				end
				IsShaking = Comix_ShakeDuration;
			end
		end
	end
end

Comix_UpdateInterval = .008
function Comix_OnUpdate(self, elapsed)
local TimeSinceLastUpdate = 0;
if elapsed == nil then 
  elapsed = 0
end
 -- DEFAULT_CHAT_FRAME:AddMessage("ding "..elapsed);
 
TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed; 
 
  while (TimeSinceLastUpdate > Comix_UpdateInterval) do
 
	-- ScreenShake
			if type(IsShaking) == "number" then
			IsShaking = IsShaking - elapsed;
			if IsShaking <= 0 then
				WorldFrame:ClearAllPoints();
				for index, value in pairs(OldWorldFramePoints) do
					WorldFrame:SetPoint(value.point, value.xOffset, value.yOffset);
				end
				IsShaking = false;
			else
				WorldFrame:ClearAllPoints();
				local moveBy;
				moveBy = math.random(-100, 100)/(101 - Comix_ShakeIntensity - (Comix_ShakeOffset - 1));
				for index, value in pairs(OldWorldFramePoints) do
					WorldFrame:SetPoint(value.point, value.xOffset + moveBy, value.yOffset + moveBy);
				end
			end
		end	

  --The Picture Animation
    for i = 1,5 do
      if Comix_Frames[i] ~= nil then
        if Comix_Frames[i]:IsVisible() then
          if Comix_FramesStatus[i] == 0 then
            Comix_FramesScale[i] = Comix_FramesScale[i]*1.1*ComixAniSpeed 
            if Comix_FramesScale[i] >= Comix_Max_Scale then
              Comix_FramesScale[i] = Comix_Max_Scale
			  Comix_FramesStatus[i] = 1    
            end
			Comix_Frames[i]:SetScale(Comix_FramesScale[i])
          elseif Comix_FramesStatus[i] == 1 then
            Comix_FramesScale[i] = Comix_Max_Scale--Comix_FramesScale[i]*0.8
            Comix_Frames[i]:SetScale(Comix_FramesScale[i])
            if Comix_FramesScale[i] >= Comix_Max_Scale*0.4 then
              Comix_FramesStatus[i] = 2
            end
          elseif Comix_FramesStatus[i] == 2 then
            Comix_FramesVisibleTime[i] = Comix_FramesVisibleTime[i] + 0.01
            if Comix_FramesVisibleTime[i] >= 1.0 then
              Comix_FramesStatus[i] = 3
            end  
          elseif Comix_FramesStatus[i] == 3 then
            Comix_FramesScale[i] = Comix_FramesScale[i]*0.5
            Comix_Frames[i]:SetScale(Comix_FramesScale[i])
            if Comix_FramesScale[i] <= 0.2 then
              Comix_Frames[i]:Hide()
              Comix_FramesStatus[i] = 0
              Comix_FramesScale[i] = 0.2
              Comix_FramesVisibleTime[i] = 0
            end
          end
        end            
      end    
    end  
  

    
  TimeSinceLastUpdate = TimeSinceLastUpdate-Comix_UpdateInterval;
  end   



end
	
function Comix_Command(Nerd)
  
  Nerd = strlower(Nerd)
   
  if (Nerd == "create") then 
    DEFAULT_CHAT_FRAME:AddMessage("Me Creates: Hello World")
    Comix_DongSound(ComixSpecialSounds,15)
	
	
	--elseif(Nerd == "deathtest") then
	--Comix_CallPic(ComixDeathImages[math.random(1, ComixDeathImagesCt)]);

    -- elseif(Nerd == "test1") then
		-- Comix_ScreenFlash(1, 0, 0, 1);
	
		
	-- elseif(Nerd == "test2") then
		-- Comix_ScreenFlash(1, 0, 1, 1);
	
		
	-- elseif(Nerd == "test3") then
		-- Comix_ScreenFlash(1, 0, 0, 2);
	
	
	-- elseif(Nerd == "test4") then
		-- Comix_ScreenFlash(0, 1, 1, 2);
	elseif (Nerd == "help") then
	DEFAULT_CHAT_FRAME:AddMessage("------------Comix Help-------------")
	DEFAULT_CHAT_FRAME:AddMessage("Fail/Awesome - type /fail or /awesome to use that feature")
	DEFAULT_CHAT_FRAME:AddMessage("the link will be placec where there is a ~~ in the string")
	DEFAULT_CHAT_FRAME:AddMessage("make sure you put where you want it sent too")
	DEFAULT_CHAT_FRAME:AddMessage("party - send to party, raid - send to raid, player name - send to player")
	DEFAULT_CHAT_FRAME:AddMessage("etc, other options are guild, yell, say, channel numbers also work")
	DEFAULT_CHAT_FRAME:AddMessage("Example - /fail raid wow this raid is ~~")
	DEFAULT_CHAT_FRAME:AddMessage("this will send - wow this raid is [Supermassive Fail] - to your raid group")
	DEFAULT_CHAT_FRAME:AddMessage("\nDrama - /drama will fire the drama detector")
	DEFAULT_CHAT_FRAME:AddMessage("Bad jokes - /badjoke will use the bad joke detector, can be aimed at your target")
	DEFAULT_CHAT_FRAME:AddMessage("\nEverthing else should be explained in the tooltips, im too lazy to type any more :P")
		
	
	
  elseif (Nerd == "hide") then 
    Comix_Framehide();
  
  elseif (Nerd == "pic") then 
   Comix_CallPic(ComixImages[math.random(1,ComixImagesCt)]);

  elseif (Nerd == "specialpic") then 
   Comix_CallPic(ComixSpecialImages[math.random(1,ComixSpecialCt)]);
  
  elseif (Nerd == "clearhug") then
    for i, line in ipairs(Comix_HugName) do
      Comix_HugName[i] = nil ;
      Comix_Hugged[i] = nil;
      Comix_Hugs[i] = nil; 
    end 
    Comix_HugName[1] = UnitName("player")
    Comix_Hugs[1] = 0
    Comix_Hugged[1] = 0 
  
  elseif (Nerd == "showhug") then
    for i = 1,5 do
      if Comix_HugName[i] ~= nil then
        DEFAULT_CHAT_FRAME:AddMessage("[Hug Report]: "..Comix_HugName[i].." has been hugged " ..Comix_Hugged[i].." times and Hugged "..Comix_Hugs[i].." times",0,0,1)
      end
    end 
  
  elseif (Nerd == "reporthug") then
    for i = 1,5 do
      if Comix_HugName[i] ~= nil then
        SendChatMessage("[Hug Report]: "..Comix_HugName[i].." has been hugged " ..Comix_Hugged[i].." times and Hugged "..Comix_Hugs[i].." times", "SAY")
      end
    end
       
	   
	elseif (Nerd == "clearjump") then
		Comix_JumpCount = 0;
		DEFAULT_CHAT_FRAME:AddMessage("Jump Counter Reset",0,0,1)
  
  elseif (Nerd == "showjump") then
        DEFAULT_CHAT_FRAME:AddMessage("[Jump Report]: "..UnitName("player").." has jumped " ..Comix_JumpCount.." times",0,0.5,1)
      
  
  elseif (Nerd == "reportjump") then
        SendChatMessage("[Jump Report]: "..UnitName("player").." has jumped " ..Comix_JumpCount.." times", "SAY")
    	
  else 
    comix_options_frame:Show()
    
  end
  
end

function Comix_BadJoke()
	
	if UnitIsPlayer("target") and not UnitIsUnit("target", "player") then
		SendChatMessage(COMIX_JOKEEMOTE2A..UnitName("target")..COMIX_JOKEEMOTE2B, "EMOTE");
	else
		SendChatMessage(COMIX_JOKEEMOTE1, "EMOTE");
	end

	
end

function Comix_Drama()
	SendChatMessage(COMIX_DRAMAEMOTE, "EMOTE");
end

function Comix_Fail(msg)
	local link = "\124cff71d5ff\124Hspell:65311\124h[Supermassive Fail]\124h\124r"
	msgSender(msg,link)
end

function Comix_Awesome(msg)
	local link = "\124cff71d5ff\124Hspell:58783\124h[Pure Awesome]\124h\124r"
	msgSender(msg, link)
end

function msgSender(message,link)
local command, txt = message:match("^(%S*)%s*(.-)$")
local fl = GetDefaultLanguage("PLAYER")
txt = gsub(txt,"~~",link)
if command == "say" or command == "emote" or command == "yell" or command == "party" or command == "guild" or command == "officer" or command == "raid" or command == "rw" or command == "bg" or command == "afk" or command == "dnd" then
	if command == "bg" then
		command = "battleground"
	end
	if command == "rw" then
		command = "raid_warning"
	end
	SendChatMessage(txt,command)
elseif tonumber(command) ~= nil and tonumber(command) > 0 and tonumber(command) < 100 then
	SendChatMessage(txt,"channel",fl,command)
else
	SendChatMessage(txt,"whisper",fl,command)
end
end




function Comix_DongSound(SoundTable,Sound)
	if not Comix_AddOnEnabled then
		return
	end
  if Comix_SoundEnabled then 
   if SoundTable == ComixSounds then  
     if Comix_BamEnabled then
	     PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..ComixSpecialSounds[13])
     else  
       local randsound = math.random(1,ComixSoundsCt)
       PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..SoundTable[randsound]);
     end
	else if SoundTable == "customcomixsound" then
		PlaySoundFile(Sound)
	
   else 
     PlaySoundFile("Interface\\AddOns\\Comix\\Sounds\\"..SoundTable[Sound]);
   end
   end
  end
   
end



function Comix_Pic(x,y,Pic, name)

  if Comix_ImagesEnabled then
-- Resetting Frames animation values --
    if Comix_Frames[ComixCurrentFrameCt]:IsVisible() then
      Comix_Frames[ComixCurrentFrameCt]:Hide()
    end  
    Comix_FramesStatus[ComixCurrentFrameCt] = 0
    Comix_FramesScale[ComixCurrentFrameCt] = 0.2
    Comix_FramesVisibleTime[ComixCurrentFrameCt] = 0 
   
-- Setting Texture --
	if Pic == "portrait" then
		SetPortraitTexture(Comix_textures[ComixCurrentFrameCt], name);
	else if name == "customcomixpic" then
		Comix_textures[ComixCurrentFrameCt]:SetTexture(Pic);
	else
		Comix_textures[ComixCurrentFrameCt]:SetTexture("Interface\\Addons\\Comix\\"..Pic);
	end
	end
    Comix_textures[ComixCurrentFrameCt]:SetAllPoints(Comix_Frames[ComixCurrentFrameCt]);
    Comix_Frames[ComixCurrentFrameCt].texture = Comix_textures[ComixCurrentFrameCt];
   
-- Positioning Frame --
     if Pic == "portrait" then
		Comix_Frames[ComixCurrentFrameCt]:SetPoint("Center",-150,-50);
	 else
		Comix_Frames[ComixCurrentFrameCt]:SetPoint("Center",x,y);
	end
    Comix_Frames[ComixCurrentFrameCt]:Show();

-- Increasing Current Frame or resetting it to 1 --  
    if ComixCurrentFrameCt == 5 then
      ComixCurrentFrameCt = 1
    else
      ComixCurrentFrameCt = ComixCurrentFrameCt +1
    end
  end     
end  

function Comix_LoaddaShite()

-- Counting Normal Images --  
  ComixImagesCt = getn(ComixImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixImagesCt.." piccus",0,0,0)

-- Counting Images in Image-Sets --
  ComixFireImagesCt = getn(ComixFireImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixFireImagesCt.." piccus",0,0,1)

  ComixFrostImagesCt = getn(ComixFrostImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixFrostImagesCt.." piccus",0,1,1)
  
  ComixFrostfireImagesCt = getn(ComixFrostfireImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixFrostfireImagesCt.." piccus",0,1,1)
  
  ComixSpellstormImagesCt = getn(ComixSpellstormImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSpellstormImagesCt.." piccus",0,1,1)
   
  ComixShadowflameImagesCt = getn(ComixShadowflameImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSpellstormImagesCt.." piccus",0,1,1)
  
  ComixShadowfrostImagesCt = getn(ComixShadowfrostImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSpellstormImagesCt.." piccus",0,1,1)

  ComixShadowImagesCt = getn(ComixShadowImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixShadowImagesCt.." piccus",0,1,0)

  ComixNatureImagesCt = getn(ComixNatureImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixNatureImagesCt.." piccus",1,1,0)

  ComixArcaneImagesCt = getn(ComixArcaneImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixArcaneImagesCt.." piccus",1,0,0)

  ComixHolyHealImagesCt = getn(ComixHolyHealImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHolyHealImagesCt.." piccus",0,0,0)

  ComixHolyDmgImagesCt = getn(ComixHolyDmgImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHolyDmgImagesCt.." piccus",0,0,0)
  
  ComixDeathImagesCt = getn(ComixDeathImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixDeathImagesCt.." piccus",0,0,0)
  
  ComixOverkillImagesCt = getn(ComixOverkillImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixOverkillImagesCt.." piccus",0,0,0)

-- Counting Normal Sounds --
  ComixSoundsCt = getn(ComixSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSoundsCt.." sounds",1,0,1)
  
-- Counting Zone Sounds --
  ComixZoneSoundsCt = getn(ComixZoneSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixZoneSoundsCt.." sounds",1,1,1)

-- Counting One hit Sounds --
  ComixOneHitSoundsCt = getn(ComixOneHitSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixOneHitSoundsCt.." sounds",1,1,1)
  
-- Counting Healing Sounds --   
  ComixHealingSoundsCt = getn(ComixHealingSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixHealingSoundsCt.." sounds",1,1,1)
  

-- Counting Specials --
  ComixSpecialCt = getn(ComixSpecialImages)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixSpecialCt.." specials",1,0,0)  
  
  -- Counting Ability Sounds --   
  ComixAbilitySoundsCt = getn(ComixAbilitySounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixAbilitySoundsCt.." sounds",1,1,1)

  -- Counting Death Sounds --   
  ComixDeathSoundsCt = getn(ComixDeathSounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixDeathSoundsCt.." sounds",1,1,1)
  
   -- Counting Ready check Sounds --   
  ComixReadySoundsCt = getn(ComixReadySounds)
  DEFAULT_CHAT_FRAME:AddMessage("Me loaded "..ComixReadySoundsCt.." sounds",1,1,1)
  
  DEFAULT_CHAT_FRAME:AddMessage("Open options GUI with /comix or get Slashcommands with /comix help",0,0,1)
    
end

function Comix_Framehide()
 for i,line in ipairs(Comix_Frames) do
   Comix_Frames[i]:Hide();
   DEFAULT_CHAT_FRAME:AddMessage("Hiding Comix_Frames["..i.."]")
 end
end



function Comix_CallPic(Image, name)
	if not Comix_AddOnEnabled then
		return
	end

  if Comix_ImagesEnabled then
-- Creating x,y Coordinates --
    Comix_x_coord = math.random(-120,120)
    if Comix_x_coord <= 0 then
      Comix_x_coord = Comix_x_coord -40
    else
      Comix_x_coord= Comix_x_coord +40
    end  
 
    if (abs(Comix_x_coord)<75) then
      local y_buffer = 50 
      Comix_y_coord = math.random(y_buffer,130)
    else
      Comix_y_coord = math.random(0,130)   
    end
  
-- Finally handing over x,y Coords and the image to show --
    Comix_CurrentImage = Image
    Comix_Pic(Comix_x_coord,Comix_y_coord,Image, name, gen)
 end
 
end



function Comix_CreateFrames()
-- Creating 5 Frames, creating 5 Textures and setting FramesScale, FramesVisibleTime & FramesStatus--
  for i = 1,5 do
    -- Create Frame --
    Comix_Frames[i] = CreateFrame("Frame","ComixFrame"..i,UIParent)
    Comix_Frames[i]:SetWidth(128);
    Comix_Frames[i]:SetHeight(128);
    Comix_Frames[i]:Hide()
    -- Create texture for each frame --
    Comix_textures[i] = Comix_Frames[i]:CreateTexture(nil,"BACKGROUND")
    -- Setting FramesScale, FramesVisibleTime & FramesStatus  to 0 --
    Comix_FramesScale[i] = 0.2
    Comix_FramesVisibleTime[i] = 0
    Comix_FramesStatus[i] = 0
  end
  

  Comix_FrameFlashTexture:SetVertexColor(1,0,0);

end  


--Functions for outside mods to access comix functions easier also for ComixPlus support
function Comix_CustomPic(path)
	Comix_CallPic(path, "customcomixpic");
end

function Comix_CustomSound(path)
	Comix_DongSound("customcomixsound", path);
end

function Comix_ScreenFlash(r, g, b, size)
	
	if size < 1 then
		size = 1
	end
	
	if size > 2 then
		size = 2
	end
	
	Comix_FrameFlashTexture:SetTexture("Interface\\Addons\\Comix\\Images\\flash"..size..".tga")
	
	Comix_FrameFlashTexture:SetVertexColor(r, g, b)
		
	
	UIFrameFlash( Comix_FrameFlash, 0.5, 0.5, 2, false, 1, 0);
	
end

function Comix_ActivatePlus()
	comixheader:SetText("Comix Options +")
end

