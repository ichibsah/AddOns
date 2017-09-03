local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

local frame_loaded = false
function f:CreateFrame()
    if frame_loaded then
        if f.frame:IsVisible() then
            f.frame:Hide()
        else
            f.frame:Show()
        end
    else
        local frame = CreateFrame("Frame", addon .. "Frame", UIParent, "BasicFrameTemplate")
        f.frame = frame
        frame:SetSize(700, 400)
        frame:SetPoint("CENTER", 0, 0)
        frame:EnableMouse(true)
        frame:SetMovable(true)

        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOPLEFT", 10, -5)
        title:SetText(L["Guild Bank Snapshots"])

        local activeLog = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        activeLog:SetPoint("LEFT", title, "RIGHT", 10, 0)
        f.activeLog = activeLog

        local buttons = {
           [1] = {L["Scan Bank"], f.Scan, false},
           [2] = {L["Select Log"], f.ShowTab, true},
           [3] = {L["Transactions"], f.ShowTab, false},
           [4] = {L["Export"], f.ShowTab, true},
           [5] = {L["Delete"], f.ShowTab, true},
           [6] = {L["Settings"], f.ShowTab, true},
           [7] = {L["Help"], f.ShowTab, true},
        }

        f.menuButtons = {}

        for k, v in pairs(buttons) do
            local tab_button = CreateFrame("Button", addon .. "Button" .. k, frame, "UIMenuButtonStretchTemplate")
            tab_button:SetSize(125, 25)
            tab_button:SetText(v[1])
            tab_button:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -(k * (tab_button:GetHeight() + 2)) - 5)
            tab_button:SetPushedTextOffset(0, 0)

            if v[3] then
                tab_button:Enable()
            else
                tab_button:Disable()
            end

            local name = string.gsub(v[1], "%s+", "")

            tab_button:SetScript("OnClick", function()
                v[2](f, k, name)
            end)

            f.menuButtons[name] = tab_button

            tinsert(buttons[k], tab_button)
        end

        frame.buttons = buttons

        local scrollFrame = CreateFrame("ScrollFrame", addon .. "ScrollFrame", frame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetSize(frame:GetWidth() - 145, frame:GetHeight() - 44)
        frame.scrollFrame = scrollFrame

        scrollFrame:SetPoint("TOP", 0, -34)
        scrollFrame:SetPoint("LEFT", 145, 0)
        scrollFrame:SetPoint("BOTTOM", 0, 7)
        scrollFrame:SetPoint("RIGHT", -32, 0)

        scrollFrame.ScrollBar:EnableMouseWheel(true)
        scrollFrame.ScrollBar:SetScript("OnMouseWheel", function(self, direction)
            ScrollFrameTemplate_OnMouseWheel(scrollFrame, direction)
        end)

        scrollFrame.scrollTexture = scrollFrame:CreateTexture(nil, "BACKGROUND", nil, -6)
        scrollFrame.scrollTexture:SetPoint("TOP")
        scrollFrame.scrollTexture:SetPoint("BOTTOM")
        scrollFrame.scrollTexture:SetPoint("RIGHT", 26, 0)
        scrollFrame.scrollTexture:SetWidth(26)
        scrollFrame.scrollTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar.blp")
        scrollFrame.scrollTexture:SetTexCoord(0, 0.45, 0.1640625, 1)
        scrollFrame.scrollTexture:SetAlpha(0.5)

        scrollFrame.texture = scrollFrame:CreateTexture()
        scrollFrame.texture:SetAllPoints(scrollFrame)
        scrollFrame.texture:SetTexture(0, 0, 0, 0.5)

        frame.scrollContent = {}

        for k, v in pairs(buttons) do
            local scrollContent = CreateFrame("Frame", addon .. v[1] .. "ScrollContent", scrollFrame)
            scrollContent:SetSize(scrollFrame:GetWidth(), scrollFrame:GetHeight())
            scrollContent:SetAllPoints(scrollFrame)

            frame.scrollContent[k] = scrollContent

            local header = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            header:SetPoint("TOPLEFT", 0, 0)
            header:SetText(v[1])
            scrollContent.header = header
        end

        f:ShowTab(2, "SelectLog")
        if db.Active.Log then
            f:SelectLog()
        end

        frame:Show()
        frame_loaded = true
    end
end

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

function f:ShowTab(tabNum, func)
    local scrollFrame = f.frame.scrollFrame
    local scrollContent = f.frame.scrollContent
    for k, v in pairs(scrollContent) do
        if k == tabNum then
            scrollContent[k]:Show()
            scrollFrame:SetScrollChild(scrollContent[k])

            if func then
                f[func]()
            end
        else
            scrollContent[k]:Hide()
        end
    end
end
