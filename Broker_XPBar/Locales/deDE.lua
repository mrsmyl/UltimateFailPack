--[[ *******************************************************************
Project                 : Broker_XPBar
Description             : German translation file (deDE)
Author                  : tritium
Translator              : tritium
Revision                : $Rev: 1 $
********************************************************************* ]]

local MODNAME   = "BrokerXPBar"

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(MODNAME, "deDE")
if not L then return end

L["Bar Properties"] = "Balkeneigenschaften"
L["Set the Bar Properties"] = "Setzen der Leisteneigenschaften"

L["Show XP Bar"] = "Zeige XP-Leiste"
L["Show the XP Bar"]  = "Zeige den XP-Leiste"
L["Show Rep Bar"] = "Zeige Rufleiste"
L["Show the Reputation Bar"] = "Zeige den Rufleiste"
L["Spark intensity"] = "Halointensität"
L["Brightness level of Spark"] = "Helligkeit der Halo"
L["Thickness"] = "Dicke"
L["Set thickness of the Bars"] = "Setzt die Dicke der XP-Balkens"
L["Shadow"] = "Schatten"
L["Toggle Shadow"] = "Aktiviert den Schattenwurf"

L["Frame"] = "Frame"
L["Frame Connection Properties"] = "Frame Einstellungen"

L["Frame to attach to"] = "Anbringen an Frame"
L["The exact name of the frame to attach to"] = "Exakter Name des Frames an dem die Leisten angehangen werden"
L["Select by Mouse"] = "Auswahl per Maus"
L["Click to activate the frame selector. (Left-Click to select frame, Right-Click do deactivate selector)"] = "Klicken um Frame-Auswahl zu aktivieren. (Links-Klick um Frame zu wählen, Rechts-Klick für Abbruch)"
L["This frame has no global name and cannot be used"] = "Dieser Frame hat keinen globalen Namen und kann nicht verwendet werden"
L["Attach to side"] = "Anbringen an Seite"
L["Select side to attach the bars to"] = "Wähle Seite des Frames an die die Leisten angebracht werden"
L["X-Offset"] = "X-Versatz"
L["Set x-Offset of the bars"] = "Setzt den x-Versatz der Leisten"
L["Y-Offset"] = "Y-Versatz"
L["Set y-Offset of the bars"] = "Setzt den y-Versatz der Leisten"
L["Strata"] = "Anzeigeschicht"
L["Select the strata of the bars"] = "Wähle Anzeigeschicht der Leisten"
L["Inside"] = "Innen"
L["Attach bars to the inside of the frame"] = "Leisten an der Frame-Innenseite anbringen"
L["Inverse Order"] = "Inverse Ordnung"
L["Place reputation bar before XP bar"] = "Platziert die Rufleiste vor die XP-Leiste"
L["Jostle"] = "Verschieben"
L["Jostle Blizzard Frames"] = "Verschiebe Blizzard-Frames"
L["Refresh"] = "Auffrischen"
L["Refresh Bar Position"] = "Auffrischen der Leistenanzeige"

L["Colors"] = "Farben"
L["Set the Bar Colors"] = "Setzen der Leistenfarben"

L["Current XP"] = "Aktuelle XP"
L["Set the color of the XP Bar"] = "Setzen der Farbe der XP-Leiste"
L["Rested XP"] = "Ruhe-XP"
L["Set the color of the Rested Bar"] = "Setzen der Farbe der Ruheleiste"
L["No XP"] = "Ohne XP"
L["Set the empty color of the XP Bar"] = "Setzen der Leerfarbe der XP-Leiste"
L["Reputation"] = "Ruf"
L["Set the color of the Rep Bar"] = "Setzen der Farbe der Rufleiste"
L["No Rep"] = "Ohne Ruf"
L["Set the empty color of the Reputation Bar"] = "Setzen der Leerfarbe der Rufleiste"
L["Blizzard Rep Colors"] = "Blizzard-Ruffarben"
L["Toggle Blizzard Reputation Colors"] = "Umschalten auf Blizzard-Ruffarben"

L["Broker Label"] = "Broker Text"
L["Broker Label Properties"] = "Broker Testeinstellungen"

L["Select Label Text"] = "Wähle Beschriftung"
L["Select label text for Broker display"] = [[Wähle Beschriftung für Broker-Anzeige:
|cffffff00Nichts|r - Zeigt Namen des Addon.
|cffffff00Kills bis Stufenaufstieg|r - Zeigt wieviele Kills etwa benötigt werden bis zum nächsten Stufenaufstieg.
|cffffff00Zeit bis Stufenaufstieg|r - Zeigt ungefähre Zeit bis zum nächsten Stufenaufstieg.
|cffffff00Ruf|r - Zeigt Ruffraktion, Ruf und Prozent der aktuellen Rufstufe.
|cffffff00XP|r - Zeigt XP and Prozent der aktuellen Stufe.
|cffffff00Ruf vor XP|r - Zeigt normalerweise Ruf und Schaltet auf XP um, wenn keine Fraktion beobachtet wird.
|cffffff00XP vor Ruf|r - Zeigt XP bis maximale Stufe erreicht, danach Ruf.]]

