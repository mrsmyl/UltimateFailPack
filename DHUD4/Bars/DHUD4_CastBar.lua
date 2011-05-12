--[[
DHUD4_CastBar.lua $Rev: 153
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
--]]
local DHUD4 = LibStub("AceAddon-3.0"):GetAddon("DHUD4")
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4")

local string_format = string.format

local CASTBARS = {
    cl3 = {
        {0,1,0,1},
        "3c",
        "3f",
        {11, 11},
    },
    cl4 = {
        {0,1,0,1},
        "4c",
        "4f",
        {5, 5},
    },
    cr3 = {
        {1,0,0,1},
        "3c",
        "3f",
        {11, 11},
    },
    cr4 = {
        {1,0,0,1},
        "4c",
        "4f",
        {5, 5},
    },
}

local BARTEXT = {
    cl3 = {
        {115, 115},
        {115, 125},
        {115, 135},
        "LEFT",
    },
    cl4 = {
        {60, 150},
        {60, 160},
        {60, 170},
        "LEFT",
    },
    cr3 = {
        {-115, 115},
        {-115, 125},
        {-115, 135},
        "RIGHT",
    },
    cr4 = {
        {-60, 150},
        {-60, 160},
        {-60, 170},
        "RIGHT",
    },
}

local castBar = setmetatable({}, {__index = DHUD4.barPrototype})

--Fonts
local MAXFONT = 25
local MINFONT = 6

--[[
    Bar constructor
]]
do
    local metatable = { __index = castBar }
    --[[
        CreatestatusBar: Create a new bar
    ]]
    function DHUD4:CreateCastBar()
        return setmetatable({}, metatable)
    end
end

--[[
    InitBar: Creates a bar. Calls parent class CreateBarPrototype
             and adds border frame
        Use:
            TO-DO
        Arguments:
            bar         = Name of the bar to create
            parentFrame = Parent frame for the bar
]]
function castBar:InitCastBar(bar, parentFrame, reverse)


    local position, texture, flashTexture, gaps = unpack(CASTBARS[bar])
    --DHUD4:Debug("InitCastBar", bar)
    self:CreateBarPrototype(bar, parentFrame, 1, position, texture, gaps)
    local path = DHUD4:GetCurrentTexture()
    self:PlaceBackTexture(path)
    if ( (not self.flashBar) or (self.flashBar ~= _G["DHUD4_"..bar.."Flash"]) ) then
        -- Create the flash bar
        local frame = CreateFrame("Button", "DHUD4_"..bar.."Flash", parentFrame)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", parentFrame, "CENTER", 0, 0)
        frame:SetHeight(256)
        frame:SetWidth(128)
        local background = frame:CreateTexture("DHUD4_"..bar.."Texture", "BORDER")
        background.texture = texture
        background:ClearAllPoints()
        background:SetPoint("CENTER", frame, "CENTER", 0, 0)
        background:SetBlendMode("BLEND")
        background:SetTexCoord(position[1], position[2], position[3], position[4])
        background:SetTexture(path.."Bars\\"..flashTexture)
        if ( not background:GetTexture() ) then
            background:SetTexture("Interface\\AddOns\\DHUD4\\textures\\DHUD\\Bars\\"..flashTexture)
        end
        background:Show()
        frame.background = background
        frame:Hide()
        self.flashBar = frame
    end
    self.frame:SetFrameStrata("HIGH")
    self.flashBar:SetFrameStrata("HIGH")
    --DHUD4:Debug("Cast extures", self.background:GetTexture(), self.flashBar.background:GetTexture())
    self.reverse = reverse
end

