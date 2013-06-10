local _G = _G

-- addon name and namespace
local ADDON, NS = ...

-- local functions
local tonumber = tonumber
local gsub     = string.gsub
local smatch   = string.match
local sqrt     = math.sqrt
local floor    = math.floor

local GetNumFactions        = _G.GetNumFactions
local GetNumGroupMembers    = _G.GetNumGroupMembers
local GetNumSubgroupMembers = _G.GetNumSubgroupMembers
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetXPExhaustion       = _G.GetXPExhaustion
local IsInRaid              = _G.IsInRaid
local IsResting             = _G.IsResting
local UnitLevel             = _G.UnitLevel
local UnitXP                = _G.UnitXP
local UnitXPMax             = _G.UnitXPMax

local _

-- setup libs
local LibStub   = LibStub

-- coloring tools
local Crayon	= LibStub:GetLibrary("LibCrayon-3.0")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- constants
local ICON         = "Interface\\Addons\\"..ADDON.."\\icon.tga"
local ICON_RESTING = "Interface\\Addons\\"..ADDON.."\\iconrest.tga"

-- addon and locals
local Addon = LibStub:GetLibrary("AceAddon-3.0"):NewAddon(ADDON, "AceEvent-3.0", "AceConsole-3.0", "AceBucket-3.0", "AceTimer-3.0")

-- internal event handling
Addon.callbacks = LibStub("CallbackHandler-1.0"):New(Addon)

-- add to namespace
NS.Addon = Addon

-- addon constants
Addon.MODNAME   = "BrokerXPBar"
Addon.FULLNAME  = "Broker: XP Bar"

Addon.MAX_LEVEL = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

-- player level
Addon.playerLvl       = UnitLevel("player")

-- faction variables
Addon.faction         = 0

Addon.watchedStanding = 0
Addon.watchedFriendID = nil
Addon.atMaxRep        = false

Addon.FONT_NAME_DEFAULT = "Broker: XP Bar - Default"
Addon.FONT_DEFAULT      = "TextStatusBarText"

-- modules
local Options       = nil
local Tooltip       = nil
local MinimapButton = nil
local DataBroker    = nil

-- aux variables
local countInitial = 0

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

local updateHandler = {
	Spark              = "UpdateBarSetting",
	Thickness          = "UpdateBarSetting",
	ShowXP             = "UpdateXPBarSetting",
	ShowRep            = "UpdateRepBarSetting",
	Shadow             = "UpdateBarSetting",
	Inverse            = "UpdateBarSetting",
	ExternalTexture    = "UpdateTextureSetting",
	Texture            = "UpdateTextureSetting",
	Ticks              = "UpdateBarSetting",
	ShowBarText        = "UpdateBarTextSetting",
	BarToGo            = "UpdateBarTextSetting",
	BarShowFactionName = "UpdateBarTextSetting",
	BarShowValues      = "UpdateBarTextSetting",
	BarShowPercentage  = "UpdateBarTextSetting",
	BarShowRestedValue = "UpdateBarTextSetting",
	BarShowRestedPerc  = "UpdateBarTextSetting",
	BarAbbreviations   = "UpdateBarTextSetting",
	MouseOver          = "UpdateBarSetting",
	Font               = "UpdateBarSetting",
	FontSize           = "UpdateBarSetting",
	Frame              = "UpdateBarSetting",
	Location           = "UpdateBarSetting",
	xOffset            = "UpdateBarSetting",
	yOffset            = "UpdateBarSetting",
	Strata             = "UpdateBarSetting",
	Inside             = "UpdateBarSetting",
	Jostle             = "UpdateBarSetting",
	BlizzRep           = "UpdateRepColorSetting",
	ShowText           = "UpdateShowTextSetting",
	ToGo               = "UpdateLabelSetting",
	ShowFactionName    = "UpdateLabelSetting",
	ShowValues         = "UpdateLabelSetting",
	ShowPercentage     = "UpdateLabelSetting",
	ShowRestedValue    = "UpdateLabelSetting",
	ShowRestedPerc     = "UpdateLabelSetting",
	ColoredText        = "UpdateLabelSetting",
	Separators         = "UpdateLabelSetting",
	Abbreviations      = "UpdateLabelSetting",
	DecimalPlaces      = "UpdateLabelSetting",
	AutoTrackOnGain    = "UpdateAutoTrackSetting",
	AutoTrackOnLoss    = "UpdateAutoTrackSetting",
	XP                 = "UpdateColorSetting",
	Rest               = "UpdateColorSetting",
	None               = "UpdateColorSetting",
	Rep                = "UpdateColorSetting",
	NoRep              = "UpdateColorSetting",
	TimeFrame          = "UpdateHistorySetting",
	Weight             = "UpdateHistorySetting",
	MaxHideXPText      = "UpdateLabelSetting",
	MaxHideXPBar       = "UpdateXPBarSetting",
	MaxHideRepText     = "UpdateLabelSetting",
	MaxHideRepBar      = "UpdateRepBarSetting",
	ShowBlizzBars      = "UpdateBlizzardBarsSetting",
	Minimap            = "UpdateMinimapSetting",
}

