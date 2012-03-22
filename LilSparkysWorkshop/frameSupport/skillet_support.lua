
-- LSW Skillet Interface (LilSparky version)


do
	local buttonNamePattern = "SkilletScrollButton(%d+)"
	local buttonTextNamePattern = "SkilletScrollButton%dName"

	local oldShowWindow, oldUpdateWindow




	local function SortCompareItemValue_OLD(skill,a,b)  -- highest value first
		local recipeID_A = LSW:FindID(GetTradeSkillItemLink(a))
		local recipeID_B = LSW:FindID(GetTradeSkillItemLink(b))

		local itemValueA = LSW:GetSkillValue(recipeID_A) or 0
		local itemValueB = LSW:GetSkillValue(recipeID_B) or 0

		if itemValueA > itemValueB then
			return true
		end

		return false
	end


	local function SortCompareReagentCost_OLD(skill,b,a)  -- lowest cost first so i swap b and a
		local recipeID_A = LSW:FindID(GetTradeSkillItemLink(a))
		local recipeID_B = LSW:FindID(GetTradeSkillItemLink(b))

		local itemCostA = LSW:GetSkillCost(recipeID_A) or 0
		local itemCostB = LSW:GetSkillCost(recipeID_B) or 0

		if (itemCostA > itemCostB) then return true; end

		return false;
	end


	local function SortCompareProfit_OLD(skill,a,b)  -- highest profit first
		local recipeID_A = LSW:FindID(GetTradeSkillItemLink(a))
		local recipeID_B = LSW:FindID(GetTradeSkillItemLink(b))

		local itemValueA = LSW:GetSkillValue(recipeID_A) or 0
		local itemValueB = LSW:GetSkillValue(recipeID_B) or 0

		local itemCostA = LSW:GetSkillCost(recipeID_A) or 0
		local itemCostB = LSW:GetSkillCost(recipeID_B) or 0

		if LSWConfig.valueAsPercent then
			local itemProfitA = itemValueA / (itemCostA+0.00001)
			local itemProfitB = itemValueB / (itemCostB+0.00001)

			return (itemProfitA > itemProfitB)
		else
			local itemProfitA = itemValueA - itemCostA
			local itemProfitB = itemValueB - itemCostB

			return (itemProfitA > itemProfitB)
		end

		return false
	end




	local function SortCompareItemValue(tradeskill, a, b)
		while a.subGroup and #a.subGroup.entries>0 do
			a = a.subGroup.entries[1]
		end

		while b.subGroup and #b.subGroup.entries>0 do
			b = b.subGroup.entries[1]
		end

		local itemValueA = LSW:GetSkillValue(a.recipeID) or 0
		local itemValueB = LSW:GetSkillValue(b.recipeID) or 0

		if (itemValueA > itemValueB) then return true; end

		return false;
	end


	local function SortCompareReagentCost(skill,b,a)  -- lowest cost first so i swap b and a
		while a.subGroup and #a.subGroup.entries>0 do
			a = a.subGroup.entries[1]
		end

		while b.subGroup and #b.subGroup.entries>0 do
			b = b.subGroup.entries[1]
		end

		local itemCostA = LSW:GetSkillCost(a.recipeID) or 0
		local itemCostB = LSW:GetSkillCost(b.recipeID) or 0

		if (itemCostA > itemCostB) then return true; end

		return false;
	end


	local function SortCompareProfit(skill,a,b)  -- highest profit first
		while a.subGroup and #a.subGroup.entries>0 do
			a = a.subGroup.entries[1]
		end

		while b.subGroup and #b.subGroup.entries>0 do
			b = b.subGroup.entries[1]
		end

		local itemValueA = LSW:GetSkillValue(a.recipeID) or 0
		local itemValueB = LSW:GetSkillValue(b.recipeID) or 0

		local itemCostA = LSW:GetSkillCost(a.recipeID) or 0
		local itemCostB = LSW:GetSkillCost(b.recipeID) or 0


		if LSWConfig.valueAsPercent then
			local itemProfitA = itemValueA / (itemCostA+0.00001)
			local itemProfitB = itemValueB / (itemCostB+0.00001)

			return (itemProfitA > itemProfitB)
		else
			local itemProfitA = itemValueA - itemCostA
			local itemProfitB = itemValueB - itemCostB

			return (itemProfitA > itemProfitB)
		end

		return false;
	end



	local function SkilletBeforeRecipeButtonShow(button, tradeskill, skill_index, list_offset)
		LSW:SkillButtonShow(button)
		return button;
	end

	local function SkilletBeforeRecipeButtonHide(button, tradeskill, skill_index, list_offset)
		LSW:SkillButtonHide(button)
		return button;
	end


	local function GetSkillListWidth()
		local width = SkilletSkillListParent:GetWidth()-100

		if (SkilletSkillList:IsVisible()) then
			width = width-20;
		end

		return width
	end



	local function ShowWindow()
		LSW:CreateTimer("updateData", 0.1, LSW.UpdateData)
		oldShowWindow(Skillet)
	end

	local function UpdateWindow()
		oldUpdateWindow(Skillet)

		local title = getglobal("SkilletTitleText")

		if (title and Skillet.currentTrade) then
			title:SetText("Skillet Trade Skills"..": "..((GetSpellInfo(Skillet.currentTrade)) or Skillet.currentTrade).." ("..LSW.version..")")
		end
	end


	local function RefreshWindow()
		if Skillet.SortAndFilterRecipes and Skillet.currentTrade then
			Skillet:SortAndFilterRecipes()
		end
		UpdateWindow()
	end





--[[
	if (LSW_Mode == "Skillet" and (button.skill and button.skill.subGroup)) then
				skillType = "header"
				skillName = ""
				skillLink = ""
]]

	local function Init()
--		LSW:ChatMessage("LilSparky's Workshop plugging into Skillet (v"..Skillet.version..")");

		oldShowWindow = Skillet.ShowTradeSkillWindow
		oldUpdateWindow = Skillet.UpdateTradeSkillWindow

		Skillet.ShowTradeSkillWindow = ShowWindow
		Skillet.UpdateTradeSkillWindow = UpdateWindow

		Skillet:AddPreButtonShowCallback(SkilletBeforeRecipeButtonShow)
		Skillet:AddPreButtonHideCallback(SkilletBeforeRecipeButtonHide)


		LSW.RefreshWindow = RefreshWindow


		if string.find(Skillet.version, "LS") then
			Skillet:AddRecipeSorter("LSW: Item Value", SortCompareItemValue)
			Skillet:AddRecipeSorter("LSW: Reagent Cost", SortCompareReagentCost)
			Skillet:AddRecipeSorter("LSW: Profit", SortCompareProfit)
		else
			Skillet:AddRecipeSorter("LSW: Item Value", SortCompareItemValue_OLD)
			Skillet:AddRecipeSorter("LSW: Reagent Cost", SortCompareReagentCost_OLD)
			Skillet:AddRecipeSorter("LSW: Profit", SortCompareProfit_OLD)
		end


		LSW.buttonNamePattern = buttonNamePattern
		LSW.buttonTextNamePattern = buttonTextNamePattern

		LSW.GetSkillListWidth = GetSkillListWidth

		LSW.parentFrame = SkilletFrame

	end


	local function Test()
		if (Skillet and Skillet.version) then
			return true
		end

		return false
	end

	LSW:RegisterFrameSupport("Skillet", Test, Init)
end


