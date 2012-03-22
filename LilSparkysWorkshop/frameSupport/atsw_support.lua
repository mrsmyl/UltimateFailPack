



-- LSW ATSW Interface



do
	local buttonNamePattern = "ATSWSkill(%d+)"
	local buttonTextNamePattern = "ATSWSkill%d"

	local skillWidth
	local oldShowWindow
	local oldUpdateWindow

	local skillWidthNarrow = 213
	local skillWidthWide = 233


	local function initButtons(i)
		local atswButton = getglobal("ATSWSkill"..i)
		atswButton:SetScript("OnShow", function() LSW:SkillButtonShow(atswButton) end)
		atswButton:SetScript("OnHide", function() LSW:SkillButtonHide(atswButton) end)
	--	atswButton:SetNormalFontObject("GameFontNormalSmall")
		atswButton:SetHighlightFontObject("GameFontHighlightSmall")
		atswButton:SetDisabledFontObject("GameFontDisableSmall")

		LSW:CreateDynamicButtons(i, "ATSWSkill"..i)
	end


	local function GetSkillListWidth()
		return skillWidth
	end





	local function UpdateWindow()
		oldUpdateWindow()

		-- force an update of the skill buttons AFTER ATSW has assigned text and such to each button
		for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
			local button = getglobal("ATSWSkill"..i)

			local skillID = button:GetID()

			local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

			LSW:FilterButtonText(button, itemID, recipeID)
		end
	end


	local function ShowWindow()
		oldShowWindow()

		local scrollFrame = ATSWListScrollFrame

		if (ATSWListScrollFrame:IsVisible()) then
			skillWidth = skillWidthNarrow
		else
			skillWidth = skillWidthWide
		end

		local ATSW_title = ATSWFrameTitleText:GetText()

		ATSWFrameTitleText:SetText(ATSW_title.." (w/ "..LSW.version..")")

		UpdateWindow()
	end

	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop plugging into AdvancedTradeSkillWindow.");

		ATSWTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25,	font = LSWFontNormalLeftOrange };
		ATSWTypeColor["medium"]		= { r = 1.00, g = 1.00, b = 0.00,	font = LSWFontNormalLeftYellow };
		ATSWTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25,	font = LSWFontNormalLeftLightGreen };
		ATSWTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50,	font = LSWFontNormalLeftGrey };
		ATSWTypeColor["header"]		= { r = 1.00, g = 0.82, b = 0,		font = GameFontNormalSmallLeft };


		oldShowWindow = ATSW_ShowWindow
		oldUpdateWindow = ATSWFrame_Update

		LSW.buttonNamePattern = buttonNamePattern
		LSW.buttonTextNamePattern = buttonTextNamePattern

		ATSW_ShowWindow = ShowWindow
		ATSWFrame_Update = UpdateWindow

		LSW.RefreshWindow = UpdateWindow

		LSW.GetSkillListWidth = GetSkillListWidth

		LSW.parentFrame = ATSWFrame

		skillWidth = skillWidthNarrow

		for i=1, ATSW_TRADE_SKILLS_DISPLAYED, 1 do
			initButtons(i)
		end
	end


	function Test()
		if ATSW_ShowWindow then
			return true
		end

		return false
	end

	LSW:RegisterFrameSupport("ATSW", Test, Init)
end