-- infrastructure
function Addon:OnInitialize()
	-- set module references
	Options       = self:GetModule("Options")
	Tooltip       = self:GetModule("Tooltip")
	MinimapButton = self:GetModule("MinimapButton")
	DataBroker    = self:GetModule("DataBroker")

	-- debug
	self.debug = false

    self:RegisterChatCommand("brokerxpbar", "ChatCommand")
	self:RegisterChatCommand("bxp",         "ChatCommand")
	
	self.Bar:Initialize()
end

function Addon:OnEnable()
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
	
	self:SetupEventHandlers()
	
	self:RegisterAutoTrack()
	self:RegisterTTL()	
	
	self:UpdateIcon()	

	-- if we don't want to show the bars we hide them else we leave them as they are
	if not self:GetSetting("ShowBlizzBars") then
		self:ShowBlizzardBars(false)
	end
	
	self:RefreshBarSettings()
	self:InitialAnchoring()
	
	MinimapButton:SetShow(Options:GetSetting("Minimap"))

	self:Update()
end

function Addon:OnDisable()
	self.Bar:Hide()

	MinimapButton:SetShow(false)
	
	-- if we hid the bars ourselves we restore them else we leave them as they are
	if not self:GetSetting("ShowBlizzBars") then
		self:ShowBlizzardBars(true)
	end
	
	self:ResetEventHandlers()

	self:RegisterAutoTrack(false)
	self:RegisterTTL(false)	
end

function Addon:OnOptionsReloaded()
	MinimapButton:SetShow(Options:GetSetting("Minimap"))
	self:ShowBlizzardBars(self:GetSetting("ShowBlizzBars")) 

	self.History:SetTimeFrame(self:GetSetting("TimeFrame") * 60)
	self.History:SetWeight(self:GetSetting("Weight"))
	
	self.ReputationHistory:SetTimeFrame(self:GetSetting("TimeFrame") * 60)
	self.ReputationHistory:SetWeight(self:GetSetting("Weight"))
	
	self.History:Process()
	self.ReputationHistory:ProcessFaction(self.faction)
	
	self:RegisterAutoTrack()
	self:RegisterTTL()		

	self:RefreshBarSettings()
	
	self:Update()	
end

function Addon:ChatCommand(input)
    if input then  
		args = NS:GetArgs(input)
		
		self:TriggerAction(args[1] and string.lower(args[1]) or nil, args)
	else
		self:TriggerAction("help")
	end
end

function Addon:OnClick(button)
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

function Addon:TriggerAction(action, args)
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

function Addon:CreateTooltip(obj)
	Tooltip:Create(obj)
end

function Addon:RemoveTooltip()
	Tooltip:Remove()
end

