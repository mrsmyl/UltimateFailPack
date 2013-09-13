local _G = _G

local ADDON = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Bar module
local Bar = Addon:NewModule("Bar")

-- rearrangement of blizzard's frames
local Jostle = LibStub:GetLibrary("LibJostle-3.0", true)

local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

-- imports
local ipairs = ipairs
local pairs  = pairs
local unpack = unpack

local _

-- constants
local SPARK_LEN_MIN  = 28
local SPARK_LEN_MAX  = 128

local SPARK2_LEN_MIN = 8
local SPARK2_LEN_MAX = 32

local TEX_BAR    = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\texture.tga"
local TEX_BORDER = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\border.tga"
local TEX_SPARK  = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\glow.tga"
local TEX_SPARK2 = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\glow2.tga"

local BORDER_HEIGHT = 8

local ORIENTATION_DEFAULT         = { 0, 1, 0, 1 }
local ORIENTATION_FLIP_HORIZONTAL = { 0, 1, 1, 0 }
local ORIENTATION_ROTATE_LEFT_90  = { 1, 0, 0, 0, 1, 1, 0, 1 }
local ORIENTATION_ROTATE_RIGHT_90 = { 0, 1, 1, 1, 0, 0, 1, 0 }

local FONT_TEMPLATE      = "TextStatusBarText"
local FONT_NAME_DEFAULT  = "Friz Quadrata TT"
local FONT_SIZE_DEFAULT  = 10
local FONT_DEFAULT       = "Fonts\\FRIZQT__.TTF"
local FONT_STYLE         = "OUTLINE"

-- small positive number close to 0, used to avoid probelms with SetWidth/Height(0)
local EPSILON = 1e-5 

-- tick
local TICK_ACTIVE_COLOR = {
	r = 1,
	g = 1,
	b = 0.2,
	a = 1,
}

local TICK_INACTIVE_COLOR = {
	r = 0.65,
	g = 0.65,
	b = 0.65,
	a = 0.75,
}

local TICK_WIDTH = 2

