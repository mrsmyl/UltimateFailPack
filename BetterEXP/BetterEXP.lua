-------------------------------------------------------------
--  BetterEXP -- Advanced Experience Bar
-------------------------------------------------------------
--  Version 3.05 - Modified by Ture of Sisters of Elune
--  Modified from Zynna's BetterEXP 2.0
-------------------------------------------------------------
--  Based on the original code from Arronax on Thunderhorn --
-------------------------------------------------------------
-- Updated to 4.0 for Cataclysm  by Joelan of Terokkar
-------------------------------------------------------------
--CONSTANTS/Etc..
--Feel free to change color values
--Variables set a 0 so they aren't nil
--------------------------------------

BEXP_selection			= 0
BEXP_toLevel			= 0
BEXP_avgXP			= 0
BEXP_gainedXP      	  	= 0
BEXP_kills			= 0
BEXP_currentXP			= 0
BEXP_maxXP			= 0
BEXP_leftXP			= 0
BEXP_restedXP			= 0
BEXP_maxBubbleXP		= 0
BEXP_currentBubbleXP		= 0
BEXP_alpha			= 1

--Default Values--
BEXP_BAR_LOCKED = 1

--Colors
BEXP_restedColorR = 0
BEXP_restedColorG = 0.02352941176470588
BEXP_restedColorB = 0.796078431372549
BEXP_normalColorR = 0.7058823529411764
BEXP_normalColorG = 0.09019607843137255
BEXP_normalColorB = 0.9215686274509803
BEXP_bubbleColorR = 1
BEXP_bubbleColorG = 0.8431372549019608
BEXP_bubbleColorB = 0.2117647058823529

--Frame width vars
BEXP_frameWidth = 21  --325
BEXP_textureWidth =   61.09090909090909 --340.9836065573771
BEXP_textBarWidth = 7.636363636363637  --319.672131147541

--Frame height vars
BEXP_frameHeight = 325  -- 21
BEXP_textureHeight = 340.9836065573771  --61.09090909090909
BEXP_textBarHeight = 319.672131147541  --7.636363636363637

-- Vertical/Horizontal Orientation
--BEXP_HOR = 1
--BEXP_VERT = 0



---------
--On Load
---------
function BetterEXP_OnLoad(self)
	self:RegisterEvent("PLAYER_XP_UPDATE");
	self:RegisterEvent("UPDATE_EXHAUSTION");
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
end

----------------------------------
--Initial function called from XML
--Handles slash command
----------------------------------
function BetterEXP_initialize()
	BetterEXPFrame:Show();
	RevertBarText();
	UpdateFrameSize();

	SlashCmdList["BetterEXP"] = BEXPhandler;
	SLASH_BetterEXP1 = "/bexp";
	SLASH_BetterEXP2 = "/BetterEXP";
end


function BEXP_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, BEXP_DropDown_Initialize, "MENU");
end

function BEXP_DropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = _G[UIDROPDOWNMENU_OPEN_MENU];
	else
		dropdown = self;
	end
	BEXP_DropDown_InitButtons();
end

function BEXP_DropDown_InitButtons()
	local info = {};
	 --0
	info.text = "BetterEXP Options";
	info.isTitle = 1;
	info.justifyH = "CENTER";
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
	 --1
	info = { };
	info.text = "Lock";
	info.notCheckable = 1;
	info.func = BEXPLock;
	UIDropDownMenu_AddButton(info);
	  --2
	info = { };
	info.text = "Unlock";
	info.notCheckable = 1;
	info.func = BEXPUnlock;
	UIDropDownMenu_AddButton(info);
	  --3
	info = { };
	info.text = "Help";
	info.notCheckable = 1;
	info.func = BEXPHelp;
	UIDropDownMenu_AddButton(info);
	info = { };
	   --4
	info.text = "Change normal color";
	info.notCheckable = 1;
	info.func = BEXPNcolor;
	UIDropDownMenu_AddButton(info);
	info = { };
	  --5
	info.text = "Change rested color";
	info.notCheckable = 1;
	info.func = BEXPRcolor;
	UIDropDownMenu_AddButton(info);
	  --6
	info = { };
	info.text = "Change bubble color";
	info.notCheckable = 1;
	info.func = BEXPBcolor;
	UIDropDownMenu_AddButton(info);
	  --7
	info = { };
	info.text = "Reset colors";
	info.notCheckable = 1;
	info.func = BEXPDcolor;
	UIDropDownMenu_AddButton(info);
	  --8
	info = { };
	info.text = "Change size";
	info.notCheckable = 1;
	info.func = BEXPSize;
	UIDropDownMenu_AddButton(info);
	   --9
	info = { };
	info.text = "Reset averages";
	info.notCheckable = 1;
	info.func = BEXPReset;
	UIDropDownMenu_AddButton(info);
	   --10
	info = { };
	info.text = "Reset Size";
	info.notCheckable = 1;
	info.func = BEXPbSize;
	UIDropDownMenu_AddButton(info);
		--11
	--info = { };
	--info.text = "Vertical Bar";
	--info.notCheckable = 0;
	--info.func = BEXP_VERT;
	--UIDropDownMenu_AddButton(info);
		--12
	--info = { };
	--info.text = "Horizontal Bar";
	--info.notCheckable = 0;
	--info.func = BEXP_HOR;
	--UIDropDownMenu_AddButton(info);
		--13
	
