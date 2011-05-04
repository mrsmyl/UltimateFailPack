------------
-- RUSSIAN --
------------
--Last update: 21.03.2011 - 11:15

if (GetLocale() == "ruRU") then

-------------------
-- Compatibility --
-------------------

-- Class
HEALBOT_DRUID                           = "Друид";
HEALBOT_HUNTER                          = "Охотник";
HEALBOT_MAGE                            = "Маг";
HEALBOT_PALADIN                         = "Паладин";
HEALBOT_PRIEST                          = "Жрец";
HEALBOT_ROGUE                           = "Разбойник";
HEALBOT_SHAMAN                          = "Шаман";
HEALBOT_WARLOCK                         = "Чернокнижник";
HEALBOT_WARRIOR                         = "Воин";
HEALBOT_DEATHKNIGHT                     = "Рыцарь cмерти";

-- Bandages and pots
HEALBOT_SILK_BANDAGE                    = GetItemInfo(6450) or "Шелковые бинты";
HEALBOT_HEAVY_SILK_BANDAGE              = GetItemInfo(6451) or "Плотные шелковые бинты";
HEALBOT_MAGEWEAVE_BANDAGE               = GetItemInfo(8544) or "Бинты из магической ткани";
HEALBOT_HEAVY_MAGEWEAVE_BANDAGE         = GetItemInfo(8545) or "Плотные бинты из магической ткани";
HEALBOT_RUNECLOTH_BANDAGE               = GetItemInfo(14529) or "Бинты из рунической ткани";
HEALBOT_HEAVY_RUNECLOTH_BANDAGE         = GetItemInfo(14530) or "Плотные бинты из рунной ткани";
HEALBOT_NETHERWEAVE_BANDAGE             = GetItemInfo(21990) or "Бинты из ткани Пустоты";
HEALBOT_HEAVY_NETHERWEAVE_BANDAGE       = GetItemInfo(21991) or "Плотные бинты из ткани Пустоты";
HEALBOT_FROSTWEAVE_BANDAGE              = GetItemInfo(34721) or "Бинты из ледяной ткани";
HEALBOT_HEAVY_FROSTWEAVE_BANDAGE        = GetItemInfo(34722) or "Плотные бинты из ледяной ткани";
HEALBOT_EMBERSILK_BANDAGE               = GetItemInfo(53049) or "Бинты из угольного шелка";
HEALBOT_DENSE_EMBERSILK_BANDAGE         = GetItemInfo(53051) or "Крепкие бинты из угольного шелка";
HEALBOT_MAJOR_HEALING_POTION            = GetItemInfo(13446) or "Хорошее лечебное зелье";
HEALBOT_SUPER_HEALING_POTION            = GetItemInfo(22829) or "Гигантский флакон с лечебным зельем";
HEALBOT_MAJOR_COMBAT_HEALING_POTION     = GetItemInfo(31838) or "Большой флакон с боевым лечебным зельем";
HEALBOT_RUNIC_HEALING_POTION            = GetItemInfo(33447) or "Рунический флакон с лечебным зельем";
HEALBOT_ENDLESS_HEALING_POTION          = GetItemInfo(43569) or "Бездонный флакон с лечебным зельем";   
HEALBOT_MAJOR_MANA_POTION               = GetItemInfo(13444) or "Огромный флакон с зельем маны";
HEALBOT_SUPER_MANA_POTION               = GetItemInfo(22832) or "Гигантский флакон с зельем маны";
HEALBOT_MAJOR_COMBAT_MANA_POTION        = GetItemInfo(31840) or "Большой флакон с боевым зельем маны";
HEALBOT_RUNIC_MANA_POTION               = GetItemInfo(33448) or "Рунический флакон с зельем маны";
HEALBOT_ENDLESS_MANA_POTION             = GetItemInfo(43570) or "Бездонный флакон с зельем маны";
HEALBOT_PURIFICATION_POTION             = GetItemInfo(13462) or "Зелье очищения";
HEALBOT_ANTI_VENOM                      = GetItemInfo(6452) or "Противоядие";
HEALBOT_POWERFUL_ANTI_VENOM             = GetItemInfo(19440) or "Мощное противоядие";
HEALBOT_ELIXIR_OF_POISON_RES            = GetItemInfo(3386) or "Эликсир излечения";

-- Racial abilities and item procs
HEALBOT_STONEFORM                       = GetSpellInfo(20594) or "Каменная форма";
HEALBOT_GIFT_OF_THE_NAARU               = GetSpellInfo(59547) or "Дар наару";
HEALBOT_PROTANCIENTKINGS                = GetSpellInfo(64413) or "Защита древних королей";

-- Healing spells by class
HEALBOT_REJUVENATION                    = GetSpellInfo(774) or "Омоложение";
HEALBOT_LIFEBLOOM                       = GetSpellInfo(33763) or "Жизнецвет";
HEALBOT_WILD_GROWTH                     = GetSpellInfo(48438) or "Буйный рост";
HEALBOT_TRANQUILITY                     = GetSpellInfo(740) or "Спокойствие";
HEALBOT_SWIFTMEND                       = GetSpellInfo(18562) or "Быстрое восстановление";
HEALBOT_LIVING_SEED                     = GetSpellInfo(48496) or "Семя жизни";
HEALBOT_REGROWTH                        = GetSpellInfo(8936) or "Восстановление";
HEALBOT_HEALING_TOUCH                   = GetSpellInfo(5185) or "Целительное прикосновение";
HEALBOT_NOURISH                         = GetSpellInfo(50464) or "Покровительство Природы";

HEALBOT_FLASH_OF_LIGHT                  = GetSpellInfo(19750) or "Вспышка Света";
HEALBOT_WORD_OF_GLORY                   = GetSpellInfo(85673) or "Торжество";
HEALBOT_LIGHT_OF_DAWN                   = GetSpellInfo(85222) or "Свет зари";
HEALBOT_HOLY_LIGHT                      = GetSpellInfo(635) or "Свет небес";
HEALBOT_DIVINE_LIGHT                    = GetSpellInfo(82326) or "Божественный свет";
HEALBOT_HOLY_RADIANCE                   = GetSpellInfo(82327) or "Святое сияние";

HEALBOT_GREATER_HEAL                    = GetSpellInfo(2060) or "Великое исцеление";
HEALBOT_BINDING_HEAL                    = GetSpellInfo(32546) or "Связующее исцеление"
HEALBOT_PENANCE                         = GetSpellInfo(47540) or "Искупление"
HEALBOT_PRAYER_OF_MENDING               = GetSpellInfo(33076) or "Молитва восстановления";
HEALBOT_FLASH_HEAL                      = GetSpellInfo(2061) or "Быстрое исцеление";
HEALBOT_HEAL                            = GetSpellInfo(2050) or "Исцеление";
HEALBOT_HOLY_NOVA                       = GetSpellInfo(15237) or "Кольцо света";
HEALBOT_DIVINE_HYMN                     = GetSpellInfo(64843) or "Божественный гимн";
HEALBOT_RENEW                           = GetSpellInfo(139) or "Обновление";
HEALBOT_DESPERATE_PRAYER                = GetSpellInfo(19236) or "Молитва отчаяния";
HEALBOT_PRAYER_OF_HEALING               = GetSpellInfo(596) or "Молитва исцеления";
HEALBOT_CIRCLE_OF_HEALING               = GetSpellInfo(34861) or "Круг исцеления"; --34863?
HEALBOT_HOLY_WORD_CHASTISE              = GetSpellInfo(88625) or "Слово Света: Воздаяние";
HEALBOT_HOLY_WORD_SERENITY              = GetSpellInfo(88684) or "Слово Света: Безмятежность"; -- Heal
--HEALBOT_HOLY_WORD_ASPIRE                = GetSpellInfo(88682) or "Слово Света: Возвышение"; -- Renew - 88682
HEALBOT_HOLY_WORD_SANCTUARY             = GetSpellInfo(88686) or "Слово Света: Святилище"; -- PoH

HEALBOT_HEALING_WAVE                    = GetSpellInfo(331) or "Волна исцеления";
HEALBOT_HEALING_SURGE                   = GetSpellInfo(8004) or "Исцеляющий всплеск";
HEALBOT_RIPTIDE                         = GetSpellInfo(61295) or "Быстрина";
HEALBOT_HEALING_WAY                     = GetSpellInfo(29206) or "Путь исцеления";
HEALBOT_GREATER_HEALING_WAVE            = GetSpellInfo(77472) or "Великая волна исцеления";
HEALBOT_HEALING_RAIN                    = GetSpellInfo(73920) or "Целительный ливень";
HEALBOT_CHAIN_HEAL                      = GetSpellInfo(1064) or "Цепное исцеление";

HEALBOT_HEALTH_FUNNEL                   = GetSpellInfo(755) or "Канал здоровья";

-- Buffs, Talents and Other spells by class
HEALBOT_ICEBOUND_FORTITUDE              = GetSpellInfo(48792) or "Незыблемость льда";
HEALBOT_ANTIMAGIC_SHELL                 = GetSpellInfo(48707) or "Антимагический панцирь";
HEALBOT_ARMY_OF_THE_DEAD                = GetSpellInfo(42650) or "Войско мертвых";
HEALBOT_LICHBORNE                       = GetSpellInfo(49039) or "Перерождение";
HEALBOT_ANTIMAGIC_ZONE                  = GetSpellInfo(51052) or "Зона антимагии";
HEALBOT_VAMPIRIC_BLOOD                  = GetSpellInfo(55233) or "Кровь вампира";
HEALBOT_BONE_SHIELD                     = GetSpellInfo(49222) or "Костяной щит";
HEALBOT_HORN_OF_WINTER                  = GetSpellInfo(57330) or "Зимний горн";

HEALBOT_MARK_OF_THE_WILD                = GetSpellInfo(1126) or "Знак дикой природы";
HEALBOT_THORNS                          = GetSpellInfo(467) or "Шипы";
HEALBOT_NATURES_GRASP                   = GetSpellInfo(16689) or "Хватка природы";
HEALBOT_OMEN_OF_CLARITY                 = GetSpellInfo(16864) or "Знамение ясности";
HEALBOT_BARKSKIN                        = GetSpellInfo(22812) or "Дубовая кожа";
HEALBOT_SURVIVAL_INSTINCTS              = GetSpellInfo(61336) or "Инстинкты выживания";
HEALBOT_FRENZIED_REGEN                  = GetSpellInfo(22842) or "Неистовое восстановление";
HEALBOT_INNERVATE                       = GetSpellInfo(29166) or "Озарение";
HEALBOT_DRUID_CLEARCASTING              = GetSpellInfo(16870) or "Ясность мысли";
HEALBOT_TREE_OF_LIFE                    = GetSpellInfo(33891) or "Древо Жизни";

