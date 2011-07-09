--[[
************************************************************************
Project				: Broker_HitCrit
Author				: zhinjio
Project Revision	: 2.22.2-release
Project Date		: 20110705025101

File				: Broker_HitCrit.lua
Commit Author		: zhinjio
Commit Revision		: 124
Commit Date			: 20110705025101
************************************************************************
Description	:
	Main addon file. 

TODO		:
	Add in disable for vulnerable and low level mobs

************************************************************************
(see bottom of file for changelog)
************************************************************************
--]]

local MODNAME = "HitCrit"
local FULLNAME = "Broker_HitCrit"

local HitCrit = LibStub( "AceAddon-3.0" ):NewAddon( MODNAME, "AceEvent-3.0" )
local L = LibStub:GetLibrary( "AceLocale-3.0" ):GetLocale( MODNAME )
local AceConfig 		= LibStub("AceConfig-3.0")
local AceConfigReg 		= LibStub("AceConfigRegistry-3.0")
local AceConfigDialog 	= LibStub("AceConfigDialog-3.0")

local addonversion = GetAddOnMetadata( FULLNAME, "Version" )
addonversion = string.gsub( addonversion, "@project.version@", " - Development" )
local addonauthor = "zhinjio"
local builddate = "20110705025101"

local _G = getfenv(0)
_G["HitCrit"] = HitCrit
local addon = HitCrit

local modularOptions = {}
local tooltip
local QT		= LibStub:GetLibrary( "LibQTip-1.0" )
local LDBIcon	= LibStub("LibDBIcon-1.0")

HitCrit.me = ""
HitCrit.selCategory = 0
HitCrit.selSchool = 0
HitCrit.selEntry = 0
HitCrit.selEntryName = ""
HitCrit.selSpecific = 0
HitCrit.selSpecificName = ""
HitCrit.superBuffed = false
HitCrit.inVehicle = false
HitCrit.dmgToggleAll = false
HitCrit.healToggleAll = false
HitCrit.activeTalents = 1
HitCrit.specName = ""
HitCrit.currTT = 1

HitCrit.selCategory = 0
HitCrit.selSchool = 0
HitCrit.selEntry = 0
HitCrit.selType = "hit"
HitCrit.resetType = 0

local db
local spellSchools = {
	-- Primary Schools
	[1]		= L["physical"],		-- 0x01		1		physical
	[2]		= L["holy"],			-- 0x02		2		holy
	[4]		= L["fire"],			-- 0x04		4		fire
	[8]		= L["nature"],			-- 0x08		8		nature
	[16]	= L["frost"],			-- 0x10		16		frost
	[32]	= L["shadow"],			-- 0x20		32		shadow
	[64]	= L["arcane"],			-- 0x40		64		arcane
	-- Double Schools
	[3]		= L["holystrike"],		-- 0x3		3		Holystrike		Holy + Physical
	[5]		= L["flamestrike"],		-- 0x5		5		Flamestrike		Fire + Physical
	[6]		= L["holyfire"],		-- 0x6		6		Holyfire		Fire + Holy
	[9]		= L["stormstrike"],		-- 0x9		9		Stormstrike		Nature + Physical
	[10]	= L["holystorm"],		-- 0xA		10		Holystorm		Nature + Holy
	[12]	= L["firestorm"],		-- 0xC		12		Firestorm		Nature + Fire
	[17]	= L["froststrike"],		-- 0x11		17		Froststrike		Frost + Physical
	[18]	= L["holyfrost"],		-- 0x12		18		Holyfrost		Frost + Holy
	[20]	= L["frostfire"],		-- 0x14		20		Frostfire		Frost + Fire
	[24]	= L["froststorm"],		-- 0x18		24		Froststorm		Frost + Nature
	[33]	= L["shadowstrike"],	-- 0x21		33		Shadowstrike	Shadow + Physical
	[34]	= L["shadowlight"],		-- 0x22		34		Shadowlight 	(Twilight)	Shadow + Holy
	[36]	= L["shadowflame"],		-- 0x24		36		Shadowflame		Shadow + Fire
	[40]	= L["shadowstorm"],		-- 0x28		40		Shadowstorm 	(Plague)	Shadow + Nature
	[48]	= L["shadowfrost"],		-- 0x30		48		Shadowfrost		Shadow + Frost
	[65]	= L["spellstrike"],		-- 0x41		65		Spellstrike		Arcane + Physical
	[66]	= L["divine"],			-- 0x42		66		Divine			Arcane + Holy
	[68]	= L["spellfire"],		-- 0x44		68		Spellfire		Arcane + Fire
	[72]	= L["spellstorm"],		-- 0x48		72		Spellstorm		Arcane + Nature
	[80]	= L["spellfrost"],		-- 0x50		80		Spellfrost		Arcane + Frost
	[96]	= L["spellshadow"],		-- 0x60		96		Spellshadow		Arcane + Shadow
	-- Triple and multi schools
	[28]	= L["elemental"],		-- 0x1C		28		Elemental		Frost + Nature + Fire
	[124]	= L["chromatic"],		-- 0x7C		124		Chromatic		Arcane + Shadow + Frost + Nature + Fire
	[126]	= L["magic"],			-- 0x7E		126		Magic			Arcane + Shadow + Frost + Nature + Fire + Holy
	[127]	= L["chaos"],			-- 0x7F		127		Chaos			Arcane + Shadow + Frost + Nature + Fire + Holy + Physical	
}

local argentSpells = {
	-- Argent Tournament spell (listed as Uncategorized Spells)
	[62626]		= true,		-- Shield-Breaker (from Argent Tournament)
	[64686]		= true,		-- Shield-Breaker (from Argent Tournament)
	[64590]		= true,		-- Shield-Breaker (from Argent Tournament)
	[64342]		= true,		-- Shield-Breaker (from Argent Tournament)
	[66480]		= true,		-- Shield-Breaker (from Argent Tournament)
	[68505]		= true,		-- Thrust (from Argent Tournament)
	[66479]		= true,		-- Thrust (from Argent Tournament)
	[64588]		= true,		-- Thrust (from Argent Tournament)
	[62544]		= true,		-- Thrust (from Argent Tournament)
	[66483]		= true,		-- Refresh Mount (from Argent Tournament)
	[64077]		= true,		-- Refresh Mount (from Argent Tournament)
	-- Argent Tournament (listed as NPC abilities)
	[68504]		= true,		-- Shield-Breaker (from Argent Tournament)
	[65147]		= true,		-- Shield-Breaker (from Argent Tournament)
	[64595]		= true,		-- Shield-Breaker (from Argent Tournament)
	[62575]		= true,		-- Shield-Breaker (from Argent Tournament)
}

local ignoreSpells = {
	-- Trial of the Champion
	[66905]		= true, -- Eadric's Hammer of the Righteous, thrown back
}

local resetExclusionList = {
	-- Druid Lifebloom
	[33763]		= true,		-- LifeBloom, rank 1
	[48450]		= true,		-- LifeBloom, rank 2
	[48451]		= true,		-- LifeBloom, rank 3
	-- Warlock Shadowflame
	[47897]		= true,		-- Shadowflame, rank 1
	[61290]		= true,		-- Shadowflame, rank 2
	-- Paladin Flash of Light (with Beacon of Light)
	[66922]		= true,		-- Flash of Light (HoT)
}

local superBuffIDs = {
--[[
	-- Turn this on to test if superbuff detection is working properly
	-- Test on Death Knight
	[53136]		= true,		-- Abominable Might			***** Death Knight TEST VALUE ******
]]--
	[60964]		= true,		-- Strength of Wrynn
	[59641]		= true,		-- Warchief's Blessing
	[58549]		= true,		-- Tenacity
	[59911]		= true,		-- Tenacity
	[58361]		= true,		-- The Might of Mograine
	[53642]		= true,		-- The Might of Mograine
	[56330]		= true,		-- Iron's Bane
	[60597]		= true,		-- Blessing of the Crusade
	[58026]		= true,		-- Blessing of the Crusade
	[23505]		= true,		-- Berserking
	[24378]		= true,		-- Berserking
}
local superBuffNames = {}

function HitCrit_Print( msg )
	local _, fh = DEFAULT_CHAT_FRAME:GetFont()
	fh = math.ceil( fh )
	local icon = "\124TInterface\\Addons\\Broker_HitCrit\\icon:" .. fh .. "\124t"
	if ( msg ~= nil ) then
	   if( DEFAULT_CHAT_FRAME ) then
	      DEFAULT_CHAT_FRAME:AddMessage( icon .. " HitCrit: " .. msg, 0.6, 1.0, 1.0 )
	   end
	end
end

function HitCrit_Debug( msg )
	if ( msg ~= nil ) then
		if ( db.options.display.debug ) then
			HitCrit_Print( "DEBUG: " .. msg )
		end
	end
end

function HitCrit_Red( text )	return "|cffff0000" .. text .. "|r" end
function HitCrit_Yellow( text )	return "|cffffff00" .. text .. "|r" end
function HitCrit_Green( text )	return "|cff00ff00" .. text .. "|r" end
function HitCrit_White( text )	return "|cffffffff" .. text .. "|r" end
function HitCrit_hit( text)		return "|cff00ffff" .. text .. "|r" end
function HitCrit_crit( text)	return "|cffff8080" .. text .. "|r" end
function HitCrit_sch( text)		return "|cffdfa050" .. text .. "|r" end

function HitCrit:AlertNew( crit, heal, target, spellName, amount )
	local hType, hStr = L["Hit"], L["Hit"]
	local dboa = db.options.alerts
	if ( heal == 1 ) then
		hStr = L["healed"]
		if ( crit == 1 ) then
			hType = L["Critical Heal"]
		else
			hType = L["Heal"]
		end
	else
		if ( crit == 1 ) then
			hType = L["Critical Hit"]
		end
	end
	local outStr = string.format( L["New Record %s! %s %s %s for %d"], hType, spellName, hStr, target, amount )
	if ( dboa.chatframe == true ) then
		HitCrit_Print( outStr )
	end
	if ( dboa.notify == true ) then
		UIErrorsFrame:AddMessage( outStr )
		-- Still need to figure this out
	end
	if ( dboa.sound == true ) then
		-- Still need to figure this out
		PlaySound("LEVELUPSOUND")
	end
	if ( dboa.screenie == true ) then
		Screenshot()
	end
	-- These two could still be present even though they stopped using Parrot/MSBT. Make sure to still
	-- check for the presence of the addon itself.
	if ( ( Parrot ~= nil ) and ( dboa.useparrot == true ) ) then
		if ( ( dboa.parrotarea ~= nil ) and( dboa.parrotarea ~= "" ) ) then
			Parrot:ShowMessage( outStr, dboa.parrotarea )
		else
			Parrot:ShowMessage( outStr )
		end
	end
	if ( ( MikSBT ~= nil ) and ( dboa.usemsbt == true ) ) then
		if ( ( dboa.msbtarea ~= nil ) and( dboa.msbtarea ~= "" ) ) then
			MikSBT.DisplayMessage( outStr, dboa.msbtarea )
		else
			MikSBT.DisplayMessage( outStr )
		end
	end
end

function HitCrit_initHC( entry )
	entry.hit = {}; entry.crit = {}
	entry.total = 0
	entry.num = 0
	for i = 1, 3 do
		entry.hit[i] = {}
		entry.hit[i].value = 0
		entry.hit[i].name = ""
		entry.crit[i] = {}
		entry.crit[i].value = 0
		entry.crit[i].name = ""
	end
end

function HitCrit_initSpellEntry()
	local entry = {}
	entry.effect = ""
	entry.school = 0
	entry.rank = 0
	HitCrit_initHC( entry )
	return entry
end

