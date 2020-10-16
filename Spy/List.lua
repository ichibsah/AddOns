local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Spy")
local _

function Spy:RefreshCurrentList(player, source)
	local MainWindow = Spy.MainWindow
	if not MainWindow:IsShown() then
		return
	end

	local mode = Spy.db.profile.CurrentList
	local manageFunction = Spy.ListTypes[mode][2]
	if manageFunction then
		manageFunction()
	end

	local button = 1
	for index, data in pairs(Spy.CurrentList) do
		if button <= Spy.ButtonLimit then
			local description = ""
			local level = "??"
			local class = "UNKNOWN"
			local guild = "??"
			local opacity = 1

			local playerData = SpyPerCharDB.PlayerData[data.player]
			if playerData then
				if playerData.level then
					level = playerData.level
					if playerData.isGuess == true and tonumber(playerData.level) < Spy.MaximumPlayerLevel then
						level = level.."+"
					end
				end
				if playerData.class then
					class = playerData.class
				end
				if playerData.guild then
					guild = playerData.guild
				end
			end
			
			if Spy.db.profile.DisplayListData == "NameLevelClass" then
				description = level.." "
				if L[class] and type(L[class]) == "string" then
					description = description..L[class]
				end
			elseif Spy.db.profile.DisplayListData == "NameLevelOnly" then
				description = level.." "
			elseif Spy.db.profile.DisplayListData == "NameGuild" then
					description = guild
			end
			
			if mode == 1 and Spy.InactiveList[data.player] then
				opacity = 0.5
			end
			if player == data.player then
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then
						Spy:AnnouncePlayer(player)
					end
				end
			end

			Spy:SetBar(button, data.player, description, 100, "Class", class, nil, opacity)
			Spy.ButtonName[button] = data.player
			button = button + 1
		end
	end
	Spy.ListAmountDisplayed = button - 1

	if Spy.db.profile.ResizeSpy then
		Spy:AutomaticallyResize()
	else
		if not Spy.db.profile.InvertSpy then 		
			if not InCombatLockdown() and Spy.MainWindow:GetHeight()< 34 then
				Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetTop(), Spy.MainWindow:GetWidth(), 34)
			end
		else
			if not InCombatLockdown() and Spy.MainWindow:GetHeight()< 34 then 
				Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetBottom(), Spy.MainWindow:GetWidth(), 34)
			end
		end	
	end
	Spy:ManageBarsDisplayed()
end

function Spy:ManageNearbyList()
	local prioritiseKoS = Spy.db.profile.PrioritiseKoS

	local activeKoS = {}
	local active = {}
	for player in pairs(Spy.ActiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(activeKoS, { player = player, time = position })
			else
				table.insert(active, { player = player, time = position })
			end
		end
	end

	local inactiveKoS = {}
	local inactive = {}
	for player in pairs(Spy.InactiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(inactiveKoS, { player = player, time = position })
			else
				table.insert(inactive, { player = player, time = position })
			end
		end
	end

	table.sort(activeKoS, function(a, b) return a.time < b.time end)
	table.sort(inactiveKoS, function(a, b) return a.time < b.time end)
	table.sort(active, function(a, b) return a.time < b.time end)
	table.sort(inactive, function(a, b) return a.time < b.time end)

	local list = {}
	for player in pairs(activeKoS) do table.insert(list, activeKoS[player]) end
	for player in pairs(inactiveKoS) do table.insert(list, inactiveKoS[player]) end
	for player in pairs(active) do table.insert(list, active[player]) end
	for player in pairs(inactive) do table.insert(list, inactive[player]) end
	Spy.CurrentList = list
end

function Spy:ManageLastHourList()
	local list = {}
	for player in pairs(Spy.LastHourList) do
		table.insert(list, { player = player, time = Spy.LastHourList[player] })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageIgnoreList()
	local list = {}
	for player in pairs(SpyPerCharDB.IgnoreData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageKillOnSightList()
	local list = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:GetNearbyListSize()
	local entries = 0
	for v in pairs(Spy.NearbyList) do
		entries = entries + 1
	end
	return entries
end

function Spy:UpdateActiveCount()
    local activeCount = 0
    for k in pairs(Spy.ActiveList) do
        activeCount = activeCount + 1
    end
	local theFrame = Spy.MainWindow
    if activeCount > 0 then 
		theFrame.CountFrame.Text:SetText("|cFF0070DE" .. activeCount .. "|r") 
    else 
        theFrame.CountFrame.Text:SetText("|cFF0070DE0|r")
    end
end

function Spy:ManageExpirations()
	local mode = Spy.db.profile.CurrentList
	local expirationFunction = Spy.ListTypes[mode][3]
	if expirationFunction then
		expirationFunction()
	end
end

function Spy:ManageNearbyListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.ActiveList) do
		if (currentTime - Spy.ActiveList[player]) > Spy.ActiveTimeout then
			Spy.InactiveList[player] = Spy.ActiveList[player]
			Spy.ActiveList[player] = nil
			expired = true
		end
	end
	if Spy.db.profile.RemoveUndetected ~= "Never" then
		for player in pairs(Spy.InactiveList) do
			if (currentTime - Spy.InactiveList[player]) > Spy.InactiveTimeout then
				if Spy.PlayerCommList[player] ~= nil then
					Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
					Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
					HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
					Spy.PlayerCommList[player] = nil
				end
				Spy.InactiveList[player] = nil
				Spy.NearbyList[player] = nil
				expired = true
			end
		end
	end
	if expired then
		Spy:RefreshCurrentList()
		Spy:UpdateActiveCount()
		if Spy.db.profile.HideSpy and Spy:GetNearbyListSize() == 0 then 
			if not InCombatLockdown() then
				Spy.MainWindow:Hide()
			else	
				Spy:HideSpyCombatCheck()
			end
		end
	end
end

function Spy:ManageLastHourListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.LastHourList) do
		if (currentTime - Spy.LastHourList[player]) > 3600 then
			Spy.LastHourList[player] = nil
			expired = true
		end
	end
	if expired then
		Spy:RefreshCurrentList()
	end
end

function Spy:RemovePlayerFromList(player)
	Spy.NearbyList[player] = nil
	Spy.ActiveList[player] = nil
	Spy.InactiveList[player] = nil
	if Spy.PlayerCommList[player] ~= nil then
		Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
		Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
		HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
		Spy.PlayerCommList[player] = nil
	end
	Spy:RefreshCurrentList()
	Spy:UpdateActiveCount()	
end

function Spy:ClearList()
	if IsShiftKeyDown () then
		Spy:EnableSound(not Spy.db.profile.EnableSound, false)		
	else	
		Spy.NearbyList = {}
		Spy.ActiveList = {}
		Spy.InactiveList = {}
		Spy.PlayerCommList = {}
		Spy.ListAmountDisplayed = 0
		for i = 1, Spy.MapNoteLimit do
			Spy.MapNoteList[i].displayed = false
			Spy.MapNoteList[i].worldIcon:Hide()
			HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[i].miniIcon)
		end
		Spy:SetCurrentList(1)
		if IsControlKeyDown() then
			Spy:EnableSpy(not Spy.db.profile.Enabled, false)
		end
		Spy:UpdateActiveCount()
	end	
end

function Spy:AddPlayerData(name, class, level, race, guild, isEnemy, isGuess)
	local info = {}
	info.name = name  --++ added to normalize data
	info.class = class
	if type(level) == "number" then info.level = level end
	info.race = race
	info.guild = guild
	info.isEnemy = isEnemy
	info.isGuess = isGuess
	SpyPerCharDB.PlayerData[name] = info
	return SpyPerCharDB.PlayerData[name]
end

