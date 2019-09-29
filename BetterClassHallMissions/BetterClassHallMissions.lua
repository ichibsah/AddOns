-- luacheck: globals OrderHallMissionFrame GarrisonMissionListTooltipThreatsFrame GameFontHighlightLarge SystemFont_Shadow_Med1_Outline
-- luacheck: globals GarrisonMissionButton_GetMissionFrame GarrisonMissionButton_SetInProgressTooltip HybridScrollFrame_OnMouseWheel GameTooltip_InsertFrame

local L_RARE_REMAINING = "|TInterface\\AddOns\\BetterClassHallMissions\\Textures\\Mobile-Clock:0|t %s"

local mechanicIcons = {
	[1380306] = [[Interface\AddOns\BetterClassHallMissions\Textures\MechanicIcon-Curse-Shadow]],
	[1383683] = [[Interface\AddOns\BetterClassHallMissions\Textures\MechanicIcon-Disorienting-Shadow]],
	[1383682] = [[Interface\AddOns\BetterClassHallMissions\Textures\MechanicIcon-Lethal-Shadow]],
	[1390116] = [[Interface\AddOns\BetterClassHallMissions\Textures\MechanicIcon-Powerful-Shadow]],
	[1383681] = [[Interface\AddOns\BetterClassHallMissions\Textures\MechanicIcon-Slowing-Shadow]],
}

local function FormatTime(time)
	if time >= 86400 then
		time = (time - 1) / 86400 + 1
		return COOLDOWN_DURATION_DAYS:format(time)
	elseif time >= 3600 then
		time = (time - 1) / 3600 + 1
		return COOLDOWN_DURATION_HOURS:format(time)
	else
		time = (time - 1) / 60 + 1
		return COOLDOWN_DURATION_MIN:format(time)
	end
end

local function CreateThreatFrame(parent)
	local threat = CreateFrame("Frame", nil, parent, "GarrisonAbilityCounterWithCheckTemplate")
	threat.Border:Hide()
	threat.Away:Hide()
	threat.Check:SetAtlas("GarrMission_CounterCheck", true)
	threat.TimeLeft:SetFontObject(SystemFont_Shadow_Med1_Outline) -- SystemFont_Outline_Small
	threat.TimeLeft:ClearAllPoints()
	threat.TimeLeft:SetPoint("CENTER", threat.Away, "CENTER", 0, 0)
	return threat
end

local abilityCountersForMechanicTypes = C_Garrison.GetFollowerAbilityCountersForMechanicTypes(LE_FOLLOWER_TYPE_GARRISON_7_0)
local followerList = nil
local threats = {
	full = {},
	away = {},
	worker = {},
}
local function DetermineCounterableThreats(missionID)
	wipe(threats.full)
	wipe(threats.away)
	wipe(threats.worker)

	if not followerList then
		followerList = {}
		local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0) or {}
		for _, follower in next, followers do
			if follower.isCollected and follower.status ~= GARRISON_FOLLOWER_INACTIVE then
				followerList[follower.followerID] = C_Garrison.GetFollowerAbilities(follower.followerID)
			end
		end
	end

	for followerID, abilities in next, followerList do
		local follower = C_Garrison.GetFollowerInfo(followerID)
		local bias = C_Garrison.GetFollowerBiasForMission(missionID, followerID)
		if bias > -1.0 then
			for _, ability in ipairs(abilities) do
				for counterMechanicID in next, ability.counters do
					if follower.status then
						if follower.status == GARRISON_FOLLOWER_ON_MISSION then
							local remaining = C_Garrison.GetFollowerMissionTimeLeftSeconds(follower.followerID)
							if remaining then
								if not threats.away[counterMechanicID] then
									threats.away[counterMechanicID] = {}
								end
								tinsert(threats.away[counterMechanicID], remaining)
							end
						elseif follower.status == GARRISON_FOLLOWER_WORKING then
							threats.worker[counterMechanicID] = (threats.worker[counterMechanicID] or 0) + 1
						end
					else
						threats.full[counterMechanicID] = (threats.full[counterMechanicID] or 0) + 1
					end
				end
			end
		end
	end

	local bonusEffects = C_Garrison.GetMissionBonusAbilityEffects(missionID)
	for i = 1, #bonusEffects do
		local mechanicTypeID = bonusEffects[i].mechanicTypeID
		if mechanicTypeID ~= 0 then
			threats.full[mechanicTypeID] = (threats.full[mechanicTypeID] or 0) + 1
		end
	end

	for counter, times in next, threats.away do
		sort(times)
	end

	return threats
end

