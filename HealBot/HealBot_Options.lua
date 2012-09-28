local HealBot_Options_ComboButtons_Button=1;
local HealBot_Options_Opened=false;
local HealBot_Options_SoftReset_flag=false;
local HealBot_buffbarcolr = {};
local HealBot_buffbarcolg = {};
local HealBot_buffbarcolb = {};
local HealBot_Skins = {};
local HealBot_DebuffWatchTarget={}
local HealBot_BuffWatchTarget={}
local BuffTextClass=nil
local strtrim=strtrim
local strsub=strsub
local tonumber=tonumber
local floor=floor
local DoneInitTab={}
local bar=nil
local sName=nil
local dName=nil
local text=nil
local r,g,b,x,y,z,k,j,i=nil,nil,nil,nil,nil,nil,nil,nil,nil
local textures=nil
local texturesIndex={}
local fonts=nil
local fontsIndex={}
local sounds=nil
local soundsIndex={}
local updatingMedia=false
local LSM = LibStub("LibSharedMedia-3.0")
local uGUID=nil
local xGUID=nil
local ClickedBuffGroupDD=nil
local tGUID=nil
local tName=nil
local hbCurSkin=""
local hbCurSkinSubFrameID=1001
local HealBot_Options_StorePrev={}
local _

local HealBot_Options_BuffTxt_List = {
    HEALBOT_WORDS_NONE,
    HEALBOT_OPTIONS_BUFFSELF,
    HEALBOT_OPTIONS_BUFFPARTY,
    HEALBOT_OPTIONS_BUFFRAID,
    HEALBOT_DRUID,
    HEALBOT_HUNTER,
    HEALBOT_MAGE,
    HEALBOT_MONK,
    HEALBOT_PALADIN,
    HEALBOT_PRIEST,
    HEALBOT_ROGUE,
    HEALBOT_SHAMAN,
    HEALBOT_WARLOCK,
    HEALBOT_WARRIOR,
    HEALBOT_DEATHKNIGHT,
    HEALBOT_CLASSES_MELEE,
    HEALBOT_CLASSES_RANGES,
    HEALBOT_CLASSES_HEALERS,
    HEALBOT_CLASSES_CUSTOM,
    HEALBOT_BUFF_PVP,
	HEALBOT_BUFF_PVE,
    HEALBOT_OPTIONS_TANKHEALS,
    HEALBOT_OPTIONS_MYTARGET,
    HEALBOT_FOCUS,
	HEALBOT_SORTBY_NAME,
}

local HealBot_Buff_Spells_Class_List={}
local HealBot_Buff_Spells_List ={}

function HealBot_Options_InitBuffSpellsClassList(tClass)
    if tClass=="DRUI" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_MARK_OF_THE_WILD,
            HEALBOT_BARKSKIN,
            HEALBOT_NATURES_GRASP,
            HEALBOT_IRONBARK,
        }
    elseif tClass=="HUNT" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_A_FOX,
            HEALBOT_A_HAWK,
            HEALBOT_A_CHEETAH,
            HEALBOT_A_PACK,
            HEALBOT_A_WILD,
        }
    elseif tClass=="MAGE" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_ARCANE_BRILLIANCE,
            HEALBOT_DALARAN_BRILLIANCE,
            HEALBOT_FROST_ARMOR,
            HEALBOT_MAGE_WARD,
            HEALBOT_MAGE_ARMOR,
            HEALBOT_MOLTEN_ARMOR,
            HEALBOT_FOCUS_MAGIC,
        }
    elseif tClass=="MONK" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_LEGACY_EMPEROR,
            HEALBOT_LEGACY_WHITETIGER,
            HEALBOT_RUSHING_JADE_WIND,
        }
    elseif tClass=="PALA" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_BLESSING_OF_MIGHT,
            HEALBOT_BLESSING_OF_KINGS,
            HEALBOT_HAND_OF_FREEDOM,
            HEALBOT_HAND_OF_PROTECTION,
            HEALBOT_HAND_OF_SACRIFICE,
            HEALBOT_HAND_OF_SALVATION,
            HEALBOT_RIGHTEOUS_FURY,
            HEALBOT_DEVOTION_AURA,
            HEALBOT_BEACON_OF_LIGHT,
            HEALBOT_SEAL_OF_RIGHTEOUSNESS,
            HEALBOT_SEAL_OF_JUSTICE,
            HEALBOT_SEAL_OF_INSIGHT,
            HEALBOT_SEAL_OF_TRUTH,
            HEALBOT_DIVINE_PLEA,
            HEALBOT_DIVINE_FAVOR,
        }
    elseif tClass=="PRIE" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_POWER_WORD_FORTITUDE,
            HEALBOT_INNER_FIRE,
            HEALBOT_INNER_WILL,
            HEALBOT_FEAR_WARD,
            HEALBOT_PAIN_SUPPRESSION,
            HEALBOT_POWER_INFUSION,
            HEALBOT_LEVITATE,
            HEALBOT_SHADOW_PROTECTION,
            HEALBOT_SHADOWFORM,
            HEALBOT_VAMPIRIC_EMBRACE,
            HEALBOT_CHAKRA_SANCTUARY,
            HEALBOT_CHAKRA_SERENITY,
            HEALBOT_CHAKRA_CHASTISE,
        }
    elseif tClass=="ROGU" then
        HealBot_Buff_Spells_Class_List = {
        }
    elseif tClass=="SHAM" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_LIGHTNING_SHIELD,
            HEALBOT_ROCKBITER_WEAPON,
            HEALBOT_FLAMETONGUE_WEAPON,
            HEALBOT_EARTHLIVING_WEAPON,
            HEALBOT_WINDFURY_WEAPON,
            HEALBOT_FROSTBRAND_WEAPON,
            HEALBOT_EARTH_SHIELD,
            HEALBOT_WATER_SHIELD,
            HEALBOT_WATER_BREATHING,
            HEALBOT_WATER_WALKING, 
        }
    elseif tClass=="WARL" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_DEMON_ARMOR,
            HEALBOT_FEL_ARMOR,
            HEALBOT_UNENDING_BREATH,
            HEALBOT_DARK_INTENT,
            HEALBOT_SOUL_LINK,
        }
    elseif tClass=="WARR" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_BATTLE_SHOUT,
            HEALBOT_COMMANDING_SHOUT,
            HEALBOT_VIGILANCE,
        }
    elseif tClass=="DEAT" then
        HealBot_Buff_Spells_Class_List = {
            HEALBOT_HORN_OF_WINTER,
            HEALBOT_BONE_SHIELD,
        }
    end
end




function HealBot_Options_InitBuffClassList()
    HealBot_Options_InitBuffSpellsClassList(HealBot_PlayerClassTrim)
    table.sort (HealBot_Buff_Spells_Class_List)
end

function HealBot_Options_InitBuffList()
    HealBot_Buff_Spells_List ={}
    for j=1, getn(HealBot_Buff_Spells_Class_List), 1 do
        local id=HealBot_GetSpellId(HealBot_Buff_Spells_Class_List[j]);
        if id then
            table.insert(HealBot_Buff_Spells_List,HealBot_Buff_Spells_Class_List[j])
            if not HealBot_Spells[HealBot_Buff_Spells_Class_List[j]] then
                if not HealBot_OtherSpells[HealBot_Buff_Spells_Class_List[j]] then
                    local id = HealBot_GetSpellId(HealBot_Buff_Spells_Class_List[j]);
                    if id then
                        HealBot_FindSpellRangeCast(id);
                    end
                end
            end
        end
    end
end

function HealBot_Options_GetDebuffSpells_List(class)
    local HealBot_Debuff_Spells = {
      ["PALA"] = {HEALBOT_CLEANSE,},
      ["DRUI"] = {HEALBOT_REMOVE_CORRUPTION, HEALBOT_NATURES_CURE,},
      ["PRIE"] = {HEALBOT_PURIFY,},
      ["SHAM"] = {HEALBOT_PURIFY_SPIRIT, HEALBOT_CLEANSE_SPIRIT},
      ["HUNT"] = {},
      ["MAGE"] = {HEALBOT_REMOVE_CURSE,},
      ["ROGU"] = {},
      ["MONK"] = {HEALBOT_DETOX,},
      ["WARL"] = {},
      ["WARR"] = {},
      ["DEAT"] = {},
    }
    return HealBot_Debuff_Spells[class]
end


function HealBot_Options_GetRacialDebuffSpells_List(race)
    local HealBot_Racial_Debuff_Spells = {
      ["Hum"] = {},
      ["Dwa"] = {HEALBOT_STONEFORM,},
      ["Nig"] = {},
      ["Gno"] = {},
      ["Dra"] = {},
      ["Pan"] = {},
      ["Orc"] = {},
      ["Sco"] = {}, -- Undead
      ["Tau"] = {},
      ["Tro"] = {}, 
      ["Blo"] = {},
      ["Gob"] = {},
      ["Wor"] = {},
    }
    return HealBot_Racial_Debuff_Spells[race]
end

local HealBot_Debuff_Types = {
  [HEALBOT_CLEANSE] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en, HEALBOT_MAGIC_en},
  [HEALBOT_REMOVE_CURSE] = {HEALBOT_CURSE_en},
  [HEALBOT_REMOVE_CORRUPTION] = {HEALBOT_CURSE_en, HEALBOT_POISON_en},
  [HEALBOT_NATURES_CURE] = {HEALBOT_MAGIC_en, HEALBOT_CURSE_en, HEALBOT_POISON_en},
  [HEALBOT_PURIFY] = {HEALBOT_MAGIC_en, HEALBOT_DISEASE_en},
  [HEALBOT_PURIFICATION_POTION] = {HEALBOT_CURSE_en, HEALBOT_DISEASE_en, HEALBOT_POISON_en},
  [HEALBOT_ANTI_VENOM] = {HEALBOT_POISON_en},
  [HEALBOT_POWERFUL_ANTI_VENOM] = {HEALBOT_POISON_en},
  [HEALBOT_ELIXIR_OF_POISON_RES] = {HEALBOT_POISON_en},
  [HEALBOT_STONEFORM] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en},
  [HEALBOT_PURIFY_SPIRIT] = {HEALBOT_MAGIC_en, HEALBOT_CURSE_en},
  [HEALBOT_CLEANSE_SPIRIT] = {HEALBOT_CURSE_en},
  [HEALBOT_DETOX] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en},
}



function HealBot_Options_setDebuffTypes()
   -- if HealBot_PlayerClassTrim=="SHAM" then
        --
   -- end
end

local CPUProfiler=0
StaticPopupDialogs["HEALBOT_OPTIONS_RELOADUI"] = {
    text = HEALBOT_OPTIONS_RELOADUIMSG,
    button1 = HEALBOT_WORDS_YES,
    button2 = HEALBOT_WORDS_NO,
    OnAccept = function()
        ReloadUI();
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
};

local hbOptGetSkinFrom=" "
local hbOptGetSkinName=" "
StaticPopupDialogs["HEALBOT_OPTIONS_ACCEPTSKIN"] = {
    text = HEALBOT_OPTIONS_ACCEPTSKINMSG.."%s",
    button1 = HEALBOT_WORDS_YES,
    button2 = HEALBOT_WORDS_NO,
    OnAccept = function()
        HealBot_Options_ShareSkinAccept();
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
};

function HealBot_Options_retDebuffWatchTarget(debuffType, hbGUID)
    if HealBot_DebuffSpell[debuffType] and HealBot_Config.HealBot_BuffWatchGUID[HealBot_DebuffSpell[debuffType]] then
        return HealBot_DebuffWatchTarget[debuffType], HealBot_Config.HealBot_BuffWatchGUID[HealBot_DebuffSpell[debuffType]][hbGUID]
    else
        return HealBot_DebuffWatchTarget[debuffType], nil
    end
end

function HealBot_Options_retBuffWatchTarget(buffName, hbGUID)
    if HealBot_Config.HealBot_BuffWatchGUID[buffName] then
        return HealBot_BuffWatchTarget[buffName], HealBot_Config.HealBot_BuffWatchGUID[buffName][hbGUID]
    else
        return HealBot_BuffWatchTarget[buffName], nil
    end
end

function HealBot_Options_retDebuffPriority(debuffName, debuffType)
    return HealBot_Globals.HealBot_Custom_Debuffs[debuffName] or 99, HealBot_Config.HealBotDebuffPriority[debuffType] or 98
end

function HealBot_Options_Pct_OnLoad(self,vText)
    self.text = vText;
    g=_G[self:GetName().."Text"]
    g:SetText(vText);
    g=_G[self:GetName().."Low"]
    g:SetText("0%");
    g=_G[self:GetName().."High"]
    g:SetText("100%");
    self:SetMinMaxValues(0.00,1.00);
    self:SetValueStep(0.01);
end

function HealBot_Options_Pct_OnLoad_MinMax(self,vText,Min,Max,Step)
    self.text = vText;

    i=(Min*100).."%";
    j=(Max*100).."%";

    g=_G[self:GetName().."Text"]
    g:SetText(vText);
    g=_G[self:GetName().."Low"]
    g:SetText(i);
    g=_G[self:GetName().."High"]
    g:SetText(j);
    self:SetMinMaxValues(Min,Max);
    self:SetValueStep(Step);
end

function HealBot_Options_val_OnLoad(self,vText,Min,Max,Step)
    self.text = vText;
    g=_G[self:GetName().."Text"]
    g:SetText(vText);
    g=_G[self:GetName().."Low"]
    g:SetText(Min);
    g=_G[self:GetName().."High"]
    g:SetText(Max);
    self:SetMinMaxValues(Min,Max);
    self:SetValueStep(Step);
end

function HealBot_Options_valNoCols_OnLoad(self,Min,Max)
    g=_G[self:GetName().."Text"]
    g:SetText(HealBot_Options_SetNoColsText);
    g=_G[self:GetName().."Low"]
    g:SetText(Min);
    g=_G[self:GetName().."High"]
    g:SetText(Max);
    self:SetMinMaxValues(Min,Max);
    self:SetValueStep(1);
end

function HealBot_Options_val2_OnLoad(self,vText,Min,Max,Step,vDiv)
    self.text = vText;

    g=_G[self:GetName().."Text"]
    g:SetText(vText);
    g=_G[self:GetName().."Low"]
    g:SetText(Min/vDiv);
    g=_G[self:GetName().."High"]
    g:SetText(Max/vDiv);
    self:SetMinMaxValues(Min,Max);
    self:SetValueStep(Step);
end

function HealBot_Options_valtime_OnLoad(self,vText,Min,Max,Step,secsOnly)
    self.text = vText;

    g=_G[self:GetName().."Text"]
    g:SetText(vText);
    if secsOnly then
        g=_G[self:GetName().."Low"]
        g:SetText(Min);
        g=_G[self:GetName().."High"]
        g:SetText(Max);
    else
        g=_G[self:GetName().."Low"]
        g:SetText(Min/60);
        g=_G[self:GetName().."High"]
        g:SetText(Max/60);
    end
    self:SetMinMaxValues(Min,Max);
    self:SetValueStep(Step);
end

function HealBot_Options_SetText(self,vText)
    g=_G[self:GetName().."Text"]
    g:SetText(vText);
end

function HealBot_Options_UIDropDownMenu_OnLoad(self, width)
    UIDropDownMenu_SetWidth(self,width)
end

function HealBot_Options_NotifyOtherMsg_OnTextChanged(self)
    Healbot_Config_Skins.NotifyOtherMsg[Healbot_Config_Skins.Current_Skin] = self:GetText()
end

function HealBot_Options_SetNoColsText()
    if Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin]==1 then
        HealBot_Options_BarNumGroupPerCol:Hide()
        return HEALBOT_OPTIONS_SKINNUMHCOLS;
    else
        HealBot_Options_BarNumGroupPerCol:Show()
        if Healbot_Config_Skins.GroupsPerCol[Healbot_Config_Skins.Current_Skin]==1 then
            return HEALBOT_OPTIONS_SKINNUMHCOLS;
        else
            return HEALBOT_OPTIONS_SKINNUMCOLS;
        end
    end
end

local pct=nil
function HealBot_Options_Pct_OnValueChanged(self)
    pct = floor(self:GetValue()*100+0.5);
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. " (" .. pct .. "%)");
    return self:GetValue();
end


function HealBot_Options_NewSkin_OnTextChanged(self)
    text= self:GetText()
    if strlen(text)>0 then
        HealBot_Options_NewSkinb:Enable();
    else
        HealBot_Options_NewSkinb:Disable();
    end
end

function HealBot_Options_NewSkinb_OnClick(self)
    HealBot_Options_setNewSkin(HealBot_Options_NewSkin:GetText())
end

