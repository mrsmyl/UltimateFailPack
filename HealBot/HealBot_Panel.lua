local TempMaxH=0;
local frameScale = {}
local bwidth={}
local bheight={}
local bcspace={}
local brspace={}
local cols={}
local HealBot_TrackNames={};
local HealBot_RaidUnitID={}
local HealBot_TrackNotVisible={};
local i={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
local order = {};
local units = {};
local subunits = {};
local MyGroup={["GROUP"]=0,["FRAME"]=1}
local HeaderPos={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}}
local OffsetY = {[1]=10,[2]=10,[3]=10,[4]=10,[5]=10,[6]=10,[7]=10,[8]=10,[9]=10,[10]=10};
local OffsetX = {[1]=10,[2]=10,[3]=10,[4]=10,[5]=10,[6]=10,[7]=10,[8]=10,[9]=10,[10]=10};
local MaxOffsetY={};
local MaxOffsetX={};
local HealBot_HeadX={};
local HealBot_HeadY={};
local HealBot_BarX={};
local HealBot_BarY={};
local HealBot_ActiveHeaders={[0]=1}
local HealBot_MultiColHoToffset=0;
local HealBot_MultiRowHoToffset=0;
local HealBot_OutlineOffset={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
local HealBot_TrackUnit={}
local HealBot_TrackGUID={}
local HealBot_Panel_BlackList={};
local format=format
local ceil=ceil;
local strsub=strsub
local HealBot_AddHeight={  ["BOTH"]={[1]=4,[2]=4,[3]=4,[4]=4,[5]=4,[6]=4,[7]=4,[8]=4,[9]=4,[10]=4},
                         ["BOTTOM"]={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0},
                           ["BAR2"]={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}};
local HealBot_AddWidth={  ["BOTH"]={[1]=4,[2]=4,[3]=4,[4]=4,[5]=4,[6]=4,[7]=4,[8]=4,[9]=4,[10]=4},
                          ["SIDE"]={[1]=4,[2]=4,[3]=4,[4]=4,[5]=4,[6]=4,[7]=4,[8]=4,[9]=4,[10]=4}};
local HealBot_MyHealTargets={}
local HealBot_MyPrivateTanks={}
local HealBot_MainTanks={};
local HealBot_TempTanks={};
local HealBot_UnitGroups={}
local HealBot_UnitNameGUID={}
local maxHealDiv=2500
local HealBot_TestBars={}
local hbBarsPerFrame={}
local hbCurrentFrame=1
local HealBot_unitRole={}
local HealBot_BottomAnchors={[1]=false,[2]=false,[3]=false,[4]=false,[5]=false,[6]=false,[7]=false,[8]=false,[9]=false,[10]=false};
local HealBot_cpName={}
local HealBot_cpData={}
local HealBot_cpOn=false
local _
local nraid=0
local HealBot_UnitName={}
local hbOptionOn=nil
local hbFocusOn=nil
local HealBot_Header_Frames={}
local HealBot_Track_Headers={}
local HealBot_PanelVars={}

local hbRole={ [HEALBOT_MAINTANK]=3,
               [HEALBOT_WORD_HEALER]=5,
               [HEALBOT_WORD_DPS]=7,
               [HEALBOT_WORDS_UNKNOWN]=9,
      }

local HealBot_Action_HealGroup = {
    "player",
    "party1",
    "party2",
    "party3",
    "party4",
};

local HealBot_Action_HealButtons = {};
local hbPanelShowhbFocus=nil

function HealBot_Panel_clickToFocus(status)
    if status=="Show" then
        hbPanelShowhbFocus=1
    else
        hbPanelShowhbFocus=nil
    end
    if HealBot_Data["REFRESH"]<5 then HealBot_Data["REFRESH"]=5; end
end

function HealBot_GetMyHealTargets()
    return HealBot_MyHealTargets;
end

function HealBot_Panel_SetSubSortPlayer()
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
        Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]=0
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_SUBSORTPLAYER2)
    else
        Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]=1
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_SUBSORTPLAYER1)
    end
    HealBot_Options_SubSortPlayerFirst:SetChecked(Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"] or 0)
    if HealBot_Data["REFRESH"]<2 then HealBot_Data["REFRESH"]=2; end
end

function HealBot_Panel_SethbTopRole(Role)
    if not Role then return end
    Role=strupper(strtrim(Role))
    if Role=="TANK" then
        hbRole[HEALBOT_MAINTANK]=2
        hbRole[HEALBOT_WORD_HEALER]=5
        hbRole[HEALBOT_WORD_DPS]=7
    elseif Role=="DPS" then
        hbRole[HEALBOT_MAINTANK]=3
        hbRole[HEALBOT_WORD_HEALER]=5
        hbRole[HEALBOT_WORD_DPS]=2
    elseif Role=="HEALER" then
        hbRole[HEALBOT_MAINTANK]=3
        hbRole[HEALBOT_WORD_HEALER]=2
        hbRole[HEALBOT_WORD_DPS]=7
    else
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..Role..HEALBOT_CHAT_TOPROLEERR)
        return
    end
    if HealBot_Globals.TopRole~=Role then
        HealBot_Globals.TopRole=Role
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_NEWTOPROLE..Role)
    end
end

function HealBot_Panel_SetBarArrays(hbBarID)
    HealBot_BarX[hbBarID]=0;
    HealBot_BarY[hbBarID]=0;
end

function HealBot_Panel_SetHeadArrays(hbHID)
    HealBot_HeadX[hbHID]=0;
    HealBot_HeadY[hbHID]=0;
end

function HealBot_Panel_ClearBarArrays()
    HealBot_BarX={};
    HealBot_BarY={};
    HealBot_HeadX={};
    HealBot_HeadY={};
    if HealBot_Data["REFRESH"]<1 then HealBot_Data["REFRESH"]=1; end
end

function HealBot_Panel_SetmaxHealDiv(lvl)
    maxHealDiv=500
    if lvl>86 then
        maxHealDiv=15000
    elseif lvl>81 then
        maxHealDiv=10000
    elseif lvl>76 then
        maxHealDiv=7500
    elseif lvl>70 then
        maxHealDiv=5000
    elseif lvl>60 then
        maxHealDiv=3000
    elseif lvl>45 then
        maxHealDiv=2000
    elseif lvl>30 then
        maxHealDiv=1000
    end
end

function HealBot_Panel_ClearBlackList()
    for x,_ in pairs(HealBot_Panel_BlackList) do
        HealBot_Panel_BlackList[x]=nil;
    end
    if HealBot_Data["REFRESH"]<1 then HealBot_Data["REFRESH"]=1 end
end

function HealBot_Panel_AddBlackList(hbGUID)
    HealBot_Panel_BlackList[hbGUID]=true;
    if HealBot_Data["REFRESH"]<2 then 
        HealBot_Data["REFRESH"]=2 
    end
end

function HealBot_Panel_ClearHealTarget(hbGUID)
    HealBot_MyHealTargets = {}
end

local myGUID=nil
function HealBot_Panel_ToggelHealTarget(unit)
    if unit=="target" then return end
    local xGUID=HealBot_UnitGUID(unit)
    local mti=0
    for j=1, #HealBot_MyHealTargets do
        if xGUID==HealBot_MyHealTargets[j] then
            mti=j
            break;
        end
    end
    if mti>0 then
        table.remove(HealBot_MyHealTargets,mti)
    else
        table.insert(HealBot_MyHealTargets,xGUID)
    end
    if HealBot_Data["REFRESH"]<2 then 
        HealBot_Data["REFRESH"]=2 
    end
end

function HealBot_Panel_ToggelPrivateTanks(unit)
    if unit=="target" then return end
    local xGUID=HealBot_UnitGUID(unit)
    local mti=0
    for j=1, #HealBot_MyPrivateTanks do
        if xGUID==HealBot_MyPrivateTanks[j] then
            mti=j
            break;
        end
    end
    if mti>0 then
        table.remove(HealBot_MyPrivateTanks,mti)
        HealBot_removePrivateTanks(xGUID)
    else
        table.insert(HealBot_MyPrivateTanks,xGUID)
        HealBot_addPrivateTanks()
    end
    if HealBot_Data["REFRESH"]<2 then 
        HealBot_Data["REFRESH"]=2 
    end
end

function HealBot_Panel_retPrivateTanks()
    return HealBot_MyPrivateTanks
end

function HealBot_Panel_RetMyHealTarget(unit)
    local xGUID=HealBot_UnitGUID(unit)
    local mti=0
    for j=1, #HealBot_MyHealTargets do
        if xGUID==HealBot_MyHealTargets[j] then
            mti=j
            break;
        end
    end
    if mti>0 then
        return true
    else
        return false
    end
end

function HealBot_Panel_RetPrivateTanks(unit)
    local xGUID=HealBot_UnitGUID(unit)
    local mti=0
    for j=1, #HealBot_MyPrivateTanks do
        if xGUID==HealBot_MyPrivateTanks[j] then
            mti=j
            break;
        end
    end
    if mti>0 then
        return true
    else
        return false
    end
end
  
function HealBot_Panel_SetMultiColHoToffset(nx)
    HealBot_MultiColHoToffset=nx
    for j=1,10 do
        HealBot_OutlineOffset[j] = ceil(Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][j]["BOUT"]*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"]);
    end
    HealBot_Action_SetAddHeightWidth()
end
  
function HealBot_Panel_SetMultiRowHoToffset(nx)
    HealBot_MultiRowHoToffset=nx
    HealBot_Action_SetAddHeightWidth()
end
    
local role_tex_file = "Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp"
local role_t = "\124T"..role_tex_file..":%d:%d:"
local role_tex = {
   DAMAGER = role_t.."0:0:64:64:20:39:22:41\124t",
   HEALER  = role_t.."0:0:64:64:20:39:1:20\124t",
   TANK    = role_t.."0:0:64:64:0:19:22:41\124t",
   LEADER  = role_t.."0:0:64:64:0:19:1:20\124t",
   NONE    = ""
}

function getRoleTexCoord(role)
  local str = role_tex[role]
  if not str or #str == 0 then return nil end
  local a,b,c,d = string.match(str, ":(%d+):(%d+):(%d+):(%d+)%\124t")
  return a/64,b/64,c/64,d/64
end

local roleTextures={
    ["DAMAGER"]="Interface\\Addons\\HealBot\\Images\\dps.tga",
    ["TANK"]="Interface\\Addons\\HealBot\\Images\\tank.tga",
    ["HEALER"]="Interface\\Addons\\HealBot\\Images\\healer.tga",
    }
    
local classTextures={
    ["DEATHKNIGHT"]="Interface\\Addons\\HealBot\\Images\\Deathknight.tga",
    ["DRUID"]="Interface\\Addons\\HealBot\\Images\\Druid.tga",
    ["HUNTER"]="Interface\\Addons\\HealBot\\Images\\Hunter.tga",
    ["MAGE"]="Interface\\Addons\\HealBot\\Images\\Mage.tga",
    ["MONK"]="Interface\\Addons\\HealBot\\Images\\Monk.tga",
    ["PALADIN"]="Interface\\Addons\\HealBot\\Images\\Paladin.tga",
    ["PRIEST"]="Interface\\Addons\\HealBot\\Images\\Priest.tga",
    ["ROGUE"]="Interface\\Addons\\HealBot\\Images\\Rogue.tga",
    ["SHAMAN"]="Interface\\Addons\\HealBot\\Images\\Shaman.tga",
    ["WARLOCK"]="Interface\\Addons\\HealBot\\Images\\Warlock.tga",
    ["WARRIOR"]="Interface\\Addons\\HealBot\\Images\\Warrior.tga",
    }

function HealBot_Action_SetClassIconTexture(button)
    local xUnit=button.unit
    if not HealBot_retdebuffTargetIcon(xUnit) then
        local bar = HealBot_Action_HealthBar(button);
        if not bar then return end
        local iconName = _G[bar:GetName().."Icon15"];   
        local setRole=false
        local unitRole=UnitGroupRolesAssigned(xUnit)  
        if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["SHOWROLE"]==1 then
            if unitRole=="NONE" then
                local xGUID=HealBot_UnitGUID(xUnit)
                if xGUID and HealBot_UnitData[xGUID] then
                    unitRole=HealBot_UnitData[xGUID]["ROLE"]
                end
            end
            if roleTextures[unitRole] then
                setRole=true
            end
        end
        if setRole then
            iconName:SetTexture(roleTextures[unitRole]);
        else
            local _,classEN = UnitClass(xUnit)
            iconName:SetTexture(classTextures[classEN]);
        end
        --iconName:SetAlpha(Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]);
    end
end

function HealBot_Panel_ResetClassIconTexture()
    for _,xButton in pairs(HealBot_Unit_Button) do
        HealBot_Action_SetClassIconTexture(xButton)
    end
end


local HealBot_ResetHeaderSkinDone={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}};
function HealBot_Panel_clearResetHeaderSkinDone()
    HealBot_ResetHeaderSkinDone={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}};
end

function HealBot_Panel_CreateHeader(hbCurFrame)
    if HealBot_ActiveHeaders[0]>99 then HealBot_ActiveHeaders[0]=1 end
    local tryId,freeId=HealBot_ActiveHeaders[0],nil
    if not HealBot_ActiveHeaders[tryId] then
        freeId=tryId
    else
        for j=1,99 do
            if not HealBot_ActiveHeaders[j] then
                freeId=j
                break
            end
        end
    end
    if freeId then 
        HealBot_ActiveHeaders[freeId]=true 
        local hn="HealBot_Action_Header"..freeId
        local hp=_G["f"..hbCurFrame.."_HealBot_Action"]
        local hhb=_G[hn]
        if not hhb then 
            hhb=CreateFrame("Button", hn, hp, "HealingButtonTemplate3") 
            hhb.id=freeId
            hhb.frame=hbCurFrame
        elseif hhb.frame~=hbCurFrame then
            hhb:ClearAllPoints()
            hhb:SetParent(hp)
            hhb.frame=hbCurFrame
        end
        HealBot_ActiveHeaders[0]=freeId+1
        return hhb
    else
        return nil
    end
