QuestHelper_File["upgrade.lua"] = "4.0.6.161r"
local my_version = QuestHelper_File["upgrade.lua"]

QuestHelper_Loadtime["upgrade.lua"] = GetTime()

QuestHelper_Zones =
  {
   {[0]="Kalimdor",
    [1]="Ahn'Qiraj: The Fallen Kingdom",
    [2]="Ashenvale",
    [3]="Azshara",
    [4]="Azuremyst Isle",
    [5]="Bloodmyst Isle",
    [6]="Darkshore",
    [7]="Darnassus",
    [8]="Desolace",
    [9]="Durotar",
    [10]="Dustwallow Marsh",
    [11]="Felwood",
    [12]="Feralas",
    [13]="Moonglade",
    [14]="Mount Hyjal",
    [15]="Mulgore",
    [16]="Northern Barrens",
    [17]="Orgrimmar",
    [18]="Silithus",
    [19]="Southern Barrens",
    [20]="Stonetalon Mountains",
    [21]="Tanaris",
    [22]="Teldrassil",
    [23]="The Exodar",
    [24]="Thousand Needles",
    [25]="Thunder Bluff",
    [26]="Uldum",
    [27]="Un'Goro Crater",
    [28]="Winterspring"
   },
   {[0]="Eastern Kingdoms",
    [1]="Abyssal Depths",
    [2]="Arathi Highlands",
    [3]="Badlands",
    [4]="Blasted Lands",
    [5]="Burning Steppes",
    [6]="Deadwind Pass",
    [7]="Dun Morogh",
    [8]="Duskwood",
    [9]="Eastern Plaguelands",
    [10]="Elwynn Forest",
    [11]="Eversong Woods",
    [12]="Ghostlands",
    [13]="Hillsbrad Foothills",
    [14]="Ironforge",
    [15]="Isle of Quel'Danas",
    [16]="Kelp'thar Forest",
    [17]="Loch Modan",
    [18]="Northern Stranglethorn",
    [19]="Redridge Mountains",
    [20]="Ruins of Gilneas",
    [21]="Gilneas", -- Actually "Ruins of Gilneas City", but this fixes issues with some non-English clients that have the two zones named the same.
    [22]="Searing Gorge",
    [23]="Shimmering Expanse",
    [24]="Silvermoon City",
    [25]="Silverpine Forest",
    [26]="Stormwind City",
    [27]="Stranglethorn Vale",
    [28]="Swamp of Sorrows",
    [29]="The Cape of Stranglethorn",
    [30]="The Hinterlands",
    [31]="Tirisfal Glades",
    [32]="Tol Barad",
    [33]="Tol Barad Peninsula",
    [34]="Twilight Highlands",
    [35]="Undercity",
    [36]="Vashj'ir",
    [37]="Western Plaguelands",
    [38]="Westfall",
    [39]="Wetlands"
   },
   {[0]="Outland",
    [1]="Blade's Edge Mountains",
    [2]="Hellfire Peninsula",
    [3]="Nagrand",
    [4]="Netherstorm",
    [5]="Shadowmoon Valley",
    [6]="Shattrath City",
    [7]="Terokkar Forest",
    [8]="Zangarmarsh"
  },
  {[0]="Northrend",
    [1]="Borean Tundra",
    [2]="Crystalsong Forest",
    [3]="Dalaran",
    [4]="Dragonblight",
    [5]="Grizzly Hills",
    [6]="Howling Fjord",
    [7]="Hrothgar's Landing",
    [8]="Icecrown",
    [9]="Sholazar Basin",
    [10]="The Storm Peaks",
    [11]="Wintergrasp",
    [12]="Zul'Drak",
  },
  {[0]="The Maelstrom Continent",
   [1]="Deepholm",
   [2]="Kezan",
   [3]="The Lost Isles",
   [4]="The Maelstrom"
  },
  [-77]={[0]="ScarletEnclave_Continent", [1]="ScarletEnclave"},
  [-78]={[0]="GilneasCity_Continent", [1]="GilneasCity"},
  [-79]={[0]="GilneasZone_Continent", [1]="GilneasZone"},
  
  [-80]={[0]="UtgardeKeep1_Continent", [1]="UtgardeKeep1"},
  [-81]={[0]="UtgardeKeep2_Continent", [1]="UtgardeKeep2"},
  [-82]={[0]="UtgardeKeep3_Continent", [1]="UtgardeKeep3"},
  
  [-83]={[0]="TheNexus_Continent", [1]="TheNexus"},
  
  [-84]={[0]="AzjolNerub1_Continent", [1]="AzjolNerub1"},
  [-85]={[0]="AzjolNerub2_Continent", [1]="AzjolNerub2"},
  [-86]={[0]="AzjolNerub3_Continent", [1]="AzjolNerub3"},
  
  [-87]={[0]="Ahnkahet_Continent", [1]="Ahnkahet"},
  
  [-88]={[0]="DrakTharonKeep1_Continent", [1]="DrakTharonKeep1"},
  [-89]={[0]="DrakTharonKeep2_Continent", [1]="DrakTharonKeep2"},
  
  [-90]={[0]="VioletHold_Continent", [1]="VioletHold"},
  
  [-91]={[0]="Gundrak_Continent", [1]="Gundrak"},
  
  [-92]={[0]="Ulduar77_Continent", [1]="Ulduar77"},
  
  [-93]={[0]="HallsofLightning1_Continent", [1]="HallsofLightning1"},
  [-94]={[0]="HallsofLightning2_Continent", [1]="HallsofLightning2"},
  
  [-95]={[0]="Nexus801_Continent", [1]="Nexus801"},
  [-96]={[0]="Nexus802_Continent", [1]="Nexus802"},
  [-97]={[0]="Nexus803_Continent", [1]="Nexus803"},
  [-98]={[0]="Nexus804_Continent", [1]="Nexus804"},
  
  [-99]={[0]="CoTStratholme1_Continent", [1]="CoTStratholme1"},
  [-100]={[0]="CoTStratholme2_Continent", [1]="CoTStratholme2"},
  
  [-101]={[0]="UtgardePinnacle1_Continent", [1]="UtgardePinnacle1"},
  [-102]={[0]="UtgardePinnacle2_Continent", [1]="UtgardePinnacle2"},
  
  [-103]={[0]="VaultofArchavon_Continent", [1]="VaultofArchavon"},
  
  [-104]={[0]="Naxxramas1_Continent", [1]="Naxxramas1"},
  [-105]={[0]="Naxxramas2_Continent", [1]="Naxxramas2"},
  [-106]={[0]="Naxxramas3_Continent", [1]="Naxxramas3"},
  [-107]={[0]="Naxxramas4_Continent", [1]="Naxxramas4"},
  [-108]={[0]="Naxxramas5_Continent", [1]="Naxxramas5"},
  [-109]={[0]="Naxxramas6_Continent", [1]="Naxxramas6"},
  
  [-110]={[0]="TheObsidianSanctum_Continent", [1]="TheObsidianSanctum"},
  
  [-111]={[0]="TheEyeOfEternity_Continent", [1]="TheEyeOfEternity"},
  
  [-112]={[0]="Ulduar_Continent", [1]="Ulduar"},
  [-113]={[0]="Ulduar1_Continent", [1]="Ulduar1"},
  [-114]={[0]="Ulduar2_Continent", [1]="Ulduar2"},
  [-115]={[0]="Ulduar3_Continent", [1]="Ulduar3"},
  [-116]={[0]="Ulduar4_Continent", [1]="Ulduar4"},
  
  [-117]={[0]="TheForgeofSouls_Continent", [1]="TheForgeofSouls"},
  [-118]={[0]="PitofSaron_Continent", [1]="PitofSaron"},
}


