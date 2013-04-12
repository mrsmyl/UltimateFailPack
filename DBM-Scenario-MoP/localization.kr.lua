﻿if GetLocale() ~= "koKR" then return end
local L

----------------------
-- Theramore's Fall --
----------------------

L= DBM:GetModLocalization("TheramoreFall")

L:SetGeneralLocalization{
	name = "테라모어의 몰락"
}

---------------------------
-- Arena Of Annihilation --
---------------------------

L= DBM:GetModLocalization("ArenaAnnihilation")

L:SetGeneralLocalization{
	name = "파멸의 투기장"
}

--------------
-- Landfall --
--------------

L = DBM:GetModLocalization("Landfall")

local landfall
if UnitFactionGroup("player") == "Alliance" then
	landfall = "사자의 상륙지"
else
	landfall = "지배령 거점"
end

L:SetGeneralLocalization({
	name = landfall
})

L:SetWarningLocalization({
	WarnAchFiveAlive	= "\"불사전설\" 업적 실패"
})

L:SetOptionLocalization({
	WarnAchFiveAlive	= "\"불사전설\" 업적 실패시 알림 보기"
})


--------------------------------
-- Troves of the Thunder King --
--------------------------------

L= DBM:GetModLocalization("Troves")

L:SetGeneralLocalization{
	name = "천둥왕의 보물"
}

------------------------
-- Warlock Green Fire --
------------------------

L= DBM:GetModLocalization("GreenFire")

L:SetGeneralLocalization{
	name = "암흑의 수확을 쫓아서"
}

L:SetWarningLocalization({
	specWarnLostSouls		= "길 잃은 영혼!",
	specWarnEnslavePitLord	= "지옥의 군주 - 지배하세요!"
})

L:SetTimerLocalization({
	timerCombatStarts		= "전투 시작",
	timerLostSoulsCD		= "길 잃은 영혼 가능"
})

L:SetOptionLocalization({
	specWarnLostSouls		= "긹 잃은 영혼 소환시 특수 경고 보기",
	specWarnEnslavePitLord	= "지옥의 군주 활성화 또는 지배 해제시 특수 경고 보기",
	timerCombatStarts		= "전투 시작 바 표시",
	timerLostSoulsCD		= "길 잃은 영혼 대기시간 바 표시"
})

L:SetMiscLocalization({
	LostSouls				= "이곳의 힘은 너 따위의 것이 아니다. 흑마법사!"
})