function HealBot_Options_setNewSkin(newSkinName)
    Healbot_Config_Skins.numcols[newSkinName] = Healbot_Config_Skins.numcols[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btexture[newSkinName] = Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bcspace[newSkinName] = Healbot_Config_Skins.bcspace[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.brspace[newSkinName] = Healbot_Config_Skins.brspace[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bwidth[newSkinName] = Healbot_Config_Skins.bwidth[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bheight[newSkinName] = Healbot_Config_Skins.bheight[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextenabledcolr[newSkinName] = Healbot_Config_Skins.btextenabledcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextenabledcolg[newSkinName] = Healbot_Config_Skins.btextenabledcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextenabledcolb[newSkinName] = Healbot_Config_Skins.btextenabledcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextenabledcola[newSkinName] = Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextdisbledcolr[newSkinName] = Healbot_Config_Skins.btextdisbledcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextdisbledcolg[newSkinName] = Healbot_Config_Skins.btextdisbledcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextdisbledcolb[newSkinName] = Healbot_Config_Skins.btextdisbledcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextdisbledcola[newSkinName] = Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextcursecolr[newSkinName] = Healbot_Config_Skins.btextcursecolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextcursecolg[newSkinName] = Healbot_Config_Skins.btextcursecolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextcursecolb[newSkinName] = Healbot_Config_Skins.btextcursecolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextcursecola[newSkinName] = Healbot_Config_Skins.btextcursecola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.backcola[newSkinName] = Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.Barcola[newSkinName] = Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarcolaInHeal[newSkinName] = Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.backcolr[newSkinName] = Healbot_Config_Skins.backcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.backcolg[newSkinName] = Healbot_Config_Skins.backcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.backcolb[newSkinName] = Healbot_Config_Skins.backcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.borcolr[newSkinName] = Healbot_Config_Skins.borcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.borcolg[newSkinName] = Healbot_Config_Skins.borcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.borcolb[newSkinName] = Healbot_Config_Skins.borcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.borcola[newSkinName] = Healbot_Config_Skins.borcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextheight[newSkinName] = Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bardisa[newSkinName] = Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bareora[newSkinName] = Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.bar2size[newSkinName] = Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowHeader[newSkinName] = Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headbarcolr[newSkinName] = Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headbarcolg[newSkinName] = Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headbarcolb[newSkinName] = Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headbarcola[newSkinName] = Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtxtcolr[newSkinName] = Healbot_Config_Skins.headtxtcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtxtcolg[newSkinName] = Healbot_Config_Skins.headtxtcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtxtcolb[newSkinName] = Healbot_Config_Skins.headtxtcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtxtcola[newSkinName] = Healbot_Config_Skins.headtxtcola[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtexture[newSkinName] = Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headwidth[newSkinName] = Healbot_Config_Skins.headwidth[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headhight[newSkinName] = Healbot_Config_Skins.headhight[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggro[newSkinName] = Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggroBars[newSkinName] = Healbot_Config_Skins.ShowAggroBars[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggroText[newSkinName] = Healbot_Config_Skins.ShowAggroText[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggroBarsPct[newSkinName] = Healbot_Config_Skins.ShowAggroBarsPct[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggroTextPct[newSkinName] = Healbot_Config_Skins.ShowAggroTextPct[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowAggroInd[newSkinName] = Healbot_Config_Skins.ShowAggroInd[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.LowManaInd[newSkinName] = Healbot_Config_Skins.LowManaInd[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.LowManaIndIC[newSkinName] = Healbot_Config_Skins.LowManaIndIC[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroIndAlertLevel[newSkinName] = Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HighLightActiveBar[newSkinName] = Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HighLightActiveBarInCombat[newSkinName] = Healbot_Config_Skins.HighLightActiveBarInCombat[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HighLightTargetBar[newSkinName] = Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HighLightTargetBarInCombat[newSkinName] = Healbot_Config_Skins.HighLightTargetBarInCombat[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.UseFluidBars[newSkinName] = Healbot_Config_Skins.UseFluidBars[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarFreq[newSkinName] = Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowHoTicons[newSkinName] = Healbot_Config_Skins.ShowHoTicons[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIcon[newSkinName] = Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconStar[newSkinName] = Healbot_Config_Skins.ShowRaidIconStar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconCircle[newSkinName] = Healbot_Config_Skins.ShowRaidIconCircle[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconDiamond[newSkinName] = Healbot_Config_Skins.ShowRaidIconDiamond[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconTriangle[newSkinName] = Healbot_Config_Skins.ShowRaidIconTriangle[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconMoon[newSkinName] = Healbot_Config_Skins.ShowRaidIconMoon[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconSquare[newSkinName] = Healbot_Config_Skins.ShowRaidIconSquare[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconCross[newSkinName] = Healbot_Config_Skins.ShowRaidIconCross[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRaidIconSkull[newSkinName] = Healbot_Config_Skins.ShowRaidIconSkull[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortPlayerFirst[newSkinName]=Healbot_Config_Skins.SubSortPlayerFirst[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ReadyCheck[newSkinName] = Healbot_Config_Skins.ReadyCheck[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HoTonBar[newSkinName] = Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HoTposBar[newSkinName] = Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HoTx2Bar[newSkinName] = Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowClassOnBar[newSkinName] = Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowClassType[newSkinName] = Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowRole[newSkinName] = Healbot_Config_Skins.ShowRole[Healbot_Config_Skins.Current_Skin] 
    Healbot_Config_Skins.ShowNameOnBar[newSkinName] = Healbot_Config_Skins.ShowNameOnBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowHealthOnBar[newSkinName] = Healbot_Config_Skins.ShowHealthOnBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarHealthIncHeals[newSkinName] = Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarHealthNumFormat1[newSkinName] = Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarHealthNumFormat2[newSkinName] = Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarHealthNumFormatAggro[newSkinName] = Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.BarHealthType[newSkinName] = Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SetClassColourText[newSkinName] = Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IncHealBarColour[newSkinName] = Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HlthBarColour[newSkinName] = Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowDebuffIcon[newSkinName] = Healbot_Config_Skins.ShowDebuffIcon[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowIconTextCount[newSkinName] = Healbot_Config_Skins.ShowIconTextCount[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowIconTextCountSelfCast[newSkinName] = Healbot_Config_Skins.ShowIconTextCountSelfCast[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowIconTextDuration[newSkinName] = Healbot_Config_Skins.ShowIconTextDuration[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowIconTextDurationSelfCast[newSkinName] = Healbot_Config_Skins.ShowIconTextDurationSelfCast[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IconScale[newSkinName] = Healbot_Config_Skins.IconScale[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IconTextScale[newSkinName] = Healbot_Config_Skins.IconTextScale[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextfont[newSkinName] = Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtextfont[newSkinName] = Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtextheight[newSkinName] = Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.btextoutline[newSkinName] = Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.headtextoutline[newSkinName] = Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroBarSize[newSkinName] = Healbot_Config_Skins.AggroBarSize[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.PanelAnchorY[newSkinName] = Healbot_Config_Skins.PanelAnchorY[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.highcolr[newSkinName] = Healbot_Config_Skins.highcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.highcolg[newSkinName] = Healbot_Config_Skins.highcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.highcolb[newSkinName] = Healbot_Config_Skins.highcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.targetcolr[newSkinName] = Healbot_Config_Skins.targetcolr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.targetcolg[newSkinName] = Healbot_Config_Skins.targetcolg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.targetcolb[newSkinName] = Healbot_Config_Skins.targetcolb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroColr[newSkinName] = Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroColg[newSkinName] = Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroColb[newSkinName] = Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroBarsMaxAlpha[newSkinName] = Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroBarsMinAlpha[newSkinName] = Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AggroBarsFreq[newSkinName] = Healbot_Config_Skins.AggroBarsFreq[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IconTextDurationShow[newSkinName] = Healbot_Config_Skins.IconTextDurationShow[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IconTextDurationWarn[newSkinName] = Healbot_Config_Skins.IconTextDurationWarn[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.PanelAnchorX[newSkinName] = Healbot_Config_Skins.PanelAnchorX[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TextAlignment[newSkinName] = Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.DoubleText[newSkinName] = Healbot_Config_Skins.DoubleText[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.GroupsPerCol[newSkinName] = Healbot_Config_Skins.GroupsPerCol[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SelfHeals[newSkinName] = Healbot_Config_Skins.SelfHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.PetHeals[newSkinName] = Healbot_Config_Skins.PetHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.GroupHeals[newSkinName] = Healbot_Config_Skins.GroupHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TankHeals[newSkinName] = Healbot_Config_Skins.TankHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SelfPet[newSkinName] = Healbot_Config_Skins.SelfPet[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.MainAssistHeals[newSkinName] = Healbot_Config_Skins.MainAssistHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.EmergencyHeals[newSkinName] = Healbot_Config_Skins.EmergencyHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SetFocusBar[newSkinName] = Healbot_Config_Skins.SetFocusBar[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.VehicleHeals[newSkinName] = Healbot_Config_Skins.VehicleHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ShowMyTargetsList[newSkinName] = Healbot_Config_Skins.ShowMyTargetsList[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetHeals[newSkinName] = Healbot_Config_Skins.TargetHeals[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetIncSelf[newSkinName] = Healbot_Config_Skins.TargetIncSelf[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetIncGroup[newSkinName] = Healbot_Config_Skins.TargetIncGroup[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetIncRaid[newSkinName] = Healbot_Config_Skins.TargetIncRaid[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetIncPet[newSkinName] = Healbot_Config_Skins.TargetIncPet[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TargetBarAlwaysShow[newSkinName] = Healbot_Config_Skins.TargetBarAlwaysShow[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.FocusBarAlwaysShow[newSkinName] = Healbot_Config_Skins.FocusBarAlwaysShow[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.GroupPetsBy5[newSkinName] = Healbot_Config_Skins.GroupPetsBy5[Healbot_Config_Skins.Current_Skin] 
    Healbot_Config_Skins.AlertLevel[newSkinName] = Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.EmergIncMonitor[newSkinName] = Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ExtraOrder[newSkinName] = Healbot_Config_Skins.ExtraOrder[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ExtraSubOrder[newSkinName] = Healbot_Config_Skins.ExtraSubOrder[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HidePartyFrames[newSkinName] = Healbot_Config_Skins.HidePartyFrames[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HidePlayerTarget[newSkinName] = Healbot_Config_Skins.HidePlayerTarget[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.CastNotify[newSkinName] = Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.NotifyChan[newSkinName] = Healbot_Config_Skins.NotifyChan[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.NotifyOtherMsg[newSkinName] = Healbot_Config_Skins.NotifyOtherMsg[Healbot_Config_Skins.Current_Skin]   
    Healbot_Config_Skins.CastNotifyResOnly[newSkinName] = Healbot_Config_Skins.CastNotifyResOnly[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.Panel_Anchor[newSkinName] = Healbot_Config_Skins.Panel_Anchor[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.Bars_Anchor[newSkinName] = Healbot_Config_Skins.Bars_Anchor[Healbot_Config_Skins.Current_Skin]
    if not HealBot_Config.SkinDefault[newSkinName] then HealBot_Config.SkinDefault[newSkinName] = 1 end
    Healbot_Config_Skins.AggroAlertLevel[newSkinName] = Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.IncHealBarColour[newSkinName] = Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.ExtraIncGroup[newSkinName] = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true}
    Healbot_Config_Skins.ActionLocked[newSkinName] = Healbot_Config_Skins.ActionLocked[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.AutoClose[newSkinName] = Healbot_Config_Skins.AutoClose[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.PanelSounds[newSkinName] = Healbot_Config_Skins.PanelSounds[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortIncGroup[newSkinName] = Healbot_Config_Skins.SubSortIncGroup[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortIncPet[newSkinName] = Healbot_Config_Skins.SubSortIncPet[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortIncVehicle[newSkinName] = Healbot_Config_Skins.SubSortIncVehicle[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortIncTanks[newSkinName] = Healbot_Config_Skins.SubSortIncTanks[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.SubSortIncMyTargets[newSkinName] = Healbot_Config_Skins.SubSortIncMyTargets[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.CrashProt[newSkinName] = Healbot_Config_Skins.CrashProt[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.CombatProt[newSkinName] = Healbot_Config_Skins.CombatProt[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.CombatProtParty[newSkinName] = Healbot_Config_Skins.CombatProtParty[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.CombatProtRaid[newSkinName] = Healbot_Config_Skins.CombatProtRaid[Healbot_Config_Skins.Current_Skin]
	  Healbot_Config_Skins.PowerCounter[newSkinName] = Healbot_Config_Skins.PowerCounter[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HideBars[newSkinName] = Healbot_Config_Skins.HideBars[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HideIncTank[newSkinName] = Healbot_Config_Skins.HideIncTank[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HideIncGroup[newSkinName] = Healbot_Config_Skins.HideIncGroup[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HideIncFocus[newSkinName] = Healbot_Config_Skins.HideIncFocus[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.HideIncMyTargets[newSkinName] = Healbot_Config_Skins.HideIncMyTargets[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.TooltipPos[newSkinName] = Healbot_Config_Skins.TooltipPos[Healbot_Config_Skins.Current_Skin]
    Healbot_Config_Skins.FrameScale[newSkinName] = Healbot_Config_Skins.FrameScale[Healbot_Config_Skins.Current_Skin] 
    local unique=true;
    table.foreach(HealBot_Skins, function (index,skin)
        if skin==newSkinName then unique=false; end
    end)
    if unique then
        table.insert(HealBot_Skins,2,newSkinName)
        Healbot_Config_Skins.Skin_ID = 2;
        Healbot_Config_Skins.Skins = HealBot_Skins
        Healbot_Config_Skins.Current_Skin = newSkinName
    end
    HealBot_Options_SetSkins();
    HealBot_Options_NewSkin:SetText("")
    HealBot_Options_Set_Current_Skin(newSkinName)
end

local hbDelSkinName=nil
function HealBot_Options_DeleteSkin_OnClick(self)
    if Healbot_Config_Skins.Current_Skin~=HEALBOT_SKINS_STD then
        hbDelSkinName=HealBot_Options_SkinsText:GetText()
        Healbot_Config_Skins.numcols[hbDelSkinName] = nil
        Healbot_Config_Skins.btexture[hbDelSkinName] = nil
        Healbot_Config_Skins.bcspace[hbDelSkinName] = nil
        Healbot_Config_Skins.brspace[hbDelSkinName] = nil
        Healbot_Config_Skins.bwidth[hbDelSkinName] = nil
        Healbot_Config_Skins.bheight[hbDelSkinName] = nil
        Healbot_Config_Skins.btextenabledcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.btextenabledcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.btextenabledcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.btextenabledcola[hbDelSkinName] = nil
        Healbot_Config_Skins.btextdisbledcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.btextdisbledcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.btextdisbledcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.btextdisbledcola[hbDelSkinName] = nil
        Healbot_Config_Skins.btextcursecolr[hbDelSkinName] = nil
        Healbot_Config_Skins.btextcursecolg[hbDelSkinName] = nil
        Healbot_Config_Skins.btextcursecolb[hbDelSkinName] = nil
        Healbot_Config_Skins.btextcursecola[hbDelSkinName] = nil
        Healbot_Config_Skins.backcola[hbDelSkinName] = nil
        Healbot_Config_Skins.Barcola[hbDelSkinName] = nil
        Healbot_Config_Skins.BarcolaInHeal[hbDelSkinName] = nil
        Healbot_Config_Skins.backcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.backcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.backcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.borcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.borcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.borcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.borcola[hbDelSkinName] = nil
        Healbot_Config_Skins.btextheight[hbDelSkinName] = nil
        Healbot_Config_Skins.bardisa[hbDelSkinName] = nil
        Healbot_Config_Skins.bareora[hbDelSkinName] = nil
        Healbot_Config_Skins.bar2size[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowHeader[hbDelSkinName] = nil
        Healbot_Config_Skins.headbarcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.headbarcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.headbarcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.headbarcola[hbDelSkinName] = nil
        Healbot_Config_Skins.headtxtcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.headtxtcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.headtxtcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.headtxtcola[hbDelSkinName] = nil
        Healbot_Config_Skins.headtexture[hbDelSkinName] = nil
        Healbot_Config_Skins.headwidth[hbDelSkinName] = nil
        Healbot_Config_Skins.headhight[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggro[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggroBars[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggroText[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggroBarsPct[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggroTextPct[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowAggroInd[hbDelSkinName] = nil
        Healbot_Config_Skins.LowManaInd[hbDelSkinName] = nil
        Healbot_Config_Skins.LowManaIndIC[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroIndAlertLevel[hbDelSkinName] = nil
        Healbot_Config_Skins.HighLightActiveBar[hbDelSkinName] = nil
        Healbot_Config_Skins.HighLightActiveBarInCombat[hbDelSkinName] = nil
        Healbot_Config_Skins.HighLightTargetBar[hbDelSkinName] = nil
        Healbot_Config_Skins.HighLightTargetBarInCombat[hbDelSkinName] = nil
        Healbot_Config_Skins.UseFluidBars[hbDelSkinName] = nil
        Healbot_Config_Skins.BarFreq[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowHoTicons[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIcon[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconStar[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconCircle[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconDiamond[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconTriangle[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconMoon[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconSquare[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconCross[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRaidIconSkull[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortPlayerFirst[hbDelSkinName] = nil
        Healbot_Config_Skins.ReadyCheck[hbDelSkinName] = nil
        Healbot_Config_Skins.HoTonBar[hbDelSkinName] = nil
        Healbot_Config_Skins.HoTposBar[hbDelSkinName] = nil
        Healbot_Config_Skins.HoTx2Bar[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowClassOnBar[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowClassType[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowRole[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowNameOnBar[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowHealthOnBar[hbDelSkinName] = nil
        Healbot_Config_Skins.BarHealthIncHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.BarHealthNumFormat1[hbDelSkinName] = nil
        Healbot_Config_Skins.BarHealthNumFormat2[hbDelSkinName] = nil
        Healbot_Config_Skins.BarHealthNumFormatAggro[hbDelSkinName] = nil
        Healbot_Config_Skins.BarHealthType[hbDelSkinName] = nil
        Healbot_Config_Skins.SetClassColourText[hbDelSkinName] = nil
        Healbot_Config_Skins.IncHealBarColour[hbDelSkinName] = nil
        Healbot_Config_Skins.HlthBarColour[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowDebuffIcon[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowIconTextCount[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowIconTextCountSelfCast[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowIconTextDuration[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowIconTextDurationSelfCast[hbDelSkinName] = nil
        Healbot_Config_Skins.IconScale[hbDelSkinName] = nil
        Healbot_Config_Skins.IconTextScale[hbDelSkinName] = nil
        Healbot_Config_Skins.btextfont[hbDelSkinName] = nil
        Healbot_Config_Skins.headtextfont[hbDelSkinName] = nil
        Healbot_Config_Skins.headtextheight[hbDelSkinName] = nil
        Healbot_Config_Skins.btextoutline[hbDelSkinName] = nil
        Healbot_Config_Skins.headtextoutline[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroBarSize[hbDelSkinName] = nil
        Healbot_Config_Skins.PanelAnchorY[hbDelSkinName] = nil
        Healbot_Config_Skins.highcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.highcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.highcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.targetcolr[hbDelSkinName] = nil
        Healbot_Config_Skins.targetcolg[hbDelSkinName] = nil
        Healbot_Config_Skins.targetcolb[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroColr[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroColg[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroColb[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroBarsMaxAlpha[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroBarsMinAlpha[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroBarsFreq[hbDelSkinName] = nil
        Healbot_Config_Skins.IconTextDurationShow[hbDelSkinName] = nil
        Healbot_Config_Skins.IconTextDurationWarn[hbDelSkinName] = nil
        Healbot_Config_Skins.PanelAnchorX[hbDelSkinName] = nil
        Healbot_Config_Skins.TextAlignment[hbDelSkinName] = nil
        Healbot_Config_Skins.DoubleText[hbDelSkinName] = nil
        Healbot_Config_Skins.GroupsPerCol[hbDelSkinName] = nil
        Healbot_Config_Skins.SelfHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.PetHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.GroupHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.TankHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.SelfPet[hbDelSkinName] = nil
        Healbot_Config_Skins.MainAssistHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.EmergencyHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.SetFocusBar[hbDelSkinName] = nil
        Healbot_Config_Skins.VehicleHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.ShowMyTargetsList[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetHeals[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetIncSelf[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetIncGroup[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetIncRaid[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetIncPet[hbDelSkinName] = nil
        Healbot_Config_Skins.TargetBarAlwaysShow[hbDelSkinName] = nil
        Healbot_Config_Skins.FocusBarAlwaysShow[hbDelSkinName] = nil
        Healbot_Config_Skins.GroupPetsBy5[hbDelSkinName] = nil
        Healbot_Config_Skins.AlertLevel[hbDelSkinName] = nil
        Healbot_Config_Skins.EmergIncMonitor[hbDelSkinName] = nil
        Healbot_Config_Skins.ExtraOrder[hbDelSkinName] = nil
        Healbot_Config_Skins.ExtraSubOrder[hbDelSkinName] = nil
        Healbot_Config_Skins.HidePartyFrames[hbDelSkinName] = nil
        Healbot_Config_Skins.HidePlayerTarget[hbDelSkinName] = nil
        Healbot_Config_Skins.CastNotify[hbDelSkinName] = nil
        Healbot_Config_Skins.NotifyChan[hbDelSkinName] = nil
        Healbot_Config_Skins.NotifyOtherMsg[hbDelSkinName] = nil
        Healbot_Config_Skins.CastNotifyResOnly[hbDelSkinName] = nil
        Healbot_Config_Skins.Panel_Anchor[hbDelSkinName] = nil
        Healbot_Config_Skins.Bars_Anchor[hbDelSkinName] = nil
        HealBot_Config.SkinDefault[hbDelSkinName] = nil
        Healbot_Config_Skins.AggroAlertLevel[hbDelSkinName] = nil
        Healbot_Config_Skins.IncHealBarColour[hbDelSkinName] = nil
        Healbot_Config_Skins.ExtraIncGroup[hbDelSkinName] = nil
        Healbot_Config_Skins.ActionLocked[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortIncGroup[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortIncPet[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortIncVehicle[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortIncTanks[hbDelSkinName] = nil
        Healbot_Config_Skins.SubSortIncMyTargets[hbDelSkinName] = nil
        Healbot_Config_Skins.AutoClose[hbDelSkinName] = nil
        Healbot_Config_Skins.PanelSounds[hbDelSkinName] = nil
        Healbot_Config_Skins.CrashProt[hbDelSkinName] = nil
        Healbot_Config_Skins.CombatProt[hbDelSkinName] = nil
		Healbot_Config_Skins.PowerCounter[hbDelSkinName] = nil
        Healbot_Config_Skins.HideBars[hbDelSkinName] = nil
        Healbot_Config_Skins.HideIncTank[hbDelSkinName] = nil
        Healbot_Config_Skins.HideIncGroup[hbDelSkinName] = nil
        Healbot_Config_Skins.HideIncFocus[hbDelSkinName] = nil
        Healbot_Config_Skins.HideIncMyTargets[hbDelSkinName] = nil
        Healbot_Config_Skins.CombatProtParty[hbDelSkinName] = nil
        Healbot_Config_Skins.CombatProtRaid[hbDelSkinName] = nil
        Healbot_Config_Skins.TooltipPos[hbDelSkinName] = nil
        Healbot_Config_Skins.FrameScale[hbDelSkinName] = nil
        table.remove(HealBot_Skins,Healbot_Config_Skins.Skin_ID)
        Healbot_Config_Skins.Skin_ID = 1;
        Healbot_Config_Skins.Skins = HealBot_Skins;  
        Healbot_Config_Skins.Current_Skin = HEALBOT_SKINS_STD;
        HealBot_Options_SetSkins();
        HealBot_Options_Set_Current_Skin(HEALBOT_SKINS_STD)
    end
end

function HealBot_Options_CrashProt_OnClick(self)
    Healbot_Config_Skins.CrashProt[Healbot_Config_Skins.Current_Skin]=self:GetChecked() or 0
    HealBot_useCrashProtection()
    if Delay_RecalcParty==0 then Delay_RecalcParty=1; end
end

function HealBot_Options_CombatProt_OnClick(self)
    Healbot_Config_Skins.CombatProt[Healbot_Config_Skins.Current_Skin]=self:GetChecked() or 0
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_CrashProt_OnTextChanged(self)
    text = self:GetText()
    if strlen(text)<1 or strlen(text)>14 then
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CP_MACRO_LEN)
        HealBot_Options_CrashProtEditBox:SetText(HealBot_Config.CrashProtMacroName)
    else
        if text~=HealBot_Config.CrashProtMacroName then
            DeleteMacro(HealBot_Config.CrashProtMacroName.."_0")
            DeleteMacro(HealBot_Config.CrashProtMacroName.."_1")
            DeleteMacro(HealBot_Config.CrashProtMacroName.."_2")
            DeleteMacro(HealBot_Config.CrashProtMacroName.."_3")
            DeleteMacro(HealBot_Config.CrashProtMacroName.."_4")
        end
        HealBot_Config.CrashProtMacroName = self:GetText()
    end
end

function HealBot_Options_CrashProtStartTime_OnValueChanged(self)
    HealBot_Config.CrashProtStartTime = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue().." "..HEALBOT_WORDS_SEC);
end

function HealBot_Options_CombatPartyNo_OnValueChanged(self)
    Healbot_Config_Skins.CombatProtParty[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self:GetValue().." "..self.text);
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_CombatRaidNo_OnValueChanged(self)
    Healbot_Config_Skins.CombatProtRaid[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self:GetValue().." "..self.text);
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end
        
function HealBot_Options_ShowHeaders_OnClick(self)
    Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_BarNumColsSText:SetText(HealBot_Options_SetNoColsText() .. ": " .. Healbot_Config_Skins.numcols[Healbot_Config_Skins.Current_Skin]);
    HealBot_Panel_ClearBarArrays()
    HealBot_setOptions_Timer(150)
end
 
function HealBot_Options_PlaySound_OnClick(self)
    PlaySoundFile(LSM:Fetch('sound',sounds[HealBot_Options_WarningSound:GetValue()]));    
end
    
function HealBot_Options_WarningSound_OnValueChanged(self)
    if self:GetValue() > 0 and sounds then
        HealBot_Config.SoundDebuffPlay = sounds[self:GetValue()];
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. " ".. self:GetValue()..": " ..sounds[self:GetValue()]);
    else
        g=_G[self:GetName().."Text"]
        g:SetText(self.text);
    end
    if not DoneInitTab[4] and not updatingMedia then
        PlaySoundFile(LSM:Fetch('sound',HealBot_Config.SoundDebuffPlay));
    end
    updatingMedia=false;
end

function HealBot_Options_BarTextureS_OnValueChanged(self)
    if self:GetValue() > 0 and textures then
        Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin] = textures[self:GetValue()];
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. " "..self:GetValue()..": " .. textures[self:GetValue()]);
    else
        g=_G[self:GetName().."Text"]
        g:SetText(self.text);
    end    
    if not updatingMedia then
        HealBot_setOptions_Timer(150)
        HealBot_setOptions_Timer(160)
    end
    updatingMedia=false;
end

function HealBot_FrameScale_OnValueChanged(self)
    local val=self:GetValue();
    val=val/10;
    Healbot_Config_Skins.FrameScale[Healbot_Config_Skins.Current_Skin] = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
    HealBot_setOptions_Timer(150)
end

function HealBot_BarButtonIconScale_OnValueChanged(self)
    local val=self:GetValue();
    val=val/10;
    Healbot_Config_Skins.IconScale[Healbot_Config_Skins.Current_Skin] = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
    HealBot_setOptions_Timer(150)
end

function HealBot_BarButtonIconTextScale_OnValueChanged(self)
    local val=self:GetValue();
    val=val/10;
    Healbot_Config_Skins.IconTextScale[Healbot_Config_Skins.Current_Skin] = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
    HealBot_setOptions_Timer(150)
end

function HealBot_BarButtonIconTextDurationTime_OnValueChanged(self)
    Healbot_Config_Skins.IconTextDurationShow[Healbot_Config_Skins.Current_Skin]=self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. Healbot_Config_Skins.IconTextDurationShow[Healbot_Config_Skins.Current_Skin]);
end

function HealBot_BarButtonIconTextDurationWarn_OnValueChanged(self)
    Healbot_Config_Skins.IconTextDurationWarn[Healbot_Config_Skins.Current_Skin]=self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. Healbot_Config_Skins.IconTextDurationWarn[Healbot_Config_Skins.Current_Skin]);
end

function HealBot_Options_HeadTextureS_OnValueChanged(self)
    if self:GetValue() > 0 and textures then
        Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin] = textures[self:GetValue()];
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. " " .. self:GetValue()..": " .. textures[self:GetValue()]);
    else
        g=_G[self:GetName().."Text"]
        g:SetText(self.text);
    end  
    if not updatingMedia then
        if Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin]==1 then
            HealBot_setOptions_Timer(150)
        end
        HealBot_setOptions_Timer(160)
    end
    updatingMedia=false;
end

function HealBot_Options_HeadFontNameS_OnValueChanged(self)
    if self:GetValue() > 0 and fonts then
        Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin] = fonts[self:GetValue()];
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. " ".. self:GetValue()..": " ..fonts[self:GetValue()]);
    else
        g=_G[self:GetName().."Text"]
        g:SetText(self.text);
    end   
    if not updatingMedia and  self:GetValue() > 0 then
        HealBot_setOptions_Timer(150)
    end
    updatingMedia=false;
    HealBot_setOptions_Timer(160)
end

function HealBot_Options_HeadFontHeightS_OnValueChanged(self)
    Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
    HealBot_setOptions_Timer(160)
end

function HealBot_Options_BarHeightS_OnValueChanged(self)
    Healbot_Config_Skins.bheight[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_BarWidthS_OnValueChanged(self)
    Healbot_Config_Skins.bwidth[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_BarNumColsS_OnValueChanged(self)
    Healbot_Config_Skins.numcols[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(HealBot_Options_SetNoColsText() .. ": " .. self:GetValue());
    Delay_RecalcParty=2
end

function HealBot_Options_BarBRSpaceS_OnValueChanged(self)
    Healbot_Config_Skins.brspace[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_BarBCSpaceS_OnValueChanged(self)
    Healbot_Config_Skins.bcspace[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_FontName_OnValueChanged(self)
    if self:GetValue() > 0 and fonts then
        Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin] = fonts[self:GetValue()];
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. " ".. self:GetValue()..": " ..fonts[self:GetValue()]);
    else
        g=_G[self:GetName().."Text"]
        g:SetText(self.text);
    end       
    if not updatingMedia and  self:GetValue() > 0 then
        HealBot_setOptions_Timer(150)
    end
    updatingMedia=false;
    HealBot_setOptions_Timer(160)
end

function HealBot_Options_FontHeight_OnValueChanged(self)
    Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
    HealBot_setOptions_Timer(160)
end

function HealBot_Options_AggroBarSize_OnValueChanged(self)
    Healbot_Config_Skins.AggroBarSize[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_Bar2Size_OnValueChanged(self)
    Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin] = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_setOptions_Timer(150)
	  HealBot_Options_Energy()
end

local HealBot_Alignment = { [1]=HEALBOT_OPTIONS_BUTTONLEFT, [2]=HEALBOT_OPTIONS_BUTTONMIDDLE, [3]=HEALBOT_OPTIONS_BUTTONRIGHT }
function HealBot_Options_TextAlign_OnValueChanged(self)
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. " ".. self:GetValue()..": " ..HealBot_Alignment[self:GetValue()]);
    if Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin] ~= self:GetValue() then
        Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin] = self:GetValue();
        HealBot_setOptions_Timer(150)
    end
end

function HealBot_Options_ActionAlpha_OnValueChanged(self)
    Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
end

function HealBot_Options_BarAlpha_OnValueChanged(self)
    Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_HeadWidthS_OnValueChanged(self)
    Healbot_Config_Skins.headwidth[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_HeadHightS_OnValueChanged(self)
    Healbot_Config_Skins.headhight[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_BarAlphaInHeal_OnValueChanged(self)
    Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_BarAlphaDis_OnValueChanged(self)
    Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_BarAlphaEor_OnValueChanged(self)
    Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_TTAlpha_OnValueChanged(self)
    HealBot_Globals.ttalpha = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_Tooltip:SetBackdropColor(0,0,0,HealBot_Globals.ttalpha)
    x=HealBot_Globals.ttalpha+0.12
    if x>1 then x=1 end
    HealBot_Tooltip:SetBackdropBorderColor(0.32,0.32,0.4, x)
end

local HealBot_ColourObjWaiting=nil
function HealBot_SkinColorpick_OnClick(SkinType)
    HealBot_ColourObjWaiting=SkinType;

    if SkinType=="En" then
        HealBot_UseColourPick(Healbot_Config_Skins.btextenabledcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextenabledcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextenabledcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin] or 1);
    elseif SkinType=="Dis" then
        HealBot_UseColourPick(Healbot_Config_Skins.btextdisbledcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextdisbledcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextdisbledcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="Debuff" then
        HealBot_UseColourPick(Healbot_Config_Skins.btextcursecolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextcursecolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextcursecolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.btextcursecola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="Back" then
        HealBot_UseColourPick(Healbot_Config_Skins.backcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.backcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.backcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="Bor" then
        HealBot_UseColourPick(Healbot_Config_Skins.borcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.borcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.borcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.borcola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="HeadB" then
        HealBot_UseColourPick(Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="HeadT" then
        HealBot_UseColourPick(Healbot_Config_Skins.headtxtcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headtxtcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headtxtcolb[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.headtxtcola[Healbot_Config_Skins.Current_Skin] or 1)
    elseif SkinType=="CustomBar" then
        HealBot_UseColourPick(Healbot_Config_Skins.barcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.barcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.barcolb[Healbot_Config_Skins.Current_Skin])
    elseif SkinType=="CustomIHBar" then
        HealBot_UseColourPick(Healbot_Config_Skins.ihbarcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.ihbarcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.ihbarcolb[Healbot_Config_Skins.Current_Skin])
    elseif SkinType=="HighlightBar" then
        HealBot_UseColourPick(Healbot_Config_Skins.highcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.highcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.highcolb[Healbot_Config_Skins.Current_Skin])
    elseif SkinType=="HighlightTargetBar" then
        HealBot_UseColourPick(Healbot_Config_Skins.targetcolr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.targetcolg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.targetcolb[Healbot_Config_Skins.Current_Skin])
    elseif SkinType=="Aggro" then
        HealBot_UseColourPick(Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin],
                              Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin])
    end
end

local buffbarcolrClass=nil
local buffbarcolgClass=nil
local buffbarcolbClass=nil
function HealBot_BuffColorpick_OnClick(BuffID,id)
    HealBot_ColourObjWaiting=BuffID;
    buffbarcolrClass = HealBot_Config.HealBotBuffColR
    buffbarcolgClass = HealBot_Config.HealBotBuffColG
    buffbarcolbClass = HealBot_Config.HealBotBuffColB
    HealBot_UseColourPick(buffbarcolrClass[id],
                          buffbarcolgClass[id],
                          buffbarcolbClass[id]);
end

local btextheight=nil
local barScale=nil
function HealBot_SetSkinColours()
    btextheight=Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin] or 10;
  
    HealBot_EnTextColorpick:SetStatusBarColor(0,1,0,Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_EnTextColorpickin:SetStatusBarColor(0,1,0,Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin]);
    HealBot_DisTextColorpick:SetStatusBarColor(0,1,0,Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin]); 
    HealBot_Options_SetBarsTextColour()
    HealBot_HeadTextColorpickt:SetTextColor(
        Healbot_Config_Skins.headtxtcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_BackgroundColorpick:SetStatusBarColor(
        Healbot_Config_Skins.backcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_BorderColorpick:SetStatusBarColor(
        Healbot_Config_Skins.borcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_HeadBarColorpick:SetStatusBarColor(
        Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin])
    HealBot_HeadTextColorpick:SetStatusBarColor(
        Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin])
    HealBot_BarCustomColour:SetStatusBarColor(
        Healbot_Config_Skins.barcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.barcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.barcolb[Healbot_Config_Skins.Current_Skin]);
    HealBot_BarIHCustomColour:SetStatusBarColor(
        Healbot_Config_Skins.ihbarcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.ihbarcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.ihbarcolb[Healbot_Config_Skins.Current_Skin]);
    HealBot_HighlightActiveBarColour:SetStatusBarColor(
        Healbot_Config_Skins.highcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.highcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.highcolb[Healbot_Config_Skins.Current_Skin]);
    HealBot_HighlightTargetBarColour:SetStatusBarColor(
        Healbot_Config_Skins.targetcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.targetcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.targetcolb[Healbot_Config_Skins.Current_Skin]);
    HealBot_Action:SetBackdropColor(
        Healbot_Config_Skins.backcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolb[Healbot_Config_Skins.Current_Skin], 
        Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_Action:SetBackdropBorderColor(
        Healbot_Config_Skins.borcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_Aggro3Colorpick:SetStatusBarColor(
        Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin]);
end

local sbR, sbG, sbB = nil, nil, nil
function HealBot_Options_SetBarsTextColour()
    if Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin]==0 then
        HealBot_EnTextColorpickt:SetTextColor(
            Healbot_Config_Skins.btextenabledcolr[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextenabledcolg[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextenabledcolb[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]);
        HealBot_DisTextColorpickt:SetTextColor(
            Healbot_Config_Skins.btextdisbledcolr[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextdisbledcolg[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextdisbledcolb[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]);
        HealBot_DebTextColorpickt:SetTextColor(
            Healbot_Config_Skins.btextcursecolr[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextcursecolg[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextcursecolb[Healbot_Config_Skins.Current_Skin],
            Healbot_Config_Skins.btextcursecola[Healbot_Config_Skins.Current_Skin]);
    else
        sbR, sbG, sbB = HealBot_Action_ClassColour(HealBot_PlayerGUID, "player")
        HealBot_EnTextColorpickt:SetTextColor(
            sbR,
            sbG,
            sbB,
            Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin]);
        HealBot_DisTextColorpickt:SetTextColor(
            sbR,
            sbG,
            sbB,
            Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin]);
        HealBot_DebTextColorpickt:SetTextColor(
            sbR,
            sbG,
            sbB,
            Healbot_Config_Skins.btextcursecola[Healbot_Config_Skins.Current_Skin]);
    end
end

function HealBot_Options_AlertLevel_OnValueChanged(self)
    Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_AggroFlashFreq_OnValueChanged(self)
    local val=self:GetValue();
    val=val/100;
    Healbot_Config_Skins.AggroBarsFreq[Healbot_Config_Skins.Current_Skin] = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
    HealBot_Action_Set_Timers()
end

function HealBot_Options_AggroFlashAlphaMin_OnValueChanged(self)
    Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    if Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin]>=Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin] then
        Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin]=Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin]+0.05
        HealBot_Options_AggroFlashAlphaMax:SetValue(Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin])
    end
end

function HealBot_Options_AggroFlashAlphaMax_OnValueChanged(self)
    Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin] = HealBot_Options_Pct_OnValueChanged(self);
    if Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin]<=Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin] then
        Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin]=Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin]-0.05
        HealBot_Options_AggroFlashAlphaMin:SetValue(Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin])
    end
end

function HealBot_Options_RangeCheckFreq_OnValueChanged(self)
    local val=self:GetValue();
    val=val/10;
    HealBot_Globals.RangeCheckFreq = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
end

function HealBot_Options_BuffTimer_OnValueChanged(self,bufftype)
    local val=self:GetValue();
    if bufftype=="SHORT" then
        HealBot_Config.ShortBuffTimer = val;
    else
        HealBot_Config.LongBuffTimer = val;
    end
    local mins,secs=HealBot_Tooltip_ReturnMinsSecs(val)
    if mins<1 then
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. ": " .. secs .." secs");
    else
        val=val/60;
        g=_G[self:GetName().."Text"]
        g:SetText(self.text .. ": " .. mins ..":".. secs .." mins");
    end
    HealBot_setOptions_Timer(10)
end

function HealBot_Options_BarFreq_OnValueChanged(self)
    local val=self:GetValue();
    val=val/10;
    Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin] = val;
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. val);
end

function HealBot_Options_NumTestBars_OnValueChanged(self)
    HealBot_Globals.noTestBars = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    HealBot_Panel_SetNumBars(HealBot_Globals.noTestBars)
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_NumTestTanks_OnValueChanged(self)
    HealBot_Globals.noTestTanks = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_NumTestMyTargets_OnValueChanged(self)
    HealBot_Globals.noTestTargets = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_NumTestPets_OnValueChanged(self)
    HealBot_Globals.noTestPets = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_AutoShow_OnClick(self)
    Healbot_Config_Skins.AutoClose[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
    if Healbot_Config_Skins.AutoClose[Healbot_Config_Skins.Current_Skin]==0 and HealBot_Config.DisabledNow==0 then
        ShowUIPanel(HealBot_Action)
    else
        HealBot_Action_Refresh(HealBot_PlayerGUID)
    end
end

function HealBot_Options_IgnoreDebuffsClass_OnClick(self)
    HealBot_Config.IgnoreClassDebuffs = self:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsNoHarm_OnClick(self)
    HealBot_Config.IgnoreNonHarmfulDebuffs = self:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsDuration_OnClick(self)
    HealBot_Config.IgnoreFastDurDebuffs = self:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsDurationSecs_OnValueChanged(self)
    HealBot_Config.IgnoreFastDurDebuffsSecs = self:GetValue();
    g=_G[self:GetName().."Text"]
    g:SetText(self.text .. ": " .. self:GetValue());
end

function HealBot_Options_IgnoreDebuffsMovement_OnClick(self)
    HealBot_Config.IgnoreMovementDebuffs = self:GetChecked() or 0;
end

function HealBot_Options_CastNotifyResOnly_OnClick(self)
    Healbot_Config_Skins.CastNotifyResOnly[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_BarNumGroupPerCol_OnClick(self)
    Healbot_Config_Skins.GroupsPerCol[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_BarNumColsSText:SetText(HealBot_Options_SetNoColsText() .. ": " .. Healbot_Config_Skins.numcols[Healbot_Config_Skins.Current_Skin]);
    Delay_RecalcParty=2
end

function HealBot_Options_ShowPowerCounter_OnClick(self)
    Healbot_Config_Skins.PowerCounter[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
	HealBot_Action_setpcClass()
	HealBot_Options_Energy()
end

function HealBot_Options_Energy()
	if Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin]>0 then 
		HealBot_Register_Mana() 
	elseif Healbot_Config_Skins.PowerCounter[Healbot_Config_Skins.Current_Skin]==1 and 
           (HealBot_PlayerClassTrim==HealBot_Class_En[HEALBOT_PALADIN] or HealBot_PlayerClassTrim==HealBot_Class_En[HEALBOT_MONK]) then
		HealBot_Register_Mana() 
	else
		HealBot_UnRegister_Mana()
	end
end

function HealBot_Options_ShowTooltipMyBuffs_OnClick(self)
    HealBot_Globals.Tooltip_ShowMyBuffs = self:GetChecked() or 0;
end

function HealBot_Options_ShowClassOnBar_OnClick(self)
    if Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin]==1 then HealBot_RaidTargetToggle(nil) end
    Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
    if Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin]==0 then
        HealBot_Options_ShowClassOnBarType1:Disable();
        HealBot_Options_ShowClassOnBarType2:Disable();
    else
        HealBot_Options_ShowClassOnBarType1:Enable();
        HealBot_Options_ShowClassOnBarType2:Enable();
    end
end

function HealBot_Options_ShowNameOnBar_OnClick(self)
    Healbot_Config_Skins.ShowNameOnBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

function HealBot_BarHealthIncHeal_OnClick(self)
    Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_PartyFrames_OnClick(self)
    Healbot_Config_Skins.HidePartyFrames[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(180)
end

function HealBot_Options_AggroTrack_OnClick(self)
    Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin]==0 then
        HealBot_UnRegister_Aggro()
    else
        HealBot_Register_Aggro()
    end
    HealBot_setOptions_Timer(150)
    HealBot_setOptions_Timer(80)
    HealBot_Action_Set_Timers()
end

function HealBot_Options_HighlightActiveBar_OnClick(self)
    Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_HighlightTargetBar_OnClick(self)
    Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
end

function HealBot_Options_HighlightActiveBarInCombat_OnClick(self)
    Healbot_Config_Skins.HighLightActiveBarInCombat[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_HighlightTargetBarInCombat_OnClick(self)
    Healbot_Config_Skins.HighLightTargetBarInCombat[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_UseFluidBars_OnClick(self)
    Healbot_Config_Skins.UseFluidBars[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
    HealBot_Action_Set_Timers()
end

function HealBot_Options_EnableLibQuickHealth_OnClick(self)
    HealBot_Globals.EnLibQuickHealth = self:GetChecked() or 0;
    StaticPopup_Show ("HEALBOT_OPTIONS_RELOADUI");
end

function HealBot_Options_AggroBar_OnClick(self)
    Healbot_Config_Skins.ShowAggroBars[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
    HealBot_setOptions_Timer(80)
    HealBot_Action_Set_Timers()
end

function HealBot_Options_AggroTxt_OnClick(self)
    Healbot_Config_Skins.ShowAggroText[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_AggroInd_OnClick(self)
    Healbot_Config_Skins.ShowAggroInd[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_AggroBarPct_OnClick(self)
    Healbot_Config_Skins.ShowAggroBarsPct[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_nileUnit()
end

function HealBot_Options_AggroTxtPct_OnClick(self)
    Healbot_Config_Skins.ShowAggroTextPct[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_nileUnit()
    HealBot_setOptions_Timer(85)
end

function HealBot_Options_CPUProfiler_OnClick(self)
    CPUProfiler = self:GetChecked() or 0;
    SetCVar("scriptProfile", CPUProfiler)
    StaticPopup_Show ("HEALBOT_OPTIONS_RELOADUI");
end

function HealBot_Options_PlayerTargetFrames_OnClick(self)
    Healbot_Config_Skins.HidePlayerTarget[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(180)
end

function HealBot_Options_MonitorBuffs_OnClick(self)
    HealBot_Config.BuffWatch = self:GetChecked() or 0;
    HealBot_Options_MonitorBuffs_Toggle()
end

function HealBot_Options_MonitorBuffs_Toggle()
    if HealBot_Config.BuffWatch==0 then
        HealBot_Options_MonitorBuffsInCombat:Disable();
        HealBot_ClearAllBuffs()
        for x,_ in pairs(HealBot_UnitBuff) do
            HealBot_UnitBuff[x]=nil;
        end
    else
        HealBot_Options_MonitorBuffsInCombat:Enable();
        HealBot_setOptions_Timer(40)
    end
end

function HealBot_Options_MonitorDebuffs_OnClick(self)
    HealBot_Config.DebuffWatch = self:GetChecked() or 0;
    HealBot_Options_MonitorDebuffs_Toggle()
end

function HealBot_Options_MonitorDebuffs_Toggle()
    if HealBot_Config.DebuffWatch==0 then
        HealBot_Options_MonitorDebuffsInCombat:Disable();
        HealBot_ClearAllDebuffs()
        for x,_ in pairs(HealBot_UnitDebuff) do
            HealBot_UnitDebuff[x]=nil;
        end
    else
        HealBot_Options_MonitorDebuffsInCombat:Enable();
        HealBot_setOptions_Timer(50)
    end
end

function HealBot_Options_MonitorBuffsInCombat_OnClick(self)
    HealBot_Config.BuffWatchInCombat = self:GetChecked() or 0;
    HealBot_setOptions_Timer(40)
end

function HealBot_Options_ManaIndicatorInCombat_OnClick(self)
    Healbot_Config_Skins.LowManaIndIC[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end


function HealBot_Options_MonitorDebuffsInCombat_OnClick(self)
    HealBot_Config.DebuffWatchInCombat = self:GetChecked() or 0;
    HealBot_setOptions_Timer(50)
end

function HealBot_Options_CDCCol_ShowOnHealthBar_OnClick(self)
    HealBot_Config.CDCshownHB = self:GetChecked() or 0;
end

function HealBot_Options_CDCCol_OnOff_OnClick(self)
    if HealBot_Options_StorePrev["CDebuffcustomName"] then
        x= self:GetChecked() or 0
        if x==1 then
            HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_Options_StorePrev["CDebuffcustomName"]] = nil
        else
            HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_Options_StorePrev["CDebuffcustomName"]] = x
        end
    else
        HealBot_Options_CDCCol_OnOff:SetChecked(HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_Options_StorePrev["CDebuffcustomName"]] or 1)
    end
end

function HealBot_Options_CDCCol_ShowOnAggroBar_OnClick(self)
    HealBot_Config.CDCshownAB = self:GetChecked() or 0;
    if HealBot_Config.CDCshownAB==0 then
        HealBot_Action_ClearUnitDebuffStatus()
        HealBot_SetResetFlag("SOFT")
    end
end

function HealBot_Options_PanelSounds_OnClick(self)
    Healbot_Config_Skins.PanelSounds[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_ActionLocked_OnClick(self)
    Healbot_Config_Skins.ActionLocked[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_DisableHealBot_OnClick(self)
    HealBot_Options_DisableHealBot(self:GetChecked() or 0)
end

function HealBot_Options_NoAuraWhenRested_OnClick(self)
    HealBot_Config.NoAuraWhenRested = self:GetChecked() or 0;
    if HealBot_Config.NoAuraWhenRested==0 then 
        HealBot_setOptions_Timer(30) 
    else
        HealBot_SetResetFlag("SOFT")
    end
end

function HealBot_Options_DisableHealBot(checkval)
    HealBot_Config.DisableHealBot=checkval
    HealBot_Options_DisableCheck()
end

function HealBot_Options_DisableHealBotSolo_OnClick(self)
    HealBot_Config.DisableSolo = self:GetChecked() or 0
    HealBot_Options_DisableCheck()
end

function HealBot_Options_DisableCheck()
    if HealBot_Config.DisableHealBot==0 then
        z=0
    elseif HealBot_Config.DisableSolo==0 then
        z=1
    elseif GetNumGroupMembers()==0 then
        z=1
    else
        z=0
    end
    if HealBot_Config.DisabledNow~=z then
        HealBot_Config.DisabledNow=z
        HealBot_setOptions_Timer(500+z)
        if z==1 then 
            HideUIPanel(HealBot_Action) 
            HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_DISABLED)
        else
            ShowUIPanel(HealBot_Action)
            HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_ENABLED)
        end
        if TITAN_HEALBOT_ID then TitanPanelButton_UpdateButton(TITAN_HEALBOT_ID, 1) end
    end
end

function HealBot_Options_GroupHeals_OnClick(self)
    Healbot_Config_Skins.GroupHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_TankHeals_OnClick(self)
    Healbot_Config_Skins.TankHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_MainAssistHeals_OnClick(self)
    Healbot_Config_Skins.MainAssistHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_EmergencyHeals_OnClick(self)
    Healbot_Config_Skins.EmergencyHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_SelfHeals_OnClick(self)
    Healbot_Config_Skins.SelfHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_PetHeals_OnClick(self)
    Healbot_Config_Skins.PetHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_FocusBar_OnClick(self)
    Healbot_Config_Skins.SetFocusBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_MyTargetsList_OnClick(self)
    Healbot_Config_Skins.ShowMyTargetsList[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_VehicleHeals_OnClick(self)
    Healbot_Config_Skins.VehicleHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_TargetBar_OnClick(self)
    Healbot_Config_Skins.TargetHeals[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_TargetIncSelf_OnClick(self)
    Healbot_Config_Skins.TargetIncSelf[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_TargetIncGroup_OnClick(self)
    Healbot_Config_Skins.TargetIncGroup[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_TargetIncRaid_OnClick(self)
    Healbot_Config_Skins.TargetIncRaid[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_TargetIncPet_OnClick(self)
    Healbot_Config_Skins.TargetIncPet[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_SubSortIncGroup_OnClick(self)
    Healbot_Config_Skins.SubSortIncGroup[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_SubSortIncPet_OnClick(self)
    Healbot_Config_Skins.SubSortIncPet[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_SubSortIncVehicle_OnClick(self)
    Healbot_Config_Skins.SubSortIncVehicle[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_SubSortIncTanks_OnClick(self)
    Healbot_Config_Skins.SubSortIncTanks[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_SubSortIncMyTargets_OnClick(self)
    Healbot_Config_Skins.SubSortIncMyTargets[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_HideBar_OnClick(self)
    Healbot_Config_Skins.HideBars[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_HideIncFocus_OnClick(self)
    Healbot_Config_Skins.HideIncFocus[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_HideIncGroup_OnClick(self)
    Healbot_Config_Skins.HideIncGroup[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_HideIncTank_OnClick(self)
    Healbot_Config_Skins.HideIncTank[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_HideIncMyTargets_OnClick(self)
    Healbot_Config_Skins.HideIncMyTargets[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<1 then Delay_RecalcParty=1; end
end

function HealBot_Options_FocusAlwaysShow_OnClick(self)
    Healbot_Config_Skins.FocusBarAlwaysShow[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_TargetAlwaysShow_OnClick(self)
    Healbot_Config_Skins.TargetBarAlwaysShow[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_GroupPetsByFive_OnClick(self)
    Healbot_Config_Skins.GroupPetsBy5[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_EFGroup_OnClick(self,id)
    if self:GetChecked() then
        Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][id] = true;
    else
        Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][id] = false;
    end
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_EFClass_OnClick(self)
    if HealBot_Globals.EmergencyFClass==1 then
        HealBot_Globals.EmergIncMelee[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
        HealBot_Globals.EmergIncMelee[HEALBOT_DEATHKNIGHT] = HealBot_Options_EFClassDeathKnight:GetChecked() or 0;
    elseif HealBot_Globals.EmergencyFClass==2 then
        HealBot_Globals.EmergIncRange[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
        HealBot_Globals.EmergIncRange[HEALBOT_DEATHKNIGHT] = HealBot_Options_EFClassDeathKnight:GetChecked() or 0;
    elseif HealBot_Globals.EmergencyFClass==3 then
        HealBot_Globals.EmergIncHealers[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
        HealBot_Globals.EmergIncHealers[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0
        HealBot_Globals.EmergIncHealers[HEALBOT_DEATHKNIGHT] = HealBot_Options_EFClassDeathKnight:GetChecked() or 0;
    elseif HealBot_Globals.EmergencyFClass==4 then
        HealBot_Globals.EmergIncCustom[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
        HealBot_Globals.EmergIncCustom[HEALBOT_DEATHKNIGHT] = HealBot_Options_EFClassDeathKnight:GetChecked() or 0;
    end
    if Delay_RecalcParty==0 then 
        Delay_RecalcParty=1; 
    end
end

HealBot_Options_StorePrev["CastNotify"]=1
function HealBot_Options_CastNotify_OnClick(self,id)
    if id>0 and id~=HealBot_Options_StorePrev["CastNotify"] then
        g=_G["HealBot_Options_CastNotify"..HealBot_Options_StorePrev["CastNotify"]]
        g:SetChecked(nil);
        HealBot_Options_StorePrev["CastNotify"]=id
    end
    Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin] = id;
    if Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin]>0 then
        g=_G["HealBot_Options_CastNotify"..Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin]]
        g:SetChecked(1);
    end
end

function HealBot_Options_HideOptions_OnClick(self)
    HealBot_Globals.HideOptions = self:GetChecked() or 0;
    if Delay_RecalcParty==0 then 
        Delay_RecalcParty=1; 
    end
end

function HealBot_Options_RightButtonOptions_OnClick(self)
    HealBot_Globals.RightButtonOptions = self:GetChecked() or 0;
end

function HealBot_Options_ShowMinimapButton_OnClick(self)
    HealBot_Globals.ButtonShown = self:GetChecked() or 0;
    HealBot_MMButton_Init()
end

function HealBot_Options_QueryTalents_OnClick(self)
    HealBot_Globals.QueryTalents = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltip_OnClick(self)
    HealBot_Globals.ShowTooltip = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipUpdate_OnClick(self)
    HealBot_Globals.TooltipUpdate = self:GetChecked() or 0;
end

function HealBot_Options_HideTooltipInCombat_OnClick(self)
    HealBot_Globals.DisableToolTipInCombat = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipTarget_OnClick(self)
    HealBot_Globals.Tooltip_ShowTarget = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipSpellDetail_OnClick(self)
    HealBot_Globals.Tooltip_ShowSpellDetail = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipSpellCoolDown_OnClick(self)
    HealBot_Globals.Tooltip_ShowCD = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipInstant_OnClick(self)
    HealBot_Globals.Tooltip_Recommend = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipUseGameTip_OnClick(self)
    HealBot_Globals.UseGameTooltip = self:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipShowHoT_OnClick(self)
    HealBot_Globals.Tooltip_ShowHoT = self:GetChecked() or 0;
end

function HealBot_Options_ShowDebuffWarning_OnClick(self)
    HealBot_Config.ShowDebuffWarning = self:GetChecked() or 0;
end

function HealBot_Options_ShowDebuffIcon_OnClick(self)
    Healbot_Config_Skins.ShowDebuffIcon[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_SoundDebuffWarning_OnClick(self)
    HealBot_Config.SoundDebuffWarning = self:GetChecked() or 0;
    if HealBot_Config.SoundDebuffWarning==0 then
        HealBot_Options_WarningSound:Disable();
        HealBot_Options_PlaySound:Disable();
    else
        HealBot_Options_WarningSound:Enable();
        HealBot_Options_PlaySound:Enable();
      end
end

function HealBot_Options_NumberTextLines_OnClick(self)
    Healbot_Config_Skins.DoubleText[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

function HealBot_Options_BarTextInClassColour_OnClick(self)
    Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Action_ResetUnitStatus()
    HealBot_Options_SetBarsTextColour()
    HealBot_Panel_resetTestCols()
end

function HealBot_Options_BarButtonShowHoT_OnClick(self)
    Healbot_Config_Skins.ShowHoTicons[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_BarButtonShowRaidIcon_OnClick(self)
    Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconStar_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconStar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconCircle_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconCircle[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconDiamond_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconDiamond[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconTriangle_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconTriangle[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconMoon_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconMoon[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconSquare_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconSquare[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconCross_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconCross[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_BarButtonShowRaidIconSkull_OnClick(self)
    Healbot_Config_Skins.ShowRaidIconSkull[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_Options_RaidTargetUpdate()
end

function HealBot_Options_SubSortPlayerFirst_OnClick(self)
    Healbot_Config_Skins.SubSortPlayerFirst[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0
    if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
end

function HealBot_Options_ShowReadyCheck_OnClick(self)
    Healbot_Config_Skins.ReadyCheck[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    if Healbot_Config_Skins.ReadyCheck[Healbot_Config_Skins.Current_Skin]==0 then
        HealBot_UnRegister_ReadyCheck()
    else
        HealBot_Register_ReadyCheck()
    end
end

function HealBot_Options_RaidTargetUpdate()
    if Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin]==1 then 
        HealBot_RaidTargetToggle(true) 
    else
        HealBot_RaidTargetToggle(nil) 
    end
end

function HealBot_BarButtonShowHoTTextCount_OnClick(self)
    Healbot_Config_Skins.ShowIconTextCount[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_BarButtonShowHoTTextCountSelfCast_OnClick(self)
    Healbot_Config_Skins.ShowIconTextCountSelfCast[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_BarButtonShowHoTTextDuration_OnClick(self)
    Healbot_Config_Skins.ShowIconTextDuration[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_BarButtonShowHoTTextDurationSelfCast_OnClick(self)
    Healbot_Config_Skins.ShowIconTextDurationSelfCast[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
end

function HealBot_Options_ShowHealthOnBar_OnClick(self)
    Healbot_Config_Skins.ShowHealthOnBar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(80)
end

HealBot_Options_StorePrev["HoTonBar"]=-1
function HealBot_HoTonBar_OnClick(self,id)
    if HealBot_Options_StorePrev["HoTonBar"]==-1 then
        HealBot_Options_StorePrev["HoTonBar"]=Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin] or 1
    end
    if HealBot_Options_StorePrev["HoTonBar"]<1 then HealBot_Options_StorePrev["HoTonBar"]=1 end
    g=_G["HealBot_BarButtonShowHoTonBar"..HealBot_Options_StorePrev["HoTonBar"]]
    g:SetChecked(nil);
    Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin] = id;
    if Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin]>0 then
        g=_G["HealBot_BarButtonShowHoTonBar"..Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin]]
        g:SetChecked(1);
        HealBot_Options_StorePrev["HoTonBar"]=id
        HealBot_setOptions_Timer(150)
    end
end

HealBot_Options_StorePrev["HoTposBar"]=-1
function HealBot_HoTposBar_OnClick(self,id)
    if HealBot_Options_StorePrev["HoTposBar"]==-1 then
        if Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]==1 then
            HealBot_Options_StorePrev["HoTposBar"]=1
        else
            HealBot_Options_StorePrev["HoTposBar"]=2
        end
    end
    g=_G["HealBot_BarButtonShowHoTposBar"..HealBot_Options_StorePrev["HoTposBar"]]
    g:SetChecked(nil);
    Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin] = id;
    if Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]>0 then
        g=_G["HealBot_BarButtonShowHoTposBar"..Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin]]
        g:SetChecked(1);
        HealBot_Options_StorePrev["HoTposBar"]=id
        HealBot_setOptions_Timer(150)
    end
end

function HealBot_HoTx2Bar_OnClick(self)
    Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
end

HealBot_Options_StorePrev["ShowClassOnBarType"]=-1
function HealBot_Options_ShowClassOnBarType_OnClick(self,id)
    if Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin]==1 then HealBot_RaidTargetToggle(nil) end
    if HealBot_Options_StorePrev["ShowClassOnBarType"]==-1 then
        if Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]==1 then
            HealBot_Options_StorePrev["ShowClassOnBarType"]=1
        else
            HealBot_Options_StorePrev["ShowClassOnBarType"]=2
        end
    end
    g=_G["HealBot_Options_ShowClassOnBarType"..HealBot_Options_StorePrev["ShowClassOnBarType"]]
    g:SetChecked(nil);
    Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin] = id;
    if Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]>0 then
        g=_G["HealBot_Options_ShowClassOnBarType"..Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin]]
        g:SetChecked(1);
        HealBot_Options_StorePrev["ShowClassOnBarType"]=id
        HealBot_setOptions_Timer(150)
    end
end

function HealBot_Options_ProtectPvP_OnClick(self)
    HealBot_Globals.ProtectPvP = self:GetChecked() or 0;
end

function HealBot_Options_ShowRoleOnBar_OnClick(self)
    Healbot_Config_Skins.ShowRole[Healbot_Config_Skins.Current_Skin] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(150)
end

--------------------------------------------------------------------------------

HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]="1,2K"

function HealBot_Options_BarHealthNumFormat_genList()
    local HealBot_Options_BarHealthNumFormat_List={}
    if Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]==1 then
        local HealBot_Options_BarHealthNumFormat1h_List = {
            "1234",
            "1K",
            "1.2K",
            "1.23K",
            "1k",
            "1.2k",
            "1.23k",
            "1",
            "1.2",
            "1.23",
        }
        HealBot_Options_BarHealthNumFormat_List=HealBot_Options_BarHealthNumFormat1h_List
    elseif Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]==2 then
        local HealBot_Options_BarHealthNumFormat1d_List = {
            "-4321",
            "-4K",
            "-4.3K",
            "-4.32K",
            "-4k",
            "-4.3k",
            "-4.32k",
            "-4",
            "-4.3",
            "-4.32",
        }
        HealBot_Options_BarHealthNumFormat_List=HealBot_Options_BarHealthNumFormat1d_List
    else
        local HealBot_Options_BarHealthNumFormat1p_List = {
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
            "88%",
        }
        HealBot_Options_BarHealthNumFormat_List=HealBot_Options_BarHealthNumFormat1p_List
    end
    HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]=HealBot_Options_BarHealthNumFormat_List[Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]]
    return HealBot_Options_BarHealthNumFormat_List
end

function HealBot_Options_BarHealthNumFormat1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local HealBot_Options_BarHealthNumFormat1_List=HealBot_Options_BarHealthNumFormat_genList()
    for j=1, getn(HealBot_Options_BarHealthNumFormat1_List), 1 do
        info.text = HealBot_Options_BarHealthNumFormat1_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]=self:GetText()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarHealthNumFormat1,Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]) 
                        DoneInitTab[308]=nil
                        HealBot_Options_InitSub(308)
                        HealBot_setOptions_Timer(80)
                    end
        info.checked = false;
        if Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]==j then
            HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]=HealBot_Options_BarHealthNumFormat1_List[j]
            info.checked = true
        end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_BarHealthNumFormat2_List = {
    " ", " ",
    "(", ")",
    "[", "]",
    "{", "}",
    "<", ">",
    "~", " ",
    ":", ":",
    "*", "*",
}

function HealBot_Options_BarHealthNumFormat2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local i=0
    for j=1, getn(HealBot_Options_BarHealthNumFormat2_List), 2 do
        i=i+1
        info.text = HealBot_Options_BarHealthNumFormat2_List[j]..HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]..HealBot_Options_BarHealthNumFormat2_List[j+1];
        info.func = function(self)
                        Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarHealthNumFormat2,Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(80)
                    end
        info.checked = false;
        if Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]==i then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_BarHealthNumFormatAggro_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local i=0
    for j=1, getn(HealBot_Options_BarHealthNumFormat2_List), 2 do
        i=i+1
        info.text = HealBot_Options_BarHealthNumFormat2_List[j].."77%"..HealBot_Options_BarHealthNumFormat2_List[j+1];
        info.func = function(self)
                        Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarHealthNumFormatAggro,Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(85)
                    end
        info.checked = false;
        if Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]==i then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_FontOutline_List = {
    HEALBOT_WORDS_NONE,
    HEALBOT_WORDS_THIN,
    HEALBOT_WORDS_THICK,
}

function HealBot_Options_FontOutline_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_FontOutline_List), 1 do
        info.text = HealBot_Options_FontOutline_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_FontOutline,Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(150)
                        HealBot_setOptions_Timer(160)
                    end
        info.checked = false;
        if Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_HeadFontOutline_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_FontOutline_List), 1 do
        info.text = HealBot_Options_FontOutline_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_HeadFontOutline,Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(150)
                        HealBot_setOptions_Timer(160)
                    end
        info.checked = false;
        if Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

-------------------------------------------

local HealBot_Options_BarHealthIncHeal_List = {
    HEALBOT_WORDS_NO.." "..HEALBOT_OPTIONS_INCHEAL,
    HEALBOT_OPTIONS_BARHEALTHINCHEALS,
    HEALBOT_OPTIONS_BARHEALTHSEPHEALS,
}

function HealBot_Options_BarHealthIncHeal_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BarHealthIncHeal_List), 1 do
        info.text = HealBot_Options_BarHealthIncHeal_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarHealthIncHeal,Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(80)
                    end
        info.checked = false;
        if Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_BarHealthColour_List = {
    HEALBOT_WORD_HEALTH,
    HEALBOT_SORTBY_CLASS,
    HEALBOT_CLASSES_CUSTOM,
}

function HealBot_Options_BarHealthColour_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BarHealthColour_List), 1 do
        info.text = HealBot_Options_BarHealthColour_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarHealthColour,Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(80)
                    end
        info.checked = false;
        if Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

-------------------------------------------

local HealBot_Options_BarIncHealColour_List = {
    HEALBOT_OPTIONS_DONT_SHOW,
    HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT,
    HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE,
    HEALBOT_OPTIONS_FUTURE_HLTH,
    HEALBOT_CLASSES_CUSTOM,
}

function HealBot_Options_BarIncHealColour_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BarIncHealColour_List), 1 do
        info.text = HealBot_Options_BarIncHealColour_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BarIncHealColour,Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]) 
                        if Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]==1 then
                            HealBot_UnRegister_IncHeals()
                        else
                            HealBot_Register_IncHeals()
                        end
                    end
        info.checked = false;
        if Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

-------------------------------------------

local HealBot_Options_BarHealthType_List = {
    HEALBOT_OPTIONS_BARHEALTH3,
    HEALBOT_OPTIONS_BARHEALTH1,
    HEALBOT_OPTIONS_BARHEALTH2,
}

local function HealBot_Options_BarHealthType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BarHealthType_List), 1 do
        info.text = HealBot_Options_BarHealthType_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetText(HealBot_Options_BarHealthType, HealBot_Options_BarHealthType_List[Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]])
                        DoneInitTab[307]=nil
                        HealBot_Options_InitSub(307)
                        DoneInitTab[308]=nil
                        HealBot_Options_InitSub(308)
                        HealBot_setOptions_Timer(80)
                    end
        info.checked = false;
        if Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_CastButton_List = {
    HEALBOT_OPTIONS_BUTTONLEFT,
    HEALBOT_OPTIONS_BUTTONMIDDLE,
    HEALBOT_OPTIONS_BUTTONRIGHT,
    HEALBOT_OPTIONS_BUTTON4,
    HEALBOT_OPTIONS_BUTTON5,
    HEALBOT_OPTIONS_BUTTON6,
    HEALBOT_OPTIONS_BUTTON7,
    HEALBOT_OPTIONS_BUTTON8,
    HEALBOT_OPTIONS_BUTTON9,
    HEALBOT_OPTIONS_BUTTON10,
    HEALBOT_OPTIONS_BUTTON11,
    HEALBOT_OPTIONS_BUTTON12,
    HEALBOT_OPTIONS_BUTTON13,
    HEALBOT_OPTIONS_BUTTON14,
    HEALBOT_OPTIONS_BUTTON15,
}

local function HealBot_Options_CastButton_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_CastButton_List), 1 do
        info.text = HealBot_Options_CastButton_List[j];
        info.func = function(self)
                        HealBot_Options_ComboButtons_Button = self:GetID()
                        UIDropDownMenu_SetText(HealBot_Options_CastButton, HealBot_Options_CastButton_List[HealBot_Options_ComboButtons_Button])
                        HealBot_Options_ComboClass_Text()
                    end
        info.checked = false;
        if HealBot_Options_ComboButtons_Button==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_ButtonCastMethod_List = {
    HEALBOT_OPTIONS_BUTTONCASTPRESSED,
    HEALBOT_OPTIONS_BUTTONCASTRELEASED,
}

function HealBot_Options_ButtonCastMethod_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ButtonCastMethod_List), 1 do
        info.text = HealBot_Options_ButtonCastMethod_List[j];
        info.func = function(self)
                        local x=HealBot_Config.ButtonCastMethod
                        HealBot_Config.ButtonCastMethod = self:GetID()
                        if x~=HealBot_Config.ButtonCastMethod then 
                            UIDropDownMenu_SetText(HealBot_Options_ButtonCastMethod, HealBot_Options_ButtonCastMethod_List[HealBot_Config.ButtonCastMethod])
                            HealBot_setOptions_Timer(110)
                        end
                    end
        info.checked = false;
        if HealBot_Config.ButtonCastMethod==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_MouseWheel_List = {
    HEALBOT_WORDS_NONE,
    HEALBOT_BLIZZARD_MENU,
    HEALBOT_HB_MENU,
    HEALBOT_FOLLOW,
    HEALBOT_TRADE,
    HEALBOT_PROMOTE_RA,
    HEALBOT_DEMOTE_RA,
    HEALBOT_TOGGLE_ENABLED,
    HEALBOT_TOGGLE_MYTARGETS,
    HEALBOT_TOGGLE_PRIVATETANKS,
    HEALBOT_RESET_BAR,
    HEALBOT_RANDOMMOUNT,
    HEALBOT_RANDOMGOUNDMOUNT,
    HEALBOT_RANDOMPET,
}

function HealBot_Options_MouseWheelUp_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["NoneUp"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelDown_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["NoneDown"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelShiftUp_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["ShiftUp"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelShiftUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelShiftDown_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["ShiftDown"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelShiftDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelCtrlUp_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["CtrlUp"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelCtrlUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelCtrlDown_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["CtrlDown"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelCtrlDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelAltUp_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["AltUp"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["AltUp"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelAltUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["AltUp"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["AltUp"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_MouseWheelAltDown_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_MouseWheel_List), 1 do
        info.text = HealBot_Options_MouseWheel_List[j];
        info.func = function(self)
                        HealBot_Globals.HealBot_MouseWheelIndex["AltDown"] = self:GetID()
                        HealBot_Globals.HealBot_MouseWheelTxt["AltDown"] = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_MouseWheelAltDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["AltDown"]])
                        HealBot_Action_InitFuncUse()
                    end
        info.checked = false;
        if HealBot_Globals.HealBot_MouseWheelIndex["AltDown"] == j then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_hbCommands_List = {
    HEALBOT_WORDS_NONE,
    HEALBOT_CMD_CLEARBLACKLIST,
    HEALBOT_CMD_COPYSPELLS,
    HEALBOT_CMD_DELCUSTOMDEBUFF10,
    HEALBOT_CMD_RESETBARS,
    HEALBOT_CMD_RESETBUFFS,
    HEALBOT_CMD_RESETCURES,
    HEALBOT_CMD_RESETCUSTOMDEBUFFS,
    HEALBOT_CMD_RESETSKINS,
    HEALBOT_CMD_RESETSPELLS,
    HEALBOT_CMD_TOGGLEACCEPTSKINS,
    HEALBOT_CMD_SUPPRESSERRORS,
    HEALBOT_CMD_SUPPRESSSOUND,
}

HealBot_Options_StorePrev["hbCommands"] = 1

function HealBot_Options_hbCommands_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_hbCommands_List), 1 do
        info.text = HealBot_Options_hbCommands_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["hbCommands"] = self:GetID()
                        UIDropDownMenu_SetText(HealBot_Options_hbCommands, HealBot_Options_hbCommands_List[HealBot_Options_StorePrev["hbCommands"]])
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["hbCommands"]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CommandsButton_OnClick(self)
    if HealBot_Options_StorePrev["hbCommands"]==2 then
        HealBot_Panel_ClearBlackList()
    elseif HealBot_Options_StorePrev["hbCommands"]==3 then
        HealBot_Copy_SpellCombos()
    elseif HealBot_Options_StorePrev["hbCommands"]==4 then
        HealBot_Options_delCustomPrio10()
    elseif HealBot_Options_StorePrev["hbCommands"]==5 then
        HealBot_Action_Reset()
    elseif HealBot_Options_StorePrev["hbCommands"]==6 then
        HealBot_Reset_Buffs()
    elseif HealBot_Options_StorePrev["hbCommands"]==7 then
        HealBot_Reset_Cures()
    elseif HealBot_Options_StorePrev["hbCommands"]==8 then
        HealBot_setResetFlagCode(2)
    elseif HealBot_Options_StorePrev["hbCommands"]==9 then
        HealBot_setResetFlagCode(3)
    elseif HealBot_Options_StorePrev["hbCommands"]==10 then
        HealBot_Reset_Spells()
    elseif HealBot_Options_StorePrev["hbCommands"]==11 then
        HealBot_ToggleAcceptSkins()
    elseif HealBot_Options_StorePrev["hbCommands"]==12 then
        HealBot_ToggleSuppressSetting("error")
    elseif HealBot_Options_StorePrev["hbCommands"]==13 then
        HealBot_ToggleSuppressSetting("sound")
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_EmergencyFClass_List = {
    HEALBOT_CLASSES_MELEE,
    HEALBOT_CLASSES_RANGES,
    HEALBOT_CLASSES_HEALERS,
    HEALBOT_CLASSES_CUSTOM,
}

function HealBot_Options_EmergencyFClass_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_EmergencyFClass_List), 1 do
        info.text = HealBot_Options_EmergencyFClass_List[j];
        info.func = function(self)
                        HealBot_Globals.EmergencyFClass = self:GetID()
                        UIDropDownMenu_SetText(HealBot_Options_EmergencyFClass, HealBot_Options_EmergencyFClass_List[HealBot_Globals.EmergencyFClass])
                        HealBot_Options_EFClass_Reset()
                    end
        info.checked = false;
        if HealBot_Globals.EmergencyFClass==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_EFClass_Reset()
    if HealBot_Globals.EmergencyFClass==1 then
        HealBot_Options_EFClassDruid:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_DRUID]);
        HealBot_Options_EFClassHunter:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_HUNTER]);
        HealBot_Options_EFClassMage:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_MAGE]);
        HealBot_Options_EFClassPaladin:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_PALADIN]);
        HealBot_Options_EFClassPriest:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_PRIEST]);
        HealBot_Options_EFClassRogue:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_ROGUE]);
        HealBot_Options_EFClassShaman:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_SHAMAN]);
        HealBot_Options_EFClassWarlock:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_WARLOCK]);
        HealBot_Options_EFClassWarrior:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_WARRIOR]);
        HealBot_Options_EFClassDeathKnight:SetChecked(HealBot_Globals.EmergIncMelee[HEALBOT_DEATHKNIGHT]);
    elseif HealBot_Globals.EmergencyFClass==2 then
        HealBot_Options_EFClassDruid:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_DRUID]);
        HealBot_Options_EFClassHunter:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_HUNTER]);
        HealBot_Options_EFClassMage:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_MAGE]);
        HealBot_Options_EFClassPaladin:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_PALADIN]);
        HealBot_Options_EFClassPriest:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_PRIEST]);
        HealBot_Options_EFClassRogue:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_ROGUE]);
        HealBot_Options_EFClassShaman:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_SHAMAN]);
        HealBot_Options_EFClassWarlock:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_WARLOCK]);
        HealBot_Options_EFClassWarrior:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_WARRIOR]);
        HealBot_Options_EFClassDeathKnight:SetChecked(HealBot_Globals.EmergIncRange[HEALBOT_DEATHKNIGHT]);
    elseif HealBot_Globals.EmergencyFClass==3 then
        HealBot_Options_EFClassDruid:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_DRUID]);
        HealBot_Options_EFClassHunter:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_HUNTER]);
        HealBot_Options_EFClassMage:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_MAGE]);
        HealBot_Options_EFClassPaladin:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_PALADIN]);
        HealBot_Options_EFClassPriest:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_PRIEST]);
        HealBot_Options_EFClassRogue:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_ROGUE]);
        HealBot_Options_EFClassShaman:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_SHAMAN]);
        HealBot_Options_EFClassWarlock:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_WARLOCK]);
        HealBot_Options_EFClassWarrior:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_WARRIOR]);
        HealBot_Options_EFClassDeathKnight:SetChecked(HealBot_Globals.EmergIncHealers[HEALBOT_DEATHKNIGHT]);
    elseif HealBot_Globals.EmergencyFClass==4 then
        HealBot_Options_EFClassDruid:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_DRUID]);
        HealBot_Options_EFClassHunter:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_HUNTER]);
        HealBot_Options_EFClassMage:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_MAGE]);
        HealBot_Options_EFClassPaladin:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_PALADIN]);
        HealBot_Options_EFClassPriest:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_PRIEST]);
        HealBot_Options_EFClassRogue:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_ROGUE]);
        HealBot_Options_EFClassShaman:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_SHAMAN]);
        HealBot_Options_EFClassWarlock:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_WARLOCK]);
        HealBot_Options_EFClassWarrior:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_WARRIOR]);
        HealBot_Options_EFClassDeathKnight:SetChecked(HealBot_Globals.EmergIncCustom[HEALBOT_DEATHKNIGHT]);
    end
    if Delay_RecalcParty==0 then Delay_RecalcParty=1; end
end

--------------------------------------------------------------------------------

local HealBot_Options_ExtraSort_List = {
    HEALBOT_SORTBY_NAME,
    HEALBOT_SORTBY_CLASS,
    HEALBOT_SORTBY_GROUP,
    HEALBOT_SORTBY_MAXHEALTH,
    HEALBOT_WORDS_NONE,
}

local HealBot_Options_ExtraSubSort_List = {
    HEALBOT_SORTBY_NAME,
    HEALBOT_SORTBY_CLASS,
    HEALBOT_SORTBY_GROUP,
    HEALBOT_SORTBY_MAXHEALTH,
    HEALBOT_SORTBY_ROLE,
    HEALBOT_WORDS_NONE,
}

function HealBot_Options_ExtraSort_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ExtraSort_List), 1 do
        info.text = HealBot_Options_ExtraSort_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.ExtraOrder[Healbot_Config_Skins.Current_Skin] = self:GetID();
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ExtraSort,Healbot_Config_Skins.ExtraOrder[Healbot_Config_Skins.Current_Skin]) 
                        if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
                    end
        info.checked = false;
        if Healbot_Config_Skins.ExtraOrder[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_ExtraSubSort_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ExtraSubSort_List), 1 do
        info.text = HealBot_Options_ExtraSubSort_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.ExtraSubOrder[Healbot_Config_Skins.Current_Skin] = self:GetID();
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ExtraSubSort,Healbot_Config_Skins.ExtraSubOrder[Healbot_Config_Skins.Current_Skin]) 
                        if Delay_RecalcParty<2 then Delay_RecalcParty=2; end
                    end
        info.checked = false;
        if Healbot_Config_Skins.ExtraSubOrder[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_ActionBarsCombo_List = {
    HEALBOT_OPTIONS_ENABLEDBARS,
    HEALBOT_OPTIONS_DISABLEDBARS,
}

HealBot_Options_StorePrev["ActionBarsCombo"] = 1

function HealBot_Options_ActionBarsCombo_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ActionBarsCombo_List), 1 do
        info.text = HealBot_Options_ActionBarsCombo_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["ActionBarsCombo"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ActionBarsCombo,HealBot_Options_StorePrev["ActionBarsCombo"]) 
                        HealBot_Options_ComboClass_Text();
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["ActionBarsCombo"]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_ComboClass_Text()
    local combo=nil
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    if combo then
        HealBot_Options_Click:SetText(combo[button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_Shift:SetText(combo["Shift"..button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_Ctrl:SetText(combo["Ctrl"..button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_Alt:SetText(combo["Alt"..button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_AltShift:SetText(combo["Alt-Shift"..button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_CtrlShift:SetText(combo["Ctrl-Shift"..button..HealBot_Config.CurrentSpec] or "")
        HealBot_Options_CtrlAlt:SetText(combo["Alt-Ctrl"..button..HealBot_Config.CurrentSpec] or "")
    end
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledSpellTarget;
    else
        combo = HealBot_Config.DisabledSpellTarget;
    end
    if combo then
        HealBot_SpellAutoTarget:SetChecked(combo[button..HealBot_Config.CurrentSpec] or 0)
        HealBot_ShiftSpellAutoTarget:SetChecked(combo["Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlSpellAutoTarget:SetChecked(combo["Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltSpellAutoTarget:SetChecked(combo["Alt"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltShiftSpellAutoTarget:SetChecked(combo["Alt-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlShiftSpellAutoTarget:SetChecked(combo["Ctrl-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlAltSpellAutoTarget:SetChecked(combo["Alt-Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
    end
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledSpellTrinket1;
    else
        combo = HealBot_Config.DisabledSpellTrinket1;
    end
    if combo then
        HealBot_SpellAutoTrinket1:SetChecked(combo[button..HealBot_Config.CurrentSpec] or 0)
        HealBot_ShiftSpellAutoTrinket1:SetChecked(combo["Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlSpellAutoTrinket1:SetChecked(combo["Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltSpellAutoTrinket1:SetChecked(combo["Alt"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltShiftSpellAutoTrinket1:SetChecked(combo["Alt-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlShiftSpellAutoTrinket1:SetChecked(combo["Ctrl-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlAltSpellAutoTrinket1:SetChecked(combo["Alt-Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
    end
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledSpellTrinket2;
    else
        combo = HealBot_Config.DisabledSpellTrinket2;
    end
    if combo then
        HealBot_SpellAutoTrinket2:SetChecked(combo[button..HealBot_Config.CurrentSpec] or 0)
        HealBot_ShiftSpellAutoTrinket2:SetChecked(combo["Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlSpellAutoTrinket2:SetChecked(combo["Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltSpellAutoTrinket2:SetChecked(combo["Alt"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_AltShiftSpellAutoTrinket2:SetChecked(combo["Alt-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlShiftSpellAutoTrinket2:SetChecked(combo["Ctrl-Shift"..button..HealBot_Config.CurrentSpec] or 0)
        HealBot_CtrlAltSpellAutoTrinket2:SetChecked(combo["Alt-Ctrl"..button..HealBot_Config.CurrentSpec] or 0)
    end
end

--------------------------------------------------------------------------------

HealBot_Options_StorePrev["HealSpellsComboID"] = 0

function HealBot_Options_SelectHealSpellsCombo_DDlist()
    local HealBot_Options_SelectHealSpellsCombo_List = {
        HEALBOT_BINDING_HEAL,
        HEALBOT_HOLY_NOVA,
        HEALBOT_CIRCLE_OF_HEALING,
        HEALBOT_DESPERATE_PRAYER,
        HEALBOT_CHAIN_HEAL,
        HEALBOT_FLASH_HEAL,
        HEALBOT_FLASH_OF_LIGHT,
        HEALBOT_GREATER_HEAL,
        HEALBOT_HEALING_TOUCH,
        HEALBOT_HEAL,
        HEALBOT_HEALING_WAVE,
        HEALBOT_HEALING_SURGE,
        HEALBOT_LIGHT_OF_DAWN,
        HEALBOT_HOLY_LIGHT,
        HEALBOT_HOLY_RADIANCE,
        HEALBOT_WORD_OF_GLORY,
        HEALBOT_DIVINE_LIGHT,
        HEALBOT_LAY_ON_HANDS,
        HEALBOT_HOLY_SHOCK,
        HEALBOT_LIFEBLOOM,
        HEALBOT_GREATER_HEALING_WAVE,
        HEALBOT_NOURISH,
        HEALBOT_PENANCE,
        HEALBOT_PRAYER_OF_HEALING,
        HEALBOT_PRAYER_OF_MENDING,
        HEALBOT_RIPTIDE,
        HEALBOT_REGROWTH,
        HEALBOT_RENEW,
        HEALBOT_DIVINE_HYMN,
        HEALBOT_HEALING_RAIN,
        HEALBOT_REJUVENATION,
        HEALBOT_WILD_GROWTH,
        HEALBOT_SWIFTMEND,
        HEALBOT_TRANQUILITY,
        HEALBOT_GIFT_OF_THE_NAARU,
        HEALBOT_MENDPET,
        HEALBOT_HEALTH_FUNNEL,
        HEALBOT_HOLY_WORD_SERENITY,
        HEALBOT_SOOTHING_MIST,
        HEALBOT_ZEN_MEDITATION,
        HEALBOT_LIFE_COCOON,
        HEALBOT_ENVELOPING_MIST,
        HEALBOT_REVIVAL,
        HEALBOT_RENEWING_MIST,
        HEALBOT_UPLIFT,
        HEALBOT_SURGING_MIST,
        HEALBOT_CHI_WAVE,
        HEALBOT_ZEN_SPHERE,
        HEALBOT_CHI_BURST,
        HEALBOT_ETERNAL_FLAME,
        HEALBOT_HOLY_PRISM,
        HEALBOT_EXECUTION_SENTENCE,
        HEALBOT_CASCADE,
        HEALBOT_CENARION_WARD,
    }
    local tmpHealDDlist={}
    for j=1, getn(HealBot_Options_SelectHealSpellsCombo_List), 1 do
        if HealBot_GetSpellId(HealBot_Options_SelectHealSpellsCombo_List[j]) then
            table.insert(tmpHealDDlist, HealBot_Options_SelectHealSpellsCombo_List[j])
        end
    end
    table.sort(tmpHealDDlist)
    return tmpHealDDlist
end

local function HealBot_Options_SelectHealSpellsCombo_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local hbHealDDlist=HealBot_Options_SelectHealSpellsCombo_DDlist()
    if getn(hbHealDDlist)>0 then
        for j=1, getn(hbHealDDlist), 1 do
            info.text = hbHealDDlist[j];
            info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpHealSelect"] = self:GetText()
                        HealBot_Options_StorePrev["HealSpellsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectHealSpellsCombo,HealBot_Options_StorePrev["HealSpellsComboID"]) 
                    end
            info.checked = false;
            if HealBot_Options_StorePrev["HealSpellsComboID"]==j then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
    else
        info.text = HEALBOT_TOOLTIP_NONE
        info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpHealSelect"] = nil
                        HealBot_Options_StorePrev["HealSpellsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectHealSpellsCombo,1) 
                    end
        info.checked = true;
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

HealBot_Options_StorePrev["OtherSpellsComboID"] = 0

local function HealBot_Options_SelectOtherSpellsCombo_DDlist()
    local HealBot_Options_SelectOtherSpellsCombo_List = {
        HEALBOT_STONEFORM,
        HEALBOT_POWER_WORD_SHIELD,
        HEALBOT_REVIVE,
        HEALBOT_GUARDIAN_SPIRIT,
        HEALBOT_INTERVENE,
        HEALBOT_RESURRECTION,
        HEALBOT_REDEMPTION,
        HEALBOT_REBIRTH,
        HEALBOT_INNERVATE,
        HEALBOT_TREE_OF_LIFE,
        HEALBOT_ANCESTRALSPIRIT,
        HEALBOT_RESUSCITATE,
        HEALBOT_CLEANSE,
        HEALBOT_REMOVE_CURSE,
        HEALBOT_REMOVE_CORRUPTION,
        HEALBOT_NATURES_CURE,
        HEALBOT_PURIFY,
        HEALBOT_PURIFY_SPIRIT,
        HEALBOT_CLEANSE_SPIRIT,
        HEALBOT_LIFE_TAP,
        HEALBOT_DIVINE_SHIELD,
        HEALBOT_DIVINE_PROTECTION,
        HEALBOT_RIGHTEOUS_DEFENSE,
        HEALBOT_NATURE_SWIFTNESS,
        HEALBOT_INNER_FOCUS,
        HEALBOT_LEAP_OF_FAITH,
        HEALBOT_UNLEASH_ELEMENTS,
        HEALBOT_DETOX,
        HEALBOT_SPEED_OF_LIGHT,
        HEALBOT_SACRED_SHIELD,
        HEALBOT_HAND_OF_PURITY,
        HEALBOT_THUNDER_FOCUS_TEA,
    }
    local tmpOtherDDlist={}
    for j=1, getn(HealBot_Options_SelectOtherSpellsCombo_List), 1 do
        if HealBot_GetSpellId(HealBot_Options_SelectOtherSpellsCombo_List[j]) then
            table.insert(tmpOtherDDlist,HealBot_Options_SelectOtherSpellsCombo_List[j])
        end
    end
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        table.insert(tmpOtherDDlist,HealBot_Buff_Spells_List[j])
    end
    table.sort(tmpOtherDDlist)
    return tmpOtherDDlist
end

function HealBot_Options_SelectOtherSpellsCombo_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local hbOtherDDlist=HealBot_Options_SelectOtherSpellsCombo_DDlist()
    if getn(hbOtherDDlist)>0 then
        for j=1, getn(hbOtherDDlist), 1 do
            info.text = hbOtherDDlist[j];
            info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpOtherSelect"] = self:GetText()
                        HealBot_Options_StorePrev["OtherSpellsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectOtherSpellsCombo,HealBot_Options_StorePrev["OtherSpellsComboID"]) 
                    end
            info.checked = false;
            if HealBot_Options_StorePrev["OtherSpellsComboID"]==j then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
    else
        info.text = HEALBOT_TOOLTIP_NONE
        info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpOtherSelect"] = nil
                        HealBot_Options_StorePrev["OtherSpellsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectOtherSpellsCombo,1) 
                    end
        info.checked = true;
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

HealBot_Options_StorePrev["MacrosComboID"] = 0

function HealBot_Options_SelectMacrosCombo_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local numglobal,numperchar = GetNumMacros();
    local totalMacros=numglobal+numperchar
    local hbMacroName=nil
    if totalMacros>0 then
        for j=1, numglobal, 1 do
            hbMacroName=GetMacroInfo(j)
            if hbMacroName then
                info.text = hbMacroName
                info.func = function(self)
                                HealBot_Options_StorePrev["hbHelpMacroSelect"] = self:GetText()
                                HealBot_Options_StorePrev["MacrosComboID"] = self:GetID()
                                UIDropDownMenu_SetSelectedID(HealBot_Options_SelectMacrosCombo,HealBot_Options_StorePrev["MacrosComboID"]) 
                            end
                info.checked = false;
                if HealBot_Options_StorePrev["MacrosComboID"]==j then info.checked = true end
                UIDropDownMenu_AddButton(info);
            end
        end
        for j=37, numperchar+36, 1 do
            hbMacroName=GetMacroInfo(j)
            if hbMacroName and strsub(hbMacroName,1,strlen(HealBot_Config.CrashProtMacroName))~=HealBot_Config.CrashProtMacroName then
                info.text = hbMacroName
                info.func = function(self)
                                HealBot_Options_StorePrev["hbHelpMacroSelect"] = self:GetText()
                                HealBot_Options_StorePrev["MacrosComboID"] = self:GetID()
                                UIDropDownMenu_SetSelectedID(HealBot_Options_SelectMacrosCombo,HealBot_Options_StorePrev["MacrosComboID"]) 
                            end
                info.checked = false;
                if HealBot_Options_StorePrev["MacrosComboID"]==j then info.checked = true end
                UIDropDownMenu_AddButton(info);
            end
        end
    else
        info.text = HEALBOT_TOOLTIP_NONE
        info.func = function(self)
                        HealBot_Options_StorePrev["MacrosComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ManaIndicator,HealBot_Options_StorePrev["MacrosComboID"]) 
                    end
        info.checked = true;
        UIDropDownMenu_AddButton(info);
        HealBot_Options_StorePrev["hbHelpMacroSelect"]=nil
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_itemsByLevel()
    local hbLevel = UnitLevel("player")
    local hbItemsByLevel={}
    local hbTmpText1=nil
    if hbLevel <= 20 then
        hbTmpText1 = GetItemInfo(19004) or "Minor Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 30 then
        hbTmpText1 = GetItemInfo(19007) or "Lesser Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 40 then
        hbTmpText1 = GetItemInfo(19009) or "Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 50 then
        hbTmpText1 = GetItemInfo(19011) or "Greater Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 60 then
        hbTmpText1 = GetItemInfo(9421) or "Major Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 70 then
        hbTmpText1 = GetItemInfo(19008) or "Master Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    elseif hbLevel <= 75 then
        hbTmpText1 = GetItemInfo(36892) or "Fel Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    else
        hbTmpText1 = GetItemInfo(36892) or "Fel Healthstone"
        table.insert(hbItemsByLevel,hbTmpText1)
    end
    return hbItemsByLevel
end
    
HealBot_Options_StorePrev["ItemsComboID"]=0

function HealBot_Options_SelectItemsCombo_DropDown()
    local hbItemsIfExists = {
        [1] = HEALBOT_SILK_BANDAGE,
        [2] = HEALBOT_HEAVY_SILK_BANDAGE,
        [3] = HEALBOT_MAGEWEAVE_BANDAGE,
        [4] = HEALBOT_HEAVY_MAGEWEAVE_BANDAGE,
        [5] = HEALBOT_RUNECLOTH_BANDAGE,
        [6] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
        [7] = HEALBOT_NETHERWEAVE_BANDAGE,
        [8] = HEALBOT_HEAVY_NETHERWEAVE_BANDAGE,
        [9] = HEALBOT_FROSTWEAVE_BANDAGE,
        [10] = HEALBOT_HEAVY_FROSTWEAVE_BANDAGE,
        [11] = HEALBOT_EMBERSILK_BANDAGE,
        [12] = HEALBOT_DENSE_EMBERSILK_BANDAGE,
        [13] = HEALBOT_MAJOR_HEALING_POTION,
        [14] = HEALBOT_SUPER_HEALING_POTION,
        [15] = HEALBOT_MAJOR_COMBAT_HEALING_POTION,
        [16] = HEALBOT_RUNIC_HEALING_POTION,
        [17] = HEALBOT_ENDLESS_HEALING_POTION,    
        [18] = HEALBOT_MAJOR_MANA_POTION,
        [19] = HEALBOT_SUPER_MANA_POTION,
        [20] = HEALBOT_MAJOR_COMBAT_MANA_POTION,
        [21] = HEALBOT_RUNIC_MANA_POTION,
        [22] = HEALBOT_ENDLESS_MANA_POTION,
        [23] = HEALBOT_PURIFICATION_POTION,
        [24] = HEALBOT_ANTI_VENOM,
        [25] = HEALBOT_POWERFUL_ANTI_VENOM,
        [26] = HEALBOT_ELIXIR_OF_POISON_RES,
        }
    local info = UIDropDownMenu_CreateInfo()
    local HealBot_Options_SelectItemsCombo_List=HealBot_Options_itemsByLevel(hbLevel)
    for j=1, getn(hbItemsIfExists), 1 do
        if IsUsableItem(hbItemsIfExists[j]) then
            table.insert(HealBot_Options_SelectItemsCombo_List, hbItemsIfExists[j])
        end
    end
    table.sort(HealBot_Options_SelectItemsCombo_List)
    for j=1, getn(HealBot_Options_SelectItemsCombo_List), 1 do
        info.text = HealBot_Options_SelectItemsCombo_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpItemSelect"] = self:GetText()
                        HealBot_Options_StorePrev["ItemsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectItemsCombo,HealBot_Options_StorePrev["ItemsComboID"]) 
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["ItemsComboID"]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

HealBot_Options_StorePrev["CmdsComboID"]=0

function HealBot_Options_SelectCmdsCombo_DropDown()
    local HealBot_Options_SelectCmdsCombo_List = {
        HEALBOT_DISABLED_TARGET,
        HEALBOT_ASSIST,
        HEALBOT_FOCUS,
        HEALBOT_MENU,
        HEALBOT_HBMENU,
        HEALBOT_MAINTANK,
        HEALBOT_MAINASSIST,
        HEALBOT_STOP,
        HEALBOT_TELL.." ...",
    }
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_SelectCmdsCombo_List), 1 do
        info.text = HealBot_Options_SelectCmdsCombo_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["hbHelpCmdsSelect"] = self:GetText()
                        HealBot_Options_StorePrev["CmdsComboID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SelectCmdsCombo,HealBot_Options_StorePrev["CmdsComboID"]) 
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["CmdsComboID"]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_SpellsSelect_OnClick(self, sType)
    if sType~="Cancel" then
        local hbTmpText1=nil
        if sType=="Heal" then
            hbTmpText1=HealBot_Options_StorePrev["hbHelpHealSelect"] or ""
        elseif sType=="Other" then
            hbTmpText1=HealBot_Options_StorePrev["hbHelpOtherSelect"] or ""
        elseif sType=="Macro" then
            hbTmpText1=HealBot_Options_StorePrev["hbHelpMacroSelect"] or ""
        elseif sType=="Item" then
            hbTmpText1=HealBot_Options_StorePrev["hbHelpItemSelect"] or ""
        else
            hbTmpText1=HealBot_Options_StorePrev["hbHelpCmdsSelect"] or ""
        end
        if hbTmpText1~=HEALBOT_TOOLTIP_NONE then
            if HealBot_Options_StorePrev["HealBot_Options_sLoc"]=="Click" then
                HealBot_Options_Click:SetText(hbTmpText1)
            elseif HealBot_Options_StorePrev["HealBot_Options_sLoc"]=="Shift" then
                HealBot_Options_Shift:SetText(hbTmpText1)
            elseif HealBot_Options_StorePrev["HealBot_Options_sLoc"]=="Ctrl" then
                HealBot_Options_Ctrl:SetText(hbTmpText1)
            elseif HealBot_Options_StorePrev["HealBot_Options_sLoc"]=="Alt" then
                HealBot_Options_Alt:SetText(hbTmpText1)
            elseif HealBot_Options_StorePrev["HealBot_Options_sLoc"]=="CtrlShift" then
                HealBot_Options_CtrlShift:SetText(hbTmpText1)
            elseif HealBot_Options_StorePrev["HealBot_Options_sLoc"]== "AltShift" then
                HealBot_Options_AltShift:SetText(hbTmpText1)
            else -- "AltCtrl"
                HealBot_Options_CtrlAlt:SetText(hbTmpText1)
            end
        end
    end
    HealBot_Options_SelectSpellsFrame:Hide()
    HealBot_Options_KeysFrame:Show()
end

function HealBot_Options_HelpSpellsSelect_OnClick(self, sLoc)
    HealBot_Options_Init(10)
    HealBot_Options_StorePrev["HealBot_Options_sLoc"]=sLoc
    local hbOptionText=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        hbOptionText=HEALBOT_OPTIONS_SETSPELLS.." "..HEALBOT_OPTIONS_ENABLEDBARS
    else
        hbOptionText=HEALBOT_OPTIONS_SETSPELLS.." "..HEALBOT_OPTIONS_DISABLEDBARS
    end
    HealBot_Options_SelectSpellsFrame_TextH1:SetText(hbOptionText)
    local hbTmpText1=HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button).." "..HEALBOT_OPTIONS_CLICK
    if sLoc=="Click" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..hbTmpText1
    elseif sLoc=="Shift" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_SHIFT.."+"..hbTmpText1
    elseif sLoc=="Ctrl" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_CTRL.."+"..hbTmpText1
    elseif sLoc=="Alt" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_ALT.."+"..hbTmpText1
    elseif sLoc=="CtrlShift" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_CTRL.."+"..HEALBOT_OPTIONS_SHIFT.."+"..hbTmpText1
    elseif sLoc=="AltShift" then
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_ALT.."+"..HEALBOT_OPTIONS_SHIFT.."+"..hbTmpText1
    else -- "AltCtrl"
        hbOptionText=HEALBOT_OPTIONS_COMBOCLASS..":  "..HEALBOT_OPTIONS_CTRL.."+"..HEALBOT_OPTIONS_ALT.."+"..hbTmpText1
    end
    HealBot_Options_SelectSpellsFrame_TextH2:SetText(hbOptionText)
    HealBot_Options_KeysFrame:Hide()
    HealBot_Options_SelectSpellsFrame:Show()
end

--------------------------------------------------------------------------------

local HealBot_Options_ActionAnchor_List = {
    HEALBOT_OPTIONS_TOPLEFT,
    HEALBOT_OPTIONS_BOTTOMLEFT,
    HEALBOT_OPTIONS_TOPRIGHT,
    HEALBOT_OPTIONS_BOTTOMRIGHT,
    HEALBOT_OPTIONS_TOP,
    HEALBOT_OPTIONS_BUTTONLEFT,
    HEALBOT_OPTIONS_BUTTONRIGHT,
    HEALBOT_OPTIONS_BOTTOM,
}

function HealBot_Options_ActionAnchor_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ActionAnchor_List), 1 do
        info.text = HealBot_Options_ActionAnchor_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.Panel_Anchor[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ActionAnchor,Healbot_Config_Skins.Panel_Anchor[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_CheckActionFrame()
                        HealBot_Panel_ClearBarArrays()
                    end
        info.checked = false;
        if Healbot_Config_Skins.Panel_Anchor[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_ActionBarsAnchor_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 4, 1 do
        info.text = HealBot_Options_ActionAnchor_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.Bars_Anchor[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ActionBarsAnchor,Healbot_Config_Skins.Bars_Anchor[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_CheckActionFrame()
                        HealBot_Panel_ClearBarArrays()
                    end
        info.checked = false;
        if Healbot_Config_Skins.Bars_Anchor[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_ManaIndicator_List = {
    HEALBOT_OPTIONS_LOWMANAINDICATOR1,
    HEALBOT_OPTIONS_LOWMANAINDICATOR2,
    HEALBOT_OPTIONS_LOWMANAINDICATOR3,
    HEALBOT_OPTIONS_LOWMANAINDICATOR4,
    HEALBOT_OPTIONS_LOWMANAINDICATOR5,
    HEALBOT_OPTIONS_LOWMANAINDICATOR6,
}

local function HealBot_Options_ManaIndicator_DropDown(dropDown, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_ManaIndicator_List), 1 do
        info.text = HealBot_Options_ManaIndicator_List[j];
     --   info.func = HealBot_Options_ManaIndicator_OnSelect;
        info.func = function(self)
                        Healbot_Config_Skins.LowManaInd[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_ManaIndicator,Healbot_Config_Skins.LowManaInd[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(4910)
                    end
        info.checked = false;
        if Healbot_Config_Skins.LowManaInd[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_FilterHoTctl_List = {
    HEALBOT_DEATHKNIGHT,
    HEALBOT_DRUID,
    HEALBOT_PALADIN,
    HEALBOT_MONK,
    HEALBOT_PRIEST,
    HEALBOT_SHAMAN,
    HEALBOT_WARRIOR,
    HEALBOT_HUNTER,
    HEALBOT_MAGE,
    HEALBOT_ROGUE,
    HEALBOT_WARLOCK,
}

HealBot_Options_StorePrev["FilterHoTctlName"]=HealBot_Options_FilterHoTctl_List[1]
HealBot_Options_StorePrev["FilterHoTctlNameTrim"]=HealBot_Class_En[HealBot_Options_StorePrev["FilterHoTctlName"]]

function HealBot_Options_Class_HoTctlName_genList()
    local HealBot_Options_Class_HoTctlName_List = {
        [HEALBOT_GIFT_OF_THE_NAARU]="ALL",
        [HEALBOT_LIFEBLOOM]=HEALBOT_DRUID,
        [HEALBOT_MENDPET]=HEALBOT_HUNTER,
        [HEALBOT_PRAYER_OF_MENDING]=HEALBOT_PRIEST,
        [HEALBOT_REGROWTH]=HEALBOT_DRUID,
        [HEALBOT_REJUVENATION]=HEALBOT_DRUID,
        [HEALBOT_LIVING_SEED]=HEALBOT_DRUID,
        [HEALBOT_CENARION_WARD]=HEALBOT_DRUID,
        [HEALBOT_RENEW]=HEALBOT_PRIEST,
        [HEALBOT_DIVINE_HYMN]=HEALBOT_PRIEST,
        [HEALBOT_HEALING_RAIN]=HEALBOT_SHAMAN,
        [HEALBOT_INNER_FOCUS]=HEALBOT_PRIEST,
        [HEALBOT_SERENDIPITY]=HEALBOT_PRIEST,
        [HEALBOT_RIPTIDE]=HEALBOT_SHAMAN,
        [HEALBOT_TRANQUILITY]=HEALBOT_DRUID,
        [HEALBOT_WILD_GROWTH]=HEALBOT_DRUID,
        [HEALBOT_GUARDIAN_SPIRIT]=HEALBOT_PRIEST,
        [HEALBOT_FEAR_WARD]=HEALBOT_PRIEST,
        [HEALBOT_BLESSED_HEALING]=HEALBOT_PRIEST,
        [HEALBOT_HAND_OF_SALVATION]=HEALBOT_PALADIN,
        [HEALBOT_DIVINE_SHIELD]=HEALBOT_PALADIN,
        [HEALBOT_HAND_OF_SACRIFICE]=HEALBOT_PALADIN,
        [HEALBOT_INFUSION_OF_LIGHT]=HEALBOT_PALADIN,
        [HEALBOT_SPEED_OF_LIGHT]=HEALBOT_PALADIN,
        [HEALBOT_DAY_BREAK]=HEALBOT_PALADIN,
        [HEALBOT_SACRED_SHIELD]=HEALBOT_PALADIN,
        [HEALBOT_HAND_OF_PURITY]=HEALBOT_PALADIN,
        [HEALBOT_DIVINE_PURPOSE]=HEALBOT_PALADIN,
        [HEALBOT_ETERNAL_FLAME]=HEALBOT_PALADIN,
        [HEALBOT_INNER_FIRE]=HEALBOT_PRIEST,
        [HEALBOT_INNER_WILL]=HEALBOT_PRIEST,
        [HEALBOT_HOLY_SHIELD]=HEALBOT_PALADIN,
        [HEALBOT_ILLUMINATED_HEALING]=HEALBOT_PALADIN,
        [HEALBOT_ARDENT_DEFENDER]=HEALBOT_PALADIN,
        [HEALBOT_DENOUNCE]=HEALBOT_PALADIN,
        [HEALBOT_PAIN_SUPPRESSION]=HEALBOT_PRIEST,
        [HEALBOT_POWER_INFUSION]=HEALBOT_PRIEST,
        [HEALBOT_POWER_WORD_SHIELD]=HEALBOT_PRIEST,
        [HEALBOT_POWER_WORD_BARRIER]=HEALBOT_PRIEST,
        [HEALBOT_EVANGELISM]=HEALBOT_PRIEST,
        [HEALBOT_ARCHANGEL]=HEALBOT_PRIEST,
        [HEALBOT_SPIRITSHELL]=HEALBOT_PRIEST,
        [HEALBOT_DIVINE_INSIGHT]=HEALBOT_PRIEST,
        [HEALBOT_VIGILANCE]=HEALBOT_WARRIOR,
        [HEALBOT_BEACON_OF_LIGHT]=HEALBOT_PALADIN,
        [HEALBOT_HANDOFPROTECTION]=HEALBOT_PALADIN,
        [HEALBOT_FLASH_OF_LIGHT]=HEALBOT_PALADIN,
        [HEALBOT_LIGHT_BEACON]=HEALBOT_PALADIN,
        [HEALBOT_GUARDED_BY_THE_LIGHT]=HEALBOT_PALADIN,
        [HEALBOT_GUARDIAN_ANCIENT_KINGS]=HEALBOT_PALADIN,
        [HEALBOT_WORD_OF_GLORY]=HEALBOT_PALADIN,
        [HEALBOT_HAND_OF_FREEDOM]=HEALBOT_PALADIN,
        [HEALBOT_DIVINE_AEGIS]=HEALBOT_PRIEST,
        [HEALBOT_ECHO_OF_LIGHT]=HEALBOT_PRIEST,
        [HEALBOT_GRACE]=HEALBOT_PRIEST,
        [HEALBOT_LEVITATE]=HEALBOT_PRIEST,
        [HEALBOT_LIGHTWELL_RENEW]=HEALBOT_PRIEST,
        [HEALBOT_PROTANCIENTKINGS]="ALL",
        [HEALBOT_EARTHLIVING_WEAPON]=HEALBOT_SHAMAN,
        [HEALBOT_EARTH_SHIELD]=HEALBOT_SHAMAN,
        [HEALBOT_LIGHTNING_SHIELD]=HEALBOT_SHAMAN,
        [HEALBOT_WATER_SHIELD]=HEALBOT_SHAMAN,
        [HEALBOT_LAST_STAND]=HEALBOT_WARRIOR,
        [HEALBOT_SHIELD_WALL]=HEALBOT_WARRIOR,
        [HEALBOT_SHIELD_BLOCK]=HEALBOT_WARRIOR,
        [HEALBOT_ENRAGED_REGEN]=HEALBOT_WARRIOR,
        [HEALBOT_DIVINE_PROTECTION]=HEALBOT_PALADIN,
        [HEALBOT_BARKSKIN]=HEALBOT_DRUID,
        [HEALBOT_IRONBARK]=HEALBOT_DRUID,
        [HEALBOT_HARMONY]=HEALBOT_DRUID,
        [HEALBOT_SURVIVAL_INSTINCTS]=HEALBOT_DRUID,
        [HEALBOT_FRENZIED_REGEN]=HEALBOT_DRUID,
        [HEALBOT_NATURE_SWIFTNESS]=HEALBOT_DRUID,
        [HEALBOT_ICEBOUND_FORTITUDE]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_ANTIMAGIC_SHELL]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_ARMY_OF_THE_DEAD]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_LICHBORNE]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_ANTIMAGIC_ZONE]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_VAMPIRIC_BLOOD]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_BONE_SHIELD]=HEALBOT_DEATHKNIGHT,
        [HEALBOT_NATURES_GRASP]=HEALBOT_DRUID,
        [HEALBOT_DRUID_CLEARCASTING]=HEALBOT_DRUID,
        [HEALBOT_CHAINHEALHOT]=HEALBOT_SHAMAN,
        [HEALBOT_EARTHLIVING]=HEALBOT_SHAMAN,
        [HEALBOT_TIDAL_WAVES]=HEALBOT_SHAMAN,
        [HEALBOT_DARK_INTENT]=HEALBOT_WARLOCK,
        [HEALBOT_ENVELOPING_MIST]=HEALBOT_MONK,
        [HEALBOT_ZEN_SPHERE]=HEALBOT_MONK,
        [HEALBOT_LIFE_COCOON]=HEALBOT_MONK,
        [HEALBOT_THUNDER_FOCUS_TEA]=HEALBOT_MONK,
        [HEALBOT_SERPENT_ZEAL]=HEALBOT_MONK,
        [HEALBOT_MANA_TEA]=HEALBOT_MONK,
        [HEALBOT_ZEN_MEDITATION]=HEALBOT_MONK,
        [HEALBOT_SOOTHING_MIST]=HEALBOT_MONK,
        [HEALBOT_RENEWING_MIST]=HEALBOT_MONK,
    }
    local class=nil
    local tmpHoTctlName_List={}
    for x,_ in pairs(tmpHoTctlName_List) do
        tmpHoTctlName_List[x]=nil;
    end
    for bName,class in pairs(HealBot_Options_Class_HoTctlName_List) do
        if class=="ALL" or HealBot_Options_StorePrev["FilterHoTctlName"]==class then
            table.insert(tmpHoTctlName_List, bName)
        elseif bName==HEALBOT_NATURE_SWIFTNESS and HealBot_Options_StorePrev["FilterHoTctlName"]==HEALBOT_SHAMAN then  -- patch in the Shaman
            table.insert(tmpHoTctlName_List, bName)
        end
    end
    table.sort(tmpHoTctlName_List)
    x=nil
    for j=1, getn(tmpHoTctlName_List), 1 do
        if tmpHoTctlName_List[j]==HealBot_Globals.HoTname then
            HealBot_Globals.HoTindex=j
            x=true
            do break end
        end
    end
    if not x then HealBot_Globals.HoTindex=1 end
    HealBot_Globals.HoTname=tmpHoTctlName_List[HealBot_Globals.HoTindex]
    return tmpHoTctlName_List
end

function HealBot_Options_Class_HoTctlName_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local HoTctlName_List = HealBot_Options_Class_HoTctlName_genList()
    for j=1, getn(HoTctlName_List), 1 do
        info.text = HoTctlName_List[j];
        info.func = function(self)
                        HealBot_Globals.HoTindex = self:GetID()
                        HealBot_Globals.HoTname = self:GetText()
                        UIDropDownMenu_SetText(HealBot_Options_Class_HoTctlName, HealBot_Globals.HoTname)
                        DoneInitTab[316]=nil
                        HealBot_Options_InitSub(316)
                    end
        info.checked = false;
        if HealBot_Globals.HoTname==HoTctlName_List[j] then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_Class_HoTctlAction_List = {
    HEALBOT_WORD_NEVER,
    HEALBOT_OPTIONS_SELFCASTS,
    HEALBOT_WORD_ALWAYS,
}

function HealBot_Options_Class_HoTctlAction_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_Class_HoTctlAction_List), 1 do
        info.text = HealBot_Options_Class_HoTctlAction_List[j];
        info.func = function(self)
                        local y=self:GetID()
                        if y>1 then HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]][HealBot_Globals.HoTname]=y end
                        UIDropDownMenu_SetSelectedID(HealBot_Options_Class_HoTctlAction,y) 
                        HealBot_setOptions_Timer(170)
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["FilterHoTctlNameTrim"] and HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]] then
            local x=HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]][HealBot_Globals.HoTname] or 1
            if x==j then info.checked = true; end 
        end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_FilterHoTctl_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    table.sort(HealBot_Options_FilterHoTctl_List)
    for j=1, getn(HealBot_Options_FilterHoTctl_List), 1 do
        info.text = HealBot_Options_FilterHoTctl_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["FilterHoTctlName"]=self.value
                        HealBot_Options_StorePrev["FilterHoTctlNameTrim"]=HealBot_Class_En[HealBot_Options_StorePrev["FilterHoTctlName"]]
                        UIDropDownMenu_SetSelectedID(HealBot_Options_FilterHoTctl,self:GetID()) 
                        DoneInitTab[315]=nil
                        HealBot_Options_InitSub(315)
                        DoneInitTab[316]=nil
                        HealBot_Options_InitSub(316)
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["FilterHoTctlName"]==HealBot_Options_FilterHoTctl_List[j] then info.checked = true; end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_SkinDefault_List = {
    HEALBOT_WORDS_NONE,
    HEALBOT_WORD_SOLO,
    HEALBOT_WORD_PARTY,
    HEALBOT_OPTIONS_EMERGENCYHEALS.." 10",
    HEALBOT_OPTIONS_EMERGENCYHEALS.." 25",
    HEALBOT_OPTIONS_EMERGENCYHEALS.." 40",
    HEALBOT_WORD_ARENA,
    HEALBOT_WORD_BATTLEGROUND.." 10",
    HEALBOT_WORD_BATTLEGROUND.." 15",
    HEALBOT_WORD_BATTLEGROUND.." 40",
}

HealBot_Options_StorePrev["hbSkinDefaultID"]=1

function HealBot_Options_SkinPartyRaidDefault_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_SkinDefault_List), 1 do
        info.text = HealBot_Options_SkinDefault_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["hbSkinDefaultID"] = self:GetID()
                        if HealBot_Options_StorePrev["hbSkinDefaultID"]>1 then
                            for x in pairs (Healbot_Config_Skins.Skins) do
                                if HealBot_Config.SkinDefault[Healbot_Config_Skins.Skins[x]]==HealBot_Options_StorePrev["hbSkinDefaultID"] then HealBot_Config.SkinDefault[Healbot_Config_Skins.Skins[x]]=1 end
                            end
                        end
                        HealBot_Config.SkinDefault[Healbot_Config_Skins.Current_Skin]=HealBot_Options_StorePrev["hbSkinDefaultID"]
                        UIDropDownMenu_SetSelectedID(HealBot_Options_SkinPartyRaidDefault,HealBot_Options_StorePrev["hbSkinDefaultID"]) 
                    end
        info.checked = false;
        if HealBot_Config.SkinDefault[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_AggroAlertLevel_List = {
   -- HEALBOT_OPTIONS_ALERTAGGROLEVEL1,
    HEALBOT_OPTIONS_ALERTAGGROLEVEL2,
    HEALBOT_OPTIONS_ALERTAGGROLEVEL3,
}

function HealBot_Options_AggroAlertLevel_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_AggroAlertLevel_List), 1 do
        info.text = HealBot_Options_AggroAlertLevel_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]=self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_AggroAlertLevel,Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]) 
                    end
        info.checked = false;
        if Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local HealBot_Options_AggroIndAlertLevel_List = {
    HEALBOT_OPTIONS_ALERTAGGROLEVEL1,
    HEALBOT_OPTIONS_ALERTAGGROLEVEL2,
    HEALBOT_OPTIONS_ALERTAGGROLEVEL3,
}

function HealBot_Options_AggroIndAlertLevel_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_AggroIndAlertLevel_List), 1 do
        info.text = HealBot_Options_AggroIndAlertLevel_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin]=self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_AggroIndAlertLevel,Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin]) 
                    end
        info.checked = false;
        if Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_EmergencyFilter_List = {
    HEALBOT_CLASSES_ALL,
    HEALBOT_DEATHKNIGHT,
    HEALBOT_DRUID,
    HEALBOT_HUNTER,
    HEALBOT_MAGE,
    HEALBOT_MONK,
    HEALBOT_PALADIN,
    HEALBOT_PRIEST,
    HEALBOT_ROGUE,
    HEALBOT_SHAMAN,
    HEALBOT_WARLOCK,
    HEALBOT_WARRIOR,
    HEALBOT_CLASSES_MELEE,
    HEALBOT_CLASSES_RANGES,
    HEALBOT_CLASSES_HEALERS,
    HEALBOT_CLASSES_CUSTOM,
}

function HealBot_Options_EmergencyFilter_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_EmergencyFilter_List), 1 do
        info.text = HealBot_Options_EmergencyFilter_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_EmergencyFilter,Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]) 
                        HealBot_setOptions_Timer(60)
                    end
        info.checked = false;
        if Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_EmergencyFilter_Reset()
  
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 0;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = 0;
    if Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==1 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 1;
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==2 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==3 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==4 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==5 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==6 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MONK]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==7 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==8 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==9 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==10 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==11 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==12 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 1;
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==13 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Globals.EmergIncMelee[HEALBOT_DRUID];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Globals.EmergIncMelee[HEALBOT_HUNTER];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Globals.EmergIncMelee[HEALBOT_MAGE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Globals.EmergIncMelee[HEALBOT_PALADIN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Globals.EmergIncMelee[HEALBOT_PRIEST];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Globals.EmergIncMelee[HEALBOT_ROGUE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Globals.EmergIncMelee[HEALBOT_SHAMAN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Globals.EmergIncMelee[HEALBOT_WARLOCK];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Globals.EmergIncMelee[HEALBOT_WARRIOR];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = HealBot_Globals.EmergIncMelee[HEALBOT_DEATHKNIGHT];
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==14 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Globals.EmergIncRange[HEALBOT_DRUID];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Globals.EmergIncRange[HEALBOT_HUNTER];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Globals.EmergIncRange[HEALBOT_MAGE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Globals.EmergIncRange[HEALBOT_PALADIN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Globals.EmergIncRange[HEALBOT_PRIEST];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Globals.EmergIncRange[HEALBOT_ROGUE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Globals.EmergIncRange[HEALBOT_SHAMAN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Globals.EmergIncRange[HEALBOT_WARLOCK];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Globals.EmergIncRange[HEALBOT_WARRIOR];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = HealBot_Globals.EmergIncRange[HEALBOT_DEATHKNIGHT];
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==15 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Globals.EmergIncHealers[HEALBOT_DRUID];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Globals.EmergIncHealers[HEALBOT_HUNTER];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Globals.EmergIncHealers[HEALBOT_MAGE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Globals.EmergIncHealers[HEALBOT_PALADIN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Globals.EmergIncHealers[HEALBOT_PRIEST];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Globals.EmergIncHealers[HEALBOT_ROGUE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Globals.EmergIncHealers[HEALBOT_SHAMAN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Globals.EmergIncHealers[HEALBOT_WARLOCK];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Globals.EmergIncHealers[HEALBOT_WARRIOR];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = HealBot_Globals.EmergIncHealers[HEALBOT_DEATHKNIGHT];
    elseif Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]==16 then
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Globals.EmergIncCustom[HEALBOT_DRUID];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Globals.EmergIncCustom[HEALBOT_HUNTER];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Globals.EmergIncCustom[HEALBOT_MAGE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Globals.EmergIncCustom[HEALBOT_PALADIN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Globals.EmergIncCustom[HEALBOT_PRIEST];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Globals.EmergIncCustom[HEALBOT_ROGUE];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Globals.EmergIncCustom[HEALBOT_SHAMAN];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Globals.EmergIncCustom[HEALBOT_WARLOCK];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Globals.EmergIncCustom[HEALBOT_WARRIOR];
        HealBot_EmergInc[HealBot_Class_En[HEALBOT_DEATHKNIGHT]] = HealBot_Globals.EmergIncCustom[HEALBOT_DEATHKNIGHT];
    end

    if Delay_RecalcParty==0 then 
        Delay_RecalcParty=1; 
    end
end

--------------------------------------------------------------------------------

function HealBot_Options_Skins_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Skins), 1 do
        info.text = HealBot_Skins[j];
        info.func = function(self)
                        Healbot_Config_Skins.Skin_ID = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_Skins,Healbot_Config_Skins.Skin_ID)
                        if self:GetID()>=1 then HealBot_Options_Set_Current_Skin(self:GetText(), "n") end
                    end
        info.checked = false;
        if Healbot_Config_Skins.Skin_ID==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

HealBot_Options_StorePrev["HealBot_Options_notSet_Current_Skin"] = true
function HealBot_Options_Set_Current_Skin(newSkin, ddRefresh)
    if HealBot_Options_StorePrev["HealBot_Options_notSet_Current_Skin"] or newSkin then
        if HealBot_Options_StorePrev["HealBot_Options_notSet_Current_Skin"] then 
            HealBot_Skins = Healbot_Config_Skins.Skins
            HealBot_Options_StorePrev["HealBot_Options_notSet_Current_Skin"]=nil
        end
        if newSkin then
            local hbFoundSkin=nil
            local hbValidSkins=nil
            for j=1, getn(HealBot_Skins), 1 do
                if newSkin==HealBot_Skins[j] then
                    hbFoundSkin=true
                    HealBot_RaidTargetToggle(nil) 
                    Healbot_Config_Skins.Skin_ID = j
                    if Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin]~=Healbot_Config_Skins.ShowHeader[HealBot_Skins[j]] then
                        HealBot_Panel_ClearBarArrays()
                    end
                    Healbot_Config_Skins.Current_Skin = HealBot_Skins[j]
                    HealBot_Action_ResetSkin("init")
                    HealBot_Options_SetSkins();
                    if Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin]==1 then 
                        HealBot_RaidTargetToggle(true) 
                    end
                end
                if hbValidSkins then
                    hbValidSkins=hbValidSkins.."  +  "..HealBot_Skins[j]
                else
                    hbValidSkins=HealBot_Skins[j]
                end
            end
            if not hbFoundSkin then
                HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_CHANGESKINERR1..newSkin)
                if hbValidSkins then HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_CHANGESKINERR2..hbValidSkins) end
            elseif Healbot_Config_Skins.AutoClose[Healbot_Config_Skins.Current_Skin]==0 and HealBot_Config.DisabledNow==0 then
                ShowUIPanel(HealBot_Action)
            else
                HealBot_Action_Refresh(HealBot_PlayerGUID)
            end
            HealBot_setOptions_Timer(180)
           -- HealBot_SetResetFlag("SOFT")
        elseif HealBot_Config.Skin_ID>0 and HealBot_Config.Current_Skin and Healbot_Config_Skins.bheight[HealBot_Config.Current_Skin] then 
            Healbot_Config_Skins.Current_Skin = HealBot_Config.Current_Skin
            Healbot_Config_Skins.Skin_ID = HealBot_Config.Skin_ID
        else
            HealBot_Config.Current_Skin = Healbot_Config_Skins.Current_Skin
            HealBot_Config.Skin_ID = Healbot_Config_Skins.Skin_ID
        end
        HealBot_useCrashProtection()
        if not ddRefresh then 
            DoneInitTab[319]=nil
            HealBot_Options_InitSub(319)
        end
		if TITAN_HEALBOT_ID then TitanPanelButton_UpdateButton(TITAN_HEALBOT_ID, 1) end
    end
end

--------------------------------------------------------------------------------
local hbOptUsers={}
HealBot_Options_StorePrev["hbShareSkin"]=1
local hbTempUnitNames={}
HealBot_Options_StorePrev["hbTempNumUnitNames"]=0
local hbMyGuildMates = {}
local hbMyFriends = {}

function HealBot_Options_setMyFriends(unitName)
    if hbMyGuildMates[unitName] or unitName==HealBot_PlayerName then return end
    hbMyFriends[unitName]=true
end

function HealBot_Options_setMyGuildMates(unitName)
    if hbMyFriends[unitName] or unitName==HealBot_PlayerName then return end
    hbMyGuildMates[unitName]=true
end

function HealBot_Options_rethbTempUnitNames()
    local hbTempShareUnitNames={}
    HealBot_Options_StorePrev["hbTempNumUnitNames"]=0
    x=GetNumFriends()
    if x>0 then
        for y=1,x do
            uName, _, _, _, z = GetFriendInfo(y)
            if z and hbMyFriends[uName] then
                hbTempShareUnitNames[uName]="F"
                HealBot_Options_StorePrev["hbTempNumUnitNames"]=HealBot_Options_StorePrev["hbTempNumUnitNames"]+1
            end
        end
    end
    x=BNGetNumFriends()
    if x>0 then
        for y=1,x do
           _, _, _, uName, _, _, isOnline = BNGetFriendInfo(y)
           if isOnline and hbMyFriends[uName] then
               hbTempShareUnitNames[uName]="B"
               HealBot_Options_StorePrev["hbTempNumUnitNames"]=HealBot_Options_StorePrev["hbTempNumUnitNames"]+1
           end
       end
    end 
    x=GetNumGuildMembers()
    if x>0 then
        for y=1,x do
            uName, _, _, _, _, _, _, _, z = GetGuildRosterInfo(y)
            if z and hbMyGuildMates[uName] then
                hbTempShareUnitNames[uName]="G"
                HealBot_Options_StorePrev["hbTempNumUnitNames"]=HealBot_Options_StorePrev["hbTempNumUnitNames"]+1
            end
        end
    end
    hbOptUsers=HealBot_GetInfo()
    for uName,_ in pairs(hbOptUsers) do
        if uName~=HealBot_PlayerName and not hbTempShareUnitNames[uName] then
            xUnit=HealBot_RaidUnit(hbTempUnitNames[uName],nil,uName)
            if xUnit then
                hbTempUnitNames[uName]=xUnit
                hbTempShareUnitNames[uName]="R"
                HealBot_Options_StorePrev["hbTempNumUnitNames"]=HealBot_Options_StorePrev["hbTempNumUnitNames"]+1
            end
        end
    end
  --  HealBot_AddDebug("Num ShareUnitNames="..HealBot_Options_StorePrev["hbTempNumUnitNames"])
    return hbTempShareUnitNames
end

HealBot_Options_StorePrev["hbCurUnitName"]=HEALBOT_WORDS_NONE
function HealBot_Options_ShareSkin_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    local hbShareUnitNames=HealBot_Options_rethbTempUnitNames()
    local i=1
    info.text = strlower(HEALBOT_WORDS_NONE);
    info.func = function(self)
                    HealBot_Options_StorePrev["hbShareSkin"] = self:GetID()
                    HealBot_Options_StorePrev["hbCurUnitName"] = self:GetText()
                    UIDropDownMenu_SetSelectedID(HealBot_Options_ShareSkin,HealBot_Options_StorePrev["hbShareSkin"]) 
                end
    info.checked = false;
    if HealBot_Options_StorePrev["hbShareSkin"]==i then info.checked = true end
    UIDropDownMenu_AddButton(info);
    if HealBot_Options_StorePrev["hbTempNumUnitNames"]>0 then
        for x,_ in pairs(hbShareUnitNames) do
            i=i+1
            info.text = x;
            info.func = function(self)
                            HealBot_Options_StorePrev["hbShareSkin"] = self:GetID()
                            HealBot_Options_StorePrev["hbCurUnitName"] = self:GetText()
                            UIDropDownMenu_SetSelectedID(HealBot_Options_ShareSkin,HealBot_Options_StorePrev["hbShareSkin"]) 
                        end
            info.checked = false;
            if HealBot_Options_StorePrev["hbShareSkin"]==i then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
        HealBot_Options_ShareSkinb:Enable()
    else
        HealBot_Options_StorePrev["hbShareSkin"]=1
        HealBot_Options_ShareSkinb:Disable()
    end
end

function HealBot_Options_ShareSkinb_OnClick()
    if HealBot_Options_StorePrev["hbCurUnitName"] and HealBot_Options_StorePrev["hbCurUnitName"]~=strlower(HEALBOT_WORDS_NONE) then
        HealBot_Options_ShareSkinSend("A", Healbot_Config_Skins.Current_Skin, HealBot_Options_StorePrev["hbCurUnitName"])
    end
end

function HealBot_Options_ShareSkinSend(status,skinName,unitName)
	hbOptUsers=HealBot_GetInfo()
    if hbOptUsers[unitName] then
        local hbFoundSkin=HealBot_Options_checkSkinName(skinName)
        if hbFoundSkin then
            if status=="A" then
                HealBot_Comms_SendAddonMsg("HealBot", "X:"..skinName, 4, unitName)
            else
                local hbMsg=nil
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,1)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:1:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,2)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:2:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,3)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:3:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,4)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:4:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,5)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:5:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,6)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:6:"..hbMsg, 4, unitName)
                hbMsg=HealBot_Options_BuildSkinSendMsg(skinName,7)
                HealBot_Comms_SendAddonMsg("HealBot", "Z:7:"..hbMsg, 4, unitName)
            end
        else
            HealBot_AddChat(HEALBOT_CHAT_ADDONID..skinName..HEALBOT_CHAT_SHARESKINERR1);
        end
    else
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..unitName..HEALBOT_CHAT_SHARESKINERR3);
    end
end

local hbSkinRecAll={}
local hbAccpetedSkin="none"
local hbWarnSharedMedia=false
function HealBot_Options_ShareSkinRec(status, msg, partID)
    if status=="X" then
        hbOptGetSkinFrom, hbOptGetSkinName = string.split("!", msg)
        if hbOptGetSkinFrom and hbOptGetSkinName then
            StaticPopup_Show ("HEALBOT_OPTIONS_ACCEPTSKIN", " "..hbOptGetSkinName..HEALBOT_OPTIONS_ACCEPTSKINMSGFROM..hbOptGetSkinFrom);
        end
    elseif hbOptGetSkinName and hbAccpetedSkin==hbOptGetSkinFrom then
        HealBot_Options_BuildSkinRecMsg(hbOptGetSkinName, tonumber(partID), msg)
        hbSkinRecAll[partID]=true
        if hbSkinRecAll["1"] and hbSkinRecAll["2"] and hbSkinRecAll["3"] and hbSkinRecAll["4"] and hbSkinRecAll["5"] and hbSkinRecAll["6"] and hbSkinRecAll["7"] then
            local unique=true;
            table.foreach(HealBot_Skins, function (index,skin)
                if skin==hbOptGetSkinName then unique=false; end
            end)
            if unique then
                table.insert(HealBot_Skins,2,hbOptGetSkinName)
                Healbot_Config_Skins.Skin_ID = 2;
                Healbot_Config_Skins.Skins = HealBot_Skins
                Healbot_Config_Skins.Current_Skin = hbOptGetSkinName
                HealBot_Config.LastVersionSkinUpdate="1.0.0"
                HealBot_Update_Skins()
            end
            HealBot_Options_SetSkins();
            HealBot_Options_NewSkin:SetText("")
            hbSkinRecAll={}
            hbAccpetedSkin="none"
            hbWarnSharedMedia=false
            HealBot_AddChat(HEALBOT_CHAT_ADDONID..hbOptGetSkinName..HEALBOT_CHAT_SKINREC..hbOptGetSkinFrom)
        end
    end
end

function HealBot_Options_checkSkinName(skinName)
    local hbFoundSkin=nil
    for j=1, getn(HealBot_Skins), 1 do
        if skinName==HealBot_Skins[j] then
            hbFoundSkin=true
            do break end
        end
    end
    return hbFoundSkin
end

function HealBot_Options_ShareSkinAccept()
    hbSkinRecAll={}
    HealBot_Comms_SendAddonMsg("HealBot", "Y:"..hbOptGetSkinName, 4, hbOptGetSkinFrom)
    hbAccpetedSkin=hbOptGetSkinFrom
end

function HealBot_Options_BuildSkinSendMsg(skinName, partID)
    local ssMsg=nil
    
    if partID==1 then
        ssMsg=Healbot_Config_Skins.numcols[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.btexture[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.bcspace[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.brspace[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.bwidth[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.bheight[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextenabledcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextenabledcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextenabledcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextenabledcola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextdisbledcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextdisbledcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextdisbledcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextdisbledcola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextcursecolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextcursecolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextcursecolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.btextcursecola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.backcola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.Barcola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.BarcolaInHeal[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.backcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.backcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.backcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.borcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.borcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.borcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.borcola[skinName],1,4)
    elseif partID==2 then
        ssMsg=Healbot_Config_Skins.btextfont[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.btextheight[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.bardisa[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.bareora[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.bar2size[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowHeader[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headbarcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headbarcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headbarcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headbarcola[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headtxtcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headtxtcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headtxtcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headtxtcola[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.headtexture[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headwidth[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.btextoutline[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.headtextoutline[skinName]
    elseif partID==3 then
        ssMsg=Healbot_Config_Skins.headtextfont[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.headtextheight[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggro[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggroBars[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggroText[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.UseFluidBars[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarFreq[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowHoTicons[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIcon[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowDebuffIcon[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HoTonBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HoTposBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowClassOnBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowClassType[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowNameOnBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowHealthOnBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarHealthIncHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetBarAlwaysShow[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarHealthType[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SetClassColourText[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.IncHealBarColour[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HlthBarColour[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.barcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.barcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.barcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowIconTextCount[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowIconTextDuration[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.IconScale[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.IconTextScale[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AggroBarSize[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.DoubleText[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TextAlignment[skinName]
    elseif partID==4 then
        ssMsg=Healbot_Config_Skins.HighLightActiveBar[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.highcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.highcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.highcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.GroupsPerCol[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.headhight[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SelfHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.PetHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.GroupHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TankHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SelfPet[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.EmergencyHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SetFocusBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.VehicleHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowMyTargetsList[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetIncSelf[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetIncGroup[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetIncRaid[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.TargetIncPet[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HideIncMyTargets[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AlertLevel[skinName]
        ssMsg=ssMsg.."!".."0" -- Free slot
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HidePartyFrames[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HidePlayerTarget[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.CastNotify[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.NotifyChan[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.GroupPetsBy5[skinName]
    elseif partID==5 then
        ssMsg=" "
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.NotifyOtherMsg[skinName]
    elseif partID==6 then
        ssMsg=Healbot_Config_Skins.CastNotifyResOnly[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HideIncGroup[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.EmergIncMonitor[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ExtraOrder[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ExtraSubOrder[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortIncGroup[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortIncPet[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortIncVehicle[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortIncTanks[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortIncMyTargets[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.Panel_Anchor[skinName]
        for x=1,8 do
            if Healbot_Config_Skins.ExtraIncGroup[skinName][x] then
                ssMsg=ssMsg.."!1"
            else
                ssMsg=ssMsg.."!0"
            end
        end
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ActionLocked[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AutoClose[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.PanelSounds[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconStar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconCircle[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconDiamond[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconTriangle[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconMoon[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconSquare[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconCross[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRaidIconSkull[skinName]
    elseif partID==7 then
        ssMsg=Healbot_Config_Skins.HoTx2Bar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowIconTextCountSelfCast[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowIconTextDurationSelfCast[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarHealthNumFormat1[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarHealthNumFormat2[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ReadyCheck[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.SubSortPlayerFirst[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggroBarsPct[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggroTextPct[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HighLightActiveBarInCombat[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.BarHealthNumFormatAggro[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.MainAssistHeals[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowAggroInd[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AggroIndAlertLevel[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.LowManaInd[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.LowManaIndIC[skinName]
        ssMsg=ssMsg.."!".." "
        ssMsg=ssMsg.."!".." "
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.AggroColr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.AggroColg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.AggroColb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.AggroBarsMaxAlpha[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.AggroBarsMinAlpha[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AggroBarsFreq[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.IconTextDurationShow[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.IconTextDurationWarn[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.AggroAlertLevel[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.Bars_Anchor[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HighLightTargetBar[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HighLightTargetBarInCombat[skinName]
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.targetcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.targetcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.targetcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.ihbarcolr[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.ihbarcolg[skinName],1,4)
        ssMsg=ssMsg.."!"..strsub(Healbot_Config_Skins.ihbarcolb[skinName],1,4)
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.FocusBarAlwaysShow[skinName]
		    ssMsg=ssMsg.."!"..Healbot_Config_Skins.PowerCounter[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HideBars[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HideIncTank[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.HideIncFocus[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.FrameScale[skinName]
        ssMsg=ssMsg.."!"..Healbot_Config_Skins.ShowRole[skinName]
    end
    return ssMsg
end

function HealBot_Options_BuildSkinRecMsg(skinName, partID, msg)
    local tmpMsg={}
    if partID==1 then
        tmpMsg[1],   tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
        tmpMsg[11], tmpMsg[12], tmpMsg[13], tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18], tmpMsg[19], tmpMsg[20],
        tmpMsg[21], tmpMsg[22], tmpMsg[23], tmpMsg[24], tmpMsg[25], tmpMsg[26], tmpMsg[27], tmpMsg[28] = string.split("!", msg)
        Healbot_Config_Skins.numcols[skinName] = tonumber(tmpMsg[1])
        if texturesIndex[tmpMsg[2]] then
            Healbot_Config_Skins.btexture[skinName] = tmpMsg[2]
        elseif not Healbot_Config_Skins.btexture[skinName] then
            Healbot_Config_Skins.btexture[skinName] = "Smooth"
        end
        Healbot_Config_Skins.bcspace[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.brspace[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.bwidth[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.bheight[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.btextenabledcolr[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.btextenabledcolg[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.btextenabledcolb[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.btextenabledcola[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.btextdisbledcolr[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.btextdisbledcolg[skinName] = tonumber(tmpMsg[12])
        Healbot_Config_Skins.btextdisbledcolb[skinName] = tonumber(tmpMsg[13])
        Healbot_Config_Skins.btextdisbledcola[skinName] = tonumber(tmpMsg[14])
        Healbot_Config_Skins.btextcursecolr[skinName] = tonumber(tmpMsg[15])
        Healbot_Config_Skins.btextcursecolg[skinName] = tonumber(tmpMsg[16])
        Healbot_Config_Skins.btextcursecolb[skinName] = tonumber(tmpMsg[17])
        Healbot_Config_Skins.btextcursecola[skinName] = tonumber(tmpMsg[18])
        Healbot_Config_Skins.backcola[skinName] = tonumber(tmpMsg[19])
        Healbot_Config_Skins.Barcola[skinName] = tonumber(tmpMsg[20])
        Healbot_Config_Skins.BarcolaInHeal[skinName] = tonumber(tmpMsg[21])
        Healbot_Config_Skins.backcolr[skinName] = tonumber(tmpMsg[22])
        Healbot_Config_Skins.backcolg[skinName] = tonumber(tmpMsg[23])
        Healbot_Config_Skins.backcolb[skinName] = tonumber(tmpMsg[24])
        Healbot_Config_Skins.borcolr[skinName] = tonumber(tmpMsg[25])
        Healbot_Config_Skins.borcolg[skinName] = tonumber(tmpMsg[26])
        Healbot_Config_Skins.borcolb[skinName] = tonumber(tmpMsg[27])
        Healbot_Config_Skins.borcola[skinName] = tonumber(tmpMsg[28])
    elseif partID==2 then
        tmpMsg[1],   tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
        tmpMsg[11], tmpMsg[12], tmpMsg[13], tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18] = string.split("!", msg)
        if fontsIndex[tmpMsg[1]] then
            Healbot_Config_Skins.btextfont[skinName] = tmpMsg[1]
        elseif not Healbot_Config_Skins.btextfont[skinName] then
            Healbot_Config_Skins.btextfont[skinName] = "Friz Quadrata TT"
        end
        Healbot_Config_Skins.btextheight[skinName] = tonumber(tmpMsg[2])
        Healbot_Config_Skins.bardisa[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.bareora[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.bar2size[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.ShowHeader[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.headbarcolr[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.headbarcolg[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.headbarcolb[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.headbarcola[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.headtxtcolr[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.headtxtcolg[skinName] = tonumber(tmpMsg[12])
        Healbot_Config_Skins.headtxtcolb[skinName] = tonumber(tmpMsg[13])
        Healbot_Config_Skins.headtxtcola[skinName] = tonumber(tmpMsg[14])
        if texturesIndex[tmpMsg[15]] then
            Healbot_Config_Skins.headtexture[skinName] = tmpMsg[15]
        elseif not Healbot_Config_Skins.headtexture[skinName] then
            Healbot_Config_Skins.headtexture[skinName] = "Smooth"
        end
        Healbot_Config_Skins.headwidth[skinName] = tonumber(tmpMsg[16])
        Healbot_Config_Skins.btextoutline[skinName] = tonumber(tmpMsg[17])
        Healbot_Config_Skins.headtextoutline[skinName] = tonumber(tmpMsg[18])
    elseif partID==3 then
        tmpMsg[1],   tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
        tmpMsg[11], tmpMsg[12], tmpMsg[13], tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18], tmpMsg[19], tmpMsg[20],
        tmpMsg[21], tmpMsg[22], tmpMsg[23], tmpMsg[24], tmpMsg[25], tmpMsg[26], tmpMsg[27], tmpMsg[28], tmpMsg[29], tmpMsg[30],
        tmpMsg[31], tmpMsg[32] = string.split("!", msg)
        if fontsIndex[tmpMsg[1]] then
            Healbot_Config_Skins.headtextfont[skinName] = tmpMsg[1]
        elseif not Healbot_Config_Skins.headtextfont[skinName] then
            Healbot_Config_Skins.headtextfont[skinName] = "Friz Quadrata TT"
        end        
        Healbot_Config_Skins.headtextheight[skinName] = tonumber(tmpMsg[2])
        Healbot_Config_Skins.ShowAggro[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.ShowAggroBars[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.ShowAggroText[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.UseFluidBars[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.BarFreq[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.ShowHoTicons[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.ShowRaidIcon[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.ShowDebuffIcon[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.HoTonBar[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.HoTposBar[skinName] = tonumber(tmpMsg[12])
        Healbot_Config_Skins.ShowClassOnBar[skinName] = tonumber(tmpMsg[13])
        Healbot_Config_Skins.ShowClassType[skinName] = tonumber(tmpMsg[14])
        Healbot_Config_Skins.ShowNameOnBar[skinName] = tonumber(tmpMsg[15])
        Healbot_Config_Skins.ShowHealthOnBar[skinName] = tonumber(tmpMsg[16])
        Healbot_Config_Skins.BarHealthIncHeals[skinName] = tonumber(tmpMsg[17])
        Healbot_Config_Skins.TargetBarAlwaysShow[skinName] = tonumber(tmpMsg[18])
        Healbot_Config_Skins.BarHealthType[skinName] = tonumber(tmpMsg[19])
        Healbot_Config_Skins.SetClassColourText[skinName] = tonumber(tmpMsg[20])
        Healbot_Config_Skins.IncHealBarColour[skinName] = tonumber(tmpMsg[21])
        Healbot_Config_Skins.HlthBarColour[skinName] = tonumber(tmpMsg[22])
        Healbot_Config_Skins.barcolr[skinName] = tonumber(tmpMsg[23])
        Healbot_Config_Skins.barcolg[skinName] = tonumber(tmpMsg[24])
        Healbot_Config_Skins.barcolb[skinName] = tonumber(tmpMsg[25])
        Healbot_Config_Skins.ShowIconTextCount[skinName] = tonumber(tmpMsg[26])
        Healbot_Config_Skins.ShowIconTextDuration[skinName] = tonumber(tmpMsg[27])
        Healbot_Config_Skins.IconScale[skinName] = tonumber(tmpMsg[28])
        Healbot_Config_Skins.IconTextScale[skinName] = tonumber(tmpMsg[29])
        Healbot_Config_Skins.AggroBarSize[skinName] = tonumber(tmpMsg[30])
        Healbot_Config_Skins.DoubleText[skinName] = tonumber(tmpMsg[31])
        Healbot_Config_Skins.TextAlignment[skinName] = tonumber(tmpMsg[32])
    elseif partID==4 then
        tmpMsg[1],   tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
        tmpMsg[11], tmpMsg[12], tmpMsg[13], tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18], tmpMsg[19], tmpMsg[20],
        tmpMsg[21], tmpMsg[22], tmpMsg[23], tmpMsg[24], tmpMsg[25], tmpMsg[26], tmpMsg[27], tmpMsg[28] = string.split("!", msg)
        Healbot_Config_Skins.HighLightActiveBar[skinName] = tonumber(tmpMsg[1])
        Healbot_Config_Skins.highcolr[skinName] = tonumber(tmpMsg[2])
        Healbot_Config_Skins.highcolg[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.highcolb[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.GroupsPerCol[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.headhight[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.SelfHeals[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.PetHeals[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.GroupHeals[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.TankHeals[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.SelfPet[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.EmergencyHeals[skinName] = tonumber(tmpMsg[12])
        Healbot_Config_Skins.SetFocusBar[skinName] = tonumber(tmpMsg[13])
        Healbot_Config_Skins.VehicleHeals[skinName] = tonumber(tmpMsg[14])
        Healbot_Config_Skins.ShowMyTargetsList[skinName] = tonumber(tmpMsg[15])
        Healbot_Config_Skins.TargetHeals[skinName] = tonumber(tmpMsg[16])
        Healbot_Config_Skins.TargetIncSelf[skinName] = tonumber(tmpMsg[17])
        Healbot_Config_Skins.TargetIncGroup[skinName] = tonumber(tmpMsg[18])
        Healbot_Config_Skins.TargetIncRaid[skinName] = tonumber(tmpMsg[19])
        Healbot_Config_Skins.TargetIncPet[skinName] = tonumber(tmpMsg[20])
        Healbot_Config_Skins.HideIncMyTargets[skinName] = tonumber(tmpMsg[21])
        Healbot_Config_Skins.AlertLevel[skinName] = tonumber(tmpMsg[22])
        _ = tonumber(tmpMsg[23])
        Healbot_Config_Skins.HidePartyFrames[skinName] = tonumber(tmpMsg[24])
        Healbot_Config_Skins.HidePlayerTarget[skinName] = tonumber(tmpMsg[25])
        Healbot_Config_Skins.CastNotify[skinName] = tonumber(tmpMsg[26])
        Healbot_Config_Skins.NotifyChan[skinName] = tmpMsg[27]
        Healbot_Config_Skins.GroupPetsBy5[skinName] = tmpMsg[28]
    elseif partID==5 then
        _ , Healbot_Config_Skins.NotifyOtherMsg[skinName] = string.split("!", msg)
    elseif partID==6 then
        tmpMsg[1],   tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
        tmpMsg[11], tmpMsg[12], tmpMsg[13], tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18], tmpMsg[19], tmpMsg[20],
        tmpMsg[21], tmpMsg[22], tmpMsg[23], tmpMsg[24], tmpMsg[25], tmpMsg[26], tmpMsg[27], tmpMsg[28], tmpMsg[29], tmpMsg[30],
        tmpMsg[31], tmpMsg[32], tmpMsg[33] = string.split("!", msg)
        Healbot_Config_Skins.CastNotifyResOnly[skinName] = tonumber(tmpMsg[1])
        Healbot_Config_Skins.HideIncGroup[skinName] = tonumber(tmpMsg[2])
        Healbot_Config_Skins.EmergIncMonitor[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.ExtraOrder[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.ExtraSubOrder[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.SubSortIncGroup[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.SubSortIncPet[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.SubSortIncVehicle[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.SubSortIncTanks[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.SubSortIncMyTargets[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.Panel_Anchor[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.ExtraIncGroup[skinName] = {}
        for x=1,8 do
            z=x+11
            if tmpMsg[z]=="0" then
                Healbot_Config_Skins.ExtraIncGroup[skinName][x] = false
            else
                Healbot_Config_Skins.ExtraIncGroup[skinName][x] = true
            end
        end
        Healbot_Config_Skins.ActionLocked[skinName] = tonumber(tmpMsg[20])
        Healbot_Config_Skins.AutoClose[skinName] = tonumber(tmpMsg[21])
        Healbot_Config_Skins.PanelSounds[skinName] = tonumber(tmpMsg[22])
        Healbot_Config_Skins.ShowRaidIconStar[skinName] = tonumber(tmpMsg[23])
        Healbot_Config_Skins.ShowRaidIconCircle[skinName] = tonumber(tmpMsg[24])
        Healbot_Config_Skins.ShowRaidIconDiamond[skinName] = tonumber(tmpMsg[25])
        Healbot_Config_Skins.ShowRaidIconTriangle[skinName] = tonumber(tmpMsg[26])
        Healbot_Config_Skins.ShowRaidIconMoon[skinName] = tonumber(tmpMsg[27])
        Healbot_Config_Skins.ShowRaidIconSquare[skinName] = tonumber(tmpMsg[28])
        Healbot_Config_Skins.ShowRaidIconCross[skinName] = tonumber(tmpMsg[29])
        Healbot_Config_Skins.ShowRaidIconSkull[skinName] = tonumber(tmpMsg[30])
    elseif partID==7 then
         tmpMsg[1],  tmpMsg[2],  tmpMsg[3],  tmpMsg[4],  tmpMsg[5],  tmpMsg[6],  tmpMsg[7],  tmpMsg[8],  tmpMsg[9], tmpMsg[10],
         tmpMsg[11],  tmpMsg[12],  tmpMsg[13],  tmpMsg[14], tmpMsg[15], tmpMsg[16], tmpMsg[17], tmpMsg[18], tmpMsg[19], tmpMsg[20],
         tmpMsg[21], tmpMsg[22], tmpMsg[23], tmpMsg[24], tmpMsg[25], tmpMsg[26], tmpMsg[27], tmpMsg[28], tmpMsg[29], tmpMsg[30],
         tmpMsg[31], tmpMsg[32], tmpMsg[33], tmpMsg[34], tmpMsg[35], tmpMsg[36], tmpMsg[37], tmpMsg[38], tmpMsg[39], tmpMsg[40], tmpMsg[41], tmpMsg[42], tmpMsg[43] = string.split("!", msg)
        Healbot_Config_Skins.HoTx2Bar[skinName] = tonumber(tmpMsg[1])
        Healbot_Config_Skins.ShowIconTextCountSelfCast[skinName] = tonumber(tmpMsg[2])
        Healbot_Config_Skins.ShowIconTextDurationSelfCast[skinName] = tonumber(tmpMsg[3])
        Healbot_Config_Skins.BarHealthNumFormat1[skinName] = tonumber(tmpMsg[4])
        Healbot_Config_Skins.BarHealthNumFormat2[skinName] = tonumber(tmpMsg[5])
        Healbot_Config_Skins.ReadyCheck[skinName] = tonumber(tmpMsg[6])
        Healbot_Config_Skins.SubSortPlayerFirst[skinName] = tonumber(tmpMsg[7])
        Healbot_Config_Skins.ShowAggroBarsPct[skinName] = tonumber(tmpMsg[8])
        Healbot_Config_Skins.ShowAggroTextPct[skinName] = tonumber(tmpMsg[9])
        Healbot_Config_Skins.HighLightActiveBarInCombat[skinName] = tonumber(tmpMsg[10])
        Healbot_Config_Skins.BarHealthNumFormatAggro[skinName] = tonumber(tmpMsg[11])
        Healbot_Config_Skins.MainAssistHeals[skinName] = tonumber(tmpMsg[12])
        Healbot_Config_Skins.ShowAggroInd[skinName] = tonumber(tmpMsg[13])
        Healbot_Config_Skins.AggroIndAlertLevel[skinName] = tonumber(tmpMsg[14])
        Healbot_Config_Skins.LowManaInd[skinName] = tonumber(tmpMsg[15])
        Healbot_Config_Skins.LowManaIndIC[skinName] = tonumber(tmpMsg[16])
        _ = tonumber(tmpMsg[17])
        _ = tonumber(tmpMsg[18])
        Healbot_Config_Skins.AggroColr[skinName] = tonumber(tmpMsg[19])
        Healbot_Config_Skins.AggroColg[skinName] = tonumber(tmpMsg[20])
        Healbot_Config_Skins.AggroColb[skinName] = tonumber(tmpMsg[21])
        Healbot_Config_Skins.AggroBarsMaxAlpha[skinName] = tonumber(tmpMsg[22])
        Healbot_Config_Skins.AggroBarsMinAlpha[skinName] = tonumber(tmpMsg[23])
        Healbot_Config_Skins.AggroBarsFreq[skinName] = tonumber(tmpMsg[24])
        Healbot_Config_Skins.IconTextDurationShow[skinName] = tonumber(tmpMsg[25])
        Healbot_Config_Skins.IconTextDurationWarn[skinName] = tonumber(tmpMsg[26])
        Healbot_Config_Skins.AggroAlertLevel[skinName] = tonumber(tmpMsg[27])
        Healbot_Config_Skins.Bars_Anchor[skinName] = tonumber(tmpMsg[28])
        Healbot_Config_Skins.HighLightTargetBar[skinName] = tonumber(tmpMsg[29])
        Healbot_Config_Skins.HighLightTargetBarInCombat[skinName] = tonumber(tmpMsg[30])
        Healbot_Config_Skins.targetcolr[skinName] = tonumber(tmpMsg[31])
        Healbot_Config_Skins.targetcolg[skinName] = tonumber(tmpMsg[32])
        Healbot_Config_Skins.targetcolb[skinName] = tonumber(tmpMsg[33])
        Healbot_Config_Skins.ihbarcolr[skinName] = tonumber(tmpMsg[34])
        Healbot_Config_Skins.ihbarcolg[skinName] = tonumber(tmpMsg[35])
        Healbot_Config_Skins.ihbarcolb[skinName] = tonumber(tmpMsg[36])
        Healbot_Config_Skins.FocusBarAlwaysShow[skinName] = tonumber(tmpMsg[37])
		Healbot_Config_Skins.PowerCounter[skinName] = tonumber(tmpMsg[38])
        Healbot_Config_Skins.HideBars[skinName] = tonumber(tmpMsg[39])
        Healbot_Config_Skins.HideIncTank[skinName] = tonumber(tmpMsg[40])
        Healbot_Config_Skins.HideIncFocus[skinName] = tonumber(tmpMsg[41])
        Healbot_Config_Skins.FrameScale[skinName] = tonumber(tmpMsg[42])        
        Healbot_Config_Skins.ShowRole[skinName] = tonumber(tmpMsg[43])   
    end
end

function HealBot_Option_WarnPossibleNoSharedMedia()
    if not hbWarnSharedMedia then
        HealBot_AddChat(HEALBOT_CHAT_ADDONID..HEALBOT_CHAT_POSSIBLEMISSINGMEDIA)
        hbWarnSharedMedia=true
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_TooltipPos_List = {
    HEALBOT_TOOLTIP_POSDEFAULT,
    HEALBOT_TOOLTIP_POSLEFT,
    HEALBOT_TOOLTIP_POSRIGHT,
    HEALBOT_TOOLTIP_POSABOVE,
    HEALBOT_TOOLTIP_POSBELOW,
    HEALBOT_TOOLTIP_POSCURSOR,
}

function HealBot_Options_TooltipPos_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_TooltipPos_List), 1 do
        info.text = HealBot_Options_TooltipPos_List[j];
        info.func = function(self)
                        Healbot_Config_Skins.TooltipPos[Healbot_Config_Skins.Current_Skin] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_TooltipPos,Healbot_Config_Skins.TooltipPos[Healbot_Config_Skins.Current_Skin]) 
                    end
        info.checked = false;
        if Healbot_Config_Skins.TooltipPos[Healbot_Config_Skins.Current_Skin]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local function HealBot_Options_BuffTxt1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt1,BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt1,BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt2,BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt2,BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt3_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt3,BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt3,BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt4_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt4,BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt4,BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt5_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt5,BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt5,BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt6_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt6,BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt6,BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt7_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt7,BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt7,BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt8_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt8,BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt8,BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt9_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt9,BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt9,BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffTxt10_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    BuffTextClass = HealBot_Config.HealBotBuffText
                    BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)] = self:GetText()
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt10,BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)])
                    HealBot_setOptions_Timer(40)
                end
    info.checked = false;
    if BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(HealBot_Buff_Spells_List), 1 do
        info.text = HealBot_Buff_Spells_List[j];
        info.func = function(self)
                        BuffTextClass = HealBot_Config.HealBotBuffText
                        BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)] = self:GetText()
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt10,BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)])
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)]==HealBot_Buff_Spells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local BuffDropDownClass=nil
local function HealBot_Options_BuffGroups1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups1,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)]) 
                        ClickedBuffGroupDD=1
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups2,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)]) 
                        ClickedBuffGroupDD=2
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups3_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups3,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)]) 
                        ClickedBuffGroupDD=3
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups4_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups4,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)]) 
                        ClickedBuffGroupDD=4
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups5_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups5,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)]) 
                        ClickedBuffGroupDD=5
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups6_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups6,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)]) 
                        ClickedBuffGroupDD=6
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups7_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups7,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)]) 
                        ClickedBuffGroupDD=7
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups8_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups8,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)]) 
                        ClickedBuffGroupDD=8
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups9_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups9,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)]) 
                        ClickedBuffGroupDD=9
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Options_BuffGroups10_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
                        BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups10,BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)]) 
                        ClickedBuffGroupDD=10
                        HealBot_setOptions_Timer(40)
                    end
        info.checked = false;
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

--------------------------------------------------------------------------------

local HealBot_Options_ComboClass_List = {
    HEALBOT_DRUID,
    HEALBOT_PALADIN,
    HEALBOT_PRIEST,
    HEALBOT_SHAMAN,
}

local HealBot_Debuff_Item_List = {
    HEALBOT_PURIFICATION_POTION,
    HEALBOT_ELIXIR_OF_POISON_RES,
    HEALBOT_ANTI_VENOM,
    HEALBOT_POWERFUL_ANTI_VENOM,
}

local HealBot_Debuff_RangeWarning_List = {
    HEALBOT_WORD_ALWAYS,
    HEALBOT_VISIBLE_RANGE,
    HEALBOT_SPELL_RANGE,
}

function HealBot_Options_CDCTxt1_DropDown()
    local DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(HealBot_PlayerClassTrim)
    local RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                    HealBot_setOptions_Timer(50)
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt1,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)])
                end
    info.checked = false;
    if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(DebuffSpells_List), 1 do
        sName, _=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[j]));
        if sName then
            info.text = sName;
            info.func = function(self)
                            HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                            HealBot_setOptions_Timer(50)
                            UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt1,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)])
                        end
            info.checked = false;
            if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)]==sName then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
    end
    for j=1, getn(RacialDebuffSpells_List), 1 do
        info.text = RacialDebuffSpells_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt1,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)]==RacialDebuffSpells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
    for j=1, getn(HealBot_Debuff_Item_List), 1 do
        info.text = HealBot_Debuff_Item_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt1,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)]==HealBot_Debuff_Item_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCTxt2_DropDown()
    local DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(HealBot_PlayerClassTrim)
    local RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                    HealBot_setOptions_Timer(50)
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt2,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)])
                end
    info.checked = false;
    if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(DebuffSpells_List), 1 do
        sName, _=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[j]));
        if sName then
            info.text = sName;
            info.func = function(self)
                            HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                            HealBot_setOptions_Timer(50)
                            UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt2,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)])
                        end
            info.checked = false;
            if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)]==sName then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
    end
    for j=1, getn(RacialDebuffSpells_List), 1 do
        info.text = RacialDebuffSpells_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt2,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)]==RacialDebuffSpells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
    for j=1, getn(HealBot_Debuff_Item_List), 1 do
        info.text = HealBot_Debuff_Item_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt2,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)]==HealBot_Debuff_Item_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCTxt3_DropDown()
    local DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(HealBot_PlayerClassTrim)
    local RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
    local info = UIDropDownMenu_CreateInfo()
    info.text = HEALBOT_WORDS_NONE;
    info.func = function(self)
                    HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                    HealBot_setOptions_Timer(50)
                    UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt3,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)])
                end
    info.checked = false;
    if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)]==HEALBOT_WORDS_NONE then info.checked = true end
    UIDropDownMenu_AddButton(info);
    for j=1, getn(DebuffSpells_List), 1 do
        sName, _=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[j]));
        if sName then
            info.text = sName;
            info.func = function(self)
                            HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                            HealBot_setOptions_Timer(50)
                            UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt3,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)])
                        end
            info.checked = false;
            if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)]==sName then info.checked = true end
            UIDropDownMenu_AddButton(info);
        end
    end
    for j=1, getn(RacialDebuffSpells_List), 1 do
        info.text = RacialDebuffSpells_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt3,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)]==RacialDebuffSpells_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
    for j=1, getn(HealBot_Debuff_Item_List), 1 do
        info.text = HealBot_Debuff_Item_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)] = self:GetText()
                        HealBot_setOptions_Timer(50)
                        UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt3,HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)])
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)]==HealBot_Debuff_Item_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCGroups1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(1)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups1,HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(1)]) 
                        ClickedBuffGroupDD=1
                        HealBot_setOptions_Timer(50)
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(1)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCGroups2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(2)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups2,HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(2)]) 
                        ClickedBuffGroupDD=2
                        HealBot_setOptions_Timer(50)
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(2)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCGroups3_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Options_BuffTxt_List), 1 do
        info.text = HealBot_Options_BuffTxt_List[j];
        info.func = function(self)
                        HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(3)] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups3,HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(3)]) 
                        ClickedBuffGroupDD=3
                        HealBot_setOptions_Timer(50)
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(3)]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCPriority1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 20, 1 do
        info.text = j;
        info.func = function(self)
                        HealBot_Config.HealBotDebuffPriority[HEALBOT_DISEASE_en] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCPriority1,HealBot_Config.HealBotDebuffPriority[HEALBOT_DISEASE_en]) 
                        HealBot_Options_setCustomDebuffList()
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffPriority[HEALBOT_DISEASE_en]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCPriority2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 20, 1 do
        info.text = j;
        info.func = function(self)
                        HealBot_Config.HealBotDebuffPriority[HEALBOT_MAGIC_en] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCPriority2,HealBot_Config.HealBotDebuffPriority[HEALBOT_MAGIC_en]) 
                        HealBot_Options_setCustomDebuffList()
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffPriority[HEALBOT_MAGIC_en]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCPriority3_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 20, 1 do
        info.text = j;
        info.func = function(self)
                        HealBot_Config.HealBotDebuffPriority[HEALBOT_POISON_en] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCPriority3,HealBot_Config.HealBotDebuffPriority[HEALBOT_POISON_en]) 
                        HealBot_Options_setCustomDebuffList()
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffPriority[HEALBOT_POISON_en]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCPriority4_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 20, 1 do
        info.text = j;
        info.func = function(self)
                        HealBot_Config.HealBotDebuffPriority[HEALBOT_CURSE_en] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCPriority4,HealBot_Config.HealBotDebuffPriority[HEALBOT_CURSE_en]) 
                        HealBot_Options_setCustomDebuffList()
                    end
        info.checked = false;
        if HealBot_Config.HealBotDebuffPriority[HEALBOT_CURSE_en]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCPriorityC_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 20, 1 do
        info.text = j;
        info.func = function(self)
                        local x=self:GetID()
                        if HealBot_Options_StorePrev["CDebuffcustomName"] then
                            HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]] = x
                        end
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCPriorityC,x) 
                        HealBot_Options_setCustomDebuffList()
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["CDebuffcustomName"] and HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]] and HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCWarnRange1_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Debuff_RangeWarning_List), 1 do
        info.text = HealBot_Debuff_RangeWarning_List[j];
        info.func = function(self)
                        HealBot_Config.HealBot_CDCWarnRange_Bar = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCWarnRange1,HealBot_Config.HealBot_CDCWarnRange_Bar) 
                    end
        info.checked = false;
        if HealBot_Config.HealBot_CDCWarnRange_Bar==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCWarnRange2_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Debuff_RangeWarning_List), 1 do
        info.text = HealBot_Debuff_RangeWarning_List[j];
        info.func = function(self)
                        HealBot_Config.HealBot_CDCWarnRange_Aggro = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCWarnRange2,HealBot_Config.HealBot_CDCWarnRange_Aggro) 
                    end
        info.checked = false;
        if HealBot_Config.HealBot_CDCWarnRange_Aggro==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCWarnRange3_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Debuff_RangeWarning_List), 1 do
        info.text = HealBot_Debuff_RangeWarning_List[j];
        info.func = function(self)
                        HealBot_Config.HealBot_CDCWarnRange_Screen = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCWarnRange3,HealBot_Config.HealBot_CDCWarnRange_Screen) 
                    end
        info.checked = false;
        if HealBot_Config.HealBot_CDCWarnRange_Screen==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCWarnRange4_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_Debuff_RangeWarning_List), 1 do
        info.text = HealBot_Debuff_RangeWarning_List[j];
        info.func = function(self)
                        HealBot_Config.HealBot_CDCWarnRange_Sound = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDCWarnRange4,HealBot_Config.HealBot_CDCWarnRange_Sound) 
                    end
        info.checked = false;
        if HealBot_Config.HealBot_CDCWarnRange_Sound==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local HealBot_CDebuffCat_List = {
    HEALBOT_CUSTOM_CAT_CUSTOM,
    HEALBOT_CUSTOM_CAT_CLASSIC,
    HEALBOT_CUSTOM_CAT_TBC_OTHER,
    HEALBOT_CUSTOM_CAT_TBC_BT,
    HEALBOT_CUSTOM_CAT_TBC_SUNWELL,
    HEALBOT_CUSTOM_CAT_LK_OTHER,
    HEALBOT_CUSTOM_CAT_LK_ULDUAR,
    HEALBOT_CUSTOM_CAT_LK_TOC,
    HEALBOT_CUSTOM_CAT_LK_ICC_LOWER,
    HEALBOT_CUSTOM_CAT_LK_ICC_PLAGUEWORKS,
    HEALBOT_CUSTOM_CAT_LK_ICC_CRIMSON,
    HEALBOT_CUSTOM_CAT_LK_ICC_FROSTWING,
    HEALBOT_CUSTOM_CAT_LK_ICC_THRONE,
    HEALBOT_CUSTOM_CAT_LK_RS_THRONE,
    HEALBOT_CUSTOM_CAT_CATA_OTHER,
    HEALBOT_CUSTOM_CAT_CATA_PARTY,
    HEALBOT_CUSTOM_CAT_CATA_RAID,
}

HealBot_Options_StorePrev["CDebuffCatID"] = 6

function HealBot_Options_CDebuffCat_genList()
    local tmpCDebuffCat_List={}
    for x,_ in pairs(tmpCDebuffCat_List) do
        tmpCDebuffCat_List[x]=nil;
    end
    HealBot_Options_DeleteCDebuffBtn:Disable();
    HealBot_Options_ResetCDebuffBtn:Disable();
    j=0
    for dName,x in pairs(HealBot_Globals.Custom_Debuff_Categories) do
        if HealBot_Options_StorePrev["CDebuffCatID"]==x and HealBot_Globals.HealBot_Custom_Debuffs[dName] then
            table.insert(tmpCDebuffCat_List, dName)
            j=j+1
        end
    end
    x=nil
    if j>0 then
        HealBot_Options_DeleteCDebuffBtn:Enable();
        HealBot_Options_ResetCDebuffBtn:Enable();
        table.sort(tmpCDebuffCat_List)
        for j=1, getn(tmpCDebuffCat_List), 1 do
            if tmpCDebuffCat_List[j]==HealBot_Options_StorePrev["CDebuffcustomName"] then
                HealBot_Options_StorePrev["CDebuffcustomID"]=j
                x=true
                do break end
            end
        end
    end
    if not x then HealBot_Options_StorePrev["CDebuffcustomID"]=1 end
    HealBot_Options_StorePrev["CDebuffcustomName"]=tmpCDebuffCat_List[HealBot_Options_StorePrev["CDebuffcustomID"]]
    return tmpCDebuffCat_List
end

function HealBot_Options_CDebuffCat_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, getn(HealBot_CDebuffCat_List), 1 do
        info.text = HealBot_CDebuffCat_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["CDebuffCatID"] = self:GetID()
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDebuffCat,HealBot_Options_StorePrev["CDebuffCatID"]) 
                        HealBot_Options_InitSub(406)
                        HealBot_Options_InitSub(408)
                        HealBot_SetCDCBarColours();
                        if HealBot_Options_StorePrev["CDebuffCatID"]==1 then
                            HealBot_Options_NewCDebuffBtn:Disable();
                        end
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["CDebuffCatID"]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDebuffTxt1_DropDown() -- added by Diacono
    local info = UIDropDownMenu_CreateInfo()
    local CDebuffCat_List = HealBot_Options_CDebuffCat_genList()
    for j=1, getn(CDebuffCat_List), 1 do
        info.text = CDebuffCat_List[j];
        info.func = function(self)
                        HealBot_Options_StorePrev["CDebuffcustomID"] = self:GetID()
                        HealBot_Options_StorePrev["CDebuffcustomName"] = self.value
                        UIDropDownMenu_SetSelectedID(HealBot_Options_CDebuffTxt1,HealBot_Options_StorePrev["CDebuffcustomID"]) 
                        HealBot_Options_InitSub(408)
                        HealBot_SetCDCBarColours();
                    end
        info.checked = false;
        if HealBot_Options_StorePrev["CDebuffcustomName"]==CDebuffCat_List[j] then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_NewCDebuff_OnTextChanged(self)
    text = strtrim(self:GetText())
    if strlen(text)>0 and HealBot_Options_StorePrev["CDebuffCatID"]>1 then
        HealBot_Options_NewCDebuffBtn:Enable();
    else
        HealBot_Options_NewCDebuffBtn:Disable();
    end
end

function HealBot_Options_GetSpellInfo_OnEnterPressed(self)
    text = strtrim(self:GetText())
    if tonumber(text) then
        text = GetSpellInfo(text)
    end
    self:SetText(text or "")
end

StaticPopupDialogs["HEALBOT_OPTIONS_ERROR"] = {
    text = HEALBOT_WORDS_ERROR..": %s",
    button1 = OKAY,
    showAlert = 1,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
};

StaticPopupDialogs["HEALBOT_OPTIONS_NEWCDEBUFF"] = {
    text = HEALBOT_OPTIONS_SAVESKIN..": %s",
    button1 = HEALBOT_WORDS_YES,
    button2 = HEALBOT_WORDS_NO,
    OnAccept = function()
        HealBot_Options_NewCDebuffBtn_OnClick(HealBot_Options_NewCDebuffBtn)
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
};

local NewCDebuffTxt=nil
function HealBot_Options_NewCDebuffBtn_OnClick(self)
    NewCDebuffTxt=HealBot_Options_NewCDebuff:GetText()
    local unique=true;
    for k, _ in pairs(HealBot_Globals.HealBot_Custom_Debuffs) do
        if k==NewCDebuffTxt then unique=false; end
    end
    if unique then
        HealBot_Globals.HealBot_Custom_Debuffs[NewCDebuffTxt]=10;
    end
    HealBot_Globals.Custom_Debuff_Categories[NewCDebuffTxt]=HealBot_Options_StorePrev["CDebuffCatID"]
    HealBot_Options_NewCDebuff:SetText("")
    HealBot_Options_InitSub(406)
    UIDropDownMenu_SetSelectedValue(HealBot_Options_CDebuffTxt1, NewCDebuffTxt);
    HealBot_CheckAllDebuffs()
end

function HealBot_Options_ConfirmNewCDebuff()
    NewCDebuffTxt=strtrim(HealBot_Options_NewCDebuff:GetText())
    HealBot_Options_NewCDebuff:SetText(NewCDebuffTxt)
    if tonumber(NewCDebuffTxt) then
        NewCDebuffTxt = GetSpellInfo(NewCDebuffTxt)
        if not NewCDebuffTxt then 
            StaticPopup_Show ("HEALBOT_OPTIONS_ERROR", HEALBOT_SPELL_NOT_FOUND);
        else
            HealBot_Options_NewCDebuff:SetText(NewCDebuffTxt)
        end
    end
    if NewCDebuffTxt and NewCDebuffTxt ~= "" then
        StaticPopup_Show ("HEALBOT_OPTIONS_NEWCDEBUFF", NewCDebuffTxt);
    end
end

function HealBot_Options_DeleteCDebuffBtn_OnClick(self)
    HealBot_Globals.Custom_Debuff_Categories[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil;
    HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil;
    if HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]] then HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil end
    HealBot_Globals.HealBot_Custom_Debuffs_RevDur[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil
    HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil
    HealBot_clearDebuffTexture(HealBot_Options_StorePrev["CDebuffcustomName"])
    HealBot_Options_InitSub(406)
    HealBot_Options_InitSub(408)
    HealBot_SetCDCBarColours();
end

function HealBot_Options_EnableDisableCDBtn_OnClick(self)
    local InstName=HealBot_rethbInsName()
    if HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]] and HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]][InstName] then
        HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]][InstName]=nil
    else
        if not HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]] then
            HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]]={}
        end
        HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]][InstName]=true
    end
    HealBot_Options_SetEnableDisableCDBtn()
end

function HealBot_Options_SetEnableDisableCDBtn()
    local InstName=HealBot_rethbInsName()
    HealBot_Options_EnableDisableCDBtn:Enable()
    if HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]] and HealBot_Globals.IgnoreCustomDebuff[HealBot_Options_StorePrev["CDebuffcustomName"]][InstName] then
        HealBot_Options_EnableDisableCDText:SetTextColor(0.88,0.1,0.1)
        HealBot_Options_EnableDisableCDText:SetText(InstName..": "..HealBot_Options_StorePrev["CDebuffcustomName"].." "..HEALBOT_SKIN_DISTEXT)
        HealBot_Options_EnableDisableCDBtn:SetText(HEALBOT_WORD_ENABLE)
    elseif HealBot_Options_StorePrev["CDebuffcustomName"] then
        HealBot_Options_EnableDisableCDText:SetTextColor(0.1,1,0.1)
        HealBot_Options_EnableDisableCDText:SetText(InstName..": "..HealBot_Options_StorePrev["CDebuffcustomName"].." "..HEALBOT_SKIN_ENTEXT)
        HealBot_Options_EnableDisableCDBtn:SetText(HEALBOT_WORD_DISABLE)
    else
        HealBot_Options_EnableDisableCDText:SetTextColor(0.7,0.7,0)
        HealBot_Options_EnableDisableCDText:SetText(HEALBOT_WORDS_NONE)
        HealBot_Options_EnableDisableCDBtn:SetText(HEALBOT_WORDS_NONE)
        HealBot_Options_EnableDisableCDBtn:Disable()
    end
end

function HealBot_Options_RevDurCDebuffBtn_OnClick(self)
    if HealBot_Options_StorePrev["CDebuffcustomName"] then
        x= self:GetChecked() or 0
        if x==0 then
            HealBot_Globals.HealBot_Custom_Debuffs_RevDur[HealBot_Options_StorePrev["CDebuffcustomName"]] = nil
        else
            HealBot_Globals.HealBot_Custom_Debuffs_RevDur[HealBot_Options_StorePrev["CDebuffcustomName"]] = x
        end
    else
        HealBot_Options_CDCReverseDurC:SetChecked(HealBot_Globals.HealBot_Custom_Debuffs_RevDur[HealBot_Options_StorePrev["CDebuffcustomName"]] or 0)
    end
end

function HealBot_Options_ResetCDebuff()
    HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]]=10;
    if HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]] then HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]]=nil end
    HealBot_Options_InitSub(406)
    HealBot_Options_InitSub(408)
    HealBot_SetCDCBarColours();
end

function HealBot_Options_delCustomPrio10()
    for dName, x in pairs(HealBot_Globals.HealBot_Custom_Debuffs) do
        if x==10 then
            HealBot_Globals.Custom_Debuff_Categories[dName]=nil;
            HealBot_Globals.HealBot_Custom_Debuffs[dName]=nil;
            if HealBot_Globals.CDCBarColour[dName] then HealBot_Globals.CDCBarColour[dName]=nil end
        end
    end
    HealBot_Options_InitSub(406)
    HealBot_Options_InitSub(408)
    HealBot_SetCDCBarColours();
end

function HealBot_Options_setCustomDebuffList()
    local customPriority = {}
    local customDefaultCnt=0
    local customListPos=0
    local textname=nil
    for dName, x in pairs(HealBot_Globals.HealBot_Custom_Debuffs) do
        if HealBot_Globals.CDCBarColour[dName] or HealBot_Globals.HealBot_Custom_Debuffs[dName]~=10 then
            if not customPriority[x] then customPriority[x]={} end
            customPriority[x][dName]=dName
        else
            customDefaultCnt=customDefaultCnt+1
        end
    end
    x = HealBot_Config.HealBotDebuffPriority[HEALBOT_DISEASE_en]
    if not customPriority[x] then customPriority[x]={} end
    customPriority[x][HEALBOT_DISEASE_en]=HEALBOT_DISEASE
    x = HealBot_Config.HealBotDebuffPriority[HEALBOT_MAGIC_en]
    if not customPriority[x] then customPriority[x]={} end
    customPriority[x][HEALBOT_MAGIC_en]=HEALBOT_MAGIC
    x = HealBot_Config.HealBotDebuffPriority[HEALBOT_CURSE_en]
    if not customPriority[x] then customPriority[x]={} end
    customPriority[x][HEALBOT_CURSE_en]=HEALBOT_CURSE
    x = HealBot_Config.HealBotDebuffPriority[HEALBOT_POISON_en]
    if not customPriority[x] then customPriority[x]={} end
    customPriority[x][HEALBOT_POISON_en]=HEALBOT_POISON
    if customDefaultCnt>0 then
        if not customPriority[10] then customPriority[10]={} end
        customPriority[10][HEALBOT_CUSTOM_CAT_CUSTOM]=HEALBOT_CUSTOM_CAT_CUSTOM.." (x"..customDefaultCnt..")"
    end
    
    for j=1,20 do
        if customPriority[j] then
            for z, dName in pairs(customPriority[j]) do
                customListPos=customListPos+1
                if customListPos<31 then
                    textname=_G["HealBot_Options_CustomDebuff_List"..customListPos]
                    if j<10 then
                        textname:SetText("0"..j.." - "..dName)
                    else
                        textname:SetText(j.." - "..dName)
                    end
                    if HealBot_Globals.CDCBarColour[z] then
                        r=HealBot_Globals.CDCBarColour[z].R or 0.45
                        g=HealBot_Globals.CDCBarColour[z].G or 0
                        b=HealBot_Globals.CDCBarColour[z].B or 0.26
                    elseif HealBot_Config.CDCBarColour[z] then
                        r=HealBot_Config.CDCBarColour[z].R or 0.7
                        g=HealBot_Config.CDCBarColour[z].G or 0.2
                        b=HealBot_Config.CDCBarColour[z].B or 0.5
                    else
                        r=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].R or 0.45
                        g=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].G or 0
                        b=HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].B or 0.26
                    end
                    if r<0.2 and g<0.2 and b<0.2 then
                        r=r+0.4
                        g=g+0.4
                        b=b+0.4
                    elseif r<0.3 and g<0.3 and b<0.3 then
                        r=r+0.3
                        g=g+0.3
                        b=b+0.3
                    elseif r<0.4 and g<0.4 and b<0.4 then
                        r=r+0.2
                        g=g+0.2
                        b=b+0.2
                    elseif r<0.5 and g<0.5 and b<0.5 then
                        r=r+0.1
                        g=g+0.1
                        b=b+0.1
                    end
                    textname:SetTextColor(r,g,b,1)
                end
            end
        end
    end
    customListPos=customListPos+1
    for j=customListPos,30 do
        textname=_G["HealBot_Options_CustomDebuff_List"..j]
        textname:SetText(" ")
    end
end

----------------------------------------------------------------------------------

function HealBot_Options_getDropDownId_bySpec(ddId)
    return HealBot_Config.CurrentSpec..ddId
end

function HealBot_Options_ComboClass_Button(bNo)
    local button=nil
    if bNo==2 then 
        button = "Middle"
    elseif bNo==3 then 
        button = "Right"
    elseif bNo==4 then 
        button = "Button4"
    elseif bNo==5 then 
        button = "Button5"
    elseif bNo==6 then 
        button = "Button6"
    elseif bNo==7 then 
        button = "Button7"
    elseif bNo==8 then 
        button = "Button8"
    elseif bNo==9 then 
        button = "Button9"
    elseif bNo==10 then 
        button = "Button10"
    elseif bNo==11 then
        button = "Button11"
    elseif bNo==12 then
        button = "Button12"
    elseif bNo==13 then
        button = "Button13"
    elseif bNo==14 then
        button = "Button14"
    elseif bNo==15 then
        button = "Button15"
    else 
        button = "Left"
    end
    return button;
end

local usable=nil
local HealBot_DebuffWatchTargetSpell=nil
local FirstDebuffLoad=true
function HealBot_Options_Debuff_Reset()
    HealBot_DebuffWatchTarget[HEALBOT_DISEASE_en] = {HEALBOT_DISEASE_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_POISON_en] = {HEALBOT_POISON_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_MAGIC_en] = {HEALBOT_MAGIC_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_CURSE_en] = {HEALBOT_CURSE_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_CUSTOM_en] = {HEALBOT_CUSTOM_en = {}}; -- added by Diacono
    for x,_ in pairs(HealBot_DebuffSpell) do
        HealBot_DebuffSpell[x]=nil;
    end
    local DebuffTextClass = HealBot_Config.HealBotDebuffText
    local DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
    
    for k=1,3 do
        if DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)] and DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]>1 then
            local id=HealBot_GetSpellId(DebuffTextClass[HealBot_Options_getDropDownId_bySpec(k)]);
            sName,_ = HealBot_GetSpellName(id);
            if not sName then
                usable, _ = IsUsableItem(DebuffTextClass[HealBot_Options_getDropDownId_bySpec(k)]);
                if usable then
                    sName=DebuffTextClass[HealBot_Options_getDropDownId_bySpec(k)];
                end
            end
            if HealBot_Debuff_Types[sName] then
                table.foreach(HealBot_Debuff_Types[sName], function (i,dName)
                    
                    if not HealBot_DebuffSpell[dName] then
                        HealBot_DebuffSpell[dName]=sName;
                    end
                    HealBot_DebuffWatchTargetSpell=HealBot_DebuffWatchTarget[dName];

                    if DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==2 then
                        HealBot_DebuffWatchTargetSpell["Self"]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==3 then
                        HealBot_DebuffWatchTargetSpell["Party"]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==4 then
                        HealBot_DebuffWatchTargetSpell["Raid"]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==5 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==6 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==7 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==8 then
					    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MONK]]=true;
					elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==9 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==10 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==11 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==12 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==13 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==14 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==15 then
                        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==16 then
                        if HealBot_Globals.EmergIncMelee[HEALBOT_DRUID]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_HUNTER]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_MAGE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_PALADIN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_PRIEST]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_ROGUE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_SHAMAN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_WARLOCK]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_WARRIOR]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                        end
                        if HealBot_Globals.EmergIncMelee[HEALBOT_DEATHKNIGHT]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                        end
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==17 then
                        if HealBot_Globals.EmergIncRange[HEALBOT_DRUID]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_HUNTER]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_MAGE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_PALADIN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_PRIEST]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_ROGUE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_SHAMAN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_WARLOCK]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_WARRIOR]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                        end
                        if HealBot_Globals.EmergIncRange[HEALBOT_DEATHKNIGHT]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                        end
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==18 then
                        if HealBot_Globals.EmergIncHealers[HEALBOT_DRUID]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_HUNTER]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_MAGE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_PALADIN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_PRIEST]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_ROGUE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_SHAMAN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_WARLOCK]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_WARRIOR]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                        end
                        if HealBot_Globals.EmergIncHealers[HEALBOT_DEATHKNIGHT]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                        end
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==19 then
                        if HealBot_Globals.EmergIncCustom[HEALBOT_DRUID]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_HUNTER]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_MAGE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_PALADIN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_PRIEST]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_ROGUE]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_SHAMAN]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_WARLOCK]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_WARRIOR]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                        end
                        if HealBot_Globals.EmergIncCustom[HEALBOT_DEATHKNIGHT]==1 then
                            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                        end
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==20 then
                        HealBot_DebuffWatchTargetSpell["PvP"]=true
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==21 then
                        HealBot_DebuffWatchTargetSpell["PvE"]=true
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==22 then
                        HealBot_DebuffWatchTargetSpell["MainTanks"]=true
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==23 then
                        HealBot_DebuffWatchTargetSpell["MyTargets"]=true
                    elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==24 then
                        HealBot_DebuffWatchTargetSpell["Focus"]=true
					elseif DebuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==25 then
						HealBot_DebuffWatchTargetSpell["Name"]=true
                        if not FirstDebuffLoad then HealBot_Options_Get_deBuffWatchGUID(sName, "Debuff", k) end
                    end        
                end)
            end
        end
        HealBot_setOptions_Timer(20)
    end
    FirstDebuffLoad=nil
end


local spells={}
local Monitor_Buffs=nil
local HealBot_BuffWatchTargetSpell=nil
local FirstBuffLoad=true
function HealBot_Options_Buff_Reset()
    BuffTextClass = HealBot_Config.HealBotBuffText
    BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
    buffbarcolrClass = HealBot_Config.HealBotBuffColR
    buffbarcolgClass = HealBot_Config.HealBotBuffColG
    buffbarcolbClass = HealBot_Config.HealBotBuffColB
    Monitor_Buffs=false;
    for x,_ in pairs(spells) do
        spells[x]=nil;
    end
    HealBot_Clear_BuffWatch()
    for x,_ in pairs(HealBot_BuffWatchTarget) do
        HealBot_BuffWatchTarget[x]=nil;
    end
    for x,_ in pairs(HealBot_buffbarcolr) do
        HealBot_buffbarcolr[x]=nil;
    end
    for x,_ in pairs(HealBot_buffbarcolg) do
        HealBot_buffbarcolg[x]=nil;
    end
    for x,_ in pairs(HealBot_buffbarcolb) do
        HealBot_buffbarcolb[x]=nil;
    end
    HealBot_Tooltip_Clear_CheckBuffs()
    
    for k=1,10 do
        if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)] and BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]>1 then
            local id=HealBot_GetSpellId(BuffTextClass[HealBot_Options_getDropDownId_bySpec(k)]);
            sName = HealBot_GetSpellName(id);

            if sName then
                if not spells[sName] then
                    spells[sName]=sName;
                    HealBot_Set_BuffWatch(sName)
                    HealBot_BuffWatchTarget[sName] = {sName = {}};
                    Monitor_Buffs=true;
                end

                HealBot_BuffWatchTargetSpell=HealBot_BuffWatchTarget[sName];
                HealBot_Tooltip_CheckBuffs(sName)
        
                if BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==2 then
                    HealBot_BuffWatchTargetSpell["Self"]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==3 then
                    HealBot_BuffWatchTargetSpell["Party"]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==4 then
                    HealBot_BuffWatchTargetSpell["Raid"]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==5 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==6 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==7 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==8 then
					HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MONK]]=true;
				elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==9 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==10 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==11 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==12 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==13 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==14 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==15 then
                    HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==16 then
                    if HealBot_Globals.EmergIncMelee[HEALBOT_DRUID]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_HUNTER]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_MAGE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_PALADIN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_PRIEST]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_ROGUE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_SHAMAN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_WARLOCK]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_WARRIOR]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                    end
                    if HealBot_Globals.EmergIncMelee[HEALBOT_DEATHKNIGHT]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                    end
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==17 then
                    if HealBot_Globals.EmergIncRange[HEALBOT_DRUID]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_HUNTER]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_MAGE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_PALADIN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_PRIEST]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_ROGUE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_SHAMAN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_WARLOCK]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_WARRIOR]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                    end
                    if HealBot_Globals.EmergIncRange[HEALBOT_DEATHKNIGHT]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                    end
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==18 then
                    if HealBot_Globals.EmergIncHealers[HEALBOT_DRUID]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_HUNTER]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_MAGE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_PALADIN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_PRIEST]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_ROGUE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_SHAMAN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_WARLOCK]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_WARRIOR]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                    end
                    if HealBot_Globals.EmergIncHealers[HEALBOT_DEATHKNIGHT]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                    end
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==19 then
                    if HealBot_Globals.EmergIncCustom[HEALBOT_DRUID]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_HUNTER]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_MAGE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_PALADIN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_PRIEST]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_ROGUE]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_SHAMAN]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_WARLOCK]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_WARRIOR]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
                    end
                    if HealBot_Globals.EmergIncCustom[HEALBOT_DEATHKNIGHT]==1 then
                        HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DEATHKNIGHT]]=true;
                    end
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==20 then
                    HealBot_BuffWatchTargetSpell["PvP"]=true
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==21 then
                    HealBot_BuffWatchTargetSpell["PvE"]=true
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==22 then
                    HealBot_BuffWatchTargetSpell["MainTanks"]=true
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==23 then
                    HealBot_BuffWatchTargetSpell["MyTargets"]=true
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==24 then
                    HealBot_BuffWatchTargetSpell["Focus"]=true
                elseif BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(k)]==25 then
                    HealBot_BuffWatchTargetSpell["Name"]=true
                    if not FirstBuffLoad then HealBot_Options_Get_BuffWatchGUID(sName, "Buff", k) end
                end
                HealBot_buffbarcolr[sName]=buffbarcolrClass[k];
                HealBot_buffbarcolg[sName]=buffbarcolgClass[k];
                HealBot_buffbarcolb[sName]=buffbarcolbClass[k];
            elseif id then
                HealBot_AddDebug("Not found buff for spell id"..id)
            end
            HealBot_setOptions_Timer(30)
        end
    end
    FirstBuffLoad=nil
end

local BuffWatchSpell=" "
StaticPopupDialogs["HEALBOT_OPTIONS_BUFFNAMEDTITLE"] = {
    text = HEALBOT_OPTIONS_BUFFNAMED.."%s",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnShow = function(self)
        g=_G[self:GetName().."WideEditBox"] or _G[self:GetName().."EditBox"]
        g:SetText(HealBot_GuessName())
    end,
    OnAccept = function(self)
        g=_G[self:GetName().."WideEditBox"] or _G[self:GetName().."EditBox"]
        HealBot_Options_Set_BuffWatchGUID(g:GetText())
    end,
    OnCancel = function()
        -- do nothing
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    hasEditBox = 1,
    hasWideEditBox = 1,
};

local gName=nil
local gGUID=nil
local myTargets={}
function HealBot_GuessName()
    gName=nil
    gGUID=nil

    if HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell] and (type(HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell]) == "table") then
        tGUID=HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell]
        for uGUID,_ in pairs(tGUID) do
            if HealBot_UnitName[uGUID] then
                if gName then
                    gName=gName..","..HealBot_UnitName[uGUID]
                else
                    gName=HealBot_UnitName[uGUID]
                end
            end
        end
    end
    
    if not gName then
        if UnitName("Target") and HealBot_UnitName[HealBot_UnitGUID("Target")] then
            gName=UnitName("Target")
        end
        for j=1,10 do
            gGUID=HealBot_retHealBot_MainTanks(j)
            if HealBot_UnitName[gGUID] then
                if gName then 
                    gName=gName..","..HealBot_UnitName[gGUID]
                else
                    gName=HealBot_UnitName[gGUID]
                end
                do break end
            end
            if not gGUID then
                do break end
            end
        end
        for j=1,10 do
            gGUID=HealBot_retHealBot_CTRATanks(j)
            if HealBot_UnitName[gGUID] then
                if gName then 
                    gName=gName..","..HealBot_UnitName[gGUID]
                else
                    gName=HealBot_UnitName[gGUID]
                end
                do break end
            end
            if not gGUID then
                do break end
            end
        end
        myTargets=HealBot_GetMyHealTargets()
        x=true
        table.foreach(myTargets, function (i,myGUID)
            if HealBot_UnitName[myGUID] then
                if gName and x then 
                    gName=gName..","..HealBot_UnitName[gGUID]
                    x=nil
                elseif x then
                    gName=HealBot_UnitName[gGUID]
                end
            end  
        end)
        if not gName then
            if UnitName("Party1") and HealBot_UnitName[UnitGUID("Party1")] then
                gName=UnitName("Party1")
            elseif UnitName("Party2") and HealBot_UnitName[UnitGUID("Party2")] then
                gName=UnitName("Party2")
            elseif UnitName("Party3") and HealBot_UnitName[UnitGUID("Party3")] then
                gName=UnitName("Party3")
            elseif UnitName("Party4") and HealBot_UnitName[UnitGUID("Party4")] then
                gName=UnitName("Party4")
            end
        end
        if gName then 
            gName=gName..","..UnitName("Player")
        else
            gName=UnitName("Player")
        end
    end
	
	gName=(gName or "")..","..HEALBOT_SORTBY_NAME

    return gName
