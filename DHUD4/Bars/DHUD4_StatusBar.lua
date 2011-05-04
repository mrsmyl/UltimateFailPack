--[[
DHUD4_StatusBar.lua $Rev: 153
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
local L = LibStub("AceLocale-3.0"):GetLocale("DHUD4")
local DogTag = LibStub("LibDogTag-3.0")
local rc = LibStub("LibRangeCheck-2.0")


--[[
    There are 10 posible positions for bars in the layout

    l5 l4 l3 l2 l1 r1 r2 r3 r4 r5

    There are 10 full bars, used to display status information: health, power,
    agro, etc. Each of this bar has a border that can be used to track additional
    stats, buffs, cooldowns etc.
    fl5 fl4 fl3 fl2 fl1 fr1 fr2 fr3 fr4 fr5
]]
local STATUSBARS = {
    fl1 = {
        {0,1,0,1},
        "1",
        "1b",
        {11, 11},
    },
    fl2 = {
        {0,1,0,1},
        "2",
        "2b",
        {11, 11},
    },
    fl3 = {
        {0,1,0,1},
        "3",
        "3b",
        {11, 11},
    },
    fl4 = {
        {0,1,0,1},
        "4",
        "4b",
        {5, 5},
    },
    fl5 = {
        {0,1,0,1},
        "5",
        "5b",
        {5, 5},
    },
    fr1 = {
        {1,0,0,1},
        "1",
        "1b",
        {11, 11},
    },
    fr2 = {
        {1,0,0,1},
        "2",
        "2b",
        {11, 11},
    },
    fr3 = {
        {1,0,0,1},
        "3",
        "3b",
        {11, 11},
    },
    fr4 = {
        {1,0,0,1},
        "4",
        "4b",
        {5, 5},
    },
    fr5 = {
        {1,0,0,1},
        "5",
        "5b",
        {5, 5},
    },
}

-- Texts: Each bar can have an asociated text to display it's value.
local BARTEXT = {
    fl1 = {
        166,
        -95,
        "LEFT",
    },
    fl2 = {
        151,
        -110,
        "LEFT",
    },
    fl3 = {
        136,
        -125,
        "LEFT",
    },
    fl4 = {
        121,
        -140,
        "LEFT",
    },
    fl5 = {
        -105,
        -140,
        "RIGHT",
    },
    fr1 = {
        -166,
        -95,
        "RIGHT",
    },
    fr2 = {
        -151,
        -110,
        "RIGHT",
    },
    fr3 = {
        -136,
        -125,
        "RIGHT",
    },
    fr4 = {
        -121,
        -140,
        "RIGHT",
    },
    fr5 = {
        105,
        -140,
        "LEFT",
    },
}

--Fonts
local MAXFONT = 25
local MINFONT = 6

local UPDATE_INTERVAL = 0.1;

local statusBar = setmetatable({}, {__index = DHUD4.barPrototype})
--[[
    Bar constructor
]]
do
    local metatable = { __index = statusBar }
    --[[
        CreatestatusBar: Create a new bar
    ]]
    function DHUD4:CreateStatusBar()
        return setmetatable({}, metatable)
    end

    function DHUD4:StatusBarMenuOptions(order, disabled, db)
        local options = {
            type = 'group',
            order = order,
            name = L["Bar's Text"],
            desc = L["Configure Health and Power (mana/rage/energy/runic) text options"],
            disabled = disabled,
            args = {
                barText = {
                    order = 1,
                    type = 'multiselect',
                    name = L["Show Bar Values"],
                    values = { ["healthBarText"] = L["Health"], ["powerBarText"] = L["Power"] },
                    get = SelectGetter,
                    set = SelectSetter,
                },
                healthTextStyle = {
                    order = 2,
                    type = 'select',
                    name = L["Health Style"],
                    hidden = function() return not db.healthBarText end,
                    values = DHUD4:GetTags("health"),
                },
                healthCustomTextStyle = {
                    order = 3,
                    type = 'input',
                    name = L["Custom Health Style"],
                    desc = L["If set this style will override Health Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Health Style setting.)"],
                    hidden = function() return not db.healthBarText end,
                    usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                },
                powerTextStyle = {
                    order = 4,
                    type = 'select',
                    name = L["Power Style"],
                    hidden = function() return not db.powerBarText end,
                    values = DHUD4:GetTags("power"),
                },
                powerCustomTextStyle = {
                    order = 5,
                    type = 'input',
                    name = L["Custom Power Style"],
                    desc = L["If set this style will override Power Style value. Use LibDogTag-3.0 Tags. (Note: Leave/set blank to use Power Style setting.)"],
                    hidden = function() return not db.powerBarText end,
                    usage = L["Enter /dog for in-game LibDogTag-3.0 Tag documentation."],
                },
                barTextSize = {
                    order = 6,
                    type = 'range',
                    name = L["Font size"],
                    hidden = function() return not (db.healthBarText or db.powerBarText) end,
                    min = MINFONT,
                    max = MAXFONT,
                    step = 1,
                },
            },
        }
        return options
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
            texture     = Custom texture
]]
function statusBar:InitStatusBar(bar, parentFrame, heightFactor)

    local position, texture, borderTexture, gaps = unpack(STATUSBARS[bar])
    self:CreateBarPrototype(bar, parentFrame, heightFactor, position, texture, gaps)
    if ( (not self.borderFrame) or (self.borderFrame ~= _G["DHUD4_"..bar.."Border"]) ) then
        -- Create the barborder
        local border  = self.frame:CreateTexture("DHUD4_"..bar.."Border", "BORDER")
        border.texture = borderTexture
        border:SetAllPoints()
        border:SetTexCoord(unpack(position))
        border:SetBlendMode("BLEND")
        self.borderFrame = border
    end
    self.need = false
    if (self.useBorders) then
        self.borderFrame:Show()
    else
        self.borderFrame:Hide()
    end
