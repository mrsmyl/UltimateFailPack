


-- prospecting support




local enabled = true


do
-- results : [ore][gem] = numProspected
	local prospectingResults = {
		[2770] = { --Copper Ore
			[818] = 0.501, --Tigerseye
			[1210] = 0.099, --Shadowgem
			[774] = 0.499, --Malachite
		},
		[2771] = { --Tin Ore
			[3864] = 0.032, --Citrine
			[1210] = 0.399, --Shadowgem
			[1529] = 0.033, --Jade
			[1206] = 0.398, --Moss Agate
			[1705] = 0.4, --Lesser Moonstone
			[7909] = 0.031, --Aquamarine
		},
		[2772] = { --Iron Ore
			[3864] = 0.371, --Citrine
			[1529] = 0.368, --Jade
			[7910] = 0.048, --Star Ruby
			[1705] = 0.363, --Lesser Moonstone
			[7909] = 0.05, --Aquamarine
		},
		[10620] = { --Thorium Ore
			[12364] = 0.335, --Huge Emerald
			[12361] = 0.336, --Blue Sapphire
			[12799] = 0.333, --Large Opal
			[12800] = 0.332, --Azerothian Diamond
			[7910] = 0.161, --Star Ruby
		},
		[3858] = { --Mithril Ore
			[12364] = 0.023, --Huge Emerald
			[12361] = 0.025, --Blue Sapphire
			[12799] = 0.027, --Large Opal
			[12800] = 0.025, --Azerothian Diamond
			[7909] = 0.366, --Aquamarine
			[7910] = 0.37, --Star Ruby
			[3864] = 0.367, --Citrine
		},
		[23424] = { --Fel Iron Ore
			[23441] = 0.012, --Nightseye
			[23438] = 0.012, --Star of Elune
			[23112] = 0.189, --Golden Draenite
			[23439] = 0.013, --Noble Topaz
			[23437] = 0.012, --Talasite
			[23117] = 0.178, --Azure Moonstone
			[23436] = 0.012, --Living Ruby
			[23440] = 0.012, --Dawnstone
			[21929] = 0.183, --Flame Spessarite
			[23079] = 0.183, --Deep Peridot
			[23077] = 0.185, --Blood Garnet
			[23107] = 0.183, --Shadow Draenite
		},
		[23425] = { --Adamantite Ore
			[23441] = 0.036, --Nightseye
			[23438] = 0.036, --Star of Elune
			[23112] = 0.187, --Golden Draenite
			[23437] = 0.037, --Talasite
			[23439] = 0.038, --Noble Topaz
			[23079] = 0.186, --Deep Peridot
			[23117] = 0.179, --Azure Moonstone
			[23436] = 0.037, --Living Ruby
			[23440] = 0.037, --Dawnstone
			[21929] = 0.184, --Flame Spessarite
			[24243] = 1, --Adamantite Powder
			[23077] = 0.181, --Blood Garnet
			[23107] = 0.183, --Shadow Draenite
		},
		[36909] = { --Cobalt Ore
			[36929] = 0.255, --Huge Citrine
			[36930] = 0.014, --Monarch Topaz
			[36923] = 0.248, --Chalcedony
			[36924] = 0.012, --Sky Sapphire
			[36917] = 0.244, --Bloodstone
			[36918] = 0.012, --Scarlet Ruby
			[36926] = 0.254, --Shadow Crystal
			[36927] = 0.012, --Twilight Opal
			[36920] = 0.246, --Sun Crystal
			[36932] = 0.246, --Dark Jade
			[36921] = 0.012, --Autumn's Glow
			[36933] = 0.013, --Forest Emerald
		},
		[36912] = { --Saronite Ore
			[36929] = 0.184, --Huge Citrine
			[36930] = 0.041, --Monarch Topaz
			[36923] = 0.181, --Chalcedony
			[36924] = 0.044, --Sky Sapphire
			[36917] = 0.182, --Bloodstone
			[36918] = 0.041, --Scarlet Ruby
			[36926] = 0.182, --Shadow Crystal
			[36927] = 0.041, --Twilight Opal
			[36920] = 0.185, --Sun Crystal
			[36932] = 0.185, --Dark Jade
			[36921] = 0.04, --Autumn's Glow
			[36933] = 0.041, --Forest Emerald
		},
		[36910] = { --Titanium Ore
			[36917] = 0.251, --Bloodstone
			[36918] = 0.042, --Scarlet Ruby
			[36919] = 0.04, --Cardinal Ruby
			[36920] = 0.246, --Sun Crystal
			[36921] = 0.041, --Autumn's Glow
			[36922] = 0.046, --King's Amber
			[36923] = 0.255, --Chalcedony
			[36924] = 0.042, --Sky Sapphire
			[36925] = 0.046, --Majestic Zircon
			[36926] = 0.252, --Shadow Crystal
			[36927] = 0.04, --Twilight Opal
			[36928] = 0.045, --Dreadstone
			[36929] = 0.251, --Huge Citrine
			[36930] = 0.043, --Monarch Topaz
			[36931] = 0.046, --Ametrine
			[36932] = 0.252, --Dark Jade
			[36933] = 0.041, --Forest Emerald
			[36934] = 0.045, --Eye of Zul
		},
		[53038] = { --Obsidium Ore
			[52192] = 0.013, --Dream Emerald
			[52178] = 0.25, --Zephyrite
			[52179] = 0.247, --Alicite
			[52180] = 0.25, --Nightstone
			[52181] = 0.251, --Hessonite
			[52182] = 0.251, --Jasper
			[52177] = 0.25, --Carnelian
			[52193] = 0.012, --Ember Topaz
			[52194] = 0.012, --Demonseye
		},
		[52185] = { --Elementium Ore
			[52192] = 0.046, --Dream Emerald
			[52178] = 0.182, --Zephyrite
			[52179] = 0.182, --Alicite
			[52180] = 0.183, --Nightstone
			[52181] = 0.184, --Hessonite
			[52182] = 0.184, --Jasper
			[52177] = 0.183, --Carnelian
			[52193] = 0.046, --Ember Topaz
			[52194] = 0.045, --Demonseye
		},
		[52183] = { --Pyrite Ore
			[52327] = 2.001, --Volatile Earth
			[52178] = 0.165, --Zephyrite
			[52179] = 0.168, --Alicite
			[52180] = 0.168, --Nightstone
			[52181] = 0.167, --Hessonite
			[52182] = 0.166, --Jasper
			[52177] = 0.166, --Carnelian
			[52193] = 0.076, --Ember Topaz
			[52192] = 0.076, --Dream Emerald
			[52194] = 0.074, --Demonseye
		},
	}


	local prospectingLevels = {
		[52183] = 500, --Pyrite Ore
		[52185] = 475, --Elementium Ore
		[53038] = 425, --Obsidium Ore
		[36912] = 400, --Saronite Ore
		[36909] = 350, --Cobalt Ore
		[23425] = 325, --Adamantite Ore
		[23424] = 275, --Fel Iron Ore
		[10620] = 250, --Thorium Ore
		[3858] = 175, --Mithril Ore
		[2772] = 125, -- Iron Ore
		[2771] = 50, --Tin Ore
		[2770] = 20, --Copper Ore
	}


	local prospectingLevels = {
		[52183] = { "playerProspectLevel", 500}, --Pyrite Ore
		[52185] = { "playerProspectLevel", 475}, --Elementium Ore
		[53038] = { "playerProspectLevel", 425}, --Obsidium Ore
		[36912] = { "playerProspectLevel", 400}, --Saronite Ore
		[36909] = { "playerProspectLevel", 350}, --Cobalt Ore
		[23425] = { "playerProspectLevel", 325}, --Adamantite Ore
		[23424] = { "playerProspectLevel", 275}, --Fel Iron Ore
		[10620] = { "playerProspectLevel", 250}, --Thorium Ore
		[3858] = { "playerProspectLevel", 175}, --Mithril Ore
		[2772] = { "playerProspectLevel", 125}, -- Iron Ore
		[2771] = { "playerProspectLevel", 50}, --Tin Ore
		[2770] = { "playerProspectLevel", 20}, --Copper Ore
	}


	-- spoof recipes for prospected ores -> gems
	local function AddToRecipeCache()
		for oreID, gemTable in pairs(prospectingResults) do
			local reagentTable = {}
			local recipeName = "Prospect "..(GetItemInfo(oreID) or "item:"..oreID)

			reagentTable[oreID] = 5

			LSW:AddRecipe(-oreID, recipeName, gemTable, reagentTable, prospectingLevels[oreID])
		end
	end

	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop adding native Prospecting support")

		AddToRecipeCache()
	end


	local function Test(index)
		if enabled then
			return true
		end

		return false
	end

	LSW:RegisterPricingSupport("Prospecting", Test, Init)
end


