--[[

Copyright (C) 2016 Yossa <yossa.addons@googlemail.com>
All Rights Reserved unless otherwise explicitly stated.

]]--

ArtifactPathFinder = LibStub("AceAddon-3.0"):NewAddon("ArtifactPathFinder", "AceEvent-3.0")

function ArtifactPathFinder:OnInitialize()
	if not ArtifactPathFinderCDB then
		ArtifactPathFinderCDB = {}
	end
	if not ArtifactPathFinderCDB.selectedPathBySpec then
		ArtifactPathFinderCDB.selectedPathBySpec = {}
	end
end

function ArtifactPathFinder:OnEnable()
	self:RegisterEvent("ARTIFACT_UPDATE");
	self:RegisterEvent("ARTIFACT_MAX_RANKS_UPDATE");
	self:RefreshPerkRanks();
end

function ArtifactPathFinder:OnDisable()
	self:UnregisterAllEvents()
	local powers = C_ArtifactUI.GetPowers();
	for i, powerID in ipairs(powers) do
		local powerButton = ArtifactPerksMixin.powerIDToPowerButton[powerID]
		if powerButton and powerButton.ArtifactPathIndex then
			powerButton.ArtifactPathIndex:Hide();
		end
	end
end

local function ArtifactRefreshed()
	if not ArtifactFrame or not ArtifactFrame.PerksTab or ArtifactFrame.PerksTab.ArtifactPathOldRefresh then return end
	ArtifactFrame.PerksTab.ArtifactPathOldRefresh = ArtifactFrame.PerksTab.RefreshPowers
	ArtifactFrame.PerksTab.RefreshPowers = function(self, newItem)
		ArtifactFrame.PerksTab.ArtifactPathOldRefresh(self, newItem)
		ArtifactPathFinder:RefreshPerkRanks()
	end

end


function ArtifactPathFinder:ARTIFACT_UPDATE()
	ArtifactRefreshed()
end

function ArtifactPathFinder:ARTIFACT_MAX_RANKS_UPDATE()
	ArtifactRefreshed()
end

function ArtifactPathFinder:GetCurrentPaths()
    local _, className = UnitClass("player");
	local artifactItemId = C_ArtifactUI.GetArtifactInfo()
	local pathTable = self.Data

	local currentPath = nil
	local currentPathName = nil

	if pathTable[className] and pathTable[className][artifactItemId] then
		return pathTable[className][artifactItemId]
	end
	return nil
end

local function GetPowerInfoMaps()
	local powers = C_ArtifactUI.GetPowers();
	if not powers then return nil end
	local powerInfo, spellInfo = {}, {}
	-- get powers info
	for i, powerID in ipairs(powers) do
		local pInfo = C_ArtifactUI.GetPowerInfo(powerID);
		powerInfo[powerID] = {}
		powerInfo[powerID].spellID = pInfo.spellID
		powerInfo[powerID].powerID = powerID
		powerInfo[powerID].buttonIndex = i
		powerInfo[powerID].currentRank = pInfo.currentRank
		powerInfo[powerID].maxRank = pInfo.maxRank
		powerInfo[powerID].bonusRanks = pInfo.bonusRanks
		powerInfo[powerID].x = pInfo.position.x
		powerInfo[powerID].y = pInfo.position.y
		powerInfo[powerID].isFinished = pInfo.currentRank == pInfo.maxRank;
		spellInfo[pInfo.spellID] = powerInfo[powerID]
	end
	return powers, powerInfo, spellInfo
end

local brokenSpellId = {}