end

function HealBot_Panel_DeleteHeader(hdrID, xHeader)
    local hg=_G["HealBot_Action_Header"..hdrID]
    if hdrID<HealBot_ActiveHeaders[0] then HealBot_ActiveHeaders[0]=hdrID end
    hg:Hide();
    HealBot_ActiveHeaders[hdrID]=nil
    HealBot_Header_Frames[xHeader]=nil
    HealBot_Panel_SetHeadArrays(hdrID)
end

function HealBot_Panel_retHealBot_Header_Frames(hbCurFrame)
    return HealBot_Header_Frames
end

function HealBot_Action_PositionButton(button,OsetX,OsetY,bWidth,bHeight,xHeader,hbCurFrame,bcSpace,brSpace)
    if xHeader then
        local thisX,thisY=nil,nil
        local hheight = ceil((bHeight+HealBot_AddHeight["BAR2"][hbCurFrame])*Healbot_Config_Skins.HeadBar[Healbot_Config_Skins.Current_Skin][hbCurFrame]["HEIGHT"])
        local hdr=HealBot_Header_Frames[xHeader]
        if not hdr then
            hdr=HealBot_Panel_CreateHeader(hbCurFrame)
            HealBot_Header_Frames[xHeader]=hdr
        end
        if hdr.frame~=hbCurFrame then
            local hbg=_G["f"..hbCurFrame.."_HealBot_Action"]
            hdr:ClearAllPoints()
            hdr:SetParent(hbg)
            hdr.frame=hbCurFrame
            HealBot_Panel_SetHeadArrays(hdr.id)
            HealBot_ResetHeaderSkinDone[hbCurFrame][hdr.id]=nil
        end
        HealBot_Track_Headers[xHeader]=true
        if not HealBot_ResetHeaderSkinDone[hbCurFrame][hdr.id] then
            HealBot_Action_ResetSkin("header",hdr)
            HealBot_ResetHeaderSkinDone[hbCurFrame][hdr.id]=true
        end
        local hwidth = bWidth*Healbot_Config_Skins.HeadBar[Healbot_Config_Skins.Current_Skin][hbCurFrame]["WIDTH"]
        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["GROW"]==1 then
            thisX=OsetX-floor(HealBot_AddWidth["BOTH"][hbCurFrame]/2)+floor(bcSpace/2)+2
            thisY=OsetY+floor(((bHeight+HealBot_AddHeight["BAR2"][hbCurFrame])-hheight)/2)
        else
            thisX=OsetX+floor((bWidth-hwidth)/2)
            thisY=OsetY-floor(HealBot_AddHeight["BOTH"][hbCurFrame]/2)+brSpace+2
        end
        if HealBot_HeadX[hdr.id]~=thisX or HealBot_HeadY[hdr.id]~=format("%s",thisY)..xHeader then
            HealBot_HeadX[hdr.id]=thisX
            HealBot_HeadY[hdr.id]=format("%s",thisY)..xHeader;
            local bar = HealBot_Action_HealthBar(hdr);
            hdr:ClearAllPoints();
            local hbg=_G["f"..hbCurFrame.."_HealBot_Action"]
            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==1 then
                hdr:SetPoint("TOPLEFT",hbg,"TOPLEFT",thisX,-thisY);
            elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==2 then
                hdr:SetPoint("BOTTOMLEFT",hbg,"BOTTOMLEFT",thisX,thisY);
            elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==3 then
                hdr:SetPoint("TOPRIGHT",hbg,"TOPRIGHT",-thisX,-thisY);
            else
                hdr:SetPoint("BOTTOMRIGHT",hbg,"BOTTOMRIGHT",-thisX,thisY);
            end
            bar.txt = _G[bar:GetName().."_text"];
            bar.txt:SetText(xHeader);
            hdr:Show();
        end
        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["GROW"]==1 then
            OsetY = thisY+hheight+(HealBot_AddHeight["BOTH"][hbCurFrame]/2)
            OsetX = thisX+hwidth+ceil(HealBot_AddWidth["BOTH"][hbCurFrame]/2)+4
        else
            OsetY = thisY+hheight+HealBot_AddHeight["BOTTOM"][hbCurFrame]+3
            OsetX = thisX+hwidth+HealBot_AddWidth["SIDE"][hbCurFrame]
        end
    else
        if HealBot_BarX[button.id]~=OsetX or HealBot_BarY[button.id]~=OsetY then
            HealBot_BarX[button.id]=OsetX
            HealBot_BarY[button.id]=OsetY;
            button:ClearAllPoints();
            local bfg=_G["f"..hbCurFrame.."_HealBot_Action"]
            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==1 then
                button:SetPoint("TOPLEFT",bfg,"TOPLEFT",OsetX,-OsetY);
            elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==2 then
                button:SetPoint("BOTTOMLEFT",bfg,"BOTTOMLEFT",OsetX,OsetY);
            elseif Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["BARS"]==3 then
                button:SetPoint("TOPRIGHT",bfg,"TOPRIGHT",-OsetX,-OsetY);
            else
                button:SetPoint("BOTTOMRIGHT",bfg,"BOTTOMRIGHT",-OsetX,OsetY);
            end
        end
        OsetY = OsetY+bHeight+HealBot_AddHeight["BOTH"][hbCurFrame]+HealBot_AddHeight["BOTTOM"][hbCurFrame]
        OsetX = OsetX+bWidth+HealBot_AddWidth["BOTH"][hbCurFrame]+HealBot_AddWidth["SIDE"][hbCurFrame]
    end
    return OsetX, OsetY;
end

function HealBot_Action_SetAddHeightWidth()
    local addsHeight={}
    local HealBot_addsHeightSize={}
    local addsHeightSize={}
    for j=1,10 do
        addsHeight[j]=0
        if Healbot_Config_Skins.Aggro[Healbot_Config_Skins.Current_Skin]["SHOW"]==0 and 
           Healbot_Config_Skins.Highlight[Healbot_Config_Skins.Current_Skin]["CBAR"]==0 and
           Healbot_Config_Skins.Highlight[Healbot_Config_Skins.Current_Skin]["TBAR"]==0 then        
            addsHeight[j]=0
        else
            addsHeight[j]=Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["AGGROSIZE"]
        end
        HealBot_addsHeightSize[j]=addsHeight[j]
        if Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][j]["BOUT"]>addsHeight[j] then
            HealBot_addsHeightSize[j]=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][j]["BOUT"]
        end
        addsHeightSize[j]=HealBot_addsHeightSize[j]*2
        HealBot_AddHeight["BOTH"][j]=ceil(addsHeightSize[j]*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"])
        HealBot_AddHeight["BOTTOM"][j]=Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["POWERSIZE"]+Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["RMARGIN"]
        HealBot_AddHeight["BOTTOM"][j]=ceil((HealBot_AddHeight["BOTTOM"][j]+HealBot_MultiRowHoToffset)*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"]);
        HealBot_AddHeight["BAR2"][j]=ceil(Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["POWERSIZE"]*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"]);

        HealBot_AddWidth["BOTH"][j]=ceil((Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][j]["BOUT"]*2)*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"])
        HealBot_AddWidth["SIDE"][j]=ceil((Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["CMARGIN"]+HealBot_MultiColHoToffset)*Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"])
    end
end


function HealBot_Action_SetHeightWidth(width,height,bWidth,bHeight,hbCurFrame)
    local g = _G["f"..hbCurFrame.."_HealBot_Action"]
    if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbCurFrame]["GROW"]==1 then
        g:SetHeight(height+bHeight+HealBot_AddHeight["BOTH"][hbCurFrame]);
        g:SetWidth(width)
    else
        g:SetHeight(height);
        g:SetWidth(width+bWidth+HealBot_OutlineOffset[hbCurFrame]) --+HealBot_AddWidth["BOTH"][hbCurFrame])
    end
    HealBot_Action_setPoint(hbCurFrame)
    g:Show()
end

local HealBot_noBars=25
local HealBot_setTestBars=false
local HealBot_setTestCols={}
function HealBot_Panel_SetNumBars(numTestBars)
    if numTestBars>HealBot_noBars and HealBot_setTestBars then
        HealBot_Panel_resetTestCols()
    end
    HealBot_noBars=numTestBars
end

function HealBot_Panel_ToggleTestBars()
    if HealBot_setTestBars then
        HealBot_setTestBars=false
        HealBot_Panel_TestBarsOff()
        HealBot_Options_TestBarsButton:SetText(HEALBOT_OPTIONS_TESTBARS.." "..HEALBOT_WORD_OFF)
    else
        HealBot_setTestBars=true
        HealBot_Options_TestBarsButton:SetText(HEALBOT_OPTIONS_TESTBARS.." "..HEALBOT_WORD_ON)
        HealBot_setTestCols={}
    end
    HealBot_Action_Set_Timers()
end

function HealBot_Panel_retTestBars()
    return HealBot_setTestBars
end

local gNo=5
local grpNo=1
local tHeader={}
function HealBot_Panel_TestBarsOn()
    for _,xButton in pairs(HealBot_Unit_Button) do
        HealBot_Action_DeleteButton(xButton.id)
    end
    for xHeader,xButton in pairs(HealBot_Header_Frames) do
        HealBot_Panel_DeleteHeader(xButton.id, xHeader)
    end
    for x,_ in pairs(HealBot_Action_HealButtons) do
        HealBot_Action_HealButtons[x]=nil
    end
    for x,_ in pairs(HealBot_TrackUnit) do
        HealBot_TrackUnit[x]=nil;
    end
    for x,b in pairs(HealBot_TestBars) do
        HealBot_Action_DeleteButton(b.id)
        HealBot_TestBars[x]=nil
    end
    for x,_ in pairs(tHeader) do
        tHeader[x]=nil
    end
    for gl=1,10 do
        HeaderPos[gl]={};
    end
    
    noBars=tonumber(HealBot_noBars)
    i={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
    grpNo=1

    local healGroups=Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin]
    local gl=0
    local xRaidBars=40
    if HealBot_Globals.TestBars["PROFILE"]==3 then xRaidBars=25 end
    if HealBot_Globals.TestBars["PROFILE"]==2 then xRaidBars=10 end

    for gl=1,10 do
        hbCurrentFrame=healGroups[gl]["FRAME"]
        if healGroups[gl]["NAME"]==HEALBOT_OPTIONS_SELFHEALS_en and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_OPTIONS_SELFHEALS,HEALBOT_OPTIONS_SELFHEALS,1,1,HEALBOT_WORD_HEALER)
            gNo=4
            xRaidBars=xRaidBars-1
        elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_TANKHEALS_en and HealBot_Globals.TestBars["TANKS"]>0 and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_OPTIONS_TANKHEALS,HEALBOT_WORD_TANK,1,HealBot_Globals.TestBars["TANKS"],HEALBOT_WORD_TANK)
            xRaidBars=xRaidBars-HealBot_Globals.TestBars["TANKS"]
        elseif healGroups[gl]["NAME"]==HEALBOT_CLASSES_HEALERS_en and HealBot_Globals.TestBars["HEALERS"]>0 and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_CLASSES_HEALERS,HEALBOT_WORD_HEALER,1,HealBot_Globals.TestBars["HEALERS"],HEALBOT_WORD_HEALER)
            xRaidBars=xRaidBars-HealBot_Globals.TestBars["HEALERS"]
        elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_GROUPHEALS_en and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_GROUPHEALS,1,gNo)
            xRaidBars=xRaidBars-gNo
        elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_MYTARGET_en and HealBot_Globals.TestBars["TARGETS"]>0 and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_OPTIONS_MYTARGET,HEALBOT_DISABLED_TARGET,1,HealBot_Globals.TestBars["TARGETS"])
            xRaidBars=xRaidBars-HealBot_Globals.TestBars["TARGETS"]
        elseif healGroups[gl]["NAME"]==HEALBOT_FOCUS_en and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_FOCUS,HEALBOT_FOCUS,1,1)
        elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_EMERGENCYHEALS_en and healGroups[gl]["STATE"]==1 and HealBot_Globals.TestBars["PROFILE"]>1 and xRaidBars>0 then
            if xRaidBars<5 then
                HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,1,xRaidBars)
            else
                HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,1,5)
            end
            if xRaidBars>5 then
                if xRaidBars<10 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,6,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,6,10)
                end
            end
            if xRaidBars>10 then
                if xRaidBars<15 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,11,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,11,15)
                end
            end
            if xRaidBars>15 then
                if xRaidBars<20 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,16,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,16,20)
                end
            end
            if xRaidBars>20 then
                if xRaidBars<25 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,21,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,21,25)
                end
            end
            if xRaidBars>25 then
                if xRaidBars<30 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,26,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,26,30)
                end
            end
            if xRaidBars>30 then
                if xRaidBars<35 then
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,31,xRaidBars)
                else
                    HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,31,35)
                end
            end
            if xRaidBars>35 then
                HealBot_Panel_testAddButton(HEALBOT_OPTIONS_EMERGENCYHEALS.." "..HEALBOT_OPTIONS_GROUPHEALS.." "..grpNo,HEALBOT_OPTIONS_EMERGENCYHEALS,36,xRaidBars)
            end
        elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_PETHEALS_en and HealBot_Globals.TestBars["PETS"]>0 and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_OPTIONS_PETHEALS,HEALBOT_OPTIONS_PETHEALS,1,HealBot_Globals.TestBars["PETS"],HEALBOT_OPTIONS_PETHEALS)
        elseif healGroups[gl]["NAME"]==HEALBOT_VEHICLE_en and healGroups[gl]["STATE"]==1 then
            HealBot_Panel_testAddButton(HEALBOT_VEHICLE,HEALBOT_VEHICLE,1,2)
    --    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_TARGETHEALS_en and healGroups[gl]["STATE"]==1 then
    --        HealBot_Panel_testAddButton(HEALBOT_OPTIONS_TARGETHEALS,HEALBOT_DISABLED_TARGET,1,1)
        end
    end
    
    HealBot_Panel_SetupBars()
    HealBot_Action_Set_Timers()
