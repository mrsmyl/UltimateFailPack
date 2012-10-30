--[[ *******************************************************************
Project                 : Broker_XPBar
Description             : English translation file (enUS)
Author                  : tritium
Translator              : 
Revision                : $Rev: 1 $
********************************************************************* ]]

local ADDON = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON, "enUS", true, true)
if not L then return end

L["Bar Properties"] = true
L["Set the Bar Properties"] = true

L["Show XP Bar"] = true
L["Show the XP Bar"]  = true
L["Show Reputation Bar"] = true
L["Show the Reputation Bar"] = true
L["Spark intensity"] = true
L["Brightness level of Spark"] = true
L["Thickness"] = true
L["Set thickness of the Bars"] = true
L["Shadow"] = true
L["Toggle Shadow"] = true
L["Inverse Order"] = true
L["Place reputation bar before XP bar"] = true
L["Other Texture"] = true
L["Use external texture for bar instead of the one provided with the addon"] = true
L["Bar Texture"] = true
L["Texture of the bars."] = true
L["If you want more textures, you should install the addon 'SharedMedia'."] = true
L["per Tick"] = true
L["Ticks"] = true
L["Set number of ticks shown on the bar."] = true

L["Bar Text"] = true
L["Display settings for bar text."] = true

L["Show Bar Text"] = true
L["Show current progress values on bar."] = true
L["Mouse-Over"] = true
L["Show text only on mouse over bar."] = true
L["Font"] = true
L["Font of the bar text."] = true
L["If you want more fonts, you should install the addon 'SharedMedia'."] = true
L["Font Size"] = true
L["The font size of the text."] = true
L["Show XP/Rep to go in bar text"] = true
L["Show faction name in bar text."] = true
L["Show values in bar text"] = true
L["Show percentage in bar text"] = true
L["Show rested value in bar text"] = true
L["Show rested percentage in bar text"] = true
L["Abbreviations"] = true
L["Use abbreviations to shorten numbers"] = true

L["Frame"] = true
L["Frame Connection Properties"] = true

L["Frame to attach to"] = true
L["The exact name of the frame to attach to"] = true
L["Select by Mouse"] = true
L["Click to activate the frame selector (Left-Click to select frame, Right-Click do deactivate selector)"] = true
L["This frame has no global name and cannot be used"] = true
L["Attach to side"] = true
L["Select side to attach the bars to"] = true
L["X-Offset"] = true
L["Set x-Offset of the bars"] = true
L["Y-Offset"] = true
L["Set y-Offset of the bars"] = true
L["Strata"] = true
L["Select the strata of the bars"] = true
L["Inside"] = true
L["Attach bars to the inside of the frame"] = true
L["Inverse Order"] = true
L["Place reputation bar before XP bar"] = true
L["Jostle"] = true
L["Jostle Blizzard Frames"] = true
L["Refresh"] = true
L["Refresh Bar Position"] = true

L["Colors"] = true
L["Set the Bar Colors"] = true

L["Current XP"] = true
L["Set the color of the XP Bar"] = true
L["Rested XP"] = true
L["Set the color of the Rested Bar"] = true
L["No XP"] = true
L["Set the empty color of the XP Bar"] = true
L["Reputation"] = true
L["Set the color of the Rep Bar"] = true
L["No Rep"] = true
L["Set the empty color of the Reputation Bar"] = true
L["Blizzard Rep Colors"] = true
L["Toggle Blizzard Reputation Colors"] = true

L["Numbers"] = true
L["General settings for number formatting"] = true

L["Separators"] = true
L["Use separators for numbers to improve readability"] = true
L["Decimal Places"] = true
L["Number of decimal places when using abbreviations"] = true

L["Broker Label"] = true
L["Broker Label Properties"] = true

