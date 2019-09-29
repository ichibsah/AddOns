--Author      : LintyDruid
--Localisation Control


function LFGShout.lang.Set(language)
	 LFGShout.lang:Init(language);
end

function LFGShout.lang:Init(language)
	if (language== nil) then
		language = GetLocale();
	end
	
	LFGShout_Locale_English(); --- Init English as default
	
	--Apply local overlay
	if (language=="deDE") then
		LFGShout_Locale_German();
		LFGShout.utils:Chat("Language set to German ("..language..")");
	elseif (language=="esES") then
		LFGShout_Locale_Spanish();
		LFGShout.utils:Chat("Language set to Spanish ("..language..")");
	elseif (language=="frFR") then
		LFGShout_Locale_French();
		LFGShout.utils:Chat("Language set to French ("..language..")");
	elseif (language=="koKR") then
		LFGShout_Locale_Korea();
		LFGShout.utils:Chat("Language set to Korean ("..language..")");
	elseif (language=="zhCN") then
		LFGShout_Locale_China();
		LFGShout.utils:Chat("Language set to Chinese ("..language..")");
	elseif (language=="zhTW") then
		LFGShout_Locale_Taiwan();
		LFGShout.utils:Chat("Language set to Taiwanese("..language..")");
	else
		LFGShout.utils:Chat("Language set to English ("..language..")");
	end
	
	--Refresh screens, etc
	LFGShout.lang:Refresh();
	
	
end

function LFGShout.lang.Refresh()

	---Set Options Window Text
	
	
	


	
end
