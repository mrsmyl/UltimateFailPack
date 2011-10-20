--
-- FlightMap - AddOn to show inbound and outbound flightpaths from a given
--             zone on the World Map.  Additionally shows flight costs and
--             zone level ranges.
-- Copyright (c) 2005-2007 Byron Ellacott (Dhask of Uther)
-- Copyright (c) 2009-2010 Moncai
--
-- An unlimited license to use, reproduce and copy this work is granted, on
-- the condition that the licensee accepts all responsibility and liability
-- for any damage that may arise from the use of this AddOn.

-- Version number
FLIGHTMAP_VERSION   = "4.0.1";

-- Size and names for path texture files
FLIGHTMAP_LINE_SIZE = 256;
FLIGHTMAP_TEX_UP    = "Interface\\AddOns\\FlightMap\\FlightMapUp";
FLIGHTMAP_TEX_DOWN  = "Interface\\AddOns\\FlightMap\\FlightMapDown";

-- How many pixels is too close to another POI?
FLIGHTMAP_CLOSE     = 16;

-- Textures for flightmaster POI icons
FLIGHTMAP_POI_KNOWN = "Interface\\TaxiFrame\\UI-Taxi-Icon-Green";
FLIGHTMAP_POI_OTHER = "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray";

local lTYPE_HORDE     = FLIGHTMAP_HORDE;
local lTYPE_ALLIANCE  = FLIGHTMAP_ALLIANCE;
local lTYPE_CONTESTED = FLIGHTMAP_CONTESTED;
local lTYPE_NEUTRAL   = FLIGHTMAP_NEUTRAL;

local B = LibStub('LibBabble-Zone-3.0');
BabbleZone = B:GetLookupTable();

-- Level areas are added from Metaux - Antonidas
-- According to http://www.worldofwarcraft.com/ at any rate...

