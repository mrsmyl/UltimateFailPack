local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Options module
local Options = Addon:NewModule("Options")

-- internal event handling
Options.callbacks = LibStub("CallbackHandler-1.0"):New(Options)

-- setup libs
local AceGUI            = LibStub("AceGUI-3.0")
local AceConfig 		= LibStub:GetLibrary("AceConfig-3.0")
local AceConfigReg 		= LibStub:GetLibrary("AceConfigRegistry-3.0")
local AceConfigDialog	= LibStub:GetLibrary("AceConfigDialog-3.0")

local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

-- get translations
local L              = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- local functions
local pairs   = pairs
local tinsert = table.insert
local tremove = table.remove

local _

local BLACK = {r = 0, g = 0, b = 0, a = 1}

-- options
local defaults = {
	profile = {
		ShowText           = "XP",
		ShowXP             = true,
		ShowRep            = false,
		Shadow             = true,
		Thickness          = 2,
		Spark              = 1,
		Inverse            = false,
		ExternalTexture    = false,
		Texture            = nil,
		ToGo               = true,
		ShowValues         = true,
		ShowPercentage     = true,
		ShowFactionName    = true,
		ShowRestedValue    = false,
		ShowRestedPerc     = false,
		ColoredText        = true,
		Separators         = false,
		Abbreviations      = false,
		TTAbbreviations    = false,
		DecimalPlaces      = 2,
		ShowBlizzBars      = false,
		HideHint           = false,
		Location           = "Bottom",
		xOffset            = 0,
		yOffset            = 0,
		Inside             = false,
		Strata             = "HIGH",
		Jostle             = false,
		BlizzRep           = true,
        Minimap	           = false,
        MaxHideXPText      = false,
        MaxHideXPBar       = false,
        MaxHideRepText     = false,
        MaxHideRepBar      = false,
        AutoTrackOnGain    = false,
        AutoTrackOnLoss    = false,
		XP                 = {r = 0.0, g = 0.4, b = 0.9, a = 1},
		Rest               = {r = 1.0, g = 0.2, b = 1.0, a = 1},
		None               = {r = 0.0, g = 0.0, b = 0.0, a = 1},
		Rep                = {r = 1.0, g = 0.2, b = 1.0, a = 1},
		NoRep              = {r = 0.0, g = 0.0, b = 0.0, a = 1},
		Weight             = 0.8,
		TimeFrame          = 30,
		TTHideXPDetails    = false,
		TTHideRepDetails   = false,
		Ticks              = 0,
		ShowBarText        = false,
		MouseOver          = false,
		Font               = Addon.FONT_NAME_DEFAULT,
		FontSize           = 10,
		BarToGo            = false,
		BarShowValues      = true,
		BarShowPercentage  = false,
		BarShowFactionName = false,
		BarShowRestedValue = false,
		BarShowRestedPerc  = false,
		BarAbbreviations   = false,
	}
}

local strata = {
	opt2val = 
	{
		[1] = "BACKGROUND", 
		[2] = "LOW", 
		[3] = "MEDIUM", 
		[4] = "HIGH", 
		[5] = "DIALOG", 
		[6] = "FULLSCREEN", 
		[7] = "FULLSCREEN_DIALOG", 
		[8] = "TOOLTIP" 
	},
	val2opt = 
	{
		BACKGROUND        = 1, 
		LOW               = 2, 
		MEDIUM            = 3, 
		HIGH              = 4, 
		DIALOG            = 5, 
		FULLSCREEN        = 6, 
		FULLSCREEN_DIALOG = 7, 
		TOOLTIP           = 8, 
	},
}

