-- GLOBALS: LibStub
local addon   = LibStub('AceAddon-3.0'):GetAddon('BagMeters')
local factory = addon:NewModule('MeterFactory')

factory.BACKPACK = 'backpack'
factory.CHAR_BAG = 'char'
factory.BANK_BAG = 'bank'

local MeterClass	-- Forward declaration
function factory:NewMeter(...)
	return MeterClass:new(...)
end

local _G = _G
local setmetatable = setmetatable
local CreateFrame, GetContainerNumSlots, GetContainerNumFreeSlots = CreateFrame, GetContainerNumSlots, GetContainerNumFreeSlots
local BACKPACK_CONTAINER, NUM_BAG_SLOTS, NUM_BANKBAGSLOTS = BACKPACK_CONTAINER, NUM_BAG_SLOTS, NUM_BANKBAGSLOTS

------------------------------------------------------------------------------
local function getFadedColor(mini, maxi, current)
	-- Return a color shading from green (if current value is close to mini)
	-- to yellow (if it's halfway) to red (if it's close to maxi).

	local pct = current / ((maxi - mini) or 1)
	local r, g

	-- Those 7 lines were shamelessly stolen from CT_UnitFrames.lua
	if (pct > 0.5) then
		r = (1.0 - pct) * 2
		g = 1.0
	else
		r = 1.0
		g = pct * 2
	end

	return r, g, 0, 0.8
end

------------------------------------------------------------------------------
-- La classe
------------------------------------------------------------------------------
MeterClass = {
	disabled = false,
	bagId    = nil,
	frame    = nil,
	bar      = nil,
	text     = nil
}
MeterClass.__index = MeterClass

-- Crée un nouveau compteur
function MeterClass:new(bagType, bagNum)

	local o = {}
	setmetatable(o, self)

	-- Trouve le bagId
	if (bagType == factory.BACKPACK) then
		o.bagId = BACKPACK_CONTAINER
		o.parent  = _G['MainMenuBarBackpackButton']
	elseif (bagType == factory.CHAR_BAG) then
		o.bagId = bagNum										-- 1 => NUM_BAG_SLOTS
		o.parent  = _G['CharacterBag'..(bagNum - 1)..'Slot']	-- 'CharacterBag0Slot' => 'CharacterBag3Slot'
	elseif (bagType == factory.BANK_BAG) then
		o.bagId = bagNum + NUM_BAG_SLOTS						-- NUM_BAG_SLOTS + 1 => NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
		o.parent  = _G['BankSlotsFrame']['Bag'..bagNum]			-- 'BankSlotsFrame.Bag1' => 'BankSlotsFrame.Bag7'
	else
		return
	end

	-- Crée les widgets
	o.frame = CreateFrame('Frame', nil, o.parent)
	o.frame:SetAllPoints(o.parent)
	o.frame:SetFrameLevel(o.parent:GetFrameLevel() + 5)

	o.bar = CreateFrame('StatusBar', nil, o.frame)
	o.bar:SetWidth(o.parent:GetWidth())
	o.bar:SetHeight(11)
	o.bar:SetPoint('BOTTOM')
	o.bar:SetMinMaxValues(0, 1)
	o.bar:SetValue(1)
	o.bar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar', 'BACKGROUND')

	o.text = o.bar:CreateFontString(nil, 'ARTWORK', 'SystemFont_Tiny')
	o.text:SetPoint('CENTER', o.bar, 'CENTER', 0, 0)
	o.text:SetTextColor(1, 1, 1, 1)

	o:update()
	return o
end

-- Met à jour le compteur
function MeterClass:update()

	if self.parent:IsVisible() then
		local total = GetContainerNumSlots(self.bagId)
		local free  = GetContainerNumFreeSlots(self.bagId)

		if total == 0 or self.disabled then
			self.frame:Hide()
		else
			-- Affiche le nombre d'emplacements libres/total
			self.bar:SetStatusBarColor(getFadedColor(0, total, free))
			self.text:SetText(free..'/'..total)
			self.frame:Show()
		end
	else
		self.frame:Hide()
	end
end

-- On/Off
function MeterClass:disable()
	self.disabled = true
	self:update()
end

function MeterClass:enable()
	self.disabled = false
	self:update()
end
