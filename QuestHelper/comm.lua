
local GetTime = QuestHelper_GetTime

QuestHelper_File["comm.lua"] = "4.3.0.244r"
QuestHelper_Loadtime["comm.lua"] = GetTime()

function QuestHelper:HandleRemoteData() end
function QuestHelper:PumpCommMessages() end
function QuestHelper:HandlePartyChange() end
function QuestHelper:EnableSharing() end
function QuestHelper:DisableSharing() end

do return end