-- bookkeeping for show text
-- (needed to achieve ordered combobox, named option value and translated display value)
local showtext = {
	val2txt = {
		None     = L["None"], 
		XP       = L["XP"], 
		KTL      = L["Kills to Level"],
		TTL      = L["Time to Level"], 
		Rep      = L["Rep"], 
		TTLRep   = L["Time to Level Rep"],
		XPFirst  = L["XP over Rep"], 
		RepFirst = L["Rep over XP"], 
	},
	opt2txt = {
		[1]  = L["None"], 
		[2]  = L["XP"], 
		[3]  = L["Kills to Level"],
		[4]  = L["Time to Level"], 
		[5]  = L["Rep"], 
		[6]  = L["Time to Level Rep"], 
		[7]  = L["XP over Rep"], 
		[8]  = L["Rep over XP"], 
	},
	opt2val = {
		[1]  = "None", 
		[2]  = "XP", 
		[3]  = "KTL",
		[4]  = "TTL", 
		[5]  = "Rep", 
		[6]  = "TTLRep", 
		[7]  = "XPFirst", 
		[8]  = "RepFirst", 
	},
	val2opt = {
		None     = 1, 
		XP       = 2, 
		KTL      = 3,
		TTL      = 4, 
		Rep      = 5, 
		TTLRep   = 6, 
		XPFirst  = 7, 
		RepFirst = 8, 
	}
}

-- cache faction info
local lookupOptIndexToFaction = {}
local lookupFactionToOptIndex = {}

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
            Addon:Output(L["This frame has no global name and cannot be used"])
        else
        	Options:SetSetting("Frame", name)
        	AceConfigReg:NotifyChange(Addon.FULLNAME)
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

-- ticks
local tickSelection = {0, 1, 2, 3, 4, 9, 19}

local tickConfig = {}

do
	for _, ticks in pairs(tickSelection) do
		tickConfig[ticks] = NS:Colorize("Yellow", string.format("%i: ", ticks)) .. NS:Colorize("Blueish", string.format("%.4g%% ", 100/(ticks+1))) .. L["per Tick"]
	end
end

-- module handling
function Options:OnInitialize()
	-- options
	self.options = {}
	
	-- options
	self.db = LibStub:GetLibrary("AceDB-3.0"):New(Addon.MODNAME.."_DB", defaults, "Default")
		
	self:Setup()
		
	-- profile support
	self.options.args.profile = LibStub:GetLibrary("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied",  "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset",   "OnProfileChanged")

	AceConfigReg:RegisterOptionsTable(Addon.FULLNAME, self.options)
	AceConfigDialog:AddToBlizOptions(Addon.FULLNAME)
end

function Options:OnEnable()
	-- empty
end

function Options:OnDisable()
	-- empty
end

function Options:OnProfileChanged(event, database, newProfileKey)
	self.db.profile = database.profile
	
	Addon:OnOptionsReloaded()
end

