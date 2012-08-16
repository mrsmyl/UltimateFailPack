-- X-Perl UnitFrames
-- Author: Zek <Boodhoof-EU>
-- License: GNU GPL v3, 29 June 2007 (see LICENSE.txt)

local conf, pconf
XPerl_RequestConfig(function(new) conf = new pconf = new.player end, "$Revision: 634 $")

local playerClass

--[===[@debug@
local function d(fmt, ...)
	fmt = fmt:gsub("(%%[sdqxf])", "|cFF60FF60%1|r")
	ChatFrame1:AddMessage("|cFFFF8080PlayerBuffs:|r "..format(fmt, ...), 0.8, 0.8, 0.8)
end
--@end-debug@]===]

-- setCommon
local function setCommon(self, filter, buffTemplate)
	self:SetAttribute("template", buffTemplate)
	self:SetAttribute("weaponTemplate", buffTemplate)
	self:SetAttribute("useparent-unit", true)

	self:SetAttribute("filter", filter)
	self:SetAttribute("separateOwn", 1)
	if (filter == "HELPFUL") then
		self:SetAttribute("includeWeapons", 1)
	end
	self:SetAttribute("point", "TOPLEFT")
	self:SetAttribute("wrapAfter", max(1, floor(XPerl_Player:GetWidth() / pconf.buffs.size)))	-- / XPerl_Player:GetEffectiveScale() 
	self:SetAttribute("maxWraps", pconf.buffs.rows)
	self:SetAttribute("xOffset", 32)	-- pconf.buffs.size)
	self:SetAttribute("yOffset", 0)
	self:SetAttribute("wrapXOffset", 0)
	self:SetAttribute("wrapYOffset", pconf.buffs.above and 32 or -32)

	self:SetAttribute("minWidth", 32)
	self:SetAttribute("minHeight", 32)

	self:SetAttribute("initial-width", pconf.buffs.size)
	self:SetAttribute("initial-height", pconf.buffs.size)
	-- Workaround: We can't set the initial-width/height (beacuse the api ignores this so far)
	-- So, we'll scale the parent frame so the effective size matches our setting

	local settings = filter == "HELPFUL" and pconf.buffs or pconf.debuffs
	if (settings) then
		local needScale = settings.size / 32
		self:SetScale(needScale)
	end
end

-- XPerl_Player_Buffs_Position
function XPerl_Player_Buffs_Position(self)
	if (self.buffFrame and not InCombatLockdown()) then
		self.buffFrame:ClearAllPoints()
		self.buffFrame:SetWidth(32)
		self.buffFrame:SetHeight(32)

		self.debuffFrame:ClearAllPoints()
		self.debuffFrame:SetWidth(32)
		self.debuffFrame:SetHeight(32)

		if (pconf.buffs.above) then
			self.buffFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 3, 0)
		else
			if (self.runes and self.runes:IsShown() and not pconf.hideRunes) then
				self.buffFrame:SetPoint("TOPLEFT", self.runes, "BOTTOMLEFT", 3, 0)
			elseif (self.runes and self.runes:IsShown()) then
				self.buffFrame:SetPoint("TOPLEFT", self.runes, "BOTTOMLEFT", 3, 0)
			--elseif (self.shards) then
			--	self.buffFrame:SetPoint("TOPLEFT", self.shards, "BOTTOMLEFT", 3, 0)
			elseif ((pconf.xpBar or pconf.repBar) and not pconf.extendPortrait) then
				--self.buffFrame:SetPoint("TOPLEFT", self.statsFrame, "BOTTOMLEFT", 3, 0)
				local diff = self.statsFrame:GetBottom() - self.portraitFrame:GetBottom()
				self.buffFrame:SetPoint("TOPLEFT", self.portraitFrame, "BOTTOMLEFT", 3, diff - 3)
			else
				self.buffFrame:SetPoint("TOPLEFT", self.portraitFrame, "BOTTOMLEFT", 3, 0)
			end
		end

		if (pconf.buffs.above) then
			self.debuffFrame:SetPoint("BOTTOMLEFT", self.buffFrame, "TOPLEFT", 0, 2)
		else
			self.debuffFrame:SetPoint("TOPLEFT", self.buffFrame, "BOTTOMLEFT", 0, -2)
		end
	end
end

