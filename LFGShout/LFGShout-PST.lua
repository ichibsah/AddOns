
LFGShout.Dialogs.PST={};
LFGShout.Dialogs.GUI= LibStub("AceGUI-3.0")
LFGShout.Dialogs.PST.Achdata={};
LFGShout.Dialogs.PST.Active=false;
LFGShout.Dialogs.PST.Message="";
------Show Dialog

function LFGShout.Dialogs.PST:Show(player, message, msgtype)
	if (LFGShout.Dialogs.PST.Active) then  LFGShout.Dialogs.PST:OnClose(LFGShout.Dialogs.PST.frame); end; --- form already open so close
	
	LFGShout.Dialogs.PST.Active=true
	LFGShout.Dialogs.PST.Message=message;
	tFontName=QuestFontNormalSmall:GetFont();
	LFGShout.Dialogs.PST.Player=player;
	LFGShout.Dialogs.PST.Reply=LFGShout_Global.WhisperMessage;
	LFGShout.Dialogs.PST.SelAch=-1;
	---Main Window
	LFGShout.Dialogs.PST.frame = LFGShout.Dialogs.GUI:Create("Frame")
	LFGShout.Dialogs.PST.frame:SetTitle("Reply...")
	LFGShout.Dialogs.PST.frame:SetAutoAdjustHeight(true)
	LFGShout.Dialogs.PST.frame:SetStatusText("This window allows you to respond to the message.")
	LFGShout.Dialogs.PST.frame:SetCallback("OnClose", function(widget) LFGShout.Dialogs.PST:OnClose(widget) end)
	LFGShout.Dialogs.PST.frame:SetLayout("List")
		----Spacer
	--LFGShout.Dialogs.PST.spacer0 = LFGShout.Dialogs.GUI:Create("Heading")

	--LFGShout.Dialogs.PST.spacer0:SetText("Advert")
	--LFGShout.Dialogs.PST.spacer0:SetFullWidth(true)
	--LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.spacer0)
	----Header
	LFGShout.Dialogs.PST.hadvert = LFGShout.Dialogs.GUI:Create("Label")
	LFGShout.Dialogs.PST.hadvert:SetFont(tFontName,15,"")
	LFGShout.Dialogs.PST.hadvert:SetText("|cffFF8000"..player.."|cFF00FFFF wrote...")
	LFGShout.Dialogs.PST.hadvert:SetFullWidth(true)
	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.hadvert)
	----Message
	LFGShout.Dialogs.PST.advert = LFGShout.Dialogs.GUI:Create("Label")
	LFGShout.Dialogs.PST.advert:SetFont(tFontName,15,"")
	LFGShout.Dialogs.PST.advert:SetText("\n"..message.."\n")
	LFGShout.Dialogs.PST.advert:SetFullWidth(true)
	--LFGShout.Dialogs.PST.advert:SetHeight(50)
	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.advert)
	
	strlink="|%x+|H.-|H.-|H|R";

	spos,epos=strfind(string.upper(message),strlink);
	
	if (spos~=nil) then --- found a link
		
		----Add button to send link to chat
		LFGShout.Dialogs.PST.selfsend = LFGShout.Dialogs.GUI:Create("Button")
		LFGShout.Dialogs.PST.selfsend:SetText("Send to chat for links")

		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.selfsend)
		LFGShout.Dialogs.PST.selfsend:SetCallback("OnClick", function(widget, event) LFGShout.utils:Chat(LFGShout.Dialogs.PST.Message) end)
	
	end
	
	
	if (msgtype>2) then --- not a grouping request
	
		if (hwm~=nil and hwm.PlayerSummaryText~=nil) then ---Have we Met is Installed...
		----Spacer
			
			local txtHWM=hwm:PlayerSummaryText("",player);
		
			if (txtHWM~=nil) then 
				--Create Header---
				LFGShout.Dialogs.PST.spacer0 = LFGShout.Dialogs.GUI:Create("Heading")

				LFGShout.Dialogs.PST.spacer0:SetText("Have We Met?")
				LFGShout.Dialogs.PST.spacer0:SetFullWidth(true)
				LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.spacer0)
				
				----Data
				LFGShout.Dialogs.PST.hwm = LFGShout.Dialogs.GUI:Create("Label")
				LFGShout.Dialogs.PST.hwm:SetFont(tFontName,12,"")
				LFGShout.Dialogs.PST.hwm:SetText(txtHWM)
				LFGShout.Dialogs.PST.hwm:SetFullWidth(true)
				LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.hwm)
			end
		
		end
		
		
		
		----Spacer
		LFGShout.Dialogs.PST.spacer2 = LFGShout.Dialogs.GUI:Create("Heading")

		LFGShout.Dialogs.PST.spacer2:SetText("Achievement Link")
		LFGShout.Dialogs.PST.spacer2:SetFullWidth(true)
		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.spacer2)
		
		----Header
		LFGShout.Dialogs.PST.hach = LFGShout.Dialogs.GUI:Create("Label")
		LFGShout.Dialogs.PST.hach:SetFont(tFontName,15,"")
		LFGShout.Dialogs.PST.hach:SetText("|cFF00FFFFSelect Achievement...")
		LFGShout.Dialogs.PST.hach:SetFullWidth(true)
		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.hach)
		
		----Achievement
		LFGShout.Dialogs.PST.ach = LFGShout.Dialogs.GUI:Create("Dropdown")
		
		LFGShout.Dialogs.PST.ach:SetFullWidth(true)
		
		local selected=LFGShout.Dialogs.PST:UpdateAchList()
			
		LFGShout.Dialogs.PST.ach:SetList(LFGShout.Dialogs.PST.Achdata);
		
		LFGShout.Dialogs.PST.ach:SetValue(selected);
		LFGShout.Dialogs.PST.SelAch=selected;
		
		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.ach)
		LFGShout.Dialogs.PST.ach:SetCallback("OnValueChanged", function(widget, event, key) LFGShout.Dialogs.PST.SelAch=key end)
		
		---- detect Achievement Link in source text
		
		spos,epos=strfind(string.upper(message),"|HACHIEVEMENT:.-:")
		if (spos ~=nil) then
			achid=strsub(message,spos+14,epos-1)
			LFGShout.utils:Debug(2,"Chat Ach Id:"..achid);
			
			LFGShout.Dialogs.PST:AddAchList(achid);
		end
		
			
		
		
		
		----Add a custom acheivement
		LFGShout.Dialogs.PST.hnewach = LFGShout.Dialogs.GUI:Create("Label")
		LFGShout.Dialogs.PST.hnewach:SetText("To add an achievement to the list type its ID into the box below and click OK.")
		LFGShout.Dialogs.PST.hnewach:SetFullWidth(true)
		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.hnewach)
		

		
		
		LFGShout.Dialogs.PST.newach = LFGShout.Dialogs.GUI:Create("EditBox")
		LFGShout.Dialogs.PST.newach:SetText("Add Achievement [ID]:")
		LFGShout.Dialogs.PST.newach:SetText("0")
		LFGShout.Dialogs.PST.newach:DisableButton(flase);
		LFGShout.Dialogs.PST.newach:SetCallback("OnEnterPressed", function(widget, event, text) LFGShout.Dialogs.PST:AddAchList(text) end)
		LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.newach)
		
	end
	----Spacer
	LFGShout.Dialogs.PST.spacer1 = LFGShout.Dialogs.GUI:Create("Heading")

	LFGShout.Dialogs.PST.spacer1:SetText("Reply")
	LFGShout.Dialogs.PST.spacer1:SetFullWidth(true)
	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.spacer1)
	
	----Header
	LFGShout.Dialogs.PST.hresp = LFGShout.Dialogs.GUI:Create("Label")
	LFGShout.Dialogs.PST.hresp:SetFont(tFontName,15,"")
	LFGShout.Dialogs.PST.hresp:SetText("\n|cFF00FFFFReply to |cffFF8000"..player.."|cFF00FFFF with...\n")
	LFGShout.Dialogs.PST.hresp:SetFullWidth(true)
	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.hresp)
	----Reply Message
	LFGShout.Dialogs.PST.message = LFGShout.Dialogs.GUI:Create("EditBox")
	LFGShout.Dialogs.PST.message:SetText(LFGShout_Global.WhisperMessage)
	LFGShout.Dialogs.PST.message:SetFullWidth(true)
	LFGShout.Dialogs.PST.message:DisableButton(true);
	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.message)
	LFGShout.Dialogs.PST.message:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.PST.Reply=text end)
	
	----Reply Message
	LFGShout.Dialogs.PST.messageb = LFGShout.Dialogs.GUI:Create("Button")
	LFGShout.Dialogs.PST.messageb:SetText("Send Reply")

	LFGShout.Dialogs.PST.frame:AddChild(LFGShout.Dialogs.PST.messageb)
	LFGShout.Dialogs.PST.messageb:SetCallback("OnClick", function(widget, event) LFGShout.Dialogs.PST:SendMessage() end)
	