end

function HealBot_Panel_testAddButton(gName,bName,minBar,maxBar,tRole)
    local k=i[hbCurrentFrame]
    --if not HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i+1] = gName end
    for j=minBar,maxBar do
        if noBars>0 then
            local tstb=HealBot_Action_SetTestButton(hbCurrentFrame, HEALBOT_WORD_TEST.." "..bName.." "..j)
            if tstb then 
                local bIndex=tstb.id
                HealBot_Panel_TestBarShow(bIndex,tstb,tRole)
                noBars=noBars-1
                i[hbCurrentFrame]=i[hbCurrentFrame]+1
                hbBarsPerFrame[tstb.frame]=hbBarsPerFrame[tstb.frame]+1
            end
        end
    end
    if i[hbCurrentFrame]>k and not tHeader[gName] then
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = gName 
        else
            HeaderPos[hbCurrentFrame][k+1] = gName
        end
        tHeader[gName]=true
        if bName==HEALBOT_OPTIONS_EMERGENCYHEALS or bName==HEALBOT_OPTIONS_GROUPHEALS then
            grpNo=grpNo+1
        end
    end
end

local HealBot_colIndex= {}

function HealBot_Panel_resetTestCols(force)
    if HealBot_setTestBars then
        if force then HealBot_setTestCols={} end
        if HealBot_Data["REFRESH"]<2 then HealBot_Data["REFRESH"]=2; end
    end
    HealBot_Action_Set_Timers()
end

function HealBot_Panel_TestBarShow(index,button,tRole)
    table.insert(HealBot_Action_HealButtons,button.unit)
    HealBot_TrackUnit[button.unit]=true
    HealBot_TestBars[index]=button
    local bar=HealBot_Action_HealthBar(button)
    local HealBot_keepClass=false
    if not HealBot_setTestCols[index] then
        if (Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HLTH"] >= 2) then
            if (Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HLTH"] == 2) then
                HealBot_colIndex["hcr"..index],HealBot_colIndex["hcg"..index],HealBot_colIndex["hcb"..index] = HealBot_Panel_RandomClassColour(tRole)
                if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["CLASSCOL"]==1 then
                    HealBot_keepClass=true
                end
            else
                HealBot_colIndex["hcr"..index]=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HR"]
                HealBot_colIndex["hcg"..index]=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HG"]
                HealBot_colIndex["hcb"..index]=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HB"]
            end
        else
            HealBot_colIndex["hcr"..index],HealBot_colIndex["hcg"..index],HealBot_colIndex["hcb"..index] = 0,1,0
        end
        if HealBot_keepClass then
            HealBot_colIndex["hctr"..index],HealBot_colIndex["hctg"..index],HealBot_colIndex["hctb"..index] = HealBot_colIndex["hcr"..index],HealBot_colIndex["hcg"..index],HealBot_colIndex["hcb"..index]
        else
            if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["CLASSCOL"]==1 then
                HealBot_colIndex["hctr"..index],HealBot_colIndex["hctg"..index],HealBot_colIndex["hctb"..index] = HealBot_Panel_RandomClassColour(tRole)
            else
                HealBot_colIndex["hctr"..index] = Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["ER"]
                HealBot_colIndex["hctg"..index] = Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["EG"]
                HealBot_colIndex["hctb"..index] = Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["EB"]
            end
        end
        HealBot_initTestBar(bar)
        bar:SetValue(0)
        HealBot_setTestCols[index]=true
    end
    bar:SetStatusBarColor(HealBot_colIndex["hcr"..index],HealBot_colIndex["hcg"..index],HealBot_colIndex["hcb"..index],Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]);
    bar.txt = _G[bar:GetName().."_text"];
    if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["HLTHONBAR"]==1 then
        if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["DOUBLE"]==0 then
            if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["HLTHTYPE"]==1 then
                bar.txt:SetText(button.unit.." 100K");
            elseif Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["HLTHTYPE"]==2 then
                bar.txt:SetText(button.unit.." (0)");
            else
                bar.txt:SetText(button.unit.." (100%)");
            end
        else
            if Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["HLTHTYPE"]==1 then
                bar.txt:SetText(button.unit.."\n100K");
            elseif Healbot_Config_Skins.BarText[Healbot_Config_Skins.Current_Skin][button.frame]["HLTHTYPE"]==2 then
                bar.txt:SetText(button.unit.."\n(0)");
            else
                bar.txt:SetText(button.unit.."\n(100%)");
            end
        end
    else
        bar.txt:SetText(button.unit)
    end
    bar.txt:SetTextColor(HealBot_colIndex["hctr"..index],HealBot_colIndex["hctg"..index],HealBot_colIndex["hctb"..index],Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["EA"]);
    button:Show()
end
          
local HealBot_randomN=random(11)
local prevCol=0
local HealBot_randomClCol = {   [1] = { [1] = 0.78, [2] = 0.04, [3] = 0.04, },  
                                [2] = { [1] = 0.78, [2] = 0.61, [3] = 0.43, },  
                                [3] = { [1] = 1.0, [2] = 0.49, [3] = 0.04, },   
                                [4] = { [1] = 0, [2] = 1.0, [3] = 0.59, }, 
                                [5] = { [1] = 0.96, [2] = 0.55, [3] = 0.73, },
                                [6] = { [1] = 1.0, [2] = 1.0, [3] = 1.0, },
                                [7] = { [1] = 0.14, [2] = 0.35, [3] = 1.0, },
                                [8] = { [1] = 0.58, [2] = 0.51, [3] = 0.79, },
                                [9] = { [1] = 0.67, [2] = 0.83, [3] = 0.45, },
                                [10] = { [1] = 0.41, [2] = 0.8, [3] = 0.94, },
                                [11] = { [1] = 1.0, [2] = 0.96, [3] = 0.41, },
                            }
function HealBot_Panel_RandomClassColour(tRole)
    local newCol=1
    while newCol>0 do
        if not tRole then
            HealBot_randomN=random(11)
        elseif tRole==HEALBOT_WORD_HEALER then
            HealBot_randomN=random(3,7)
        else
            HealBot_randomN=random(1,5)
        end
        if HealBot_randomN~=prevCol then
            prevCol=HealBot_randomN
            newCol=0
        end
    end
    return HealBot_randomClCol[HealBot_randomN][1],HealBot_randomClCol[HealBot_randomN][2],HealBot_randomClCol[HealBot_randomN][3]
end

function HealBot_Panel_TestBarsOff()
    for x,b in pairs(HealBot_TestBars) do
        HealBot_Action_DeleteButton(b.id)
        HealBot_TestBars[x]=nil
    end
end

function HealBot_Panel_PartyChanged(disableHealBot)
    for j=1,10 do
        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][j]["BARS"]==2 or Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][j]["BARS"]==4 then
            HealBot_BottomAnchors[j]=true
        else
            HealBot_BottomAnchors[j]=false
        end
    end
    hbBarsPerFrame={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
    for xHeader in pairs(HealBot_Track_Headers) do
        HealBot_Track_Headers[xHeader]=nil
    end
    if HealBot_setTestBars then
        if HealBot_Data["UILOCK"]=="NO" then
            HealBot_Panel_TestBarsOn()
        else
            HealBot_Panel_TestBarsOff()
            HealBot_Panel_PanelChanged(disableHealBot)
            HealBot_Data["REFRESH"]=1
        end
    else
        HealBot_Panel_PanelChanged(disableHealBot)
    end
end

function HealBot_Panel_PanelChanged(disableHealBot)
    nraid=GetNumGroupMembers();
    TempMaxH=9;
    local raidIconOn=false
    if not IsInRaid() then nraid=0 end;
  
    HealBot_clearEnemyUnits()
    
    for x,_ in pairs(HealBot_Action_HealButtons) do
        HealBot_Action_HealButtons[x]=nil;
    end
    
    for x,_ in pairs(HealBot_TrackNames) do
        HealBot_TrackNames[x]=nil;
    end
    for x,_ in pairs(HealBot_RaidUnitID) do
        HealBot_RaidUnitID[x]=nil;
    end
   
    for x,_ in pairs(HealBot_TrackNotVisible) do
        HealBot_TrackNotVisible[x]=nil;
    end

    for x,_ in pairs(HealBot_MainTanks) do
        HealBot_MainTanks[x]=nil;
    end
    
    for x,_ in pairs(HealBot_unitRole) do
        HealBot_unitRole[x]=nil;
    end
    
    for x,_ in pairs(HealBot_TempTanks) do
        HealBot_TempTanks[x]=nil;
    end
  
    for xGUID,_ in pairs(HealBot_Panel_BlackList) do
        HealBot_TrackNames[xGUID]=true
    end 
    
    for gl=1,10 do
        HeaderPos[gl]={};
    end

    for x,_ in pairs(HealBot_cpName) do
        HealBot_cpName[x]=nil
    end 
    
    for x,_ in pairs(HealBot_TrackUnit) do
        HealBot_TrackUnit[x]=nil
    end 
    
    table.foreach(HealBot_MyHealTargets, function (j,xGUID)
        HealBot_TrackNames[xGUID]=true
    end)
  
    i={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
    local x=false
    if HealBot_retHealBot_UseCrashProtection() and Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["CRASH"]==1 then
        if nraid==0 and not UnitExists("player2") then
            HealBot_cpData["mName"]=HealBot_Config.CrashProtMacroName
            HealBot_cpData["body0"]=GetMacroBody(HealBot_cpData["mName"].."_0")
            if HealBot_cpData["body0"] and strsub(HealBot_cpData["body0"],1,5)~="Clean" then
                local t=tonumber(strsub(HealBot_cpData["body0"],1,1))
                if t>0 and t<6 then
                    x=true
                    HealBot_cpData["numMacros"]=t
                    for j=1,t do
                        HealBot_cpData["body"..j]=GetMacroBody(HealBot_cpData["mName"].."_"..j)
                        if not HealBot_cpData["body"..j] or strlen(HealBot_cpData["body"..j])<14 then
                            x=false
                        end
                    end
                end
            end
        end
    end

    if x then -- Crash Protection
        for j=1,tonumber(HealBot_cpData["numMacros"]) do
            local u1n,u1u,u1g,u1f,u2n,u2u,u2g,u2f,u3n,u3u,u3g,u3f,u4n,u4u,u4g,u4f,
                  u5n,u5u,u5g,u5f,u6n,u6u,u6g,u6f,u7n,u7u,u7g,u7f,u8n,u8u,u8g,u8f = string.split(":", HealBot_cpData["body"..j])
            HealBot_Panel_cpSort(u1n, u1u, u1g, u1f)
            HealBot_Panel_cpSort(u2n, u2u, u2g, u2f)
            HealBot_Panel_cpSort(u3n, u3u, u3g, u3f)
            HealBot_Panel_cpSort(u4n, u4u, u4g, u4f)
            HealBot_Panel_cpSort(u5n, u5u, u5g, u5f)
            HealBot_Panel_cpSort(u6n, u6u, u6g, u6f)
            HealBot_Panel_cpSort(u7n, u7u, u7g, u7f)
            HealBot_Panel_cpSort(u8n, u8u, u8g, u8f)
        end
        local _,c1,h1f,h1p,h1n,h2f,h2p,h2n,h3f,h3p,h3n,h4f,h4p,h4n,h5f,h5p,h5n,h6f,h6p,h6n,h7f,h7p,h7n,h8f,h8p,h8n,
              h9f,h9p,h9n,h10f,h10p,h10n,h11f,h11p,h11n,h12f,h12p,h12n,h13f,h13p,h13n,h14f,h14p,h14n,h15f,h15p,h15n = string.split(":", HealBot_cpData["body0"])
        if c1=="H" then
            if tonumber(h1f) and tonumber(h1f)>0 and tonumber(h1f)<11 and h1p and h1n then HeaderPos[tonumber(h1f)][tonumber(h1p)] = h1n end
            if tonumber(h2f) and tonumber(h2f)>0 and tonumber(h2f)<11 and h2p and h2n then HeaderPos[tonumber(h2f)][tonumber(h2p)] = h2n end
            if tonumber(h3f) and tonumber(h3f)>0 and tonumber(h3f)<11 and h3p and h3n then HeaderPos[tonumber(h3f)][tonumber(h3p)] = h3n end
            if tonumber(h4f) and tonumber(h4f)>0 and tonumber(h4f)<11 and h4p and h4n then HeaderPos[tonumber(h4f)][tonumber(h4p)] = h4n end
            if tonumber(h5f) and tonumber(h5f)>0 and tonumber(h5f)<11 and h5p and h5n then HeaderPos[tonumber(h5f)][tonumber(h5p)] = h5n end
            if tonumber(h6f) and tonumber(h6f)>0 and tonumber(h6f)<11 and h6p and h6n then HeaderPos[tonumber(h6f)][tonumber(h6p)] = h6n end
            if tonumber(h7f) and tonumber(h7f)>0 and tonumber(h7f)<11 and h7p and h7n then HeaderPos[tonumber(h7f)][tonumber(h7p)] = h7n end
            if tonumber(h8f) and tonumber(h8f)>0 and tonumber(h8f)<11 and h8p and h8n then HeaderPos[tonumber(h8f)][tonumber(h8p)] = h8n end
            if tonumber(h9f) and tonumber(h9f)>0 and tonumber(h9f)<11 and h9p and h9n then HeaderPos[tonumber(h9f)][tonumber(h9p)] = h9n end
            if tonumber(h10f) and tonumber(h10f)>0 and tonumber(h10f)<11 and h10p and h10n then HeaderPos[tonumber(h10f)][tonumber(h10p)] = h10n end
            if tonumber(h11f) and tonumber(h11f)>0 and tonumber(h11f)<11 and h11p and h11n then HeaderPos[tonumber(h11f)][tonumber(h11p)] = h11n end
            if tonumber(h12f) and tonumber(h12f)>0 and tonumber(h12f)<11 and h12p and h12n then HeaderPos[tonumber(h12f)][tonumber(h12p)] = h12n end
            if tonumber(h13f) and tonumber(h13f)>0 and tonumber(h13f)<11 and h13p and h13n then HeaderPos[tonumber(h13f)][tonumber(h13p)] = h13n end
            if tonumber(h14f) and tonumber(h14f)>0 and tonumber(h14f)<11 and h14p and h14n then HeaderPos[tonumber(h14f)][tonumber(h14p)] = h14n end
            if tonumber(h15f) and tonumber(h15f)>0 and tonumber(h15f)<11 and h15p and h15n then HeaderPos[tonumber(h15f)][tonumber(h15p)] = h15n end
        end
        HealBot_cpOn=true
    else
        HealBot_cpOn=false
        if nraid>0 then
            local xUnit,xGUID,combatRole,role,online,subgroup,aRole=nil,nil,nil,nil,nil,nil,nil
            for j=1,nraid do
                xUnit = "raid"..j;
                if UnitExists(xUnit) then
                    xGUID=UnitGUID(xUnit)
                    if xGUID==HealBot_Data["PGUID"] then xUnit="player" end
                    _, _, subgroup, _, _, _, _, online, _, role, _, combatRole = GetRaidRosterInfo(j);
                    HealBot_UnitGroups[xUnit]=subgroup
                    if role and (string.lower(role)=="mainassist" or string.lower(role)=="maintank") then
                        HealBot_unitRole[xGUID]=hbRole[HEALBOT_MAINTANK]
                    else
                        if combatRole and (combatRole=="DAMAGER" or combatRole=="HEALER" or combatRole=="TANK") then
                            aRole = combatRole
                        else
                            aRole = UnitGroupRolesAssigned(xUnit)
                        end
						if aRole=="TANK" then
							HealBot_unitRole[xGUID]=hbRole[HEALBOT_MAINTANK]
							HealBot_addExtraTank(xGUID)
						elseif aRole=="HEALER" then
							HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORD_HEALER]
						elseif aRole=="DAMAGER" then
							HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORD_DPS]
						else
							HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORDS_UNKNOWN]
                            aRole=nil
						end
                    end
                    if aRole and HealBot_UnitData[xGUID] then
                        HealBot_UnitData[xGUID]["ROLE"]=aRole
                    end
                    if (not online and not HealBot_Action_retUnitOffline(xGUID)) or HealBot_Action_retUnitOffline(xGUID) then
                        HealBot_Action_UnitIsOffline(xGUID)
                    end
                    if Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["STATE"]==1 and not UnitIsVisible(xUnit) then HealBot_TrackNotVisible[xGUID]=true end
                end
            end
        else
            local xGUID,aRole=nil,nil
            for _,xUnit in ipairs(HealBot_Action_HealGroup) do
                if UnitExists(xUnit) then
                    local xGUID=HealBot_UnitGUID(xUnit)
                    HealBot_UnitGroups[xUnit]=1
                    local aRole = UnitGroupRolesAssigned(xUnit)
                    if aRole=="TANK" then
                        HealBot_unitRole[xGUID]=hbRole[HEALBOT_MAINTANK]
                        HealBot_addExtraTank(xGUID)
                    elseif aRole=="HEALER" then
                        HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORD_HEALER]
                    elseif aRole=="DAMAGER" then
                        HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORD_DPS]
                    else
                        HealBot_unitRole[xGUID]=hbRole[HEALBOT_WORDS_UNKNOWN]
                        aRole=nil
                    end
                    if aRole and HealBot_UnitData[xGUID] then
                        HealBot_UnitData[xGUID]["ROLE"]=aRole
                    end
                    if (not UnitIsConnected(xUnit) and not HealBot_Action_retUnitOffline(xGUID)) or HealBot_Action_retUnitOffline(xGUID) then
                        HealBot_Action_UnitIsOffline(xGUID)
                    end
                    if Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["STATE"]==1 and not UnitIsVisible(xUnit) then HealBot_TrackNotVisible[xGUID]=true end
                end
            end
        end
   

        if disableHealBot then
            hbCurrentFrame=1
            HealBot_Panel_selfHeals()
        else
            MyGroup["GROUP"]=0
            
            local healGroups=Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin]
            local gl=0
            for gl=1,11 do
                if healGroups[gl]["STATE"]==1 then
                    hbCurrentFrame=healGroups[gl]["FRAME"]
                    if healGroups[gl]["NAME"]==HEALBOT_OPTIONS_SELFHEALS_en then
                        HealBot_Panel_selfHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_TANKHEALS_en then
                        HealBot_Panel_tankHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_CLASSES_HEALERS_en then
                        HealBot_Panel_healerHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_GROUPHEALS_en then
                        HealBot_Panel_groupHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_MYTARGET_en then
                        HealBot_Panel_myHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_FOCUS_en then
                        HealBot_Panel_focusHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_EMERGENCYHEALS_en then
                        HealBot_Panel_raidHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_PETHEALS_en then
                        HealBot_Panel_petHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_VEHICLE_en then
                        HealBot_Panel_vehicleHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_OPTIONS_TARGETHEALS_en then
                        HealBot_Panel_targetHeals()
                    elseif healGroups[gl]["NAME"]==HEALBOT_CUSTOM_CASTBY_ENEMY_en then
                        HealBot_Panel_enemyTargets()
                    end
                    if Healbot_Config_Skins.RaidIcon[Healbot_Config_Skins.Current_Skin][hbCurrentFrame]["SHOW"]==1 then
                        raidIconOn=true
                    end
                end
            end
            
            if i[1]+i[2]+i[3]+i[4]+i[5]+i[6]+i[7]+i[8]+i[9]+i[10]==0 then 
                HealBot_Data["REFRESH"]=1 
                HealBot_AddDebug("Self not found in HealBot_Panel_PanelChanged - Retry")
            end
        end   

        for xGUID,xUnit in pairs(HealBot_TrackGUID) do