function Options:Setup()
	self.options = {
		type = 'group',
		args = {
			bars = {
				type = 'group',
				name = L["Bar Properties"],
				desc = L["Set the Bar Properties"],
				order = 1,
				args = {
					spark = {
						type = 'range',
						name = L["Spark intensity"],
						desc = L["Brightness level of Spark"],
						get = function() return self:GetSetting("Spark") end,
						set = function(info, value) 
							self:SetSetting("Spark", value)
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
						get = function() return self:GetSetting("Thickness") end,
						set = function(info, value)
							self:SetSetting("Thickness", value)
						end,
						min = 1.5,
						max = 32,
						step = 0.1,
						order = 2,
					},
					showxp = {
						type = 'toggle',
						name = L["Show XP Bar"],
						desc = L["Show the XP Bar"],
						get = function() return self:GetSetting("ShowXP") end,
						set = function()
							self:ToggleSetting("ShowXP")
						end,
						order = 3,
					},
					showrep = {
						type = 'toggle',
						name = L["Show Reputation Bar"],
						desc = L["Show the Reputation Bar"],
						get = function() return self:GetSetting("ShowRep") end,
						set = function()
							self:ToggleSetting("ShowRep")
						end,
						order = 4,
					},
					shadow = {
						type = 'toggle',
						name = L["Shadow"],
						desc = L["Toggle Shadow"],
						get = function() return self:GetSetting("Shadow") end,
						set = function()
							self:ToggleSetting("Shadow")
						end,
						order = 5,
					},
					inverse = {
						type = 'toggle',
						name = L["Inverse Order"],
						desc = L["Place reputation bar before XP bar"],
						get = function() return self:GetSetting("Inverse") end,
						set = function()
							self:ToggleSetting("Inverse")
						end,
						order = 6,
					},
					external = {
						type = 'toggle',
						name = L["Other Texture"],
						desc = L["Use external texture for bar instead of the one provided with the addon"],
						get = function() return self:GetSetting("ExternalTexture") end,
						set = function()
							self:ToggleSetting("ExternalTexture")
						end,
						hidden = function(info)
							return not LibSharedMedia
						end,
						order = 7,
					},
					texture = {
						type = 'select',
						name = L["Bar Texture"],
						desc = L["Texture of the bars."] .. "\n" .. L["If you want more textures, you should install the addon 'SharedMedia'."],
						get = function() return self:GetSetting("Texture") end,
						set = function(info, value)
							self:SetSetting("Texture", value)
						end,
						values = function(info)
							return LibSharedMedia:HashTable("statusbar")
						end,
						hidden = function(info)
							return not LibSharedMedia
						end,
						disabled = function(info)
							return not self:GetSetting("ExternalTexture")
						end,
						dialogControl = AceGUI.WidgetRegistry["LSM30_Statusbar"] and "LSM30_Statusbar" or nil,
						order = 8,
					},
					ticks = {
						type = 'select',
						name = L["Ticks"],
						desc = L["Set number of ticks shown on the bar."],
						get = function() return self:GetSetting("Ticks") end,
						set = function(info, key)
							self:SetSetting("Ticks", key)
						end,
						values = tickConfig,
						order = 9,
					},
					frame = {
						type = 'group',
						name = L["Frame"],
						desc = L["Frame Connection Properties"],
						order = 1,
						args = {
							attached = {
								type = "input",
								name = L["Frame to attach to"],
								desc = L["The exact name of the frame to attach to"],
								get = function()
										return self:GetSetting("Frame")
									end,
								set = function(info, value)
									self:SetSetting("Frame", value)
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
										return self:GetSetting("Location")
									end,
								set = function(info, value)
									self:SetSetting("Location", value)
								end,
								values = { Top = L["Top"], Bottom = L["Bottom"], Left = L["Left"], Right = L["Right"] },
								order = 3,
							},
							strata = {
								type = "select", 
								name = L["Strata"],
								desc = L["Select the strata of the bars"],
								get = function() return strata.val2opt[self:GetSetting("Strata")] end,
								set = function(info, value)
									self:SetSetting("Strata", strata.opt2val[value] or "BACKGROUND")
								end,
								values = strata.opt2val,
								order = 4,
							},
							xoffset = {
								type = 'range',
								name = L["X-Offset"],
								desc = L["Set x-Offset of the bars"],
								get = function() return self:GetSetting("xOffset") end,
								set = function(info, value)
									self:SetSetting("xOffset", value)
								end,
								min = -250,
								max =  250,
								step = 1,
								order = 5,
							},
							yoffset = {
								type = 'range',
								name = L["Y-Offset"],
								desc = L["Set y-Offset of the bars"],
								get = function() return self:GetSetting("yOffset") end,
								set = function(info, value)
									self:SetSetting("yOffset", value)
								end,
								min = -250,
								max =  250,
								step = 1,
								order = 6,
							},
							inside = {
								type = 'toggle',
								name = L["Inside"],
								desc = L["Attach bars to the inside of the frame"],
								get = function() return self:GetSetting("Inside") end,
								set = function()
									self:ToggleSetting("Inside")
								end,
								order = 7,
							},
							jostle = {
								type = 'toggle',
								name = L["Jostle"],
								desc = L["Jostle Blizzard Frames"],
								get = function() return self:GetSetting("Jostle") end,
								set = function()
									self:ToggleSetting("Jostle")
								end,
								order = 8,
							},
							refresh = {
								type = 'execute',
								name = L["Refresh"],
								desc = L["Refresh Bar Position"],
								func = function() 
									local Bar = Addon:GetModule("Bar")
									
									if Bar then
										Bar:Reanchor() 
									end
								end,
								order = 9,
							},
						},
					},
					colors = {
						type = 'group',
						name = L["Colors"],
						desc = L["Set the Bar Colors"],
						order = 2,
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
									self:SetColor("XP", r, g, b, a)
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
									self:SetColor("Rest", r, g, b, a)
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
									self:SetColor("None", r, g, b, a)
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
									self:SetColor("NoRep", r, g, b, a)
								end,
								order = 5,
							},
							blizzrep = {
								type = 'toggle',
								name = L["Blizzard Rep Colors"],
								desc = L["Toggle Blizzard Reputation Colors"],
								get = function() return self:GetSetting("BlizzRep") end,
								set = function()
									self:ToggleSetting("BlizzRep")
								end,
								order = 6,
							},
						},
					},
					bartext = {
						type = 'group',
						name = L["Bar Text"],
						desc = L["Display settings for bar text."],
						order = 3,
						args = {
							text = {
								type = 'toggle',
								name = L["Show Bar Text"],
								desc = L["Show current progress values on bar."],
								get = function() return self:GetSetting("ShowBarText") end,
								set = function()
									self:ToggleSetting("ShowBarText")
								end,
								order = 1,
							},
							mouseover = {
								type = 'toggle',
								name = L["Mouse-Over"],
								desc = L["Show text only on mouse over bar."],
								get = function() return self:GetSetting("MouseOver") end,
								set = function()
									self:ToggleSetting("MouseOver")
								end,
								order = 2,
							},
							font = {
								type = 'select',
								name = L["Font"],
								desc = L["Font of the bar text."] .. "\n" .. L["If you want more fonts, you should install the addon 'SharedMedia'."],
								get = function() return self:GetSetting("Font") end,
								set = function(info, value)
									self:SetSetting("Font", value)
								end,
								values = function(info)
									return LibSharedMedia:HashTable("font")
								end,
								hidden = function(info)
									return not LibSharedMedia
								end,
								dialogControl = AceGUI.WidgetRegistry["LSM30_Font"] and "LSM30_Font" or nil,
								order = 3,
							},
							fontsize = {
								type = 'range',
								name = L["Font Size"],
								desc = L["The font size of the text."],
								get = function() return self:GetSetting("FontSize") end,
								set = function(info, value)
									self:SetSetting("FontSize", value)
								end,
								min = 2,
								max = 32,
								step = 1,
								order = 4,
							},
							togo = {
								type = 'toggle',
								name = L["XP/Rep to go"],
								desc = L["Show XP/Rep to go in bar text"],
								get  = function() return self:GetSetting("BarToGo") end,
								set  = function()
									self:ToggleSetting("BarToGo") 
								end,
								order = 5,
							},
							faction = {
								type = 'toggle',
								name = L["Show faction name"],
								desc = L["Show faction name in bar text."],
								get  = function() return self:GetSetting("BarShowFactionName") end,
								set  = function()
									self:ToggleSetting("BarShowFactionName") 
								end,
								order = 6,
							},
							values = {
								type = 'toggle',
								name = L["Show Values"],
								desc = L["Show values in bar text"],
								get  = function() return self:GetSetting("BarShowValues") end,
								set  = function()
									self:ToggleSetting("BarShowValues") 
								end,
								order = 7,
							},
							perc = {
								type = 'toggle',
								name = L["Show Percentage"],
								desc = L["Show percentage in bar text"],
								get  = function() return self:GetSetting("BarShowPercentage") end,
								set  = function()
									self:ToggleSetting("BarShowPercentage") 
								end,
								order = 8,
							},
							rested = {
								type = 'toggle',
								name = L["Show Rested"],
								desc = L["Show rested value in bar text"],
								get  = function() return self:GetSetting("BarShowRestedValue") end,
								set  = function()
									self:ToggleSetting("BarShowRestedValue") 
								end,
								order = 9,
							},
							restperc = {
								type = 'toggle',
								name = L["Show Rested %"],
								desc = L["Show rested percentage in bar text"],
								get  = function() return self:GetSetting("BarShowRestedPerc") end,
								set  = function()
									self:ToggleSetting("BarShowRestedPerc") 
								end,
								order = 10,
							},
							abbreviations = {
								type = 'toggle',
								name = L["Abbreviations"],
								desc = L["Use abbreviations to shorten numbers"],
								get  = function() return self:GetSetting("BarAbbreviations") end,
								set  = function()
									self:ToggleSetting("BarAbbreviations") 
								end,
								order = 11,
							},
						},
					},
				},
			},
			label = {
				type = 'group',
				name = L["Broker Label"],
				desc = L["Broker Label Properties"],
				order = 2,
				args = {
					showtext = {
						type = "select", 
						name = L["Select Label Text"],
						desc = L["Select label text for Broker display"],
						get  = function() 
							return showtext.val2opt[self:GetSetting("ShowText")]
						end,
						set  = function(info, value)
							self:SetSetting("ShowText", showtext.opt2val[value])
						end,
						values = showtext.opt2txt,
						order = 1,
					},
					togo = {
						type = 'toggle',
						name = L["XP/Rep to go"],
						desc = L["Show XP/Rep to go in label"],
						get  = function() return self:GetSetting("ToGo") end,
						set  = function()
							self:ToggleSetting("ToGo") 
						end,
						order = 2,
					},
					faction = {
						type = 'toggle',
						name = L["Show faction name"],
						desc = L["Show faction name when reputation is selected as label text."],
						get  = function() return self:GetSetting("ShowFactionName") end,
						set  = function()
							self:ToggleSetting("ShowFactionName") 
						end,
						order = 3,
					},
					values = {
						type = 'toggle',
						name = L["Show Values"],
						desc = L["Show values in label text"],
						get  = function() return self:GetSetting("ShowValues") end,
						set  = function()
							self:ToggleSetting("ShowValues") 
						end,
						order = 4,
					},
					perc = {
						type = 'toggle',
						name = L["Show Percentage"],
						desc = L["Show percentage in label text"],
						get  = function() return self:GetSetting("ShowPercentage") end,
						set  = function()
							self:ToggleSetting("ShowPercentage") 
						end,
						order = 5,
					},
					rested = {
						type = 'toggle',
						name = L["Show Rested"],
						desc = L["Show rested value in label text"],
						get  = function() return self:GetSetting("ShowRestedValue") end,
						set  = function()
							self:ToggleSetting("ShowRestedValue") 
						end,
						order = 6,
					},
					restperc = {
						type = 'toggle',
						name = L["Show Rested %"],
						desc = L["Show rested percentage in label text"],
						get  = function() return self:GetSetting("ShowRestedPerc") end,
						set  = function()
							self:ToggleSetting("ShowRestedPerc") 
						end,
						order = 7,
					},
					colored = {
						type = 'toggle',
						name = L["Colored Label"],
						desc = L["Color label text based on percentages"],
						get  = function() return self:GetSetting("ColoredText") end,
						set  = function()
							self:ToggleSetting("ColoredText") 
						end,
						order = 8,
					},
					abbreviations = {
						type = 'toggle',
						name = L["Abbreviations"],
						desc = L["Use abbreviations to shorten numbers"],
						get  = function() return self:GetSetting("Abbreviations") end,
						set  = function()
							self:ToggleSetting("Abbreviations") 
						end,
						order = 10,
					},
				},
			},
			tooltip = {
				type = 'group',
				name = L["Tooltip"],
				desc = L["Tooltip Properties"],
				order = 3,
				args = {
					tooltipabbrev = {
						type = 'toggle',
						name = L["Abbreviations"],
						desc = L["Use abbreviations to shorten numbers"],
						get  = function() return self:GetSetting("TTAbbreviations") end,
						set  = function()
							self:ToggleSetting("TTAbbreviations")
						end,
						order = 1,
					},
				},
			},
			numbers = {
				type = 'group',
				name = L["Numbers"],
				desc = L["General settings for number formatting"],
				order = 4,
				args = {
					separators = {
						type = 'toggle',
						name = L["Separators"],
						desc = L["Use separators for numbers to improve readability"],
						get  = function() return self:GetSetting("Separators") end,
						set  = function()
							self:ToggleSetting("Separators") 
						end,
						order = 1,
					},
					decimalplaces = {
						type = 'select',
						name = L["Decimal Places"],
						desc = L["Number of decimal places when using abbreviations"],
						get  = function() return self:GetSetting("DecimalPlaces") end,
						set  = function(info, value)
							self:SetSetting("DecimalPlaces", value) 
						end,
						values = { [0] = "0", [1] = "1", [2] = "2", [3] = "3" },
						order = 2,
					},
				},
			},
			autotrack = {
				type = 'group',
				name = L["Faction Tracking"],
				desc = L["Auto-switch watched faction on reputation gains/losses."],
				order = 5,
				args = {
					gain = {
						type = 'toggle',
						name = L["Switch on rep gain"],
						desc = L["Auto-switch watched faction on reputation gain."],
						get  = function() return self:GetSetting("AutoTrackOnGain") end,
						set  = function()
							self:ToggleSetting("AutoTrackOnGain")
						end,
						order = 1,
					},
					loss = {
						type = 'toggle',
						name = L["Switch on rep loss"],
						desc = L["Auto-switch watched faction on reputation loss."],
						get  = function() return self:GetSetting("AutoTrackOnLoss") end,
						set  = function()
							self:ToggleSetting("AutoTrackOnLoss") 
						end,
						order = 2,
					},
				},
			},
			level = {
				type = 'group',
				name = L["Leveling"],
				desc = L["Leveling Properties"],
				order = 6,
				args = {
					timeframe = {
						type = 'range',
						name = L["Time Frame"],
						desc = L["Time frame for dynamic TTL calculation."],
						get = function() return self:GetSetting("TimeFrame") end,
						set = function(info, value) 
							self:SetSetting("TimeFrame", value)
						end,
						min = 0,
						max = 120,
						step = 1,
						order = 1,
					},
					weight = {
						type = 'range',
						name = L["Weight"],
						desc = L["Weight time frame vs. session average for dynamic TTL calculation."],
						get = function() return self:GetSetting("Weight") end,
						set = function(info, value) 
							self:SetSetting("Weight", value)
						end,
						min = 0,
						max = 1,
						step = 0.01,
						order = 2,
					},
				},
			},
			maxlvl = {
				type = 'group',
				name = L["Max. XP/Rep"],
				desc = L["Display settings at maximum level/reputation"],
				order = 7,
				args = {
					hidexptxt = {
						type = 'toggle',
						name = L["No XP label"],
						desc = L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."],
						get  = function() return self:GetSetting("MaxHideXPText") end,
						set  = function()
							self:ToggleSetting("MaxHideXPText")
						end,
						order = 1,
					},
					hidexpbar = {
						type = 'toggle',
						name = L["No XP bar"],
						desc = L["Don't show XP bar at maximum level."],
						get  = function() return self:GetSetting("MaxHideXPBar") end,
						set  = function()
							self:ToggleSetting("MaxHideXPBar")
						end,
						order = 2,
					},
					hidereptxt = {
						type = 'toggle',
						name = L["No Rep label"],
						desc = L["Don't show label text at maximum Reputation. Affects Rep option only."],
						get  = function() return self:GetSetting("MaxHideRepText") end,
						set  = function()
							self:ToggleSetting("MaxHideRepText")
						end,
						order = 3,
					},
					hiderepbar = {
						type = 'toggle',
						name = L["No Rep bar"],
						desc = L["Don't show Rep bar at maximum Reputation."],
						get  = function() return self:GetSetting("MaxHideRepBar") end,
						set  = function()
							self:ToggleSetting("MaxHideRepBar")
						end,
						order = 4,
					},
				},
			},
			faction = {
				type = "select", 
				name = L["Faction"],
				desc = L["Select Faction"],
				get = function()
					return lookupFactionToOptIndex[Addon:GetFaction()] or 1
				end,
				set = function(info, key)
					Addon:SetFaction(lookupOptIndexToFaction[key] or 0)
				end,
				handler = self,
				values = "QueryFactions", 
				order = 1,
			},
			blizzbars = {
				type = 'toggle',
				name = L["Blizzard Bars"],
				desc = L["Show default Blizzard Bars"],
				get  = function() return self:GetSetting("ShowBlizzBars") end,
				set  = function()
					self:ToggleSetting("ShowBlizzBars") 
				end,
				order = 2,
			},
			minimap = {
				type = 'toggle',
				name = L["Minimap Button"],
				desc = L["Show Minimap Button"],
				get  = function() return self:GetSetting("Minimap") end,
				set  = function()
					self:ToggleSetting("Minimap")
				end,
				order = 3,
			},
			hint = {
				type = 'toggle',
				name = L["Hide Hint"],
				desc = L["Hide usage hint in tooltip"],
				get  = function() return self:GetSetting("HideHint") end,
				set  = function()
					self:ToggleSetting("HideHint")
				end,
				order = 4,
			},
		}
	}