HEALBOT_A_FOX                           = GetSpellInfo(82661) or "Дух лисицы";
HEALBOT_A_HAWK                          = GetSpellInfo(13165) or "Дух ястреба";
HEALBOT_A_CHEETAH                       = GetSpellInfo(5118) or "Дух гепарда";
HEALBOT_A_PACK                          = GetSpellInfo(13159) or "Дух стаи";
HEALBOT_A_WILD                          = GetSpellInfo(20043) or "Дух дикой природы";
HEALBOT_MENDPET                         = GetSpellInfo(136) or "Лечение питомца";

HEALBOT_ARCANE_BRILLIANCE               = GetSpellInfo(1459) or "Чародейская гениальность";
HEALBOT_DALARAN_BRILLIANCE              = GetSpellInfo(61316) or "Чародейская гениальность Даларана";
HEALBOT_MAGE_WARD                       = GetSpellInfo(543) or "Магическая защита";
HEALBOT_MAGE_ARMOR                      = GetSpellInfo(6117) or "Магический доспех";
HEALBOT_MOLTEN_ARMOR                    = GetSpellInfo(30482) or "Раскаленный доспех";
HEALBOT_FOCUS_MAGIC                     = GetSpellInfo(54646) or "Магическая концентрация";
HEALBOT_FROST_ARMOR                     = GetSpellInfo(168) or "Морозный доспех";

HEALBOT_HANDOFPROTECTION                = GetSpellInfo(1022) or "Длань защиты";
HEALBOT_BEACON_OF_LIGHT                 = GetSpellInfo(53563) or "Частица света";
HEALBOT_LIGHT_BEACON                    = GetSpellInfo(53651) or "Частица Света";
HEALBOT_CONVICTION                      = GetSpellInfo(20049) or "Твердая вера";
HEALBOT_SACRED_SHIELD                   = GetSpellInfo(53601) or "Священный щит";
HEALBOT_LAY_ON_HANDS                    = GetSpellInfo(633) or "Возложение рук";
HEALBOT_INFUSION_OF_LIGHT               = GetSpellInfo(53569) or "Прилив Света";
HEALBOT_SPEED_OF_LIGHT                  = GetSpellInfo(85495) or "Скорость Света";
HEALBOT_DAY_BREAK                       = GetSpellInfo(88820) or "Рассвет";
HEALBOT_DENOUNCE                        = GetSpellInfo(31825) or "Обличение";
HEALBOT_CLARITY_OF_PURPOSE              = GetSpellInfo(85462) or "Светлые намерения";
HEALBOT_HOLY_SHOCK                      = GetSpellInfo(20473) or "Шок небес";
HEALBOT_DIVINE_FAVOR                    = GetSpellInfo(31842) or "Божественное одобрение";
HEALBOT_DIVINE_PLEA                     = GetSpellInfo(54428) or "Святая клятва"
HEALBOT_DIVINE_SHIELD                   = GetSpellInfo(642) or "Божественный щит";
HEALBOT_RIGHTEOUS_DEFENSE               = GetSpellInfo(31789) or "Праведная защита";
HEALBOT_BLESSING_OF_MIGHT               = GetSpellInfo(19740) or "Благословение могущества";
HEALBOT_BLESSING_OF_KINGS               = GetSpellInfo(20217) or "Благословение королей";
HEALBOT_SEAL_OF_RIGHTEOUSNESS           = GetSpellInfo(20154) or "Печать праведности";
HEALBOT_SEAL_OF_JUSTICE                 = GetSpellInfo(20164) or "Печать справедливости";
HEALBOT_SEAL_OF_INSIGHT                 = GetSpellInfo(20165) or "Печать прозрения";
HEALBOT_SEAL_OF_TRUTH                   = GetSpellInfo(31801) or "Печать правды";
HEALBOT_HAND_OF_FREEDOM                 = GetSpellInfo(1044) or "Длань свободы";
HEALBOT_HAND_OF_PROTECTION              = GetSpellInfo(1022) or "Длань защиты";
HEALBOT_HAND_OF_SACRIFICE               = GetSpellInfo(6940) or "Длань жертвенности";
HEALBOT_HAND_OF_SALVATION               = GetSpellInfo(1038) or "Длань спасения";
HEALBOT_RIGHTEOUS_FURY                  = GetSpellInfo(25780) or "Праведное неистовство";
HEALBOT_AURA_MASTERY                    = GetSpellInfo(31821) or "Мастер аур";
HEALBOT_DEVOTION_AURA                   = GetSpellInfo(465) or "Аура благочестия";
HEALBOT_RETRIBUTION_AURA                = GetSpellInfo(7294) or "Аура воздаяния";
HEALBOT_RESISTANCE_AURA                 = GetSpellInfo(19891) or "Аура сопротивления";
HEALBOT_CONCENTRATION_AURA              = GetSpellInfo(19746) or "Аура сосредоточенности";
HEALBOT_CRUSADER_AURA                   = GetSpellInfo(32223) or "Аура воина Света";
HEALBOT_DIVINE_PROTECTION               = GetSpellInfo(498) or "Божественная защита";
HEALBOT_ILLUMINATED_HEALING             = GetSpellInfo(76669) or "Озаряющее исцеление";
HEALBOT_ARDENT_DEFENDER                 = GetSpellInfo(31850) or "Ревностный защитник";
HEALBOT_HOLY_SHIELD                     = GetSpellInfo(20925) or "Щит небес";
HEALBOT_GUARDED_BY_THE_LIGHT            = GetSpellInfo(85646) or "Под защитой Света";
HEALBOT_GUARDIAN_ANCIENT_KINGS          = GetSpellInfo(86150) or "Защитник древних королей";

HEALBOT_POWER_WORD_SHIELD               = GetSpellInfo(17) or "Слово силы: Щит";
HEALBOT_POWER_WORD_BARRIER              = GetSpellInfo(62618) or "Слово Силы: Барьер";
HEALBOT_ECHO_OF_LIGHT                   = GetSpellInfo(77485) or "Отблеск Света";
HEALBOT_GUARDIAN_SPIRIT                 = GetSpellInfo(47788) or "Оберегающий дух";
HEALBOT_LEVITATE                        = GetSpellInfo(1706) or "Левитация";
HEALBOT_DIVINE_AEGIS                    = GetSpellInfo(47509) or "Божественное покровительство";
HEALBOT_SURGE_OF_LIGHT                  = GetSpellInfo(33154) or "Всплеск света";
HEALBOT_BLESSED_HEALING                 = GetSpellInfo(70772) or "Благословенное исцеление";
HEALBOT_BLESSED_RESILIENCE              = GetSpellInfo(33142) or "Благословенная устойчивость";
HEALBOT_PAIN_SUPPRESSION                = GetSpellInfo(33206) or "Подавление боли";
HEALBOT_POWER_INFUSION                  = GetSpellInfo(10060) or "Придание сил";
HEALBOT_POWER_WORD_FORTITUDE            = GetSpellInfo(21562) or "Слово силы: Стойкость";
HEALBOT_SHADOW_PROTECTION               = GetSpellInfo(27683) or "Защита от темной магии";
HEALBOT_INNER_FIRE                      = GetSpellInfo(588) or "Внутренний огонь";
HEALBOT_INNER_WILL                      = GetSpellInfo(73413) or "Внутренняя решимость";
HEALBOT_SHADOWFORM                      = GetSpellInfo(15473) or "Облик Тьмы"
HEALBOT_INNER_FOCUS                     = GetSpellInfo(89485) or "Внутреннее сосредоточение";
HEALBOT_CHAKRA                          = GetSpellInfo(14751) or "Чакра";
HEALBOT_CHAKRA_POH                      = GetSpellInfo(81206) or "Чакра: молитва исцеления";
--HEALBOT_CHAKRA_RENEW                    = GetSpellInfo(81207) or "Чакра: обновление";
HEALBOT_CHAKRA_HEAL                     = GetSpellInfo(81208) or "Чакра: исцеление";
HEALBOT_CHAKRA_SMITE                    = GetSpellInfo(81209) or "Чакра: кара";
HEALBOT_REVELATIONS                     = GetSpellInfo(88627) or "Откровения";
HEALBOT_FEAR_WARD                       = GetSpellInfo(6346) or "Защита от страха";
HEALBOT_SERENDIPITY                     = GetSpellInfo(63730) or "Прозорливость";
HEALBOT_VAMPIRIC_EMBRACE                = GetSpellInfo(15286) or "Объятия вампира";
HEALBOT_INSPIRATION                     = GetSpellInfo(14892) or "Вдохновение";
HEALBOT_LIGHTWELL_RENEW                 = GetSpellInfo(7001) or "Обновление колодца Света";
HEALBOT_GRACE                           = GetSpellInfo(47516) or "Милость";
HEALBOT_LEAP_OF_FAITH                   = GetSpellInfo(73325) or "Духовное рвение";
HEALBOT_EVANGELISM                      = GetSpellInfo(81661) or "Приверженность Свету";
HEALBOT_ARCHANGEL                       = GetSpellInfo(87151) or "Архангел";

HEALBOT_CHAINHEALHOT                    = GetSpellInfo(70809) or "Цепное исцеление";
HEALBOT_TIDAL_WAVES                     = GetSpellInfo(51562) or "Приливные волны";
HEALBOT_TIDAL_FORCE                     = GetSpellInfo(55198) or "Сила прилива";
HEALBOT_NATURE_SWIFTNESS                = GetSpellInfo(17116) or "Природная стремительность";
HEALBOT_LIGHTNING_SHIELD                = GetSpellInfo(324) or "Щит молний";
HEALBOT_ROCKBITER_WEAPON                = GetSpellInfo(8017) or "Оружие камнедробителя";
HEALBOT_FLAMETONGUE_WEAPON              = GetSpellInfo(8024) or "Оружие языка пламени";
HEALBOT_EARTHLIVING_WEAPON              = GetSpellInfo(51730) or "Оружие жизни земли";
HEALBOT_WINDFURY_WEAPON                 = GetSpellInfo(8232) or "Оружие неистовства ветра";
HEALBOT_FROSTBRAND_WEAPON               = GetSpellInfo(8033) or "Оружие ледяного клейма";
HEALBOT_EARTH_SHIELD                    = GetSpellInfo(974) or "Щит земли";
HEALBOT_WATER_SHIELD                    = GetSpellInfo(52127) or "Водный щит";
HEALBOT_WATER_BREATHING                 = GetSpellInfo(131) or "Подводное дыхание";
HEALBOT_WATER_WALKING                   = GetSpellInfo(546) or "Хождение по воде";
HEALBOT_ANCESTRAL_FORTITUDE             = GetSpellInfo(16236) or "Стойкость предков";
HEALBOT_EARTHLIVING                     = GetSpellInfo(51945) or "Жизнь Земли";
HEALBOT_UNLEASH_ELEMENTS                = GetSpellInfo(73680) or "Высвободить чары стихий";
HEALBOT_STONEKIN_TOTEM                  = GetSpellInfo(8071) or "Тотем каменной кожи";