FLIGHTMAP_RANGES   = {
    [BabbleZone["Elwynn Forest"]]        = { 1, 10, lTYPE_ALLIANCE},
    [BabbleZone["Eversong Woods"]]     = { 1, 10, lTYPE_HORDE},
    [BabbleZone["Dun Morogh"]]     = { 1, 10, lTYPE_ALLIANCE},
    [BabbleZone["Tirisfal Glades"]]      = { 1, 10, lTYPE_HORDE},
    [BabbleZone["Ghostlands"]]    = {10, 20, lTYPE_HORDE},
    [BabbleZone["Loch Modan"]]     = {10, 20, lTYPE_ALLIANCE},
    [BabbleZone["Silverpine Forest"]]    = {10, 20, lTYPE_HORDE},
    [BabbleZone["Westfall"]]      = {10, 20, lTYPE_ALLIANCE},
    [BabbleZone["Redridge Mountains"]]      = {15, 25, lTYPE_CONTESTED},
    [BabbleZone["Duskwood"]]      = {18, 30, lTYPE_CONTESTED},
    [BabbleZone["Hillsbrad Foothills"]]     = {20, 30, lTYPE_CONTESTED},
    [BabbleZone["Wetlands"]]      = {20, 30, lTYPE_CONTESTED},
    [BabbleZone["Alterac Mountains"]]       = {30, 40, lTYPE_CONTESTED},
    [BabbleZone["Arathi Highlands"]]        = {30, 40, lTYPE_CONTESTED},
    [BabbleZone["Stranglethorn Vale"]] = {30, 45, lTYPE_CONTESTED},
    [BabbleZone["Badlands"]]      = {35, 45, lTYPE_CONTESTED},
    [BabbleZone["Swamp of Sorrows"]]       = {35, 45, lTYPE_CONTESTED},
    [BabbleZone["The Hinterlands"]]   = {40, 50, lTYPE_CONTESTED},
    [BabbleZone["Searing Gorge"]]  = {43, 50, lTYPE_CONTESTED},
    [BabbleZone["Blasted Lands"]]  = {45, 55, lTYPE_CONTESTED},
    [BabbleZone["Burning Steppes"]] = {50, 58, lTYPE_CONTESTED},
    [BabbleZone["Western Plaguelands"]] = {51, 58, lTYPE_CONTESTED},
    [BabbleZone["Eastern Plaguelands"]] = {53, 60, lTYPE_CONTESTED},
    [BabbleZone["Deadwind Pass"]]  = {55, 60, lTYPE_CONTESTED},
    [BabbleZone["Isle of Quel'Danas"]]     = {70, 70, lTYPE_CONTESTED},
    
    [BabbleZone["Azuremyst Isle"]]     = { 1, 10, lTYPE_ALLIANCE},
    [BabbleZone["Teldrassil"]]    = { 1, 10, lTYPE_ALLIANCE},
    [BabbleZone["Durotar"]]       = { 1, 10, lTYPE_HORDE},
    [BabbleZone["Mulgore"]]       = { 1, 10, lTYPE_HORDE},
    [BabbleZone["Bloodmyst Isle"]]     = {10, 20, lTYPE_ALLIANCE},
    [BabbleZone["Darkshore"]]     = {10, 20, lTYPE_ALLIANCE},
    [BabbleZone["The Barrens"]]       = {10, 25, lTYPE_HORDE},
    [BabbleZone["Stonetalon Mountains"]]    = {15, 27, lTYPE_CONTESTED},
    [BabbleZone["Ashenvale"]]     = {18, 30, lTYPE_CONTESTED},
    [BabbleZone["Thousand Needles"]]     = {25, 35, lTYPE_CONTESTED},
    [BabbleZone["Desolace"]]      = {30, 40, lTYPE_CONTESTED},
    [BabbleZone["Dustwallow Marsh"]]    = {35, 45, lTYPE_CONTESTED},
    [BabbleZone["Feralas"]]       = {40, 50, lTYPE_CONTESTED},
    [BabbleZone["Tanaris"]]       = {40, 50, lTYPE_CONTESTED},
    [BabbleZone["Azshara"]]       = {45, 55, lTYPE_CONTESTED},
    [BabbleZone["Felwood"]]       = {48, 55, lTYPE_CONTESTED},
    [BabbleZone["Un'Goro Crater"]]  = {48, 55, lTYPE_CONTESTED},
    [BabbleZone["Silithus"]]      = {55, 60, lTYPE_CONTESTED},
    [BabbleZone["Winterspring"]]  = {55, 60, lTYPE_CONTESTED},
    [BabbleZone["Moonglade"]]     = { 1, 60, lTYPE_CONTESTED},
    
    [BabbleZone["Hellfire Peninsula"]]   = {58, 63, lTYPE_CONTESTED},
    [BabbleZone["Zangarmarsh"]]   = {60, 64, lTYPE_CONTESTED},
    [BabbleZone["Terokkar Forest"]]      = {62, 65, lTYPE_CONTESTED},
    [BabbleZone["Nagrand"]]       = {64, 68, lTYPE_CONTESTED},
    [BabbleZone["Blade's Edge Mountains"]]   = {65, 68, lTYPE_CONTESTED},
    [BabbleZone["Netherstorm"]]   = {67, 70, lTYPE_CONTESTED},
    [BabbleZone["Shadowmoon Valley"]]   = {67, 70, lTYPE_CONTESTED},
    
    [BabbleZone["Borean Tundra"]]      = {68, 72, lTYPE_CONTESTED},
    [BabbleZone["Howling Fjord"]]  = {68, 72, lTYPE_CONTESTED},
    [BabbleZone["Dragonblight"]]  = {71, 74, lTYPE_CONTESTED},
    [BabbleZone["Grizzly Hills"]]  = {73, 75, lTYPE_CONTESTED},
    [BabbleZone["Zul'Drak"]]       = {74, 77, lTYPE_CONTESTED},
    [BabbleZone["Sholazar Basin"]]    = {76, 78, lTYPE_CONTESTED},
    [BabbleZone["Crystalsong Forest"]]   = {77, 80, lTYPE_CONTESTED},
    [BabbleZone["The Storm Peaks"]]    = {77, 80, lTYPE_CONTESTED},
    [BabbleZone["Icecrown"]]      = {77, 80, lTYPE_CONTESTED},
    [BabbleZone["Wintergrasp"]]   = {77, 80, lTYPE_CONTESTED},
};

-- Colours for zones
FLIGHTMAP_COLORS = {
    Unknown   = { r = 0.8, g = 0.8, b = 0.8 },
    Hostile   = { r = 0.9, g = 0.2, b = 0.2 },
    Friendly  = { r = 0.2, g = 0.9, b = 0.2 },
    Contested = { r = 0.8, g = 0.6, b = 0.4 },
};

------------------ Data access functions ------------------

local function lStripPoint(map, point)
    for k, v in pairs(map) do
        if v.Costs then v.Costs[point] = nil; end
        if v.Flights then v.Flights[point] = nil; end
    end
    for k, v in pairs(FlightMap.Knowledge) do
        v[point] = nil;
    end
    map[point] = nil;
end

