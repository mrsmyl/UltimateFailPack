﻿if GetLocale() ~= "frFR" then return end
local L
-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	KohcromWarning	= "%s : %s"
})

L:SetTimerLocalization({
	KohcromCD		= "Kohcrom mimicks %s",
})

L:SetOptionLocalization({
	KohcromWarning	= "Alerte lorsque Kohcrom imite des compétences",
	KohcromCD		= "Délai avant la prochaine compétence imitiée par Kohcrom",
	RangeFrame		= "Cadre des portées (5) pour le haut fait"
})

L:SetMiscLocalization({
})

---------------------
-- Warlord Zon'ozz --
---------------------
L= DBM:GetModLocalization(324)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	RangeFrame	= "Cadre des portées (10) pour $spell:104601 (difficulté héroïque)"
})

L:SetMiscLocalization({
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	timerOozesActive	= "Gelées attaquables"
})

L:SetOptionLocalization({
	timerOozesActive	= "Délai avant que les gelées ne soient attaquables après leur apparition",
	RangeFrame			= "Cadre des portées (4) pour $spell:104898\n(difficulté Normal+)"
})

L:SetMiscLocalization({
	Black			= "|cFF424242noir|r",
	Purple			= "|cFF9932CDviolet|r",
	Red				= "|cFFFF0404rouge|r",
	Green			= "|cFF088A08vert|r",
	Blue			= "|cFF0080FFbleu|r",
	Yellow			= "|cFFFFA901jaune|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	warnFrostTombCast		= "%s dans 8 sec."
})

L:SetTimerLocalization({
	TimerSpecial			= "1er spécial"
})

L:SetOptionLocalization({
	TimerSpecial			= "Délai avant la première incantation d'une technique spéciale",
	RangeFrame				= "Cadre des portées (3) pour $spell:105269",
	AnnounceFrostTombIcons	= "Annonce des icônes des cibles de $spell:104451 au canal Raid\n(nécessite d'être le chef du raid)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	TombIconSet				= "Icône de Tombeau de glace {rt%d} placée sur %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "Ultraxion atterrit"
})

L:SetOptionLocalization({
	TimerCombatStart	= "Durée du RP d'Ultraxion"
})

L:SetMiscLocalization({
	Trash				= "It is good to see you again, Alexstrasza. I have been busy in my absence.", -- à traduire
	Pull				= "Je sens un grand trouble dans l'équilibre qui s'approche. Un chaos tel qu'il me brùle l'esprit !"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "Début du combat",
	TimerSapper			= "Proch. Sapeur du Crépuscule"
})

L:SetOptionLocalization({
	TimerCombatStart	= "Délai avant le début du combat",
	TimerSapper			= "Délai avant la prochaine apparition d'un Sapeur du Crépuscule"
})

L:SetMiscLocalization({
	SapperEmote			= "Un drake plonge et dépose un sapeur du Crépuscule sur le pont !",
	Broadside			= "spell:110153",
	DeckFire			= "spell:110095"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril			= "Accrochez-vous !"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTendril			= "Alerte spéciale quand vous n'avez pas $spell:109454",
	InfoFrame				= "Cadre d'infos indiquant les joueurs sans $spell:109454",
	SetIconOnGrip			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfo			= "Cadre des vies du boss avec une barre de vie pour $spell:109479"
})

L:SetMiscLocalization({
	Pull		= "Les plaques ! Il tombe en morceaux ! Arrachez les plaques et on aura une chance de le descendre !",
	NoDebuff	= "Sans %s",
	PlasmaTarget	= "Plasma incendiaire : %s",
	DRoll		= "va faire un tonneau"
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "Tentacules caustiques - Switch"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTentacle	= "Alerte spéciale quand des Tentacules caustiques apparaissent (et Alexstrasza n'est pas active)"
})

L:SetMiscLocalization({
	Pull				= "Vous n'avez RIEN fait. Je vais mettre votre monde en PIÈCES.",
	Kill				= "We are one step closer. The unknowable, transcendent power of the Emerald Dream I now give unto the Dragon Soul." -- à traduire
})
