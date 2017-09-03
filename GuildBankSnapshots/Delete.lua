local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 5

local deleteActive, deleteAll

local content_loaded = false
function f:Delete()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]   

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
     
        local warning = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        warning:SetPoint("TOPLEFT", scrollContent.header, "BOTTOMLEFT", 0, -10)
        warning:SetText(L["WARNING: Deletion is permanent. If you need to clear space, you may export your logs to create a CSV file for backup. Please check the Export page for more information."])
        warning:SetWordWrap(true)
        warning:SetJustifyH("LEFT")
        warning:SetWidth(scrollContent:GetWidth() - 20)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

        deleteActive = CreateFrame("Button", addon .. "deleteActive", scrollContent, "UIMenuButtonStretchTemplate")
        deleteActive:SetSize(100, 25)
        deleteActive:SetPoint("TOPLEFT", warning, "BOTTOMLEFT", 0, -10)
        deleteActive:SetText(L["Delete Active"])
        deleteActive:SetPushedTextOffset(0, 0)
        if db.Active.Log then
            deleteActive:Enable()
        else
            deleteActive:Disable()
        end

        deleteActive:SetScript("OnClick", function()
            local active = db.Active
            db.Transactions[active.Realm][active.Faction][active.Guild][active.Log] = nil

            if f:count(db.Transactions[active.Realm][active.Faction][active.Guild]) == 0 then
                db.Transactions[active.Realm][active.Faction][active.Guild] = nil
                if f:count(db.Transactions[active.Realm][active.Faction]) == 0 then
                    db.Transactions[active.Realm][active.Faction] = nil
                    if f:count(db.Transactions[active.Realm]) == 0 then
                        db.Transactions[active.Realm] = nil
                    end
                end
            end

            db.Active.Log = false
            db.Active.Guild = false
            db.Active.Faction = false
            db.Active.Realm = false

            f.activeLog:SetText("")
            f:ClearSelectLog()
            f:ClearExports()
            
            f.frame.buttons[3][4]:Disable()

            deleteActive:Disable()

            if f:count(db.Transactions) == 0 then
                deleteAll:Disable()
            end
        end)
  
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
       
        deleteAll = CreateFrame("Button", addon .. "deleteAll", scrollContent, "UIMenuButtonStretchTemplate")
        deleteAll:SetSize(100, 25)
        deleteAll:SetPoint("LEFT", deleteActive, "RIGHT", 25, 0)
        deleteAll:SetText(L["Delete All"])
        deleteAll:SetPushedTextOffset(0, 0)
        if f:count(db.Transactions) ~= 0 then
            deleteAll:Enable()
        else
            deleteAll:Disable()
        end

        deleteAll:SetScript("OnClick", function()
            table.wipe(db.Transactions)

            db.Active.Log = false
            db.Active.Guild = false
            db.Active.Faction = false
            db.Active.Realm = false

            f.activeLog:SetText("")
            f:ClearSelectLog()
            f:ClearExports()
            
            f.frame.buttons[3][4]:Disable()

            deleteAll:Disable()
            deleteActive:Disable()
        end)
  
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
       
        scrollContent:SetScript("OnShow", function()
            if db.Active.Log then
                deleteActive:Enable()
            else
                deleteActive:Disable()
            end
        end)

-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
        
        content_loaded = true
    else
        if db.Active.Log then
            deleteActive:Enable()
        else
            deleteActive:Disable()
        end

        if f:count(db.Transactions) ~= 0 then
            deleteAll:Enable()
        else
            deleteAll:Disable()
        end
    end
end

function f:ActivateDeletion()
    if content_loaded then
        deleteAll:Enable()
        deleteActive:Enable()
    end
end
