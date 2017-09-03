local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local tabNum = 7

local content_loaded = false
function f:Help()
    if not content_loaded then
        local scrollContent = f.frame.scrollContent[tabNum]

        local strings = {
            {"If you need assistance with the addon or have any suggestions/requests, please leave a comment on Curse/WoW Interface.", false},
            {"Common Issues", true},
            {"If you have an incomplete scan (usually upon first logging in), simply delete the scan and try again. Usually when this is happening, it's because there wasn't enough time to query the bank log. The second scan should be complete.", false},
            {"Slash Commands", true},
            {"/gbs = Opens main addon frame", false},
            {"/gbs scan = Scans guild bank to create log (same function as using the button)", false}
        }

        local lines = {}

        i = 1
        for k, v in pairs(strings) do
            lines[i] = scrollContent:CreateFontString(nil, "OVERLAY", v[2] and "GameFontNormal" or "GameFontHighlight")
            lines[i]:SetWidth(scrollContent:GetWidth() - 20)
            lines[i]:SetPoint("TOPLEFT", i > 1 and lines[i - 1] or scrollContent.header, "BOTTOMLEFT", 0, v[2] and -10 or -5)

            lines[i]:SetText(v[1])
            lines[i]:SetJustifyH("LEFT")
            lines[i]:SetWordWrap(true)

            i = i + 1
        end

        content_loaded = true
    end
end
