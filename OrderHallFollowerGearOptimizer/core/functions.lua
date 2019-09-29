local OHFGO, L = unpack(OrderHallFollowerGearOptimizer);


OHFGO.upgradeDB = {
	["Sets"] = { -- 7.3
		[880] = 153005, -- Relinquished Armor Set
		[900] = 151842, -- Krokul Armor Set
		[925] = 151843, -- Mac'Aree Armor Set
		[950] = 151844, -- Xenedar Armor Set
		--[950] = 147558, -- Debug
	},
	["Upgrades"] = { -- 7.2
		[5] = 147348, -- Bulky Armor Set
		[10] = 147349, -- Spiked Armor Set
		[15] = 147350, -- Invincible Armor Set
		--[15] = 147558, -- Debug
	},
	["oldUpgrades"] = { -- 7.2
		[5] = 136412, -- Heavy Armor Set
		[10] = 137207, -- Fortified Armor Set
		[15] = 137208, -- Indestructible Armor Set
	},
	--["targetIlvls"] = { 775, 790, 805, 820, 835, 850 },
	--["targetIlvls"] = { 775, 800, 825, 850, 875, 900 }, -- 7.2
	["targetIlvls"] = { 800, 820, 850, 880, 900, 925, 950 }, -- 7.3

}

function OHFGO:DoesFollowerHaveSetItem(followerID)
	local weaponItemID, weaponItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerID);

	if (self.db.forceSetItem) then
		return false;
	end
	if (weaponItemLevel ~= 750) then
		return true;
	end
	for k, v in pairs(self.upgradeDB.Sets) do
		if (weaponItemID == v and weaponItemLevel >= k) then
			return true;
		end
	end

	return false;
end

function OHFGO:CollectCounterMechanicCounts()
	local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0);

	if (not self.counters) then self.counters = {}; end

	for i = 1, #followers do
		local follower = followers[i];
		local followerID = follower.followerID;

		if (follower.level >= 110 and follower.isCollected and not follower.isTroop) then
			local status = C_Garrison.GetFollowerStatus(followerID);

			--if (not status or (not (status == GARRISON_FOLLOWER_INACTIVE or status == GARRISON_FOLLOWER_ON_MISSION))) then
			if (not status or (not ((self.db.ignoreInactive and status == GARRISON_FOLLOWER_INACTIVE) or (self.db.ignoreWorking and status == GARRISON_FOLLOWER_COMBAT_ALLY) or status == GARRISON_FOLLOWER_ON_MISSION))) then
				for j = 1, 4 do
					local abilityID = C_Garrison.GetFollowerAbilityAtIndex(followerID, j);
					if (abilityID and abilityID > 0) then
						local mechanicID, mechanicName = C_Garrison.GetFollowerAbilityCounterMechanicInfo(abilityID);
						if mechanicID then
							if (not self.counters[mechanicID]) then
								self.counters[mechanicID] = { ["name"] = mechanicName, ["count"] = 0, };
							end
							self.counters[mechanicID].count = self.counters[mechanicID].count + 1;
						end
					end
				end
			end
		end
	end
end

function OHFGO:GetFollowerCounterInfo(followerID)
	local counters = {};

	for i = 1, 4 do
		local abilityID = C_Garrison.GetFollowerAbilityAtIndex(followerID, i);
		if (abilityID and abilityID > 0) then
			local mechanicID, mechanicName, mechanicIcon = C_Garrison.GetFollowerAbilityCounterMechanicInfo(abilityID);
			if mechanicID then
				tinsert(counters, {["id"] = mechanicID, ["icon"] = mechanicIcon });
			end
		end
	end

	return counters;
end