function Addon:SetupEventHandlers()
	Options.RegisterCallback(self, ADDON .. "_SETTING_CHANGED", "UpdateSetting")	

	self:RegisterBucketEvent("UPDATE_EXHAUSTION", 60, "Update")
	
    self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateIcon")
	self:RegisterEvent("UPDATE_FACTION", "UpdateStanding")
	
	if self.playerLvl < self.MAX_LEVEL then
		self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:RegisterEvent("PLAYER_XP_UPDATE")
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end
end

function Addon:ResetEventHandlers()
	Options.UnregisterCallback(self, ADDON .. "_SETTING_CHANGED")	

	self:UnregisterAllBuckets()
	
	self:UnregisterEvent("PLAYER_UPDATE_RESTING")
	self:UnregisterEvent("UPDATE_FACTION")
	
	if self.playerLvl < self.MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
	end
end

function Addon:RegisterAutoTrack(register)
	if register == nil then
		register = self:GetSetting("AutoTrackOnGain") or self:GetSetting("AutoTrackOnLoss")
	end
	
	if register then
		self:RegisterEvent("COMBAT_TEXT_UPDATE")
	else
		self:UnregisterEvent("COMBAT_TEXT_UPDATE")
	end
end

function Addon:RegisterTTL(register)
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

function Addon:RefreshBarSettings()
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
		local r, g, b, a = Options:GetColor(id)
		
		if id == "Rep" and self:GetSetting("BlizzRep") then
			r, g, b, a = self:GetBlizzardReputationColor()
		end
		
		self.Bar:SetColor(id, r, g, b, a)
	end
	
	self.Bar:Reanchor()
end

function Addon:InitialAnchoring()
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
function Addon:Update()
	self:UpdateBar()
	self:UpdateLabel()
end

function Addon:UpdateBar()
	if self:GetSetting("ShowXP") then
		local currentXP = UnitXP("player")
		local maxXP     = UnitXPMax("player")
		local restXP    = GetXPExhaustion() or 0
		
		if maxXP == 0 then
			return
		end
		
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
			text = self:GetInfoText("XP", "Bar")
		end
		
		self.Bar:SetText("XP", text)		
	end

	if self:GetSetting("ShowRep") then
		local reputation = 0
		local text = ""
		
		if self.faction ~= 0 then
			local name, standing, minRep, maxRep, currentRep = nil, 0, 0, 0, 0
			
			name, _, standing, minRep, maxRep, currentRep = NS:GetFactionInfo(self.faction)
			
			if maxRep == minRep then
				return
			end
			
			reputation = (currentRep - minRep) / (maxRep - minRep)
			
			if self:GetSetting("ShowBarText") then
				text = self:GetInfoText("Rep", "Bar")
			end
		end

		local oldValue = self.Bar.progress.Reputation
		
		self.Bar:SetBarProgress("Reputation", reputation)
		self:Debug("UpdateBar: Progress for bar Reputation set to " .. tostring(self.Bar.progress.Reputation) .. " (from " .. oldValue .. ")")		
		
		self.Bar:SetText("Reputation", text)
	end
		
	self.Bar:Update()
end

function Addon:UpdateLabel()
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
				DataBroker:SetText("")
			else
				DataBroker:SetText(L["Max Level"])
			end
			return
		end
	end
	
	if show == "Rep" and self.atMaxRep and self:GetSetting("MaxHideRepText") then
		DataBroker:SetText("")
		return
	end

    if show == "Rep" or show == "XP"  then		
		DataBroker:SetText(self:GetInfoText(show))
    elseif show == "TTL" then		
		self.History:Process()
			
		DataBroker:SetText(L["TTL"] .. ": " .. self.History:GetTimeToLevel())
    elseif show == "KTL" then
		self.History:Process()
			
		DataBroker:SetText(L["KTL"] .. ": " .. NS:Colorize("Red", self.History:GetKillsToLevel()))
    elseif show == "TTLRep" then		
		self.ReputationHistory:ProcessFaction(self.faction)
			
		DataBroker:SetText(L["TTLRep"] .. ": " .. self.ReputationHistory:GetTimeToLevel(self.faction))
    else
        DataBroker:SetText(self.FULLNAME)
    end
end