HEALBOT_DEMON_ARMOR                     = GetSpellInfo(687) or "Демонический доспех";
HEALBOT_FEL_ARMOR                       = GetSpellInfo(28176) or "Доспех Скверны";
HEALBOT_SOUL_LINK                       = GetSpellInfo(19028) or "Связка души";
HEALBOT_UNENDING_BREATH                 = GetSpellInfo(5697) or "Бесконечное дыхание";
HEALBOT_LIFE_TAP                        = GetSpellInfo(1454) or "Жизнеотвод";
HEALBOT_BLOOD_PACT                      = GetSpellInfo(6307) or "Кровавый союз";
HEALBOT_DARK_INTENT                     = GetSpellInfo(80398) or "Узы Тьмы";

HEALBOT_BATTLE_SHOUT                    = GetSpellInfo(6673) or "Боевой крик";
HEALBOT_COMMANDING_SHOUT                = GetSpellInfo(469) or "Командирский крик";
HEALBOT_INTERVENE                       = GetSpellInfo(3411) or "Вмешательство";
HEALBOT_VIGILANCE                       = GetSpellInfo(50720) or "Бдительность";
HEALBOT_LAST_STAND                      = GetSpellInfo(12975) or "Ни шагу назад";
HEALBOT_SHIELD_WALL                     = GetSpellInfo(871) or "Глухая оборона";
HEALBOT_SHIELD_BLOCK                    = GetSpellInfo(2565) or "Блок щитом";
HEALBOT_ENRAGED_REGEN                   = GetSpellInfo(55694) or "Безудержное восстановление";

-- Res Spells
HEALBOT_RESURRECTION                    = GetSpellInfo(2006) or "Воскрешение";
HEALBOT_REDEMPTION                      = GetSpellInfo(7328) or "Искупление";
HEALBOT_REBIRTH                         = GetSpellInfo(20484) or "Возрождение";
HEALBOT_REVIVE                          = GetSpellInfo(50769) or "Оживление";
HEALBOT_ANCESTRALSPIRIT                 = GetSpellInfo(2008) or "Дух предков";

-- Cure Spells
HEALBOT_CLEANSE                         = GetSpellInfo(4987) or "Очищение";
HEALBOT_REMOVE_CURSE                    = GetSpellInfo(475) or "Снятие проклятия";
HEALBOT_REMOVE_CORRUPTION               = GetSpellInfo(2782) or "Снятие порчи";
HEALBOT_NATURES_CURE                    = GetSpellInfo(88423) or "Природный целитель";
HEALBOT_CURE_DISEASE                    = GetSpellInfo(528) or "Излечение болезни";
HEALBOT_DISPEL_MAGIC                    = GetSpellInfo(527) or "Рассеивание заклинаний";
HEALBOT_CLEANSE_SPIRIT                  = GetSpellInfo(51886) or "Очищение духа";
HEALBOT_IMPROVED_CLEANSE_SPIRIT         = GetSpellInfo(77130) or "Улучшенное очищение духа";
HEALBOT_SACRED_CLEANSING                = GetSpellInfo(53551) or "Священное очищение";
HEALBOT_BODY_AND_SOUL                   = GetSpellInfo(64127) or "Тело и душа";
HEALBOT_DISEASE                         = "Болезнь";
HEALBOT_MAGIC                           = "Магия";
HEALBOT_CURSE                           = "Проклятие";
HEALBOT_POISON                          = "Яд";
-- HEALBOT_DISEASE_en                      = "Disease";  -- Do NOT localize this value.
-- HEALBOT_MAGIC_en                        = "Magic";  -- Do NOT localize this value.
-- HEALBOT_CURSE_en                        = "Curse";  -- Do NOT localize this value.
-- HEALBOT_POISON_en                       = "Poison";  -- Do NOT localize this value.
-- HEALBOT_CUSTOM_en                       = "Custom";  -- Do NOT localize this value. 

-- Common Buffs
HEALBOT_ZAMAELS_PRAYER                  = GetSpellInfo(88663) or "Молитва Замеля";

-- Debuffs
HEALBOT_DEBUFF_ANCIENT_HYSTERIA         = "Древняя истерия";
HEALBOT_DEBUFF_IGNITE_MANA              = "Воспламенение маны";
HEALBOT_DEBUFF_TAINTED_MIND             = "Запятнанный разум";
HEALBOT_DEBUFF_VIPER_STING              = "Укус гадюки";
HEALBOT_DEBUFF_SILENCE                  = "Безмолвие";
HEALBOT_DEBUFF_MAGMA_SHACKLES           = "Оковы магмы";
HEALBOT_DEBUFF_FROSTBOLT                = "Ледяная стрела";
HEALBOT_DEBUFF_HUNTERS_MARK             = "Метка охотника";
HEALBOT_DEBUFF_SLOW                     = "Замедление";
HEALBOT_DEBUFF_ARCANE_BLAST             = "Чародейская вспышка";
HEALBOT_DEBUFF_IMPOTENCE                = "Проклятие бессилия";
HEALBOT_DEBUFF_DECAYED_STR              = "Ослабление силы";
HEALBOT_DEBUFF_DECAYED_INT              = "Угасание интеллекта";
HEALBOT_DEBUFF_CRIPPLE                  = "Увечье";
HEALBOT_DEBUFF_CHILLED                  = "Окоченение";
HEALBOT_DEBUFF_CONEOFCOLD               = "Конус холода";
HEALBOT_DEBUFF_CONCUSSIVESHOT           = "Шокирующий выстрел";
HEALBOT_DEBUFF_THUNDERCLAP              = "Раскат грома";
HEALBOT_DEBUFF_HOWLINGSCREECH           = "Визгливый вой";
HEALBOT_DEBUFF_DAZED                    = "Головокружение";
HEALBOT_DEBUFF_UNSTABLE_AFFL            = "Нестабильное колдовство";
HEALBOT_DEBUFF_DREAMLESS_SLEEP          = "Мирный сон";
HEALBOT_DEBUFF_GREATER_DREAMLESS        = "Больший мирный сон";
HEALBOT_DEBUFF_MAJOR_DREAMLESS          = "Старший мирный сон";
HEALBOT_DEBUFF_FROST_SHOCK              = "Ледяной шок";
HEALBOT_DEBUFF_WEAKENED_SOUL            = GetSpellInfo(6788) or "Ослабленная душа";

HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(29670) or "Ледяной склеп";
HEALBOT_DEBUFF_SACRIFICE                = GetSpellInfo(30115) or "Жертвоприношение";
HEALBOT_DEBUFF_ICEBOLT                  = GetSpellInfo(31249) or "Морозная стрела";
HEALBOT_DEBUFF_DOOMFIRE                 = GetSpellInfo(31944) or "Роковой Огонь";
HEALBOT_DEBUFF_IMPALING_SPINE           = GetSpellInfo(39837) or "Пронзающий шип";
HEALBOT_DEBUFF_FEL_RAGE                 = GetSpellInfo(40604) or "Ярость скверны";
HEALBOT_DEBUFF_FEL_RAGE2                = GetSpellInfo(40616) or "Ярость Скверны 2";
HEALBOT_DEBUFF_FATAL_ATTRACTION         = GetSpellInfo(41001) or "Смертельное притяжение";
HEALBOT_DEBUFF_AGONIZING_FLAMES         = GetSpellInfo(40932) or "Пламенная боль";
HEALBOT_DEBUFF_DARK_BARRAGE             = GetSpellInfo(40585) or "Темное заграждение";
HEALBOT_DEBUFF_PARASITIC_SHADOWFIEND    = GetSpellInfo(41917) or "Паразитирующее исчадие Тьмы";
HEALBOT_DEBUFF_GRIEVOUS_THROW           = GetSpellInfo(43093) or "Горестный бросок";
HEALBOT_DEBUFF_BURN                     = GetSpellInfo(46394) or "Палящее пламя";
HEALBOT_DEBUFF_ENCAPSULATE              = GetSpellInfo(45662) or "Инкапсуляция";
HEALBOT_DEBUFF_CONFLAGRATION            = GetSpellInfo(45342) or "Воспламенение";
HEALBOT_DEBUFF_FLAME_SEAR               = GetSpellInfo(46771) or "Обжигающее пламя";
HEALBOT_DEBUFF_FIRE_BLOOM               = GetSpellInfo(45641) or "Огненный цветок";
HEALBOT_DEBUFF_GRIEVOUS_BITE            = GetSpellInfo(48920) or "Болезненный укус";
HEALBOT_DEBUFF_FROST_TOMB               = GetSpellInfo(25168) or "Ледяная могила";
HEALBOT_DEBUFF_IMPALE                   = GetSpellInfo(67478) or "Прокалывание";
HEALBOT_DEBUFF_WEB_WRAP                 = GetSpellInfo(28622) or "Кокон";
HEALBOT_DEBUFF_JAGGED_KNIFE             = GetSpellInfo(55550) or "Зазубренный нож";
HEALBOT_DEBUFF_FROST_BLAST              = GetSpellInfo(27808) or "Ледяной взрыв";
HEALBOT_DEBUFF_SLAG_PIT                 = GetSpellInfo(63477) or "Шлаковый ковш";
HEALBOT_DEBUFF_GRAVITY_BOMB             = GetSpellInfo(64234) or "Гравитационная бомба";
HEALBOT_DEBUFF_LIGHT_BOMB               = GetSpellInfo(63018) or "Опаляющий свет";
HEALBOT_DEBUFF_STONE_GRIP               = GetSpellInfo(64292) or "Каменная хватка";
HEALBOT_DEBUFF_FERAL_POUNCE             = GetSpellInfo(64669) or "Дикий прыжок";
HEALBOT_DEBUFF_NAPALM_SHELL             = GetSpellInfo(63666) or "Заряд напалма";
HEALBOT_DEBUFF_IRON_ROOTS               = GetSpellInfo(62283) or "Железные корни";
HEALBOT_DEBUFF_SARA_BLESSING            = GetSpellInfo(63134) or "Благословение Сары";
HEALBOT_DEBUFF_SNOBOLLED                = GetSpellInfo(66406) or "Получи снобольда!";
HEALBOT_DEBUFF_FIRE_BOMB                = GetSpellInfo(67475) or "Огненная бомба";
HEALBOT_DEBUFF_BURNING_BILE             = GetSpellInfo(66869) or "Горящая желчь";
HEALBOT_DEBUFF_PARALYTIC_TOXIN          = GetSpellInfo(67618) or "Паралитический токсин";
HEALBOT_DEBUFF_INCINERATE_FLESH         = GetSpellInfo(67049) or "Испепеление плоти";
HEALBOT_DEBUFF_LEGION_FLAME             = GetSpellInfo(68123) or "Пламя Легиона";
HEALBOT_DEBUFF_MISTRESS_KISS            = GetSpellInfo(67078) or "Поцелуй Госпожи";
HEALBOT_DEBUFF_SPINNING_PAIN_SPIKE      = GetSpellInfo(66283) or "Крутящийся шип боли";
HEALBOT_DEBUFF_TOUCH_OF_LIGHT           = GetSpellInfo(67297) or "Касание Света";
HEALBOT_DEBUFF_TOUCH_OF_DARKNESS        = GetSpellInfo(66001) or "Касание тьмы";
HEALBOT_DEBUFF_PENETRATING_COLD         = GetSpellInfo(66013) or "Пронизывающий холод";
HEALBOT_DEBUFF_ACID_DRENCHED_MANDIBLES  = GetSpellInfo(67861) or "Ядовитые жвалы";
HEALBOT_DEBUFF_EXPOSE_WEAKNESS          = GetSpellInfo(67847) or "Выявление слабости";
HEALBOT_DEBUFF_IMPALED                  = GetSpellInfo(69065) or "Прокалывание";
HEALBOT_DEBUFF_NECROTIC_STRIKE          = GetSpellInfo(70659) or "Некротический удар";
HEALBOT_DEBUFF_FALLEN_CHAMPION          = GetSpellInfo(72293) or "Метка падшего воителя";
HEALBOT_DEBUFF_BOILING_BLOOD            = GetSpellInfo(72385) or "Кипящая кровь";
HEALBOT_DEBUFF_RUNE_OF_BLOOD            = GetSpellInfo(72409) or "Руна крови";
HEALBOT_DEBUFF_VILE_GAS                 = GetSpellInfo(72273) or "Губительный газ";
HEALBOT_DEBUFF_GASTRIC_BLOAT            = GetSpellInfo(72219) or "Желудочное вздутие";
HEALBOT_DEBUFF_GAS_SPORE                = GetSpellInfo(69278) or "Газообразные споры";
HEALBOT_DEBUFF_INOCULATED               = GetSpellInfo(72103) or "Невосприимчивость к гнили";
HEALBOT_DEBUFF_MUTATED_INFECTION        = GetSpellInfo(71224) or "Мутировавшая инфекция";
HEALBOT_DEBUFF_GASEOUS_BLOAT            = GetSpellInfo(72455) or "Газовое вздутие";
HEALBOT_DEBUFF_VOLATILE_OOZE            = GetSpellInfo(70447) or "Выделения неустойчивого слизнюка";
HEALBOT_DEBUFF_MUTATED_PLAGUE           = GetSpellInfo(72745) or "Мутировавшая чума";
HEALBOT_DEBUFF_GLITTERING_SPARKS        = GetSpellInfo(72796) or "Ослепительные искры";
HEALBOT_DEBUFF_SHADOW_PRISON            = GetSpellInfo(72999) or "Клетка Тьмы";
HEALBOT_DEBUFF_SWARMING_SHADOWS         = GetSpellInfo(72638) or "Роящиеся тени";
HEALBOT_DEBUFF_PACT_DARKFALLEN          = GetSpellInfo(71340) or "Пакт Омраченных";
HEALBOT_DEBUFF_ESSENCE_BLOOD_QUEEN      = GetSpellInfo(70867) or "Сущность Кровавой королевы";
HEALBOT_DEBUFF_DELIRIOUS_SLASH          = GetSpellInfo(71624) or "Безумный выпад";
HEALBOT_DEBUFF_CORROSION                = GetSpellInfo(70751) or "Коррозия";
HEALBOT_DEBUFF_GUT_SPRAY                = GetSpellInfo(70633) or "Выброс внутренностей";
HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(70157) or "Ледяной склеп";
HEALBOT_DEBUFF_FROST_BEACON             = GetSpellInfo(70126) or "Ледяная метка";
HEALBOT_DEBUFF_CHILLED_BONE             = GetSpellInfo(70106) or "Обморожение";
HEALBOT_DEBUFF_INSTABILITY              = GetSpellInfo(69766) or "Неустойчивость";
HEALBOT_DEBUFF_MYSTIC_BUFFET            = GetSpellInfo(70127) or "Таинственная энергия";
HEALBOT_DEBUFF_FROST_BREATH             = GetSpellInfo(69649) or "Ледяное дыхание";
HEALBOT_DEBUFF_INFEST                   = GetSpellInfo(70541) or "Заражение";
HEALBOT_DEBUFF_NECROTIC_PLAGUE          = GetSpellInfo(70338) or "Мертвящая чума";
HEALBOT_DEBUFF_DEFILE                   = GetSpellInfo(72754) or "Осквернение";
HEALBOT_DEBUFF_HARVEST_SOUL             = GetSpellInfo(68980) or "Жатва душ";
HEALBOT_DEBUFF_FIERY_COMBUSTION         = GetSpellInfo(74562) or "Пылающий огонь";
HEALBOT_DEBUFF_COMBUSTION               = GetSpellInfo(75882) or "Возгорание";
HEALBOT_DEBUFF_SOUL_CONSUMPTION         = GetSpellInfo(74792) or "Пожирание души";
HEALBOT_DEBUFF_CONSUMPTION              = GetSpellInfo(75875) or "Пожирание";
HEALBOT_DEBUFF_TOXIC_SPORES             = GetSpellInfo(86281) or "Отравляющие споры";
HEALBOT_DEBUFF_LIGHTING_ROD             = GetSpellInfo(93294) or "Громоотвод";
HEALBOT_DEBUFF_PARASITIC_INFECT         = GetSpellInfo(91913) or "Заражение паразитами";
HEALBOT_DEBUFF_CONSUMING_FLAMES         = GetSpellInfo(92973) or "Пожирающий огонь";
HEALBOT_DEBUFF_FLASH_FREEZE             = GetSpellInfo(92978) or "Ледяная вспышка";
HEALBOT_DEBUFF_EXPLOSIVE_CINDERS        = GetSpellInfo(79339) or "Взрывчатая субстанция";
HEALBOT_DEBUFF_ENGULFING_MAGIC          = GetSpellInfo(95641) or "Избыточная магия";
HEALBOT_DEBUFF_WATERLOGGED              = GetSpellInfo(82762) or "Промокший насквозь";
HEALBOT_DEBUFF_GRAVITY_CORE             = GetSpellInfo(92075) or "Гравитационное ядро";
HEALBOT_DEBUFF_GRAVITY_CRUSH            = GetSpellInfo(92488) or "Гравитационный удар";

HB_TOOLTIP_MANA                         = "^Мана: (%d+)$";
HB_TOOLTIP_INSTANT_CAST                 = SPELL_CAST_TIME_INSTANT_NO_MANA;
HB_TOOLTIP_CAST_TIME                    = "Применение: (%d+.?%d*) сек";
HB_TOOLTIP_CHANNELED                    = SPELL_CAST_CHANNELED;
HB_TOOLTIP_OFFLINE                      = PLAYER_OFFLINE;
HB_OFFLINE                              = PLAYER_OFFLINE; -- has gone offline msg
HB_ONLINE                               = GUILD_ONLINE_LABEL; -- has come online msg

-----------------
-- Translation --
-----------------

HEALBOT_ADDON                           = "HealBot " .. HEALBOT_VERSION;
HEALBOT_LOADED                          = " загружен.";

HEALBOT_ACTION_OPTIONS                  = "Настройки";

HEALBOT_OPTIONS_TITLE                   = HEALBOT_ADDON;
HEALBOT_OPTIONS_DEFAULTS                = "Стандарт";
HEALBOT_OPTIONS_CLOSE                   = "Закрыть";
HEALBOT_OPTIONS_HARDRESET               = "Перез.UI"
HEALBOT_OPTIONS_SOFTRESET               = "СбросHB"
HEALBOT_OPTIONS_INFO                    = "Инфо"
HEALBOT_OPTIONS_TAB_GENERAL             = "Общее";
HEALBOT_OPTIONS_TAB_SPELLS              = "Заклинания";
HEALBOT_OPTIONS_TAB_HEALING             = "Исцеление";
HEALBOT_OPTIONS_TAB_CDC                 = "Излечение";
HEALBOT_OPTIONS_TAB_SKIN                = "Шкурки";
HEALBOT_OPTIONS_TAB_TIPS                = "Tips";
HEALBOT_OPTIONS_TAB_BUFFS               = "Бафы";

HEALBOT_OPTIONS_BARALPHA                = "Прозрач-ть включеных";
HEALBOT_OPTIONS_BARALPHAINHEAL          = "Прозр-ть вход-го исцеления";
HEALBOT_OPTIONS_BARALPHAEOR             = "Прозр-ть 'Вне досягаемости'";
HEALBOT_OPTIONS_ACTIONLOCKED            = "Закрепить позиции";
HEALBOT_OPTIONS_AUTOSHOW                = "Авто закрыть";
HEALBOT_OPTIONS_PANELSOUNDS             = "Звук при открытии";
HEALBOT_OPTIONS_HIDEOPTIONS             = "Скрыть кнопку настроек";
HEALBOT_OPTIONS_PROTECTPVP              = "Избегать случайного PvP";
HEALBOT_OPTIONS_HEAL_CHATOPT            = "Настройки чата";

HEALBOT_OPTIONS_FRAMESCALE              = "Масштаб фрейма"
HEALBOT_OPTIONS_SKINTEXT                = "Шкурка";
HEALBOT_SKINS_STD                       = "Стандарт";
HEALBOT_OPTIONS_SKINTEXTURE             = "Текстура";
HEALBOT_OPTIONS_SKINHEIGHT              = "Высота";
HEALBOT_OPTIONS_SKINWIDTH               = "Ширина";
HEALBOT_OPTIONS_SKINNUMCOLS             = "Колонок";
HEALBOT_OPTIONS_SKINNUMHCOLS            = "Заголовки/колонки";
HEALBOT_OPTIONS_SKINBRSPACE             = "Промежуток строк";
HEALBOT_OPTIONS_SKINBCSPACE             = "Промежуток рядов";
HEALBOT_OPTIONS_EXTRASORT               = "Сорт панелей";
HEALBOT_SORTBY_NAME                     = "Имя";
HEALBOT_SORTBY_CLASS                    = "Класс";
HEALBOT_SORTBY_GROUP                    = "Группа";
HEALBOT_SORTBY_MAXHEALTH                = "Макс здоровья";
HEALBOT_OPTIONS_NEWDEBUFFTEXT           = "Нов.Дебаф"
HEALBOT_OPTIONS_DELSKIN                 = "Удалить";
HEALBOT_OPTIONS_NEWSKINTEXT             = "Нов.Шкурка";
HEALBOT_OPTIONS_SAVESKIN                = "Сохранить";
HEALBOT_OPTIONS_SKINBARS                = "Опции панели";
HEALBOT_SKIN_ENTEXT                     = "Включить";
HEALBOT_SKIN_DISTEXT                    = "Выключить";
HEALBOT_SKIN_DISABLED                   = HEALBOT_SKIN_DISTEXT
HEALBOT_SKIN_DEBTEXT                    = "Дебаф";
HEALBOT_SKIN_BACKTEXT                   = "Фон";
HEALBOT_SKIN_BORDERTEXT                 = "Края";
HEALBOT_OPTIONS_SKINFONT                = "Шрифт"
HEALBOT_OPTIONS_SKINFHEIGHT             = "Размер шрифта";
HEALBOT_OPTIONS_SKINFOUTLINE            = "Контур шрифта"
HEALBOT_OPTIONS_BARALPHADIS             = "Прозрачностьть откл.";
HEALBOT_OPTIONS_SHOWHEADERS             = "Заголовки";

