--[[
	GuildFinder
	Copyright © 2012, 2013, 2015 LudwigV

	This file is part of GuildFinder.

	GuildFinder is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	GuildFinder is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with GuildFinder.  If not, see <http://www.gnu.org/licenses/>.
]]

local L = GUILDFINDER_LOCALE

local GuildFinderRecrutingGuilds = {}

local NUM_GUILD_MEMBERS_MIN = 1
local NUM_GUILD_MEMBERS_MAX = 999
local NUM_GUILD_MEMBERS_STEP = 1 -- 10
local GUILD_ACH_POINTS_MIN = 0
local GUILD_ACH_POINTS_MAX = 2550
local GUILD_ACH_POINTS_STEP = 1 -- 50

local GUILD_BUTTON_HEIGHT = 84
local GUILD_COMMENT_HEIGHT = 50
local GUILD_COMMENT_BORDER = 10

local function GuildFinderInit()
	LookingForGuildFrame:SetHeight(580)

	-- NumGuildMembers frame
	CreateFrame("Frame", "GuildFinderNumGuildMembersFrame", LookingForGuildStartFrame, "LookingForGuildSectionTemplate")
	GuildFinderNumGuildMembersFrame:SetPoint("TOPLEFT", 8, -10)
	GuildFinderNumGuildMembersFrameText:SetText(L["GUILDFINDER_WORDS_NUM_GUILD_MEMBERS"])
	-- NumGuildMembersMin slider
	CreateFrame("Slider", "GuildFinderNumGuildMembersMin", GuildFinderNumGuildMembersFrame, "GuildFinderSliderTemplate")
	GuildFinderNumGuildMembersMin:SetPoint("TOPLEFT", 30, -40)
	GuildFinderNumGuildMembersMin.text = L["GUILDFINDER_WORDS_NUM_GUILD_MEMBERS_FROM"]
	GuildFinderNumGuildMembersMinLow:SetText(NUM_GUILD_MEMBERS_MIN)
	GuildFinderNumGuildMembersMinHigh:SetText(NUM_GUILD_MEMBERS_MAX)
	GuildFinderNumGuildMembersMin:SetMinMaxValues(NUM_GUILD_MEMBERS_MIN, NUM_GUILD_MEMBERS_MAX)
	GuildFinderNumGuildMembersMin:SetValueStep(NUM_GUILD_MEMBERS_STEP)
	GuildFinderNumGuildMembersMin:SetScript("OnValueChanged", GuildFinderNumGuildMembersMin_OnValueChanged)
	GuildFinderNumGuildMembersMin:SetValue(NUM_GUILD_MEMBERS_MIN)

	-- GuildAchPoints frame
	CreateFrame("Frame", "GuildFinderGuildAchPointsFrame", LookingForGuildStartFrame, "LookingForGuildSectionTemplate")
	GuildFinderGuildAchPointsFrame:SetPoint("TOPLEFT", GuildFinderNumGuildMembersFrame, "BOTTOMLEFT", 0, -4)
	GuildFinderGuildAchPointsFrameText:SetText(L["GUILDFINDER_WORDS_GUILD_ACH_POINTS"])
	-- GuildAchPointsMin slider
	CreateFrame("Slider", "GuildFinderGuildAchPointsMin", GuildFinderGuildAchPointsFrame, "GuildFinderSliderTemplate")
	GuildFinderGuildAchPointsMin:SetPoint("TOPLEFT", 30, -40)
	GuildFinderGuildAchPointsMin.text = L["GUILDFINDER_WORDS_GUILD_ACH_POINTS_FROM"]
	GuildFinderGuildAchPointsMinLow:SetText(GUILD_ACH_POINTS_MIN)
	GuildFinderGuildAchPointsMinHigh:SetText(GUILD_ACH_POINTS_MAX)
	GuildFinderGuildAchPointsMin:SetMinMaxValues(GUILD_ACH_POINTS_MIN, GUILD_ACH_POINTS_MAX)
	GuildFinderGuildAchPointsMin:SetValueStep(GUILD_ACH_POINTS_STEP)
	GuildFinderGuildAchPointsMin:SetScript("OnValueChanged", GuildFinderGuildAchPointsMin_OnValueChanged)
	GuildFinderGuildAchPointsMin:SetValue(GUILD_ACH_POINTS_MIN)

	-- Interest frame
	LookingForGuildInterestFrame:SetPoint("TOPLEFT", GuildFinderGuildAchPointsFrame, "BOTTOMLEFT", 0, -4)

	-- RoleButtons
	LookingForGuildFrame:SetScript("OnShow", EnableAllRoleButtons)

	-- GuildsFound font string
	LookingForGuildStartFrame:CreateFontString("GuildFinderGuildsFound", "ARTWORK", "GameFontHighlightSmall")
	GuildFinderGuildsFound:SetPoint("BOTTOMLEFT", LookingForGuildFrame, "BOTTOMLEFT", 15, 9)
	GuildFinderGuildsFound:SetFormattedText(L["GUILDFINDER_WORDS_GUILDS_FOUND"], 0)


	-- Browse frame
	LookingForGuildBrowseFrameContainer:SetHeight(482)

	LookingForGuildBrowseFrameContainer.update = GuildFinder_Update
	HybridScrollFrame_CreateButtons(LookingForGuildBrowseFrameContainer, "LookingForGuildGuildTemplate", 0, 0)


	LookingForGuild_Update = GuildFinder_Update
