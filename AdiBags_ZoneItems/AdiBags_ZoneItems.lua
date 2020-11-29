--[[
AdiBags_ZoneItems - Groups  items for specific zones, expansions or activities together, an addition to Adirelle's fantastic bag addon AdiBags.
Copyright 2020 Ggreg Taylor
--]]
local addonName, addon = ...	
local AdiBags = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})
local setFilter = AdiBags:RegisterFilter("ZoneItems", 93, 'ABEvent-1.0')
setFilter.uiName = L['Zone Specific Items']
setFilter.uiDesc = L['Group zone specific items together.']

local kCurrBoAMin = 67
local kLowGearThreshold = 20
local kMinExpansionIlevel = 75

local Ggbug = false
if Ggbug == true then print(addonName , 'loaded.') end
-- debugging values
local lookForId = -1
local testSlot = {0,6}
local bagItemID
local currItemBagSlot = {}
-- General Constants
local errNOT_FOUND = -101
local kCategory = L['Zone Item']
local kPfx = '|cff00ffff'  -- teal
--local kPfx2 = '|cffFF99FF' -- bright PINK
local kPfx2 = '|cff3CE13F' -- bright green1
local kPfx3 = '|cff2FEB77' -- bright green2
local kSfx = '|r'
-- Set special top-of-bags category for current zone's items
local CURRENT_ZONE_ITEM = L['Current Zone Item']
local CURRENT_ZONE_ITEM2 = L['Current Zone']
local PRIORITY_ITEM = L['Attention!']
AdiBags:SetCategoryOrder(CURRENT_ZONE_ITEM, 80)
AdiBags:SetCategoryOrder(PRIORITY_ITEM, 79)
AdiBags:SetCategoryOrder(CURRENT_ZONE_ITEM2, 78) -- To be ordered after zone match items
-- Global Variables
local currZoneId, currMap, currMapID, mapName, parentMapID, parentMapName

local function Ggprint(...) 
  if ((lookForId == bagItemID) or (testSlot[1] == currItemBagSlot[1] and testSlot[2] ==  currItemBagSlot[2])) and Ggbug == true then print(...) end
end

------------------------------------------------------------------------------
function setFilter:OnInitialize(b)
  self.db = AdiBags.db:RegisterNamespace('ZoneItems', {
    profile = { 
      enable = true ,
      enableZoneItem = true,
      groupBoATokens = true,
      groupEssences = true,
      groupMechagon = true,
      groupMission = true,
      groupNazjatar = true,
      groupTimeless = true,
      groupPatch8_3 = true,
      groupCorrupted = true,
		  groupRepItems  = true,
      zonePriority = true,
      groupAzerite = true,
      groupScourge = true,
      groupLowGear = false,
  },
    char = {  },
  })
end
function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end
function setFilter:OnEnable()
  AdiBags:UpdateFilters()
end
function setFilter:OnDisable()
  AdiBags:UpdateFilters()
end
function setFilter:GetOptions()
  return {
    enable = {
      name = L['Enable Zone Item groups'],
      desc = L['Check this if you want to automatically seperate Nazjatar and Mechagon items.'],
      type = 'toggle',
      order = 20,
    },
    groupSetCurrentFirst = {
      name = L['Current Zone First in Bags'],
      type = L['group'],
      inline = true,
      order = 24,
      args = {
        _desc = {
          name = L['Group items relevant for the current zone(s) to top of bags for quicker access.'],
          type = 'description',
          order = 10,
        }, 
        zonePriority = {
          name = L['Enable'],
          desc = L['Only a monster would disable this feature. You aren\'t a monster now, are you?'],
          type = 'toggle',
          order = 33,
        },
      }
    },
    groupSetZoneItemSubgroups = {
      name = L['Battle for Azeroth Groups'],
      type = L['group'],
      inline = true,
      order = 28,
      args = {
        _desc = {
          name = L['Select optional additional sub-groupings.'],
          type = 'description',
          order = 10,
        }, 
        groupMechagon = {
          name = L['Mechagon'],
          desc = L['Group items specific to Mechagon seperately.'],
          type = 'toggle',
          order = 26,
        },
        groupNazjatar = {
          name = L['Nazjatar'],
          desc = L['Group items specific to Nazjatar seperately.'],
          type = 'toggle',
          order = 27,
        },
        groupEssences = {
          name = L['Heart Essences'],
          desc = L['Group Heart of Azeroth essences seperately.'],
          type = 'toggle',
          order = 29,
        },
        groupPatch8_3 = {
          name = L['Uldum, Vale, Visions'],
          desc = L['Group items added in Patch 8.3 for Uldum, Horrific Visions, and Vale of Eternal Blossoms. They really should leave that poor Vale alone.'],
          type = 'toggle',
          order = 30,
        },
 --[[        groupCorrupted = {
          name = L[CORRUPTION_TOOLTIP_TITLE],
          desc = L['Group corrupted items.'],
          type = 'toggle',
          order = 34,
        }, ]]
        groupAzerite = {
          name = L['Azerite Armor'],
          desc = L['Group corrupted items.'],
          type = 'toggle',
          order = 35,
        },
        ---[[
        groupLowGear = {
          name = L['Low iLevel Separated'],
          desc = L['Group current expansion low item level gear separately.'],
          type = 'toggle',
          order = 36,
        }, 
        groupScourge = {
          name = L['Scourge Invasions'],
          desc = L['Scourge Invasion items.'],
          type = 'toggle',
          order = 33,
        },
        --]]
      }
    },
    otherMiscGroups = {
      name = L['Other Groupings'],
      type = L['group'],
      inline = true,
      order = 29,
      args = {
        _desc = {
          name = L['Group filters for Prior Expansions and More.'],
          type = 'description',
          order = 10,
        }, 
        groupBoATokens = {
          name = L['BoA Gear Tokens'],
          desc = L['Group Benthic and Black Empire Bind on Account gear tokens seperately.'],
          type = 'toggle',
          order = 25,
        },
        groupRepItems = {
          name = L['Reputation Items'],
          desc = L['Group Reputation on-use and repeatable turn-in items seperately.'],
          type = 'toggle',
          order = 28,
        },
        groupMission = {
          name = L['Garrison & Class Hall'],
          desc = L[GARRISON_LOCATION_TOOLTIP .. '/' ..ORDER_HALL_MISSIONS],
          type = 'toggle',
          order = 31,
        },
        groupTimeless = {
          name = L['Pandaria Timeless Isle'],
          desc = L['Pandaria Timeless Isle-specific items.'],
          type = 'toggle',
          order = 32,
        },
      }
    },
  }, AdiBags:GetOptionHandler(self, false, function() return self:Update() end)
