if GetLocale() ~= "deDE" then return end
if not DBM_GUI_Translations then DBM_GUI_Translations = {} end
local L = DBM_GUI_Translations

L.MainFrame = "Deadly Boss Mods"

L.TranslationByPrefix		= "Übersetzt von "
L.TranslationBy 			= "Ebmor@EU-Malorne"
L.Website					= "Besuche unsere neuen Diskussions- und Support-Foren: |cFF73C2FBwww.deadlybossmods.com|r (gehostet von Elitist Jerks!)"
L.WebsiteButton				= "Foren"

L.OTabBosses	= "Bosse"
L.OTabOptions	= "Optionen"

L.TabCategory_Options	 	= "Allgemeine Einstellungen"
L.TabCategory_MOP	 		= "Mists of Pandaria"
L.TabCategory_CATA	 		= "Cataclysm"
L.TabCategory_WOTLK 		= "Wrath of the Lich King"
L.TabCategory_BC 			= "The Burning Crusade"
L.TabCategory_CLASSIC		= "Classic"
L.TabCategory_PVP 			= "PvP"
L.TabCategory_OTHER    		= "Sonstige Boss Mods"

L.BossModLoaded 			= "Statistiken von %s"
L.BossModLoad_now 			= [[Dieses Boss Mod ist nicht geladen. Es wird automatisch geladen, wenn du die Instanz betrittst. Du kannst auch auf den Button klicken um das Boss Mod manuell zu laden.]]



L.PosX						= 'Position X'
L.PosY						= 'Position Y'

L.MoveMe 					= 'Positionieren'
L.Button_OK 				= 'OK'
L.Button_Cancel 			= 'Abbrechen'
L.Button_LoadMod 			= 'Lade Boss Mod'
L.Mod_Enabled				= "Aktiviere Boss Mod"
L.Mod_Reset					= "Lade Standardeinstellungen"
L.Reset 					= "Zurücksetzen"

L.Enable  					= "Aktiviert"
L.Disable					= "Deaktiviert"

L.NoSound					= "Kein Sound"

L.IconsInUse				= "Von diesem Mod benutzte Zeichen"

-- Tab: Boss Statistics
L.BossStatistics			= "Boss Statistiken"
L.Statistic_Kills			= "Siege:"
L.Statistic_Wipes			= "Niederlagen:"
L.Statistic_Incompletes		= "Abgebrochen:"
L.Statistic_BestKill		= "Schnellster:"

-- Tab: General Core Options
L.General 					= "Allgemeine Grundeinstellungen"
L.EnableDBM 				= "Aktiviere DBM"
L.EnableMiniMapIcon			= "Aktiviere Minimap-Symbol"
L.SetPlayerRole				= "Automatisch eigene Rolle (Schutz/Heilung/Schaden) setzen (empfohlen)"
L.UseMasterVolume			= "Benutze Master-Audiokanal um DBM-Sounddateien abzuspielen"
L.LFDEnhance				= "Spiele \"Bereitschaftscheck\"-Sound für Rollenabfragen und Einladungen der Gruppensuche im Master-Audiokanal"
L.AutologBosses				= "Automatische Aufzeichnung von Bosskämpfen im spieleigenen Kampflog"
L.AdvancedAutologBosses		= "Automatische Aufzeichnung von Bosskämpfen mit Addon \"Transcriptor\""
L.LogOnlyRaidBosses			= "Nur Schlachtzugbosskämpfe aufzeichnen\n(ohne Schlachtzugsbrowser-/Dungeon-/Szenarien-/Weltbosskämpfe)"
L.Latency_Text				= "Maximale Synchronisierungslatenz: %d"
-- Tab: General Timer Options
L.TimerGeneral 				= "Allgemeine Einstellungen für Timer"
L.SKT_Enabled				= "Zeige immer Timer für schnellsten Sieg (ignoriert Boss-spezifische Einstellung)"
L.ChallengeTimerOptions		= "Timer für den schnellsten Abschluss im Herausforderungsmodus"
L.ChallengeTimerPersonal	= "Persönliche Bestzeit"
L.ChallengeTimerGuild		= "Bestzeit der Gilde"
L.ChallengeTimerRealm		= "Bestzeit des Realms"

L.ModelOptions				= "Einstellungen für 3D-Modellanzeige"
L.EnableModels				= "Aktiviere 3D-Modelle in den Bosseinstellungen"
L.ModelSoundOptions			= "Setze Soundeinstellung für Modellanzeige"
L.ModelSoundShort			= "Kurz"
L.ModelSoundLong			= "Lang"

L.Button_RangeFrame			= "Zeige/Verberge Abstandsfenster"
L.Button_RangeRadar			= "Zeige/Verberge Abstandsradar"
L.Button_InfoFrame			= "Zeige/Verberge Infofenster"
L.Button_TestBars			= "Starte Testbalken"

