-- GLOBALS: LibStub
local addon = LibStub('AceAddon-3.0'):NewAddon('BagMeters', 'AceConsole-3.0', 'AceEvent-3.0')
local L     = LibStub('AceLocale-3.0'):GetLocale('BagMeters')

-- Index des sacs dans addon.meters
local BACKPACK_BAG   = 1

local NUM_CHAR_BAGS  = _G.NUM_BAG_SLOTS			-- Dans FrameXML/Constants.lua
local FIRST_CHAR_BAG = 2
local LAST_CHAR_BAG  = FIRST_CHAR_BAG + NUM_CHAR_BAGS - 1

local NUM_BANK_BAGS  = _G.NUM_BANKBAGSLOTS		-- Dans FrameXML/Constants.lua
local FIRST_BANK_BAG = LAST_CHAR_BAG + 1
local LAST_BANK_BAG  = FIRST_BANK_BAG + NUM_BANK_BAGS - 1

local table, ipairs = table, ipairs
local SetCVar = SetCVar

------------------------------------------------------------------------------
-- Options et défauts
------------------------------------------------------------------------------
local defaults = {
	global = {
		enabled = true,
		version = 1
	},
	profile = {
		charBags  = true,
		bankBags  = true,
		hideBlizz = true,
	}
}

-- Options
local options_panel_gui = {
	name = 'BagMeters',
	handler = addon,
	type = 'group',
	args = {
		general = {
			type = 'group',
			name = L["OPTIONS_GENERALES"],
			order = 1,
			args =  {
				version = {
					order = 1,
					type  = 'description',
					name  = 'Version ' .. GetAddOnMetadata('BagMeters', 'Version')
				},

				author = {
					order = 2,
					type  = 'description',
					name  = L['OPTIONS_GENERALES_AUTEUR'] .. '\n'
				},

				toggle = {
					order = 3,
					name  = L['OPTIONS_GENERALES_ACTIVE'],
					desc  = L['OPTIONS_GENERALES_ACTIVE_DESC'],
					type  = 'toggle',
					get   = 'IsEnabled',
					set   = function(info, value)
								if value then addon:Enable() else addon:Disable() end
							end
				},

				sep = {
					order = 4,
					type = 'header',
					name = ''
				},

				charbags = {
					type = 'group',
					name = L['OPTIONS_GENERALES_PERSONNAGE'],
					inline = true,
					disabled = 'IsDisabled',
					order = 5,
					args = {
						enable = {
							type  = 'toggle',
							name  = L['OPTIONS_GENERALES_PERSONNAGE_ACTIVE'],
							desc  = L['OPTIONS_GENERALES_PERSONNAGE_ACTIVE_DESC'],
							order = 1,
							get   = function() return addon.db.profile.charBags end,
							set   = 'ToggleCharBags'
						},

						blizzard = {
							type  = 'toggle',
							name  = L["OPTIONS_GENERALES_PERSONNAGE_CACHER_BLIZZARD"],
							desc  = L["OPTIONS_GENERALES_PERSONNAGE_CACHER_BLIZZARD_DESC"],
							order = 2,
							get   = function() return addon.db.profile.hideBlizz end,
							set   = 'ToggleBlizzard'
						}
					}
				},

				bankbags = {
					type = 'group',
					name = L["OPTIONS_GENERALES_BANQUE"],
					inline = true,
					disabled = 'IsDisabled',
					order = 6,
					args = {
						enable = {
							type = 'toggle',
							name  = L['OPTIONS_GENERALES_BANQUE_ACTIVE'],
							desc  = L['OPTIONS_GENERALES_BANQUE_ACTIVE_DESC'],
							get  = function() return addon.db.profile.bankBags end,
							set  = 'ToggleBankBags'
						}
					}
				}
			}
		}

		-- profile est ajouté plus tard
	}
}

