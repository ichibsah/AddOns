-- Copyright © 2008 - 2012 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

if select(2,UnitClass("player")) ~= "SHAMAN" then return end

local nrfonts = 0

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)

local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)

local LibDialog = LibStub:GetLibrary("LibDialog-1.0")


TotemTimers.options = {
    type = "group",
    args = {
        general = {
            type = "group",
            name = "general",
            args = {
                version= {
                    order = 0,
                    type ="description",
                    name = L["Version"]..": "..tostring(GetAddOnMetadata("TotemTimers", "Version"))
                },
				unlockspells = {
				    order = 1,
                    type = "execute",
                    name = L["Unlock Spells"],
                    desc = L["Unlocks the button grid to change the spells on the timer buttons"],
                    func = function(info, val) XiTimers.ShowGrid() LibDialog:Spawn("XiTimers_Spells") InterfaceOptionsFrame:Hide() end,			
                    get = function(info) return TotemTimers.ActiveProfile.UnlockSpells end,
				},
                unlock = {
                    order = 2,
                    type = "execute",
                    name = L["Unlock Bars"],
                    desc = L["Unlocks the position of MonkTimers Bars and Frames"],
                    func = function(info, val) XiTimers.UnlockBars() LibDialog:Spawn("XiTimers_Bars") InterfaceOptionsFrame:Hide() end,
                },   
                flashred = {
                    order = 3,
                    type = "toggle",
                    name = L["Red Flash Color"],
                    desc = L["RedFlash Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.FlashRed = val TotemTimers.ProcessSetting("FlashRed") end,
                    get = function(info) return TotemTimers.ActiveProfile.FlashRed end,
                }, 
                stoppulse = {
                    order = 4,
                    type = "toggle",
                    name = L["Stop Pulse"],
                    desc = L["Stop Pulse Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.StopPulse = val TotemTimers.ProcessSetting("StopPulse") end,
                    get = function(info) return TotemTimers.ActiveProfile.StopPulse end,
                },
                showTimerBars = {
                    order = 5,
                    type = "toggle",
                    name = L["Show Timer Bars"],
                    desc = L["Displays timer bars underneath times"],
                    set = function(info, val) TotemTimers.ActiveProfile.ShowTimerBars = val TotemTimers.ProcessSetting("ShowTimerBars") end,
                    get = function(info) return TotemTimers.ActiveProfile.ShowTimerBars end,
                },
                timersonbuttons = {
                    order = 6,
                    type = "toggle",
                    name = L["Timers On Buttons"],
                    desc = L["Timers On Buttons Desc"],
                    set = function(info, val) 
                        TotemTimers.ActiveProfile.TimersOnButtons = val 
                        TotemTimers.ProcessSetting("TimersOnButtons")
                        for i=1,#XiTimers.timers do
                            XiTimers.timers[i]:SetTimerBarPos(XiTimers.timers[i].timerBarPos)
                        end
                    end,
                    get = function(info) return TotemTimers.ActiveProfile.TimersOnButtons end,
                },
                hideblizztimers = {
                    order = 7,
                    type = "toggle",
                    name = L["Hide Blizzard Timers"],
                    set = function(info, val) TotemTimers.ActiveProfile.HideBlizzTimers = val TotemTimers.ProcessSetting("HideBlizzTimers") end,
                    get = function(info) return TotemTimers.ActiveProfile.HideBlizzTimers end,
                },                  
                hidedefaulttotembar = {
                    order = 8,
                    type = "toggle",
                    name = L["Hide Default Totem Bar"],
                    desc = L["Hide Default Totem Bar Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.HideDefaultTotemBar = val
                            TotemTimers.ProcessSetting("HideDefaultTotemBar") end,
                    get = function(info) return TotemTimers.ActiveProfile.HideDefaultTotemBar  end,
                },                  
                tooltips = {
                    order = 9,
                    type = "toggle",
                    name = L["Show Tooltips"],
                    desc = L["Shows tooltips on timer and totem buttons"],
                    set = function(info, val) TotemTimers.ActiveProfile.Tooltips = val TotemTimers.ProcessSetting("Tooltips") end,
                    get = function(info) return TotemTimers.ActiveProfile.Tooltips end,
                },  
                tooltipsatbuttons = {
                    order = 10,
                    type = "toggle",
                    name = L["Tooltips At Buttons"],
                    desc = L["Tooltips At Buttons Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.TooltipsAtButtons = val TotemTimers.ProcessSetting("TooltipsAtButtons") end,
                    get = function(info) return TotemTimers.ActiveProfile.TooltipsAtButtons end,
                },
                HideInVehicle = {
                    order = 11,
                    type = "toggle",
                    name = L["Hide In Vehicles"],
                    desc = L["Hide In Vehicles Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.HideInVehicle = val TotemTimers.ProcessSetting("HideInVehicle") end,
                    get = function(info) return TotemTimers.ActiveProfile.HideInVehicle end,
                },                
                Keybinds = {
                     order = 12,
                   type = "toggle",
                    name = L["Show Key Bindings"],
                    desc = L["Shows key bindings on totem timers"],
                    set = function(info, val) TotemTimers.ActiveProfile.ShowKeybinds = val TotemTimers.ProcessSetting("ShowKeybinds") end,
                    get = function(info) return TotemTimers.ActiveProfile.ShowKeybinds end,
                },                 
                --[[h3 = {
                    order = 100,
                    type = "header",
                    name = "",
                },
                lavasurgeaura = {
                    order = 11,
                    type = "toggle",
                    name = L["Lava Surge Aura"],
                    desc = L["Lava Surge Aura Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.LavaSurgeAura = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveProfile.LavaSurgeAura end,
                },
                lavasurgeglow = {
                    order = 12,
                    type = "toggle",
                    name = L["Lava Surge Glow"],
                    desc = L["Lava Surge Glow Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.LavaSurgeGlow = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveProfile.LavaSurgeGlow end,
                },]]
                --[[fulminationaura = {
                    order = 11,
                    type = "toggle",
                    name = L["Fulmination Aura"],
                    desc = L["Fulmination Aura Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.FulminationAura = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveProfile.FulminationAura end,
                },
                fulminationglow = {
                    order = 12,
                    type = "toggle",
                    name = L["Fulmination Glow"],
                    desc = L["Fulmination Glow Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.FulminationGlow = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveProfile.FulminationGlow end,
                },]]
                h1 = {
                    order = 20,
                    type = "header",
                    name = "",
                },
                TimerBarTexture = {
                    order = 35,
                    type = "select",
                    name = L["Timer Bar Texture"],
                    values = AceGUIWidgetLSMlists.statusbar,
                    set = function(info, val) TotemTimers.ActiveProfile.TimerBarTexture = val TotemTimers.ProcessSetting("TimerBarTexture") end,
                    get = function(info) return TotemTimers.ActiveProfile.TimerBarTexture end,
                    dialogControl = "LSM30_Statusbar",
                },                
                TimeFont = {
                    order = 35,
                    type = "select",
                    name = L["Time Font"] ,
                    values = AceGUIWidgetLSMlists.font,
                    set = function(info, val) TotemTimers.ActiveProfile.TimeFont = val TotemTimers.ProcessSetting("TimeFont") end,
                    get = function(info) return TotemTimers.ActiveProfile.TimeFont end,
                    dialogControl = "LSM30_Font",
                }, 
                TimeColor = {
                    order = 36,
                    type = "color",
                    name = L["Time Color"],
                    set = function(info, r,g,b)
                        TotemTimers.ActiveProfile.TimeColor.r = r
                        TotemTimers.ActiveProfile.TimeColor.g = g
                        TotemTimers.ActiveProfile.TimeColor.b = b
                        TotemTimers.ProcessSetting("TimeColor")
                    end,
                    get = function(info) return TotemTimers.ActiveProfile.TimeColor.r,
                                                TotemTimers.ActiveProfile.TimeColor.g,
                                                TotemTimers.ActiveProfile.TimeColor.b,
                                                1
                          end,
                },
                TimerBarColor = {
                    order = 37,
                    type = "color",
                    name = L["Timer Bar Color"],
                    hasAlpha = true,
                    set = function(info, r,g,b,a)
                        TotemTimers.ActiveProfile.TimerBarColor.r = r
                        TotemTimers.ActiveProfile.TimerBarColor.g = g
                        TotemTimers.ActiveProfile.TimerBarColor.b = b
                        TotemTimers.ActiveProfile.TimerBarColor.a = a
                        TotemTimers.ProcessSetting("ColorTimerBars")
                    end,
                    get = function(info) return TotemTimers.ActiveProfile.TimerBarColor.r,
                                                TotemTimers.ActiveProfile.TimerBarColor.g,
                                                TotemTimers.ActiveProfile.TimerBarColor.b,
                                                TotemTimers.ActiveProfile.TimerBarColor.a
                          end,
                },
				hm = {
					order = 200,
					type = "header",
					name = "",
				},
				maelstrombar = {
                    order = 201,
                    type = "toggle",
                    name = L["Maelstrom Bar"],
                    desc = L["Maelstrom Bar Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.MaelstromBar = val TotemTimers.ProcessSetting("MaelstromBar") end,
                    get = function(info) return TotemTimers.ActiveProfile.MaelstromBar end,
                }, 
				manabar = {
                    order = 202,
                    type = "toggle",
                    name = L["Mana Bar"],
                    desc = L["Mana Bar Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.ManaBar = val TotemTimers.ProcessSetting("ManaBar") end,
                    get = function(info) return TotemTimers.ActiveProfile.ManaBar end,
                }, 
				flameshockbar = {
                    order = 203,
                    type = "toggle",
                    name = L["Flame Shock Duration"],
                    desc = L["Flame Shock Duration Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.FlameshockBar = val TotemTimers.ProcessSetting("FlameshockBar") end,
                    get = function(info) return TotemTimers.ActiveProfile.FlameshockBar end,
                },
				flameshockbarresto = {
                    order = 204,
                    type = "toggle",
                    name = L["Flame Shock Duration Restoration"],
                    desc = L["Flame Shock Duration Restoration Desc"],
                    set = function(info, val) TotemTimers.ActiveProfile.FlameshockBarRestoration = val TotemTimers.ProcessSetting("FlameshockBarRestoration") end,
                    get = function(info) return TotemTimers.ActiveProfile.FlameshockBarRestoration end,
                }, 
                --[[h2 = {
                    order = 70,
                    type = "header",
                    name = "",
                },
                Debug = {
                    order = -1,
                    type = "execute",
                    name = L["Debug"] ,
                    func = function() HideUIPanel(InterfaceOptionsFrame) TotemTimers_DebugScrollFrame:Show() end
                }, ]]               
            },
        },
    },
}


local ACR =	LibStub("AceConfigRegistry-3.0")
ACR:RegisterOptionsTable("TotemTimers", TotemTimers.options)
local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", "TotemTimers", nil, "general")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
TotemTimers.LastGUIPanel = frame




