local HealBot_UnitStatus={};
local HealBot_PlayerDead=false;
local HealBot_CheckGroup=0;
local HealBot_Enabled={};
local HealBot_PetMaxH={};
local HealBot_PetMaxHcnt1={};
local HealBot_PetMaxHcnt2={};
local HealBot_AttribStatus={};
local HealBot_UnitRange={}
local HealBot_UnitRangeSpell={}
local HealBot_UnitBarsRange={["r"]={},["g"]={},["b"]={},["a"]={},["3a"]={},["hr"]={},["hg"]={},["hb"]={},["sr"]={},["sg"]={},["sb"]={}}
local HealBot_UnitTextRange={["ir"]={},["ig"]={},["ib"]={},["or"]={},["og"]={},["ob"]={},["oa"]={}}
local HealBot_curUnitHealth={}
local HealBot_UnitBarUpdate={}
local HealBot_UnitOffline={}
local HealBot_ResetAttribs=nil
local ceil=ceil;
local floor=floor
local strsub=strsub
local HealBot_ActiveButtons={[0]=1}
local HealBot_hSpell=nil
local HealBot_bSpell=nil
local HealBot_dSpell=nil
local HealBot_rSpell=nil
local HealBot_Aggro={}
local HealBot_AggroIndicator={}
local HealBot_AggroBarA=0.8
local HealBot_AggroBarAup=true
local HealBot_MyTargets={}
local HealBot_pcClass=false
local HealBot_pcMax=3
local HealBot_FrameMoving=nil
local LSM = LibStub("LibSharedMedia-3.0")
local HealBot_UnitThreat={}
local HealBot_ResetBarSkinDone={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}}
local HealBot_Hightlight={}
local HealBot_Reserved={}
local _

-- Register Default HealBot Media
for i = 1, #HealBot_Default_Textures do
    LSM:Register("statusbar", HealBot_Default_Textures[i].name, HealBot_Default_Textures[i].file)
end
for i = 1, #HealBot_Default_Sounds do
    LSM:Register("sound", HealBot_Default_Sounds[i].name, HealBot_Default_Sounds[i].file)
end

local HealBot_prevUnitThreat={}
local Healbot_tempUnitThreat=0
local UnitDebuffStatus={}
local HealBot_UnitThreatPct={}
local HealBot_UnitAggro={}
local hbprevThreatPct=-3
-- local HealBot_resetUnitStatus=nil
function HealBot_Action_UpdateAggro(unit,status,threatStatus,threatPct)
    local xButton=HealBot_Unit_Button[unit]
    if not xButton then return end

    --if HealBot_UnitAggro[unit] then HealBot_UnitAggro[unit]=nil end

    local barName=HealBot_Action_HealthBar4(xButton)
    if not barName then return end    
    if UnitExists(unit) then
        if UnitIsDeadOrGhost(unit) and not UnitIsFeignDeath(unit) then
            status=nil
            threatPct=0
            if threatStatus then threatStatus=0 end
        end
        hbprevThreatPct=HealBot_UnitThreatPct[unit] or -4
        if threatStatus and (Healbot_Config_Skins.ShowAggroBarsPct[Healbot_Config_Skins.Current_Skin]==1 or Healbot_Config_Skins.ShowAggroTextPct[Healbot_Config_Skins.Current_Skin]==1) then
            if not threatPct then threatPct,_=HealBot_CalcThreat(unit) end
           -- threatPct,_=HealBot_CalcThreat(unit)
            if threatPct>0 then
                HealBot_UnitThreatPct[unit]=threatPct
                if threatStatus==0 then
                    threatStatus=1
                    if not status then status=true end
                end
            elseif threatStatus==3 then
                HealBot_UnitThreatPct[unit]=100
            elseif threatStatus==2 then
                if not HealBot_UnitThreatPct[unit] then HealBot_UnitThreatPct[unit]=75 end
            elseif threatStatus==1 then
                if not HealBot_UnitThreatPct[unit] then HealBot_UnitThreatPct[unit]=25 end
            elseif threatStatus>4 then 
                if not HealBot_UnitThreatPct[unit] then HealBot_UnitThreatPct[unit]=50 end
            else
                HealBot_UnitThreatPct[unit]=0
            end
            if HealBot_UnitThreatPct[unit]>0 then HealBot_UnitAggro[unit]=true end
        else
            if not threatStatus then threatStatus=0 end
            HealBot_UnitThreatPct[unit]=0
            if status and not UnitIsFriend("player",unit) then status=nil end
        end
        if status then
            if HealBot_Config.CDCshownAB==1 and UnitDebuffStatus[unit] then
                HealBot_Aggro[unit]="d"
                HealBot_UnitThreat[unit]=UnitDebuffStatus[unit]
            elseif Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin]==1 and 
                   threatStatus>(Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]) then
                HealBot_UnitThreat[unit]=threatStatus
                HealBot_Aggro[unit]="a"
                HealBot_UnitAggro[unit]=true
            elseif status=="target" and Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin]==1 then
                HealBot_Aggro[unit]="h"
                HealBot_UnitThreat[unit]=-2
                HealBot_Hightlight[unit]="T"
            elseif status=="highlight" and Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]==1 then
                HealBot_Aggro[unit]="h"
                HealBot_UnitThreat[unit]=-1
                HealBot_Hightlight[unit]="M"
            elseif HealBot_Aggro[unit] and HealBot_Aggro[unit]=="h" then
                if status~="off" then
                    if (HealBot_Hightlight[unit] or "M")=="M" then 
                        HealBot_UnitThreat[unit]=-1
                    else    
                        HealBot_UnitThreat[unit]=-2
                    end
                else
                    HealBot_Aggro[unit]=nil
                    HealBot_UnitThreat[unit]=threatStatus
                end
            else
                HealBot_UnitThreat[unit]=threatStatus
                HealBot_Aggro[unit]="a"
            end
            if Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin]==1 and
                Healbot_Config_Skins.ShowAggroInd[Healbot_Config_Skins.Current_Skin]==1 and
                (HealBot_AggroIndicator[unit] or -11) ~= threatStatus then
                    HealBot_Action_aggoIndicatorUpd(unit, threatStatus)
            end
        else
            HealBot_UnitThreat[unit]=threatStatus
            HealBot_Aggro[unit]=nil
            if HealBot_AggroIndicator[unit] then
                HealBot_AggroIndicator[unit]=nil
                HealBot_Action_aggoIndicatorUpd(unit, 0)
            end
        end
        if status and 
           (HealBot_Aggro[unit]=="d" or HealBot_Aggro[unit]=="h" or 
           (HealBot_Aggro[unit]=="a" and Healbot_Config_Skins.ShowAggroBars[Healbot_Config_Skins.Current_Skin]==1 and
           threatStatus>(Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]))) then
            if HealBot_UnitThreat[unit]>-1 and HealBot_UnitThreat[unit]<4 and Healbot_Config_Skins.ShowAggroBarsPct[Healbot_Config_Skins.Current_Skin]==1 then
                barName:SetValue(HealBot_UnitThreatPct[unit])
            else
                barName:SetValue(100)
            end
            xButton.bar4state=1
        else
            HealBot_Hightlight[unit]=nil
            barName:SetStatusBarColor(1,0,0,0)
            xButton.bar4state=0
        end
    else
        HealBot_Hightlight[unit]=nil
        barName:SetStatusBarColor(1,0,0,0)
        xButton.bar4state=0
    end
    HealBot_Action_ResetUnitStatus(unit)
end

function HealBot_Action_aggoIndicatorUpd(unit, threatStatus)
    local mainBar=HealBot_Action_HealthBar(HealBot_Unit_Button[unit])
    local iconName=nil
    HealBot_AggroIndicator[unit]=threatStatus
    if threatStatus>=Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin] then
        if threatStatus==1 then
            iconName = _G[mainBar:GetName().."Iconal1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconal2"];
            iconName:SetAlpha(0)
            iconName = _G[mainBar:GetName().."Iconal3"];
            iconName:SetAlpha(0)
            iconName = _G[mainBar:GetName().."Iconar1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar2"];
            iconName:SetAlpha(0)
            iconName = _G[mainBar:GetName().."Iconar3"];
            iconName:SetAlpha(0)
        elseif threatStatus==2 then
            iconName = _G[mainBar:GetName().."Iconal1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconal2"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconal3"];
            iconName:SetAlpha(0)
            iconName = _G[mainBar:GetName().."Iconar1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar2"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar3"];
            iconName:SetAlpha(0)
        elseif threatStatus==3 then
            iconName = _G[mainBar:GetName().."Iconal1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconal2"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconal3"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar1"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar2"];
            iconName:SetAlpha(1)
            iconName = _G[mainBar:GetName().."Iconar3"];
            iconName:SetAlpha(1)
        end
    elseif threatStatus>-1 and threatStatus<4 then
        iconName = _G[mainBar:GetName().."Iconal1"];
        iconName:SetAlpha(0)
        iconName = _G[mainBar:GetName().."Iconal2"];
        iconName:SetAlpha(0)
        iconName = _G[mainBar:GetName().."Iconal3"];
        iconName:SetAlpha(0)
        iconName = _G[mainBar:GetName().."Iconar1"];
        iconName:SetAlpha(0)
        iconName = _G[mainBar:GetName().."Iconar2"];
        iconName:SetAlpha(0)
        iconName = _G[mainBar:GetName().."Iconar3"];
        iconName:SetAlpha(0)
    end
end

function HealBot_Action_SetThreatPct(unit, threatPct)
    if threatPct then
        hbprevThreatPct=HealBot_UnitThreatPct[unit] or -2
        HealBot_UnitThreatPct[unit]=threatPct
        if HealBot_UnitThreatPct[unit]~=hbprevThreatPct then HealBot_Action_ResetUnitStatus(unit) end
    end
end

function HealBot_Action_SetVAggro(unit, threatStatus)
    if threatStatus then
        HealBot_Aggro[unit]="a"
    else
        HealBot_Aggro[unit]=nil
    end
end

function HealBot_Action_retAggro(unit)
    return HealBot_Aggro[unit]
end

function HealBot_Action_EndAggro()
    for xUnit,_ in pairs(HealBot_Unit_Button) do
        --local bar4=HealBot_Action_HealthBar4(xButton)
        --bar4:SetStatusBarColor(1,0,0,0)
        --xButton.bar4state=0
        HealBot_Action_UpdateAggro(xUnit,false,nil,0)
    end
    for xUnit,_ in pairs(HealBot_Aggro) do
        HealBot_Action_UpdateAggro(xUnit,false,nil,0)
    end
end

function HealBot_Action_SetUnitDebuffStatus(unit,status)
    if not status then
        UnitDebuffStatus[unit]=nil
    else
        UnitDebuffStatus[unit]=status
    end
end

function HealBot_Action_ClearUnitDebuffStatus(unit)
    if unit then
        UnitDebuffStatus[unit]=nil
    else
        for x,_ in pairs(UnitDebuffStatus) do
            UnitDebuffStatus[x]=nil;
        end
    end
end

function HealBot_Action_RetUnitThreat(unit)
    return HealBot_UnitThreat[unit] or -9
end

function HealBot_Action_RetHealBot_UnitStatus(unit)
    return HealBot_UnitStatus[unit] or -9
end

function HealBot_Action_setpcClass()
	if Healbot_Config_Skins.PowerCounter[Healbot_Config_Skins.Current_Skin]==1 and (HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PALADIN] or HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_MONK]) then
        local prevHealBot_pcMax=HealBot_pcMax;
		if HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PALADIN] then
            HealBot_pcClass=9
            if UnitLevel("player")<85 then
                HealBot_pcMax=3
            else
                HealBot_pcMax=5
            end
        else
            HealBot_pcClass=12
            local _, talent = GetTalentRowSelectionInfo(3)
            if talent==8 then
                HealBot_pcMax=5
            else
                HealBot_pcMax=4
            end
        end     
        if prevHealBot_pcMax~=HealBot_pcMax then
            HealBot_Action_clearResetBarSkinDone()
            if HealBot_Data["REFRESH"]<1 then HealBot_Data["REFRESH"]=1; end
        end
	else
		HealBot_pcClass=false
        local barName = HealBot_Action_HealthBar3(HealBot_Unit_Button["player"])
        if barName then
            for y=1,5 do
                local iconName = _G[barName:GetName().."Icon"..y];
                iconName:SetAlpha(0)
            end
        end
	end
end

function HealBot_Action_SetrSpell()
	HealBot_hSpell=nil
	HealBot_bSpell=nil
	HealBot_dSpell=nil
	HealBot_rSpell=nil
	local x=HealBot_GetBandageType()
    if HealBot_Data["PCLASSTRIM"]=="DRUI" then
        if HealBot_GetSpellId(HEALBOT_REMOVE_CORRUPTION) then 
			HealBot_dSpell=HEALBOT_REMOVE_CORRUPTION
			x=HEALBOT_REMOVE_CORRUPTION
		end
        if HealBot_GetSpellId(HEALBOT_REVIVE) then 
			HealBot_rSpell=HEALBOT_REVIVE
			x=HEALBOT_REVIVE
		end
        if HealBot_GetSpellId(HEALBOT_MARK_OF_THE_WILD) then 
			HealBot_bSpell=HEALBOT_MARK_OF_THE_WILD
			x=HEALBOT_MARK_OF_THE_WILD
		end
        if HealBot_GetSpellId(HEALBOT_REJUVENATION) then 
			HealBot_hSpell=HEALBOT_REJUVENATION 
			x=HEALBOT_REJUVENATION
		end
    elseif HealBot_Data["PCLASSTRIM"]=="MAGE" then
		if HealBot_GetSpellId(HEALBOT_REMOVE_CURSE) then 
			HealBot_dSpell=HEALBOT_REMOVE_CURSE
			x=HEALBOT_REMOVE_CURSE
		end
		if HealBot_GetSpellId(HEALBOT_ARCANE_BRILLIANCE) then 
			HealBot_bSpell=HEALBOT_ARCANE_BRILLIANCE
			x=HEALBOT_ARCANE_BRILLIANCE
		end
    elseif HealBot_Data["PCLASSTRIM"]=="PALA" then
		if HealBot_GetSpellId(HEALBOT_REDEMPTION) then 
			HealBot_rSpell=HEALBOT_REDEMPTION
			x=HEALBOT_REDEMPTION
		end
		if HealBot_GetSpellId(HEALBOT_CLEANSE) then 
			HealBot_dSpell=HEALBOT_CLEANSE
			x=HEALBOT_CLEANSE
		end
		if HealBot_GetSpellId(HEALBOT_BLESSING_OF_KINGS) then 
			HealBot_bSpell=HEALBOT_BLESSING_OF_KINGS
			x=HEALBOT_BLESSING_OF_KINGS
		end
		if HealBot_GetSpellId(HEALBOT_HOLY_LIGHT) then 
			HealBot_hSpell=HEALBOT_HOLY_LIGHT
			x=HEALBOT_HOLY_LIGHT
		end
    elseif HealBot_Data["PCLASSTRIM"]=="PRIE" then
		if HealBot_GetSpellId(HEALBOT_RESURRECTION) then 
			HealBot_rSpell=HEALBOT_RESURRECTION
			x=HEALBOT_RESURRECTION
		end
		if HealBot_GetSpellId(HEALBOT_PURIFY) then 
			HealBot_dSpell=HEALBOT_PURIFY
			x=HEALBOT_PURIFY
		end
		if HealBot_GetSpellId(HEALBOT_POWER_WORD_FORTITUDE) then 
			HealBot_bSpell=HEALBOT_POWER_WORD_FORTITUDE
			x=HEALBOT_POWER_WORD_FORTITUDE
		end
		if HealBot_GetSpellId(HEALBOT_FLASH_HEAL) then 
			HealBot_hSpell=HEALBOT_FLASH_HEAL
			x=HEALBOT_FLASH_HEAL
		end
    elseif HealBot_Data["PCLASSTRIM"]=="SHAM" then
		if HealBot_GetSpellId(HEALBOT_ANCESTRALSPIRIT) then 
			HealBot_rSpell=HEALBOT_ANCESTRALSPIRIT
			x=HEALBOT_ANCESTRALSPIRIT
		end
		if HealBot_GetSpellId(HEALBOT_PURIFY_SPIRIT) then 
			HealBot_dSpell=HEALBOT_PURIFY_SPIRIT
			x=HEALBOT_PURIFY_SPIRIT
        elseif HealBot_GetSpellId(HEALBOT_CLEANSE_SPIRIT) then 
			HealBot_dSpell=HEALBOT_CLEANSE_SPIRIT
			x=HEALBOT_CLEANSE_SPIRIT
		end
		if HealBot_GetSpellId(HEALBOT_EARTH_SHIELD) then 
			HealBot_bSpell=HEALBOT_EARTH_SHIELD
			x=HEALBOT_EARTH_SHIELD
		end
		if HealBot_GetSpellId(HEALBOT_HEALING_WAVE) then 
			HealBot_hSpell=HEALBOT_HEALING_WAVE
			x=HEALBOT_HEALING_WAVE
		end
    elseif HealBot_Data["PCLASSTRIM"]=="MONK" then
		if HealBot_GetSpellId(HEALBOT_RESUSCITATE) then 
			HealBot_rSpell=HEALBOT_RESUSCITATE
			x=HEALBOT_RESUSCITATE
		end
		if HealBot_GetSpellId(HEALBOT_DETOX) then 
			HealBot_dSpell=HEALBOT_DETOX
			x=HEALBOT_DETOX
		end
		if HealBot_GetSpellId(HEALBOT_LEGACY_EMPEROR) then 
			HealBot_bSpell=HEALBOT_LEGACY_EMPEROR
			x=HEALBOT_LEGACY_EMPEROR
		end
		if HealBot_GetSpellId(HEALBOT_SOOTHING_MIST) then 
			HealBot_hSpell=HEALBOT_SOOTHING_MIST
			x=HEALBOT_SOOTHING_MIST
		end
    elseif HealBot_Data["PCLASSTRIM"]=="WARL" then
		if HealBot_GetSpellId(HEALBOT_UNENDING_BREATH) then 
			HealBot_bSpell=HEALBOT_UNENDING_BREATH
			x=HEALBOT_UNENDING_BREATH
		end
    elseif HealBot_Data["PCLASSTRIM"]=="WARR" then
        if HealBot_GetSpellId(HEALBOT_VIGILANCE) then 
			HealBot_bSpell=HEALBOT_VIGILANCE 
			x=HEALBOT_VIGILANCE
		end
    end
	if (HealBot_hSpell or HEALBOT_WORDS_UNKNOWN)==HEALBOT_WORDS_UNKNOWN then HealBot_hSpell=x end
	if (HealBot_bSpell or HEALBOT_WORDS_UNKNOWN)==HEALBOT_WORDS_UNKNOWN then HealBot_bSpell=x end
	if (HealBot_dSpell or HEALBOT_WORDS_UNKNOWN)==HEALBOT_WORDS_UNKNOWN then HealBot_dSpell=x end
	if (HealBot_rSpell or HEALBOT_WORDS_UNKNOWN)==HEALBOT_WORDS_UNKNOWN then HealBot_rSpell=x end
    HealBot_Set_debuffSpell(HealBot_dSpell)
--    HealBot_SetrSpells(HealBot_hSpell,HealBot_bSpell,HealBot_dSpell,HealBot_rSpell)
end

function HealBot_GetBandageType()
    local bandage = ""
    if IsUsableItem(HEALBOT_DENSE_EMBERSILK_BANDAGE) then bandage = HEALBOT_DENSE_EMBERSILK_BANDAGE
    elseif IsUsableItem(HEALBOT_EMBERSILK_BANDAGE) then bandage = HEALBOT_EMBERSILK_BANDAGE
    elseif IsUsableItem(HEALBOT_HEAVY_FROSTWEAVE_BANDAGE) then bandage = HEALBOT_HEAVY_FROSTWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_FROSTWEAVE_BANDAGE) then bandage = HEALBOT_FROSTWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_HEAVY_NETHERWEAVE_BANDAGE) then bandage = HEALBOT_HEAVY_NETHERWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_NETHERWEAVE_BANDAGE) then bandage = HEALBOT_NETHERWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_HEAVY_RUNECLOTH_BANDAGE) then bandage = HEALBOT_HEAVY_RUNECLOTH_BANDAGE
    elseif IsUsableItem(HEALBOT_RUNECLOTH_BANDAGE) then bandage = HEALBOT_RUNECLOTH_BANDAGE
    elseif IsUsableItem(HEALBOT_HEAVY_MAGEWEAVE_BANDAGE) then bandage = HEALBOT_HEAVY_MAGEWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_MAGEWEAVE_BANDAGE) then bandage = HEALBOT_MAGEWEAVE_BANDAGE
    elseif IsUsableItem(HEALBOT_HEAVY_SILK_BANDAGE) then bandage = HEALBOT_HEAVY_SILK_BANDAGE
    elseif IsUsableItem(HEALBOT_SILK_BANDAGE) then bandage = HEALBOT_SILK_BANDAGE
    else
        bandage = HEALBOT_WORDS_UNKNOWN
    end
    return bandage
