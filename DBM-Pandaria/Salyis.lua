local mod	= DBM:NewMod(725, "DBM-Pandaria", nil, 322)	-- 322 = Pandaria/Outdoor I assume
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 10106 $"):sub(12, -3))
mod:SetCreatureID(62346)--Salyis not die. Only Galleon attackable and dies.
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"RAID_BOSS_EMOTE"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

local warnCannonBarrage			= mod:NewSpellAnnounce(121600, 3)
local warnStomp					= mod:NewCastAnnounce(121787, 3, 3)
local warnWarmonger				= mod:NewSpellAnnounce("ej6200", 2, 121747)

local specWarnCannonBarrage		= mod:NewSpecialWarningSpell(121600, mod:IsTank())
local specWarnStomp				= mod:NewSpecialWarningSpell(121787, nil, nil, nil, 2)
local specWarnWarmonger			= mod:NewSpecialWarningSwitch("ej6200", not mod:IsHealer())

local timerCannonBarrageCD		= mod:NewNextTimer(60, 121600)
local timerStompCD				= mod:NewNextTimer(60, 121787)
local timerStomp				= mod:NewCastTimer(3, 121787)
local timerWarmongerCD			= mod:NewNextTimer(10, "ej6200", nil, nil, nil, 121747)--Comes after Stomp. (Also every 60 sec.)

mod:AddBoolOption("ReadyCheck", false)

local yellTriggered = false

function mod:OnCombatStart(delay)
	if yellTriggered then
		timerCannonBarrageCD:Start(24-delay)
		timerStompCD:Start(50-delay)
	end
end

function mod:OnCombatEnd()
	yellTriggered = false
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find("spell:121600") then
		warnCannonBarrage:Show()
		specWarnCannonBarrage:Show()
		timerCannonBarrageCD:Start()
	elseif msg:find("spell:121787") then
		warnStomp:Show()
		specWarnStomp:Show()
		warnWarmonger:Schedule(10)
		specWarnWarmonger:Schedule(10)
		timerStomp:Start()
		timerWarmongerCD:Start()
		timerStompCD:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Pull and not self:IsInCombat() then
		if self:GetCIDFromGUID(UnitGUID("target")) == 62346 or self:GetCIDFromGUID(UnitGUID("targettarget")) == 62346 then--Whole zone gets yell, so lets not engage combat off yell unless he is our target (or the target of our target for healers)
			yellTriggered = true
			DBM:StartCombat(self, 0)
		end
		if self.Options.ReadyCheck and not IsQuestFlaggedCompleted(32098) then
			PlaySoundFile("Sound\\interface\\levelup2.ogg", "Master")
		end
	end
end