-- Attempt to move a node to a new taxi map position
local function lRelocateNode(newkey, name)
    local map = FlightMapUtil.getFlightMap();

    for k, v in pairs(map) do
        -- Same name, different key, it's probably moved
        if k ~= newkey and v.Name == name then
            -- Rename node
            map[newkey] = map[k];
            map[k] = nil;
            -- Adjust costs, times and routes
            for l, b in pairs(map) do
                map[l].Costs[newkey] = map[l].Costs[k];
                map[l].Costs[k] = nil;
                map[l].Flights[newkey] = map[l].Flights[k];
                map[l].Flights[k] = nil;
                if map[l].Routes then
                    map[l].Routes[newkey] = map[l].Routes[k];
                    map[l].Routes[k] = nil;
                    for _, r in pairs(map[l].Routes) do
                        for n, m in pairs(r) do
                            if m == k then r[n] = newkey; end
                        end
                    end
                end
            end
            -- Remap knowledge
            for _, knows in pairs(FlightMap.Knowledge) do
                knows[newkey] = knows[k];
                knows[k] = nil;
            end
        end
    end
end

local function lOnUpdateSetting(option)
	if option == "largerTimer" or option == "xlTimer" then	
		if  FlightMap.Opts.xlTimer then
			FM_Resize(300)
		elseif FlightMap.Opts.largerTimer then
			FM_Resize(250)
		else
			FM_Resize(195)
		end
	end
end

local function lSetDefaultData()
    -- Create an empty knowledge record
    if not FlightMap["Knowledge"] then
        FlightMap.Knowledge = {};
    end

    -- Default option settings
    if (not FlightMap["Opts"]) then
        FlightMap["Opts"] = FLIGHTMAP_DEFAULT_OPTS;
    end

    -- Any options that don't have a value at all should be defaulted
    for k, v in pairs(FLIGHTMAP_DEFAULT_OPTS) do
	lOnUpdateSetting(k) -- just to be sure, update here.
        if FlightMap.Opts[k] == nil then
            FlightMap.Opts[k] = v;
        end
    end

    -- Make sure there's a GossipFlights structure
    if not FlightMap["GossipFlights"] then
        FlightMap["GossipFlights"] = {};
    end

    -- Revision 1.8-2: Delete pre-1.7 data
    FlightMap.Locs = nil;
    FlightMap.Times = nil;

    -- Revision 3.0-1: Delete pre-3.0 data
    if not FlightMap.build or FlightMap.build < 9138 then
        FlightMap[FLIGHTMAP_HORDE] = nil;
        FlightMap[FLIGHTMAP_ALLIANCE] = nil;
        FlightMap.build = 9138;
    end

    -- Revision 3.0-2: remove Coldarra Ledge and the second Argent Stand
    lStripPoint(FlightMap[FLIGHTMAP_HORDE] or {}, "4:720:593");
    lStripPoint(FlightMap[FLIGHTMAP_HORDE] or {}, "4:75:508");
end

