--[[
************************************************************************
Project			: Broker_HitCrit
Author			: James D. Callahan III
Project Revision	: 2.22.3-release
Project Date		: 20120914093113

File			: Broker_HitCrit.lua
Commit Author		: James D. Callahan III
Commit Revision		: @file-revision@
Commit Date		: 20120914093113
************************************************************************
Description	:
	Main addon file.

TODO		:
	Add in disable for vulnerable and low level mobs
--]]

-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local pairs = _G.pairs
local select = _G.select

-- Libraries
local math = _G.math
local table = _G.table

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local ADDON_NAME = "HitCrit"

local HitCrit = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0")
local addon = HitCrit
_G.HitCrit = HitCrit

local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON_NAME)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigReg = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local QT = LibStub:GetLibrary("LibQTip-1.0")
local LDBIcon = LibStub("LibDBIcon-1.0")

do
	local debug_version = false
	local alpha_version = false

	--[===[@debug@
	debug_version = true
	--@end-debug@]===]

	--[===[@alpha@
	alpha_version = true
	--@end-alpha@]===]

	local addon_version = _G.GetAddOnMetadata(FOLDER_NAME, "Version")
	addon.version = debug_version and "Devel" or (alpha_version and addon_version .. "-Alpha") or addon_version

end --do-block
local addon_author = "James D. Callahan III"
local build_date = "20120914093113"

------------------------------------------------------------------------------
-- Constants.
------------------------------------------------------------------------------
local PLUS_ICON = "|TInterface\\Buttons\\UI-PlusButton-Up:18:18:1:0|t"
local MINUS_ICON = "|TInterface\\Buttons\\UI-MinusButton-Up:18:18:1:0|t"

local SPELL_SCHOOLS = private.SPELL_SCHOOLS

------------------------------------------------------------------------------
-- Variables.
------------------------------------------------------------------------------
local modularOptions = {}
local tooltip

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

local function HitCrit_Print( msg )
	if not msg then
		return
	end
	local font_height = math.ceil(select(2, _G.DEFAULT_CHAT_FRAME:GetFont()))
	local icon = "\124TInterface\\Addons\\Broker_HitCrit\\icon:" .. font_height .. "\124t"
	_G.DEFAULT_CHAT_FRAME:AddMessage(icon .. " HitCrit: " .. msg, 0.6, 1.0, 1.0)
end

local function HitCrit_Debug( msg )
	if not msg or not db.options.display.debug then
		return
	end
	HitCrit_Print("DEBUG: " .. msg)
end

local function HitCrit_Red(text)
	return "|cffff0000" .. text .. "|r"
end

local function HitCrit_Yellow(text)
	return "|cffffff00" .. text .. "|r"
end

local function HitCrit_Green(text)
	return "|cff00ff00" .. text .. "|r"
end

local function HitCrit_White(text)
	return "|cffffffff" .. text .. "|r"
end

local function HitCrit_hit(text)
	return "|cff00ffff" .. text .. "|r"
end

local function HitCrit_crit(text)
	return "|cffff8080" .. text .. "|r"
end

local function HitCrit_sch(text)
	return "|cffdfa050" .. text .. "|r"
end

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

local function HitCrit_initHC( entry )
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

local function HitCrit_initSpellEntry()
	local entry = {}
	entry.effect = ""
	entry.school = 0
	entry.rank = 0
	HitCrit_initHC( entry )
	return entry
end

