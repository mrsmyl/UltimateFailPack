-- Russian translations

if (GetLocale() == "ruRU") then
    BINDING_HEADER_FLIGHTMAP = "FlightMap";
    BINDING_NAME_FLIGHTMAP   = "Показать карту полетов";

    FLIGHTMAP_NAME          = "FlightMap";
    FLIGHTMAP_DESCRIPTION   = "Информация о точках и путях полета на карте мира";
    FLIGHTMAP_ALLIANCE      = "Альянс";
    FLIGHTMAP_HORDE         = "Орда";
    FLIGHTMAP_CONTESTED     = "Оспариваемые";
    FLIGHTMAP_NEUTRAL       = "Нейтральные";

    -- General strings
    FLIGHTMAP_TIMING        = "(считаю)";
    FLIGHTMAP_LEVELS        = "Уровни %d - %d";
    FLIGHTMAP_NOFLIGHTS     = "Нет известных!";
    FLIGHTMAP_NOT_KNOWN     = "(Неизвестно)";
    FLIGHTMAP_NO_COST       = "Бесплатно";
    FLIGHTMAP_MONEY_GOLD    = "з";
    FLIGHTMAP_MONEY_SILVER  = "с";
    FLIGHTMAP_MONEY_COPPER  = "м";
    FLIGHTMAP_FLIGHTTIME    = "Время полета: ";
    FLIGHTMAP_QUICKEST      = "Кратчайший путь";
    FLIGHTMAP_TOTAL_TIME    = "Полное время";
    FLIGHTMAP_VIA           = "Через ";
    FLIGHTMAP_CONFIRM       = "Уверены, что хотите лететь к %s?%s";
    FLIGHTMAP_CONFIRM_TIME  = " Этот полет займет ";

    -- Command strings
    FLIGHTMAP_RESET         = "сбросить";
    FLIGHTMAP_SHOWMAP       = "открыть";
    FLIGHTMAP_LOCKTIMES     = "закрепить";
    FLIGHTMAP_GETHELP       = "помощь";

    -- Help text
    FLIGHTMAP_TIMER_HELP    =
        "Нажмите SHIFT и двигайте панель левой кнопкой мыши туда, где она вам наиболее удобна.";
    FLIGHTMAP_SUBCOMMANDS   = {
        [FLIGHTMAP_RESET]       = "Сбрасывает положение панели времени полета",
        [FLIGHTMAP_SHOWMAP]     = "Открывает окно карты путей",
        [FLIGHTMAP_GETHELP]     = "Показывает этот текст",
    };

    -- Locked/unlocked status
    FLIGHTMAP_TIMESLOCKED   = {
        [true] = "Время полета более не будет рассчитываться.",
        [false] = "Теперь время полета будет рассчитываться.",
    };

    -- Option strings
    FLIGHTMAP_OPTIONS_CLOSE = "Закрыть";
    FLIGHTMAP_OPTIONS_TITLE = "Настройки FlightMap";
    FLIGHTMAP_OPTIONS = {};
    FLIGHTMAP_OPTIONS[1] = {   -- Option 1: flight path lines
        label = "Линии путей",
        option = "showPaths",
        tooltip = "Показывает на карте мира линии путей сообщения.",
    };
    FLIGHTMAP_OPTIONS[2] = {   -- Option 2: extra POI buttons
        label = "Показывать иконки",
        option = "showPOIs",
        tooltip = "Показывает на карте мира иконки полетных станций.",
    };
    FLIGHTMAP_OPTIONS[3] = {   -- Option 3: Unknown masters
        label = "Показать неизвестные",
        option = "showAllInfo",
        tooltip = "Показывать все полетные станции, даже еще непосещенные персонажем.",
    };
    FLIGHTMAP_OPTIONS[4] = {   -- Option 5: flight timers
        label = "Таймер в полете",
        option = "useTimer",
        tooltip = "Включить/выключить полоску, показывающую время полета.",
    };

    FLIGHTMAP_OPTIONS[5] = {   -- Option 6: Show flight destinations
        label = "Точки назначения",
        option = "showDestinations",
        tooltip = "Показывать точки назначения в подсказках.",
        children = {6, 7, 8},
    };
    FLIGHTMAP_OPTIONS[6] = {   -- Option 7: Show multi-hop destinations
        label = "Включая многопрыжковые",
        option = "showMultiHop",
        tooltip = "Показывать в подсказках точки назначения, которые находятся в нескольких станциях от текущей.",
    };
    FLIGHTMAP_OPTIONS[7] = {   -- Option 8: Show flight times
        label = "Со временем полета",
        option = "showTimes",
        tooltip = "Показывать время полета в подсказках.",
    };
    FLIGHTMAP_OPTIONS[8] = {   -- Option 9: Show flight costs
        label = "Со стоимостью полета",
        option = "showCosts",
        tooltip = "Показывать стоимость полета в подсказках.",
    };
    FLIGHTMAP_OPTIONS[9] = {   -- Option 10: Taxi window extras
        label = "Улучшенное окно полета",
        option = "fullTaxiMap",
        tooltip = "Показывать сеть станций полета в окне полета.",
    };
    FLIGHTMAP_OPTIONS[10] = {   -- Option 11: Confirm flight destinations
        label = "Подтверждать полет",
        option = "confirmFlights",
        tooltip = "Перед полетом запрашивается подтверждение.",
    };

    -- These constants determine how "Town, Zone" strings look.
    -- SEP_STRING is what separates Town from Zone.  SEP_POSTAMBLE
    -- is anything that is after Zone.
    FLIGHTMAP_SEP_STRING    = ", ";
    FLIGHTMAP_SEP_POSTAMBLE = "";
end
