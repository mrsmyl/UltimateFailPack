﻿if GetLocale() ~= "koKR" then return end
local L

--------------------------
-- Jin'rokh the Breaker --
--------------------------
L= DBM:GetModLocalization(827)

L:SetOptionLocalization({
	RangeFrame		= "거리 창 보기"
})

--------------
-- Horridon --
--------------
L= DBM:GetModLocalization(819)

L:SetWarningLocalization({
	warnAdds		= "%s"
})

L:SetTimerLocalization({
	timerDoor		= "다음 부족의 문 열림",
	timerAdds		= "다음 %s"
})

L:SetOptionLocalization({
	warnAdds		= "병력 등장시 알림 보기",
	timerDoor		= "다음 부족의 문 열림 바 표시",
	timerAdds		= "다음 추가 병력 바 표시"
})

L:SetMiscLocalization({
	newForces		= "병력들이 쏟아져",
	chargeTarget	= "꼬리를 바닥에 쿵쿵 내려칩니다!"
})

---------------------------
-- The Council of Elders --
---------------------------
L= DBM:GetModLocalization(816)

L:SetOptionLocalization({
	warnPossessed	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136442),
	warnSandBolt	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.target:format(136189),
	RangeFrame		= "거리 창 보기"
})

------------
-- Tortos --
------------
L= DBM:GetModLocalization(825)

L:SetWarningLocalization({
	warnKickShell			= "%s 사용 : >%s< (%d 남음)",
	specWarnCrystalShell	= "%s 받으세요!"
})

L:SetOptionLocalization({
	warnKickShell			= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(134031),
	specWarnCrystalShell	= "$spell:137633 효과가 없을 경우 특수 경고 보기",
	InfoFrame				= "$spell:137633 효과가 없는 대상을 정보 창에서 보기"
})

L:SetMiscLocalization({
	WrongDebuff		= "%s 없음"
})

-------------
-- Megaera --
-------------
L= DBM:GetModLocalization(821)

L:SetMiscLocalization({
	rampageEnds	= "분노가 가라앉습니다."
})

------------
-- Ji-Kun --
------------
L= DBM:GetModLocalization(828)

L:SetWarningLocalization({
	warnFlock		= "%2$ : %1$ (%3$d)",
	specWarnFlock	= "%2$ : %1$ (%3$d)",
})

L:SetTimerLocalization({
	timerFlockCD	= "둥지 (%d): %s"
})

L:SetOptionLocalization({
	warnFlock		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.count:format("ej7348"),
	specWarnFlock	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.switch:format("ej7348"),
	timerFlockCD	= DBM_CORE_AUTO_TIMER_OPTIONS.nextcount:format("ej7348"),
	RangeFrame		= "$spell:138923 주문에 대한 거리 창 보기(8m)"
})

L:SetMiscLocalization({
	eggsHatchL		= "아랫둥지에 있는 알들이 부화하기 시작합니다!",
	eggsHatchU		= "위쪽 둥지에 있는 알들이 부화하기 시작합니다!",
	Upper			= "위쪽",
	Lower			= "아래쪽",
	UpperAndLower	= "윗쪽 & 아래쪽"
})

--------------------------
-- Durumu the Forgotten --
--------------------------
L= DBM:GetModLocalization(818)

L:SetWarningLocalization({
	warnAddsLeft				= "안개도깨비 남음 : %d",
	specWarnFogRevealed			= "%s 드러남!",
	specWarnDisintegrationBeam	= "%s (%s)"
})

L:SetOptionLocalization({
	warnAddsLeft				= "안개도깨비 남은 횟수 알림 보기",
	specWarnFogRevealed			= "안개도깨비가 드러날 때 특수 경고 보기",
	specWarnDisintegrationBeam	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format("ej6882"),
	ArrowOnBeam					= "$journal:6882 시전 중에 이동해야 될 방향을 DBM 화살표로 보기",
	SetIconRays					= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format("ej6891")
})

L:SetMiscLocalization({
	Eye		= "눈"--확인 필요, "<72.0 20:04:19> [CHAT_MSG_MONSTER_EMOTE] CHAT_MSG_MONSTER_EMOTE#The Bright  Light reveals an Amber Fog!#Amber Fog###--------->Yellow Eye<---------##0#0##0#309#nil#0#false#false", -- [13413]
})

----------------
-- Primordius --
----------------
L= DBM:GetModLocalization(820)

L:SetOptionLocalization({
	RangeFrame			= "거리 창 보기(5m/2m)",
	SetIconOnBadOoze	= "$spell:140506를 생성하는 살아있는 점액에 전술 목표 아이콘 설정"
})

-----------------
-- Dark Animus --
-----------------
L= DBM:GetModLocalization(824)

L:SetWarningLocalization({
	warnMatterSwapped	= "%s: >%s<, >%s< 자리바뀜"
})

L:SetOptionLocalization({
	warnMatterSwapped	= "$spell:138618 대상 알림"
})

L:SetMiscLocalization({
	Pull		= "구슬이 폭발합니다!"
})

--------------
-- Iron Qon --
--------------
L= DBM:GetModLocalization(817)

L:SetWarningLocalization({
	warnDeadZone	= "%s: %s, %s 봉쇄됨"
})

L:SetOptionLocalization({
	warnDeadZone	= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(137229),
	RangeFrame		= "전투 진영에 따라 거리 창 보기\n(일정 인원 이상이 뭉쳐 있을 때만 보이는 똑똑한 거리 창 입니다.)",
	InfoFrame		= "$spell:136193 주문에 영향을 받은 대상을 정보 창에서 보기"
})

-------------------
-- Twin Consorts --
-------------------
L= DBM:GetModLocalization(829)

L:SetOptionLocalization({
	RangeFrame		= "거리 창 보기(8m)"
})

L:SetMiscLocalization({
	DuskPhase		= "Lu'lin! Lend me your strength!"
})

--------------
-- Lei Shen --
--------------
L= DBM:GetModLocalization(832)

L:SetOptionLocalization({
	RangeFrame			= "거리 창 보기",
	StaticShockArrow	= "$spell:135695 주문의 영향을 누군가 받은 경우 DBM 화살표 보기",
	OverchargeArrow		= "$spell:136295 주문의 영향을 누군가 받은 경우 DBM 화살표 보기",
	SetIconOnOvercharge	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(136295),
	SetIconOnStaticShock= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(135695)
})

------------
-- Ra-den --
------------
L= DBM:GetModLocalization(831)

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("ToTTrash")

L:SetGeneralLocalization({
	name =	"천둥의 왕좌 일반구간"
})

L:SetOptionLocalization({
	RangeFrame		= "거리 창 보기(10m)"
})
