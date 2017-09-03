GRT_SavedVars = {}
GRT_Title = "Guild Repairs Toggle"
GRT_Version = GetAddOnMetadata(..., "Version") 
GRT_Author = GetAddOnMetadata(..., "Author")

local MainFrame = CreateFrame("Frame", nil, UIParent)
MainFrame:RegisterEvent("PLAYER_LOGIN")

function MainFrame_OnEvent(self, event, ...)
	if (GRT_SavedVars.daysEnabled == false or not GRT_SavedVars.days) then
		return
	end
	
	local weekday, _, _, _ = CalendarGetDate();
	if (GRT_SavedVars.days[weekday] == true) then
		GRT_Toggle("on", true)
	else
		GRT_Toggle("off", true)
	end
end
MainFrame:SetScript("OnEvent", MainFrame_OnEvent)

SLASH_GRT1 = "/grt"
function SlashCmdList.GRT(msg)
	msg = msg:lower()
	local command = msg:match("^(%S*)%s*(.-)$")
	
	if (command == "config" or command == "options" or command == "settings" or command == "conf") then
		-- when called only once it opens the interface settings window without going any further
		InterfaceOptionsFrame_OpenToCategory(GRT_Title)
		InterfaceOptionsFrame_OpenToCategory(GRT_Title)
	elseif (command == "on" or command == "off") then
		GRT_Toggle(command, false)
	elseif (command == "about") then
		GRT_About()
	else
		print("|cff00ccffGuildRepairsToggle|r: Welcome! Following commands are available:")
		print("/grt config - opens addon settings")
		print("/grt on - toggles guild repairs for the specified ranks on")
		print("/grt off - toggles guild repairs for the specified ranks off")
		print("/grt about - displays addon and author info")
	end
end

function GRT_Toggle(command, auto)
	if (not IsGuildLeader()) then
		print("|cff00ccffGuildRepairsToggle|r: Sorry! Only Guild Leaders can toggle repairs.")
		return
	end
	
	local count = 0
	local printString = "|cff00ccffGuildRepairsToggle|r: Guild repairs for ranks: "
	for v, k in ipairs(GRT_SavedVars.ranks) do
		if (v > GuildControlGetNumRanks()) then
			print("|cff00ccffGuildRepairsToggle|r: |cffff0000Warning!|r GRT found out that the number of ranks in your guild has changed. Please reload UI to refresh the rank list and set correct ranks in the GRT config")
			break
		end
		if (k[2] == true) then
			if (count > 0) then
					printString = printString .. ", "
			end
			GuildControlSetRank(v)
			GuildControlSetRankFlag(15, command == "on" and true or false) -- 15 is the Guild Repairs flag index
			GuildControlSaveRank()
			printString = printString .. k[1]
			count = count + 1
		end
	end
	
	if (count > 0) then
		printString = printString .. " toggled " .. command .. "."
	else
		printString = "|cff00ccffGuildRepairsToggle|r: Attempted to toggle repairs " .. command .. ", but no ranks are set! Go to /grt config to specify ranks you want to edit."
	end
	
	if (auto == true) then
		printString = printString .. " (auto toggling)"
	end
	
	print(printString)
end

function GRT_About()
	print("|cff00ccff" .. GRT_Title .. "|r")
	print("Version: " .. GRT_Version)
	print("Author: " .. GRT_Author)
	print("Contact: via Curse. Suggestions are always welcome.")
end