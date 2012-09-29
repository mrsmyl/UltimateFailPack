-- Advanced Trade Skill Window v0.10.0
-- written 2006-2011 by Rene Schneider (Slarti on EU-Blackhand)
-- performance and stability improved 2012 by rowaasr13

-- main script file

local _, aEnv = ...

local function crash_debug(...)  end

ATSW_TRADE_SKILLS_DISPLAYED = 23;
ATSW_MAX_TRADE_SKILL_REAGENTS = 8;
ATSW_TRADE_SKILL_HEIGHT = 16;
ATSW_MAX_DELAY = 4.0;
ATSW_MAX_RETRIES = 5;

ATSWTypeColor = { };
ATSWTypeColor["optimal"] = { r = 1.00, g = 0.50, b = 0.25, font = GameFontNormalLeftOrange };
ATSWTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00, font = GameFontNormalLeftYellow };
ATSWTypeColor["easy"] = { r = 0.25, g = 0.75, b = 0.25, font = GameFontNormalLeftLightGreen };
ATSWTypeColor["trivial"] = { r = 0.50, g = 0.50, b = 0.50, font = GameFontNormalLeftGrey };
ATSWTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0, font = GameFontNormalLeft };

ATSWRarityNames={};
ATSWRarityNames["purple"]=4;
ATSWRarityNames["blue"]=3;
ATSWRarityNames["green"]=2;
ATSWRarityNames["white"]=1;
ATSWRarityNames["grey"]=0;

atsw_tradeskilllist={};

---- Opened skill list data [START] ----
local OpenedSkillList        = atsw_tradeskilllist -- Data on recipes in CURRENTLY OPENED TRADESKILL.
local OpenedSkillListLen     = 0                   -- Cached list lenght to avoid repeated lookups and allow some rewrites that will minimize amount of generated garbage.
local OpenedSkillNameToIdx   = {}                  -- Skill name to index map for faster lookups.
local OpenedSkillListDirty   = 1                   -- Flag if list needs refreshing or not. Actual refresh only happens when data is needed, but flag is raised on any event that may affect list.
local OpenedSkillListRefresh                       -- Function that refreshes list content.
---- Opened skill list data [ END ] ----

local atsw_tradeskillheaders={};
local atsw_skilllisting={};
local atsw_tradeskillcountcache={};
local atsw_tradeskillcountwithinventorycache={};
atsw_selectedskill="";
local atsw_displayedgroup="";
local atsw_retries=0;
local atsw_retrydelay=0;
local atsw_retry=false;
local atsw_delay=0;
local atsw_working=false;
local atsw_processingtimeout=0;
local atsw_scans=0;
local atsw_updatedelay=0;
local atsw_uncategorizedexpanded=true;
local atsw_tradeskillid={};
local atsw_currentinvslotfilter={};
local atsw_invslotfilter={};
local atsw_invslotfiltered={};
local atsw_currentsubclassfilter={};
local atsw_subclassfilter={};
local atsw_subclassfiltered={};
local atsw_updating=false;
local atsw_incombat=false;
local atsw_bankopened=false;
local atsw_queueditemlist={};
local atsw_temporaryitemlist={};
atsw_queue={};
local atsw_preventupdate=false;
local atsw_iscurrentlyenabled=false;
local atsw_processingname="";
local atsw_processing=false;
local atsw_processnext=false;
local atsw_lastremoved="";
local atsw_missingitems={};
local atsw_necessaryitems={};
local atsw_filter="";
local atsw_scan_timeout=0;
local atsw_scan_state=0;
local atsw_scan_delay=0.1;
local atsw_scan_numtradeskills=0;
local atsw_scan_nextskill=0;
atsw_itemlist={};
atsw_orderby={};
atsw_disabled={};
atsw_savedqueue={};
atsw_savednecessaryitems={};
atsw_is_sorted=false;
atsw_prescanned={};
atsw_onlycreatable=false;

-- Lua/Blizzard API
local tinsert=table.insert
local wipe=wipe
local ceil=math.ceil
local floor=math.floor

-- internal functions - no need to pollute _G
local ATSW_CreateSkillListing

local player_name
local player_realm=GetRealmName()

function ATSW_OnLoad()
	SLASH_ATSW1 = "/atsw";
	SlashCmdList["ATSW"] = ATSW_Command;
	ATSWFrame:RegisterEvent("TRADE_SKILL_UPDATE");
	ATSWFrame:RegisterEvent("TRADE_SKILL_CLOSE");
	ATSWFrame:RegisterEvent("TRADE_SKILL_SHOW");
	ATSWFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	ATSWFrame:RegisterEvent("UPDATE_TRADESKILL_RECAST");
	ATSWFrame:RegisterEvent("BANKFRAME_OPENED");
	ATSWFrame:RegisterEvent("BANKFRAME_CLOSED");
	ATSWFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	ATSWFrame:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	ATSWFrame:RegisterEvent("MERCHANT_SHOW");
	ATSWFrame:RegisterEvent("MERCHANT_UPDATE");
	ATSWFrame:RegisterEvent("MERCHANT_CLOSED");
	ATSWFrame:RegisterEvent("BAG_UPDATE");
	ATSWFrame:RegisterEvent("TRAINER_CLOSED");
	ATSWFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	ATSWFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	ATSWFrame:RegisterEvent("AUCTION_HOUSE_CLOSED");
	ATSWFrame:RegisterEvent("AUCTION_HOUSE_SHOW");
	ATSWFrame:RegisterEvent("CRAFT_SHOW");
	ATSWFrame:RegisterEvent("CRAFT_CLOSE");
	ATSWFrame:RegisterEvent("PLAYER_LOGOUT");
	ATSWFrame:RegisterEvent("UI_ERROR_MESSAGE");
	ATSWFrame:RegisterEvent("VARIABLES_LOADED")
end

function ATSW_ShowWindow()
	if(type(atsw_orderby)~="table") then atsw_orderby={}; end
	if(not atsw_orderby[player_name]) then atsw_orderby[player_name]={}; end
	if(not atsw_orderby[player_name][atsw_selectedskill]) then atsw_orderby[player_name][atsw_selectedskill]="nothing"; end
	--if(atsw_oldmode and atsw_orderby[player_name][atsw_selectedskill]=="nothing") then
	--	atsw_orderby[player_name][atsw_selectedskill]="name";
	--end
	atsw_oldtradeskillcount=0;
	atsw_is_sorted=false;
	if(atsw_subclassfiltered[atsw_selectedskill]==nil) then atsw_subclassfiltered[atsw_selectedskill]={}; end
	if(atsw_invslotfiltered[atsw_selectedskill]==nil) then atsw_invslotfiltered[atsw_selectedskill]={}; end
	ShowUIPanel(ATSWCheckerFrame);
	ShowUIPanel(ATSWFrame);
	SetPortraitTexture(ATSWFramePortrait, "player");
	--if(not atsw_oldmode) then
		ExpandTradeSkillSubClass(0);
		if(GetTradeSkillSelectionIndex()>1) then
			ATSWFrame_SetSelection(GetTradeSkillSelectionIndex());
		else
			if(GetNumTradeSkills()>0) then
				ATSWFrame_SetSelection(GetFirstTradeSkill());
				FauxScrollFrame_SetOffset(ATSWListScrollFrame, 0);
			end
			ATSWListScrollFrameScrollBar:SetValue(0);
		end
	--end
	ATSWFrameTitleText:SetFormattedText(TEXT(TRADE_SKILL_TITLE).." - "..ATSW_VERSION, GetTradeSkillLine());
	ATSW_AdjustFrame();
	ATSW_ResetPossibleItemCounts();
	OpenedSkillListRefresh();
	crash_debug("leaving OpenedSkillListRefresh() 1")
	ATSW_CreateSkillListing();
	crash_debug("leaving ATSW_CreateSkillListing() 1")
	ATSWInv_UpdateItemList();
	ATSWFrame_UpdateQueue();
	ATSWInv_UpdateQueuedItemList();
	ATSWFrame_Update();
	ATSWInputBox:SetText("1");
	atsw_updatedelay=0.5;
end

function ATSW_HideWindow()
	ATSW_SaveQueue(false);
	atsw_processing=false;
	if(AC_Craft and AC_Craft:GetParent()==ATSWFrame and TradeSkillFrame~=nil) then -- for ArmorCraft and atsw_oldmode==false
		AC_Craft:SetParent(TradeSkillFrame);
		AC_Craft:SetPoint("TOPLEFT","TradeSkillFrame","TOPRIGHT",-40,100);
		AC_Craft:SetFrameLevel(0);
		AC_ToggleButton:SetParent(TradeSkillFrame);
		AC_ToggleButton:SetFrameLevel(TradeSkillFrame:GetFrameLevel()+3);
		AC_ToggleButton:SetPoint("RIGHT","TradeSkillFrameCloseButton","LEFT")
		AC_UseButton:SetPoint("RIGHT","AC_ToggleButton","LEFT");
		AC_UseButton:SetFrameLevel(TradeSkillFrame:GetFrameLevel()+3);
	end
	ATSWQueueStartStopButton:Enable();
	ATSWQueueDeleteButton:Enable();
	HideUIPanel(ATSWFrame);
end

function ATSW_GetSelectedSkill()
	atsw_selectedskill=GetTradeSkillLine();
	if(not atsw_disabled[player_name]) then
		atsw_disabled[player_name]={};
	end
	if(not atsw_disabled[player_name][atsw_selectedskill]) then
		atsw_disabled[player_name][atsw_selectedskill]=0;
	end
end

function ATSW_CheckForRescan()
	atsw_scans=0;
	skillname=GetTradeSkillLine();
	if(skillname) then
		if(skillname~=atsw_displayedgroup) then
			if(atsw_displayedgroup~="") then
				ATSW_SaveQueue(false);
			end
			atsw_displayedgroup=skillname;
			atsw_selectedskill=skillname;
			ATSW_RestoreQueue();
			OpenedSkillListRefresh();
			crash_debug("leaving OpenedSkillListRefresh() 2")
			ATSW_NoteNecessaryItemsForQueue();
		end
	end
	if(ls3dci_guiTradeButton and ls3dci_guiTradeButton:IsVisible() and ls3dci_guiTradeButton:GetParent()~=ATSWFrame) then -- for LS3D craft info
		ls3dci_guiTradeButton:SetParent(ATSWFrame);
		ls3dci_guiTradePostButton:SetParent(ATSWFrame);
		ls3dci_guiTradeWatchButton:SetParent(ATSWFrame);
		ls3dci_guiTradeButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+50, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradePostButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+156, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradeWatchButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+262, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradeButton:SetAlpha(1.0);
		ls3dci_guiTradePostButton:SetAlpha(1.0);
		ls3dci_guiTradeWatchButton:SetAlpha(1.0);
	end
	if(AC_Craft and AC_Craft:GetParent()~=ATSWFrame) then -- for ArmorCraft
		AC_Craft:SetParent(ATSWFrame);
		AC_Craft:SetPoint("TOPLEFT","ATSWFrame","TOPRIGHT",-40,0);
		AC_Craft:SetFrameLevel(0);
		AC_ToggleButton:SetParent(ATSWFrame);
		AC_ToggleButton:SetFrameLevel(ATSWFrame:GetFrameLevel()+3);
		AC_ToggleButton:SetPoint("RIGHT","ATSWFrameCloseButton","LEFT")
		AC_UseButton:SetFrameLevel(ATSWFrame:GetFrameLevel()+3);
		AC_UseButton:SetPoint("RIGHT","AC_ToggleButton","LEFT");
		AC_Craft:SetAlpha(1.0);
		AC_ToggleButton:SetAlpha(1.0);
		AC_UseButton:SetAlpha(1.0);
	end
end

function ATSW_OnHide()
	--if(not atsw_oldmode) then
		TradeSkillFrame_Hide();
	--else
	--	CraftFrame_Hide();
	--end
	HideUIPanel(ATSWCheckerFrame);
	HideUIPanel(ATSWReagentFrame);
	HideUIPanel(ATSWCSFrame);
	atsw_displayedgroup="";
	atsw_selectedskill="";
end

function ATSW_Command(cmd)
	if(cmd=="show") then
		ATSW_ShowWindow();
	elseif(cmd=="disable") then
		ATSW_DisableForActiveTradeskill();
	elseif(cmd=="enable") then
		ATSW_EnableForActiveTradeskill();
	elseif(cmd=="reagents") then
		ShowUIPanel(ATSWAllReagentListFrame);
	elseif(cmd=="deletequeues") then
		wipe(atsw_savedqueue)
		wipe(atsw_savednecessaryitems)
		ATSW_DisplayMessage(ATSW_QUEUESDELETED);
	end
end

function ATSW_DisableForActiveTradeskill()
	if(TradeSkillFrame and TradeSkillFrame:IsVisible()) then
		atsw_disabled[player_name][atsw_selectedskill]=1;
		ATSW_IsEnabled();
		HideUIPanel(ATSWFrame);
		ATSW_ShowBlizzardTradeSkillFrame();
		ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_DEACTIVATED);
	end
end

function ATSW_EnableForActiveTradeskill()
	if(TradeSkillFrame and TradeSkillFrame:IsVisible()) then
		atsw_disabled[player_name][atsw_selectedskill]=0;
		ATSW_IsEnabled();
		ATSW_ShowWindow();
		ATSW_HideBlizzardTradeSkillFrame();
		ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_ACTIVATED);
	end
end

ATSWFrame_Show=ATSW_ShowWindow;

function ATSW_CheckForTradeSkillWindow(self, elapsed)
	if(ATSWFrame:IsVisible()) then
		if(atsw_updatedelay>0) then
			atsw_updatedelay=atsw_updatedelay-elapsed;
			if(atsw_updatedelay<=0) then
				ATSWFrame_Update();
				atsw_updatedelay=0;
			end
		end
		ATSW_CheckForRescan();
	end
	if(atsw_processnext==true) then
		atsw_processnext=false;
		ATSW_ProcessNextQueueItem();
	end
	if(atsw_processing==true) then
		if(atsw_processingtimeout~=0) then
			if(atsw_processingtimeout>0) then
				atsw_processingtimeout=atsw_processingtimeout-elapsed;
			else
				atsw_processingtimeout=0;
				ATSWQueueStartStopButton:Enable();
				ATSWQueueDeleteButton:Enable();
				ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
				atsw_processing=false;
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			end
		end
		if(atsw_retry==true) then
			if(atsw_retrydelay<ATSW_MAX_DELAY) then
				atsw_retrydelay=atsw_retrydelay+elapsed;
			else
				atsw_retrydelay=0;
				ATSW_ProcessNextQueueItem();
			end
		end
	end
end