-- utilities
local function vertical(str)
	if not str or type(str) ~= "string" then
		return str
	end
	
    -- test multi-byte
    local _, len = str:gsub("[^\128-\193]", "")
	
	local vertical
 
    if len == #str then
        vertical = str:gsub("(.)", "%1\n")
    else
	    vertical = str:gsub("([%z\1-\127\194-\244][\128-\191]*)", "%1\n")
    end
	
	return vertical:sub(1, #vertical-1)
end
	
local function CalcSparkLength(min, max, length)
	if length < max then
		return min + (length*(max-min)/max)
	else
		return max
	end
end

-- module data
local moduleData = {
	-- layout
	anchored    = false,
	anchorFrame = nil,
	horizontal  = true,
	ticks       = {
		XP         = {},
		Reputation = {},
	},
	tickPool  = {},
	tickCount = 0,
	bars      = {},
	
	-- data
	progress = {
		XP          = 0,
		Rested      = 0,
		Reputation  = 0,
	},

	text = {
		XP          = "",
		Reputation  = "",
	},
	
	-- settings
	settings = {
		Frame     = "dummy", 
		Inside    = false, 
		Inverse   = false, 
		Location  = "Top", 
		Jostle    = false, 
		Shadow    = true, 
		ShowXP    = true, 
		ShowRep   = true, 
		Spark     = 1, 
		Strata    = "HIGH", 
		Thickness = 2, 
		xOffset   = 0, 
		yOffset   = 0,
		Texture   = TEX_BAR,
		Ticks     = 0,
		Font      = FONT_DEFAULT,
		FontSize  = 6,
		MouseOver = false,
	},
	
	-- colors
	colors = {
		XP        = {r=0.0, g=0.4, b=0.9, a=1},
		Rest      = {r=1.0, g=0.2, b=1.0, a=1},
		None      = {r=0.0, g=0.0, b=0.0, a=1},
		Rep       = {r=1.0, g=0.2, b=1.0, a=1},
		NoRep     = {r=0.0, g=0.0, b=0.0, a=1},
		Border    = {r=0.0, g=0.0, b=0.0, a=1},
	},
	
	-- textures (aux list used in Reanchor)
	barTextures = {
	},
}

-- module handling
function Bar:OnInitialize()	
	-- init the module
	self:Initialize()
end

function Bar:OnEnable()
	-- empty
end

function Bar:OnDisable()
	-- empty
end

function Bar:Initialize()
	-- bar setup
	local mainFrame = CreateFrame("Frame", ADDON.."_Bar_MainFrame", UIParent)
	
	mainFrame:SetScript('OnEnter', function(self) Bar:OnMouseEnter() end)
	mainFrame:SetScript('OnLeave', function(self) Bar:OnMouseLeave() end)	

	local xpBar = CreateFrame("Frame", ADDON.."_Bar_XP", mainFrame)

	local tex     = xpBar:CreateTexture(ADDON.."_Tex_XP",       "BACKGROUND")	
	local restTex = xpBar:CreateTexture(ADDON.."_Tex_RestedXP", "BACKGROUND")	
	local noTex   = xpBar:CreateTexture(ADDON.."_Tex_NoXP",     "BACKGROUND")
	
	local spark = xpBar:CreateTexture(ADDON.."_Tex_XPSpark", "OVERLAY")
	spark:SetTexture(TEX_SPARK)
	spark:SetBlendMode("ADD")

	local spark2 = xpBar:CreateTexture(ADDON.."_Tex_XPSparkMini", "OVERLAY")
	spark2:SetTexture(TEX_SPARK2)
	spark2:SetBlendMode("ADD")

	local xpText = xpBar:CreateFontString(ADDON.."_Text_XP", "OVERLAY", FONT_TEMPLATE)
	xpText:SetJustifyH("CENTER")
	xpText:SetJustifyV("MIDDLE")
	xpText:SetPoint("CENTER", xpBar, "CENTER")
	
	local repBar = CreateFrame("Frame", ADDON.."_Bar_Reputation", mainFrame)

	local repTex   = repBar:CreateTexture(ADDON.."_Tex_Rep",   "BACKGROUND")
	local norepTex = repBar:CreateTexture(ADDON.."_Tex_NoRep", "BACKGROUND")

	local rspark = repBar:CreateTexture(ADDON.."_Tex_RepSpark", "OVERLAY")
	rspark:SetTexture(TEX_SPARK)
	rspark:SetBlendMode("ADD")

	local rspark2 = repBar:CreateTexture(ADDON.."_Tex_RepSparkMini", "OVERLAY")
	rspark2:SetTexture(TEX_SPARK2)
	rspark2:SetBlendMode("ADD")

	local repText = repBar:CreateFontString(ADDON.."_Text_Reputation", "OVERLAY", FONT_TEMPLATE)
	repText:SetJustifyH("CENTER")
	repText:SetJustifyV("MIDDLE")
	repText:SetPoint("CENTER", repBar, "CENTER")
	
	local border = CreateFrame("Frame", ADDON.."_Bar_Border", mainFrame)
	
	local borderTex = border:CreateTexture(ADDON.."_Tex_Border", "BACKGROUND")
	borderTex:SetTexture(TEX_BORDER)
	borderTex:SetAllPoints()
	
	moduleData.MainFrame   = mainFrame
	moduleData.XPBar       = xpBar
	moduleData.XPBarTex    = tex
	moduleData.Spark       = spark
	moduleData.Spark2      = spark2
	moduleData.NoXPTex     = noTex
	moduleData.RestedXPTex = restTex
	moduleData.XPText      = xpText
	moduleData.RepBar      = repBar
	moduleData.RepBarTex   = repTex
	moduleData.RepSpark    = rspark
	moduleData.RepSpark2   = rspark2
	moduleData.NoRepTex    = norepTex
	moduleData.RepText     = repText
	moduleData.Border      = border
	moduleData.BorderTex   = borderTex	
	
	moduleData.barTextures = { tex, noTex, restTex, spark, spark2, repTex, norepTex, rspark, rspark2, }

	-- aux vars to simplify tick handling
	moduleData.bars.XP         = moduleData.XPBar
	moduleData.bars.Reputation = moduleData.RepBar
	
	-- update colors
	for id in self:IterateColors() do
		self:UpdateColor(id)
	end
end

function Bar:Reanchor()
	local point, relpoint
	local offsetDir   = 0
	local visibleBars = 0
	
	self:Hide()
	
	-- detach from old frame
	moduleData.MainFrame:ClearAllPoints()
	
	moduleData.anchorFrame = self:GetSetting("Frame") and getglobal(self:GetSetting("Frame")) or nil
	
	if moduleData.anchorFrame == nil then
		return 
	end
	
	local location = self:GetSetting("Location")
	local inside   = self:GetSetting("Inside")
	local inverse  = self:GetSetting("Inverse")
		
	if location == "Top" or location == "Bottom" then
		moduleData.horizontal = true
	else
		moduleData.horizontal = false
	end

	-- assign anchor points
	if location == "Top" then
		relpoint = "TOPLEFT"
	elseif location == "Right" then
		relpoint = "BOTTOMRIGHT"
	else
		relpoint = "BOTTOMLEFT"
	end

	if moduleData.horizontal then
		if (location == "Top" and (not inside) ) or
			(location ~= "Top" and inside) then
			point = "BOTTOMLEFT"
			moduleData.BorderTex:SetTexCoord(unpack(ORIENTATION_FLIP_HORIZONTAL))
		else
			point = "TOPLEFT"
			moduleData.BorderTex:SetTexCoord(unpack(ORIENTATION_DEFAULT))
		end

		self:SetTexPoints("LEFT", "RIGHT", "TOP", "BOTTOM")		
	else
		if (location == "Right" and (not inside) ) or
			(location ~= "Right" and inside) then
			point = "BOTTOMLEFT"
			moduleData.BorderTex:SetTexCoord(unpack(ORIENTATION_ROTATE_LEFT_90))
		else
			point = "BOTTOMRIGHT"
			moduleData.BorderTex:SetTexCoord(unpack(ORIENTATION_ROTATE_RIGHT_90))
		end
		
		self:SetTexPoints("BOTTOM", "TOP", "LEFT", "RIGHT")		
	end
	
	local xOffset = self:GetSetting("xOffset")
	local yOffset = self:GetSetting("yOffset")
	
	-- attach to new frame
	moduleData.MainFrame:SetParent(moduleData.anchorFrame)
	moduleData.MainFrame:SetPoint(point, moduleData.anchorFrame, relpoint, xOffset, yOffset)
	
	-- setup bars
	self:SetupBars(location, inverse, inside)		
	
	-- setup sparks
	self:SetupSparks()

	-- setup ticks
	self:SetupTicks("XP")
	self:SetupTicks("Reputation")
	
	if self:GetSetting("MouseOver") then
		moduleData.XPText:Hide()
		moduleData.RepText:Hide()
	else
		moduleData.XPText:Show()
		moduleData.RepText:Show()
	end	

	-- refresh settings
	self:UpdateThickness()
	self:UpdateStrata()
	self:UpdateSparkIntensity()
	self:UpdateTexture()
	self:UpdateFont()
	
	-- (re)anchoring finished
	moduleData.anchored = true	
	
	self:Update()
	
	self:Show()
end

function Bar:SetupBars(side, inverse, inside)
	moduleData.XPBar:ClearAllPoints()
	moduleData.RepBar:ClearAllPoints()
	moduleData.Border:ClearAllPoints()

	local front, back, first, second
	
	if side == "Top" or side == "Bottom" then
		front = "LEFT"
		back  = "RIGHT"
		
		if side == "Bottom" then
			first  = inside and "BOTTOM" or "TOP"
			second = inside and "TOP" or "BOTTOM"
		else
			first  = inside and "TOP" or "BOTTOM"
			second = inside and "BOTTOM" or "TOP"
		end
	elseif side == "Left" or side == "Right" then
		front = "BOTTOM"
		back  = "TOP"
		
		if side == "Right" then
			first  = inside and "RIGHT" or "LEFT"
			second = inside and "LEFT" or "RIGHT"
		else
			first  = inside and "LEFT" or "RIGHT"
			second = inside and "RIGHT" or "LEFT"
		end
	else
		return
	end	
	
	local showXP     = self:GetSetting("ShowXP")
	local showRep    = self:GetSetting("ShowRep")
	local showBorder = self:GetSetting("Shadow")

	-- xp bar
	if showXP then
		moduleData.XPBar:SetPoint(front)
		moduleData.XPBar:SetPoint(back)
					
		if inverse and showRep then
			moduleData.XPBar:SetPoint(first, moduleData.RepBar, second)
		else
			moduleData.XPBar:SetPoint(first)
		end
		
		if not showBorder and (inverse or not showRep) then
			moduleData.XPBar:SetPoint(second)
		end
	end
	
	-- rep bar
	if showRep then
		moduleData.RepBar:SetPoint(front)
		moduleData.RepBar:SetPoint(back)
					
		if not inverse and showXP then
			moduleData.RepBar:SetPoint(first, moduleData.XPBar, second)
		else
			moduleData.RepBar:SetPoint(first)
		end
		
		if not showBorder and (not inverse or not showXP) then
			moduleData.RepBar:SetPoint(second)
		end
	end
	
	-- border
	if showBorder then
		moduleData.Border:SetPoint(front)
		moduleData.Border:SetPoint(back)
					
		if showXP or showRep then
			local neighbor = inverse and showXP and moduleData.XPBar or moduleData.RepBar
			
			moduleData.Border:SetPoint(first, neighbor, second)
		else
			moduleData.Border:SetPoint(first)
		end
		
		moduleData.Border:SetPoint(second)
	end
end

-- viewed in progress direction of bar: front and back are moving, left right are fixed
function Bar:SetTexPoints(front, back, left, right)
	moduleData.XPBarTex:ClearAllPoints()
	moduleData.RestedXPTex:ClearAllPoints()
	moduleData.NoXPTex:ClearAllPoints()
	moduleData.RepBarTex:ClearAllPoints()
	moduleData.NoRepTex:ClearAllPoints()

	-- left and right points are fixed
	moduleData.XPBarTex:SetPoint(left)
	moduleData.RestedXPTex:SetPoint(left)
	moduleData.NoXPTex:SetPoint(left)
	moduleData.RepBarTex:SetPoint(left)
	moduleData.NoRepTex:SetPoint(left)
	
	moduleData.XPBarTex:SetPoint(right)
	moduleData.RestedXPTex:SetPoint(right)
	moduleData.NoXPTex:SetPoint(right)
	moduleData.RepBarTex:SetPoint(right)
	moduleData.NoRepTex:SetPoint(right)
	
	-- textures are attached side by side
	moduleData.XPBarTex:SetPoint(front)
	moduleData.RestedXPTex:SetPoint(front, moduleData.XPBarTex, back)
	moduleData.NoXPTex:SetPoint(front, moduleData.RestedXPTex, back)
	moduleData.NoXPTex:SetPoint(back)
	
	moduleData.RepBarTex:SetPoint(front)
	moduleData.NoRepTex:SetPoint(front, moduleData.RepBarTex, back)
	moduleData.NoRepTex:SetPoint(back)	
end

function Bar:SetupSparks()	
	local back, xOffset, yOffset, orientation
	
	if moduleData.horizontal then
		back = "RIGHT"
		xOffset = 1
		yOffset = 0
		orientation = ORIENTATION_DEFAULT
	else
		back = "TOP"
		xOffset = 0
		yOffset = 1
		orientation = ORIENTATION_ROTATE_LEFT_90
	end
	
	-- set texture orientation
	moduleData.Spark:SetTexCoord(unpack(orientation))
	moduleData.Spark2:SetTexCoord(unpack(orientation))
	moduleData.RepSpark:SetTexCoord(unpack(orientation))
	moduleData.RepSpark2:SetTexCoord(unpack(orientation))
	
	-- attach sparks to the backside of XP/RepBarTex
	moduleData.Spark:ClearAllPoints()
	moduleData.Spark:SetPoint(back, moduleData.XPBarTex, back, xOffset*4, yOffset*4)

	moduleData.Spark2:ClearAllPoints()
	moduleData.Spark2:SetPoint(back, moduleData.XPBarTex, back, xOffset*1, yOffset*1)
	
	moduleData.RepSpark:ClearAllPoints()
	moduleData.RepSpark:SetPoint(back, moduleData.RepBarTex, back, xOffset*4, yOffset*4)

	moduleData.RepSpark2:ClearAllPoints()
	moduleData.RepSpark2:SetPoint(back, moduleData.RepBarTex, back, xOffset*1, yOffset*1)
end

function Bar:UpdateTextureCoords(tex, from, to)
	if not tex then
		return
	end

	if moduleData.horizontal then
		tex:SetTexCoord(from, 0, from, 1, to, 0, to,   1)
	else
		tex:SetTexCoord(to,   0, from, 0, to, 1, from, 1)
	end
end

function Bar:Update()
	local front, back, barlength

	if moduleData.anchorFrame == nil then
		return
	end
	
	local setLength
	
	if moduleData.horizontal then
		front = "LEFT"
		back  = "RIGHT"
	
		barlength = moduleData.anchorFrame:GetWidth()

		setLength = "SetWidth"
	else
		front = "BOTTOM"
		back  = "TOP"
	
		barlength = moduleData.anchorFrame:GetHeight()

		setLength = "SetHeight"
	end

	-- adjust to possible changes in parent frame dimensions
	moduleData.MainFrame[setLength](moduleData.MainFrame, barlength)
	-- TODO: check if it can be skipped
	moduleData.XPBar[setLength](moduleData.XPBar, barlength)
	moduleData.RepBar[setLength](moduleData.RepBar, barlength)
	moduleData.Border[setLength](moduleData.Border, barlength)
	
	if self:GetSetting("ShowXP") then
		local xp     = self:GetProgress("XP")
		local rested = self:GetProgress("Rested")
	
		if xp + rested > 1 then
			rested = 1 - xp
		end
	
		local xpLength   = xp == 0 and EPSILON or xp * barlength
		local restLength = rested == 0 and EPSILON or rested * barlength
	
		-- bar sections
		moduleData.XPBarTex[setLength](moduleData.XPBarTex, xpLength)
		moduleData.RestedXPTex[setLength](moduleData.RestedXPTex, restLength)
		
		self:UpdateTextureCoords(moduleData.XPBarTex, 0, xp)
		self:UpdateTextureCoords(moduleData.RestedXPTex, xp, xp+rested)
		self:UpdateTextureCoords(moduleData.NoXPTex, xp+rested, 1)
	
		-- spark
		-- resize to avoid excessive overlapping
		moduleData.Spark[setLength](moduleData.Spark, CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, xpLength))
		moduleData.Spark2[setLength](moduleData.Spark2, CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, xpLength))	
		
		-- ticks
		self:UpdateTicks("XP", barlength, front)
		
		local text = self:GetText("XP")
		
		if not moduleData.horizontal then
			text = vertical(text)
		end
	
		-- text
		moduleData.XPText:SetText(text)
			
		if moduleData.XPText:IsShown() then
			moduleData.XPText:Show()
		end
	end

	if self:GetSetting("ShowRep") then
		local reputation = self:GetProgress("Reputation")
		local length = reputation == 0 and EPSILON or reputation * barlength
	
		-- bar sections
		moduleData.RepBarTex[setLength](moduleData.RepBarTex, length)

		self:UpdateTextureCoords(moduleData.RepBarTex, 0, reputation)
		self:UpdateTextureCoords(moduleData.NoRepTex, reputation, 1)

		-- spark
		-- resize to avoid excessive overlapping
		moduleData.RepSpark[setLength](moduleData.RepSpark, CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, length))
		moduleData.RepSpark2[setLength](moduleData.RepSpark2, CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, length))	

		-- ticks
		self:UpdateTicks("Reputation", barlength, front)
		
		-- text
		local text = self:GetText("Reputation")
		
		if not moduleData.horizontal then
			text = vertical(text)
		end
	
		moduleData.RepText:SetText(text)
			
		if moduleData.RepText:IsShown() then
			moduleData.RepText:Show()
		end
	end
