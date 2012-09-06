﻿-- X-Perl UnitFrames
-- Author: Zek <Boodhoof-EU>
-- License: GNU GPL v3, 29 June 2007 (see LICENSE.txt)

if (GetLocale() == "itIT") then
XPerl_ProductName		= "|cFFD00000X-Perl|r UnitFrames"
XPerl_ShortProductName	= "|cFFD00000X-Perl|r"
XPerl_Author			= "|cFFFF8080Zek|r"
XPerl_Description		= XPerl_ProductName.." di "..XPerl_Author
XPerl_VersionNumber 	= "3.5.3"
XPerl_Version			= XPerl_Description.." - "..XPerl_VersionNumber
XPerl_LongDescription	= "Sostituzione dell'UnitFrame del Personaggio, Famiglio, Gruppo, Bersaglio, Bersaglio del Bersaglio, Focus e Incursioni"
XPerl_ModMenuIcon		= "Interface\\Icons\\INV_Misc_Gem_Pearl_02"

XPERL_COMMS_PREFIX		= "X-Perl"
XPERL_MINIMAP_HELP1		= "|c00FFFFFFClick Sinistro|r per le opzioni (e per |c0000FF00sbloccare le finestre|r)"
XPERL_MINIMAP_HELP2		= "|c00FFFFFFClick Destro|r per spostare questa icona"
XPERL_MINIMAP_HELP3		= "\rMembri reali dell'incursione: |c00FFFF80%d|r\rMembri reali del gruppo: |c00FFFF80%d|r"
XPERL_MINIMAP_HELP4		= "\rSei il capogruppo/capoincursione reale"
XPERL_MINIMAP_HELP5		= "|c00FFFFFFAlt|r per info sull'uso di memoria di X-Perl"
XPERL_MINIMAP_HELP6		= "|c00FFFFFF+Maiusc|r per l'uso di memoria di X-Perl dall'avvio"

XPERL_MINIMENU_OPTIONS	= "Opzioni"
XPERL_MINIMENU_ASSIST	= "Visualizza finestra assist"
XPERL_MINIMENU_CASTMON	= "Visualizza monitor dei lanci delle magie"
XPERL_MINIMENU_RAIDAD	= "Visualizza Amministratore Incursione"
XPERL_MINIMENU_ITEMCHK	= "Visualizza Controllo Oggetti"
XPERL_MINIMENU_RAIDBUFF = "Buff Incursione"
XPERL_MINIMENU_ROSTERTEXT="Roster Text"
XPERL_MINIMENU_RAIDSORT = "Riorganizzazione Incursione"
XPERL_MINIMENU_RAIDSORT_GROUP = "Organizza per gruppo"
XPERL_MINIMENU_RAIDSORT_CLASS = "Organizza per classe"

XPERL_TYPE_NOT_SPECIFIED = "Non specificato"
XPERL_TYPE_PET		= PET			-- "Pet"
XPERL_TYPE_BOSS 	= "Boss"
XPERL_TYPE_RAREPLUS = "Raro+"
XPERL_TYPE_ELITE	= "Elite"
XPERL_TYPE_RARE 	= "Raro"

-- Zones
XPERL_LOC_ZONE_SERPENTSHRINE_CAVERN	= "Serpentshrine Cavern"
XPERL_LOC_ZONE_BLACK_TEMPLE			= "Black Temple"
XPERL_LOC_ZONE_HYJAL_SUMMIT			= "Hyjal Summit"
XPERL_LOC_ZONE_KARAZHAN				= "Karazhan"
XPERL_LOC_ZONE_SUNWELL_PLATEAU		= "Sunwell Plateau"
XPERL_LOC_ZONE_NAXXRAMAS			= "Naxxramas"
XPERL_LOC_ZONE_OBSIDIAN_SANCTUM		= "The Obsidian Sanctum"
XPERL_LOC_ZONE_EYE_OF_ETERNITY		= "The Eye of Eternity"
XPERL_LOC_ZONE_ULDUAR				= "Ulduar"
XPERL_LOC_ZONE_TRIAL_OF_THE_CRUSADER= "Trial of the Crusader"
XPERL_LOC_ZONE_ICECROWN_CITADEL		= "Icecrown Citadel"
XPERL_LOC_ZONE_RUBY_SANCTUM			= "The Ruby Sanctum"
--Any zones 4.x and higher can all be localized from EJ, in 5.0, even these above zones are in EJ which means the rest can go bye bye too