-- This will be translated to [LOCALE_NAME] = INDEX by QuestHelper_BuildZoneLookup.
-- Additionally, [CONT_INDEX][ZONE_INDEX] = INDEX will also be added.
QuestHelper_IndexLookup =
 {
  ["Orgrimmar"] = {1, 1, 17},
  ["Ashenvale"] = {2, 1, 2},
  ["AzuremystIsle"] = {3, 1, 4},
  ["Desolace"] = {4, 1, 8},
  ["Silithus"] = {5, 1, 18},
  ["StonetalonMountains"] = {6, 1, 20},
  ["Durotar"] = {7, 1, 9},
  ["Tanaris"] = {8, 1, 21},
  ["BloodmystIsle"] = {9, 1, 5},
  ["Dustwallow"] = {10, 1, 10},
  ["Barrens"] = {11, 1, 16},
  ["TheExodar"] = {12, 1, 23},
  ["Felwood"] = {13, 1, 11},
  ["ThousandNeedles"] = {14, 1, 24},
  ["Aszhara"] = {15, 1, 3},
  ["Darkshore"] = {16, 1, 6},
  ["Feralas"] = {17, 1, 12},
  ["UngoroCrater"] = {18, 1, 27},
  ["Winterspring"] = {19, 1, 28},
  ["Moonglade"] = {20, 1, 13},
  ["Darnassus"] = {21, 1, 7},
  ["Mulgore"] = {22, 1, 15},
  ["ThunderBluff"] = {23, 1, 25},
  ["Teldrassil"] = {24, 1, 22},
  ["Ironforge"] = {25, 2, 14},
  ["Badlands"] = {27, 2, 3},
  ["DunMorogh"] = {28, 2, 7},
  ["LochModan"] = {29, 2, 17},
  ["Redridge"] = {30, 2, 19},
  ["Duskwood"] = {31, 2, 8},
  ["SearingGorge"] = {32, 2, 22},
  ["BlastedLands"] = {33, 2, 4},
  ["EasternPlaguelands"] = {34, 2, 9},
  ["Silverpine"] = {35, 2, 25},
  ["StormwindCity"] = {36, 2, 26},
  ["Elwynn"] = {37, 2, 10},
  ["StranglethornVale"] = {38, 2, 27},
  ["Arathi"] = {39, 2, 2},
  ["BurningSteppes"] = {40, 2, 5},
  ["EversongWoods"] = {41, 2, 11},
  ["Hinterlands"] = {42, 2, 30},
  ["Tirisfal"] = {43, 2, 31},
  ["Ghostlands"] = {44, 2, 12},
  ["Undercity"] = {45, 2, 35},
  ["SwampOfSorrows"] = {46, 2, 28},
  ["DeadwindPass"] = {47, 2, 6},
  ["HillsbradFoothills"] = {48, 2, 13},
  ["Westfall"] = {49, 2, 38},
  ["WesternPlaguelands"] = {50, 2, 37},
  ["Wetlands"] = {51, 2, 39},
  ["SilvermoonCity"] = {52, 2, 24},
  ["ShadowmoonValley"] = {53, 3, 5},
  ["BladesEdgeMountains"] = {54, 3, 1},
  ["TerokkarForest"] = {55, 3, 7},
  ["Hellfire"] = {56, 3, 2},
  ["Zangarmarsh"] = {57, 3, 8},
  ["Nagrand"] = {58, 3, 3},
  ["Netherstorm"] = {59, 3, 4},
  ["ShattrathCity"] = {60, 3, 6},
  ["Kalimdor"] = {61, 1, 0},
  ["Azeroth"] = {62, 2, 0},
  ["Expansion01"] = {63, 3, 0},
  ["Sunwell"] = {64, 2, 15},  
  ["BoreanTundra"] = {65, 4, 1},
  ["CrystalsongForest"] = {66, 4, 2},
  ["Dalaran"] = {67, 4, 3},
  ["Dragonblight"] = {68, 4, 4},
  ["GrizzlyHills"] = {69, 4, 5},
  ["HowlingFjord"] = {70, 4, 6},
  ["IcecrownGlacier"] = {71, 4, 8},
  ["SholazarBasin"] = {72, 4, 9},
  ["TheStormPeaks"] = {73, 4, 10},
  ["LakeWintergrasp"] = {74, 4, 11},
  ["ZulDrak"] = {75, 4, 12},
  ["Northrend"] = {76, 4, 0},

  ["HrothgarsLanding"] = {153, 4, 7}, -- wooo consecutive numbering

  ["AhnQirajTheFallenKingdom"] = {158, 1, 1}, 
  ["Hyjal"] = {198, 1, 14}, -- Check
  ["SouthernBarrens"] = {203, 1, 19},
  ["Uldum"] = {164, 1, 26}, -- Check
  ["Uldum_terrain1"] = {210, 1, 26}, -- Check
  ["VashjirDepths"] = {165, 2, 1}, -- Check
  ["VashjirKelpForest"] = {167, 2, 16}, -- Check
  ["StranglethornJungle"] = {168, 2, 18},
  ["RuinsofGilneas"] = {169, 2, 20},
  ["RuinsofGilneasCity"] = {170, 2, 21},
  ["VashjirRuins"] = {171, 2, 23}, -- Check
  ["TheCapeOfStranglethorn"] = {174, 2, 29},
  ["TolBarad"] = {175, 2, 32},
  ["TolBaradDailyArea"] = {176, 2, 33},
  ["TwilightHighlands_terrain1"] = {177, 2, 34},
  ["Vashjir"] = {178, 2, 36}, -- Check
  ["Deepholm"] = {179, 5, 1},
  ["Kezan"] = {180, 5, 2},
  ["TheLostIsles"] = {181, 5, 3},
  ["TheLostIsles_terrain1"] = {208, 5, 3},
  ["TheLostIsles_terrain2"] = {209, 5, 3},
  ["TheMaelstrom"] = {182, 5, 4},
  ["TheMaelstromContinent"] = {183, 5, 0},
  ["TwilightHighlands"] = {184, 2, 34},
  ["Hyjal_terrain1"] = {185, 1, 14},


  ["ScarletEnclave_Continent"] = {77, -77, 0}, ["ScarletEnclave"] = {78, -77, 1},
  
  ["UtgardeKeep1_Continent"] = {79, -80, 0}, ["UtgardeKeep1"] = {80, -80, 1},
  ["UtgardeKeep2_Continent"] = {81, -81, 0}, ["UtgardeKeep2"] = {82, -81, 1},
  ["UtgardeKeep3_Continent"] = {83, -82, 0}, ["UtgardeKeep3"] = {84, -82, 1},
  
  ["TheNexus_Continent"] = {85, -83, 0}, ["TheNexus"] = {86, -83, 1},
  
  ["AzjolNerub1_Continent"] = {87, -84, 0}, ["AzjolNerub1"] = {88, -84, 1},
  ["AzjolNerub2_Continent"] = {89, -85, 0}, ["AzjolNerub2"] = {90, -85, 1},
  ["AzjolNerub3_Continent"] = {91, -86, 0}, ["AzjolNerub3"] = {92, -86, 1},
  
  ["Ahnkahet_Continent"] = {93, -87, 0}, ["Ahnkahet"] = {94, -87, 1},
  
  ["DrakTharonKeep1_Continent"] = {95, -88, 0}, ["DrakTharonKeep1"] = {96, -88, 1},
  ["DrakTharonKeep2_Continent"] = {97, -89, 0}, ["DrakTharonKeep2"] = {98, -89, 1},
  
  ["VioletHold_Continent"] = {99, -90, 0}, ["VioletHold"] = {100, -90, 1},
  
  ["Gundrak_Continent"] = {101, -91, 0}, ["Gundrak"] = {102, -91, 1},
  
  ["Ulduar77_Continent"] = {103, -92, 0}, ["Ulduar77"] = {104, -92, 1}, -- HoS
  
  ["HallsofLightning1_Continent"] = {105, -93, 0}, ["HallsofLightning1"] = {106, -93, 1},
  ["HallsofLightning2_Continent"] = {107, -94, 0}, ["HallsofLightning2"] = {108, -94, 1},
  
  ["Nexus801_Continent"] = {109, -95, 0}, ["Nexus801"] = {110 , -95, 1},
  ["Nexus802_Continent"] = {111, -96, 0}, ["Nexus802"] = {112, -96, 1},
  ["Nexus803_Continent"] = {113, -97, 0}, ["Nexus803"] = {114, -97, 1},
  ["Nexus804_Continent"] = {115, -98, 0}, ["Nexus804"] = {116, -98, 1},
  
  ["CoTStratholme1_Continent"] = {117, -99, 0}, ["CoTStratholme1"] = {118, -99, 1},
  ["CoTStratholme2_Continent"] = {119, -100, 0}, ["CoTStratholme2"] = {120, -100, 1},
  
  ["UtgardePinnacle1_Continent"] = {121, -101, 0}, ["UtgardePinnacle1"] = {122, -101, 1},
  ["UtgardePinnacle2_Continent"] = {123, -102, 0}, ["UtgardePinnacle2"] = {124, -102, 1},
  
  ["VaultofArchavon_Continent"] = {125, -103, 0}, ["VaultofArchavon"] = {126, -103, 1},
  
  ["Naxxramas1_Continent"] = {127, -104, 0}, ["Naxxramas1"] = {128, -104, 1},
  ["Naxxramas2_Continent"] = {129, -105, 0}, ["Naxxramas2"] = {130, -105, 1},
  ["Naxxramas3_Continent"] = {131, -106, 0}, ["Naxxramas3"] = {132, -106, 1},
  ["Naxxramas4_Continent"] = {133, -107, 0}, ["Naxxramas4"] = {134, -107, 1},
  ["Naxxramas5_Continent"] = {135, -108, 0}, ["Naxxramas5"] = {136, -108, 1},
  ["Naxxramas6_Continent"] = {137, -109, 0}, ["Naxxramas6"] = {138, -109, 1},
  
  ["TheObsidianSanctum_Continent"] = {139, -110, 0}, ["TheObsidianSanctum"] = {140, -110, 1},
  
  ["TheEyeOfEternity_Continent"] = {141, -111, 0}, ["TheEyeOfEternity"] = {142, -111, 1},
  
  ["Ulduar_Continent"] = {143, -112, 0}, ["Ulduar"] = {144, -112, 1},
  ["Ulduar1_Continent"] = {145, -113, 0}, ["Ulduar1"] = {146, -113, 1},
  ["Ulduar2_Continent"] = {147, -114, 0}, ["Ulduar2"] = {148, -114, 1},
  ["Ulduar3_Continent"] = {149, -115, 0}, ["Ulduar3"] = {150, -115, 1},
  ["Ulduar4_Continent"] = {151, -116, 0}, ["Ulduar4"] = {152, -116, 1},
  
  ["TheForgeofSouls_Continent"] = {154, -117, 0}, ["TheForgeofSouls"] = {155, -117, 1},
  ["PitofSaron_Continent"] = {156, -118, 0}, ["PitofSaron"] = {157, -118, 1},
  ["GilneasCity_Continent"] = {204, -78, 0}, ["GilneasCity"] = {205, -78, 1},
  ["GilneasZone_Continent"] = {206, -79, 0}, ["GilneasZone"] = {207, -79, 1},



  -- yes virginia 183 is currently the end

}

