------------
-- GERMAN --
------------

-- Ä = \195\132
-- Ö = \195\150
-- Ü = \195\156
-- ß = \195\159
-- ä = \195\164
-- ö = \195\182
-- ü = \195\188


if (GetLocale() == "deDE") then

-------------------
-- Compatibility --
-------------------

-- Class
HEALBOT_DRUID                           = "Druide";
HEALBOT_HUNTER                          = "J\195\164ger";
HEALBOT_MAGE                            = "Magier";
HEALBOT_PALADIN                         = "Paladin";
HEALBOT_PRIEST                          = "Priester";
HEALBOT_ROGUE                           = "Schurke";
HEALBOT_SHAMAN                          = "Schamane";
HEALBOT_WARLOCK                         = "Hexenmeister";
HEALBOT_WARRIOR                         = "Krieger";
HEALBOT_DEATHKNIGHT                     = "Todesritter";

-- Bandages and pots
HEALBOT_SILK_BANDAGE                    = GetItemInfo(6450) or "Seidenverband";
HEALBOT_HEAVY_SILK_BANDAGE              = GetItemInfo(6451) or "Schwerer Seidenverband";
HEALBOT_MAGEWEAVE_BANDAGE               = GetItemInfo(8544) or "Magiestoffverband";
HEALBOT_HEAVY_MAGEWEAVE_BANDAGE         = GetItemInfo(8545) or "Schwerer Magiestoffverband";
HEALBOT_RUNECLOTH_BANDAGE               = GetItemInfo(14529) or "Runenstoffverband";
HEALBOT_HEAVY_RUNECLOTH_BANDAGE         = GetItemInfo(14530) or "Heavy Runecloth Bandage";
HEALBOT_NETHERWEAVE_BANDAGE             = GetItemInfo(21990) or "Netherweave Bandage";
HEALBOT_HEAVY_NETHERWEAVE_BANDAGE       = GetItemInfo(21991) or "Schwerer Runenstoffverband";
HEALBOT_FROSTWEAVE_BANDAGE              = GetItemInfo(34721) or "Froststoffverband";
HEALBOT_HEAVY_FROSTWEAVE_BANDAGE        = GetItemInfo(34722) or "Schwerer Froststoffverband";
HEALBOT_MAJOR_HEALING_POTION            = GetItemInfo(13446) or "Erheblicher Heiltrank";
HEALBOT_SUPER_HEALING_POTION            = GetItemInfo(22829) or "Erstklassiger Heiltrank";
HEALBOT_MAJOR_COMBAT_HEALING_POTION     = GetItemInfo(31838) or "Erheblicher Gefechtsheiltrank";
HEALBOT_RUNIC_HEALING_POTION            = GetItemInfo(33447) or "Runenverzierter Heiltrank";
HEALBOT_ENDLESS_HEALING_POTION          = GetItemInfo(43569) or "Endloser Heiltrank";   
HEALBOT_MAJOR_MANA_POTION               = GetItemInfo(13444) or "Erheblicher Manatrank";
HEALBOT_SUPER_MANA_POTION               = GetItemInfo(22832) or "Erstklassiger Manatrank";
HEALBOT_MAJOR_COMBAT_MANA_POTION        = GetItemInfo(31840) or "Erheblicher Gefechtsmanatrank";
HEALBOT_RUNIC_MANA_POTION               = GetItemInfo(33448) or "Runenverzierter Manatrank";
HEALBOT_ENDLESS_MANA_POTION             = GetItemInfo(43570) or "Endloser Manatrank";
HEALBOT_PURIFICATION_POTION             = GetItemInfo(13462) or "L\195\164uterungstrank";
HEALBOT_ANTI_VENOM                      = GetItemInfo(6452) or "Gegengift";
HEALBOT_POWERFUL_ANTI_VENOM             = GetItemInfo(19440) or "M\195\164chtiges Gegengift";
HEALBOT_ELIXIR_OF_POISON_RES            = GetItemInfo(3386) or "Trank der Genesung";

-- Racial abilities and item procs
HEALBOT_STONEFORM                       = GetSpellInfo(20594) or "Steingestalt";
HEALBOT_GIFT_OF_THE_NAARU               = GetSpellInfo(59547) or "Gabe der Naaru";
HEALBOT_PROTANCIENTKINGS                = GetSpellInfo(64413) or "Schutz der Uralten K\195\182nige";

-- Healing spells by class
HEALBOT_REJUVENATION                    = GetSpellInfo(774) or "Verj\195\188ngung";
HEALBOT_LIFEBLOOM                       = GetSpellInfo(33763) or "Bl\195\188hendes Leben";
HEALBOT_WILD_GROWTH                     = GetSpellInfo(48438) or "Wildwuchs";
HEALBOT_TRANQUILITY                     = GetSpellInfo(740) or "Gelassenheit";
HEALBOT_SWIFTMEND                       = GetSpellInfo(18562) or "Rasche Heilung";
HEALBOT_LIVING_SEED                     = GetSpellInfo(48496) or "Samenkorn des Lebens";
HEALBOT_REGROWTH                        = GetSpellInfo(8936) or "Nachwachsen";
HEALBOT_HEALING_TOUCH                   = GetSpellInfo(5185) or "Heilende Ber\195\188hrung";
HEALBOT_NOURISH                         = GetSpellInfo(50464) or "Pflege";

HEALBOT_FLASH_OF_LIGHT                  = GetSpellInfo(19750) or "Lichtblitz";
HEALBOT_WORD_OF_GLORY                   = GetSpellInfo(85673) or "Wort der Herrlichkeit";
HEALBOT_LIGHT_OF_DAWN                   = GetSpellInfo(85222) or "Licht der Morgend\195\164mmerung";
HEALBOT_HOLY_LIGHT                      = GetSpellInfo(635) or "Heiliges Licht";
HEALBOT_DIVINE_LIGHT                    = GetSpellInfo(82326) or "G\195\182ttliches Licht";
HEALBOT_HOLY_RADIANCE                   = GetSpellInfo(82327) or "Heiliges Strahlen";

HEALBOT_GREATER_HEAL                    = GetSpellInfo(2060) or "Gro\195\159e Heilung";
HEALBOT_BINDING_HEAL                    = GetSpellInfo(32546) or "Verbindende Heilung"
HEALBOT_PENANCE                         = GetSpellInfo(47540) or "S\195\188hne"
HEALBOT_PRAYER_OF_MENDING               = GetSpellInfo(33076) or "Gebet der Besserung";
HEALBOT_FLASH_HEAL                      = GetSpellInfo(2061) or "Blitzheilung";
HEALBOT_HEAL                            = GetSpellInfo(2050) or "Heilung";
HEALBOT_HOLY_NOVA                       = GetSpellInfo(15237) or "Heilige Nova";
HEALBOT_DIVINE_HYMN                     = GetSpellInfo(64843) or "Gotteshymne";
HEALBOT_RENEW                           = GetSpellInfo(139) or "Erneuerung";
HEALBOT_DESPERATE_PRAYER                = GetSpellInfo(19236) or "Verzweifeltes Gebet";
HEALBOT_PRAYER_OF_HEALING               = GetSpellInfo(596) or "Gebet der Heilung";
HEALBOT_CIRCLE_OF_HEALING               = GetSpellInfo(34861) or "Kreis der Heilung";
HEALBOT_HOLY_WORD_CHASTISE              = GetSpellInfo(88625) or "Segenswort: Z\195\188chtigung";
HEALBOT_HOLY_WORD_SERENITY              = GetSpellInfo(88684) or "Segenswort: Epiphanie"; -- Heal
HEALBOT_HOLY_WORD_ASPIRE                = GetSpellInfo(88682) or "Segenswort: Passion"; -- Renew - 88682
HEALBOT_HOLY_WORD_SANCTUARY             = GetSpellInfo(88685) or "Segenswort: Refugium"; -- PoH

HEALBOT_HEALING_WAVE                    = GetSpellInfo(331) or "Welle der Heilung";
HEALBOT_HEALING_SURGE                   = GetSpellInfo(8004) or "Heilende Woge";
HEALBOT_RIPTIDE                         = GetSpellInfo(61295) or "Springflut";
HEALBOT_HEALING_WAY                     = GetSpellInfo(29206) or "Pfad der Heilung";
HEALBOT_GREATER_HEALING_WAVE            = GetSpellInfo(77472) or "Gro\195\159e Welle der Heilung";
HEALBOT_HEALING_RAIN                    = GetSpellInfo(73920) or "Heilender Regen";
HEALBOT_CHAIN_HEAL                      = GetSpellInfo(1064) or "Kettenheilung";

HEALBOT_HEALTH_FUNNEL                   = GetSpellInfo(755) or "Lebenslinie";

-- Buffs, Talents and Other spells by class
HEALBOT_ICEBOUND_FORTITUDE              = GetSpellInfo(48792) or "Eisige Gegenwehr";
HEALBOT_ANTIMAGIC_SHELL                 = GetSpellInfo(48707) or "Antimagische H\195\188lle";
HEALBOT_ARMY_OF_THE_DEAD                = GetSpellInfo(42650) or "Armee der Toten";
HEALBOT_LICHBORNE                       = GetSpellInfo(49039) or "Lichritter";
HEALBOT_ANTIMAGIC_ZONE                  = GetSpellInfo(51052) or "Antimagisches Feld";
HEALBOT_VAMPIRIC_BLOOD                  = GetSpellInfo(55233) or "Vampirblut";
HEALBOT_BONE_SHIELD                     = GetSpellInfo(49222) or "Knochenschild";
HEALBOT_HORN_OF_WINTER                  = GetSpellInfo(57330) or "Horn des Winters";

HEALBOT_MARK_OF_THE_WILD                = GetSpellInfo(1126) or "Mal der Wildnis";
HEALBOT_THORNS                          = GetSpellInfo(467) or "Dornen";
HEALBOT_OMEN_OF_CLARITY                 = GetSpellInfo(16864) or "Omen der Klarsicht";
HEALBOT_BARKSKIN                        = GetSpellInfo(22812) or "Baumrinde";
HEALBOT_SURVIVAL_INSTINCTS              = GetSpellInfo(61336) or "\195\156berlebensinstinkte";
HEALBOT_FRENZIED_REGEN                  = GetSpellInfo(22842) or "Rasende Regeneration";
HEALBOT_INNERVATE                       = GetSpellInfo(29166) or "Anregen";