end

function Bar:Show()
	self:Hide()

	local jostle    = self:GetSetting("Jostle")
	local location  = self:GetSetting("Location")
	
	if self:GetSetting("ShowXP") then
		moduleData.XPBar:Show()

		-- register for jostle
		if Jostle and jostle and moduleData.horizontal then
			if location == "Bottom" then
				Jostle:RegisterTop(moduleData.XPBar)
			else
				Jostle:RegisterBottom(moduleData.XPBar)
			end
		end		
	end
	
	if self:GetSetting("ShowRep") then
		moduleData.RepBar:Show()

		-- register for jostle
		if Jostle and jostle and moduleData.horizontal then
			if location == "Bottom" then
				Jostle:RegisterTop(moduleData.RepBar)
			else
				Jostle:RegisterBottom(moduleData.RepBar)
			end
		end
	end
	
	if self:GetSetting("Shadow") then
		moduleData.Border:Show()
	end

	moduleData.MainFrame:Show()
	
	if Jostle then Jostle:Refresh() end	
end

function Bar:Hide()
	-- remove from jostle
	if Jostle then
		Jostle:Unregister(moduleData.XPBar)
		Jostle:Unregister(moduleData.RepBar)
	end

	moduleData.XPBar:Hide()
	moduleData.RepBar:Hide()
	moduleData.Border:Hide()
	
	moduleData.MainFrame:Hide() 
	
	if Jostle then Jostle:Refresh() end	
