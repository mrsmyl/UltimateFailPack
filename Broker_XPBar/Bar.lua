local _G = _G

local ADDON = ...

local Addon = _G.BrokerXPBar

-- rearrangement of blizzard's frames
local Jostle = LibStub:GetLibrary("LibJostle-3.0", true)

local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

-- imports
local ipairs = _G.ipairs
local unpack = _G.unpack

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

local SIDES = {"TOP", "BOTTOM", "LEFT", "RIGHT"}

local FONT_DEFAULT = "TextStatusBarText"
local FONT_STYLE   = "OUTLINE"

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

-- the bar frame
local Bar = {
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
	},
	
	-- textures (aux list used in Reanchor)
	barTextures = {
	},
}

Addon.Bar = Bar

-- utilities
local function CalcSparkLength(min, max, length)
	if length < max then
		return min + (length*(max-min)/max)
	else
		return max
	end
end

-- bar
function Bar:Initialize()
	local r, g, b, a
	
	local intensity = self:GetSetting("Spark")
	
	-- bar setup
	local MainFrame = CreateFrame("Frame", ADDON.."_Bar_MainFrame", UIParent)
	
	MainFrame:SetScript('OnEnter', function(self) Bar:OnMouseEnter() end)
	MainFrame:SetScript('OnLeave', function(self) Bar:OnMouseLeave() end)	
	
	local XPBar = CreateFrame("Frame", ADDON.."_Bar_XPBar", MainFrame)

	r, g, b, a = self:GetColor("XP")
	
	local tex = XPBar:CreateTexture(ADDON.."_Tex_BarTex", "ARTWORK")
	tex:SetTexture(TEX_BAR)
	tex:SetVertexColor(r, g, b, a)
	
	local spark = XPBar:CreateTexture(ADDON.."_Tex_XPSpark", "OVERLAY")
	spark:SetTexture(TEX_SPARK)
	spark:SetVertexColor(r, g, b, intensity)
	spark:SetBlendMode("ADD")

	local spark2 = XPBar:CreateTexture(ADDON.."_Tex_XPSpark2", "OVERLAY")
	spark2:SetTexture(TEX_SPARK2)
	spark2:SetBlendMode("ADD")

	r, g, b, a = self:GetColor("Rest")
	
	local resttex = XPBar:CreateTexture(ADDON.."_Tex_RestedXPTex", "BORDER")
	resttex:SetTexture(TEX_BAR)
	resttex:SetVertexColor(r, g, b, a)

	r, g, b, a = self:GetColor("None")
	
	local notex = XPBar:CreateTexture(ADDON.."_Tex_NoXPTex", "BACKGROUND")
	notex:SetTexture(TEX_BAR)
	notex:SetVertexColor(r, g, b, a)
	notex:SetAllPoints(XPBar)
	
	local xptext = XPBar:CreateFontString(ADDON.."_XPText", "OVERLAY", FONT_DEFAULT)
	--xptext:SetWidth(600) -- just make it big enough
	--xptext:SetHeight(600) -- just make it big enough
	xptext:SetJustifyH("CENTER")
	xptext:SetJustifyV("MIDDLE")
	xptext:SetPoint("CENTER", XPBar, "CENTER")
	
	local RepBar = CreateFrame("Frame", ADDON.."_Bar_RepBar", MainFrame)

	r, g, b, a = self:GetColor("Rep")
	
	local reptex = RepBar:CreateTexture(ADDON.."_Tex_RepTex", "ARTWORK")
	reptex:SetTexture(TEX_BAR)
	reptex:SetVertexColor(r, g, b, a)

	local rspark = RepBar:CreateTexture(ADDON.."_Tex_RepSpark", "OVERLAY")
	rspark:SetTexture(TEX_SPARK)
	rspark:SetVertexColor(r, g, b, intensity)
	rspark:SetBlendMode("ADD")

	local rspark2 = RepBar:CreateTexture(ADDON.."_Tex_RepSpark2", "OVERLAY")
	rspark2:SetTexture(TEX_SPARK2)
	rspark2:SetBlendMode("ADD")

	r, g, b, a = self:GetColor("NoRep")
	
	local noreptex = RepBar:CreateTexture(ADDON.."_Tex_NoRepTex", "BACKGROUND")
	noreptex:SetTexture(TEX_BAR)
	noreptex:SetVertexColor(r, g, b, a)
	noreptex:SetAllPoints(RepBar)

	local reptext = RepBar:CreateFontString(ADDON.."_RepText", "OVERLAY", FONT_DEFAULT)
	reptext:SetJustifyH("CENTER")
	reptext:SetJustifyV("MIDDLE")
	reptext:SetPoint("CENTER", RepBar, "CENTER")
	
	local Border = CreateFrame("Frame", ADDON.."_Bar_Border", MainFrame)
	
	local bordtex = Border:CreateTexture(ADDON.."_Tex_BorderTex", "BACKGROUND")
	bordtex:SetTexture(TEX_BORDER)
	bordtex:SetVertexColor(0, 0, 0, 1)
	bordtex:SetAllPoints(Border)

	self.MainFrame   = MainFrame
	self.XPBar       = XPBar
	self.XPBarTex    = tex
	self.Spark       = spark
	self.Spark2      = spark2
	self.NoXPTex     = notex
	self.RestedXPTex = resttex
	self.XPText      = xptext
	self.RepBar      = RepBar
	self.RepBarTex   = reptex
	self.RepSpark    = rspark
	self.RepSpark2   = rspark2
	self.NoRepTex    = noreptex
	self.RepText     = reptext
	self.Border      = Border
	self.BorderTex   = bordtex	
	
	self.barTextures = { tex, notex, resttex, spark, spark2, reptex, noreptex, rspark, rspark2, }

	-- aux vars to simplify tick handling
	self.bars.XP         = self.XPBar
	self.bars.Reputation = self.RepBar	
