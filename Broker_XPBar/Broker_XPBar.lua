local _G = getfenv(0)

-- addon constants
local MODNAME   = "BrokerXPBar"
local FULLNAME  = "Broker: XP Bar"
local DIRNAME   = "Broker_XPBar"

-- local functions
local tinsert, tremove, tgetn = table.insert, table.remove, table.getn
local tonumber, time, gsub, smatch =  tonumber, time, string.gsub, string.match
local sqrt, floor, ceil = math.sqrt, math.floor, math.ceil

-- setup libs
local LibStub   = LibStub
local LDB       = LibStub:GetLibrary("LibDataBroker-1.1")

-- rearrangement of blizzard's frames
local Jostle	= LibStub:GetLibrary("LibJostle-3.0", true)
-- coloring tools
local Crayon	= LibStub:GetLibrary("LibCrayon-3.0")
-- tooltip library
local QT		= LibStub:GetLibrary("LibQTip-1.0")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale( MODNAME )

-- config libraries
local AceConfig 		= LibStub:GetLibrary("AceConfig-3.0")
local AceConfigReg 		= LibStub:GetLibrary("AceConfigRegistry-3.0")
local AceConfigDialog	= LibStub:GetLibrary("AceConfigDialog-3.0")

-- utilities
local function Debug( msg )
	if ( debug and msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( MODNAME .. " (dbg): " .. msg, 0.6, 1.0, 1.0 )
	end
end
local function Output( msg )
	if ( msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( MODNAME..": "..msg, 0.6, 1.0, 1.0 )
	end
end

local function Red( text )      return "|cffff0000" .. text .. "|r" end
local function Yellow( text )   return "|cffffff00" .. text .. "|r" end
local function White( text )    return "|cffffffff" .. text .. "|r" end
local function Brownish( text ) return "|cffeda55f" .. text .. "|r" end

local function GetArgs(str, pattern)
   local ret = {}
   local pos=0
   
   while true do
     local word
     _, pos, word=string.find(str, pattern, pos+1)
	 
     if not word then
       break
     end
	 
     word = string.lower(word)
     table.insert(ret, word)
   end
   
   return ret
end

local function format_time(stamp)
	local days    = floor(stamp/86400)
	local hours   = floor((stamp - days * 86400) / 3600)
	local minutes = floor((stamp - days * 86400 - hours * 3600) / 60)

	if days > 0 then
		return string.format("%dd %02d:%02d", days, hours, minutes)
	else
		return string.format("%02d:%02d", hours, minutes)
	end
end

local abbreviations = {
		[0]  = "", 
		[1]  = L["k"], 
		[2]  = L["m"], 
		[3]  = L["bn"], 
}
	
local function format_number(number, sep, abbrev, decimals)
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

-- addon and locals
BrokerXPBar = LibStub:GetLibrary("AceAddon-3.0"):NewAddon(MODNAME, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0")

local tooltip

local function CreateTooltip( self )
	tooltip = QT:Acquire( MODNAME.."TT", 2 )
	tooltip:Hide()
	tooltip:Clear()
	tooltip:SetScale(1)
		
	BrokerXPBar:DrawTooltip()

	tooltip:SmartAnchorTo( self )
	tooltip:Show()
end

local function RemoveTooltip()
	if tooltip then
		tooltip:Hide()
		QT:Release(tooltip)
		tooltip = nil
	end
end

local dataobj  = LDB:NewDataObject(MODNAME, {
	type	= "data source",
	icon	= "Interface\\Addons\\"..DIRNAME.."\\icon.tga",
	label	= MODNAME,
	text	= "Updating...",
	OnClick = function(clickedframe, button) 
		BrokerXPBar:OnClick(button) 
	end,
	OnEnter = function ( self )
		CreateTooltip(self)
	end,
	OnLeave = function()
		RemoveTooltip()
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

	local mm_button = CreateFrame("Button", MODNAME .. "_MinimapButton", Minimap)
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
	icon:SetTexture("Interface\\Addons\\"..DIRNAME.."\\icon.tga")
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
		CreateTooltip(self)
	end)
	
	mm_button:SetScript("OnLeave", function(self)
		RemoveTooltip()
	end)

	mm_button:Hide()

	function BrokerXPBar:ShowMinimapButton(show)
		if show then
			mm_button:Show()
		else
			mm_button:Hide()
		end
	end
end

-- layout variables
local countinitial = 0

local barframe   = nil
local horizontal = true

-- faction variables
local faction          = 0
local watchedstanding  = 0
local atmaxrep         = false

local lookupFactions   = {}
local lookupIndexes    = {}
local lookupNames      = {}

local blizz_rep_colors = {
	[1] = {r=0.80, g=0.13, b=0.13, a=1}, -- hated
	[2] = {r=1.00, g=0.25, b=0.00, a=1}, -- hostile
	[3] = {r=0.93, g=0.40, b=0.13, a=1}, -- unfriendly
	[4] = {r=1.00, g=1.00, b=0.00, a=1}, -- neutral
	[5] = {r=0.00, g=0.70, b=0.00, a=1}, -- friendly
	[6] = {r=0.00, g=1.00, b=0.00, a=1}, -- honoured
	[7] = {r=0.00, g=0.60, b=1.00, a=1}, -- revered
	[8] = {r=0.00, g=1.00, b=1.00, a=1}, -- exalted
}

-- xp rate variables
local MAX_HISTORY   = 12
local MAX_LEVEL     = MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()]
local playerlvl     = UnitLevel("player")
local totalkills    = 0
local totalxp       = 0
local activitykills = 0
local activityxp    = 0
local xpperkill     = 0
local grp_xpperkill = 0
local raid_penaltyperkill = 0
local starttime     = nil
local endresttime   = nil
local startxp       = 0
local lvlmaxxp      = 0
local donelvlxp     = 0
local activebucket  = floor(time() / 60) - 1
local tainted_xp    = true
local tainted_mobs  = false
local history_xp    = {}
local history_mobs  = {}

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

-- options
local strata = { 
	BACKGROUND        = "BACKGROUND", 
	LOW               = "LOW", 
	MEDIUM            = "MEDIUM", 
	HIGH              = "HIGH", 
	DIALOG            = "DIALOG", 
	FULLSCREEN        = "FULLSCREEN", 
	FULLSCREEN_DIALOG = "FULLSCREEN_DIALOG", 
	TOOLTIP           = "TOOLTIP" 
}

-- bookkeeping for show text
-- (needed to achieve ordered combobox, named option value and translated display value)
local showtext = {
	val2txt = {
		None     = L["None"], 
		KTL      = L["Kills to Level"],
		TTL      = L["Time to Level"], 
		Rep      = L["Rep"], 
		XP       = L["XP"], 
		RepFirst = L["Rep over XP"], 
		XPFirst  = L["XP over Rep"], 
	},
	opt2txt = {
		[1]  = L["None"], 
		[2]  = L["Kills to Level"],
		[3]  = L["Time to Level"], 
		[4]  = L["Rep"], 
		[5]  = L["XP"], 
		[6]  = L["Rep over XP"], 
		[7]  = L["XP over Rep"], 
	},
	opt2val = {
		[1]  = "None", 
		[2]  = "KTL",
		[3]  = "TTL", 
		[4]  = "Rep", 
		[5]  = "XP", 
		[6]  = "RepFirst", 
		[7]  = "XPFirst", 
	},
	val2opt = {
		None     = 1, 
		KTL      = 2,
		TTL      = 3, 
		Rep      = 4, 
		XP       = 5, 
		RepFirst = 6, 
		XPFirst  = 7, 
	}
}

local options  = {}
local defaults = {
	profile = {
		ShowText        = "XP",
		ShowXP          = true,
		ShowRep         = false,
		Shadow          = true,
		Thickness       = 2,
		Spark           = 1,
		Inverse         = false,
		ToGo            = true,
		ShowValues      = true,
		ShowPercentage  = true,
		ShowFactionName = true,
		ColoredText     = true,
		Separators		= false,
		Abbreviations	= false,
		TTAbbreviations	= false,
		DecimalPlaces	= 2,
		ShowBlizzBars   = false,
		HideHint        = false,
		Location        = "Bottom",
		xOffset         = 0,
		yOffset         = 0,
		Inside          = false,
		Strata          = "HIGH",
		Jostle          = false,
		BlizzRep        = true,
        Minimap	        = false,
        MaxHideXPText   = false,
        MaxHideXPBar    = false,
        MaxHideRepText  = false,
        MaxHideRepBar   = false,
        AutoTrackOnGain = false,
        AutoTrackOnLoss = false,
		XP              = {r=0.0, g=0.4, b=0.9, a=1},
		Rest            = {r=1.0, g=0.2, b=1.0, a=1},
		None            = {r=0.0, g=0.0, b=0.0, a=1},
		Rep             = {r=1.0, g=0.2, b=1.0, a=1},
		NoRep           = {r=0.0, g=0.0, b=0.0, a=1},
		Weight          = 0.8,
		TimeFrame       = 30
	}
}

-- frame selector
local mousehook     = CreateFrame("Frame")
mousehook.tooltip   = _G.GameTooltip
mousehook.setCursor = _G.SetCursor

function mousehook:OnUpdate(elap)
    if IsMouseButtonDown("RightButton") then
        return self:Stop()
    end

    local frame = GetMouseFocus()
    local name = frame and frame:GetName() or tostring(frame)
    
    SetCursor("CAST_CURSOR")
    if not frame then return end
    self.tooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT")
    self.tooltip:SetText(name, 1.0, 0.82, 0)
    self.tooltip:Show()
    
    if IsMouseButtonDown("LeftButton") then
        self:Stop()
        if not type(frame.GetName) == 'function' or not frame:GetName() then
            Output(L["This frame has no global name and cannot be used"])
        else
        	BrokerXPBar.db.profile.Frame = name
        	AceConfigReg:NotifyChange(FULLNAME)
        	BrokerXPBar:Reanchor()
        end
    end
end

function mousehook:Start()
    self:SetScript("OnUpdate", self.OnUpdate)
end

function mousehook:Stop()
	ResetCursor()
    self.tooltip:Hide()
    self:SetScript("OnUpdate", nil)
end

hooksecurefunc(_G.GameMenuFrame, "Show", function() mousehook:Stop() end)

-- infrastructure
function BrokerXPBar:SetupOptions()	
	options = {
		type = 'group',
		args = {
			bars = {
				type = 'group',
				name = L["Bar Properties"],
				desc = L["Set the Bar Properties"],
				args = {
					spark = {
						type = 'range',
						name = L["Spark intensity"],
						desc = L["Brightness level of Spark"],
						get = function() return self.db.profile.Spark end,
						set = function(info, v) 
							self.db.profile.Spark = v
							self.Spark:SetAlpha(v)
							self.Spark2:SetAlpha(v)
							self.RepSpark:SetAlpha(v)
							self.RepSpark2:SetAlpha(v)
						end,
						min = 0,
						max = 1,
						step = 0.01,
						bigStep = 0.05,
						order = 1
					},
					thickness = {
						type = 'range',
						name = L["Thickness"],
						desc = L["Set thickness of the Bars"],
						get = function() return self.db.profile.Thickness end,
						set = function(info, v)
							self:SetThickness(v)
						end,
						min = 1.5,
						max = 8,
						step = 0.1,
						order = 2
					},
					showxp = {
						type = 'toggle',
						name = L["Show XP Bar"],
						desc = L["Show the XP Bar"],
						get = function() return self.db.profile.ShowXP end,
						set = function()
							self.db.profile.ShowXP = not self.db.profile.ShowXP
							self:Reanchor()
						end,
						order = 3
					},
					showrep = {
						type = 'toggle',
						name = L["Show Rep Bar"],
						desc = L["Show the Reputation Bar"],
						get = function() return self.db.profile.ShowRep end,
						set = function()
							self.db.profile.ShowRep = not self.db.profile.ShowRep
							self:Reanchor()
						end,
						order = 4
					},
					shadow = {
						type = 'toggle',
						name = L["Shadow"],
						desc = L["Toggle Shadow"],
						get = function() return self.db.profile.Shadow end,
						set = function()
							self.db.profile.Shadow = not self.db.profile.Shadow
							self:Reanchor()
						end,
						order = 5
					},
					inverse = {
						type = 'toggle',
						name = L["Inverse Order"],
						desc = L["Place reputation bar before XP bar"],
						get = function() return self.db.profile.Inverse end,
						set = function()
							self.db.profile.Inverse = not self.db.profile.Inverse
							self:Reanchor()
						end,
						order = 6,
					},
				},
			},
			frame = {
				type = 'group',
				name = L["Frame"],
				desc = L["Frame Connection Properties"],
				args = {
					attached = {
						type = "input",
						name = L["Frame to attach to"],
						desc = L["The exact name of the frame to attach to"],
						get = function()
								return self.db.profile.Frame
							end,
						set = function(info, key)
							self.db.profile.Frame = key
							self:Reanchor()
						end,
						order = 1,
					},
					attach = {
						type = "execute",
						name = L["Select by Mouse"],
						desc = L["Click to activate the frame selector (Left-Click to select frame, Right-Click do deactivate selector)"],
						func = function() mousehook:Start() end,
						order = 2,
					},
					location = {
						type = "select", 
						name = L["Attach to side"],
						desc = L["Select side to attach the bars to"],
						get = function()
								return self.db.profile.Location
							end,
						set = function(info, key)
							self.db.profile.Location = key
							self:Reanchor()
						end,
						values = { Top = L["Top"], Bottom = L["Bottom"], Left = L["Left"], Right = L["Right"] },
						order = 3,
					},
					xoffset = {
						type = 'range',
						name = L["X-Offset"],
						desc = L["Set x-Offset of the bars"],
						get = function() return self.db.profile.xOffset end,
						set = function(info, v)
							self.db.profile.xOffset = v
							self:Reanchor()
						end,
						min = -250,
						max =  250,
						step = 1,
						order = 4
					},
					yoffset = {
						type = 'range',
						name = L["Y-Offset"],
						desc = L["Set y-Offset of the bars"],
						get = function() return self.db.profile.yOffset end,
						set = function(info, v)
							self.db.profile.yOffset = v
							self:Reanchor()
						end,
						min = -250,
						max =  250,
						step = 1,
						order = 5
					},
					strata = {
						type = "select", 
						name = L["Strata"],
						desc = L["Select the strata of the bars"],
						get = function() return self.db.profile.Strata end,
						set = function(info, key)
							self.db.profile.Strata = key
							self.MainFrame:SetFrameStrata(key)
							self.XPBar:SetFrameStrata(key)
							self.RepBar:SetFrameStrata(key)
							self.Border:SetFrameStrata(key)
						end,
						values = strata,
						order = 6,
					},
					inside = {
						type = 'toggle',
						name = L["Inside"],
						desc = L["Attach bars to the inside of the frame"],
						get = function() return self.db.profile.Inside end,
						set = function()
							self.db.profile.Inside = not self.db.profile.Inside
							self:Reanchor()
						end,
						order = 7,
					},
					jostle = {
						type = 'toggle',
						name = L["Jostle"],
						desc = L["Jostle Blizzard Frames"],
						get = function() return self.db.profile.Jostle end,
						set = function()
							self.db.profile.Jostle = not self.db.profile.Jostle
							self:Reanchor()
						end,
						order = 8,
					},
					refresh = {
						type = 'execute',
						name = L["Refresh"],
						desc = L["Refresh Bar Position"],
						func = function() self:Reanchor() end,
						order = 9,
					},
				},
			},
			colors = {
				type = 'group',
				name = L["Colors"],
				desc = L["Set the Bar Colors"],
				args = {
					currentXP = {
						type = "color",
						name = L["Current XP"],
						desc = L["Set the color of the XP Bar"],
						hasAlpha = true,
						get = function ()
							return self:GetColor("XP")
						end,
						set = function (info, r, g, b, a)
							self:SetColor("XP", r, g, b, a, self.XPBarTex, self.Spark)
						end,
						order = 1,
					},
					restedXP = {
						type = 'color',
						name = L["Rested XP"],
						desc = L["Set the color of the Rested Bar"],
						hasAlpha = true,
						get = function ()
							return self:GetColor("Rest")
						end,
						set = function (info, r, g, b, a)
							self:SetColor("Rest", r, g, b, a, self.RestedXPTex)
						end,
						order = 2,
					},
					noxp = {
						type = 'color',
						name = L["No XP"],
						desc = L["Set the empty color of the XP Bar"],
						hasAlpha = true,
						get = function ()
							return self:GetColor("None")
						end,
						set = function (info, r, g, b, a)
							self:SetColor("None", r, g, b, a, self.NoXPTex)
						end,
						order = 3,
					},
					rep = {
						type = 'color',
						name = L["Reputation"],
						desc = L["Set the color of the Rep Bar"],
						hasAlpha = true,
						get = function ()
							return self:GetColor("Rep")
						end,
						set = function (info, r, g, b, a)
							self:SetColor("Rep", r, g, b, a)
							self:UpdateReputationColor()
						end,
						order = 4,
					},
					norep = {
						type = 'color',
						name = L["No Rep"],
						desc = L["Set the empty color of the Reputation Bar"],
						hasAlpha = true,
						get = function ()
							return self:GetColor("NoRep")
						end,
						set = function (info, r, g, b, a)
							self:SetColor("NoRep", r, g, b, a, self.NoRepTex)
						end,
						order = 5,
					},
					blizzrep = {
						type = 'toggle',
						name = L["Blizzard Rep Colors"],
						desc = L["Toggle Blizzard Reputation Colors"],
						get = function() return self.db.profile.BlizzRep end,
						set = function()
							self.db.profile.BlizzRep = not self.db.profile.BlizzRep
							self:UpdateReputationColor()
						end,
						order = 6
					},
				},
			},
			label = {
				type = 'group',
				name = L["Broker Label"],
				desc = L["Broker Label Properties"],
				args = {
					showtext = {
						type = "select", 
						name = L["Select Label Text"],
						desc = L["Select label text for Broker display"],
						get  = function() 
							return showtext.val2opt[self.db.profile.ShowText]
						end,
						set  = function(info, key)
							self:SetShowText(key)
						end,
						values = showtext.opt2txt,
						order = 1
					},
					togo = {
						type = 'toggle',
						name = L["XP/Rep to go"],
						desc = L["Show XP/Rep to go in label"],
						get  = function() return self.db.profile.ToGo end,
						set  = function()
							self.db.profile.ToGo = not self.db.profile.ToGo
							self:UpdateLabel() 
						end,
						order = 2
					},
					faction = {
						type = 'toggle',
						name = L["Show faction name"],
						desc = L["Show faction name when reputation is selected as label text."],
						get  = function() return self.db.profile.ShowFactionName end,
						set  = function()
							self.db.profile.ShowFactionName = not self.db.profile.ShowFactionName
							self:UpdateLabel() 
						end,
						order = 3
					},
					values = {
						type = 'toggle',
						name = L["Show Values"],
						desc = L["Show values in label text"],
						get  = function() return self.db.profile.ShowValues end,
						set  = function()
							self.db.profile.ShowValues = not self.db.profile.ShowValues
							self:UpdateLabel() 
						end,
						order = 4
					},
					perc = {
						type = 'toggle',
						name = L["Show Percentage"],
						desc = L["Show percentage in label text"],
						get  = function() return self.db.profile.ShowPercentage end,
						set  = function()
							self.db.profile.ShowPercentage = not self.db.profile.ShowPercentage
							self:UpdateLabel() 
						end,
						order = 5
					},
					colored = {
						type = 'toggle',
						name = L["Colored Label"],
						desc = L["Color label text based on percentages"],
						get  = function() return self.db.profile.ColoredText end,
						set  = function()
							self.db.profile.ColoredText = not self.db.profile.ColoredText
							self:UpdateLabel() 
						end,
						order = 6
					},
					separators = {
						type = 'toggle',
						name = L["Separators"],
						desc = L["Use separators for numbers to improve readability"],
						get  = function() return self.db.profile.Separators end,
						set  = function()
							self.db.profile.Separators = not self.db.profile.Separators
							self:UpdateLabel() 
						end,
						order = 7
					},
					abbreviations = {
						type = 'toggle',
						name = L["Abbreviations"],
						desc = L["Use abbreviations to shorten numbers"],
						get  = function() return self.db.profile.Abbreviations end,
						set  = function()
							self.db.profile.Abbreviations = not self.db.profile.Abbreviations
							self:UpdateLabel() 
						end,
						order = 8
					},
					tooltipabbrev = {
						type = 'toggle',
						name = L["Tip Abbreviations"],
						desc = L["Use abbreviations in tooltip"],
						get  = function() return self.db.profile.TTAbbreviations end,
						set  = function()
							self.db.profile.TTAbbreviations = not self.db.profile.TTAbbreviations
						end,
						order = 9
					},
					decimalplaces = {
						type = 'select',
						name = L["Decimal Places"],
						desc = L["Number of decimal places when using abbreviations"],
						get  = function() return self.db.profile.DecimalPlaces end,
						set  = function(info, key)
							self.db.profile.DecimalPlaces = key
							self:UpdateLabel() 
						end,
						values = { [0] = "0", [1] = "1", [2] = "2", [3] = "3" },
						order = 10
					},
				},
			},
			autotrack = {
				type = 'group',
				name = L["Faction Tracking"],
				desc = L["Auto-switch watched faction on reputation gains/losses."],
				args = {
					gain = {
						type = 'toggle',
						name = L["Switch on rep gain"],
						desc = L["Auto-switch watched faction on reputation gain."],
						get  = function() return self.db.profile.AutoTrackOnGain end,
						set  = function()
							self.db.profile.AutoTrackOnGain = not self.db.profile.AutoTrackOnGain
							self:UpdateAutoTrack() 
						end,
						order = 1
					},
					loss = {
						type = 'toggle',
						name = L["Switch on rep loss"],
						desc = L["Auto-switch watched faction on reputation loss."],
						get  = function() return self.db.profile.AutoTrackOnLoss end,
						set  = function()
							self.db.profile.AutoTrackOnLoss = not self.db.profile.AutoTrackOnLoss
							self:UpdateAutoTrack() 
						end,
						order = 2
					},
				},
			},
			level = {
				type = 'group',
				name = L["Leveling"],
				desc = L["Leveling Properties"],
				args = {
					timeframe = {
						type = 'range',
						name = L["Time Frame"],
						desc = L["Time frame for dynamic TTL calculation."],
						get = function() return self.db.profile.TimeFrame end,
						set = function(info, v) 
							self.db.profile.TimeFrame = v
							tainted_xp = true
							self:ProcessXPHistory()
						end,
						min = 0,
						max = 120,
						step = 1,
						order = 1
					},
					weight = {
						type = 'range',
						name = L["Weight"],
						desc = L["Weight time frame vs. session average for dynamic TTL calculation."],
						get = function() return self.db.profile.Weight end,
						set = function(info, v) 
							self.db.profile.Weight = v
							tainted_xp = true
							self:ProcessXPHistory()
						end,
						min = 0,
						max = 1,
						step = 0.01,
						order = 2
					},
				},
			},
			maxlvl = {
				type = 'group',
				name = L["Max. XP/Rep"],
				desc = L["Display settings at maximum level/reputation"],
				args = {
					hidexptxt = {
						type = 'toggle',
						name = L["No XP label"],
						desc = L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."],
						get  = function() return self.db.profile.MaxHideXPText end,
						set  = function()
							self.db.profile.MaxHideXPText = not self.db.profile.MaxHideXPText
							self:UpdateLabel() 
						end,
						order = 1
					},
					hidexpbar = {
						type = 'toggle',
						name = L["No XP bar"],
						desc = L["Don't show XP bar at maximum level."],
						get  = function() return self.db.profile.MaxHideXPBar end,
						set  = function()
							self.db.profile.MaxHideXPBar = not self.db.profile.MaxHideXPBar
							self:Reanchor() 
						end,
						order = 2
					},
					hidereptxt = {
						type = 'toggle',
						name = L["No Rep label"],
						desc = L["Don't show label text at maximum Reputation. Affects Rep option only."],
						get  = function() return self.db.profile.MaxHideRepText end,
						set  = function()
							self.db.profile.MaxHideRepText = not self.db.profile.MaxHideRepText
							self:UpdateLabel() 
						end,
						order = 3
					},
					hiderepbar = {
						type = 'toggle',
						name = L["No Rep bar"],
						desc = L["Don't show Rep bar at maximum Reputation."],
						get  = function() return self.db.profile.MaxHideRepBar end,
						set  = function()
							self.db.profile.MaxHideRepBar = not self.db.profile.MaxHideRepBar
							self:Reanchor() 
						end,
						order = 4
					},
				},
			},
			faction = {
				type = "select", 
				name = L["Faction"],
				desc = L["Select Faction"],
				get = function()
					return lookupIndexes[self:GetFaction()] or 1
				end,
				set = function(info, key)
					self:SetFaction(lookupFactions[key] or 0)
				end,
				handler = BrokerXPBar,
				values = "QueryFactions", 
				order = 1,
			},
			blizzbars = {
				type = 'toggle',
				name = L["Blizzard Bars"],
				desc = L["Show default Blizzard Bars"],
				get  = function() return self.db.profile.ShowBlizzBars end,
				set  = function()
					self.db.profile.ShowBlizzBars = not self.db.profile.ShowBlizzBars
					self:ShowBlizzardBars(self.db.profile.ShowBlizzBars) 
				end,
				order = 2
			},
			minimap = {
				type = 'toggle',
				name = L["Minimap Button"],
				desc = L["Show Minimap Button"],
				get  = function() return self.db.profile.Minimap end,
				set  = function()
					self.db.profile.Minimap = not self.db.profile.Minimap
					
					self:ShowMinimapButton(self.db.profile.Minimap)
				end,
				order = 3
			},
			hint = {
				type = 'toggle',
				name = L["Hide Hint"],
				desc = L["Hide usage hint in tooltip"],
				get  = function() return self.db.profile.HideHint end,
				set  = function()
					self.db.profile.HideHint = not self.db.profile.HideHint
				end,
				order = 4
			},
		}
	}

end

function BrokerXPBar:OnInitialize()
	self.db = LibStub:GetLibrary("AceDB-3.0"):New(MODNAME.."_DB", defaults, "Default")
	self:SetupOptions()
	
	-- profile support
	options.args.profile = LibStub:GetLibrary("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied",  "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset",   "OnProfileChanged")
	
	AceConfigReg:RegisterOptionsTable(FULLNAME, options)
	AceConfigDialog:AddToBlizOptions(FULLNAME)

    self:RegisterChatCommand("brokerxpbar", "ChatCommand")
	self:RegisterChatCommand("bxp",         "ChatCommand")
		
	-- bar setup
	local MainFrame = CreateFrame("Frame", "BrokerXPBarFrame", UIParent)
	MainFrame:SetFrameStrata(self.db.profile.Strata)
	MainFrame:SetHeight(2 * self.db.profile.Thickness + 5)	
	MainFrame:SetWidth(2 * self.db.profile.Thickness + 5)	
	
	local XPBar = CreateFrame("Frame", "BrokerXPBar", MainFrame)
	XPBar:SetFrameStrata(self.db.profile.Strata)
	XPBar:SetHeight(self.db.profile.Thickness)

	local tex = XPBar:CreateTexture("XPBarTex", "ARTWORK")
	tex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\texture.tga")
	tex:SetVertexColor(self.db.profile.XP.r, self.db.profile.XP.g, self.db.profile.XP.b, self.db.profile.XP.a)
	tex:ClearAllPoints()
	tex:Show()
	
	local spark = XPBar:CreateTexture("XPSpark", "OVERLAY")
	spark:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\glow.tga")
	spark:SetAlpha(self.db.profile.Spark)
	spark:SetWidth(128)
	spark:SetHeight((self.db.profile.Thickness) * 8)
	spark:SetVertexColor(self.db.profile.XP.r, self.db.profile.XP.g, self.db.profile.XP.b, self.db.profile.Spark)
	spark:SetBlendMode("ADD")

	local spark2 = XPBar:CreateTexture("XPSpark2", "OVERLAY")
	spark2:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\glow2.tga")
	spark2:SetAlpha(self.db.profile.Spark)
	spark2:SetWidth(32)
	spark2:SetHeight((self.db.profile.Thickness) * 8)
	spark2:SetBlendMode("ADD")

	local restex = XPBar:CreateTexture("RestedXPTex", "BORDER")
	restex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\texture.tga")
	restex:SetVertexColor(self.db.profile.Rest.r, self.db.profile.Rest.g, self.db.profile.Rest.b, self.db.profile.Rest.a)
	restex:ClearAllPoints()
	restex:Show()

	local notex = XPBar:CreateTexture("NoXPTex", "BACKGROUND")
	notex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\texture.tga")
	notex:SetVertexColor(self.db.profile.None.r, self.db.profile.None.g, self.db.profile.None.b, self.db.profile.None.a)
	notex:ClearAllPoints()
	notex:Show()
	notex:SetAllPoints(XPBar)
	
	local Rep = CreateFrame("Frame", "BrokerXPRepBar", MainFrame)
	Rep:SetFrameStrata(self.db.profile.Strata)
	Rep:SetHeight(self.db.profile.Thickness)

	local reptex = Rep:CreateTexture("RepTex", "ARTWORK")
	reptex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\texture.tga")
	reptex:SetVertexColor(self.db.profile.Rep.r, self.db.profile.Rep.g, self.db.profile.Rep.b, self.db.profile.Rep.a)
	reptex:ClearAllPoints()
	reptex:Show()

	local rspark = Rep:CreateTexture("RepSpark", "OVERLAY")
	rspark:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\glow.tga")
	rspark:SetAlpha(self.db.profile.Spark)
	rspark:SetWidth(128)
	rspark:SetHeight((self.db.profile.Thickness) * 8)
	rspark:SetVertexColor(self.db.profile.Rep.r, self.db.profile.Rep.g, self.db.profile.Rep.b, self.db.profile.Spark)
	rspark:SetBlendMode("ADD")

	local rspark2 = Rep:CreateTexture("RepSpark2", "OVERLAY")
	rspark2:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\glow2.tga")
	rspark2:SetAlpha(self.db.profile.Spark)
	rspark2:SetWidth(32)
	rspark2:SetHeight((self.db.profile.Thickness) * 8)
	rspark2:SetBlendMode("ADD")

	local noreptex = Rep:CreateTexture("NoRepTex", "BACKGROUND")
	noreptex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\texture.tga")
	noreptex:SetVertexColor(self.db.profile.NoRep.r, self.db.profile.NoRep.g, self.db.profile.NoRep.b, self.db.profile.NoRep.a)
	noreptex:ClearAllPoints()
	noreptex:SetAllPoints(Rep)
	noreptex:Show()

	local Border = CreateFrame("Frame", "BrokerXPBorder", MainFrame)
	Border:SetFrameStrata(self.db.profile.Strata)
	Border:SetHeight(5)
	
	local bordtex = Border:CreateTexture("BorderTex", "BACKGROUND")
	bordtex:SetTexture("Interface\\AddOns\\" .. DIRNAME .. "\\Textures\\border.tga")
	bordtex:SetVertexColor(0, 0, 0, 1)
	bordtex:ClearAllPoints()
	bordtex:SetAllPoints(Border)

	self.MainFrame   = MainFrame
	self.XPBar       = XPBar
	self.XPBarTex    = tex
	self.Spark       = spark
	self.Spark2      = spark2
	self.NoXPTex     = notex
	self.RestedXPTex = restex
	self.RepBar      = Rep
	self.RepBarTex   = reptex
	self.RepSpark    = rspark
	self.RepSpark2   = rspark2
	self.NoRepTex    = noreptex
	self.Border      = Border
	self.BorderTex   = bordtex
end

function BrokerXPBar:OnEnable()
	self:RegisterBucketEvent("UPDATE_EXHAUSTION", 60, "Update")
    self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateIcon")
	self:RegisterEvent("UPDATE_FACTION", "UpdateStanding")
	
	-- init xp rate session vars
	playerlvl     = UnitLevel("player")
	starttime     = time()
	if (GetXPExhaustion() or 0) == 0 then
		endresttime  = starttime
	end
	totalkills    = 0
	totalxp       = 0
	activitykills = 0
	activityxp    = 0
	startxp       = UnitXP("player")
	lvlmaxxp      = UnitXPMax("player")
	
	if playerlvl < MAX_LEVEL then
		self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:RegisterEvent("PLAYER_XP_UPDATE")
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end
	
	self:UpdateAutoTrack()
	
	self:UpdateIcon()	

	-- if we don't want to show the bars we hide them else we leave them as they are
	if not self.db.profile.ShowBlizzBars then
		self:ShowBlizzardBars(false)
	end
	
	self:InitialAnchoring()
	
	self:Update()

	if self.db.profile.ShowText == "TTL" then
		self.timer = self:ScheduleRepeatingTimer("UpdateLabel", 1)
	end	
end

function BrokerXPBar:OnDisable()
	self:HideBar()

	-- if we hid the bars ourselves we restore them else we leave them as they are
	if not self.db.profile.ShowBlizzBars then
		self:ShowBlizzardBars(true)
	end
	
	self:UnregisterEvent("PLAYER_UPDATE_RESTING")
	self:UnregisterEvent("UPDATE_FACTION")
	
	if playerlvl < MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
	end

	self:UpdateAutoTrack(false)
	
	self:UnregisterAllBuckets()
	self:UnhookAll()
	
	if self.db.profile.ShowText == "TTL" then
		self:CancelTimer(self.timer)
	end		
end

function BrokerXPBar:ChatCommand(input)
    if input then  
		args = GetArgs(input, "^ *([^%s]+) *")
		
		self:TriggerAction(args[1], tremove(args, 1))
	else
		self:TriggerAction("help")
	end
end

function BrokerXPBar:OnProfileChanged(event, database, newProfileKey)
	self.db.profile = database.profile
	
	self:UpdateColor("XP",    self.XPBarTex, self.Spark)
	self:UpdateColor("Rest",  self.RestedXPTex)
	self:UpdateColor("None",  self.NoXPTex)
	self:UpdateReputationColor()
	self:UpdateColor("NoRep", self.NoRepTex)

	self:UpdateStanding()
	self:Reanchor()
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
		InterfaceOptionsFrame_OpenToCategory(FULLNAME)
	elseif action == "version" then
		-- print version information
		self:PrintVersionInfo()
	else -- if action == "help" then
		-- display help
		Output(L["Usage:"])
		Output(L["/brokerxpbar arg"])
		Output(L["/bxp arg"])
		Output(L["Args:"])
		Output(L["version - display version information"])
		Output(L["menu - display options menu"])
		Output(L["help - display this help"])
	end
end

-- layout
function BrokerXPBar:Reanchor()
	local point, relpoint, y
	local sy = 0
	
	barframe = self.db.profile.Frame and getglobal(self.db.profile.Frame) or nil
	
	if barframe == nil then
		self:HideBar()
		return 
	end
		
	if self.db.profile.Location == "Top" or self.db.profile.Location == "Bottom" then
		horizontal = true
	else
		horizontal = false
	end

	-- assign anchor points
	if self.db.profile.Location == "Top" then
		relpoint = "TOPLEFT"
	elseif self.db.profile.Location == "Right" then
		relpoint = "BOTTOMRIGHT"
	else
		relpoint = "BOTTOMLEFT"
	end

	if horizontal then
		if (self.db.profile.Location == "Top" and (not self.db.profile.Inside) ) or
			(self.db.profile.Location ~= "Top" and self.db.profile.Inside) then
			point = "BOTTOMLEFT"
			self.BorderTex:SetTexCoord(1,0,1,0)
			y = 1
		else
			point = "TOPLEFT"
			self.BorderTex:SetTexCoord(1,0,0,1)
			y = -1
		end

		self.XPBarTex:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		self.NoXPTex:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		self.RestedXPTex:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		self.Spark:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
		self.Spark2:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)

		self.RepBarTex:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		self.NoRepTex:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		self.RepSpark:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
		self.RepSpark2:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
	else
		if (self.db.profile.Location == "Right" and (not self.db.profile.Inside) ) or
			(self.db.profile.Location ~= "Right" and self.db.profile.Inside) then
			point = "BOTTOMLEFT"
			self.BorderTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
			y = 1
		else
			point = "BOTTOMRIGHT"
			self.BorderTex:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
			y = -1
		end

		self.XPBarTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
		self.NoXPTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
		self.RestedXPTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
		self.Spark:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
		self.Spark2:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)

		self.RepBarTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
		self.NoRepTex:SetTexCoord(0, 0, 1, 0, 0, 1, 1, 1)
		self.RepSpark:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
		self.RepSpark2:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
	end
	
	-- detach from old frame
	self.MainFrame:ClearAllPoints()
	self.XPBar:ClearAllPoints()
	self.RepBar:ClearAllPoints()
	self.Border:ClearAllPoints()
	
	-- attach to new frame
	local xOffset = self.db.profile.xOffset
	local yOffset = self.db.profile.yOffset
	
	self:AttachBarToFrame(self.MainFrame, point, barframe, relpoint, xOffset, yOffset)
	
	if self:IsBarRequired("XP") then
		local offset = 0
		
		if self.db.profile.Inverse and self:IsBarRequired("Rep") then
			offset = y * self.db.profile.Thickness
		end
		
		if horizontal then
			xOffset = 0
			yOffset = offset
		else
			xOffset = offset
			yOffset = 0
		end
		
		self:AttachBarToFrame(self.XPBar, point, self.MainFrame, point, xOffset, yOffset)
		
		sy = sy + y
	end
	
	if self:IsBarRequired("Rep") then
		local offset = 0
		
		if not self.db.profile.Inverse and self:IsBarRequired("XP") then
			offset = y * self.db.profile.Thickness
		end
		
		if horizontal then
			xOffset = 0
			yOffset = offset
		else
			xOffset = offset
			yOffset = 0
		end

		self:AttachBarToFrame(self.RepBar, point, self.MainFrame, point, xOffset, yOffset)

		sy = sy + y
	end
		
	if self.db.profile.Shadow then
		if horizontal then
			xOffset = 0
			yOffset = sy * self.db.profile.Thickness
		else
			xOffset = sy * self.db.profile.Thickness
			yOffset = 0
		end

		self:AttachBarToFrame(self.Border, point, self.MainFrame, point, xOffset, yOffset)
	end
	
	-- reset tex points
	self.Spark:ClearAllPoints()
	self.Spark2:ClearAllPoints()

	self.XPBarTex:ClearAllPoints()
	self.XPBarTex:SetPoint("TOP",    self.XPBar, "TOP")
	self.XPBarTex:SetPoint("BOTTOM", self.XPBar, "BOTTOM")
	self.XPBarTex:SetPoint("LEFT",   self.XPBar, "LEFT")
	self.XPBarTex:SetPoint("RIGHT",  self.XPBar, "RIGHT")
	
	self.RestedXPTex:ClearAllPoints()
	self.RestedXPTex:SetPoint("TOP",    self.XPBar, "TOP")
	self.RestedXPTex:SetPoint("BOTTOM", self.XPBar, "BOTTOM")
	self.RestedXPTex:SetPoint("LEFT",   self.XPBar, "LEFT")
	self.RestedXPTex:SetPoint("RIGHT",  self.XPBar, "RIGHT")
	
	self.RepSpark:ClearAllPoints()
	self.RepSpark2:ClearAllPoints()

	self.RepBarTex:ClearAllPoints()
	self.RepBarTex:SetPoint("TOP",    self.RepBar, "TOP")
	self.RepBarTex:SetPoint("BOTTOM", self.RepBar, "BOTTOM")
	self.RepBarTex:SetPoint("LEFT",   self.RepBar, "LEFT")
	self.RepBarTex:SetPoint("RIGHT",  self.RepBar, "RIGHT")
	
	-- restore minimal bar size
	if horizontal then
		self.XPBar:SetWidth(self.db.profile.Thickness)

		self.Spark:SetWidth(128)
		self.Spark2:SetWidth(128)

		self.RepBar:SetWidth(self.db.profile.Thickness)
	
		self.RepSpark:SetWidth(128)
		self.RepSpark2:SetWidth(128)
	else
		self.XPBar:SetHeight(self.db.profile.Thickness)
	
		self.Spark:SetHeight(128)
		self.Spark2:SetHeight(128)

		self.RepBar:SetHeight(self.db.profile.Thickness)
	
		self.RepSpark:SetHeight(128)
		self.RepSpark2:SetHeight(128)

	end
	
	self.Border:SetWidth(8)
	self.Border:SetHeight(8)
	
	self:SetThickness(self.db.profile.Thickness)

	-- (re)anchoring finished
	self.Anchored = true	
	
	self:ShowBar()
	
	self:UpdateData()

	if Jostle then Jostle:Refresh() end
end

function BrokerXPBar:AttachBarToFrame(bar, point, frame, relpoint, xOffset, yOffset)
	bar:SetParent(frame)
	bar:SetPoint(point, frame, relpoint, xOffset, yOffset)
end

function BrokerXPBar:TextureSetPoint(tex, bar, point, offset)
	local xOffset, yOffset
	
	if horizontal then
		xOffset = offset
		yOffset = 0
	else
		xOffset = 0
		yOffset = offset
	end
	
	tex:SetPoint(point, bar, point, xOffset, yOffset)
end

function BrokerXPBar:ShowBar()
	local height = 0
	
	self:HideBar()

	if self:IsBarRequired("XP") then
		self.XPBar:Show()
		self.Spark:Show()
		self.Spark2:Show()
		height = height + self.db.profile.Thickness

		-- register for jostle
		if Jostle and self.db.profile.Jostle and horizontal then
			if self.db.profile.Location == "Bottom" then
				Jostle:RegisterTop(self.XPBar)
			else
				Jostle:RegisterBottom(self.XPBar)
			end
		end		
	end
	
	if self:IsBarRequired("Rep") then
		self.RepBar:Show()
		self.RepSpark:Show()
		self.RepSpark2:Show()
		height = height + self.db.profile.Thickness

		-- register for jostle
		if Jostle and self.db.profile.Jostle and horizontal then
			if self.db.profile.Location == "Bottom" then
				Jostle:RegisterTop(self.RepBar)
			else
				Jostle:RegisterBottom(self.RepBar)
			end
		end
	end
	
	if self.db.profile.Shadow then
		self.Border:Show()
		height = height + 5
	end

	if horizontal then
		self.MainFrame:SetHeight(height)
	else
		self.MainFrame:SetWidth(height)		
	end
	
	self.MainFrame:Show() 

	return height
end

function BrokerXPBar:HideBar()
	-- remove from jostle
	if Jostle then
		Jostle:Unregister(self.XPBar)
		Jostle:Unregister(self.RepBar)
	end

	self.XPBar:Hide()
	self.Spark:Hide()
	self.Spark2:Hide()
	self.Border:Hide()
	self.RepBar:Hide()
	self.RepSpark:Hide()
	self.RepSpark2:Hide()
	
	self.MainFrame:Hide() 
end

function BrokerXPBar:IsBarRequired(bar)
	if bar == "XP" then
		if self.db.profile.ShowXP then
			return playerlvl < MAX_LEVEL or not self.db.profile.MaxHideXPBar
		end
	elseif bar == "Rep" then
		if self.db.profile.ShowRep and faction ~= 0 then
			return not atmaxrep or not self.db.profile.MaxHideRepBar
		end
	end
	
	return false
end

-- update functions
function BrokerXPBar:InitialAnchoring()
	-- try to attach to the anchor frame for 30 secs and then give up
	if not self.Anchored and countinitial < 30 then
		self:Reanchor()
		countinitial = countinitial + 1
		self:ScheduleTimer("InitialAnchoring", 1)
	else
		self:UpdateWatchedFactionIndex()
	end
end

function BrokerXPBar:UpdateStanding()
	local standing = 0
	
	-- check for changes in watched faction
	self:UpdateWatchedFactionIndex()
	
	if faction ~= 0 then
		_, _, standing = GetFactionInfo(faction)
	end
		
	if standing ~= watchedstanding then
		watchedstanding = standing
		
		if self.db.profile.BlizzRep then
			self:UpdateReputationColor()
		end
	end

	self:Update()
end

function BrokerXPBar:UpdateAutoTrack(register)
	if register == nil then
		register = self.db.profile.AutoTrackOnLoss or self.db.profile.AutoTrackOnLoss
	end
	
	if register then
		self:RegisterEvent("COMBAT_TEXT_UPDATE")
	else
		self:UnregisterEvent("COMBAT_TEXT_UPDATE")
	end
end

function BrokerXPBar:Update()
	self:UpdateData()
	self:UpdateLabel()
end

function BrokerXPBar:UpdateData()
	local length
	local front, back, barlength

	if barframe == nil then
		return
	end
	
	if horizontal then
		front = "LEFT"
		back  = "RIGHT"
	
		barlength = barframe:GetWidth()

		-- adjust to possible changes in parent frame dimensions
		self.MainFrame:SetWidth(barlength)
		self.XPBar:SetWidth(barlength)
		self.RepBar:SetWidth(barlength)
		self.Border:SetWidth(barlength)
	else
		front = "BOTTOM"
		back  = "TOP"
	
		barlength = barframe:GetHeight()

		-- adjust to possible changes in parent frame dimensions
		self.MainFrame:SetHeight(barlength)
		self.XPBar:SetHeight(barlength)
		self.RepBar:SetHeight(barlength)
		self.Border:SetHeight(barlength)
	end

	if self.db.profile.ShowXP then
		local currentXP = UnitXP("player")
		local maxXP = UnitXPMax("player")
		local restXP = GetXPExhaustion() or 0
		local remainXP = maxXP - (currentXP + restXP)
	
		if remainXP < 0 then
			remainXP = 0
		end

		length = (currentXP / maxXP) * barlength
		
		self:TextureSetPoint(self.XPBarTex, self.XPBar, back, length-barlength)
		self:TextureSetPoint(self.RestedXPTex, self.XPBar, front, length)

		self:TextureSetPoint(self.Spark, self.XPBar, back, length-barlength+11)
		self:TextureSetPoint(self.Spark2, self.XPBar, back, length-barlength+11)
		
		-- resize spark to avoid excessive overlapping
		local sparklength  = 128
		local spark2length = 32
		
		if length < 128 then
			sparklength = 28 + (length*100/128)
		end
		
		if length < 32 then
			spark2length = 8 + (length*100/32)
		end

		self.Spark:SetWidth(sparklength)
		self.Spark2:SetWidth(spark2length)	
		
		if (restXP + currentXP) / maxXP > 1 then
			length = barlength
		else
			length = length + (restXP / maxXP) * barlength
		end

		self:TextureSetPoint(self.RestedXPTex, self.XPBar, back, length-barlength)
	end

	if self.db.profile.ShowRep then
		local name, standing, minRep, maxRep, currentRep = nil, 0, 0, 0, 0
		
		if faction == 0 then
			length = 0
		else
			name, _, standing, minRep, maxRep, currentRep = GetFactionInfo(faction)
			length = ((currentRep - minRep) / (maxRep - minRep)) * barlength
		end
		
		self:TextureSetPoint(self.RepBarTex, self.RepBar, back, length-barlength)

		self:TextureSetPoint(self.RepSpark, self.RepBar, back, length-barlength+11)
		self:TextureSetPoint(self.RepSpark2, self.RepBar, back, length-barlength+11)
		
		-- resize spark to avoid excessive overlapping
		local sparklength  = 128
		local spark2length = 32
		
		if length < 128 then
			sparklength = 28 + (length*100/128)
		end
		
		if length < 32 then
			spark2length = 8 + (length*100/32)
		end

		self.RepSpark:SetWidth(sparklength)
		self.RepSpark2:SetWidth(spark2length)	
		
		if not atmaxrep and standing == 8 and currentRep + 1 == maxRep then
			self:MaxReputationReached()
		end
	end
end

function BrokerXPBar:UpdateLabel()
	local show = self.db.profile.ShowText

	if show == "XPFirst" then
		if playerlvl == MAX_LEVEL then
			show = "Rep"
		else
			show = "XP"
		end
	elseif show == "RepFirst" then
		if faction == 0 then
			show = "XP"
		else
			show = "Rep"
		end
	end
	
    if show == "XP" or
	   show == "TTL" or
	   show == "KTL" then
		if playerlvl == MAX_LEVEL then
			if self.db.profile.MaxHideXPText then
				dataobj.text = ""
			else
				dataobj.text = L["Max Level"]
			end
			return
		end
	end
	
	if show == "Rep" and atmaxrep and self.db.profile.MaxHideRepText then
		dataobj.text = ""
		return
	end

    if show == "Rep" or show == "XP"  then
		local current, min, max = 0, 0, 100
		local name
		local label, values, percentage  = "", "", ""
		
		if show == "XP" then
			current, max = UnitXP("player"), UnitXPMax("player")
		else
			if faction == 0 then
				dataobj.text = L["No watched faction"]
				return
			end
			
			name, _, _, min, max, current = GetFactionInfo(faction)
						
			current = current - min
			max     = max - min
			
			if self.db.profile.ShowFactionName then
				label  = name ..": "
			end
		end
        
        if self.db.profile.ToGo then
			local toGo        = max - current
			local percentToGo = floor(toGo / max * 100)
			
			if Crayon and self.db.profile.ColoredText then
				values     = "|cff"..Crayon:GetThresholdHexColor(toGo, max, max * 0.75, max * 0.5, max * 0.25, 1) .. self:FormatNumberLabel(toGo) .. "|r"
				percentage = "|cff"..Crayon:GetThresholdHexColor(percentToGo, 100, 75, 50, 1) .. percentToGo .. "|r"
			else
				values     = self:FormatNumberLabel(toGo)
				percentage = percentToGo
			end			
        else 
			local percent = floor(current/max * 100)
			
			if Crayon and self.db.profile.ColoredText then
				values     = "|cff"..Crayon:GetThresholdHexColor(current, 1, max * 0.25, max * 0.5, max * 0.75, max) .. self:FormatNumberLabel(current) .. "|r"
				percentage = "|cff"..Crayon:GetThresholdHexColor(percent, 1, 25, 50, 75, 100) .. percent .. "|r"
			else
				values     = self:FormatNumberLabel(current)
				percentage = percent
			end
			
			values = values .. "/" .. self:FormatNumberLabel(max)
        end
		
		if self.db.profile.ShowValues then
			label = label .. values
		end
			
		if self.db.profile.ShowPercentage then
			if self.db.profile.ShowValues then
				label = label .. " (" .. percentage .. "%)"
			else
				label = label .. percentage .. "%"
			end
		end
		
		dataobj.text = label
    elseif show == "TTL" then		
		self:ProcessHistory()
			
		dataobj.text = L["TTL"] .. ": " .. self:GetTimeToLevel()
    elseif show == "KTL" then
		self:ProcessHistory()
			
		dataobj.text = L["KTL"] .. ": " .. Red( self:GetKillsToLevel() )
    else
        dataobj.text = MODNAME
    end
end

function BrokerXPBar:UpdateReputationColor()
	local r, g, b, a
	
	if self.db.profile.BlizzRep and watchedstanding then
		r = blizz_rep_colors[watchedstanding].r;
		g = blizz_rep_colors[watchedstanding].g;
		b = blizz_rep_colors[watchedstanding].b;
		a = blizz_rep_colors[watchedstanding].a;
	else
		r, g, b, a = self:GetColor("Rep")
	end
	
	self.RepBarTex:SetVertexColor(r, g, b, a)
	self.RepSpark:SetVertexColor(r, g, b, self.db.profile.Spark)
end

function BrokerXPBar:UpdateIcon()
    if IsResting() then
		dataobj.icon = "Interface\\Addons\\"..DIRNAME.."\\iconrest.tga"
    else
		dataobj.icon = "Interface\\Addons\\"..DIRNAME.."\\icon.tga"
    end
end

function BrokerXPBar:MaxLevelReached()
	if playerlvl == MAX_LEVEL then
		self:UnregisterEvent("PLAYER_XP_UPDATE")
		self:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
		
		self:Reanchor()
	end
end

function BrokerXPBar:MaxReputationReached()
	if not atmaxrep then
		atmaxrep = true
		
		self:Reanchor()
	end
end

-- tooltip
function BrokerXPBar:DrawTooltip()
	local colcount = tooltip:GetColumnCount()	
	
	local totalXP = UnitXPMax("player")
	local currentXP = UnitXP("player")
	local toLevelXP = totalXP - currentXP
	local toLevelXPPercent = floor((currentXP / totalXP) * 100)

	-- Add our header
	local lineNum = tooltip:AddHeader( " " )
	tooltip:SetCell( lineNum, 1, White( FULLNAME ), "CENTER", colcount )
	tooltip:AddLine( " " )

	if self.db.profile.ShowXP then
		if GetXPExhaustion() then
			local xpEx = GetXPExhaustion()
			local xpExPercent
			if xpEx - toLevelXP > 0 then
				xpExPercent = floor(((xpEx - toLevelXP) / totalXP) * 100)
			else
				xpExPercent = floor((xpEx / totalXP) * 100)
			end
			if Crayon then
				-- Scale: 1 - 100
				-- ExXP:  1 - toLevelXP
				xpEx = "|cff"..Crayon:GetThresholdHexColor(xpEx, 1, toLevelXP * 0.25, toLevelXP * 0.5, toLevelXP * 0.75, toLevelXP) .. self:FormatNumberTip(xpEx) .. "|r"
				xpExPercent = "|cff"..Crayon:GetThresholdHexColor(xpExPercent, 1, 25, 50, 75, 100) .. self:FormatNumberTip(xpExPercent) .. "|r"
			else
				xpEx = self:FormatNumberTip(xpEx, true)
				xpExPercent = self:FormatNumberTip(xpExPercent, true)
			end
			if GetXPExhaustion() - toLevelXP > 0 then
				xpExPercent = "100% + "..xpExPercent
			end
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, L["Rested XP"], "LEFT" )
			tooltip:SetCell( lineNum, 2, string.format("%s (%s%%)", xpEx, xpExPercent), "LEFT" )
		end
		if Crayon then
			currentXP = "|cff"..Crayon:GetThresholdHexColor(currentXP, 1, totalXP * 0.25, totalXP * 0.5, totalXP * 0.75, totalXP) .. self:FormatNumberTip(currentXP) .. "|r"
			toLevelXP = "|cff"..Crayon:GetThresholdHexColor(toLevelXP, totalXP, totalXP * 0.75, totalXP * 0.5, totalXP * 0.25, 1) .. self:FormatNumberTip(toLevelXP) .. "|r"
			toLevelXPPercent = "|cff"..Crayon:GetThresholdHexColor(toLevelXPPercent, 1, 25, 50, 75, 100) .. toLevelXPPercent .. "|r"
		else
			currentXP = self:FormatNumberTip(currentXP, true)
			toLevelXP = self:FormatNumberTip(toLevelXP, true)
		end
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Current XP"], "LEFT" )
		tooltip:SetCell( lineNum, 2, string.format("%s/%s (%s%%)", currentXP, self:FormatNumberTip(totalXP), toLevelXPPercent), "LEFT" )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["To Level"], "LEFT" )
		tooltip:SetCell( lineNum, 2, toLevelXP, "LEFT" )
	end
	
	if self.db.profile.ShowRep and faction ~= 0 then
		local name, desc, standing, minRep, maxRep, currentRep = GetFactionInfo(faction)
		local r, g, b
		r = blizz_rep_colors[standing].r
		g = blizz_rep_colors[standing].g
		b = blizz_rep_colors[standing].b
		
		local fullLevelRep = maxRep - minRep
		local toLevelRep   = maxRep - currentRep
		local atLevelRep   = fullLevelRep - toLevelRep

		if Crayon then
			toLevelRep = "|cff"..Crayon:GetThresholdHexColor(atLevelRep, 1, fullLevelRep * 0.25, fullLevelRep * 0.5, fullLevelRep * 0.75, fullLevelRep) .. self:FormatNumberTip(toLevelRep) .. "|r"
		else
			toLevelRep = self:FormatNumberTip(toLevelRep)
		end

		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Faction"], "LEFT" )
		tooltip:SetCell( lineNum, 2, name, "LEFT" )

		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Rep to next standing"], "LEFT" )
		tooltip:SetCell( lineNum, 2, toLevelRep, "LEFT" )

		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Current rep"], "LEFT" )
		tooltip:SetCell( lineNum, 2, "|cff"..string.format("%02x%02x%02x", r*255, g*255, b*255)..getglobal("FACTION_STANDING_LABEL"..standing).."|r", "LEFT" )
	end

	if self.db.profile.ShowXP and playerlvl < MAX_LEVEL then
		self:ProcessHistory()
		
		local kph  = self:GetKillsPerHour()
		local xpph = self:GetXPPerHour()
		
		if kph then
			kph = string.format("%.0f", kph)
		else
			kph = "~"
		end

		if xpph then
			xpph = string.format("%.0f", xpph)
		else
			xpph = "~"
		end

		tooltip:AddLine( " " )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Session XP"], "LEFT" )
		tooltip:SetCell( lineNum, 2, totalxp, "LEFT" )
		
		tooltip:AddLine( " " )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["XP per hour"], "LEFT" )
		tooltip:SetCell( lineNum, 2, xpph, "LEFT" )

		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Kills per hour"], "LEFT" )
		tooltip:SetCell( lineNum, 2, kph, "LEFT" )
		
		tooltip:AddLine( " " )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Time to level"], "LEFT" )
		tooltip:SetCell( lineNum, 2, self:GetTimeToLevel(), "LEFT" )
		
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, L["Kills to level"], "LEFT" )
		tooltip:SetCell( lineNum, 2, Red( self:GetKillsToLevel() ), "LEFT" )		
	end
	
	if not self.db.profile.HideHint then
		tooltip:AddLine( " " )
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1,  Brownish( L["Click"] .. ":" ) .. Yellow( " " .. L["Send current XP to an open editbox."] ), nil, "LEFT", colcount)
		if faction ~= 0 then
			lineNum = tooltip:AddLine( " " )
			tooltip:SetCell( lineNum, 1, Brownish( L["Shift-Click"] .. ":" ) .. Yellow( " " .. L["Send current reputation to an open editbox."] ), nil, "LEFT", colcount )
		end
		lineNum = tooltip:AddLine( " " )
		tooltip:SetCell( lineNum, 1, Brownish( L["Right-Click"] .. ":" ) .. Yellow( " " .. L["Open option menu."] ), nil, "LEFT", colcount )
	end
	
