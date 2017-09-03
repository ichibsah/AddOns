local addon, ns = ...

local f = CreateFrame("Frame", addon .. "Frame", UIParent)
f:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("GUILDBANKFRAME_CLOSED")
f:RegisterEvent("GUILDBANKFRAME_OPENED")

f:Hide()

local db = setmetatable({}, {__index = function(t, k)
    return _G["GuildBankSnapshotsDB"][k]
end})

local L = setmetatable({}, {__index = function(t, k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end})

ns.f = f
ns.db = db
ns.L = L

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

function f:buttons_OnEnter(self, ...)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self.tooltip_text, nil, nil, nil, nil, true)
    GameTooltip:Show()
end

function f:buttons_OnLeave(self)
    GameTooltip_Hide()
end

function f:count(tbl)
	local counter = 0
	for k, v in pairs(tbl) do
		counter = counter + 1
	end

	return counter
end

function f:FormatMsg(line, log_type)
	local msg

	local type = line[1]
	local name = line[2]

	if not name then
		name = UNKNOWN or "Unknown"
	end

	name = (NORMAL_FONT_COLOR_CODE or "|cffffd200") .. name .. (FONT_COLOR_CODE_CLOSE or "|r")

	if log_type == "money" then
		local money
		local amount = line[3]
		local year = line[4]
		local month = line[5]
		local day = line[6]
		local hour = line[7]

		money = GetDenominationsFromCopper(amount)

		if type == "deposit" then
			msg = format(GUILDBANK_DEPOSIT_MONEY_FORMAT or "%s deposited %s", name, money)
		elseif type == "withdraw" then
			msg = format(GUILDBANK_WITHDRAW_MONEY_FORMAT or "%s |cffff2020withdrew|r %s", name, money)
		elseif type == "repair" then
			msg = format(GUILDBANK_REPAIR_MONEY_FORMAT or "%s withdrew %s for repairs", name, money)
		elseif type == "withdrawForTab" then
			msg = format(GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT or "%s withdrew %s to purchase a guild bank tab", name, money)
		elseif type == "buyTab" then
			if amount > 0 then
				msg = format(GUILDBANK_BUYTAB_MONEY_FORMAT or "%s purchased a guild bank tab for %s", name, money)
			else
				msg = format(GUILDBANK_UNLOCKTAB_FORMAT or "%s unlocked a guild bank tab with a Guild Vault Voucher.", name)
			end
		elseif type == "depositSummary" then
			msg = format(GUILDBANK_AWARD_MONEY_SUMMARY_FORMAT or "A total of %s was deposited last week from Guild Perk: Cash Flow ", money)
		end

		if not msg then
			return
		end
		msg = msg .. (GUILD_BANK_LOG_TIME_PREPEND or "|cff009999   ") .. format(GUILD_BANK_LOG_TIME or "( %s ago )", RecentTimeDate(year, month, day, hour))
	elseif log_type == "item" then
		local itemLink = line[3]
		local count = line[4]
		local tab1 = line[5] ~= 0 and "Tab " .. line[5][1] .. " (" .. line[5][2] .. ")" or line[5]
		local tab2 = line[6] ~= 0 and "Tab " .. line[6][1] .. " (" .. line[6][2] .. ")" or line[6]
		local year = line[7]
		local month = line[8]
		local day = line[9]
		local hour = line[10]

		if type == "deposit" then
			msg = format(GUILDBANK_DEPOSIT_FORMAT or "%s deposited %s", name, itemLink)
			if count > 1 then
				msg = msg .. format(GUILDBANK_LOG_QUANTITY or " x %d", count)
			end
		elseif type == "withdraw" then
			msg = format(GUILDBANK_WITHDRAW_FORMAT or "%s |cffff2020withdrew|r %s", name, itemLink)
			if count > 1 then
				msg = msg .. format(GUILDBANK_LOG_QUANTITY or " x %d", count)
			end
		elseif type == "move" then
			msg = format(GUILDBANK_MOVE_FORMAT or "%s moved %s x %d from %s to %s", name, itemLink, count, tab1, tab2)
		end

		if not msg then
			return
		end
		msg = msg .. (GUILD_BANK_LOG_TIME_PREPEND or "|cff009999   ") .. format(GUILD_BANK_LOG_TIME or "( %s ago )", RecentTimeDate(year, month, day, hour))
	end

	return msg
end

function f:getMoneyString(str)
	if not str then
		return 0
	end
	str = tonumber(str)
	local g = floor(abs(str/10000))
	local s = floor(abs(mod(str/100, 100)))
	local c = floor(abs(mod(str, 100)))

	return string.format("%dg %ds %dc", g, s, c)
end

f.pairsByKeys = function(_, t, f)
	local a = {}

	for n in pairs(t) do
		table.insert(a, n)
	end

	table.sort(a, f)

	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	
	return iter
end

function f:print(msg)
	print(string.format("|cff00ff00%s:|r %s", addon, msg))
end


-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

function f:ADDON_LOADED(event, Addon, ...)
	if Addon == addon then
		local backup
		if GuildBankSnapshotsDB and GuildBankSnapshotsDB.Version and GuildBankSnapshotsDB.Version == 4 then
			backup = GuildBankSnapshotsDB
			GuildBankSnapshotsDB = nil
		end

		GuildBankSnapshotsDB = GuildBankSnapshotsDB or {
			["Transactions"] = {},
			["Active"] = {},
			["Settings"] = {
				ShowOnScan = true,
			},
			["Database"] = 1
		}

		local db = GuildBankSnapshotsDB
		db.Active = {
			    ["Realm"] = false,
			    ["Faction"] = false,
			    ["Guild"] = false,
			    ["Log"] = false
		}

		if backup then
			db.Backup = backup
		end
	end
end

function f:GUILDBANKFRAME_CLOSED(...)
	if not f.menuButtons then		
		f:CreateFrame()
		f:CreateFrame()
	end

	f.menuButtons["ScanBank"]:Disable()
end

function f:GUILDBANKFRAME_OPENED(...)
	if not f.menuButtons then
		f:CreateFrame()
		f:CreateFrame()
	end
	
	f.menuButtons["ScanBank"]:Enable()
end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

SLASH_GUILDBANKSNAPSHOTS1 = "/gbs"

function SlashCmdList.GUILDBANKSNAPSHOTS(msg)
	if msg == "scan" then
		f:Scan()
	else
		f:CreateFrame()
	end
end