end

local function ttCreate()
  local tip, rightside, leftside = CreateFrame("GameTooltip"), {}, {}
  for i = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftside[i] = L
    rightside[i] = R
  end
  tip.leftside = leftside
  tip.rightside = rightside
  return tip
end
local tooltip = tooltip or ttCreate()

local function loadMapIDs()
  currZoneId = C_Map.GetBestMapForUnit("player")
  if currZoneId ~= nil then
    currMap = C_Map.GetMapInfo(currZoneId)
    currMapID = currMap.mapID
    mapName = currMap.name
    parentMapID = C_Map.GetMapInfo(currMapID).parentMapID
    parentMapName = C_Map.GetMapInfo(parentMapID).name
  end
end

------------------------------------------------------------------------------
function setFilter:checkItem(itemId, dataArray)
  -- returns zoneId if itemId finds a match in the array otherwise null
  --itemId, zoneId, qty-1, label
  for id, info in pairs(dataArray) do
    if tonumber(itemId) == tonumber(info.itemId) then
      --if qty is a number and matched by item quantity then mark as labeled  
      if GetItemCount(itemId, true) == tonumber(info.qty) then return true, kPfx .. info.label .. kSfx, PRIORITY_ITEM end

      local isCurrent, zoneGroup = setFilter:isCurrentZone(info.zoneId)
      zoneGroup = L[zoneGroup] 
      if isCurrent and self.db.profile.zonePriority then 
        return true, kPfx2 .. zoneGroup .. kSfx, CURRENT_ZONE_ITEM
      elseif isCurrentZone then 
        return true, kPfx2 .. zoneGroup .. kSfx, kCategory
      else
        return true, kPfx .. zoneGroup .. kSfx, kCategory
      end 
    end -- end itemId match
  end
  return false, false, false
end

function setFilter:isCurrentZone(zoneId)
  for id, info in pairs(addon.arrZoneCodes) do 
    if tonumber(id) == tonumber(zoneId) then 
      for x = 1, #info.zGroupIds do
        if tonumber(info.zGroupIds[x]) == currZoneId then return true, info.zGroup end
      end -- end for x
      return false, info.zGroup 
    end
  end 
end

