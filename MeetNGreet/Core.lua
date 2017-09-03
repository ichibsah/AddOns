CreateFrame('Frame', "MeetNGreet", UIParent)

local L = LibStub('AceLocale-3.0'):GetLocale("MeetNGreet")

MeetNGreet:SetScript('OnEvent', function(self)
	local defaults = {
		profile = {
			farewell = {
				['**'] = {
					female = L["Farewell!"],
					male = L["Farewell!"]
				}
			},
			greet = {
				['**'] = {
					female = L["Greetings!"],
					male = L["Greetings!"]
				}
			}
		}
	}
	self.db = LibStub('AceDB-3.0'):New("MeetNGreetDB", defaults)
	self:SetScript('OnEvent', nil)
	self:UnregisterEvent('ADDON_LOADED')
end)
MeetNGreet:RegisterEvent('ADDON_LOADED')
MeetNGreet:Hide()

local negativeEmotes = { 'ANGRY', 'BARK', 'BURP', 'BONK', 'BONK', 'CHICKEN', 'CRACK', 'DROOL', 'EYE', 'FART', 'GROAN', 'GUFFAW', 'INSULT', 'INSULT', 'INSULT', 'LAUGH', 'MOCK', 'MOON', 'NOSEPICK', 'PITY', 'RASP', 'ROAR', 'RUDE', 'SHOO', 'SLAP', 'SNARL', 'SPIT', 'STINK', 'THREATEN', 'VIOLIN' }

local playerClass, playerFaction, playerName, playerRace = UnitClass('player'):lower(), select(2, UnitFactionGroup('player')), UnitName('player'), UnitRace('player'):lower()

