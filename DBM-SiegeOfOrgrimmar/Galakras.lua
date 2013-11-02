local mod	= DBM:NewMod(868, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 10671 $"):sub(12, -3))
mod:SetCreatureID(72311, 72560, 72249, 73910, 72302, 72561, 73909)--Boss needs to engage off friendly NCPS, not the boss. I include the boss too so we don't detect a win off losing varian. :)
mod:SetReCombatTime(180, 15)--fix combat re-starts after killed. Same issue as tsulong. Fires TONS of IEEU for like 1-2 minutes after fight ends.
mod:SetMainBossID(72249)
mod:SetZone()
mod:SetUsedIcons(8, 7, 2)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UPDATE_WORLD_STATES",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

--Stage 2: Bring Her Down!
local warnWarBanner					= mod:NewSpellAnnounce(147328, 3)
local warnFracture					= mod:NewTargetAnnounce(146899, 3)
local warnChainHeal					= mod:NewCastAnnounce(146757, 4)
local warnDemolisher				= mod:NewSpellAnnounce("ej8562", 3, 116040)
local warnTowerGrunt				= mod:NewAnnounce("warnTowerGrunt", 3, 89253)
----Master Cannoneer Dragryn (Tower)
local warnMuzzleSpray				= mod:NewSpellAnnounce(147824, 3)--147824 spams combat log, 147825 is actual cast but does not show in combat log only UNIT event
----Lieutenant General Krugruk (Tower)
local warnArcingSmash				= mod:NewSpellAnnounce(147688, 3)
----High Enforcer Thranok (Road)
local warnCrushersCall				= mod:NewSpellAnnounce(146769, 4)
local warnShatteringCleave			= mod:NewSpellAnnounce(146849, 3, nil, mod:IsTank())

--Phase 3: Galakras,The Last of His Progeny
local warnPhase2					= mod:NewPhaseAnnounce(2, 2)
local warnFlamesofGalakrondTarget	= mod:NewTargetAnnounce(147068, 4)
local warnFlamesofGalakrond			= mod:NewStackAnnounce(147029, 2, nil, mod:IsTank())

--Stage 2: Bring Her Down!
local specWarnWarBanner				= mod:NewSpecialWarningSwitch(147328, not mod:IsHealer())
local specWarnFracture				= mod:NewSpecialWarningTarget(146899, mod:IsHealer())
local specWarnChainheal				= mod:NewSpecialWarningInterrupt(146757)
local specWarnFlameArrow			= mod:NewSpecialWarningMove(146764)
----Master Cannoneer Dragryn (Tower)
local specWarnMuzzleSpray			= mod:NewSpecialWarningSpell(147824, nil, nil, nil, 2)
----Lieutenant General Krugruk (Tower)
local specWarnArcingSmash			= mod:NewSpecialWarningSpell(147688, nil, nil, nil, 2)
----High Enforcer Thranok (Road)
local specWarnCrushersCall			= mod:NewSpecialWarningSpell(146769, false, nil, nil, 2)--optional pre warning for the grip soon. although melee/tank probably don't really care and ranged are 50/50
----Korgra the Snake (Road)
local specWarnPoisonCloud			= mod:NewSpecialWarningMove(147705)
--Phase 3: Galakras,The Last of His Progeny
local specWarnFlamesofGalakrond		= mod:NewSpecialWarningCount(147029, false, nil, nil, 2)--Cast often, so lets make this optional since it's spammy
local specWarnFlamesofGalakrondYou	= mod:NewSpecialWarningYou(147068)
local yellFlamesofGalakrond			= mod:NewYell(147068)
local specWarnFlamesofGalakrondTank	= mod:NewSpecialWarningStack(147029, mod:IsTank(), 3)
local specWarnFlamesofGalakrondOther= mod:NewSpecialWarningTarget(147029, mod:IsTank())

--Stage 2: Bring Her Down!
local timerAddsCD					= mod:NewNextTimer(55, "ej8553", nil, nil, nil, 2457)
local timerTowerCD					= mod:NewTimer(99, "timerTowerCD", 88852)
local timerTowerGruntCD				= mod:NewTimer(60, "timerTowerGruntCD", 89253)
local timerDemolisherCD				= mod:NewNextTimer(20, "ej8562", nil, nil, nil, 116040)--EJ is just not complete yet, shouldn't need localizing
local timerProtoCD					= mod:NewNextTimer(55, "ej8587", nil, nil, nil, 59961)
----High Enforcer Thranok (Road)
local timerShatteringCleaveCD		= mod:NewCDTimer(7.5, 146849, nil, mod:IsTank())
local timerCrushersCallCD			= mod:NewNextTimer(30, 146769)

--Phase 3: Galakras,The Last of His Progeny
local timerFlamesofGalakrondCD		= mod:NewCDCountTimer(6, 147068)
local timerFlamesofGalakrond		= mod:NewTargetTimer(15, 147029, nil, mod:IsTank())

mod:AddSetIconOption("FixateIcon", 147068)
mod:AddSetIconOption("SetIconOnAdds", "ej8556", false, true)

local addsCount = 0
local firstTower = 0--0: first tower not started, 1: first tower started, 2: first tower breached
local flamesCount = 0


local function TowerGrunt()
	warnTowerGrunt:Show()
	timerTowerGruntCD:Start()
	mod:Schedule(60, TowerGrunt)
end

function mod:OnCombatStart(delay)
	addsCount = 0
	firstTower = 0
	flamesCount = 0
--	timerAddsCD:Start(6.5-delay)--First wave actually seems to have a couple second variation, since timer is so short anyways, just disabling it
	if not self:IsDifficulty("heroic10", "heroic25") then
		timerTowerCD:Start(116.5-delay)
	else
		timerTowerGruntCD:Start(6)
		mod:Schedule(6, TowerGrunt)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 147688 and UnitPower("player", ALTERNATE_POWER_INDEX) > 0 then--Tower Spell
		warnArcingSmash:Show()
		specWarnArcingSmash:Show()
	elseif args.spellId == 146757 and UnitPower("player", ALTERNATE_POWER_INDEX) == 0 then
		local source = args.sourceName
		warnChainHeal:Show()
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnChainheal:Show(source)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 147824 and UnitPower("player", ALTERNATE_POWER_INDEX) > 0 and self:AntiSpam(3, 2) then--Tower Spell
		warnMuzzleSpray:Show()
		specWarnMuzzleSpray:Show()
	elseif args.spellId == 146769 and UnitPower("player", ALTERNATE_POWER_INDEX) == 0 then
		warnCrushersCall:Show()
		specWarnCrushersCall:Show()
		timerCrushersCallCD:Start()
	elseif args.spellId == 146849 and UnitPower("player", ALTERNATE_POWER_INDEX) == 0 then
		warnShatteringCleave:Show()
		timerShatteringCleaveCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 147068 then
		flamesCount = flamesCount + 1
		warnFlamesofGalakrondTarget:Show(args.destName)
		timerFlamesofGalakrondCD:Cancel(flamesCount)
		timerFlamesofGalakrondCD:Start(nil, flamesCount+1)
		if args:IsPlayer() then
			specWarnFlamesofGalakrondYou:Show()
			yellFlamesofGalakrond:Yell()
		else
			specWarnFlamesofGalakrond:Show(flamesCount)
		end
		if self.Options.FixateIcon then
			self:SetIcon(args.destName, 2)
		end
	elseif args.spellId == 147328 and UnitPower("player", ALTERNATE_POWER_INDEX) == 0 then
		warnWarBanner:Show()
		specWarnWarBanner:Show()
	elseif args.spellId == 146899 and UnitPower("player", ALTERNATE_POWER_INDEX) == 0 then
		warnFracture:Show(args.destName)
		specWarnFracture:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 147029 then--Tank debuff version
		local uId = DBM:GetRaidUnitId(args.destName)
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID then
				if self:IsTanking(uId, bossUnitID) then
					local amount = args.amount or 1
					warnFlamesofGalakrond:Show(args.destName, amount)
					timerFlamesofGalakrond:Start(args.destName)
					if amount >= 3 then
						if args:IsPlayer() then
							specWarnFlamesofGalakrondTank:Show(amount)
						else
							specWarnFlamesofGalakrondOther:Show(args.destName)
						end
					end
				end
				break--break loop if find right boss
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 147068 then
		if self.Options.FixateIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 147029 then--Tank debuff version
		timerFlamesofGalakrond:Cancel(args.destName)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 147705 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnPoisonCloud:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 146764 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnFlameArrow:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 72249 then--Main Boss ID
		DBM:EndCombat(self)
	elseif cid == 72355 then--High Enforcer Thranok
		timerShatteringCleaveCD:Cancel()
		timerCrushersCallCD:Cancel()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 50630 and self:AntiSpam(2, 3) then--Eject All Passengers:
		timerAddsCD:Cancel()
		timerProtoCD:Cancel()
		warnPhase2:Show()
		timerFlamesofGalakrondCD:Start(18.6, 1)--TODO, verify consistency since this timing may depend on where drake lands and time it takes to get picked up.
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.newForces1 or msg == L.newForces1H or msg == L.newForces2 or msg == L.newForces3 or msg == L.newForces4 then
		self:SendSync("Adds")
	elseif msg == L.Pull and not self:IsInCombat() then
		DBM:StartCombat(self, 0)
	end
end

function mod:UPDATE_WORLD_STATES()
	local text = select(4, GetWorldStateUIInfo(4))
	local percent = tonumber(string.match(text or "", "%d+"))
	if percent == 1 and (firstTower == 0) and not self:IsDifficulty("heroic10", "heroic25") then
		firstTower = 1
		timerTowerCD:Start()
	end
end

--"<167.7 21:23:40> [CHAT_MSG_RAID_BOSS_EMOTE] CHAT_MSG_RAID_BOSS_EMOTE#Warlord Zaela orders a |cFFFF0404|hKor'kron Demolisher|h|r to assault the tower!
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("cFFFF0404") then--They fixed epiccenter bug (figured they would). Color code should be usuable though. It's only emote on encounter that uses it.
		warnDemolisher:Show()
		if self:IsDifficulty("heroic10", "heroic25") and firstTower == 1 then
			timerTowerGruntCD:Start(15)
			self:Schedule(15, TowerGrunt)
			firstTower = 2
		end
	elseif msg:find(L.tower) then
		timerDemolisherCD:Start()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerTowerGruntCD:Cancel()
			self:Unschedule(TowerGrunt)
		end
	end
end

function mod:OnSync(msg)
	if msg == "Adds" and self:AntiSpam(10, 4) then
		addsCount = addsCount + 1
		if addsCount == 1 then
			timerAddsCD:Start(48)
		elseif addsCount == 3 or addsCount == 7 or addsCount == 11 then--Verified. Every 4th wave gets a proto. IE waves 4, 8, 12
			timerProtoCD:Start()
			timerAddsCD:Start(110)
		else
			timerAddsCD:Start()
		end
		if self.Options.SetIconOnAdds then
			self:ScanForMobs(72958, 0, 8, 2, 0.2, 8)
		end
	end
end
