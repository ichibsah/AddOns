-- Copyright © 2008 - 2012 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowinterface.com and their respective addon updaters

if select(2,UnitClass("player")) ~= "SHAMAN" then return end

if not TotemTimers then
	TotemTimers = {}
end

local SpellIDs = TotemTimers.SpellIDs

local Version = 12.01

TotemTimers.DefaultGlobalSettings = {
	Version = 12.01,
    Profiles = {},
    Sink = {}
}

TotemTimers_Profiles = {
    ["default"] = {}
}
TotemTimers_GlobalSettings = {}

TotemTimers.DefaultProfile = {

    --General            
        Lock = false,
        FlashRed = true,
        ShowTimerBars = true,
        HideBlizzTimers = true,
        Tooltips = true,
        TooltipsAtButtons = false,
        TimeFont = "Friz Quadrata TT",
        TimeColor = {r=1,g=1,b=1},
        TimerBarTexture = "Blizzard",
        TimerBarColor = {r=0.5,g=0.5,b=1.0,a=1.0},
        ShowKeybinds = true,
        HideInVehicle = true,
        StopPulse = true,
        TimersOnButtons = true,
        LavaSurgeAura = true,
        LavaSurgeGlow = true,
        FulminationAura = true,
        FulminationGlow = true,
		
		ActionBarButtonPosition = {
			"center",
			"center",
			"center",
			"right",
			"left",
		},

        
    --Timers 
        Show = true,
        Order = {1,2,3,4,},
        Arrange = "horizontal",
        TimeStyle = "mm:ss",
        TimerTimePos = "BOTTOM",   
        CastBarDirection = "auto",
        TimerSize = 32,
        TimerTimeHeight = 12,	
        TimerSpacing = 5,
        TimerTimeSpacing = 0,
        TotemTimerBarWidth = 36,
        TotemMenuSpacing = 0,
        OpenOnRightclick = false,
        MenusAlwaysVisible = false,
        BarBindings = true,
        ReverseBarBindings = false,    
        MiniIcons = true,
        ProcFlash = true,
        ColorTimerBars = false,
        ShowCooldowns = true,
        CheckPlayerRange = true,
        CheckRaidRange = true,	
        CheckRaidRange = true,	
        ShowRaidRangeTooltip = true,

        
    --Trackers
        TrackerArrange = "horizontal",
        TrackerTimePos = "BOTTOM",
        TrackerSize = 30,
        TrackerTimeHeight=12,
        TrackerSpacing = 5,
        TrackerTimeSpacing = 0,
        TrackerTimerBarWidth = 36,
        AnkhTracker = true,
        ShieldTracker = true,
        EarthShieldTracker = true,
        EarthShieldLeftButton = "recast", 
        EarthShieldRightButton = "target",
        EarthShieldMiddleButton = "targettarget",
        EarthShieldButton4 = "player",
        EarthShieldTargetName = true,
        ESMainTankMenu = true,
        ESMainTankMenuDirection = "auto",
        ESChargesOnly = false,
        
    --Warnings
        ActivateHiddenTimers = false,
        Warnings = {
            TotemWarning = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Totem Expiring",
                enabled = true,
            },
            TotemExpiration = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Totem Expired",            
                enabled = true,
            },
            TotemDestroyed = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Totem Destroyed",            
                enabled = true,
            },
            Shield = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Shield removed",            
                enabled = true,
            },
            EarthShield = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Shield removed",            
                enabled = true,
            },
            Maelstrom = {
                r = 1,
                g = 0,
                b = 0,
                a = 1,
                sound = "",
                text = "Maelstrom Notifier",            
                enabled = true,
            },
        },
        
        LastMainEnchants = {},
        LastOffEnchants = {},


        ShowOmniCCOnEnhanceCDs = true,
        EnhanceCDsOOCAlpha = 0.4,
        CDTimersOnButtons = true,
        Clickthrough = false,
		FlameshockBar = true,
		FlameshockBarRestoration = true,
		
		MaelstromBar = true,
		ManaBar = true,

		CooldownSpacing = 5,
    
        FramePositions = {

        },

		["Anchors"] = {
			["TotemTimers_FSAnchor"] = {
				["yOffset"] = -64.5334625244141,
			},
			["XiTimersBar5"] = {
				["pointFrom"] = "RIGHT",
				["xOffset"] = -139.559768676758,
				["pointTo"] = "RIGHT",
				["yOffset"] = -107.200096130371,
			},
			["XiTimersBar1"] = {
				["yOffset"] = -107.199920654297,
			},
			["XiTimersBar3"] = {
				["pointFrom"] = "LEFT",
				["pointTo"] = "LEFT",
				["xOffset"] = 139.466781616211,
				["yOffset"] = -72.0003509521484,
			},
			["XiTimers_PowerBar"] = {
				["pointFrom"] = "BOTTOM",
				["pointTo"] = "BOTTOM",
				["yOffset"] = 210.564834594727,
			},
			["XiTimersBar2"] = {
				["xOffset"] = 4.66856909042690e-005,
				["yOffset"] = -142.400451660156,
			},
			["XiTimersBar4"] = {
				["pointFrom"] = "LEFT",
				["xOffset"] = 139.426254272461,
				["pointTo"] = "LEFT",
				["yOffset"] = -107.199775695801,
			},
		},
		
		["buttons"] = {
			["SHAMAN"] = {
				{
					nil, -- [1]
					nil, -- [2]
					{
						["id"] = 117014,
						["type"] = "spell",
					}, -- [3]
					{
						["id"] = 51505,
						["type"] = "spell",
					}, -- [4]
					{
						["id"] = 188389,
						["type"] = "spell",
					}, -- [5]
					{
						["id"] = 196840,
						["type"] = "spell",
					}, -- [6]
					{
						["id"] = 8042,
						["type"] = "spell",
					}, -- [7]
					{
						["id"] = 57994,
						["type"] = "spell",
					}, -- [8]
					[13] = {
						["id"] = 108271,
						["type"] = "spell",
					},
					[35] = {
						["id"] = 192058,
						["type"] = "spell",
					},
					[14] = {
						["id"] = 51490,
						["type"] = "spell",
					},
					[39] = {
						["id"] = 2825,
						["type"] = "spell",
					},
					[15] = {
						["id"] = 198103,
						["type"] = "spell",
					},
					[16] = {
						["id"] = 192249,
						["type"] = "spell",
					},
					[17] = {
						["id"] = 210714,
						["type"] = "spell",
					},
					[18] = {
						["id"] = 20608,
						["type"] = "spell",
					},
					[36] = {
						["id"] = 108281,
						["type"] = "spell",
					},
					[38] = {
						["id"] = 61882,
						["type"] = "spell",
					},
					[40] = {
						["id"] = 51514,
						["type"] = "spell",
					},
					[34] = {
						["id"] = 192222,
						["type"] = "spell",
					},
					[37] = {
						["id"] = 210643,
						["type"] = "spell",
					},
				}, -- [1]
				{
					nil, -- [1]
					nil, -- [2]
					{
						["id"] = 193786,
						["type"] = "spell",
					}, -- [3]
					{
						["id"] = 17364,
						["type"] = "spell",
					}, -- [4]
					{
						["id"] = 60103,
						["type"] = "spell",
					}, -- [5]
					{
						["id"] = 187874,
						["type"] = "spell",
					}, -- [6]
					{
						["id"] = 193796,
						["type"] = "spell",
					}, -- [7]
					{
						["id"] = 201898,
						["type"] = "spell",
					}, -- [8]
					[13] = {
						["id"] = 192077,
						["type"] = "spell",
					},
					[14] = {
						["id"] = 108271,
						["type"] = "spell",
					},
					[39] = {
						["id"] = 2825,
						["type"] = "spell",
					},
					[15] = {
						["id"] = 58875,
						["type"] = "spell",
					},
					[16] = {
						["id"] = 51533,
						["type"] = "spell",
					},
					[17] = {
						["id"] = 57994,
						["type"] = "spell",
					},
					[18] = {
						["id"] = 196834,
						["type"] = "spell",
					},
					[36] = {
						["id"] = 188089,
						["type"] = "spell",
					},
					[38] = {
						["id"] = 51485,
						["type"] = "spell",
					},
					[40] = {
						["id"] = 51514,
						["type"] = "spell",
					},
					[37] = {
						["id"] = 192106,
						["type"] = "spell",
					},
					[12] = {
						["id"] = 197214,
						["type"] = "spell",
					},
					[19] = {
						["id"] = 20608,
						["type"] = "spell",
					},
				}, -- [2]
				{
					nil, -- [1]
					nil, -- [2]
					{
						["id"] = 61295,
						["type"] = "spell",
					}, -- [3]
					{
						["id"] = 73920,
						["type"] = "spell",
					}, -- [4]
					{
						["id"] = 5394,
						["type"] = "spell",
					}, -- [5]
					{
						["id"] = 108280,
						["type"] = "spell",
					}, -- [6]
					{
						["id"] = 98008,
						["type"] = "spell",
					}, -- [7]
					{
						["id"] = 73685,
						["type"] = "spell",
					}, -- [8]
					[13] = {
						["id"] = 108271,
						["type"] = "spell",
					},
					[35] = {
						["id"] = 157153,
						["type"] = "spell",
					},
					[14] = {
						["id"] = 188838,
						["type"] = "spell",
					},
					[39] = {
						["id"] = 2825,
						["type"] = "spell",
					},
					[15] = {
						["id"] = 51505,
						["type"] = "spell",
					},
					[16] = {
						["id"] = 57994,
						["type"] = "spell",
					},
					[17] = {
						["id"] = 77130,
						["type"] = "spell",
					},
					[18] = {
						["id"] = 79206,
						["type"] = "spell",
					},
					[19] = {
						["id"] = 20608,
						["type"] = "spell",
					},
					[38] = {
						["id"] = 192077,
						["type"] = "spell",
					},
					[40] = {
						["id"] = 51514,
						["type"] = "spell",
					},
					[37] = {
						["id"] = 192058,
						["type"] = "spell",
					},
					[12] = {
						["id"] = 197995,
						["type"] = "spell",
					},
					[36] = {
						["id"] = 108281,
						["type"] = "spell",
					},
				}, -- [3]
			},
		},
}

