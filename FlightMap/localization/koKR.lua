-- Korean translations

if (GetLocale() == "koKR") then
    BINDING_HEADER_FLIGHTMAP = "FlightMap";
    BINDING_NAME_FLIGHTMAP   = "비행경로 보기";

    FLIGHTMAP_NAME          = "FlightMap";
    FLIGHTMAP_DESCRIPTION   = "월드맵에 비행경로를 표시합니다.";
    FLIGHTMAP_ALLIANCE      = "얼라이언스";
    FLIGHTMAP_HORDE         = "호드";
    FLIGHTMAP_CONTESTED     = "분쟁 지역";
FLIGHTMAP_NEUTRAL       = "중립 지역";

    -- General strings
    FLIGHTMAP_TIMING        = "(측정중)";
    FLIGHTMAP_LEVELS        = "|cff00ff00레벨: %d - %d|r";
    FLIGHTMAP_NOFLIGHTS     = "가지 않은 경로!";    -- TODO translate
    FLIGHTMAP_NOT_KNOWN     = "(모르는 곳)";    -- TODO translate
    FLIGHTMAP_NO_COST       = "무료";           -- TODO translate
    FLIGHTMAP_MONEY_GOLD    = "G";              -- TODO translate
    FLIGHTMAP_MONEY_SILVER  = "S";              -- TODO translate
    FLIGHTMAP_MONEY_COPPER  = "C";              -- TODO translate
    FLIGHTMAP_FLIGHTTIME    = "비행시간 ";  -- TODO translate
    FLIGHTMAP_QUICKEST      = "빠른 경로";  -- TODO translate
    FLIGHTMAP_TOTAL_TIME    = "총 시간";     -- TODO translate
    FLIGHTMAP_VIA           = "경유: ";           -- TODO translate
    FLIGHTMAP_CONFIRM       = "정말 %s(|cff00ff00%s|r)로 이동하시겠습니까?";
    FLIGHTMAP_CONFIRM_TIME  = "비행시간 - ";

    -- Command strings
    FLIGHTMAP_RESET         = "초기화";  -- TODO translate
    FLIGHTMAP_SHOWMAP       = "열기";   -- TODO translate
    FLIGHTMAP_LOCKTIMES     = "고정";   -- TODO translate
    FLIGHTMAP_GETHELP       = "도움말";   -- TODO translate

FLIGHTMAP_REPAIR = "복구"; -- TODO translate
FLIGHTMAP_HARDRESET = "강제 초기화"; -- TODO translate

-- Repair and reset confirmation strings
FLIGHTMAP_REPAIR_OK = "비행경로 정보를 복구했습니다."
FLIGHTMAP_HARDRESET_OK = "비행경로 정보를 모두 초기화했습니다."

    -- Help text        TODO translate
    FLIGHTMAP_TIMER_HELP    =
        "SHIFT키를 누른채로 드래그하여 위치를 이동할 수 있습니다.";
    FLIGHTMAP_SUBCOMMANDS   = {
        [FLIGHTMAP_RESET]       = "이동시간 표시바 위치를 초기화합니다.",
        [FLIGHTMAP_SHOWMAP]     = "플라이트맵 창을 엽니다.",
        [FLIGHTMAP_GETHELP]     = "도움말을 봅니다.",
    };

    -- Locked/unlocked status           TODO translate
    FLIGHTMAP_TIMESLOCKED   = {
        [true] = "비행시간이 더이상 저장되지 않습니다.",
        [false] = "비행시간을 저장합니다.",
    };

    -- Option strings
    FLIGHTMAP_OPTIONS_CLOSE = "닫기";             -- TODO translate
    FLIGHTMAP_OPTIONS_TITLE = "플라이트맵 설정"; -- TODO translate
    FLIGHTMAP_OPTIONS = {};
    FLIGHTMAP_OPTIONS[1] = {   -- Option 1: flight path lines
        label = "비행 경로",
        option = "showPaths",
        tooltip = "비행 경로를 월드맵에 표시해줍니다.",
    };
    FLIGHTMAP_OPTIONS[2] = {   -- Option 2: extra POI buttons
        label = "비행장 아이콘 표시",
        option = "showPOIs",
        tooltip = "비행장의 위치를 아이콘으로 표시해줍니다.",
    };
    FLIGHTMAP_OPTIONS[3] = {   -- Option 3: Unknown masters
        label = "모든 정보 보기",
        option = "showAllInfo",
        tooltip = "비행경로를 알 수 없어도 모두 보여줍니다.",
    };
FLIGHTMAP_OPTIONS[4] = {   -- Option 4: flight timers
        label = "비행 시간 타이머",
        option = "useTimer",
        tooltip = "비행 시간을 잽니다.",
    };

FLIGHTMAP_OPTIONS[5] = {   -- Option 5: Show flight destinations
        label = "비행경로 설명 보기",
        option = "showDestinations",
        tooltip = "비행경로 툴팁에 시간/비용을 표시합니다.",
    children = {6, 7, 8},
    };
FLIGHTMAP_OPTIONS[6] = {   -- Option 6: Show multi-hop destinations
        label = "경유 이동경로 표시",
        option = "showMultiHop",
        tooltip = "툴팁에 경유 이동경로를 표시합니다.",
    };
FLIGHTMAP_OPTIONS[7] = {   -- Option 7: Show flight times
        label = "비행 시간 표시",
        option = "showTimes",
        tooltip = "비행 시간을 툴팁에 보여줍니다.",
    };
FLIGHTMAP_OPTIONS[8] = {   -- Option 8: Show flight costs
        label = "비행료 표시",
        option = "showCosts",
        tooltip = "비행료를 툴팁에 보여줍니다.",
    };
FLIGHTMAP_OPTIONS[9] = {   -- Option 9: Taxi window extras
        label = "전체 비행경로 표시",
        option = "fullTaxiMap",
        tooltip = "한 번에 갈 수 없는 비행경로라도 모두 표시합니다.",
    };
FLIGHTMAP_OPTIONS[10] = {   -- Option 10: Confirm flight destinations
        label = "비행경로 확인",
        option = "confirmFlights",
        tooltip = "선택한 경로로 날아가기 전에 확인 창을 표시합니다.확인을 눌러야만 비행을 시작합니다.",
    };
FLIGHTMAP_OPTIONS[11] = {   -- Option 11: Larger Timer Window
    label = "타이머창 길게 표시",
    option = "largerTimer",
    tooltip = "비행 시간 타이머 창을 길게 표시합니다.",
    children = { 12 },
};
FLIGHTMAP_OPTIONS[12] = {   -- Option 12: XL Timer window
    label = "더 길게 표시",
    option = "xlTimer",
    tooltip = "비행 시간 타이머 창을 더 길게 표시합니다.",
};

    -- These constants determine how "Town (Zone)" strings look.
    -- SEP_STRING is what separates Town from Zone.  SEP_POSTAMBLE
    -- is anything that is after Zone.
    FLIGHTMAP_SEP_STRING    = " (";
    FLIGHTMAP_SEP_POSTAMBLE = ")";
end