function Addon:UpdateIcon()
	local icon = self:GetIcon()
	
	DataBroker:SetIcon(icon)
	MinimapButton:SetIcon(icon)
end

function Addon:UpdateStanding()
	local standing = 0
	local friendID = nil
	
	-- check for changes in watched faction
	self:UpdateWatchedFactionIndex()
	
	if self.faction ~= 0 then
		local minRep, maxRep, currentRep = 0, 0, 0
		_, _, standing, minRep, maxRep, currentRep, _, _, _, _, _, _, _, _, friendID, atMax = NS:GetFactionInfo(self.faction)
		
		if not self.atMaxRep and atMax then
			self:MaxReputationReached()
		end
	end
	
	local recolor = false
	
	if friendID ~= self.watchedFriendID then
		self.watchedFriendID = friendID
		
		recolor = true
	end
	
	if standing ~= self.watchedStanding then
		self.watchedStanding = standing

		recolor = true		
	end
	
	if recolor then
		if self:GetSetting("BlizzRep") then
			local r, g, b, a = self:GetBlizzardReputationColor(standing, friendID)

			self.Bar:SetColor("Rep", r, g, b, a)
		end
	end

	self.ReputationHistory:Update()
	
	self:Update()
end

-- settings
function Addon:UpdateSetting(event, setting, value, old)
	local handler = updateHandler[setting]

	if handler == "UpdateBarSetting" then
		self.Bar:SetSetting(setting, value)
	elseif handler == "UpdateXPBarSetting" then
		self.Bar:SetSetting("ShowXP", self:IsBarRequired("XP"))
		
		self:UpdateBar()
	elseif handler == "UpdateRepBarSetting" then
		self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))

		self:UpdateBar()
	elseif handler == "UpdateTextureSetting" then
		self.Bar:SetSetting("Texture", Options:GetSetting("ExternalTexture") and Options:GetSetting("Texture") or nil)
	elseif handler == "UpdateBarTextSetting" then
		self:UpdateBar()
	elseif handler == "UpdateRepColorSetting" then
		local r, g, b, a = Options:GetColor("Rep")

		if Options:GetSetting("BlizzRep") then
			r, g, b, a = self:GetBlizzardReputationColor()
		end

		self.Bar:SetColor("Rep", r, g, b, a)
	elseif handler == "UpdateLabelSetting" then
		self:UpdateLabel()
	elseif handler == "UpdateShowTextSetting" then
		self:RegisterTTL()
		
		self:UpdateLabel()
	elseif handler == "UpdateHistorySetting" then
		if setting == "TimeFrame" then
			self.History:SetTimeFrame(value * 60)
			self.ReputationHistory:SetTimeFrame(value * 60)
		elseif setting == "Weight" then
			self.History:SetWeight(value)
			self.ReputationHistory:SetWeight(value)
		end

		self.History:Process()
		self.ReputationHistory:Process()
	elseif handler == "UpdateAutoTrackSetting" then
		self:RegisterAutoTrack()
	elseif handler == "UpdateColorSetting" then
		if setting == "Rep" and self:GetSetting("BlizzRep") then
			return
		end
		
		self.Bar:SetColor(setting, value.r, value.g, value.b, value.a)	
	elseif handler == "UpdateBlizzardBarsSetting" then
		self:ShowBlizzardBars(value) 
	elseif handler == "UpdateMinimapSetting" then
		MinimapButton:SetShow(value)
	end
end

function Addon:GetSetting(setting)
	return Options:GetSetting(setting)
end

function Addon:GetFaction()
	return self.faction
end

function Addon:SetFaction(index)
	if not index or self.faction == index then
		return
	end
	
	self.faction  = index
	self.atMaxRep = false
	
	SetWatchedFactionIndex(index)
	
	if self.faction == 0 then
		self.watchedStanding = 0
	end

	Options:Update()
	
	self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))
end

-- utilities
function Addon:GetIcon()
	if IsResting() then
		return ICON_RESTING
	else
		return ICON
	end
end

