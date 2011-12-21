local mod	= DBM:NewMod(318, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6939 $"):sub(12, -3))
mod:SetCreatureID(53879)
mod:SetModelID(35268)
mod:SetZone()
mod:SetUsedIcons(6, 5, 4, 3, 2, 1)

mod:RegisterCombat("yell", L.Pull)--Engage trigger comes 30 seconds after encounter starts, because of this, the mod can miss the first round of ability casts such as first grip targets. have to use yell

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_HEAL",
	"SPELL_PERIODIC_HEAL",
	"RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

local warnAbsorbedBlood		= mod:NewStackAnnounce(105248, 2)
local warnGrip				= mod:NewTargetAnnounce(109459, 4)
local warnNuclearBlast		= mod:NewCastAnnounce(105845, 4)
local warnSealArmor			= mod:NewCastAnnounce(105847, 4)--Cast by Burning Tendons when they spawn after you break a plate

local specWarnTendril		= mod:NewSpecialWarning("SpecWarnTendril")
local specWarnGrip			= mod:NewSpecialWarningSpell(109459, mod:IsDps())
local specWarnNuclearBlast	= mod:NewSpecialWarningRun(105845, mod:IsMelee())
local specWarnSealArmor		= mod:NewSpecialWarningSpell(105847, mod:IsDps())

local timerSealArmor		= mod:NewCastTimer(23, 105847)
local timerBarrelRoll		= mod:NewCastTimer(5, "ej4050")
--local timerGripCD			= mod:NewCDTimer(25, 109457)

local soundNuclearBlast		= mod:NewSound(105845, nil, mod:IsMelee())

mod:AddBoolOption("InfoFrame", true)
mod:AddBoolOption("SetIconOnGrip", true)
mod:AddBoolOption("ShowShieldInfo", true)

local gripTargets = {}
local gripIcon = 6

local function checkTendrils()
	if not UnitDebuff("player", GetSpellInfo(109454)) and not UnitIsDeadOrGhost("player") then
		specWarnTendril:Show()
	end
	if mod.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
		DBM.InfoFrame:SetHeader(L.NoDebuff:format(GetSpellInfo(109454)))
		DBM.InfoFrame:Show(5, "playergooddebuff", 109454)
	end
end

local function clearTendrils()
	if mod.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

local function showGripWarning()
	warnGrip:Show(table.concat(gripTargets, "<, >"))
	specWarnGrip:Show()
	table.wipe(gripTargets)
end

--This wasn't working right on 25 man at all, i think more then one went out at a time, and it spam changed name, it didn't want to add more then 1 name to frame at a time so instead it kept replacing the frame, alli saw was about 6 names flash by within 1 second.
local clearPlasmaTarget, setPlasmaTarget
do
	local plasmaTargets = {}
	local healed = {}
	
	function mod:SPELL_HEAL(args)
		if plasmaTargets[args.destGUID] then
			healed[args.destGUID] = healed[args.destGUID] + (args.absorbed or 0)
		end
	end
	mod.SPELL_PERIODIC_HEAL = mod.SPELL_HEAL

	function setPlasmaTarget(guid, name)
		plasmaTargets[guid] = name
		healed[guid] = 0
		local maxAbsorb =	mod:IsDifficulty("heroic25") and 420000 or
							mod:IsDifficulty("heroic10") and 280000 or
							mod:IsDifficulty("normal25") and 300000 or
							mod:IsDifficulty("normal10") and 200000 or 1
		if not DBM.BossHealth:IsShown() then
			DBM.BossHealth:Show(L.name)
		end
		DBM.BossHealth:AddBoss(function() return math.max(1, math.floor((healed[guid] or 0) / maxAbsorb * 100))	end, L.PlasmaTarget:format(name))
	end

	function clearPlasmaTarget(guid, name)
		DBM.BossHealth:RemoveBoss(L.PlasmaTarget:format(name))
		plasmaTargets[guid] = nil
		healed[guid] = nil
	end
end



function mod:OnCombatStart(delay)
	if self:IsDifficulty("lfr25") then
		warnSealArmor = mod:NewCastAnnounce(105847, 4, 34.5)
	else
		warnSealArmor = mod:NewCastAnnounce(105847, 4)
	end
	table.wipe(gripTargets)
	gripIcon = 6
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(105845) and args.sourceGUID == UnitGUID("target") then--Only warn if it's your target, if it isn't you're probably not by the one exploding.
		warnNuclearBlast:Show()
		specWarnNuclearBlast:Show()
		soundNuclearBlast:Play()
	elseif args:IsSpellID(105847, 105848) then -- sometimes spellid 105848, maybe related to positions?
		warnSealArmor:Show()
		specWarnSealArmor:Show()
		if self:IsDifficulty("lfr25") then
			timerSealArmor:Start(34.5)
		else
			timerSealArmor:Start()
		end
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(105490, 109457, 109458, 109459) then
		timerGripCD:Start(args.sourceGUID)--args.sourceGUID is to support multiple cds when more then 1 is up at once
	end
end
--]]

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(105248) then
		warnAbsorbedBlood:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(105490, 109457, 109458, 109459) then--This ability is not used in LFR, so if you add a CD bar for this, make sure you exclude LFR.
		gripTargets[#gripTargets + 1] = args.destName
		if self.Options.SetIconOnGrip then
			if gripIcon == 0 then
				gripIcon = 6
			end
			self:SetIcon(args.destName, gripIcon)
			gripIcon = gripIcon - 1
		end
		self:Unschedule(showGripWarning)
		self:Schedule(0.3, showGripWarning)
	elseif args:IsSpellID(105479, 109362, 109363, 109364) then -- 105479 in 10 man. otherid is drycoded.
		if self.Options.ShowShieldInfo then
			setPlasmaTarget(args.destGUID, args.destName)
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(105490, 109457, 109458, 109459) then
		if self.Options.SetIconOnGrip then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(105479, 109362, 109363, 109364) then -- 105479 in 10 man. otherid is drycoded.
		if self.Options.ShowShieldInfo then
			clearPlasmaTarget(args.destGUID, args.destName)
		end
	end
end	

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.DRoll or msg:find(L.DRoll) then
		self:Unschedule(checkTendrils)--In case you manage to spam spin him, we don't want to get a bunch of extra stuff scheduled.
		self:Unschedule(clearTendrils)--^
		checkTendrils()--Warn you right away.
		self:Schedule(3, checkTendrils)--Check a second time 3 seconds into 5 second cast to remind player
		self:Schedule(8, clearTendrils)--Clearing 3 seconds after the roll should be sufficent
		timerBarrelRoll:Start()
	elseif msg == L.DLevels or msg:find(L.DLevels) then
		self:Unschedule(checkTendrils)
		self:Unschedule(clearTendrils)
		clearTendrils()
		timerBarrelRoll:Cancel()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53891 then
--		timerGripCD:Cancel(args.sourceGUID)
	elseif cid == 56341 then
		timerSealArmor:Cancel(args.sourceGUID)
	end
end