local i=nil
local HB_mana=nil
local HB_cast=nil
local tmpText=nil
local line=nil
local tmpTest=nil
local tmpTest2=nil
local hbHealsMin=nil
local hbHealsMax=nil
local spell=nil
local spellrank=nil
local line1=nil
local line2=nil
local line3=nil
local SmartCast_Res=nil;
local HealBot_Spec = {}
local TempSkins = {}
local tonumber=tonumber
local strfind=strfind
local floor=floor
local strsub=strsub

function HealBot_Init_retSmartCast_Res()
    return SmartCast_Res
end

function HealBot_Init_SetSpec()
HealBot_Spec = {
    ["DRUI"] = { [1] = HEALBOT_BALANCE,       [2] = HEALBOT_FERAL,        [3] = HEALBOT_RESTORATION, },
    ["MAGE"] = { [1] = HEALBOT_ARCANE,        [2] = HEALBOT_FIRE,         [3] = HEALBOT_FROST,       },
    ["PRIE"] = { [1] = HEALBOT_DISCIPLINE,    [2] = HEALBOT_HOLY,         [3] = HEALBOT_SHADOW,      },
    ["ROGU"] = { [1] = HEALBOT_ASSASSINATION, [2] = HEALBOT_COMBAT,       [3] = HEALBOT_SUBTLETY,    },
    ["WARR"] = { [1] = HEALBOT_ARMS,          [2] = HEALBOT_FURY,         [3] = HEALBOT_PROTECTION,  },
    ["HUNT"] = { [1] = HEALBOT_BEASTMASTERY,  [2] = HEALBOT_MARKSMANSHIP, [3] = HEALBOT_SURVIVAL,    },
    ["PALA"] = { [1] = HEALBOT_HOLY,          [2] = HEALBOT_PROTECTION,   [3] = HEALBOT_RETRIBUTION, },
    ["SHAM"] = { [1] = HEALBOT_ELEMENTAL,     [2] = HEALBOT_ENHANCEMENT,  [3] = HEALBOT_SHAMAN_RESTORATION, },
    ["WARL"] = { [1] = HEALBOT_AFFLICTION,    [2] = HEALBOT_DEMONOLOGY,   [3] = HEALBOT_DESTRUCTION, },
    ["DEAT"] = { [1] = HEALBOT_BLOOD,         [2] = HEALBOT_FROST,        [3] = HEALBOT_UNHOLY, },
    }
end

function HealBot_Init_retSpec(class,tab)
    if HealBot_Spec[class] and HealBot_Spec[class][tab] then
        return HealBot_Spec[class][tab]
    end
    return nil
end

function HealBot_InitGetSpellData(spell, id, class, spellname)

    if ( not spell ) then return end
  
    HB_cast=nil
    HB_mana=nil
    
   -- name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange 
    _, _, _, HB_mana, _, _, HB_cast, _, _ = GetSpellInfo(spell)

    if HB_cast then HB_cast=HealBot_Comm_round(HB_cast/1000,2) end
   
    HealBot_TooltipInit();
    HealBot_ScanTooltip:SetSpellBookItem( id, BOOKTYPE_SPELL );
    tmpText = _G["HealBot_ScanTooltipTextLeft2"];
    if (tmpText:GetText()) and not HB_mana then
        line = tmpText:GetText();
        tmpTest,tmpTest,HB_mana = strfind(line, HB_TOOLTIP_MANA ); 
    end
    tmpText = _G["HealBot_ScanTooltipTextLeft3"];
    if (tmpText:GetText()) then
        line = tmpText:GetText();
        if ( line == HB_TOOLTIP_INSTANT_CAST ) then
            HB_cast = 0;
        elseif line == HB_TOOLTIP_CHANNELED then
            HB_cast = 0;
        elseif ( tmpText ) then
            tmpTest,tmpTest,HB_cast = strfind(line, HB_TOOLTIP_CAST_TIME ); 
        end
    end  
    if HB_cast then
        HealBot_Spells[spell].CastTime=tonumber(HB_cast);
    end
    if HB_mana then
        HealBot_Spells[spell].Mana=tonumber(HB_mana);
    end
    HealBot_InitClearSpellNils(spell)