L["XP/Rep to go"] = "XP/Ruf verbleibend"
L["Show XP/Rep to go in label"] = "Zeige verbleibende XP/Ruf in Beschriftung"
L["Percentage only"] = "Nur Prozentwert"
L["Show percentage only"] = "Nur Prozentwert anzeigen"
L["Show faction name"] = "Zeige Fraktionsnamen"
L["Show faction name when reputation is selected as label text."] = "Zeige Fraktionsnamen, wenn wenn Ruf als Textoption gewählt wurde."
L["Colored Label"] = "Beschriftung färben"
L["Color label text based on percentages"] = "Beschriftung basierend auf Prozentwerten färben"

L["Faction Tracking"] = "Fraktion verfolgen"
L["Auto-switch watched faction on reputation gains/losses."] = "Beobachtete Fraktion folgt automatisch Rufänderungen"

L["Switch on rep gain"] = "Wechsel bei Rufgewinn"
L["Auto-switch watched faction on reputation gain."] = "Automatischer Wechsel der beobachteten Fraktion bei Rufgewinn."
L["Switch on rep loss"] = "Wechsel bei Rufverlust"
L["Auto-switch watched faction on reputation loss."] = "Automatischer Wechsel der beobachteten Fraktion bei Rufverlust."

L["Leveling"] = "Leveln"
L["Leveling Properties"] = "Einstellungen beim Leveln"

L["Time Frame"] = "Zeitrahmen"
L["Time frame for dynamic TTL calculation."] = "Zeitrahmen für dynamische Berechnung der Zeit bis Stufe."
L["Weight"] = "Wichtung"
L["Weight time frame vs. session average for dynamic TTL calculation."] = "Wichtung Zeitrahmen zu Session-Durchschnitt für dynamische Berechnung der Zeit bis Stufe."

L["Max. XP/Rep"] = "Max. XP/Ruf"
L["Display settings at maximum level/reputation"] = "Anzeigeeinstellungen auf maximaler Stufe / maximalem Ruf"

L["No XP label"] = "Kein XP-Text"
L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."] = "Broker-Text für XP auf max. Stufe verbergen. Betrifft nur XP basierte Textoptionen."
L["No XP bar"] = "Keine XP-Leiste"
L["Don't show XP bar at maximum level."] = "XP-Leiste auf maximaler Stufe verbergen."
L["No Rep label"] = "Kein Ruftext"
L["Don't show label text at maximum Reputation. Affects Rep option only."] = "Broker-Text für Ruf bei max. Ruf verbergen. Nur bei Ruf als Textoptionen."
L["No Rep bar"] = "Keine Rufleiste"
L["Don't show Rep bar at maximum Reputation."] = "Rufleiste bei maximalem Ruf verbergen."

L["Faction"] = "Fraktion"
L["Select Faction"] = "Wähle Fraktion"
L["Blizzard Bars"] = "Blizzard-Leisten"
L["Show default Blizzard Bars"] = "Zeige normale Blizzard-Leisten"
L["Minimap Button"] = "Minimap Button"
L["Show Minimap Button"] = "Zeige Minimap Button"
L["Hide Hint"] = "Hinweis verbergen"
L["Hide usage hint in tooltip"] = "Bedienhinweise im Tooltip verbergen"

L["Max Level"] = "Max. Stufe"
L["No watched faction"] = "Keine beobachte Fraktion"

L["%s: %3.0f%% (%s/%s) %s left"] = "%s: %3.0f%% (%s/%s) %s übrig"

L["Current XP"] = "Aktuelle XP"
L["To Level"] = "Bis Stufe"
L["Rested XP"] = "Ruhe-XP"

L["Rep to next standing"] = "Ruf bis zur nächsten Rufstufe"
L["Current rep"] = "Aktueller Ruf"

L["Session XP"] = "Session XP"
L["XP per hour"] = "XP pro Stunde"
L["Kills per hour"] = "Kills pro Stunde"
L["Time to level"] = "Zeit bis Stufenaufstieg"
L["Kills to level"] = "Kills bis Stufenaufstieg"

L["Click"] = "Klick"
L["Shift-Click"] = "Umschalt-Klick"
L["Right-Click"] = "Rechts-Klick"
L["Send current XP to an open editbox."] = "Fügt aktuelle XP in offenes Chat-Eingabefeld ein."
L["Send current reputation to an open editbox."] = "Fügt aktuellen Ruf in offenes Chat-Eingabefeld ein."
L["Open option menu."] = "Öffne Optionsmenü"

L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"] = "%s/%s (%3.0f%%) %d übrig (%3.0f%% gerastet)"
L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"] = "%s:%s/%s (%3.2f%%) Aktuell %s mit %d übrig"

L["Usage:"] = "Verwendung:"
L["/brokerxpbar arg"] = "/brokerxpbar arg"
L["/bxb arg"] = "/bxb arg"
L["Args:"] = "Argumente:"
L["version - display version information"] = "version - Versionsinformation anzeigen"
L["menu - display options menu"] = "menu - Optionsmenü anzeigen"
L["help - display this help"] = "help - diese Hilfe anzeigen"

L["Maximum level reached."] = "Maximale Stufe erreicht."
L["Currently no faction tracked."] = "Derzeit keine Fraktion gewählt."
L["Version"] = "Version"

L["Top"] = "Oben" 
L["Bottom"] = "Unten"
L["Left"] = "Links" 
L["Right"] = "Rechts"

L["XP"] = "XP"
L["Rep"] = "Ruf"
L["None"] = "Nichts"
L["Kills to Level"] = "Kills bis Stufenaufstieg"
L["Time to Level"] = "Zeit bis Stufenaufstieg"
L["XP over Rep"] = "XP vor Ruf"
L["Rep over XP"] = "Ruf vor XP"