--[[
    InitBarText: Creates a bar's text. Cast bars have 3 texts: SpellName, count and delay
        Use:
            TO-DO
        Arguments:
            savedPosition = Value of the saved position. Null if not exists
]]
function castBar:InitCastBarText(bar, showTimer, showName, showDelay, nameColor, delayColor)

    --DHUD4:Debug("castBar:InitCastBarText", bar, showTimer, showName, showDelay)
    local name, timer, delay, justify = unpack(BARTEXT[bar])
    local x, y
    if (showName) then
        x, y = unpack(name)
        local savedPosition = DHUD4:GetPosition(bar.."Name")
        if ( savedPosition ) then
            x, y = unpack(savedPosition)
            local point, relativeTo, relativePoint, xOfs, yOfs = self.parentFrame:GetPoint(1)
            --DHUD4:Debug("SetPosition Parent", xOfs, yOfs)
            x = x - xOfs
            y = y - yOfs
            --DHUD4:Debug("SetPosition", x, y)
        end
        -- Test if the name frame has allready been created
        if((not self.nameText) or (self.nameText:GetName() ~= "DHUD4_"..bar.."NameText")) then
            local frame = CreateFrame("Frame", "DHUD4_"..bar.."NameText", self.frame)
            frame:SetWidth(100)
            frame:SetHeight(14)
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", self.frame, "CENTER", x, y)
            frame.name = bar.."Name"
            local font = frame:CreateFontString("DHUD4_"..bar.."NameTextFont", "OVERLAY")
            font:SetFontObject(GameFontHighlightSmall)
            font:ClearAllPoints()
            font:SetPoint("CENTER", frame, "CENTER", 0, 0)
            font:SetTextColor(nameColor.r, nameColor.g, nameColor.b)
            font:SetWidth(100)
            font:SetJustifyH(justify)
            font:Show()
            self.nameText = frame
            self.nameText.owner = self
            self.nameText.text = font
            frame:RegisterForDrag("LeftButton")
            frame:Hide()
        elseif (self.nameText) then
            self.nameText:ClearAllPoints()
            self.nameText:SetPoint("CENTER", self.frame, "CENTER", x, y)
            self.nameText.text:SetJustifyH(justify)
        end
    end
    if (showTimer) then
        x, y = unpack(timer)
        local savedPosition = DHUD4:GetPosition(bar.."Timer")
        if ( savedPosition ) then
            x, y = unpack(savedPosition)
            local point, relativeTo, relativePoint, xOfs, yOfs = self.parentFrame:GetPoint(1)
            --DHUD4:Debug("SetPosition Parent", xOfs, yOfs)
            x = x - xOfs
            y = y - yOfs
            --DHUD4:Debug("SetPosition", x, y)
        end
        -- Test if the cast time frame has allready been created
        if((not self.text) or (self.text:GetName() ~= "DHUD4_"..bar.."Text")) then
            local frame = CreateFrame("Frame", "DHUD4_"..bar.."Text", self.frame)
            frame:SetWidth(100)
            frame:SetHeight(14)
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", self.frame, "CENTER", x, y)
            frame.name = bar.."Timer"
            local font = frame:CreateFontString("DHUD4_"..bar.."TextFont", "OVERLAY")
            font:SetFontObject(GameFontHighlightSmall)
            font:ClearAllPoints()
            font:SetPoint("CENTER", frame, "CENTER", 0, 0)
            font:SetWidth(100)
            font:SetJustifyH(justify)
            font:Show()
            self.text = frame
            self.text.owner = self
            self.text.text = font
            frame:RegisterForDrag("LeftButton")
            frame:Hide()
        elseif(self.text) then
            self.text:ClearAllPoints()
            self.text:SetPoint("CENTER", self.frame, "CENTER", x, y)
            self.text.text:SetJustifyH(justify)
        end
    end
    if (showDelay) then
        x, y = unpack(delay)
        local savedPosition = DHUD4:GetPosition(bar.."Delay")
        if ( savedPosition ) then
            x, y = unpack(savedPosition)
            local point, relativeTo, relativePoint, xOfs, yOfs = self.parentFrame:GetPoint(1)
            --DHUD4:Debug("SetPosition Parent", xOfs, yOfs)
            x = x - xOfs
            y = y - yOfs
            --DHUD4:Debug("SetPosition", x, y)
        end
        -- Test if the frame has allready been created
        if((not self.delayText) or (self.delayText:GetName() ~= "DHUD4_"..bar.."DelayText")) then
            local frame = CreateFrame("Frame", "DHUD4_"..bar.."DelayText", self.frame)
            frame:SetWidth(100)
            frame:SetHeight(14)
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", self.frame, "CENTER", x, y)
            frame.name = bar.."Delay"
            local font = frame:CreateFontString("DHUD4_"..bar.."DelayTextFont", "OVERLAY")
            font:SetFontObject(GameFontHighlightSmall)
            font:ClearAllPoints()
            font:SetPoint("CENTER", frame, "CENTER", 0, 0)
            font:SetTextColor(delayColor.r, delayColor.g, delayColor.b)
            font:SetWidth(100)
            font:SetJustifyH(justify)
            font:Show()
            self.delayText = frame
            self.delayText.owner = self
            self.delayText.text = font
            frame:RegisterForDrag("LeftButton")
            frame:Hide()
        elseif(self.delayText) then
            self.delayText:ClearAllPoints()
            self.delayText:SetPoint("CENTER", self.frame, "CENTER", x, y)
            self.delayText.text:SetJustifyH(justify)
        end
    end
end


