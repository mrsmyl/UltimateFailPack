﻿if GetLocale() ~= "zhTW" then return end
local L

--------------------------
-- Jin'rokh the Breaker --
--------------------------
L= DBM:GetModLocalization(827)

L:SetWarningLocalization({
	specWarnWaterMove	= "%s即將到來 - 離開導電水池!"
})

L:SetOptionLocalization({
	specWarnWaterMove	= "為$spell:137313施放前或$spell:138732效果消失前前顯示特別警告",
	RangeFrame			= "顯示距離框架"
})

--------------
-- Horridon --
--------------
L= DBM:GetModLocalization(819)

L:SetWarningLocalization({
	warnAdds				= "%s",
	warnOrbofControl		= "控獸寶珠掉落",
	specWarnOrbofControl	= "控獸寶珠掉落!"
})

L:SetTimerLocalization({
	timerDoor				= "下一個部族的門",
	timerAdds				= "下一波%s"
})

L:SetOptionLocalization({
	warnAdds				= "提示小怪跳下",
	warnOrbofControl		= "提示$journal:7092掉落",
	specWarnOrbofControl	= "為$journal:7092掉落顯示特別警告",
	timerDoor				= "為下一個部族的門顯示計時器",
	timerAdds				= "為下一次小怪跳下顯示計時器",
	RangeFrame				= "為$spell:136480顯示距離框架(5碼)"
})

L:SetMiscLocalization({
	newForces				= "的門蜂擁而出!",
	chargeTarget			= "用力拍動尾巴!"
})

---------------------------
-- The Council of Elders --
---------------------------
L= DBM:GetModLocalization(816)

L:SetWarningLocalization({
	specWarnPossessed		= "%s在%s - 快換目標"
})

L:SetOptionLocalization({
	PHealthFrame		= "為$spell:136442消散顯示剩餘血量框架(需要首領血量框架開啟)",
	RangeFrame			= "顯示距離框架"
})

------------
-- Tortos --
------------
L= DBM:GetModLocalization(825)

L:SetWarningLocalization({
	warnKickShell			= "%s被>%s<使用 (還剩餘%d)",
	specWarnCrystalShell	= "取得%s"
})

L:SetOptionLocalization({
	specWarnCrystalShell	= "當你沒有$spell:137633減益時顯示特別警告",
	InfoFrame				= "為玩家沒有$spell:137633顯示訊息框架",
	SetIconOnTurtles		= "為$journal:7129標示團隊圖示(超過一名以上的團隊助理時不可靠)",
	ClearIconOnTurtles		= "當$journal:7129中了$spell:133971清除團隊圖示"
})

L:SetMiscLocalization({
	WrongDebuff		= "沒有%s"
})

-------------
-- Megaera --
-------------
L= DBM:GetModLocalization(821)

L:SetTimerLocalization({
	timerBreathsCD			= "下一次吐息"
})

L:SetOptionLocalization({
	timerBreaths			= "為下一次吐息顯示計時器"
})

L:SetMiscLocalization({
	rampageEnds	= "梅賈拉的怒氣平息了。"
})

------------
-- Ji-Kun --
------------
L= DBM:GetModLocalization(828)

L:SetWarningLocalization({
	warnFlock		= "%s %s %s",
	specWarnFlock	= "%s %s %s",
	specWarnBigBird	= "巢穴守護者:%s"
})

L:SetTimerLocalization({
	timerFlockCD	= "蛋巢 (%d): %s"
})

L:SetOptionLocalization({
	RangeFrame		= "為$spell:138923顯示距離框架(10碼)"
})

L:SetMiscLocalization({
	eggsHatchL		= "下層巢裡的蛋開始孵化了!",
	eggsHatchU		= "上層巢裡的蛋開始孵化了!",
	Upper			= "上層",
	Lower			= "下層",
	UpperAndLower	= "上層和下層",
	TrippleD		= "Tripple (2xDwn)",
	TrippleU		= "Tripple (2xUp)",
	SouthWest		= "西南",
	SouthEast		= "東南",
	NorthWest		= "西北",
	NorthEast		= "西南",
	West			= "西邊",
	Middle			= "中間"
})

