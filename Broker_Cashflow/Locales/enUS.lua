--[[ *******************************************************************
Project                 : Broker_Cashflow
Description             : English translation file (enUS)
Author                  : Aledara (wowi AT jocosoft DOT com)
Translator              : Aledara (wowi AT jocosoft DOT com)
Revision                : $Rev: 36 $
********************************************************************* ]]

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale( "Cashflow", "enUS", true, true )
if not L then return end

-- Name of currency
L["NAME_YES"]			= "Yes"
L["NAME_NO"]			= "No"
L["NAME_MONEY"]			= "Money"
L["NAME_DALJCTOKEN"]		= "Dalaran Jewelcrafter's Token"
L["NAME_ILLJCTOKEN"]		= "Illustrious Jewelcrafter's Token"
L["NAME_DALCOOKINGAWARD"]	= "Dalaran Cooking Award"
L["NAME_CHEFSAWARD"]		= "Chef's Award"

L["NAME_CHAMPIONSEAL"]		= "Champion's Seal"
L["NAME_JUSTICEPOINTS"]		= "Justice Points"
L["NAME_VALORPOINTS"]		= "Valor Points"
L["NAME_HONORPOINTS"]		= "Honor Points"
L["NAME_CONQUESTPOINTS"]	= "Conquest Points"
L["NAME_TOLBARADCOMMENDATION"]	= "Tol Barad Commendation"

-- Name of archaeology fragments
L["NAME_AF_DWARF"]		= "Dwarf"
L["NAME_AF_DRAENEI"]		= "Draenei"
L["NAME_AF_FOSSIL"]		= "Fossil"
L["NAME_AF_NIGHTELF"]		= "Night Elf"
L["NAME_AF_NERUBIAN"]		= "Nerubian"
L["NAME_AF_ORC"]		= "Orc"
L["NAME_AF_TOLVIR"]		= "Tol'vir"
L["NAME_AF_TROLL"]		= "Troll"
L["NAME_AF_VRYKULL"]		= "Vrykull"
L["NAME_AF_OTHER"]		= "Other"

-- Config panel - Main
L["CFGHDR_TOOLTIP"]		= "Tooltip"
L["CFGNAME_CASHFORMAT"]		= "Cash format"
L["CFGDESC_CASHFORMAT"]		= "Choose how money will be displayed"
L["CFGOPT_CF_CONDENSED"]	= "Condensed"
L["CFGOPT_CF_SHORT"]		= "Short"
L["CFGOPT_CF_FULL"]		= "Full"
L["CFGOPT_CF_COINS"]		= "Coins"
L["CFGNAME_TTSCALE"]		= "Tooltip scale"
L["CFGDESC_TTSCALE"]		= "Choose the size of the tooltip"
L["CFGNAME_SHOWCASHDETAIL"]	= "Show cash detail"
L["CFGDESC_SHOWCASHDETAIL"]	= "Show the cash gained/spent rows"
L["CFGHDR_BUTTON"]		= "Button"
L["CFGNAME_BUTTONFIRST"]	= "First"
L["CFGDESC_BUTTONFIRST"]	= "First currency to show on button"
L["CFGNAME_BUTTONSECOND"]	= "Second"
L["CFGDESC_BUTTONSECOND"]	= "Second currency to show on button"
L["CFGNAME_BUTTONTHIRD"]	= "Third"
L["CFGDESC_BUTTONTHIRD"]	= "Third currency to show on button"
L["CFGNAME_BUTTONFOURTH"]	= "Fourth"
L["CFGDESC_BUTTONFOURTH"]	= "Fourth currency to show on button"
L["CFGOPT_BTNNONE"]		= "None"
L["CFGOPT_BTNMONEY"]		= "Current Money"
L["CFGOPT_BTNSESSIONTOTAL"]	= "Session gold total"
L["CFGOPT_BTNSESSIONPERHOUR"]	= "Session gold/Hr"
L["CFGOPT_BTNTODAYTOTAL"]	= "Today gold total"
L["CFGOPT_BTNTODAYPERHOUR"]	= "Today gold/Hr"
L["CFGOPT_BTNWEEKTOTAL"]	= "This week gold total"
L["CFGOPT_BTNWEEKPERHOUR"]	= "This week gold/Hr"
L["CFGOPT_BTNMONTHTOTAL"]	= "This month gold total"
L["CFGOPT_BTNMONTHPERHOUR"]	= "This month gold/Hr"
L["CFGOPT_BTNOTHER"]		= "Current %s"

