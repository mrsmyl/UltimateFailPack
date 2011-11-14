--Globals
local pairs_ = pairs
local table_insert = table.insert
local table_sort = table.sort
local table_getn = table.getn
local date_ = date

-- Isolate the environment
local folder, core = ...
setfenv(1, core)
-- local

local realmKey = GetRealmName()
local charKey = UnitName("player") .. " - " .. realmKey
local factionKey = UnitFactionGroup("player")
local factionrealmKey = factionKey .. " - " .. realmKey


local chunks = {
	year	= 60 * 60 * 24 * 365,
	month	= 60 * 60 * 24 * 30,
	week	= 60 * 60 * 24 * 7,
	day		= 60 * 60 * 24,
	hour	= 60 * 60,
	minute	= 60,
}


CoreOptionsTable = {
	name = titleFull,
	type = "group",
	childGroups = "tab",

	args = {
		core={
			name = L["Core"],
			type = "group",
			order = 1,
			args={}
		},
		PoI = {
			name = L.PoI,
			type = "group",
			order = 2,
			args={}
		}
	},
}



CoreOptionsTable.args.core.args.enable = {
	type = "toggle",	order	= 1,
	name	= L["Enable"],
	desc	= L["Enables / Disables the addon"],
	set = function(info,val) 
		if val == true then
			core:Enable()
		else
			core:Disable()
		end
	end,
	get = function(info) return core:IsEnabled() end
}

CoreOptionsTable.args.core.args.RefreshTable = {
	type = "execute",	order	= 10,
	name	= L["Show Window"],
	desc	= L["Bring up the main window."],
	func = function(info) 
		CreateOurFrames()
		displayFrame.frame:Show()
	end
}

defaultSettings.profile.relativeWhen		= true
CoreOptionsTable.args.core.args.relativeWhen = {
	name = L["Relative Date"],
	desc = L["Show how long it's been since receiving the money."],
	type = "toggle",
	order	= 11,
	set = function(info,val) 
		P.relativeWhen = val
		RefreshAllTables()
	end,
	get = function(info) return P.relativeWhen end
}


defaultSettings.profile.guildColour		= {r=0.2, g=1.0, b=0.2, a=1.0}
CoreOptionsTable.args.core.args.guildColour = {
	name = L["Guild Buyer"],	order	= 12,
	desc = L["Buyer colour if they're in your guild."],
	type = "color",
	hasAlpha	= true,
	set = function(info,r,g,b,a) 
		P.guildColour.r = r
		P.guildColour.g = g
		P.guildColour.b = b
		P.guildColour.a = a
	end,
	get = function(info) return P.guildColour.r, P.guildColour.g, P.guildColour.b, P.guildColour.a end
}


defaultSettings.profile.friendColour		= {r=0.2, g=0.4, b=1, a=1.0}
CoreOptionsTable.args.core.args.friendColour = {
	name = L["Friend Buyer"],	order	= 13,
	desc = L["Buyer name if they're in your guild."],
	type = "color",
	hasAlpha	= true,
	set = function(info,r,g,b,a) 
		P.friendColour.r = r
		P.friendColour.g = g
		P.friendColour.b = b
		P.friendColour.a = a
	end,
	get = function(info) return P.friendColour.r, P.friendColour.g, P.friendColour.b, P.friendColour.a end
}

defaultSettings.profile.PoIColour		= {r=1.0, g=0, b=0, a=1.0}
CoreOptionsTable.args.core.args.PoIColour = {
	name = L["PoI Buyer"],	order	= 14,
	desc = L["Buyer name if on People of Interest list."],
	type = "color",
	hasAlpha	= true,
	set = function(info,r,g,b,a) 
		P.PoIColour.r = r
		P.PoIColour.g = g
		P.PoIColour.b = b
		P.PoIColour.a = a
	end,
	get = function(info) return P.PoIColour.r, P.PoIColour.g, P.PoIColour.b, P.PoIColour.a end
}


