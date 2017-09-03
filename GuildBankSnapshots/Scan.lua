local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

function f:Scan()
    if not f.menuButtons then
        f:CreateFrame()
        f:CreateFrame()        
    end

    if f.menuButtons["ScanBank"]:GetButtonState() == "DISABLED" then
        f:print(L["The guild bank frame must be open to use this command."])
        return
    end
    
    f.menuButtons["ScanBank"]:Disable()
    f:print(L["Scanning in progress..."])
    f:ClearExports()

    for i = 1, MAX_GUILDBANK_TABS + 1 do
        QueryGuildBankLog(i)
    end

    C_Timer.After(1, function()        
        local realm = GetRealmName()
        local faction = strsub(UnitFactionGroup("player"), 1, 1)
        local guild = GetGuildInfo("player")
        local datetime = date("%m/%d/%Y %H:%M:%S")

        local tabs = GetNumGuildBankTabs() + 1
        local num_transactions, type, name, amount, itemLink, count, tab1, tab2, year, month, day, hour
        local export_line = ""

        db.Transactions[realm] = db.Transactions[realm] or {}
        db.Transactions[realm][faction] = db.Transactions[realm][faction] or {}
        db.Transactions[realm][faction][guild] = db.Transactions[realm][faction][guild] or {}
        db.Transactions[realm][faction][guild][datetime] = {}

        local log_table = db.Transactions[realm][faction][guild][datetime]
        log_table["Transactions"] = {}
        log_table["Money"] = {}
        log_table.MaxTabs = tabs
        log_table.MoneyTotal = 0

        local transactions_table = log_table["Transactions"]
        local money_table = log_table["Money"]

        for tab = 1, tabs do
            num_transactions = tab < tabs and GetNumGuildBankTransactions(tab) or GetNumGuildBankMoneyTransactions()

            transactions_table["Tab" .. tab] = {
                ["Name"] = GetGuildBankTabInfo(tab)            
            }

            local tab_table = transactions_table["Tab" .. tab]

            for i = num_transactions, 1, -1 do
                if tab < tabs then
                    type, name, itemLink, count, tab1, tab2, year, month, day, hour = GetGuildBankTransaction(tab, i)

                    local tab1_name = tab1 and GetGuildBankTabInfo(tab1) or ""
                    local tab2_name = tab2 and GetGuildBankTabInfo(tab2) or ""

                    name = name or (UNKNOWN or "Unknown")
                    tab1 = tab1 and {tab1, tab1_name} or 0
                    tab2 = tab2 and {tab2, tab2_name} or 0

                    table.insert(tab_table, {type, name, itemLink, count, tab1, tab2, year, month, day, hour})

                    local line = string.format("%s,%s,%s,%s,%s (Tab %d),%s,%s,%s,%d,%s (Tab %d),%s (Tab %d),%d,%d,%d,%d", realm, faction, guild, datetime, tab_table.Name, tab, type, name, itemLink, count, tab1_name, tab1 ~= 0 and tab1[1] or 0, tab2_name, tab2 ~= 0 and tab2[1] or 0, year, month, day, hour)
                    export_line = export_line ~= "" and export_line .. line .. "**#**" or line .. "**#**"
                else
                    type, name, amount, year, month, day, hour = GetGuildBankMoneyTransaction(i)

                    name = name or (UNKNOWN or "Unknown")

                    table.insert(money_table, {type, name, amount, year, month, day, hour})

                    log_table.MoneyTotal = GetGuildBankMoney()

                    local line = string.format("%s,%s,%s,%s,Money Log,%s,%s,%s,%d,%s,%s,%d,%d,%d,%d", realm, faction, guild, datetime, type, name, f:getMoneyString(amount), "", "", "", year, month, day, hour)
                    export_line = export_line ~= "" and export_line .. line .. "**#**" or line .. "**#**"
                end
            end
        end

        log_table.ExportLine = export_line

        f:SelectLogs(realm, faction, guild, datetime)
        f:LoadActiveTransactions()
        f:ShowTab(3, "Transactions")

        if db.Settings.ShowOnScan and not f.frame:IsVisible() then
            f:CreateFrame()
        end

        f:print(L["Scan finished."])
        f.menuButtons["ScanBank"]:Enable()
    end)
end