end

function HealBot_HealthColor(unit,hlth,maxhlth,tooltipcol,UnitDead,Member_Buff,Member_Debuff,healin,absorbs,getBar5,button)
    local hca,hcr,hir,hcg,hig,hcb,hib,hbr,hbg,hbb,har,hag,hab=0,0,0,0,0,0,0,0,0,0,0,0,0
    local hcaggro,hcta,hcpct,hipct,hrpct,hapct,hbuff=nil,nil,nil,nil,100,nil,nil
    if UnitDead then
        hcpct=0
        hipct=0
        hrpct=0
        hapct=0
    else
        hipct = hlth+healin
        if hipct<maxhlth then
            hipct=hipct/maxhlth
        else
            hipct=1;
        end
        hcpct=hlth/maxhlth
        if maxhlth == 0 then
            hrpct = 100;
        else
            hrpct=floor((hlth/maxhlth)*100)
        end
        if Healbot_Config_Skins.AbsorbBarColour[Healbot_Config_Skins.Current_Skin] == 1 then
            hapct=hlth+absorbs
        else
            hapct=hlth+healin+absorbs
        end
        if hapct<maxhlth then
            hapct=hapct/maxhlth
        else
            hapct=1;
        end
    end
  
    if HealBot_Aggro[unit] and (HealBot_UnitThreat[unit] or 0)>(Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]) and UnitIsConnected(unit) then
        hcaggro=true
    else
        hcaggro=nil
    end
    
    if not tooltipcol then
        HealBot_UnitStatus[unit]=1
        if UnitDead then
            HealBot_UnitStatus[unit]=8
            hbuff=true
        elseif Member_Debuff and UnitIsConnected(unit) then
            if HealBot_Config.CDCshownHB==1 and HealBot_UnitInRange(HealBot_dSpell, unit)>(HealBot_Config.HealBot_CDCWarnRange_Bar-3) and 
              (HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[button.debuff.name] or 1)==1  then
                if HealBot_Globals.CDCBarColour[button.debuff.name] then
                    hcr = HealBot_Globals.CDCBarColour[button.debuff.name].R
                    hcg = HealBot_Globals.CDCBarColour[button.debuff.name].G
                    hcb = HealBot_Globals.CDCBarColour[button.debuff.name].B
                elseif Member_Debuff == HEALBOT_CUSTOM_en then
                    hcr = HealBot_Globals.CDCBarColour[Member_Debuff].R
                    hcg = HealBot_Globals.CDCBarColour[Member_Debuff].G
                    hcb = HealBot_Globals.CDCBarColour[Member_Debuff].B
                else
                    hcr = HealBot_Config.CDCBarColour[Member_Debuff].R
                    hcg = HealBot_Config.CDCBarColour[Member_Debuff].G
                    hcb = HealBot_Config.CDCBarColour[Member_Debuff].B
                end
                hca = Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin]
                hcta = Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]
                hbuff=true
            end
        elseif Member_Buff and UnitIsConnected(unit) then
            hcr,hcg,hcb=HealBot_Options_RetBuffRGB(Member_Buff)
            hca = Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin]
            hcta = Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]
            hbuff=true
        elseif hlth>maxhlth*Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin] and not hcaggro then
            local vUnit=HealBot_retIsInVehicle(unit)
            if vUnit then
                x,y=HealBot_VehicleHealth(vUnit)
                if x>y*Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin] and not hcaggro then
                    HealBot_UnitStatus[unit]=0;
                end
            else
                HealBot_UnitStatus[unit]=0;
            end
        end
    end

    if not hbuff then
        hcr,hcg,hir,hig,har,hag = 1, 1, 1, 1, 1, 1
        if HealBot_UnitStatus[unit]~=0 then --(hipct<=Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin] or HealBot_Aggro[unit]) then -- 
            hca=Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin]
            hcta=Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]
        else
            hca=Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]
            hcta=Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]
        end
        if (Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin] >= 2) and not tooltipcol then
            if (Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin] == 2) then
                hcr,hcg,hcb = HealBot_Action_ClassColour(unit)
            else
                hcr=Healbot_Config_Skins.barcolr[Healbot_Config_Skins.Current_Skin]
                hcg=Healbot_Config_Skins.barcolg[Healbot_Config_Skins.Current_Skin]
                hcb=Healbot_Config_Skins.barcolb[Healbot_Config_Skins.Current_Skin]
            end
        else
            if (Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin] == 3) then -- Incoming Heal Bar Colour = "Same as Health (Future Health)"
                hcr, hcg = HealBot_Action_BarColourPct(hipct)
            else 
                hcr, hcg = HealBot_Action_BarColourPct(hcpct)
            end
        end
    end

    if (Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin] == 5) then -- Incoming Heal Bar Colour = "Custom"
        hir=Healbot_Config_Skins.ihbarcolr[Healbot_Config_Skins.Current_Skin]
        hig=Healbot_Config_Skins.ihbarcolg[Healbot_Config_Skins.Current_Skin]
        hib=Healbot_Config_Skins.ihbarcolb[Healbot_Config_Skins.Current_Skin]
    elseif (Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin] == 4) then -- Incoming Heal Bar Colour = "Future Health"
        hir, hig = HealBot_Action_BarColourPct(hipct)
    else
        hir=hcr
        hig=hcg
        hib=hcb
    end
    if (Healbot_Config_Skins.AbsorbBarColour[Healbot_Config_Skins.Current_Skin] == 4) then -- Incoming Heal Bar Colour = "Custom"
        har=Healbot_Config_Skins.asbarcolr[Healbot_Config_Skins.Current_Skin]
        hag=Healbot_Config_Skins.asbarcolg[Healbot_Config_Skins.Current_Skin]
        hab=Healbot_Config_Skins.asbarcolb[Healbot_Config_Skins.Current_Skin]
    elseif (Healbot_Config_Skins.AbsorbBarColour[Healbot_Config_Skins.Current_Skin] == 3) then -- Incoming Heal Bar Colour = "Future Health"
        har, hag = HealBot_Action_BarColourPct(hapct)
        hab=hcb
    else
        har=hcr
        hag=hcg
        hab=hcb
    end
    
    if getBar5 then
        if Healbot_Config_Skins.HlthBackColour[Healbot_Config_Skins.Current_Skin]<3 and Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin]==Healbot_Config_Skins.HlthBackColour[Healbot_Config_Skins.Current_Skin] and not UnitDead then
            hbr,hbg,hbb=hcr,hcg,hcb
        elseif Healbot_Config_Skins.HlthBackColour[Healbot_Config_Skins.Current_Skin]==1 then
            if Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin] > 2 then
                hbr,hbg = HealBot_Action_BarColourPct(hipct)
            else
                hbr,hbg = HealBot_Action_BarColourPct(hcpct)
            end
        elseif Healbot_Config_Skins.HlthBackColour[Healbot_Config_Skins.Current_Skin]==2 then
            hbr,hbg,hbb = HealBot_Action_ClassColour(unit)
        else
            hbr=Healbot_Config_Skins.barbackcolr[Healbot_Config_Skins.Current_Skin]
            hbg=Healbot_Config_Skins.barbackcolg[Healbot_Config_Skins.Current_Skin]
            hbb=Healbot_Config_Skins.barbackcolb[Healbot_Config_Skins.Current_Skin]
        end
        
    end

    return hcr,hcg,hcb,hca,hrpct,hcta,hir,hig,hib,hbr,hbg,hbb,har,hag,hab
end

function HealBot_Action_BarColourPct(hlthPct)
    local hcpr, hcpg = 1,1
    if hlthPct>=0.98 then 
        hcpr = 0.0
    elseif hlthPct<0.98 and hlthPct>=0.65 then 
        hcpr=2.94-(hlthPct*3)
    elseif hlthPct<=0.64 and hlthPct>0.31 then 
        hcpg=(hlthPct-0.31)*3
    elseif hlthPct<=0.31 then 
        hcpg = 0.0 
    end
    return hcpr, hcpg
end

function HealBot_Action_HealthBar(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar"];
end

function HealBot_Action_HealthBar2(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar2"];
end

function HealBot_Action_HealthBar3(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar3"];
end

function HealBot_Action_HealthBar4(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar4"];
end

function HealBot_Action_HealthBar5(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar5"];
end

function HealBot_Action_HealthBar6(button)
    if not button then return nil end
    local barName = button:GetName();
    return _G[barName.."Bar6"];
end

function HealBot_Action_ShouldHealSome(unit, hbCurFrame)
    if unit and HealBot_Enabled[unit] and HealBot_Enabled[unit]=="e" then 
        return true
    else
        if hbCurFrame then
            for xUnit,xButton in pairs(HealBot_Unit_Button) do
                if xButton.frame==hbCurFrame and HealBot_Enabled[xUnit] and HealBot_Enabled[xUnit]=="e" then
                    return true
                end
            end
        end
    end
    return false
end

function HealBot_MayHeal(unit)
    if UnitCanAttack("player",unit) then 
        return false 
    end
    return true;
end

function HealBot_Action_SetBar3Value(button)
    if not button then return end
    local barName = HealBot_Action_HealthBar3(button)
    local x,iconName=nil,nil
    if HealBot_pcClass and button.unit=="player" then
		x = UnitPower("player", HealBot_pcClass)
        if x==1 then
            iconName = _G[barName:GetName().."Icon"..1];
            iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_red.tga]]);
            iconName:SetAlpha(1)
            iconName = _G[barName:GetName().."Icon"..2];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..3];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..4];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(0)
        elseif x==2 then
            if HealBot_pcMax<4 then
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_yellow.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_yellow.tga]]);
                iconName:SetAlpha(1)
            else
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_orange.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_orange.tga]]);
                iconName:SetAlpha(1)
            end
            iconName = _G[barName:GetName().."Icon"..3];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..4];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(0)
        elseif x==3 then
            if HealBot_pcMax<4 then
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..3];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)

            elseif HealBot_pcMax<5 then
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..3];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)

            else
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_yellow.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_yellow.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..3];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_yellow.tga]]);
                iconName:SetAlpha(1)
            end
            iconName = _G[barName:GetName().."Icon"..4];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(0)
        elseif x==4 then
            if HealBot_pcMax<5 then
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..3];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..4];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
                iconName:SetAlpha(1)

            else
                iconName = _G[barName:GetName().."Icon"..1];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..2];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..3];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
                iconName = _G[barName:GetName().."Icon"..4];
                iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_lime.tga]]);
                iconName:SetAlpha(1)
            end
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(0)
        elseif x==5 then
            iconName = _G[barName:GetName().."Icon"..1];
            iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
            iconName:SetAlpha(1)
            iconName = _G[barName:GetName().."Icon"..2];
            iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
            iconName:SetAlpha(1)
            iconName = _G[barName:GetName().."Icon"..3];
            iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
            iconName:SetAlpha(1)
            iconName = _G[barName:GetName().."Icon"..4];
            iconName:SetTexture([[Interface\AddOns\HealBot\Images\indicator_green.tga]]);
            iconName:SetAlpha(1)
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(1)
        else
            iconName = _G[barName:GetName().."Icon"..1];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..2];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..3];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..4];
            iconName:SetAlpha(0)
            iconName = _G[barName:GetName().."Icon"..5];
            iconName:SetAlpha(0)
        end
	--	for y=1,3 do
    --        iconName = _G[barName:GetName().."Icon"..y];
    --        if y>x then
    --            iconName:SetAlpha(0)
    --        else
    --            iconName:SetAlpha(1)
    --        end
--		end
    end
	if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]==0 then return end
    if UnitManaMax(button.unit)==0 then
        x=100
    else
        x=UnitManaMax(button.unit)
    end
    local y=floor((UnitMana(button.unit)/x)*100)
    local hcr,hcg,hcb=HealBot_Action_GetManaBarCol(button.unit)
    barName:SetValue(y);
    barName:SetStatusBarColor(hcr,hcg,hcb,HealBot_UnitBarsRange["3a"][button.unit] or Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin])
end

function HealBot_Action_GetManaBarCol(unit)
    local z=UnitPowerType(unit);
    if z==0 then
        return 0.1,0.1,1 -- Mana
    elseif z==1 then
        return 1,0.1,0.1 -- Rage
    elseif z==4 then
        return 0,1,1 -- Happy
    elseif z==6 then
        return 0.1,0.8,1 -- Rune
    end
    return 1,1,0 -- Energy
end

function HealBot_CorrectPetHealth(unit,hlth,maxhlth,hbGUID)
    if maxhlth==0 then maxhlth=hlth end
    if not hbGUID then return maxhlth end
    if not HealBot_PetMaxH[hbGUID] then
        local hbPetLevel=UnitLevel(unit)
        if hbPetLevel>80 then
            if hlth<8100 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*100
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        elseif hbPetLevel>70 then
            if hlth<5325 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*75
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        elseif hbPetLevel>60 then
            if hlth<3050 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*50
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        elseif hbPetLevel>40 then
            if hlth<1640 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*40
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        elseif hbPetLevel>20 then
            if hlth<735 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*35
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        elseif hbPetLevel>5 then
            if hlth<180 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*30
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        else
            if hlth<25 then
                HealBot_PetMaxH[hbGUID]=hbPetLevel*25
            else
                HealBot_PetMaxH[hbGUID]=hlth;
            end
        end
    elseif hlth>HealBot_PetMaxH[hbGUID] then
        HealBot_PetMaxH[hbGUID]=hlth;
    elseif HealBot_Data["UILOCK"]=="NO" then
        if not HealBot_PetMaxHcnt1[hbGUID] then
            HealBot_PetMaxHcnt1[hbGUID]=1
            HealBot_PetMaxHcnt2[hbGUID]=HealBot_PetMaxH[hbGUID];
        else
            if HealBot_PetMaxHcnt2[hbGUID]~=hlth then
                HealBot_PetMaxHcnt2[hbGUID]=hlth;
                HealBot_PetMaxHcnt1[hbGUID]=1;
            else
                HealBot_PetMaxHcnt1[hbGUID]=HealBot_PetMaxHcnt1[hbGUID]+1;
                if HealBot_PetMaxHcnt1[hbGUID]>9 then
                    HealBot_PetMaxH[hbGUID]=HealBot_PetMaxHcnt2[hbGUID];
                    HealBot_PetMaxHcnt1[hbGUID]=1;
                end
            end
        end
    end
    return HealBot_PetMaxH[hbGUID]
end

function HealBot_Action_EnableButton(button, isTarget)
    local ebUnit=isTarget or button.unit
    local ebubar,ebubar2,ebubar5,ebubar6,ebuicon15=nil,nil,nil,nil,nil
    local ebusr,ebusg,ebusb,ebusa=nil,nil,nil,nil
    local ebur,ebir,ebug,ebig,ebub,ebib,ebua,hbr,hbg,hbb,har,hag,hab=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
    local ebpct,ebipct,ebapct,uHlth,uMaxHlth,uName=1,0,0,nil,nil,nil,nil
    local ebufastenable,ebuProcessThis,activeUnit=nil,nil,true
    local ebuUnitDead,ebuHealBot_UnitDebuff,ebuHealBot_UnitBuff=nil,nil,nil
    local unitHRange=HealBot_UnitInRange(HealBot_hSpell, ebUnit)
    hbGUID=button.guid

