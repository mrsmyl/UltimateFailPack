--[[
DHUD4_Bar.lua $Rev: 153
Copyright (c) 2006 by Markus Inger, 2006 by Caeryn Dryad, 2007-2010 by Horacio Hoyos

This file is part of DHUD4.

    DHUD4 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    DHUD4 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with DHUD4.  If not, see <http://www.gnu.org/licenses/>.
]]
local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4")

--[[
    There are 10 posible positions for bars in the layout, and 4 posible
    positions for cast bars

    l5 l4 l3 l2 l1 r1 r2 r3 r4 r5
       c  c              c  c
       f  f              f  f
]]

local barPrototype = {
    frame,
    background,
    unit,
    maxVal = 0,
    maxBorderVal = 0,
    val = -1,
    borderVal = -1,
    baseColors,
    borderColors,
    tex_gap_top,
    tex_gap_bottom,
    text,
    updateInterval = 0.1,
    heightFactor = 1,
}
DHUD4.barPrototype = barPrototype

--[[
    CreateBarPrototype: Creates a bar
        Use:
            TO-DO
        Arguments:
            bar          = Name of the bar to create
            parentFrame  = Parent frame for the bar
            heightFactor = For bars how's height is less than 128
]]
function barPrototype:CreateBarPrototype(bar, parentFrame, heightFactor, position, texture, gaps)
    -- Test if the frame has allready been created
    if ( (not self.frame) or (self.frame ~= _G["DHUD4_"..bar]) ) then
        -- Create the bar
        if ( self.frame ) then
            self:Disable()  -- Remove previous configurations
        end
        local frame = CreateFrame("Button", "DHUD4_"..bar, parentFrame)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", parentFrame, "CENTER", 0, 0)
        frame:SetHeight(256)
        frame:SetWidth(128)
        local background = frame:CreateTexture("DHUD4_"..bar.."Texture", "BACKGROUND")
        background.texture = texture
        background:SetBlendMode("BLEND")
        self.background = background
        frame:Hide()
        frame.bar = bar
        frame:EnableMouse(false)
        self.frame = frame
        self.frame.owner = self
        self.x0 = position[1]
        self.x1 = position[2]
        self.parentFrame = parentFrame
        self.tex_gap_top = gaps[1]
        self.tex_gap_bottom = gaps[2]
        if ( heightFactor ) then
            self.heightFactor = heightFactor
        end
    end
end


--[[
    InitBarText: Creates a bar's text
        Use:
            TO-DO
        Arguments:
            savedPosition = Value of the saved position. Null if not exists
]]
function barPrototype:CreateBarText(bar, x, y, justify)

    -- Test if the frame has allready been created
    if((not self.text) or (self.text ~= _G["DHUD4_"..bar.."Text"])) then
        local frame = CreateFrame("Frame", "DHUD4_"..bar.."Text", self.frame)
        frame:SetWidth(100)
        frame:SetHeight(14)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", self.frame, "CENTER", x, y)
        local font = frame:CreateFontString("DHUD4_"..bar.."TextFont", "OVERLAY")
        font:SetFontObject(GameFontHighlightSmall)
        font:ClearAllPoints()
        font:SetPoint("CENTER", frame, "CENTER", 0, 0)
        font:SetText(bar.."Aligment")
        font:SetWidth(200)
        font:SetJustifyH(justify)
        font:Show()
        self.text = frame
        self.text.owner = self
        self.text.text = font
        frame:RegisterForDrag("LeftButton")
        frame.bar = bar
        frame:Hide()
    else
        self.text:ClearAllPoints()
        self.text:SetPoint("CENTER", self.frame, "CENTER", x, y)
        self.text.text:SetJustifyH(justify)
    end
end

--[[
    SetBaseColors: Sets the base colors for the bar
        Use:
            TO-DO
        Arguments:
            colors = colors too use with the bar. Table with this format:
                    { f = {r=0,g=0,b=0},
                      h = {r=0,g=0,b=0},
                      e = {r=0,g=0,b=0}, }
                      l -> full color
                      h -> half fill color
                      l -> low fill color
]]
function barPrototype:SetColor(colors)
    self.baseColors = colors
end

--[[
    SetText: Sets the bar's matching text
        Use:
            TO-DO
        Arguments:
            text = Frame of the bar's text
]]
function barPrototype:SetText(text)
    self.text = text
end

function barPrototype:Hide()
    self.text:Hide()
    self.frame:Hide()
end

local defaultTexturePath = "Interface\\AddOns\\DHUD4\\textures\\DHUD\\"

function barPrototype:PlaceBackTexture(path)
    self.background:SetTexture(path.."Bars\\"..self.background.texture)
    if ( not self.background:GetTexture() ) then
        self.background:SetTexture(defaultTexturePath.."Bars\\"..self.background.texture)
    end
end

function barPrototype:PlaceTextures(path)
    self:PlaceBackTexture(path)
    self.borderFrame:SetTexture(path.."Bars\\"..self.borderFrame.texture)
    if ( not self.borderFrame:GetTexture() ) then
        self.borderFrame:SetTexture(defaultTexturePath.."Bars\\"..self.borderFrame.texture)
    end
end

--[[
    SetDisplayOptions: Sets the bar's display options
        Use:
            TO-DO
        Arguments:
            showEmpty: show bars when empty
            useBorders: use bar borders
]]
function barPrototype:SetDisplayOptions(showEmpty, useBorders)

    self.showEmpty = showEmpty
    self.useBorders = useBorders
end