function ATSW_IsEnabled()
	if(IsTradeSkillLinked() or IsTradeSkillGuild()) then
		atsw_iscurrentlyenabled=false;
		return false;
	end
	if((atsw_disabled[player_name][atsw_selectedskill]==0 and not IsShiftKeyDown()) or (atsw_disabled[player_name][atsw_selectedskill]==1 and IsShiftKeyDown())) then
		atsw_iscurrentlyenabled=true;
		return true;
	else
		atsw_iscurrentlyenabled=false;
		return false;
	end
end

function ATSW_IsCurrentlyEnabled()
	return atsw_iscurrentlyenabled;
end

function ATSW_HideBlizzardTradeSkillFrame()
	TradeSkillFrame:SetAlpha(0);
	TradeSkillFrame:ClearAllPoints();
	TradeSkillFrame:SetPoint("TOPLEFT", 0, 900);
end

function ATSW_ShowBlizzardTradeSkillFrame()
	TradeSkillFrame:SetAlpha(1);
	TradeSkillFrame:ClearAllPoints();
end

local process_BAG_UPDATE
local consolidatedEventProcessor=CreateFrame('Frame')
local function consolidatedEventProcess()
	if(process_BAG_UPDATE) then
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateItemList();
		if(atsw_bankopened) then ATSWBank_UpdateBankList() end
		if(ATSWFrame:IsVisible()) then
			local index=GetTradeSkillSelectionIndex()
			if(index>0) then ATSWFrame_SetSelection(index) end
		end
		process_BAG_UPDATE=nil
	end
	return consolidatedEventProcessor:SetScript("OnUpdate", nil)
end

local event_map={}	-- If event is processed by calling just a single function, put it in this table (see bottom of file)
local pattern_SPELL_FAILED_REAGENTS=string.sub(SPELL_FAILED_REAGENTS,1,string.len(SPELL_FAILED_REAGENTS)-2)
local pattern_SPELL_FAILED_REQUIRES_SPELL_FOCUS=string.sub(SPELL_FAILED_REQUIRES_SPELL_FOCUS,1,string.len(SPELL_FAILED_REQUIRES_SPELL_FOCUS)-3)

function ATSWFrame_OnEvent(self, event, ...)
	if(not player_name) then player_name=UnitName("player") end
	local visible=ATSWFrame:IsVisible()
	local process_event=event_map[event]
	if(process_event) then
		process_event()
	elseif(event=="TRADE_SKILL_SHOW") then
		--if(CraftFrame and CraftFrame:IsVisible()) then ATSW_HideWindow(); end
		--atsw_oldmode=false;
		ATSW_GetSelectedSkill();
		if(ATSW_IsEnabled()) then
			local version,build,date=GetBuildInfo();
			local locale=GetLocale();
			if(IsTradeSkillLinked() or (atsw_prescanned[atsw_selectedskill]==build..locale and not IsAltKeyDown())) then
				ATSW_ShowWindow();
			else
				ATSW_InitSlowScan();
			end
		else
			ATSW_ShowBlizzardTradeSkillFrame();
			--HideUIPanel(ATSWFrame);
		end
	elseif(event=="BANKFRAME_OPENED") then
		atsw_bankopened=true;
		ATSWBank_UpdateBankList();
		if(atsw_displayreagentlist==true) then
			ATSWAllReagentList_OpenBankFrame();
		end
		if(ATSWAllReagentListFrame:IsVisible()) then
			ATSWARLFGetFromBankButton:Enable();
		end
	elseif(event=="BANKFRAME_CLOSED") then
		atsw_bankopened=false;
		if(ATSWAllReagentListFrame:IsVisible()) then
			ATSWARLFGetFromBankButton:Disable();
		end
		if(atsw_displayreagentlist==true) then
			ATSWAllReagentList_CloseBankFrame();
		end
	elseif(event=="MERCHANT_SHOW") then
		ATSWMerchant_InsertAutoBuyButton();
		ATSWMerchant_UpdateMerchantList();
		ATSWMerchant_AutoBuy();
	elseif(event=="BAG_UPDATE") then
		if(visible) then
			if(atsw_processing==true) then
				if(#atsw_queue==0) then
					atsw_processingtimeout=-1;
				end
			end
			atsw_retries=0;
			atsw_retrydelay=ATSW_MAX_DELAY;
		end
		process_BAG_UPDATE=true
		consolidatedEventProcessor:SetScript("OnUpdate", consolidatedEventProcess)
	end

	if(not visible) then return	end
	
	if(TradeSkillFrame and TradeSkillFrame:IsVisible() and ATSW_IsCurrentlyEnabled()) then
		ATSW_HideBlizzardTradeSkillFrame();
	end
	if(event=="TRADE_SKILL_UPDATE") then
		--ATSW_DisplayMessage(GetTime().."TRADE_SKILL_UPDATE");
		OpenedSkillListDirty=1
		if(atsw_scans<2) then
			atsw_scans=atsw_scans+1;
			OpenedSkillListRefresh();
			crash_debug("leaving OpenedSkillListRefresh() 3")
			ATSWCreateButton:Disable();
			ATSWQueueButton:Disable();
			ATSWCreateAllButton:Disable();
			ATSWQueueAllButton:Disable();
			ATSWHighlightFrame:Hide();
			if(GetTradeSkillSelectionIndex()>0) then
				ATSWFrame_SetSelection(GetTradeSkillSelectionIndex());
			else
				if(GetNumTradeSkills()>0) then
					ATSWFrame_SetSelection(GetFirstTradeSkill());
					FauxScrollFrame_SetOffset(ATSWListScrollFrame, 0);
				end
				ATSWListScrollFrameScrollBar:SetValue(0);
			end
			if(atsw_updating==false) then
				ATSW_ResetPossibleItemCounts();
				ATSW_CreateSkillListing();
				crash_debug("leaving ATSW_CreateSkillListing() 2")
				ATSWFrame_Update();
			end
		end
	elseif(event=="UNIT_PORTRAIT_UPDATE") then
		local arg1 = (...);
		if(arg1=="player") then
			SetPortraitTexture(ATSWFramePortrait, "player");
		end
	elseif(event=="UPDATE_TRADESKILL_RECAST") then
		ATSWInputBox:SetNumber(GetTradeskillRepeatCount());
	elseif(event=="UNIT_SPELLCAST_STOP" or event=="UNIT_SPELLCAST_CHANNEL_STOP") then
		local arg1 = (...);
		if(arg1=="player") then ATSW_SpellcastStop(); end
	elseif(event=="UNIT_SPELLCAST_START") then
		local arg1 = (...);
		if(arg1=="player") then	ATSW_SpellcastStart(); end
	elseif(event=="UNIT_SPELLCAST_INTERRUPTED") then
		local arg1 = (...);
		if(arg1=="player") then ATSW_SpellcastInterrupted(); end
	elseif(event=="TRAINER_CLOSED") then
		ATSW_ResetPossibleItemCounts();
		ATSW_CreateSkillListing();
		crash_debug("leaving ATSW_CreateSkillListing() 3")
		ATSWFrame_Update()
	elseif(event=="PLAYER_REGEN_ENABLED") then
		atsw_incombat=false;
	elseif(event=="PLAYER_REGEN_DISABLED") then
		atsw_incombat=true;
	elseif(event=="PLAYER_LOGOUT") then
		ATSW_SaveQueue(false);
	elseif(event=="UI_ERROR_MESSAGE") then
		local arg1 = (...);
		if(arg1==INVENTORY_FULL) then
			ATSW_SpellcastInterrupted();
		end
		if(string.find(arg1,pattern_SPELL_FAILED_REAGENTS,1,true)) then
			ATSW_SpellcastInterrupted();
		end
		if(string.find(arg1,pattern_SPELL_FAILED_REQUIRES_SPELL_FOCUS,1,true)) then
			ATSW_SpellcastInterrupted();
		end
	end
end

function ATSW_AdjustFrame()
	crash_debug("entering ATSW_AdjustFrame()")
	--if(atsw_oldmode) then
	--	ATSWHeaderSortButton:Hide();
	--	ATSWInvSlotDropDown:Hide();
	--	ATSWSubClassDropDown:Hide();
	--	ATSWExpandButtonFrame:Hide();
	--	ATSWCreateButton:Hide();
	--	ATSWQueueButton:Hide();
	--	ATSWCreateAllButton:Hide();
	--	ATSWQueueAllButton:Hide();
	--	ATSWDecrementButton:Hide();
	--	ATSWInputBox:Hide();
	--	ATSWIncrementButton:Hide();
	--	ATSWQueueStartStopButton:Hide();
	--	ATSWQueueDeleteButton:Hide();
	--	ATSWReagentsButton:Hide();
	--	ATSWHorizontalBarLeft:Hide();
	--	ATSWHorizontalBarLeft2:Hide();
	--	ATSWHorizontalBarLeftAddon:Hide();
	--	ATSWHorizontalBarLeft2Addon:Hide();
---
--		ATSWEnchantButton:Show();
--		ATSWReagentLabel:SetPoint("TOPLEFT", "ATSWFrame", "TOPLEFT" , 380, -180);
--		ATSWCraftDescription:Show();
--	else
		ATSWHeaderSortButton:Show();
		ATSWInvSlotDropDown:Show();
		ATSWSubClassDropDown:Show();
		ATSWExpandButtonFrame:Show();
		ATSWCreateButton:Show();
		ATSWQueueButton:Show();
		ATSWCreateAllButton:Show();
		ATSWQueueAllButton:Show();
		ATSWDecrementButton:Show();
		ATSWInputBox:Show();
		ATSWIncrementButton:Show();
		ATSWQueueStartStopButton:Show();
		ATSWQueueDeleteButton:Show();
		ATSWReagentsButton:Show();
		ATSWHorizontalBarLeft:Show();
		ATSWHorizontalBarLeft2:Show();
		ATSWHorizontalBarLeftAddon:Show();
		ATSWHorizontalBarLeft2Addon:Show();

		ATSWEnchantButton:Hide();
		ATSWReagentLabel:SetPoint("TOPLEFT", "ATSWFrame", "TOPLEFT" , 380, -136);
		ATSWCraftDescription:Hide();
--	end
	if(IsTradeSkillLinked()) then
		ATSWCreateButton:Disable();
		ATSWCreateAllButton:Disable();
		ATSWDecrementButton:Disable();
		ATSWInputBox:Hide();
		ATSWIncrementButton:Disable();
		ATSWTradeSkillLinkButton:Hide();
		ATSWCreateAllButton:Disable();
		ATSWQueueAllButton:Disable();
		ATSWQueueStartStopButton:Disable();
		ATSWQueueDeleteButton:Disable();
		ATSWReagentsButton:Disable();
	else
		ATSWCreateButton:Enable();
		ATSWCreateAllButton:Enable();
		ATSWDecrementButton:Enable();
		ATSWInputBox:Show();
		ATSWIncrementButton:Enable();
		ATSWTradeSkillLinkButton:Show();
		ATSWCreateAllButton:Enable();
		ATSWQueueAllButton:Enable();
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWReagentsButton:Enable();
	end
end

function ATSW_SortTradeSkills()
	local tradeskills={};
	ExpandTradeSkillSubClass(0);
	local numTradeSkills=GetNumTradeSkills();

	local idx=1
	for i=1,numTradeSkills,1 do
		local skillName, skillType, numAvailable, isExpanded, altVerb = GetTradeSkillInfo(i);
		if(skillType~="header") then
			local skillTypeNumber=0;
			if(skillType=="easy") then skillTypeNumber=1; end
			if(skillType=="medium") then skillTypeNumber=2; end
			if(skillType=="optimal") then skillTypeNumber=3; end
			tradeskills[idx]={name=skillName,id=i,skilltype=skillTypeNumber,altVerb=altVerb};
			idx=idx+1
		end
	end

	wipe(atsw_tradeskillid)
	if(atsw_orderby[player_name][atsw_selectedskill]=="name") then
		table.sort(tradeskills,ATSW_CompareName);
		for i=1,#tradeskills do
			atsw_tradeskillid[i]=tradeskills[i].id
		end
	end
	if(atsw_orderby[player_name][atsw_selectedskill]=="difficulty") then
		table.sort(tradeskills,ATSW_CompareDifficulty);
		for i=1,#tradeskills do
			atsw_tradeskillid[i]=tradeskills[i].id
		end
	end
	atsw_is_sorted=true;
end

function ATSW_CompareName(i,j)
	return string.lower(i.name) < string.lower(j.name);
end

function ATSW_CompareDifficulty(i,j)
	return i.skilltype > j.skilltype
end

function ATSW_OrderBy(order)
	atsw_orderby[player_name][atsw_selectedskill]=order;
	atsw_is_sorted=false;
	ATSW_CreateSkillListing();
	crash_debug("leaving ATSW_CreateSkillListing() 4")
	ATSWFrame_Update();
end

function ATSWFrame_Update()
	if(not ATSWFrame:IsVisible()) then return; end
	if(type(atsw_orderby)~="table") then atsw_orderby={}; end
	if(not atsw_orderby[player_name]) then atsw_orderby[player_name]={}; end
	if(not atsw_orderby[player_name][atsw_selectedskill]) then atsw_orderby[player_name][atsw_selectedskill]="nothing"; end
	--if(atsw_oldmode and atsw_orderby[player_name][atsw_selectedskill]=="nothing") then
	--	atsw_orderby[player_name][atsw_selectedskill]="name";
	--end
	if(atsw_orderby[player_name][atsw_selectedskill]=="name") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(true);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(false);
	elseif(atsw_orderby[player_name][atsw_selectedskill]=="difficulty") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(true);
		ATSWCustomSortButton:SetChecked(false);
	elseif(atsw_orderby[player_name][atsw_selectedskill]=="custom") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(true);
	else
		ATSWHeaderSortButton:SetChecked(true);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(false);
	end
	for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
		_G["ATSWSkill"..i]:Hide();
	end
	if(atsw_orderby[player_name][atsw_selectedskill]=="nothing" or atsw_orderby[player_name][atsw_selectedskill]=="custom") then
		ATSWExpandButtonFrame:Show();
		local numTradeSkills=#atsw_skilllisting
		local skillOffset=FauxScrollFrame_GetOffset(ATSWListScrollFrame);

		if(numTradeSkills==0) then
			ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), GetTradeSkillLine()).." - "..ATSW_VERSION);
			ATSWSkillName:Hide();
			ATSWSkillIcon:Hide();
			ATSWRequirementLabel:Hide();
			ATSWCollapseAllButton:Disable();
			for i=1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
				_G["ATSWReagent"..i]:Hide();
			end
		else
			ATSWSkillName:Show();
			ATSWSkillIcon:Show();
			ATSWCollapseAllButton:Enable();
		end

		FauxScrollFrame_Update(ATSWListScrollFrame, numTradeSkills, ATSW_TRADE_SKILLS_DISPLAYED, ATSW_TRADE_SKILL_HEIGHT, nil, nil, nil, ATSWHighlightFrame, 293, 316);
		ATSWHighlightFrame:Hide();
		local jumped=1;
		for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
			local skillName, skillType, numAvailable, isExpanded;
			local skillIndex;
			repeat
				skillIndex=skillOffset+jumped;
				if(skillIndex>numTradeSkills) then
					skillName=nil;
				else
					skillName = atsw_skilllisting[skillIndex].name;
					skillType = atsw_skilllisting[skillIndex].type;
					isExpanded = atsw_skilllisting[skillIndex].expanded;
				end
				jumped=jumped+1;
			until ((skillName and ATSW_Filter(skillName)==true and ATSW_FilterInvSlot(skillName) and ATSW_FilterSubClass(skillName)) or skillIndex>numTradeSkills or skillType=="header");
			if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
			local skillButton=_G["ATSWSkill"..i];
			if(skillIndex<=numTradeSkills) then
				if(ATSWListScrollFrame:IsVisible()) then
					skillButton:SetWidth(293);
				else
					skillButton:SetWidth(323);
				end
				local color=ATSWTypeColor[skillType];
				if(color) then
					skillButton:SetNormalFontObject(color.font);
				end

				if(atsw_skilllisting[skillIndex] and atsw_skilllisting[skillIndex].id) then
					skillButton:SetID(atsw_skilllisting[skillIndex].id);
					skillButton:Enable();
				else
					skillButton:SetDisabledTexture("");
					skillButton:Disable();
					skillButton:SetText("DELETED: "..skillName);
					skillType="notfound";
				end
				skillButton:Show();
				if(skillType=="header") then
					skillButton:SetText(skillName);
					if(isExpanded) then
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
					else
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					end
					_G["ATSWSkill"..i.."Highlight"]:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
					_G["ATSWSkill"..i]:UnlockHighlight();
				elseif(skillType~="notfound") then
					if(not skillName)then
						return;
					end
					skillButton:SetNormalTexture("");
					_G["ATSWSkill"..i.."Highlight"]:SetTexture("");
					if(atsw_multicount==true) then
						if ( numAvailable == 0 ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailable.."]");
						end
					else
						local numAvailableString=ATSW_GetNumItemsPossibleWithInventory(skillName).."/"..numAvailable;
						if ( numAvailableString == "0/0" ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailableString.."]");
						end
					end

					if(GetTradeSkillSelectionIndex()==atsw_skilllisting[skillIndex].id) then
						ATSWHighlightFrame:SetPoint("TOPLEFT", "ATSWSkill"..i, "TOPLEFT", 0, 0);
						ATSWHighlightFrame:Show();
						ATSWFrame.numAvailable = numAvailable;
						_G["ATSWSkill"..i]:LockHighlight();
					else
						_G["ATSWSkill"..i]:UnlockHighlight();
					end
				end
			else
				skillButton:Hide();
			end
		end
	end
	if(atsw_orderby[player_name][atsw_selectedskill]=="name" or atsw_orderby[player_name][atsw_selectedskill]=="difficulty") then
		ATSWExpandButtonFrame:Hide();
		atsw_updating=true;
		if(atsw_is_sorted==false) then ATSW_SortTradeSkills(); end
		local numTradeSkills=#atsw_tradeskillid
		local skillOffset=FauxScrollFrame_GetOffset(ATSWListScrollFrame);

		if(numTradeSkills==0) then
			ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), GetTradeSkillLine()).." - "..ATSW_VERSION);
			ATSWSkillName:Hide();
			ATSWSkillIcon:Hide();
			ATSWRequirementLabel:Hide();
			ATSWCollapseAllButton:Disable();
			for i=1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
				_G["ATSWReagent"..i]:Hide();
			end
		else
			ATSWSkillName:Show();
			ATSWSkillIcon:Show();
			ATSWCollapseAllButton:Enable();
		end

		FauxScrollFrame_Update(ATSWListScrollFrame, numTradeSkills, ATSW_TRADE_SKILLS_DISPLAYED, ATSW_TRADE_SKILL_HEIGHT, nil, nil, nil, ATSWHighlightFrame, 293, 316);
		ATSWHighlightFrame:Hide();
		local jumped=1;
		for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
			local skillName, skillType, numAvailable, isExpanded, craftSubSpellName;
			local skillIndex;
			repeat
				skillIndex=atsw_tradeskillid[skillOffset+jumped];
				if(skillIndex==nil) then
					skillName=nil;
				else
					skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex);
				end
				jumped=jumped+1;
			until (((skillName and ATSW_Filter(skillName)==true and ATSW_FilterInvSlot(skillName) and ATSW_FilterSubClass(skillName)) or skillIndex==nil) and skillType~="header");
			if(skillIndex) then
				skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex);
				if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
				local skillButton=_G["ATSWSkill"..i];
				if(ATSWListScrollFrame:IsVisible()) then
					skillButton:SetWidth(293);
				else
					skillButton:SetWidth(323);
				end
				local color=ATSWTypeColor[skillType];
				if(color) then
					skillButton:SetNormalFontObject(color.font);
				end

				skillButton:SetID(skillIndex);
				skillButton:Show();
				if(skillType=="header") then
					skillButton:SetText(skillName);
					if(isExpanded) then
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
					else
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					end
					_G["ATSWSkill"..i.."Highlight"]:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
					_G["ATSWSkill"..i]:UnlockHighlight();
				else
					if(not skillName)then
						return;
					end
					skillButton:SetNormalTexture("");
					_G["ATSWSkill"..i.."Highlight"]:SetTexture("");
					if(atsw_multicount==true) then
						if ( numAvailable == 0 ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailable.."]");
						end
					else
						local numAvailableString=ATSW_GetNumItemsPossibleWithInventory(skillName).."/"..numAvailable;
						if ( numAvailableString == "0/0" ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailableString.."]");
						end
					end

					if(GetTradeSkillSelectionIndex()==skillIndex) then
						ATSWHighlightFrame:SetPoint("TOPLEFT", "ATSWSkill"..i, "TOPLEFT", 0, 0);
						ATSWHighlightFrame:Show();
						ATSWFrame.numAvailable = numAvailable;
						_G["ATSWSkill"..i]:LockHighlight();
					else
						_G["ATSWSkill"..i]:UnlockHighlight();
					end
				end
			end
		end
		atsw_updating=false;
	end