--            if xGUID~=HealBot_PlayerGUID then
                HealBot_Action_RemoveMember(xGUID,xUnit)
--            end
        end
        
        for x,_ in pairs(HealBot_TrackGUID) do
            HealBot_TrackGUID[x]=nil;
        end
        
        for xUnit,xButton in pairs(HealBot_Unit_Button) do
            local xGUID=xButton.guid
            if HealBot_TrackUnit[xUnit] and not HealBot_Panel_BlackList[xGUID] then
                if HealBot_Data["TIPUSE"]=="YES" then HealBot_talentSpam(xGUID,"insert",nil) end
                HealBot_TrackGUID[xGUID]=xUnit;
                xButton:Show()
            else
                --if xGUID and HealBot_TrackNames[xGUID] and not HealBot_Panel_BlackList[xGUID] then 
                --    HealBot_Data["REFRESH"]=7
                --    HealBot_AddDebug("Unsure Member set REFRESH=7")
                --end
                HealBot_Action_DeleteButton(xButton.id)
                HealBot_UnitGroups[xUnit]=nil
            end
        end

        if Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["CRASH"]==1 and HealBot_Data["UILOCK"]=="NO" then
            HealBot_cpData["mName"]=HealBot_Config.CrashProtMacroName
            local j=0
            local k=1
            local t=HealBot_cpData["body1"]
            HealBot_cpData["body1"]=""
            table.foreach(HealBot_Action_HealButtons, function (x,xUnit)
                local xButton=HealBot_Unit_Button[xUnit]
                if xButton then
                    local uName=UnitName(xUnit)
                    if uName then
                        j=j+1
                        if j>8 then 
                            if HealBot_cpData["body"..k]~=t then HealBot_Panel_cpSave(k) end
                            j=1 
                            k=k+1
                            t=HealBot_cpData["body"..k]
                            HealBot_cpData["body"..k]=""
                        end
                        if k<6 then
                            local lUnit=HealBot_cpsUnit(xUnit,nil)
                            if lUnit then
                                HealBot_cpData["body"..k]=HealBot_cpData["body"..k]..strsub(uName,1,5)..":"..lUnit..":"..strsub(xButton.guid,3)..":"..xButton.frame..":"
                            end
                        end
                    end
                end
            end)
            if HealBot_cpData["body"..k]~=t then HealBot_Panel_cpSave(k) end
            t=HealBot_cpData["body0"]
            showHeaders=false
            HealBot_cpData["body0"]=k..":H:"
            for bFrame=1,10 do
                if Healbot_Config_Skins.HeadBar[Healbot_Config_Skins.Current_Skin][bFrame]["SHOW"] then
                    showHeaders=true
                    for j=1,(k*10)+j do
                        if HeaderPos[bFrame][j] then 
                            HealBot_cpData["body0"]=HealBot_cpData["body0"]..bFrame..":"..j..":"..HeaderPos[bFrame][j]..":"
                        end
                    end
                end
            end
            if not showHeaders then
                HealBot_cpData["body0"]=k..":N"
            end
            if HealBot_cpData["body0"]~=t then HealBot_Panel_cpSave(0) end
        end

    end
    
    HealBot_Panel_SetupBars()

    if raidIconOn then HealBot_OnEvent_RaidTargetUpdate(nil) end
    
    if HealBot_PanelVars["setRefresh"] then
        HealBot_setOptions_Timer(9990)
    end
    HealBot_PanelVars["setRefresh"]=nil
    
end

function HealBot_Panel_selfHeals()
    local k=i[hbCurrentFrame]
    local xUnit="player";
    if not HealBot_TrackNames[HealBot_Data["PGUID"]] then
        i[hbCurrentFrame] = i[hbCurrentFrame]+1;
        local uName=UnitName(xUnit);
        HealBot_UnitName[HealBot_Data["PGUID"]] = uName;
        HealBot_UnitNameGUID[uName]=HealBot_Data["PGUID"]
        HealBot_TrackNames[HealBot_Data["PGUID"]]=true;
        table.insert(subunits,xUnit)
        HealBot_Panel_SubSort(false)
        if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["SELFPET"]==1 and not disableHealBot then
            xUnit="pet";
            local xGUID=HealBot_UnitGUID(xUnit)
            if UnitExists(xUnit) and not HealBot_TrackNames[xGUID] then
                if not HealBot_TrackNotVisible[xGUID] then
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    uName=UnitName(xUnit);
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_TrackNames[xGUID]=true;
                    table.insert(subunits,xUnit)
                    HealBot_Panel_SubSort(false)
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
        end
    end
    if i[hbCurrentFrame]>k then 
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_SELFHEALS 
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_OPTIONS_SELFHEALS 
        end
    end
end

function HealBot_Panel_tankHeals()
    local k=i[hbCurrentFrame]
    local xGUID=nil
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIT"]==1 then 
        hbincSort=true
    end
    HealBot_Panel_setTanks()
    for xGUID,xUnit in pairs(HealBot_MainTanks) do
        if not HealBot_TrackNames[xGUID] then
            if not HealBot_TrackNotVisible[xGUID] or Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["INCTANK"]==0 then
                i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                local uName=UnitName(xUnit);
                HealBot_UnitName[xGUID] = uName
                HealBot_UnitNameGUID[uName]=xGUID
                HealBot_TrackNames[xGUID]=true;
                HealBot_unitRole[xGUID]=hbRole[HEALBOT_MAINTANK]
                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                    HealBot_Panel_insSubSort(xUnit, xGUID)
                else
                    table.insert(subunits,xUnit)
                end
            else
                HealBot_setNotVisible(xGUID,xUnit)
            end
        end
    end
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(hbincSort)
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_TANKHEALS
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_OPTIONS_TANKHEALS 
        end
    end
end

function HealBot_Panel_setTanks()
    local HealBot_RegTanks = HealBot_retHealBot_MainTanks()
    for _,xGUID in pairs(HealBot_RegTanks) do
        HealBot_MainTanks[xGUID]=true 
        HealBot_TempTanks[xGUID]=true 
    end
    if nraid>0 then
        for j=1,nraid do
            xGUID=UnitGUID("raid"..j);
            if xGUID then
                if HealBot_MainTanks[xGUID] or ((HealBot_unitRole[xGUID] or "x")==hbRole[HEALBOT_MAINTANK]) then
                    if xGUID==HealBot_Data["PGUID"] then
                        HealBot_MainTanks[xGUID]="player"
                    else
                        HealBot_MainTanks[xGUID]="raid"..j
                    end
                    HealBot_TempTanks[xGUID]=nil 
                end
            end
        end
    else
        for _,xUnit in ipairs(HealBot_Action_HealGroup) do
            xGUID=HealBot_UnitGUID(xUnit);
            if xGUID then
                if HealBot_MainTanks[xGUID] or ((HealBot_unitRole[xGUID] or "x")==hbRole[HEALBOT_MAINTANK]) then
                    HealBot_MainTanks[xGUID]=xUnit
                    HealBot_TempTanks[xGUID]=nil 
                end
            end
        end
    end
    for xGUID,_ in pairs(HealBot_TempTanks) do
        HealBot_MainTanks[xGUID]=nil
    end
    table.foreach(HealBot_MyPrivateTanks, function (index,xGUID)
        local xUnit=HealBot_RaidUnit(xGUID) or "unknown"
        if xUnit and UnitExists(xUnit) then  
            HealBot_MainTanks[xGUID]=xUnit
        end
    end)