function castBar:startCast()

    --DHUD4:Debug("castBar:startCast()")
    local spell, _, _, _, startTime, endTime = UnitCastingInfo(self.unit)
    self.val = -1
    if ( not spell ) then
        spell, _, _, _, startTime, endTime = UnitChannelInfo(self.unit)
        self.channel = true
    end
    if ( startTime ) then
        --DHUD4:Debug("show")
        self.startTime = startTime / 1000
        self.finishTime = endTime / 1000
        self.maxVal = self.finishTime - self.startTime
        local value
        if self.channel then
            value = self.reverse and (GetTime() - self.startTime) or (self.finishTime - GetTime())
        else
            value = self.reverse and (self.finishTime - GetTime()) or (GetTime() - self.startTime)
        end
        self.fade = false
        self.cast = true
        if ( self.nameText ) then
            self.nameText.text:SetText(spell)
            local w = self.nameText.text:GetStringWidth() * 1.1
            self.nameText:SetWidth(w)
            self.nameText:Show()
        end
        self.frame:SetAlpha(1)
        self.frame:Show()
        self.frame:SetScript("OnUpdate", function (self, elapsed)
                local currentTime = GetTime()
                local startTime = self.owner.startTime
                local finishTime = self.owner.finishTime
                if (self.owner.channel or self.owner.cast) then
                    local value
                    if (self.owner.channel) then
                        value = self.owner.reverse and (currentTime - startTime) or (finishTime - currentTime)
                    else
                        value = self.owner.reverse and (finishTime - currentTime) or (currentTime - startTime)
                    end
                    self.owner:SetVal(value)
                elseif self.owner.fade then
                    local fadeAlpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP
                    if fadeAlpha > 0 then
                        self:SetAlpha(fadeAlpha)
                    else
                        self:SetScript("OnUpdate", nil)
                        self:Hide()
                        self.owner.nameText:Hide()
                        self.owner.text:Hide()
                        self.owner.delayText:Hide()
                        self.owner.fade = false
                        if self.owner.unit == "player" then
                            DHUD4:UpdateAlpha(3, false)
                        end
                    end
                end
            end)
        self.frame:Show()
    else
        self.cast = false
        self.channel = false
        self.frame:Hide()
    end
end

--[[
    SetVal: Sets the current value of the bar, if the value has changed
               the bar color and fill value are updated.
        Use:
            TO-DO
        Arguments:
            val = bar current value
        Returns:
            true if the value changed
]]
function castBar:SetVal(val)

    if (self.text) then
        if ( self.val ~= val ) then
            --DHUD4:Debug("castBar:SetVal", val)
            self.val = val
            if (self.text) then
                self.text.text:SetText(string_format("%.1f", val))
                self.text:Show()
            end
            self:Colorize()
            self:Fill()
        end
    end
end

function castBar:SetDelay(val)
    if (self.delayTex) then
        if ( self.delay ~= val ) then
            self.delay = val
            if (self.delayText) then
                self.delayText.text:SetText(string_format("%.1f", val))
                self.delayText:Show()
            end
        end
    end
end

--[[
    Disable: Disable the bar, removing all events and hiding it
]]
function castBar:Disable()
    if(self.frame) then
        self.frame:UnregisterAllEvents()
        self.frame:SetScript("OnUpdate", nil)
        self.frame:SetScript("OnEvent", nil)
        self.frame:Hide()
        if (self.text) then
            self.text:SetScript("OnDragStart", nil)
            self.text:SetScript("OnDragStop", nil)
            self.text:EnableMouse(false)
            self.text:SetMovable(false)
        end
        if (self.nameText) then
            self.nameText:SetScript("OnDragStart", nil)
            self.nameText:SetScript("OnDragStop", nil)
            self.nameText:EnableMouse(false)
            self.nameText:SetMovable(false)
        end
        if (self.delayText) then
            self.delayText:SetScript("OnDragStart", nil)
            self.delayText:SetScript("OnDragStop", nil)
            self.delayText:EnableMouse(false)
            self.delayText:SetMovable(false)
        end
        self.val = -1
        self.maxVal = 0
        self.delay = -1
        self.channel = false
        self.cast = false
        self.fade = false
        self:HideText(self.nameText)
        self:HideText(self.text)
        self:HideText(self.delayText)
    end
end