HEALBOT_A_FOX                           = GetSpellInfo(82661) or "Aspekt des Fuchses"
HEALBOT_A_HAWK                          = GetSpellInfo(13165) or "Aspekt des Falken"
HEALBOT_A_CHEETAH                       = GetSpellInfo(5118) or "Aspekt des Geparden"
HEALBOT_A_PACK                          = GetSpellInfo(13159) or "Aspekt des Rudels"
HEALBOT_A_WILD                          = GetSpellInfo(20043) or "Aspekt der Wildnis"
HEALBOT_MENDPET                         = GetSpellInfo(136) or "Tier heilen"

HEALBOT_ARCANE_BRILLIANCE               = GetSpellInfo(1459) or "Arkane Brillanz";
HEALBOT_DALARAN_BRILLIANCE              = GetSpellInfo(61316) or "Brillanz von Dalaran";
HEALBOT_MAGE_WARD                       = GetSpellInfo(543) or "Magiezauberschutz";
HEALBOT_MAGE_ARMOR                      = GetSpellInfo(6117) or "Magische R\195\188stung";
HEALBOT_MOLTEN_ARMOR                    = GetSpellInfo(30482) or "Gl\195\188hende R\195\188stung";
HEALBOT_FOCUS_MAGIC                     = GetSpellInfo(54646) or "Magie fokussieren";
HEALBOT_FROST_ARMOR                     = GetSpellInfo(12544) or "Frostr\195\188stung";

HEALBOT_HANDOFPROTECTION                = GetSpellInfo(1022) or "Hand des Schutzes";
HEALBOT_BEACON_OF_LIGHT                 = GetSpellInfo(53563) or "Flamme des Glaubens";
HEALBOT_LIGHT_BEACON                    = GetSpellInfo(53651) or "Glaubensflamme";
HEALBOT_CONVICTION                      = GetSpellInfo(20049) or "Schuldspruch";
HEALBOT_SACRED_SHIELD                   = GetSpellInfo(20925) or "Geheiligter Schild";
HEALBOT_LAY_ON_HANDS                    = GetSpellInfo(633) or "Handauflegung";
HEALBOT_INFUSION_OF_LIGHT               = GetSpellInfo(53569) or "Lichtenergie";
HEALBOT_SPEED_OF_LIGHT                  = GetSpellInfo(85495) or "Geschwindigkeit des Lichts";
HEALBOT_DAY_BREAK                       = GetSpellInfo(88820) or "Tagesanbruch";
HEALBOT_DENOUNCE                        = GetSpellInfo(31825) or "Denunzieren";
HEALBOT_CLARITY_OF_PURPOSE              = GetSpellInfo(85462) or "Klares Ziel";
HEALBOT_HOLY_SHOCK                      = GetSpellInfo(20473) or "Heiliger Schock";
HEALBOT_DIVINE_FAVOR                    = GetSpellInfo(31842) or "G\195\182ttliche Gunst";
HEALBOT_DIVINE_PLEA                     = GetSpellInfo(54428) or "G\195\182ttliche Bitte"
HEALBOT_DIVINE_SHIELD                   = GetSpellInfo(642) or "Gottesschild";
HEALBOT_RIGHTEOUS_DEFENSE               = GetSpellInfo(31789) or "Rechtschaffene Verteidigung";
HEALBOT_SHEATH_OF_LIGHT                 = GetSpellInfo(53503) or "Ummantelung des Lichts";
HEALBOT_BLESSING_OF_MIGHT               = GetSpellInfo(19740) or "Segen der Macht";
HEALBOT_BLESSING_OF_KINGS               = GetSpellInfo(20217) or "Segen der K\195\182nige";
HEALBOT_SEAL_OF_RIGHTEOUSNESS           = GetSpellInfo(25742) or "Siegel der Rechtschaffenheit";
HEALBOT_SEAL_OF_JUSTICE                 = GetSpellInfo(20164) or "Siegel der Gerechtigkeit";
HEALBOT_SEAL_OF_INSIGHT                 = GetSpellInfo(20165) or "Siegel der Einsicht";
HEALBOT_SEAL_OF_TRUTH                   = GetSpellInfo(31801) or "Siegel der Wahrheit";
HEALBOT_HAND_OF_FREEDOM                 = GetSpellInfo(1044) or "Hand der Freiheit";
HEALBOT_HAND_OF_PROTECTION              = GetSpellInfo(1022) or "Hand des Schutzes";
HEALBOT_HAND_OF_SACRIFICE               = GetSpellInfo(6940) or "Hand der Aufopferung";
HEALBOT_HAND_OF_SALVATION               = GetSpellInfo(1038) or "Hand der Erl\195\182sung";
HEALBOT_RIGHTEOUS_FURY                  = GetSpellInfo(25780) or "Zorn der Gerechtigkeit";
HEALBOT_AURA_MASTERY                    = GetSpellInfo(31821) or "Aurenbeherrschung";
HEALBOT_DEVOTION_AURA                   = GetSpellInfo(465) or "Aura der Hingabe";
HEALBOT_RETRIBUTION_AURA                = GetSpellInfo(7294) or "Aura der Vergeltung";
HEALBOT_RESISTANCE_AURA                 = GetSpellInfo(19891) or "Aura des Widerstands";
HEALBOT_CONCENTRATION_AURA              = GetSpellInfo(19746) or "Aura der Konzentration";
HEALBOT_CRUSADER_AURA                   = GetSpellInfo(32223) or "Aura des Kreuzfahrers";
HEALBOT_DIVINE_PROTECTION               = GetSpellInfo(498) or "G\195\182ttlicher Schutz";
HEALBOT_ILLUMINATED_HEALING             = GetSpellInfo(76669) or "Erleuchtete Heilung";
HEALBOT_ARDENT_DEFENDER                 = GetSpellInfo(31850) or "Unerm\195\188dlicher Verteidiger";

HEALBOT_POWER_WORD_SHIELD               = GetSpellInfo(17) or "Machtwort: Schild";
HEALBOT_ECHO_OF_LIGHT                   = GetSpellInfo(77485) or "Echo des Lichts";
HEALBOT_GUARDIAN_SPIRIT                 = GetSpellInfo(47788) or "Schutzgeist";
HEALBOT_LEVITATE                        = GetSpellInfo(1706) or "Levitieren";
HEALBOT_DIVINE_AEGIS                    = GetSpellInfo(47509) or "G\195\182ttliche Aegis";
HEALBOT_SURGE_OF_LIGHT                  = GetSpellInfo(33154) or "Woge des Lichts";
HEALBOT_BLESSED_HEALING                 = GetSpellInfo(70772) or "Gesegnete Heilung";
HEALBOT_BLESSED_RESILIENCE              = GetSpellInfo(33142) or "Gesegnete Abh\195\164rtung";
HEALBOT_PAIN_SUPPRESSION                = GetSpellInfo(33206) or "Schmerzunterdr\195\188ckung";
HEALBOT_POWER_INFUSION                  = GetSpellInfo(10060) or "Seele der Macht";
HEALBOT_POWER_WORD_FORTITUDE            = GetSpellInfo(21562) or "Machtwort: Seelenst\195\164rke";
HEALBOT_SHADOW_PROTECTION               = GetSpellInfo(27683) or "Schattenschutz";
HEALBOT_INNER_FIRE                      = GetSpellInfo(588) or "Inneres Feuer";
HEALBOT_INNER_WILL                      = GetSpellInfo(73413) or "Innerer Wille";
HEALBOT_SHADOWFORM                      = GetSpellInfo(15473) or "Schattengestalt"
HEALBOT_INNER_FOCUS                     = GetSpellInfo(89485) or "Innerer Fokus";
HEALBOT_CHAKRA                          = GetSpellInfo(14751) or "Chakra";
HEALBOT_CHAKRA_POH                      = GetSpellInfo(81206) or "Chakra: Gebet der Heilung";
HEALBOT_CHAKRA_RENEW                    = GetSpellInfo(81207) or "Chakra: Erneuerung";
HEALBOT_CHAKRA_HEAL                     = GetSpellInfo(81208) or "Chakra: Heilung";
HEALBOT_CHAKRA_SMITE                    = GetSpellInfo(81209) or "Chakra: Heilige Pein";
HEALBOT_REVELATIONS                     = GetSpellInfo(88627) or "Offenbarungen";
HEALBOT_FEAR_WARD                       = GetSpellInfo(6346) or "Furchtzauberschutz";
HEALBOT_SERENDIPITY                     = GetSpellInfo(63730) or "Gl\195\188cksfall";
HEALBOT_VAMPIRIC_EMBRACE                = GetSpellInfo(15286) or "Vampirumarmung";
HEALBOT_INSPIRATION                     = GetSpellInfo(14892) or "Inspiration";
HEALBOT_LIGHTWELL_RENEW                 = GetSpellInfo(7001) or "Erneuerung des Lichtbrunnens";
HEALBOT_GRACE                           = GetSpellInfo(47516) or "Barmherzigkeit";

HEALBOT_CHAINHEALHOT                    = GetSpellInfo(70809) or "Gekettete Heilung";
HEALBOT_TIDAL_WAVES                     = GetSpellInfo(51562) or "Flutwellen";
HEALBOT_TIDAL_FORCE                     = GetSpellInfo(55198) or "Kraft der Gezeiten";
HEALBOT_NATURE_SWIFTNESS                = GetSpellInfo(17116) or "Schnelligkeit der Natur";
HEALBOT_LIGHTNING_SHIELD                = GetSpellInfo(324) or "Blitzschlagschild";
HEALBOT_ROCKBITER_WEAPON                = GetSpellInfo(8017) or "Waffe des Felsbei\195\159ers";
HEALBOT_FLAMETONGUE_WEAPON              = GetSpellInfo(8024) or "Waffe der Flammenzunge";
HEALBOT_EARTHLIVING_WEAPON              = GetSpellInfo(51730) or "Waffe der Lebensgeister";
HEALBOT_WINDFURY_WEAPON                 = GetSpellInfo(8232) or "Waffe des Windzorns";
HEALBOT_FROSTBRAND_WEAPON               = GetSpellInfo(8033) or "Waffe des Frostbrands";
HEALBOT_EARTH_SHIELD                    = GetSpellInfo(974) or "Erdschild";
HEALBOT_WATER_SHIELD                    = GetSpellInfo(52127) or "Wasserschild";
HEALBOT_WATER_BREATHING                 = GetSpellInfo(131) or "Wasseratmung";
HEALBOT_WATER_WALKING                   = GetSpellInfo(546) or "Wasserwandeln";
HEALBOT_ANCESTRAL_FORTITUDE             = GetSpellInfo(16236) or "Seelenst\195\164rke der Ahnen";
HEALBOT_EARTHLIVING                     = GetSpellInfo(51945) or "Lebensgeister";

