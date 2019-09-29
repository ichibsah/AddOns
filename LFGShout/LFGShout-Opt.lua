
LFGShout.vars.filterOptions={a="Any",b="Low", c="Medium", d="High", e="Custom Only"}

LFGShout.config.AceConfig = {
    name = "LFG and Trade Shout",
    handler = nil,
    type = 'group',
    args = {
		a = {
            type = 'header',
            name = 'General Options',
			order=100,
            
        },
		
        aa = {
            type = 'toggle',
            name = 'Shout in chat',
            desc = 'Announce chat messages in chat?',
            set = function(info,val) LFGShout_Global.ChatShout=val end,
            get = function(info) return LFGShout_Global.ChatShout end,
			order=101,
        },
		
		 aa1 = {
            type = 'toggle',
            name = 'Shout Alert',
            desc = 'Announce chat in Error/Alert frame?',
            set = function(info,val) LFGShout_Global.ShowAlert=val end,
            get = function(info) return LFGShout_Global.ShowAlert end,
			order=101,
        },
		
		ab = {
            type = 'toggle',
            name = 'Show Trade',
            desc = 'Announce trade messages?',
            set = function(info,val) LFGShout_Global.ShowTrade=val end,
            get = function(info) return LFGShout_Global.ShowTrade end,
			order=102,
        },
		
		ac = {
            type = 'toggle',
            name = 'Show Guild Adverts',
            desc = 'Announce guild adverts?',
            set = function(info,val) LFGShout_Global.ShowGuild=val end,
            get = function(info) return LFGShout_Global.ShowGuild end,
			order=103,
        },
		
		ad = {
            type = 'toggle',
            name = 'Show LFG/Quest',
            desc = 'Announce LFG and Quest adverts?',
            set = function(info,val) LFGShout_Global.ShowLFG=val end,
            get = function(info) return LFGShout_Global.ShowLFG end,
			order=104,
        },
		
		ae = {
            type = 'toggle',
            name = 'Broadcast Adverts',
            desc = 'Broadcast local messages you recieve and watch for broadcasted message from other users?',
            set = function(info,val) LFGShout_Global.ForwardMessages=val end,
            get = function(info) return LFGShout_Global.ForwardMessages end,
			order=105,
        },
		
		b = {
            type = 'header',
            name = 'Filter Controls',
			order=200,
			
            
        },
		
		ba = {
            type = 'select',
            name = 'Filter Level',
            desc = 'Filter Level: See below.',
			style="dropdown",
			values=LFGShout.vars.filterOptions,
            set = function(info,val) LFGShout.config:SetFilterLevel(info, val) end,
            get = function(info) return LFGShout.config:GetFilterLevel(info) end,
			order=201,
        },
		bb = {
            type = 'description',
            name = '|cff00FFFFFilter Level:\n|cFFFFF000All|r - All messages matching a keyword\n|cFFFFF000Low|r - Most keyword hist will be shown\n|cFFFFF000Medium|r - Good level of matching\n|cFFFFF000High|r - Multi phrase matches only(e.g. LFM ICC10)\n|cFFFF0000Custom Only|r - Only the custom filters below will be evaluated.',
			fontSize='medium',
			order=202,
        },
		c = {
            type = 'header',
            name = 'Custom Filters',
			order=300,
			
            
        },
		
		ca = {
            type = 'description',
            name = '|cff00FFFFType a list of exact words you definitely want to include/exclude from the list.',
			fontSize='medium',
			order=301,
        },
		
		cb = {
            type = 'input',
			width="full",
            name = 'Include',
            desc = 'Type a list of words that will definietly be included in the list.  Separate each word with a semi-colon (;).',
            set = function(info,val) LFGShout.utils:SetCustomWhiteList(val) end,
            get = function(info) return LFGShout_Global.CustomWhiteList end,
			order=302,
		
		},
		cc = {
            type = 'description',
            name = 'N.B A louder alarm will be sounded when the words above are matched.',
			fontSize='medium',
			order=303,
        },
		cd = {
            type = 'input',
            name = 'Exclude',
			width="full",
            desc = 'Type a list of words that will definietly be excluded from the list.  Separate each word with a semi-colon (;).',
            set = function(info,val) LFGShout.utils:SetCustomBlackList(val) end,
            get = function(info) return LFGShout_Global.CustomBlackList end,
			order=304,
		
		},
		d = {
            type = 'header',
            name = 'Other Options',
			order=400,
			
            
        },
		
		da = {
            type = 'execute',
            name = 'Clear Advert List',
			desc="Clears the list of adverts",
			order=401,
			func = function(info) LFGShout.utils:ClearAdverts() end,
        },
		
		db = {
            type = 'execute',
            name = 'Statistics',
			desc = "Output statistics into the chat window.",
			order=402,
			func = function(info) LFGShout.utils:DisplayStats() end,
        },
		
		
	},
}

 LFGShout.config.AceOptionsTable= LibStub("AceConfig-3.0")

 LFGShout.config.AceOptionsTable:RegisterOptionsTable("LFGShout", LFGShout.config.AceConfig)
 LFGShout.config.AceDialog= LibStub("AceConfigDialog-3.0")
 LFGShout.config.AceDialog:AddToBlizOptions("LFGShout","LFG Shout")



function LFGShout.config:SetFilterLevel(info, val)
		LFGShout.utils:Debug(2,"Val:"..val);
		
	if (val=="a") then LFGShout_Global.FilterLevel=1;
	elseif (val=="b") then LFGShout_Global.FilterLevel=45;
	elseif (val=="c") then LFGShout_Global.FilterLevel=75;
	elseif (val=="d") then LFGShout_Global.FilterLevel=101;
	else LFGShout_Global.FilterLevel=999 end
	
end
function LFGShout.config:GetFilterLevel(info)
	if (LFGShout_Global.FilterLevel==1) then return "a" end
	if (LFGShout_Global.FilterLevel==45) then return "b" end
	if (LFGShout_Global.FilterLevel==75) then return "c" end
	if (LFGShout_Global.FilterLevel==101) then return "d" end
	return "e"
end