-- Learn about the currently open taxi map
local function lLearnTaxiNode()
    -- Get the faction appropriate map
    local map = FlightMapUtil.getFlightMap();

    -- Save the old map settings
    local oldCont, oldZone = GetCurrentMapContinent(),
                             GetCurrentMapZone();

    -- Ensure the map is set to the right place
    SetMapToCurrentZone();

    -- Get the current continent number
    local thisCont = GetCurrentMapContinent();

    -- Extract the taxi map information
    local thisNode;
    local destinations = {};
    local numNodes = NumTaxiNodes();
    for index = 1, numNodes, 1 do
        local tType = TaxiNodeGetType(index);
        if (tType == "CURRENT") then
            thisNode = index;
        elseif (tType == "REACHABLE") then
            local mx, my = TaxiNodePosition(index);
            local destName = FlightMapUtil.makeNodeName(thisCont, mx, my);

            -- Add to list of destinations
            destinations[destName] = index;

            -- Has this node been moved?
            lRelocateNode(destName, TaxiNodeName(index));

            -- Note that the character knows of this node
            FlightMapUtil.knownNode(destName, true);

            -- Create a dummy entry if the node isn't known.  This helps
            -- prevent bugs later, and ensures the name is going to be known
            -- pretty much straight away.  Most of the data is pure bunk, of
            -- course, but with a continent number of -1, the node will
            -- generally be ignored.
            if not map[destName] then
                map[destName] = {
                    Name      = "Will be set below",
                    Zone      = "Unknown!",
                    Continent = thisCont,
                    Flights   = {},
                    Costs     = {},
                    Routes    = {},
                    Location  = {
                        Taxi      = { x = mx, y = my },
                        Zone      = { x = 0, y = 0 },
                        Continent = { x = 0, y = 0 },
                    },
                };
            end

            -- Always update the name and location
            map[destName].Name = TaxiNodeName(index);
            map[destName].Location.Taxi = { x = mx, y = my };
        end
    end

    -- If the current node was found (should always be, but... eh.)
    if (thisNode) then
        -- Establish the coded name of this node
        local mx, my = TaxiNodePosition(thisNode);
        local thisName = FlightMapUtil.makeNodeName(thisCont, mx, my);
        local zoneName = FlightMapUtil.getZoneName();
        local zx, zy = GetPlayerMapPosition("player");
        SetMapZoom(thisCont, nil);
        local cx, cy = GetPlayerMapPosition("player");

        -- It might have moved on the taxi map...
        lRelocateNode(thisName, TaxiNodeName(thisNode));

        -- Player knows this node now
        FlightMapUtil.knownNode(thisName, true);

        -- Get, or create, the info structure for the node
        if not map[thisName] then
            map[thisName] = {};
        end
        if not map[thisName].Flights then
            map[thisName].Flights = {};
        end
        if not map[thisName].Costs then
            map[thisName].Costs = {};
        end
        if not map[thisName].Routes then
            map[thisName].Routes = {};
        end

        -- Update all relevant details, to ensure mistakes are fixed
        map[thisName].Name = TaxiNodeName(thisNode);
        map[thisName].Zone = zoneName;
        map[thisName].Continent = thisCont;
        map[thisName].Location = {
            Zone = { x = zx, y = zy },
            Continent = { x = cx, y = cy },
            Taxi = { x = mx, y = my },
        };

        -- Create Costs index field if missing (thorarin@tiwaz.org)
        if not map[thisName].Costs then
            map[thisName].Costs = {};
        end

        -- Record everywhere this node flies to
        for k,v in pairs(destinations) do
            -- Store cost
            map[thisName].Costs[k] = TaxiNodeCost(v);

            -- If it's a multihop, store route and try to estimate time
            local routes = GetNumRoutes(v);
            if routes > 1 then
                local totalTime = 0;
                local prevSpot = thisName;
                local newRoute = {};
                for r = 1, routes do
                    local dest = FlightMapUtil.makeNodeName(thisCont,
                            TaxiGetDestX(v, r), TaxiGetDestY(v, r));
                    table.insert(newRoute, dest);

                    -- Must know last spot, last spot must have a non-zero
                    -- time recorded for the new destination, and all
                    -- previous hops must have also been known
                    if map[prevSpot] and map[prevSpot].Flights[dest]
                        and map[prevSpot].Flights[dest] > 0
                        and totalTime then
                        totalTime = totalTime + map[prevSpot].Flights[dest];
                    else
                        totalTime = nil;
                    end

                    -- Keep track of the last point in the flight chain
                    prevSpot = dest;
                end

                -- Compare this route to the past one stored, if any
                local oldRoute = map[thisName].Routes[k];
                local isNewRoute = not oldRoute
                    or table.getn(oldRoute) ~= table.getn(newRoute)
                    or table.foreachi(newRoute, function(idx)
                        return newRoute[idx] ~= oldRoute[idx];
                    end);

                -- If it's a new route, store the new estimated time no
                -- matter what was there, because what was there is for a
                -- different flight anyway; this might mean the flight time
                -- is removed entirely, but the general set-zero-time case
                -- below will catch that.
                if isNewRoute or map[thisName].Flights[k] == 0 then
                    map[thisName].Flights[k] = totalTime;
                    map[thisName].Routes[k] = newRoute;
                end
            else
                -- Wipe out any previously stored route!
                map[thisName].Routes[k] = nil;
            end

            if not map[thisName].Flights[k] then
                map[thisName].Flights[k] = 0;   -- no duration yet
            end
        end
    end

    -- Don't mess with the user's choice of map zoom!
    SetMapZoom(oldCont, oldZone);
end

------------------ Miscellaneous utility ------------------

local function lAutoDismount()
    if not FlightMap.Opts.autoDismount then return; end

    -- Blizzard does this for me, now
    -- Dismount();
end

------------------ Map drawing functions ------------------

local function lFormatExtra(cost, secs)
    local result = "";
    local separator = "";
    if cost ~= nil and FlightMap.Opts.showCosts then
        local dosh = FlightMapUtil.formatMoney(cost);
        if cost == 0 then dosh = FLIGHTMAP_NO_COST; end
        result = result .. dosh;
        separator = " ";
    end
    if secs ~= nil and FlightMap.Opts.showTimes then
        local durn = FlightMapUtil.formatTime(secs);
        result = result .. separator .. durn;
    end
    return result;
