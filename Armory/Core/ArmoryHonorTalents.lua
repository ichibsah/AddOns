--[[
    Armory Addon for World of Warcraft(tm).
    Revision: 5da12e4bc1d7b3aa1322947ce253f0fe7f8895c7 2016-11-25T3:11:39Z
    URL: http://www.wow-neighbours.com

    License:
        This program is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License
        as published by the Free Software Foundation; either version 2
        of the License, or (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program(see GPL.txt); if not, write to the Free Software
        Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

    Note:
        This AddOn's source code is specifically designed to work with
        World of Warcraft's interpreted AddOn system.
        You have an implicit licence to use this AddOn with these facilities
        since that is it's designated purpose as per:
        http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

local Armory, _ = Armory;
local container = "HonorTalents";

----------------------------------------------------------
-- Talents Storage
----------------------------------------------------------

function Armory:HonorTalentsExists()
    local dbEntry = self.playerDbBaseEntry;
    return dbEntry and dbEntry:Contains(container);
end

function Armory:ClearHonorTalents()
    self:ClearModuleData(container);
end

function Armory:SetHonorTalents()
    local dbEntry = self.playerDbBaseEntry;
    
    if ( not dbEntry ) then
        return;
    elseif ( not self:PVPEnabled() or _G.UnitLevel("player") < SHOW_PVP_TALENT_LEVEL ) then
        dbEntry:SetValue(container, nil);
        return;
    end
    
    if ( not self:IsLocked(container) ) then
        self:Lock(container);

        self:PrintDebug("UPDATE", container);
    
        local activeTalentGroup = _G.GetActiveSpecGroup() or 1;
		for tier = 1, MAX_PVP_TALENT_TIERS do
			for column = 1, MAX_PVP_TALENT_COLUMNS do
				local id, _, _, selected, available = _G.GetPvpTalentInfo(tier, column, activeTalentGroup);
				dbEntry:SetValue(3, container, tier, column, id, selected, available);
			end
		end

        dbEntry:SetValue(2, container, "Unspent", _G.GetNumUnspentPvpTalents());
        
        self:Unlock(container);
    else
        self:PrintDebug("LOCKED", container);
    end
end

----------------------------------------------------------
-- Talents Interface
----------------------------------------------------------
 
function Armory:GetNumUnspentPvpTalents()
	local dbEntry = self.selectedDbBaseEntry;
	return (dbEntry and dbEntry:GetValue(container, "Unspent")) or 0;
end

function Armory:GetPvpTalentInfo(tier, column, talentGroup)
	local dbEntry = self.selectedDbBaseEntry;
	if ( dbEntry ) then
		local id, selected, available = dbEntry:GetValue(container, tier, column);
        local name, iconTexture;
        if ( id ) then
            _, name, iconTexture = GetPvpTalentInfoByID(id);
        end
	    return id, name, iconTexture, selected, available;
	end
end
