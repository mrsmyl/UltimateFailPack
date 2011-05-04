--[[
Copyright (c) 2006 by Markus Inger, 2006 by Caeryn Dryad, 2007-2010 by Horacio Hoyos

This file is part of DHUD4.

    DHUD4 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    DHUD4 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DHUD4.  If not, see <http://www.gnu.org/licenses/>.
]]
local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4");
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4");
local DogTag = LibStub("LibDogTag-3.0");

local MODNAME = "DHUD4_Outer";
local DHUD4_Outer = DHUD4:NewModule(MODNAME, "AceEvent-3.0");
local VERSION = tonumber(("$Rev: 74 $"):match("%d+"));

local string_len = string.len;
local string_gsub = string.gsub;
local string_upper = string.upper;
local string_find = string.find;

local NONE = 0
local FH = 1
local FP = 2
local TOTH = 3
local TOTP = 4
local A = 5

--Fonts
local maxfont = 25
local minfont = 6

-- Local defaults
local totBar, focusBar;
local origColor = {r, g, b};
local db
local defaults = {
	profile = {
		ro = {
			track = NONE,
			barText = true,
			style = "[FractionalXP] ([PercentXP:Percent])",
			cStyle = "",
			onParty = false,
            withPet = true,
			aBarText = true,
			aStyle = "[Short([PercentThreat])] ([RawPercentThreat])",
			aCStyle = "",
			textSize = 10,
			agrostatus = true,
			threatpct = true,
			rawthreatpct = true,
			colors = {
				["0"] = {
		            f = {r=0,g=0.67,b= 0.67 },
		            h = {r=0,g=0, b=0.67 },
		            l = {r=0.67,g=0, b=0.67 }
		        },
				["1"] = {
		            f = {r=0.67,g=0, b=0 },
		            h = {r=0.67,g=0.15, b=0.15 },
		            l = { 0.67,g=0.28, b=0.28 }
		        },
				["2"] = {
		            f = {r=0.67,g= 0.27, b=0 },
		            h = {r=0.67,g= 0.27, b=0 },
		            l = {r=0.67,g= 0.27, b=0 }
		        },
		        ["3"] = {
		            f = {r=0.67,g= 0.67, b=0 },
		            h = {r=0.67,g= 0.67, b=0.15 },
		            l = {r= 0.67,g= 0.67, b=0.28 }
		        },
				["6"] = {
		            f = {r=0,g= 0.43, b=0.58 },
		            h = {r=0.15,g= 0.48, b=0.56 },
		            l = {r=0.21,g= 0.50, b=0.54 }
		        },
		        ["7"] = {
		            f = {r=0,g= 0.67, b=0 },
		            h = {r=0.67,g= 0.67, b=0 },
		            l = {r=0.67,g= 0, b=0 },
		        },
				["8"] = {
		            f = {r=0.8,g= 0.8, b=0.8 },
		            h = {r=0.73,g= 0.73, b=0.73 },
		            l = {r=0.67,g= 0.67, b=0.67 }
		        },
				agro = {
		            f = {r=0.67,g= 0, b=0 },
		            h = {r=0.67,g= 0.67, b=0 },
		            l = {r=0,g= 0.67, b=0 },
		        },
			},
		},
		lo = {
			track = NONE,
			barText = true,
			style = "[FractionalXP] ([PercentXP:Percent])",
			cStyle = "",
			onParty = false,
            withPet = true,
			aBarText = true,
			aStyle = "[Short([PercentThreat])] ([RawPercentThreat])",
			aCStyle = "",
			textSize = 10,
			agrostatus = true,
			threatpct = true,
			rawthreatpct = true,
			colors = {
				["0"] = {
		            f = {r=0,g=0.67,b= 0.67 },
		            h = {r=0,g=0, b=0.67 },
		            l = {r=0.67,g=0, b=0.67 }
		        },
				["1"] = {
		            f = {r=0.67,g=0, b=0 },
		            h = {r=0.67,g=0.15, b=0.15 },
		            l = { 0.67,g=0.28, b=0.28 }
		        },
				["2"] = {
		            f = {r=0.67,g= 0.27, b=0 },
		            h = {r=0.67,g= 0.27, b=0 },
		            l = {r=0.67,g= 0.27, b=0 }
		        },
		        ["3"] = {
		            f = {r=0.67,g= 0.67, b=0 },
		            h = {r=0.67,g= 0.67, b=0.15 },
		            l = {r= 0.67,g= 0.67, b=0.28 }
		        },
				["6"] = {
		            f = {r=0,g= 0.43, b=0.58 },
		            h = {r=0.15,g= 0.48, b=0.56 },
		            l = {r=0.21,g= 0.50, b=0.54 }
		        },
		        ["7"] = {
		            f = {r=0,g= 0.67, b=0 },
		            h = {r=0.67,g= 0.67, b=0 },
		            l = {r=0.67,g= 0, b=0 },
		        },
				["8"] = {
		            f = {r=0.8,g= 0.8, b=0.8 },
		            h = {r=0.73,g= 0.73, b=0.73 },
		            l = {r=0.67,g= 0.67, b=0.67 }
		        },
				agro = {
		            f = {r=0.67,g= 0, b=0 },
		            h = {r=0.67,g= 0.67, b=0 },
		            l = {r=0,g= 0.67, b=0 },
		        },
			},
		},
	}
}