end

function Bar:OnMouseEnter()
	if self:GetSetting("MouseOver") then
		if not moduleData.XPText:IsShown() then
			moduleData.XPText:Show()
		end
		if not moduleData.RepText:IsShown() then
			moduleData.RepText:Show()
		end
	end
end

function Bar:OnMouseLeave()
	if self:GetSetting("MouseOver") then
		if moduleData.XPText:IsShown() then
			moduleData.XPText:Hide()
		end
		if moduleData.RepText:IsShown() then
			moduleData.RepText:Hide()
		end
	end
end

-- ticks
function Bar:SetupTicks(id)
	if not moduleData.bars[id] then
		return
	end
	
	local ticks = self:GetSetting("Ticks")

	-- create all required ticks
	for i = #moduleData.ticks[id] + 1, ticks do
		local tick = self:NewTick(moduleData.bars[id])
		
		moduleData.ticks[id][i] = tick
	end
	
	-- remove surplus ticks
	for i = #moduleData.ticks[id], ticks + 1, -1 do
		self:DelTick(moduleData.ticks[id][i])
		moduleData.ticks[id][i] = nil		
	end	
end

function Bar:NewTick(bar)
	local newTick = next(moduleData.tickPool)
	
	if not newTick then
		moduleData.tickCount = moduleData.tickCount + 1
		newTick = bar:CreateTexture(ADDON.."_Tick_"..tostring(moduleData.tickCount), "OVERLAY")
		newTick:SetBlendMode("ADD")	
	else
		newTick:SetParent(bar)
		moduleData.tickPool[newTick] = nil
	end
	
	newTick:Show()
	
	return newTick