end

function ATSWSkillButton_OnClick(self, button)
	if(button=="LeftButton") then
		ATSWFrame_SetSelection(self:GetID(),true, button);
		ATSWFrame_Update();
	end
end

function ATSWFrame_SetSelection(id,wasClicked,button)
	local skillName, skillType, numAvailable, altVerb;
	local listpos=ATSW_GetSkillListingPos(id);
	if(atsw_skilllisting[listpos]) then
		skillName = atsw_skilllisting[listpos].name;
		skillType = atsw_skilllisting[listpos].type;
		altVerb = atsw_skilllisting[listpos].altVerb;
	else
		skillName=nil;
	end
	if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
	if(IsShiftKeyDown() and skillName~=nil and wasClicked~=nil) then
		if(button=="LeftButton") then
			ATSW_AddTradeSkillReagentLinksToChatFrame(skillName);
		end
	end
	if(skillType=="header") then
		ATSWHighlightFrame:Hide();
		if(atsw_skilllisting[listpos].expanded) then
			ATSW_SetHeaderExpanded(id,false);
		else
			ATSW_SetHeaderExpanded(id,true);
		end
		ATSWFrame_Update();
		return;
	end
	ATSWFrame.selectedSkillName=skillName;
	ATSWFrame.selectedSkill = id;
	SelectTradeSkill(id);

	if(GetTradeSkillSelectionIndex()>GetNumTradeSkills())then
		return;
	end
	local color=ATSWTypeColor[skillType];
	if(color) then
		ATSWHighlight:SetVertexColor(color.r, color.g, color.b);
	end

	-- General Info
	local skillLineName, skillLineRank, skillLineMaxRank = GetTradeSkillLine();
	ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), skillLineName).." - "..ATSW_VERSION);
	-- Set statusbar info
	ATSWRankFrameSkillName:SetText(skillLineName);
	ATSWRankFrame:SetStatusBarColor(0.0, 0.0, 1.0, 0.5);
	ATSWRankFrameBackground:SetVertexColor(0.0, 0.0, 0.75, 0.5);
	ATSWRankFrame:SetMinMaxValues(0, skillLineMaxRank);
	ATSWRankFrame:SetValue(skillLineRank);
	ATSWRankFrameSkillRank:SetText(skillLineRank.."/"..skillLineMaxRank);

	ATSWSkillName:SetText(skillName);
	--if(atsw_oldmode and GetCraftDescription(id)) then
	--	ATSWCraftDescription:SetText(GetCraftDescription(id));
	--end
	if(GetTradeSkillCooldown(id)) then
		ATSWSkillCooldown:SetText(COOLDOWN_REMAINING.." "..SecondsToTime(GetTradeSkillCooldown(id)));
	else
		ATSWSkillCooldown:SetText("");
	end
	ATSWSkillIcon:SetNormalTexture(GetTradeSkillIcon(id));
	local minMade,maxMade = GetTradeSkillNumMade(id);
	if(maxMade>1) then
		if(minMade==maxMade) then
			ATSWSkillIconCount:SetText(minMade);
		else
			ATSWSkillIconCount:SetText(minMade.."-"..maxMade);
		end
		if(ATSWSkillIconCount:GetWidth()>39) then
			ATSWSkillIconCount:SetText("~"..floor((minMade + maxMade)/2));
		end
	else
		ATSWSkillIconCount:SetText("");
	end

	local creatable = 1;
	local numReagents = GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
		local reagent = _G["ATSWReagent"..i];
		local name = _G["ATSWReagent"..i.."Name"];
		local count = _G["ATSWReagent"..i.."Count"];
		if(not reagentName or not reagentTexture) then
			reagent:Hide();
		else
			reagent:Show();
			SetItemButtonTexture(reagent, reagentTexture);
			name:SetText(reagentName);
			-- Grayout items
			if(playerReagentCount<reagentCount) then
				SetItemButtonTextureVertexColor(reagent, 0.5, 0.5, 0.5);
				name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			else
				SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
				name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			end
			if(playerReagentCount>=100) then
				playerReagentCount = "*";
			end
			count:SetText(playerReagentCount.." /"..reagentCount);
		end
	end
	local reagentToAnchorTo = numReagents;
	if((numReagents > 0) and (mod(numReagents, 2)==0)) then
		reagentToAnchorTo = reagentToAnchorTo - 1;
	end

	for i=numReagents+1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
		_G["ATSWReagent"..i]:Hide();
	end

	local spellFocus=BuildColoredListString(GetTradeSkillTools(id));
	if(spellFocus) then
		ATSWRequirementLabel:Show();
		ATSWRequirementText:SetText(spellFocus);
	else
		ATSWRequirementLabel:Hide();
		ATSWRequirementText:SetText("");
	end

	if(creatable and not IsTradeSkillLinked()) then
		ATSWCreateButton:Enable();
		ATSWQueueButton:Enable();
		ATSWCreateAllButton:Enable();
		ATSWQueueAllButton:Enable();
		ATSWDecrementButton:Enable();
		ATSWIncrementButton:Enable();
	else
		ATSWCreateButton:Disable();
		ATSWQueueButton:Disable();
		ATSWCreateAllButton:Disable();
		ATSWQueueAllButton:Disable();
		ATSWDecrementButton:Disable();
		ATSWIncrementButton:Disable();
	end

	if(not altVerb) then
		ATSWQueueStartStopButton:Show();
		ATSWQueueDeleteButton:Show();
		ATSWReagentsButton:Show();
		ATSWEnchantButton:Hide();
	else
		ATSWQueueStartStopButton:Hide();
		ATSWQueueDeleteButton:Hide();
		ATSWReagentsButton:Hide();
		ATSWEnchantButton:Show();
	end


	if(FRC_CraftFrame_SetSelection and FRC_TradeSkillFrame_SetSelection) then -- for Fizzwidgets ReagentCost
		--if(atsw_oldmode==false) then
			local ATSW_Orig_TradeSkillFrame_SetSelection=FRC_Orig_TradeSkillFrame_SetSelection;
			FRC_Orig_TradeSkillFrame_SetSelection=ATSW_NOP;
			FRC_TradeSkillFrame_SetSelection(id);
			FRC_Orig_TradeSkillFrame_SetSelection=ATSW_Orig_TradeSkillFrame_SetSelection;
			ATSWReagentLabel:SetText(TradeSkillReagentLabel:GetText());
		--else
		--	local ATSW_Orig_CraftFrame_SetSelection=FRC_Orig_CraftFrame_SetSelection;
		--	FRC_Orig_CraftFrame_SetSelection=ATSW_NOP;
		--	FRC_CraftFrame_SetSelection(id);
		--	FRC_Orig_CraftFrame_SetSelection=ATSW_Orig_CraftFrame_SetSelection;
		--	ATSWReagentLabel:SetText(CraftReagentLabel:GetText());
		--end
	end
end

function ATSWSubClassDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, ATSWSubClassDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 120);
	UIDropDownMenu_SetSelectedID(self, 1);
end

function ATSWSubClassDropDown_OnShow(self)
	UIDropDownMenu_Initialize(self, ATSWSubClassDropDown_Initialize);
	if(atsw_currentsubclassfilter[atsw_selectedskill]==nil or atsw_currentsubclassfilter[atsw_selectedskill]==0) then
		UIDropDownMenu_SetSelectedID(self, 1);
	end
end

function ATSWSubClassDropDown_Initialize()
	ATSWFilterFrame_LoadSubClasses(GetTradeSkillSubClasses());
end

function ATSWFilterFrame_LoadSubClasses(...)
	local info = UIDropDownMenu_CreateInfo();
	info.text = TEXT(ALL_SUBCLASSES);
	info.func = ATSWSubClassDropDownButton_OnClick;
	info.checked = false;
	if(atsw_currentsubclassfilter[atsw_selectedskill] and atsw_currentsubclassfilter[atsw_selectedskill]==0) then info.checked=true; end
	UIDropDownMenu_AddButton(info);

	local checked;
	for i=1, select("#", ...), 1 do
		if (atsw_currentsubclassfilter[atsw_selectedskill] and atsw_currentsubclassfilter[atsw_selectedskill]==0 and select("#", ...)>1) then
			checked = nil;
			UIDropDownMenu_SetText(ATSWSubClassDropDown, TEXT(ALL_SUBCLASSES));
		else
			if(atsw_currentsubclassfilter[atsw_selectedskill] and i==atsw_currentsubclassfilter[atsw_selectedskill]) then
				checked=true;
				UIDropDownMenu_SetText(ATSWSubClassDropDown, select(i, ...));
			else
				checked=false;
			end
		end
		info.text = select(i, ...);
		info.func = ATSWSubClassDropDownButton_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWInvSlotDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, ATSWInvSlotDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 120);
	UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, 1);
