--Cache global variables
--Lua functions
local tonumber, print, pairs, select = tonumber, print, pairs, select
local tconcat, twipe, tinsert = table.concat, table.wipe, table.insert
local gsub, lower, upper, match, format, strsplit = string.gsub, string.lower, string.upper, string.match, string.format, strsplit
--WoW API / Variables
local C_Timer_After = C_Timer.After
local FindAuraByName = AuraUtil.FindAuraByName
local GetBindingKey = GetBindingKey
local GetContainerItemEquipmentSetInfo = GetContainerItemEquipmentSetInfo
local GetContainerItemID = GetContainerItemID
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetInstanceInfo = GetInstanceInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: BINDING_HEADER_GARRISONDISENCHANT, SLASH_GARRISONDISENCHANT1, SLASH_GARRISONDISENCHANT2
-- GLOBALS: GarrisonDisenchantDB, GameTooltip, StaticPopup_Show

-- local variables
local LibProcessable = LibStub("LibProcessable-GarrisonDisenchant")
local disenchantBuffName = GetSpellInfo(161724) --Essence Attunement
local atEnchantBuilding = false
local bagIDs = {0, 1, 2, 3, 4}
local InvSlotIDs = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19}
local ignoredCache = {}
local equippedCache = {}
local promptedItemLink
local suppressHideNotice = false
local displayOverride = false
local garrisonMaps = {
	[1152] = true, -- FW Horde Garrison Level 1
	[1330] = true, -- FW Horde Garrison Level 2
	[1153] = true, -- FW Horde Garrison Level 3
	[1154] = true, -- FW Horde Garrison Level 4
	[1158] = true, -- SMV Alliance Garrison Level 1
	[1331] = true, -- SMV Alliance Garrison Level 2
	[1159] = true, -- SMV Alliance Garrison Level 3
	[1160] = true, -- SMV Alliance Garrison Level 4
}

-- settings
local Defaults = {
	["ignoreItemSets"] = true,		-- filters out items that are part of any of your equipmentsets. They are not added to the ignore list.
	["promptEquipped"] = true,		-- prompts the user before disenchanting items which have been equipped during the session.
	["positionLocked"] = true,		-- controls whether or not the button is movable by dragging.
	["qualityBorder"] = true,		-- colors the border to match item quality.
	["buttonSize"] = 60,			-- size in of the button in pixels
	["displayOverride"] = false,	-- forces the button to show, useful for real enchanters
	["filterQuality"] = {			-- filters out items of a specific quality
		["uncommon"] = false,
		["rare"] = false,
		["epic"] = false,
	},
}

-- localization
BINDING_HEADER_GARRISONDISENCHANT = "Garrison Disenchant"
_G["BINDING_NAME_CLICK GarrisonDisenchant:LeftButton"] = "Disenchant Item Currently Shown"