QuestHelper_RestrictedZones = { -- Everything defaults to "nil"
  [78] = 1,
  [205] = 1,
  [207] = 1,
}

local next_index = 1
for i, j in pairs(QuestHelper_IndexLookup) do next_index = math.max(next_index, j[1]+1) end

-- Maps zone names and indexes to a two element array, containing zone index a continent/zone
QuestHelper_ZoneLookup = {}

-- Maps indexes to zone names.
QuestHelper_NameLookup = {}

-- Maps plane indexes to the ultimate continent parents
QuestHelper_ParentLookup = {}

local built = false

function QuestHelper_BuildZoneLookup()
  if built then return end
  built = true
  
  local cartugh
  if Cartographer_Notes and not Cartographer_Notes.fixed_that_bug_that_causes_POI_to_crash_when_you_change_to_hrothgars_landing then
    cartugh = Cartographer_Notes.SetNote
    Cartographer_Notes.SetNote = function () end -- cartographer why are you terrible
  end
  
  if GetMapContinents and GetMapZones then
    -- Called from inside the WoW client.
    
    local original_lookup, original_zones = QuestHelper_IndexLookup, QuestHelper_Zones
    QuestHelper_IndexLookup = {}
    QuestHelper_Zones = {}
    
    for c, cname in pairs(QuestHelper.Astrolabe:GetMapVirtualContinents()) do
      QuestHelper_Zones[c] = {}
      local tpx = QuestHelper.Astrolabe:GetMapVirtualZones(c)
      tpx[0] = cname

      for z, zname in pairs(tpx) do
        
        local base_name = QuestHelper.Astrolabe:GetMapTexture(c, z)

        local index = original_lookup[base_name] and original_lookup[base_name][1]
        local altered_index = "!!! QuestHelper_IndexLookup entry needs update: [%q] = {%s, %s, %s}"
        local altered_zone = "!!! QuestHelper_Zones entry needs update: [%s][%s] = %q -- was %s"
        
        if not index and my_version == "4.0.6.$svnversion\$" then
          QuestHelper_ErrorCatcher_ExplicitError(false, altered_index:format(tostring(base_name), tostring(next_index), tostring(c), tostring(z)))
          next_index = next_index + 1
        else
          if QuestHelper_Locale == "enUS" and my_version == "4.0.6.161r" then
            if original_lookup[base_name][2] ~= c or original_lookup[base_name][3] ~= z then
              QuestHelper_ErrorCatcher_ExplicitError(false, altered_index:format(base_name, index, c, z))
            end
            
            if not original_zones[c] or original_zones[c][z] ~= zname then
              QuestHelper_ErrorCatcher_ExplicitError(false, altered_zone:format(c, z, zname, original_zones[c] and original_zones[c][z] or "missing"))
              --QuestHelper:TextOut(altered_zone:format(c, z, zname, original_zones[c] and original_zones[c][z] or "missing"))
            end
          end
          
          local pair = {c, z}
          if not QuestHelper_IndexLookup[c] then QuestHelper_IndexLookup[c] = {} end
          QuestHelper_IndexLookup[c][z] = index
          QuestHelper_IndexLookup[zname] = index
          
          QuestHelper_NameLookup[index] = zname
          
          QuestHelper_ZoneLookup[zname] = pair
          QuestHelper_ZoneLookup[index] = pair
          
          QuestHelper_Zones[c][z] = zname
        end
      end
    end
    
    for name, index in pairs(original_lookup) do
      if index[2] == -1 then
        --assert(not QuestHelper_IndexLookup[name])
        QuestHelper_IndexLookup[name] = index[1]
      end
    end
    
    for k, v in pairs(QuestHelper_ZoneLookup) do
      if type(k) == "number" then
        --QuestHelper:TextOut(tostring(k) .. " " .. tostring(v[1]))
        if v[1] == 1 or v[1] == 2 or v[1] == 4 or v[1] == 5 then  -- weh
          QuestHelper_ParentLookup[k] = 0
        else
          QuestHelper_ParentLookup[k] = v[1]
        end
      end
    end