-- Status
XPERL_LOC_DEAD		= DEAD			-- "Dead"
XPERL_LOC_GHOST 	= "Spirito"
XPERL_LOC_FEIGNDEATH	= "Finta morte"
XPERL_LOC_OFFLINE	= PLAYER_OFFLINE	-- "Offline"
XPERL_LOC_RESURRECTED	= "Riportato in vita"
XPERL_LOC_SS_AVAILABLE	= "SS Disponibile"
XPERL_LOC_UPDATING	= "In aggiornamento"
XPERL_LOC_ACCEPTEDRES	= "Accettata"		-- Res accepted
XPERL_RAID_GROUP	= "Gruppo %d"
XPERL_RAID_GROUPSHORT	= "G%d"

XPERL_LOC_NONEWATCHED	= "none watched"

XPERL_LOC_STATUSTIP = "Status Highlights: " 	-- Tooltip explanation of status highlight on unit
XPERL_LOC_STATUSTIPLIST = {
	HOT = "Heal over Time",
	AGGRO = "Aggro",
	MISSING = "Missing your class' buff",
	HEAL = "Being healed",
	SHIELD = "Shielded"
}

XPERL_OK		= "OK"
XPERL_CANCEL		= "Annulla"

XPERL_LOC_LARGENUMDIV	= 1000
XPERL_LOC_LARGENUMTAG	= "K"
XPERL_LOC_HUGENUMDIV	= 1000000
XPERL_LOC_HUGENUMTAG	= "M"

BINDING_HEADER_XPERL = XPerl_ProductName
BINDING_NAME_TOGGLERAID = "Abilita/Disattiva Raid Windows"
BINDING_NAME_TOGGLERAIDSORT = "Abilita/Disattiva riorganizzazione per classe/gruppo"
BINDING_NAME_TOGGLERAIDPETS = "Abilita/Disattiva Raid Pets"
BINDING_NAME_TOGGLEOPTIONS = "Abilita/Disattiva finestra opzioni"
BINDING_NAME_TOGGLEBUFFTYPE = "Abilita/Disattiva Buffs/Debuffs/none"
BINDING_NAME_TOGGLEBUFFCASTABLE = "Abilita/Disattiva Castable/Curable"
BINDING_NAME_TEAMSPEAKMONITOR = "Teamspeak Monitor"
BINDING_NAME_TOGGLERANGEFINDER = "Abilita/Disattiva Range Finder"

XPERL_KEY_NOTICE_RAID_BUFFANY = "Visualizza tutti i benefici/penalità"
XPERL_KEY_NOTICE_RAID_BUFFCURECAST = "Visualizza solo benefici lanciabili/curabili o Only castable/curable buffs or debuffs shown"
XPERL_KEY_NOTICE_RAID_BUFFS = "Raid Buffs shown"
XPERL_KEY_NOTICE_RAID_DEBUFFS = "Raid Debuffs shown"
XPERL_KEY_NOTICE_RAID_NOBUFFS = "No raid buffs shown"

XPERL_DRAGHINT1		= "|c00FFFFFFFai Click|r per riscalare la finestra"
XPERL_DRAGHINT2		= "|c00FFFFFFFai Maiusc+Click|r per ridimensionare la finestra"

-- Usage
XPerlUsageNameList	= {XPerl = "Core", XPerl_Player = "Player", XPerl_PlayerPet = "Pet", XPerl_Target = "Target", XPerl_TargetTarget = "Target's Target", XPerl_Party = "Party", XPerl_PartyPet = "Party Pets", XPerl_RaidFrames = "Raid Frames", XPerl_RaidHelper = "Raid Helper", XPerl_RaidAdmin = "Raid Admin", XPerl_TeamSpeak = "TS Monitor", XPerl_RaidMonitor = "Raid Monitor", XPerl_RaidPets = "Raid Pets", XPerl_ArcaneBar = "Arcane Bar", XPerl_PlayerBuffs = "Player Buffs", XPerl_GrimReaper = "Grim Reaper"}
XPERL_USAGE_MEMMAX	= "UI Mem Max: %d"
XPERL_USAGE_MODULES = "Moduli: "
XPERL_USAGE_NEWVERSION	= "*Una nuova versione"
XPERL_USAGE_AVAILABLE	= "%s |c00FFFFFF%s|r è disponibile per il download"