function OHFGO:GetTargetFollowers(targetIlvl)
	local targetFollowers = {};
	local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0);

	for i = 1, #followers do
		local follower = followers[i];
		if (follower.level >= 110 and follower.iLevel < targetIlvl and follower.isCollected and not follower.isTroop) then
			local status = C_Garrison.GetFollowerStatus(follower.followerID);
			--if (not status or (not ((self.db.ignoreInactive and status == GARRISON_FOLLOWER_INACTIVE) or (self.db.ignoreWorking and status == GARRISON_FOLLOWER_WORKING) or status == GARRISON_FOLLOWER_ON_MISSION))) then
			if (not status or (not ((self.db.ignoreInactive and status == GARRISON_FOLLOWER_INACTIVE) or (self.db.ignoreWorking and status == GARRISON_FOLLOWER_COMBAT_ALLY) or status == GARRISON_FOLLOWER_ON_MISSION))) then
				tinsert(targetFollowers, follower.followerID);
			end
		end
	end

	return targetFollowers;
end

function OHFGO:CalculateWeights()
	local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0);

	if (not self.counters) then
		self:CollectCounterMechanicCounts();
	end

	if (not self.weights) then self.weights = {}; end

	wipe(self.weights);
	for id, _ in pairs(self.counters) do
		self.weights[id] = self.counters[id].count / #followers;
	end
end