end

function HealBot_Panel_healerHeals()
    local hbHealers={}
    local k=i[hbCurrentFrame]
    local xGUID=nil
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIT"]==1 then 
        hbincSort=true
    end
    if nraid>0 then
        for j=1,nraid do
        xGUID=UnitGUID("raid"..j);
            if xGUID and not HealBot_TrackNames[xGUID] then
                if ((HealBot_unitRole[xGUID] or "x")==hbRole[HEALBOT_WORD_HEALER]) then
                    if xGUID==HealBot_Data["PGUID"] then
                        hbHealers[xGUID]="player"
                    else
                        hbHealers[xGUID]="raid"..j
                    end
                end
            end
        end
    else
        for _,xUnit in ipairs(HealBot_Action_HealGroup) do
            xGUID=HealBot_UnitGUID(xUnit);
            if xGUID and not HealBot_TrackNames[xGUID] then
                if ((HealBot_unitRole[xGUID] or "x")==hbRole[HEALBOT_WORD_HEALER]) then
                    hbHealers[xGUID]=xUnit
                end
            end
        end
    end
    for xGUID,xUnit in pairs(hbHealers) do
        if not HealBot_TrackNotVisible[xGUID] then
            i[hbCurrentFrame] = i[hbCurrentFrame]+1;
            local uName=UnitName(xUnit);
            HealBot_UnitName[xGUID] = uName
            HealBot_UnitNameGUID[uName]=xGUID
            HealBot_TrackNames[xGUID]=true;
            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                HealBot_Panel_insSubSort(xUnit, xGUID)
            else
                table.insert(subunits,xUnit)
            end
        else
            HealBot_setNotVisible(xGUID,xUnit)
        end
    end
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(hbincSort)
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_CLASSES_HEALERS 
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_CLASSES_HEALERS 
        end
    end
end

function HealBot_Panel_groupHeals()
    local k=i[hbCurrentFrame]
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIG"]==1 then 
        hbincSort=true
    end
    local z=0
    for _,xUnit in ipairs(HealBot_Action_HealGroup) do
        if UnitExists(xUnit) then
            local xGUID=HealBot_UnitGUID(xUnit)
            if not HealBot_TrackNames[xGUID] then
                if not HealBot_TrackNotVisible[xGUID] or Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["INCGROUP"]==0 then
                    local uName=UnitName(xUnit);
                    if nraid>0 and uName~=HealBot_Data["PNAME"] then 
                        local pUnit=xUnit
                        xUnit=HealBot_RaidUnit(xGUID) or xUnit
                        HealBot_RaidUnitID[pUnit]=xUnit
                    end
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitNameGUID[uName]=xGUID
                    HealBot_TrackNames[xGUID]=true;
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                        HealBot_Panel_insSubSort(xUnit, xGUID)
                    else
                        table.insert(subunits,xUnit)
                    end
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
        elseif nraid==0 and Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBAT"]==1 and 
                            z<Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBATPARTY"] then 
            local xGUID = xUnit
            if not HealBot_TrackNames[xGUID] then
                z=z+1
                local uName = HEALBOT_WORD_RESERVED..":"..xUnit
                HealBot_UnitGroups[xUnit]=1
                i[hbCurrentFrame]=i[hbCurrentFrame]+1;
                HealBot_UnitName[xGUID] = uName;
                HealBot_TrackNames[xGUID]=true;
                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                    HealBot_Panel_insSubSort(xUnit, xGUID)
                else
                    table.insert(subunits,xUnit)
                end
            end
        end
    end
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(hbincSort)
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            MyGroup["GROUP"]=i[hbCurrentFrame]+1
            HeaderPos[hbCurrentFrame][MyGroup["GROUP"]] = HEALBOT_OPTIONS_GROUPHEALS 
        else
            MyGroup["GROUP"]=k+1
            HeaderPos[hbCurrentFrame][MyGroup["GROUP"]] = HEALBOT_OPTIONS_GROUPHEALS 
        end
        MyGroup["FRAME"]=hbCurrentFrame
    else
        MyGroup["GROUP"]=0
    end
end

function HealBot_Panel_myHeals()
    local k=i[hbCurrentFrame]
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIMT"]==1 then 
        hbincSort=true
    end
    local uName,xUnit=nil,nil
    table.foreach(HealBot_MyHealTargets, function (index,xGUID)
        xUnit=HealBot_RaidUnit(xGUID) or "unknown"
        --HealBot_AddDebug("Trying xUnit Added My Target "..xUnit)
        if UnitExists(xUnit) then
            if not HealBot_TrackNotVisible[xGUID] or Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["INCMYTARGETS"]==0 then
                i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                uName=UnitName(xUnit)
                HealBot_UnitName[xGUID] = uName
                HealBot_UnitNameGUID[uName]=xGUID
                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                    HealBot_Panel_insSubSort(xUnit, xGUID)
                else
                    table.insert(subunits,xUnit)
                end
            else
                HealBot_setNotVisible(xGUID,xUnit)
            end
        elseif HealBot_Unit_Button[xUnit] then
            HealBot_Panel_ToggelHealTarget(xUnit)
        end
    end)
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(hbincSort)
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_MYTARGET 
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_OPTIONS_MYTARGET 
        end
    end
end

function HealBot_Panel_focusHeals()
    local k=i[hbCurrentFrame]
    local xUnit="focus"
    local uName=UnitName(xUnit)
    local xGUID=HealBot_UnitGUID(xUnit)
    local uExists=false
    if UnitExists(xUnit) and (Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["FONLYFRIEND"]==0 or UnitIsFriend("player",xUnit)) then
        uExists=true
    end
    if uExists then
        if xGUID and not HealBot_TrackNames[xGUID] then 
            if not HealBot_TrackNotVisible[xGUID] or Healbot_Config_Skins.BarsHide[Healbot_Config_Skins.Current_Skin]["INCFOCUS"]==0 then
                HealBot_TrackNames[xGUID]=true;
                i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                HealBot_UnitName[xGUID] = uName
                HealBot_UnitNameGUID[uName]=xGUID
                table.insert(subunits,xUnit)
            else
                HealBot_setNotVisible(xGUID,xUnit)
            end
        end
    elseif Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["FALWAYSSHOW"]==1 then
        xGUID = xUnit
        if not HealBot_TrackNames[xGUID] then 
            HealBot_TrackNames[xGUID]=true;
            i[hbCurrentFrame] = i[hbCurrentFrame]+1;
            uName = HEALBOT_WORD_RESERVED..":"..xUnit
            HealBot_UnitName[xGUID] = uName
            table.insert(subunits,xUnit)
        end
    end
    
    if i[hbCurrentFrame]>k then 
        if UnitIsFriend("player",xUnit) or uName==HEALBOT_WORD_RESERVED..":"..xUnit then
            HealBot_Panel_SubSort(false)
        else
            HealBot_Panel_SubSort(false, true)
        end
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_FOCUS
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_FOCUS 
        end
    end
end