end

-- Add node name and location into the given tooltip.  If the source node is
-- given, also show any stop-off nodes along the way.
local function lAddFlightsForNode(tooltip, node, prefix, source)
    -- Sanitize prefix
    if not prefix then prefix = ""; end

    -- Need a map of flight nodes
    local map = FlightMapUtil.getFlightMap();

    -- Get the node's data
    local data = map[node];
    if not data then return 0; end
    if not data.Costs then data.Costs = {}; end

    -- Get name of node
    local name = data.Name;

    -- And its zone location, if that's known
    local locn = "";
    if data.Location.Zone then
        locn = string.format("%d, %d", data.Location.Zone.x * 100,
                data.Location.Zone.y * 100);
    end

    -- Add that info to the tooltip
    if FlightMapUtil.knownNode(node) then
        tooltip:AddDoubleLine(prefix .. name, locn);
    else
        local r = NORMAL_FONT_COLOR.r * 0.7;
        local g = NORMAL_FONT_COLOR.g * 0.7;
        local b = NORMAL_FONT_COLOR.b * 0.7;
        tooltip:AddDoubleLine(prefix .. name, locn, r, g, b, r, g, b);
    end

    -- Check for a route
    prefix = prefix .. " ";
    if source and map[source] then
        if map[source].Flights[node] then
          local durn = FlightMapUtil.formatTime(map[source].Flights[node]);
          GameTooltip:AddLine(prefix .. FLIGHTMAP_FLIGHTTIME .. durn, 1, 1, 1);
        end
        if map[source].Routes[node] then
            local src = map[source];
            for i = 1, table.getn(src.Routes[node]) - 1 do
                local hop = src.Routes[node][i];
                if map[hop] then
                    GameTooltip:AddLine(prefix..FLIGHTMAP_VIA..map[hop].Name,
                        0.7, 0.7, 0.7);
                end
            end
        end
    end

    -- Check for flights from node
    if not source and FlightMap.Opts.showDestinations then
        for dest, secs in pairs(data.Flights) do
            local islocal = (not data.Routes or not data.Routes[dest]);
            local destData = map[dest];
            if destData and (islocal or FlightMap.Opts.showMultiHop) then
                local name, _ = FlightMapUtil.getNameAndZone(destData.Name);
                local cost = data.Costs[dest];
                local extra = lFormatExtra(cost, secs);
                if FlightMapUtil.knownNode(dest) then
                    tooltip:AddDoubleLine(prefix .. name, extra,
                        1, 1, 1, 1, 1, 1);
                elseif FlightMap.Opts.showAllInfo then
                    tooltip:AddDoubleLine(prefix .. name, extra,
                        0.7, 0.7, 0.7, 0.7, 0.7, 0.7);
                end
            end
         end
    end

    return 1;
end
FlightMapUtil.addFlightsForNode = lAddFlightsForNode;

-- Update the flight tooltip for a zone
local function lUpdateTooltip(self, zoneName)
    -- No zone name, no tooltip!
    if not zoneName or zoneName == "" then
        FlightMapTooltip:Hide();
        return;
    end

    -- Doesn't matter which anchor point we use, none of them are
    -- useful for what FlightMap needs...
    FlightMapTooltip:SetOwner(self, "ANCHOR_LEFT");

    local title = FLIGHTMAP_COLORS.Unknown;
    local levels = nil;
    if (FLIGHTMAP_RANGES[zoneName]) then
        local faction = UnitFactionGroup("player");
        local min = FLIGHTMAP_RANGES[zoneName][1];
        local max = FLIGHTMAP_RANGES[zoneName][2];
        local side = FLIGHTMAP_RANGES[zoneName][3];
        if (side == lTYPE_CONTESTED) then
            title = FLIGHTMAP_COLORS.Contested;
        else
            if (faction == side) then
                title = FLIGHTMAP_COLORS.Friendly;
            else
                title = FLIGHTMAP_COLORS.Hostile;
            end
        end
        levels = string.format(FLIGHTMAP_LEVELS, min, max);
    end

    -- Show the zone title
    local r = NORMAL_FONT_COLOR.r;
    local g = NORMAL_FONT_COLOR.g;
    local b = NORMAL_FONT_COLOR.b;
    FlightMapTooltip:SetText(zoneName, r, g, b);

    if levels then
        FlightMapTooltip:AddLine(levels, title.r, title.g, title.b);
    end

    -- Discover and add all the flights, including subzones
    local nodes = FlightMapUtil.getNodesInZone(zoneName, true);

    -- Outbound flights
    local flights = 0;
    -- FlightMapTooltip:AddLine("\n");
    for node, data in pairs(nodes) do
        if FlightMapUtil.knownNode(node) or FlightMap.Opts.showAllInfo then
            flights = flights + lAddFlightsForNode(FlightMapTooltip, node, "");
        end
    end

    -- This stuff seems to get reset each time, possibly by the SetOwner()
    FlightMapTooltip:SetBackdropColor(0, 0, 0, 0.5);
    FlightMapTooltip:SetBackdropBorderColor(0, 0, 0, 0);
    FlightMapTooltip:ClearAllPoints();
    FlightMapTooltip:SetPoint("BOTTOMLEFT", "WorldMapDetailFrame",
            "BOTTOMLEFT", 0, 0);

    -- Only show if there's flight information or level information
    if flights > 0 or levels then
        FlightMapTooltip:Show();
    else
        FlightMapTooltip:Hide();
    end

    -- Now go ahead and put the tooltip into the right location
    FlightMapTooltip:ClearAllPoints();
    FlightMapTooltip:SetPoint("BOTTOMLEFT", WorldMapDetailFrame);