-- Sanity is failing BEFORE exiting the function... Duplicate indices... owa tagu siam. This is now true ONLY for non enUS version (grumble).
    QuestHelper:Assert(QuestHelper:ZoneSanity())
  else
    -- Called from some lua script.
    local original_lookup = QuestHelper_IndexLookup
    QuestHelper_IndexLookup = {}
    
    for base_name, i in pairs(original_lookup) do
      local index = i[1]
      local pair = {i[2], i[3]}
      local name = QuestHelper_Zones[pair[1]][pair[2]]
      
      --assert(index and name)
      
      if not QuestHelper_IndexLookup[pair[1]] then QuestHelper_IndexLookup[pair[1]] = {} end
      QuestHelper_IndexLookup[pair[1]][pair[2]] = index
      QuestHelper_IndexLookup[name] = index
      
      QuestHelper_NameLookup[index] = name
      
      QuestHelper_ZoneLookup[name] = pair
      QuestHelper_ZoneLookup[index] = pair
    end
    QuestHelper:Assert(QuestHelper:ZoneSanity())
  end
  
  if Cartographer_Notes and not Cartographer_Notes.fixed_that_bug_that_causes_POI_to_crash_when_you_change_to_hrothgars_landing then
    Cartographer_Notes.SetNote = cartugh
  end
  -- We are broken by the time we get here. Time to turn these TextOut's to Errors.
  QuestHelper:Assert(QuestHelper:ZoneSanity())