HEALBOT_DEMON_ARMOR                     = GetSpellInfo(687) or "D\195\164monenr\195\188stung";
HEALBOT_FEL_ARMOR                       = GetSpellInfo(28176) or "Teufelsr\195\188stung";
HEALBOT_SOUL_LINK                       = GetSpellInfo(19028) or "Seelenverbindung";
HEALBOT_UNENDING_BREATH                 = GetSpellInfo(5697) or "Unendlicher Atem"
HEALBOT_LIFE_TAP                        = GetSpellInfo(1454) or "Aderlass";
HEALBOT_BLOOD_PACT                      = GetSpellInfo(6307) or "Blutpakt";

HEALBOT_BATTLE_SHOUT                    = GetSpellInfo(6673) or "Schlachtruf";
HEALBOT_COMMANDING_SHOUT                = GetSpellInfo(469) or "Befehlsruf";
HEALBOT_INTERVENE                       = GetSpellInfo(3411) or "Einschreiten";
HEALBOT_VIGILANCE                       = GetSpellInfo(50720) or "Wachsamkeit";
HEALBOT_LAST_STAND                      = GetSpellInfo(12975) or "Letztes Gefecht";
HEALBOT_SHIELD_WALL                     = GetSpellInfo(871) or "Schildwall";
HEALBOT_SHIELD_BLOCK                    = GetSpellInfo(2565) or "Schildblock";
HEALBOT_ENRAGED_REGEN                   = GetSpellInfo(55694) or "W\195\188tende Regeneration";

-- Res Spells
HEALBOT_RESURRECTION                    = GetSpellInfo(2006) or "Auferstehung";
HEALBOT_REDEMPTION                      = GetSpellInfo(7328) or "Erl\195\182sung";
HEALBOT_REBIRTH                         = GetSpellInfo(20484) or "Wiedergeburt";
HEALBOT_REVIVE                          = GetSpellInfo(50769) or "Wiederbeleben";
HEALBOT_ANCESTRALSPIRIT                 = GetSpellInfo(2008) or "Geist der Ahnen";

-- Cure Spells
HEALBOT_CLEANSE                         = GetSpellInfo(4987) or "Reinigung des Glaubens";
HEALBOT_REMOVE_CURSE                    = GetSpellInfo(475) or "Fluch aufheben";
HEALBOT_REMOVE_CORRUPTION               = GetSpellInfo(2782) or "Verderbnis entfernen";
HEALBOT_NATURES_CURE                    = GetSpellInfo(88423) or "Heilung der Natur";
HEALBOT_CURE_DISEASE                    = GetSpellInfo(528) or "Krankheit heilen";
HEALBOT_DISPEL_MAGIC                    = GetSpellInfo(527) or "Magiebannung";
HEALBOT_CLEANSE_SPIRIT                  = GetSpellInfo(51886) or "Geistl\195\164uterung";
HEALBOT_IMPROVED_CLEANSE_SPIRIT         = GetSpellInfo(77130) or "Verbesserte Geistl\195\164uterung";
HEALBOT_SACRED_CLEANSING                = GetSpellInfo(53551) or "Heilige L\195\164uterung";
HEALBOT_BODY_AND_SOUL                   = GetSpellInfo(64127) or "K\195\182rper und Geist";
HEALBOT_DISEASE                         = "Krankheit";   
HEALBOT_MAGIC                           = "Magie";
HEALBOT_CURSE                           = "Fluch";   
HEALBOT_POISON                          = "Gift";
HEALBOT_DISEASE_en                      = "Disease";  -- Do NOT localize this value.
HEALBOT_MAGIC_en                        = "Magic";  -- Do NOT localize this value.
HEALBOT_CURSE_en                        = "Curse";  -- Do NOT localize this value.
HEALBOT_POISON_en                       = "Poison";  -- Do NOT localize this value.
HEALBOT_CUSTOM_en                       = "Custom";  -- Do NOT localize this value. 

-- Debuffs
HEALBOT_DEBUFF_ANCIENT_HYSTERIA         = "Uralte Hysterie";
HEALBOT_DEBUFF_IGNITE_MANA              = "Mana entz\195\188nden";
HEALBOT_DEBUFF_TAINTED_MIND             = "Besudelte Gedanken";
HEALBOT_DEBUFF_VIPER_STING              = "Vipernbiss";
HEALBOT_DEBUFF_SILENCE                  = "Stille";
HEALBOT_DEBUFF_MAGMA_SHACKLES           = "Magmafesseln";
HEALBOT_DEBUFF_FROSTBOLT                = "Frostblitz";
HEALBOT_DEBUFF_HUNTERS_MARK             = "Mal des J\195\164gers";
HEALBOT_DEBUFF_SLOW                     = "Verlangsamen";
HEALBOT_DEBUFF_ARCANE_BLAST             = "Arkanschlag";
HEALBOT_DEBUFF_IMPOTENCE                = "Fluch der Machtlosigkeit";
HEALBOT_DEBUFF_DECAYED_STR              = "Verfallene St\195\164rke";
HEALBOT_DEBUFF_DECAYED_INT              = "Verfallene Intelligenz";
HEALBOT_DEBUFF_CRIPPLE                  = "Verkr\195\188ppeln";
HEALBOT_DEBUFF_CHILLED                  = "K\195\164lte";
HEALBOT_DEBUFF_CONEOFCOLD               = "K\195\164ltekegel";
HEALBOT_DEBUFF_CONCUSSIVESHOT           = "Ersch\195\188tternder Schuss";
HEALBOT_DEBUFF_THUNDERCLAP              = "Donnerknall";         
HEALBOT_DEBUFF_HOWLINGSCREECH           = "Heulender Schrei";
HEALBOT_DEBUFF_DAZED                    = "Benommen";
HEALBOT_DEBUFF_UNSTABLE_AFFL            = "Instabiles Gebrechen";
HEALBOT_DEBUFF_DREAMLESS_SLEEP          = "Traumloser Schlaf";
HEALBOT_DEBUFF_GREATER_DREAMLESS        = "Gro\195\159er traumloser Schlaf";
HEALBOT_DEBUFF_MAJOR_DREAMLESS          = "\195\156berragender traumloser Schlaf";
HEALBOT_DEBUFF_FROST_SHOCK              = "Frostschock";
HEALBOT_DEBUFF_WEAKENED_SOUL            = GetSpellInfo(6788) or "Geschw\195\164chte Seele";

HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(29670) or "Eisgrab";
HEALBOT_DEBUFF_SACRIFICE                = GetSpellInfo(30115) or "Opferung";
HEALBOT_DEBUFF_ICEBOLT                  = GetSpellInfo(31249) or "Eisblitz";
HEALBOT_DEBUFF_DOOMFIRE                 = GetSpellInfo(31944) or "Verdammnisfeuer";
HEALBOT_DEBUFF_IMPALING_SPINE           = GetSpellInfo(39837) or "Pf\195\164hlstachel";
HEALBOT_DEBUFF_FEL_RAGE                 = GetSpellInfo(40604) or "Teufelswut";
HEALBOT_DEBUFF_FEL_RAGE2                = GetSpellInfo(40616) or "Teufelswut 2";
HEALBOT_DEBUFF_FATAL_ATTRACTION         = GetSpellInfo(41001) or "Verh\195\164ngnisvolle Aff\195\164re";
HEALBOT_DEBUFF_AGONIZING_FLAMES         = GetSpellInfo(40932) or "Peinigende Flammen";
HEALBOT_DEBUFF_DARK_BARRAGE             = GetSpellInfo(40585) or "Dunkles Sperrfeuer";
HEALBOT_DEBUFF_PARASITIC_SHADOWFIEND    = GetSpellInfo(41917) or "Sch\195\164dlicher Schattengeist";
HEALBOT_DEBUFF_GRIEVOUS_THROW           = GetSpellInfo(43093) or "Schrecklicher Wurf";
HEALBOT_DEBUFF_BURN                     = GetSpellInfo(46394) or "Brand";
HEALBOT_DEBUFF_ENCAPSULATE              = GetSpellInfo(45662) or "Einschlie\195\159en";
HEALBOT_DEBUFF_CONFLAGRATION            = GetSpellInfo(45342) or "Gro\195\159brand";
HEALBOT_DEBUFF_FLAME_SEAR               = GetSpellInfo(46771) or "Sengflamme";
HEALBOT_DEBUFF_FIRE_BLOOM               = GetSpellInfo(45641) or "Feuerbl\195\188te";
HEALBOT_DEBUFF_GRIEVOUS_BITE            = GetSpellInfo(48920) or "Schrecklicher Biss";
HEALBOT_DEBUFF_FROST_TOMB               = GetSpellInfo(25168) or "Frostgrab";
HEALBOT_DEBUFF_IMPALE                   = GetSpellInfo(67478) or "Pf\195\164hlen";
HEALBOT_DEBUFF_WEB_WRAP                 = GetSpellInfo(28622) or "Fangnetz";
HEALBOT_DEBUFF_JAGGED_KNIFE             = GetSpellInfo(55550) or "Gezacktes Messer";
HEALBOT_DEBUFF_FROST_BLAST              = GetSpellInfo(27808) or "Frostschlag";
HEALBOT_DEBUFF_SLAG_PIT                 = GetSpellInfo(63477) or "Schlackentopf";
HEALBOT_DEBUFF_GRAVITY_BOMB             = GetSpellInfo(64234) or "Gravitationsbombe";
HEALBOT_DEBUFF_LIGHT_BOMB               = GetSpellInfo(63018) or "Sengendes Licht";
HEALBOT_DEBUFF_STONE_GRIP               = GetSpellInfo(64292) or "Steinerner Griff";
HEALBOT_DEBUFF_FERAL_POUNCE             = GetSpellInfo(64669) or "Wildes Anspringen";
HEALBOT_DEBUFF_NAPALM_SHELL             = GetSpellInfo(63666) or "Brandbombe";
HEALBOT_DEBUFF_IRON_ROOTS               = GetSpellInfo(62283) or "Eiserne Wurzeln";
HEALBOT_DEBUFF_SARA_BLESSING            = GetSpellInfo(63134) or "Saras Segen";
HEALBOT_DEBUFF_SNOBOLLED                = GetSpellInfo(66406) or "Vom Schneebold getroffen!";
HEALBOT_DEBUFF_FIRE_BOMB                = GetSpellInfo(67475) or "Feuerbombe";
HEALBOT_DEBUFF_BURNING_BILE             = GetSpellInfo(66869) or "Brennende Galle";
HEALBOT_DEBUFF_PARALYTIC_TOXIN          = GetSpellInfo(67618) or "Paralysierendes Toxin";
HEALBOT_DEBUFF_INCINERATE_FLESH         = GetSpellInfo(67049) or "Fleisch ein\195\164schern";
HEALBOT_DEBUFF_LEGION_FLAME             = GetSpellInfo(68123) or "Legionsflamme";
HEALBOT_DEBUFF_MISTRESS_KISS            = GetSpellInfo(67078) or "Kuss der Herrin";
HEALBOT_DEBUFF_SPINNING_PAIN_SPIKE      = GetSpellInfo(66283) or "Windender Schmerzstachel";
HEALBOT_DEBUFF_TOUCH_OF_LIGHT           = GetSpellInfo(67297) or "Ber\195\188hrung des Lichts";
HEALBOT_DEBUFF_TOUCH_OF_DARKNESS        = GetSpellInfo(66001) or "Ber\195\188hrung der Nacht";
HEALBOT_DEBUFF_PENETRATING_COLD         = GetSpellInfo(66013) or "Durchdringende K\195\164lte";
HEALBOT_DEBUFF_ACID_DRENCHED_MANDIBLES  = GetSpellInfo(67861) or "S\195\164uregetr\195\164nkte Mandibeln";
HEALBOT_DEBUFF_EXPOSE_WEAKNESS          = GetSpellInfo(67847) or "Schw\195\164che aufdecken";
HEALBOT_DEBUFF_IMPALED                  = GetSpellInfo(69065) or "Aufgespie\195\159t";
HEALBOT_DEBUFF_NECROTIC_STRIKE          = GetSpellInfo(70659) or "Nekrotischer Sto\195\159";
HEALBOT_DEBUFF_FALLEN_CHAMPION          = GetSpellInfo(72293) or "Mal des gefallenen Champions";
HEALBOT_DEBUFF_BOILING_BLOOD            = GetSpellInfo(72385) or "Kochendes Blut";
HEALBOT_DEBUFF_RUNE_OF_BLOOD            = GetSpellInfo(72409) or "Rune des Blutes";
HEALBOT_DEBUFF_VILE_GAS                 = GetSpellInfo(72273) or "Ekelhaftes Gas";
HEALBOT_DEBUFF_GASTRIC_BLOAT            = GetSpellInfo(72219) or "Magenbl\195\164hung";
HEALBOT_DEBUFF_GAS_SPORE                = GetSpellInfo(69278) or "Gasspore";
HEALBOT_DEBUFF_INOCULATED               = GetSpellInfo(72103) or "Geimpft";
HEALBOT_DEBUFF_MUTATED_INFECTION        = GetSpellInfo(71224) or "Mutierte Infektion";
HEALBOT_DEBUFF_GASEOUS_BLOAT            = GetSpellInfo(72455) or "Gasf\195\182rmige Bl\195\164hung";
HEALBOT_DEBUFF_VOLATILE_OOZE            = GetSpellInfo(70447) or "Fl\195\188chtiger Schlammkleber";
HEALBOT_DEBUFF_MUTATED_PLAGUE           = GetSpellInfo(72745) or "Mutierte Seuche";
HEALBOT_DEBUFF_GLITTERING_SPARKS        = GetSpellInfo(72796) or "Glei\195\159ende Funken";
HEALBOT_DEBUFF_SHADOW_PRISON            = GetSpellInfo(72999) or "Schattengef\195\164ngnis";
HEALBOT_DEBUFF_SWARMING_SHADOWS         = GetSpellInfo(72638) or "Schw\195\164rmende Schatten";
HEALBOT_DEBUFF_PACT_DARKFALLEN          = GetSpellInfo(71340) or "Pakt der Sinistren";
HEALBOT_DEBUFF_ESSENCE_BLOOD_QUEEN      = GetSpellInfo(70867) or "Essenz der Blutk\195\182nigin";
HEALBOT_DEBUFF_DELIRIOUS_SLASH          = GetSpellInfo(71624) or "Hei\195\159bl\195\188tiges Schlitzen";
HEALBOT_DEBUFF_CORROSION                = GetSpellInfo(70751) or "Korrosion";
HEALBOT_DEBUFF_GUT_SPRAY                = GetSpellInfo(70633) or "Magens\195\164ure";
HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(70157) or "Eisgrab";
HEALBOT_DEBUFF_FROST_BEACON             = GetSpellInfo(70126) or "Frostleuchtfeuer";
HEALBOT_DEBUFF_CHILLED_BONE             = GetSpellInfo(70106) or "Durchgefroren";
HEALBOT_DEBUFF_INSTABILITY              = GetSpellInfo(69766) or "Instabilit\195\164t";
HEALBOT_DEBUFF_MYSTIC_BUFFET            = GetSpellInfo(70127) or "Mystischer Puffer";
HEALBOT_DEBUFF_FROST_BREATH             = GetSpellInfo(69649) or "Frostatem";
HEALBOT_DEBUFF_INFEST                   = GetSpellInfo(70541) or "Befallen";
HEALBOT_DEBUFF_NECROTIC_PLAGUE          = GetSpellInfo(70338) or "Nekrotische Seuche";
HEALBOT_DEBUFF_DEFILE                   = GetSpellInfo(72754) or "Entweihen";
HEALBOT_DEBUFF_HARVEST_SOUL             = GetSpellInfo(68980) or "Seele ernten";
HEALBOT_DEBUFF_FIERY_COMBUSTION         = GetSpellInfo(74562) or "Feurige Ein\195\164scherung";
HEALBOT_DEBUFF_COMBUSTION               = GetSpellInfo(75882) or "Ein\195\164schern";
HEALBOT_DEBUFF_SOUL_CONSUMPTION         = GetSpellInfo(74792) or "Seelenverzehrung";
HEALBOT_DEBUFF_CONSUMPTION              = GetSpellInfo(75875) or "Verzehrung";

HB_TOOLTIP_MANA                         = "^(%d+) Mana$";
HB_TOOLTIP_INSTANT_CAST                 = "Spontanzauber";
HB_TOOLTIP_CAST_TIME                    = "(%d+.?%d*) Sek";
HB_TOOLTIP_CHANNELED                    = "Abgebrochen"; 
HB_TOOLTIP_OFFLINE                      ="Offline";
HB_OFFLINE                              ="offline"; -- has gone offline msg
HB_ONLINE                               ="online"; -- has come online msg

-----------------
-- Translation --
-----------------

HEALBOT_ADDON                           = "HealBot " .. HEALBOT_VERSION;
HEALBOT_LOADED                          = " geladen.";

HEALBOT_ACTION_OPTIONS                  = "Optionen";

HEALBOT_OPTIONS_TITLE                   = HEALBOT_ADDON;
HEALBOT_OPTIONS_DEFAULTS                = "Defaults";
HEALBOT_OPTIONS_CLOSE                   = "Schlie\195\159en";
HEALBOT_OPTIONS_HARDRESET               = "ReloadUI"
HEALBOT_OPTIONS_SOFTRESET               = "ResetHB"
HEALBOT_OPTIONS_INFO                    = "Info"
HEALBOT_OPTIONS_TAB_GENERAL             = "Allg.";
HEALBOT_OPTIONS_TAB_SPELLS              = "Spr\195\188che";  
HEALBOT_OPTIONS_TAB_HEALING             = "Heilung";
HEALBOT_OPTIONS_TAB_CDC                 = "Debuffs";  
HEALBOT_OPTIONS_TAB_SKIN                = "Skin";   
HEALBOT_OPTIONS_TAB_TIPS                = "Tips";
HEALBOT_OPTIONS_TAB_BUFFS               = "Buffs";

HEALBOT_OPTIONS_BARALPHA                = "Balken Transparenz";
HEALBOT_OPTIONS_BARALPHAINHEAL          = "Ankomm.Heilung Transparenz";
HEALBOT_OPTIONS_BARALPHAEOR             = "Trasparenz wenn au\195\159er Reichweite";
HEALBOT_OPTIONS_ACTIONLOCKED            = "Fenster fixieren";
HEALBOT_OPTIONS_AUTOSHOW                = "Automatisch \195\182ffnen";
HEALBOT_OPTIONS_PANELSOUNDS             = "Sound beim \195\150ffnen";
HEALBOT_OPTIONS_HIDEOPTIONS             = "Kein Optionen-Knopf";
HEALBOT_OPTIONS_PROTECTPVP              = "Vermeidung des PvP Flags";
HEALBOT_OPTIONS_HEAL_CHATOPT            = "Chat-Optionen";

HEALBOT_OPTIONS_SKINTEXT                = "Benutze Skin";  
HEALBOT_SKINS_STD                       = "Standard";
HEALBOT_OPTIONS_SKINTEXTURE             = "Textur";  
HEALBOT_OPTIONS_SKINHEIGHT              = "H\195\182he";  
HEALBOT_OPTIONS_SKINWIDTH               = "Breite";   
HEALBOT_OPTIONS_SKINNUMCOLS             = "Anzahl Spalten";  
HEALBOT_OPTIONS_SKINNUMHCOLS            = "Anzahl Gruppen pro Spalte";
HEALBOT_OPTIONS_SKINBRSPACE             = "Reihenabstand";   
HEALBOT_OPTIONS_SKINBCSPACE             = "Spaltenabstand";  
HEALBOT_OPTIONS_EXTRASORT               = "Sort. Extrabalken nach";  
HEALBOT_SORTBY_NAME                     = "Name";  
HEALBOT_SORTBY_CLASS                    = "Klasse";  
HEALBOT_SORTBY_GROUP                    = "Gruppe";
HEALBOT_SORTBY_MAXHEALTH                = "Max. Leben";
HEALBOT_OPTIONS_NEWDEBUFFTEXT           = "Neuer Debuff"   
HEALBOT_OPTIONS_DELSKIN                 = "L\195\182schen"; 
HEALBOT_OPTIONS_NEWSKINTEXT             = "Neuer Skin";   
HEALBOT_OPTIONS_SAVESKIN                = "Speichern";  
HEALBOT_OPTIONS_SKINBARS                = "Balken-Optionen";   
HEALBOT_SKIN_ENTEXT                     = "Aktiv";   
HEALBOT_SKIN_DISTEXT                    = "Inaktiv";   
HEALBOT_SKIN_DEBTEXT                    = "Debuff";   
HEALBOT_SKIN_BACKTEXT                   = "Hintergrund"; 
HEALBOT_SKIN_BORDERTEXT                 = "Rand"; 
HEALBOT_OPTIONS_SKINFONT                = "Font"
HEALBOT_OPTIONS_SKINFHEIGHT             = "Schriftgr\195\182\195\159e";
HEALBOT_OPTIONS_BARALPHADIS             = "Inaktiv-Transparenz";
HEALBOT_OPTIONS_SHOWHEADERS             = "Zeige \195\156berschriften";

