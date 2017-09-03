--[[

Author: Trelis @ Proudmoore
(shamanfriend (a) stassart o org)

Original Author: Glyph @ EU-Sylvanas (2007-2009)

See info.txt for more information

Copyright 2009-2012 Benjamin Stassart

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]

-- Disable ShamanFriend if the player is not a shaman
if select(2, UnitClass('player')) ~= "SHAMAN" then
	DisableAddOn("ShamanFriend")
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("ShamanFriend")
local AceAddon = LibStub("AceAddon-3.0")
ShamanFriend = AceAddon:NewAddon("ShamanFriend", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")

local LSM = LibStub("LibSharedMedia-3.0")

local meta_version = GetAddOnMetadata("ShamanFriend","Version")
local revision = GetAddOnMetadata("ShamanFriend","X-Curse-Packaged-Version")
ShamanFriend.version = ("v%s-%s"):format(meta_version, revision)

-- Add configmode support (i.e. OneButtonConfig)
-- Create the global table if it does not exist yet
CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
-- Declare our handler
CONFIGMODE_CALLBACKS["ShamanFriend"] = function(action)
	if action == "ON" then
		ShamanFriend.configMode = true
		ShamanFriend:UpdateLock()
	elseif action == "OFF" then
		ShamanFriend.configMode = false
		ShamanFriend:UpdateLock()
	end
end

-- Default Options for ShamanFriend
ShamanFriend.defaults = {
   profile = {
	alert = {
		shield = true,
		readycheck = true,
		entercombat = true,
		aftercombat = false,
		mounted = true,
		vehicle = true,
		sound = "None",
		-- maelstrom = false,
		-- maelstacks = 5,
		surge = false,
		-- fulmination = false,
		-- fulmstacks = 0,
		proc_sound = "None",
		display = {
			color = { r=1, g=1, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	spell = {
		purge = true,
		purgemsg = "none",
		interrupt = false,
		interruptmsg = "none",
		ground = false,
		groundself = true,
		groundmsg = "none",
		target = false,
		bloodlust = false,
		bloodlusttext = "SPELL UP! Now go pewpew!",
		bloodlustchat = "SAY",
		spiritlink = false,
		spiritlinktext = "SPELL robs from the rich and gives to the poor!",
		spiritlinkchat = "SAY",
		healtide = false,
		healtidetext = "SPELL Magic Healing Stick!",
		healtidechat = "SAY",
		feralspirit = false,
		feralspirittext = "SPELL! Who let the dogs out?",
		feralspiritchat = "SAY",
		dispel = false,
		dispelmsg = "none",
		display = {
			color = { r=1, g=0.5, b=0.7 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	display = {
		chat = false,
		number = 0,
		screen = false,
		frame = true,
		fontSize = 18,
		fontFace = L["Friz Quadrata TT"], -- Default font
		fontEffect = L["OUTLINE"],
		lock = true,
		bgannounce = "none",
		arenaannounce = true,
		partyannounce = true,
		raidannounce = true,
		worldannounce = false,
	},
	wf = {
		enable = true,
		crit = true,
		miss = false,
		hand = false,
		lavalash = false,
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	lo = {
		enable = true,
		crit = false,
		damage = false,
		miss = false,
		-- fulmination = false,
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	eshield = {
		enable = false,
		lock = false,
		notooltip = false,
		button = false,
		bgcolor = true,
		flash = false,
		readycheck = true,
		entercombat = true,
		aftercombat = false,
		alert = true,
		sound = "None",
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	cc = {
		success = false,
		successtext = "SF: TARGET has SPELL Don't break it!",
		fail = false,
		failtext = "SF: SPELL failed on TARGET: ",
		remove = false,
		removetext = "SF: TARGET no longer has SPELL!",
		ccchat = "none",
		broken = true,
		brokentext = "SF: SOURCE broke SPELL on TARGET: ",
		brokenchat = "none",
		tanktime = 10,
		sound = "None",
		display = {
			color = { r=0.3, g=1, b=0.1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	--[[totem = {
		kill = false,
		killmsg = "none",
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},]]
	-- Pre-WoD set bonuses are disabled in Legion
	-- misc = {
	-- 	elet5 = false,
	-- 	enht5 = false,
	-- 	restot5 = false,
	-- 	display = {
	-- 		color = { r=0.7, g=1, b=0.7 },
	-- 		scroll = false,
	-- 		frames = true,
	-- 		time = 5,
	-- 	},
	-- },
	soundchannel = "Master",
   }
}

-- Sounds for alerts
-- local sounds = {
-- 	ding = "Sound\\Doodad\\BellTollAlliance.ogg",
-- 	dong = "Sound\\Doodad\\BellTollHorde.ogg",
-- 	bell = "AuctionWindowClose",
-- 	dodo = "igQuestFailed",
-- }
LSM:Register(LSM.MediaType.SOUND, L["Ding"], "Sound\\Doodad\\BellTollAlliance.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Dong"], "Sound\\Doodad\\BellTollHorde.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Bell"], "Sound\\interface\\AuctionWindowClose.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Dodo"], "Sound\\interface\\igQuestFailed.ogg")

local wf_str
local wf_guid
local wf_hand
local wf_cnt = 0
local wf_crit = 0
local wf_miss = 0
local wf_over = 0
local wf_dmg = 0
local fs_target, fs_cnt
local time = 0
local lo_str
local lo_c = 0
local lo_hit = 0
local lo_crit = 0
local lo_miss = 0
local lvb_hit = 0
local lvb_crit = 0
local eb_hit = 0
local eb_crit = 0
local cl_cnt = 0
local fulm_hit = 0
local fulm_crit = 0
local fulm_miss = 0
local eshield_target = "-"
local eshield_count
local eshield_id
local eshield_lockdown = false
local eshield_oldtarget
local eshield_casttarget
local mw_count = 0
local sear_count = 0
local ls_id
local ls_count = 0
local isl_id
local fulm_alertstacks

local trackedEvents = {}
local DelayedUnitUpdate = false

-- Lightning Bolt
local lb_ids = {
	-- Resto
	-- [403] = true
	-- Enh
	-- [187837] = true
	-- Ele
	[188196] = true
}

-- Lightning Bolt Overload
local lb_ol_ids = {
	[45284] = true
}

-- Lava Burst
local lvb_ids = {
	-- Ele/Resto
	[51505] = true
}

-- Lava Burst Overload
local lvb_ol_ids = {
	[77451] = true
}

-- Elemental Blast
local eb_ids = {
	-- Ele
	[117014] = true
}

-- Elemental Blast Overload
local eb_ol_ids = {
	[120588] = true
}

-- Chain Lightning
local cl_ids = {
	-- Resto
	-- [421] = true
	-- Ele
	[188443] = true
}

-- Chain Lightning Overload
local cl_ol_ids = {
	[45297] = true
}

-- Removed in Legion
-- local fulm_ids = {
-- 	[190493] = true
-- }

-- Removed in Legion
-- local isl_ids = {
-- 	[157774] = true
-- }

local es_ids = {
	-- Ele
	[8042] = true
}

-- Earth Shield is now a PvP talent
local eshield_ids = {
 	[204288] = true
}

-- Lightning shield is now an Enh talent
local ls_ids = {
	-- Enh
 	[192106] = true
}

local interrupt_ids = {
	-- Wind Shear (Ele/Enh/Resto)
	[57994] = true
}

local dispel_ids = {
	-- Cleanse Spirit (Ele/Enh)
	[51886] = true,
	-- Purify Spirit (Resto)
	[77130] = true,
}

local cc_ids = {
	-- Hex
	[51514] = true,
}

-- CC's that can overwrite shaman CC's
-- Or CC's that can be combined with shaman CC so that if
-- these are still up the mob is not lose and there is no need to alert
-- other players
-- Including other shaman's CC's
-- Not including stuff like Blind and Scatter Shot as they are short duration
local allcc_ids = {
	-- Banish
	[710] = true,
	-- Fear
	[5782] = true,
	-- Freezing Trap (Effect)
	[3355] = true,
	-- Hex
	[51514] = true,
	-- Polymorph
	[118] = true,
	-- Polymorph: Black Cat
	[61305] = true,
	-- Polymorph: Pig
	[28272] = true,
	-- Polymorph: Rabbit
	[61721] = true,
	-- Polymorph: Turkey
	[61780] = true,
	-- Polymorph: Turtle
	[28271] = true,
	-- Repentance
	[20066] = true,
	-- Sap
	[6770] = true,
}

local hex_ids = {
	-- Hex
	[51514] = true
}

-- Spell ids for Spell Names
-- This is used to get localized names for spells
-- Lots of Legion changes here
local name_ids = {
	["Lightning Shield"] = 192106,
	["Purge"] = 370,
	["Earth Shield"] = 204288,
	["Bloodlust"] = 2825,
	["Grounding Totem"] = 204336,
	["Heroism"] = 32182,
	["Feral Spirit"] = 51533,
	-- ["Water Shield"] = 52127,
	["Maelstrom Weapon"] = 187880,
	["Lava Lash"] = 60103,
	["Lava Surge"] = 77762,
	["Windfury"] = 78147,-- This isn't the shaman spell "Windfury Weapon"
	["Fulmination"] = 190493,
	["Spirit Link Totem"] = 98008,
	["Healing Tide Totem"] = 108280,
}

-- Which Raid difficulties to put to instance chat instead of raid chat
-- diff_index:
-- 0 - None; not in an Instance.
-- 1 - 5-player Instance.
-- 2 - 5-player Heroic Instance.
-- 3 - 10-player Raid Instance.
-- 4 - 25-player Raid Instance.
-- 5 - 10-player Heroic Raid Instance.
-- 6 - 25-player Heroic Raid Instance.
-- 7 - 25-player LFR
-- 8 - 5-player challenge mode
-- 9 - 40-player Raid Instance.
-- 10 - Not used.
-- 11 - Heroic Scenario Instance.
-- 12 - Scenario Instance.
-- 13 - Not used.
-- 14 - Flexible Raid.
-- 15 - Flexible Heroic Raid.
-- 16 - 20-player Mythic
-- 17 - Flexible LFR
-- 18 - 40-player event raid (level 100 version of Molten Core)
-- 19 - 5-player event (level 90 version of UBRS)
-- 20 - 25-player event (unknown)
-- 21 - not used
-- 22 - not used
-- 23 - Mythic 5-player
-- 24 - Timewalker 5-player
local raid_ic_ids = {
	-- 25-player LFR
	[7] = true,
	-- Flexible Raid
	-- [14] = true,
	-- Flexible Heroic Raid
	-- [15] = true,
	-- Flexible LFR
	[17] = true,
}

ShamanFriend.lN = {
	["Lightning Shield"] = GetSpellInfo(name_ids["Lightning Shield"]),
	["Purge"] = GetSpellInfo(name_ids["Purge"]),
	["Earth Shield"] = GetSpellInfo(name_ids["Earth Shield"]),
	["Bloodlust"] = GetSpellInfo(name_ids["Bloodlust"]),
	["Grounding Totem"] = GetSpellInfo(name_ids["Grounding Totem"]),
	["Heroism"] = GetSpellInfo(name_ids["Heroism"]),
	["Feral Spirit"] = GetSpellInfo(name_ids["Feral Spirit"]),
	-- ["Water Shield"] = GetSpellInfo(name_ids["Water Shield"]),
	["Maelstrom Weapon"] = GetSpellInfo(name_ids["Maelstrom Weapon"]),
	["Lava Lash"] = GetSpellInfo(name_ids["Lava Lash"]),
	["Lava Surge"] = GetSpellInfo(name_ids["Lava Surge"]),
	["Windfury"] = GetSpellInfo(name_ids["Windfury"]),
	["Fulmination"] = GetSpellInfo(name_ids["Fulmination"]),
	["Spirit Link Totem"] = GetSpellInfo(name_ids["Spirit Link Totem"]),
	["Healing Tide Totem"] = GetSpellInfo(name_ids["Healing Tide Totem"]),
}

local lN = ShamanFriend.lN

ShamanFriend.Wf = 0
ShamanFriend.Wf_miss = 0
ShamanFriend.Wf_crit = 0

-- Handle some of the MoP changes

function ShamanFriend:IsSolo()
	return (GetNumGroupMembers() == 0)
end

-- Bug in MoP where you are not in range of yourself when not in a group
function ShamanFriend:InRange(unit)
	if (self:IsSolo() and (unit == "player" or unit == UnitName("player") or
			unit == "pet")) then
		-- Always in range of self
		-- May not be in range of pet, but better to assume yes than assume no
		return true
	else
		return UnitInRange(unit)
	end
end

-- In MoP when solo you aren't in your own party anymore
function ShamanFriend:UInParty(unit)
	if (self:IsSolo() and (unit == "player" or unit == UnitName("player") or
			unit == "pet")) then
		-- Player and pet are always in party with self
		return true
	else
		return UnitInParty(unit)
	end
end

function ShamanFriend:OnInitialize()
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	self.db = LibStub("AceDB-3.0"):New("ShamanFriendDB", ShamanFriend.defaults, "profile")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ShamanFriend",
		ShamanFriend.options, {"shamanfriend", "sf"} )
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("ShamanFriend","ShamanFriend")
	self.db:RegisterDefaults(self.defaults)
		
	-- self:RegisterChatCommand({"/sfcl"}, options)
	self:Print(self.version.." Loaded.")
	self:Print("Use /sf for options.")
	self.announce = true
	self.zonetype = "none"
	self.configMode = false
	self:Upgrade()

	self:InitializeEarthShield()
	self:InitializeShield()
	self:InitializeCC()
	-- self:GetLocaleSpells()

	self:RegisterSink("SF", "ShamanFriend", nil, "SinkPrint")

end

function ShamanFriend:Upgrade()
	-- Always localize sounds
	-- If a sound gets translated, we want the non-translated stored setting
	-- to get updated.
	-- The only thing this won't address is if a translation gets changed
	self.db.profile.alert.sound = self:UpgradeSound(self.db.profile.alert.sound)
	self.db.profile.alert.proc_sound = self:UpgradeSound(self.db.profile.alert.proc_sound)
	self.db.profile.eshield.sound = self:UpgradeSound(self.db.profile.eshield.sound)
	self.db.profile.cc.sound = self:UpgradeSound(self.db.profile.cc.sound)

	if self.db.profile.version then
		self.db.profile.version = meta_version
		return
	end

	-- Fix configuration options that have changed
	if self.db.profile.display.fontFace == "FRIZQT__.TTF" then
		self.db.profile.display.fontFace = "Friz Quadrata TT"
	elseif self.db.profile.display.fontFace == "ARIALN.TTF" then
	 	self.db.profile.display.fontFace = "Arial Narrow"
	elseif self.db.profile.display.fontFace == "skurri.ttf" then
	 	self.db.profile.display.fontFace = "Skurri"
	elseif self.db.profile.display.fontFace == "MORPHEUS.ttf" then
	 	self.db.profile.display.fontFace = "Morpheus"
	elseif self.db.profile.display.fontFace == "2002.ttf" then
		self.db.profile.display.fontFace = "2002"
	end

	self.db.profile.version = meta_version
end

-- This both upgrades the old settings to the new
-- and it updates if a sound gets translated
function ShamanFriend:UpgradeSound(sound)
	local lsound = string.lower(sound)
	if lsound == "none" then
		return "None"
	elseif lsound == "ding" then
		return L["Ding"]
	elseif lsound == "dong" then
		return L["Dong"]
	elseif lsound == "dodo" then
		return L["Dodo"]
	elseif lsound == "bell" then
		return L["Bell"]
	else
		return sound
	end
end

function ShamanFriend:OnEnable()
	-- self:Print("OnEnable")
	self:LoadEvents()
end

function ShamanFriend:OnDisable()
	self:UnregisterAllEvents()
end

function ShamanFriend:InitializeEarthShield()
	self.eshield = {}
	self.eshield = {
		enabled = false,
		TimerEvent = nil,
		elapsed = 0,
		flashing = false,
	}
end

function ShamanFriend:InitializeShield()
	self.shield = {}
	self.shield = {
		enabled = false,
		name = nil,
	}
end

function ShamanFriend:InitializeCC()
	self.cc = {}
	self.cc = {
		removetarget = nil,
		removetime = nil,
	}
	self.hex = {}
	self.hex = {
		enabled = false,
		target = nil,
		dead = false,
		lasttarget = nil,
		time = 0,
		expiration = 0,
		breaksource = nil,
		breakspell = nil,
	}
	self.checkcc = {}
	self.NameToID = {}
end


-- function ShamanFriend:ShowUI()
--	waterfall:Open("ShamanFriend")
-- end

function ShamanFriend:LoadEvents()
	self:UnregisterAllEvents()
	
	trackedEvents = {}
	-- Check for Earth Shield talent
	ShamanFriend:FindEshieldId();
	-- Check for Lightning Shield talent
	ShamanFriend:FindLshieldId();
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	-- Detect talent spec change
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	-- Ready Check
	-- if self.db.profile.alert.readycheck or self.db.profile.eshield.readycheck then
	if (self.db.profile.alert.readycheck and ls_id) or
	   (self.db.profile.eshield.readycheck and eshield_id) then
	 	self:RegisterEvent("READY_CHECK")
	end
	
	-- Enter combat
	-- if self.db.profile.alert.entercombat or self.db.profile.eshield.entercombat then
	if (self.db.profile.alert.entercombat and ls_id) or
	   (self.db.profile.eshield.entercombat and ls_id) then
	 	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	-- After combat
	if (self.db.profile.alert.aftercombat and ls_id) or
	   (self.db.profile.eshield.enable and eshield_id) or
	    self.db.profile.cc.broken then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	-- Disable announces when in battlegrounds
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	ShamanFriend:ZoneCheck();
	
	-- Shield
	-- if self.db.profile.alert.shield and ls_id then
	-- 	trackedEvents["SPELL_AURA_REMOVED"] = true
	-- end
	
	-- Wf
	if self.db.profile.wf.enable then
		trackedEvents["SWING_DAMAGE"] = true
		trackedEvents["SWING_MISSED"] = true
		trackedEvents["SPELL_DAMAGE"] = true
		trackedEvents["SPELL_MISSED"] = true
		--trackedEvents["UNIT_DIED"] = true
	end
	
	-- LO
	-- if self.db.profile.lo.enable or self.db.profile.lo.fulmination then
	if self.db.profile.lo.enable  then
		trackedEvents["SPELL_DAMAGE"] = true
		trackedEvents["SPELL_MISSED"] = true
		trackedEvents["SPELL_CAST_SUCCESS"] = true
	end
	
	-- BL
	if self.db.profile.spell.bloodlust then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
	
	-- Earth Shield tracker
	if self.db.profile.eshield.enable and eshield_id then
		-- trackedEvents["SPELL_AURA_APPLIED"] = true
		-- trackedEvents["SPELL_AURA_REMOVED"] = true
		trackedEvents["SPELL_HEAL"] = true
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterEvent("UNIT_SPELLCAST_SENT")
	end
	
	-- Set bonus
	-- Pre WoD set bonuses are disabled in Legion
	-- if self.db.profile.misc.elet5 or self.db.profile.misc.enht5 or self.db.profile.misc.restot5 then
	-- 	trackedEvents["SPELL_AURA_APPLIED"] = true
	-- end
	
	-- Purge
	if self.db.profile.spell.purge or self.db.profile.spell.dispel then
		trackedEvents["SPELL_DISPEL"] = true
	end
	
	-- Ground
	if self.db.profile.spell.ground then
		trackedEvents["SPELL_DAMAGE"] = true
		trackedEvents["SPELL_MISSED"] = true
	end
	
	-- Earth Shock + Wind Shock/Shear
	if self.db.profile.spell.interrupt then
		trackedEvents["SPELL_INTERRUPT"] = true
	end

	-- CC
	if self.db.profile.cc.success then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
	end
	if self.db.profile.cc.fail then
		trackedEvents["SPELL_MISSED"] = true
	end
	if self.db.profile.cc.remove then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
	end
	if self.db.profile.cc.broken then
		trackedEvents["SWING_DAMAGE"] = true
		trackedEvents["RANGE_DAMAGE"] = true
		trackedEvents["SPELL_DAMAGE"] = true
		trackedEvents["SPELL_DISPEL"] = true
		trackedEvents["SPELL_PERIODIC_DAMAGE"] = true
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
	 	trackedEvents["SPELL_AURA_BROKEN"] = true
	 	trackedEvents["SPELL_AURA_BROKEN_SPELL"] = true
		-- trackedEvents["UNIT_DIED"] = true
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateUnits")
		self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateUnits")
	end

	-- Maelstrom Weapon
	-- Fulmination
	-- Earth Shield
	-- Water/Lightning Shield
	-- if self.db.profile.alert.maelstrom or
	-- self.db.profile.alert.fulmination or
	if (self.db.profile.eshield.enable and eshield_id) or
	   (self.db.profile.alert.shield and ls_id) then
		self:RegisterEvent("UNIT_AURA")
	end

	if self.db.profile.alert.surge then
		-- I can't find a fired event for Lava Surge, but it is sent to the combatlog
		-- Legion it is now SPELL_AURA_APPLIED
	 	-- trackedEvents["SPELL_CAST_SUCCESS"] = true
	 	trackedEvents["SPELL_AURA_APPLIED"] = true
	end
	
	-- Totem kills
	--if self.db.profile.totem.kill then
	--	trackedEvents["UNIT_DIED"] = true
	--end
	
	-- Custom Message Frame
	if (not self.msgFrame) and self.db.profile.display.frame then
		self:CreateCustomFrame()
	end
	
	-- Create Eshield Frame
	if self.db.profile.eshield.enable and eshield_id then
		if (not self.eshieldFrame) then
			self:CreateEshieldFrame()
		end
		if self.eshieldFrame then
			self.eshieldFrame:Show()
			self.eshieldButton:Show()
		end
	elseif self.eshieldFrame then
		self.eshieldFrame:Hide()
		self.eshieldButton:Hide()
	end

	-- if self.db.profile.alert.fulmination then
	-- 	ShamanFriend:FindISLId();
	-- 	ShamanFriend:SetFulmStacks();
	-- end
end

function ShamanFriend:COMBAT_LOG_EVENT_UNFILTERED(e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local substring
	if not trackedEvents[event] then
		-- self:Print("NOT tracked")
		-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
		-- self:Print(...)
		return
	end
	if (event == "SWING_DAMAGE") then
		if self.db.profile.wf.enable and sourceGUID == UnitGUID("player") then
			self:WfHandler("melee",select(1,...),select(7,...),select(2,...),event, "")
			
		end
		if self.db.profile.cc.broken then
			if (self.hex.enabled and destGUID == self.hex.target) then
				self.hex.breaksource = sourceName
				self.hex.breakspell = "(melee)"
				if (select(2,...) > 0) then
					self.hex.dead = true
				end
				-- self:Print("breakspell: " .. self.hex.breakspell .. ", dead: " .. tostring(self.hex.dead))
			end
		end
	elseif (event == "SWING_MISSED") and sourceGUID == UnitGUID("player") then
		if self.db.profile.wf.enable then
			self:WfHandler("melee",select(2,...),0,0,event,select(1,...))
		end
	elseif (event == "RANGE_DAMAGE") then
		if self.db.profile.cc.broken then
			if (self.hex.enabled and destGUID == self.hex.target) then
				self.hex.breaksource = sourceName
				self.hex.breakspell = select(2,...)
				if (select(5,...) > 0) then
					self.hex.dead = true
				end
				-- self:Print("breakspell: " .. self.hex.breakspell .. ", dead: " .. tostring(self.hex.dead))
			end
		end
	elseif (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or
	   event == "SPELL_MISSED") then
		if self.db.profile.cc.broken and event == "SPELL_DAMAGE" or
		   event == "SPELL_PERIODIC_DAMAGE" then
			if (self.hex.enabled and destGUID == self.hex.target) then
				self.hex.breaksource = sourceName
				self.hex.breakspell = select(2,...)
				if (select(5,...) > 0) then
					self.hex.dead = true
				end
				-- self:Print("breakspell: " .. self.hex.breakspell .. ", dead: " .. tostring(self.hex.dead))
			end
		end
		if sourceGUID == UnitGUID("player") then
			-- if self.db.profile.lo.enable or self.db.profile.lo.fulmination then
			if self.db.profile.lo.enable then
				if event == "SPELL_DAMAGE" then
					self:LoHandler(select(1,...),select(4,...),select(10,...),event)
				elseif event == "SPELL_MISSED" then
					self:LoHandler(select(1,...),0,0,event)
				end
			end
			if self.db.profile.wf.enable then
				if event == "SPELL_DAMAGE" then
					self:WfHandler(select(1,...),select(4,...),select(10,...),select(5,...),event,"")
				elseif event == "SPELL_MISSED" then
					self:WfHandler(select(1,...),0,0,0,event,select(4,...))
				end
			end
			if self.db.profile.cc.fail and event == "SPELL_MISSED" then
				if cc_ids[select(1,...)] and self:ChatChannel(self.db.profile.cc.ccchat) ~= "none" then
					-- Replace TARGET in string with the actual target
					substring = string.gsub(self.db.profile.cc.failtext, "TARGET", destName)
					-- Add the type of miss to the end
					substring = substring .. select(4,...)

					-- Do not announce that the CC failed if they are still CC'd
					-- For example if you try to hex a banished target
					local ccannounce = true
					if (self:GetCC(destGUID, select(1,...))) then
						ccannounce = false
					-- elseif (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
					-- 	ccannounce = false
					end
					if (not ccannounce) then
						-- Replace SPELL in string with the actual spell
						substring = string.gsub(substring, "SPELL", select(2,...))
						self:Message(substring, "spell")
					else
						-- Replace SPELL in string with the actual spell
						-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(1,...) .. "\124h[" .. select(2,...) .. "]\124h\124r"
						local spellstring = GetSpellLink(select(1,...))
						substring = string.gsub(substring, "SPELL", spellstring)

						self:Announce(substring,self:ChatChannel(self.db.profile.cc.ccchat))
					end
				end
			end
		else
			if self.db.profile.spell.ground then
				-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
				-- destFlags == 8465 for my unmarked totem. With a raid mark on totem, higher bits may be set. 
				if ((not self.db.profile.spell.groundself) or math.fmod(destFlags,65536) == 8465) and destName == lN["Grounding Totem"] then
					self:Message(L["Ground: "] .. select(2,...) .. string.format(" (%s)",strlower(select(4,...))),"spell")
					if self:ChatChannel(self.db.profile.spell.groundmsg) ~= "none" then
						self:Announce(L["Ground: "] .. select(2,...) .. string.format(" (%s)",strlower(select(4,...))),self:ChatChannel(self.db.profile.spell.groundmsg))
					end
				end 
			end		
		end
	elseif event == "SPELL_AURA_REMOVED" then
		if sourceGUID == UnitGUID("player") and cc_ids[select(1,...)] then
			-- More than one CC can break at the same time before it is processed
			-- We need to create a table of each CC break
			table.insert(self.checkcc, timestamp);
			table.insert(self.checkcc, destGUID);
			table.insert(self.checkcc, destName);
			local cc_sid = select(1,...)
			table.insert(self.checkcc, cc_sid);
			local cc_name = select(2,...)
			table.insert(self.checkcc, cc_name);
			self:ScheduleTimer(self.CheckCC, 0.2, self)
		elseif allcc_ids[select(1,...)] then
			-- Track if any CC was removed from a target
			-- We won't announce when applying CC to this target
			self.cc.removetarget = destGUID
			self.cc.removetime = timestamp
		end
	-- Blizzard has apparently implemented this for every CC in the game, except Hex
	-- There does not seem to be any good way to determine what broke Hex until this is implemented
	elseif (event == "SPELL_AURA_BROKEN" or
		event == "SPELL_AURA_BROKEN_SPELL") then
	 	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		if (self.hex.enabled and destGUID == self.hex.target and hex_ids[select(1,...)]) then
			if self.db.profile.cc.broken then
				local breakspell
				-- What broke it?
				if (event == "SPELL_AURA_BROKEN") then
					breakspell = "(melee)"
				elseif (event == "SPELL_AURA_BROKEN_SPELL") then
					breakspell = select(5,...)
				end

				local cctime = 0
				if (hex_ids[select(1,...)]) then
					cctime = self.hex.time
				end

				self:BreakMessage(timestamp, sourceName, destGUID, destName, breakspell, cctime, select(1,...), select(2,...))

				if hex_ids[select(1,...)] then
					self.hex.enabled = false
					self.hex.target = nil
					self.hex.dead = false
					-- self.hex.time = 0
					self.hex.breaksource = nil
					self.hex.breakspell = nil
				end
			end
		end
	elseif event == "SPELL_AURA_APPLIED" then
		-- if self.db.profile.misc.elet5 and select(1,...) == 37234 and destGUID == UnitGUID("player") then
		-- 	self:Message(L["Gained set bonus"], "misc")
		-- elseif self.db.profile.misc.enht5 and select(1,...) == 37240 and destGUID == UnitGUID("player") then
		-- 	self:Message(L["Gained set bonus"], "misc")
		-- elseif self.db.profile.misc.restot5 and select(1,...) == 39950 and destGUID == UnitGUID("player") then
		-- 	self:Message(L["Gained set bonus"], "misc")
	 	if sourceGUID == UnitGUID("player") then
			-- Lava Surge is resto only in Legion?
	 		-- Reset the Chain Lightning count on each SPELL_CAST_SUCCESS
	 		cl_cnt = 0
	 		if self.db.profile.alert.surge and (select(1,...) == 77762) then
	 			self:Message(select(2,...), "proc")
	 		end
	 	end
		if sourceGUID == UnitGUID("player") and cc_ids[select(1,...)] then
			local ccannounce = true
			if hex_ids[select(1,...)] then
				self.hex.enabled = true
				self.hex.target = destGUID
				self.hex.dead = false
				-- Do not reset time or announce if reapplying CC to the same target
				if (self.hex.target == self.hex.lasttarget) then
					ccannounce = false
				else
					self.hex.time = timestamp
					self.hex.lasttarget = destGUID
				end
				self.hex.breaksource = nil
				self.hex.breakspell = nil
				self.hex.expiration = self:GetExpiration(timestamp, select(2,...), destGUID, 60)
			end
			if (self:GetCC(destGUID, select(1,...))) then
				-- Do not announce if the target is already CC'd by another player
				ccannounce = false
			elseif (destGUID == self.cc.removetarget and (self.cc.removetime + 1) >= timestamp) then
				-- Do not announce if CC was just removed from that target
				-- For example, if we hex a target that was polymorphed
				ccannounce = false
			-- elseif (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
			-- 	ccannounce = false
			end
			if ccannounce and self.db.profile.cc.success and self:ChatChannel(self.db.profile.cc.ccchat) ~= "none" then
				-- Replace TARGET in string with the actual target
				substring = string.gsub(self.db.profile.cc.successtext, "TARGET", destName)
				-- Replace SPELL in string with the actual spell
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(1,...) .. "\124h[" .. select(2,...) .. "]\124h\124r"
				local spellstring = GetSpellLink(select(1,...))
				substring = string.gsub(substring, "SPELL", spellstring)
	 			self:Announce(substring,self:ChatChannel(self.db.profile.cc.ccchat))
			end
		end
	elseif event == "SPELL_INTERRUPT" then
		if self.db.profile.spell.interrupt and sourceGUID == UnitGUID("player") and interrupt_ids[select(1,...)] then
			self:Message(string.format(L["Interrupted: %s"],select(5,...)),"spell")
			if self:ChatChannel(self.db.profile.spell.interruptmsg) ~= "none" then
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(4,...) .. "\124h[" .. select(5,...) .. "]\124h\124r"
				local spell = select(4,...)
				-- self:Print("Debug: Interrupt spell id:", spell)
				local spellstring = ""
				if (spell) then
					spellstring = GetSpellLink(spell)
				end
				if self.db.profile.spell.target then
					self:Announce(string.format(L["Interrupted: %s"] .. " (%s)",spellstring,destName),self:ChatChannel(self.db.profile.spell.interruptmsg))
				else
					self:Announce(string.format(L["Interrupted: %s"],spellstring),self:ChatChannel(self.db.profile.spell.interruptmsg))
				end
			end
		end	
	elseif event == "SPELL_HEAL" then
		-- Legion: Need to check spell id for actual SPELL_HEAL for new Earth Shield
		if eshield_id and self.db.profile.eshield.enable and select(1,...) == 204288 and destName == eshield_target then
			self:eshield_BuffCheck()
		end
	elseif event == "SPELL_DISPEL" then
		if self.db.profile.spell.purge and sourceGUID == UnitGUID("player") and select(1,...) == 370 then
			self:Message(L["Purge: "] .. select(5,...),"spell")
			if self:ChatChannel(self.db.profile.spell.purgemsg) ~= "none" then
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(4,...) .. "\124h[" .. select(5,...) .. "]\124h\124r"
				local spellstring = GetSpellLink(select(4,...))
				if self.db.profile.spell.target then
					self:Announce(string.format(L["Purge: "] .. "%s (%s)",spellstring,destName),self:ChatChannel(self.db.profile.spell.purgemsg))
				else
					self:Announce(L["Purge: "] .. spellstring,self:ChatChannel(self.db.profile.spell.purgemsg))
				end
			end
		elseif self.db.profile.spell.dispel and sourceGUID == UnitGUID("player") and dispel_ids[select(1,...)] then
			self:Message(L["Dispel: "] .. select(5,...),"spell")
			if self:ChatChannel(self.db.profile.spell.dispelmsg) ~= "none" then
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(4,...) .. "\124h[" .. select(5,...) .. "]\124h\124r"
				local spellstring = GetSpellLink(select(4,...))
				if self.db.profile.spell.target then
					self:Announce(string.format(L["Dispel: "] .. "%s (%s)",spellstring,destName),self:ChatChannel(self.db.profile.spell.dispelmsg))
				else
					self:Announce(L["Dispel: "] .. spellstring,self:ChatChannel(self.db.profile.spell.dispelmsg))
				end
			end
		elseif self.db.profile.cc.broken then
			if (self.hex.enabled and destGUID == self.hex.target) then
				self.hex.breaksource = sourceName
				self.hex.breakspell = select(2,...)
				-- self:Print("breakspell: " .. self.hex.breakspell)
			end
		end
	-- Lava Surge is now SPELL_AURA_APPLIED in Legion for resto
	-- elseif event == "SPELL_CAST_SUCCESS" then
	--	if sourceGUID == UnitGUID("player") then
	--		-- Reset the Chain Lightning count on each SPELL_CAST_SUCCESS
	--		cl_cnt = 0
	--		if self.db.profile.alert.surge and (select(1,...) == 77762) then
	--			self:Message(select(2,...), "proc")
	--		end
	--	end
	-- elseif event == "UNIT_DIED" then
	 	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
		-- if (self.hex.enabled and destGUID == self.hex.target and self.db.profile.cc.broken) then
			-- self:Print("Hex target died")
		-- 	self.hex.dead = true
		-- end
		-- if self.db.profile.wf.enable and sourceGUID == wf_guid then
			--wf_guid = nil
		-- end
		--[[if self.db.profile.totem.kill and sourceFlags == 8465 then
			self:Message(L["Killed: "] .. select(5,...),"totem")
			if self:ChatChannel(self.db.profile.spell.purgemsg) ~= "none" then
				if self.db.profile.spell.target then
					self:Announce(string.format(L["Killed: "] .. "%s (%s)",select(5,...),destName),self:ChatChannel(self.db.profile.spell.purgemsg))
				else
					self:Announce(L["Killed: "] .. select(5,...),self:ChatChannel(self.db.profile.spell.purgemsg))
				end
			end
		end]]
	end
	
	--self:Print("tracked")
	--self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
	--self:Print(...)
end

function ShamanFriend:CheckCC()
	-- self:Print("In CheckCC")
	while (next(self.checkcc) ~= nil) do
		local timestamp, destGUID, destName, cc_sid, cc_name
		timestamp = table.remove(self.checkcc, 1)
		destGUID = table.remove(self.checkcc, 1)
		destName = table.remove(self.checkcc, 1)
		cc_sid = table.remove(self.checkcc, 1)
		cc_name = table.remove(self.checkcc, 1)
		self:CCRemoved(timestamp, destGUID, destName, cc_sid, cc_name)
	end
end


function ShamanFriend:CCRemoved(timestamp, destGUID, destName, cc_sid, cc_name)
	-- self:Print("In CCRemoved")
	-- self:Print("hex breakspell: "..tostring(self.hex.breakspell)"))
	if self.db.profile.cc.broken and self.hex.breakspell and hex_ids[cc_sid] and
	   (timestamp + 1 < self.hex.expiration) then
		self:BreakMessage(timestamp, self.hex.breaksource, destGUID, destName, self.hex.breakspell, self.hex.time, cc_sid, cc_name)
	elseif self.db.profile.cc.remove then
		if hex_ids[cc_sid] and self.hex.enabled then
			self:Message(cc_name .. L[" faded from "] .. destName, "cc")
			-- Do not announce that the CC faded if they are still CC'd
			local ccannounce = true
			if (self:GetCC(destGUID, cc_sid)) then
				ccannounce = false
			-- elseif (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
			elseif (hex_ids[cc_sid] and self.hex.dead) then
				ccannounce = false
			end
			if self:ChatChannel(self.db.profile.cc.ccchat) ~= "none" and ccannounce then
				-- Replace TARGET in string with the actual target
				substring = string.gsub(self.db.profile.cc.removetext, "TARGET", destName)
				-- Replace SPELL in string with the actual spell
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. cc_sid .. "\124h[" .. cc_name .. "]\124h\124r"
				local spellstring = GetSpellLink(cc_sid)
				substring = string.gsub(substring, "SPELL", spellstring)
				self:Announce(substring,self:ChatChannel(self.db.profile.cc.ccchat))
			end
		end
	end
	if hex_ids[cc_sid] then
		self.hex.enabled = false
		self.hex.target = nil
		self.hex.dead = false
		-- self.hex.time = 0
		self.hex.breaksource = nil
		self.hex.breakspell = nil
	end
	self.cc.removetarget = nil
end

function ShamanFriend:BreakMessage(timestamp, sourceName, destGUID, destName, breakspell, cc_time, cc_sid, cc_name)
	local message = L[" broke SPELL on "]
	-- Replace SPELL in string with the actual spell
	message = string.gsub(message, "SPELL", cc_name)

	-- self:Print("In BreakMessage")

	-- if (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
	if (hex_ids[cc_sid] and self.hex.dead) then
		return
	end

	self:Message(sourceName .. message .. destName .. ": " .. breakspell, "cc")

	-- If the tank breaks it after tanktime then do not warn
	local istank = false
	local uid = self.NameToID[sourceName]
	local role = ""
	if (uid and UnitExists(uid)) then
		role = UnitGroupRolesAssigned(uid)
	end
	if (role == "TANK") then
		istank = true
	elseif (uid and UnitExists(uid) and GetPartyAssignment('MAINTANK', uid)) then
		istank = true
	end

	-- self:Print(sourceName.."/"..tostring(uid)..": istank: "..tostring(istank)..", timestamp: "..timestamp..", cc_time: "..cc_time)
	if (istank and (timestamp >= cc_time + self.db.profile.cc.tanktime)) then
		return
	end

	if self:ChatChannel(self.db.profile.cc.brokenchat) ~= "none" then
		-- Replace SOURCE in string with the source
		substring = string.gsub(self.db.profile.cc.brokentext, "SOURCE", sourceName)
		-- Replace TARGET in string with the TARGET
		substring = string.gsub(substring, "TARGET", destName)
		-- Replace SPELL in string with the actual spell
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. cc_sid .. "\124h[" .. cc_name .. "]\124h\124r"
		local spellstring = GetSpellLink(cc_sid)
		substring = string.gsub(substring, "SPELL", spellstring)
		-- Add what broke it
		substring = substring .. breakspell
		self:Announce(substring,self:ChatChannel(self.db.profile.cc.brokenchat))
	end
end

function ShamanFriend:LEARNED_SPELL_IN_TAB(event, Tab)
	if self.eshieldFrame then
		self.eshieldFrame:Hide()
	end
	if self.eshieldButton then
		self.eshieldButton:Hide()
	end
	-- self:Print("detected a new spell")
	self:LoadEvents()
end

function ShamanFriend:ACTIVE_TALENT_GROUP_CHANGED(event, newGroup, prevGroup)
	-- if self.db.char.switchSpec then
		if self.eshieldFrame then
			self.eshieldFrame:Hide()
		end
		if self.eshieldButton then
			self.eshieldButton:Hide()
		end
		-- self:Print("detected a talent spec change")
		self:LoadEvents()
	-- end
end

function ShamanFriend:ChatChannel(chat)
	if chat == "RAID" and not UnitInRaid("player") then
		chat = "PARTY"
	end
	if chat == "PARTY" and GetNumSubgroupMembers() == 0 then
		chat = "none"
	end

	-- self:Print("ChatChannel: " .. chat)
	return chat;
end

-- a1 = Unit casting the spell
-- a2 = Spell name
-- a3 = Spell rank
function ShamanFriend:UNIT_SPELLCAST_SUCCEEDED(event,a1,a2,a3)
	if a1 ~= "player" then
		return
	end
	
	if self.db.profile.spell.bloodlust and self:ChatChannel(self.db.profile.spell.bloodlustchat) ~= "none" and (a2 == lN["Bloodlust"] or a2 == lN["Heroism"]) then
		-- Replace SPELL in string with the actual spell
		-- local spell_name = "Bloodlust"
		-- if a2 == lN["Heroism"] then
		-- 	spell_name = "Heroism"
		-- end
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. name_ids[spell_name] .. "\124h[" .. a2 .. "]\124h\124r"
		local spellstring = GetSpellLink(a2)
		local substring = string.gsub(self.db.profile.spell.bloodlusttext, "SPELL", spellstring)
		self:Announce(substring,self:ChatChannel(self.db.profile.spell.bloodlustchat))
	elseif self.db.profile.spell.spiritlink and self:ChatChannel(self.db.profile.spell.spiritlinkchat) ~= "none" and a2 == lN["Spirit Link Totem"] then
		-- Replace SPELL in string with the actual spell
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. name_ids["Spirit Link Totem"] .. "\124h[" .. a2 .. "]\124h\124r"
		local spellstring = GetSpellLink(a2)
		local substring = string.gsub(self.db.profile.spell.spiritlinktext, "SPELL", spellstring)
		self:Announce(substring,self:ChatChannel(self.db.profile.spell.spiritlinkchat))
	elseif self.db.profile.spell.healtide and self:ChatChannel(self.db.profile.spell.healtidechat) ~= "none" and a2 == lN["Healing Tide Totem"] then
		-- Replace SPELL in string with the actual spell
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. name_ids["Healing Tide Totem"] .. "\124h[" .. a2 .. "]\124h\124r"
		local spellstring = GetSpellLink(a2)
		local substring = string.gsub(self.db.profile.spell.healtidetext, "SPELL", spellstring)
		self:Announce(substring,self:ChatChannel(self.db.profile.spell.healtidechat))
	elseif self.db.profile.spell.feralspirit and self:ChatChannel(self.db.profile.spell.feralspiritchat) ~= "none" and a2 == lN["Feral Spirit"] then
		-- Replace SPELL in string with the actual spell
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. name_ids["Feral Spirit"] .. "\124h[" .. a2 .. "]\124h\124r"
		local spellstring = GetSpellLink(a2)
		local substring = string.gsub(self.db.profile.spell.feralspirittext, "SPELL", spellstring)
		self:Announce(substring,self:ChatChannel(self.db.profile.spell.feralspiritchat))
	-- This event isn't called for Lava Surge
	-- elseif self.db.profile.alert.surge and a2 == lN["Lava Surge!"] then
	--	self:Message(a2, "alert")
	end
end

-- a1 = Unit
function ShamanFriend:UNIT_AURA(event,a1)
	local old_mwcount = 0

	if self.db.profile.alert.maelstrom and a1 == "player" then
		old_mwcount = mw_count
		self:maelstrom_BuffCheck()
		if old_mwcount ~= mw_count and mw_count == self.db.profile.alert.maelstacks then
			self:Message(lN["Maelstrom Weapon"] .." ".. tostring(mw_count),"proc")
		end
	end

	-- if self.db.profile.alert.fulmination and a1 == "player" then
		-- old_mwcount = ls_count
	-- 	self:fulmination_BuffCheck()
		-- if old_mwcount ~= ls_count and ls_count == 9 then
	-- 	if ls_count == fulm_alertstacks then
	-- 		self:Message(lN["Lightning Shield"] .." ".. tostring(ls_count),"proc")
	-- 	end
	-- end

	if self.db.profile.alert.shield and a1 == "player" then
	 	if UnitBuff("player", lN["Lightning Shield"]) then
	 		self.shield.enabled = true
	 		self.shield.name = lN["Lightning Shield"]
	-- 	elseif UnitBuff("player", lN["Water Shield"]) then
	-- 		self.shield.enabled = true
	-- 		self.shield.name = lN["Water Shield"]
	 	elseif UnitBuff("player", lN["Earth Shield"], nil, "player") then
	 		self.shield.enabled = true
	 		self.shield.name = lN["Earth Shield"]
	 	elseif self.shield.enabled then
	 		self.shield.enabled = false
	 		self:Message(self.shield.name .. L[" faded"], "alert")
	 	end
	end

	if eshield_id and self.db.profile.eshield.enable and (a1 == eshield_target or a1 == "player") then
		-- self:Print("Updating Earth Shield in UNIT_AURA")
		self:eshield_BuffCheck()

		local buff = UnitBuff(eshield_target, lN["Earth Shield"], nil, "player")
		-- self:Print("Earth Shield source: " .. source)

		if self.eshield.enabled and not buff then
			self.eshield.enabled = false
			self:CancelTimer(self.eshield.TimerEvent, false)
			local es_target_name = UnitName(eshield_target)
			if not es_target_name then
				es_target_name = "Unknown"
			end
			-- Only warn if either the target no longer exists or
			-- does exist and is still in range
			-- This should get rid of warnings about Earth Shield fading when the target
			-- gets out of range
			if self.db.profile.eshield.alert and
			   (not UnitExists(eshield_target) or self:InRange(eshield_target)) then
				self:Message(L["Earth Shield faded from "] .. es_target_name, "eshield")
			end
		end
	end
end

-- Load NameToID table
-- This is only used to get UnitIDs for tanks
-- so there is no need to track pets
function ShamanFriend:UpdateUnits()
	local num_party = GetNumSubgroupMembers()

	-- Don't do this in combat for performance reasons
	-- For this addon it is not a big deal if we don't
	-- have a current list of tanks if it changes during combat
	if InCombatLockdown() then
		DelayedUnitUpdate = true
		return
	end

	self.NameToID = {}

	if IsInRaid() then
		local num_raid = GetNumGroupMembers()
		for i = 1, num_raid do
			local unitID = "raid" .. i
			if UnitExists(unitID) then
				local name, realm = UnitName(unitID)
				-- self.NameToID[name] = unitID
				if realm and realm ~= "" then
					name = name .. "-" .. realm
				end
				self.NameToID[name] = unitID
			end
		end
	elseif num_party > 0 then
		for i = 1, num_party do
			local unitID = "party" .. i
			if UnitExists(unitID) then
				local name, realm = UnitName(unitID)
				-- self.NameToID[name] = unitID
				if realm and realm ~= "" then
					name = name .. "-" .. realm
				end
				self.NameToID[name] = unitID
			end
		end
	end

	-- The shaman shouldn't be a tank
	-- self.NameToID[UnitName("player")] = "player"
	DelayedUnitUpdate = false
end

function ShamanFriend:eshield_checkTarget()
	-- self:Print("In eshield_checkTarget")
	if eshield_id and self.db.profile.eshield.enable and eshield_target ~= eshield_casttarget then
		local buff = UnitBuff(eshield_casttarget, lN["Earth Shield"], nil, "player")

		if buff then
			-- self:Print("Found buff")
			if InCombatLockdown() then
				-- Target changed in combat
				self.eshieldButton.texture:SetVertexColor(0.8,0,0,0.8)
				if self.eshield_lockdown == false then
					self.eshield_oldtarget = eshield_target
					self.eshield_lockdown = true
					-- self:Print("Earth Shield oldtarget " .. self.eshield_oldtarget)
				end
			end
			if self.eshield_lockdown and self.eshield_oldtarget == eshield_casttarget then
				-- Target changed back to original
				self.eshieldButton.texture:SetVertexColor(1,1,1,1)
				self.eshield_lockdown = false
			end

			eshield_target = eshield_casttarget
			-- self:Print("Updating Earth Shield in eshield_checkTarget")
			if self:UInParty(eshield_target) or UnitInRaid(eshield_target) then
				self:eshield_SetTarget(eshield_target)
				self:eshield_SetText("-","-")
				self:eshield_BuffCheck()
				self.eshield.enabled = true
				self.eshield.TimerEvent = self:ScheduleRepeatingTimer(self.eshield_BuffCheck, 10, self)
			else
				eshield_target = "Outside group"
				self:eshield_SetTarget(eshield_target)
				self:eshield_SetText("-","-")
				self:eshield_BuffCheck()
				if self.eshield.enabled then
					self.eshield.enabled = false
					self:CancelTimer(self.eshield.TimerEvent, false)
				end
			end
		else
			if not self:UInParty(eshield_casttarget) and not UnitInRaid(eshield_casttarget) then
				eshield_target = "Outside group"
				self:eshield_SetTarget(eshield_target)
				self:eshield_SetText("-","-")
				self:eshield_BuffCheck()
				if self.eshield.enabled then
					self.eshield.enabled = false
					self:CancelTimer(self.eshield.TimerEvent, false)
				end
			-- else
			-- self:Print("Earth Shield cast failed.")
			end
		end
	elseif eshield_id and self.db.profile.eshield.enable then
		local buff = UnitBuff(eshield_target, lN["Earth Shield"], nil, "player")

		if buff then
			-- Earth Shield never changed targets, re-enable earth shield checking
			if not self.eshield.enabled then
				self.eshield.enabled = true
				self.eshield.TimerEvent = self:ScheduleRepeatingTimer(self.eshield_BuffCheck, 10, self)
				self:eshield_BuffCheck()
			end
		end
	end
end

function ShamanFriend:maelstrom_BuffCheck()
	local buff, _, _, count, _, _, expirationTime = UnitBuff("PLAYER", lN["Maelstrom Weapon"])
	if buff then
		mw_count = count
		-- self:Print(lN["Maelstrom Weapon"] .. count)
	end
end

-- function ShamanFriend:fulmination_BuffCheck()
-- 	local buff, _, _, count, _, _, expirationTime = UnitBuff("PLAYER", lN["Lightning Shield"])
-- 	if buff then
-- 		ls_count = count
		-- self:Print(lN["Lightning Shield"] .. count)
-- 	else
-- 		ls_count = 0
-- 	end
-- end

-- Find the expiration time of buff
function ShamanFriend:GetExpiration(timestamp, buff_name, unitid, default)
	-- Try to get a usable unitid
	if (unitid == UnitGUID("target")) then
		unitid = "target"
	elseif (unitid == UnitGUID("focus")) then
		unitid = "focus"
	elseif (unitid == UnitGUID("targettarget")) then
		unitid = "targettarget"
	elseif (unitid == UnitGUID("focustarget")) then
		unitid = "focustarget"
	else
		-- Couldn't find a usable unitid
		-- Default if we can't figure it out
		return timestamp + default
	end

	-- GetTime and timestamp use different formats, need this in
	-- timestamp format
	local buff, _, _, count, _, _, expirationTime = UnitDebuff(unitid, buff_name)
	if (buff) then
		local expires = expirationTime - GetTime()
		-- self:Print("GetExpiration: time: "..expires.." timestamp: "..timestamp)
		return timestamp + expires
	else
		-- Default if we can't figure it out
		return timestamp + default
	end
end

-- Find a CC on the unit cast by any player
function ShamanFriend:GetCC(unitid, current_sid)
	local spell

	-- Try to get a usable unitid
	if (unitid == UnitGUID("target")) then
		unitid = "target"
	elseif (unitid == UnitGUID("focus")) then
		unitid = "focus"
	elseif (unitid == UnitGUID("targettarget")) then
		unitid = "targettarget"
	elseif (unitid == UnitGUID("focustarget")) then
		unitid = "focustarget"
	else
		-- Couldn't find a usable unitid
		return
	end
	-- self:Print("GetCC unitid: "..unitid)

	-- Go through all buffs on a unit until you find a CC
	local i = 1
	local buffName, _, _, _, _, _, _, unitCaster, _, _,
		buffID = UnitDebuff(unitid, i)
	while buffName do
		if allcc_ids[buffID] and buffName then
			if unitCaster ~= "player" or buffID ~= current_sid then
				spell = buffName
				break
			end
		end
		i = i + 1
		buffName, _, _, _, _, _, _, unitCaster, _, _,
			buffID = UnitDebuff(unitid, i)
	end
	-- self:Print("GetCC spell: "..tostring(spell).." "..tostring(unitCaster))
	return spell
end

function ShamanFriend:OpenConfig(input)
	-- Have to call it twice to work around bug
 	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
 	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	-- if InterfaceOptionsFrame_OpenToCategory then
	-- 	InterfaceOptionsFrame_OpenToCategory("ShamanFriend");
	-- else
	-- 	InterfaceOptionsFrame_OpenToFrame("ShamanFriend");
	-- end
end

function ShamanFriend:ShowVersion()
	self:Print(self.version)
end

function ShamanFriend:WfHandler(id, damage, crit, over, event, miss)
	-- Melee + mh stormstrike/Windstrike
	if id == "melee" or id == 32175 or id == 115357 then
		wf_cnt = 0
		wf_over = 0
		if event == "SWING_MISSED" or event == "SPELL_MISSED" then
			wf_miss = 1
			wf_dmg = 0
			wf_crit = 0
		else
			wf_miss = 0
			--self:Print("aaa: " .. damage .. "event: " .. event)
			wf_dmg = damage
			if crit == 1 then
				wf_crit = 1
			else
				wf_crit = 0
			end
		end

	-- oh stormstrike/oh windstrike + wf mh + wf oh
	elseif id == 32176 or id == 115360 or id == 25504 or id == 33750 then
		if id == 25504 then
			wf_cnt = wf_cnt + 1
			wf_hand = "mh"
		elseif id == 33750 then
			wf_cnt = wf_cnt + 1
			wf_hand = "oh"
		end
		
		if event == "SWING_MISSED" or event == "SPELL_MISSED" then
			wf_miss = wf_miss + 1
		else
			--self:Print("bbb: " .. damage)
			wf_dmg = wf_dmg + damage
			
			if crit == 1 then
				wf_crit = wf_crit + 1
			end
		end
	elseif self.db.profile.wf.lavalash and id == 60103 then
		lava_str = lN["Lava Lash"]
		if crit == 1 then
			lava_str = lava_str .. L[" CRIT"]
		end
		if event == "SPELL_MISSED" then
			lava_str = lava_str .. " ( " .. miss .. " )"
		elseif event == "SPELL_DAMAGE" then
			lava_str = lava_str .. ": " .. damage
		end
		self:Message(lava_str, "wf")
	end
	
	if wf_cnt == 3 then
		self:WfPrinter()
	elseif (self.db.profile.wf.miss and wf_cnt > 0 and wf_cnt < 3 and over > 0) then
		wf_over = 1
		self:WfPrinter()
	end
end

function ShamanFriend:WfPrinter()
	if wf_hand == "mh" and self.db.profile.wf.hand then
		wf_str = L["MH Windfury"]
	elseif wf_hand == "oh" and self.db.profile.wf.hand then
		wf_str = L["OH Windfury"]
	else
		wf_str = lN["Windfury"]
	end
	
	if wf_crit == 0 or not self.db.profile.wf.crit then
		wf_str = wf_str .. ": " .. wf_dmg
	elseif wf_crit == 1 then
		wf_str = wf_str .. L[" Single crit: "] .. wf_dmg
	elseif wf_crit == 2 then
		wf_str = wf_str .. L[" DOUBLE crit: "] .. wf_dmg
	elseif wf_crit == 3 then
		wf_str = wf_str .. L[" TRIPLE crit: "] .. wf_dmg
	elseif wf_crit == 4 then
		wf_str = wf_str .. L[" QUADRUPLE crit: "] .. wf_dmg
	elseif wf_crit == 5 then
		wf_str = wf_str .. L[" QUINTUPLE crit: "] .. wf_dmg
	else
		wf_str = wf_str .. " " .. wf_crit .. " crit: " .. wf_dmg
	end
	if self.db.profile.wf.miss and wf_miss > 0 then
		wf_str = wf_str .. " (" .. wf_miss .. L[" miss"] .. ")"
	end
	if self.db.profile.wf.miss and wf_over > 0 then
		wf_str = wf_str .. " (" .. wf_cnt .. L[" proc kill"] .. ")"
	end
	self:Message(wf_str, "wf")
	
	self.Wf = wf_dmg
	self.Wf_miss = wf_miss
	self.Wf_crit = wf_crit
	wf_cnt = 0
	wf_miss = 0
	wf_crit = 0
	wf_over = 0
	wf_dmg = 0
end

function ShamanFriend:LoHandler(spellID, spellDamage, spellCrit, event)
	lo_str = ""

	-- Elemental Overload is the Elemental Spec mastery
	-- Return if not Elemental spec
	local currentSpec = GetSpecialization()
	-- Shaman specs: 1) Elemental, 2) Enhancement, 3) Restoration

	if currentSpec ~= 1 then
		return
	end

	local spell_name = GetSpellInfo(spellID)

	if lb_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = 1
		else
			lo_miss = 0
		end

		cl_cnt = 0;
		lo_hit = spellDamage
		if spellCrit == 1 then
			lo_crit = 1
		else
			lo_crit = 0
		end
	elseif lb_ol_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = lo_miss + 1
		end

		lo_hit = lo_hit + spellDamage
		if spellCrit == 1 then
			lo_crit = lo_crit +1
		end
		
		lo_str = string.format(L["%s Overload"], spell_name)
		if self.db.profile.lo.crit then
			if lo_crit == 1 then
				lo_str = lo_str .. L[" CRIT"]
			elseif lo_crit == 2 then
				lo_str = lo_str .. L[" DOUBLE CRIT"]
			elseif lo_crit > 2 then
				lo_str = lo_str .. " " .. lo_crit .. L[" CRIT"]
			end
		end
		
		if self.db.profile.lo.damage then
			lo_str = lo_str .. ": " .. lo_hit
		end
		if self.db.profile.lo.miss and lo_miss > 0 then
			lo_str = lo_str .. " (" .. lo_miss .. L[" miss"] .. ")"
		end
		self:Message(lo_str, "lo")
	elseif lvb_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = 1
		else
			lo_miss = 0
		end

		cl_cnt = 0;
		lvb_hit = spellDamage
		if spellCrit == 1 then
			lvb_crit = 1
		else
			lvb_crit = 0
		end
	elseif lvb_ol_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = lo_miss + 1
		end

		lvb_hit = lvb_hit + spellDamage
		if spellCrit == 1 then
			lvb_crit = lvb_crit +1
		end
		
		lo_str = string.format(L["%s Overload"], spell_name)
		if self.db.profile.lo.crit then
			if lvb_crit == 1 then
				lo_str = lo_str .. L[" CRIT"]
			elseif lvb_crit == 2 then
				lo_str = lo_str .. L[" DOUBLE CRIT"]
			elseif lvb_crit > 2 then
				lo_str = lo_str .. " " .. lvb_crit .. L[" CRIT"]
			end
		end
		
		if self.db.profile.lo.damage then
			lo_str = lo_str .. ": " .. lvb_hit
		end
		if self.db.profile.lo.miss and lo_miss > 0 then
			lo_str = lo_str .. " (" .. lo_miss .. L[" miss"] .. ")"
		end
		self:Message(lo_str, "lo")
	elseif eb_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = 1
		else
			lo_miss = 0
		end

		cl_cnt = 0;
		eb_hit = spellDamage
		if spellCrit == 1 then
			eb_crit = 1
		else
			eb_crit = 0
		end
	elseif eb_ol_ids[spellID] and self.db.profile.lo.enable then
		if event == "SPELL_MISSED" then
			lo_miss = lo_miss + 1
		end

		eb_hit = eb_hit + spellDamage
		if spellCrit == 1 then
			eb_crit = eb_crit +1
		end
		
		lo_str = string.format(L["%s Overload"], spell_name)
		if self.db.profile.lo.crit then
			if eb_crit == 1 then
				lo_str = lo_str .. L[" CRIT"]
			elseif eb_crit == 2 then
				lo_str = lo_str .. L[" DOUBLE CRIT"]
			end
		end
		
		if self.db.profile.lo.damage then
			lo_str = lo_str .. ": " .. eb_hit
		end
		if self.db.profile.lo.miss and lo_miss > 0 then
			lo_str = lo_str .. " (" .. lo_miss .. L[" miss"] .. ")"
		end
		self:Message(lo_str, "lo")
	elseif cl_ids[spellID] and self.db.profile.lo.enable then
		-- If we didn't print the last Chain Lightning Overload, print it now
		lo_c = 0
		self:CLOLPrinter()
		if cl_cnt == 0 then
			lo_hit = spellDamage
			-- Reset Chain Lightning and Overload count to 0
			cl_cnt = 1

			-- Can spam Chain Lightning now, so this doesn't work
			-- Reset the cl_cnt in 2 sec
			--self:ScheduleTimer(function() cl_cnt = 0
			--end, 2, self)

			if event == "SPELL_MISSED" then
				lo_miss = 1
			else
				lo_miss = 0
			end

			if spellCrit == 1 then
				lo_crit = 1
			else
				lo_crit = 0
			end
		else
			lo_hit = lo_hit + spellDamage
			cl_cnt = cl_cnt + 1

			if event == "SPELL_MISSED" then
				lo_miss = lo_miss + 1
			end

			if spellCrit == 1 then
				lo_crit = lo_crit +1
			end
		end
	elseif cl_ol_ids[spellID] and self.db.profile.lo.enable then
		lo_hit = lo_hit + spellDamage
		lo_c = lo_c + 1

		if event == "SPELL_MISSED" then
			lo_miss = lo_miss + 1
		end

		if spellCrit == 1 then
			lo_crit = lo_crit +1
		end
		-- Print results in 2 seconds or at start of next Chain Lightning
		self:ScheduleTimer(self.CLOLPrinter, 2, self)
-- 	elseif fulm_ids[spellID] and self.db.profile.lo.fulmination then
-- 		fulm_hit = spellDamage
-- 		if event == "SPELL_MISSED" then
-- 			fulm_miss = 1
-- 		else
-- 			fulm_miss = 0
-- 		end
-- 		if spellCrit == 1 then
-- 			fulm_crit = 1
-- 		else
-- 			fulm_crit = 0
-- 		end
	-- elseif es_ids[spellID] and self.db.profile.lo.fulmination then
	-- 	if ((fulm_hit == 0) and (fulm_miss == 0)) then
	-- 		return
	-- 	end
-- 
-- 		fulm_hit = fulm_hit + spellDamage
-- 
-- 		if event == "SPELL_MISSED" then
-- 			fulm_miss = fulm_miss + 1
-- 		end
-- 		if spellCrit == 1 then
-- 			fulm_crit = fulm_crit +1
-- 		end
-- 		
-- 		lo_str = lN["Fulmination"]
-- 		if self.db.profile.lo.crit then
-- 			if fulm_crit == 1 then
-- 				lo_str = lo_str .. L[" CRIT"]
-- 			elseif fulm_crit == 2 then
-- 				lo_str = lo_str .. L[" DOUBLE CRIT"]
-- 			elseif fulm_crit > 2 then
-- 				lo_str = lo_str .. " " .. fulm_crit .. L[" CRIT"]
-- 			end
-- 		end
-- 		
-- 		if self.db.profile.lo.damage then
-- 			lo_str = lo_str .. ": " .. fulm_hit
-- 		end
-- 		if self.db.profile.lo.miss and fulm_miss > 0 then
-- 			lo_str = lo_str .. " (" .. fulm_miss .. L[" miss"] .. ")"
-- 		end
-- 		self:Message(lo_str, "lo")
-- 		fulm_hit = 0
-- 		fulm_miss = 0
-- 		cl_cnt = 0;
	end
end

-- Report Chain Lightning Overload
function ShamanFriend:CLOLPrinter()
	lo_str = ""

	-- Chain Lightning
	local spell_name = GetSpellInfo(421)

	if lo_c == 0 then
		return
	elseif lo_c == 1 then
		lo_str = string.format(L["%s Overload"], spell_name)
	elseif lo_c == 2 then
		lo_str = L["DOUBLE Chain Lightning Overload"]
	elseif lo_c == 3 then
		lo_str = L["TRIPLE Chain Lightning Overload"]
	else
		lo_str = tostring(lo_c) .. " " .. string.format(L["%s Overload"], spell_name)
	end

	if self.db.profile.lo.crit then
		if lo_crit == 1 then
			lo_str = lo_str .. L[" CRIT"]
		elseif lo_crit == 2 then
			lo_str = lo_str .. L[" DOUBLE CRIT"]
		elseif lo_crit > 2 then
			lo_str = lo_str .. " " .. lo_crit .. L[" CRIT"]
		end
	end

	if self.db.profile.lo.damage then
		lo_str = lo_str .. ": " .. lo_hit
	end
	if self.db.profile.lo.miss and lo_miss > 0 then
		lo_str = lo_str .. " (" .. lo_miss .. L[" miss"] .. ")"
	end
	self:Message(lo_str, "lo")
	lo_c = 0
end

-- a1 - Unit casting the spell
-- a2 - Spell name
-- a3 - Spell rank
-- a4 = Spell target
function ShamanFriend:UNIT_SPELLCAST_SENT(event, a1, a2, a3, a4)
	if a1 ~= "player" then
		return
	end
	-- self:Print(event, a1, a2, a3, a4)

	if self.db.profile.eshield.enable and a2 == lN["Earth Shield"] then
		if a4 ~= nil then
			eshield_casttarget = a4
			-- self:Print(eshield_casttarget)

			-- Temporarily disable earth shield checking
			if self.eshield.enabled then
				self.eshield.enabled = false
				self:CancelTimer(self.eshield.TimerEvent, false)
			end
			self:ScheduleTimer(self.eshield_checkTarget, 1, self)
		end
	end
end

--function ShamanFriend:ESSetTarget(t)
--	eshield_target = t
--end

function ShamanFriend:READY_CHECK()
	if not (UnitIsDeadOrGhost("player")) then
		if self.db.profile.alert.readycheck then
			self:CheckShield()
		end
		if self.db.profile.eshield.readycheck then
			self:CheckEShield()
		end
	end
end

function ShamanFriend:PLAYER_REGEN_DISABLED()
	if not (UnitIsDeadOrGhost("player")) then
		if self.db.profile.alert.entercombat then
			self:CheckShield()
		end
		if self.db.profile.eshield.entercombat then
			self:CheckEShield()
		end
	end
end

function ShamanFriend:PLAYER_REGEN_ENABLED()
	if not (UnitIsDeadOrGhost("player")) then
		if self.db.profile.alert.aftercombat then
			self:CheckShield()
		end
		if self.db.profile.eshield.aftercombat then
			self:CheckEShield()
		end
	end
	if (eshield_id and self.db.profile.eshield.enable) then
		-- self:Print("Updating Earth Shield in PLAYER_REGEN_ENABLED")
	 	self:eshield_SetTarget(eshield_target)
		self:eshield_BuffCheck()
	end
	if DelayedUnitUpdate then
		self:UpdateUnits()
	end
end

function ShamanFriend:PLAYER_ENTERING_WORLD()
	ShamanFriend:ZoneCheck();
end

function ShamanFriend:ZoneCheck()
	local inInstance, instanceType = IsInInstance();

	self.announce = true
	self.zonetype = instanceType

	if instanceType == "pvp" then
		if self.db.profile.display.bgannounce == "none" then
			self.announce = false
		end
	elseif instanceType == "arena" then
	 	if self.db.profile.display.arenaannounce == false then
			self.announce = false
		end
	elseif instanceType == "party" then
	 	if self.db.profile.display.partyannounce == false then
			self.announce = false
		end
	elseif instanceType == "raid" then
	 	if self.db.profile.display.raidannounce == false then
			self.announce = false
		end
	else
		if self.db.profile.display.worldannounce == false then
			self.announce = false
		end
	end
end

function ShamanFriend:Announce(msg, chatType, language, channel)
	if self.announce == false then
		return
	end

	local inst_flag, zonetype = IsInInstance()
	-- self:Print("inst: " .. inst_flag)
	local name, inst_type, diff_index = GetInstanceInfo()
	-- self:Print("name: " .. name .. " type: " .. tostring(inst_type) .. " diff: " .. diff_index)

	if zonetype == "pvp" then
		-- Battlegrounds need to be handled specially
		if self.db.profile.display.bgannounce == "BATTLEGROUND" then
			-- 5.1 is now INSTANCE_CHAT
			chatType = "INSTANCE_CHAT"
		elseif self.db.profile.display.bgannounce == "PARTY" then
			-- RealNumPartyMembers
			if GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
				chatType = "PARTY"
			else
				return
			end
		elseif self.db.profile.display.bgannounce == "none" then
			return
		end
	elseif zonetype == "party" then
		-- As of 5.1 Instances need to be handled specially
		if chatType == "RAID" or chatType == "PARTY" then
			chatType = "INSTANCE_CHAT"
		end
	elseif zonetype == "raid" then
		-- self:Print("Debug: Announce in raid instance")
		-- As of 5.1 LFR needs to be handled specially
		-- Flex Raids should also use INSTANCE_CHAT over raid chat
		if raid_ic_ids[diff_index] then
			-- self:Print("Debug: Announce in LFR")
			if chatType == "RAID" then
				-- Put to instance chat
				chatType = "INSTANCE_CHAT"
			elseif chatType == "PARTY" then
				if GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
					-- Actually in a party
					chatType = "PARTY"
				else
					return
				end
			end
		end
	elseif zonetype == "scenario" then
		-- As of 5.1 Scenarios need to be handled specially
		-- For a Scenario:
		-- inst_flag is 1 (is an instance)
		-- inst_type is nil
		-- diff_index is 1 (normal)
		-- self:Print("Debug: Announce in Scenario instance")
		if chatType == "RAID" or chatType == "PARTY" then
			chatType = "INSTANCE_CHAT"
		end
	end

	-- self:Print("announce: " .. tostring(self.announce) .. " chatType: " .. chatType)

	SendChatMessage(msg, chatType, language, channel);
end

function ShamanFriend:CheckShield()
	-- if not (UnitBuff("player", lN["Lightning Shield"]) or UnitBuff("player", lN["Water Shield"]) or UnitBuff("player", lN["Earth Shield"], nil, "player")) then
	-- Only check for player shield buffs if one has the Lightning Shield talent and alert is enabled
	if not self.db.profile.alert.shield or not ls_id then
		return
	end
	if not UnitBuff("player", lN["Lightning Shield"]) then
 		if not (self.db.profile.alert.mounted and IsMounted()) then
 			if not (self.db.profile.alert.vehicle and UnitInVehicle("player")) then
 				self:Message(L["Missing: Elemental Shield"], "alert")
 			end
 		end
 	end
end

function ShamanFriend:CheckEShield()
	-- Don't alert about missing Earth Shield when solo
	if self:IsSolo() then
		return
	end

	if eshield_id and self.db.profile.eshield.enable then
		local buff = UnitBuff(eshield_target, lN["Earth Shield"], nil, "player")
		if not buff then
			if not (self.db.profile.alert.mounted and IsMounted()) then
				if not (self.db.profile.alert.vehicle and UnitInVehicle("player")) then
					self:Message(L["Missing: Earth Shield"], "eshield")
				end
			end
		end
	end
end

function ShamanFriend:Message(str, type)
	local c, t
	if type == "wf" then
		c = self.db.profile.wf.display.color
		t = self.db.profile.wf.display.time
		opt_sound = "none"
	elseif type == "alert" then
		c = self.db.profile.alert.display.color
		t = self.db.profile.alert.display.time
		opt_sound = self.db.profile.alert.sound
	elseif type == "spell" then
		c = self.db.profile.spell.display.color
		t = self.db.profile.spell.display.time
		opt_sound = "none"
	elseif type == "lo" then
		c = self.db.profile.lo.display.color
		t = self.db.profile.lo.display.time
		opt_sound = "none"
	elseif type == "misc" then
		c = self.db.profile.misc.display.color
		t = self.db.profile.misc.display.time
		opt_sound = "none"
	elseif type == "eshield" then
		c = self.db.profile.eshield.display.color
		t = self.db.profile.eshield.display.time
		opt_sound = self.db.profile.eshield.sound
	elseif type == "cc" then
		c = self.db.profile.cc.display.color
		t = self.db.profile.cc.display.time
		opt_sound = self.db.profile.cc.sound
	elseif type == "proc" then
		c = self.db.profile.alert.display.color
		t = self.db.profile.alert.display.time
		opt_sound = self.db.profile.alert.proc_sound
	end
	if (type == "wf" and self.db.profile.wf.display.frames) or ((type == "alert" or type == "proc") and self.db.profile.alert.display.frames) or (type == "spell" and self.db.profile.spell.display.frames) or (type == "lo" and self.db.profile.lo.display.frames) or (type == "misc" and self.db.profile.misc.display.frames) or (type == "eshield" and self.db.profile.eshield.display.frames) or (type == "cc" and self.db.profile.cc.display.frames) then
		if self.db.profile.display.chat then
			if self.db.profile.display.number == 0 then
				self:Print(str)
			else
				local chatframe = getglobal("ChatFrame" .. self.db.profile.display.number)
				chatframe:AddMessage(str, c.r, c.g, c.b)
			end
		end
		if self.db.profile.display.screen then
			UIErrorsFrame:AddMessage(str, c.r, c.g, c.b, 1, t)
		end
		if self.db.profile.display.frame then
			if t ~= 5 then
				self.msgFrame:SetTimeVisible(t)
			end
			self.msgFrame:AddMessage(str, c.r, c.g, c.b, 1, t)
		end
	end
	if ((type == "wf" and self.db.profile.wf.display.scroll) or ((type == "alert" or type == "proc") and self.db.profile.alert.display.scroll) or (type == "spell" and self.db.profile.spell.display.scroll) or (type == "lo" and self.db.profile.lo.display.scroll) or (type == "misc" and self.db.profile.misc.display.scroll) or (type == "eshield" and self.db.profile.eshield.display.scroll) or (type == "cc" and self.db.profile.cc.display.scroll)) then
		-- Use LibSink to handle scrolling text
		self:Pour(str, c.r, c.g, c.b)
	end
	
	self:Play(opt_sound)
end

function ShamanFriend:Play(sound_arg)
	if (sound_arg == "None") then
		return
	end

	local sound = LSM:Fetch("sound", sound_arg) 
	PlaySoundFile(sound, ShamanFriend.db.profile.soundchannel)

	-- local sound = sounds[sound_arg]
	-- if (not sound) then
	-- 	return
	-- end

	-- if string.find(sound, "%\\") then
	-- 	PlaySoundFile(sound, ShamanFriend.db.profile.soundchannel)
	-- else
	-- 	PlaySound(sound, ShamanFriend.db.profile.soundchannel)
	-- end
end

function ShamanFriend:SinkPrint(addon, message, r, g, b)
	-- The custom frame also gets created if it is set as a Sink
	-- from a scrolling output addon
 	if not self.msgFrame then self:CreateCustomFrame() end
 	self.msgFrame:AddMessage(message, r, g, b, 1, UIERRORS_HOLD_TIME)
end

function ShamanFriend:CreateCustomFrame()
	-- Sinks also create the custom frame, without having it enabled
	-- if not self.db.profile.display.frame then
	-- 	return
	-- end

	self.dragButton = CreateFrame("Button","ShamanFriend_dragButton",UIParent)
	self.dragButton.owner = self
	self.dragButton:Hide()
	self.dragButton:ClearAllPoints()
	self.dragButton:SetWidth(250)
	self.dragButton:SetHeight(20)
	
	if self.db.profile.display.x and self.db.profile.display.y then
		--local s = self.dragButton:GetEffectiveScale()
		--self.dragbutton:ClearAllPoints()
		--self.dragButton:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.display.x / s, self.db.profile.display.y / s)
		self.dragButton:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.display.x, self.db.profile.display.y)
	else 
		self.dragButton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	end	
	
	self.dragButton:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.dragButton:SetBackdropColor(0,0,0.3,.6)	
	
	self.dragButton:SetMovable(true)
	self.dragButton:RegisterForDrag("LeftButton")
	self.dragButton:SetScript("OnDragStart", function() ShamanFriend.dragButton:StartMoving() end )
	self.dragButton:SetScript("OnDragStop",
		function()
			ShamanFriend.dragButton:StopMovingOrSizing()
			self.db.profile.display.x = ShamanFriend.dragButton:GetLeft()
			self.db.profile.display.y = ShamanFriend.dragButton:GetTop()
		end
	)

	self.msgFrame = CreateFrame("MessageFrame","ShamanFriend_msgFrame")
	self.msgFrame.owner = self
	self.msgFrame:ClearAllPoints()
	self.msgFrame:SetWidth(400)
	self.msgFrame:SetHeight(75)
	self.msgFrame:SetPoint("TOP", self.dragButton, "TOP", 0, 0)
	self.msgFrame:SetInsertMode("TOP")
	self.msgFrame:SetFrameStrata("HIGH")
	self.msgFrame:SetToplevel(true)

	self.msgText = self.dragButton:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
	self.msgText:SetText("ShamanFriend Display")
	self.msgText:SetPoint("TOP", self.dragButton, "TOP", 0, -5)

	self:UpdateLock()
	self:UpdateFont()
	
	self.msgFrame:Show()
end

function ShamanFriend:ResetDisplayPos()
	-- self:Print("In ResetDisplayPos")
	local lock = false
	if self.db.profile.display.lock then
		lock = true
		self.db.profile.display.lock = false
		self:UpdateLock()
	end
	self.db.profile.display.x = nil
	self.db.profile.display.y = nil
	self.dragButton:Hide()
	self.dragButton:ClearAllPoints()
	self.dragButton:SetWidth(250)
	self.dragButton:SetHeight(20)
	self.dragButton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	self.msgFrame:ClearAllPoints()
	self.msgFrame:SetWidth(400)
	self.msgFrame:SetHeight(75)
	self.msgFrame:SetPoint("TOP", self.dragButton, "TOP", 0, 0)
	if lock then
		self.db.profile.display.lock = true
	end
	self:UpdateLock()
	self.msgFrame:Show()
end

function ShamanFriend:UpdateFont()
	if self.db.profile.display.frame and self.msgFrame then
		local font = LSM:Fetch("font", self.db.profile.display.fontFace) 
		self.msgFrame:SetFont(font, self.db.profile.display.fontSize,self.db.profile.display.fontEffect)
		-- self.msgFrame:SetFont("Fonts\\" .. self.db.profile.display.fontFace, self.db.profile.display.fontSize,self.db.profile.display.fontEffect)
		
		--if self.db.profile.display.fontSize == "small" then
		--	self.msgFrame:SetFontObject(GameFontNormalSmall)
		--elseif self.db.profile.display.fontSize == "normal" then
		--	self.msgFrame:SetFontObject(GameFontNormal)
		--elseif self.db.profile.display.fontSize == "large" then
		--	self.msgFrame:SetFontObject(GameFontNormalLarge)
		--elseif self.db.profile.display.fontSize == "huge" then
		--	self.msgFrame:SetFontObject(GameFontNormalHuge)
		--end
	end
end

function ShamanFriend:UpdateLock()
	if self.db.profile.display.frame and self.msgFrame then
		if self.db.profile.display.lock and not self.configMode then
			self.dragButton:SetMovable(false)
			self.dragButton:RegisterForDrag()
			self.msgFrame:SetBackdrop(nil)
			self.msgFrame:SetBackdropColor(0,0,0,0)
			self.dragButton:Hide()
		else
			self.dragButton:Show()
			self.dragButton:SetMovable(true)
			self.dragButton:RegisterForDrag("LeftButton")
			self.msgFrame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			})
			self.msgFrame:SetBackdropColor(0,0,0.3,.3)
		end
	end
	self:SetButtonMode()
end

-- This should still work in Legion with PvP talent
-- Will need to test
-- Find Earth Shield spell id if it exists
function ShamanFriend:FindEshieldId()
	local i
	eshield_id = nil

	local currentSpec = GetSpecialization()
	-- Shaman specs: 1) Elemental, 2) Enhancement, 3) Restoration

	if currentSpec ~= 3 then
		return
	end

	-- tab 1 is general
	-- tab 2 is current spec (resto)
	local tabName, tabTexture, tabOffset, tabSlots, tabIsGuild, tabOffSpecID = GetSpellTabInfo(2);
 
	-- Cycle through specialization spell tab and extra spells for cooldown usage
	for i = tabOffset+1, tabSlots+tabOffset do
		local spellType, spellID = GetSpellBookItemInfo( i, BOOKTYPE_SPELL );
		if eshield_ids[spellID] then
			eshield_id = i
			-- self:Print("eshield_id: "..eshield_id)
		end
	end
	-- self:Print(eshield_id)
end

function ShamanFriend:CreateEshieldFrame()
	if eshield_id == nil then
		return
	end
	
	self.eshieldFrame = CreateFrame("Frame","ShamanFriend_eshield",UIParent)
	self.eshieldFrame.owner = self
	self.eshieldFrame:ClearAllPoints()
	self.eshieldFrame:SetWidth(170)
	self.eshieldFrame:SetHeight(54)
--	self.eshieldFrame:SetFrameStrata("DIALOG")
	self.eshieldFrame:SetFrameStrata("MEDIUM")
	self.eshieldFrame:SetToplevel(true)
	self.eshieldFrame:SetMovable(true)
	self.eshieldFrame:RegisterForDrag("LeftButton")
	self.eshieldFrame:SetScript("OnDragStart",
		function()
			if (not self.db.profile.eshield.lock) or self.configMode then
				ShamanFriend.eshieldFrame:StartMoving()
			end
		end
	)
	self.eshieldFrame:SetScript("OnDragStop",
		function()
			ShamanFriend.eshieldFrame:StopMovingOrSizing()
			self.db.profile.eshield.x = ShamanFriend.eshieldFrame:GetLeft()
			self.db.profile.eshield.y = ShamanFriend.eshieldFrame:GetTop()
		end
	)
	
	if self.db.profile.eshield.x and self.db.profile.eshield.y then
		self.eshieldFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.eshield.x, self.db.profile.eshield.y)
	else 
		self.eshieldFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	end	
	
	self.eshieldHeader = self.eshieldFrame:CreateFontString(nil, "OVERLAY")
	self.eshieldHeader.owner = self
	
	self.eshieldInfo = self.eshieldFrame:CreateFontString(nil, "OVERLAY")
	self.eshieldInfo.owner = self

	self:SetButtonMode()

	self.eshieldButton = CreateFrame("Button", "ShamanFriend_eshieldButton", self.eshieldFrame, "SecureActionButtonTemplate")
	self.eshieldButton.class = self
	self.eshieldButton:SetPoint("TOPRIGHT", self.eshieldFrame, "TOPLEFT", 0, 0)
	self.eshieldButton:SetWidth(36)
	self.eshieldButton:SetHeight(36)
--	self.eshieldButton:SetFrameStrata("DIALOG")
	self.eshieldButton:SetFrameStrata("MEDIUM")
	self.eshieldButton:SetToplevel(true)
	self.eshieldButton:HookScript("OnEnter", ShamanFriend.ShowTooltip)
	self.eshieldButton:HookScript("OnLeave", ShamanFriend.HideTooltip)
	
	--self.eshieldButton:SetNormalTexture(GetSpellTexture("Healing Wave"))
	--self.eshieldButton:SetNormalTexture(GetSpellTexture(lN["Earth Shield"]))
	--self.eshieldButton:SetNormalTexture("")
	
	self.eshieldButton.texture = self.eshieldButton:CreateTexture(nil, "ARTWORK")
	--self.eshieldButton.texture:SetTexture(GetSpellTexture("Healing Wave"))
	self.eshieldButton.texture:SetTexture(GetSpellTexture(lN["Earth Shield"]))
	self.eshieldButton.texture:SetPoint("TOPLEFT", self.eshieldButton, "TOPLEFT", 3, -3)
	self.eshieldButton.texture:SetPoint("BOTTOMRIGHT", self.eshieldButton, "BOTTOMRIGHT", -3, 3)
	self.eshieldButton.texture:SetTexCoord(0.10, 0.90, 0.10, 0.90)
	
	self.eshieldButton_shadow = CreateFrame("Frame", "ShamanFriend_eshieldButton_shadow", self.eshieldButton)
	--frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 1, edgeFile = "", edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0},})
	self.eshieldButton_shadow:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 8, edgeSize = 9,
			insets = { left = 2, right =2, top = 2, bottom = 2 }
		})
	self.eshieldButton_shadow:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
	self.eshieldButton_shadow:SetAllPoints(self.eshieldButton)
	self.eshieldButton_shadow:SetFrameLevel(0)
	
	self.eshieldButton.Cooldown = CreateFrame("Cooldown", "ShamanFriend_eshieldButton_cooldown", self.eshieldButton, "CooldownFrameTemplate");
	
	self.eshield_target = "target"
	self:eshield_SetTarget("target")
	
	self:eshield_SetText("-","-")

	self.eshieldFrame:Show()