--    if not button then return end
--    if not uName then uName=HEALBOT_WORDS_UNKNOWN end

    ebubar = HealBot_Action_HealthBar(button)
    ebubar2 = HealBot_Action_HealthBar2(button)
    ebubar5 = HealBot_Action_HealthBar5(button)
    ebubar6 = HealBot_Action_HealthBar6(button)
    ebuicon15 = _G[ebubar:GetName().."Icon15"];
    HealBot_UnitRangeSpell[ebUnit]=HealBot_hSpell

    local uHealIn, uAbsorbs = HealBot_IncHeals_retHealsIn(ebUnit)
    if UnitExists(ebUnit) and UnitIsFriend("player",ebUnit) then
        activeUnit = true
        uName=UnitName(ebUnit)
        uHlth,uMaxHlth=HealBot_UnitHealth(ebUnit)

        ebuUnitDead = UnitIsDeadOrGhost(ebUnit)
        if button.debuff and button.debuff.type then
            ebuHealBot_UnitDebuff=button.debuff.type
        else
            ebuHealBot_UnitDebuff=nil
        end
        ebuHealBot_UnitBuff=button.buff
        
        if uHlth>uMaxHlth then uMaxHlth=HealBot_CorrectPetHealth(ebUnit,uHlth,uMaxHlth,hbGUID) end
    
        if ebuUnitDead then
            if UnitIsFeignDeath(ebUnit) then
                ebuUnitDead = nil
            else
                uHealIn=0
                uAbsorbs=0
                --if HealBot_Aggro[ebUnit] then
                HealBot_Action_SetUnitDebuffStatus(ebUnit)
                HealBot_Action_UpdateAggro(ebUnit,false,nil,0)
                HealBot_Aggro[ebUnit]=nil
                --end
                if button.debuff.name then  
                    HealBot_CheckAllDebuffs(ebUnit)
                    ebuHealBot_UnitDebuff=nil
                end
                ebuHealBot_UnitBuff=nil
                HealBot_HoT_RemoveIconButton(HealBot_Unit_Button[ebUnit])
                if HealBot_UnitInRange(HealBot_rSpell, ebUnit)==1 and not UnitIsGhost(ebUnit) then
                    ebubar:SetValue(100)
                else
                    ebubar:SetValue(0)
                end
            end
            if uName==HealBot_Data["PNAME"] and not HealBot_PlayerDead then
                HealBot_Action_ResetActiveUnitStatus()
                HealBot_PlayerDead=true
            end
        elseif uName==HealBot_Data["PNAME"] and HealBot_PlayerDead then
            HealBot_Action_ResetActiveUnitStatus()
            HealBot_PlayerDead=false
        end
    
        ebur,ebug,ebub,ebua,ebpct,ebusa,ebir,ebig,ebib,hbr,hbg,hbb,har,hag,hab = HealBot_HealthColor(ebUnit,uHlth,uMaxHlth,false,ebuUnitDead,ebuHealBot_UnitBuff,ebuHealBot_UnitDebuff,uHealIn,uAbsorbs,true,button)

        if Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin]==1 then
            ebusr,ebusg,ebusb = HealBot_Action_ClassColour(ebUnit);
        elseif ebuHealBot_UnitDebuff then
            ebusr=Healbot_Config_Skins.btextcursecolr[Healbot_Config_Skins.Current_Skin];
            ebusg=Healbot_Config_Skins.btextcursecolg[Healbot_Config_Skins.Current_Skin];
            ebusb=Healbot_Config_Skins.btextcursecolb[Healbot_Config_Skins.Current_Skin];
        else
            ebusr=Healbot_Config_Skins.btextenabledcolr[Healbot_Config_Skins.Current_Skin] or 1;
            ebusg=Healbot_Config_Skins.btextenabledcolg[Healbot_Config_Skins.Current_Skin] or 1;
            ebusb=Healbot_Config_Skins.btextenabledcolb[Healbot_Config_Skins.Current_Skin] or 1;
        end

        if uMaxHlth<1 then 
            uHlth=1 
        end
  
        if Healbot_Config_Skins.UseFluidBars[Healbot_Config_Skins.Current_Skin]==0 then
            ebubar:SetValue(ebpct)
        elseif HealBot_curUnitHealth[ebubar]~=ebpct then
            HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
            HealBot_curUnitHealth[ebubar]=ebpct
        end

        --local hBarWidth=ceil(HealBot_bWidth*(ebpct/100))
        if uHealIn>0 and HealBot_UnitStatus[ebUnit]~=0 then
            ebipct = uHlth+uHealIn
            if ebipct<uMaxHlth then
                ebipct=ebipct/uMaxHlth
            else
                ebipct=1;
            end
            ebipct=floor(ebipct*100)
            --ebubar2:SetPoint("TOPLEFT",ebubar,"TOPLEFT",hBarWidth,0);
            ebubar2:SetValue(ebipct);
        elseif ebubar2:GetValue()>0 then
            ebubar2:SetValue(0)
        end
        if uAbsorbs>0 and HealBot_UnitStatus[ebUnit]~=0 then
            if Healbot_Config_Skins.AbsorbBarColour[Healbot_Config_Skins.Current_Skin] == 1 then
                ebapct = uHlth+uAbsorbs
            else
                ebapct = uHlth+uHealIn+uAbsorbs
            end
            if ebapct<uMaxHlth then
                ebapct=ebapct/uMaxHlth
            else
                ebapct=1;
            end
            ebapct=floor(ebapct*100)
            ebubar6:SetValue(ebapct);
        elseif ebubar6:GetValue()>0 then
            ebubar6:SetValue(0)
        end    

        ebuProcessThis=true
        ebufastenable=false
        if HealBot_Globals.ProtectPvP==1 then
            if UnitIsPVP(ebUnit) and not UnitIsPVP("player") then 
                ebuProcessThis=false
            end
        end
        if not ebuUnitDead and not HealBot_PlayerDead and ebuProcessThis then
            if ebuHealBot_UnitDebuff then
                HealBot_UnitRangeSpell[ebUnit]=HealBot_dSpell
                if HealBot_UnitInRange(HealBot_dSpell, ebUnit)==1 then ebufastenable=true end
            elseif ebuHealBot_UnitBuff then
                HealBot_UnitRangeSpell[ebUnit]=HealBot_bSpell
                if HealBot_UnitInRange(HealBot_bSpell, ebUnit)==1 then ebufastenable=true end
            end
            if not ebufastenable and (uHlth<=(uMaxHlth*Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin]) or HealBot_MyTargets[hbGUID]) and unitHRange==1 then
                ebufastenable=true
            elseif not ebufastenable and HealBot_Aggro[ebUnit] and (HealBot_UnitThreat[ebUnit] or 0)>(Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]) and unitHRange==1 then
                ebufastenable=true
            end
        end
        if ebufastenable then
            ebusa = Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin];
            HealBot_Enabled[ebUnit]="e"
            ebubar:SetStatusBarColor(ebur,ebug,ebub,Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
            HealBot_UnitBarsRange["3a"][ebUnit]=Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]
            if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 and not HealBot_retdebuffTargetIcon(ebUnit) then
                ebuicon15:SetAlpha(Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
            end
            HealBot_UnitTextRange["ir"][ebUnit]=ebusr
            HealBot_UnitTextRange["ig"][ebUnit]=ebusg
            HealBot_UnitTextRange["ib"][ebUnit]=ebusb
            HealBot_UnitTextRange["or"][ebUnit]=ebusr
            HealBot_UnitTextRange["og"][ebUnit]=ebusg
            HealBot_UnitTextRange["ob"][ebUnit]=ebusb
            if HealBot_Data["TIPUSE"]=="YES" and HealBot_Data["TIPUNIT"] and ebUnit==HealBot_Data["TIPUNIT"] then
                HealBot_Data["TIPTYPE"] = "Enabled"
                HealBot_Action_RefreshTooltip()
            end
            if Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][button.frame]["AUTO"]==1 then HealBot_Action_ShowPanel(button.frame) end
        else
            HealBot_Enabled[ebUnit]="d"
            if Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin]==0 then
                ebusr=Healbot_Config_Skins.btextdisbledcolr[Healbot_Config_Skins.Current_Skin]
                ebusg=Healbot_Config_Skins.btextdisbledcolg[Healbot_Config_Skins.Current_Skin]
                ebusb=Healbot_Config_Skins.btextdisbledcolb[Healbot_Config_Skins.Current_Skin]
            end
            if HealBot_RetHealBot_Ressing(hbGUID) then
                if ebuUnitDead then
                    ebusr=0.2
                    ebusg=1.0
                    ebusb=0.2
                    ebusa=1
                else
                    HealBot_UnsetHealBot_Ressing(hbGUID)
                end
                HealBot_UnitTextRange["ir"][ebUnit]=0.2
                HealBot_UnitTextRange["ig"][ebUnit]=1
                HealBot_UnitTextRange["ib"][ebUnit]=0.2
                HealBot_UnitTextRange["or"][ebUnit]=0.2
                HealBot_UnitTextRange["og"][ebUnit]=1
                HealBot_UnitTextRange["ob"][ebUnit]=0.2
            elseif ebuUnitDead and hbGUID~=HealBot_Data["PGUID"] then
                if HealBot_rSpell then
                    HealBot_UnitRangeSpell[ebUnit]=HealBot_rSpell
                    if HealBot_UnitInRange(HealBot_rSpell, ebUnit)==1 and not UnitIsGhost(ebUnit) then
                        ebusr=1;
                        ebusg=0.2;
                        ebusb=0.2;
                        ebusa=1;
                    else
                        ebusr=0.8;
                        ebusg=0;
                        ebusb=0;
                        ebusa=1;
                    end
                    if not UnitIsGhost(ebUnit) then
                        HealBot_UnitTextRange["ir"][ebUnit]=1
                        HealBot_UnitTextRange["ig"][ebUnit]=0.2
                        HealBot_UnitTextRange["ib"][ebUnit]=0.2
                    else
                        HealBot_UnitTextRange["ir"][ebUnit]=0.8
                        HealBot_UnitTextRange["ig"][ebUnit]=0
                        HealBot_UnitTextRange["ib"][ebUnit]=0
                    end
                    HealBot_UnitTextRange["or"][ebUnit]=0.8
                    HealBot_UnitTextRange["og"][ebUnit]=0
                    HealBot_UnitTextRange["ob"][ebUnit]=0
                end
            else
                HealBot_UnitTextRange["ir"][ebUnit]=ebusr
                HealBot_UnitTextRange["ig"][ebUnit]=ebusg
                HealBot_UnitTextRange["ib"][ebUnit]=ebusb
                HealBot_UnitTextRange["or"][ebUnit]=ebusr
                HealBot_UnitTextRange["og"][ebUnit]=ebusg
                HealBot_UnitTextRange["ob"][ebUnit]=ebusb
                --ebua=Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]
            end
            if not HealBot_retdebuffTargetIcon(ebUnit) then
                if UnitIsVisible(ebUnit) then
                    ebubar:SetStatusBarColor(ebur,ebug,ebub,ebua);
                    if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 then
                        if Healbot_Config_Skins.IconAlphaAlEn[Healbot_Config_Skins.Current_Skin]==0 then
                            ebuicon15:SetAlpha(ebua);
                        else
                            ebuicon15:SetAlpha(Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin])
                        end
                    end
                else
                    ebubar:SetStatusBarColor(ebur,ebug,ebub,Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
                    if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 then
                        if Healbot_Config_Skins.IconAlphaAlEn[Healbot_Config_Skins.Current_Skin]==0 then
                            ebuicon15:SetAlpha(Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
                        else
                            ebuicon15:SetAlpha(Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin])
                        end
                    end
                end
            end
            if HealBot_Data["UILOCK"]=="NO" and HealBot_Config.EnableHealthy==0 then
                if HealBot_Data["TIPUSE"]=="YES" and HealBot_Data["TIPUNIT"] and ebUnit==HealBot_Data["TIPUNIT"] then
                    HealBot_Data["TIPTYPE"] = "Disabled"
                    HealBot_Action_RefreshTooltip()
                end
            end
            HealBot_UnitBarsRange["3a"][ebUnit]=ebua
        end
        HealBot_UnitBarsRange["r"][ebUnit]=ebur
        HealBot_UnitBarsRange["g"][ebUnit]=ebug
        HealBot_UnitBarsRange["b"][ebUnit]=ebub
        HealBot_UnitBarsRange["a"][ebUnit]=ebua
        HealBot_UnitTextRange["oa"][ebUnit]=ebusa
    else
        uHlth,uMaxHlth=1,1
        uHealIn = 0
        uAbsorbs = 0
        ebusr,ebusg,ebusb=0.7,0.7,0.7
        ebubar:SetStatusBarColor(0,1,0,0)
        ebubar2:SetStatusBarColor(0,0,0,0);
        ebubar5:SetStatusBarColor(0,0,0,0);
        ebubar6:SetStatusBarColor(0,0,0,0);
        HealBot_UnitBarsRange["r"][ebUnit]=0
        HealBot_UnitBarsRange["g"][ebUnit]=1
        HealBot_UnitBarsRange["b"][ebUnit]=0
        HealBot_UnitBarsRange["a"][ebUnit]=ebua or 0.1
        HealBot_UnitBarsRange["3a"][ebUnit]=ebua or 0.1
        HealBot_UnitTextRange["oa"][ebUnit]=ebusa or 0.01
        activeUnit = false
        if hbGUID==ebUnit then
            uName=HEALBOT_WORD_RESERVED..":"..ebUnit
            HealBot_Reserved[ebUnit]=true
        else
            uName=HEALBOT_WORDS_UNKNOWN
            if HealBot_Data["REFRESH"]<1 then HealBot_Data["REFRESH"]=1 end
            HealBot_UnitStatus[ebUnit]=9
        end
    end
    
    ebubar5:SetStatusBarColor(hbr,hbg,hbb,Healbot_Config_Skins.barbackcola[Healbot_Config_Skins.Current_Skin]);
    if uHealIn>0 then
        if unitHRange==1 and not HealBot_PlayerDead then
            ebubar2:SetStatusBarColor(ebir,ebig,ebib,Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin]);
        elseif unitHRange==0 then
            ebubar2:SetStatusBarColor(ebir,ebig,ebib,HealBot_UnitBarsRange["a"][ebUnit]);
        else
            ebubar2:SetStatusBarColor(ebir,ebig,ebib,Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
        end
        --if unitHRange~=1 and UnitIsVisible(ebUnit) then HealBot_AddDebug("unitHRange="..unitHRange.." for visible unit "..ebUnit) end
        HealBot_UnitBarsRange["hr"][ebUnit]=ebir
        HealBot_UnitBarsRange["hg"][ebUnit]=ebig
        HealBot_UnitBarsRange["hb"][ebUnit]=ebib
    else
        ebubar2:SetStatusBarColor(ebur,ebug,ebub,0);
    end
    if uAbsorbs>0 then
        if unitHRange==1 and not HealBot_PlayerDead then
            ebubar6:SetStatusBarColor(har,hag,hab,Healbot_Config_Skins.barabsorbcola[Healbot_Config_Skins.Current_Skin]);
        elseif unitHRange==0 then
            ebubar6:SetStatusBarColor(har,hag,hab,HealBot_UnitBarsRange["a"][ebUnit]);
        else
            ebubar6:SetStatusBarColor(har,hag,hab,Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
        end
        HealBot_UnitBarsRange["sr"][ebUnit]=har
        HealBot_UnitBarsRange["sg"][ebUnit]=hag
        HealBot_UnitBarsRange["sb"][ebUnit]=hab
    else
        ebubar6:SetStatusBarColor(ebur,ebug,ebub,0);
    end

    local ebtext=unitName
    if activeUnit then
        ebtext=HealBot_Action_HBText(uHlth,uMaxHlth,uName,ebUnit,uHealIn, hbGUID)
    end
    ebubar.txt = _G[ebubar:GetName().."_text"];
    ebubar.txt:SetText(ebtext);
    if activeUnit and UnitIsVisible(ebUnit) then
        ebubar.txt:SetTextColor(ebusr,ebusg,ebusb,ebusa);
    else
        ebubar.txt:SetTextColor(ebusr,ebusg,ebusb,Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]);
    end
    if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]>0 then 
        HealBot_Action_SetBar3Value(HealBot_Unit_Button[ebUnit]);
    end
    HealBot_UnitRange[ebUnit]=HealBot_UnitInRange(HealBot_UnitRangeSpell[ebUnit], ebUnit)
end

local hbFontVal={ ["Accidental Presidency"]=3,
                  ["Alba Super"]=1.4,
                  ["Anime Ace"]=1,
                  ["Ariel Narrow"]=3,
                  ["Blazed"]=1.1,
                  ["Designer Block"]=1.7,
                  ["DestructoBeam BB"]=1.4,
                  ["Diogenes"]=2.1,
                  ["Disko"]=1.9,
                  ["DreamSpeak"]=3,
                  ["Drummon"]=1.5,
                  ["Dustismo"]=1.9,
                  ["Electrofied"]=1.1,
                  ["Emblem"]=1.7,
                  ["Frakturika Spamless"]=2.4,
                  ["Friz Quadrata TT"]=1.6,
                  ["Impact"]=2,
                  ["Liberation Sans"]=1.6,
                  ["Liberation Serif"]=1.8,
                  ["Morpheus"]=1.9,
                  ["Mystic Orbs"]=1.2,
                  ["Pokemon Solid"]=1.9,
                  ["Rock Show Whiplash"]=2.4,
                  ["SF Diego Sans"]=1.5,
                  ["SF Laundromatic"]=3,
                  ["Skurri"]=2.2,
                  ["Solange"]=1.4,
                  ["Star Cine"]=1,
                  ["Trashco"]=1.6,
                  ["Waltograph UI"]=1,
                  ["X360"]=1.4,
                  ["Zekton"]=1.6,
                }
                

local hbNumFormatPlaces=-1
local hbNumFormatSurL="("
local hbNumFormatSurR=")"
local hbNumFormatSuffix="K"
function HealBot_Action_sethbNumberFormat()
    if Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==2 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==5 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==8 then
        hbNumFormatPlaces=0
    elseif Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==3 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==6 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==9 then
        hbNumFormatPlaces=1
    elseif Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==4 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==7 or Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==10 then
        hbNumFormatPlaces=2
    else
        hbNumFormatPlaces=-1
    end
    if Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]>1 and Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]<5 then
        hbNumFormatSuffix="K"
    elseif Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]>4 and Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]<8 then
        hbNumFormatSuffix="k"
    else
        hbNumFormatSuffix=""
    end
    if Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==2 then
        hbNumFormatSurL="("
        hbNumFormatSurR=")"
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==3 then
        hbNumFormatSurL="["
        hbNumFormatSurR="]"
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==4 then
        hbNumFormatSurL="{"
        hbNumFormatSurR="}"
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==5 then
        hbNumFormatSurL="<"
        hbNumFormatSurR=">"
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==6 then
        hbNumFormatSurL="~"
        hbNumFormatSurR=""
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==7 then
        hbNumFormatSurL=":"
        hbNumFormatSurR=":"
    elseif Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==8 then
        hbNumFormatSurL="*"
        hbNumFormatSurR="*"
    else
        hbNumFormatSurL=""
        hbNumFormatSurR=""
    end
    if hbNumFormatPlaces==-1 then
        hbNumFormatSuffix=""
    end
end

local hbNumFormatSurLa="["
local hbNumFormatSurRa="]"
function HealBot_Action_sethbAggroNumberFormat()
    if Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==2 then
        hbNumFormatSurLa="("
        hbNumFormatSurRa=")"
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==3 then
        hbNumFormatSurLa="["
        hbNumFormatSurRa="]"
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==4 then
        hbNumFormatSurLa="{"
        hbNumFormatSurRa="}"
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==5 then
        hbNumFormatSurLa="<"
        hbNumFormatSurRa=">"
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==6 then
        hbNumFormatSurLa="~"
        hbNumFormatSurRa=""
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==7 then
        hbNumFormatSurLa=":"
        hbNumFormatSurRa=":"
    elseif Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==8 then
        hbNumFormatSurLa="*"
        hbNumFormatSurRa="*"
    else
        hbNumFormatSurLa=""
        hbNumFormatSurRa=""
    end
end

function HealBot_Action_HBText(hlth,maxhlth,unitName,unit,healin, hbGUID)
    local btHBbarText,uName,bthlthdelta=" ",unitName,0
    
    if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==2 and UnitClass(unit) then
        local clTxt=UnitClass(unit)
        if Healbot_Config_Skins.ShowRole[Healbot_Config_Skins.Current_Skin]==1 then
            local hbRole=UnitGroupRolesAssigned(unit)
            if hbRole=="NONE" and HealBot_UnitData[hbGUID] then
                hbRole=HealBot_UnitData[hbGUID]["ROLE"]
            end
            if hbRole=="DAMAGER" then
                clTxt=HEALBOT_WORD_DAMAGER
            elseif hbRole=="HEALER" then
                clTxt=HEALBOT_WORD_HEALER
            elseif hbRole=="TANK" then
                clTxt=HEALBOT_WORD_TANK
            elseif hbRole=="LEADER" then
                clTxt=HEALBOT_WORD_LEADER
            else
                clTxt=UnitClass(unit)
            end
        end
        if Healbot_Config_Skins.ShowNameOnBar[Healbot_Config_Skins.Current_Skin]==1 then
            uName=clTxt..":"..unitName;
        else
            uName=clTxt;
        end
    elseif Healbot_Config_Skins.ShowNameOnBar[Healbot_Config_Skins.Current_Skin]==1 then
        uName=unitName;
    else
        uName=" "
    end
    local hbFont=Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]
    local hbFontAdj=hbFontVal[hbFont] or 2
    local bttextlen = floor((hbFontAdj*2)+2+(((Healbot_Config_Skins.bwidth[Healbot_Config_Skins.Current_Skin]*1.88)/Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin])-(Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin]/hbFontAdj)))
    if Healbot_Config_Skins.ShowHealthOnBar[Healbot_Config_Skins.Current_Skin]==1 and maxhlth then
        if Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]==1 then
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==2 then
                bthlthdelta=hlth+healin
                if bthlthdelta>maxhlth then bthlthdelta=maxhlth end
            else
                bthlthdelta=hlth;
            end
            if hbNumFormatPlaces>-1 then bthlthdelta=HealBot_Comm_round(bthlthdelta/1000,hbNumFormatPlaces) end
            btHBbarText=btHBbarText..hbNumFormatSurL..bthlthdelta..hbNumFormatSuffix..hbNumFormatSurR;
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==3 and healin>0 then
                if hbNumFormatPlaces>-1 then healin=HealBot_Comm_round(healin/1000,hbNumFormatPlaces) end
                btHBbarText=btHBbarText.." +"..healin..hbNumFormatSuffix
            end
        elseif Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]==2 then
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==2 then
                bthlthdelta=(hlth+healin)-maxhlth;
            else
                bthlthdelta=hlth-maxhlth;
            end
            if hbNumFormatPlaces>-1 then bthlthdelta=HealBot_Comm_round(bthlthdelta/1000,hbNumFormatPlaces) end
            if bthlthdelta>0 then
                btHBbarText=btHBbarText.." "..hbNumFormatSurL.."+"..bthlthdelta..hbNumFormatSuffix..hbNumFormatSurR;
            else
                btHBbarText=btHBbarText..hbNumFormatSurL..bthlthdelta..hbNumFormatSuffix..hbNumFormatSurR;
            end
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==3 and healin>0 then
                if hbNumFormatPlaces>-1 then healin=HealBot_Comm_round(healin/1000,hbNumFormatPlaces) end
                btHBbarText=btHBbarText.." +"..healin..hbNumFormatSuffix
            end
        else
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==2 then
                btHBbarText=btHBbarText..hbNumFormatSurL..floor(((hlth+healin)/maxhlth)*100).."%"..hbNumFormatSurR
            else
                btHBbarText=btHBbarText..hbNumFormatSurL..floor((hlth/maxhlth)*100).."%"..hbNumFormatSurR
            end
            if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==3 and healin>0 then
                btHBbarText=btHBbarText.." +"..floor((healin/maxhlth)*100).."%"
            end
        end
    end
    
    if HealBot_Action_UnitIsOffline(hbGUID) then
        uName=HEALBOT_DISCONNECTED_TEXT.." "..uName;
    end    -- added by Diacono of Ursin
    if Healbot_Config_Skins.ShowAggroText[Healbot_Config_Skins.Current_Skin]==1 and HealBot_Aggro[unit] and HealBot_Aggro[unit]=="a" and 
       (HealBot_UnitThreat[unit] or 0)>(Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]) and uName then
        uName=">> "..uName.." <<"
        --uName=">"..HealBot_UnitThreat[unit].."> "..uName.." <"..HealBot_UnitThreat[unit].."<"
    end
    local vUnit=HealBot_retIsInVehicle(unit)
    if vUnit then
        local x,y=HealBot_VehicleHealth(vUnit)
        local hpPerc = floor((x/y)*100)
        if hpPerc < 0.0001 then 
            hpPerc = 0
        end
        bthlthdelta="  "..string.format("|cff%s%d%%|r", HealBot_PercentToHexColor(hpPerc), hpPerc)
        if bttextlen>9 then 
            y=bttextlen-7
        else
            y=3
        end
        if UnitName(vUnit) and string.utf8len(UnitName(vUnit))>y then
            bthlthdelta = string.utf8sub(UnitName(vUnit),1,y).. '..'..bthlthdelta
        elseif UnitExists(vUnit) then
            bthlthdelta = UnitName(vUnit)..bthlthdelta
        else
            HealBot_CheckAllUnitVehicle(unit)
            if HealBot_retIsInVehicle(unit) then
                bthlthdelta = HEALBOT_VEHICLE..bthlthdelta
            end
        end
    end
    if Healbot_Config_Skins.ShowAggroTextPct[Healbot_Config_Skins.Current_Skin]==1 and HealBot_UnitThreatPct[unit] and HealBot_UnitThreatPct[unit]>0 then 
        btHBbarText=btHBbarText.."  "..hbNumFormatSurLa..HealBot_UnitThreatPct[unit].."%"..hbNumFormatSurRa
    end
    if Healbot_Config_Skins.DoubleText[Healbot_Config_Skins.Current_Skin]==0 then
        bttextlen=bttextlen-string.utf8len(btHBbarText)
        if bttextlen<1 then 
            bttextlen=1
        end
        if uName and string.utf8len(uName)>bttextlen then
            btHBbarText = string.utf8sub(uName,1,bttextlen) .. '.'..btHBbarText;
        elseif uName then
            btHBbarText = uName..btHBbarText;
        end
        if vUnit then
            btHBbarText = btHBbarText.."\n".." "..bthlthdelta
        end
    else
        if bttextlen<1 then 
            bttextlen=1
        end
        if uName and string.utf8len(uName)>bttextlen then
            btHBbarText = string.utf8sub(uName,1,bttextlen) .. '.'.."\n"..btHBbarText;
        elseif uName then
            btHBbarText = uName.."\n"..btHBbarText;
        end
        if vUnit then
            btHBbarText = btHBbarText.." "..bthlthdelta
        end
    end
    return btHBbarText;
