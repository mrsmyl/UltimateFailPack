local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local BrokerXPBar    = _G.BrokerXPBar

-- setup libs
local AceGUI         = LibStub("AceGUI-3.0")
local AceConfigReg   = LibStub:GetLibrary("AceConfigRegistry-3.0")

local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

-- get translations
local L              = LibStub:GetLibrary("AceLocale-3.0"):GetLocale( ADDON )

-- local functions
local pairs   = pairs
local tinsert = table.insert
local tremove = table.remove

local GetNumFactions         = _G.GetNumFactions
local SetWatchedFactionIndex = _G.SetWatchedFactionIndex

local _

local function clear_table(tab)
	if tab and type(tab) == "table" then
		for k in pairs(tab) do
			tab[k] = nil
		end
	end
end

-- options
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
local lookupFactions = {}
local lookupIndexes  = {}
local lookupNames    = {}

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
            BrokerXPBar:Output(L["This frame has no global name and cannot be used"])
        else
        	BrokerXPBar:SetSetting("Frame", name)
        	AceConfigReg:NotifyChange(BrokerXPBar.FULLNAME)
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

-- handler called on update of setting
local updateHandler = {}

function BrokerXPBar:SetupOptions()
	if LibSharedMedia then
		LibSharedMedia:Register("font", self.FONT_NAME_DEFAULT, self.FONT_DEFAULT)
	end
	
	updateHandler = {
		Spark           = BrokerXPBar.UpdateBarSetting,
		Thickness       = BrokerXPBar.UpdateBarSetting,
		ShowXP          = BrokerXPBar.UpdateXPBarSetting,
		ShowRep         = BrokerXPBar.UpdateRepBarSetting,
		Shadow          = BrokerXPBar.UpdateBarSetting,
		Inverse         = BrokerXPBar.UpdateBarSetting,
		ExternalTexture = BrokerXPBar.UpdateTextureSetting,
		Texture         = BrokerXPBar.UpdateTextureSetting,
		Ticks           = BrokerXPBar.UpdateBarSetting,
		ShowBarText     = BrokerXPBar.UpdateBarTextSetting,
		BarToGo            = BrokerXPBar.UpdateBarTextSetting,
		BarShowFactionName = BrokerXPBar.UpdateBarTextSetting,
		BarShowValues      = BrokerXPBar.UpdateBarTextSetting,
		BarShowPercentage  = BrokerXPBar.UpdateBarTextSetting,
		BarShowRestedValue = BrokerXPBar.UpdateBarTextSetting,
		BarShowRestedPerc  = BrokerXPBar.UpdateBarTextSetting,
		BarAbbreviations   = BrokerXPBar.UpdateBarTextSetting,
		MouseOver       = BrokerXPBar.UpdateBarSetting,
		Font            = BrokerXPBar.UpdateBarSetting,
		FontSize        = BrokerXPBar.UpdateBarSetting,
		Frame           = BrokerXPBar.UpdateBarSetting,
		Location        = BrokerXPBar.UpdateBarSetting,
		xOffset         = BrokerXPBar.UpdateBarSetting,
		yOffset         = BrokerXPBar.UpdateBarSetting,
		Strata          = BrokerXPBar.UpdateBarSetting,
		Inside          = BrokerXPBar.UpdateBarSetting,
		Jostle          = BrokerXPBar.UpdateBarSetting,
		BlizzRep        = BrokerXPBar.UpdateRepColorSetting,
		ShowText        = BrokerXPBar.UpdateShowTextSetting,
		ToGo            = BrokerXPBar.UpdateLabelSetting,
		ShowFactionName = BrokerXPBar.UpdateLabelSetting,
		ShowValues      = BrokerXPBar.UpdateLabelSetting,
		ShowPercentage  = BrokerXPBar.UpdateLabelSetting,
		ShowRestedValue = BrokerXPBar.UpdateLabelSetting,
		ShowRestedPerc  = BrokerXPBar.UpdateLabelSetting,
		ColoredText     = BrokerXPBar.UpdateLabelSetting,
		Separators      = BrokerXPBar.UpdateLabelSetting,
		Abbreviations   = BrokerXPBar.UpdateLabelSetting,
		DecimalPlaces   = BrokerXPBar.UpdateLabelSetting,
		AutoTrackOnGain = BrokerXPBar.UpdateAutoTrackSetting,
		AutoTrackOnLoss = BrokerXPBar.UpdateAutoTrackSetting,
		TimeFrame       = BrokerXPBar.UpdateHistorySetting,
		Weight          = BrokerXPBar.UpdateHistorySetting,
		MaxHideXPText   = BrokerXPBar.UpdateLabelSetting,
		MaxHideXPBar    = BrokerXPBar.UpdateXPBarSetting,
		MaxHideRepText  = BrokerXPBar.UpdateLabelSetting,
		MaxHideRepBar   = BrokerXPBar.UpdateRepBarSetting,
		ShowBlizzBars   = BrokerXPBar.UpdateBlizzardBarsSetting,
		Minimap         = BrokerXPBar.UpdateMinimapSetting,
	}
	
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
								func = function() self.Bar:Reanchor() end,
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