XPERL_CMD_MENU		= "menu"
XPERL_CMD_OPTIONS	= "opzioni"
XPERL_CMD_LOCK		= "blocca"
XPERL_CMD_UNLOCK	= "sblocca"
XPERL_CMD_CONFIG	= "configurazioni"
XPERL_CMD_LIST		= "elenca"
XPERL_CMD_DELETE	= "elimina"
XPERL_CMD_HELP		= "|c00FFFF80Utilizzo: |c00FFFFFF/xperl menu | blocca | sblocca | configurazioni elenca | configurazioni elimina <reame> <nome>"
XPERL_CANNOT_DELETE_CURRENT = "Impossibile cancellare la tua configurazione corrente"
XPERL_CONFIG_DELETED		= "Configurazione di %s/%s cancellata"
XPERL_CANNOT_FIND_DELETE_TARGET = "Impossibile trovare configurazione da cancellare (%s/%s)"
XPERL_CANNOT_DELETE_BADARGS = "Prego scrivi il del reame e quello del personaggio"
XPERL_CONFIG_LIST		= "Elenco configurazioni:"
XPERL_CONFIG_CURRENT		= " (In uso)"

XPERL_RAID_TOOLTIP_WITHBUFF	= "Con buff: (%s)"
XPERL_RAID_TOOLTIP_WITHOUTBUFF	= "Senza buff: (%s)"
XPERL_RAID_TOOLTIP_BUFFEXPIRING	= "%s ha usato %s che finisce in %s"	-- Name, buff name, time to expire


local isMOP = select(4, _G.GetBuildInfo()) >= 50000
 

if (not isMOP) then
-- Status highlight spells
XPERL_HIGHLIGHT_SPELLS = {
	hotSpells  = {
		[GetSpellInfo(774)] = 12,			-- Rejuvenation (old id 26982)
		[GetSpellInfo(8936)] = 6,			-- Regrowth (old id 26980)
		[GetSpellInfo(139)] = 12,			-- Renew (old id 25222)
	    [GetSpellInfo(48438)] = 7,			-- Wild Growth 
		[GetSpellInfo(33763)] = 8,			-- Lifebloom
		[GetSpellInfo(28880)] = 15,			-- Gift of the Naaru (Racial)
		[GetSpellInfo(61295)] = 15,			-- Riptide
	},
	pomSpells = {
		[GetSpellInfo(33076)] = 30			-- Prayer of Mending
	},
	shieldSpells = {
		[GetSpellInfo(17)] = 30,			-- Power Word: Shield
		[GetSpellInfo(76669)] = 6,			-- Illuminated Healing
		[GetSpellInfo(974)] = 600			-- Earth Shield	(old id 32594)
	},
	healSpells = {
		[GetSpellInfo(2061)] = 1.5,			-- Flash of Light (old id 25235)
		[GetSpellInfo(2060)] = 3,			-- Greater Heal (old id 25213)
		[GetSpellInfo(2050)] = 3,			-- Heal (old id 6064)
		[GetSpellInfo(5185)] = 3,			-- Healing Touch (old id 26979)
		[GetSpellInfo(8936)] = 1.5,			-- Regrowth (old id 26980)
		[GetSpellInfo(331)] = 3,			-- Healing Wave (old id 25396)
		[GetSpellInfo(8004)] = 1.5,			-- Lesser Healing Wave (old id 25420)
		[GetSpellInfo(19750)] = 1.5,		-- Flash Heal (old id 27137)
		[GetSpellInfo(635)] = 2.5,			-- Holy Light (old id 27136)
		[GetSpellInfo(50464)] = 3.0			-- Nourish
	},
	buffSpells = {
		PRIEST = {
			[GetSpellInfo(21532)] = true,	-- Power Word: Fortitude (old id 25389)
			[GetSpellInfo(39231)] = true	-- Prayer of Fortitude (old id 25392)
		},
	    DRUID = {
			[GetSpellInfo(1126)] = true		-- Mark of the Wild (old id 26990)
		},
	    MAGE = {
			[GetSpellInfo(1459)] = true		-- Arcane Intellect (old id 27126)
		},
	    PALADIN = {
			[GetSpellInfo(19740)] = true,	-- Blessing of Might
			[GetSpellInfo(20217)] = true	-- Blessing of Kings
		},
	},
	groupHealSpells = {
		[GetSpellInfo(596)] = 2.5,			-- Prayer of Healing (old id 25308)
		[GetSpellInfo(1064)] = 2.5,			-- Chain Heal
	},
}


