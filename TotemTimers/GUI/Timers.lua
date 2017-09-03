-- Copyright © 2008 - 2012 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

if select(2,UnitClass("player")) ~= "SHAMAN" then return end

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)


TotemTimers.options.args.timers = {
    type = "group",
    name = "timers",
    args = {
        clickthrough = {
            order = 1,
            type = "toggle", 
            name = L["Clickthrough"],
            desc = L["Clickthrough Desc"],
            set = function(info, val) TotemTimers.ActiveProfile.Clickthrough = val  TotemTimers.ProcessSetting("Clickthrough") end,
            get = function(info) return TotemTimers.ActiveProfile.Clickthrough end,
        },
        h1 = {
            order = 2,
            type = "header",
            name = "",
        },
        time = {
            order = 8,
            type = "select",
            name = L["Time Style"],
            desc = L["Sets the format in which times are displayed"],
            values = {["mm:ss"] = "mm:ss", blizz = L["Blizz Style"], },
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimeStyle = val  TotemTimers.ProcessSetting("TimeStyle")
                        TotemTimers.ActiveProfile.TimeStyle = val  TotemTimers.ProcessSetting("TimeStyle")
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimeStyle end,
        },
        timepos = {
            order = 9,
            type = "select",
            name = L["Timer Bar Position"],
            desc = L["Timer Bar Position Desc"],
            values = {	["TOP"] = L["Top"], ["BOTTOM"] = L["Bottom"],},
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimerTimePos = val  TotemTimers.ProcessSetting("TimerTimePos")	
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimerTimePos end,
        },
        sizes = {
            order = 10,
            type = "header",
            name = L["Scaling"],
        },
        timerSize = {
            order = 11,
            type = "range",
            name = L["Button Size"],
            desc = L["Scales the timer buttons"],
            min = 16,
            max = 96,
            step = 1,
            bigStep = 2,
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimerSize = val  TotemTimers.ProcessSetting("TimerSize")	
						XiTimers.LoadProfile()
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimerSize end,
        },
        timerTimeHeight = {
            order = 12,
            type = "range",
            name = L["Time Size"],
            desc = L["Sets the font size of time strings"],
            min = 6,
            max = 40,
            step = 1,
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimerTimeHeight = val  TotemTimers.ProcessSetting("TimerTimeHeight")
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimerTimeHeight end,
        },
        spacing = {
            order = 13,
            type = "range",
            name = L["Spacing"] ,
            desc = L["Sets the space between timer buttons"],
            min = -2,
            max = 20,
            step = 1,
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimerSpacing = val  TotemTimers.ProcessSetting("TimerSpacing")	
						XiTimers.LoadProfile()
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimerSpacing end,
        },
        timeSpacing = {
            order = 14,
            type = "range",
            name = L["Time Spacing"],
            desc = L["Sets the space between timer buttons and timer bars"],
            min = 0,
            max = 20,
            step = 1,
            set = function(info, val)
                        TotemTimers.ActiveProfile.TimerTimeSpacing = val  TotemTimers.ProcessSetting("TimerTimeSpacing")	
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TimerTimeSpacing end,
        },
        timerBarWidth = {
            order = 15,
            type = "range",
            name = L["Timer Bar Width"],
            desc = L["Timer Bar Width Desc"],
            min = 36,
            max = 300,
            step = 4,
            set = function(info, val)
                        TotemTimers.ActiveProfile.TotemTimerBarWidth = val  TotemTimers.ProcessSetting("TotemTimerBarWidth")	
                  end,
            get = function(info) return TotemTimers.ActiveProfile.TotemTimerBarWidth end,
        },
	
                                   
    },
}

for i = 1,5 do
	TotemTimers.options.args.timers.args["hbar"..i] = {
		order = 100*i,
		type = "header",
		name = L["Bar"].." "..i
	}
	TotemTimers.options.args.timers.args["barbuttonpos"..i] = {
	    order = 100*i+1,
		type = "select",
		name = L["Move Active Buttons to"],
		desc = L["Move Active Buttons to Desc"],
		values = { ["center"] = L["Center"], ["left"] = L["Left"], ["right"] = L["Right"], ["grid"] = L["Don't Move"]},
		set = function(info, val)
					TotemTimers.ActiveProfile.ActionBarButtonPosition[i] = val
					TotemTimers.ProcessSetting("ActionBarButtonPosition")	
					XiTimers.PositionTimersOnBars(XiTimers.grid)
			  end,
		get = function(info) return TotemTimers.ActiveProfile.ActionBarButtonPosition[i] end,
	}
end

local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["Timers"], "TotemTimers", "timers")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
