local P, E, L = unpack(select(2, ...))

local categoryName = L['Trade Goods']
local categoryIndex = 40

local categoryFilter = function(bagID, slotID, itemID)
	local custom = BackpackKnownItems[itemID]
	if(custom and custom == categoryIndex) then
		return true
	else
		-- tradegoods/reagents
		local _, _, _, _, _, itemClass = GetItemInfoInstant(itemID)
		return itemClass == LE_ITEM_CLASS_TRADEGOODS
	end
end

P.AddCategory(categoryIndex, categoryName, 'TradeGoods', categoryFilter)
