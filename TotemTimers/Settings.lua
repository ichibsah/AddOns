-- Copyright © 2008 - 2012 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowinterface.com and their respective addon updaters

if select(2,UnitClass("player")) ~= "SHAMAN" then return end

local Timers = XiTimers.timers

local SpellIDs = TotemTimers.SpellIDs
local SpellNames = TotemTimers.SpellNames
local AvailableSpells = TotemTimers.AvailableSpells

local TotemFrameScript = TotemFrame:GetScript("OnShow")

local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)

local TotemColors = {
    [AIR_TOTEM_SLOT] = {0.7,0.7,1.0},
    [WATER_TOTEM_SLOT] = {0.4,0.4,1.0},
    [FIRE_TOTEM_SLOT] = {1.0,0.1,0.1},
    [EARTH_TOTEM_SLOT] = {0.7,0.5,0.3},
}

local SettingsFunctions

function TotemTimers.ProcessSetting(setting)
    if SettingsFunctions[setting] then
        SettingsFunctions[setting](TotemTimers.ActiveProfile[setting], XiTimers.timers)
    end
end


function TotemTimers.ProcessAllSettings()
    for k,v in pairs(TotemTimers.ActiveProfile) do
        TotemTimers.ProcessSetting(k)
    end
end


SettingsFunctions = {

    ShowTimerBars = 
        function(value, Timers) 
            for _,timer in pairs(Timers) do
				if timer.nr ~= fsnr then
					timer.visibleTimerBars = value
					if timer.timer>0 and value and not timer.timerOnButton then
						timer:ShowTimerBar()
					else
						timer.timerBar.background:Hide()
						timer.timerBar:SetValue(0)			
					end
				end
            end
			if TotemTimers.FlameshockBar then
				TotemTimers.FlameshockBar.visibleTimerBars = true
				TotemTimers.FlameshockBar:ShowTimerBar()
			end
        end,
		

    FlashRed = 
        function(value, Timers)
        	for _,timer in pairs(Timers) do
                timer.flashRed = value
            end
        end,
        
    TimerSize = 
        function(value, Timers)
            local v = value
    		for e=1,#Timers do
    			Timers[e]:SetScale(v/36)
    		end
			TotemTimers.FlameshockBar:SetScale(1)
        end,
        
    TimerTimeHeight =
        function(value, Timers)
			local fsnr = TotemTimers.FlameshockBar.nr
    		for e=1,#Timers do
				if fsnr ~= Timers[e].nr then
					Timers[e]:SetTimeHeight(value)
					Timers[e].button.time:SetFont(Timers[e].button.time:GetFont(),value+5,"OUTLINE")
				end
    		end  
			
        end,
        
       
    TimerSpacing = 
        function(value, Timers)
    		for e=1,#Timers do
    			Timers[e]:SetSpacing(value)
    		end
        end,
        
        
    TimerTimeSpacing = 
        function(value, Timers)
    		for e=1,#Timers do
				Timers[e]:SetTimeSpacing(value)
    		end
        end,
        
    TimerTimePos = 
        function(value, Timers)
    		for e=1,#Timers do
				Timers[e]:SetTimerBarPos(value)
    		end  
        end,
       
       
     
    HideBlizzTimers = 
        function(value)
            if value then
                TotemFrame:UnregisterEvent("PLAYER_TOTEM_UPDATE")
                TotemFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
                TotemFrame:SetScript("OnShow", function() TotemFrame:Hide() end)
                TotemFrame:Hide()
            else
                TotemFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
                TotemFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                TotemFrame:Show()
                TotemFrame:SetScript("OnShow", TotemFrameScript)
            end
        end,
            
   
   --[[ OpenOnRightclick =
        function(value, Timers)
            for i = 1,4 do
                if value and not TotemTimers.ActiveProfile.MenusAlwaysVisible then 
                    Timers[i].button:SetAttribute("OpenMenu", "RightButton")
                    --Timers[i].button:SetAttribute("*macrotext3", "/script XiTimers.timers["..i.."].stopQuiet = true DestroyTotem("..Timers[i].nr..")")
					Timers[i].button:SetAttribute("*macrotext3", "/cast Totemic Recall")
                    Timers[i].button:SetAttribute("*macrotext2", "")
                else
                    Timers[i].button:SetAttribute("OpenMenu", "mouseover")
                    Timers[i].button:SetAttribute("*macrotext3", "/cast Totemic Recall")
					Timers[i].button:SetAttribute("*macrotext2", "/cast Totemic Recall")
                    --Timers[i].button:SetAttribute("*macrotext2", "/script XiTimers.timers["..i.."].stopQuiet = true DestroyTotem("..Timers[i].nr..")")
                end
            end
        end,]]
    
    --[[MenusAlwaysVisible =
        function(value, Timers)
            if value then
                for i=1,4 do
                    Timers[i].button:SetAttribute("OpenMenu", "always")
                end
            end
            for i=1,4 do
                TTActionBars.bars[i]:SetAlwaysVisible(value)
            end
        end,]]
		
	ActionBarButtonPosition =
		function(value, Timers)
			for i=1,#XiTimers.actionBars do
				XiTimers.actionBars[i].position = value[i]
			end
		end,

        
    Lock =
        function(value, Timers)
            for k,v in pairs(Timers) do
                v.locked = value
            end
        end,
        
    
    ProcFlash =
        function(value, Timers)
            for i=1,#Timers do
                Timers[i].procFlash = value
            end
        end,
     
    TimeFont =
        function(value, Timers)
            local font = LSM:Fetch("font", value)
            if font then
                for _,timer in pairs(Timers) do
                    timer:SetFont(font)
                end
            end
        end,
        
    TimerBarTexture =
        function(value, Timers) 
            local texture = LSM:Fetch("statusbar", value)
            if texture then
                for _,timer in pairs(Timers) do
                    timer:SetBarTexture(texture)
                end
            end
        end,
        
       
    --[[ BarBindings =
        function(value, Timers)
            for i=1,4 do
                for j=1,5 do
                    local key = GetBindingKey("TOTEMTIMERSCAST"..i..j)
                    if TotemTimers.ActiveProfile.BarBindings and not TotemTimers.ActiveProfile.MenusAlwaysVisible then
                        if TotemTimers.ActiveProfile.ReverseBarBindings then
                            getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or tostring(10-j))
                            getglobal("TT_ActionButton"..i..j):SetAttribute("binding", tostring(10-j))
                        else
                            getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or tostring(j))
                            getglobal("TT_ActionButton"..i..j):SetAttribute("binding", tostring(j))
                        end
                    else
                        getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or "")
                        getglobal("TT_ActionButton"..i..j):SetAttribute("binding", nil)
                    end
                end
            end
        end, ]]--
 
        
    --[[ EnhanceCDsMaelstromHeight = 
        function(value, Timers)
			return
            TotemTimers.maelstrom:SetHeight(value)
            TotemTimers.maelstrom.background:SetHeight(value)
            TotemTimers.maelstrombutton:SetHeight(value)
            TotemTimers.maelstrom.icon:SetWidth(value)
            TotemTimers.maelstrom.icon:SetHeight(value)
            Timers[21]:SetScale(value/36)
            Timers[21]:SetTimeHeight(value)
            Timers[21].timerBars[1]:SetScale(36/value)
            local font = TotemTimers.maelstrom.text:GetFont()
            local outline
            if Timers[9].timerOnButton then outline = "OUTLINE" end
    		TotemTimers.maelstrom.text:SetFont(font, value, outline)
            local font, value = _G["XiTimers_TimerBar17_1Time"]:GetFont()
            _G["XiTimers_TimerBar17_1Time"]:SetFont(font, value, outline)
            TotemTimers.LayoutEnhanceCDs()
        end, ]]--
        
    Tooltips =  
        function(value, Timers)
            for i=1,#Timers do
				if value then
					Timers[i].button:SetAttribute("_onenter", [[ control:CallMethod("ShowTooltip")]])
					Timers[i].button:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip")]])
				else
					Timers[i].button.SetAttribute("_onenter", nil)
					Timers[i].button.SetAttribute("_onleave", nil)
				end
            end
        end,
		
	TooltipsAtButtons = 
		function(value, Timers)
			XiTimers.TooltipsAtButtons = value
		end,
        
    TotemTimerBarWidth =
        function(value, Timers)
            for i=1,#Timers do
                Timers[i].timerBar:SetWidth(value)
            end
			if TotemTimers.FlameshockBar then
				TotemTimers.FlameshockBar.timerBar:SetWidth(100)
			end
        end,
        
        
    ActivateHiddenTimers =
        function(value, Timers)
            TotemTimers.ProcessSetting("ShieldTracker")
            TotemTimers.ProcessSetting("EarthShieldTracker")
        end,
        
    ShowKeybinds =
        function(value, Timers)
            for _,t in pairs(Timers) do
                if value then
                    t.button.hotkey:Show()
                else
                    t.button.hotkey:Hide()
                end
            end
        end,
        
    FramePositions = 
        function(value, Timers)
            for name, pos in pairs(value) do
                if _G[name] and pos and pos[1] then
                    _G[name]:ClearAllPoints()
                    _G[name]:SetPoint(pos[1],pos[2],pos[3],pos[4],pos[5])
                end
            end
        end,
        
    --[[ ESMainTankMenuDirection =
        function(value, Timers) 
            TTActionBars.bars[5]:SetDirection(value, TotemTimers.ActiveProfile.TrackerArrange)
            --if #TTActionBars.bars > 5 then TotemTimers.ProcessSetting("MultiSpellBarDirection") end
        end,  ]] 
        
    --[[EnhanceCDsOOCAlpha = 
        function(value, Timers)
            for i = 1,#Timers do
                Timers[i].OOCAlpha = value
            end
            --TotemTimers.maelstrom:SetAlpha(value)
            XiTimers.invokeOOCFader()
        end,]]
        
    TimersOnButtons = 
        function(value, Timers)
            for i=1,#Timers do
                Timers[i].timerOnButton = value
                if Timers[i].timer > 0 then Timers[i]:Start(Timers[i].timer, Timers[i].duration) end
            end
			TotemTimers.FlameshockBar.timerOnButton = false
			if TotemTimers.FlameshockBar.timer > 0 then TotemTimers.FlameshockBar:Start(TotemTimers.FlameshockBar.timer, TotemTimers.FlameshockBar.duration) end
        end,
    
    TimeColor = 
        function(value, Timers)
            for i=1,#Timers do
                Timers[i].button.time:SetTextColor(value.r, value.g, value.b, 1)
                Timers[1].timeColor = value
                for j=1,#Timers[i].timerBars do
                    Timers[i].timerBars[j].time:SetTextColor(value.r,value.g,value.b,1)
                end
            end
        end,
        
   
    HideInVehicle = 
        function(value, Timers)
            if value then
                for k,v in pairs(Timers) do
                    RegisterStateDriver(v.button,"invehicle","[bonusbar:5]hide;show")
                end
                --RegisterStateDriver(TotemTimers.MB,"invehicle","[bonusbar:5]hide;show")
            else
                for k,v in pairs(Timers) do
                    UnregisterStateDriver(v.button,"invehicle")
                end
                --UnregisterStateDriver(TotemTimers.MB,"invehicle")
            end
        end,
   
    StopPulse =
        function(value, Timers)
            for i = 1,#Timers do
                Timers[i].StopPulse = value
            end
        end,
        
   --[[ HideEnhanceCDsOOC =
        function(value)
			local Timers = TotemTimers.EnhanceCDs
            for i = 1,#Timers do
                Timers[i].HideOOC = value
				Timers[i].button:SetAttribute("HideOOC", value)
            end
            TotemTimers.ConfigEnhanceCDs()
        end,]]
        
        
    --[[EarthShieldTargetName =
        function(value, Timers)
            if value then
                Timers[7].nameframe:Show()
            else
                Timers[7].nameframe:Hide()
            end
        end,]]
        
        
    Clickthrough = 
        function(value, Timers)
            for i = 1,#Timers do
                --Timers[i].button:EnableMouse(not value)
				Timers[i]:Clickthrough(value)
            end
        end,
		
	MaelstromBar = 
		function(value, Timers)
			if GetSpecialization() < 3 then
				if value then
					XiTimers.PowerBar.powerName = "MAELSTROM"
					XiTimers.PowerBar.powerIndex = SPELL_POWER_MAELSTROM
					XiTimers.PowerBar:enable()
				else
					XiTimers.PowerBar:disable()
				end
			end
		end,
		
	ManaBar = 
		function(value, Timers)
			if GetSpecialization() == 3 then
				if value then
					XiTimers.PowerBar.powerName = "MANA"
					XiTimers.PowerBar.powerIndex = SPELL_POWER_MANA
					XiTimers.PowerBar:enable()
				else
					XiTimers.PowerBar:disable()
				end
			end
		end,
        
    FlameshockBar =
		function(value, Timers)
			if not TotemTimers.FlameshockBar then return end
			local role = GetSpecialization()
			if value and (role == 1) then
				TotemTimers.FlameshockBar:Activate()
			elseif role == 2 or not value then
				TotemTimers.FlameshockBar:Deactivate()
			end
		end,
		
	FlameshockBarRestoration =
		function(value, Timers)
			if not TotemTimers.FlameshockBar then return end
			if GetSpecialization() < 3 then return end
			if value then
				TotemTimers.FlameshockBar:Activate()
			else
				TotemTimers.FlameshockBar:Deactivate()
			end
		end,
        
       
}

SettingsFunctions.ReverseBarBindings = SettingsFunctions.BarBindings


