



-- LSW Blizzard Interface

-- also works with doublewide tradeskills and tradeskillHD and should work with any other mod that keeps the normal name pattern for tradeskill buttons -- that is: TradeSkillSkillXXX


do
	local buttonNamePattern = "TradeSkillSkill(%d+)"
	local buttonTextNamePattern = "TradeSkillSkill%d"

	local skillWidth
	local oldShowWindow

	local skillWidthNarrow = 205
	local skillWidthWide = 225

	local numSkills = 1



	local function GetSkillListWidth()
		return skillWidth
	end


	local function initButtons(i)
		local tradeSkillButton = getglobal("TradeSkillSkill"..i);

		if tradeSkillButton then
			tradeSkillButton:SetScript("OnShow", function() LSW:SkillButtonShow(tradeSkillButton) end)
			tradeSkillButton:SetScript("OnHide", function() LSW:SkillButtonHide(tradeSkillButton) end)
		--	tradeSkillButton:SetNormalFontObject("GameFontNormalSmall");
			tradeSkillButton:SetHighlightFontObject("GameFontHighlightSmall");
			tradeSkillButton:SetDisabledFontObject("GameFontDisableSmall");
			tradeSkillButton:SetWidth(GetSkillListWidth());

			LSW:CreateDynamicButtons(i, "TradeSkillSkill"..i, TradeSkillFrame);
		end

		return tradeSkillButton
	end




	local function UpdateWindow()
		for i=1, numSkills, 1 do
			local tradeSkillButton = getglobal("TradeSkillSkill"..i)
			tradeSkillButton:Hide()
			getglobal("LSWTradeSkillValue"..i):Hide()
			getglobal("LSWTradeSkillCost"..i):Hide()
			getglobal("LSWTradeSkillItemLevel"..i):Hide()
		end

		oldUpdateWindow()

		for i=1, numSkills, 1 do
			local button = getglobal("TradeSkillSkill"..i)

			local skillID = button:GetID()

			local skillName, skillType, itemLink, recipeLink, itemID, recipeID = LSW:GetTradeSkillData(skillID)

			LSW:FilterButtonText(button, itemID, recipeID)
		end

		local name = GetTradeSkillLine()
		TradeSkillFrameTitleText:SetText(name.." ("..LSW.version..")")
	end




	local function ShowWindow()
--		LSW.globalSync = LSW.globalSync + 1
		LSW:CreateTimer("updateData", 0.1, LSW.UpdateData)

		oldShowWindow()

		if (TradeSkillListScrollFrame:IsVisible()) then
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


		oldShowWindow = TradeSkillFrame_Show
		TradeSkillFrame_Show = ShowWindow

		oldUpdateWindow = TradeSkillFrame_Update
		TradeSkillFrame_Update = UpdateWindow


		skillWidth = skillWidthNarrow

		LSW.RefreshWindow = UpdateWindow

		LSW.GetSkillListWidth = GetSkillListWidth

		LSW.parentFrame = TradeSkillFrame

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


-- only use the standard ui if no other supported ui is present
	local function Test(index)
		local test = true
		frameSupportList = LSW:GetFrameSupportList()

		for i=1,#frameSupportList do
			if i ~= index then
				if frameSupportList[i].Test(i) then
					test = false
				end
			end
		end

		return test
	end


	LSW:RegisterFrameSupport("BlizzardUI", Test, Init)
end