end

local BuffWatchType=nil
local BuffWatchID=nil
local Uname=nil
function HealBot_Options_Set_BuffWatchGUID(unitName)
    
    if BuffWatchType=="Buff" and HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell] then
        tGUID=HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell]
        if tGUID and type(tGUID)=="table" then
            for uGUID,_ in pairs(tGUID) do
                if HealBot_UnitBuff[uGUID] and HealBot_UnitBuff[uGUID]==BuffWatchSpell then
                    HealBot_UnitBuff[uGUID]=nil
                end
            end
        elseif tGUID then
            if HealBot_UnitBuff[tGUID] and HealBot_UnitBuff[tGUID]==BuffWatchSpell then
                HealBot_UnitBuff[tGUID]=nil
            end
        end
    end

    if strfind(unitName,",") then tName = HealBot_Split(unitName, ","); end
    tGUID={}

    if tName and type(tName)=="table" then
        for _,uName in pairs(tName) do
            uName=HealBot_Options_CleanName(uName)
            if HealBot_Derive_GUID_fuName(uName) then
                tinsert(tGUID, HealBot_Derive_GUID_fuName(uName));
            end
        end
    elseif tName then
        tName=HealBot_Options_CleanName(tName)
        if HealBot_Derive_GUID_fuName(tName) then
            tinsert(tGUID, HealBot_Derive_GUID_fuName(tName));
        end
    end
    
    HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell]={}
    
    for _,uGUID in pairs(tGUID) do
        if HealBot_UnitID[uGUID] then
            HealBot_Config.HealBot_BuffWatchGUID[BuffWatchSpell][uGUID]=uGUID 
            HealBot_Queue_MyBuffsCheck(uGUID, HealBot_UnitID[uGUID])
        end
    end