------------------------------------------------------------------------------
-- Initialisation
------------------------------------------------------------------------------
function addon:OnInitialize()

	-- Charge ou crée les données sauvegardées
	self.db = LibStub('AceDB-3.0'):New('BagMetersDB', defaults, true)

	-- Initialise le panneau des options
	options_panel_gui.args.profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	options_panel_gui.args.profile.order = 100
	LibStub('AceConfig-3.0'):RegisterOptionsTable('BagMeters', options_panel_gui)
	LibStub('AceConfigDialog-3.0'):AddToBlizOptions('BagMeters', 'BagMeters', nil, 'general')
	LibStub('AceConfigDialog-3.0'):AddToBlizOptions('BagMeters', 'Profile', 'BagMeters', 'profile')
	self.db.RegisterCallback(self, 'OnProfileChanged', 'UpdateProfile')
	self.db.RegisterCallback(self, 'OnProfileCopied',  'UpdateProfile')
	self.db.RegisterCallback(self, 'OnProfileReset',   'UpdateProfile')

	self:RegisterChatCommand('bagmeters', 'ChatCommand')
	self:RegisterChatCommand('bm',        'ChatCommand')

	-- Crées les compteurs
	local BM_MeterFactory = self:GetModule('MeterFactory')

	self.meters = {}

	table.insert(self.meters, BM_MeterFactory:NewMeter(BM_MeterFactory.BACKPACK))			-- meters[1] = Sac à dos

	for i = 1, NUM_CHAR_BAGS do
		table.insert(self.meters, BM_MeterFactory:NewMeter(BM_MeterFactory.CHAR_BAG, i))	-- meters[2 ... 5] > Sacs
	end

	for i = 1, NUM_BANK_BAGS do
		table.insert(self.meters, BM_MeterFactory:NewMeter(BM_MeterFactory.BANK_BAG, i))	-- meters[6 ... 12] > Banque
	end

	-- Active/désactive les compteurs selon le profil courant
	self:UpdateProfile()
end

-- Raccourci
function addon:IsDisabled()
	return not self:IsEnabled()
end

------------------------------------------------------------------------------
-- Activation/désactivation globales
------------------------------------------------------------------------------
function addon:OnEnable()

	-- Addon actif
	self.db.global.enabled = true

	-- Affiche ou cache le compteur par défaut
	self:ToggleBlizzard(nil, self.db.profile.hideBlizz)

	-- Affiche ou cache nos compteurs
	self:ToggleCharBags(nil, self.db.profile.charBags)
	self:ToggleBankBags(nil, self.db.profile.bankBags)

	-- Evénements
	self:RegisterEvent('BANKFRAME_OPENED',   'UpdateAllMeters')
	self:RegisterEvent('BAG_UPDATE_DELAYED', 'UpdateAllMeters')
end

------------------------------------------------------------------------------
function addon:OnDisable()

	-- Addon inactif
	self.db.global.enabled = false

	-- Affiche le compteur par défaut
	self:ToggleBlizzard(nil, false)

	-- Désactive tous nos compteurs
	self:ToggleCharBags(nil, false)
	self:ToggleBankBags(nil, false)
end

------------------------------------------------------------------------------
-- Active/désactive les compteurs
------------------------------------------------------------------------------
function addon:ToggleBlizzard(info, hide)

	-- Sauve le réglage si appelé depuis les options
	if info then self.db.profile.hideBlizz = hide end

	-- Affiche/masque le compteur
	SetCVar("displayFreeBagSlots", (self.db.global.enabled and hide) and '0' or '1', "DISPLAY_FREE_BAG_SLOTS")
end

------------------------------------------------------------------------------
function addon:ToggleCharBags(info, enable)

	-- Sauve le réglage si appelé depuis les options
	if info then self.db.profile.charBags = enable end

	-- Affiche/masque les compteurs
	local x = (self.db.global.enabled and enable) and 'enable' or 'disable'
	for i = BACKPACK_BAG, LAST_CHAR_BAG do
		self.meters[i][x](self.meters[i])	-- aka self.meters[i]:enable() / :disable()
	end
end

------------------------------------------------------------------------------
function addon:ToggleBankBags(info, enable)

	-- Sauve le réglage si appelé depuis les options
	if info then self.db.profile.bankBags = enable end

	-- Affiche/masqye les compteurs
	local x = (self.db.global.enabled and enable) and 'enable' or 'disable'
	for i = FIRST_BANK_BAG, LAST_BANK_BAG do
		self.meters[i][x](self.meters[i])	-- aka self.meters[i]:enable() / :disable()
	end
end

------------------------------------------------------------------------------
-- Met à jour tous les compteurs affichés
------------------------------------------------------------------------------
function addon:UpdateAllMeters(evt)
	for _,meter in ipairs(self.meters) do
		meter:update()
	end
end

------------------------------------------------------------------------------
-- Chat command
------------------------------------------------------------------------------
function addon:ChatCommand(input)
	LibStub("AceConfigDialog-3.0"):Open("BagMeters")
end

------------------------------------------------------------------------------
-- Gestion des profils
------------------------------------------------------------------------------
function addon:UpdateProfile()
	self:SetEnabledState(self.db.global.enabled)
	if self.db.global.enabled then
		self:OnEnable()
	else
		self:OnDisable()
	end
end