end

-- Returns true iff an existing world map POI icon is very close to the
-- given coordinates.
local function lCloseToExistingPOI(x, y)
    for i = 1, NUM_WORLDMAP_POIS, 1 do
        local button = _G["WorldMapFramePOI" .. i];
        if button:IsShown() then
            local _, _, index, _, _ = GetMapLandmarkInfo(i);
            -- Index 0 is an invisible POI
            if index ~= 0 then
                local px, py = button:GetCenter();
                px = px - WorldMapDetailFrame:GetLeft();
                py = py - WorldMapDetailFrame:GetBottom();
                if abs(px - x) < FLIGHTMAP_CLOSE and
                abs(py - y) < FLIGHTMAP_CLOSE then
                    return true;
                end
            end
        end
    end
    return false;
end

-- Try showing a POI node; returns true if the POI icon was displayed, or
-- false if it was too close to an existing POI icon, or there were no
-- known coordinates for the requested coordinate space, or the POI number
-- is out of range.
local function lShowNodePOI(node, data, space, num)
    -- Ensure the coordinate space is known
    if not data.Location[space] then return false; end

    -- Get the coordinates
    local x = data.Location[space].x;
    local y = data.Location[space].y;

    -- Convert them to world map pixel-space
    x = x * WorldMapDetailFrame:GetWidth();
    y = (1 - y) * WorldMapDetailFrame:GetHeight();

    -- Ensure the point isn't close to an existing POI icon
    if lCloseToExistingPOI(x, y) then return false; end

    -- Get the node name
    local name, _ = FlightMapUtil.getNameAndZone(data.Name);

    -- Get the button
    local button = _G["FlightMapPOI" .. num];
    if not button then
        button = CreateFrame("Button", "FlightMapPOI" .. num,
                FlightMapPathFrame, "FlightMapPOITemplate");
        if not button then return false end
    end

    -- Does the user know this flight node?
    if not FlightMapUtil.knownNode(node) then
        if not FlightMap.Opts.showAllInfo then
            return false;
        end
        button:SetNormalTexture(FLIGHTMAP_POI_OTHER);
    else
        button:SetNormalTexture(FLIGHTMAP_POI_KNOWN);
    end

    -- Set all data
    button.name = name;
    button.data = data;
    button.node = node;
    button:SetPoint("CENTER", "WorldMapDetailFrame",
            "BOTTOMLEFT", x, y);
    button:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 20)
    button:Show();

    -- Done!
    return true;
end

-- Show locations of flight masters for either continent or zone level maps
local function lUpdateFlightPOIs(zoneName)
    local continent = GetCurrentMapContinent();
    local mapZone = GetCurrentMapZone();
    local POI = 1;

    if mapZone ~= 0 and FlightMap.Opts.showPOIs then
        -- Zone level map
        local nodes = FlightMapUtil.getNodesInZone(zoneName, false);
        for node, data in pairs(nodes) do
            if lShowNodePOI(node, data, "Zone", POI) then
                POI = POI + 1;
            end
        end
    elseif continent ~= 0 and FlightMap.Opts.showPOIs then
        -- Continent level map
        local map = FlightMapUtil.getFlightMap();
        for node, data in pairs(map) do
            -- Filter list by continent
            if data.Continent == continent then
                if lShowNodePOI(node, data, "Continent", POI) then
                    POI = POI + 1;
                end
            end
        end
    end

    -- Hide any remaining unused POI buttons
    for i = POI, 10000, 1 do
        local but = _G["FlightMapPOI" .. i];
        if but then but:Hide() else break end
    end
