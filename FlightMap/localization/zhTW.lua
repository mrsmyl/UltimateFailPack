-- Translatable strings, Traditional Chinese version
-- Translated by: Arith Hsu (arithmandarjp at yahoo.co.jp)
-- Revision History:
-- 1.11-1:
--    7/19: Synchronize zhTW version with latest 1.11-1 English version, and translate the unlocalized strings
-- 1.12-1:
--    8/21: Revised some translations
-- 2.0.3:
--    2007/04/30: Sync with English 2.0.3 and updated translation
if (GetLocale()=="zhTW") then

BINDING_HEADER_FLIGHTMAP = "飛行地圖";
BINDING_NAME_FLIGHTMAP   = "顯示飛行地圖";

FLIGHTMAP_NAME          = "飛行地圖";
FLIGHTMAP_DESCRIPTION   = "在世界地圖上顯示飛行路線資訊";
FLIGHTMAP_ALLIANCE      = "聯盟";
FLIGHTMAP_HORDE         = "部落";
FLIGHTMAP_CONTESTED     = "爭奪中";
FLIGHTMAP_NEUTRAL       = "中立地區";

-- General strings
FLIGHTMAP_TIMING        = "(計時中)";
FLIGHTMAP_LEVELS        = "等級 %d - %d";
FLIGHTMAP_NOFLIGHTS     = "沒有已知的飛行點!";
FLIGHTMAP_NOT_KNOWN     = "(未開啟)";
FLIGHTMAP_NO_COST       = "免費";
FLIGHTMAP_MONEY_GOLD    = "金";
FLIGHTMAP_MONEY_SILVER  = "銀";
FLIGHTMAP_MONEY_COPPER  = "銅";
FLIGHTMAP_FLIGHTTIME    = "飛行時間: ";
FLIGHTMAP_QUICKEST      = "最快路線";
FLIGHTMAP_TOTAL_TIME    = "總計時間";
FLIGHTMAP_VIA           = "經由 ";
FLIGHTMAP_CONFIRM       = "你確定你要飛到 %s?%s";
FLIGHTMAP_CONFIRM_TIME  = " 這飛行將會費時 ";

-- Command strings
FLIGHTMAP_RESET         = "重設";
FLIGHTMAP_SHOWMAP       = "開啟";
FLIGHTMAP_LOCKTIMES     = "鎖住";
FLIGHTMAP_GETHELP       = "求助";

-- Help text
FLIGHTMAP_TIMER_HELP    =
    "按住 SHIFT 鍵並拖曳計時列來移動位置";
FLIGHTMAP_SUBCOMMANDS   = {
    [FLIGHTMAP_RESET]       = "重設計時列的位置",
    [FLIGHTMAP_SHOWMAP]     = "打開飛行地圖視窗",
    [FLIGHTMAP_GETHELP]     = "顯示這個內容",
};

-- Locked/unlocked status
FLIGHTMAP_TIMESLOCKED   = {
    [true] = "飛行時間將不再被記錄.",
    [false] = "飛行時間現在起將會被記錄.",
};

-- Option strings
FLIGHTMAP_OPTIONS_CLOSE = "關閉";
FLIGHTMAP_OPTIONS_TITLE = "飛行地圖選項";
FLIGHTMAP_OPTIONS = {};
FLIGHTMAP_OPTIONS[1] = {   -- Option 1: flight path lines
    label = "飛行路線",
    option = "showPaths",
    tooltip = "在世界地圖的飛行點之間顯示飛行線路.",
};
FLIGHTMAP_OPTIONS[2] = {   -- Option 2: extra POI buttons
    label = "管理員POI",
    option = "showPOIs",
    tooltip = "為飛行管理員設置額外的POI按鈕",
};
FLIGHTMAP_OPTIONS[3] = {   -- Option 3: Unknown masters
    label = "顯示未知飛行點",
    option = "showAllInfo",
    tooltip = "顯示全部資訊，甚至包含未開啟的飛行節點",
};
FLIGHTMAP_OPTIONS[4] = {   -- Option 5: flight timers
    label = "飛行計時器顯示",
    option = "useTimer",
    tooltip = "啟動/取消飛行時顯示時間計時",
 };
FLIGHTMAP_OPTIONS[5] = {   -- Option 6: Show flight destinations
    label = "顯示目的地",
    option = "showDestinations",
    tooltip = "在提示訊息裡顯示飛行目的地",
    children = {7, 8, 9},
};
FLIGHTMAP_OPTIONS[6] = {   -- Option 7: Show multi-hop destinations
    label = "包含轉運點",
    option = "showMultiHop",
    tooltip = "在提示訊息裡顯示中途的飛行點",
};
FLIGHTMAP_OPTIONS[7] = {   -- Option 8: Show flight times
    label = "顯示飛行時間",
    option = "showTimes",
    tooltip = "在提示訊息中顯示飛行所需時間",
};
FLIGHTMAP_OPTIONS[8] = {   -- Option 9: Show flight costs
    label = "顯示飛行費用",
    option = "showCosts",
    tooltip = "在提示訊息中顯示飛行所需花費",
};
FLIGHTMAP_OPTIONS[9] = {   -- Option 10: Taxi window extras
    label = "全飛行地圖",
    option = "fullTaxiMap",
    tooltip = "在飛行路線地圖上顯示所有飛行網路",
};
FLIGHTMAP_OPTIONS[10] = {   -- Option 11: Confirm flight destinations
    label = "確認飛行路線",
    option = "confirmFlights",
    tooltip = "在起飛前再次提示確認",
};

-- These constants determine how "Town, Zone" strings look.
-- SEP_STRING is what separates Town from Zone.  SEP_POSTAMBLE
-- is anything that is after Zone.
FLIGHTMAP_SEP_STRING    = "，";
FLIGHTMAP_SEP_POSTAMBLE = "";

end