local TRACKVALUES = {
        [NONE] = L["None"],
        [FH] = L["Focus Health"],
        [FP] = L["Focus Power"],
        [TOTH] = L["Target Of Target Health"],
        [TOTP] = L["Target Of Target Power"],
        [A] = L["Agro"]}

local THREATTAGS = {
		["[IsTanking]"] = L["Is Tanking"],
		["[Short([PercentThreat])] ([RawPercentThreat])"] = L["Pull Agro Percent (Total Agro Percent"],
		["[RawPercentThreat])"] = L["Total Agro Percent"],
		["[RawPercentThreat] = [ThreatStatus]"] = L["Total Agro Percent = Threat Status"],
		["[ThreatStatus]"] = L["Threat Status"]}

-- Functions required by the configuration options table
local OptGetter, OptSetter, ColorGetter, ColorSetter, SelectGetter, SelectSetter, agroEnabled, correctTag, noneEnabled
do
	local mod = DHUD4_Outer
	function OptGetter(info)
		local key1, key2 = info[#info-1], info[#info];
		return db[key1][key2];
	end

	function OptSetter(info, value)
		local key1, key2 = info[#info-1], info[#info];
		db[key1][key2] = value;
		mod:Refresh();
	end

	function OptGetter2(info)
		local key1, key2 = info[#info-2], info[#info];
		return db[key1][key2];
	end

	function OptSetter2(info, value)
		local key1, key2 = info[#info-2], info[#info];
		db[key1][key2] = value;
		mod:Refresh();
	end

	function SelectGetter (info, select)
        return db[select];
    end

    function SelectSetter (info, select, value)
       db[select] = value;
       mod:Refresh();
    end

    function ColorGetter (info)
        local key1, key2, key3, key4 = info[#info-3], info[#info-2], info[#info-1], info[#info];
        --DHUD4:Debug("DHUD4_Outer:ColorGetter", key1, key2, key3, key4)
		return db[key1][key2][key3][key4].r, db[key1][key2][key3][key4].g, db[key1][key2][key3][key4].b;
	end

    function ColorSetter (info, r, g, b)
        local key1, key2, key3, key4 = info[#info-3], info[#info-2], info[#info-1], info[#info];
        db[key1][key2][key3][key4].r = r;
        db[key1][key2][key3][key4].g = g;
        db[key1][key2][key3][key4].b = b;
        mod:Refresh();
    end

	function agroEnabled(info)

		local key1 = info[#info-1]
        if db[key1].track == A then
			return true;
		else
			return false;
		end
	end

	function noneEnabled(info)

		local key1 = info[#info-1];
        if db[key1].track == NONE then
			return true;
		else
			return false;
		end
	end

    function correctTag(info)

        local key1 = info[#info-1];
		if db[key1].track == FH or db[key1].track == TOTH then
			return DHUD4:GetTags("health")
		elseif db[key1].track == FP or db[key1].track == TOTP then
			return DHUD4:GetTags("power")
        else
            return {}
		end
    end
end


--Local Options
local options
local function GetOptions()
	if not options then
        --Options table
    	options = {
    		type = "group",
			name = L["The outer module manages the outer bars functionality. Track focus, target of target or agro"],
			arg = MODNAME,
            order = 2,
			get = OptGetter,
			set = OptSetter,
			--childGroups = "tab",
    		args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable Outer Module"],
                    get = function() return DHUD4:GetModuleEnabled(MODNAME) end,
                    set = function(info, value) DHUD4:SetModuleEnabled(MODNAME, value) end,
                },
				lo = {
					order = 3,
					type = 'group',
					name = L["Left Bar"],
					args = {
						track = {
                            type = "select",
                            order = 1,
                            name = L["Bar tracks"],
                            values = TRACKVALUES,
                        },
                        agrostatus = {
                            type = "toggle",
                            order = 2,
                            name = L["Agro Status"],
                            desc = L["Track your agro status by coloring the bar border"],
                            disabled = noneEnabled,
                        },
                        barText = {
                            type = 'toggle',
                            order = 3,
                            name = L["Show Bar Values"],
                            disabled = agroEnabled or noneEnabled,
                        },
                        style = {
                            type = 'select',
                            order = 4,
                            name = L["Bar Text Style"],
                            hidden = BarTextHidden,
                            values = correctTag,
                            disabled = agroEnabled or noneEnabled,
                        },
                        cStyle = {
                            type = 'input',
                            order = 5,
                            name = L["Custom Text Style"],
                            desc = L["If set this style will override Bar Text Style value. Replace H (health) and M (mana/power) on your tags by X and DHUD4 will replace it appropriately depending on the status you are tracking. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Bar Text Style setting.)"],
                            usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                            disabled = agroEnabled or noneEnabled,
                        },
                        textSize = {
                            type = 'range',
                            order = 6,
                            name = L["Font size"],
                            min = minfont,
                            max = maxfont,
                            disabled = agroEnabled or noneEnabled,
                            hidden = BarTextHidden,
                            step = 1,
                        },
						agro = {
							type = 'group',
							order = 7,
							name = L["Agro Tracking"],
                            get = OptGetter2,
                            set = OptSetter2,
							disabled = function (info)
									local key1 = info[#info-1];
									if db[key1].track == A then
										return false;
									else
										return true;
									end
								end,
							args = {
								aBarText = {
									type = 'toggle',
									order = 1,
									name = L["Show Bar Values"],
									disabled = false,
								},
								aStyle = {
									type = 'select',
									order = 2,
									name = L["Agro Text Style"],
									values = THREATTAGS,
									disabled = false,
								},
								cAStyle = {
									type = 'input',
									order = 3,
									name = L["Custom Agro Style"],
									desc = L["If set this style will override Agro Text Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Agro Text Style setting.)"],
									usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
									disabled = false,
								},
								onParty = {
									type = 'toggle',
									order = 4,
									name = L["On Party"],
									desc = L["Only track Agro while on party/raid"],
									disabled = false,
								},
                                withPet = {
									type = 'toggle',
									order = 5,
									name = L["With Pet"],
									desc = L["Track Agro while pet is active"],
									disabled = false,
								},
								threatpct = {
									type = 'toggle',
									order = 6,
									name = L["Threat Percent"],
									desc = L["Track your total threat as the percent required to pull agro"],
									disabled = false,
								},
								--rawthreatpct = {
								--	type = 'toggle',
								--	order = 7,
								--	name = L["Raw Threat Percent"],
								--	desc = L["Track your raw threat as a percent of the tank's current threat"],
								--	disabled = false,
								--},
							},
						},
						colors = {
							type = 'group',
							order = 8,
							name = L["Bar Colors"],
							get = ColorGetter,
							set = ColorSetter,
							disabled = function (info)
									local key1 = info[#info-1];
									if db[key1].track == NONE then
										return true;
									else
										return false;
									end
								end,
							args = {
								["7"] = {
									type = 'group',
									guiInline = true,
									name = L["Health"],
									order = 1,
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["0"] = {
									type = 'group',
									guiInline = true,
									name = L["Mana"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["1"] = {
									type = 'group',
									guiInline = true,
									name = L["Rage"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["3"] = {
									type = 'group',
									guiInline = true,
									name = L["Energy"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["6"] = {
									type = 'group',
									guiInline = true,
									name = L["Runic Power"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["2"] = {
									type = 'group',
									guiInline = true,
									name = L["Focus (Pet)"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["8"] = {
									type = 'group',
									guiInline  = true,
									name = L["Tapped"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								agro = {
									type = 'group',
									guiInline = true,
									name = L["Agro"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["High"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
							},
						},
					},
				},
				ro = {
					order = 4,
					type = 'group',
					name = L["Right Bar"],
					args = {
                        track = {
                            type = "select",
                            order = 1,
                            name = L["Bar tracks"],
                            values = TRACKVALUES,
                        },
                        agrostatus = {
                            type = "toggle",
                            order = 2,
                            name = L["Agro Status"],
                            desc = L["Track your agro status by coloring the bar border"],
                            disabled = noneEnabled,
                        },
                        barText = {
                            type = 'toggle',
                            order = 3,
                            name = L["Show Bar Values"],
                            disabled = agroEnabled or noneEnabled,
                        },
                        style = {
                            type = 'select',
                            order = 4,
                            name = L["Bar Text Style"],
                            hidden = BarTextHidden,
                            values = correctTag,
                            disabled = agroEnabled or noneEnabled,
                        },
                        cStyle = {
                            type = 'input',
                            order = 5,
                            name = L["Custom Text Style"],
                            desc = L["If set this style will override Bar Text Style value. Replace H (health) and M (mana/power) on your tags by X and DHUD4 will replace it appropriately depending on the status you are tracking. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Bar Text Style setting.)"],
                            usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                            disabled = agroEnabled or noneEnabled,
                        },
                        textSize = {
                            type = 'range',
                            order = 6,
                            name = L["Font size"],
                            min = minfont,
                            max = maxfont,
                            disabled = agroEnabled or noneEnabled,
                            hidden = BarTextHidden,
                            step = 1,
                        },
						agro = {
							type = 'group',
							order = 7,
							name = L["Agro Tracking"],
                            get = OptGetter2,
                            set = OptSetter2,
							disabled = function (info)
									local key1 = info[#info-1];
									if db[key1].track == A then
										return false;
									else
										return true;
									end
								end,
							args = {
								aBarText = {
									type = 'toggle',
									order = 1,
									name = L["Show Bar Values"],
									disabled = false,
								},
								aStyle = {
									type = 'select',
									order = 2,
									name = L["Agro Text Style"],
									values = THREATTAGS,
									disabled = false,
								},
								cAStyle = {
									type = 'input',
									order = 3,
									name = L["Custom Agro Style"],
									desc = L["If set this style will override Agro Text Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Agro Text Style setting.)"],
									usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
									disabled = false,
								},
								onParty = {
									type = 'toggle',
									order = 4,
									name = L["On Party"],
									desc = L["Only track Agro while on party/raid"],
									disabled = false,
								},
                                withPet = {
									type = 'toggle',
									order = 5,
									name = L["With Pet"],
									desc = L["Track Agro while pet is active"],
									disabled = false,
								},
								threatpct = {
									type = 'toggle',
									order = 6,
									name = L["Threat Percent"],
									desc = L["Track your total threat as the percent required to pull agro"],
									disabled = false,
								},
								--[[rawthreatpct = {
									type = 'toggle',
									order = 7,
									name = L["Raw Threat Percent"],
									desc = L["Track your raw threat as a percent of the tank's current threat"],
									disabled = false,
								},]]
							},
						},
						colors = {
							type = 'group',
							order = 8,
							name = L["Bar Colors"],
							get = ColorGetter,
							set = ColorSetter,
							disabled = function (info)
									local key1 = info[#info-1];
									if db[key1].track == NONE then
										return true;
									else
										return false;
									end
								end,
							args = {
								["7"] = {
									type = 'group',
									guiInline = true,
									name = L["Health"],
									order = 1,
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["0"] = {
									type = 'group',
									guiInline = true,
									name = L["Mana"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["1"] = {
									type = 'group',
									guiInline = true,
									name = L["Rage"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["3"] = {
									type = 'group',
									guiInline = true,
									name = L["Energy"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["6"] = {
									type = 'group',
									guiInline = true,
									name = L["Runic Power"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["2"] = {
									type = 'group',
									guiInline = true,
									name = L["Focus (Pet)"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								["8"] = {
									type = 'group',
									guiInline  = true,
									name = L["Tapped"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["Full"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
								agro = {
									type = 'group',
									guiInline = true,
									name = L["Agro"],
									disabled = false,
									args = {
										f = {
											type = 'color',
											name = L["High"],
											order = 1,
										},
										h = {
											type = 'color',
											name = L["Med"],
											order = 2,
										},
										l = {
											type = 'color',
											name = L["Low"],
											order = 3,
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return options;
end

-- Local functions
local PlaceBarTexts, OnBarShow, OnBarHide, SetBarText, SetBarAgro, OnPlayerFocus, OnUnitThreat
do

	function SetBarAgro(who, bar)

		_G["DHUD4_"..bar]:RegisterEvent("UNIT_TARGET");
		_G["DHUD4_"..bar]:SetScript("OnEvent", OnUnitThreat);
	end

	
end

function DHUD4_Outer:OnInitialize()

    --DHUD4:Debug("DHUD4_Player:OnInitialize");
	self.db = DHUD4.db:RegisterNamespace(MODNAME, defaults);
	db = self.db.profile;
	self:SetEnabledState(DHUD4:GetModuleEnabled(MODNAME));
	DHUD4:RegisterModuleOptions(MODNAME, GetOptions, L["Outer"]);

    -- Bars
    rightBar = DHUD4:CreateStatusBar()
    leftBar = DHUD4:CreateStatusBar()
	
end

function DHUD4_Outer:OnEnable()

    if not self:IsEnabled() then return end
	self:Refresh();
end

function DHUD4_Outer:OnDisable()

	self:UnregisterAllEvents();
    rightBar:Disable()
    leftBar:Disable()
end

function DHUD4_Outer:Refresh()

	--DHUD4:Debug(MODNAME, "Refresh");
    if not self:IsEnabled() then return end
	db = self.db.profile
	
	-- Remove all registered events and text tags
    self:UnregisterAllEvents();
    rightBar:Disable()
    rightBar.focus = false
    rightBar.tot = false
    rightBar.agro = false
    rightBar.agrostatus = false
    leftBar:Disable()
    leftBar.focus = false
    leftBar.tot = false
    leftBar.agro = false
    leftBar.agrostatus = false


    -- Right bar
    rightBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
    rightBar:InitStatusBar("fr5", DHUD4_RightFrame)
    rightBar:PlaceTextures(DHUD4:GetCurrentTexture())
    if db.ro.barText then
        rightBar:InitStatusBarText("fr5", DHUD4:GetPosition("fr5"))
    end
    rightBar:SetDisplayOptions(DHUD4:GetDisplayOptions())

	--DHUD4:Debug("Right Bar", db.ro.track);

	if db.ro.track == FH or db.ro.track == FP then
		self:RegisterEvent("PLAYER_FOCUS_CHANGED");
		rightBar.focus = true
        if db.ro.barText then
            local tagCode = (string_len(db.ro.cStyle) > 0) and db.ro.cStyle or db.ro.style
            --tagCode = string_gsub(tagCode, "X", ( (db.ro.track == FH) and "M" or "H"))
            rightBar:ConfigBarText(DHUD4:GetFont(), db.ro.textSize * DHUD4.GetScale(), tagCode, "focus")
        end
        self:PLAYER_FOCUS_CHANGED()
        if db.ro.agrostatus then
			origColor.r, origColor.g, origColor.b = rightBar.background:GetVertexColor()
            rightBar.agrostatus = true
            self:RegisterEvent("UNIT_TARGET")
		end
	elseif db.ro.track == TOTH or  db.ro.track == TOTP then
        rightBar.tot = true
        if db.ro.barText then
            local tagCode = (string_len(db.ro.cStyle) > 0) and db.ro.cStyle or db.ro.style
            --tagCode = string_gsub(tagCode, "X", ( (db.ro.track == FH) and "M" or "H"))
            rightBar:ConfigBarText(DHUD4:GetFont(), db.ro.textSize * DHUD4.GetScale(), tagCode, "targettarget")
        end
		if db.ro.agrostatus then
			origColor.r, origColor.g, origColor.b = rightBar.background:GetVertexColor();
            rightBar.agrostatus = true
		end
        self:RegisterEvent("UNIT_TARGET")
	elseif db.ro.track == A then
        rightBar.agro = true
        if db.ro.aBarText then
			local tagCode = (string_len(db.ro.aCStyle) > 0) and db.ro.aCStyle or db.ro.aStyle;
            rightBar:ConfigBarText(DHUD4:GetFont(), db.ro.textSize * DHUD4.GetScale(), tagCode, "player")
		end
		self:RegisterEvent("UNIT_TARGET")
        if (db.ro.onParty and db.ro.withPet) then
            self:RegisterEvent("PET_ATTACK_START")
        end
	end

    -- Left bar
    leftBar:SetDisplayOptions(DHUD4:GetDisplayOptions())
    leftBar:InitStatusBar("fl5", DHUD4_LeftFrame)
    leftBar:PlaceTextures(DHUD4:GetCurrentTexture())
    if db.ro.barText then
        leftBar:InitStatusBarText("fl5", DHUD4:GetPosition("fl5"))
    end
    

	--DHUD4:Debug("Right Bar", db.ro.track);

	if db.lo.track == FH or db.lo.track == FP then
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		leftBar.focus = true
        if db.lo.barText then
            local tagCode = (string_len(db.lo.cStyle) > 0) and db.lo.cStyle or db.lo.style
            --tagCode = string_gsub(tagCode, "X", ( (db.lo.track == FH) and "M" or "H"))
            leftBar:ConfigBarText(DHUD4:GetFont(), db.lo.textSize * DHUD4.GetScale(), tagCode, "focus")
        end
        self:PLAYER_FOCUS_CHANGED()
        if db.ro.agrostatus then
			--origColor.r, origColor.g, origColor.b = rightBar.background:GetVertexColor()
            leftBar.agrostatus = true
            self:RegisterEvent("UNIT_TARGET")
		end
	elseif db.lo.track == TOTH or  db.lo.track == TOTP then
        leftBar.tot = true
        if db.lo.barText then
            local tagCode = (string_len(db.lo.cStyle) > 0) and db.lo.cStyle or db.lo.style
            --tagCode = string_gsub(tagCode, "X", ( (db.lo.track == FH) and "M" or "H"))
            leftBar:ConfigBarText(DHUD4:GetFont(), db.lo.textSize * DHUD4.GetScale(), tagCode, "targettarget")
        end
		if db.lo.agrostatus then
			--origColor.r, origColor.g, origColor.b = rightBar.background:GetVertexColor();
            leftBar.agrostatus = true
		end
        self:RegisterEvent("UNIT_TARGET")
	elseif db.lo.track == A then
        leftBar.agro = true
        if db.lo.aBarText then
			local tagCode = (string_len(db.lo.aCStyle) > 0) and db.lo.aCStyle or db.lo.aStyle;
            leftBar:ConfigBarText(DHUD4:GetFont(), db.lo.textSize * DHUD4.GetScale(), tagCode, "player")
		end
		self:RegisterEvent("UNIT_TARGET")
        if (db.lo.onParty and db.lo.withPet) then
            self:RegisterEvent("PET_ATTACK_START")
            self:RegisterEvent("PET_ATTACK_STOP")
            self:RegisterEvent("UNIT_PET", "PET_ATTACK_STOP")
        end
	end
    self:UNIT_TARGET(nil, "player")

    -- Enable bar pop events
    rightBar.frame:SetScript("OnShow", function (this)
            DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
        end)
    rightBar.frame:SetScript("OnHide", function (this)
            DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
        end)
    leftBar.frame:SetScript("OnShow", function (this)
            DHUD4:SendMessage("DHUD4_BAR", this.bar, true)
        end)
    leftBar.frame:SetScript("OnHide", function (this)
            DHUD4:SendMessage("DHUD4_BAR", this.bar, false)
        end)
	

end

function DHUD4_Outer:PLAYER_FOCUS_CHANGED(event)

	--DHUD4:Debug("DHUD4_Outer", event);
    if (rightBar.focus) then
        rightBar:Disable(true)
        if (UnitExists("focus")) then
            if (db.ro.track == FH) then
                rightBar:TrackUnitHealth("focus", db.ro.colors[tostring(7)])
            elseif (db.ro.track == FP) then
                rightBar:TrackUnitPower("focus", db.ro.colors[tostring(UnitPowerType("focus"))], UnitPowerType("focus"))
            end
        end
    end
    if(leftBar.focus) then
        leftBar:Disable(true)
        if (UnitExists("focus")) then
            if (db.lo.track == FH) then
                leftBar:TrackUnitHealth("focus", db.lo.colors[tostring(7)])
            elseif (db.lo.track == FP) then
                leftBar:TrackUnitPower("focus", db.lo.colors[tostring(UnitPowerType("focus"))], UnitPowerType("focus"))
            end
        end
    end
end

function DHUD4_Outer:UNIT_TARGET(event, who)
	if (who == "target") then
		if (rightBar.tot) then
            rightBar:Disable(true)
            if (UnitExists("targettarget")) then
                if (db.ro.track == TOTH) then
                    rightBar:TrackUnitHealth("targettarget", db.ro.colors[tostring(7)])
                elseif (db.ro.track == TOTP) then
                    rightBar:TrackUnitPower("targettarget", db.ro.colors[tostring(UnitPowerType("targettarget"))], UnitPowerType("targettarget"))
                end
            end
        elseif(leftBar.tot) then
            leftBar:Disable(true)
            if (UnitExists("targettarget")) then
                if (db.lo.track == TOTH) then
                    leftBar:TrackUnitHealth("targettarget", db.lo.colors[tostring(7)])
                elseif (db.lo.track == TOTP) then
                    leftBar:TrackUnitPower("targettarget", db.lo.colors[tostring(UnitPowerType("targettarget"))], UnitPowerType("targettarget"))
                end
            end
        end
	elseif (who == "player") then
        if (rightBar.tot) then
            rightBar:Disable(true)
            if (UnitExists("targettarget")) then
                if (db.ro.track == TOTH) then
                    rightBar:TrackUnitHealth("targettarget", db.ro.colors[tostring(7)])
                elseif (db.ro.track == TOTP) then
                    rightBar:TrackUnitPower("targettarget", db.ro.colors[tostring(UnitPowerType("targettarget"))], UnitPowerType("targettarget"))
                end
            end
            if rightBar.agrostatus then
				if (UnitExists("target")) then
                    rightBar:TrackAgroStatus("player", "target")
				end
			end
        elseif (rightBar.agro) then
            if (UnitExists("target")) then
                if (db.ro.onParty and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0))) then
                    rightBar:Disable(true)
                    rightBar:TrackAgroStatus("player", "target", true, db.ro.colors.agro)
                elseif (not db.ro.onParty) then
                    rightBar:Disable(true)
                    rightBar:TrackAgroStatus("player", "target", true, db.ro.colors.agro)
                elseif (not db.ro.withPet) then
                    rightBar:Disable(true)
                end
            elseif (not db.withPet) then
                rightBar:Disable(true)
            end
        end
        if(leftBar.tot) then
            leftBar:Disable(true)
            if (UnitExists("targettarget")) then
                if (db.lo.track == TOTH) then
                    leftBar:TrackUnitHealth("targettarget", db.lo.colors[tostring(7)])
                elseif (db.lo.track == TOTP) then
                    leftBar:TrackUnitPower("targettarget", db.lo.colors[tostring(UnitPowerType("targettarget"))], UnitPowerType("targettarget"))
                end
            end
            if leftBar.agrostatus then
				if (UnitExists("target")) then
                    leftBar:TrackAgroStatus("player", "target")
				end
			end
         elseif (leftBar.agro) then
            if (UnitExists("target")) then
                if (db.lo.onParty and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0))) then
                    leftBar:Disable(true)
                    leftBar:TrackAgroStatus("player", "target", true, db.lo.colors.agro)
                elseif (not db.lo.onParty) then
                    leftBar:Disable(true)
                    leftBar:TrackAgroStatus("player", "target", true, db.lo.colors.agro)
                elseif (not db.lo.withPet) then
                    leftBar:Disable(true)
                end
            elseif (not db.lo.withPet) then
                leftBar:Disable(true)
            end
        end
	end
end

function DHUD4_Outer:PET_ATTACK_START(event)

    --DHUD4:Debug("DHUD4_Outer", event);
    if (rightBar.agro) then
        --rightBar:Disable(true)
        rightBar:TrackAgroStatus("player", "target", true, db.ro.colors.agro)
    end
    if (leftBar.agro) then
        --leftBar:Disable(true)
        leftBar:TrackAgroStatus("player", "target", true, db.lo.colors.agro)
    end
end

function DHUD4_Outer:PET_ATTACK_STOP(event, unit)

    --DHUD4:Debug("DHUD4_Outer", event);
    if ((event == "PET_ATTACK_STOP") or (unit == "player")) then
        if (rightBar.agro) then
            rightBar:Disable(true)
        end
        if (leftBar.agro) then
            leftBar:Disable(true)
        end
    end
end

function DHUD4_Outer:SetLayout()

    self.layout = true
    rightBar:SetLayout("Focus/ToT/Aggro", 100, 80)
    leftBar:SetLayout("Focus/ToT/Aggro", 100, 80)
end

function DHUD4_Outer:EndLayout()

    self.layout = false
    self:Refresh()
end