end

function Options:Update()
	AceConfigReg:NotifyChange(Addon.FULLNAME)
end

-- faction helper
function Options:QueryFactions()
	local Factions = Addon:GetModule("Factions")
	
	local factionTable = {}
	local sortingTable = {}

	-- reset lookup table
	NS:ClearTable(lookupOptIndexToFaction)
	NS:ClearTable(lookupFactionToOptIndex)
	
	for index, factionID in Factions:IterateAllFactions() do
		if factionID then
			local name, _, standing, _, _ , _ ,_ , _, isHeader, _, hasRep, _, _, _, friendID = Factions:GetFactionInfo(factionID)
			
			if not isHeader or hasRep then
				local r, g, b = Addon:GetBlizzardReputationColor(standing, friendID)
				
				tinsert(sortingTable, {factionID, name, "|cff"..string.format("%02x%02x%02x", r*255, g*255, b*255)..name.."|r"})
			end
		end
	end
	
	Factions:RestoreUI()
	
	-- sort by name
	table.sort(sortingTable, function(a, b) return a[2]<b[2] end)
	
	-- insert nil
	tinsert(sortingTable, 1, {0, L["None"], L["None"]})
	
	for k, v in pairs(sortingTable) do
		tinsert(factionTable, v[3])
		lookupOptIndexToFaction[#factionTable] = v[1]
		lookupFactionToOptIndex[v[1]]          = #factionTable
	end

	return factionTable
end

-- option getter / setter
function Options:GetSetting(option)
	return self.db.profile[option]
end

function Options:SetSetting(option, value)
	local current = self:GetSetting(option)

	if current == value then
		return
	end
	
	self.db.profile[option] = value

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", option, value, current)
end

function Options:ToggleSetting(option)
	self:SetSetting(option, not self:GetSetting(option) and true or false)
end

function Options:ToggleSettingTrueNil(option)
	self:SetSetting(option, not self:GetSetting(option) and true or nil)
end

function Options:GetColor(id)
	local color = self.db.profile[id] or BLACK

	return color.r, color.g, color.b, color.a
end

function Options:SetColor(id, r, g, b, a)
	if not self.db.profile[id] then
		return
	end

	local current = {r = self.db.profile[id].r, g = self.db.profile[id].g, b = self.db.profile[id].b, a = self.db.profile[id].a}
	local value   = {r = r, g = g, b = b, a = a}
	
	self.db.profile[id].r = r
	self.db.profile[id].g = g
	self.db.profile[id].b = b
	self.db.profile[id].a = a
	
	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", id, value, current)
end

-- test
function Options:Debug(msg)
	Addon:Debug("(Options) " .. tostring(msg))
end