HEALBOT_OPTIONS_ITEMS                   = "Gegenst\195\164nde";

HEALBOT_OPTIONS_COMBOCLASS              = "Tastenkombinationen f\195\188r";
HEALBOT_OPTIONS_CLICK                   = "Klick";
HEALBOT_OPTIONS_SHIFT                   = "Shift";
HEALBOT_OPTIONS_CTRL                    = "Strg";
HEALBOT_OPTIONS_ENABLEHEALTHY           = "Auch unverletzte Ziele heilen";

HEALBOT_OPTIONS_CASTNOTIFY1             = "Keine Benachrichtigungen";
HEALBOT_OPTIONS_CASTNOTIFY2             = "Nachricht an mich selbst";
HEALBOT_OPTIONS_CASTNOTIFY3             = "Nachricht ans Ziel";
HEALBOT_OPTIONS_CASTNOTIFY4             = "Nachricht an die Gruppe";
HEALBOT_OPTIONS_CASTNOTIFY5             = "Nachricht an den Raid ";
HEALBOT_OPTIONS_CASTNOTIFY6             = "Channel";
HEALBOT_OPTIONS_CASTNOTIFYRESONLY       = "Benachrichtigung nur bei Wiederbelebung";

HEALBOT_OPTIONS_CDCBARS                 = "Balkenfarben";   
HEALBOT_OPTIONS_CDCSHOWHBARS            = "Lebensbalkenfarbe \195\164ndern";
HEALBOT_OPTIONS_CDCSHOWABARS            = "Aggrobalkenfarbe \195\164ndern";
HEALBOT_OPTIONS_CDCWARNINGS             = "Warnung bei Debuffs";
HEALBOT_OPTIONS_SHOWDEBUFFICON          = "Zeige Debuff";
HEALBOT_OPTIONS_SHOWDEBUFFWARNING       = "Zeige Warnung bei Debuff";
HEALBOT_OPTIONS_SOUNDDEBUFFWARNING      = "Spiele Ton bei Debuff"; 
HEALBOT_OPTIONS_SOUND                   = "Ton";  

HEALBOT_OPTIONS_HEAL_BUTTONS            = "Heilungsbalken f\195\188r";
HEALBOT_OPTIONS_SELFHEALS               = "Selbst";
HEALBOT_OPTIONS_PETHEALS                = "Begleiter";
HEALBOT_OPTIONS_GROUPHEALS              = "Gruppe";
HEALBOT_OPTIONS_TANKHEALS               = "Maintanks";
HEALBOT_OPTIONS_MAINASSIST              = "Hauptassistent";
HEALBOT_OPTIONS_PRIVATETANKS            = "Eigene Maintanks";
HEALBOT_OPTIONS_TARGETHEALS             = "Ziele";
HEALBOT_OPTIONS_EMERGENCYHEALS          = "Raid";
HEALBOT_OPTIONS_ALERTLEVEL              = "Alarmstufe";
HEALBOT_OPTIONS_EMERGFILTER             = "Notfall-Optionen f\195\188r";
HEALBOT_OPTIONS_EMERGFCLASS             = "Klassenauswahl nach";
HEALBOT_OPTIONS_COMBOBUTTON             = "Maustaste";  
HEALBOT_OPTIONS_BUTTONLEFT              = "Links";  
HEALBOT_OPTIONS_BUTTONMIDDLE            = "Mitte";  
HEALBOT_OPTIONS_BUTTONRIGHT             = "Rechts"; 
HEALBOT_OPTIONS_BUTTON4                 = "Taste4";  
HEALBOT_OPTIONS_BUTTON5                 = "Taste5";  
HEALBOT_OPTIONS_BUTTON6                 = "Taste6";
HEALBOT_OPTIONS_BUTTON7                 = "Taste7";
HEALBOT_OPTIONS_BUTTON8                 = "Taste8";
HEALBOT_OPTIONS_BUTTON9                 = "Taste9";
HEALBOT_OPTIONS_BUTTON10                = "Taste10";
HEALBOT_OPTIONS_BUTTON11                = "Taste11";
HEALBOT_OPTIONS_BUTTON12                = "Taste12";
HEALBOT_OPTIONS_BUTTON13                = "Taste13";
HEALBOT_OPTIONS_BUTTON14                = "Taste14";
HEALBOT_OPTIONS_BUTTON15                = "Taste15";


HEALBOT_CLASSES_ALL                     = "Alle Klassen";
HEALBOT_CLASSES_MELEE                   = "Nahkampf";
HEALBOT_CLASSES_RANGES                  = "Fernkampf";
HEALBOT_CLASSES_HEALERS                 = "Heiler";
HEALBOT_CLASSES_CUSTOM                  = "Pers\195\182nlich";

HEALBOT_OPTIONS_SHOWTOOLTIP             = "Zeige Tooltips"; 
HEALBOT_OPTIONS_SHOWDETTOOLTIP          = "Zeige detaillierte Spruchinfos";
HEALBOT_OPTIONS_SHOWCDTOOLTIP           = "Zeige Zauber-Cooldown";
HEALBOT_OPTIONS_SHOWUNITTOOLTIP         = "Zeige Zielinfos";  
HEALBOT_OPTIONS_SHOWRECTOOLTIP          = "Zeige empf. Sofortzauber";
HEALBOT_TOOLTIP_POSDEFAULT              = "Standardposition";  
HEALBOT_TOOLTIP_POSLEFT                 = "Links von Healbot";  
HEALBOT_TOOLTIP_POSRIGHT                = "Rechts von Healbot";   
HEALBOT_TOOLTIP_POSABOVE                = "\195\156ber Healbot";  
HEALBOT_TOOLTIP_POSBELOW                = "Unter Healbot";   
HEALBOT_TOOLTIP_POSCURSOR               = "Neben Mauszeiger";
HEALBOT_TOOLTIP_RECOMMENDTEXT           = "Sofortzauber-Empfehlung";
HEALBOT_TOOLTIP_NONE                    = "nicht verf\195\188gbar";
HEALBOT_TOOLTIP_CORPSE                  = "Leichnam von "
HEALBOT_TOOLTIP_CD                      = " (CD ";
HEALBOT_TOOLTIP_SECS                    = "s)";
HEALBOT_WORDS_SEC                       = "Sek";
HEALBOT_WORDS_CAST                      = "Zauber";
HEALBOT_WORDS_UNKNOWN                   = "Unbekannt";
HEALBOT_WORDS_YES                       = "Ja";
HEALBOT_WORDS_NO                        = "Nein";

HEALBOT_WORDS_NONE                      = "Nichts";
HEALBOT_OPTIONS_ALT                     = "Alt";
HEALBOT_DISABLED_TARGET                 = "Ziel";
HEALBOT_OPTIONS_SHOWCLASSONBAR          = "Zeige Klasse";
HEALBOT_OPTIONS_SHOWHEALTHONBAR         = "Zeige Leben auf Balken";
HEALBOT_OPTIONS_BARHEALTHINCHEALS       = "Zeige ankommende Heilung";
HEALBOT_OPTIONS_BARHEALTHSEPHEALS       = "getrennte ankommende Heilung";
HEALBOT_OPTIONS_BARHEALTH1              = "Defizit";
HEALBOT_OPTIONS_BARHEALTH2              = "prozentual";
HEALBOT_OPTIONS_TIPTEXT                 = "Tooltip-Anzeige";
HEALBOT_OPTIONS_POSTOOLTIP              = "Tooltip-Position";
HEALBOT_OPTIONS_SHOWNAMEONBAR           = "mit Namen";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1     = "Text in Klassenfarben";
HEALBOT_OPTIONS_EMERGFILTERGROUPS       = "in Gruppe";

HEALBOT_ONE                             = "1";
HEALBOT_TWO                             = "2";
HEALBOT_THREE                           = "3";
HEALBOT_FOUR                            = "4";
HEALBOT_FIVE                            = "5";
HEALBOT_SIX                             = "6";
HEALBOT_SEVEN                           = "7";
HEALBOT_EIGHT                           = "8";

HEALBOT_OPTIONS_SETDEFAULTS             = "Setze Standard-Einstellungen";
HEALBOT_OPTIONS_SETDEFAULTSMSG          = "Stelle alle Optionen auf Standard zur\195\188ck";
HEALBOT_OPTIONS_RIGHTBOPTIONS           = "Panel-Rechtsklick \195\182ffnet Optionen";

HEALBOT_OPTIONS_HEADEROPTTEXT           = "\195\156berschriften-Optionen"; 
HEALBOT_OPTIONS_ICONOPTTEXT             = "Icon-Optionen";
HEALBOT_SKIN_HEADERBARCOL               = "Balkenfarbe"; 
HEALBOT_SKIN_HEADERTEXTCOL              = "Textfarbe"; 
HEALBOT_OPTIONS_BUFFSTEXT1              = "Buff-Typ";
HEALBOT_OPTIONS_BUFFSTEXT2              = "auf Mitglieder"; 
HEALBOT_OPTIONS_BUFFSTEXT3              = "Balkenfarbe"; 
HEALBOT_OPTIONS_BUFF                    = "Buff "; 
HEALBOT_OPTIONS_BUFFSELF                = "nur selbst"; 
HEALBOT_OPTIONS_BUFFPARTY               = "f\195\188r Gruppe"; 
HEALBOT_OPTIONS_BUFFRAID                = "f\195\188r Raid"; 
HEALBOT_OPTIONS_MONITORBUFFS            = "\195\156berwachung fehlender Buffs"; 
HEALBOT_OPTIONS_MONITORBUFFSC           = "auch im Kampf"; 
HEALBOT_OPTIONS_ENABLESMARTCAST         = "SmartCast au\195\159erhalb des Kampfs"; 
HEALBOT_OPTIONS_SMARTCASTSPELLS         = "Inclusive Spr\195\188che"; 
HEALBOT_OPTIONS_SMARTCASTDISPELL        = "Entferne Debuffs"; 
HEALBOT_OPTIONS_SMARTCASTBUFF           = "Buffen"; 
HEALBOT_OPTIONS_SMARTCASTHEAL           = "Heilen"; 
HEALBOT_OPTIONS_BAR2SIZE                = "Manabalken-Gr\195\182\195\159e"; 
HEALBOT_OPTIONS_SETSPELLS               = "Setze Zauber f\195\188r"; 
HEALBOT_OPTIONS_ENABLEDBARS             = "Aktive Balken zu jeder Zeit"; 
HEALBOT_OPTIONS_DISABLEDBARS            = "Inaktive Balken au\195\159erhalb des Kampfs"; 
HEALBOT_OPTIONS_MONITORDEBUFFS          = "Debuff-\195\188berwachung"; 
HEALBOT_OPTIONS_DEBUFFTEXT1             = "Zauber zum Entfernen des Debuffs"; 