-- faction helper
function BrokerXPBar:QueryFactions()
	local factionTable = {}
	local sortingTable = {}

	-- reset lookup table
	clear_table(lookupFactions)
	clear_table(lookupIndexes)
	clear_table(lookupNames)
	
	for factionIndex = 1, GetNumFactions() do
		local name, _, standing, _, _ , _ ,_ , _, isHeader, _, hasRep, _, _, _, friendID = NS:GetFactionInfo(factionIndex)
		
		if not isHeader or hasRep then
			local r, g, b = self:GetBlizzardReputationColor(standing, friendID)
			
			tinsert(sortingTable, {factionIndex, name, "|cff"..string.format("%02x%02x%02x", r*255, g*255, b*255)..name.."|r"})
			lookupNames[name] = factionIndex
		end
	end
	
	table.sort(sortingTable, function(a, b) return a[2]<b[2] end)
	
	tinsert(sortingTable, 1, {0, L["None"], L["None"]})
	
	for k, v in pairs(sortingTable) do
		tinsert(factionTable, v[3])
		lookupFactions[#factionTable] = v[1]
		lookupIndexes[v[1]] = #factionTable
	end

	return factionTable
end

function BrokerXPBar:GetFactionByName(name)
	if not lookupNames[name] then
		self:QueryFactions()
	end

	return lookupNames[name]
end

-- handling of updated settings
function BrokerXPBar:UpdateSetting(option)
	if updateHandler[option] then
		updateHandler[option](self, option)
	end
end

function BrokerXPBar:UpdateBarSetting(option)
	self.Bar:SetSetting(option, self:GetSetting(option))
end

function BrokerXPBar:UpdateXPBarSetting()
	self.Bar:SetSetting("ShowXP", self:IsBarRequired("XP"))
	
	self:UpdateBar()
end

function BrokerXPBar:UpdateRepBarSetting()
	self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))

	self:UpdateBar()
end

function BrokerXPBar:UpdateTextureSetting()
	self.Bar:SetSetting("Texture", self:GetSetting("ExternalTexture") and self:GetSetting("Texture") or nil)
end

function BrokerXPBar:UpdateBarTextSetting()
	self:UpdateBar()
end

function BrokerXPBar:UpdateRepColorSetting()
	local r, g, b, a = self:GetColor("Rep")

	if self:GetSetting("BlizzRep") then
		r, g, b, a = self:GetBlizzardReputationColor()
	end

	self.Bar:SetColor("Rep", r, g, b, a)
end

function BrokerXPBar:UpdateMinimapSetting()
	self:ShowMinimapButton(self:GetSetting("Minimap"))
end

function BrokerXPBar:UpdateLabelSetting(option)
	self:UpdateLabel()
end

function BrokerXPBar:UpdateShowTextSetting()
	self:RegisterTTL()
	
	self:UpdateLabel()
end

function BrokerXPBar:UpdateHistorySetting(option)
	if option == "TimeFrame" then
		self.History:SetTimeFrame(self:GetSetting(option) * 60)
		self.ReputationHistory:SetTimeFrame(self:GetSetting(option) * 60)
	elseif option == "Weight" then
		self.History:SetWeight(self:GetSetting(option))
		self.ReputationHistory:SetWeight(self:GetSetting(option))
	end

	self.History:Process()
	self.ReputationHistory:Process()
end

function BrokerXPBar:UpdateAutoTrackSetting(option)
	self:RegisterAutoTrack()
end

function BrokerXPBar:UpdateBlizzardBarsSetting(option)
	self:ShowBlizzardBars(self:GetSetting("ShowBlizzBars")) 
end

-- option getter / setter
function BrokerXPBar:GetSetting(option)
	return self.db.profile[option]
end

function BrokerXPBar:SetSetting(option, value)
	local current = self:GetSetting(option)

	if current == value then
		return
	end
	
	self.db.profile[option] = value

	self:UpdateSetting(option)
end

function BrokerXPBar:ToggleSetting(option)
	self:SetSetting(option, not self:GetSetting(option) and true or false)
end

function BrokerXPBar:GetFaction()
	return self.faction
end

function BrokerXPBar:SetFaction(index)
	if not index or self.faction == index then
		return
	end
	
	self.faction  = index
	self.atMaxRep = false
	
	SetWatchedFactionIndex(index)
	
	if self.faction == 0 then
		self.watchedStanding = 0
	end

	AceConfigReg:NotifyChange(self.FULLNAME)
	
	self.Bar:SetSetting("ShowRep", self:IsBarRequired("Rep"))
end

function BrokerXPBar:GetColor(id)
	local color = self.db.profile[id] or {r = 0, g = 0, b = 0, a = 0}

	return color.r, color.g, color.b, color.a
end

function BrokerXPBar:SetColor(id, r, g, b, a)
	if not self.db.profile[id] then
		return
	end

	self.db.profile[id].r = r
	self.db.profile[id].g = g
	self.db.profile[id].b = b
	self.db.profile[id].a = a
	
	if id == "Rep" and self:GetSetting("BlizzRep") then
		return
	end
	
	self.Bar:SetColor(id, r, g, b, a)
end
