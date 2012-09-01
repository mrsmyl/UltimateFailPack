﻿if GetLocale() ~= "deDE" then return end
local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetOptionLocalization({
	RangeFrame			= "Zeige Abstandsfenster (8m) für $spell:111850\n(zeigt jeden, falls du den Debuff hast; sonst nur betroffene Spieler)",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436)
})


------------
-- Tsulong --
------------
L= DBM:GetModLocalization(742)

L:SetMiscLocalization{
	Victory	= "I thank you, strangers. I have been freed." --translate (trigger)
}


-------------------------------
-- Lei Shi --
-------------------------------
L= DBM:GetModLocalization(729)

L:SetWarningLocalization({
	warnHideOver			= "%s ist beendet"
})

L:SetTimerLocalization({
	timerSpecialCD			= "Nächste Spezialfähigkeit"
})

L:SetOptionLocalization({
	warnHideOver			= "Zeige Warnung, wenn $spell:123244 beendet ist",
	timerSpecialCD			= "Zeige Zeit bis nächste Spezialfähigkeit gewirkt wird"
})

L:SetMiscLocalization{
	Victory	= "I... ah... oh! Did I...? Was I...? It was... so... cloudy." --translate (trigger)
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

