
LFGShout.Dialogs.Advert={};
LFGShout.Dialogs.GUI= LibStub("AceGUI-3.0")
LFGShout.Dialogs.Advert.AdvertIndex="";
LFGShout.Dialogs.Advert.AdvertName="";
LFGShout.Dialogs.Advert.Active=false;
LFGShout.Dialogs.Advert.line1="";
LFGShout.Dialogs.Advert.line2="";
LFGShout.Dialogs.Advert.line3="";
LFGShout.Dialogs.Advert.line4="";
LFGShout.Dialogs.Advert.line5="";
LFGShout.Dialogs.Advert.cityshout=false;
LFGShout.Dialogs.Advert.SelSkill=1;

LFGShout.Dialogs.Advert.skilldata={};




------Show Dialog

function LFGShout.Dialogs.Advert:Show(advertind)

	----Build Skill List
	LFGShout.Dialogs.Advert.skilldata={};
	LFGShout.Dialogs.Advert.skilldata[1]="None";
	
	profs={}
	
	profs[1], profs[2], profs[3], profs[4], profs[5], profs[6] = GetProfessions()

	for i=1,6 do
		if (profs[i]~=nil) then
		
			name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(profs[i])
		
			LFGShout.Dialogs.Advert.skilldata[i]=i..". "..name;
		
		else
		
			LFGShout.Dialogs.Advert.skilldata[i]=i..". None";
		end
	end
	
	LFGShout.Dialogs.Advert.skilldata[7]="7. None";

	-----Load Data Form Globals
	
	LFGShout.utils:Debug(2,"edit advert = "..advertind);
	LFGShout.Dialogs.Advert.AdvertIndex=advertind;
	LFGShout.Dialogs.Advert.line1=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[1];
	LFGShout.Dialogs.Advert.line2=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[2];
	LFGShout.Dialogs.Advert.line3=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[3];
	LFGShout.Dialogs.Advert.line4=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[4];
	LFGShout.Dialogs.Advert.line5=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[5];
	LFGShout.Dialogs.Advert.cityshout=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].cityshout;
	LFGShout.Dialogs.Advert.SelSkill=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].skill;
	
	LFGShout.Dialogs.Advert.AdvertName=LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].name;
	
	
	---Dialog
	
	if (LFGShout.Dialogs.Advert.Active) then  LFGShout.Dialogs.Advert:OnClose(LFGShout.Dialogs.Advert.frame); end; --- form already open so close
	
	LFGShout.Dialogs.Advert.Active=true
	
	tFontName=QuestFontNormalSmall:GetFont();
	
	---Main Window
	LFGShout.Dialogs.Advert.frame = LFGShout.Dialogs.GUI:Create("Frame")
	LFGShout.Dialogs.Advert.frame:SetTitle("Edit Advert...")
	LFGShout.Dialogs.Advert.frame:SetAutoAdjustHeight(true)
	LFGShout.Dialogs.Advert.frame:SetStatusText("This window allows you to edit an advert message.")
	LFGShout.Dialogs.Advert.frame:SetCallback("OnClose", function(widget) LFGShout.Dialogs.Advert:OnClose() end)
	LFGShout.Dialogs.Advert.frame:SetLayout("Flow")
	----Label
	LFGShout.Dialogs.Advert.lab01 = LFGShout.Dialogs.GUI:Create("Label")
	LFGShout.Dialogs.Advert.lab01:SetFont(tFontName,15,"")
	LFGShout.Dialogs.Advert.lab01:SetText("|cffC0E0FFAdvert Name:")
	LFGShout.Dialogs.Advert.lab01:SetFullWidth(true)
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.lab01)
	----Advert Name
	LFGShout.Dialogs.Advert.txtName = LFGShout.Dialogs.GUI:Create("EditBox")
	LFGShout.Dialogs.Advert.txtName:SetText(LFGShout.Dialogs.Advert.AdvertName)
	LFGShout.Dialogs.Advert.txtName:SetFullWidth(true)
	LFGShout.Dialogs.Advert.txtName:DisableButton(true);
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtName)
	LFGShout.Dialogs.Advert.txtName:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.AdvertName=text end)
	
	----Spacer
	---LFGShout.Dialogs.Advert.spacer1 = LFGShout.Dialogs.GUI:Create("Heading")

	---LFGShout.Dialogs.Advert.spacer1:SetText("Trade to advertise")
