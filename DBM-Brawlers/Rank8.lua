local mod	= DBM:NewMod("BrawlRank8", "DBM-Brawlers")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 8255 $"):sub(12, -3))
--mod:SetCreatureID(60491)
mod:SetModelID(46265)
mod:SetZone()

mod:RegisterEvents(
	"SPELL_CAST_START"
)

mod:RemoveOption("HealthFrame")
mod:RemoveOption("SpeedKillTimer")