HEALBOT_OPTIONS_IGNOREDEBUFF            = "Ignoriere:"; 
HEALBOT_OPTIONS_IGNOREDEBUFFCLASS       = "Klassen"; 
HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT    = "Verlangsamung"; 
HEALBOT_OPTIONS_IGNOREDEBUFFDURATION    = "Kurzer Effekt"; 
HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM      = "Kein negativer Effekt"; 

HEALBOT_OPTIONS_RANGECHECKFREQ          = "Reichweite, Aura und Aggro \195\156berpr\195\188fungs-Frequenz";

HEALBOT_OPTIONS_HIDEPARTYFRAMES         = "Keine Portraits";
HEALBOT_OPTIONS_HIDEPLAYERTARGET        = "Spieler- und Zielportrait ausblenden";
HEALBOT_OPTIONS_DISABLEHEALBOT          = "HealBot deaktivieren";

HEALBOT_OPTIONS_CHECKEDTARGET           = "Checked";

HEALBOT_ASSIST                          = "Helfen";
HEALBOT_FOCUS                           = "Fokus";
HEALBOT_MENU                            = "Men\195\188";
HEALBOT_MAINTANK                        = "Main-Tank";
HEALBOT_MAINASSIST                      = "Main-Assist";
HEALBOT_STOP                            = "Stop";
HEALBOT_TELL                            = "Sagen";

HEALBOT_TITAN_SMARTCAST                 = "SmartCast";
HEALBOT_TITAN_MONITORBUFFS              = "\195\156berwache Buffs";
HEALBOT_TITAN_MONITORDEBUFFS            = "\195\156berwache Debuffs";
HEALBOT_TITAN_SHOWBARS                  = "Zeige Balken f\195\188r";
HEALBOT_TITAN_EXTRABARS                 = "Extra Balken";
HEALBOT_BUTTON_TOOLTIP                  = "Linksklick f\195\188r Umschalten der Optionspanels\nRechtsklick (und halten) zum Verschieben";
HEALBOT_TITAN_TOOLTIP                   = "Linksklick f\195\188r Umschalten der Optionspanels";
HEALBOT_OPTIONS_SHOWMINIMAPBUTTON       = "Zeige Minimap-Button";
HEALBOT_OPTIONS_BARBUTTONSHOWHOT        = "Zeige HoT";
HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON   = "Zeige Schlachtzugssymbols";
HEALBOT_OPTIONS_HOTONBAR                = "auf Balken";
HEALBOT_OPTIONS_HOTOFFBAR               = "neben Balken";
HEALBOT_OPTIONS_HOTBARRIGHT             = "rechte Seite";
HEALBOT_OPTIONS_HOTBARLEFT              = "linke Seite";

HEALBOT_ZONE_AB                         = "Arathibecken";
HEALBOT_ZONE_AV                         = "Alteractal";
HEALBOT_ZONE_ES                         = "Auge des Sturms";
HEALBOT_ZONE_IC                         = "Insel der Eroberung";
HEALBOT_ZONE_SA                         = "Strand der Uralten";
HEALBOT_ZONE_WG                         = "Kriegshymnenschlucht";

HEALBOT_OPTION_AGGROTRACK               = "Aggro aufsp\195\188ren"; 
HEALBOT_OPTION_AGGROBAR                 = "Aufblitzen"; 
HEALBOT_OPTION_AGGROTXT                 = ">> Zeige Text <<"; 
HEALBOT_OPTION_BARUPDFREQ               = "Balken-Aktualisierungsfrequenz";
HEALBOT_OPTION_USEFLUIDBARS             = "'flie\195\159ende' Balken";
HEALBOT_OPTION_CPUPROFILE               = "CPU-Profiler verwenden (Addons CPU usage Info)"
HEALBOT_OPTIONS_RELOADUIMSG             = "Diese Option ben\195\182tigt einen UI Reload, jetzt neu laden?"

HEALBOT_SELF_PVP                        = "selbst im PvP"
HEALBOT_OPTIONS_ANCHOR                  = "Rahmen Anker"
HEALBOT_OPTIONS_BARSANCHOR              = "Balken Anker"
HEALBOT_OPTIONS_TOPLEFT                 = "Oben Links"
HEALBOT_OPTIONS_BOTTOMLEFT              = "Unten Links"
HEALBOT_OPTIONS_TOPRIGHT                = "Oben Rechts"
HEALBOT_OPTIONS_BOTTOMRIGHT             = "Unten Rechts"
HEALBOT_OPTIONS_TOP                     = "Oben"
HEALBOT_OPTIONS_BOTTOM                  = "Unten"

HEALBOT_PANEL_BLACKLIST                 = "BlackList"

HEALBOT_WORDS_REMOVEFROM                = "Entferne von";
HEALBOT_WORDS_ADDTO                     = "Hinzuf\195\188gen";
HEALBOT_WORDS_INCLUDE                   = "f\195\188r";

HEALBOT_OPTIONS_TTALPHA                 = "Transparenz"
HEALBOT_TOOLTIP_TARGETBAR               = "Ziel-Balken"
HEALBOT_OPTIONS_MYTARGET                = "meine Ziele"

HEALBOT_DISCONNECTED_TEXT               = "<DC>"
HEALBOT_OPTIONS_SHOWUNITBUFFTIME        = "Zeige meine Buffs";
HEALBOT_OPTIONS_TOOLTIPUPDATE           = "St\195\164ndig updaten";
HEALBOT_OPTIONS_BUFFSTEXTTIMER          = "Zeige Buffs, bevor sie auslaufen";
HEALBOT_OPTIONS_SHORTBUFFTIMER          = "Kurze Buffs"
HEALBOT_OPTIONS_LONGBUFFTIMER           = "Lange Buffs"

HEALBOT_BALANCE                         = "Gleichgewicht"
HEALBOT_FERAL                           = "Wilder Kampf"
HEALBOT_RESTORATION                     = "Wiederherstellung"
HEALBOT_SHAMAN_RESTORATION              = "Wiederherstellung"
HEALBOT_ARCANE                          = "Arkan"
HEALBOT_FIRE                            = "Feuer"
HEALBOT_FROST                           = "Frost"
HEALBOT_DISCIPLINE                      = "Disziplin"
HEALBOT_HOLY                            = "Heilig"
HEALBOT_SHADOW                          = "Schatten"
HEALBOT_ASSASSINATION                   = "Meucheln"
HEALBOT_COMBAT                          = "Kampf"
HEALBOT_SUBTLETY                        = "T\195\164uschung"
HEALBOT_ARMS                            = "Waffen"
HEALBOT_FURY                            = "Furor"
HEALBOT_PROTECTION                      = "Schutz"
HEALBOT_BEASTMASTERY                    = "Tierherrschaft"
HEALBOT_MARKSMANSHIP                    = "Treffsicherheit"
HEALBOT_SURVIVAL                        = "\195\156berleben"
HEALBOT_RETRIBUTION                     = "Vergeltung"
HEALBOT_ELEMENTAL                       = "Elementar"
HEALBOT_ENHANCEMENT                     = "Verst\195\164rkung"
HEALBOT_AFFLICTION                      = "Gebrechen"
HEALBOT_DEMONOLOGY                      = "D\195\164monologie"
HEALBOT_DESTRUCTION                     = "Destruction"
HEALBOT_BLOOD                           = "Blut"
HEALBOT_UNHOLY                          = "Unheilig"

HEALBOT_OPTIONS_VISIBLERANGE            = "Balken deaktivieren, wenn Entfernung > 100 Meter"
HEALBOT_OPTIONS_NOTIFY_HEAL_MSG         = "Nachricht beim Heilen"
HEALBOT_OPTIONS_NOTIFY_MSG              = "Nachricht"
HEALBOT_WORDS_YOU                       = "dir/dich";
HEALBOT_NOTIFYHEALMSG                   = "Wirke #s und heile #n um #h";
HEALBOT_NOTIFYOTHERMSG                  = "Wirke #s auf #n";

HEALBOT_OPTIONS_HOTPOSITION             = "Icon-Position";
HEALBOT_OPTIONS_HOTSHOWTEXT             = "Zeige Icontext";
HEALBOT_OPTIONS_HOTTEXTCOUNT            = "Z\195\164hler";
HEALBOT_OPTIONS_HOTTEXTDURATION         = "Dauer";
HEALBOT_OPTIONS_ICONSCALE               = "Icon Ma\195\159stab"
HEALBOT_OPTIONS_ICONTEXTSCALE           = "Icon Text Ma\195\159stab"

HEALBOT_SKIN_FLUID                      = "Fluid";
HEALBOT_SKIN_VIVID                      = "Vivid";
HEALBOT_SKIN_LIGHT                      = "Light";
HEALBOT_SKIN_SQUARE                     = "Square";
HEALBOT_OPTIONS_AGGROBARSIZE            = "Gr\195\182\195\159e des Aggrobalkens";
HEALBOT_OPTIONS_TARGETBARMODE           = "Beschr\195\164nke Targetbalken auf vordefinierte Einstellungen"
HEALBOT_OPTIONS_DOUBLETEXTLINES         = "Zweifache Textzeilen";
HEALBOT_OPTIONS_TEXTALIGNMENT           = "Text-Ausrichtung";
HEALBOT_OPTIONS_ENABLELIBQH             = "libQuickHealth einschalten";
HEALBOT_VEHICLE                         = "Fahrzeug"
HEALBOT_OPTIONS_UNIQUESPEC              = "Speichere individuelle Einstellungen f\195\188r jede Skillung"
HEALBOT_WORDS_ERROR                     = "Error"
HEALBOT_SPELL_NOT_FOUND                 = "Zauber nicht gefunden"
HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT  = "Kein Tooltipp im Kampf"

HEALBOT_OPTIONS_BUFFNAMED               = "Eingabe der Spielernamen f\195\188r\n\n"
HEALBOT_WORD_ALWAYS                     = "Immer";
HEALBOT_WORD_SOLO                       = "Solo";
HEALBOT_WORD_NEVER                      = "Nie";
HEALBOT_SHOW_CLASS_AS_ICON              = "als Icon";
HEALBOT_SHOW_CLASS_AS_TEXT              = "als Text";

HEALBOT_SHOW_INCHEALS                   = "Zeige ankommende Heilung";
HEALBOT_D_DURATION                      = "Direkte Dauer";
HEALBOT_H_DURATION                      = "HoT Dauer";
HEALBOT_C_DURATION                      = "Kanalisierte Dauer";