defaultSettings.profile.salesMadeMessage		= true
CoreOptionsTable.args.core.args.salesMadeMessage = {
	name = L["Sales made message"],
	desc = L["Upon closing the mailbox, print how many sales you've made."],
	type = "toggle",
	order	= 15,
	set = function(info,val) 
		P.salesMadeMessage = val
	end,
	get = function(info) return P.salesMadeMessage end
}



defaultSettings.profile.filterWhen		= 0
CoreOptionsTable.args.core.args.filterWhen = {
	type = "select", order	= 20,
	name = L["Show when"],
	desc = L.fwDesc,
	values = function()
		return {
			[0]				= L["All"], 
			[chunks.hour]	= SecondsToString(chunks.hour),
			[chunks.hour*8]	= SecondsToString(chunks.hour*8),
			[chunks.day]	= SecondsToString(chunks.day),
			[chunks.day*3]	= SecondsToString(chunks.day*3),
			[chunks.week]	= SecondsToString(chunks.week),
			[chunks.month]	= SecondsToString(chunks.month),
		}
	end,
	
	set = function(info,val) 
		P.filterWhen = val
		RefreshAllTables()
	end,
	get = function(info) return P.filterWhen end
}

defaultSettings.profile.showBuyers		= 1
CoreOptionsTable.args.core.args.showBuyers = {
	type = "select", order	= 21,
	name = L["Show Buyers"],
	desc = L["Show these buyers"],
	values = {L["All"], L["Guild"], L["Friend"], L.PoI},
	
	set = function(info,val) 
		P.showBuyers = val
		RefreshAllTables()
	end,
	get = function(info) return P.showBuyers end
}


defaultSettings.profile.saveSales		= "factionrealm"
CoreOptionsTable.args.core.args.saveSales = {
	name = L["Save sales"],
	order = 22,
	desc = L["Save sales per faction-realm or per character."],
	type = "select",
	
	values = function()
		return {["factionrealm"]=L["Per faction-realm"], ["char"]=L["Per character"]}
	end,
	set = function(info,val) 
		P.saveSales = val
		
		if not db[val].sales then
			db[val].sales = {}
		end
		
		local sales = GetSalesKeys()
		if val == "char" then
			P.showSales = charKey
		else
			P.showSales = factionrealmKey
		end
		echo(L.showSalesChange:format(P.showSales))
		
		
		UpdateShownSales()
		RefreshAllTables()
	end,
	get = function(info) return P.saveSales end
}

defaultSettings.profile.showSales		= factionrealmKey
CoreOptionsTable.args.core.args.showSales = {
	name = L["Show sales"],
	order = 23,
	desc = L["Show sales saved by the 'Save sales' setting."],
	type = "select",
	
	values = function()
		local sales = GetSalesKeys()
		
		local keys = {}
		for key in pairs(sales) do 
			keys[key] = key
		end
		
		return keys
	end,
	set = function(info,val) 
		P.showSales = val
		UpdateShownSales()
		RefreshAllTables()
	end,
	get = function(info) return P.showSales end
}

--People of interest
CoreOptionsTable.args.PoI.args.whatThisDo = {
	type = "description",	order = 1,
	width = "full",
	name = L.PoIDesc,
}

tmpNewName = ""
CoreOptionsTable.args.PoI.args.inputName = {
	type = "input",	order	= 2,
	name = L["Name"],
	desc = L["Input a name"],
	set = function(info,val) 
		tmpNewName = val
	end,
	get = function(info) return tmpNewName end
}

CoreOptionsTable.args.PoI.args.addName = {
	type = "execute",	order	= 3,
	name	= L["Add Name"],
	desc	= L["Add name to list"],
	func = function(info) 
		if tmpNewName ~= "" then
			Debug("addName", tmpNewName)
			AddPoIName(tmpNewName)
			tmpNewName = ""
		end
	end
}

CoreOptionsTable.args.PoI.args.nameList = {
	type = "group",	order	= 6,
	name	= L["Names"],
	args={}
}

