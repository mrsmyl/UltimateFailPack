-- Chinese translations
-- By Tobar at CN Realm
if (GetLocale() == "zhCN") then
    BINDING_HEADER_FLIGHTMAP = "FlightMap";       -- TODO translate
    BINDING_NAME_FLIGHTMAP   = "Show flight map"; -- TODO translate

    FLIGHTMAP_NAME          = "FlightMap";
    FLIGHTMAP_DESCRIPTION   = "在世界地图上显示飞行路线";
    FLIGHTMAP_ALLIANCE      = "联盟";
    FLIGHTMAP_HORDE         = "部落";
    FLIGHTMAP_CONTESTED     = "争夺中";

    -- General strings
    FLIGHTMAP_TIMING        = "(计时)";
    FLIGHTMAP_LEVELS        = "|cff00ff00等级范围: %d - %d|r";
    FLIGHTMAP_NOFLIGHTS     = "没有已知的飞行点!";
    FLIGHTMAP_NOT_KNOWN     = "(未知)";
    FLIGHTMAP_NO_COST       = "免费";
    FLIGHTMAP_MONEY_GOLD    = "金";
    FLIGHTMAP_MONEY_SILVER  = "银";
    FLIGHTMAP_MONEY_COPPER  = "铜";
    FLIGHTMAP_FLIGHTTIME    = "Flight time: ";     -- TODO translate
    FLIGHTMAP_QUICKEST      = "Fastest route: ";   -- TODO translate
    FLIGHTMAP_TOTAL_TIME    = "Total time: ";      -- TODO translate
    FLIGHTMAP_VIA           = "Via ";              -- TODO translate
    FLIGHTMAP_CONFIRM       = "Are you sure you wish to fly to %s?%s";
    FLIGHTMAP_CONFIRM_TIME  = " This flight will take ";

    -- Command strings
    FLIGHTMAP_RESET         = "reset";             -- TODO translate
    FLIGHTMAP_SHOWMAP       = "open";              -- TODO translate
    FLIGHTMAP_LOCKTIMES     = "lock";              -- TODO translate
    FLIGHTMAP_GETHELP       = "help";              -- TODO translate

    -- Help text                   TODO translate
    FLIGHTMAP_TIMER_HELP    =
        "Hold down SHIFT and drag the timer bar to reposition.";
    FLIGHTMAP_SUBCOMMANDS   = {
        [FLIGHTMAP_RESET]       = "Reset timer bar position",
        [FLIGHTMAP_SHOWMAP]     = "Open flight map window",
        [FLIGHTMAP_GETHELP]     = "Show this text",
    };

    -- Locked/unlocked status           TODO translate
    FLIGHTMAP_TIMESLOCKED   = {
        [true] = "Flight times will no longer be recorded.",
        [false] = "Flight times will now be recorded.",
    };

    -- Option strings
    FLIGHTMAP_OPTIONS_CLOSE = "Close";             -- TODO translate
    FLIGHTMAP_OPTIONS_TITLE = "FlightMap Options"; -- TODO translate
    FLIGHTMAP_OPTIONS = {};
    FLIGHTMAP_OPTIONS[1] = {   -- Option 1: flight path lines
        label = "飞行路线",
        option = "showPaths",
        tooltip = "在世界地图上画出飞行路线.",
    };
    FLIGHTMAP_OPTIONS[2] = {   -- Option 2: extra POI buttons
        label = "飞行管理员图标",
        option = "showPOIs",
        tooltip = "在地图上显示飞行管理员的坐标.",
    };
    FLIGHTMAP_OPTIONS[3] = {   -- Option 3: Unknown masters
        label = "显示所有信息",
        option = "showAllInfo",
        tooltip = "显示所有数据, 包括还未访问的飞行点.",
    };
    FLIGHTMAP_OPTIONS[4] = {   -- Option 5: flight timers
        label = "飞行计时器",
        option = "useTimer",
        tooltip = "启用/禁用 飞行进度监视器.",
    };

    FLIGHTMAP_OPTIONS[5] = {   -- Option 6: Show flight destinations
        label = "Show destinations",
        option = "showDestinations",
        tooltip = "Show flight destinations on tooltips",
        children = {7, 8, 9},
    };
    FLIGHTMAP_OPTIONS[6] = {   -- Option 7: Show multi-hop destinations
        label = "Including multi-hop",
        option = "showMultiHop",
        tooltip = "Show multi-hop destinations on tooltips",
    };
    FLIGHTMAP_OPTIONS[7] = {   -- Option 8: Show flight times
        label = "显示飞行时间",
        option = "showTimes",
        tooltip = "在提示框中显示飞行时间.",
    };
    FLIGHTMAP_OPTIONS[8] = {   -- Option 5: Show flight costs
        label = "显示飞行费用",
        option = "showCosts",
        tooltip = "在提示框中显示飞行费用.",
    };
    FLIGHTMAP_OPTIONS[9] = {   -- Option 10: Taxi window extras
        label = "Full flight map",
        option = "fullTaxiMap",
        tooltip = "Show unreachable nodes on the taxi window map",
    };
    FLIGHTMAP_OPTIONS[10] = {   -- Option 11: Confirm flight destinations
        label = "Confirm flights",
        option = "confirmFlights",
        tooltip = "Prompt for confirmation before taking a flight",
    };

    -- These constants determine how "Town, Zone" strings look.
    -- SEP_STRING is what separates Town from Zone.  SEP_POSTAMBLE
    -- is anything that is after Zone.
    FLIGHTMAP_SEP_STRING    = "，";
    FLIGHTMAP_SEP_POSTAMBLE = "";
end