local function ShowThreats(threatsFrame, missionID)
	if threatsFrame.missionID == missionID then
		threatsFrame:Show()
	end

	-- this creates a fair amount of garbage when scrolling
	local _, _, _, _, _, _, _, enemies = C_Garrison.GetMissionInfo(missionID)
	local counterableThreats = DetermineCounterableThreats(missionID)

	local numThreats = 0
	for _, enemy in ipairs(enemies) do
		for mechanicID, mechanic in next, enemy.mechanics do
			numThreats = numThreats + 1
			local threat = threatsFrame[numThreats]
			if not threat then
				threat = CreateThreatFrame(threatsFrame)
				threat:SetPoint("LEFT", threatsFrame[numThreats - 1], "RIGHT", 10, 0)
				tinsert(threatsFrame, threat)
			end
			local ability = abilityCountersForMechanicTypes[mechanicID]
			threat.abilityCounterIcon = ability.icon
			threat.abilityCounterIsSpecialization = ability.isSpecialization

			threat.Icon:SetTexture(mechanicIcons[mechanic.ability.icon] or mechanic.ability.icon)
			threat.Check:Hide()
			threat.TimeLeft:Hide()
			threat.Working:Hide()

			if counterableThreats.full[mechanicID] and counterableThreats.full[mechanicID] > 0 then
				counterableThreats.full[mechanicID] = counterableThreats.full[mechanicID] - 1
				threat.Check:Show()
			elseif counterableThreats.away[mechanicID] and #counterableThreats.away[mechanicID] > 0 then
				local soonestTime = tremove(counterableThreats.away[mechanicID], 1)
				threat.TimeLeft:SetText(FormatTime(soonestTime))
				threat.TimeLeft:Show()
			elseif counterableThreats.worker[mechanicID] and counterableThreats.worker[mechanicID] > 0 then
				counterableThreats.worker[mechanicID] = counterableThreats.worker[mechanicID] - 1
				threat.Working:Show()
			end

			threat:Show()
		end
	end
	for i = numThreats + 1, #threatsFrame do
		threatsFrame[i]:Hide()
	end
	threatsFrame:SetWidth(30 * numThreats)
	threatsFrame:Show()

	threatsFrame.missionID = missionID
end

