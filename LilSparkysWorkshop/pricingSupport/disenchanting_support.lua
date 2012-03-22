


-- disenchanting support


local enabled = true

local ArmorID = "Armor"
local WeaponID = "Weapon"

do
	local reagentID = {
		["[Arcane Dust]"]= 22445,
		["[Dream Dust]"]= 11176,
		["[Soul Dust]"] = 11083,
		["[Strange Dust]"] = 10940,
		["[Vision Dust]"] = 11137,
		["[Illusion Dust]"] = 16204,
		["[Infinite Dust]"] = 34054,

		["[Dream Shard]"] = 34052,
		["[Greater Astral Essence]"] = 11082,
		["[Greater Cosmic Essence]"] = 34055,
		["[Greater Eternal Essence]"] = 16203,
		["[Greater Magic Essence]"] = 10939,
		["[Greater Mystic Essence]"] = 11135,
		["[Greater Nether Essence]"] = 11175,
		["[Greater Planar Essence]"] = 22446,

		["[Large Brilliant Shard]"] = 14344,
		["[Large Glimmering Shard]"]  = 11084,
		["[Large Glowing Shard]"]  = 11139,
		["[Large Prismatic Shard]"]  = 22449,
		["[Large Radiant Shard]"]  = 11178,
		["[Lesser Astral Essence]"] = 10998,
		["[Lesser Cosmic Essence]"] = 34056,
		["[Lesser Eternal Essence]"] = 16202,
		["[Lesser Magic Essence]"]= 10938,
		["[Lesser Mystic Essence]"] = 11134,
		["[Lesser Nether Essence]"] = 11174,
		["[Lesser Planar Essence]"] = 22447,

		["[Small Brilliant Shard]"]  = 14343,
		["[Small Dream Shard]"] = 34053,
		["[Small Glimmering Shard]"] = 10978,
		["[Small Glowing Shard]"] = 11138,
		["[Small Prismatic Shard]"] = 22448,
		["[Small Radiant Shard]"] = 11177,

		["[Nexus Crystal]"] = 20725,
		["[Abyss Crystal]"] = 34057,
		["[Void Crystal]"] = 22450,

		["[Lesser Celestial Essence]"] = 52718,
		["[Small Heavenly Shard]"] = 52720,
		["[Heavenly Shard]"] = 52721,
		["[Maelstrom Crystal]"] = 52722,
		["[Hypnotic Dust]"] = 52555,
	}


	local reagentSourceTable = {
		["Armor"] = {
			[5] = "[Strange Dust]		80%		1-2x	[Lesser Magic Essence]		20%		1-2x	[NIL]						0%",
			[16] = "[Strange Dust] 		75% 	2-3x 	[Greater Magic Essence] 	20% 	1-2x 	[Small Glimmering Shard] 	5%",
			[21] = "[Strange Dust] 		75% 	4-6x 	[Lesser Astral Essence] 	15% 	1-2x 	[Small Glimmering Shard] 	10%",
			[26] = "[Soul Dust] 		75% 	1-2x 	[Greater Astral Essence] 	20% 	1-2x 	[Large Glimmering Shard] 	5%",
			[31] = "[Soul Dust] 		75% 	2-5x 	[Lesser Mystic Essence] 	20% 	1-2x 	[Small Glowing Shard] 		5%",
			[36] = "[Vision Dust] 		75% 	1-2x 	[Greater Mystic Essence] 	20% 	1-2x 	[Large Glowing Shard] 		5%",
			[41] = "[Vision Dust] 		75% 	2-5x 	[Lesser Nether Essence] 	20% 	1-2x 	[Small Radiant Shard] 		5%",
			[46] = "[Dream Dust] 		75% 	1-2x 	[Greater Nether Essence] 	20% 	1-2x 	[Large Radiant Shard] 		5%",
			[51] = "[Dream Dust] 		75% 	2-5x 	[Lesser Eternal Essence] 	20% 	1-2x 	[Small Brilliant Shard] 	5%",
			[56] = "[Illusion Dust] 	75% 	1-2x 	[Greater Eternal Essence] 	20% 	1-2x 	[Large Brilliant Shard] 	5%",
			[61] = "[Illusion Dust] 	75% 	2-5x 	[Greater Eternal Essence] 	20% 	2-3x 	[Large Brilliant Shard] 	5%",
			[66] = "[Arcane Dust] 		75% 	1-3x 	[Lesser Planar Essence] 	22% 	1-3x 	[Small Prismatic Shard] 	3%",
			[81] = "[Arcane Dust] 		75% 	2-3x 	[Lesser Planar Essence] 	22% 	2-3x 	[Small Prismatic Shard] 	3%",
			[100] = "[Arcane Dust] 		75% 	2-5x 	[Greater Planar Essence] 	22% 	1-2x 	[Large Prismatic Shard] 	3%",
			[121] = "[Infinite Dust] 	75% 	1-2x 	[Lesser Cosmic Essence] 	22% 	1-2x 	[Small Dream Shard] 		3%",
			[152] = "[Infinite Dust] 	75% 	2-5x 	[Greater Cosmic Essence] 	22% 	1-2x 	[Dream Shard] 				3%",
			[272] = "[Hypnotic Dust] 	75% 	1-3x 	[Lesser Celestial Essence] 	25% 	1-3x	[NIL]						0%",
		},
		["Weapon"] = {
			[6] =	"[Strange Dust] 	20% 	1-2x 	[Lesser Magic Essence] 		80% 	1-2x	[NIL]						0%",
			[16] = 	"[Strange Dust] 	20% 	2-3x 	[Greater Magic Essence] 	75% 	1-2x 	[Small Glimmering Shard] 	5%",
			[21] =	"[Strange Dust] 	15% 	4-6x 	[Lesser Astral Essence] 	75% 	1-2x 	[Small Glimmering Shard] 	10%",
			[26] =	"[Soul Dust] 		20% 	1-2x 	[Greater Astral Essence] 	75% 	1-2x 	[Large Glimmering Shard] 	5%",
			[31] =	"[Soul Dust] 		20% 	2-5x 	[Lesser Mystic Essence] 	75% 	1-2x 	[Small Glowing Shard] 		5%",
			[36] =	"[Vision Dust] 		20% 	1-2x 	[Greater Mystic Essence] 	75% 	1-2x 	[Large Glowing Shard] 		5%",
			[41] =	"[Vision Dust]		20% 	2-5x 	[Lesser Nether Essence] 	75% 	1-2x 	[Small Radiant Shard] 		5%",
			[46] =	"[Dream Dust]		20% 	1-2x 	[Greater Nether Essence] 	75% 	1-2x 	[Large Radiant Shard] 		5%",
			[51] =	"[Dream Dust]		22% 	2-5x 	[Lesser Eternal Essence] 	75% 	1-2x 	[Small Brilliant Shard] 	3%",
			[56] =	"[Illusion Dust] 	22% 	1-2x 	[Greater Eternal Essence] 	75% 	1-2x 	[Large Brilliant Shard] 	3%",
			[61] =	"[Illusion Dust] 	22% 	2-5x 	[Greater Eternal Essence] 	75% 	2-3x 	[Large Brilliant Shard] 	3%",
			[66] =	"[Arcane Dust] 		22% 	2-3x 	[Lesser Planar Essence] 	75% 	2-3x 	[Small Prismatic Shard] 	3%",
			[100] =	"[Arcane Dust] 		22% 	2-5x 	[Greater Planar Essence] 	75% 	1-2x 	[Large Prismatic Shard] 	3%",
			[121] =	"[Infinite Dust] 	22% 	1-2x 	[Lesser Cosmic Essence] 	75% 	1-2x 	[Small Dream Shard] 		3%",
			[152] =	"[Infinite Dust] 	22% 	2-5x 	[Greater Cosmic Essence] 	75% 	1-2x 	[Dream Shard] 				3%",
			[272] = "[Hypnotic Dust] 	75% 	1-3x 	[Lesser Celestial Essence] 	25% 	1-3x 	[NIL]						0%",
		},
		["Rare"] = {
			[11] =	"[Small Glimmering Shard] 	100%	[NIL]				0%",
			[26] =	"[Large Glimmering Shard] 	100%	[NIL]				0%",
			[31] =	"[Small Glowing Shard] 		100%	[NIL]				0%",
			[36] = 	"[Large Glowing Shard] 		100%	[NIL]				0%",
			[41] =	"[Small Radiant Shard] 		100%	[NIL]				0%",
			[46] =	"[Large Radiant Shard] 		100%	[NIL]				0%",
			[51] =	"[Small Brilliant Shard] 	100%	[NIL]				0%",
			[56] =	"[Large Brilliant Shard] 	99.5%	[Nexus Crystal] 	0.5%",
			[66] =	"[Small Prismatic Shard] 	99.5%	[Nexus Crystal] 	0.5%",
			[100] =	"[Large Prismatic Shard] 	99.5%	[Void Crystal]	 	0.5%",
			[121] =	"[Small Dream Shard] 		99.5%	[Abyss Crystal] 	0.5%",
			[165] =	"[Dream Shard] 				99.5%	[Abyss Crystal] 	0.5%",
			[279] = "[Small Heavenly Shard] 	100%	[NIL]				0%",
			[318] = "[Heavenly Shard]			100%	[NIL]				0%",
		},
		["Epic Armor"] = {
			[40] =	"[Small Radiant Shard] 		2-4x",
			[46] = 	"[Large Radiant Shard] 		2-4x",
			[51] =	"[Small Brilliant Shard] 	2-4x",
			[56] =	"[Nexus Crystal] 			1-1x",
			[61] =	"[Nexus Crystal] 			1-2x",
			[95] =	"[Void Crystal] 			1-2x",
			[105] =	"[Void Crystal] 			1.66-1.66x",		-- 1-2x 	33% 1x, 67% 2x
			[165] =	"[Abyss Crystal] 			1-1x",
			[201] =	"[Abyss Crystal] 			1-2x",
			[285] =	"[Maelstrom Crystal]		1-1x",
			[360] =	"[Maelstrom Crystal] 		1-2x",
		},
		["Epic Weapon"] = {
			[40] =	"[Small Radiant Shard] 		2-4x",
			[46] = 	"[Large Radiant Shard] 		2-4x",
			[51] =	"[Small Brilliant Shard] 	2-4x",
			[56] =	"[Nexus Crystal] 			1-1x",
			[61] =	"[Nexus Crystal] 			1-2x",
			[76] =	"[Nexus Crystal]			1.66-1.66x",		-- 1-2x 	33% 1x, 67% 2x		THIS IS THE ONLY DIFFERENCE FROM ARMOR
			[95] =	"[Void Crystal] 			1-2x",
			[105] =	"[Void Crystal] 			1.66-1.66x",		-- 1-2x 	33% 1x, 67% 2x
			[165] =	"[Abyss Crystal] 			1-1x",
			[201] =	"[Abyss Crystal] 			1-2x",
			[285] =	"[Maelstrom Crystal]		1-1x",
			[360] =	"[Maelstrom Crystal] 		1-2x",
		}
	}

	local reagentBrackets = { "Armor", "Weapon", "Rare", "Epic Armor", "Epic Weapon" }

	local disenchantTable = { }


	local deExclusions = { [11287] = true, [11288] = true, [11289] = true, [11290] = true, [58483] = true }		-- wands can't be de'd, nor can lifebound alchemist stones


	local deReagents = {}
	local deResults = {}
	local deNames = {}

	local bracketNames = {}


	local function BuildReagentTables()
		local armor = reagentSourceTable["Armor"]
		local weapon = reagentSourceTable["Weapon"]
		local rare = reagentSourceTable["Rare"]
		local epicArmor = reagentSourceTable["Epic Armor"]
		local epicWeapon = reagentSourceTable["Epic Weapon"]

		local armorTable = {}
		local baseLevel = 5
		local newTable = nil

		local name = nil

		for level=5,400 do
			local line

			if armor[level] then
				baseLevel = level
				newTable = {}

				line = string.gsub(armor[baseLevel], "%s+", " ")

				local dustName, dustPercent, dustMin, dustMax, essenceName, essencePercent, essenceMin, essenceMax, shardName, shardPercent = string.match(line, "(%b[]) ([%d%.]+)%% ([%d%.]+)-([%d%.]+)x (%b[]) ([%d%.]+)%% ([%d%.]+)-([%d%.]+)x (%b[]) ([%d%.]+)%%")

				if dustName and reagentID[dustName] then
					newTable[reagentID[dustName]] =  tonumber(dustPercent)/ 100 * (tonumber(dustMin) + tonumber(dustMax)) / 2
				end

				if essenceName and reagentID[essenceName] then
					newTable[reagentID[essenceName]] =  tonumber(essencePercent)/ 100 * (tonumber(essenceMin) + tonumber(essenceMax)) / 2
				end

				if shardName and reagentID[shardName] then
					newTable[reagentID[shardName]] =  tonumber(shardPercent)/ 100
				end

				armorTable[level] = newTable
			else
				armorTable[level] = newTable
			end
		end

		disenchantTable[ArmorID.."2"] = armorTable


		local weaponTable = {}
		local baseLevel = 6
		local newTable = nil

		for level=6,400 do
			local line

			if weapon[level] then
				baseLevel = level
				newTable = {}

				line = string.gsub(weapon[baseLevel], "%s+", " ")

				local dustName, dustPercent, dustMin, dustMax, essenceName, essencePercent, essenceMin, essenceMax, shardName, shardPercent = string.match(line, "(%b[]) ([%d%.]+)%% ([%d%.]+)-([%d%.]+)x (%b[]) ([%d%.]+)%% ([%d%.]+)-([%d%.]+)x (%b[]) ([%d%.]+)%%")

				if dustName and reagentID[dustName] then
					newTable[reagentID[dustName]] =  tonumber(dustPercent)/ 100 * (tonumber(dustMin) + tonumber(dustMax)) / 2
				end

				if essenceName and reagentID[essenceName] then
					newTable[reagentID[essenceName]] =  tonumber(essencePercent)/ 100 * (tonumber(essenceMin) + tonumber(essenceMax)) / 2
				end

				if shardName and reagentID[shardName] then
					newTable[reagentID[shardName]] =  tonumber(shardPercent)/ 100
				end


				weaponTable[level] = newTable
			else
				weaponTable[level] = newTable
			end
		end

		disenchantTable[WeaponID.."2"] = weaponTable



		local rareTable = {}
		local baseLevel = 11
		local newTable = nil

		for level=11,400 do
			local line

			if rare[level] then
				baseLevel = level
				newTable = {}

				line = string.gsub(rare[baseLevel], "%s+", " ")

				local shardName, shardPercent, crystalName, crystalPercent = string.match(line, "(%b[]) ([%d%.]+)%% (%b[]) ([%d%.]+)%%")

				if shardName and reagentID[shardName] then
					newTable[reagentID[shardName]] =  (tonumber(shardPercent)) / 100
				end

				if crystalName and reagentID[crystalName] then
					newTable[reagentID[crystalName]] =  (tonumber(crystalPercent)) / 100
				end

				rareTable[level] = newTable
			else
				rareTable[level] = newTable
			end
		end

		disenchantTable[WeaponID.."3"] = rareTable
		disenchantTable[ArmorID.."3"] = rareTable



		local epicArmorTable = {}
		local baseLevel = 40
		local newTable = nil

		for level=40,400 do
			local line

			if epicArmor[level] then
				baseLevel = level
				newTable = {}

				line = string.gsub(epicArmor[baseLevel], "%s+", " ")

				local shardName, shardMin, shardMax = string.match(line, "(%b[]) ([%d%.]+)-([%d%.]+)x")

				if shardName and reagentID[shardName] then
					newTable[reagentID[shardName]] =  (tonumber(shardMin) + tonumber(shardMax)) / 2
				end

				epicArmorTable[level] = newTable
			else
				epicArmorTable[level] = newTable
			end
		end

		disenchantTable[ArmorID.."4"] = epicArmorTable




		local epicWeaponTable = {}
		local baseLevel = 40
		local newTable = nil

		for level=40,400 do
			local line

			if epicWeapon[level] then
				baseLevel = level
				newTable = {}

				line = string.gsub(epicWeapon[baseLevel], "%s+", " ")

				local shardName, shardMin, shardMax = string.match(line, "(%b[]) ([%d%.]+)-([%d%.]+)x")

				if shardName and reagentID[shardName] then
					newTable[reagentID[shardName]] =  (tonumber(shardMin) + tonumber(shardMax)) / 2
				end

				epicWeaponTable[level] = newTable
			else
				epicWeaponTable[level] = newTable
			end
		end

		disenchantTable[WeaponID.."4"] = epicWeaponTable

		LSWConfig.detables = nil
	end


	local function DumpDisenchantTable()
		for class, deTable in pairs(disenchantTable) do
			for level, t in pairs(deTable) do
				for id, count in pairs(t) do
					LSW:ChatMessage(class.." level: "..level.." "..GetItemInfo(id).." x "..count)
				end
			end
		end
	end


	local function DisenchantTable(itemID)
		if deExclusions[itemID] ~= nil then
			return
		end

		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType = GetItemInfo(itemID)

		if itemName and itemRarity > 1 and itemRarity < 5 and (itemType == ArmorID or itemType == WeaponID) then
			local tableName = itemType..itemRarity

			if disenchantTable[tableName] and  disenchantTable[tableName][itemLevel] then
				return disenchantTable[tableName][itemLevel]
			end
		end
	end


	local function DisenchantValue(itemID)
		local deTable = DisenchantTable(itemID)

		local deValue = 0

		if (deTable) then
			for reagentID, count in pairs(deTable) do
--local _, link = GetItemInfo(reagentID)
--LSW:ChatMessage(link.." x "..count.."  =  "..(LSW.auctionValue(reagentID) or 0) * (count or 1))
				deValue = deValue + (LSW.auctionValue(reagentID) or 0) * (count or 1)
			end

			return deValue
		end
	end



	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding native Disenchanting support")

		BuildReagentTables()

--		DumpDisenchantTable()

		LSW.getDisenchantValue = DisenchantValue
		LSW.getDisenchantResults = DisenchantTable
	end


	local function Test(index)
		if enabled then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Disenchanting", Test, Init)
end


