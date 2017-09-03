-- Basic configuration. Eventually, I'll add slash commands with arguments.

local delay = 11; -- You can manually adjust the delay of the onset log-in message here.
local onEntryBark = true; -- If you don't want it to yell at you when you log in, set this to false.
local doWaypoints = true; -- If you don't want it to add waypoints to your map automatically, set this to false.

-- Fancy addon stuff below.

local waitTable = {};
local waitFrame = nil;

local prefix = " |TInterface\\Icons\\Artifactability_balancedruid_moonandstars:16|t |cAAA8EADAMoonspirit:|r";

-- Setting our slash commands.
SLASH_MOONSPIRIT1, SLASH_MOONSPIRIT2, SLASH_MOONSPIRIT3 = "/moonspirit", "/owlcat";
SlashCmdList["MOONSPIRIT"] = function(msg)
    Moonspirit_Status();
end

-- Adding in a delay to the player of their Moonspirit status, after all other entry messages have posted.
function Moonspirit_Wait(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false;
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable;
			local i = 1;
			while(i<=count) do
				local waitRecord = tremove(waitTable,i);
				local d = tremove(waitRecord,1);
				local f = tremove(waitRecord,1);
				local p = tremove(waitRecord,1);
				if(d>elapse) then
					tinsert(waitTable,i,{d-elapse,f,p});
					i = i + 1;
				else
					count = count - 1;
					f(unpack(p));
				end
			end
			end);
	end
	tinsert(waitTable,{delay,func,{...}});
	return true;
end