TotemTimers.ActiveProfile = TotemTimers_Profiles.default


local function copy(object) 
    if type(object) ~= "table" then
        return object
    else
        local newtable = {}
        for k,v in pairs(object) do
            newtable[k] = copy(v)
        end
        return newtable
    end
end




function TotemTimers.CreateProfile(name)
    if not TotemTimers_Profiles[name] then
        TotemTimers.ResetProfile(name)
        return true
    else
        return false
    end
end


function TotemTimers.DeleteProfile(name)
    if name == "default" then return end
    TotemTimers_Profiles[name] = nil
    for u,p in pairs(TotemTimers_GlobalSettings.Profiles) do
        for i = 1,3 do
            for _,v in pairs({"none","party","arena","pvp","raid"}) do
                if p[i][v] == name then
                    p[i][v] = "default"
                end
            end
        end
    end
end

function TotemTimers.ResetProfile(name)
    TotemTimers_Profiles[name] = copy(TotemTimers.DefaultProfile)
end

function TotemTimers.ResetAllProfiles()
    TotemTimers_Profiles = {
        ["default"] = {}
    }
    TotemTimers.ResetProfile("default")
end

function TotemTimers.SelectActiveProfile()
    local player = UnitName("player")
    local specialization = GetSpecialization()
    if not specialization then specialization = 2 end
    local _,instance = IsInInstance()
	if not instance then instance = "party" end
    TotemTimers.ActiveProfile = TotemTimers_Profiles[TotemTimers_GlobalSettings.Profiles[player][specialization][instance]] or TotemTimers_Profiles.default
	XiTimers.SetProfile(TotemTimers.ActiveProfile)
