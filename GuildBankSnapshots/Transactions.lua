local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 3

local log_table, transaction_buttons, copy, transactions_scrollContent, money_scrollContent, active_tab, active_subtab, filterType

local content_loaded = false
function f:Transactions()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]

        log_table = db.Transactions[db.Active.Realm][db.Active.Faction][db.Active.Guild][db.Active.Log]

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
  
        local transactions = CreateFrame("Button", addon .. "transactions", scrollContent, "UIMenuButtonStretchTemplate")
        transactions:SetSize(100, 25)
        transactions:SetPoint("TOPLEFT", scrollContent.header, "BOTTOMLEFT", 0, -10)
        transactions:SetText(L["Transactions"])
        transactions:SetPushedTextOffset(0, 0)
        transactions:Disable()

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
  
        local money = CreateFrame("Button", addon .. "money", scrollContent, "UIMenuButtonStretchTemplate")
        money:SetSize(100, 25)
        money:SetPoint("LEFT", transactions, "RIGHT", 10, 0)
        money:SetText(L["Money Log"])
        money:SetPushedTextOffset(0, 0)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
  
        copy = CreateFrame("Button", addon .. "copy", scrollContent, "UIMenuButtonStretchTemplate")
        copy:SetSize(50, 25)
        copy:SetPoint("LEFT", money, "RIGHT", 10, 0)
        copy:SetText(L["Copy"])
        copy:SetPushedTextOffset(0, 0)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        local filter = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        filter:SetPoint("LEFT", copy, "RIGHT", 10, 0)
        filter:SetText(L["Filter"])

        filterDropDownButton = CreateFrame("Button", "filterDropDownButton", scrollContent, "UIDropDownMenuTemplate")
        filterDropDownButton:SetPoint("LEFT", filter, "RIGHT", 0, 0)
        UIDropDownMenu_JustifyText(filterDropDownButton, "LEFT")
        UIDropDownMenu_SetWidth(filterDropDownButton, 150);
        UIDropDownMenu_SetButtonWidth(filterDropDownButton, 150)

        UIDropDownMenu_Initialize(filterDropDownButton, f.filterDropDownButtonInitialization, nil, 1, false)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
    
        transactions_scrollFrame = CreateFrame("ScrollFrame", addon .. "transactions_scrollFrame", scrollContent, "UIPanelScrollFrameTemplate")
        transactions_scrollFrame:SetPoint("TOPLEFT", transactions, "BOTTOMLEFT", 0, -10)
        transactions_scrollFrame:SetPoint("BOTTOMRIGHT", scrollContent, "BOTTOMRIGHT", -26, 10)

        transactions_scrollFrame.ScrollBar:EnableMouseWheel(true)
        transactions_scrollFrame.ScrollBar:SetScript("OnMouseWheel", function(self, direction)
            ScrollFrameTemplate_OnMouseWheel(transactions_scrollFrame, direction)
        end)

        transactions_scrollFrame.scrollTexture = transactions_scrollFrame:CreateTexture(nil, "BACKGROUND", nil, -6)
        transactions_scrollFrame.scrollTexture:SetPoint("TOP")
        transactions_scrollFrame.scrollTexture:SetPoint("BOTTOM")
        transactions_scrollFrame.scrollTexture:SetPoint("RIGHT", 26, 0)
        transactions_scrollFrame.scrollTexture:SetWidth(26)
        transactions_scrollFrame.scrollTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar.blp")
        transactions_scrollFrame.scrollTexture:SetTexCoord(0, 0.45, 0.1640625, 1)
        transactions_scrollFrame.scrollTexture:SetAlpha(0.5)

        transactions_scrollFrame:SetBackdrop({
            bgFile = [[Interface\Buttons\WHITE8x8]],
            insets = {left = 0, right = 0, top = 0, bottom = 0
        }})
        transactions_scrollFrame:SetBackdropColor(0, 0, 0, 0.5)

        transactions_scrollContent = CreateFrame("Frame", addon .."transactions_scrollContent", transactions_scrollFrame)
        transactions_scrollContent:SetSize(transactions_scrollFrame:GetWidth(), transactions_scrollFrame:GetHeight())
        transactions_scrollContent:SetAllPoints(transactions_scrollFrame)
        transactions_scrollFrame:SetScrollChild(transactions_scrollContent)

        money_scrollContent = CreateFrame("Frame", addon .."money_scrollContent", transactions_scrollFrame)
        money_scrollContent:SetSize(transactions_scrollFrame:GetWidth(), transactions_scrollFrame:GetHeight())
        money_scrollContent:SetAllPoints(transactions_scrollFrame)
        money_scrollContent:Hide()

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
      
        transaction_buttons = {}
        for i = 1, 8 do
            local tab_button = CreateFrame("Button", addon .. "tab_button" .. i, transactions_scrollContent, "UIMenuButtonStretchTemplate")
            tab_button:SetSize(50, 25)
            tab_button:SetPoint("TOPRIGHT", transactions_scrollContent, "TOPLEFT", (i * (tab_button:GetWidth() + 2)) + 5, -10)
            tab_button:SetText(i)
            tab_button:SetPushedTextOffset(0, 0)
            tab_button.i = i
            if i == 1 or i > log_table.MaxTabs - 1 then
                tab_button:Disable()
            else
                tab_button:Enable()
            end

            tab_button:SetScript("OnClick", function(self)
                for k, v in pairs(transaction_buttons) do
                    if v == self or v.i > log_table.MaxTabs - 1 then
                        v:Disable()
                    else
                        v:Enable()
                    end
                end

                active_tab = 1
                active_subtab = i
                f:LoadActiveTransactions()
                f:ClearFilter()
            end)

            tinsert(transaction_buttons, tab_button)
        end

        active_tab = 1
        active_subtab = 1

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        copy_scrollContent = CreateFrame("EditBox", "ExportEditBox", transactions_scrollFrame)
        copy_scrollContent:SetSize(transactions_scrollFrame:GetWidth(), transactions_scrollFrame:GetHeight())
        copy_scrollContent:SetAllPoints(transactions_scrollFrame)

        copy_scrollContent:SetFontObject(GameFontHighlightSmall)
        copy_scrollContent:SetAutoFocus(false)
        copy_scrollContent:SetTextInsets(10, 10, 10, 10)
        copy_scrollContent:SetMaxLetters(999999)
        copy_scrollContent:SetMultiLine(true)

        copy_scrollContent:Hide()
        
        copy_scrollContent:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        transactions:SetScript("OnClick", function(self)
            self:Disable()
            transactions_scrollContent:Show()

            for k, v in pairs(transaction_buttons) do
                v:Show()
                if v.i == active_subtab or v.i > log_table.MaxTabs - 1 then
                    v:Disable()
                else
                    v:Enable()
                end
            end

            copy:Enable()
            copy_scrollContent:Hide()

            money:Enable()
            money_scrollContent:Hide()

            transactions_scrollFrame:SetVerticalScroll(0)
            transactions_scrollFrame:SetScrollChild(transactions_scrollContent)
            UIDropDownMenu_Initialize(filterDropDownButton, f.filterDropDownButtonInitialization, nil, 1, false)
            CloseDropDownMenus()
        end)

        money:SetScript("OnClick", function(self)
            self:Disable()
            money_scrollContent:Show()

            copy:Enable()
            copy_scrollContent:Hide()

            transactions:Enable()
            transactions_scrollContent:Hide()

            for k, v in pairs(transaction_buttons) do
                v:Hide()
            end

            transactions_scrollFrame:SetVerticalScroll(0)
            transactions_scrollFrame:SetScrollChild(money_scrollContent)
            UIDropDownMenu_Initialize(filterDropDownButton, f.filterDropDownButtonInitialization, nil, 1, false)
        end)

        copy:SetScript("OnClick", function(self)
            self:Disable()
            copy_scrollContent:Show()

            transactions:Enable()
            transactions_scrollContent:Hide()

            for k, v in pairs(transaction_buttons) do
                v:Hide()
            end

            money:Enable()
            money_scrollContent:Hide()

            transactions_scrollFrame:SetVerticalScroll(0)
            transactions_scrollFrame:SetScrollChild(copy_scrollContent)
            UIDropDownMenu_Initialize(filterDropDownButton, f.filterDropDownButtonInitialization, nil, 1, false)
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
 
        transactions_scrollContent:SetScript("OnShow", function()
            active_tab = 1
            active_subtab = 1
            f:LoadActiveTransactions()
        end)
 
        money_scrollContent:SetScript("OnShow", function()
            active_tab = 2
            f:LoadActiveTransactions()
        end)
 
        copy_scrollContent:SetScript("OnShow", function()
            f:LoadActiveTransactions(nil, nil, true)
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
  
        content_loaded = true
        f:LoadActiveTransactions()
    end
end

local transaction_lines = {}
local money_lines = {}
function f:LoadActiveTransactions(filter_type, filter_key, copy_tab)
    if content_loaded == true then
        log_table = db.Transactions[db.Active.Realm][db.Active.Faction][db.Active.Guild][db.Active.Log]

        if active_tab == 1 then
            for k, v in pairs(transaction_lines) do
                v:SetText("")
                v:ClearAllPoints()
                v:Hide()
            end

            if copy_tab then
                local msg = log_table.Transactions["Tab" .. active_subtab].Name .. "\n\n"

                for k, v in f:pairsByKeys(log_table.Transactions["Tab" .. active_subtab], function(a, b) a = tonumber(a) or 0; b = tonumber(b) or 0; return b < a end) do
                    if k ~= "Name" then
                        if (filter_type == "name" and filter_key == v[2]) or (filter_type == "type" and filter_key == v[1]) or (filter_type == "item" and filter_key == v[3]) or not filter_type then
                            msg = msg .. f:FormatMsg(v, "item") .. "\n"
                        end                        
                    end
                end

                copy_scrollContent:SetText(msg)
            else
                local i = 1
                local name = transactions_scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                name:SetPoint("TOPLEFT", 10, -40)
                name:SetText(log_table.Transactions["Tab" .. active_subtab].Name)
                transaction_lines[i] = name
                i = i + 1

                for k, v in f:pairsByKeys(log_table.Transactions["Tab" .. active_subtab], function(a, b) a = tonumber(a) or 0; b = tonumber(b) or 0; return b < a end) do
                    if k ~= "Name" then
                        if (filter_type == "name" and filter_key == v[2]) or (filter_type == "type" and filter_key == v[1]) or (filter_type == "item" and filter_key == v[3]) or not filter_type then
                            transaction_lines[i] = transactions_scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                            transaction_lines[i]:SetPoint("TOPLEFT", transaction_lines[1], "TOPLEFT", 0, -(transaction_lines[1]:GetStringHeight() * i))
                            transaction_lines[i]:SetText(f:FormatMsg(v, "item"))

                            i = i + 1
                        end
                    end
                end
            end
        else
            for k, v in pairs(money_lines) do
                v:SetText("")
                v:ClearAllPoints()
                v:Hide()
            end

            if copy_tab then
                local msg = string.format("Total: %s", GetCoinTextureString(log_table.MoneyTotal)) .. "\n\n"

                for k, v in f:pairsByKeys(log_table.Money) do
                    if (filter_type == "name" and filter_key == v[2]) or (filter_type == "type" and filter_key == v[1]) or not filter_type then
                            msg = msg .. f:FormatMsg(v, "money") .. "\n"
                    end
                end

                copy_scrollContent:SetText(msg)
            else

                local i = 1
                local total = money_scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                total:SetPoint("TOPLEFT", 10, -10)
                total:SetText(string.format("Total: %s", GetCoinTextureString(log_table.MoneyTotal)))
                money_lines[i] = total
                i = i + 1

                for k, v in f:pairsByKeys(log_table.Money) do
                    if (filter_type == "name" and filter_key == v[2]) or (filter_type == "type" and filter_key == v[1]) or not filter_type then
                        money_lines[i] = money_scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                        money_lines[i]:SetPoint("TOPLEFT", money_lines[1], "TOPLEFT", 0, -(money_lines[1]:GetStringHeight() * i))
                        money_lines[i]:SetText(f:FormatMsg(v, "money"))

                        i = i + 1
                    end
                end
            end
        end
    end
end

function f:filterDropDownButtonInitialization(level, menuList)
    if not menuList then
        filterType = false
        UIDropDownMenu_SetText(filterDropDownButton, "")
        CloseDropDownMenus()
    end

    local info = UIDropDownMenu_CreateInfo()

    if level == 1 then
        info.text = L["Name"]
        info.hasArrow = true
        info.menuList = L["Name"]
        UIDropDownMenu_AddButton(info)

        info.text = L["Type"]
        info.hasArrow = true
        info.menuList = L["Type"]
        UIDropDownMenu_AddButton(info)

        if active_tab == 1 then
            info.text = L["Item"]
            info.hasArrow =  true
            info.menuList = L["Item"]
            UIDropDownMenu_AddButton(info)
        end

        info.text = L["Clear Filter"]
        info.hasArrow = false
        info.func = f.ClearFilter
        UIDropDownMenu_AddButton(info)
    elseif menuList == "Name" then
        local names = {}

        local filterTBL = active_tab == 1 and log_table.Transactions["Tab" .. active_subtab] or log_table.Money
        for k, v in pairs(filterTBL) do
            if k ~= "Name" then
                names[v[2]] = true
            end
        end

        for k, v in f:pairsByKeys(names) do
            info.text = k
            info.checked = filterType == k
            info.func = function(self, ...)
                filterType = k
                UIDropDownMenu_SetText(filterDropDownButton, string.format("%s: %s", menuList, k))
                CloseDropDownMenus()
                f:LoadActiveTransactions("name", k, copy:GetButtonState() == "DISABLED")
            end
            UIDropDownMenu_AddButton(info, level)
        end
    elseif menuList == "Type" then
        local types = {}

        local filterTBL = active_tab == 1 and log_table.Transactions["Tab" .. active_subtab] or log_table.Money
        for k, v in pairs(filterTBL) do
            if k ~= "Name" then
                types[v[1]] = true
            end
        end

        for k, v in f:pairsByKeys(types) do
            info.text = k
            info.checked = filterType == k
            info.func = function(self, ...)
                filterType = k
                UIDropDownMenu_SetText(filterDropDownButton, string.format("%s: %s", menuList, k))
                CloseDropDownMenus()
                f:LoadActiveTransactions("type", k, copy:GetButtonState() == "DISABLED")
            end
            UIDropDownMenu_AddButton(info, level)
        end
    elseif menuList == "Item" then
        local items = {}

        for k, v in pairs(log_table.Transactions["Tab" .. active_subtab]) do
            if k ~= "Name" then
                local itemName = gsub(gsub(strsub(v[3], string.find(v[3], "%["), string.find(v[3], "%]")), "%[", ""), "%]", "")
                items[itemName] = v[3]
            end
        end

        for k, v in f:pairsByKeys(items) do
            info.text = k
            info.checked = filterType == k
            info.func = function(self, ...)
                filterType = k
                UIDropDownMenu_SetText(filterDropDownButton, string.format("%s: %s", menuList, k))
                CloseDropDownMenus()
                f:LoadActiveTransactions("item", v, copy:GetButtonState() == "DISABLED")
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
end

function f:ClearFilter()
    filterType = false
    UIDropDownMenu_SetText(filterDropDownButton, "")
    CloseDropDownMenus()
    f:LoadActiveTransactions()
end