------------------------------------------------------------------------------
function setFilter:Filter(slotData)
  --Exit zoneItem addon if not enabled
  --name, count, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
  if not self.db.profile.enable then return end
  bagItemID = slotData.itemId
  currItemBagSlot =  {slotData.bag, slotData.slot}
  local isEquipmentSetItem, equipmentSetName = GetContainerItemEquipmentSetInfo(slotData.bag, slotData.slot)
  local isAzeriteGear = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(slotData.link)
  
  if currZoneId ~= C_Map.GetBestMapForUnit("player") or currZoneId == nil then  loadMapIDs() end
  --funky but GetItemInfo doesn't return corruption info so call specifically for itemLink
  local itemName,_, itemRarity, itemLevel,itemMinLevel, itemType, itemSubType,_,itemEquipLoc, _, _, itemClassID, itemSubClassID, bindType, expacID, itemSetId = GetItemInfo(slotData.link)
  if itemLevel == nil then itemLevel = 0 end
  -- Start checking groupings
  -- Heart of Azeroth Essences
  if self.db.profile.groupEssences and (itemClassID == 0 and itemSubClassID == 8 and itemRarity == 6 and expacID ==7) then
    local isZone, zoneGroupName =setFilter:isCurrentZone(10)
    if isZone and self.db.profile.zonePriority then 
      return kPfx2 .. zoneGroupName.. kSfx, CURRENT_ZONE_ITEM
    else
      return kPfx .. zoneGroupName.. kSfx, kCategory
    end
  end
    -- Heart Essences
  if self.db.profile.groupEssences then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrEssence) 
    if itemFound == true  then return groupLabel, retCategory end
  end
  -- Garrison and Order Hall  
  if self.db.profile.groupMission then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrMissions) 
    if itemFound == true  then return L[groupLabel], retCategory end
  end
  -- Patch 8.3 Vale/Uldum/Horiffic Visions
  if self.db.profile.groupPatch8_3 then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrPatch8_3) 
    if itemFound == true  then return groupLabel, retCategory end
  end
  -- Scourge Invasions
  if self.db.profile.groupScourge then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrScourge) 
    if itemFound == true  then return groupLabel, retCategory end
  end
  -- Pandaria Timeless Isle
  if self.db.profile.groupTimeless then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrTimeless) 
    if itemFound == true  then return groupLabel, retCategory end
  end
  -- Patch 8.2 Nazjatar
  if self.db.profile.groupNazjatar then
    -- check Nazjatar general items
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrNazjatar) 
    if itemFound == true  then  return groupLabel, retCategory end
  end
  -- Patch 8.2 Mechagon
  if self.db.profile.groupMechagon then
    local itemFound, groupLabel, retCategory = setFilter:checkItem(bagItemID, addon.arrMechagon) 
    if itemFound == true  then return groupLabel, retCategory end
  end
  if self.db.profile.groupRepItems then
    local itemFound, groupLabel = setFilter:checkItem(bagItemID, addon.arrReputation) 
    if itemFound == true  then return groupLabel, retCategory end
  end

  if self.db.profile.groupLowGear and isEquipmentSetItem == false and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel()
    -- exception for items in item sets
    if itemLevel >= kMinExpansionIlevel and (itemLevel <= (avgItemLevel-kLowGearThreshold)) and (itemRarity < Enum.ItemQuality.Legendary ) and (itemRarity >= Enum.ItemQuality.Uncommon ) then  -- less than legendary quality
      local lowIlevel = ' < ' .. string.format("%u", tostring(avgItemLevel-kLowGearThreshold))
      return kPfx .. ITEM_LEVEL_ABBR ..  lowIlevel .. kSfx, ITEM_LEVEL_ABBR ..  lowIlevel 
    end
  end
  -- BfA Azerite Gear
  if self.db.profile.groupAzerite and (isEquipmentSetItem == false) and (isAzeriteGear == true) then
    return 'Azerite '.. GetItemClassInfo(LE_ITEM_CLASS_ARMOR) , 'Azerite '.. GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
  end
   -- BoA Gear Tokens, non-obsolete, check last
  if self.db.profile.groupBoATokens == true then
    tooltip:SetOwner(UIParent,"ANCHOR_NONE")
    tooltip:ClearLines()
    if slotData.bag == BANK_CONTAINER then
      tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
    else
      tooltip:SetBagItem(slotData.bag, slotData.slot)
    end
    local bindType = tooltip.leftside[3]:GetText()

    tip4 = strsub(tooltip.leftside[4]:GetText(),1,15)
    tip5 = strsub(tooltip.leftside[5]:GetText(),1,15)
    compareText = strsub(ITEM_CREATE_LOOT_SPEC_ITEM,1,15)
    local checkForText = tooltip.leftside[5]:GetText() -- 5th tooltip row contains text specifying it's an armor token
    tooltip:Hide()
    tooltip:SetParent(nil)
    
    if bindType == ITEM_BNETACCOUNTBOUND and (tip4 == compareText or tip5 == compareText ) then 
      -- match tooltip for "Create gear" text, ITEM_CREATE_LOOT_SPEC_ITEM
        return  RESISTANCE0_NAME.. ' (i'.. itemLevel .. ') ' .. ITEM_BIND_TO_ACCOUNT
      --return currSubCategory
    end 
--[[ 
    if (bindType == ITEM_ACCOUNTBOUND or bindType == ITEM_BNETACCOUNTBOUND) and (strsub(checkForText,1,15) == strsub(ITEM_CREATE_LOOT_SPEC_ITEM,1,15)) then 
      -- match tooltip for "Create gear" text, ITEM_CREATE_LOOT_SPEC_ITEM
        return  RESISTANCE0_NAME ..' - ' .. ITEM_BIND_TO_ACCOUNT, RESISTANCE0_NAME ..' - ' .. ITEM_BIND_TO_ACCOUNT
    elseif  (bindType ==ITEM_ACCOUNTBOUND or bindType ==ITEM_BNETACCOUNTBOUND) then
      currSubCategory = RESISTANCE0_NAME.. ' (i'.. itemLevel .. ') ' .. ITEM_BIND_TO_ACCOUNT
      -- ITEM_ACCOUNTBOUND .. ' ('.. itemLevel .. ') ' .. itemLevel .. '/'..  kCurrBoAMin
      return currSubCategory, kCategory 
    end ]]
  end
end

