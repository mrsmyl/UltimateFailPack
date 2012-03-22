-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Gathering - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_gathering.aspx   --
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
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Gathering")

local function debug(...)
	TSM:Debug(...)
end

function Config:Load(parent)
	local professions = {["Enchanting"]=L["Enchanting"], ["Inscription"]=L["Inscription"],
		["Jewelcrafting"]=L["Jewelcrafting"], ["Alchemy"]=L["Alchemy"], ["Blacksmithing"]=L["Blacksmithing"],
		["Leatherworking"]=L["Leatherworking"], ["Tailoring"]=L["Tailoring"],
		["Engineering"]=L["Engineering"], ["Cooking"]=L["Cooking"]}
	local players, crafters, guilds = {}, {}, {}
	for _, v in ipairs(TSM.Data:GetPlayers()) do
		crafters[v] = v
		players[v] = v
		if TSM.db.factionrealm.gatherPlayers[v] == nil then
			TSM.db.factionrealm.gatherPlayers[v] = true
		end
	end
	for _, v in ipairs(TSM.Data:GetGuilds()) do
		guilds[v] = v
		if TSM.db.factionrealm.gatherGuilds[v] == nil then
			TSM.db.factionrealm.gatherGuilds[v] = true
		end
	end
	
	local profession = TSM.db.factionrealm.currentProfession
	local crafter = TSM.db.factionrealm.currentCrafter
	
	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "flow",
			children = {
				{
					type = "InlineGroup",
					title = L["Gather Mats From Alts"],
					layout = "flow",
					children = {
						{
							type = "Label",
							text = L["Gathering will create a list of tasks required to collect mats you need for your craft queue from your alts, banks, and guild banks according to the settings below."],
							fullWidth = true,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "Dropdown",
							label = L["Profession to gather mats for:"],
							list = professions,
							value = profession,
							relativeWidth = 0.49,
							callback = function(self,_,value)
									self:SetValue(value)
									profession = value
									local siblings = self.parent.children
									for i, frame in ipairs(siblings) do
										if frame == self then
											siblings[i+4]:SetDisabled(not (profession and crafter))
											break
										end
									end
								end,
							tooltip = L["Specify which profession's craft queue you would like to gather mats for."],
						},
						{
							type = "Dropdown",
							label = L["Character you will craft on:"],
							list = crafters,
							value = crafter,
							relativeWidth = 0.49,
							callback = function(self,_,value)
									self:SetValue(value)
									crafter = value
									local siblings = self.parent.children
									for i, frame in ipairs(siblings) do
										if frame == self then
											siblings[i+5]:SetDisabled(not (profession and crafter))
											break
										end
									end
								end,
							tooltip = L["Specify which character you will craft on. All gathered mats will be mailed to this character."],
						},
						{
							type = "Spacer"
						},
						{
							type = "Dropdown",
							label = L["Characters (bags/banks) to gather from:"],
							multiselect = true,
							list = players,
							value = TSM.db.factionrealm.gatherPlayers,
							relativeWidth = 0.49,
							callback = function(_,_,key,value)
									TSM.db.factionrealm.gatherPlayers[key] = value
								end,
							tooltip = L["Select which characters you would like to gather mats from. This will include their bags and personal banks."],
						},
						{
							type = "Dropdown",
							label = L["Guilds (guild banks) to gather from:"],
							multiselect = true,
							list = guilds,
							value = TSM.db.factionrealm.gatherGuilds,
							relativeWidth = 0.49,
							callback = function(_,_,key,value)
									TSM.db.factionrealm.gatherGuilds[key] = value
								end,
							tooltip = L["Select which guild's guild banks you would like to gather mats from."],
						},
						{
							type = "Spacer"
						},
						{
							type = "Button",
							text = L["Start Gathering"],
							relativeWidth = 1,
							disabled = not (profession and crafter),
							callback = function() TSMAPI:CloseFrame() TSM:BuildTaskList(profession, crafter) end,
							tooltip = L["Creates a task list to gather mats according to the above settings."],
						},
					},
				},
				{
					type = "InlineGroup",
					title = L["Options"],
					layout = "flow",
					children = {
						{
							type = "Dropdown",
							label = L["Tooltip:"],
							value = TSM.db.profile.tooltip,
							list = {["hide"]=L["No Tooltip Info"], ["simple"]=L["Simple"], ["full"]=L["Full"]},
							relativeWidth = 0.49,
							callback = function(_,_,value)
									if value ~= "hide" then
										TSMAPI:RegisterTooltip("TradeSkillMaster_Gathering", function(...) return TSM:LoadTooltip(...) end)
									else
										TSMAPI:UnregisterTooltip("TradeSkillMaster_Gathering")
									end
									TSM.db.profile.tooltip = value
								end,
							tooltip = L["Here, you can choose what Gathering info, if any, to show in tooltips. \"Simple\" will show only show totals for bags/banks and for guild banks. \"Full\" will show detailed information for every character and guild."],
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
									TSM:Print(format(L["\"%s\" removed from Gathering."], value))
									self:SetValue()
								end,
							tooltip = L["If you rename / transfer / delete one of your characters, use this dropdown to remove that character from Gathering. There is no confirmation. If you accidentally delete a character that still exists, simply log onto that character to re-add it to Gathering."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(parent, page)
end