end

function Bar:DelTick(tick)
	if tick then
		tick:Hide()
		moduleData.tickPool[tick] = true
	end
end

function Bar:UpdateTicks(id, length, front)
	if not moduleData.ticks[id] or #moduleData.ticks[id] == 0 then
		return
	end
	
	local progress = moduleData.progress[id] * length
	local count    = #moduleData.ticks[id]
	local interval = length / (count + 1)

	for i = 1, count do
		local tick = moduleData.ticks[id][i]
		
		local pos = i * interval
		
		if moduleData.horizontal then
			tick:SetPoint("CENTER", moduleData.bars[id], front, pos, 0)
		else
			tick:SetPoint("CENTER", moduleData.bars[id], front, 0,   pos)
		end

		if pos <= progress then
			tick:SetTexture(TICK_ACTIVE_COLOR.r, TICK_ACTIVE_COLOR.g, TICK_ACTIVE_COLOR.b, TICK_ACTIVE_COLOR.a)
		else
			tick:SetTexture(TICK_INACTIVE_COLOR.r, TICK_INACTIVE_COLOR.g, TICK_INACTIVE_COLOR.b, TICK_INACTIVE_COLOR.a)
		end
	end
end

-- properties
function Bar:IsAnchored()
	return moduleData.anchored
end