HEALBOT_OPTIONS_ITEMS                   = "Предметы";

HEALBOT_OPTIONS_COMBOCLASS              = "Клавиши для";
HEALBOT_OPTIONS_CLICK                   = "Клик";
HEALBOT_OPTIONS_SHIFT                   = "Shift";
HEALBOT_OPTIONS_CTRL                    = "Ctrl";
HEALBOT_OPTIONS_ENABLEHEALTHY           = "Всегда включено";

HEALBOT_OPTIONS_CASTNOTIFY1             = "Не сообщать";
HEALBOT_OPTIONS_CASTNOTIFY2             = "Только себе";
HEALBOT_OPTIONS_CASTNOTIFY3             = "Извещать цель";
HEALBOT_OPTIONS_CASTNOTIFY4             = "Группа";
HEALBOT_OPTIONS_CASTNOTIFY5             = "Рейд";
HEALBOT_OPTIONS_CASTNOTIFY6             = "В канал";
HEALBOT_OPTIONS_CASTNOTIFYRESONLY       = "Извещать только воскрешение";

HEALBOT_OPTIONS_CDCBARS                 = "Цвета полос";
HEALBOT_OPTIONS_CDCSHOWHBARS            = "На полосе здоровья";
HEALBOT_OPTIONS_CDCSHOWABARS            = "На полосе угрозы";
HEALBOT_OPTIONS_CDCWARNINGS             = "Предупреждения о дебафах";
HEALBOT_OPTIONS_SHOWDEBUFFICON          = "Иконки дебафов";
HEALBOT_OPTIONS_SHOWDEBUFFWARNING       = "Сообщения о дебафах";
HEALBOT_OPTIONS_SOUNDDEBUFFWARNING      = "Звук при дебафе";
HEALBOT_OPTIONS_SOUND                   = "Звук";

HEALBOT_OPTIONS_HEAL_BUTTONS            = "Панели исцелений";
HEALBOT_OPTIONS_SELFHEALS               = "Себя";
HEALBOT_OPTIONS_PETHEALS                = "Питомцев";
HEALBOT_OPTIONS_GROUPHEALS              = "Группу";
HEALBOT_OPTIONS_TANKHEALS               = "Главных танков";
HEALBOT_OPTIONS_MAINASSIST              = "Наводчик";
HEALBOT_OPTIONS_PRIVATETANKS            = "Личных Гл. танков";
HEALBOT_OPTIONS_TARGETHEALS             = "Цели";
HEALBOT_OPTIONS_EMERGENCYHEALS          = "Рейд";
HEALBOT_OPTIONS_ALERTLEVEL              = "Тревога";
HEALBOT_OPTIONS_EMERGFILTER             = "Экстра полосы для";
HEALBOT_OPTIONS_EMERGFCLASS             = "Настройка классов для";
HEALBOT_OPTIONS_COMBOBUTTON             = "Кнопка";
HEALBOT_OPTIONS_BUTTONLEFT              = "Левая";
HEALBOT_OPTIONS_BUTTONMIDDLE            = "Средняя";
HEALBOT_OPTIONS_BUTTONRIGHT             = "Правая";
HEALBOT_OPTIONS_BUTTON4                 = "Кнопка4";
HEALBOT_OPTIONS_BUTTON5                 = "Кнопка5";
HEALBOT_OPTIONS_BUTTON6                 = "Кнопка6";
HEALBOT_OPTIONS_BUTTON7                 = "Кнопка7";
HEALBOT_OPTIONS_BUTTON8                 = "Кнопка8";
HEALBOT_OPTIONS_BUTTON9                 = "Кнопка9";
HEALBOT_OPTIONS_BUTTON10                = "Кнопка10";
HEALBOT_OPTIONS_BUTTON11                = "Кнопка11";
HEALBOT_OPTIONS_BUTTON12                = "Кнопка12";
HEALBOT_OPTIONS_BUTTON13                = "Кнопка13";
HEALBOT_OPTIONS_BUTTON14                = "Кнопка14";
HEALBOT_OPTIONS_BUTTON15                = "Кнопка15";


HEALBOT_CLASSES_ALL                     = "Все классы";
HEALBOT_CLASSES_MELEE                   = "Ближние";
HEALBOT_CLASSES_RANGES                  = "Дальние";
HEALBOT_CLASSES_HEALERS                 = "Целители";
HEALBOT_CLASSES_CUSTOM                  = "Клиентские";

HEALBOT_OPTIONS_SHOWTOOLTIP             = "Подсказки";
HEALBOT_OPTIONS_SHOWDETTOOLTIP          = "Инфо о заклинании";
HEALBOT_OPTIONS_SHOWCDTOOLTIP           = "Восстановление заклинания";
HEALBOT_OPTIONS_SHOWUNITTOOLTIP         = "Инфо о цели";
HEALBOT_OPTIONS_SHOWRECTOOLTIP          = "Рекомендации Исцеления За Время";
HEALBOT_TOOLTIP_POSDEFAULT              = "По умолчанию";
HEALBOT_TOOLTIP_POSLEFT                 = "Слева Healbotа";
HEALBOT_TOOLTIP_POSRIGHT                = "Справа Healbotа";
HEALBOT_TOOLTIP_POSABOVE                = "Вверху Healbotа";
HEALBOT_TOOLTIP_POSBELOW                = "Внизу Healbotа";
HEALBOT_TOOLTIP_POSCURSOR               = "Под курсором";
HEALBOT_TOOLTIP_RECOMMENDTEXT           = "Рекомендации Исцеления За Время";
HEALBOT_TOOLTIP_NONE                    = "нет доступных";
HEALBOT_TOOLTIP_CORPSE                  = "Труп ";
HEALBOT_TOOLTIP_CD                      = " (CD ";
HEALBOT_TOOLTIP_SECS                    = "с)";
HEALBOT_WORDS_SEC                       = "сек";
HEALBOT_WORDS_CAST                      = "Применение";
HEALBOT_WORDS_UNKNOWN                   = "неизвестно";
HEALBOT_WORDS_YES                       = "Да";
HEALBOT_WORDS_NO                        = "Нет";
HEALBOT_WORDS_THIN                      = "Тонкий";
HEALBOT_WORDS_THICK                     = "Толстый";

HEALBOT_WORDS_NONE                      = "Нету";
HEALBOT_OPTIONS_ALT                     = "Alt";
HEALBOT_DISABLED_TARGET                 = "Цель"
HEALBOT_OPTIONS_SHOWCLASSONBAR          = "Классы на панели";
HEALBOT_OPTIONS_SHOWHEALTHONBAR         = "Здоровье на панели";
HEALBOT_OPTIONS_BARHEALTHINCHEALS       = "Входящее исцеление";
HEALBOT_OPTIONS_BARHEALTHSEPHEALS       = "Разделять вход. исцеление";
HEALBOT_OPTIONS_BARHEALTH1              = "в цифрах";
HEALBOT_OPTIONS_BARHEALTH2              = "в процентах";
HEALBOT_OPTIONS_TIPTEXT                 = "Информация в подсказке";
HEALBOT_OPTIONS_POSTOOLTIP              = "Подсказка";
HEALBOT_OPTIONS_SHOWNAMEONBAR           = "Имена";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1     = "Текст по цвету класса";
HEALBOT_OPTIONS_EMERGFILTERGROUPS       = "Группы";

HEALBOT_ONE                             = "1";
HEALBOT_TWO                             = "2";
HEALBOT_THREE                           = "3";
HEALBOT_FOUR                            = "4";
HEALBOT_FIVE                            = "5";
HEALBOT_SIX                             = "6";
HEALBOT_SEVEN                           = "7";
HEALBOT_EIGHT                           = "8";

HEALBOT_OPTIONS_SETDEFAULTS             = "Стандарт";
HEALBOT_OPTIONS_SETDEFAULTSMSG          = "Сброс всех настроек на стандартные";
HEALBOT_OPTIONS_RIGHTBOPTIONS           = "ПКМ открывает настройки";

HEALBOT_OPTIONS_HEADEROPTTEXT           = "Заголовки";
HEALBOT_OPTIONS_ICONOPTTEXT             = "Опции иконки";
HEALBOT_SKIN_HEADERBARCOL               = "Цвета панелей";
HEALBOT_SKIN_HEADERTEXTCOL              = "Цвета текста";
HEALBOT_OPTIONS_BUFFSTEXT1              = "Заклинание";
HEALBOT_OPTIONS_BUFFSTEXT2              = "Проверка";
HEALBOT_OPTIONS_BUFFSTEXT3              = "Цвета панелей";
HEALBOT_OPTIONS_BUFF                    = "Баф";
HEALBOT_OPTIONS_BUFFSELF                = "на себя";
HEALBOT_OPTIONS_BUFFPARTY               = "на группу";
HEALBOT_OPTIONS_BUFFRAID                = "на рейд";
HEALBOT_OPTIONS_MONITORBUFFS            = "Монитор пропущенных бафов";
HEALBOT_OPTIONS_MONITORBUFFSC           = "также в бою";
HEALBOT_OPTIONS_ENABLESMARTCAST         = "БыстроеЧтение когда в не боя";
HEALBOT_OPTIONS_SMARTCASTSPELLS         = "Заклинания";
HEALBOT_OPTIONS_SMARTCASTDISPELL        = "Расс-ть дебаф";
HEALBOT_OPTIONS_SMARTCASTBUFF           = "Добавить баф";
HEALBOT_OPTIONS_SMARTCASTHEAL           = "Исцеления";
HEALBOT_OPTIONS_BAR2SIZE                = "Размер полосы маны";
HEALBOT_OPTIONS_SETSPELLS               = "Заклинания";
HEALBOT_OPTIONS_ENABLEDBARS             = "Включить панели";
HEALBOT_OPTIONS_DISABLEDBARS            = "Отключить панели когда в не боя";
HEALBOT_OPTIONS_MONITORDEBUFFS          = "Монитор снятия дебафов";
HEALBOT_OPTIONS_DEBUFFTEXT1             = "Зак-ние снимающее дебафы";

