-- Setup required stuff

	-- Create a burning sound loop
	local burning = 0

	-- Create the countdown vairable
	local timey = 0

	-- Create varriables needed to check for buffs
	local n,s,_

	-- Create a binary varriable to determine if you have a bloodlust or not
	local bloodlust,bloodlustbefore = 0

	-- Create a binary varriable to determine if you have a speedboost or not
	local dash,dashbefore = 0

	-- Create a binary varriable to determine if you have [Tiger's Fury] or not
	local tigersfury,tigersfurybefore = 0

	-- Create a binary varriable to determine if you have [survival Instincts] or not
	local survival,survivalbefore = 0

	-- Create a binary varriable to determine if you have [Bristling Fur] or not
	local bristling,bristlingbefore = 0

	-- Create a binary varriable to determine if you have [Savage Defense] or not
	local savage,savagebefore = 0

	-- Create a binary varriable to determine if you have [Burning Essence] or not
	local burningessence,burningessencebefore = 0

	-- Create the sound function
	local frame = CreateFrame("FRAME", "FireDruid")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:RegisterEvent("PLAYER_DEAD")


-- The function that plays the sound
local function eventHandler(self, event, ...)
if (UnitClass("player")) == "Druid" then

	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)


	-- Play a random Fandal/Druid of the Flame sound when you and only YOU have died
	if ( (event == "PLAYER_DEAD") and (timey <= 0)) then
		-- Check the player's gender, then play the appropriate voice-over
		if (UnitSex("player") == 3) then
			PlaySoundFile(GetRandomArgument("Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_WOUNDCRIT01.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_WOUNDCRIT02.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_WOUNDCRIT03.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_WOUNDCRIT04.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_WOUNDCRIT05.ogg","Sound/creature/Corla/VO_BC_Corla_Event04.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_DEATH.ogg"), "Master")
		else
			PlaySoundFile(GetRandomArgument("Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_DEATH.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_WOUNDCRIT01.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_WOUNDCRIT02.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_WOUNDCRIT03.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_WOUNDCRIT04.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_WOUNDCRIT05.ogg"), "Master")
		end
		-- Set the countdown to 5 seconds before anouther sound can be played
		timey = 5

	end

	-- Play a random Fandal/Druid of the Flame sound when you and only YOU kill something
	if ( (sourceName == UnitGUID("player")) and (type == "PARTY_KILL") and (timey <= 0)) then
		-- Check the player's gender, then play the appropriate voice-over
		if (UnitSex("player") == 3) then
			PlaySoundFile(GetRandomArgument("Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_KILL_01.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_KILL_02.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_LAUGH_01.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_LAUGH_02.ogg","","","",""), "Master")
		else
			PlaySoundFile(GetRandomArgument("Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_KILL_01.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_KILL_02.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_KILL_03.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_KILL_04.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_KILL_05.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_LAUGH01.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_LAUGH02.ogg","","","","","","",""), "Master")
		end
		-- Set the countdown to 5 seconds before anouther sound can be played
		timey = 5

	end


	-- Check buffs before playing sounds
		bloodlust = 0
		dash = 0
		tigersfury = 0
		survival = 0
		bristling = 0
		savage = 0
		burningessence = 0
		for i=1,40 do n,_,_,_,_,_,_,_,s=UnitAura("player",i)

			-- Count the number of bloodlusts present
				if ((n == "Berserk") or (n == "Incarnation: King of the Jungle") or (n == "Bloodlust") or (n == "Heroism") or (n == "Time Warp") or (n == "Ancient Hysteria") or (n == "Drums of Fury")) then
				bloodlust = bloodlust + 1
				end
	
			-- Count the number of speed boosts present
				if ((n == "Dash") or (n == "Nitro Boosts") or (n == "Stampeding Roar") or (n == "Darkflight") or (n == "Speed") or (n == "Draenic Swiftness Potion") or (n == "Swim Speed") or (n == "Darkwater Potion")) then
					dash = dash + 1
				end

			-- Count the number of [Tiger's Fury] present
				if (n == "Tiger's Fury") then
					tigersfury = tigersfury + 1
				end

			-- Count the number of [Survival Instincts] present
				if (n == "Survival Instincts") then
					survival = survival + 1
				end

			-- Count the number of [Bristling Fur] present
				if (n == "Mark of Ursol") then
					bristling = bristling + 1
				end

			-- Count the number of [Savage Defense] present
				if (n == "Ironfur") then
					savage = savage + 1
				end

			-- Count the number of [Burning Essence] present
				if (n == "Burning Essence") then
					burningessence = burningessence + 1
				end
		end
	

	-- If no other sound has been played within 5 seconds and you just got a DPS buff, play an 'enrage' RP sound
	-- Otherwise, reset the 'before' variable to zero
		if ((bloodlust > 0) and (bloodlustbefore == 0) and (timey <= 0)) then
			bloodlustbefore = 1
			timey = 5
			-- Check the player's gender, then play the appropriate voice-over
			if (UnitSex("player") == 3) then
				PlaySoundFile(GetRandomArgument("Sound/creature/Azil/VO_SC_Azil_Aggro01.ogg","Sound/creature/FlameDruidFemale/VO_FL_FLAME_DRUID_FEMALE_ALYSRAZOR_ATTACK_01.ogg","Sound/creature/FlameDruidFemale/VO_FL_FLAME_DRUID_FEMALE_ALYSRAZOR_ATTACK_02.ogg","Sound/creature/FlameDruidFemale/VO_FL_FLAME_DRUID_FEMALE_ALYSRAZOR_ATTACK_03.ogg","Sound/creature/FlameDruidFemale/VO_FL_FLAME_DRUID_FEMALE_ALYSRAZOR_ATTACK_04.ogg"), "Master")
			else
				PlaySoundFile(GetRandomArgument("Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_TIGER_TRANSFORM.ogg","Sound/creature/FlameDruidMale/VO_FL_FLAME_DRUID_MALE_ALYSRAZOR_ATTACK_01.ogg","Sound/creature/FlameDruidMale/VO_FL_FLAME_DRUID_MALE_ALYSRAZOR_ATTACK_02.ogg","Sound/creature/FlameDruidMale/VO_FL_FLAME_DRUID_MALE_ALYSRAZOR_ATTACK_03.ogg","Sound/creature/FlameDruidMale/VO_FL_FLAME_DRUID_MALE_ALYSRAZOR_ATTACK_04.ogg"), "Master")
			end

		end
		if (bloodlust == 0) then
			bloodlustbefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got a speed boost, play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((dash > 0) and (dashbefore == 0) and (timey <= 0) and (random() > 0.5)) then
			dashbefore = 1
			timey = 5
			-- Check the player's gender, then play the appropriate voice-over
			if (UnitSex("player") == 3) then
				PlaySoundFile(GetRandomArgument("Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_KILL_01.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_KILL_02.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_TRANSITION_02.ogg"), "Master")
			else
				PlaySoundFile(GetRandomArgument("Sound/creature/FlameDruidMale/VO_FL_FLAME_DRUID_MALE_ALYSRAZOR_METEOR_01.ogg","Sound/creature/FandralFlameDruid/VO_FL_FANDRAL_FIREBIRD_TRANSFORM.ogg"), "Master")
			end
		end
		if (dash == 0) then
			dashbefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got [Tiger's Fury], play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((tigersfury > 0) and (tigersfurybefore == 0) and (timey <= 0)) then
			tigersfurybefore = 1
			timey = 5
			PlaySoundKitID((26952),"Master")
		end
		if (tigersfury == 0) then
			tigersfurybefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got [Survival Instincts], play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((survival > 0) and (survivalbefore == 0) and (timey <= 0)) then
			survivalbefore = 1
			timey = 5
			if (GetShapeshiftForm() == 1) then
				-- Bear Form version
				PlaySoundKitID((477),"Master")
			else
				-- Cat Form version
				PlaySoundKitID((26958),"Master")
			end
		end
		if (survival == 0) then
			survivalbefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got [Bristling Fur], play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((bristling > 0) and (bristlingbefore == 0) and (timey <= 0)) then
			bristlingbefore = 1
			timey = 5
			PlaySoundKitID((473),"Master")
		end
		if (bristling == 0) then
			bristlingbefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got [Savage Defense], play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((savage > 0) and (savagebefore == 0) and (timey <= 0)) then
			savagebefore = 1
			timey = 5
			PlaySoundKitID((476),"Master")
		end
		if (savage == 0) then
			savagebefore = 0
		end


	-- If no other sound has been played within 5 seconds and you just got [Burning Essence], play a sound
	-- Otherwise, reset the 'before' variable to zero
		if ((burningessence > 0) and (burningessencebefore == 0) and (timey <= 0)) then
			burningessencebefore = 1
			timey = 5
			-- Check the player's gender, then play the appropriate voice-over
			if (UnitSex("player") == 3) then
				PlaySoundFile(GetRandomArgument("Sound/creature/Azil/VO_SC_Azil_Aggro01.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_AGGRO.ogg","Sound/creature/ALYSRAZOR/VO_FL_ALYSRAZOR_TRANSITION_02.ogg"), "Master")
			else
				PlaySoundKitID(GetRandomArgument(24808,24809,24483),"Master")
			end
		end
		if (burningessence == 0) then
			burningessencebefore = 0
		end

end
end




-- The function that runs the delay in between sounds
local function timeycountdown(self,elapsed)
if (UnitClass("player")) == "Druid" then

	-- Start and propogate the burning sound loop
	if (burning == 10) then
		burning = 1
		PlaySoundKitID((32979),"Master")
	end

	if (timey > 0) then
		timey = timey - elapsed
	end

end
end



-- Run the function

frame:SetScript("OnEvent", eventHandler);
frame:SetScript("OnUpdate", timeycountdown);