end

function Bar:Reanchor()
	local point, relpoint
	local offsetDir   = 0
	local visibleBars = 0
	
	self.anchorFrame = self:GetSetting("Frame") and getglobal(self:GetSetting("Frame")) or nil
	
	if self.anchorFrame == nil then
		self:Hide()
		return 
	end
	
	local location = self:GetSetting("Location")
	local inside   = self:GetSetting("Inside")
	local inverse  = self:GetSetting("Inverse")
		
	if location == "Top" or location == "Bottom" then
		self.horizontal = true
	else
		self.horizontal = false
	end

	-- assign anchor points
	if location == "Top" then
		relpoint = "TOPLEFT"
	elseif location == "Right" then
		relpoint = "BOTTOMRIGHT"
	else
		relpoint = "BOTTOMLEFT"
	end

	if self.horizontal then
		if (location == "Top" and (not inside) ) or
			(location ~= "Top" and inside) then
			point = "BOTTOMLEFT"
			self.BorderTex:SetTexCoord(unpack(ORIENTATION_FLIP_HORIZONTAL))
			offsetDir = 1
		else
			point = "TOPLEFT"
			self.BorderTex:SetTexCoord(unpack(ORIENTATION_DEFAULT))
			offsetDir = -1
		end

		for _, tex in ipairs(self.barTextures) do
			tex:SetTexCoord(unpack(ORIENTATION_DEFAULT))
		end
	else
		if (location == "Right" and (not inside) ) or
			(location ~= "Right" and inside) then
			point = "BOTTOMLEFT"
			self.BorderTex:SetTexCoord(unpack(ORIENTATION_ROTATE_LEFT_90))
			offsetDir = 1
		else
			point = "BOTTOMRIGHT"
			self.BorderTex:SetTexCoord(unpack(ORIENTATION_ROTATE_RIGHT_90))
			offsetDir = -1
		end

		for _, tex in ipairs(self.barTextures) do
			tex:SetTexCoord(unpack(ORIENTATION_ROTATE_LEFT_90))
		end
	end
	
	-- detach from old frame
	self.MainFrame:ClearAllPoints()
	self.XPBar:ClearAllPoints()
	self.RepBar:ClearAllPoints()
	self.Border:ClearAllPoints()
	
	local thickness = self:GetSetting("Thickness")
	
	-- attach to new frame
	local xOffset = self:GetSetting("xOffset")
	local yOffset = self:GetSetting("yOffset")
	
	self:AttachBarToFrame(self.MainFrame, point, self.anchorFrame, relpoint, xOffset, yOffset)
	
	if self:GetSetting("ShowXP") then
		local offset = 0
		
		if inverse and self:GetSetting("ShowRep") then
			offset = offsetDir * thickness
		end
		
		if self.horizontal then
			xOffset = 0
			yOffset = offset
		else
			xOffset = offset
			yOffset = 0
		end
		
		self:AttachBarToFrame(self.XPBar, point, self.MainFrame, point, xOffset, yOffset)
		
		visibleBars = visibleBars + 1
	end
		
	if self:GetSetting("ShowRep") then
		local offset = 0
		
		if not inverse and self:GetSetting("ShowXP") then
			offset = offsetDir * thickness
		end
		
		if self.horizontal then
			xOffset = 0
			yOffset = offset
		else
			xOffset = offset
			yOffset = 0
		end

		self:AttachBarToFrame(self.RepBar, point, self.MainFrame, point, xOffset, yOffset)

		visibleBars = visibleBars + 1
	end
		
	if self:GetSetting("Shadow") then
		if self.horizontal then
			xOffset = 0
			yOffset = visibleBars * thickness * offsetDir
		else
			xOffset = visibleBars * thickness * offsetDir
			yOffset = 0
		end

		self:AttachBarToFrame(self.Border, point, self.MainFrame, point, xOffset, yOffset)
	end
	
	-- reset tex points
	self.Spark:ClearAllPoints()
	self.Spark2:ClearAllPoints()

	self:RestoreTexturePoints(self.XPBarTex,    self.XPBar)
	self:RestoreTexturePoints(self.RestedXPTex, self.XPBar)
	
	self.RepSpark:ClearAllPoints()
	self.RepSpark2:ClearAllPoints()

	self:RestoreTexturePoints(self.RepBarTex, self.RepBar)

	-- setup ticks
	self:SetupTicks("XP")
	self:SetupTicks("Reputation")
	
	-- restore default dimensions for border and spark
	if self.horizontal then
		self.Spark:SetWidth(SPARK_LEN_MAX)
		self.Spark2:SetWidth(SPARK2_LEN_MAX)

		self.RepSpark:SetWidth(SPARK_LEN_MAX)
		self.RepSpark2:SetWidth(SPARK2_LEN_MAX)

		self.Border:SetHeight(BORDER_HEIGHT)
	else
		self.Spark:SetHeight(SPARK_LEN_MAX)
		self.Spark2:SetHeight(SPARK2_LEN_MAX)

		self.RepSpark:SetHeight(SPARK_LEN_MAX)
		self.RepSpark2:SetHeight(SPARK2_LEN_MAX)

		self.Border:SetWidth(BORDER_HEIGHT)
	end
	
	if self:GetSetting("MouseOver") then
		self.XPText:Hide()
		self.RepText:Hide()
	else
		self.XPText:Show()
		self.RepText:Show()
	end	

	-- refresh settings
	self:UpdateThickness()
	self:UpdateStrata()
	self:UpdateSparkIntensity()
	self:UpdateTexture()
	self:UpdateFont()
	
	-- (re)anchoring finished
	self.anchored = true	
	
	self:Show()

	self:Update()

	if Jostle then Jostle:Refresh() end