function Addon:MaxLevelReached()
	if self.playerLvl == self.MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
		
		self.Bar:SetSetting("ShowXP", self:IsBarRequired("XP"))
	end
end

function Addon:MaxReputationReached()
	if not self.atMaxRep then
		self.atMaxRep = true
		
		self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))
	end
end

function Addon:GetInfoText(source, prefix)
	if source ~= "XP" and source ~= "Rep" then
		return ""
	end
	
	if not prefix then
		prefix = ""
	end
	
	if type(prefix) ~= "string" then
		return ""
	end

	local current, min, max = 0, 0, 100
	local name
	local label, values, percentage  = "", "", ""
	
	if source == "XP" then
		current, max = UnitXP("player"), UnitXPMax("player")
	else
		if self.faction == 0 then
			return L["No watched faction"]
		end
		
		name, _, _, min, max, current = NS:GetFactionInfo(self.faction)
					
		current = current - min
		max     = max - min
		
		if self:GetSetting(prefix .. "ShowFactionName") then
			label  = name ..": "
		end
	end
	
	if self:GetSetting(prefix .. "ToGo") then
		local toGo = max - current
		
		values     = self:FormatNumber(toGo, prefix)
		percentage = floor((toGo / max * 100) + 0.5)
			
		if self:GetSetting(prefix .. "ColoredText") then
			values, percentage = NS:ColorizeByValue(toGo, max, 0, values, percentage)
		end			
	else 
		values     = self:FormatNumber(current, prefix)
		percentage = floor(current/max * 100)
		
		if Crayon and self:GetSetting(prefix .. "ColoredText") then
			values, percentage = NS:ColorizeByValue(current, 0, max, values, percentage)
		end
		
		values = values .. "/" .. self:FormatNumber(max, prefix)
	end
	
	if self:GetSetting(prefix .. "ShowValues") then
		label = label .. values
	end
		
	if self:GetSetting(prefix .. "ShowPercentage") then
		if label == "" then
			label = percentage .. "%"
		else
			label = label .. " (" .. percentage .. "%)"
		end
	end
	
	if source == "XP" then
		local showRestValue = self:GetSetting(prefix .. "ShowRestedValue")
		local showRestPerc  = self:GetSetting(prefix .. "ShowRestedPerc")
		
		local exhaustion = GetXPExhaustion()
		
		if exhaustion and (showRestValue or showRestPerc) then
			if label ~= "" then
				label = label .. " - "
			end
			
			label = label .. L["R:"]
			
			values = self:FormatNumber(exhaustion, prefix)
			percentage = floor(((exhaustion / max) * 100) + 0.5)
			
			if self:GetSetting(prefix .. "ColoredText") then
				values, percentage = NS:ColorizeByValue(percentage, 0, 150, values, percentage)
			end
			
			if showRestValue then
				label = label .. " " .. values
			end
			
			if showRestPerc then
				if showRestValue then
					percentage = " (" .. percentage .. "%)"
				else
					percentage = percentage .. "%"
				end
				
				label = label .. " " .. percentage
			end
		end
	end

	return label
end

-- events
function Addon:PLAYER_XP_UPDATE()
	self.History:UpdateXP()

	self:Update()
end

function Addon:CHAT_MSG_COMBAT_XP_GAIN(_, xpMsg)
	-- kill, rested, group, penalty, raid penalty
	local kxp, rxp, gxp, pxp, rpxp
	local bonusType
	local kill = 0
	local mob
	
	if GetNumGroupMembers() > 0 then
		if IsInRaid() then		
			mob, kxp, rpxp = smatch(xpMsg, XPGAIN_RAID)
			
			if not mob then
				mob, kxp, rxp, bonusType, rpxp = smatch(xpMsg, XPGAIN_RAID_RESTED)
			end
			
			if not mob then
				mob, kxp, pxp, bonusType, rpxp = smatch(xpMsg, XPGAIN_RAID_PENALTY)
			end
		else
			mob, kxp, gxp = smatch(xpMsg, XPGAIN_GROUP)
			
			if not mob then
				mob, kxp, rxp, bonusType, gxp = smatch(xpMsg, XPGAIN_GROUP_RESTED)
			end
			
			if not mob then
				mob, kxp, pxp, bonusType, gxp = smatch(xpMsg, XPGAIN_GROUP_PENALTY)
			end
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