-- The meat. Showing a breakdown of where the player lies in the event chain.
function Moonspirit_Alert()

	local dailyDreamway = IsQuestFlaggedCompleted(44326);
	local feralasOpen = IsQuestFlaggedCompleted(44327);
	local feralasDone = IsQuestFlaggedCompleted(44331);
	local hinterlandsOpen = IsQuestFlaggedCompleted(44328);
	local hinterlandsDone = IsQuestFlaggedCompleted(44332);
	local duskwoodOpen = IsQuestFlaggedCompleted(44329);
	local duskwoodDone = IsQuestFlaggedCompleted(44330);

	local allDone = feralasDone and hinterlandsDone and duskwoodDone;
	local canAlert = (feralasOpen and not feralasDone) or (hinterlandsOpen and not hinterlandsDone) or (duskwoodOpen and not duskwoodDone);

	if (not allDone and dailyDreamway == true and canAlert == true) then
		print(prefix, "|cFFFFFF00The Dreamway daily event is |cFF00FF00has been triggered|cFFFFFF00!");
		
		if (feralasOpen == true and feralasDone == false) then
			print(" - |cFFFFFF00Feralas is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		end
		
		if (hinterlandsOpen == true and hinterlandsDone == false) then
			print(" - |cFFFFFF00The Hinterlands is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		end

		if (duskwoodOpen == true and duskwoodDone == false) then
			print(" - |cFFFFFF00Duskwood is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		end
	end
end

-- The meat. Showing a breakdown of where the player lies in the event chain.
function Moonspirit_Status()

	local dailyDreamway = IsQuestFlaggedCompleted(44326);
	local feralasOpen = IsQuestFlaggedCompleted(44327);
	local feralasDone = IsQuestFlaggedCompleted(44331);
	local hinterlandsOpen = IsQuestFlaggedCompleted(44328);
	local hinterlandsDone = IsQuestFlaggedCompleted(44332);
	local duskwoodOpen = IsQuestFlaggedCompleted(44329);
	local duskwoodDone = IsQuestFlaggedCompleted(44330);

	-- TODO: Need a better way of detecting this, for sure.
	local probablyOwlcat = feralasDone == true and hinterlandsDone == true and duskwoodDone == true;

	if (probablyOwlcat == true) then

		Moonspirit_Variations();

	else

		if (dailyDreamway == true) then
			print(prefix, "|cFFFFFF00The Dreamway daily event is |cFF00FF00has been triggered|cFFFFFF00! Here's your breakdown:");
		else
			print(prefix, "|cFFFFFF00The Dreamway daily event is |cFFFF0000has not been triggered|cFFFFFF00 today. Here's where you stand:");
		end
			
		if (feralasDone == true) then
			print(" - |cFFFFFF00Feralas is |cFF00FF00complete|cFFFFFF00!")
		elseif (feralasOpen == true and feralasDone == false) then
			print(" - |cFFFFFF00Feralas is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		elseif (feralasOpen == false and feralasDone == false) then
			print(" - |cFFFFFF00Feralas is |cFFFF0000inactive|cFFFFFF00 today.");
		end

		if (hinterlandsDone == true) then
			print(" - |cFFFFFF00The Hinterlands is |cFF00FF00complete|cFFFFFF00!");
		elseif (hinterlandsOpen == true and hinterlandsDone == false) then
			print(" - |cFFFFFF00The Hinterlands is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		elseif (hinterlandsOpen == false and hinterlandsDone == false) then
			print(" - |cFFFFFF00The Hinterlands is |cFFFF0000inactive|cFFFFFF00 today.");
		end

		if (duskwoodDone == true) then
			print(" - |cFFFFFF00Duskwood is |cFF00FF00complete|cFFFFFF00!");
		elseif (duskwoodOpen == true and duskwoodDone == false) then
			print(" - |cFFFFFF00Duskwood is |cFF00FF00active|cFFFFFF00, but |cFFFF0000untouched|cFFFFFF00.");
		elseif (duskwoodOpen == false and duskwoodDone == false) then
			print(" - |cFFFFFF00Duskwood is |cFFFF0000inactive|cFFFFFF00 today.");
		end
	
	end
end

function Moonspirit_Zoning()
	if (IsAddOnLoaded("TomTom") and doWaypoints == true) then
	
		local feralasOpen = IsQuestFlaggedCompleted(44327);
		local feralasDone = IsQuestFlaggedCompleted(44331);
		local hinterlandsOpen = IsQuestFlaggedCompleted(44328);
		local hinterlandsDone = IsQuestFlaggedCompleted(44332);
		local duskwoodOpen = IsQuestFlaggedCompleted(44329);
		local duskwoodDone = IsQuestFlaggedCompleted(44330);


		-- Getting zone ID since it's more reliable than text. People do play in different languages other than English!
		-- Feralas: 121
		-- Duskwood: 34
		-- The Hinterlands: 26

  		local zone = GetCurrentMapAreaID();

  		if (zone == 121 and feralasOpen == true and feralasDone == false) then
  			Moonspirit_Feralas();
  		end

		if (zone == 34 and duskwoodOpen == true and duskwoodDone == false) then
			Moonspirit_Duskwood();
  		end

  		if (zone == 26 and hinterlandsOpen == true and hinterlandsDone == false) then
			Moonspirit_Hinterlands();
  		end
	end
end

function Moonspirit_Feralas()
	print(prefix, "|cFFFFFF00Looks like you're in Feralas. The Moonspirit event is |cFF00FF00active|cFFFFFF00 here, but your Owlstone is |cFFFF0000untouched|cFFFFFF00. Waypoints to the most likely spots have been added to your map!");
	TomTom:AddWaypointToCurrentZone(49.5, 4.4, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(48, 6, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(54, 6, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(51, 11, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(52, 6, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(50, 15, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(52, 15, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(52, 10, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(51, 8, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(53, 14, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(51, 10, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(53.81, 14.93, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(54.34, 10.30, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(54, 15, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(48, 10, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(50, 11, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(51, 15, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(51.51, 5.38, "Feralas Owlstone");
	TomTom:AddWaypointToCurrentZone(54.04, 7.85, "Feralas Owlstone");
end

function Moonspirit_Hinterlands()
	print(prefix, "|cFFFFFF00Looks like you're in the Hinterlands. The Moonspirit event is |cFF00FF00active|cFFFFFF00 here, but your Owlstone is |cFFFF0000untouched|cFFFFFF00. Waypoints to the most likely spots have been added to your map!");
	TomTom:AddWaypointToCurrentZone(64, 24, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(68, 36, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(60, 33, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(60, 29, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(58, 32, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(60, 28, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(68, 24, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(67, 31, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(66, 37.4, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(57, 34, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(59.6, 25.5, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(58.11, 18.05, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(66, 38, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(66, 20, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(68.9, 32.4, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(66.9, 20.5, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(58.3, 29.1, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(63, 31, "Hinterlands Owlstone");
	TomTom:AddWaypointToCurrentZone(64, 32, "Hinterlands Owlstone");
end

function Moonspirit_Duskwood()
	print(prefix, "|cFFFFFF00Looks like you're in Duskwood. The Moonspirit event is |cFF00FF00active|cFFFFFF00 here, but your Owlstone is |cFFFF0000untouched|cFFFFFF00. Waypoints to the most likely spots have been added to your map!");
	TomTom:AddWaypointToCurrentZone(45, 45, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(43, 38, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(42, 38, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(45, 36, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(48, 44, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(44, 35, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(48.93, 38.75, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(48, 31, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(47, 35, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(50.85, 45.06, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(50.71, 44.90, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(48.63, 31.74, "Duskwood Owlstone");
	TomTom:AddWaypointToCurrentZone(46, 36.56, "Duskwood Owlstone");
end

function Moonspirit_Variations()

	print(prefix, "|cFFFFFF00Hello, fellow catbird! Here is the breakdown for achieving your hidden artifact color variations:");

	local q,x,_,a,b = GetAchievementCriteriaInfo,0 

	for i=1,11 do 
		_,_,_,a,b = q(11152,i) x=x+a 
	end 

	local _,_,_,c,d = q(11153,1); 
	local _,_,_,e,f = q(11154,1);

	local dungeonsComplete = x == b;
	local questsComplete = c == d;
	local killsComplete = e == f;

	if (dungeonsComplete == true) then
		print(" - |cFFFFFF00Dungeons: |cFF00FF00"..x.."|cFFFFFF00 of |cFF00FF00"..b.."|cFFFFFF00: |cFF00FF00complete!");
	else
		print(" - |cFFFFFF00Dungeons: |cFFFF0000"..x.."|cFFFFFF00 of |cFF00FF00"..b);
	end

	if (questsComplete == true) then
		print(" - |cFFFFFF00World Quests: |cFF00FF00"..c.."|cFFFFFF00 of |cFF00FF00"..d.."|cFFFFFF00: |cFF00FF00complete!");
	else
		print(" - |cFFFFFF00World Quests: |cFFFF0000"..c.."|cFFFFFF00 of |cFF00FF00"..d);
	end

	if (killsComplete == true) then
		print(" - |cFFFFFF00Player Kills: |cFF00FF00"..e.."|cFFFFFF00 of |cFF00FF00"..f.."|cFFFFFF00: |cFF00FF00complete!");
	else
		print(" - |cFFFFFF00Player Kills: |cFFFF0000"..e.."|cFFFFFF00 of |cFF00FF00"..f);
	end

end

-- Event detection

local frame, events = CreateFrame("Frame"), {};
function events:ZONE_CHANGED_NEW_AREA(...)
	Moonspirit_Wait(4, Moonspirit_Zoning);
end

-- Disabled since the event fires twice on zoning from the Dreamway to new continents.
--function events:PLAYER_ENTERING_WORLD(...)
--	print("entering world");
--	Moonspirit_Wait(3, Moonspirit_Zoning);
--end


frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end

-- Detecting when the player enters a Moonspirit zone, or logs in..

if (onEntryBark == true) then
	Moonspirit_Wait(delay, Moonspirit_Alert);
end