end

function ShamanFriend:ResetEShieldPos()
	local lock = false
	if self.db.profile.eshield.lock then
		lock = true
		self.db.profile.eshield.lock = false
	end
	self.db.profile.eshield.x = nil
	self.db.profile.eshield.y = nil
	if (self.eshieldFrame) then
		self.eshieldFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	end
	if lock then
		self.db.profile.eshield.lock = true
	end
	self:SetButtonMode()
end

function ShamanFriend:SetButtonMode()
	if (not self.eshieldFrame) then
		return
	end

	self.eshieldFrame:ClearAllPoints()
	if self.db.profile.eshield.x and self.db.profile.eshield.y then
		self.eshieldFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.eshield.x, self.db.profile.eshield.y)
	else 
		self.eshieldFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	end

	if (ShamanFriend.db.profile.eshield.notooltip and
	    ShamanFriend.db.profile.eshield.lock and not ShamanFriend.configMode) then
		self.eshieldFrame:EnableMouse(false)
	else
		self.eshieldFrame:EnableMouse(true)
	end

	self.eshieldFrame:Hide()
	if (self.db.profile.eshield.button) then
		self.eshieldFrame:SetWidth(36)
		self.eshieldFrame:SetHeight(36)
		if (ShamanFriend.db.profile.eshield.lock) then
			self.eshieldFrame:SetBackdrop(nil)
			self.eshieldFrame:SetBackdropColor(0,0,0,0)
		else
			self.eshieldFrame:SetBackdrop({
					bgFile = "Interface/Tooltips/UI-Tooltip-Background",
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = true, tileSize = 8, edgeSize = 9,
					insets = { left = 2, right =2, top = 2, bottom = 2 }
				})
			self.eshieldFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
		end

		self.eshieldInfo:SetFontObject(GameFontNormalLarge)
		self.eshieldInfo:ClearAllPoints()
		self.eshieldInfo:SetTextColor(1, 1, 1, 1)
		self.eshieldInfo:SetWidth(36)
		self.eshieldInfo:SetHeight(36)
		self.eshieldInfo:SetPoint("TOP", self.eshieldFrame, "TOP",0,0)
		self.eshieldInfo:SetJustifyH("LEFT")
		self.eshieldInfo:SetJustifyV("MIDDLE")

		self:eshield_SetText("-","-")
		self:eshield_BuffCheck()
		-- self:Print("SetButtonMode Hide")
		self.eshieldFrame:Show()
		self.eshieldHeader:Hide()
		self.eshieldInfo:Show()
	else
		self.eshieldFrame:SetWidth(170)
		self.eshieldFrame:SetHeight(54)
		self.eshieldFrame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true, tileSize = 8, edgeSize = 9,
				insets = { left = 2, right =2, top = 2, bottom = 2 }
			})
		self.eshieldFrame:SetBackdropColor(0.1,0.1,0.1,0.9)

		self.eshieldHeader:SetFontObject(GameFontNormalSmall)
		self.eshieldHeader:ClearAllPoints()
		self.eshieldHeader:SetWidth(170)
		self.eshieldHeader:SetHeight(12)
		self.eshieldHeader:SetPoint("TOP", self.eshieldFrame, "TOP",0,-2)
		self.eshieldHeader:SetJustifyH("CENTER")
		self.eshieldHeader:SetJustifyV("TOP")
		self.eshieldHeader:SetText(L["Shaman Friend ES Tracker"])

		self.eshieldInfo:SetFontObject(GameFontNormalSmall)
		self.eshieldInfo:ClearAllPoints()
		self.eshieldInfo:SetTextColor(1, 1, 1, 1)
		self.eshieldInfo:SetWidth(130)
		self.eshieldInfo:SetHeight(36)
		self.eshieldInfo:SetPoint("TOP", self.eshieldHeader, "BOTTOM",0,0)
		self.eshieldInfo:SetJustifyH("LEFT")
		self.eshieldInfo:SetJustifyV("MIDDLE")

		self:eshield_SetText("-","-")
		self:eshield_BuffCheck()

		-- self:Print("SetButtonMode Show")
		self.eshieldFrame:Show()
		self.eshieldHeader:Show()
		self.eshieldInfo:Show()
	end
