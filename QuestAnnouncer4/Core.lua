QuestAnnouncer4 = LibStub("AceAddon-3.0"):NewAddon("QuestAnnouncer4", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0", "AceSerializer-3.0", "AceTimer-3.0");
QuestAnnouncer4.version = "1.2";
QuestAnnouncer4.author = "Jason Olivarez (Svetlania, Ragu, and Pyroclastic of Garrosh-US)";

-- Local variables
local questLog = {};
local questLogUpdating = false;
local delayPartyChat = false;

-- Default options DB
local defaults = {
	global = {
		PartyChat = false,
		localMsgs = true,
	}
};

-- Message List
local messages = {
	-- quest failed messages
	["failed"] = {
		color = {r=1,g=0,b=0},
		broadcast = "%s has failed %s",
		party = "Failed: %s",
		locl = "You have failed %s"
	},
	-- quest progress messages
	["progress"] = {
		color = {r=1,g=1,b=0},
		broadcast = "%s\'s quest progress... %s",
		party = "%s",
		locl = nil
	},
	-- quest completed messages
	["completed"] = {
		color = {r=0,g=1,b=0},
		broadcast = "%s has completed %s",
		party = "Completed: %s",
		locl = "You have completed %s"
	},
	-- quest accepted messages
	["accepted"] = {
		color = {r=.75,g=.75,b=1},
		broadcast = "%s has accepted %s",
		party = "Accepted: %s",
		locl = "You have accepted %s"
	}
}

function QuestAnnouncer4:OnInitialize()
	-- Load Options DB
	self.db = LibStub("AceDB-3.0"):New("QuestAnnouncer4DB", defaults);
	
	-- Initialize Config
	self:InitConfig();
	
	-- Register Events
	self:RegisterEvent("QUEST_LOG_UPDATE");
	self:RegisterEvent("QUEST_ACCEPTED");
	self:RegisterEvent("UI_INFO_MESSAGE");
	
	-- Register Communications channel
	self:RegisterComm("QA4");
	
	-- Delay welcome message.
	self:ScheduleTimer(function() 
			self:Print("QuestAnnouncer 4 (ver. " .. self.version .. ") is loaded. Use /qa4 for options.")
		end, 4);
end

function QuestAnnouncer4:OnCommReceived(prefix, message, distribution, sender)
	if (prefix == "QA4") and (sender ~= UnitName("player")) then
		local success, msg, color = self:Deserialize(message)
		if (success) then
			UIErrorsFrame:AddMessage(msg,color.r,color.g,color.b,1.0,UIERRORS_HOLD_TIME);
		end
	end
end

function QuestAnnouncer4:ProcessAnnouncement(typ, msg)
	local myname = UnitName("player");
	local broadcast, party, locl, color = messages[typ].broadcast, messages[typ].party, messages[typ].locl, messages[typ].color
	
	if locl and self.db.global.localMsgs then
		UIErrorsFrame:AddMessage(string.format(locl, msg),color.r,color.g,color.b,1.0,UIERRORS_HOLD_TIME);
	end

	if (GetNumPartyMembers() > 0) then
		local serializedData = self:Serialize(string.format(broadcast, myname, msg), color);
		self:SendCommMessage("QA4", serializedData, "RAID");
		
		if (not delayPartyChat or typ ~= "progress") and self.db.global.PartyChat then
			if typ == "progress" then
				delayPartyChat = true;
				self:ScheduleTimer(function() delayPartyChat = false end, 3);
			end
			SendChatMessage(string.format(party, msg), "PARTY");
		end
	end
end

function QuestAnnouncer4:UI_INFO_MESSAGE(frame,msg)
	if (msg ~= gsub(msg,"(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$","%1",1)) then
		self:ProcessAnnouncement("progress", msg);
	end
end

function QuestAnnouncer4:QUEST_ACCEPTED(event, QuestID)
	local questTitle = GetQuestLogTitle(QuestID);
	self:ProcessAnnouncement("accepted", questTitle)
end

function QuestAnnouncer4:QUEST_LOG_UPDATE()
	-- Check to see if thread is already running. If so, exit or lock if not.
	if ( questLogUpdating ) then
		return true;
	end
	questLogUpdating = true;
	local QuestID=1;
	while (GetQuestLogTitle(QuestID) ~= nil) do
		local questTitle, _, _, _, isHeader, _, isComplete = GetQuestLogTitle(QuestID);
		local questCRC = 0;
		if (not isHeader) then
			SelectQuestLogEntry(QuestID);

			-- Get CRC32 value of current quest's description.  This allows for better tracking of quests with the same name.
			local questDescription, _ = GetQuestLogQuestText();
			if (questDescription) then
				questCRC = CRC32Lib.Compute(questDescription);
				local status = 0;
				if (isComplete) then status = isComplete end;
				-- Check for Quest changes
				if questLog[questCRC] and questLog[questCRC] ~= status then
					local sendDelayed = function(typ, msg)
							self:ScheduleTimer(function() self:ProcessAnnouncement(typ, msg) end, 1)
						end
					if questLog[questCRC] == 0 and status == 1 then
						sendDelayed("completed", questTitle);
					elseif (questLog[questCRC] == 0 or questLog[questCRC] == 1) and status == -1 then
						sendDelayed("failed", questTitle);						
					end
				end
				questLog[questCRC] = status;
			end
		end
		QuestID = QuestID + 1;
	end
	
	-- Unlock the thread
	questLogUpdating = false;
end