end

function ATSWInvSlotDropDown_OnShow(self)
	UIDropDownMenu_Initialize(self, ATSWInvSlotDropDown_Initialize);
	if(atsw_currentinvslotfilter[atsw_selectedskill]==nil or atsw_currentinvslotfilter[atsw_selectedskill]==0) then
		UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, 1);
	end
end

function ATSWInvSlotDropDown_Initialize()
	ATSWFilterFrame_LoadInvSlots(GetTradeSkillInvSlots());
end

function ATSWFilterFrame_LoadInvSlots(...)
	local info = UIDropDownMenu_CreateInfo();
	info.text = TEXT(ALL_INVENTORY_SLOTS);
	info.func = ATSWInvSlotDropDownButton_OnClick;
	info.checked = false;
	if(atsw_currentinvslotfilter[atsw_selectedskill]==0) then info.checked=true; end
	UIDropDownMenu_AddButton(info);

	local checked=false;
	for i=1, select("#", ...), 1 do
		if (atsw_currentinvslotfilter[atsw_selectedskill] and atsw_currentinvslotfilter[atsw_selectedskill]==0 and select("#", ...)>1) then
			checked = false;
			UIDropDownMenu_SetText(ATSWInvSlotDropDown, TEXT(ALL_INVENTORY_SLOTS));
		else
			if(atsw_currentinvslotfilter[atsw_selectedskill] and i==atsw_currentinvslotfilter[atsw_selectedskill]) then
				checked=true;
				UIDropDownMenu_SetText(ATSWInvSlotDropDown, select(i, ...));
			else
				checked=false;
			end
		end
		info.text = select(i, ...);
		info.func = ATSWInvSlotDropDownButton_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWSubClassDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(ATSWSubClassDropDown, self:GetID());
	if(self:GetID()==1) then
		atsw_subclassfilter[atsw_selectedskill]=nil;
		atsw_subclassfiltered[atsw_selectedskill]={};
		atsw_currentsubclassfilter[atsw_selectedskill]=0;
		ATSW_CreateSkillListing();
		crash_debug("leaving ATSW_CreateSkillListing() 5")
		ATSWFrame_Update();
	else
		atsw_subclassfilter[atsw_selectedskill]=self:GetID()-1;
		atsw_currentsubclassfilter[atsw_selectedskill]=atsw_subclassfilter[atsw_selectedskill];
		SetTradeSkillSubClassFilter(self:GetID() - 1, 1, 1);
	end
end

function ATSWInvSlotDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, self:GetID());
	if(self:GetID()==1) then
		atsw_invslotfilter[atsw_selectedskill]=nil;
		atsw_invslotfiltered[atsw_selectedskill]={};
		atsw_currentinvslotfilter[atsw_selectedskill]=0;
		ATSW_CreateSkillListing();
		crash_debug("leaving ATSW_CreateSkillListing() 6")
		ATSWFrame_Update();
	else
		atsw_invslotfilter[atsw_selectedskill]=self:GetID()-1;
		atsw_currentinvslotfilter[atsw_selectedskill]=atsw_invslotfilter[atsw_selectedskill];
		SetTradeSkillInvSlotFilter(self:GetID() - 1, 1, 1);
	end
end

function ATSW_FilterInvSlot(skillName)
	if(atsw_currentinvslotfilter[atsw_selectedskill]==0 or atsw_currentinvslotfilter[atsw_selectedskill]==nil) then
		return true;
	end
	if(atsw_invslotfiltered[atsw_selectedskill][skillName]) then
		return true;
	else
		return false;
	end
end

function ATSW_FilterSubClass(skillName)
	if(atsw_currentsubclassfilter[atsw_selectedskill]==0 or atsw_currentsubclassfilter[atsw_selectedskill]==nil) then
		return true;
	end
	if(atsw_subclassfiltered[atsw_selectedskill][skillName]) then
		return true;
	else
		return false;
	end
end

function ATSWCollapseAllButton_OnClick(self)
	if (self.collapsed) then
		self.collapsed = nil;
		if(atsw_orderby[player_name][atsw_selectedskill]=="custom") then
			if(atsw_customheaders[player_name]) then
				if(atsw_customheaders[player_name][atsw_selectedskill]) then
					for i=1,#atsw_customheaders[player_name][atsw_selectedskill],1 do
						atsw_customheaders[player_name][atsw_selectedskill][i].expanded=true;
					end
				end
			end
			atsw_uncategorizedexpanded=true;
		else
			for i=1,#atsw_tradeskillheaders do
				atsw_tradeskillheaders[i].expanded=true;
			end
		end
	else
		self.collapsed = 1;
		ATSWListScrollFrameScrollBar:SetValue(0);
		if(atsw_orderby[player_name][atsw_selectedskill]=="custom") then
			if(atsw_customheaders[player_name]) then
				if(atsw_customheaders[player_name][atsw_selectedskill]) then
					for i=1,#atsw_customheaders[player_name][atsw_selectedskill],1 do
						atsw_customheaders[player_name][atsw_selectedskill][i].expanded=false;
					end
				end
			end
			atsw_uncategorizedexpanded=false;
		else
			for i=1,#atsw_tradeskillheaders do
				atsw_tradeskillheaders[i].expanded=false;
			end
		end
	end
	ATSW_CreateSkillListing();
	crash_debug("leaving ATSW_CreateSkillListing() 7")
	ATSWFrame_Update();
end

function ATSWFrame_UpdateQueue()
	local jobs=#atsw_queue
	local offset=FauxScrollFrame_GetOffset(ATSWQueueScrollFrame);

	for i=1,4,1 do
		local jobindex=i+offset;
		local queueCount=_G["ATSWQueueItem"..i.."CountText"];
		local queueName=_G["ATSWQueueItem"..i.."NameText"];
		local queueItem=_G["ATSWQueueItem"..i];
		local queueButton=_G["ATSWQueueItem"..i.."DeleteButton"];
		if(atsw_queue[jobindex]) then
			queueCount:SetText(atsw_queue[jobindex].count.."x");
			queueName:SetText(atsw_queue[jobindex].name);
			queueItem.jobindex=jobindex;
			queueButton.jobindex=jobindex;
			queueItem:Show();
			queueButton:Show();
		else
			queueButton:Hide();
			queueItem:Hide();
		end
	end

	FauxScrollFrame_Update(ATSWQueueScrollFrame, jobs, 4, 22);
end

function ATSW_DeleteQueue()
	wipe(atsw_queue)
	ATSW_ResetPossibleItemCounts();
	ATSWInv_UpdateQueuedItemList();
	ATSWFrame_UpdateQueue();
	ATSWFrame_Update();
	ATSWQueueStartStopButton:Enable();
	ATSWQueueDeleteButton:Enable();
	ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
end

function ATSW_SaveQueue(delete)
	if(ATSWFrame:IsVisible()) then
		ATSW_NoteNecessaryItemsForQueue();
		if(atsw_savedqueue[player_name]==nil) then
			atsw_savedqueue[player_name]={};
		end
		atsw_savedqueue[player_name][atsw_displayedgroup]=atsw_queue;
		if(atsw_savednecessaryitems[player_name]==nil) then
			atsw_savednecessaryitems[player_name]={};
		end
		atsw_savednecessaryitems[player_name][atsw_displayedgroup]=atsw_necessaryitems;
		if(delete==true) then
			ATSW_DeleteQueue();
		end
	end
end

function ATSW_RestoreQueue()
	if(ATSWFrame:IsVisible()) then
		if(atsw_savedqueue[player_name]~=nil) then
			if(atsw_savedqueue[player_name][atsw_selectedskill]~=nil) then
				atsw_queue=atsw_savedqueue[player_name][atsw_displayedgroup];
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
				return;
			end
		end
		ATSW_DeleteQueue();
	end
end

function ATSW_DeleteJob(jobindex)
	if(atsw_queue[jobindex]) then
		table.remove(atsw_queue,jobindex);
		if(FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)>0 and FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)+4>#atsw_queue) then
			FauxScrollFrame_SetOffset(ATSWQueueScrollFrame,FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)-1);
		end
		if(atsw_preventupdate==false) then
			ATSW_ResetPossibleItemCounts();
			ATSWInv_UpdateQueuedItemList();
			ATSWFrame_UpdateQueue();
			ATSWFrame_Update();
		end
	end
end

function ATSW_AddJobLL(skillname, num)
	for i=1,#atsw_queue,1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count+num;
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
	local itemlink=ATSW_GetLinkForSkill(skillname);
	tinsert(atsw_queue,{name=skillname,count=num,link=itemlink});
	if(atsw_preventupdate==false) then
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateQueuedItemList();
		ATSWFrame_UpdateQueue();
		ATSWFrame_Update();
	end
end

function ATSW_GetLinkForSkill(skillname)
	for i=1,GetNumTradeSkills() do
		local skill=GetTradeSkillInfo(i)
		if(skill==skillname) then
			return GetTradeSkillItemLink(i);
		end
	end
	return nil;
end

function ATSW_AddJobFirst(skillname, num)
	for i=1,#atsw_queue,1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count+num;
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
	tinsert(atsw_queue,1,{name=skillname,count=num});
	if(atsw_preventupdate==false) then
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateQueuedItemList();
		ATSWFrame_UpdateQueue();
		ATSWFrame_Update();
	end
end

function ATSW_DeleteJobPartial(skillname, num)
	for i=1,#atsw_queue,1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count-num;
			if(atsw_queue[i].count<=0) then ATSW_DeleteJob(i); end
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
end

function ATSW_StartStopProcessing()
	if(atsw_processing==true) then
		ATSW_AddJobFirst(atsw_processingname,1);
		atsw_processing=false;
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
	else
		if(#atsw_queue==0) then return; end
		atsw_processing=true;
		--ATSWQueueStartStopButton:Disable();
		--ATSWQueueDeleteButton:Disable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		ATSW_StartProcessing();
	end
end

function ATSW_Enchant()
	DoCraft(GetCraftSelectionIndex());
end

function ATSW_SetColumnWidth(width, frame)
	frame:SetWidth(width);
  	_G[frame:GetName().."Middle"]:SetWidth(width - 9);
	frame:Disable();
end

function ATSW_StartProcessing()
	atsw_retries=0;
	atsw_retry=false;
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_STOP");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_START");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	ATSW_ProcessNextQueueItem(true);
end

