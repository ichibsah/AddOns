--[[
$Id: DruidFriend.lua 60 2016-07-20 09:40:21Z stassart $

Author: Trelis @ Proudmoore
(addon (a) stassart o org)

Copyright 2011 Benjamin Stassart

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

-- Disable DruidFriend if the player is not a druid
if select(2, UnitClass('player')) ~= "DRUID" then
	DisableAddOn("DruidFriend")
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("DruidFriend")
local AceAddon = LibStub("AceAddon-3.0")

-- Functions marked with "*" are used by DruidFriend
-- AceConsole: Print*, Printf, RegisterChatCommand, UnregisterChatCommand,
--		GetArgs
-- AceEvent: RegisterEvent*, UnregisterEvent, UnregisterAllEvents*
-- AceTimer: ScheduleTimer*, ScheduleRepeatingTimer, CancelTimer, CancelAllTimers, TimeLeft
-- LibSink: Pour*, RegisterSink*, SetSinkStorage, GetSinkAce2OptionsDataTable,
--		GetSinkAce3OptionsDataTable
DruidFriend = AceAddon:NewAddon("DruidFriend",
				"AceConsole-3.0",
				"AceEvent-3.0",
				"AceTimer-3.0",
				"LibSink-2.0")

local LSM = LibStub("LibSharedMedia-3.0")

local meta_version = GetAddOnMetadata("DruidFriend","Version")
-- This doesn't get updated if this file isn't updated
-- local revision = ("$Revision: 60 $"):sub(12, -3)
local revision = GetAddOnMetadata("DruidFriend","X-Curse-Packaged-Version")
DruidFriend.DisplayVersion = ("v%s-%s"):format(meta_version, revision)

-- Add configmode support (i.e. OneButtonConfig)
-- Create the global table if it does not exist yet
CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
-- Declare our handler
CONFIGMODE_CALLBACKS["DruidFriend"] = function(action)
	if action == "ON" then
		DruidFriend.configMode = true
		DruidFriend:UpdateLock()
	elseif action == "OFF" then
		DruidFriend.configMode = false
		DruidFriend:UpdateLock()
	end
end

-- Default Options for DruidFriend
DruidFriend.defaults = {
   profile = {
	display = {
		chat = true,
		number = 0,
		frame = true,
		fontSize = 18,
		fontFace = L["Friz Quadrata TT"], -- default font
		fontEffect = L["OUTLINE"],
		lock = true,
	},
--	buff = {
--		enable = true,
--		readycheck = true,
--		entercombat = true,
--		aftercombat = true,
--		mounted = true,
--		vehicle = true,
--		combat = false,
--		pvp = false,
--		bg = false,
--		arena = true,
--		wg = false,
--		instance = true,
--		raid = true,
--		world = true,
--		frequency = 5,
--		sound = L["Bell"],
--		display = {
--			color = { r=1, g=1, b=1 },
--			scroll = false,
--			frames = true,
--			time = 5,
--		},
--	},
	announce = {
		target = true,
		interrupt = false,
		intchan = "none",
		dispel = false,
		dispelpm = false,
		dispelchan = "none",
		iron = false,
		ironpm = false,
		ironchan = "none",
		irontext = "DF: SPELL cast on TARGET",
		tranquility = false,
		tranqchan = "none",
		tranqtext = "DF: SPELL Meter padding incoming!",
		starfall = false,
		starchan = "none",
		startext = "DF: SPELL The sky is falling! The sky is falling!",
		berserk = false,
		zerkchan = "none",
		zerktext = "DF: SPELL Rawr!",
		-- tankspec = "guardian",
		barkskin = false,
		barkchan = "none",
		barktext = "DF: SPELL",
		survival = false,
		survchan = "none",
		survtext = "DF: SPELL",
		-- savage = false,
		-- frenz = false,
		frequency = 5,
		sound = "None",
		loc = {
			bgannounce = "none",
			arenaannounce = true,
			partyannounce = true,
			raidannounce = true,
			worldannounce = true,
		},
		display = {
			color = { r=1, g=0.5, b=0.7 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	tank = {
		balspec = false,
		feralspec = false,
		guardspec = true,
		restospec = false,
	},
	cc = {
		success = false,
		successtext = "DF: TARGET has SPELL Don't break it!",
		fail = false,
		failtext = "DF: SPELL failed on TARGET: ",
		fade = false,
		fadetext = "DF: TARGET no longer has SPELL!",
		ccchan = "none",
		broken = true,
		brokentext = "DF: SOURCE broke SPELL on TARGET: ",
		brokenchan = "none",
		tanktime = 10,
		sound = "None",
		display = {
			color = { r=0.3, g=1, b=0.1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	absorb = {
		enable = false,
		lock = false,
		icon = true,
		time = true,
		combat = false,
		zero = false,
		-- spec = "guardian",
		balspec = false,
		feralspec = false,
		guardspec = true,
		restospec = false,
	},
	cd = {
		tranq = false,
		starfall = false,
		berserk = false,
		crits = false,
		sound = "None",
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	taunt = {
		enable = false,
		own = false,
		other = false,
		sound = "None",
		pet = false,
		petaggro = false,
		noisypet = false,
		display = {
			color = { r=0.7, g=1, b=0.7 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	soundchannel = "Master",
   }
}

-- Sounds for alerts
-- local sounds = {
-- 	ding = "Sound\\Doodad\\BellTollAlliance.wav",
-- 	dong = "Sound\\Doodad\\BellTollHorde.wav",
-- 	bell = "AuctionWindowClose",
-- 	dodo = "igQuestFailed",
-- }
LSM:Register(LSM.MediaType.SOUND, L["Ding"], "Sound\\Doodad\\BellTollAlliance.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Dong"], "Sound\\Doodad\\BellTollHorde.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Bell"], "Sound\\interface\\AuctionWindowClose.ogg")
LSM:Register(LSM.MediaType.SOUND, L["Dodo"], "Sound\\interface\\igQuestFailed.ogg")

-- COMBAT_LOG_EVENT events that are tracked
local trackedEvents = {}

-- Update raid unit changes after combat to reduce combat lag
-- I don't want this to be one of those addons that causes your UI to freeze
-- whenever someone joins or leaves the raid
local DelayedUnitUpdate = false

-- Buff IDs
-- local motw_ids = {
-- 	[1126] = true, -- "Mark of the Wild",
-- }

-- Strength, Agility, Intellect +5%
-- local stat_ids = {
-- 	[1126] = true, -- "Mark of the Wild",
-- 	[20217] = true, -- "Blessing of Kings" (paladin),
-- 	[90363] = true, -- "Embrace of the Shale Spider" (hunter pet),
-- 	[115921] = true, -- "Legacy of the Emperor" (mistweaver monk),
-- 	[116781] = true, -- "Legacy of the White Tiger" (brewmaster/windwalker monk),
-- 	[159988] = true, -- "Bark of the Wild" (hunter pet),
-- 	[160017] = true, -- "Blessing of Kongs" (hunter pet),
-- 	[160077] = true, -- "Strength of the Earth" (hunter pet),
-- }

-- Versatility +3%
-- local vers_ids = {
-- 	[1126] = true, -- "Mark of the Wild",
-- 	[35290] = true, -- "Indomitable" (hunter pet),
-- 	[50518] = true, -- "Chitinous Armor" (hunter pet),
-- 	[55610] = true, -- "Unholy Aura",
-- 	[57386] = true, -- "Wild Strength" (hunter pet),
-- 	[159735] = true, -- "Tenacity" (hunter pet),
-- 	[160045] = true, -- "Defensive Quills" (hunter pet),
-- 	[160077] = true, -- "Strength of the Earth" (hunter pet),
-- 	[167187] = true, -- "Sanctity Aura",
-- 	[167188] = true, -- "Inspiring Presence" (arms/fury warrior),
-- 	[173035] = true, -- "Grace" (hunter pet),
-- }

-- Interrupt IDs
local interrupt_ids = {
	-- Skull Bash
	[106839] = true,
	-- Solar Beam
	[78675] = true,
}

-- Dispel IDS
local dispel_ids = {
	-- Remove Corruption
	[2782] = true,
	-- Nature's Cure
	[88423] = true,
}

-- Berserk and Incarnation
local zerk_ids = {
	-- Berserk
	[106951] = true,
	-- Incarnation: Guardian of Ursoc
	[102558] = true,
}

-- Spell ids for Spell Names
-- This is used to get localized names for spells
local name_ids = {
	["Tranquility"] = 740,
--	["Mark of the Wild"] = 1126,
--	["Blessing of Kings"] = 20217,
	["Barkskin"] = 22812,
--	["Indomitable"] = 35290,
	["Starfall"] = 191034,
	["Berserk"] = 106951,
--	["Chitinous Armor"] = 50518,
--	["Unholy Aura"] = 55610,
--	["Wild Strength"] = 57386,
	["Survival Instincts"] = 61336,
--	["Embrace of the Shale Spider"] = 90363,
	["Ironbark"] = 102342,
--	["Legacy of the Emperor"] = 115921,
--	["Legacy of the White Tiger"] = 116781,
--	["Frenzied Regeneration"] = 22842, -- buff spell id, not the spellbook entry
--	["Savage Defense"] = 132402, -- buff spell id, not the spellbook entry
--	["Tenacity"] = 159735,
--	["Blessing of Kongs"] = 160017,
--	["Defensive Quills"] = 160045,
--	["Strength of the Earth"] = 160077,
--	["Sanctity Aura"] = 167187,
--	["Inspiring Presence"] = 167188,
--	["Bark of the Wild"] = 169988,
--	["Grace"] = 173035,
}

-- Absorbs that can be on a druid
local absorb_ids = {
	-- Power Word: Shield
	[17] = true,
	-- Divine Aegis
	-- [47753] = true,
	-- Illuminated Healing
	-- [86273] = true,
	-- Trinkets
}

-- Druid Crowd Control
local cc_ids = {
	-- Entangling Roots
	[339] = true,
}

local root_ids = {
	-- Entangling Roots
	[339] = true,
}

-- CC's that can overwrite druid CC's
-- Or CC's that can be combined with druid CC so that if
-- these are still up the mob is not lose and there is no need to alert
-- other players
-- Including other shaman's CC's
-- Not including stuff like Blind and Scatter Shot as they are short duration
local allcc_ids = {
	-- Entangling Roots
	[339] = true,
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

-- Taunt Spells
local taunt_ids = {
	-- Warior
	[355] = true, -- Taunt
	[114192] = true, -- Mocking Banner
	--[114198] = true, -- Mocking Banner (Buff)

	-- Death Knight
	[49576] = true, -- Death Grip
	[56222] = true, -- Dark Command

	-- Paladin
	[62124] = true, -- Reckoning

	-- Druid
	[6795] = true, -- Growl

	-- Hunter
	[20736] = true, -- Distracting Shot

	-- Shaman
	-- [73684] = true, -- Unleash Earth

	-- Warlock

	-- Monk
	[115546] = true, -- Provoke
	[115543] = true, -- Leer of the Ox
}

-- This is used for how the taunt is displayed
local aoetaunt_ids = {
	[114192] = true, -- Mocking Banner
	-- Pet
	[63900] = true, -- Thunderstomp (damage+threat, hunter pet talent)
}

local pettaunt_ids = {
	-- [53477] = true, -- Taunt (True taunt, Hunter pet talent)
	[17735] = true, -- Suffering (True taunt, Voidwalker)
}

local petaggro_ids = {
	[2649] = true, -- Growl (Increases threat, generic hunter pet)
	[63900] = true, -- Thunderstomp (damage+threat, hunter pet talent)
}

-- MapIDs for PvP zones
-- http://www.wowpedia.org/MapID
local pvp_zoneids = {
	[501] = true, -- Wintergrasp
	[708] = true, -- Tol Barad
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

-- Localized names
DruidFriend.lN = {
--	["Bark of the Wild"] = GetSpellInfo(name_ids["Bark of the Wild"]),
	["Barkskin"] = GetSpellInfo(name_ids["Barkskin"]),
	["Berserk"] = GetSpellInfo(name_ids["Berserk"]),
--	["Blessing of Kings"] = GetSpellInfo(name_ids["Blessing of Kings"]),
--	["Blessing of Kongs"] = GetSpellInfo(name_ids["Blessing of Kongs"]),
--	["Chitinous Armor"] = GetSpellInfo(name_ids["Chitinous Armor"]),
--	["Defensive Quills"] = GetSpellInfo(name_ids["Defensive Quills"]),
--	["Embrace of the Shale Spider"] = GetSpellInfo(name_ids["Embrace of the Shale Spider"]),
--	["Grace"] = GetSpellInfo(name_ids["Grace"]),
--	["Indomitable"] = GetSpellInfo(name_ids["Indomitable"]),
--	["Inspiring Presence"] = GetSpellInfo(name_ids["Inspiring Presence"]),
	["Ironbark"] = GetSpellInfo(name_ids["Ironbark"]),
--	["Legacy of the Emperor"] = GetSpellInfo(name_ids["Legacy of the Emperor"]),
--	["Legacy of the White Tiger"] = GetSpellInfo(name_ids["Legacy of the White Tiger"]),
--	["Mark of the Wild"] = GetSpellInfo(name_ids["Mark of the Wild"]),
	["Power Word: Shield"] = GetSpellInfo(17),
--	["Sanctity Aura"] = GetSpellInfo(name_ids["Sanctity Aura"]),
	["Starfall"] = GetSpellInfo(name_ids["Starfall"]),
--	["Strength of the Earth"] = GetSpellInfo(name_ids["Strength of the Earth"]),
	["Survival Instincts"] = GetSpellInfo(name_ids["Survival Instincts"]),
--	["Tenacity"] = GetSpellInfo(name_ids["Tenacity"]),
	["Tranquility"] = GetSpellInfo(name_ids["Tranquility"]),
--	["Unholy Aura"] = GetSpellInfo(name_ids["Unholy Aura"]),
--	["Wild Strength"] = GetSpellInfo(name_ids["Wild Strength"]),
	["Balance"] = select(2, GetSpecializationInfoByID(102)),
	["Feral"] = select(2, GetSpecializationInfoByID(103)),
	["Guardian"] = select(2, GetSpecializationInfoByID(104)),
	["Restoration"] = select(2, GetSpecializationInfoByID(105))
}
-- GetSpecializationInfoByID is available at initialization
-- GetSpecializationInfo is not available until after PLAYER_LOGIN

local lN = DruidFriend.lN

-- Track the last alert of a given type
local AlertTimes = {}

-- Players that have had buffs fade
local BuffFades = {}

-- Pet taunts per combat
local CombatPetTaunt = {}

-- Cooldowns
local tranquing = false
local tranq_crit = 0
local tranq_heals = 0
local berserking = false
local zerk_crit = 0
local zerk_spell
local zerk_dam = 0
local starfall_flag = false
local star_crit = 0
local star_dam = 0

DruidFriend.num_overlay = DruidFriend.num_overlay or 0

-- OnInitialize is called when the addon is loaded
function DruidFriend:OnInitialize()
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	-- Attach to configuration settings
	self.db = LibStub("AceDB-3.0"):New("DruidFriendDB",
			DruidFriend.defaults, "profile")
	-- Load options
	LibStub("AceConfig-3.0"):RegisterOptionsTable("DruidFriend",
		DruidFriend.options, {"druidfriend", "druidf", "df"} )

	-- Add options to Blizzard's Addon Interface
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("DruidFriend",
		"DruidFriend")

	-- Configure what the default options are
	self.db:RegisterDefaults(self.defaults)

	-- Display version number when loading

	self:Print(self.DisplayVersion..L[" Loaded. Use /df for options."])

	-- Announcements enabled?
	-- Can be disabled by zone
	self.announce = true

	-- Current zone
	-- Used to check for PvP zones
	self.zonetype = "none"

	-- ConfigMode (OneButtonConfig) off by default
	self.configMode = false

	-- Loaded?
	self.loaded = false

	-- Upgrade any saved settings that need to be updated
	self:Upgrade()

	-- Initialize variables
	self:InitializeCC()
	self:InitializeAbsorb()

	-- Delete Cata saved variables that have been removed
	-- I will be commenting out this call after MoP has been out for a while, but I may keep the function around
	-- to be called manually
	-- self:DeleteCataSaved()

	-- Register Scrolling Combat Text
	self:RegisterSink("DF", "DruidFriend", nil, "SinkPrint")
end

function DruidFriend:Upgrade()

	-- Always localize sounds
	-- If a sound gets translated, we want the non-translated stored setting
	-- to get updated.
	-- The only thing this won't address is if a translation gets changed
	-- self.db.profile.buff.sound = self:UpgradeSound(self.db.profile.buff.sound)
	self.db.profile.cc.sound = self:UpgradeSound(self.db.profile.cc.sound)
	self.db.profile.taunt.sound = self:UpgradeSound(self.db.profile.taunt.sound)

	if self.db.profile.version then
		self.db.profile.version = meta_version
		return
	end

	-- Fix configuration options that have changed

	-- Fonts
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
function DruidFriend:UpgradeSound(sound)
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

function DruidFriend:InitializeCC()
	self.cc = {}
	self.cc = {
		removetarget = nil,
		removetime = nil,
	}
	self.root = {}
	self.root = {
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

function DruidFriend:InitializeAbsorb()
	-- Create Scanning Tooltip
	CreateFrame( "GameTooltip", "scan", nil, "GameTooltipTemplate" )
	scan:SetOwner( WorldFrame, "ANCHOR_NONE" );
	-- Allow tooltip SetX() methods to dynamically add new lines based on these
	scan:AddFontStrings(
		scan:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
		scan:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
	);

	self.absorb = {}
	self.absorb = {
		total = 0,
		time = 0,
		spellicon = 0,
		timer = false,
		TimerEvent = nil,
	}
end

-- function DruidFriend:DeleteCataSaved()
-- 	self.db.profile.announce.frenzied = nil
-- 	self.db.profile.announce.frenzchan = nil
-- 	self.db.profile.announce.frenztext = nil
-- 	self.db.profile.announce.thorns = nil
-- 	self.db.profile.announce.thornspm = nil
-- 	self.db.profile.announce.thornschan = nil
-- 	self.db.profile.announce.thornstext = nil
-- 	self.db.profile.absorb.sdonly = nil
-- end

-- Called when the user enables the addon
function DruidFriend:OnEnable()
	self:LoadEvents()
	-- self:PrintAssignments()
end

-- Called when the user disables the addon
function DruidFriend:OnDisable()
	self:UnregisterAllEvents()
end

-- Events handled by DruidFriend
function DruidFriend:LoadEvents()
	-- self:Print("In LoadEvents")
	-- Disable all previous events from this addon
	self:UnregisterAllEvents()
	
	trackedEvents = {}

	-- Initially register this event
	if (not self.loaded) then
		self:RegisterEvent("PLAYER_ALIVE")
	end

	-- Always monitor the combatlog
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	-- Detect fading buffs
	-- if (self.db.profile.buff.enable) then
	-- 	trackedEvents["SPELL_AURA_REMOVED"] = true
	-- end

	-- Dispel
	if self.db.profile.announce.dispel then
		trackedEvents["SPELL_DISPEL"] = true
	end

	-- Interrupt
	if self.db.profile.announce.interrupt then
		trackedEvents["SPELL_INTERRUPT"] = true
	end

	-- Spell casts to announce
	if self.db.profile.announce.tranquility or
	   self.db.profile.announce.starfall or
	   self.db.profile.announce.berserk or
	   self.db.profile.announce.barkskin or
	   self.db.profile.announce.survival then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end

	-- Expirations
	if self.db.profile.announce.savage or self.db.profile.announce.frenz then
		trackedEvents["SPELL_AURA_REMOVED"] = true
	end

	-- Ready Check
	-- if (self.db.profile.buff.enable) then
	-- 	self:RegisterEvent("READY_CHECK")
	-- end

	-- Enter combat
	-- if (self.db.profile.buff.enable) or
	if (self.db.profile.absorb.enable and self.db.profile.absorb.combat) then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	-- After combat
	-- if (self.db.profile.buff.enable) or
	if (self.db.profile.cc.broken) or
	   (self.db.profile.absorb.enable and self.db.profile.absorb.combat) or
	   (self.db.profile.taunt.enable and (self.db.profile.taunt.pet or self.db.profile.taunt.petaggro)) then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	-- CC
	if self.db.profile.cc.success then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
	end
	if self.db.profile.cc.fail then
		trackedEvents["SPELL_MISSED"] = true
	end
	if self.db.profile.cc.fade then
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
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", "UpdateUnits")
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateUnits")
	end

	-- If we are not showing the absorb tracker
	-- in both specs, then we need to detect spec changes
	-- The tank announcements don't need to detect spec changes
	-- they check current spec before announcing
	if self.db.profile.absorb.enable and (self.db.profile.absorb.spec ~= "both") then
		self:RegisterEvent("LEARNED_SPELL_IN_TAB")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	end

	-- Absorb Tracker
	if self.db.profile.absorb.enable then
		-- self:Print("Enable Absorb Tracker")
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REFRESH"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
		trackedEvents["SWING_MISSED"] = true
		trackedEvents["SPELL_MISSED"] = true
		trackedEvents["SPELL_PERIODIC_MISSED"] = true

		if (not self.absorbFrame) and self:CheckAbsorbSpec() then
			-- self:Print("CheckSpec passed")
			self:CreateAbsorbFrame()
		-- else
			-- If we are pre-PLAYER_ALIVE event we can get a false failure here
			-- self:Print("CheckSpec failed")
		end
	end
	-- This also hides it if it is no longer enabled
	self:AbsorbUpdate()

	-- Cooldowns
	if self.db.profile.cd.tranq then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_HEAL"] = true
		-- trackedEvents["SPELL_PERIODIC_HEAL"] = true
	end
	if self.db.profile.cd.berserk or
	   self.db.profile.cd.starfall then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_AURA_REMOVED"] = true
		trackedEvents["SPELL_DAMAGE"] = true
	end

	-- Taunt Tracker
	if self.db.profile.taunt.enable then
		trackedEvents["SPELL_AURA_APPLIED"] = true
		trackedEvents["SPELL_CAST_SUCCESS"] = true
	end

	-- Can disable announcements by zone
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	DruidFriend:ZoneCheck();

	-- Custom Message Frame
	if (not self.msgFrame) and self.db.profile.display.frame then
		self:CreateCustomFrame()
	end
end

function DruidFriend:LEARNED_SPELL_IN_TAB(event, Tab)
	if self.loaded then
		-- self:Print("detected a new spell")
		self:LoadEvents()
	end
end

function DruidFriend:ACTIVE_TALENT_GROUP_CHANGED(event, newGroup, prevGroup)
	if self.loaded then
		-- self:Print("detected a talent spec change")
	   	self:LoadEvents()
	end
end

function DruidFriend:PLAYER_ALIVE(event)
	-- self:Print("login complete")
	self:LoadEvents()
end

-- If set to raid, and in a party instead reverts to party
-- If set to raid or party and not in a party, does not output
function DruidFriend:ChatChannel(chat)
	if chat == "RAID" and not UnitInRaid("player") then
		chat = "PARTY"
	end
	if chat == "PARTY" and GetNumSubgroupMembers() == 0 then
		chat = "none"
	end

	-- self:Print("ChatChannel: " .. chat)
	return chat;
end

-- Process combat log events
function DruidFriend:COMBAT_LOG_EVENT_UNFILTERED(e,
   timestamp,
   event,
   hideCaster,
   sourceGUID,
   sourceName,
   sourceFlags,
   sourceRaidFlags,
   destGUID,
   destName,
   destFlags,
   destRaidFlags,
   ...)
	local substring

	-- If druid is dead, don't issue warnings
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- End if it isn't an event we care about
	if not trackedEvents[event] then
		-- self:Print("NOT tracked")
		-- self:Print(timestamp, event, sourceGUID, sourceName,
		--		sourceFlags, destGUID, destName, destFlags)
		-- self:Print(...)
		return
	end

	if event == "SPELL_AURA_REMOVED" then
	 	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		-- self:Print(sourceGUID .. " " .. UnitGUID("player"))
		-- self:Print("sid: " .. select(1,...))
		-- It doesn't matter whose Kings/Motw faded, let player know so that they can rebuff
		-- if self.db.profile.buff.enable and (stat_ids[select(1,...)] or vers_ids[select(1,...)]) then
		-- 	if self:IsBuffCheckEnabled() then
		-- 		-- Was it replaced by a new Kings/MotW?
		-- 		-- When a player dies, the buffs are removed right before
		-- 		-- they die, so we need to delay checking to see if they died
		-- 		BuffFades[destName] = select(2,...)
		-- 		self:ScheduleTimer(self.CheckFades, 1, self)
		-- 	end
		-- end
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
		elseif destGUID == UnitGUID("player") and absorb_ids[select(1,...)] then
			if self.db.profile.absorb.enable then
				self:AbsorbUpdate()
			end
		elseif sourceGUID == UnitGUID("player") and zerk_ids[select(1,...)] then
			if (self.db.profile.cd.berserk and berserking) then
				self:BerserkReport()
			end
		elseif sourceGUID == UnitGUID("player") and select(1,...) == name_ids["Starfall"] then
			if (self.db.profile.cd.starfall and starfall_flag) then
				-- Delay Starfall report 1 second from when the buff falls off
				-- Sometimes the final damage events come right after the fade
				self:ScheduleTimer(self.StarfallReport, 1, self)
			end
		-- elseif destGUID == UnitGUID("player") and select(1,...) == name_ids["Savage Defense"] then
		-- 	if self.db.profile.announce.savage then
		-- 		self:Message(string.format("%s %s",select(2,...),L["expired"]),"announce")
		-- 	end
		-- elseif destGUID == UnitGUID("player") and select(1,...) == name_ids["Frenzied Regeneration"] then
		-- 	-- Glyph of Frenzied Regeneration expiration
		-- 	if self.db.profile.announce.frenz then
		-- 		self:Message(string.format("%s %s",select(2,...),L["expired"]),"announce")
		-- 	end
		end
	elseif event == "SPELL_AURA_APPLIED" then
	 	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		if self.db.profile.announce.iron and select(1,...) == name_ids["Ironbark"] then
			if sourceGUID == UnitGUID("player") then
				if self.announce then
					-- Replace TARGET in string with the actual target
					local substring = string.gsub(self.db.profile.announce.irontext, "TARGET", destName)
					self:SpellCastAnnounce(select(1,...), select(2,...), substring, self.db.profile.announce.ironchan)
				end
				if self.db.profile.announce.ironpm then
					-- Replace SPELL in string with the actual spell
					-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(1,...) .. "\124h[" .. select(2,...) .. "]\124h\124r"
					local spellstring = GetSpellLink(select(1,...))
					local substring = string.gsub(self.db.profile.announce.irontext, "SPELL", spellstring)
					-- Replace TARGET with "you" for whispers
					substring = string.gsub(substring, "TARGET", L["you"])
					self:Whisper(substring,destName)
				end
			end
		elseif sourceGUID == UnitGUID("player") and cc_ids[select(1,...)] then
			local ccannounce = true
			if root_ids[select(1,...)] then
				self.root.enabled = true
				self.root.target = destGUID
				self.root.dead = false
				-- Do not reset time or announce if reapplying CC to the same target
				if (self.root.target == self.root.lasttarget) then
					ccannounce = false
				else
					self.root.time = timestamp
					self.root.lasttarget = destGUID
				end
				self.root.breaksource = nil
				self.root.breakspell = nil
				self.root.expiration = self:GetExpiration(timestamp, select(2,...), destGUID, 30)
			end
			if (self:GetCC(destGUID, select(1,...))) then
				-- Do not announce if the target is already CC'd by another player
				-- self:Print("already CC")
				ccannounce = false
			elseif (destGUID == self.cc.removetarget and (self.cc.removetime + 1) >= timestamp) then
				-- Do not announce if CC was just removed from that target
				-- For example, if we root a target that was polymorphed
				ccannounce = false
			-- elseif (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
			-- 	ccannounce = false
			end
			if ccannounce and self.db.profile.cc.success and self:ChatChannel(self.db.profile.cc.ccchan) ~= "none" then
				-- Replace TARGET in string with the actual target
				local substring = string.gsub(self.db.profile.cc.successtext, "TARGET", destName)
				self:SpellCastAnnounce(select(1,...), select(2,...), substring, self.db.profile.cc.ccchan)
			end
		elseif destGUID == UnitGUID("player") and absorb_ids[select(1,...)] then
			if self.db.profile.absorb.enable then
				self:AbsorbUpdate()
			end
		elseif sourceGUID == UnitGUID("player") and select(1,...) == name_ids["Tranquility"] then
			if (self.db.profile.cd.tranq and not tranquing) then
				-- Start of Tranquility
				-- self:Print("Start of Tranq")
				tranquing = true
				tranq_crit = 0
				tranq_heals = 0
				-- The initial tranq lasts 8 seconds (minus haste)
				-- No hots for tranq in Legion
				self:ScheduleTimer(self.TranqReport, 10, self)
			end
		elseif sourceGUID == UnitGUID("player") and zerk_ids[select(1,...)] then
			if (self.db.profile.cd.berserk and not berserking) then
				-- Start of Berserk
				berserking = true
				zerk_spell = select(2,...)
				zerk_crit = 0
				zerk_dam = 0
			end
		elseif sourceGUID == UnitGUID("player") and select(1,...) == name_ids["Starfall"] then
			if (self.db.profile.cd.starfall and not starfall_flag) then
				-- Start of Starfall
				starfall_flag = true
				star_crit = 0
				star_dam = 0
			end
		elseif self.db.profile.taunt.enable and self:CheckTaunt(sourceGUID, select(1,...)) then
			-- Unleash Earth can only be checked for with SPELL_AURA_APPLIED
			-- The Unleash Elements cast is the same no matter which weapon enchant
			if select(1,...) == 73684 then
				local msg = string.format(L["%s taunted %s using %s"], sourceName, destName, select(2,...))
				self:Message(msg, "taunt")
			end
		end
	elseif event == "SPELL_AURA_REFRESH" then
		if destGUID == UnitGUID("player") and absorb_ids[select(1,...)] then
			if self.db.profile.absorb.enable then
				self:AbsorbUpdate()
			end
		end
	elseif event == "SPELL_INTERRUPT" then
		if self.db.profile.announce.interrupt and sourceGUID == UnitGUID("player") and interrupt_ids[select(1,...)] then
			-- Do I need to use a limited Message/Announce to prevent spamming for solar beam interrupting multiple mobs?
			self:LimitedMessage(string.format(L["Interrupted"]..": %s",select(5,...)),"announce",self.db.profile.announce.frequency)
			if self:ChatChannel(self.db.profile.announce.intchan) ~= "none" then
				-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(4,...) .. "\124h[" .. select(5,...) .. "]\124h\124r"
				local spellstring = GetSpellLink(select(4,...))
				if self.db.profile.announce.target then
					self:LimitedAnnounce(string.format(L["Interrupted"]..": %s (%s)",spellstring,destName),self.db.profile.announce.frequency,select(2,...),self:ChatChannel(self.db.profile.announce.intchan))
				else
					self:LimitedAnnounce(string.format(L["Interrupted"]..": %s",spellstring),self.db.profile.announce.frequency,select(2,...),self:ChatChannel(self.db.profile.announce.intchan))
				end
			end
		end
	elseif event == "SPELL_DISPEL" then
		if self.db.profile.announce.dispel and sourceGUID == UnitGUID("player") and dispel_ids[select(1,...)] then
			self:Message(string.format(L["Dispel: "] .. "%s (%s)",select(5,...),destName),"announce")
			-- local spellstring = "\124cff71d5ff\124Hspell:" .. select(4,...) .. "\124h[" .. select(5,...) .. "]\124h\124r"
			local spellstring = GetSpellLink(select(4,...))
			if self:ChatChannel(self.db.profile.announce.dispelchan) ~= "none" then
				if self.db.profile.announce.target then
					self:Announce(string.format(L["Dispel: "] .. "%s (%s)",spellstring,destName),self:ChatChannel(self.db.profile.announce.dispelchan))
				else
					self:Announce(L["Dispel: "] .. spellstring,self:ChatChannel(self.db.profile.announce.dispelchan))
				end
			end
			if self.db.profile.announce.dispelpm then
				self:Whisper(L["Dispel: "] .. spellstring,destName)
			end
		elseif self.db.profile.cc.broken then
			if (self.root.enabled and destGUID == self.root.target) then
				self.root.breaksource = sourceName
			 	self.root.breakspell = select(2,...)
				-- self:Print("breakspell: " .. self.root.breakspell)
			end
		end
	elseif (event == "SWING_DAMAGE") then
		if self.db.profile.cc.broken then
			if (self.root.enabled and destGUID == self.root.target) then
				self.root.breaksource = sourceName
			 	self.root.breakspell = "(melee)"
				if (select(2,...) > 0) then
					self.root.dead = true
				end
			end
		end
	elseif (event == "RANGE_DAMAGE") then
		if self.db.profile.cc.broken then
			if (self.root.enabled and destGUID == self.root.target) then
				self.root.breaksource = sourceName
			 	self.root.breakspell = select(2,...)
				if (select(5,...) > 0) then
					self.root.dead = true
				end
			end
		end
	elseif (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE") then 
		if self.db.profile.cc.broken then
			if (self.root.enabled and destGUID == self.root.target) then
				self.root.breaksource = sourceName
				self.root.breakspell = select(2,...)
				if (select(5,...) > 0) then
					self.root.dead = true
				end
			end
		end
		if (self.db.profile.cd.berserk or self.db.profile.cd.starfall) and
		   sourceGUID == UnitGUID("player") and event == "SPELL_DAMAGE" then
			-- Neither Berserk/Incarnation or Starfall use PERIODIC_DAMAGE
			self:DamHandler(select(1,...),select(4,...),select(10,...))
		end
	elseif (event == "SPELL_MISSED") then
		if self.db.profile.cc.fail and sourceGUID == UnitGUID("player") then
			if cc_ids[select(1,...)] then
				-- Replace TARGET in string with the actual target
				substring = string.gsub(self.db.profile.cc.failtext, "TARGET", destName)
				-- Add the type of miss to the end
				substring = substring .. select(4,...)

				-- Do not announce that the CC failed if they are still CC'd
				-- For example if you tried to root a sheeped target
				-- if it misses, don't announce since it is still CC'd
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
					self:SpellCastAnnounce(select(1,...), select(2,...), substring, self.db.profile.cc.ccchan)
				end
			end
		end
		if self.db.profile.absorb.enable and destGUID == UnitGUID("player") then
			-- Check if the spell was absorbed
			if (select(4,...) == "ABSORB") then
				self:AbsorbUpdate()
			end
		end
	elseif (event == "SPELL_PERIODIC_MISSED") then
		if self.db.profile.absorb.enable and destGUID == UnitGUID("player") then
			-- Check if the spell was absorbed
			if (select(4,...) == "ABSORB") then
				-- 5 is the amount that was absorbed, but it's more accurate to just
				-- check how much absorb is remaining on buffs
				self:AbsorbUpdate()
			end
		end
	elseif (event == "SWING_MISSED") then
		if self.db.profile.absorb.enable and destGUID == UnitGUID("player") then
			-- Check if the swing was absorbed
			if (select(1,...) == "ABSORB") then
				-- 2 is the amount that was absorbed, but it's more accurate to just
				-- check how much absorb is remaining on buffs
				self:AbsorbUpdate()
			end
		end
	elseif (event == "SPELL_AURA_BROKEN" or
	        event == "SPELL_AURA_BROKEN_SPELL") then
	 	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
		if (self.root.enabled and destGUID == self.root.target and root_ids[select(1,...)]) then
			if self.db.profile.cc.broken then
				local breakspell
				-- What broke it?
				if (event == "SPELL_AURA_BROKEN") then
					breakspell = "(melee)"
				elseif (event == "SPELL_AURA_BROKEN_SPELL") then
					breakspell = select(5,...)
				end

				local cctime = self.root.time

				self:BreakMessage(timestamp, sourceName, destGUID, destName, breakspell, cctime, select(1,...), select(2,...))

				if root_ids[select(1,...)] then
					self.root.enabled = false
					self.root.target = nil
					self.root.dead = false
					-- self.root.time = 0
					self.root.breaksource = nil
					self.root.breakspell = nil
				end
			end
		end
	elseif (event == "SPELL_HEAL") then
		-- Tranquility uses spell id 740 for SPELL_AURA and SPELL_CAST events
		-- 157982 is the SPELL_HEAL spell id for Tranquility
		if self.db.profile.cd.tranq and sourceGUID == UnitGUID("player") and select(1,...) == 157982 then
			self:TranqHandler(select(4,...), select(5,...), select(7,...))
		end
	-- In Legion all Tranquility heals appear to be SPELL_HEAL and not PERIODIC
	-- elseif (event == "SPELL_PERIODIC_HEAL") then
	-- 	-- Tranquility uses spell id 740 for SPELL_AURA and SPELL_CAST events
	-- 	-- 157982 is the SPELL_HEAL and SPELL_PERIODIC_HEAL spell id for Tranquility
	-- 	if self.db.profile.cd.tranq and sourceGUID == UnitGUID("player") and select(1,...) == 44203 then
	-- 		self:TranqHandler(select(4,...), select(5,...), select(7,...))
	-- 	end
	elseif (event == "SPELL_CAST_SUCCESS") then
		if self.db.profile.taunt.enable and self:CheckTaunt(sourceGUID, select(1,...)) then
			local msg = ""
			-- Righteous Defense is removed in MoP
			-- if select(1,...) == 31789 then
			--	msg = string.format(L["%s AoE taunted off of %s using %s"], sourceName, destName, select(2,...))

			-- In 5.2 combatlog sometimes the sourceName is missing on taunts
			if (not sourceName) then
				sourceName = "Unknown"
			end

			if aoetaunt_ids[select(1,...)] then
				msg = string.format(L["%s AoE taunted using %s"], sourceName, select(2,...))
			else
				msg = string.format(L["%s taunted %s using %s"], sourceName, destName, select(2,...))
			end
			-- self:Print("Taunt announce, spell: (" .. select(2,...) .. ")")
			self:Message(msg, "taunt")
			-- self:Print("End taunt announce")
		end
	end

	-- self:Print("tracked")
	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
	-- self:Print(...)
end

function DruidFriend:IsSolo()
	return (GetNumGroupMembers() == 0)
end

-- Conditions to check for Buff Fade
-- function DruidFriend:IsBuffCheckEnabled()
-- 	-- Check when mounted?
-- 	if (self.db.profile.buff.mounted and IsMounted()) then
-- 		return false
-- 	end
-- 
-- 	-- Check when in vehicle?
-- 	if (self.db.profile.buff.vehicle and UnitInVehicle("player")) then
-- 		return false
-- 	end
-- 
-- 	-- Check when in combat?
-- 	if (self.db.profile.buff.combat and InCombatLockdown()) then
-- 		return false
-- 	end
-- 
-- 	-- Check when PvP flagged?
-- 	if (self.db.profile.buff.pvp) then
-- 		if UnitIsPVP("player") or UnitIsPVPFreeForAll("player") then
-- 			return false
-- 		end
-- 	end
-- 
-- 	-- Do we check in this location?
-- 	if (not self:IsBuffCheckLocation()) then
-- 		return false
-- 	end
-- 
-- 	return true
-- end

-- Check if this is a location where we check Buffs
-- function DruidFriend:IsBuffCheckLocation()
-- 	local mapid = GetCurrentMapAreaID()
-- 
-- 	-- First check for Wintergrasp by zone text
-- 	-- If warn in Wintergrasp is selected, it will warn
-- 	-- even if World warnings are otherwise disabled
-- 	-- local zone = GetRealZoneText()
-- 	-- if zone == L["ZONE_WG"] or
-- 	--    zone == L["ZONE_TOLB"] then
-- 	if pvp_zoneids[mapid] then
-- 		if self.db.profile.buff.wg then
-- 			return true
-- 		else
-- 			return false
-- 		end
-- 	end
-- 
-- 	local inInstance, instanceType = IsInInstance();
-- 
-- 	-- Then check instance type
-- 	if instanceType == "pvp" then
-- 	   	if not self.db.profile.buff.bg then
-- 			return false
-- 		end
-- 	elseif instanceType == "arena" then
-- 	  	if not self.db.profile.buff.arena then
-- 			return false
-- 		end
-- 	elseif instanceType == "party" then
-- 	   	if not self.db.profile.buff.instance then
-- 			return false
-- 		end
-- 	elseif instanceType == "raid" then
-- 	   	if not self.db.profile.buff.raid then
-- 			return false
-- 		end
-- 	elseif not self.db.profile.buff.world then
-- 		-- "none"
-- 		return false
-- 	end
-- 
-- 	return true
-- end

-- Check all players that have had buffs fade
-- function DruidFriend:CheckFades()
-- 	for k, v in pairs (BuffFades) do
-- 		-- self:Print("k = "..k..", v = "..v)
-- 		self:CheckBuffFade(k, v)
-- 	end
-- 	BuffFades = {}
-- end

-- Check if a buff faded
-- unitid - players to check
-- oldBuff - the buff that was removed
-- function DruidFriend:CheckBuffFade(unitid, oldBuff)
-- 	local name = UnitName(unitid)
-- 
-- 	-- Do not warn about buff if player has Kings or MotW
-- 	-- Another buffer can replace the buff
-- 	-- Do not warn if they are out of range or dead
-- 	local hasbuff, visible, isdead = self:HasBuffs(unitid)
-- 	if hasbuff == false and visible == true and isdead == false then
-- 		self:LimitedMessage(
-- 		  oldBuff .. L[" faded from "] ..name,
-- 		  "buff",
-- 		  self.db.profile.buff.frequency)
-- 	end
-- end

-- function DruidFriend:HasBuffs(unitid)
-- 
-- 	if not unitid or not UnitExists(unitid) then
-- 		return nil
-- 	end
-- 
-- 	-- In range?
-- 	local visible = IsSpellInRange(lN["Mark of the Wild"], unitid) == 1
-- 	-- Is dead?
-- 	local isdead = UnitIsDeadOrGhost(unitid) == 1
-- 
-- 	local hasstats = self:HasStats(unitid)
-- 	local hasvers = self:HasVers(unitid)
-- 
--         local hasbuff = false
--         if (hasstats and hasvers) then
-- 		hasbuff = true
--         end
-- 
--         return hasbuff, visible, isdead
-- end

-- Check for Stat Buffs
-- function DruidFriend:HasStats(unitid)
-- 	local hasbuff = false
-- 
-- 	if not unitid or not UnitExists(unitid) then
-- 		return nil
-- 	end
-- 
-- 	if (UnitBuff(unitid, lN["Mark of the Wild"]) or
-- 	    UnitBuff(unitid, lN["Blessing of Kings"]) or
-- 	    UnitBuff(unitid, lN["Legacy of the Emperor"]) or
-- 	    UnitBuff(unitid, lN["Legacy of the White Tiger"]) or
-- 	    UnitBuff(unitid, lN["Blessing of Kongs"]) or
-- 	    UnitBuff(unitid, lN["Strength of the Earth"]) or
-- 	    UnitBuff(unitid, lN["Bark of the Wild"]) or
-- 	    UnitBuff(unitid, lN["Embrace of the Shale Spider"])) then
-- 		hasbuff = true
-- 	end
-- 
-- 	return hasbuff
-- end

-- Check for Versatility Buffs
-- function DruidFriend:HasVers(unitid)
-- 	local hasbuff = false
-- 
-- 	if not unitid or not UnitExists(unitid) then
-- 		return nil
-- 	end
-- 
-- 	if (UnitBuff(unitid, lN["Mark of the Wild"]) or
-- 	    UnitBuff(unitid, lN["Unholy Aura"]) or
-- 	    UnitBuff(unitid, lN["Sanctity Aura"]) or
-- 	    UnitBuff(unitid, lN["Inspiring Presence"]) or
-- 	    UnitBuff(unitid, lN["Indomitable"]) or
-- 	    UnitBuff(unitid, lN["Chitinous Armor"]) or
-- 	    UnitBuff(unitid, lN["Wild Strength"]) or
-- 	    UnitBuff(unitid, lN["Tenacity"]) or
-- 	    UnitBuff(unitid, lN["Defensive Quills"]) or
-- 	    UnitBuff(unitid, lN["Strength of the Earth"]) or
-- 	    UnitBuff(unitid, lN["Grace"])) then
-- 		hasbuff = true
-- 	end
-- 
-- 	return hasbuff
-- end

function DruidFriend:CheckCC()
	-- self:Print("In CheckCC")
	while (next(self.checkcc) ~= nil) do
		local timestamp, destGUID, destName, cc_sid, cc_name
		timestamp = table.remove(self.checkcc, 1)
		destGUID = table.remove(self.checkcc, 1)
		destName = table.remove(self.checkcc, 1)
		cc_sid = table.remove(self.checkcc, 1)
		cc_name = table.remove(self.checkcc, 1)
		self:CCFaded(timestamp, destGUID, destName, cc_sid, cc_name)
	end
end

function DruidFriend:CCFaded(timestamp, destGUID, destName, cc_sid, cc_name)
	-- self:Print("In CCFaded")
	if self.db.profile.cc.broken and self.root.breakspell and root_ids[cc_sid] and
	   (timestamp + 1 < self.root.expiration) then
		self:BreakMessage(timestamp, self.root.breaksource, destGUID, destName, self.root.breakspell, self.root.time, cc_sid, cc_name)
	elseif self.db.profile.cc.fade then
		if root_ids[cc_sid] and self.root.enabled then
			self:Message(cc_name .. L[" faded from "] .. destName, "cc")
			-- Do not announce that the CC faded if they are still CC'd
			-- This only works if the CC'd unit is a Target, Target's Target, Focus, or Focus's Target
			-- because there is no way to check debuffs on an NPC otherwise
			local ccannounce = true
			if (self:GetCC(destGUID, cc_sid)) then
				ccannounce = false
			-- elseif (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
			elseif (root_ids[cc_sid] and self.root.dead) then
				ccannounce = false
			end
			if ccannounce then
				-- Replace TARGET in string with the actual target
				substring = string.gsub(self.db.profile.cc.fadetext, "TARGET", destName)
				self:SpellCastAnnounce(cc_sid, cc_name, substring, self.db.profile.cc.ccchan)
			end
		end
	end
	if root_ids[cc_sid] then
		self.root.enabled = false
		self.root.target = nil
		self.root.dead = false
		-- self.root.time = 0
		self.root.breaksource = nil
		self.root.breakspell = nil
	end
	self.cc.removetarget = nil
end

function DruidFriend:BreakMessage(timestamp, sourceName, destGUID, destName, breakspell, cc_time, cc_sid, cc_name)
	local message = L[" broke SPELL on "]
	-- Replace SPELL in string with the actual spell
	message = string.gsub(message, "SPELL", cc_name)

	-- self:Print("In BreakMessage")

	-- if (UnitIsDead(destGUID) or UnitIsCorpse(destGUID)) then
	if (root_ids[cc_sid] and self.root.dead) then
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

	if self:ChatChannel(self.db.profile.cc.brokenchan) ~= "none" then
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
		self:Announce(substring,self:ChatChannel(self.db.profile.cc.brokenchan))
	end
end

-- Perform Checks
-- function DruidFriend:PerformChecks()
-- 	if self.db.profile.buff.readycheck then
-- 		self:CheckBuffs()
-- 	end
-- end

-- unitID = Unit casting the spell
-- spellName = Spell name
-- spellRank = Spell rank
-- lineID = Spell lineID counter
-- spellID = Spell ID
function DruidFriend:UNIT_SPELLCAST_SUCCEEDED(event,unitID,spellName,spellRank,lineID,spellID)
	if unitID ~= "player" then
		return
	end

	-- Tranquility cast spellID = 740
	if self.db.profile.announce.tranquility and
	   self:ChatChannel(self.db.profile.announce.tranqchan) ~= "none" and
	   (spellID == name_ids["Tranquility"]) then
		-- Replace SPELL in string with the actual spell
		-- local spellstring = "\124cff71d5ff\124Hspell:" .. spellID .. "\124h[" .. spellName .. "]\124h\124r"
		local spellstring = GetSpellLink(spellID)
		local substring = string.gsub(self.db.profile.announce.tranqtext, "SPELL", spellstring)
		-- Require a frequency of at least 10 for Tranquility or it gets reported multiple times
		local frequency = 10
		if (self.db.profile.announce.frequency and self.db.profile.announce.frequency > frequency) then
			frequency = self.db.profile.announce.frequency
		end
		self:LimitedAnnounce(substring,frequency,spellName,self:ChatChannel(self.db.profile.announce.tranqchan))
	-- Leaving this one spellName until I can test it with spellID
	elseif self.db.profile.announce.starfall and (spellName == lN["Starfall"]) then
		self:SpellCastAnnounce(spellID,spellName,self.db.profile.announce.startext,self.db.profile.announce.starchan)
	elseif self.db.profile.announce.berserk and zerk_ids[spellID] then
		self:SpellCastAnnounce(spellID,spellName,self.db.profile.announce.zerktext,self.db.profile.announce.zerkchan)
	elseif self.db.profile.announce.barkskin and (spellID == name_ids["Barkskin"]) and
	       self:CheckSpec(self.db.profile.tank.balspec, false, self.db.profile.tank.guardspec, self.db.profile.tank.restospec) then
		self:SpellCastAnnounce(spellID,spellName,self.db.profile.announce.barktext,self.db.profile.announce.barkchan)
	elseif self.db.profile.announce.survival and (spellID == name_ids["Survival Instincts"]) and
	       self:CheckSpec(false, self.db.profile.tank.feralspec, self.db.profile.tank.guardspec, false) then
		self:SpellCastAnnounce(spellID,spellName,self.db.profile.announce.survtext,self.db.profile.announce.survchan)
	-- Debug
	-- else
	 	-- self:Print("SpellName: ".. spellName, ", SpellID: ".. spellID)
	end
end

function DruidFriend:CheckAbsorbSpec()
	return self:CheckSpec(self.db.profile.absorb.balspec, self.db.profile.absorb.feralspec, self.db.profile.absorb.guardspec, self.db.profile.absorb.restospec)
end

-- This doesn't work on login until the PLAYER_ALIVE event fires
-- until the character is loaded, the spec detects as 0/0/0
function DruidFriend:CheckSpec(balspec, feralspec, guardspec, restospec)
	local active_spec
	local balance = false
	local feral = false
	local guardian = false
	local resto = false

	-- active_spec = GetActiveSpecGroup()
	-- Druid specs: 1) Balance, 2) Feral, 3) Guardian, 4) Restoration
	local currentSpec = GetSpecialization()
	if (currentSpec == 1) then
		balance = true
	elseif (currentSpec == 2) then
		feral = true
	elseif (currentSpec == 3) then
		guardian = true
	elseif (currentSpec == 4) then
		resto = true
	end

	-- self:Print("CheckSpec active: "..active_spec.." guardian: "..guardian.." feral: "..feral)

	if (balance and balspec) then
		return true
	elseif (feral and feralspec) then
		return true
	elseif (guardian and guardspec) then
		return true
	elseif (resto and restospec) then
		return true
	else
		return false
	end
end

-- sid = Spell Id
-- loc_spell = Localized Spell Name
-- Text = Text to display
-- Channel = Channel to announce to
function DruidFriend:SpellCastAnnounce(sid, loc_spell, text, channel)
	-- self:Print("In SpellCastAnnounce")
	if self:ChatChannel(channel) == "none" then
		return
	end

	-- Replace SPELL in string with the actual spell
	-- local spellstring = "\124cff71d5ff\124Hspell:" .. sid .. "\124h[" .. loc_spell .. "]\124h\124r"
	local spellstring = GetSpellLink(sid)
	local substring = string.gsub(text, "SPELL", spellstring)
	self:Announce(substring,self:ChatChannel(channel))
end

-- Ready Check event
-- function DruidFriend:READY_CHECK()
--	-- self:Print("READY_CHECK")
--	if self.db.profile.buff.readycheck then
--		self:CheckBuffs()
--	end
--end

-- Enter combat event
--function DruidFriend:PLAYER_REGEN_DISABLED()
--	-- self:Print("PLAYER_REGEN_DISABLED")
--	if self.db.profile.buff.entercombat then
--		self:CheckBuffs()
--	end
--end

-- Leave combat event
function DruidFriend:PLAYER_REGEN_ENABLED()
	-- self:Print("PLAYER_REGEN_ENABLED")
--	if self.db.profile.buff.aftercombat then
--		self:CheckBuffs()
--	end
	if DelayedUnitUpdate then
		self:UpdateUnits()
	end
	CombatPetTaunt = {}
end

-- Has the druid fully buffed?
-- function DruidFriend:CheckBuffs()
-- 	local missing_motw = 0
-- 	local missing_range = 0
-- 
-- 	local max_raid = 0
-- 	local unit_prefix
-- 	local israid = 0
-- 	local PlayersMissingMotw = {}
-- 	local PlayersMissingRange = {}
-- 
-- 	-- local motwString = "\124cff71d5ff\124Hspell:20217\124h[" .. lN["Mark of the Wild"] .. "]\124h\124r"
-- 	local motwString = GetSpellLink(20217)
-- 
-- 	-- Enabled?
-- 	if (not self.db.profile.buff.enable) then
-- 		return
-- 	end
-- 
-- 	-- Don't warn if dead
-- 	if (UnitIsDeadOrGhost("player")) then
-- 		return
-- 	end
-- 
-- 	-- Check when mounted?
-- 	if (self.db.profile.buff.mounted and IsMounted()) then
-- 		return
-- 	end
-- 
-- 	-- Check when in vehicle?
-- 	if (self.db.profile.buff.vehicle and UnitInVehicle("player")) then
-- 		return
-- 	end
-- 
-- 	-- Check when PvP flagged?
-- 	if (self.db.profile.buff.pvp) then
-- 		if UnitIsPVP("player") or UnitIsPVPFreeForAll("player") then
-- 			return
-- 		end
-- 	end
-- 
-- 	-- Do we check in this location?
-- 	if (not self:IsBuffCheckLocation()) then
-- 		return
-- 	end
-- 
-- 	if IsInRaid() then
-- 		-- raid
-- 		max_raid = MAX_RAID_MEMBERS
-- 		unit_prefix = "raid"
-- 		israid = 1
-- 	else
-- 		-- party
-- 		max_raid = MAX_PARTY_MEMBERS
-- 		unit_prefix = "party"
-- 		israid = 0
-- 	end
-- 	-- self:Print("max_raid: " .. max_raid)
-- 
-- 	local hasbuff
-- 	local visible
-- 	local isdead
-- 
-- 	-- player
-- 	hasbuff, visible, isdead = self:HasBuffs("player")
-- 	if (not hasbuff and visible and not isdead) then
-- 		local name = UnitName("player")
-- 		PlayersMissingMotw[name] = true
-- 		missing_motw = missing_motw + 1
-- 	end
-- 
-- 	for i = 1, max_raid do
-- 		local unitid
-- 		-- Check Player
-- 		unitid = unit_prefix..i
-- 		-- self:Print(unitid)
-- 		if unitid and UnitExists(unitid) then
-- 			hasbuff, visible, isdead = self:HasBuffs(unitid)
-- 
-- 			-- Server lag will sometimes cause newly spawned units
-- 			-- to show up as "Unknown"
-- 			-- Can't check buffs properly on "Unknown" units
-- 			local name = UnitName(unitid)
-- 
-- 			if not hasbuff and not isdead and name ~= L["Unknown"] then
-- 				if visible then
-- 					PlayersMissingMotw[name] = true
-- 					missing_motw = missing_motw + 1
-- 				else
-- 					missing_range = missing_range + 1
-- 					PlayersMissingRange[name] = true
-- 				end
-- 			end
-- 		end
-- 	end
-- 
-- 	if missing_motw > 0 then
-- 		local message = L["Missing "] .. motwString .. ": " .. missing_motw
-- 		self:LimitedMessage(message, "buff",
-- 			self.db.profile.buff.frequency)
-- 
-- 		-- Print players missing Kings
-- 		local player_string = ""
-- 		for k, v in pairs (PlayersMissingMotw) do
-- 			if player_string == "" then
-- 				player_string = k
-- 			else
-- 				player_string = player_string..", "..k
-- 			end
-- 		end
-- 		self:ChatMessage(L["Players missing MOTW: "]..player_string,
-- 			"buff")
-- 	end
-- 
-- 	if missing_range > 0 then
-- 		-- Out of range players missing buffs
-- 		local player_string = ""
-- 		for k, v in pairs (PlayersMissingRange) do
-- 			if player_string == "" then
-- 				player_string = k
-- 			else
-- 				player_string = player_string..", "..k
-- 			end
-- 		end
-- 		self:ChatMessage(L["Players out of range: "]..player_string,
-- 			"buff")
-- 	end
-- end

function DruidFriend:PLAYER_ENTERING_WORLD()
	DruidFriend:ZoneCheck();
	self.loaded = true
end

function DruidFriend:ZoneCheck()
	local inInstance, instanceType = IsInInstance();

	self.announce = true
	self.zonetype = instanceType

	if instanceType == "pvp" then
		if self.db.profile.announce.loc.bgannounce == "none" then
			self.announce = false
		end
	elseif instanceType == "arena" then
		if self.db.profile.announce.loc.arenaannounce == false then
			self.announce = false
		end
	elseif instanceType == "party" then
		if self.db.profile.announce.loc.partyannounce == false then
			self.announce = false
		end
	elseif instanceType == "raid" then
		if self.db.profile.announce.loc.raidannounce == false then
			self.announce = false
		end
	else
		if self.db.profile.announce.loc.worldannounce == false then
			self.announce = false
		end
	end
end

-- Load NameToID table
-- This is only used to get UnitIDs for tanks
-- so there is no need to track pets
function DruidFriend:UpdateUnits()
	local num_party = GetNumSubgroupMembers()

	-- Don't do this in combat for performance reasons
	-- I don't want this to be one of those addons that causes your UI to freeze
	-- whenever someone joins or leaves the raid
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

	-- A druid can be a tank
	self.NameToID[UnitName("player")] = "player"

	DelayedUnitUpdate = false
end

-- Find the expiration time of a debuff
-- This can only check if there is still CC on:
-- Your target
-- Your Focus
-- Your Target's Target
-- Your Focus's Target
function DruidFriend:GetExpiration(timestamp, buff_name, unitid, default)
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
	local buff, _, _, count, _, _, expirationTime  = UnitDebuff(unitid, buff_name)
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
-- Ignore the current CC cast by the player
-- This can only check if there is still CC on:
-- Your target
-- Your Focus
-- Your Target's Target
-- Your Focus's Target
function DruidFriend:GetCC(unitid, current_sid)
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

-- language and channel are optional
function DruidFriend:LimitedAnnounce(msg, limit, spell, chatType, language, channel)
	local last_time = 0
	-- Group all announcements together
	if AlertTimes[spell] then
		last_time = AlertTimes[spell]
	end

	if limit and ((limit == 0) or ((GetTime() - last_time) > limit)) then
		AlertTimes[spell] = GetTime()
		self:Announce(msg, chatType, language, channel)
	end
end

-- language and channel are optional
-- If language is nil it is "ORCISH" for Horde and "COMMON" for Alliance
function DruidFriend:Announce(msg, chatType, language, channel)
	-- self:Print("In Announce")
	if self.announce == false then
		return
	end

	local inst_flag, zonetype = IsInInstance()
	-- self:Print("inst: " .. inst_flag)
	local name, inst_type, diff_index = GetInstanceInfo()
	-- self:Print("name: " .. name .. " type: " .. tostring(inst_type) .. " diff: " .. diff_index)

	if zonetype == "pvp" then
		-- Battlegrounds need to be handled specially
		if self.db.profile.announce.loc.bgannounce == "BATTLEGROUND" then
			-- 5.1 is now INSTANCE_CHAT
			chatType = "INSTANCE_CHAT"
		elseif self.db.profile.announce.loc.bgannounce == "PARTY" then
			if GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
				-- Actually in a party
				chatType = "PARTY"
			else
				return
			end
		elseif self.db.profile.announce.loc.bgannounce == "none" then
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
		-- self:Print("Setting chatType for scenario")
		-- For a Scenario:
		-- As of 5.4, it looks like zonetype/inst_type is now labeled scenario instead of nil
		--  inst_flag is 1 (is an instance)
		-- inst_type is nil
		-- self:Print("Debug: Announce in Scenario instance")
		-- As of 5.1 Scenarios need to be handled specially
		if chatType == "RAID" or chatType == "PARTY" then
			-- self:Print("... to instance")
			chatType = "INSTANCE_CHAT"
		end
	end

	-- self:Print("announce: " .. tostring(self.announce) .. " chatType: " .. chatType)

	SendChatMessage(msg, chatType, language, channel);
end

-- Don't whisper a message of this type more often than limit
function DruidFriend:LimitedWhisper(msg, target, type, limit)
	local last_time = 0
	if AlertTimes[type] then
		last_time = AlertTimes[type]
	end

	if (limit == 0) or ((GetTime() - last_time) > limit) then
		AlertTimes[type] = GetTime()
		self:Whisper(msg, target)
	end
end

-- Display alerts to the user
-- Language is optional:
-- If language is nil it is "ORCISH" for Horde and "COMMON" for Alliance
function DruidFriend:Whisper(msg, target, language)
	if not target then
		return
	end

	SendChatMessage(msg, "WHISPER", language, target);
end

-- Called to open the configuration
function DruidFriend:OpenConfig()
	-- Have to call it twice to work around bug
 	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
 	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	-- if InterfaceOptionsFrame_OpenToCategory then
	-- 	InterfaceOptionsFrame_OpenToCategory("DruidFriend");
	-- else
	-- 	InterfaceOptionsFrame_OpenToFrame("DruidFriend");
	-- end
end

-- Show the version number
function DruidFriend:ShowVersion()
	self:Print(self.DisplayVersion)
end

-- Don't display a message of this type more often than limit
function DruidFriend:LimitedMessage(str, type, limit)
	local last_time = 0
	if AlertTimes[type] then
		last_time = AlertTimes[type]
	end

	if (limit == 0) or ((GetTime() - last_time) > limit) then
		AlertTimes[type] = GetTime()
		self:Message(str, type)
	end
end

function DruidFriend:ChatMessage(str, type)
	local c
	if type == "buff" then
		c = self.db.profile.buff.display.color
	elseif type == "announce" then
		c = self.db.profile.announce.display.color
	else
		return
	end

	if (type == "buff" and self.db.profile.buff.display.frames) or
	   (type == "announce" and self.db.profile.announce.display.frames) then
		-- Display Chat Message?
		if self.db.profile.display.chat then
			if self.db.profile.display.number == 0 then
				self:Print(str)
			else
				local chatframe = getglobal("ChatFrame" .. self.db.profile.display.number)
				chatframe:AddMessage(str, c.r, c.g, c.b)
			end
		end
	end
end

-- Display alerts to the user
function DruidFriend:Message(str, type)
	local c, t
	local opt_sound = "none"

	-- if type == "buff" then
	-- 	c = self.db.profile.buff.display.color
	-- 	t = self.db.profile.buff.display.time
	-- 	opt_sound = self.db.profile.buff.sound
	if type == "announce" then
		c = self.db.profile.announce.display.color
		t = self.db.profile.announce.display.time
		opt_sound = self.db.profile.announce.sound
	elseif type == "cd" then
		c = self.db.profile.cd.display.color
		t = self.db.profile.cd.display.time
		opt_sound = self.db.profile.cd.sound
	elseif type == "taunt" then
		c = self.db.profile.taunt.display.color
		t = self.db.profile.taunt.display.time
		opt_sound = self.db.profile.taunt.sound
	else
		return
	end

	--if (type == "buff" and self.db.profile.buff.display.frames) or
	if (type == "announce" and self.db.profile.announce.display.frames) or
	   (type == "cd" and self.db.profile.cd.display.frames) or
	   (type == "taunt" and self.db.profile.taunt.display.frames) then
		-- Display Chat Message?
		if self.db.profile.display.chat then
			if self.db.profile.display.number == 0 then
				self:Print(str)
			else
				local chatframe = getglobal("ChatFrame" .. self.db.profile.display.number)
				chatframe:AddMessage(str, c.r, c.g, c.b)
			end
		end
		-- Display to Custom Frame?
		if self.db.profile.display.frame then
			self.msgFrame:SetTimeVisible(t)
			self.msgFrame:AddMessage(str, c.r, c.g, c.b, 1, t)
		end
	end

	-- Scrolling output
	-- if (type == "buff" and self.db.profile.buff.display.scroll) or
	if (type == "announce" and self.db.profile.announce.display.scroll) or
	   (type == "cd" and self.db.profile.cd.display.scroll) or
	   (type == "taunt" and self.db.profile.taunt.display.scroll) then
		-- Use LibSink to handle scrolling text
		self:Pour(str, c.r, c.g, c.b)
	end

	-- Play sound if one is enabled
	self:Play(opt_sound)
	-- self:Print("End of Message")
end

function DruidFriend:Play(sound_arg)
	if (sound_arg == "None") then
		return
	end

	local sound = LSM:Fetch("sound", sound_arg) 
	PlaySoundFile(sound, DruidFriend.db.profile.soundchannel)

	-- local sound = sounds[sound_arg]
	-- if (not sound) then
	-- 	return
	-- end

	-- if string.find(sound, "%\\") then
	-- 	PlaySoundFile(sound, DruidFriend.db.profile.soundchannel)
	-- else
	-- 	PlaySound(sound, DruidFriend.db.profile.soundchannel)
	-- end
end

-- Scrolling Combat Text output
function DruidFriend:SinkPrint(addon, message, r, g, b)
 	if not self.msgFrame then self:CreateCustomFrame() end
 	self.msgFrame:AddMessage(message, r, g, b, 1, UIERRORS_HOLD_TIME)
end

-- Create the output frame
function DruidFriend:CreateCustomFrame()
	self.dragButton = CreateFrame("Button","DruidFriend_dragButton",UIParent)
	self.dragButton.owner = self
	self.dragButton:Hide()
	self.dragButton:ClearAllPoints()
	self.dragButton:SetWidth(250)
	self.dragButton:SetHeight(20)
	
	if self.db.profile.display.x and self.db.profile.display.y then
		self.dragButton:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
			self.db.profile.display.x, self.db.profile.display.y)
	else 
		self.dragButton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	end	
	
	self.dragButton:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.dragButton:SetBackdropColor(0,0,0.3,.6)	
	
	self.dragButton:SetMovable(true)
	self.dragButton:RegisterForDrag("LeftButton")
	self.dragButton:SetScript("OnDragStart",
		function() DruidFriend.dragButton:StartMoving() end )
	self.dragButton:SetScript("OnDragStop",
		function()
			DruidFriend.dragButton:StopMovingOrSizing()
			self.db.profile.display.x = DruidFriend.dragButton:GetLeft()
			self.db.profile.display.y = DruidFriend.dragButton:GetTop()
		end
	)

	self.msgFrame = CreateFrame("MessageFrame","DruidFriend_msgFrame")
	self.msgFrame.owner = self
	self.msgFrame:ClearAllPoints()
	self.msgFrame:SetWidth(400)
	self.msgFrame:SetHeight(75)
	self.msgFrame:SetPoint("TOP", self.dragButton, "TOP", 0, 0)
	self.msgFrame:SetInsertMode("TOP")
	self.msgFrame:SetFrameStrata("HIGH")
	self.msgFrame:SetToplevel(true)

	self.msgText = self.dragButton:CreateFontString(nil, "BACKGROUND",
		"GameFontNormalSmall")
	self.msgText:SetText(L["DruidFriend Display"])
	self.msgText:SetPoint("TOP", self.dragButton, "TOP", 0, -5)

	self:UpdateLock()
	self:UpdateFont()
	
	self.msgFrame:Show()
end

function DruidFriend:ResetDisplayPos()
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

-- Update the font in the custom frame
function DruidFriend:UpdateFont()
	if self.db.profile.display.frame and self.msgFrame then
		local font = LSM:Fetch("font", self.db.profile.display.fontFace) 
		self.msgFrame:SetFont(font,
			self.db.profile.display.fontSize,
			self.db.profile.display.fontEffect)
	end
end

-- Lock or unlock the custom frame
function DruidFriend:UpdateLock()
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
end

-- Update the Absorb Tracker
function DruidFriend:AbsorbUpdate()
	if (not self.db.profile.absorb.enable) then
		self:AbsorbHide()
		return
	end

	self.absorb.total, self.absorb.time, self.absorb.spellicon = self:GetAbsorbInfo()

	self:absorbSetText(self.absorb.total, self.absorb.time)
	self:AbsorbShow()

	-- Check if we need to update the spell icon
	if (self.db.profile.absorb.icon) then
		local texture
		if self.absorb.spellicon then
			texture = GetSpellTexture(self.absorb.spellicon)
		end

		if self.absorbIcon and self.absorbIcon.texture and texture then
			self.absorbIcon.texture:SetTexture(texture)
		else
			-- Default to Power Word: Shield Icon
			texture = GetSpellTexture(lN["Power Word: Shield"])
		end
	end

	-- Check if it should be visible
	-- Combat Only
	if (self.db.profile.absorb.combat and not InCombatLockdown()) then
		self:AbsorbHide()
		return
	end

	-- Absorbs Only (only show if there are currently absorb buffs)
	if (self.db.profile.absorb.zero and (self.absorb.total == 0)) then
		self:AbsorbHide()
		return
	end

	-- Spec
	if (not self:CheckAbsorbSpec()) then
		self:AbsorbHide()
		return
	end

	-- Still showing, run the timer
	if (not self.absorb.timer) then
		self.absorb.TimerEvent = self:ScheduleRepeatingTimer(self.AbsorbTimeUpdate, 1, self)
		self.absorb.timer = true
	end
end

function DruidFriend:AbsorbTimeUpdate()
	-- Primal Tenacity doesn't seem to update the event, need to do it manually every second
	self.absorb.total, self.absorb.time, self.absorb.spellicon = self:GetAbsorbInfo()
	-- self.absorb.time = self.absorb.time - 1

	if (self.absorb.time < 0) then
		self:absorbSetText(self.absorb.total, 0)
		self.absorb.timer = false
		self:CancelTimer(self.absorb.TimerEvent, false)
	else
		self:absorbSetText(self.absorb.total, self.absorb.time)
	end

end

function DruidFriend:AbsorbHide()
	if (not self.absorbFrame) then
		return
	end
	
	self.absorbFrame:Hide()
end

function DruidFriend:AbsorbShow()
	if (not self.absorbFrame) then
		return
	end
	
	self.absorbFrame:Show()
end

-- Goes through all buffs on player
-- and for absorb buffs checks their tooltips for the absorb amounts remaining
function DruidFriend:GetAbsorbInfo()
	local sum = 0
	local time = -1
	local spellamount = 0
	local spellicon

	local i = 1
	local buffName, _, _, _, _, _, expirationTime, _, _, _,
		buffID = UnitBuff("player", i)
	while buffName do
		if absorb_ids[buffID] and buffName then
			-- Use Scanning Tooltip to get current absorb value
			scan:ClearLines()
			scan:SetUnitBuff("player", i)

			-- All absorb tooltips must have the amount in the same
			-- location or be treated specially, but they all seem
			-- to follow this format:
			-- Savage Defense
			-- Absorbs 35 Physical damage.
			-- 10 seconds remaining

			-- Get line 2 of the tooltip
			local txt = scanTextLeft2:GetText()

			-- Example line:
			-- Absorbs 35 Physical damage.

			-- Get the second word in the line (the number)
			local _, val, _ = strsplit(" ", txt)

			local buffval = 0
			if (tonumber(val)) then
				buffval = tonumber(val)
			end

			sum = sum + buffval

			-- Update the spell icon?
			if (buffval > spellamount) then
				spellamount = buffval
				spellicon = buffID
			end

			-- Get time remaining
			local remaining = math.ceil(expirationTime - GetTime())

			if (time < 0) then
				-- First absorb found, use this buff's
				time = remaining
			elseif (remaining < time and remaining >= 0) then
				time = remaining
			-- else there is already a shorter absorb
			end
			-- self:Print(buffName .. " "..val.." "..remaining)
		end
		i = i + 1
		buffName, _, _, _, _, _, expirationTime, _, _, _,
			buffID = UnitBuff("player", i)
	end

	if (time < 0) then
		time = 0
	end

	-- self:Print("GetAbsorbInfo: "..sum.." "..time)
	return sum, time, spellicon
end

function DruidFriend:CreateAbsorbFrame()
	-- self:Print("In CreateAbsorbFrame")
	if not self.db.profile.absorb.enable then
		return
	end
	
	self.absorbFrame = CreateFrame("Frame","DruidFriend_absorb",UIParent)
	self.absorbFrame.owner = self
	self.absorbFrame:ClearAllPoints()
	self.absorbFrame:SetWidth(170)
	self.absorbFrame:SetHeight(48)
	self.absorbFrame:SetFrameStrata("MEDIUM")
	self.absorbFrame:SetToplevel(true)
	self.absorbFrame:SetMovable(true)
	self.absorbFrame:EnableMouse(true)
	self.absorbFrame:SetMovable(true)
	self.absorbFrame:RegisterForDrag("LeftButton")
	self.absorbFrame:SetScript("OnDragStart",
		function()
			if (not self.db.profile.absorb.lock) or self.configMode then
				DruidFriend.absorbFrame:StartMoving()
			end
		end
	)
	self.absorbFrame:SetScript("OnDragStop",
		function()
			DruidFriend.absorbFrame:StopMovingOrSizing()
			self.db.profile.absorb.x = DruidFriend.absorbFrame:GetLeft()
			self.db.profile.absorb.y = DruidFriend.absorbFrame:GetTop()
		end
	)
	
	if self.db.profile.absorb.x and self.db.profile.absorb.y then
		self.absorbFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.absorb.x, self.db.profile.absorb.y)
	else 
		self.absorbFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	end	

	-- Frame Header
	self.absorbHeader = self.absorbFrame:CreateFontString(nil, "OVERLAY")
	self.absorbHeader.owner = self

	-- Frame Icon
	self.absorbIcon = CreateFrame("Frame", "DruidFriend_absorbIcon", self.absorbFrame)
	self.absorbIcon.owner = self

	self.absorbIcon.texture = self.absorbIcon:CreateTexture(nil, "ARTWORK")
	-- Default to Savage Defense icon
	self.absorbIcon.texture:SetTexture(GetSpellTexture(lN["Savage Defense"]))
	self.absorbIcon.texture:SetPoint("TOPLEFT", self.absorbIcon, "TOPLEFT", 3, -3)
	self.absorbIcon.texture:SetPoint("BOTTOMRIGHT", self.absorbIcon, "BOTTOMRIGHT", -3, 3)
	self.absorbIcon.texture:SetTexCoord(0.10, 0.90, 0.10, 0.90)
	
	-- Frame Text
	self.absorbInfo = self.absorbFrame:CreateFontString(nil, "OVERLAY")
	self.absorbInfo.owner = self

	self:AbsorbFrameUpdate()
end

function DruidFriend:ResetAbsorbPos()
	local lock = false
	if self.db.profile.absorb.lock then
		lock = true
		self.db.profile.absorb.lock = false
	end
	self.db.profile.absorb.x = nil
	self.db.profile.absorb.y = nil
	self.absorbFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	if lock then
		self.db.profile.absorb.lock = true
	end
	self:AbsorbFrameUpdate()
end

function DruidFriend:AbsorbFrameUpdate()
	if (not self.absorbFrame) then
		return
	end

	self.absorbFrame:ClearAllPoints()
	if self.db.profile.absorb.x and self.db.profile.absorb.y then
		self.absorbFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.absorb.x, self.db.profile.absorb.y)
	else 
		self.absorbFrame:SetPoint("BOTTOMRIGHT", UIParrent, "BOTTOMRIGHT", -200, 300)
	end	

	self.absorbFrame:Hide()

	self.absorbFrame:SetWidth(170)
	self.absorbFrame:SetHeight(48)
	if (DruidFriend.db.profile.absorb.lock) then
		self.absorbFrame:SetBackdrop(nil)
		self.absorbFrame:SetBackdropColor(0,0,0,0)
	else
		self.absorbFrame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true, tileSize = 8, edgeSize = 9,
				insets = { left = 2, right =2, top = 2, bottom = 2 }
			})
		self.absorbFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
	end

	self.absorbHeader:SetFontObject(GameFontNormalSmall)
	self.absorbHeader:ClearAllPoints()
	self.absorbHeader:SetWidth(170)
	self.absorbHeader:SetHeight(12)
	self.absorbHeader:SetPoint("TOP", self.absorbFrame, "TOP",0,-2)
	self.absorbHeader:SetJustifyH("CENTER")
	self.absorbHeader:SetJustifyV("TOP")
	self.absorbHeader:SetText(L["Absorb Tracker"])

	self.absorbInfo:SetFontObject(GameFontNormalLarge)
	self.absorbInfo:ClearAllPoints()
	self.absorbInfo:SetTextColor(1, 1, 1, 1)
	self.absorbInfo:SetWidth(170)
	self.absorbInfo:SetHeight(36)
	self.absorbInfo:SetPoint("TOP", self.absorbHeader, "BOTTOM",0,0)
	self.absorbInfo:SetJustifyH("CENTER")
	self.absorbInfo:SetJustifyV("MIDDLE")

	self:absorbSetText(0,0)

	-- self:Print("SetButtonMode Hide")
	self.absorbFrame:Show()
	self.absorbInfo:Show()

	-- Check if Header is visible
	if self.absorbHeader then
		if (self.db.profile.absorb.lock) then
			self.absorbHeader:Hide()
		else
			self.absorbHeader:Show()
		end
	end

	if (DruidFriend.db.profile.absorb.icon) then
		-- Its position depends on whether it is locked or not
		if (self.db.profile.absorb.lock) then
			self.absorbIcon:ClearAllPoints()
			self.absorbIcon:SetPoint("BOTTOMLEFT", self.absorbFrame, "TOPLEFT", 67, -13)
			self.absorbIcon:SetWidth(36)
			self.absorbIcon:SetHeight(36)
			self.absorbIcon:SetFrameStrata("MEDIUM")
			self.absorbIcon:SetToplevel(true)
		else
			self.absorbIcon:ClearAllPoints()
			self.absorbIcon:SetPoint("BOTTOMLEFT", self.absorbFrame, "TOPLEFT", 67, 0)
			self.absorbIcon:SetWidth(36)
			self.absorbIcon:SetHeight(36)
			self.absorbIcon:SetFrameStrata("MEDIUM")
			self.absorbIcon:SetToplevel(true)
		end
		self.absorbIcon:Show()
	else
		self.absorbIcon:Hide()
	end

	self:AbsorbUpdate()
end

function DruidFriend:absorbSetText(amount, time)
	if (not self.absorbInfo) then
		return
	end

	if self.db.profile.absorb.time then
		self.absorbInfo:SetText(amount .. "|n" .. time)
	else
		self.absorbInfo:SetText(amount)
	end
end

function DruidFriend:TranqReport()
	-- self:Print("Tranq report")
	if (tranq_heals <= 0) then
		return
	end

	local msg = lN["Tranquility"] .. " " .. tranq_heals

	if self.db.profile.cd.crits then
		msg = msg .. " (" .. tranq_crit .. " " .. L["Crits"] .. ")"
	end

	self:Message(msg, "cd")

	-- No longer tranquing
	tranquing = false
	tranq_crit = 0
	tranq_heals = 0
end

-- Track Tranquility amount and crits
function DruidFriend:TranqHandler(amount, over, crit)
	-- self:Print("TranqHandler"..amount.." "..over.." "..tostring(crit))

	if (not tranquing) then
		-- Start of Tranquility
		tranquing = true
		tranq_crit = 0
		tranq_heals = 0
		-- The initial tranq lasts 8 seconds (minus haste)
		-- No hots for tranq in Legion
		self:ScheduleTimer(self.TranqReport, 10, self)
	end

	local eff = amount - over
	if (eff < 0) then
		eff = 0
	end

	tranq_heals = tranq_heals + eff

	-- Should we include crits that aren't effective?
	-- Until I hear an argument otherwise, not including
	-- heals that are entirely overheal
	if (eff > 0 and crit == 1) then
		tranq_crit = tranq_crit + 1
	end
end

function DruidFriend:DamHandler(spellid,amount,crit)
	-- Mangle(Bear) (Incarnation)
	if self.db.profile.cd.berserk and berserking and (spellid == 33917 or spellid == 202085) then
		if (amount > 0) then
			zerk_dam = zerk_dam + amount
		end

		if (crit == 1) then
			zerk_crit = zerk_crit + 1
		end
	-- SPELL_DAMAGE for Starfall uses sid 191037
	elseif self.db.profile.cd.starfall and starfall_flag and spellid == 191037 then
		if (amount > 0) then
			star_dam = star_dam + amount
		end

		if (crit == 1) then
			star_crit = star_crit + 1
		end
	end
end

function DruidFriend:BerserkReport()
	if (zerk_dam <= 0) then
		return
	end

	local msg = zerk_spell .. " " .. zerk_dam

	if self.db.profile.cd.crits then
		msg = msg .. " (" .. zerk_crit .. " " .. L["Crits"] .. ")"
	end

	self:Message(msg, "cd")

	-- End of Berserk
	berserking = false
	zerk_crit = 0
	zerk_dam = 0
end

function DruidFriend:StarfallReport()
	if (star_dam <= 0) then
		return
	end

	local msg = lN["Starfall"] .. " " .. star_dam

	if self.db.profile.cd.crits then
		msg = msg .. " (" .. star_crit .. " " .. L["Crits"] .. ")"
	end

	self:Message(msg, "cd")

	-- End of Starfall
	starfall_flag = false
	star_crit = 0
	star_dam = 0
end

function DruidFriend:CheckTaunt(sourceGUID, spellid)
	if (not self.db.profile.taunt.own and sourceGUID == UnitGUID("player")) or
	   (not self.db.profile.taunt.other and sourceGUID ~= UnitGUID("player")) then
		return false
	end

	-- Is it a pet taunt?
	if (pettaunt_ids[spellid] or petaggro_ids[spellid]) then
		-- Are we listing pet taunts?
		if (not self.db.profile.taunt.pet and pettaunt_ids[spellid]) or
		   (not self.db.profile.taunt.petaggro and petaggro_ids[spellid]) then
			return false
		end
		
		if (self.db.profile.taunt.noisypet) then
			-- No limit on how many times to output
			return true
		end

		-- Otherwise only say something the first time a pet does it per combat
		if CombatPetTaunt[sourceGUID] then
			return false
		else
			CombatPetTaunt[sourceGUID] = true
			return true
		end
	end

	if taunt_ids[spellid] then
		return true
	end
	return false
end