function Bar:UpdateThickness()
	local thickness = self:GetSetting("Thickness")
	local mainThickness = 0
	
	if self:GetSetting("ShowXP") then
		mainThickness = mainThickness + thickness
	end	
	
	if self:GetSetting("ShowRep") then
		mainThickness = mainThickness + thickness
	end	
	
	if self:GetSetting("Shadow") then
		mainThickness = mainThickness + BORDER_HEIGHT
	end	
	
	local setThickness
	local setTickWidth
	
	if moduleData.horizontal then
		setThickness = "SetHeight"
		setTickWidth = "SetWidth"
	else
		setThickness = "SetWidth"
		setTickWidth = "SetHeight"
	end
	
	thickness = thickness == 0 and EPSILON or thickness
	mainThickness = mainThickness == 0 and EPSILON or mainThickness
	
	moduleData.MainFrame[setThickness](moduleData.MainFrame, mainThickness)

	moduleData.XPBar[setThickness](moduleData.XPBar, thickness)
	moduleData.Spark[setThickness](moduleData.Spark, thickness * 2 + 12)
	moduleData.Spark2[setThickness](moduleData.Spark2, thickness * 8)

	moduleData.RepBar[setThickness](moduleData.RepBar, thickness)
	moduleData.RepSpark[setThickness](moduleData.RepSpark, thickness * 2 + 12)
	moduleData.RepSpark2[setThickness](moduleData.RepSpark2, thickness * 8)
	
	for _, ticks in pairs(moduleData.ticks) do
		for _, tick in ipairs(ticks) do
			tick[setThickness](tick, thickness)
			tick[setTickWidth](tick, TICK_WIDTH)
		end
	end
	
	moduleData.Border[setThickness](moduleData.Border, BORDER_HEIGHT)	
