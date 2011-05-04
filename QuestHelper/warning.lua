QuestHelper_File["warning.lua"] = "4.0.6.161r"
QuestHelper_Loadtime["warning.lua"] = GetTime()

--[[
  Much of this code is ganked wholesale from Swatter, and is Copyright (C) 2006 Norganna. Licensed under LGPL v3.0.
]]

local debug_output = false
if QuestHelper_File["warning.lua"] == "Development Version" then debug_output = true end

QuestHelper_local_version = QuestHelper_File["warning.lua"]
QuestHelper_toc_version = GetAddOnMetadata("QuestHelper", "Version")

local origHandler = getwarninghandler()

local QuestHelper_WarningCatcher = { }

local startup_warnings = {}
local completely_started = false
local yelled_at_user = false

local first_warning = nil

QuestHelper_Warnings = {}

function QuestHelper_WarningCatcher.TextWarning(text)
  DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffff8080QuestHelper Warning Handler: |r%s", text))
end


-- ganked verbatim from Swatter
function QuestHelper_WarningCatcher.GetQuests()
  local return_string = ""

  for q = 1, GetNumQuestLogEntries() do
    local title, _, _, _, header, _, _, _, id = GetQuestLogTitle(q)
    if header then
      if id then
        return_string = return_string .. string.format("%s (%d)\n", title, id)
      else
        return_string = return_string .. string.format("[%s]\n", title)
      end
    else
      return_string = return_string .. string.format("\t%s (%d)\n", title, id)
    end
  end

  return return_string
end
function QuestHelper_WarningCatcher.GetAddOns()
	local addlist = ""
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)

		local loaded = IsAddOnLoaded(i)
		if (loaded) then
			if not name then name = "Anonymous" end
			name = name:gsub("[^a-zA-Z0-9]+", "")
			local version = GetAddOnMetadata(i, "Version")
			local class = getglobal(name)
			if not class or type(class)~='table' then class = getglobal(name:lower()) end
			if not class or type(class)~='table' then class = getglobal(name:sub(1,1):upper()..name:sub(2):lower()) end
			if not class or type(class)~='table' then class = getglobal(name:upper()) end
			if class and type(class)=='table' then
				if (class.version) then
					version = class.version
				elseif (class.Version) then
					version = class.Version
				elseif (class.VERSION) then
					version = class.VERSION
				end
			end
			local const = getglobal(name:upper().."_VERSION")
			if (const) then version = const end

			if type(version)=='table' then
        local allstr = true
        for k, v in pairs(version) do
          if type(v) ~= "string" then allstr = false end
        end
        
        if allstr then
          version = table.concat(version,":")
        end
			elseif type(version) == 'function' then
        local yay, v = pcall(version)
        
        if yay then version = v end
      end

			if (version) then
				addlist = addlist.."  "..name..", v"..tostring(version).."\n"
			else
				addlist = addlist.."  "..name.."\n"
			end
		end
	end
	return addlist
end

local warning_uniqueness_whitelist = {
  ["count"] = true,
  ["timestamp"] = true,
}

-- here's the logic
function QuestHelper_WarningCatcher.CondenseWarnings()
  if completely_started then
    while next(startup_warnings) do
      _, warn = next(startup_warnings)
      table.remove(startup_warnings)
      
      if not QuestHelper_Warnings[warn.type] then QuestHelper_Warnings[warn.type] = {} end
      
      local found = false
      
      for _, item in ipairs(QuestHelper_Warnings[warn.type]) do
        local match = true
        for k, v in pairs(warn.dat) do
          if not warning_uniqueness_whitelist[k] and item[k] ~= v then match = false break end
        end
        if match then for k, v in pairs(item) do
          if not warning_uniqueness_whitelist[k] and warn.dat[k] ~= v then match = false break end
        end end
        if match then
          found = true
          item.count = (item.count or 1) + 1
          break
        end
      end
      
      if not found then
        table.insert(QuestHelper_Warnings[warn.type], warn.dat)
      end
    end
  end
end

function QuestHelper_WarningCatcher_RegisterWarning(typ, dat)
  table.insert(startup_warnings, {type = typ, dat = dat})
  QuestHelper_WarningCatcher.CondenseWarnings()
end