end



function LFGShout.Dialogs.PST:SendMessage()

	txtMessage=LFGShout.Dialogs.PST.Reply;
	achid=LFGShout.Dialogs.PST.SelAch;
	
	if (achid>-1) then  txtMessage=txtMessage.." "..GetAchievementLink(achid) end;

	SendChatMessage(txtMessage,"Whisper","",LFGShout.Dialogs.PST.Player);
	
	LFGShout.Dialogs.PST:OnClose(LFGShout.Dialogs.PST.frame);
	
end


function LFGShout.Dialogs.PST:AddAchList(text)

	LFGShout.utils:Debug(2,"Adding??");
	local id = tonumber(text);
	if (id==nil) then return end ---Check its a number
	
	id=floor(id); ---round number to int
	
	if (LFGShout.Dialogs.PST.Achdata[id]~=nil) then 
				LFGShout.utils:Debug(2,"Exists!!");
				LFGShout.Dialogs.PST.ach:SetValue(id);
				return
				
	end --- already exists
	
	local id1, name, points, completed,  month, day, year, description,  flags, icon, rewardText =  GetAchievementInfo(id)
	
	if (id1~=id) then return end ---Not found
	
	LFGShout.utils:Debug(2,"Added");
	tinsert(LFGShout_Global.CustomAchs, id)
	
	LFGShout.Dialogs.PST:UpdateAchList();
	LFGShout.Dialogs.PST.ach:SetList(LFGShout.Dialogs.PST.Achdata);
	LFGShout.Dialogs.PST.ach:SetValue(id);
	

