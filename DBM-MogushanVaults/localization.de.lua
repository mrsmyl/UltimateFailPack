﻿if GetLocale() ~= "deDE" then return end
local L

------------
-- The Stone Guard --
------------
L= DBM:GetModLocalization(679)

L:SetWarningLocalization({
	SpecWarnOverloadSoon	= "%s wirkbar in 7 Sek!"
})

L:SetOptionLocalization({
	SpecWarnOverloadSoon	= "Zeige Spezialwarnung bevor eine Überladung gewirkt werden kann",
})

L:SetMiscLocalization({
	Overload	= "%s is about to Overload!" --translate (trigger)
})


------------
-- Feng the Accursed --
------------
L= DBM:GetModLocalization(689)

L:SetWarningLocalization({
	WarnPhase	= "Phase %d"
})

L:SetOptionLocalization({
	WarnPhase	= "Verkünde Phasenwechsel"
})

L:SetMiscLocalization({
	Fire		= "Oh exalted one! Through me you shall melt flesh from bone!", --translate (trigger)
	Arcane		= "Oh sage of the ages! Instill to me your arcane wisdom!", --translate (trigger)
	Nature		= "Oh great spirit! Grant me the power of the earth!", --translate (trigger)
	Shadow		= "Great soul of champions past! Bear to me your shield!" --translate (trigger)
})


-------------------------------
-- Gara'jal the Spiritbinder --
-------------------------------
L= DBM:GetModLocalization(682)

L:SetOptionLocalization({
	RangeFrame			= "Zeige Abstandsfenster (8m)",
	SetIconOnVoodoo		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122151)
})

L:SetMiscLocalization({
	Pull		= "It be dyin' time, now!" --translate (trigger)
})


----------------------
-- The Spirit Kings --
----------------------
L = DBM:GetModLocalization(687)

L:SetOptionLocalization({
	RangeFrame			= "Zeige Abstandsfenster (8m)"
})


------------
-- Elegon --
------------
L = DBM:GetModLocalization(726)

L:SetWarningLocalization({
	specWarnDespawnFloor		= "Paß auf, wo du hintrittst!"
})

L:SetTimerLocalization({
	timerDespawnFloor			= "Paß auf, wo du hintrittst!"
})

L:SetOptionLocalization({
	specWarnDespawnFloor		= "Zeige Spezialwarnung bevor der Boden (Energievortex) verschwindet",
	timerDespawnFloor			= "Zeige Zeit bis der Boden (Energievortex) verschwindet"
})


------------
-- Will of the Emperor --
------------
L= DBM:GetModLocalization(677)

L:SetOptionLocalization({
	InfoFrame		= "Zeige Infofenster für Spieler, welche von $spell:116525 betroffen sind"
})

L:SetMiscLocalization({
	Pull		= "The machine hums to life!  Get to the lower level!", --translate (trigger)
	Rage		= "The Emperor's Rage echoes through the hills.", --translate (trigger)
	Strength	= "The Emperor's Strength appears in the alcoves!", --translate (trigger)
	Courage		= "The Emperor's Courage appears in the alcoves!", --translate (trigger)
	Boss		= "Two titanic constructs appear in the large alcoves!" --translate (trigger)
})

