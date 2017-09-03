local MAJOR, MINOR = "LibGuildBankScan", 2
assert(LibStub, MAJOR.." requires LibStub")
local lib, minor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return nil end
local strformat, match, pairs,  type = string.format, string.match, pairs, type
local MAX_GUILDBANK_SLOTS_PER_TAB = MAX_GUILDBANK_SLOTS_PER_TAB or 98
local slotItems = {}

local function scanGuild()
	wipe(slotItems)
	local numTabs = GetNumGuildBankTabs()
	local index = 0
	for tab = 1, numTabs do
		local _, _, isViewable, _, _, _ = GetGuildBankTabInfo(tab)
		if isViewable then
			for slot = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
				local link = GetGuildBankItemLink(tab, slot)
				if link and lib:linkMatch(link) then
					index = index + 1
					local _, count = GetGuildBankItemInfo(tab, slot)
					count = (count > 1 and count) or nil
					if count then
						slotItems[index] = strformat('%s,%d', lib:linkMatch(link), count)
					else
						slotItems[index] = lib:linkMatch(link)
					end
				end
			end
		end
	end
end

lib.eventFrame = lib.eventFrame or CreateFrame("Frame")
lib.eventFrame:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
lib.eventFrame:SetScript("OnEvent", scanGuild)

function lib:linkMatch(link)
	if not link then return nil end
	return link:match('|Hitem:(%d+):[%d:]+|h%[(.-)%]|h')
end

function lib:scanResult(itemid)
	assert(type(itemid) == "number", "Itemid must be a number.")
	local total = 0
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice, itemClassID, itemSubClassID  = GetItemInfo(itemid)
	local id = lib:linkMatch(link)
	for _, item in pairs(slotItems) do
		local slotlink, slotcount = strsplit(',', item)
		if slotlink and slotlink == id then
			total = total + (slotcount or 1)
		end
	end
	return total
end
