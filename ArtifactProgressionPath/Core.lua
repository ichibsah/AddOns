local addonName, APP = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("ARTIFACT_UPDATE")
-- frame:RegisterEvent("ARTIFACT_XP_UPDATE")
-- frame:RegisterEvent("ARTIFACT_CLOSE")

local currentArtifact = nil
local ranksPurchased = 0

local debugMode = false
local function Debug(msg)
	if debugMode then print(msg) end
end

---------------------------------------
-- Create overlays for specific artifact
---------------------------------------
local powerButtonOverlays = {}
--[[
powerButtonOverlays structure
powerButtonOverlays = {
	[artifact] = {
		[powerID] = overlay,
	},
}
]]
local function CreateButtonOverlays(artifact)
	Debug("CreateButtonOverlays:" .. (artifact or "nil") .. ", " .. ((not powerButtonOverlays[artifact]) and "creating" or "created"))
	if not powerButtonOverlays[artifact] then	-- not initialized
		powerButtonOverlays[artifact] = {}
		
		-- SocketInventoryItem(_G.INVSLOT_MAINHAND)
		-- local powerButtons = ArtifactFrame.PerksTab.PowerButtons

		local powers = C_ArtifactUI.GetPowers()
		if powers then	-- artifact ready
			Debug("#C_ArtifactUI.GetPowers():" .. #powers)
			for i = 1, #powers do
				local powerButton = ArtifactFrame.PerksTab:GetOrCreatePowerButton(i)
				local powerID = powers[i]
				local overlay = powerButton:CreateFontString(nil, "OVERLAY")
				local font = GameFontNormal:GetFont()
				overlay:SetFont(font, 18, "OUTLINE")
				overlay:SetPoint("CENTER", 0, 0)
				powerButtonOverlays[artifact][powerID] = overlay
			end
			wipe(powers)
		end
	end
end

---------------------------------------
-- Set Text
---------------------------------------
local function SetOverlaysText(artifact, path)
	Debug("SetOverlaysText:" .. (artifact or "nil"))
	
	local temp = APP.data[artifact]
	local startIndex = 1
	if #temp <= 2 then	-- 2 paths
		temp = APP.data[artifact][path]
		startIndex = 2
	end
		
	local last = #temp
	if ranksPurchased == 0 then last = 2 end
		
	for i = startIndex, last do
		local powerID = temp[i]
		local overlay = powerButtonOverlays[artifact][powerID]
		if overlay then
			overlay:SetText(i - startIndex + 1)
			overlay:Show()
			overlay:SetTextColor(1, 1, 1, 1)
			-- Debug("SetText:" .. (i - startIndex + 1) .. " - " .. powerID)
		else
			print("|cffFF2222InvalidPowerID:|r" .. powerID)
		end
	end
end

---------------------------------------
-- Set Highlight
---------------------------------------
local highlightFrame = nil

local function CreateHighlightFrame()
	Debug("CreateHighlightFrame...")
	highlightFrame = CreateFrame("Frame", "APP-Highlight", ArtifactFrame.PerksTab)
	highlightFrame:SetSize(50, 50)
	highlightFrame:EnableMouse(false)
	highlightFrame:SetAlpha(0)
	
	local t1 = highlightFrame:CreateTexture("APP-HighlightRing", "ARTWORK")
	t1:SetAtlas("ArtifactsFX-YellowRing")
	t1:SetSize(50, 50)
	t1:SetBlendMode("ADD")
	t1:SetDrawLayer("OVERLAY", 5)
	t1:SetPoint("CENTER", 0, 0)

	local t2 = highlightFrame:CreateTexture("APP-HighlightGlow", "ARTWORK")
	t2:SetAtlas("Artifacts-PerkRing-MainProc-Glow")
	t2:SetSize(120, 120)
	t2:SetBlendMode("ADD")
	t2:SetDrawLayer("OVERLAY", 5)
	t2:SetPoint("CENTER", 0, 0)
end

local function SetOrRemoveHighlight(artifact, powerID, isSet)
	local overlay = powerButtonOverlays[artifact][powerID]
	if isSet then
		Debug("|cff22FF22SetHighlight:|r" .. powerID)
		C_Timer.After(0.01, function()
			local point, relativeTo, relativePoint, xOffset, yOffset = overlay:GetParent():GetPoint()
			if point then
				if not highlightFrame then CreateHighlightFrame() end
				
				highlightFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
				-- C_Timer.NewTicker(0.005, function() highlightFrame:SetAlpha(highlightFrame:GetAlpha() + 0.1) end, 11)
				highlightFrame:SetAlpha(1)
			end
			overlay:SetTextColor(1, 0.3, 0.3, 1)
		end)
	else
		-- Debug("|cff22FF22RemoveHightlight:|r" .. powerID)
		overlay:SetTextColor(1, 1, 1, 1)
	end
end

local function RefreshHighlight(artifact, path, index)
	local temp = APP.data[artifact]
	local startIndex = 1
	if #temp <= 2 then	-- 2 paths
		temp = APP.data[artifact][path]
		startIndex = 2
	end
	
	if index then	-- highlight exists
		Debug("|cff2222FFSavedHighlight:|r" .. temp[index])
		startIndex = index
	else
		Debug("|cff2222FFSearching for highlight...|r")
	end
	
	for i = startIndex, #temp do
		local powerID = temp[i]
		-- spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = C_ArtifactUI.GetPowerInfo(powerID)
		local _, _, currentRank, maxRank = C_ArtifactUI.GetPowerInfo(powerID)
		
		if currentRank < maxRank then
			SetOrRemoveHighlight(artifact, powerID, true)
			Debug("|cffFF2222SaveHighlight:|r" .. temp[i] .. " (" .. currentRank .. "/" .. maxRank .. ")")
			APP.cfg[artifact][2] = i
			return
		else	-- restore changes
			SetOrRemoveHighlight(artifact, powerID, false)
		end
	end
end

---------------------------------------
-- DropDownMenu
---------------------------------------
local APPDropDownMenu = {}

local function APPDropDownMenu_Initialize(self, level)
	for i = 1, #APP.data[currentArtifact] do
		local info = UIDropDownMenu_CreateInfo()
		info.text = APP.data[currentArtifact][i][1]
		info.value = i
		-- info.tooltipTitle = "title"
		-- info.tooltipText = "test tooltip"
		info.func = function(self)
			UIDropDownMenu_SetSelectedValue(APPDropDownMenu[currentArtifact], self.value)
			-- UIDropDownMenu_SetSelectedID(APPDropDownMenu[currentArtifact], self:GetID())
			Debug("|cffFF2222APP.cfg[".. currentArtifact .."][1]|r = " .. self.value .. "(" .. self:GetText() .. ")")
			APP.cfg[currentArtifact][1] = self.value
			APP_Refresh()
		end
		UIDropDownMenu_AddButton(info, level)
	end
end

local function ShowAPPDropDownMenu(show)
	if not show then
		if APPDropDownMenu[currentArtifact] then
			APPDropDownMenu[currentArtifact]:Hide()
			Debug("HideAPPDropDownMenu:" .. currentArtifact)
		end
		return
	end
	Debug("ShowAPPDropDownMenu")
	
	if not APPDropDownMenu[currentArtifact] then
		Debug("APPDropDownMenu_Initialize:" .. currentArtifact .. "#" .. #APP.data[currentArtifact])
		
		APPDropDownMenu[currentArtifact] = CreateFrame("Frame", "APPDropDownMenu" .. currentArtifact, ArtifactFrame, "UIDropDownMenuTemplate")
		UIDropDownMenu_Initialize(APPDropDownMenu[currentArtifact], APPDropDownMenu_Initialize)
		UIDropDownMenu_SetWidth(APPDropDownMenu[currentArtifact], 120);
		-- UIDropDownMenu_SetButtonWidth(APPDropDownMenu, 124)
		UIDropDownMenu_SetSelectedValue(APPDropDownMenu[currentArtifact], APP.cfg[currentArtifact][1])
		UIDropDownMenu_JustifyText(APPDropDownMenu[currentArtifact], "LEFT")
	end
	
	APPDropDownMenu[currentArtifact]:Show()
	APPDropDownMenu[currentArtifact]:ClearAllPoints()
	APPDropDownMenu[currentArtifact]:SetPoint("TOPRIGHT", ArtifactFrame, -5, 3)
end

---------------------------------------
-- Hide & Refresh
---------------------------------------
local function APP_HideAll()
	if highlightFrame then highlightFrame:SetAlpha(0) end
	for artifactID, artifactTable in pairs(powerButtonOverlays) do
		Debug("APP_Hide:" .. artifactID)
		for _, overlay in pairs(artifactTable) do
			overlay:Hide()
		end
	end
	for artifactID, dropDownMenu in pairs(APPDropDownMenu) do
		dropDownMenu:Hide()
	end
end

function APP_Refresh()
	Debug("---------------------------")
	-- itemID, altItemID, name, iconFileDataID, powerAvailable, ranksPurchased, ranksKnown, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetArtifactInfo()
	currentArtifact, _, _, _, _, ranksPurchased = C_ArtifactUI.GetArtifactInfo()
	
	if ArtifactFrame and currentArtifact and currentArtifact ~= "" then
		APP_HideAll()
		
		if type(APP.cfg[currentArtifact]) ~= "table" then APP.cfg[currentArtifact] = {1, nil} end -- {selectedPath, highlightIndex}
		
		local path = APP.cfg[currentArtifact][1]
		Debug("APP_Refresh:" .. currentArtifact .. (APP.data[currentArtifact] and ", supported" or ", not supported") .. ", path:" .. path)
		if APP.data[currentArtifact] then	-- supported
			CreateButtonOverlays(currentArtifact)
			SetOverlaysText(currentArtifact, path)
			RefreshHighlight(currentArtifact, path, (ranksPurchased ~= 0) and APP.cfg[currentArtifact][2] or nil)	-- if reset then index = nil
			ShowAPPDropDownMenu(#APP.data[currentArtifact] <= 2)
		end
	end
end

---------------------------------------
-- Event
---------------------------------------
function frame:ARTIFACT_UPDATE()
	APP_Refresh()
end

function frame:ADDON_LOADED(arg1)
	if arg1 == addonName then
		frame:UnregisterEvent("ADDON_LOADED")
		if type(ArtifactProgressionPath) ~= "table" then ArtifactProgressionPath = {} end
		APP.cfg = ArtifactProgressionPath
	end
end

frame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

---------------------------------------
-- Slash
---------------------------------------
SLASH_ARTIFACTPROGRESSIONPATH1 = '/app'
function SlashCmdList.ARTIFACTPROGRESSIONPATH(msg, editBox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if command == "reset" then
		print("ArtifactProgressionPath config reset...")
		APP.cfg[currentArtifact] = nil
		APP_Refresh()
	-- elseif command == "hide" then
	-- elseif command == "fontsize" and rest ~= "" then
	end
end