end

-- Earth Shield Tooltip
-- Do not use "self" in this function (lua error)
function ShamanFriend:ShowTooltip()
	if (ShamanFriend.db.profile.eshield.notooltip) then
		return
	end

	if (eshield_id and ShamanFriend.db.profile.eshield.enable) then
		GameTooltip:SetOwner(ShamanFriend.eshieldButton,ANCHOR_LEFT)
		GameTooltip:SetSpellBookItem(eshield_id, BOOKTYPE_SPELL)
		-- GameTooltip:SetHyperlink(GetSpellLink(lN["Earth Shield"]))
	end
end

function ShamanFriend:HideTooltip()
	GameTooltip:Hide()
end

function ShamanFriend:eshield_SetText(eshield_text_charges, eshield_text_time)
	if eshield_target == L["Outside group"] then
		eshield_text_charges = "-"
		eshield_text_time = "-"
		if (self.db.profile.eshield.button) then
			if eshield_text_charges == "-" then
				eshield_text_charges = ""
			end
			self.eshieldInfo:SetText(eshield_text_charges)
		else
			self.eshieldInfo:SetText(L["Charges: "] .. eshield_text_charges .. "|n" .. L["Time: "] .. eshield_text_time .. "|n" .. L["Target: "] .. "|cffff0000" .. eshield_target .. "|r")
		end
	else
		if (self.db.profile.eshield.button) then
			if eshield_text_charges == "-" then
				eshield_text_charges = ""
			end
			self.eshieldInfo:SetText(eshield_text_charges)
		else
			self.eshieldInfo:SetText(L["Charges: "] .. eshield_text_charges .. "|n" .. L["Time: "] .. eshield_text_time .. "|n" .. L["Target: "] .. eshield_target)
		end
	end