function HitCrit_CheckInsertAlert( heal, id, hit, crit, dName, effect, sch )
	local side = ""
	if ( effect ~= "" ) then
		if ( heal == 1 ) then side = "heal" else side = "damage" end
		if ( db.values[HitCrit.activeTalents][side][id] ) then
			local entry = db.values[HitCrit.activeTalents][side][id]
			-- this value already exists. Compare to current, and replace if needed
			if ( crit ~= 0 ) then
				entry.total = entry.total + crit
				entry.num = entry.num + 1
				entry.numcrit = entry.numcrit + 1
				if ( crit > entry.crit[1].value ) then
					entry.crit[3].value = entry.crit[2].value
					entry.crit[3].name = entry.crit[2].name
					entry.crit[2].value = entry.crit[1].value
					entry.crit[2].name = entry.crit[1].name
					entry.crit[1].value = crit
					entry.crit[1].name = dName
					HitCrit:AlertNew( 1, heal, dName, effect, crit )
				elseif ( crit > entry.crit[2].value ) then
					entry.crit[3].value = entry.crit[2].value
					entry.crit[3].name = entry.crit[2].name
					entry.crit[2].value = crit
					entry.crit[2].name = dName
				elseif ( crit > entry.crit[3].value ) then
					entry.crit[3].value = crit
					entry.crit[3].name = dName
				end
			else
				entry.total = entry.total + hit
				entry.num = entry.num + 1
				if ( hit > entry.hit[1].value ) then
					entry.hit[3].value = entry.hit[2].value
					entry.hit[3].name = entry.hit[2].name
					entry.hit[2].value = entry.hit[1].value
					entry.hit[2].name = entry.hit[1].name
					entry.hit[1].value = hit
					entry.hit[1].name = dName
					HitCrit:AlertNew( 0, heal, dName, effect, hit )
				elseif ( hit > entry.hit[2].value ) then
					entry.hit[3].value = entry.hit[2].value
					entry.hit[3].name = entry.hit[2].name
					entry.hit[2].value = hit
					entry.hit[2].name = dName
				elseif ( hit > entry.hit[3].value ) then
					entry.hit[3].value = hit
					entry.hit[3].name = dName
				end
			end
		else
			-- This could be a previously tracked spell, just with a new rank
			local sName, sRank = GetSpellInfo( id )
			local prevSpellID = 0
			if ( id ~= 0 ) then
				-- sName should match "effect" I believe 
				for k, v in pairs( db.values[HitCrit.activeTalents][side] ) do
					if ( v.effect == sName ) then
						if ( resetExclusionList[k] == true ) then
							-- this is a lifebloom (et al) type spell
							if ( resetExclusionList[id] ) then
								-- the new spell is also on the exclusion list. This is probably a down/uprank of the existing data
								if ( sRank ~= v.rank ) then
									prevSpellID = k
									break
								end
							else
								-- the new spell is NOT excluded. This is probably the "Bloom" effect. So don't exclude
							end
						else
							if ( sRank ~= v.rank ) then
								prevSpellID = k
								break
							else
								-- if we're here, someone is casting a downranked spell. Nub.
							end
						end
					end
				end
			end
			if ( prevSpellID ~= 0 ) then
				db.values[HitCrit.activeTalents][side][prevSpellID] = nil
			end

			-- Otherwise, we've got a new previously untracked value. Record all the info
			db.values[HitCrit.activeTalents][side][id] = {}
			local entry = HitCrit_initSpellEntry()
			entry.effect = effect
			entry.school = sch
			entry.rank = sRank
			entry.hit[1].value = hit
			entry.crit[1].value = crit
			if ( crit ~= 0 ) then
				entry.total = crit
				entry.num = 1
				entry.numcrit = 1
				entry.crit[1].name = dName
				HitCrit:AlertNew( 1, heal, dName, effect, crit )
			else
				entry.total = hit
				entry.num = 1
				entry.numcrit = 0
				entry.hit[1].name = dName
				HitCrit:AlertNew( 0, heal, dName, effect, hit )
			end
			db.values[HitCrit.activeTalents][side][id] = entry
		end
	end
	HitCrit:ChangeLabel()
end

local function amTracking( type )
	-- quick function to see if I'm tracking damage or healing at all
	-- This lets me shortcut out of the CLEU quickly
	local result = false
	if ( type == "damage" ) then
		local tdb = db.options.tracking.damage
		for k, v in pairs( tdb ) do
			if ( tdb[k] == true ) then
				return true
			end
		end
	else
		local tdb = db.options.tracking.healing
		for k, v in pairs( tdb ) do
			if ( tdb[k] == true ) then
				return true
			end
		end
	end
	return result
end

function HitCrit:COMBAT_LOG_EVENT_UNFILTERED(
	_, _, eType, hideCaster, sGUID, sName, sFlags, sRFlags, dGUID, dName, dFlags, dRFlags, ... )
--	eType				sGUID				sName		sFlags	dGUID				dName		dFlags		...
-- SPELL_HEAL			0x0100000003EDD6BF	"Zhinjio"	0x10511	0x0100000003EDD6BF	"Zhinjio"	0x10511		48785	"Flash of Light"	0x2	3653	3653	0	nil
-- SPELL_HEAL			0x0100000003EDD6BF	"Zhinjio"	0x10511	0x0100000003EDD6BF	"Zhinjio"	0x10511		48785	"Flash of Light"	0x2	5413	5413	0	1
-- SPELL_HEAL			0x0100000003EDD6BF	"Zhinjio"	0x10511	0x0100000003EDD6BF	"Zhinjio"	0x10511		48782	"Holy Light"		0x2	16834	16834	0	1
-- SPELL_HEAL			0x0100000003EDD6BF	"Zhinjio"	0x10511	0x0100000003EDD6BF	"Zhinjio"	0x10511		48782	"Holy Light"		0x2	11068	11068	0	nil
-- Parameters:
--	event		COMBAT_LOG_EVENT_UNFILTERED
--	timestamp
--	hideCaster	no idea
--	eType		event type (for example, SPELL_DAMAGE)
--	sGUID		source GUID
--	sName		source Name
--	sFlags		source Flags
--	sRFlags		source Raid Flags	-- added in 4.2
--	dGUID		destination GUID
--	dName		destination Name
--	dFlags		destination Flags
--	dRFlags		destination Raid Flags	-- added in 4.2
--
--		The remaining parameters are dependent on eType
--
--		For RANGE_, SPELL_, SPELL_AURA_ and SPELL_PERIODIC_ prefixes, you have the following
--			spellId
--			spellName
--			spellSchool
--
--		Then, for _DAMAGE suffixes:
--			amount
--			overkill
--			school
--			resisted
--			blocked
--			absorbed
--			critical (1 or nil)
--			glancing (1 or nil)
--			crushing (1 or nil)
--
--		Then, for _HEAL suffixes:
--			amount
--			overhealing
--			absorbed
--			critical
--
	local effect, id, hit, crit, sch, heal = "", 0, 0, 0, 0, 0
	
	local targetLevel = UnitLevel( "target" )
	if ( sGUID == HitCrit.GUID ) then
		-- First, check for damage
		if ( amTracking( "damage" ) ) then
			if ( eType == "SWING_DAMAGE" ) then
				local amount, _, school, resisted, blocked, absorbed, critical, glance, crush = select( 1, ... )
				id = 0; effect = L["Melee"]; sch = school
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "RANGE_DAMAGE" ) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glance, crush = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_DAMAGE" ) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glance, crush = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_AURA_DAMAGE" ) then
				-- does this event exist?
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glance, crush = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_PERIODIC_DAMAGE" ) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, crit, glance, crush = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			end
		end
		if ( amTracking( "healing" ) ) then
			if ( eType == "SWING_HEAL" ) then
				-- does this event exist?
				local amount, overheal, absorbed, critical = select( 1, ... )
				id = 0; effect = L["Melee"]; sch = 1; heal = 1
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "RANGE_HEAL" ) then
				-- does this event exist?
				local spellID, spellName, spellSchool, amount, overheal, absorbed, critical = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool; heal = 1
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_HEAL" ) then
				local	spellID,	spellName,			spellSchool,	amount,	overheal,	absorbed,	critical = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool; heal = 1
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_AURA_HEAL" ) then
				-- does this event exist?
				local spellID, spellName, spellSchool, amount, overheal, absorbed, critical = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool; heal = 1
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			elseif ( eType == "SPELL_PERIODIC_HEAL" ) then
				local spellID, spellName, spellSchool, amount, overheal, absorbed, critical = select( 1, ... )
				id = spellID; effect = spellName; sch = spellSchool; heal = 1
				if ( critical == 1 ) then hit = 0; crit = amount else hit = amount; crit = 0 end
			end
		end
	elseif ( ( db.options.tracking.againstMe == true ) and ( dGUID == HitCrit.GUID ) ) then
	end

	local ignoreHit = false
	-- Check to see if this target is too low a level
	-- It is possible that we have *nothing* targeted (self-heal). In that case, don't bother checking this...
	if ( heal == 0 ) then
		if ( db.options.tracking.lowlevel == false ) then
			if ( ( HitCrit.level - targetLevel ) >= 7 ) then
				HitCrit_Debug( "Ignored due to low level" )
				ignoreHit = true
			end
		end
	end
	-- check to make sure we're tracking this school
	local tdb = {}
	if ( heal == 0 ) then tdb = db.options.tracking.damage else tdb = db.options.tracking.healing end
	if ( tdb[sch] == false ) then
		HitCrit_Debug( "Ignored due to tracking off" )
		ignoreHit = true
	end
	if ( ( heal == 0 ) and ( dName == HitCrit.me ) ) then
		-- This is an effect like Judgement of the Martyr where hitting someone else transfers some
		-- damage to me. Ignore those
		HitCrit_Debug( "Ignored due to martyr effect" )
		ignoreHit = true
	end
	-- Check if we're supposed to ignore Argent Tourney stuff
	if ( db.options.suppress.argent == true ) then
		if ( argentSpells[ id ] ) then
			HitCrit_Debug( "Ignored due to argent tourney" )
			ignoreHit = true
		end
	end
	
	-- Check to see if this is a spell we just flat out ignore
	if ( ignoreSpells[ id ] ) then
		HitCrit_Debug( "Ignored because its a spell we ignore. Duh." )
		ignoreHit = true
	end
	
	if ( ignoreHit == false ) then
		HitCrit_CheckInsertAlert( heal, id, hit, crit, dName, effect, sch )
	end
end

local function HideTooltip()
	tooltip:SetScript( "OnLeave", nil )
	tooltip:Hide()
end

