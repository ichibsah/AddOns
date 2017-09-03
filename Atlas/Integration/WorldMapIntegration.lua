-- $Id: WorldMapIntegration.lua 253 2017-05-25 07:22:48Z arith $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert at gmail dot com>
	Copyright 2010 - Lothaer <lothayer at gmail dot com>, Atlas Team
	Copyright 2011 ~ 2017 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

-- Atlas WorldMap Integration
-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs, tonumber = _G.pairs, _G.tonumber
-- Libraries

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("Atlas")

local function Atlas_AutoSelect_from_WorldMap()
	local mapID, _ = GetCurrentMapAreaID();
	local dungeonLevel = GetCurrentMapDungeonLevel();
	local profile = addon.db.profile;
	
	if (not mapID) then
		return;
	end

	for type_k, type_v in pairs(ATLAS_DROPDOWNS) do
		for zone_k, zone_v in pairs(type_v) do
			local AtlasWorldMapID = tonumber(AtlasMaps[zone_v].WorldMapID);
			local AtlasMapDungeonLevel = tonumber(AtlasMaps[zone_v].DungeonLevel);
			local AtlasMapFaction = AtlasMaps[zone_v].Faction;
			if (AtlasWorldMapID and AtlasWorldMapID == mapID) then
				if (AtlasMapFaction and AtlasMapFaction == ATLAS_PLAYER_FACTION) then
					profile.options.dropdowns.module = type_k;
					profile.options.dropdowns.zone = zone_k;
				else
					if (dungeonLevel > 0 and AtlasMapDungeonLevel) then
						if (AtlasMapDungeonLevel == dungeonLevel) then
							profile.options.dropdowns.module = type_k;
							profile.options.dropdowns.zone = zone_k;
						end
					else
						profile.options.dropdowns.module = type_k;
						profile.options.dropdowns.zone = zone_k;
					end
				end
				Atlas_Refresh();
				return;
			end
		end
	end
end

function AtlasToggleFromWorldMap_OnClick(self)
	Atlas_AutoSelect_from_WorldMap();
	ToggleFrame(WorldMapFrame);
	Atlas_Toggle();
end

