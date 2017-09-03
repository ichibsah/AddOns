-- REVERSE LOGS
local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 2

local alliance, horde, unknown, realmDropDownButton, guildDropDownButton, log_scrollContent

local content_loaded = false
function f:SelectLog()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local realm = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        realm:SetPoint("TOPLEFT", scrollContent.header, "BOTTOMLEFT", 0, -10)
        realm:SetText(L["Realm"])

        realmDropDownButton = CreateFrame("Button", "RealmDropDownButton", scrollContent, "UIDropDownMenuTemplate")
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
                info.checked = db.Active.Realm == k
                UIDropDownMenu_AddButton(info)
            end

            if f:count(db.Transactions) ~= 0 then
                info.text = L["Clear Selection"]
                info.arg1 = 0
                info.checked = false
                UIDropDownMenu_AddButton(info)
            end
        end)

        function realmDropDownButton:SetValue(selected)
            if selected == 0 then
                f:ClearSelectLog()
            else
                db.Active.Realm = selected
                UIDropDownMenu_SetText(realmDropDownButton, selected)

                alliance:Enable()
                horde:Enable()
                unknown:Enable()

                db.Active.Faction = false
                db.Active.Guild = false
                db.Active.Log = false

                alliance:SetNormalFontObject("GameFontHighlight")
                horde:SetNormalFontObject("GameFontHighlight")
                unknown:SetNormalFontObject("GameFontHighlight")
                guildDropDownButton:SetValue()
                log_scrollContent:LoadLogs()

                if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (db.Active.Realm and not db.Transactions[db.Active.Realm]["U"]) then
                    unknown:Hide()
                else
                    unknown:Show()
                end
            end

            f.frame.buttons[3][4]:Disable()
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

            db.Active.Faction = "A"
            db.Active.Guild = false
            db.Active.Log = false

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

            db.Active.Faction = "H"
            db.Active.Guild = false
            db.Active.Log = false

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

        if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (db.Active.Realm and not db.Transactions[db.Active.Realm]["U"]) or not db.Active.Realm then
            unknown:Hide()
        else
            unknown:Show()
        end

        unknown:SetScript("OnClick", function()
            alliance:SetNormalFontObject("GameFontHighlight")
            horde:SetNormalFontObject("GameFontHighlight")
            unknown:SetNormalFontObject("GameFontNormal")

            db.Active.Faction = "U"
            db.Active.Guild = false
            db.Active.Log = false

            guildDropDownButton:SetValue()
            log_scrollContent:LoadLogs()
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local guild = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        guild:SetPoint("TOPLEFT", realmDropDownButton, "BOTTOMLEFT", 0, -10)
        guild:SetText(L["Guild"])

        guildDropDownButton = CreateFrame("Button", "GuildDropDownButton", scrollContent, "UIDropDownMenuTemplate")
        guildDropDownButton:SetPoint("TOPLEFT", guild, "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_JustifyText(guildDropDownButton, "LEFT")
        UIDropDownMenu_SetWidth(guildDropDownButton, 150);
        UIDropDownMenu_SetButtonWidth(guildDropDownButton, 150)

        UIDropDownMenu_Initialize(guildDropDownButton, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.func = self.SetValue

            if db.Active.Realm and db.Active.Faction and db.Transactions[db.Active.Realm][db.Active.Faction] then
                for k, v in f:pairsByKeys(db.Transactions[db.Active.Realm][db.Active.Faction]) do
                    info.text = k
                    info.arg1 = k
                    info.checked = db.Active.Guild == k
                    UIDropDownMenu_AddButton(info)
                end
            end
        end)

        function guildDropDownButton:SetValue(selected)
            db.Active.Guild = selected
            db.Active.Log = false

            UIDropDownMenu_SetText(guildDropDownButton, selected)

            log_scrollContent:LoadLogs()
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local log = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        log:SetPoint("TOPLEFT", guildDropDownButton, "BOTTOMLEFT", 0, -10)
        log:SetText(L["Log"])

        local log_scrollFrame = CreateFrame("ScrollFrame", addon .. "log_scrollFrame", scrollContent, "UIPanelScrollFrameTemplate")
        log_scrollFrame:SetSize(scrollContent:GetWidth() - 40, 165)
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

        function log_scrollContent:LoadLogs(setLog)
            if not db.Active.Log then
                f.activeLog:SetText("")
            end
            setLog = setLog or ""
            for k, v in pairs(lines) do
                v:SetText("")
                v:ClearAllPoints()
                v:Hide()
            end

            local line_counter = 0
            if db.Active.Realm and db.Active.Faction and db.Active.Guild and db.Transactions[db.Active.Realm][db.Active.Faction][db.Active.Guild] then
                for k, v in f:pairsByKeys(db.Transactions[db.Active.Realm][db.Active.Faction][db.Active.Guild], function(a, b) return b < a end) do
                    local log_button = CreateFrame("Button", nil, log_scrollContent)
                    log_button:SetSize(log_scrollContent:GetWidth() - 20, 20)
                    log_button:SetPoint("TOPLEFT", log_scrollContent, "TOPLEFT", 10, -(line_counter * 20) - 10)
                    log_button:SetText(string.format("%s (%s-%s [%s])", k, db.Active.Guild, db.Active.Realm, db.Active.Faction))
                    log_button:SetNormalFontObject("GameFontHighlight")
                    log_button:SetPushedTextOffset(0, 0)
                    log_button:GetFontString():SetPoint("LEFT", log_button, "LEFT", 0, 0)

                    if k == setLog then
                        log_button:SetNormalFontObject("GameFontNormal")

                        db.Active.Log = k

                        f.frame.buttons[3][4]:Enable()
                    end

                    log_button:SetScript("OnClick", function()
                        for key, value in pairs(lines) do
                            value:SetNormalFontObject("GameFontHighlight")
                        end
                        log_button:SetNormalFontObject("GameFontNormal")

                        db.Active.Log = k

                        f.activeLog:SetText(string.format("%s-%s [%s] (%s)", db.Active.Guild, db.Active.Realm, db.Active.Faction, db.Active.Log))

                        f.frame.buttons[3][4]:Enable()
                        f:ShowTab(3, "Transactions")
                    end)

                    lines[line_counter] = log_button
                    line_counter = line_counter + 1
                end
            end
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
    
        function f:SelectLogs(realm, faction, guild, log)
            if realm and faction and guild and log then
                db.Active.Realm = realm
                db.Active.Faction = faction
                db.Active.Guild = guild
                db.Active.Log = log
            end

            UIDropDownMenu_SetText(realmDropDownButton, db.Active.Realm)
            if faction == "H" then
                alliance:Disable()
                alliance:SetNormalFontObject("GameFontHighlight")

                horde:Enable()
                horde:SetNormalFontObject("GameFontNormal")
                
                unknown:Disable()
                unknown:SetNormalFontObject("GameFontHighlight")
            elseif faction == "A" then
                alliance:Enable()
                alliance:SetNormalFontObject("GameFontNormal")

                horde:Disable()
                horde:SetNormalFontObject("GameFontHighlight")
                
                unknown:Disable()
                unknown:SetNormalFontObject("GameFontHighlight")
            elseif faction == "U" then
                alliance:Disable()
                alliance:SetNormalFontObject("GameFontHighlight")

                horde:Disable()
                horde:SetNormalFontObject("GameFontHighlight")
                
                unknown:Enable()
                unknown:SetNormalFontObject("GameFontNormal")
            end
            UIDropDownMenu_SetText(guildDropDownButton, db.Active.Guild)

            if db.Active.Log then
                f.activeLog:SetText(string.format("%s-%s [%s] (%s)", db.Active.Guild, db.Active.Realm, db.Active.Faction, db.Active.Log))
            else
                f.activeLog:SetText("")
            end

            log_scrollContent:LoadLogs(db.Active.Log)
            f:ActivateDeletion()
        end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        scrollContent:SetScript("OnShow", function()
            f:SelectLogs()

            if not (db.Transactions["UNKNOWN"] and db.Transactions["UNKNOWN"]["U"]) or (db.Active.Realm and not db.Transactions[db.Active.Realm]["U"]) or not db.Active.Realm then
                unknown:Hide()
            else
                unknown:Show()
            end
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        content_loaded = true
    end
end

function f:ClearSelectLog()
    if content_loaded then
        db.Active.Realm = false
        db.Active.Faction = false
        db.Active.Guild = false
        db.Active.Log = false

        alliance:Disable()
        horde:Disable()
        unknown:Disable()

        alliance:SetNormalFontObject("GameFontHighlight")
        horde:SetNormalFontObject("GameFontHighlight")
        unknown:SetNormalFontObject("GameFontHighlight")

        UIDropDownMenu_SetText(realmDropDownButton, "")
        guildDropDownButton:SetValue()

        log_scrollContent:LoadLogs()
    end
end
