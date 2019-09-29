-- Configuration
local on = 1 -- Enables auto-follow. 1 - on, nil - off.
local whispCommand = "!plz" -- The whisper command to trigger the follow.

-- Local Table
local aName, aTable = ...

function aTable:OnEvent(event, ...)
	local msg, name = ...

	if event == "CHAT_MSG_WHISPER" then
		aTable.FMP(msg, name)
	end
	
end

function aTable.FMP(msg, name)
	local author = name:gsub("%-.+", "") -- You can thank the WoW forum user Choonster of Frostmourne for this fix.
	if msg == whispCommand then
		if UnitInParty(author) then
			FollowUnit(author)
			SendChatMessage("Lead On!", "WHISPER", nil, name)
		else
			SendChatMessage(UnitName("player").." isn't in your group. Sorry.", "WHISPER", nil, name)
		end
	else
		return
	end
end

-- Need a frame to attach to.
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("AUTOFOLLOW_BEGIN")
f:RegisterEvent("AUTOFOLLOW_END")
f:SetScript("OnEvent", aTable.OnEvent)