-- Default spells for range checking in the healer visual out-of-range cues.
XPerl_DefaultRangeSpells = {
	DRUID	= {spell = GetSpellInfo(5185)},				-- Healing Touch
	PALADIN = {spell = GetSpellInfo(635)},				-- Holy Light
	PRIEST	= {spell = GetSpellInfo(2061)},				-- Flash Heal
	SHAMAN	= {spell = GetSpellInfo(331)},				-- Healing Wave
	MAGE	= {spell = GetSpellInfo(475)},				-- Remove Lesser Curse
	WARLOCK	= {spell = GetSpellInfo(5697)},				-- Underwater Breathing
	ANY		= {item = GetItemInfo(21991)}				-- Heavy Netherweave Bandage
}

-- Don't highlight these magical debuffs
XPerl_ArcaneExclusions = {
	[GetSpellInfo(63559)] = true,						-- Bind Life
	[GetSpellInfo(30451)] = true,						-- Arcane Blast (again) (old 42897)
	[GetSpellInfo(30108)] = true,						-- Unstable Affliction (old 30405)
	[GetSpellInfo(15822)] = true,						-- Dreamless Sleep
	[GetSpellInfo(24360)] = true,						-- Greater Dreamless Sleep
	[GetSpellInfo(28504)] = true,						-- Major Dreamless Sleep
	[GetSpellInfo(31257)] = true,						-- Chilled
	[GetSpellInfo(710)] = true,							-- Banish
	[GetSpellInfo(44836)] = true,						-- Also Banish !?
	[GetSpellInfo(24306)] = true,						-- Delusions of Jin'do
	[GetSpellInfo(46543)] = {ROGUE = true, WARRIOR = true},	-- Ignite Mana
	[GetSpellInfo(16567)] = {ROGUE = true, WARRIOR = true},	-- Tainted Mind
	[GetSpellInfo(39052)] = {ROGUE = true},				-- Sonic Burst
	[GetSpellInfo(41190)] = {ROGUE = true, WARRIOR = true}, -- Mind-numbing Poison
	[GetSpellInfo(25195)] = {ROGUE = true},				-- Curse of Tongues
	[GetSpellInfo(30129)] = true,						-- Charred Earth - Nightbane debuff, can't be cleansed, but shows as magic
	[GetSpellInfo(31651)] = {MAGE = true, WARLOCK = true, PRIEST = true},	-- Banshee Curse, Melee hit rating debuff
	[GetSpellInfo(38913)] = {ROGUE = true},				-- Silence
	[GetSpellInfo(31555)] = {ROGUE = true, WARRIOR = true}, -- Decayed Intellect
}
else

