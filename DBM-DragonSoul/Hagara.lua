local mod	= DBM:NewMod(317, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6977 $"):sub(12, -3))
mod:SetCreatureID(55689)
mod:SetModelID(39318)
mod:SetZone()
mod:SetUsedIcons(3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnTempest			= mod:NewCastAnnounce(109552, 4)
local warnLightningStorm	= mod:NewSpellAnnounce(105465, 4)
local warnAssault			= mod:NewSpellAnnounce(107851, 4, nil, mod:IsHealer() or mod:IsTank())
local warnShatteringIce		= mod:NewTargetAnnounce(105289, 3, nil, mod:IsHealer())--3 second cast, give a healer a heads up of who's about to be kicked in the face.
local warnFrostTombCast		= mod:NewAnnounce("warnFrostTombCast", 4, 104448)--Can't use a generic, cause it's an 8 second cast even though it says 1second in tooltip.
local warnFrostTomb			= mod:NewTargetAnnounce(104451, 4)
local warnIceLance			= mod:NewTargetAnnounce(105269, 3)
local warnFrostflake		= mod:NewTargetAnnounce(109325, 3, nil, mod:IsHealer())--Spammy, only a dispeller really needs to know this, probably a healer assigned to managing it.
local warnStormPillars		= mod:NewSpellAnnounce(109557, 3, nil, false)--Spammy, off by default (since we can't get a target anyways.

local specWarnIceLance		= mod:NewSpecialWarningStack(107061, nil, 3)
local specWarnFrostTombCast	= mod:NewSpecialWarningSpell(104448, nil, nil, nil, true)
local specWarnTempest		= mod:NewSpecialWarningSpell(109552, nil, nil, nil, true)
local specWarnLightingStorm	= mod:NewSpecialWarningSpell(105465, nil, nil, nil, true)
local specWarnAssault		= mod:NewSpecialWarningSpell(107851, mod:IsTank())
--local specWarnFrostTomb		= mod:NewSpecialWarningYou(104451)
local specWarnWatery		= mod:NewSpecialWarningMove(110317)
--local specWarnStormPillars	= mod:NewSpecialWarningClose(109557)	-- target was always nil on my pulls. She didn't target anyone
local specWarnFrostflake	= mod:NewSpecialWarningYou(109325)
local yellFrostflake		= mod:NewYell(109325)

local timerFrostTomb		= mod:NewCastTimer(8, 104448)
local timerFrostTombCD		= mod:NewNextTimer(20, 104451)
local timerIceLance			= mod:NewBuffActiveTimer(15, 105269)
local timerShatteringCD		= mod:NewCDTimer(10.5, 105289)--every 10.5-15 seconds
local timerIceLanceCD		= mod:NewNextTimer(30, 105269)
local timerSpecialCD		= mod:NewTimer(62, "TimerSpecial", "Interface\\Icons\\Spell_Nature_WispSplode")
local timerTempestCD		= mod:NewNextTimer(62, 105256)
local timerLightningStormCD	= mod:NewNextTimer(62, 105465)
local timerIceWave			= mod:NewNextTimer(10, 105314)
local timerFeedback			= mod:NewBuffActiveTimer(15, 108934)
local timerAssault			= mod:NewBuffActiveTimer(5, 107851, nil, mod:IsTank() or mod:IsTank())
local timerAssaultCD		= mod:NewCDTimer(15.5, 107851, nil, mod:IsTank() or mod:IsTank())
local timerStormPillarCD	= mod:NewNextTimer(5, 109557)--Both of these are just spammed every 5 seconds on new targets.
local timerFrostFlakeCD		= mod:NewNextTimer(5, 109325)

local berserkTimer			= mod:NewBerserkTimer(480)	-- according to Icy-Veins

local SpecialCountdown		= mod:NewCountdown(62, 105256)--Apparently countdown prototype doesn't support localized text, too lazy to do that now, so i'll just use tempest, even though it's enabled for both specials.

mod:AddBoolOption("RangeFrame")--Ice lance spreading in ice phases, and lighting linking in lighting phases (with reverse intent, staying within 10 yards, not out of 10 yards)
mod:AddBoolOption("SetIconOnFrostflake", false)--You can use an icon if you want, but this is cast on a new target every 5 seconds, often times on 25 man 2-3 have it at same time while finding a good place to drop it.
mod:AddBoolOption("SetIconOnFrostTomb", true)
mod:AddBoolOption("AnnounceFrostTombIcons", false)

local lanceTargets = {}
local tombTargets = {}
local tombIconTargets = {}

--[[
"<44.3> [UNIT_SPELLCAST_SUCCEEDED] Hagara the Stormbinder:Possible Target<nil>:boss1:Storm Pillar::0:109541", -- [97]
"<49.3> [UNIT_SPELLCAST_SUCCEEDED] Hagara the Stormbinder:Possible Target<nil>:boss1:Storm Pillar::0:109541", -- [98]
"<54.2> [UNIT_SPELLCAST_SUCCEEDED] Hagara the Stormbinder:Possible Target<nil>:boss1:Storm Pillar::0:109541", -- [99]
function mod:stormPillarsTarget(target)
	local targetname = target or self:GetBossTarget(55689)
	if not targetname then return end
	warnStormPillars:Show(targetname)
	local uId = DBM:GetRaidUnitId(targetname)
	if uId then
		local x, y = GetPlayerMapPosition(uId)
		if x == 0 and y == 0 then
			SetMapToCurrentZone()
			x,y = GetPlayerMapPosition(uId)
		end
		local inRange = DBM.RangeCheck:GetDistance("player", x, y)
		if inRange and inRange < 5 then
			specWarnStormPillars:Show(targetname)
		end
	end
end--]]

function mod:ShatteredIceTarget()
	local targetname = self:GetBossTarget(55689)
	if not targetname then return end
	warnShatteringIce:Show(targetname)
	timerShatteringCD:Start()
end

function mod:OnCombatStart(delay)
	table.wipe(lanceTargets)
	table.wipe(tombIconTargets)
	table.wipe(tombTargets)
	timerAssaultCD:Start(4-delay)
	timerIceLanceCD:Start(10-delay)
--	timerFrostTombCD:Start(16-delay)--No longer cast on engage? most recent log she only casts it after specials now and not after pull
	timerSpecialCD:Start(30-delay)
	SpecialCountdown:Start(30-delay)
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(3)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function warnLanceTargets()
	warnIceLance:Show(table.concat(lanceTargets, "<, >"))
	timerIceLance:Start()
	timerIceLanceCD:Start()
	table.wipe(lanceTargets)
end

local function ClearTombTargets()
	table.wipe(tombIconTargets)
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	end
	function mod:SetTombIcons()
		if DBM:GetRaidRank() > 0 then
			table.sort(tombIconTargets, sort_by_group)
			local tombIcons = 8
			for i, v in ipairs(tombIconTargets) do
				if self.Options.AnnounceFrostTombIcons and IsRaidLeader() then
					SendChatMessage(L.TombIconSet:format(tombIcons, UnitName(v)), "RAID")
				end
				self:SetIcon(UnitName(v), tombIcons)
				tombIcons = tombIcons - 1
			end
			self:Schedule(8, ClearTombTargets)
		end
	end
end

local function warnTombTargets()
	warnFrostTomb:Show(table.concat(tombTargets, "<, >"))
	table.wipe(tombTargets)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(104451) then--104451 25 man normal confirmed.
		tombTargets[#tombTargets + 1] = args.destName
		--[[if args:IsPlayer() then
			specWarnFrostTomb:Show()
		end--]]
		if self.Options.SetIconOnFrostTomb then
			table.insert(tombIconTargets, DBM:GetRaidUnitId(args.destName))
			self:UnscheduleMethod("SetTombIcons")
			--know 25 normal is 5, the rest are just guessed based on similar mechanic off Sindragosa
			if (self:IsDifficulty("normal25") and #tombIconTargets >= 5) or (self:IsDifficulty("heroic25") and #tombIconTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #tombIconTargets >= 2) then
				self:SetTombIcons()--Sort and fire as early as possible once we have all targets.
			else
				if self:LatencyCheck() then--Icon sorting is still sensitive and should not be done by laggy members that don't have all targets.
					self:ScheduleMethod(0.3, "SetTombIcons")
				end
			end
		end
		self:Unschedule(warnTombTargets)
		if (self:IsDifficulty("normal25") and #tombTargets >= 5) or (self:IsDifficulty("heroic25") and #tombTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #tombTargets >= 2) then
			warnTombTargets()
		else
			self:Schedule(0.3, warnTombTargets)
		end
	elseif args:IsSpellID(107851, 110898, 110899, 110900) then--107851 10/25 man normal confirmed. 110900 is lfr25 difficulty.
		warnAssault:Show()
		timerAssault:Start()
		timerAssaultCD:Start()
	elseif args:IsSpellID(110317) and args:IsPlayer() then
		specWarnWatery:Show()
	elseif args:IsSpellID(109325) then
		warnFrostflake:Show(args.destName)
		timerFrostFlakeCD:Start()
		if args:IsPlayer() then
			specWarnFrostflake:Show()
			yellFrostflake:Yell()
		end
		if self.Options.SetIconOnFrostflake then
			self:SetIcon(args.destName, 3)
		end
	elseif args:IsSpellID(105316, 107061, 107062, 107063) then
		if (args.amount or 1) % 3 == 0 and args:IsPlayer() then--Warn every 3 stacks, don't want to spam TOO much.
			specWarnIceLance:Show(args.amount)
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(105316, 107061, 107062, 107063) then
		if (args.amount or 1) % 3 == 0 and args:IsPlayer() then--Warn every 3 stacks, don't want to spam TOO much.
			specWarnIceLance:Show(args.amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(104451) and self.Options.SetIconOnFrostTomb then--104451 10/25 man normal confirmed.
		self:SetIcon(args.destName, 0)
	elseif args:IsSpellID(105256, 109552, 109553, 109554) then--Tempest
		timerFrostFlakeCD:Cancel()
		timerIceLanceCD:Start(12)
		timerFeedback:Start()
		if not self:IsDifficulty("lfr25") then
			timerFrostTombCD:Start()
		end
		timerAssaultCD:Start(20)
		timerLightningStormCD:Start()
		SpecialCountdown:Start(62)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(3)
		end
	elseif args:IsSpellID(105409, 109560, 109561, 109562) then--Water Shield
		timerStormPillarCD:Cancel()
		timerIceLanceCD:Start(12)
		timerFeedback:Start()
		if not self:IsDifficulty("lfr25") then
			timerFrostTombCD:Start()
		end
		timerAssaultCD:Start(20)
		timerTempestCD:Start()
		SpecialCountdown:Start(62)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(3)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(104448) then
		warnFrostTombCast:Show(args.spellName)
		specWarnFrostTombCast:Show()
		timerFrostTomb:Start()
	elseif args:IsSpellID(105256, 109552, 109553, 109554) then--109552 25man normal confirmed, rest wowhead drycodes
		timerAssaultCD:Cancel()
		timerIceLanceCD:Cancel()
		warnTempest:Show()
		specWarnTempest:Show()
		timerIceWave:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif args:IsSpellID(105409, 109560, 109561, 109562) then--Water Shield
		timerAssaultCD:Cancel()
		timerIceLanceCD:Cancel()
		warnLightningStorm:Show()
		specWarnLightingStorm:Show()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	elseif args:IsSpellID(105289, 108567, 110887, 110888) then
		self:ScheduleMethod(0.2, "ShatteredIceTarget")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(109557) then
--		self:stormPillarsTarget()
		warnStormPillars:Show()
		timerStormPillarCD:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(105297) then -- comfirmed 25 man normal(lfg),
		lanceTargets[#lanceTargets + 1] = args.sourceName
		self:Unschedule(warnLanceTargets)
		self:Schedule(0.5, warnLanceTargets)--Maybe adjust timing to allow for more combining of people failing at spreading?
	end
end