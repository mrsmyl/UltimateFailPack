﻿if GetLocale() ~= "ruRU" then return end
local L

-----------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	KohcromWarning	= "%s: %s"--Bossname, spellname. At least with this we can get boss name from casts in this one, unlike a timer started off the previous bosses casts.
})

L:SetTimerLocalization({
	KohcromCD		= "Кохром повторяет %s"
})

L:SetOptionLocalization({
	KohcromWarning	= "Предупреждать, когда Кохром повторяет заклинания Морхока",
	KohcromCD		= "Отсчет времени до следующего повторения заклинания",
	RangeFrame		= "Показывать окно проверки дистанции (5м) для достижения."
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
	ShadowYell	= "Кричать, когда на вас $spell:104600\n(Героический уровень сложности)",
	RangeFrame	= "Показывать окно проверки дистанции для $spell:104601\n(Героический уровень сложности)",
	NoFilterRangeFrame	= "Показывать всех игроков в этом окне, а не только с дебаффами"
})

L:SetMiscLocalization({
	voidYell	= "Gul'kafh an'qov N'Zoth."--Start translating the yell he does for Void of the Unmaking cast, the latest logs from DS indicate blizz removed the UNIT_SPELLCAST_SUCCESS event that detected casts. sigh.
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	timerOozesActive	= "Появление капель крови"
})

L:SetOptionLocalization({
	timerOozesActive	= "Отсчет времени спавна капель крови",
	RangeFrame			= "Показывать окно проверки дистанции (4м) для $spell:104898"
})

L:SetMiscLocalization({
	Black			= "|cFF424242черная|r",
	Purple			= "|cFF9932CDтеневая|r",
	Red				= "|cFFFF0404алая|r",
	Green			= "|cFF088A08кислотная|r",
	Blue			= "|cFF0080FFкобальтовая|r",
	Yellow			= "|cFFFFA901светящаяся|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	warnFrostTombCast		= "%s через 8 секунл"
})

L:SetTimerLocalization({
	TimerSpecial			= "Первая способность"
})

L:SetOptionLocalization({
	TimerSpecial			= "Отсчет времени до первой особой способности",
	RangeFrame				= "Показывать окно проверки дистанции: (3м) для $spell:105269 и\n(10м) для $journal:4327",
	AnnounceFrostTombIcons	= "Дублировать рейдовые иконки на целях $spell:104451 в рейд-чат\n(Необходимы права лидера или помощника)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	TombIconSet				= "Ледяная гробница {rt%d} на %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerDrakes			= "%s",--spellname from mod
	TimerCombatStart	= "Ультраксион приземляется"
})

L:SetOptionLocalization({
	TimerDrakes			= "Отсчет времени при применении $spell:109904 Сумеречными агрессорами",
	TimerCombatStart	= "Отсчет времени до приземления Ультраксиона"
})

L:SetMiscLocalization({
	Trash				= "Рад встрече, Алекстраза. Скоро ты увидишь, над чем я трудился.",
	Pull				= "Я чувствую приближение Хаоса… Мой разум не в силах этого выдержать!!"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "Начало боя",
	TimerSapper			= "Следующий сапёр",
	TimerAdd			= "Следующие помощники"
})

L:SetOptionLocalization({
	TimerCombatStart	= "Отсчет времени до начала боя",
	TimerSapper			= "Отсчет времени до появления следующего сапёра",--npc=56923
	TimerAdd			= "Отсчет времени до появления следующих помощников"
})

L:SetMiscLocalization({
	SapperEmote			= "Дракон пикирует на палубу, чтобы сбросить на нее сумеречного сапера!",
	Broadside			= "spell:110153",
	DeckFire			= "spell:110095"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril			= "Закрепитесь!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTendril			= "Спец-предупреждение, когда на вас нет дебаффа $spell:109454",--http://ptr.wowhead.com/npc=56188
	InfoFrame				= "Показывать информационное окно для игроков без $spell:109454",
	SetIconOnGrip			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfo			= "Показывать полосы здоровья для исцеления $spell:105479"
})

L:SetMiscLocalization({
	Pull		= "Смотрите, он разваливается! Оторвите пластины, и у нас появится шанс сбить его!",
	NoDebuff	= "Нет %s",
	PlasmaTarget	= "Жгучая плазма: %s",
	DRoll		= "собирается накрениться",
	DLevels		= "выравнивается"
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "Раскаленное щупальце - переключитесь!"--Msg too long? maybe just "Blistering Tentacles!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTentacle	= "Спец-предупреждение, когда появляются раскаленные щупальца (и Алекстраза не активна)"--http://ptr.wowhead.com/npc=56188
})

L:SetMiscLocalization({
	Pull				= "У вас НИЧЕГО не вышло. Я РАЗОРВУ ваш мир на куски.",
})