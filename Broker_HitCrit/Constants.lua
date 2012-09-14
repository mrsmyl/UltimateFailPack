-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

-------------------------------------------------------------------------------
-- General constants.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Spell school data.
-------------------------------------------------------------------------------
private.SPELL_SCHOOLS = {
	-- Primary Schools
	[1]	= _G.STRING_SCHOOL_PHYSICAL,		-- 0x01
	[2]	= _G.STRING_SCHOOL_HOLY,		-- 0x02
	[4]	= _G.STRING_SCHOOL_FIRE,		-- 0x04
	[8]	= _G.STRING_SCHOOL_NATURE,		-- 0x08
	[16]	= _G.STRING_SCHOOL_FROST,		-- 0x10
	[32]	= _G.STRING_SCHOOL_SHADOW,		-- 0x20
	[64]	= _G.STRING_SCHOOL_ARCANE,		-- 0x40
	-- Double Schools
	[3]	= _G.STRING_SCHOOL_HOLYSTRIKE,		-- 0x3	        Holy + Physical
	[5]	= _G.STRING_SCHOOL_FLAMESTRIKE,		-- 0x5		Fire + Physical
	[6]	= _G.STRING_SCHOOL_HOLYFIRE,		-- 0x6		Fire + Holy
	[9]	= _G.STRING_SCHOOL_STORMSTRIKE,		-- 0x9		Nature + Physical
	[10]	= _G.STRING_SCHOOL_HOLYSTORM,		-- 0xA		Nature + Holy
	[12]	= _G.STRING_SCHOOL_FIRESTORM,		-- 0xC		Nature + Fire
	[17]	= _G.STRING_SCHOOL_FROSTSTRIKE,		-- 0x11		Frost + Physical
	[18]	= _G.STRING_SCHOOL_HOLYFROST,		-- 0x12		Frost + Holy
	[20]	= _G.STRING_SCHOOL_FROSTFIRE,		-- 0x14		Frost + Fire
	[24]	= _G.STRING_SCHOOL_FROSTSTORM,		-- 0x18		Frost + Nature
	[33]	= _G.STRING_SCHOOL_SHADOWSTRIKE,	-- 0x21		Shadow + Physical
	[34]	= _G.STRING_SCHOOL_SHADOWLIGHT,		-- 0x22		Shadow + Holy (Twilight)
	[36]	= _G.STRING_SCHOOL_SHADOWFLAME,		-- 0x24		Shadow + Fire
	[40]	= _G.STRING_SCHOOL_SHADOWSTORM,		-- 0x28		Shadow + Nature (Plague)
	[48]	= _G.STRING_SCHOOL_SHADOWFROST,		-- 0x30		Shadow + Frost
	[65]	= _G.STRING_SCHOOL_SPELLSTRIKE,		-- 0x41		Arcane + Physical
	[66]	= _G.STRING_SCHOOL_DIVINE,		-- 0x42		Arcane + Holy
	[68]	= _G.STRING_SCHOOL_SPELLFIRE,		-- 0x44		Arcane + Fire
	[72]	= _G.STRING_SCHOOL_SPELLSTORM,		-- 0x48		Arcane + Nature
	[80]	= _G.STRING_SCHOOL_SPELLFROST,		-- 0x50		Arcane + Frost
	[96]	= _G.STRING_SCHOOL_SPELLSHADOW,		-- 0x60		Arcane + Shadow
	-- Triple and multi schools
	[28]	= _G.STRING_SCHOOL_ELEMENTAL,		-- 0x1C		Frost + Nature + Fire
	[124]	= _G.STRING_SCHOOL_CHROMATIC,		-- 0x7C		Arcane + Shadow + Frost + Nature + Fire
	[126]	= _G.STRING_SCHOOL_MAGIC,		-- 0x7E		Arcane + Shadow + Frost + Nature + Fire + Holy
	[127]	= _G.STRING_SCHOOL_CHAOS,		-- 0x7F		Arcane + Shadow + Frost + Nature + Fire + Holy + Physical
}