function QuestHelper_WarningPackage(depth)
  return {
    timestamp = date("%Y-%m-%d %H:%M:%S"),
    local_version = QuestHelper_local_version,
    toc_version = QuestHelper_toc_version,
    game_version = GetBuildInfo(),
    locale = GetLocale(),
    mutation_passes_exceeded = QuestHelper and QuestHelper.mutation_passes_exceeded,
    stack = debugstack(depth or 4, 20, 20),
  }
end

StaticPopupDialogs["QH_EXPLODEY"] = {
	text = "QuestHelper has broken. You may have to restart WoW. Type \"/qh warning\" for a detailed warning message.",
	button1 = OKAY,
	OnAccept = function(self)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};

function QuestHelper_WarningCatcher_ExplicitWarning(loud, o_msg, o_frame, o_stack, ...)
  local msg = o_msg or ""  

  -- We toss it into StartupWarnings, and then if we're running properly, we'll merge it into the main DB.
  local twarning = QuestHelper_WarningPackage()
  
  twarning.message = msg
  twarning.addons = QuestHelper_WarningCatcher.GetAddOns()
  twarning.stack = o_stack or twarning.stack
  twarning.silent = not loud
  twarning.quests = QuestHelper_WarningCatcher.GetQuests()
  
  QuestHelper_WarningCatcher_RegisterWarning("crash", twarning)
  
  if first_warning and first_warning.silent and not first_warning.next_loud and not twarning.silent then first_warning.next_loud = twarning first_warning.addons = "" end
  if not first_warning or first_warning.generated then first_warning = twarning end
  
  QuestHelper_WarningCatcher.CondenseWarnings()

  if (--[[debug_output or]] loud) and not yelled_at_user then
    --print("qhbroken")
    StaticPopupDialogs["QH_EXPLODEY"] = {
      text = "QuestHelper has broken. You may have to restart WoW. Type \"/qh warning\" for a detailed warning message.",
      button1 = OKAY,
      OnAccept = function(self)
      end,
      timeout = 0,
      whileDead = 1,
      hideOnEscape = 1
    }
    
    StaticPopup_Show("QH_EXPLODEY")
    yelled_at_user = true
  end
end

function QuestHelper_WarningCatcher_GenerateReport()
  if first_warning then return end -- don't need to generate one
  
  local twarning = QuestHelper_WarningPackage()
  
  twarning.message = "(Full report)"
  twarning.addons = QuestHelper_WarningCatcher.GetAddOns()
  twarning.stack = ""
  twarning.silent = "(Full report)"
  twarning.generated = true
  twarning.quests = QuestHelper_WarningCatcher.GetQuests()
  
  first_warning = twarning
end

function QuestHelper_WarningCatcher.OnWarning(o_msg, o_frame, o_stack, o_etype, ...)
  local warningize = false
  local loud = false
  if o_msg and string.find(o_msg, "QuestHelper") and not string.find(o_msg, "Cannot find a library with name") then loud = true end
  
  for lin in string.gmatch(debugstack(2, 20, 20), "([^\n]*)") do
    if string.find(lin, "QuestHelper") and not string.find(lin, "QuestHelper\\AstrolabeQH\\DongleStub.lua") then warningize = true end
  end
  
  if string.find(o_msg, "SavedVariables") then warningize, loud = false, false end
  if string.find(o_msg, "C stack overflow") then
    if loud then warningize = true end
    loud = false
  end
  
  if loud then warningize = true end
  
  if warningize then QuestHelper_WarningCatcher_ExplicitWarning(loud, o_msg, o_frame, o_stack) end
  
  --[[
  if o_msg and
    (
      (
        string.find(o_msg, "QuestHelper")  -- Obviously we care about our bugs
      )
      or (
        string.find(debugstack(2, 20, 20), "QuestHelper")  -- We're being a little overzealous and catching any bug with "QuestHelper" in the stack. This possibly should be removed, I'm not sure it's ever caught anything interesting.
        and not string.find(o_msg, "Cartographer_POI")  -- Cartographer started throwing ridiculous numbers of warnings on startup with QH in the stack, and since we caught stuff with QH in the stack, we decided these warnings were ours. Urgh. Disabled.
      )
    )
    and not string.match(o_msg, "WTF\\Account\\.*")  -- Sometimes the WTF file gets corrupted. This isn't our fault, since we weren't involved in writing it, and there's also nothing we can do about it - in fact we can't even retrieve the remnants of the old file. We may as well just ignore it. I suppose we could pop up a little dialog saying "clear some space on your hard drive, dufus" but, meh.
    and not (string.find(o_msg, "Cannot find a library with name") and string.find(debugstack(2, 20, 20), "QuestHelper\\AstrolabeQH\\DongleStub.lua")) -- We're catching warnings caused by other people mucking up their dongles. Ughh.
    then
      QuestHelper_WarningCatcher_ExplicitWarning(o_msg, o_frame, o_stack)
  end]]
  
  return origHandler(o_msg, o_frame, o_stack, o_etype, unpack(arg or {}))  -- pass it on
