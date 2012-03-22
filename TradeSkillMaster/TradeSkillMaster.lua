-- This is the main TSM file that holds the majority of the APIs that modules will use.

-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster", "AceEvent-3.0", "AceConsole-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table
TSM.version = GetAddOnMetadata("TradeSkillMaster","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster", "Version") -- current version of the addon
TSM.versionKey = 2


TSM.FRAME_WIDTH = 780 -- width of the entire frame
TSM.FRAME_HEIGHT = 700 -- height of the entire frame
local TREE_WIDTH = 150 -- the width of the tree part of the options frame

TSMAPI = {}
local lib = TSMAPI
local private = {slashCommands={}, modData={}, currentIcon=0}
TSM.registeredModules = {}

local savedDBDefaults = {
	profile = {
		minimapIcon = { -- minimap icon position and visibility
			hide = false,
			minimapPos = 220,
			radius = 80,
		},
		infoMessage = 0,
		pricePerUnit = false,
		frameBackdropColor = {r=0, g=0, b=0.05, a=1},
		frameBorderColor = {r=0, g=0, b=1, a=1},
		auctionButtonColors = {
			feature = {
				{r=0.2, g=0.2, b=0.2, a=1}, -- button color
				{r=0.4, g=0.4, b=0.4, a=0.4}, -- highlight color
				{r=0.9, g=0.9, b=0.95, a=1}, -- text color
			},
			control = {
				{r=0.4, g=0.32, b=0.4, a=1}, -- button color
				{r=0.4, g=0.4, b=0.4, a=0.4}, -- highlight color
				{r=0.9, g=0.9, b=0.95, a=1}, -- text color
			},
			action = {
				{r=0.2, g=0.32, b=0.4, a=1}, -- button color
				{r=0.4, g=0.4, b=0.4, a=0.4}, -- highlight color
				{r=0.9, g=0.9, b=0.95, a=1}, -- text color
			},
			action2 = {
				{r=0.32, g=0.32, b=0.4, a=1}, -- button color
				{r=0.59, g=0.53, b=0.51, a=0.4}, -- highlight color
				{r=0.9, g=0.9, b=0.95, a=1}, -- text color
			},
		},
		isDefaultTab = true,
		auctionFrameMovable = true,
		auctionFrameScale = 1,
		showBids = false,
		detachByDefault = false,
		openAllBags = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMasterDB", savedDBDefaults, true)

	-- register the chat commands (slash commands)
	-- whenver '/tsm' or '/tradeskillmaster' is typed by the user, TSM:ChatCommand() will be called
   TSM:RegisterChatCommand("tsm", "ChatCommand")
	TSM:RegisterChatCommand("tradeskillmaster", "ChatCommand")
	
	-- embed LibAuctionScan into TSMAPI
	LibStub("LibAuctionScan-1.0"):Embed(lib)
	
	-- create / register the minimap button
	TSM.LDBIcon = LibStub("LibDataBroker-1.1", true) and LibStub("LibDBIcon-1.0", true)
	local TradeSkillMasterLauncher = LibStub("LibDataBroker-1.1", true):NewDataObject("TradeSkillMasterMinimapIcon", {
		icon = "Interface\\Addons\\TradeSkillMaster\\TSM_Icon",
		OnClick = function(_, button) -- fires when a user clicks on the minimap icon
				if button == "LeftButton" then
					-- does the same thing as typing '/tsm'
					TSM:ChatCommand("")
				end
			end,
		OnTooltipShow = function(tt) -- tooltip that shows when you hover over the minimap icon
				local cs = "|cffffffcc"
				local ce = "|r"
				tt:AddLine("TradeSkillMaster " .. TSM.version)
				tt:AddLine(format(L["%sLeft-Click%s to open the main window"], cs, ce))
				tt:AddLine(format(L["%sDrag%s to move this button"], cs, ce))
			end,
		})
	TSM.LDBIcon:Register("TradeSkillMaster", TradeSkillMasterLauncher, TSM.db.profile.minimapIcon)
	local TradeSkillMasterLauncher2 = LibStub("LibDataBroker-1.1", true):NewDataObject("TradeSkillMaster", {
		type = "launcher",
		icon = "Interface\\Addons\\TradeSkillMaster\\TSM_Icon2",
		OnClick = function(_, button) -- fires when a user clicks on the minimap icon
				if button == "LeftButton" then
					-- does the same thing as typing '/tsm'
					TSM:ChatCommand("")
				end
			end,
		OnTooltipShow = function(tt) -- tooltip that shows when you hover over the minimap icon
				local cs = "|cffffffcc"
				local ce = "|r"
				tt:AddLine("TradeSkillMaster " .. TSM.version)
				tt:AddLine(format(L["%sLeft-Click%s to open the main window"], cs, ce))
				tt:AddLine(format(L["%sDrag%s to move this button"], cs, ce))
			end,
		})
	
	TSM:CreateMainFrame()
	lib:RegisterReleasedModule("TradeSkillMaster", TSM.version, GetAddOnMetadata("TradeSkillMaster", "Author"), L["Provides the main central frame as well as APIs for all TSM modules."], TSM.versionKey)
	lib:RegisterIcon(L["Status"], "Interface\\Icons\\Achievement_Quests_Completed_04", function(...) TSM:LoadOptions(...) end, "TradeSkillMaster", "options")

	TSM:InitializeTooltip()
end

function TSM:OnEnable()
	lib:CreateTimeDelay("noModules", 3, function()
			if #TSM.registeredModules == 1 then
				StaticPopupDialogs["TSMInfoPopup"] = {
					text = L["|cffffff00Important Note:|rYou do not currently have any modules installed / enabled for TradeSkillMaster! |cff77ccffYou must download modules for TradeSkillMaster to have some useful functionality!|r\n\nPlease visit http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx and check the project description for links to download modules."],
					button1 = L["I'll Go There Now!"],
					timeout = 0,
					whileDead = true,
					OnAccept = function() TSM:Print(L["Just incase you didn't read this the first time:"]) TSM:Print(L["|cffffff00Important Note:|r You do not currently have any modules installed / enabled for TradeSkillMaster! |cff77ccffYou must download modules for TradeSkillMaster to have some useful functionality!|r\n\nPlease visit http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx and check the project description for links to download modules."]) end,
				}
				lib:ShowStaticPopupDialog("TSMInfoPopup")
			elseif select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 then
				StaticPopupDialogs["TSMInfoPopup"] = {
					text = "|cffffff00Important Note:|r TSM_Gathering has been replaced by the ItemTracker and Warehousing modules (downloadable from curse). Gathering should be uninstalled immediately to avoid errors.",
					button1 = L["Thanks!"],
					timeout = 0,
					whileDead = true,
					OnAccept = function() TSM:Print(L["Just incase you didn't read this the first time:"]) TSM:Print("|cffffff00Important Note:|r TSM_Gathering has been replaced by the ItemTracker and Warehousing modules (downloadable from curse). Gathering should be uninstalled immediately to avoid errors.") end,
				}
				lib:ShowStaticPopupDialog("TSMInfoPopup")
			elseif TSM.db.profile.infoMessage < 10 then
				TSM.db.profile.infoMessage = 10
				StaticPopupDialogs["TSMInfoPopup"] = {
					text = L["Welcome to the release version of TradeSkillMaster!\n\nIf you ever need help with TSM, check out the resources listed on the first page of the main TSM window (type /tsm or click the minimap icon)!"],
					button1 = L["Thanks!"],
					timeout = 0,
					whileDead = true,
				}
				lib:ShowStaticPopupDialog("TSMInfoPopup")
			end
		end)
end

-- deals with slash commands
function TSM:ChatCommand(oInput)
	local input, extraValue
	local sStart, sEnd = strfind(oInput, "  ")
	if sStart and sEnd then
		input = strsub(oInput, 1, sStart-1)
		extraValue = strsub(oInput, sEnd+1)
	else
		local inputs = {strsplit(" ", oInput)}
		input = inputs[1]
		extraValue = inputs[2]
		for i=3, #(inputs) do
			extraValue = extraValue .. " " .. inputs[i]
		end
	end
	
	if input == "" then	-- '/tsm' opens up the main window to the status page
		TSM.Frame:Show()
		if #TSM.Frame.children > 0 then
			TSM.Frame:ReleaseChildren()
		end
		TSM:SelectInitialIcon()
		TSM:BuildIcons()
		lib:SetStatusText("")
	else -- go through our Module-specific commands
		local found=false
		for _,v in ipairs(private.slashCommands) do
			if input == v.cmd then
				found = true
				v.loadFunc(self, extraValue)
			end
		end
		if not found then
			TSM:Print(L["Slash Commands:"])
			print("|cffffaa00"..L["/tsm|r - opens the main TSM window."])
			print("|cffffaa00"..L["/tsm help|r - Shows this help listing"])
			
			for _,v in ipairs(private.slashCommands) do
				print("|cffffaa00/tsm " .. v.cmd .. "|r - " .. v.desc)
			end
		end
    end
end

function lib:RegisterModule(...)
	error(format(L["Module \"%s\" is out of date. Please update."], ...), 2)
end

--- Registers a release version module with TSM. Modules are required to be registered before they can use various TSMAPI functions.
-- @param moduleName The unlocalized name of the module.
-- @param version The version of the module. This should come from the TOC file.
-- @param authors The authors who worked on this module. This should come from the TOC file.
-- @param desc A brief description of what the module does. This should come from the TOC file.
-- @param versionKey A number to be used with TSMAPI:GetVersionKey() for helping ensure backward compatibility of inter-module changes.
function lib:RegisterReleasedModule(moduleName, version, authors, desc, versionKey)
	if not (moduleName and version and authors and desc) then
		return nil, "invalid args", moduleName, version, authors, desc
	end
	
	tinsert(TSM.registeredModules, {name=moduleName, version=version, authors=authors, desc=desc, versionKey=versionKey})
end

--- Gets the version key for a specific module. This is used to help ensure backward compatibility after changes that affect other modules.
-- @param moduleName The unlocalized name of the module.
-- @return Returns the version key or nil if the module wasn't found. Returns error message as second return value on error.
function lib:GetVersionKey(moduleName)
	if not moduleName then return nil, "no module name passed" end
	for i=1, #TSM.registeredModules do
		if TSM.registeredModules[i].name == moduleName then
			return TSM.registeredModules[i].versionKey
		end
	end
end

--- Registers a slash command with TSM. This will add it to the list of '/tsm' slash commands.
-- @param cmd The desired slash command parameter (after /tsm). For example, if cmd is "hi" then the user would type "/tsm hi".
-- @param loadFunc The function called when the slash command is typed.
-- @param desc A brief description of the command that's shown when the user types "/tsm help".
-- @return Returns an error message as the second return value on error.
function lib:RegisterSlashCommand(cmd, loadFunc, desc)
	if not desc then
		desc = L["No help provided."]
	end
	
	if not loadFunc then
		return nil, "no function provided"
	elseif not cmd then
		return nil, "no command provided"
	elseif cmd=="test" or cmd=="debug" or cmd=="help" or cmd=="" then
		return nil, "reserved command provided"
	end
	
	tinsert(private.slashCommands, {cmd=cmd, loadFunc=loadFunc, desc=desc})
end

function lib:RegisterData(label, dataFunc)
	label = strlower(label)
	private.modData[label] = dataFunc
end

function lib:GetData(label, ...)
	label = strlower(label)
	if private.modData[label] then
		return private.modData[label](self, ...)
	end
	
	return nil, "no data for that label"
end

function TSM:CheckModuleName(moduleName)
	for _, module in ipairs(TSM.registeredModules) do
		if module.name == moduleName then
			return true
		end
	end
end

-- TSM:UpdateFrameColors() is defined in TSMCustomContainers.lua
function TSM:RestoreDefaultColors()
	local colorOptions = {"frameBackdropColor", "frameBorderColor", "auctionButtonColors"}
	for _, option in ipairs(colorOptions) do
		TSM.db.profile[option] = CopyTable(savedDBDefaults.profile[option])
	end
	TSM:UpdateFrameColors()
end

function lib:GetBackdropColor()
	local color = TSM.db.profile.frameBackdropColor
	return color.r, color.g, color.b, color.a
end

function lib:GetBorderColor()
	local color = TSM.db.profile.frameBorderColor
	return color.r, color.g, color.b, color.a
end

local coloredFrames = {}

function TSM:UpdateCustomFrameColors()
	for _, frame in ipairs(coloredFrames) do
		frame:SetBackdropColor(lib:GetBackdropColor())
		frame:SetBackdropBorderColor(lib:GetBorderColor())
	end
end

function lib:RegisterForColorChanges(frame)
	tinsert(coloredFrames, frame)
	frame:SetBackdropColor(lib:GetBackdropColor())
	frame:SetBackdropBorderColor(lib:GetBorderColor())
end


local itemsToCache = {}

local function UpdateCache()
	local maxIndex = min(#itemsToCache, 100)
	for i=maxIndex, 1, -1 do
		if GetItemInfo(itemsToCache[i]) then
			tremove(itemsToCache, i)
		end
	end
	
	if #itemsToCache == 0 then
		lib:CancelFrame("TSMItemInfoCache")
	end
end

function lib:GetItemInfoCache(items, isKey)
	if isKey then
		for item in pairs(items) do
			tinsert(itemsToCache, item)
		end
	else
		for _, item in ipairs(items) do
			tinsert(itemsToCache, item)
		end
	end

	if #itemsToCache > 0 then
		lib:CreateTimeDelay("TSMItemInfoCache", 1, UpdateCache, 0.2)
	end
end