--[[
    SetUseBorders: Set if the borders are used. Provided to override db
                   configuration when a border is used for displaing a
                   stat
        Use:
            TO-DO
        Arguments:
            use:
]]
function barPrototype:SetUseBorders(use)

    self.useBorders = use
end

--[[
    Colorize: Get the bar color according to percent
]]
function barPrototype:Colorize()

    local r, g, b, diff
    local percent = self.val / self.maxVal
    local threshold1, threshold2  = 0.6, 0.2
    if ( percent <= threshold2 ) then
        r, g, b = self.baseColors.l.r, self.baseColors.l.g, self.baseColors.l.b
    elseif ( percent <= threshold1) then
        diff = 1 - (percent - threshold2) / (threshold1 - threshold2)
        r = self.baseColors.h.r - (self.baseColors.h.r - self.baseColors.l.r) * diff
        g = self.baseColors.h.g - (self.baseColors.h.g - self.baseColors.l.g) * diff
        b = self.baseColors.h.b - (self.baseColors.h.b - self.baseColors.l.b) * diff
    elseif ( percent < 1) then
        diff = 1 - (percent - threshold1) / (1 - threshold1);
        r = self.baseColors.f.r - (self.baseColors.f.r - self.baseColors.h.r) * diff
        g = self.baseColors.f.g - (self.baseColors.f.g - self.baseColors.h.g) * diff
        b = self.baseColors.f.b - (self.baseColors.f.b - self.baseColors.h.b) * diff
    else
        r, g, b = self.baseColors.f.r, self.baseColors.f.g, self.baseColors.f.b
    end
    --self:Debug("colorize", r, g, b)
    if (r < 0) then r = 0; end
    if (r > 1) then r = 1; end
    if (g < 0) then g = 0; end
    if (g > 1) then g = 1; end
    if (b < 0) then b = 0; end
    if (b > 1) then b = 1; end
    --hex = self:Rgb2hex(r, g, b)
    self.background:SetVertexColor(r, g, b)
    if(self.text) then
        self.text.text:SetTextColor(r, g, b)
    end
end


--[[
    Fill: Fills the bar changing its height and color acording to the maximun
          and current value
]]
function barPrototype:Fill()

    --DHUD4:Debug("Fill")
    if (self.val > 0) then
        local fracVal = (self.val / self.maxVal)  * self.heightFactor
        local tex_gap_top_p    = self.tex_gap_top / 256
        local tex_gap_bottom_p = self.tex_gap_bottom / 256
        local h = (256 - self.tex_gap_top - self.tex_gap_bottom) * fracVal
        local top    = (1 - ( fracVal - tex_gap_top_p ))
        local bottom = (1 - tex_gap_bottom_p)
        top = top  - ( (tex_gap_top_p + tex_gap_bottom_p) * (1 - fracVal) )
        if ( top > 1 ) then top = 1 end
        if ( bottom < 0 ) then bottom = 0 end
        self.background:SetHeight(h)
        self.background:SetTexCoord(self.x0, self.x1, top, bottom)
        self.background:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, self.tex_gap_bottom)
        self.background:Show()
    else
        self.background:Hide()
    end
end

--[[
    ConfigBarText: Register the bars's text with DogTag
        Use:
            TO-DO
        arguments:
]]
function barPrototype:ConfigText(font, size, width)

    --DHUD4:Debug("barPrototype:ConfigBarText", self.text.bar, who)
    self.text.text:SetFont(font, size)
    self.text.text:SetWidth(width)
end

--[[
    SetBorderMax: Sets the maximun value of the bar border
        Use:
            TO-DO
        Arguments:
            val = bar border max value
]]
function barPrototype:SetBorderMax(val)

    --DHUD4:Debug("barPrototype:SetMaxVal", val)
    self.maxBorderVal = val
end


--[[
    SetBorderVal: Sets the current value of the bar border when the values are
                  a range, if the value has changed the bar border color changes
        Use:
            TO-DO
        Arguments:
            valLow = low value
            valHigh = high value
]]
function barPrototype:SetBorderValRange(valLow, valHigh)
    
    --DHUD4:Debug("SetBorderVal", valLow, valHigh)
    local val = 0
    if (valHigh == nil) then
        valHigh = self.maxBorderVal
    end
    if (valLow == nil) then
        val = 4
    elseif (valLow == self.maxBorderVal) then
        val = 4
    else
        local step = self.maxBorderVal/4
        local done = false
        repeat
            if (valLow <= (step * val) and valHigh <= (step * val)) then
                done = true
            elseif (valLow > (step * val) and valHigh > (step * val)) then
                val = val + 1
            else
                val = math.abs(valHigh-(step * val)) > math.abs(valLow-(step * val)) and val or val-1
                if (val < 0 ) then val = 0 end
                done = true
            end
        until done
    end
    if ( self.borderVal ~= val ) then
        self.borderVal = val
        -- Out of range, hide borders if not in use
        if (val == 4 and not self.useBorders) then
            self.borderFrame:Hide()
        else
            self.borderFrame:Show()
            self:ColorizeBorder()
        end
    end
end

--[[
    Colorize: Get the bar color according to percent
        returns:
            r, g, b and hex values for the calculated color.
]]
function barPrototype:ColorizeBorder()

    --DHUD4:Debug("ColorizeBorder", self.borderVal)
    local r, g, b
    local pos = string.format("%i", self.borderVal)
    r, g, b = self.borderColors[pos].r, self.borderColors[pos].g, self.borderColors[pos].b
    --self:Debug("colorize", r, g, b)
    self.borderFrame:SetVertexColor(r, g, b)
end
