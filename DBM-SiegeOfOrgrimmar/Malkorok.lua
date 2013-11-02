local mod	= DBM:NewMod(846, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 10614 $"):sub(12, -3))
mod:SetCreatureID(71454)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 4, 3, 2, 1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--Endless Rage
local warnBloodRage						= mod:NewSpellAnnounce(142879, 3)
local warnDisplacedEnergy				= mod:NewTargetAnnounce(142913, 3)
--Might of the Kor'kron
local warnArcingSmash					= mod:NewCountAnnounce(142815, 4)--Target scanning doesn't work, no boss1target or boss1targettarget
local warnSeismicSlam					= mod:NewCountAnnounce(142851, 3)
local warnBreathofYShaarj				= mod:NewCountAnnounce(142842, 4)
local warnFatalStrike					= mod:NewStackAnnounce(142990, 2, nil, mod:IsTank())

--Endless Rage
local specWarnBloodRage					= mod:NewSpecialWarningSpell(142879, nil, nil, nil, 2)
local specWarnBloodRageEnded			= mod:NewSpecialWarningFades(142879)
local specWarnDisplacedEnergy			= mod:NewSpecialWarningRun(142913)
local yellDisplacedEnergy				= mod:NewYell(142913)
--Might of the Kor'kron
local specWarnArcingSmash				= mod:NewSpecialWarningCount(142815, nil, nil, nil, 2)
local specWarnImplodingEnergySoon		= mod:NewSpecialWarningPreWarn(142986, nil, 4)
local specWarnBreathofYShaarj			= mod:NewSpecialWarningCount(142842, nil, nil, nil, 3)
local specWarnFatalStrike				= mod:NewSpecialWarningStack(142990, mod:IsTank(), 12)--stack guessed, based on CD
local specWarnFatalStrikeOther			= mod:NewSpecialWarningTarget(142990, mod:IsTank())

local timerBloodRage					= mod:NewBuffActiveTimer(22.5, 142879)--2.5sec cast plus 20 second duration
local timerDisplacedEnergyCD			= mod:NewNextTimer(11, 142913)
local timerBloodRageCD					= mod:NewNextTimer(127.7, 142879)
--Might of the Kor'kron
local timerArcingSmashCD				= mod:NewNextCountTimer(17.5, 142815)--17-18 variation (the 23 second ones are delayed by Breath of Yshaarj)
local timerImplodingEnergy				= mod:NewCastTimer(10, 142986)--Always 10 seconds after arcing
local timerSeismicSlamCD				= mod:NewNextCountTimer(17.5, 142851)--Works exactly same as arcingsmash 18 sec unless delayed by breath. two sets of 3
local timerBreathofYShaarjCD			= mod:NewNextCountTimer(59, 142842)
local timerFatalStrike					= mod:NewTargetTimer(30, 142990, nil, mod:IsTank())

local berserkTimer						= mod:NewBerserkTimer(360)

local countdownImplodingEnergy			= mod:NewCountdown(10, 142986, nil, nil, 8)

local soundDisplacedEnergy				= mod:NewSound(142913)

mod:AddRangeFrameOption("8/5")--Various things
mod:AddSetIconOption("SetIconOnDisplacedEnergy", 142913, false)
mod:AddSetIconOption("SetIconOnAdds", "ej7952", false, true)

local displacedEnergyDebuff = GetSpellInfo(142913)
local playerDebuffs = 0
local breathCast = 0
local arcingSmashCount = 0
local seismicSlamCount = 0
local displacedCast = false
local rageActive = false
local UnitDebuff = UnitDebuff
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local debuffFilter
do
	debuffFilter = function(uId)
		return UnitDebuff(uId, displacedEnergyDebuff)
	end
end

function mod:OnCombatStart(delay)
	playerDebuffs = 0
	breathCast = 0
	arcingSmashCount = 0
	seismicSlamCount = 0
	rageActive = false
	if self:IsDifficulty("lfr25") then
		timerSeismicSlamCD:Start(7.5-delay, 1)
		timerArcingSmashCD:Start(14-delay, 1)
		timerBreathofYShaarjCD:Start(70-delay, 1)
	else
		timerSeismicSlamCD:Start(5-delay, 1)
		timerArcingSmashCD:Start(14-delay, 1)
		timerBreathofYShaarjCD:Start(-delay, 1)
	end
	timerBloodRageCD:Start(122-delay)
	if self:IsDifficulty("lfr25") then
		berserkTimer:Start(720-delay)
	else
		berserkTimer:Start(-delay)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 142879 then
		displacedCast = false
		rageActive = true
		warnBloodRage:Show()
		specWarnBloodRage:Show()
		timerBloodRage:Start()
		timerDisplacedEnergyCD:Start(3.5)
	elseif args.spellId == 142842 then
		breathCast = breathCast + 1
		warnBreathofYShaarj:Show(breathCast)
		specWarnBreathofYShaarj:Show(breathCast)
		if breathCast == 1 then
			arcingSmashCount = 0
			seismicSlamCount = 0
			if self:IsDifficulty("lfr25") then
				timerSeismicSlamCD:Start(7.5, 1)
				timerArcingSmashCD:Start(14, 1)
				timerBreathofYShaarjCD:Start(70, 2)
			else
				timerSeismicSlamCD:Start(5, 1)
				timerArcingSmashCD:Start(11, 1)
				timerBreathofYShaarjCD:Start(nil, 2)
			end
		end
	elseif args.spellId == 143199 then
		breathCast = 0
		arcingSmashCount = 0
		seismicSlamCount = 0
		rageActive = false
		specWarnBloodRageEnded:Show()
		if self:IsDifficulty("lfr25") then
			timerSeismicSlamCD:Start(7.5, 1)
			timerArcingSmashCD:Start(14, 1)
			timerBreathofYShaarjCD:Start(70, 1)
		else
			timerSeismicSlamCD:Start(5, 1)
			timerArcingSmashCD:Start(11, 1)
			timerBreathofYShaarjCD:Start(nil, 1)
		end
		timerBloodRageCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 142851 then
		seismicSlamCount = seismicSlamCount + 1
		warnSeismicSlam:Show(seismicSlamCount)
		if seismicSlamCount < 3 then
			if self:IsDifficulty("lfr25") then
				timerSeismicSlamCD:Start(19.5, seismicSlamCount+1)
			else
				timerSeismicSlamCD:Start(nil, seismicSlamCount+1)
			end
		end
		if self.Options.SetIconOnAdds and self:IsDifficulty("heroic10", "heroic25") then
			self:ScanForMobs(71644, 0, 8, nil, 0.2, 6)
		end
	elseif args.spellId == 143913 then--May not be right spell event
		--5 rage gained from Essence of Y'Shaarj would progress timer about 2.5 seconds
		--May choose a more accurate UNIT_POWER monitoring method if this doesn't feel accurate enough
		if self:AntiSpam() then
			local elapsed, total = timerBloodRageCD:GetTime()
			timerBloodRageCD:Update(elapsed+2.5, total)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 142913 then
		warnDisplacedEnergy:CombinedShow(0.5, args.destName)
		playerDebuffs = playerDebuffs + 1
		if args:IsPlayer() then
			specWarnDisplacedEnergy:Show()
			soundDisplacedEnergy:Play()
			yellDisplacedEnergy:Yell()
		end
		if not displacedCast then--Only cast twice, so we only start cd bar once here
			displacedCast = true
			timerDisplacedEnergyCD:DelayedStart(0.5)
		end
		if self.Options.SetIconOnDisplacedEnergy and args:IsDestTypePlayer() then--Filter further on icons because we don't want to set icons on grounding totems
			self:SetSortedIcon(0.5, args.destName, 1)
		end
		if self.Options.RangeFrame then
			if UnitDebuff("player", displacedEnergyDebuff) then--You have debuff, show everyone
				DBM.RangeCheck:Show(8, nil)
			else--You do not have debuff, only show players who do
				DBM.RangeCheck:Show(8, debuffFilter)
			end
		end
	elseif args.spellId == 142990 then
		local amount = args.amount or 1
		if amount % 3 == 0 then
			warnFatalStrike:Show(args.destName, amount)
		end
		timerFatalStrike:Start(args.destName)
		if amount % 3 == 0 and amount >= 12 then
			if args:IsPlayer() then--At this point the other tank SHOULD be clear.
				specWarnFatalStrike:Show(amount)
			else--Taunt as soon as stacks are clear, regardless of stack count.
				if not UnitDebuff("player", GetSpellInfo(142990)) and not UnitIsDeadOrGhost("player") then
					specWarnFatalStrikeOther:Show(args.destName)
				end
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 142913 then
		playerDebuffs = playerDebuffs - 1
		if args:IsPlayer() and self.Options.RangeFrame and playerDebuffs >= 1 then
			DBM.RangeCheck:Show(10, debuffFilter)--Change to debuff filter based check since theirs is gone but there are still others in raid.
		end
		if self.Options.RangeFrame and playerDebuffs == 0 and rageActive then--All of them are gone. We do it this way since some may cloak/bubble/iceblock early and we don't want to just cancel range finder if 1 of 3 end early.
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnDisplacedEnergy then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 142898 then--Faster than combat log
		arcingSmashCount = arcingSmashCount + 1
		warnArcingSmash:Show(arcingSmashCount)
		specWarnArcingSmash:Show(arcingSmashCount)
		timerImplodingEnergy:Start()
		countdownImplodingEnergy:Start()
		specWarnImplodingEnergySoon:Schedule(6)
		if arcingSmashCount < 3 then
			if self:IsDifficulty("lfr25") then
				timerArcingSmashCD:Start(19.5, arcingSmashCount+1)
			else
				timerArcingSmashCD:Start(nil, arcingSmashCount+1)
			end
		end
	end
end
