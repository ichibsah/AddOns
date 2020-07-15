-- Author      : Linty


 ------Code
if not LibStub then return end

local LDB = LibStub("LibDataBroker-1.1")
local tip = LibStub('LibQTip-1.0')



LFGShout_Global={
			Version=0.1,
			Debug=0,
			WhisperMessage="",
			FilterLevel=45,
			ChatShout=true,
			ShowTrade=true,
			ShowGuild=true,
			ShowLFG=true,
			ShowAlert=true,
			CustomWhiteList="",
			CustomBlackList="",
			CustomAchs={},
			ForwardMessages=true,
			MyAdverts={},
			}; --Global Storage Var

--LFGShout_Global.Debug=4 ---Debug everything
			
LFGShout_frame = CreateFrame("Frame");

LFGShout={unittest={},lang={}, utils={}, event={},vars={}, config={}, Dialogs={}, Stats={checked=0, rejected=0, forwarded=0, fromforward=0, added=0, started=time()},
		broker=LibStub("AceAddon-3.0"):NewAddon("Broker_LFGShout", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0"),
		timer = LibStub("AceAddon-3.0"):NewAddon("LFGShout_broadcast", "AceTimer-3.0"),

		OpenedAt=0, NewMessages=0,
		};

LFGShout.vars.WhisperTarget="";
LFGShout.vars.adverts={};
LFGShout.vars.whitelist={};
LFGShout.vars.blacklist={};
LFGShout.vars.StdFilterCount=0;
LFGShout.vars.Channel=-1;
LFGShout.vars.broadcastFreq=10;
LFGShout.BroadcastQ={};
LFGShout.BroadcastCache={};
LFGShout.vars.lastsentadvert=0;


LFGShout_frame:SetScript("OnEvent", function(self,event, ...)
		LFGShout.EventManager(self,event,...); -- call event handler
			end);
			

 LFGShout_frame:RegisterEvent("VARIABLES_LOADED");
 LFGShout_frame:RegisterEvent("ADDON_LOADED");
 LFGShout_frame:RegisterEvent("CHAT_MSG_CHANNEL");




------------------------Unit Tests-----------------------------

function LFGShout.unittest:run()
	LFGShout.unittest:ChatAdvert();
end

function LFGShout.unittest:ChatAdvert()
	LFGShout.utils:SetDebug(6);
	
--	LFGShout.utils:AdvertAdd("LFGS Addon Unit Test","LintyDruid#","99. LFG Unit Test");

--	LFGShout.utils:AdvertAdd("WTS - LFGS Addon Debug Test","LintyDruid#","99. LFG Unit Test");
--	LFGShout.utils:AdvertAdd("GALLEON - LFGS Addon Debug Test","LintyDruid#","99. LFG Unit Test");
--	LFGShout.utils:AdvertAdd("VC - LFGS Addon Debug Test","LintyDruid#","99. LFG Unit Test");
	LFGShout.utils:AdvertAdd("lfg hhov - LFGS Addon Debug Test","LintyDruid#","99. LFG Unit Test");


--	LFGShout.utils:AdvertAdd("LFGS - Unit Test Ends","LintyDruid#","99. LFG Unit Test");
	LFGShout.utils:SetDebug(0);
end

------------------------Send Mesage to chat---------------------


function LFGShout.utils:Chat(chatmsg)

	if (chatmsg==nil) then 
		chatmsg="";
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFF000LFG Shout : |r"..chatmsg);
end

------------------------Send Debug to chat---------------------
function LFGShout.utils:Debug(level, debugStr) --- level == 0-Critical, 1- Important, 2-Information, 3-trace only
		
		if (debugStr==nil or level == nil) then 
			return;
		end
		if   LFGShout_Global.Debug==0 then 
				return;
		end
		
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFFF000LFG Shout : |cffff0000[Debug] |r"..debugStr);
end

------------------------Set Debug Level---------------------
function LFGShout.utils:SetDebug(level)
	LFGShout_Global.Debug=level;
end

---------------------------------Helper Funcitons---------------------------------
function LFGShout.utils:SafeNil(StringVar)
		if (StringVar== nil) then
			return "";
		end

		return StringVar;
end 

function LFGShout.utils:TimeString(secs)

	if (secs==nil) then
		return "-";
	end
	
	if (secs<60) then
		return secs..LFGShout.lang.Seconds;
	end
		
	
	
	local mins=math.floor(secs/60);
	local hours=0;
	local days=0;

	hours,mins=math.modf(mins/60);
	mins=math.floor(mins*60);

	days,hours=math.modf(hours/24);

	hours=math.floor(hours*24);

	sret=""
	if (days>0) then
		sret=days..LFGShout.lang.Days.." ";
	end

	if (hours>0 or days>0) then
		sret=sret..hours..LFGShout.lang.Hours.." ";
	end

	sret=sret..mins..LFGShout.lang.Minutes;

return sret;




end

function LFGShout.utils:Explode(delimiter, text)
  local list = {}; local pos = 1
  
  if strtrim(text)=="" then
    return {}
  end

  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end

--------------------------Init-----------------------------------------
function LFGShout.utils:InitSettings()
	if (LFGShout_Global==nil or LFGShout_Global.Version==nil) then -- New Install or settings wiped
	
		LFGShout_Global ={
			Version=0.1, 
			Debug=0,
			};

	end
	
	
	--- Upgrade Settings 
	if (LFGShout_Global.FilterLevel==nil) then LFGShout_Global.FilterLevel=45 end
	if (LFGShout_Global.ChatShout==nil) then LFGShout_Global.ChatShout=true end
	if (LFGShout_Global.ShowTrade==nil) then LFGShout_Global.ShowTrade=true end
	if (LFGShout_Global.CustomAchs==nil) then LFGShout_Global.CustomAchs={} end
	if (LFGShout_Global.ShowGuild==nil) then LFGShout_Global.ShowGuild=true end
	if (LFGShout_Global.ShowLFG==nil) then LFGShout_Global.ShowLFG=true end
	if (LFGShout_Global.ShowAlert==nil) then LFGShout_Global.ShowAlert=true end
	if (LFGShout_Global.ForwardMessages==nil) then LFGShout_Global.ForwardMessages=true end

	
	if (LFGShout_Global.CustomWhiteList==nil) then LFGShout_Global.CustomWhiteList="" end
	if (LFGShout_Global.CustomBlackList==nil) then LFGShout_Global.CustomBlackList="" end
	
	if (LFGShout_Global.MyAdverts==nil) then LFGShout_Global.MyAdverts={} end

	if (LFGShout_Global.Coordinates==nil) then LFGShout_Global.Coordinates=true end
	if (LFGShout_Global.CoordinatesTomTom==nil) then LFGShout_Global.CoordinatesTomTom=true end
	
	LFGShout.vars.StdFilterCount=#LFGShout.lang.Filters; -- store number of standard defined filters.
	
	 LFGShout.utils:LoadCustomLists();
	 
	
	 --- Setup broacst timer
	 
	 LFGShout.timer.tmrBC = LFGShout.timer:ScheduleRepeatingTimer("Broadcast", LFGShout.vars.broadcastFreq) --- every 5 seconds

	 
	SLASH_LFGSHOUT1 = "/lfgshout";
	SLASH_LFGSHOUT2 = "/lfgs";

	SlashCmdList["LFGSHOUT"] = LFGShout_SlashHandler;
end

--------------------------Broadcast Channel Management-----------------------------
function LFGShout.utils:JoinChannel()

	
	
	if (not LFGShout_Global.ForwardMessages) then
		LeaveChannelByName("LFGShout")
		LFGShout.vars.Channel=-1
		return
	end

	local chans={GetChannelList()}
	
	if (LFGShout.vars.Channel==-1 and (#chans==0 or chans[1]~=1 or chans[2]==nil)) then return end; ---ensure channel are all registered before ours
	
	
	 for ind,name in ipairs(chans) do 
	 	if type(name)=="string" then
			if string.upper(name)=="LFGSHOUT" then
				LFGShout.vars.Channel=chans[ind-1]
				return
			end
		end
	end
	
	
	chan, name = JoinPermanentChannel("LFGShout")
	LFGShout.vars.Channel=chan

end




--------------------------Broadcast Message-----------------------------
function LFGShout.timer:OnEnable()
	---LFGShout.timer.tmrBC = LFGShout.timer:ScheduleRepeatingTimer("Broadcast", 5) --- every 5 seconds
end


function LFGShout.timer:Broadcast()

	if (UnitAffectingCombat("PLAYER")) then -- Lag protection, no broadcasting whilst in combat
		LFGShout.BroadcastQ={};
		return
	end;  

	--LFGShout.utils:Debug(2,"Broacast event..");
	--are we forwarding?
	if (not LFGShout_Global.ForwardMessages) then
		--LFGShout.utils:Debug(2,"do not broadcast");
		LeaveChannelByName("LFGShout");
		LFGShout.vars.Channel=-1
		LFGShout.BroadcastQ={};
		return
	end
	
	--ensure channel is available
	LFGShout.utils:JoinChannel();
	
	
	
	--Still no channel or no messages to broadcast
	if (#LFGShout.BroadcastQ<1 or LFGShout.vars.Channel==-1) then return end;
	
	--Broadcast messages (5 max)
	msgspamcnt=0
	--LFGShout.utils:Debug(2,#LFGShout.BroadcastQ.." message on q");
	
	for f= 1, #LFGShout.BroadcastQ do
	
	
		tmpMess="FWD:["..LFGShout.BroadcastQ[f].sender.."]"..LFGShout.BroadcastQ[f].message
		tmpsend=true
		
		--ensure it not been broadcasted recently
		
		for i=1, #LFGShout.BroadcastCache do
		
				if (LFGShout.BroadcastCache[i]==tmpMess) then
					tmpsend=false
				end
				
		end
		

		--Double check its not a fuplicate in your main list
		--for i=1, #LFGShout.vars.adverts do
		--	if (LFGShout.vars.adverts[i].player==LFGShout.BroadcastQ[f].sender and LFGShout.vars.adverts[i].message==LFGShout.BroadcastQ[f].message and
		--							LFGShout.vars.adverts[i].time~=LFGShout.BroadcastQ[f].time) then
		--		LFGShout.utils:Debug(2,f..": message is duplicate or later exists");
		--		tmpsend=false
		--		break
		--	end
		--end	
	
		--Broadcast message
		if tmpsend and LFGShout.BroadcastQ[f].sender~=nil then
			SendChatMessage(tmpMess,"CHANNEL",nil,LFGShout.vars.Channel)
			LFGShout.Stats.forwarded=LFGShout.Stats.forwarded+1 -- increment stats
			msgspamcnt=msgspamcnt+1
		end
		
		LFGShout.BroadcastQ[f].sender="~"
		
		if (msgspamcnt==5) then break end;  --ensure we don't spam (5 message max)
		
		
		
	end
		
	---Clean up Q
	while #LFGShout.BroadcastQ>0 and LFGShout.BroadcastQ[1].sender=="~" do
		tremove(LFGShout.BroadcastQ, 1)
	end
	
	


end




--------------------------Custom White/Black List Management-----------------------------
function LFGShout.utils:SetCustomBlackList(data)

	LFGShout_Global.CustomBlackList=data
	
	LFGShout.utils:LoadCustomLists()
end

function LFGShout.utils:SetCustomWhiteList(data)

	LFGShout_Global.CustomWhiteList=data
	
	LFGShout.utils:LoadCustomLists()
end


function LFGShout.utils:LoadCustomLists()

	LFGShout.vars.whitelist=LFGShout.utils:Explode(";", LFGShout_Global.CustomWhiteList)
	LFGShout.vars.blacklist=LFGShout.utils:Explode(";", LFGShout_Global.CustomBlackList)

	--- Clear out old custom lists from search list (global LFGShout.lang.Filters)
	ub = #LFGShout.lang.Filters 
	if LFGShout.vars.StdFilterCount<ub then
		for n=LFGShout.vars.StdFilterCount+1,ub do
			
				tremove(LFGShout.lang.Filters, #LFGShout.lang.Filters) --- delete custom filter

		end
	end
	---Add white list
	if #LFGShout.vars.whitelist>0 then
		for n=1,#LFGShout.vars.whitelist do
			tinsert(LFGShout.lang.Filters,
				{F1=strupper(LFGShout.vars.whitelist[n]),F2="",F3="",F4="",F5="", Type=99, lStart=0, lEnd=999, Score=200})
			
		end
	end
	---Add black list
	if #LFGShout.vars.blacklist>0 then
		for n=1,#LFGShout.vars.blacklist do
			tinsert(LFGShout.lang.Filters,
				{F1=strupper(LFGShout.vars.blacklist[n]),F2="",F3="",F4="",F5="", Type=99, lStart=0, lEnd=999, Score=-200})
			
		end
	end
	
	


end

--------------------------Command Line---------------------------------
function LFGShout_SlashHandler(msg)


	msg = strupper(msg);

		if msg=="unittest" then
			LFGShout.unittest:run()
			return
		end

	
	
		if LFGShout_AdvertPlay(msg) then
			return;
		end
		
		
	
		 LFGShout.utils:Chat(LFGShout.lang.command1);
		 LFGShout.utils:Chat(LFGShout.lang.command2);
		 LFGShout.utils:Chat(LFGShout.lang.command3);
		 
		 LFGShout.utils:Chat(LFGShout.lang.command4);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat1..LFGShout.Stats.checked);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat2..LFGShout.Stats.rejected);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat3..LFGShout.Stats.forwarded);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat4..LFGShout.Stats.added);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat5..LFGShout.Stats.fromforward);
		 
	

	
end

function LFGShout.utils:DisplayStats()
	
		 LFGShout.utils:Chat(LFGShout.lang.command1);
		 
		 LFGShout.utils:Chat(LFGShout.lang.command4);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat1..LFGShout.Stats.checked);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat2..LFGShout.Stats.rejected);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat3..LFGShout.Stats.forwarded);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat4..LFGShout.Stats.added);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat5..LFGShout.Stats.fromforward);
		 LFGShout.utils:Chat(LFGShout.lang.command_stat6..LFGShout.utils:TimeString(time()-LFGShout.Stats.started));