end

function ShamanFriend:eshield_BuffCheck()
	if (not eshield_id or not self.db.profile.eshield.enable) then
		return
	end

	if (not eshield_target) or eshield_target == L["Outside group"] or eshield_target == "-" then
		self:eshield_SetText("-","-")
		-- Don't warn when there is no target or target is outside group
		self:eshield_UpdateBG(3)
	else
		local buff, _, _, count, _, _, expirationTime = UnitBuff(eshield_target, lN["Earth Shield"], nil, "player")

		if buff == lN["Earth Shield"] then
			if expirationTime == nil then
				expirationTime = "|cff999999Unavailable|r"
			else
				expirationTime = math.ceil((expirationTime - GetTime()) / 60) .. L[" min"]
			end

			self:eshield_SetText(count,expirationTime )
			self:eshield_UpdateBG(count)
		else
			self:eshield_SetText("-","-")
			self:eshield_UpdateBG(0)
		end
	end
end

-- Update Background color/flash for Earth Shield frame
function ShamanFriend:eshield_UpdateBG(count)
	if (self.db.profile.eshield.button) then
		if (self.db.profile.eshield.lock) then
			self.eshieldFrame:SetBackdropColor(0,0,0,0)
		else
			self:eshield_UpdateBGColor(count)
		end
	else
		self:eshield_UpdateBGColor(count)
	end
	self:eshield_UpdateBGAlpha(count)