end

-- Draw a line from one flight node to another; returns true if the line
-- was drawn, false if it could not be: number out of range, coordinates
-- not known, etc.
local function lDrawFlightLine(from, to, num)
    -- Get the flight map
    local map = FlightMapUtil.getFlightMap();

    -- Make sure both ends are known about
    if not map[from] or not map[to] then return false; end

    -- Get the continent coordinate sets
    local src = map[from].Location.Continent;
    local dst = map[to].Location.Continent;

    -- Make sure both are known
    if not src or not dst then return false; end;
    if src.x == 0 or dst.x == 0 then return false; end

    -- Get the texture to work with
    local tex = _G["FlightMapPath" .. num];
    if not tex then
        tex = FlightMapPathFrame:CreateTexture(
                "FlightMapPath" .. num,
                "ARTWORK", "FlightMapPathTemplate");
        if not tex then return false end;
    end

    return FlightMapUtil.drawLine(WorldMapDetailFrame, tex,
            src.x, src.y, dst.x, dst.y);
end

-- Fill in flight map lines
local function lDrawFlightLines(zoneName)
    local lineNum = 1;

    -- Only if the zone name is known
    if zoneName and FlightMap.Opts.showPaths then
        -- Iterate over nodes in the current zone
        local nodes = FlightMapUtil.getNodesInZone(zoneName, true);
        for node, data in pairs(nodes) do
            -- If the source node is known
            if FlightMap.Opts.showAllInfo or FlightMapUtil.knownNode(node) then
                -- ... then iterate over that node's outbound flights
                for dest, duration in pairs(data.Flights) do
                    -- If the destination node is known
                    if not (data.Routes and data.Routes[dest])
                    and (FlightMap.Opts.showAllInfo
                    or FlightMapUtil.knownNode(dest)) then
                        -- ... and the flight line can be drawn
                        if lDrawFlightLine(node, dest, lineNum) then
                            -- ... then increment the line number
                            lineNum = lineNum + 1;
                        end
                    end
                end
            end
        end
    end

    -- Hide remaining flight paths
    for i = lineNum, 10000, 1 do
        local tex = _G["FlightMapPath" .. i];
        if tex then tex:Hide() else break end
    end
end

-- Last drawn info for tooltip
lFM_CurrentZone = nil;
lFM_CurrentArea = nil;
local lFM_OldUpdate = WorldMapFrame:GetScript("OnUpdate") or function() end

-- Replacement function to draw all the extra goodies of FlightMap
function FlightMap_WorldMapButton_OnUpdate(self, elapsed)
    lFM_OldUpdate(self, elapsed);
    local areaName = WorldMapFrame.areaName;
    local zoneNum = GetCurrentMapZone();

    -- zone name equivalence map
    if FLIGHTMAP_SUBZONES[areaName] then
        areaName = FLIGHTMAP_SUBZONES[areaName];
    end

    -- Bail out if nothing has changed
    if zoneNum == lFM_CurrentZone and areaName == lFM_CurrentArea then
        return;
    end

    -- Continent or zone map?
    if zoneNum == 0 then
        lUpdateTooltip(self, areaName);
        lUpdateFlightPOIs(areaName);
        lDrawFlightLines(areaName);
    else
        lUpdateFlightPOIs(FlightMapUtil.getZoneName());
        lUpdateTooltip(self, nil);            -- hide it
        lDrawFlightLines(nil);          -- hide them
    end
end

function FlightMapPOIButton_OnEnter(self)
    local x, y = self:GetCenter();
    local parentX, parentY = WorldMapDetailFrame:GetCenter();
    if (x > parentX) then
        WorldMapTooltip:SetOwner(self, "ANCHOR_LEFT");
    else
        WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT");
	WorldMapTooltip:SetFrameLevel(self:GetFrameLevel() + 1)	-- help put tooltips in front
    end
    lAddFlightsForNode(WorldMapTooltip, self.node, "");
    WorldMapTooltip:Show();
end

---------------- Initialization functions -----------------