function ATSW_ProcessNextQueueItem(directClick)
	if(#atsw_queue>0 and atsw_retries<ATSW_MAX_RETRIES) then
--		atsw_processingname=atsw_queue[1].name;
--		atsw_working=true;
--		atsw_retries=atsw_retries+1;
--		atsw_retry=true;
--		atsw_retrydelay=0;
--		DoTradeSkill(ATSW_GetTradeSkillID(atsw_queue[1].name),1);
		if(directClick~=nil and directClick==true) then
			ATSW_ProcessIt();
		else
			--ATSWCFItemName:SetText(ATSWCF_TITLE2.."\n"..atsw_queue[1].count.."x "..atsw_queue[1].name);
			--ShowUIPanel(ATSWContinueFrame);
			ATSWQueueStartStopButton:Enable();
			ATSWQueueDeleteButton:Enable();
			ATSWQueueStartStopButton:SetText(ATSW_CONTINUEQUEUE);
		end
	else
		atsw_processingtimeout=5;
	end
end

function ATSW_ProcessIt()
	atsw_processingname=atsw_queue[1].name;
	atsw_working=true;
	atsw_retries=atsw_retries+1;
	atsw_retry=true;
	atsw_processnext=false;
	atsw_retrydelay=0;
	DoTradeSkill(ATSW_GetTradeSkillID(atsw_queue[1].name),atsw_queue[1].count);
end

function ATSW_SpellcastStop()
	atsw_working=false;
	if(atsw_queue[1]) then
		atsw_lastremoved=atsw_processingname;
		ATSW_DeleteJobPartial(atsw_processingname,1);
		ATSWFrame_UpdateQueue();
	end
	if(atsw_processing==true) then
		if(atsw_queue[1]~=nil and atsw_queue[1].name~=atsw_processingname) then
			atsw_processnext=true;
		end
	else
		ATSWQueueStartStopButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		ATSWQueueDeleteButton:Enable();
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	end
end

function ATSW_SpellcastInterrupted()
	if(atsw_processing==true) then
		atsw_working=false;
		--if(atsw_lastremoved) then
		--	ATSW_AddJobFirst(atsw_lastremoved,1);
		--	ATSWFrame_UpdateQueue();
		--end
		--if(atsw_retries<ATSW_MAX_RETRIES) then
		--	atsw_retries=atsw_retries+1;
		--	atsw_retry=true;
		--	atsw_retrydelay=0;
		--	return;
		--end
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		atsw_processing=false;
		atsw_interrupted=true;
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	end
end

function ATSW_SpellcastStart()
	atsw_retry=false;
	atsw_retrydelay=0;
	atsw_processingtimeout=0;
end

function ATSWDBF_OnOK()
	if(#atsw_queue>0) then
		ATSW_ProcessIt();
	end
end

function ATSWDBF_OnAbort()
	ATSW_StartStopProcessing();
end

function ATSW_GetTradeSkillID(skillName)
	local tradeskill_idx=OpenedSkillNameToIdx[skillName]
	if(tradeskill_idx and OpenedSkillList[tradeskill_idx].name==skillName) then
		return OpenedSkillList[tradeskill_idx].id;
	end
	return 0;
end

function ATSW_GetTradeSkillListPos(id)
	for i=1,OpenedSkillListLen do
		if(OpenedSkillList[i].id==id) then
			return i;
		end
	end
	return -1;
end

function ATSW_GetTradeSkillListPosByName(name)
	local tradeskill_idx=OpenedSkillNameToIdx[name]
	if(tradeskill_idx and OpenedSkillList[tradeskill_idx].name==name) then
		return tradeskill_idx;
	end
	return -1;
end

OpenedSkillListRefresh=function()
	crash_debug("entering OpenedSkillListRefresh()")
	if(not OpenedSkillListDirty) then crash_debug("OpenedSkillListRefresh - no work to do") return end
	
	local numTradeSkills=GetNumTradeSkills();
	local OpenedSkillList = OpenedSkillList
	local OpenedSkillListLenNew = 0
	local OpenedSkillNameToIdx = OpenedSkillNameToIdx
	-- wipe old list only if new list is expected to be shorter. Otherwise rewrite it to save time on recreating tables and GC.
	if(numTradeSkills < OpenedSkillListLen) then wipe(OpenedSkillList) end
	
	local currentHeader=0;
	local atsw_oldtradeskillheaders=atsw_tradeskillheaders;
	atsw_tradeskillheaders={}
	
	for i=1,numTradeSkills do
		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i);
		if(skillName~=nil) then
			if(skillType=="header") then
				local oldexpanded=true;
				for j=1,#atsw_oldtradeskillheaders,1 do
					if(atsw_oldtradeskillheaders[j].name==skillName) then
						oldexpanded=atsw_oldtradeskillheaders[j].expanded;
					end
				end
				tinsert(atsw_tradeskillheaders,{name=skillName,id=i,list={},expanded=oldexpanded});
				currentHeader=#atsw_tradeskillheaders;
			else
				if(currentHeader>0) then
					reagentlist={};
					local numReagents = GetTradeSkillNumReagents(i);
					local skillLink = GetTradeSkillItemLink(i);
					local numMade = GetTradeSkillNumMade(i);
					for j=1, numReagents do
						local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(i, j);
						local reagentLink = GetTradeSkillReagentItemLink(i,j);
						if(reagentName) then
							tinsert(reagentlist,{name=reagentName,count=reagentCount,link=reagentLink});
						end
					end
					local recipeLink=GetTradeSkillRecipeLink(i);
					OpenedSkillListLenNew=OpenedSkillListLenNew+1
					local skillData=OpenedSkillList[OpenedSkillListLenNew]
					if(not skillData) then skillData={} OpenedSkillList[OpenedSkillListLenNew]=skillData end
					skillData.name=skillName
					skillData.id=i
					skillData.reagents=reagentlist
					skillData.link=skillLink
					skillData.type=skillType
					skillData.num=numMade
					skillData.recipelink=recipeLink
					OpenedSkillNameToIdx[skillName]=OpenedSkillListLenNew
					tinsert(atsw_tradeskillheaders[currentHeader].list, OpenedSkillListLenNew);
				end
			end
		end
	end
	OpenedSkillListLen=OpenedSkillListLenNew
	OpenedSkillListDirty=nil

	local check=false;
	
	if(atsw_invslotfilter[atsw_selectedskill]~=nil) then
		atsw_invslotfilter[atsw_selectedskill]=nil;
		local filtered_list={}
		atsw_invslotfiltered[atsw_selectedskill]=filtered_list;
		for i=1,OpenedSkillListLen do
			filtered_list[OpenedSkillList[i].name]=1;
		end
		for i=1,#atsw_tradeskillheaders do
			filtered_list[atsw_tradeskillheaders[i].name]=1;
		end
		SetTradeSkillInvSlotFilter(0, 1, 1);
		check=true;
	end

	if(atsw_subclassfilter[atsw_selectedskill]~=nil) then
		atsw_subclassfilter[atsw_selectedskill]=nil;
		local filtered_list={}
		atsw_subclassfiltered[atsw_selectedskill]=filtered_list
		for i=1,OpenedSkillListLen do
			filtered_list[OpenedSkillList[i].name]=1;
		end
		for i=1,#atsw_tradeskillheaders do
			filtered_list[atsw_tradeskillheaders[i].name]=1;
		end
		SetTradeSkillSubClassFilter(0, 1, 1);
		check=true;
	end

	if(check==false) then
		ATSW_CreateSkillListing();
		crash_debug("leaving ATSW_CreateSkillListing() 8")
	end
end

function ATSW_GetSkillListingPos(id)
	for i=1,#atsw_skilllisting do
		if(atsw_skilllisting[i].id==id) then
			return i;
		end
	end
	return -1;
end

ATSW_CreateSkillListing=function()
	crash_debug("entering ATSW_CreateSkillListing()")
	
	wipe(atsw_skilllisting)
	if(atsw_orderby[player_name][atsw_selectedskill]~="custom") then
		for i=1,#atsw_tradeskillheaders do
			local header=atsw_tradeskillheaders[i]
			tinsert(atsw_skilllisting, { type="header", name=header.name, expanded=header.expanded, id=header.id });
			if(header.expanded==true) then
				local list=header.list
				for j=1,#list do
					local skill=OpenedSkillList[list[j]]
					local skillName=skill.name;
					local skillID=skill.id;
					local skillType=skill.type;
					local numMade=skill.num;
					local skillLink=skill.link;
					local recipeLink=skill.recipelink;
					tinsert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink,recipelink=recipeLink});
				end
			end
		end
	else
		local atsw_allskills={};
		for i=1,#atsw_tradeskillheaders do
			for j=1,#atsw_tradeskillheaders[i].list do
				tinsert(atsw_allskills,OpenedSkillList[atsw_tradeskillheaders[i].list[j]].name);
			end
		end
		if(atsw_customheaders[player_name]) then
			if(atsw_customheaders[player_name][atsw_selectedskill]) then
				for i=1,#atsw_customheaders[player_name][atsw_selectedskill] do
					tinsert(atsw_skilllisting,{type="header",name=atsw_customheaders[player_name][atsw_selectedskill][i].name,expanded=atsw_customheaders[player_name][atsw_selectedskill][i].expanded,id=i*1000});
					if(atsw_customsorting[player_name] and atsw_customsorting[player_name][atsw_selectedskill] and atsw_customsorting[player_name][atsw_selectedskill][atsw_customheaders[player_name][atsw_selectedskill][i].name]) then
						for j=1,#atsw_customsorting[player_name][atsw_selectedskill][atsw_customheaders[player_name][atsw_selectedskill][i].name] do
							local skillName=atsw_customsorting[player_name][atsw_selectedskill][atsw_customheaders[player_name][atsw_selectedskill][i].name][j].name;
							local skillID, skillType, numMade, skillLink, recipeLink=ATSW_GetSkillDataFromSkillList(skillName);
							if(atsw_customheaders[player_name][atsw_selectedskill][i].expanded==true) then tinsert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink,recipelink=recipeLink}); end
							for k=1,#atsw_allskills do
								if(atsw_allskills[k]==skillName) then
									table.remove(atsw_allskills,k);
								end
							end
						end
					end
				end
			end
		end
		if(#atsw_allskills>0) then
			tinsert(atsw_skilllisting,{type="header",name=ATSWCS_UNCATEGORIZED,expanded=atsw_uncategorizedexpanded,id=1001});
			if(atsw_uncategorizedexpanded==true) then
				for i=1,#atsw_allskills do
					local skillName=atsw_allskills[i];
					local skillID, skillType, numMade, skillLink=ATSW_GetSkillDataFromSkillList(skillName);
					tinsert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink});
				end
			end
		end
	end
end
aEnv.ATSW_CreateSkillListing=ATSW_CreateSkillListing

function ATSW_GetSkillDataFromSkillList(skillName)
	local tradeskill_idx=OpenedSkillNameToIdx[skillName]
	if(tradeskill_idx) then
		local skill=OpenedSkillList[tradeskill_idx]
		if(skill and skill.name==skillName) then
			local skillID=skill.id;
			local skillType=skill.type;
			local numMade=skill.num;
			local skillLink=skill.link;
			local recipeLink=skill.recipelink;
			return skillID, skillType, numMade, skillLink, recipeLink;
		end
	end
	return nil;
end

function ATSW_SetHeaderExpanded(id,value)
	if(atsw_orderby[player_name][atsw_selectedskill]~="custom") then
		for i=1,#atsw_tradeskillheaders do
			if(atsw_tradeskillheaders[i].id==id) then
				atsw_tradeskillheaders[i].expanded=value;
			end
		end
	else
		if(id==1001) then
			atsw_uncategorizedexpanded=value;
		else
			atsw_customheaders[player_name][atsw_selectedskill][id/1000].expanded=value;
		end
	end
	ATSW_CreateSkillListing();
	crash_debug("leaving ATSW_CreateSkillListing() 10")
end

function ATSW_AddTradeSkillReagentLinksToChatFrame(skillName)
	for i=1,OpenedSkillListLen do
		if(OpenedSkillList[i]) then
			if(OpenedSkillList[i].name==skillName) then
				ChatEdit_InsertLink(OpenedSkillList[i].recipelink);
			end
		end
	end
end

function ATSWFrameIncrement_OnClick()
	if(ATSWInputBox:GetNumber()<100) then
		ATSWInputBox:SetNumber(ATSWInputBox:GetNumber()+1);
	end
end

function ATSWFrameDecrement_OnClick()
	if(ATSWInputBox:GetNumber()>0) then
		ATSWInputBox:SetNumber(ATSWInputBox:GetNumber()-1);
	end
end

function ATSW_GetNumItemsPossible(skillName)
	return ATSW_GetNumItemsPossibleCached(skillName,atsw_tradeskillcountcache);
end

function ATSW_GetNumItemsPossibleCached(skillName,cacheTable)
	if(cacheTable and cacheTable[skillName]) then
		return cacheTable[skillName];
	end
	local atsw_considermerchants_backup=atsw_considermerchants;
	if(atsw_considermerchants==true and ATSW_CheckIfCreatedOnlyWithVendorStuff(skillName)==true) then
		atsw_considermerchants=false;
	end
	local i;
	local temporaryitemlist=atsw_temporaryitemlist;
	for i=1,500 do
		wipe(temporaryitemlist);
		if(ATSW_CheckIfPossible(skillName,i)==false) then
			wipe(temporaryitemlist);
			if(cacheTable) then cacheTable[skillName]=(i-1); end
			atsw_considermerchants=atsw_considermerchants_backup;
			return (i-1);
		end
	end
	atsw_considermerchants=atsw_considermerchants_backup;
	return 0;
end

function ATSW_GetNumItemsPossibleWithInventory(skillName)
	local atsw_considerbank_backup=atsw_considerbank;
	local atsw_consideralts_backup=atsw_consideralts;
	local atsw_considermerchants_backup=atsw_considermerchants;
	atsw_considerbank=false;
	atsw_consideralts=false;
	atsw_considermerchants=false;
	local count=ATSW_GetNumItemsPossibleCached(skillName, atsw_tradeskillcountwithinventorycache);
	atsw_considerbank=atsw_considerbank_backup;
	atsw_consideralts=atsw_consideralts_backup;
	atsw_considermerchants=atsw_considermerchants_backup;
	return count;
end

function ATSW_ToggleReagentFrame()
	if(ATSWReagentFrame:IsVisible()) then
		HideUIPanel(ATSWReagentFrame);
	else
		ATSW_ShowNecessaryReagents();
	end
end

function ATSW_ResetPossibleItemCounts()
	wipe(atsw_tradeskillcountcache)
	wipe(atsw_tradeskillcountwithinventorycache)
end

function ATSW_AddJob(skillName,count)
	wipe(atsw_temporaryitemlist);
	local numMade=1;
	local tradeskill_idx=OpenedSkillNameToIdx[skillName]
	if(tradeskill_idx) then
		local tradeskill=OpenedSkillList[tradeskill_idx]
		if(tradeskill.name==skillName) then
			numMade=tradeskill.num;
		end
	end
	ATSW_AddJobRecursive(skillName,count*numMade,true);
end

function ATSW_AddJobRecursive(skillName,count,firstcall,depth,previousSkill)
	-- Endless recursion is prevented by checking a reagent against the name of the skill in the previous recursion step
	-- This should eliminate any circles with just two elements recursing into eachother (AFAIK that's the only type of circular
	-- recipes available in the game as of patch 2.2)
	-- In addition to that, a depth counter is used to kill the recursion after at most 10 steps, "just in case"
	-- The same mechanism applies to all recursive functions below
	if(depth==nil) then
		depth=10;
	else
		if(depth<=0) then return; end
	end
	if(ATSW_CheckBlacklist(skillName)==false or firstcall==true) then
		local tradeskill_idx=OpenedSkillNameToIdx[skillName]
		if(tradeskill_idx) then
			local tradeskill=OpenedSkillList[tradeskill_idx]
			if(tradeskill.name==skillName) then
				local usagecount=ceil(count/tradeskill.num);
				for j=1,#tradeskill.reagents do
					local reagent=tradeskill.reagents[j]
					local itemcount=ATSW_GetItemCountMinusQueued(reagent.name);
					if(itemcount<0) then itemcount=0; end
					local necessary=reagent.count*usagecount;
					if(itemcount<necessary and reagent.name~=previousSkill) then
						local missing=necessary-itemcount;
						ATSW_AddJobRecursive(reagent.name,missing,false,depth-1,skillName);
					end
				end
				ATSW_AddJobLL(skillName,usagecount);
			end
		end
	end
end

function ATSW_CheckIfPossible(skillName, count, depth, previousSkill)
	if(depth==nil) then
		depth=10;
	else
		if(depth<=0) then return; end
	end

	-- local cacheReagent, cacheNameToId=DCTS_GetCache()
	-- local cacheReagentIndexMaxReagents=DCTS_cacheReagentIndexMaxReagents
	
	local tradeskill=OpenedSkillList[OpenedSkillNameToIdx[skillName]]
	if(not tradeskill) then
		OpenedSkillListRefresh()
		crash_debug("leaving OpenedSkillListRefresh() manual")
		tradeskill=OpenedSkillList[OpenedSkillNameToIdx[skillName]]
	end
	
	if(tradeskill and tradeskill.name==skillName) then
		local reagents=tradeskill.reagents
		for j=1,#reagents do
			local usagecount=count;
			local reagent=reagents[j]
			local reagent_name=reagent.name
			local reagent_making_skill=OpenedSkillList[OpenedSkillNameToIdx[reagent_name]]
			if(reagent_making_skill and reagent_making_skill.name==reagent_name) then
				usagecount=ceil(count/reagent_making_skill.num);
			end
			local itemcount=ATSW_GetItemCountMinusQueuedAndTemporary(reagent_name);
			local necessary=reagent.count*usagecount;
			if(itemcount>=necessary) then
				ATSW_TemporaryUseItem(reagent_name,necessary);
			else
				if(reagent_name~=previousSkill) then
					local missing=necessary-itemcount;
					local response=ATSW_CheckIfPossible(reagent_name,missing,depth-1,skillName);
					if(response==false) then return false; end
				end
			end
		end
		return true;
	end
	return false;
end