L.PizzaTimer_Headline 		= 'Erstelle einen "Pizza-Timer"'
L.PizzaTimer_Title			= 'Name (z.B. "Pizza!")'
L.PizzaTimer_Hours 			= "Stunden"
L.PizzaTimer_Mins 			= "Min"
L.PizzaTimer_Secs 			= "Sek"
L.PizzaTimer_ButtonStart 	= "Starte Timer"
L.PizzaTimer_BroadCast		= "Anderen Schlachtzugspielern anzeigen"

-- Tab: Raidwarning
L.Tab_RaidWarning 			= "Schlachtzugwarnungen"
L.RaidWarning_Header		= "Einstellungen für Schlachtzugwarnungen"
L.RaidWarnColors 			= "Farben für Schlachtzugwarnungen"
L.RaidWarnColor_1 			= "Farbe 1"
L.RaidWarnColor_2 			= "Farbe 2"
L.RaidWarnColor_3		 	= "Farbe 3"
L.RaidWarnColor_4 			= "Farbe 4"
L.InfoRaidWarning			= [[Hier werden Position und Farben des Fensters für Schlachtzugwarnungen festgelegt. Dieses Fenster wird für Nachrichten wie "Spieler X ist betroffen von Y" verwendet.]]

L.ColorResetted 			= "Diese Farbeinstellung wurde zurückgesetzt."
L.ShowWarningsInChat 		= "Zeige Warnungen im Chatfenster"
L.ShowFakedRaidWarnings 	= "Zeige Warnungen als künstliche Schlachtzugwarnungen"
L.WarningIconLeft 			= "Zeige Symbol links an"
L.WarningIconRight 			= "Zeige Symbol rechts an"
L.WarningIconChat 			= "Zeige Symbole im Chatfenster"
L.ShowCountdownText			= "Zeige Countdown-Text"
L.RaidWarnMessage 			= "Danke, dass du Deadly Boss Mods verwendest"
L.BarWhileMove 				= "bewegbare Schlachtzugwarnung"
L.RaidWarnSound				= "Sound für Schlachtzugwarnung"
L.CountdownVoice			= "Primäre Stimme für akustische Zählungen"
L.CountdownVoice2			= "Sekundäre Stimme für akustische Zählungen"
L.SpecialWarnSound			= "Sound für Spezialwarnungen, die dich oder deine Rolle betreffen"
L.SpecialWarnSound2			= "Sound für Spezialwarnungen, die jeden betreffen"
L.SpecialWarnSound3			= "Sound für SEHR wichtige Spezialwarnungen"

-- Tab: Generalwarnings
L.Tab_GeneralMessages 		= "Allgemeine Meldungen"
L.CoreMessages				= "Systemmeldungen"
L.ShowLoadMessage 			= "Zeige Lademeldungen für Mods im Chatfenster"
L.ShowPizzaMessage 			= "Zeige Meldungen für Timerbroadcasts im Chatfenster"
L.CombatMessages			= "Kampfmeldungen"
L.ShowEngageMessage 		= "Zeige Meldungen für den Beginn von Kämpfen im Chatfenster"
L.ShowKillMessage 			= "Zeige Meldungen für Siege im Chatfenster"
L.ShowWipeMessage 			= "Zeige Meldungen für Niederlagen im Chatfenster"
L.ShowRecoveryMessage 		= "Zeige Meldungen für Neukalibrierung der Timer im Chatfenster"
L.WhisperMessages			= "Flüstermeldungen"
L.AutoRespond 				= "Aktiviere automatische Antwort während eines Bosskampfes"
L.EnableStatus 				= "Antworte auf 'status'-Flüsteranfragen"
L.WhisperStats 				= "Füge Sieg-/Niederlagestatistik den Flüsterantworten hinzu"

-- Tab: Barsetup
L.BarSetup   				= "Balkenstil"
L.BarTexture 				= "Balkentextur"
L.BarStartColor				= "Startfarbe"
L.BarEndColor 				= "Endfarbe"
L.ExpandUpwards				= "Erweitere Balken nach oben"
L.Bar_Font					= "Schriftart für Balken"
L.Bar_FontSize				= "Schriftgröße"
L.Slider_BarOffSetX 		= "Abstand X: %d"
L.Slider_BarOffSetY 		= "Abstand Y: %d"
L.Slider_BarWidth 			= "Breite: %d"
L.Slider_BarScale 			= "Skalierung: %0.2f"
L.AreaTitle_BarSetup		= "Allgemeine Balkeneinstellungen"
L.AreaTitle_BarSetupSmall 	= "Einstellungen für kleine Balken"
L.AreaTitle_BarSetupHuge	= "Einstellungen für große Balken"
L.BarIconLeft 				= "Symbol links"
L.BarIconRight 				= "Symbol rechts"
L.EnableHugeBar 			= "Aktiviere große Balken (Balken 2)"
L.FillUpBars				= "Balken auffüllen"
L.ClickThrough				= "Mausereignisse deaktivieren (macht die Balken durchklickbar)"