-- Added a static popup for confirmation of delete actions...
StaticPopupDialogs["HC_CONFIRM_RESET_DATA"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	OnAccept = function( self )
		HitCrit_ResetData()
		self:Hide()
	end,
	EditBoxOnEscapePressed = function( self )
		self:Hide()
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

local function HitCrit_GenerateReportString( category, spell )
	local dbv = db.values[HitCrit.activeTalents][category][ tonumber(spell) ]
	if ( dbv ) then
		-- format for output:
		-- HitCrit: <Name> casts <effect>(<rank>)(<school>) for <hit> with crit <crit>(critpctg)
		local outString = L["Broker_HitCrit"] .. " : " .. HitCrit.me .. " " .. L["casts"] .. " "
		outString = outString .. dbv["effect"]
		if ( ( dbv.rank ) and ( dbv.rank ~= "" ) ) then
			outString = outString .. "(" .. dbv["rank"] .. ")"
		end
		outString = outString .. "(" .. spellSchools[dbv["school"]] .. ") " .. L["for"] .. " "
		outString = outString .. dbv["hit"][1]["value"] .. " "

		if ( ( dbv.num ~= 0 ) and ( dbv.numcrit ~= 0 ) ) then
			outString = outString .. L["with"] .. " " .. L["Crit"] .. " "
			outString = outString .. dbv["crit"][1]["value"]
			critpctg = string.format( "(%.1f%%)", ( dbv.numcrit / dbv.num * 100 ) )
			outString = outString .. critpctg
		end
		return outString
	else
		HitCrit_Print( string.format( L["Error occurred in the tooltip. I could not report for category (%s) and spell (%s)."], category, spell )  )
		HitCrit_Print( L["Please report this error on the project webpage."] )
		return ""
	end
end

local function HitCrit_ExpandHandler( cell, arg, button )
	-- This handles the + and - buttons that expand sections
	local dbe = db.options.expand
	if ( arg == "dmg" ) then
		dbe.expdmg = not dbe.expdmg
	elseif ( arg  == "heal" ) then
		dbe.expheal = not dbe.expheal
	else
		local resetType, resetCat = strsplit( "~", arg )
		rCat = tonumber( resetCat )
		HitCrit_Debug( "got rT and rC of " .. resetType .. "/" .. resetCat )
		dbe[resetType][rCat] = not dbe[resetType][rCat]
	end
	addon:drawTooltip( HitCrit.currTT )
	tooltip:Show()
end

local function HitCrit_MouseHandler( cell, arg, button )
	-- need a couple different effects here.
	-- Normal right click == open config
	-- Normal left click == report into chat frame
	-- Alt left click == reset value
	HitCrit_Debug( "Received .. " .. arg ) 
	if( button == "RightButton" ) then
		HitCrit:ShowConfig()
	elseif ( button == "LeftButton" ) then
		local resetType, resetCat, resetSpecific, hitorcrit = strsplit( "~", arg )
		if ( IsAltKeyDown() ) then
		-- do resetting stuff
			if ( resetCat == "damage" ) then
				HitCrit.selCategory = 1
			end
			if ( hitorcrit == "h" ) then
				HitCrit.selType = "hit"
			elseif ( hitorcrit == "a" ) then
				HitCrit.selType = "all"
			else
				HitCrit.selType = "crit"
			end
			if ( resetType == "2" ) then
				HitCrit_Debug( "Resetting whole category --> " .. resetCat )
				HCBF_ResetCategoryButton()
			elseif ( resetType == "3" ) then
				HitCrit.selSchool = tonumber( resetSpecific )
				HitCrit_Debug( "Resetting school (" .. resetCat .. ") --> " .. resetSpecific )
				HCBF_ResetSchoolButton()
			elseif ( resetType == "4" ) then
				HitCrit.selEntry = tonumber( resetSpecific )
				HitCrit.selEntryName = GetSpellInfo( resetSpecific )
				HitCrit_Debug( "Resetting spell (" .. resetCat .. ") --> " .. resetSpecific )
				if ( hitorcrit == "a" ) then
					HCBF_ResetEntryButton()
				else
					HCBF_ResetTopEntryButton()
				end
			else
				HitCrit_Debug( "ResetType is " .. resetType )
			end
		else
			HitCrit_Debug( "Chatframe reporting" )
			-- I can only do chatframe reporting for specific strings, not categories or schools
			if ( resetType == "4" ) then
				-- do chatframe stuff
				HitCrit_Debug( "correct reset type" )
				local chatReportString = HitCrit_GenerateReportString( resetCat, resetSpecific )
				-- Thanks to Torhal (from ARL code) for this little bit of madness
				local edit_box = _G.ChatEdit_ChooseBoxForSend()
				_G.ChatEdit_ActivateChat(edit_box)
				edit_box:Insert(chatReportString)
			end
		end
	end
		
end

function addon:drawTooltip( talent )
	-- plus and minus icons
	local plusIcon = "|TInterface\\Buttons\\UI-PlusButton-Up:18:18:1:0|t"
	local minusIcon = "|TInterface\\Buttons\\UI-MinusButton-Up:18:18:1:0|t"

	tooltip:Hide()
	tooltip:Clear()

	local dbs = db.options.suppress
	local dbod = db.options.display
	local dbe = db.options.expand
	
	local headerTitle = ""

	local t = {}
	local numCols = 2
	t[1] = "LEFT"
	t[2] = "LEFT"
	if ( dbod.avg ) then numCols = numCols + 1; table.insert( t, "RIGHT" ) end
	if ( dbod.hit ) then numCols = numCols + 1; table.insert( t, "RIGHT" ) end
	if ( dbod.crit ) then numCols = numCols + 1; table.insert( t, "RIGHT" ) end
	if ( dbod.enemyName ) then numCols = numCols + 1; table.insert( t, "RIGHT" ) end
	tooltip:SetColumnLayout( numCols, unpack( t ) )

	if ( talent == HitCrit.activeTalents ) then
		headerTitle = HitCrit_White( L["Broker_HitCrit"] .. " - " .. HitCrit.specName )
	else
		headerTitle = HitCrit_White( L["Broker_HitCrit"] .. " - " .. L["Inactive Spec"] )
	end
	local lineNum = tooltip:AddHeader( "b" )
	tooltip:SetCell( lineNum, 1, headerTitle, "CENTER", numCols )
	local colIndex = 0
	local t = {}
	if ( dbod.type ) then
		-- sort by damage school
		local schools = {}; schools.damage = {}; schools.healing = {}
		for k, v in pairs( spellSchools ) do schools.damage[k] = {}; schools.healing[k] = {} end
		for k, v in pairs( db.values[talent]["damage"] ) do
			if ( not schools.damage[v.school] ) then
				schools.damage[v.school] = {}
			end
			schools.damage[v.school][k] = true
		end
		for k, v in pairs( db.values[talent]["heal"] ) do
			if ( not schools.healing[v.school] ) then
				schools.healing[v.school] = {}
			end
			schools.healing[v.school][k] = true
		end
		-- damage block
		if ( not dbs.alldamage ) then
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 2, HitCrit_Red( "  " .. L["Damage"] ), "LEFT", ( numCols - 1 ) )
			tooltip:SetCellScript( lineNum, 2, "OnMouseDown", HitCrit_MouseHandler, "2~damage~0~h" )
			if ( dbe.expdmg == false ) then
				tooltip:SetCell( lineNum, 1, plusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
			else
				tooltip:SetCell( lineNum, 1, minusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
				wipe(t)
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( dbod.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( dbod.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( dbod.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( dbod.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				for k, v in pairs( spellSchools ) do
					if ( ( next( schools.damage[k] ) ~= nil ) and ( not dbs.damage[k] ) ) then
						lineNum = tooltip:AddLine( " " )
						tooltip:SetCell( lineNum, 2, HitCrit_sch( "    " .. v ), "LEFT", ( numCols - 1 ) )
						tooltip:SetCellScript( lineNum, 2, "OnMouseDown",
							HitCrit_MouseHandler, "3~damage~" .. k .. "~h" )
						if ( dbe.damage[k] == false ) then
							tooltip:SetCell( lineNum, 1, "  " .. plusIcon, "LEFT", 1 )
							tooltip:SetCellScript( lineNum, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "damage~" .. k )
						else
							tooltip:SetCell( lineNum, 1, "  " .. minusIcon, "LEFT", 1 )
							tooltip:SetCellScript( lineNum, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "damage~" .. k )
							for m, u in pairs( schools.damage[k] ) do
								local i = db.values[talent]["damage"][m]
								local e, h, c, a = i.effect, i.hit[1].value, i.crit[1].value, floor( i.total / i.num )
								local cp = ""
								if ( ( i.num ~= 0 ) and ( i.numcrit ~= 0 ) ) 
									then cp = string.format( "(%.1f%%)", ( i.numcrit / i.num * 100 ) )
								end
								if ( i.num == 0 ) then a = " " end
								lineNum = tooltip:AddLine( "b" )
								tooltip:SetCell( lineNum, 1, " ", "LEFT", 1 )
								local colIndex = 2
								tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( "      " .. e ), "LEFT", 1 )
								tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
									HitCrit_MouseHandler, "4~damage~" .. m .. "~a" )
								if ( dbod.avg ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
								end
								if ( dbod.hit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
									tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
										HitCrit_MouseHandler, "4~damage~" .. m .. "~h" )
								end
								if ( dbod.crit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
									tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
										HitCrit_MouseHandler, "4~damage~" .. m .. "~c" )
								end
								if ( dbod.enemyName ) then 
									colIndex = colIndex + 1
									if ( c ~= 0 ) then
										tooltip:SetCell( lineNum, colIndex, HitCrit_crit( i.crit[1].name ), "RIGHT", 1 )
									else
										tooltip:SetCell( lineNum, colIndex, HitCrit_hit( i.hit[1].name ), "RIGHT", 1 )
									end
								end
							end
						end
					end
				end
			end
		end
		-- healing block
		if ( not dbs.allhealing ) then
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, "+", "LEFT", 1 )
			tooltip:SetCell( lineNum, 2, HitCrit_Green( "  " .. L["Healing"] ), "LEFT", ( numCols - 1 ) )
			tooltip:SetCellScript( lineNum, 2, "OnMouseDown", HitCrit_MouseHandler, "2~heal~0~h" )
			if ( dbe.expheal == false ) then
				tooltip:SetCell( lineNum, 1, plusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
			else
				tooltip:SetCell( lineNum, 1, minusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
				wipe(t)
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( dbod.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( dbod.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( dbod.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( dbod.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				for k, v in pairs( spellSchools ) do
					if ( ( next( schools.healing[k] ) ~= nil ) and ( not dbs.healing[k] ) ) then
						lineNum = tooltip:AddLine( " " )
						tooltip:SetCell( lineNum, 2, HitCrit_sch( "    " .. v ), "LEFT", ( numCols - 1 ) )
						tooltip:SetCellScript( lineNum, 2, "OnMouseDown",
							HitCrit_MouseHandler, "3~heal~" .. k .. "~h" )
						if ( dbe.healing[k] == false ) then
							tooltip:SetCell( lineNum, 1, "  " .. plusIcon, "LEFT", 1 )
							tooltip:SetCellScript( lineNum, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "healing~" .. k )
						else
							tooltip:SetCell( lineNum, 1, "  " .. minusIcon, "LEFT", 1 )
							tooltip:SetCellScript( lineNum, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "healing~" .. k )
							for m, n in pairs( schools.healing[k] ) do
								local i = db.values[talent]["heal"][m]
								local e, h, c, a = i.effect, i.hit[1].value, i.crit[1].value, floor( i.total / i.num )
								local cp = ""
								if ( ( i.num ~= 0 ) and ( i.numcrit ~= 0 ) ) 
									then cp = string.format( "(%.1f%%)", ( i.numcrit / i.num * 100 ) )
								end
								if ( i.num == 0 ) then a = " " end
								lineNum = tooltip:AddLine( " " )
								tooltip:SetCell( lineNum, 1, " ", "LEFT", 1 )
								colIndex = 2
								tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( "      " .. e ), "LEFT", 1 )
								tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
									HitCrit_MouseHandler, "4~heal~" .. m .. "~a" )
								if ( dbod.avg ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
								end
								if ( dbod.hit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
									tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
										HitCrit_MouseHandler, "4~heal~" .. m .. "~h" )
								end
								if ( dbod.crit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( lineNum, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
									tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
										HitCrit_MouseHandler, "4~heal~" .. m .. "~c" )
								end
								if ( dbod.enemyName ) then 
									colIndex = colIndex + 1
									if ( c ~= 0 ) then
										tooltip:SetCell( lineNum, colIndex, HitCrit_crit( i.crit[1].name ), "RIGHT", 1 )
									else
										tooltip:SetCell( lineNum, colIndex, HitCrit_hit( i.hit[1].name ), "RIGHT", 1 )
									end
								end
							end
						end
					end
				end
			end
		end
	else
		if ( not dbs.alldamage ) then
			-- damage header lines
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 2, HitCrit_Red( "  " .. L["Damage"] ), "LEFT", ( numCols - 1 ) )
			tooltip:SetCellScript( lineNum, 2, "OnMouseDown", HitCrit_MouseHandler, "2~damage~0~h" )
			if ( dbe.expdmg == false ) then
				tooltip:SetCell( lineNum, 1, plusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
			else
				tooltip:SetCell( lineNum, 1, minusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( dbod.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( dbod.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( dbod.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( dbod.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				for k, v in pairs( db.values[talent]["damage"] ) do
					local e, h, c, a = v.effect, v.hit[1].value, v.crit[1].value, floor( v.total / v.num )
					local cp = ""
					if ( ( v.num ~= 0 ) and ( v.numcrit ~= 0 ) ) 
						then cp = string.format( "(%.1f%%)", ( v.numcrit / v.num * 100 ) )
					end
					if ( v.num == 0 ) then a = " " end
					lineNum = tooltip:AddLine( " " )
					tooltip:SetCell( lineNum, 1, " ", "LEFT", 1 )
					colIndex = 2
					tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( "    " .. e ), "LEFT", 1 )
					tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
						HitCrit_MouseHandler, "4~damage~" .. k .. "~a" )
					if ( dbod.avg ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
					end
					if ( dbod.hit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
						tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
							HitCrit_MouseHandler, "4~damage~" .. k .. "~h" )
					end
					if ( dbod.crit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
						tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
							HitCrit_MouseHandler, "4~damage~" .. k .. "~c" )
					end
					if ( dbod.enemyName ) then 
						colIndex = colIndex + 1
						if ( c ~= 0 ) then
							tooltip:SetCell( lineNum, colIndex, HitCrit_crit( v.crit[1].name ), "RIGHT", 1 )
						else
							tooltip:SetCell( lineNum, colIndex, HitCrit_hit( v.hit[1].name ), "RIGHT", 1 )
						end
					end
				end
			end
		end
		if ( not dbs.allhealing ) then
			-- healing header lines
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 2, HitCrit_Green( "  " .. L["Healing"] ), "LEFT", ( numCols - 1 ) )
			tooltip:SetCellScript( lineNum, 2, "OnMouseDown", HitCrit_MouseHandler, "2~heal~0~h" )
			if ( dbe.expheal == false ) then
				tooltip:SetCell( lineNum, 1, plusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
			else
				tooltip:SetCell( lineNum, 1, minusIcon, "LEFT", 1 )
				tooltip:SetCellScript( lineNum, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
				wipe(t)
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( dbod.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( dbod.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( dbod.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( dbod.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				-- loop through healing
				for k, v in pairs( db.values[talent]["heal"] ) do
					local e, h, c, a = v.effect, v.hit[1].value, v.crit[1].value, floor( v.total / v.num )
					local cp = ""
					if ( ( v.num ~= 0 ) and ( v.numcrit ~= 0 ) ) 
						then cp = string.format( "(%.1f%%)", ( v.numcrit / v.num * 100 ) )
					end
					if ( v.num == 0 ) then a = " " end
					lineNum = tooltip:AddLine( " " )
					tooltip:SetCell( lineNum, 1, " ", "LEFT", 1 )
					colIndex = 2
					tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( "    " .. e ), "LEFT", 1 )
					tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
						HitCrit_MouseHandler, "4~heal~" .. k .. "~a" )
					if ( dbod.avg ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
					end
					if ( dbod.hit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
						tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
							HitCrit_MouseHandler, "4~heal~" .. k .. "~h" )
					end
					if ( dbod.crit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( lineNum, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
						tooltip:SetCellScript( lineNum, colIndex, "OnMouseDown", 
							HitCrit_MouseHandler, "4~heal~" .. k .. "~c" )
					end
					if ( dbod.enemyName ) then 
						colIndex = colIndex + 1
						if ( c ~= 0 ) then
							tooltip:SetCell( lineNum, colIndex, HitCrit_crit( v.crit[1].name ), "RIGHT", 1 )
						else
							tooltip:SetCell( lineNum, colIndex, HitCrit_hit( v.hit[1].name ), "RIGHT", 1 )
						end
					end
				end
			end
		end
	end
	-- Add menu items
	tooltip:AddLine(" ")
	lineNum = tooltip:AddLine( "c" )
	tooltip:SetCell( lineNum, 1, HitCrit_Yellow( L["Left-click to Report values in chat"] ), "LEFT", numCols )
	lineNum = tooltip:AddLine( "d" )
	tooltip:SetCell( lineNum, 1, HitCrit_Yellow( L["Alt-Left-click to delete values"] ), "LEFT", numCols )
	lineNum = tooltip:AddLine( "e" )
	tooltip:SetCell( lineNum, 1, HitCrit_Yellow( L["Right-click for Configuration"] ), "LEFT", numCols )
	lineNum = tooltip:AddLine( "f" )
	if ( HitCrit.currTT == HitCrit.activeTalents ) then
		tooltip:SetCell( lineNum, 1, HitCrit_Yellow( L["Alt-Right-click to see Inactive Spec"] ), "LEFT", numCols )
	else
		tooltip:SetCell( lineNum, 1, HitCrit_Yellow( L["Alt-Right-click to see Active Spec"] ), "LEFT", numCols )
	end
end

local LDB = LibStub( "LibDataBroker-1.1" )
local launcher = LDB:NewDataObject( MODNAME, {
	type = "data source",
	text = " ",
	label = FULLNAME,
	icon = "Interface\\Addons\\Broker_HitCrit\\icon",
	OnClick = function(clickedframe, button)
				if ( button == "RightButton" ) then
					if ( IsAltKeyDown() ) then
						-- switch to other spec
						if ( HitCrit.currTT == 1 ) then
							HitCrit.currTT = 2
						else
							HitCrit.currTT = 1
						end
						tooltip:Release()
						tooltip = QT:Acquire( "HitCritTT", 5, "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT" )
						tooltip:SetScale( db.options.display.tipscale )
						addon:drawTooltip( HitCrit.currTT )
						tooltip:SetAutoHideDelay( db.options.display.autoHideDelay, clickedframe )
						tooltip:EnableMouse()
						tooltip:SmartAnchorTo( clickedframe )
						tooltip:UpdateScrolling()
						tooltip:Show()
					else
						HitCrit:ShowConfig()
					end
				else
					-- does nothing unless you're in the tooltip. handled elsewhere
				end
	end,
	OnEnter = function ( self )
		tooltip = QT:Acquire( "HitCritTT", 5, "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT" )
		tooltip:SetScale( db.options.display.tipscale )
		addon:drawTooltip( HitCrit.currTT )
		tooltip:SetAutoHideDelay( db.options.display.autoHideDelay, self )
		tooltip:EnableMouse()
		tooltip:SmartAnchorTo( self )
		tooltip:UpdateScrolling()
		tooltip:Show()
	end,
	OnLeave = function()
		-- apparently some LDB displays pitch a fit when your launcher
		-- has an onenter, but no onleave. Pshaw, I say.
		return
	end,
} )

function HitCrit_upgradeDB()

	-- this function is only ever used inside this scope
	local function tblCopy( src ) 
		local tgt = {}
		for k, v in pairs( src ) do
			if ( type( v ) == "table" ) then
				tgt[k] = tblCopy( v )
			else
				tgt[k] = v
			end
		end
		return tgt
	end
	
	local olddb = HitCrit.db.factionrealm[HitCrit.me]
	-- This checks the current DB version the person has, and upgrades as necessary
	if not ( olddb.options.display.dbVersion ) then
		-- They have the original version
		local values = {}; values["damage"] = {}; values["heal"] = {}
		local side = "damage"
		for k, v in pairs( olddb.values ) do
			HitCrit_Debug( "id/h/c/dmg/sch/eff = "..k.."/"..v.hit.."/"..v.crit.."/"..
				v.dmg.."/"..v.school.."/"..v.effect )
			if ( v.dmg == 1 ) then side = "damage" else side = "heal" end
			local entry = HitCrit_initSpellEntry()
			_, sRank = GetSpellInfo( k )
			entry.school = v.school
			entry.effect = v.effect
			entry.rank = sRank
			entry.total = 0
			entry.num = 0
			entry.hit[1].value = v.hit
			entry.crit[1].value = v.crit
			if ( v.hit == 0 ) then entry.hit[1].name = "" else entry.hit[1].name = v.target end
			if ( v.crit == 0 ) then entry.crit[1].name = "" else entry.crit[1].name = v.target end
			values[side][k] = entry
		end
		olddb.values = nil
		olddb.values = values
		olddb.options.display.dbVersion = "1.1"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.1" ) )
	end
	if ( olddb.options.display.dbVersion == "1.1" ) then
		olddb.options.tracking.lowlevel = false
		olddb.options.display.dbVersion = "1.2"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.2" ) )
	end
	if ( olddb.options.display.dbVersion == "1.2" ) then
		olddb.options.display.avg = true
		olddb.options.display.dbVersion = "1.3"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.3" ) )
	end
	if ( olddb.options.display.dbVersion == "1.3" ) then
		olddb.options.display.fontsize = nil
		olddb.options.display.tipscale = 1
		olddb.options.display.dbVersion = "1.4"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.4" ) )
	end
	if ( olddb.options.display.dbVersion == "1.4" ) then
		olddb.options.alerts.screenie = false
		olddb.options.display.dbVersion = "1.5"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.5" ) )
	end
	if ( olddb.options.display.dbVersion == "1.5" ) then
		olddb.options.display.debug = false
		olddb.options.display.dbVersion = "1.6"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.6" ) )
	end
	if ( olddb.options.display.dbVersion == "1.6" ) then
		-- reset totals for each damage and healing entry, and add in the numcrit field
		for k, v in pairs( olddb.values["heal"] ) do
			v.total = 0
			v.num = 0
			v.numcrit = 0
		end
		for k, v in pairs( olddb.values["damage"] ) do
			v.total = 0
			v.num = 0
			v.numcrit = 0
		end
		olddb.options.display.debug = false
		olddb.options.display.dbVersion = "1.7"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.7" ) )
	end
	if ( olddb.options.display.dbVersion == "1.7" ) then
		olddb.options.display.label = false
		olddb.options.display.labelHeal = false
		olddb.options.display.dbVersion = "1.8"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.8" ) )
	end
	if ( olddb.options.display.dbVersion == "1.8" ) then
		olddb.options.alerts.useparrot = false
		olddb.options.alerts.parrotarea = ""
		olddb.options.alerts.usemsbt = false
		olddb.options.alerts.msbtarea = ""
		olddb.options.display.dbVersion = "1.9"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "1.9" ) )
	end
	if ( olddb.options.display.dbVersion == "1.9" ) then
		olddb.options.tracking.healing = nil
		olddb.options.tracking.healing = {}
		for k, v in pairs( spellSchools ) do
			olddb.options.tracking.healing[k] = true
		end
		olddb.options.tracking.damage = nil
		olddb.options.tracking.damage = {}
		for k, v in pairs( spellSchools ) do
			olddb.options.tracking.damage[k] = true
		end
		olddb.options.display.dbVersion = "2.0"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.0" ) )
	end
	if ( olddb.options.display.dbVersion == "2.0" ) then
		olddb.options.alerts.superbuffnotify = false
		olddb.options.display.dbVersion = "2.1"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.1" ) )
	end
	if ( olddb.options.display.dbVersion == "2.1" ) then
		olddb.options.tracking.spdetect = true
		olddb.options.display.dbVersion = "2.2"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.2" ) )
	end
	if ( olddb.options.display.dbVersion == "2.2" ) then
		olddb.options.display.labelDmg = false
		olddb.options.display.dbVersion = "2.3"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.3" ) )
	end
	if ( olddb.options.display.dbVersion == "2.3" ) then
		olddb.options.display.autoHideDelay = .25
		olddb.options.display.dbVersion = "2.4"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.4" ) )
	end
	if ( olddb.options.display.dbVersion == "2.4" ) then
		olddb.options.display.autoHideDelay = .1
		olddb.options.display.dbVersion = "2.5"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.5" ) )
	end
	if ( olddb.options.display.dbVersion == "2.5" ) then
		olddb.options.display.colorLabel = true
		olddb.options.display.dbVersion = "2.6"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.6" ) )
	end
	if ( olddb.options.display.dbVersion == "2.6" ) then
		olddb.options.suppress = {}
		olddb.options.suppress.allhealing = false
		olddb.options.suppress.alldamage = false
		olddb.options.suppress.healing = {}
		olddb.options.suppress.damage = {}
		for k, v in pairs( spellSchools ) do
			olddb.options.suppress.healing[k] = false
			olddb.options.suppress.damage[k] = false
		end
		olddb.options.display.dbVersion = "2.7"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.7" ) )
	end
	if ( olddb.options.display.dbVersion == "2.7" ) then
		olddb.options.expand = {}
		olddb.options.expand.expheal = true
		olddb.options.expand.expdmg = true
		olddb.options.expand.healing = {}
		olddb.options.expand.damage = {}
		for k, v in pairs( spellSchools ) do
			olddb.options.expand.healing[k] = true
			olddb.options.expand.damage[k] = true
		end
		olddb.options.display.dbVersion = "2.8"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.8" ) )
	end
	if ( olddb.options.display.dbVersion == "2.8" ) then
		olddb.options.suppress.argent = true
		olddb.options.display.dbVersion = "2.9"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "2.9" ) )
	end
	if ( olddb.options.display.dbVersion == "2.9" ) then
		local activeTalentGroup = GetActiveTalentGroup( false, false )
		local destTree = {}
		local otherTree = {}
		olddb.values[1] = {}
		olddb.values[2] = {}
		if ( activeTalentGroup == 1 ) then
			-- primary
			otherTree = olddb.values[2]
			destTree = olddb.values[1]
		else
			otherTree = olddb.values[1]
			destTree = olddb.values[2]
		end
		otherTree.damage = {}
		otherTree.heal = {}
		destTree.damage = {}
		destTree.heal = {}
		-- copy the current values into the destTree spot
		destTree.damage = tblCopy( olddb.values.damage )
		destTree.heal = tblCopy( olddb.values.heal )
		-- clean out old values
		olddb.values.damage = nil
		olddb.values.heal = nil
		olddb.options.display.dbVersion = "3.0"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "3.0" ) )
	end
	if ( olddb.options.display.dbVersion == "3.0" ) then
		for k, v in pairs( spellSchools ) do
			olddb.options.suppress.healing[k] = false
			olddb.options.suppress.damage[k] = false
		end
		for k, v in pairs( spellSchools ) do
			olddb.options.expand.healing[k] = true
			olddb.options.expand.damage[k] = true
		end
		for k, v in pairs( spellSchools ) do
			olddb.options.tracking.healing[k] = true
			olddb.options.tracking.damage[k] = true
		end
		HitCrit_Print( L["Please note: All spell suppression, tracking and expansion toggles have been reset."] )
		olddb.options.display.dbVersion = "3.1"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "3.1" ) )
	end
	if ( olddb.options.display.dbVersion == "3.1" ) then
		olddb.options.display.minimap_icon = nil
		olddb.options.display.minimap_icon = {}
		olddb.options.display.minimap_icon.hide = true
		olddb.options.display.dbVersion = "3.2"
		HitCrit_Print( string.format( L["Database upgraded to %s"], "3.2" ) )
	end
	if ( olddb.options.display.dbVersion == "3.2" ) then
		HitCrit_Print( L["Please note: Due to changes in 4.2, you may need to clear data."] )
		HitCrit_Print( L["If you notice errors or values not updating, try clearing out values."] )
		olddb.options.display.dbVersion = "3.3"
	end
end

function HitCrit:ChangeLabel()
	-- going to go with the following format:
	-- 		topdmghit(topdmgcrit)/tophealhit(tophealcrit)
	--
	-- default value
	local dmgtext = ""
	local healtext = ""
	local blort = 0
	launcher.text = ""
	local dbd = db.options.display
	if ( dbd.label == true ) then
		-- by default, we display damage
		local tophit, topcrit = 0, 0
		if ( dbd.labelHeal == true ) then
			for k, v in pairs( db.values[HitCrit.activeTalents]["heal"] ) do
				if ( v.hit[1].value > tophit ) then tophit = v.hit[1].value end
				if ( v.crit[1].value > topcrit ) then topcrit = v.crit[1].value end
			end
			if ( dbd.colorLabel == true ) then
				healtext = HitCrit_Green( tophit .. " (" .. topcrit .. ")" )
			else 
				healtext = tophit .. " (" .. topcrit .. ")"
			end
			blort = blort + 1
		end
		tophit, topcrit = 0, 0
		if ( dbd.labelDmg == true ) then
			for k, v in pairs( db.values[HitCrit.activeTalents]["damage"] ) do
				if ( v.hit[1].value > tophit ) then tophit = v.hit[1].value end
				if ( v.crit[1].value > topcrit ) then topcrit = v.crit[1].value end
			end
			if ( dbd.colorLabel == true ) then
				dmgtext = HitCrit_Red( tophit .. " (" .. topcrit .. ")" )
			else
				dmgtext = tophit .. " (" .. topcrit .. ")"
			end
			blort = blort + 1
		end
		if ( blort == 1 ) then
			if ( dbd.labelHeal == true ) then
				launcher.text = healtext
			else
				launcher.text = dmgtext
			end
		elseif( blort == 2 ) then
			launcher.text = dmgtext .. " - " .. healtext
		end
	end
end

local alertOptions = nil
local displayOptions = nil
local trackingOptions = nil
local options = nil

-- options stuff
local function giveTracking()
	if (not trackingOptions) then
		trackingOptions = {
			order = 2,
			type = "group",
			name = L["Tracking Options"],
			desc = L["TRACKING_OPTIONS_DESC"],
			args = {
				header1 = {
					order	= 21,
					type	= "header",
					name	= L["Tracking Options"],
				},
				desc = {
					order	= 22,
					type	= "description",
					name	= L["TRACKING_OPTIONS_DESC"],
				},
				pvp = {
					order	= 23,
					type	= "toggle",
					name	= L["Track PvP"],
					desc	= L["TRACK_PVP_DESC"],
					get		= function() return db.options.tracking.pvp end,
					set		= function() db.options.tracking.pvp = not db.options.tracking.pvp end,
					disabled = true,
				},
				againstMe = {
					order	= 24,
					type	= "toggle",
					name	= L["Track Hits Against Me"],
					desc	= L["TRACK_AGAINSTME_DESC"],
					get		= function() return db.options.tracking.againstMe end,
					set		= function() db.options.tracking.againstMe = not db.options.tracking.againstMe end,
					disabled = true,
				},
				environmental = {
					order	= 27,
					type	= "toggle",
					name	= L["Track Environmental"],
					desc	= L["TRACK_ENVIRONMENTAL_DESC"],
					get		= function() return db.options.tracking.environmental end,
					set		= function() db.options.tracking.environmental = not db.options.tracking.environmental end,
					disabled = true,
				},
				vulnerable = {
					order	= 28,
					type	= "toggle",
					name	= L["Track Vulnerable"],
					desc	= L["TRACK_VULNERABLE_DESC"],
					get		= function() return db.options.tracking.vulnerable end,
					set		= function() db.options.tracking.vulnerable = not db.options.tracking.vulnerable end,
					disabled = true,
				},
				lowlevel = {
					order	= 29,
					type	= "toggle",
					name	= L["Track Low Level"],
					desc	= L["TRACK_LOWLEVEL_DESC"],
					get		= function() return db.options.tracking.lowlevel end,
					set		= function() db.options.tracking.lowlevel = not db.options.tracking.lowlevel end,
				},
				spdetect = {
					order	= 30,
					type	= "toggle",
					name	= L["Detect Superbuffs"],
					desc	= L["TRACK_DETECT_SP"],
					get		= function() return db.options.tracking.spdetect end,
					set		= function()
								db.options.tracking.spdetect = not db.options.tracking.spdetect
								if ( db.options.tracking.spdetect == true ) then
									HitCrit:RegisterEvent( "UNIT_AURA" )
									HitCrit:RegisterEvent( "UNIT_ENTERED_VEHICLE" )
									HitCrit:RegisterEvent( "UNIT_EXITED_VEHICLE" )
								else
									HitCrit:UnregisterEvent( "UNIT_AURA" )
									HitCrit:UnregisterEvent( "UNIT_ENTERED_VEHICLE" )
									HitCrit:UnregisterEvent( "UNIT_EXITED_VEHICLE" )
								end
							  end,
				},
				header2 = {
					order	= 100,
					type	= "header",
					name	= L["Damage Schools"],
				},
				desc2 = {
					order	= 101,
					type	= "description",
					name	= L["DMG_SCHOOLS_DESC"],
				},
				damage = {
					order	= 102,
					type	= "toggle",
					name	= L["Global Damage Toggle"],
					desc	= L["DMG_GLOBAL_TOGGLE_DESC"],
					get		= function() return HitCrit.dmgToggleAll end,
					set		= function()
						HitCrit.dmgToggleAll = not HitCrit.dmgToggleAll
						local newsetvalue = true
						if ( HitCrit.dmgToggleAll == true ) then
							newsetvalue = true
						else
							newsetvalue = false
						end
						for k, v in pairs( spellSchools ) do
							db.options.tracking.damage[k] = newsetvalue
						end
					end,
				},
				header3 = {
					order	= 300,
					type	= "header",
					name	= L["Healing Schools"],
				},
				desc3 = {
					order	= 301,
					type	= "description",
					name	= L["HEAL_SCHOOLS_DESC"],
				},
				healing = {
					order	= 302,
					type	= "toggle",
					name	= L["Global Healing Toggle"],
					desc	= L["HEAL_GLOBAL_TOGGLE_DESC"],
					get		= function() return HitCrit.healToggleAll end,
					set		= function()
						HitCrit.healToggleAll = not HitCrit.healToggleAll
						local newsetvalue = true
						if ( HitCrit.healToggleAll == true ) then
							newsetvalue = true
						else
							newsetvalue = false
						end
						for k, v in pairs( spellSchools ) do
							db.options.tracking.healing[k] = newsetvalue
						end
					end,
				},
			},
		}
	end
	-- loops to add in the spell school stuff
	for k, v in pairs( spellSchools ) do
		local dmgname = "dmgsch" .. k
		local healname = "healdch" .. k
		-- damage
		trackingOptions.args[dmgname] = {
			order	= ( 103 + k ),
			type	= "toggle",
			name	= v,
			desc	= v,
			get		= function() return db.options.tracking.damage[k] end,
			set		= function()
				db.options.tracking.damage[k] = not db.options.tracking.damage[k]
				local result = true
				for k, v in pairs( spellSchools ) do
					if ( db.options.tracking.damage[k] == false ) then
						result = false
						break
					end
				end
				HitCrit.dmgToggleAll = result
			end,
		}
		trackingOptions.args[healname] = {
			order	= ( 303 + k ),
			type	= "toggle",
			name	= v,
			desc	= v,
			get		= function() return db.options.tracking.healing[k] end,
			set		= function()
				db.options.tracking.healing[k] = not db.options.tracking.healing[k]
				local result = true
				for k, v in pairs( spellSchools ) do
					if ( db.options.tracking.healing[k] == false ) then
						result = false
						break
					end
				end
				HitCrit.healToggleAll = result
			end,
		}
	end
	return trackingOptions
end

local function giveDisplay()
	if (not displayOptions) then
		displayOptions = {
			order = 3,
			type = "group",
			name = L["Display Options"],
			desc = L["DISPLAY_OPTIONS_DESC"],
			args = {
				header1 = {
					order	= 31,
					type	= "header",
					name	= L["Display Options"],
				},
				desc = {
					order	= 32,
					type	= "description",
					name	= L["DISPLAY_OPTIONS_DESC"],
				},
				avg = {
					order	= 33,
					type	= "toggle",
					name	= L["Display Avg"],
					desc	= L["DISPLAY_AVG_DESC"],
					get		= function() return db.options.display.avg end,
					set		= function() db.options.display.avg = not db.options.display.avg end,
				},
				hit = {
					order	= 34,
					type	= "toggle",
					name	= L["Display Hit"],
					desc	= L["DISPLAY_HIT_DESC"],
					get		= function() return db.options.display.hit end,
					set		= function() db.options.display.hit = not db.options.display.hit end,
				},
				crit = {
					order	= 35,
					type	= "toggle",
					name	= L["Display Crit"],
					desc	= L["DISPLAY_CRIT_DESC"],
					get		= function() return db.options.display.crit end,
					set		= function() db.options.display.crit = not db.options.display.crit end,
				},
				enemyName = {
					order	= 36,
					type	= "toggle",
					name	= L["Display Enemy Name"],
					desc	= L["DISPLAY_ENEMYNAME_DESC"],
					get		= function() return db.options.display.enemyName end,
					set		= function() db.options.display.enemyName = not db.options.display.enemyName end,
				},
				school = {
					order	= 37,
					type	= "toggle",
					name	= L["Sort by School"],
					desc	= L["DISPLAY_SORTSCHOOL_DESC"],
					get		= function() return db.options.display.type end,
					set		= function() db.options.display.type = not db.options.display.type end,
				},
				tooltipscale = {
					order	= 41,
					type	= "range",
					name	= L["Tooltip Scale"],
					desc	= L["TOOLTIP_SCALE_DESC"],
					min		= .7,
					max		= 1.3,
					step	= .05,
					bigStep = .05,
					get		= function() return db.options.display.tipscale end,
					set		= function( info, v ) 
								db.options.display.tipscale = v
								tooltip:SetScale( v )
							  end,
				},
				header2 = {
					order	= 100,
					type	= "header",
					name	= L["LDB Text Display Options"],
				},
				desc2 = {
					order	= 101,
					type	= "description",
					name	= L["LDBDISPLAY_OPTIONS_DESC"],
				},
				label = {
					order	= 102,
					type	= "toggle",
					name	= L["Display Top Values"],
					desc	= L["DISPLAY_LABEL_DESC"],
					get		= function() return db.options.display.label end,
					set		= function()
								db.options.display.label = not db.options.display.label
								HitCrit:ChangeLabel()
							  end,									
				},
				labelHeal = {
					order	= 103,
					type	= "toggle",
					name	= L["Display Heal in Label"],
					desc	= L["DISPLAY_LABELHEAL_DESC"],
					get		= function() return db.options.display.labelHeal end,
					set		= function()
								db.options.display.labelHeal = not db.options.display.labelHeal
								HitCrit:ChangeLabel()
							  end,
					disabled	= function() return not db.options.display.label end,
				},
				labelDmg = {
					order	= 104,
					type	= "toggle",
					name	= L["Display Dmg in Label"],
					desc	= L["DISPLAY_LABELDMG_DESC"],
					get		= function() return db.options.display.labelDmg end,
					set		= function()
								db.options.display.labelDmg = not db.options.display.labelDmg
								HitCrit:ChangeLabel()
							  end,
					disabled	= function() return not db.options.display.label end,
				},
				colorLabel = {
					order	= 105,
					type	= "toggle",
					name	= L["Color Label Text"],
					desc	= L["DISPLAY_COLORLABEL_DESC"],
					get		= function() return db.options.display.colorLabel end,
					set		= function()
								db.options.display.colorLabel = not db.options.display.colorLabel
								HitCrit:ChangeLabel()
							  end,
					disabled	= function() return not db.options.display.label end,
				},
				header3 = {
					order	= 200,
					type	= "header",
					name	= L["Minimap Icon Options"],
				},
				desc3 = {
					order	= 201,
					type	= "description",
					name	= L["MINIMAP_OPTIONS_DESC"],
				},
				minimap_icon = {
					order	= 202,
					type	= "toggle",
					width	= "full",
					name	= L["Show Minimap Icon"],
					desc	= L["Draws the icon on the minimap."],
					get	= function()
							return not db.options.display.minimap_icon.hide
						  end,
					set	= function(info, value)
							db.options.display.minimap_icon.hide = not value
							  LDBIcon[value and "Show" or "Hide"](LDBIcon, MODNAME)
						  end,
				},
				header4 = {
					order	= 300,
					type	= "header",
					name	= L["Miscellaneous Display Options"],
				},
				desc4 = {
					order	= 301,
					type	= "description",
					name	= L["MISCDISPLAY_OPTIONS_DESC"],
				},
				debug = {
					order	= 302,
					type	= "toggle",
					name	= L["Display Debug"],
					desc	= L["DISPLAY_DEBUG_DESC"],
					get		= function() return db.options.display.debug end,
					set		= function() db.options.display.debug = not db.options.display.debug end,
				},
				autoHideDelay = {
					order	= 303,
					type	= "range",
					name	= L["Tooltip Auto-hide Delay"],
					desc	= L["TOOLTIP_DELAY_DESC"],
					min		= .1,
					max		= 2,
					step	= .1,
					bigStep = .1,
					get		= function() return db.options.display.autoHideDelay end,
					set		= function( info, v ) 
								db.options.display.autoHideDelay = v
							  end,
				},
			},
		}
	end
	return displayOptions
end

local function giveSuppress()
	if (not suppressOptions) then
		suppressOptions = {
			order = 2,
			type = "group",
			name = L["Suppression Options"],
			desc = L["SUPPRESS_OPTIONS_DESC"],
			args = {
				header2 = {
					order	= 100,
					type	= "header",
					name	= L["Damage Schools"],
				},
				desc2 = {
					order	= 101,
					type	= "description",
					name	= L["SUPPRESS_DMG_DESC"],
				},
				damage = {
					order	= 102,
					type	= "toggle",
					name	= L["Global Damage Toggle"],
					desc	= L["DMG_GLOBAL_TOGGLE_DESC"],
					get		= function() return db.options.suppress.alldamage end,
					set		= function()
						local dbs = db.options.suppress
						dbs.alldamage = not dbs.alldamage
						local newsetvalue = true
						if ( dbs.alldamage == true ) then
							newsetvalue = true
						else
							newsetvalue = false
						end
						for k, v in pairs( spellSchools ) do
							dbs.damage[k] = newsetvalue
						end
					end,
				},
				header3 = {
					order	= 300,
					type	= "header",
					name	= L["Healing Schools"],
				},
				desc3 = {
					order	= 301,
					type	= "description",
					name	= L["SUPPRESS_HEAL_DESC"],
				},
				healing = {
					order	= 302,
					type	= "toggle",
					name	= L["Global Healing Toggle"],
					desc	= L["HEAL_GLOBAL_TOGGLE_DESC"],
					get		= function() return db.options.suppress.allhealing end,
					set		= function()
						local dbs = db.options.suppress
						dbs.allhealing = not dbs.allhealing
						local newsetvalue = true
						if ( dbs.allhealing == true ) then
							newsetvalue = true
						else
							newsetvalue = false
						end
						for k, v in pairs( spellSchools ) do
							dbs.healing[k] = newsetvalue
						end
					end,
				},
				header4 = {
					order	= 500,
					type	= "header",
					name	= L["Miscellaneous"],
				},
				desc3 = {
					order	= 501,
					type	= "description",
					name	= L["SUPPRESS_MISC_DESC"],
				},
				argent = {
					order	= 502,
					type	= "toggle",
					name	= L["Argent Tourney"],
					desc	= L["ARGENT_TOGGLE_DESC"],
					get		= function() return db.options.suppress.argent end,
					set		= function() db.options.suppress.argent = not db.options.suppress.argent end,
				},
				header5 = {
					order	= 600,
					type	= "header",
					name	= L["Notes"],
				},
				desc4 = {
					order	= 601,
					type	= "description",
					name	= L["SUPPRESS_NOTES_DESC"],
				},
			},
		}
	end
	-- loops to add in the spell school stuff
	for k, v in pairs( spellSchools ) do
		local dmgname = "dmgsch" .. k
		local healname = "healsch" .. k
		suppressOptions.args[dmgname] = {
			order	= ( 103 + k ),
			type	= "toggle",
			name	= v,
			desc	= v,
			get		= function() return db.options.suppress.damage[k] end,
			set		= function()
				local dbs = db.options.suppress
				dbs.damage[k] = not dbs.damage[k]
				local result = true
				for k, v in pairs( spellSchools ) do
					if ( dbs.damage[k] == false ) then
						result = false
						break
					end
				end
				dbs.alldamage = result
			end,
		}
		suppressOptions.args[healname] = {
			order	= ( 303 + k ),
			type	= "toggle",
			name	= v,
			desc	= v,
			get		= function() return db.options.suppress.healing[k] end,
			set		= function()
				local dbs = db.options.suppress
				dbs.healing[k] = not dbs.healing[k]
				local result = true
				for k, v in pairs( spellSchools ) do
					if ( dbs.healing[k] == false ) then
						result = false
						break
					end
				end
				dbs.allhealing = result
			end,
		}
	end
	return suppressOptions
end

local function giveAlert()
	if (not alertOptions) then
		alertOptions = {
			order = 4,
			type = "group",
			name = L["Alert Options"],
			desc = L["ALERT_OPTIONS_DESC"],
			args = {
				header1 = {
					order	= 41,
					type	= "header",
					name	= L["Alert Options"],
				},
				desc = {
					order	= 42,
					type	= "description",
					name	= L["ALERT_OPTIONS_DESC"],
				},
				sound = {
					order	= 43,
					type	= "toggle",
					name	= L["Alert with Sound"],
					desc	= L["ALERT_SOUND_DESC"],
					get		= function() return db.options.alerts.sound end,
					set		= function() db.options.alerts.sound = not db.options.alerts.sound end,
				},
				notify = {
					order	= 44,
					type	= "toggle",
					name	= L["Alert with Notify"],
					desc	= L["ALERT_NOTIFY_DESC"],
					get		= function() return db.options.alerts.notify end,
					set		= function() db.options.alerts.notify = not db.options.alerts.notify end,
				},
				chatframe = {
					order	= 45,
					type	= "toggle",
					name	= L["Alert in Chat Frame"],
					desc	= L["ALERT_CHATFRAME_DESC"],
					get		= function() return db.options.alerts.chatframe end,
					set		= function() db.options.alerts.chatframe = not db.options.alerts.chatframe end,
				},
				screenie = {
					order	= 46,
					type	= "toggle",
					name	= L["Take Screenshot"],
					desc	= L["ALERT_SCREENIE_DESC"],
					get		= function() return db.options.alerts.screenie end,
					set		= function() db.options.alerts.screenie = not db.options.alerts.screenie end,
				},
				superbuffnotify = {
					order	= 47,
					type	= "toggle",
					name	= L["Turn off Superbuff Alerts"],
					desc	= L["ALERT_SUPERBUFF_TOGGLE"],
					get		= function() return db.options.alerts.superbuffnotify end,
					set		= function() db.options.alerts.superbuffnotify = not db.options.alerts.superbuffnotify end,
				},
				header2 = {
					order	= 50,
					type	= "header",
					name	= L["Parrot Integration"],
					disabled	= function() return not ( Parrot ~= nil ) end,
				},
				desc2 = {
					order	= 51,
					type	= "description",
					name	= L["ALERT_PARROT_DESC"],
					disabled	= function() return not ( Parrot ~= nil ) end,
				},
				useParrot = {
					order	= 52,
					type	= "toggle",
					name	= L["Alert in Parrot Scroll Area"],
					desc	= L["ALERT_PARROTAREA_DESC"],
					get		= function() return db.options.alerts.useparrot end,
					set		= function() db.options.alerts.useparrot = not db.options.alerts.useparrot end,
					disabled	= function() return not ( Parrot ~= nil ) end,
				},
				parrotArea = {
					order	= 53,
					type	= "select",
					name	= L["Select Parrot Scroll Area"],
					desc	= L["ALERT_SELECTPARROTAREA_DESC"],
					get		= function() return db.options.alerts.parrotarea end,
					set		= function( info, value ) db.options.alerts.parrotarea = value end,
					values	= function()
						if ( Parrot ~= nil ) then
							return Parrot.GetScrollAreasChoices()
						else
							return {}
						end
					end,
					disabled	= function()
						if ( Parrot ~= nil ) then
							return not db.options.alerts.useparrot
						else
							return true
						end
					end,
				},
				header3 = {
					order	= 60,
					type	= "header",
					name	= L["MSBT Integration"],
					disabled	= function() return not ( MikSBT ~= nil ) end,
				},
				desc3 = {
					order	= 61,
					type	= "description",
					name	= L["ALERT_MSBT_DESC"],
					disabled	= function() return not ( MikSBT ~= nil ) end,
				},
				useMSBT = {
					order	= 62,
					type	= "toggle",
					name	= L["Alert in MSBT Scroll Area"],
					desc	= L["ALERT_MSBTAREA_DESC"],
					get		= function() return db.options.alerts.usemsbt end,
					set		= function() db.options.alerts.usemsbt = not db.options.alerts.usemsbt end,
					disabled	= function() return not ( MikSBT ~= nil ) end,
				},
				msbtArea = {
					order	= 63,
					type	= "select",
					name	= L["Select MSBT Scroll Area"],
					desc	= L["ALERT_SELECTMSBTAREA_DESC"],
					get		= function() return db.options.alerts.msbtarea end,
					set		= function( info, value ) db.options.alerts.msbtarea = value end,
					values	= function()
						if ( MikSBT ~= nil ) then
							local t = {}
							for k, v in MikSBT.IterateScrollAreas() do
								t[k] = v
							end
							return t
						else
							return {}
						end
					end,
					disabled	= function()
						if ( MikSBT ~= nil ) then
							return not db.options.alerts.usemsbt
						else
							return true
						end
					end,
				},
			},
		}
	end
	return alertOptions
end

local function fullOptions()
	if (not options) then
		options = {
			type = "group",
			name = MODNAME,
			args = {
				general = {
					order	= 1,
					type	= "group",
					name	= L["General Information"],
					desc	= L["GENERAL_INFO_DESC"],
					args	= {
						header1 = {
							order	= 11,
							type	= "header",
							name	= L["General Information"],
						},
						desc = {
							order	= 12,
							type	= "description",
							name	= L["GENERAL_INFO_DESC"],
						},
						author = {
							order	= 13,
							type	= "description",
							name	= L["Author : "] .. addonauthor .. "\n",
						},
						version = {
							order	= 14,
							type	= "description",
							name	= L["Version : "] .. addonversion .. "\n",
						},
						builddate = {
							order	= 15,
							type	= "description",
							name	= L["Build Date : "] .. builddate .. "\n",
						},
						dbversion = {
							order	= 15,
							type	= "description",
							name	= L["Database Version : "] .. db.options.display.dbVersion .. "\n",
						},
						translators = {
							order	= 16,
							type	= "description",
							name	= string.format( L["Helpful Translators (thank you) : %s"],
								"Markam(frFR), SunTsu(deDE), Dessa(deDE), " ..
								"next96(koKR), andy52005(zhTW)" .. "\n" ),
						},
					},
				},
			},
		}
	end
	
	for k,v in pairs(modularOptions) do
		options.args[k] = (type(v) == "function") and v() or v
	end

	return options
end

function addon:SetupOptions()
	AceConfigReg:RegisterOptionsTable(MODNAME, fullOptions)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions(MODNAME, nil, nil, "general")

	-- Fill up our modular options...
	self:RegisterModuleOptions("Tracking", giveTracking(), L["Tracking Options"])
	self:RegisterModuleOptions("Display", giveDisplay(), L["Display Options"])
	self:RegisterModuleOptions("Suppress", giveSuppress(), L["Suppression Options"])
	self:RegisterModuleOptions("Alert", giveAlert(), L["Alert Options"])
end

function addon:setToggles()
	local tdb = db.options.tracking.damage
	local result = true
	for k, v in pairs( spellSchools ) do
		if ( tdb[k] == false ) then
			result = false
			break
		end
	end
	HitCrit.dmgToggleAll = result
	tdb = db.options.tracking.healing
	result = true
	for k, v in pairs( spellSchools ) do
		if ( tdb[k] == false ) then
			result = false
			break
		end
	end
	HitCrit.healToggleAll = result
end

function addon:populateSuperBuffs()
	for k, v in pairs( superBuffIDs ) do
		sName = GetSpellInfo( k )
		superBuffNames[sName] = true
	end
end

function addon:checkSuperBuffs()
	HitCrit_Debug( "checking superbuffs" )
	-- UnitControllingVehicle ?? UnitHasVehicleUI?? UnitInVehicle
	-- do superbuff checks
	local prevState = addon.superBuffed 
	addon.superBuffed = false
	local i = 1
	while ( true ) do
		local name, _, texture = UnitBuff( "player", i )
		-- if texture is nil, we're past the end of the buffs
		if not texture then break end
		if ( superBuffNames[ name ] == true ) then
			addon.superBuffed = true
			break
		end
		i = i + 1
	end
	if ( addon.superBuffed == true ) then
		HitCrit:UnregisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
		if ( ( prevState == false ) and ( db.options.alerts.superbuffnotify == false ) ) then
			HitCrit_Print( L["You are now superbuffed (doing higher than normal damage). HitCrit disabled."] )
		end
	else
		HitCrit:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
		if ( ( prevState == true ) and ( db.options.alerts.superbuffnotify == false ) ) then
			HitCrit_Print( L["You are no longer superbuffed. HitCrit re-enabled."] )
		end
	end
	-- do vehicle checks
	prevState = addon.inVehicle
	addon.inVehicle = false
	if ( UnitInVehicle( "player" ) ) then
		addon.inVehicle = true
	end
	if ( addon.inVehicle == true ) then
		HitCrit:UnregisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
		if ( ( prevState == false ) and ( db.options.alerts.superbuffnotify == false ) ) then
			HitCrit_Print( L["You are now in a vehicle (doing higher than normal damage). HitCrit disabled."] )
		end
	else
		if ( addon.superBuffed == true ) then
			HitCrit:UnregisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
			if ( ( prevState == true ) and ( db.options.alerts.superbuffnotify == false ) ) then
				HitCrit_Print( L["You are no longer in a vehicle, but are still superbuffed. HitCrit remains disabled."] )
			end
		else
			HitCrit:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
			if ( ( prevState == true ) and ( db.options.alerts.superbuffnotify == false ) ) then
				HitCrit_Print( L["You are no longer in a vehicle. HitCrit re-enabled."] )
			end
		end
	end
end

function addon:GetSpecName()
	local activeTab = 0
	local maxPointsSpent = 0
	local specName = ""
	for i = 1, 3 do
		local _, tabName, _, _, points = GetTalentTabInfo( i, false, false, HitCrit.activeTalents )
		if ( points > maxPointsSpent ) then
			activeTab = i
			maxPointsSpent = points
			specName = tabName
		end
	end
	if ( activeTab == 0 ) then
		return ""
	else
		return specName
	end
end

function HitCrit:UNIT_AURA( ... )
	HitCrit_Debug( "Player unit aura event fired" )
	HitCrit:checkSuperBuffs()
end

function HitCrit:UNIT_ENTERED_VEHICLE( ... )
	HitCrit_Debug( "Unit entered vehicle event fired" )
	HitCrit:checkSuperBuffs()
end

function HitCrit:UNIT_EXITED_VEHICLE( ... )
	HitCrit_Debug( "Unit exited vehicle event fired" )
	HitCrit:checkSuperBuffs()
end

function HitCrit:ACTIVE_TALENT_GROUP_CHANGED( ... )
	HitCrit_Debug( "Player talents switched" )
	HitCrit.activeTalents = GetActiveTalentGroup( false, false )
	HitCrit.specName = addon.GetSpecName()
	HitCrit.currTT = HitCrit.activeTalents
end

function addon:RegisterModuleOptions(name, optionsTable, displayName)
	modularOptions[name] = optionsTable
	self.optionsFrame[name] = AceConfigDialog:AddToBlizOptions(MODNAME, displayName, MODNAME, name)
end

function HitCrit:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory( self.optionsFrame["Display"] )
end

function HitCrit_ResetData()
	-- If we're here, the user already confirmed. Nuke away...
	if ( HitCrit.resetType == 1 ) then
		-- Reset all data for this toon
		-- Don't actually have a way to reach this anymore...
	elseif ( HitCrit.resetType == 2 ) then
		-- Reset all data either in "damage" or "heal"
		if ( HitCrit.selCategory == 1 ) then
			db.values[HitCrit.activeTalents].damage = nil
			db.values[HitCrit.activeTalents].damage = {}
		else
			db.values[HitCrit.activeTalents].heal = nil
			db.values[HitCrit.activeTalents].heal = {}
		end
	elseif ( HitCrit.resetType == 3 ) then
		-- Reset all "damage" or "heal" data for a specific school
		local dbc = {}
		if ( HitCrit.selCategory == 1 ) then
			dbc = db.values[HitCrit.activeTalents].damage
		else
			dbc = db.values[HitCrit.activeTalents].heal
		end
		for k, v in pairs( dbc ) do
			if ( v.school == HitCrit.selSchool ) then
				dbc[k] = nil
			end
		end
	elseif ( HitCrit.resetType == 4 ) then
		-- Reset specific spell entries (or whole entry)
		local dbc = {}
		if ( HitCrit.selCategory == 1 ) then
			dbc = db.values[HitCrit.activeTalents].damage
		else
			dbc = db.values[HitCrit.activeTalents].heal
		end
		if ( HitCrit.selType == "all" ) then
			dbc[ HitCrit.selEntry ] = nil
		else
			local entry = dbc[ HitCrit.selEntry ]
			local hTable = HitCrit.selType
			entry[ hTable ][1].value = entry[ hTable ][2].value
			entry[ hTable ][1].name = entry[ hTable ][2].name
			entry[ hTable ][2].value = entry[ hTable ][3].value
			entry[ hTable ][2].name = entry[ hTable ][3].name
			entry[ hTable ][3].value = 0
			entry[ hTable ][3].name = ""
		end
	end

	HitCrit.selCategory = 0
	HitCrit.selSchool = 0
	HitCrit.selType = 0
	HitCrit.selSpecific = 0

	HitCrit:ChangeLabel()
end

function HCBF_ResetCategoryButton()
	HideTooltip()
	HitCrit.resetType = 2
	local c = ""
	if ( HitCrit.selCategory == 1 ) then c = L["Damage"] else c = L["Heal"] end
	StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
		string.format( L["Reset Category: %s. Are you sure?"], c )
	StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
end

function HCBF_ResetSchoolButton()
	HideTooltip()
	HitCrit.resetType = 3
	local c = ""
	if ( HitCrit.selCategory == 1 ) then c = L["Damage"] else c = L["Heal"] end
	local s = spellSchools[ HitCrit.selSchool ]
	StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
		string.format( L["Reset Category: %s, School: %s. Are you sure?"], c, s )
	StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
end

function HCBF_ResetEntryButton()
	HideTooltip()
	HitCrit.resetType = 4
	local e = HitCrit.selEntryName
	StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
		string.format( L["Reset all entries for spell: %s. Are you sure?"], e )
	StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
end

function HCBF_ResetTopEntryButton()
	HideTooltip()
	HitCrit.resetType = 4
	local e = HitCrit.selEntryName
	local t = HitCrit.selType
	StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
		string.format( L["Reset first %s entry for spell: %s. Are you sure?"], t, e )
	StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
end

function HitCrit:OnInitialize()
	-- If there was frame creation stuff to do, it would go here
end

function HitCrit:OnEnable()
    -- Called when the addon is loaded
	HitCrit.me = UnitName( "player" )
	HitCrit.GUID = UnitGUID( "player" )
	HitCrit.level = UnitLevel( "player" )
	HitCrit.activeTalents = GetActiveTalentGroup( false, false )
	HitCrit.specName = addon.GetSpecName()
	HitCrit.currTT = HitCrit.activeTalents

	self.db = LibStub( "AceDB-3.0" ):New( "HitCrit_DB", nil, "Default" )
	-- do we have any data yet; for this toon? If not, init its table
	if not ( self.db.factionrealm[HitCrit.me] ) then
		self.db.factionrealm[HitCrit.me] = {
			options = {
				tracking = {
					pvp = false,
					againstMe = false,
					environmental = false,
					vulnerable = false,
					lowlevel = false,
					damage = true,
					spdetect = true,
					healing = {
						[1]		= true,		-- physical
						[2]		= true,		-- holy
						[4]		= true,		-- fire
						[8]		= true,		-- nature
						[16]	= true,		-- frost
						[32]	= true,		-- shadow
						[64]	= true,		-- arcane
						[3]		= true,		-- Holystrike	
						[5]		= true,		-- Flamestrike	
						[6]		= true,		-- Holyfire		
						[9]		= true,		-- Stormstrike	
						[10]	= true,		-- Holystorm	
						[12]	= true,		-- Firestorm	
						[17]	= true,		-- Froststrike	
						[18]	= true,		-- Holyfrost	
						[20]	= true,		-- Frostfire	
						[24]	= true,		-- Froststorm	
						[33]	= true,		-- Shadowstrike	
						[34]	= true,		-- Shadowlight 	
						[36]	= true,		-- Shadowflame	
						[40]	= true,		-- Shadowstorm 	
						[48]	= true,		-- Shadowfrost	
						[65]	= true,		-- Spellstrike	
						[66]	= true,		-- Divine		
						[68]	= true,		-- Spellfire	
						[72]	= true,		-- Spellstorm	
						[80]	= true,		-- Spellfrost	
						[96]	= true,		-- Spellshadow	
						[28]	= true,		-- Elemental
						[124]	= true,		-- Chromatic
						[126]	= true,		-- Magic	
						[127]	= true,		-- Chaos		
					},
					damage = {
						[1]		= true,		-- physical
						[2]		= true,		-- holy
						[4]		= true,		-- fire
						[8]		= true,		-- nature
						[16]	= true,		-- frost
						[32]	= true,		-- shadow
						[64]	= true,		-- arcane
						[3]		= true,		-- Holystrike	
						[5]		= true,		-- Flamestrike	
						[6]		= true,		-- Holyfire		
						[9]		= true,		-- Stormstrike	
						[10]	= true,		-- Holystorm	
						[12]	= true,		-- Firestorm	
						[17]	= true,		-- Froststrike	
						[18]	= true,		-- Holyfrost	
						[20]	= true,		-- Frostfire	
						[24]	= true,		-- Froststorm	
						[33]	= true,		-- Shadowstrike	
						[34]	= true,		-- Shadowlight 	
						[36]	= true,		-- Shadowflame	
						[40]	= true,		-- Shadowstorm 	
						[48]	= true,		-- Shadowfrost	
						[65]	= true,		-- Spellstrike	
						[66]	= true,		-- Divine		
						[68]	= true,		-- Spellfire	
						[72]	= true,		-- Spellstorm	
						[80]	= true,		-- Spellfrost	
						[96]	= true,		-- Spellshadow	
						[28]	= true,		-- Elemental
						[124]	= true,		-- Chromatic
						[126]	= true,		-- Magic	
						[127]	= true,		-- Chaos		
					},
				},
				display = {
					hit = true,
					crit = true,
					avg = true,
					enemyName = false,
					type = false,
					debug = false,
					tipscale = 1,
					dbVersion = "3.3",
					label = false,
					labelHeal = false,
					labelDmg = false,
					autoHideDelay = .1,
					colorLabel = true,
					minimap_icon = {
						hide = true,
					},
				},
				suppress = {
					allhealing = false,
					alldamage = false,
					argent = true,
					healing = {
						[1]		= false,	-- physical
						[2]		= false,	-- holy
						[4]		= false,	-- fire
						[8]		= false,	-- nature
						[16]	= false,	-- frost
						[32]	= false,	-- shadow
						[64]	= false,	-- arcane
						[3]		= false,	-- Holystrike	
						[5]		= false,	-- Flamestrike	
						[6]		= false,	-- Holyfire		
						[9]		= false,	-- Stormstrike	
						[10]	= false,	-- Holystorm	
						[12]	= false,	-- Firestorm	
						[17]	= false,	-- Froststrike	
						[18]	= false,	-- Holyfrost	
						[20]	= false,	-- Frostfire	
						[24]	= false,	-- Froststorm	
						[33]	= false,	-- Shadowstrike	
						[34]	= false,	-- Shadowlight 	
						[36]	= false,	-- Shadowflame	
						[40]	= false,	-- Shadowstorm 	
						[48]	= false,	-- Shadowfrost	
						[65]	= false,	-- Spellstrike	
						[66]	= false,	-- Divine		
						[68]	= false,	-- Spellfire	
						[72]	= false,	-- Spellstorm	
						[80]	= false,	-- Spellfrost	
						[96]	= false,	-- Spellshadow	
						[28]	= false,	-- Elemental
						[124]	= false,	-- Chromatic
						[126]	= false,	-- Magic	
						[127]	= false,	-- Chaos		
					},
					damage = {
						[1]		= false,	-- physical
						[2]		= false,	-- holy
						[4]		= false,	-- fire
						[8]		= false,	-- nature
						[16]	= false,	-- frost
						[32]	= false,	-- shadow
						[64]	= false,	-- arcane
						[3]		= false,	-- Holystrike	
						[5]		= false,	-- Flamestrike	
						[6]		= false,	-- Holyfire		
						[9]		= false,	-- Stormstrike	
						[10]	= false,	-- Holystorm	
						[12]	= false,	-- Firestorm	
						[17]	= false,	-- Froststrike	
						[18]	= false,	-- Holyfrost	
						[20]	= false,	-- Frostfire	
						[24]	= false,	-- Froststorm	
						[33]	= false,	-- Shadowstrike	
						[34]	= false,	-- Shadowlight 	
						[36]	= false,	-- Shadowflame	
						[40]	= false,	-- Shadowstorm 	
						[48]	= false,	-- Shadowfrost	
						[65]	= false,	-- Spellstrike	
						[66]	= false,	-- Divine		
						[68]	= false,	-- Spellfire	
						[72]	= false,	-- Spellstorm	
						[80]	= false,	-- Spellfrost	
						[96]	= false,	-- Spellshadow	
						[28]	= false,	-- Elemental
						[124]	= false,	-- Chromatic
						[126]	= false,	-- Magic	
						[127]	= false,	-- Chaos		
					},
				},
				expand = {
					expheal = true,
					expdmg = true,
					healing = {
						[1]		= true,		-- physical
						[2]		= true,		-- holy
						[4]		= true,		-- fire
						[8]		= true,		-- nature
						[16]	= true,		-- frost
						[32]	= true,		-- shadow
						[64]	= true,		-- arcane
						[3]		= true,		-- Holystrike	
						[5]		= true,		-- Flamestrike	
						[6]		= true,		-- Holyfire		
						[9]		= true,		-- Stormstrike	
						[10]	= true,		-- Holystorm	
						[12]	= true,		-- Firestorm	
						[17]	= true,		-- Froststrike	
						[18]	= true,		-- Holyfrost	
						[20]	= true,		-- Frostfire	
						[24]	= true,		-- Froststorm	
						[33]	= true,		-- Shadowstrike	
						[34]	= true,		-- Shadowlight 	
						[36]	= true,		-- Shadowflame	
						[40]	= true,		-- Shadowstorm 	
						[48]	= true,		-- Shadowfrost	
						[65]	= true,		-- Spellstrike	
						[66]	= true,		-- Divine		
						[68]	= true,		-- Spellfire	
						[72]	= true,		-- Spellstorm	
						[80]	= true,		-- Spellfrost	
						[96]	= true,		-- Spellshadow	
						[28]	= true,		-- Elemental
						[124]	= true,		-- Chromatic
						[126]	= true,		-- Magic	
						[127]	= true,		-- Chaos		
					},
					damage = {
						[1]		= true,		-- physical
						[2]		= true,		-- holy
						[4]		= true,		-- fire
						[8]		= true,		-- nature
						[16]	= true,		-- frost
						[32]	= true,		-- shadow
						[64]	= true,		-- arcane
						[3]		= true,		-- Holystrike	
						[5]		= true,		-- Flamestrike	
						[6]		= true,		-- Holyfire		
						[9]		= true,		-- Stormstrike	
						[10]	= true,		-- Holystorm	
						[12]	= true,		-- Firestorm	
						[17]	= true,		-- Froststrike	
						[18]	= true,		-- Holyfrost	
						[20]	= true,		-- Frostfire	
						[24]	= true,		-- Froststorm	
						[33]	= true,		-- Shadowstrike	
						[34]	= true,		-- Shadowlight 	
						[36]	= true,		-- Shadowflame	
						[40]	= true,		-- Shadowstorm 	
						[48]	= true,		-- Shadowfrost	
						[65]	= true,		-- Spellstrike	
						[66]	= true,		-- Divine		
						[68]	= true,		-- Spellfire	
						[72]	= true,		-- Spellstorm	
						[80]	= true,		-- Spellfrost	
						[96]	= true,		-- Spellshadow	
						[28]	= true,		-- Elemental
						[124]	= true,		-- Chromatic
						[126]	= true,		-- Magic	
						[127]	= true,		-- Chaos		
					},
				},
				alerts = {
					sound = false,
					notify = false,
					chatframe = true,
					screenie = false,
					superbuffnotify = false,
					useparrot = false,
					parrotarea = "",
					usemsbt = false,
					msbtarea = "",
				},
			},
			values = {
				-- Primary talent spec
				[1] = {
					damage = {},
					heal = {},
				},
				-- Secondary talent spec
				[2] = {
					damage = {},
					heal = {},
				},
			}
		}
	else
		-- check if we need to upgrade the db
		HitCrit_upgradeDB()
	end
	db = self.db.factionrealm[HitCrit.me]

	HitCrit_Debug( "In OnInit" )

	HitCrit:setToggles()
	HitCrit:SetupOptions()
	HitCrit:ChangeLabel()

	HitCrit:populateSuperBuffs()
	-- Event listeners
	HitCrit:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
	HitCrit:RegisterEvent( "ACTIVE_TALENT_GROUP_CHANGED" )
	-- Toggle if we're not detecting superbuffs/vehicles
	if ( db.options.tracking.spdetect ~= true ) then
		HitCrit:RegisterEvent( "UNIT_AURA" )
		HitCrit:RegisterEvent( "UNIT_ENTERED_VEHICLE" )
		HitCrit:RegisterEvent( "UNIT_EXITED_VEHICLE" )
		HitCrit:checkSuperBuffs()
	end
	-- libdbicon stuff
	if LDBIcon then
		LDBIcon:Register( MODNAME, launcher, db.options.display.minimap_icon )
	end

end

--[[
************************************************************************
CHANGELOG:

Date : 7/4/11
	Updated for 4.2 CLEU changes
	toc bump
Date : 5/7/11
	Revert bad change (not sure when it happened) in expandHandler
Date : 04/27/11
	Updated for 4.1 CLEU, et al
	Added LibDBIcon
Date : 03/20/11
	Added in all current known spell schools
Date : 01/14/11
	Adding in per spec tracking
Date : 08/25/10
	One more chatframe reporting fix (dmg spells)
	Found Eadric's "Hammer of the Righteous" to exclude
Date : 08/20/10
	Fixed chatframe reporting
	Fixed FoL reporting (paladin)
Date : 08/19/10
	Adding proper Argent Tourney suppression
Date : 8/23/09
	Adding category/school collapse/expand buttons to tooltip
Date : 8/6/09
	Updated new Libqtip (which contains scripting)
	Removed libqtipclick
	updated toc to 3.2 (30200)
	adding option for tooltip delay (and slider to adjust)
Date : 5/31/09
	Removed data reset thinger in favor of using libqtipclick
	Added Libqtipclick support
	added reporting into chatframe support
Date : 4/15/09
	added ability to turn off the superbuff notifications in chat
Date : 12/02/08
	added ability display top hit/crit values in text of display
Date : 11/17/08
	added data browser and the ability to remove data points
Date : 11/15/08
	changed font size to tooltip scaling in options == win
Date : 10/29/08
	Initial version
************************************************************************
]]--