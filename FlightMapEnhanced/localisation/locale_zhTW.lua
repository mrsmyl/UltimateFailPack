if ( GetLocale() ~= "zhTW" ) then
	return;
end
local ns = select( 2, ... );
ns.L = {
	ALT_KEY = "Alt", -- Requires localization
	ALWAYS_COLLAPSE = "Always collapse on show", -- Requires localization
	CONFIG_BASIC = "Basic Options", -- Requires localization
	CONFIG_CONFIRM_FLIGHT_AUTO = "Confirm before a flight is automatic taken", -- Requires localization
	CONFIG_CONFIRM_FLIGHT_MANUAL = "Confirm before a flight is manually taken", -- Requires localization
	CONFIG_MODULES = "Modules", -- Requires localization
	CONFIG_MODULES_HELP_CAPTION = "Module Configuration", -- Requires localization
	CONFIG_MODULES_HELP_TEXT = "If you enable/disable a module you need to reload the UI to make the change active.", -- Requires localization
	CONFIG_MODULES_WMC_EXPLAIN = "You can click on the Worldmap and your next flight is set to the closest flight location and automatic taken when you visit next a Flightmaster.", -- Requires localization
	CONFIG_MODULES_WMC_EXPLAIN2 = "To reset the chosen flight location, click the minimap button and choose None", -- Requires localization
	CONFIG_MOUDLES_MFM_EXPLAIN = "This module will show you all missing Flight Master on the World Map", -- Requires localization
	CONFIRM_FLIGHT = "You really wanna flight to %s ?", -- Requires localization
	CTRL_KEY = "Ctrl", -- Requires localization
	DETACH_ADDON_FRAME = "Detach Addon Frame", -- Requires localization
	FLIGHT_FRAME_LOCK = "Lock Flight Map frame", -- Requires localization
	FT_ACCURATE = "Accurate", -- Requires localization
	FT_CALCULATED = "Calculated", -- Requires localization
	FT_CANNOT_FIND_ID = "Cannot find the following id", -- Requires localization
	FT_CANNOT_FIND_ID2 = "Please report this id", -- Requires localization
	FT_INFO = "If you use both options if possible the accurate time will be shown otherwise the times from fast tracking.", -- Requires localization
	FT_MINUTE_SHORT = "m", -- Requires localization
	FT_MISSING_HOPS = "Missing hops", -- Requires localization
	FT_MODUS = "Modus", -- Requires localization
	FT_MOVE = "Shift+Left click to move the window", -- Requires localization
	FT_SECOND_SHORT = "s", -- Requires localization
	FT_SHOW_ACCURATE_MAP = "Show accurate flight times if known on the flight map", -- Requires localization
	FT_TIME_LEFT = "Time left", -- Requires localization
	FT_USE_ACCURATE_TRACK = "Accurate tracking", -- Requires localization
	FT_USE_ACCURATE_TRACK_EXPLAIN = "With this enabled every possible flight combination will be tracked, resulting in accurate times, but will take long to record all possible combination. This is due even flying the same flight path forth and back can be different and there are just alot of combinations.", -- Requires localization
	FT_USE_FAST_TRACK = "Fast tracking", -- Requires localization
	FT_USE_FAST_TRACK_EXPLAIN = "This allows to track flight times fast, with the withdraw of not being accurate, this is done by tracking on longer flight every hop, that it wont be accurate is due the fact that the flight usually is different if you just pass a flight point or end the flight there", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED = "Do not track fast/slow taxis", -- Requires localization
	FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN = "If fast tracking is activated with this option on it will only track times with normal taxi speed resulting in more accurate times in most cases, the slow/fast taxis are very rare.", -- Requires localization
	LEFT_BUTTON = "Left", -- Requires localization
	LOCK_ADDON_FRAME = "Lock Addon Frame", -- Requires localization
	MFM_THE_ALDOR = "The Aldor", -- Requires localization
	MFM_THE_SCRYERS = "The Scryers", -- Requires localization
	MIDDLE_BUTTON = "Middle", -- Requires localization
	MODIFIER_KEY = "Modifier Key", -- Requires localization
	MOUSEBUTTON = "Mouse Button", -- Requires localization
	NEED_VISIT_FLIGHT_MASTER = "You need to visit a Flight Master for this continent first", -- Requires localization
	NEED_VISIT_FLIGHT_MASTER_MINIMAP = "You need to open the flight map once for this continent before you can use this feature", -- Requires localization
	NEW_FLIGHT_PATH_DISCOVERED_HELP = "You have flight path location and/or flight times in your local database, which arent in the addon database yet, help to increase the known flight path locations/flight times and upload your data on http://flightmap.wowuse.com/", -- Requires localization
	NEXT_FLIGHT_GOTO = "Next fly will goto", -- Requires localization
	NO = "No", -- Requires localization
	NO_FLIGHT_LOCATIONS_KNOWN = "No known flight location for the map", -- Requires localization
	NONE = "None", -- Requires localization
	RIGHT_BUTTON = "Right", -- Requires localization
	SHIFT_KEY = "Shift", -- Requires localization
	SHOW_MINIMAP_BUTTON = "Show Minimap Button", -- Requires localization
	TOOLTIP_FLIGHTMAP_COLLAPSE = "If checked every time the Flight Map is opened all zones will be collapsed", -- Requires localization
	TOOLTIP_LINE1_MINIMAP = "Right click to move the Minimap Icon around", -- Requires localization
	TOOLTIP_LINE2_MINIMAP = "Left click to choose your next flight destination", -- Requires localization
	WMC_MODIFIER_SETTINGS = "Choose the key and mouse combination to pick the closest flight location", -- Requires localization
	WMC_SHOW_ON_MINIMAP = "Show the closest flight master on the Minimap from your current position if you click on the World Map", -- Requires localization
	YES = "Yes", -- Requires localization
}