end

function HealBot_PercentToHexColor(percent)
    local percent = percent/100
    local r,g,b = 0,1,0
    if percent <= 0 then
        r,g,b = 1,0,0
    elseif percent <= 0.5 then
        r,g,b = 1,percent*2,0
    end 
    return string.format("%02x%02x%02x",r*255,g*255,b*255)
end

function HealBot_Action_UnitIsOffline(hbGUID,preset) -- added by Diacono of Ursin
    local x = nil;
    if not HealBot_UnitData[hbGUID] or not UnitExists(HealBot_UnitData[hbGUID]["UNIT"]) then 
        if HealBot_UnitOffline[hbGUID] then HealBot_UnitOffline[hbGUID]=nil end
        return 
    end
    if preset then
        HealBot_UnitOffline[hbGUID]=preset
    else
        if HealBot_UnitOffline[hbGUID] then
            if time() - HealBot_UnitOffline[hbGUID] <= 2 then
                x = true;
            end
        end
        if not UnitIsConnected(HealBot_UnitData[hbGUID]["UNIT"]) or x then
            if not HealBot_UnitOffline[hbGUID] then
                HealBot_UnitOffline[hbGUID] = time();
            elseif HealBot_UnitOffline[hbGUID] == -1 then
                HealBot_UnitOffline[hbGUID] = nil;
            end
        else
            HealBot_UnitOffline[hbGUID] = nil;
        end
        return HealBot_UnitOffline[hbGUID]
    end
end

function HealBot_Action_retUnitOffline(hbGUID)
    return HealBot_UnitOffline[hbGUID]
end

function HealBot_Action_RefreshButton(button)
    if not button then return end
--  if type(button)~="table" then DEFAULT_CHAT_FRAME:AddMessage("***** "..type(button)) end
    HealBot_Action_EnableButton(button)
    if UnitExists("target") and HealBot_Unit_Button["target"] and button.unit~="target" and HealBot_UnitGUID("target")==button.guid then
        HealBot_Action_EnableButton(HealBot_Unit_Button["target"], "target")
    end
end

local HealBot_resetSkinTo=""
local HealBot_initSkin={[0]={},[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}}
function HealBot_Action_ResetSkin(barType,button,numcols)
local frameScale = 1
if button and button.frame then frameScale = Healbot_Config_Skins.FrameScale[Healbot_Config_Skins.Current_Skin][button.frame] end
local bWidth = ceil(Healbot_Config_Skins.bwidth[Healbot_Config_Skins.Current_Skin]*frameScale);
local bOutline = ceil(Healbot_Config_Skins.backoutline[Healbot_Config_Skins.Current_Skin]*frameScale);
local bheight=ceil(Healbot_Config_Skins.bheight[Healbot_Config_Skins.Current_Skin]*frameScale);
local b2Size = ceil(Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]*frameScale)
local br=Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin];  
local bg=Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin];
local bb=Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin];
local ba=Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin];
local sr=Healbot_Config_Skins.headtxtcolr[Healbot_Config_Skins.Current_Skin];  
local sg=Healbot_Config_Skins.headtxtcolg[Healbot_Config_Skins.Current_Skin];
local sb=Healbot_Config_Skins.headtxtcolb[Healbot_Config_Skins.Current_Skin];
local sa=Healbot_Config_Skins.headtxtcola[Healbot_Config_Skins.Current_Skin];
local btexture=Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin];
local btextheight=ceil(Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin]*frameScale);
local btextoutline=Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin];
local b,bar,bar2,bar3,bar4,icon,txt,icon1,icon15,icon16,icon1t,icon15t,icon1ta,icon15ta,pIcon,icont,iconta=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
local barScale,h,hwidth,hheight,iScale,itScale,x,hcpct,bar5,bar6=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
local abSize = ceil((Healbot_Config_Skins.AggroBarSize[Healbot_Config_Skins.Current_Skin])*frameScale)
local abtSize = {[0]=1,[1]=1,[2]=1,[3]=2,[4]=2,[5]=2,[6]=3,[7]=3,[8]=3,[9]=3,[10]=4,[11]=4,[12]=4,[13]=4,[14]=4,[15]=5}
  
    if barType=="bar" then
        if Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin]==0 and 
           Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]==0 and
           Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin]==0 then 
            abSize=0 
        end
        if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
            iScale=floor(((bheight*Healbot_Config_Skins.IconScale[Healbot_Config_Skins.Current_Skin])-2)*0.485)
        else
            iScale=(bheight*Healbot_Config_Skins.IconScale[Healbot_Config_Skins.Current_Skin])-2
        end
        itScale=ceil(iScale*Healbot_Config_Skins.IconTextScale[Healbot_Config_Skins.Current_Skin])
         --for x=1,51 do
        b=button;
        HealBot_ResetBarSkinDone[b.frame][b.id]=true
        bar = HealBot_Action_HealthBar(b);
        bar2 = HealBot_Action_HealthBar2(b);
        bar3 = HealBot_Action_HealthBar3(b);
        bar4 = HealBot_Action_HealthBar4(b)
        bar5 = HealBot_Action_HealthBar5(b)
        bar6 = HealBot_Action_HealthBar6(b)
        bar.txt = _G[bar:GetName().."_text"];
        bar3.txt=_G[bar3:GetName().."Power".."1"];
        bar:SetHeight(bheight);
        bar:SetWidth(bWidth)
        bar5:SetHeight(bheight+b2Size+(bOutline*2));
        bar5:SetWidth(bWidth+(bOutline*2))
        bar2:SetHeight(bheight);
        bar2:SetWidth(bWidth)
        bar6:SetHeight(bheight);
        bar6:SetWidth(bWidth)
        bar5:SetPoint("TOPLEFT",bar,"TOPLEFT",-bOutline,bOutline);
       -- bar6:SetPoint("TOPLEFT",bar,"TOPLEFT",0,0);
        local gaf = _G["f"..b.frame.."_HealBot_Action"]
        b:SetFrameLevel(gaf:GetFrameLevel()+ 1);
        bar5:SetFrameLevel(b:GetFrameLevel()+ 1);
        bar4:SetFrameLevel(bar5:GetFrameLevel()+ 1);
        bar6:SetFrameLevel(bar4:GetFrameLevel()+ 1);
        bar2:SetFrameLevel(bar6:GetFrameLevel()+ 1);
        bar:SetFrameLevel(bar2:GetFrameLevel()+ 1);
		bar3:SetFrameLevel(bar:GetFrameLevel()+ 1);
     --   bar:SetTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]),false);
        bar:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        bar:GetStatusBarTexture():SetHorizTile(false)
        bar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),btextheight,HealBot_Font_Outline[btextoutline]);
        bar.txt:ClearAllPoints();
        bar5:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        bar5:GetStatusBarTexture():SetHorizTile(false)
        bar6:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        bar6:GetStatusBarTexture():SetHorizTile(false)
        if Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin]==1 then
            bar.txt:SetPoint("LEFT",bar,"LEFT",4,0)
        elseif Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin]==2 then
            bar.txt:SetPoint("CENTER",bar,"CENTER")
        else
            bar.txt:SetPoint("RIGHT",bar,"RIGHT",-4,0)
        end
    --bar.txt:SetTextHeight(btextheight);
        bar2:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        bar2:GetStatusBarTexture():SetHorizTile(false)
        bar3:SetHeight(b2Size);
        bar3:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        bar3:GetStatusBarTexture():SetHorizTile(false)
        bar4:ClearAllPoints();
        bar4:SetPoint("TOPLEFT",bar,"TOPLEFT",0,abSize);
        bar4:SetPoint("TOPRIGHT",bar,"TOPRIGHT",0,abSize);
        if b2Size==0 then
            bar4:SetHeight(bheight+(abSize*2))
        else
            bar4:SetHeight(b2Size+bheight+(abSize*2))
        end
        bar4:SetStatusBarTexture('Interface\\Addons\\HealBot\\Images\\aggro'..abtSize[abSize]..'.tga')
        bar4:GetStatusBarTexture():SetHorizTile(false)
        bar4:SetStatusBarColor(1,0,0,0)
        bar4:SetMinMaxValues(0,100)
        bar4:SetValue(100)
        b:SetHeight(bheight); 
        b:SetWidth(bWidth)
        for x=2,14 do
            icon=_G[bar:GetName().."Icon"..x];
            icont=_G[bar:GetName().."Count"..x];
            iconta=_G[bar:GetName().."Count"..x.."a"];
            icon:SetHeight(iScale);
            icon:SetWidth(iScale);
            icont:SetTextHeight(itScale)
            iconta:SetTextHeight(itScale)
        end
        icon1 = _G[bar:GetName().."Icon1"];
        icon1t = _G[bar:GetName().."Count1"];
        icon1ta = _G[bar:GetName().."Count1a"];
        icon15 = _G[bar:GetName().."Icon15"];
        icon16 = _G[bar:GetName().."Icon16"];
        icon15t = _G[bar:GetName().."Count15"]; 
        icon15ta = _G[bar:GetName().."Count15a"];   
        for x=1,3 do
            pIcon = _G[bar:GetName().."Iconal"..x];
            pIcon:SetAlpha(0);
            pIcon = _G[bar:GetName().."Iconar"..x];
            pIcon:SetAlpha(0);
            pIcon = _G[bar:GetName().."Icontm"..x];
            pIcon:SetAlpha(0);
        end
        for x=1,5 do
            pIcon = _G[bar3:GetName().."Icon"..x];
            pIcon:SetAlpha(0);
        end
        if HealBot_pcMax==3 then
            pIcon = _G[bar3:GetName().."Icon1"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","-9","0");
            pIcon = _G[bar3:GetName().."Icon2"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","0","0");
            pIcon = _G[bar3:GetName().."Icon3"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","9","0");
        elseif HealBot_pcMax==4 then
            pIcon = _G[bar3:GetName().."Icon1"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","-12","0");
            pIcon = _G[bar3:GetName().."Icon2"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","-4","0");
            pIcon = _G[bar3:GetName().."Icon3"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","4","0");
            pIcon = _G[bar3:GetName().."Icon4"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","12","0");
        else
            pIcon = _G[bar3:GetName().."Icon1"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","-14","0");
            pIcon = _G[bar3:GetName().."Icon2"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","-7","0");
            pIcon = _G[bar3:GetName().."Icon3"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","0","0");
            pIcon = _G[bar3:GetName().."Icon4"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","7","0");
            pIcon = _G[bar3:GetName().."Icon5"];
            pIcon:SetPoint("BOTTOM",bar3,"BOTTOM","14","0");
        end
        icon1:SetHeight(iScale);
        icon1:SetWidth(iScale);
        icon1t:SetTextHeight(itScale)
        icon1ta:SetTextHeight(itScale)        
        icon15:SetHeight(iScale);
        icon15:SetWidth(iScale);
        icon15t:SetTextHeight(itScale)
        icon15ta:SetTextHeight(itScale)
        icon16:SetHeight(iScale);
        icon16:SetWidth(iScale);
        if not HealBot_initSkin[b.frame][b.id] then
            HealBot_initSkin[b.frame][b.id]=true
            b:Enable();
            bar:SetMinMaxValues(0,100)
            bar2:SetMinMaxValues(0,100);
            bar3:SetMinMaxValues(0,100)
            bar5:SetMinMaxValues(0,100)
            bar6:SetMinMaxValues(0,100)
            bar:SetStatusBarColor(0,1,0,Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
            bar5:SetStatusBarColor(0,1,0,0);
            bar6:SetStatusBarColor(0,1,0,Healbot_Config_Skins.barabsorbcola[Healbot_Config_Skins.Current_Skin]);
            if not HealBot_curUnitHealth[bar] then
                local uHlth,uMaxHlth=HealBot_UnitHealth(b.unit)
                local hcpct=100
                if uHlth>uMaxHlth then uMaxHlth=HealBot_CorrectPetHealth(b.unit,uHlth,uMaxHlth,b.guid) end
                if uHlth<uMaxHlth then
                    hcpct=floor(uHlth/uMaxHlth)*100
                end
                HealBot_curUnitHealth[bar]=hcpct
            end
            bar:SetValue(HealBot_curUnitHealth[bar])
            HealBot_Panel_SetBarArrays(b.id)
            bar2:SetValue(0);
            bar5:SetValue(100);
            bar6:SetValue(0);
            bar2:SetStatusBarColor(0,1,0,0);
            if b.guid then HealBot_Action_RefreshButton(b) end
        end
        if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 then
            icon15:SetTexture([[Interface\AddOns\HealBot\Images\icon_class.tga]]);
        else
        --    icon15:SetTexCoord(0,1,0,1);
            icon15:SetAlpha(0);
        end
        if Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin]==1 then
            HealBot_Panel_SetMultiColHoToffset(0)
            HealBot_Panel_SetMultiRowHoToffset(0)
            if Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]==1 then
                icon1:ClearAllPoints();
                icon1:SetPoint("BOTTOMLEFT",b,"BOTTOMLEFT",1,0);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMLEFT",icon1,"BOTTOMLEFT",-1,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPRIGHT",icon1,"TOPRIGHT",5,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-1,"TOPLEFT",0,1);
                        else
                            icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-2,"BOTTOMRIGHT",1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-1,"BOTTOMRIGHT",1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMLEFT",icon,"BOTTOMLEFT",-1,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPRIGHT",icon,"TOPRIGHT",5,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("BOTTOMRIGHT",b,"BOTTOMRIGHT",-1,0);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"TOPRIGHT",0,1);
                else
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMLEFT",-1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMLEFT",icon15,"BOTTOMLEFT",-1,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPRIGHT",icon15,"TOPRIGHT",5,0);
            else
                icon1:ClearAllPoints();
                icon1:SetPoint("BOTTOMRIGHT",b,"BOTTOMRIGHT",-1,0);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMRIGHT",icon1,"BOTTOMRIGHT",5,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPLEFT",icon1,"TOPLEFT",-1,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-1,"TOPRIGHT",0,1);
                        else
                            icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-2,"BOTTOMLEFT",-1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-1,"BOTTOMLEFT",-1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",5,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPLEFT",icon,"TOPLEFT",-1,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("BOTTOMLEFT",b,"BOTTOMLEFT",1,0);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("BOTTOMLEFT",icon15,"TOPLEFT",0,1);
                else
                    icon16:SetPoint("BOTTOMLEFT",icon15,"BOTTOMRIGHT",1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMRIGHT",5,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPLEFT",icon15,"TOPLEFT",-1,0);
            end
        elseif Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin]==2 then
            HealBot_Panel_SetMultiColHoToffset((iScale+1)*5)
            HealBot_Panel_SetMultiRowHoToffset(0)
            if Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]==1 then
                icon1:ClearAllPoints();
                icon1:SetPoint("BOTTOMRIGHT",b,"BOTTOMLEFT",-1,0);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMRIGHT",icon1,"BOTTOMRIGHT",5,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPLEFT",icon1,"TOPLEFT",-1,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-1,"TOPRIGHT",0,1);
                        else
                            icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-2,"BOTTOMLEFT",-1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-1,"BOTTOMLEFT",-1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",5,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPLEFT",icon,"TOPLEFT",-1,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("BOTTOMLEFT",b,"BOTTOMRIGHT",1,0);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("BOTTOMLEFT",icon15,"TOPLEFT",0,1);
                else
                    icon16:SetPoint("BOTTOMLEFT",icon15,"BOTTOMRIGHT",1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMRIGHT",5,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPLEFT",icon15,"TOPLEFT",-1,0);
            else
                icon1:ClearAllPoints();
                icon1:SetPoint("BOTTOMLEFT",b,"BOTTOMRIGHT",2,0);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMLEFT",icon1,"BOTTOMLEFT",-1,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPRIGHT",icon1,"TOPRIGHT",5,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-1,"TOPLEFT",0,1);
                        else
                            icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-2,"BOTTOMRIGHT",1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-1,"BOTTOMRIGHT",1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMLEFT",icon,"BOTTOMLEFT",-1,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPRIGHT",icon,"TOPRIGHT",5,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("BOTTOMRIGHT",b,"BOTTOMLEFT",-1,0);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"TOPRIGHT",0,1);
                else
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMLEFT",-1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMLEFT",icon15,"BOTTOMLEFT",-1,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPRIGHT",icon15,"TOPRIGHT",5,0);
            end
        else
            HealBot_Panel_SetMultiColHoToffset(0)
            if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                HealBot_Panel_SetMultiRowHoToffset((iScale*2)+1)
            else
                HealBot_Panel_SetMultiRowHoToffset(iScale+1)
            end
            if Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]==1 then
                icon1:ClearAllPoints();
                icon1:SetPoint("TOPLEFT",b,"BOTTOMLEFT",1,-1);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMLEFT",icon1,"BOTTOMLEFT",-1,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPRIGHT",icon1,"TOPRIGHT",5,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("TOPLEFT",bar:GetName().."Icon"..x-1,"BOTTOMLEFT",0,-1);
                        else
                            icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-2,"BOTTOMRIGHT",1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMLEFT",bar:GetName().."Icon"..x-1,"BOTTOMRIGHT",1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMLEFT",icon,"BOTTOMLEFT",-1,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPRIGHT",icon,"TOPRIGHT",5,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("TOPRIGHT",b,"BOTTOMRIGHT",-1,-1);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"TOPRIGHT",0,-1);
                else
                    icon16:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMLEFT",-1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMLEFT",icon15,"BOTTOMLEFT",-1,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPRIGHT",icon15,"TOPRIGHT",5,0);
            else
                icon1:ClearAllPoints();
                icon1:SetPoint("TOPRIGHT",b,"BOTTOMRIGHT",-1,-1);
                icon1t:ClearAllPoints();
                icon1t:SetPoint("BOTTOMRIGHT",icon1,"BOTTOMRIGHT",5,0);
                icon1ta:ClearAllPoints();
                icon1ta:SetPoint("TOPLEFT",icon1,"TOPLEFT",-1,0);
                for x=2,14 do
                    icon=_G[bar:GetName().."Icon"..x];
                    icont=_G[bar:GetName().."Count"..x];
                    iconta=_G[bar:GetName().."Count"..x.."a"];
                    icon:ClearAllPoints();
                    if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                        if (x/2)==floor(x/2) then
                            icon:SetPoint("TOPRIGHT",bar:GetName().."Icon"..x-1,"BOTTOMRIGHT",0,-1);
                        else
                            icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-2,"BOTTOMLEFT",-1,0);
                        end
                    else
                        icon:SetPoint("BOTTOMRIGHT",bar:GetName().."Icon"..x-1,"BOTTOMLEFT",-1,0);
                    end
                    icont:ClearAllPoints();
                    icont:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",5,0);
                    iconta:ClearAllPoints();
                    iconta:SetPoint("TOPLEFT",icon,"TOPLEFT",-1,0);
                end
                icon15:ClearAllPoints();
                icon15:SetPoint("TOPLEFT",b,"BOTTOMLEFT",1,-1);
                icon16:ClearAllPoints();
                if Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]==1 then
                    icon16:SetPoint("TOPLEFT",icon15,"BOTTOMRIGHT",0,-1);
                else
                    icon16:SetPoint("BOTTOMLEFT",icon15,"BOTTOMRIGHT",1,0);
                end
                icon15t:ClearAllPoints();
                icon15t:SetPoint("BOTTOMRIGHT",icon15,"BOTTOMRIGHT",5,0); 
                icon15ta:ClearAllPoints();
                icon15ta:SetPoint("TOPLEFT",icon15,"TOPLEFT",-1,0);
            end
        end

        if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]==0 then
            bar3:SetHeight(1);
            bar3:SetValue(0);
            bar3:SetStatusBarColor(0,0,0,0)
        elseif b.guid then 
            HealBot_Action_SetBar3Value(b)
        end
        if Healbot_Config_Skins.ShowAggroBars[Healbot_Config_Skins.Current_Skin]==0 and 
           Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]==0 and
           Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin]==0 then
            bar4:SetMinMaxValues(0,100)
            bar4:SetValue(0)
            bar4:SetStatusBarColor(0,0,0,0)
        end
        barScale = bar:GetScale();
        bar:SetScale(barScale + 0.01);
        bar:SetScale(barScale);
        barScale = bar2:GetScale();
        bar2:SetScale(barScale + 0.01);
        bar2:SetScale(barScale);
        barScale = bar3:GetScale();
        bar3:SetScale(barScale + 0.01);
        bar3:SetScale(barScale);
        barScale = bar4:GetScale();
        bar4:SetScale(barScale + 0.01);
        bar4:SetScale(barScale);
        barScale = bar5:GetScale();
        bar5:SetScale(barScale + 0.01);
        bar5:SetScale(barScale);
        barScale = bar6:GetScale();
        bar6:SetScale(barScale + 0.01);
        bar6:SetScale(barScale);
    elseif barType=="header" then
          --for x=1,15 do
        h=button
        bar = HealBot_Action_HealthBar(h);
        hwidth = ceil(bWidth*Healbot_Config_Skins.headwidth[Healbot_Config_Skins.Current_Skin])
        hheight = ceil((bheight+Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin])*Healbot_Config_Skins.headhight[Healbot_Config_Skins.Current_Skin])
        local headtextoutline = Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]
        HealBot_Panel_SetHeadArrays(h.id)
        h:SetHeight(hheight);
        h:SetWidth(hwidth);
        bar:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]));
        bar:GetStatusBarTexture():SetHorizTile(false)
        bar:SetMinMaxValues(0,100);
        bar:SetValue(100);
        bar:SetStatusBarColor(br,bg,bb,ba);
        bar:SetHeight(hheight);
        bar:SetWidth(hwidth);
        bar.txt = _G[bar:GetName().."_text"];
        bar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin]*frameScale,HealBot_Font_Outline[headtextoutline]);
        bar.txt:SetTextColor(sr,sg,sb,sa);
        h:Disable();
        barScale = bar:GetScale();
        --bar:SetScale(barScale + 0.01);
        --bar:SetScale(barScale);
    elseif barType=="hbfocus" then
        HealBot_Action_hbFocusButtonBar:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
        HealBot_Action_hbFocusButtonBar:GetStatusBarTexture():SetHorizTile(false)

        HealBot_Action_hbFocusButtonBar:SetStatusBarColor(1,1,1,1);
        HealBot_Action_hbFocusButtonBar.txt = _G[HealBot_Action_hbFocusButtonBar:GetName().."_text"];
        HealBot_Action_hbFocusButtonBar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),btextheight,HealBot_Font_Outline[btextoutline]);
        HealBot_Action_hbFocusButtonBar.txt:SetTextColor(0,0,0,1);
        iScale=0.84
        iScale=iScale+(numcols/10)
        HealBot_Action_hbFocusButtonBar:SetWidth(bWidth*iScale)
        HealBot_Action_hbFocusButton:SetWidth(bWidth*iScale)
        HealBot_Action_hbFocusButtonBar:SetHeight(bheight); 
        HealBot_Action_hbFocusButton:SetHeight(bheight); 
        HealBot_Action_hbFocusButtonBar.txt:SetText(HEALBOT_ACTION_HBFOCUS)
        barScale = HealBot_Action_hbFocusButtonBar:GetScale();
        --HealBot_Action_hbFocusButtonBar:SetScale(barScale + 0.01);
        --HealBot_Action_hbFocusButtonBar:SetScale(barScale);
    else
        HealBot_Action_SetAddHeightWidth()
        HealBot_Panel_clearResetHeaderSkinDone()
        HealBot_Action_clearResetBarSkinDone()
        HealBot_Action_sethbNumberFormat()
        HealBot_setOptions_Timer(85)
        if HealBot_resetSkinTo~=Healbot_Config_Skins.Current_Skin then
            HealBot_resetSkinTo=Healbot_Config_Skins.Current_Skin
            HealBot_Options_RaidTargetUpdate()
            for x=1,10 do
                local gaf = _G["f"..x.."_HealBot_Action"]
                HealBot_CheckFrame(x, gaf)
            end
        end
        if HealBot_Data["REFRESH"]<1 then 
            HealBot_Data["REFRESH"]=1; 
        end
    end