end

function HealBot_Options_CleanName(unitName)
    Uname=strtrim(unitName)
    Uname=strupper(strsub(Uname, 1, 1))..strlower(strsub(Uname, 2))
    return Uname
end

function HealBot_Options_Get_BuffWatchGUID(spellName, BuffType, ddID)
    if not ClickedBuffGroupDD or ClickedBuffGroupDD~=ddID then return end
    BuffWatchSpell=spellName
    BuffWatchType=BuffType
    BuffWatchID=ddID
    StaticPopup_Show ("HEALBOT_OPTIONS_BUFFNAMEDTITLE", BuffWatchSpell);
    ClickedBuffGroupDD=nil
end

function HealBot_Options_Get_deBuffWatchGUID(spellName, BuffType, ddID)
    if not ClickedBuffGroupDD or ClickedBuffGroupDD~=ddID then return end
    BuffWatchSpell=spellName
    BuffWatchType=BuffType
    BuffWatchID=ddID
    StaticPopup_Show ("HEALBOT_OPTIONS_BUFFNAMEDTITLE", BuffWatchSpell);
    ClickedBuffGroupDD=nil
end

function HealBot_Options_RetBuffRGB(spellName)
    return HealBot_buffbarcolr[spellName],HealBot_buffbarcolg[spellName],HealBot_buffbarcolb[spellName];