end

function HealBot_InitClearSpellNils(spell)
    if not HealBot_Spells[spell].CastTime then
        HealBot_Spells[spell].CastTime=0;
    end
    if not HealBot_Spells[spell].Mana then
        HealBot_Spells[spell].Mana=10*UnitLevel("player");
    end
    if not HealBot_Spells[spell].Level then
        HealBot_Spells[spell].Level = 1;
    end
end

function HealBot_Generic_Patten(matchStr,matchPattern)
    tmpTest2,tmpTest2,hbHealsMin,hbHealsMax = strfind(matchStr, matchPattern ); 
    return tmpTest2,hbHealsMin,hbHealsMax;
end

function HealBot_FindSpellRangeCast(id)

    if ( not id ) then return; end
  
    spell,spellrank = HealBot_GetSpellName(id);
    if spell==HEALBOT_HOLY_WORD_SERENITY then 
        spell=HEALBOT_HOLY_WORD_CHASTISE 
        id=HealBot_GetSpellId(HEALBOT_HOLY_WORD_CHASTISE)
    end
    if spellrank then 
        spell=spell.."("..spellrank..")"; 
    end
  
    HealBot_TooltipInit();
    HealBot_ScanTooltip:SetSpellBookItem( id, BOOKTYPE_SPELL );
 
    if HealBot_ScanTooltipTextLeft2:GetText() then
        line1=HealBot_ScanTooltipTextLeft2:GetText();
    end
    if HealBot_ScanTooltipTextRight2:GetText() then
        line2 = HealBot_ScanTooltipTextRight2:GetText()
    end
    if HealBot_ScanTooltipTextLeft3:GetText() then
        line3 = HealBot_ScanTooltipTextLeft3:GetText();
    end
  
    if line1 then
        tmpTest,tmpTest,HB_mana = strfind(line1, HB_TOOLTIP_MANA ); 
    end

    if line3 then
        if ( line3 == HB_TOOLTIP_INSTANT_CAST ) then
            HB_cast = 0;
        elseif line3 == HB_TOOLTIP_CHANNELED then
            HB_cast = 0;
        elseif ( line3 ) then
            tmpTest,tmpTest,HB_cast = strfind(line3, HB_TOOLTIP_CAST_TIME ); 
        end
    end  

    HealBot_OtherSpells[spell] = {spell = {}};
    if not HB_cast then
        HealBot_OtherSpells[spell].CastTime=0;
    else
        HealBot_OtherSpells[spell].CastTime=tonumber(HB_cast);
    end
    if not HB_mana then
        HealBot_OtherSpells[spell].Mana=10*UnitLevel("player");
    else
        HealBot_OtherSpells[spell].Mana=tonumber(HB_mana);
    end
end

function HealBot_Init_Spells_Defaults(class)