local function HitCrit_CheckInsertAlert( heal, id, hit, crit, dName, effect, sch )
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
			local sName, sRank = _G.GetSpellInfo( id )
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

	local targetLevel = _G.UnitLevel( "target" )
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
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glance, crush = select( 1, ... )
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
		outString = outString .. "(" .. SPELL_SCHOOLS[dbv["school"]] .. ") " .. L["for"] .. " "
		outString = outString .. dbv["hit"][1]["value"] .. " "

		if ( ( dbv.num ~= 0 ) and ( dbv.numcrit ~= 0 ) ) then
			outString = outString .. L["with"] .. " " .. L["Crit"] .. " "
			outString = outString .. dbv["crit"][1]["value"]
			outString = outString .. string.format("(%.1f%%)", (dbv.numcrit / dbv.num * 100))
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
		resetCat = tonumber( resetCat )
		HitCrit_Debug( "got rT and rC of " .. resetType .. "/" .. resetCat )
		dbe[resetType][resetCat] = not dbe[resetType][resetCat]
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
				HideTooltip()
				HitCrit.resetType = 2
				local c = ""
				if ( HitCrit.selCategory == 1 ) then c = L["Damage"] else c = L["Heal"] end
				StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
				string.format( L["Reset Category: %s. Are you sure?"], c )
				StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
			elseif ( resetType == "3" ) then
				HitCrit.selSchool = tonumber( resetSpecific )
				HitCrit_Debug( "Resetting school (" .. resetCat .. ") --> " .. resetSpecific )
				HideTooltip()
				HitCrit.resetType = 3
				local c = ""
				if ( HitCrit.selCategory == 1 ) then c = L["Damage"] else c = L["Heal"] end
				local s = SPELL_SCHOOLS[ HitCrit.selSchool ]
				StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
				string.format( L["Reset Category: %s, School: %s. Are you sure?"], c, s )
				StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
			elseif ( resetType == "4" ) then
				HitCrit.selEntry = tonumber( resetSpecific )
				HitCrit.selEntryName = GetSpellInfo( resetSpecific )
				HitCrit_Debug( "Resetting spell (" .. resetCat .. ") --> " .. resetSpecific )
				if ( hitorcrit == "a" ) then
					HideTooltip()
					HitCrit.resetType = 4
					local e = HitCrit.selEntryName
					StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
					string.format( L["Reset all entries for spell: %s. Are you sure?"], e )
					StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
				else
					HideTooltip()
					HitCrit.resetType = 4
					local e = HitCrit.selEntryName
					local t = HitCrit.selType
					StaticPopupDialogs["HC_CONFIRM_RESET_DATA"].text =
					string.format( L["Reset first %s entry for spell: %s. Are you sure?"], t, e )
					StaticPopup_Show( "HC_CONFIRM_RESET_DATA" )
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

local OPTIONAL_TOOLTIP_COLUMNS = {
	"avg",
	"hit",
	"crit",
	"enemyName",
}

