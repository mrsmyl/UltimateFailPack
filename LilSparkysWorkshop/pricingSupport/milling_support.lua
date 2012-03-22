


-- milling support





local enabled = true

do
-- results : [pigment][herb] = numMilled
	local millingResults = {
		[765] = { -- Silverleaf
			[39151] = 2.501, --Alabaster Pigment
		},
		[2447] = { -- Peacebloom
			[39151] = 2.5, --Alabaster Pigment
		},
		[785] = { -- Mageroyal
			[39334] = 2.498, --Dusky Pigment
			[43103] = 0.269, --Verdant Pigment
		},
		[2449] = { -- Earthroot
			[39151] = 2.995, --Alabaster Pigment
		},
		[2450] = { -- Briarthorn
			[39334] = 2.499, --Dusky Pigment
			[43103] = 0.265, --Verdant Pigment
		},
		[2452] = { -- Swiftthistle
			[39334] = 2.497, --Dusky Pigment
			[43103] = 0.266, --Verdant Pigment
		},
		[2453] = { -- Bruiseweed
			[39334] = 2.999, --Dusky Pigment
			[43103] = 0.537, --Verdant Pigment
		},
		[3820] = { -- Stranglekelp
			[39334] = 3.01, --Dusky Pigment
			[43103] = 0.532, --Verdant Pigment
		},
		[3369] = { -- Grave Moss
			[39338] = 2.502, --Golden Pigment
			[43104] = 0.277, --Burnt Pigment
		},
		[3355] = { -- Wild Steelbloom
			[39338] = 2.499, --Golden Pigment
			[43104] = 0.264, --Burnt Pigment
		},
		[3356] = { -- Kingsblood
			[39338] = 3, --Golden Pigment
			[43104] = 0.534, --Burnt Pigment
		},
		[3357] = { -- Liferoot
			[39338] = 2.999, --Golden Pigment
			[43104] = 0.541, --Burnt Pigment
		},
		[3818] = { -- Fadeleaf
			[39339] = 2.496, --Emerald Pigment
			[43105] = 0.262, --Indigo Pigment
		},
		[3821] = { -- Goldthorn
			[39339] = 2.491, --Emerald Pigment
			[43105] = 0.27, --Indigo Pigment
		},
		[3358] = { -- Khadgar's Whisker
			[39339] = 3.501, --Emerald Pigment
			[43105] = 0.533, --Indigo Pigment
		},
		[3819] = { -- Dragon's Teeth
			[39339] = 3.492, --Emerald Pigment
			[43105] = 0.529, --Indigo Pigment
		},
		[4625] = { -- Firebloom
			[39340] = 2.506, --Violet Pigment
			[43106] = 0.27, --Ruby Pigment
		},
		[8831] = { -- Purple Lotus
			[39340] = 2.502, --Violet Pigment
			[43106] = 0.257, --Ruby Pigment
		},
		[8836] = { -- Arthas' Tears
			[39340] = 2.511, --Violet Pigment
			[43106] = 0.274, --Ruby Pigment
		},
		[8838] = { -- Sungrass
			[39340] = 2.499, --Violet Pigment
			[43106] = 0.266, --Ruby Pigment
		},
		[8839] = { -- Blindweed
			[39340] = 2.998, --Violet Pigment
			[43106] = 0.532, --Ruby Pigment
		},
		[8845] = { -- Ghost Mushroom
			[39340] = 2.997, --Violet Pigment
			[43106] = 0.55, --Ruby Pigment
		},
		[8846] = { -- Gromsblood
			[39340] = 3.006, --Violet Pigment
			[43106] = 0.536, --Ruby Pigment
		},
		[13464] = { -- Golden Sansam
			[43107] = 0.265, --Sapphire Pigment
			[39341] = 2.505, --Silvery Pigment
		},
		[13463] = { -- Dreamfoil
			[43107] = 0.27, --Sapphire Pigment
			[39341] = 2.499, --Silvery Pigment
		},
		[13465] = { -- Mountain Silversage
			[43107] = 0.536, --Sapphire Pigment
			[39341] = 3.011, --Silvery Pigment
		},
		[13466] = { -- Sorrowmoss
			[43107] = 0.538, --Sapphire Pigment
			[39341] = 3.001, --Silvery Pigment
		},
		[13467] = { -- Icecap
			[43107] = 0.538, --Sapphire Pigment
			[39341] = 3.002, --Silvery Pigment
		},
		[22785] = { -- Felweed
			[43108] = 0.264, --Ebon Pigment
			[39342] = 2.501, --Nether Pigment
		},
		[22786] = { -- Dreaming Glory
			[43108] = 0.265, --Ebon Pigment
			[39342] = 2.501, --Nether Pigment
		},
		[22789] = { -- Terocone
			[43108] = 0.266, --Ebon Pigment
			[39342] = 2.493, --Nether Pigment
		},
		[22787] = { -- Ragveil
			[43108] = 0.272, --Ebon Pigment
			[39342] = 2.504, --Nether Pigment
		},
		[22790] = { -- Ancient Lichen
			[43108] = 0.532, --Ebon Pigment
			[39342] = 2.995, --Nether Pigment
		},
		[22791] = { -- Netherbloom
			[43108] = 0.547, --Ebon Pigment
			[39342] = 3.001, --Nether Pigment
		},
		[22792] = { -- Nightmare Vine
			[43108] = 0.562, --Ebon Pigment
			[39342] = 2.997, --Nether Pigment
		},
		[22793] = { -- Mana Thistle
			[43108] = 0.529, --Ebon Pigment
			[39342] = 3.023, --Nether Pigment
		},
		[36907] = { -- Talandra's Rose
			[43109] = 0.267, --Icy Pigment
			[39343] = 2.503, --Azure Pigment
		},
		[37921] = { -- Deadnettle
			[43109] = 0.267, --Icy Pigment
			[39343] = 2.5, --Azure Pigment
		},
		[36904] = { -- Tiger Lily
			[43109] = 0.265, --Icy Pigment
			[39343] = 2.502, --Azure Pigment
		},
		[36901] = { -- Goldclover
			[43109] = 0.267, --Icy Pigment
			[39343] = 2.5, --Azure Pigment
		},
		[39970] = { -- Fire Leaf
			[43109] = 0.268, --Icy Pigment
			[39343] = 2.503, --Azure Pigment
		},
		[39969] = { -- Fire Seed
			[43109] = 0.244, --Icy Pigment
			[39343] = 2.633, --Azure Pigment
		},
		[36903] = { -- Adder's Tongue
			[43109] = 0.535, --Icy Pigment
			[39343] = 3.002, --Azure Pigment
		},
		[36905] = { -- Lichbloom
			[43109] = 0.537, --Icy Pigment
			[39343] = 3, --Azure Pigment
		},
		[36906] = { -- Icethorn
			[43109] = 0.539, --Icy Pigment
			[39343] = 2.989, --Azure Pigment
		},
		[52983] = { -- Cinderbloom
			[61979] = 2.499, --Ashen Pigment
			[61980] = 0.265, --Burning Embers
		},
		[52984] = { -- Stormvine
			[61979] = 2.502, --Ashen Pigment
			[61980] = 0.266, --Burning Embers
		},
		[52985] = { -- Azshara's Veil
			[61979] = 2.502, --Ashen Pigment
			[61980] = 0.267, --Burning Embers
		},
		[52986] = { -- Heartblossom
			[61979] = 2.501, --Ashen Pigment
			[61980] = 0.266, --Burning Embers
		},
		[52988] = { -- Whiptail
			[61979] = 2.998, --Ashen Pigment
			[61980] = 0.536, --Burning Embers
		},
		[52987] = { -- Twilight Jasmine
			[61979] = 3, --Ashen Pigment
			[61980] = 0.533, --Burning Embers
		},
	}

	local millBrackets =
	{
		[2449] = 1,
		[2447] = 1,
		[765] = 1,

		[2450] = 25,
		[2453] = 25,
		[785] = 25,
		[3820] = 25,
		[2452] = 25,

		[3369] = 75,
		[3356] = 75,
		[3357] = 75,
		[3355] = 75,

		[3818] = 125,
		[3821] = 125,
		[3358] = 125,
		[3819] = 125,

		[8836] = 175,
		[8839] = 175,
		[4625] = 175,
		[8845] = 175,
		[8846] = 175,
		[8831] = 175,
		[8838] = 175,

		[13463] = 225,
		[13464] = 225,
		[13467] = 225,
		[13465] = 225,
		[13466] = 225,

		[22790] = 275,
		[22786] = 275,
		[22785] = 275,
		[22793] = 275,
		[22791] = 275,
		[22792] = 275,
		[22787] = 275,
		[22789] = 275,

		[36903] = 325,
		[37921] = 325,
		[39970] = 325,
		[36901] = 325,
		[36906] = 325,
		[36905] = 325,
		[36907] = 325,
		[36904] = 325,

		[52983] = 425,
		[52984] = 425,

		[52986] = 450,
		[52985] = 450,

		[52987] = 475,
		[52988] = 475,

--		[52989] = 500,
	}



	local millingLevels = {
		[1] = { "playerMillLevel", 1},
		[25] = { "playerMillLevel", 25},
		[75] = { "playerMillLevel", 75},
		[125] = { "playerMillLevel", 125},
		[175] = { "playerMillLevel", 175},
		[225] = { "playerMillLevel", 225},
		[275] = { "playerMillLevel", 275},
		[325] = { "playerMillLevel", 325},
		[425] = { "playerMillLevel", 425},
		[450] = { "playerMillLevel", 450},
		[475] = { "playerMillLevel", 475},
--		[500] = { "playerMillLevel", 500},
	}

	local pigmentSources = {}


	local function BuildPigmentSources()
		for herbID, pigmentTable in pairs(millingResults) do
			for pigmentID, count in pairs(pigmentTable) do
				if not pigmentSources[pigmentID] then
					pigmentSources[pigmentID] = {}
				end

				pigmentSources[pigmentID][herbID] = count
			end
		end
	end


	-- spoof recipes for milled herbs -> pigments
	local function AddToRecipeCache()
		for herbID, pigmentTable in pairs(millingResults) do
			local reagentTable = {}
			local recipeName = "Mill "..(GetItemInfo(herbID) or "item:"..herbID)

			reagentTable[herbID] = 5

			LSW:AddRecipe(-herbID, recipeName, pigmentTable, reagentTable, millingLevels[herbID])
		end
	end



	local function GetMillingSources(itemID)
		return millingResults[itemID]
	end


	local function GetMillingValue(itemID)
		local millingTable = millingResults[itemID]

		local value = 0

		if (millingTable) then
			for pigmentID, count in pairs(millingTable) do
				value = value + (LSW.auctionValue(pigmentID) or 0) * (count or 1)
			end

			return value
		end
	end


	local function GetPigmentSources(itemID)
		return pigmentSources[itemID]
	end



	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding native Milling support")

		BuildPigmentSources()
		AddToRecipeCache()

		LSW.getMillingValue = GetMillingValue
		LSW.getMillingResults = GetMillingSources
		LSW.getPigmentSources = GetPigmentSources
	end


	local function Test(index)
		if enabled then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Milling", Test, Init)
end


