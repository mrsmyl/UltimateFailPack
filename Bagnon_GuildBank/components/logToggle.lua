--[[
	logToggle.lua
		A guild log toggle widget (by João Libório Cardoso)
--]]

local Bagnon = LibStub('AceAddon-3.0'):GetAddon('Bagnon')
local L = LibStub('AceLocale-3.0'):GetLocale('Bagnon')
local LogToggle = Bagnon.Classy:New('CheckButton')
Bagnon.LogToggle = LogToggle

local SIZE = 20
local NORMAL_TEXTURE_SIZE = 64 * (SIZE/36)


--[[ Constructor ]]--

function LogToggle:New(parent, isMoney)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent))
	b:SetWidth(SIZE)
	b:SetHeight(SIZE)
	b:RegisterForClicks('anyUp')

	local nt = b:CreateTexture()
	nt:SetTexture([[Interface\Buttons\UI-Quickslot2]])
	nt:SetWidth(NORMAL_TEXTURE_SIZE)
	nt:SetHeight(NORMAL_TEXTURE_SIZE)
	nt:SetPoint('CENTER', 0, -1)
	b:SetNormalTexture(nt)

	local pt = b:CreateTexture()
	pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	pt:SetAllPoints(b)
	b:SetPushedTexture(pt)

	local ht = b:CreateTexture()
	ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	ht:SetAllPoints(b)
	b:SetHighlightTexture(ht)

	local ct = b:CreateTexture()
	ct:SetTexture([[Interface\Buttons\CheckButtonHilight]])
	ct:SetAllPoints(b)
	ct:SetBlendMode('ADD')
	b:SetCheckedTexture(ct)

	local icon = b:CreateTexture()
	icon:SetAllPoints(b)
	
	if isMoney then
		icon:SetTexture([[Interface\Icons\INV_Misc_Coin_01]])
	else
		icon:SetTexture([[Interface\Icons\INV_Misc_Note_05]])
	end

	if isMoney then
		b:RegisterMessage('SHOW_LOG_TRANSACTIONS', 'Uncheck')
	else
		b:RegisterMessage('SHOW_LOG_MONEY', 'Uncheck')
	end
	
	b:RegisterMessage('GUILD_BANK_CLOSED', 'Uncheck')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b.isMoney = isMoney
	
	return b
end


--[[ Frame Events ]]--

function LogToggle:OnClick()
	if self:GetChecked() then
		self:SendMessage('SHOW_LOG_FRAME')
		
		if self:IsMoney() then
			self:SendMessage('SHOW_LOG_MONEY')
		else
			self:SendMessage('SHOW_LOG_TRANSACTIONS')
		end
	else
		self:SendMessage('SHOW_ITEM_FRAME')
	end
end

function LogToggle:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end
	
	if self:IsMoney() then
		GameTooltip:SetText('Click to show the money log')
	else
		GameTooltip:SetText('Click to show the transaction log')
	end
end

function LogToggle:OnLeave()
	GameTooltip:Hide()
end


--[[ API ]]--

function LogToggle:IsMoney()
	return self.isMoney
end

function LogToggle:Uncheck()
	self:SetChecked(false)
end