-- frame creation
local GD = CreateFrame("Button", "GarrisonDisenchant", UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
GD:SetPoint("CENTER", 0, 100) --Default position. If moved, the WoW client will handle position.
GD:SetBackdrop({
	bgFile = "Interface/BUTTONS/WHITE8X8",
	edgeFile = "Interface/BUTTONS/WHITE8X8",
	tile = false, tileSize = 0, edgeSize = 2,
	insets = { left = 0, right = 0, top = 0, bottom = 0}
})
GD:SetBackdropColor(0, 0, 0, 0)
GD:SetNormalTexture(nil)
GD:SetPushedTexture(nil)
GD:SetMovable(true)
GD:EnableMouseWheel(true)
GD:RegisterForClicks("LeftButtonUp", "RightButtonUp")
GD:Hide()

GD.icon:SetTexCoord(.08, .92, .08, .92)

GD.HotKey = GD:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
GD.HotKey:SetShadowColor(0,0,0)
GD.HotKey:SetShadowOffset(1,-1)
GD.HotKey:SetPoint("BOTTOMLEFT", GD, "BOTTOMLEFT", 3, 3)
GD.HotKey:SetPoint("TOPRIGHT", GD, "TOPRIGHT", -3, -3)
GD.HotKey:SetJustifyV("TOP")
GD.HotKey:SetJustifyH("RIGHT")

GD.Version = GetAddOnMetadata("GarrisonDisenchant", "Version")

--Handle the prompt on equipped items
StaticPopupDialogs["GD_PROMPT_EQUIPPED"] = {
	text = "The following item was previously equipped, are you sure you want to disenchant it? Click the icon again if you wish to disenchant the item.",
	button1 = "Ok!",
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 3,
	showAlert = true,
	hasItemFrame = true,
}

-- functions
local function GDPrint(...)
	print('|cff00b3ffGD:|r', ...)
end

local function BuildIgnoredCache()
	twipe(ignoredCache)
	for itemID in pairs(GarrisonDisenchantDB["Ignored"]) do
		if not ignoredCache[itemID] then ignoredCache[itemID] = true end
	end
end

local function AddEquippedItemToCache(slot)
	if not slot then return; end

	local itemLink = GetInventoryItemLink("player", slot)
	if not itemLink then return; end --No item equipped in this slot

	--On first login, the text might be missing from item links.
	--Test for it here and schedule a 2nd attempt if first one failed
	local itemText = match(itemLink, "%[(%S.+)%]")
	if itemText and not equippedCache[itemLink] then
		equippedCache[itemLink] = true
	elseif (not itemText) then
		C_Timer_After(5, function() AddEquippedItemToCache(slot) end)
	end
end

local function UpdateButton(bagID, slot)
	if InCombatLockdown() then return; end

	if (not bagID or not slot) then
		GD.itemID = nil
		GD.itemLink = nil
		GD.bagID = nil
		GD.bagSlot = nil
		GD.wasEquipped = nil
		GD:Hide()
		promptedItemLink = nil
	else
		local texture, _, _, quality = GetContainerItemInfo(bagID, slot)
		local itemID = GetContainerItemID(bagID, slot)
		local itemLink = GetContainerItemLink(bagID, slot)
		local color = GarrisonDisenchantDB["Settings"].qualityBorder and ITEM_QUALITY_COLORS[quality] or {r = 0, g = 0, b = 0}
		local wasEquipped = equippedCache[itemLink]
		local macroText
		if displayOverride then
			macroText = format("/cast Disenchant\n/use %d %d", bagID, slot)
		else
			macroText = format("/use %d %d", bagID, slot)
		end
		GD:SetBackdropBorderColor(color.r, color.g, color.b)
		GD.icon:SetTexture(texture)
		GD.itemID = itemID
		GD.itemLink = itemLink
		GD.bagID = bagID
		GD.bagSlot = slot
		GD.wasEquipped = wasEquipped
		GD:SetAttribute("type1", "macro")
		GD:SetAttribute("macrotext1", macroText)
		GD:Show()
	end
end

local function SetButtonSize(size)
	if not size or not tonumber(size) then return; end

	size = tonumber(size)
	if size < 20 then
		size = 20
	elseif size > 100 then
		size = 100
	end

	GarrisonDisenchantDB["Settings"].buttonSize = size
	GD:SetSize(size, size)
end

local function FindItem()
	for _, bagID in pairs(bagIDs) do
		local numSlots = GetContainerNumSlots(bagID)
		for slot = 1, numSlots do
			local itemID = GetContainerItemID(bagID, slot)

			if itemID then
				local isDisenchantable = LibProcessable:IsDisenchantable(itemID, true)
				local isInSet = GetContainerItemEquipmentSetInfo(bagID, slot)
				local _, _, quality = GetItemInfo(itemID)

				if isDisenchantable and not ignoredCache[itemID] and ((GarrisonDisenchantDB.Settings.ignoreItemSets and not isInSet) or not GarrisonDisenchantDB.Settings.ignoreItemSets) then
					if (quality == 2 and not GarrisonDisenchantDB.Settings.filterQuality.uncommon) or
					 (quality == 3 and not GarrisonDisenchantDB.Settings.filterQuality.rare) or
					 (quality == 4 and not GarrisonDisenchantDB.Settings.filterQuality.epic) then
						UpdateButton(bagID, slot)
						suppressHideNotice = false
						return
					end
				end
			end
		end
	end

	if not suppressHideNotice then
		GDPrint("No disenchantable items found, hiding button!")
		suppressHideNotice = true
	end
end

local function UpdateBinding()
	local text = GetBindingKey("CLICK GarrisonDisenchant:LeftButton")
	if text then
		text = gsub(text, 'SHIFT', "Shift")
		text = gsub(text, 'ALT', "Alt")
		text = gsub(text, 'CTRL', "Ctrl")
		text = gsub(text, 'BUTTON', "M")
		text = gsub(text, 'MOUSEWHEELUP', "MwU")
		text = gsub(text, 'MOUSEWHEELDOWN', "MwD")
		text = gsub(text, 'NUMPAD', "N")
		text = gsub(text, 'PAGEUP', "PU")
		text = gsub(text, 'PAGEDOWN', "PD")
		text = gsub(text, 'SPACE', "SpB")
		text = gsub(text, 'INSERT', "Ins")
		text = gsub(text, 'HOME', "Hm")
		text = gsub(text, 'DELETE', "Del")
		text = gsub(text, 'NMULTIPLY', "*")
		text = gsub(text, 'NMINUS', "N-")
		text = gsub(text, 'NPLUS', "N+")
	end
	GD.HotKey:SetText(text);
end

local function GetItemIDFromItem(item)
	if not item then return; end
	local itemID
	if tonumber(item) then
		itemID = item
	else
		local _, itemLink = GetItemInfo(item)
		if itemLink then
			local itemString = match(itemLink, "item[%-?%d:]+")
			local _, id = strsplit(":", itemString)
			itemID = id
		end
	end

	return itemID
end

function GD:IgnoreItem(item)
	local itemID
	if not item then
		itemID = GD.itemID
	else
		local itemString = match(item, "item[%-?%d:]+")
		if itemString then
			local _, id = strsplit(":", itemString)
			itemID = id
		else
			itemID = GetItemIDFromItem(item) or GD.itemID
		end
	end
	if not itemID then
		return
	end

	local _, itemLink = GetItemInfo(itemID)
	if itemLink and LibProcessable:IsDisenchantable(itemID, true) then
		GarrisonDisenchantDB["Ignored"][tonumber(itemID)] = true
		BuildIgnoredCache()
		GDPrint("Following item was ignored:", itemLink)
	elseif itemLink then
		GDPrint(format("|cff4BEB2CError:|r The item %s is not disenchantable.", itemLink))
	else
		GDPrint("|cff4BEB2CError:|r Unable to find disenchantable item from input:", item)
	end

	if atEnchantBuilding or displayOverride then
		UpdateButton()
		FindItem()
	end

	return true
end

local function RemoveItemFromIgnore(item)
	if not item or item == "" then return; end

	if item == "all" then
		twipe(ignoredCache)
		twipe(GarrisonDisenchantDB["Ignored"])
		GDPrint("All items removed from ignore.")
	elseif item then
		local itemID
		local itemString = match(item, "item[%-?%d:]+")
		if itemString then
			local _, id = strsplit(":", itemString)
			itemID = tonumber(id)
		else
			itemID = tonumber(GetItemIDFromItem(item))
		end
		if not itemID then
			return;
		end

		if GarrisonDisenchantDB["Ignored"][itemID] then
			GarrisonDisenchantDB["Ignored"][itemID] = nil
			local _, itemLink = GetItemInfo(itemID)
			if itemLink then
				GDPrint("Item removed from ignore:", itemLink)
			end
		end
	end
	BuildIgnoredCache()
	if atEnchantBuilding or displayOverride then
		FindItem()
	end

	return true
end

local function GetIgnoredItemsAsString()
	local temp = {}
	for itemID in pairs(ignoredCache) do
		local _, itemLink = GetItemInfo(itemID)
		tinsert(temp, itemLink)
	end
	local itemString = tconcat(temp, ", ")
	if itemString == "" then itemString = "None" end
	return itemString
end

local function ToggleEquipmentFilter()
	local setting = GarrisonDisenchantDB.Settings.ignoreItemSets
	GarrisonDisenchantDB["Settings"].ignoreItemSets = (setting == false and true) or false

	local state = GarrisonDisenchantDB["Settings"].ignoreItemSets == true and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r"
	GDPrint("EquipmentSet Filter is now:", state)

	if atEnchantBuilding or displayOverride then
		UpdateButton()
		FindItem()
	end
end

local function TogglePrompt()
	local setting = GarrisonDisenchantDB.Settings.promptEquipped
	GarrisonDisenchantDB["Settings"].promptEquipped = (setting == false and true) or false

	local state = GarrisonDisenchantDB["Settings"].promptEquipped == true and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r"
	GDPrint("Prompt on equipped items is now:", state)

	--Reset prompt
	promptedItemLink = nil
end

local function ToggleButtonQualityBorder()
	local setting = GarrisonDisenchantDB["Settings"].qualityBorder
	GarrisonDisenchantDB["Settings"].qualityBorder = (setting == false and true) or false

	local state = GarrisonDisenchantDB["Settings"].qualityBorder == true and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r"
	GDPrint("Quality Border is now:", state)

	if atEnchantBuilding or displayOverride then
		FindItem()
	end
end

local function ToggleDisplayOverride()
	local setting = GarrisonDisenchantDB["Settings"].displayOverride
	GarrisonDisenchantDB["Settings"].displayOverride = (setting == false and true) or false

	--Update internal displayOverride value
	displayOverride = GarrisonDisenchantDB["Settings"].displayOverride

	if displayOverride then
		GD:RegisterEvent("BAG_NEW_ITEMS_UPDATED") --Update button if we loot an item from mob or mailbox
		GD:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		UpdateButton()
		FindItem()
	elseif not atEnchantBuilding then
		GD:UnregisterEvent("BAG_NEW_ITEMS_UPDATED")
		GD:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		UpdateButton() --Hide
	end

	local state = (displayOverride == true and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r")
	GDPrint("Display override is now:", state)
end

local function ToggleButtonLock()
	local setting = GarrisonDisenchantDB["Settings"].positionLocked
	GarrisonDisenchantDB["Settings"].positionLocked = (setting == false and true) or false

	if GarrisonDisenchantDB["Settings"].positionLocked then
		GD:RegisterForDrag()
		GDPrint("Button position is now: |cffFF0000Locked|r")
	else
		GD:RegisterForDrag("LeftButton")
		GDPrint("Button position is now: |cff00FF00Unlocked|r")
	end
end

local function ToggleQualityFilter(quality)
	if quality ~= "uncommon" and quality ~= "rare" and quality ~= "epic" then
		return;
	end

	local setting = GarrisonDisenchantDB["Settings"]["filterQuality"][quality]
	if setting ~= nil then
		local colorIndex = (quality == "uncommon" and 2) or (quality == "rare" and 3) or (quality == "epic" and 4)
		local hexColor = ITEM_QUALITY_COLORS[colorIndex].hex
		GarrisonDisenchantDB["Settings"]["filterQuality"][quality] = (setting == false and true) or false

		local state = GarrisonDisenchantDB["Settings"]["filterQuality"][quality] == true and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r"
		GDPrint(format("Quality filter for %s%s|r items is now: %s", hexColor, upper(quality), state))
	else
		return
	end

	UpdateButton()
	FindItem()

	return true
end

local function PrintCommands()
	GDPrint("Command List. Usage: |cff4BEB2C/gd|r [|cffff8000command|r]")
	GDPrint("|cff4BEB2CIgnorelist:|r |cffff8000ignore|r | |cffff8000remove|r | |cffff8000list|r")
	GDPrint("|cff4BEB2CDisenchant Protection:|r |cffff8000filter|r | |cffff8000prompt|r | |cffff8000quality|r")
	GDPrint("|cff4BEB2CButton:|r |cffff8000border|r | |cffff8000size|r | |cffff8000lock|r | |cffff8000override|r")
	GDPrint("|cff4BEB2COther:|r |cffff8000version|r | |cffff8000help|r")
end

local function PrintHelp()
	GDPrint("Invalid command or parameter. Use |cff4BEB2C/gd help|r [|cffff8000command|r]")
end

-- slash commands
SLASH_GARRISONDISENCHANT1, SLASH_GARRISONDISENCHANT2 = "/garrisondisenchant", "/gd"
local function CommandHandler(arg)
	local command, param = arg:match("^(%S*)%s*(.-)$")
	if command then command = lower(command) end
	if param then param = lower(param) end

	if command == "ignore" then
		if param and param ~= "" then
			local success = GD:IgnoreItem(param)
			if not success then PrintHelp() end
		else
			PrintHelp()
		end

	elseif command == "remove" then
		if param and param ~= "" then
			local success = RemoveItemFromIgnore(param)
			if not success then PrintHelp() end
		else
			PrintHelp()
		end

	elseif command == "list" then
		GDPrint(format("List of Ignored Items: %s", GetIgnoredItemsAsString()))

	elseif command == "filter" then
		ToggleEquipmentFilter()

	elseif command == "prompt" then
		TogglePrompt()

	elseif command == "lock" then
		ToggleButtonLock()

	elseif command == "size" then
		if param and tonumber(param) then
			SetButtonSize(param)
		else
			PrintHelp()
		end

	elseif command == "border" then
		ToggleButtonQualityBorder()

	elseif command == "override" then
		ToggleDisplayOverride()

	elseif command == "quality" then
		if param and param ~= "" then
			local success = ToggleQualityFilter(param)
			if not success then PrintHelp() end
		else
			PrintHelp()
		end

	elseif command == "version" then
		GDPrint(format("Installed Version: |cff4BEB2C%s|r", GD.Version))

	elseif command == "help" then
		if param == "ignore" then
			GDPrint("|cff4BEB2C/gd ignore|r [|cffff8000itemID|r | |cffff8000itemName|r | |cffff8000itemLink|r]")
		elseif param == "remove" then
			GDPrint("|cff4BEB2C/gd remove|r [|cffff8000itemID|r | |cffff8000itemLink|r | |cffff8000all|r]")
		elseif param == "size" then
			GDPrint("|cff4BEB2C/gd size|r [|cffff8000number|r] (20 to 100)")
		elseif param == "quality" then
			GDPrint("|cff4BEB2C/gd quality|r [|cffff8000uncommon|r | |cffff8000rare|r | |cffff8000epic|r]")
		else
			GDPrint("Use '/gd help [command]' for information about a command.")
			PrintCommands()
		end
	else
		PrintCommands()
	end
end
SlashCmdList["GARRISONDISENCHANT"] = CommandHandler

-- script handlers
GD:SetScript("OnDragStart", GD.StartMoving)
GD:SetScript("OnDragStop", GD.StopMovingOrSizing)
GD:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
GD:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
	GameTooltip:SetBagItem(self.bagID, self.bagSlot)
	GameTooltip:Show()
end)
GD:SetScript("OnHide", function(self)
	if self.isMoving then
		self:StopMovingOrSizing();
		self.isMoving = false;
	end
end)
GD:SetScript("OnMouseWheel", function(self, delta)
	if not IsControlKeyDown() then return; end
	SetButtonSize(GarrisonDisenchantDB["Settings"].buttonSize + delta)
end)
--Check if we need to prompt the user before we cast the disenchant on an item
GD:HookScript("PreClick", function(self, button)
	if button == "LeftButton" then
		if (GarrisonDisenchantDB.Settings.promptEquipped and GD.wasEquipped) then
			if not (promptedItemLink == GD.itemLink) then
				local itemLink = GetContainerItemLink(GD.bagID, GD.bagSlot)
				local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(itemLink);
				local r, g, b = GetItemQualityColor(itemRarity)
				StaticPopup_Show("GD_PROMPT_EQUIPPED", nil, nil, {["texture"] = itemTexture, ["name"] = itemName, ["color"] = {r, g, b, 1}, ["link"] = itemLink})
				promptedItemLink = GD.itemLink
				self:SetAttribute("macrotext1", "")
			else
				UpdateButton()
				FindItem()
			end
		end
	end
end)

-- event handling
GD:RegisterEvent("PLAYER_LOGIN")
GD:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event == "PLAYER_LOGIN" then
		--Initialize saved vars
		if GarrisonDisenchantDB == nil then GarrisonDisenchantDB = {} end
		if GarrisonDisenchantDB.Settings == nil then GarrisonDisenchantDB.Settings = Defaults end
		if GarrisonDisenchantDB.Ignored == nil then GarrisonDisenchantDB.Ignored = {} end

		--Add new settings to saved vars if they don't already exist
		for k,v in pairs(Defaults) do
			if GarrisonDisenchantDB["Settings"][k] == nil then
				GarrisonDisenchantDB["Settings"][k] = v
			end
		end

		--Set button size
		SetButtonSize(GarrisonDisenchantDB["Settings"].buttonSize)

		--Make the button movable if unlocked
		if not GarrisonDisenchantDB["Settings"].positionLocked then
			GD:RegisterForDrag("LeftButton")
		end

		--Register helper events
		self:RegisterEvent("GARRISON_UPDATE")
		self:RegisterEvent("UPDATE_BINDINGS")
		self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

		--Set keybind text, build ignore cache and build cache of equipped items
		UpdateBinding()
		BuildIgnoredCache()
		for _, slot in pairs(InvSlotIDs) do
			AddEquippedItemToCache(slot)
		end

		--Update internal displayOverride value
		displayOverride = GarrisonDisenchantDB["Settings"].displayOverride

		--In case of /reload while having override or the disenchant buff active, update icon
		if FindAuraByName(disenchantBuffName, "player") or displayOverride then
			atEnchantBuilding = true
			FindItem()
			self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			self:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
		end

		--Set right click ignore action
		GD:SetAttribute("type2", "macro")
		GD:SetAttribute("macrotext2", "/run GarrisonDisenchant:IgnoreItem()")

		--Print addon information
		GDPrint(format("GarrisonDisenchant version: |cff4BEB2C%s|r", GD.Version))
		GDPrint("Use |cff4BEB2C/gd|r or |cff4BEB2C/garrisondisenchant|r to configure")

	elseif event == "UPDATE_BINDINGS" then
		UpdateBinding()

	elseif event == "GARRISON_UPDATE" then
		local mapID = select(8, GetInstanceInfo())
		if garrisonMaps[mapID] then
			self:RegisterEvent("SPELL_CONFIRMATION_PROMPT")
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		elseif not displayOverride then
			atEnchantBuilding = false
			self:UnregisterEvent("SPELL_CONFIRMATION_PROMPT")
			self:UnregisterEvent("UNIT_AURA")
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
			self:UnregisterEvent("BAG_NEW_ITEMS_UPDATED")
		end

	elseif event == "UNIT_AURA" and arg1 == "player" then
		if not FindAuraByName(disenchantBuffName, "player") then
			atEnchantBuilding = false
			UpdateButton() --Hide button
		end

	elseif event == "CURRENT_SPELL_CAST_CHANGED" then
		if FindAuraByName(disenchantBuffName, "player") then
			atEnchantBuilding = true
			FindItem()
		end

	elseif event == "SPELL_CONFIRMATION_PROMPT" and tonumber(arg1) == 161736 then --Disenchant prompt from clicking the Essence Font
		self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED") --Subsequent clicks on the Essence Font triggers this event

	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" and (tonumber(arg5) == 160201 or tonumber(arg5) == 13262) then --Disenchant
		self:RegisterEvent("BAG_UPDATE") --Successful disenchant leads to looting and triggers this event
	elseif event == "BAG_UPDATE" then
		self:UnregisterEvent("BAG_UPDATE")
		UpdateButton()
		FindItem() --An item was just disenchanted and looted, find next item

	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		--In case the button is clicked without disenchant action active.
		--Items will be swapped, so make sure we don't accidentally disenchant the item sitting in the bag slot of the old item.
		if atEnchantBuilding or displayOverride then
			UpdateButton()
			FindItem()
		end

		--Add the equipped item to the list of items which should receive a prompt before being disenchanted.
		local slot = arg1
		AddEquippedItemToCache(slot)
	elseif event == "BAG_NEW_ITEMS_UPDATED" then
		FindItem()
	end
end)