local function CreateIndexesForPowers(currentPath, spellInfo)
	local selectionPath = {}
	local isNextChecking = true
	local _, _, _, _, _, ranksPurchased, _, _, _, _, _, _ = C_ArtifactUI.GetArtifactInfo()

	--set powers indexes and next selection
	for i,spellID in ipairs(currentPath) do
		local spellIndex = i
		-- Skip traits after index 18 if 35th trait havent been unlocked yet, or the first 18 traits if 36th trait has been purchased.
		if (i <= 18 and ranksPurchased < 35) or (i >= 19 and ranksPurchased >= 35) then
			if (i >= 19 and ranksPurchased >= 35) then spellIndex = i - 18 end
			-- Start multi-spellID fix (Added by SethAluma)
			if (type(spellID) == "table") then
				-- spellID contains multiple spellIDs
				local isGroupNext = false;

				for j,subSpellID in ipairs(spellID) do
					if not spellInfo[subSpellID] then
						if not brokenSpellId[subSpellID] then
							--local _, className = UnitClass("player");
							--local artifactItemId = C_ArtifactUI.GetArtifactInfo()
							--DEFAULT_CHAT_FRAME:AddMessage("Artifact spell not found. Please report a bug in Path data: "..tostring(subSpellID).." "..className.."/"..tostring(artifactItemId))
							brokenSpellId[subSpellID] = 1
						end
					else
						local isNext = false
						if isNextChecking then
							if not spellInfo[subSpellID].isFinished then
								isNext = true
								isGroupNext = true
							end
						end
						local powerID = spellInfo[subSpellID].powerID
						selectionPath[powerID] = {}
						selectionPath[powerID].index = spellIndex
						selectionPath[powerID].isNext = isNext
					end
				end
				if isGroupNext then isNextChecking = false end
			else
				-- spellID is singular
				if not spellInfo[spellID] then
					if not brokenSpellId[spellID] then
						--local _, className = UnitClass("player");
						--local artifactItemId = C_ArtifactUI.GetArtifactInfo()
						--DEFAULT_CHAT_FRAME:AddMessage("Artifact spell not found. Please report a bug in Path data: "..tostring(spellID).." "..className.."/"..tostring(artifactItemId))
						brokenSpellId[spellID] = 1
					end
				else
					local isNext = false
					if isNextChecking then
						if not spellInfo[spellID].isFinished then
							isNext = true
							isNextChecking = false
						end
					end
					local powerID = spellInfo[spellID].powerID
					selectionPath[powerID] = {}
					selectionPath[powerID].index = spellIndex
					selectionPath[powerID].isNext = isNext
				end
			end
			-- End multi-spellID fix
		end
	end
	return selectionPath
end

local function CreateButtonOverlay(powerButton)
	local button = powerButton:CreateFontString(nil, "OVERLAY")
	button:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
	button:SetPoint("CENTER",powerButton.Icon,"CENTER",0,0)
	return button
end

function ArtifactPathFinder:RefreshSelectedPath()
	local currentPaths = ArtifactPathFinder:GetCurrentPaths()
	local pathCount = 0
	if not currentPaths then return 0 end
 	for _ in pairs(currentPaths) do pathCount = pathCount + 1 end
 	local artifactItemId = C_ArtifactUI.GetArtifactInfo()

	if pathCount == 0 then
		self.selectedName = nil
		self.selectedPath = nil
	elseif pathCount == 1 or not ArtifactPathFinderCDB.selectedPathBySpec[artifactItemId] then
		self.selectedName, self.selectedPath = next(currentPaths)
	else
		self.selectedName = ArtifactPathFinderCDB.selectedPathBySpec[artifactItemId]
		if currentPaths[self.selectedName] then
			self.selectedPath = currentPaths[self.selectedName]
		else
			self.selectedName, self.selectedPath = next(currentPaths)
		end
	end
	ArtifactPathFinderCDB.selectedPathBySpec[artifactItemId] = self.selectedName
	return pathCount
end

local function DropDown_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo()
	local num = 1
	local selectedNum = nil
	for k, v in pairs(ArtifactPathFinder:GetCurrentPaths()) do
		info = UIDropDownMenu_CreateInfo()
		info.text = k
		info.value = num
		info.func = function (self)
			UIDropDownMenu_SetSelectedID(ArtifactFrame.PerksTab.ArtifactPathFinderFilter, self:GetID())
			ArtifactPathFinder.selectedPath = v
			ArtifactPathFinder.selectedName = k
			ArtifactPathFinderCDB.selectedPathBySpec[C_ArtifactUI.GetArtifactInfo()] = k
			ArtifactPathFinder:RefreshPerkRanks()
		end
		info.checked = ArtifactPathFinder.selectedName == k
		if info.checked then selectedNum = num end
		num = num + 1
		UIDropDownMenu_AddButton(info, level)
	end
	if selectedNum then
		UIDropDownMenu_SetSelectedID(ArtifactFrame.PerksTab.ArtifactPathFinderFilter, selectedNum)
	end