--  if strsub(class,1,4)==HealBot_Class_En[HEALBOT_PALADIN] then
-- PALADIN
    HealBot_Spells = {
        [HEALBOT_HOLY_LIGHT] = {
            CastTime = 2.5, Mana =  35, Level = 7 },

        [HEALBOT_FLASH_OF_LIGHT] = {
            CastTime = 1.5, Mana =  35, Level = 16 },
    
        [HEALBOT_WORD_OF_GLORY] = {
            CastTime = 0, Mana =  35, Level = 9 },
         
        [HEALBOT_DIVINE_LIGHT] = {
            CastTime = 3, Mana =  35, Level = 62 },        
        
        [HEALBOT_HOLY_RADIANCE] = {
            CastTime = 0, Mana = 200, Level = 83}, 

        [HEALBOT_LIGHT_OF_DAWN] = {
            CastTime = 0, Mana =  35, Level = 20 },
            
        [HEALBOT_REDEMPTION] = {
            CastTime = 10, Mana = 155, Level = 12 }, 
           
        [HEALBOT_LAY_ON_HANDS] = {
            CastTime = 0, Mana = 155, Level = 16 }, 
            
        [HEALBOT_LAY_ON_HANDS] = {
            CastTime = 0, Mana = 155, Level = 16 }, 
            
        [HEALBOT_SEAL_OF_INSIGHT] = {
            CastTime = 0, Mana = 155, Level = 32 }, 
            
        [HEALBOT_CLEANSE] = {
            CastTime = 0, Mana = 155, Level = 34 }, 
            
        [HEALBOT_CONCENTRATION_AURA] = {
            CastTime = 0, Mana = 155, Level = 42 }, 
            
        [HEALBOT_DIVINE_PLEA] = {
            CastTime = 0, Mana = 155, Level = 44 }, 
            
        [HEALBOT_SEAL_OF_RIGHTEOUSNESS] = {
            CastTime = 0, Mana = 155, Level = 3 }, 
        
        [HEALBOT_DEVOTION_AURA] = {
            CastTime = 0, Mana = 155, Level = 5 }, 
            
        [HEALBOT_HAND_OF_PROTECTION] = {
            CastTime = 0, Mana = 155, Level = 18 }, 
            
        [HEALBOT_BLESSING_OF_KINGS] = {
            CastTime = 0, Mana = 155, Level = 22 }, 
            
        [HEALBOT_RIGHTEOUS_DEFENSE] = {
            CastTime = 0, Mana = 155, Level = 36 }, 
            
        [HEALBOT_DIVINE_SHIELD] = {
            CastTime = 0, Mana = 155, Level = 48 }, 
            
        [HEALBOT_HAND_OF_FREEDOM] = {
            CastTime = 0, Mana = 155, Level = 52 }, 
            
        [HEALBOT_SEAL_OF_JUSTICE] = {
            CastTime = 0, Mana = 155, Level = 64 }, 
            
        [HEALBOT_HAND_OF_SALVATION] = {
            CastTime = 0, Mana = 155, Level = 66 }, 
            
        [HEALBOT_RESISTANCE_AURA] = {
            CastTime = 0, Mana = 155, Level = 76 }, 
            
        [HEALBOT_HAND_OF_SACRIFICE] = {
            CastTime = 0, Mana = 155, Level = 80 }, 
            
        [HEALBOT_RETRIBUTION_AURA] = {
            CastTime = 0, Mana = 155, Level = 26 }, 
            
        [HEALBOT_SEAL_OF_TRUTH] = {
            CastTime = 0, Mana = 155, Level = 44 }, 
            
        [HEALBOT_BLESSING_OF_MIGHT] = {
            CastTime = 0, Mana = 155, Level = 56 }, 
            
        [HEALBOT_CRUSADER_AURA] = {
            CastTime = 0, Mana = 155, Level = 62 }, 
        
--    };
--  end

