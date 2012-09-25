
local GetTime = QuestHelper_GetTime

QuestHelper_File["collect_location.lua"] = "5.0.5.255r"
QuestHelper_Loadtime["collect_location.lua"] = GetTime()

-- little endian two's complement
local function signed(c)
  QuestHelper: Assert(not c or c >= -127 and c < 127)
  if not c then c = -128 end
  if c < 0 then c = c + 256 end
  return c
  --return strchar(c)
end

local function float(c)
--  if not c then c = -128 end
--  QuestHelper: Assert( c >= -128, string.format("c is too small. It is %s.", tostring(c)))
--  QuestHelper: Assert( c < 128, string.format("c is too big. It is %s.", tostring(c)))
  local ret = tostring(c):gsub(",",".") -- eliminate issues with locales that use a comma as the decimal separator.
  return ret
end

local function BolusizeLocation(delayed, c, z, x, y, dl, mid, mf, f)
  -- c and z are *signed* integers that fit within an 8-bit int.
  -- x and y are floating-point values, generally between 0 and 1. We'll dedicate 24 bits to the fractional part, largely because we can.
  -- Overall we're using a weird 11 bytes on this. Meh.
  -- Also, any nil values are being turned into MIN_WHATEVER.
  local float_x = float(x)
  local float_y = float(y)
  local loc = {}
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