end



--------------------------Event Management-----------------------------
function LFGShout.EventManager(self,event,...)


	LFGShout.utils:Debug(3,"Event : " ..event);
	
    if (event=="ADDON_LOADED") then
			LFGShout.event:ADDON_LOADED(...)
         
    elseif (event=="VARIABLES_LOADED") then
            LFGShout.event:VARIABLES_LOADED(...)
	
	elseif (event=="CHAT_MSG_CHANNEL") then
			LFGShout.event:CHAT_MSG_CHANNEL(...)
	end
end


function LFGShout.event:VARIABLES_LOADED(...)
	LFGShout.utils:Debug(3, "Vars Loaded!");	
	LFGShout.lang:Init();
	LFGShout.utils:InitSettings();
	LFGShout.utils:Chat(LFGShout.lang.welcome);
	
	SlashCmdList["LFGShout"] = LFGShout_SlashHandler;
	
	 
end



function LFGShout.event:ADDON_LOADED(...)
	LFGShout.utils:Debug(3, "Addons Loaded!");	
end

function LFGShout.event:CHAT_MSG_CHANNEL(...)
		message,sender, language, channel,aa,ab,ac,ad = ...;
		 
		 LFGShout.utils:Debug(2,"**:"..message);
		  LFGShout.utils:Debug(2,"**:"..sender);
		   LFGShout.utils:Debug(2,"**:"..language);
		    LFGShout.utils:Debug(2,"**:"..channel);
			LFGShout.utils:Debug(2,"**:"..aa);
			LFGShout.utils:Debug(2,"**:"..ab);
			LFGShout.utils:Debug(2,"**:"..ac);
		 LFGShout.utils:AdvertAdd(message,sender,channel);
		
		
		return
  