local SetRewards
do
	local cache = {}
	local tooltip = CreateFrame("GameTooltip", "BetterClassHallMissionsTooltip", nil, "GameTooltipTemplate")
	tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

	local function GetArtifactPower(itemID)
		if not cache[itemID] then
			tooltip:SetItemByID(itemID)
			local text = _G["BetterClassHallMissionsTooltipTextLeft2"]:GetText()
			if text and text:match(ARTIFACT_POWER) then
				text = _G["BetterClassHallMissionsTooltipTextLeft4"]:GetText()
				local ap = text:match("(%d*[,.]?%d+)")
				if ap then
					cache[itemID] = ap
				end
			end
		end
		return cache[itemID]
	end

	function SetRewards(self, mission)
		local rewards = {}
		if mission.overmaxRewards then
			for i = 1, #mission.overmaxRewards do
				rewards[#rewards + 1] = mission.overmaxRewards[i]
			end
		end
		if mission.rewards then
			for i = 1, #mission.rewards do
				rewards[#rewards + 1] = mission.rewards[i]
			end
		end

		_G.GarrisonMissionButton_SetRewards(self, rewards)

		for index, reward in ipairs(self.Rewards) do
			if index > 1 then
				self.Rewards[index]:SetPoint("RIGHT", self.Rewards[index-1], "LEFT", 15, 0) -- reduce that spacing
			end
			if reward.itemID and IsArtifactPowerItem(reward.itemID) then
				local ap = GetArtifactPower(reward.itemID)
				if ap then
					reward.Quantity:SetFormattedText("|cffe5cc7f%s|r", ap)
					reward.Quantity:Show()
				end
			end
		end
	end

	-- reset the cache on close to pick up AK changes
	OrderHallMissionFrame:HookScript("OnHide", function()
		wipe(cache)
		followerList = nil
		collectgarbage()
	end)
end

hooksecurefunc(OrderHallMissionFrame.MissionTab.MissionList, "Update", function(self)
	for _, button in ipairs(self.listScroll.buttons) do
		local threatsFrame = button.threatsFrame
		if threatsFrame then threatsFrame:Hide() end

		local mission = button.info
		if mission then
			if not mission.inProgress then
				button.Title:ClearAllPoints()
				button.Title:SetPoint("LEFT", 160, 10)
				if button.Title:GetWidth() + button.Summary:GetWidth() + 8 > 475 then
					button.Title:SetWidth(475)
				end
				button.Summary:ClearAllPoints()
				button.Summary:SetPoint("BOTTOMLEFT", button.Title, "BOTTOMRIGHT", 8, 0)

				button.Level:SetTextColor(0.84, 0.72, 0.57, 1.0)
				if mission.isMaxLevel and button.ItemLevel:IsShown() then
					button.ItemLevel:Hide()
					button.Level:SetText(mission.iLevel)
					if mission.isRare then
						button.Level:SetPoint("CENTER", button, "TOPLEFT", 35, -36)
						button.Level:SetTextColor(0.098, 0.537, 0.969, 1.0)
					else
					end
				end

				if not threatsFrame then
					threatsFrame = CreateFrame("Frame", nil, button)
					threatsFrame:SetPoint("TOPLEFT", button.Title, "BOTTOMLEFT", 0, 0)
					threatsFrame:SetSize(0, 28)

					local threat = CreateThreatFrame(threatsFrame)
					threat:SetPoint("TOPLEFT", 0, -4)
					threatsFrame[1] = threat

					local timeRemaining = threatsFrame:CreateFontString(nil, "OVERLAY")
					timeRemaining:SetPoint("LEFT", threatsFrame, "RIGHT", 20, 0)
					timeRemaining:SetFontObject(GameFontHighlightLarge)
					timeRemaining:SetTextColor(0.8, 0.8, 0.8)
					timeRemaining:SetText("")
					threatsFrame.timeRemaining = timeRemaining

					button.threatsFrame = threatsFrame
				end
				ShowThreats(threatsFrame, mission.missionID)

				if not mission.isRare then
					threatsFrame.timeRemaining:SetText("")
				else
					threatsFrame.timeRemaining:SetFormattedText(L_RARE_REMAINING, mission.offerTimeRemaining)
				end
			end

			SetRewards(button, mission)
		end
	end
end)

-- Don't recalculate threat on tooltips
do
	local function OnEnter(self)
		if not self.info or not self.threatsFrame then return end

		GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")

		local missionFrame = OrderHallMissionFrame
		if self.info.inProgress then
			GarrisonMissionButton_SetInProgressTooltip(self.info)
		else
			GameTooltip:SetText(self.info.name)
			GameTooltip:AddLine(string.format(GARRISON_MISSION_TOOLTIP_NUM_REQUIRED_FOLLOWERS, self.info.numFollowers), 1, 1, 1)

			local numThreats = 0
			for i = 1, #self.threatsFrame do
				if not self.threatsFrame[i]:IsShown() then break end
				numThreats = numThreats + 1

				local tooltipThreatFrame = GarrisonMissionListTooltipThreatsFrame.Threats[i]
				if not tooltipThreatFrame then
					tooltipThreatFrame = CreateFrame("Frame", nil, GarrisonMissionListTooltipThreatsFrame, "GarrisonAbilityCounterWithCheckTemplate")
					tooltipThreatFrame:SetPoint("LEFT", GarrisonMissionListTooltipThreatsFrame.Threats[i - 1], "RIGHT", 10, 0)
					tinsert(GarrisonMissionListTooltipThreatsFrame.Threats, tooltipThreatFrame)
				end

				local threatFrame = self.threatsFrame[i]
				tooltipThreatFrame.Border:SetShown(threatFrame.abilityCounterIsSpecialization)
				tooltipThreatFrame.Icon:SetTexture(threatFrame.abilityCounterIcon)
				tooltipThreatFrame.Check:SetShown(threatFrame.Check:IsShown())
				tooltipThreatFrame.Away:SetShown(threatFrame.TimeLeft:IsShown())
				tooltipThreatFrame.Working:SetShown(threatFrame.Working:IsShown())
				tooltipThreatFrame.TimeLeft:Hide()

				tooltipThreatFrame:SetWidth(20)
				tooltipThreatFrame:Show()
			end
			for i = numThreats + 1, #GarrisonMissionListTooltipThreatsFrame.Threats do
				GarrisonMissionListTooltipThreatsFrame.Threats[i]:Hide()
			end

			if numThreats > 0 then
				GarrisonMissionListTooltipThreatsFrame:SetWidth(24 + 30 * numThreats)
				local usedHeight = GameTooltip_InsertFrame(GameTooltip, GarrisonMissionListTooltipThreatsFrame)
				GarrisonMissionListTooltipThreatsFrame:SetHeight(usedHeight) -- 26
			else
				GarrisonMissionListTooltipThreatsFrame:Hide()
			end
		end

		if self.info.offerEndTime then --if self.info.isRare then
			GameTooltip:AddLine(GARRISON_MISSION_AVAILABILITY)
			GameTooltip:AddLine(self.info.offerTimeRemaining, 1, 1, 1)
		end

		GameTooltip:Show()

		missionFrame.MissionTab.MissionList.newMissionIDs[self.info.missionID] = nil
		missionFrame.MissionTab.MissionList:Update()
	end

	local scrollFrame = OrderHallMissionFrame.MissionTab.MissionList.listScroll
	for _, button in next, scrollFrame.buttons do
		button:SetScript("OnEnter", OnEnter)
	end

	scrollFrame:SetScript("OnMouseWheel", function(self, ...)
		HybridScrollFrame_OnMouseWheel(self, ...)
		for i = 1, #self.buttons do
			if self.buttons[i]:IsMouseOver() then
				OnEnter(self.buttons[i])
				break
			end
		end
	end)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, followerTypeID)
	if followerTypeID == LE_FOLLOWER_TYPE_GARRISON_7_0 then
		followerList = nil
	end
end)
frame:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
frame:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
frame:RegisterEvent("GARRISON_FOLLOWER_UPGRADED")
