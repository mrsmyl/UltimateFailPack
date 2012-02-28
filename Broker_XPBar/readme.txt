Broker_XPBar, a World of Warcraft® user interface addon.
Copyright© 2010 Bernhard Voigt, aka tritium - All rights reserved.
License is given to copy, distribute and to make derivative works.

Broker_XPBar - A broker addon that adds XP and reputation info to your Broker addon and attaches a XP/Rep bar to any globally named frame.

Features -

	* Label displays XP or reputation info with colored text depending on progress in level.
	* Tooltip displays extended information about XP and reputation of currently watched faction.
	* Attaches bars for XP and/or reputation to (almost) any globally named frame.
	* Customizable bar colors plus predefined colors for reputation bar baseed on current standing.
	* Shows estimated time to level and kills to level.
	* Ace3 profile support for settings.

Install -

	Copy the Broker_XPBar folder to your Interface\AddOns directory.
		
Commands - 

	/brokerxpbar arg
	/bxp arg

	With arg:
	menu - display options menu
	version - display the version information
	help - display this help
	
Usage -

	To attach bars to a frame open the option menu and select the "Frame" category. Click button "Hook to Frame". The mouse cursor gets highlighted and shows the frame name as tooltip for each frame it hovers over. Left-click on desired frame to attach the bars to. Right-click will disable the selection cursor. Frame names may also be entered manually in the edit box. Use the option "Attach to" to select the side (Top or Bottom) of the frame where you want the bars. Fine adjust the position by using the Offset settings if needed. The "Jostle" option displaces the blizzard frames by the width of the bars. This should only be used with frames on the upper and lower edge of the screen and not with free floating frames!
	
	Consider that the Reputation bar is hidden if no faction is watched.