function castBar:TrackUnitCast(who, colors)

    self.unit = who
    self.baseColors = colors
    self.frame:RegisterEvent("UNIT_SPELLCAST_START")
	self.frame:RegisterEvent("UNIT_SPELLCAST_STOP")
    self.frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
    self.frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
    self.frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    self.frame:SetScript("OnEvent", function (self, event, who)
            if ( who == self.owner.unit ) then
                if ( event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" ) then
                    self.owner:startCast()
                    if self.owner.unit == "player" then
                        DHUD4:UpdateAlpha(3, true)
                    end
                elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_CHANNEL_STOP" ) then
                    if ( self.owner.cast ) then
                        self.owner.cast = false
                        self.owner.channel = false
                        self.owner.fade = true
                        self.owner.flashBar:SetAlpha(0)
                        self.owner.flashBar:Show()
                        self.owner.flashBar.flash = true
                        self.owner.flashBar.dir = true
                        self.owner.flashBar.fadeAlpha = 0
                        self.owner.flashBar:SetScript("OnUpdate", function (self, elapsed)
                                if ( self.flash ) then
                                    local fadeAlpha
                                    if ( self.dir ) then
                                        fadeAlpha = self:GetAlpha() + CASTING_BAR_FLASH_STEP
                                        if ( fadeAlpha < 1 ) then
                                            self:SetAlpha(fadeAlpha)
                                        else
                                            self.dir =false
                                        end
                                    else
                                        fadeAlpha = self:GetAlpha() - CASTING_BAR_FLASH_STEP
                                        if ( fadeAlpha > 0 ) then
                                            self:SetAlpha(fadeAlpha)
                                        else
                                            self.flash = false
                                            self:SetScript("OnUpdate", nil)
                                            self:Hide()
                                        end
                                    end
                                else
                                    self:SetScript("OnUpdate", nil)
                                    self:Hide()
                                end
                            end)
                    end
                    if self.owner.unit == "player" then
                        DHUD4:UpdateAlpha(3, false)
                    end
                elseif ( event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
                    --DHUD4:Debug("UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_CHANNEL_UPDATE")
                    local _, _, _, _, startTime, endTime = UnitCastingInfo(self.owner.unit);
                    if ( startTime ) then
                        local oldStart = self.owner.startTime
                        self.owner.startTime = startTime / 1000
                        self.owner.finishTime = endTime / 1000
                        self.owner:SetDelay(self.owner.startTime - oldStart)
                    end
                end
            end
        end)
end

function castBar:HideText(text)
    if ( text ) then
        text:Hide()
    end
end

--[[
    SetLayout: Show the bar and it's text so the user can place it
]]
function castBar:SetLayout(caption, maxVal, val)

    self:Disable()
    -- Fill the bar and show it
    self.baseColors = {
        f = { r=1,g=0.98,b=0.14},
        h = { r=1,g=0.98,b=0.14},
        l = { r=1,g=0.98,b=0.14}
    }
    self.maxVal = maxVal
    self:SetVal(val)
    self.frame:SetAlpha(1)
    self.frame:Show()
    if (self.text) then
        self.text:SetScript("OnDragStart", function(self)
                if ( IsAltKeyDown() ) then
                    self:StartMoving()
                    self.isMoving = true
                end
            end)
        self.text:SetScript("OnDragStop", function(self)
                if ( self.isMoving ) then
                    self.isMoving = false
                    self:StopMovingOrSizing()
                    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
                    self:SetUserPlaced(false)
                    --DHUD4:Debug("SavePosition", self.name, xOfs, yOfs)
                    DHUD4:SavePosition(self.name, {xOfs, yOfs})
                end
            end)
        self.text:EnableMouse(true)
        self.text:SetMovable(true)
    end
    if (self.delayText) then
        self.delayText.text:SetText("0.5")
        self.delayText:SetScript("OnDragStart", function(self)
                if ( IsAltKeyDown() ) then
                    self:StartMoving()
                    self.isMoving = true
                end
            end)
        self.delayText:SetScript("OnDragStop", function(self)
                if ( self.isMoving ) then
                    self.isMoving = false
                    self:StopMovingOrSizing()
                    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
                    self:SetUserPlaced(false)
                    --DHUD4:Debug("SavePosition", self.name, xOfs, yOfs)
                    DHUD4:SavePosition(self.name, {xOfs, yOfs})
                end
            end)
        self.delayText:EnableMouse(true)
        self.delayText:SetMovable(true)
        self.delayText:Show()
    end
    if (self.nameText) then
        self.nameText.text:SetText(caption.." Spell Name")
        self.nameText:SetScript("OnDragStart", function(self)
                if ( IsAltKeyDown() ) then
                    self:StartMoving()
                    self.isMoving = true
                end
            end)
        self.nameText:SetScript("OnDragStop", function(self)
                if ( self.isMoving ) then
                    self.isMoving = false
                    self:StopMovingOrSizing()
                    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
                    self:SetUserPlaced(false)
                    --DHUD4:Debug("SavePosition", self.name, xOfs, yOfs)
                    DHUD4:SavePosition(self.name, {xOfs, yOfs})
                end
            end)
        self.nameText:EnableMouse(true)
        self.nameText:SetMovable(true)
        self.nameText:Show()
    end
end

--[[
    ConfigBarText: Register the bars's text with DogTag
        Use:
            TO-DO
        arguments:
            tagCode = DogTag code for displaying the bars text
]]
function castBar:ConfigBarText(font, size)

    --DHUD4:Debug("castBar:ConfigBarText")
    self.nameText.text:SetFont(font, size)
    self.text.text:SetFont(font, size)
    self.delayText.text:SetFont(font, size)
end