end

function HealBot_Colorpick_OnClick(CDCType)
    HealBot_ColourObjWaiting=CDCType;
    if CDCType==HEALBOT_CUSTOM_en then
        if HealBot_Options_StorePrev["CDebuffcustomName"] then
            HealBot_ColourObjWaiting=HealBot_Options_StorePrev["CDebuffcustomName"]
            if not HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]] then 
                HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]]={}
                HealBot_UseColourPick(HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].R,HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].G,HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].B, nil)
            else
                HealBot_UseColourPick(HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].R,
                                      HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].G,
                                      HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].B, nil)
            end
        else
            HealBot_UseColourPick(HealBot_Globals.CDCBarColour[CDCType].R,HealBot_Globals.CDCBarColour[CDCType].G,HealBot_Globals.CDCBarColour[CDCType].B, nil)
        end
    else
        HealBot_UseColourPick(HealBot_Config.CDCBarColour[CDCType].R,HealBot_Config.CDCBarColour[CDCType].G,HealBot_Config.CDCBarColour[CDCType].B, nil)
    end
end

local R=nil
local G=nil
local B=nil
local A=nil
local setskincols=true
function HealBot_Returned_Colours(R, G, B, A)
  --R, G, B = ColorPickerFrame:GetColorRGB(); -- added by Diacono
  --A = OpacitySliderFrame:GetValue();
    if A then
        A = ((0-A)+1);
    end
    setskincols=true;
    if HealBot_ColourObjWaiting=="En" then
        Healbot_Config_Skins.btextenabledcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextenabledcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextenabledcolb[Healbot_Config_Skins.Current_Skin], 
        Healbot_Config_Skins.btextenabledcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
    elseif HealBot_ColourObjWaiting=="Dis" then
        Healbot_Config_Skins.btextdisbledcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextdisbledcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextdisbledcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextdisbledcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
    elseif HealBot_ColourObjWaiting=="Debuff" then
        Healbot_Config_Skins.btextcursecolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextcursecolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextcursecolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.btextcursecola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
    elseif HealBot_ColourObjWaiting=="Back" then
        Healbot_Config_Skins.backcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.backcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
    elseif HealBot_ColourObjWaiting=="Bor" then
        Healbot_Config_Skins.borcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.borcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
    elseif HealBot_ColourObjWaiting=="HeadB" then
        Healbot_Config_Skins.headbarcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headbarcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
        HealBot_setOptions_Timer(150)
    elseif HealBot_ColourObjWaiting=="HeadT" then
        Healbot_Config_Skins.headtxtcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcolb[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.headtxtcola[Healbot_Config_Skins.Current_Skin] = R, G, B, A;
        HealBot_setOptions_Timer(150)
    elseif HealBot_ColourObjWaiting=="CustomBar" then
        Healbot_Config_Skins.barcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.barcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.barcolb[Healbot_Config_Skins.Current_Skin] = R, G, B;
        HealBot_Action_ResetUnitStatus()
    elseif HealBot_ColourObjWaiting=="CustomIHBar" then
        Healbot_Config_Skins.ihbarcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.ihbarcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.ihbarcolb[Healbot_Config_Skins.Current_Skin] = R, G, B;
    elseif HealBot_ColourObjWaiting=="HighlightBar" then
        Healbot_Config_Skins.highcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.highcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.highcolb[Healbot_Config_Skins.Current_Skin] = R, G, B;
        HealBot_Action_SetHightlightAggroCols()
    elseif HealBot_ColourObjWaiting=="HighlightTargetBar" then
        Healbot_Config_Skins.targetcolr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.targetcolg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.targetcolb[Healbot_Config_Skins.Current_Skin] = R, G, B;
        HealBot_Action_SetHightlightTargetAggroCols()
    elseif HealBot_ColourObjWaiting=="Aggro" then
        Healbot_Config_Skins.AggroColr[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.AggroColg[Healbot_Config_Skins.Current_Skin],
        Healbot_Config_Skins.AggroColb[Healbot_Config_Skins.Current_Skin] = R, G, B;
        HealBot_Action_SetAggroCols()
    elseif strsub(HealBot_ColourObjWaiting ,1,4)=="Buff" then
        local id=tonumber(strsub(HealBot_ColourObjWaiting ,5));
        buffbarcolrClass = HealBot_Config.HealBotBuffColR
        buffbarcolgClass = HealBot_Config.HealBotBuffColG
        buffbarcolbClass = HealBot_Config.HealBotBuffColB
        buffbarcolrClass[id],
        buffbarcolgClass[id],
        buffbarcolbClass[id] = R, G, B;
        HealBot_setOptions_Timer(100)
        setskincols=false;
    elseif HealBot_ColourObjWaiting==HEALBOT_CUSTOM_en or HealBot_ColourObjWaiting==HealBot_Options_StorePrev["CDebuffcustomName"] then
        HealBot_Globals.CDCBarColour[HealBot_ColourObjWaiting].R,
        HealBot_Globals.CDCBarColour[HealBot_ColourObjWaiting].G,
        HealBot_Globals.CDCBarColour[HealBot_ColourObjWaiting].B = R, G, B;
        HealBot_SetCDCBarColours();
        setskincols=false;
    else
        HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].R,
        HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].G,
        HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].B = R, G, B;
        HealBot_SetCDCBarColours();
        setskincols=false;
    end
    if setskincols then
        HealBot_setOptions_Timer(90)
    end
