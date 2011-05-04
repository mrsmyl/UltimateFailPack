--[[
************************************************************************
Project				: Broker_HitCrit
Author				: zhinjio
Project Revision	: 2.22.0-release
Project Date		: 20110428045833

File				: Locales\frFR.lua
Commit Author		: zhinjio
Commit Revision		: 57
Commit Date			: 20090116200236
************************************************************************
Description	:
	French translation strings
TODO		:
************************************************************************
(see bottom of file for changelog)
************************************************************************
--]]
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale("HitCrit", "frFR")
if not L then return end

L["%s for %s against %s"] = "%s pour %s contre %s"
L["ALERT_CHATFRAME_DESC"] = "Cochez pour alerter dans la fenêtre de discussion par défaut"
-- L["ALERT_MSBTAREA_DESC"] = "Check to alert in an MSBT Scroll Area"
-- L["ALERT_MSBT_DESC"] = "Options to receive alerts in MikScrollingBattleText Scroll Areas"
L["ALERT_NOTIFY_DESC"] = "Cochez pour alerter avec un message dans la zone de notification"
L["ALERT_OPTIONS_DESC"] = "Options qui modifient la manière dont HitCrit vous avertit quand vous obtenez une nouvelles grande valeur"
-- L["ALERT_PARROTAREA_DESC"] = "Check to alert in a Parrot Scroll Area"
-- L["ALERT_PARROT_DESC"] = "Options to receive alerts in Parrot Scroll Areas. Only enabled if Parrot is installed."
L["ALERT_SCREENIE_DESC"] = "Cochez pour prendre une capture d'écran à chaque nouvelle grande valeur"
-- L["ALERT_SELECTMSBTAREA_DESC"] = "Select the MSBT Scroll Area to use"
-- L["ALERT_SELECTPARROTAREA_DESC"] = "Select the Parrot Scroll Area to use"
L["ALERT_SOUND_DESC"] = "Cochez pour alerter avec un son"
-- L["ALERT_SUPERBUFF_TOGGLE"] = "Check to disable superbuff notifications in chatframe"
-- L["ARGENT_TOGGLE_DESC"] = "Suppress Argent Tourney spells"
L["Against"] = "Contre"
L["Alert Options"] = "Options d'alerte"
L["Alert in Chat Frame"] = "Alerte dans la fenêtre de discussion"
-- L["Alert in MSBT Scroll Area"] = "Alert in MSBT Scroll Area"
-- L["Alert in Parrot Scroll Area"] = "Alert in Parrot Scroll Area"
L["Alert with Notify"] = "Alerte avec notification"
L["Alert with Sound"] = "Alerte sonore"
-- L["Alt-Left-click to delete values"] = "Alt-Left-click to delete values"
-- L["Alt-Right-click for to see Alternate Spec"] = "Alt-Right-click for to see Alternate Spec"
-- L["Alt-Right-click to see Active Spec"] = "Alt-Right-click to see Active Spec"
-- L["Alt-Right-click to see Inactive Spec"] = "Alt-Right-click to see Inactive Spec"
-- L["Argent Tourney"] = "Argent Tourney"
L["Author : "] = "Auteur : "
L["Avg"] = "Moy"
L["Broker_HitCrit"] = "HitCrit"
L["Build Date : "] = "Date du Build : "
-- L["Color Label Text"] = "Color Label Text"
L["Crit"] = "Crit"
L["Critical Heal"] = "Soin Critique"
L["Critical Hit"] = "Coup Critique"
L["DISPLAY_AVG_DESC"] = "Cochez pour inclure la colonne 'Moy'"
-- L["DISPLAY_COLORLABEL_DESC"] = "Click to enable LDB text coloring. Disabling this lets the LDB bar addon handle the coloring."
L["DISPLAY_CRIT_DESC"] = "Cochez pour afficher la colonne 'Crit'"
L["DISPLAY_DEBUG_DESC"] = "Cochez pour afficher les informations de Debug"
L["DISPLAY_ENEMYNAME_DESC"] = "Cochez pour afficher le nom de l'ennemi"
L["DISPLAY_HIT_DESC"] = "Cochez pour inclure la colonne 'Coup'"
-- L["DISPLAY_LABELDMG_DESC"] = "Check to display top damage values on the LDB Bar"
L["DISPLAY_LABELHEAL_DESC"] = "Cochez pour afficher les plus grandes valeurs de soin au lieu des dégâts dans le texte du Label"
L["DISPLAY_LABEL_DESC"] = "Cochez pour afficher les plus grandes valeurs de HitCrit dans le texte du Label"
L["DISPLAY_OPTIONS_DESC"] = "Options qui modifient la manière dont les données sont affichées dans la tooltip"
L["DISPLAY_SORTSCHOOL_DESC"] = "Cochez pour trier les données par école de magie"
-- L["DMG_GLOBAL_TOGGLE_DESC"] = "Toggle to affect all schools at once"
-- L["DMG_SCHOOLS_DESC"] = "Per school damage tracking inclusion"
L["Damage"] = "Dégâts"
-- L["Damage Schools"] = "Damage Schools"
L["Database Version : "] = "Version de la base de données: "
L["Database upgraded to %s"] = "Base de données mise à jour vers %s"
-- L["Detect Superbuffs"] = "Detect Superbuffs"
L["Display Avg"] = "Afficher Moy"
L["Display Crit"] = "Afficher Crit"
L["Display Debug"] = "Afficher le Debug"
-- L["Display Dmg in Label"] = "Display Dmg in Label"
L["Display Enemy Name"] = "Afficher le nom de l'ennemi"
L["Display Heal in Label"] = "Afficher les soins dans le Label"
L["Display Hit"] = "Afficher Coup"
L["Display Options"] = "Options d'affichage"
L["Display Top Values"] = "Afficher les plus grandes valeurs dans le Label"
-- L["Draws the icon on the minimap."] = "Draws the icon on the minimap."
L["Effect"] = "Effet"
-- L["Error occurred in the tooltip. I could not report for category (%s) and spell (%s)."] = "Error occurred in the tooltip. I could not report for category (%s) and spell (%s)."
L["GENERAL_INFO_DESC"] = "Version et informations sur l'auteur"
L["General Information"] = "Informations générales"
-- L["Global Damage Toggle"] = "Global Damage Toggle"
-- L["Global Healing Toggle"] = "Global Healing Toggle"
-- L["HEAL_GLOBAL_TOGGLE_DESC"] = "Toggle to affect all schools at once"
-- L["HEAL_SCHOOLS_DESC"] = "Per school healing tracking inclusion"
L["Heal"] = "Soin"
L["Healing"] = "Soin"
-- L["Healing Schools"] = "Healing Schools"
L["Helpful Translators (thank you) : %s"] = "Traducteurs (merci) : %s"
L["Hit"] = "touche"
L["HitCrit Data Browser"] = "HitCrit Data Browser"
-- L["Inactive Spec"] = "Inactive Spec"
-- L["LDB Text Display Options"] = "LDB Text Display Options"
-- L["LDBDISPLAY_OPTIONS_DESC"] = "Options that change the text displayed on the LDB Bar"
L["Left-click for Data Browser"] = "Clic-gauche pour ouvrir le Data Browser"
-- L["Left-click to Report values in chat"] = "Left-click to Report values in chat"
-- L["MINIMAP_OPTIONS_DESC"] = "Options regarding the minimap icon"
-- L["MISCDISPLAY_OPTIONS_DESC"] = "Other options"
-- L["MSBT Integration"] = "MSBT Integration"
L["Melee"] = "Mêlée"
-- L["Minimap Icon Options"] = "Minimap Icon Options"
-- L["Miscellaneous"] = "Miscellaneous"
-- L["Miscellaneous Display Options"] = "Miscellaneous Display Options"
L["New Record %s! %s %s %s for %d"] = "Nouveau record %s! %s %s %s pour %d"
L["No"] = "No"
-- L["Notes"] = "Notes"
-- L["Parrot Integration"] = "Parrot Integration"
-- L["Please note: All spell suppression, tracking and expansion toggles have been reset."] = "Please note: All spell suppression, tracking and expansion toggles have been reset."
-- L["Please report this error on the project webpage."] = "Please report this error on the project webpage."
L["RESETALL_TOOLTIP"] = "Cliquez pour remettre à zéro toutes les données sauvegardées de HitCrit pour ce personnage"
L["RESETCATEGORY_TOOLTIP"] = "Cliquez pour remettre à zéro les données de HitCrit de la catégorie sélectionnée pour ce personnage"
L["RESETENTRY_TOOLTIP"] = "Cliquez pour remettre à zéro les données de HitCrit de la catégorie, de l'école et des entrées sélectionnées pour ce personnage"
L["RESETSCHOOL_TOOLTIP"] = "Cliquez pour remettre à zéro les données de HitCrit de la catégorie et de l'école sélectionnées pour ce personnage"
L["RESETSPECIFIC_TOOLTIP"] = "Cliquez pour remettre à zéro les données spécifiques de HitCrit sélectionnées pour ce personnage"
L["Reset ALL data for '%s'. Are you sure?"] = "Remettre à zéro toutes les données pour '%s'. Etes-vous sûr?"
L["Reset All Data"] = "Remettre à zéro toutes les données"
L["Reset Category Data"] = "Remettre à zéro toutes les données de catégorie"
-- L["Reset Category: %s, School: %s. Are you sure?"] = "Reset Category: %s, School: %s. Are you sure?"
-- L["Reset Category: %s. Are you sure?"] = "Reset Category: %s. Are you sure?"
L["Reset Entry Data"] = "Remettre à zéro les entrées"
L["Reset School Data"] = "Remettre à zéro les données d'école"
L["Reset Specific Data"] = "Remise à zéro de données spécifiques"
-- L["Reset all entries for spell: %s. Are you sure?"] = "Reset all entries for spell: %s. Are you sure?"
L["Reset data for '%s' - '%s'. Are you sure?"] = "Remettre à zéro les données pour '%s' - '%s'. Etes-vous sûr?"
L["Reset data for '%s' - Category: %s, School: %s. Are you sure?"] = "Remettre à zéro les données pour '%s' - Catégorie: %s, Ecole: %s. Etes-vous sûr?"
L["Reset data for '%s' - Category: %s. Are you sure?"] = "Remettre à zéro les données pour '%s' - Catégorie: %s. Etes-vous sûr?"
L["Reset data for '%s' - Spell: %s. Are you sure?"] = "Remettre à zéro les données pour '%s' - Sort: %s. Etes-vous sûr?"
-- L["Reset first %s entry for spell: %s. Are you sure?"] = "Reset first %s entry for spell: %s. Are you sure?"
L["Right-click for Configuration"] = "Clic-droit pour configurer"
-- L["SUPPRESS_DMG_DESC"] = "Damage spell schools checked below WILL NOT be included in the tooltip."
-- L["SUPPRESS_HEAL_DESC"] = "Healing spell schools checked below WILL NOT be included in the tooltip."
-- L["SUPPRESS_MISC_DESC"] = "Miscellaneous Suppressions"
-- L["SUPPRESS_NOTES_DESC"] = "Suppression by selected schools only works if 'Sort by Schools' is turned on in the Display Options. Turning ALL schools on or off will still work, however."
-- L["SUPPRESS_OPTIONS_DESC"] = "Options pertaining to the suppression of spell schools in the toolip. Note that these are independent of whether data is being gathered for these schools or not."
-- L["Select MSBT Scroll Area"] = "Select MSBT Scroll Area"
-- L["Select Parrot Scroll Area"] = "Select Parrot Scroll Area"
-- L["Show Minimap Icon"] = "Show Minimap Icon"
L["Sort by School"] = "Trier par Ecole"
-- L["Suppression Options"] = "Suppression Options"
-- L["TOOLTIP_DELAY_DESC"] = "Time (in seconds) that the tooltip will remain after moving mouse away"
L["TOOLTIP_SCALE_DESC"] = "Faites glisser pour modifier l'échelle de la tooltip"
L["TRACKING_OPTIONS_DESC"] = "Options qui modifient la manière dont les données sont recueillies"
L["TRACK_AGAINSTME_DESC"] = "Cochez pour détecter les coups qui vous sont portés"
L["TRACK_DAMAGE_DESC"] = "Cochez pour détecter les dégâts"
-- L["TRACK_DETECT_SP"] = "If checked, HitCrit will disable when superbuffs/vehicles are active"
L["TRACK_ENVIRONMENTAL_DESC"] = "Cochez pour détecter les dégâts de l'environment qui vous sont infligés"
L["TRACK_HEALING_DESC"] = "Cochez pour détecter les soins"
L["TRACK_LOWLEVEL_DESC"] = "Cochez pour détecter les données envers les monstres de bas niveau"
L["TRACK_PVP_DESC"] = "Cochez pour détecter lors des combats JcJ"
L["TRACK_VULNERABLE_DESC"] = "Cochez pour détecter les données envers les cibles vulnérables"
L["Take Screenshot"] = "Prendre une capture d'écran"
-- L["Tooltip Auto-hide Delay"] = "Tooltip Auto-hide Delay"
L["Tooltip Scale"] = "Echelle de la tooltip"
L["Track Damage"] = "Détecter les dégâts"
L["Track Environmental"] = "Détecter l'environment"
L["Track Healing"] = "Détecter les soins"
L["Track Hits Against Me"] = "Détecter les coups portés contre moi"
L["Track Low Level"] = "Détecter les bas niveaux"
L["Track PvP"] = "Détecter en JcJ"
L["Track Vulnerable"] = "Détecter les vulnérables"
L["Tracking Options"] = "Options de détection"
-- L["Turn off Superbuff Alerts"] = "Turn off Superbuff Alerts"
L["Version : "] = "Version : "
L["Yes"] = "Yes"
-- L["You are no longer in a vehicle, but are still superbuffed. HitCrit remains disabled."] = "You are no longer in a vehicle, but are still superbuffed. HitCrit remains disabled."
-- L["You are no longer in a vehicle. HitCrit re-enabled."] = "You are no longer in a vehicle. HitCrit re-enabled."
-- L["You are no longer superbuffed. HitCrit re-enabled."] = "You are no longer superbuffed. HitCrit re-enabled."
-- L["You are now in a vehicle (doing higher than normal damage). HitCrit disabled."] = "You are now in a vehicle (doing higher than normal damage). HitCrit disabled."
-- L["You are now superbuffed (doing higher than normal damage). HitCrit disabled."] = "You are now superbuffed (doing higher than normal damage). HitCrit disabled."
L["arcane"] = "arcane"
-- L["casts"] = "casts"
-- L["chaos"] = "chaos"
-- L["chromatic"] = "chromatic"
-- L["divine"] = "divine"
-- L["elemental"] = "elemental"
L["fire"] = "feu"
-- L["firestorm"] = "firestorm"
-- L["flamestrike"] = "flamestrike"
-- L["for"] = "for"
L["frost"] = "givre"
L["frostfire"] = "givrefeu"
L["froststorm"] = "tempête-de-givre"
-- L["froststrike"] = "froststrike"
L["healed"] = "soigné"
L["holy"] = "sacré"
-- L["holyfire"] = "holyfire"
-- L["holyfrost"] = "holyfrost"
-- L["holystorm"] = "holystorm"
-- L["holystrike"] = "holystrike"
-- L["magic"] = "magic"
L["nature"] = "nature"
L["physical"] = "physique"
L["shadow"] = "ombre"
-- L["shadowflame"] = "shadowflame"
-- L["shadowfrost"] = "shadowfrost"
-- L["shadowlight"] = "shadowlight"
L["shadowstorm"] = "shadowstorm"
-- L["shadowstrike"] = "shadowstrike"
-- L["spellfire"] = "spellfire"
-- L["spellfrost"] = "spellfrost"
-- L["spellshadow"] = "spellshadow"
-- L["spellstorm"] = "spellstorm"
-- L["spellstrike"] = "spellstrike"
-- L["stormstrike"] = "stormstrike"
-- L["with"] = "with"


--[[
************************************************************************
CHANGELOG:

Date : 1/15/08
	switched to using wowace's auto-localization stuff
************************************************************************
]]--