end

-- events
function BrokerXPBar:PLAYER_XP_UPDATE()
	local bucket
	
	-- check for lvl up
	if lvlmaxxp < UnitXPMax("player") then
		bucket = self:GetWriteBucket()
	
		local leftxp = lvlmaxxp - (totalxp + startxp)
		totalxp = totalxp + leftxp
		bucket.totalxp = bucket.totalxp + leftxp
		donelvlxp = totalxp

		startxp = 0
		lvlmaxxp = UnitXPMax("player")	
	end

	local lvltotal = UnitXP("player") - startxp
	local delta    = lvltotal - (totalxp - donelvlxp)
	
	-- track activity
	bucket = self:GetWriteBucket()
	
	totalxp = lvltotal + donelvlxp
	bucket.totalxp = bucket.totalxp + delta
	
	if not endresttime and (GetXPExhaustion() or 0) == 0 then
		endresttime  = time()
	end

	tainted_xp = true
	
	self:Update()
end

function BrokerXPBar:CHAT_MSG_COMBAT_XP_GAIN(_, combat_string)
	-- kill, rested, group, penalty, raid penalty
	local kxp, rxp, gxp, pxp, rpxp
	local bonustype
	local kill = 0
	local mob
	
	if GetNumRaidMembers() > 0 then
		mob, kxp, rpxp = smatch(combat_string, XPGAIN_RAID)
		
		if not mob then
			mob, kxp, rxp, bonustype, rpxp = smatch(combat_string, XPGAIN_RAID_RESTED)
		end
		
		if not mob then
			mob, kxp, pxp, bonustype, rpxp = smatch(combat_string, XPGAIN_RAID_PENALTY)
		end
	elseif GetNumPartyMembers() > 0 then
		mob, kxp, gxp = smatch(combat_string, XPGAIN_GROUP)
		
		if not mob then
			mob, kxp, rxp, bonustype, gxp = smatch(combat_string, XPGAIN_GROUP_RESTED)
		end
		
		if not mob then
			mob, kxp, pxp, bonustype, gxp = smatch(combat_string, XPGAIN_GROUP_PENALTY)
		end
	end

	-- raid penalty not always applies it seems
	if not mob then
		mob, kxp, rxp, bonustype = smatch(combat_string, XPGAIN_SINGLE_RESTED)
	end
	
	if not mob then
		mob, kxp, pxp, bonustype = smatch(combat_string, XPGAIN_SINGLE_PENALTY)
	end

	if not mob then
		mob, kxp = smatch(combat_string, XPGAIN_SINGLE)
	end
	
	if mob then 
		kill = 1
		
		-- rested bonus is marked as string in the constant for some reason
		rxp = tonumber(rxp)
		-- for koKR and ruRU rxp and bonustype are exchanged
		if not rxp and bonustype then
			rxp = tonumber(bonustype)
		end
		-- penalty is marked as string in the constant for some reason
		pxp = tonumber(pxp)
		-- for koKR and ruRU pxp and bonustype are exchanged
		if not pxp and bonustype then
			pxp = tonumber(bonustype)
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
	
	-- track activity	
	local bucket = self:GetWriteBucket()
	
	totalkills   = totalkills + kill
	bucket.kills = bucket.kills + kill

	-- track mob kills
	local mobdata = {
		kxp = kxp,
		gxp = gxp,
		pxp = rpxp
	}
	
	tinsert(history_mobs, 1, mobdata)
				
	-- remove oldest entry if we exceed history size
	if tgetn(history_mobs) > MAX_HISTORY then
		tremove(history_mobs)
	end
		
	tainted_mobs = true
	
	if self.db.profile.ShowText == "KTL" then
		self:UpdateLabel()
	end
