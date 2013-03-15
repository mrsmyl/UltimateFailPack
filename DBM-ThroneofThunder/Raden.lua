local mod	= DBM:NewMod(831, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 8862 $"):sub(12, -3))
--mod:SetCreatureID(62983)
mod:SetModelID(47739) -- most likely a placeholder :)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START"
)
