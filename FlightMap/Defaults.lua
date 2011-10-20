-- Default neutral data sets for FlightMap
--
-- Some default flight times thanks to Krwaz, author of FlightPath.
-- 
-- This file is loaded after the localisations

-- Prepare LibBabble
local B = LibStub('LibBabble-Zone-3.0');
BabbleZone = B:GetLookupTable();

-- Default options
FLIGHTMAP_DEFAULT_OPTS = {
     ["showPaths"]   = true,
     ["showPOIs"]    = true,
     ["showAllInfo"] = false,
     ["useTimer"]    = true,
     ["showCosts"]   = false,
     ["showTimes"]   = false,
     ["fullTaxiMap"] = true,
     ["largerTimer"] = false,
     ["xlTimer"] = false,
};

-- Sub-zones
FLIGHTMAP_SUBZONES = {
    [BabbleZone["Orgrimmar"]]     = BabbleZone["Durotar"],
    [BabbleZone["Thunder Bluff"]] = BabbleZone["Mulgore"],
    [BabbleZone["Undercity"]]     = BabbleZone["Tirisfal Glades"],
    [BabbleZone["Ironforge"]]     = BabbleZone["Dun Morogh"],
    [BabbleZone["Stormwind"]]     = BabbleZone["Elwynn Forest"],
    [BabbleZone["Shattrath"]]     = BabbleZone["Terokkar Forest"],
    [BabbleZone["Dalaran"]]       = BabbleZone["Crystalsong Forest"],
};

FlightMap = {
    ["Opts"]             = FLIGHTMAP_DEFAULT_OPTS,
    ["Knowledge"]        = {},
};
