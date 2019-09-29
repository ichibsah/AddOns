local OHFGO, L = unpack(OrderHallFollowerGearOptimizer)

local defaults = {
	profile = {
		["mustMeetTargetIlvl"] = true,
		["forceSetItem"] = true,
		["ignoreWorking"] = true,
		["ignoreInactive"] = true,
	},
};

--ORDERHALL_FOLLOWER_GEAR_OPTIMIZER_OPTIMIZED_ITEM_LEVEL = L["|cff00ff00Optimized Item Level:|r |cff00ffff%d|r"];
--ORDERHALL_FOLLOWER_GEAR_OPTIMIZER_OPTIMIZED_ITEM_ITEM_LEVEL = "|cff00ff00%d|r |cffffffff->|r |cff00ffff%d|r";

local createdFollowerFrames = 0;

function OHFGO:RecycleItemButtons(frame)
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("RecycleItemButtons", frame);
		return;
	end

	if (frame.itemButtons and #frame.itemButtons > 0) then
		if (not frame.itemButtonHolder) then
			frame.itemButtonHolder = {};
		end

		while (#frame.itemButtons > 0) do
			local button = tremove(frame.itemButtons);

			tinsert(frame.itemButtonHolder, button);

			button:Hide();
		end
	end
end

function OHFGO:CreateItemButton(frame)
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("CreateItemButton", frame);
		return;
	end

	local button;

	if (not frame.itemButtons) then
		frame.itemButtons = {};
	end

	if (frame.itemButtonHolder and #frame.itemButtonHolder > 0) then
		button = tremove(frame.itemButtonHolder);
		button:Show();
	else
		if (not frame.createdItemButtons) then
			frame.createdItemButtons = 0;
		end

		frame.createdItemButtons = frame.createdItemButtons + 1;

		button = CreateFrame("Button", frame:GetName()..frame.createdItemButtons, frame, "ItemButtonTemplate");
		button:SetFrameLevel(frame:GetFrameLevel() + 2);
		button:SetSize(32, 32);
		
		button:SetScript('OnEnter', function(self)
			if self.itemID then
				GameTooltip:SetOwner(self, "TOPLEFT", 0, 4);
				GameTooltip:SetItemByID(self.itemID);
				GameTooltip:Show()
			end
		end)
		button:SetScript('OnLeave', function(self)
			GameTooltip:Hide()
		end)
	end

	local myIndex = #frame.itemButtons + 1;

	button:ClearAllPoints();
	if (myIndex == 1) then
		button:SetPoint("LEFT", frame.ItemLevelDiff, "RIGHT", 16, 0);
	elseif (myIndex % 8 == 0) then
		button:SetPoint("TOPLEFT", frame.itemButtons[myIndex - 7], "BOTTOMLEFT", 0, -8);
	else
		button:SetPoint("LEFT", frame.itemButtons[myIndex-1], "RIGHT", 8, 0);
	end
	button:Show();

	frame.itemButtons[myIndex] = button;

	return button;
end

function OHFGO:RecycleCounterButtons(frame)
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("RecycleCounterButtons", frame);
		return;
	end
	if (frame.counterButtons and #frame.counterButtons > 0) then
		if (not frame.counterButtonHolder) then
			frame.counterButtonHolder = {};
		end

		while (#frame.counterButtons > 0) do
			local button = tremove(frame.counterButtons);

			tinsert(frame.counterButtonHolder, button);

			button:Hide();
		end
	end
end

function OHFGO:CreateCounterButtons(frame, followerID)
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("CreateCounterButtons", frame, followerID);
		return;
	end

	local button;

	if (not frame.counterButtons) then
		frame.counterButtons = {};
	end

	local counters = self:GetFollowerCounterInfo(followerID);

	for i = 1, #counters do
		if (frame.counterButtonHolder and #frame.counterButtonHolder > 0) then
			button = tremove(frame.counterButtonHolder);
		else
			if (not frame.createdCounterButtons) then
				frame.createdCounterButtons = 0;
			end

			frame.createdCounterButtons = frame.createdCounterButtons + 1;

			button = CreateFrame("Button", frame:GetName()..frame.createdCounterButtons, frame, "GarrisonAbilityCounterTemplate");
			button:SetFrameLevel(frame:GetFrameLevel() + 2);
			button:SetSize(16, 16);
		end

		button:ClearAllPoints();
		if (#counters == 1) then
			button:SetPoint("TOP", frame.name, "BOTTOM", 0, -4);
		else
			if (i == 1) then
				button:SetPoint("TOPRIGHT", frame.name, "BOTTOM", -8, -4);
			else
				button:SetPoint("TOPLEFT", frame.name, "BOTTOM", 8, -4);
			end
		end
		button.Icon:SetTexture(counters[i].icon);
		button:Show();

		frame.counterButtons[i] = button;
	end
end

function OHFGO:RecycleFollowerUpgradeFrames()
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("RecycleFollowerUpgradeFrames");
		return;
	end
	if (self.frame.followerFrames and #self.frame.followerFrames > 0) then
		if (not self.frame.recyledFollowerFrames) then
			self.frame.recyledFollowerFrames = {};
		end

		while (#self.frame.followerFrames > 0) do
			local frame = tremove(self.frame.followerFrames);

			tinsert(self.frame.recyledFollowerFrames, frame);

			frame:Hide();
		end
	end
end

function OHFGO:CreateFollowerUpgradeFrame(forUpgrade)
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("CreateFollowerUpgradeFrame", forUpgrade);
		return;
	end

	local frame;
	local parent = self.frame;

	if (self.frame.recyledFollowerFrames and #self.frame.recyledFollowerFrames > 0) then
		frame = tremove(self.frame.recyledFollowerFrames);
	else
		createdFollowerFrames = createdFollowerFrames + 1;
		frame = CreateFrame("Frame", "OHFGOFollowerFrame"..createdFollowerFrames, parent);
		frame:SetSize(544, 40);
		local portrait = CreateFrame("Frame", nil, frame, "GarrisonFollowerPortraitTemplate");
		portrait:SetPoint("LEFT", frame, "LEFT");

		frame.portrait = portrait;

		local name = frame:CreateFontString(nil, "ARTWORK");
		name:SetFontObject(GameFontNormalSmall);
		name:SetPoint("TOP", portrait, "BOTTOM", 0, -4);

		frame.name = name;

		local itemLevel = frame:CreateFontString(nil, "ARTWORK");
		itemLevel:SetFontObject(GameFontNormalSmall);
		itemLevel:SetText("|cff00ff00Optimized Item Level:|r |cff00ffff615|r");
		itemLevel:SetPoint("BOTTOMLEFT", portrait, "BOTTOMRIGHT", 4, 8);

		frame.itemLevel = itemLevel;

		local ItemLevel = frame:CreateFontString(nil, "ARTWORK");
		ItemLevel:SetFontObject(GameFontNormalSmall);
		ItemLevel:SetText(L["Item Level"]);
		ItemLevel:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 4, -8);

		frame.ItemLevel = ItemLevel;

		local ItemLevelDiff = frame:CreateFontString(nil, "ARTWORK");
		ItemLevelDiff:SetFontObject(GameFontHighlightSmall);
		ItemLevelDiff:SetText("|cff00ff00610|r |cffffffff->|r |cff00ffff615|r");
		ItemLevelDiff:SetPoint("LEFT", ItemLevel, "RIGHT", 4, 0);

		frame.ItemLevelDiff = ItemLevelDiff;
	end

	frame:ClearAllPoints();
	if (forUpgrade) then
		frame:SetPoint("LEFT", self.followerUpgradeButton, "RIGHT", 20, 0);
	else
		local myIndex = #parent.followerFrames + 1;

		parent.followerFrames[myIndex] = frame;
		if (myIndex == 1) then
			frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 56, -100);
		else
			frame:SetPoint("TOPLEFT", parent.followerFrames[myIndex - 1], "BOTTOMLEFT", 0, -80);
		end
	end

	return frame;
end

function OHFGO:CreateFrame()
	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("CreateFrame");
		return;
	end

	local frame = CreateFrame("Frame", "OrderHallFollowerGearOptimizerFrame", OrderHallMissionFrame.FollowerTab, "GarrisonUITemplate");
	frame:SetSize(600, 800);
	frame:SetFrameStrata("DIALOG");
	frame:SetPoint("CENTER", OrderHallMissionFrame, "CENTER");
	frame:SetScript("OnShow", function(self)
		self:SetFrameLevel(OrderHallMissionFrame:GetFrameLevel() + 4);
	end);

	frame.TitleText:SetText(L["Order Hall Follower Gear Optimizer"]);

	frame.offset = 0;
	frame:SetScript("OnMouseWheel", function(s, delta)
		 if (delta > 0) then
		 	frame.offset = max(frame.offset - 1, 0);
		 else
		 	local count = 0;
		 	if (self.upgrades) then
			 	for k, v in pairs(self.upgrades) do
			 		count = count + 1;
			 	end
			end
			frame.offset = min(frame.offset + 1, count - 1);
		end
		self:DisplayUpgrades();
	end);

	local button = CreateFrame("Button", "OHFGOApply", frame, "UIPanelButtonTemplate");
	button:SetSize(80, 22);
	button:SetText("Apply");
	button:SetPoint("BOTTOM", frame, "BOTTOM", 0, 40);
	button:SetEnabled(false);
	button:Show();
	button:SetScript("OnShow", function(self)
		frame.totalText:SetShown(frame.totalTextShouldShow)
	end);
	button:SetScript("OnHide", function(self)
		frame.totalText:Hide();
	end);
	button:SetScript("OnClick", function(self)
		OHFGO:ApplyUpgrades();
	end);

	frame.ApplyButton = button;

	local text = frame:CreateFontString(nil, "ARTWORK");
	text:SetFontObject(GameFontNormal);
	text:SetPoint("BOTTOM", frame.ApplyButton, "TOP", 0, 14);
	text:Hide();

	frame.totalText = text;

	for i = 1, #(self.upgradeDB.targetIlvls) do
		local ilvl = self.upgradeDB.targetIlvls[i];
		button = CreateFrame("Button", "OHFGOOptimize"..ilvl, frame ,"UIPanelButtonTemplate");
		button:SetText(ilvl);
		button:SetSize(40, 22);
		button:SetPoint("TOP", frame, "TOP", -(40 * (#self.upgradeDB.targetIlvls - 1)) + (80 * (i - 1)), -30);
		button:SetScript("OnClick", function(self)
			OHFGO:OptimizeFollowerUpgrades(ilvl);
			OHFGO:DisplayUpgrades();
		end);
	end

	frame:Hide();

	return frame;
end

function OHFGO:Reset()
	self:RecycleFollowerUpgradeFrames();
	self:ResetItemCounts();
	self.upgrades = nil; 
	self.followerUpgradeButton.followerID = nil; 
	self.followerUpgradeButton.itemID = nil; 
	self.followerUpgradeButton:Hide();
	self.followerUpgradeFrame:Hide();
	self.frame.ApplyButton:SetEnabled(false);
	self.frame.ApplyButton:Show();
end

function OHFGO:PLAYER_REGEN_ENABLED()
	if (not self.regenFuncs) then
		return;
	end

	for func, args in pairs(self.regenFuncs) do
		OHFGO[func](OHFGO, unpack(args));
	end

	self.regenFuncs = nil;
	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
end

function OHFGO:RegenWait(func, ...)
	if (not self.regenFuncs) then
		self.regenFuncs = {};
	end

	local args = {};
	for i = 1, select('#', ...) do
		local arg = select(i, ...);
		if (arg) then
			tinsert(args, arg);
		end
	end
	self.regenFuncs[func] = args;
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function OHFGO:GetOptions()
	local options = {
		type = "group",
		name = "OrderHallFollowerGearOptimizer",
		order = 103,
		get = function(info) return OHFGO.db[info[#info]] end,
		set = function(info, value) OHFGO.db[info[#info]] = value; end,
		args = {
			mustMeetTargetIlvl = {
				type = "toggle",
				order = 1,
				name = L["Upgrade follower only if they meet target item level"],
				width = "full",
			},
			forceSetItem = {
				type = "toggle",
				order = 2,
				name = L["Set items ignore applied enhancements"],
				width = "full",
			},
			ignoreWorking = {
				type = "toggle",
				order = 3,
				name = L["Ignore Combat Ally Followers"],
				width = "full",
			},
			ignoreInactive = {
				type = "toggle",
				order = 4,
				name = L["Ignore Inactive Followers"],
				width = "full",
			},
		},
	};

	local spacers = 10;
	for i = 1, spacers do
		options.args["spacer"..i] = {
			name = '',
			type = 'description',
			desc = "\n",
			order = 2 + i,
			width = "full",
		};
	end

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("OrderHallFollowerGearOptimizer", options);

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.data);
	options.args.profiles.guiInline = true;
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("OHFGOProfiles", options.args.profiles);

	if (not self.registeredOptions) then
		local dialog = LibStub("AceConfigDialog-3.0");
		dialog:AddToBlizOptions("OrderHallFollowerGearOptimizer");
		self.registeredOptions = true;
	end
end

function OHFGO:UpdateProfile()
	self.data = LibStub("AceDB-3.0"):New("OHFGODB", defaults, true);
	self.data.RegisterCallback(self, "OnProfileChanged", "UpdateProfile");
	self.data.RegisterCallback(self, "OnProfileCopied", "UpdateProfile");
	self.db = self.data.profile;
end

function OHFGO:OpenFrame()
	self:ResetItemCounts();

	local followers = self:GetTargetFollowers(self.cap);
	--local items = self:GetUpgradeItemCountTotals("all");
	local items = self:GetUpgradeItemCountTotals("Upgrades"); -- 7.3

	-- 7.3
	local setFollowers = self:GetTargetFollowers(self.SetCap)
	local setItems = self:GetUpgradeItemCountTotals("Sets")

	-- 7.2
	local oldFollowers = self:GetTargetFollowers(self.oldCap);
	local oldItems = self:GetUpgradeItemCountTotals("Old");

	local open, reason = true, nil;

	--Debug
	--print(format("7.3: %d, %d - 7.2: %d, %d - 7.0: %d, %d", #setFollowers, setItems, #oldFollowers, oldItems, followers, items))

	--if (#oldFollowers == 0 and #followers == 0) then -- 7.2
	if (#setFollowers == 0 and #oldFollowers == 0 and #followers == 0) then -- 7.3
		open = false;
		reason = L["You have no followers eligible to be upgraded."];
	--elseif (oldItems == 0 and items == 0) then
	elseif (setItems == 0 and oldItems == 0 and items == 0) then -- 7.3
		open = false;
		reason = L["You have no follower upgrade items in your bags."];
	elseif (#oldFollowers == 0 and oldItems > 0 and items == 0) then
		open = false;
		reason = L["You have no suitable follower upgrade items in your bags."];
	elseif (#followers == 0 and items > 0 and setItems == 0) then -- 7.3
		open = false;
		reason = L["You have no suitable follower upgrade items in your bags."];
	end

	--[[if (#followers == 0) then
		open = false;
		reason = L["You have no followers eligible to be upgraded."];
	elseif (items == 0) then
		open = false;
		reason = L["You have no follower upgrade items in your bags."];
	end]]

	if (open) then
		self.frame:Show();
	else
		UIErrorsFrame:AddMessage(reason, 1.0, 0.0, 0.0);
	end
end

function OHFGO:Wait(button)
	button:SetEnabled(false); 
	C_Timer.After(2, function() button:SetEnabled(true); end);
end

function OHFGO:Init()
	if _G["OrderHallFollowerGearOptimizerButton"] then -- 7.3, some reason this ran multiple times, stop it
		return
	end

	local tab = OrderHallMissionFrame.FollowerTab;

	if (InCombatLockdown() or UnitAffectingCombat("player")) then
		self:RegenWait("Init");
		return;
	end

	self.frame = self:CreateFrame();
	self.frame.followerFrames = {};

	--self.cap = self.upgradeDB.targetIlvls[#self.upgradeDB.targetIlvls];
	self.cap = 900; -- 7.3
	self.SetCap = 950; -- 7.3
	self.oldCap = 850; -- 7.2

	local button = CreateFrame('Button', 'OrderHallFollowerGearOptimizerButton', tab, 'UIPanelButtonTemplate');
	button:SetSize(140, 22);
	button:SetText(L["Optimize"]);
	button:SetPoint("TOP", OrderHallMissionFrameFollowersListScrollFrame, "BOTTOM", 0, -40);
	button:SetScript("OnClick", function(self, button) OHFGO:OpenFrame() end);
	
	self.waiting = false;

	--local b = CreateFrame("Button", "OHFGOApplyButton", self.frame, "ItemButtonTemplate, SecureActionButtonTemplate")
	local b = CreateFrame("ItemButton", "OHFGOApplyButton", self.frame, "SecureActionButtonTemplate") -- ItemButtonTemplate was replaced by ItemButton-widget in 8.1.5
	b:SetAttribute("type", "macro")
	b:SetSize(40, 40);
	b:SetPoint("BOTTOM", 0, 60);
	b:HookScript("OnClick", function(self)
		OHFGO:Wait(self); 
		C_Garrison.CastSpellOnFollower(self.followerID);
		OHFGO:RemoveUpgrade(self.followerID, self.itemID);
		OHFGO:ApplyUpgrades();
	end);
	b:Hide();
	self.followerUpgradeButton = b;

	local f = self:CreateFollowerUpgradeFrame(true);
	f.itemLevel:Hide();
	f.ItemLevel:Hide();
	f.ItemLevelDiff:Hide();
	f:Hide();
	self.followerUpgradeFrame = f;

	tab:HookScript('OnHide', function() self.frame:Hide() end);

	self.frame:SetScript('OnShow', function()
		self:Reset()
	end);
	
	self.frame:SetScript('OnHide', function()
		self:Reset();
	end);

	self:UpdateProfile();

	self:GetOptions();
end

OHFGO:RegisterEvent('ADDON_LOADED', 'Init');
