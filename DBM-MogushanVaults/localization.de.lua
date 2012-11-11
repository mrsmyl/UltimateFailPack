﻿if GetLocale() ~= "deDE" then return end
local L

------------
-- The Stone Guard --
------------
L= DBM:GetModLocalization(679)

L:SetWarningLocalization({
	SpecWarnOverloadSoon		= "%s wirkbar in 7 Sek!",
	specWarnBreakJasperChains	= "Sprenge Jaspisketten!"
})

L:SetOptionLocalization({
	SpecWarnOverloadSoon		= "Zeige Spezialwarnung bevor eine Überladung gewirkt werden kann",
	specWarnBreakJasperChains	= "Zeige Spezialwarnung, wenn es sicher ist die $spell:130395 zu sprengen",
	ArrowOnJasperChains			= "Zeige DBM-Pfeil, wenn du von $spell:130395 betroffen bist",
	InfoFrame					= "Zeige Infofenster für Bossenergie, Spielerversteinerung und welcher Boss Versteinerung wirkt"
})

L:SetMiscLocalization({
	Overload	= "%s überlädt sich gleich!"
})


------------
-- Feng the Accursed --
------------
L= DBM:GetModLocalization(689)

L:SetWarningLocalization({
	WarnPhase	= "Phase %d"
})

L:SetOptionLocalization({
	WarnPhase	= "Verkünde Phasenwechsel",
	RangeFrame	= "Zeige Abstandsfenster (6m) während Arkanphase"
})

L:SetMiscLocalization({
	Fire		= "Oh, Erhabener! Durch mich sollt Ihr das Fleisch von den Knochen schmelzen!",
	Arcane		= "Oh, Weiser der Zeitalter! Vertraut mir Euer arkanes Wissen an!",
	Nature		= "Oh, großer Geist! Gewährt mir die Macht der Erde!",
	Shadow		= "Great soul of champions past! Bear to me your shield!" --translate (trigger, hero only)
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
	Pull		= "Jetzt is' Sterbenszeit!"
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
	specWarnDespawnFloor	= "Paß auf, wo du hintrittst!"
})

L:SetTimerLocalization({
	timerDespawnFloor		= "Paß auf, wo du hintrittst!"
})

L:SetOptionLocalization({
	specWarnDespawnFloor	= "Zeige Spezialwarnung bevor der Boden (Energievortex) verschwindet",
	timerDespawnFloor		= "Zeige Zeit bis der Boden (Energievortex) verschwindet",
	SetIconOnDestabilized	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(132226)
})


------------
-- Will of the Emperor --
------------
L= DBM:GetModLocalization(677)

L:SetOptionLocalization({
	InfoFrame		= "Zeige Infofenster für Spieler, welche von $spell:116525 betroffen sind",
	ArrowOnCombo	= "Zeige DBM-Pfeil während $journal:5673  HINWEIS: Nimmt an,\ndass sich der Tank vor dem Boss befindet und alle anderen dahinter."
})

L:SetMiscLocalization({
	Pull		= "Die Maschine brummt und erwacht zu Leben! Geht zur unteren Ebene!",
	Rage		= "Der Zorn des Kaisers schallt durch die Berge.",
	Strength	= "Die Stärke des Kaisers erscheint in den Erkern!",
	Courage		= "Der Mut des Kaisers erscheint in den Erkern!",
	Boss		= "In den riesigen Erkern erscheinen zwei Titanenkonstrukte!"
})