function HealBot_Panel_raidHeals()
    for x,_ in pairs(order) do
        order[x]=nil;
    end
    for x,_ in pairs(units) do
        units[x]=nil;
    end
    for x,_ in pairs(subunits) do
        subunits[x]=nil;
    end
    local k=i[hbCurrentFrame]
    local xUnit=nil
    local xGUID=nil
    local uName=nil
    local subgroup=1;
    local classEN=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 or Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==5 then
        if not HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_EMERGENCYHEALS end
    end
    if Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==1 then
        
        if nraid>0 then
            local z=0
            for j=1,nraid do
                xUnit = "raid"..j;
                xGUID=UnitGUID(xUnit)
                _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(j);
                if xGUID then
                    if xGUID==HealBot_Data["PGUID"] then
                        xUnit="player"
                        if MyGroup["GROUP"]>0 then
                            HeaderPos[MyGroup["FRAME"]][MyGroup["GROUP"]] = HEALBOT_OPTIONS_GROUPHEALS.." "..subgroup;
                        end
                    end
                end
                if UnitExists(xUnit) then
                    HealBot_UnitGroups[xUnit]=subgroup
                    if not HealBot_TrackNames[xGUID] then
                        if not HealBot_TrackNotVisible[xGUID] then
                            _,classEN=UnitClass(xUnit)
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] and classEN then
                                uName=UnitName(xUnit);
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = classEN;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-UnitHealthMax(xUnit);
                                    if UnitHealthMax(xUnit)>TempMaxH then TempMaxH=UnitHealthMax(xUnit); end
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_UnitNameGUID[uName]=xGUID
                                HealBot_TrackNames[xGUID]=true;
                            end
                        else
                            HealBot_setNotVisible(xGUID,xUnit)
                        end
                    end
                elseif Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBAT"]==1 and 
                       z<Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBATRAID"] then 
                    xGUID = xUnit
                    if not HealBot_TrackNames[xGUID] then
                        HealBot_UnitGroups[xUnit]=8
                        z=z+1
                        if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] then
                            uName = HEALBOT_WORD_RESERVED..":"..xUnit
                            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                order[xUnit] = "ZZZZ"..uName;
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                order[xUnit] = "WARRIOR"
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                order[xUnit] = 8;
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                order[xUnit] = 0-maxHealDiv;
                            end
                            table.insert(units,xUnit);
                            HealBot_UnitName[xGUID] = uName;
                            HealBot_TrackNames[xGUID]=true;
                        end
                    end
                end
            end
        else
            local z=0
            for _,xUnit in ipairs(HealBot_Action_HealGroup) do
                xGUID=HealBot_UnitGUID(xUnit)
                if UnitExists(xUnit) then
                    if not HealBot_TrackNames[xGUID] then
                        if not HealBot_TrackNotVisible[xGUID] then
                            _,classEN=UnitClass(xUnit)
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] and classEN then
                                uName=UnitName(xUnit);
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = classEN;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-UnitHealthMax(xUnit);
                                    if UnitHealthMax(xUnit)>TempMaxH then TempMaxH=UnitHealthMax(xUnit); end
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_UnitNameGUID[uName]=xGUID
                                HealBot_TrackNames[xGUID]=true;
                            end
                        else
                            HealBot_setNotVisible(xGUID,xUnit)
                        end
                    end
                else
                    local gState=0
                    for id=1,10 do
                        if Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin][id]["NAME"]==HEALBOT_OPTIONS_GROUPHEALS_en then
                            gState=Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin][id]["STATE"]
                            break
                        end
                    end
                    if Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBAT"]==1 and gState==0 and z<Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBATPARTY"] then 
                        xGUID = xUnit
                        if not HealBot_TrackNames[xGUID] then
                            HealBot_UnitGroups[xUnit]=subgroup
                            z=z+1
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] then
                                uName = HEALBOT_WORD_RESERVED..":"..xUnit
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = "ZZZZ"..uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = "WARRIOR";
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-maxHealDiv;
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_TrackNames[xGUID]=true;
                            end
                        end
                    end
                end
            end
        end
    else
        if nraid>0 then
            local z=0
            for j=1,nraid do
                xUnit = "raid"..j;
                xGUID=UnitGUID(xUnit)
                _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(j);
                if xGUID then
                    if xGUID==HealBot_Data["PGUID"] then
                        xUnit="player"
                        if MyGroup["GROUP"]>0 then
                            HeaderPos[MyGroup["FRAME"]][MyGroup["GROUP"]] = HEALBOT_OPTIONS_GROUPHEALS.." "..subgroup;
                        end
                    end
                end
                if UnitExists(xUnit) and xGUID then
                    HealBot_UnitGroups[xUnit]=subgroup
                    if not HealBot_TrackNames[xGUID] then
                        if not HealBot_TrackNotVisible[xGUID] then
                            _,classEN=UnitClass(xUnit)
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] and classEN and HealBot_Options_retEmergInc(strsub(classEN,1,4))==1 then
                                uName=UnitName(xUnit);
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = classEN;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-UnitHealthMax(xUnit);
                                    if UnitHealthMax(xUnit)>TempMaxH then TempMaxH=UnitHealthMax(xUnit); end
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_UnitNameGUID[uName]=xGUID
                                HealBot_TrackNames[xGUID]=true;
                            end
                        else
                            HealBot_setNotVisible(xGUID,xUnit)
                        end
                    end
                elseif Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBAT"]==1 and 
                       z<Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBATRAID"] then 
                    xGUID = xUnit
                    if not HealBot_TrackNames[xGUID] then
                        HealBot_UnitGroups[xUnit]=8
                        z=z+1
                        if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] then
                            uName = HEALBOT_WORD_RESERVED..":"..xUnit
                            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                order[xUnit] = "ZZZZ"..uName;
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                order[xUnit] = "WARRIOR";
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                order[xUnit] = 8;
                            elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                order[xUnit] = 0-maxHealDiv;
                            end
                            table.insert(units,xUnit);
                            HealBot_UnitName[xGUID] = uName;
                            HealBot_TrackNames[xGUID]=true;
                        end
                    end
                end
            end
        else
            local z=0
            for _,xUnit in ipairs(HealBot_Action_HealGroup) do
                _,classEN = UnitClass(xUnit);
                xGUID=HealBot_UnitGUID(xUnit)
                if UnitExists(xUnit) then
                    HealBot_UnitGroups[xUnit]=subgroup
                    if not HealBot_TrackNames[xGUID] then
                        if not HealBot_TrackNotVisible[xGUID] then
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] and HealBot_Options_retEmergInc(strsub(classEN,1,4))==1 then
                                uName=UnitName(xUnit);
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = classEN;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-UnitHealthMax(xUnit);
                                    if UnitHealthMax(xUnit)>TempMaxH then TempMaxH=UnitHealthMax(xUnit); end
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_UnitNameGUID[uName]=xGUID
                                HealBot_TrackNames[xGUID]=true;
                            end
                        else
                            HealBot_setNotVisible(xGUID,xUnit)
                        end
                    end
                else
                    local gState=0
                    for id=1,10 do
                        if Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin][id]["NAME"]==HEALBOT_OPTIONS_GROUPHEALS_en then
                            gState=Healbot_Config_Skins.HealGroups[Healbot_Config_Skins.Current_Skin][id]["STATE"]
                            break
                        end
                    end
                    if Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBAT"]==1 and gState==0 and z<Healbot_Config_Skins.Protection[Healbot_Config_Skins.Current_Skin]["COMBATPARTY"] then 
                        xGUID = xUnit
                        if not HealBot_TrackNames[xGUID] then
                            HealBot_UnitGroups[xUnit]=subgroup
                            z=z+1
                            if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][subgroup] then
                                uName = HEALBOT_WORD_RESERVED..":"..xUnit
                                if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                                    order[xUnit] = "ZZZZ"..uName;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                                    order[xUnit] = "WARRIOR";
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                                    order[xUnit] = subgroup;
                                elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                                    order[xUnit] = 0-maxHealDiv;
                                end
                                table.insert(units,xUnit);
                                HealBot_UnitName[xGUID] = uName;
                                HealBot_TrackNames[xGUID]=true;
                            end
                        end
                    end
                end
            end
        end
    end
    for bi=1,4 do
        xUnit="boss"..bi
        xGUID=UnitGUID(xUnit)
        if UnitExists(xUnit) and UnitIsFriend("player",xUnit) and UnitHealth(xUnit)>99 then
            if not HealBot_TrackNames[xGUID] then
                if not HealBot_TrackNotVisible[xGUID] then
                    uName=UnitName(xUnit);
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 then
                        order[xUnit] = uName;
                    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 then
                        _,classEN=UnitClass(xUnit)
                        order[xUnit] = classEN;
                    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 then
                        order[xUnit] = 9;
                    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 then
                        order[xUnit] = 0-UnitHealthMax(xUnit);
                        if UnitHealthMax(xUnit)>TempMaxH then TempMaxH=UnitHealthMax(xUnit); end
                    end
                    table.insert(units,xUnit);
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitNameGUID[uName]=xGUID
                    HealBot_TrackNames[xGUID]=true;
                end
            end
        end
    end
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]<5 then
        table.sort(units,function (a,b)
            if order[a]<order[b] then return true end
            if order[a]>order[b] then return false end
            return a<b
        end)
    end
    local TempMaxH=ceil(TempMaxH/maxHealDiv)*maxHealDiv;
    local TempMaxHinit=TempMaxH
    local TempSort,TempGrp,TempUnitMaxH="init",99,1
    local class,classEN=HEALBOT_WARRIOR,"WARRIOR"
    local PrevSort,SubSort=nil,nil
    for x,_ in pairs(order) do
        order[x]=nil;
    end

    for j=1,41 do
        if not units[j] then 
            classEN="end"
            TempGrp=99
            TempUnitMaxH=1
        else
            xUnit=units[j];
            if UnitExists(xUnit) then
                class,classEN = UnitClass(xUnit)
                xGUID=HealBot_UnitGUID(xUnit)
                TempUnitMaxH=UnitHealthMax(xUnit)
            else
                classEN = "WARRIOR";
                class = HEALBOT_WARRIOR
                xGUID = xUnit
                TempUnitMaxH = maxHealDiv
            end
            TempGrp=HealBot_UnitGroups[xUnit] or 8
            i[hbCurrentFrame] = i[hbCurrentFrame]+1;
        end
        if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==2 and TempSort~=classEN then 
            if TempSort=="init" then 
                SubSort=classEN
            else
                if HealBot_BottomAnchors[hbCurrentFrame] then 
                    if units[j] then 
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = PrevSort
                    else
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = PrevSort
                    end
                end
            end
            TempSort=classEN
            if units[j] and not HealBot_BottomAnchors[hbCurrentFrame] then 
                HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = class
            else
                PrevSort=class
            end
            if TempSort~=SubSort then
                HealBot_Panel_SubSort(true)
                SubSort=TempSort
            end
        elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==3 and TempSort~=TempGrp then
            if TempSort=="init" then 
                SubSort=TempGrp
            else
                if HealBot_BottomAnchors[hbCurrentFrame] then 
                    if units[j] then 
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = PrevSort
                    else
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = PrevSort
                    end
                end
            end
            TempSort=TempGrp
            if units[j] and not HealBot_BottomAnchors[hbCurrentFrame] then  
                HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = HEALBOT_OPTIONS_GROUPHEALS.." "..TempSort
            else
                PrevSort=HEALBOT_OPTIONS_GROUPHEALS.." "..TempSort
            end
            if TempSort~=SubSort then
                HealBot_Panel_SubSort(true)
                SubSort=TempSort
            end
        elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==4 and TempMaxH>TempUnitMaxH then
            if TempMaxHinit==TempMaxH then 
                SubSort=TempMaxH-maxHealDiv
            else
                if HealBot_BottomAnchors[hbCurrentFrame] then 
                    if units[j] then 
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = PrevSort
                    else
                        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = PrevSort
                    end
                end
            end
            TempMaxH=TempMaxH-maxHealDiv
            if TempMaxH>TempUnitMaxH and TempMaxH>0 then 
                TempMaxH=TempMaxH-maxHealDiv
                if TempMaxH>TempUnitMaxH and TempMaxH>0 then 
                    TempMaxH=TempMaxH-maxHealDiv
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                    if TempMaxH>TempUnitMaxH and TempMaxH>0 then TempMaxH=TempMaxH-maxHealDiv end
                end
            end
            if units[j] and not HealBot_BottomAnchors[hbCurrentFrame] then 
                HeaderPos[hbCurrentFrame][i[hbCurrentFrame]] = ">"..format("%s",(TempMaxH/1000)).."k"
            else
                PrevSort=">"..format("%s",(TempMaxH/1000)).."k"
            end
            if TempMaxH~=SubSort then
                HealBot_Panel_SubSort(true)
                SubSort=TempMaxH
            end
        end
        if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==5 and not units[j] then
            HealBot_Panel_SubSort(true)
        elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["RAIDORDER"]==1 and units[j] then
            table.insert(subunits,xUnit)
            HealBot_Panel_SubSort(false)
        elseif units[j] then
            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 then
                HealBot_Panel_insSubSort(xUnit, xGUID)
            else
                table.insert(subunits,xUnit)
            end
        else
            do break end
        end
    end
    if i[hbCurrentFrame]==k+1 and not HealBot_BottomAnchors[hbCurrentFrame] then
        HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = nil 
 --   else
 --       if HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_EMERGENCYHEALS end
    end
end

function HealBot_Panel_petHeals()
    if not HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS end
    local k=i[hbCurrentFrame]
    local xUnit="pet"
    local uName=UnitName(xUnit);
    local pUnit="player"
    local xGUID=HealBot_UnitGUID(xUnit)
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIP"]==1 then 
        hbincSort=true
    end
    if UnitExists(xUnit) and not HealBot_TrackNames[xGUID] and not UnitUsingVehicle(pUnit) then
        if not HealBot_TrackNotVisible[xGUID] then
            i[hbCurrentFrame] = i[hbCurrentFrame]+1;
            HealBot_UnitName[xGUID] = uName;
            HealBot_UnitGroups[xUnit]=HealBot_UnitGroups[pUnit]
            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                HealBot_Panel_insSubSort(xUnit, xGUID)
            else
                table.insert(subunits,xUnit)
            end
        else
            HealBot_setNotVisible(xGUID,xUnit)
        end
    end
    if nraid>0 then
        for j=1,nraid do
            xUnit="raidpet"..j;
            xGUID=HealBot_UnitGUID(xUnit)
            pUnit="raid"..j;
            if UnitExists(xUnit) and not HealBot_TrackNames[xGUID] and HealBot_TrackNames[UnitGUID(pUnit)] and not UnitUsingVehicle(pUnit) then
                if not HealBot_TrackNotVisible[xGUID] then
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    uName=UnitName(xUnit);
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitGroups[xUnit]=HealBot_UnitGroups[pUnit]
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                        HealBot_Panel_insSubSort(xUnit, xGUID)
                    else
                        table.insert(subunits,xUnit)
                    end
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
            if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["GROUPPETS"] == 1 then
                if not HealBot_BottomAnchors[hbCurrentFrame] and i[hbCurrentFrame]-k == 6 then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]-5] = HEALBOT_OPTIONS_PETHEALS.." 1" end
                if i[hbCurrentFrame]>k and ((i[hbCurrentFrame]-k)%5 == 0) then                           
                    HealBot_Panel_SubSort(hbincSort)        
                    HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS.." "..((i[hbCurrentFrame]-k)/5)+(HealBot_BottomAnchors[hbCurrentFrame] and 0 or 1)
                end
            end
        end
        if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["GROUPPETS"] == 1 and HealBot_BottomAnchors[hbCurrentFrame] and i[hbCurrentFrame]-k == 5 then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS 
        end
    else
        for j=1,4 do
            xUnit="partypet"..j;
            xGUID=HealBot_UnitGUID(xUnit)
            pUnit="party"..j;
            if UnitExists(xUnit) and not HealBot_TrackNames[xGUID] and HealBot_TrackNames[UnitGUID(pUnit)] and not UnitUsingVehicle(pUnit) then
                if not HealBot_TrackNotVisible[xGUID] then
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    uName=UnitName(xUnit);
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitGroups[xUnit]=1
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                        HealBot_Panel_insSubSort(xUnit, xGUID)
                    else
                        table.insert(subunits,xUnit)
                    end
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
        end
    end
    if i[hbCurrentFrame]>k then
        HealBot_Panel_SubSort(hbincSort)        
        --if HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS end
        if HealBot_BottomAnchors[hbCurrentFrame] then
            if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["GROUPPETS"] == 0 then
                HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS
            elseif nraid==0 or (i[hbCurrentFrame]-k)%5>0 then 
                HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_PETHEALS..(i[hbCurrentFrame]-k>5 and " "..ceil((i[hbCurrentFrame]-k)/5) or "")
            end
        end
    end
end

function HealBot_Panel_vehicleHeals()
    local hbincSort=nil
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBIV"]==1 then 
        hbincSort=true
    end
    local k=i[hbCurrentFrame]
    local xUnit="pet"
    local pUnit="player"
    local xGUID=HealBot_UnitGUID(xUnit)
    local uName=UnitName(xUnit);
    if xGUID and not HealBot_TrackNames[xGUID] and UnitUsingVehicle(pUnit) and uName then
        if not HealBot_TrackNotVisible[xGUID] then
            i[hbCurrentFrame] = i[hbCurrentFrame]+1;
            HealBot_UnitName[xGUID] = uName;
            HealBot_UnitGroups[xUnit]=HealBot_UnitGroups[pUnit]
            if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                HealBot_Panel_insSubSort(xUnit, xGUID)
            else
                table.insert(subunits,xUnit)
            end
        else
            HealBot_setNotVisible(xGUID,xUnit)
        end
    end
    if nraid>0 then
        for j=1,nraid do
            xUnit="raidpet"..j;
            xGUID=HealBot_UnitGUID(xUnit)
            pUnit="raid"..j;
            uName=UnitName(xUnit);
            if xGUID and not HealBot_TrackNames[xGUID] and HealBot_TrackNames[UnitGUID(pUnit)] and UnitUsingVehicle(pUnit) and uName then
                if not HealBot_TrackNotVisible[xGUID] then
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitGroups[xUnit]=HealBot_UnitGroups[pUnit]
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                        HealBot_Panel_insSubSort(xUnit, xGUID)
                    else
                        table.insert(subunits,xUnit)
                    end
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
        end
    else
        for j=1,4 do
            xUnit="partypet"..j;
            xGUID=HealBot_UnitGUID(xUnit)
            pUnit="party"..j;
            uName=UnitName(xUnit);
            if xGUID and not HealBot_TrackNames[xGUID] and HealBot_TrackNames[UnitGUID(pUnit)] and UnitUsingVehicle(pUnit) and uName then
                if not HealBot_TrackNotVisible[xGUID] then
                    i[hbCurrentFrame] = i[hbCurrentFrame]+1;
                    HealBot_UnitName[xGUID] = uName;
                    HealBot_UnitGroups[xUnit]=1
                    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
                        HealBot_Panel_insSubSort(xUnit, xGUID)
                    else
                        table.insert(subunits,xUnit)
                    end
                else
                    HealBot_setNotVisible(xGUID,xUnit)
                end
            end
        end
    end
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(hbincSort)    
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_VEHICLE
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_VEHICLE 
        end
    end
end

