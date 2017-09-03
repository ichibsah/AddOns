MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceConsole-3.0")

MyAddon:RegisterChatCommand("mythics", "MythicTracker")
MyAddon:RegisterChatCommand("mythic", "MythicTracker")

function MyAddon:MythicTracker()
	for i=1,GetNumSavedInstances() 
		do local n,_,_,d,l = GetSavedInstanceInfo(i) 
	
		if d==23 
			then print(n,l and "\124cff00ff00Locked" or "\124cffff0000Unlocked") 
		end 	
	
	end
end