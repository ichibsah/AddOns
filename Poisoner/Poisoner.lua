
--
--	Poisoner by humfras
--	All rights reserved
--

Poisoner = LibStub("AceAddon-3.0"):NewAddon("Poisoner", "AceConsole-3.0", "AceEvent-3.0")

local function debug(...)
	if Poisoner.debug then
		Poisoner:Print(...)
	end
end

Poisoner.Buttons = {}

local textureprefix = "Interface\\Icons\\"
local texturesuffix = ""
local playerGUID, playerClass
local currentbuffs = {}
local k, v, cat, t, spelltable, spellID, _
local tempshowauraframe = false
local initialized = false
local fishingpole = select(7,GetItemInfo(6256))
local hasfishingpole = false
local inInstance = false
local threshold = 5*60
local canCast = {
	["Lethal"] = false,
	["Non-Lethal"] = false,
}

local maxtempmodels = 0

local weaponslot = {
	[16] = "MainHandSlot",
	[17] = "SecondaryHandSlot",
}
local weaponid = {
	["MainHandSlot"] = 0,
	["SecondaryHandSlot"] = 0,
}
local activesound = {
	["expiring"] = 0,
	["nopoison"] = 0,
}
local activepoison = {
	["Lethal"] = false,
	["Non-Lethal"] = false,
}
local iscasting = {
	["Lethal"] = false,
	["Non-Lethal"] = false,
}

if true then
	textureprefix = "Interface\\AddOns\\Poisoner\\images\\"
end

local fbtexturescfg = {
	[1] = "Classic",
	[2] = "Poison_06",
}
local fbtextures = {
	["Classic"] = "Spell_Nature_CorrosiveBreath",
	["Poison_06"] = "Ability_Creature_Poison_06",
}

local color = {
	BLUE = "|cff0000ff";
	GOLD = "|cffcfb52b";
	GREEN = "|cff00ff00";	-- Poison
	GREY = "|cff808080";
	NEON_BLUE = "|cff4d4dff";
	ORANGE = "|cffff6d00";
	PURPLE = "|cff700090";
	RED = "|cffff0000";		-- "not"
	WHITE = "|cffffffff";
	YELLOW = "|cffffff00";
	END = "|r";
}

local fstrata = {
	[1] = "BACKGROUND",
	[2] = "LOW",
	[3] = "MEDIUM",
	[4] = "HIGH",
	[5] = "DIALOG",
	[6] = "FULLSCREEN",
	[7] = "FULLSCREEN_DIALOG",
	[8] = "TOOLTIP",
}

local spells = {
	[2823] = "Deadly Poison",
	[8679] = "Wound Poison",
	[157584] = "Instant Poison",
	[3408] = "Crippling Poison",
	[5761] = "Mind-numbing Poison",
	[108211] = "Leeching Poison",
--	[108215] = "Paralytic Poison",
	[200802] = "Agonizing Poison",
}

local spelltoreplace = {
	[157584] = 2823,
}

local spellreplace = {
--	[2823] = 157584,
}

local spellgroup = {
	[2823] = "Lethal",
	[8679] = "Lethal",
	[157584] = "Lethal",
	[200802] = "Lethal",
	
	[3408] = "Non-Lethal",
	[5761] = "Non-Lethal",
	[108211] = "Non-Lethal",
--	[108215] = "Non-Lethal",
}

local poisons = {
	["Lethal"] = {
		[2823] = "Deadly Poison",
		[8679] = "Wound Poison",
		[157584] = "Instant Poison",
		[200802] = "Agonizing Poison",
	},
	["Non-Lethal"] = {
		[3408] = "Crippling Poison",
		[5761] = "Mind-numbing Poison",
		[108211] = "Leeching Poison",
	--	[108215] = "Paralytic Poison",
	},
}

local statusfunc = {
	instance = function() return not inInstance end,
	combat = function() return not Poisoner.InCombatLockdown end,
	resting = IsResting,
	mounted = IsMounted,
	fishing = function() return hasfishingpole end,
	vehicle = function() return UnitHasVehicleUI("player") end,	--UnitInVehicle("player") end,
	deadorghost = function() return UnitIsDeadOrGhost("player") end,
	ontaxi = function() return UnitOnTaxi("player") end,
}

local events = {
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,
	["PLAYER_ENTERING_WORLD"] = true,
	["PLAYER_LEAVING_WORLD"] = true,
	["SPELLS_CHANGED"] = true,
	["PLAYER_REGEN_DISABLED"] = true,
	["PLAYER_REGEN_ENABLED"] = true,
--	["UNIT_AURA"] = true,
	["UNIT_SPELLCAST_START"] = true,
	["PLAYER_EQUIPMENT_CHANGED"] = true,
	["UNIT_LEVEL"] = true,
	["PLAYER_SPECIALIZATION_CHANGED"] = true,
}

local CLEU_events = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_INTERRUPT"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_UPDATE_COOLDOWN"] = true,
--	["SPELL_CAST_START"] = true,
}

local function GetSquarePoint(angle, lengthX, lengthY, clockwise)
	if not lengthY and lengthX then lengthY = lengthX end
	local angle = tonumber(angle)
	local lengthX = tonumber(lengthX)
	local lengthY = tonumber(lengthY)
	
	while angle > 360 do
		angle = angle - 360
	end
	
	if not clockwise then
		angle = 360 - angle
	end
	
	local x, y, per = 0, 0, 0
	local modx, mody = 1, 1
	
	if angle == 270 then
		x = -lengthX/2
		y = lengthY/2
	elseif angle == 180 then
		x = lengthX/2
		y = lengthY/2
	elseif angle == 90 then
		x = lengthX/2
		y = -lengthY/2
	elseif angle == 0 or angle == 360 then
		x = -lengthX/2
		y = -lengthY/2
	elseif angle > 270 then
		angle = angle - 270
		per = 100/90*angle
		if per == 50 then
			x = -lengthX/2
			y = 0
		else
			x = -lengthX/2
			y = 0 + lengthY/2 - lengthY*per/100
		end
	elseif angle > 180 then
		angle = angle - 180
		per = 100/90*angle
		if per == 50 then
			x = 0
			y = lengthY/2
		else
			x = 0 + lengthX/2 - lengthX*per/100
			y = lengthY/2
		end
	elseif angle > 90 then
		angle = angle - 90
		per = 100/90*angle
		if per == 50 then
			x = lengthX/2
			y = 0
		else
			x = lengthX/2
			y = 0 - lengthY/2 + lengthY*per/100
		end
	else
		per = 100/90*angle
		if per == 50 then
			x = 0
			y = -lengthY/2
		else
			x = 0 - lengthX/2 + lengthX*per/100
			y = -lengthY/2
		end
	end
	
	return x, y
	
end

local function GetCircularPoint(angle, radius, clockwise)
	
	local angle = tonumber(angle)
	local radius = tonumber(radius)
	
	while angle > 360 do
		angle = angle - 360
	end
	
	if clockwise then
		angle = 360 - angle
	end
	
	local x, y
	
	if angle == 270 then
		x = -radius
		y = 0
	elseif angle == 180 then
		x = 0
		y = -radius
	elseif angle == 90 then
		x = radius
		y = 0
	elseif angle == 0 or angle == 360 then
		x = 0
		y = radius
	elseif angle > 270 then
		x = -(radius * cos(angle-270))
		y = radius * sin(angle-270)
	elseif angle > 180 then
		x = -(radius * sin(angle-180))
		y = -(radius * cos(angle-180))
	elseif angle > 90 then
		x = radius * cos(angle-90)
		y = -(radius * sin(angle-90))
	else
		x = radius * sin(angle)
		y = radius * cos(angle)
	end
	
	return x,y
	
end

local function get8coords(l,r,t,b,rota)
	
	rota = tonumber(rota)
	
	if rota == 90 then
		return l, b, r, b, l, t, r, t
	elseif rota == 180 then
		return r, b, r, t, l, b, l, t
	elseif rota == 270 then
		return r, t, l, t, r, b, l, b
	else
		return l, t, l, b, r, t, r, b
	end
	
end


local defaults = {
	profile = {
		enabled = true,
		freebutton = {
			enabled = true,
			tooltip = true,
			texture = 1,
			alpha = 1,
			scale = 0.85,
			framelevel = 1,
			framestrata = 3,
			roundtexture = true,
			minimapborder = true,
			texturesize = 23,
			mmbtexturesize = 66,
			mmbofsx = -3.7,
			mmbofsy = 2.7,
			point = {
				p = "CENTER",
				rf = "UIParent",
				rp = "CENTER",
				x = 0,
				y = 0,
			},
			behavior = {
				regclick = "Up",
			},
		},
		menu = {
			alpha = 1,
			scale = 1,
			visible = true,
			framelevel = 1,
			framestrata = 4,
			relativepoint = "LEFT",
			texture = "Own",
			roundtexture = true,
			tooltip = "full", --or "name"
			animation = {
				nummodels = 3,
				modelscale = 0.02,
				animationtime = 2,	--in sec
				shape = "round",
				radius = 16,
				clockwise = true,
			},
			point = {
				p = "RIGHT",
				rf = "Poisoner_FreeButton",
				rp = "LEFT",
				x = 0,
				y = 0,
			},
			behavior = {
				regclick = "Up",
				autoshowmenuonmouseover = false,
			},
		},
		aurabutton = {
			alpha = 1,
			lowalpha = 0.5,
			scale = 1,
			framelevel = 1,
			framestrata = "MEDIUM",
			point = {
				p = "CENTER",
				rf = "UIParent",
				rp = "CENTER",
				x = 0,
				y = 0,
			},
		},
		warning = {
			enabled = true,
			frequency = 1,	--in seconds
			delay = 60,	--in seconds
			warnonlyonce = false,
			threshold = 5, --in minutes
			output = {
				chat = true,
				errorframe = true,
				aura = true,
				sound = true,
			},
			hide = {
				combat = false,
				instance = false,
				mounted = true,
				resting = true,
				fishing = true,
				vehicle = true,
				deadorghost = true,
				ontaxi = true,
			},
			aura = {
				scale = 1,
				alpha = 1,
				point = {
					p = "CENTER",
					rf = "UIParent",
					rp = "CENTER",
					x = 0,
					y = 150,
				},
			},
		},
		poisons = {
			lastused = {
				["Lethal"] = "",
				["Non-Lethal"] = "",
			},
			ignored = {},
			
		},
	},
}

local function isconfigopen()
	local cfg = LibStub("AceConfigDialog-3.0").OpenFrames.Poisoner
	if cfg then
		return true
	else
		return false
	end
end

function Poisoner:OnInitialize()
		
	self.db = LibStub("AceDB-3.0"):New("PoisonerDB", defaults, true)
	
	self:GetOptions()	--create options

	local LibDualSpec = LibStub("LibDualSpec-1.0")
	LibDualSpec:EnhanceDatabase(self.db, "Poisoner")
	LibDualSpec:EnhanceOptions(self.Options.args.profile, self.db)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "ToggleEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "ToggleEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "ToggleEnable")
	
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Poisoner", self:GetOptions())
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PoisonerSlashCommand", self.OptionsSlash, {"Poisoner", "poisoner"})
	
	self.debug = false
	
	self.NeedUpdate = {--[[
		--This table stores the secure code functions that needs to be executed after leaving combat
		CreateMainButton = true,
		CreateMenu = true,
		CreateButtons = true,
		CreateAuraButtonFrame = true,
		CreateAuraButtons = true,
	]]}
	