function HealBot_Panel_targetHeals()
    local xUnit="target";
    local uName=UnitName(xUnit)
    local TargetValid=false
    local IsFighting=1
    if HealBot_Data["UILOCK"]=="NO" then IsFighting=0 end
    local k=i[hbCurrentFrame]
    local xGUID=nil
    local uExists=false
    if UnitExists(xUnit) and (Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TONLYFRIEND"]==0 or UnitIsFriend("player",xUnit)) then
        uExists=true
    end
    if uExists and UnitHealth(xUnit)>99 and (Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TALWAYSSHOW"]==1 or IsFighting==0) then
        xGUID=HealBot_UnitGUID(xUnit)
        if (not UnitInRaid(xUnit) and not UnitInParty(xUnit)) or ((UnitInRaid(xUnit) or UnitInParty(xUnit)) and xGUID and HealBot_TrackNames[xGUID]) then
            if uName==HealBot_Data["PNAME"] then 
                if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TINCSELF"]==1 then TargetValid=true end
            elseif UnitInParty("target") then
                if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TINCGROUP"]==1 then TargetValid=true end
            elseif UnitInRaid("target") then 
                if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TINCRAID"]==1 then TargetValid=true end
            elseif UnitPlayerOrPetInParty("target") or UnitPlayerOrPetInRaid("target") then
                if Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TINCPET"]==1 then TargetValid=true end
            else
                TargetValid=true
            end
        end
    end
    if TargetValid and not HealBot_Panel_BlackList[xGUID] then
        HealBot_UnitName[xGUID] = uName;    
        i[hbCurrentFrame] = i[hbCurrentFrame]+1;
        table.insert(subunits,xUnit)
        if hbPanelShowhbFocus then hbPanelShowhbFocus=hbCurrentFrame end
    elseif Healbot_Config_Skins.Healing[Healbot_Config_Skins.Current_Skin]["TALWAYSSHOW"]==1 then
        i[hbCurrentFrame] = i[hbCurrentFrame]+1;
        uName = HEALBOT_WORD_RESERVED..":"..xUnit
        HealBot_UnitName[xUnit] = uName
        table.insert(subunits,xUnit)
    end
    
    if i[hbCurrentFrame]>k then 
        if UnitIsFriend("player",xUnit) or uName==HEALBOT_WORD_RESERVED..":"..xUnit then
            HealBot_Panel_SubSort(false)
        else
            HealBot_Panel_SubSort(false, true)
        end
        if HealBot_BottomAnchors[hbCurrentFrame] then
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_TARGETHEALS
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_OPTIONS_TARGETHEALS 
        end
    end
end

function HealBot_Panel_enemyTargets()
    if not HealBot_BottomAnchors[hbCurrentFrame] then HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_OPTIONS_TARGETHEALS end
    local k=i[hbCurrentFrame]
    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["INCSELF"]==1 then
        if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["HIDE"]==1 then
            if HealBot_Data["UILOCK"]=="YES" then
                if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["EXISTSHOWPTAR"]==1 then
                    if UnitExists("playertarget") and not UnitIsFriend("player","playertarget") then
                        HealBot_Panel_enemyBar("playertarget", "player")
                    end
                else
                    HealBot_Panel_enemyBar("playertarget", "player")
                end
            end
        else
            HealBot_Panel_enemyBar("playertarget", "player")
        end
    end
    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["INCTANKS"]==1 then
        if #HealBot_MainTanks<1 then
            HealBot_Panel_setTanks()
        end
        for _,xUnit in pairs(HealBot_MainTanks) do
            if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["HIDE"]==1 then
                if HealBot_Data["UILOCK"]=="YES" then
                    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["EXISTSHOWPTAR"]==1 then
                        if UnitExists(xUnit.."target") and not UnitIsFriend(xUnit,xUnit.."target") then
                            HealBot_Panel_enemyBar(xUnit.."target", xUnit)
                        end
                    else
                        HealBot_Panel_enemyBar(xUnit.."target", xUnit)
                    end
                end
            else
                HealBot_Panel_enemyBar(xUnit.."target", xUnit)
            end
        end
    end
    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["INCMYTAR"]==1 then
        table.foreach(HealBot_MyHealTargets, function (index,xGUID)
            xUnit=HealBot_RaidUnit(xGUID) or "unknown"
            if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["HIDE"]==1 then
                if HealBot_Data["UILOCK"]=="YES" then
                    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["EXISTSHOWPTAR"]==1 then
                        if UnitExists(xUnit.."target") and not UnitIsFriend(xUnit,xUnit.."target") then
                            HealBot_Panel_enemyBar(xUnit.."target", xUnit)
                        end
                    else
                        HealBot_Panel_enemyBar(xUnit.."target", xUnit)
                    end
                end
            else
                HealBot_Panel_enemyBar(xUnit.."target", xUnit)
            end
        end)
    end
    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["NUMBOSS"]>0 then
        for bi=1,Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["NUMBOSS"] do
            if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["HIDE"]==1 then
                if HealBot_Data["UILOCK"]=="YES" then
                    if Healbot_Config_Skins.Enemy[Healbot_Config_Skins.Current_Skin]["EXISTSHOWBOSS"]==1 then
                        if UnitExists("boss"..bi) then
                            HealBot_Panel_enemyBar("boss"..bi, "boss"..bi)
                        end
                    else
                        HealBot_Panel_enemyBar("boss"..bi, "boss"..bi)
                    end
                end
            else
                HealBot_Panel_enemyBar("boss"..bi, "boss"..bi)
            end
        end
    end
    if i[hbCurrentFrame]>k then 
        HealBot_Panel_SubSort(true, true)
        if HealBot_BottomAnchors[hbCurrentFrame] then 
            HeaderPos[hbCurrentFrame][i[hbCurrentFrame]+1] = HEALBOT_CUSTOM_CASTBY_ENEMY 
        else
            HeaderPos[hbCurrentFrame][k+1] = HEALBOT_CUSTOM_CASTBY_ENEMY 
        end
    end
end

function HealBot_Panel_enemyBar(unit, pUnit)
    local xGUID=unit
    local uName=HEALBOT_ENEMY_NO_TARGET
    local incEnemy=true
    if UnitExists(unit) and UnitHealth(unit)>99 then
        if not UnitIsFriend("player",unit) then
            xGUID=HealBot_UnitGUID(unit)
            uName=UnitName(unit)
        else
            incEnemy=false
        end
    end
    if incEnemy then
        HealBot_UnitName[unit]=uName;    
        i[hbCurrentFrame]=i[hbCurrentFrame]+1;
        table.insert(subunits,unit)
        HealBot_setEnemyUnits(unit, xGUID, pUnit)
    end
end

function HealBot_Panel_cpSave(mNum)
    HealBot_cpQueue(mNum, HealBot_cpData["mName"].."_"..mNum, HealBot_cpData["body"..mNum])
end

function HealBot_Panel_insSubSort(unit, hbGUID)
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]==1 then
        if unit == "player" and Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
            order[unit] = "!";
        elseif UnitExists(unit) then
            order[unit] = HealBot_UnitName[hbGUID];
        else
            order[unit] = "ZZZZ"..HealBot_UnitName[hbGUID];
        end
    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]==2 then
        local _,classEN = UnitClass(unit);
        if unit == "player" and Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
            order[unit] = "!";
        else
            order[unit] = classEN or "ZZ"
        end
    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]==3 then
        if unit == "player" and Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
            order[unit] = -1
        elseif UnitExists(unit) then
            order[unit] = HealBot_UnitGroups[unit]
        else
            order[unit] = 9
        end
    elseif Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]==4 then
        if unit == "player" and Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
            order[unit] = -99999999
        else
            order[unit] = 0-(UnitHealthMax(unit) or 1)
        end
    else
        if unit == "player" and Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBPF"]==1 then
            order[unit] = -1
        else
            order[unit] = HealBot_unitRole[hbGUID] or 99
        end
    end
    table.insert(subunits,unit)
end

function HealBot_Panel_SubSort(hbincSort,enemy)
    if Healbot_Config_Skins.Sort[Healbot_Config_Skins.Current_Skin]["SUBORDER"]<6 and hbincSort then
        table.sort(subunits,function (a,b)
            if not order[a] or not order[b] then
                return false
            else
                if order[a]<order[b] then return true end
                if order[a]>order[b] then return false end
                return a<b
            end
        end)
    end
    for j=1,#subunits do
        local sUnit=subunits[j];
        local sGUID=HealBot_UnitGUID(sUnit) or sUnit
        if not HealBot_TrackUnit[sUnit] and not HealBot_Panel_BlackList[sGUID] then
            local setBtutton=HealBot_Action_SetHealButton(sUnit,sGUID,hbCurrentFrame,enemy);
            if setBtutton then
                HealBot_TrackUnit[sUnit]=true
                HealBot_TrackGUID[sGUID]=nil
                HealBot_UnitData[sGUID]["NAME"]=HealBot_UnitName[sGUID]
                table.insert(HealBot_Action_HealButtons,sUnit)
                hbBarsPerFrame[hbCurrentFrame]=hbBarsPerFrame[hbCurrentFrame]+1
            end
        end
    end
    for x,_ in pairs(order) do
        order[x]=nil;
    end
    for x,_ in pairs(subunits) do
        subunits[x]=nil;
    end
end

function HealBot_Panel_cpSort(unitName, unit, hbGUID, hbCurFrame)
    if unitName and unit and hbGUID then
        unit=HealBot_cpsUnit(nil,unit)
        if not HealBot_TrackUnit[unit] then
            hbGUID="0x"..hbGUID
            HealBot_UnitName[hbGUID] = unitName;
            local frameNo=tonumber(hbCurFrame) or 1
            local setBtutton=HealBot_Action_SetHealButton(unit,hbGUID,frameNo);
            if setBtutton then
                table.insert(HealBot_Action_HealButtons,unit)
                HealBot_cpName[unit]=unitName
                HealBot_UnitData[hbGUID]["NAME"]=unitName
                HealBot_TrackUnit[unit]=true
                HealBot_TrackGUID[hbGUID]=nil
                hbBarsPerFrame[frameNo]=hbBarsPerFrame[frameNo]+1
            end
        end
    end
end

function HealBot_cpsUnit(unit,sUnit)
    local xUnit=nil
    if unit then
        if unit=="player" then
            xUnit="p"
    --    elseif unit=="pet" then
    --        xUnit="t"
        elseif strsub(unit,6,3)=="pet" then
    --        xUnit="t"..strsub(unit,10)
        elseif strsub(unit,1,5)=="party" then
            xUnit="g"..strsub(unit,6)
        elseif strsub(unit,5,3)=="pet" then
--            xUnit="z"..strsub(unit,8)
        elseif strsub(unit,1,4)=="raid" then
            xUnit=strsub(unit,5)
        elseif unit=="focus" then
            xUnit="f"
        end
    elseif sUnit then
        if sUnit=="p" then
            xUnit="player"
    --    elseif sUnit=="t" then
    --        xUnit="pet"
    --    elseif strsub(sUnit,1,1)=="t" then
    --        xUnit="partypet"..strsub(sUnit,2)
        elseif strsub(sUnit,1,1)=="g" then
            xUnit="party"..strsub(sUnit,2)
    --    elseif strsub(sUnit,1,1)=="z" then
    --        xUnit="raidpet"..strsub(sUnit,2)
        elseif sUnit=="f" then
            xUnit="focus"
        else
            xUnit="raid"..sUnit
        end
    end
    return xUnit
end