--  if strsub(class,1,4)==HealBot_Class_En[HEALBOT_DRUID] then
-- DRUID
--    HealBot_Spells = {

        [HEALBOT_REJUVENATION] = { 
            CastTime = 0, Mana =  25, Level =  3, HoT=HEALBOT_REJUVENATION},

        [HEALBOT_HEALING_TOUCH] = {
            CastTime = 1.5, Mana =  25, Level  = 78 },
 
        [HEALBOT_NOURISH] = {
            CastTime = 1.5, Mana = 1400, Level = 8 },
 
        [HEALBOT_REGROWTH] = {
            CastTime = 2, Mana =  80, Level = 12, HoT=HEALBOT_REGROWTH},
    
        [HEALBOT_LIFEBLOOM] = {
            CastTime = 0, Mana = 220, Level = 64, HoT=HEALBOT_LIFEBLOOM},

        [HEALBOT_WILD_GROWTH] = {
            CastTime = 0, Mana = 200, Level = 30, HoT=HEALBOT_WILD_GROWTH}, 

        [HEALBOT_TRANQUILITY] = {
            CastTime = 0, Mana = 200, Level = 68},  

        [HEALBOT_REVIVE] = {
            CastTime = 0, Mana = 155, Level = 12 },  

        [HEALBOT_OMEN_OF_CLARITY] = {
            CastTime = 0, Mana = 155, Level = 20 },                   

        [HEALBOT_REBIRTH] = {
            CastTime = 0, Mana = 155, Level = 20 },  

        [HEALBOT_REMOVE_CORRUPTION] = {
            CastTime = 0, Mana = 155, Level = 24 },  

        [HEALBOT_MARK_OF_THE_WILD] = {
            CastTime = 0, Mana = 155, Level = 30 },  

        [HEALBOT_THORNS] = {
            CastTime = 0, Mana = 155, Level = 5 },  
            
        [HEALBOT_NATURES_GRASP] = {
            CastTime = 0, Mana = 155, Level = 52 },  

        [HEALBOT_INNERVATE] = {
            CastTime = 0, Mana = 155, Level = 28 },  

        [HEALBOT_BARKSKIN] = {
            CastTime = 0, Mana = 155, Level = 58 },  

--    };
--  end

--  if strsub(class,1,4)==HealBot_Class_En[HEALBOT_PRIEST] then
-- PRIEST
--    HealBot_Spells = {

        [HEALBOT_HEAL] = {
            CastTime = 3.0, Mana = 155, Level = 16 }, 

        [HEALBOT_GREATER_HEAL] = {
            CastTime = 3.0, Mana =  370, Level = 38 }, 
    
        [HEALBOT_BINDING_HEAL] = {
            CastTime = 1.5, Mana =  705, Level = 48 }, 
    
        [HEALBOT_PRAYER_OF_MENDING] = {
            CastTime = 0, Mana =  390, Level = 68 }, 
    
        [HEALBOT_PRAYER_OF_HEALING] = {
            CastTime = 3.0, Mana =  410, Level = 44 }, 

        [HEALBOT_PENANCE] = {
            CastTime = 0, Mana =  400, Level =  10}, 
            
        [HEALBOT_RENEW] = {
            CastTime = 0, Mana =  30, Level =  8, HoT=HEALBOT_RENEW}, 
    
        [HEALBOT_FLASH_HEAL] = {
            CastTime = 1.5, Mana = 125, Level = 3 }, 
    
        [HEALBOT_POWER_WORD_SHIELD] = {
            CastTime = 0, Mana =  45, Level = 5 }, 
            
        [HEALBOT_DIVINE_HYMN] = {
            CastTime = 0, Mana =  30, Level = 78}, 

        [HEALBOT_HOLY_NOVA] = {
            CastTime = 3.0, Mana = 155, Level = 62 }, 
            
        [HEALBOT_INNER_FIRE] = {
            CastTime = 0, Mana = 155, Level = 7 }, 
            
        [HEALBOT_INNER_WILL] = {
            CastTime = 0, Mana = 155, Level = 83 }, 
            
        [HEALBOT_RESURRECTION] = {
            CastTime = 0, Mana = 155, Level = 14 }, 
            
        [HEALBOT_CURE_DISEASE] = {
            CastTime = 0, Mana = 155, Level = 22 },
            
        [HEALBOT_POWER_WORD_FORTITUDE] = {
            CastTime = 0, Mana = 155, Level = 14},
            
        [HEALBOT_DISPEL_MAGIC] = {
            CastTime = 0, Mana = 155, Level = 26 },

        [HEALBOT_LEVITATE] = {
            CastTime = 0, Mana = 155, Level = 34 },
            
        [HEALBOT_FEAR_WARD] = {
            CastTime = 0, Mana = 155, Level = 54 },
            
        [HEALBOT_SHADOW_PROTECTION] = {
            CastTime = 0, Mana = 155, Level = 52},
            
        [HEALBOT_LEAP_OF_FAITH] = {
            CastTime = 0, Mana = 155, Level = 85},
--    };
--  end