end

function Bar:UpdateColor(id)
	local r, g, b, a = self:GetColor(id)

	local tex
	local spark
	
	if id == "XP" then
		tex   = moduleData.XPBarTex
		spark = moduleData.Spark
	elseif id == "Rest" then
		tex = moduleData.RestedXPTex
	elseif id == "None" then
		tex = moduleData.NoXPTex
	elseif id == "Rep" then
		tex   = moduleData.RepBarTex
		spark = moduleData.RepSpark
	elseif id == "NoRep" then
		tex = moduleData.NoRepTex
	elseif id == "Border" then
		tex = moduleData.BorderTex
	end
	
	if tex ~= nil then
		tex:SetVertexColor(r, g, b, a)
	end

	if spark ~= nil then
		spark:SetVertexColor(r, g, b, self:GetSetting("Spark"))
	end
end

function Bar:UpdateSparkIntensity()
	local intensity = self:GetSetting("Spark")
	
	moduleData.Spark:SetAlpha(intensity)
	moduleData.Spark2:SetAlpha(intensity)
	moduleData.RepSpark:SetAlpha(intensity)
	moduleData.RepSpark2:SetAlpha(intensity)
end

function Bar:UpdateStrata()
	local strata = self:GetSetting("Strata")
	
	-- TODO: all frames have to have their strata set? or do children inherit parents strata?
	moduleData.MainFrame:SetFrameStrata(strata)
	moduleData.XPBar:SetFrameStrata(strata)
	moduleData.RepBar:SetFrameStrata(strata)
	moduleData.Border:SetFrameStrata(strata)
