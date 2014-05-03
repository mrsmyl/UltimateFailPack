﻿-- Italian maintained by Brezza on Nemesis-EU.

-------------
-- ITALIAN --
-------------
--
-- Alcuni termini e acronimi non sono stati tradotti perchè acquisiti come uso comune anche in italiano (ad esempio aggro, dps, buff, skin, in alcuni casi spell...)
-- oppure per motivi di spazio delle varie finestre dell'addon. Se trovate bug o avete suggerimenti non esitate a scrivermi via PM su www.healbot.info
--
-- Some words and acronyms haven't been translated because by now acquired as common use in italian (eg. aggro, dps, buff, skin, in some cases spell...)
-- or due to limited space in the addon's windows. For bugs and hints don't hesitate to contact me via PM on www.healbot.info
--
--
--




function HealBot_Lang_itIT()

    -----------------
    -- Translation --
    -----------------

    -- Class
    HEALBOT_DRUID                           = "Druido";
    HEALBOT_HUNTER                          = "Cacciatore";
    HEALBOT_MAGE                            = "Mago";
    HEALBOT_PALADIN                         = "Paladino";
    HEALBOT_PRIEST                          = "Sacerdote";
    HEALBOT_ROGUE                           = "Ladro";
    HEALBOT_SHAMAN                          = "Sciamano";
    HEALBOT_WARLOCK                         = "Stregone";
    HEALBOT_WARRIOR                         = "Guerriero";
    HEALBOT_DEATHKNIGHT                     = "Cavaliere della Morte";
    HEALBOT_MONK                            = "Monaco";

    HEALBOT_DISEASE                         = "Malattia";
    HEALBOT_MAGIC                           = "Magia";
    HEALBOT_CURSE                           = "Maledizione";
    HEALBOT_POISON                          = "Veleno";

    HB_TOOLTIP_OFFLINE                      = "Offline";
    HB_OFFLINE                              = "offline"; -- has gone offline msg
    HB_ONLINE                               = "online"; -- has come online msg

    HEALBOT_HEALBOT                         = "HealBot";
    HEALBOT_ADDON                           = HEALBOT_HEALBOT .. " " .. HEALBOT_VERSION;
    HEALBOT_LOADED                          = " caricato.";

    HEALBOT_ACTION_OPTIONS                  = "Opzioni";

    HEALBOT_OPTIONS_TITLE                   = HEALBOT_ADDON;
    HEALBOT_OPTIONS_DEFAULTS                = "Predefinite";
    HEALBOT_OPTIONS_CLOSE                   = "Chiudi";
    HEALBOT_OPTIONS_HARDRESET               = "RicaricaUI"
    HEALBOT_OPTIONS_SOFTRESET               = "ResettaHB"
    HEALBOT_OPTIONS_TAB_GENERAL             = "Generale";
    HEALBOT_OPTIONS_TAB_SPELLS              = "Incantesimi";
    HEALBOT_OPTIONS_TAB_HEALING             = "Cure";
    HEALBOT_OPTIONS_TAB_CDC                 = "Dissoluzioni";
    HEALBOT_OPTIONS_TAB_SKIN                = "Skins";
    HEALBOT_OPTIONS_TAB_TIPS                = "Tooltips";
    HEALBOT_OPTIONS_TAB_BUFFS               = "Buffs";

    HEALBOT_OPTIONS_BARALPHA                = "Opacità abilitato";
    HEALBOT_OPTIONS_BARALPHAINHEAL          = "Opacità cure ricevute";
    HEALBOT_OPTIONS_BARALPHABACK            = "Opacità sfondo barre";
    HEALBOT_OPTIONS_BARALPHAEOR             = "Opacità fuori range";
    HEALBOT_OPTIONS_ACTIONLOCKED            = "Blocca in posizione";
    HEALBOT_OPTIONS_AUTOSHOW                = "Chiudi automaticamente";
    HEALBOT_OPTIONS_PANELSOUNDS             = "Riproduci suono all'apertura";
    HEALBOT_OPTIONS_HIDEOPTIONS             = "Nascondi pulsante Opzioni";
    HEALBOT_OPTIONS_PROTECTPVP              = "Previeni attivazione PvP";
    HEALBOT_OPTIONS_HEAL_CHATOPT            = "Opzioni della Chat";

    HEALBOT_OPTIONS_FRAMESCALE              = "Dimensione frame"
    HEALBOT_OPTIONS_SKINTEXT                = "Usa skin"
    HEALBOT_SKINS_STD                       = "Standard"
    HEALBOT_OPTIONS_SKINTEXTURE             = "Texture"
    HEALBOT_OPTIONS_SKINHEIGHT              = "Altezza"
    HEALBOT_OPTIONS_SKINWIDTH               = "Larghezza"
    HEALBOT_OPTIONS_SKINNUMCOLS             = "Nr. colonne"
    HEALBOT_OPTIONS_SKINNUMHCOLS            = "Nr. gruppi per colonna"
    HEALBOT_OPTIONS_SKINBRSPACE             = "Spaziatura righe"
    HEALBOT_OPTIONS_SKINBCSPACE             = "Spaziatura colonne"
    HEALBOT_OPTIONS_EXTRASORT               = "Metodo Ordinamento barre in Incursione"
    HEALBOT_SORTBY_NAME                     = "Nome"
    HEALBOT_SORTBY_CLASS                    = "Classe"
    HEALBOT_SORTBY_GROUP                    = "Gruppo"
    HEALBOT_SORTBY_MAXHEALTH                = "Salute massima"
    HEALBOT_OPTIONS_NEWDEBUFFTEXT           = "Nuovo debuff"
    HEALBOT_OPTIONS_DELSKIN                 = "Cancella"
    HEALBOT_OPTIONS_NEWSKINTEXT             = "Nuova skin"
    HEALBOT_OPTIONS_SAVESKIN                = "Salva"
    HEALBOT_OPTIONS_SKINBARS                = "Opzioni barre"
    HEALBOT_SKIN_ENTEXT                     = "Abilitato"
    HEALBOT_SKIN_DISTEXT                    = "Disabilitato"
    HEALBOT_SKIN_DEBTEXT                    = "Debuff"
    HEALBOT_SKIN_BACKTEXT                   = "Sfondo"
    HEALBOT_SKIN_BORDERTEXT                 = "Bordo"
    HEALBOT_OPTIONS_SKINFONT                = "Font"
    HEALBOT_OPTIONS_SKINFHEIGHT             = "Dimensione font"
    HEALBOT_OPTIONS_SKINFOUTLINE            = "Font Outline"
    HEALBOT_OPTIONS_BARALPHADIS             = "Opacità disabilitato"
    HEALBOT_OPTIONS_SHOWHEADERS             = "Mostra intestazioni"

    HEALBOT_OPTIONS_ITEMS                   = "Oggetti";

    HEALBOT_OPTIONS_COMBOCLASS              = "Combinazione tasti per";
    HEALBOT_OPTIONS_CLICK                   = "Click";
    HEALBOT_OPTIONS_SHIFT                   = "Maiusc";
    HEALBOT_OPTIONS_CTRL                    = "Ctrl";
    HEALBOT_OPTIONS_ENABLEHEALTHY           = "Usa sempre barre abilitate";

    HEALBOT_OPTIONS_CASTNOTIFY1             = "Nessun messaggio";
    HEALBOT_OPTIONS_CASTNOTIFY2             = "Notifica a te stesso";
    HEALBOT_OPTIONS_CASTNOTIFY3             = "Notifica al bersaglio";
    HEALBOT_OPTIONS_CASTNOTIFY4             = "Notifica al gruppo";
    HEALBOT_OPTIONS_CASTNOTIFY5             = "Notifica all'incursione";
    HEALBOT_OPTIONS_CASTNOTIFY6             = "Notifica nel canale";
    HEALBOT_OPTIONS_CASTNOTIFYRESONLY       = "Notifica solo le resurrezioni";

    HEALBOT_OPTIONS_CDCBARS                 = "Colori barre";
    HEALBOT_OPTIONS_CDCSHOWHBARS            = "Cambia colore barra salute";
    HEALBOT_OPTIONS_CDCSHOWABARS            = "Cambia colore barra aggro";
    HEALBOT_OPTIONS_CDCWARNINGS             = "Avvisi debuff";
    HEALBOT_OPTIONS_SHOWDEBUFFICON          = "Mostra debuff";
    HEALBOT_OPTIONS_SHOWDEBUFFWARNING       = "Mostra avviso per debuff";
    HEALBOT_OPTIONS_SOUNDDEBUFFWARNING      = "Esegui effetto audio per debuff";
    HEALBOT_OPTIONS_SOUND                   = "Effetto audio"

    HEALBOT_OPTIONS_HEAL_BUTTONS            = "Barre della salute";
    HEALBOT_OPTIONS_SELFHEALS               = "Te stesso"
    HEALBOT_OPTIONS_PETHEALS                = "Famigli"
    HEALBOT_OPTIONS_GROUPHEALS              = "Gruppo";
    HEALBOT_OPTIONS_TANKHEALS               = "Main tanks";
    HEALBOT_OPTIONS_MAINASSIST              = "Main assist";
    HEALBOT_OPTIONS_PRIVATETANKS            = "Main tanks personali";
    HEALBOT_OPTIONS_TARGETHEALS             = "Targets";
    HEALBOT_OPTIONS_EMERGENCYHEALS          = "Incursione";
    HEALBOT_OPTIONS_ALERTLEVEL              = "Livello di allerta";
    HEALBOT_OPTIONS_EMERGFILTER             = "Mostra barre incursione per";
    HEALBOT_OPTIONS_EMERGFCLASS             = "Configura classi per";
    HEALBOT_OPTIONS_COMBOBUTTON             = "Pulsante";
    HEALBOT_OPTIONS_BUTTONLEFT              = "Sinistro";
    HEALBOT_OPTIONS_BUTTONMIDDLE            = "Centrale";
    HEALBOT_OPTIONS_BUTTONRIGHT             = "Destro";
    HEALBOT_OPTIONS_BUTTON4                 = "Pulsante4";
    HEALBOT_OPTIONS_BUTTON5                 = "Pulsante5";
    HEALBOT_OPTIONS_BUTTON6                 = "Pulsante6";
    HEALBOT_OPTIONS_BUTTON7                 = "Pulsante7";
    HEALBOT_OPTIONS_BUTTON8                 = "Pulsante8";
    HEALBOT_OPTIONS_BUTTON9                 = "Pulsante9";
    HEALBOT_OPTIONS_BUTTON10                = "Pulsante10";
    HEALBOT_OPTIONS_BUTTON11                = "Pulsante11";
    HEALBOT_OPTIONS_BUTTON12                = "Pulsante12";
    HEALBOT_OPTIONS_BUTTON13                = "Pulsante13";
    HEALBOT_OPTIONS_BUTTON14                = "Pulsante14";
    HEALBOT_OPTIONS_BUTTON15                = "Pulsante15";

    HEALBOT_CLASSES_ALL                     = "Tutte le classi";
    HEALBOT_CLASSES_MELEE                   = "Melee";
    HEALBOT_CLASSES_RANGES                  = "Ranged";
    HEALBOT_CLASSES_HEALERS                 = "Healers";
    HEALBOT_CLASSES_CUSTOM                  = "Personalizzata";

    HEALBOT_OPTIONS_SHOWTOOLTIP             = "Mostra tooltips";
    HEALBOT_OPTIONS_SHOWDETTOOLTIP          = "Mostra informazioni incantesimo dettagliate";
    HEALBOT_OPTIONS_SHOWCDTOOLTIP           = "Mostra cooldown incantesimo";
    HEALBOT_OPTIONS_SHOWUNITTOOLTIP         = "Mostra info bersaglio";
    HEALBOT_OPTIONS_SHOWRECTOOLTIP          = "Mostra consigli per le HoT";
    HEALBOT_TOOLTIP_POSDEFAULT              = "Posizione predefinita";
    HEALBOT_TOOLTIP_POSLEFT                 = "Alla sinistra di Healbot";
    HEALBOT_TOOLTIP_POSRIGHT                = "Alla destra di Healbot";
    HEALBOT_TOOLTIP_POSABOVE                = "Sopra Healbot";
    HEALBOT_TOOLTIP_POSBELOW                = "Sotto Healbot";
    HEALBOT_TOOLTIP_POSCURSOR               = "Accanto al cursore";
    HEALBOT_TOOLTIP_RECOMMENDTEXT           = "Consiglio per la HoT";
    HEALBOT_TOOLTIP_NONE                    = "nessuna disponibile";
    HEALBOT_TOOLTIP_CORPSE                  = "Corpo di ";
    HEALBOT_TOOLTIP_CD                      = " (CD ";
    HEALBOT_TOOLTIP_SECS                    = "s)";
    HEALBOT_WORDS_SEC                       = "sec";
    HEALBOT_WORDS_CAST                      = "Lancio";
    HEALBOT_WORDS_UNKNOWN                   = "Sconosciuto";
    HEALBOT_WORDS_YES                       = "Si";
    HEALBOT_WORDS_NO                        = "No";
    HEALBOT_WORDS_THIN                      = "Sottile";
    HEALBOT_WORDS_THICK                     = "Spesso";

    HEALBOT_WORDS_NONE                      = "Nessuno";
    HEALBOT_OPTIONS_ALT                     = "Alt";
    HEALBOT_DISABLED_TARGET                 = "Bersaglio";
    HEALBOT_OPTIONS_SHOWCLASSONBAR          = "Mostra classe sulla barra";
    HEALBOT_OPTIONS_SHOWHEALTHONBAR         = "Mostra salute sulla barra";
    HEALBOT_OPTIONS_BARHEALTHINCHEALS       = "Includi cure ricevute";
    HEALBOT_OPTIONS_BARHEALTHSEPHEALS       = "Separa cure ricevute";
    HEALBOT_OPTIONS_BARHEALTH1              = "come delta";
    HEALBOT_OPTIONS_BARHEALTH2              = "come percentuale";
    HEALBOT_OPTIONS_TIPTEXT                 = "Impostazioni Tooltip";
    HEALBOT_OPTIONS_POSTOOLTIP              = "Posizione del tooltip";
    HEALBOT_OPTIONS_SHOWNAMEONBAR           = "Mostra nome sulla barra";
    HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1     = "Colore testo in base alla classe";
    HEALBOT_OPTIONS_EMERGFILTERGROUPS       = "Includi gruppi incursione";

    HEALBOT_ONE                             = "1";
    HEALBOT_TWO                             = "2";
    HEALBOT_THREE                           = "3";
    HEALBOT_FOUR                            = "4";
    HEALBOT_FIVE                            = "5";
    HEALBOT_SIX                             = "6";
    HEALBOT_SEVEN                           = "7";
    HEALBOT_EIGHT                           = "8";

    HEALBOT_OPTIONS_SETDEFAULTS             = "Imposta predefinite";
    HEALBOT_OPTIONS_SETDEFAULTSMSG          = "Resetta le opzioni ai valori predefiniti";
    HEALBOT_OPTIONS_RIGHTBOPTIONS           = "Tasto destro apre finestra opzioni";

    HEALBOT_OPTIONS_HEADEROPTTEXT           = "Opzioni intestazioni";
    HEALBOT_OPTIONS_ICONOPTTEXT             = "Opzioni icone";
    HEALBOT_SKIN_HEADERBARCOL               = "Colore barra";
    HEALBOT_SKIN_HEADERTEXTCOL              = "Colore testo";
    HEALBOT_OPTIONS_BUFFSTEXT1              = "Incantesimo per buffare";
    HEALBOT_OPTIONS_BUFFSTEXT2              = "controlla membri";
    HEALBOT_OPTIONS_BUFFSTEXT3              = "Colori barra";
    HEALBOT_OPTIONS_BUFF                    = "Buff ";
    HEALBOT_OPTIONS_BUFFSELF                = "su se stessi";
    HEALBOT_OPTIONS_BUFFPARTY               = "sul gruppo";
    HEALBOT_OPTIONS_BUFFRAID                = "sull'incursione";
    HEALBOT_OPTIONS_MONITORBUFFS            = "Monìtora per buff mancanti";
    HEALBOT_OPTIONS_MONITORBUFFSC           = "anche in combattimento";
    HEALBOT_OPTIONS_ENABLESMARTCAST         = "SmartCast fuori dal combattimento";
    HEALBOT_OPTIONS_SMARTCASTSPELLS         = "Incantesimi inclusi";
    HEALBOT_OPTIONS_SMARTCASTDISPELL        = "Rimozione debuff";
    HEALBOT_OPTIONS_SMARTCASTBUFF           = "Applicazione buff";
    HEALBOT_OPTIONS_SMARTCASTHEAL           = "Incantesimi di cura";
    HEALBOT_OPTIONS_BAR2SIZE                = "Dimensione barra potere";
    HEALBOT_OPTIONS_SETSPELLS               = "Imposta spell per";
    HEALBOT_OPTIONS_ENABLEDBARS             = "Barre abilitate sempre";
    HEALBOT_OPTIONS_DISABLEDBARS            = "Barre disabilitate quando fuori dal combattimento";
    HEALBOT_OPTIONS_MONITORDEBUFFS          = "Monìtora per rimuovere debuff";
    HEALBOT_OPTIONS_DEBUFFTEXT1             = "Incantesimo per rimuovere debuff";

    HEALBOT_OPTIONS_IGNOREDEBUFF            = "Debuff da ignorare:";
    HEALBOT_OPTIONS_IGNOREDEBUFFCLASS       = "Per classe";
    HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT    = "Rallentamento";
    HEALBOT_OPTIONS_IGNOREDEBUFFDURATION    = "Breve durata";
    HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM      = "Non dannoso";
    HEALBOT_OPTIONS_IGNOREDEBUFFCOOLDOWN    = "Quando l'incantesimo di rimozione ha CoolDown > 1.5 secs (GCD)";
    HEALBOT_OPTIONS_IGNOREDEBUFFFRIEND      = "Quando il caster è amichevole";

    HEALBOT_OPTIONS_RANGECHECKFREQ          = "Frequenza di controllo Distanza, Aura e Aggro";

    HEALBOT_OPTIONS_HIDEPARTYFRAMES         = "Nascondi frame del gruppo";
    HEALBOT_OPTIONS_HIDEPLAYERTARGET        = "Includi te stesso e bersaglio";
    HEALBOT_OPTIONS_DISABLEHEALBOT          = "Disabilita HealBot";

    HEALBOT_ASSIST                          = "Assist";
    HEALBOT_FOCUS                           = "Focus";
    HEALBOT_MENU                            = "Menù";
    HEALBOT_MAINTANK                        = "MainTank";
    HEALBOT_MAINASSIST                      = "MainAssist";
    HEALBOT_STOP                            = "Stop";
    HEALBOT_TELL                            = "Sussurra";

    HEALBOT_TITAN_SMARTCAST                 = "SmartCast";
    HEALBOT_TITAN_MONITORBUFFS              = "Monìtora buff";
    HEALBOT_TITAN_MONITORDEBUFFS            = "Monìtora debuff"
    HEALBOT_TITAN_SHOWBARS                  = "Mostra barre per";
    HEALBOT_TITAN_EXTRABARS                 = "Barre extra";
    HEALBOT_BUTTON_TOOLTIP                  = "Clicca per aprire/chiudere le opzioni di HealBot\nClicca e tieni premuto per muovere l'icona";
    HEALBOT_TITAN_TOOLTIP                   = "Click sinistro per aprire/chiudere il pannelo opzioni di HealBot";
    HEALBOT_OPTIONS_SHOWMINIMAPBUTTON       = "Mostra pulsante sulla minimappa";
    HEALBOT_OPTIONS_BARBUTTONSHOWHOT        = "Mostra HoT";
    HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON   = "Mostra icone Raid";
    HEALBOT_OPTIONS_HOTONBAR                = "Sulla barra";
    HEALBOT_OPTIONS_HOTOFFBAR               = "Fuori barra";
    HEALBOT_OPTIONS_HOTBARRIGHT             = "A destra";
    HEALBOT_OPTIONS_HOTBARLEFT              = "A sinistra";

    HEALBOT_ZONE_AB                         = "Bacino d'Arathi";
    HEALBOT_ZONE_AV                         = "Valle d'Alterac";
    HEALBOT_ZONE_ES                         = "Occhio del Ciclone";
    HEALBOT_ZONE_IC                         = "Isola della Conquista";
    HEALBOT_ZONE_SA                         = "Lido degli Antichi";

    HEALBOT_OPTION_AGGROTRACK               = "Monìtora Aggro"
    HEALBOT_OPTION_AGGROBAR                 = "Barra"
    HEALBOT_OPTION_AGGROTXT                 = ">> Testo <<"
    HEALBOT_OPTION_AGGROIND                 = "Indicatore"
    HEALBOT_OPTION_BARUPDFREQ               = "Moltiplicatore di aggiornamento"
    HEALBOT_OPTION_USEFLUIDBARS             = "Usa fluid bars"
    HEALBOT_OPTION_CPUPROFILE               = "Usa CPU profiler (Info su quanto gli Addon usano la CPU)"
    HEALBOT_OPTIONS_RELOADUIMSG             = "Questa opzione richiede di ricaricare la UI, Ricaricare adesso?"

    HEALBOT_BUFF_PVP                        = "PvP"
    HEALBOT_BUFF_PVE						= "PvE"
    HEALBOT_OPTIONS_ANCHOR                  = "Ancoraggio Frame"
    HEALBOT_OPTIONS_BARSANCHOR              = "Ancoraggio Barre"
    HEALBOT_OPTIONS_TOPLEFT                 = "In alto a sinistra"
    HEALBOT_OPTIONS_BOTTOMLEFT              = "In basso a sinistra"
    HEALBOT_OPTIONS_TOPRIGHT                = "In alto a destra"
    HEALBOT_OPTIONS_BOTTOMRIGHT             = "In basso a destra"
    HEALBOT_OPTIONS_TOP                     = "In alto"
    HEALBOT_OPTIONS_BOTTOM                  = "In basso"

    HEALBOT_PANEL_BLACKLIST                 = "BlackList"

    HEALBOT_WORDS_REMOVEFROM                = "Rimuovi da";
    HEALBOT_WORDS_ADDTO                     = "Aggiungi a";
    HEALBOT_WORDS_INCLUDE                   = "Includi";

    HEALBOT_OPTIONS_TTALPHA                 = "Opacità"
    HEALBOT_TOOLTIP_TARGETBAR               = "Barra bersaglio"
    HEALBOT_OPTIONS_MYTARGET                = "Miei bersagli"

    HEALBOT_DISCONNECTED_TEXT               = "<DC>"
    HEALBOT_OPTIONS_SHOWUNITBUFFTIME        = "Mostra i miei buff";
    HEALBOT_OPTIONS_TOOLTIPUPDATE           = "Aggiorna costantemente";
    HEALBOT_OPTIONS_BUFFSTEXTTIMER          = "Mostra buff prima che scada";
    HEALBOT_OPTIONS_SHORTBUFFTIMER          = "Buff brevi"
    HEALBOT_OPTIONS_LONGBUFFTIMER           = "Buff lunghi"

    HEALBOT_OPTIONS_NOTIFY_MSG              = "Messaggio"
    HEALBOT_WORDS_YOU                       = "tu";
    HEALBOT_NOTIFYOTHERMSG                  = "Lanciando #s su #n";

    HEALBOT_OPTIONS_HOTPOSITION             = "Posizione icona"
    HEALBOT_OPTIONS_HOTSHOWTEXT             = "Mostra testo icona"
    HEALBOT_OPTIONS_HOTTEXTCOUNT            = "Conteggio"
    HEALBOT_OPTIONS_HOTTEXTDURATION         = "Durata"
    HEALBOT_OPTIONS_ICONSCALE               = "Dimensione icona"
    HEALBOT_OPTIONS_ICONTEXTSCALE           = "Dimensione testo icona"

    HEALBOT_OPTIONS_AGGROBARSIZE            = "Dimensione barra Aggro"
    HEALBOT_OPTIONS_DOUBLETEXTLINES         = "Raddoppia le righe di testo"
    HEALBOT_OPTIONS_TEXTALIGNMENT           = "Allineamento testo"
    HEALBOT_VEHICLE                         = "Veicolo"
    HEALBOT_WORDS_ERROR                     = "Errore"
    HEALBOT_SPELL_NOT_FOUND	                = "Incantesimo non trovato"
    HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT  = "Nacondi Tooltip in Combattimento"
    HEALBOT_OPTIONS_ENABLELIBQH             = "Abilita fastHealth di HealBot"

    HEALBOT_OPTIONS_BUFFNAMED               = "Inserisci i nomi dei personaggi da controllare per\n\n"
    HEALBOT_WORD_ALWAYS                     = "Sempre";
    HEALBOT_WORD_SOLO                       = "Solo";
    HEALBOT_WORD_NEVER                      = "Mai";
    HEALBOT_SHOW_CLASS_AS_ICON              = "come icona";
    HEALBOT_SHOW_CLASS_AS_TEXT              = "come testo";
    HEALBOT_SHOW_ROLE                       = "Mostra ruolo se impostato";

    HEALBOT_SHOW_INCHEALS                   = "Mostra cure ricevute";

    HEALBOT_HELP={ [1] = "[HealBot] /hb h -- Mostra aiuti",
                   [2] = "[HealBot] /hb o -- Apri/chiudi Opzioni",
                   [3] = "[HealBot] /hb ri -- Resetta HealBot",
                   [4] = "[HealBot] /hb t -- Abilita/Disabilita Healbot",
                   [5] = "[HealBot] /hb bt -- Abilita/Disabilita il Buff Monitor",
                   [6] = "[HealBot] /hb dt -- Abilita/Disabilita il Debuff Monitor",
                   [7] = "[HealBot] /hb skin <skinName> -- Cambia Skin in quella indicata",
                   [8] = "[HealBot] /hb ui -- Ricarica UI",
                   [9] = "[HealBot] /hb hs -- Mostra comandi slash aggiuntivi",
                  }

    HEALBOT_HELP2={ [1] = "[HealBot] /hb d -- Resetta le opzioni a quelle predefinite",
                    [2] = "[HealBot] /hb aggro 2 <n> -- Imposta il livello aggro 2 per la percentuale di threat <n>",
                    [3] = "[HealBot] /hb aggro 3 <n> -- Imposta il livello aggro 3 per la percentuale di threat <n>",
                    [4] = "[HealBot] /hb tr <Role> -- Imposta la priorità di ruolo alta in SubSort per Ruolo. Ruoli validi sono 'TANK', 'HEALER' o 'DPS'",
                    [5] = "[HealBot] /hb use10 -- Usa automaticamente lo slot 10 di Ingegneria",
                    [6] = "[HealBot] /hb pcs <n> -- Modifica la dimensione dell'indicatore di carica del Potere Sacro di <n>, Valore predefinito 7 ",
                    [7] = "[HealBot] /hb spt -- Attiva/Disattiva il tuo famiglio",
                    [8] = "[HealBot] /hb ws -- Attiva/Disattiva la possibilità di mostrare/nascondere l'icona Anima Indebolita al posto di quella di PW:S con il -",
                    [9] = "[HealBot] /hb rld <n> -- Imposta (in secondi), quanto a lungo il nome dei personaggi rimane verde dopo una resurrezione",
                    [10] = "[HealBot] /hb flb -- Attiva/Disattiva il bypass del blocco dei frame (i frame si spostano sempre con Ctrl+Alt+Click sinistro)",
                    [11] = "[HealBot] /hb rtb -- Attiva/Disattiva la restrizione per la barra del bersaglio a Sinistro=SmartCast e Destro=aggiungi/rimuovi a/dai Miei Bersagli",
                  }
                  
    HEALBOT_OPTION_HIGHLIGHTACTIVEBAR       = "Evidenzia mouseover"
    HEALBOT_OPTION_HIGHLIGHTTARGETBAR       = "Evidenzia bersaglio"
    HEALBOT_OPTIONS_TESTBARS                = "Barre di Test"
    HEALBOT_OPTION_NUMBARS                  = "Numero di Barre"
    HEALBOT_OPTION_NUMTANKS                 = "Numero di Tank"
    HEALBOT_OPTION_NUMMYTARGETS             = "Numero di Miei Bersagli"
    HEALBOT_OPTION_NUMPETS                  = "Numero di Famigli"
    HEALBOT_WORD_TEST                       = "Test";
    HEALBOT_WORD_OFF                        = "Off";
    HEALBOT_WORD_ON                         = "On";

    HEALBOT_OPTIONS_TAB_PROTECTION          = "Protezione"
    HEALBOT_OPTIONS_TAB_CHAT                = "Chat"
    HEALBOT_OPTIONS_TAB_HEADERS             = "Intestazioni"
    HEALBOT_OPTIONS_TAB_BARS                = "Barre"
    HEALBOT_OPTIONS_TAB_ICONS               = "Icone"
    HEALBOT_OPTIONS_TAB_WARNING             = "Avviso"
    HEALBOT_OPTIONS_SKINDEFAULTFOR          = "Skin predefinita per"
    HEALBOT_OPTIONS_INCHEAL                 = "Cure ricevute"
    HEALBOT_WORD_ARENA                      = "Arena"
    HEALBOT_WORD_BATTLEGROUND               = "Battle Ground"
    HEALBOT_OPTIONS_TEXTOPTIONS             = "Opzioni del Testo"
    HEALBOT_WORD_PARTY                      = "Gruppo"
    HEALBOT_OPTIONS_COMBOAUTOTARGET         = "Auto\nTarget"
    HEALBOT_OPTIONS_COMBOAUTOTRINKET        = "Auto Trinket"
    HEALBOT_OPTIONS_GROUPSPERCOLUMN         = "Imposta gruppi in colonne"

    HEALBOT_OPTIONS_MAINSORT                = "Primo ordinamento"
    HEALBOT_OPTIONS_SUBSORT                 = "Sub-ordinamento"
    HEALBOT_OPTIONS_SUBSORTINC              = "Sub-ordina anche:"

    HEALBOT_OPTIONS_BUTTONCASTMETHOD        = "Lancia quando"
    HEALBOT_OPTIONS_BUTTONCASTPRESSED       = "Premuto"
    HEALBOT_OPTIONS_BUTTONCASTRELEASED      = "Rilasciato"

    HEALBOT_INFO_ADDONCPUUSAGE              = "== Addon CPU Usage in Secondi =="
    HEALBOT_INFO_ADDONCOMMUSAGE             = "== Addon Comms Usage =="
    HEALBOT_WORD_HEALER                     = "Guaritore"
    HEALBOT_WORD_DAMAGER                    = "Assaltatore"
    HEALBOT_WORD_TANK                       = "Difensore"
    HEALBOT_WORD_LEADER                     = "Leader"
    HEALBOT_WORD_VERSION                    = "Versione"
    HEALBOT_WORD_CLIENT                     = "Client"
    HEALBOT_WORD_ADDON                      = "Addon"
    HEALBOT_INFO_CPUSECS                    = "CPU Secs"
    HEALBOT_INFO_MEMORYMB                   = "Memory MB"
    HEALBOT_INFO_COMMS                      = "Comms KB"

    HEALBOT_WORD_STAR                       = "Stella"
    HEALBOT_WORD_CIRCLE                     = "Cerchio"
    HEALBOT_WORD_DIAMOND                    = "Diamante"
    HEALBOT_WORD_TRIANGLE                   = "Triangolo"
    HEALBOT_WORD_MOON                       = "Luna"
    HEALBOT_WORD_SQUARE                     = "Quadrato"
    HEALBOT_WORD_CROSS                      = "Croce"
    HEALBOT_WORD_SKULL                      = "Teschio"

    HEALBOT_OPTIONS_ACCEPTSKINMSG           = "Accetta Skin di [HealBot]: "
    HEALBOT_OPTIONS_ACCEPTSKINMSGFROM       = " da "
    HEALBOT_OPTIONS_BUTTONSHARESKIN         = "Condividi con"

    HEALBOT_CHAT_ADDONID                    = "[HealBot]  "
    HEALBOT_CHAT_NEWVERSION1                = "Una nuova versione è disponibile"
    HEALBOT_CHAT_NEWVERSION2                = "su "..HEALBOT_ABOUT_URL
    HEALBOT_CHAT_SHARESKINERR1              = " Skin da condividere non trovata"
    HEALBOT_CHAT_SHARESKINERR3              = " non trovata per la condivisione Skin"
    HEALBOT_CHAT_SHARESKINACPT              = "Condivisione Skin accettata da "
    HEALBOT_CHAT_CONFIRMSKINDEFAULTS        = "Skin impostate a Predefinite"
    HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS      = "Reset Debuff personalizzati"
    HEALBOT_CHAT_CHANGESKINERR1             = "Skin sconosciuta: /hb skin "
    HEALBOT_CHAT_CHANGESKINERR2             = "Skin valide:  "
    HEALBOT_CHAT_CONFIRMSPELLCOPY           = "Incantesimo corrente copiato per tutte le spec"
    HEALBOT_CHAT_UNKNOWNCMD                 = "Comando slash sconosciuto: /hb "
    HEALBOT_CHAT_ENABLED                    = "Stato ATTIVATO in attivazione"
    HEALBOT_CHAT_DISABLED                   = "Stato DISATTIVATO in attivazione"
    HEALBOT_CHAT_SOFTRELOAD                 = "Richiesto ricaricamento Healbot"
    HEALBOT_CHAT_HARDRELOAD                 = "Richiesto ricaricamento UI"
    HEALBOT_CHAT_CONFIRMSPELLRESET          = "Incantesimi resettati"
    HEALBOT_CHAT_CONFIRMCURESRESET          = "Dissoluzioni resettate"
    HEALBOT_CHAT_CONFIRMBUFFSRESET          = "Buff resettati"
    HEALBOT_CHAT_POSSIBLEMISSINGMEDIA       = "Impossibile ricevere le impostazioni delle Skin - Probabilmente manca SharedMedia, scaricalo da curse.com"
    HEALBOT_CHAT_MACROSOUNDON               = "Suono non soppresso quando abilitato auto trinkets"
    HEALBOT_CHAT_MACROSOUNDOFF              = "Suono soppresso quando abilitato auto trinkets"
    HEALBOT_CHAT_MACROERRORON               = "Errori non soppressi quando abilitato auto trinkets"
    HEALBOT_CHAT_MACROERROROFF              = "Errori soppressi quando abilitato auto trinkets"
    HEALBOT_CHAT_ACCEPTSKINON               = "Condivisione Skin - Mostra finestra popup per accettare la skin condivisa da qualcuno con te"
    HEALBOT_CHAT_ACCEPTSKINOFF              = "Condivisione Skin - Ignora sempre condivisione skins da tutti"
    HEALBOT_CHAT_USE10ON                    = "Auto Trinket - Use10 è on - Devi abilitare un auto trinket perché use10 funzioni"
    HEALBOT_CHAT_USE10OFF                   = "Auto Trinket - Use10 è off"
    HEALBOT_CHAT_SKINREC                    = " skin ricevuta da " 

    HEALBOT_OPTIONS_SELFCASTS               = "Solo lancio su se stessi"
    HEALBOT_OPTIONS_HOTSHOWICON             = "Mostra icona"
    HEALBOT_OPTIONS_ALLSPELLS               = "Tutti gli incantesimi"
    HEALBOT_OPTIONS_DOUBLEROW               = "Raddoppia righe"
    HEALBOT_OPTIONS_HOTBELOWBAR             = "Sotto la barra"
    HEALBOT_OPTIONS_OTHERSPELLS             = "Altri incantesimi"
    HEALBOT_WORD_MACROS                     = "Macro"
    HEALBOT_WORD_SELECT                     = "Seleziona"
    HEALBOT_OPTIONS_QUESTION                = "?"
    HEALBOT_WORD_CANCEL                     = "Cancella"
    HEALBOT_WORD_COMMANDS                   = "Comandi"
    HEALBOT_OPTIONS_BARHEALTH3              = "come salute";
    HEALBOT_SORTBY_ROLE                     = "Ruolo"
    HEALBOT_WORD_DPS                        = "DPS"
    HEALBOT_CHAT_TOPROLEERR                 = " ruolo non valido in questo contesto - usa 'TANK', 'DPS' o 'HEALER'"
    HEALBOT_CHAT_NEWTOPROLE                 = "Adesso il massimo ruolo è "
    HEALBOT_CHAT_SUBSORTPLAYER1             = "Il personaggio sarà impostato primo nel SubSort"
    HEALBOT_CHAT_SUBSORTPLAYER2             = "Il personaggio sarà ordinato normalmente nel SubSort"
    HEALBOT_OPTIONS_SHOWREADYCHECK          = "Mostra Appello";
    HEALBOT_OPTIONS_SUBSORTSELFFIRST        = "Se stessi per primi"
    HEALBOT_WORD_FILTER                     = "Filtra"
    HEALBOT_OPTION_AGGROPCTBAR              = "Sposta barra"
    HEALBOT_OPTION_AGGROPCTTXT              = "Mostra testo"
    HEALBOT_OPTION_AGGROPCTTRACK            = "Monìtora percentuale" 
    HEALBOT_OPTIONS_ALERTAGGROLEVEL1        = "1 - Threat basso"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL2        = "2 - Threat alto"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL3        = "3 - Tanking"
    HEALBOT_OPTIONS_AGGROALERT              = "Barra livello allerta"
    HEALBOT_OPTIONS_AGGROINDALERT           = "Indicatore livello allerta"
    HEALBOT_OPTIONS_TOOLTIPSHOWHOT          = "Mostra dettagli HoT attivi monitorati"
    HEALBOT_WORDS_MIN                       = "min"
    HEALBOT_WORDS_MAX                       = "max"
    HEALBOT_CHAT_SELFPETSON                 = "Proprio famiglio attivato"
    HEALBOT_CHAT_SELFPETSOFF                = "Proprio famiglio disattivato"
    HEALBOT_WORD_PRIORITY                   = "Priorità"
    HEALBOT_VISIBLE_RANGE                   = "Entro 100 yard"
    HEALBOT_SPELL_RANGE                     = "Entro il range dell'incantesimo"
    HEALBOT_WORD_RESET                      = "Resetta"
    HEALBOT_HBMENU                          = "HBmenu"
    HEALBOT_ACTION_HBFOCUS                  = "Click sinistro per impostare\nil focus sul bersaglio"
    HEALBOT_WORD_CLEAR                      = "Pulisci"
    HEALBOT_WORD_SET                        = "Imposta"
    HEALBOT_WORD_HBFOCUS                    = "HealBot Focus"
    HEALBOT_WORD_OUTSIDE                    = "Esterno"
    HEALBOT_WORD_ALLZONE                    = "Tutte le zone"
    HEALBOT_OPTIONS_TAB_ALERT               = "Allerta"
    HEALBOT_OPTIONS_TAB_SORT                = "Ordina"
    HEALBOT_OPTIONS_TAB_HIDE                = "Nascondi"
    HEALBOT_OPTIONS_TAB_AGGRO               = "Aggro"
    HEALBOT_OPTIONS_TAB_ICONTEXT            = "Testo Icona"
    HEALBOT_OPTIONS_TAB_TEXT                = "Testo Barra"
    HEALBOT_OPTIONS_AGGRO3COL               = "Colore della barra\ndell'Aggro"
    HEALBOT_OPTIONS_AGGROFLASHFREQ          = "Frequenza lampeggiamento"
    HEALBOT_OPTIONS_AGGROFLASHALPHA         = "Opacità lampeggiamento"
    HEALBOT_OPTIONS_SHOWDURATIONFROM        = "Mostra durata da"
    HEALBOT_OPTIONS_SHOWDURATIONWARN        = "Avviso durata da"
    HEALBOT_CMD_RESETCUSTOMDEBUFFS          = "Resetta debuff personalizzati"
    HEALBOT_CMD_RESETSKINS                  = "Resetta skin"
    HEALBOT_CMD_CLEARBLACKLIST              = "Pulisci BlackList"
    HEALBOT_CMD_TOGGLEACCEPTSKINS           = "Attiva/Disattiva accetta Skin dagli altri"
    HEALBOT_CMD_TOGGLEDISLIKEMOUNT          = "Attiva/Disattiva Cavalvatura Sgradita"
    HEALBOT_OPTION_DISLIKEMOUNT_ON          = "Adesso sgradisci la Cavalcatura"
    HEALBOT_OPTION_DISLIKEMOUNT_OFF         = "Non sgradire più la Cavalcatura"
    HEALBOT_CMD_COPYSPELLS                  = "Copia l'incantesimo corrente in tutte le spec"
    HEALBOT_CMD_RESETSPELLS                 = "Resetta incantesimi"
    HEALBOT_CMD_RESETCURES                  = "Resetta dissoluzioni"
    HEALBOT_CMD_RESETBUFFS                  = "Resetta buff"
    HEALBOT_CMD_RESETBARS                   = "Resetta la posizione della barra"
    HEALBOT_CMD_SUPPRESSSOUND               = "Attiva/Disattiva soppressione suono quando auto trinket abilitato"
    HEALBOT_CMD_SUPPRESSERRORS              = "Attiva/Disattiva soppressione errori quando auto trinket abilitato"
    HEALBOT_OPTIONS_COMMANDS                = "Comandi di HealBot"
    HEALBOT_WORD_RUN                        = "Esegui"
    HEALBOT_OPTIONS_MOUSEWHEEL              = "Usa rotellina del mouse"
    HEALBOT_OPTIONS_MOUSEUP                 = "Rotellina su"
    HEALBOT_OPTIONS_MOUSEDOWN               = "Rotellina giù"
    HEALBOT_CMD_DELCUSTOMDEBUFF10           = "Cancella debuff personalizzati con priorità 10"
    HEALBOT_ACCEPTSKINS                     = "Accetta Skin dagli altri"
    HEALBOT_SUPPRESSSOUND                   = "Auto Trinket: Sopprimi suono"
    HEALBOT_SUPPRESSERROR                   = "Auto Trinket: Sopprimi errori"
    HEALBOT_OPTIONS_CRASHPROT               = "Protezione dai Crash"
    HEALBOT_CP_MACRO_LEN                    = "Il nome della Macro deve avere da 1 a 14 caratteri"
    HEALBOT_CP_MACRO_BASE                   = "Nome Base della macro"
    HEALBOT_CP_MACRO_SAVE                   = "Ultimo salvataggio alle: "
    HEALBOT_CP_STARTTIME                    = "Durata protezione alla connessione"
    HEALBOT_WORD_RESERVED                   = "Riservato"
    HEALBOT_OPTIONS_COMBATPROT              = "Protezione Combattimento"
    HEALBOT_COMBATPROT_PARTYNO              = "Barre Riservate per il Gruppo"
    HEALBOT_COMBATPROT_RAIDNO               = "Barre Riservate per il Raid"

    HEALBOT_WORD_HEALTH                     = "Salute"
    HEALBOT_OPTIONS_DONT_SHOW               = "Non mostrare"
    HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT    = "Lo stesso della salute (salute attuale)"
    HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE     = "Lo stesso della salute (salute futura)"
    HEALBOT_OPTIONS_FUTURE_HLTH             = "Salute futura"
    HEALBOT_SKIN_HEALTHBARCOL_TEXT          = "Barra della Salute";
    HEALBOT_SKIN_HEALTHBACKCOL_TEXT         = "Sfondo della barra";
    HEALBOT_SKIN_INCHEALBARCOL_TEXT         = "Cure ricevute";
    HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET      = "Bersaglio: Mostra sempre"
    HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS       = "Focus: Mostra sempre"
    HEALBOT_OPTIONS_GROUP_PETS_BY_FIVE      = "Famigli: in gruppi di cinque"
    HEALBOT_OPTIONS_USEGAMETOOLTIP          = "Usa il Tooltip del Gioco"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER        = "Mostra conteggio potere"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA   = "Mostra potere sacro"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_MONK   = "Mostra potere chi"
    HEALBOT_OPTIONS_CUSTOMDEBUFF_REVDUR     = "Inverti durata"
    HEALBOT_OPTIONS_DISABLEHEALBOTSOLO      = "soltanto quando in solo"
    HEALBOT_OPTIONS_CUSTOM_ALLDISEASE       = "Tutte le Malattie"
    HEALBOT_OPTIONS_CUSTOM_ALLMAGIC         = "Tutte le Magie"
    HEALBOT_OPTIONS_CUSTOM_ALLCURSE         = "Tutte le Maledizioni"
    HEALBOT_OPTIONS_CUSTOM_ALLPOISON        = "Tutti i Veleni"
    HEALBOT_OPTIONS_CUSTOM_CASTBY           = "Lanciato da"

    HEALBOT_BLIZZARD_MENU                   = "Menù Blizzard"
    HEALBOT_HB_MENU                         = "Menù di Healbot"
    HEALBOT_FOLLOW                          = "Segui"
    HEALBOT_TRADE                           = "Commercia"
    HEALBOT_PROMOTE_RA                      = "Promuovi ad assistente"
    HEALBOT_DEMOTE_RA                       = "Degrada ad assistente"
    HEALBOT_TOGGLE_ENABLED                  = "Attiva/Disattiva abilitato"
    HEALBOT_TOGGLE_MYTARGETS                = "Attiva/Disattiva Miei Bersagli"
    HEALBOT_TOGGLE_PRIVATETANKS             = "Attiva/Disattiva Tank personali"
    HEALBOT_RESET_BAR                       = "Resetta barra"
    HEALBOT_HIDE_BARS                       = "Nascondi barre oltre 100 yard"
    HEALBOT_RANDOMMOUNT                     = "Cavalcatura Casuale"
    HEALBOT_RANDOMGOUNDMOUNT                = "Cavalcatura Terrestre Casuale"
    HEALBOT_RANDOMPET                       = "Mascotte Casuale"
    HEALBOT_ZONE_AQ40                       = "Ahn'Qiraj"
    HEALBOT_ZONE_VASHJIR1                   = "Foresta di Kelp'thar"
    HEALBOT_ZONE_VASHJIR2                   = "Distesa Scintillante"
    HEALBOT_ZONE_VASHJIR3                   = "Profondità Abissali"
    HEALBOT_ZONE_VASHJIR                    = "Vashj'ir"
    HEALBOT_RESLAG_INDICATOR                = "Mantieni il nome in verde dopo il res impostato a" 
    HEALBOT_RESLAG_INDICATOR_ERROR          = "Mantieni il nome in verde dopo il res deve essere da 1 a 30" 
    HEALBOT_FRAMELOCK_BYPASS_OFF            = "Bypass del blocco frame disabilitato"
    HEALBOT_FRAMELOCK_BYPASS_ON             = "Bypass del blocco frame (Ctl+Alt+Left) abilitato"
    HEALBOT_RESTRICTTARGETBAR_ON            = "Restrizione barra bersaglio abilitata"
    HEALBOT_RESTRICTTARGETBAR_OFF           = "Restrizione barra bersaglio disabilitata"
    HEALBOT_PRELOADOPTIONS_ON               = "Precaricamento Opzioni abilitato"
    HEALBOT_PRELOADOPTIONS_OFF              = "Precaricamento Opzioni disabilitato"
    HEALBOT_AGGRO2_ERROR_MSG                = "Per impostare il livello aggro 2, la percentuale di threat deve essere tra 25 e 95"
    HEALBOT_AGGRO3_ERROR_MSG                = "Per impostare il livello aggro 2, la percentuale di threat deve essere tra 75 e 100"
    HEALBOT_AGGRO2_SET_MSG                  = "Livello aggro 2 impostato alla percentuale di threat "
    HEALBOT_AGGRO3_SET_MSG                  = "Livello aggro 3 impostato alla percentuale di threat "
    HEALBOT_WORD_THREAT                     = "Threat"
    HEALBOT_AGGRO_ERROR_MSG                 = "Livello aggro non valido - usare 2 o 3"

    HEALBOT_OPTIONS_QUERYTALENTS            = "Interrogazione dati talenti"
    HEALBOT_OPTIONS_LOWMANAINDICATOR        = "Indicatore Mana basso"
    HEALBOT_OPTIONS_LOWMANAINDICATOR1       = "Non mostrare"
    HEALBOT_OPTIONS_LOWMANAINDICATOR2       = "*10% / **20% / ***30%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR3       = "*15% / **30% / ***45%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR4       = "*20% / **40% / ***60%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR5       = "*25% / **50% / ***75%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR6       = "*30% / **60% / ***90%"

    HEALBOT_OPTION_IGNORE_AURA_RESTED       = "Ignora eventi aura durante il riposo"

    HEALBOT_WORD_ENABLE                     = "Abilita"
    HEALBOT_WORD_DISABLE                    = "Disabilita"

    HEALBOT_OPTIONS_MYCLASS                 = "Mia Classe"

    HEALBOT_OPTIONS_CONTENT_ABOUT           = "        Info"
    HEALBOT_OPTIONS_CONTENT_GENERAL         = "        " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SPELLS          = "        " .. HEALBOT_OPTIONS_TAB_SPELLS
    HEALBOT_OPTIONS_CONTENT_SKINS           = "        " .. HEALBOT_OPTIONS_TAB_SKIN
    HEALBOT_OPTIONS_CONTENT_CURE            = "        " .. HEALBOT_OPTIONS_TAB_CDC
    HEALBOT_OPTIONS_CONTENT_BUFFS           = "        " .. HEALBOT_OPTIONS_TAB_BUFFS
    HEALBOT_OPTIONS_CONTENT_TIPS            = "        " .. HEALBOT_OPTIONS_TAB_TIPS
    HEALBOT_OPTIONS_CONTENT_MOUSEWHEEL      = "        Rotellina Mouse"
    HEALBOT_OPTIONS_CONTENT_TEST            = "        Test"
    HEALBOT_OPTIONS_CONTENT_USAGE           = "        Utilizzo"
    HEALBOT_OPTIONS_REFRESH                 = "Aggiorna"

    HEALBOT_CUSTOM_CATEGORY                 = "Categoria"
    HEALBOT_CUSTOM_CAT_CUSTOM               = "Personalizzato"
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

    HEALBOT_CUSTOM_CASTBY_EVERYONE          = "Tutti"
    HEALBOT_CUSTOM_CASTBY_ENEMY             = "Nemico"
    HEALBOT_CUSTOM_CASTBY_FRIEND            = "Amico"

    HEALBOT_CUSTOM_DEBUFF_CATS = {
           --[[[HEALBOT_DEBUFF_ACID_DRENCHED_MANDIBLES] = 2,
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
            [HEALBOT_DEBUFF_WEB_WRAP]              = 13,]]--
        }

    HEALBOT_ABOUT_DESC1                    = "Aggiunge un pannello con barre skinnabili per curare, decursare, buffare, ressare e trackare aggro"
    HEALBOT_ABOUT_WEBSITE                  = "Website:"
    HEALBOT_ABOUT_AUTHORH                  = "Autore:"
    HEALBOT_ABOUT_AUTHORD                  = "Strife"
    HEALBOT_ABOUT_CATH                     = "Categoria:"
    HEALBOT_ABOUT_CATD                     = "Unit Frames, Buffs and Debuffs, Combat:Healer"
    HEALBOT_ABOUT_CREDITH                  = "Crediti:"
    HEALBOT_ABOUT_CREDITD                  = "Acirac, Kubik, Von, Aldetal, Brezza (itIT), CT, Moonlight Han Xing"  -- Anyone taking on translations (if required), feel free to add yourself here.
    HEALBOT_ABOUT_LOCALH                   = "Lingue:"
    HEALBOT_ABOUT_LOCALD                   = "deDE, enUK, esES, frFR, huHU, itIT, koKR, poBR, ruRU, zhCN, zhTW"
    HEALBOT_ABOUT_FAQH                     = "Domande Frequenti (FAQ)"
    HEALBOT_ABOUT_FAQ_QUESTION             = "Domanda"
    HEALBOT_ABOUT_FAQ_ANSWER               = "Risposta"

    HEALBOT_ABOUT_FAQ_QUESTIONS = {   [1]   = "Buffs - Tutte le barre sono bianche, cos'è successo",
                                      [2]   = "Lancio - Ogni tanto il cursore diventa blu e non posso fare niente",
                                      [3]   = "Macro - Esiste qualche esempio di cooldown",
                                      [4]   = "Macro - Esiste qualche esempio di lancio d'incantesimo",
                                      [5]   = "Mouse - Come posso usare le mie macro mouseover con la rotellina del mouse",
                                      [6]   = "Opzioni - Si possono ordinare le barre in base ai gruppi, per esempio avere 2 gruppi per colonna",
                                      [7]   = "Opzioni - Posso nascondere tutte le barre e mostrare solo quelle di chi ha un debuff da rimuovere",
                                      [8]   = "Opzioni - Posso nascondere le cure ricevute",
                                      [9]   = "Opzioni - Healbot non salva le mie opzioni quando sloggo/loggo",
                                      [10]  = "Opzioni - Come posso impostare l'uso delle barre sempre abilitate",
                                      [11]  = "Opzioni - Come posso disabilitare Healbot automaticamente",
                                      [12]  = "Opzioni - Come posso fare in modo che le barre vengano create in una direzione diversa",
                                      [13]  = "Opzioni - Come posso impostare i 'Miei Bersagli'",
                                      [14]  = "Opzioni - Come posso impostare i 'Tank Personali'",
                                      [15]  = "Opzioni - Con Healbot è possibile creare una barra per un NPC",
                                      [16]  = "Distanza - Non riesco a vedere quando i bersagli sono fuori range (troppo distanti), come posso risolvere",
                                      [17]  = "Incantesimi - Healbot lancia un incantesimo differente rispetto a quello che ho impostato",
                                      [18]  = "Incantesimi - Non posso lanciare cure su bersagli non feriti",
                                  }

    HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01       = "Questo è dovuto alle opzioni impostate nella sezione Incantesimi \n" ..
                                              "prova a fare queste modifiche e testale: \n\n" ..
                                              "     1: Nella sezione Incantesimi: Attiva Usa sempre barre abilitate \n" ..
                                              "     2: Nella sezione Incantesimi: Disattiva SmartCast \n\n" ..
                                              "Nota: Si prevede che la maggior parte degli utenti voglia \n"..
                                              "         riabilitare SmartCast \n\n" ..
                                              "Nota: Si prevede che gli utenti più esperti vogliano \n" ..
                                              "         disabilitare Usa sempre barre abilitate \n" ..
                                              "         e impostare gli incantesimi per le barre disabilitate"
                                              
    HEALBOT_ABOUT_FAQ_ANSWERS = {     [1]   = "Hai il monitoraggio per i buff mancanti attivo \n\n" .. 
                                              "Puoi disabilitare questa opzione nella sezione Buffs \n" ..
                                              "In alternativa clicca sulla barra e lancia il buff",
                                      [2]   = "Questa è una funzione Blizzard, non di Healbot \n\n" .. 
                                              "Usando i frame standard Blizzard, \n" ..
                                              "prova a lanciare un incantesimo che è in Cooldown \n" ..
                                              "Nota come il cursore diventa blu. \n\n" ..
                                              "Nota: Nulla può essere fatto per prevenirlo finché si è \n" ..
                                              "in combattimento, sin da WoW 2.0 la Blizzard ha bloccato \n" ..
                                              "l'interfaccia (UI) durante il combattimento impedendo a tutti gli addon \n" ..
                                              "di cambiare incantesimi o bersagli da quel che è stato preimpostato \n\n" ..
                                              "Può essere d'aiuto monitorare il cooldown dell'incantesimo nel tooltip",
                                      [3]   = "Si \n\n"..
                                              "Esempio di macro cooldown usando Imposizione della Salvezza (Hand of Salvation) \ndel Paladino: \n\n" ..
                                              "    #show Imposizione della Salvezza \n" ..
                                              '    /script local n=UnitName("hbtarget"); ' .. "\n" ..
                                              '    if GetSpellCooldown("Imposizione della Salvezza")==0 then ' .. " \n" ..
                                              '        SendChatMessage("Imposizione della Salvezza su "..n,"YELL") ' .. "\n" ..
                                              '        SendChatMessage("Imposizione della Salvezza!","WHISPER",nil,n) ' .. "\n" ..
                                              "    end; \n" ..
                                              "    /cast [@hbtarget] Imposizione della Salvezza",
                                      [4]   = "Si \n\n"..
                                              "Esempio con Cura Rapida del Sacerdote, usando entrambi i trinket: \n\n" ..
                                              "    #show Cura Rapida \n" ..
                                              "    /script UIErrorsFrame:Hide() \n" ..
                                              "    /console Sound_EnableSFX 0 \n" ..
                                              "    /use 13 \n" ..
                                              "    /use 14 \n" ..
                                              "    /console Sound_EnableSFX 1 \n" ..
                                              "    /cast [@hbtarget] Cura Rapida \n" ..
                                              "    /script UIErrorsFrame:Clear(); UIErrorsFrame:Show()",
                                      [5]   = "1: Nella sezione Rotellina Mouse: Disabilita Usa rotellina del mouse \n" ..
                                              "2: Associa le macro alle associazioni Blizzard usando [@mouseover] \n\n\n" ..
                                              "Macro di esempio: \n\n" ..
                                              "    #showtooltip Cura Rapida \n" ..
                                              "    /cast [@mouseover] Cura Rapida \n",
                                      [6]   = "Si \n\n\n"..
                                              "Con Intestazioni: \n" ..
                                              "     1: Nella sezione Skins>Intestazioni, attiva Mostra Intestazioni \n" ..
                                              "     2: Nella sezione Skins>Barre, imposta Nr. gruppi per colonna \n\n" ..
                                              "Senza Intestazioni: \n" ..
											  "     1: Nella sezione Skins>Intestazioni, disattiva Mostra Intestazioni \n" ..
                                              "     2: Nella sezione Skins>Barre, attiva Imposta gruppi in colonne \n" ..
                                              "     3: Nella sezione Skins>Barre, imposta Nr. Colonne",
                                      [7]   = "Si \n\n"..
                                              "1: Nella sezione Skins>Cure>Allerta, imposta Livello di allerta a 0 \n" ..
                                              "2: Nella sezione Skins>Aggro, disattiva Monìtora Aggro \n" .. 
                                              "3: Nella sezione Skins>Barre, imposta Opacità disabilitato a 0 \n" ..
                                              "4: Nella sezione Skins>Barre, imposta Opacità sfondo barre a 0 \n" ..
                                              "5: Nella sezione Skins>Testo Barra, clicca sulla barra Disabilitato \n" ..
                                              "    e imposta l'opacità a 0 \n" ..
                                              "6: Nella sezione Skins>Generale, clicca su Sfondo \n" ..
                                              "    e imposta l'opacità a 0 \n" ..
                                              "7: Nella sezione Dissoluzioni, abilita Monìtora per rimuovere debuff",
                                      [8]   = "Si \n\n"..
                                              "1: Nella sezione Skins>Barre, imposta Cure ricevute su Non mostrare \n" ..
                                              "2: Nella sezione Skins>Testo Barra, imposta Mostra salute sulla barra \n" ..
                                              "    a No cure ricevute",
                                      [9]   = "Questo problema esiste da quando vi fu un cambiamento in WoW 3.2, \n" ..
                                              "può colpire personaggi con caratteri strani (non-unicode) nel nome \n\n" ..
											  "  Se usi Vista o Win7 puoi provare a risolvere andando in \n" ..
											  "     - Pannello di Controllo > Paese e lingua > Opzioni di Amministrazione \n" ..
                                              "     - Nella sezione Lingua per programmi non Unicode clicca su \n" ..
											  "       Cambia impostazioni locali del sistema \n" ..
											  "     - scegli quindi una lingua, clicca su OK e poi su Riavvia ora",

                                      [10]   = "Nella sezione Incantesimi abilita Usa sempre barre abilitate \n\n" ..
                                              "Alcuni vorranno anche impostare il livello di allerta a 100 \n" ..
                                              "Questo può essere fatto nella sezione Skins>Cure>Allerta",
                                      [11]  = "Disabilitarlo per un solo personaggio: \n\n" ..
                                              "     1: Apri le la sezione Generale \n" ..
                                              "     2: Metti la spunta su Disabilita HealBot \n\n\n" ..
                                              "Disabilitarlo solo quando si è soli: \n\n" ..
                                              "     1: Apri la sezione Generale \n" ..
                                              "     2: Vicino all'opzione Disabilita HealBot, seleziona Soltanto quando in solo \n" ..
                                              "     3: Metti la spunta su Disabilita HealBot",
                                      [12]  = "Cambia le impostazioni di Ancoraggio Barre nella sezione Skins>Generale \n\n" ..
                                              "     In alto a destra:        le barre verranno generate verso il basso e a sinistra \n" ..
                                              "     In alto a sinistra:      le barre verranno generate verso il basso e a destra \n" ..
                                              "     In basso a destra:     le barre verranno generate verso l'alto e a sinistra \n" ..
                                              "     In basso a sinistra:   le barre verranno generate verso l'alto e a destra",
                                      [13]  = "Miei Bersagli permette di creare una lista di Bersagli che si vogliono \n" ..
                                              "gruppare separatamente dagli altri, simile al gruppo dei MainTanks \n\n" ..
                                              "Le seguenti opzioni sono disponibili per \n" .. 
                                              "aggiungere/rimuovere personaggi al/dal gruppo Miei Bersagli \n\n" ..
                                              "     - Maiusc+Ctrl+Alt+Click destro sulla barra \n" ..
                                              '     - Usare il Menù di HealBot, inserire "hbmenu" nella sezione Incantesimi ' .. "\n" ..
                                              "     - Usare la rotellina del mouse, impostandola nella sezione Rotellina Mouse",
                                      [14]  = "I Tank Personali possono essere aggiunti alla lista Main Tanks, \n" ..
                                              "sono visibili solo nel TUO HealBot\n" ..
                                              "e non coinvolgono altri giocatori o addons \n\n" ..
                                              "Le seguenti opzioni sono disponibili per \n" ..
                                              "aggiungere/rimuovere personaggi alla/dalla lista dei Tank \n\n" ..
                                              '     - Usare il Menù di HealBot, inserire "hbmenu" nella sezione Incantesimi ' .. "\n" ..
                                              "     - Usare la rotellina del mouse, impostandola nella sezione Rotellina Mouse",
                                      
                                      [15]  = "Si \n\n"..
                                              "     1: Nella sezione Skins>Cure, abilita Focus \n" ..
                                              "     2: Imposta il tuo focus sull'NPC (o PG non in raid/gruppo) \n" ..
                                              "         Healbot creerà una barra nella tua lista Miei Bersagli \n\n" ..
                                              "Nota: Se ti trovi in una situazione di combattimento in cui entri e esci dalla zona \n" ..
                                              "         durante il combattimento e hai bisogno di risettare il focus su un NPC \n" ..
                                              "         nella sezione Skins>Cure abilita l'opzione Focus: Mostra sempre \n" ..
                                              "         Questo manterrà disponibile la barra durante il combattimento. \n\n" ..
                                              "Nota: Nel menù di HealBot c'è l'opzione 'Imposta HealBot Focus' \n" ..
                                              "         Questo può rendere più semplice l'impostare il focus su un NPC e\n" ..
                                              "         serve da promemoria per l'impostazione del focus. \n\n" ..
                                              "         Inserisci 'hbmenu' nella sezione Incantesimi per usare il menù di HealBot \n" ..
                                              "         o impostalo nella sezione Rotellina Mouse",
                                      [16]  = "1:  Nella sezione Skins>Barre, regola l'impostazione Opacità disabilitato \n" ..
                                              "2:  Nella sezione Skins>Testo Barre, regola l'impostazione dell'opacità Disabilitato \n" ..
                                              "     Per farlo clicca sulla barra chiamata Disabilitato (quella in mezzo alle altre due). \n\n" ..
                                              "Alcuni vorranno anche impostare il livello di Allerta a 100 \n" ..
                                              "Questo può essere fatto nella sezione Skins>Cure>Allerta",
                                      [17]  = "In realtà Healbot lancia esattamente quanto impostato nelle impostazioni. \n\n" .. HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                      [18]  = HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                  }

    HEALBOT_OPTIONS_SKINAUTHOR              = "Autore delle Skin:"
    HEALBOT_OPTIONS_AVOIDBLUECURSOR         = "Evita\nCursore Blu"
    HEALBOT_PLAYER_OF_REALM                 = "di"
    
    HEALBOT_OPTIONS_LANG                    = "Lingua"
    
    HEALBOT_OPTIONS_LANG_ZHCN               = "Cinese (zhCN - by Ydzzs)"
    HEALBOT_OPTIONS_LANG_ENUK               = "Inglese (enUK - by Strife)"
    HEALBOT_OPTIONS_LANG_ENUS               = "Inglese (enUS - by Strife)"
    HEALBOT_OPTIONS_LANG_FRFR               = "Francese (frFR - by Kubik)"
    HEALBOT_OPTIONS_LANG_DEDE               = "Tedesco (deDE - translator required)"
    HEALBOT_OPTIONS_LANG_HUHU               = "Ungherese (huHU - by Von)"
    HEALBOT_OPTIONS_LANG_ITIT               = "Italiana (itIT - by Brezza)"
    HEALBOT_OPTIONS_LANG_KRKR               = "Coreano (krKR - translator required)"
    HEALBOT_OPTIONS_LANG_PTBR               = "Portoghese (ptBR - by aldetal)"
    HEALBOT_OPTIONS_LANG_RURU               = "Russo (ruRU - translator required)"
    HEALBOT_OPTIONS_LANG_ESES               = "Spagnolo (esES - translator required)"
    HEALBOT_OPTIONS_LANG_TWTW               = "Taiwanese (twTW - translator required)"
    
    HEALBOT_OPTIONS_LANG_ADDON_FAIL1        = "Caricamento traduzione fallito"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL2        = "Il motivo del problema è:"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL3        = "Nota della versione corrente, questo è il solo avviso per"
    
    HEALBOT_OPTIONS_ADDON_FAIL              = "Caricamento di HealBot fallito"
    
    HEALBOT_OPTIONS_CONTENT_SKINS_GENERAL   = "    " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SKINS_HEALING   = "    " .. HEALBOT_OPTIONS_TAB_HEALING
    HEALBOT_OPTIONS_CONTENT_SKINS_HEADERS   = "        " .. HEALBOT_OPTIONS_TAB_HEADERS
    HEALBOT_OPTIONS_CONTENT_SKINS_BARS      = "        " .. HEALBOT_OPTIONS_TAB_BARS
    HEALBOT_OPTIONS_CONTENT_SKINS_ICONS     = "        " .. HEALBOT_OPTIONS_TAB_ICONS
    HEALBOT_OPTIONS_CONTENT_SKINS_AGGRO     = "    " .. HEALBOT_OPTIONS_TAB_AGGRO
    HEALBOT_OPTIONS_CONTENT_SKINS_PROT      = "    " .. HEALBOT_OPTIONS_TAB_PROTECTION
    HEALBOT_OPTIONS_CONTENT_SKINS_CHAT      = "    " .. HEALBOT_OPTIONS_TAB_CHAT
    HEALBOT_OPTIONS_CONTENT_SKINS_TEXT      = "        " .. HEALBOT_OPTIONS_TAB_TEXT
    HEALBOT_OPTIONS_CONTENT_SKINS_ICONTEXT  = "        " .. HEALBOT_OPTIONS_TAB_ICONTEXT

    HEALBOT_OPTIONS_CONTENT_CURE_DEBUFF     = "    " .. HEALBOT_SKIN_DEBTEXT
    HEALBOT_OPTIONS_CONTENT_CURE_CUSTOM     = "    " .. HEALBOT_CLASSES_CUSTOM
    HEALBOT_OPTIONS_CONTENT_CURE_WARNING    = "    " .. HEALBOT_OPTIONS_TAB_WARNING
    
    HEALBOT_SKIN_ABSORBCOL_TEXT             = "Absorb effects";
    HEALBOT_OPTIONS_BARALPHAABSORB          = "Absorb effects opacity";
    HEALBOT_OPTIONS_OUTLINE                 = "Outline"
    HEALBOT_OPTIONS_FRAME                   = "Frame"
    HEALBOT_OPTIONS_CONTENT_SKINS_FRAMES    = "    " .. "Frames"
    HEALBOT_OPTIONS_FRAMESOPTTEXT           = "Frames options"
    HEALBOT_OPTIONS_SETTOOLTIP_POSITION     = "Set Tooltip Position"
    HEALBOT_OPTIONS_FRAME_ALIAS             = "Frame Title"
    HEALBOT_OPTIONS_FRAME_ALIAS_SHOW        = "Show Title"
    HEALBOT_OPTIONS_GROW_DIRECTION          = "Grow Direction"
    HEALBOT_OPTIONS_GROW_HORIZONTAL         = "Horizontal"
    HEALBOT_OPTIONS_GROW_VERTICAL           = "Vertical"
    HEALBOT_OPTIONS_FONT_OFFSET             = "Font Offset"
    HEALBOT_OPTIONS_SET_FRAME_HEALGROUPS    = "Assign Heal Groups"
    HEALBOT_OPTION_EXCLUDEMOUNT_ON          = "Now Excluding Mount"
    HEALBOT_OPTION_EXCLUDEMOUNT_OFF         = "No longer Excluding Mount"
    HEALBOT_CMD_TOGGLEEXCLUDEMOUNT          = "Toggle Exclude Mount"
    HEALBOT_OPTIONS_HIDEMINIBOSSFRAMES      = "Hide mini boss frames";
    HEALBOT_OPTIONS_HIDERAIDFRAMES          = "Hide raid frames";
    HEALBOT_OPTIONS_FRAME_ALIAS             = "Alias"
    HEALBOT_OPTIONS_CONTENT_SKINS_HEALGROUP = "        " .. "Heal Groups"
    HEALBOT_OPTIONS_CONTENT_SKINS_BARCOLOUR = "        " .. "Bar Colors";
    HEALBOT_OPTIONS_SET_ALL_FRAMES          = "Apply current tab settings to all Frames"
    HEALBOT_WORDS_PROFILE                   = "Profile"
    HEALBOT_SHARE_SCREENSHOT                = "ScreenShot taken"
    HEALBOT_SHARE_INSTRUCTION               = "Go to the website for instrunctions on sharing with "..HEALBOT_ABOUT_URL
    HEALBOT_ENEMY_USE_FRAME                 = "Use frame"
    HEALBOT_ENEMY_INCLUDE_SELF              = "Include my target"
    HEALBOT_ENEMY_INCLUDE_TANKS             = "Include tanks targets"
    HEALBOT_OPTIONS_ENEMY_OPT               = "Enemy Options";
    HEALBOT_OPTIONS_SHARE_OPT               = "Share Options";
    HEALBOT_OPTIONS_CONTENT_SKINS_SHARE     = "    " .. "Share"
    HEALBOT_OPTIONS_CONTENT_SKINS_ENEMY     = "    " .. "Enemy"
    HEALBOT_OPTIONS_BUTTONLOADSKIN          = "Load skin"
    HEALBOT_ENEMY_NO_TARGET                 = "No target"
    HEALBOT_OPTIONS_ENEMYBARS               = "Enemy bars at all times";
    HEALBOT_OPTIONS_HARMFUL_SPELLS          = "Harmful Spells"
    HEALBOT_ENEMY_INCLUDE_MYTARGETS         = "Include My Targets targets"
    HEALBOT_ENEMY_NUMBER_BOSSES             = "Number of Bosses"
    HEALBOT_ENEMY_HIDE_OUTOFCOMBAT          = "Hide bars out of combat"
    HEALBOT_ENEMY_EXISTS_SHOW               = "Entering combat only".."\n".."show when exists"
    HEALBOT_ENEMY_EXISTS_SHOW_PTARGETS      = "Player targets"
    HEALBOT_ENEMY_EXISTS_SHOW_BOSSES        = "Boss bars"
end