--------------------------
-- Durumu the Forgotten --
--------------------------
L= DBM:GetModLocalization(818)

L:SetWarningLocalization({
	warnBeamNormal				= "射線 - |cffff0000紅光|r : >%s<, |cff0000ff藍光|r : >%s<",
	warnBeamHeroic				= "射線 - |cffff0000紅光|r : >%s<, |cff0000ff藍光|r : >%s<, |cffffff00黃光|r : >%s<",
	warnAddsLeft				= "霧獸剩餘: %d",
	specWarnBlueBeam			= "你中了藍光射線 - 避免移動!!",
	specWarnFogRevealed			= "照出%s了!",
	specWarnDisintegrationBeam	= "%s (%s)"
})

L:SetOptionLocalization({
	warnBeam					= "提示射線目標",
	warnAddsLeft				= "提示還剩餘多少霧獸",
	specWarnFogRevealed			= "為照出霧獸顯示特別警告",
	ArrowOnBeam					= "為$journal:6882指示DBM箭頭移動方向",
	InfoFrame					= "為$spell:133795堆疊顯示訊息框架"
})

----------------
-- Primordius --
----------------
L= DBM:GetModLocalization(820)

L:SetWarningLocalization({
	warnDebuffCount				= "突變: %d/5有益& %有害",
})

L:SetOptionLocalization({
	warnDebuffCount				= "當你吃池水時顯示減益計算警告",
	RangeFrame					= "顯示距離框架(2碼/5碼)",
})

-----------------
-- Dark Animus --
-----------------
L= DBM:GetModLocalization(824)

L:SetWarningLocalization({
	warnMatterSwapped	= "%s:>%s<和>%s<交換"
})

L:SetOptionLocalization({
	warnMatterSwapped	= "提示目標被$spell:138618交換"
})

L:SetMiscLocalization({
	Pull	= "寶珠爆炸了!"
})

--------------
-- Iron Qon --
--------------
L= DBM:GetModLocalization(817)

L:SetWarningLocalization({
	warnDeadZone	= "%s:%s跟%s開盾"
})

L:SetOptionLocalization({
	RangeFrame		= "顯示動態距離框架(當太多人太接近時會動態顯示)",
	InfoFrame		= "為玩家有$spell:136193顯示訊息框架"
})

-------------------
-- Twin Consorts --
-------------------
L= DBM:GetModLocalization(829)

L:SetWarningLocalization({
	warnNight		= "黑夜階段",
	warnDay			= "白天階段",
	warnDusk		= "黃昏階段"
})

L:SetTimerLocalization({
	timerDayCD		= "白天階段",
	timerDuskCD		= "黃昏階段",
})

L:SetOptionLocalization({
	warnNight		= "提示黑夜階段",
	warnDay			= "提示白天階段",
	warnDusk		= "提示黃昏階段",
	timerDayCD		= "為白天階段顯示計時器",
	timerDuskCD		= "為黃昏階段顯示計時器",
	RangeFrame		= "顯示距離框架(8碼)"
})

L:SetMiscLocalization({
	DuskPhase		= "盧凜!借本宮力量!"
})

--------------
-- Lei Shen --
--------------
L= DBM:GetModLocalization(832)

L:SetWarningLocalization({
	specWarnIntermissionSoon	= "中場階段即將到來"
})


L:SetOptionLocalization({
	specWarnIntermissionSoon	= "在中場階段前顯示預先特別警告",
	RangeFrame					= "顯示距離框架",
	StaticShockArrow			= "當某人中了$spell:135695顯示DBM箭頭",
	OverchargeArrow				= "當某人中了$spell:136295顯示DBM箭頭"
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
	name =	"雷霆王座小怪"
})

L:SetOptionLocalization({
	RangeFrame		= "顯示距離框架(10碼)"
})
