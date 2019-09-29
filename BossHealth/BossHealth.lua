local frame = CreateFrame("Frame",  nil, UIParent);
local startTime = {}
local stopTime = {}
local updateTime = {}
local bossHealth = {}
local bossMaxHealth = {}
local bossName = {}
local bossLine = {}
local bossList = {}
local barCount = 9
local statusBars = {}
local percentStrings = {}
local timeStrings = {}
local nameStrings = {}
local playerFlagMask = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_PLAYER)

--BossHealth_debug = 1

function BossHealth_IsBoss(guid)
   local mobid = string.match(guid, "Creature%-0%-%d*%-%d*%-%d*%-(%d*)%-")
   
   if not mobid then return nil; end
   if BossHealth_debug then 
	  print("boss:", tonumber(mobid), BossHealth_IDs[tonumber(mobid)]);
   end
   return BossHealth_IDs[tonumber(mobid)]
end

function BossHealth_EnterCombat(guid, name)
   local localTime = GetTime()
   startTime[guid]  = localTime
   stopTime[guid] = localTime
   updateTime[guid] = localTime + 1.0
   bossName[guid]   = name
   bossList[#bossList+1] = guid
   if BossHealth_debug then print("enter boss combat: ", name); end

   bossLine = {}
   for bar = 1, min(#bossList, #statusBars) do
      local boss = #bossList-bar+1
      local guid=bossList[boss]
      nameStrings[bar]:SetText(bossName[guid])
      bossLine[guid] = bar
      BossHealth_UpdateUnit(nil, guid)
   end
end

function BossHealth_UpdateUnit(unit, guid)
   if unit then
      local max = UnitHealthMax(unit)
      if (max > 0) then
        bossMaxHealth[guid] = max
        bossHealth[guid]    = UnitHealth(unit)
      end
      updateTime[guid]    = GetTime() + 1
   end

   local bar = bossLine[guid]
   if bar then
      if startTime[guid] then
         local minutes = math.floor((stopTime[guid] - startTime[guid]) / 60)
         local seconds = math.floor(stopTime[guid] - startTime[guid]) % 60
         timeStrings[bar]:SetText(string.format("%d:%02d", minutes, seconds))
      else
         timeStrings[bar]:SetText("")
      end
      if bossMaxHealth[guid] and (bossMaxHealth[guid] > 0) then
         local percent = 100 * bossHealth[guid] / bossMaxHealth[guid]
         percentStrings[bar]:SetText(math.ceil(percent).."%")
         statusBars[bar]:SetValue(percent)
      else
         percentStrings[bar]:SetText("")
         statusBars[bar]:SetValue(0)
      end
   end
end

function BossHealth_SearchUnit(guid)
   local i, unit
   for i = 1,4 do
      unit = "boss" .. i
      if UnitGUID(unit) == guid then
         BossHealth_UpdateUnit(unit, guid)
         return
      end
   end

   local raid = GetNumGroupMembers()
   if (raid > 0) then
      for i = 1, raid do
         unit = "raid" .. i .. "target"
         if UnitGUID(unit) == guid then
            BossHealth_UpdateUnit(unit, guid)
            return
         end
      end
      for i = 1, raid do
         unit = "raidpet" .. i .. "target"
         if UnitGUID(unit) == guid then
            BossHealth_UpdateUnit(unit, guid)
            return
         end
      end
   else
      for i = 1, 4 do
         unit = "party" .. i .. "target"
         if UnitGUID(unit) == guid then
            BossHealth_UpdateUnit(unit, guid)
            return
         end
      end
      for i = 1, 4 do
         unit = "partypet" .. i .. "target"
         if UnitGUID(unit) == guid then
            BossHealth_UpdateUnit(unit, guid)
            return
         end
      end
   end
   BossHealth_UpdateUnit(nil, guid)
end

function frame:OnEvent(event, ...)
   if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
      local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
                                          destGUID,   destName,   destFlags,   destRaidFlags
                                          
      if CombatLogGetCurrentEventInfo then
         timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
                                       destGUID,   destName,   destFlags,   destRaidFlags    = CombatLogGetCurrentEventInfo()
      else 
         timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
                                       destGUID,   destName,   destFlags,   destRaidFlags    = ...
      end
      
      if string.find(event, "_AURA_") or string.find(event, "_PERIODIC_") or 
            string.find(event, "_CAST_") or (event == "SPELL_MISSED") then
         return
      end
      
      if (not stopTime[sourceGUID]) and (BossHealth_IsBoss(sourceGUID)) and 
            (bit.band(destFlags, playerFlagMask) > 0) then
         BossHealth_EnterCombat(sourceGUID, sourceName)
         if BossHealth_debug then print(sourceName, " ", event, " ", destName, " dst:", destFlags) end
      elseif (not stopTime[destGUID]) and (BossHealth_IsBoss(destGUID)) and 
            (bit.band(sourceFlags, playerFlagMask) > 0) then
         BossHealth_EnterCombat(destGUID, destName)
         if BossHealth_debug then print(sourceName, " ", event, " ", destName, " src:", sourceFlags) end
      end
      
      for _,guid in pairs({sourceGUID, destGUID}) do
         if stopTime[guid] then
            if BossHealth_debug and (bossHealth[guid] == 0) then
               print(event, " ", sourceName, " ", sourceFlags, " ", destName, " ", destFlags)
            end
         
            local localTime = GetTime()
            stopTime[guid] = localTime
            if (localTime > updateTime[guid]) then
               updateTime[guid] = localTime + 0.5
               BossHealth_SearchUnit(guid)
            end
         end
      end
      if ((event == "UNIT_DIED") or (event == "UNIT_DESTROYED")) and stopTime[destGUID] then
         if BossHealth_debug then print(event, " ", destGUID) end
         bossHealth[destGUID] = 0
         BossHealth_UpdateUnit(nil, destGUID)
      end
   elseif (event == "UNIT_COMBAT") or (event == "UNIT_HEALTH") or (event == "UNIT_MAXHEALTH") then
      local unit = ...
      if unit then
          local guid = UnitGUID(unit)
          
          if (not stopTime[guid]) and (unit:sub(1,4) == "boss") then
             BossHealth_EnterCombat(guid, UnitName(unit))
             if BossHealth_debug then print(UnitName(unit), " ", event) end
          end
          
          if stopTime[guid] then
             stopTime[guid] = GetTime()
             BossHealth_UpdateUnit(unit, guid)
          end
        end
   elseif (event == "PLAYER_LOGOUT") then
      local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
      BossHealth_FramePos = {}
      BossHealth_FramePos.pt = point
      BossHealth_FramePos.rel = relativePoint
      BossHealth_FramePos.x = xOfs
      BossHealth_FramePos.y = yOfs
   elseif (event == "ADDON_LOADED") then
      local addon = ...
      if (addon == "BossHealth") then
         if BossHealth_FramePos then
            frame:ClearAllPoints()
            frame:SetPoint(BossHealth_FramePos.pt, nil, BossHealth_FramePos.rel, 
                           BossHealth_FramePos.x, BossHealth_FramePos.y)
         else
            frame:SetPoint("CENTER")
         end
      end
   end
end

frame:SetBackdrop( { 
   bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
   edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
   tile = true, tileSize = 0, edgeSize = 8, 
   insets = { left = 2, right = 2, top = 2, bottom = 2 }
});
frame:SetBackdropColor(0, 0, 0, 0.5)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetWidth(190)
frame:SetHeight(barCount * (10+1) + 6)
frame:Show()

local testString = frame:CreateFontString()
testString:SetFont("Fonts\\FRIZQT__.TTF", 10)
testString:SetText("100%")
local percentWidth = testString:GetStringWidth()+2
testString:SetText("88:88")
local timeWidth = testString:GetStringWidth()+1

for i = 1, barCount do
   local status = CreateFrame("STATUSBAR", nil, frame)
   status:SetMinMaxValues(0, 100)
   status:SetValue(0)
   status:SetPoint("RIGHT", -3, 0)
   status:SetPoint("LEFT", 3, 0)
   status:SetHeight(10)
   status:SetOrientation("HORIZONTAL")
   status:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BACKGROUND")
   status:SetStatusBarColor(0,1,0,1.0)

   local percent = status:CreateFontString()
   percent:SetFont("Fonts\\FRIZQT__.TTF", 10)
   percent:SetJustifyH("RIGHT")
   percent:SetWidth(percentWidth)
   percent:SetPoint("RIGHT", -1, 0)

   local elapsed = status:CreateFontString()
   elapsed:SetFont("Fonts\\FRIZQT__.TTF", 10)
   elapsed:SetJustifyH("RIGHT")
   elapsed:SetWidth(timeWidth)
   elapsed:SetPoint("RIGHT", percent, "LEFT", 0, 0)

   local name = status:CreateFontString()
   name:SetFont("Fonts\\FRIZQT__.TTF", 10)
   name:SetJustifyH("LEFT")
   name:SetPoint("RIGHT", elapsed, "LEFT")
   name:SetPoint("LEFT", 1, 0)
   name:SetNonSpaceWrap(false)
   name:SetWordWrap(false)

   statusBars[i] = status
   percentStrings[i] = percent
   timeStrings[i] = elapsed
   nameStrings[i] = name
end
statusBars[1]:SetPoint("TOP", 0, -3)
for i = 2, barCount do
   statusBars[i]:SetPoint("TOP", statusBars[i-1], "BOTTOM", 0, -1)
end
nameStrings[1]:SetText("Boss Health")
statusBars[1]:SetValue(0)

frame:RegisterEvent("UNIT_COMBAT");
frame:RegisterEvent("UNIT_HEALTH");
frame:RegisterEvent("UNIT_MAXHEALTH");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", frame.OnEvent)