---	LFGShout.Dialogs.Advert.spacer1:SetFullWidth(true)
---	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.spacer1)
	
	----List of Trades
---	LFGShout.Dialogs.Advert.skilllist = LFGShout.Dialogs.GUI:Create("Dropdown")
		
	---LFGShout.Dialogs.Advert.skilllist:SetFullWidth(true)
		
			
---	LFGShout.Dialogs.Advert.skilllist:SetList(LFGShout.Dialogs.Advert.skilldata);
		
---	LFGShout.Dialogs.Advert.skilllist:SetValue(LFGShout.Dialogs.Advert.SelSkill);
		
---	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.skilllist)
--	LFGShout.Dialogs.Advert.skilllist:SetCallback("OnValueChanged", function(widget, event, key) LFGShout.Dialogs.Advert.SelSkill=key end)
	----Spacer
	LFGShout.Dialogs.Advert.spacer0 = LFGShout.Dialogs.GUI:Create("Heading")

	LFGShout.Dialogs.Advert.spacer0:SetText("Advert")
	LFGShout.Dialogs.Advert.spacer0:SetFullWidth(true)
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.spacer0)
	----LABEL/iNSTR
	LFGShout.Dialogs.Advert.lab02 = LFGShout.Dialogs.GUI:Create("Label")
	LFGShout.Dialogs.Advert.lab02:SetFont(tFontName,15,"")
	LFGShout.Dialogs.Advert.lab02:SetText("|cffC0E0FFDefine upto 2 lines of the advert below. Supported Macros are |cffFFF000#link:<spell id>#, #zone#, #ilvl#, #class#")
	LFGShout.Dialogs.Advert.lab02:SetFullWidth(true)
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.lab02)
	
	----Line 1
	LFGShout.Dialogs.Advert.txtLine1 = LFGShout.Dialogs.GUI:Create("EditBox")
	LFGShout.Dialogs.Advert.txtLine1:SetText(LFGShout.Dialogs.Advert.line1)
	LFGShout.Dialogs.Advert.txtLine1:SetFullWidth(true)
	LFGShout.Dialogs.Advert.txtLine1:DisableButton(true);
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtLine1)
	LFGShout.Dialogs.Advert.txtLine1:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.line1=text end)

	----Line 2
	LFGShout.Dialogs.Advert.txtLine2 = LFGShout.Dialogs.GUI:Create("EditBox")
	LFGShout.Dialogs.Advert.txtLine2:SetText(LFGShout.Dialogs.Advert.line2)
	LFGShout.Dialogs.Advert.txtLine2:SetFullWidth(true)
	LFGShout.Dialogs.Advert.txtLine2:DisableButton(true);
	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtLine2)
	LFGShout.Dialogs.Advert.txtLine2:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.line2=text end)
	
	----Line 3
	---LFGShout.Dialogs.Advert.txtLine3 = LFGShout.Dialogs.GUI:Create("EditBox")
	---LFGShout.Dialogs.Advert.txtLine3:SetText(LFGShout.Dialogs.Advert.line3)
	---LFGShout.Dialogs.Advert.txtLine3:SetFullWidth(true)
	----LFGShout.Dialogs.Advert.txtLine3:DisableButton(true);
	----LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtLine3)
	----LFGShout.Dialogs.Advert.txtLine3:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.line3=text end)
	
	----Line 4
	----LFGShout.Dialogs.Advert.txtLine4 = LFGShout.Dialogs.GUI:Create("EditBox")
	----LFGShout.Dialogs.Advert.txtLine4:SetText(LFGShout.Dialogs.Advert.line4)
	----LFGShout.Dialogs.Advert.txtLine4:SetFullWidth(true)
	----LFGShout.Dialogs.Advert.txtLine4:DisableButton(true);
	----LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtLine4)
	----LFGShout.Dialogs.Advert.txtLine4:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.line4=text end)
	
	----Line 5
	----LFGShout.Dialogs.Advert.txtLine5 = LFGShout.Dialogs.GUI:Create("EditBox")
	-----LFGShout.Dialogs.Advert.txtLine5:SetText(LFGShout.Dialogs.Advert.line5)
	-----LFGShout.Dialogs.Advert.txtLine5:SetFullWidth(true)
	-----LFGShout.Dialogs.Advert.txtLine5:DisableButton(true);
	-----LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.txtLine5)
	-----LFGShout.Dialogs.Advert.txtLine5:SetCallback("OnTextChanged", function(widget, event, text) LFGShout.Dialogs.Advert.line5=text end)
	
	
	
	----Test Message
	LFGShout.Dialogs.Advert.cmdTest = LFGShout.Dialogs.GUI:Create("Button")
	LFGShout.Dialogs.Advert.cmdTest:SetText("Test Advert")

	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.cmdTest)
	LFGShout.Dialogs.Advert.cmdTest:SetCallback("OnClick", function(widget, event) LFGShout.Dialogs.Advert:TestMessage() end)
	
	----Send
	LFGShout.Dialogs.Advert.cmdSend = LFGShout.Dialogs.GUI:Create("Button")
	LFGShout.Dialogs.Advert.cmdSend:SetText("Advertise")

	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.cmdSend)
	LFGShout.Dialogs.Advert.cmdSend:SetCallback("OnClick", function(widget, event) LFGShout.Dialogs.Advert:SendMessage() end)
	
	----Delete
	LFGShout.Dialogs.Advert.cmdDel = LFGShout.Dialogs.GUI:Create("Button")
	LFGShout.Dialogs.Advert.cmdDel:SetText("Delete")

	LFGShout.Dialogs.Advert.frame:AddChild(LFGShout.Dialogs.Advert.cmdDel)
	LFGShout.Dialogs.Advert.cmdDel:SetCallback("OnClick", function(widget, event) LFGShout.Dialogs.Advert:DelMessage() end)

	
