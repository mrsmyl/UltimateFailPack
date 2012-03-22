-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_ItemTracker - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/TradeSkillMaster_ItemTracker.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Config = TSM:NewModule("Config", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_ItemTracker")

function Config:Load(parent)
	local players = {}
	for _, v in ipairs(TSM.Data:GetPlayers()) do
		players[v] = v
	end
	
	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "flow",
			children = {
				{
					type = "InlineGroup",
					title = L["Options"],
					layout = "flow",
					children = {
						{
							type = "Dropdown",
							label = "Tooltip:",
							value = TSM.db.profile.tooltip,
							list = {hide=L["No Tooltip Info"], simple=L["Simple"], full=L["Full"]},
							relativeWidth = 0.49,
							callback = function(_,_,value)
									if TSM.db.profile.tooltip == "hide" and value ~= "hide" then
										TSMAPI:RegisterTooltip("TradeSkillMaster_ItemTracker", function(...) return TSM:LoadTooltip(...) end)
									elseif TSM.db.profile.tooltip ~= "hide" and value == "hide" then
										TSMAPI:UnregisterTooltip("TradeSkillMaster_ItemTracker")
									end
									TSM.db.profile.tooltip = value
								end,
							tooltip = L["Here, you can choose what ItemTracker info, if any, to show in tooltips. \"Simple\" will show only show totals for bags/banks and for guild banks. \"Full\" will show detailed information for every character and guild."],
						},
						{
							type = "Dropdown",
							label = L["Delete Character:"],
							list = players,
							relativeWidth = 0.49,
							callback = function(self,_,value)
									local charGuild = TSM.characters[value].guild
									if charGuild then
										TSM.guilds[charGuild].characters[value] = nil
										local hasMembersLeft = false
										for _ in pairs(TSM.guilds[charGuild].characters) do
											hasMembersLeft = true
											break
										end
										if not hasMembersLeft then
											TSM.guilds[charGuild] = nil
										end
									end
									
									TSM.characters[value] = nil
									TSM:Print(format(L["\"%s\" removed from ItemTracker."], value))
									players[value] = nil
									self:SetList(players)
									self:SetValue()
								end,
							tooltip = L["If you rename / transfer / delete one of your characters, use this dropdown to remove that character from ItemTracker. There is no confirmation. If you accidentally delete a character that still exists, simply log onto that character to re-add it to ItemTracker."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(parent, page)
end