function addon:drawTooltip( talent )
	-- plus and minus icons
	local db_suppress = db.options.suppress
	local db_display = db.options.display
	local db_expand = db.options.expand
	local headerTitle = ""
	local num_columns = 2
	local t = {
		"LEFT",
		"LEFT"
	}

	for index = 1, #OPTIONAL_TOOLTIP_COLUMNS do
		if db_display[OPTIONAL_TOOLTIP_COLUMNS[index]] then
			num_columns = num_columns + 1
			t[#t + 1] = "RIGHT"
		end
	end
	tooltip:Hide()
	tooltip:Clear()
	tooltip:SetColumnLayout(num_columns, unpack(t))

	if  talent == HitCrit.activeTalents then
		headerTitle = HitCrit_White( L["Broker_HitCrit"] .. " - " .. HitCrit.specName )
	else
		headerTitle = HitCrit_White( L["Broker_HitCrit"] .. " - " .. L["Inactive Spec"] )
	end
	local colIndex = 0
	local line_num = tooltip:AddHeader("b")
	tooltip:SetCell(line_num, 1, headerTitle, "CENTER", num_columns)

	local t = {}

	if db_display.type then
		-- sort by damage school
		local schools = {
			damage = {},
			healing = {},
		}

		for k, v in pairs(SPELL_SCHOOLS) do
			schools.damage[k] = {}
			schools.healing[k] = {}
		end

		for k, v in pairs(db.values[talent].damage) do
			if not schools.damage[v.school] then
				schools.damage[v.school] = {}
			end
			schools.damage[v.school][k] = true
		end

		for k, v in pairs(db.values[talent].heal) do
			if not schools.healing[v.school] then
				schools.healing[v.school] = {}
			end
			schools.healing[v.school][k] = true
		end

		-- damage block
		if not db_suppress.alldamage then
			line_num = tooltip:AddLine(" ")
			tooltip:SetCell(line_num, 2, HitCrit_Red("  " .. L["Damage"]), "LEFT", (num_columns - 1))
			tooltip:SetCellScript(line_num, 2, "OnMouseDown", HitCrit_MouseHandler, "2~damage~0~h")

			if not db_expand.expdmg then
				tooltip:SetCell(line_num, 1, PLUS_ICON, "LEFT", 1)
				tooltip:SetCellScript(line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg")
			else
				tooltip:SetCell(line_num, 1, MINUS_ICON, "LEFT", 1)
				tooltip:SetCellScript(line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg")

				table.wipe(t)
				table.insert(t, " ")
				table.insert(t, HitCrit_White("    " .. L["Effect"]))

				if db_display.avg then
					table.insert(t, HitCrit_White(L["Avg"]))
				end

				if db_display.hit then
					table.insert(t, HitCrit_White(L["Hit"]))
				end

				if db_display.crit then
					table.insert(t, HitCrit_White(L["Crit"] .. "(%)"))
				end

				if db_display.enemyName then
					table.insert(t, HitCrit_White(L["Against"]))
				end
				tooltip:AddLine(unpack(t))

				for k, v in pairs(SPELL_SCHOOLS) do
					if next(schools.damage[k]) and not db_suppress.damage[k] then
						line_num = tooltip:AddLine(" ")
						tooltip:SetCell(line_num, 2, HitCrit_sch("    " .. v), "LEFT", (num_columns - 1))
						tooltip:SetCellScript(line_num, 2, "OnMouseDown", HitCrit_MouseHandler, "3~damage~" .. k .. "~h")

						if not db_expand.damage[k] then
							tooltip:SetCell(line_num, 1, "  " .. PLUS_ICON, "LEFT", 1)
							tooltip:SetCellScript(line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "damage~" .. k)
						else
							tooltip:SetCell(line_num, 1, "  " .. MINUS_ICON, "LEFT", 1)
							tooltip:SetCellScript(line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "damage~" .. k)

							for m, u in pairs(schools.damage[k]) do
								local i = db.values[talent]["damage"][m]
								local crit_value = i.crit[1].value
								local col_index = 2
								line_num = tooltip:AddLine("b")
								tooltip:SetCell(line_num, 1, " ", "LEFT", 1)
								tooltip:SetCell(line_num, col_index, HitCrit_Yellow("      " .. i.effect), "LEFT", 1)
								tooltip:SetCellScript(line_num, col_index, "OnMouseDown", HitCrit_MouseHandler, "4~damage~" .. m .. "~a")

								if db_display.avg then
									local average = (i.num == 0) and " " or floor(i.total / i.num)

									col_index = col_index + 1
									tooltip:SetCell(line_num, col_index, HitCrit_Yellow(average), "RIGHT", 1)
								end

								if db_display.hit then
									col_index = col_index + 1
									tooltip:SetCell(line_num, col_index, HitCrit_hit(i.hit[1].value), "RIGHT", 1)
									tooltip:SetCellScript(line_num, col_index, "OnMouseDown", HitCrit_MouseHandler, "4~damage~" .. m .. "~h")
								end

								if db_display.crit then
									local crit_percent

									if i.num ~= 0 and i.numcrit ~= 0 then
										crit_percent = string.format("(%.1f%%)", (i.numcrit / i.num * 100))
									else
										crit_percent = ""
									end
									col_index = col_index + 1
									tooltip:SetCell(line_num, col_index, HitCrit_crit(crit_value .. crit_percent), "RIGHT", 1)
									tooltip:SetCellScript(line_num, col_index, "OnMouseDown", HitCrit_MouseHandler, "4~damage~" .. m .. "~c")
								end

								if db_display.enemyName then
									col_index = col_index + 1
									if crit_value ~= 0 then
										tooltip:SetCell(line_num, col_index, HitCrit_crit(i.crit[1].name), "RIGHT", 1)
									else
										tooltip:SetCell(line_num, col_index, HitCrit_hit(i.hit[1].name), "RIGHT", 1)
									end
								end
							end
						end
					end
				end
			end
		end

		---------------------------------------------
		-- TODO: Look at all code under this comment.
		---------------------------------------------
		-- healing block
		if ( not db_suppress.allhealing ) then
			line_num = tooltip:AddLine( " " )
			tooltip:SetCell( line_num, 1, "+", "LEFT", 1 )
			tooltip:SetCell( line_num, 2, HitCrit_Green( "  " .. L["Healing"] ), "LEFT", ( num_columns - 1 ) )
			tooltip:SetCellScript( line_num, 2, "OnMouseDown", HitCrit_MouseHandler, "2~heal~0~h" )
			if ( db_expand.expheal == false ) then
				tooltip:SetCell( line_num, 1, PLUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
			else
				tooltip:SetCell( line_num, 1, MINUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
				wipe(t)
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( db_display.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( db_display.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( db_display.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( db_display.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				for k, v in pairs(SPELL_SCHOOLS) do
					if ( ( next( schools.healing[k] ) ~= nil ) and ( not db_suppress.healing[k] ) ) then
						line_num = tooltip:AddLine( " " )
						tooltip:SetCell( line_num, 2, HitCrit_sch( "    " .. v ), "LEFT", ( num_columns - 1 ) )
						tooltip:SetCellScript( line_num, 2, "OnMouseDown",
							HitCrit_MouseHandler, "3~heal~" .. k .. "~h" )
						if ( db_expand.healing[k] == false ) then
							tooltip:SetCell( line_num, 1, "  " .. PLUS_ICON, "LEFT", 1 )
							tooltip:SetCellScript( line_num, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "healing~" .. k )
						else
							tooltip:SetCell( line_num, 1, "  " .. MINUS_ICON, "LEFT", 1 )
							tooltip:SetCellScript( line_num, 1, "OnMouseDown",
								HitCrit_ExpandHandler, "healing~" .. k )
							for m, n in pairs( schools.healing[k] ) do
								local i = db.values[talent]["heal"][m]
								local e, h, c, a = i.effect, i.hit[1].value, i.crit[1].value, floor( i.total / i.num )
								local cp = ""
								if ( ( i.num ~= 0 ) and ( i.numcrit ~= 0 ) )
									then cp = string.format( "(%.1f%%)", ( i.numcrit / i.num * 100 ) )
								end
								if ( i.num == 0 ) then a = " " end
								line_num = tooltip:AddLine( " " )
								tooltip:SetCell( line_num, 1, " ", "LEFT", 1 )
								colIndex = 2
								tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( "      " .. e ), "LEFT", 1 )
								tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
									HitCrit_MouseHandler, "4~heal~" .. m .. "~a" )
								if ( db_display.avg ) then
									colIndex = colIndex + 1
									tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
								end
								if ( db_display.hit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( line_num, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
									tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
										HitCrit_MouseHandler, "4~heal~" .. m .. "~h" )
								end
								if ( db_display.crit ) then
									colIndex = colIndex + 1
									tooltip:SetCell( line_num, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
									tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
										HitCrit_MouseHandler, "4~heal~" .. m .. "~c" )
								end
								if ( db_display.enemyName ) then
									colIndex = colIndex + 1
									if ( c ~= 0 ) then
										tooltip:SetCell( line_num, colIndex, HitCrit_crit( i.crit[1].name ), "RIGHT", 1 )
									else
										tooltip:SetCell( line_num, colIndex, HitCrit_hit( i.hit[1].name ), "RIGHT", 1 )
									end
								end
							end
						end
					end
				end
			end
		end
	else
		if ( not db_suppress.alldamage ) then
			-- damage header lines
			line_num = tooltip:AddLine( " " )
			tooltip:SetCell( line_num, 2, HitCrit_Red( "  " .. L["Damage"] ), "LEFT", ( num_columns - 1 ) )
			tooltip:SetCellScript( line_num, 2, "OnMouseDown", HitCrit_MouseHandler, "2~damage~0~h" )
			if ( db_expand.expdmg == false ) then
				tooltip:SetCell( line_num, 1, PLUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
			else
				tooltip:SetCell( line_num, 1, MINUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "dmg" )
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( db_display.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( db_display.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( db_display.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( db_display.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				for k, v in pairs( db.values[talent]["damage"] ) do
					local e, h, c, a = v.effect, v.hit[1].value, v.crit[1].value, floor( v.total / v.num )
					local cp = ""
					if ( ( v.num ~= 0 ) and ( v.numcrit ~= 0 ) )
						then cp = string.format( "(%.1f%%)", ( v.numcrit / v.num * 100 ) )
					end
					if ( v.num == 0 ) then a = " " end
					line_num = tooltip:AddLine( " " )
					tooltip:SetCell( line_num, 1, " ", "LEFT", 1 )
					colIndex = 2
					tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( "    " .. e ), "LEFT", 1 )
					tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
						HitCrit_MouseHandler, "4~damage~" .. k .. "~a" )
					if ( db_display.avg ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
					end
					if ( db_display.hit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
						tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
							HitCrit_MouseHandler, "4~damage~" .. k .. "~h" )
					end
					if ( db_display.crit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
						tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
							HitCrit_MouseHandler, "4~damage~" .. k .. "~c" )
					end
					if ( db_display.enemyName ) then
						colIndex = colIndex + 1
						if ( c ~= 0 ) then
							tooltip:SetCell( line_num, colIndex, HitCrit_crit( v.crit[1].name ), "RIGHT", 1 )
						else
							tooltip:SetCell( line_num, colIndex, HitCrit_hit( v.hit[1].name ), "RIGHT", 1 )
						end
					end
				end
			end
		end
		if ( not db_suppress.allhealing ) then
			-- healing header lines
			line_num = tooltip:AddLine( " " )
			tooltip:SetCell( line_num, 2, HitCrit_Green( "  " .. L["Healing"] ), "LEFT", ( num_columns - 1 ) )
			tooltip:SetCellScript( line_num, 2, "OnMouseDown", HitCrit_MouseHandler, "2~heal~0~h" )
			if ( db_expand.expheal == false ) then
				tooltip:SetCell( line_num, 1, PLUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
			else
				tooltip:SetCell( line_num, 1, MINUS_ICON, "LEFT", 1 )
				tooltip:SetCellScript( line_num, 1, "OnMouseDown", HitCrit_ExpandHandler, "heal" )
				wipe(t)
				table.insert( t, " " )
				table.insert( t, HitCrit_White( "    " .. L["Effect"] ) )
				if ( db_display.avg ) then table.insert( t, HitCrit_White( L["Avg"] ) ) end
				if ( db_display.hit ) then table.insert( t, HitCrit_White( L["Hit"] ) ) end
				if ( db_display.crit ) then table.insert( t, HitCrit_White( L["Crit"] .. "(%)" ) ) end
				if ( db_display.enemyName ) then table.insert( t, HitCrit_White( L["Against"] ) ) end
				tooltip:AddLine( unpack( t ) )
				-- loop through healing
				for k, v in pairs( db.values[talent]["heal"] ) do
					local e, h, c, a = v.effect, v.hit[1].value, v.crit[1].value, floor( v.total / v.num )
					local cp = ""
					if ( ( v.num ~= 0 ) and ( v.numcrit ~= 0 ) )
						then cp = string.format( "(%.1f%%)", ( v.numcrit / v.num * 100 ) )
					end
					if ( v.num == 0 ) then a = " " end
					line_num = tooltip:AddLine( " " )
					tooltip:SetCell( line_num, 1, " ", "LEFT", 1 )
					colIndex = 2
					tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( "    " .. e ), "LEFT", 1 )
					tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
						HitCrit_MouseHandler, "4~heal~" .. k .. "~a" )
					if ( db_display.avg ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_Yellow( a ), "RIGHT", 1 )
					end
					if ( db_display.hit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_hit( h ), "RIGHT", 1 )
						tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
							HitCrit_MouseHandler, "4~heal~" .. k .. "~h" )
					end
					if ( db_display.crit ) then
						colIndex = colIndex + 1
						tooltip:SetCell( line_num, colIndex, HitCrit_crit( c .. cp ), "RIGHT", 1 )
						tooltip:SetCellScript( line_num, colIndex, "OnMouseDown",
							HitCrit_MouseHandler, "4~heal~" .. k .. "~c" )
					end
					if ( db_display.enemyName ) then
						colIndex = colIndex + 1
						if ( c ~= 0 ) then
							tooltip:SetCell( line_num, colIndex, HitCrit_crit( v.crit[1].name ), "RIGHT", 1 )
						else
							tooltip:SetCell( line_num, colIndex, HitCrit_hit( v.hit[1].name ), "RIGHT", 1 )
						end
					end
				end
			end
		end
	end
	-- Add menu items
	tooltip:AddLine(" ")
	line_num = tooltip:AddLine( "c" )
	tooltip:SetCell( line_num, 1, HitCrit_Yellow( L["Left-click to Report values in chat"] ), "LEFT", num_columns)
	line_num = tooltip:AddLine( "d" )
	tooltip:SetCell( line_num, 1, HitCrit_Yellow( L["Alt-Left-click to delete values"] ), "LEFT", num_columns)
	line_num = tooltip:AddLine( "e" )
	tooltip:SetCell( line_num, 1, HitCrit_Yellow( L["Right-click for Configuration"] ), "LEFT", num_columns)
	line_num = tooltip:AddLine( "f" )
	if ( HitCrit.currTT == HitCrit.activeTalents ) then
		tooltip:SetCell( line_num, 1, HitCrit_Yellow( L["Alt-Right-click to see Inactive Spec"] ), "LEFT", num_columns)
	else
		tooltip:SetCell( line_num, 1, HitCrit_Yellow( L["Alt-Right-click to see Active Spec"] ), "LEFT", num_columns)
	end
end

local LDB = LibStub( "LibDataBroker-1.1" )
local launcher = LDB:NewDataObject( ADDON_NAME, {
	type = "data source",
	text = " ",
	label = FOLDER_NAME,
	icon = "Interface\\Addons\\Broker_HitCrit\\icon",
	OnClick = function(clickedframe, button)
		if (button == "RightButton") then
			if (IsAltKeyDown()) then
				-- switch to other spec
				if (HitCrit.currTT == 1) then
					HitCrit.currTT = 2
				else
					HitCrit.currTT = 1
				end
				tooltip:Release()
				tooltip = QT:Acquire("HitCritTT", 5, "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
				tooltip:SetScale(db.options.display.tipscale)
				addon:drawTooltip(HitCrit.currTT)
				tooltip:SetAutoHideDelay(db.options.display.autoHideDelay, clickedframe)
				tooltip:EnableMouse()
				tooltip:SmartAnchorTo(clickedframe)
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

local function HitCrit_upgradeDB()
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
			local _, sRank = _G.GetSpellInfo(k)
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
		for k, v in pairs(SPELL_SCHOOLS) do
			olddb.options.tracking.healing[k] = true
		end
		olddb.options.tracking.damage = nil
		olddb.options.tracking.damage = {}
		for k, v in pairs(SPELL_SCHOOLS) do
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
		for k, v in pairs(SPELL_SCHOOLS) do
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
		for k, v in pairs(SPELL_SCHOOLS) do
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
		local activeTalentGroup = _G.GetActiveSpecGroup()
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
		for k, v in pairs(SPELL_SCHOOLS) do
			olddb.options.suppress.healing[k] = false
			olddb.options.suppress.damage[k] = false
		end
		for k, v in pairs(SPELL_SCHOOLS) do
			olddb.options.expand.healing[k] = true
			olddb.options.expand.damage[k] = true
		end
		for k, v in pairs(SPELL_SCHOOLS) do
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

local alertOptions
local displayOptions
local suppressOptions
local trackingOptions
local options

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
						for k, v in pairs(SPELL_SCHOOLS) do
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
						for k, v in pairs(SPELL_SCHOOLS) do
							db.options.tracking.healing[k] = newsetvalue
						end
					end,
				},
			},
		}
	end
	-- loops to add in the spell school stuff
	for k, v in pairs(SPELL_SCHOOLS) do
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
				for k, v in pairs(SPELL_SCHOOLS) do
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
				for k, v in pairs(SPELL_SCHOOLS) do
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
							  LDBIcon[value and "Show" or "Hide"](LDBIcon, ADDON_NAME)
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
						for k, v in pairs(SPELL_SCHOOLS) do
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
						for k, v in pairs(SPELL_SCHOOLS) do
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
	for k, v in pairs(SPELL_SCHOOLS) do
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
				for k, v in pairs(SPELL_SCHOOLS) do
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
				for k, v in pairs(SPELL_SCHOOLS) do
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
			name = ADDON_NAME,
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
							name	= L["Author : "] .. addon_author .. "\n",
						},
						version = {
							order	= 14,
							type	= "description",
							name	= L["Version : "] .. addon.version .. "\n",
						},
						builddate = {
							order	= 15,
							type	= "description",
							name	= L["Build Date : "] .. build_date .. "\n",
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
	AceConfigReg:RegisterOptionsTable(ADDON_NAME, fullOptions)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions(ADDON_NAME, nil, nil, "general")

	-- Fill up our modular options...
	self:RegisterModuleOptions("Tracking", giveTracking(), L["Tracking Options"])
	self:RegisterModuleOptions("Display", giveDisplay(), L["Display Options"])
	self:RegisterModuleOptions("Suppress", giveSuppress(), L["Suppression Options"])
	self:RegisterModuleOptions("Alert", giveAlert(), L["Alert Options"])
end

function addon:setToggles()
	local tdb = db.options.tracking.damage
	local result = true
	for k, v in pairs(SPELL_SCHOOLS) do
		if ( tdb[k] == false ) then
			result = false
			break
		end
	end
	HitCrit.dmgToggleAll = result
	tdb = db.options.tracking.healing
	result = true
	for k, v in pairs(SPELL_SCHOOLS) do
		if ( tdb[k] == false ) then
			result = false
			break
		end
	end
	HitCrit.healToggleAll = result
end

function addon:populateSuperBuffs()
	for k, v in pairs( superBuffIDs ) do
		superBuffNames[_G.GetSpellInfo(k)] = true
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
		local name, _, texture = _G.UnitBuff( "player", i )
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
	HitCrit.activeTalents = GetActiveSpecGroup()
	HitCrit.specName = select(2, GetSpecializationInfo(GetSpecialization()))
	HitCrit.currTT = HitCrit.activeTalents
end

function addon:RegisterModuleOptions(name, optionsTable, displayName)
	modularOptions[name] = optionsTable
	self.optionsFrame[name] = AceConfigDialog:AddToBlizOptions(ADDON_NAME, displayName, ADDON_NAME, name)
end

function HitCrit:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory( self.optionsFrame["Display"] )
end

function HitCrit:OnInitialize()
	-- If there was frame creation stuff to do, it would go here
end

function HitCrit:OnEnable()
    -- Called when the addon is loaded
	HitCrit.me = UnitName( "player" )
	HitCrit.GUID = UnitGUID( "player" )
	HitCrit.level = UnitLevel( "player" )
	HitCrit.activeTalents = GetActiveSpecGroup()
	HitCrit.specName = select(2, GetSpecializationInfo(GetSpecialization()))
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
		LDBIcon:Register( ADDON_NAME, launcher, db.options.display.minimap_icon )
	end

end