function ATSW_CheckIfCreatedOnlyWithVendorStuff(skillName,depth,previousSkill)
	if(depth==nil) then
		depth=10;
	else
		if(depth<=0) then return; end
	end
	local tradeskill_idx=OpenedSkillNameToIdx[skillName]
	if(tradeskill_idx) then
		local tradeskill=OpenedSkillList[tradeskill_idx]
		if(tradeskill and tradeskill.name==skillName) then
			for j=1,#tradeskill.reagents do
				local reagent=tradeskill.reagents[j]
				if(reagent.name~=previousSkill) then
					local response=ATSW_CheckIfCreatedOnlyWithVendorStuff(reagent.name,depth-1,skillName);
					if(response==false) then return false; end
				end
			end
			return true;
		end
	end
	return ATSWMerchant_CheckIfAvailable(skillName);
end

function ATSW_NoteMissingItems(skillName,count,depth,previousSkill)
	if(depth==nil) then
		depth=10;
	else
		if(depth<=0) then return; end
	end
	if(ATSW_CheckBlacklist(skillName)==false) then
		local tradeskill_idx=OpenedSkillNameToIdx[skillName]
		if(tradeskill_idx) then
			local tradeskill=OpenedSkillList[tradeskill_idx]
			if(tradeskill.name==skillName) then
				for j=1,#tradeskill.reagents do
					local reagent=tradeskill.reagents[j]
					local itemcount=ATSW_GetItemCountMinusQueuedAndTemporary(reagent.name);
					local necessary=reagent.count*count;
					if(itemcount>=necessary) then
						ATSW_TemporaryUseItem(reagent.name,necessary);
					else
						if(reagent.name~=previousSkill) then
							local missing=necessary-itemcount;
							ATSW_NoteMissingItems(reagent.name,missing,depth-1,skillName);
						end
					end
				end
				return;
			end
		end
	end
	for i=1,#atsw_missingitems do
		if(atsw_missingitems[i]) then
			if(atsw_missingitems[i].name==skillName) then
				atsw_missingitems[i].cnt=atsw_missingitems[i].cnt+count;
				return;
			end
		end
	end
	tinsert(atsw_missingitems,{name=skillName,cnt=count});
end

function ATSW_OutputMissingItems(skillName,count)
	ATSW_DisplayMessage(ATSW_ITEMSMISSING1..count.."x '"..skillName.."'"..ATSW_ITEMSMISSING2);
	for i=1,#atsw_missingitems do
		ATSW_DisplayMessage(atsw_missingitems[i].cnt.."x '"..atsw_missingitems[i].name.."'");
	end
end

function ATSW_NoteNecessaryItems(skillName,count,itemLink)
	local tradeskill_idx=OpenedSkillNameToIdx[skillName]
	if(tradeskill_idx) then
		local tradeskill=OpenedSkillList[tradeskill_idx]
		if(tradeskill.name==skillName) then
			for j=1,#tradeskill.reagents do
				local reagent=tradeskill.reagents[j]
				local necessary=reagent.count*count;
				local found=false;
				for x=1,#atsw_necessaryitems do
					if(atsw_necessaryitems[x]) then
						if(atsw_necessaryitems[x].name==reagent.name) then
							atsw_necessaryitems[x].cnt=atsw_necessaryitems[x].cnt+necessary;
							found=true;
							break;
						end
					end
				end
				if(found==false) then
					tinsert(atsw_necessaryitems,{name=reagent.name,cnt=necessary,link=reagent.link});
				end
			end
			return;
		end
	end
end

function ATSW_NoteNecessaryItemsForQueue()
	wipe(atsw_necessaryitems)
	for i=1,#atsw_queue do
		ATSW_NoteNecessaryItems(atsw_queue[i].name,atsw_queue[i].count,nil);
	end
	ATSW_FilterNecessaryItems();
end

function ATSW_FilterNecessaryItems()
	for i=1,#atsw_necessaryitems do
		for k=1,#atsw_queue do
			if(atsw_necessaryitems[i].name==atsw_queue[k].name) then
				atsw_necessaryitems[i].cnt=atsw_necessaryitems[i].cnt-atsw_queue[k].count;
			end
		end
	end
	for i=#atsw_necessaryitems,1,-1 do
		if(atsw_necessaryitems[i].cnt<=0) then
			table.remove(atsw_necessaryitems,i);
		end
	end
end

function ATSW_NoteNecessaryItemsForTradeskill(skillName,skillCount)
	local atsw_queue_backup=atsw_queue;
	atsw_preventupdate=true;
	atsw_queue={};
	ATSW_AddJob(skillName,skillCount);
	ATSW_NoteNecessaryItemsForQueue();
	atsw_queue=atsw_queue_backup;
	atsw_preventupdate=false;
end

function ATSW_ShowNecessaryReagents()
	ATSW_NoteNecessaryItemsForQueue();
	for i=1,20,1 do
		local count=_G["ATSWRFReagent"..i.."Count"];
		local item=_G["ATSWRFReagent"..i.."Item"];
		local inv=_G["ATSWRFReagent"..i.."Inventory"];
		local bank=_G["ATSWRFReagent"..i.."Bank"];
		local merchant=_G["ATSWRFReagent"..i.."Merchant"];
		local alt=_G["ATSWRFReagent"..i.."Alt"];
		local missing=_G["ATSWRFReagent"..i.."Missing"];
		if(atsw_necessaryitems[i]) then
			local items_inventory=ATSWInv_GetItemCount(atsw_necessaryitems[i].name);
			local items_bank=ATSWBank_GetItemCount(atsw_necessaryitems[i].name);
			local items_alt=ATSWAlt_GetItemCount(atsw_necessaryitems[i].name);
			local items_missing=items_inventory+items_bank+items_alt-atsw_necessaryitems[i].cnt;
			local items_merchant=ATSWMerchant_CheckIfAvailable(atsw_necessaryitems[i].name);
			count:SetText(atsw_necessaryitems[i].cnt.."x");
			count:Disable();
			count:Show();
			item:SetText("["..atsw_necessaryitems[i].name.."]");
			item.link=atsw_necessaryitems[i].link;
			item:Show();
			if(items_inventory>=atsw_necessaryitems[i].cnt) then items_inventory="|cff00ff00"..items_inventory.."|r"; else items_inventory="|cffff0000"..items_inventory.."|r"; end
			inv:SetText(items_inventory);
			inv:Disable();
			inv:Show();
			if(items_bank>=atsw_necessaryitems[i].cnt) then items_bank="|cff00ff00"..items_bank.."|r"; else items_bank="|cffff0000"..items_bank.."|r"; end
			bank:SetText(items_bank);
			bank:Disable();
			bank:Show();
			merchant:SetText("X");
			merchant:Disable();
			if(items_merchant==true) then
				merchant:Show();
			else
				merchant:Hide();
			end
			if(items_alt>0) then
				alt:Enable();
				alt.itemname=atsw_necessaryitems[i].name;
			else
				alt:Disable();
			end
			if(items_alt>=atsw_necessaryitems[i].cnt) then items_alt="|cff00ff00"..items_alt.."|r"; else items_alt="|cffff0000"..items_alt.."|r"; end
			alt:SetText(items_alt);
			alt:Show();
			if(items_missing>=0) then
				missing:SetText("|cff00ff00".."+"..items_missing.."|r");
			else
				missing:SetText("|cffff0000"..items_missing.."|r");
			end
			missing:Disable();
			missing:Show();
		else
			count:Hide();
			item:Hide();
			inv:Hide();
			bank:Hide();
			merchant:Hide();
			alt:Hide();
			missing:Hide();
		end
	end
	ShowUIPanel(ATSWReagentFrame);
end

function ATSWItemButton_OnEnter(self)
    if(self.link) then
    	GameTooltip:SetOwner(self, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT",self:GetName(),"TOPLEFT");
	GameTooltip:SetHyperlink(string.gsub(self.link, "|c(%x+)|H(item:%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r", "%2"));
        GameTooltip:Show();
    end
end

function ATSWItemButton_OnLeave()
	GameTooltip:Hide();
end

function ATSW_TemporaryUseItem(itemname,count)
	if(atsw_temporaryitemlist[itemname]) then
		atsw_temporaryitemlist[itemname]=atsw_temporaryitemlist[itemname]+count;
	else
		atsw_temporaryitemlist[itemname]=count;
	end
end

function ATSW_CheckBlacklist(itemname)
	for i=1,#atsw_blacklist do
		if(atsw_blacklist[i]) then
			if(atsw_blacklist[i]==itemname) then return true; end
		end
	end
	return false;
end

function ATSW_UpdateFilter(filtertext)
	atsw_filter=filtertext;
	ATSWFrame_Update();
end

function ATSW_Filter(skillname)
	if(skillname==nil) then return false; end
	if(skillname=="") then return true; end
	local parameters={};
	if(atsw_onlycreatable) then
		local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
		if(possible<=0) then
			return false;
		end
	end
	for w in string.gmatch(atsw_filter, ":[^:]*") do
		local _, _, param_name, param_value=string.find(w, ":(%a+)%s([^:]*)");
		if(param_name~=nil) then _, _, param_name=string.find(param_name,"^%s*(.-)%s*$"); end
		if(param_value~=nil) then _, _, param_value=string.find(param_value,"^%s*(.-)%s*$"); end
		if(param_name~=nil) then
			tinsert(parameters,{name=param_name,value=param_value});
		end
	end
	local _, _, searchstring=string.find(atsw_filter,"^([^:]*):?");
	if(searchstring~=nil) then
		_, _, searchstring=string.find(searchstring,"^%s*(.-)%s*$");
		tinsert(parameters,1,{name="name",value=searchstring});
	end
	for i=1,#parameters do
		if(parameters[i].name=="name") then
			if(string.find(string.lower(skillname),".-"..string.lower(parameters[i].value)..".-")==nil) then
				return false;
			end
		end
		if(parameters[i].name=="reagent") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local found=false;
				for j=1,#OpenedSkillList[index].reagents do
					if(string.find(string.lower(OpenedSkillList[index].reagents[j].name),".-"..string.lower(parameters[i].value)..".-")~=nil) then
						found=true;
					end
				end
				if(found==false) then return false; end
			else
				return false;
			end
		end
		if(parameters[i].name=="minlevel") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local level=ATSW_GetItemMinLevel(OpenedSkillList[index].id);
				if(tonumber(parameters[i].value,10)==nil or level==0 or level<tonumber(parameters[i].value,10)) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="maxlevel") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local level=ATSW_GetItemMinLevel(OpenedSkillList[index].id);
				if(tonumber(parameters[i].value,10)==nil or level==0 or level>tonumber(parameters[i].value,10)) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="minrarity") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local rarity=ATSW_GetItemRarity(OpenedSkillList[index].id);
				local reference=ATSWRarityNames[parameters[i].value];
				if(reference==nil or rarity==0 or rarity<reference) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="maxrarity") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local rarity=ATSW_GetItemRarity(OpenedSkillList[index].id);
				local reference=ATSWRarityNames[parameters[i].value];
				if(reference==nil or rarity==0 or rarity>reference) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="minpossible") then
			local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible<tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="maxpossible") then
			local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible>tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="minpossibletotal") then
			local possible=ATSW_GetNumItemsPossible(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible<tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="maxpossibletotal") then
			local possible=ATSW_GetNumItemsPossible(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible>tonumber(parameters[i].value,10)) then
				return false;
			end
		end
	end
	return true;
end

function ATSW_GetItemMinLevel(tradeskillid)
	local product_link=GetTradeSkillItemLink(tonumber(tradeskillid,10))
	local _, _, _, _, itemMinLevel=GetItemInfo(product_link)
	return itemMinLevel or 0
end

function ATSW_GetItemRarity(tradeskillid)
	local product_link=GetTradeSkillItemLink(tonumber(tradeskillid,10))
	local _, _, itemRarity=GetItemInfo(product_link)
	return itemRarity or 0
end

function ATSW_Test()
	local stats=GetTradeSkillItemStats(3);
	ATSW_DisplayMessage(stats);
end

function ATSW_ToggleOptionsFrame()
	if(ATSWOptionsFrame:IsVisible()) then
		HideUIPanel(ATSWOptionsFrame);
	else
		ATSWOFUnifiedCounterButton:SetChecked(atsw_multicount);
		ATSWOFSeparateCounterButton:SetChecked(not atsw_multicount);
		ATSWOFIncludeBankButton:SetChecked(atsw_considerbank);
		ATSWOFIncludeAltsButton:SetChecked(atsw_consideralts);
		ATSWOFIncludeMerchantsButton:SetChecked(atsw_considermerchants);
		ATSWOFAutoBuyButton:SetChecked(atsw_autobuy);
		ATSWOFTooltipButton:SetChecked(atsw_recipetooltip);
		ATSWOFShoppingListButton:SetChecked(atsw_displayshoppinglist)
		ATSWOFReagentListButton:SetChecked(atsw_displayreagentlist);
		ShowUIPanel(ATSWOptionsFrame);
	end
end

function ATSW_ToggleCSFrame()
	return ShowUIPanel(ATSWCSFrame);
end

-- tooltip functions

atsw_recipetooltip=true;

function ATSW_DisplayTradeskillTooltip(self)
	if(atsw_recipetooltip==false) then return; end
	ATSWTradeskillTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",-300);
	ATSWTradeskillTooltip:SetBackdropColor(0,0,0,1);

	local tradeskillid=self:GetID();
	local skillName, skillType, numAvailable;
	local listpos=ATSW_GetSkillListingPos(tradeskillid);
	if(atsw_skilllisting[listpos]) then
		skillName = atsw_skilllisting[listpos].name;
		skillType = atsw_skilllisting[listpos].type;
	else
		skillName=nil;
		akillType=nil;
	end

	if(skillName and skillType ~= "header") then
		ATSWTradeskillTooltip:AddLine(skillName);
		local color=ATSWTypeColor[skillType];
		if(color) then
			ATSWTradeskillTooltipTextLeft1:SetVertexColor(color.r, color.g, color.b);
		end
		ATSWTradeskillTooltip:AddLine(ATSW_GetNumItemsPossibleWithInventory(skillName)..ATSW_TOOLTIP_PRODUCABLE);
		ATSWTradeskillTooltipTextLeft2:SetVertexColor(1, 1, 1);
		ATSWTradeskillTooltip:AddLine(" ");
		ATSWTradeskillTooltip:AddLine(ATSW_TOOLTIP_NECESSARY);

		ATSW_NoteNecessaryItemsForTradeskill(skillName,1);
		for i=1,20,1 do
			if(atsw_necessaryitems[i]) then
				local items_inventory=ATSWInv_GetItemCount(atsw_necessaryitems[i].name);
				local items_bank=ATSWBank_GetItemCount(atsw_necessaryitems[i].name);
				local items_alt=ATSWAlt_GetItemCount(atsw_necessaryitems[i].name);
				local items_missing=items_inventory+items_bank+items_alt-atsw_necessaryitems[i].cnt;
				local items_merchant="";
				if(ATSWMerchant_CheckIfAvailable(atsw_necessaryitems[i].name)==true) then
					items_merchant=ATSW_TOOLTIP_BUYABLE;
				end
				ATSWTradeskillTooltip:AddLine(atsw_necessaryitems[i].cnt.."x "..atsw_necessaryitems[i].name.." ("..items_inventory.." / "..items_bank.." / "..items_alt..")"..items_merchant);
				local _, _, itemRarity=GetItemInfo(atsw_necessaryitems[i].link)
				_G["ATSWTradeskillTooltipTextLeft"..(4+i)]:SetVertexColor(GetItemQualityColor(itemRarity));
			end
		end
		ATSWTradeskillTooltip:AddLine(ATSW_TOOLTIP_LEGEND);

		ATSWTradeskillTooltip:Show();
	end
