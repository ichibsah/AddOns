local OptionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
OptionsFrame.name = GRT_Title
OptionsFrame:Hide()
OptionsFrame:RegisterEvent("PLAYER_LOGIN")

-- Local vars and helper functions used in this layout --
local previousbox
local checkboxes = {}

local BoxMonday
local BoxTuesday
local BoxWednesday
local BoxThursday
local BoxFriday
local BoxSaturday
local BoxSunday

local function AddCheckbox(text, relativeTo, size, offX, offY, font)
    local checkbox = CreateFrame("CheckButton", nil, OptionsFrame, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", offX, offY)
	checkbox:SetSize(size, size)
    checkbox.text:SetFontObject(font)
    checkbox.text:SetText("  " .. text)
    previousbox = checkbox
    return checkbox
end

local function AddTextLabel(text, relativeTo, offX, offY, font)
	local textlabel = OptionsFrame:CreateFontString(nil, "ARTWORK", font)
	if (not relativeTo) then
		textlabel:SetPoint("TOPLEFT", offX, offY)
	else
		textlabel:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", offX, offY)
	end
	textlabel:SetJustifyH("LEFT")
	textlabel:SetFontObject(font)
	textlabel:SetText(text)
	return textlabel
end
----

function OptionsFrame_OnEvent(self, event, ...)
	-- we registered only for one event so no need to check which one we've received
	local OptionsTitle = AddTextLabel(GRT_Title, nil, 16, -16, "GameFontNormalLarge")
	local OptionsRanks = AddTextLabel("Choose ranks to be affected by the toggle:", OptionsTitle, 0, -20, "GameFontNormal")
	previousbox = OptionsRanks

	if GuildControlGetNumRanks() < 1 then
		previousbox =  AddTextLabel("You are not in a guild or your guild does not have any ranks!", previousbox, 5, -5, "GameFontHighlight")
	else
		for i=1, GuildControlGetNumRanks() do
			local name = GuildControlGetRankName(i)
			local offY = (i == 1) and -5 or 0 -- we want offset only for the first row
			local offX = (i == 1) and 5 or 0
			checkboxes[i] = AddCheckbox(name, previousbox, 16, offX, offY, "GameFontHighlight")
		end
	end
	
	if (#checkboxes > 0) then
		checkboxes[1]:Disable() -- can't edit Guild Master rank
	end

	local OptionsAutoToggle = AddTextLabel("Automatic toggling repairs on or off on selected days:", previousbox, -5, -20, "GameFontNormal")
	local OptionsAutoToggle_Desc = AddTextLabel("Check the days when the repairs should be available. Changes will be performed when you log in.\
If none of the boxes are checked the addon will not auto-toggle repairs.", OptionsAutoToggle, 0, -3, "GameFontHighlightSmall")
	OptionsAutoToggle_Desc:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 40)

	BoxMonday = AddCheckbox("Monday", OptionsAutoToggle_Desc, 16, 5, -5, "GameFontHighlight")
	BoxTuesday = AddCheckbox("Tuesday", previousbox, 16, 0, 0, "GameFontHighlight")
	BoxWednesday = AddCheckbox("Wednesday", previousbox, 16, 0, 0, "GameFontHighlight")
	BoxThursday = AddCheckbox("Thursday", previousbox, 16, 0, 0, "GameFontHighlight")
	BoxFriday = AddCheckbox("Friday", previousbox, 16, 0, 0, "GameFontHighlight")
	BoxSaturday = AddCheckbox("Saturday", previousbox, 16, 0, 0, "GameFontHighlight")
	BoxSunday = AddCheckbox("Sunday", previousbox, 16, 0, 0, "GameFontHighlight")
end

function OptionsFrame.default()
	GRT_SavedVars.ranks = {}
	for i=2, GuildControlGetNumRanks() do
		GRT_SavedVars.ranks[i] = {GuildControlGetRankName(i), false}
	end
	
	GRT_SavedVars.days = {}
	GRT_SavedVars.days[1] = false;
	GRT_SavedVars.days[2] = false;
	GRT_SavedVars.days[3] = false;
	GRT_SavedVars.days[4] = false;
	GRT_SavedVars.days[5] = false;
	GRT_SavedVars.days[6] = false;
	GRT_SavedVars.days[7] = false;
	
	GRT_SavedVars.enabledDays = false;
end

function OptionsFrame.refresh()
	BoxMonday:SetChecked(GRT_SavedVars.days[2])
	BoxTuesday:SetChecked(GRT_SavedVars.days[3])
	BoxWednesday:SetChecked(GRT_SavedVars.days[4])
	BoxThursday:SetChecked(GRT_SavedVars.days[5])
	BoxFriday:SetChecked(GRT_SavedVars.days[6])
	BoxSaturday:SetChecked(GRT_SavedVars.days[7])
	BoxSunday:SetChecked(GRT_SavedVars.days[1])
	
	if #GRT_SavedVars.ranks ~= GuildControlGetNumRanks() then
		print("|cff00ccffGuildRepairsToggle|r: |cffff0000Warning!|r GRT found out that the number of ranks in your guild has changed. Please reload UI to refresh the rank list and set correct ranks in the GRT config")
		return
	end
	
	for i=1, #GRT_SavedVars.ranks do
		if i > #checkboxes then
			return
		end
		checkboxes[i]:SetChecked(GRT_SavedVars.ranks[i][2])
		if GRT_SavedVars.ranks[i][1] ~= GuildControlGetRankName(i) then
			print("|cff00ccffGuildRepairsToggle|r: |cffff0000Warning!|r GRT found out that changes to the guild ranks have been made. Please reload UI to refresh the rank list and check GRT config to avoid any complications.")
		end
	end		
end

function OptionsFrame.okay()
	GRT_SavedVars.ranks = {}
	for i=1, GuildControlGetNumRanks() do
		GRT_SavedVars.ranks[i] = {GuildControlGetRankName(i), checkboxes[i]:GetChecked()}
	end

	GRT_SavedVars.days = {}
	GRT_SavedVars.days[1] = BoxSunday:GetChecked()
	GRT_SavedVars.days[2] = BoxMonday:GetChecked()
	GRT_SavedVars.days[3] = BoxTuesday:GetChecked()
	GRT_SavedVars.days[4] = BoxWednesday:GetChecked()
	GRT_SavedVars.days[5] = BoxThursday:GetChecked()
	GRT_SavedVars.days[6] = BoxFriday:GetChecked()
	GRT_SavedVars.days[7] = BoxSaturday:GetChecked()

	GRT_SavedVars.daysEnabled = false
	
	for _, k in ipairs(GRT_SavedVars.days) do
		if (k == true) then
			GRT_SavedVars.daysEnabled = true
		end
	end
end

OptionsFrame:SetScript("OnEvent", OptionsFrame_OnEvent)
InterfaceOptions_AddCategory(OptionsFrame)