function OHFGO:GetFollowerWeight(followerID)
	if (not self.counters) then
		self:CollectCounterMechanicCounts();
	end

	if (not self.weights) then
		self:CalculateWeights();
	end

	local counters = self:GetFollowerCounterInfo(followerID);
	local mod = 1;

	if (#counters > 0) then
		mod = mod - (.25 * (#counters - 1));
	end

	local weight_mod = 0;

	for i = 1, #counters do
		if self.weights[counters[i].id] then
			weight_mod = weight_mod + (self.weights[counters[i].id] * mod);
		end
	end

	return weight_mod;
end

function OHFGO:GenerateWeightedList(followers)
	local weightedList = {};
	for i = 1, #followers do
		local weight = self:GetFollowerWeight(followers[i]);

		for j = 1, floor(weight*100) do
			tinsert(weightedList, i);
		end
	end

	return weightedList;
end

function OHFGO:NormalizeDifference(diff)
	return diff <= 5 and 5 or diff <= 10 and 10 or 15;
end

function OHFGO:GetUpgradeItemCount(itemID)
	if (not self.upgradeCounts) then self.upgradeCounts = {}; end
	if (not self.upgradeCounts[itemID]) then
		self.upgradeCounts[itemID] = GetItemCount(itemID);
	end

	return self.upgradeCounts[itemID];
end

function OHFGO:ResetItemCounts()
	if (not self.upgradeCounts) then self.upgradeCounts = {}; end
	--for _, v in pairs({"Upgrades"}) do
	for _, v in pairs({"Sets","Upgrades","oldUpgrades"}) do -- 7.3
		for _, itemID in pairs(self.upgradeDB[v]) do
			self.upgradeCounts[itemID] = GetItemCount(itemID);
		end
	end
end

function OHFGO:StartUpgrade()
	assert(not self.backupUpgradeCount);
	self.backupUpgradeCount = CopyTable(self.upgradeCounts);
end

function OHFGO:FinalizeUpgrade(keep)
	assert(self.backupUpgradeCount);
	if (not keep) then
		self.upgradeCounts = CopyTable(self.backupUpgradeCount);
	end
	self.backupUpgradeCount = nil;
end

function OHFGO:AssignUpgrade(upgradeInfo, itemID)
	if (not self.upgradeCounts or not self.upgradeCounts[itemID]) then
		self:GetUpgradeItemCount(itemID);
	end

	tinsert(upgradeInfo, itemID);
	self.upgradeCounts[itemID] = self.upgradeCounts[itemID] - 1;
end

--[[function OHFGO:GetUpgradeItemCountTotals()
	local count = 0;
	local table = self.upgradeDB.Upgrades;

	if (table) then
		for _, itemID in pairs(table) do
			count = count + self:GetUpgradeItemCount(itemID);
		end
	end
	return count;
end]]
function OHFGO:GetUpgradeItemCountTotals(type) -- 7.3
	local count = 0;
	local table;
	if (type == "Sets") then
		table = self.upgradeDB.Sets;
	elseif (type == "Upgrades") then
		table = self.upgradeDB.Upgrades;
	elseif type == "Old" then
		table = self.upgradeDB.oldUpgrades;
	end
	if (table) then
		for _, itemID in pairs(table) do
			count = count + self:GetUpgradeItemCount(itemID);
		end
	elseif (type == "all") then
		for _, table in pairs({"Sets","Upgrades","oldUpgrades"}) do
			count = count + self:GetUpgradeItemCountTotals(table);
		end
	end
	return count;
end

--[[function OHFGO:GetOldUpgradeItemCountTotals() -- 7.2
	local count = 0;
	local table = 

	if (table) then
		for _, itemID in pairs(table) do
			count = count + self:GetUpgradeItemCount(itemID);
		end
	end
	return count;
end]]

function OHFGO:CalculateUpgradeForFollower(followerID, targetIlvl)
	local upgradeInfo = {};
	local ItemID, ItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerID);

	local follower = C_Garrison.GetFollowerInfo(followerID);
	local set_item_levels = {880, 900, 925, 950};
	local upgraded = false;

	if follower.isTroop then return upgradeInfo, upgraded; end

	self:StartUpgrade();

	if (ItemLevel < targetIlvl and targetIlvl <= self.oldCap and (self:GetUpgradeItemCountTotals("Old") > 0)) then -- 7.2
		local br = false;

		while (ItemLevel < targetIlvl and not br and self:GetUpgradeItemCountTotals("Old") > 0) do
			local inserted = false;
			local diff = self:NormalizeDifference(targetIlvl - ItemLevel);
			while (diff > 0 and not inserted) do
				if (self:GetUpgradeItemCount(self.upgradeDB.oldUpgrades[diff]) > 0 and ItemLevel + diff <= self.oldCap) then
					self:AssignUpgrade(upgradeInfo, self.upgradeDB.oldUpgrades[diff]);
					ItemLevel = ItemLevel + diff;
					inserted = true;
				else
					diff = diff - 5;
				end
			end

			if (not inserted) then
				diff = self:NormalizeDifference(targetIlvl - ItemLevel);
				while (diff <= 15 and not inserted) do
					if (self:GetUpgradeItemCount(self.upgradeDB.oldUpgrades[diff]) > 0 and ItemLevel + diff <= self.oldCap) then
						self:AssignUpgrade(upgradeInfo, self.upgradeDB.oldUpgrades[diff]);
						ItemLevel = ItemLevel + diff;
						inserted = true;
					else
						diff = diff + 5;
					end
				end
			end
			br = not inserted;
		end

		if (#upgradeInfo > 0) then
			upgradeInfo.newItemLevel = ItemLevel;
			upgraded = true;
		end
	end

	--if (ItemLevel < targetIlvl and (self:GetUpgradeItemCountTotals() > 0)) then
	if (ItemLevel < targetIlvl and (self:GetUpgradeItemCountTotals("Sets") > 0 or self:GetUpgradeItemCountTotals("Upgrades") > 0)) then -- 7.3
		if (not self:DoesFollowerHaveSetItem(followerID) and self:GetUpgradeItemCountTotals("Sets") > 0) then
			if (tContains(set_item_levels, targetIlvl) and self:GetUpgradeItemCount(self.upgradeDB.Sets[targetIlvl]) > 0) then
				self:AssignUpgrade(upgradeInfo, self.upgradeDB.Sets[targetIlvl]);
				ItemLevel = ItemLevel + (targetIlvl - ItemLevel);
			else
				for _, ilvl in pairs(set_item_levels) do
					if (ilvl ~= targetIlvl and ItemLevel < ilvl and self:GetUpgradeItemCount(self.upgradeDB.Sets[ilvl]) > 0) then
						self:AssignUpgrade(upgradeInfo, self.upgradeDB.Sets[ilvl]);
						ItemLevel = ItemLevel + (ilvl - ItemLevel);
						break;
					end
				end
			end
		end

		local br = false;

		while (ItemLevel < targetIlvl and not br and self:GetUpgradeItemCountTotals("Upgrades") > 0) do
			local inserted = false;
			local diff = self:NormalizeDifference(targetIlvl - ItemLevel);
			while (diff > 0 and not inserted) do
				if (self:GetUpgradeItemCount(self.upgradeDB.Upgrades[diff]) > 0 and ItemLevel + diff <= self.cap) then
					self:AssignUpgrade(upgradeInfo, self.upgradeDB.Upgrades[diff]);
					ItemLevel = ItemLevel + diff;
					inserted = true;
				else
					diff = diff - 5;
				end
			end

			if (not inserted) then
				diff = self:NormalizeDifference(targetIlvl - ItemLevel);
				while (diff <= 15 and not inserted) do
					if (self:GetUpgradeItemCount(self.upgradeDB.Upgrades[diff]) > 0 and ItemLevel + diff <= self.cap) then
						self:AssignUpgrade(upgradeInfo, self.upgradeDB.Upgrades[diff]);
						ItemLevel = ItemLevel + diff;
						inserted = true;
					else
						diff = diff + 5;
					end
				end
			end
			br = not inserted;
		end

		if (#upgradeInfo > 0) then
			upgradeInfo.newItemLevel = ItemLevel;
			upgraded = true;
		end
	end

	if (upgraded) then
		local meetsItemLevel = ItemLevel >= targetIlvl;
		-- We are force upgraded if we are first upgrade and we have no tokens left
		if (not meetsItemLevel and self.db.mustMeetTargetIlvl) then
			upgraded = false;
		end
	end

	self:FinalizeUpgrade(upgraded);

	return upgradeInfo, upgraded;
end

function OHFGO:OptimizeFollowerUpgrades(targetIlvl)
	local upgrades = {};
	self:CollectCounterMechanicCounts();
	self:CalculateWeights();
	self:ResetItemCounts();

	local followers = self:GetTargetFollowers(targetIlvl);

	local upgraded = true;

	local upgradeInfo;

	while (#followers > 0) do
		local index;
		if (#followers == 1) then
			index = 1;
		elseif (#followers == 2) then
			local follower1 = C_Garrison.GetFollowerInfo(followers[1]);
			local follower2 = C_Garrison.GetFollowerInfo(followers[2]);

			local weightDiff = follower1.iLevel - follower2.iLevel;

			index = (random(1,100) <= (50 - weightDiff)) and 1 or 2;
		else
			local weighedList = self:GenerateWeightedList(followers);
			index = random (1, #weighedList);
		end

		assert(index);
		if (not followers[index]) then
			tremove(followers,index);
		else
			upgradeInfo, upgraded = self:CalculateUpgradeForFollower(followers[index], targetIlvl);
			if (upgraded) then
				upgrades[followers[index]] = upgradeInfo;
			end
			tremove(followers, index);
		end
	end

	self.upgrades = upgrades;
end

function OHFGO:DisplayUpgrades()
	self = OHFGO;

	if (not self.upgrades) then
		return;
	end

	self:RecycleFollowerUpgradeFrames();

	local count = 0;

	local i = 1;
	local offset = self.frame.offset;

	for followerID, upgradeInfo in pairs(self.upgrades) do
		if (count >= offset and i <= 5) then
			local frame = self:CreateFollowerUpgradeFrame();

			local follower = C_Garrison.GetFollowerInfo(followerID);
			if not follower.isTroop then

				--GarrisonMissionFrame_SetFollowerPortrait(frame.portrait, follower, false);
				-- GarrisonMissionFrame_SetFollowerPortrait() throws an error if Blizzard_GarrisonMissionUI isn't loaded
				frame.portrait:SetupPortrait(follower)
				frame.portrait.Level:SetFormattedText(GARRISON_FOLLOWER_ITEM_LEVEL, follower.iLevel);

				frame.name:SetText(follower.name);

				local ItemID, ItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerID);
				local finalItemLevel = upgradeInfo.newItemLevel or ItemLevel;

				if (finalItemLevel ~= ItemLevel) then
					--frame.ItemLevelDiff:SetText(ORDERHALL_FOLLOWER_GEAR_OPTIMIZER_OPTIMIZED_ITEM_ITEM_LEVEL:format(ItemLevel, finalItemLevel));
					frame.ItemLevelDiff:SetFormattedText("|cff00ff00%d|r |cffffffff->|r |cff00ffff%d|r", ItemLevel, finalItemLevel); -- why this was Global?
					frame.ItemLevel:Show();
					frame.ItemLevelDiff:Show();
				else
					frame.ItemLevel:Hide();
					frame.ItemLevelDiff:Hide();
				end

				--frame.itemLevel:SetText(ORDERHALL_FOLLOWER_GEAR_OPTIMIZER_OPTIMIZED_ITEM_LEVEL:format(finalItemLevel));
				frame.itemLevel:SetFormattedText(L["|cff00ff00Optimized Item Level:|r |cff00ffff%d|r"], finalItemLevel); -- why this was Global?

				self:RecycleItemButtons(frame);

				for i = 1, #upgradeInfo do
					local ItemID = upgradeInfo[i];

					local itemButton = self:CreateItemButton(frame);

					itemButton.icon:SetTexture(select(10, GetItemInfo(ItemID)));
					itemButton.itemID = ItemID;
				end

				self:RecycleCounterButtons(frame);
				self:CreateCounterButtons(frame, followerID);

				frame:Show();
			end

			i = i + 1;
		end
		count = count + 1;
	end

	if (count > 5 and not self.frame.ApplyButton:IsShown()) then
		self.frame.totalTextShouldShow = true;
		self.frame.totalText:SetText(format(L["Total Count: %d"], count));
		self.frame.totalText:Show();
	else
		self.frame.totalTextShouldShow = false;
		self.frame.totalText:Hide();
	end

	self.frame.ApplyButton:SetEnabled(count > 0);
end

function OHFGO:ApplyUpgrades()
	assert(self.upgrades);

	local button = self.followerUpgradeButton;
	local frame = self.followerUpgradeFrame;

	local seen = false;
	for followerID, upgrades in pairs(self.upgrades) do
		if (#upgrades > 0) then
			local itemID = upgrades[1];

			button.itemID = itemID;
			button.followerID = followerID;
			button:SetAttribute("macrotext", "/use item:"..itemID);
			button.icon:SetTexture(select(10, GetItemInfo(itemID)));
			button:Show();

			local follower = C_Garrison.GetFollowerInfo(followerID);
			--GarrisonMissionFrame_SetFollowerPortrait(frame.portrait, follower, false);
			-- GarrisonMissionFrame_SetFollowerPortrait() throws an error if Blizzard_GarrisonMissionUI isn't loaded
			frame.portrait:SetupPortrait(follower)
			frame.portrait.Level:SetFormattedText(GARRISON_FOLLOWER_ITEM_LEVEL, follower.iLevel);
			frame.name:SetText(follower.name);
			frame:Show();

			seen = true;
			break;
		end
	end

	self.frame.ApplyButton:SetShown(not seen);
	for i = 1, #(self.upgradeDB.targetIlvls) do
		_G["OHFGOOptimize"..self.upgradeDB.targetIlvls[i]]:SetEnabled(not seen);
	end

	self:DisplayUpgrades();
	self.frame.totalText:Hide();

	if (not seen) then
		self.upgrades = nil;
		button:Hide();
		frame:Hide();
		self.frame.ApplyButton:SetEnabled(false);
		self.frame:Hide();
	end
end

function OHFGO:RemoveUpgrade(followerID, itemID)
	assert(self.upgrades)

	for follower, upgrades in pairs(self.upgrades) do
		if (follower == followerID) then
			local index;
			for i = 1, #upgrades do
				if (upgrades[i] == itemID) then
					index = i;
					break;
				end
			end

			if (index) then
				tremove(upgrades, index);
				break;
			end
		end
	end
end