-- Status highlight spells
XPERL_HIGHLIGHT_SPELLS = {
	hotSpells  = {
		[GetSpellInfo(774)] = 12,			-- Rejuvenation (old id 26982)
		[GetSpellInfo(8936)] = 6,			-- Regrowth (old id 26980)
		[GetSpellInfo(139)] = 12,			-- Renew (old id 25222)
	    [GetSpellInfo(48438)] = 7,			-- Wild Growth 
		[GetSpellInfo(33763)] = 8,			-- Lifebloom
		[GetSpellInfo(28880)] = 15,			-- Gift of the Naaru (Racial)
		[GetSpellInfo(61295)] = 15,			-- Riptide
	},
	pomSpells = {
		[GetSpellInfo(33076)] = 30			-- Prayer of Mending
	},
	shieldSpells = {
		[GetSpellInfo(17)] = 30,			-- Power Word: Shield
		[GetSpellInfo(76669)] = 6,			-- Illuminated Healing
		[GetSpellInfo(974)] = 600			-- Earth Shield	(old id 32594)
	},
	healSpells = {
		[GetSpellInfo(2061)] = 1.5,			-- Flash of Light (old id 25235)
		[GetSpellInfo(2060)] = 3,			-- Greater Heal (old id 25213)
		[GetSpellInfo(2050)] = 3,			-- Heal (old id 6064)
		[GetSpellInfo(5185)] = 3,			-- Healing Touch (old id 26979)
		[GetSpellInfo(8936)] = 1.5,			-- Regrowth (old id 26980)
		[GetSpellInfo(331)] = 3,			-- Healing Wave (old id 25396)
		[GetSpellInfo(8004)] = 1.5,			-- Lesser Healing Wave (old id 25420)
		[GetSpellInfo(19750)] = 1.5,		-- Flash Heal (old id 27137)
		[GetSpellInfo(635)] = 2.5,			-- Holy Light (old id 27136)
		[GetSpellInfo(50464)] = 3.0			-- Nourish
	},
	buffSpells = {
		PRIEST = {
			[GetSpellInfo(21532)] = true	-- Power Word: Fortitude (old id 25389)
		},
	    DRUID = {
			[GetSpellInfo(1126)] = true		-- Mark of the Wild (old id 26990)
		},
	    MAGE = {
			[GetSpellInfo(1459)] = true		-- Arcane Intellect (old id 27126)
		},
	    PALADIN = {
			[GetSpellInfo(19740)] = true,	-- Blessing of Might
			[GetSpellInfo(20217)] = true	-- Blessing of Kings
		},
	},
	groupHealSpells = {
		[GetSpellInfo(596)] = 2.5,			-- Prayer of Healing (old id 25308)
		[GetSpellInfo(1064)] = 2.5,			-- Chain Heal
	},
}


-- Default spells for range checking in the healer visual out-of-range cues.
XPerl_DefaultRangeSpells = {
	DRUID	= {spell = GetSpellInfo(5185)},				-- Healing Touch
	PALADIN = {spell = GetSpellInfo(635)},				-- Holy Light
	PRIEST	= {spell = GetSpellInfo(2061)},				-- Flash Heal
	SHAMAN	= {spell = GetSpellInfo(331)},				-- Healing Wave
	MAGE	= {spell = GetSpellInfo(475)},				-- Remove Lesser Curse
	WARLOCK	= {spell = GetSpellInfo(5697)},				-- Underwater Breathing
	ANY		= {item = GetItemInfo(21991)}				-- Heavy Netherweave Bandage
}

-- Don't highlight these magical debuffs
XPerl_ArcaneExclusions = {
	[GetSpellInfo(63559)] = true,						-- Bind Life
	[GetSpellInfo(30451)] = true,						-- Arcane Blast (again) (old 42897)
	[GetSpellInfo(30108)] = true,						-- Unstable Affliction (old 30405)
	[GetSpellInfo(15822)] = true,						-- Dreamless Sleep
	[GetSpellInfo(24360)] = true,						-- Greater Dreamless Sleep
	[GetSpellInfo(28504)] = true,						-- Major Dreamless Sleep
	[GetSpellInfo(31257)] = true,						-- Chilled
	[GetSpellInfo(710)] = true,							-- Banish
	[GetSpellInfo(44836)] = true,						-- Also Banish !?
	[GetSpellInfo(24306)] = true,						-- Delusions of Jin'do
	[GetSpellInfo(46543)] = {ROGUE = true, WARRIOR = true},	-- Ignite Mana
	[GetSpellInfo(16567)] = {ROGUE = true, WARRIOR = true},	-- Tainted Mind
	[GetSpellInfo(39052)] = {ROGUE = true},				-- Sonic Burst
	[GetSpellInfo(41190)] = {ROGUE = true, WARRIOR = true}, -- Mind-numbing Poison
	[GetSpellInfo(25195)] = {ROGUE = true},				-- Curse of Tongues
	[GetSpellInfo(30129)] = true,						-- Charred Earth - Nightbane debuff, can't be cleansed, but shows as magic
	[GetSpellInfo(31651)] = {MAGE = true, WARLOCK = true, PRIEST = true},	-- Banshee Curse, Melee hit rating debuff
	[GetSpellInfo(38913)] = {ROGUE = true},				-- Silence
	[GetSpellInfo(31555)] = {ROGUE = true, WARRIOR = true}, -- Decayed Intellect
}

end
end