local function process(settings, emote)
	if UnitExists('target') then
		if UnitIsFriend('player', 'target') then
			if not UnitIsDeadOrGhost('target') then
				local gender, playerGuild, targetGuild = UnitSex('target') == 3 and "female" or "male", GetGuildInfo('player'), GetGuildInfo('target')
				local reaction = playerGuild and playerGuild == targetGuild and "guild" or "ally"

				local targetRace, targetClass, targetFaction = (UnitRace('target') or UnitCreatureFamily('target') or UnitCreatureType('target')):lower()
				if UnitIsPlayer('target') then
					targetClass, targetFaction = UnitClass('target'):lower(), select(2, UnitFactionGroup('target'))
				else
					targetClass, targetFaction = L["warrior"], L["the neutral"]
				end

				local say = settings[reaction][gender]:gsub("$c", playerClass)
				say = say:gsub("$C", targetClass)
				say = say:gsub("$f", playerFaction)
				say = say:gsub("$F", targetFaction)
				say = say:gsub("$g", playerGuild or L["the unguilded"])
				say = say:gsub("$G", targetGuild or L["the unguilded"])
				say = say:gsub("$n", playerName)
				say = say:gsub("$N", UnitName('target') or L["unknown"], nil)
				say = say:gsub("$r", playerRace)
				say = say:gsub("$R", targetRace)
				SendChatMessage(say:sub(1, 1):upper() .. say:sub(2))
				emote = gender == "female" and 'BOW' or (reaction == "guild" and 'SALUTE' or 'WAVE')
			else
				emote = 'MOURN'
			end
		elseif not UnitIsDeadOrGhost('target') then
			emote = negativeEmotes[random(1, #negativeEmotes)]
		else
			emote = 'ROFL'
		end
	end
	DoEmote(emote)
end

function MeetNGreet:Farewell()
	process(self.db.profile.farewell, 'BYE')
end

function MeetNGreet:Greet()
	process(self.db.profile.greet, 'HELLO')
end

MeetNGreet:SetScript('OnShow', function(self)
	local frame, method, savedText = self, "greet"
	frame:SetHeight(424)
	frame:SetWidth(576)
	frame:SetPoint('CENTER')
	frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
		tile = true, tileSize = 32,
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		edgeSize = 32,
		insets = { bottom = 10, left = 11, right = 11, top = 11 }
	})

	local header = frame:CreateTexture(nil, 'ARTWORK')
	header:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	header:SetHeight(68)
	header:SetWidth(300)
	header:SetPoint('TOP', frame, 'TOP', 0, 12)

	local label = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	label:SetText("MeetNGreet")
	label:SetPoint('TOP', header, 'TOP', 0, -15)

	label = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	label:SetText(L["Available special symbols and their meanings:"])
	label:SetPoint('LEFT')
	label:SetPoint('RIGHT')
	label:SetPoint('TOP', frame, 'TOP', 0, -36)
	label:SetJustifyH('CENTER')

	local symbol_c = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_c:SetText(L["$c = class of the player"])
	symbol_c:SetPoint('LEFT')
	symbol_c:SetPoint('RIGHT', frame, 'CENTER')
	symbol_c:SetPoint('TOP', label, 'BOTTOM', 0, -16)
	symbol_c:SetJustifyH('CENTER')

	local symbol_f = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_f:SetText(L["$f = faction of the player"])
	symbol_f:SetPoint('LEFT')
	symbol_f:SetPoint('RIGHT', frame, 'CENTER')
	symbol_f:SetPoint('TOP', symbol_c, 'BOTTOM', 0, -8)
	symbol_f:SetJustifyH('CENTER')

	local symbol_g = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_g:SetText(L["$g = guild of the player"])
	symbol_g:SetPoint('LEFT')
	symbol_g:SetPoint('RIGHT', frame, 'CENTER')
	symbol_g:SetPoint('TOP', symbol_f, 'BOTTOM', 0, -8)
	symbol_g:SetJustifyH('CENTER')

	local symbol_n = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_n:SetText(L["$n = name of the player"])
	symbol_n:SetPoint('LEFT')
	symbol_n:SetPoint('RIGHT', frame, 'CENTER')
	symbol_n:SetPoint('TOP', symbol_g, 'BOTTOM', 0, -8)
	symbol_n:SetJustifyH('CENTER')

	local symbol_r = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_r:SetText(L["$r = race of the player"])
	symbol_r:SetPoint('LEFT')
	symbol_r:SetPoint('RIGHT', frame, 'CENTER')
	symbol_r:SetPoint('TOP', symbol_n, 'BOTTOM', 0, -8)
	symbol_r:SetJustifyH('CENTER')

	symbol_c = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_c:SetText(L["$C = class of the target"])
	symbol_c:SetPoint('LEFT', frame, 'CENTER')
	symbol_c:SetPoint('RIGHT')
	symbol_c:SetPoint('TOP', label, 'BOTTOM', 0, -16)
	symbol_c:SetJustifyH('CENTER')

	symbol_f = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_f:SetText(L["$F = faction of the target"])
	symbol_f:SetPoint('LEFT', frame, 'CENTER')
	symbol_f:SetPoint('RIGHT')
	symbol_f:SetPoint('TOP', symbol_c, 'BOTTOM', 0, -8)
	symbol_f:SetJustifyH('CENTER')

	symbol_g = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_g:SetText(L["$G = guild of the target"])
	symbol_g:SetPoint('LEFT', frame, 'CENTER')
	symbol_g:SetPoint('RIGHT')
	symbol_g:SetPoint('TOP', symbol_f, 'BOTTOM', 0, -8)
	symbol_g:SetJustifyH('CENTER')

	symbol_n = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_n:SetText(L["$N = name of the target"])
	symbol_n:SetPoint('LEFT', frame, 'CENTER')
	symbol_n:SetPoint('RIGHT')
	symbol_n:SetPoint('TOP', symbol_g, 'BOTTOM', 0, -8)
	symbol_n:SetJustifyH('CENTER')

	symbol_r = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	symbol_r:SetText(L["$R = race of the target"])
	symbol_r:SetPoint('LEFT', frame, 'CENTER')
	symbol_r:SetPoint('RIGHT')
	symbol_r:SetPoint('TOP', symbol_n, 'BOTTOM', 0, -8)
	symbol_r:SetJustifyH('CENTER')

	local function load()
		local settings = MeetNGreet.db.profile[method]
		if method == "greet" then
			frame.toggle:SetText(L["Farewell"])
			frame[1].label:SetText(L["Greeting for a male guild member:"])
			frame[2].label:SetText(L["Greeting for a female guild member:"])
			frame[3].label:SetText(L["Greeting for a male ally:"])
			frame[4].label:SetText(L["Greeting for a female ally:"])
		else
			frame.toggle:SetText(L["Greet"])
			frame[1].label:SetText(L["Farewell for a male guild member:"])
			frame[2].label:SetText(L["Farewell for a female guild member:"])
			frame[3].label:SetText(L["Farewell for a male ally:"])
			frame[4].label:SetText(L["Farewell for a female ally:"])
		end
		frame[1]:SetText(settings.guild.male)
		frame[2]:SetText(settings.guild.female)
		frame[3]:SetText(settings.ally.male)
		frame[4]:SetText(settings.ally.female)
	end

	local function save()
		local settings = MeetNGreet.db.profile[method]
		settings.guild.male = frame[1]:GetText()
		settings.guild.female = frame[2]:GetText()
		settings.ally.male = frame[3]:GetText()
		settings.ally.female = frame[4]:GetText()
	end

	local okay = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate')
	okay:SetText(OKAY)
	okay:SetHeight(22)
	okay:SetWidth(96)
	okay:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -16, 16)
	okay:SetScript('OnClick', function()
		save()
		frame:Hide()
	end)

	local toggle = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate')
	toggle:SetHeight(22)
	toggle:SetWidth(96)
	toggle:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 16, 16)
	toggle:SetScript('OnClick', function()
		save()
		method = method == "greet" and "farewell" or "greet"
		load()
	end)
	frame.toggle = toggle

	local function OnEditFocusGained(self)
		savedText = self:GetText()
	end

	local function OnEscapePressed(self)
		self:SetText(savedText)
		self:ClearFocus()
	end

	local function OnTabPressed(self)
		local index = self.index + 1
		frame[index <= #frame and index or 1]:SetFocus()
	end

	local backdrop, editBox = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		edgeSize = 16,
		insets = { bottom = 4, left = 4, right = 4, top = 4 }
	}
	for index = 1, 4 do
		editBox = CreateFrame('EditBox', nil, frame)
		editBox:SetHeight(24)
		editBox:SetPoint('LEFT', frame, 'LEFT', 16, 0)
		editBox:SetPoint('RIGHT', frame, 'RIGHT', -16, 0)
		editBox:SetBackdrop(backdrop)
		editBox:SetBackdropColor(0, 0, 0)
		editBox:SetBackdropBorderColor(0.6, 0.6, 0.6)
		editBox:SetFontObject('GameFontHighlight')
		editBox:SetTextInsets(5, 5, 0, 0)
		editBox:SetAutoFocus(false)
		editBox:SetScript('OnEditFocusGained', OnEditFocusGained)
		editBox:SetScript('OnEditFocusLost', save)
		editBox:SetScript('OnEnterPressed', editBox.ClearFocus)
		editBox:SetScript('OnEscapePressed', OnEscapePressed)
		editBox:SetScript('OnTabPressed', OnTabPressed)
		editBox.index, frame[index] = index, editBox

		label = editBox:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		label:SetPoint('BOTTOMLEFT', editBox, 'TOPLEFT', 4, 2)
		editBox.label = label
	end

	frame[4]:SetPoint('BOTTOM', okay, 'TOP', 0, 16)
	frame[3]:SetPoint('BOTTOM', frame[4], 'TOP', 0, 28)
	frame[2]:SetPoint('BOTTOM', frame[3], 'TOP', 0, 28)
	frame[1]:SetPoint('BOTTOM', frame[2], 'TOP', 0, 28)

	self.db.RegisterCallback(self, 'OnProfileChanged', load)
	self.db.RegisterCallback(self, 'OnProfileCopied', load)
	self.db.RegisterCallback(self, 'OnProfileReset', load)
	self:SetScript('OnShow', nil)
	load()
end)

_G["SLASH_MeetNGreet1"] = "/MeetNGreet"
_G["SLASH_MeetNGreet2"] = "/meetngreet"
_G["SLASH_MeetNGreet3"] = "/MEETNGREET"
_G["SLASH_MeetNGreet4"] = "/mng"
_G["SLASH_MeetNGreet5"] = "/MtNG"
SlashCmdList["MeetNGreet"] = function()
	MeetNGreet:Show()
end

BINDING_HEADER_MeetNGreet = "MeetNGreet"
BINDING_NAME_MeetNGreet_Farewell = L["Farewell"]
BINDING_NAME_MeetNGreet_Greet = L["Greet"]