end

---------------
--Event Handler
---------------
function BetterEXP_OnEvent (self, event, ...)
	
	if (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_EXHAUSTION") then
		BEXP_currentXP = UnitXP("player");
		BEXP_maxXP = UnitXPMax("player");
		
		BEXP_restedXP = GetXPExhaustion();
  		
		BetterEXPUpdateColor();
		
		BEXP_maxBubbleXP = BEXP_maxXP / 20;

		BEXP_currentBubbleXP = math.fmod(BEXP_currentXP, BEXP_maxBubbleXP);

		BetterEXPLevelBar:SetMinMaxValues(min(0, BEXP_currentXP), BEXP_maxXP);

		BetterEXPBubbleBar:SetMinMaxValues(min(0, BEXP_currentBubbleXP), BEXP_maxBubbleXP);
  		BetterEXPBubbleBar:SetValue(BEXP_currentBubbleXP);

		BetterEXPRestedBar:SetMinMaxValues(min(0, BEXP_currentXP), BEXP_maxXP);
                
		if (BEXP_restedXP == nil) then
  			BetterEXPRestedBar:SetValue(0);
  			BetterEXPLevelBar:SetValue(BEXP_currentXP);
		else
  			BetterEXPRestedBar:SetValue(BEXP_restedXP + BEXP_currentXP);
  			BetterEXPLevelBar:SetValue(BEXP_currentXP);
		end

		BEXP_leftXP = BEXP_maxXP - BEXP_currentXP;
		BEXP_toLevel = math.ceil(BEXP_leftXP / BEXP_avgXP);
		RevertBarText();

	elseif (event == "CHAT_MSG_COMBAT_XP_GAIN") then
		local arg1 = ...;
		BEXP_kills = BEXP_kills + 1	
		for xpGain in string.gmatch(arg1, BEXP_XP_STRING) do
			BEXP_gainedXP = BEXP_gainedXP + xpGain;
		end

		BEXP_avgXP = math.ceil(BEXP_gainedXP / BEXP_kills);
		BEXP_toLevel = math.ceil(BEXP_leftXP / BEXP_avgXP);
		RevertBarText();
	end
	
end
----------
--Bar Text
----------
function ShowBarText()
	if (BEXP_restedXP == nil) then
		BetterEXPBubbleText:SetText(BEXP_currentXP.." / "..BEXP_maxXP.."    "..BEXP_leftXP..REMAINING_TXT);
		GameTooltip_SetDefaultAnchor(GameTooltip, WorldFrame);
		GameTooltip:SetText(NORMAL_1, 1.00, 1.00, 0);
		GameTooltip:AddLine(NORMAL_2, 1.00, 1.00, 1.00);
	else
		BetterEXPBubbleText:SetText(BEXP_currentXP.." / "..BEXP_maxXP.."    "..BEXP_restedXP..RESTED_TXT.."    "..BEXP_leftXP..REMAINING_TXT);
		GameTooltip_SetDefaultAnchor(GameTooltip, WorldFrame);
		GameTooltip:SetText(RESTED_1, .45, .45, .95);
		GameTooltip:AddLine(RESTED_2, 1.00, 1.00, 1.00);
	end

	GameTooltip:AddLine(BEXP_avgXP..AVG_XP_MSG, 1.00, 1.00, 1.00);
	if (BEXP_avgXP == 0) then
		GameTooltip:AddLine("??"..BEXP_KILLS_TNL, 1.00, 1.00, 1.00);
	else
		GameTooltip:AddLine(BEXP_toLevel..BEXP_KILLS_TNL, 1.00, 1.00, 1.00);
	end
	GameTooltip:Show();
end

function RevertBarText()
	local percStrng="" local
	perc=(BEXP_currentXP * 10) / (BEXP_maxXP / 10)
	if (BEXP_avgXP == 0) then
		percStrng = format("~~ - %d%%",perc)
		BetterEXPBubbleText:SetText(percStrng);
	else
		if(BEXP_toLevel == 1) then
			BetterEXPBubbleText:SetText(BEXP_KILL_TNL);
		else percStrng = format(" - %d%%",perc)
			BetterEXPBubbleText:SetText(BEXP_toLevel..BEXP_KILLS_TNL..percStrng);
		end

	end
end

-------
--Color
-------
function BetterEXPUpdateColor()
	--if (BEXP_restedXP == nil) then
		BetterEXPLevelBar:SetStatusBarColor(BEXP_normalColorR, BEXP_normalColorG, BEXP_normalColorB)
	--else
		BetterEXPRestedBar:SetStatusBarColor(BEXP_restedColorR, BEXP_restedColorG, BEXP_restedColorB, BEXP_alpha)
		BetterEXPLevelBar:SetStatusBarColor(BEXP_normalColorR, BEXP_normalColorG, BEXP_normalColorB)
	--end

	BetterEXPBubbleBar:SetStatusBarColor(BEXP_bubbleColorR, BEXP_bubbleColorG, BEXP_bubbleColorB)
end

function RememberCurrentColors()
	oldNColorR = BEXP_normalColorR;
	oldNColorG = BEXP_normalColorG;
	oldNColorB = BEXP_normalColorB;

	oldRColorR = BEXP_restedColorR;
	oldRColorG = BEXP_restedColorG;
	oldRColorB = BEXP_restedColorB;

	oldBColorR = BEXP_bubbleColorR;
	oldBColorG = BEXP_bubbleColorG;
	oldBColorB = BEXP_bubbleColorB;
end

--------
--Sizing
--------
function UpdateFrameSize()
	BetterEXPFrame:SetWidth(BEXP_frameWidth);
	BetterEXPTexture:SetWidth(BEXP_textureWidth);
	BetterEXPBubbleText:SetWidth(BEXP_textBarWidth);
	BetterEXPBubbleBar:SetWidth(BEXP_textBarWidth);
	BetterEXPLevelBar:SetWidth(BEXP_textBarWidth);
	BetterEXPRestedBar:SetWidth(BEXP_textBarWidth);

	BetterEXPFrame:SetHeight(BEXP_frameHeight);
	BetterEXPTexture:SetHeight(BEXP_textureHeight);
	BetterEXPBubbleText:SetHeight(BEXP_textBarHeight);
	BetterEXPBubbleBar:SetHeight(BEXP_textBarHeight);
	BetterEXPLevelBar:SetHeight(BEXP_textBarHeight);
	BetterEXPRestedBar:SetHeight(BEXP_textBarHeight)
end




----------------
--Slash commands
----------------

function BEXPLock()
	BAR_LOCKED = 1;
	DEFAULT_CHAT_FRAME:AddMessage("BetterEXP"..LOCKED_MSG);
end

function BEXPUnlock()
	BAR_LOCKED = 0;
	DEFAULT_CHAT_FRAME:AddMessage("BetterEXP"..UNLOCK_MSG);
end


function BEXPNcolor()
	BEXP_selection = 0;
	RememberCurrentColors();
	BEXPCurrentColorSwatch:SetTexture(BEXP_normalColorR, BEXP_normalColorG, BEXP_normalColorB);
	BetterEXPColorSelect:Show();
end

function BEXPRcolor()
	BEXP_selection = 1;
	RememberCurrentColors();
	BEXPCurrentColorSwatch:SetTexture(BEXP_restedColorR, BEXP_restedColorG, BEXP_restedColorB, BEXP_alpha);
	BetterEXPColorSelect:Show();
end

function BEXPBcolor()
	BEXP_selection = 2;
	RememberCurrentColors();
	BEXPCurrentColorSwatch:SetTexture(BEXP_bubbleColorR, BEXP_bubbleColorG, BEXP_bubbleColorB);
	BetterEXPColorSelect:Show();
end

function BEXPAlpha_on()
    BEXP_alpha = 0.8
	BetterEXPUpdateColor()
end

function BEXPAlpha_off()
    BEXP_alpha = 1.0
	BetterEXPUpdateColor()
end

function BEXPDcolor()
	BEXP_restedColorR = 0
	BEXP_restedColorG = 0.02352941176470588
	BEXP_restedColorB = 0.796078431372549
	BEXP_normalColorR = 0.7058823529411764
	BEXP_normalColorG = 0.09019607843137255
	BEXP_normalColorB = 0.9215686274509803
	BEXP_bubbleColorR = 1
	BEXP_bubbleColorG = 0.8431372549019608
	BEXP_bubbleColorB = 0.2117647058823529
	BetterEXPUpdateColor();
	DEFAULT_CHAT_FRAME:AddMessage("BetterEXP "..COL_RES)
	
end

function BEXPSize()
	BEXPSliderBox:Show();
end

function BEXPHeightChange()
	BEXP_frameHeight = BEXPHeightSlider:GetValue();
	local ratio = BEXP_frameHeight / 20;
	BEXP_textureHeight = 64 * ratio;
	BEXP_textBarHeight = 8 * ratio;
	UpdateFrameSize();
end

function BEXPWidthChange()
	BEXP_frameWidth = BEXPWidthSlider:GetValue();
	local ratio = BEXP_frameWidth / 488;
	BEXP_textureWidth = 512 * ratio;
	BEXP_textBarWidth = 480 * ratio;
	UpdateFrameSize();
end
-- Orientation H/V


function BEXPbSize()
	-- Width reset
	BEXP_frameWidth = 560
	BEXP_textureWidth = 588
	BEXP_textBarWidth = 551
	UpdateFrameSize();
	-- Height reset
	BEXP_frameHeight = 23
	BEXP_textureHeight = 66
	BEXP_textBarHeight = 9
	UpdateFrameSize();	
	DEFAULT_CHAT_FRAME:AddMessage("BetterEXP "..BAR_SIZE)
end




function BEXPHelp()
	DEFAULT_CHAT_FRAME:AddMessage("/bexp lock -"..HELP_1);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp unlock -"..HELP_2);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp help -"..HELP_3);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp ncolor -"..HELP_4);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp rcolor -"..HELP_5);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp bcolor -"..HELP_6);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp defaultcolors -"..HELP_7);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp size -"..HELP_8);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp reset -"..HELP_9);
	DEFAULT_CHAT_FRAME:AddMessage("/bexp bar reset -"..HELP_10)
	--DEFAULT_CHAT_FRAME:AddMessage("/bexp vert -"..HELP_11)
	--DEFAULT_CHAT_FRAME:AddMessage("/bexp horizon -"..HELP_12)