HEALBOT_HELP={ [1] = "[HealBot] /hb h -- zeige Hilfe (Diese Liste)",
               [2] = "[HealBot] /hb o -- Optionen umschalten",
               [3] = "[HealBot] /hb d -- Optionen auf Standard zur\195\188cksetzen",
               [4] = "[HealBot] /hb ui -- UI neu laden",
               [5] = "[HealBot] /hb ri -- Reset HealBot",
               [6] = "[HealBot] /hb t -- zwischen Healbot aktiviert/deaktiviert umschalten",
               [7] = "[HealBot] /hb bt -- zwischen Buff Monitor aktiviert/deaktiviert umschalten",
               [8] = "[HealBot] /hb dt -- zwischen Debuff Monitor aktiviert/deaktiviert umschalten",
               [9] = "[HealBot] /hb skin <skinName> -- wechselt Skins",
               [10] = "[HealBot] /hb tr <Role> -- Setze h\195\182chste Rollenpriorit\195\164t f\195\188r Untersortierung nach Rolle. G\195\188ltige Rollen sind 'TANK', 'HEALER' oder 'DPS'",
               [11] = "[HealBot] /hb use10 -- Benutze automatisch Ingenieurskunst Slot 10",
               [12] = "[HealBot] /hb pcs <n> -- Anpassen der Gr\195\182\195\159e der Heilige Kraft Ladungsanzeige um <n>, Standardwert ist 7 ",
               [13] = "[HealBot] /hb info -- Zeige das Infofenster",
               [14] = "[HealBot] /hb spt -- zwischen Eigenen Begleiter aktiviert/deaktiviert umschalten",
               [15] = "[HealBot] /hb ws -- Umschalten zwischen Verstecken/Zeigen des Geschw\195\164chte Seele Icons anstatt MW:S mit einem -",
              }
              
HEALBOT_OPTION_HIGHLIGHTACTIVEBAR       = "Mouseover hervorheben"
HEALBOT_OPTION_HIGHLIGHTTARGETBAR       = "Ziel hervorheben"
HEALBOT_OPTIONS_TESTBARS                = "Test Balken"
HEALBOT_OPTION_NUMBARS                  = "Anzahl Balken"
HEALBOT_OPTION_NUMTANKS                 = "Anzahl Tanks"
HEALBOT_OPTION_NUMMYTARGETS             = "Anzahl meine Ziele"
HEALBOT_OPTION_NUMPETS                  = "Anzahl Begleiter"
HEALBOT_WORD_TEST                       = "Test";
HEALBOT_WORD_OFF                        = "Aus";
HEALBOT_WORD_ON                         = "An";

HEALBOT_OPTIONS_TAB_PROTECTION          = "Schutz"
HEALBOT_OPTIONS_TAB_CHAT                = "Chat"
HEALBOT_OPTIONS_TAB_HEADERS             = "\195\156berschriften"
HEALBOT_OPTIONS_TAB_BARS                = "Balken"
HEALBOT_OPTIONS_TAB_ICONS               = "Icons"
HEALBOT_OPTIONS_TAB_WARNING             = "Warnung"
HEALBOT_OPTIONS_SKINDEFAULTFOR          = "Standardskin f\195\188r"
HEALBOT_OPTIONS_INCHEAL                 = "Ankommende Heilungen"
HEALBOT_WORD_ARENA                      = "Arena"
HEALBOT_WORD_BATTLEGROUND               = "Schlachtfeld"
HEALBOT_OPTIONS_TEXTOPTIONS             = "Text Optionen"
HEALBOT_WORD_PARTY                      = "Gruppe"
HEALBOT_OPTIONS_COMBOAUTOTARGET         = "Auto Ziel"
HEALBOT_OPTIONS_COMBOAUTOTRINKET        = "Auto Schmuck"
HEALBOT_OPTIONS_GROUPSPERCOLUMN         = "Benutze Gruppen pro Spalte"

HEALBOT_OPTIONS_MAINSORT                = "Hauptsortierung"
HEALBOT_OPTIONS_SUBSORT                 = "Untersortierung"
HEALBOT_OPTIONS_SUBSORTINC              = "Ebenfalls sortieren"

HEALBOT_OPTIONS_BUTTONCASTMETHOD        = "Wirke beim"
HEALBOT_OPTIONS_BUTTONCASTPRESSED       = "dr\195\188cken"
HEALBOT_OPTIONS_BUTTONCASTRELEASED      = "loslassen"

HEALBOT_INFO_INCHEALINFO                = "== Ankommende Heilung Info =="
HEALBOT_INFO_ADDONCPUUSAGE              = "== Addon CPU Nutzung in Sek. =="
HEALBOT_INFO_ADDONCOMMUSAGE             = "== Addon Comms Nutzung =="
HEALBOT_WORD_HEALER                     = "Heiler"
HEALBOT_WORD_VERSION                    = "Version"
HEALBOT_WORD_CLIENT                     = "Client"
HEALBOT_WORD_ADDON                      = "Addon"
HEALBOT_INFO_CPUSECS                    = "CPU Sek."
HEALBOT_INFO_MEMORYKB                   = "Speicher KB"
HEALBOT_INFO_COMMS                      = "Komm. KB"

HEALBOT_WORD_STAR                       = "Stern"
HEALBOT_WORD_CIRCLE                     = "Kreis"
HEALBOT_WORD_DIAMOND                    = "Diamant"
HEALBOT_WORD_TRIANGLE                   = "Dreieck"
HEALBOT_WORD_MOON                       = "Mond"
HEALBOT_WORD_SQUARE                     = "Viereck"
HEALBOT_WORD_CROSS                      = "Kreuz"
HEALBOT_WORD_SKULL                      = "Totenkopf"

HEALBOT_OPTIONS_ACCEPTSKINMSG           = "Akzeptiere [HealBot] Skin: "
HEALBOT_OPTIONS_ACCEPTSKINMSGFROM       = " von "
HEALBOT_OPTIONS_BUTTONSHARESKIN         = "Teile mit"

HEALBOT_CHAT_ADDONID                    = "[HealBot]  "
HEALBOT_CHAT_NEWVERSION1                = "Eine neuere Version ist unter"
HEALBOT_CHAT_NEWVERSION2                = "http://healbot.alturl.com verf\195\188gbar"
HEALBOT_CHAT_SHARESKINERR1              = " Skin zum Teilen nicht gefunden"
HEALBOT_CHAT_SHARESKINERR3              = " nicht gefunden zum Skin Teilen"
HEALBOT_CHAT_SHARESKINACPT              = "Geteiltes Skin akzeptiert von "
HEALBOT_CHAT_CONFIRMSKINDEFAULTS        = "Skins auf Standard gesetzt"
HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS      = "Pers\195\182nliche Debuffs zur\195\188ckgesetzt"
HEALBOT_CHAT_CHANGESKINERR1             = "Unbekanntes skin: /hb skin "
HEALBOT_CHAT_CHANGESKINERR2             = "G\195\188ltige skins:  "
HEALBOT_CHAT_CONFIRMSPELLCOPY           = "Aktuelle Spr\195\188che f\195\188r in alle Skillungen \195\188bernommen"
HEALBOT_CHAT_UNKNOWNCMD                 = "Unbekanntes Kommandozeilenbefehl: /hb "
HEALBOT_CHAT_ENABLED                    = "Status jetzt aktiviert"
HEALBOT_CHAT_DISABLED                   = "Status jetzt deaktiviert"
HEALBOT_CHAT_SOFTRELOAD                 = "Healbot Reload angefragt"
HEALBOT_CHAT_HARDRELOAD                 = "UI Reload angefragt"
HEALBOT_CHAT_CONFIRMSPELLRESET          = "Spr\195\188che wurden zur\195\188ckgesetzt"
HEALBOT_CHAT_CONFIRMCURESRESET          = "Heilung wurde zur\195\188ckgesetzt"
HEALBOT_CHAT_CONFIRMBUFFSRESET          = "Buffs wurde zur\195\188ckgesetzt"
HEALBOT_CHAT_POSSIBLEMISSINGMEDIA       = "Es ist nicht m\195\182glich alle Skin-Einstellungen zu empfangen - evtl. fehlen SharedMedia-Daten. Links hierzu siehe HealBot/Docs/readme.html"
HEALBOT_CHAT_MACROSOUNDON               = "Sound wird nicht unterdr\195\188ckt, wenn Auto Schmuck benutzt wird"
HEALBOT_CHAT_MACROSOUNDOFF              = "Sound wird unterdr\195\188ckt, wenn Auto Schmuck benutzt wird"
HEALBOT_CHAT_MACROERRORON               = "Fehler werden nicht unterdr\195\188ckt, wenn Auto Schmuck benutzt wird"
HEALBOT_CHAT_MACROERROROFF              = "Fehler werden unterdr\195\188ckt, wenn Auto Schmuck benutzt wird"
HEALBOT_CHAT_TITANON                    = "Titan Panel - Updates an"
HEALBOT_CHAT_TITANOFF                   = "Titan Panel - Updates aus"
HEALBOT_CHAT_ACCEPTSKINON               = "Teile Skin - Zeige Akzeptiere-Skin-Popup wenn jemand ein Skin mit dir teilen m\195\182chte"
HEALBOT_CHAT_ACCEPTSKINOFF              = "Teile Skin - Skin Teilen von allen immer ignorieren"
HEALBOT_CHAT_USE10ON                    = "Auto Schmuck - Use10 ist eingeschaltet - Damit use10 funktioniert muss ein Auto Schmuck aktiviert sein"
HEALBOT_CHAT_USE10OFF                   = "Auto Schmuck - Use10 ist ausgeschaltet"
HEALBOT_CHAT_SKINREC                    = " Skin erhalten von " 