L["Select Label Text"] = true
L["Select label text for Broker display"] = [[Select label text for Broker display:
|cffffff00None|r - Displays title of addon.
|cffffff00Kills to Level|r - Displays approximately how many more kills needed to level.
|cffffff00Time to Level|r - Displays approximately how much longer it will take to level.
|cffffff00Rep|r - Displays watched reputation faction's name, amount of earned reputation, and percent earned.
|cffffff00XP|r - Displays XP and percent earned.
|cffffff00Rep over XP|r - Displays reputation label by default, but if no watched faction displays XP.
|cffffff00XP over Rep|r - Displays XP label by default when below max level and Rep when max level.]]

L["XP/Rep to go"] = true
L["Show XP/Rep to go in label"] = true
L["Show faction name"] = true
L["Show faction name when reputation is selected as label text."] = true
L["Show Values"] = true
L["Show values in label text"] = true
L["Show Percentage"] = true
L["Show percentage in label text"] = true
L["Show Rested"] = true
L["Show rested value in label text"] = true
L["Show Rested %"] = true
L["Show rested percentage in label text"] = true
L["Colored Label"] = true
L["Color label text based on percentages"] = true

L["Tooltip"] = true
L["Tooltip Properties"] = true 

L["Faction Tracking"] = true
L["Auto-switch watched faction on reputation gains/losses."] = true

L["Switch on rep gain"] = true
L["Auto-switch watched faction on reputation gain."] = true
L["Switch on rep loss"] = true
L["Auto-switch watched faction on reputation loss."] = true

L["Leveling"] = true
L["Leveling Properties"] = true

L["Time Frame"] = true
L["Time frame for dynamic TTL calculation."] = true
L["Weight"] = true
L["Weight time frame vs. session average for dynamic TTL calculation."] = true

L["Max. XP/Rep"] = true
L["Display settings at maximum level/reputation"] = true

L["No XP label"] = true
L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."] = true
L["No XP bar"] = true
L["Don't show XP bar at maximum level."] = true
L["No Rep label"] = true
L["Don't show label text at maximum Reputation. Affects Rep option only."] = true
L["No Rep bar"] = true
L["Don't show Rep bar at maximum Reputation."] = true

L["Faction"] = true
L["Select Faction"] = true
L["Blizzard Bars"] = true
L["Show default Blizzard Bars"] = true
L["Minimap Button"] = true
L["Show Minimap Button"] = true
L["Hide Hint"] = true
L["Hide usage hint in tooltip"] = true

L["Max Level"] = true
L["No watched faction"] = true
				
L["%s: %3.0f%% (%s/%s) %s left"] = true

L["Level"] = true
L["Current XP"] = true
L["Rested XP"] = true
L["To next level"] = true
L["Session XP"] = true
L["Session kills"] = true
L["XP per hour"] = true
L["Kills per hour"] = true
L["Time to level"] = true
L["Kills to level"] = true

L["Faction"] = true
L["Standing"] = true
L["Current reputation"] = true
L["To next standing"] = true
L["Session rep"] = true
L["Rep per hour"] = true

L["Click"] = true
L["Shift-Click"] = true
L["Right-Click"] = true
L["Send current XP to an open editbox."] = true
L["Send current reputation to an open editbox."] = true
L["Open option menu."] = true

L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"] = true
L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"] = true

L["Usage:"] = true
L["/brokerxpbar arg"] = true
L["/bxp arg"] = true
L["Args:"] = true
L["version - display version information"] = true
L["menu - display options menu"] = true
L["help - display this help"] = true

L["Maximum level reached."] = true
L["Currently no faction tracked."] = true
L["Version"] = true

L["Top"] = true 
L["Bottom"] = true
L["Left"] = true 
L["Right"] = true 

L["None"] = true
L["XP"] = true
L["Kills to Level"] = true
L["Time to Level"] = true
L["Rep"] = true
L["Time to Level Rep"] = true
L["XP over Rep"] = true
L["Rep over XP"] = true

L[","] = true
L["."] = true

L["k"] = true
L["m"] = true
L["bn"] = true