end


function TotemTimers.ExecuteProfile()
	TotemTimers.ProcessAllSettings()
	XiTimers.LoadProfile()    
    --TotemTimers.SetCastButtonSpells()
    --TotemTimers.ProgramSetButtons()
	--XiTimers.InitWarnings(TotemTimers.ActiveProfile.Warnings)
end

local SettingsConverters = {
}

	
function TotemTimers.UpdateProfiles()

    if not TotemTimers_Profiles then TotemTimers_Profiles = {default={}} end
    
	if not TotemTimers_GlobalSettings.Version or TotemTimers_GlobalSettings.Version < 12.01 then
		DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Pre-12.0-Beta1 or no saved settings found, loading defaults...")
        TotemTimers_GlobalSettings = {}
		TotemTimers.ResetAllProfiles()
	elseif TotemTimers_GlobalSettings.Version ~= Version then
        if not SettingsConverters[TotemTimers_GlobalSettings.Version] then
            DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Unknown settings found, loading defaults...")
            TotemTimers_GlobalSettings = {}
            TotemTimers.ResetAllProfiles()
        else
            while SettingsConverters[TotemTimers_GlobalSettings.Version] do
                SettingsConverters[TotemTimers_GlobalSettings.Version]()
            end
        end
    end

	for k,v in pairs(TotemTimers.DefaultProfile) do
        for _,profile in pairs(TotemTimers_Profiles) do
            if profile[k] == nil then
                profile[k] = copy(v)
            end
        end
	end
    
    for k,v in pairs(TotemTimers.DefaultGlobalSettings) do
        if TotemTimers_GlobalSettings[k] == nil then
            TotemTimers_GlobalSettings[k] = copy(v)
        end
    end
    
    local player = UnitName("player")
    if not TotemTimers_GlobalSettings.Profiles[player] then
        TotemTimers_GlobalSettings.Profiles[player] = {
            [1] = {none="default",pvp="default",arena="default",party="default",raid="default",scenario="default"},
            [2] = {none="default",pvp="default",arena="default",party="default",raid="default",scenario="default"},
            [3] = {none="default",pvp="default",arena="default",party="default",raid="default",scenario="default"},
        }
    end
	for i=1,3 do
		if not TotemTimers_GlobalSettings.Profiles[player][i].scenario then
			TotemTimers_GlobalSettings.Profiles[player][i].scenario = "default"
		end
	end