function HealBot_Panel_SetupBars()
    for j=1,10 do
        OffsetY[j] = 4 + ceil(HealBot_AddHeight["BOTH"][j]/2)--HealBot_OutlineOffset[j];
        OffsetX[j] = 6 + ceil(HealBot_AddWidth["BOTH"][j]/2)
        MaxOffsetY[j]=0
        MaxOffsetX[j]=0
        frameScale[j] = Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["SCALE"];
        bwidth[j] = ceil(Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["WIDTH"]*frameScale[j]);
        bheight[j] = ceil(Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["HEIGHT"]*frameScale[j]);
        bcspace[j] = ceil((Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["CMARGIN"]+
                           Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][j]["BOUT"])*frameScale[j]);
        brspace[j] = ceil(Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["RMARGIN"]*frameScale[j]);
        cols[j]=Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["NUMCOLS"];
    end
    local h={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0}
    local z={[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1,[10]=1}
    local newHeader={["H"]={},["G"]={},["C"]={}}
    table.foreach(HealBot_Action_HealButtons, function (x,xUnit)
        local xButton=HealBot_Unit_Button[xUnit]
        if xButton then
            local uName=UnitName(xUnit);
            if not uName then
                if HealBot_UnitName[xButton.guid] then
                    uName=HealBot_UnitName[xButton.guid];
                elseif HealBot_cpOn and HealBot_cpName[xUnit] then -- Crash Protection 
                    uName=HealBot_cpName[xUnit];
                elseif strsub(xButton.unit,1,4)==strsub(HEALBOT_WORD_TEST,1,4) then
                    uName=xButton.unit
                end
            end
            if uName then
                local bFrame = xButton.frame
                if Healbot_Config_Skins.HeadBar[Healbot_Config_Skins.Current_Skin][bFrame]["SHOW"]==1 then 
                    if not newHeader["H"][bFrame] then
                        if HealBot_BottomAnchors[bFrame] then 
                            newHeader["H"][bFrame]=1
                        else
                            newHeader["H"][bFrame]=0
                        end
                    end
                    h[bFrame]=h[bFrame]+1
                    if HeaderPos[bFrame][h[bFrame]] then
                        newHeader["H"][bFrame]=newHeader["H"][bFrame]+1;
                        if HealBot_BottomAnchors[bFrame] then 
                            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                                OffsetX[bFrame], _ = HealBot_Action_PositionButton(nil,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],HeaderPos[bFrame][h[bFrame]],bFrame,bcspace[bFrame],brspace[bFrame])
                            else
                                _, OffsetY[bFrame] = HealBot_Action_PositionButton(nil,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],HeaderPos[bFrame][h[bFrame]],bFrame,bcspace[bFrame],brspace[bFrame])
                            end
                        end
                        if newHeader["H"][bFrame]>cols[bFrame] then
                            newHeader["H"][bFrame]=1
                            if MaxOffsetY[bFrame]<OffsetY[bFrame] then MaxOffsetY[bFrame] = OffsetY[bFrame]; end
                            if MaxOffsetX[bFrame]<OffsetX[bFrame] then MaxOffsetX[bFrame] = OffsetX[bFrame]; end
                            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                                OffsetY[bFrame] = OffsetY[bFrame] + bheight[bFrame] + HealBot_AddHeight["BOTH"][bFrame] + HealBot_AddHeight["BOTTOM"][bFrame]
                                OffsetX[bFrame] = 6 + ceil(HealBot_AddWidth["BOTH"][bFrame]/2)
                            else
                                OffsetY[bFrame] = 4 + ceil(HealBot_AddHeight["BOTH"][bFrame]/2)
                                OffsetX[bFrame] = OffsetX[bFrame] + bwidth[bFrame] + HealBot_AddWidth["BOTH"][bFrame] + HealBot_AddWidth["SIDE"][bFrame]
                            end
                        end
                        if not HealBot_BottomAnchors[bFrame] then 
                            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                                OffsetX[bFrame], _ = HealBot_Action_PositionButton(nil,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],HeaderPos[bFrame][h[bFrame]],bFrame,bcspace[bFrame],brspace[bFrame])
                            else
                                _, OffsetY[bFrame] = HealBot_Action_PositionButton(nil,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],HeaderPos[bFrame][h[bFrame]],bFrame,bcspace[bFrame],brspace[bFrame])
                            end
                        end
                        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                            OffsetX[bFrame], _ = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                        else
                            _, OffsetY[bFrame] = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                        end
                    else
                        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                            OffsetX[bFrame], _ = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                        else
                            _, OffsetY[bFrame] = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                        end
                    end
                    if HeaderPos[bFrame][h[bFrame]+1] and HealBot_BottomAnchors[bFrame] then
                        OffsetY[bFrame] = HealBot_Action_PositionButton(nil,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],HeaderPos[bFrame][h[bFrame]+1],bFrame,bcspace[bFrame],brspace[bFrame]);
                    end
                elseif Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][bFrame]["GRPCOLS"]==1 then
                    h[bFrame]=h[bFrame]+1
                    if not newHeader["G"][bFrame] then
                        if HealBot_BottomAnchors[bFrame] then 
                            newHeader["G"][bFrame]=1
                        else
                            newHeader["G"][bFrame]=0
                        end
                    end
                    if HeaderPos[bFrame][h[bFrame]] then
                        newHeader["G"][bFrame]=newHeader["G"][bFrame]+1;
                        if newHeader["G"][bFrame]>cols[bFrame] then
                            if MaxOffsetY[bFrame]<OffsetY[bFrame] then MaxOffsetY[bFrame] = OffsetY[bFrame]; end
                            if MaxOffsetX[bFrame]<OffsetX[bFrame] then MaxOffsetX[bFrame] = OffsetX[bFrame]; end
                            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                                OffsetY[bFrame] = OffsetY[bFrame] + bheight[bFrame] + HealBot_AddHeight["BOTH"][bFrame] + HealBot_AddHeight["BOTTOM"][bFrame]
                                OffsetX[bFrame] = 6 + ceil(HealBot_AddWidth["BOTH"][bFrame]/2)
                            else
                                OffsetY[bFrame] = 4 + ceil(HealBot_AddHeight["BOTH"][bFrame]/2)
                                OffsetX[bFrame] = OffsetX[bFrame] + bwidth[bFrame] + HealBot_AddWidth["BOTH"][bFrame] + HealBot_AddWidth["SIDE"][bFrame]
                            end
                            newHeader["G"][bFrame]=1;
                        end
                    end
                    if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                        OffsetX[bFrame], _ = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                    else
                        _, OffsetY[bFrame] = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                    end
                else
                    if not newHeader["C"][bFrame] then newHeader["C"][bFrame]=1 end
                    if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                        OffsetX[bFrame], _ = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                    else
                        _, OffsetY[bFrame] = HealBot_Action_PositionButton(xButton,OffsetX[bFrame],OffsetY[bFrame],bwidth[bFrame],bheight[bFrame],nil,bFrame,bcspace[bFrame],brspace[bFrame])
                    end
                    if newHeader["C"][bFrame]==ceil((hbBarsPerFrame[bFrame])/cols[bFrame]) and z[bFrame]<hbBarsPerFrame[bFrame] then
                        newHeader["C"][bFrame]=0;
                        if MaxOffsetY[bFrame]<OffsetY[bFrame] then MaxOffsetY[bFrame] = OffsetY[bFrame]; end
                        if MaxOffsetX[bFrame]<OffsetX[bFrame] then MaxOffsetX[bFrame] = OffsetX[bFrame]; end
                        if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["GROW"]==1 then
                            OffsetY[bFrame] = OffsetY[bFrame] + bheight[bFrame] + HealBot_AddHeight["BOTH"][bFrame] + HealBot_AddHeight["BOTTOM"][bFrame]
                            OffsetX[bFrame] = 6 + ceil(HealBot_AddWidth["BOTH"][bFrame]/2)
                        else
                            OffsetY[bFrame] = 4 + ceil(HealBot_AddHeight["BOTH"][bFrame]/2)
                            OffsetX[bFrame] = OffsetX[bFrame] + bwidth[bFrame] + HealBot_AddWidth["BOTH"][bFrame] + HealBot_AddWidth["SIDE"][bFrame]
                        end
                    end
            
                    z[bFrame]=z[bFrame]+1
                    newHeader["C"][bFrame]=newHeader["C"][bFrame]+1;
                end
            end
        end
    end)

    for xHeader,xButton in pairs(HealBot_Header_Frames) do
        if not HealBot_Track_Headers[xHeader] then
            HealBot_Panel_DeleteHeader(xButton.id, xHeader)
        end
    end

    local bFrame=0
    for j=1,10 do
        if hbBarsPerFrame[j]>0 then
            if bFrame==0 then bFrame=j end
            if MaxOffsetY[j]<OffsetY[j] then MaxOffsetY[j] = OffsetY[j]; end
            if MaxOffsetX[j]<OffsetX[j] then MaxOffsetX[j] = OffsetX[j]; end
            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][j]["GROW"]==1 then
                MaxOffsetY[j]=MaxOffsetY[j]-ceil(HealBot_AddHeight["BOTH"][j]/2)+HealBot_AddHeight["BAR2"][j]+4
                MaxOffsetX[j]=MaxOffsetX[j]-ceil((HealBot_AddWidth["BOTH"][j]/2)+HealBot_AddWidth["SIDE"][j])+6
            else
                MaxOffsetY[j]=MaxOffsetY[j]+5-(Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][j]["RMARGIN"]+ceil(HealBot_AddHeight["BOTH"][j]/2))
                MaxOffsetX[j]=MaxOffsetX[j]+6
            end
         --   HealBot_AddDebug("Frame "..j.." has "..hbBarsPerFrame[j].." bars")
        end
    end
    if HealBot_Globals.HideOptions==1 and bFrame>0 then
        if hbOptionOn then
            hbOptionOn:Hide()
            hbOptionOn=nil
        end
    else
        if bFrame==0 then bFrame=1 end
        local on="HealBot_Action_OptionsButton"
        local op=_G["f"..bFrame.."_HealBot_Action"]
        local onb=_G[on]
        if not onb then 
            onb=CreateFrame("Button", on, op, "HealBotOptionsButtonTemplate") 
            local bar = HealBot_Action_HealthBar(onb);
            bar:SetStatusBarColor(0.1,0.1,0.4,0);
            bar:SetMinMaxValues(0,100);
            bar:SetValue(0);
            onb.frame=bFrame
            bar.txt = _G[bar:GetName().."_text"];
            bar.txt:SetTextColor(0.8,0.8,0.2,0.85);
            bar.txt:SetText(HEALBOT_ACTION_OPTIONS);
        elseif onb.frame~=bFrame then
            onb:Hide()
            onb:ClearAllPoints()
            onb:SetParent(op)
            onb.frame=bFrame
        end
        if hbOptionOn and hbOptionOn~=onb then hbOptionOn:Hide() end
        hbOptionOn=onb
        if hbOptionOn then
            hbOptionOn:ClearAllPoints()
            if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["BARS"]==2 or Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][bFrame]["BARS"]==4 then
                hbOptionOn:SetPoint("TOP",op,"TOP",0,-10);
            else
                hbOptionOn:SetPoint("BOTTOM",op,"BOTTOM",0,10);
            end
            hbOptionOn:Show();
            MaxOffsetY[bFrame] = MaxOffsetY[bFrame]+30;
        end
    end
    
    if hbPanelShowhbFocus then
        local fn="HealBot_Action_hbFocusButton"
        local fp=_G["f"..hbPanelShowhbFocus.."_HealBot_Action"]
        local fhb=_G[fn]
        if not fhb then
            fhb=CreateFrame("Button", fn, fp, "HealBotFocusButtonTemplate") 
            local bar = HealBot_Action_HealthBar(fhb)
            bar:SetMinMaxValues(0,100);
            bar:SetValue(100);
            HealBot_Action_SethbFocusButtonAttrib(fhb)
            fhb.id=999
            fhb.frame=hbPanelShowhbFocus
            HealBot_Action_OnLoad(fhb) 
            fhb:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        elseif fhb.frame~=hbPanelShowhbFocus then 
            fhb:Hide()
            fhb:ClearAllPoints()
            fhb:SetParent(fp)
            fhb.frame=hbPanelShowhbFocus
        end
        if hbFocusOn and hbFocusOn~=fhb then hbFocusOn:Hide() end
        hbFocusOn=fhb
    end
    if hbPanelShowhbFocus and HealBot_Data["UILOCK"]=="NO" and UnitName("target") and HealBot_Globals.FocusMonitor[UnitName("target")] then
        if UnitName("focus") and HealBot_Globals.FocusMonitor[UnitName("focus")] then
            hbFocusOn:Hide()
        else
            local fp=_G["f"..hbPanelShowhbFocus.."_HealBot_Action"]
            HealBot_Action_ResetSkin("hbfocus",hbFocusOn,Healbot_Config_Skins.HealBar[Healbot_Config_Skins.Current_Skin][hbFocusOn.frame]["NUMCOLS"])
            hbFocusOn:ClearAllPoints()
            if HealBot_Globals.HideOptions==0 then
                if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbPanelShowhbFocus]["BARS"]==2 or Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbPanelShowhbFocus]["BARS"]==4 then
                    hbFocusOn:SetPoint("TOP",fp,"TOP",0,-40);
                else
                    hbFocusOn:SetPoint("BOTTOM",fp,"BOTTOM",0,40);
                end
            else
                if Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbPanelShowhbFocus]["BARS"]==2 or Healbot_Config_Skins.Anchors[Healbot_Config_Skins.Current_Skin][hbPanelShowhbFocus]["BARS"]==4 then
                    hbFocusOn:SetPoint("TOP",fp,"TOP",0,-10);
                else
                    hbFocusOn:SetPoint("BOTTOM",fp,"BOTTOM",0,10);
                end
            end
            MaxOffsetY[hbPanelShowhbFocus] = MaxOffsetY[hbPanelShowhbFocus]+bheight[hbPanelShowhbFocus]+15;
            hbFocusOn:Show();
        end
    elseif hbFocusOn then
        hbFocusOn:Hide();
        hbFocusOn=nil
    end
    for j=1,10 do
        if hbBarsPerFrame[j]>0 then
            if HealBot_Config.DisabledNow==0 then
                HealBot_Action_SetHeightWidth(MaxOffsetX[j], MaxOffsetY[j], bwidth[j], bheight[j], j);
                if HealBot_setTestBars or (Healbot_Config_Skins.Frame[Healbot_Config_Skins.Current_Skin][j]["AUTOCLOSE"]==0 or HealBot_Data["UILOCK"]=="YES" or HealBot_Action_ShouldHealSome(nil, j)) then
                    HealBot_Action_ShowPanel(j)
                end
            else
                HealBot_Action_HidePanel(j)
            end
          --  HealBot_AddDebug("Frame "..j.." has "..hbBarsPerFrame[j].." bars")
        else
            HealBot_Action_HidePanel(j)
        end
    end
    
end

function HealBot_Action_RemoveMember(hbGUID, unit)
    local uName=HealBot_UnitName[hbGUID] or UnitName(unit) or "NONE"
    if HealBot_unitRole[hbGUID] then HealBot_unitRole[hbGUID]=nil end
    if HealBot_UnitNameGUID[uName] then HealBot_UnitNameGUID[uName]=nil end
    HealBot_immediateClearLocalArr(hbGUID)
    if HealBot_UnitName[hbGUID] then HealBot_UnitName[hbGUID]=nil end
end

function HealBot_RetUnitNameGUIDs(unitName)
    return HealBot_UnitNameGUID[unitName]
end

function HealBot_RetHealBot_RaidUnitID(unit)
    return HealBot_RaidUnitID[unit]
end

--function HealBot_RetUnitGroups(unit)
--    local z=HealBot_UnitGroups[unit] or 1
--    local y=unit
--    for xUnit,group in pairs(HealBot_UnitGroups) do
--        if group==z and xUnit~=unit then
--            y=y..":"..xUnit
--        end
--    end
--    return y
--end

function HealBot_Panel_setRefresh()
    HealBot_PanelVars["setRefresh"]=true
end
