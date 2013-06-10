local _G = _G

-- addon name and namespace
local ADDON, NS = ...

-- local functions
local string_format = string.format
local tinsert       = table.insert
local pairs         = pairs
local tostring      = tostring

local GetFactionInfo          = _G.GetFactionInfo
local GetFriendshipReputation = _G.GetFriendshipReputation

-- get translations
local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- coloring tools
local Crayon = LibStub:GetLibrary("LibCrayon-3.0")

-- colors
NS.HexColors = {
	Blueish  = "04adcb",
	Brownish = "eda55f",
	GrayOut  = "888888",
	Green    = "00ff00",
	Magenta  = "ff00ff",
	Orange   = "e54100",
	Red      = "ff0000",
	White    = "ffffff",
	Yellow   = "ffff00",
}

-- utilities
local cmdLinePattern = "^ *([^%s]+) *"

function NS:GetArgs(str)
   local ret = {}
   local pos=0
   
   while true do
     local word
     _, pos, word=string.find(str, cmdLinePattern, pos+1)
	 
     if not word then
       break
     end
	 
     --word = string.lower(word)
     table.insert(ret, word)
   end
   
   return ret
end

function NS:Colorize(color, text)
    if not text then
	    return ""
	end

	if type(text) ~= "string" then
		text = tostring(text)
	end
	
	if NS.HexColors[color] then
		text = text:gsub("(.*)(|r)", "%1%2|cff" .. NS.HexColors[color])
		text = "|cff" .. NS.HexColors[color] .. tostring(text) .. "|r"
	end
	
	return text
end

function NS:ColorizeByValue(value, from, to, ...)
	if value and Crayon then
		from = from or 0
		to   = to or 1
		
		local hexColor = Crayon:GetThresholdHexColor(value, from, to)
		
		local args = {...}
		local ret = {}
		
		for k, v in ipairs(args) do
			v = "|cff" .. hexColor .. v .. "|r"
			
			ret[k] = v
		end
		
		return unpack(ret)
	else
		return ...
	end
end

function NS:ClearTable(tab)
	if tab and type(tab) == "table" then
		for k in pairs(tab) do
			tab[k] = nil
		end
	end
end

function NS:FormatTime(stamp)
	stamp = type(stamp) == "number" and stamp or 0
	
	local days    = floor(stamp/86400)
	local hours   = floor((stamp - days * 86400) / 3600)
	local minutes = floor((stamp - days * 86400 - hours * 3600) / 60)
	local seconds = floor((stamp - days * 86400 - hours * 3600 - minutes * 60))

	return string_format("%02d:%02d:%02d", hours, minutes, seconds)
end

local abbreviations = {
		[0]  = "", 
		[1]  = L["k"], 
		[2]  = L["m"], 
		[3]  = L["bn"], 
}

function NS:FormatNumber(number, sep, abbrev, decimals)
	if type(number) ~= "number" then
		return number
	end
	
	local lvl    = 0
	
	if abbrev then
		while number >= 1000 do
			number = number / 1000
			lvl = lvl + 1
			
			if lvl == #abbreviations - 1 then
				break
			end
		end				
	end
	
	number = string.format("%." .. decimals .. "f", number)
	
	local num, decimal = string.match(number,'^(%d*)(.-)$')
	
	if sep then
		num = num:reverse():gsub('(%d%d%d)', "%1"..L[","]):reverse()
		-- remove leading separator if necessary
		-- TODO: move into regexp pattern above
		num = num:gsub('^([^%d])(.*)', "%2")
	end	
	
	-- trim right zeros
	decimal = decimal:gsub('^(%p%d-)(0*)$', "%1")
	
	if decimal == "." then 
		decimal = ""
	else
		-- localize decimal seperator
		decimal = decimal:gsub('^(%p)(%d*)$', L["."].."%2")
	end
	
	return num .. decimal .. abbreviations[lvl]
end

-- reputation interface (merging friendship into rep)
function NS:GetFactionInfo(faction)
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(faction)
		
	local currentRank, maxRank = GetFriendshipReputationRanks(factionID)

	local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
	if friendID ~= nil then		
		standingID = currentRank
		
		-- store localized standing text
		self.friendStanding[standingID] = friendTextLevel
		
		barMin   = friendThreshold
		barMax   = nextFriendThreshold or barMin + 1000
		barValue = friendRep
	end
	
	local atMax = standingID == maxRank and barValue + 1 == barMax
	
	return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, friendID, atMax
end

function NS:GetStandingLabel(standing, friend)
	if friend then
		return NS.friendStanding[standing] or "???"
	else
		return _G["FACTION_STANDING_LABEL"..tostring(standing)] or "???"
	end
end

function NS:GetBlizzardReputationColor(standing, friendship)
	local r, g, b, a = 0, 0, 0, 0
	
	if type(standing) == "number" then
		if friendship then
			standing = standing + 2
		end
	
		if self.blizzRepColors[standing] then
			r = self.blizzRepColors[standing].r
			g = self.blizzRepColors[standing].g
			b = self.blizzRepColors[standing].b
			a = self.blizzRepColors[standing].a
		end
	end
		
	return r, g, b, a
end

NS.friendStanding = {
	[0] = "Stranger",
	[1] = "Acquaintance",
	[2] = "Buddy",
	[3] = "Friend",
	[4] = "Good Friend",
	[5] = "Best Buddy",
}

NS.blizzRepColors = {
	[1] = {r=0.80, g=0.13, b=0.13, a=1}, -- hated
	[2] = {r=1.00, g=0.25, b=0.00, a=1}, -- hostile
	[3] = {r=0.93, g=0.40, b=0.13, a=1}, -- unfriendly
	[4] = {r=1.00, g=1.00, b=0.00, a=1}, -- neutral
	[5] = {r=0.00, g=0.70, b=0.00, a=1}, -- friendly
	[6] = {r=0.00, g=1.00, b=0.00, a=1}, -- honoured
	[7] = {r=0.00, g=0.60, b=1.00, a=1}, -- revered
	[8] = {r=0.00, g=1.00, b=1.00, a=1}, -- exalted
}