end

function TotemTimers.ResetProfilePositions(name)
    TotemTimers_Profiles[name].FramePositions = copy(TotemTimers.DefaultProfile.FramePositions)
    TotemTimers_Profiles[name].TimerPositions = copy(TotemTimers.DefaultProfile.TimerPositions)
    TotemTimers.ProcessSetting("FramePositions")
end

function TotemTimers.CopyProfile(p1,p2)
    TotemTimers_Profiles[p2] = copy(TotemTimers_Profiles[p1])
end

function TotemTimers.CopyFramePositions(p1, p2)
    TotemTimers_Profiles[p2].FramePositions = copy(TotemTimers_Profiles[p1].FramePositions)
    TotemTimers_Profiles[p2].TimerPositions = copy(TotemTimers_Profiles[p2].TimerPositions)
end


local GeneralList = {
    Lock, FlashRed, ShowTimerBars,
    HideBlizzTimers, Tooltips, TooltipsAtButtons,
    TimeFont, TimeColor, TimerBarTexture,
    TimerBarColor, ShowKeybinds, HideInVehicle,
    StopPulse, TimersOnButtons, LavaSurgeAura,
    LavaSurgeGlow, FulminationAura, FulminationGlow,
}

function TotemTimers.CopyGeneralSettings(p1,p2)
    for k,v in pairs(GeneralList) do
        TotemTimers_Profiles[p2][v] = copy(TotemTimers_Profiles[p1][v])
    end
end


local TotemSettings = {
    TotemOrder, HiddenTotems, TotemSets,
}




local WarningsList = {
    ActivateHiddenTimers, Warnings,
}

function TotemTimers.CopyWarnings(p1,p2)
    for k,v in pairs(WarningsList) do
        TotemTimers_Profiles[p2][v] = copy(TotemTimers_Profiles[p1][v])
    end
end