end

--[[
    InitBarText: Creates a bar's text
        Use:
            TO-DO
        Arguments:
            savedPosition = Value of the saved position. Null if not exists
]]
function statusBar:InitStatusBarText(bar, savedPosition)

    --DHUD4:Debug("statusBar:InitStatusBarText", bar, savedPosition)
    local x, y, justify = unpack(BARTEXT[bar])
    if ( savedPosition ) then
        x, y = unpack(savedPosition)
        local point, relativeTo, relativePoint, xOfs, yOfs = self.parentFrame:GetPoint(1)
        --DHUD4:Debug("SetPosition Parent", xOfs, yOfs)
        x = x - xOfs
        y = y - yOfs
        --DHUD4:Debug("SetPosition", x, y)
    end
    self:CreateBarText(bar, x, y, justify)
end

--[[
    TrackUnitHealth: Set a bar to track a unit's health
        Use:
            TO-DO
        arguments:
            who = unit to track
            colors = colors to use
]]
function statusBar:TrackUnitHealth(who, colors)

    --DHUD4:Debug("TrackUnitHealth", self.text.bar, who)
    self.unit = who
    self.baseColors = colors
    self.display = 7
    self.vote = 1
    self.frame.auraTimer = self.updateInterval
    self:SetMaxHealth(UnitHealthMax(who))
    self.frame:RegisterEvent("UNIT_MAXHEALTH")
    self.frame:SetScript("OnEvent", function (self, event, unit)
            if ( unit == self.owner.unit and event == "UNIT_MAXHEALTH" ) then
                self.owner:SetMaxHealth(UnitHealthMax(unit))
            end
        end)
end

--[[
    TrackUnitPower: Set a bar to track a unit's power
        Use:
            TO-DO
        arguments:
            who = unit to track
            colors = colors to use
]]
function statusBar:TrackUnitPower(who, colors, powerType)

    --DHUD4:Debug("statusBar:TrackUnitPower", self.text.bar, who, powerType)
    self.unit = who
    self.baseColors = colors
    self.display = powerType
    self.vote = 2
    self.frame.auraTimer = self.updateInterval
    self:SetMaxPower(UnitPowerMax(who, powerType))
    self.frame:RegisterEvent("UNIT_MAXPOWER")
    self.frame:SetScript("OnEvent", function(self, event, unit)
            if ( unit == self.owner.unit and event == "UNIT_MAXPOWER" ) then
                self.owner:SetMaxPower(UnitPowerMax(unit, self.owner.display))
            end
        end)
end

