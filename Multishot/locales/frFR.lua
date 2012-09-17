local L = LibStub("AceLocale-3.0"):NewLocale("Multishot", "frFR")
if not L then return end

L["achievements"] = "Hauts faits"
L["bosskillshots"] = "killing screenshots" -- Requires localization
L["bosskillsparty"] = "groupes 5 joueurs" -- Needs review
L["bosskillsraid"] = "raids 10/25/40" -- Needs review
L["BOTTOMLEFT"] = "Bottom Left" -- Requires localization
L["BOTTOMRIGHT"] = "Bottom Right" -- Requires localization
L["capture"] = "paramètres de capture" -- Needs review
L["charpane"] = "show character window" -- Requires localization
L["clear the text and press Enter to restore defaults."] = "clear the text and press Enter to restore defaults." -- Requires localization
L["close"] = "fermé les fenêtres ouvertes" -- Needs review
L["Custom screenshot"] = "Custom screenshot" -- Requires localization
L["debug"] = "mode debug" -- Needs review
L["delay"] = "délai de capture" -- Needs review
L["delaykill"] = "killshots" -- Requires localization
L["delayother"] = "levelups & achievements" -- Requires localization
L["delayTimeline"] = "Timeline delay (minutes)" -- Requires localization
L["firstkills"] = "firstkill mode (per character)" -- Requires localization
L["format"] = "format de capture d'écran" -- Needs review
L["guildachievements"] = "Hauts faits de guilde" -- Needs review
L["guildlevelups"] = "guild levelups" -- Requires localization
L["intro"] = "Multishot prendra des captures d'écrans des évènements suivants" -- Needs review
L["jpeg"] = "Qualité basse (JPEG)" -- Needs review
L["levelups"] = "levelups" -- Requires localization
L["played"] = "Ajouter /joué" -- Needs review
L["png"] = "Qualité haute (PNG)" -- Needs review
L["quality"] = "qualité" -- Needs review
L["rarekills"] = "Monstres rares" -- Needs review
L["repchange"] = "Changements de réputation" -- Needs review
L["reset"] = "reset firstkill history" -- Requires localization
L["set the format for watermark text"] = "set the format for watermark text" -- Requires localization
L["tga"] = "non-compressé (TGA)" -- Needs review
L["timeline"] = "Timeline" -- Requires localization
L["timeLineEnable"] = "Enable Timeline mode (auto screenshot)" -- Requires localization
L["TOP"] = "Top" -- Requires localization
L["TOPLEFT"] = "Top Left" -- Requires localization
L["TOPRIGHT"] = "Top Right" -- Requires localization
L["trade"] = "trade window" -- Requires localization
L["uihide"] = "Cacher l'interface" -- Needs review
L["various"] = "various" -- Requires localization
L["watermark"] = "watermark" -- Requires localization
L["watermarkanchor"] = "Set the screen location of the watermark text" -- Requires localization
L["watermarkformat"] = "Configure the watermark text" -- Requires localization
L["watermarkformattext"] = [=[
$n = name
$c = class
$l = level
$z = zone
$r = realm
$d = date
$b = line change]=] -- Requires localization