HEALBOT_OPTIONS_IGNOREDEBUFF            = "Игнорировать:";
HEALBOT_OPTIONS_IGNOREDEBUFFCLASS       = "По классам";
HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT    = "Замедления";
HEALBOT_OPTIONS_IGNOREDEBUFFDURATION    = "Срок действия";
HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM      = "Не вредные";

HEALBOT_OPTIONS_RANGECHECKFREQ          = "Проверка досягаемости";

HEALBOT_OPTIONS_HIDEPARTYFRAMES         = "Скрыть окна группы";
HEALBOT_OPTIONS_HIDEPLAYERTARGET        = "Включая игрока и цель";
HEALBOT_OPTIONS_DISABLEHEALBOT          = "Отключить HealBot";

HEALBOT_OPTIONS_CHECKEDTARGET           = "Проверен";

HEALBOT_ASSIST                          = "Assist";
HEALBOT_FOCUS                           = "Focus";
HEALBOT_MENU                            = "Меню";
HEALBOT_MAINTANK                        = "Г.Танк";
HEALBOT_MAINASSIST                      = "Г.Помощник";
HEALBOT_STOP                            = "Стоп";
HEALBOT_TELL                            = "Сказать";

HEALBOT_TITAN_SMARTCAST                 = "БыстроеЧтение";
HEALBOT_TITAN_MONITORBUFFS              = "Монитор бафов";
HEALBOT_TITAN_MONITORDEBUFFS            = "Монитор дебафов";
HEALBOT_TITAN_SHOWBARS                  = "Панели для";
HEALBOT_TITAN_EXTRABARS                 = "Доп. панели";
HEALBOT_BUTTON_TOOLTIP                  = "ЛКМ переключает окно настроек HealBotа\nПКМ (Удерживая) для перемещения";
HEALBOT_TITAN_TOOLTIP                   = "ЛКМ переключает окно настроек HealBotа";
HEALBOT_OPTIONS_SHOWMINIMAPBUTTON       = "Показ кнопки у мини-карты";
HEALBOT_OPTIONS_BARBUTTONSHOWHOT        = "Показ иконки ИзВ";
HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON   = "Показ иконки рейда";
HEALBOT_OPTIONS_HOTONBAR                = "Внутри";
HEALBOT_OPTIONS_HOTOFFBAR               = "Снаружи";
HEALBOT_OPTIONS_HOTBARRIGHT             = "Справа";
HEALBOT_OPTIONS_HOTBARLEFT              = "Слева";

HEALBOT_ZONE_AB                         = "Низина Арати";
HEALBOT_ZONE_AV                         = "Альтеракская долина";
HEALBOT_ZONE_ES                         = "Око Бури";
HEALBOT_ZONE_IC                         = "Остров Завоеваний";
HEALBOT_ZONE_SA                         = "Берег Древних";
HEALBOT_ZONE_WG                         = "Ущелье Песни Войны";

HEALBOT_OPTION_AGGROTRACK               = "Монитор агрессии";
HEALBOT_OPTION_AGGROBAR                 = "Мигание";
HEALBOT_OPTION_AGGROTXT                 = ">> Показ текста <<";
HEALBOT_OPTION_BARUPDFREQ               = "Частота обновления";
HEALBOT_OPTION_USEFLUIDBARS             = "Исп текучие полосы";
HEALBOT_OPTION_CPUPROFILE               = "Использовать профайлер CPU (Инфо о нагрузке CPU )";
HEALBOT_OPTIONS_RELOADUIMSG             = "Для того чтобы настройки вступили бы в силу необходима перезагрузка интерфейса, Готовы?";

HEALBOT_BUFF_PVP                        = "PvP"
HEALBOT_BUFF_PVE						= "PvE"
HEALBOT_OPTIONS_ANCHOR                  = "Якорь фрейма";
HEALBOT_OPTIONS_BARSANCHOR              = "Якорь полос"
HEALBOT_OPTIONS_TOPLEFT                 = "Вверху слева";
HEALBOT_OPTIONS_BOTTOMLEFT              = "Внизу слева";
HEALBOT_OPTIONS_TOPRIGHT                = "Вверху справа";
HEALBOT_OPTIONS_BOTTOMRIGHT             = "Внизу справа";
HEALBOT_OPTIONS_TOP                     = "Вверху";
HEALBOT_OPTIONS_BOTTOM                  = "Внизу";

HEALBOT_PANEL_BLACKLIST                 = "Чёрный-Список";

HEALBOT_WORDS_REMOVEFROM                = "Снять с";
HEALBOT_WORDS_ADDTO                     = "Наложить на";
HEALBOT_WORDS_INCLUDE                   = "Включая";

HEALBOT_OPTIONS_TTALPHA                 = "Прозрачность";
HEALBOT_TOOLTIP_TARGETBAR               = "Панель цели";
HEALBOT_OPTIONS_MYTARGET                = "Моя цель";

HEALBOT_DISCONNECTED_TEXT               = "<ОФФ>"
HEALBOT_OPTIONS_SHOWUNITBUFFTIME        = "Показ.мои бафы";
HEALBOT_OPTIONS_TOOLTIPUPDATE           = "Постоянно обновлять";
HEALBOT_OPTIONS_BUFFSTEXTTIMER          = "Показ баф перед окончанием";
HEALBOT_OPTIONS_SHORTBUFFTIMER          = "Короткие бафы";
HEALBOT_OPTIONS_LONGBUFFTIMER           = "Длинные бафы";

HEALBOT_BALANCE                         = "Баланс";
HEALBOT_FERAL                           = "Сила зверя";
HEALBOT_RESTORATION                     = "Исцеление";
HEALBOT_SHAMAN_RESTORATION              = "Исцеление";
HEALBOT_ARCANE                          = "Тайная магия";
HEALBOT_FIRE                            = "Огонь";
HEALBOT_FROST                           = "Лед";
HEALBOT_DISCIPLINE                      = "Послушание";
HEALBOT_HOLY                            = "Свет";
HEALBOT_SHADOW                          = "Темная магия";
HEALBOT_ASSASSINATION                   = "Убийство";
HEALBOT_COMBAT                          = "Бой";
HEALBOT_SUBTLETY                        = "Скрытность";
HEALBOT_ARMS                            = "Оружие";
HEALBOT_FURY                            = "Неистовство";
HEALBOT_PROTECTION                      = "Защита";
HEALBOT_BEASTMASTERY                    = "Чувство зверя";
HEALBOT_MARKSMANSHIP                    = "Стрельба";
HEALBOT_SURVIVAL                        = "Выживание";
HEALBOT_RETRIBUTION                     = "Возмездие";
HEALBOT_ELEMENTAL                       = "Укрощение стихии";
HEALBOT_ENHANCEMENT                     = "Совершенствование";
HEALBOT_AFFLICTION                      = "Колдовство";
HEALBOT_DEMONOLOGY                      = "Демонология";
HEALBOT_DESTRUCTION                     = "Разрушение";
HEALBOT_BLOOD                           = "Кровь";
HEALBOT_UNHOLY                          = "Нечестивость";

HEALBOT_OPTIONS_VISIBLERANGE            = "Отключать панель когда расстояние больше 100 метров";
HEALBOT_OPTIONS_NOTIFY_HEAL_MSG         = "Сообщения о исцелении";
HEALBOT_OPTIONS_NOTIFY_MSG              = "Cообщения";
HEALBOT_WORDS_YOU                       = "вы";
HEALBOT_NOTIFYHEALMSG                   = "Применяется #s для исцеления #n на #h";
HEALBOT_NOTIFYOTHERMSG                  = "Применяется #s на #n";

HEALBOT_OPTIONS_HOTPOSITION             = "Позиция иконки";
HEALBOT_OPTIONS_HOTSHOWTEXT             = "Текст иконки";
HEALBOT_OPTIONS_HOTTEXTCOUNT            = "Подсчёт";
HEALBOT_OPTIONS_HOTTEXTDURATION         = "Длительность";
HEALBOT_OPTIONS_ICONSCALE               = "Масштаб";
HEALBOT_OPTIONS_ICONTEXTSCALE           = "Масштаб текста иконки";

HEALBOT_SKIN_FLUID                      = "Fluid";
HEALBOT_SKIN_VIVID                      = "Vivid";
HEALBOT_SKIN_LIGHT                      = "Light";
HEALBOT_SKIN_SQUARE                     = "Квадраты";
HEALBOT_OPTIONS_AGGROBARSIZE            = "Размер полосы угрозы";
HEALBOT_OPTIONS_DOUBLETEXTLINES         = "Текст в 2 строки";
HEALBOT_OPTIONS_TEXTALIGNMENT           = "Выравнивание текста";
HEALBOT_OPTIONS_ENABLELIBQH             = "Включить libQuickHealth";
HEALBOT_VEHICLE                         = "Транспорт";
HEALBOT_OPTIONS_UNIQUESPEC              = "Спец. заклинание для другой спецификации";
HEALBOT_WORDS_ERROR				        = "Ошибка";
HEALBOT_SPELL_NOT_FOUND			        = "Заклинание не найдено";
HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT  = "Скрыть подсказки в бою";

HEALBOT_OPTIONS_BUFFNAMED               = "Для наблюдения, введите имя игрока:\n\n";
HEALBOT_WORD_ALWAYS                     = "Всегда";
HEALBOT_WORD_SOLO                       = "В одиночку";
HEALBOT_WORD_NEVER                      = "Никогда";
HEALBOT_SHOW_CLASS_AS_ICON              = "как иконку";
HEALBOT_SHOW_CLASS_AS_TEXT              = "как текст";

HEALBOT_SHOW_INCHEALS                   = "Входящее исцеление";
HEALBOT_D_DURATION                      = "Длительность прямых";
HEALBOT_H_DURATION                      = "Длительность ИзВя";
HEALBOT_C_DURATION                      = "Длительность потоковых";

HEALBOT_HELP={ [1] = "[HealBot] /hb h -- показать справку",
               [2] = "[HealBot] /hb o -- переключение настроек",
               [3] = "[HealBot] /hb ri -- сбросить HealBot",
               [4] = "[HealBot] /hb t -- переключения Healbot из состояния включен в выключен и обратно",
               [5] = "[HealBot] /hb bt -- переключения мониторинга бафов из состояния включен в выключен и обратно",
               [6] = "[HealBot] /hb dt -- переключения мониторинга дебафов из состояния включен в выключен и обратно",
               [7] = "[HealBot] /hb skin <skinName> -- сменить шкурку",
               [8] = "[HealBot] /hb hs -- показать дополнительные слэш команды",
              }