L["CFGPAGE_SECTIONS"]		= "Sections"
L["CFGNAME_THISSESSION"]	= "This session"
L["CFGHDR_HISTORY"]		= "History sections"
L["CFGNAME_TODAYSELF"]		= "Today (self)"
L["CFGNAME_TODAYTOTAL"]		= "Today (total)"
L["CFGNAME_YESTERDAYSELF"]	= "Yesterday (self)"
L["CFGNAME_YESTERDAYTOTAL"]	= "Yesterday (total)"
L["CFGNAME_WEEKSELF"]		= "This week (self)"
L["CFGNAME_WEEKTOTAL"]		= "This week (total)"
L["CFGNAME_MONTHSELF"]		= "This month (self)"
L["CFGNAME_MONTHTOTAL"]		= "This month (total)"
L["CFGNAME_TIPOPTIONS"]		= "Right-click for options"
L["CFGNAME_TIPRESETSESSION"]	= "Shift-Click to reset session"
L["CFGNAME_GAINED"]		= "Gained"
L["CFGNAME_SPENT"]		= "Spent"
L["CFGNAME_PROFIT"]		= "Profit"
L["CFGHDR_OTHERCHARS"]		= "Other characters on realm"
L["CFGNAME_OTHERCHARS"]		= "Show other characters"
L["CFGDESC_OTHERCHARS"]		= 'Show section "Characters"'
L["CFGNAME_CHARACTERS"]		= "Characters"
L["CFGNAME_SORTOTHERCHARS"]	= "Sort characters by"
L["CFGDESC_SORTOTHERCHARS"]	= "Choose how the character list will be sorted"
L["CFGOPT_SORTNAME"]		= "Name"
L["CFGNAME_SORTDESC"]		= "Sort Descending"
L["CFGDESC_SORTDESC"]		= "If checked, items will be sorted from high to low"
L["CFGHDR_TOTALS"]		= "Totals"
L["CFGNAME_TOTAL"]		= "Total"
L["CFGNAME_SHOWTOTALS"]		= "Show totals"
L["CFGDESC_SHOWTOTALS"]		= "Show totals of all your characters on this realm"

L["CFGPAGE_COLUMNS"]		= "Columns"
L["CFGHDR_GENERAL"]		= "General"
L["CFGNAME_SHOWCASHPERHOUR"]	= "Show cash per hour"
L["CFGDESC_SHOWCASHPERHOUR"]	= "Show the cash per hour column"
L["CFGDESC_SHOWCOLUMNFOR"]	= "Show tooltip column for %s"
L["CFGHDR_PVE"]			= "PVE Currency"
L["CFGHDR_PVP"]			= "PVP Currency"
L["CFGHDR_ARCHFRAGMENTS"]	= "Archeology Fragments"
L["CFGHDR_OTHERCURRENCY"]	= "Other Currency"

L["CFGPAGE_CHARACTERS"]		= "Characters"
L["CFGTXT_IGNOREDCHARS"]	= "Ignored characters will be completely igonered by this addon. They will not build any history, will not show up in the tooltip, and will not be included in any calculations."
L["CFGNAME_IGNORECHARS"]	= "Ignore characters"

L["CFGHDR_DELETECHAR"]		= "Delete character"
L["CFGDESC_DELETECHAR"]		= "Select a character to delete"
L["CFGTXT_DELETECHAR"]		= "If a character is deleted, all history of it will be removed."

L["CFGNAME_DELETE"]		= "Delete"
L["CFG_CONFIRMDELETE"]		= 'Are you sure you want to delete character "%s"?'
L["CFG_CONFIRMRESETSESSION"]	= "Are you sure you want to reset the current session?"

L["CFGPAGE_PROFILES"]		= "Profiles"
