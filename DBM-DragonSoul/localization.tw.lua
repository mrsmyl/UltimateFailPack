﻿if GetLocale() ~= "zhTW"  then return end
local L

-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	KohcromWarning	= "%s:%s"
})

L:SetTimerLocalization({
	KohcromCD		= "寇魔的%s",
})

L:SetOptionLocalization({
	KohcromWarning	= "為寇魔的技能顯示警告。",
	KohcromCD		= "為寇魔下一次的技能顯示計時器。",
	RangeFrame		= "為成就顯示距離框(5碼)。"
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
	ShadowYell			= "當你中了$spell:104600時大喊(只有英雄模式)",
	RangeFrame			= "為玩家的減益狀態顯示動態距離框架，應對英雄難度的$spell:104601",
	NoFilterRangeFrame	= "停用過濾框架減益並總是顯示所有人"
})

L:SetMiscLocalization({
	voidYell	= "Gul'kafh an'qov N'Zoth."
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	timerOozesActive	= "軟泥可被攻擊"
})

L:SetOptionLocalization({
	timerOozesActive	= "為軟泥重生後可被攻擊顯示計時器",
	RangeFrame			= "為$spell:104898顯示距離框(4碼)(普通以上的難度)"
})

L:SetMiscLocalization({
	Black			= "|cFF424242黑|r",
	Purple			= "|cFF9932CD紫|r",
	Red				= "|cFFFF0404紅|r",
	Green			= "|cFF088A08綠|r",
	Blue			= "|cFF0080FF藍|r",
	Yellow			= "|cFFFFA901黃|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	warnFrostTombCast		= "%s 在八秒後"
})

L:SetTimerLocalization({
	TimerSpecial			= "第一次特別技能"
})

L:SetOptionLocalization({
	TimerSpecial			= "為第一次特別技能$spell:105256或$spell:105465施放顯示計時器(第一次施放根據首領手中的武器的附魔)",
	RangeFrame				= "為$spell:105269(3碼),$journal:4327(10碼)顯示距離框",
	AnnounceFrostTombIcons	= "為$spell:104451的目標發佈圖示至團隊頻道\n(需要團隊隊長)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	TombIconSet				= "寒冰之墓{rt%d}標記於%s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerDrakes			= "%s",
	TimerCombatStart	= "戰鬥開始"
})

L:SetOptionLocalization({
	TimerDrakes			= "為暮光猛擊者$spell:109904顯示計時器",
	TimerCombatStart	= "為戰鬥開始時間顯示計時器"
})

L:SetMiscLocalization({
	Trash				= "很高興又見到你，雅立史卓莎。我離開這段時間忙得很。",
	Pull				= "我感到平衡被一股強大的波動干擾。如此混沌在燃燒我的心靈!"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "戰鬥開始",
	TimerSapper			= "下一次暮光工兵",
	TimerAdd			= "下一次精英暮光"
})

L:SetOptionLocalization({
	TimerCombatStart	= "為戰鬥開始時間顯示計時器",
	TimerSapper			= "為下一次暮光工兵重生顯示計時器",--npc=56923
	TimerAdd			= "為下一次精英暮光顯示計時器"
})

L:SetMiscLocalization({
	SapperEmote			= "一頭龍急速飛來，載送一名暮光工兵降落到甲板上!",
	Broadside			= "spell:110153",
	DeckFire			= "spell:110095"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril			= "已被安全抓住!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTendril			= "當你身上沒有$spell:109454減益時顯示特別警告",--http://ptr.wowhead.com/npc=56188
	InfoFrame				= "為沒有$spell:109454的玩家顯示訊息框",
	SetIconOnGrip			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfo			= "為$spell:105479顯示生命條"
})

L:SetMiscLocalization({
	Pull		= "他的護甲!他正在崩壞!破壞他的護甲，我們就有機會打贏他了!",
	NoDebuff	= "無%s",
	PlasmaTarget	= "燃燒血漿: %s",
	DRoll		= "他準備往",
	DLevels			= "回復平衡"
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "快攻擊極熾觸手!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTentacle	= "為極熾觸手生長顯示特別警告(當雅立史卓莎不在場時)"--http://ptr.wowhead.com/npc=56188
})

L:SetMiscLocalization({
	Pull				= "你們都徒勞無功。我會撕裂你們的世界。"
})
