local mod	= DBM:NewMod(691, "DBM-Pandaria", nil, 322)	-- 322 = Pandaria/Outdoor I assume
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 7778 $"):sub(12, -3))
mod:SetCreatureID(60491)
mod:SetModelID(41448)
mod:SetZone(809)--Kun-Lai Summit (zoneid not yet known)
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)

-- TODO: This is field boss, if you die while combat, you can go tomb and revive as you wish.
-- But if you go tomb, DBM regards combat ends and messing up timer and warns.
-- So, needs to improve combat detection and ends on field boss. 
-- Also, you can enter combat while boss fights (not 100% health). 
-- On this situration, block OnCombatStart() function will be better (+ do not record kill time)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_AURA"
)

local warnUnleashedWrath		= mod:NewSpellAnnounce(119488, 3)--Big aoe damage aura when at 100 rage
local warnGrowingAnger			= mod:NewTargetAnnounce(119622, 4)--Mind control trigger
local warnAggressiveBehavior	= mod:NewTargetAnnounce(119626, 4)--Actual mind control targets

local specWarnUnleashedWrath	= mod:NewSpecialWarningSpell(119488, mod:IsTank() or mod:IsHealer())--Defaults to tank and healers cause tank probalby want to Cd through this and healers have to heal it, dps just do what they always do and kill stuff.
local specWarnGrowingAnger		= mod:NewSpecialWarningYou(119622)
local specWarnBitterThoughts	= mod:NewSpecialWarningMove(119610)

local timerGrowingAngerCD		= mod:NewCDTimer(32, 119622)--Min 32.6~ Max 67.8
local timerUnleashedWrathCD		= mod:NewCDTimer(77, 119488)--Based on rage, but timing is consistent enough to use a CD bar, might require some perfecting later, similar to xariona's special, if rage doesn't reset after wipes, etc.
local timerUnleashedWrath		= mod:NewBuffActiveTimer(24, 119488, nil, mod:IsTank() or mod:IsHealer())

--local berserkTimer				= mod:NewBerserkTimer(900)--he did not seems to berserk. my combat lasts 20 min, not berserks at all.

mod:AddBoolOption("RangeFrame", true)--For Mind control spreading.
mod:AddBoolOption("SetIconOnMC", true)

local warnpreMCTargets = {}
local warnMCTargets = {}
local mcTargetIcons = {}
local mcIcon = 8
local bitterThought = GetSpellInfo(119601)

local function debuffFilter(uId)
	return UnitDebuff(uId, GetSpellInfo(119622))
end

local function removeIcon(target)
	for i,j in ipairs(mcTargetIcons) do
		if j == target then
			table.remove(mcTargetIcons, i)
			mod:SetIcon(target, 0)
		end
	end
end

local function clearMCTargets()
	table.wipe(mcTargetIcons)
	mcIcon = 8
end

do
	local function sortByGroup(v1, v2)
		return DBM:GetRaidSubgroup(DBM:GetUnitFullName(v1)) < DBM:GetRaidSubgroup(DBM:GetUnitFullName(v2))
	end
	function mod:SetMCIcons()
		if DBM:GetRaidRank() > 0 then
			table.sort(mcTargetIcons, sortByGroup)
			for i, v in ipairs(mcTargetIcons) do
				self:SetIcon(v, mcIcon)
				mcIcon = mcIcon - 1
			end
			self:Schedule(10, clearMCTargets)--delay 10 sec. (mc sperad takes 2~3 sec, and dead players do not get the SPELL_AURA_REMOVED event)
		end
	end
end

function mod:updateRangeFrame()
	if not self.Options.RangeFrame then return end
	if UnitDebuff("player", GetSpellInfo(119622)) then
		DBM.RangeCheck:Show(5, nil)--Show everyone.
	else
		DBM.RangeCheck:Show(5, debuffFilter)--Show only people who have debuff.
	end
end

local function showpreMC()
	mod:updateRangeFrame()
	warnGrowingAnger:Show(table.concat(warnpreMCTargets, "<, >"))
	table.wipe(warnpreMCTargets)
	mcIcon = 8
end

local function showMC()
	warnAggressiveBehavior:Show(table.concat(warnMCTargets, "<, >"))
	table.wipe(warnMCTargets)
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:OnCombatStart(delay)
	table.wipe(warnpreMCTargets)
	table.wipe(warnMCTargets)
	mcIcon = 8
--	timerUnleashedWrathCD:Start(-delay)
--	timerGrowingAngerCD:Start(-delay)
--	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(119488) then
		warnUnleashedWrath:Show()
		specWarnUnleashedWrath:Show()
		timerUnleashedWrath:Start()
	elseif args:IsSpellID(119622) then
		timerGrowingAngerCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(119622) then
		warnpreMCTargets[#warnpreMCTargets + 1] = args.destName
		if self.Options.SetIconOnMC then--Set icons on first debuff to get an earlier spread out.
			table.insert(mcTargetIcons, DBM:GetRaidUnitId(args.destName))
			self:UnscheduleMethod("SetMCIcons")
			if self:LatencyCheck() then
				self:ScheduleMethod(0.5, "SetMCIcons")
			end
		end
		if args:IsPlayer() then
			specWarnGrowingAnger:Show()
		end
		self:Unschedule(showpreMC)
		if #warnpreMCTargets >= 3 then
			showpreMC()
		else
			self:Schedule(1.0, showpreMC)
		end
	elseif args:IsSpellID(119626) then
		--Maybe add in function to update icons here in case of a spread that results in more then the original 3 getting the final MC debuff.
		warnMCTargets[#warnMCTargets + 1] = args.destName
		self:Unschedule(showMC)
		self:Schedule(2.5, showMC)--These can be vastly spread out, not even need to use 3, depends on what more data says. As well as spread failures.
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(119626) and self.Options.SetIconOnMC then--Remove them after the MCs break.
		removeIcon(args.destName)
	elseif args:IsSpellID(119488) then
		timerUnleashedWrathCD:Start()
	end
end

function mod:UNIT_AURA(uId)
	if uId ~= "player" then return end
	if UnitDebuff("player", bitterThought) and self:AntiSpam(2) then
		specWarnBitterThoughts:Show()
	end
end