end

function ArtifactPathFinder:RefreshFilter()
	local pathCount = ArtifactPathFinder:RefreshSelectedPath()
	if pathCount < 2 then
		if ArtifactFrame.PerksTab.ArtifactPathFinderFilter then
			ArtifactFrame.PerksTab.ArtifactPathFinderFilter:Hide()
		end
		return
	end

	if not ArtifactFrame.PerksTab.ArtifactPathFinderFilter then
		ArtifactFrame.PerksTab.ArtifactPathFinderFilter = CreateFrame("Frame", "ArtifactPathFinderFilter", ArtifactFrame.PerksTab, "UIDropDownMenuTemplate")
	else
		ArtifactFrame.PerksTab.ArtifactPathFinderFilter:Show()
	end
	local FilterDropDown = ArtifactFrame.PerksTab.ArtifactPathFinderFilter
	UIDropDownMenu_Initialize(FilterDropDown, DropDown_Initialize)
	UIDropDownMenu_SetWidth(FilterDropDown, 200);
	UIDropDownMenu_SetButtonWidth(FilterDropDown, 144)
	UIDropDownMenu_JustifyText(FilterDropDown, "LEFT")
	FilterDropDown:SetPoint("TOPRIGHT", ArtifactFrame.PerksTab, "TOPRIGHT", 0, -50)
end

function ArtifactPathFinder:HideAll()
	local powers = C_ArtifactUI.GetPowers();
	for i, powerID in ipairs(powers) do
		local powerButton = ArtifactFrame.PerksTab.powerIDToPowerButton[powerID]
		if powerButton and powerButton.ArtifactPathIndex then
			powerButton.ArtifactPathIndex:Hide()
			powerButton.StarBurst:SetAlpha(0)
		end
	end
	if ArtifactFrame.PerksTab.ArtifactPathFinderFilter then
		ArtifactFrame.PerksTab.ArtifactPathFinderFilter:Hide()
	end
end

local function clearButtons()
	for i, button in ipairs(ArtifactFrame.PerksTab.powerIDToPowerButton) do
    		if button.ArtifactPathIndex then
    			button.StarBurst:SetAlpha(0)
		    	button.ArtifactPathIndex:Hide()
		end
    	end
end

function ArtifactPathFinder:RefreshPerkRanks()
    if not ArtifactFrame or not ArtifactFrame.PerksTab or not ArtifactFrame.PerksTab.powerIDToPowerButton then return end
	clearButtons()
	local currentTier = C_ArtifactUI.GetArtifactTier();
	if currentTier>1 then
		--return
	end
	self:RefreshFilter()
	local currentPath = self.selectedPath
	if currentPath then
		local powers, powerInfo, spellInfo = GetPowerInfoMaps();
		if not powers then return end
		local selectionPath = CreateIndexesForPowers(currentPath, spellInfo)
		--fill all buttons
		for i, powerID in ipairs(powers) do
			local powerButton = ArtifactFrame.PerksTab.powerIDToPowerButton[powerID]
			if powerButton then
				if not powerButton.ArtifactPathIndex then
					powerButton.ArtifactPathIndex = CreateButtonOverlay(powerButton)
				else
					powerButton.ArtifactPathIndex:Show();
				end
				powerButton.StarBurst:SetAlpha(0)
				powerButton.ArtifactPathIndex:SetTextColor(1, 1, 1, 1)
				powerButton.ArtifactPathIndex:SetText("")

				if selectionPath[powerID] then
					if (C_ArtifactUI.GetTotalPurchasedRanks() == 0 and selectionPath[powerID].index>2) --or
					   --(selectionPath[powerID].index == 18 and not selectionPath[powerID].isNext)
					then
						powerButton.ArtifactPathIndex:Hide()
					else
						powerButton.ArtifactPathIndex:SetText(tostring(selectionPath[powerID].index));
						if selectionPath[powerID].isNext then
							powerButton.ArtifactPathIndex:SetTextColor(1, 0, 0, 1)
							powerButton.StarBurst:SetAlpha(0.9)
						end
					end
				end
			end
		end
	end
end