end

function Bar:RestoreTexturePoints(tex, bar)
	if not tex or not bar then
		return
	end

	tex:ClearAllPoints()
	
	for _, side in ipairs(SIDES) do
		tex:SetPoint(side, bar, side)
	end
end

function Bar:AttachBarToFrame(bar, point, frame, relpoint, xOffset, yOffset)
	if not bar then
		return
	end
	
	bar:SetParent(frame)
	bar:SetPoint(point, frame, relpoint, xOffset, yOffset)
end

function Bar:TextureSetPoint(tex, bar, point, offset)
	if not tex then
		return
	end

	local xOffset, yOffset
	
	if self.horizontal then
		xOffset = offset
		yOffset = 0
	else
		xOffset = 0
		yOffset = offset
	end
	
	tex:SetPoint(point, bar, point, xOffset, yOffset)
end

function Bar:Update()
	local length
	local front, back, barlength

	if self.anchorFrame == nil then
		return
	end
	
	if self.horizontal then
		front = "LEFT"
		back  = "RIGHT"
	
		barlength = self.anchorFrame:GetWidth()

		-- adjust to possible changes in parent frame dimensions
		self.MainFrame:SetWidth(barlength)
		self.XPBar:SetWidth(barlength)
		self.RepBar:SetWidth(barlength)
		self.Border:SetWidth(barlength)
	else
		front = "BOTTOM"
		back  = "TOP"
	
		barlength = self.anchorFrame:GetHeight()

		-- adjust to possible changes in parent frame dimensions
		self.MainFrame:SetHeight(barlength)
		self.XPBar:SetHeight(barlength)
		self.RepBar:SetHeight(barlength)
		self.Border:SetHeight(barlength)
	end

	if self:GetSetting("ShowXP") then
		length = self.progress.XP * barlength
		
		self:TextureSetPoint(self.XPBarTex, self.XPBar, back, length-barlength)
		self:TextureSetPoint(self.RestedXPTex, self.XPBar, front, length)

		self:TextureSetPoint(self.Spark, self.XPBar, back, length-barlength+4)
		self:TextureSetPoint(self.Spark2, self.XPBar, back, length-barlength+1)
		
		-- resize spark to avoid excessive overlapping
		if self.horizontal then
			self.Spark:SetWidth(CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, length))
			self.Spark2:SetWidth(CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, length))	
		else
			self.Spark:SetHeight(CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, length))
			self.Spark2:SetHeight(CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, length))	
		end
		
		if self.progress.XP + self.progress.Rested > 1 then
			length = barlength
		else
			length = length + self.progress.Rested * barlength
		end

		self:TextureSetPoint(self.RestedXPTex, self.XPBar, back, length-barlength)

		self:UpdateTicks("XP", barlength, front)
		
		local text = self:GetText("XP")
		
		if not self.horizontal then
			text = vertical(text)
		end
	
		self.XPText:SetText(text)
			
		if self.XPText:IsShown() then
			self.XPText:Show()
		end
	end

	if self:GetSetting("ShowRep") then
		length = self.progress.Reputation * barlength
		
		self:TextureSetPoint(self.RepBarTex, self.RepBar, back, length-barlength)

		self:TextureSetPoint(self.RepSpark, self.RepBar, back, length-barlength+4)
		self:TextureSetPoint(self.RepSpark2, self.RepBar, back, length-barlength+1)
		
		-- resize spark to avoid excessive overlapping
		if self.horizontal then
			self.RepSpark:SetWidth(CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, length))
			self.RepSpark2:SetWidth(CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, length))	
		else
			self.RepSpark:SetHeight(CalcSparkLength(SPARK_LEN_MIN, SPARK_LEN_MAX, length))
			self.RepSpark2:SetHeight(CalcSparkLength(SPARK2_LEN_MIN, SPARK2_LEN_MAX, length))	
		end

		self:UpdateTicks("Reputation", barlength, front)
		
		local text = self:GetText("Reputation")
		
		if not self.horizontal then
			text = vertical(text)
		end
	
		self.RepText:SetText(text)
			
		if self.RepText:IsShown() then
			self.RepText:Show()
		end
	end
