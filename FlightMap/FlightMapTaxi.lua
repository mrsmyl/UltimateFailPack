-- Continent number -> TAXIMAPnnn
local continent_maps = {"1", "0", "530", "571"};

function FlightMapTaxi_SetContinent(cont)
    local cname = FlightMapUtil.getContinentName(cont);
    TaxiFrameTitleText:SetText(cname);
    local tname = "Interface\\TaxiFrame\\TAXIMAP" .. continent_maps[cont];
    TaxiFrameInsetBg:SetTexture(tname);
    FlightMapTaxiFrame_OnEvent(FlightMapTaxiFrame, cont);
end

function FlightMapTaxi_ShowContinent()
    if TaxiFrame:IsVisible() then
        HideUIPanel(TaxiFrame);
        return;
    end

    --TaxiPortrait:SetTexture("Interface\\WorldMap\\WorldMap-Icon");
    for i = 1, NUM_TAXI_BUTTONS, 1 do
        local btn = _G["TaxiButton" .. i];
        if btn then btn:Hide(); end
    end

    -- Get a (non-instanced) continent number
    local cont = FlightMapUtil.getContinent();
    if cont == 0 then cont = 1; end

    -- Must kill "OnShow" handler briefly
    local onshow = TaxiFrame:GetScript("OnShow");
    TaxiFrame:SetScript("OnShow", function()
        PlaySound("igMainMenuOpen");
    end);
    ShowUIPanel(TaxiFrame, 1);
    TaxiFrame:SetScript("OnShow", onshow);

    -- Toggle FlightMap/Blizzard stuff
    TaxiRouteMap:Hide();
    FlightMapTaxiContinents:Show();

    -- Then set the continent display
    FlightMapTaxi_SetContinent(cont);

    UIDropDownMenu_SetSelectedID(FlightMapTaxiContinents, cont);
end

function FlightMapTaxiButton_OnEnter(button)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
    FlightMapUtil.addFlightsForNode(GameTooltip, button.nodeKey, '',
        FlightMapTaxiFrame.sourceKey);
    if FlightMapTaxiFrame.sourceNode then
        local costs = FlightMapTaxiFrame.sourceNode.Costs;
        if costs[button.nodeKey] and costs[button.nodeKey] > 0 then
            SetTooltipMoney(GameTooltip, costs[button.nodeKey]);
        end
    end
    GameTooltip:Show();
end

function FlightMapTaxiButton_OnLeave(button)
    GameTooltip:Hide();
end

function FlightMapTaxiFrame_OnLoad(self)
    self:RegisterEvent("TAXIMAP_OPENED");
    TaxiButtonTypes["UNKNOWN"] = {
	file = "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray"
    };
end

