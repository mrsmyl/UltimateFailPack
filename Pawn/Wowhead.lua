-- Pawn by Vger-Azjol-Nerub
-- www.vgermods.com
-- © 2006-2011 Green Eclipse.  This mod is released under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 license.
-- See Readme.htm for more information.
--
-- Wowhead scales
------------------------------------------------------------

local ScaleProviderName = "Wowhead"

function PawnWowheadScaleProvider_AddScales()



------------------------------------------------------------
-- Warrior
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"WarriorArms",
	PawnWowheadScale_WarriorArms,
	"c79c6e",
	{
		["Strength"] = 100, ["HitRating"] = 90, ["ExpertiseRating"] = 85, ["CritRating"] = 80, ["MasteryRating"] = 70, ["HasteRating"] = 50, ["Stamina"] = .1, ["IsRelic"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"WarriorFury",
	PawnWowheadScale_WarriorFury,
	"c79c6e",
	{
		["Strength"] = 100, ["ExpertiseRating"] = 90, ["HitRating"] = 90, ["CritRating"] = 80, ["MasteryRating"] = 70, ["HasteRating"] = 50, ["Stamina"] = .1, ["IsRelic"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"WarriorTank",
	PawnWowheadScale_WarriorTank,
	"c79c6e",
	{
		["Stamina"] = 100, ["MasteryRating"] = 90, ["ParryRating"] = 85, ["DodgeRating"] = 80, ["ExpertiseRating"] = 70, ["HitRating"] = 65, ["Strength"] = 60, ["CritRating"] = 50, ["IsRelic"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

------------------------------------------------------------
-- Paladin
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"PaladinHoly",
	PawnWowheadScale_PaladinHoly,
	"f58cba",
	{
		["Intellect"] = 100, ["HasteRating"] = 80, ["Spirit"] = 50, ["MasteryRating"] = 50, ["SpellPower"] = 50, ["CritRating"] = 25, ["Stamina"] = .1, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"PaladinTank",
	PawnWowheadScale_PaladinTank,
	"f58cba",
	{
		["Stamina"] = 100, ["MasteryRating"] = 90, ["DodgeRating"] = 80, ["ParryRating"] = 80, ["HitRating"] = 70, ["ExpertiseRating"] = 60, ["Strength"] = 50, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"PaladinRetribution",
	PawnWowheadScale_PaladinRetribution,
	"f58cba",
	{
		["Strength"] = 100, ["MeleeDps"] = 100, ["Ap"] = 45, ["HitRating"] = 35, ["ExpertiseRating"] = 22, ["HasteRating"] = 18, ["CritRating"] = 16, ["MasteryRating"] = 9, ["Stamina"] = .1, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	1 -- hide 1H upgrades
)

------------------------------------------------------------
-- Hunter
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"HunterBeastMastery",
	PawnWowheadScale_HunterBeastMastery,
	"abd473",
	{
		["Agility"] = 100, ["RangedDps"] = 100, ["HitRating"] = 80, ["CritRating"] = 60, ["MasteryRating"] = 40, ["HasteRating"] = 20, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"HunterMarksman",
	PawnWowheadScale_HunterMarksman,
	"abd473",
	{
		["Agility"] = 100, ["RangedDps"] = 100, ["HitRating"] = 80, ["CritRating"] = 60, ["HasteRating"] = 60, ["MasteryRating"] = 40, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"HunterSurvival",
	PawnWowheadScale_HunterSurvival,
	"abd473",
	{
		["Agility"] = 100, ["RangedDps"] = 100, ["HitRating"] = 80, ["CritRating"] = 60, ["HasteRating"] = 40, ["MasteryRating"] = 20, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------
-- Rogue
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"RogueAssassination",
	PawnWowheadScale_RogueAssassination,
	"fff569",
	{
		["MeleeDps"] = 100, ["Agility"] = 100, ["HitRating"] = 67, ["MasteryRating"] = 50, ["HasteRating"] = 46, ["ExpertiseRating"] = 42, ["CritRating"] = 35, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsPolearm"] = -1000000, ["IsStaff"] = -1000000, ["Is2HAxe"] = -1000000, ["Is2HMace"] = -1000000, ["Is2HSword"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"RogueCombat",
	PawnWowheadScale_RogueCombat,
	"fff569",
	{
		["MeleeDps"] = 100, ["Agility"] = 100, ["HitRating"] = 70, ["ExpertiseRating"] = 59, ["HasteRating"] = 56, ["CritRating"] = 35, ["MasteryRating"] = 33, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsPolearm"] = -1000000, ["IsStaff"] = -1000000, ["Is2HAxe"] = -1000000, ["Is2HMace"] = -1000000, ["Is2HSword"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"RogueSubtlety",
	PawnWowheadScale_RogueSubtlety,
	"fff569",
	{
		["MeleeDps"] = 100, ["Agility"] = 100, ["HitRating"] = 40, ["HasteRating"] = 37, ["ExpertiseRating"] = 33, ["CritRating"] = 31, ["MasteryRating"] = 20, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsPolearm"] = -1000000, ["IsStaff"] = -1000000, ["Is2HAxe"] = -1000000, ["Is2HMace"] = -1000000, ["Is2HSword"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

------------------------------------------------------------
-- Priest
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"PriestDiscipline",
	PawnWowheadScale_PriestDiscipline,
	"ffffff",
	{
		["Intellect"] = 100, ["Spirit"] = 80, ["SpellPower"] = 19, ["CritRating"] = 11, ["HasteRating"] = 10, ["MasteryRating"] = 6, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["Is2HMace"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"PriestHoly",
	PawnWowheadScale_PriestHoly,
	"ffffff",
	{
		["Intellect"] = 100, ["Spirit"] = 95, ["HasteRating"] = 85, ["MasteryRating"] = 80, ["CritRating"] = 30, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["Is2HMace"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"PriestShadow",
	PawnWowheadScale_PriestShadow,
	"ffffff",
	{
		["Intellect"] = 100, ["SpellPower"] = 79, ["HasteRating"] = 50, ["CritRating"] = 40, ["MasteryRating"] = 38, ["Spirit"] = 37, ["HitRating"] = 37, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["Is2HMace"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------
-- DK
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"DeathKnightBloodTank",
	PawnWowheadScale_DeathKnightBloodTank,
	"ff4d6b",
	{
		["MeleeDps"] = 500, ["MasteryRating"] = 100, ["Stamina"] = 100, ["Agility"] = 69, ["DodgeRating"] = 50, ["ParryRating"] = 43, ["ExpertiseRating"] = 38, ["Strength"] = 31, ["CritRating"] = 22, ["Armor"] = 18, ["HasteRating"] = 16, ["HitRating"] = 16, ["BonusArmor"] = 11, ["IsShield"] = -1000000, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	1 -- hide 1H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"DeathKnightFrostDps",
	PawnWowheadScale_DeathKnightFrostDps,
	"ff4d6b",
	{
		["Strength"] = 100, ["MeleeDps"] = 100, ["HitRating"] = 43, ["ExpertiseRating"] = 41, ["HasteRating"] = 37, ["MasteryRating"] = 35, ["Ap"] = 32, ["CritRating"] = 26, ["Stamina"] = .1, ["IsShield"] = -1000000, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"DeathKnightUnholyDps",
	PawnWowheadScale_DeathKnightUnholyDps,
	"ff4d6b",
	{
		["Strength"] = 100, ["MeleeDps"] = 100, ["HitRating"] = 25, ["HasteRating"] = 25, ["Ap"] = 23, ["ExpertiseRating"] = 21, ["CritRating"] = 20, ["MasteryRating"] = 8, ["Stamina"] = .1, ["IsShield"] = -1000000, ["IsDagger"] = -1000000, ["IsFist"] = -1000000, ["IsStaff"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	1 -- hide 1H upgrades
)

------------------------------------------------------------
-- Shaman
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"ShamanElemental",
	PawnWowheadScale_ShamanElemental,
	"6e95ff",
	{
		["HitRating"] = 100, ["Spirit"] = 100, ["SpellPower"] = 80, ["Intellect"] = 80, ["MasteryRating"] = 75, ["HasteRating"] = 75, ["CritRating"] = 40, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"ShamanEnhancement",
	PawnWowheadScale_ShamanEnhancement,
	"6e95ff",
	{
		["MeleeDps"] = 124, ["Agility"] = 100, ["HitRating"] = 60, ["ExpertiseRating"] = 48, ["MasteryRating"] = 44, ["Strength"] = 42, ["Ap"] = 40, ["Intellect"] = 36, ["SpellPower"] = 36, ["CritRating"] = 28, ["HasteRating"] = 16, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	2 -- hide 2H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"ShamanRestoration",
	PawnWowheadScale_ShamanRestoration,
	"6e95ff",
	{
		["Intellect"] = 100, ["SpellPower"] = 83, ["Spirit"] = 75, ["HasteRating"] = 67, ["CritRating"] = 58, ["MasteryRating"] = 42, ["Stamina"] = 8, ["IsPlate"] = -1000000, ["IsPolearm"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------
-- Mage
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"MageArcane",
	PawnWowheadScale_MageArcane,
	"69ccf0",
	{
		["SpellPower"] = 100, ["Intellect"] = 100, ["HitRating"] = 80, ["HasteRating"] = 50, ["CritRating"] = 45, ["MasteryRating"] = 40, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"MageFire",
	PawnWowheadScale_MageFire,
	"69ccf0",
	{
		["Intellect"] = 100, ["HitRating"] = 82, ["SpellPower"] = 68, ["CritRating"] = 52, ["MasteryRating"] = 37, ["HasteRating"] = 35, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"MageFrost",
	PawnWowheadScale_MageFrost,
	"69ccf0",
	{
		["Intellect"] = 100, ["SpellPower"] = 100, ["HitRating"] = 80, ["MasteryRating"] = 70, ["HasteRating"] = 50, ["CritRating"] = 45, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------
-- Warlock
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"WarlockAffliction",
	PawnWowheadScale_WarlockAffliction,
	"bca5ff",
	{
		["Intellect"] = 100, ["SpellPower"] = 81, ["HitRating"] = 52, ["HasteRating"] = 43, ["CritRating"] = 32, ["MasteryRating"] = 30, ["Stamina"] = 1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"WarlockDemonology",
	PawnWowheadScale_WarlockDemonology,
	"bca5ff",
	{
		["Intellect"] = 100, ["SpellPower"] = 79, ["HitRating"] = 63, ["HasteRating"] = 40, ["CritRating"] = 35, ["MasteryRating"] = 31, ["Stamina"] = 1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"WarlockDestruction",
	PawnWowheadScale_WarlockDestruction,
	"bca5ff",
	{
		["Intellect"] = 100, ["SpellPower"] = 77, ["HitRating"] = 64, ["HasteRating"] = 36, ["CritRating"] = 34, ["MasteryRating"] = 29, ["Stamina"] = 1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsLeather"] = -1000000, ["IsShield"] = -1000000, ["IsRelic"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsFist"] = -1000000, ["IsMace"] = -1000000, ["Is2HMace"] = -1000000, ["IsPolearm"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------
-- Druid
------------------------------------------------------------

PawnAddPluginScale(
	ScaleProviderName,
	"DruidBalance",
	PawnWowheadScale_DruidBalance,
	"ff7d0a",
	{
		["Intellect"] = 100, ["SpellPower"] = 100, ["Spirit"] = 90, ["HasteRating"] = 90, ["HitRating"] = 90, ["MasteryRating"] = 80, ["CritRating"] = 70, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

PawnAddPluginScale(
	ScaleProviderName,
	"DruidFeralDps",
	PawnWowheadScale_DruidFeralDps,
	"ff7d0a",
	{
		["Dps"] = 151, ["Agility"] = 100, ["Strength"] = 78, ["Ap"] = 37, ["MasteryRating"] = 35, ["HasteRating"] = 32, ["ExpertiseRating"] = 29, ["HitRating"] = 28, ["CritRating"] = 28, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	1 -- hide 1H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"DruidFeralTank",
	PawnWowheadScale_DruidFeralTank,
	"ff7d0a",
	{
		["Stamina"] = 100, ["Armor"] = 75, ["Agility"] = 48, ["DodgeRating"] = 41, ["BonusArmor"] = 21, ["MasteryRating"] = 16, ["CritRating"] = 13, ["Strength"] = 10, ["ExpertiseRating"] = 10, ["FeralAp"] = 5, ["Ap"] = 5, ["HitRating"] = 5, ["HasteRating"] = 1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1,
	1 -- hide 1H upgrades
)

PawnAddPluginScale(
	ScaleProviderName,
	"DruidRestoration",
	PawnWowheadScale_DruidRestoration,
	"ff7d0a",
	{
		["Intellect"] = 100, ["SpellPower"] = 95, ["Spirit"] = 90, ["MasteryRating"] = 80, ["HasteRating"] = 70, ["CritRating"] = 60, ["Stamina"] = .1, ["IsPlate"] = -1000000, ["IsMail"] = -1000000, ["IsShield"] = -1000000, ["IsAxe"] = -1000000, ["Is2HAxe"] = -1000000, ["IsSword"] = -1000000, ["Is2HSword"] = -1000000, ["IsBow"] = -1000000, ["IsCrossbow"] = -1000000, ["IsGun"] = -1000000, ["IsThrown"] = -1000000, ["IsWand"] = -1000000, ["IsOffHand"] = -1000000, ["MetaSocketEffect"] = 7200
	},
	1
)

------------------------------------------------------------

-- PawnWowheadScaleProviderOptions.LastAdded keeps track of the last time that we tried to automatically enable scales for this character.
if not PawnWowheadScaleProviderOptions then PawnWowheadScaleProviderOptions = { } end
if not PawnWowheadScaleProviderOptions.LastAdded then PawnWowheadScaleProviderOptions.LastAdded = 0 end

local _, Class = UnitClass("player")
if PawnWowheadScaleProviderOptions.LastAdded < 1 then
	-- Enable round one of scales based on the player's class.
	if Class == "WARRIOR" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarriorFury"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarriorTank"), true)
	elseif Class == "PALADIN" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PaladinHoly"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PaladinTank"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PaladinRetribution"), true)
	elseif Class == "HUNTER" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "HunterBeastMastery"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "HunterMarksman"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "HunterSurvival"), true)
	elseif Class == "ROGUE" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "RogueAssassination"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "RogueCombat"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "RogueSubtlety"), true)
	elseif Class == "PRIEST" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PriestDiscipline"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PriestHoly"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "PriestShadow"), true)
	elseif Class == "DEATHKNIGHT" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DeathKnightBloodTank"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DeathKnightFrostDps"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DeathKnightUnholyDps"), true)
	elseif Class == "SHAMAN" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "ShamanElemental"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "ShamanEnhancement"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "ShamanRestoration"), true)
	elseif Class == "MAGE" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "MageArcane"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "MageFire"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "MageFrost"), true)
	elseif Class == "WARLOCK" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarlockAffliction"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarlockDemonology"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarlockDestruction"), true)
	elseif Class == "DRUID" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DruidBalance"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DruidFeralDps"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DruidFeralTank"), true)
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "DruidRestoration"), true)
	end
end

if PawnWowheadScaleProviderOptions.LastAdded < 2 then
	if Class == "WARRIOR" then
		PawnSetScaleVisible(PawnGetProviderScaleName(ScaleProviderName, "WarriorArms"), true)
	end
end

-- Don't reenable those scales again after the user has disabled them previously.
PawnWowheadScaleProviderOptions.LastAdded = 2

-- After this function terminates there's no need for it anymore, so cause it to self-destruct to save memory.
PawnWowheadScaleProvider_AddScales = nil

end -- PawnWowheadScaleProvider_AddScales

------------------------------------------------------------

PawnAddPluginScaleProvider(ScaleProviderName, PawnWowheadScale_Provider, PawnWowheadScaleProvider_AddScales)