end

function ShamanFriend:IsEShieldCheckValid()
	if (not UnitExists(eshield_target)) then
		return false
	elseif (not self:InRange(eshield_target)) then
		return false
	elseif self:IsSolo() then
		-- Don't flash when solo
		return false
	else
		return true
	end
end

function ShamanFriend:eshield_UpdateBGColor(count)
	if (self.db.profile.eshield.bgcolor and self:IsEShieldCheckValid()) then
		if (count > 1) then
			-- black
			self.eshieldFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
		elseif (count == 1) then
			-- yellow
			self.eshieldFrame:SetBackdropColor(1,1,0.1,0.9)
		else
			-- red
			self.eshieldFrame:SetBackdropColor(1,0.1,0.1,0.9)
		end
	else
		self.eshieldFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
	end
end

-- Flash iteration time, fading in and fading out
local FLASH_TIME = 0.7
-- Time to fade in or out
local HALF_FLASH_TIME = FLASH_TIME / 2
local INVERSE_HALF_FLASH_TIME = 1 / HALF_FLASH_TIME

-- UIFrameFlash causes taint, so have to create own function
function ShamanFriend:eshield_UpdateBGAlpha(count)
	-- if (self.db.profile.eshield.button) then
	if (self.db.profile.eshield.flash and count == 0 and self:IsEShieldCheckValid()) then
		if (not self.eshield.flashing) then
			self.eshield.flashing = true
			self.eshield.elapsed = 0
			self.eshieldFrame:SetScript("OnUpdate",
				function(self, elapsed)
					local e = ShamanFriend.eshield.elapsed + elapsed
					ShamanFriend.eshield.elapsed = e
					local alpha = (e % FLASH_TIME) * INVERSE_HALF_FLASH_TIME
					if alpha > 1 then
						alpha = 2 - alpha
					end
 					ShamanFriend.eshieldFrame:SetAlpha(alpha)
				end
			)
		end
	else
	 	self.eshieldFrame:SetAlpha(1)
		-- Cancel any running flash script
		if (self.eshield.flashing) then
			self.eshieldFrame:SetScript("OnUpdate", nil)
			self.eshield.flashing = false
		end
	end
