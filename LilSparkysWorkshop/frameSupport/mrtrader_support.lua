-- LSW MrTrader Interface

do
	local buttonNamePattern = "MRTSkillButton(%d+)"
	local buttonTextNamePattern = "MRTSkillButton(%d+)"

	local skillWidth
	local oldShowWindow

	local skillWidthNarrow = 205
	local skillWidthWide = 225

	local numSkills = 1



	local function GetSkillListWidth()
		return skillWidth
	end


	local function initButtons(i)
		local tradeSkillButton = _G["MRTSkillButton"..i];

		if tradeSkillButton then
			tradeSkillButton:SetScript("OnShow", function() LSW:SkillButtonShow(tradeSkillButton) end)
			tradeSkillButton:SetScript("OnHide", function() LSW:SkillButtonHide(tradeSkillButton) end)
			tradeSkillButton:SetNormalFontObject("GameFontNormalSmall");
			tradeSkillButton:SetHighlightFontObject("GameFontHighlightSmall");
			tradeSkillButton:SetDisabledFontObject("GameFontDisableSmall");
			tradeSkillButton:SetWidth(GetSkillListWidth());

			LSW:CreateDynamicButtons(i, "MRTSkillButton"..i, MrTrader_SkillFrame);
		end

		return tradeSkillButton
	end




	local function UpdateWindow()
		for i=1, numSkills, 1 do
			_G["MRTSkillButton"..i]:Hide()
			_G["LSWTradeSkillValue"..i]:Hide()
			_G["LSWTradeSkillCost"..i]:Hide()
			_G["LSWTradeSkillItemLevel"..i]:Hide()
		end

		oldUpdateWindow(MRTSkillWindow)

		for i=1, numSkills, 1 do
			local button = _G["MRTSkillButton"..i]

			local skillID = button:GetID()

			local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

			LSW:FilterButtonText(button, itemID, recipeID)


			button:SetNormalFontObject("GameFontNormalSmall");
		end

		local name = GetTradeSkillLine()

		MRTSkillFrameTitleText:SetText(name.." ("..LSW.version..")")
	end




	local function ShowWindow()
--		LSW.globalSync = LSW.globalSync + 1
		LSW:CreateTimer("updateData", 0.1, LSW.UpdateData)

		oldShowWindow(MRTSkillWindow)

		if (MRTSkillListScrollFrame:IsVisible()) then
			skillWidth = skillWidthNarrow
		else
			skillWidth = skillWidthWide
		end

-- make sure all buttons are accounted for (mods might have added new buttons in the meantime -- doublewide, tradeskill HD, etc)
		for i=numSkills,100 do
			if not initButtons(i) then
				break
			else
				numSkills = i
			end
		end

		UpdateWindow()
	end




	local function Init()
		TradeSkillTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25,	font = LSWFontNormalLeftOrange }
		TradeSkillTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00,	font = LSWFontNormalLeftYellow }
		TradeSkillTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25,	font = LSWFontNormalLeftLightGreen }
		TradeSkillTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50,	font = LSWFontNormalLeftGrey }
		TradeSkillTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0,		font = GameFontNormalSmallLeft }


		oldShowWindow = MRTSkillWindow.Show
		MRTSkillWindow.Show = ShowWindow

		oldUpdateWindow = MRTSkillWindow.Update
		MRTSkillWindow.Update = UpdateWindow


		skillWidth = skillWidthNarrow

		LSW.RefreshWindow = UpdateWindow

		LSW.GetSkillListWidth = GetSkillListWidth

		LSW.parentFrame = MRTSkillFrame

		LSW.buttonNamePattern = buttonNamePattern
		LSW.buttonTextNamePattern = buttonTextNamePattern

		numSkills = 1

		for i=1,100 do
			if not initButtons(i) then
				break
			else
				numSkills = i
			end
		end
	end

	local function Test(index)
		LoadAddOn("MrTrader_SkillWindow")

		if MRTSkillWindow then
			return true
		end

		return false
	end

	LSW:RegisterFrameSupport("MrTrader", Test, Init)
end