end

function Bar:Show()
	local height = 0
	
	self:Hide()

	local jostle    = self:GetSetting("Jostle")
	local location  = self:GetSetting("Location")
	
	if self:GetSetting("ShowXP") then
		self.XPBar:Show()

		-- register for jostle
		if Jostle and jostle and self.horizontal then
			if location == "Bottom" then
				Jostle:RegisterTop(self.XPBar)
			else
				Jostle:RegisterBottom(self.XPBar)
			end
		end		
	end
	
	if self:GetSetting("ShowRep") then
		self.RepBar:Show()

		-- register for jostle
		if Jostle and jostle and self.horizontal then
			if location == "Bottom" then
				Jostle:RegisterTop(self.RepBar)
			else
				Jostle:RegisterBottom(self.RepBar)
			end
		end
	end
	
	if self:GetSetting("Shadow") then
		self.Border:Show()
	end

	self.MainFrame:Show() 
end

function Bar:Hide()
	-- remove from jostle
	if Jostle then
		Jostle:Unregister(self.XPBar)
		Jostle:Unregister(self.RepBar)
	end

	self.XPBar:Hide()
	self.Border:Hide()
	self.RepBar:Hide()
	
	self.MainFrame:Hide() 
end

function Bar:OnMouseEnter()
	if self:GetSetting("MouseOver") then
		if not self.XPText:IsShown() then
			self.XPText:Show()
		end
		if not self.RepText:IsShown() then
			self.RepText:Show()
		end
	end