end

setwarninghandler(QuestHelper_WarningCatcher.OnWarning) -- at this point we can catch warnings

function QuestHelper_WarningCatcher.CompletelyStarted()
  completely_started = true
  
  -- Our old code generated a horrifying number of redundant items. My bad. I considered going and trying to collate them into one chunk, but I think I'm just going to wipe them - it's easier, faster, and should fix some performance issues.
  if not QuestHelper_Warnings.version or QuestHelper_Warnings.version ~= 1 then
    QuestHelper_Warnings = {version = 1}
  end
  
  QuestHelper_WarningCatcher.CondenseWarnings()
end

function QuestHelper_WarningCatcher_CompletelyStarted()
  QuestHelper_WarningCatcher.CompletelyStarted()
end



-- and here is the GUI

local QHE_Gui = {}

function QHE_Gui.WarningUpdate()
  QHE_Gui.WarningTextinate()
  QHE_Gui.Warning.Box:SetText(QHE_Gui.Warning.curWarning)
  QHE_Gui.Warning.Scroll:UpdateScrollChildRect()
	QHE_Gui.Warning.Box:ClearFocus()
end

function TextinateWarning(warn)
  local tswarn = string.format("msg: %s\ntoc: %s\nv: %s\ngame: %s\nlocale: %s\ntimestamp: %s\nmutation: %s\nsilent: %s\n\n%s\naddons:\n%s", warn.message, warn.toc_version, warn.local_version, warn.game_version, warn.locale, warn.timestamp, tostring(warn.mutation_passes_exceeded), tostring(warn.silent), warn.stack, warn.addons)
  if warn.next_loud then
    tswarn = tswarn .. "\n\n---- Following loud warning\n\n" .. TextinateWarning(warn.next_loud)
  end
  return tswarn
end

function QHE_Gui.WarningTextinate()
  if first_warning then
    QHE_Gui.Warning.curWarning = TextinateWarning(first_warning)
  else
    QHE_Gui.Warning.curWarning = "None"
  end
end

function QHE_Gui.WarningClicked()
	if (QHE_Gui.Warning.selected) then return end
	QHE_Gui.Warning.Box:HighlightText()
	QHE_Gui.Warning.selected = true
end

function QHE_Gui.WarningDone()
	QHE_Gui.Warning:Hide()
end


-- Create our warning message frame. Most of this is also ganked from Swatter.
QHE_Gui.Warning = CreateFrame("Frame", "QHE_GUIWarningFrame", UIParent)
QHE_Gui.Warning:Hide()
QHE_Gui.Warning:SetPoint("CENTER", "UIParent", "CENTER")
QHE_Gui.Warning:SetFrameStrata("TOOLTIP")
QHE_Gui.Warning:SetHeight(300)
QHE_Gui.Warning:SetWidth(600)
QHE_Gui.Warning:SetBackdrop({
	bgFile = "Interface/Tooltips/ChatBubble-Background",
	edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 32, right = 32, top = 32, bottom = 32 }
})
QHE_Gui.Warning:SetBackdropColor(0.2,0,0, 1)
QHE_Gui.Warning:SetScript("OnShow", QHE_Gui.WarningShow)
QHE_Gui.Warning:SetMovable(true)