end

local curBucket=-15
function HealBot_Action_RefreshButtons(button)
    if button then
        HealBot_Action_RefreshButton(button)
    else
        curBucket=curBucket+1
        if curBucket>3 then curBucket=1 end
        for _,xButton in pairs(HealBot_Unit_Button) do
            if xButton.refresh==curBucket then
                HealBot_Action_CheckRange(xButton)
            end
        end
    end
end

function HealBot_Action_CheckAggro()
    --if HealBot_Data["UILOCK"]=="YES" then
    --    for xUnit,xButton in pairs(HealBot_Unit_Button) do
    --        HealBot_CheckUnitAggro(xUnit)
    --    end
    --else
        for xUnit,_ in pairs(HealBot_UnitAggro) do
            if not HealBot_CheckUnitAggro(xUnit) then
                HealBot_UnitAggro[xUnit]=nil
            end
        end
    --end
end

function HealBot_Action_CheckRange(button)
    local unit=button.unit
    if not HealBot_UnitStatus[unit] then return end
    if HealBot_UnitStatus[unit]>0 then
        local uRange=HealBot_UnitInRange(HealBot_UnitRangeSpell[unit] or HealBot_hSpell, unit)
        if unit~="player" and HealBot_UnitStatus[unit]==8 and (UnitHealth(unit) or 2)>1 then 
            HealBot_OnEvent_UnitHealth(nil,unit,UnitHealth(unit),UnitHealthMax(unit)) 
        end
        if HealBot_UnitRange[unit]==-2 then
            --HealBot_AddDebug("HealBot_UnitRange[unit]==-2 unit="..unit)
            HealBot_Action_RefreshButton(button)
        elseif uRange~=HealBot_UnitRange[unit] then
            local uHealIn, uAbsorbs = HealBot_IncHeals_retHealsIn(unit)
            local ebubar,ebubar2,ebubar6,ebuicon15=nil,nil,nil,nil
            local uHealIn, uAbsorbs = HealBot_IncHeals_retHealsIn(unit)
            ebubar = HealBot_Action_HealthBar(button)
            ebubar2 = HealBot_Action_HealthBar2(button)
            ebubar6 = HealBot_Action_HealthBar6(button)
            ebubar.txt=_G[ebubar:GetName().."_text"];
            ebuicon15 = _G[ebubar:GetName().."Icon15"];
            HealBot_UnitRange[unit]=uRange
            if uHealIn==0 then
                ebubar2:SetStatusBarColor(HealBot_UnitBarsRange["r"][unit],HealBot_UnitBarsRange["g"][unit],HealBot_UnitBarsRange["b"][unit],0);
            end
            if uAbsorbs==0 then
                ebubar6:SetStatusBarColor(HealBot_UnitBarsRange["r"][unit],HealBot_UnitBarsRange["g"][unit],HealBot_UnitBarsRange["b"][unit],0);
            end
            if uRange==1 and not HealBot_PlayerDead then
                ebubar:SetStatusBarColor(HealBot_UnitBarsRange["r"][unit],HealBot_UnitBarsRange["g"][unit],HealBot_UnitBarsRange["b"][unit],Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin])
                if uHealIn>0 then 
                    ebubar2:SetStatusBarColor(HealBot_UnitBarsRange["hr"][unit],HealBot_UnitBarsRange["hg"][unit],HealBot_UnitBarsRange["hb"][unit],Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin]); 
                end
                if uAbsorbs>0 then 
                    ebubar6:SetStatusBarColor(HealBot_UnitBarsRange["sr"][unit],HealBot_UnitBarsRange["sg"][unit],HealBot_UnitBarsRange["sb"][unit],Healbot_Config_Skins.barabsorbcola[Healbot_Config_Skins.Current_Skin]); 
                end
                ebubar.txt:SetTextColor(HealBot_UnitTextRange["ir"][unit],HealBot_UnitTextRange["ig"][unit],HealBot_UnitTextRange["ib"][unit],Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]);
                if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 and not HealBot_retdebuffTargetIcon(unit) then
                    ebuicon15:SetAlpha(Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
                end
                if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]>0 then 
                    HealBot_UnitBarsRange["3a"][unit]=Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]
                    HealBot_Action_SetBar3Value(HealBot_Unit_Button[unit]);
                end
                if Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][button.frame]["AUTO"]==1 then 
                    HealBot_Action_ShowPanel(button.frame) 
                end            
            elseif uRange==0 then
                ebubar:SetStatusBarColor(HealBot_UnitBarsRange["r"][unit],HealBot_UnitBarsRange["g"][unit],HealBot_UnitBarsRange["b"][unit],HealBot_UnitBarsRange["a"][unit])
                if uHealIn>0 then 
                    ebubar2:SetStatusBarColor(HealBot_UnitBarsRange["hr"][unit],HealBot_UnitBarsRange["hg"][unit],HealBot_UnitBarsRange["hb"][unit],HealBot_UnitBarsRange["a"][unit]); 
                end
                if uAbsorbs>0 then 
                    ebubar6:SetStatusBarColor(HealBot_UnitBarsRange["sr"][unit],HealBot_UnitBarsRange["sg"][unit],HealBot_UnitBarsRange["sb"][unit],HealBot_UnitBarsRange["a"][unit]); 
                end
                ebubar.txt:SetTextColor(HealBot_UnitTextRange["ir"][unit],HealBot_UnitTextRange["ig"][unit],HealBot_UnitTextRange["ib"][unit],HealBot_UnitTextRange["oa"][unit]);
                if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 and
                   Healbot_Config_Skins.IconAlphaAlEn[Healbot_Config_Skins.Current_Skin]==0 and not HealBot_retdebuffTargetIcon(unit) then
                    ebuicon15:SetAlpha(HealBot_UnitBarsRange["a"][unit]);
                end
                if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]>0 then 
                    HealBot_UnitBarsRange["3a"][unit]=HealBot_UnitBarsRange["a"][unit]
                    HealBot_Action_SetBar3Value(HealBot_Unit_Button[unit]);
                end
            else
                ebubar:SetStatusBarColor(HealBot_UnitBarsRange["r"][unit],HealBot_UnitBarsRange["g"][unit],HealBot_UnitBarsRange["b"][unit],Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin])
                if uHealIn>0 then 
                    ebubar2:SetStatusBarColor(HealBot_UnitBarsRange["hr"][unit],HealBot_UnitBarsRange["hg"][unit],HealBot_UnitBarsRange["hb"][unit],Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]); 
                end
                if uAbsorbs>0 then 
                    ebubar6:SetStatusBarColor(HealBot_UnitBarsRange["sr"][unit],HealBot_UnitBarsRange["sg"][unit],HealBot_UnitBarsRange["sb"][unit],Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]); 
                end
                ebubar.txt:SetTextColor(HealBot_UnitTextRange["or"][unit],HealBot_UnitTextRange["og"][unit],HealBot_UnitTextRange["ob"][unit],Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]);
                if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==1 and Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 and 
                   Healbot_Config_Skins.IconAlphaAlEn[Healbot_Config_Skins.Current_Skin]==0 and not HealBot_retdebuffTargetIcon(unit) then
                    ebuicon15:SetAlpha(Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]);
                end
                if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]>0 then 
                    HealBot_UnitBarsRange["3a"][unit]=Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]
                    HealBot_Action_SetBar3Value(HealBot_Unit_Button[unit]);
                end
            end
        end
    end
end

function HealBot_Action_CheckReserved()
    for xUnit,_ in pairs(HealBot_Reserved) do
        if HealBot_Unit_Button[xUnit] then
            if UnitExists(xUnit) then
                HealBot_UnitNameUpdate(xUnit)
                HealBot_Reserved[xUnit]=nil
            end
        else
            HealBot_Reserved[xUnit]=nil
        end
    end
end

function HealBot_Action_ShowPanel(hbCurFrame)
    if HealBot_Config.DisabledNow==0 then
        local g = _G["f"..hbCurFrame.."_HealBot_Action"]
        if not g:IsVisible() then ShowUIPanel(g) end
    end
end

function HealBot_Action_HidePanel(hbCurFrame)
    local g = _G["f"..hbCurFrame.."_HealBot_Action"]
    if g:IsVisible() then HideUIPanel(g) end
end

function HealBot_Action_ResetUnitStatus(unit)
    if unit then
        HealBot_UnitStatus[unit]=1;
        HealBot_UnitRange[unit]=-2
    else
        for xUnit,_ in pairs(HealBot_Unit_Button) do
            HealBot_UnitStatus[xUnit]=1;
            HealBot_UnitRange[xUnit]=-2
        end
        --HealBot_AddDebug("HealBot_UnitRange for all")
    end
end

function HealBot_Action_ResetActiveUnitStatus()
    for xUnit,xButton in pairs(HealBot_Unit_Button) do
        if HealBot_UnitStatus[xUnit]>0 or UnitHealth(xUnit)<2 then
            HealBot_UnitStatus[xUnit]=1
            HealBot_UnitRange[xUnit]=-2
        end
    end
end

function HealBot_Action_clearResetBarSkinDone()
    for j=1,10 do
        HealBot_ResetBarSkinDone[j]={};
    end
end

function HealBot_Action_SetHealButton(unit,hbGUID,hbCurFrame)
    local shb=nil
    if hbGUID then
        if not HealBot_Unit_Button[unit] then
            shb=HealBot_Action_CreateButton(hbCurFrame)
            if not shb then
                return nil
            else
                HealBot_Unit_Button[unit]="init"
            end
        else
            shb=HealBot_Unit_Button[unit]
        end
        if shb.frame~=hbCurFrame then
            local gp=_G["f"..hbCurFrame.."_HealBot_Action"]
            shb:ClearAllPoints()
            shb:SetParent(gp)
            shb.frame=hbCurFrame
            HealBot_Panel_SetBarArrays(shb.id)
            HealBot_ResetBarSkinDone[shb.frame][shb.id] = nil
            HealBot_initSkin[shb.frame][shb.id]=nil
            --HealBot_Panel_setRefresh()
            --HealBot_Unit_Button[unit]="init"
        end
        if not HealBot_UnitData[hbGUID] or HealBot_UnitData[hbGUID]["SPEC"]==" " then
            if HealBot_UnitData[hbGUID] then 
                HealBot_delClearLocalArr(hbGUID)
            else
                HealBot_UnitData[hbGUID]={}
                HealBot_UnitData[hbGUID]["UNIT"]="init2"
                HealBot_UnitData[hbGUID]["SPEC"] = " "
                HealBot_UnitData[hbGUID]["NAME"] = ""
                HealBot_UnitData[hbGUID]["ROLE"] = HEALBOT_WORDS_UNKNOWN
                HealBot_CheckPlayerMana(hbGUID, unit)
            end
            HealBot_UnitData[hbGUID]["TIME"]=GetTime()
            HealBot_Unit_Button[unit]="init"
        end
        if HealBot_Unit_Button[unit]~=shb or shb.unit~=unit or shb.guid~=hbGUID or shb.reset then
            shb.reset=nil
            shb.unit=unit
            shb.guid=hbGUID
            if (shb.refresh or 0)<1 then
                shb.refresh=HealBot_Action_BalanceRefresh()
            end
            if not shb.debuff then
                shb.buff=false
                shb.debuff={}
                shb.debuff.type=false
                shb.debuff.name=false
                shb.debuff.spellId=false
                shb.bar4state=0
            end
            shb:SetAttribute("unit", unit);
            HealBot_Action_SetAllButtonAttribs(shb,"Enabled")
            HealBot_Unit_Button[unit]=shb
            HealBot_UnitData[hbGUID]["UNIT"]=unit
            HealBot_CheckAllBuffs(unit)
            HealBot_CheckAllDebuffs(unit)
            if not HealBot_Enabled[unit] then HealBot_Enabled[unit]="e" end
            HealBot_CheckHealth(unit)
            HealBot_UnitStatus[unit]=9
            HealBot_UnitRange[unit]=-2
        end
        if not HealBot_ResetBarSkinDone[shb.frame][shb.id] then
            HealBot_Action_ResetSkin("bar",shb)
        end
    else
        return nil
    end
    return shb
end

function HealBot_Action_SetTestButton(hbCurFrame, unitText)
    local thb=HealBot_Action_CreateButton(hbCurFrame)
    if thb then
        thb.unit=unitText
        thb.guid=nil
        thb.bar4state=0
        HealBot_Unit_Button[unitText]=thb
        if thb.frame~=hbCurFrame then
            local gp=_G["f"..hbCurFrame.."_HealBot_Action"]
            thb:ClearAllPoints()
            thb:SetParent(gp)
            thb.frame=hbCurFrame
            HealBot_Panel_SetBarArrays(thb.id)
            --HealBot_ResetBarSkinDone[thb.frame][thb.id] = nil
            --HealBot_initSkin[thb.frame][thb.id]=nil
        end
        if not HealBot_ResetBarSkinDone[thb.frame][thb.id] then
            HealBot_Action_ResetSkin("bar",thb)
        end
    end
    return thb
end

local HealBotButtonMacroAttribs={}
function HealBot_Action_SetAllAttribs()
 --   HealBot_AddDebug("In HealBot_Action_SetAllAttribs")
    HealBot_ResetAttribs=true
    HealBot_Data["REFRESH"]=1
end

local HealBot_Keys_List = {"","Shift","Ctrl","Alt","Alt-Shift","Ctrl-Shift","Alt-Ctrl"}
local hbAttribsMinReset = {}
local HB_button,HB_prefix=nil,nil
function HealBot_Action_SetAllButtonAttribs(button,status)
    for x=1,15 do
  --      HB_button=HealBot_Options_ComboClass_Button(x) ' Cannot use this as 2 returns Middle and 3 returns Right, this function is older than Blizzards secure templates.
        if x==1 then 
            HB_button="Left";
        elseif x==2 then 
            HB_button="Right";
        elseif x==3 then 
            HB_button="Middle";
        elseif x==4 then 
            HB_button="Button4";
        elseif x==5 then 
            HB_button="Button5";
        elseif x==6 then 
            HB_button="Button6";
        elseif x==7 then 
            HB_button="Button7";
        elseif x==8 then 
            HB_button="Button8";
        elseif x==9 then 
            HB_button="Button9";
        elseif x==10 then 
            HB_button="Button10";
        elseif x==11 then
            HB_button="Button11";
        elseif x==12 then
            HB_button="Button12";
        elseif x==13 then
            HB_button="Button13";
        elseif x==14 then
            HB_button="Button14";
        elseif x==15 then
            HB_button="Button15";
        end
    
        for y=1, getn(HealBot_Keys_List), 1 do
            if strlen(HealBot_Keys_List[y])>1 then
                HB_prefix = strlower(HealBot_Keys_List[y]).."-"
            else
                HB_prefix = "";
            end
            if not hbAttribsMinReset[button.frame..button.id..HB_prefix..status..x] then
                HealBot_Action_SetButtonAttrib(button,HB_button,HealBot_Keys_List[y],status,x)
            end
        end
    end