end
--------------------------Advert Manager-------------------------------
function LFGShout.utils.TrimAdvert(txtAdvert, tSize)


	if strlen(txtAdvert)<=tSize then
		return txtAdvert;
	end
	
	strlink="|%x+|H.-|H.-|H|R";
	tNewSize=tSize;
	
	spos,epos=strfind(string.upper(txtAdvert),strlink);
	while spos~=nil do
		if (tSize>=spos and tSize<=epos) then 
			tNewSize=epos;
		end
		spos,epos=strfind(string.upper(txtAdvert),strlink,epos);
	
	end
	
	return strsub(txtAdvert,1,tNewSize).."...";
	
	

end

function LFGShout.utils:ClearAdverts() 
	LFGShout.lDBObject.text = "0"
	LFGShout.vars.adverts={}
	
	
end

function LFGShout.utils:IsPlayer(pName)
	
	if pName==UnitName("PLAYER") then --Same name (non shared server)
		return true;
	end
	
	if strlower(pName)==strlower(UnitName("PLAYER").."-"..GetRealmName()) then -- shared server match for server name at end
		return true
	end
	
	return false

end

--------------------------Process Advert-------------------------------
function LFGShout.utils:AdvertAdd(pmessage,psender,pchannel)

	
	LFGShout.Stats.checked=LFGShout.Stats.checked+1 --- increment stats
	LFGShout.Stats.rejected=LFGShout.Stats.rejected+1 --- increment stats - assume rejected until added
	
	--Translate Forwarded Messages
	local msgfwd=false
	cpos,cend =strfind(strupper(pchannel),"LFGSHOUT",1)
	local isLFGShoutChan= (cpos~=nil)
	
	LFGShout.utils:Debug(5,"Channel: "..pchannel);
	LFGShout.utils:Debug(5,"Sender: "..psender);
	
	
	if (isLFGShoutChan and strsub(pmessage,1,5)=="FWD:[") then --- cache last 40 messages sent
		
		LFGShout.Stats.fromforward=LFGShout.Stats.fromforward+1 --- increment stats
		
		if (#LFGShout.BroadcastCache>39) then tremove(LFGShout.BroadcastCache,1) end;
		
		tinsert(LFGShout.BroadcastCache,pmessage)
		
	end
	
	if (UnitAffectingCombat("PLAYER")) then return end;  -- Lag protection, no recording whilst in combat
	
	if (isLFGShoutChan and (LFGShout.utils:IsPlayer(psender) and LFGShout_Global.Debug<4) and strsub(pmessage,1,5)=="FWD:[") then  return end; -- discard no formatted messages
	
	if ( isLFGShoutChan and (LFGShout.utils:IsPlayer(psender)==false or LFGShout_Global.Debug>3) and strsub(pmessage,1,5)=="FWD:[") then
		LFGShout.utils:Debug(5,"Forwarded!");
		
		msgfwd=true
		
		spos=strfind(pmessage,"]")
		
		if spos~=nil then
		
			psender=strsub(pmessage,6, spos-1)
			pmessage=strsub(pmessage,spos+1)
			
			LFGShout.utils:Debug(5,"FW Sender: "..psender);
			LFGShout.utils:Debug(5,"FW Message: "..pmessage);
		else
			return
		
		end

	end
	
	
	
	
	
	--Unit Level
	
	plev=UnitLevel("PLAYER")

	
	--- Check for duplicates
	local isdupl=false;
	
	--Write
	umess=string.upper(pmessage);
	LFGShout.utils:Debug(5,pmessage);

	totScore=0;
	totScoreUDF = 0;
	rawScore=0;
	msgType=0;
	
	if (pchannel~=nil and strfind(pchannel,LFGShout.lang.LFGChannelText,1,true)~=nil) then
		LFGShout.utils:Debug(5,"LFG Channel");
		totScore=25;
	end
	

	
	 for n=1,#LFGShout.lang.Filters do
		--LFGShout.utils:Debug(5,"Filter:"..n);
		
		if (LFGShout.lang.Filters[n].lStart<=plev and LFGShout.lang.Filters[n].lEnd>=plev) then
			
								
			--LFGShout.utils:Debug(5,"Filter L:"..LFGShout.lang.Filters[n].F1);
			local spos=nil;
			local epos = nil;
			
			if (LFGShout.lang.Filters[n].SingleWord==false) then ---Filter is a link or complex expression
			
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F1)~="" then 
							spos,epos=string.find(umess,LFGShout.lang.Filters[n].F1,1)
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F2)~="" then 
					if spos==nil then spos,epos=string.find(umess,LFGShout.lang.Filters[n].F2,1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F3)~="" then 
					if spos==nil then spos,epos=string.find(umess,LFGShout.lang.Filters[n].F3,1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F4)~="" then 
					if spos==nil then spos,epos=string.find(umess,LFGShout.lang.Filters[n].F4,1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F5)~="" then 
					if spos==nil then spos,epos=string.find(umess,LFGShout.lang.Filters[n].F5,1) end
				end
			
			else
			
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F1)~="" then 
							spos,epos=string.find(" "..umess.." ","[%s%\\%./,%?]"..LFGShout.lang.Filters[n].F1.."[%s%\\%./,%?]",1)
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F2)~="" then 
					if spos==nil then spos,epos=string.find(" "..umess.." ","[%s%\\%./,%?]"..LFGShout.lang.Filters[n].F2.."[%s%\\%./,%?]",1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F3)~="" then 
					if spos==nil then spos,epos=string.find(" "..umess.." ","[%s%\\%./,%?]"..LFGShout.lang.Filters[n].F3.."[%s%\\%./,%?]",1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F4)~="" then 
					if spos==nil then spos,epos=string.find(" "..umess.." ","[%s%\\%./,%?]"..LFGShout.lang.Filters[n].F4.."[%s%\\%./,%?]",1) end
				end
				
				if LFGShout.utils:SafeNil(LFGShout.lang.Filters[n].F5)~="" then 
					if spos==nil then spos,epos=string.find(" "..umess.." ","[%s%\\%./,%?]"..LFGShout.lang.Filters[n].F5.."[%s%\\%./,%?]",1) end
				end
			end
			
			if (spos~=nil) then
					LFGShout.utils:Debug(5,"Found in Filter: "..LFGShout.lang.Filters[n].F1);
					LFGShout.utils:Debug(5,"text detected ["..n.."] Found '"..strsub(umess,spos-1, epos-1).."'")
					
					
					totScore=totScore+LFGShout.lang.Filters[n].Score
					
					if LFGShout.lang.Filters[n].Type~=99 then rawScore=rawScore+LFGShout.lang.Filters[n].Score end --Only include system filters
					
					if (msgType<LFGShout.lang.Filters[n].Type) then msgType=LFGShout.lang.Filters[n].Type end
			else
				--LFGShout.utils:Debug(5,"Failed ["..n.."]: '"..string.gsub(umess,"|", "||").."'")
			end
			
			
		
		end
	end	
	
	local mtime=time();
	
	LFGShout.utils:Debug(5,"Score:"..totScore);
	LFGShout.utils:Debug(5,"UDFScore:"..(totScore-rawScore));
	LFGShout.utils:Debug(5,"Type:"..msgType);
	LFGShout.utils:Debug(5,"Filter Level:"..LFGShout_Global.FilterLevel);
	
	if (rawScore>44 and LFGShout_Global.ForwardMessages and msgfwd==false and isLFGShoutChan==false and msgType~=9) then
		
		
		bcmsg={sender=psender, message=pmessage, time=mtime}
		
		tinsert(LFGShout.BroadcastQ,1,bcmsg); --- add a message onto the broadcast Q
		--LFGShout.utils:Debug(2,"Added to broadcast Q : len "..#LFGShout.BroadcastQ);
	end
	
		-- Filter out own messages
	if (LFGShout.utils:IsPlayer(psender) and LFGShout_Global.Debug==0) then
		return;
	end
	
	
	
	if (totScore<LFGShout_Global.FilterLevel and LFGShout_Global.FilterLevel~=999) or (LFGShout_Global.FilterLevel==999 and (totScore-rawScore)<199) then --filter out if (normal and below threshold) or (UDF and UDF score is below 200)
		return;
	end
	
	LFGShout.utils:Debug(5,"Passed score check.");
	
	if (LFGShout_Global.ShowTrade==false and (msgType==1 or msgType==2)) then -- filter out - trade
		return
	end
	
	if (LFGShout_Global.ShowGuild==false and msgType==5) then -- filter out - Guild
		return
	end
	
	if (LFGShout_Global.ShowLFG==false and (msgType==3 or msgType==4)) then -- filter out - LFG and Quest
		return
	end

	if (LFGShout_Global.Coordinates==false and msgType==9 ) then -- filter out - coords
		return
	end

	LFGShout.utils:Debug(5,"Passed type filter.");
	
	
	tAdvert={time=0; player="",shortmessage="",msgtype=0,score=0,message="",channel="",color="", class="", count=1, Changed=true, coordX=0,coordY=0};

	pmessage=string.gsub(pmessage,"<","[");
	pmessage=string.gsub(pmessage,">","]");
	pmessage=string.gsub(pmessage,"/","\\");
	pmessage=string.gsub(pmessage,"&","+");

	if (msgType==9) then

		 mapPosX,mapPosY = string.match(pmessage,"(%d+%.*%d*),%s+(%d+%.*%d*)")
		 if mapPosX == nil then
		 	mapPosX,mapPosY = string.match(pmessage,"(%d+%.*%d*),(%d+%.*%d*)")
		 end
		 if mapPosX == nil then
		 	mapPosX,mapPosY = string.match(pmessage,"(%d+%.*%d*)%s+(%d+%.*%d*)")
		 end

		 if mapPosX == nil then --coords not found

		 	LFGShout.utils:Debug(5,"Failed! Cold not find co-ordinates");

		 else

		 	mapcoords = ""..mapPosX.." "..mapPosY
		 	LFGShout.utils:Debug(5,"Coords = "..mapcoords);

		 	tAdvert.coordX=tonumber(mapPosX);
		 	tAdvert.coordY=tonumber(mapPosY);


		 	if (TomTom.AddWaypointToCurrentZone~=nil and LFGShout_Global.CoordinatesTomTom==true) then -- add to tomtom if it exists
		 		TomTom:AddWaypointToCurrentZone(tAdvert.coordX, tAdvert.coordY, LFGShout.utils.TrimAdvert(pmessage,80))
		 	end


		 end




		pmessage="("..GetZoneText()..") "..pmessage;
	end

	tAdvert.shortmessage=LFGShout.utils.TrimAdvert(pmessage,80)
	tAdvert.time = mtime;
	tAdvert.player=psender;
	tAdvert.channel=pchannel;
	tAdvert.Score=totScore;
	tAdvert.msgType=msgType;
	
	if (msgType==1) then --- Buy
		tAdvert.color="FFC000";
	elseif (msgType==2) then --- Sell
		tAdvert.color="FF8000";
	elseif (msgType==3) then --- Instance/LFG
		tAdvert.color="00FF00";
	elseif (msgType==4) then --- Quest
		tAdvert.color="FFFF00";
	elseif (msgType==5) then --- Guild
		tAdvert.color="ff80ff";
	elseif (msgType==9) then --- Co-ords
		tAdvert.color="30c0ff";
		tAdvert.blockBroadcast=true;
	elseif (msgType==99) then --- Guild
		tAdvert.color="E9323C";
	else
		tAdvert.color="FFFFFF";
	end
	
	pcolor=tAdvert.color;
	
	--tAdvert.class=pclass;
	tAdvert.message=pmessage;
	

	
	for i=1, #LFGShout.vars.adverts do
		if (LFGShout.vars.adverts[i].player==psender) then
			
			tAdvert.Changed =  not (LFGShout.vars.adverts[i].message==pmessage) -- is it a new message?
			tAdvert.Changed = tAdvert.Changed or LFGShout.vars.adverts[i].Changed
			
			if not msgfwd then tAdvert.count=LFGShout.vars.adverts[i].count+1 end;
			
			tremove(LFGShout.vars.adverts,i);
			tinsert(LFGShout.vars.adverts,1,tAdvert);
			
			
		
			isdupl =true;
			break;
		end
	end	
	
	if  (not isdupl) then		
			LFGShout.Stats.rejected=LFGShout.Stats.rejected-1 --- decrement stats because added
			LFGShout.Stats.added=LFGShout.Stats.added+1
			tinsert(LFGShout.vars.adverts,1,tAdvert);

	end
	

	
	
	if (#LFGShout.vars.adverts>40) then
		tremove(LFGShout.vars.adverts,#LFGShout.vars.adverts);
	end
	
	
	
	--LFGShout.utils:Debug(2,"Shouting");
	if (LFGShout_Global.ChatShout) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffFFC000--> LFG Shout: |cff"..pcolor.."|Hplayer:"..psender.."|h["..psender.."]|h "..pmessage.."|cffFFC000 <--|r");
	end
	
	if LFGShout_Global.ShowAlert then 
		UIErrorsFrame:AddMessage("|cFFFFFFFF["..psender.."]|cff"..pcolor..pmessage);
	end
	
	if msgType==9 then
	 	PlaySound(SOUNDKIT.UI_GARRISON_TOAST_INVASION_ALERT)
	elseif msgType<99 then
		PlaySound(SOUNDKIT.TELL_MESSAGE);
	else
		PlaySound(SOUNDKIT.UI_GARRISON_SHIPMENTS_WINDOW_OPEN);
	end
	
	
	---Manage new message count.
	LFGShout.NewMessages= 0
	for i=1, #LFGShout.vars.adverts do
		if LFGShout.vars.adverts[i].Changed then LFGShout.NewMessages= LFGShout.NewMessages+1 end;
	end
	
	if LFGShout.NewMessages>0 then
		LFGShout.lDBObject.text = "|cff00ff00"..LFGShout.NewMessages 
	else
		LFGShout.lDBObject.text = "0"
		
	end

end



--------------------------Broker functions---------------------------------

local function LFGShout_ClickLine(line, setName, button)
	if (setName=="Browse Players") then LFGShout_Browse_Frame:Show() end
	if (setName=="Current Session") then LFGShout.utils:SessionToggle() end
	if (setName=="Configure") then InterfaceOptionsFrame_OpenToCategory(LFGShout_OptionsFrame) end
	
	LFGShout.broker.tooltip:Hide();
	
end

local function LFGShout_ClickPlaya(line, setName, button)

		if (button=="LeftButton") then
		
			ChatFrame_OpenChat("/w "..LFGShout.vars.adverts[setName].player.." ", DEFAULT_CHAT_FRAME);
		else
			if LFGShout.vars.adverts[setName].msgType==9 then 

				if (TomTom.AddWaypointToCurrentZone~=nil and LFGShout_Global.CoordinatesTomTom==true) then -- add to tomtom if it exists
					 TomTom:AddWaypointToCurrentZone(LFGShout.vars.adverts[setName].coordX, LFGShout.vars.adverts[setName].coordY, LFGShout.vars.adverts[setName].shortmessage)
				end

			else

				LFGShout.Dialogs.PST:Show(LFGShout.vars.adverts[setName].player, LFGShout.vars.adverts[setName].message,LFGShout.vars.adverts[setName].msgType)
				
				LFGShout.broker.tooltip:Hide();
			end
		end
end

--------------------------MyAdvert Management--------------------------
function LFGShout_AdvertPlay(msg)
		
		
	for i=1, #LFGShout_Global.MyAdverts do
	
		
		if string.upper(LFGShout_Global.MyAdverts[i].name)==string.upper(msg) then
					LFGShout.Advertise(i, false)
					return true;
		end
		
	
	end

	return false;

end
local function LFGShout_Advert(line, setName, button)


	if (button=="LeftButton" and setName~=0) then
		LFGShout.Advertise(setName, false, false) 
		LFGShout.broker.tooltip:Hide();

	elseif (setName==0) then
		LFGShout_Global.MyAdverts[#LFGShout_Global.MyAdverts+1]={name="<New Advert>",lines={"","","","","",},cityshout=false,skill=1,}
		LFGShout.Dialogs.Advert:Show(#LFGShout_Global.MyAdverts)
	else
		
	
			LFGShout.Dialogs.Advert:Show(setName)

	end
	
	
	

end

local function LFGShout_Tooltip_Show(frame)

	--Manage count display
	LFGShout.OpenedAt=#LFGShout.vars.adverts
	LFGShout.lDBObject.text = "0"
	
	-----Define Dropdown
	
	
	
	if tip:IsAcquired("Broker_LFGShout") then tip:Release(LFGShout.broker.tooltip) end
	LFGShout.broker.tooltip = tip:Acquire("Broker_LFGShout", 4, "LEFT", "LEFT","RIGHT", "RIGHT")
	--LFGShout.broker.tooltip:SetColumnLayout(4, "LEFT", "LEFT","RIGTH", "RIGHT")
	
	--LFGShout.broker.tooltip:SetColumnColor(1,0,255,255,1)
	--LFGShout.broker.tooltip:SetColumnColor(2,0,0,0,1)
	--LFGShout.broker.tooltip:SetColumnColor(3,255,128,0,1)
	--LFGShout.broker.tooltip:SetColumnColor(4,255,255,0,1)
	
	
	--write Menu Items
		LFGShout.broker.tooltip:AddHeader("|cffff8000Messages","","","")
		local row, col = LFGShout.broker.tooltip:AddLine("|cffffffffMessage", "|cffffffffPlayer","When","|CFFFFFFffCount")
		LFGShout.broker.tooltip:SetLineColor(row,1,.5,0,1)
		
	--	LFGShout.broker.tooltip:SetLineScript(1, "OnMouseDown", LFGShoutBTooltip_ClickLine, "Browse Players")
	--	LFGShout.broker.tooltip:AddLine("|TInterface\\Icons\\INV_Misc_Bone_OrcSkull_01.blp:16|t", "Current Session")
	--	LFGShout.broker.tooltip:SetLineScript(2, "OnMouseDown", LFGShoutBTooltip_ClickLine, "Current Session")
		--LFGShout.broker.tooltip:AddLine("|TInterface\\Icons\\INV_Holiday_Christmas_Present_01.blp:16|t", "Configure")
		--LFGShout.broker.tooltip:SetLineScript(3, "OnMouseDown", LFGShoutBTooltip_ClickLine, "Configure")
		
	-- Write recent History
	for i=1, #LFGShout.vars.adverts do
	
		local alpha="99"
		
	
		--Selct format for type
		local TImage="|TInterface\\Icons\\INV_Misc_Ribbon_01.blp:16|t";
		local TColor="|c"..alpha..LFGShout.vars.adverts[i].color;
		
		if LFGShout.vars.adverts[i].msgType==1 then
			TImage="|TInterface\\Icons\\INV_Misc_Coin_02.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==2 then
			TImage="|TInterface\\Icons\\INV_Misc_Coin_04.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==3 then
			TImage="|TInterface\\Icons\\INV_Misc_GroupNeedMore.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==4 then
			TImage="|TInterface\\Icons\\INV_Misc_Book_07.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==5 then
			TImage="|TInterface\\Icons\\INV_Misc_Bomb_04.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==9 then
			TImage="|TInterface\\Icons\\inv_misc_map_01.blp:16|t";
		end
		if LFGShout.vars.adverts[i].msgType==99 then
			TImage="|TInterface\\Icons\\Spell_Nature_StarFall.blp:16|t";
		end
		
		--Check if know and colour accordingly
		local pcolor="|c"..alpha.."FFFFFF"
		
		
		if (UnitIsInMyGuild(LFGShout.vars.adverts[i].player)) then pcolor="|cFFFF00FF" end
		
		if (hwm~=nil) then ---Have we Met is Installed...
			score=hwm:PlayerInfo("", LFGShout.vars.adverts[i].player)
			if score>0 then
				pcolor="|cFF00FFFF"
			end
		end
		
		
		--Add Menu Item
		
		
		
		local row, col = LFGShout.broker.tooltip:AddLine(TImage..TColor.." "..LFGShout.vars.adverts[i].shortmessage,
										pcolor..LFGShout.vars.adverts[i].player,
										"|c"..alpha.."FF80FF"..LFGShout.utils:TimeString(time()-LFGShout.vars.adverts[i].time),
										"|c"..alpha.."FFFF00"..LFGShout.vars.adverts[i].count)
		
		LFGShout.broker.tooltip:SetLineScript(row, "OnMouseDown", LFGShout_ClickPlaya, i)
		
		if (LFGShout.vars.adverts[i].Changed) then
			LFGShout.broker.tooltip:SetLineColor(row,0.5,1,0.5,0.5);
			LFGShout.vars.adverts[i].Changed=false;
		elseif (mod(i,2)>0) then -- uneven
				LFGShout.broker.tooltip:SetLineColor(row,0.25,0.5,1,0.25);
		end
		
		
		
	
	end
	
	LFGShout.broker.tooltip:AddLine(" ")
	row, col= LFGShout.broker.tooltip:AddLine("|cffC0E0FFLeft Click item to whisper")
	LFGShout.broker.tooltip:SetLineColor(row,0.047,0.188,.266,1)
	row, col= LFGShout.broker.tooltip:AddLine("|cffC0E0FFRight Click item for advanced whisper/guide with TomTom")
	LFGShout.broker.tooltip:SetLineColor(row,0.047,0.188,.266,1)
	LFGShout.broker.tooltip:AddLine(" ")
	-------------------------- adverts
	---Prof List
	skillname={}
	profs={}
	profs[1], profs[2], profs[3], profs[4], profs[5], profs[6] = GetProfessions()
	
	
	for i=1,6 do
		if (profs[i]~=nil) then
		
			name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(profs[i])
		
			skillname[i]=name;
		
		else
		
			skillname[i]="None";
		end
	end
	
	skillname[7]="";
	
	tmpStartLine=#LFGShout.vars.adverts+8; ---- 1st action line (i.e. create)
	
	
	
	LFGShout.broker.tooltip:AddSeparator(1, 1, 1, 1, 1)
	LFGShout.broker.tooltip:AddHeader("|cffff8000Your Adverts")
	row,col=LFGShout.broker.tooltip:AddLine("|cffffffffAdvert","|cffffffffSkill")
	LFGShout.broker.tooltip:SetLineColor(row,1,.5,0,1)

	
	
	for i=1, #LFGShout_Global.MyAdverts do
	
		
		local row,col = LFGShout.broker.tooltip:AddLine("|cffFFF000"..LFGShout_Global.MyAdverts[i].name, skillname[LFGShout_Global.MyAdverts[i].skill])
		LFGShout.broker.tooltip:SetLineScript(row, "OnMouseDown", LFGShout_Advert,i)
		LFGShout.broker.tooltip:SetLineColor(row,0,1,32/255,0);
		
	end
	
	
	LFGShout.broker.tooltip:AddLine(" ")
	row,col=LFGShout.broker.tooltip:AddLine("|TInterface\\Icons\\Inv_misc_orb_03.blp:16|t|cff00FFFFCreate New...")
	LFGShout.broker.tooltip:SetLineColor(row,0.5,1,0.5,0.5);
	LFGShout.broker.tooltip:SetLineScript(row, "OnMouseDown", LFGShout_Advert,0)
	
	LFGShout.broker.tooltip:AddLine(" ")
	LFGShout.broker.tooltip:AddLine("|cffC0E0FFLeft click to advertise.")
	LFGShout.broker.tooltip:AddLine("|cffC0E0FFRight click to edit.")
	LFGShout.broker.tooltip:AddLine(" ")
	-- end menu Items
	
	LFGShout.broker.tooltip:AddSeparator(1, 1, 1, 1, 1)
	row, col = LFGShout.broker.tooltip:AddLine("|TInterface\\Icons\\Inv_misc_note_04.blp:16|t|cffffffffConfigure...")
	LFGShout.broker.tooltip:SetLineScript(row, "OnMouseDown", LFGShout.broker.OpenOptions,"")

	
	LFGShout.broker.tooltip:SmartAnchorTo(frame)
	LFGShout.broker.tooltip:SetAutoHideDelay(1, frame)
	LFGShout.broker.tooltip:Show()
end
function LFGShout.broker:OpenOptions()
	LFGShout.config.AceDialog:Open("LFGShout");
end

--------------------------Shout Advert ---------------------------------
function LFGShout.Advertise(index, isTest, isSecure)
	if (isSecure==nil) then 
		isSecure=true ;
	end;

	if (isTest==nil) then 
		isTest=false ;
	end;
	
	if (LFGShout.vars.lastsentadvert+60>GetTime() and not isTest) then --- one advert per 2 minutes
		LFGShout.utils:Chat("|cffff0000Spam Protection: Can only send one message every 1 minutes. "..floor((LFGShout.vars.lastsentadvert+60)-GetTime()).." seconds to go!")
		return;
	end
	
	
	local advert = LFGShout_Global.MyAdverts[index]
	
	if (strfind(advert.lines[1]..advert.lines[2],"#")~=nil and not isSecure) then -- Protect against wow secure function issue
		LFGShout.utils:Chat("|cffff0000The message could contain links that will cause an error if sent from this menu. Right Click on the advert and use the Advertise button.")
		return
	end
	
	if (not isTest) then
		LFGShout.vars.lastsentadvert=GetTime();
	end
	
	---Prof List
	local profs={}
	profs[1], profs[2], profs[3], profs[4], profs[5], profs[6] = GetProfessions()
	
	local trade_link="<?>"
	local trade_name="<?>"
	local trade_level="<?>"

	local ilvl=0
	
	
	
	if (strfind(advert.lines[1]..advert.lines[2],"#ilvl#")~=nil) then
		ilvl = PlayerIlvl()
	end
	
		
	
	if (profs[advert.skill]~=nil and profs[advert.skill]~=6 and  strfind(advert.lines[1]..advert.lines[2],"#tradelink#")~=nil) then
	
		name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(profs[advert.skill])
		
		trade_name=name
		trade_level=""..rank
		
		
		
		
		
		
		CastSpellByName(name);
		trade_link=GetTradeSkillListLink();
		if (trade_link==nil) then  --- must have been open
			CastSpellByName(name);
			trade_link=GetTradeSkillListLink();
		end
		
		if (trade_link==nil) then  --- failed gettign link
			trade_link="["..name.."]"; ---at least it will look right
		end
		
		
		CloseTradeSkill()
		
		
		
	end
	
	
		
	--- {name="<New Advert>",lines={"","","","","",},cityshout=false,skill=1,}

	;------Produce Chat line
	
	local targ_chan=GetUnitName("PLAYER")
	local targ_type="WHISPER"
	
	if (not isTest) then
		targ_chan=2
		targ_type="CHANNEL"
	end
	
	
	
	if (isTest) then 
		SendChatMessage("Testing Trade Message : "..advert.name,targ_type,nil,targ_chan)
	end
	
	
	---Process Message Lines
	for i=1,2 do --- Note can only us 2 lines currently
		advert_line=advert.lines[i]
		
		if (advert_line~="") then 
			
			
			---Process and replace macro text
			
			----#tradelink#, #tradename#, #tradelevel#,  #link:<spell id>#, #zone#
			
			advert_line=string.gsub(advert_line, "#tradename#", trade_name)
			advert_line=string.gsub(advert_line, "#tradelevel#", trade_level)
			advert_line=string.gsub(advert_line, "#tradelink#", trade_link)
			advert_line=string.gsub(advert_line, "#zone#",GetZoneText())
			advert_line=string.gsub(advert_line, "#ilvl#",floor(GetAverageItemLevel()))
			class, fn = UnitClass("Player")
			advert_line=string.gsub(advert_line, "#class#",class)
			
			local spellpos_s=string.find(advert_line,"#link:")
			local spellpos_e=-1
			
			if (spellpos_s~=nil) then
				spellpos_e=string.find(advert_line,"#",spellpos_s+6)
			end
			
			while (spellpos_s~=nil and spellpos_e>spellpos_s) do
				
				local spelltext=string.sub(advert_line,spellpos_s,spellpos_e)
				local spellid = string.sub(spelltext,7,-2)
				--Build Link
				
				spell_link = GetSpellLink(spellid)
				if (spell_link==nil) then
					spell_link="<spell "..spellid.." nf>"
				end
				
				
				advert_line=string.gsub(advert_line,spelltext,spell_link)
				
				
				
				
			
				spellpos_s=string.find(advert_line,"#link:")
				local spellpos_e=-1
				
				if (spellpos_s~=nil)  then
					spellpos_e=string.find(advert_line,"#",spellpos_s+1)
				end
			end
			
			
			
			SendChatMessage(""..advert_line,targ_type,nil,targ_chan)
		end
		
	end
	
	

end

------------------Get Player I Level----------------------------------

function PlayerIlvl()
 
        NotifyInspect("Player")
 
        local t,c=0,0
        for i =1,18 do
            if i~=4 then
                local k=GetInventoryItemLink("Player",i)
                if k then
                    local iname,_,_,l=GetItemInfo(k)
                    t=t+l
                    c=c+1
					
					----LFGShout.utils:Chat(k.." : "..l)
					
                end
            end
        end
        ClearInspectPlayer()
        if c>0 then
            return(t/c)
        end
    
end


--------------------------Broker Class---------------------------------
function LFGShout.broker:OnInitialize()
    -- Called when the addon is loaded
    self.lDBStruc = {
		type = 'data source',
		label = 'LFG Shout',
		text = '0',
		icon = 'Interface\\Icons\\Ability_Warrior_WarCry',
		OnEnter = LFGShout_Tooltip_Show,
		OnClick = function(frame, msg)
		if msg == "RightButton" then
			LFGShout.broker:OpenOptions()
		end
	end,
	}
	
	LFGShout.lDBObject = LDB:NewDataObject("LFGShout", self.lDBStruc)
end