QHE_Gui.ProxyFrame = CreateFrame("Frame", "QHE_GuiProxyFrame")
QHE_Gui.ProxyFrame:SetParent(QHE_Gui.Warning)
QHE_Gui.ProxyFrame.IsShown = function() return QHE_Gui.Warning:IsShown() end
QHE_Gui.ProxyFrame.escCount = 0
QHE_Gui.ProxyFrame.timer = 0
QHE_Gui.ProxyFrame.Hide = (
	function( self )
		local numEscapes = QHE_Gui.numEscapes or 1
		self.escCount = self.escCount + 1
		if ( self.escCount >= numEscapes ) then
			self:GetParent():Hide()
			self.escCount = 0
		end
		if ( self.escCount == 1 ) then
			self.timer = 0
		end
	end
)
QHE_Gui.ProxyFrame:SetScript("OnUpdate",
	function( self, elapsed )
		local timer = self.timer + elapsed
		if ( timer >= 1 ) then
			self.escCount = 0
		end
		self.timer = timer
	end
)
table.insert(UISpecialFrames, "QHE_GuiProxyFrame")

QHE_Gui.Drag = CreateFrame("Button", nil, QHE_Gui.Warning)
QHE_Gui.Drag:SetPoint("TOPLEFT", QHE_Gui.Warning, "TOPLEFT", 10,-5)
QHE_Gui.Drag:SetPoint("TOPRIGHT", QHE_Gui.Warning, "TOPRIGHT", -10,-5)
QHE_Gui.Drag:SetHeight(8)
QHE_Gui.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

QHE_Gui.Drag:SetScript("OnMouseDown", function() QHE_Gui.Warning:StartMoving() end)
QHE_Gui.Drag:SetScript("OnMouseUp", function() QHE_Gui.Warning:StopMovingOrSizing() end)

QHE_Gui.Warning.Done = CreateFrame("Button", "", QHE_Gui.Warning, "OptionsButtonTemplate")
QHE_Gui.Warning.Done:SetText("Close")
QHE_Gui.Warning.Done:SetPoint("BOTTOMRIGHT", QHE_Gui.Warning, "BOTTOMRIGHT", -10, 10)
QHE_Gui.Warning.Done:SetScript("OnClick", QHE_Gui.WarningDone)

QHE_Gui.Warning.Mesg = QHE_Gui.Warning:CreateFontString("", "OVERLAY", "GameFontNormalSmall")
QHE_Gui.Warning.Mesg:SetJustifyH("LEFT")
QHE_Gui.Warning.Mesg:SetPoint("TOPRIGHT", QHE_Gui.Warning.Prev, "TOPLEFT", -10, 0)
QHE_Gui.Warning.Mesg:SetPoint("LEFT", QHE_Gui.Warning, "LEFT", 15, 0)
QHE_Gui.Warning.Mesg:SetHeight(20)
QHE_Gui.Warning.Mesg:SetText("Select All and Copy the above warning message to report this bug.")

QHE_Gui.Warning.Scroll = CreateFrame("ScrollFrame", "QHE_GUIWarningInputScroll", QHE_Gui.Warning, "UIPanelScrollFrameTemplate")
QHE_Gui.Warning.Scroll:SetPoint("TOPLEFT", QHE_Gui.Warning, "TOPLEFT", 20, -20)
QHE_Gui.Warning.Scroll:SetPoint("RIGHT", QHE_Gui.Warning, "RIGHT", -30, 0)
QHE_Gui.Warning.Scroll:SetPoint("BOTTOM", QHE_Gui.Warning.Done, "TOP", 0, 10)

QHE_Gui.Warning.Box = CreateFrame("EditBox", "QHE_GUIWarningEditBox", QHE_Gui.Warning.Scroll)
QHE_Gui.Warning.Box:SetWidth(500)
QHE_Gui.Warning.Box:SetHeight(85)
QHE_Gui.Warning.Box:SetMultiLine(true)
QHE_Gui.Warning.Box:SetAutoFocus(false)
QHE_Gui.Warning.Box:SetFontObject(GameFontHighlight)
QHE_Gui.Warning.Box:SetScript("OnEscapePressed", QHE_Gui.WarningDone)
QHE_Gui.Warning.Box:SetScript("OnTextChanged", QHE_Gui.WarningUpdate)
QHE_Gui.Warning.Box:SetScript("OnEditFocusGained", QHE_Gui.WarningClicked)

QHE_Gui.Warning.Scroll:SetScrollChild(QHE_Gui.Warning.Box)

function QuestHelper_WarningCatcher_ReportWarning()
  QHE_Gui.Warning.selected = false
	QHE_Gui.WarningUpdate()
	QHE_Gui.Warning:Show()
end