--  if strsub(class,1,4)==HealBot_Class_En[HEALBOT_SHAMAN] then
-- SHAMAN
--    HealBot_Spells = {

        [HEALBOT_HEALING_WAVE] = {
             CastTime = 1.5, Mana =  25, Level =  7 }, 

        [HEALBOT_GREATER_HEALING_WAVE] = {
             CastTime = 3, Mana = 105,Level = 68 }, 
    
        [HEALBOT_CHAIN_HEAL] = {
            CastTime = 2.5, Mana = 260, Level = 40 },

        [HEALBOT_EARTH_SHIELD] = {
            CastTime = 0, Mana = 0, Level = 10 },

        [HEALBOT_WATER_SHIELD] = {
            CastTime = 0, Mana = 0, Level = 20 },

        [HEALBOT_RIPTIDE] = {
            CastTime = 0, Mana = 250, Level = 1, HoT=HEALBOT_RIPTIDE },
			
        [HEALBOT_HEALING_RAIN] = {
            CastTime = 0, Mana = 250, Level = 83 },
            
        [HEALBOT_HEALING_SURGE] = {
           CastTime = 1.5, Mana = 105, Level = 20 }, 
           
        [HEALBOT_ANCESTRALSPIRIT] = {
            CastTime = 0, Mana = 155, Level = 12 }, 
            
        [HEALBOT_CLEANSE_SPIRIT] = {
            CastTime = 0, Mana = 155, Level = 18 }, 
            
        [HEALBOT_WATER_SHIELD] = {
            CastTime = 0, Mana = 155, Level = 20 }, 
            
        [HEALBOT_LIGHTNING_SHIELD] = {
            CastTime = 0, Mana = 155, Level = 8 }, 
            
        [HEALBOT_EARTHLIVING_WEAPON] = {
            CastTime = 0, Mana = 155, Level = 54 }, 
            
        [HEALBOT_FLAMETONGUE_WEAPON] = {
            CastTime = 0, Mana = 155, Level = 10 }, 
            
        [HEALBOT_FROSTBRAND_WEAPON] = {
            CastTime = 0, Mana = 155, Level = 26 }, 
            
        [HEALBOT_WINDFURY_WEAPON] = {
            CastTime = 0, Mana = 155, Level = 32 }, 
            
        [HEALBOT_ROCKBITER_WEAPON] = {
            CastTime = 0, Mana = 155, Level = 75 }, 
            
        [HEALBOT_WATER_WALKING] = {
            CastTime = 0, Mana = 155, Level = 24 }, 
            
        [HEALBOT_WATER_BREATHING] = {
            CastTime = 0, Mana = 155, Level = 46 }, 
            
--    };
--  end

--  if strsub(class,1,4)==HealBot_Class_En[HEALBOT_HUNTER] then
--  Hunter
--    HealBot_Spells = {
        [HEALBOT_MENDPET] = {
            CastTime = 0, Mana =  40, Level = 12}, 
            
        [HEALBOT_A_FOX] = {
            CastTime = 0, Mana = 155, Level = 83 }, 
    };
--  end

end


function HealBot_Init_SmartCast()
    if strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then
        SmartCast_Res=HEALBOT_RESURRECTION;
    elseif strsub(HealBot_PlayerClassEN,1,4)=="DRUI" then
        SmartCast_Res=HEALBOT_REVIVE;
    elseif strsub(HealBot_PlayerClassEN,1,4)=="PALA" then
        SmartCast_Res=HEALBOT_REDEMPTION;
    elseif strsub(HealBot_PlayerClassEN,1,4)=="SHAM" then
        SmartCast_Res=HEALBOT_ANCESTRALSPIRIT;
    end
end