end

function Bar:UpdateTexture()
	if not LibSharedMedia then
		return
	end
	
	local texture = self:GetSetting("Texture")
	
	texture = LibSharedMedia:Fetch("statusbar", texture)

	if not texture then
		texture = TEX_BAR
	end

	moduleData.XPBarTex:SetTexture(texture)
	moduleData.RestedXPTex:SetTexture(texture)
	moduleData.NoXPTex:SetTexture(texture)
	moduleData.RepBarTex:SetTexture(texture)
	moduleData.NoRepTex:SetTexture(texture)
end

function Bar:UpdateFont()
	if not LibSharedMedia then
		return
	end
	
	local fontName = self:GetSetting("Font") or FONT_NAME_DEFAULT
	
	font = LibSharedMedia:Fetch("font", fontName) or FONT_DEFAULT

	local size = self:GetSetting("FontSize") or FONT_SIZE_DEFAULT

	-- setup bar texts
	moduleData.XPText:SetFont(font, size, FONT_STYLE)
	moduleData.RepText:SetFont(font, size, FONT_STYLE)
end

function Bar:GetProgress(bar)
	return moduleData.progress[bar] or 0
end

-- set bar progress in fraction of 1
function Bar:SetProgress(bar, fraction)
	if not bar or not fraction then
		return
	end
	
	if fraction < 0 then
		fraction = 0
	elseif fraction > 1 and bar ~= "Rested" then
		fraction = 1
	end
	
	moduleData.progress[bar] = fraction
end

-- settings
function Bar:GetSetting(option)
	return moduleData.settings[option]
end

function Bar:SetSetting(option, value, skipReanchor)
	local current = self:GetSetting(option)
	
	if current == value then
		return
	end
	
	moduleData.settings[option] = value
	
	if not skipReanchor then
		self:Reanchor()
	end
end

function Bar:GetColor(id)
	local color = moduleData.colors[id] or {r = 0, g = 0, b = 0, a = 0}

	return color.r, color.g, color.b, color.a
end

function Bar:SetColor(id, r, g, b, a)
	if not moduleData.colors[id] then
		return
	end

	moduleData.colors[id].r = r
	moduleData.colors[id].g = g
	moduleData.colors[id].b = b
	moduleData.colors[id].a = a
	
	self:UpdateColor(id)
end

function Bar:GetText(bar)
	return moduleData.text[bar]
end

function Bar:SetText(bar, text)
	if not bar then
		return
	end

	if not text then
		text = ""
	end
	
	local current = self:GetText(bar)

	if current == value then
		return
	end
	
	moduleData.text[bar] = text
end

-- iterators

-- function Bar:IterateSettings()
-- function Bar:IterateColors()
do --Do-end block for iterators
	local tablestack = setmetatable({}, {__mode = 'k'})
	
	local function KeyOnlyIter(t, prestate)
		if not t then 
			return nil 
		end

		if t.iterator then
			local key = t.iterator(t.t, prestate)

			if key then
				return key
			end				
		end
		
		tablestack[t] = true
		return nil, nil		
	end
	
	local function IterateTable(data)
		local tbl = next(tablestack) or {}		
		tablestack[tbl] = nil
		
		local iterator, t, state = pairs(data)
		
		tbl.iterator   = iterator
		tbl.t          = t
		
		return KeyOnlyIter, tbl, state
	end
	
	function Bar:IterateSettings()
		return IterateTable(moduleData.settings)
	end

	function Bar:IterateColors()
		return IterateTable(moduleData.colors)
	end	
end

-- test
function Bar:Debug(msg)
	Addon:Debug("(Bar) " .. tostring(msg))
end