end

--local mUnit=nil
local mText=nil
local showmenu=nil
local showHBmenu=nil
local setDropdown=nil
local partyNo=nil
function HealBot_Action_SetButtonAttrib(button,bbutton,bkey,status,j)
    local HB_prefix = "";
    if strlen(bkey)>1 then
        HB_prefix = strlower(bkey).."-"
    end
    local HB_combo_prefix = bkey..bbutton..HealBot_Config.CurrentSpec;
    local sName,sTar,sTrin1,sTrin2,AvoidBC=nil,0, 0, 0, 0
    if status=="Enabled" then
        sName, sTar, sTrin1, sTrin2, AvoidBC = HealBot_Action_AttribSpellPattern(HB_combo_prefix)
    elseif status=="Disabled" then
        sName, sTar, sTrin1, sTrin2, AvoidBC = HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
    end
    if sName then
        hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=false
        local mId=GetMacroIndexByName(sName)
        if strlower(sName)==strlower(HEALBOT_DISABLED_TARGET) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, "target"..j);
            button:SetAttribute(HB_prefix.."type"..j, "target")
            button:SetAttribute(HB_prefix.."type-target"..j, "target")
            hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
        elseif strlower(sName)==strlower(HEALBOT_FOCUS) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, "focus"..j);
            button:SetAttribute(HB_prefix.."type"..j, "focus")
            button:SetAttribute(HB_prefix.."type-focus"..j, "focus")
            hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
        elseif strlower(sName)==strlower(HEALBOT_ASSIST) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, "assist"..j);
            button:SetAttribute(HB_prefix.."type"..j, "assist")
            button:SetAttribute(HB_prefix.."type-assist"..j, "assist")
            hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
        elseif strlower(sName)==strlower(HEALBOT_STOP) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
            button:SetAttribute(HB_prefix.."type"..j, "macro")
            button:SetAttribute(HB_prefix.."macrotext"..j, "/stopcasting")
            hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
        elseif strsub(strlower(sName),1,4)==strlower(HEALBOT_TELL) then
            local mText='/script local n=UnitName("hbtarget");SendChatMessage("hbMSG","WHISPER",nil,n)'
            mText=string.gsub(mText,"hbtarget",button.unit)
            mText=string.gsub(mText,"hbMSG", strtrim(strsub(sName,5)))
            button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
            button:SetAttribute(HB_prefix.."type"..j, "macro")
            button:SetAttribute(HB_prefix.."macrotext"..j, mText)
            hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
        elseif strlower(sName)==strlower(HEALBOT_MENU) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
            button:SetAttribute(HB_prefix.."type"..j, "showmenu")
            showmenu = function()
                local setDropdown=nil
                if button.unit=="player" then
                    setDropdown=PlayerFrameDropDown
                elseif button.unit=="target" then
                    setDropdown=TargetFrameDropDown
                elseif button.unit=="pet" then
                    setDropdown=PetFrameDropDown
                else
                    local xUnit=HealBot_Action_UnitID(button.unit)
                    local partyNo = tonumber(xUnit:match('party(%d+)')) or 0
                    if partyNo > 0 then
                        setDropdown = _G['PartyMemberFrame' .. partyNo .. 'DropDown']
                    else
                        partyNo = tonumber(xUnit:match('raid(%d+)')) or 0
                        if partyNo == 0 then
                            partyNo=button.id
                        end
                        FriendsDropDown.name = UnitName(xUnit);    
                        FriendsDropDown.id = partyNo;    
                        FriendsDropDown.unit = xUnit;    
                        FriendsDropDown.initialize = RaidFrameDropDown_Initialize;    
                        FriendsDropDown.displayMode = "MENU";    
                        setDropdown=FriendsDropDown
                    end
                end
                ToggleDropDownMenu(1, nil, setDropdown, "cursor", 10, -8)  
            end
            button.showmenu = showmenu 
        elseif strlower(sName)==strlower(HEALBOT_HBMENU) and HealBot_UnitGUID(button.unit) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
            button:SetAttribute(HB_prefix.."type"..j, "showhbmenu")
            showHBmenu = function()
                local HBFriendsDropDown = CreateFrame("Frame", "HealBot_Action_hbmenuFrame_DropDown", UIParent, "UIDropDownMenuTemplate");
                HBFriendsDropDown.unit = button.unit
                HBFriendsDropDown.name = UnitName(button.unit)
                HBFriendsDropDown.initialize = HealBot_Action_hbmenuFrame_DropDown_Initialize
                HBFriendsDropDown.displayMode = "MENU"
                ToggleDropDownMenu(1, nil, HBFriendsDropDown, "cursor", 10, -8)
            end
            button.showhbmenu = showHBmenu
        elseif HealBot_GetSpellId(sName) then
            if sTar==1 or sTrin1==1 or sTrin2==1 or AvoidBC==1 then
                local mText = HealBot_Action_AlterSpell2Macro(sName, sTar, sTrin1, sTrin2, AvoidBC, button.unit, HB_combo_prefix)
                button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
                button:SetAttribute(HB_prefix.."type"..j,"macro")
                button:SetAttribute(HB_prefix.."macrotext"..j, mText)
            else
                button:SetAttribute(HB_prefix.."helpbutton"..j, "heal"..j);
                button:SetAttribute(HB_prefix.."type-heal"..j, "spell");
                button:SetAttribute(HB_prefix.."spell-heal"..j, sName);
                hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
            end
        elseif mId ~= 0 then
            local _,_,mText=GetMacroInfo(mId)
 --        mUnit = button.unit
            if UnitExists(HealBot_UnitPet(button.unit)) then
                mText=string.gsub(mText,"hbtargetpet",HealBot_UnitPet(button.unit))
            end
            mText=string.gsub(mText,"hbtargettargettarget",button.unit.."targettarget")
            mText=string.gsub(mText,"hbtargettarget",button.unit.."target")
            mText=string.gsub(mText,"hbtarget",button.unit)
            button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
            button:SetAttribute(HB_prefix.."type"..j,"macro")
            button:SetAttribute(HB_prefix.."macrotext"..j, mText)
            if status=="Enabled" then
                HealBotButtonMacroAttribs[HB_prefix..j]=sName
            end
        elseif IsUsableItem(sName) then
            button:SetAttribute(HB_prefix.."helpbutton"..j, "item"..j);
            button:SetAttribute(HB_prefix.."type-item"..j, "item");
            button:SetAttribute(HB_prefix.."item-item"..j, sName);
        else
            if sTar==1 or sTrin1==1 or sTrin2==1 or AvoidBC==1 then
                local mText = HealBot_Action_AlterSpell2Macro(sName, sTar, sTrin1, sTrin2, AvoidBC, button.unit, HB_combo_prefix)
                button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
                button:SetAttribute(HB_prefix.."type"..j,"macro")
                button:SetAttribute(HB_prefix.."macrotext"..j, mText)
            else
                button:SetAttribute(HB_prefix.."helpbutton"..j, "heal"..j);
                button:SetAttribute(HB_prefix.."type-heal"..j, "spell");
                button:SetAttribute(HB_prefix.."spell-heal"..j, sName);
                hbAttribsMinReset[button.frame..button.id..HB_prefix..status..j]=true
            end
        end
        button:SetAttribute(HB_prefix.."checkselfcast"..j, "false")
    else
        button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
    end
end

function HealBot_Action_SethbFocusButtonAttrib(button)
    button:SetAttribute("unit", "target")
    button:SetAttribute("helpbutton1", "focus1");
    button:SetAttribute("type1", "focus")
    button:SetAttribute("type-focus1", "focus")
end

local smName={}
function HealBot_Action_AlterSpell2Macro(spellName, spellTar, spellTrin1, spellTrin2, spellAvoidBC, unit, combo)
    if not smName[combo..unit] then
        local sysSoundSFX = strsub(GetCVar("Sound_EnableSFX") or "nil",1,1)
        smName[combo..unit]=""
        if HealBot_Globals.MacroSuppressSound==1 and sysSoundSFX=="1" then smName[combo..unit]=smName[combo..unit].."/console Sound_EnableSFX 0;\n" end
        if HealBot_Globals.MacroSuppressError==1 then smName[combo..unit]=smName[combo..unit].."/script UIErrorsFrame:Hide();\n" end
        if spellTar==1 then smName[combo..unit]=smName[combo..unit].."/target "..unit..";\n" end
        if spellTrin1==1 then smName[combo..unit]=smName[combo..unit].."/use 13;\n" end
        if spellTrin2==1 then smName[combo..unit]=smName[combo..unit].."/use 14;\n" end
        if HealBot_Config.MacroUse10==1 then smName[combo..unit]=smName[combo..unit].."/use 10;\n" end
        if HealBot_Globals.MacroSuppressError==1 then smName[combo..unit]=smName[combo..unit].."/script UIErrorsFrame:Clear(); UIErrorsFrame:Show();\n" end
        if HealBot_Globals.MacroSuppressSound==1 and sysSoundSFX=="1" then smName[combo..unit]=smName[combo..unit].."/console Sound_EnableSFX 1;\n" end
        smName[combo..unit]=smName[combo..unit].."/cast [@"..unit.."] "..spellName..";\n"
        if spellAvoidBC==1 then smName[combo..unit]=smName[combo..unit].."/use 4;" end
        if strlen(smName[combo..unit])>255 then
            smName[combo..unit]=""
            if HealBot_Globals.MacroSuppressSound==1 and sysSoundSFX=="1" then smName[combo..unit]=smName[combo..unit].."/console Sound_EnableSFX 0;\n" end
            if spellTar==1 then smName[combo..unit]=smName[combo..unit].."/target "..UnitName(unit)..";\n" end
            if spellTrin1==1 then smName[combo..unit]=smName[combo..unit].."/use 13;\n" end
            if spellTrin2==1 then smName[combo..unit]=smName[combo..unit].."/use 14;\n" end
            if HealBot_Config.MacroUse10==1 then smName[combo..unit]=smName[combo..unit].."/use 10;\n" end
            if HealBot_Globals.MacroSuppressSound==1 and sysSoundSFX=="1" then smName[combo..unit]=smName[combo..unit].."/console Sound_EnableSFX 1;\n" end
            smName[combo..unit]=smName[combo..unit].."/cast [@"..unit.."] "..spellName..";\n"
            if spellAvoidBC==1 then smName[combo..unit]=smName[combo..unit].."/use 4;" end
            if strlen(smName[combo..unit])>255 then
                smName[combo..unit]=""
                if spellTar==1 then smName[combo..unit]=smName[combo..unit].."/target "..UnitName(unit)..";\n" end
                if spellTrin1==1 then smName[combo..unit]=smName[combo..unit].."/use 13;\n" end
                if spellTrin2==1 then smName[combo..unit]=smName[combo..unit].."/use 14;\n" end
                if HealBot_Config.MacroUse10==1 then smName[combo..unit]=smName[combo..unit].."/use 10;\n" end
                smName[combo..unit]=smName[combo..unit].."/cast [@"..unit.."] "..spellName..";\n"
                if spellAvoidBC==1 then smName[combo..unit]=smName[combo..unit].."/use 4;" end
                if strlen(smName[combo..unit])>255 then
                    smName[combo..unit]=spellName
                end
            end
        end
    end
    return smName[combo..unit]
end

function HealBot_Action_hbmenuFrame_DropDown_Initialize(self,level)
    local info
    level = level or 1;
    if level==1 then
 
        info = UIDropDownMenu_CreateInfo();
        info.isTitle = 1
        info.text = self.name
        UIDropDownMenu_AddButton(info, 1);
        
        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        if HealBot_Action_RetMyTarget(HealBot_UnitGUID(self.unit)) then
            info.text = HEALBOT_SKIN_DISTEXT;
        else
            info.text = HEALBOT_SKIN_ENTEXT;
        end
        info.func = function() HealBot_Action_Toggle_Enabled(self); end
        UIDropDownMenu_AddButton(info, 1);

        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        if HealBot_Panel_RetMyHealTarget(self.guid) then
            info.text = HEALBOT_WORDS_REMOVEFROM.." "..HEALBOT_OPTIONS_TARGETHEALS;
        else
            info.text = HEALBOT_WORDS_ADDTO.." "..HEALBOT_OPTIONS_TARGETHEALS
        end
        info.func = function() HealBot_Panel_ToggelHealTarget(self); end;
        UIDropDownMenu_AddButton(info, 1);
        
        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        if HealBot_Panel_RetPrivateTanks(HealBot_UnitGUID(self.unit)) then
            info.text = HEALBOT_WORDS_REMOVEFROM.." "..HEALBOT_OPTIONS_PRIVATETANKS;
        else
            info.text = HEALBOT_WORDS_ADDTO.." "..HEALBOT_OPTIONS_PRIVATETANKS
        end
        info.func = function() HealBot_Panel_ToggelPrivateTanks(self); end;
        UIDropDownMenu_AddButton(info, 1);

        info = UIDropDownMenu_CreateInfo();
        info.notCheckable = true;
        if HealBot_retHbFocus(self.name) then
            info.text = HEALBOT_WORD_CLEAR.." "..HEALBOT_WORD_HBFOCUS;
            info.hasArrow = false;
            info.func = function() HealBot_ToggelFocusMonitor(self.name); end;
        else
            info.text = HEALBOT_WORD_SET.." "..HEALBOT_WORD_HBFOCUS
            info.hasArrow = true; 
        end
        UIDropDownMenu_AddButton(info, 1);
        
        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        info.text = HEALBOT_WORD_RESET
        info.func = function() HealBot_Reset_Unit(self); end
        UIDropDownMenu_AddButton(info, 1);
        
        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        info.text = HEALBOT_PANEL_BLACKLIST
        info.func = function() HealBot_Panel_AddBlackList(HealBot_UnitGUID(self.unit)); end
        UIDropDownMenu_AddButton(info, 1);
        
        info = UIDropDownMenu_CreateInfo();
        info.hasArrow = false; 
        info.notCheckable = true;
        info.text = HEALBOT_WORD_CANCEL
        UIDropDownMenu_AddButton(info, 1);
    end
    if level==2 then
        info = UIDropDownMenu_CreateInfo();
        info.text = HEALBOT_WORD_ALLZONE
        info.hasArrow = false; 
        info.notCheckable = true;
        info.func = function() HealBot_ToggelFocusMonitor(self.name, "all"); end;
        UIDropDownMenu_AddButton(info, 2);
        
        info = UIDropDownMenu_CreateInfo();
        local _,z = IsInInstance()
        if z=="pvp" or z == "arena" then 
            z = "bg"
            info.text = HEALBOT_WORD_BATTLEGROUND
        elseif z~="none" then
            z = GetRealZoneText()
            info.text=z
        else
            info.text = HEALBOT_WORD_OUTSIDE
        end
        info.hasArrow = false; 
        info.notCheckable = true;
        info.func = function() HealBot_ToggelFocusMonitor(self.name, z); end;
        UIDropDownMenu_AddButton(info, 2);
    end
end

function HealBot_Action_UnitID(unit)
    if strsub(unit,1,4)=="raid" then
        if UnitIsUnit(unit,"party1") then
            unit="party1"
        elseif UnitIsUnit(unit,"party2") then
            unit="party2"
        elseif UnitIsUnit(unit,"party3") then
            unit="party3"
        elseif UnitIsUnit(unit,"party4") then
            unit="party4"
        end
    end
    return unit
end

function HealBot_Action_AttribSpellPattern(HB_combo_prefix)
    local hbCombos = HealBot_Config.EnabledKeyCombo
    local hbTarget = HealBot_Config.EnabledSpellTarget
    local hbTrinket1 = HealBot_Config.EnabledSpellTrinket1
    local hbTrinket2 = HealBot_Config.EnabledSpellTrinket2
    local hbAvoidBC  = HealBot_Config.EnabledAvoidBlueCursor
    if not hbCombos then 
        return nil 
    end
    return hbCombos[HB_combo_prefix], hbTarget[HB_combo_prefix] or 0, hbTrinket1[HB_combo_prefix] or 0, hbTrinket2[HB_combo_prefix] or 0, hbAvoidBC[HB_combo_prefix] or 0
end

function HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
    local hbCombos = HealBot_Config.DisabledKeyCombo
    local hbTarget = HealBot_Config.DisabledSpellTarget
    local hbTrinket1 = HealBot_Config.DisabledSpellTrinket1
    local hbTrinket2 = HealBot_Config.DisabledSpellTrinket2
    local hbAvoidBC  = HealBot_Config.DisabledAvoidBlueCursor
    if not hbCombos then 
        return nil 
    end
    return hbCombos[HB_combo_prefix], hbTarget[HB_combo_prefix] or 0, hbTrinket1[HB_combo_prefix] or 0, hbTrinket2[HB_combo_prefix] or 0, hbAvoidBC[HB_combo_prefix] or 0
end

local hbInitButtons=false
function HealBot_Action_ResethbInitButtons()
    hbInitButtons=false
end

function HealBot_Action_PartyChanged(HealBot_PreCombat, disableHealBot)
    if HealBot_Config.DisabledNow==1 and not disableHealBot then return end
    if InCombatLockdown() then 
        HealBot_Data["UILOCK"]="YES"
    elseif HealBot_Data["UILOCK"]=="YES" then 
        HealBot_PreCombat=true
        HealBot_Data["UILOCK"]="NO"
    end
    if HealBot_Data["UILOCK"]=="NO" and HealBot_Data["PGUID"] then
        if not HealBot_PreCombat and HealBot_ResetAttribs then
            for x,xButton in pairs(HealBot_Unit_Button) do
                xButton.reset="init";
            end
            for x,_ in pairs(HealBotButtonMacroAttribs) do
                HealBotButtonMacroAttribs[x]=nil;
            end
            for x,_ in pairs(smName) do
                smName[x]=nil;
            end
            for x,_ in pairs(hbAttribsMinReset) do
                hbAttribsMinReset[x]=nil;
            end
            HealBot_ResetAttribs=nil
        end
        if not hbInitButtons then
            for xUnit,xButton in pairs(HealBot_Unit_Button) do
                HealBot_Action_DeleteButton(xButton.id)
            end 
            hbInitButtons=true
        end
        
        if HealBot_PreCombat then 
            HealBot_EnteringCombat()
        end
  
        if Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin]==1 then
            HealBot_Panel_PartyChanged(true, disableHealBot, HealBot_PreCombat)
        else
            HealBot_Panel_PartyChanged(false, disableHealBot, HealBot_PreCombat)
        end
    
        for xUnit,xButton in pairs(HealBot_Unit_Button) do
            if HealBot_UnitStatus[xUnit]==9 then
                HealBot_Action_ResetUnitStatus(xUnit)
            end
        end
    elseif HealBot_Data["REFRESH"]<2 then 
        HealBot_Data["REFRESH"]=2; 
    end
end

function HealBot_Action_CreateButton(hbCurFrame)
    if HealBot_ActiveButtons[0]>998 then HealBot_ActiveButtons[0]=1 end
    local tryId,freeId=HealBot_ActiveButtons[0],nil
    if not HealBot_ActiveButtons[tryId] then
        freeId=tryId
    else
        for i=1,998 do
            if not HealBot_ActiveButtons[i] then
                freeId=i
                break
            end
        end
    end
    if freeId then 
        HealBot_ActiveButtons[freeId]=true 
        local gn="HealBot_Action_HealUnit"..freeId
        local gp=_G["f"..hbCurFrame.."_HealBot_Action"]
        local ghb=_G[gn]
        if not ghb then 
            ghb=CreateFrame("Button", gn, gp, "HealBotButtonSecureTemplate") 
            HealBot_Action_setRegisterForClicks(ghb)
            ghb.frame=hbCurFrame
            ghb.id=freeId
        elseif ghb.frame~=hbCurFrame then
            ghb.frame=0
        end
        ghb.guid="nil"
        ghb.unit="nil"
        HealBot_ActiveButtons[0]=freeId+1
        return ghb
    else
        return nil
    end
end