end

atsw_considerbank=false;
atsw_consideralts=false;
atsw_considermerchants=false;
atsw_multicount=true;

function ATSW_GetItemCountMinusQueuedAndTemporary(itemname)
	if(atsw_temporaryitemlist[itemname]) then
		return ATSW_GetItemCountMinusQueued(itemname)-atsw_temporaryitemlist[itemname];
	else
		return ATSW_GetItemCountMinusQueued(itemname);
	end
end

function ATSW_GetItemCountMinusQueued(itemname)
	local getitemcount=ATSWInv_GetItemCount(itemname);
	if(atsw_considerbank==true) then
		getitemcount=getitemcount+ATSWBank_GetItemCount(itemname);
	end
	if(atsw_considermerchants==true) then
		if(atsw_merchantlist[itemname]) then
			getitemcount=getitemcount+99999;
		end
	end
	if(atsw_consideralts==true) then
		getitemcount=getitemcount+ATSWAlt_GetItemCount(itemname);
	end
	if(atsw_queueditemlist[itemname]) then
		return getitemcount-atsw_queueditemlist[itemname];
	else
		return getitemcount;
	end
end

-- inventory functions

function ATSWInv_GetItemName(bag, slot)
	local link = GetContainerItemLink(bag, slot);
	if(link) then
    	local _,_,name = string.find(link, "^.*%[(.*)%].*$");
    	return name;
 	else
    	return nil;
    end
end

function ATSWInv_UpdateItemList()
	if(atsw_incombat==true) then return; end
	local realm_data=atsw_itemlist[player_realm]
	if(not realm_data) then
		realm_data={}
		atsw_itemlist[player_realm]=realm_data
	end
	local player_data=realm_data[player_name]
	if(player_data) then
		wipe(player_data)
	else
		player_data={}
		realm_data[player_name]=player_data
	end
	for container=0, NUM_BAG_FRAMES do
		for slot=1, GetContainerNumSlots(container) do
			local itemname=ATSWInv_GetItemName(container,slot);
			if(itemname and not player_data[itemname]) then
				player_data[itemname]=GetItemCount(itemname)
			end
		end
	end
	if(ATSWFrame:IsVisible()) then ATSWFrame_Update(); end
end

function ATSWInv_GetItemCount(itemname)
	local data=atsw_itemlist[player_realm]
	if(data) then
		data=data[player_name]
		if(data) then
			return data[itemname] or 0
		end
	end
	return 0
end

function ATSWInv_UpdateQueuedItemList()
	wipe(atsw_queueditemlist)
	for i=1,#atsw_queue do
		local tradeskill_idx=OpenedSkillNameToIdx[atsw_queue[i].name]
		if(tradeskill_idx) then
			local tradeskill=OpenedSkillList[tradeskill_idx]
			if(tradeskill.name==atsw_queue[i].name) then
				for k=1,#tradeskill.reagents do
					local reagent=tradeskill.reagents[k]
					if(reagent) then
						if(atsw_queueditemlist[reagent.name]) then
							atsw_queueditemlist[reagent.name]=atsw_queueditemlist[reagent.name]+reagent.count*atsw_queue[i].count;
						else
							atsw_queueditemlist[reagent.name]=reagent.count*atsw_queue[i].count;
							--table.setn(atsw_queueditemlist,table.getn(atsw_queueditemlist)+1);
						end
					end
				end
			end
		end
	end
end

function ATSWInv_FindBagForItem(name, count)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(name);
	if(itemName==nil) then return; end
	local possiblecontainer=nil;
	for container=0, 4, 1 do
		for slot=1, GetContainerNumSlots(container), 1 do
			local bagitemname=ATSWInv_GetItemName(container,slot);
			if(bagitemname) then
				if(bagitemname==name) then
					local _, itemcount, locked=GetContainerItemInfo(container, slot);
					local freeslots=itemStackCount-itemcount;
					if(freeslots>=count and locked==nil) then
						return container;
					end
				end
			else
				if(possiblecontainer==nil) then
					possiblecontainer=container;
				end
			end
		end
	end
	return possiblecontainer;
end


-- bank functions

atsw_bankitemlist={};

function ATSWBank_UpdateBankList()
	if(atsw_bankopened==true) then
		if(not atsw_bankitemlist[player_realm]) then
			atsw_bankitemlist[player_realm]={};
		end
		atsw_bankitemlist[player_realm][player_name]={};
		for slot=1, 28, 1 do
			local name=ATSWInv_GetItemName(BANK_CONTAINER,slot);
			if(name) then
				local icon, count = GetContainerItemInfo(BANK_CONTAINER, slot);
				ATSWBank_AddToBankList(name,count);
			end
		end
		for container=5, 12, 1 do
			for slot=1, GetContainerNumSlots(container), 1 do
				local name=ATSWInv_GetItemName(container,slot);
				if(name) then
					local icon, count = GetContainerItemInfo(container, slot);
					ATSWBank_AddToBankList(name,count);
				end
			end
		end
		ATSW_ResetPossibleItemCounts();
	end
end

function ATSWBank_AddToBankList(name,count)
	if(not atsw_bankitemlist[player_realm]) then
		atsw_bankitemlist[player_realm]={};
	end
	if(not atsw_bankitemlist[player_realm][player_name]) then
		atsw_bankitemlist[player_realm][player_name]={};
	end
	if(atsw_bankitemlist[player_realm][player_name][name]) then
		atsw_bankitemlist[player_realm][player_name][name]=atsw_bankitemlist[player_realm][player_name][name]+count;
	else
		atsw_bankitemlist[player_realm][player_name][name]=count;
	end
end

function ATSWBank_GetItemCount(name)
	local data=atsw_bankitemlist[player_realm]
	if(data) then
		data=data[player_name]
		if(data) then return data[name] or 0 end
	end
	return 0
end

function ATSWBank_FetchItemsFromBank(reqname, reqcount)
	if(atsw_bankopened==true) then
		for slot=1, 28, 1 do
			local name=ATSWInv_GetItemName(BANK_CONTAINER,slot);
			if(name and name==reqname) then
				local icon, count = GetContainerItemInfo(BANK_CONTAINER, slot);
				local fetchcount=reqcount;
				if(reqcount>count) then fetchcount=count; end
				if(fetchcount>0) then
					ATSWBankFetchItem(name, BANK_CONTAINER, slot, fetchcount, count);
					reqcount=reqcount-fetchcount;
				end
			end
		end
		for container=5, 11, 1 do
			for slot=1, GetContainerNumSlots(container), 1 do
				local name=ATSWInv_GetItemName(container,slot);
				if(name and name==reqname) then
					local icon, count = GetContainerItemInfo(container, slot);
					local fetchcount=reqcount;
					if(reqcount>count) then fetchcount=count; end
					if(fetchcount>0) then
						ATSWBankFetchItem(name, container, slot, fetchcount, count);
						reqcount=reqcount-fetchcount;
					end
				end
			end
		end
	end
end

function ATSWBankFetchItem(name, bag, slot, reqcount, totalcount)
	ClearCursor();
	if(totalcount==1 or reqcount==totalcount) then
		PickupContainerItem(bag, slot);
	else
		SplitContainerItem(bag, slot, reqcount);
	end
	local container=ATSWInv_FindBagForItem(name, reqcount);
	if(container==nil or container==0) then PutItemInBackpack(); end
	if(container==1) then PutItemInBag(20); end
	if(container==2) then PutItemInBag(21); end
	if(container==3) then PutItemInBag(22); end
	if(container==4) then PutItemInBag(23); end
end

-- alternative character functions
atsw_playernames={}	-- Filled once on VARIABLES_LOADED below

function ATSWAlt_GetItemCount(name, player)
	return ATSWAlt_GetItemCountInInventory(name, player)+ATSWAlt_GetItemCountInBank(name, player);
end

function ATSWAlt_GetItemCountInInventory(name, player)
	local itemcount=0;
	if(atsw_itemlist[player_realm]) then
		for i=1,#atsw_playernames do
			if(atsw_itemlist[player_realm][atsw_playernames[i]] and (player==atsw_playernames[i] or player==nil)) then
				if(atsw_itemlist[player_realm][atsw_playernames[i]][name]) then
					itemcount=itemcount+atsw_itemlist[player_realm][atsw_playernames[i]][name];
				end
			end
		end
	end
	return itemcount;
end

function ATSWAlt_GetItemCountInBank(name, player)
	local itemcount=0;
	if(atsw_bankitemlist[player_realm]) then
		for i=1,#atsw_playernames do
			if(atsw_bankitemlist[player_realm][atsw_playernames[i]] and (player==atsw_playernames[i] or player==nil)) then
				if(atsw_bankitemlist[player_realm][atsw_playernames[i]][name]) then
					itemcount=itemcount+atsw_bankitemlist[player_realm][atsw_playernames[i]][name];
				end
			end
		end
	end
	return itemcount;
end

function ATSWAlt_GetItemLocation(name)
	ATSW_DisplayMessage(ATSW_ALTLIST1..name..ATSW_ALTLIST2);
	if(atsw_itemlist[player_realm]) then
		for i=1,#atsw_playernames do
			if(atsw_itemlist[player_realm][atsw_playernames[i]]) then
				if(atsw_itemlist[player_realm][atsw_playernames[i]][name]) then
					ATSW_DisplayMessage(atsw_itemlist[player_realm][atsw_playernames[i]][name].."x "..ATSW_ALTLIST3..atsw_playernames[i]);
				end
			end
		end
	end
	if(atsw_bankitemlist[player_realm]) then
		for i=1,#atsw_playernames do
			if(atsw_bankitemlist[player_realm][atsw_playernames[i]]) then
				if(atsw_bankitemlist[player_realm][atsw_playernames[i]][name]) then
					ATSW_DisplayMessage(atsw_bankitemlist[player_realm][atsw_playernames[i]][name].."x "..ATSW_ALTLIST4..atsw_playernames[i]);
				end
			end
		end
	end
end

-- auction functions

atsw_displayshoppinglist=true;

function ATSWAuction_ShowShoppingList()
	if(AuctionFrame:IsVisible() and ATSWAuction_UpdateReagentList()>0 and atsw_displayshoppinglist) then
		ATSWShoppingListFrame:Show();
		ATSWShoppingListFrame:SetPoint("TOPLEFT","AuctionFrame","TOPLEFT",353,-436);
		ATSW_NoteNecessaryItemsForQueue();
		ATSWAuction_UpdateReagentList();
	end
end

function ATSWAuction_HideShoppingList()
	ATSWShoppingListFrame:Hide();
end

function ATSWAuction_UpdateReagentList()
	local necessary={};
	local charname, skillname, skillarrays, k, v;
	if(atsw_savednecessaryitems) then
		for charname, skillarrays in pairs(atsw_savednecessaryitems) do
			if(skillarrays) then
				for skillname, necessaryitems in pairs(skillarrays) do
					for k, v in pairs(necessaryitems) do
						tinsert(necessary, {name=v.name,count=v.cnt,link=v.link});
					end
				end
			end
		end
	end
	local reagents=#necessary;
	local offset=FauxScrollFrame_GetOffset(ATSWSLScrollFrame);
	for i=1,5 do
		local count=_G["ATSWSLFReagent"..i.."Count"];
		local item=_G["ATSWSLFReagent"..i.."Item"];
		local inv=_G["ATSWSLFReagent"..i.."Inventory"];
		local bank=_G["ATSWSLFReagent"..i.."Bank"];
		local merchant=_G["ATSWSLFReagent"..i.."Merchant"];
		local alt=_G["ATSWSLFReagent"..i.."Alt"];
		local missing=_G["ATSWSLFReagent"..i.."Missing"];
		if(necessary[offset+i]) then
			local items_inventory=ATSWInv_GetItemCount(necessary[offset+i].name);
			local items_bank=ATSWBank_GetItemCount(necessary[offset+i].name);
			local items_alt=ATSWAlt_GetItemCount(necessary[offset+i].name);
			local items_missing=items_inventory+items_bank+items_alt-necessary[offset+i].count;
			local items_merchant=ATSWMerchant_CheckIfAvailable(necessary[offset+i].name);
			count:SetText(necessary[offset+i].count.."x");
			count:Disable();
			count:Show();
			item:SetText("["..necessary[offset+i].name.."]");
			item.link=necessary[offset+i].link;
			item.itemname=necessary[offset+i].name;
			item:Show();
			if(items_inventory>=necessary[offset+i].count) then items_inventory="|cff00ff00"..items_inventory.."|r"; else items_inventory="|cffff0000"..items_inventory.."|r"; end
			inv:SetText(items_inventory);
			inv:Disable();
			inv:Show();
			if(items_bank>=necessary[offset+i].count) then items_bank="|cff00ff00"..items_bank.."|r"; else items_bank="|cffff0000"..items_bank.."|r"; end
			bank:SetText(items_bank);
			bank:Disable();
			bank:Show();
			merchant:SetText("X");
			merchant:Disable();
			if(items_merchant==true) then
				merchant:Show();
			else
				merchant:Hide();
			end
			alt:SetText(items_alt);
			if(items_alt>0) then
				alt:Enable();
				if(items_alt>=necessary[offset+i].count) then items_alt="|cff00ff00"..items_alt.."|r"; else items_alt="|cffff0000"..items_alt.."|r"; end
				alt.itemname=necessary[offset+i].name;
			else
				alt:Disable();
			end
			alt:Show();
			if(items_missing>=0) then
				missing:SetText("|cff00ff00".."+"..items_missing.."|r");
			else
				missing:SetText("|cffff0000"..items_missing.."|r");
			end
			missing:Disable();
			missing:Show();
		else
			count:Hide();
			item:Hide();
			inv:Hide();
			bank:Hide();
			merchant:Hide();
			alt:Hide();
			missing:Hide();
		end
	end
	FauxScrollFrame_Update(ATSWSLScrollFrame, reagents, 5, 5);
	return reagents;
