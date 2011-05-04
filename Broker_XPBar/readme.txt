Broker_XPBar, a World of Warcraft® user interface addon.
Copyright© 2010 Bernhard Voigt, aka tritium - All rights reserved.
License is given to copy, distribute and to make derivative works.

Broker_XPBar - A broker addon that adds XP and reputation info to your Broker addon and attaches a XP/Rep bar to any globally named frame.

Features -

	* Label displays XP or reputation info with colored text depending on progress in level.
	* Tooltip displays extended information about XP and reputation of currently watched faction.
	* Attaches bars for XP and/or reputation to (almost) any globally named frame.
	* Customizable bar colors plus predefined colors for reputation bar baseed on current standing.
	* Ace3 profile support for settings.

New features -

	* optional Minimap-Button to use addon without Broker display 
	* added XP per hour to tooltip
	* added kills to level (KTL) to tooltip and as broker label option
	* added time to level (TTL) to tooltip and as broker label option

	The TTL/KTL predictions are still experimental. Goal is to provide precise predictions based on player preferences. All XP calculations are session only - the idea is to give a prediction based on what you do now. 
	Mob experience is calculated based on the last mob kills and standard deviation is used to eliminate outliers. Possible group bonuses and raid penalties are taken into account as well as rested bonus. The TTL and KTL prediction can be customized. The calculation is based on the data for the whole session and the activity in the last X minutes. The length of the activity frame can be up to 120 minutes. Session and activity XP rates will be weighted for the prediction. 
	Default values are 30 min activity and weighted 0.8. So session data will have an impact of 20% and the last 30 minutes will make up 80% in the calculation. Depending on your preferences you can shift the weight and time frame to favour the whole session or more recent data.
	
	* option to hide bar or Broker text for XP or Rep on reaching max. level or Rep
	* new label options to allow for a single 'omnipotent' configuration that fits the needs of leveling and maxed out chars
	* added "Rep over XP" as broker label option showing reputation values on default and falls back to XP if no faction is watched
	* added "XP over Rep" as broker label option showing XP values on default and falls back to reputation if maximum level is reached
	
	
Install -

	Copy the Broker_XPBar folder to your Interface\AddOns directory.
		
Commands - 

	/brokerxpbar arg
	/bxb arg

	With arg:
	menu - display options menu
	version - display the version information
	help - display this help
	
Usage -

	To attach bars to a frame open the option menu and select the "Frame" category. Click button "Hook to Frame". The mouse cursor gets highlighted and shows the frame name as tooltip for each frame it hovers over. Left-click on desired frame to attach the bars to. Right-click will disable the selection cursor. Frame names may also be entered manually in the edit box. Use the option "Attach to" to select the side (Top or Bottom) of the frame where you want the bars. Fine adjust the position by using the Offset settings if needed. The "Jostle" option displaces the blizzard frames by the width of the bars. This should only be used with frames on the upper and lower edge of the screen and not with free floating frames!
	
	Consider that the Reputation bar is hidden if no faction is watched.