end

local convert_lookup =
 {{2, 15, 3, 9, 16, 21, 4, 7, 10, 13, 17, 20, 22, 1, 5, 6, 8, 24, 11, 12, 14, 23, 18, 19},
  {26, 39, 27, 33, 40, 47, 28, 31, 34, 37, 41, 44, 48, 25, 29, 30, 32, 52, 35, 36, 38, 46, 42, 43, 45, 50, 49, 51},
  {54, 56, 58, 59, 53, 60, 55, 57}}

function QuestHelper_ValidPosition(c, z, x, y)
  return type(x) == "number" and type(y) == "number" and x > -0.1 and y > -0.1 and x < 1.1 and y < 1.1 and c and convert_lookup[c] and z and convert_lookup[c][z] and true
end

function QuestHelper_PrunePositionList(list)
  if type(list) ~= "table" then
    return nil
  end
  
  local i = 1
  while i <= #list do
    local pos = list[i]
    if QuestHelper_ValidPosition(unpack(list[i])) and type(pos[5]) == "number" and pos[5] >= 1 then
      i = i + 1
    else
      local rem = table.remove(list, i)
    end
  end
  
  return #list > 0 and list or nil
end

local function QuestHelper_ConvertPosition(pos)
  pos[2] = convert_lookup[pos[1]][pos[2]]
  table.remove(pos, 1)