end

function BEXPReset()
	BEXP_gainedXP = 0
	BEXP_kills = 0
	BEXP_avgXP = 0
	DEFAULT_CHAT_FRAME:AddMessage("BetterEXP "..AVG_RES)
end

function BEXPhandler(message)
	if(message) then
		local msg = string.lower(message);
		if(msg == "lock") then
			BEXPLock()
		elseif (msg == "unlock") then
			BEXPUnlock()
		elseif (msg == "ncolor") then
			BEXPNcolor()
		elseif (msg == "rcolor") then
			BEXPRcolor()
		elseif (msg == "bcolor") then
			BEXPBcolor()
		elseif (msg == "defaultcolors") then
			BEXPDcolor()
		elseif (msg == "size") then
			BEXPSliderBox:Show()
		elseif (msg == "alpha on") then
			BEXPAlpha_on()
		elseif (msg == "alpha off") then
			BEXPAlpha_off()
		elseif (msg == "reset") then
			BEXPReset()
		elseif (msg == "reset size") then
			BEXPReset()	
		else
			BEXPHelp()
		end
	end
end

----------------------------------------------------------
--Below this line used to hide Blizzard's Experience bar--
----------------------------------------------------------

function HideBlizzExpBar_OnEvent()
	MainMenuExpBar:Hide();
	MainMenuBarLeftEndCap:Hide();
	MainMenuBarRightEndCap:Hide();

end

local dummyframe = CreateFrame("Frame");
dummyframe:SetScript("OnEvent", HideBlizzExpBar_OnEvent);

-- frame:RegisterEvent("PLAYER_LEVEL_UP");

dummyframe:RegisterEvent("ZONE_CHANGED");
dummyframe:RegisterEvent("ZONE_CHANGED_NEW_AREA");

