﻿if GetLocale() ~= "koKR" then return end
local L

------------
-- The Stone Guard --
------------
L= DBM:GetModLocalization(679)

L:SetWarningLocalization({
	SpecWarnOverloadSoon	= "7초 후 %s 가능!"
})

L:SetOptionLocalization({
	SpecWarnOverloadSoon	= "과부하 사전 특수 경고 보기",
})

L:SetMiscLocalization({
	Overload	= "과부하되기 직전입니다!"
})


------------
-- Feng the Accursed --
------------
L= DBM:GetModLocalization(689)

L:SetWarningLocalization({
	WarnPhase	= "%d 단계"
})

L:SetOptionLocalization({
	WarnPhase	= "단계 전환 알림 보기"
})

L:SetMiscLocalization({
	Fire		= "오 고귀한 자여! 나와 함께 발라내자! 뼈에서 살을!",
	Arcane		= "오 세기의 현자여! 내게 비전의 지혜를 불어넣어라!",
	Nature		= "오 위대한 영혼이여! 내게 대지의 힘을 부여하라!",--I did not log this one, text is probably not right
	Shadow		= "Great soul of champions past! Bear to me your shield!"
})


-------------------------------
-- Gara'jal the Spiritbinder --
-------------------------------
L= DBM:GetModLocalization(682)

L:SetOptionLocalization({
	RangeFrame			= "거리 프레임 표시 (8m)",
	SetIconOnVoodoo		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(122151)
})

L:SetMiscLocalization({
	Pull		= "죽을 시간이다!"
})


----------------------
-- The Spirit Kings --
----------------------
L = DBM:GetModLocalization(687)

L:SetOptionLocalization({
	RangeFrame			= "거리 프레임 표시 (8m)"
})


------------
-- Elegon --
------------
L = DBM:GetModLocalization(726)

L:SetWarningLocalization({
	specWarnDespawnFloor		= "가운데 바닥 조심!"
})

L:SetTimerLocalization({
	timerDespawnFloor			= "가운데 바닥 사라짐"
})

L:SetOptionLocalization({
	specWarnDespawnFloor		= "가운데 바닥이 무너지기 전에 특수 경고 보기",
	timerDespawnFloor			= "가운데 바닥이 무너지기 전까지 남은 시간 바 표시"
})


------------
-- Will of the Emperor --
------------
L= DBM:GetModLocalization(677)

L:SetOptionLocalization({
	InfoFrame		= "$spell:116525 주문의 영향을 받은 플레이어를 정보 프레임에 표시"
})

L:SetMiscLocalization({
	Pull		= "기계가 윙윙거리며 동작하기 시작합니다! 아래층으로 가십시오!",--Emote
	Rage		= "황제의 분노가 온 언덕에 울려퍼진다.",--Yell
	Strength	= "황제의 힘이 벽감에 나타납니다!",--Emote
	Courage		= "황제의 용기가 벽감에 나타납니다!",--Emote
	Boss		= "거대한 모구 조형체 둘이 큰 벽감에 나타납니다!"--Emote
})