function Addon:PLAYER_LEVEL_UP(_, newLevel)
	self.playerLvl = newLevel

	if self.playerLvl == self.MAX_LEVEL then
		-- PLAYER_LEVEL_UP seems to be triggered before PLAYER_XP_UPDATE
		-- so we delay the unregister a bit
		self:ScheduleTimer("MaxLevelReached", 3)
	end
end

function Addon:COMBAT_TEXT_UPDATE(_, msgType, factionName, amount)
    if msgType ~= "FACTION" then
		return
	end
	
	if (amount < 0 and self:GetSetting("AutoTrackOnLoss")) or 
	   (amount > 0 and self:GetSetting("AutoTrackOnGain")) then
		if factionName then
			self:SetFaction(Options:GetFactionByName(factionName))
		end
	end	
end

-- faction functions
function Addon:UpdateWatchedFactionIndex()
	-- isWatched in GetFactionInfo(factionIndex) doesnt do the trick before use of SetWatchedFactionIndex(index)
	local watchedname = GetWatchedFactionInfo()
	local currentname = NS:GetFactionInfo(self.faction)
	local index = 0

	if currentname ~= watchedname then
		for i = 1, GetNumFactions() do
			local name, _, _, _, _, _, _, _, isHeader, _, hasRep = NS:GetFactionInfo(i)			
			if name == watchedname and (not isHeader or hasRep) then
				index = i
				break
			end
		end

		self:SetFaction(index)
	end

	return self.faction
end

function Addon:GetFactionName(faction)
	return NS:GetFactionInfo(faction) or L["None"]
end

-- auxillary functions
function Addon:Output(msg)
	if ( msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME..": "..msg, 0.6, 1.0, 1.0 )
	end
end

function Addon:Debug(msg)
	if ( self.debug and msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME .. " (dbg): " .. msg, 1.0, 0.37, 0.37 )
	end
end

function Addon:FormatNumber(number, prefix)
	if not prefix then
		prefix = ""
	end
	
	if type(prefix) ~= "string" then
		return number
	end
	
	return NS:FormatNumber(number, self:GetSetting("Separators"), self:GetSetting(prefix .. "Abbreviations"), self:GetSetting("DecimalPlaces"))
end

function Addon:GetBlizzardReputationColor(standing, friendship)
	if not standing then
		standing   = self.watchedStanding
		freindship = self.watchedFriendID 
	end
		
	return NS:GetBlizzardReputationColor(standing, friendship)
end

function Addon:IsBarRequired(bar)
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

function Addon:ShowBlizzardBars(show)
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
function Addon:OutputExperience()
	if self.playerLvl < self.MAX_LEVEL then
		local totalXP = UnitXPMax("player")
		local currentXP = UnitXP("player")
		local toLevelXP = totalXP - currentXP
		local xpEx = GetXPExhaustion() or 0

		local xpExPercent = floor(((xpEx / totalXP) * 100) + 0.5)

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

function Addon:OutputReputation()
	if self.faction ~= 0 then
		local name, desc, standing, minRep, maxRep, currentRep, _, _, _, _, _, _, _, _, friendID = NS:GetFactionInfo(self.faction)
		DEFAULT_CHAT_FRAME.editBox:SetText(string.format(L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"],
					name,
					currentRep - minRep,
					maxRep - minRep, 
					(currentRep-minRep)/(maxRep-minRep)*100,
					NS:GetStandingLabel(standing, friendID),
					maxRep - currentRep))
	else
		self:Output(L["Currently no faction tracked."])
	end
end

function Addon:PrintVersionInfo()
    self:Output(L["Version"] .. " " .. NS:Colorize("White", GetAddOnMetadata(ADDON, "Version")))
end

function Addon:UserSetBarProgress(bar, progress)
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