-- Tab: Spec Warn Frame
L.Panel_SpecWarnFrame		= "Spezialwarnungen"
L.Area_SpecWarn				= "Einstellungen für Spezialwarnungen"
L.SpecWarn_Enabled			= "Zeige Spezialwarnungen für Bossfähigkeiten"
L.SpecWarn_FlashFrame		= "Aktiviere aufblinkenden Bildschirm bei Spezialwarnungen"
L.SpecWarn_AdSound			= "Erweiterte Soundeinstellungen für Spezialwarnungen (benötigt /reload)"
L.SpecWarn_Font				= "Schriftart für Spezialwarnungen" --unused
L.SpecWarn_FontSize			= "Schriftgröße: %d"
L.SpecWarn_FontColor		= "Schriftfarbe"
L.SpecWarn_FontType			= "Schriftart für Spezialwarnungen"
L.SpecWarn_FlashColor		= "Blinkfarbe"
L.SpecWarn_FlashDur			= "Blinkdauer: %0.1f"
L.SpecWarn_FlashAlpha		= "Blinkalpha: %0.1f"
L.SpecWarn_DemoButton		= "Zeige Beispiel"
L.SpecWarn_MoveMe			= "Positionieren"
L.SpecWarn_ResetMe			= "Zurücksetzen"

-- Tab: HealthFrame
L.Panel_HPFrame				= "Lebensanzeige"
L.Area_HPFrame				= "Einstellungen für die Lebensanzeige"
L.HP_Enabled				= "Lebensanzeige immer anzeigen (ignoriert Boss-spezifische Einstellung)"
L.HP_GrowUpwards			= "Erweitere Lebensanzeige nach oben"
L.HP_ShowDemo				= "Anzeigen"
L.BarWidth					= "Balkenbreite: %d"

-- Tab: Spam Filter
L.Panel_SpamFilter				= "Filter / Spam-Filter"
L.Area_SpamFilter				= "Spam-Filter"
L.StripServerName				= "Entferne den Realmnamen der Spieler in Warnungen und Timern"
L.SpamBlockBossWhispers			= "Aktiviere Filter für &lt;DBM&gt;-Flüstermitteilungen im Kampf"
L.BlockVersionUpdateNotice		= "Zeige Update-Meldung im Chatfenster statt als Popup (nicht empfohlen)"
L.ShowBigBrotherOnCombatStart	= "Führe bei Kampfbeginn eine \"BigBrother\"-Buffprüfung durch"
L.BigBrotherAnnounceToRaid		= "Verkünde Ergebnis der \"BigBrother\"-Buffprüfung zum Schlachtzug"

L.Area_SpamFilter_Outgoing		= "globale Filtereinstellungen"
L.SpamBlockNoShowAnnounce		= "Zeige keine Mitteilungen und spiele keine Warnungssounds"
L.SpamBlockNoSendWhisper		= "Sende keine Flüstermitteilungen an andere Spieler"
L.SpamBlockNoSetIcon			= "Setze keine Zeichen auf Ziele"
L.SpamBlockNoRangeFrame			= "Zeige kein Abstandsfenster/-radar an"
L.SpamBlockNoInfoFrame			= "Zeige kein Infofenster an"

L.Area_PullTimer				= "Filtereinstellungen für Pull-Timer"
L.DontShowPTNoID				= "Blockiere Pull-Timer, die nicht aus deiner derzeitigen Zone gesendet worden sind"
L.DontShowPT					= "Zeige keinen Timerbalken für Pull-Timer"
L.DontShowPTText				= "Zeige keine Mitteilungen für Pull-Timer im Chatfenster"
L.DontPlayPTCountdown			= "Spiele keinen akustischen Countdown für Pull/Kampfbeginn-Timer"
L.DontShowPTCountdownText		= "Zeige keinen optischen Countdown für Pull/Kampfbeginn-Timer"
L.PT_Threshold					= "Zeige keinen optischen Countdown für Pull/Kampfbeginn-Timer über: %d"


L.Panel_HideBlizzard			= "Verberge Spielelemente"
L.Area_HideBlizzard				= "Einstellungen zum Verbergen von Spielelementen"
L.HideBossEmoteFrame			= "Verberge das Fenster \"RaidBossEmoteFrame\" während Bosskämpfen"
L.HideWatchFrame				= "Verberge das Fenster für die Questverfolgung während Bosskämpfen"
L.SpamBlockSayYell				= "Sprechblasen-Ansagen im Chatfenster ausblenden"
L.DisableCinematics				= "Verberge Videosequenzen"
L.AfterFirst					= "Nach jeweils einmaligem Abspielen"
L.Always						= "Immer"

-- Misc
L.FontHeight	= 16
