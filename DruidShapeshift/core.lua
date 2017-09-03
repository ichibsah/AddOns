-- ===================================================================
-- DruidShapeShift for tMorph
-- Twitch.TV/Wildlands -- Follow and Share
-- Configuration.
-- ===================================================================
	-- Setting the display ID to nil causes that form to not be affected;
	-- setting the scale to nil causes the scale to not be affected, even
	-- if the display ID is. The display ID is NOT the value found in a
	-- WoW Head URL, they must be ascertained separately.

	-- local FORM           = {DisplayID, Scale}
	-- local CAT_FORM       = {45042, 0.8} -- Cat form to Xuen at 0.8 scale.
	local CAT_FORM          = {43780, nil}
	local TREE_FORM         = {nil, nil}
	local TRAVEL_FORM       = {nil, nil}
	local AQUATIC_FORM      = {nil, nil}
	local BEAR_FORM         = {nil, nil}
	local FLIGHT_FORM       = {nil, nil} -- Doubles for Flight Form and Swift Flight Form.
	local MOONKINK_FORM     = {nil, nil}

-- ===================================================================
-- Core.
-- ===================================================================
	local eventHandler = CreateFrame("Frame", nil, UIParent)
	eventHandler:SetScript("OnEvent", function()
		-- Break out of the function if tMorph is not loaded.
		if (not tMorphLoaded) then return end

		-- http://wowpedia.org/API_GetShapeshiftFormID
		local ShapeShiftID = GetShapeshiftFormID()

		if (ShapeShiftID == 1) then
			-- Cat Form.
			if (CAT_FORM[1]) then
				SetDisplayID("player", CAT_FORM[1])
				if (CAT_FORM[2]) then SetScale("player", CAT_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 2) then
			-- Tree Form.
			if (TREE_FORM[1]) then
				SetDisplayID("player", TREE_FORM[1])
				if (TREE_FORM[2]) then SetScale("player", TREE_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 3) then
			-- Travel Form.
			if (TRAVEL_FORM[1]) then
				SetDisplayID("player", TRAVEL_FORM[1])
				if (TRAVEL_FORM[2]) then SetScale("player", TRAVEL_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 4) then
			-- Aquatic Form.
			if (AQUATIC_FORM[1]) then
				SetDisplayID("player", AQUATIC_FORM[1])
				if (AQUATIC_FORM[2]) then SetScale("player", AQUATIC_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 5) then
			-- Bear Form.
			if (BEAR_FORM[1]) then
				SetDisplayID("player", BEAR_FORM[1])
				if (BEAR_FORM[2]) then SetScale("player", BEAR_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 27) or (ShapeShiftID == 29) then
			-- Swift Flight Form or Flight Form.
			if (FLIGHT_FORM[1]) then
				SetDisplayID("player", FLIGHT_FORM[1])
				if (FLIGHT_FORM[2]) then SetScale("player", FLIGHT_FORM[2]) end

				UpdateModel("player")
			end
		elseif (ShapeShiftID == 31) then
			-- Moonkin Form.
			if (MOONKINK_FORM[1]) then
				SetDisplayID("player", MOONKINK_FORM[1])
				if (MOONKINK_FORM[2]) then SetScale("player", MOONKINK_FORM[2]) end

				UpdateModel("player")
			end
		end
	end)

	local _, playerClass = UnitClass("player")
	if (playerClass == "DRUID") then
		eventHandler:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
	end