-- /flightmap handler
function FlightMap_OnSlashCmd(args)
	if args == FLIGHTMAP_RESET then
		-- Reset the flight timer window's position
		FlightMapTimesFrame:ClearAllPoints();
		FlightMapTimesFrame:SetPoint("TOP", PVPArenaTextString, "BOTTOM");
	elseif args == FLIGHTMAP_SHOWMAP then
		FlightMapTaxi_ShowContinent();
	elseif args == FLIGHTMAP_LOCKTIMES then
		FlightMap.Opts.lockFlightTimes = not FlightMap.Opts.lockFlightTimes;
		DEFAULT_CHAT_FRAME:AddMessage(
			FLIGHTMAP_TIMESLOCKED[FlightMap.Opts.lockFlightTimes],
			1.0, 1.0, 1.0);
	elseif args == FLIGHTMAP_REPAIR then
		FlightMapUtil.repairFlightMap()
		DEFAULT_CHAT_FRAME:AddMessage(
			FLIGHTMAP_REPAIR_OK,
			1.0, 1.0, 1.0);		
	elseif args == FLIGHTMAP_HARDRESET then
		FlightMapUtil.resetFlightMap()
		DEFAULT_CHAT_FRAME:AddMessage(
			FLIGHTMAP_HARDRESET_OK,
			1.0, 1.0, 1.0);	
	else
		for cmd, desc in pairs(FLIGHTMAP_SUBCOMMANDS) do
			DEFAULT_CHAT_FRAME:AddMessage("|cffcc9010" .. cmd .. "|r " .. desc,
				1.0, 1.0, 1.0);
		end
	InterfaceOptionsFrame_OpenToCategory(InterfaceOptionsFlightMapPanel)
	end
end

function FlightMap_OnLoad(self)
    -- Hook TAXIMAP_OPENED to learn flight paths
    self:RegisterEvent("TAXIMAP_OPENED");

    WorldMapFrame:SetScript('OnUpdate', function(...)
        FlightMap_WorldMapButton_OnUpdate(...)
    end)

    -- Set up my slash command
    SLASH_FLIGHTMAP1 = "/fmap";
    SLASH_FLIGHTMAP2 = "/flightmap";
    SlashCmdList["FLIGHTMAP"] = FlightMap_OnSlashCmd;

    -- Register for VARIABLES_LOADED to talk to myAddOns
    self:RegisterEvent("VARIABLES_LOADED");
end

function FlightMap_OnEvent(self, event, ...)
    if (event == "TAXIMAP_OPENED") then
        lAutoDismount();
        lLearnTaxiNode();
    elseif (event == "VARIABLES_LOADED") then
        lSetDefaultData();
    end
end

----------------- Options panel functions -----------------

function FlightMapOptionsFrame_OnLoad(self)
    local base = "InterfaceOptionsFlightMapPanel";
    local parent = InterfaceOptionsFlightMapPanel;
    local referent = InterfaceOptionsFlightMapPanelSubText;
    local options = {};

    local children = {};

    for optid, option in pairs(FLIGHTMAP_OPTIONS) do
        -- Create a checkbox
        local box = CreateFrame("CheckButton", base .. "Option" .. optid,
                parent, "InterfaceOptionsCheckButtonTemplate");
        box.type = CONTROLTYPE_CHECKBOX;
        box.label = "option" .. optid;
        box.setFunc = function(value)
            if value == "0" then value = false end
            FlightMap.Opts[option.option] = value
	    lOnUpdateSetting(option.option)
        end
        box.GetValue = function() return (FlightMap.Opts[option.option] and "1" or "0") end

        -- Deal with indenting children
        local left = -2;
        for _, child in pairs(option.children or {}) do
            children[child] = 1;
        end
        if children[optid] then left = 13 end

        -- Add anchor
        box:SetPoint("TOPLEFT", referent, "BOTTOMLEFT",
                left, 30 - 30 * optid);

        -- Store for later use
        option.control = box;
        options["option" .. optid] = {
            text = option.label,
            tooltip = option.tooltip,
            default = FlightMap.Opts[option.option],
        };
    end

    -- Register all controls
    for optid, option in pairs(FLIGHTMAP_OPTIONS) do
        BlizzardOptionsPanel_RegisterControl(option.control, option.control:GetParent());
    end

    -- Register all dependencies
    for optid, option in pairs(FLIGHTMAP_OPTIONS) do
        for _, child in pairs(option.children or {}) do
            local other = FLIGHTMAP_OPTIONS[child];
            if other and other.control then
                --BlizzardOptionsPanel_SetupDependentControl(other.control,
                        --option.control)
            end
        end
    end

    -- Initialise the options panel
    self.name = FLIGHTMAP_OPTIONS_TITLE;
    self.options = options;
    InterfaceOptionsPanel_OnLoad(self);
end