end

function BrokerXPBar:PLAYER_LEVEL_UP(_, newlevel)
	playerlvl = newlevel

	if playerlvl == MAX_LEVEL then
		-- PLAYER_LEVEL_UP seems to be triggered before PLAYER_XP_UPDATE
		-- so we delay the unregister a bit
		self:ScheduleTimer("MaxLevelReached", 3)
	end
end

function BrokerXPBar:COMBAT_TEXT_UPDATE(_, msg_type, faction, amount)
    if msg_type ~= "FACTION" then
		return
	end
	
	if (amount < 0 and self.db.profile.AutoTrackOnLoss) or 
	   (amount > 0 and self.db.profile.AutoTrackOnGain) then
		if faction then
			if not lookupNames[faction] then
				self:QueryFactions()
			end
	
			self:SetFaction(lookupNames[faction])
		end
	end	
end

-- faction functions
function BrokerXPBar:QueryFactions(info)
	local factionTable = {  }
	local sortingTable = {  }

	-- reset lookup table
	lookupFactions = {}
	lookupIndexes  = {}
	lookupNames    = {}
	
	for factionIndex = 1, GetNumFactions() do
		local name, _, standing, _, _ , _ ,_ , _, isHeader = GetFactionInfo(factionIndex)
		
		if not isHeader then
			local r, g, b
			r = blizz_rep_colors[standing].r;
			g = blizz_rep_colors[standing].g;
			b = blizz_rep_colors[standing].b;
			
			table.insert(sortingTable, {factionIndex, name, "|cff"..string.format("%02x%02x%02x", r*255, g*255, b*255)..name.."|r"})
			lookupNames[name] = factionIndex
		end
	end
	
	table.sort(sortingTable, function(a, b) return a[2]<b[2] end)
	
	table.insert(sortingTable, 1, {0, L["None"], L["None"]})
	
	for k, v in pairs(sortingTable) do
		table.insert(factionTable, v[3])
		lookupFactions[#factionTable] = v[1]
		lookupIndexes[v[1]] = #factionTable
	end

	return factionTable
end

function BrokerXPBar:GetFaction()
	return faction
end

function BrokerXPBar:GetFactionName()
	return GetFactionInfo(faction) or L["None"]
end

function BrokerXPBar:UpdateWatchedFactionIndex()
	-- isWatched in GetFactionInfo(factionIndex) doesnt do the trick before use of SetWatchedFactionIndex(index)
	local watchedname = GetWatchedFactionInfo()
	local currentname = GetFactionInfo(faction)
	local index = 0

	if currentname ~= watchedname then
		for i = 1, GetNumFactions() do
			local name, _, _, _, _, _, _,  _, isHeader  = GetFactionInfo(i)			
			if name == watchedname and not isHeader then
				index = i
				break
			end
		end

		self:SetFaction(index)
	end

	return faction
end

-- xp rate calculations
function BrokerXPBar:GetWriteBucket()
	local buckettime = floor(time() / 60)
	local bucket = history_xp[#history_xp]
	
	if not bucket or bucket.time ~= buckettime then
		bucket = {
			time    = buckettime,
			totalxp = 0,
			kills   = 0
		}
		tinsert(history_xp, bucket)
	end
	
	return bucket
end

function BrokerXPBar:GetTimeToLevel()
	if totalxp == 0 then
		return "~"
	end

	local duration = time() - starttime

	if duration == 0 then
		return "~"
	end

	local duration_rest = duration
	
	if endresttime then
		duration_rest = endresttime - starttime
	end
	
	local xp_togo = UnitXPMax("player") - UnitXP("player")
	
	-- xp/s (current)
	local xppersec_c
	-- kills/s (current)
	local killspersec_c
	-- fraction of time with rested bonus
	local rest_factor

	local timeframe = self.db.profile.TimeFrame * 60
	local weight    = self.db.profile.Weight
	
	if timeframe == 0 or duration < timeframe then
		xppersec_c    = totalxp / duration
		killspersec_c = totalkills / duration
		rest_factor   = duration_rest / duration
	else
		xppersec_c    = (activityxp / timeframe) * weight + (totalxp / duration) * (1-weight)
		killspersec_c = (activitykills / timeframe) * weight + (totalkills / duration) * (1-weight)
		local duration_rest_activity = duration_rest - (duration - timeframe)
		rest_factor   = ( duration_rest_activity / timeframe) * weight + (duration_rest / duration) * (1-weight)		
	end

	if xppersec_c == 0 then
		return "~"
	end
	
	-- xp/s (based on mob kills)
	local xppersec_m = xpperkill * killspersec_c
	
	local xp_rested = GetXPExhaustion() or 0
	
	-- fraction of xp/s done by mobkills
	local mob_fraction = xppersec_m / xppersec_c
	
	-- how far does the rested bonus extend 
	-- based on our current fraction of mobkills of xp earned 
	local xp_restrange = 0

	if mob_fraction > 0 then
		xp_restrange = xp_rested / mob_fraction
	end
	
	if xp_restrange > xp_togo then
		xp_restrange = xp_togo
	end

	-- xppersec_c(urrent) = xppersec_nomobs + 2*(xppersec_m(obs))
	local ttl = xp_restrange / xppersec_c + (xp_togo - xp_restrange) / (xppersec_c - (xppersec_m * rest_factor))
	
	return format_time( ttl )	
end

function BrokerXPBar:GetKillsToLevel()
	if xpperkill == 0 then 
		return "~" 
	end
	
	local rested = GetXPExhaustion() or 0
	local xptogo = UnitXPMax("player") - UnitXP("player")
	
	local bonus = 0
	
	if GetNumRaidMembers() > 0 then
		bonus = raid_penaltyperkill
	elseif GetNumPartyMembers() > 0 then
		bonus = grp_xpperkill
	end
	
	-- NOTE: since there is no formula calculating the group bonus available 
	-- we depend on the data we extracted from the combat log
	-- so group bonus is incorrect if the number of players in party/raid changes
	-- but it will adjust faily quick (and we cant take everything into account)
	if rested >= xptogo then
		return ceil(xptogo/(xpperkill * 2 + bonus))
	else
		return ceil((rested/(xpperkill * 2 + bonus)) + ((xptogo - rested)/(xpperkill + bonus)))
	end
end

function BrokerXPBar:GetKillsPerHour()
	local duration = time() - starttime

	if duration == 0 then
		return nil
	end

	if self.db.profile.TimeFrame == 0 or duration < self.db.profile.TimeFrame * 60 then
		return totalkills / duration * 3600
	else
		return ((activitykills / (self.db.profile.TimeFrame * 60)) * self.db.profile.Weight + (totalkills / duration) * (1-self.db.profile.Weight)) * 3600
	end
end

function BrokerXPBar:GetXPPerHour()
	local duration = time() - starttime

	if duration == 0 then
		return nil
	end

	if self.db.profile.TimeFrame == 0 or duration < self.db.profile.TimeFrame * 60 then
		return totalxp / duration * 3600
	else
		return ((activityxp / (self.db.profile.TimeFrame * 60)) * self.db.profile.Weight + (totalxp / duration) * (1-self.db.profile.Weight)) * 3600
	end
end

function BrokerXPBar:ProcessHistory()
	self:ProcessXPHistory()
	self:ProcessMobHistory()
end

function BrokerXPBar:ProcessXPHistory()
	local currentbucket = floor(time() / 60)
	if not tainted_xp and currentbucket == activebucket then 
		return 
	end
	
	activebucket = currentbucket
	
	-- remove old buckets
	while #history_xp ~= 0 and history_xp[1].time <= (activebucket - self.db.profile.TimeFrame) do
		tremove(history_xp, 1)
	end

	local xp, mobxp, kills = 0, 0, 0
	
	for _, bucket in pairs(history_xp) do
		xp    = xp + bucket.totalxp
		kills = kills + bucket.kills
	end

	activityxp    = xp
	activitykills = kills
	
	tainted_xp = false	
end

function BrokerXPBar:ProcessMobHistory()
	if not tainted_mobs then 
		return 
	end
	
	-- regular mean
	local total = 0
	local mean = 0
	local size = tgetn(history_mobs)
	for _, xp in pairs(history_mobs) do
		total = total + xp.kxp
	end
	mean = total/size

	-- std deviation
	total = 0
	local stdev = 0
	for _, xp in pairs(history_mobs) do
		total = total + (xp.kxp - mean)^2
	end
	if size > 1 then
		stdev = sqrt(total/(size-1))
	else
		stdev = 0
	end

	-- mean of values within the stdev
	total = 0
	local group = 0
	local raid = 0
	local count = 0
	
	local low = mean - stdev
	local high = mean + stdev
	
	for _, xp in pairs(history_mobs) do
		if xp.kxp >= low and xp.kxp <= high then
			total = total + xp.kxp
			group = group + xp.gxp
			raid  = raid - xp.pxp
			count = count + 1
		end
	end
	
	if count == 0 then
		xpperkill     = 0
		grp_xpperkill = 0
		raid_penaltyperkill = 0
	else
		xpperkill     = total/count
		grp_xpperkill = group/count
		raid_penaltyperkill = raid/count
	end

	tainted_mobs = false	
end

-- auxillary functions
function BrokerXPBar:FormatNumberLabel(number)
	return format_number(number, self.db.profile.Separators, self.db.profile.Abbreviations, self.db.profile.DecimalPlaces)
end

function BrokerXPBar:FormatNumberTip(number)
	return format_number(number, self.db.profile.Separators, self.db.profile.TTAbbreviations, self.db.profile.DecimalPlaces)
end

-- user functions
function BrokerXPBar:OutputExperience()
	if playerlvl < MAX_LEVEL then
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
		Output(L["Maximum level reached."])
	end
					
end

function BrokerXPBar:OutputReputation()
	if faction ~= 0 then
		local name, desc, standing, minRep, maxRep, currentRep = GetFactionInfo(faction)
		DEFAULT_CHAT_FRAME.editBox:SetText(string.format(L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"],
					name,
					currentRep - minRep,
					maxRep - minRep, 
					(currentRep-minRep)/(maxRep-minRep)*100,
					getglobal("FACTION_STANDING_LABEL"..standing),
					maxRep - currentRep))
	else
		Output(L["Currently no faction tracked."])
	end
end

function BrokerXPBar:PrintVersionInfo()
    Output(L["Version"] .. " " .. White(GetAddOnMetadata(MODNAME, "Version")))
end

-- option getter / setter
function BrokerXPBar:SetThickness(thickness)
	if (horizontal) then
		self.XPBar:SetHeight(thickness)
		self.Spark:SetHeight((thickness) * 8)
		self.Spark2:SetHeight((thickness) * 8)

		self.RepBar:SetHeight(thickness)
		self.RepSpark:SetHeight((thickness) * 8)
		self.RepSpark2:SetHeight((thickness) * 8)
	else
		self.XPBar:SetWidth(thickness)
		self.Spark:SetWidth((thickness) * 8)
		self.Spark2:SetWidth((thickness) * 8)

		self.RepBar:SetWidth(thickness)
		self.RepSpark:SetWidth((thickness) * 8)
		self.RepSpark2:SetWidth((thickness) * 8)
	end

	if self.db.profile.Thickness == thickness then
		return
	end
	
	self.db.profile.Thickness = thickness

	self:Reanchor()
	if Jostle and horizontal then Jostle:Refresh() end
end

function BrokerXPBar:SetFaction(index)
	if not index or faction == index then
		return
	end
	
	faction  = index
	atmaxrep = false
	
	if faction == 0 then
		watchedstanding = 0
	end

	SetWatchedFactionIndex(index)
	
	self:Reanchor()
end

function BrokerXPBar:SetShowText(key)
	if self.db.profile.ShowText == "TTL" then
		self:CancelTimer(self.timer)
	end

	self.db.profile.ShowText = showtext.opt2val[key]
	
	if self.db.profile.ShowText == "TTL" then
		self.timer = self:ScheduleRepeatingTimer("UpdateLabel", 1)
	end
	
	self:UpdateLabel()
end

function BrokerXPBar:GetColor(id)
	return self.db.profile[id].r, self.db.profile[id].g, self.db.profile[id].b, self.db.profile[id].a
end

function BrokerXPBar:SetColor(id, r, g, b, a, tex, spark)
	self.db.profile[id].r = r
	self.db.profile[id].g = g
	self.db.profile[id].b = b
	self.db.profile[id].a = a
	
	self:UpdateColor(id, tex, spark)
end

function BrokerXPBar:UpdateColor(id, tex, spark)
	local r, g, b, a = self:GetColor(id)

	if tex ~= nil then
		tex:SetVertexColor(r, g, b, a)
	end

	if spark ~= nil then
		spark:SetVertexColor(r, g, b, self.db.profile.Spark)
	end
end

function BrokerXPBar:ShowBlizzardBars(show)

	if show then
		-- restore the blizzard frames
		MainMenuExpBar:SetScript("OnEvent", MainMenuExpBar_OnEvent);
		MainMenuExpBar:Show()
	
		ReputationWatchBar:SetScript("OnEvent", ReputationWatchBar_OnEvent);
		ReputationWatchBar:Show()

		ExhaustionTick:SetScript("OnEvent", ExhaustionTick_OnEvent);
		ExhaustionTick:Show() 
	else
		-- hide the blizzard frames
		MainMenuExpBar:SetScript("OnEvent", nil);
		MainMenuExpBar:Hide()

		ReputationWatchBar:SetScript("OnEvent", nil);
		ReputationWatchBar:Hide()

		ExhaustionTick:SetScript("OnEvent", nil);
		ExhaustionTick:Hide()
	end
 
end