HEALBOT_HELP2={ [1] = "[HealBot] /hb d -- сброс настроек на стандартные значения",
                [2] = "[HealBot] /hb ui -- перезагрузить UI",
                [3] = "[HealBot] /hb ri -- сбросить HealBot",
                [4] = "[HealBot] /hb tr <Role> -- установите наивысший приоритет по роли для под-сортировке по роли. Дествующие роли 'TANK', 'HEALER' или 'DPS'",
                [5] = "[HealBot] /hb use10 -- австоматически использовать Инженерный слот 10",
                [6] = "[HealBot] /hb pcs <n> -- регулировка размера индикатора заряда энергии света на <n>, Значение по умолчанию 7 ",
                [7] = "[HealBot] /hb info -- показать инф. окно",
                [8] = "[HealBot] /hb spt -- переключение своего питомца",
                [9] = "[HealBot] /hb ws -- переключение сокрытия/показа иконки Ослабленная душа вместо СС:Щ с -",
               [10] = "[HealBot] /hb rld <n> -- In seconds, how long the players name stays green after a res",
               [11] = "[HealBot] /hb flb -- Toggle frame lock bypass (frame always moves with Ctrl+Alt+Left click)",
               [12] = "[HealBot] /hb rtb -- Toggle restrict target bar to Left=SmartCast and Right=add/remove to/from My Targets",
              }
              
HEALBOT_OPTION_HIGHLIGHTACTIVEBAR       = "Выделять активную полосу";
HEALBOT_OPTION_HIGHLIGHTTARGETBAR       = "Выделять цель";
HEALBOT_OPTIONS_TESTBARS                = "Тест полос";
HEALBOT_OPTION_NUMBARS                  = "Количество полос";
HEALBOT_OPTION_NUMTANKS                 = "Количество танков";
HEALBOT_OPTION_NUMMYTARGETS             = "Количество моих целей";
HEALBOT_OPTION_NUMPETS                  = "Количество питов";
HEALBOT_WORD_TEST                       = "Тест";
HEALBOT_WORD_OFF                        = "Выкл";
HEALBOT_WORD_ON                         = "Вкл";

HEALBOT_OPTIONS_TAB_PROTECTION          = "Защита";
HEALBOT_OPTIONS_TAB_CHAT                = "Чат";
HEALBOT_OPTIONS_TAB_HEADERS             = "Заголовки";
HEALBOT_OPTIONS_TAB_BARS                = "Полосы";
HEALBOT_OPTIONS_TAB_ICONS               = "Иконки";
HEALBOT_OPTIONS_TAB_WARNING             = "Оповещения";
HEALBOT_OPTIONS_SKINDEFAULTFOR          = "Стандарт. шкурка для";
HEALBOT_OPTIONS_INCHEAL                 = "Вхд. исцеление";
HEALBOT_WORD_ARENA                      = "Арена";
HEALBOT_WORD_BATTLEGROUND               = "Поля боя";
HEALBOT_OPTIONS_TEXTOPTIONS             = "Опции текста";
HEALBOT_WORD_PARTY                      = "Группа";
HEALBOT_OPTIONS_COMBOAUTOTARGET         = "Авто цель";
HEALBOT_OPTIONS_COMBOAUTOTRINKET        = "Авто аксессуар";
HEALBOT_OPTIONS_GROUPSPERCOLUMN         = "Исп. группы на колонку";

HEALBOT_OPTIONS_MAINSORT                = "Гл. сорт";
HEALBOT_OPTIONS_SUBSORT                 = "Доп. сорт";
HEALBOT_OPTIONS_SUBSORTINC              = "Также доп сорт:";

HEALBOT_OPTIONS_BUTTONCASTMETHOD        = "Применить\nкогда";
HEALBOT_OPTIONS_BUTTONCASTPRESSED       = "Нажата";
HEALBOT_OPTIONS_BUTTONCASTRELEASED      = "Отпущена";

HEALBOT_INFO_INCHEALINFO                = "== Инфо входящего исцеления ==";
HEALBOT_INFO_ADDONCPUUSAGE              = "== Исп. CPU аддоном в секундах ==";
HEALBOT_INFO_ADDONCOMMUSAGE             = "== Исп. коммуникации аддоном ==";
HEALBOT_WORD_HEALER                     = "Лекарь";
HEALBOT_WORD_VERSION                    = "Версия";
HEALBOT_WORD_CLIENT                     = "Клиент";
HEALBOT_WORD_ADDON                      = "Аддон";
HEALBOT_INFO_CPUSECS                    = "CPU сек";
HEALBOT_INFO_MEMORYKB                   = "Память КБ";
HEALBOT_INFO_COMMS                      = "Связь КБ";

HEALBOT_WORD_STAR                       = "Звезда";
HEALBOT_WORD_CIRCLE                     = "Круг";
HEALBOT_WORD_DIAMOND                    = "Ромб";
HEALBOT_WORD_TRIANGLE                   = "Треугольник";
HEALBOT_WORD_MOON                       = "Луна";
HEALBOT_WORD_SQUARE                     = "Квадрат";
HEALBOT_WORD_CROSS                      = "Крест";
HEALBOT_WORD_SKULL                      = "Череп";

HEALBOT_OPTIONS_ACCEPTSKINMSG           = "Принять шкурку [HealBot]: ";
HEALBOT_OPTIONS_ACCEPTSKINMSGFROM       = " от ";
HEALBOT_OPTIONS_BUTTONSHARESKIN         = "Поделиться с";

HEALBOT_CHAT_ADDONID                    = "[HealBot]  ";
HEALBOT_CHAT_NEWVERSION1                = "Доступна новая версия";
HEALBOT_CHAT_NEWVERSION2                = "на http://healbot.alturl.com";
HEALBOT_CHAT_SHARESKINERR1              = " Skin not found for Sharing";
HEALBOT_CHAT_SHARESKINERR3              = " not found for Skin Sharing";
HEALBOT_CHAT_SHARESKINACPT              = "Share Skin accepted from ";
HEALBOT_CHAT_CONFIRMSKINDEFAULTS        = "Шкурка по умолчанию";
HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS      = "Пользовательский дебаф сброшен";
HEALBOT_CHAT_CHANGESKINERR1             = "неизвестная шкурка: /hb skin ";
HEALBOT_CHAT_CHANGESKINERR2             = "Действительные шкурки:  ";
HEALBOT_CHAT_CONFIRMSPELLCOPY           = "Текущее заклинания скопировано на все наборы талантов";
HEALBOT_CHAT_UNKNOWNCMD                 = "Неизвестная слэш команда: /hb ";
HEALBOT_CHAT_ENABLED                    = "Entering enabled state";
HEALBOT_CHAT_DISABLED                   = "Entering disabled state";
HEALBOT_CHAT_SOFTRELOAD                 = "Reload healbot requested";
HEALBOT_CHAT_HARDRELOAD                 = "Reload UI requested";
HEALBOT_CHAT_CONFIRMSPELLRESET          = "Заклинания сброшены";
HEALBOT_CHAT_CONFIRMCURESRESET          = "Лечения сброшены";
HEALBOT_CHAT_CONFIRMBUFFSRESET          = "Бафы сброшены";
HEALBOT_CHAT_POSSIBLEMISSINGMEDIA       = "Unable to receive all Skin settings - Possibly missing SharedMedia, see HealBot/Docs/readme.html for links";
HEALBOT_CHAT_MACROSOUNDON               = "Sound not suppressed when using auto trinkets";
HEALBOT_CHAT_MACROSOUNDOFF              = "Sound suppressed when using auto trinkets";
HEALBOT_CHAT_MACROERRORON               = "Errors not suppressed when using auto trinkets";
HEALBOT_CHAT_MACROERROROFF              = "Errors suppressed when using auto trinkets";
HEALBOT_CHAT_ACCEPTSKINON               = "Share Skin - Show accept skin popup when someone shares a skin with you";
HEALBOT_CHAT_ACCEPTSKINOFF              = "Share Skin - Always ignore share skins from everyone";
HEALBOT_CHAT_USE10ON                    = "Auto Trinket - Use10 is on - You must enable an existing auto trinket for use10 to work";
HEALBOT_CHAT_USE10OFF                   = "Auto Trinket - Use10 is off";
HEALBOT_CHAT_SKINREC                    = " получена шкурка от ";

