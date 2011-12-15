﻿if GetLocale() ~= "koKR" then return end
local L

-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	KohcromWarning	= "%s: %s"--Bossname, spellname. At least with this we can get boss name from casts in this one, unlike a timer started off the previous bosses casts.
})

L:SetTimerLocalization({
	KohcromCD		= "크초르모 주문사용: %s",--Universal single local timer used for all of his mimick timers
})

L:SetOptionLocalization({
	KohcromWarning	= "크초르모가 동일하게 사용하는 주문 알림 보기(영웅 난이도)",
	KohcromCD		= "크초르모가 동일하게 사용하는 주문 바 표시(영웅 난이도)",
	RangeFrame		= "거리 프레임 보기(5m, 업적 용도)"
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
	RangeFrame	= "$spell:104601 주문의 영향을 받은 경우 거리 프레임 보기 (10m)\n(영웅 난이도)"
})

L:SetMiscLocalization({
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
	warnOozes		= "핏방울: %s",
	specWarnOozes	= "핏방울 소환!",
})

L:SetTimerLocalization({
	timerOozesCD		= "다음 핏방울",
	timerOozesActive	= "핏방울 공격 가능",
--	timerOozesReach		= "핏방울 도착"
})

L:SetOptionLocalization({
	warnOozes			= "핏방울 소환 알림 보기",
	specWarnOozes		= "핏방울 소환 특수 경고 보기",
	timerOozesCD		= "다음 핏방울 바 표시",
	timerOozesActive	= "핏방울이 소환된 후 공격 가능하기까지 남은시간 바 표시",
--	timerOozesReach		= "소환된 핏방울이 보스에게 도착하기까지 남은시간 바 표시",
	RangeFrame			= "보스가 $spell:104898 주문의 영향을 받은 경우 거리 프레임 보기(4m)\n(일반 난이도 이상)"
})

L:SetMiscLocalization({
	Black			= "|cFF424242검정|r",
	Purple			= "|cFF9932CD보라|r",
	Red				= "|cFFFF0404빨강|r",
	Green			= "|cFF088A08초록|r",
	Blue			= "|cFF0080FF파랑|r",
	Yellow			= "|cFFFFA901노랑|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	warnFrostTombCast		= "8초 후 %s"
})

L:SetTimerLocalization({
	TimerSpecial			= "첫번째 특수 공격"
})

L:SetOptionLocalization({
	TimerSpecial			= "첫번째 특수 공격 까지 남은 시간 바 표시",
	RangeFrame				= "$spell:105269 주문의 영향을 받은 경우 거리 프레임 보기 (3m)",
	AnnounceFrostTombIcons	= "$spell:104451 대상을 공격대 대화로 알리기\n(승급 권한 필요)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	TombIconSet				= "얼음 무덤 징표 : {rt%d} %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "울트락시온 착지"
})

L:SetOptionLocalization({
	TimerCombatStart	= "울트락시온 착지 바 표시"
})

L:SetMiscLocalization({
	Trash				= "다시 만나 반갑군, 알렉스트라자. 난 떠나 있는 동안 좀 바쁘게 지냈다.",
	Pull				= "엄청난 무언가가 느껴진다. 조화롭지 못한 그의 혼돈이 내 정신을 어지럽히는구나!"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerCombatStart	= "전투 시작",
	TimerSapper			= "다음 황혼의 폭파병"
})

L:SetOptionLocalization({
	TimerCombatStart	= "전투 시작 바 표시",
	TimerSapper			= "다음 황혼의 폭파병 등장 바 표시"--npc=56923
})

L:SetMiscLocalization({
	SapperEmote			= "비룡이 빠르게 날아와 황혼의 폭파병을 갑판에 떨어뜨립니다!",
	Broadside			= "spell:110153",
	DeckFire			= "spell:110095"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril			= "휘감는 촉수 받으세요!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTendril			= "$spell:109454 약화 효과가 없을 경우 특수 경고 보기",--http://ptr.wowhead.com/npc=56188
	InfoFrame				= "$spell:109454 약화 효과 없음에 대한 정보 프레임 보기",
	SetIconOnGrip			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfo			= "$spell:105479 주문 흡수량에 대한 바와 함께 보스 체력 프레임 보기"
})

L:SetMiscLocalization({
	Pull			= "저 갑옷! 놈의 갑옷이 벗겨지는군! 갑옷을 뜯어내면 놈을 쓰러뜨릴 기회가 생길 거요!",	
	NoDebuff		= "%s 없음",
	PlasmaTarget	= "이글거리는 혈장: %s",
	DRoll			= "회전하려고"--Not a single transcriptor log for this fight from anyone, just bad chat logs that have more looting then actual boss encounters. This emote needs to be confirmed/fixed if it's wrong.
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "열기 촉수 - 대상 전환!"--Msg too long? maybe just "Blistering Tentacles!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SpecWarnTentacle	= "열기 촉수 등장시 특수 경고 보기 (알렉스트라자의 강화 효과가 비활성화 일때)"--http://ptr.wowhead.com/npc=56188
})

L:SetMiscLocalization({
	Pull				= "넌 아무것도 못 했다. 내가 이 세상을 조각내주마.",
	Kill				= "때가 왔다. 내가 가진 모든 힘을 쏟아 모든 가능성의 끈을 바로 여기, 바로 지금, 용의 영혼에 엮겠다. 앞으로 일어날 일은 절대로 되돌릴 수 없으리라."
})