function Spy:UpdatePlayerData(name, class, level, race, guild, isEnemy, isGuess)
	local detected = true
	local playerData = SpyPerCharDB.PlayerData[name]
	if not playerData then
		playerData = Spy:AddPlayerData(name, class, level, race, guild, isEnemy, isGuess)
	else
		if name ~= nil then playerData.name = name end  
		if class ~= nil then playerData.class = class end
		if type(level) == "number" then playerData.level = level end
		if race ~= nil then playerData.race = race end
		if guild ~= nil then playerData.guild = guild end
		if isEnemy ~= nil then playerData.isEnemy = isEnemy end
		if isGuess ~= nil then playerData.isGuess = isGuess end
	end
	if playerData then
		playerData.time = time()
		if not Spy.ActiveList[name] then
			if (WorldMapFrame:IsVisible() and Spy.db.profile.SwitchToZone) then
				WorldMapFrame:SetMapID(C_Map.GetBestMapForUnit("player"))
			end
			if (nil == C_Map.GetBestMapForUnit("player")) or (nil == C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player")) then
				local x,y = 0,0
				local InsName = GetInstanceInfo()
				playerData.zone = InsName
				playerData.subZone = ""
			else
				local mapX, mapY = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()			
				if mapX ~= 0 and mapY ~= 0 then
					mapX = math.floor(tonumber(mapX) * 100) / 100
					mapY = math.floor(tonumber(mapY) * 100) / 100
					playerData.mapX = mapX
					playerData.mapY = mapY
					playerData.zone = GetZoneText()
					playerData.mapID = C_Map.GetBestMapForUnit("player") --++8.0
					playerData.subZone = GetSubZoneText()
				else
					detected = false
				end
			end
		end	
	end
	return detected
end

function Spy:UpdatePlayerStatus(name, class, level, race, guild, isEnemy, isGuess)
	local playerData = SpyPerCharDB.PlayerData[name]
	if not playerData then
		playerData = Spy:AddPlayerData(name, class, level, race, guild, isEnemy, isGuess)
	else
		if name ~= nil then playerData.name = name end  
		if class ~= nil then playerData.class = class end
		if type(level) == "number" then playerData.level = level end
		if race ~= nil then playerData.race = race end
		if guild ~= nil then playerData.guild = guild end
		if isEnemy ~= nil then playerData.isEnemy = isEnemy end
		if isGuess ~= nil then playerData.isGuess = isGuess end
	end
	if playerData.time == nil then
		playerData.time = time()
	end	
end

function Spy:RemovePlayerData(name)
	SpyPerCharDB.PlayerData[name] = nil
end

function Spy:AddIgnoreData(name)
	SpyPerCharDB.IgnoreData[name] = true
end

function Spy:RemoveIgnoreData(name)
	if SpyPerCharDB.IgnoreData[name] then
		SpyPerCharDB.IgnoreData[name] = nil
	end
end

function Spy:AddKOSData(name)
	SpyPerCharDB.KOSData[name] = time()
--	SpyPerCharDB.PlayerData[name].kos = 1 
	if Spy.db.profile.ShareKOSBetweenCharacters then
		SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = nil
	end
end

function Spy:RemoveKOSData(name)
	if SpyPerCharDB.KOSData[name] then
		local playerData = SpyPerCharDB.PlayerData[name]
		if playerData and playerData.reason then
			playerData.reason = nil
		end
		SpyPerCharDB.KOSData[name] = nil
		if SpyPerCharDB.PlayerData[name] then
			SpyPerCharDB.PlayerData[name].kos = nil
		end
		if Spy.db.profile.ShareKOSBetweenCharacters then
			SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = time()
		end
	end
end

function Spy:SetKOSReason(name, reason, other)
	local playerData = SpyPerCharDB.PlayerData[name]
	if playerData then
		if not reason then
			playerData.reason = nil
		else
			if not playerData.reason then playerData.reason = {} end
			if reason == L["KOSReasonOther"] then
				if not other then 
					local dialog = StaticPopup_Show("Spy_SetKOSReasonOther", name)
					if dialog then
						dialog.playerName = name
					end
				else
					if other == "" then
						playerData.reason[L["KOSReasonOther"]] = nil
					else
						playerData.reason[L["KOSReasonOther"]] = other
					end
					Spy:RegenerateKOSCentralList(name)
				end
			else
				if playerData.reason[reason] then
					playerData.reason[reason] = nil
				else
					playerData.reason[reason] = true
				end
				Spy:RegenerateKOSCentralList(name)
			end
		end
	end
end

function Spy:AlertPlayer(player, source)
	local playerData = SpyPerCharDB.PlayerData[player]
	if SpyPerCharDB.KOSData[player] and Spy.db.profile.WarnOnKOS then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["KOSWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			if source ~= nil and source ~= Spy.CharacterName then
				Spy:ShowAlert("kosaway", player, source, Spy:GetPlayerLocation(playerData))
			else
				local reasonText = ""
				if playerData.reason then
					for reason in pairs(playerData.reason) do
						if reasonText ~= "" then reasonText = reasonText..", " end
						if reason == L["KOSReasonOther"] then
							reasonText = reasonText..playerData.reason[reason]
						else
							reasonText = reasonText..reason
						end
					end
				end
				Spy:ShowAlert("kos", player, nil, reasonText)
			end
		end
		if Spy.db.profile.EnableSound then
			if source ~= nil and source ~= Spy.CharacterName then
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3", Spy.db.profile.SoundChannel)
			else
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kos.mp3", Spy.db.profile.SoundChannel)
			end
		end
		if Spy.db.profile.ShareKOSBetweenCharacters then Spy:RegenerateKOSCentralList(player) end
	elseif Spy.db.profile.WarnOnKOSGuild then
		if playerData and playerData.guild and Spy.KOSGuild[playerData.guild] then
--			if Spy.db.profile.DisplayWarningsInErrorsFrame then
			if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
				local text = Spy.db.profile.Colors.Warning["Warning Text"]
				local msg = L["KOSGuildWarning"].."<"..playerData.guild..">"
				UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)				
			else
				if source ~= nil and source ~= Spy.CharacterName then
					Spy:ShowAlert("kosguildaway", "<"..playerData.guild..">", source, Spy:GetPlayerLocation(playerData))
				else
					Spy:ShowAlert("kosguild", "<"..playerData.guild..">")
				end
			end
			if Spy.db.profile.EnableSound then
				if source ~= nil and source ~= Spy.CharacterName then
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3", Spy.db.profile.SoundChannel)
				else
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosguild.mp3", Spy.db.profile.SoundChannel)
				end
			end
		else
			if Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 
				if source == nil or source == Spy.CharacterName then
					if playerData and Spy.db.profile.WarnOnRace and playerData.race == Spy.db.profile.SelectWarnRace then --++
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-race.mp3", Spy.db.profile.SoundChannel) 
					else
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
					end
				end
			end
		end 
	elseif Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 
		if source == nil or source == Spy.CharacterName then
			if playerData and Spy.db.profile.WarnOnRace and playerData.race == Spy.db.profile.SelectWarnRace then
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-race.mp3", Spy.db.profile.SoundChannel) 
			else
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
			end
		end
	elseif Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then
		if source == nil or source == Spy.CharacterName then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AlertStealthPlayer(player)
	if Spy.db.profile.WarnOnStealth then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			Spy:ShowAlert("stealth", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AlertProwlPlayer(player)
	if Spy.db.profile.WarnOnStealth then
--		if Spy.db.profile.DisplayWarningsInErrorsFrame then
		if Spy.db.profile.DisplayWarnings == "ErrorFrame" then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			Spy:ShowAlert("prowl", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3", Spy.db.profile.SoundChannel)
		end
	end
end

function Spy:AnnouncePlayer(player, channel)
	if not Spy_IgnoreList[player] then
		local msg = ""
		local isKOS = SpyPerCharDB.KOSData[player]
		local playerData = SpyPerCharDB.PlayerData[player]

		local announce = Spy.db.profile.Announce  
		if channel or announce == "Self" or announce == "LocalDefense" or (announce == "Guild" and GetGuildInfo("player") ~= nil and not Spy.InInstance) or (announce == "Party" and GetNumGroupMembers() > 0) or (announce == "Raid" and UnitInRaid("player")) then --++
			if announce == "Self" and not channel then
				if isKOS then
					msg = msg..L["SpySignatureColored"]..L["KillOnSightDetectedColored"]..player.." "
				else
					msg = msg..L["SpySignatureColored"]..L["PlayerDetectedColored"]..player.." "
				end
			else
				if isKOS then
					msg = msg..L["KillOnSightDetected"]..player.." "
				else
					msg = msg..L["PlayerDetected"]..player.." "
				end
			end
			if playerData then
				if playerData.guild and playerData.guild ~= "" then
					msg = msg.."<"..playerData.guild.."> "
				end
				if playerData.level or playerData.race or (playerData.class and playerData.class ~= "") then
					msg = msg.."- "
					if playerData.level and playerData.isGuess == false then
						msg = msg..L["Level"].." "..playerData.level.." "
					end
					if playerData.race and playerData.race ~= "" then
						msg = msg..playerData.race.." "
					end
					if playerData.class and playerData.class ~= "" then
						msg = msg..L[playerData.class].." "
					end
				end
				if playerData.zone then
					if playerData.subZone and playerData.subZone ~= "" and playerData.subZone ~= playerData.zone then
						msg = msg.."- "..playerData.subZone..", "..playerData.zone
					else
						msg = msg.."- "..playerData.zone
					end
				end
				if playerData.mapX and playerData.mapY then
					msg = msg.." ("..math.floor(tonumber(playerData.mapX) * 100)..","..math.floor(tonumber(playerData.mapY) * 100)..")"
				end
			end

			if channel then
				-- announce to selected channel
				if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then
					SendChatMessage(msg, channel)
				elseif channel == "LOCAL" then
					SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
				end
			else
				-- announce to standard channel
				if isKOS or not Spy.db.profile.OnlyAnnounceKoS then
					if announce == "Self" then
						DEFAULT_CHAT_FRAME:AddMessage(msg)
					elseif announce == "LocalDefense" then
						SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
					else
						SendChatMessage(msg, strupper(announce))
					end
				end
			end
		end

		-- announce to other Spy users
		if Spy.db.profile.ShareData then
			local class, level, race, zone, subZone, mapX, mapY, guild, mapID = "", "", "", "", "", "", "", "", ""
			if playerData then
				if playerData.class then class = playerData.class end
				if playerData.level and playerData.isGuess == false then level = playerData.level end
				if playerData.race then race = playerData.race end
				if playerData.zone then zone = playerData.zone end
				if playerData.mapID then mapID = playerData.mapID end
				if playerData.subZone then subZone = playerData.subZone end
				if playerData.mapX then mapX = playerData.mapX end
				if playerData.mapY then mapY = playerData.mapY end
				if playerData.guild then guild = playerData.guild end
			end
			local details = Spy.Version.."|"..player.."|"..class.."|"..level.."|"..race.."|"..zone.."|"..subZone.."|"..mapX.."|"..mapY.."|"..guild.."|"..mapID
			if strlen(details) < 240 then
				if channel then
					if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then
						Spy:SendCommMessage(Spy.Signature, details, channel)
					end
				else
					if GetNumGroupMembers() > 0 then
						Spy:SendCommMessage(Spy.Signature, details, "PARTY")
					end
					if UnitInRaid("player") then
						Spy:SendCommMessage(Spy.Signature, details, "RAID")
					end
					if Spy.InInstance == false and GetGuildInfo("player") ~= nil then
						Spy:SendCommMessage(Spy.Signature, details, "GUILD")
					end
				end
			end
		end
	end	
end

function Spy:SendKoStoGuild(player)
	local playerData = SpyPerCharDB.PlayerData[player]
	local class, level, race, zone, subZone, mapX, mapY, guild, mapID = "", "", "", "", "", "", "", "", ""	 			
	if playerData then
		if playerData.class then class = playerData.class end
		if playerData.level and playerData.isGuess == false then level = playerData.level end
		if playerData.race then race = playerData.race end
		if playerData.zone then zone = playerData.zone end
		if playerData.mapID then mapID = playerData.mapID end					
		if playerData.subZone then subZone = playerData.subZone end
		if playerData.mapX then mapX = playerData.mapX end
		if playerData.mapY then mapY = playerData.mapY end
		if playerData.guild then guild = playerData.guild end
	end
	local details = Spy.Version.."|"..player.."|"..class.."|"..level.."|"..race.."|"..zone.."|"..subZone.."|"..mapX.."|"..mapY.."|"..guild.."|"..mapID	
	if strlen(details) < 240 then
		if Spy.InInstance == false and GetGuildInfo("player") ~= nil then
			Spy:SendCommMessage(Spy.Signature, details, "GUILD")
		end
	end
end

function Spy:ToggleIgnorePlayer(ignore, player)
	if ignore then
		Spy:AddIgnoreData(player)
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToIgnoreColored"]..player)
	else
		Spy:RemoveIgnoreData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromIgnoreColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then
		Spy:RegenerateKOSCentralList()
	end
	Spy:RefreshCurrentList()
end

function Spy:ToggleKOSPlayer(kos, player)
	if kos then
		Spy:AddKOSData(player)
		Spy:RemoveIgnoreData(player)
		if player ~= SpyPerCharDB.PlayerData[name] then
--			Spy:UpdatePlayerData(player, nil, nil, nil, nil, true, nil)
			Spy:UpdatePlayerStatus(player, nil, nil, nil, nil, true, nil)
			SpyPerCharDB.PlayerData[player].kos = 1 
		end	
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToKOSColored"]..player)
	else
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3", Spy.db.profile.SoundChannel)
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromKOSColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then
		Spy:RegenerateKOSCentralList()
	end
	Spy:RefreshCurrentList()
end

function Spy:PurgeUndetectedData()
	local secondsPerDay = 60 * 60 * 24
	local timeout = 90 * secondsPerDay
	if Spy.db.profile.PurgeData == "OneDay" then
		timeout = secondsPerDay
	elseif Spy.db.profile.PurgeData == "FiveDays" then
		timeout = 5 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "TenDays" then
		timeout = 10 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "ThirtyDays" then
		timeout = 30 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "SixtyDays" then
		timeout = 60 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "NinetyDays" then
		timeout = 90 * secondsPerDay
	end

	-- remove expired players held in character data
	local currentTime = time()
	for player in pairs(SpyPerCharDB.PlayerData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if Spy.db.profile.PurgeWinLossData then
			if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
				Spy:RemoveIgnoreData(player)
				Spy:RemoveKOSData(player)
				SpyPerCharDB.PlayerData[player] = nil
			end
		else
			if ((playerData.loses == nil) and (playerData.wins == nil)) then
				if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
					Spy:RemoveIgnoreData(player)
					if Spy.db.profile.PurgeKoS then
						Spy:RemoveKOSData(player)
						SpyPerCharDB.PlayerData[player] = nil
					else
						if (playerData.kos == nil) then
							SpyPerCharDB.PlayerData[player] = nil
						end	
					end	
				end
			end
		end
	end
	
	-- remove expired kos players held in central data
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		local characterKosData = kosData[characterName]
		for player in pairs(characterKosData) do
			local kosPlayerData = characterKosData[player]
			if Spy.db.profile.PurgeKoS then
				if not kosPlayerData.time or (currentTime - kosPlayerData.time) > timeout or not kosPlayerData.isEnemy then
					SpyDB.kosData[Spy.RealmName][Spy.FactionName][characterName][player] = nil
					SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] = nil
				end
			end
		end
	end
	if not Spy.db.profile.AppendUnitNameCheck then 	
		Spy:AppendUnitNames() end
	if not Spy.db.profile.AppendUnitKoSCheck then
		Spy:AppendUnitKoS() end
end

function Spy:RegenerateKOSGuildList()
	Spy.KOSGuild = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if playerData and playerData.guild then
			Spy.KOSGuild[playerData.guild] = true
		end
	end
end

function Spy:RemoveLocalKOSPlayers()
	for player in pairs(SpyPerCharDB.KOSData) do
		if SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
			Spy:RemoveKOSData(player)
		end
	end
end

function Spy:RegenerateKOSCentralList(player)
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
		if playerData then
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData
		end
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
	else
		for player in pairs(SpyPerCharDB.KOSData) do
			local playerData = SpyPerCharDB.PlayerData[player]
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
			if playerData then
				SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData
			end
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
		end
	end
end

function Spy:RegenerateKOSListFromCentral()
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		if characterName ~= Spy.CharacterName then
			local characterKosData = kosData[characterName]
			for player in pairs(characterKosData) do
				if not SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
					local playerData = SpyPerCharDB.PlayerData[player]
					if not playerData then
						playerData = Spy:AddPlayerData(player, class, level, race, guild, isEnemy, isGuess)
					end
					local kosPlayerData = characterKosData[player]
					if kosPlayerData.time and (not playerData.time or (playerData.time and playerData.time < kosPlayerData.time)) then
						playerData.time = kosPlayerData.time
						if kosPlayerData.class then
							playerData.class = kosPlayerData.class
						end
						if type(kosPlayerData.level) == "number" and (type(playerData.level) ~= "number" or playerData.level < kosPlayerData.level) then
							playerData.level = kosPlayerData.level
						end
						if kosPlayerData.race then
							playerData.race = kosPlayerData.race
						end
						if kosPlayerData.guild then
							playerData.guild = kosPlayerData.guild
						end
						if kosPlayerData.isEnemy then
							playerData.isEnemy = kosPlayerData.isEnemy
						end
						if kosPlayerData.isGuess then
							playerData.isGuess = kosPlayerData.isGuess
						end
						if type(kosPlayerData.wins) == "number" and (type(playerData.wins) ~= "number" or playerData.wins < kosPlayerData.wins) then
							playerData.wins = kosPlayerData.wins
						end
						if type(kosPlayerData.loses) == "number" and (type(playerData.loses) ~= "number" or playerData.loses < kosPlayerData.loses) then
							playerData.loses = kosPlayerData.loses
						end
						if kosPlayerData.mapX then
							playerData.mapX = kosPlayerData.mapX
						end
						if kosPlayerData.mapY then
							playerData.mapY = kosPlayerData.mapY
						end
						if kosPlayerData.zone then
							playerData.zone = kosPlayerData.zone
						end
						if kosPlayerData.mapID then
							playerData.mapID = kosPlayerData.mapID
						end
						if kosPlayerData.subZone then
							playerData.subZone = kosPlayerData.subZone
						end
						if kosPlayerData.reason then
							playerData.reason = {}
							for reason in pairs(kosPlayerData.reason) do
								playerData.reason[reason] = kosPlayerData.reason[reason]
							end
						end
					end
					local characterKOSPlayerData = SpyPerCharDB.KOSData[player]
					if kosPlayerData.added and (not characterKOSPlayerData or characterKOSPlayerData < kosPlayerData.added) then
						SpyPerCharDB.KOSData[player] = kosPlayerData.added
					end
				end
			end
		end
	end
end

function Spy:ButtonClicked(self, button)
	local name = Spy.ButtonName[self.id]
	if name and name ~= "" then
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				if SpyPerCharDB.KOSData[name] then
					Spy:ToggleKOSPlayer(false, name)
				else
					Spy:ToggleKOSPlayer(true, name)
				end
			elseif IsControlKeyDown() then
				if SpyPerCharDB.IgnoreData[name] then
					Spy:ToggleIgnorePlayer(false, name)
				else
					Spy:ToggleIgnorePlayer(true, name)
				end
			else
				if not InCombatLockdown() then
					self:SetAttribute("macrotext", "/targetexact "..name)
				end	
			end
		elseif button == "RightButton" then
			Spy:BarDropDownOpen(self)
			CloseDropDownMenus(1)
			ToggleDropDownMenu(1, nil, Spy_BarDropDownMenu)
		end
	end
end

function Spy:ParseMinimapTooltip(tooltip)
	local newTooltip = ""
	local newLine = false
	for text in string.gmatch(tooltip, "[^\n]*") do
		local name = text
		if string.len(text) > 0 then
			if strsub(text, 1, 2) == "|T" then
			name = strtrim(gsub(gsub(text, "|T.-|t", ""), "|r", ""))
			end
			local playerData = SpyPerCharDB.PlayerData[name]
			if not playerData then
				for index, v in pairs(Spy.LastHourList) do
					local realmSeparator = strfind(index, "-")
					if realmSeparator and realmSeparator > 1 and strsub(index, 1, realmSeparator - 1) == strsub(name, 1, realmSeparator - 1) then
						playerData = SpyPerCharDB.PlayerData[index]
						break
					end
				end
			end
			if playerData and playerData.isEnemy then
				local desc = ""
				if playerData.class and playerData.level then
					desc = L["MinimapClassText"..playerData.class].." ["..playerData.level.." "..L[playerData.class].."]|r"
				elseif playerData.class then
					desc = L["MinimapClassText"..playerData.class].." ["..L[playerData.class].."]|r"
				elseif playerData.level then
					desc = " ["..playerData.level.."]|r"
				end
				if (newTooltip and desc == "") then
					newTooltip = text 
				elseif (newTooltip == "") then	
					newTooltip = text.."|r"..desc
				else
					newTooltip = newTooltip.."\r"..text.."|r"..desc
				end	
				if not SpyPerCharDB.IgnoreData[name] and not Spy.InInstance then
					local detected = Spy:UpdatePlayerData(name, nil, nil, nil, nil, true, nil)
					if detected and Spy.db.profile.MinimapDetection then
						Spy:AddDetected(name, time(), false)
					end
				end
			else
				if (newTooltip == "") then
					newTooltip = text
				else	
					newTooltip = newTooltip.."\n"..text
				end
			end
			newLine = false
		elseif not newLine then
			newTooltip = newTooltip
			newLine = true
		end
	end
	return newTooltip
end

function Spy:ParseUnitAbility(analyseSpell, event, player, class, race, spellId, spellName)
	local learnt = false
	if player then
--		local class = nil
		local level = nil
--		local race = nil
		local isEnemy = true
		local isGuess = true

		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData or playerData.isEnemy == nil then
			learnt = true
		end

		if analyseSpell then
			local abilityType = strsub(event, 1, 5)
			if abilityType == "SWING" or abilityType == "SPELL" or abilityType == "RANGE" then
--				local ability = Spy_AbilityList[spellName]
				local ability = Spy_AbilityList[spellId]
				if ability then
					if class == nil then
						if ability.class and not (playerData and playerData.class) then
							class = ability.class
							learnt = true
						end
					end
					if ability.level then
						local playerLevelNumber = nil
						if playerData and playerData.level then
							playerLevelNumber = tonumber(playerData.level)
						end
						if type(playerLevelNumber) ~= "number" or playerLevelNumber < ability.level then
							level = ability.level
							learnt = true
						end
					end
					if race == nil then
						if ability.race and not (playerData and playerData.race) then
							race = ability.race
							learnt = true
						end
					end	
				else	
--					print(spellId, " - ", spellName)
				end
				if class and race and level == Spy.MaximumPlayerLevel then
					isGuess = false
					learnt = true
				end
			end
		end

		Spy:UpdatePlayerData(player, class, level, race, nil, isEnemy, isGuess)
		return learnt, playerData
	end
	return learnt, nil
end

function Spy:ParseUnitDetails(player, class, level, race, zone, subZone, mapX, mapY, guild, mapID)
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData then
			playerData = Spy:AddPlayerData(player, class, level, race, guild, true, true)
		else
			if not playerData.class then playerData.class = class end
			if level then
				local levelNumber = tonumber(level)
				if type(levelNumber) == "number" then
					if playerData.level then
						local playerLevelNumber = tonumber(playerData.level)
						if type(playerLevelNumber) == "number" and playerLevelNumber < levelNumber then playerData.level = levelNumber end
					else
						playerData.level = levelNumber
					end
				end
			end
			if not playerData.race then
				playerData.race = race
			end
			if not playerData.guild then
				playerData.guild = guild
			end
		end
		playerData.isEnemy = true
		playerData.time = time()
		playerData.zone = zone
		playerData.mapID = mapID
		playerData.subZone = subZone
		playerData.mapX = mapX
		playerData.mapY = mapY

		return true, playerData
	end
	return true, nil
end

function Spy:AddDetected(player, timestamp, learnt, source)
	if Spy.db.profile.StopAlertsOnTaxi then
		if not UnitOnTaxi("player") then 
			Spy:AddDetectedToLists(player, timestamp, learnt, source)
		end
	else
		Spy:AddDetectedToLists(player, timestamp, learnt, source)
	end
--[[if Spy.db.profile.ShowOnlyPvPFlagged then
		if UnitIsPVP("target") then		
			Spy:AddDetectedToLists(player, timestamp, learnt, source)
		end	
	else
		Spy:AddDetectedToLists(player, timestamp, learnt, source)
	end ]]--
end

function Spy:AddDetectedToLists(player, timestamp, learnt, source)
	if not Spy.NearbyList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		if source and source ~= Spy.CharacterName and not Spy.ActiveList[player] then
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.InactiveList[player] = timestamp
		else
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.ActiveList[player] = timestamp
			Spy.InactiveList[player] = nil
		end

		if Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList(player, source)
			Spy:UpdateActiveCount()			
		else
			if not source or source ~= Spy.CharacterName then
				Spy:AlertPlayer(player, source)
				if not source then Spy:AnnouncePlayer(player) end
			end
		end
	elseif not Spy.ActiveList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		Spy.LastHourList[player] = timestamp
		Spy.ActiveList[player] = timestamp
		Spy.InactiveList[player] = nil

		if Spy.PlayerCommList[player] ~= nil then
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList(player, source)
			else
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then Spy:AnnouncePlayer(player) end
				end
			end
		else
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList()
				Spy:UpdateActiveCount()						
			end
		end
	else
		Spy.ActiveList[player] = timestamp
		Spy.LastHourList[player] = timestamp
		if learnt and Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList()
			Spy:UpdateActiveCount()	
		end
	end
end

function Spy:AppendUnitNames()
	for key, unit in pairs(SpyPerCharDB.PlayerData) do	
		-- find any units without a name
		if not unit.name then			
			local name = key
		-- if unit.name does not exist update info
			if (not unit.name) and name then
				unit.name = key
			end		
		end
    end
	-- set profile so it only runs once
	Spy.db.profile.AppendUnitNameCheck=true
end

function Spy:AppendUnitKoS()
	for kosName, value in pairs(SpyPerCharDB.KOSData) do	
		if kosName then	
			local playerData = SpyPerCharDB.PlayerData[kosName]
			if not playerData then 
				Spy:UpdatePlayerData(kosName, nil, nil, nil, nil, true, nil) 
				SpyPerCharDB.PlayerData[kosName].kos = 1 
				SpyPerCharDB.PlayerData[kosName].time = value			
			end		
		end
    end
	-- set profile so it only runs once
	Spy.db.profile.AppendUnitKoSCheck=true
end

Spy.ListTypes = {
	{L["Nearby"], Spy.ManageNearbyList, Spy.ManageNearbyListExpirations},
	{L["LastHour"], Spy.ManageLastHourList, Spy.ManageLastHourListExpirations},
	{L["Ignore"], Spy.ManageIgnoreList},
	{L["KillOnSight"], Spy.ManageKillOnSightList},
}

Spy_AbilityList = {
--++ Racial Traits ++	
	[68976]={ race = "Worgen", level = 1, },
	[317795]={ race = "Vulpera", level = 1, },
	[94293]={ race = "Worgen", level = 1, },
	[274738]={ race = "Mag'har Orc", level = 1, },
	[255663]={ race = "Nightborne", level = 1, },
	[154742]={ race = "Blood Elf", level = 1, },
	[28877]={ race = "Blood Elf", level = 1, },
	[260364]={ race = "Nightborne", level = 1, },
	[20592]={ race = "Gnome", level = 1, },
	[822]={ race = "Blood Elf", level = 1, },
	[255664]={ race = "Nightborne", level = 1, },
	[28730]={ race = "Blood Elf", level = 1, },
	[155145]={ race = "Blood Elf", level = 1, },
	[25046]={ race = "Blood Elf", level = 1, },
	[69179]={ race = "Blood Elf", level = 1, },
	[50613]={ race = "Blood Elf", level = 1, },
	[202719]={ race = "Blood Elf", level = 1, },
	[232633]={ race = "Blood Elf", level = 1, },
	[80483]={ race = "Blood Elf", level = 1, },
	[129597]={ race = "Blood Elf", level = 1, },
	[312411]={ race = "Vulpera", level = 1, },
	[20557]={ race = "Troll", level = 1, },
	[26297]={ race = "Troll", level = 1, },
	[69044]={ race = "Goblin", level = 1, },
	[69045]={ race = "Goblin", level = 1, },
	[20572]={ race = "Orc", level = 1, },
	[33697]={ race = "Orc", level = 1, },
	[33702]={ race = "Orc", level = 1, },
	[107076]={ race = "Pandaren", level = 1, },
	[154743]={ race = "Tauren", level = 1, },
	[291628]={ race = "Kul Tiran", level = 1, },
	[255654]={ race = "Highmountain Tauren", level = 1, },
	[20577]={ race = "Undead", level = 1, },
	[255661]={ race = "Nightborne", level = 1, },
	[291622]={ race = "Kul Tiran", level = 1, },
	[255668]={ race = "Void Elf", level = 1, },
	[291619]={ race = "Zandalari Troll", level = 1, },
	[312923]={ race = "Mechgnome", level = 1, },
	[20552]={ race = "Tauren", level = 1, },
	[58943]={ race = "Troll", level = 1, },
	[68992]={ race = "Worgen", level = 1, },
	[255653]={ race = "Lightforged Draenei", level = 1, },
	[20599]={ race = "Human", level = 1, },
	[265223]={ race = "Dark Iron Dwarf", level = 1, },
	[292752]={ race = "Zandalari Troll", level = 1, },
	[292751]={ race = "Zandalari Troll", level = 1, },
	[312916]={ race = "Mechgnome", level = 1, },
	[20550]={ race = "Tauren", level = 1, },
	[20593]={ race = "Gnome", level = 1, },
	[255669]={ race = "Void Elf", level = 1, },
	[107072]={ race = "Pandaren", level = 1, },
	[20589]={ race = "Gnome", level = 1, },
	[255667]={ race = "Void Elf", level = 1, },
	[20591]={ race = "Gnome", level = 1, },
	[154746]={ race = "Gnome", level = 1, },
	[227057]={ race = "Gnome", level = 1, },
	[154747]={ race = "Gnome", level = 1, },
	[154744]={ race = "Gnome", level = 1, },
	[92682]={ race = "Dwarf", level = 1, },
	[312198]={ race = "Vulpera", level = 1, },
	[265221]={ race = "Dark Iron Dwarf", level = 1, },
	[68978]={ race = "Worgen", level = 1, },
	[259930]={ race = "Lightforged Draenei", level = 1, },
	[255650]={ race = "Lightforged Draenei", level = 1, },
	[265224]={ race = "Dark Iron Dwarf", level = 1, },
	[20596]={ race = "Dwarf", level = 1, },
	[28875]={ race = "Draenei", level = 1, },
	[28880]={ race = "Draenei", level = 1, },
	[121093]={ race = "Draenei", level = 1, },
	[59542]={ race = "Draenei", level = 1, },
	[59547]={ race = "Draenei", level = 1, },
	[59545]={ race = "Draenei", level = 1, },
	[59548]={ race = "Draenei", level = 1, },
	[59544]={ race = "Draenei", level = 1, },
	[59543]={ race = "Draenei", level = 1, },
	[107073]={ race = "Pandaren", level = 1, },
	[20573]={ race = "Orc", level = 1, },
	[287712]={ race = "Kul Tiran", level = 1, },
	[6562]={ race = "Draenei", level = 1, },
	[255651]={ race = "Lightforged Draenei", level = 1, },
	[312924]={ race = "Mechgnome", level = 1, },
	[107074]={ race = "Pandaren", level = 1, },
	[291442]={ race = "Kul Tiran", level = 1, },
	[131701]={ race = "Pandaren", level = 1, },
	[262438]={ race = "Nightborne", level = 1, },
	[262486]={ race = "Void Elf", level = 1, },
	[273105]={ race = "Dark Iron Dwarf", level = 1, },
	[292489]={ race = "Zandalari Troll", level = 1, },
	[274743]={ race = "Mag'har Orc", level = 1, },
	[292495]={ race = "Kul Tiran", level = 1, },
	[312769]={ race = "Vulpera", level = 1, },
	[312766]={ race = "Mechgnome", level = 1, },
	[255647]={ race = "Lightforged Draenei", level = 1, },
	[255652]={ race = "Lightforged Draenei", level = 1, },
	[255665]={ race = "Nightborne", level = 1, },
	[312370]={ race = "Vulpera", level = 1, },
	[265222]={ race = "Dark Iron Dwarf", level = 1, },
	[312896]={ race = "Mechgnome", level = 1, },
	[59224]={ race = "Dwarf", level = 1, },
	[265225]={ race = "Dark Iron Dwarf", level = 1, },
	[255658]={ race = "Highmountain Tauren", level = 1, },
	[20583]={ race = "Night Elf", level = 1, },
	[20551]={ race = "Tauren", level = 1, },
	[92680]={ race = "Gnome", level = 1, },
	[312215]={ race = "Vulpera", level = 1, },
	[273216]={ race = "Mag'har Orc", level = 1, },
	[69046]={ race = "Goblin", level = 1, },
	[255670]={ race = "Void Elf", level = 1, },
	[255655]={ race = "Highmountain Tauren", level = 1, },
	[281954]={ race = "Zandalari Troll", level = 1, },
	[107079]={ race = "Pandaren", level = 1, },
	[20582]={ race = "Night Elf", level = 1, },
	[291944]={ race = "Zandalari Troll", level = 1, },
	[20555]={ race = "Troll", level = 1, },
	[312372]={ race = "Vulpera", level = 1, },
	[291417]={ race = "Kul Tiran", level = 1, },
	[69041]={ race = "Goblin", level = 1, },
	[69070]={ race = "Goblin", level = 1, },
	[255659]={ race = "Highmountain Tauren", level = 1, },
	[312425]={ race = "Vulpera", level = 1, },
	[87840]={ race = "Worgen", level = 1, },
	[273220]={ race = "Mag'har Orc", level = 1, },
	[20579]={ race = "Undead", level = 1, },
	[59221]={ race = "Draenei", level = 1, },
	[58984]={ race = "Night Elf", level = 1, },
	[312890]={ race = "Mechgnome", level = 1, },
	[256948]={ race = "Void Elf", level = 1, },
	[20594]={ race = "Dwarf", level = 1, },
	[273217]={ race = "Mag'har Orc", level = 1, },
	[20598]={ race = "Human", level = 1, },
	[69042]={ race = "Goblin", level = 1, },
	[154748]={ race = "Night Elf", level = 1, },
	[5227]={ race = "Undead", level = 1, },
	[68996]={ race = "Worgen", level = 1, },
	[68975]={ race = "Worgen", level = 1, },
	[20549]={ race = "Tauren", level = 1, },
	[255656]={ race = "Highmountain Tauren", level = 1, },
	[7744]={ race = "Undead", level = 1, },
	[59752]={ race = "Human", level = 1, },
	[20585]={ race = "Night Elf", level = 1, },
	
--++ Death Knight Abliities ++	
	[205224]={ class = "DEATHKNIGHT", level = 8, },
	[137005]={ class = "DEATHKNIGHT", level = 8, },
	[190780]={ class = "DEATHKNIGHT", level = 8, },
	[55095]={ class = "DEATHKNIGHT", level = 8, },
	[82246]={ class = "DEATHKNIGHT", level = 8, },
	[278107]={ class = "DEATHKNIGHT", level = 8, },
	[319278]={ class = "DEATHKNIGHT", level = 8, },
	[316239]={ class = "DEATHKNIGHT", level = 8, },
	[47541]={ class = "DEATHKNIGHT", level = 8, },
	[43265]={ class = "DEATHKNIGHT", level = 8, },
	[49998]={ class = "DEATHKNIGHT", level = 8, },
	[49576]={ class = "DEATHKNIGHT", level = 8, },
	[53428]={ class = "DEATHKNIGHT", level = 8, },
	[47528]={ class = "DEATHKNIGHT", level = 8, },
	[53343]={ class = "DEATHKNIGHT", level = 8, },
	[53344]={ class = "DEATHKNIGHT", level = 8, },
	[62158]={ class = "DEATHKNIGHT", level = 8, },
	[48263]={ class = "DEATHKNIGHT", level = 8, },
	[48707]={ class = "DEATHKNIGHT", level = 9, },
	[50977]={ class = "DEATHKNIGHT", level = 10, },
	[46585]={ class = "DEATHKNIGHT", level = 12, },
	[45524]={ class = "DEATHKNIGHT", level = 13, },
	[56222]={ class = "DEATHKNIGHT", level = 14, },
	[127344]={ class = "DEATHKNIGHT", level = 19, },
	[326977]={ class = "DEATHKNIGHT", level = 20, },
	[51986]={ class = "DEATHKNIGHT", level = 22, },
	[55078]={ class = "DEATHKNIGHT", level = 23, },
	[3714]={ class = "DEATHKNIGHT", level = 27, },
	[326805]={ class = "DEATHKNIGHT", level = 32, },
	[49039]={ class = "DEATHKNIGHT", level = 33, },
	[111673]={ class = "DEATHKNIGHT", level = 37, },
	[48792]={ class = "DEATHKNIGHT", level = 38, },
	[61999]={ class = "DEATHKNIGHT", level = 39, },
	[48265]={ class = "DEATHKNIGHT", level = 42, },
	[327082]={ class = "DEATHKNIGHT", level = 44, },
	[326911]={ class = "DEATHKNIGHT", level = 46, },
	[51052]={ class = "DEATHKNIGHT", level = 47, },
	[326855]={ class = "DEATHKNIGHT", level = 48, },
	[343257]={ class = "DEATHKNIGHT", level = 49, },
	[327574]={ class = "DEATHKNIGHT", level = 54, },
--++ Death Knight Specializations ++	
	[137008]={ class = "DEATHKNIGHT", level = 8, },
	[674]={ class = "DEATHKNIGHT", level = 8, },
	[137006]={ class = "DEATHKNIGHT", level = 8, },
	[137007]={ class = "DEATHKNIGHT", level = 8, },
	[197147]={ class = "DEATHKNIGHT", level = 8, },
	[85948]={ class = "DEATHKNIGHT", level = 10, },
	[206930]={ class = "DEATHKNIGHT", level = 10, },
	[49184]={ class = "DEATHKNIGHT", level = 10, },
	[77513]={ class = "DEATHKNIGHT", level = 10, },
	[77515]={ class = "DEATHKNIGHT", level = 10, },
	[77514]={ class = "DEATHKNIGHT", level = 10, },
	[81333]={ class = "DEATHKNIGHT", level = 10, },
	[49143]={ class = "DEATHKNIGHT", level = 11, },
	[195182]={ class = "DEATHKNIGHT", level = 11, },
	[55090]={ class = "DEATHKNIGHT", level = 11, },
	[49020]={ class = "DEATHKNIGHT", level = 14, },
	[50842]={ class = "DEATHKNIGHT", level = 17, },
	[77575]={ class = "DEATHKNIGHT", level = 17, },
	[81136]={ class = "DEATHKNIGHT", level = 18, },
	[178819]={ class = "DEATHKNIGHT", level = 18, },
	[275699]={ class = "DEATHKNIGHT", level = 19, },
	[196770]={ class = "DEATHKNIGHT", level = 19, },
	[194679]={ class = "DEATHKNIGHT", level = 19, },
	[221562]={ class = "DEATHKNIGHT", level = 21, },
	[51462]={ class = "DEATHKNIGHT", level = 21, },
	[81229]={ class = "DEATHKNIGHT", level = 21, },
	[195621]={ class = "DEATHKNIGHT", level = 23, },
	[316575]={ class = "DEATHKNIGHT", level = 23, },
	[51128]={ class = "DEATHKNIGHT", level = 23, },
	[49530]={ class = "DEATHKNIGHT", level = 23, },
	[316634]={ class = "DEATHKNIGHT", level = 24, },
	[316867]={ class = "DEATHKNIGHT", level = 24, },
	[343252]={ class = "DEATHKNIGHT", level = 24, },
	[278223]={ class = "DEATHKNIGHT", level = 28, },
	[195292]={ class = "DEATHKNIGHT", level = 28, },
	[51271]={ class = "DEATHKNIGHT", level = 29, },
	[46584]={ class = "DEATHKNIGHT", level = 29, },
	[161797]={ class = "DEATHKNIGHT", level = 29, },
	[55233]={ class = "DEATHKNIGHT", level = 29, },
	[63560]={ class = "DEATHKNIGHT", level = 32, },
	[108199]={ class = "DEATHKNIGHT", level = 32, },
	[59057]={ class = "DEATHKNIGHT", level = 32, },
	[49028]={ class = "DEATHKNIGHT", level = 34, },
	[207317]={ class = "DEATHKNIGHT", level = 34, },
	[316794]={ class = "DEATHKNIGHT", level = 34, },
	[316941]={ class = "DEATHKNIGHT", level = 41, },
	[316746]={ class = "DEATHKNIGHT", level = 41, },
	[316838]={ class = "DEATHKNIGHT", level = 41, },
	[316664]={ class = "DEATHKNIGHT", level = 43, },
	[316916]={ class = "DEATHKNIGHT", level = 43, },
	[316803]={ class = "DEATHKNIGHT", level = 43, },
	[42650]={ class = "DEATHKNIGHT", level = 44, },
	[279302]={ class = "DEATHKNIGHT", level = 44, },
	[316616]={ class = "DEATHKNIGHT", level = 44, },
	[47568]={ class = "DEATHKNIGHT", level = 48, },
	[316961]={ class = "DEATHKNIGHT", level = 49, },
	[316849]={ class = "DEATHKNIGHT", level = 49, },
	[316714]={ class = "DEATHKNIGHT", level = 49, },
	[325554]={ class = "DEATHKNIGHT", level = 52, },
	[317090]={ class = "DEATHKNIGHT", level = 52, },
	[317198]={ class = "DEATHKNIGHT", level = 52, },
	[317230]={ class = "DEATHKNIGHT", level = 56, },
	[317234]={ class = "DEATHKNIGHT", level = 56, },
	[317133]={ class = "DEATHKNIGHT", level = 56, },
	[343755]={ class = "DEATHKNIGHT", level = 58, },
	[317214]={ class = "DEATHKNIGHT", level = 58, },
	[219786]={ class = "DEATHKNIGHT", level = 58, },
--++ Death Knight Talents ++	
	[194916]={ class = "DEATHKNIGHT", level = 15, },
	[206931]={ class = "DEATHKNIGHT", level = 15, },
	[207311]={ class = "DEATHKNIGHT", level = 15, },
	[281208]={ class = "DEATHKNIGHT", level = 15, },
	[221536]={ class = "DEATHKNIGHT", level = 15, },
	[194878]={ class = "DEATHKNIGHT", level = 15, },
	[253593]={ class = "DEATHKNIGHT", level = 15, },
	[207272]={ class = "DEATHKNIGHT", level = 15, },
	[219809]={ class = "DEATHKNIGHT", level = 15, },
	[207264]={ class = "DEATHKNIGHT", level = 25, },
	[274156]={ class = "DEATHKNIGHT", level = 25, },
	[207269]={ class = "DEATHKNIGHT", level = 25, },
	[273946]={ class = "DEATHKNIGHT", level = 25, },
	[57330]={ class = "DEATHKNIGHT", level = 25, },
	[207061]={ class = "DEATHKNIGHT", level = 25, },
	[194662]={ class = "DEATHKNIGHT", level = 25, },
	[207104]={ class = "DEATHKNIGHT", level = 25, },
	[115989]={ class = "DEATHKNIGHT", level = 25, },
	[108194]={ class = "DEATHKNIGHT", level = 30, },
	[207167]={ class = "DEATHKNIGHT", level = 30, },
	[221699]={ class = "DEATHKNIGHT", level = 30, },
	[276079]={ class = "DEATHKNIGHT", level = 30, },
	[206974]={ class = "DEATHKNIGHT", level = 30, },
	[273952]={ class = "DEATHKNIGHT", level = 30, },
	[317610]={ class = "DEATHKNIGHT", level = 30, },
	[205727]={ class = "DEATHKNIGHT", level = 35, },
	[207142]={ class = "DEATHKNIGHT", level = 35, },
	[207230]={ class = "DEATHKNIGHT", level = 35, },
	[194909]={ class = "DEATHKNIGHT", level = 35, },
	[276023]={ class = "DEATHKNIGHT", level = 35, },
	[206940]={ class = "DEATHKNIGHT", level = 35, },
	[194917]={ class = "DEATHKNIGHT", level = 35, },
	[343294]={ class = "DEATHKNIGHT", level = 35, },
	[206967]={ class = "DEATHKNIGHT", level = 35, },
	[48743]={ class = "DEATHKNIGHT", level = 40, },
	[207200]={ class = "DEATHKNIGHT", level = 40, },
	[207321]={ class = "DEATHKNIGHT", level = 40, },
	[206970]={ class = "DEATHKNIGHT", level = 40, },
	[212552]={ class = "DEATHKNIGHT", level = 40, },
	[195679]={ class = "DEATHKNIGHT", level = 45, },
	[152280]={ class = "DEATHKNIGHT", level = 45, },
	[194912]={ class = "DEATHKNIGHT", level = 45, },
	[194913]={ class = "DEATHKNIGHT", level = 45, },
	[321995]={ class = "DEATHKNIGHT", level = 45, },
	[277234]={ class = "DEATHKNIGHT", level = 45, },
	[319230]={ class = "DEATHKNIGHT", level = 45, },
	[273953]={ class = "DEATHKNIGHT", level = 45, },
	[276837]={ class = "DEATHKNIGHT", level = 50, },
	[194844]={ class = "DEATHKNIGHT", level = 50, },
	[152279]={ class = "DEATHKNIGHT", level = 50, },
	[207126]={ class = "DEATHKNIGHT", level = 50, },
	[281238]={ class = "DEATHKNIGHT", level = 50, },
	[114556]={ class = "DEATHKNIGHT", level = 50, },
	[205723]={ class = "DEATHKNIGHT", level = 50, },
	[49206]={ class = "DEATHKNIGHT", level = 50, },
	[207289]={ class = "DEATHKNIGHT", level = 50, },
--++ Death Knight PvP Talents ++	
	[233411]={ class = "DEATHKNIGHT", level = 20, },
	[201995]={ class = "DEATHKNIGHT", level = 20, },
	[77606]={ class = "DEATHKNIGHT", level = 20, },
	[287250]={ class = "DEATHKNIGHT", level = 20, },
	[203173]={ class = "DEATHKNIGHT", level = 20, },
	[204080]={ class = "DEATHKNIGHT", level = 20, },
	[233396]={ class = "DEATHKNIGHT", level = 20, },
	[288855]={ class = "DEATHKNIGHT", level = 20, },
	[207018]={ class = "DEATHKNIGHT", level = 20, },
	[210128]={ class = "DEATHKNIGHT", level = 20, },
	[202727]={ class = "DEATHKNIGHT", level = 20, },
	[288977]={ class = "DEATHKNIGHT", level = 20, },
	[202731]={ class = "DEATHKNIGHT", level = 20, },
	[288848]={ class = "DEATHKNIGHT", level = 29, },
	[305392]={ class = "DEATHKNIGHT", level = 30, },
	[223829]={ class = "DEATHKNIGHT", level = 30, },
	[47476]={ class = "DEATHKNIGHT", level = 30, },
	[233412]={ class = "DEATHKNIGHT", level = 35, },
	[199642]={ class = "DEATHKNIGHT", level = 35, },
	[199720]={ class = "DEATHKNIGHT", level = 40, },
	[288853]={ class = "DEATHKNIGHT", level = 45, },
	[328718]={ class = "DEATHKNIGHT", level = 48, },
	[199719]={ class = "DEATHKNIGHT", level = 50, },
--++ Demon Hunter Abilities ++	
	[344867]={ class = "DEMONHUNTER", level = 8, },
	[344862]={ class = "DEMONHUNTER", level = 8, },
	[344859]={ class = "DEMONHUNTER", level = 8, },
	[196055]={ class = "DEMONHUNTER", level = 8, },
	[344865]={ class = "DEMONHUNTER", level = 8, },
	[329554]={ class = "DEMONHUNTER", level = 8, },
	[131347]={ class = "DEMONHUNTER", level = 8, },
	[178940]={ class = "DEMONHUNTER", level = 8, },
	[214743]={ class = "DEMONHUNTER", level = 8, },
	[188501]={ class = "DEMONHUNTER", level = 8, },
	[344866]={ class = "DEMONHUNTER", level = 8, },
	[221351]={ class = "DEMONHUNTER", level = 8, },
	[203724]={ class = "DEMONHUNTER", level = 8, },
	[185245]={ class = "DEMONHUNTER", level = 9, },
	[278386]={ class = "DEMONHUNTER", level = 13, },
	[258920]={ class = "DEMONHUNTER", level = 14, },
	[278326]={ class = "DEMONHUNTER", level = 17, },
	[320364]={ class = "DEMONHUNTER", level = 18, },
	[185123]={ class = "DEMONHUNTER", level = 19, },
	[320386]={ class = "DEMONHUNTER", level = 19, },
	[191427]={ class = "DEMONHUNTER", level = 20, },
	[183752]={ class = "DEMONHUNTER", level = 29, },
	[217832]={ class = "DEMONHUNTER", level = 34, },
	[320313]={ class = "DEMONHUNTER", level = 37, },
	[320379]={ class = "DEMONHUNTER", level = 42, },
	[320361]={ class = "DEMONHUNTER", level = 46, },
	[255260]={ class = "DEMONHUNTER", level = 49, },
--++ Demon Hunter Specializations ++	
	[179057]={ class = "DEMONHUNTER", level = 8, },
	[162794]={ class = "DEMONHUNTER", level = 8, },
	[162243]={ class = "DEMONHUNTER", level = 8, },
	[195072]={ class = "DEMONHUNTER", level = 8, },
	[212612]={ class = "DEMONHUNTER", level = 8, },
	[189110]={ class = "DEMONHUNTER", level = 8, },
	[204254]={ class = "DEMONHUNTER", level = 8, },
	[203782]={ class = "DEMONHUNTER", level = 8, },
	[212613]={ class = "DEMONHUNTER", level = 8, },
	[198793]={ class = "DEMONHUNTER", level = 8, },
	[203720]={ class = "DEMONHUNTER", level = 8, },
	[204021]={ class = "DEMONHUNTER", level = 8, },
	[203783]={ class = "DEMONHUNTER", level = 8, },
	[228477]={ class = "DEMONHUNTER", level = 8, },
	[320380]={ class = "DEMONHUNTER", level = 8, },
	[185164]={ class = "DEMONHUNTER", level = 10, },
	[203747]={ class = "DEMONHUNTER", level = 10, },
	[204157]={ class = "DEMONHUNTER", level = 10, },
	[198013]={ class = "DEMONHUNTER", level = 11, },
	[212084]={ class = "DEMONHUNTER", level = 11, },
	[188499]={ class = "DEMONHUNTER", level = 12, },
	[204596]={ class = "DEMONHUNTER", level = 12, },
	[203513]={ class = "DEMONHUNTER", level = 13, },
	[320413]={ class = "DEMONHUNTER", level = 14, },
	[321021]={ class = "DEMONHUNTER", level = 14, },
	[187827]={ class = "DEMONHUNTER", level = 20, },
	[320422]={ class = "DEMONHUNTER", level = 20, },
	[321067]={ class = "DEMONHUNTER", level = 20, },
	[198589]={ class = "DEMONHUNTER", level = 21, },
	[207684]={ class = "DEMONHUNTER", level = 21, },
	[320402]={ class = "DEMONHUNTER", level = 22, },
	[320794]={ class = "DEMONHUNTER", level = 22, },
	[320415]={ class = "DEMONHUNTER", level = 23, },
	[320639]={ class = "DEMONHUNTER", level = 23, },
	[320377]={ class = "DEMONHUNTER", level = 27, },
	[320378]={ class = "DEMONHUNTER", level = 27, },
	[320381]={ class = "DEMONHUNTER", level = 28, },
	[320383]={ class = "DEMONHUNTER", level = 28, },
	[320416]={ class = "DEMONHUNTER", level = 28, },
	[320791]={ class = "DEMONHUNTER", level = 28, },
	[207197]={ class = "DEMONHUNTER", level = 29, },
	[320387]={ class = "DEMONHUNTER", level = 32, },
	[320770]={ class = "DEMONHUNTER", level = 32, },
	[320407]={ class = "DEMONHUNTER", level = 33, },
	[320418]={ class = "DEMONHUNTER", level = 33, },
	[320412]={ class = "DEMONHUNTER", level = 38, },
	[320962]={ class = "DEMONHUNTER", level = 38, },
	[196718]={ class = "DEMONHUNTER", level = 39, },
	[202137]={ class = "DEMONHUNTER", level = 39, },
	[321028]={ class = "DEMONHUNTER", level = 41, },
	[320635]={ class = "DEMONHUNTER", level = 41, },
	[320382]={ class = "DEMONHUNTER", level = 43, },
	[343006]={ class = "DEMONHUNTER", level = 43, },
	[320654]={ class = "DEMONHUNTER", level = 44, },
	[321299]={ class = "DEMONHUNTER", level = 44, },
	[320420]={ class = "DEMONHUNTER", level = 47, },
	[320421]={ class = "DEMONHUNTER", level = 48, },
	[321068]={ class = "DEMONHUNTER", level = 48, },
	[320417]={ class = "DEMONHUNTER", level = 48, },
	[281242]={ class = "DEMONHUNTER", level = 49, },
	[343017]={ class = "DEMONHUNTER", level = 52, },
	[343016]={ class = "DEMONHUNTER", level = 52, },
	[343010]={ class = "DEMONHUNTER", level = 54, },
	[320645]={ class = "DEMONHUNTER", level = 54, },
	[343206]={ class = "DEMONHUNTER", level = 56, },
	[343207]={ class = "DEMONHUNTER", level = 56, },
	[343311]={ class = "DEMONHUNTER", level = 58, },
	[343014]={ class = "DEMONHUNTER", level = 58, },
--++ Demon Hunter Talents ++	
	[207550]={ class = "DEMONHUNTER", level = 15, },
	[207548]={ class = "DEMONHUNTER", level = 15, },
	[203550]={ class = "DEMONHUNTER", level = 15, },
	[206478]={ class = "DEMONHUNTER", level = 15, },
	[232893]={ class = "DEMONHUNTER", level = 15, },
	[207739]={ class = "DEMONHUNTER", level = 25, },
	[320374]={ class = "DEMONHUNTER", level = 25, },
	[203555]={ class = "DEMONHUNTER", level = 25, },
	[227174]={ class = "DEMONHUNTER", level = 25, },
	[207697]={ class = "DEMONHUNTER", level = 25, },
	[258876]={ class = "DEMONHUNTER", level = 25, },
	[336639]={ class = "DEMONHUNTER", level = 30, },
	[342817]={ class = "DEMONHUNTER", level = 30, },
	[320331]={ class = "DEMONHUNTER", level = 30, },
	[247454]={ class = "DEMONHUNTER", level = 30, },
	[258881]={ class = "DEMONHUNTER", level = 30, },
	[275144]={ class = "DEMONHUNTER", level = 30, },
	[205411]={ class = "DEMONHUNTER", level = 35, },
	[218612]={ class = "DEMONHUNTER", level = 35, },
	[263642]={ class = "DEMONHUNTER", level = 35, },
	[196555]={ class = "DEMONHUNTER", level = 35, },
	[204909]={ class = "DEMONHUNTER", level = 35, },
	[217996]={ class = "DEMONHUNTER", level = 35, },
	[207666]={ class = "DEMONHUNTER", level = 40, },
	[258887]={ class = "DEMONHUNTER", level = 40, },
	[258860]={ class = "DEMONHUNTER", level = 40, },
	[206416]={ class = "DEMONHUNTER", level = 40, },
	[209281]={ class = "DEMONHUNTER", level = 40, },
	[202138]={ class = "DEMONHUNTER", level = 40, },
	[321453]={ class = "DEMONHUNTER", level = 45, },
	[211881]={ class = "DEMONHUNTER", level = 45, },
	[203556]={ class = "DEMONHUNTER", level = 45, },
	[263648]={ class = "DEMONHUNTER", level = 45, },
	[206477]={ class = "DEMONHUNTER", level = 45, },
	[268175]={ class = "DEMONHUNTER", level = 45, },
	[320341]={ class = "DEMONHUNTER", level = 50, },
	[213410]={ class = "DEMONHUNTER", level = 50, },
	[258925]={ class = "DEMONHUNTER", level = 50, },
	[209258]={ class = "DEMONHUNTER", level = 50, },
	[206476]={ class = "DEMONHUNTER", level = 50, },
	[326853]={ class = "DEMONHUNTER", level = 50, },
--++ Demon Hunter PvP Talents ++	
	[205625]={ class = "DEMONHUNTER", level = 20, },
	[235893]={ class = "DEMONHUNTER", level = 20, },
	[205629]={ class = "DEMONHUNTER", level = 20, },
	[205626]={ class = "DEMONHUNTER", level = 20, },
	[206649]={ class = "DEMONHUNTER", level = 20, },
	[205630]={ class = "DEMONHUNTER", level = 20, },
	[205627]={ class = "DEMONHUNTER", level = 20, },
	[203704]={ class = "DEMONHUNTER", level = 20, },
	[235903]={ class = "DEMONHUNTER", level = 20, },
	[328725]={ class = "DEMONHUNTER", level = 20, },
	[211489]={ class = "DEMONHUNTER", level = 20, },
	[207029]={ class = "DEMONHUNTER", level = 20, },
	[213480]={ class = "DEMONHUNTER", level = 20, },
	[206803]={ class = "DEMONHUNTER", level = 30, },
	[205604]={ class = "DEMONHUNTER", level = 30, },
	[227635]={ class = "DEMONHUNTER", level = 40, },
	[205596]={ class = "DEMONHUNTER", level = 40, },
--++ Druid Abilities ++	
	[231437]={ class = "DRUID", level = 1, },
	[137009]={ class = "DRUID", level = 1, },
	[164862]={ class = "DRUID", level = 1, },
	[219432]={ class = "DRUID", level = 1, },
	[77758]={ class = "DRUID", level = 1, },
	[106830]={ class = "DRUID", level = 1, },
	[5225]={ class = "DRUID", level = 1, },
	[5176]={ class = "DRUID", level = 1, },
	[8921]={ class = "DRUID", level = 2, },
	[8936]={ class = "DRUID", level = 3, },
	[339]={ class = "DRUID", level = 4, },
	[768]={ class = "DRUID", level = 5, },
	[5221]={ class = "DRUID", level = 5, },
	[1850]={ class = "DRUID", level = 6, },
	[125972]={ class = "DRUID", level = 6, },
	[22568]={ class = "DRUID", level = 7, },
	[5487]={ class = "DRUID", level = 8, },
	[33917]={ class = "DRUID", level = 8, },
	[326646]={ class = "DRUID", level = 9, },
	[16870]={ class = "DRUID", level = 10, },
	[236716]={ class = "DRUID", level = 10, },
	[783]={ class = "DRUID", level = 10, },
	[193753]={ class = "DRUID", level = 12, },
	[276012]={ class = "DRUID", level = 13, },
	[50769]={ class = "DRUID", level = 13, },
	[164815]={ class = "DRUID", level = 13, },
	[6795]={ class = "DRUID", level = 14, },
	[5215]={ class = "DRUID", level = 17, },
	[192081]={ class = "DRUID", level = 18, },
	[127757]={ class = "DRUID", level = 19, },
	[210053]={ class = "DRUID", level = 19, },
	[210065]={ class = "DRUID", level = 19, },
	[18960]={ class = "DRUID", level = 22, },
	[22812]={ class = "DRUID", level = 24, },
	[165962]={ class = "DRUID", level = 24, },
	[20484]={ class = "DRUID", level = 29, },
	[276029]={ class = "DRUID", level = 30, },
	[2637]={ class = "DRUID", level = 38, },
	[2908]={ class = "DRUID", level = 41, },
	[106898]={ class = "DRUID", level = 43, },
	[327993]={ class = "DRUID", level = 44, },
	[328024]={ class = "DRUID", level = 46, },
	[33786]={ class = "DRUID", level = 48, },
	[231032]={ class = "DRUID", level = 52, },
	[343238]={ class = "DRUID", level = 56, },
--++ Druid Specializations ++	
	[137013]={ class = "DRUID", level = 1, },
	[137011]={ class = "DRUID", level = 1, },
	[137010]={ class = "DRUID", level = 1, },
	[137012]={ class = "DRUID", level = 1, },
	[157447]={ class = "DRUID", level = 1, },
	[228545]={ class = "DRUID", level = 1, },
	[190984]={ class = "DRUID", level = 1, },
	[197911]={ class = "DRUID", level = 10, },
	[77495]={ class = "DRUID", level = 10, },
	[155783]={ class = "DRUID", level = 10, },
	[77493]={ class = "DRUID", level = 10, },
	[326085]={ class = "DRUID", level = 10, },
	[6807]={ class = "DRUID", level = 10, },
	[1822]={ class = "DRUID", level = 10, },
	[774]={ class = "DRUID", level = 10, },
	[194153]={ class = "DRUID", level = 10, },
	[300346]={ class = "DRUID", level = 10, },
	[79577]={ class = "DRUID", level = 11, },
	[18562]={ class = "DRUID", level = 11, },
	[106832]={ class = "DRUID", level = 11, },
	[270100]={ class = "DRUID", level = 12, },
	[102342]={ class = "DRUID", level = 12, },
	[78674]={ class = "DRUID", level = 12, },
	[5217]={ class = "DRUID", level = 12, },
	[24858]={ class = "DRUID", level = 16, },
	[300349]={ class = "DRUID", level = 19, },
	[88423]={ class = "DRUID", level = 19, },
	[2782]={ class = "DRUID", level = 19, },
	[22842]={ class = "DRUID", level = 21, },
	[33763]={ class = "DRUID", level = 21, },
	[1079]={ class = "DRUID", level = 21, },
	[93402]={ class = "DRUID", level = 23, },
	[213764]={ class = "DRUID", level = 23, },
	[231040]={ class = "DRUID", level = 26, },
	[106839]={ class = "DRUID", level = 26, },
	[78675]={ class = "DRUID", level = 26, },
	[197524]={ class = "DRUID", level = 27, },
	[131768]={ class = "DRUID", level = 27, },
	[16931]={ class = "DRUID", level = 27, },
	[145108]={ class = "DRUID", level = 27, },
	[99]={ class = "DRUID", level = 28, },
	[22570]={ class = "DRUID", level = 28, },
	[132469]={ class = "DRUID", level = 28, },
	[102793]={ class = "DRUID", level = 28, },
	[231050]={ class = "DRUID", level = 32, },
	[61336]={ class = "DRUID", level = 32, },
	[231070]={ class = "DRUID", level = 33, },
	[328023]={ class = "DRUID", level = 33, },
	[16864]={ class = "DRUID", level = 33, },
	[113043]={ class = "DRUID", level = 33, },
	[50334]={ class = "DRUID", level = 34, },
	[106951]={ class = "DRUID", level = 34, },
	[191034]={ class = "DRUID", level = 34, },
	[48438]={ class = "DRUID", level = 34, },
	[231057]={ class = "DRUID", level = 36, },
	[210706]={ class = "DRUID", level = 37, },
	[48484]={ class = "DRUID", level = 37, },
	[345208]={ class = "DRUID", level = 37, },
	[231042]={ class = "DRUID", level = 37, },
	[740]={ class = "DRUID", level = 37, },
	[194223]={ class = "DRUID", level = 39, },
	[145205]={ class = "DRUID", level = 39, },
	[273048]={ class = "DRUID", level = 39, },
	[231052]={ class = "DRUID", level = 39, },
	[29166]={ class = "DRUID", level = 42, },
	[231064]={ class = "DRUID", level = 42, },
	[231063]={ class = "DRUID", level = 42, },
	[231283]={ class = "DRUID", level = 42, },
	[328021]={ class = "DRUID", level = 47, },
	[231065]={ class = "DRUID", level = 47, },
	[212040]={ class = "DRUID", level = 47, },
	[328767]={ class = "DRUID", level = 47, },
	[231055]={ class = "DRUID", level = 47, },
	[16974]={ class = "DRUID", level = 49, },
	[202342]={ class = "DRUID", level = 49, },
	[288826]={ class = "DRUID", level = 49, },
	[328025]={ class = "DRUID", level = 49, },
	[326228]={ class = "DRUID", level = 52, },
	[301768]={ class = "DRUID", level = 54, },
	[343232]={ class = "DRUID", level = 54, },
	[327541]={ class = "DRUID", level = 54, },
	[197061]={ class = "DRUID", level = 56, },
	[343223]={ class = "DRUID", level = 58, },
	[343240]={ class = "DRUID", level = 58, },
	[132158]={ class = "DRUID", level = 58, },
	[328022]={ class = "DRUID", level = 58, },
--++ Druid Talents ++	
	[207383]={ class = "DRUID", level = 15, },
	[203962]={ class = "DRUID", level = 15, },
	[203953]={ class = "DRUID", level = 15, },
	[155835]={ class = "DRUID", level = 15, },
	[102351]={ class = "DRUID", level = 15, },
	[205636]={ class = "DRUID", level = 15, },
	[155580]={ class = "DRUID", level = 15, },
	[202430]={ class = "DRUID", level = 15, },
	[50464]={ class = "DRUID", level = 15, },
	[202021]={ class = "DRUID", level = 15, },
	[202031]={ class = "DRUID", level = 15, },
	[202425]={ class = "DRUID", level = 15, },
	[108238]={ class = "DRUID", level = 25, },
	[252216]={ class = "DRUID", level = 25, },
	[102401]={ class = "DRUID", level = 25, },
	[197488]={ class = "DRUID", level = 30, },
	[197632]={ class = "DRUID", level = 30, },
	[197490]={ class = "DRUID", level = 30, },
	[202155]={ class = "DRUID", level = 30, },
	[202157]={ class = "DRUID", level = 30, },
	[197491]={ class = "DRUID", level = 30, },
	[217615]={ class = "DRUID", level = 30, },
	[197492]={ class = "DRUID", level = 30, },
	[319454]={ class = "DRUID", level = 35, },
	[102359]={ class = "DRUID", level = 35, },
	[5211]={ class = "DRUID", level = 35, },
	[200390]={ class = "DRUID", level = 40, },
	[203964]={ class = "DRUID", level = 40, },
	[102560]={ class = "DRUID", level = 40, },
	[102558]={ class = "DRUID", level = 40, },
	[102543]={ class = "DRUID", level = 40, },
	[33891]={ class = "DRUID", level = 40, },
	[52610]={ class = "DRUID", level = 40, },
	[114107]={ class = "DRUID", level = 40, },
	[158476]={ class = "DRUID", level = 40, },
	[158477]={ class = "DRUID", level = 40, },
	[158478]={ class = "DRUID", level = 40, },
	[202345]={ class = "DRUID", level = 40, },
	[202028]={ class = "DRUID", level = 45, },
	[203974]={ class = "DRUID", level = 45, },
	[155578]={ class = "DRUID", level = 45, },
	[197073]={ class = "DRUID", level = 45, },
	[203651]={ class = "DRUID", level = 45, },
	[285381]={ class = "DRUID", level = 45, },
	[285564]={ class = "DRUID", level = 45, },
	[207385]={ class = "DRUID", level = 45, },
	[202354]={ class = "DRUID", level = 45, },
	[202347]={ class = "DRUID", level = 45, },
	[203965]={ class = "DRUID", level = 45, },
	[279620]={ class = "DRUID", level = 45, },
	[319439]={ class = "DRUID", level = 50, },
	[274837]={ class = "DRUID", level = 50, },
	[197721]={ class = "DRUID", level = 50, },
	[202770]={ class = "DRUID", level = 50, },
	[155675]={ class = "DRUID", level = 50, },
	[236068]={ class = "DRUID", level = 50, },
	[274281]={ class = "DRUID", level = 50, },
	[274902]={ class = "DRUID", level = 50, },
	[80313]={ class = "DRUID", level = 50, },
	[204053]={ class = "DRUID", level = 50, },
	[343647]={ class = "DRUID", level = 50, },
	[135288]={ class = "DRUID", level = 50, },
--++ Druid PvP Talents ++	
	[233754]={ class = "DRUID", level = 20, },
	[200567]={ class = "DRUID", level = 20, },
	[233755]={ class = "DRUID", level = 20, },
	[201664]={ class = "DRUID", level = 20, },
	[202226]={ class = "DRUID", level = 20, },
	[209749]={ class = "DRUID", level = 20, },
	[236020]={ class = "DRUID", level = 20, },
	[203224]={ class = "DRUID", level = 20, },
	[236012]={ class = "DRUID", level = 20, },
	[236147]={ class = "DRUID", level = 20, },
	[202246]={ class = "DRUID", level = 20, },
	[200549]={ class = "DRUID", level = 20, },
	[209730]={ class = "DRUID", level = 20, },
	[203399]={ class = "DRUID", level = 20, },
	[202110]={ class = "DRUID", level = 20, },
	[236019]={ class = "DRUID", level = 20, },
	[201259]={ class = "DRUID", level = 20, },
	[203553]={ class = "DRUID", level = 21, },
	[203052]={ class = "DRUID", level = 21, },
	[236153]={ class = "DRUID", level = 21, },
	[247543]={ class = "DRUID", level = 23, },
	[207017]={ class = "DRUID", level = 25, },
	[289318]={ class = "DRUID", level = 25, },
	[203242]={ class = "DRUID", level = 25, },
	[228431]={ class = "DRUID", level = 27, },
	[205673]={ class = "DRUID", level = 27, },
	[236180]={ class = "DRUID", level = 30, },
	[232546]={ class = "DRUID", level = 30, },
	[236144]={ class = "DRUID", level = 30, },
	[289237]={ class = "DRUID", level = 30, },
	[209740]={ class = "DRUID", level = 30, },
	[203624]={ class = "DRUID", level = 34, },
	[305497]={ class = "DRUID", level = 35, },
	[233673]={ class = "DRUID", level = 40, },
	[202626]={ class = "DRUID", level = 40, },
	[233750]={ class = "DRUID", level = 40, },
	[329042]={ class = "DRUID", level = 40, },
	[213200]={ class = "DRUID", level = 43, },
	[200931]={ class = "DRUID", level = 48, },
--++ Hunter Abilities ++	
	[138430]={ class = "HUNTER", level = 1, },
	[203413]={ class = "HUNTER", level = 1, },
	[137014]={ class = "HUNTER", level = 1, },
	[242155]={ class = "HUNTER", level = 1, },
	[205154]={ class = "HUNTER", level = 1, },
	[229533]={ class = "HUNTER", level = 1, },
	[260247]={ class = "HUNTER", level = 1, },
	[157443]={ class = "HUNTER", level = 1, },
	[56641]={ class = "HUNTER", level = 1, },
	[162487]={ class = "HUNTER", level = 1, },
	[185358]={ class = "HUNTER", level = 2, },
	[195645]={ class = "HUNTER", level = 3, },
	[781]={ class = "HUNTER", level = 4, },
	[1494]={ class = "HUNTER", level = 4, },
	[19878]={ class = "HUNTER", level = 4, },
	[19879]={ class = "HUNTER", level = 4, },
	[19880]={ class = "HUNTER", level = 4, },
	[19882]={ class = "HUNTER", level = 4, },
	[19885]={ class = "HUNTER", level = 4, },
	[19883]={ class = "HUNTER", level = 4, },
	[19884]={ class = "HUNTER", level = 4, },
	[186257]={ class = "HUNTER", level = 5, },
	[1462]={ class = "HUNTER", level = 5, },
	[883]={ class = "HUNTER", level = 5, },
	[2641]={ class = "HUNTER", level = 5, },
	[6991]={ class = "HUNTER", level = 5, },
	[136]={ class = "HUNTER", level = 5, },
	[982]={ class = "HUNTER", level = 5, },
	[1515]={ class = "HUNTER", level = 5, },
	[5384]={ class = "HUNTER", level = 6, },
	[210000]={ class = "HUNTER", level = 6, },
	[257284]={ class = "HUNTER", level = 7, },
	[186265]={ class = "HUNTER", level = 8, },
	[109304]={ class = "HUNTER", level = 9, },
	[83242]={ class = "HUNTER", level = 10, },
	[93321]={ class = "HUNTER", level = 10, },
	[93322]={ class = "HUNTER", level = 10, },
	[187650]={ class = "HUNTER", level = 10, },
	[259398]={ class = "HUNTER", level = 12, },
	[83243]={ class = "HUNTER", level = 17, },
	[61648]={ class = "HUNTER", level = 19, },
	[127933]={ class = "HUNTER", level = 19, },
	[1543]={ class = "HUNTER", level = 19, },
	[209997]={ class = "HUNTER", level = 19, },
	[187698]={ class = "HUNTER", level = 21, },
	[272651]={ class = "HUNTER", level = 22, },
	[34477]={ class = "HUNTER", level = 27, },
	[321297]={ class = "HUNTER", level = 29, },
	[19801]={ class = "HUNTER", level = 37, },
	[1513]={ class = "HUNTER", level = 39, },
	[83244]={ class = "HUNTER", level = 41, },
	[6197]={ class = "HUNTER", level = 43, },
	[343241]={ class = "HUNTER", level = 46, },
	[125050]={ class = "HUNTER", level = 47, },
	[83245]={ class = "HUNTER", level = 48, },
	[343242]={ class = "HUNTER", level = 52, },
	[343244]={ class = "HUNTER", level = 54, },
	[343247]={ class = "HUNTER", level = 56, },
	[343248]={ class = "HUNTER", level = 58, },
--++ Hunter Specializations ++	
	[137015]={ class = "HUNTER", level = 1, },
	[137016]={ class = "HUNTER", level = 1, },
	[137017]={ class = "HUNTER", level = 1, },
	[19434]={ class = "HUNTER", level = 10, },
	[34026]={ class = "HUNTER", level = 10, },
	[76657]={ class = "HUNTER", level = 10, },
	[193468]={ class = "HUNTER", level = 10, },
	[263135]={ class = "HUNTER", level = 10, },
	[186270]={ class = "HUNTER", level = 10, },
	[259489]={ class = "HUNTER", level = 11, },
	[321014]={ class = "HUNTER", level = 11, },
	[321018]={ class = "HUNTER", level = 11, },
	[217200]={ class = "HUNTER", level = 12, },
	[186387]={ class = "HUNTER", level = 12, },
	[259491]={ class = "HUNTER", level = 12, },
	[5116]={ class = "HUNTER", level = 13, },
	[321023]={ class = "HUNTER", level = 13, },
	[321026]={ class = "HUNTER", level = 13, },
	[321293]={ class = "HUNTER", level = 14, },
	[193455]={ class = "HUNTER", level = 14, },
	[190925]={ class = "HUNTER", level = 14, },
	[147362]={ class = "HUNTER", level = 18, },
	[187707]={ class = "HUNTER", level = 18, },
	[19574]={ class = "HUNTER", level = 20, },
	[257044]={ class = "HUNTER", level = 20, },
	[259495]={ class = "HUNTER", level = 20, },
	[187708]={ class = "HUNTER", level = 23, },
	[2643]={ class = "HUNTER", level = 23, },
	[257620]={ class = "HUNTER", level = 23, },
	[186289]={ class = "HUNTER", level = 24, },
	[155228]={ class = "HUNTER", level = 24, },
	[185789]={ class = "HUNTER", level = 24, },
	[263186]={ class = "HUNTER", level = 28, },
	[56315]={ class = "HUNTER", level = 28, },
	[321281]={ class = "HUNTER", level = 28, },
	[115939]={ class = "HUNTER", level = 32, },
	[294029]={ class = "HUNTER", level = 32, },
	[257621]={ class = "HUNTER", level = 32, },
	[19577]={ class = "HUNTER", level = 33, },
	[231548]={ class = "HUNTER", level = 34, },
	[266779]={ class = "HUNTER", level = 34, },
	[288613]={ class = "HUNTER", level = 34, },
	[193530]={ class = "HUNTER", level = 38, },
	[231550]={ class = "HUNTER", level = 38, },
	[260240]={ class = "HUNTER", level = 38, },
	[53270]={ class = "HUNTER", level = 39, },
	[53351]={ class = "HUNTER", level = 42, },
	[320976]={ class = "HUNTER", level = 42, },
	[231546]={ class = "HUNTER", level = 44, },
	[262838]={ class = "HUNTER", level = 49, },
	[321287]={ class = "HUNTER", level = 49, },
	[321290]={ class = "HUNTER", level = 49, },
--++ Hunter Talents ++	
	[269737]={ class = "HUNTER", level = 15, },
	[267116]={ class = "HUNTER", level = 15, },
	[120679]={ class = "HUNTER", level = 15, },
	[273887]={ class = "HUNTER", level = 15, },
	[260309]={ class = "HUNTER", level = 15, },
	[271788]={ class = "HUNTER", level = 15, },
	[265895]={ class = "HUNTER", level = 15, },
	[268501]={ class = "HUNTER", level = 15, },
	[120360]={ class = "HUNTER", level = 25, },
	[212436]={ class = "HUNTER", level = 25, },
	[260228]={ class = "HUNTER", level = 25, },
	[53209]={ class = "HUNTER", level = 25, },
	[212431]={ class = "HUNTER", level = 25, },
	[264332]={ class = "HUNTER", level = 25, },
	[260241]={ class = "HUNTER", level = 25, },
	[199528]={ class = "HUNTER", level = 25, },
	[193532]={ class = "HUNTER", level = 25, },
	[199483]={ class = "HUNTER", level = 30, },
	[270581]={ class = "HUNTER", level = 30, },
	[199921]={ class = "HUNTER", level = 30, },
	[131894]={ class = "HUNTER", level = 35, },
	[260248]={ class = "HUNTER", level = 35, },
	[342049]={ class = "HUNTER", level = 35, },
	[257891]={ class = "HUNTER", level = 35, },
	[193533]={ class = "HUNTER", level = 35, },
	[162488]={ class = "HUNTER", level = 35, },
	[260367]={ class = "HUNTER", level = 35, },
	[257944]={ class = "HUNTER", level = 35, },
	[321468]={ class = "HUNTER", level = 40, },
	[109248]={ class = "HUNTER", level = 40, },
	[266921]={ class = "HUNTER", level = 40, },
	[109215]={ class = "HUNTER", level = 40, },
	[321460]={ class = "HUNTER", level = 45, },
	[260402]={ class = "HUNTER", level = 45, },
	[269751]={ class = "HUNTER", level = 45, },
	[260393]={ class = "HUNTER", level = 45, },
	[259387]={ class = "HUNTER", level = 45, },
	[201430]={ class = "HUNTER", level = 45, },
	[199530]={ class = "HUNTER", level = 45, },
	[260285]={ class = "HUNTER", level = 45, },
	[191384]={ class = "HUNTER", level = 50, },
	[260331]={ class = "HUNTER", level = 50, },
	[321530]={ class = "HUNTER", level = 50, },
	[260404]={ class = "HUNTER", level = 50, },
	[259391]={ class = "HUNTER", level = 50, },
	[199532]={ class = "HUNTER", level = 50, },
	[194595]={ class = "HUNTER", level = 50, },
	[260243]={ class = "HUNTER", level = 50, },
	[271014]={ class = "HUNTER", level = 50, },
--++ Hunter PvP Talents ++	
	[205691]={ class = "HUNTER", level = 20, },
	[208652]={ class = "HUNTER", level = 20, },
	[202589]={ class = "HUNTER", level = 20, },
	[236776]={ class = "HUNTER", level = 20, },
	[203235]={ class = "HUNTER", level = 20, },
	[212640]={ class = "HUNTER", level = 20, },
	[248443]={ class = "HUNTER", level = 20, },
	[213691]={ class = "HUNTER", level = 20, },
	[202900]={ class = "HUNTER", level = 20, },
	[202914]={ class = "HUNTER", level = 20, },
	[212668]={ class = "HUNTER", level = 20, },
	[202797]={ class = "HUNTER", level = 20, },
	[204190]={ class = "HUNTER", level = 20, },
	[203264]={ class = "HUNTER", level = 21, },
	[202746]={ class = "HUNTER", level = 25, },
	[248518]={ class = "HUNTER", level = 30, },
	[203155]={ class = "HUNTER", level = 30, },
	[212638]={ class = "HUNTER", level = 35, },
	[203129]={ class = "HUNTER", level = 35, },
	[203340]={ class = "HUNTER", level = 40, },
	[53480]={ class = "HUNTER", level = 40, },
--++ Mage Abilities ++	
	[120146]={ class = "MAGE", level = 1, },
	[131784]={ class = "MAGE", level = 1, },
	[137018]={ class = "MAGE", level = 1, },
	[53142]={ class = "MAGE", level = 1, },
	[281402]={ class = "MAGE", level = 1, },
	[33691]={ class = "MAGE", level = 1, },
	[35717]={ class = "MAGE", level = 1, },
	[49361]={ class = "MAGE", level = 1, },
	[176246]={ class = "MAGE", level = 1, },
	[88345]={ class = "MAGE", level = 1, },
	[88346]={ class = "MAGE", level = 1, },
	[132620]={ class = "MAGE", level = 1, },
	[132626]={ class = "MAGE", level = 1, },
	[176244]={ class = "MAGE", level = 1, },
	[116]={ class = "MAGE", level = 1, },
	[61780]={ class = "MAGE", level = 1, },
	[126819]={ class = "MAGE", level = 1, },
	[161353]={ class = "MAGE", level = 1, },
	[161354]={ class = "MAGE", level = 1, },
	[161355]={ class = "MAGE", level = 1, },
	[319836]={ class = "MAGE", level = 2, },
	[122]={ class = "MAGE", level = 3, },
	[1953]={ class = "MAGE", level = 4, },
	[190336]={ class = "MAGE", level = 5, },
	[1449]={ class = "MAGE", level = 6, },
	[2139]={ class = "MAGE", level = 7, },
	[1459]={ class = "MAGE", level = 8, },
	[130]={ class = "MAGE", level = 9, },
	[118]={ class = "MAGE", level = 10, },
	[193759]={ class = "MAGE", level = 10, },
	[343127]={ class = "MAGE", level = 11, },
	[281403]={ class = "MAGE", level = 11, },
	[224869]={ class = "MAGE", level = 11, },
	[3565]={ class = "MAGE", level = 11, },
	[32271]={ class = "MAGE", level = 11, },
	[3562]={ class = "MAGE", level = 11, },
	[3567]={ class = "MAGE", level = 11, },
	[32272]={ class = "MAGE", level = 11, },
	[3561]={ class = "MAGE", level = 11, },
	[49359]={ class = "MAGE", level = 11, },
	[3566]={ class = "MAGE", level = 11, },
	[3563]={ class = "MAGE", level = 11, },
	[475]={ class = "MAGE", level = 21, },
	[45438]={ class = "MAGE", level = 22, },
	[49358]={ class = "MAGE", level = 23, },
	[210086]={ class = "MAGE", level = 24, },
	[343140]={ class = "MAGE", level = 24, },
	[281400]={ class = "MAGE", level = 24, },
	[11419]={ class = "MAGE", level = 24, },
	[32266]={ class = "MAGE", level = 24, },
	[11416]={ class = "MAGE", level = 24, },
	[11417]={ class = "MAGE", level = 24, },
	[32267]={ class = "MAGE", level = 24, },
	[10059]={ class = "MAGE", level = 24, },
	[49360]={ class = "MAGE", level = 24, },
	[11420]={ class = "MAGE", level = 24, },
	[11418]={ class = "MAGE", level = 24, },
	[28271]={ class = "MAGE", level = 25, },
	[28272]={ class = "MAGE", level = 25, },
	[61305]={ class = "MAGE", level = 25, },
	[61721]={ class = "MAGE", level = 25, },
	[161372]={ class = "MAGE", level = 25, },
	[277787]={ class = "MAGE", level = 25, },
	[277792]={ class = "MAGE", level = 25, },
	[321395]={ class = "MAGE", level = 25, },
	[53140]={ class = "MAGE", level = 25, },
	[33690]={ class = "MAGE", level = 25, },
	[35715]={ class = "MAGE", level = 25, },
	[120145]={ class = "MAGE", level = 28, },
	[88342]={ class = "MAGE", level = 32, },
	[88344]={ class = "MAGE", level = 32, },
	[66]={ class = "MAGE", level = 34, },
	[30449]={ class = "MAGE", level = 39, },
	[55342]={ class = "MAGE", level = 44, },
	[80353]={ class = "MAGE", level = 49, },
	[281404]={ class = "MAGE", level = 50, },
	[176248]={ class = "MAGE", level = 50, },
	[132621]={ class = "MAGE", level = 50, },
	[132627]={ class = "MAGE", level = 50, },
	[176242]={ class = "MAGE", level = 50, },
--++ Mage Specializations ++	
	[137019]={ class = "MAGE", level = 1, },
	[137020]={ class = "MAGE", level = 1, },
	[44425]={ class = "MAGE", level = 10, },
	[30451]={ class = "MAGE", level = 10, },
	[137021]={ class = "MAGE", level = 10, },
	[133]={ class = "MAGE", level = 10, },
	[30455]={ class = "MAGE", level = 10, },
	[76613]={ class = "MAGE", level = 10, },
	[12846]={ class = "MAGE", level = 10, },
	[190740]={ class = "MAGE", level = 10, },
	[11366]={ class = "MAGE", level = 12, },
	[31589]={ class = "MAGE", level = 12, },
	[31687]={ class = "MAGE", level = 12, },
	[5143]={ class = "MAGE", level = 13, },
	[112965]={ class = "MAGE", level = 13, },
	[2948]={ class = "MAGE", level = 13, },
	[190356]={ class = "MAGE", level = 14, },
	[195283]={ class = "MAGE", level = 14, },
	[759]={ class = "MAGE", level = 17, },
	[2120]={ class = "MAGE", level = 17, },
	[12982]={ class = "MAGE", level = 17, },
	[321752]={ class = "MAGE", level = 18, },
	[120]={ class = "MAGE", level = 18, },
	[231568]={ class = "MAGE", level = 18, },
	[342245]={ class = "MAGE", level = 19, },
	[44614]={ class = "MAGE", level = 19, },
	[257541]={ class = "MAGE", level = 19, },
	[321758]={ class = "MAGE", level = 23, },
	[117216]={ class = "MAGE", level = 23, },
	[231596]={ class = "MAGE", level = 23, },
	[31661]={ class = "MAGE", level = 27, },
	[12051]={ class = "MAGE", level = 27, },
	[231582]={ class = "MAGE", level = 27, },
	[235313]={ class = "MAGE", level = 28, },
	[11426]={ class = "MAGE", level = 28, },
	[235450]={ class = "MAGE", level = 28, },
	[12042]={ class = "MAGE", level = 29, },
	[190319]={ class = "MAGE", level = 29, },
	[12472]={ class = "MAGE", level = 29, },
	[231564]={ class = "MAGE", level = 31, },
	[190447]={ class = "MAGE", level = 32, },
	[321420]={ class = "MAGE", level = 32, },
	[108853]={ class = "MAGE", level = 32, },
	[157642]={ class = "MAGE", level = 33, },
	[343175]={ class = "MAGE", level = 33, },
	[321507]={ class = "MAGE", level = 33, },
	[231584]={ class = "MAGE", level = 37, },
	[231567]={ class = "MAGE", level = 37, },
	[321707]={ class = "MAGE", level = 38, },
	[84714]={ class = "MAGE", level = 38, },
	[321747]={ class = "MAGE", level = 38, },
	[343208]={ class = "MAGE", level = 41, },
	[343194]={ class = "MAGE", level = 41, },
	[343177]={ class = "MAGE", level = 41, },
	[86949]={ class = "MAGE", level = 42, },
	[235219]={ class = "MAGE", level = 42, },
	[205025]={ class = "MAGE", level = 42, },
	[343180]={ class = "MAGE", level = 43, },
	[231565]={ class = "MAGE", level = 43, },
	[343230]={ class = "MAGE", level = 43, },
	[343183]={ class = "MAGE", level = 46, },
	[343222]={ class = "MAGE", level = 46, },
	[343215]={ class = "MAGE", level = 46, },
	[236662]={ class = "MAGE", level = 47, },
	[231630]={ class = "MAGE", level = 47, },
	[110959]={ class = "MAGE", level = 47, },
	[321708]={ class = "MAGE", level = 48, },
	[321684]={ class = "MAGE", level = 48, },
	[321745]={ class = "MAGE", level = 48, },
	[321526]={ class = "MAGE", level = 52, },
	[321696]={ class = "MAGE", level = 52, },
	[321709]={ class = "MAGE", level = 52, },
	[321699]={ class = "MAGE", level = 54, },
	[321742]={ class = "MAGE", level = 54, },
	[321711]={ class = "MAGE", level = 54, },
	[321739]={ class = "MAGE", level = 56, },
	[321710]={ class = "MAGE", level = 56, },
	[321702]={ class = "MAGE", level = 56, },
	[108978]={ class = "MAGE", level = 58, },
--++ Mage Talents ++	
	[236628]={ class = "MAGE", level = 15, },
	[205022]={ class = "MAGE", level = 15, },
	[205027]={ class = "MAGE", level = 15, },
	[205026]={ class = "MAGE", level = 15, },
	[157997]={ class = "MAGE", level = 15, },
	[205024]={ class = "MAGE", level = 15, },
	[205020]={ class = "MAGE", level = 15, },
	[264354]={ class = "MAGE", level = 15, },
	[269644]={ class = "MAGE", level = 15, },
	[157981]={ class = "MAGE", level = 25, },
	[235365]={ class = "MAGE", level = 25, },
	[235297]={ class = "MAGE", level = 25, },
	[108839]={ class = "MAGE", level = 25, },
	[342249]={ class = "MAGE", level = 25, },
	[212653]={ class = "MAGE", level = 25, },
	[236457]={ class = "MAGE", level = 25, },
	[321358]={ class = "MAGE", level = 30, },
	[1463]={ class = "MAGE", level = 30, },
	[116011]={ class = "MAGE", level = 30, },
	[235870]={ class = "MAGE", level = 35, },
	[342231]={ class = "MAGE", level = 35, },
	[278309]={ class = "MAGE", level = 35, },
	[257537]={ class = "MAGE", level = 35, },
	[205029]={ class = "MAGE", level = 35, },
	[342344]={ class = "MAGE", level = 35, },
	[205030]={ class = "MAGE", level = 35, },
	[114923]={ class = "MAGE", level = 35, },
	[205028]={ class = "MAGE", level = 35, },
	[235711]={ class = "MAGE", level = 40, },
	[236058]={ class = "MAGE", level = 40, },
	[235224]={ class = "MAGE", level = 40, },
	[205036]={ class = "MAGE", level = 40, },
	[113724]={ class = "MAGE", level = 40, },
	[153626]={ class = "MAGE", level = 45, },
	[153595]={ class = "MAGE", level = 45, },
	[205023]={ class = "MAGE", level = 45, },
	[205037]={ class = "MAGE", level = 45, },
	[270233]={ class = "MAGE", level = 45, },
	[44457]={ class = "MAGE", level = 45, },
	[281482]={ class = "MAGE", level = 45, },
	[157980]={ class = "MAGE", level = 45, },
	[321387]={ class = "MAGE", level = 50, },
	[199786]={ class = "MAGE", level = 50, },
	[155148]={ class = "MAGE", level = 50, },
	[153561]={ class = "MAGE", level = 50, },
	[155147]={ class = "MAGE", level = 50, },
	[269650]={ class = "MAGE", level = 50, },
	[205021]={ class = "MAGE", level = 50, },
	[155149]={ class = "MAGE", level = 50, },
	[210805]={ class = "MAGE", level = 50, },
--++ Mage PvP Talents ++	
	[276741]={ class = "MAGE", level = 20, },
	[206431]={ class = "MAGE", level = 20, },
	[198126]={ class = "MAGE", level = 20, },
	[280450]={ class = "MAGE", level = 20, },
	[236788]={ class = "MAGE", level = 20, },
	[198120]={ class = "MAGE", level = 20, },
	[198158]={ class = "MAGE", level = 20, },
	[198062]={ class = "MAGE", level = 20, },
	[198064]={ class = "MAGE", level = 20, },
	[203275]={ class = "MAGE", level = 20, },
	[198151]={ class = "MAGE", level = 20, },
	[203280]={ class = "MAGE", level = 20, },
	[198123]={ class = "MAGE", level = 30, },
	[203283]={ class = "MAGE", level = 30, },
	[203284]={ class = "MAGE", level = 30, },
	[198144]={ class = "MAGE", level = 30, },
	[198111]={ class = "MAGE", level = 30, },
	[198148]={ class = "MAGE", level = 40, },
	[203286]={ class = "MAGE", level = 40, },
	[198100]={ class = "MAGE", level = 40, },
	[210476]={ class = "MAGE", level = 48, },
--++ Monk Abilities ++	
	[137022]={ class = "MONK", level = 1, },
	[116812]={ class = "MONK", level = 1, },
	[100780]={ class = "MONK", level = 1, },
	[100784]={ class = "MONK", level = 2, },
	[109132]={ class = "MONK", level = 3, },
	[116670]={ class = "MONK", level = 4, },
	[117952]={ class = "MONK", level = 5, },
	[119381]={ class = "MONK", level = 6, },
	[101546]={ class = "MONK", level = 7, },
	[322101]={ class = "MONK", level = 8, },
	[328669]={ class = "MONK", level = 9, },
	[209525]={ class = "MONK", level = 10, },
	[322109]={ class = "MONK", level = 10, },
	[126892]={ class = "MONK", level = 11, },
	[115178]={ class = "MONK", level = 13, },
	[115546]={ class = "MONK", level = 14, },
	[126895]={ class = "MONK", level = 16, },
	[169340]={ class = "MONK", level = 17, },
	[115078]={ class = "MONK", level = 22, },
	[218164]={ class = "MONK", level = 24, },
	[115203]={ class = "MONK", level = 28, },
	[101643]={ class = "MONK", level = 32, },
	[119996]={ class = "MONK", level = 32, },
	[125883]={ class = "MONK", level = 37, },
	[328670]={ class = "MONK", level = 39, },
	[322113]={ class = "MONK", level = 44, },
	[8647]={ class = "MONK", level = 49, },
	[344359]={ class = "MONK", level = 56, },
--++ Monk Specializations ++	
	[137023]={ class = "MONK", level = 1, },
	[137024]={ class = "MONK", level = 1, },
	[322729]={ class = "MONK", level = 1, },
	[137025]={ class = "MONK", level = 1, },
	[157445]={ class = "MONK", level = 1, },
	[124146]={ class = "MONK", level = 1, },
	[205523]={ class = "MONK", level = 10, },
	[115636]={ class = "MONK", level = 10, },
	[117906]={ class = "MONK", level = 10, },
	[117907]={ class = "MONK", level = 10, },
	[107428]={ class = "MONK", level = 10, },
	[124682]={ class = "MONK", level = 12, },
	[113656]={ class = "MONK", level = 12, },
	[115069]={ class = "MONK", level = 12, },
	[128595]={ class = "MONK", level = 14, },
	[261916]={ class = "MONK", level = 17, },
	[322120]={ class = "MONK", level = 17, },
	[115175]={ class = "MONK", level = 17, },
	[115151]={ class = "MONK", level = 18, },
	[116705]={ class = "MONK", level = 18, },
	[245013]={ class = "MONK", level = 19, },
	[137384]={ class = "MONK", level = 19, },
	[220357]={ class = "MONK", level = 19, },
	[116645]={ class = "MONK", level = 19, },
	[157411]={ class = "MONK", level = 19, },
	[191837]={ class = "MONK", level = 21, },
	[101545]={ class = "MONK", level = 21, },
	[121253]={ class = "MONK", level = 21, },
	[261917]={ class = "MONK", level = 23, },
	[119582]={ class = "MONK", level = 23, },
	[116680]={ class = "MONK", level = 23, },
	[115450]={ class = "MONK", level = 24, },
	[262840]={ class = "MONK", level = 26, },
	[322522]={ class = "MONK", level = 26, },
	[322507]={ class = "MONK", level = 27, },
	[116849]={ class = "MONK", level = 27, },
	[137639]={ class = "MONK", level = 27, },
	[243435]={ class = "MONK", level = 28, },
	[115181]={ class = "MONK", level = 29, },
	[281231]={ class = "MONK", level = 29, },
	[122470]={ class = "MONK", level = 29, },
	[322700]={ class = "MONK", level = 33, },
	[343730]={ class = "MONK", level = 33, },
	[231876]={ class = "MONK", level = 33, },
	[116095]={ class = "MONK", level = 34, },
	[231633]={ class = "MONK", level = 34, },
	[115176]={ class = "MONK", level = 34, },
	[231602]={ class = "MONK", level = 37, },
	[274586]={ class = "MONK", level = 37, },
	[116092]={ class = "MONK", level = 38, },
	[231605]={ class = "MONK", level = 38, },
	[124502]={ class = "MONK", level = 38, },
	[322510]={ class = "MONK", level = 41, },
	[343731]={ class = "MONK", level = 41, },
	[343744]={ class = "MONK", level = 41, },
	[132578]={ class = "MONK", level = 42, },
	[123904]={ class = "MONK", level = 42, },
	[322118]={ class = "MONK", level = 42, },
	[322102]={ class = "MONK", level = 43, },
	[322104]={ class = "MONK", level = 43, },
	[322106]={ class = "MONK", level = 43, },
	[322719]={ class = "MONK", level = 46, },
	[216519]={ class = "MONK", level = 46, },
	[115310]={ class = "MONK", level = 46, },
	[343743]={ class = "MONK", level = 47, },
	[212051]={ class = "MONK", level = 47, },
	[231627]={ class = "MONK", level = 47, },
	[322960]={ class = "MONK", level = 48, },
	[325208]={ class = "MONK", level = 48, },
	[325095]={ class = "MONK", level = 52, },
	[325215]={ class = "MONK", level = 52, },
	[344360]={ class = "MONK", level = 52, },
	[324312]={ class = "MONK", level = 54, },
	[325214]={ class = "MONK", level = 54, },
	[344487]={ class = "MONK", level = 54, },
	[328682]={ class = "MONK", level = 56, },
	[343655]={ class = "MONK", level = 58, },
	[322740]={ class = "MONK", level = 58, },
	[323999]={ class = "MONK", level = 58, },
--++ Monk Talents ++	
	[123986]={ class = "MONK", level = 15, },
	[115098]={ class = "MONK", level = 15, },
	[196607]={ class = "MONK", level = 15, },
	[197900]={ class = "MONK", level = 15, },
	[115173]={ class = "MONK", level = 25, },
	[115008]={ class = "MONK", level = 25, },
	[116841]={ class = "MONK", level = 25, },
	[115396]={ class = "MONK", level = 30, },
	[115399]={ class = "MONK", level = 30, },
	[115288]={ class = "MONK", level = 30, },
	[261947]={ class = "MONK", level = 30, },
	[197915]={ class = "MONK", level = 30, },
	[325093]={ class = "MONK", level = 30, },
	[197908]={ class = "MONK", level = 30, },
	[210802]={ class = "MONK", level = 30, },
	[242580]={ class = "MONK", level = 30, },
	[280195]={ class = "MONK", level = 35, },
	[116844]={ class = "MONK", level = 35, },
	[198898]={ class = "MONK", level = 35, },
	[115315]={ class = "MONK", level = 35, },
	[264348]={ class = "MONK", level = 35, },
	[280515]={ class = "MONK", level = 40, },
	[122278]={ class = "MONK", level = 40, },
	[122783]={ class = "MONK", level = 40, },
	[261767]={ class = "MONK", level = 40, },
	[325201]={ class = "MONK", level = 45, },
	[325153]={ class = "MONK", level = 45, },
	[196740]={ class = "MONK", level = 45, },
	[325197]={ class = "MONK", level = 45, },
	[196725]={ class = "MONK", level = 45, },
	[116847]={ class = "MONK", level = 45, },
	[196730]={ class = "MONK", level = 45, },
	[115313]={ class = "MONK", level = 45, },
	[196736]={ class = "MONK", level = 50, },
	[325177]={ class = "MONK", level = 50, },
	[197895]={ class = "MONK", level = 50, },
	[196737]={ class = "MONK", level = 50, },
	[274909]={ class = "MONK", level = 50, },
	[152173]={ class = "MONK", level = 50, },
	[280197]={ class = "MONK", level = 50, },
	[274963]={ class = "MONK", level = 50, },
	[152175]={ class = "MONK", level = 50, },
--++ Monk PvP Talents ++	
	[207025]={ class = "MONK", level = 20, },
	[287503]={ class = "MONK", level = 20, },
	[202162]={ class = "MONK", level = 20, },
	[213658]={ class = "MONK", level = 20, },
	[202577]={ class = "MONK", level = 20, },
	[205147]={ class = "MONK", level = 20, },
	[202370]={ class = "MONK", level = 20, },
	[202523]={ class = "MONK", level = 20, },
	[342928]={ class = "MONK", level = 20, },
	[227344]={ class = "MONK", level = 20, },
	[287681]={ class = "MONK", level = 20, },
	[287506]={ class = "MONK", level = 20, },
	[209584]={ class = "MONK", level = 20, },
	[202335]={ class = "MONK", level = 21, },
	[201372]={ class = "MONK", level = 21, },
	[232876]={ class = "MONK", level = 23, },
	[205234]={ class = "MONK", level = 25, },
	[202424]={ class = "MONK", level = 27, },
	[202107]={ class = "MONK", level = 28, },
	[202272]={ class = "MONK", level = 29, },
	[202428]={ class = "MONK", level = 30, },
	[202126]={ class = "MONK", level = 30, },
	[247483]={ class = "MONK", level = 30, },
	[216255]={ class = "MONK", level = 32, },
	[201769]={ class = "MONK", level = 34, },
	[202200]={ class = "MONK", level = 34, },
	[233759]={ class = "MONK", level = 40, },
	[345829]={ class = "MONK", level = 40, },
--++ Paladin Abilities ++	
	[290608]={ class = "PALADIN", level = 1, },
	[137026]={ class = "PALADIN", level = 1, },
	[23214]={ class = "PALADIN", level = 1, },
	[270562]={ class = "PALADIN", level = 1, },
	[270564]={ class = "PALADIN", level = 1, },
	[73629]={ class = "PALADIN", level = 1, },
	[73630]={ class = "PALADIN", level = 1, },
	[69826]={ class = "PALADIN", level = 1, },
	[69820]={ class = "PALADIN", level = 1, },
	[34767]={ class = "PALADIN", level = 1, },
	[34769]={ class = "PALADIN", level = 1, },
	[13819]={ class = "PALADIN", level = 1, },
	[200654]={ class = "PALADIN", level = 1, },
	[123830]={ class = "PALADIN", level = 1, },
	[115675]={ class = "PALADIN", level = 1, },
	[35395]={ class = "PALADIN", level = 1, },
	[82242]={ class = "PALADIN", level = 1, },
	[53600]={ class = "PALADIN", level = 2, },
	[20271]={ class = "PALADIN", level = 3, },
	[19750]={ class = "PALADIN", level = 4, },
	[853]={ class = "PALADIN", level = 5, },
	[26573]={ class = "PALADIN", level = 6, },
	[85673]={ class = "PALADIN", level = 7, },
	[327977]={ class = "PALADIN", level = 8, },
	[633]={ class = "PALADIN", level = 9, },
	[642]={ class = "PALADIN", level = 10, },
	[7328]={ class = "PALADIN", level = 13, },
	[62124]={ class = "PALADIN", level = 14, },
	[190784]={ class = "PALADIN", level = 17, },
	[121183]={ class = "PALADIN", level = 19, },
	[32223]={ class = "PALADIN", level = 21, },
	[1044]={ class = "PALADIN", level = 22, },
	[10326]={ class = "PALADIN", level = 24, },
	[465]={ class = "PALADIN", level = 28, },
	[6940]={ class = "PALADIN", level = 32, },
	[31884]={ class = "PALADIN", level = 37, },
	[183435]={ class = "PALADIN", level = 38, },
	[1022]={ class = "PALADIN", level = 41, },
	[317872]={ class = "PALADIN", level = 43, },
	[24275]={ class = "PALADIN", level = 46, },
	[200327]={ class = "PALADIN", level = 47, },
	[317911]={ class = "PALADIN", level = 49, },
	[317920]={ class = "PALADIN", level = 52, },
	[5502]={ class = "PALADIN", level = 54, },
	[317906]={ class = "PALADIN", level = 56, },
	[326730]={ class = "PALADIN", level = 58, },
--++ Paladin Specializations ++	
	[137029]={ class = "PALADIN", level = 1, },
	[275773]={ class = "PALADIN", level = 1, },
	[137028]={ class = "PALADIN", level = 1, },
	[137027]={ class = "PALADIN", level = 1, },
	[229976]={ class = "PALADIN", level = 1, },
	[275779]={ class = "PALADIN", level = 3, },
	[31935]={ class = "PALADIN", level = 10, },
	[20473]={ class = "PALADIN", level = 10, },
	[289941]={ class = "PALADIN", level = 10, },
	[76671]={ class = "PALADIN", level = 10, },
	[267316]={ class = "PALADIN", level = 10, },
	[183997]={ class = "PALADIN", level = 10, },
	[25780]={ class = "PALADIN", level = 10, },
	[105805]={ class = "PALADIN", level = 10, },
	[85256]={ class = "PALADIN", level = 10, },
	[342348]={ class = "PALADIN", level = 11, },
	[82326]={ class = "PALADIN", level = 11, },
	[4987]={ class = "PALADIN", level = 12, },
	[213644]={ class = "PALADIN", level = 12, },
	[53595]={ class = "PALADIN", level = 14, },
	[315867]={ class = "PALADIN", level = 16, },
	[105424]={ class = "PALADIN", level = 16, },
	[344172]={ class = "PALADIN", level = 18, },
	[183218]={ class = "PALADIN", level = 18, },
	[272906]={ class = "PALADIN", level = 18, },
	[53563]={ class = "PALADIN", level = 19, },
	[184575]={ class = "PALADIN", level = 19, },
	[317907]={ class = "PALADIN", level = 19, },
	[327980]={ class = "PALADIN", level = 23, },
	[53385]={ class = "PALADIN", level = 23, },
	[53576]={ class = "PALADIN", level = 23, },
	[267344]={ class = "PALADIN", level = 24, },
	[498]={ class = "PALADIN", level = 26, },
	[184662]={ class = "PALADIN", level = 26, },
	[85043]={ class = "PALADIN", level = 27, },
	[183998]={ class = "PALADIN", level = 27, },
	[96231]={ class = "PALADIN", level = 27, },
	[231644]={ class = "PALADIN", level = 29, },
	[231663]={ class = "PALADIN", level = 29, },
	[231667]={ class = "PALADIN", level = 33, },
	[317854]={ class = "PALADIN", level = 33, },
	[327981]={ class = "PALADIN", level = 34, },
	[85222]={ class = "PALADIN", level = 34, },
	[315921]={ class = "PALADIN", level = 34, },
	[31821]={ class = "PALADIN", level = 39, },
	[86659]={ class = "PALADIN", level = 39, },
	[255937]={ class = "PALADIN", level = 39, },
	[31850]={ class = "PALADIN", level = 42, },
	[231642]={ class = "PALADIN", level = 42, },
	[212056]={ class = "PALADIN", level = 44, },
	[231665]={ class = "PALADIN", level = 44, },
	[317912]={ class = "PALADIN", level = 48, },
	[327979]={ class = "PALADIN", level = 48, },
	[161800]={ class = "PALADIN", level = 48, },
	[321136]={ class = "PALADIN", level = 48, },
--++ Paladin Talents ++	
	[223306]={ class = "PALADIN", level = 15, },
	[204019]={ class = "PALADIN", level = 15, },
	[196926]={ class = "PALADIN", level = 15, },
	[343527]={ class = "PALADIN", level = 15, },
	[152261]={ class = "PALADIN", level = 15, },
	[114158]={ class = "PALADIN", level = 15, },
	[280373]={ class = "PALADIN", level = 15, },
	[267610]={ class = "PALADIN", level = 15, },
	[269569]={ class = "PALADIN", level = 15, },
	[231832]={ class = "PALADIN", level = 25, },
	[204023]={ class = "PALADIN", level = 25, },
	[326732]={ class = "PALADIN", level = 25, },
	[203316]={ class = "PALADIN", level = 25, },
	[203776]={ class = "PALADIN", level = 25, },
	[114165]={ class = "PALADIN", level = 25, },
	[327193]={ class = "PALADIN", level = 25, },
	[157047]={ class = "PALADIN", level = 25, },
	[115750]={ class = "PALADIN", level = 30, },
	[234299]={ class = "PALADIN", level = 30, },
	[20066]={ class = "PALADIN", level = 30, },
	[204018]={ class = "PALADIN", level = 35, },
	[230332]={ class = "PALADIN", level = 35, },
	[205191]={ class = "PALADIN", level = 35, },
	[214202]={ class = "PALADIN", level = 35, },
	[114154]={ class = "PALADIN", level = 35, },
	[223817]={ class = "PALADIN", level = 40, },
	[105809]={ class = "PALADIN", level = 40, },
	[152262]={ class = "PALADIN", level = 40, },
	[216331]={ class = "PALADIN", level = 45, },
	[248033]={ class = "PALADIN", level = 45, },
	[204054]={ class = "PALADIN", level = 45, },
	[315924]={ class = "PALADIN", level = 45, },
	[326734]={ class = "PALADIN", level = 45, },
	[183778]={ class = "PALADIN", level = 45, },
	[215661]={ class = "PALADIN", level = 45, },
	[53376]={ class = "PALADIN", level = 45, },
	[85804]={ class = "PALADIN", level = 45, },
	[156910]={ class = "PALADIN", level = 50, },
	[200025]={ class = "PALADIN", level = 50, },
	[231895]={ class = "PALADIN", level = 50, },
	[343721]={ class = "PALADIN", level = 50, },
	[204077]={ class = "PALADIN", level = 50, },
	[325966]={ class = "PALADIN", level = 50, },
	[204074]={ class = "PALADIN", level = 50, },
	[171648]={ class = "PALADIN", level = 50, },
	[317866]={ class = "PALADIN", level = 50, },
--++ Paladin PvP Talents ++	
	[199441]={ class = "PALADIN", level = 20, },
	[210256]={ class = "PALADIN", level = 20, },
	[236186]={ class = "PALADIN", level = 20, },
	[210378]={ class = "PALADIN", level = 20, },
	[210294]={ class = "PALADIN", level = 20, },
	[204914]={ class = "PALADIN", level = 20, },
	[216855]={ class = "PALADIN", level = 20, },
	[216868]={ class = "PALADIN", level = 20, },
	[207028]={ class = "PALADIN", level = 20, },
	[216860]={ class = "PALADIN", level = 20, },
	[204979]={ class = "PALADIN", level = 20, },
	[246806]={ class = "PALADIN", level = 20, },
	[216327]={ class = "PALADIN", level = 20, },
	[215652]={ class = "PALADIN", level = 20, },
	[199542]={ class = "PALADIN", level = 20, },
	[287947]={ class = "PALADIN", level = 20, },
	[210341]={ class = "PALADIN", level = 20, },
	[305394]={ class = "PALADIN", level = 22, },
	[216853]={ class = "PALADIN", level = 24, },
	[210323]={ class = "PALADIN", level = 24, },
	[199428]={ class = "PALADIN", level = 25, },
	[199456]={ class = "PALADIN", level = 25, },
	[199330]={ class = "PALADIN", level = 27, },
	[199324]={ class = "PALADIN", level = 27, },
	[247675]={ class = "PALADIN", level = 30, },
	[199454]={ class = "PALADIN", level = 30, },
	[199452]={ class = "PALADIN", level = 35, },
	[228049]={ class = "PALADIN", level = 40, },
	[204934]={ class = "PALADIN", level = 40, },
--++ Priest Abilities ++	
	[137030]={ class = "PRIEST", level = 1, },
	[585]={ class = "PRIEST", level = 1, },
	[589]={ class = "PRIEST", level = 2, },
	[2061]={ class = "PRIEST", level = 3, },
	[17]={ class = "PRIEST", level = 4, },
	[8092]={ class = "PRIEST", level = 5, },
	[81782]={ class = "PRIEST", level = 5, },
	[21562]={ class = "PRIEST", level = 6, },
	[8122]={ class = "PRIEST", level = 7, },
	[19236]={ class = "PRIEST", level = 8, },
	[586]={ class = "PRIEST", level = 9, },
	[2006]={ class = "PRIEST", level = 10, },
	[32379]={ class = "PRIEST", level = 14, },
	[327821]={ class = "PRIEST", level = 17, },
	[1706]={ class = "PRIEST", level = 21, },
	[2096]={ class = "PRIEST", level = 22, },
	[528]={ class = "PRIEST", level = 24, },
	[327820]={ class = "PRIEST", level = 27, },
	[9484]={ class = "PRIEST", level = 28, },
	[45243]={ class = "PRIEST", level = 33, },
	[605]={ class = "PRIEST", level = 34, },
	[32375]={ class = "PRIEST", level = 42, },
	[322107]={ class = "PRIEST", level = 46, },
	[73325]={ class = "PRIEST", level = 49, },
	[453]={ class = "PRIEST", level = 52, },
	[327830]={ class = "PRIEST", level = 54, },
	[10060]={ class = "PRIEST", level = 58, },
--++ Priest Specializations ++	
	[137032]={ class = "PRIEST", level = 1, },
	[137031]={ class = "PRIEST", level = 1, },
	[137033]={ class = "PRIEST", level = 1, },
	[335467]={ class = "PRIEST", level = 10, },
	[77485]={ class = "PRIEST", level = 10, },
	[271534]={ class = "PRIEST", level = 10, },
	[343690]={ class = "PRIEST", level = 10, },
	[2050]={ class = "PRIEST", level = 11, },
	[15407]={ class = "PRIEST", level = 11, },
	[47540]={ class = "PRIEST", level = 11, },
	[81749]={ class = "PRIEST", level = 12, },
	[139]={ class = "PRIEST", level = 12, },
	[232698]={ class = "PRIEST", level = 12, },
	[319899]={ class = "PRIEST", level = 13, },
	[262861]={ class = "PRIEST", level = 13, },
	[185916]={ class = "PRIEST", level = 14, },
	[2060]={ class = "PRIEST", level = 15, },
	[34914]={ class = "PRIEST", level = 15, },
	[47585]={ class = "PRIEST", level = 16, },
	[231682]={ class = "PRIEST", level = 18, },
	[527]={ class = "PRIEST", level = 18, },
	[213634]={ class = "PRIEST", level = 18, },
	[14914]={ class = "PRIEST", level = 19, },
	[186263]={ class = "PRIEST", level = 19, },
	[34433]={ class = "PRIEST", level = 20, },
	[88625]={ class = "PRIEST", level = 23, },
	[194509]={ class = "PRIEST", level = 23, },
	[228266]={ class = "PRIEST", level = 23, },
	[228260]={ class = "PRIEST", level = 23, },
	[228264]={ class = "PRIEST", level = 23, },
	[15286]={ class = "PRIEST", level = 25, },
	[63733]={ class = "PRIEST", level = 26, },
	[48045]={ class = "PRIEST", level = 26, },
	[341491]={ class = "PRIEST", level = 29, },
	[15487]={ class = "PRIEST", level = 29, },
	[20711]={ class = "PRIEST", level = 29, },
	[47788]={ class = "PRIEST", level = 30, },
	[132157]={ class = "PRIEST", level = 31, },
	[596]={ class = "PRIEST", level = 32, },
	[319904]={ class = "PRIEST", level = 32, },
	[343726]={ class = "PRIEST", level = 32, },
	[212036]={ class = "PRIEST", level = 37, },
	[231688]={ class = "PRIEST", level = 37, },
	[33206]={ class = "PRIEST", level = 38, },
	[204883]={ class = "PRIEST", level = 39, },
	[322115]={ class = "PRIEST", level = 39, },
	[319908]={ class = "PRIEST", level = 39, },
	[341205]={ class = "PRIEST", level = 41, },
	[34861]={ class = "PRIEST", level = 41, },
	[47536]={ class = "PRIEST", level = 41, },
	[285485]={ class = "PRIEST", level = 43, },
	[280752]={ class = "PRIEST", level = 43, },
	[33076]={ class = "PRIEST", level = 43, },
	[322108]={ class = "PRIEST", level = 44, },
	[64843]={ class = "PRIEST", level = 44, },
	[62618]={ class = "PRIEST", level = 44, },
	[322112]={ class = "PRIEST", level = 47, },
	[198068]={ class = "PRIEST", level = 47, },
	[64901]={ class = "PRIEST", level = 47, },
	[322110]={ class = "PRIEST", level = 47, },
	[319912]={ class = "PRIEST", level = 48, },
	[322116]={ class = "PRIEST", level = 48, },
--++ Priest Talents ++	
	[193134]={ class = "PRIEST", level = 15, },
	[321291]={ class = "PRIEST", level = 15, },
	[193155]={ class = "PRIEST", level = 15, },
	[193195]={ class = "PRIEST", level = 15, },
	[341997]={ class = "PRIEST", level = 15, },
	[214621]={ class = "PRIEST", level = 15, },
	[200128]={ class = "PRIEST", level = 15, },
	[265259]={ class = "PRIEST", level = 15, },
	[341273]={ class = "PRIEST", level = 15, },
	[238100]={ class = "PRIEST", level = 25, },
	[121536]={ class = "PRIEST", level = 25, },
	[64129]={ class = "PRIEST", level = 25, },
	[288733]={ class = "PRIEST", level = 25, },
	[193063]={ class = "PRIEST", level = 25, },
	[199855]={ class = "PRIEST", level = 25, },
	[196707]={ class = "PRIEST", level = 30, },
	[238136]={ class = "PRIEST", level = 30, },
	[200209]={ class = "PRIEST", level = 30, },
	[123040]={ class = "PRIEST", level = 30, },
	[238558]={ class = "PRIEST", level = 30, },
	[129250]={ class = "PRIEST", level = 30, },
	[341385]={ class = "PRIEST", level = 30, },
	[197045]={ class = "PRIEST", level = 30, },
	[109142]={ class = "PRIEST", level = 30, },
	[200199]={ class = "PRIEST", level = 35, },
	[205367]={ class = "PRIEST", level = 35, },
	[263716]={ class = "PRIEST", level = 35, },
	[205369]={ class = "PRIEST", level = 35, },
	[64044]={ class = "PRIEST", level = 35, },
	[196704]={ class = "PRIEST", level = 35, },
	[204263]={ class = "PRIEST", level = 35, },
	[155271]={ class = "PRIEST", level = 40, },
	[32546]={ class = "PRIEST", level = 40, },
	[197419]={ class = "PRIEST", level = 40, },
	[321377]={ class = "PRIEST", level = 40, },
	[199484]={ class = "PRIEST", level = 40, },
	[314867]={ class = "PRIEST", level = 40, },
	[342834]={ class = "PRIEST", level = 40, },
	[280391]={ class = "PRIEST", level = 40, },
	[109186]={ class = "PRIEST", level = 40, },
	[193157]={ class = "PRIEST", level = 45, },
	[341374]={ class = "PRIEST", level = 45, },
	[110744]={ class = "PRIEST", level = 45, },
	[120517]={ class = "PRIEST", level = 45, },
	[200174]={ class = "PRIEST", level = 45, },
	[204197]={ class = "PRIEST", level = 45, },
	[263165]={ class = "PRIEST", level = 45, },
	[341240]={ class = "PRIEST", level = 50, },
	[200183]={ class = "PRIEST", level = 50, },
	[246287]={ class = "PRIEST", level = 50, },
	[265202]={ class = "PRIEST", level = 50, },
	[345218]={ class = "PRIEST", level = 50, },
	[238063]={ class = "PRIEST", level = 50, },
	[196985]={ class = "PRIEST", level = 50, },
	[109964]={ class = "PRIEST", level = 50, },
	[319952]={ class = "PRIEST", level = 50, },
--++ Priest PvP Talents ++	
	[197862]={ class = "PRIEST", level = 20, },
	[197871]={ class = "PRIEST", level = 20, },
	[289666]={ class = "PRIEST", level = 20, },
	[213610]={ class = "PRIEST", level = 20, },
	[289657]={ class = "PRIEST", level = 20, },
	[199445]={ class = "PRIEST", level = 20, },
	[235587]={ class = "PRIEST", level = 20, },
	[211522]={ class = "PRIEST", level = 20, },
	[196162]={ class = "PRIEST", level = 20, },
	[196439]={ class = "PRIEST", level = 20, },
	[197268]={ class = "PRIEST", level = 20, },
	[215768]={ class = "PRIEST", level = 20, },
	[197535]={ class = "PRIEST", level = 20, },
	[214205]={ class = "PRIEST", level = 20, },
	[280749]={ class = "PRIEST", level = 20, },
	[108968]={ class = "PRIEST", level = 20, },
	[328530]={ class = "PRIEST", level = 22, },
	[199259]={ class = "PRIEST", level = 23, },
	[236499]={ class = "PRIEST", level = 23, },
	[228630]={ class = "PRIEST", level = 23, },
	[215982]={ class = "PRIEST", level = 29, },
	[213602]={ class = "PRIEST", level = 40, },
	[341167]={ class = "PRIEST", level = 40, },
	[328529]={ class = "PRIEST", level = 43, },
	[197590]={ class = "PRIEST", level = 44, },
	[196611]={ class = "PRIEST", level = 49, },
	[316262]={ class = "PRIEST", level = 50, },
--++ Rogue Abilities ++	
	[56814]={ class = "ROGUE", level = 1, },
	[210108]={ class = "ROGUE", level = 1, },
	[82245]={ class = "ROGUE", level = 1, },
	[137034]={ class = "ROGUE", level = 1, },
	[157442]={ class = "ROGUE", level = 1, },
	[1752]={ class = "ROGUE", level = 1, },
	[196819]={ class = "ROGUE", level = 2, },
	[1833]={ class = "ROGUE", level = 3, },
	[1784]={ class = "ROGUE", level = 3, },
	[31209]={ class = "ROGUE", level = 4, },
	[2983]={ class = "ROGUE", level = 5, },
	[1766]={ class = "ROGUE", level = 6, },
	[8676]={ class = "ROGUE", level = 7, },
	[185311]={ class = "ROGUE", level = 8, },
	[315496]={ class = "ROGUE", level = 9, },
	[315584]={ class = "ROGUE", level = 10, },
	[6770]={ class = "ROGUE", level = 11, },
	[408]={ class = "ROGUE", level = 13, },
	[2836]={ class = "ROGUE", level = 19, },
	[5277]={ class = "ROGUE", level = 21, },
	[1856]={ class = "ROGUE", level = 23, },
	[1804]={ class = "ROGUE", level = 24, },
	[921]={ class = "ROGUE", level = 24, },
	[1860]={ class = "ROGUE", level = 25, },
	[1725]={ class = "ROGUE", level = 28, },
	[231691]={ class = "ROGUE", level = 31, },
	[5938]={ class = "ROGUE", level = 32, },
	[3408]={ class = "ROGUE", level = 33, },
	[1966]={ class = "ROGUE", level = 34, },
	[8679]={ class = "ROGUE", level = 38, },
	[2094]={ class = "ROGUE", level = 39, },
	[31224]={ class = "ROGUE", level = 47, },
	[57934]={ class = "ROGUE", level = 48, },
	[114018]={ class = "ROGUE", level = 49, },
	[5761]={ class = "ROGUE", level = 54, },
--++ Rogue Specializations ++	
	[137037]={ class = "ROGUE", level = 1, },
	[199736]={ class = "ROGUE", level = 1, },
	[137036]={ class = "ROGUE", level = 1, },
	[137035]={ class = "ROGUE", level = 1, },
	[76808]={ class = "ROGUE", level = 10, },
	[76806]={ class = "ROGUE", level = 10, },
	[76803]={ class = "ROGUE", level = 10, },
	[193315]={ class = "ROGUE", level = 10, },
	[1329]={ class = "ROGUE", level = 12, },
	[185763]={ class = "ROGUE", level = 12, },
	[185438]={ class = "ROGUE", level = 12, },
	[279876]={ class = "ROGUE", level = 12, },
	[279877]={ class = "ROGUE", level = 12, },
	[2823]={ class = "ROGUE", level = 13, },
	[53]={ class = "ROGUE", level = 14, },
	[703]={ class = "ROGUE", level = 16, },
	[114014]={ class = "ROGUE", level = 16, },
	[315341]={ class = "ROGUE", level = 17, },
	[1943]={ class = "ROGUE", level = 17, },
	[195457]={ class = "ROGUE", level = 18, },
	[36554]={ class = "ROGUE", level = 18, },
	[13877]={ class = "ROGUE", level = 19, },
	[51723]={ class = "ROGUE", level = 19, },
	[197835]={ class = "ROGUE", level = 19, },
	[2098]={ class = "ROGUE", level = 22, },
	[32645]={ class = "ROGUE", level = 22, },
	[185313]={ class = "ROGUE", level = 22, },
	[58423]={ class = "ROGUE", level = 26, },
	[14161]={ class = "ROGUE", level = 27, },
	[14190]={ class = "ROGUE", level = 27, },
	[196912]={ class = "ROGUE", level = 27, },
	[185565]={ class = "ROGUE", level = 29, },
	[315508]={ class = "ROGUE", level = 29, },
	[212283]={ class = "ROGUE", level = 29, },
	[61329]={ class = "ROGUE", level = 37, },
	[316219]={ class = "ROGUE", level = 37, },
	[79134]={ class = "ROGUE", level = 37, },
	[185314]={ class = "ROGUE", level = 41, },
	[319473]={ class = "ROGUE", level = 41, },
	[79096]={ class = "ROGUE", level = 41, },
	[13750]={ class = "ROGUE", level = 42, },
	[121471]={ class = "ROGUE", level = 42, },
	[79140]={ class = "ROGUE", level = 42, },
	[35551]={ class = "ROGUE", level = 43, },
	[14117]={ class = "ROGUE", level = 43, },
	[245751]={ class = "ROGUE", level = 43, },
	[328077]={ class = "ROGUE", level = 43, },
	[235484]={ class = "ROGUE", level = 44, },
	[231716]={ class = "ROGUE", level = 44, },
	[319066]={ class = "ROGUE", level = 44, },
	[319949]={ class = "ROGUE", level = 46, },
	[231719]={ class = "ROGUE", level = 46, },
	[1776]={ class = "ROGUE", level = 46, },
	[319175]={ class = "ROGUE", level = 52, },
	[331851]={ class = "ROGUE", level = 52, },
	[330542]={ class = "ROGUE", level = 52, },
	[319600]={ class = "ROGUE", level = 56, },
	[319951]={ class = "ROGUE", level = 56, },
	[344362]={ class = "ROGUE", level = 56, },
	[344363]={ class = "ROGUE", level = 58, },
	[319178]={ class = "ROGUE", level = 58, },
	[319032]={ class = "ROGUE", level = 58, },
--++ Rogue Talents ++	
	[328085]={ class = "ROGUE", level = 15, },
	[193640]={ class = "ROGUE", level = 15, },
	[196937]={ class = "ROGUE", level = 15, },
	[200758]={ class = "ROGUE", level = 15, },
	[196864]={ class = "ROGUE", level = 15, },
	[343160]={ class = "ROGUE", level = 15, },
	[196938]={ class = "ROGUE", level = 15, },
	[193537]={ class = "ROGUE", level = 15, },
	[200733]={ class = "ROGUE", level = 15, },
	[196924]={ class = "ROGUE", level = 25, },
	[196922]={ class = "ROGUE", level = 25, },
	[255989]={ class = "ROGUE", level = 25, },
	[14062]={ class = "ROGUE", level = 25, },
	[256188]={ class = "ROGUE", level = 25, },
	[108209]={ class = "ROGUE", level = 25, },
	[108208]={ class = "ROGUE", level = 25, },
	[193531]={ class = "ROGUE", level = 30, },
	[137619]={ class = "ROGUE", level = 30, },
	[14983]={ class = "ROGUE", level = 30, },
	[31230]={ class = "ROGUE", level = 35, },
	[79008]={ class = "ROGUE", level = 35, },
	[193546]={ class = "ROGUE", level = 35, },
	[280716]={ class = "ROGUE", level = 35, },
	[200759]={ class = "ROGUE", level = 35, },
	[256165]={ class = "ROGUE", level = 40, },
	[108216]={ class = "ROGUE", level = 40, },
	[154904]={ class = "ROGUE", level = 40, },
	[196861]={ class = "ROGUE", level = 40, },
	[277953]={ class = "ROGUE", level = 40, },
	[131511]={ class = "ROGUE", level = 40, },
	[257505]={ class = "ROGUE", level = 40, },
	[193539]={ class = "ROGUE", level = 45, },
	[245687]={ class = "ROGUE", level = 45, },
	[343142]={ class = "ROGUE", level = 45, },
	[238104]={ class = "ROGUE", level = 45, },
	[200806]={ class = "ROGUE", level = 45, },
	[256170]={ class = "ROGUE", level = 45, },
	[152152]={ class = "ROGUE", level = 45, },
	[271877]={ class = "ROGUE", level = 50, },
	[121411]={ class = "ROGUE", level = 50, },
	[272026]={ class = "ROGUE", level = 50, },
	[270061]={ class = "ROGUE", level = 50, },
	[51690]={ class = "ROGUE", level = 50, },
	[196976]={ class = "ROGUE", level = 50, },
	[255544]={ class = "ROGUE", level = 50, },
	[280719]={ class = "ROGUE", level = 50, },
	[277925]={ class = "ROGUE", level = 50, },
--++ Rogue PvP Talents ++	
	[209752]={ class = "ROGUE", level = 20, },
	[212035]={ class = "ROGUE", level = 20, },
	[198675]={ class = "ROGUE", level = 20, },
	[269513]={ class = "ROGUE", level = 20, },
	[207777]={ class = "ROGUE", level = 20, },
	[212210]={ class = "ROGUE", level = 20, },
	[197000]={ class = "ROGUE", level = 20, },
	[197050]={ class = "ROGUE", level = 20, },
	[206328]={ class = "ROGUE", level = 20, },
	[198529]={ class = "ROGUE", level = 20, },
	[197899]={ class = "ROGUE", level = 20, },
	[198020]={ class = "ROGUE", level = 20, },
	[198952]={ class = "ROGUE", level = 20, },
	[198145]={ class = "ROGUE", level = 22, },
	[198128]={ class = "ROGUE", level = 25, },
	[212182]={ class = "ROGUE", level = 25, },
	[212081]={ class = "ROGUE", level = 25, },
	[197007]={ class = "ROGUE", level = 27, },
	[198265]={ class = "ROGUE", level = 29, },
	[198092]={ class = "ROGUE", level = 30, },
	[213981]={ class = "ROGUE", level = 35, },
	[212217]={ class = "ROGUE", level = 35, },
	[198032]={ class = "ROGUE", level = 40, },
	[207736]={ class = "ROGUE", level = 40, },
	[221622]={ class = "ROGUE", level = 48, },
--++ Shaman Abilities ++	
	[328928]={ class = "SHAMAN", level = 1, },
	[328930]={ class = "SHAMAN", level = 1, },
	[137038]={ class = "SHAMAN", level = 1, },
	[320747]={ class = "SHAMAN", level = 1, },
	[188196]={ class = "SHAMAN", level = 1, },
	[73899]={ class = "SHAMAN", level = 2, },
	[188389]={ class = "SHAMAN", level = 3, },
	[8004]={ class = "SHAMAN", level = 4, },
	[2484]={ class = "SHAMAN", level = 5, },
	[318044]={ class = "SHAMAN", level = 6, },
	[318038]={ class = "SHAMAN", level = 7, },
	[20608]={ class = "SHAMAN", level = 8, },
	[192106]={ class = "SHAMAN", level = 9, },
	[2645]={ class = "SHAMAN", level = 10, },
	[57994]={ class = "SHAMAN", level = 12, },
	[2008]={ class = "SHAMAN", level = 13, },
	[6196]={ class = "SHAMAN", level = 14, },
	[196840]={ class = "SHAMAN", level = 17, },
	[1064]={ class = "SHAMAN", level = 21, },
	[192058]={ class = "SHAMAN", level = 23, },
	[188443]={ class = "SHAMAN", level = 24, },
	[5394]={ class = "SHAMAN", level = 28, },
	[556]={ class = "SHAMAN", level = 32, },
	[546]={ class = "SHAMAN", level = 33, },
	[198103]={ class = "SHAMAN", level = 37, },
	[370]={ class = "SHAMAN", level = 39, },
	[51514]={ class = "SHAMAN", level = 41, },
	[210873]={ class = "SHAMAN", level = 41, },
	[211004]={ class = "SHAMAN", level = 41, },
	[211010]={ class = "SHAMAN", level = 41, },
	[211015]={ class = "SHAMAN", level = 41, },
	[269352]={ class = "SHAMAN", level = 41, },
	[277778]={ class = "SHAMAN", level = 41, },
	[277784]={ class = "SHAMAN", level = 41, },
	[309328]={ class = "SHAMAN", level = 41, },
	[108271]={ class = "SHAMAN", level = 42, },
	[319352]={ class = "SHAMAN", level = 46, },
	[8143]={ class = "SHAMAN", level = 47, },
	[2825]={ class = "SHAMAN", level = 48, },
	[32182]={ class = "SHAMAN", level = 48, },
	[343196]={ class = "SHAMAN", level = 54, },
	[343198]={ class = "SHAMAN", level = 56, },
--++ Shaman Specializations ++	
	[212048]={ class = "SHAMAN", level = 1, },
	[137040]={ class = "SHAMAN", level = 1, },
	[137041]={ class = "SHAMAN", level = 1, },
	[137039]={ class = "SHAMAN", level = 1, },
	[157444]={ class = "SHAMAN", level = 10, },
	[86629]={ class = "SHAMAN", level = 10, },
	[8042]={ class = "SHAMAN", level = 10, },
	[190488]={ class = "SHAMAN", level = 10, },
	[187828]={ class = "SHAMAN", level = 10, },
	[343725]={ class = "SHAMAN", level = 10, },
	[77226]={ class = "SHAMAN", level = 10, },
	[168534]={ class = "SHAMAN", level = 10, },
	[77223]={ class = "SHAMAN", level = 10, },
	[61295]={ class = "SHAMAN", level = 10, },
	[33757]={ class = "SHAMAN", level = 10, },
	[51505]={ class = "SHAMAN", level = 11, },
	[60103]={ class = "SHAMAN", level = 11, },
	[51886]={ class = "SHAMAN", level = 18, },
	[77130]={ class = "SHAMAN", level = 18, },
	[231721]={ class = "SHAMAN", level = 20, },
	[17364]={ class = "SHAMAN", level = 20, },
	[51564]={ class = "SHAMAN", level = 20, },
	[334033]={ class = "SHAMAN", level = 22, },
	[231780]={ class = "SHAMAN", level = 23, },
	[60188]={ class = "SHAMAN", level = 27, },
	[77472]={ class = "SHAMAN", level = 27, },
	[201845]={ class = "SHAMAN", level = 27, },
	[231785]={ class = "SHAMAN", level = 27, },
	[77756]={ class = "SHAMAN", level = 29, },
	[187880]={ class = "SHAMAN", level = 29, },
	[51533]={ class = "SHAMAN", level = 34, },
	[198067]={ class = "SHAMAN", level = 34, },
	[73920]={ class = "SHAMAN", level = 34, },
	[16196]={ class = "SHAMAN", level = 37, },
	[187874]={ class = "SHAMAN", level = 38, },
	[61882]={ class = "SHAMAN", level = 38, },
	[16191]={ class = "SHAMAN", level = 38, },
	[52127]={ class = "SHAMAN", level = 41, },
	[231722]={ class = "SHAMAN", level = 43, },
	[98008]={ class = "SHAMAN", level = 43, },
	[319930]={ class = "SHAMAN", level = 43, },
	[58875]={ class = "SHAMAN", level = 44, },
	[79206]={ class = "SHAMAN", level = 44, },
	[108280]={ class = "SHAMAN", level = 49, },
	[51490]={ class = "SHAMAN", level = 49, },
	[8512]={ class = "SHAMAN", level = 49, },
	[334308]={ class = "SHAMAN", level = 52, },
	[343190]={ class = "SHAMAN", level = 52, },
	[343182]={ class = "SHAMAN", level = 52, },
	[343226]={ class = "SHAMAN", level = 58, },
	[343205]={ class = "SHAMAN", level = 58, },
	[343211]={ class = "SHAMAN", level = 58, },
--++ Shaman Talents ++	
	[170374]={ class = "SHAMAN", level = 15, },
	[333919]={ class = "SHAMAN", level = 15, },
	[117014]={ class = "SHAMAN", level = 15, },
	[262647]={ class = "SHAMAN", level = 15, },
	[334046]={ class = "SHAMAN", level = 15, },
	[342243]={ class = "SHAMAN", level = 15, },
	[200072]={ class = "SHAMAN", level = 15, },
	[200071]={ class = "SHAMAN", level = 15, },
	[273221]={ class = "SHAMAN", level = 25, },
	[200076]={ class = "SHAMAN", level = 25, },
	[108283]={ class = "SHAMAN", level = 25, },
	[320125]={ class = "SHAMAN", level = 25, },
	[201900]={ class = "SHAMAN", level = 25, },
	[342240]={ class = "SHAMAN", level = 25, },
	[344357]={ class = "SHAMAN", level = 25, },
	[320746]={ class = "SHAMAN", level = 25, },
	[974]={ class = "SHAMAN", level = 30, },
	[51485]={ class = "SHAMAN", level = 30, },
	[260878]={ class = "SHAMAN", level = 30, },
	[265046]={ class = "SHAMAN", level = 30, },
	[207399]={ class = "SHAMAN", level = 35, },
	[207401]={ class = "SHAMAN", level = 35, },
	[198838]={ class = "SHAMAN", level = 35, },
	[210853]={ class = "SHAMAN", level = 35, },
	[333974]={ class = "SHAMAN", level = 35, },
	[334195]={ class = "SHAMAN", level = 35, },
	[192222]={ class = "SHAMAN", level = 35, },
	[16166]={ class = "SHAMAN", level = 35, },
	[192249]={ class = "SHAMAN", level = 35, },
	[108281]={ class = "SHAMAN", level = 40, },
	[196884]={ class = "SHAMAN", level = 40, },
	[192088]={ class = "SHAMAN", level = 40, },
	[30884]={ class = "SHAMAN", level = 40, },
	[192077]={ class = "SHAMAN", level = 40, },
	[157153]={ class = "SHAMAN", level = 45, },
	[192246]={ class = "SHAMAN", level = 45, },
	[207778]={ class = "SHAMAN", level = 45, },
	[280614]={ class = "SHAMAN", level = 45, },
	[210714]={ class = "SHAMAN", level = 45, },
	[117013]={ class = "SHAMAN", level = 45, },
	[320137]={ class = "SHAMAN", level = 45, },
	[197214]={ class = "SHAMAN", level = 45, },
	[262303]={ class = "SHAMAN", level = 45, },
	[114050]={ class = "SHAMAN", level = 50, },
	[114051]={ class = "SHAMAN", level = 50, },
	[114052]={ class = "SHAMAN", level = 50, },
	[188089]={ class = "SHAMAN", level = 50, },
	[262624]={ class = "SHAMAN", level = 50, },
	[157154]={ class = "SHAMAN", level = 50, },
	[191634]={ class = "SHAMAN", level = 50, },
	[260895]={ class = "SHAMAN", level = 50, },
	[197995]={ class = "SHAMAN", level = 50, },
--++ Shaman PvP Talents ++	
	[204393]={ class = "SHAMAN", level = 20, },
	[204331]={ class = "SHAMAN", level = 20, },
	[204385]={ class = "SHAMAN", level = 20, },
	[204247]={ class = "SHAMAN", level = 20, },
	[289874]={ class = "SHAMAN", level = 20, },
	[204261]={ class = "SHAMAN", level = 20, },
	[204264]={ class = "SHAMAN", level = 20, },
	[204366]={ class = "SHAMAN", level = 20, },
	[290250]={ class = "SHAMAN", level = 21, },
	[236501]={ class = "SHAMAN", level = 21, },
	[204336]={ class = "SHAMAN", level = 30, },
	[305483]={ class = "SHAMAN", level = 35, },
	[206642]={ class = "SHAMAN", level = 39, },
	[204330]={ class = "SHAMAN", level = 40, },
	[204268]={ class = "SHAMAN", level = 41, },
	[210918]={ class = "SHAMAN", level = 42, },
	[204293]={ class = "SHAMAN", level = 43, },
	[290254]={ class = "SHAMAN", level = 44, },
	[193876]={ class = "SHAMAN", level = 48, },
	[204403]={ class = "SHAMAN", level = 49, },
--++ Warlock Abilities ++	
	[23161]={ class = "WARLOCK", level = 1, },
	[5784]={ class = "WARLOCK", level = 1, },
	[137042]={ class = "WARLOCK", level = 1, },
	[686]={ class = "WARLOCK", level = 1, },
	[172]={ class = "WARLOCK", level = 2, },
	[246985]={ class = "WARLOCK", level = 3, },
	[688]={ class = "WARLOCK", level = 3, },
	[104773]={ class = "WARLOCK", level = 4, },
	[5782]={ class = "WARLOCK", level = 5, },
	[702]={ class = "WARLOCK", level = 6, },
	[6201]={ class = "WARLOCK", level = 7, },
	[755]={ class = "WARLOCK", level = 8, },
	[234153]={ class = "WARLOCK", level = 9, },
	[93375]={ class = "WARLOCK", level = 10, },
	[697]={ class = "WARLOCK", level = 10, },
	[334275]={ class = "WARLOCK", level = 12, },
	[126]={ class = "WARLOCK", level = 17, },
	[5697]={ class = "WARLOCK", level = 18, },
	[712]={ class = "WARLOCK", level = 19, },
	[1098]={ class = "WARLOCK", level = 21, },
	[333889]={ class = "WARLOCK", level = 22, },
	[691]={ class = "WARLOCK", level = 23, },
	[108370]={ class = "WARLOCK", level = 24, },
	[119898]={ class = "WARLOCK", level = 29, },
	[342601]={ class = "WARLOCK", level = 31, },
	[20707]={ class = "WARLOCK", level = 32, },
	[698]={ class = "WARLOCK", level = 33, },
	[1714]={ class = "WARLOCK", level = 34, },
	[30283]={ class = "WARLOCK", level = 38, },
	[317138]={ class = "WARLOCK", level = 39, },
	[48018]={ class = "WARLOCK", level = 41, },
	[268358]={ class = "WARLOCK", level = 41, },
	[48020]={ class = "WARLOCK", level = 41, },
	[288843]={ class = "WARLOCK", level = 44, },
	[710]={ class = "WARLOCK", level = 46, },
	[29893]={ class = "WARLOCK", level = 47, },
	[111771]={ class = "WARLOCK", level = 49, },
	[342914]={ class = "WARLOCK", level = 52, },
--++ Warlock Specializations ++	
	[137043]={ class = "WARLOCK", level = 1, },
	[137044]={ class = "WARLOCK", level = 1, },
	[137046]={ class = "WARLOCK", level = 1, },
	[105174]={ class = "WARLOCK", level = 1, },
	[980]={ class = "WARLOCK", level = 10, },
	[116858]={ class = "WARLOCK", level = 10, },
	[29722]={ class = "WARLOCK", level = 10, },
	[77220]={ class = "WARLOCK", level = 10, },
	[77219]={ class = "WARLOCK", level = 10, },
	[77215]={ class = "WARLOCK", level = 10, },
	[348]={ class = "WARLOCK", level = 11, },
	[324536]={ class = "WARLOCK", level = 11, },
	[30146]={ class = "WARLOCK", level = 12, },
	[104316]={ class = "WARLOCK", level = 13, },
	[17962]={ class = "WARLOCK", level = 13, },
	[316099]={ class = "WARLOCK", level = 13, },
	[196406]={ class = "WARLOCK", level = 14, },
	[317031]={ class = "WARLOCK", level = 14, },
	[264178]={ class = "WARLOCK", level = 14, },
	[231793]={ class = "WARLOCK", level = 23, },
	[80240]={ class = "WARLOCK", level = 27, },
	[196277]={ class = "WARLOCK", level = 27, },
	[27243]={ class = "WARLOCK", level = 27, },
	[231792]={ class = "WARLOCK", level = 28, },
	[267102]={ class = "WARLOCK", level = 28, },
	[5740]={ class = "WARLOCK", level = 28, },
	[205180]={ class = "WARLOCK", level = 42, },
	[265187]={ class = "WARLOCK", level = 42, },
	[1122]={ class = "WARLOCK", level = 42, },
	[108415]={ class = "WARLOCK", level = 43, },
	[231791]={ class = "WARLOCK", level = 43, },
	[231811]={ class = "WARLOCK", level = 48, },
	[334727]={ class = "WARLOCK", level = 54, },
	[334342]={ class = "WARLOCK", level = 54, },
	[335174]={ class = "WARLOCK", level = 54, },
	[334591]={ class = "WARLOCK", level = 56, },
	[335189]={ class = "WARLOCK", level = 56, },
	[334315]={ class = "WARLOCK", level = 56, },
	[334585]={ class = "WARLOCK", level = 58, },
	[335175]={ class = "WARLOCK", level = 58, },
--++ Warlock Talents ++	
	[267211]={ class = "WARLOCK", level = 15, },
	[267171]={ class = "WARLOCK", level = 15, },
	[198590]={ class = "WARLOCK", level = 15, },
	[264078]={ class = "WARLOCK", level = 15, },
	[196412]={ class = "WARLOCK", level = 15, },
	[267115]={ class = "WARLOCK", level = 15, },
	[334319]={ class = "WARLOCK", level = 15, },
	[108558]={ class = "WARLOCK", level = 15, },
	[6353]={ class = "WARLOCK", level = 15, },
	[196103]={ class = "WARLOCK", level = 25, },
	[205145]={ class = "WARLOCK", level = 25, },
	[603]={ class = "WARLOCK", level = 25, },
	[266134]={ class = "WARLOCK", level = 25, },
	[264130]={ class = "WARLOCK", level = 25, },
	[205148]={ class = "WARLOCK", level = 25, },
	[17877]={ class = "WARLOCK", level = 25, },
	[196102]={ class = "WARLOCK", level = 25, },
	[111400]={ class = "WARLOCK", level = 30, },
	[108416]={ class = "WARLOCK", level = 30, },
	[219272]={ class = "WARLOCK", level = 30, },
	[152108]={ class = "WARLOCK", level = 35, },
	[196408]={ class = "WARLOCK", level = 35, },
	[267170]={ class = "WARLOCK", level = 35, },
	[270545]={ class = "WARLOCK", level = 35, },
	[205179]={ class = "WARLOCK", level = 35, },
	[264057]={ class = "WARLOCK", level = 35, },
	[196226]={ class = "WARLOCK", level = 35, },
	[264119]={ class = "WARLOCK", level = 35, },
	[278350]={ class = "WARLOCK", level = 35, },
	[264874]={ class = "WARLOCK", level = 40, },
	[5484]={ class = "WARLOCK", level = 40, },
	[6789]={ class = "WARLOCK", level = 40, },
	[334183]={ class = "WARLOCK", level = 45, },
	[108503]={ class = "WARLOCK", level = 45, },
	[111898]={ class = "WARLOCK", level = 45, },
	[48181]={ class = "WARLOCK", level = 45, },
	[267216]={ class = "WARLOCK", level = 45, },
	[266086]={ class = "WARLOCK", level = 45, },
	[205184]={ class = "WARLOCK", level = 45, },
	[215941]={ class = "WARLOCK", level = 45, },
	[196447]={ class = "WARLOCK", level = 50, },
	[264000]={ class = "WARLOCK", level = 50, },
	[113858]={ class = "WARLOCK", level = 50, },
	[113860]={ class = "WARLOCK", level = 50, },
	[267215]={ class = "WARLOCK", level = 50, },
	[267217]={ class = "WARLOCK", level = 50, },
	[267214]={ class = "WARLOCK", level = 50, },
--++ Warlock PvP Talents ++	
	[328774]={ class = "WARLOCK", level = 20, },
	[199954]={ class = "WARLOCK", level = 20, },
	[234877]={ class = "WARLOCK", level = 20, },
	[212459]={ class = "WARLOCK", level = 20, },
	[212619]={ class = "WARLOCK", level = 20, },
	[201996]={ class = "WARLOCK", level = 20, },
	[221711]={ class = "WARLOCK", level = 20, },
	[200586]={ class = "WARLOCK", level = 20, },
	[248855]={ class = "WARLOCK", level = 20, },
	[212295]={ class = "WARLOCK", level = 20, },
	[212618]={ class = "WARLOCK", level = 20, },
	[212371]={ class = "WARLOCK", level = 20, },
	[221703]={ class = "WARLOCK", level = 23, },
	[200546]={ class = "WARLOCK", level = 30, },
	[212282]={ class = "WARLOCK", level = 30, },
	[285933]={ class = "WARLOCK", level = 30, },
	[335052]={ class = "WARLOCK", level = 30, },
	[212623]={ class = "WARLOCK", level = 30, },
	[233577]={ class = "WARLOCK", level = 40, },
	[212628]={ class = "WARLOCK", level = 40, },
	[212356]={ class = "WARLOCK", level = 40, },
	[264106]={ class = "WARLOCK", level = 45, },
--++ Warrior Abilities ++	
	[115767]={ class = "WARRIOR", level = 1, },
	[296087]={ class = "WARRIOR", level = 1, },
	[294184]={ class = "WARRIOR", level = 1, },
	[294189]={ class = "WARRIOR", level = 1, },
	[137047]={ class = "WARRIOR", level = 1, },
	[88163]={ class = "WARRIOR", level = 1, },
	[123829]={ class = "WARRIOR", level = 1, },
	[3127]={ class = "WARRIOR", level = 1, },
	[1464]={ class = "WARRIOR", level = 1, },
	[100]={ class = "WARRIOR", level = 2, },
	[23922]={ class = "WARRIOR", level = 3, },
	[1715]={ class = "WARRIOR", level = 4, },
	[34428]={ class = "WARRIOR", level = 5, },
	[2565]={ class = "WARRIOR", level = 6, },
	[6552]={ class = "WARRIOR", level = 7, },
	[319157]={ class = "WARRIOR", level = 8, },
	[1680]={ class = "WARRIOR", level = 9, },
	[163201]={ class = "WARRIOR", level = 10, },
	[319158]={ class = "WARRIOR", level = 11, },
	[355]={ class = "WARRIOR", level = 14, },
	[190456]={ class = "WARRIOR", level = 17, },
	[231847]={ class = "WARRIOR", level = 22, },
	[57755]={ class = "WARRIOR", level = 24, },
	[18499]={ class = "WARRIOR", level = 29, },
	[6544]={ class = "WARRIOR", level = 33, },
	[5246]={ class = "WARRIOR", level = 34, },
	[6673]={ class = "WARRIOR", level = 39, },
	[64382]={ class = "WARRIOR", level = 41, },
	[3411]={ class = "WARRIOR", level = 43, },
	[97462]={ class = "WARRIOR", level = 46, },
	[23920]={ class = "WARRIOR", level = 47, },
	[1161]={ class = "WARRIOR", level = 54, },
	[316825]={ class = "WARRIOR", level = 56, },
--++ Warrior Specializations ++	
	[137049]={ class = "WARRIOR", level = 1, },
	[137050]={ class = "WARRIOR", level = 1, },
	[325446]={ class = "WARRIOR", level = 1, },
	[137048]={ class = "WARRIOR", level = 1, },
	[5308]={ class = "WARRIOR", level = 9, },
	[190411]={ class = "WARRIOR", level = 9, },
	[23881]={ class = "WARRIOR", level = 10, },
	[231842]={ class = "WARRIOR", level = 10, },
	[184361]={ class = "WARRIOR", level = 10, },
	[76857]={ class = "WARRIOR", level = 10, },
	[262111]={ class = "WARRIOR", level = 10, },
	[76856]={ class = "WARRIOR", level = 10, },
	[12294]={ class = "WARRIOR", level = 10, },
	[316523]={ class = "WARRIOR", level = 10, },
	[7384]={ class = "WARRIOR", level = 12, },
	[85288]={ class = "WARRIOR", level = 12, },
	[6572]={ class = "WARRIOR", level = 12, },
	[316402]={ class = "WARRIOR", level = 13, },
	[316405]={ class = "WARRIOR", level = 13, },
	[20243]={ class = "WARRIOR", level = 14, },
	[81099]={ class = "WARRIOR", level = 14, },
	[46917]={ class = "WARRIOR", level = 14, },
	[231830]={ class = "WARRIOR", level = 18, },
	[316403]={ class = "WARRIOR", level = 18, },
	[167105]={ class = "WARRIOR", level = 19, },
	[184367]={ class = "WARRIOR", level = 19, },
	[209694]={ class = "WARRIOR", level = 19, },
	[6343]={ class = "WARRIOR", level = 19, },
	[316424]={ class = "WARRIOR", level = 20, },
	[261901]={ class = "WARRIOR", level = 20, },
	[71]={ class = "WARRIOR", level = 20, },
	[12323]={ class = "WARRIOR", level = 21, },
	[46968]={ class = "WARRIOR", level = 21, },
	[260708]={ class = "WARRIOR", level = 22, },
	[316435]={ class = "WARRIOR", level = 22, },
	[118038]={ class = "WARRIOR", level = 23, },
	[184364]={ class = "WARRIOR", level = 23, },
	[871]={ class = "WARRIOR", level = 23, },
	[1160]={ class = "WARRIOR", level = 27, },
	[316452]={ class = "WARRIOR", level = 27, },
	[279423]={ class = "WARRIOR", level = 27, },
	[316440]={ class = "WARRIOR", level = 28, },
	[316412]={ class = "WARRIOR", level = 28, },
	[231834]={ class = "WARRIOR", level = 28, },
	[316778]={ class = "WARRIOR", level = 29, },
	[316474]={ class = "WARRIOR", level = 32, },
	[184783]={ class = "WARRIOR", level = 32, },
	[316411]={ class = "WARRIOR", level = 37, },
	[316414]={ class = "WARRIOR", level = 37, },
	[12950]={ class = "WARRIOR", level = 37, },
	[227847]={ class = "WARRIOR", level = 38, },
	[12975]={ class = "WARRIOR", level = 38, },
	[1719]={ class = "WARRIOR", level = 38, },
	[316453]={ class = "WARRIOR", level = 42, },
	[161798]={ class = "WARRIOR", level = 42, },
	[316432]={ class = "WARRIOR", level = 42, },
	[261900]={ class = "WARRIOR", level = 44, },
	[316519]={ class = "WARRIOR", level = 44, },
	[316790]={ class = "WARRIOR", level = 44, },
	[316537]={ class = "WARRIOR", level = 48, },
	[316534]={ class = "WARRIOR", level = 48, },
	[316428]={ class = "WARRIOR", level = 48, },
	[316464]={ class = "WARRIOR", level = 49, },
	[316425]={ class = "WARRIOR", level = 49, },
	[316441]={ class = "WARRIOR", level = 49, },
	[316438]={ class = "WARRIOR", level = 52, },
	[315948]={ class = "WARRIOR", level = 52, },
	[316828]={ class = "WARRIOR", level = 52, },
	[231827]={ class = "WARRIOR", level = 58, },
	[316834]={ class = "WARRIOR", level = 58, },
	[316433]={ class = "WARRIOR", level = 58, },
--++ Warrior Talents ++	
	[236279]={ class = "WARRIOR", level = 15, },
	[215568]={ class = "WARRIOR", level = 15, },
	[275334]={ class = "WARRIOR", level = 15, },
	[260643]={ class = "WARRIOR", level = 15, },
	[29725]={ class = "WARRIOR", level = 15, },
	[280721]={ class = "WARRIOR", level = 15, },
	[262231]={ class = "WARRIOR", level = 15, },
	[316733]={ class = "WARRIOR", level = 15, },
	[346002]={ class = "WARRIOR", level = 15, },
	[103827]={ class = "WARRIOR", level = 25, },
	[202168]={ class = "WARRIOR", level = 25, },
	[275339]={ class = "WARRIOR", level = 25, },
	[107570]={ class = "WARRIOR", level = 25, },
	[202560]={ class = "WARRIOR", level = 30, },
	[202743]={ class = "WARRIOR", level = 30, },
	[202316]={ class = "WARRIOR", level = 30, },
	[335077]={ class = "WARRIOR", level = 30, },
	[206315]={ class = "WARRIOR", level = 30, },
	[281001]={ class = "WARRIOR", level = 30, },
	[315720]={ class = "WARRIOR", level = 30, },
	[772]={ class = "WARRIOR", level = 30, },
	[202163]={ class = "WARRIOR", level = 35, },
	[203201]={ class = "WARRIOR", level = 35, },
	[197690]={ class = "WARRIOR", level = 35, },
	[202224]={ class = "WARRIOR", level = 35, },
	[275338]={ class = "WARRIOR", level = 35, },
	[29838]={ class = "WARRIOR", level = 35, },
	[208154]={ class = "WARRIOR", level = 35, },
	[845]={ class = "WARRIOR", level = 40, },
	[334779]={ class = "WARRIOR", level = 40, },
	[335070]={ class = "WARRIOR", level = 40, },
	[215571]={ class = "WARRIOR", level = 40, },
	[202095]={ class = "WARRIOR", level = 40, },
	[202561]={ class = "WARRIOR", level = 40, },
	[335091]={ class = "WARRIOR", level = 40, },
	[262161]={ class = "WARRIOR", level = 40, },
	[107574]={ class = "WARRIOR", level = 45, },
	[46924]={ class = "WARRIOR", level = 45, },
	[262228]={ class = "WARRIOR", level = 45, },
	[118000]={ class = "WARRIOR", level = 45, },
	[248621]={ class = "WARRIOR", level = 45, },
	[202603]={ class = "WARRIOR", level = 45, },
	[280392]={ class = "WARRIOR", level = 45, },
	[228920]={ class = "WARRIOR", level = 45, },
	[275336]={ class = "WARRIOR", level = 45, },
	[152278]={ class = "WARRIOR", level = 50, },
	[280001]={ class = "WARRIOR", level = 50, },
	[262150]={ class = "WARRIOR", level = 50, },
	[203177]={ class = "WARRIOR", level = 50, },
	[152277]={ class = "WARRIOR", level = 50, },
	[202751]={ class = "WARRIOR", level = 50, },
	[280772]={ class = "WARRIOR", level = 50, },
--++ Warrior PvP Talents ++	
	[213857]={ class = "WARRIOR", level = 20, },
	[329038]={ class = "WARRIOR", level = 20, },
	[213871]={ class = "WARRIOR", level = 20, },
	[198500]={ class = "WARRIOR", level = 20, },
	[199261]={ class = "WARRIOR", level = 20, },
	[236077]={ class = "WARRIOR", level = 20, },
	[206572]={ class = "WARRIOR", level = 20, },
	[198877]={ class = "WARRIOR", level = 20, },
	[205800]={ class = "WARRIOR", level = 20, },
	[198807]={ class = "WARRIOR", level = 20, },
	[198817]={ class = "WARRIOR", level = 20, },
	[198912]={ class = "WARRIOR", level = 20, },
	[280747]={ class = "WARRIOR", level = 20, },
	[199127]={ class = "WARRIOR", level = 20, },
	[199045]={ class = "WARRIOR", level = 20, },
	[236320]={ class = "WARRIOR", level = 20, },
	[199023]={ class = "WARRIOR", level = 27, },
	[280745]={ class = "WARRIOR", level = 33, },
	[199086]={ class = "WARRIOR", level = 33, },
	[236308]={ class = "WARRIOR", level = 38, },
	[236273]={ class = "WARRIOR", level = 40, },
	[329033]={ class = "WARRIOR", level = 41, },
	[329035]={ class = "WARRIOR", level = 45, },
	[235941]={ class = "WARRIOR", level = 46, },
	[213915]={ class = "WARRIOR", level = 47, },
};