end

local function QuestHelper_ConvertPositionList(list)
  if list then
    for i, pos in pairs(list) do
      QuestHelper_ConvertPosition(pos)
    end
  end
end

local function QuestHelper_ConvertFaction(faction)
  if faction == 1 or faction == "Alliance" or faction == FACTION_ALLIANCE then return 1
  elseif faction == 2 or faction == "Horde" or faction == FACTION_HORDE then return 2
  else
    --assert(false, "Unknown faction: "..faction.."'")
  end
end

function QuestHelper_UpgradeDatabase(data)
  if data.QuestHelper_SaveVersion == 1 then
    
    -- Reputation objectives weren't parsed correctly before.
    if data.QuestHelper_Objectives["reputation"] then
      for faction, objective in pairs(data.QuestHelper_Objectives["reputation"]) do
        local real_faction = string.find(faction, "%s*(.+)%s*:%s*") or faction
        if faction ~= real_faction then
          data.QuestHelper_Objectives["reputation"][real_faction] = data.QuestHelper_Objectives["reputation"][faction]
          data.QuestHelper_Objectives["reputation"][faction] = nil
        end
      end
    end
    
    -- Items that wern't in the local cache when I read the quest log ended up with empty names.
    if data.QuestHelper_Objectives["item"] then
      data.QuestHelper_Objectives["item"][" "] = nil
    end
    
    data.QuestHelper_SaveVersion = 2
  end
  
  if data.QuestHelper_SaveVersion == 2 then
    
    -- The hashes for the quests were wrong. Damnit!
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.hash = nil
          quest_data.alt = nil
        end
      end
    end
    
    -- None of the information I collected about quest items previously can be trusted.
    -- I also didn't properly mark quest items as such, so I'll have to remove the information for non
    -- quest items also.
    
    if data.QuestHelper_Objectives["item"] then
      for item, item_data in pairs(data.QuestHelper_Objectives["item"]) do
        -- I'll remerge the bad data later if I find out its not used solely for quests.
        item_data.bad_pos = item_data.bad_pos or item_data.pos
        item_data.bad_drop = item_data.bad_drop or item_data.drop
        item_data.pos = nil
        item_data.drop = nil
        
        -- In the future i'll delete the bad_x data.
        -- When I do, either just delete it, or of all the monsters or positions match the monsters and positions of the
        -- quest, merge them into that.
      end
    end
    
    data.QuestHelper_SaveVersion = 3
  end
  
  if data.QuestHelper_SaveVersion == 3 then
    -- We'll go through this and make sure all the position lists are correct.
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.pos = QuestHelper_PrunePositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              data.pos = QuestHelper_PrunePositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        data.pos = QuestHelper_PrunePositionList(data.pos)
      end
    end
    
    if data.QuestHelper_ZoneTransition then
      for c, z1list in pairs(data.QuestHelper_ZoneTransition) do
        for z1, z2list in pairs(z1list) do
          for z2, poslist in pairs(z2list) do
            z2list[z2] = QuestHelper_PrunePositionList(poslist)
          end
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 4
  end
  
  if data.QuestHelper_SaveVersion == 4 then
    -- Zone transitions have been obsoleted by a bug.
    data.QuestHelper_ZoneTransition = nil
    data.QuestHelper_SaveVersion = 5
  end
  
  if data.QuestHelper_SaveVersion == 5 then
    -- For version 6, I'm converting area positions from a continent/zone index pair to a single index.
    
    if data.QuestHelper_FlightRoutes then
      local old_routes = data.QuestHelper_FlightRoutes
      data.QuestHelper_FlightRoutes = {}
      for c, value in pairs(old_routes) do
        data.QuestHelper_FlightRoutes[QuestHelper_IndexLookup[c][0]] = value
      end
    end
    
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          QuestHelper_ConvertPositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            QuestHelper_ConvertPositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            QuestHelper_ConvertPositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              QuestHelper_ConvertPositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        QuestHelper_ConvertPositionList(data.pos)
      end
    end
    
    data.QuestHelper_SaveVersion = 6
  end
  
  if data.QuestHelper_SaveVersion == 6 then
    -- Redoing how flightpaths work, previously collected flightpath data is now obsolete.
    data.QuestHelper_FlightRoutes = {}
    
    -- FlightInstructors table should be fine, will leave it.
    -- Upgrading per-character data is handled in main.lua.
    
    -- Also converting factions to numbers, 1 for Alliance, 2 for Horde.
    local replacement = {}
    for faction, dat in pairs(data.QuestHelper_Quests) do
      replacement[QuestHelper_ConvertFaction(faction)] = dat
    end
    data.QuestHelper_Quests = replacement
    
    replacement = {}
    if data.QuestHelper_FlightInstructors then for faction, dat in pairs(data.QuestHelper_FlightInstructors) do
      replacement[QuestHelper_ConvertFaction(faction)] = dat
    end end
    data.QuestHelper_FlightInstructors = replacement
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if obj.faction then
          obj.faction = QuestHelper_ConvertFaction(obj.faction)
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 7
  end
  
  if data.QuestHelper_SaveVersion == 7 then
    -- It sure took me long enough to discover that I broke vendor objectives.
    -- their factions were strings and didn't match the number value of QuestHelper.faction
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if type(obj.faction) == "string" then
          obj.faction = (obj.faction == "Alliance" and 1) or (obj.faction == "Horde" and 2) or nil
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 8
  end
  
  if data.QuestHelper_SaveVersion == 8 then
    -- Two things we're doing here
    -- First, wrath-ize Stormwind coordinates
    
    --[[
    for cat, list in pairs(QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if obj.pos then
          for i, cpos in pairs(obj.pos) do
            QuestHelper_ConvertCoordsToWrath(cpos, true)
          end
        end
      end
    end]] -- okay we're not actually doing this, coordinates are staying native
    
    -- Second, split up the entire thing into versions
    local function versionize(item)
      --if not item or type(item) ~= "table" then return end  -- blue magician doesn't know what the fuck
      
      local temp = {}
      local foundthings = false
      for k, v in pairs(item) do
        temp[k] = v
        foundthings = true
      end
      if not foundthings then return end -- just to avoid extra keys hanging around in people's tables
      
      for key in pairs(item) do
        item[key] = nil
      end
      
      item["unknown on unknown"] = temp
    end
    
    versionize(data.QuestHelper_Quests)
    versionize(data.QuestHelper_Objectives)
    versionize(data.QuestHelper_FlightInstructors)
    versionize(data.QuestHelper_FlightRoutes)
    
    data.QuestHelper_SaveVersion = 9
  end
  
  if data.QuestHelper_SaveVersion == 9 then
    -- The only thing we're doing here is moving the QuestHelper_ErrorList into QuestHelper_Errors
    data.QuestHelper_Errors = {}
    data.QuestHelper_Errors.crashes = {}
    
    if data.QuestHelper_ErrorList then
      for k, v in pairs(data.QuestHelper_ErrorList) do
        data.QuestHelper_Errors.crashes[k] = v
      end
    end
    
    data.QuestHelper_ErrorList = nil
    
    data.QuestHelper_SaveVersion = 10
  end
end

function QuestHelper_UpgradeComplete()
  -- This function deletes everything related to upgrading, as it isn't going to be needed again.
  built = nil
  next_index = nil
  convert_lookup = nil
  QuestHelper_BuildZoneLookup = nil
  QuestHelper_ValidPosition = nil
  QuestHelper_PrunePositionList = nil
  QuestHelper_ConvertPosition = nil
  QuestHelper_ConvertPositionList = nil
  QuestHelper_ConvertFaction = nil
  QuestHelper_UpgradeDatabase = nil
  QuestHelper_UpgradeComplete = nil
end

-- These are used to convert coordinates back and forth from "Wrath" to "Native". "Force" is used to convert back and forth from "Wrath" to "BC".
-- Both changes the data in-place and returns the data.
function QuestHelper_ConvertCoordsToWrath(data, force)
  if force then
    if data[1] == 36 then -- Stormwind
      data[2] = data[2] * 0.77324 + 0.197
      data[3] = data[3] * 0.77324 + 0.245
    elseif data[1] == 34 then -- EPL
      data[2] = data[2] * 0.960 - 0.0254
      data[3] = data[3] * 0.960 - 0.03532
    end
  end
  return data
end

function QuestHelper_ConvertCoordsFromWrath(data, force)
  if force then
    if data[1] == 36 then -- Stormwind
      data[2] = (data[2] - 0.197) / 0.77324
      data[3] = (data[3] - 0.245) / 0.77324
    elseif data[1] == 34 then -- EPL
      data[2] = (data[2] + 0.0254) / 0.960
      data[3] = (data[3] + 0.03532) / 0.960
    end
  end
  return data
end

local QuestHelper_PrivateServerBlacklist_Find = {
  "WoWFusion",
  "WoWgasm",
  "Egyéb",
  "Reagens/",
}

local QuestHelper_PrivateServerBlacklist_Exact = {
  "WarcraftMMO",
  "TAXI",
  "GeNiuS",
  "Columbian Drug Dealer",
  "PlayBoy Fun Vendor",
  "Gm Vendor",
  "Accessories Vendor",
  "General Goods Vendor",
  "Party Vendor",
  "Potion Vendor",
  "Totem Vendor",
  "Gm Vendor",
  "Misc",
  "Off-Hands Vendor",
  "Ore Vendor",
  "Enchanting Vendor",
  "Gem Vendor",
  "Fooooood and Drinks!",
  "I Sell Consumables",
  "Armor Raid Tier V",
  "world translate",
  "Bobby", -- I have no idea if this is an actual private server NPC
  "Nejeib", -- same
  "Shaman Set Vendor",
  "Warrior Set Vendor",
  "Priest Set Vendor",
  "Warlock Set Vendor",
  "Paladin Set Vendor",
  "Hunter Set Vendor",
  "Mage Set Vendor",  -- yeah yeah this isn't everyone whatever
}

local matchstring = nil

function QuestHelper_IsPolluted(input)
  if not input then input = _G end
  
  for version, data in pairs(input.QuestHelper_Objectives) do
    for cat, name_list in pairs(data) do
      for name, obj in pairs(name_list) do
        for k, v in pairs(QuestHelper_PrivateServerBlacklist_Find) do
          if string.find(name, v) then
            for _, __ in pairs(obj) do
              return true -- if there's nothing actually in the object, the player may not have contributed data, he may have just gotten smacked by old corrupted data.
            end
          end
        end
        for k, v in pairs(QuestHelper_PrivateServerBlacklist_Exact) do
          if name == v then
            for _, __ in pairs(obj) do
              return true -- if there's nothing actually in the object, the player may not have contributed data, he may have just gotten smacked by old corrupted data.
            end
          end
        end
      end
    end
  end
end