local ctlBuckets={[1]=0, [2]=0, [3]=0}
function HealBot_Action_BalanceRefresh()
    local nextBucket=1
    if ctlBuckets[3]<ctlBuckets[2] then
        if ctlBuckets[3]<ctlBuckets[1] then 
            nextBucket=3
        end
    elseif ctlBuckets[3]<ctlBuckets[1] then
        nextBucket=2
    elseif ctlBuckets[2]<ctlBuckets[1] then 
        nextBucket=2
    end
    ctlBuckets[nextBucket]=ctlBuckets[nextBucket]+1
    return nextBucket
end

function HealBot_Action_DeleteButton(hbBarID)
    local dg=_G["HealBot_Action_HealUnit"..hbBarID]
    local dbUnit=dg.unit or "N"
    local dbGUID=dg.guid or "0"
    HealBot_HoT_RemoveIconButton(dg,true)
    HealBot_Action_ClearUnitDebuffStatus(dbUnit)
    HealBot_Action_UpdateAggro(dbUnit,false,nil,0)
    HealBot_Aggro[dbUnit]=nil
    local bar4=HealBot_Action_HealthBar4(dg)
    bar4:SetStatusBarColor(1,0,0,0)
    dg.bar4state=0
    if HealBot_AggroIndicator[dbUnit] then
        HealBot_AggroIndicator[dbUnit]=nil
        HealBot_Action_aggoIndicatorUpd(dbUnit, 0)
    end
    if HealBot_UnitData[dbGUID] then HealBot_UnitData[dbGUID]["SPEC"] = " " end
    HealBot_Unit_Button[dbUnit]=nil
    dg.guid="nil"
    dg.unit="nil"
    HealBot_UnitStatus[dbUnit]=nil
    HealBot_UnitRange[dbUnit]=nil
    if (dg.refresh or 0)>0 then ctlBuckets[dg.refresh]=ctlBuckets[dg.refresh]-1 end
    dg.buff=false
    dg.debuff={}
    dg.debuff.type=false
    dg.debuff.name=false
    dg.debuff.spellId=false
    dg.refresh=0
    dg:Hide();
    HealBot_ActiveButtons[hbBarID]=false
    if hbBarID<HealBot_ActiveButtons[0] then HealBot_ActiveButtons[0]=hbBarID end
    HealBot_Panel_SetBarArrays(hbBarID)
end

function HealBot_Action_Reset()
    local screenWidth = (ceil(GetScreenWidth()/2)) or 700
    local screenHeight = (ceil(GetScreenHeight()/2)) or 500
    for i=1, 10 do
        Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][i]["X"]=screenWidth-(-100+(i*10))
        Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][i]["Y"]=screenHeight-(-50+(i*10))
        Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][i]["AUTO"]=0
        if HealBot_Config.DisabledNow==0 and HealBot_Config.ActionVisible[i]==1 then
            HealBot_Action_setPoint(i)
            HealBot_Action_ShowPanel(i)
        end
        HealBot_Action_unlockFrame(i)
    end
end

function HealBot_Action_unlockFrame(hbCurFrame)
    Healbot_Config_Skins.FrameLocked[Healbot_Config_Skins.Current_Skin][hbCurFrame]=0
    HealBot_Options_ActionLocked:SetChecked(Healbot_Config_Skins.FrameLocked[Healbot_Config_Skins.Current_Skin][hbCurFrame])
end

function HealBot_Action_setPoint(hbCurFrame)
    if not hbCurFrame then return end
    local gaf=_G["f"..hbCurFrame.."_HealBot_Action"]

    if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==1 then
        gaf:ClearAllPoints();
        gaf:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==2 then
        gaf:ClearAllPoints();
        gaf:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==3 then
        gaf:ClearAllPoints();
        gaf:SetPoint("TOPRIGHT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==4 then
        gaf:ClearAllPoints();
        gaf:SetPoint("BOTTOMRIGHT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==5 then
        gaf:ClearAllPoints();
        gaf:SetPoint("TOP","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==6 then
        gaf:ClearAllPoints();
        gaf:SetPoint("LEFT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==7 then
        gaf:ClearAllPoints();
        gaf:SetPoint("RIGHT","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FRAME"]==8 then
        gaf:ClearAllPoints();
        gaf:SetPoint("BOTTOM","UIParent","BOTTOMLEFT",Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["X"],Healbot_Config_Skins.AnchorXY[Healbot_Config_Skins.Current_Skin][hbCurFrame]["Y"]);
    end
end

local hbClassCols = {
          ["DRUI"] = {r=1.0,  g=0.49, b=0.04, },
          ["HUNT"] = {r=0.67, g=0.83, b=0.45, },
          ["MAGE"] = {r=0.41, g=0.8,  b=0.94, },
          ["MONK"] = {r=0.0,  g=1.0,  b=0.59, },
          ["PALA"] = {r=0.96, g=0.55, b=0.73, },
          ["PRIE"] = {r=1.0,  g=1.0,  b=1.0,  },
          ["ROGU"] = {r=1.0,  g=0.96, b=0.41, },
          ["SHAM"] = {r=0.14, g=0.35, b=1.0,  },
          ["WARL"] = {r=0.58, g=0.51, b=0.79, },
          ["DEAT"] = {r=0.78, g=0.04, b=0.04, },
          ["WARR"] = {r=0.78, g=0.61, b=0.43, },
      }
      
function HealBot_Action_ClassColour(unit)
    local xClass=nil
    if unit and UnitClass(unit) then
        _,xClass=UnitClass(unit)    
    end
    if xClass then
        xClass = strsub(xClass,1,4)
    else
        xClass = "WARR"
    end
    return hbClassCols[xClass].r, hbClassCols[xClass].g, hbClassCols[xClass].b
end

function HealBot_Action_HideTooltip(self)
    if HealBot_Data["TIPUNIT"] then
        HealBot_Data["TIPUNIT"] = false;
        HealBot_Data["TIPTYPE"] = "NONE";
        HealBot_Action_HideTooltipFrame()
    end
    HealBot_Data["INSPECT"]=false
end

function HealBot_Action_HideTooltipFrame()
    if HealBot_Data["TIPUSE"]=="YES" then
        if HealBot_Globals.UseGameTooltip==1 then
            GameTooltip:Hide();
        else
            HealBot_Tooltip:Hide();
        end
    end
end

function HealBot_Action_Refresh(unit)
    if unit and HealBot_Unit_Button[unit] then
        local xButton=HealBot_Unit_Button[unit]
        if HealBot_PlayerDead then
            if Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][xButton.frame]["AUTO"]==1 and HealBot_Data["UILOCK"]=="NO" then
                HealBot_Action_HidePanel(xButton.frame); 
            else
                HealBot_Action_RefreshButtons(xButton);
            end
            return;
        end
        HealBot_Action_RefreshButtons(xButton);
        if HealBot_Data["UILOCK"]=="NO" then
            if HealBot_Config.ActionVisible[xButton.frame]==0 and HealBot_Config.DisabledNow==0 then
                if HealBot_Action_ShouldHealSome(unit, xButton.frame) then
                    HealBot_Action_ShowPanel(xButton.frame);
                end
            elseif Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][xButton.frame]["AUTO"]==1 then 
                if not HealBot_Action_ShouldHealSome(unit, xButton.frame) then
                    HealBot_Action_HidePanel(xButton.frame);
                end
            end
        end
    end
end

local hbLastButton=nil
function HealBot_Action_HealUnit_OnEnter(self)
    if not self.unit then return; end
    if HealBot_Globals.ShowTooltip==1 and HealBot_Data["TIPUSE"]=="YES" and UnitExists(self.unit) then
        HealBot_Data["TIPUNIT"] = self.unit
        if HealBot_Data["UILOCK"]=="YES" and HealBot_Globals.DisableToolTipInCombat==0 then
            HealBot_Data["TIPTYPE"] = "Enabled"
            HealBot_Action_RefreshTooltip();
        elseif UnitAffectingCombat(self.unit)==1 then
            HealBot_Data["TIPTYPE"] = "Enabled"
            HealBot_Action_RefreshTooltip();
        elseif HealBot_Enabled[self.unit]=="e" or HealBot_Config.EnableHealthy==1 then 
            HealBot_Data["TIPTYPE"] = "Enabled"
            HealBot_Action_RefreshTooltip();
        elseif not HealBot_PlayerDead then
            HealBot_Data["TIPTYPE"] = "Disabled"
            HealBot_Action_RefreshTooltip();
        end
    end
    if Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]==1 and not UnitIsDeadOrGhost(self.unit) and HealBot_retHighlightTarget()~=self.unit then
        local z=false
        if HealBot_Data["UILOCK"]=="YES" then
            if Healbot_Config_Skins.HighLightActiveBarInCombat[Healbot_Config_Skins.Current_Skin]==1 then z=true end
        else
            z=true
        end
        if z then
            HealBot_Action_UpdateAggro(self.unit,"highlight",HealBot_UnitThreat[self.unit] or 0, HealBot_UnitThreatPct[self.unit])
        end
    end
    hbLastButton=self
   -- SetOverrideBindingClick(HealBot_Action,true,"MOUSEWHEELUP", "HealBot_Action_HealUnit"..self.id,"Button4");
   -- SetOverrideBindingClick(HealBot_Action,true,"MOUSEWHEELDOWN", "HealBot_Action_HealUnit"..self.id,"Button5");
end

function HealBot_Action_HealUnit_OnLeave(self)
    HealBot_Action_HideTooltip(self);
    local xUnit=self.unit
    if Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]==1 and HealBot_Hightlight[xUnit] and HealBot_Hightlight[xUnit]=="M" then
        if HealBot_Aggro[xUnit] and HealBot_Aggro[xUnit]=="h" then
            HealBot_Action_UpdateAggro(self.unit,"off",HealBot_UnitThreat[xUnit] or 0, 0)
        end
    end
    hbLastButton=nil
   -- ClearOverrideBindings(HealBot_Action)
end

local HealBot_MouseWheelCmd=nil

function HealBot_Action_HealUnit_Wheel(self, delta)
    local xButton=hbLastButton
    if not xButton then return end
    local xUnit=xButton.unit
    if not UnitExists(xUnit) then return end
    local y="None"
    if IsShiftKeyDown() then
        if not IsControlKeyDown() and not IsAltKeyDown() then 
            y="Shift" 
        else
            y=""
        end
    elseif IsControlKeyDown() then
        if not IsShiftKeyDown() and not IsAltKeyDown() then 
            y="Ctrl" 
        else
            y=""
        end

    elseif IsAltKeyDown() then
        if not IsControlKeyDown() and not IsShiftKeyDown() then 
            y="Alt" 
        else
            y=""
        end
    end    
    if delta>0 then
        y=y.."Up"
    else
        y=y.."Down"
    end
    if HealBot_Globals.HealBot_MouseWheelTxt[y] then
        HealBot_MouseWheelCmd=HealBot_Globals.HealBot_MouseWheelTxt[y]
    else
        HealBot_MouseWheelCmd=HEALBOT_WORDS_NONE
    end
    
    if HealBot_MouseWheelCmd==HEALBOT_BLIZZARD_MENU then
        if xUnit=="player" then
            setDropdown=PlayerFrameDropDown
        elseif xUnit=="target" then
            setDropdown=TargetFrameDropDown
        elseif xUnit=="pet" then
            setDropdown=PetFrameDropDown
        else
            partyNo = tonumber(xUnit:match('party(%d+)')) or 0
            if partyNo > 0 then
                setDropdown = _G['PartyMemberFrame' .. partyNo .. 'DropDown']
            else
                partyNo = tonumber(strmatch(xUnit, "(%d+)"))
                FriendsDropDown.name = UnitName(xUnit);    
                FriendsDropDown.id = partyNo;    
                FriendsDropDown.unit = xUnit;    
                FriendsDropDown.initialize = RaidFrameDropDown_Initialize;    
                FriendsDropDown.displayMode = "MENU";    
                setDropdown=FriendsDropDown
            end
        end
        ToggleDropDownMenu(1, nil, setDropdown, "cursor", 10, -8)  
    elseif HealBot_MouseWheelCmd==HEALBOT_HB_MENU then
        local HBFriendsDropDown = CreateFrame("Frame", "HealBot_Action_hbmenuFrame_DropDown", UIParent, "UIDropDownMenuTemplate");
        HBFriendsDropDown.unit = xUnit
        HBFriendsDropDown.name = UnitName(xUnit)
        HBFriendsDropDown.initialize = HealBot_Action_hbmenuFrame_DropDown_Initialize
        HBFriendsDropDown.displayMode = "MENU"
        ToggleDropDownMenu(1, nil, HBFriendsDropDown, "cursor", 10, -8)
    elseif HealBot_MouseWheelCmd==HEALBOT_FOLLOW then
        FollowUnit(xUnit)
    elseif HealBot_MouseWheelCmd==HEALBOT_TRADE then
        InitiateTrade(xUnit)
    elseif HealBot_MouseWheelCmd==HEALBOT_PROMOTE_RA then
        PromoteToAssistant(xUnit)
    elseif HealBot_MouseWheelCmd==HEALBOT_DEMOTE_RA then
        DemoteAssistant(xUnit)
    elseif HealBot_MouseWheelCmd==HEALBOT_TOGGLE_ENABLED then
        HealBot_Action_Toggle_Enabled(xButton)
    elseif HealBot_MouseWheelCmd==HEALBOT_TOGGLE_MYTARGETS then
        HealBot_Panel_ToggelHealTarget(xButton)
    elseif HealBot_MouseWheelCmd==HEALBOT_TOGGLE_PRIVATETANKS then
        HealBot_Panel_ToggelPrivateTanks(xButton)
    elseif HealBot_MouseWheelCmd==HEALBOT_RESET_BAR then
        HealBot_Reset_Unit(xButton)
    elseif HealBot_MouseWheelCmd==HEALBOT_RANDOMMOUNT and UnitIsUnit(xUnit,"player") and not UnitAffectingCombat("player") then
        HealBot_MountsPets_ToggelMount("all")
    elseif HealBot_MouseWheelCmd==HEALBOT_RANDOMGOUNDMOUNT and UnitIsUnit(xUnit,"player") and not UnitAffectingCombat("player") then
        HealBot_MountsPets_ToggelMount("ground")
    elseif HealBot_MouseWheelCmd==HEALBOT_RANDOMPET and UnitIsUnit(xUnit,"player") then
        HealBot_MountsPets_RandomPet()   
    end

end

function HealBot_Action_OptionsButton_OnClick(self)
    HealBot_TogglePanel(HealBot_Options);
end

function HealBot_Action_OnLoad(self)
    self:SetScript("PreClick", HealBot_Action_PreClick); 
    self:SetScript("PostClick", HealBot_Action_PostClick)
end

function HealBot_Action_setRegisterForClicks(button)
    if button then
        if HealBot_Config.ButtonCastMethod==1 then
            button:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown", "Button4Down", "Button5Down",
                                        "Button6Down", "Button7Down", "Button8Down", "Button9Down", "Button10Down",
                                       "Button11Down", "Button12Down", "Button13Down", "Button14Down", "Button15Down");
        else
            button:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp", "Button4Up", "Button5Up",
                                        "Button6Up", "Button7Up", "Button8Up", "Button9Up", "Button10Up",
                                        "Button11Up", "Button12Up", "Button13Up", "Button14Up", "Button15Up");
        end
    else
        if HealBot_Config.ButtonCastMethod==1 then
            for _,xButton in pairs(HealBot_Unit_Button) do
                xButton:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown", "Button4Down", "Button5Down",
                                        "Button6Down", "Button7Down", "Button8Down", "Button9Down", "Button10Down",
                                       "Button11Down", "Button12Down", "Button13Down", "Button14Down", "Button15Down");
            end
        else
            for _,xButton in pairs(HealBot_Unit_Button) do
                xButton:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp", "Button4Up", "Button5Up",
                                    "Button6Up", "Button7Up", "Button8Up", "Button9Up", "Button10Up",
                                    "Button11Up", "Button12Up", "Button13Up", "Button14Up", "Button15Up");
            end
        end
    end
end

local HealBot_AggroBarColr = {[-2]=0.7, [-1]=1, [0]=1, [1]=1, [2]=1, [3]=1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1}
local HealBot_AggroBarColg = {[-2]=0.7, [-1]=1, [0]=1, [1]=1, [2]=0.1, [3]=0.1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1}
local HealBot_AggroBarColb = {[-2]=1, [-1]=1, [0]=0.4, [1]=0.2, [2]=0.1, [3]=0.1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1}
local HealBot_AggroUnitThreat=1
local HealBot_HasAggro=false

function HealBot_Action_SetDebuffAggroCols()
    HealBot_AggroBarColr[5]=HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].R
    HealBot_AggroBarColg[5]=HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].G
    HealBot_AggroBarColb[5]=HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].B 
    HealBot_AggroBarColr[6]=HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].R
    HealBot_AggroBarColg[6]=HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].G
    HealBot_AggroBarColb[6]=HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].B 
    HealBot_AggroBarColr[7]=HealBot_Config.CDCBarColour[HEALBOT_POISON_en].R
    HealBot_AggroBarColg[7]=HealBot_Config.CDCBarColour[HEALBOT_POISON_en].G
    HealBot_AggroBarColb[7]=HealBot_Config.CDCBarColour[HEALBOT_POISON_en].B 
    HealBot_AggroBarColr[8]=HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].R
    HealBot_AggroBarColg[8]=HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].G
    HealBot_AggroBarColb[8]=HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].B 
    HealBot_AggroBarColr[9]=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].R
    HealBot_AggroBarColg[9]=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].G
    HealBot_AggroBarColb[9]=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].B
end

function HealBot_Action_SetHightlightAggroCols()
    HealBot_AggroBarColr[-1]=Healbot_Config_Skins.highcolr[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColg[-1]=Healbot_Config_Skins.highcolg[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColb[-1]=Healbot_Config_Skins.highcolb[Healbot_Config_Skins.Current_Skin]
end

function HealBot_Action_SetHightlightTargetAggroCols()
    HealBot_AggroBarColr[-2]=Healbot_Config_Skins.targetcolr[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColg[-2]=Healbot_Config_Skins.targetcolg[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColb[-2]=Healbot_Config_Skins.targetcolb[Healbot_Config_Skins.Current_Skin]
end

function HealBot_Action_SetAggroCols()
    HealBot_AggroBarColr[2]=Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColg[2]=Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColb[2]=Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColr[3]=Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColg[3]=Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin]
    HealBot_AggroBarColb[3]=Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin]
end

function HealBot_Action_setTestBar(b)
    HealBot_UnitBarUpdate[b]=0
    HealBot_curUnitHealth[b]=100
end

function HealBot_Action_UpdateFluidBars()
    for ebubar,value in pairs(HealBot_UnitBarUpdate) do 
        if value>HealBot_curUnitHealth[ebubar] then
            if value-Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin]<=HealBot_curUnitHealth[ebubar] then
                HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
            else
                HealBot_UnitBarUpdate[ebubar]=value-Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin]
            end
        elseif value+Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin]>=HealBot_curUnitHealth[ebubar] then
            HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
        else
            HealBot_UnitBarUpdate[ebubar]=value+Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin]
        end
        ebubar:SetValue(HealBot_UnitBarUpdate[ebubar])
        if HealBot_UnitBarUpdate[ebubar]==HealBot_curUnitHealth[ebubar] then
            HealBot_UnitBarUpdate[ebubar]=nil
        end
    end
end

function HealBot_Action_UpdateAggroBars()
    for xUnit,xButton in pairs(HealBot_Unit_Button) do
        if xButton.bar4state>0 then
            local bar4=HealBot_Action_HealthBar4(xButton)
            if UnitExists(xUnit) then
                HealBot_AggroUnitThreat=HealBot_UnitThreat[xUnit] or 2
                if HealBot_AggroUnitThreat==9 and xButton.debuff.name and HealBot_Globals.CDCBarColour[xButton.debuff.name] then
                    bar4:SetStatusBarColor(HealBot_Globals.CDCBarColour[xButton.debuff.name].R,
                                           HealBot_Globals.CDCBarColour[xButton.debuff.name].G,
                                           HealBot_Globals.CDCBarColour[xButton.debuff.name].B,HealBot_AggroBarA)
                else
                    bar4:SetStatusBarColor(HealBot_AggroBarColr[HealBot_AggroUnitThreat],HealBot_AggroBarColg[HealBot_AggroUnitThreat],HealBot_AggroBarColb[HealBot_AggroUnitThreat],HealBot_AggroBarA)
                end
            else
                bar4:SetStatusBarColor(1,0,0,0)
                xButton.bar4state=0
            end
        end
    end
    if HealBot_AggroBarAup then
        if HealBot_AggroBarA>=Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin] then
            HealBot_AggroBarAup=false
            HealBot_AggroBarA=HealBot_AggroBarA-0.05
        else
            HealBot_AggroBarA=HealBot_AggroBarA+0.05
        end
    else
        if HealBot_AggroBarA<=Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin] then
            HealBot_AggroBarAup=true
            HealBot_AggroBarA=HealBot_AggroBarA+0.05
        else
            HealBot_AggroBarA=HealBot_AggroBarA-0.05
        end
    end