end

function Poisoner:ToggleEnable()
	if self.db.profile.enabled then
		self:OnEnable()
	else
		self:OnDisable()
	end
end

function Poisoner:OnEnable()
	if self.InCombatLockdown or InCombatLockdown() then self.NeedUpdate.OnEnable = true return end
	
--Check Playerclass
	playerClass = select(2,UnitClass("player"))
	playerGUID = UnitGUID("player")
	
	if not self.db.profile.enabled then
		return
	elseif playerClass ~= "ROGUE" then
		self:Print("not loaded. - Reason: wrong player class!\nPlease disable Poisoner in the AddOn selection menu to save resources.")
		return
	end
	
--Events
	for k,v in pairs(events) do
		self:RegisterEvent(k)
	end
	
--Create Tables and Frames
	self.specHasPoisons = GetSpecialization() == 1	--only Assassination spec has poisons in Legion
	self:GetWeapons()
	self:CheckFishingPole()
	self:CheckBuffs("OnEnable")
	self:CreateFrames()
	
	if initialized then
		self:CreateOnUpdateHandler()
	end
	--self:UpdateFrameVisibility(true)
	self:UNIT_LEVEL("player")
	
end

function Poisoner:OnDisable()
	if self.InCombatLockdown or InCombatLockdown() then self.NeedUpdate.OnDisable = true return end
	
	for k,v in pairs(events) do
		self:UnregisterEvent(k)
	end

	self:UpdateFrameVisibility(false)
	
end

function Poisoner:UpdateFrameVisibility(val)
	
	local pm = _G["Poisoner_Menu"]
	if pm then
		local isvisible = pm:IsShown()	--pm:IsVisible()
		if val == true then
			pm:Show()
		elseif val == false then
			pm:Hide()
			self.db.profile.menu.visible = (isvisible and true) or false
		end
	end
	
	local pfb = _G["Poisoner_FreeButton"]
	if pfb then
		if val == true then
			pfb:Show()
		elseif val == false then
			pfb:Hide()
		end
	end
	
	local puh = _G["Poisoner_OnUpdateHandler"]
	if puh then
		if val == true and initialized then
			self:CreateOnUpdateHandler()
		elseif val == false then
			puh:SetScript("OnUpdate", nil)
			self:DisableWarning("OnDisable")
		end
	end
	
	local af = _G["Poisoner_AuraFrame"]
	if af then
		if val == true then
		--	af:Show()
		elseif val == false then
			af:Hide()
		end
	end
	
end


-- Slash commands
Poisoner.OptionsSlash = {
	type = "group",
	name = "Slash Command",
	order = -3,
	args = {
		config = {
			type = "execute",
			name = "Configure",
			desc = "Open the configuration dialog ( /poisoner config )",
			func = function() Poisoner:ShowConfig() end,
			guiHidden = true,
		},
		enable = {
			type = "execute",
			name = "Enable",
			desc = "Enable Poisoner ( /poisoner show )",
			func = function() Poisoner.db.profile.enabled = true; Poisoner:OnEnable() end,
		},
		disable = {
			type = "execute",
			name = "Disable",
			desc = "Disable Poisoner ( /poisoner hide )",
			func = function() Poisoner.db.profile.enabled = false; Poisoner:OnDisable() end,
		},
		plt = {
			type = "execute",
			name = "plt",
			desc = "Prints Poisoner's local tables (for bug reporting)",
			func = function() Poisoner:PrintLocalTables() end,
		},
	},
}

-- Config
function Poisoner:ShowConfig()
	-- not using Blizzard's Interface options because of taint issues
--	InterfaceOptionsFrame_OpenToCategory("Poisoner")
	if Poisoner.InCombatLockdown or InCombatLockdown() then
		Poisoner:Print("Can not open config while in combat.")
		return
	end
	LibStub("AceConfigDialog-3.0"):Open("Poisoner")
end

function Poisoner:ToggleConfig()
	-- not using Blizzard's Interface options because of taint issues
--	InterfaceOptionsFrame_OpenToCategory("Poisoner")
	if Poisoner.InCombatLockdown or InCombatLockdown() then
		Poisoner:Print("Can not open config while in combat.")
		return
	end
	if isconfigopen() then
		LibStub("AceConfigDialog-3.0"):Close("Poisoner")
	else
		LibStub("AceConfigDialog-3.0"):Open("Poisoner")
	end
end

