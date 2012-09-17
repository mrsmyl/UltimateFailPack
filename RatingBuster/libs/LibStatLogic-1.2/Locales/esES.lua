-- esES localization by Kaie Estirpe de las Sombras from Minahonda

--These constants need to be built outside the table before they can be referenced
local LOCALE_STHOUSAND = ".";  --Character used to separate groups of digits
local LOCALE_SDECIMAL = ","; --Character(s) used for the decimal separator
local patNumber = "%d+["..LOCALE_STHOUSAND.."%d]*"; --regular expression to find a localized number e.g. "1,234"  = %d+[,%d]*
local patDecimal = "%d+["..LOCALE_STHOUSAND.."%d]*"..LOCALE_SDECIMAL.."?%d*"; --regex to find a localized decimal number e.g. "1,234.56" = %d+[,%d]*.?%d*


PatternLocale.esES = { -- {{{
	LOCALE_STHOUSAND = LOCALE_STHOUSAND, --Character used to separate groups of digits
	LOCALE_SDECIMAL = LOCALE_SDECIMAL, --Character(s) used for the decimal separator
	
	patNumber = patNumber, --regular expression to find a localized number e.g. "1,234"  = %d+[,%d]*
	patDecimal = patDecimal, --regex to find a localized decimal number e.g. "1,234.56" = %d+[,%d]*.?%d*

	-----------------
	-- Armor Types --
	-----------------
	Plate = "Placas",
	Mail = "Mallas",
	Leather = "Cuero",
	Cloth = "Tela",
	------------------
	-- Fast Exclude --
	------------------
	-- Note to localizers: This is important for reducing lag on mouse over.
	-- Turn on /sldebug and see if there are any "No Match" strings, any 
	-- unused strings should be added in the "Exclude" table, because an unmatched 
	-- string costs a lot of CPU time, and should be prevented whenever possible.
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	-- ExcludeLen Mirando a las primeras letras de una linea podemos excluir un monton de lineas
	["ExcludeLen"] = 5, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item will be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_BIND_TO_ACCOUNT] = true, -- ITEM_BIND_QUEST = "Binds to account";
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "Meta Socket";
		--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "Red Socket";
		--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever

		--["Desen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		--["Durac"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		["Tiemp"] = true, -- temps de recharge…
		["<Hecho"] = true, -- artisan
		["Único"] = true, -- Unique (20)
		["Nivel"] = true, -- Niveau
		["\nNive"] = true, -- Niveau
		["Clase"] = true, -- Classes: xx
		["Razas"] = true, -- Races: xx (vendor mounts)
		["Uso: "] = true, -- Utiliser:
		["Posib"] = true, -- Chance de toucher:
		["Requi"] = true, -- Requiert
		["\nRequ"] = true,-- Requiert
		["Neces"] = true,--nécessite plus de gemmes...
		-- Set Bonuses
		-- ITEM_SET_BONUS = "Set: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["Bonif"] = true,--ensemble
		["(2) B"] = true,
		["(3) B"] = true,
		["(4) B"] = true,
		["(5) B"] = true,
		["(6) B"] = true,
		["(7) B"] = true,
		["(8) B"] = true,
		-- Equip type
		["Proye"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
		--4.0.6
		[REFORGED] = true,
		[ITEM_HEROIC] = true,
		[ITEM_HEROIC_EPIC] = true,
		[ITEM_HEROIC_QUALITY0_DESC] = true,
		[ITEM_HEROIC_QUALITY1_DESC] = true,
		[ITEM_HEROIC_QUALITY2_DESC] = true,
		[ITEM_HEROIC_QUALITY3_DESC] = true,
		[ITEM_HEROIC_QUALITY4_DESC] = true,
		[ITEM_HEROIC_QUALITY5_DESC] = true,
		[ITEM_HEROIC_QUALITY6_DESC] = true,
		[ITEM_HEROIC_QUALITY7_DESC] = true,
		[ITEM_QUALITY0_DESC] = true,
		[ITEM_QUALITY1_DESC] = true,
		[ITEM_QUALITY2_DESC] = true,
		[ITEM_QUALITY3_DESC] = true,
		[ITEM_QUALITY4_DESC] = true,
		[ITEM_QUALITY5_DESC] = true,
		[ITEM_QUALITY6_DESC] = true,
		[ITEM_QUALITY7_DESC] = true,
	},

	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Usado principalmente para encantamientos que no tienen numeros en el texto
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

		--ToDo
		["Aceite de zahorí menor"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
		["Aceite de zahorí inferior"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
		["Aceite de zahorí"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
		["Aceite de zahorí luminoso"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
		["Aceite de zahorí excelente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
		["Aceite de zahorí bendito"] = {["SPELL_DMG_UNDEAD"] = 60}, --
		["Windwalk"] = false, --ID: 74244  Windwalk: Permanently enchant a weapon to sometimes increase dodge rating by 600 and movement speed by 15% for 10 sec
		["Flintlocke's Woodchucker"] = false, --ItemID: 70139  Flintlocke's Woodchucker

		["Aceite de maná menor"] = {["COMBAT_MANA_REGEN"] = 4}, --
		["Aceite de maná inferior"] = {["COMBAT_MANA_REGEN"] = 8}, --
		["Aceite de maná luminoso"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --
		["Aceite de maná excelente"] = {["COMBAT_MANA_REGEN"] = 14}, --

		["Sedal de eternio"] = {["FISHING"] = 5}, --
		["Fuego solar"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --
    ["Velocidad de la montura"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
    ["Pies de plomo"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

    ["Sutileza"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    -- ["2% Reduced Threat"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["Equipar: Permite respirar bajo el agua"] = false, -- [Band of Icy Depths] ID: 21526
    ["Permite respirar bajo el agua"] = false, --
    ["Equipar: Duración de Desarmar reducida"] = false, -- [Stronghold Gauntlets] ID: 12639
    ["Immune a desarmar"] = false, --
    ["Robo de vida"] = false, -- Enchant Crusader

    --translated
    ["Espuelas de mitril"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
    ["Equipar: Velocidad de carrera aumentada ligeramente"] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048"
    ["Aumenta ligeramente la velocidad de movimiento"] = {["RUN_SPEED"] = 8}, --
    ["Aumenta ligeramente la velocidad de movimiento"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
    ["Vitalidad"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
    ["Escarcha de alma"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["Salvajismo"] = {["AP"] = 70}, --
    ["Velocidad menor"] = {["RUN_SPEED"] = 8},
    -- ["Vitesse mineure et +9 en Endurance"] = {["RUN_SPEED"] = 8, ["STA"] = 9},--enchant

    ["Cruzado"] = false, -- Enchant Crusader
    ["Mangosta"] = false, -- Enchant Mangouste
    ["Arma impia"] = false,
    -- ["Équipé : Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, --cape Onyxia
	},

	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(patNumber) (.-)%.?$"
	-- Stamina +19 = "^(.-) %+(patNumber)%.?$"
	-- +19 耐力 = "^%+(patNumber) (.-)%.?$"
	-- Some have a "." at the end of string like:
	-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
	["SinglePlusStatCheck"] = "^([%+%-]"..patNumber..") (.-)%.?$",

	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
  ["SingleEquipStatCheck"] = "^Equipar: (.-) h?a?s?t?a? ?(%d+)(.-)?%.$",

	-------------
	-- PreScan --
	-------------
	-- Its preferable to have as few "PreScanPatterns" as possible, only use this table if all other methods fail.
	-- Special cases that need to be dealt with before deep scan
	["PreScanPatterns"] = {
		["^(%d+) armadura$"] = "ARMOR",
		["^Equipar: Restaura (%d+) p. de salud cada 5 s"]= "COMBAT_HEALTH_REGEN",
		["^Equipar: Restaura (%d+) p. de maná cada 5 s"]= "COMBAT_MANA_REGEN",
		["^Equipar: Aumenta (%d+) p. el poder de ataque"]= "AP",
		-- ["^Equipar: Mejora tu índice de golpe crítico (%d+) p"]= "MELEE_CRIT_RATING",
		["Refuerza %(%+(%d+) Armadura%)"]= "ARMOR_BONUS",
		-- ["Lunette %(%+(%d+) points? de dégâts?%)"]="RANGED_AP",
		["^%+?"..patNumber.." %- (%d+) .-Daño$"] = "MAX_DAMAGE",
		["^%(("..patDecimal..") daño por segundo%)$"] = "DPS",

		-- Exclude
		["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		--["Confère une chance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["A veces ganas"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["Ganas una Carga"] = false, -- El condensador de rayos ID:28785
		["Daño:"] = false, -- ligne de degats des armes
		["Tu técnica"] = false,
		["^%+?%d+ %- %d+ puntos de daño %(.-%)$"]= false, -- ligne de degats des baguettes/ +degats (Thunderfury)
		-- ["Permettent au porteur"] = false, -- Casques Ombrelunes
		-- ["^.- %(%d+%) requis"] = false, --metier requis pour porter ou utiliser
		-- ["^.- ?[Vv]?o?u?s? [Cc]onfèren?t? .-"] = false, --proc
		-- ["^.- ?l?e?s? ?[Cc]hances .-"] = false, --proc
		-- ["^.- par votre sort .-"] = false, --augmentation de capacité de sort
		-- ["^.- la portée de .-"] = false, --augmentation de capacité de sort
		-- ["^.- la durée de .-"] = false, --augmentation de capacité de sort
	},

	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "Equipar: ", --\194\160= espacio requerido
	["Socket Bonus: "] = "Bonus ranura: ",
	-- Strip trailing "."
	["."] = ".",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" y " , -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", " , -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"[^p]%." , -- cuando es p y punto no separa
	},
	["DeepScanWordSeparators"] = {
		" y ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
	},
	["DualStatPatterns"] = { -- all lower case
		["la salud %+(%d+) y el daño %+ (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["la salud %+(%d+) el dano %+ (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
		["salud un máximo de (%d+) y el dano un máximo de (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-) ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
		-- "^(.-)5 [Ss]ek%. (%d+) (.-)$",  -- "xxx 5 Sek. 8 xxx" (scan 2nd)
		"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 3rd)
		"^(.-) ?([%d%,]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["Mira de korio"] = {"RANGED_DMG"}, -- Khorium Scope EnchantID: 2723
		["Scope (Critical Strike Rating)"] = {"RANGED_CRIT_RATING"}, -- Stabilized Eternium Scope EnchantID: 2724
		["Your attacks ignoreof your opponent's armor"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
		["% Threat"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
		["Aumenta tu nivel efectivo de sigilo enp"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		-- ["Velocidad de carrera"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048


		--dano melee
		["daño de arma"] = {"MELEE_DMG"},
		["daño del arma"] = {"MELEE_DMG"},
		["daño en melee"] = {"MELEE_DMG"},
		["daño de melee"] = {"MELEE_DMG"},


		--caracteristicas
		["todas las estadísticas"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["Fuerza"] = {"STR",},
		["Agilidad"] = {"AGI",},
		["Aguante"] = {"STA",},
		["Intelecto"] = {"INT",},
		["Espíritu"] = {"SPI",},


		--resistencias
		["resistencia arcana"] = {"ARCANE_RES",},
		["resistencia a Arcano"] = {"ARCANE_RES",},

		["resistencia al fuego"] = {"FIRE_RES",},
		["resistencia al Fuego"] = {"FIRE_RES",},

		["resistencia a la naturaleza"] = {"NATURE_RES",},
		["resistencia a Naturaleza"] = {"NATURE_RES",},

		["resistencia a la Escarcha"] = {"FROST_RES",},
		["resistencia a Escarcha"] = {"FROST_RES",},

		["resistencia a Sombras"] = {"SHADOW_RES",},
		["resistencia a las sombras"] = {"SHADOW_RES",},

		["a todas las resistencias"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

		--artesano
		["pesca"] = {"FISHING",},
		["mineria"] = {"MINING",},
		["herboristeria"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["desollar"] = {"SKINNING",}, -- Skinning enchant ID:865

		--
		["armadura"] = {"ARMOR_BONUS",},

		["defensa"] = {"DEFENSE",},

		["salud"] = {"HEALTH",},
		["puntos de vida"] = {"HEALTH",},
		["puntos de maná"] = {"MANA",},

		["aumenta el poder de ataquep"] = {"AP",},
		["al poder de ataque"] = {"AP",},
		["poder de ataque"] = {"AP",},
		["aumentap. el poder ataque"] = {"AP",}, -- id:38045



		--ToDo
		["Aumenta el poder de ataque contra muertos vivientes"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
		--["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
		--["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},


		--ranged AP
		["el poder de ataque a distancia"] = {"RANGED_AP",},
		--Feral
		["el poder de ataque para la formas felina, de oso"] = {"FERAL_AP",},

		--regenerar
		["maná cada 5 segundos"] = {"COMBAT_MANA_REGEN",},
		["maná cada 5 s"] = {"COMBAT_MANA_REGEN",},
		["puntos de vida cada 5 segundos"] = {"COMBAT_HEALTH_REGEN",},
		["puntos de salud cada 5 segundos"] = {"COMBAT_HEALTH_REGEN",},
		["points de mana toutes les 5 sec"] = {"COMBAT_MANA_REGEN",},
		["points de vie toutes les 5 sec"] = {"COMBAT_HEALTH_REGEN",},
		["p. de maná cada 5 s."] = {"COMBAT_MANA_REGEN",},
		["p. de salud cada 5 s."] = {"COMBAT_HEALTH_REGEN",},
		["regeneración de maná"] = {"COMBAT_MANA_REGEN",},


		--penetración de hechizos
		["aumenta el índice de penetración de tus hechizosp"] = {"SPELLPEN",},
		["penetración del hechizo"] = {"SPELLPEN",},
		["aumenta el índice de penetración de armadurap"] = {"SPELLPEN",},

		--Puissance soins et sorts
		["poder con hechizos"] = {"SPELL_DMG", "HEAL"},
		["el poder con hechizos"] = {"SPELL_DMG", "HEAL"},
		["Aumenta el poder con hechizosp"] = {"SPELL_DMG", "HEAL"},


		--ToDo
		["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques d'un maximum de"] = {"SPELL_DMG_UNDEAD"},

		["el daño inflingido por los hechizos de sombras"]={"SHADOW_SPELL_DMG",},
		["el daño de hechizo de sombras"]={"SHADOW_SPELL_DMG",},
		["el daño de sombras"]={"SHADOW_SPELL_DMG",},

		["el daño inflingido por los hechizos de escarcha"]={"FROST_SPELL_DMG",},
		["el daño de hechizos de escarcha"]={"FROST_SPELL_DMG",},
		["el daño de escarcha"]={"FROST_SPELL_DMG",},

		["el daño inflingido por los hechizos de fuego"]={"FIRE_SPELL_DMG",},
		["el daño de hechizos de fuego"]={"FIRE_SPELL_DMG",},
		["el daño de fuego"]={"FIRE_SPELL_DMG",},

		["el daño inflingido por los hechizos de naturaleza"]={"NATURE_SPELL_DMG",},
		["el daño de hechizos de naturaleza"]={"NATURE_SPELL_DMG",},
		["el daño de naturaleza"]={"NATURE_SPELL_DMG",},

		["el daño inflingido por los hechizos arcanos"]={"ARCANE_SPELL_DMG",},
		["el daño de hechizos arcanos"]={"ARCANE_SPELL_DMG",},
		["el daño arcano"]={"ARCANE_SPELL_DMG",},

		["el daño inflingido por los hechizos de sagrado"]={"HOLY_SPELL_DMG",},
		["el daño de hechizos sagrado"]={"HOLY_SPELL_DMG",},
		["el daño de sagrado"]={"HOLY_SPELL_DMG",},

		--ToDo
		--["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
		--["Increases Healing"] = {"HEAL",},
		--["Healing"] = {"HEAL",},
		--["healing Spells"] = {"HEAL",},
		--["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
		--["Increases healing done by spells and effects"] = {"HEAL",},
		--["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
		--["your healing"] = {"HEAL",}, -- Atiesh

		["da/195/177o por segundo"] = {"DPS",},
		--["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

		["índice de defensa"] = {"DEFENSE_RATING",},
		["aumenta tu índice de defensap"] = {"DEFENSE_RATING",},
		["tu índice de defensa"] = {"DEFENSE_RATING",},

		["índice de esquivar"] = {"DODGE_RATING",},
		["aumenta tu índice de esquivarp"] = {"DODGE_RATING",},
		["tu índice de esquivar"] = {"DODGE_RATING",},

		["índice de parada"] = {"PARRY_RATING",},
		["tu índice de parada"] = {"PARRY_RATING",},
		["Aumenta tu índice de paradap"] = {"PARRY_RATING",},
		["Aumenta el índice de parada"] = {"PARRY_RATING",},

		["índice de bloqueo"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
		["aumenta el índice de bloqueo"] = {"BLOCK_RATING",},
		["tu índice de bloqueo"] = {"BLOCK_RATING",},

		["mejora tu índice de golpep"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
		["índice de golpe"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
		["tu índice de golpep"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},

		["mejora tu índice de golpe críticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
		["índice de criticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
		["tu índice de golpe críticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},

		["índice de temple"] = {"RESILIENCE_RATING",},
		["Mejora tu índice de templep"] = {"RESILIENCE_RATING",},
		["tu índice de temple"] = {"RESILIENCE_RATING",},
		["al temple"] = {"RESILIENCE_RATING",},

		["tu índice de golpe con hechizos"] = {"SPELL_HIT_RATING",},
		["índice de golpe de hechizos"] = {"SPELL_HIT_RATING",},
		["tu indice de golpe con hechizos"] = {"SPELL_HIT_RATING",},

		["el indice de golpe critico de hechizo"] = {"SPELL_CRIT_RATING",},
		["indice de golpe critico de los hechizos"] = {"SPELL_CRIT_RATING",},
		["indice de critico con hechizos"] = {"SPELL_CRIT_RATING",},

		--ToDo
		--["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
		--["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		--["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},
		--["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

		["índice de celeridad"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
		["mejora tu índice de celeridadp"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING",},
		["Mejora tu índice de celeridad"] = {"SPELL_HASTE_RATING"},
		["Mejora el índice de celeriad"] = {"RANGED_HASTE_RATING"},
		--["Improves haste rating"] = {"MELEE_HASTE_RATING"},
		--["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
		--["Improves ranged haste rating"] = {"SPELL_HASTE_RATING"},
		--["Improves spell haste rating"] = {"RANGED_HASTE_RATING"},

		["tu índice de pericia"] = {"EXPERTISE_RATING"},
		["el índice de pericia"] = {"EXPERTISE_RATING"},

		["índice de penetración de armadura"] = {"ARMOR_PENETRATION_RATING"}, -- gems
		-- ["Increases your expertise rating"] = {"EXPERTISE_RATING"},
		-- ["Increases armor penetration rating"] = {"ARMOR_PENETRATION_RATING"},
		["Aumenta tu índice de penetración de armadurap"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178

		-- no traducidos no se si se utilizan actualmente
		["le score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
		["score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
		["le score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
		["score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
		["le score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
		["score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
		["le score de la compétence masses"]= {"MACE_WEAPON_RATING"},
		["score de la compétence masses"]= {"MACE_WEAPON_RATING"},
		["le score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
		["score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
		["le score de la compétence haches"] = {"AXE_WEAPON_RATING"},
		["score de la compétence haches"] = {"AXE_WEAPON_RATING"},
		["le score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},
		["score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},

		["le score de la compétence armes de pugilat"] = {"FIST_WEAPON_RATING"},
		["le score de compétence combat farouche"] = {"FERAL_WEAPON_RATING"},
		["le score de la compétence mains nues"] = {"FIST_WEAPON_RATING"},

		--ToDo
		--["Increases gun skill rating"] = {"GUN_WEAPON_RATING"},

		--["Increases Crossbow skill rating"] = {"CROSSBOW_WEAPON_RATING"},
		--["Increases Bow skill rating"] = {"BOW_WEAPON_RATING"},

		--ToDo
		-- Exclude
		--["sec"] = false,
		--["to"] = false,
		["Bolsa"] = false,
		--["Slot Quiver"] = false,
		--["Slot Ammo Pouch"] = false,
		--["Increases ranged attack speed"] = false, -- AV quiver
	},
} -- }}}

DisplayLocale.esES = { -- {{{
  --ToDo
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["Stat Multiplier"] = "Stat Multiplier",
	["Attack Power Multiplier"] = "Attack Power Multiplier",
	["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
	["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
	["5% Spell Haste"] = "5% Spell Haste",
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";

		["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
		["STEALTH_LEVEL"] = {"Stealth Level", "Stealth"},
		["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
		["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
		["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

		["STR"] = {SPELL_STAT1_NAME, "Str"},
		["AGI"] = {SPELL_STAT2_NAME, "Agi"},
		["STA"] = {SPELL_STAT3_NAME, "Sta"},
		["INT"] = {SPELL_STAT4_NAME, "Int"},
		["SPI"] = {SPELL_STAT5_NAME, "Spi"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
		["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

		["FISHING"] = {"Fishing", "Fishing"},
		["MINING"] = {"Mining", "Mining"},
		["HERBALISM"] = {"Herbalism", "Herbalism"},
		["SKINNING"] = {"Skinning", "Skinning"},

		["BLOCK_VALUE"] = {"Bloqueo", "Block Value"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
		["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
		["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Undead)", "AP(Undead)"},
		["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Demon)", "AP(Demon)"},

		["HEAL"] = {"Sanacion", "Heal"},

		["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
		["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
		["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Undead)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
		["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Demon)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
		["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
		["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
		["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
		["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
		["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
		["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

		["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["COMBAT_HEALTH_REGEN"] = {HEALTH.." Regen", "HP5"},
		["COMBAT_MANA_REGEN"] = {MANA.." Regen", "MP5"},

		["MAX_DAMAGE"] = {"Max Daño", "Max Dmg"},
		["DPS"] = {"Daño por segundo", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"Hit Avoidance "..RATING, "Hit Avoidance "..RATING},
		["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING},
		["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
		["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
		["MELEE_CRIT_AVOID_RATING"] = {"Crit Avoidance "..RATING, "Crit Avoidance "..RATING},
		["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING},
		["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"Haste "..RATING, "Haste "..RATING}, --
		["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
		["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
		["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
		["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
		["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
		["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
		["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
		["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
		["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
		["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
		["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
		["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
		["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},
		["EXPERTISE_RATING"] = {"Expertise".." "..RATING, "Expertise".." "..RATING},
		["ARMOR_PENETRATION_RATING"] = {"Armor Penetration".." "..RATING, "ArP".." "..RATING},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REGEN"] = {HEALTH.." Regen (Out of combat)", "HP5(OC)"},
		["MANA_REGEN"] = {MANA.." Regen (Out of casting)", "MP5(OC)"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction(%)", "Crit Dmg Reduc(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
		["DEFENSE"] = {DEFENSE, "Def"},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["MELEE_HIT"] = {"Prob. Golpe(%)", "Hit(%)"},
		["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
		["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
		["MELEE_HIT_AVOID"] = {"Hit Avoidance(%)", "Hit Avd(%)"},
		["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit Avd(%)"},
		["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit Avd(%)"},
		["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
		["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
		["MELEE_CRIT_AVOID"] = {"Crit Avoidance(%)", "Crit Avd(%)"},
		["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Avd(%)"},
		["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Avd(%)"},
		["MELEE_HASTE"] = {"Celeridad(%)", "Haste(%)"}, --
		["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Celeridad(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
		["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Celeridad(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
		["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
		["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
		["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
		["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
		["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
		["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
		["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
		["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
		["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
		["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
		["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},
		["EXPERTISE"] = {"Pericia", "Expertise"},
		["ARMOR_PENETRATION"] = {"Penetr. Armadura(%)", "ArP(%)"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
		["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
		["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

		---------------------------------------------------------------------------
		-- Talents
		["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
		["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
		["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"Threat", "Threat"},
		["CAST_TIME"] = {"Casting Time", "Cast Time"},
		["MANA_COST"] = {"Mana Cost", "Mana Cost"},
		["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
		["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
		["COOLDOWN"] = {"Cooldown", "CD"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
		["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
		["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
		["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
		["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
		["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
		["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
		["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
		["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
		["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
		["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
		["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
		["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
		["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
		["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
		["MOD_SPELL_PWR"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
		["MOD_HEAL"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
		["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
		["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
		["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
		["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
		["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
		["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
		["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
		["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
		["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
	},
} -- }}}
