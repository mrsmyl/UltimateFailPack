-- This is what loads the appropriate locale specific data.
local loaded, reason = LoadAddOn("QHData-" .. GetLocale())

if loaded ~= 1 then error(getglobal("ADDON_" .. reason)) end