end

function LFGShout.Dialogs.Advert:DelMessage()
	if #LFGShout_Global.MyAdverts<2 then
		LFGShout_Global.MyAdverts={}
	else
		tremove(LFGShout_Global.MyAdverts,LFGShout.Dialogs.Advert.AdvertIndex)
	end
	
	LFGShout.Dialogs.GUI:Release(LFGShout.Dialogs.Advert.frame);
	LFGShout.Dialogs.Advert.Active=false;
	
end

function LFGShout.Dialogs.Advert:TestMessage()
	LFGShout.Dialogs.Advert:SaveMessage()
	LFGShout.Advertise(LFGShout.Dialogs.Advert.AdvertIndex, true)
	
end

function LFGShout.Dialogs.Advert:SendMessage()
	LFGShout.Dialogs.Advert:SaveMessage()
	LFGShout.Advertise(LFGShout.Dialogs.Advert.AdvertIndex, false)
end


function LFGShout.Dialogs.Advert:SaveMessage()

	if (LFGShout.Dialogs.Advert.line1==nil or LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex]==nil) then
		return
	end

----Save Data to Globals
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[1]=LFGShout.Dialogs.Advert.line1;
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[2]=LFGShout.Dialogs.Advert.line2;
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[3]=LFGShout.Dialogs.Advert.line3;
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[4]=LFGShout.Dialogs.Advert.line4;
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].lines[5]=LFGShout.Dialogs.Advert.line5;
	
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].skill=LFGShout.Dialogs.Advert.SelSkill
	
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].cityshout=LFGShout.Dialogs.Advert.cityshout;
	
	if (LFGShout.Dialogs.Advert.AdvertName=="") then 
		LFGShout.Dialogs.Advert.AdvertName="<No Name>";
	end
	
	LFGShout_Global.MyAdverts[LFGShout.Dialogs.Advert.AdvertIndex].name=LFGShout.Dialogs.Advert.AdvertName;
	
end




---close Dialog
function LFGShout.Dialogs.Advert:OnClose()

	LFGShout.Dialogs.Advert:SaveMessage()
	
	LFGShout.Dialogs.GUI:Release(LFGShout.Dialogs.Advert.frame);
	LFGShout.Dialogs.Advert.Active=false;

end