HEALBOT_OPTIONS_SELFCASTS               = "Nur eigene Zauber"
HEALBOT_OPTIONS_HOTSHOWICON             = "Zeige Icon"
HEALBOT_OPTIONS_ALLSPELLS               = "Alle Spr\195\188che"
HEALBOT_OPTIONS_DOUBLEROW               = "zweizeilig"
HEALBOT_OPTIONS_HOTBELOWBAR             = "unter Balken"
HEALBOT_OPTIONS_OTHERSPELLS             = "andere Spr\195\188che"
HEALBOT_WORD_MACROS                     = "Makros"
HEALBOT_WORD_SELECT                     = "Ausw\195\164hlen"
HEALBOT_OPTIONS_QUESTION                = "?"
HEALBOT_WORD_CANCEL                     = "Abbrechen"
HEALBOT_WORD_COMMANDS                   = "Kommandos"
HEALBOT_OPTIONS_BARHEALTH3              = "als Gesundheit";
HEALBOT_SORTBY_ROLE                     = "Rolle"
HEALBOT_WORD_DPS                        = "DPS"
HEALBOT_CHAT_TOPROLEERR                 = " Rolle in diesem Zusammenhang nicht g\195\188ltig - benutze 'TANK', 'DPS' oder 'HEALER'"
HEALBOT_CHAT_NEWTOPROLE                 = "H\195\188chste obere Rolle ist jetzt "
HEALBOT_CHAT_SUBSORTPLAYER1             = "Spieler wird in Untersortierung als erstes gesetzt"
HEALBOT_CHAT_SUBSORTPLAYER2             = "Spieler wird in Untersortierung normal gesetzt"
HEALBOT_OPTIONS_SHOWREADYCHECK          = "Zeige Ready Check";
HEALBOT_OPTIONS_SUBSORTSELFFIRST        = "Selbst zuerst"
HEALBOT_WORD_FILTER                     = "Filter"
HEALBOT_OPTION_AGGROPCTBAR              = "Bew. Balken"
HEALBOT_OPTION_AGGROPCTTXT              = "Zeige Text"
HEALBOT_OPTION_AGGROPCTTRACK            = "Prozentual verfolgen" 
HEALBOT_OPTIONS_ALERTAGGROLEVEL0        = "0 - hat niedrige Bedrohung und tankt nichts"
HEALBOT_OPTIONS_ALERTAGGROLEVEL1        = "1 - hat hohe Bedrohung und tankt nichts"
HEALBOT_OPTIONS_ALERTAGGROLEVEL2        = "2 - unsicher ob tankt, nicht die h\195\182chste Bedrohung am Gegner"
HEALBOT_OPTIONS_ALERTAGGROLEVEL3        = "3 - tankt sicher mindestens einen Gegner"
HEALBOT_OPTIONS_AGGROALERT              = "Aggro Alarm Level"
HEALBOT_OPTIONS_TOOLTIPSHOWHOT          = "Zeige aktiv verfolgte HoT Details"
HEALBOT_WORDS_MIN                       = "min"
HEALBOT_WORDS_MAX                       = "max"
HEALBOT_WORDS_R                         = "R"
HEALBOT_WORDS_G                         = "G"
HEALBOT_WORDS_B                         = "B"
HEALBOT_CHAT_SELFPETSON                 = "Eigenen Begleiter anschalten"
HEALBOT_CHAT_SELFPETSOFF                = "Eigenen Begleiter ausschalten"
HEALBOT_WORD_PRIORITY                   = "Priorit\195\164t"
HEALBOT_VISIBLE_RANGE                   = "Innerhalb 100 Metern"
HEALBOT_SPELL_RANGE                     = "In Zauberreichweite"
HEALBOT_CUSTOM_CATEGORY                 = "Kategorie"
HEALBOT_CUSTOM_CAT_CUSTOM               = "Pers\195\182nlich"
HEALBOT_CUSTOM_CAT_CLASSIC              = "Classic"
HEALBOT_CUSTOM_CAT_TBC_OTHER            = "TBC - Sonstige"
HEALBOT_CUSTOM_CAT_TBC_BT               = "TBC - Der Schwarze Tempel"
HEALBOT_CUSTOM_CAT_TBC_SUNWELL          = "TBC - Sonnenbrunnenplateau"
HEALBOT_CUSTOM_CAT_LK_OTHER             = "WotLK - Sonstige"
HEALBOT_CUSTOM_CAT_LK_ULDUAR            = "WotLK - Ulduar"
HEALBOT_CUSTOM_CAT_LK_TOC               = "WotLK - Kolosseum der Kreuzfahrers"
HEALBOT_CUSTOM_CAT_LK_ICC_LOWER         = "WotLK - ICC Zitadelle"
HEALBOT_CUSTOM_CAT_LK_ICC_PLAGUEWORKS   = "WotLK - ICC Die Seuchenwerke"
HEALBOT_CUSTOM_CAT_LK_ICC_CRIMSON       = "WotLK - ICC Die Blutrote Halle"
HEALBOT_CUSTOM_CAT_LK_ICC_FROSTWING     = "WotLK - ICC Hallen der Frostschwingen"
HEALBOT_CUSTOM_CAT_LK_ICC_THRONE        = "WotLK - ICC Frostthron"
HEALBOT_CUSTOM_CAT_LK_RS_THRONE         = "WotLK - Das Rubinsanktum"
HEALBOT_CUSTOM_CAT_CATA_OTHER           = "Cata - Sonstige"
HEALBOT_CUSTOM_CAT_CATA_PARTY           = "Cata - Gruppe"
HEALBOT_CUSTOM_CAT_CATA_RAID            = "Cata - Schlachtzug"
HEALBOT_WORD_RESET                      = "Reset"
HEALBOT_HBMENU                          = "HBmenu"
HEALBOT_ACTION_HBFOCUS                  = "Linksklick um Ziel als\nFokus zu setzen"
HEALBOT_WORD_CLEAR                      = "L\195\182schen"
HEALBOT_WORD_SET                        = "Setze"
HEALBOT_WORD_HBFOCUS                    = "HealBot Fokus"
HEALBOT_WORD_OUTSIDE                    = "Au\195\159erhalb"
HEALBOT_WORD_ALLZONE                    = "Alle Zonen"
HEALBOT_WORD_OTHER                      = "Sonstige"
HEALBOT_OPTIONS_TAB_ALERT               = "Alarm"
HEALBOT_OPTIONS_TAB_SORT                = "Sortieren"
HEALBOT_OPTIONS_TAB_AGGRO               = "Aggro"
HEALBOT_OPTIONS_TAB_ICONTEXT            = "Icon Text"
HEALBOT_OPTIONS_TAB_TEXT                = "Balken Text"
HEALBOT_OPTIONS_AGGROBARCOLS            = "Aggro Balken Farben";
HEALBOT_OPTIONS_AGGRO1COL               = "Hat hohe\nBedrohung"
HEALBOT_OPTIONS_AGGRO2COL               = "Unsicher \nob tankt"
HEALBOT_OPTIONS_AGGRO3COL               = "Tankt\nsicher"
HEALBOT_OPTIONS_AGGROFLASHFREQ          = "Aufblitz-Frequenz"
HEALBOT_OPTIONS_AGGROFLASHALPHA         = "Aufblitz-Durchsichtigkeit"
HEALBOT_OPTIONS_SHOWDURATIONFROM        = "Zeige Dauer ab"
HEALBOT_OPTIONS_SHOWDURATIONWARN        = "Dauer Warnung ab"
HEALBOT_CMD_RESETCUSTOMDEBUFFS          = "Reset pers\195\182nliche Debuffs"
HEALBOT_CMD_RESETSKINS                  = "Reset Skins"
HEALBOT_CMD_CLEARBLACKLIST              = "L\195\182sche BlackList"
HEALBOT_CMD_TOGGLEACCEPTSKINS           = "Umschalten Akzeptieren von Skins Anderer"
HEALBOT_CMD_COPYSPELLS                  = "\195\156bernehme aktuelle Spr\195\188che f\195\188r alle Skillungen"
HEALBOT_CMD_RESETSPELLS                 = "Reset Spr\195\188che"
HEALBOT_CMD_RESETCURES                  = "Reset Heilungen"
HEALBOT_CMD_RESETBUFFS                  = "Reset Buffs"
HEALBOT_CMD_RESETBARS                   = "Reset Balken Position"
HEALBOT_CMD_TOGGLETITAN                 = "Umschalten Titan Updates"
HEALBOT_CMD_SUPPRESSSOUND               = "Umschalten der Soundunterdr\195\188ckung, wenn Auto Schmuck benutzt wird"
HEALBOT_CMD_SUPPRESSERRORS              = "Umschalten der Fehlerunterdr\195\188ckung, wenn Auto Schmuck benutzt wird"
HEALBOT_OPTIONS_COMMANDS                = "HealBot Kommandos"
HEALBOT_WORD_RUN                        = "Ausf\195\188hren"
HEALBOT_OPTIONS_MOUSEWHEEL              = "Aktiviere Men\195\188 auf Mausrad"
HEALBOT_CMD_DELCUSTOMDEBUFF10           = "L\195\182sche pers\195\182nliche Debuffs mit Priorit\195\164t 10"
HEALBOT_ACCEPTSKINS                     = "Akzeptiere Skins von anderen"
HEALBOT_SUPPRESSSOUND                   = "Auto Schmuck: Unterdr\195\188cke Sound"
HEALBOT_SUPPRESSERROR                   = "Auto Schmuck: Unterdr\195\188cke Fehler"
HEALBOT_OPTIONS_CRASHPROT               = "Crash Protection"
HEALBOT_CP_MACRO_LEN                    = "Makro Name muss zwischen 1 und 14 Zeichen lang sein"
HEALBOT_CP_MACRO_BASE                   = "Grund-Makro Name"
HEALBOT_CP_MACRO_SAVE                   = "Zuletzt gespeichert um: "
HEALBOT_CP_STARTTIME                    = "Schutzdauer beim Einloggen"
HEALBOT_WORD_RESERVED                   = "Reserviert"
HEALBOT_OPTIONS_COMBATPROT              = "Combat Protection"
HEALBOT_COMBATPROT_PARTYNO              = "Balken f\195\188r Gruppe reserviert"
HEALBOT_COMBATPROT_RAIDNO               = "Balken f\195\188r Raid reserviert"

HEALBOT_WORD_HEALTH                     = "Gesundheit"
HEALBOT_OPTIONS_DONT_SHOW               = "nicht zeigen"
HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT    = "Gleich wie Gesundheit (jetzige Gesundheit)"
HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE     = "Gleich wie Gesundheit (zuk\195\188nftige Gesundheit)"
HEALBOT_OPTIONS_FUTURE_HLTH             = "zuk\195\188nftige Gesundheit"
HEALBOT_SKIN_HEALTHBARCOL_TEXT          = "Gesundheitsbalken Farbe";
HEALBOT_SKIN_INCHEALBARCOL_TEXT         = "Ankomm. Heilung Farbe";
HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET      = "Ziel: Immer anzeigen"
HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS       = "Fokus: Immer anzeigen"
HEALBOT_OPTIONS_USEGAMETOOLTIP          = "Benutze Spiel Tooltip"

HEALBOT_OPTIONS_SHOWPOWERCOUNTER        = "Zeige Kraft Z\195\164hler"
HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA   = "Zeige Heilige Kraft"

end
