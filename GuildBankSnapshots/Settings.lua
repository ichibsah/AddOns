local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 6

local content_loaded = false
function f:Settings()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]

        local ShowOnScanCHK = CreateFrame("CheckButton", addon .. "ShowOnScanCHK", scrollContent, "OptionsBaseCheckButtonTemplate")
        ShowOnScanCHK:SetScript("OnClick", function(self)
            db.Settings.ShowOnScan = self:GetChecked() and true or false
        end)
        ShowOnScanCHK:SetScript("OnShow", function(self)
            self:SetChecked(db.Settings.ShowOnScan)
        end)

        ShowOnScanCHK:SetPoint("TOPLEFT", scrollContent.header, "BOTTOMLEFT", 0, -5)
        ShowOnScanCHK:SetChecked(db.Settings.ShowOnScan)

        local ShowOnScanTXT = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        ShowOnScanTXT:SetPoint("LEFT", ShowOnScanCHK, "RIGHT", 5, 0)
        ShowOnScanTXT:SetText(L["Show log frame after bank scan"])

        content_loaded = true

        if db.Backup then
            local outdated = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            outdated:SetPoint("TOPLEFT", ShowOnScanCHK, "BOTTOMLEFT", 0, -10)
            outdated:SetText(L["Outdated database detected"])

            local outdatedDesc = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            outdatedDesc:SetPoint("TOPLEFT", outdated, "BOTTOMLEFT", 0, -10)
            outdatedDesc:SetText(L["An outdated version of the GBS database has been found. To recover your data, use the button below. Please keep in mind that recovered logs may not be fully compatible with newer features of this addon."])
            outdatedDesc:SetWordWrap(true)
            outdatedDesc:SetJustifyH("LEFT")
            outdatedDesc:SetWidth(scrollContent:GetWidth() - 20)

            local recoverDB = CreateFrame("Button", addon .. "recoverDB", scrollContent, "UIMenuButtonStretchTemplate")
            recoverDB:SetSize(150, 25)
            recoverDB:SetPoint("TOPLEFT", outdatedDesc, "BOTTOMLEFT", 0, -10)
            recoverDB:SetText(L["Recover Database"])
            recoverDB:SetPushedTextOffset(0, 0)

            recoverDB:SetScript("OnClick", function()
                for k, v in pairs(db.Backup.Transactions) do
                    local realm = "UNKNOWN"
                    local faction = "U"
                    local guild = k
                    for log, log_table in pairs(v) do
                        local datetime = log

                        db.Transactions[realm] = db.Transactions[realm] or {}
                        db.Transactions[realm][faction] = db.Transactions[realm][faction] or {}
                        db.Transactions[realm][faction][guild] = db.Transactions[realm][faction][guild] or {}
                        db.Transactions[realm][faction][guild][datetime] = {}

                        db.Transactions[realm][faction][guild][datetime]["Transactions"] = {}
                        db.Transactions[realm][faction][guild][datetime]["Money"] = {}
                        db.Transactions[realm][faction][guild][datetime]["MaxTabs"] = log_table.MaxTabs
                        db.Transactions[realm][faction][guild][datetime]["MoneyTotal"] = 0

                        local export_line = ""

                        for tab, tab_table in pairs(log_table) do
                            if tab == ("tab" .. (log_table.MaxTabs + 1)) then
                                for transaction, transaction_table in pairs(tab_table) do
                                    for t, t2 in pairs(transaction_table) do
                                        tinsert(db.Transactions[realm][faction][guild][datetime]["Money"], t2)
                                    end
                                end
                            elseif string.find(tab, "tab") and tab ~= "MaxTabs" then
                                local tabNum = gsub(tab, "tab", "")
                                db.Transactions[realm][faction][guild][datetime]["Transactions"]["Tab" .. tabNum] = {}
                                local transactionsTBL = db.Transactions[realm][faction][guild][datetime]["Transactions"]["Tab" .. tabNum]
                                for transaction, transaction_table in pairs(tab_table) do
                                    if type(transaction_table) ~= "string" then
                                        for t, t2 in pairs(transaction_table) do
                                            local type = t2[1]
                                            local name = t2[2]
                                            local itemLink = t2[3]
                                            local count = t2[4]
                                            local tab1 = type == "move" and {t2[5][1], t2[5][2]} or 0
                                            local tab2 = type == "move" and {t2[6][1], t2[6][2]} or 0
                                            local year = t2[7]
                                            local month = t2[8]
                                            local day = t2[9]
                                            local hour = t2[10]

                                            fuck = t2

                                            local tab1_name = (tab1 ~= 0) and tab1[2] or ""
                                            local tab2_name = (tab2 ~= 0) and tab2[2] or ""
                                            local tab1_num = (tab1 ~= 0) and tab1[1] or 0
                                            local tab2_num = (tab2 ~= 0) and tab2[1] or 0

                                            local line = string.format("%s,%s,%s,%s,%s (Tab %d),%s,%s,%s,%d,%s (Tab %d),%s (Tab %d),%d,%d,%d,%d", realm, faction, guild, datetime, tab_table.name, gsub(tab, "tab", ""), type, name, itemLink, count, tab1_name, tab1_num, tab2_name, tab2_num, year, month, day, hour)
                                            export_line = export_line ~= "" and export_line .. line .. "**#**" or line .. "**#**"

                                            tinsert(transactionsTBL, t2)
                                        end
                                    else
                                        db.Transactions[realm][faction][guild][datetime]["Transactions"]["Tab" .. tabNum]["Name"] = transaction_table
                                    end
                                end
                            end
                        end

                        db.Transactions[realm][faction][guild][datetime]["ExportLine"] = export_line
                    end
                end

                f:ShowTab(2, "SelectLog")
                f:ClearSelectLog()
                GuildBankSnapshotsDB.Backup = nil

                outdated:Hide()
                outdatedDesc:Hide()
                recoverDB:Hide()
            end)
        end
    end
end