-- Options table
function Poisoner:GetOptions()
if not Poisoner.Options then
	Poisoner.Options = {
		type = "group",
		name = "Poisoner",
		handler = Poisoner,
		set = function(info, value) db[ info[#info] ] = value end,
		get = function(info) return db[ info[#info] ] end,
		args = {
			enable = {
				name = "Enable",
				desc = "Enables / disables Poisoner",
				order = 0,
				type = "toggle",
				set = function(info,val)
						self.db.profile.enabled = val
						Poisoner:ToggleEnable()
					end,
				get = function(info) return self.db.profile.enabled end
			},
			freebutton = {
				name = "FreeButton",
				order = 2,
				type = "group",
				args = {
					enable = {
						name = "Enable",
						desc = "Enables / disables Poisoner",
						order = 0,
						type = "toggle",
						set = function(info,val)
								self.db.profile.freebutton.enabled = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile.freebutton.enabled end
					},
					tooltip = {
						name = "show tooltip",
						desc = "Show/Hide the Freebuton's tooltip",
						order = 0.1,
						type = "toggle",
						set = function(info,val)
								self.db.profile.freebutton.tooltip = val
							end,
						get = function(info) return self.db.profile.freebutton.tooltip end
					},
					header = {
						name = "Button Texture",
						order = 1,
						type = "header",
						width = "full",
					},
					texture = {
						name = "Texture",
						desc = "",
						type = "select",
						order = 1.1,
						values = fbtexturescfg,
						set = function(info, val)
							self.db.profile[info[1]].texture = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile[info[1]].texture
						end,
					},
					texturesize = {
						name = "texturesize",
						desc = "The FreeButton's texture size",
						order = 1.11,
						type = "range",
						min = 10,
						max = 32,
						step = 1,
						set = function(info, val)
							self.db.profile[info[1]].texturesize = val;
							Poisoner:CreateFrames()
						end,
						get = function(info) return self.db.profile[info[1]].texturesize end
					},
					roundtexture = {
						name = "circular texture",
						desc = "Use circular textures instead of the default square ones.",
						order = 1.2,
						type = "toggle",
						set = function(info,val)
								self.db.profile[info[1]].roundtexture = val
								if val == false then
									self.db.profile[info[1]].minimapborder = val
								end
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile[info[1]].roundtexture end
					},
					description1 = {
						name = " ",
						order = 1.21,
						type = "description"
					},
					minimapborder = {
						name = "MinimapButton texture",
						desc = "Show the MinimapButton border texture.\n(Requires \"circular texture\".)",
						order = 1.3,
						type = "toggle",
						set = function(info,val)
								self.db.profile[info[1]].minimapborder = val
								if val == true then
									self.db.profile[info[1]].roundtexture = val
								end
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile[info[1]].minimapborder end
					},
					mmbtexturesize = {
						name = "MinimapBorder texture size",
						desc = "The FreeButton's MinimapBorder texture size",
						order = 1.31,
						type = "range",
						min = 10,
						max = 100,
						step = 1,
						set = function(info, val)
							self.db.profile[info[1]].mmbtexturesize = val;
							Poisoner:CreateFrames()
						end,
						get = function(info) return self.db.profile[info[1]].mmbtexturesize end
					},
					mmbofsx = {
						name = "MinimapBorder X offset",
						desc = "Changes the MinimapBorders' placement",
						order = 1.4,
						type = "range",
						min = -20,
						max = 20,
						step = 0.05,
						set = function(info, val)
							self.db.profile[info[1]].mmbofsx = val;
							Poisoner:CreateFrames()
						end,
						get = function(info) return self.db.profile[info[1]].mmbofsx end
					},
					mmbofsy = {
						name = "MinimapBorder Y offset",
						desc = "Changes the MinimapBorders' placement",
						order = 1.41,
						type = "range",
						min = -20,
						max = 20,
						step = 0.05,
						set = function(info, val)
							self.db.profile[info[1]].mmbofsy = val;
							Poisoner:CreateFrames()
						end,
						get = function(info) return self.db.profile[info[1]].mmbofsy end
					},
					header2 = {
						name = "Visuals",
						order = 2,
						type = "header",
						width = "full",
					},
					scale = {
						name = "Scale",
						desc = "Poisoner main frame scale",
						order = 2.1,
						type = "range",
						min = 0.2,
						max = 2,
						step = 0.05,
						set = function(info, val)
							self.db.profile[info[1]].scale = val;
							Poisoner:CreateFrames()
						end,
						get = function(info) return self.db.profile[info[1]].scale end
					},
					alpha = {
						name = "Alpha",
						desc = "Poisoner main frame alpha",
						order = 2.2,
						type = "range",
						min = 0,
						max = 1,
						step = 0.05,
						set = function(info, val) self.db.profile[info[1]].alpha = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile[info[1]].alpha end
					},
					framestrata = {
						name = "Frame Strata",
						desc = "Controls the PoisonMenu framestrata. Default: HIGH",
						type = "select",
						order = 2.3,
						values = fstrata,
						set = function(info, val)
							self.db.profile[info[1]].framestrata = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile[info[1]].framestrata
						end,
					},
					framelevel = {
						name = "Frame Level",
						desc = "PoisonMenu frame level",
						order = 2.4,
						type = "range",
						min = 1,
						max = 20,
						step = 1,
						set = function(info, val) self.db.profile[info[1]].framelevel = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile[info[1]].framelevel end
					},
					header3 = {
						name = "Click/Mouse behavior",
						order = 3,
						type = "header",
						width = "full",
					},
					regclick = {
						name = "Click trigger",
						desc = "Controls the click behavior. Default: Up",
						type = "select",
						order = 3.1,
						values = {["Up"] = "Up", ["Down"] = "Down"},
						set = function(info, val)
							self.db.profile[info[1]].behavior.regclick = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile[info[1]].behavior.regclick
						end,
					},
					autoshowmenuonmouseover = {
						name = "Show Menu on mouseover",
						desc = "Automatically show the menu on mouseover.",
						order = 3.2,
						type = "toggle",
						width = "full",
						set = function(info,val)
								self.db.profile.menu.behavior.autoshowmenuonmouseover = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile.menu.behavior.autoshowmenuonmouseover end
					},
				},
			},
			menu = {
				name = "Menu",
				order = 2,
				type = "group",
				disabled = function() return not self.db.profile.freebutton.enabled end,
				args = {
					header = {
						name = "Button Texture",
						order = 0,
						type = "header",
						width = "full",
					},
					roundtexture = {
						name = "circular texture",
						desc = "Use circular textures instead of the default square ones.",
						order = 0.1,
						type = "toggle",
						set = function(info,val)
								self.db.profile[info[1]].roundtexture = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile[info[1]].roundtexture end
					},
					texture = {
						name = "Own textures",
						desc = "Use the included, borderless textures instead of the default ones.",
						order = 0.2,
						type = "toggle",
						set = function(info,val)
								if val == true then
									self.db.profile[info[1]].texture = "Own"
								else
									self.db.profile[info[1]].texture = false
								end
								Poisoner:CreateFrames()
							end,
						get = function(info) if self.db.profile[info[1]].texture == "Own" then return true else return false end end
					},--[[
					description = {
						name = " ",
						order = 0.2,
						type = "description"
					},]]
					header1 = {
						name = "Tooltip",
						order = 1,
						type = "header",
						width = "full",
					},
					tooltip = {
						name = "Tooltip",
						desc = "Show the spell tooltip or the spell name only. Default: full",
						type = "select",
						order = 1.1,
						values = {["full"] = "full", ["name"] = "name", ["none"] = "none"},
						set = function(info, val)
							self.db.profile.menu.tooltip = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile.menu.tooltip
						end,
					},
					description1 = {
						name = " ",
						order = 1.2,
						type = "description"
					},
					header2 = {
						name = "Animation",
						order = 2,
						type = "header",
						width = "full",
					},
					shape = {
						name = "Animation Shape",
						desc = "Controls the animation's shape. Default: circular",
						type = "select",
						order = 2.01,
						values = {["square"] = "square", ["round"] = "circular"},
						set = function(info, val)
							self.db.profile.menu.animation.shape = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile.menu.animation.shape
						end,
					},
					clockwise = {
						name = "Clockwise rotation",
						desc = "Changes the rotational direction clockwise/counter-clockwise.",
						order = 2.02,
						type = "toggle",
						set = function(info,val)
								self.db.profile.menu.animation.clockwise = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile.menu.animation.clockwise end
					},
					radius = {
						name = "Animation radius",
						desc = "The animation's radial offset from the button's center.\n(Default: 16)",
						order = 2.1,
						type = "range",
						min = 0,
						max = 32,
						step = 0.5,
						set = function(info, val) self.db.profile.menu.animation.radius = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.animation.radius end
					},
					nummodels = {
						name = "Number of Models/Sprites",
						desc = "How many Models/Sprites rotating around the active poison should be visible?",
						order = 2.11,
						type = "range",
						min = 0,
						max = 12,
						step = 1,
						set = function(info, val) self.db.profile.menu.animation.nummodels = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.animation.nummodels end
					},
					modelscale = {
						name = "Model/Sprite scale",
						desc = "Scales the Models/Sprites",
						order = 2.2,
						type = "range",
						min = 0.005,
						max = 0.05,
						step = 0.005,
						set = function(info, val) self.db.profile.menu.animation.modelscale = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.animation.modelscale end
					},
					animationtime = {
						name = "Animation time (sec)",
						desc = "The time frame the animation needs for a full cycle (in seconds)",
						order = 2.3,
						type = "range",
						min = 0.5,
						max = 10,
						step = 0.5,
						set = function(info, val) self.db.profile.menu.animation.animationtime = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.animation.animationtime end
					},
					header3 = {
						name = "Visuals",
						order = 3,
						type = "header",
						width = "full",
					},
					scale = {
						name = "Scale",
						desc = "PoisonMenu frame scale",
						order = 3.1,
						type = "range",
						min = 0.2,
						max = 2,
						step = 0.05,
						set = function(info, val) self.db.profile.menu.scale = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.scale end
					},
					alpha = {
						name = "Alpha",
						desc = "PoisonMenu frame alpha",
						order = 3.2,
						type = "range",
						min = 0,
						max = 1,
						step = 0.05,
						set = function(info, val) self.db.profile.menu.alpha = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.alpha end
					},
					framestrata = {
						name = "Frame Strata",
						desc = "Controls the PoisonMenu framestrata. Default: HIGH",
						type = "select",
						order = 3.3,
						values = fstrata,
						set = function(info, val)
							self.db.profile.menu.framestrata = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile.menu.framestrata
						end,
					},
					framelevel = {
						name = "Frame Level",
						desc = "PoisonMenu frame level",
						order = 3.4,
						type = "range",
						min = 1,
						max = 20,
						step = 1,
						set = function(info, val) self.db.profile.menu.framelevel = val; Poisoner:CreateFrames() end,
						get = function(info) return self.db.profile.menu.framelevel end
					},
					header4 = {
						name = "Click/Mouse behavior",
						order = 4,
						type = "header",
						width = "full",
					},
					regclick = {
						name = "Click trigger",
						desc = "Controls the click behavior. Default: Up",
						type = "select",
						order = 4.1,
						values = {["Up"] = "Up", ["Down"] = "Down"},
						set = function(info, val)
							self.db.profile[info[1]].behavior.regclick = val; Poisoner:CreateFrames()
						end,
						get = function(info, val)
							return self.db.profile[info[1]].behavior.regclick
						end,
					},
					autoshowmenuonmouseover = {
						name = "Show Menu on mouseover",
						desc = "Automatically show the menu on mouseover.",
						order = 4.2,
						type = "toggle",
						width = "full",
						set = function(info,val)
								self.db.profile[info[1]].behavior.autoshowmenuonmouseover = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile[info[1]].behavior.autoshowmenuonmouseover end
					},
				},
			},
			warning = {
				name = "Warnings",
				order = 4,
				type = "group",
				args = {
					enable = {
						name = "Enable",
						desc = "Enables / disables the warning system",
						order = 0,
						type = "toggle",
						set = function(info,val)
								self.db.profile.warning.enabled = val
								Poisoner:CreateFrames()
							end,
						get = function(info) return self.db.profile.warning.enabled end
					},
					header = {
						name = "",
						order = 1,
						type = "header",
						width = "full",
					},
					frequency = {
						name = "Update frequency (sec)",
						desc = "The time threshold (in seconds) when the buff time check should run (default: 1 second).",
						order = 1.01,
						type = "range",
						min = 0.5,
						max = 30,
						step = 0.5,
						width = "full",
						set = function(info, val) self.db.profile.warning.frequency = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
						get = function(info) return self.db.profile.warning.frequency end
					},
					threshold = {
						name = "Threshold (min)",
						desc = "The time threshold (in minutes) below which the text/audio/aura warnings should be activated.",
						order = 1.1,
						type = "range",
						min = 0.5,
						max = 30,
						step = 0.5,
						width = "full",
						set = function(info, val) self.db.profile.warning.threshold = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
						get = function(info) return self.db.profile.warning.threshold end
					},
					warnonlyonce = {
						name = "Warn only once",
						desc = "Poisoner warns only once per slot (lethal and non-lethal). This state will reset after mounting/resting/death/taxi/vehicle.",
						order = 1.2,
						type = "toggle",
						set = function(info, val) self.db.profile.warning.warnonlyonce = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
						get = function(info) return self.db.profile.warning.warnonlyonce end
					},
					delay = {
						name = "Warning delay (sec)",
						desc = "The time between text and audio warning output in seconds.",
						order = 1.3,
						type = "range",
						width = "full",
						min = 5,
						max = 600,
						step = 5,
						disabled = function() return self.db.profile.warning.warnonlyonce end,
						set = function(info, val) self.db.profile.warning.delay = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
						get = function(info) return self.db.profile.warning.delay end
					},
					header2 = {
						name = "",
						order = 2,
						type = "header",
						width = "full",
					},
					output = {
						type = "group",
						order = 3,
						name = "Output",
						inline = true,
						args = {
							chat = {
								type = "toggle", order = 1,
								width = "normal", descStyle = "",
								name = "|TInterface\\Icons\\INV_Inscription_Scroll:16:16|t ChatFrame",
								set = function(info, val) self.db.profile.warning.output.chat = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.output.chat end
							},
							errorframe = {
								type = "toggle", order = 2,
								width = "normal", descStyle = "",
								name = "|TInterface\\Icons\\Ability_Warrior_FocusedRage:16:16|t UIErrorFrame",
								set = function(info, val) self.db.profile.warning.output.errorframe = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.output.errorframe end
							},
							aura = {
								type = "toggle", order = 3,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\ACHIEVEMENT_GUILDPERK_QUICK AND DEAD:16:16|t Aura   (see options below)",
								set = function(info, val) self.db.profile.warning.output.aura = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.output.aura end
							},
							sound = {
								type = "toggle", order = 4,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\Ability_Warrior_RallyingCry:16:16|t Sound",
								set = function(info, val) self.db.profile.warning.output.sound = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.output.sound end
							},
						},
					},
					hide = {
						type = "group",
						order = 4,
						name = "Hide when...",
						inline = true,
						args = {
							combat = {
								type = "toggle", order = 0.1,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\Ability_DualWield:16:16|t not in combat",
								set = function(info, val) self.db.profile.warning.hide.combat = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.combat end
							},
							instance = {
								type = "toggle", order = 0.2,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\Spell_Arcane_PortalIronForge:16:16|t not in instance (Arena, BG, Raid, Group Instance)",
								set = function(info, val) self.db.profile.warning.hide.instance = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.instance end
							},
							resting = {
								type = "toggle", order = 1,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\Spell_Nature_Sleep:16:16|t resting",
								set = function(info, val) self.db.profile.warning.hide.resting = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.resting end
							},
							mounted = {
								type = "toggle", order = 2,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\ABILITY_MOUNT_DREADSTEED:16:16|t mounted",
								set = function(info, val) self.db.profile.warning.hide.mounted = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.mounted end
							},
							fishing = {
								type = "toggle", order = 2,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\INV_Fishingpole_02:16:16|t fishing",
								set = function(info, val) self.db.profile.warning.hide.fishing = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.fishing end
							},
							deadorghost = {
								type = "toggle", order = 3,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\Ability_Creature_Cursed_02:16:16|t dead or ghost",
								set = function(info, val) self.db.profile.warning.hide.deadorghost = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.deadorghost end
							},
							vehicle = {
								type = "toggle", order = 4,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\INV_Gizmo_02:16:16|t in vehicle",
								set = function(info, val) self.db.profile.warning.hide.vehicle = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.vehicle end
							},
							ontaxi = {
								type = "toggle", order = 5,
								width = "full", descStyle = "",
								name = "|TInterface\\Icons\\achievement_guild_ridelikethewind:16:16|t on taxi (fly path)",
								set = function(info, val) self.db.profile.warning.hide.ontaxi = val; Poisoner:CreateFrames(); Poisoner:CreateOnUpdateHandler() end,
								get = function(info) return self.db.profile.warning.hide.ontaxi end
							},
						},
					},
					header5 = {
						name = "",
						order = 5,
						type = "header",
						width = "full",
					},
					auraoptions = {
						type = "group",
						order = 5.1,
						name = "Aura options",
						inline = true,
						args = {
							tempshowbg = {
								name = "Temp. show Aura frame",
								desc = "Shows the ",
								order = 0.1,
								type = "toggle",
								width = "full",
								set = function(info,val)
										tempshowauraframe = val
										local t = _G["Poisoner_AuraFrame_Background"]
										if t then
											if val then
												t.texture:SetTexture(0,1,0,1)
											else
												t.texture:SetTexture(1,1,1,0)
											end
										end
									end,
								get = function(info) return tempshowauraframe end
							},
							scale = {
								name = "Scale",
								desc = "Aura frame scale",
								order = 1,
								type = "range",
								min = 0.2,
								max = 2,
								step = 0.1,
								set = function(info, val)
									self.db.profile.warning.aura.scale = val;
									Poisoner:CreateAuraFrame()
								end,
								get = function(info) return self.db.profile.warning.aura.scale end
							},
							alpha = {
								name = "Alpha",
								desc = "Aura frame alpha",
								order = 1.1,
								type = "range",
								min = 0,
								max = 1,
								step = 0.05,
								set = function(info, val)
									self.db.profile.warning.aura.alpha = val;
									Poisoner:CreateAuraFrame()
								end,
								get = function(info) return self.db.profile.warning.aura.alpha end
							},
							description2 = {
								name = " \n ",
								order = 2,
								type = "description",
								width = "full",
							},
							header2 = {
								name = "Positioning (relative to the UI's center)",
								order = 2.01,
								type = "header",
								width = "full",
							},
							description21 = {
								name = " ",
								order = 2.03,
								type = "description",
								width = "full",
							},
							x = {
								name = "X offset",
								desc = "Modifies the horizontal position",
								order = 2.1,
								type = "range",
								min = -1000,
								max = 1000,
								step = 1,
								set = function(info, val)
									self.db.profile.warning.aura.point.x = val;
									Poisoner:CreateAuraFrame()
								end,
								get = function(info) return self.db.profile.warning.aura.point.x end
							},
							y = {
								name = "Y offset",
								desc = "Modifies the vertical position",
								order = 2.1,
								type = "range",
								min = -1000,
								max = 1000,
								step = 1,
								set = function(info, val)
									self.db.profile.warning.aura.point.y = val;
									Poisoner:CreateAuraFrame()
								end,
								get = function(info) return self.db.profile.warning.aura.point.y end
							},
						},
					},
				},
			},
			
			profile = {
				name = "Profile",
				order = -1,
				type = "group",
				args = {
				},
			},
		}
	}
	
end

	Poisoner.Options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
	return Poisoner.Options
end

Poisoner.Load = ""
function Poisoner:PLAYER_ENTERING_WORLD(event)
	inInstance = IsInInstance()
	if not initialized then
		local isreload = GetRealZoneText()
		self.Load = self.Load.."-NotInitialized".."-"..((isreload and "IsReload") or "NIL")
		if not isreload then
		--	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			self:RegisterEvent("UNIT_AURA")
		else
			self:ZONE_CHANGED_NEW_AREA()
		end
		initialized = true
	else
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	--	self:CheckBuffs(event)
	--	self:CreateOnUpdateHandler()
	end
	self.InWorld = true
end
function Poisoner:PLAYER_LEAVING_WORLD()
	self:CreateOnUpdateHandler(true)
	self.InWorld = false
end

function Poisoner:UNIT_LEVEL(unit)
	--check if unit has the level to cast a lethal/non-lethal spell
	
	if unit ~= "player" then return end
	
	for k,v in pairs(poisons["Lethal"]) do
		if IsSpellKnown(k) then
			canCast["Lethal"] = true
			break
		end
	end
	
	for k,v in pairs(poisons["Non-Lethal"]) do
		if IsSpellKnown(k) then
			canCast["Non-Lethal"] = true
			break
		end
	end
	
	for k,v in pairs(spelltoreplace) do
		if IsSpellKnown(k) then
			spellreplace[v] = k
		end
	end
	
end

function Poisoner:ZONE_CHANGED_NEW_AREA(event)
	event = event or "ZONE_CHANGED_NEW_AREA"
	self:GetWeapons()
	self:CheckFishingPole()
	self:CheckBuffs(event)
	self:CreateOnUpdateHandler()
	
	self:UnregisterEvent(event)	--Only call this once on login.
end

function Poisoner:UNIT_AURA(event, UnitId)
	if UnitId ~= "player" then return end
	
	self:GetWeapons()
	self:CheckFishingPole()
	self:CheckBuffs(event)
	self:CreateOnUpdateHandler()
	
	self:UnregisterEvent(event)	--Only call this once on login. Poisoner uses CLEU for buff tracking afterwards
end

function Poisoner:UNIT_SPELLCAST_START(event, unit, name, rank, lineId, spellID)
	if unit ~= "player" then return end
	if not spells[spellID] then return end
	
	iscasting[spellgroup[spellID]] = true	
end

function Poisoner:PLAYER_REGEN_ENABLED()
	self.InCombatLockdown = false
	local t = self.NeedUpdate
	if next(t) then
		for k,v in pairs(t) do
			t.k = nil
			Poisoner[k](self)
		end
		self:CheckBuffs("PLAYER_REGEN_ENABLED")
	end
end
function Poisoner:PLAYER_REGEN_DISABLED()
	self.InCombatLockdown = true
	LibStub("AceConfigDialog-3.0"):Close("Poisoner")
end

function Poisoner:SPELLS_CHANGED()
	self:CreateButtons()
end

function Poisoner:PLAYER_SPECIALIZATION_CHANGED(event)
	self.specHasPoisons = GetSpecialization() == 1	--only Assassination spec has poisons in Legion
	self:GetWeapons()
	self:CheckFishingPole()
	self:CheckBuffs(event)
	self:UNIT_LEVEL("player")
	self:CreateOnUpdateHandler(false, true)
end

function Poisoner:CheckFishingPole()
	if not fishingpole then
		fishingpole = select(7,GetItemInfo(6256))
	end
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(weaponid["MainHandSlot"])
	if itemSubType == fishingpole then
		hasfishingpole = true
		if self.db.profile.warning.hide.fishing then
			self:DisableWarning("Warning hide fishing")
		end
	else
		hasfishingpole = false
	end
	
	return hasfishingpole
end

function Poisoner:PLAYER_EQUIPMENT_CHANGED(event, slotID, item)
	if slotID ~= 16 and slotID ~= 17 then return end
	if item then
		weaponid[weaponslot[slotID]] = GetInventoryItemID("player", slotID)
		if slotID == 16 then
			self:CheckFishingPole()
		end
	else
		weaponid[weaponslot[slotID]] = 0
	end
	if weaponid["MainHandSlot"] == 0 and weaponid["SecondaryHandSlot"] == 0 then
		self:DisableWarning("No WeaponIds")
	end
end

function Poisoner:COMBAT_LOG_EVENT_UNFILTERED(eventfuncname, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType, amount)
--	debug("CLEU")
	if destGUID ~= playerGUID then return end
	if not spells[spellID] then debug("not spells[", spellID, "]") return end
	if not CLEU_events[event] then debug("not CLEU_events[", event, "]") return end
	debug(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType, amount)
	
	if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
		currentbuffs[spellID] = self:GetBuffDuration(spellID, spellName)
		local sg = spellgroup[spellID]
		self.db.profile.poisons.lastused[sg] = spellID
		iscasting[sg] = false
		activepoison[sg] = spellID
		if self.db.profile.warning.enabled then
			self:AuraWarning("hide", spellID, sg, true)
		end
	elseif event == "SPELL_AURA_REMOVED" then
		if currentbuffs[spellID] then
			currentbuffs[spellID] = nil
			local sg = spellgroup[spellID]
			if not iscasting[sg] then
				activepoison[sg] = false
				if self.db.profile.warning.enabled and self.specHasPoisons then
					self:PlaySound("nopoison")
					self:PrintWarning("nopoison", sg)
					self:AuraWarning("nopoison", spellID, sg, true)
				end
			end
		end
	end
	
end


function Poisoner:GetWeapons()

	for k,v in pairs(weaponid) do
		weaponid[k] = GetInventoryItemID("player", GetInventorySlotInfo(k)) or 0
	end
	
	return weaponid["MainHandSlot"], weaponid["SecondaryHandSlot"]
end

function Poisoner:GetSpellTexture(spellID)
	local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellID)
	return icon
end

function Poisoner:GetAllSpellTextures()
	for k,v in pairs(spells) do
		print(self:GetSpellTexture(k))
	end
end

function Poisoner:CreateFrames()
	if not self.db.profile.enabled or (playerClass and playerClass ~= "ROGUE") then return end
	self:CreateMainButton()
	self:CreateMenu()
	self:CreateButtons()
	self:CreateAuraFrame()
end



-- local frame functions
local function modkeys()
	local shift, ctrl, alt = IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown()
	local modkey = ""
			
	if shift then modkey = modkey.."shift" end
	if ctrl then modkey = modkey.."ctrl" end
	if alt then modkey = modkey.."alt" end
	--print("ReqKey", reqmod,"- ModKey:", modkey)
	
	return modkey
end
--[[
local function savepos(frame, optstring)
	if type(frame) == "string" then frame = _G[frame] end
	if not frame then return end
--	print("Poisoner", "Savepos: ", frame, optstring)
	local p, f, rp, x, y = frame:GetPoint()
	if f then
		f = f:GetName()
	elseif f == nil then
		f = "UIParent"
	end
--	local uiscale = UIParent:GetScale()
--	x = x * uiscale; y = y * uiscale
	local t = {p, f or "UIParent", rp, x, y}
	self.db.profile[optstring].point = {
		p = p, rf = f, rp = rp, x = x, y = y,
	}
end]]

local function savepos(frame, optstring)
	if type(frame) == "string" then frame = _G[frame] end
	if not frame then return end
	
	local centerx, centery = frame:GetCenter()
	
	local scale = frame:GetScale()
	
	local p, f, rp, x, y = "CENTER", "UIParent", "BOTTOMLEFT", centerx*scale, centery*scale
	
	Poisoner.db.profile[optstring].point = {
		p = p, rf = f, rp = rp, x = x, y = y,
	}
end

local function tooltipShow(owner, direction, typ, value)
	--print(owner:GetName(), direction, typ, value, type(value))
	if typ == "text" then
		GameTooltip:SetOwner(owner, direction or "BOTTOMLEFT")
		GameTooltip:SetText(value)
	elseif typ == "spellid" or typ == "itemid" then
		GameTooltip:SetOwner(owner, direction or "BOTTOMLEFT")
		GameTooltip:SetHyperlink(GetSpellLink(value))
	end
	GameTooltip:Show()
end
local function tooltipHide()
	GameTooltip:ClearLines()
	GameTooltip:Hide()
end

-- Classic Menu
local timedupdate, updatedelay = 0, 1000
function Poisoner:CreateMainButton()
	if self.InCombatLockdown or InCombatLockdown() then self.NeedUpdate.CreateMainButton = true return end
	
	local pfb = _G["Poisoner_FreeButton"]
	local pmenu = _G["Poisoner_Menu"]
	
	if not self.db.profile.freebutton.enabled then
		if pfb then
			pfb:Hide()
		end
		if pmenu then
			local isvisible = pmenu:IsVisible()
			pmenu:Hide()
			self.db.profile.menu.visible = (isvisible and true) or false
		end
		return
	else
		if pfb then
			pfb:Show()
		end
	end
	
	
	if pfb == nil then
		pfb = CreateFrame("BUTTON", "Poisoner_FreeButton", UIParent, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate, SecureHandlerEnterLeaveTemplate, SecureHandlerMouseWheelTemplate, SecureHandlerStateTemplate");
	--	pfb:Show()
	end
	
	pfb:RegisterForDrag("LeftButton");
	pfb:SetMovable(true);
	local modkey = "shift"
	
	pfb:SetScript("OnDragStart", function(self)
		if modkeys() == modkey then
			self:StartMoving()
			self.IsMoving = true
		end
	end);
	pfb:SetScript("OnDragStop", function(self)
		if self.IsMoving == true then
			self:StopMovingOrSizing()
			self.IsMoving = false
			savepos(self, "freebutton")
			if Poisoner.InCombatLockdown or InCombatLockdown() then
				Poisoner.NeedUpdate.CreateMainButton = true
			else
				Poisoner:CreateMainButton()
			end
		end
	end);
	
	
	pfb:RegisterForClicks("Any"..self.db.profile.freebutton.behavior.regclick);
--	pfb:SetClampedToScreen(true);
	pfb:SetSize(32,32)
	pfb:SetScale(self.db.profile.freebutton.scale)
	pfb:SetAlpha(self.db.profile.freebutton.alpha)
	
	local fb_af = _G["Poisoner_FreeButton_AlignFrame"]
	if fb_af == nil then
		fb_af = CreateFrame("FRAME", "Poisoner_FreeButton_AlignFrame", UIParent, "SecureHandlerBaseTemplate")
	end
	pfb:SetFrameRef("anchor", Poisoner_FreeButton_AlignFrame);
	fb_af:SetSize(pfb:GetSize())
	fb_af:SetScale(pfb:GetScale())
	fb_af:ClearAllPoints();
	local t = self.db.profile.freebutton.point
	fb_af:SetPoint(t.p, t.rf, t.rp, t.x/fb_af:GetScale(), t.y/fb_af:GetScale());
	
	pfb:ClearAllPoints();
	pfb:SetPoint("CENTER", Poisoner_FreeButton_AlignFrame, "CENTER", 0, 0)
	
	pfb:SetFrameStrata(fstrata[self.db.profile.freebutton.framestrata])
	pfb:SetFrameLevel(self.db.profile.freebutton.framelevel)
	
	local texture = textureprefix..(fbtextures[fbtexturescfg[self.db.profile.freebutton.texture]] or fbtextures["Classic"])..texturesuffix	
	if not pfb.Texture then
		pfb.Texture = pfb:CreateTexture(pfb:GetName().."Icon", "ARTWORK");
	end
	pfb.Texture:SetTexture(texture)
	pfb.Texture:ClearAllPoints()
	--pfb.Texture:SetAllPoints(pfb)
	pfb.Texture:SetPoint("CENTER", pfb, "CENTER", 0, 0)
	pfb.Texture:SetTexCoord(0,1,0,1)
	local size = self.db.profile.freebutton.texturesize
	pfb.Texture:SetSize(size, size)
	
	pfb:SetNormalTexture(texture)
	pfb:SetHighlightTexture(texture)
	
	local tex = pfb:GetNormalTexture()
	tex:ClearAllPoints()
	tex:SetPoint("CENTER", pfb, "CENTER", 0, 0)
	local size = self.db.profile.freebutton.texturesize
	tex:SetSize(size, size)
	
	local mbtexture = "Interface\\AddOns\\Poisoner\\images\\MiniMap-TrackingBorder"
	if self.db.profile.freebutton.minimapborder then
		if not pfb.MinimapBorder then
			pfb.MinimapBorder = pfb:CreateTexture(pfb:GetName().."MinimapBorder", "OVERLAY");
		end
		local mmbsize = self.db.profile.freebutton.mmbtexturesize
		pfb.MinimapBorder:SetTexture(mbtexture)
		pfb.MinimapBorder:SetSize(mmbsize,mmbsize)
		pfb.MinimapBorder:ClearAllPoints()
		pfb.MinimapBorder:SetPoint("TOPLEFT", pfb, "TOPLEFT", self.db.profile.freebutton.mmbofsx, self.db.profile.freebutton.mmbofsy)
		pfb.MinimapBorder:Show()

		pfb:SetHighlightTexture(mbtexture)
		local f = pfb:GetHighlightTexture()
		f:ClearAllPoints()
		f:SetSize(mmbsize,mmbsize)
		f:SetPoint("TOPLEFT", pfb, "TOPLEFT", self.db.profile.freebutton.mmbofsx, self.db.profile.freebutton.mmbofsy)
	else
		if pfb.MinimapBorder then
			pfb.MinimapBorder:Hide()
		end
		local f = pfb:GetHighlightTexture()
		f:ClearAllPoints()
		local size = self.db.profile.freebutton.texturesize
		f:SetSize(size, size)
		f:SetPoint("CENTER", pfb, "CENTER", 0, 0)
	end
	
	
	if self.db.profile.freebutton.roundtexture then
		SetPortraitToTexture(pfb:GetNormalTexture(), texture)
		if not self.db.profile.freebutton.minimapborder then
			SetPortraitToTexture(pfb:GetHighlightTexture(), texture)
		end
		SetPortraitToTexture(_G[pfb:GetName().."Icon"], texture)
	end
	
	
	pfb:SetAttribute("modkey", "shift")
	
	local function onenter()
		if self.db.profile.freebutton.tooltip then
			tooltipShow(Poisoner_FreeButton, "BOTTOMRIGHT", "text", "CLICK  |cffffffffto toggle the menu|r \nSHIFT and DRAG  |cffffffffto move the button around (even in combat)|r \nSHIFT and MOUSEWHEEL  |cffffffffto scale the button from 0.1 to 2.0 (even in combat)|r ")
		end
	end
	
	pfb.OnEnter = onenter
	pfb.OnLeave = tooltipHide
	
	pfb.ToggleOptions = self.ToggleConfig
	
	pfb.SavePos = function(handler, frame, optstring) --[[savepos(frame, optstring)]] end
	
	local function savescale()
		self.db.profile.freebutton.scale = tonumber(Poisoner_FreeButton:GetScale())
	end
	pfb.SaveScale = savescale
	
	pfb.FramePos = function(frame)
		local ofsb = frame:GetBottom();
		local ofst = frame:GetTop();
		local ofsl = frame:GetLeft();
		local ofsr = frame:GetRight();
		
		local centerx = (ofsl + ofsr) / 2
		local centery = (ofst + ofsb) / 2
		
		pfb.CenterX = centerx
		pfb.CenterY = centery
	end
	
	pfb:SetAttribute("UIParentScale", UIParent:GetScale())
	
	pfb:SetAttribute("showmouseover", self.db.profile.menu.behavior.autoshowmenuonmouseover)
	
	pfb:SetAttribute("_onclick", [=[
		local left, right, middle, menu = button == "LeftButton", button == "RightButton", button == "MiddleButton", self:GetFrameRef("menu");
		
		if right then
			control:CallMethod("ToggleOptions")
		elseif left then
			if menu:IsVisible() then
				menu:Hide();
			elseif menu:IsShown() then
				menu:Hide();
			else
				menu:Show();
			end
		elseif middle then
			print("QuickButton updated.")
		end
		
		
	]=]);
	
	pfb:SetAttribute("_onmousewheel", [=[
		local up, down, menu = delta == 1, delta == -1, self:GetFrameRef("menu");
		local anchor = self:GetFrameRef("anchor")
		local reqmod, modkey = self:GetAttribute("modkey"), ""
		local shift, ctrl, alt = IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown()
		
		if shift then modkey = modkey.."shift" end
		if ctrl then modkey = modkey.."ctrl" end
		if alt then modkey = modkey.."alt" end
		--print("ReqKey", reqmod,"- ModKey:", modkey)
		
		if modkey ~= reqmod then return end
		
		local p, rf, rp, x, y = self:GetPoint()
		if rf ~= anchor then
			anchor:ClearAllPoints()
			anchor:SetPoint(p, rf, rp, x, y)
			anchor:SetScale(self:GetScale())
			
			self:ClearAllPoints();
			self:SetPoint("CENTER", anchor, "CENTER", 0, 0)
		end
		
		local sScale = self:GetScale()
		local mScale = menu:GetScale()
		local ofsScale = 0.05
		
		if up then
			local newScale = sScale + ofsScale
			if newScale > 2 then newScale = 2 end
			self:SetScale(newScale)
		elseif down then
			local newScale = sScale + ofsScale
			if newScale < 0.2 then newScale = 0.2 end
			self:SetScale(sScale - ofsScale)
		end
		
		control:CallMethod("SaveScale", self)
		
		control:CallMethod("SavePos", "Poisoner_FreeButton_AlignFrame", "freebutton")
		
	]=])
		
	pfb:SetAttribute("_onenter", [=[
		
		local menu = self:GetFrameRef("menu")
		
		local som = self:GetAttribute("showmouseover")
		
		if som then
			menu:Show();
		end
		
		control:CallMethod("OnEnter", self)
	]=])
	pfb:SetAttribute("_onleave", [=[
		
		local menu = self:GetFrameRef("menu")
		local som = self:GetAttribute("showmouseover")
		
		if som then
			menu:Hide();
		end
		
		control:CallMethod("OnLeave")
	]=])
	
	RegisterStateDriver(pfb, "spec", "[spec:1] show; hide")
	pfb:SetAttribute("_onstate-spec", [[ -- arguments: self, stateid, newstate
		if newstate == "show" then
			self:Show()
		elseif newstate == "hide" then
			self:Hide()
		end
	]])
	
	if self.specHasPoisons then
		pfb:Show()
	else
		pfb:Hide()
	end
	
	return pfb
	
end

function Poisoner:CreateMenu()
	if self.InCombatLockdown or InCombatLockdown() then self.NeedUpdate.CreateMenu = true return end
	
	local pfb = _G["Poisoner_FreeButton"] or self:CreateMainButton()
	local pmenu = _G["Poisoner_Menu"]

	if pfb == nil or self.db.profile.freebutton.enabled == false then return end
	
	if pmenu == nil then
		pmenu = CreateFrame("Frame", "Poisoner_Menu", pfb, "SecureHandlerEnterLeaveTemplate, SecureHandlerMouseWheelTemplate")
	end
	
	if self.db.profile.menu.visible then
		pmenu:Show()
	else
		pmenu:Hide()
	end
	
	pmenu:SetSize(64*4,64)
	pmenu:SetScale(self.db.profile.menu.scale)
	pmenu:SetAlpha(self.db.profile.menu.alpha)
	pmenu:ClearAllPoints();
	pmenu:SetPoint("RIGHT",Poisoner_FreeButton,"LEFT");
	pmenu:SetFrameStrata(fstrata[self.db.profile.menu.framestrata])
	pmenu:SetFrameLevel(self.db.profile.menu.framelevel)
	--[[
	local texture = textureprefix.."ability_creature_poison_06"..texturesuffix
	pmenu.Texture = pmenu:CreateTexture(pmenu:GetName().."Icon", "ARTWORK");
	pmenu.Texture:SetTexture(texture);
	pmenu.Texture:SetAllPoints();
	]]
	
	pmenu:SetAttribute("modkey", "shift")
	
	local function savescale()
		self.db.profile.menu.scale = tonumber(Poisoner_Menu:GetScale())
	end
	pmenu.SaveScale = savescale
	
	pmenu:SetAttribute("showmouseover", self.db.profile.menu.behavior.autoshowmenuonmouseover)
	
	pmenu:SetAttribute("_onmousewheel", [=[
		local up, down = delta == 1, delta == -1
		local anchor = self:GetFrameRef("anchor")
		local reqmod, modkey = self:GetAttribute("modkey"), ""
		local shift, ctrl, alt = IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown()
		
		if shift then modkey = modkey.."shift" end
		if ctrl then modkey = modkey.."ctrl" end
		if alt then modkey = modkey.."alt" end
		--print("ReqKey", reqmod,"- ModKey:", modkey)
		
		if modkey ~= reqmod then return end
		
		local mScale = self:GetScale()
		local ofsScale = 0.05
		
		if up then
			local newScale = mScale + ofsScale
			if newScale > 2 then newScale = 2 end
			self:SetScale(newScale)
		elseif down then
			local newScale = mScale - ofsScale
			if newScale < 0.2 then newScale = 0.2 end
			self:SetScale(newScale)
		end
		
		control:CallMethod("SaveScale", self)
		
	]=])
	
	pmenu:SetAttribute("_onenter", [=[
		
		local som = self:GetAttribute("showmouseover")
		
		if som then
			self:Show();
		end
		
	]=])
	pmenu:SetAttribute("_onleave", [=[
				
		local som = self:GetAttribute("showmouseover")
		
		if som then
			self:Hide();
		end
		
	]=])
	
	_G["Poisoner_FreeButton"]:SetFrameRef("menu", Poisoner_Menu);
	
	hooksecurefunc(pmenu, "Show", function() self.db.profile.menu.visible = true end)
	hooksecurefunc(pmenu, "Hide", function() self.db.profile.menu.visible = false end)
	
	return pmenu
end

function Poisoner:CreateButtons()
	if self.InCombatLockdown or InCombatLockdown() then self.NeedUpdate.CreateButtons = true return end
	
	local pmenu = _G["Poisoner_Menu"]
	if pmenu == nil then return end
	local pmenuwidthL, pmenuwidthNL = 0, 0
	local pmenuheightL, pmenuheightNL = 0, 0
	local prevbutton
	for cat,spelltable in pairs(poisons) do
		prevbutton = nil
		for spellID,v in pairs(spelltable) do
			local buttonName = "Poisoner_MenuButton__"..spellID;
			local button = _G[buttonName];
			if IsSpellKnown(spellID) then
				
				if button == nil then
					button = CreateFrame("Button", buttonName, pmenu, "SecureActionButtonTemplate, SecureHandlerEnterLeaveTemplate, SecureHandlerMouseWheelTemplate")
				end
					
				button:SetHeight(32)
				button:SetWidth(32)
				--button:ClearAllPoints();
				--button:SetPoint("CENTER",UIParent,"CENTER");
				
				button.Name = GetSpellInfo(spellID)
				button.spellID = spellID
				
				local name, rank, icon = GetSpellInfo(spellID)
									
				button:RegisterForClicks("Any"..self.db.profile.menu.behavior.regclick);
				
				button:SetAttribute("name", name);
				button:SetAttribute("spellID", spellID);
				button:SetAttribute("cat", cat);
				button:SetAttribute("type", "macro");
				button:SetAttribute("macrotext", "/cast "..name)
				
				local texture = icon
				if self.db.profile.menu.texture == "Own" then
					texture = gsub(icon, "Interface\\Icons\\", "Interface\\AddOns\\Poisoner\\images\\")
				end
				
				button:SetNormalTexture(texture);
				button:SetHighlightTexture(texture);
				
				if not button.Texture then
					button.Texture = button:CreateTexture(buttonName.."Icon", "ARTWORK");
				end				
				button.Texture:SetTexture(texture);
				button.Texture:SetAllPoints(button);
				
				if self.db.profile.menu.roundtexture then
					SetPortraitToTexture(button:GetNormalTexture(), texture)
					SetPortraitToTexture(button:GetHighlightTexture(), texture)
					SetPortraitToTexture(_G[button:GetName().."Icon"], texture)
				end
				
				button:GetNormalTexture():SetTexCoord(0,1,0,1)
				button:GetHighlightTexture():SetTexCoord(0,1,0,1)
				_G[button:GetName().."Icon"]:SetTexCoord(0,1,0,1)
				
				--[[	--No need for a font string because we are no longer counting items
				local bfs = _G[buttonName.."Text"]
				if not bfs then
					bfs = button:CreateFontString(buttonName.."Text","OVERLAY","GameFontNormal");
				end
				bfs:SetPoint("BOTTOMRIGHT");
				bfs:SetTextColor(1,1,1,1);
				bfs:SetShadowColor(0,0,0,1);
				bfs:SetShadowOffset(-2,2);
				button:SetFontString(bfs);
				]]
				
				button:SetAttribute("modkey", "shift")
				
				
				SecureHandlerWrapScript(button, "PostClick", button, [=[
					local left, right, middle, cat, spellName, pfb = button == "LeftButton", button == "RightButton", button == "MiddleButton", self:GetAttribute("cat"), self:GetAttribute("name"), self:GetFrameRef("pfb");
					
				--	print(self:GetName(), cat, spellName)
					
					pfb:SetAttribute(cat, spellName)
					
					if true then return end
					
					if right then
						
					elseif left then
						
					elseif middle then
						
					end
					
					
				]=]);
				
				local tt = self.db.profile.menu.tooltip
				if tt == "name" then
				--	button:SetScript("OnEnter", function(self) tooltipShow(self, nil, "text", self.Name) end)
					button.OnEnter = function(self) tooltipShow(self, nil, "text", self.Name) end
				elseif tt == "full" then
				--	button:SetScript("OnEnter", function(self) tooltipShow(self, nil, "spellid", self.spellID) end)
					button.OnEnter = function(self) tooltipShow(self, nil, "spellid", self.spellID) end
				else
					button.OnEnter = function() end
				end
			--	button:SetScript("OnLeave", function() tooltipHide() end)
				button.OnLeave = tooltipHide
				
				button:SetFrameRef("pfb", Poisoner_FreeButton)
				button:SetFrameRef("menu", Poisoner_Menu);
				
				
				button:SetAttribute("_onenter", [=[
		
					local menu = self:GetFrameRef("menu")					
					local som = menu:GetAttribute("showmouseover")
					
					if som then
						menu:Show();
					end
					
					control:CallMethod("OnEnter", self)
				]=])
				button:SetAttribute("_onleave", [=[
					
					local menu = self:GetFrameRef("menu")
					local som = menu:GetAttribute("showmouseover")
					
					if som then
						menu:Hide();
					end
					
					control:CallMethod("OnLeave")
				]=])
				
				
				local function savescale()
					self.db.profile.menu.scale = tonumber(Poisoner_Menu:GetScale())
				end
				button.SaveScale = savescale
				
				button:SetAttribute("_onmousewheel", [=[
					local up, down, menu = delta == 1, delta == -1, self:GetFrameRef("menu");
					local anchor = self:GetFrameRef("anchor")
					local reqmod, modkey = self:GetAttribute("modkey"), ""
					local shift, ctrl, alt = IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown()
					
					if shift then modkey = modkey.."shift" end
					if ctrl then modkey = modkey.."ctrl" end
					if alt then modkey = modkey.."alt" end
					--print("ReqKey", reqmod,"- ModKey:", modkey)
					
					if modkey ~= reqmod then return end
					
					local mScale = menu:GetScale()
					local ofsScale = 0.1
					
					if up then
						local newScale = mScale + ofsScale
						if newScale > 2 then newScale = 2 end
						menu:SetScale(newScale)
					elseif down then
						local newScale = mScale - ofsScale
						if newScale < 0.2 then newScale = 0.2 end
						menu:SetScale(newScale)
					end
					
					control:CallMethod("SaveScale", self)
					
				]=])
				
				
				-- >>> Visuals
					local nummodels = 0	--self.db.profile.menu.animation.nummodels or 3	--disabled until Blizzard works out Model:SetPosition() after patch 7.0.3
					if nummodels > maxtempmodels then maxtempmodels = nummodels end
					if true then
						
						local UIScale = UIParent:GetEffectiveScale()
						local Hypotenuse = ( GetScreenWidth() ^ 2 + GetScreenHeight() ^ 2 ) ^ 0.5 * UIScale
						local roundtime, starttime = self.db.profile.menu.animation.animationtime*1000 or 2000, GetTime()*1000
						local endtime = starttime + roundtime
						local scale = self.db.profile.menu.animation.modelscale
						local shape = self.db.profile.menu.animation.shape
						local clockwise = self.db.profile.menu.animation.clockwise
						local radius = self.db.profile.menu.animation.radius
						
						local X = ( (button:GetRight() or 0) + (button:GetLeft() or 0) ) /2
						local Y = ( (button:GetTop() or 0) + (button:GetBottom() or 0) ) /2
						
						for i=1,nummodels do
							local Model = _G[buttonName.."Model"..i]
							if not Model then
								Model = CreateFrame("Model", buttonName.."Model"..i, button);
							end
							Model:SetAllPoints( nil ); -- Fullscreen
							Model:Show();
						--	Model:SetLight( true, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
							Model:SetModel("spells\\lightning_fel_precast_low_hand.mdx")
							Model:SetModelScale(0.02)
							Model:SetFacing(0)
							Model:SetFrameStrata(button:GetFrameStrata())
						end
						for i=nummodels+1,maxtempmodels do
							local Model = _G[buttonName.."Model"..i]
							if Model then
								Model:SetModelScale(0.0)
								Model:Hide()
							end
						end
						
						
						local lengthX, lengthY = radius*2, radius*2
						if radius == 0 then
							lengthX, lengthY = button:GetSize()
							radius = button:GetWidth()/2
						end
						
						
						button:SetScript("OnUpdate", function(self)
							local X,Y
							X = ( (button:GetRight() or 0) + (button:GetLeft() or 0) ) /2
							Y = ( (button:GetTop() or 0) + (button:GetBottom() or 0) ) /2
							local currenttime = GetTime()*1000
							for i=1,nummodels do
								local Model = _G[buttonName.."Model"..i]
								if endtime >= currenttime then
									local ofsa = (360 / nummodels) * i
									local per = (endtime - currenttime) / ((endtime - starttime) / 100)
									local angle = 360/100*per + ofsa
									local ofsx, ofsy
									if shape == "square" then
										ofsx, ofsy = GetSquarePoint(angle, lengthX, lengthY, clockwise)
									else
										ofsx, ofsy = GetCircularPoint(angle, radius, clockwise)
									end
									Model:SetPosition( ( X + ofsx) / Hypotenuse, ( Y + ofsy) / Hypotenuse, 0 )
								else
									starttime = currenttime
									endtime = currenttime + roundtime
								end
								if currentbuffs[spellreplace[button.spellID] or button.spellID] then
									Model:SetModelScale(scale or 0.02)
								else
									Model:SetModelScale(0.0)
								end
							end
						end)
						
					end
				-- <<< Visuals
				
				button:ClearAllPoints();
				if prevbutton then
					button:SetPoint("RIGHT", prevbutton, "LEFT");
				else
					if cat == "Lethal" then
						button:SetPoint("TOPRIGHT", pmenu, "TOPRIGHT");
					else
						button:SetPoint("BOTTOMRIGHT", pmenu, "BOTTOMRIGHT");
					end
				end
				button:Show()
				prevbutton = button
				
				if cat == "Lethal" then
					pmenuwidthL = pmenuwidthL + button:GetWidth()
				else
					pmenuwidthNL = pmenuwidthNL + button:GetWidth()
				end
				self.Buttons[spellID] = button
			else
				if button then
					button:Hide()
					button:SetScript("OnUpdate", nil)
				end
			end
		end
	end
	
	local pmenuheight = 64
	local pemnuwidth
	if pmenuwidthL >= pmenuwidthNL then
		pmenuwidth = pmenuwidthL
	else
		pmenuwidth = pmenuwidthNL
	end
	
	pmenu:SetWidth(pmenuwidth)
	pmenu:SetHeight(pmenuheight)
	
	self:InitialModelPositioning()
	
end

local init_position = false
function Poisoner:InitialModelPositioning()
	if init_position then return end
	
	local UIScale = UIParent:GetEffectiveScale()
	local Hypotenuse = ( GetScreenWidth() ^ 2 + GetScreenHeight() ^ 2 ) ^ 0.5 * UIScale
	
	for spellID,button in pairs(self.Buttons) do
		local ofsx, ofsy = GetCircularPoint(0, 0, true)
		local X = ( ( (button:GetRight() or 0) + (button:GetLeft() or 0) ) /2  + ofsx ) / Hypotenuse
		local Y = ( ( (button:GetTop() or 0) + (button:GetBottom() or 0) ) /2  + ofsy ) / Hypotenuse
		for i=1,maxtempmodels do
			local Model = _G["Poisoner_MenuButton__"..spellID.."Model"..i]
			if Model then
				Model:SetPosition( X, Y, 0 )
			end
		end
	end
	
	init_position = true
end


-- AuraButtons
function Poisoner:CreateAuraButtonFrame()
	local abf = _G["Poisoner_AuraButtonFrame"]
	if abf == nil then
		abf = CreateFrame("Frame", "Poisoner_AuraButtonFrame", UIParent, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate, SecureHandlerEnterLeaveTemplate");
		abf:SetSize(64*2,64)
		abf:ClearAllPoints();
		abf:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
		abf:Show()
		--[[
		local texture = textureprefix.."ability_creature_poison_06"..texturesuffix
		abf.Texture = abf:CreateTexture(abf:GetName().."Icon", "ARTWORK");
		abf.Texture:SetTexture(texture);
		abf.Texture:SetAllPoints();
		]]
	end
	return abf
end

function Poisoner:CreateAuraButtons()
	local abf = _G["Poisoner_AuraButtonFrame"] or self:CreateAuraButtonFrame()
	
	for cat,spells in pairs(poisons) do
		local buttonName = "Poisoner_AuraButton__"..cat;
		local button = _G[buttonName];
		if button == nil then
			button = CreateFrame("Button", buttonName, UIParent, "SecureActionButtonTemplate, SecureHandlerEnterLeaveTemplate, SecureHandlerAttributeTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate")
		end
		button:SetHeight(32)
		button:SetWidth(32)
		button:SetFrameStrata(abf:GetFrameStrata())
		button:SetFrameLevel(abf:GetFrameLevel()+1)
		button:ClearAllPoints();
		
		button:RegisterForClicks("AnyDown");
				
		button.Name = cat
		button:SetAttribute("cat", cat);
		
		local macrostring = ""
		if cat == "Lethal" then
			
			button:SetPoint("LEFT", abf, "LEFT", 0, 0);
			
			local i = 1
			for spellID,v in pairs(spells) do
			
				local texture = button:CreateTexture(button:GetName().."Icon"..i, "ARTWORK");
				
				local name, rank, icon = GetSpellInfo(spellID)
				
				texture:SetTexture(icon)
				
				texture:SetSize(button:GetWidth()/2, button:GetHeight())
				
				if i == 1 then
					texture:SetTexCoord(get8coords(0,0.5,0,1,0))
					texture:SetPoint("LEFT", button, "LEFT", 0, 0)
					macrostring = macrostring.."/cast [button:"..i.."]"..name
					button:SetAttribute("button:"..i, name)
				else
					texture:SetTexCoord(get8coords(0.5,1,0,1,0))
					texture:SetPoint("RIGHT", button, "RIGHT", 0, 0)
					macrostring = macrostring.."\n/cast [button:"..i.."] "..name
					button:SetAttribute("button:"..i, name)
				end
				
				i = i + 1
			end
			
			button.ChangeTextures = function(self)
				local tex1, tex2 = _G[self:GetName().."Icon1"], _G[self:GetName().."Icon2"]
				local oldtex1, oldtex2 = tex1:GetTexture(), tex2:GetTexture()
				
				tex1:SetTexture(oldtex2)
				tex1:SetTexCoord(get8coords(0,0.5,0,1,0))
				tex1:SetPoint("LEFT", button, "LEFT", 0, 0)
			
				tex2:SetTexture(oldtex1)
				tex2:SetTexCoord(get8coords(0.5,1,0,1,0))
				tex2:SetPoint("RIGHT", button, "RIGHT", 0, 0)
				
			end
			
			SecureHandlerWrapScript(button, "PostClick", button, [=[
				local left, right, middle, cat, spellName, pfb = button == "LeftButton", button == "RightButton", button == "MiddleButton", self:GetAttribute("cat"), self:GetAttribute("name"), self:GetFrameRef("pfb");
				
			--	print(self:GetName(), cat, spellName)
				
			--	pfb:SetAttribute(cat, spellName)
				
				if right then
					local old1, old2 = self:GetAttribute("button:1"), self:GetAttribute("button:2")
					self:SetAttribute("button:1", old2)
					self:SetAttribute("button:2", old1)
					self:SetAttribute("macrotext", "/cast [button:1] "..self:GetAttribute("button:1").."; [button:2]"..self:GetAttribute("button:2"))
					self:CallMethod("ChangeTextures")
				end
				
				
			]=]);
			
			button:SetScript("OnEnter", function(self)
			--	tooltipShow(self, nil, "spellid", self.spellID)
				for i = 1,2 do
					_G[button:GetName().."Icon"..i]:SetBlendMode("ADD")
				end
			end)
			button:SetScript("OnLeave", function()
				tooltipHide()
				for i = 1,2 do
					_G[button:GetName().."Icon"..i]:SetBlendMode("DISABLE")
				end
			end)
			
		else
			
			button:SetPoint("RIGHT", abf, "RIGHT", 0, 0);
			
			local mods = {[1] = "nomod", [2] = "shift", [3] = "ctrl", [4] = "alt"}
			
			for i,m in ipairs(mods) do
				local texture = button:CreateTexture(button:GetName().."Icon"..i, "ARTWORK")
				
				texture:ClearAllPoints()
				
				if v == 1 then
					texture:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
				elseif v == 2 then
					texture:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0)
				elseif v == 3 then
					texture:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 0)
				elseif v == 4 then
					texture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
				end
				
			end
			
			
			
		end
		
		
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", macrostring)
		
	end
	
end


--[[
	TIMER
]]
-- lookup the duration of the spells
function Poisoner:CheckBuffs(event)
	for k,v in pairs(currentbuffs) do
		currentbuffs[k] = nil
	end
	local currentTime = GetTime()
	for k,v in pairs(spells) do
		local spellName = GetSpellInfo(k)
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3
		if spellName then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff("player", spellName, nil, "PLAYER")
		end
		if name then
			currentbuffs[k] = expirationTime - currentTime
			activepoison[spellgroup[k]] = k
			self.db.profile.poisons.lastused[spellgroup[spellID]] = spellID
		end
	end
	return currentbuffs
end

function Poisoner:GetAllBuffDurations()
	if currentbuffs == {} then
		currentbuffs = self:CheckBuffs()
	end
	
	return currentbuffs
end

function Poisoner:GetBuffDuration(reqspellId, spellName)
	if not tonumber(reqspellId) then return nil end
	local currentTime = GetTime()
	local bufftime	
	local spellName = spellName or GetSpellInfo(reqspellId)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3
	if spellName then
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff("player", spellName, nil, "PLAYER")
	end
	if name and spellID == reqspellId then
		bufftime = expirationTime - currentTime
	end
		
	return bufftime
end


function Poisoner:GetLocalTables()
	local t = {}
	
	t.weaponid = weaponid
	t.canCast = canCast
	t.currentbuffs = currentbuffs
	t.activepoison = activepoison
	t.iscasting = iscasting
	t.activesound = activesound
	t.threshold = {value = threshold}
	
	t.hide =  {}
	for k,v in pairs(self.db.profile.warning.hide) do
		t.hide[k] = statusfunc[k]() or false
	end
	
	return t
end

function Poisoner:PrintLocalTables()
	local _, mtname, stname, t, t1, t2
	
	local t = self:GetLocalTables()
	
	for mtname,t1 in pairs(t) do
		local str = ""
		str = str..mtname.." = {"
		local isfirst = true
		for stname, t2 in pairs(t1) do
			if not isfirst then
				str = str..", "
			end
			str = str..stname.." = "..tostring(t2)
			isfirst = false
		end
		print(str.."}")
	end
	
end

--[[
	Warning system
]]

function Poisoner:CreateOnUpdateHandler(forcedisable, direct)
	
	local puh = _G["Poisoner_OnUpdateHandler"]
	
	if self.db.profile.warning.enabled and self.specHasPoisons and not forcedisable then
		
		if not puh then
			puh = CreateFrame("FRAME", "Poisoner_OnUpdateHandler")
		end
		
		threshold = self.db.profile.warning.threshold*60
		if not puh.OnUpdate then
			puh.OnUpdate = {
				delay = self.db.profile.warning.frequency,
				next = direct and 0 or self.db.profile.warning.frequency,
				warned = false,
				warnonlyonce = self.db.profile.warning.warnonlyonce,
				hide = self.db.profile.warning.hide,
			}
		else
			puh.OnUpdate.delay = self.db.profile.warning.frequency
			puh.OnUpdate.next = direct and 0 or self.db.profile.warning.frequency
			puh.OnUpdate.warned = false
			puh.OnUpdate.warnonlyonce = self.db.profile.warning.warnonlyonce
			puh.OnUpdate.hide = self.db.profile.warning.hide
		end
		puh:SetScript("OnUpdate", function(self,elapsed)
		-- check if we already warned and no longer need to
			if self.OnUpdate.warnonlyonce then
				if self.OnUpdate.warned then
					return
				else
					self.OnUpdate.warned = true
				end
			end
			self.OnUpdate.next = self.OnUpdate.next - elapsed
			for k,v in pairs(currentbuffs) do
				currentbuffs[k] = v - elapsed
			end
		-- only run this function after the defined time is expired
			if self.OnUpdate.next <= 0 then
				self.OnUpdate.next = self.OnUpdate.delay
			else
				return
			end
		-- return if you do not have any weapons active
			if weaponid["MainHandSlot"] == 0 and weaponid["SecondaryHandSlot"] == 0 then
				Poisoner:DisableWarning("No WeaponIds")
				return
			end
		-- test for all 'hide' options
			for k,v in pairs(self.OnUpdate.hide) do
				if v and statusfunc[k]() then
					Poisoner:DisableWarning("Warning hide "..(k or ""))
					return
				end
			end
			Poisoner:Warn()
		end)
	else
		if puh then
			puh:SetScript("OnUpdate", nil)
		end
		Poisoner:DisableWarning("Warning disabled")
	end
	
end

function Poisoner:Warn()
	
	for cat,spellID in pairs(activepoison) do
		
		if canCast[cat] then
		
			local d = currentbuffs[spellID]
			if d then
			--	local buffduration = d - GetTime()*1000
			--	if buffduration <= threshold then
				if d <= threshold then
					debug("buffduration is lower than threshold")
					self:PlaySound("expiring")
					self:PrintWarning("expiring", cat)
					self:AuraWarning("expiring", spellID, cat)
				else
					self:AuraWarning("hide", spellID, cat)
				end
			else
				self:PlaySound("nopoison")
				self:PrintWarning("nopoison", cat)
				self:AuraWarning("nopoison", self.db.profile.poisons.lastused[cat], cat)
			end
		
		end
		
	end
	
	if true then return end
	
	for k,v in pairs(currentbuffs) do
		local cat = spellgroup[k]
		activepoison[cat] = true
		local buffduration = v - GetTime()*1000
		if buffduration <= threshold then
			debug("buffduration is lower than threshold")
			self:PlaySound("expiring")
			self:PrintWarning("expiring", cat)
			self:AuraWarning("expiring", k, cat)
		else
			self:AuraWarning("hide", k, cat)
		end
	end
	
	for cat,t in pairs(poisons) do
		if not activepoison[cat] then
			debug("not activepoison", cat)
			self:PlaySound("nopoison")
			self:PrintWarning("nopoison", cat)
			self:AuraWarning("nopoison", self.db.profile.poisons.lastused[cat], cat)
		end
	end
	
end


local ExpirationDelay = {
	Print = {
		["Lethal"] = 0,
		["Non-Lethal"] = 0,
	},
	Sound = 0
}
local NoPoisonDelay = {
	Print = {
		["Lethal"] = 0,
		["Non-Lethal"] = 0,
	},
	Sound = 0
}

function Poisoner:DisableWarning(reason)

	local pfb = _G["Poisoner_FreeButton"]
	if pfb then
		if pfb.OnUpdate then
			pfb.OnUpdate.delay = self.db.profile.warning.delay * 1000
			pfb.OnUpdate.next = 0
			pfb.OnUpdate.warned = false
			pfb.OnUpdate.warnonlyonce = self.db.profile.warning.warnonlyonce
			pfb.OnUpdate.hide = self.db.profile.warning.hide
		else
			pfb.OnUpdate = {
				delay = self.db.profile.warning.delay * 1000,
				next = 0,
				warned = false,
				warnonlyonce = self.db.profile.warning.warnonlyonce,
				hide = self.db.profile.warning.hide,
			}
		end
	end
	
	ExpirationDelay.Print["Lethal"] = 0
	ExpirationDelay.Print["Non-Lethal"] = 0
	ExpirationDelay.Sound = 0
	
	NoPoisonDelay.Print["Lethal"] = 0
	NoPoisonDelay.Print["Non-Lethal"] = 0
	NoPoisonDelay.Sound = 0
	
	self:AuraWarning("hide", self.db.profile.poisons.lastused["Lethal"], "Lethal")
	self:AuraWarning("hide", self.db.profile.poisons.lastused["Non-Lethal"], "Non-Lethal")
	
end

function Poisoner:PrintWarning(cmd, typ, force)
	
	local delay = self.db.profile.warning.delay * 1000
	local ct = GetTime() * 1000
	
	local ctyp = typ
	if typ == "Lethal" then
		ctyp = color.ORANGE..typ..color.END
	else
		ctyp = color.YELLOW..typ..color.END
	end

	if (cmd == "expiring") then
		if ExpirationDelay.Print[typ] <= ct or force then
			ExpirationDelay.Print[typ] = ct + delay
			
			local message = "Your "..ctyp.." Poison is about to expire."
			
			if self.db.profile.warning.output.chat then
				self:Print(message)
			end	
			if self.db.profile.warning.output.errorframe then
				UIErrorsFrame:AddMessage(message, 1,1,1, id, 9);
			end
		end
	elseif (cmd == "nopoison") then
		if NoPoisonDelay.Print[typ] <= ct or force then
			NoPoisonDelay.Print[typ] = ct + delay
			
			local message = "You have "..color.RED.."no"..color.END.." "..ctyp.." Poison active!"
			
			if self.db.profile.warning.output.chat then
				self:Print(message)
			end	
			if self.db.profile.warning.output.errorframe then
				UIErrorsFrame:AddMessage(message, 1,1,1, id, 9);
			end
		end
	end
end


function Poisoner:CreateAuraFrame()

--	AuraFrame
	local af = _G["Poisoner_AuraFrame"]
	if not af then
		af = CreateFrame("Frame", "Poisoner_AuraFrame", UIParent)
	end
	af:SetFrameStrata("BACKGROUND")
	af:SetWidth(128) 
	af:SetHeight(64)
	af:SetAlpha(self.db.profile.warning.aura.alpha)
	
	local t = _G["Poisoner_AuraFrame_Background"]
	if not t then
		t = CreateFrame("Frame" ,"Poisoner_AuraFrame_Background", Poisoner_AuraFrame)
		t:SetWidth(128) 
		t:SetHeight(64)
		t.texture = t:CreateTexture(nil, "BACKGROUND")
	--	t.texture:SetTexture(1,1,1,0)
		t.texture:SetAllPoints(t)
		t:SetPoint("CENTER", Poisoner_AuraFrame, "CENTER", 0, 0)
	end
	t:SetScale(self.db.profile.warning.aura.scale)
	
	local pt = self.db.profile.warning.aura.point
	af:ClearAllPoints()
	af:SetPoint(pt.p, pt.rf, pt.rp, pt.x, pt.y)	--("CENTER","UIParent","CENTER",100,0)
	if self.db.profile.warning.output.aura then
		af:Show()
	else
		af:Hide()
	end
	
	
	local f = _G["Poisoner_AuraFrame_Lethal"]
	if not f then
		f = CreateFrame("Frame", "Poisoner_AuraFrame_Lethal", Poisoner_AuraFrame)
		f:Hide()
	end
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(64) 
	f:SetHeight(64)
	
	local t = _G["Poisoner_AuraFrame_LethalIcon"]
	if not t then
		t = f:CreateTexture("Poisoner_AuraFrame_LethalIcon","ARTWORK")
	--	t:SetTexture(1,1,1,1)
		t:SetAllPoints(f)
		f.texture = t
	end
	
	f:SetScale(self.db.profile.warning.aura.scale)
	f:ClearAllPoints()
	f:SetPoint("RIGHT",Poisoner_AuraFrame,"CENTER",0,0)
	
	
	local f = _G["Poisoner_AuraFrame_Non-Lethal"]
	if not f then
		f = CreateFrame("Frame", "Poisoner_AuraFrame_Non-Lethal", Poisoner_AuraFrame)
		f:Hide()
	end
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(64) 
	f:SetHeight(64)
	
	local t = _G["Poisoner_AuraFrame_Non-LethalIcon"]
	if not t then
		t = f:CreateTexture("Poisoner_AuraFrame_Non-LethalIcon","ARTWORK")
		--t:SetTexture(1,1,1,1)
		t:SetAllPoints(f)
		f.texture = t
	end
	
	f:SetScale(self.db.profile.warning.aura.scale)
	f:ClearAllPoints()
	f:SetPoint("LEFT",Poisoner_AuraFrame,"CENTER",0,0)
	
	
	return af
end

function Poisoner:AuraWarning(cmd, spellID, cat, force)
	
	local af = _G["Poisoner_AuraFrame"]
	if not self.db.profile.warning.output.aura then
		if af then
			af:Hide()
		end
		return
	else
		if af then
			af:Show()
		else
			af = self:CreateAuraFrame()
		end
	end
	
	local configAlpha = 1	--self.db.profile.warning.aura.alpha
	local f = _G["Poisoner_AuraFrame_"..cat]
	local t = _G["Poisoner_AuraFrame_"..cat.."Icon"]
	
	if (cmd == "expiring") then
		local RealAlpha = configAlpha * 0.5
		
		if f then
			t:SetTexture(self:GetSpellTexture(spellID) or "Interface\\Icons\\Ability_Creature_Poison_06")
			f:SetAlpha(RealAlpha)
			f:Show()
		end
		
	elseif (cmd == "nopoison") then
		local RealAlpha = configAlpha * 1
		
		if f then
			t:SetTexture(self:GetSpellTexture(spellID) or "Interface\\Icons\\Ability_Creature_Poison_06")
			f:SetAlpha(RealAlpha)
			f:Show()
		end
		
	elseif (cmd == "hide") then
		
		if f then
			f:Hide()
		end
		
	end
end

--[[
	Sound effects
]]

local soundfolder = "Interface\\AddOns\\Poisoner\\sounds\\"
local ExpPoison, NoPoison, LowStock

if (GetLocale() == "deDE") then
	ExpPoison = "Poisoner_ExpPoison_deDE.ogg"
	NoPoison = "Poisoner_NoPoison_deDE.ogg"
	LowStock = "Poisoner_Stock_deDE.ogg"
elseif (GetLocale() == "frFR") then
	ExpPoison = "Poisoner_ExpPoison_frFR.ogg"
	--NoPoison = "Poisoner_NoPoison_frFR.ogg"
	LowStock = "Poisoner_Stock_frFR.ogg"
else
	ExpPoison = "Poisoner_ExpPoison_EnUS-EnGB.ogg"
	NoPoison = "Poisoner_NoPoison_EnUS-EnGB.ogg"
	LowStock = "Poisoner_Stock_EnUS-EnGB.ogg"
end

function Poisoner:PlaySound(cmd, force)
	if not self.db.profile.warning.output.sound then return end
	
	local delay = self.db.profile.warning.delay * 1000
	local ct = GetTime() * 1000
	
	if activesound[cmd] <= ct then
		if (cmd == "expiring") then
			if ExpirationDelay.Sound <= ct or force then
				ExpirationDelay.Sound = ct + delay
				PlaySoundFile(soundfolder..ExpPoison, "Master")
				activesound[cmd] = ct + 2000
			end
		elseif (cmd == "nopoison") then
			if NoPoisonDelay.Sound <= ct or force then
				NoPoisonDelay.Sound = ct + delay
				PlaySoundFile(soundfolder..NoPoison, "Master")
				activesound[cmd] = ct + 2000
			end
	--	elseif (cmd == "lowstock") then
	--		PlaySoundFile(soundfolder..LowStock, "Master");
		end
	end
	
end
