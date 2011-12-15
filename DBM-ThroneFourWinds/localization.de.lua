﻿if GetLocale() ~= "deDE" then return end
local L

------------------------
--  Conclave of Wind  --
------------------------
--L = DBM:GetModLocalization(154)
L = DBM:GetModLocalization("Conclave")

L:SetGeneralLocalization({
	name = "Konklave des Windes"
})

L:SetWarningLocalization({
	warnSpecial			= "Hurrikan/Zephyr/Graupelsturm aktiv",
	specWarnSpecial		= "Spezialfähigkeiten aktiv!",
	warnSpecialSoon		= "Spezialfähigkeiten in 10 Sekunden!"
})

L:SetTimerLocalization({
	timerSpecial		= "Spezialfähigkeiten CD",
	timerSpecialActive	= "Spezialfähigkeiten aktiv"
})

L:SetOptionLocalization({
	warnSpecial			= "Zeige Warnung, wenn Hurrikan/Zephyr/Graupelsturm gewirkt werden",
	specWarnSpecial		= "Zeige Spezialwarnung, wenn Spezialfähigkeiten gewirkt werden",
	timerSpecial		= "Zeige Abklingzeit für Spezialfähigkeiten",
	timerSpecialActive	= "Zeige Dauer der Spezialfähigkeiten",
	warnSpecialSoon		= "Zeige Vorwarnung 10 Sekunden vor den Spezialfähigkeiten",
	OnlyWarnforMyTarget	= "Zeige Warnungen und Timer nur für aktuelles Ziel und Fokusziel\n(Versteckt den Rest. Dies beinhaltet den PULL!)"
})

L:SetMiscLocalization({
	gatherstrength	= "%s beinnt von den verbliebenen Windlords Stärke zu beziehen!", --yes the typo is from the logfiles (4.06a) "<356.9> RAID_BOSS_EMOTE#%s beinnt von den verbliebenen Windlords Stärke zu beziehen!#Rohash#####0#0##0#1616##0#false#false", -- [6]
	Anshal			= "Anshal",
	Nezir			= "Nezir",
	Rohash			= "Rohash"
})

---------------
--  Al'Akir  --
---------------
--L = DBM:GetModLocalization(155)
L = DBM:GetModLocalization("AlAkir")

L:SetGeneralLocalization({
	name = "Al'Akir"
})

L:SetWarningLocalization({
	WarnAdd			= "Sturmling gespawned"
})

L:SetTimerLocalization({
	TimerFeedback 	= "Rückkopplung (%d)",
	TimerAddCD		= "Nächstes Add"
})

L:SetOptionLocalization({
	LightningRodIcon= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(89668),
	TimerFeedback	= "Zeige Dauer von $spell:87904",
	WarnAdd			= "Zeige Warnung, wenn ein Sturmling spawned", 
	TimerAddCD		= "Zeige Timer für neues Add"
})

L:SetMiscLocalization({
	summonAdd	=	"Stürme! Ich rufe euch an meine Seite!",
	phase3		=	"Genug! Ich werde mich nicht länger zurückhalten!"
})
