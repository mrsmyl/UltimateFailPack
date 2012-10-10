﻿-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 9/27/2012

if GetLocale() ~= "zhCN" then return end
local L

------------
-- Protectors of the Endless --
------------
L= DBM:GetModLocalization(683)

L:SetOptionLocalization({
	RangeFrame			= "距离监视（8码）：$spell:111850\n当你受到效果影响时会显示其他所有没有受到效果影响的队友",
	SetIconOnPrison		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(117436)
})


------------
-- Tsulong --
------------
L= DBM:GetModLocalization(742)

L:SetMiscLocalization{
	Victory	= "I thank you, strangers. I have been freed."
}


-------------------------------
-- Lei Shi --
-------------------------------
L= DBM:GetModLocalization(729)

L:SetWarningLocalization({
	warnHideOver			= "%s 结束"
})

L:SetTimerLocalization({
	timerSpecialCD			= "下一次特殊能力"
})

L:SetOptionLocalization({
	warnHideOver			= "特殊警报：$spell:123244效果结束时",
	timerSpecialCD			= "计时条：下一次特殊能力"
})

L:SetMiscLocalization{
	Victory	= "I... ah... oh! Did I...? Was I...? It was... so... cloudy."--wtb alternate and less crappy victory event.
}


----------------------
-- Sha of Fear --
----------------------
L= DBM:GetModLocalization(709)