HEALBOT_OPTIONS_SELFCASTS               = "Только личные применения";
HEALBOT_OPTIONS_HOTSHOWICON             = "Иконка";
HEALBOT_OPTIONS_ALLSPELLS               = "Все заклинания";
HEALBOT_OPTIONS_DOUBLEROW               = "Двойной ряд";
HEALBOT_OPTIONS_HOTBELOWBAR             = "Ниже полосы";
HEALBOT_OPTIONS_OTHERSPELLS             = "Другие заклинания";
HEALBOT_WORD_MACROS                     = "Макрос";
HEALBOT_WORD_SELECT                     = "Выбрать";
HEALBOT_OPTIONS_QUESTION                = "?";
HEALBOT_WORD_CANCEL                     = "Отмена";
HEALBOT_WORD_COMMANDS                   = "Команды"
HEALBOT_OPTIONS_BARHEALTH3              = "как здоровье";
HEALBOT_SORTBY_ROLE                     = "Роль";
HEALBOT_WORD_DPS                        = "DPS";
HEALBOT_CHAT_TOPROLEERR                 = " роль не действительна в данном контексте - используйте 'TANK', 'DPS' или 'HEALER'";
HEALBOT_CHAT_NEWTOPROLE                 = "Highest top role is now ";
HEALBOT_CHAT_SUBSORTPLAYER1             = "Player will be set to first in SubSort";
HEALBOT_CHAT_SUBSORTPLAYER2             = "Player will be sorted normally in SubSort";
HEALBOT_OPTIONS_SHOWREADYCHECK          = "Проверка готовности";
HEALBOT_OPTIONS_SUBSORTSELFFIRST        = "Сначало вы";
HEALBOT_WORD_FILTER                     = "Фильтр";
HEALBOT_OPTION_AGGROPCTBAR              = "Двигать";
HEALBOT_OPTION_AGGROPCTTXT              = "Показ. текст";
HEALBOT_OPTION_AGGROPCTTRACK            = "Следить в %";
HEALBOT_OPTIONS_ALERTAGGROLEVEL0        = "0 - имея низкую угрозы и ничего не танкуя";
HEALBOT_OPTIONS_ALERTAGGROLEVEL1        = "1 - имея высокую угрозу и ничего не танкуя";
HEALBOT_OPTIONS_ALERTAGGROLEVEL2        = "2 - опасное танкования, не наивысшая угроза на существе";
HEALBOT_OPTIONS_ALERTAGGROLEVEL3        = "3 - безопасное танкованин по крайней мере одно существо";
HEALBOT_OPTIONS_AGGROALERT              = "Уровент сигнала об угрозе";
HEALBOT_OPTIONS_TOOLTIPSHOWHOT          = "Показать подробности о наблюдаемом ИзВ";
HEALBOT_WORDS_MIN                       = "мин";
HEALBOT_WORDS_MAX                       = "макс";
HEALBOT_WORDS_R                         = "R";
HEALBOT_WORDS_G                         = "G";
HEALBOT_WORDS_B                         = "B";
HEALBOT_CHAT_SELFPETSON                 = "Self Pet switched on";
HEALBOT_CHAT_SELFPETSOFF                = "Self Pet switched off";
HEALBOT_WORD_PRIORITY                   = "Приоритет";
HEALBOT_VISIBLE_RANGE                   = "В пределах 100 метров";
HEALBOT_SPELL_RANGE                     = "В пределах действия заклинания";
HEALBOT_CUSTOM_CATEGORY                 = "Категория";
HEALBOT_CUSTOM_CAT_CUSTOM               = "Свой";
HEALBOT_CUSTOM_CAT_CLASSIC              = "Classic";
HEALBOT_CUSTOM_CAT_TBC_OTHER            = "TBC - Другое";
HEALBOT_CUSTOM_CAT_TBC_BT               = "TBC - Черный храм";
HEALBOT_CUSTOM_CAT_TBC_SUNWELL          = "TBC - Солнечный Колодец";
HEALBOT_CUSTOM_CAT_LK_OTHER             = "WotLK - Другое";
HEALBOT_CUSTOM_CAT_LK_ULDUAR            = "WotLK - Ульдуар";
HEALBOT_CUSTOM_CAT_LK_TOC               = "WotLK - Испытание крестоносца";
HEALBOT_CUSTOM_CAT_LK_ICC_LOWER         = "WotLK - ЦЛК Нижний ярус";
HEALBOT_CUSTOM_CAT_LK_ICC_PLAGUEWORKS   = "WotLK - ЦЛК Чумодельня";
HEALBOT_CUSTOM_CAT_LK_ICC_CRIMSON       = "WotLK - ЦЛК Багровый зал";
HEALBOT_CUSTOM_CAT_LK_ICC_FROSTWING     = "WotLK - ЦЛК Залы Ледокрылых";
HEALBOT_CUSTOM_CAT_LK_ICC_THRONE        = "WotLK - ЦЛК Ледяной Трон";
HEALBOT_CUSTOM_CAT_LK_RS_THRONE         = "WotLK - Рубиновое святилище"
HEALBOT_CUSTOM_CAT_CATA_OTHER           = "Cata - Другое";
HEALBOT_CUSTOM_CAT_CATA_PARTY           = "Cata - Группа";
HEALBOT_CUSTOM_CAT_CATA_RAID            = "Cata - Рейд";
HEALBOT_WORD_RESET                      = "Сброс";
HEALBOT_HBMENU                          = "HBmenu";
HEALBOT_ACTION_HBFOCUS                  = "Левый клик - установить\nфокус на цель";
HEALBOT_WORD_CLEAR                      = "Очистить";
HEALBOT_WORD_SET                        = "Установить";
HEALBOT_WORD_HBFOCUS                    = "Фокус HealBot";
HEALBOT_WORD_OUTSIDE                    = "Внешний мир";
HEALBOT_WORD_ALLZONE                    = "Все зоны";
HEALBOT_WORD_OTHER                      = "Другие";
HEALBOT_OPTIONS_TAB_ALERT               = "Тревога";
HEALBOT_OPTIONS_TAB_SORT                = "Сорт";
HEALBOT_OPTIONS_TAB_HIDE                = "Скрыть"
HEALBOT_OPTIONS_TAB_AGGRO               = "Угроза";
HEALBOT_OPTIONS_TAB_ICONTEXT            = "Текст иконки";
HEALBOT_OPTIONS_TAB_TEXT                = "Текст панели";
HEALBOT_OPTIONS_AGGROBARCOLS            = "Цвета полосы угрозы";
HEALBOT_OPTIONS_AGGRO1COL               = "Высокая\nугроза";
HEALBOT_OPTIONS_AGGRO2COL               = "Опасное\nтанкование";
HEALBOT_OPTIONS_AGGRO3COL               = "Безопастное\nтанкование";
HEALBOT_OPTIONS_AGGROFLASHFREQ          = "Частота сверкания";
HEALBOT_OPTIONS_AGGROFLASHALPHA         = "Прозрачность сверкания";
HEALBOT_OPTIONS_SHOWDURATIONFROM        = "Длительность от";
HEALBOT_OPTIONS_SHOWDURATIONWARN        = "Оповещение длительности от";
HEALBOT_CMD_RESETCUSTOMDEBUFFS          = "Сброс своих дебафов";
HEALBOT_CMD_RESETSKINS                  = "Сброс шкурок";
HEALBOT_CMD_CLEARBLACKLIST              = "Очистить черный список";
HEALBOT_CMD_TOGGLEACCEPTSKINS           = "Переключение приёма шкурок от других";
HEALBOT_CMD_COPYSPELLS                  = "Копировать данное заклинание во все наборы";
HEALBOT_CMD_RESETSPELLS                 = "Сброс заклинаний";
HEALBOT_CMD_RESETCURES                  = "Сброс лечений";
HEALBOT_CMD_RESETBUFFS                  = "Сброс бафов";
HEALBOT_CMD_RESETBARS                   = "Сброс позицый панелей";
HEALBOT_CMD_SUPPRESSSOUND               = "Переключение сдерживания звука когда используется авто аксессуар";
HEALBOT_CMD_SUPPRESSERRORS              = "Переключение сдерживания ошибок когда используется авто аксессуар";
HEALBOT_OPTIONS_COMMANDS                = "Команды HealBot";
HEALBOT_WORD_RUN                        = "Пуск";
HEALBOT_OPTIONS_MOUSEWHEEL              = "Включит меню на колесике мыши";
HEALBOT_OPTIONS_MOUSEUP                 = "Колёсик вверх"
HEALBOT_OPTIONS_MOUSEDOWN               = "Колёсик вниз"
HEALBOT_CMD_DELCUSTOMDEBUFF10           = "Delete custom debuffs on priority 10";
HEALBOT_ACCEPTSKINS                     = "Принемать шкурки от других";
HEALBOT_SUPPRESSSOUND                   = "Авто-Аксессуар: Подавлять звуки";
HEALBOT_SUPPRESSERROR                   = "Авто-Аксессуар: Подавлять ошибки";
HEALBOT_OPTIONS_CRASHPROT               = "Crash Protection";
HEALBOT_CP_MACRO_LEN                    = "Macro name must be between 1 and 14 characters";
HEALBOT_CP_MACRO_BASE                   = "Base macro name";
HEALBOT_CP_MACRO_SAVE                   = "Last saved at: ";
HEALBOT_CP_STARTTIME                    = "Protect duration on logon";
HEALBOT_WORD_RESERVED                   = "Reserved";
HEALBOT_OPTIONS_COMBATPROT              = "Combat Protection";
HEALBOT_COMBATPROT_PARTYNO              = "bars Reserved for Party";
HEALBOT_COMBATPROT_RAIDNO               = "bars Reserved for Raid";

HEALBOT_WORD_HEALTH                     = "Здоровье";
HEALBOT_OPTIONS_DONT_SHOW               = "Не показывать";
HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT    = "Same as health (current health)";
HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE     = "Same as health (future health)";
HEALBOT_OPTIONS_FUTURE_HLTH             = "Future health";
HEALBOT_SKIN_HEALTHBARCOL_TEXT          = "Цвет полосы здоровья";
HEALBOT_SKIN_INCHEALBARCOL_TEXT         = "Цвет входящего исцеления";
HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET      = "Цель: всегда показ.";
HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS       = "Фокус: всегда показ.";
HEALBOT_OPTIONS_GROUP_PETS_BY_FIVE      = "Питомцы: группы из 5и"
HEALBOT_OPTIONS_USEGAMETOOLTIP          = "Исп. игровую подсказку";
HEALBOT_OPTIONS_SHOWPOWERCOUNTER        = "Показ. знач. энергии";
HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA   = "Показ. энергию света";

HEALBOT_BLIZZARD_MENU                   = "Меню Blizzard"
HEALBOT_HB_MENU                         = "Меню Healbot"
HEALBOT_FOLLOW                          = "Следовать"
HEALBOT_TRADE                           = "Обмен"
HEALBOT_PROMOTE_RA                      = "Назначить помощником"
HEALBOT_DEMOTE_RA                       = "Разжаловать помощника"
HEALBOT_TOGGLE_ENABLED                  = "Переключениен включения"
HEALBOT_TOGGLE_MYTARGETS                = "Перекл. моих целей"
HEALBOT_TOGGLE_PRIVATETANKS             = "Перекл. личных танков"
HEALBOT_RESET_BAR                       = "Сброс панели"
HEALBOT_HIDE_BARS                       = "Скрыть полосы дальше 100 метров"
HEALBOT_RANDOMMOUNT                     = "Случайный транспорт"
HEALBOT_RANDOMGOUNDMOUNT                = "Случ. наземн. транспорт"
HEALBOT_RANDOMPET                       = "Случайный спутник"
HEALBOT_ZONE_AQ40                       = "Ан'Кираж"
HEALBOT_ZONE_THEOCULUS                  = "Окулус"
HEALBOT_ZONE_VASHJIR1                   = "Лес Келп’тар"
HEALBOT_ZONE_VASHJIR2                   = "Мерцающий простор"
HEALBOT_ZONE_VASHJIR3                   = "Бездонные глубины"
HEALBOT_ZONE_VASHJIR                    = "Вайш'ир"
HEALBOT_RESLAG_INDICATOR                = "Keep name green after res set to" 
HEALBOT_RESLAG_INDICATOR_ERROR          = "Keep name green after res must be between 1 and 30" 
HEALBOT_FRAMELOCK_BYPASS_OFF            = "Frame lock bypass turned Off"
HEALBOT_FRAMELOCK_BYPASS_ON             = "Frame lock bypass (Ctl+Alt+Left) turned On"
HEALBOT_RESTRICTTARGETBAR_ON            = "Restrict Target bar turned On"
HEALBOT_RESTRICTTARGETBAR_OFF           = "Restrict Target bar turned Off"
HEALBOT_PRELOADOPTIONS_ON               = "PreLoad Options turned On"
HEALBOT_PRELOADOPTIONS_OFF              = "PreLoad Options turned Off"

end
