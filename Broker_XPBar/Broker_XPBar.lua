local _G = getfenv(0)

-- addon name and namespace
local ADDON, NS = ...

-- local functions
local tonumber = tonumber
local gsub     = string.gsub
local smatch   = string.match
local sqrt     = math.sqrt
local floor    = math.floor

local GetFactionInfo        = _G.GetFactionInfo
local GetNumFactions        = _G.GetNumFactions
local GetNumGroupMembers    = _G.GetNumGroupMembers
local GetNumSubgroupMembers = _G.GetNumSubgroupMembers
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetXPExhaustion       = _G.GetXPExhaustion
local IsResting             = _G.IsResting
local UnitLevel             = _G.UnitLevel
local UnitXP                = _G.UnitXP
local UnitXPMax             = _G.UnitXPMax

-- setup libs
local LibStub   = LibStub
local LDB       = LibStub:GetLibrary("LibDataBroker-1.1")

-- coloring tools
local Crayon	= LibStub:GetLibrary("LibCrayon-3.0")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale( ADDON )

-- config libraries
local AceConfig 		= LibStub:GetLibrary("AceConfig-3.0")
local AceConfigReg 		= LibStub:GetLibrary("AceConfigRegistry-3.0")
local AceConfigDialog	= LibStub:GetLibrary("AceConfigDialog-3.0")

-- constants
local ICON         = "Interface\\Addons\\"..ADDON.."\\icon.tga"
local ICON_RESTING = "Interface\\Addons\\"..ADDON.."\\iconrest.tga"