end

function ATSWAuction_SearchForItem(itemname)
	if(CanSendAuctionQuery()) then
		BrowseName:SetText(itemname);
		AuctionFrameBrowse_Search();
		BrowseNoResultsText:SetText(BROWSE_NO_RESULTS);
	end
end

-- merchant functions

atsw_autobuy=false;
atsw_merchantlist={};

function ATSWMerchant_InsertAutoBuyButton()
	if(#atsw_queue==0) then return; end
	if(ATSWMerchant_Buy(true)==false) then return; end
	ATSWAutoBuyButtonFrame:Show();
	ATSWAutoBuyButtonFrame:SetPoint("TOPLEFT", "MerchantFrame", "TOPLEFT" , 60, -28);
	ATSWAutoBuyButtonFrame:SetFrameStrata("HIGH");
end

function ATSWMerchant_RemoveAutoBuyButton()
	ATSWAutoBuyButtonFrame:Hide();
end

function ATSWMerchant_ExecuteAutoBuy()
	ATSWMerchant_RemoveAutoBuyButton();
	ATSWMerchant_Buy();
end

function ATSWMerchant_UpdateMerchantList()
	if(MerchantFrame:IsVisible()) then
		local numitems=GetMerchantNumItems();
		if(numitems==148) then numitems=0; end
		for i=1,numitems,1 do
			local itemname=ATSWMerchant_GetItemName(i);
			if(itemname) then
				local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i);
				if(numAvailable==-1) then
					atsw_merchantlist[itemname]=true;
				end
			end
		end
	end
end

function ATSWMerchant_GetItemName(slot)
	local link = GetMerchantItemLink(slot);
	if(link) then
    	local _,_,name = string.find(link, "^.*%[(.*)%].*$");
    	return name;
 	else
    	return nil;
    end
end

function ATSWMerchant_CheckIfAvailable(itemname)
	if(atsw_merchantlist[itemname]) then
		return true;
	else
		return false;
	end
end

function ATSWMerchant_AutoBuy()
	if(atsw_autobuy==true) then
		ATSWMerchant_Buy();
	end
end

function ATSWMerchant_Buy(onlyCheck)
	local needtobuy=false;
	if(#atsw_queue>0) then
		if(MerchantFrame:IsVisible()) then
			ATSW_NoteNecessaryItemsForQueue();
			autobuymessage=false;
			local numitems=GetMerchantNumItems();
			if(numitems==148) then numitems=0; end
			for i=1,numitems do
				local itemname=ATSWMerchant_GetItemName(i);
				if(itemname) then
					for k=1,#atsw_necessaryitems do
						if(atsw_necessaryitems[k]) then
							if(atsw_necessaryitems[k].name==itemname) then
								local stilltobuy=atsw_necessaryitems[k].cnt-ATSWInv_GetItemCount(itemname);
								if(stilltobuy>0) then
									local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i);
									local sName, sLink, iQuality, iLevel, iMinLevel, sType, sSubType, iCount = GetItemInfo(GetMerchantItemLink(i));
									local itemstobuy=ceil(stilltobuy/quantity);
									if(onlyCheck==nil or onlyCheck==false) then
										if(iCount==nil) then
											for l=1,itemstobuy,1 do
												BuyMerchantItem(i,1);
											end
										else
											local fullstackstobuy=floor(stilltobuy/iCount);
											local fullstackitemcount=floor(iCount);
											local resttobuy=ceil((stilltobuy-(fullstackstobuy*iCount)));
											if(fullstackstobuy>0) then
												for l=1,fullstackstobuy,1 do
													BuyMerchantItem(i,fullstackitemcount);
												end
											end
											if(resttobuy>0) then
												BuyMerchantItem(i,resttobuy);
											end
										end
										if(autobuymessage==false) then
											ATSW_DisplayMessage(ATSW_AUTOBUYMESSAGE);
											autobuymessage=true;
										end
										local totalprice=price*itemstobuy;
										local gold=floor(totalprice/10000);
										local silver=floor((totalprice-gold*10000)/100);
										local copper=math.fmod(totalprice,100);
										local moneystring="";
										if(gold>0) then
											moneystring=gold.."g "..silver.."s "..copper.."c";
										elseif(silver>0) then
											moneystring=silver.."s "..copper.."c";
										else
											moneystring=copper.."c";
										end
										ATSW_DisplayMessage((itemstobuy*quantity).."x "..GetMerchantItemLink(i).." ("..moneystring..")");
									else
										needtobuy=true;
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return needtobuy;
end

-- all reagents for all queues frame functions

atsw_displayreagentlist=false;

function ATSWAllReagentListCharDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, ATSWAllReagentListCharDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 400);
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, 1);
end

function ATSWAllReagentListCharDropDown_OnShow(self)
	UIDropDownMenu_Initialize(self, ATSWAllReagentListCharDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, 1);
	FauxScrollFrame_SetOffset(ATSWARLFScrollFrame, 0);
	ATSWAllReagentList_ScrollUpdate();
end

function ATSWAllReagentList_OpenBankFrame()
	if(atsw_savednecessaryitems) then
		for k, v in pairs(atsw_savednecessaryitems)  do
			for k2, v2 in pairs(v) do
				if(#v2>0) then
					ShowUIPanel(ATSWAllReagentListFrame);
					return;
				end
			end
		end
	end
end

function ATSWAllReagentList_CloseBankFrame()
	HideUIPanel(ATSWAllReagentListFrame);
end

function ATSWAllReagentListCharDropDown_Initialize()
	local info={};
	local count=0;
	if(atsw_savednecessaryitems) then
		for k, v in pairs(atsw_savednecessaryitems)  do
			for k2, v2 in pairs(v) do
				if(#v2>0) then
					info.text=k.." - "..k2;
					info.func=ATSWAllReagentListCharDropDownButton_OnClick;
					info.checked=false;
					info.charname=k;
					UIDropDownMenu_AddButton(info);
					count=count+1;
				end
			end
		end
	end
	if(count==0) then
		info.text=ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY;
		info.func=nil;
		info.checked=false;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWAllReagentListCharDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, self:GetID());
	local charname, skillname=string.match(self:GetText(), "(%w*) %- (%w*)");
	ATSWAllReagentList_Update(charname, skillname);
	FauxScrollFrame_SetOffset(ATSWARLFScrollFrame, 0);
end

function ATSWAllReagentList_ScrollUpdate()
	local charname, skillname=string.match(UIDropDownMenu_GetText(ATSWAllReagentListCharDropDown), "(%w*) %- (%w*)");
	ATSWAllReagentList_Update(charname, skillname);
end

function ATSWAllReagentList_Update(charname, skillname)
	local offset=FauxScrollFrame_GetOffset(ATSWARLFScrollFrame);
	local necessary={};
	if(charname) then
		ATSWAllReagentListFrameHeader1:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..charname);
		ATSWAllReagentListFrameHeader2:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..player_name);
		if(atsw_savednecessaryitems[charname] and atsw_savednecessaryitems[charname][skillname]) then
			for k, v in pairs(atsw_savednecessaryitems[charname][skillname]) do
				tinsert(necessary, {name=v.name,count=v.cnt,link=v.link});
			end
		end
	end
	for i=1+offset, 7+offset, 1 do
		local lcount=_G["ATSWARLFReagent"..(i-offset).."Count"];
		local lname=_G["ATSWARLFReagent"..(i-offset).."Item"];
		local lorigcount=_G["ATSWARLFReagent"..(i-offset).."OrigCount"];
		local llocalcount=_G["ATSWARLFReagent"..(i-offset).."LocalCount"];
		local laltcount=_G["ATSWARLFReagent"..(i-offset).."AltCount"];
		local lmerchant=_G["ATSWARLFReagent"..(i-offset).."Merchant"];
		if(necessary[i]) then
			local localcount=ATSWInv_GetItemCount(necessary[i].name)+ATSWBank_GetItemCount(necessary[i].name);
			local origcount=ATSWAlt_GetItemCount(necessary[i].name, charname);
			local altcount=ATSWAlt_GetItemCount(necessary[i].name);
			local merchant=ATSWMerchant_CheckIfAvailable(necessary[i].name);
			if(player_name~=charname) then
				altcount=altcount-origcount;
			end
			lcount:SetText(necessary[i].count);
			lname:SetText("["..necessary[i].name.."]");
			lname.link=necessary[i].link;
			lname.itemname=necessary[i].name;
			lorigcount:SetText(origcount);
			llocalcount:SetText(localcount);
			laltcount:SetText(altcount);
			laltcount.itemname=necessary[i].name;
			if(merchant==true) then
				lmerchant:SetText("X");
			else
				lmerchant:SetText("");
			end
		else
			lcount:SetText("");
			lname:SetText("");
			lname.link=nil;
			lorigcount:SetText("");
			llocalcount:SetText("");
			laltcount:SetText("");
			lmerchant:SetText("");
		end
		lmerchant:Disable();
		llocalcount:Disable();
		lorigcount:Disable();
	end
	FauxScrollFrame_Update(ATSWARLFScrollFrame, #necessary, 7, 22);
end

function ATSWAllReagentList_FetchItemsFromBank(itemname)
	if(atsw_bankopened==false) then return; end
	local charname, skillname=string.match(UIDropDownMenu_GetText(ATSWAllReagentListCharDropDown), "(%w*) %- (%w*)");
	local offset=FauxScrollFrame_GetOffset(ATSWARLFScrollFrame);
	local necessary={};
	if(charname) then
		ATSWAllReagentListFrameHeader1:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..charname);
		ATSWAllReagentListFrameHeader2:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..player_name);
		if(atsw_savednecessaryitems[charname] and atsw_savednecessaryitems[charname][skillname]) then
			for k, v in pairs(atsw_savednecessaryitems[charname][skillname]) do
				tinsert(necessary, {name=v.name,count=v.cnt,link=v.link});
			end
		end
	end
	for i=1,#necessary do
		local itemstofetch=0;
		if(player_name==charname) then
			itemstofetch=necessary[i].count-ATSWInv_GetItemCount(necessary[i].name);
		else
			itemstofetch=necessary[i].count-ATSWAlt_GetItemCount(necessary[i].name, charname)-ATSWInv_GetItemCount(necessary[i].name);
		end
		if(itemstofetch>0 and (itemname==nil or itemname==necessary[i].name)) then
			ATSWBank_FetchItemsFromBank(necessary[i].name, itemstofetch);
		end
	end
end

-- slow scanning mechanism

function ATSW_InitSlowScan()
	if(TradeSkillFrame and TradeSkillFrame:IsVisible() and ATSW_IsCurrentlyEnabled()) then
		ATSW_HideBlizzardTradeSkillFrame();
	end
	local blah=GetNumTradeSkills();
	atsw_scan_timeout=3.0;
	atsw_scan_state=1;
	ATSWScanDelayFrame:Show();
	ATSWScanDelayFrameBar:SetMinMaxValues(0,1);
	ATSWScanDelayFrameBar:SetValue(0);
	ATSWScanDelayFrameBarText:SetText(ATSW_SCAN_DELAY_FRAME_INITIALIZING);
end

function ATSW_FinalizeSlowScan()
	atsw_scan_state=0;
	ATSWScanDelayFrame:Hide();
	local version,build,date=GetBuildInfo();
	local locale=GetLocale();
	atsw_prescanned[atsw_selectedskill]=build..locale;
	ATSW_ShowWindow();
end

function ATSW_AbortSlowScan()
	atsw_scan_state=0;
	ATSWScanDelayFrame:Hide();
	ATSW_HideWindow();
end

function ATSWScanDelayFrame_OnUpdate(self, elapsed)
	atsw_scan_timeout=atsw_scan_timeout-elapsed;
	if(atsw_scan_timeout<=0) then
		atsw_scan_timeout=atsw_scan_delay;
		if(atsw_scan_state==1) then
			atsw_scan_state=2;
			atsw_scan_numtradeskills=GetNumTradeSkills();
			atsw_scan_nextskill=1;
			ATSWScanDelayFrameBar:SetMinMaxValues(0,atsw_scan_numtradeskills);
		end
		ATSW_ContinueSlowScan();
	end
end

function ATSW_ContinueSlowScan()
	if(atsw_scan_nextskill>=atsw_scan_numtradeskills) then
		ATSW_FinalizeSlowScan();
	else
		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(atsw_scan_nextskill);
		if(skillName~=nil) then
			if(skillType~="header") then
				local numReagents = GetTradeSkillNumReagents(atsw_scan_nextskill);
				GetTradeSkillItemLink(atsw_scan_nextskill);
				GetTradeSkillNumMade(atsw_scan_nextskill);
				for j=1, numReagents, 1 do
					GetTradeSkillReagentInfo(atsw_scan_nextskill, j);
					GetTradeSkillReagentItemLink(atsw_scan_nextskill, j);
				end
			end
		end
		atsw_scan_nextskill=atsw_scan_nextskill+1;
		ATSWScanDelayFrameBar:SetValue(atsw_scan_nextskill);
		ATSWScanDelayFrameBarText:SetText(atsw_scan_nextskill.." / "..atsw_scan_numtradeskills);
	end
end


-- general utility functions

function ATSW_DisplayMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function ATSW_NOP()
	-- do nothing!
end

event_map.TRADE_SKILL_CLOSE				= ATSW_HideWindow
event_map.PLAYERBANKSLOTS_CHANGED		= ATSWBank_UpdateBankList
event_map.PLAYERBANKBAGSLOTS_CHANGED	= ATSWBank_UpdateBankList
event_map.MERCHANT_CLOSED				= ATSWMerchant_RemoveAutoBuyButton
event_map.MERCHANT_UPDATE				= ATSWMerchant_UpdateMerchantList
event_map.AUCTION_HOUSE_SHOW			= ATSWAuction_ShowShoppingList
event_map.AUCTION_HOUSE_CLOSED			= ATSWAuction_HideShoppingList
event_map.VARIABLES_LOADED				= function()
	local added={}
	if(atsw_itemlist[player_realm]) then
		for name,data in pairs(atsw_itemlist[player_realm]) do
			if(name~=player_name and not added[name]) then tinsert(atsw_playernames, name) added[name]=1 end
		end
	end
	if(atsw_bankitemlist[player_realm]) then
		for name,data in pairs(atsw_bankitemlist[player_realm]) do
			if(name~=player_name and not added[name]) then tinsert(atsw_playernames, name) added[name]=1 end
		end
	end
	ATSWFrame:UnregisterEvent("VARIABLES_LOADED")
	event_map.VARIABLES_LOADED=nil
end
