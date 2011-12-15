﻿if GetLocale() ~= "zhTW"  then return end
local L

-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	KohcromWarning	= "%s: %s"
})

L:SetTimerLocalization({
	KohcromCD		= "寇魔的%s",
})

L:SetOptionLocalization({
	KohcromWarning	= "為寇魔的技能顯示警告。",
	KohcromCD		= "為寇魔下一次的技能顯示計時器。"
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
	RangeFrame	= "為$spell:104601顯示距離框(10碼)\n(英雄模式)"
})

L:SetMiscLocalization({
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
	warnOozes		= "軟泥即將來臨!: %s",
	specWarnOozes	= "軟泥來臨!",
})

L:SetTimerLocalization({
	timerOozesCD	= "下一次軟泥",
	timerOozesActive	= "軟泥可被攻擊",
	
})

L:SetOptionLocalization({
	warnOozes			= "當軟泥重生時顯示警告",
	specWarnOozes		= "當軟泥重生時顯示特別警告",
	timerOozesCD		= "為下一次軟泥重生顯示計時器",
	timerOozesActive	= "為軟泥重生後可被攻擊顯示計時器"
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
	TimerSpecial			= "第一次階段轉換"
})

L:SetOptionLocalization({
	TimerSpecial			= "為第一次特別技能施放顯示計時器",
	RangeFrame				= "為$spell:105269顯示距離框(3碼)",
	AnnounceFrostTombIcons	= "為$spell:104451的目標發佈圖示至團隊頻道\n(需要團隊隊長)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451)
})

L:SetMiscLocalization({
	TombIconSet				= "寒冰之墓標記{rt%d}設置於 %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "戰鬥開始"
})

L:SetOptionLocalization({
	TimerCombatStart	= "為戰鬥開始時間顯示計時器"
})

L:SetMiscLocalization({
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
	TimerSapper			= "下一次暮光工兵"
})

L:SetOptionLocalization({
	TimerCombatStart	= "為戰鬥開始時間顯示計時器",
	TimerSapper			= "為下一次暮光工兵重生顯示計時器"--npc=56923
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
	SetIconOnGrip			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459)
})

L:SetMiscLocalization({
	Pull		= "他的護甲!他正在崩壞!破壞他的護甲，我們就有機會打贏他了!",
	NoDebuff	= "無%s",
	DRoll		= "他準備往"
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
	Pull				= "你們都徒勞無功。我會撕毀你們的世界。"
})
