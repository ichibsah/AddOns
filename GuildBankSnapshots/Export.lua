local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 4

local tbl = {
    ["Active"] = {
        ["Realm"] = false,
        ["Guild"] = false,
        ["Faction"] = false,
    },
    ["Pending"] = {},
}

local alliance, horde, unknown, realmDropDownButton, guildDropDownButton, log_scrollContent, export_editBox

local content_loaded = false
function f:Export()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
     
        local instructions = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        instructions:SetPoint("TOPLEFT", scrollContent.header, "BOTTOMLEFT", 0, -10)
        instructions:SetText(L["To export one or more logs, please select the realm, faction and guild and then click on the appropriate logs in the Log section. To remove a log from your pending exports, click on the log in the Pending section.\n\nOnce you have selected all the logs you wish to export (up to a maximum of 8 at a time), click the Select button at the bottom of this page to generate and select the export text in the bottom scroll box.\n\nTo create a CSV file, open a text editor, such as Notepad, and paste the text into the editor. Save the file with a .csv extension. Please note, some text editors require you to select All Files from the file type and then manually type in .csv after the name.\n\nOnce your file is saved, you may open it in Excel or another reader of your choice."])
        instructions:SetWordWrap(true)
        instructions:SetJustifyH("LEFT")
        instructions:SetWidth(scrollContent:GetWidth() - 20)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local realm = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        realm:SetPoint("TOPLEFT", instructions, "BOTTOMLEFT", 0, -10)
        realm:SetText(L["Realm"])

        realmDropDownButton = CreateFrame("Button", "RealmDropDownButton2", scrollContent, "UIDropDownMenuTemplate")
        realmDropDownButton:SetPoint("TOPLEFT", realm, "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_JustifyText(realmDropDownButton, "LEFT")
        UIDropDownMenu_SetWidth(realmDropDownButton, 150);
        UIDropDownMenu_SetButtonWidth(realmDropDownButton, 150)

        UIDropDownMenu_Initialize(realmDropDownButton, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.func = self.SetValue

            for k, v in f:pairsByKeys(db.Transactions) do
                info.text = k
                info.arg1 = k
                info.checked = tbl.Active.Realm == k
                UIDropDownMenu_AddButton(info)
            end
        end)
        
        function realmDropDownButton:SetValue(selected)
            tbl.Active.Realm = selected
            UIDropDownMenu_SetText(realmDropDownButton, selected)

            alliance:Enable()
            horde:Enable()
                unknown:Enable()

            tbl.Active.Faction = false
            tbl.Active.Guild = false

            alliance:SetNormalFontObject("GameFontHighlight")
            horde:SetNormalFontObject("GameFontHighlight")
            unknown:SetNormalFontObject("GameFontHighlight")
            guildDropDownButton:SetValue()
            log_scrollContent:LoadLogs()

            if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (tbl.Active.Realm and not db.Transactions[tbl.Active.Realm]["U"]) or not tbl.Active.Realm then
                unknown:Hide()
            else
                unknown:Show()
            end
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local faction = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        faction:SetPoint("LEFT", realm, "RIGHT", 200, 0)
        faction:SetText(L["Faction"])

        alliance = CreateFrame("Button", nil, scrollContent)
        alliance:SetSize(100, 25)
        alliance:SetPoint("TOPLEFT", faction, "BOTTOMLEFT", 10, -10)
        alliance:SetNormalFontObject("GameFontHighlight")
        alliance:SetDisabledFontObject("GameFontDisable")
        alliance:SetPushedTextOffset(0, 0)
        alliance:SetText(L["Alliance"])
        alliance:GetFontString():SetPoint("TOPLEFT", 0, 0)
        alliance:Disable()

        alliance:SetScript("OnClick", function()
            alliance:SetNormalFontObject("GameFontNormal")
            horde:SetNormalFontObject("GameFontHighlight")
            unknown:SetNormalFontObject("GameFontHighlight")

            tbl.Active.Faction = "A"

            guildDropDownButton:SetValue()
        end)

        horde = CreateFrame("Button", nil, scrollContent)
        horde:SetSize(100, 25)
        horde:SetPoint("LEFT", alliance, "RIGHT", 10, 0)
        horde:SetNormalFontObject("GameFontHighlight")
        horde:SetDisabledFontObject("GameFontDisable")
        horde:SetPushedTextOffset(0, 0)
        horde:SetText(L["Horde"])
        horde:GetFontString():SetPoint("TOPLEFT", 0, 0)
        horde:Disable()

        horde:SetScript("OnClick", function()
            alliance:SetNormalFontObject("GameFontHighlight")
            horde:SetNormalFontObject("GameFontNormal")
            unknown:SetNormalFontObject("GameFontHighlight")

            tbl.Active.Faction = "H"

            guildDropDownButton:SetValue()
            log_scrollContent:LoadLogs()
        end)

        unknown = CreateFrame("Button", nil, scrollContent)
        unknown:SetSize(100, 25)
        unknown:SetPoint("TOPLEFT", alliance, "BOTTOMLEFT", 0, -10)
        unknown:SetNormalFontObject("GameFontHighlight")
        unknown:SetDisabledFontObject("GameFontDisable")
        unknown:SetPushedTextOffset(0, 0)
        unknown:SetText(L["UNKNOWN"])
        unknown:GetFontString():SetPoint("TOPLEFT", 0, 0)
        unknown:Disable()
        unknown:Hide()
        
        if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (tbl.Active.Realm and not db.Transactions[tbl.Active.Realm]["U"]) or not tbl.Active.Realm then
            unknown:Hide()
        else
            unknown:Show()
        end

        unknown:SetScript("OnClick", function()
            alliance:SetNormalFontObject("GameFontHighlight")
            horde:SetNormalFontObject("GameFontHighlight")
            unknown:SetNormalFontObject("GameFontNormal")

            tbl.Active.Faction = "U"
            tbl.Active.Guild = false
            tbl.Active.Log = false

            guildDropDownButton:SetValue()
            log_scrollContent:LoadLogs()
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local guild = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        guild:SetPoint("TOPLEFT", realmDropDownButton, "BOTTOMLEFT", 0, -10)
        guild:SetText(L["Guild"])

        guildDropDownButton = CreateFrame("Button", "GuildDropDownButton2", scrollContent, "UIDropDownMenuTemplate")
        guildDropDownButton:SetPoint("TOPLEFT", guild, "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_JustifyText(guildDropDownButton, "LEFT")
        UIDropDownMenu_SetWidth(guildDropDownButton, 150);
        UIDropDownMenu_SetButtonWidth(guildDropDownButton, 150)

        UIDropDownMenu_Initialize(guildDropDownButton, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.func = self.SetValue

            if tbl.Active.Realm and tbl.Active.Faction and db.Transactions[tbl.Active.Realm][tbl.Active.Faction] then
                for k, v in f:pairsByKeys(db.Transactions[tbl.Active.Realm][tbl.Active.Faction]) do
                    info.text = k
                    info.arg1 = k
                    info.checked = tbl.Active.Guild == k
                    UIDropDownMenu_AddButton(info)
                end
            end
        end)

        function guildDropDownButton:SetValue(selected)
            tbl.Active.Guild = selected
            UIDropDownMenu_SetText(guildDropDownButton, selected)

            log_scrollContent:LoadLogs()
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        local log = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        log:SetPoint("TOPLEFT", guildDropDownButton, "BOTTOMLEFT", 0, -10)
        log:SetText(L["Log"])

        local log_scrollFrame = CreateFrame("ScrollFrame", addon .. "log_scrollFrame", scrollContent, "UIPanelScrollFrameTemplate")
        log_scrollFrame:SetSize((scrollContent:GetWidth() - 66)/2, 165)
        log_scrollFrame:SetPoint("TOPLEFT", log, "BOTTOMLEFT", 0, -10)

        log_scrollFrame.ScrollBar:EnableMouseWheel(true)
        log_scrollFrame.ScrollBar:SetScript("OnMouseWheel", function(self, direction)
            ScrollFrameTemplate_OnMouseWheel(log_scrollFrame, direction)
        end)

        log_scrollFrame.scrollTexture = log_scrollFrame:CreateTexture(nil, "BACKGROUND", nil, -6)
        log_scrollFrame.scrollTexture:SetPoint("TOP")
        log_scrollFrame.scrollTexture:SetPoint("BOTTOM")
        log_scrollFrame.scrollTexture:SetPoint("RIGHT", 26, 0)
        log_scrollFrame.scrollTexture:SetWidth(26)
        log_scrollFrame.scrollTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar.blp")
        log_scrollFrame.scrollTexture:SetTexCoord(0, 0.45, 0.1640625, 1)
        log_scrollFrame.scrollTexture:SetAlpha(0.5)

        log_scrollFrame:SetBackdrop({
            bgFile = [[Interface\Buttons\WHITE8x8]],
            insets = {left = 0, right = 0, top = 0, bottom = 0
        }})
        log_scrollFrame:SetBackdropColor(0, 0, 0, 0.5)

        log_scrollContent = CreateFrame("Frame", addon .."log_scrollContent", log_scrollFrame)
        log_scrollContent:SetSize(log_scrollFrame:GetWidth(), log_scrollFrame:GetHeight())
        log_scrollContent:SetAllPoints(log_scrollFrame)
        log_scrollFrame:SetScrollChild(log_scrollContent)

        local lines = {}

        function log_scrollContent:LoadLogs()
            for k, v in pairs(lines) do
                v:SetText("")
                v:ClearAllPoints()
                v:Hide()
            end

            local line_counter = 0
            if tbl.Active.Realm and tbl.Active.Faction and tbl.Active.Guild and db.Transactions[tbl.Active.Realm][tbl.Active.Faction][tbl.Active.Guild] then
                for k, v in f:pairsByKeys(db.Transactions[tbl.Active.Realm][tbl.Active.Faction][tbl.Active.Guild], function(a, b) return b < a end) do
                    local log_button = CreateFrame("Button", nil, log_scrollContent)
                    log_button:SetSize(log_scrollContent:GetWidth() - 20, 20)
                    log_button:SetPoint("TOPLEFT", log_scrollContent, "TOPLEFT", 10, -(line_counter * 20) - 10)
                    log_button:SetText(k)
                    log_button:SetNormalFontObject("GameFontHighlight")
                    log_button:SetPushedTextOffset(0, 0)
                    log_button:GetFontString():SetPoint("LEFT", log_button, "LEFT", 0, 0)

                    log_button:SetScript("OnClick", function()
                        local numPending = 0
                        for realm, realmTBL in f:pairsByKeys(tbl.Pending) do
                            for faction, factionTBL in pairs(realmTBL) do
                                for guild, guildTBL in pairs(factionTBL) do
                                    for log, logTBL in pairs(guildTBL) do
                                        numPending = numPending + 1
                                    end
                                end
                            end
                        end

                        if numPending < 8 then
                            tbl.Pending[tbl.Active.Realm] = tbl.Pending[tbl.Active.Realm] or {}
                            tbl.Pending[tbl.Active.Realm][tbl.Active.Faction] = tbl.Pending[tbl.Active.Realm][tbl.Active.Faction] or {}
                            tbl.Pending[tbl.Active.Realm][tbl.Active.Faction][tbl.Active.Guild] = tbl.Pending[tbl.Active.Realm][tbl.Active.Faction][tbl.Active.Guild] or {}
                            tbl.Pending[tbl.Active.Realm][tbl.Active.Faction][tbl.Active.Guild][k] = true

                            pending_scrollContent:LoadLogs()
                        else
                            f:print(L["Export limit reached."])
                        end
                    end)

                    lines[line_counter] = log_button
                    line_counter = line_counter + 1
                end
            end
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        local pending = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        pending:SetPoint("BOTTOMLEFT", log_scrollFrame, "TOPRIGHT", 36, 10)
        pending:SetText(L["Pending"])

        local pending_scrollFrame = CreateFrame("ScrollFrame", addon .. "pending_scrollFrame", scrollContent, "UIPanelScrollFrameTemplate")
        pending_scrollFrame:SetSize((scrollContent:GetWidth() - 66)/2, 165)
        pending_scrollFrame:SetPoint("TOPLEFT", pending, "BOTTOMLEFT", 0, -10)

        pending_scrollFrame.ScrollBar:EnableMouseWheel(true)
        pending_scrollFrame.ScrollBar:SetScript("OnMouseWheel", function(self, direction)
            ScrollFrameTemplate_OnMouseWheel(pending_scrollFrame, direction)
        end)

        pending_scrollFrame.scrollTexture = pending_scrollFrame:CreateTexture(nil, "BACKGROUND", nil, -6)
        pending_scrollFrame.scrollTexture:SetPoint("TOP")
        pending_scrollFrame.scrollTexture:SetPoint("BOTTOM")
        pending_scrollFrame.scrollTexture:SetPoint("RIGHT", 26, 0)
        pending_scrollFrame.scrollTexture:SetWidth(26)
        pending_scrollFrame.scrollTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar.blp")
        pending_scrollFrame.scrollTexture:SetTexCoord(0, 0.45, 0.1640625, 1)
        pending_scrollFrame.scrollTexture:SetAlpha(0.5)

        pending_scrollFrame:SetBackdrop({
            bgFile = [[Interface\Buttons\WHITE8x8]],
            insets = {left = 0, right = 0, top = 0, bottom = 0
        }})
        pending_scrollFrame:SetBackdropColor(0, 0, 0, 0.5)

        pending_scrollContent = CreateFrame("Frame", addon .."pending_scrollContent", pending_scrollFrame)
        pending_scrollContent:SetSize(pending_scrollFrame:GetWidth(), pending_scrollFrame:GetHeight())
        pending_scrollContent:SetAllPoints(pending_scrollFrame)
        pending_scrollFrame:SetScrollChild(pending_scrollContent)

        local pending_lines = {}

        function pending_scrollContent:LoadLogs()
            for k, v in pairs(pending_lines) do
                v:SetText("")
                v:ClearAllPoints()
                v:Hide()
            end

            local line_counter = 0
            for realm, realmTBL in f:pairsByKeys(tbl.Pending, function(a, b) return b < a end) do
                for faction, factionTBL in pairs(realmTBL) do
                    for guild, guildTBL in pairs(factionTBL) do
                        for log, logTBL in pairs(guildTBL) do
                            local log_button = CreateFrame("Button", nil, pending_scrollContent)
                            log_button:SetSize(pending_scrollContent:GetWidth() - 20, 20)
                            log_button:SetPoint("TOPLEFT", pending_scrollContent, "TOPLEFT", 10, -(line_counter * 20) - 10)
                            log_button:SetText(string.format("%s (%s-%s [%s])", log, guild, realm, faction))
                            log_button:SetNormalFontObject("GameFontHighlight")
                            log_button:SetPushedTextOffset(0, 0)
                            log_button:GetFontString():SetPoint("LEFT", log_button, "LEFT", 0, 0)
                            log_button.Active = {
                                ["Realm"] = realm,
                                ["Faction"] = faction,
                                ["Guild"] = guild,
                                ["Log"] = log
                            }

                            log_button.tooltip_text = string.format("%s (%s-%s [%s])", log, guild, realm, faction)
                            log_button:SetScript("OnEnter", function() f:buttons_OnEnter(log_button) end)
                            log_button:SetScript("OnLeave", function() f:buttons_OnLeave(log_button) end)

                            log_button:SetScript("OnClick", function()
                                local active = log_button.Active
                                tbl.Pending[active.Realm][active.Faction][active.Guild][active.Log] = nil

                                if f:count(tbl.Pending[active.Realm][active.Faction][active.Guild]) == 0 then
                                    tbl.Pending[active.Realm][active.Faction][active.Guild] = nil
                                    if f:count(tbl.Pending[active.Realm][active.Faction]) == 0 then
                                        tbl.Pending[active.Realm][active.Faction] = nil
                                        if f:count(tbl.Pending[active.Realm]) == 0 then
                                            tbl.Pending[active.Realm] = nil
                                        end
                                    end
                                end

                                pending_scrollContent:LoadLogs()
                            end)

                            pending_lines[line_counter] = log_button
                            line_counter = line_counter + 1
                        end
                    end
                end
            end
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        local limit = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        limit:SetPoint("TOPRIGHT", pending_scrollFrame, "BOTTOMRIGHT", 0, -5)
        limit:SetText(L["Limit of 8 logs per export."])

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        export_editBox = CreateFrame("EditBox", "ExportEditBox", scrollContent)
        export_editBox:SetSize(scrollContent:GetWidth() - 10, 45)
        export_editBox:SetPoint("TOPRIGHT", limit, "BOTTOMRIGHT", 0, -10)

        export_editBox:SetBackdrop({
            bgFile = [[Interface\Buttons\WHITE8x8]],
            insets = {left = 0, right = 0, top = 0, bottom = 0
        }})
        export_editBox:SetBackdropColor(0, 0, 0, 0.5)

        export_editBox:SetFontObject(GameFontHighlightSmall)
        export_editBox:SetAutoFocus(false)
        export_editBox:SetTextInsets(10, 10, 10, 10)
        export_editBox:SetMaxLetters(999999)
        export_editBox:GetRegions():SetNonSpaceWrap(false)
        
        export_editBox:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local select_btn = CreateFrame("Button", addon .. "select_btn", scrollContent, "UIMenuButtonStretchTemplate")
        select_btn:SetSize(100, 25)
        select_btn:SetPoint("TOPRIGHT", export_editBox, "BOTTOMRIGHT", 0, -10)
        select_btn:SetText(L["Select"])
        select_btn:SetPushedTextOffset(0, 0)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        select_btn:SetScript("OnClick", function()
            local export_line = "realm,faction,guild,datetime,tab_name,transaction_type,name,itemLink/amount,item_count,move_tab1_name,move_tab2_name,year,month,day,hour**#**"

            for realm, realmTBL in f:pairsByKeys(tbl.Pending, function(a, b) return b < a end) do
                for faction, factionTBL in pairs(realmTBL) do
                    for guild, guildTBL in pairs(factionTBL) do
                        for log, logTBL in pairs(guildTBL) do
                            if db.Transactions[realm] and db.Transactions[realm][faction] and db.Transactions[realm][faction][guild] and db.Transactions[realm][faction][guild][log] and db.Transactions[realm][faction][guild][log]["ExportLine"] then
                                export_line = gsub(gsub(gsub(gsub(gsub(export_line .. db.Transactions[realm][faction][guild][log]["ExportLine"] .. (string.format("%s,%s,%s,%s,Money Log,total,,%s,,,,,,,", realm, faction, guild, log, f:getMoneyString(db.Transactions[realm][faction][guild][log]["MoneyTotal"])) .. "**#**"), "**#**", "\n"), "\n\n", "\n"), "%(Tab 0%)", ""), "%]", ""), "%[", "")
                            end
                        end
                    end
                end
            end

            if export_line == "realm,faction,guild,datetime,tab_name,transaction_type,name,itemLink/amount,item_count,move_tab1_name,move_tab2_name,year,month,day,hour**#**" then
                export_editBox:SetText("")
                export_editBox:ClearFocus()
                return
            end

            export_editBox:SetText(export_line)
            export_editBox:SetFocus()
            export_editBox:HighlightText()
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        scrollContent:SetScript("OnShow", function()
            if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (tbl.Active.Realm and not db.Transactions[tbl.Active.Realm]["U"]) or not tbl.Active.Realm then
                unknown:Hide()
            else
                unknown:Show()
            end
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        content_loaded = true
    end
end
    
function f:ClearExports()
    if content_loaded then
        tbl.Active.Realm = false
        tbl.Active.Faction = false
        tbl.Active.Guild = false
        table.wipe(tbl.Pending)

        alliance:Disable()
        horde:Disable()
        unknown:Disable()

        alliance:SetNormalFontObject("GameFontHighlight")
        horde:SetNormalFontObject("GameFontHighlight")
        unknown:SetNormalFontObject("GameFontHighlight")

        UIDropDownMenu_SetText(realmDropDownButton, "")
        guildDropDownButton:SetValue()

        log_scrollContent:LoadLogs()
        pending_scrollContent:LoadLogs()

        export_editBox:SetText("")
        export_editBox:ClearFocus()
    end
end