end

function Bar:OnMouseLeave()
	if self:GetSetting("MouseOver") then
		if self.XPText:IsShown() then
			self.XPText:Hide()
		end
		if self.RepText:IsShown() then
			self.RepText:Hide()
		end
	end
end

-- ticks
function Bar:SetupTicks(id)
	if not self.bars[id] then
		return
	end
	
	local ticks = self:GetSetting("Ticks")

	-- create all required ticks
	for i = #self.ticks[id] + 1, ticks do
		local tick = self:NewTick(self.bars[id])
		
		self.ticks[id][i] = tick
	end
	
	-- remove surplus ticks
	for i = #self.ticks[id], ticks + 1, -1 do
		self:DelTick(self.ticks[id][i])
		self.ticks[id][i] = nil		
	end	
end

function Bar:NewTick(bar)
	local newTick = next(self.tickPool)
	
	if not newTick then
		self.tickCount = self.tickCount + 1
		newTick = bar:CreateTexture(ADDON.."_Tick_"..tostring(self.tickCount), "OVERLAY")
		newTick:SetBlendMode("ADD")	
	else
		newTick:SetParent(bar)
		self.tickPool[newTick] = nil
	end
	
	newTick:Show()
	
	return newTick
end

function Bar:DelTick(tick)
	if tick then
		tick:Hide()
		self.tickPool[tick] = true
	end
end

function Bar:UpdateTicks(id, length, front)
	if not self.ticks[id] or #self.ticks[id] == 0 then
		return
	end
	
	local progress = self.progress[id] * length
	local count    = #self.ticks[id]
	local interval = length / (count + 1)

	for i = 1, count do
		local tick = self.ticks[id][i]
		
		local pos = i * interval
		
		if self.horizontal then
			tick:SetPoint("CENTER", self.bars[id], front, pos, 0)
		else
			tick:SetPoint("CENTER", self.bars[id], front, 0,   pos)
		end

		if pos <= progress then
			tick:SetTexture(TICK_ACTIVE_COLOR.r, TICK_ACTIVE_COLOR.g, TICK_ACTIVE_COLOR.b, TICK_ACTIVE_COLOR.a)
		else
			tick:SetTexture(TICK_INACTIVE_COLOR.r, TICK_INACTIVE_COLOR.g, TICK_INACTIVE_COLOR.b, TICK_INACTIVE_COLOR.a)
		end
	end
end