end

HealBot_Options_StorePrev["prevR"] = nil
HealBot_Options_StorePrev["prevG"] = nil
HealBot_Options_StorePrev["prevB"] = nil
HealBot_Options_StorePrev["prevA"] = nil
function HealBot_UseColourPick(R, G, B, A)
    if not R then R=1 end
    if not G then G=1 end
    if not B then B=1 end
    HealBot_Options_StorePrev["prevR"], HealBot_Options_StorePrev["prevG"], HealBot_Options_StorePrev["prevB"], HealBot_Options_StorePrev["prevA"] = R, G, B, A;
    if ColorPickerFrame:IsVisible() then 
        ColorPickerFrame:Hide();
    elseif A then
        ColorPickerFrame.hasOpacity = true;
        ColorPickerFrame.opacity = 1-A;
        ColorPickerFrame.func = function() local lR,lG,lB=ColorPickerFrame:GetColorRGB(); local lA=OpacitySliderFrame:GetValue() HealBot_Returned_Colours(lR,lG,lB,lA); end;
        ColorPickerFrame.opacityFunc = function() local lR,lG,lB=ColorPickerFrame:GetColorRGB(); local lA=OpacitySliderFrame:GetValue() HealBot_Returned_Colours(lR,lG,lB,lA); end;
        ColorPickerFrame.cancelFunc = function() HealBot_Returned_Colours(HealBot_Options_StorePrev["prevR"], HealBot_Options_StorePrev["prevG"], HealBot_Options_StorePrev["prevB"], 1-HealBot_Options_StorePrev["prevA"]); end; --added by Diacono
        ColorPickerFrame:ClearAllPoints();
        ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
        OpacitySliderFrame:SetValue(1-A);
        ColorPickerFrame:SetColorRGB(R, G, B);
        ColorPickerFrame:Show();
    else
        ColorPickerFrame.hasOpacity = false;
        ColorPickerFrame.func = function() HealBot_Returned_Colours(ColorPickerFrame:GetColorRGB()); end;
        ColorPickerFrame.cancelFunc = function() HealBot_Returned_Colours(HealBot_Options_StorePrev["prevR"], HealBot_Options_StorePrev["prevG"], HealBot_Options_StorePrev["prevB"]); end; --added by Diacono
        ColorPickerFrame:ClearAllPoints();
        ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
        ColorPickerFrame:SetColorRGB(R, G, B);
        ColorPickerFrame:Show();
    end
    return ColorPickerFrame:GetColorRGB();
end

function HealBot_SetCDCBarColours()
    HealBot_DiseaseColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].R or 0.55,
                                               HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].G or 0.19,
                                               HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].B or 0.7,
                                               Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_MagicColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].R or 0.26,
                                             HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].G or 0.33,
                                             HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].B or 0.83,
                                             Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_PoisonColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_POISON_en].R or 0.12,
                                              HealBot_Config.CDCBarColour[HEALBOT_POISON_en].G or 0.46,
                                              HealBot_Config.CDCBarColour[HEALBOT_POISON_en].B or 0.24,
                                              Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_CurseColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].R or 0.83,
                                             HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].G or 0.43,
                                             HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].B or 0.09,
                                             Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    if HealBot_Options_StorePrev["CDebuffcustomName"] and HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]] then
        HealBot_CustomColorpick:SetStatusBarColor(HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].R or 0.45,
                                                 HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].G or 0,
                                                 HealBot_Globals.CDCBarColour[HealBot_Options_StorePrev["CDebuffcustomName"]].B or 0.26,
                                                 Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    else
        HealBot_CustomColorpick:SetStatusBarColor(HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].R or 0.45,
                                                 HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].G or 0,
                                                 HealBot_Globals.CDCBarColour[HEALBOT_CUSTOM_en].B or 0.26,
                                                 Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    end
    HealBot_DebTextColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].R or 0.1,
                                               HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].G or 0.05,
                                               HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].B or 0.2,
                                               Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
    HealBot_Action_SetDebuffAggroCols()
    HealBot_Options_setCustomDebuffList()
end

function HealBot_SetBuffBarColours()
    buffbarcolrClass = HealBot_Config.HealBotBuffColR
    buffbarcolgClass = HealBot_Config.HealBotBuffColG
    buffbarcolbClass = HealBot_Config.HealBotBuffColB

    for k=1,10 do
        bar=_G["HealBot_Buff"..k.."Colour"]
        if bar then
            bar:SetStatusBarColor(buffbarcolrClass[k],
                                  buffbarcolgClass[k],
                                  buffbarcolbClass[k],
                                  Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin]);
        end
    end
    HealBot_setOptions_Timer(40)
end
--------------------------------------------------------------------------------

function HealBot_Options_NotifyChan_OnTextChanged(self)
    Healbot_Config_Skins.NotifyChan[Healbot_Config_Skins.Current_Skin] = self:GetText()
end

function HealBot_SpellAutoButton_OnClick(self, autoType, autoMod)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        if autoType=="Target" then combo = HealBot_Config.EnabledSpellTarget;
        elseif autoType=="Trinket1" then combo = HealBot_Config.EnabledSpellTrinket1;
        else combo = HealBot_Config.EnabledSpellTrinket2; end
    else
        if autoType=="Target" then combo = HealBot_Config.DisabledSpellTarget;
        elseif autoType=="Trinket1" then combo = HealBot_Config.DisabledSpellTrinket1;
        else combo = HealBot_Config.DisabledSpellTrinket2; end
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    combo[autoMod..button..HealBot_Config.CurrentSpec] = self:GetChecked() or 0;
    HealBot_setOptions_Timer(400)
end

local spellText=nil
function HealBot_Options_Click_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo[button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_Shift_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Shift"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_Ctrl_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Ctrl"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_Alt_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Alt"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_CtrlShift_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Ctrl-Shift"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_AltShift_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Alt-Shift"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_CtrlAlt_OnTextChanged(self)
    local combo=nil
    if HealBot_Options_StorePrev["ActionBarsCombo"]==1 then
        combo = HealBot_Config.EnabledKeyCombo;
    else
        combo = HealBot_Config.DisabledKeyCombo;
    end
    local button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
    spellText = strtrim(self:GetText())
    combo["Alt-Ctrl"..button..HealBot_Config.CurrentSpec] = spellText
    if HealBot_GetSpellId(spellText) then
        HealBot_setOptions_Timer(70)
        HealBot_setOptions_Timer(400)
    elseif GetMacroIndexByName(spellText) or IsUsableItem(spellText) then
        HealBot_setOptions_Timer(400)
    end
    HealBot_Options_SoftReset_flag=true
end

function HealBot_Options_EnableHealthy_OnClick(self)
    HealBot_Config.EnableHealthy = self:GetChecked() or 0;
    HealBot_Action_ResetUnitStatus();
end

function HealBot_Options_EnableMouseWheel_OnClick(self)
    HealBot_Globals.HealBot_Enable_MouseWheel = self:GetChecked() or 0;
    StaticPopup_Show ("HEALBOT_OPTIONS_RELOADUI");
end

function HealBot_Options_EnableSmartCast_OnClick(self)
    HealBot_Globals.SmartCast = self:GetChecked() or 0;
end

function HealBot_Options_SmartCastDisspell_OnClick(self)
    HealBot_Globals.SmartCastDebuff = self:GetChecked() or 0;
end

function HealBot_Options_SmartCastBuff_OnClick(self)
    HealBot_Globals.SmartCastBuff = self:GetChecked() or 0;
end

function HealBot_Options_SmartCastHeal_OnClick(self)
    HealBot_Globals.SmartCastHeal = self:GetChecked() or 0;
end

function HealBot_Options_SmartCastRes_OnClick(self)
    HealBot_Globals.SmartCastRes = self:GetChecked() or 0;
end

local HealBot_CombosKeys_List = {"","Shift","Ctrl","Alt","Ctrl-Shift","Alt-Shift"}
local HB_combo_prefix=nil
local SpellTxtE=nil
local SpellTxtD=nil
local SpellTxtB=nil
local HB_button=nil
function HealBot_Options_CheckCombos()  

    local id=0;
  
    for j=1,15 do
        HB_button=HealBot_Options_ComboClass_Button(j)
    
        for x=1, getn(HealBot_CombosKeys_List), 1 do
            HB_combo_prefix = HealBot_CombosKeys_List[x]..HB_button..HealBot_Config.CurrentSpec

            SpellTxtE = HealBot_Action_AttribSpellPattern(HB_combo_prefix)
            SpellTxtD = HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
      
            if SpellTxtE then
                if not HealBot_Spells[SpellTxtE] then
                    if not HealBot_OtherSpells[SpellTxtE] then
                        id = HealBot_GetSpellId(SpellTxtE);
                        if id then
                            HealBot_FindSpellRangeCast(id);
                        end
                    end
                end
            end
            if SpellTxtD then
                if not HealBot_Spells[SpellTxtD] then
                    if not HealBot_OtherSpells[SpellTxtD] then
                        id = HealBot_GetSpellId(SpellTxtD);
                        if id then
                            HealBot_FindSpellRangeCast(id);
                        end
                    end
                end
            end
        end
    end
end

--------------------------------------------------------------------------------

StaticPopupDialogs["HEALBOT_OPTIONS_SETDEFAULTS"] = {
    text = HEALBOT_OPTIONS_SETDEFAULTSMSG,
    button1 = HEALBOT_WORDS_YES,
    button2 = HEALBOT_WORDS_NO,
    OnAccept = function()
        HealBot_Options_SetDefaults();
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
};

function HealBot_Options_Defaults_OnClick(self)
    StaticPopup_Show ("HEALBOT_OPTIONS_SETDEFAULTS");
end

function HealBot_Options_Reset_OnClick(self,mode)
    HealBot_SetResetFlag(mode)
end

function HealBot_Options_Info_OnClick(self)
    HealBot_Comms_Info()
end

function HealBot_Options_SetDefaults()
    HealBot_Config = HealBot_ConfigDefaults;
    HealBot_Globals = HealBot_GlobalsDefaults;
    if Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin] then HealBot_Options_CastNotify_OnClick(nil,0); end
--    table.foreach(HealBot_ConfigDefaults, function (x,val)
--        HealBot_Config[x] = val;
--    end);
--    table.foreach(HealBot_GlobalsDefaults, function (x,val)
--        HealBot_Globals[x] = val;
--    end);
    table.foreach(HealBot_Config_SkinsDefaults, function (key,val)
        if not Healbot_Config_Skins[key] then
            Healbot_Config_Skins[key] = val;
        end
    end);
    HealBot_InitNewChar(HealBot_PlayerClassEN)
    HealBot_Config.CurrentSpec=1
    HealBot_Update_SpellCombos()
    HealBot_Update_BuffsForSpec()
    for x,_ in pairs(HealBot_UnitDebuff) do
        HealBot_UnitDebuff[x]=nil;
    end
    for x,_ in pairs(HealBot_UnitBuff) do
        HealBot_UnitBuff[x]=nil;
    end
    HealBot_Options_Opened=false;
    HealBot_Action_Reset();
    HealBot_ClearAllBuffs()
    HealBot_ClearAllDebuffs()
    ShowUIPanel(HealBot_Action)
    HealBot_Action_SetAllAttribs()
    HideUIPanel(HealBot_Options)
    HealBot_Config.ActionVisible = HealBot_Action:IsVisible();
    DoneInitTab={}
    HealBot_setOptions_Timer(8000)