function statusBar:TrackAgroStatus(unit, against, bar, colors)

    --DHUD4:Debug("statusBar:TrackUnitPower", self.text.bar, who, UnitPowerMax(who, powerType))
    self.unit = unit
    self.against = against
    self.frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    if (bar) then
        self.baseColors = colors
        self.maxVal = 100
        self.frame:SetScript("OnEvent", function(self, event, unit)
            if ( event == "UNIT_THREAT_LIST_UPDATE" and (self.owner.against == unit) ) then
                local _, agrostatus, threatpct, rawthreatpct = UnitDetailedThreatSituation(self.owner.unit, self.owner.against);
                if (threatpct) then
                    if ( self.val ~= threatpct ) then
                        self.owner.val = threatpct
                        self.owner:Colorize()
                        self.owner:Fill()
                    end
                    r, g, b = GetThreatStatusColor(agrostatus)
                    self.owner.borderFrame:SetVertexColor(r, g, b)
                    self.owner.borderFrame:Show()
                    --if ( db[this.bar].rawthreatpct ) then
                        -- Marker ??
                    --end
                    self.owner.text:Show()
                    self:Show()
                else
                    -- Hide when Bar empty ?
                    if ( self.showEmpty ) then
                        self.owner.background:Hide()
                        if ( self.useBorders ) then
                            self.owner.borderFrame:Show()
                        else
                            self.owner.borderFrame:Hide()
                        end
                        self:Show()
                        self.text:Show()
                    else
                        self.val = 0
                        self.owner.text:Hide()
                        self:Hide()
                    end
                    if (self.owner.useBorders) then
                        self.owner.borderFrame:SetVertexColor(1, 1, 1, 1)
                    else
                        self.owner.borderFrame:Hide()
                    end
                end
            end
        end)
    else
        self.frame:SetScript("OnEvent", function(self, event, unit)
                if ( event == "UNIT_THREAT_LIST_UPDATE" and (self.owner.against == unit) ) then
                    local _, agrostatus, threatpct = UnitDetailedThreatSituation(self.owner.unit, self.owner.against);
                    if ( threatpct ) then
                        r, g, b = GetThreatStatusColor(agrostatus)
                        self.owner.borderFrame:SetVertexColor(r, g, b)
                        self.owner.borderFrame:Show()
                    else
                        if (self.owner.useBorders) then
                            self.owner.borderFrame:SetVertexColor(1, 1, 1, 1)
                        else
                            self.owner.borderFrame:Hide()
                        end
                    end
                end
            end)
    end
end



--[[
    TrackUnitRange: Set a bar to track a unit's range. Range is tracked using
                    the bar's border
        Use:
            TO-DO
        arguments:
            who = unit to track
            colors = colors to use
]]
function statusBar:TrackUnitRange(colors)

    --DHUD4:Debug("TrackUnitRange", self.frame.bar)
    self.maxBorderVal = 80
    self.borderColors = colors
    self.range = true
end


--[[
    SetMaxHealth: Sets the maximun value of the bar
        Use:
            TO-DO
        Arguments:
            val = bar max value
]]
function statusBar:SetMaxHealth(val)

    --DHUD4:Debug("barPrototype:SetMaxHealth", val)
    self.maxVal = val
    if (val == 0) then
        -- Hide when Bar empty ?
        if ( self.showEmpty ) then
            self.background:Hide()
            if ( self.useBorders ) then
                self.borderFrame:Show()
            else
                self.borderFrame:Hide()
            end
            self.frame:Show()
            self.text:Show()
        else
            self.frame:Hide()
            self.text:Hide()
        end
    else
        self.frame:SetScript("OnUpdate", function (self, elapsed)
                self.auraTimer = self.auraTimer + elapsed
                if self.auraTimer >= self.owner.updateInterval then
                    if ( UnitExists(self.owner.unit) ) then
                        self.owner:SetVal(UnitHealth(self.owner.unit))
                        if (self.owner.range) then
                            local minRange, maxRange = rc:GetRange(self.owner.unit)
                            self.owner:SetBorderValRange(minRange, maxRange)
                        end
                    else
                        self:SetScript("OnUpdate", nil)
                        self:SetScript("OnEvent", nil)
                        self:Hide()
                    end
                    self.auraTimer = 0
                end
            end)
        self.text:Show()
        self.frame:Show()
    end
end