-- addon and locals
BrokerXPBar = LibStub:GetLibrary("AceAddon-3.0"):NewAddon(ADDON, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0")

-- addon constants
BrokerXPBar.MODNAME   = "BrokerXPBar"
BrokerXPBar.FULLNAME  = "Broker: XP Bar"

BrokerXPBar.MAX_LEVEL = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

-- player level
BrokerXPBar.playerLvl       = UnitLevel("player")

-- faction variables
BrokerXPBar.faction         = 0

BrokerXPBar.watchedStanding = 0
BrokerXPBar.atMaxRep        = false

BrokerXPBar.FONT_NAME_DEFAULT = "Broker: XP Bar - Default"
BrokerXPBar.FONT_DEFAULT      = "TextStatusBarText"

local ldbObj  = LDB:NewDataObject(ADDON, {
	type	= "data source",
	icon	= ICON,
	label	= BrokerXPBar.MODNAME,
	text	= "Updating...",
	OnClick = function(clickedframe, button) 
		BrokerXPBar:OnClick(button) 
	end,
	OnEnter = function(self)
		BrokerXPBar:CreateTooltip(self)
	end,
	OnLeave = function()
		-- BrokerXPBar:RemoveTooltip()
	end,
})

--  minimap button
do
	local dragMode = nil
	
	local function moveButton(self)
		if dragMode == "free" then
			local centerX, centerY = Minimap:GetCenter()
			local x, y = GetCursorPosition()
			x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
			self:ClearAllPoints()
			self:SetPoint("CENTER", x, y)
		else
			local centerX, centerY = Minimap:GetCenter()
			local x, y = GetCursorPosition()
			x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
			centerX, centerY = abs(x), abs(y)
			centerX, centerY = (centerX / sqrt(centerX^2 + centerY^2)) * 80, (centerY / sqrt(centerX^2 + centerY^2)) * 80
			centerX = x < 0 and -centerX or centerX
			centerY = y < 0 and -centerY or centerY
			self:ClearAllPoints()
			self:SetPoint("CENTER", centerX, centerY)
		end
	end

	local mm_button = CreateFrame("Button", ADDON .. "_MinimapButton", Minimap)
	mm_button:SetHeight(32)
	mm_button:SetWidth(32)
	mm_button:SetFrameStrata("HIGH")
	mm_button:SetPoint("CENTER", -77.44, -20.06)
	mm_button:SetMovable(true)
	mm_button:SetUserPlaced(true)
	mm_button:EnableMouse(true)
	mm_button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	mm_button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	
	local icon = mm_button:CreateTexture(mm_button:GetName() .. "Icon", "HIGH")
	icon:SetTexture(ICON)
	icon:SetTexCoord(0, 1, 0, 1)
	icon:SetWidth(16)
	icon:SetHeight(16)
	icon:SetPoint("TOPLEFT", mm_button, "TOPLEFT", 8, -7)
	
	local overlay = mm_button:CreateTexture(mm_button:GetName() .. "Overlay", "OVERLAY")
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	overlay:SetWidth(53)
	overlay:SetHeight(53)
	overlay:SetPoint("TOPLEFT", mm_button, "TOPLEFT")
	
	mm_button:SetScript("OnClick", function(self, button)
		BrokerXPBar:OnClick(button)
	end)
	
	mm_button:SetScript("OnMouseDown", function(self, button)
		if IsShiftKeyDown() and IsControlKeyDown() then
			dragMode = "free"
			self:SetScript("OnUpdate", moveButton)
		elseif IsShiftKeyDown() then
			dragMode = nil
			self:SetScript("OnUpdate", moveButton)
		end
	end)
	
	mm_button:SetScript("OnMouseUp", function(self)
		self:SetScript("OnUpdate", nil)
	end)

	mm_button:SetScript("OnEnter", function(self)
		BrokerXPBar:CreateTooltip(self)
	end)
	
	mm_button:SetScript("OnLeave", function(self)
		BrokerXPBar:RemoveTooltip()
	end)

	mm_button:Hide()

	function BrokerXPBar:ShowMinimapButton(show)
		if show then
			mm_button:Show()
		else
			mm_button:Hide()
		end
	end

	function BrokerXPBar:SetMinimapIcon(active)
		if active then
			icon:SetTexture(ICON)
		else
			icon:SetTexture(ICON_RESTING)
		end
	end
end

-- helper functions
local function GetArgs(str, pattern)
   local ret = {}
   local pos=0
   
   while true do
     local word
     _, pos, word=string.find(str, pattern, pos+1)
	 
     if not word then
       break
     end
	 
     -- word = string.lower(word)
     table.insert(ret, word)
   end
   
   return ret
end

local abbreviations = {
		[0]  = "", 
		[1]  = L["k"], 
		[2]  = L["m"], 
		[3]  = L["bn"], 
}

local function FormatNumber(number, sep, abbrev, decimals)
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

-- colors
NS.HexColors = {
	Red      = "ff0000",
	White    = "ffffff",
	Yellow   = "ffff00",
	Brownish = "eda55f",
	Orange   = "e54100",
	Blueish  = "04adcb",
}

function NS:Colorize(color, text) 
	if not text then
		text = tostring(text)
	end
	
	if NS.HexColors[color] then
		text = text:gsub("(.*)(|r)", "%1%2|cff" .. NS.HexColors[color])
		text = "|cff" .. NS.HexColors[color] .. tostring(text) .. "|r"
	end
	
	return text
end

-- aux variables
local countInitial = 0

local blizzRepColors = {
	[1] = {r=0.80, g=0.13, b=0.13, a=1}, -- hated
	[2] = {r=1.00, g=0.25, b=0.00, a=1}, -- hostile
	[3] = {r=0.93, g=0.40, b=0.13, a=1}, -- unfriendly
	[4] = {r=1.00, g=1.00, b=0.00, a=1}, -- neutral
	[5] = {r=0.00, g=0.70, b=0.00, a=1}, -- friendly
	[6] = {r=0.00, g=1.00, b=0.00, a=1}, -- honoured
	[7] = {r=0.00, g=0.60, b=1.00, a=1}, -- revered
	[8] = {r=0.00, g=1.00, b=1.00, a=1}, -- exalted
}

-- combat log processing
-- using wow constants to avoid localization issues
-- NOTE: rested bonus and penalty(?) are string literals for some reason
local XPGAIN_SINGLE
local XPGAIN_SINGLE_RESTED
local XPGAIN_SINGLE_PENALTY
local XPGAIN_GROUP
local XPGAIN_GROUP_RESTED
local XPGAIN_GROUP_PENALTY
local XPGAIN_RAID
local XPGAIN_RAID_RESTED
local XPGAIN_RAID_PENALTY

do
-- NOTE: russian and korean clients use POSIX position indicators in COMBATLOG_XPGAIN_ patterns, 
-- which LUAs functions like string.find() or string.format() do not support
-- thx to Lua 5 for kicking them out of the language: "The format option %n$ is obsolete."
-- apparently argument 3 and 4 are always exchanged in those localizations
-- so we get rid of the position indicators and manually switch back the args after matching
	local temp
	
	-- "%s dies, you gain %d experience."
	temp                  = gsub(COMBATLOG_XPGAIN_FIRSTPERSON,      "(%%[0-9]$)([ds])", "%%%2") -- position indicators
	temp                  = gsub(temp,                              "%%s",   "(.+)")   -- string pattern
	XPGAIN_SINGLE         = gsub(temp,                              "%%d",   "(%%d+)") -- number pattern

	-- "%s dies, you gain %d experience. (%s exp %s bonus)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION1,      "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                              "[()+-]", "[%0]")  -- mask '(', ')', '+', '-'
	temp                  = gsub(temp,                              "%%s",    "(.+)")
	XPGAIN_SINGLE_RESTED  = gsub(temp,                              "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (%s exp %s penalty)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION4,      "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                              "[()+-]", "[%0]")
	temp                  = gsub(temp,                              "%%s",    "(.+)")
	XPGAIN_SINGLE_PENALTY = gsub(temp,                              "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (+%d group bonus)"
	temp                  = gsub(COMBATLOG_XPGAIN_FIRSTPERSON_GROUP, "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_GROUP          = gsub(temp,                               "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (%s exp %s bonus, +%d group bonus)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION1_GROUP, "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_GROUP_RESTED   = gsub(temp,                               "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (%s exp %s penalty, +%d group bonus)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION4_GROUP, "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_GROUP_PENALTY  = gsub(temp,                               "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (-%d raid penalty)"
	temp                  = gsub(COMBATLOG_XPGAIN_FIRSTPERSON_RAID,  "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_RAID           = gsub(temp,                               "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (%s exp %s bonus, -%d raid penalty)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION1_RAID,  "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_RAID_RESTED    = gsub(temp,                               "%%d",    "(%%d+)")

	-- "%s dies, you gain %d experience. (%s exp %s penalty, -%d raid penalty)"
	temp                  = gsub(COMBATLOG_XPGAIN_EXHAUSTION4_RAID,  "(%%[0-9]$)([ds])", "%%%2")
	temp                  = gsub(temp,                               "[()+-]", "[%0]")
	temp                  = gsub(temp,                               "%%s",    "(.+)")
	XPGAIN_RAID_PENALTY   = gsub(temp,                               "%%d",    "(%%d+)")
end

local defaults = {
	profile = {
		ShowText         = "XP",
		ShowXP           = true,
		ShowRep          = false,
		Shadow           = true,
		Thickness        = 2,
		Spark            = 1,
		Inverse          = false,
		ExternalTexture  = false,
		Texture          = nil,
		ToGo             = true,
		ShowValues       = true,
		ShowPercentage   = true,
		ShowFactionName  = true,
		ColoredText      = true,
		Separators       = false,
		Abbreviations    = false,
		TTAbbreviations  = false,
		DecimalPlaces    = 2,
		ShowBlizzBars    = false,
		HideHint         = false,
		Location         = "Bottom",
		xOffset          = 0,
		yOffset          = 0,
		Inside           = false,
		Strata           = "HIGH",
		Jostle           = false,
		BlizzRep         = true,
        Minimap	         = false,
        MaxHideXPText    = false,
        MaxHideXPBar     = false,
        MaxHideRepText   = false,
        MaxHideRepBar    = false,
        AutoTrackOnGain  = false,
        AutoTrackOnLoss  = false,
		XP               = {r=0.0, g=0.4, b=0.9, a=1},
		Rest             = {r=1.0, g=0.2, b=1.0, a=1},
		None             = {r=0.0, g=0.0, b=0.0, a=1},
		Rep              = {r=1.0, g=0.2, b=1.0, a=1},
		NoRep            = {r=0.0, g=0.0, b=0.0, a=1},
		Weight           = 0.8,
		TimeFrame        = 30,
		TTHideXPDetails  = false,
		TTHideRepDetails = false,
		Ticks            = 0,
		ShowBarText      = false,
		MouseOver        = false,
		Font             = BrokerXPBar.FONT_NAME_DEFAULT,
		FontSize         = 6,
	}
}

-- infrastructure
function BrokerXPBar:OnInitialize()
	-- debug
	self.debug = false

	-- options
	self.options = {}

	self.db = LibStub:GetLibrary("AceDB-3.0"):New(self.MODNAME.."_DB", defaults, "Default")
	self:SetupOptions()
	
	-- profile support
	self.options.args.profile = LibStub:GetLibrary("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied",  "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset",   "OnProfileChanged")
	
	AceConfigReg:RegisterOptionsTable(self.FULLNAME, self.options)
	AceConfigDialog:AddToBlizOptions(self.FULLNAME)

    self:RegisterChatCommand("brokerxpbar", "ChatCommand")
	self:RegisterChatCommand("bxp",         "ChatCommand")
	
	self.Bar:Initialize()
end

function BrokerXPBar:OnEnable()
	-- init session vars
	self.playerLvl = UnitLevel("player")
	
	-- init xp history
	self.History:Initialize()
	
	self.History:SetTimeFrame(self:GetSetting("TimeFrame") * 60)
	self.History:SetWeight(self:GetSetting("Weight"))

	-- init reputation history
	self.ReputationHistory:Initialize()
	
	self.ReputationHistory:SetTimeFrame(self:GetSetting("TimeFrame") * 60)
	self.ReputationHistory:SetWeight(self:GetSetting("Weight"))
	
	self:RegisterBucketEvent("UPDATE_EXHAUSTION", 60, "Update")
    self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateIcon")
	self:RegisterEvent("UPDATE_FACTION", "UpdateStanding")
	
	if self.playerLvl < self.MAX_LEVEL then
		self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:RegisterEvent("PLAYER_XP_UPDATE")
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end
	
	self:RegisterAutoTrack()
	self:RegisterTTL()	
	
	self:UpdateIcon()	

	-- if we don't want to show the bars we hide them else we leave them as they are
	if not self:GetSetting("ShowBlizzBars") then
		self:ShowBlizzardBars(false)
	end
	
	self:RefreshBarSettings()
	self:InitialAnchoring()
	
	self:ShowMinimapButton(self:GetSetting("Minimap"))

	self:Update()
end

function BrokerXPBar:OnDisable()
	self.Bar:Hide()

	self:ShowMinimapButton(false)
	
	-- if we hid the bars ourselves we restore them else we leave them as they are
	if not self:GetSetting("ShowBlizzBars") then
		self:ShowBlizzardBars(true)
	end
	
	self:UnregisterEvent("PLAYER_UPDATE_RESTING")
	self:UnregisterEvent("UPDATE_FACTION")
	
	if self.playerLvl < self.MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
	end

	self:RegisterAutoTrack(false)
	self:RegisterTTL(false)	
	
	self:UnregisterAllBuckets()
	self:UnhookAll()	
end

function BrokerXPBar:ChatCommand(input)
    if input then  
		args = GetArgs(input, "^ *([^%s]+) *")
		
		self:TriggerAction(args[1] and string.lower(args[1]) or nil, args)
	else
		self:TriggerAction("help")
	end
end

function BrokerXPBar:OnProfileChanged(event, database, newProfileKey)
	self.db.profile = database.profile
	
	self:ShowMinimapButton(self:GetSetting("Minimap"))
	self:ShowBlizzardBars(self:GetSetting("ShowBlizzBars")) 

	self.History:SetTimeFrame(self:GetSetting("TimeFrame") * 60)
	self.History:SetWeight(self:GetSetting("Weight"))
	
	self.History:Process()
	
	self:RegisterAutoTrack()
	self:RegisterTTL()		

	self:RefreshBarSettings()
	
	self:Update()	
end

function BrokerXPBar:OnClick(button)
	if ( button == "RightButton" ) then 
		if IsShiftKeyDown() then
			-- unused
		elseif IsControlKeyDown() then
			-- unused
		elseif IsAltKeyDown() then
			-- unused
		else
			-- open options menu
			self:TriggerAction("menu")
		end
	elseif ( button == "LeftButton" ) then 
		if IsShiftKeyDown() then
			-- reputation to open edit box
			self:TriggerAction("reputation")
		elseif IsControlKeyDown() then
			-- unused
		elseif IsAltKeyDown() then
			-- unused
		else
			-- xp to open edit box
			self:TriggerAction("xp")
		end
	end
end

function BrokerXPBar:TriggerAction(action, args)
	if action == "xp" then
		-- xp to open edit box
		self:OutputExperience()
	elseif action == "reputation" then
		-- reputation to open edit box
		self:OutputReputation()
	elseif action == "menu" then
		-- open options menu
		InterfaceOptionsFrame_OpenToCategory(self.FULLNAME)
	elseif action == "debug" then
		if args[2] and string.lower(args[2]) == "on" then
			self:Output("debug mode turned on")
			self.debug = true
		end
		if args[2] and string.lower(args[2]) == "off" then
			self:Output("debug mode turned off")
			self.debug = false
		end
	elseif action == "setting" then
		self:Output("Setting: " .. tostring(args[2]) .. " = " .. tostring(self:GetSetting(args[2])))
	elseif action == "bar" then
		self:UserSetBarProgress(args[2], args[3])
	elseif action == "refresh" then
		self.Bar:Reanchor()
		self:Output("Refresh done.")
	elseif action == "update" then
		self:Update()
		self:Output("Update done.")
	elseif action == "version" then
		-- print version information
		self:PrintVersionInfo()
	else -- if action == "help" then
		-- display help
		self:Output(L["Usage:"])
		self:Output(L["/brokerxpbar arg"])
		self:Output(L["/bxp arg"])
		self:Output(L["Args:"])
		self:Output(L["version - display version information"])
		self:Output(L["menu - display options menu"])
		self:Output(L["help - display this help"])
	end
end

function BrokerXPBar:RegisterAutoTrack(register)
	if register == nil then
		register = self:GetSetting("AutoTrackOnLoss") or self:GetSetting("AutoTrackOnLoss")
	end
	
	if register then
		self:RegisterEvent("COMBAT_TEXT_UPDATE")
	else
		self:UnregisterEvent("COMBAT_TEXT_UPDATE")
	end
end

function BrokerXPBar:RegisterTTL(register)
	if register == nil then
		register = self:GetSetting("ShowText") == "TTL" or self:GetSetting("ShowText") == "TTLRep"
	end
	
	if register then
		if not self.timer then
			self.timer = self:ScheduleRepeatingTimer("UpdateLabel", 1)
		end
	else
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
		end
	end
end

function BrokerXPBar:RefreshBarSettings()
	-- layout settings
	for option in pairs(self.Bar.settings) do
		if option == "ShowXP" then
			self.Bar:SetSetting(option, self:IsBarRequired("XP"), true)
		elseif option == "ShowRep" then
			self.Bar:SetSetting(option, self:IsBarRequired("Rep"), true)
		elseif option == "Texture" then
			self.Bar:SetSetting(option, self:GetSetting("ExternalTexture") and self:GetSetting("Texture") or nil, true)
		else
			self.Bar:SetSetting(option, self:GetSetting(option), true)
		end
	end

	-- update colors
	for id in pairs(self.Bar.colors) do
		local r, g, b, a = self:GetColor(id)
		
		if id == "Rep" and self:GetSetting("BlizzRep") then
			r, g, b, a = self:GetBlizzardReputationColor()
		end
		
		self.Bar:SetColor(id, r, g, b, a)
	end
	
	self.Bar:Reanchor()
end

function BrokerXPBar:InitialAnchoring()
	-- try to attach to the anchor frame for 30 secs and then give up
	if not self.Bar.anchored and countInitial < 30 then
		self.Bar:Reanchor()
		countInitial = countInitial + 1
		self:ScheduleTimer("InitialAnchoring", 1)
	else
		self.Bar:SetSetting("Texture", self:GetSetting("ExternalTexture") and self:GetSetting("Texture") or nil)
		self:UpdateWatchedFactionIndex()
		self:UpdateStanding()
	end
end

-- update functions
function BrokerXPBar:Update()
	self:UpdateBar()
	self:UpdateLabel()
end

function BrokerXPBar:UpdateBar()
	if self:GetSetting("ShowXP") then
		local currentXP = UnitXP("player")
		local maxXP     = UnitXPMax("player")
		local restXP    = GetXPExhaustion() or 0
		
		local xp     = currentXP / maxXP
		local rested = restXP / maxXP
		
		local oldValue = self.Bar.progress.XP
		
		self.Bar:SetBarProgress("XP", xp)
		self:Debug("UpdateBar: Progress for bar XP set to " .. tostring(self.Bar.progress.XP) .. " (from " .. oldValue .. ")")
		
		oldValue = self.Bar.progress.Rested
		
		self.Bar:SetBarProgress("Rested", rested)
		self:Debug("UpdateBar: Progress for bar Rested set to " .. tostring(self.Bar.progress.Rested) .. " (from " .. oldValue .. ")")
		
		local text = ""
		
		if self:GetSetting("ShowBarText") then
			text = string.format("%s / %s", self:FormatNumberLabel(currentXP), self:FormatNumberLabel(maxXP))
		end
		
		self.Bar:SetText("XP", text)		
	end

	if self:GetSetting("ShowRep") then
		local reputation = 0
		local text = ""
		
		if self.faction ~= 0 then
			local name, standing, minRep, maxRep, currentRep = nil, 0, 0, 0, 0
			
			name, _, standing, minRep, maxRep, currentRep = GetFactionInfo(self.faction)
			
			reputation = (currentRep - minRep) / (maxRep - minRep)
			
			if self:GetSetting("ShowBarText") then
				text = string.format("%s / %s", self:FormatNumberLabel(currentRep - minRep), self:FormatNumberLabel(maxRep - minRep))
			end
		end

		local oldValue = self.Bar.progress.Reputation
		
		self.Bar:SetBarProgress("Reputation", reputation)
		self:Debug("UpdateBar: Progress for bar Reputation set to " .. tostring(self.Bar.progress.Reputation) .. " (from " .. oldValue .. ")")		
		
		self.Bar:SetText("Reputation", text)
	end
		
	self.Bar:Update()
end

function BrokerXPBar:UpdateLabel()
	local show = self:GetSetting("ShowText")

	if show == "XPFirst" then
		if self.playerLvl == self.MAX_LEVEL then
			show = "Rep"
		else
			show = "XP"
		end
	elseif show == "RepFirst" then
		if self.faction == 0 then
			show = "XP"
		else
			show = "Rep"
		end
	end
	
    if show == "XP" or
	   show == "TTL" or
	   show == "KTL" then
		if self.playerLvl == self.MAX_LEVEL then
			if self:GetSetting("MaxHideXPText") then
				ldbObj.text = ""
			else
				ldbObj.text = L["Max Level"]
			end
			return
		end
	end
	
	if show == "Rep" and self.atMaxRep and self:GetSetting("MaxHideRepText") then
		ldbObj.text = ""
		return
	end

    if show == "Rep" or show == "XP"  then
		local current, min, max = 0, 0, 100
		local name
		local label, values, percentage  = "", "", ""
		
		if show == "XP" then
			current, max = UnitXP("player"), UnitXPMax("player")
		else
			if self.faction == 0 then
				ldbObj.text = L["No watched faction"]
				return
			end
			
			name, _, _, min, max, current = GetFactionInfo(self.faction)
						
			current = current - min
			max     = max - min
			
			if self:GetSetting("ShowFactionName") then
				label  = name ..": "
			end
		end
        
        if self:GetSetting("ToGo") then
			local toGo        = max - current
			local percentToGo = floor(toGo / max * 100)
			
			if Crayon and self:GetSetting("ColoredText") then
				values     = "|cff"..Crayon:GetThresholdHexColor(toGo, max, max * 0.75, max * 0.5, max * 0.25, 1) .. self:FormatNumberLabel(toGo) .. "|r"
				percentage = "|cff"..Crayon:GetThresholdHexColor(percentToGo, 100, 75, 50, 1) .. percentToGo .. "|r"
			else
				values     = self:FormatNumberLabel(toGo)
				percentage = percentToGo
			end			
        else 
			local percent = floor(current/max * 100)
			
			if Crayon and self:GetSetting("ColoredText") then
				values     = "|cff"..Crayon:GetThresholdHexColor(current, 1, max * 0.25, max * 0.5, max * 0.75, max) .. self:FormatNumberLabel(current) .. "|r"
				percentage = "|cff"..Crayon:GetThresholdHexColor(percent, 1, 25, 50, 75, 100) .. percent .. "|r"
			else
				values     = self:FormatNumberLabel(current)
				percentage = percent
			end
			
			values = values .. "/" .. self:FormatNumberLabel(max)
        end
		
		if self:GetSetting("ShowValues") then
			label = label .. values
		end
			
		if self:GetSetting("ShowPercentage") then
			if self:GetSetting("ShowValues") then
				label = label .. " (" .. percentage .. "%)"
			else
				label = label .. percentage .. "%"
			end
		end
		
		ldbObj.text = label
    elseif show == "TTL" then		
		self.History:Process()
			
		ldbObj.text = L["TTL"] .. ": " .. self.History:GetTimeToLevel()
    elseif show == "KTL" then
		self.History:Process()
			
		ldbObj.text = L["KTL"] .. ": " .. NS:Colorize("Red", self.History:GetKillsToLevel() )
    elseif show == "TTLRep" then		
		self.ReputationHistory:Process()
			
		ldbObj.text = L["TTLRep"] .. ": " .. (self.ReputationHistory:GetTimeToLevel(self.faction) or L["no data"])
    else
        ldbObj.text = self.FULLNAME
    end
end

function BrokerXPBar:UpdateIcon()
	local resting = IsResting() or false
	
    if resting then
		ldbObj.icon = ICON_RESTING
    else
		ldbObj.icon = ICON
    end
	
	self:SetMinimapIcon(not resting)
end

function BrokerXPBar:UpdateStanding()
	local standing = 0
	
	-- check for changes in watched faction
	self:UpdateWatchedFactionIndex()
	
	if self.faction ~= 0 then
		local minRep, maxRep, currentRep = 0, 0, 0
		_, _, standing, minRep, maxRep, currentRep = GetFactionInfo(self.faction)
		
		if not self.atMaxRep and standing == 8 and currentRep + 1 == maxRep then
			self:MaxReputationReached()
		end
	end
		
	if standing ~= self.watchedStanding then
		self.watchedStanding = standing
		
		if self:GetSetting("BlizzRep") then
			local r, g, b, a = self:GetBlizzardReputationColor()

			self.Bar:SetColor("Rep", r, g, b, a)
		end
	end

	self.ReputationHistory:Update()
	
	self:Update()
end

function BrokerXPBar:MaxLevelReached()
	if self.playerLvl == self.MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
		
		self.Bar:SetSetting("ShowXP", self:IsBarRequired("XP"))
	end
end

function BrokerXPBar:MaxReputationReached()
	if not self.atMaxRep then
		self.atMaxRep = true
		
		self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))
	end
end

-- events
function BrokerXPBar:PLAYER_XP_UPDATE()
	self.History:UpdateXP()

	self:Update()
end

function BrokerXPBar:CHAT_MSG_COMBAT_XP_GAIN(_, xpMsg)
	-- kill, rested, group, penalty, raid penalty
	local kxp, rxp, gxp, pxp, rpxp
	local bonusType
	local kill = 0
	local mob
	
	if GetNumGroupMembers() > 0 then
		mob, kxp, rpxp = smatch(xpMsg, XPGAIN_RAID)
		
		if not mob then
			mob, kxp, rxp, bonusType, rpxp = smatch(xpMsg, XPGAIN_RAID_RESTED)
		end
		
		if not mob then
			mob, kxp, pxp, bonusType, rpxp = smatch(xpMsg, XPGAIN_RAID_PENALTY)
		end
	elseif GetNumSubgroupMembers() > 0 then
		mob, kxp, gxp = smatch(xpMsg, XPGAIN_GROUP)
		
		if not mob then
			mob, kxp, rxp, bonusType, gxp = smatch(xpMsg, XPGAIN_GROUP_RESTED)
		end
		
		if not mob then
			mob, kxp, pxp, bonusType, gxp = smatch(xpMsg, XPGAIN_GROUP_PENALTY)
		end
	end

	-- raid penalty not always applies it seems
	if not mob then
		mob, kxp, rxp, bonusType = smatch(xpMsg, XPGAIN_SINGLE_RESTED)
	end
	
	if not mob then
		mob, kxp, pxp, bonusType = smatch(xpMsg, XPGAIN_SINGLE_PENALTY)
	end

	if not mob then
		mob, kxp = smatch(xpMsg, XPGAIN_SINGLE)
	end
	
	if mob then 
		kill = 1
		
		-- rested bonus is marked as string in the constant for some reason
		rxp = tonumber(rxp)
		-- for koKR and ruRU rxp and bonustype are exchanged
		if not rxp and bonusType then
			rxp = tonumber(bonusType)
		end
		-- penalty is marked as string in the constant for some reason
		pxp = tonumber(pxp)
		-- for koKR and ruRU pxp and bonustype are exchanged
		if not pxp and bonusType then
			pxp = tonumber(bonusType)
		end
		
		kxp  = kxp  or 0
		rxp  = rxp  or 0
		gxp  = gxp  or 0
		pxp  = pxp  or 0
		rpxp = rpxp or 0

		-- pure kill xp: subtract bonuses, add penalties 
		kxp = kxp - rxp - gxp + pxp + rpxp
	else
		kxp = 0
	end

	if kill == 0 then
		return
	end

	self.History:AddKill(kxp, gxp, rpxp)
	
	if self:GetSetting("ShowText") == "KTL" then
		self:UpdateLabel()
	end
end

function BrokerXPBar:PLAYER_LEVEL_UP(_, newLevel)
	self.playerLvl = newLevel

	if self.playerLvl == self.MAX_LEVEL then
		-- PLAYER_LEVEL_UP seems to be triggered before PLAYER_XP_UPDATE
		-- so we delay the unregister a bit
		self:ScheduleTimer("MaxLevelReached", 3)
	end
end

function BrokerXPBar:COMBAT_TEXT_UPDATE(_, msgType, factionName, amount)
    if msgType ~= "FACTION" then
		return
	end
	
	if (amount < 0 and self:GetSetting("AutoTrackOnLoss")) or 
	   (amount > 0 and self:GetSetting("AutoTrackOnGain")) then
		if factionName then
			self:SetFaction(self:GetFactionByName(factionName))
		end
	end	
end

-- faction functions
function BrokerXPBar:UpdateWatchedFactionIndex()
	-- isWatched in GetFactionInfo(factionIndex) doesnt do the trick before use of SetWatchedFactionIndex(index)
	local watchedname = GetWatchedFactionInfo()
	local currentname = GetFactionInfo(self.faction)
	local index = 0

	if currentname ~= watchedname then
		for i = 1, GetNumFactions() do
			local name, _, _, _, _, _, _, _, isHeader  = GetFactionInfo(i)			
			if name == watchedname and not isHeader then
				index = i
				break
			end
		end

		self:SetFaction(index)
	end

	return self.faction
end

function BrokerXPBar:GetFactionName(faction)
	return GetFactionInfo(faction) or L["None"]
end

-- auxillary functions
function BrokerXPBar:Output(msg)
	if ( msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME..": "..msg, 0.6, 1.0, 1.0 )
	end
end

function BrokerXPBar:Debug(msg)
	if ( self.debug and msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME .. " (dbg): " .. msg, 1.0, 0.37, 0.37 )
	end
end

function BrokerXPBar:FormatNumberLabel(number)
	return FormatNumber(number, self:GetSetting("Separators"), self:GetSetting("Abbreviations"), self:GetSetting("DecimalPlaces"))
end

function BrokerXPBar:FormatNumberTip(number)
	return FormatNumber(number, self:GetSetting("Separators"), self:GetSetting("TTAbbreviations"), self:GetSetting("DecimalPlaces"))
end

function BrokerXPBar:GetBlizzardReputationColor(standing)
	local r, g, b, a = 0, 0, 0, 0
	
	if not standing then
		standing = self.watchedStanding
	end
		
	if standing and blizzRepColors[standing] then
		r = blizzRepColors[standing].r
		g = blizzRepColors[standing].g
		b = blizzRepColors[standing].b
		a = blizzRepColors[standing].a
	end
		
	return r, g, b, a
end

function BrokerXPBar:IsBarRequired(bar)
	if bar == "XP" then
		if self:GetSetting("ShowXP") then
			return self.playerLvl < self.MAX_LEVEL or not self:GetSetting("MaxHideXPBar")
		end
	elseif bar == "Rep" then
		if self:GetSetting("ShowRep") and self.faction ~= 0 then
			return not self.atMaxRep or not self:GetSetting("MaxHideRepBar")
		end
	end
	
	return false
end

function BrokerXPBar:ShowBlizzardBars(show)
	if show then
		-- restore the blizzard frames
		MainMenuExpBar:SetScript("OnEvent", MainMenuExpBar_OnEvent)
		MainMenuExpBar:Show()
	
		ReputationWatchBar:SetScript("OnEvent", ReputationWatchBar_OnEvent)
		ReputationWatchBar:Show()

		ExhaustionTick:SetScript("OnEvent", ExhaustionTick_OnEvent)
		ExhaustionTick:Show() 
	else
		-- hide the blizzard frames
		MainMenuExpBar:SetScript("OnEvent", nil)
		MainMenuExpBar:Hide()

		ReputationWatchBar:SetScript("OnEvent", nil)
		ReputationWatchBar:Hide()

		ExhaustionTick:SetScript("OnEvent", nil)
		ExhaustionTick:Hide()
	end
end

-- user functions
function BrokerXPBar:OutputExperience()
	if self.playerLvl < self.MAX_LEVEL then
		local totalXP = UnitXPMax("player")
		local currentXP = UnitXP("player")
		local toLevelXP = totalXP - currentXP
		local xpEx = GetXPExhaustion() or 0

		local xpExPercent
		if xpEx - toLevelXP > 0 then
			xpExPercent = floor(((xpEx - toLevelXP) / totalXP) * 100)
		else
			xpExPercent = floor((xpEx / totalXP) * 100)
		end
		DEFAULT_CHAT_FRAME.editBox:SetText(string.format(L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"], 
					currentXP,
					totalXP, 
					(currentXP/totalXP)*100, 
					totalXP - currentXP, 
					xpExPercent))
	else
		self:Output(L["Maximum level reached."])
	end
					
end

function BrokerXPBar:OutputReputation()
	if self.faction ~= 0 then
		local name, desc, standing, minRep, maxRep, currentRep = GetFactionInfo(self.faction)
		DEFAULT_CHAT_FRAME.editBox:SetText(string.format(L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"],
					name,
					currentRep - minRep,
					maxRep - minRep, 
					(currentRep-minRep)/(maxRep-minRep)*100,
					getglobal("FACTION_STANDING_LABEL"..standing),
					maxRep - currentRep))
	else
		self:Output(L["Currently no faction tracked."])
	end
end

function BrokerXPBar:PrintVersionInfo()
    self:Output(L["Version"] .. " " .. NS:Colorize("White", GetAddOnMetadata(ADDON, "Version")))
end

function BrokerXPBar:UserSetBarProgress(bar, progress)
	if self.Bar.progress[bar] then
		local current = self.Bar.progress[bar]
	
		if not progress then
			self:Output("Current progress of bar " .. bar .. ": " .. tostring(current))
			
			return
		end
	
		local fraction = tonumber(progress)
		
		if not fraction then
			self:Output("No valid value given for bar progress: " .. tostring(progress))
		end
	
		self.Bar:SetBarProgress(bar, fraction)
		self.Bar:Update()
		
		self:Output("Progress of bar " .. bar .. " set to " .. tostring(self.Bar.progress[bar]) .. " (from : " .. tostring(current) .. ")")
	else
		self:Output("Unknown bar: " .. tostring(bar))
	end
end