end

function HealBot_Options_OnLoad(self, panelNum)
   -- table.insert(UISpecialFrames,self:GetName());
    DoneInitTab={}
   -- HealBot_setOptions_Timer(8000)
  -- Tabs
    PanelTemplates_SetNumTabs(self,7);
    self.selectedTab = 1; 
    PanelTemplates_UpdateTabs(HealBot_Options);   

    g=_G["HealBot_Options_HeadersSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_IconsSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_HealingSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_ProtSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_ChatSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_BarsSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_TextSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_AggroSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_IconTextSkinsFrame"]
    g:Hide()
    g=_G["HealBot_Options_CustomCureFrame"]
    g:Hide()
    g=_G["HealBot_Options_WarningCureFrame"]
    g:Hide()
    g=_G["HealBot_Options_HealSortFrame"]
    g:Hide()
    g=_G["HealBot_Options_HealRaidFrame"]
    g:Hide()
    g=_G["HealBot_Options_HealHideFrame"]
    g:Hide()
    g=_G["HealBot_SkinsFrameSelectGeneralFramef"]
    g:SetTextColor(1,1,1,1)
    g=_G["HealBot_SkinsFrameSelectHealingFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectProtFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectChatFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectHeadersFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectBarsFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectTextFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectIconsFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectIconTextFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsFrameSelectAggroFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_CureFrameSelectDebuffFramef"]
    g:SetTextColor(1,1,1,1)
    g=_G["HealBot_CureFrameSelectCustomFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_CureFrameSelectWarningFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsSubFrameSelectHealAlertFramef"]
    g:SetTextColor(1,1,1,1)
    g=_G["HealBot_SkinsSubFrameSelectHealRaidFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsSubFrameSelectHealSortFramef"]
    g:SetTextColor(1,1,0,0.92)
    g=_G["HealBot_SkinsSubFrameSelectHealHideFramef"]
    g:SetTextColor(1,1,0,0.92)
end

function HealBot_Options_OnShow(self)
    HealBot_Options_ShowPanel(self, self.selectedTab)
end

function HealBot_Options_Close()
    if HealBot_Options_SoftReset_flag then
        HealBot_Options_SoftReset_flag=false
        HealBot_setOptions_Timer(400)
    end
end

function HealBot_Options_idleInit()
    if not DoneInitTab[0] then
        if HealBot_Globals.preloadOptions==1 then
            DoneInitTab[0]=100
        else
            DoneInitTab[0]=9999
        end
        HealBot_Options_UpdateMedia(3)
    elseif DoneInitTab[0]>0 then
        if not UIDROPDOWNMENU_OPEN_MENU then
            DoneInitTab[0]=DoneInitTab[0]+1
            if DoneInitTab[0]>102 and DoneInitTab[0]<199 then
                DoneInitTab[0]=200
            elseif DoneInitTab[0]>203 and DoneInitTab[0]<299 then
                DoneInitTab[0]=300
            elseif DoneInitTab[0]>324 and DoneInitTab[0]<399 then
                DoneInitTab[0]=400
            elseif DoneInitTab[0]>418 and DoneInitTab[0]<499 then
                DoneInitTab[0]=500
            elseif DoneInitTab[0]>520 and DoneInitTab[0]<599 then
                DoneInitTab[0]=700
            elseif DoneInitTab[0]>708 and DoneInitTab[0]<799 then
                DoneInitTab[0]=800
            elseif DoneInitTab[0]>805 then
                DoneInitTab[0]=0
            else
                HealBot_Options_InitSub(DoneInitTab[0])
            end
        end
    else
        return nil
    end
    return true
end

function HealBot_Options_idleInitMod()
    if HealBot_Globals.preloadOptions==1 then
        DoneInitTab[0]=nil
        HealBot_setOptions_Timer(8000)
    elseif DoneInitTab[0] and DoneInitTab[0]>0 then
        DoneInitTab[0]=9999
    end
end

function HealBot_Options_ResetDoInittab(tabNo)
    HealBot_AddDebug("ResetDoInittab tabNo="..tabNo)
    if tabNo==1 then
        DoneInitTab[1]=nil
        DoneInitTab[101]=nil
        DoneInitTab[102]=nil
    elseif tabNo==2 then
        DoneInitTab[2]=nil
        DoneInitTab[21]=nil
        DoneInitTab[201]=nil
        DoneInitTab[202]=nil
        DoneInitTab[203]=nil
    elseif tabNo==3 then
        DoneInitTab[3]=nil
        DoneInitTab[301]=nil
        DoneInitTab[302]=nil
        DoneInitTab[303]=nil
        DoneInitTab[304]=nil
        DoneInitTab[305]=nil
        DoneInitTab[306]=nil
        DoneInitTab[307]=nil
        DoneInitTab[308]=nil
        DoneInitTab[309]=nil
        DoneInitTab[310]=nil
        DoneInitTab[311]=nil
        DoneInitTab[312]=nil
        DoneInitTab[313]=nil
        DoneInitTab[314]=nil
        DoneInitTab[315]=nil
        DoneInitTab[316]=nil
        DoneInitTab[317]=nil
        DoneInitTab[319]=nil
        DoneInitTab[320]=nil
        DoneInitTab[321]=nil
        DoneInitTab[322]=nil
        DoneInitTab[323]=nil
        DoneInitTab[324]=nil
        DoneInitTab[1001]=nil
        DoneInitTab[1002]=nil
        DoneInitTab[1003]=nil
        DoneInitTab[1004]=nil
        DoneInitTab[1005]=nil
        DoneInitTab[1006]=nil
        DoneInitTab[1007]=nil
        DoneInitTab[1008]=nil
        DoneInitTab[1009]=nil
        DoneInitTab[1010]=nil
    elseif tabNo==4 then
        DoneInitTab[4]=nil
        DoneInitTab[409]=nil
        DoneInitTab[411]=nil
        DoneInitTab[413]=nil
        if HealBot_Globals.preloadOptions==1 then
            if DoneInitTab[0] and (DoneInitTab[0]==0 or DoneInitTab[0]>408) then DoneInitTab[0]=408 end
            HealBot_setOptions_Timer(8000)
        end
    elseif tabNo==5 then
        DoneInitTab[5]=nil
        DoneInitTab[501]=nil
        DoneInitTab[503]=nil
        DoneInitTab[505]=nil
        DoneInitTab[507]=nil
        DoneInitTab[509]=nil
        DoneInitTab[511]=nil
        DoneInitTab[513]=nil
        DoneInitTab[515]=nil
        DoneInitTab[517]=nil
        DoneInitTab[519]=nil
        if HealBot_Globals.preloadOptions==1 then
            if DoneInitTab[0] and (DoneInitTab[0]==0 or DoneInitTab[0]>500) then DoneInitTab[0]=500 end
            HealBot_setOptions_Timer(8000)
        end
    elseif tabNo==6 then
        DoneInitTab[6]=nil
    elseif tabNo==7 then
        DoneInitTab[7]=nil
        DoneInitTab[701]=nil
        DoneInitTab[702]=nil
        DoneInitTab[703]=nil
        DoneInitTab[704]=nil
        DoneInitTab[705]=nil
        DoneInitTab[706]=nil
        DoneInitTab[707]=nil
        DoneInitTab[708]=nil
    elseif tabNo==9 then
        DoneInitTab[9]=nil
    elseif tabNo==40 then
        DoneInitTab[4]=nil
        DoneInitTab[410]=nil
        DoneInitTab[412]=nil
        DoneInitTab[414]=nil
        if HealBot_Globals.preloadOptions==1 then
            if DoneInitTab[0] and (DoneInitTab[0]==0 or DoneInitTab[0]>409) then DoneInitTab[0]=409 end
            HealBot_setOptions_Timer(8000)
        end
    elseif tabNo==50 then
        DoneInitTab[5]=nil
        DoneInitTab[502]=nil
        DoneInitTab[504]=nil
        DoneInitTab[506]=nil
        DoneInitTab[508]=nil
        DoneInitTab[510]=nil
        DoneInitTab[512]=nil
        DoneInitTab[514]=nil
        DoneInitTab[516]=nil
        DoneInitTab[518]=nil
        DoneInitTab[520]=nil
        if HealBot_Globals.preloadOptions==1 then
            if DoneInitTab[0] and (DoneInitTab[0]==0 or DoneInitTab[0]>501) then DoneInitTab[0]=501 end
            HealBot_setOptions_Timer(8000)
        end
    else
        DoneInitTab[10]=nil
        HealBot_Options_SelectSpellsFrame:Hide()
        HealBot_Options_KeysFrame:Show()
        DoneInitTab[801]=nil
        DoneInitTab[802]=nil
        DoneInitTab[803]=nil
        DoneInitTab[804]=nil
        DoneInitTab[805]=nil
    end
    if HealBot_Options:IsVisible() then
        HealBot_Options_Init(tabNo)
    end
end

function HealBot_Options_Init(tabNo)
    if tabNo==1 then
        if not DoneInitTab[1] then
            HealBot_Options_NoAuraWhenRested:SetChecked(HealBot_Config.NoAuraWhenRested)
            HealBot_Options_ShowMinimapButton:SetChecked(HealBot_Globals.ButtonShown)
            HealBot_Options_QueryTalents:SetChecked(HealBot_Globals.QueryTalents)
            HealBot_Options_HideOptions:SetChecked(HealBot_Globals.HideOptions)
            HealBot_Options_RightButtonOptions:SetChecked(HealBot_Globals.RightButtonOptions)
            HealBot_Options_EnableLibQuickHealth:SetChecked(HealBot_Globals.EnLibQuickHealth)
            HealBot_Options_RangeCheckFreq:SetValue((HealBot_Globals.RangeCheckFreq or 0.2)*10)
            HealBot_Options_InitSub(102)
            HealBot_Options_EFClass_Reset()
            HealBot_Options_InitSub(101)
            DoneInitTab[1]=true
        end
        CPUProfiler=GetCVar("scriptProfile")
        HealBot_Options_CPUProfiler:SetChecked(CPUProfiler)
    elseif tabNo==2 and not DoneInitTab[2] then
        if not DoneInitTab[21] then
            HealBot_Options_InitSub(201)
            HealBot_Options_InitSub(202)
            HealBot_Options_InitSub(203)
            HealBot_Options_EnableHealthy:SetChecked(HealBot_Config.EnableHealthy)
            DoneInitTab[21]=true
        end
        HealBot_Options_ComboClass_Text()
        DoneInitTab[2]=true
    elseif tabNo==4 and not DoneInitTab[4] then
        if not DoneInitTab[415] then
            HealBot_Options_InitSub(401)
            HealBot_Options_InitSub(402)
            HealBot_Options_InitSub(403)
            HealBot_Options_InitSub(404)
            HealBot_Options_InitSub(405)
            HealBot_Options_InitSub(406)
            HealBot_Options_InitSub(407)
            HealBot_Options_InitSub(408)
            HealBot_Options_IgnoreDebuffsDuration:SetChecked(HealBot_Config.IgnoreFastDurDebuffs)
            HealBot_Options_IgnoreDebuffsMovement:SetChecked(HealBot_Config.IgnoreMovementDebuffs)
            HealBot_Options_IgnoreDebuffsDurationSecs:SetValue(HealBot_Config.IgnoreFastDurDebuffsSecs)
            HealBot_Options_IgnoreDebuffsNoHarm:SetChecked(HealBot_Config.IgnoreNonHarmfulDebuffs)
            HealBot_Options_IgnoreDebuffsClass:SetChecked(HealBot_Config.IgnoreClassDebuffs)
            HealBot_Options_MonitorDebuffsInCombat:SetChecked(HealBot_Config.DebuffWatchInCombat)
            HealBot_Options_ShowDebuffWarning:SetChecked(HealBot_Config.ShowDebuffWarning)
            HealBot_Options_SoundDebuffWarning:SetChecked(HealBot_Config.SoundDebuffWarning)
            HealBot_Options_WarningSound:SetValue(soundsIndex[HealBot_Config.SoundDebuffPlay] or 0);
            HealBot_Options_CDCCol_ShowOnAggroBar:SetChecked(HealBot_Config.CDCshownAB)
            HealBot_Options_CDCCol_ShowOnHealthBar:SetChecked(HealBot_Config.CDCshownHB)
            HealBot_Options_MonitorDebuffs:SetChecked(HealBot_Config.DebuffWatch)
            HealBot_Options_InitSub(415)
            HealBot_Options_InitSub(416)
            HealBot_Options_InitSub(417)
            HealBot_Options_InitSub(418)
            HealBot_SetCDCBarColours()
            DoneInitTab[415]=true
        end
        HealBot_Options_InitSub(409)
        HealBot_Options_InitSub(410)
        HealBot_Options_InitSub(411)
        HealBot_Options_InitSub(412)
        HealBot_Options_InitSub(413)
        HealBot_Options_InitSub(414)
        DoneInitTab[4]=true
    elseif tabNo==3 then
        if not DoneInitTab[3] then
            HealBot_Options_UpdateMedia(tabNo)
            HealBot_Options_NewSkinb:Disable()
            HealBot_Options_InitSub(319)
            HealBot_Options_CrashProtEditBox:SetText(HealBot_Config.CrashProtMacroName)
            HealBot_Options_CrashProtStartTime:SetValue(HealBot_Config.CrashProtStartTime)
            DoneInitTab[3]=true
        end
        HealBot_Options_InitSub(318)
    elseif tabNo==6 and not DoneInitTab[6] then
        HealBot_Options_ShowTooltip:SetChecked(HealBot_Globals.ShowTooltip)
        HealBot_Options_ShowTooltipUpdate:SetChecked(HealBot_Globals.TooltipUpdate)
        HealBot_Options_HideTooltipInCombat:SetChecked(HealBot_Globals.DisableToolTipInCombat)
        HealBot_Options_ShowTooltipTarget:SetChecked(HealBot_Globals.Tooltip_ShowTarget)
        HealBot_Options_ShowTooltipMyBuffs:SetChecked(HealBot_Globals.Tooltip_ShowMyBuffs)
        HealBot_Options_ShowTooltipSpellDetail:SetChecked(HealBot_Globals.Tooltip_ShowSpellDetail)
        HealBot_Options_ShowTooltipSpellCoolDown:SetChecked(HealBot_Globals.Tooltip_ShowCD)
        HealBot_Options_ShowTooltipInstant:SetChecked(HealBot_Globals.Tooltip_Recommend)
        HealBot_Options_ShowTooltipUseGameTip:SetChecked(HealBot_Globals.UseGameTooltip)
        HealBot_Options_ShowTooltipShowHoT:SetChecked(HealBot_Globals.Tooltip_ShowHoT)
        HealBot_Options_InitSub(317)
        HealBot_Options_TTAlpha:SetValue(HealBot_Globals.ttalpha)
        DoneInitTab[6]=true
    elseif tabNo==5 and not DoneInitTab[5] then
        if not DoneInitTab[521] then
            HealBot_Options_MonitorBuffsInCombat:SetChecked(HealBot_Config.BuffWatchInCombat)
            HealBot_Options_LongBuffTimer:SetValue(HealBot_Config.LongBuffTimer)
            HealBot_Options_ShortBuffTimer:SetValue(HealBot_Config.ShortBuffTimer)
            HealBot_Options_MonitorBuffs:SetChecked(HealBot_Config.BuffWatch)
            DoneInitTab[521]=true
        end
        HealBot_Options_InitSub(501)
        HealBot_Options_InitSub(502)
        HealBot_Options_InitSub(503)
        HealBot_Options_InitSub(504)
        HealBot_Options_InitSub(505)
        HealBot_Options_InitSub(506)
        HealBot_Options_InitSub(507)
        HealBot_Options_InitSub(508)
        HealBot_Options_InitSub(509)
        HealBot_Options_InitSub(510)
        HealBot_Options_InitSub(511)
        HealBot_Options_InitSub(512)
        HealBot_Options_InitSub(513)
        HealBot_Options_InitSub(514)
        HealBot_Options_InitSub(515)
        HealBot_Options_InitSub(516)
        HealBot_Options_InitSub(517)
        HealBot_Options_InitSub(518)
        HealBot_Options_InitSub(519)
        HealBot_Options_InitSub(520)
        DoneInitTab[5]=true
    elseif tabNo==7 and not DoneInitTab[7] then
        HealBot_Options_NumberTestBars:SetValue(HealBot_Globals.noTestBars)
        HealBot_Options_SmartCastBuff:SetChecked(HealBot_Globals.SmartCastBuff)
        HealBot_Options_SmartCastHeal:SetChecked(HealBot_Globals.SmartCastHeal)
        HealBot_Options_NumberTestTanks:SetValue(HealBot_Globals.noTestTanks)
        HealBot_Options_SmartCastRes:SetChecked(HealBot_Globals.SmartCastRes)
        HealBot_Options_EnableMouseWheel:SetChecked(HealBot_Globals.HealBot_Enable_MouseWheel)
        HealBot_Options_NumberTestMyTargets:SetValue(HealBot_Globals.noTestTargets)
        HealBot_Options_EnableSmartCast:SetChecked(HealBot_Globals.SmartCast)
        HealBot_Options_SmartCastDisspell:SetChecked(HealBot_Globals.SmartCastDebuff)
        HealBot_Options_NumberTestPets:SetValue(HealBot_Globals.noTestPets)
        HealBot_Options_TestBarsButton:SetText(HEALBOT_OPTIONS_TESTBARS.." "..HEALBOT_WORD_OFF)
        HealBot_Options_ProtectPvP:SetChecked(HealBot_Globals.ProtectPvP)
        HealBot_Options_InitSub(701)
        HealBot_Options_InitSub(702)
        HealBot_Options_InitSub(703)
        HealBot_Options_InitSub(704)
        HealBot_Options_InitSub(705)
        HealBot_Options_InitSub(706)
        HealBot_Options_InitSub(707)
        HealBot_Options_InitSub(708)
        DoneInitTab[7]=true
    elseif tabNo==9 and not DoneInitTab[9] then
        HealBot_Options_DisableHealBotOpt:SetChecked(HealBot_Config.DisableHealBot)
        HealBot_Options_DisableHealBotSolo:SetChecked(HealBot_Config.DisableSolo)
        HealBot_Options_EnableSmartCast:SetChecked(HealBot_Globals.SmartCast)
        HealBot_Options_MonitorDebuffs:SetChecked(HealBot_Config.DebuffWatch)
        HealBot_Options_MonitorBuffs:SetChecked(HealBot_Config.BuffWatch)
        DoneInitTab[9]=true
        LSM.RegisterCallback("HealBot", "LibSharedMedia_Registered", function(event, mediatype, key) HealBot_UpdateUsedMedia(event, mediatype, key) end)  
        LSM.RegisterCallback("HealBot", "LibSharedMedia_SetGlobal", function(event, mediatype, key) HealBot_UpdateUsedMedia(event, mediatype, key) end) 
        HealBot_Options_SelectSpellsFrame:Hide()
    elseif tabNo==10 and not DoneInitTab[10] then
        HealBot_Options_InitSub(801)
        HealBot_Options_InitSub(802)
        HealBot_Options_InitSub(803)
        HealBot_Options_InitSub(804)
        HealBot_Options_InitSub(805)
        DoneInitTab[10]=true
    end
    if not HealBot_Options_Opened then
        HealBot_setOptions_Timer(100)
        HealBot_Options_Opened=true
        if (HealBot_Config.SoundDebuffWarning or 0)>0 then
            HealBot_Options_WarningSound:Enable();
            HealBot_Options_PlaySound:Enable();
        else
            HealBot_Options_WarningSound:Disable();
            HealBot_Options_PlaySound:Disable();
        end
        if (Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin] or 0)==0 then
            HealBot_Options_ShowClassOnBarType1:Disable();
            HealBot_Options_ShowClassOnBarType2:Disable();
        else
            HealBot_Options_ShowClassOnBarType1:Enable();
            HealBot_Options_ShowClassOnBarType2:Enable();
        end
        HealBot_HighlightActiveBarColour:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Default_Textures[16].name));
        HealBot_HighlightTargetBarColour:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Default_Textures[16].name));
        HealBot_Aggro3Colorpick:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Default_Textures[16].name));
		if HealBot_PlayerClassTrim==HealBot_Class_En[HEALBOT_PALADIN] then
			HealBot_Options_ShowPowerCounter:Show()
			HealBot_Options_ShowPowerCounterText:SetText(HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA)
        elseif HealBot_PlayerClassTrim==HealBot_Class_En[HEALBOT_MONK] then
			HealBot_Options_ShowPowerCounter:Show()
			HealBot_Options_ShowPowerCounterText:SetText(HEALBOT_OPTIONS_SHOWPOWERCOUNTER_MONK)
		else
			HealBot_Options_ShowPowerCounter:Hide()
		end
    end
end

function HealBot_Options_InitSub(subNo)
    if subNo<500 then
        HealBot_Options_InitSub1(subNo)
    else
        HealBot_Options_InitSub2(subNo)
    end
end

function HealBot_Options_InitSub1(subNo)
    if subNo==101 and not DoneInitTab[101] then
        HealBot_Options_hbCommands.initialize = HealBot_Options_hbCommands_DropDown
        UIDropDownMenu_SetText(HealBot_Options_hbCommands, HealBot_Options_hbCommands_List[HealBot_Options_StorePrev["hbCommands"]])
        DoneInitTab[101]=true
    elseif subNo==102 and not DoneInitTab[102] then
        HealBot_Options_EmergencyFClass.initialize = HealBot_Options_EmergencyFClass_DropDown
        UIDropDownMenu_SetText(HealBot_Options_EmergencyFClass, HealBot_Options_EmergencyFClass_List[HealBot_Globals.EmergencyFClass])
        DoneInitTab[102]=true
    elseif subNo==201 and not DoneInitTab[201] then
        HealBot_Options_CastButton.initialize = HealBot_Options_CastButton_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CastButton, HealBot_Options_CastButton_List[HealBot_Options_ComboButtons_Button])
        DoneInitTab[201]=true
    elseif subNo==202 and not DoneInitTab[202] then
        HealBot_Options_ButtonCastMethod.initialize = HealBot_Options_ButtonCastMethod_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ButtonCastMethod, HealBot_Options_ButtonCastMethod_List[HealBot_Config.ButtonCastMethod])
        DoneInitTab[202]=true
    elseif subNo==203 and not DoneInitTab[203] then
        HealBot_Options_ActionBarsCombo.initialize = HealBot_Options_ActionBarsCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ActionBarsCombo, HealBot_Options_ActionBarsCombo_List[HealBot_Options_StorePrev["ActionBarsCombo"]])
        DoneInitTab[203]=true
    elseif subNo==301 and not DoneInitTab[301] then
        HealBot_Options_ActionAnchor.initialize = HealBot_Options_ActionAnchor_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ActionAnchor, HealBot_Options_ActionAnchor_List[Healbot_Config_Skins.Panel_Anchor[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[301]=true
    elseif subNo==302 and not DoneInitTab[302] then
        HealBot_Options_ActionBarsAnchor.initialize = HealBot_Options_ActionBarsAnchor_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ActionBarsAnchor, HealBot_Options_ActionAnchor_List[Healbot_Config_Skins.Bars_Anchor[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[302]=true
    elseif subNo==303 and not DoneInitTab[303] then
        HealBot_Options_SkinPartyRaidDefault.initialize = HealBot_Options_SkinPartyRaidDefault_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SkinPartyRaidDefault, HealBot_Options_SkinDefault_List[HealBot_Config.SkinDefault[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[303]=true
    elseif subNo==304 and not DoneInitTab[304] then
        HealBot_Options_EmergencyFilter.initialize = HealBot_Options_EmergencyFilter_DropDown
        UIDropDownMenu_SetText(HealBot_Options_EmergencyFilter, HealBot_Options_EmergencyFilter_List[Healbot_Config_Skins.EmergIncMonitor[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[304]=true
    elseif subNo==305 and not DoneInitTab[305] then
        HealBot_Options_HeadFontOutline.initialize = HealBot_Options_HeadFontOutline_DropDown
        UIDropDownMenu_SetText(HealBot_Options_HeadFontOutline, HealBot_Options_FontOutline_List[Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[305]=true
    elseif subNo==306 and not DoneInitTab[306] then
        local i=Healbot_Config_Skins.BarHealthNumFormatAggro[Healbot_Config_Skins.Current_Skin]
        if i>1 then i=(i*2)-1 end
        HealBot_Options_BarHealthNumFormatAggro.initialize = HealBot_Options_BarHealthNumFormatAggro_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthNumFormatAggro, HealBot_Options_BarHealthNumFormat2_List[i].."77%"..HealBot_Options_BarHealthNumFormat2_List[i+1])
        DoneInitTab[306]=true
    elseif subNo==307 and not DoneInitTab[307] then
        local tmpBarHealthNumFormat1_List=HealBot_Options_BarHealthNumFormat_genList()
        HealBot_Options_BarHealthNumFormat1.initialize = HealBot_Options_BarHealthNumFormat1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthNumFormat1, tmpBarHealthNumFormat1_List[Healbot_Config_Skins.BarHealthNumFormat1[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[307]=true
    elseif subNo==308 and not DoneInitTab[308] then
        local i=Healbot_Config_Skins.BarHealthNumFormat2[Healbot_Config_Skins.Current_Skin]
        if i>1 then i=(i*2)-1 end
        HealBot_Options_BarHealthNumFormat2.initialize = HealBot_Options_BarHealthNumFormat2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthNumFormat2, HealBot_Options_BarHealthNumFormat2_List[i]..HealBot_Options_StorePrev["hbBarHealthNumFormatTxt"]..HealBot_Options_BarHealthNumFormat2_List[i+1])
        DoneInitTab[308]=true
    elseif subNo==309 and not DoneInitTab[309] then -- dia font
        HealBot_Options_FontOutline.initialize = HealBot_Options_FontOutline_DropDown
        UIDropDownMenu_SetText(HealBot_Options_FontOutline, HealBot_Options_FontOutline_List[Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[309]=true
    elseif subNo==310 and not DoneInitTab[310] then -- dia font
        HealBot_Options_ManaIndicator.initialize = HealBot_Options_ManaIndicator_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ManaIndicator, HealBot_Options_ManaIndicator_List[Healbot_Config_Skins.LowManaInd[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[310]=true
    elseif subNo==311 and not DoneInitTab[311] then
        if (Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin] or 0)<1 then Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]=1 end
        HealBot_Options_BarHealthType.initialize = HealBot_Options_BarHealthType_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthType, HealBot_Options_BarHealthType_List[Healbot_Config_Skins.BarHealthType[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[311]=true
    elseif subNo==312 and not DoneInitTab[312] then
        HealBot_Options_ExtraSort.initialize = HealBot_Options_ExtraSort_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ExtraSort, HealBot_Options_ExtraSort_List[Healbot_Config_Skins.ExtraOrder[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[312]=true
    elseif subNo==313 and not DoneInitTab[313] then
        HealBot_Options_ExtraSubSort.initialize = HealBot_Options_ExtraSubSort_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ExtraSubSort, HealBot_Options_ExtraSubSort_List[Healbot_Config_Skins.ExtraSubOrder[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[313]=true
    elseif subNo==314 and not DoneInitTab[314] then
        HealBot_Options_FilterHoTctl.initialize = HealBot_Options_FilterHoTctl_DropDown
        UIDropDownMenu_SetText(HealBot_Options_FilterHoTctl, HealBot_Options_StorePrev["FilterHoTctlName"])
        DoneInitTab[314]=true
    elseif subNo==315 and not DoneInitTab[315] then
        local _ = HealBot_Options_Class_HoTctlName_genList()
        if HealBot_Options_StorePrev["FilterHoTctlNameTrim"] and HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]] and not
           HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]][HealBot_Globals.HoTname] then HealBot_Globals.HoTname=HEALBOT_GIFT_OF_THE_NAARU end
        HealBot_Options_Class_HoTctlName.initialize = HealBot_Options_Class_HoTctlName_DropDown
        UIDropDownMenu_SetText(HealBot_Options_Class_HoTctlName, HealBot_Globals.HoTname)
        DoneInitTab[315]=true
    elseif subNo==316 and not DoneInitTab[316] then
        HealBot_Options_Class_HoTctlAction.initialize = HealBot_Options_Class_HoTctlAction_DropDown
        local x=HealBot_Globals.WatchHoT[HealBot_Options_StorePrev["FilterHoTctlNameTrim"]][HealBot_Globals.HoTname] or 1
        UIDropDownMenu_SetText(HealBot_Options_Class_HoTctlAction, HealBot_Options_Class_HoTctlAction_List[x])
        DoneInitTab[316]=true
    elseif subNo==317 and not DoneInitTab[317] then
        HealBot_Options_TooltipPos.initialize = HealBot_Options_TooltipPos_DropDown
        UIDropDownMenu_SetText(HealBot_Options_TooltipPos, HealBot_Options_TooltipPos_List[Healbot_Config_Skins.TooltipPos[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[317]=true
    elseif subNo==318 then -- Always run
        HealBot_Options_ShareSkin.initialize = HealBot_Options_ShareSkin_DropDown
        UIDropDownMenu_SetText(HealBot_Options_ShareSkin, HealBot_Options_StorePrev["hbCurUnitName"])
    elseif subNo==319 and not DoneInitTab[319] then
        HealBot_Options_Skins.initialize = HealBot_Options_Skins_DropDown
        UIDropDownMenu_SetText(HealBot_Options_Skins, HealBot_Skins[Healbot_Config_Skins.Skin_ID])
        DoneInitTab[319]=true
    elseif subNo==320 and not DoneInitTab[320] then
        HealBot_Options_AggroAlertLevel.initialize = HealBot_Options_AggroAlertLevel_DropDown
        UIDropDownMenu_SetText(HealBot_Options_AggroAlertLevel, HealBot_Options_AggroAlertLevel_List[Healbot_Config_Skins.AggroAlertLevel[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[320]=true
    elseif subNo==321 and not DoneInitTab[321] then
        HealBot_Options_AggroIndAlertLevel.initialize = HealBot_Options_AggroIndAlertLevel_DropDown
        UIDropDownMenu_SetText(HealBot_Options_AggroIndAlertLevel, HealBot_Options_AggroIndAlertLevel_List[Healbot_Config_Skins.AggroIndAlertLevel[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[321]=true
    elseif subNo==322 and not DoneInitTab[322] then
        HealBot_Options_BarIncHealColour.initialize = HealBot_Options_BarIncHealColour_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarIncHealColour, HealBot_Options_BarIncHealColour_List[Healbot_Config_Skins.IncHealBarColour[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[322]=true
    elseif subNo==323 and not DoneInitTab[323] then
        HealBot_Options_BarHealthColour.initialize = HealBot_Options_BarHealthColour_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthColour, HealBot_Options_BarHealthColour_List[Healbot_Config_Skins.HlthBarColour[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[323]=true
    elseif subNo==324 and not DoneInitTab[324] then
        HealBot_Options_BarHealthIncHeal.initialize = HealBot_Options_BarHealthIncHeal_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BarHealthIncHeal, HealBot_Options_BarHealthIncHeal_List[Healbot_Config_Skins.BarHealthIncHeals[Healbot_Config_Skins.Current_Skin]])
        DoneInitTab[324]=true
    elseif subNo==401 and not DoneInitTab[401] then
        HealBot_Options_UpdateMedia(4)
        DoneInitTab[401]=true
    elseif subNo==402 and not DoneInitTab[402] then
        HealBot_Options_CDCPriority1.initialize = HealBot_Options_CDCPriority1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCPriority1, HealBot_Config.HealBotDebuffPriority[HEALBOT_DISEASE_en])
        DoneInitTab[402]=true
    elseif subNo==403 and not DoneInitTab[403] then
        HealBot_Options_CDCPriority2.initialize = HealBot_Options_CDCPriority2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCPriority2, HealBot_Config.HealBotDebuffPriority[HEALBOT_MAGIC_en])
        DoneInitTab[403]=true
    elseif subNo==404 and not DoneInitTab[404] then
        HealBot_Options_CDCPriority3.initialize = HealBot_Options_CDCPriority3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCPriority3, HealBot_Config.HealBotDebuffPriority[HEALBOT_POISON_en])
        DoneInitTab[404]=true
    elseif subNo==405 and not DoneInitTab[405] then
        HealBot_Options_CDCPriority4.initialize = HealBot_Options_CDCPriority4_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCPriority4, HealBot_Config.HealBotDebuffPriority[HEALBOT_CURSE_en])
        DoneInitTab[405]=true
    elseif subNo==406 then  -- Alway run this
        local _ = HealBot_Options_CDebuffCat_genList()
        HealBot_Options_CDebuffTxt1.numButtons = 0;
        HealBot_Options_CDebuffTxt1.initialize = HealBot_Options_CDebuffTxt1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDebuffTxt1, HealBot_Options_StorePrev["CDebuffcustomName"])
        HealBot_Options_CDCReverseDurC:SetChecked(HealBot_Globals.HealBot_Custom_Debuffs_RevDur[HealBot_Options_StorePrev["CDebuffcustomName"]] or 0)
        HealBot_Options_CDCCol_OnOff:SetChecked(HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_Options_StorePrev["CDebuffcustomName"]] or 1)
        HealBot_Options_SetEnableDisableCDBtn()
    elseif subNo==407 and not DoneInitTab[407] then
        HealBot_Options_CDebuffCat.initialize = HealBot_Options_CDebuffCat_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDebuffCat, HealBot_CDebuffCat_List[HealBot_Options_StorePrev["CDebuffCatID"]])
        DoneInitTab[407]=true
    elseif subNo==408 then -- Always run this
        local x=10
        if HealBot_Options_StorePrev["CDebuffcustomName"] then
            if not HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]] then HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]]=10 end;
            x=HealBot_Globals.HealBot_Custom_Debuffs[HealBot_Options_StorePrev["CDebuffcustomName"]]
        end
        HealBot_Options_CDCPriorityC.initialize = HealBot_Options_CDCPriorityC_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCPriorityC, x)
    elseif subNo==409 and not DoneInitTab[409] then
        HealBot_Options_CDCTxt1.initialize = HealBot_Options_CDCTxt1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCTxt1, HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(1)])
        DoneInitTab[409]=true
    elseif subNo==410 and not DoneInitTab[410] then
        HealBot_Options_CDCGroups1.initialize = HealBot_Options_CDCGroups1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCGroups1, HealBot_Options_BuffTxt_List[HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(1)]])
        DoneInitTab[410]=true
    elseif subNo==411 and not DoneInitTab[411] then
        HealBot_Options_CDCTxt2.initialize = HealBot_Options_CDCTxt2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCTxt2, HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(2)])
        DoneInitTab[411]=true
    elseif subNo==412 and not DoneInitTab[412] then
        HealBot_Options_CDCGroups2.initialize = HealBot_Options_CDCGroups2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCGroups2, HealBot_Options_BuffTxt_List[HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(2)]])
        DoneInitTab[412]=true
    elseif subNo==413 and not DoneInitTab[413] then
        HealBot_Options_CDCTxt3.initialize = HealBot_Options_CDCTxt3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCTxt3, HealBot_Config.HealBotDebuffText[HealBot_Options_getDropDownId_bySpec(3)])
        DoneInitTab[413]=true
    elseif subNo==414 and not DoneInitTab[414] then
        HealBot_Options_CDCGroups3.initialize = HealBot_Options_CDCGroups3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCGroups3, HealBot_Options_BuffTxt_List[HealBot_Config.HealBotDebuffDropDown[HealBot_Options_getDropDownId_bySpec(3)]])
        DoneInitTab[414]=true
    elseif subNo==415 and not DoneInitTab[415] then
        HealBot_Options_CDCWarnRange1.initialize = HealBot_Options_CDCWarnRange1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCWarnRange1, HealBot_Debuff_RangeWarning_List[HealBot_Config.HealBot_CDCWarnRange_Bar])
        DoneInitTab[415]=true
    elseif subNo==416 and not DoneInitTab[416] then
        HealBot_Options_CDCWarnRange2.initialize = HealBot_Options_CDCWarnRange2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCWarnRange2, HealBot_Debuff_RangeWarning_List[HealBot_Config.HealBot_CDCWarnRange_Aggro])
        DoneInitTab[416]=true
    elseif subNo==417 and not DoneInitTab[417] then
        HealBot_Options_CDCWarnRange3.initialize = HealBot_Options_CDCWarnRange3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCWarnRange3, HealBot_Debuff_RangeWarning_List[HealBot_Config.HealBot_CDCWarnRange_Screen])
        DoneInitTab[417]=true
    elseif subNo==418 and not DoneInitTab[418] then
        HealBot_Options_CDCWarnRange4.initialize = HealBot_Options_CDCWarnRange4_DropDown
        UIDropDownMenu_SetText(HealBot_Options_CDCWarnRange4, HealBot_Debuff_RangeWarning_List[HealBot_Config.HealBot_CDCWarnRange_Sound])
        DoneInitTab[418]=true
    end
end

function HealBot_Options_InitSub2(subNo)
    if subNo==501 and not DoneInitTab[501] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt1.numButtons = 0;
        HealBot_Options_BuffTxt1.initialize = HealBot_Options_BuffTxt1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt1, BuffTextClass[HealBot_Options_getDropDownId_bySpec(1)])
        DoneInitTab[501]=true
    elseif subNo==502 and not DoneInitTab[502] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)]=1 end;
        HealBot_Options_BuffGroups1.initialize = HealBot_Options_BuffGroups1_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups1, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(1)]])
        DoneInitTab[502]=true
    elseif subNo==503 and not DoneInitTab[503] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt2.numButtons = 0;
        HealBot_Options_BuffTxt2.initialize = HealBot_Options_BuffTxt2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt2, BuffTextClass[HealBot_Options_getDropDownId_bySpec(2)])
        DoneInitTab[503]=true
    elseif subNo==504 and not DoneInitTab[504] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)]=1 end;
        HealBot_Options_BuffGroups2.initialize = HealBot_Options_BuffGroups2_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups2, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(2)]])
        DoneInitTab[504]=true
    elseif subNo==505 and not DoneInitTab[505] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt3.numButtons = 0;
        HealBot_Options_BuffTxt3.initialize = HealBot_Options_BuffTxt3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt3, BuffTextClass[HealBot_Options_getDropDownId_bySpec(3)])
        DoneInitTab[505]=true
    elseif subNo==506 and not DoneInitTab[506] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)]=1 end;
        HealBot_Options_BuffGroups3.initialize = HealBot_Options_BuffGroups3_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups3, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(3)]])
        DoneInitTab[506]=true
    elseif subNo==507 and not DoneInitTab[507] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt4.numButtons = 0;
        HealBot_Options_BuffTxt4.initialize = HealBot_Options_BuffTxt4_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt4, BuffTextClass[HealBot_Options_getDropDownId_bySpec(4)])
        DoneInitTab[507]=true
    elseif subNo==508 and not DoneInitTab[508] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)]=1 end;
        HealBot_Options_BuffGroups4.initialize = HealBot_Options_BuffGroups4_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups4, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(4)]])
        DoneInitTab[508]=true
    elseif subNo==509 and not DoneInitTab[509] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt5.numButtons = 0;
        HealBot_Options_BuffTxt5.initialize = HealBot_Options_BuffTxt5_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt5, BuffTextClass[HealBot_Options_getDropDownId_bySpec(5)])
        DoneInitTab[509]=true
    elseif subNo==510 and not DoneInitTab[510] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)]=1 end;
        HealBot_Options_BuffGroups5.initialize = HealBot_Options_BuffGroups5_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups5, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(5)]])
        DoneInitTab[510]=true
    elseif subNo==511 and not DoneInitTab[511] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt6.numButtons = 0;
        HealBot_Options_BuffTxt6.initialize = HealBot_Options_BuffTxt6_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt6, BuffTextClass[HealBot_Options_getDropDownId_bySpec(6)])
        DoneInitTab[511]=true
    elseif subNo==512 and not DoneInitTab[512] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)]=1 end;
        HealBot_Options_BuffGroups6.initialize = HealBot_Options_BuffGroups6_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups6, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(6)]])
        DoneInitTab[512]=true
    elseif subNo==513 and not DoneInitTab[513] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt7.numButtons = 0;
        HealBot_Options_BuffTxt7.initialize = HealBot_Options_BuffTxt7_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt7, BuffTextClass[HealBot_Options_getDropDownId_bySpec(7)])
        DoneInitTab[513]=true
    elseif subNo==514 and not DoneInitTab[514] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)]=1 end;
        HealBot_Options_BuffGroups7.initialize = HealBot_Options_BuffGroups7_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups7, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(7)]])
        DoneInitTab[514]=true
    elseif subNo==515 and not DoneInitTab[515] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt8.numButtons = 0;
        HealBot_Options_BuffTxt8.initialize = HealBot_Options_BuffTxt8_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt8, BuffTextClass[HealBot_Options_getDropDownId_bySpec(8)])
        DoneInitTab[515]=true
    elseif subNo==516 and not DoneInitTab[516] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)]=1 end;
        HealBot_Options_BuffGroups8.initialize = HealBot_Options_BuffGroups8_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups8, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(8)]])
        DoneInitTab[516]=true
    elseif subNo==517 and not DoneInitTab[517] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt9.numButtons = 0;
        HealBot_Options_BuffTxt9.initialize = HealBot_Options_BuffTxt9_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt9, BuffTextClass[HealBot_Options_getDropDownId_bySpec(9)])
        DoneInitTab[517]=true
    elseif subNo==518 and not DoneInitTab[518] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)]=1 end;
        HealBot_Options_BuffGroups9.initialize = HealBot_Options_BuffGroups9_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups9, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(9)]])
        DoneInitTab[518]=true
    elseif subNo==519 and not DoneInitTab[519] then
        BuffTextClass = HealBot_Config.HealBotBuffText
        if not BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)] then BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)]=HEALBOT_WORDS_NONE  end;
        HealBot_Options_BuffTxt10.numButtons = 0;
        HealBot_Options_BuffTxt10.initialize = HealBot_Options_BuffTxt10_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffTxt10, BuffTextClass[HealBot_Options_getDropDownId_bySpec(10)])
        DoneInitTab[519]=true
    elseif subNo==520 and not DoneInitTab[520] then
        BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
        if not BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)] then BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)]=1 end;
        HealBot_Options_BuffGroups10.initialize = HealBot_Options_BuffGroups10_DropDown
        UIDropDownMenu_SetText(HealBot_Options_BuffGroups10, HealBot_Options_BuffTxt_List[BuffDropDownClass[HealBot_Options_getDropDownId_bySpec(10)]])
        DoneInitTab[520]=true
    elseif subNo==701 and not DoneInitTab[701] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"] then HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"]=1 end
        HealBot_Options_MouseWheelUp.initialize = HealBot_Options_MouseWheelUp_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["NoneUp"]])
        DoneInitTab[701]=true
    elseif subNo==702 and not DoneInitTab[702] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"] then HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"]=1 end
        HealBot_Options_MouseWheelDown.initialize = HealBot_Options_MouseWheelDown_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["NoneDown"]])
        DoneInitTab[702]=true
    elseif subNo==703 and not DoneInitTab[703] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"] then HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"]=1 end
        HealBot_Options_MouseWheelShiftUp.initialize = HealBot_Options_MouseWheelShiftUp_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelShiftUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["ShiftUp"]])
        DoneInitTab[703]=true
    elseif subNo==704 and not DoneInitTab[704] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"] then HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"]=1 end
        HealBot_Options_MouseWheelShiftDown.initialize = HealBot_Options_MouseWheelShiftDown_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelShiftDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["ShiftDown"]])
        DoneInitTab[704]=true
    elseif subNo==705 and not DoneInitTab[705] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"] then HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"]=1 end
        HealBot_Options_MouseWheelCtrlUp.initialize = HealBot_Options_MouseWheelCtrlUp_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelCtrlUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["CtrlUp"]])
        DoneInitTab[705]=true
    elseif subNo==706 and not DoneInitTab[706] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"] then HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"]=1 end
        HealBot_Options_MouseWheelCtrlDown.initialize = HealBot_Options_MouseWheelCtrlDown_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelCtrlDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["CtrlDown"]])
        DoneInitTab[706]=true
    elseif subNo==707 and not DoneInitTab[707] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["AltUp"] then HealBot_Globals.HealBot_MouseWheelIndex["AltUp"]=1 end
        HealBot_Options_MouseWheelAltUp.initialize = HealBot_Options_MouseWheelAltUp_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelAltUp, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["AltUp"]])
        DoneInitTab[707]=true
    elseif subNo==708 and not DoneInitTab[708] then
        if not HealBot_Globals.HealBot_MouseWheelIndex["AltDown"] then HealBot_Globals.HealBot_MouseWheelIndex["AltDown"]=1 end
        HealBot_Options_MouseWheelAltDown.initialize = HealBot_Options_MouseWheelAltDown_DropDown
        UIDropDownMenu_SetText(HealBot_Options_MouseWheelAltDown, HealBot_Options_MouseWheel_List[HealBot_Globals.HealBot_MouseWheelIndex["AltDown"]])
        DoneInitTab[708]=true
    elseif subNo==801 and not DoneInitTab[801] then
        HealBot_Options_SelectHealSpellsCombo.numButtons = 0;
        HealBot_Options_SelectHealSpellsCombo.initialize = HealBot_Options_SelectHealSpellsCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SelectHealSpellsCombo, HEALBOT_OPTIONS_SMARTCASTHEAL)
        DoneInitTab[801]=true
    elseif subNo==802 and not DoneInitTab[802] then
        HealBot_Options_SelectOtherSpellsCombo.numButtons = 0;
        HealBot_Options_SelectOtherSpellsCombo.initialize = HealBot_Options_SelectOtherSpellsCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SelectOtherSpellsCombo, HEALBOT_OPTIONS_OTHERSPELLS)
        DoneInitTab[802]=true
    elseif subNo==803 and not DoneInitTab[803] then
        HealBot_Options_SelectMacrosCombo.numButtons = 0;
        HealBot_Options_SelectMacrosCombo.initialize = HealBot_Options_SelectMacrosCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SelectMacrosCombo, HEALBOT_WORD_MACROS)
        DoneInitTab[803]=true
    elseif subNo==804 and not DoneInitTab[804] then
        HealBot_Options_SelectItemsCombo.numButtons = 0;
        HealBot_Options_SelectItemsCombo.initialize = HealBot_Options_SelectItemsCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SelectItemsCombo, HEALBOT_OPTIONS_ITEMS)
        DoneInitTab[804]=true
    elseif subNo==805 and not DoneInitTab[805] then
        HealBot_Options_SelectCmdsCombo.numButtons = 0;
        HealBot_Options_SelectCmdsCombo.initialize = HealBot_Options_SelectCmdsCombo_DropDown
        UIDropDownMenu_SetText(HealBot_Options_SelectCmdsCombo, HEALBOT_WORD_COMMANDS)
        DoneInitTab[805]=true
    end
