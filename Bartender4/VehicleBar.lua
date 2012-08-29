--[[
	Copyright (c) 2009-2012, Hendrik "Nevcairiel" Leppkes < h.leppkes at gmail dot com >
	All rights reserved.
]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")
-- register module
local VehicleBarMod = Bartender4:NewModule("Vehicle", "AceHook-3.0")

-- fetch upvalues
local ButtonBar = Bartender4.ButtonBar.prototype

-- create prototype information
local VehicleBar = setmetatable({}, {__index = ButtonBar})

local table_insert = table.insert

local defaults = { profile = Bartender4:Merge({
	enabled = true,
	visibility = {
		vehicleui = false,
	},
}, Bartender4.ButtonBar.defaults) }

function VehicleBarMod:OnInitialize()
	self.db = Bartender4.db:RegisterNamespace("Vehicle", defaults)
	if self.blizzardVehicle then
		self:SetEnabledState(false)
	else
		self:SetEnabledState(self.db.profile.enabled)
	end
end

function VehicleBarMod:OnEnable()
	if self.blizzardVehicle then
		self:Disable()
		return
	end
	if not self.bar then
		self.bar = setmetatable(Bartender4.ButtonBar:Create("Vehicle", self.db.profile, L["Vehicle Bar"], true), {__index = VehicleBar})
		local buttons = {MainMenuBarVehicleLeaveButton}
		self.bar.buttons = buttons

		VehicleBarMod.button_count = #buttons

		for i,v in pairs(buttons) do
			v:SetParent(self.bar)
			v.ClearSetPoint = self.bar.ClearSetPoint
		end

		self:SecureHook("MainMenuBarVehicleLeaveButton_Update")
	end
	self.bar:Enable()
	self:ToggleOptions()
	self:ApplyConfig()
end

function VehicleBarMod:ApplyConfig()
	self.bar:ApplyConfig(self.db.profile)
end

function VehicleBarMod:MainMenuBarVehicleLeaveButton_Update()
	if CanExitVehicle() then
		MainMenuBarVehicleLeaveButton:Show()
	end
	self.bar:UpdateButtonLayout()
end

VehicleBar.button_width = 32
VehicleBar.button_height = 32
VehicleBar.LBFOverride = true
function VehicleBar:ApplyConfig(config)
	ButtonBar.ApplyConfig(self, config)

	if not self.config.position.x then
		self:ClearSetPoint("CENTER", 120, 27)
		self:SavePosition()
	end

	self:UpdateButtonLayout()
end