end



function GuildFinderSlider_OnValueChanged(self)
	local slider_value = floor(self:GetValue() + .5)
	self:SetValue(slider_value)
	g = _G[self:GetName() .. "Text"]
	g:SetText(self.text .. " (" .. slider_value .. ")")
end

function GuildFinderNumGuildMembersMin_OnValueChanged(self)
	GuildFinderSlider_OnValueChanged(self)
	LookingForGuild_Update()
end

function GuildFinderGuildAchPointsMin_OnValueChanged(self)
	GuildFinderSlider_OnValueChanged(self)
	LookingForGuild_Update()
end



function EnableAllRoleButtons()
	PlaySound("igCharacterInfoOpen")

	LookingForGuild_UpdateRoleButton(LookingForGuildTankButton, true)
	LookingForGuild_UpdateRoleButton(LookingForGuildHealerButton, true)
	LookingForGuild_UpdateRoleButton(LookingForGuildDamagerButton, true)

	UpdateMicroButtons()
	RequestGuildMembershipList()

	RequestRecruitingGuildsList()
end



function GuildFinderUpdateGuildsList()
	local numGuilds = GetNumRecruitingGuilds()
	local j = 0
	for i = 1, numGuilds do
		local name, level, numMembers, achPoints, comment, cached, requestPending = GetRecruitingGuildInfo(i)
		if (numMembers >= GuildFinderNumGuildMembersMin:GetValue()) and (achPoints >= GuildFinderGuildAchPointsMin:GetValue()) then
			j = j + 1
			GuildFinderRecrutingGuilds[j] = {index = i}
		end
	end
	GuildFinderRecrutingGuilds.numGuilds = j
	GuildFinderGuildsFound:SetFormattedText(L["GUILDFINDER_WORDS_GUILDS_FOUND"], j)
end

function GuildFinder_Update()
	GuildFinderUpdateGuildsList()
	local scrollFrame = LookingForGuildBrowseFrameContainer
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numButtons = #buttons
	local button, index
	local numGuilds = GuildFinderRecrutingGuilds.numGuilds
	local _, numAppsRemaining = GetNumGuildMembershipRequests()
	local selection = GetRecruitingGuildSelection()

	for i = 1, numButtons do
		button = buttons[i]
		index = offset + i
		if (index <= numGuilds) then
			local name, level, numMembers, achPoints, comment, cached, requestPending = GetRecruitingGuildInfo(GuildFinderRecrutingGuilds[index].index)
			button.name:SetText(name)
			button.numMembers:SetFormattedText(BROWSE_GUILDS_NUM_MEMBERS, numMembers)
			button.achPoints:SetText(achPoints)
			button.comment:SetText(comment)
			button.fullComment:SetText(comment)
			-- tabard
			local tabardInfo = { GetRecruitingGuildTabardInfo(GuildFinderRecrutingGuilds[index].index) }
			SetLargeGuildTabardTextures(nil, button.emblem, button.tabard, button.border, tabardInfo)
			-- selection
			local buttonHeight = GUILD_BUTTON_HEIGHT
			if (requestPending) then
				button.selectedTex:Show()
				button.pendingFrame:Show()
			else
				button.pendingFrame:Hide()
				if (GuildFinderRecrutingGuilds[index].index == selection) then
					button.selectedTex:Show()
					local commentHeight = button.fullComment:GetHeight()
					if (commentHeight > GUILD_COMMENT_HEIGHT) then
						buttonHeight = GUILD_BUTTON_HEIGHT + commentHeight - GUILD_COMMENT_HEIGHT + GUILD_COMMENT_BORDER
					end
				else
					button.selectedTex:Hide()
				end
			end
			button:SetHeight(buttonHeight)

			button:Show()
			button.index = GuildFinderRecrutingGuilds[index].index
		else
			button:Hide()
		end
	end

	if (not selection) then
		HybridScrollFrame_CollapseButton(scrollFrame)
	end

	local totalHeight = numGuilds * GUILD_BUTTON_HEIGHT
	if (scrollFrame.largeButtonHeight) then
		totalHeight = totalHeight + (scrollFrame.largeButtonHeight - GUILD_BUTTON_HEIGHT)
	end
	local displayedHeight = numButtons * GUILD_BUTTON_HEIGHT
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight)

	if (selection and numAppsRemaining > 0) then
		LookingForGuildRequestButton:Enable()
	else
		LookingForGuildRequestButton:Disable()
	end
end



local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

local function eventHandler(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... == "Blizzard_LookingForGuildUI" then
			GuildFinderInit()
		end
	end
end
f:SetScript("OnEvent", eventHandler)


