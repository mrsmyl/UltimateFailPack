-- English maintained by Strife.

-------------
-- ENGLISH --
-------------
--
--
--
--
--
--
--
--
--


function HealBot_Lang_enUK()
    HEALBOT_enWORD_COLOUR_SUFFIX = "our"
    HealBot_Lang_enALL()
end

function HealBot_Lang_enUS()
    HEALBOT_enWORD_COLOUR_SUFFIX = "or"
    HealBot_Lang_enALL()
end

function HealBot_Lang_enALL()

    -----------------
    -- Translation --
    -----------------

    -- Class
    HEALBOT_DRUID                           = "Druid";
    HEALBOT_HUNTER                          = "Hunter";
    HEALBOT_MAGE                            = "Mage";
    HEALBOT_PALADIN                         = "Paladin";
    HEALBOT_PRIEST                          = "Priest";
    HEALBOT_ROGUE                           = "Rogue";
    HEALBOT_SHAMAN                          = "Shaman";
    HEALBOT_WARLOCK                         = "Warlock";
    HEALBOT_WARRIOR                         = "Warrior";
    HEALBOT_DEATHKNIGHT                     = "Death Knight";
    HEALBOT_MONK                            = "Monk";

    HEALBOT_DISEASE                         = "Disease";
    HEALBOT_MAGIC                           = "Magic";
    HEALBOT_CURSE                           = "Curse";
    HEALBOT_POISON                          = "Poison";

    HB_TOOLTIP_OFFLINE                      = "Offline";
    HB_OFFLINE                              = "offline"; -- has gone offline msg
    HB_ONLINE                               = "online"; -- has come online msg

    HEALBOT_HEALBOT                         = "HealBot";
    HEALBOT_ADDON                           = HEALBOT_HEALBOT .. " " .. HEALBOT_VERSION;
    HEALBOT_LOADED                          = " loaded.";

    HEALBOT_ACTION_OPTIONS                  = "Options";

    HEALBOT_OPTIONS_TITLE                   = HEALBOT_ADDON;
    HEALBOT_OPTIONS_DEFAULTS                = "Defaults";
    HEALBOT_OPTIONS_CLOSE                   = "Close";
    HEALBOT_OPTIONS_HARDRESET               = "ReloadUI"
    HEALBOT_OPTIONS_SOFTRESET               = "ResetHB"
    HEALBOT_OPTIONS_TAB_GENERAL             = "General";
    HEALBOT_OPTIONS_TAB_SPELLS              = "Spells";
    HEALBOT_OPTIONS_TAB_HEALING             = "Healing";
    HEALBOT_OPTIONS_TAB_CDC                 = "Cure";
    HEALBOT_OPTIONS_TAB_SKIN                = "Skins";
    HEALBOT_OPTIONS_TAB_TIPS                = "Tips";
    HEALBOT_OPTIONS_TAB_BUFFS               = "Buffs"

    HEALBOT_OPTIONS_BARALPHA                = "Enabled opacity";
    HEALBOT_OPTIONS_BARALPHAINHEAL          = "Incoming heals opacity";
    HEALBOT_OPTIONS_BARALPHABACK            = "Background bar opacity";
    HEALBOT_OPTIONS_BARALPHAEOR             = "Out of range opacity";
    HEALBOT_OPTIONS_ACTIONLOCKED            = "Lock position";
    HEALBOT_OPTIONS_AUTOSHOW                = "Close automatically";
    HEALBOT_OPTIONS_PANELSOUNDS             = "Play sound on open";
    HEALBOT_OPTIONS_HIDEOPTIONS             = "Hide options button";
    HEALBOT_OPTIONS_PROTECTPVP              = "Avoid PvP";
    HEALBOT_OPTIONS_HEAL_CHATOPT            = "Chat Options";

    HEALBOT_OPTIONS_FRAMESCALE              = "Frame Scale"
    HEALBOT_OPTIONS_SKINTEXT                = "Use skin"
    HEALBOT_SKINS_STD                       = "Standard"
    HEALBOT_OPTIONS_SKINTEXTURE             = "Texture"
    HEALBOT_OPTIONS_SKINHEIGHT              = "Height"
    HEALBOT_OPTIONS_SKINWIDTH               = "Width"
    HEALBOT_OPTIONS_SKINNUMCOLS             = "No. columns"
    HEALBOT_OPTIONS_SKINNUMHCOLS            = "No. groups per column"
    HEALBOT_OPTIONS_SKINBRSPACE             = "Row spacer"
    HEALBOT_OPTIONS_SKINBCSPACE             = "Col spacer"
    HEALBOT_OPTIONS_EXTRASORT               = "Sort raid bars by"
    HEALBOT_SORTBY_NAME                     = "Name"
    HEALBOT_SORTBY_CLASS                    = "Class"
    HEALBOT_SORTBY_GROUP                    = "Group"
    HEALBOT_SORTBY_MAXHEALTH                = "Max health"
    HEALBOT_OPTIONS_NEWDEBUFFTEXT           = "New debuff"
    HEALBOT_OPTIONS_DELSKIN                 = "Delete"
    HEALBOT_OPTIONS_NEWSKINTEXT             = "New skin"
    HEALBOT_OPTIONS_SAVESKIN                = "Save"
    HEALBOT_OPTIONS_SKINBARS                = "Bar options"
    HEALBOT_SKIN_ENTEXT                     = "Enabled"
    HEALBOT_SKIN_DISTEXT                    = "Disabled"
    HEALBOT_SKIN_DEBTEXT                    = "Debuff"
    HEALBOT_SKIN_BACKTEXT                   = "Background"
    HEALBOT_SKIN_BORDERTEXT                 = "Border"
    HEALBOT_OPTIONS_SKINFONT                = "Font"
    HEALBOT_OPTIONS_SKINFHEIGHT             = "Font Size"
    HEALBOT_OPTIONS_SKINFOUTLINE            = "Font Outline"
    HEALBOT_OPTIONS_BARALPHADIS             = "Disabled opacity"
    HEALBOT_OPTIONS_SHOWHEADERS             = "Show headers"

    HEALBOT_OPTIONS_ITEMS                   = "Items";

    HEALBOT_OPTIONS_COMBOCLASS              = "Key combos for";
    HEALBOT_OPTIONS_CLICK                   = "Click";
    HEALBOT_OPTIONS_SHIFT                   = "Shift";
    HEALBOT_OPTIONS_CTRL                    = "Ctrl";
    HEALBOT_OPTIONS_ENABLEHEALTHY           = "Always use enabled";

    HEALBOT_OPTIONS_CASTNOTIFY1             = "No messages";
    HEALBOT_OPTIONS_CASTNOTIFY2             = "Notify self";
    HEALBOT_OPTIONS_CASTNOTIFY3             = "Notify target";
    HEALBOT_OPTIONS_CASTNOTIFY4             = "Notify party";
    HEALBOT_OPTIONS_CASTNOTIFY5             = "Notify raid";
    HEALBOT_OPTIONS_CASTNOTIFY6             = "Notify chan";
    HEALBOT_OPTIONS_CASTNOTIFYRESONLY       = "Notify for resurrection only";

    HEALBOT_OPTIONS_CDCBARS                 = "Bar col"..HEALBOT_enWORD_COLOUR_SUFFIX.."s";
    HEALBOT_OPTIONS_CDCSHOWHBARS            = "Change health bar col"..HEALBOT_enWORD_COLOUR_SUFFIX;
    HEALBOT_OPTIONS_CDCSHOWABARS            = "Change aggro bar col"..HEALBOT_enWORD_COLOUR_SUFFIX;
    HEALBOT_OPTIONS_CDCWARNINGS             = "Debuff warnings";
    HEALBOT_OPTIONS_SHOWDEBUFFICON          = "Show debuff";
    HEALBOT_OPTIONS_SHOWDEBUFFWARNING       = "Display warning on debuff";
    HEALBOT_OPTIONS_SOUNDDEBUFFWARNING      = "Play sound on debuff";
    HEALBOT_OPTIONS_SOUND                   = "Sound"

    HEALBOT_OPTIONS_HEAL_BUTTONS            = "Healing bars";
    HEALBOT_OPTIONS_SELFHEALS               = "Self"
    HEALBOT_OPTIONS_PETHEALS                = "Pets"
    HEALBOT_OPTIONS_GROUPHEALS              = "Group";
    HEALBOT_OPTIONS_TANKHEALS               = "Main tanks";
    HEALBOT_OPTIONS_MAINASSIST              = "Main assist";
    HEALBOT_OPTIONS_PRIVATETANKS            = "Private main tanks";
    HEALBOT_OPTIONS_TARGETHEALS             = "Targets";
    HEALBOT_OPTIONS_EMERGENCYHEALS          = "Raid";
    HEALBOT_OPTIONS_ALERTLEVEL              = "Alert Level";
    HEALBOT_OPTIONS_EMERGFILTER             = "Show raid bars for";
    HEALBOT_OPTIONS_EMERGFCLASS             = "Configure classes for";
    HEALBOT_OPTIONS_COMBOBUTTON             = "Button";
    HEALBOT_OPTIONS_BUTTONLEFT              = "Left";
    HEALBOT_OPTIONS_BUTTONMIDDLE            = "Middle";
    HEALBOT_OPTIONS_BUTTONRIGHT             = "Right";
    HEALBOT_OPTIONS_BUTTON4                 = "Button4";
    HEALBOT_OPTIONS_BUTTON5                 = "Button5";
    HEALBOT_OPTIONS_BUTTON6                 = "Button6";
    HEALBOT_OPTIONS_BUTTON7                 = "Button7";
    HEALBOT_OPTIONS_BUTTON8                 = "Button8";
    HEALBOT_OPTIONS_BUTTON9                 = "Button9";
    HEALBOT_OPTIONS_BUTTON10                = "Button10";
    HEALBOT_OPTIONS_BUTTON11                = "Button11";
    HEALBOT_OPTIONS_BUTTON12                = "Button12";
    HEALBOT_OPTIONS_BUTTON13                = "Button13";
    HEALBOT_OPTIONS_BUTTON14                = "Button14";
    HEALBOT_OPTIONS_BUTTON15                = "Button15";

    HEALBOT_CLASSES_ALL                     = "All classes";
    HEALBOT_CLASSES_MELEE                   = "Melee";
    HEALBOT_CLASSES_RANGES                  = "Ranged";
    HEALBOT_CLASSES_HEALERS                 = "Healers";
    HEALBOT_CLASSES_CUSTOM                  = "Custom";

    HEALBOT_OPTIONS_SHOWTOOLTIP             = "Show tooltips";
    HEALBOT_OPTIONS_SHOWDETTOOLTIP          = "Show detailed spell information";
    HEALBOT_OPTIONS_SHOWCDTOOLTIP           = "Show spell cooldown";
    HEALBOT_OPTIONS_SHOWUNITTOOLTIP         = "Show target information";
    HEALBOT_OPTIONS_SHOWRECTOOLTIP          = "Show heal over time recommendation";
    HEALBOT_TOOLTIP_POSDEFAULT              = "Default location";
    HEALBOT_TOOLTIP_POSLEFT                 = "Left of Healbot";
    HEALBOT_TOOLTIP_POSRIGHT                = "Right of Healbot";
    HEALBOT_TOOLTIP_POSABOVE                = "Above Healbot";
    HEALBOT_TOOLTIP_POSBELOW                = "Below Healbot";
    HEALBOT_TOOLTIP_POSCURSOR               = "Next to Cursor";
    HEALBOT_TOOLTIP_RECOMMENDTEXT           = "Heal over time Recommendation";
    HEALBOT_TOOLTIP_NONE                    = "none available";
    HEALBOT_TOOLTIP_CORPSE                  = "Corpse of ";
    HEALBOT_TOOLTIP_CD                      = " (CD ";
    HEALBOT_TOOLTIP_SECS                    = "s)";
    HEALBOT_WORDS_SEC                       = "sec";
    HEALBOT_WORDS_CAST                      = "Cast";
    HEALBOT_WORDS_UNKNOWN                   = "Unknown";
    HEALBOT_WORDS_YES                       = "Yes";
    HEALBOT_WORDS_NO                        = "No";
    HEALBOT_WORDS_THIN                      = "Thin";
    HEALBOT_WORDS_THICK                     = "Thick";

    HEALBOT_WORDS_NONE                      = "None";
    HEALBOT_OPTIONS_ALT                     = "Alt";
    HEALBOT_DISABLED_TARGET                 = "Target";
    HEALBOT_OPTIONS_SHOWCLASSONBAR          = "Show class on bar";
    HEALBOT_OPTIONS_SHOWHEALTHONBAR         = "Show health on bar";
    HEALBOT_OPTIONS_BARHEALTHINCHEALS       = "Include incoming heals";
    HEALBOT_OPTIONS_BARHEALTHSEPHEALS       = "Separate incoming heals";
    HEALBOT_OPTIONS_BARHEALTH1              = "as delta";
    HEALBOT_OPTIONS_BARHEALTH2              = "as percentage";
    HEALBOT_OPTIONS_TIPTEXT                 = "Tooltip information";
    HEALBOT_OPTIONS_POSTOOLTIP              = "Position tooltip";
    HEALBOT_OPTIONS_SHOWNAMEONBAR           = "Show name on bar";
    HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1     = "Col"..HEALBOT_enWORD_COLOUR_SUFFIX.." text by class";
    HEALBOT_OPTIONS_EMERGFILTERGROUPS       = "Include raid groups";

    HEALBOT_ONE                             = "1";
    HEALBOT_TWO                             = "2";
    HEALBOT_THREE                           = "3";
    HEALBOT_FOUR                            = "4";
    HEALBOT_FIVE                            = "5";
    HEALBOT_SIX                             = "6";
    HEALBOT_SEVEN                           = "7";
    HEALBOT_EIGHT                           = "8";

    HEALBOT_OPTIONS_SETDEFAULTS             = "Set defaults";
    HEALBOT_OPTIONS_SETDEFAULTSMSG          = "Reset all options to default values";
    HEALBOT_OPTIONS_RIGHTBOPTIONS           = "Right click opens options";

    HEALBOT_OPTIONS_HEADEROPTTEXT           = "Header options";
    HEALBOT_OPTIONS_ICONOPTTEXT             = "Icon options";
    HEALBOT_SKIN_HEADERBARCOL               = "Bar col"..HEALBOT_enWORD_COLOUR_SUFFIX;
    HEALBOT_SKIN_HEADERTEXTCOL              = "Text col"..HEALBOT_enWORD_COLOUR_SUFFIX;
    HEALBOT_OPTIONS_BUFFSTEXT1              = "Spell to buff";
    HEALBOT_OPTIONS_BUFFSTEXT2              = "check members";
    HEALBOT_OPTIONS_BUFFSTEXT3              = "bar col"..HEALBOT_enWORD_COLOUR_SUFFIX.."s";
    HEALBOT_OPTIONS_BUFF                    = "Buff ";
    HEALBOT_OPTIONS_BUFFSELF                = "on self";
    HEALBOT_OPTIONS_BUFFPARTY               = "on party";
    HEALBOT_OPTIONS_BUFFRAID                = "on raid";
    HEALBOT_OPTIONS_MONITORBUFFS            = "Monitor for missing buffs";
    HEALBOT_OPTIONS_MONITORBUFFSC           = "also in combat";
    HEALBOT_OPTIONS_ENABLESMARTCAST         = "SmartCast out of combat";
    HEALBOT_OPTIONS_SMARTCASTSPELLS         = "Include spells";
    HEALBOT_OPTIONS_SMARTCASTDISPELL        = "Remove debuffs";
    HEALBOT_OPTIONS_SMARTCASTBUFF           = "Add buffs";
    HEALBOT_OPTIONS_SMARTCASTHEAL           = "Healing spells";
    HEALBOT_OPTIONS_BAR2SIZE                = "Power bar size";
    HEALBOT_OPTIONS_SETSPELLS               = "Set spells for";
    HEALBOT_OPTIONS_ENABLEDBARS             = "Enabled bars at all times";
    HEALBOT_OPTIONS_DISABLEDBARS            = "Disabled bars when out of combat";
    HEALBOT_OPTIONS_MONITORDEBUFFS          = "Monitor to remove debuffs";
    HEALBOT_OPTIONS_DEBUFFTEXT1             = "Spell to remove debuffs";

    HEALBOT_OPTIONS_IGNOREDEBUFF            = "Ignore debuffs:";
    HEALBOT_OPTIONS_IGNOREDEBUFFCLASS       = "By class";
    HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT    = "Slow movement";
    HEALBOT_OPTIONS_IGNOREDEBUFFDURATION    = "Short duration";
    HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM      = "Non harmful";
    HEALBOT_OPTIONS_IGNOREDEBUFFCOOLDOWN    = "When cure spell CoolDown > 1.5 secs (GCD)";
    HEALBOT_OPTIONS_IGNOREDEBUFFFRIEND      = "When caster is known as friend";

    HEALBOT_OPTIONS_RANGECHECKFREQ          = "Range, Aura and Aggro check frequency";

    HEALBOT_OPTIONS_HIDEPARTYFRAMES         = "Hide party frames";
    HEALBOT_OPTIONS_HIDEPLAYERTARGET        = "Include player and target";
    HEALBOT_OPTIONS_DISABLEHEALBOT          = "Disable HealBot";

    HEALBOT_ASSIST                          = "Assist";
    HEALBOT_FOCUS                           = "Focus";
    HEALBOT_MENU                            = "Menu";
    HEALBOT_MAINTANK                        = "MainTank";
    HEALBOT_MAINASSIST                      = "MainAssist";
    HEALBOT_STOP                            = "Stop";
    HEALBOT_TELL                            = "Tell";

    HEALBOT_TITAN_SMARTCAST                 = "SmartCast";
    HEALBOT_TITAN_MONITORBUFFS              = "Monitor buffs";
    HEALBOT_TITAN_MONITORDEBUFFS            = "Monitor debuffs"
    HEALBOT_TITAN_SHOWBARS                  = "Show bars for";
    HEALBOT_TITAN_EXTRABARS                 = "Extra bars";
    HEALBOT_BUTTON_TOOLTIP                  = "Click to toggle HealBot options panel\nClick and hold to move this icon";
    HEALBOT_TITAN_TOOLTIP                   = "Left click to toggle HealBot options panel";
    HEALBOT_OPTIONS_SHOWMINIMAPBUTTON       = "Show minimap button";
    HEALBOT_OPTIONS_BARBUTTONSHOWHOT        = "Show HoT";
    HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON   = "Show Raid Target";
    HEALBOT_OPTIONS_HOTONBAR                = "On bar";
    HEALBOT_OPTIONS_HOTOFFBAR               = "Off bar";
    HEALBOT_OPTIONS_HOTBARRIGHT             = "Right side";
    HEALBOT_OPTIONS_HOTBARLEFT              = "Left side";

    HEALBOT_ZONE_AB                         = "Arathi Basin";
    HEALBOT_ZONE_AV                         = "Alterac Valley";
    HEALBOT_ZONE_ES                         = "Eye of the Storm";
    HEALBOT_ZONE_IC                         = "Isle of Conquest";
    HEALBOT_ZONE_SA                         = "Strand of the Ancients";

    HEALBOT_OPTION_AGGROTRACK               = "Monitor Aggro"
    HEALBOT_OPTION_AGGROBAR                 = "Bar"
    HEALBOT_OPTION_AGGROTXT                 = ">> Text <<"
    HEALBOT_OPTION_AGGROIND                 = "Indicator"
    HEALBOT_OPTION_BARUPDFREQ               = "Refresh Multiplier"
    HEALBOT_OPTION_USEFLUIDBARS             = "Use fluid bars"
    HEALBOT_OPTION_CPUPROFILE               = "Use CPU profiler (Addons CPU usage Info)"
    HEALBOT_OPTIONS_RELOADUIMSG             = "This option requires a UI Reload, Reload now?"

    HEALBOT_BUFF_PVP                        = "PvP"
    HEALBOT_BUFF_PVE						= "PvE"
    HEALBOT_OPTIONS_ANCHOR                  = "Frame anchor"
    HEALBOT_OPTIONS_BARSANCHOR              = "Bars anchor"
    HEALBOT_OPTIONS_TOPLEFT                 = "Top Left"
    HEALBOT_OPTIONS_BOTTOMLEFT              = "Bottom Left"
    HEALBOT_OPTIONS_TOPRIGHT                = "Top Right"
    HEALBOT_OPTIONS_BOTTOMRIGHT             = "Bottom Right"
    HEALBOT_OPTIONS_TOP                     = "Top"
    HEALBOT_OPTIONS_BOTTOM                  = "Bottom"

    HEALBOT_PANEL_BLACKLIST                 = "BlackList"

    HEALBOT_WORDS_REMOVEFROM                = "Remove from";
    HEALBOT_WORDS_ADDTO                     = "Add to";
    HEALBOT_WORDS_INCLUDE                   = "Include";

    HEALBOT_OPTIONS_TTALPHA                 = "Opacity"
    HEALBOT_TOOLTIP_TARGETBAR               = "Target Bar"
    HEALBOT_OPTIONS_MYTARGET                = "My Targets"

    HEALBOT_DISCONNECTED_TEXT               = "<DC>"
    HEALBOT_OPTIONS_SHOWUNITBUFFTIME        = "Show my buffs";
    HEALBOT_OPTIONS_TOOLTIPUPDATE           = "Constantly update";
    HEALBOT_OPTIONS_BUFFSTEXTTIMER          = "Show buff before it expires";
    HEALBOT_OPTIONS_SHORTBUFFTIMER          = "Short buffs"
    HEALBOT_OPTIONS_LONGBUFFTIMER           = "Long buffs"

    HEALBOT_OPTIONS_NOTIFY_MSG              = "Message"
    HEALBOT_WORDS_YOU                       = "you";
    HEALBOT_NOTIFYOTHERMSG                  = "Casting #s on #n";

    HEALBOT_OPTIONS_HOTPOSITION             = "Icon position"
    HEALBOT_OPTIONS_HOTSHOWTEXT             = "Show icon text"
    HEALBOT_OPTIONS_HOTTEXTCOUNT            = "Count"
    HEALBOT_OPTIONS_HOTTEXTDURATION         = "Duration"
    HEALBOT_OPTIONS_ICONSCALE               = "Icon Scale"
    HEALBOT_OPTIONS_ICONTEXTSCALE           = "Icon Text Scale"

    HEALBOT_OPTIONS_AGGROBARSIZE            = "Aggro bar size"
    HEALBOT_OPTIONS_DOUBLETEXTLINES         = "Double text lines"
    HEALBOT_OPTIONS_TEXTALIGNMENT           = "Text Alignment"
    HEALBOT_VEHICLE                         = "Vehicle"
    HEALBOT_WORDS_ERROR                     = "Error"
    HEALBOT_SPELL_NOT_FOUND	                = "Spell Not Found"
    HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT  = "Hide Tooltip in Combat"
    HEALBOT_OPTIONS_ENABLELIBQH             = "Enable HealBot fastHealth"

    HEALBOT_OPTIONS_BUFFNAMED               = "Enter the player names to watch for\n\n"
    HEALBOT_WORD_ALWAYS                     = "Always";
    HEALBOT_WORD_SOLO                       = "Solo";
    HEALBOT_WORD_NEVER                      = "Never";
    HEALBOT_SHOW_CLASS_AS_ICON              = "as icon";
    HEALBOT_SHOW_CLASS_AS_TEXT              = "as text";
    HEALBOT_SHOW_ROLE                       = "show role when set";

    HEALBOT_SHOW_INCHEALS                   = "Show incoming heals";

    HEALBOT_HELP={ [1] = "[HealBot] /hb h -- Display help",
                   [2] = "[HealBot] /hb o -- Toggles options",
                   [3] = "[HealBot] /hb ri -- Reset HealBot",
                   [4] = "[HealBot] /hb t -- Toggle Healbot between disabled and enabled",
                   [5] = "[HealBot] /hb bt -- Toggle Buff Monitor between disabled and enabled",
                   [6] = "[HealBot] /hb dt -- Toggle Debuff Monitor between disabled and enabled",
                   [7] = "[HealBot] /hb skin <skinName> -- Switch Skins",
                   [8] = "[HealBot] /hb ui -- Reload UI",
                   [9] = "[HealBot] /hb hs -- Display additional slash commands",
                  }

    HEALBOT_HELP2={ [1] = "[HealBot] /hb d -- Reset options to default",
                    [2] = "[HealBot] /hb aggro 2 <n> -- Set aggro level 2 on threat percentage <n>",
                    [3] = "[HealBot] /hb aggro 3 <n> -- Set aggro level 3 on threat percentage <n>",
                    [4] = "[HealBot] /hb tr <Role> -- Set highest role priority for SubSort by Role. Valid Roles are 'TANK', 'HEALER' or 'DPS'",
                    [5] = "[HealBot] /hb use10 -- Automatically use Engineering slot 10",
                    [6] = "[HealBot] /hb pcs <n> -- Adjust the size of the Holy power charge indicator by <n>, Default value is 7 ",
                    [7] = "[HealBot] /hb spt -- Self Pet toggle",
                    [8] = "[HealBot] /hb ws -- Toggle Hide/Show the Weaken Soul icon instead of the PW:S with a -",
                    [9] = "[HealBot] /hb rld <n> -- In seconds, how long the players name stays green after a res",
                    [10] = "[HealBot] /hb flb -- Toggle frame lock bypass (frame always moves with Ctrl+Alt+Left click)",
                    [11] = "[HealBot] /hb rtb -- Toggle restrict target bar to Left=SmartCast and Right=add/remove to/from My Targets",
                  }
                  
    HEALBOT_OPTION_HIGHLIGHTACTIVEBAR       = "Highlight mouseover"
    HEALBOT_OPTION_HIGHLIGHTTARGETBAR       = "Highlight target"
    HEALBOT_OPTIONS_TESTBARS                = "Test Bars"
    HEALBOT_OPTION_NUMBARS                  = "Number of Bars"
    HEALBOT_OPTION_NUMTANKS                 = "Number of Tanks"
    HEALBOT_OPTION_NUMMYTARGETS             = "Number of MyTargets"
    HEALBOT_OPTION_NUMPETS                  = "Number of Pets"
    HEALBOT_WORD_TEST                       = "Test";
    HEALBOT_WORD_OFF                        = "Off";
    HEALBOT_WORD_ON                         = "On";

    HEALBOT_OPTIONS_TAB_PROTECTION          = "Protection"
    HEALBOT_OPTIONS_TAB_CHAT                = "Chat"
    HEALBOT_OPTIONS_TAB_HEADERS             = "Headers"
    HEALBOT_OPTIONS_TAB_BARS                = "Bars"
    HEALBOT_OPTIONS_TAB_ICONS               = "Icons"
    HEALBOT_OPTIONS_TAB_WARNING             = "Warning"
    HEALBOT_OPTIONS_SKINDEFAULTFOR          = "Skin default for"
    HEALBOT_OPTIONS_INCHEAL                 = "Incoming heals"
    HEALBOT_WORD_ARENA                      = "Arena"
    HEALBOT_WORD_BATTLEGROUND               = "Battle Ground"
    HEALBOT_OPTIONS_TEXTOPTIONS             = "Text Options"
    HEALBOT_WORD_PARTY                      = "Party"
    HEALBOT_OPTIONS_COMBOAUTOTARGET         = "Auto\nTarget"
    HEALBOT_OPTIONS_COMBOAUTOTRINKET        = "Auto Trinket"
    HEALBOT_OPTIONS_GROUPSPERCOLUMN         = "Use Groups per Column"

    HEALBOT_OPTIONS_MAINSORT                = "Main sort"
    HEALBOT_OPTIONS_SUBSORT                 = "Sub sort"
    HEALBOT_OPTIONS_SUBSORTINC              = "Also sub sort:"

    HEALBOT_OPTIONS_BUTTONCASTMETHOD        = "cast when"
    HEALBOT_OPTIONS_BUTTONCASTPRESSED       = "Pressed"
    HEALBOT_OPTIONS_BUTTONCASTRELEASED      = "Released"

    HEALBOT_INFO_ADDONCPUUSAGE              = "== Addon CPU Usage in Seconds =="
    HEALBOT_INFO_ADDONCOMMUSAGE             = "== Addon Comms Usage =="
    HEALBOT_WORD_HEALER                     = "Healer"
    HEALBOT_WORD_DAMAGER                    = "Damager"
    HEALBOT_WORD_TANK                       = "Tank"
    HEALBOT_WORD_LEADER                     = "Leader"
    HEALBOT_WORD_VERSION                    = "Version"
    HEALBOT_WORD_CLIENT                     = "Client"
    HEALBOT_WORD_ADDON                      = "Addon"
    HEALBOT_INFO_CPUSECS                    = "CPU Secs"
    HEALBOT_INFO_MEMORYMB                   = "Memory MB"
    HEALBOT_INFO_COMMS                      = "Comms KB"

    HEALBOT_WORD_STAR                       = "Star"
    HEALBOT_WORD_CIRCLE                     = "Circle"
    HEALBOT_WORD_DIAMOND                    = "Diamond"
    HEALBOT_WORD_TRIANGLE                   = "Triangle"
    HEALBOT_WORD_MOON                       = "Moon"
    HEALBOT_WORD_SQUARE                     = "Square"
    HEALBOT_WORD_CROSS                      = "Cross"
    HEALBOT_WORD_SKULL                      = "Skull"

    HEALBOT_OPTIONS_ACCEPTSKINMSG           = "Accept [HealBot] Skin: "
    HEALBOT_OPTIONS_ACCEPTSKINMSGFROM       = " from "
    HEALBOT_OPTIONS_BUTTONSHARESKIN         = "Share with"

    HEALBOT_CHAT_ADDONID                    = "[HealBot]  "
    HEALBOT_CHAT_NEWVERSION1                = "A newer version is available"
    HEALBOT_CHAT_NEWVERSION2                = "at "..HEALBOT_ABOUT_URL
    HEALBOT_CHAT_SHARESKINERR1              = " Skin not found for Sharing"
    HEALBOT_CHAT_SHARESKINERR3              = " not found for Skin Sharing"
    HEALBOT_CHAT_SHARESKINACPT              = "Share Skin accepted from "
    HEALBOT_CHAT_CONFIRMSKINDEFAULTS        = "Skins set to Defaults"
    HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS      = "Custom Debuffs reset"
    HEALBOT_CHAT_CHANGESKINERR1             = "Unknown skin: /hb skin "
    HEALBOT_CHAT_CHANGESKINERR2             = "Valid skins:  "
    HEALBOT_CHAT_CONFIRMSPELLCOPY           = "Current spells copied for all specs"
    HEALBOT_CHAT_UNKNOWNCMD                 = "Unknown slash command: /hb "
    HEALBOT_CHAT_ENABLED                    = "Entering enabled state"
    HEALBOT_CHAT_DISABLED                   = "Entering disabled state"
    HEALBOT_CHAT_SOFTRELOAD                 = "Reload healbot requested"
    HEALBOT_CHAT_HARDRELOAD                 = "Reload UI requested"
    HEALBOT_CHAT_CONFIRMSPELLRESET          = "Spells have been reset"
    HEALBOT_CHAT_CONFIRMCURESRESET          = "Cures have been reset"
    HEALBOT_CHAT_CONFIRMBUFFSRESET          = "Buffs have been reset"
    HEALBOT_CHAT_POSSIBLEMISSINGMEDIA       = "Unable to receive all Skin settings - Possibly missing SharedMedia, download from curse.com"
    HEALBOT_CHAT_MACROSOUNDON               = "Sound not suppressed when using auto trinkets"
    HEALBOT_CHAT_MACROSOUNDOFF              = "Sound suppressed when using auto trinkets"
    HEALBOT_CHAT_MACROERRORON               = "Errors not suppressed when using auto trinkets"
    HEALBOT_CHAT_MACROERROROFF              = "Errors suppressed when using auto trinkets"
    HEALBOT_CHAT_ACCEPTSKINON               = "Share Skin - Show accept skin popup when someone shares a skin with you"
    HEALBOT_CHAT_ACCEPTSKINOFF              = "Share Skin - Always ignore share skins from everyone"
    HEALBOT_CHAT_USE10ON                    = "Auto Trinket - Use10 is on - You must enable an existing auto trinket for use10 to work"
    HEALBOT_CHAT_USE10OFF                   = "Auto Trinket - Use10 is off"
    HEALBOT_CHAT_SKINREC                    = " skin received from " 

    HEALBOT_OPTIONS_SELFCASTS               = "Self casts only"
    HEALBOT_OPTIONS_HOTSHOWICON             = "Show icon"
    HEALBOT_OPTIONS_ALLSPELLS               = "All spells"
    HEALBOT_OPTIONS_DOUBLEROW               = "Double row"
    HEALBOT_OPTIONS_HOTBELOWBAR             = "Below bar"
    HEALBOT_OPTIONS_OTHERSPELLS             = "Other spells"
    HEALBOT_WORD_MACROS                     = "Macros"
    HEALBOT_WORD_SELECT                     = "Select"
    HEALBOT_OPTIONS_QUESTION                = "?"
    HEALBOT_WORD_CANCEL                     = "Cancel"
    HEALBOT_WORD_COMMANDS                   = "Commands"
    HEALBOT_OPTIONS_BARHEALTH3              = "as health";
    HEALBOT_SORTBY_ROLE                     = "Role"
    HEALBOT_WORD_DPS                        = "DPS"
    HEALBOT_CHAT_TOPROLEERR                 = " role not valid in this context - use 'TANK', 'DPS' or 'HEALER'"
    HEALBOT_CHAT_NEWTOPROLE                 = "Highest top role is now "
    HEALBOT_CHAT_SUBSORTPLAYER1             = "Player will be set to first in SubSort"
    HEALBOT_CHAT_SUBSORTPLAYER2             = "Player will be sorted normally in SubSort"
    HEALBOT_OPTIONS_SHOWREADYCHECK          = "Show Ready Check";
    HEALBOT_OPTIONS_SUBSORTSELFFIRST        = "Self First"
    HEALBOT_WORD_FILTER                     = "Filter"
    HEALBOT_OPTION_AGGROPCTBAR              = "Move bar"
    HEALBOT_OPTION_AGGROPCTTXT              = "Show text"
    HEALBOT_OPTION_AGGROPCTTRACK            = "Track percentage" 
    HEALBOT_OPTIONS_ALERTAGGROLEVEL1        = "1 - Low threat"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL2        = "2 - High threat"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL3        = "3 - Tanking"
    HEALBOT_OPTIONS_AGGROALERT              = "Bar alert level"
    HEALBOT_OPTIONS_AGGROINDALERT           = "Indicator alert level"
    HEALBOT_OPTIONS_TOOLTIPSHOWHOT          = "Show active monitored HoT details"
    HEALBOT_WORDS_MIN                       = "min"
    HEALBOT_WORDS_MAX                       = "max"
    HEALBOT_CHAT_SELFPETSON                 = "Self Pet switched on"
    HEALBOT_CHAT_SELFPETSOFF                = "Self Pet switched off"
    HEALBOT_WORD_PRIORITY                   = "Priority"
    HEALBOT_VISIBLE_RANGE                   = "Within 100 yards"
    HEALBOT_SPELL_RANGE                     = "Within spell range"
    HEALBOT_WORD_RESET                      = "Reset"
    HEALBOT_HBMENU                          = "HBmenu"
    HEALBOT_ACTION_HBFOCUS                  = "Left click to set\nfocus on target"
    HEALBOT_WORD_CLEAR                      = "Clear"
    HEALBOT_WORD_SET                        = "Set"
    HEALBOT_WORD_HBFOCUS                    = "HealBot Focus"
    HEALBOT_WORD_OUTSIDE                    = "Outside"
    HEALBOT_WORD_ALLZONE                    = "All zones"
    HEALBOT_OPTIONS_TAB_ALERT               = "Alert"
    HEALBOT_OPTIONS_TAB_SORT                = "Sort"
    HEALBOT_OPTIONS_TAB_HIDE                = "Hide"
    HEALBOT_OPTIONS_TAB_AGGRO               = "Aggro"
    HEALBOT_OPTIONS_TAB_ICONTEXT            = "Icon text"
    HEALBOT_OPTIONS_TAB_TEXT                = "Bar text"
    HEALBOT_OPTIONS_AGGRO3COL               = "Aggro bar\ncol"..HEALBOT_enWORD_COLOUR_SUFFIX
    HEALBOT_OPTIONS_AGGROFLASHFREQ          = "Flash frequency"
    HEALBOT_OPTIONS_AGGROFLASHALPHA         = "Flash opacity"
    HEALBOT_OPTIONS_SHOWDURATIONFROM        = "Show duration from"
    HEALBOT_OPTIONS_SHOWDURATIONWARN        = "Duration warning from"
    HEALBOT_CMD_RESETCUSTOMDEBUFFS          = "Reset custom debuffs"
    HEALBOT_CMD_RESETSKINS                  = "Reset skins"
    HEALBOT_CMD_CLEARBLACKLIST              = "Clear BlackList"
    HEALBOT_CMD_TOGGLEACCEPTSKINS           = "Toggle accept Skins from others"
    HEALBOT_CMD_TOGGLEDISLIKEMOUNT          = "Toggle Dislike Mount"
    HEALBOT_OPTION_DISLIKEMOUNT_ON          = "Now Dislike Mount"
    HEALBOT_OPTION_DISLIKEMOUNT_OFF         = "No longer Dislike Mount"
    HEALBOT_CMD_COPYSPELLS                  = "Copy current spells to all specs"
    HEALBOT_CMD_RESETSPELLS                 = "Reset spells"
    HEALBOT_CMD_RESETCURES                  = "Reset cures"
    HEALBOT_CMD_RESETBUFFS                  = "Reset buffs"
    HEALBOT_CMD_RESETBARS                   = "Reset bar position"
    HEALBOT_CMD_SUPPRESSSOUND               = "Toggle suppress sound when using auto trinkets"
    HEALBOT_CMD_SUPPRESSERRORS              = "Toggle suppress errors when using auto trinkets"
    HEALBOT_OPTIONS_COMMANDS                = "HealBot Commands"
    HEALBOT_WORD_RUN                        = "Run"
    HEALBOT_OPTIONS_MOUSEWHEEL              = "Use mouse wheel"
    HEALBOT_OPTIONS_MOUSEUP                 = "Wheel up"
    HEALBOT_OPTIONS_MOUSEDOWN               = "Wheel down"
    HEALBOT_CMD_DELCUSTOMDEBUFF10           = "Delete custom debuffs on priority 10"
    HEALBOT_ACCEPTSKINS                     = "Accept Skins from others"
    HEALBOT_SUPPRESSSOUND                   = "Auto Trinket: Suppress sound"
    HEALBOT_SUPPRESSERROR                   = "Auto Trinket: Suppress errors"
    HEALBOT_OPTIONS_CRASHPROT               = "Crash Protection"
    HEALBOT_CP_MACRO_LEN                    = "Macro name must be between 1 and 14 characters"
    HEALBOT_CP_MACRO_BASE                   = "Base macro name"
    HEALBOT_CP_MACRO_SAVE                   = "Last saved at: "
    HEALBOT_CP_STARTTIME                    = "Protect duration on logon"
    HEALBOT_WORD_RESERVED                   = "Reserved"
    HEALBOT_OPTIONS_COMBATPROT              = "Combat Protection"
    HEALBOT_COMBATPROT_PARTYNO              = "bars Reserved for Party"
    HEALBOT_COMBATPROT_RAIDNO               = "bars Reserved for Raid"

    HEALBOT_WORD_HEALTH                     = "Health"
    HEALBOT_OPTIONS_DONT_SHOW               = "Don't show"
    HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT    = "Same as health (current health)"
    HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE     = "Same as health (future health)"
    HEALBOT_OPTIONS_FUTURE_HLTH             = "Future health"
    HEALBOT_SKIN_HEALTHBARCOL_TEXT          = "Health bar";
    HEALBOT_SKIN_HEALTHBACKCOL_TEXT         = "Background bar";
    HEALBOT_SKIN_INCHEALBARCOL_TEXT         = "Incoming heals";
    HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET      = "Target: Always show"
    HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS       = "Focus: Always show"
    HEALBOT_OPTIONS_GROUP_PETS_BY_FIVE      = "Pets: Groups of five"
    HEALBOT_OPTIONS_USEGAMETOOLTIP          = "Use Game Tooltip"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER        = "Show power counter"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA   = "Show holy power"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_MONK   = "Show chi power"
    HEALBOT_OPTIONS_CUSTOMDEBUFF_REVDUR     = "Reverse Duration"
    HEALBOT_OPTIONS_DISABLEHEALBOTSOLO      = "only when solo"
    HEALBOT_OPTIONS_CUSTOM_ALLDISEASE       = "All Disease"
    HEALBOT_OPTIONS_CUSTOM_ALLMAGIC         = "All Magic"
    HEALBOT_OPTIONS_CUSTOM_ALLCURSE         = "All Curse"
    HEALBOT_OPTIONS_CUSTOM_ALLPOISON        = "All Poison"
    HEALBOT_OPTIONS_CUSTOM_CASTBY           = "Cast By"

    HEALBOT_BLIZZARD_MENU                   = "Blizzard menu"
    HEALBOT_HB_MENU                         = "Healbot menu"
    HEALBOT_FOLLOW                          = "Follow"
    HEALBOT_TRADE                           = "Trade"
    HEALBOT_PROMOTE_RA                      = "Promote raid assistant"
    HEALBOT_DEMOTE_RA                       = "Demote raid assistant"
    HEALBOT_TOGGLE_ENABLED                  = "Toggle enabled"
    HEALBOT_TOGGLE_MYTARGETS                = "Toggle My Targets"
    HEALBOT_TOGGLE_PRIVATETANKS             = "Toggle private tanks"
    HEALBOT_RESET_BAR                       = "Reset bar"
    HEALBOT_HIDE_BARS                       = "Hide bars over 100 yards"
    HEALBOT_RANDOMMOUNT                     = "Random Mount"
    HEALBOT_RANDOMGOUNDMOUNT                = "Random Ground Mount"
    HEALBOT_RANDOMPET                       = "Random Pet"
    HEALBOT_ZONE_AQ40                       = "Ahn'Qiraj"
    HEALBOT_ZONE_VASHJIR1                   = "Kelp'thar Forest"
    HEALBOT_ZONE_VASHJIR2                   = "Shimmering Expanse"
    HEALBOT_ZONE_VASHJIR3                   = "Abyssal Depths"
    HEALBOT_ZONE_VASHJIR                    = "Vashj'ir"
    HEALBOT_RESLAG_INDICATOR                = "Keep name green after res set to" 
    HEALBOT_RESLAG_INDICATOR_ERROR          = "Keep name green after res must be between 1 and 30" 
    HEALBOT_FRAMELOCK_BYPASS_OFF            = "Frame lock bypass turned Off"
    HEALBOT_FRAMELOCK_BYPASS_ON             = "Frame lock bypass (Ctl+Alt+Left) turned On"
    HEALBOT_RESTRICTTARGETBAR_ON            = "Restrict Target bar turned On"
    HEALBOT_RESTRICTTARGETBAR_OFF           = "Restrict Target bar turned Off"
    HEALBOT_PRELOADOPTIONS_ON               = "PreLoad Options turned On"
    HEALBOT_PRELOADOPTIONS_OFF              = "PreLoad Options turned Off"
    HEALBOT_AGGRO2_ERROR_MSG                = "To set aggro level 2, threat percentage must be between 25 and 95"
    HEALBOT_AGGRO3_ERROR_MSG                = "To set aggro level 3, threat percentage must be between 75 and 100"
    HEALBOT_AGGRO2_SET_MSG                  = "Aggro level 2 set at threat percentage "
    HEALBOT_AGGRO3_SET_MSG                  = "Aggro level 3 set at threat percentage "
    HEALBOT_WORD_THREAT                     = "Threat"
    HEALBOT_AGGRO_ERROR_MSG                 = "Invalid aggro level - use 2 or 3"

    HEALBOT_OPTIONS_QUERYTALENTS            = "Query talent data"       
    HEALBOT_OPTIONS_LOWMANAINDICATOR        = "Low Mana indicator"
    HEALBOT_OPTIONS_LOWMANAINDICATOR1       = "Don't show"
    HEALBOT_OPTIONS_LOWMANAINDICATOR2       = "*10% / **20% / ***30%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR3       = "*15% / **30% / ***45%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR4       = "*20% / **40% / ***60%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR5       = "*25% / **50% / ***75%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR6       = "*30% / **60% / ***90%"

    HEALBOT_OPTION_IGNORE_AURA_RESTED       = "Ignore aura events when resting"

    HEALBOT_WORD_ENABLE                     = "Enable"
    HEALBOT_WORD_DISABLE                    = "Disable"

    HEALBOT_OPTIONS_MYCLASS                 = "My Class"

    HEALBOT_OPTIONS_CONTENT_ABOUT           = "        About"
    HEALBOT_OPTIONS_CONTENT_GENERAL         = "        " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SPELLS          = "        " .. HEALBOT_OPTIONS_TAB_SPELLS
    HEALBOT_OPTIONS_CONTENT_SKINS           = "        " .. HEALBOT_OPTIONS_TAB_SKIN
    HEALBOT_OPTIONS_CONTENT_CURE            = "        " .. HEALBOT_OPTIONS_TAB_CDC
    HEALBOT_OPTIONS_CONTENT_BUFFS           = "        " .. HEALBOT_OPTIONS_TAB_BUFFS
    HEALBOT_OPTIONS_CONTENT_TIPS            = "        " .. HEALBOT_OPTIONS_TAB_TIPS
    HEALBOT_OPTIONS_CONTENT_MOUSEWHEEL      = "        Mouse Wheel"
    HEALBOT_OPTIONS_CONTENT_TEST            = "        Test"
    HEALBOT_OPTIONS_CONTENT_USAGE           = "        Usage"
    HEALBOT_OPTIONS_REFRESH                 = "Refresh"

    HEALBOT_CUSTOM_CATEGORY                 = "Category"
    HEALBOT_CUSTOM_CAT_CUSTOM               = "Custom"
    HEALBOT_CUSTOM_CAT_02                   = "A - B" 
    HEALBOT_CUSTOM_CAT_03                   = "C - D"
    HEALBOT_CUSTOM_CAT_04                   = "E - F"
    HEALBOT_CUSTOM_CAT_05                   = "G - H"
    HEALBOT_CUSTOM_CAT_06                   = "I - J"
    HEALBOT_CUSTOM_CAT_07                   = "K - L"
    HEALBOT_CUSTOM_CAT_08                   = "M - N"
    HEALBOT_CUSTOM_CAT_09                   = "O - P"
    HEALBOT_CUSTOM_CAT_10                   = "Q - R"
    HEALBOT_CUSTOM_CAT_11                   = "S - T"
    HEALBOT_CUSTOM_CAT_12                   = "U - V"
    HEALBOT_CUSTOM_CAT_13                   = "W - X"
    HEALBOT_CUSTOM_CAT_14                   = "Y - Z"

    HEALBOT_CUSTOM_CASTBY_EVERYONE          = "Everyone"
    HEALBOT_CUSTOM_CASTBY_ENEMY             = "Enemy"
    HEALBOT_CUSTOM_CASTBY_FRIEND            = "Friend"

    HEALBOT_CUSTOM_DEBUFF_CATS = {
            [HEALBOT_DEBUFF_ACID_DRENCHED_MANDIBLES] = 2,
            [HEALBOT_DEBUFF_AGONIZING_FLAMES]      = 2,
            [HEALBOT_DEBUFF_BOILING_BLOOD]         = 2,
            [HEALBOT_DEBUFF_BURN]                  = 2,
            [HEALBOT_DEBUFF_BURNING_BILE]          = 2,
            [HEALBOT_DEBUFF_CHILLED_BONE]          = 3,
            [HEALBOT_DEBUFF_COMBUSTION]            = 3,
            [HEALBOT_DEBUFF_CONFLAGRATION]         = 3,
            [HEALBOT_DEBUFF_CONSUMING_FLAMES]      = 3,
            [HEALBOT_DEBUFF_CONSUMPTION]           = 3,
            [HEALBOT_DEBUFF_CORROSION]             = 3,
            [HEALBOT_DEBUFF_DARK_BARRAGE]          = 3,
            [HEALBOT_DEBUFF_DEFILE]                = 3,
            [HEALBOT_DEBUFF_DELIRIOUS_SLASH]       = 3,
            [HEALBOT_DEBUFF_DOOMFIRE]              = 3,
            [HEALBOT_DEBUFF_ENCAPSULATE]           = 4,
            [HEALBOT_DEBUFF_ESSENCE_BLOOD_QUEEN]   = 4,
            [HEALBOT_DEBUFF_EXPLOSIVE_CINDERS]     = 4,
            [HEALBOT_DEBUFF_EXPOSE_WEAKNESS]       = 4,
            [HEALBOT_DEBUFF_FATAL_ATTRACTION]      = 4,
            [HEALBOT_DEBUFF_FEL_RAGE]              = 4,
            [HEALBOT_DEBUFF_FEL_RAGE2]             = 4,
            [HEALBOT_DEBUFF_FERAL_POUNCE]          = 4, 
            [HEALBOT_DEBUFF_FIERY_COMBUSTION]      = 4,
            [HEALBOT_DEBUFF_FIRE_BLOOM]            = 4,
            [HEALBOT_DEBUFF_FIRE_BOMB]             = 4,
            [HEALBOT_DEBUFF_FLAME_SEAR]            = 4, 
            [HEALBOT_DEBUFF_FLASH_FREEZE]          = 4,
            [HEALBOT_DEBUFF_FROST_BEACON]          = 4,
            [HEALBOT_DEBUFF_FROST_BLAST]           = 4,
            [HEALBOT_DEBUFF_FROST_BREATH]          = 4,
            [HEALBOT_DEBUFF_FROST_TOMB]            = 4,
            [HEALBOT_DEBUFF_GAS_SPORE]             = 5,
            [HEALBOT_DEBUFF_GASEOUS_BLOAT]         = 5,
            [HEALBOT_DEBUFF_GASTRIC_BLOAT]         = 5,
            [HEALBOT_DEBUFF_GLITTERING_SPARKS]     = 5,
            [HEALBOT_DEBUFF_GRAVITY_BOMB]          = 5,
            [HEALBOT_DEBUFF_GRAVITY_CORE]          = 5,
            [HEALBOT_DEBUFF_GRAVITY_CRUSH]         = 5,
            [HEALBOT_DEBUFF_GRIEVOUS_BITE]         = 5,         
            [HEALBOT_DEBUFF_GRIEVOUS_THROW]        = 5,
            [HEALBOT_DEBUFF_GUT_SPRAY]             = 5,
            [HEALBOT_DEBUFF_HARVEST_SOUL]          = 5,
            [HEALBOT_DEBUFF_ICEBOLT]               = 6,
            [HEALBOT_DEBUFF_ICE_TOMB]              = 6,
            [HEALBOT_DEBUFF_IMPALE]                = 6,
            [HEALBOT_DEBUFF_IMPALED]               = 6,
            [HEALBOT_DEBUFF_IMPALING_SPINE]        = 6,
            [HEALBOT_DEBUFF_INCINERATE_FLESH]      = 6,
            [HEALBOT_DEBUFF_INFEST]                = 6,
            [HEALBOT_DEBUFF_INSTABILITY]           = 6,
            [HEALBOT_DEBUFF_IRON_ROOTS]            = 6,
            [HEALBOT_DEBUFF_JAGGED_KNIFE]          = 6, 
            [HEALBOT_DEBUFF_LEGION_FLAME]          = 7, 
            [HEALBOT_DEBUFF_LIGHTNING_ROD]         = 7,
            [HEALBOT_DEBUFF_FALLEN_CHAMPION]       = 8,
            [HEALBOT_DEBUFF_MISTRESS_KISS]         = 8,
            [HEALBOT_DEBUFF_MUTATED_INFECTION]     = 8,
            [HEALBOT_DEBUFF_MUTATED_PLAGUE]        = 8,
            [HEALBOT_DEBUFF_MYSTIC_BUFFET]         = 8,
            [HEALBOT_DEBUFF_NAPALM_SHELL]          = 8,
            [HEALBOT_DEBUFF_NECROTIC_PLAGUE]       = 8,
            [HEALBOT_DEBUFF_NECROTIC_STRIKE]       = 8,
            [HEALBOT_DEBUFF_PACT_DARKFALLEN]       = 9,
            [HEALBOT_DEBUFF_PARALYTIC_TOXIN]       = 9,
            [HEALBOT_DEBUFF_PARASITIC_INFECT]      = 9,
            [HEALBOT_DEBUFF_PARASITIC_SHADOWFIEND] = 9,
            [HEALBOT_DEBUFF_PENETRATING_COLD]      = 9,
            [HEALBOT_DEBUFF_RUNE_OF_BLOOD]         = 10,
            [HEALBOT_DEBUFF_SACRIFICE]             = 11,
            [HEALBOT_DEBUFF_SARA_BLESSING]         = 11,
            [HEALBOT_DEBUFF_SHADOW_PRISON]         = 11,
            [HEALBOT_DEBUFF_SLAG_POT]              = 11,
            [HEALBOT_DEBUFF_SNOBOLLED]             = 11,
            [HEALBOT_DEBUFF_SOUL_CONSUMPTION]      = 11,
            [HEALBOT_DEBUFF_SPINNING_PAIN_SPIKE]   = 11,
            [HEALBOT_DEBUFF_STONE_GRIP]            = 11,
            [HEALBOT_DEBUFF_SWARMING_SHADOWS]      = 11,
            [HEALBOT_DEBUFF_TOUCH_OF_DARKNESS]     = 11,
            [HEALBOT_DEBUFF_TOUCH_OF_LIGHT]        = 11,
            [HEALBOT_DEBUFF_TOXIC_SPORES]          = 11,
            [HEALBOT_DEBUFF_VILE_GAS]              = 12,
            [HEALBOT_DEBUFF_VOLATILE_OOZE]         = 12,
            [HEALBOT_DEBUFF_WATERLOGGED]           = 13,
            [HEALBOT_DEBUFF_WEB_WRAP]              = 13,
        }

    HEALBOT_ABOUT_DESC1                    = "Add a panel with skinable bars for healing, decursive, buffing, ressing and aggro tracking"
    HEALBOT_ABOUT_WEBSITE                  = "Website:"
    HEALBOT_ABOUT_AUTHORH                  = "Author:"
    HEALBOT_ABOUT_AUTHORD                  = "Strife"
    HEALBOT_ABOUT_EMAILH                   = "Email:"
    HEALBOT_ABOUT_EMAILD                   = "healbot@outlook.com"
    HEALBOT_ABOUT_CATH                     = "Category:"
    HEALBOT_ABOUT_CATD                     = "Unit Frames, Buffs and Debuffs, Combat:Healer"
    HEALBOT_ABOUT_CREDITH                  = "Credits:"
    HEALBOT_ABOUT_CREDITD                  = "Acirac, Kubik, Ayngel, StingerSoft, SayClub"  -- Anyone taking on translations (if required), feel free to add yourself here.
    HEALBOT_ABOUT_LOCALH                   = "Localizations:"
    HEALBOT_ABOUT_LOCALD                   = "deDE, enUK, esES, frFR, huHU, koKR, ruRU, zhCN, zhTW"
    HEALBOT_ABOUT_FAQH                     = "Frequently Asked Questions"
    HEALBOT_ABOUT_FAQ_QUESTION             = "Question"
    HEALBOT_ABOUT_FAQ_ANSWER               = "Answer"

    HEALBOT_ABOUT_FAQ_QUESTIONS = {   [1]   = "Buffs - All the bars are White, what happened",
                                      [2]   = "Casting - Sometimes the cursor turns blue and I can't do anything",
                                      [3]   = "Macros - Do you have any cooldown examples",
                                      [4]   = "Macros - Do you have any spell casting examples",
                                      [5]   = "Mouse - How do I use my mouseover macros with the mouse wheel",
                                      [6]   = "Options - Can bars be sorted by groups, for example have 2 groups per column",
                                      [7]   = "Options - Can I hide all the bars and only show those needing a debuff removed",
                                      [8]   = "Options - Can I hide the incoming heals",
                                      [9]   = "Options - Healbot does not save my options when i logout/logon",
                                      [10]   = "Options - How do I always use enabled settings",
                                      [11]  = "Options - How do I disable healbot automatically",
                                      [12]  = "Options - How do I make the bars grow a different direction",
                                      [13]  = "Options - How do I setup 'My Targets'",
                                      [14]  = "Options - How do I setup 'Private Tanks'",
                                      [15]  = "Options - Will Healbot create a bar for an NPC",
                                      [16]  = "Range - I can't see when people are out of range, how do I fix this",
                                      [17]  = "Spells - Healbot casts a different spell to my setup",
                                      [18]  = "Spells - I can no longer cast heals on unwounded targets",
                                  }

    HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01       = "This is due to options set on the Spells tab \n" ..
                                              "try changing the following and testing: \n\n" ..
                                              "     1: On the spells tab: Turn on Always Use Enabled \n" ..
                                              "     2: On the spells tab: Turn off SmartCast \n\n" ..
                                              "Note: It is expected that most users will want to \n"..
                                              "          turn SmartCast back on \n\n" ..
                                              "Note: It is expected that experienced users will want to \n" ..
                                              "          turn off Always Use Enabled  \n" ..
                                              "          and set the spells for disabled bars"
                                              
    HEALBOT_ABOUT_FAQ_ANSWERS = {     [1]   = "You are monitoring for missing buffs \n\n" .. 
                                              "This can be turned off on the buffs tab \n" ..
                                              "Alternatively click on the bar and cast the buff",
                                      [2]   = "This is blizzard functionality, not Healbot \n\n" .. 
                                              "Using the standard blizzard frames, \n" ..
                                              "try casting a spell thats on Cooldown \n" ..
                                              "Notice how the cursor turns blue. \n\n" ..
                                              "Note: Nothing can be done to prevent this while \n" ..
                                              "in combat, since WoW 2.0 Blizzard has locked down \n" ..
                                              "the ui while in combat stopping all addons from \n" ..
                                              "changing spells or targets from what has been predefined \n\n" ..
                                              "It may help to monitor the spell cooldown in the tooltips",
                                      [3]   = "Yes \n\n"..
                                              "Paladin Hand of Salvation cooldown macro example: \n\n" ..
                                              "    #show Hand of Salvation \n" ..
                                              '    /script local n=UnitName("hbtarget"); ' .. "\n" ..
                                              '    if GetSpellCooldown("Hand of Salvation")==0 then ' .. " \n" ..
                                              '        SendChatMessage("Hand of Salvation on "..n,"YELL") ' .. "\n" ..
                                              '        SendChatMessage("Hand of Salvation!","WHISPER",nil,n) ' .. "\n" ..
                                              "    end; \n" ..
                                              "    /cast [@hbtarget] Hand of Salvation",
                                      [4]   = "Yes \n\n"..
                                              "Preist Flash Heal, example using both trinkets: \n\n" ..
                                              "    #show Flash Heal \n" ..
                                              "    /script UIErrorsFrame:Hide() \n" ..
                                              "    /console Sound_EnableSFX 0 \n" ..
                                              "    /use 13 \n" ..
                                              "    /use 14 \n" ..
                                              "    /console Sound_EnableSFX 1 \n" ..
                                              "    /cast [@hbtarget] Flash Heal \n" ..
                                              "    /script UIErrorsFrame:Clear(); UIErrorsFrame:Show()",
                                      [5]   = "1: On the Mouse Wheel tab: Turn off Use Mouse Wheel \n" ..
                                              "2: Bind your macros to blizzard's bindings with [@mouseover] \n\n\n" ..
                                              "Eample macro: \n\n" ..
                                              "    #showtooltip Flash Heal \n" ..
                                              "    /cast [@mouseover] Flash Heal \n",
                                      [6]   = "Yes \n\n\n"..
                                              "With Headers: \n" ..
                                              "     1: On the Skins>Headers tab, switch on Show Headers \n" ..
                                              "     2: On the Skins>Bars tab, set Number of Groups per column \n\n" ..
                                              "Without Headers: \n" ..
                                              "     1: On the Skins>Bars tab, switch on Use Groups per Column \n" ..
                                              "     2: On the Skins>Bars tab, set Number of Groups per column ",
                                      [7]   = "Yes \n\n"..
                                              "1: On the Skins>Healing>Alert tab, set Alert Level to 0 \n" ..
                                              "2: On the Skins>Aggro tab, turn off the Aggro Monitor \n" .. 
                                              "3: On the Skins>Bars tab, set Disabled opacity to 0 \n" ..
                                              "4: On the Skins>Bars tab, set Background opacity to 0 \n" ..
                                              "5: On the Skins>Bar Text tab, click on the bar Disabled \n" ..
                                              "     and set the Disabled text opacity to 0 \n" ..
                                              "6: On the Skins>General tab, click on the bar Background \n" ..
                                              "     and set the Background opacity to 0 \n" ..
                                              "7: On the Cure tab, Turn on debuff monitoring",
                                      [8]   = "Yes \n\n"..
                                              "1: On the Skins>Bars tab, set Incoming Heals to Dont Show \n" ..
                                              "2: On the Skins>Bar Text tab, \n" ..
                                              "          set Show Health on Bar to No Incoming Heals",
                                      [9]   = "This has been present since a change in WoW 3.2, \n" ..
                                              "it can affects characters with weird letters in their name \n\n" ..
                                              "If your on Vista or Win7, try the follow: \n"..
                                              "     change system locale to English (for non-unicode programs) \n" ..
                                              "     in Control Panel > Region and Language > Administrative Tab",

                                      [10]   = "On the spells tab turn on Always Use Enabled \n\n" ..
                                              "Some my also want to set the Alert Level to 100 \n" ..
                                              "This can be done on the Skins>Healing>Alert tab",
                                      [11]  = "Disable for a character: \n\n" ..
                                              "     1: Open the General tab \n" ..
                                              "     2: Turn on the Disable option \n\n\n" ..
                                              "Disable when solo: \n\n" ..
                                              "     1: Open the General tab \n" ..
                                              "     2: To the right of the Disable option, Select only when solo \n" ..
                                              "     3: Turn on the Disable option",
                                      [12]  = "Change the Bars Anchor setting on the Skins>General tab  \n\n" ..
                                              "     Top Right:        the bars will grow Down and Left \n" ..
                                              "     Top Left:          the bars will grow Down and Right \n" ..
                                              "     Bottom Right:  the bars will grow Up and Left \n" ..
                                              "     Bottom Left:     the bars will grow Up and Right",
                                      [13]  = "My Targets allows you to create a list of Targets you want to \n" ..
                                              "group separately from others, similar to the MT group \n\n" ..
                                              "The following options are available for \n" .. 
                                              "adding/removing people to/from the My Targets group \n\n" ..
                                              "     - Shift+Ctrl+Alt+Right click on the bar \n" ..
                                              '     - Use the Healbot Menu, enter "hbmenu" on the spells tab ' .. "\n" ..
                                              "     - Use the Mouse Wheel, set on the Mouse Wheel tab",
                                      [14]  = "Private Tanks can be added to the Main Tanks list, \n" ..
                                              "the Private tanks are only visible in your Healbot \n" ..
                                              "and do not affect other players or addons \n\n" ..
                                              "The following options are available for \n" ..
                                              "adding/removing people to/from the Tanks list \n\n" ..
                                              '     - Use the Healbot Menu, enter "hbmenu" on the spells tab ' .. "\n" ..
                                              "     - Use the Mouse Wheel, set on the Mouse Wheel tab",
                                      
                                      [15]  = "Yes \n\n"..
                                              "     1: On the Skins>Healing tab, turn on Focus \n" ..
                                              "     2: set your focus on the NPC (or PC not in raid/party) \n" ..
                                              "          Healbot will create a bar in your My Targets list \n\n" ..
                                              "Note: If in a combat situation where you zone in and out while \n" ..
                                              "          in combat and need to reset focus on an NPC \n" ..
                                              "          on the Skins>Healing tab set Focus: always show to on \n" ..
                                              "          This will keep the bar available during combat. \n\n" ..
                                              "Note: The HealBot Menu has the option 'Set HealBot Focus' \n" ..
                                              "          This can make setting focus easy on NPC's and \n" ..
                                              "          serves as a reminder to set focus. \n\n" ..
                                              "          Enter 'hbmenu' on the spells tab to use HealBot Menu \n" ..
                                              "          or use the Mouse Wheel tab to and set HealBot Menu",
                                      [16]  = "1:  On the Skins>Bars tab, adjust the disabled bar opacity \n" ..
                                              "2:  On the Skins>Bars Text tab, adjust the disabled text opacity \n" ..
                                              "       To do this click on the bar labeled Disabled. \n\n" ..
                                              "Some my also want to set the Alert Level to 100 \n" ..
                                              "This can be done on the Skins>Healing>Alert tab",
                                      [17]  = "Actually Healbot is casting exacly as the setup. \n\n" .. HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                      [18]  = HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                  }

    HEALBOT_OPTIONS_SKINAUTHOR              = "Skin Author:"
    HEALBOT_OPTIONS_AVOIDBLUECURSOR         = "Avoid\nBlue Cursor"
    HEALBOT_PLAYER_OF_REALM                 = "of"
    
    HEALBOT_OPTIONS_LANG                    = "Language"
    HEALBOT_OPTIONS_LANG_ZHCN               = "Chinese (zhCN - translator required)"
    HEALBOT_OPTIONS_LANG_DEDE               = "German (deDE - translator required)"
    HEALBOT_OPTIONS_LANG_ENUK               = "English (enUK - by Strife)"
    HEALBOT_OPTIONS_LANG_ENUS               = "English (enUS - by Strife)"
    HEALBOT_OPTIONS_LANG_ESES               = "Spanish (esES - translator required)"
    HEALBOT_OPTIONS_LANG_FRFR               = "French (frFR - by Kubik)"
    HEALBOT_OPTIONS_LANG_HUHU               = "Hungarian (huHU - by Von)"
    HEALBOT_OPTIONS_LANG_KRKR               = "Korean (krKR - translator required)"
    HEALBOT_OPTIONS_LANG_RURU               = "Russian (ruRU - translator required)"
    HEALBOT_OPTIONS_LANG_TWTW               = "Taiwanese (twTW - translator required)"
    
    HEALBOT_OPTIONS_LANG_ADDON_FAIL1        = "Failed to load addon for localization"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL2        = "Reason for failure is:"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL3        = "Obtain the latest localization addons from:"
end

if (GetLocale() == "enUK") then
    HealBot_Lang_enUK()
else
    HealBot_Lang_enUS()
end