-- properties
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
	
	if self.horizontal then
		self.MainFrame:SetHeight(mainThickness)

		self.XPBar:SetHeight(thickness)
		self.Spark:SetHeight(thickness * 2 + 12)
		self.Spark2:SetHeight(thickness * 8)

		self.RepBar:SetHeight(thickness)
		self.RepSpark:SetHeight(thickness * 2 + 12)
		self.RepSpark2:SetHeight(thickness * 8)
		
		for _, tick in ipairs(self.ticks.XP) do
			tick:SetHeight(thickness)
			tick:SetWidth(TICK_WIDTH)
		end

		for _, tick in ipairs(self.ticks.Reputation) do
			tick:SetHeight(thickness)
			tick:SetWidth(TICK_WIDTH)
		end
	else
		self.MainFrame:SetWidth(mainThickness)
		
		self.XPBar:SetWidth(thickness)
		self.Spark:SetWidth(thickness * 2 + 12)
		self.Spark2:SetWidth(thickness * 8)

		self.RepBar:SetWidth(thickness)
		self.RepSpark:SetWidth(thickness * 2 + 12)
		self.RepSpark2:SetWidth(thickness * 8)
		
		for _, tick in ipairs(self.ticks.XP) do
			tick:SetWidth(thickness)
			tick:SetHeight(TICK_WIDTH)
		end

		for _, tick in ipairs(self.ticks.Reputation) do
			tick:SetWidth(thickness)
			tick:SetHeight(TICK_WIDTH)
		end		
	end
end

function Bar:UpdateColor(id)
	local r, g, b, a = self:GetColor(id)

	local tex
	local spark
	
	if id == "XP" then
		tex   = self.XPBarTex
		spark = self.Spark
	elseif id == "Rest" then
		tex = self.RestedXPTex
	elseif id == "None" then
		tex = self.NoXPTex
	elseif id == "Rep" then
		tex   = self.RepBarTex
		spark = self.RepSpark
	elseif id == "NoRep" then
		tex = self.NoRepTex
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
	
	self.Spark:SetAlpha(intensity)
	self.Spark2:SetAlpha(intensity)
	self.RepSpark:SetAlpha(intensity)
	self.RepSpark2:SetAlpha(intensity)
end

function Bar:UpdateStrata()
	local strata = self:GetSetting("Strata")
	
	self.MainFrame:SetFrameStrata(strata)
	self.XPBar:SetFrameStrata(strata)
	self.RepBar:SetFrameStrata(strata)
	self.Border:SetFrameStrata(strata)
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

	self.XPBarTex:SetTexture(texture)
	self.NoXPTex:SetTexture(texture)
	self.RestedXPTex:SetTexture(texture)
	self.RepBarTex:SetTexture(texture)
	self.NoRepTex:SetTexture(texture)
end

function Bar:UpdateFont()
	if not LibSharedMedia then
		return
	end
	
	local font = self:GetSetting("Font")
	
	font = LibSharedMedia:Fetch("font", font)

	if not font then
		font = FONT_DEFAULT
	end

	-- setup bar texts
	self.XPText:SetFont(font, self:GetSetting("FontSize") or 6, FONT_STYLE)
	self.RepText:SetFont(font, self:GetSetting("FontSize") or 6, FONT_STYLE)
end

-- set bar progress in fraction of 1
function Bar:SetBarProgress(bar, fraction)
	if not bar or not fraction then
		return
	end
	
	if fraction < 0 then
		fraction = 0
	elseif fraction > 1 and bar ~= "Rested" then
		fraction = 1
	end
	
	self.progress[bar] = fraction
end

-- settings
function Bar:GetSetting(option)
	return self.settings[option]
end

function Bar:SetSetting(option, value, skipReanchor)
	local current = self:GetSetting(option)

	if current == value then
		return
	end
	
	self.settings[option] = value
	
	if not skipReanchor then
		self:Reanchor()
	end
end

function Bar:GetColor(id)
	local color = self.colors[id] or {r = 0, g = 0, b = 0, a = 0}

	return color.r, color.g, color.b, color.a
end

function Bar:SetColor(id, r, g, b, a)
	if not self.colors[id] then
		return
	end

	self.colors[id].r = r
	self.colors[id].g = g
	self.colors[id].b = b
	self.colors[id].a = a
	
	self:UpdateColor(id)
end

function Bar:GetText(bar)
	return self.text[bar]
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
	
	self.text[bar] = text
end