end

function ShamanFriend:eshield_SetTarget(t)
	if not InCombatLockdown() then
		if (self.eshieldButton) then
			self.eshieldButton:SetAttribute("type1", "spell")
			self.eshieldButton:SetAttribute("spell1", lN["Earth Shield"])
			self.eshieldButton:SetAttribute("unit1", t)
			self.eshieldButton.texture:SetVertexColor(1,1,1,1)
		end
		self.eshield_lockdown = false
	end
end

function ShamanFriend:SPELL_UPDATE_COOLDOWN()
	if eshield_id then
		local start, duration, enable = GetSpellCooldown(eshield_id, BOOKTYPE_SPELL);
		CooldownFrame_SetTimer(self.eshieldButton.Cooldown, start, duration, enable);
	end
end

-- This should still work in Legion with PvP talent
-- Will need to test
-- Find Lightning Shield spell id if it exists
function ShamanFriend:FindLshieldId()
	local i
	ls_id = nil

	local currentSpec = GetSpecialization()
	-- Shaman specs: 1) Elemental, 2) Enhancement, 3) Restoration

	if currentSpec ~= 2 then
		return
	end

	-- tab 1 is general
	-- tab 2 is current spec (enh)
	local tabName, tabTexture, tabOffset, tabSlots, tabIsGuild, tabOffSpecID = GetSpellTabInfo(2);
 
	-- Cycle through specialization spell tab and extra spells for cooldown usage
	for i = tabOffset+1, tabSlots+tabOffset do
		local spellType, spellID = GetSpellBookItemInfo( i, BOOKTYPE_SPELL );
		if ls_ids[spellID] then
			ls_id = i
			-- self:Print("ls_id: "..ls_id)
		end
	end
	-- self:Print(ls_id)
