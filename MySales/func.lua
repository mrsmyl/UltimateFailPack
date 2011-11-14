-- globals
local tostring_ = tostring
local table_getn = table.getn
local math_floor = math.floor
local tonumber_ = tonumber
local string_gmatch = string.gmatch
local date_ = date
local string_rep = string.rep
local math_floor = math.floor
local string_sub = string.sub
local string_len = string.len
local pairs_ = pairs
local table_sort = table.sort
local table_insert = table.insert

-- Isolate the environment
local folder, core = ...
setfenv(1, core)
-- local


local chunks = {
	year	= 60 * 60 * 24 * 365,
	month	= 60 * 60 * 24 * 30,
--~ 	week	= 60 * 60 * 24 * 7,
	day		= 60 * 60 * 24,
	hour	= 60 * 60,
	minute	= 60,
}


local strDebugFrom		= "|cffffff00[%s]|r" --Yellow function name. help pinpoint where the debug msg is from.
local strWhiteBar		= "|cffffff00 || |r" -- a white bar to seperate the debug info.
-----------------------------
function Debug(from, ...)	--	/script DA.Debug("hey","bye")
-- simple print function.	--
------------------------------
	if version ~= "" then--version's from curse, user doesn't need to see debug msgs.
		return
	end
	local tbl  = {...}
	local msg = tostring_(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring_(tbl[i])
	end
	echo(strDebugFrom:format(from).." "..msg)
end

local colouredName		= "|cff7f7f7f{|r|cffff0000MS|r|cff7f7f7f}|r "
function echo(...)
	local tbl  = {...}
	local msg = tostring_(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring_(tbl[i])
	end
	
	local cf = _G["ChatFrame1"]
	if cf then
		cf:AddMessage(colouredName..msg,.7,.7,.7)
	end
end

local iconpath = "Interface\\MoneyFrame\\UI-"
function CopperToCoins(copper)
	copper = math_floor(tonumber_(copper) or 0)
	local g = math_floor(copper / 10000)
	local s = math_floor(copper % 10000 / 100)
	local c = copper % 100

	local text = "";
	if g ==0 and s ==0 then
		text = text.."|cFFFF6600" .. c .. "|r|T"..iconpath.."CopperIcon:0|t"
	else
		if g > 0 then
			text = text.."|cFFFFFF00" .. g .. "|r|T"..iconpath.."GoldIcon:0|t"
		end
		if s > 0 then
			text = text.."|cFFCCCCCC" .. s .. "|r|T"..iconpath.."SilverIcon:0|t"
		end
		if c > 0 then
			text = text.."|cFFFF6600" .. c .. "|r|T"..iconpath.."CopperIcon:0|t"
		end
	end
	return text;
end

function DateStringToDigits(dateString)
	for m,d,y,h,mi,s in string_gmatch(dateString, "(.+)/(.+)/(.+) (.+):(.+):(.+)") do
		return tonumber_(m),tonumber_(d),tonumber_(y),tonumber_(h),tonumber_(mi),tonumber_(s);
	end
	return nil
end

function SecondsSinceDateString(dateString)
	local m,d,y,h,mi,s = DateStringToDigits(dateString)
	return m and SecondsSinceDate(m,d,y,h,mi,s) or 0
end

--~ function StringSinceDate(dateString)
--~ 	local ssd = SecondsSinceDateString(dateString)
--~ 	return SecondsToString(ssd)
--~ end

--------------------------------------------------------------------------
function DateToSeconds(oMonth, oDay, oYear, oHour, oMinute, oSecond)	--
-- Return number of seconds in a date. 									--
--------------------------------------------------------------------------
	local seconds = oYear * chunks.year
	seconds = seconds + (oMonth * chunks.month)
	seconds = seconds + (oDay * chunks.day)
	seconds = seconds + ((oHour or 0) * chunks.hour)
	seconds = seconds + ((oMinute or 0) * chunks.minute)
	seconds = seconds + (oSecond or 0)
	return seconds
end

--------------------------------------------------------------------------
function SecondsSinceDate(oMonth, oDay, oYear, oHour, oMinute, oSecond)	--
-- Returns how many seconds has past since a date.						--
--------------------------------------------------------------------------
	local orignalTime = oYear * chunks.year
	orignalTime = orignalTime + (oMonth * chunks.month)
	orignalTime = orignalTime + (oDay * chunks.day)
	orignalTime = orignalTime + ((oHour or 0) * chunks.hour)
	orignalTime = orignalTime + ((oMinute or 0) * chunks.minute)
	orignalTime = orignalTime + (oSecond or 0)
	
	local cYear, cMonth, cDay, cHour, cMinute, cSecond = date_("%y"), date_("%m"), date_("%d"), date_("%H"), date_("%M"), date_("%S");
	
	local currentTime = cYear * chunks.year
	currentTime = currentTime + (cMonth * chunks.month)
	currentTime = currentTime + (cDay * chunks.day)
	currentTime = currentTime + (cHour * chunks.hour)
	currentTime = currentTime + (cMinute * chunks.minute)
	currentTime = currentTime + cSecond
	
	local sinceTime = currentTime - orignalTime
--~ 	print(2,"orignalTime","oT: "..tostring(orignalTime)..", cT: "..tostring(currentTime)..", sT: "..tostring(sinceTime))
	return sinceTime;
end


--------------------------------------------------------------
function SecondsToString(seconds)								--
-- Returns the number of hours in a readable string format.	--
--------------------------------------------------------------
	local msg = "";
	seconds = Round(seconds);
	if seconds==0 then
		msg = "0s "
	else
		local sYear, sMonth, sDay, sHour, sMinute = 0, 0, 0, 0, 0;

		while seconds > (chunks.year - 1) do
			sYear	= sYear + 1;
			seconds	= seconds - chunks.year;
		end
		while seconds > (chunks.month - 1) do
			sMonth	= sMonth + 1;
			seconds	= seconds - chunks.month;
		end
--~ 	while seconds > (chunks.week - 1) do
--~ 		sWeek	= sWeek + 1;
--~ 		seconds	= seconds - chunks.week;
--~ 	end
		while seconds > (chunks.day - 1) do
			sDay	= sDay + 1;
			seconds	= seconds - chunks.day;
		end
	
		while seconds > (chunks.hour - 1) do
			sHour	= sHour + 1;
			seconds	= seconds - chunks.hour;
		end
		
		while seconds > (chunks.minute - 1) do
			sMinute	= sMinute + 1;
			seconds	= seconds - chunks.minute;
		end
		
		local sLenth = 0;
		if sYear > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = sYear.."y ";
		end
		if sMonth > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = msg..sMonth.."mo ";
		end
--~ 	if (sWeek > 0) then
--~ 		msg = msg..sWeek.."w ";
--~ 	end
		if sDay > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = msg..sDay.."d ";
		end
		if sHour > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = msg..sHour.."h ";
		end
		
		if sMinute > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = msg..sMinute.."m ";
		end
		
		if seconds > 0 and sLenth < 2 then
			sLenth = sLenth + 1;
			msg = msg..seconds.."s ";
		end
		
	end

	msg	= string_sub(msg,1,string_len(msg) - 1);--Remove the last space in the string.
	
	return msg;
end

------------------------------------------------------------------
function Round(num, zeros)										--
-- zeroes is the number of decimal places. eg 1=*.*, 3=*.***	--
------------------------------------------------------------------
	return math_floor( num * 10 ^ (zeros or 0) + 0.5 ) / 10 ^ (zeros or 0)
end

function AddPoIName(name)
	if not fR.PoI[name] then
		fR.PoI[name] = {}
	end
	fR.PoI[name].when = date_("%c")
	
	BuildPoIList()
end

function BuildPoIList()
	CoreOptionsTable.args.PoI.args.nameList.args = {} --reset
	
	local list = {}
	for name, data in pairs_(fR.PoI) do 
		table_insert(list, name)
	end
	
	table_sort(list, function(a,b) 
		if(a and b) then 
			return a < b
		end 
	end)
	
	
	local playerName, data
	for i=1, table_getn(list) do 
		playerName = list[i]
		data = fR.PoI[playerName]
		
		CoreOptionsTable.args.PoI.args.nameList.args[playerName] = {
			type	= "group",
			name	= playerName,
--~ 			desc	= "someName",
			order = i,
			args={}
		}
		
		CoreOptionsTable.args.PoI.args.nameList.args[playerName].args.addedWhen = {
			type = "description",	order = 1,
			name = L["Added: "]..data.when,
		}
		
		
		CoreOptionsTable.args.PoI.args.nameList.args[playerName].args.removeName = {
			type = "execute",	order	= 10,
			name	= L["Remove Name"],
			desc	= L["Remove name from list"],
			func = function(info) 
				RemoveName(info[3])
			end
		}
		
	end
	
end

function RemoveName(name)
	fR.PoI[name] = nil
	BuildPoIList()
	echo(L["Removed |cffffff00%s|r from list."]:format(name))
end