-- XPerl_Player_BuffSetup
function XPerl_Player_BuffSetup(self)
	if (not self) then
		return
	end
	if (not pconf.buffs.enable) then
		if (self.buffFrame) then
			self.buffFrame:Hide()
			self.debuffFrame:Hide()

			BuffFrame:Show()
			BuffFrame:RegisterEvent("UNIT_AURA")
			TemporaryEnchantFrame:Show()
		end
		return
	end

	if (not self.buffFrame) then
		self.buffFrame = CreateFrame("Frame", self:GetName().."buffFrame", self, "SecureAuraHeaderTemplate")
		self.debuffFrame = CreateFrame("Frame", self:GetName().."debuffFrame", self, "SecureAuraHeaderTemplate")

		self.buffFrame.BuffFrameUpdateTime = 0
		self.buffFrame.BuffFrameFlashTime = 0
		self.buffFrame.BuffFrameFlashState = 1
		self.buffFrame.BuffAlphaValue = 1
		self.buffFrame:SetScript("OnUpdate", BuffFrame_OnUpdate)

		-- Not implemented.. yet.. maybe later
		--self.buffFrame.initialConfigFunction = function(self)
		--	d("initialConfigFunction(%s)", tostring(self))
		--	self:SetAttribute("useparent-unit", true)
		--end
		--self.debuffFrame.initialConfigFunction = self.buffFrame.initialConfigFunction
	end
		
	if (pconf.buffs.hideBlizzard) then
		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:Hide()
		TemporaryEnchantFrame:Hide()
	else
		BuffFrame:Show()
		BuffFrame:RegisterEvent("UNIT_AURA")
		TemporaryEnchantFrame:Show()
	end
end


local function XPerl_Player_Buffs_Set_Bits(self)
	playerClass = select(2, UnitClass("player"))

	XPerl_Player_BuffSetup(self)

	local buffs = self.buffFrame
	if buffs then
		if pconf.buffs.enable then
			setCommon(buffs, "HELPFUL", "XPerl_Secure_BuffTemplate")
			buffs:Show()
		else
			buffs:Hide()
		end
	end
		
	local debuffs = self.debuffFrame
	if debuffs then
		if pconf.buffs.enable and pconf.debuffs.enable then
			setCommon(debuffs, "HARMFUL", "XPerl_Secure_BuffTemplate")
			debuffs:Show()
		else
			debuffs:Hide()
		end
	end

	XPerl_Player_Buffs_Position(self)
end