end

function HealBot_Options_SetEFGroups()
    for x=1,8 do
        if Healbot_Config_Skins.ExtraIncGroup[Healbot_Config_Skins.Current_Skin][x] then 
            g=_G["HealBot_Options_EFGroup"..x]
            g:SetChecked(1)
        else
            g=_G["HealBot_Options_EFGroup"..x]
            g:SetChecked(nil)
        end
    end
end

local HealBot_disabledState=-1
function HealBot_Options_SetSkins()
    if hbCurSkin~=Healbot_Config_Skins.Current_Skin then
        HealBot_Options_ResetDoInittab(3)
        HealBot_Options_InitSub(317)
        HealBot_Options_SetEFGroups()
        HealBot_SetSkinColours()
        HealBot_Action_SetHightlightAggroCols()
        HealBot_Options_SetSkinBars()
        if Healbot_Config_Skins.Current_Skin==HEALBOT_SKINS_STD then
            HealBot_Options_DeleteSkin:Disable();
        else
            HealBot_Options_DeleteSkin:Enable();
        end
        if (Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin] or 0)==0 then
            HealBot_UnRegister_Mana()
        else
            HealBot_Register_Mana()
        end
        if (Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin] or 0)==0 then
            HealBot_UnRegister_Aggro()
        else
            HealBot_Register_Aggro()
        end
        if (Healbot_Config_Skins.ReadyCheck[Healbot_Config_Skins.Current_Skin] or 0)==0 then
            HealBot_UnRegister_ReadyCheck()
        else
            HealBot_Register_ReadyCheck()
        end
        HealBot_Config.Current_Skin = Healbot_Config_Skins.Current_Skin
        HealBot_Config.Skin_ID = Healbot_Config_Skins.Skin_ID
        hbCurSkin=Healbot_Config_Skins.Current_Skin
    end
    if hbCurSkinSubFrameID==1001 and not DoneInitTab[1001] then
        HealBot_Options_PartyFrames:SetChecked(Healbot_Config_Skins.HidePartyFrames[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_PlayerTargetFrames:SetChecked(Healbot_Config_Skins.HidePlayerTarget[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_ActionLocked:SetChecked(Healbot_Config_Skins.ActionLocked[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_AutoShow:SetChecked(Healbot_Config_Skins.AutoClose[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_PanelSounds:SetChecked(Healbot_Config_Skins.PanelSounds[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_ManaIndicatorInCombat:SetChecked(Healbot_Config_Skins.LowManaIndIC[Healbot_Config_Skins.Current_Skin])
        HealBot_FrameScale:SetValue((Healbot_Config_Skins.FrameScale[Healbot_Config_Skins.Current_Skin] or 1)*10)
        HealBot_Options_UseFluidBars:SetChecked(Healbot_Config_Skins.UseFluidBars[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_BarUpdateFreq:SetValue((Healbot_Config_Skins.BarFreq[Healbot_Config_Skins.Current_Skin] or 2)*10)
        HealBot_Options_InitSub(301)
        HealBot_Options_InitSub(302)
        HealBot_Options_InitSub(303)
        HealBot_Options_InitSub(310)
        DoneInitTab[1001]=true
    elseif hbCurSkinSubFrameID==1002 and not DoneInitTab[1002] then
        HealBot_Options_HideBars:SetChecked(Healbot_Config_Skins.HideBars[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_HideIncFocus:SetChecked(Healbot_Config_Skins.HideIncFocus[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_HideIncGroup:SetChecked(Healbot_Config_Skins.HideIncGroup[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_HideIncTank:SetChecked(Healbot_Config_Skins.HideIncTank[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_HideIncMyTargets:SetChecked(Healbot_Config_Skins.HideIncMyTargets[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortPlayerFirst:SetChecked(Healbot_Config_Skins.SubSortPlayerFirst[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_SelfHeals:SetChecked(Healbot_Config_Skins.SelfHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_PetHeals:SetChecked(Healbot_Config_Skins.PetHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_GroupHeals:SetChecked(Healbot_Config_Skins.GroupHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TankHeals:SetChecked(Healbot_Config_Skins.TankHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_MainAssistHeals:SetChecked(Healbot_Config_Skins.MainAssistHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_EmergencyHeals:SetChecked(Healbot_Config_Skins.EmergencyHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_FocusBar:SetChecked(Healbot_Config_Skins.SetFocusBar[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_VehicleHeals:SetChecked(Healbot_Config_Skins.VehicleHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_MyTargetsList:SetChecked(Healbot_Config_Skins.ShowMyTargetsList[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetBar:SetChecked(Healbot_Config_Skins.TargetHeals[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetIncSelf:SetChecked(Healbot_Config_Skins.TargetIncSelf[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetIncGroup:SetChecked(Healbot_Config_Skins.TargetIncGroup[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetIncRaid:SetChecked(Healbot_Config_Skins.TargetIncRaid[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetIncPet:SetChecked(Healbot_Config_Skins.TargetIncPet[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_FocusAlwaysShow:SetChecked(Healbot_Config_Skins.FocusBarAlwaysShow[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_TargetAlwaysShow:SetChecked(Healbot_Config_Skins.TargetBarAlwaysShow[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_GroupPetsByFive:SetChecked(Healbot_Config_Skins.GroupPetsBy5[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_AlertLevel:SetValue(Healbot_Config_Skins.AlertLevel[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortIncGroup:SetChecked(Healbot_Config_Skins.SubSortIncGroup[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortIncPets:SetChecked(Healbot_Config_Skins.SubSortIncPet[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortIncVehicle:SetChecked(Healbot_Config_Skins.SubSortIncVehicle[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortIncMainTanks:SetChecked(Healbot_Config_Skins.SubSortIncTanks[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_SubSortIncMyTargets:SetChecked(Healbot_Config_Skins.SubSortIncMyTargets[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_InitSub(304)
        HealBot_Options_InitSub(312)
        HealBot_Options_InitSub(313)
        DoneInitTab[1002]=true
    elseif hbCurSkinSubFrameID==1003 and not DoneInitTab[1003] then
        HealBot_Options_HeadTextureS:SetValue(texturesIndex[Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]] or 0)
        HealBot_Options_HeadWidthS:SetValue(Healbot_Config_Skins.headwidth[Healbot_Config_Skins.Current_Skin] or 0.72)
        HealBot_Options_HeadHightS:SetValue(Healbot_Config_Skins.headhight[Healbot_Config_Skins.Current_Skin] or 0.75)
        HealBot_Options_HeadFontNameS:SetValue(fontsIndex[Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]] or 0)
        HealBot_Options_HeadFontHeightS:SetValue(Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin] or 10)  
        HealBot_Options_ShowHeaders:SetChecked(Healbot_Config_Skins.ShowHeader[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_InitSub(305)
        DoneInitTab[1003]=true
    elseif hbCurSkinSubFrameID==1004 and not DoneInitTab[1004] then
        HealBot_Options_ShowPowerCounter:SetChecked(Healbot_Config_Skins.PowerCounter[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_BarAlpha:SetValue(Healbot_Config_Skins.Barcola[Healbot_Config_Skins.Current_Skin] or 95);
        HealBot_Options_BarAlphaInHeal:SetValue(Healbot_Config_Skins.BarcolaInHeal[Healbot_Config_Skins.Current_Skin] or 35);
        HealBot_Options_BarTextureS:SetValue(texturesIndex[Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]] or 1)
        HealBot_Options_BarHeightS:SetValue(Healbot_Config_Skins.bheight[Healbot_Config_Skins.Current_Skin] or 22)
        HealBot_Options_BarWidthS:SetValue(Healbot_Config_Skins.bwidth[Healbot_Config_Skins.Current_Skin] or 95)
        HealBot_Options_BarNumColsS:SetValue(Healbot_Config_Skins.numcols[Healbot_Config_Skins.Current_Skin] or 2)
        HealBot_Options_BarBRSpaceS:SetValue(Healbot_Config_Skins.brspace[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarBCSpaceS:SetValue(Healbot_Config_Skins.bcspace[Healbot_Config_Skins.Current_Skin] or 4)
        HealBot_Options_BarAlphaDis:SetValue(Healbot_Config_Skins.bardisa[Healbot_Config_Skins.Current_Skin] or 4)
        HealBot_Options_BarAlphaEor:SetValue(Healbot_Config_Skins.bareora[Healbot_Config_Skins.Current_Skin] or 32)
        HealBot_Options_Bar2Size:SetValue(Healbot_Config_Skins.bar2size[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_AggroBarSize:SetValue(Healbot_Config_Skins.AggroBarSize[Healbot_Config_Skins.Current_Skin] or 2)
        HealBot_Options_BarNumGroupPerCol:SetChecked(Healbot_Config_Skins.GroupsPerCol[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_InitSub(322)
        HealBot_Options_InitSub(323)
        DoneInitTab[1004]=true
    elseif hbCurSkinSubFrameID==1005 and not DoneInitTab[1005] then
        HealBot_Options_BarButtonShowHoT:SetChecked(Healbot_Config_Skins.ShowHoTicons[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIcon:SetChecked(Healbot_Config_Skins.ShowRaidIcon[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconStar:SetChecked(Healbot_Config_Skins.ShowRaidIconStar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconCircle:SetChecked(Healbot_Config_Skins.ShowRaidIconCircle[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconDiamond:SetChecked(Healbot_Config_Skins.ShowRaidIconDiamond[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconTriangle:SetChecked(Healbot_Config_Skins.ShowRaidIconTriangle[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconMoon:SetChecked(Healbot_Config_Skins.ShowRaidIconMoon[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconSquare:SetChecked(Healbot_Config_Skins.ShowRaidIconSquare[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconCross:SetChecked(Healbot_Config_Skins.ShowRaidIconCross[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarButtonShowRaidIconSkull:SetChecked(Healbot_Config_Skins.ShowRaidIconSkull[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_HoTonBar_OnClick(nil,Healbot_Config_Skins.HoTonBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_HoTposBar_OnClick(nil,Healbot_Config_Skins.HoTposBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonShowHoTx2Bar:SetChecked(Healbot_Config_Skins.HoTx2Bar[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_ShowDebuffIcon:SetChecked(Healbot_Config_Skins.ShowDebuffIcon[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_ShowReadyCheck:SetChecked(Healbot_Config_Skins.ReadyCheck[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonIconScale:SetValue((Healbot_Config_Skins.IconScale[Healbot_Config_Skins.Current_Skin] or 7.5)*10)
        HealBot_Options_InitSub(314)
        HealBot_Options_InitSub(315)
        HealBot_Options_InitSub(316)
        DoneInitTab[1005]=true    
    elseif hbCurSkinSubFrameID==1006 and not DoneInitTab[1006] then
        HealBot_Options_AggroTrack:SetChecked(Healbot_Config_Skins.ShowAggro[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_AggroBar:SetChecked(Healbot_Config_Skins.ShowAggroBars[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_AggroTxt:SetChecked(Healbot_Config_Skins.ShowAggroText[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_AggroInd:SetChecked(Healbot_Config_Skins.ShowAggroInd[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_AggroBarPct:SetChecked(Healbot_Config_Skins.ShowAggroBarsPct[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_AggroTxtPct:SetChecked(Healbot_Config_Skins.ShowAggroTextPct[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_HighlightActiveBar:SetChecked(Healbot_Config_Skins.HighLightActiveBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_HighlightTargetBar:SetChecked(Healbot_Config_Skins.HighLightTargetBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_HighlightActiveBarInCombat:SetChecked(Healbot_Config_Skins.HighLightActiveBarInCombat[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_HighlightTargetBarInCombat:SetChecked(Healbot_Config_Skins.HighLightTargetBarInCombat[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_AggroFlashAlphaMax:SetValue(Healbot_Config_Skins.AggroBarsMaxAlpha[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_AggroFlashAlphaMin:SetValue(Healbot_Config_Skins.AggroBarsMinAlpha[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_AggroFlashFreq:SetValue(Healbot_Config_Skins.AggroBarsFreq[Healbot_Config_Skins.Current_Skin]*100)
        HealBot_Options_InitSub(320)
        HealBot_Options_InitSub(321)
        HealBot_Options_InitSub(306)
        DoneInitTab[1006]=true
    elseif hbCurSkinSubFrameID==1007 and not DoneInitTab[1007] then
        HealBot_Options_CrashProt:SetChecked(Healbot_Config_Skins.CrashProt[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_CombatProt:SetChecked(Healbot_Config_Skins.CombatProt[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_CombatPartyNo:SetValue(Healbot_Config_Skins.CombatProtParty[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_CombatRaidNo:SetValue(Healbot_Config_Skins.CombatProtRaid[Healbot_Config_Skins.Current_Skin])
        DoneInitTab[1007]=true
    elseif hbCurSkinSubFrameID==1008 and not DoneInitTab[1008] then
        HealBot_Options_CastNotify_OnClick(nil,Healbot_Config_Skins.CastNotify[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_NotifyChan:SetText(Healbot_Config_Skins.NotifyChan[Healbot_Config_Skins.Current_Skin])
        HealBot_Options_NotifyOtherMsg:SetText(Healbot_Config_Skins.NotifyOtherMsg[Healbot_Config_Skins.Current_Skin])   
        HealBot_Options_CastNotifyResOnly:SetChecked(Healbot_Config_Skins.CastNotifyResOnly[Healbot_Config_Skins.Current_Skin])
        DoneInitTab[1008]=true
    elseif hbCurSkinSubFrameID==1009 and not DoneInitTab[1009] then
        HealBot_Options_FontName:SetValue(fontsIndex[Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]] or 0)
        HealBot_Options_FontHeight:SetValue(Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin] or 10)
        HealBot_Options_ShowClassOnBarType_OnClick(nil,Healbot_Config_Skins.ShowClassType[Healbot_Config_Skins.Current_Skin] or 2)
        HealBot_Options_ShowRoleOnBar:SetChecked(Healbot_Config_Skins.ShowRole[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_ShowClassOnBar:SetChecked(Healbot_Config_Skins.ShowClassOnBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_ShowNameOnBar:SetChecked(Healbot_Config_Skins.ShowNameOnBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_ShowHealthOnBar:SetChecked(Healbot_Config_Skins.ShowHealthOnBar[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_BarTextInClassColour:SetChecked(Healbot_Config_Skins.SetClassColourText[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_Options_TextAlign:SetValue(Healbot_Config_Skins.TextAlignment[Healbot_Config_Skins.Current_Skin] or 2)
        HealBot_Options_NumberTextLines:SetChecked(Healbot_Config_Skins.DoubleText[Healbot_Config_Skins.Current_Skin] or 0)
        HealBot_Options_InitSub(324)
        HealBot_Options_InitSub(307)
        HealBot_Options_InitSub(308)
        HealBot_Options_InitSub(309)
        HealBot_Options_InitSub(311)
        DoneInitTab[1009]=true
    elseif hbCurSkinSubFrameID==1010 and not DoneInitTab[1010] then
        HealBot_BarButtonShowHoTTextCount:SetChecked(Healbot_Config_Skins.ShowIconTextCount[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonShowHoTTextCountSelfCast:SetChecked(Healbot_Config_Skins.ShowIconTextCountSelfCast[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonShowHoTTextDuration:SetChecked(Healbot_Config_Skins.ShowIconTextDuration[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonShowHoTTextDurationSelfCast:SetChecked(Healbot_Config_Skins.ShowIconTextDurationSelfCast[Healbot_Config_Skins.Current_Skin] or 1)
        HealBot_BarButtonIconTextScale:SetValue((Healbot_Config_Skins.IconTextScale[Healbot_Config_Skins.Current_Skin] or 7.5)*10)
        HealBot_BarButtonIconTextDurationTime:SetValue(Healbot_Config_Skins.IconTextDurationShow[Healbot_Config_Skins.Current_Skin])
        HealBot_BarButtonIconTextDurationWarn:SetValue(Healbot_Config_Skins.IconTextDurationWarn[Healbot_Config_Skins.Current_Skin])
        DoneInitTab[1010]=true
    end
        
end

function HealBot_Options_SetSkinBars()
    local headtextoutline=Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin];
    local btextoutline=Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin];
    HealBot_HeadBarColorpickt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[headtextoutline]);
    HealBot_HeadTextColorpickt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[headtextoutline]);
    HealBot_EnTextColorpickt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[btextoutline]);
    HealBot_DisTextColorpickt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[btextoutline]);
    HealBot_DebTextColorpickt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[btextoutline]);
    HealBot_BarCustomColourt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[btextoutline]);
    HealBot_BarIHCustomColourt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[btextoutline]);
    HealBot_DiseaseColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_MagicColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_PoisonColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_CurseColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_CustomColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_EnTextColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_EnTextColorpickin:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_DisTextColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_DebTextColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_HeadBarColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_HeadTextColorpick:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff1Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff2Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff3Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff4Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff5Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff6Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff7Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff8Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff9Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_Buff10Colour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_BarCustomColour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_BarIHCustomColour:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
    HealBot_DiseaseColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_MagicColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_PoisonColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_CurseColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_CustomColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_EnTextColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_EnTextColorpickin:GetStatusBarTexture():SetHorizTile(false)
    HealBot_DisTextColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_DebTextColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_HeadBarColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_HeadTextColorpick:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff1Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff2Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff3Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff4Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff5Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff6Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff7Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff8Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff9Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Buff10Colour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_BarCustomColour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_BarIHCustomColour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_HighlightActiveBarColour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_HighlightTargetBarColour:GetStatusBarTexture():SetHorizTile(false)
    HealBot_Aggro3Colorpick:GetStatusBarTexture():SetHorizTile(false)
    barScale = HealBot_EnTextColorpick:GetScale();
    HealBot_EnTextColorpick:SetScale(barScale + 0.01);
    HealBot_EnTextColorpick:SetScale(barScale);
    HealBot_DisTextColorpick:SetScale(barScale + 0.01);
    HealBot_DisTextColorpick:SetScale(barScale);
    HealBot_DebTextColorpick:SetScale(barScale + 0.01);
    HealBot_DebTextColorpick:SetScale(barScale);
    HealBot_BarCustomColour:SetScale(barScale + 0.01);
    HealBot_BarCustomColour:SetScale(barScale);
    HealBot_BarIHCustomColour:SetScale(barScale + 0.01);
    HealBot_BarIHCustomColour:SetScale(barScale);
end

local HealBot_Options_CurrentPanel = 0;

function HealBot_Options_ShowPanel(self, tabNo)
    if HealBot_Options_CurrentPanel>0 then
        g=_G["HealBot_Options_Panel"..HealBot_Options_CurrentPanel]
        g:Hide();
    end
    HealBot_Options_CurrentPanel = tabNo;
    if HealBot_Options_CurrentPanel>0 then
        g=_G["HealBot_Options_Panel"..HealBot_Options_CurrentPanel]
        g:Show();
        g=_G["HealBot_OptionsTab"..HealBot_Options_CurrentPanel]
        g:Show();
        HealBot_Options_Init(HealBot_Options_CurrentPanel)
    end
end


HealBot_Options_StorePrev["CurrentSkinsPanel"]="HealBot_Options_GeneralSkinsFrame"
HealBot_Options_StorePrev["CurrentbarName"]="HealBot_SkinsFrameSelectGeneralFrame"
function HealBot_Options_ShowSkinsPanel(frameName,barName, hbFrameID)
    hbCurSkinSubFrameID=hbFrameID
    g=_G[HealBot_Options_StorePrev["CurrentSkinsPanel"]]
    g:Hide()
    g=_G[HealBot_Options_StorePrev["CurrentbarName"]]
    g:SetStatusBarColor(0.58,0.08,0.08)
    g=_G[HealBot_Options_StorePrev["CurrentbarName"].."f"]
    g:SetTextColor(1,1,0,0.92)
    g=_G[frameName]
    g:Show()
    g=_G[barName]
    g:SetStatusBarColor(1,0.32,0.32)
    g=_G[barName.."f"]
    g:SetTextColor(1,1,1,1)
    HealBot_Options_StorePrev["CurrentSkinsPanel"]=frameName
    HealBot_Options_StorePrev["CurrentbarName"]=barName
    HealBot_Options_SetSkins()
end

HealBot_Options_StorePrev["CurrentCurePanel"]="HealBot_Options_CureDispelCleanse"
HealBot_Options_StorePrev["CurrentCurebarName"]="HealBot_CureFrameSelectDebuffFrame"
function HealBot_Options_ShowCurePanel(frameName,barName)
    g=_G[HealBot_Options_StorePrev["CurrentCurePanel"]]
    g:Hide()
    g=_G[HealBot_Options_StorePrev["CurrentCurebarName"]]
    g:SetStatusBarColor(0.58,0.08,0.08)
    g=_G[HealBot_Options_StorePrev["CurrentCurebarName"].."f"]
    g:SetTextColor(1,1,0,0.92)
    g=_G[frameName]
    g:Show()
    g=_G[barName]
    g:SetStatusBarColor(1,0.32,0.32)
    g=_G[barName.."f"]
    g:SetTextColor(1,1,1,1)
    HealBot_Options_StorePrev["CurrentCurePanel"]=frameName
    HealBot_Options_StorePrev["CurrentCurebarName"]=barName
end

HealBot_Options_StorePrev["CurrentHealPanel"]="HealBot_Options_HealAlertFrame"
HealBot_Options_StorePrev["CurrentHealbarName"]="HealBot_SkinsSubFrameSelectHealAlertFrame"
function HealBot_Options_ShowHealPanel(frameName,barName)
    g=_G[HealBot_Options_StorePrev["CurrentHealPanel"]]
    g:Hide()
    g=_G[HealBot_Options_StorePrev["CurrentHealbarName"]]
    g:SetStatusBarColor(0.58,0.08,0.08)
    g=_G[HealBot_Options_StorePrev["CurrentHealbarName"].."f"]
    g:SetTextColor(1,1,0,0.92)
    g=_G[frameName]
    g:Show()
    g=_G[barName]
    g:SetStatusBarColor(1,0.32,0.32)
    g=_G[barName.."f"]
    g:SetTextColor(1,1,1,1)
    HealBot_Options_StorePrev["CurrentHealPanel"]=frameName
    HealBot_Options_StorePrev["CurrentHealbarName"]=barName
end

function HealBot_Options_OnMouseDown(self)
    HealBot_StartMoving(self);
end

function HealBot_Options_OnMouseUp(self)
    HealBot_StopMoving(self);
end

function HealBot_Options_OnDragStart(self)
    HealBot_StartMoving(self);
end

function HealBot_Options_OnDragStop(self)
    HealBot_StopMoving(self);
end

function HealBot_Options_DisablePlayerFrame()
    PlayerFrame:UnregisterAllEvents()
    PlayerFrameHealthBar:UnregisterAllEvents()
    PlayerFrameManaBar:UnregisterAllEvents()
    PlayerFrame:Hide()
end

function HealBot_Options_EnablePlayerFrame()
    PlayerFrame:RegisterAllEvents()
    PlayerFrameHealthBar:RegisterAllEvents()
    PlayerFrameManaBar:RegisterAllEvents()
    PlayerFrame:Show();
end

function HealBot_Options_DisablePetFrame()
    PetFrame:UnregisterAllEvents()
    PetFrame:Hide()
end

function HealBot_Options_EnablePetFrame()
    PetFrame:RegisterAllEvents()
    PetFrame:Show();
end

local f=nil
function HealBot_Options_DisablePartyFrame()
  --  HidePartyFrame()
    hooksecurefunc("ShowPartyFrame", function()
        for x = 1,4 do
            g=_G["PartyMemberFrame"..x]
            g:Hide()
        end
    end)
  --  HealBot_AddDebug("In DisablePartyFrame")
    for x = 1, 4 do
        f = _G["PartyMemberFrame"..x]
        f:Hide()
        f:UnregisterAllEvents()
        g=_G["PartyMemberFrame"..x.."HealthBar"]
        g:UnregisterAllEvents()
        g=_G["PartyMemberFrame"..x.."ManaBar"]
        g:UnregisterAllEvents()
    end
end

function HealBot_Options_EnablePartyFrame()
    hooksecurefunc("ShowPartyFrame", function()
        for x = 1,4 do
            g=_G["PartyMemberFrame"..x]
            g:Show()
        end
    end)
    for x = 1, 4 do
        f = _G["PartyMemberFrame"..x]
        if UnitExists("party"..x) then
            f:Show()
        end
        f:RegisterAllEvents()
        g=_G["PartyMemberFrame"..x.."HealthBar"]
        g:RegisterAllEvents()
        g=_G["PartyMemberFrame"..x.."ManaBar"]
        g:RegisterAllEvents()
    end
end

function HealBot_Options_DisableTargetFrame()
    TargetFrame:UnregisterAllEvents()
    TargetFrameHealthBar:UnregisterAllEvents()
    TargetFrameManaBar:UnregisterAllEvents()
    TargetFrame:Hide()
    TargetFrameToT:UnregisterAllEvents()
    TargetFrameToT:Hide()
end

function HealBot_Options_EnableTargetFrame()
    TargetFrame:RegisterAllEvents()
    TargetFrameHealthBar:RegisterAllEvents()
    TargetFrameManaBar:RegisterAllEvents()
    TargetFrameToT:RegisterAllEvents()
end

function HealBot_Options_SetSliderValue(slider,value,updating)
    updatingMedia = updating
    slider:SetValue(-1) -- Pre change value so that text gets updated if value does not change but media does
    updatingMedia = updating
    slider:SetValue(value or 0)
end

function HealBot_Options_UpdateMedia(panel)
    HealBot_AddDebug("Update Media Called")
    if panel == 3 then
        textures = LSM:List('statusbar');
        for x,_ in pairs(texturesIndex) do
            texturesIndex[x]=nil
        end 
        for i=1,#textures do
            texturesIndex[textures[i]] = i
        end
        fonts = LSM:List('font');
        for x,_ in pairs(fontsIndex) do
            fontsIndex[x]=nil
        end 
        for i=1,#fonts do
            fontsIndex[fonts[i]] = i
        end
        HealBot_Options_val_OnLoad(HealBot_Options_HeadTextureS,HEALBOT_OPTIONS_SKINTEXTURE,1,#textures,1)
        HealBot_Options_val_OnLoad(HealBot_Options_HeadFontNameS,HEALBOT_OPTIONS_SKINFONT,1,#fonts,1)
        HealBot_Options_SetSliderValue(HealBot_Options_HeadTextureS,texturesIndex[Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]],true)
        HealBot_Options_SetSliderValue(HealBot_Options_HeadFontNameS,fontsIndex[Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]],true)
        HealBot_Options_val_OnLoad(HealBot_Options_BarTextureS,HEALBOT_OPTIONS_SKINTEXTURE,1,#textures,1)
        HealBot_Options_val_OnLoad(HealBot_Options_FontName,HEALBOT_OPTIONS_SKINFONT,1,#fonts,1)
        HealBot_Options_SetSliderValue(HealBot_Options_BarTextureS,texturesIndex[Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]],true)
        HealBot_Options_SetSliderValue(HealBot_Options_FontName,fontsIndex[Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]],true)
    elseif panel == 4 then
        sounds = LSM:List('sound');
        for x,_ in pairs(soundsIndex) do
            soundsIndex[x]=nil
        end 
        for i=1,#sounds do
            soundsIndex[sounds[i]] = i
        end
        HealBot_Options_val_OnLoad(HealBot_Options_WarningSound,HEALBOT_OPTIONS_SOUND,1,#sounds,1)
        HealBot_Options_SetSliderValue(HealBot_Options_WarningSound,soundsIndex[HealBot_Config.SoundDebuffPlay],true)
    end
end

function HealBot_UpdateUsedMedia(event, mediatype, key)
    if mediatype == "statusbar" then
        if Healbot_Config_Skins.headtexture and key == Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin] then 
            for x=1,15 do
                h=_G["HealBot_Action_Header"..x];
                bar = HealBot_Action_HealthBar(h);
                bar:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.headtexture[Healbot_Config_Skins.Current_Skin]));
                bar:GetStatusBarTexture():SetHorizTile(false)
                bar.txt = _G[bar:GetName().."_text"];
                bar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]]);
            end
        end
        if Healbot_Config_Skins.btexture and key == Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin] then 
            for x=1,51 do
                b=_G["HealBot_Action_HealUnit"..x];
                bar = HealBot_Action_HealthBar(b);
                bar2 = HealBot_Action_HealthBar2(b);
                bar3 = HealBot_Action_HealthBar3(b);
                bar:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
                bar2:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
                bar3:SetStatusBarTexture(LSM:Fetch('statusbar',Healbot_Config_Skins.btexture[Healbot_Config_Skins.Current_Skin]));
                bar:GetStatusBarTexture():SetHorizTile(false)
                bar2:GetStatusBarTexture():SetHorizTile(false)
                bar3:GetStatusBarTexture():SetHorizTile(false)
            end            
        end
    elseif mediatype == "font" then
        if Healbot_Config_Skins.headtextfont and key == Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin] then
            for x=1,15 do
                h=_G["HealBot_Action_Header"..x];
                bar = HealBot_Action_HealthBar(h);
                bar.txt = _G[bar:GetName().."_text"];
                bar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.headtextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.headtextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[Healbot_Config_Skins.headtextoutline[Healbot_Config_Skins.Current_Skin]]);
            end
        end
        if Healbot_Config_Skins.btextfont and key == Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin] then
            for x=1,51 do
                b=_G["HealBot_Action_HealUnit"..x];
                bar = HealBot_Action_HealthBar(b);
                bar.txt = _G[bar:GetName().."_text"];
                bar.txt:SetFont(LSM:Fetch('font',Healbot_Config_Skins.btextfont[Healbot_Config_Skins.Current_Skin]),Healbot_Config_Skins.btextheight[Healbot_Config_Skins.Current_Skin],HealBot_Font_Outline[Healbot_Config_Skins.btextoutline[Healbot_Config_Skins.Current_Skin]]);
            end        
        end
    --elseif mediatype == "background" then
    --elseif mediatype == "border" then
    elseif mediatype == "sound" then
        if key == HealBot_Config.SoundDebuffPlay then
        -- Do nothing
        end
    end
end