end

function LFGShout.Dialogs.PST:UpdateAchList()
	
	--Build List
	local ach_cat = GetCategoryList()
	LFGShout.Dialogs.PST.Achdata={};
	LFGShout.Dialogs.PST.Achdata[-1]="---None---";
	
	--- Add Common Achievments
	for n=1, #LFGShout.lang.Achievments do
		local id, name, points, completed,  month, day, year, description,  flags, icon, rewardText =  GetAchievementInfo(LFGShout.lang.Achievments[n])
		if (id~=nil) then
			local txtlabel=name;
			if (completed) then txtlabel=txtlabel.."|cFF00FF00(Completed)" end
						
			--			LFGShout.utils:Debug(2,id ..":"..name);
						
			LFGShout.Dialogs.PST.Achdata[id]=txtlabel;
		end			
	
	end
	
		--- Add Common Achievments
	for n=1, #LFGShout_Global.CustomAchs do
		local id, name, points, completed,  month, day, year, description,  flags, icon, rewardText =  GetAchievementInfo(LFGShout_Global.CustomAchs[n])
		
		if (id~=nil) then
			local txtlabel=name;
			if (completed) then txtlabel=txtlabel.."|cFF00FF00(Completed)" end
						
			--			LFGShout.utils:Debug(2,id ..":"..name);
						
			LFGShout.Dialogs.PST.Achdata[id]=txtlabel;
		end			
	
	end
	
	---Check for acheivements in message
	
	return -1
	
end

---close Dialog
function LFGShout.Dialogs.PST:OnClose(widget)

	LFGShout.Dialogs.GUI:Release(widget);
	LFGShout.Dialogs.PST.Active=false;

end