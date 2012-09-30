
local GetTime = QuestHelper_GetTime

QuestHelper_File["collect_location.lua"] = "5.0.5.267r"
QuestHelper_Loadtime["collect_location.lua"] = GetTime()

-- little endian two's complement
local function signed(c)
  QuestHelper: Assert(not c or c >= -127 and c < 127)
  if not c then c = -128 end
  if c < 0 then c = c + 256 end
  return c
  --return strchar(c)
end

local dec2hex = {[0] = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}

local hex2dec = {}

for k, v in pairs(dec2hex) do hex2dec[v] = k end

local function tohex(c)
	return dec2hex[c]
end

local function lgToDec(c, pos)
	if not c or c == "" then return 0 end

	local ret = 0

	pos = pos or 0

	if pos == 0 then c = string.reverse(c) end

	ret = todec(string.sub(c,1,1)) * math.pow(16, pos) + lgToDec(string.sub(c, 2), pos + 1)

	return ret
end

local function lgToHex(c, pos)
	local ret, rem, hex

	pos = pos or 0
	c = c or 0
	local minVal = math.pow(16, pos)
	local maxVal = math.pow(16, pos+1) - 1

	if c > maxVal then
		rem, hex = lgToHex(c, pos + 1)
	else
		rem, hex = c, ""
	end

	local mult = 0

	while rem >= minVal do
		mult = mult + 1
		rem = rem - minVal
	end

	return rem, hex .. tohex(mult)
end

local function todec(c)
	return hex2dec[c]
end

local function float(c)
--  if not c then c = -128 end
--  QuestHelper: Assert( c >= -128, string.format("c is too small. It is %s.", tostring(c)))
--  QuestHelper: Assert( c < 128, string.format("c is too big. It is %s.", tostring(c)))
  local ret = tohex(math.floor(128 * c))
  return ret
end

local function BolusizeLocation(delayed, c, z, x, y, dl, mid, mf, f)
  -- c and z are *signed* integers that fit within an 8-bit int.
  -- x and y are floating-point values, generally between 0 and 1. We'll dedicate 24 bits to the fractional part, largely because we can.
  -- Overall we're using a weird 11 bytes on this. Meh.
  -- Also, any nil values are being turned into MIN_WHATEVER.
  local float_x = x
  local float_y = y
  local loc = {}
  --local locStr = (delayed and 1 or 0) .. lgToHex(mid) .. tohex(dl) .. float(x) .. float(y)
  loc["delayed"] = (delayed and 1 or 0)
  loc["c"] = c
  loc["z"] = z
  loc["x"] = float_x
  loc["y"] = float_y
  loc["dungeonLevel"] = dl
  loc["mapid"] = mid
  loc["mapfile"] = mf
  loc["facing"] = f
  return loc;
  --return string.format("%s,%s,%s,%s,%s", signed(delayed and 1 or 0), signed(c), signed(z), float_x, float_y)
  --return signed(delayed and 1 or 0) .. signed(c) .. signed(z) .. float_x .. float_y
end

-- This merely provides another API function
function QH_Collect_Location_Init(_, API)
  API.Callback_LocationBolus = BolusizeLocation  -- Yeah. *Bolusize*. You heard me.
  API.Callback_LocationBolusCurrent = function () return BolusizeLocation(API.Callback_Location_Raw()) end  -- This is just a convenience function, really
end
