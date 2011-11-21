local options = {
	name = "QuestAnnouncer4",
	handler = QuestAnnouncer4,
	type = "group",
	args = {
		info1 = {
			type		= "description",
			name		= "Version " .. QuestAnnouncer4.version,
			order		= 0,
		},
		info2 = {
			type		= "description",
			name		= "Authors: " .. QuestAnnouncer4.author,
			order		= 1,
		},
		header = {
			type		= "header",
			name		= "General Options",
			order		= 2,
		},
		partyChat = {
			type = 'toggle',
			name = "Party Chat",
			desc = "Toggles whether announcements should also be sent through party chat allowing non-QA4 users to get updates",
			get = function() return QuestAnnouncer4.db.global.PartyChat end,
			set = function() QuestAnnouncer4.db.global.PartyChat = not QuestAnnouncer4.db.global.PartyChat end,
		}, 
		localMsgs = {
			type = 'toggle',
			name = "Local Messages",
			desc = "Toggles whether announcements such as quest accepted, failed, and completed should be shown on the local client",
			get = function() return QuestAnnouncer4.db.global.localMsgs end,
			set = function() QuestAnnouncer4.db.global.localMsgs = not QuestAnnouncer4.db.global.localMsgs end,
		} 
	}
};

function QuestAnnouncer4:InitConfig()
	QuestAnnouncer4:RegisterChatCommand("qa4", function() LibStub("AceConfigDialog-3.0"):Open("QuestAnnouncer4") end)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("QuestAnnouncer4", options);
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestAnnouncer4");
end