end

-- Check if player has Improved Lightning Shield
-- function ShamanFriend:FindISLId()
-- 	local i
-- 	isl_id = nil
-- 
-- 	local currentSpec = GetSpecialization()
	-- Shaman specs: 1) Elemental, 2) Enhancement, 3) Restoration

-- 	if currentSpec ~= 1 then
-- 		return
-- 	end

	-- tab 1 is general
	-- tab 2 is current spec (elemental)
-- 	local tabName, tabTexture, tabOffset, tabSlots, tabIsGuild, tabOffSpecID = GetSpellTabInfo(2);
 
	-- Cycle through specialization spell tab and extra spells for cooldown usage
-- 	for i = tabOffset+1, tabSlots+tabOffset do
-- 		local spellType, spellID = GetSpellBookItemInfo( i, BOOKTYPE_SPELL );
-- 		if isl_ids[spellID] then
-- 			isl_id = i
-- 			-- self:Print("isl_id: "..isl_id)
-- 		end
-- 	end
	-- self:Print(isl_id)
-- end

-- Set the number of fulmination stacks to alert on
-- function ShamanFriend:SetFulmStacks()
-- 	if self.db.profile.alert.fulmstacks == 0 then
-- 		-- autodetect
-- 		if (isl_id) then
-- 			fulm_alertstacks = 20
-- 		else
-- 			fulm_alertstacks = 15
-- 		end
-- 	else
-- 		fulm_alertstacks = self.db.profile.alert.fulmstacks
-- 	end
-- 	-- self:Print("fulm_alertstacks: "..fulm_alertstacks)
-- end