-- AuraButton_OnUpdate
local function AuraButton_OnUpdate(self, elapsed)
	if (not self.endTime) then
		self:SetAlpha(1)
		self:SetScript("OnUpdate", nil)
		return
	end
	local index = self:GetID()
	local timeLeft = self.endTime - GetTime()
	if (timeLeft < _G.BUFF_WARNING_TIME) then
		self:SetAlpha(XPerl_Player.buffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end

local function DoEnchant(self, slotID, hasEnchant, expire, charges)
	if (hasEnchant) then
		-- Fix to check to see if the player is a shaman and sets the fullDuration to 30 minutes. Shaman weapon enchants are only 30 minutes.
		if (playerClass == "SHAMAN") then
			if ((expire / 1000) > 30 * 60) then
				self.fullDuration = 60 * 60
			else         
				self.fullDuration = 30 * 60
			end
		end
		if (not self.fullDuration) then
			self.fullDuration = expire - GetTime()
			if (self.fullDuration > 1 * 60) then
				self.fullDuration = 60 * 60
			end
		end

		-- self:Show()

		local textureName = GetInventoryItemTexture("player", slotID)	-- Weapon Icon
		self.icon:SetTexture(textureName)
		self:SetAlpha(1)
		self.border:SetVertexColor(0.7, 0, 0.7)

		-- Handle cooldowns
		if (self.cooldown and expire and conf.buffs.cooldown and pconf.buffs.cooldown) then
			local timeEnd = GetTime() + (expire / 1000)
			local timeStart = timeEnd - self.fullDuration		--          (30 * 60)
			XPerl_CooldownFrame_SetTimer(self.cooldown, timeStart, self.fullDuration, 1)

			if (pconf.buffs.flash) then
				self.endTime = timeEnd
				self:SetScript("OnUpdate", AuraButton_OnUpdate)
			else
				self.endTime = nil
			end
		else
			self.cooldown:Hide()
			self.endTime = nil
		end
	else
		self.fullDuration = nil
		-- self:Hide()
	end
end

--local function setupButton(self)
--end

function XPerl_PlayerBuffs_Show(self)
	self:RegisterEvent("UNIT_AURA")
	XPerl_PlayerBuffs_Update(self)
end

function XPerl_PlayerBuffs_Hide(self)
	self:UnregisterEvent("UNIT_AURA")
	XPerl_PlayerBuffs_Update(self)
end

function XPerl_PlayerBuffs_OnEvent(self, event, unit)
	if (event == "UNIT_AURA") then
		if (unit == "player" or unit == "pet" or unit == "vehicle") then
			XPerl_PlayerBuffs_Update(self)
		end
	end
end

function XPerl_PlayerBuffs_OnAttrChanged(self, attr, value)
	if (attr == "index" or attr == "filter" or attr == "target-slot") then
		XPerl_PlayerBuffs_Update(self)
	end
end

function XPerl_PlayerBuffs_OnEnter(self)
	if (conf.tooltip.enableBuffs and XPerl_TooltipModiferPressed(true)) then
		if (not conf.tooltip.hideInCombat or not InCombatLockdown()) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",0,0)

			local slot = self:GetAttribute("target-slot")
			if (slot) then
				GameTooltip:SetInventoryItem("player", slot)
			else
				local partyid = SecureButton_GetUnit(self:GetParent()) or "player"
				if (self:GetAttribute("filter") == "HELPFUL") then
					XPerl_TooltipSetUnitBuff(GameTooltip, partyid, self:GetID(), "HELPFUL")
				else
					XPerl_TooltipSetUnitDebuff(GameTooltip, partyid, self:GetID(), "HARMFUL")
				end
				self.UpdateTooltip = XPerl_PlayerBuffs_OnEnter
			end
		end
	end
end

function XPerl_PlayerBuffs_OnLeave(self)
	GameTooltip:Hide()
end


function XPerl_PlayerBuffs_Update(self)
	local slot = self:GetAttribute("target-slot")
	if (slot) then
		-- Weapon Enchant

		if (XPerl_PlayerbuffFrameTempEnchant1 and XPerl_PlayerbuffFrameTempEnchant2) then
			-- TODO Remove when fixed after WoW 13164 sometime
			-- Build 13164: SecureGroupHeaders.lua(777) uses main hand slot instead of offhand
			-- (ie: all weapon icons have 16 as their ID and their target-slot)
			if (XPerl_PlayerbuffFrameTempEnchant1:GetAttribute("target-slot") == XPerl_PlayerbuffFrameTempEnchant2:GetAttribute("target-slot")) then
				if (self:GetName() == "XPerl_PlayerbuffFrameTempEnchant2") then
					slot = 17
					if (not InCombatLockdown()) then
						XPerl_PlayerbuffFrameTempEnchant2:SetAttribute("target-slot", 17)
						XPerl_PlayerbuffFrameTempEnchant2:SetID(17)
					end
				end
			end
		end

		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
		if (slot == 16) then
			DoEnchant(self, 16, hasMainHandEnchant, mainHandExpiration, mainHandCharges)
		else
			DoEnchant(self, 17, hasOffHandEnchant, offHandExpiration, offHandCharges)
		end
	else
		-- Aura
		local index = self:GetAttribute("index")
		local filter = self:GetAttribute("filter")
		local unit = SecureButton_GetUnit(self:GetParent()) or "player"

		if (filter and unit) then
			local name, rank, buff, count, debuffType, duration, endTime, isMine, isStealable = UnitAura(unit, index, filter)
			self.filter = filter
			self:SetAlpha(1)

			if (name and filter == "HARMFUL") then
				self.border:Show()
				local borderColor = DebuffTypeColor[(debuffType or "none")]
				self.border:SetVertexColor(borderColor.r, borderColor.g, borderColor.b)
			else
				self.border:Hide()
			end

			self.icon:SetTexture(buff)
			if ((count or 0) > 1) then
				self.count:SetText(count)
				self.count:Show()
			else
				self.count:Hide()
			end
	
			-- Handle cooldowns
			if (self.cooldown and (duration or 0) ~= 0 and conf.buffs.cooldown and (isMine or conf.buffs.cooldownAny)) then
				local start = endTime - duration
				XPerl_CooldownFrame_SetTimer(self.cooldown, start, duration, 1, isMine)
				if (pconf.buffs.flash) then
					self.endTime = endTime
					self:SetScript("OnUpdate", AuraButton_OnUpdate)
				else
					self.endTime = nil
				end
			else
				self.cooldown:Hide()
				self.endTime = nil
			end
		end
	end
end

function XPerl_PlayerBuffs_OnLoad(self)
	XPerl_SetChildMembers(self)
	self:RegisterForClicks("RightButtonUp")			-- The XML version doesn't work..
	--XPerl_ProtectedCall(setupButton, self)
end


XPerl_RegisterOptionChanger(XPerl_Player_Buffs_Set_Bits, XPerl_Player)
