local MAJOR, MINOR = 'LibProcessable-GarrisonDisenchant', 32
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local professions = {}

function lib:IsDisenchantable(item, override)
	local itemID = item
	if(type(itemID) == 'string') then
		assert(string.match(itemID, 'item:(%d+):') or tonumber(itemID), 'item must be an item ID or item Link')
		itemID = (tonumber(itemID)) or (GetItemInfoFromHyperlink(itemID))
	end

	if(self:HasProfession(333)) or override then -- Enchanting
		if(self.enchantingItems[itemID]) then
			-- special items that can be disenchanted
			return true
		else
			local _, _, quality, _, _, _, _, _, _, _, _, class, subClass = GetItemInfo(item)
			return (quality >= LE_ITEM_QUALITY_UNCOMMON and quality <= LE_ITEM_QUALITY_EPIC)
				and (class == LE_ITEM_CLASS_ARMOR or class == LE_ITEM_CLASS_WEAPON
				or (class == LE_ITEM_CLASS_GEM and subClass == 11)) -- artifact relics
		end
	end
end

function lib:HasProfession(professionID)
	return not not professions[professionID]
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('SKILL_LINES_CHANGED')
Handler:SetScript('OnEvent', function(self, event, ...)
	table.wipe(professions)

	local first, second = GetProfessions()
	if(first) then
		local _, _, _, _, _, _, professionID = GetProfessionInfo(first)
		professions[professionID] = true
	end

	if(second) then
		local _, _, _, _, _, _, professionID = GetProfessionInfo(second)
		professions[professionID] = true
	end
end)

lib.enchantingBuildings = {
	[93] = true,
	[125] = true,
	[126] = true,
}

lib.enchantingItems = {
	-- These items are used as part of the Legion enchanting quest line
	[137195] = true, -- Highmountain Armor
	[137221] = true, -- Enchanted Raven Sigil
	[137286] = true, -- Fel-Crusted Rune
}
