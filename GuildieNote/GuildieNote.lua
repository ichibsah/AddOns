if not LoginLogoutFrame then
	LoginLogoutFrame = CreateFrame("Frame")
end

local GuildieNote = LoginLogoutFrame

STRING_ONLINE = ERR_FRIEND_ONLINE_SS:gsub("%%s", "(.-)"):gsub("[%[%]]", "%%%1")

GuildieNote:RegisterEvent("CHAT_MSG_SYSTEM")
GuildieNote:SetScript("OnEvent", function(self, event, ...) 
	local system_msg = select(1, ...)
	--local name = string.match(system_msg, "^.*%[(.*)%].* has come online")
	local _, name = strmatch(system_msg, STRING_ONLINE)
	local realm = GetRealmName():gsub("%s+", "");
	if name then
		GuildRoster();
		note = GetGuildieInfoByName(name .. "-" .. realm);
		if (strlen(note) > 0) then
			--DEFAULT_CHAT_FRAME:AddMessage(note);
			DoMessage(note);
		end
	end
end)

function GetGuildieInfoByName(name)
	local numTotal, numOnline = GetNumGuildMembers();
	local result = "";
	for i = 1, numTotal do
		local fname, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i);
		if (fname == name) then
			result = name;
			if (strlen(note) > 0) then
				result = result .. strchar(13) .. "Note: " .. note;
			end
			if (strlen(officernote) > 0) then
				result = result .. strchar(13) .. "Officer's note: " .. officernote;
			end
			if (strlen(rank) > 0) then
				result = result .. strchar(13) .. "Rank: " .. rank .. " [" .. rankIndex .. "]";
			end
		end
	end
	
	return result;
end

DoMessage = function (str, ...)
	if ... then str = str:format(...) end
	DEFAULT_CHAT_FRAME:AddMessage(("%s"):format(str));
end

DoMessage("GuildieNote loaded");
