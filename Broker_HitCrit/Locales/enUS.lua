--[[
************************************************************************
Project				: Broker_HitCrit
Author				: zhinjio
Project Revision	: 2.22.2-release
Project Date		: 20110705025101

File				: Locales\enUS.lua
Commit Author		: zhinjio
Commit Revision		: 88
Commit Date			: 20090823170149
************************************************************************
Description	:
	English translation strings
TODO		:
************************************************************************
(see bottom of file for changelog)
************************************************************************
--]]
local MODNAME = "HitCrit"
local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale( MODNAME, "enUS", true, debug )
if not L then return end

L["%s for %s against %s"] = true
L["ALERT_CHATFRAME_DESC"] = "Check to alert in the default Chat Frame"
L["ALERT_MSBTAREA_DESC"] = "Check to alert in an MSBT Scroll Area"
L["ALERT_MSBT_DESC"] = "Options to receive alerts in MikScrollingBattleText Scroll Areas"
L["ALERT_NOTIFY_DESC"] = "Check to alert with a Notify Area message"
L["ALERT_OPTIONS_DESC"] = "Options that change the way HitCrit notifies you when you get a new high value"
L["ALERT_PARROTAREA_DESC"] = "Check to alert in a Parrot Scroll Area"
L["ALERT_PARROT_DESC"] = "Options to receive alerts in Parrot Scroll Areas. Only enabled if Parrot is installed."
L["ALERT_SCREENIE_DESC"] = "Check to take a screenshot on new high value"
L["ALERT_SELECTMSBTAREA_DESC"] = "Select the MSBT Scroll Area to use"
L["ALERT_SELECTPARROTAREA_DESC"] = "Select the Parrot Scroll Area to use"
L["ALERT_SOUND_DESC"] = "Check to alert with a sound"
L["ALERT_SUPERBUFF_TOGGLE"] = "Check to disable superbuff notifications in chatframe"
L["ARGENT_TOGGLE_DESC"] = "Suppress Argent Tourney spells"
L["Against"] = true
L["Alert Options"] = true
L["Alert in Chat Frame"] = true
L["Alert in MSBT Scroll Area"] = true
L["Alert in Parrot Scroll Area"] = true
L["Alert with Notify"] = true
L["Alert with Sound"] = true
L["Alt-Left-click to delete values"] = true
L["Alt-Right-click for to see Alternate Spec"] = true
L["Alt-Right-click to see Active Spec"] = true
L["Alt-Right-click to see Inactive Spec"] = true
L["Argent Tourney"] = true
L["Author : "] = true
L["Avg"] = true
L["Broker_HitCrit"] = "HitCrit"
L["Build Date : "] = true
L["Color Label Text"] = true
L["Crit"] = true
L["Critical Heal"] = true
L["Critical Hit"] = true
L["DISPLAY_AVG_DESC"] = "Check to include the 'Avg' column"
L["DISPLAY_COLORLABEL_DESC"] = "Click to enable LDB text coloring. Disabling this lets the LDB bar addon handle the coloring."
L["DISPLAY_CRIT_DESC"] = "Checked to include the 'Crit' column"
L["DISPLAY_DEBUG_DESC"] = "Checked to display DEBUG information"
L["DISPLAY_ENEMYNAME_DESC"] = "Check to display enemy name"
L["DISPLAY_HIT_DESC"] = "Check to include the 'Hit' column"
L["DISPLAY_LABELDMG_DESC"] = "Check to display top damage values on the LDB Bar"
L["DISPLAY_LABELHEAL_DESC"] = "Check to display top healing values on the LDB Bar"
L["DISPLAY_LABEL_DESC"] = "Check to display top Hit/Crit values in the text label in the display"
L["DISPLAY_OPTIONS_DESC"] = "Options that change the way data is displayed in the tooltip"
L["DISPLAY_SORTSCHOOL_DESC"] = "Check to sort data by spell school"
L["DMG_GLOBAL_TOGGLE_DESC"] = "Toggle to affect all schools at once"
L["DMG_SCHOOLS_DESC"] = "Per school damage tracking inclusion"
L["Damage"] = true
L["Damage Schools"] = true
L["Database Version : "] = true
L["Database upgraded to %s"] = true
L["Detect Superbuffs"] = true
L["Display Avg"] = true
L["Display Crit"] = true
L["Display Debug"] = true
L["Display Dmg in Label"] = true
L["Display Enemy Name"] = true
L["Display Heal in Label"] = true
L["Display Hit"] = true
L["Display Options"] = true
L["Display Top Values"] = true
L["Draws the icon on the minimap."] = true
L["Effect"] = true
L["Error occurred in the tooltip. I could not report for category (%s) and spell (%s)."] = true
L["GENERAL_INFO_DESC"] = "Version and author information"
L["General Information"] = true
L["Global Damage Toggle"] = true
L["Global Healing Toggle"] = true
L["HEAL_GLOBAL_TOGGLE_DESC"] = "Toggle to affect all schools at once"
L["HEAL_SCHOOLS_DESC"] = "Per school healing tracking inclusion"
L["Heal"] = true
L["Healing"] = true
L["Healing Schools"] = true
L["Helpful Translators (thank you) : %s"] = true
L["Hit"] = true
L["HitCrit Data Browser"] = true
L["If you notice errors or values not updating, try clearing out values."] = true
L["Inactive Spec"] = true
L["LDB Text Display Options"] = true
L["LDBDISPLAY_OPTIONS_DESC"] = "Options that change the text displayed on the LDB Bar"
L["Left-click for Data Browser"] = true
L["Left-click to Report values in chat"] = true
L["MINIMAP_OPTIONS_DESC"] = "Options regarding the minimap icon"
L["MISCDISPLAY_OPTIONS_DESC"] = "Other options"
L["MSBT Integration"] = true
L["Melee"] = true
L["Minimap Icon Options"] = true
L["Miscellaneous"] = true
L["Miscellaneous Display Options"] = true
L["New Record %s! %s %s %s for %d"] = true
L["No"] = true
L["Notes"] = true
L["Parrot Integration"] = true
L["Please note: All spell suppression, tracking and expansion toggles have been reset."] = true
L["Please note: Due to changes in 4.2, you may need to clear data."] = true
L["Please report this error on the project webpage."] = true
L["RESETALL_TOOLTIP"] = "Click to reset all saved HitCrit data for this toon"
L["RESETCATEGORY_TOOLTIP"] = "Click to reset HitCrit data for the selected category for this toon"
L["RESETENTRY_TOOLTIP"] = "Click to reset HitCrit data for the selected category, school and entry for this toon"
L["RESETSCHOOL_TOOLTIP"] = "Click to reset HitCrit data for the selected category and school for this toon"
L["RESETSPECIFIC_TOOLTIP"] = "Click to reset the specific HitCrit data selected for this toon"
L["Reset ALL data for '%s'. Are you sure?"] = true
L["Reset All Data"] = true
L["Reset Category Data"] = true
L["Reset Category: %s, School: %s. Are you sure?"] = true
L["Reset Category: %s. Are you sure?"] = true
L["Reset Entry Data"] = true
L["Reset School Data"] = true
L["Reset Specific Data"] = true
L["Reset all entries for spell: %s. Are you sure?"] = true
L["Reset data for '%s' - '%s'. Are you sure?"] = true
L["Reset data for '%s' - Category: %s, School: %s. Are you sure?"] = true
L["Reset data for '%s' - Category: %s. Are you sure?"] = true
L["Reset data for '%s' - Spell: %s. Are you sure?"] = true
L["Reset first %s entry for spell: %s. Are you sure?"] = true
L["Right-click for Configuration"] = true
L["SUPPRESS_DMG_DESC"] = "Damage spell schools checked below WILL NOT be included in the tooltip."
L["SUPPRESS_HEAL_DESC"] = "Healing spell schools checked below WILL NOT be included in the tooltip."
L["SUPPRESS_MISC_DESC"] = "Miscellaneous Suppressions"
L["SUPPRESS_NOTES_DESC"] = "Suppression by selected schools only works if 'Sort by Schools' is turned on in the Display Options. Turning ALL schools on or off will still work, however."
L["SUPPRESS_OPTIONS_DESC"] = "Options pertaining to the suppression of spell schools in the toolip. Note that these are independent of whether data is being gathered for these schools or not."
L["Select MSBT Scroll Area"] = true
L["Select Parrot Scroll Area"] = true
L["Show Minimap Icon"] = true
L["Sort by School"] = true
L["Suppression Options"] = true
L["TOOLTIP_DELAY_DESC"] = "Time (in seconds) that the tooltip will remain after moving mouse away"
L["TOOLTIP_SCALE_DESC"] = "Slide to change the scale of the tooltip"
L["TRACKING_OPTIONS_DESC"] = "Options that change the way data is gathered"
L["TRACK_AGAINSTME_DESC"] = "Check to track hits against me"
L["TRACK_DAMAGE_DESC"] = "Check to track damage"
L["TRACK_DETECT_SP"] = "If checked, HitCrit will disable when superbuffs/vehicles are active"
L["TRACK_ENVIRONMENTAL_DESC"] = "Check to track environmental damage against me"
L["TRACK_HEALING_DESC"] = "Check to track healing"
L["TRACK_LOWLEVEL_DESC"] = "Check to track data against low level mobs"
L["TRACK_PVP_DESC"] = "Check to track PvP combat"
L["TRACK_VULNERABLE_DESC"] = "Check to track data against vulnerable targets"
L["Take Screenshot"] = true
L["Tooltip Auto-hide Delay"] = true
L["Tooltip Scale"] = true
L["Track Damage"] = true
L["Track Environmental"] = true
L["Track Healing"] = true
L["Track Hits Against Me"] = true
L["Track Low Level"] = true
L["Track PvP"] = true
L["Track Vulnerable"] = true
L["Tracking Options"] = true
L["Turn off Superbuff Alerts"] = true
L["Version : "] = true
L["Yes"] = true
L["You are no longer in a vehicle, but are still superbuffed. HitCrit remains disabled."] = true
L["You are no longer in a vehicle. HitCrit re-enabled."] = true
L["You are no longer superbuffed. HitCrit re-enabled."] = true
L["You are now in a vehicle (doing higher than normal damage). HitCrit disabled."] = true
L["You are now superbuffed (doing higher than normal damage). HitCrit disabled."] = true
L["arcane"] = true
L["casts"] = true
L["chaos"] = true
L["chromatic"] = true
L["divine"] = true
L["elemental"] = true
L["fire"] = true
L["firestorm"] = true
L["flamestrike"] = true
L["for"] = true
L["frost"] = true
L["frostfire"] = true
L["froststorm"] = true
L["froststrike"] = true
L["healed"] = true
L["holy"] = true
L["holyfire"] = true
L["holyfrost"] = true
L["holystorm"] = true
L["holystrike"] = true
L["magic"] = true
L["nature"] = true
L["physical"] = true
L["shadow"] = true
L["shadowflame"] = true
L["shadowfrost"] = true
L["shadowlight"] = true
L["shadowstorm"] = true
L["shadowstrike"] = true
L["spellfire"] = true
L["spellfrost"] = true
L["spellshadow"] = true
L["spellstorm"] = true
L["spellstrike"] = true
L["stormstrike"] = true
L["with"] = true


--[[
************************************************************************
CHANGELOG:

Date : 8/23/09
	Added MODNAME and debug error suppression
Date : 1/15/08
	switched to using wowace's auto-localization stuff
************************************************************************
]]--