end

local HealBot_Action_Init={}
function HealBot_Action_OnShow(self, hbCurFrame)
    if Healbot_Config_Skins.FrameClose[Healbot_Config_Skins.Current_Skin][hbCurFrame]["SOUND"]==1 then
        PlaySound("igAbilityOpen");
    end
    HealBot_Config.ActionVisible[hbCurFrame]=1
    if not HealBot_Action_Init[hbCurFrame] then
        self:SetBackdropColor(
        Healbot_Config_Skins.backcol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["R"],
        Healbot_Config_Skins.backcol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["G"],
        Healbot_Config_Skins.backcol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["B"], 
        Healbot_Config_Skins.backcol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["A"]);
        self:SetBackdropBorderColor(
        Healbot_Config_Skins.bordercol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["R"],
        Healbot_Config_Skins.bordercol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["G"],
        Healbot_Config_Skins.bordercol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["B"],
        Healbot_Config_Skins.bordercol[Healbot_Config_Skins.Current_Skin][hbCurFrame]["A"]);
        HealBot_Action_Init[hbCurFrame]=true
        HealBot_Action_SetAlias(hbCurFrame)
        HealBot_Action_SetAliasFontSize(hbCurFrame)
    end
end

function HealBot_Action_SetAlias(hbCurFrame)
    local g=_G["f"..hbCurFrame.."_HealBot_Action_Title"]
    if Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame] and
       Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["NAME"] and 
       Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["SHOW"]==1 then
        g:SetText(Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["NAME"])
    else
        g:SetText("")
    end
end

function HealBot_Action_SetAliasFontSize(hbCurFrame)
    if Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame] and Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FONT"] then
        local g=_G["f"..hbCurFrame.."_HealBot_Action_Title"]
        g:SetTextColor(Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["R"],
                               Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["G"],
                               Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["B"],
                               Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["A"]);
        g:SetFont(LSM:Fetch('font',Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["FONT"]),
                                           Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["SIZE"],
                                           HealBot_Font_Outline[Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["OUTLINE"]]);
        g:SetTextHeight(Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["SIZE"])
        g:ClearAllPoints();
        g:SetPoint("TOP",0,Healbot_Config_Skins.FrameAlias[Healbot_Config_Skins.Current_Skin][hbCurFrame]["OFFSET"]);
    end
end

function HealBot_Action_OnHide(self, hbCurFrame)
    HealBot_Config.ActionVisible[hbCurFrame] = 0
end

function HealBot_Action_OnMouseDown(self,button, hbCurFrame)
    if button=="LeftButton" then
        if Healbot_Config_Skins.FrameLocked[Healbot_Config_Skins.Current_Skin][hbCurFrame]==0 or (HealBot_Globals.ByPassLock==1 and IsControlKeyDown() and IsAltKeyDown()) then
            HealBot_FrameMoving=true
            HealBot_StartMoving(self);
        end
    end
end

function HealBot_Action_OnMouseUp(self,button,bID)
    if button=="LeftButton" and HealBot_FrameMoving then
        HealBot_StopMoving(self,bID);
        HealBot_FrameMoving=nil
    elseif button=="RightButton" and HealBot_Data["UILOCK"]=="NO" and HealBot_Globals.RightButtonOptions~=0 then
        HealBot_Action_OptionsButton_OnClick();
    end
end

function HealBot_Action_OnDragStart(self, hbCurFrame)
    if Healbot_Config_Skins.FrameLocked[Healbot_Config_Skins.Current_Skin][hbCurFrame]==0 then
        HealBot_FrameMoving=true
        HealBot_StartMoving(self);
    end
end

local usedSmartCast=nil
local ModKey=nil
local abutton=nil
local aj=nil
function HealBot_Action_PreClick(self,button)
    if self.id<999 then
        HealBot_UpdTargetUnitID(self.unit)
        usedSmartCast=false;
        ModKey=""
        if IsShiftKeyDown() then 
            if IsControlKeyDown() then 
                ModKey="Ctrl-Shift"
            elseif IsAltKeyDown() then 
                ModKey="Alt-Shift"
            else
                ModKey="Shift" 
            end
        elseif IsControlKeyDown() then 
            ModKey="Ctrl"
        elseif IsAltKeyDown() then 
            ModKey="Alt"
        end
        if button=="LeftButton" then 
            abutton="Left"
            aj=1
        elseif button=="RightButton" then 
            abutton="Right"
            aj=2
        elseif button=="MiddleButton" then 
            abutton="Middle"
            aj=3
        else
            abutton=button
            aj=tonumber(strmatch(button, "(%d+)"))
        end
        if self.unit=="target" and HealBot_Globals.TargetBarRestricted==1 then
            if button=="RightButton" then
                HealBot_Panel_ToggelHealTarget(self)
                if HealBot_Data["TIPUSE"]=="YES" and HealBot_Globals.ShowTooltip==1 then 
                    HealBot_Action_RefreshTargetTooltip(self) 
                end
            elseif button=="LeftButton" and HealBot_Globals.SmartCast==1 and not IsModifierKeyDown() then
                HealBot_Action_UseSmartCast(self)
            end
        elseif IsShiftKeyDown() and IsControlKeyDown() and IsAltKeyDown() and (button=="LeftButton" or button=="MiddleButton" or button=="RightButton") then
            if button=="LeftButton" then
                HealBot_Action_Toggle_Enabled(self)
            elseif button=="RightButton" then
                HealBot_Panel_ToggelHealTarget(self)
            elseif not UnitIsUnit(self.unit, "player") and button=="MiddleButton" and HealBot_UnitGUID(self.unit) then
                HealBot_Panel_AddBlackList(HealBot_UnitGUID(self.unit))
            end
        elseif HealBot_Data["UILOCK"]=="NO" then
            if UnitAffectingCombat(self.unit)==1 then 
                return
            end
            if HealBot_Globals.ProtectPvP==1 then
                if UnitIsPVP(self.unit) and not UnitIsPVP("player") then 
                    HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"nil",aj)
                    usedSmartCast=true;
                end
            end
            if button=="LeftButton" and HealBot_Globals.SmartCast==1 and not IsModifierKeyDown() then
                HealBot_Action_UseSmartCast(self)
            end
            if HealBot_Enabled[self.unit]=="d" and HealBot_Config.EnableHealthy==0 and not usedSmartCast then
                HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"Disabled",aj)
                usedSmartCast=true;
            end
        end
    end
end

function HealBot_Action_Toggle_Enabled(button)
    if HealBot_MyTargets[button.guid] then
        HealBot_MyTargets[button.guid]=nil
    else
        HealBot_MyTargets[button.guid]=true
    end
    HealBot_Action_ResetUnitStatus(button.unit)
end

function HealBot_Action_UseSmartCast(bp)
    local sName=HealBot_Action_SmartCast(bp);
    if sName then
        local sID=HealBot_GetSpellId(sName)
        if sID then
            if UnitIsUnit("player",bp.unit) or HealBot_UnitInRange(sName, bp.unit)==1 then
                bp:SetAttribute("helpbutton1", "heal1");
                bp:SetAttribute("type-heal1", "spell");
                bp:SetAttribute("spell-heal1", sName);
            end
        else
            local mId=GetMacroIndexByName(sName)
            if mId ~= 0 then
               local _,_,mText=GetMacroInfo(mId)
     --        mUnit = bp.unit
                if UnitExists(HealBot_UnitPet(bp.unit)) then
                    mText=string.gsub(mText,"hbtargetpet",HealBot_UnitPet(bp.unit))
                end
                mText=string.gsub(mText,"hbtarget",bp.unit)
                mText=string.gsub(mText,"hbtargettarget",bp.unit.."target")
                mText=string.gsub(mText,"hbtargettargettarget",bp.unit.."targettarget")
                bp:SetAttribute("type1","macro")
                bp:SetAttribute("macrotext1", mText)
            else
                bp:SetAttribute("helpbutton1", "item1");
                bp:SetAttribute("type-item1", "item");
                bp:SetAttribute("item-item1", sName);
            end
        end
        usedSmartCast=true;
        HealBot_Check_WeaponBuffs(sName)
    end
end

function HealBot_Action_PostClick(self,button)
    if self.id==999 and not IsModifierKeyDown() then
        HealBot_Panel_clickToFocus("hide")
    elseif usedSmartCast then
        if self.unit=="target" then
            if aj==1 then
                self:SetAttribute(HB_prefix.."helpbutton"..aj, "target"..aj);
                self:SetAttribute(HB_prefix.."type"..aj, "target")
                self:SetAttribute(HB_prefix.."type-target"..aj, "target")
            end
        else
            HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"Enabled",aj)
        end
    end
end

function HealBot_Action_RetMyTarget(hbGUID)
    return HealBot_MyTargets[hbGUID]
end

function HealBot_Action_SmartCast(button)
    local scuSpell, scuHlth, scuMaxHlth, scuHealsIn, scuMinHlth = nil,nil,nil,nil, UnitLevel("player")*20
    local rangeSpell=HealBot_hSpell
    if HealBot_PlayerDead then return nil; end
    
  
    if HealBot_Globals.SmartCastRes==1 and UnitIsDead(button.unit) and not UnitIsGhost(button.unit) then
        scuSpell=HealBot_Init_retSmartCast_Res();
        rangeSpell=HealBot_rSpell
    elseif button.debuff.type and HealBot_Globals.SmartCastDebuff==1 then
        scuSpell=HealBot_Options_retDebuffCureSpell(button.debuff.type);
        rangeSpell=HealBot_dSpell
    elseif button.buff and HealBot_Globals.SmartCastBuff==1 then
        scuSpell=button.buff
        rangeSpell=HealBot_bSpell
    elseif HealBot_Globals.SmartCastHeal==1 then
        scuHealsIn = HealBot_IncHeals_retHealsIn(button.unit);
        scuHlth, scuMaxHlth = HealBot_UnitHealth(button.unit);
        x = scuMaxHlth-(scuHlth+scuHealsIn);
        if x>scuMinHlth then
            scuSpell=HealBot_SmartCast(x)
        end
    end
    if scuSpell and button.guid~=HealBot_Data["PGUID"] then
        if HealBot_UnitInRange(rangeSpell, button.unit)~=1 then return nil; end
    end
    return scuSpell;
end

function HealBot_Action_ClearLocalArr(hbGUID)
    HealBot_UnitOffline[hbGUID]=nil
    HealBot_PetMaxH[hbGUID]=nil
    HealBot_PetMaxHcnt1[hbGUID]=nil
    HealBot_PetMaxHcnt2[hbGUID]=nil
end

local HealBot_GMount = {}
local HealBot_PrevGMounts = {}
local HealBot_FMount = {}
local HealBot_PrevFMounts = {}
local HealBot_SMount = {}
local HealBot_mountData = {}

function HealBot_MountsPets_InitUse()
    if (HealBot_Globals.HealBot_MouseWheelTxt["NoneUp"] and (HealBot_Globals.HealBot_MouseWheelTxt["NoneUp"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["NoneUp"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["NoneDown"] and (HealBot_Globals.HealBot_MouseWheelTxt["NoneDown"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["NoneDown"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["ShiftUp"] and (HealBot_Globals.HealBot_MouseWheelTxt["ShiftUp"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["ShiftUp"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["ShiftDown"] and (HealBot_Globals.HealBot_MouseWheelTxt["ShiftDown"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["ShiftDown"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["CtrlUp"] and (HealBot_Globals.HealBot_MouseWheelTxt["CtrlUp"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["CtrlUp"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["CtrlDown"] and (HealBot_Globals.HealBot_MouseWheelTxt["CtrlDown"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["CtrlDown"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["AltUp"] and (HealBot_Globals.HealBot_MouseWheelTxt["AltUp"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["AltUp"]==HEALBOT_RANDOMGOUNDMOUNT))
    or (HealBot_Globals.HealBot_MouseWheelTxt["AltDown"] and (HealBot_Globals.HealBot_MouseWheelTxt["AltDown"]==HEALBOT_RANDOMMOUNT or HealBot_Globals.HealBot_MouseWheelTxt["AltDown"]==HEALBOT_RANDOMGOUNDMOUNT)) then
        HealBot_setOptions_Timer(410)
    end
end

function HealBot_MountsPets_InitMount()
    SetMapToCurrentZone()
    if IsSpellKnown(54197) then
        HealBot_mountData["ColdFlying"]=true
    else
        HealBot_mountData["ColdFlying"]=false
    end
    if IsSpellKnown(90267) then
        HealBot_mountData["CataFlying"]=true
    else
        HealBot_mountData["CataFlying"]=false
    end
    local y = GetCurrentMapContinent();
    if (y==3 or y>4) or (y == 4 and HealBot_mountData["ColdFlying"]) or (y<3 and HealBot_mountData["CataFlying"]) then
        HealBot_mountData["IncFlying"]=true
    else
        HealBot_mountData["IncFlying"]=false
    end
   -- if IsInInstance() and GetRealZoneText()==HEALBOT_ZONE_AQ40 then
   --     HealBot_mountData["IncGround"]="aq40"
   -- else
        HealBot_mountData["IncGround"]="grd"
        if GetRealZoneText()==HEALBOT_ZONE_VASHJIR1 or GetRealZoneText()==HEALBOT_ZONE_VASHJIR2 or GetRealZoneText()==HEALBOT_ZONE_VASHJIR3 or GetRealZoneText()==HEALBOT_ZONE_VASHJIR then
            HealBot_mountData["IncVashjir"]=GetRealZoneText()
        else
            HealBot_mountData["IncVashjir"]=false
        end
    --end
    HealBot_mountData["OculusID"]=nil
    for z,_ in pairs(HealBot_GMount) do
        HealBot_GMount[z]=nil;
    end
    for z,_ in pairs(HealBot_FMount) do
        HealBot_FMount[z]=nil;
    end
    for z,_ in pairs(HealBot_SMount) do
        HealBot_SMount[z]=nil;
    end
    for z,_ in pairs(HealBot_PrevGMounts) do
        HealBot_PrevGMounts[z]=nil;
    end
    for z,_ in pairs(HealBot_PrevFMounts) do
        HealBot_PrevFMounts[z]=nil;
    end

    local x = GetNumCompanions("MOUNT");
	for z=1,x do
 		local _, mount, sID, _, _, mountType = GetCompanionInfo("MOUNT", z);
        if not HealBot_Globals.excludeMount[mount] then
            if (mountType==31 or mountType==7) then
                if HealBot_mountData["IncFlying"] then
                    table.insert(HealBot_FMount, mount);
                end
            elseif mountType==29 then
                if HealBot_mountData["IncGround"]=="grd" then
                    table.insert(HealBot_GMount, mount);
                end
            elseif mountType==12 then
                if HealBot_mountData["IncVashjir"] then
                    table.insert(HealBot_SMount, mount);
                end
            elseif HealBot_mountData["IncFlying"] then
                table.insert(HealBot_FMount, mount);
            elseif HealBot_mountData["IncGround"]=="grd" then
                table.insert(HealBot_GMount, mount);
            end
        end
	end   
    
    if #HealBot_FMount<4 then
        HealBot_mountData["PrevFlying#"]=0
    else
        HealBot_mountData["PrevFlying#"]=ceil(#HealBot_FMount/3) 
    end
    if #HealBot_GMount<4 then
        HealBot_mountData["PrevGround#"]=0
    else
        HealBot_mountData["PrevGround#"]=ceil(#HealBot_GMount/3) 
    end

    if #HealBot_GMount==0 and #HealBot_FMount==0 then
        HealBot_mountData["ValidUse"]=false
    else
        HealBot_mountData["ValidUse"]=true
    end
end

function HealBot_MountsPets_ToggelMount(mountType)
    if IsMounted() then
        Dismount()
	elseif CanExitVehicle() then	
		VehicleExit()
    elseif HealBot_mountData["ValidUse"] and IsOutdoors() and not HealBot_IsFighting then
        local mount = nil
        local i=0
        if mountType=="all" and not IsSwimming() and IsFlyableArea() and #HealBot_FMount>0 then
            for x=1,10 do
                i = math.random(1, #HealBot_FMount);
                mount = HealBot_FMount[i];
                if not HealBot_Globals.dislikeMount[mount] then
                    do break end
                else
                    if HealBot_Globals.dislikeMount[mount]>0 then
                        HealBot_Globals.dislikeMount[mount]=HealBot_Globals.dislikeMount[mount]-1
                    else
                        HealBot_Globals.dislikeMount[mount]=500
                        do break end
                    end
                end
            end
            if HealBot_mountData["PrevFlying#"]>0 then
                table.insert(HealBot_PrevFMounts, HealBot_FMount[i]);
                table.remove(HealBot_FMount,i)
            end
            if #HealBot_PrevFMounts>HealBot_mountData["PrevFlying#"] then
                table.insert(HealBot_FMount, HealBot_PrevFMounts[1]);
                table.remove(HealBot_PrevFMounts,1)
            end
        elseif IsSwimming() and #HealBot_SMount>0 then
            i = math.random(1, #HealBot_SMount);
            mount = HealBot_SMount[i];
        elseif #HealBot_GMount>0 then
            for x=1,10 do
                i = math.random(1, #HealBot_GMount);
                mount = HealBot_GMount[i];
                if not HealBot_Globals.dislikeMount[mount] then
                    do break end
                else
                    if HealBot_Globals.dislikeMount[mount]>0 then
                        HealBot_Globals.dislikeMount[mount]=HealBot_Globals.dislikeMount[mount]-1
                    else
                        HealBot_Globals.dislikeMount[mount]=500
                        do break end
                    end
                end
            end
            if HealBot_mountData["PrevGround#"]>0 then
                table.insert(HealBot_PrevGMounts, HealBot_GMount[i]);
                table.remove(HealBot_GMount,i)
            end
            if #HealBot_PrevGMounts>HealBot_mountData["PrevGround#"] then
                table.insert(HealBot_GMount, HealBot_PrevGMounts[1]);
                table.remove(HealBot_PrevGMounts,1)
            end
        end
        if mount then HealBot_MountsPets_Mount(mount) end
    end
end

function HealBot_MountsPets_DislikeMount(action)
    local z = GetNumCompanions("MOUNT");
    local mount=nil
	for i=1,z do
 		local _, x, _, _, y = GetCompanionInfo("MOUNT", i);
 		if y then
 			mount=x
            do break end
 		end
 	end
    if mount then
        if action=="Exclude" then
            if HealBot_Globals.excludeMount[mount] then
                HealBot_AddChat(HEALBOT_OPTION_EXCLUDEMOUNT_OFF.." "..mount)
                HealBot_Globals.excludeMount[mount]=nil
            else
                HealBot_AddChat(HEALBOT_OPTION_EXCLUDEMOUNT_ON.." "..mount)
                HealBot_Globals.excludeMount[mount]=true
            end
            HealBot_setOptions_Timer(405)
        else
            if HealBot_Globals.dislikeMount[mount] then
                HealBot_AddChat(HEALBOT_OPTION_DISLIKEMOUNT_OFF.." "..mount)
                HealBot_Globals.dislikeMount[mount]=nil
            else
                HealBot_AddChat(HEALBOT_OPTION_DISLIKEMOUNT_ON.." "..mount)
                HealBot_Globals.dislikeMount[mount]=275
            end
        end
    end
end

function HealBot_MountsPets_Mount(mountName)
	local z = GetNumCompanions("MOUNT");
	for i=1,z do
 		local _, sName, _, _, _ = GetCompanionInfo("MOUNT", i);
 		if sName==mountName then
 			CallCompanion("MOUNT", i);
            do break end
 		end
 	end
end

function HealBot_MountsPets_RandomPet()
    C_PetJournal.SummonRandomPet("CRITTER");
end