--[[
    SetMaxPower: Sets the maximun value of the bar
        Use:
            TO-DO
        Arguments:
            val = bar max value
]]
function statusBar:SetMaxPower(val)

    --DHUD4:Debug("barPrototype:SetMaxVal", val)
    self.maxVal = val
    if (val == 0) then
        --self:SetVal(UnitPower(self.unit, self.display))
        -- Hide when Bar empty ?
        if ( self.showEmpty ) then
            self.background:Hide()
            if ( self.useBorders ) then
                self.borderFrame:Show()
            else
                self.borderFrame:Hide()
            end
            self.frame:Show()
            self.text:Show()
        else
            self.frame:Hide()
            self.text:Hide()
        end
    else
        self.frame:SetScript("OnUpdate", function(self, elapsed)
                self.auraTimer = self.auraTimer + elapsed
                if self.auraTimer >= self.owner.updateInterval then
                    if ( UnitExists(self.owner.unit) ) then
                        self.owner:SetVal(UnitPower(self.owner.unit, self.owner.display))
                        if (self.owner.range) then
                            local minRange, maxRange = rc:GetRange(self.owner.unit)
                            self.owner:SetBorderValRange(minRange, maxRange)
                        end
                    else
                        self:SetScript("OnUpdate", nil)
                        self:SetScript("OnEvent", nil)
                        self:Hide()
                    end
                    self.auraTimer = 0
                end
            end)
        self.text:Show()
        self.frame:Show()
    end
end


--[[
    SetVal: Sets the current value of the bar, if the value has changed
               the bar color and fill value are updated.
        Use:
            TO-DO
        Arguments:
            val = bar current value
]]
function statusBar:SetVal(val)

    if ( self.val ~= val ) then
        self.val = val
        self:Colorize()
        self:Fill()
        if ( self.unit == "player" ) then
            local need = false
            if ( self.display == 1 or self.display == 6 ) then
                if self.val/self.maxVal ~= 0 then
                    need = true
                end
            else
                if self.val/self.maxVal ~= 1 then
                    need = true
                end
            end
            if(need ~= self.need) then
                if (need) then
                    DHUD4:UpdateAlpha(1, true, self.vote)
                else
                    DHUD4:UpdateAlpha(1, false, self.vote)
                end
                self.need = need
            end
        end
    end
end


--[[
    SetLayout: Show the bar and it's text so the user can place it
]]
function statusBar:MoveText()

    self:SetLayout(self.text.bar.." 85/100", 100, 85)
end

--[[
    SetLayout: Show the bar and it's text so the user can place it
]]
function statusBar:SetLayout(caption, maxVal, val)

    self:Disable()
    -- Fill the bar and show it
    self.baseColors = {
        f = { r=1,g=0.53,b=0.08},
        h = { r=1,g=0.53,b=0.08},
        l = { r=1,g=0.53,b=0.08}
    }
    self.maxVal = maxVal
    self.val = val
    self:Colorize()
    self:Fill()
    self.text.text:SetText(caption)
    self.text:Show()
    self.frame:Show()
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
                --DHUD4:Debug("SavePosition", self.bar, xOfs, yOfs)
                DHUD4:SavePosition(self.bar, {xOfs, yOfs})
            end
        end)
    self.text:EnableMouse(true)
    self.text:SetMovable(true)
end

--[[
    Disable: Disable the bar, removing all events and hiding it
]]
function statusBar:Disable(skipText)
    if(self.frame) then
        self.frame:UnregisterAllEvents()
        self.frame:SetScript("OnUpdate", nil)
        self.frame:SetScript("OnEvent", nil)
        if (self.text) then
            self.text:SetScript("OnDragStart", nil)
            self.text:SetScript("OnDragStop", nil)
            self.text:EnableMouse(false)
            self.text:SetMovable(false)
            if (not skipText) then
                DogTag:RemoveFontString(self.text.text)
            end
            self.text:Hide()
        end
        self.val = -1
        self.maxVal = 0
        self.borderVal = -1
        self.maxBorderVal = 0
        self.range = false
        self.background:SetVertexColor(1, 1, 1, 1)
        self.frame:Hide()
    end
end

--[[
    ConfigBarText: Register the bars's text with DogTag
        Use:
            TO-DO
        arguments:
            tagCode = DogTag code for displaying the bars text
]]
function statusBar:ConfigBarText(font, size, tagCode, who)

    --DHUD4:Debug("statusBar:ConfigBarText", self.text.bar, tagCode, who)
    self:ConfigText(font, size, 200)
    DogTag:AddFontString(self.text.text, self.text, tagCode, "Unit", { unit = who } )
end