function FlightMapTaxiFrame_OnEvent(self, event, ...)
    -- Hide any unused lines left over from a previous flight master visit
    for i = 1, 10000, 1 do
        local tex = _G["FlightMapTaxiPath" .. i];
        if tex then tex:Hide() else break end
    end

    -- Hide any unused icons too
    for i = 1, 10000, 1 do
        local but = _G["FlightMapTaxiButton" .. i];
        if but then but:Hide() else break end
    end

    -- If the event isn't "TAXIMAP_OPENED" then this is an
    -- anywhere-display map.
    local thiscont = event;
    if event == "TAXIMAP_OPENED" then
        -- Turn the route map back on
        TaxiRouteMap:Show();
        -- Turn the continent select off
        FlightMapTaxiContinents:Hide();
        -- Check option is on
        if not FlightMap.Opts.fullTaxiMap then return; end
        thiscont = FlightMapUtil.getContinent();
    end

    local map = FlightMapUtil.getFlightMap();

    -- Reset these...
    FlightMapTaxiFrame.sourceKey = nil;
    FlightMapTaxiFrame.sourceNode = nil;

    -- So, NumTaxiNodes() returns a value all the time...
    local numNodes = NumTaxiNodes();
    if event ~= "TAXIMAP_OPENED" then
        numNodes = 0;
    end

    -- Build a list of nodes the Blizzard client has dealt with
    local shownNodes = {};
    local dontShow = {};
    FlightMapTaxiFrame.Destinations = {};
    for i = 1, numNodes do
        local tx, ty = TaxiNodePosition(i);
        local node = FlightMapUtil.makeNodeName(thiscont, tx, ty);
        shownNodes[node] = true;
        if TaxiNodeGetType(i) == "CURRENT" then
            FlightMapTaxiFrame.sourceKey = node;
            FlightMapTaxiFrame.sourceNode = map[node];
        end
        if TaxiNodeGetType(i) == "NONE" then
            dontShow[node] = true;
        end
        FlightMapTaxiFrame.Destinations[node] = i;
    end

    -- Show the entire flight map as a faint overlay
    local seen = {};
    local linenum = 1;
    local nodenum = 1;
    for key, node in pairs(map) do
        -- If it's on this continent, and hasn't been drawn, fill it in
        if not shownNodes[key] and node.Continent == thiscont
        and (FlightMap.Opts.showAllInfo or FlightMapUtil.knownNode(key)) then
            local button = _G["FlightMapTaxiButton" .. nodenum];
            if not button then
                button = CreateFrame("Button",
                        "FlightMapTaxiButton" .. nodenum,
                        FlightMapTaxiFrame, "FlightMapTaxiButtonTemplate");
                if button then button:SetID(nodenum); end
            end
            if button then
                nodenum = nodenum + 1;
                button:ClearAllPoints();
                button:SetPoint("CENTER", "TaxiRouteMap", "BOTTOMLEFT", -- Started as TaxiMap, could be TaxiFrameInsetBg
                    node.Location.Taxi.x * TAXI_MAP_WIDTH,
                    node.Location.Taxi.y * TAXI_MAP_HEIGHT);
                button.nodeKey = key;
                button.node    = node;
                if FlightMapUtil.knownNode(key) then
                    button:SetNormalTexture(TaxiButtonTypes["REACHABLE"].file);
                else
                    button:SetNormalTexture(TaxiButtonTypes["UNKNOWN"].file);
                end
                button:Show();
            end
        end

        -- Draw all single-hop lines
        for k, v in pairs(node.Flights) do
            local tex = _G["FlightMapTaxiPath" .. linenum];
            if not tex then
                tex = FlightMapTaxiFrame:CreateTexture(
                        "FlightMapTaxiPath" .. linenum,
                        "ARTWORK", "FlightMapPathTemplate");
            end
            if tex and not seen[key .. "-" .. k]
            and node.Continent == thiscont and map[k]
            and not dontShow[k] and not dontShow[key]
            and not (node.Routes and node.Routes[k]) then
                linenum = linenum + 1;
                seen[key .. "-" .. k] = true;
                seen[k .. "-" .. key] = true;
                if FlightMap.Opts.showAllInfo
                or (FlightMapUtil.knownNode(k)
                and FlightMapUtil.knownNode(key)) then
                    FlightMapUtil.drawLine(TaxiRouteMap, tex,
                        node.Location.Taxi.x, 1 - node.Location.Taxi.y,
                        map[k].Location.Taxi.x, 1 - map[k].Location.Taxi.y);
                    tex:SetAlpha(0.5);
                end
            end
        end
    end
end

function FlightMapTaxiContinents_OnShow(self)
    UIDropDownMenu_Initialize(self, FlightMapTaxiContinentsDropDown_Initialize);
    UIDropDownMenu_SetWidth(self, 130);

    if ((GetCurrentMapContinent() == 0) or (GetCurrentMapContinent() == WORLDMAP_COSMIC_ID)) then
        UIDropDownMenu_SetSelectedId(self, 1);
            FlightMapTaxi_SetContinent(1);
    else
        UIDropDownMenu_SetSelectedID(self, GetCurrentMapContinent());
        FlightMapTaxi_SetContinent(GetCurrentMapContinent());
    end
end

function FlightMapTaxiContinents_OnClick(self)
    UIDropDownMenu_SetSelectedID(FlightMapTaxiContinents, self:GetID());
    FlightMapTaxi_SetContinent(self:GetID());
end

function FlightMapTaxiContinentsDropDown_Initialize()
    FlightMapTaxiContinents_LoadContinents(GetMapContinents());
end

function FlightMapTaxiContinents_LoadContinents(...)
    local info = UIDropDownMenu_CreateInfo();
    for i=1, select("#", ...), 1 do
        info.text = select(i, ...);
        info.func = FlightMapTaxiContinents_OnClick;
        info.checked = nil;
        UIDropDownMenu_AddButton(info);
    end
end
