DHUD4 is a recode, new features adition and optimization of Drathal's original DHUD.

********************
Drathals HUD3  - DHUD4
Copyright (c) 2006 by Markus Inger, 2006 by Caeryn Dryad, 2007-2010 by Horacio Hoyos

This file is part of DHUD4.

    DHUD4 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    DHUD2 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DHUD4.  If not, see <http://www.gnu.org/licenses/>.
********************

**DHUD4 is Heads Up Display Addon.**

DHUD4 provides 4 sets of bar to display player, target, pet, focus, target of target and/or vehicle health and power, and target range, druid mana when shapeshifted and threat information. Additionally player buffs, target buffs/debufs and special class abilities are tracked. Two simple cast bars allow player and target casting tracking too. Bar text info and nameplates can be configured using DogTags. 

Slash command: /dhud4

// Renaitre's Profile: // DHUD4 ships with a Renaitre preloaded profile to adjust the addon to the Renaitre UI layout.

=== Known Issues ===
Focusing using drop down menu is now a protected function. Using the focus option in DHUD4 drop-down menus will generate an error. 

== **Global Options** ==
* Config Layout mode to preview settings
* 6 Transparency (Alpha) settings for:
	** Deth
	** In Combat
	** Casting
	** Target Selected
	** Regeneracy
    ** Out of combat
* Addon scale
* Show/Hide Minimap button
* Selectable horizontal frame spacing and global vertical position.
* Show/Hide bar borders
* Show/Hide empty bars
* Selectable font for all DHUD4 texts
* Selectable bars and abilities texture style (DHUD and Renaitre Tribal textures included)
        
== **Player Module** ==
Tracking and layout options for player information.

=== Layout ===
* Two bars to track Health and Power(mana, rage, energy, focus, runic power). Bar's height and color change to provide visual information of current value. 
* Cast bar for player casting
* Configurable layout:
** Centered: One bar at each side of the player
*** Configurable sides: Health Left/Power Right, Health Right/Power Left
** Right/Left: Two bars at the selected side
*** Configurable order: Health Inner/Power Outer, Health Outer/Power Inner
* Option to swap player info to pet bars when in vehicle.

=== Options ===
* Status Icons:
** In Combat
** Resting
** Party Leader
** Master Looter
** PvP Flag (With remaining PvP timer mouseover option)
* Bar text
** Configurable texts using DogTag library
** Show/Hide text for each bar
** Bar's text can be moved while in "Config Layout mode" (alt+click)
* Cast bar:
** Cast bar side
** Cast bar colors
** Spell info = name, countdonw, delay
* Configurable bar colors (full, medium and low level)


== **Target Module** ==
Tracking and layout options for target information.

=== Layout ===
* Two bars to track Health and Power(mana, rage, energy, focus, runic power). Bar's height and color change to provide visual information of current value. 
* Cast bar for target casting
* Configurable layout (player layout overrides these settings):
** Centered: One bar at each side of the player
*** Configurable sides: Health Left/Power Right, Health Right/Power Left
** Right/Left: Two bars at the selected side
*** Configurable order: Health Inner/Power Outer, Health Outer/Power Inner
* Target and Target of Target name plates
** Adjust displayed text with DogTags
** Click to target and drop down menu
* Target buffs and debuffs, with clock effect countdown
** Number of displayed buffs
** Number of columns
* Health bar border color change for range information

=== Options ===
* Status icons
** Raid (X, circle, skull, etc)
** Target PvP Status
** Elite
* Show target bars for NPCs
* Buff/debuff tips
* Swap buffs/debuufs side
* Bar text
** Configurable texts using DogTag library
** Show/Hide text for each bar
** Bar's text can be moved while in "Config Layout mode" (alt+click)
* Cast bar:
** Cast bar side (player layout overrides this setting)
** Cast bar colors
** Spell info = name, countdonw, delay
* Configurable bar colors (full, medium and low level)


== **Pet Module** ==
Tracking and layout options for target information.

=== Layout ===
* Two bars to track Health and Power(mana, rage, energy, focus). Bar's height and color change to provide visual information of current value.  Additionally bars can be used to track vehicle stats, druid mana while shapeshifted and Lunar/Solar Energy
* Configurable layout:
** Centered: One bar at each side of the player
*** Configurable sides: Health Left/Power Right, Health Right/Power Left
** Right/Left: Two bars at the selected side
*** Configurable order: Health Inner/Power Outer, Health Outer/Power Inner

=== Options ===
* Happiness icon
* Configurable side for druid tracking
* Track unit health and power
* Bar text
** Configurable texts using DogTag library
** Show/Hide text for each bar
** Bar's text can be moved while in "Config Layout mode" (alt+click)
* Configurable bar colors (full, medium and low level)


== **Auras Module** ==
Show player buffs and/or weapon enchants close to expiring.

=== Layout ===
* 16 slots that display buff or weapon enchant icon and time left
* Independent scaling

=== Options ===
* Configurable border and text color to emphasize expiration (color starts to change when less than 20 seconds remain)
* Only show mine
* Time filter to display buffs
* Time left font size
* Display weapon enchants as buffs
** Option to configure the slots used by the weapon enchants: two first, two last, two bottom or two top 
* Buffs can be shown to the left or to the right
* Option to show tool tip with information about the buff    


== **Abilities Modules (Class specifics)** ==
Show/track abilities specific to your class applied to your target (DoTs, HoTs, etc), or Death Knight runes.

=== Layout ===
* 12 slots to track abilities
* Independant scaling

=== Options ===
* Configurable border and text color to emphasize expiration/readyness
* Track time left if ability has it

=== Class specific ===
==== Druids ====
* Combo Points
* Lacerates
* Lifeblooms
==== Rogues ====
* Combo Points
==== Warriors ====
* Sunder armors
==== Death Knights ====
* Runes (Runes can be displayed in 1 of 4 possible layouts)
* Holy Power
==== Shamans ====
* Totems
==== Warlocks ====
* Shards
==== Vehicles ====
* Combo points


== **Outer Module** ==

TODO