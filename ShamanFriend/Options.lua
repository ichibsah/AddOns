--[[
$Id: Options.lua 84 2016-07-20 02:05:50Z stassart $

Author: Trelis @ Proudmoore
(shamanfriend (a) stassart o org)

Copyright 2009-2011 Benjamin Stassart

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

-- Prevent LUA error with blank WTF
-- Disable ShamanFriend if the player is not a shaman
if select(2, UnitClass('player')) ~= "SHAMAN" then
        DisableAddOn("ShamanFriend")
        return
end

local L = LibStub("AceLocale-3.0"):GetLocale("ShamanFriend")

local lN = ShamanFriend.lN

local LSM = LibStub("LibSharedMedia-3.0")

ShamanFriend.options = {
	name = "Shaman Friend",
	handler = ShamanFriend,
	type ='group',
	childGroups ='tree',
	desc = L["Options for ShamanFriend"],
	args = {
		ui = {
			name = L["Show UI"],
			type = "execute",
			desc = L["Shows the Graphical User Interface"],
			func = "OpenConfig",
			guiHidden = true,
			order = 999,
		},
		version = {
			name = L["Show version"],
			type = "execute",
			desc = L["Show version"],
			func = "ShowVersion",
			guiHidden = true,
			order = 998,
		},
		alert = {
			name = L["Alerts"],
			type = 'group',
			desc = L["Alertss."],
			order = 200, 
			args = {
				shield = {
				 	name = L["Elemental Shield"],
				 	type = "toggle",
				 	desc = L["Toggle check for Elemental Shield."],
				 	get = function(info) return ShamanFriend.db.profile.alert.shield end,
				 	set = function(info,v)
				 		ShamanFriend.db.profile.alert.shield = v
				 		ShamanFriend:LoadEvents()
				 	end,
				 	order = 201,
				},
				buff_sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a buff is missing."],
					get = function(info) return ShamanFriend.db.profile.alert.sound end,
					set = function(info,v) ShamanFriend.db.profile.alert.sound = v	end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					order = 202,
				},
				h203 = {type = "header", name = " ", order = 203},
				readycheck = {
				 	name = L["Ready Check"],
				 	type = "toggle",
				 	desc = L["Notify on ready check."],
				 	get = function(info) return ShamanFriend.db.profile.alert.readycheck end,
				 	set = function(info,v)
				 		ShamanFriend.db.profile.alert.readycheck = v
				 		ShamanFriend:LoadEvents()
				 	end,
				 	order = 204, 
				},
				entercombat = {
					name = L["Enter Combat"],
				 	type = "toggle",
				 	desc = L["Notify when entering combat."],
				 	get = function(info) return ShamanFriend.db.profile.alert.entercombat end,
				 	set = function(info,v)
				 		ShamanFriend.db.profile.alert.entercombat = v
				 		ShamanFriend:LoadEvents()
				 	end,
				 	order = 205,
				},
				aftercombat = {
				 	name = L["After Combat"],
				 	type = "toggle",
				 	desc = L["Notify after the end of combat."],
				 	get = function(info) return ShamanFriend.db.profile.alert.aftercombat end,
				 	set = function(info,v)
				 		ShamanFriend.db.profile.alert.aftercombat = v
				 		ShamanFriend:LoadEvents()
				 	end,
				 	order = 206,
				},
				mounted = {
				 	name = L["No Mounted"],
				 	type = "toggle",
				 	desc = L["Disable notifications when mounted."],
				 	get = function(info) return ShamanFriend.db.profile.alert.mounted end,
				 	set = function(info,v) ShamanFriend.db.profile.alert.mounted = v end,
				 	order = 207,
				},
				vehicle = {
				 	name = L["No Vehicle"],
				 	type = "toggle",
				 	desc = L["Disable notifications when in a vehicle."],
				 	get = function(info) return ShamanFriend.db.profile.alert.vehicle end,
				 	set = function(info,v) ShamanFriend.db.profile.alert.vehicle = v end,
				 	order = 208,
				},
				-- h209 = {type = "header", name = " ", order = 209},
				-- maelstrom = {
				-- 	name = lN["Maelstrom Weapon"],
				-- 	type = "toggle",
				-- 	desc = string.format(L["Toggle %s information."],lN["Maelstrom Weapon"]),
				-- 	get = function(info) return ShamanFriend.db.profile.alert.maelstrom end,
				-- 	set = function(info,v)
				-- 		ShamanFriend.db.profile.alert.maelstrom = v
				-- 		ShamanFriend:LoadEvents()
				-- 	end,
				-- 	order = 210,
				-- },
				-- maelstacks = {
				-- 	name = L["Number of stacks"],
				-- 	type = "range",
				-- 	desc = L["Alert when buff reaches number of stacks."],
				-- 	get = function(info) return ShamanFriend.db.profile.alert.maelstacks end,
				-- 	set = function(info,v)
				-- 		ShamanFriend.db.profile.alert.maelstacks = v
				-- 	end,
				-- 	step = 1,
				-- 	min = 1,
				-- 	max = 5,
				-- 	order = 211,
				-- },
				-- h212 = {type = "header", name = " ", order = 212},
				-- fulmination = {
				-- 	name = lN["Fulmination"],
				-- 	type = "toggle",
				-- 	desc = L["Alert when lightning shield hits X stacks."],
				-- 	get = function(info) return ShamanFriend.db.profile.alert.fulmination end,
				-- 	set = function(info,v)
				-- 		ShamanFriend.db.profile.alert.fulmination = v
				-- 		ShamanFriend:LoadEvents()
				-- 	end,
				-- 	order = 213,
				-- },
				-- fulmstacks = {
				-- 	name = L["Number of stacks"],
				-- 	type = "range",
				-- 	desc = L["Alert when buff reaches number of stacks (0 = autodetect)."],
				-- 	get = function(info) return ShamanFriend.db.profile.alert.fulmstacks end,
				-- 	set = function(info,v)
				-- 		ShamanFriend.db.profile.alert.fulmstacks = v
				-- 		ShamanFriend:SetFulmStacks()
				-- 	end,
				-- 	step = 1,
				-- 	min = 0,
				-- 	max = 20,
				-- 	order = 214,
				-- },
				h215 = {type = "header", name = " ", order = 215},
				surge = {
				 	name = lN["Lava Surge"],
				 	type = "toggle",
				 	desc = string.format(L["Toggle %s information."],lN["Lava Surge"]),
				 	get = function(info) return ShamanFriend.db.profile.alert.surge end,
				 	set = function(info,v)
				 		ShamanFriend.db.profile.alert.surge = v
				 		ShamanFriend:LoadEvents()
				 	end,
				 	order = 216,
				},
				proc_sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a proc occurs."],
					get = function(info) return ShamanFriend.db.profile.alert.proc_sound end,
					set = function(info,v) ShamanFriend.db.profile.alert.proc_sound = v	end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					order = 217,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.alert.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.alert.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.alert.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.alert.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.alert.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.alert.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.alert.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.alert.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		spell = {
			name = L["Spells"],
			type = 'group',
			desc = L["Settings regarding different spells."],
			order = 300,
			args = {
				purge = {
					name = lN["Purge"],
					type = "toggle",
					desc = string.format(L["Toggle %s information."],lN["Purge"]),
					get = function(info) return ShamanFriend.db.profile.spell.purge end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.purge = v
						ShamanFriend:LoadEvents()
					end,
					order = 301,
				},
				purgemsg = {
					name = string.format(L["Announce %s"],lN["Purge"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],lN["Purge"]),
					get = function(info) return ShamanFriend.db.profile.spell.purgemsg end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.purgemsg = v
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.purge end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["RAID_WARNING"] = L["Raid Warning"],
						["SAY"] = L["Say"],
						["none"] = L["None"],
					},
					order = 302,
				},
				h303 = {type = "header", name = " ", order = 303},
				interrupt = {
					name = L["Interrupt"],
					type = "toggle",
					desc = string.format(L["Toggle %s information."],L["Interrupt"]),
					get = function(info) return ShamanFriend.db.profile.spell.interrupt end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.interrupt = v
						ShamanFriend:LoadEvents()
					end,
					order = 304,
				},
				interruptmsg = {
					name = string.format(L["Announce %s"],L["Interrupt"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],L["Interrupt"]),
					get = function(info) return ShamanFriend.db.profile.spell.interruptmsg end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.interruptmsg = v
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.interrupt end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["RAID_WARNING"] = L["Raid Warning"],
						["SAY"] = L["Say"],
						["none"] = L["None"],
					},
					order = 305,
				},
				h306 = {type = "header", name = " ", order = 306},
				dispel = {
					name = L["Dispel"],
					type = "toggle",
					desc = L["Toggle message when dispel is cast."],
					get = function(info) return ShamanFriend.db.profile.spell.dispel end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.dispel = v
						ShamanFriend:LoadEvents()
					end,
					order = 307,
				},
				dispelmsg = {
					name = string.format(L["Announce %s"],L["Dispel"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],L["Dispel"]),
					get = function(info) return ShamanFriend.db.profile.spell.dispelmsg end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.dispelmsg = v
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.dispel end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 308,
				},
				h309 = {type = "header", name = " ", order = 309},
				target = {
					name = L["Add target"],
					type = "toggle",
					desc = L["Add the target to the end of the message when broadcasting."],
					get = function(info) return ShamanFriend.db.profile.spell.target end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.target = v
					end,
					order = 310,
				},
				h311 = {type = "header", name = " ", order = 311},
				ground = {
					name = lN["Grounding Totem"],
					type = "toggle",
					desc = L["Toggle message when Grounding Totem absorbs a spell."],
					get = function(info) return ShamanFriend.db.profile.spell.ground end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.ground = v
						ShamanFriend:LoadEvents()
					end,
					order = 312,
				},
				groundself = {
					name = L["Ground self only"],
					type = "toggle",
					desc = L["Only show grounding message for your own Grounding Totem"],
					get = function(info) return ShamanFriend.db.profile.spell.groundself end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.groundself = v
						ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.ground end,
					order = 313,
				},
				groundmsg = {
					name = string.format(L["Announce %s"],lN["Grounding Totem"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],lN["Grounding Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.groundmsg end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.groundmsg = v
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.ground end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["RAID_WARNING"] = L["Raid Warning"],
						["SAY"] = L["Say"],
						["none"] = L["None"],
					},
					order = 314,
				},
				h315 = {type = "header", name = " ", order = 315},
				bloodlust = {
					name = string.format(L["%s message"],lN["Bloodlust"]),
					type = "toggle",
					width = "double",
					desc = string.format(L["Send a message when %s is cast."],lN["Bloodlust"]),
					get = function(info) return ShamanFriend.db.profile.spell.bloodlust end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.bloodlust = v
						ShamanFriend:LoadEvents()
					end,
					order = 316,
				},
				bloodlusttext = {
					name = string.format(L["%s text"],lN["Bloodlust"]),
					type = "input",
					width = "double",
					desc = string.format(L["The text in the message when %s is cast."],lN["Bloodlust"]),
					get = function(info) return ShamanFriend.db.profile.spell.bloodlusttext end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.bloodlusttext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = "%t = your target",
					disabled = function() return not ShamanFriend.db.profile.spell.bloodlust end,
					order = 317,
				},
				bloodlustchat = {
					name = string.format(L["%s chat"],lN["Bloodlust"]),
					type = "select",
					desc = string.format(L["Chat for the %s message."],lN["Bloodlust"]),
					get = function(info) return ShamanFriend.db.profile.spell.bloodlustchat end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.bloodlustchat = v
						-- ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.bloodlust end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
					},
					order = 318,
				},
				h323 = {type = "header", name = " ", order = 323},
				spiritlink = {
					name = string.format(L["%s message"],lN["Spirit Link Totem"]),
					type = "toggle",
					width = "double",
					desc = string.format(L["Send a message when %s is cast."],lN["Spirit Link Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.spiritlink end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.spiritlink = v
						ShamanFriend:LoadEvents()
					end,
					order = 324,
				},
				spiritlinktext = {
					name = string.format(L["%s text"],lN["Spirit Link Totem"]),
					type = "input",
					width = "double",
					desc = string.format(L["The text in the message when %s is cast."],lN["Spirit Link Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.spiritlinktext end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.spiritlinktext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = "%t = your target",
					disabled = function() return not ShamanFriend.db.profile.spell.spiritlink end,
					order = 325,
				},
				spiritlinkchat = {
					name = string.format(L["%s chat"],lN["Spirit Link Totem"]),
					type = "select",
					desc = string.format(L["Chat for the %s message."],lN["Spirit Link Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.spiritlinkchat end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.spiritlinkchat = v
						-- ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.spiritlink end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
					},
					order = 326,
				},
				h327 = {type = "header", name = " ", order = 327},
				healtide = {
					name = string.format(L["%s message"],lN["Healing Tide Totem"]),
					type = "toggle",
					width = "double",
					desc = string.format(L["Send a message when %s is cast."],lN["Healing Tide Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.healtide end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.healtide = v
						ShamanFriend:LoadEvents()
					end,
					order = 328,
				},
				healtidetext = {
					name = string.format(L["%s text"],lN["Healing Tide Totem"]),
					type = "input",
					width = "double",
					desc = string.format(L["The text in the message when %s is cast."],lN["Healing Tide Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.healtidetext end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.healtidetext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = "%t = your target",
					disabled = function() return not ShamanFriend.db.profile.spell.healtide end,
					order = 329,
				},
				healtidechat = {
					name = string.format(L["%s chat"],lN["Healing Tide Totem"]),
					type = "select",
					desc = string.format(L["Chat for the %s message."],lN["Healing Tide Totem"]),
					get = function(info) return ShamanFriend.db.profile.spell.healtidechat end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.healtidechat = v
						-- ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.healtide end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
					},
					order = 330,
				},
				h340 = {type = "header", name = " ", order = 340},
				feralspirit = {
					name = string.format(L["%s message"],lN["Feral Spirit"]),
					type = "toggle",
					width = "double",
					desc = string.format(L["Send a message when %s is cast."],lN["Feral Spirit"]),
					get = function(info) return ShamanFriend.db.profile.spell.feralspirit end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.feralspirit = v
						ShamanFriend:LoadEvents()
					end,
					order = 341,
				},
				feralspirittext = {
					name = string.format(L["%s text"],lN["Feral Spirit"]),
					type = "input",
					width = "double",
					desc = string.format(L["The text in the message when %s is cast."],lN["Feral Spirit"]),
					get = function(info) return ShamanFriend.db.profile.spell.feralspirittext end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.feralspirittext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = "%t = your target",
					disabled = function() return not ShamanFriend.db.profile.spell.feralspirit end,
					order = 342,
				},
				feralspiritchat = {
					name = string.format(L["%s chat"],lN["Feral Spirit"]),
					type = "select",
					desc = string.format(L["Chat for the %s message."],lN["Feral Spirit"]),
					get = function(info) return ShamanFriend.db.profile.spell.feralspiritchat end,
					set = function(info,v)
						ShamanFriend.db.profile.spell.feralspiritchat = v
						-- ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.spell.feralspirit end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
					},
					order = 343,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.spell.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.spell.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.spell.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.spell.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.spell.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.spell.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.spell.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.spell.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		display = {
			name = L["General"],
			type = 'group',
			desc = L["General Display settings and options for the Custom Message Frame."],
			order = 100, 
			args = {
				chat = {
					name = L["In Chat"],
					type = "toggle",
					desc = L["Display message in Chat Frame."],
					get = function(info) return ShamanFriend.db.profile.display.chat end,
					set = function(info,v) ShamanFriend.db.profile.display.chat = v end,
					order = 110,
				},
				number= {
					name = L["Chat number"],
					type = "range",
					desc = L["Choose which chat to display the messages in (0=default)."],
					get = function(info) return ShamanFriend.db.profile.display.number end,
					set = function(info,v)
						ShamanFriend.db.profile.display.number = v
					end,
					step = 1,
					min = 0,
					max = 10,
					order = 111,
				},
				screen = {
					name = L["On Screen"],
					type = "toggle",
					desc = L["Display message in Blizzard UI Error Frame."],
					get = function(info) return ShamanFriend.db.profile.display.screen end,
					set = function(info,v) ShamanFriend.db.profile.display.screen = v end,
					order = 120,
				},
				frame = {
					name = L["Custom Frame"],
					type = "toggle",
					desc = L["Display message in Custom Message Frame."],
					get = function(info) return ShamanFriend.db.profile.display.frame end,
					set = function(info,v)
						ShamanFriend.db.profile.display.frame = v
						ShamanFriend:LoadEvents()
					end,
					order = 130,
				},
				lock = {
					name = L["Lock"],
					type = "toggle",
					desc = L["Toggle locking of the Custom Message Frame."],
					get = function(info) return ShamanFriend.db.profile.display.lock end,
					set = function(info,v)
						ShamanFriend.db.profile.display.lock = v
						ShamanFriend:UpdateLock()
					end,
					order = 131,
				},
				resetpos = {
					name = L["Reset Position"],
					type = "execute",
					desc = L["Reset Position"],
					func = "ResetDisplayPos",
					order = 132,
				},
				fontSize = {
					name = L["Font Size"],
					type = "range",
					desc = L["Set the font size in the Custom Message Frame."],
					get = function(info) return ShamanFriend.db.profile.display.fontSize end,
					set = function(info,v)
						ShamanFriend.db.profile.display.fontSize = v
						ShamanFriend:UpdateFont()
					end,
					step = 1,
					min = 8,
					max = 32,
					order = 133,
				},
				fontEffect = {
					name = L["Font Effect"],
					type = "select",
					desc = L["Set the font effect in the Custom Message Frame."],
					get = function(info) return ShamanFriend.db.profile.display.fontEffect end,
					set = function(info,v)
						ShamanFriend.db.profile.display.fontEffect = v
						ShamanFriend:UpdateFont()
					end,
					values = {
						["none"] = L["None"],
						[L["OUTLINE"]] = L["OUTLINE"],
						[L["THICKOUTLINE"]] = L["THICKOUTLINE"],
						[L["MONOCHROME"]] = L["MONOCHROME"],
					},
					order = 134,
				},
				fontFace = {
					name = L["Font Face"],
					type = "select",
					width = "double",
					desc = L["Set the font face in the Custom Message Frame."],
					dialogControl = "LSM30_Font",
					get = function(info) return ShamanFriend.db.profile.display.fontFace end,
					set = function(info,v)
						ShamanFriend.db.profile.display.fontFace = v
						ShamanFriend:UpdateFont()
					end,
					values = LSM:HashTable("font"),
					order = 135,
				},
				BGAnnounce = {
					name = L["BG Announce"],
					type = "select",
					desc = L["Announce when in battlegrounds."],
					get = function(info) return ShamanFriend.db.profile.display.bgannounce end,
					set = function(info,v)
						ShamanFriend.db.profile.display.bgannounce = v
						ShamanFriend:LoadEvents()
					end,
					values = {
						["BATTLEGROUND"] = L["Battleground"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["none"] = L["None"],
					},
					order = 136,
				},
				ArenaAnnounce = {
					name = L["Arena Announce"],
					type = "toggle",
					desc = L["Announce when in arena."],
					get = function(info) return ShamanFriend.db.profile.display.arenaannounce end,
					set = function(info,v)
						ShamanFriend.db.profile.display.arenaannounce = v
						ShamanFriend:LoadEvents()
					end,
					order = 137,
				},
				PartyAnnounce = {
					name = L["5-man Announce"],
					type = "toggle",
					desc = L["Announce when in a 5-man instance."],
					get = function(info) return ShamanFriend.db.profile.display.partyannounce end,
					set = function(info,v)
						ShamanFriend.db.profile.display.partyannounce = v
						ShamanFriend:LoadEvents()
					end,
					order = 138,
				},
				RaidAnnounce = {
					name = L["Raid Announce"],
					type = "toggle",
					desc = L["Announce when in a raid instance."],
					get = function(info) return ShamanFriend.db.profile.display.raidannounce end,
					set = function(info,v)
						ShamanFriend.db.profile.display.raidannounce = v
						ShamanFriend:LoadEvents()
					end,
					order = 139,
				},
				WorldAnnounce = {
					name = L["World Announce"],
					type = "toggle",
					desc = L["Announce when not in instances."],
					get = function(info) return ShamanFriend.db.profile.display.worldannounce end,
					set = function(info,v)
						ShamanFriend.db.profile.display.worldannounce = v
						ShamanFriend:LoadEvents()
					end,
					order = 140,
				},
				SoundChannel = {
					name = L["Sound Channel"],
					type = "select",
					desc = L["Channel to play sounds"],
					get = function(info) return ShamanFriend.db.profile.soundchannel end,
					set = function(info,v)
						ShamanFriend.db.profile.soundchannel = v
						ShamanFriend:LoadEvents()
					end,
					values = {
						["SFX"] = L["Effects"],
						["Music"] = L["Music"],
						["Ambience"] = L["Ambience"],
						["Master"] = L["Master"],
					},
					order = 141,
				},
			}
		},
		wf = {
			name = lN["Windfury"],
			type = 'group',
			desc = L["Settings for Windfury counter."],
			order = 500,
			args = {
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Enable WF hit counter."],
					get = function(info) return ShamanFriend.db.profile.wf.enable end,
					set = function(info,v)
						ShamanFriend.db.profile.wf.enable = v
						ShamanFriend:LoadEvents()
					end,
					order = 501,
				},
				crit = {
					name = L["Crit"],
					type = "toggle",
					desc = L["Enable display of WF crits."],
					get = function(info) return ShamanFriend.db.profile.wf.crit end,
					set = function(info,v) ShamanFriend.db.profile.wf.crit = v end,
					disabled = function() return not ShamanFriend.db.profile.wf.enable end,
					order = 502,
				},
				miss = {
					name = L["Miss"],
					type = "toggle",
					desc = L["Enable display of WF misses."],
					get = function(info) return ShamanFriend.db.profile.wf.miss end,
					set = function(info,v) ShamanFriend.db.profile.wf.miss = v end,
					disabled = function() return not ShamanFriend.db.profile.wf.enable end,
					order = 503,
				},
				hand = {
					name = L["Hand"],
					type = "toggle",
					desc = L["Show which hand the proc comes from"],
					get = function(info) return ShamanFriend.db.profile.wf.hand end,
					set = function(info,v) ShamanFriend.db.profile.wf.hand = v end,
					disabled = function() return not ShamanFriend.db.profile.wf.enable end,
					order = 503,
				},
				lavalash = {
					name = lN["Lava Lash"],
					type = "toggle",
					desc = L["Show Lava Lash damage"],
					get = function(info) return ShamanFriend.db.profile.wf.lavalash end,
					set = function(info,v) ShamanFriend.db.profile.wf.lavalash = v end,
					order = 504,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.wf.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.wf.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.wf.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.wf.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.wf.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.wf.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.wf.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.wf.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		lo = {
			name = L["Elemental Overload"],
			type = 'group',
			desc = L["Settings for Elemental Overload."],
			order = 400,
			args = {
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Toggle whether to show a message when Elemental Overload procs."],
					get = function(info) return ShamanFriend.db.profile.lo.enable end,
					set = function(info,v)
						ShamanFriend.db.profile.lo.enable = v
						ShamanFriend:LoadEvents()
					end,
					order = 401,
				},
				crit = {
					name = L["Crit"],
					type = "toggle",
					desc = L["Enable display of Elemental Overload crits."],
					get = function(info) return ShamanFriend.db.profile.lo.crit end,
					set = function(info,v) ShamanFriend.db.profile.lo.crit = v end,
					disabled = function() return not ShamanFriend.db.profile.lo.enable end,
					order = 403,
				},
				damage = {
					name = L["Damage"],
					type = "toggle",
					desc = L["Enable display of Elemental Overload total damage."],
					get = function(info) return ShamanFriend.db.profile.lo.damage end,
					set = function(info,v) ShamanFriend.db.profile.lo.damage = v end,
					disabled = function() return not ShamanFriend.db.profile.lo.enable end,
					order = 404,
				},
				miss = {
					name = L["Miss"],
					type = "toggle",
					desc = L["Enable display of Elemental Overload misses."],
					get = function(info) return ShamanFriend.db.profile.lo.miss end,
					set = function(info,v) ShamanFriend.db.profile.lo.miss = v end,
					disabled = function() return not ShamanFriend.db.profile.lo.enable end,
					order = 405,
				},
				-- fulmination = {
				-- 	name = lN["Fulmination"],
				-- 	type = "toggle",
				-- 	desc = lN["Fulmination"],
				-- 	get = function(info) return ShamanFriend.db.profile.lo.fulmination end,
				-- 	set = function(info,v)
				-- 		ShamanFriend.db.profile.lo.fulmination = v
				-- 		ShamanFriend:LoadEvents()
				-- 	end,
				-- 	order = 406,
				-- },
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.lo.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.lo.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.lo.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.lo.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.lo.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.lo.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.lo.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.lo.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		eshield = {
			name = lN["Earth Shield"],
			type = 'group',
			desc = L["Settings for Earth Shield."],
			order = 500,
			args = {
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Toggle Earth Shield tracker"],
					get = function(info) return ShamanFriend.db.profile.eshield.enable end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.enable = v
						ShamanFriend:LoadEvents()
					end,
					order = 501,
				},
				lock = {
					name = L["Lock tracker"],
					type = "toggle",
					desc = L["Lock Earth Shield tracker."],
					get = function(info) return ShamanFriend.db.profile.eshield.lock end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.lock = v
						ShamanFriend:SetButtonMode()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 502,
				},
				tooltip = {
					name = L["Disable tooltip"],
					type = "toggle",
					desc = L["Disable Earth Shield tracker tooltip."],
					get = function(info) return ShamanFriend.db.profile.eshield.notooltip end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.notooltip = v
						ShamanFriend:SetButtonMode()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 503,
				},
				button = {
					name = L["Button only"],
					type = "toggle",
					desc = L["Show only the Earth Shield button."],
					get = function(info) return ShamanFriend.db.profile.eshield.button end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.button = v
						ShamanFriend:SetButtonMode()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 504,
				},
				bgcolor = {
					name = L["Color"],
					type = "toggle",
					desc = L["Change the color of the background."],
					get = function(info) return ShamanFriend.db.profile.eshield.bgcolor end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.bgcolor = v
						ShamanFriend:eshield_BuffCheck()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 505,
				},
				flash = {
					name = L["Flash"],
					type = "toggle",
					desc = L["Flash frame when expired."],
					get = function(info) return ShamanFriend.db.profile.eshield.flash end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.flash = v
						ShamanFriend:eshield_BuffCheck()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 506,
				},
				resetpos = {
					name = L["Reset Position"],
					type = "execute",
					desc = L["Reset Position"],
					func = "ResetEShieldPos",
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 507,
				},
				h508 = {type = "header", name = " ", order = 508},
				readycheck = {
					name = L["Ready Check"],
					type = "toggle",
					desc = L["Notify on ready check."],
					get = function(info) return ShamanFriend.db.profile.eshield.readycheck end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.readycheck = v
						ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 509, 
				},
				entercombat = {
					name = L["Enter Combat"],
					type = "toggle",
					desc = L["Notify when entering combat."],
					get = function(info) return ShamanFriend.db.profile.eshield.entercombat end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.entercombat = v
						ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 510,
				},
				aftercombat = {
					name = L["After Combat"],
					type = "toggle",
					desc = L["Notify after the end of combat."],
					get = function(info) return ShamanFriend.db.profile.eshield.aftercombat end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.aftercombat = v
						ShamanFriend:LoadEvents()
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 511,
				},
				alert = {
					name = L["Alert when fading"],
					type = "toggle",
					desc = L["Alert me when Earth Shield fades from my target."],
					get = function(info) return ShamanFriend.db.profile.eshield.alert end,
					set = function(info,v)
						ShamanFriend.db.profile.eshield.alert = v
					end,
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 512,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when Earth Shield fades from my target."],
					get = function(info) return ShamanFriend.db.profile.eshield.sound end,
					set = function(info,v) ShamanFriend.db.profile.eshield.sound = v	end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					disabled = function() return not ShamanFriend.db.profile.eshield.enable end,
					order = 513,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.eshield.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.eshield.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.eshield.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.eshield.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.eshield.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.eshield.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.eshield.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.eshield.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		cc = {
			name = L["CC"],
			type = 'group',
			desc = L["Settings for Crowd Control."],
			order = 600,
			args = {
				success = {
					name = L["Success"],
					type = "toggle",
					desc = L["Display when successfully CCing a target."],
					get = function(info) return ShamanFriend.db.profile.cc.success end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.success = v
						ShamanFriend:LoadEvents()
					end,
					order = 602,
				},
				successtext = {
					name = L["Success text"],
					type = "input",
					desc = L["The text in the message when CC succeeds."],
					get = function(info) return ShamanFriend.db.profile.cc.successtext end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.successtext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not ShamanFriend.db.profile.cc.success end,
					order = 603,
				},
				fail = {
					name = L["Fail"],
					type = "toggle",
					desc = L["Display when CCing a target fails."],
					get = function(info) return ShamanFriend.db.profile.cc.fail end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.fail = v
						ShamanFriend:LoadEvents()
					end,
					order = 604,
				},
				failtext = {
					name = L["Fail text"],
					type = "input",
					desc = L["The text in the message when CC fails."],
					get = function(info) return ShamanFriend.db.profile.cc.failtext end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.failtext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not ShamanFriend.db.profile.cc.fail end,
					order = 605,
				},
				remove = {
					name = L["Remove"],
					type = "toggle",
					desc = L["Display when CC is removed from a target."],
					get = function(info) return ShamanFriend.db.profile.cc.remove end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.remove = v
						ShamanFriend:LoadEvents()
					end,
					order = 606,
				},
				removetext = {
					name = L["Remove text"],
					type = "input",
					desc = L["The text in the message when CC is removed."],
					get = function(info) return ShamanFriend.db.profile.cc.removetext end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.removetext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not ShamanFriend.db.profile.cc.remove end,
					order = 607,
				},
				ccchat = {
					name = string.format(L["Announce %s"],L["CC"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],L["CC"]),
					get = function(info) return ShamanFriend.db.profile.cc.ccchat end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.ccchat = v
					end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 608,
				},
				h609 = {type = "header", name = " ", order = 609},
				broken = {
					name = L["Broken CC"],
					type = "toggle",
					desc = L["Display when CC is broken."],
					get = function(info) return ShamanFriend.db.profile.cc.broken end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.broken = v
						ShamanFriend:LoadEvents()
					end,
					order = 610,
				},
				brokentext = {
					name = string.format(L["%s text"],L["Broken CC"]),
					type = "input",
					desc = L["The text in the message when CC is broken."],
					get = function(info) return ShamanFriend.db.profile.cc.brokentext end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.brokentext = v
						-- ShamanFriend:LoadEvents()
					end,
					usage = L["SOURCE = Source of break, TARGET = CC target"],
				 	disabled = function() return not ShamanFriend.db.profile.cc.broken end,
					order = 611,
				},
				brokenchat = {
					name = string.format(L["Announce %s"],L["Broken CC"]),
					type = "select",
					desc = string.format(L["Announce %s message to the following chat. (Above option must be enabled)"],L["Broken CC"]),
					get = function(info) return ShamanFriend.db.profile.cc.brokenchat end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.brokenchat = v
					end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 612,
				},
				tanktime = {
					name = L["Tank break time"],
					type = "range",
					desc = L["Do not warn if the tank breaks CC after this time"],
					get = function(info) return ShamanFriend.db.profile.cc.tanktime end,
					set = function(info,v)
						ShamanFriend.db.profile.cc.tanktime = v
						end,
					step = 1,
					min = 0,
					max = 60,
					order = 613,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when CC fades from my target."],
					get = function(info) return ShamanFriend.db.profile.cc.sound end,
					set = function(info,v) ShamanFriend.db.profile.cc.sound = v	end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					order = 614,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.cc.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.cc.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.cc.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.cc.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.cc.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.cc.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.cc.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.cc.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 614,
						},
					}
				},
			}
		},
		--[[totem = {
			name = L["Totems"],
			type = 'group',
			desc = L["Settings for Totems."],
			order = 500,
			args = {
				kill = {
					name = L["Warn on kill"],
					type = "toggle",
					desc = L["Shows a message whenether one of your totems are killed."],
					get = function(info) return ShamanFriend.db.profile.totem.kill end,
					set = function(info,v)
						ShamanFriend.db.profile.totem.kill = v
						ShamanFriend:LoadEvents()
					end,
					order = 501,
				},
				killmsg = {
					name = L["Broadcast on kill"],
					type = "text",
					desc = L["Broadcast to the following chat when one of your totems are killed. (Above option must be enabled)"],
					get = function(info) return ShamanFriend.db.profile.totem.killmsg end,
					set = function(info,v)
						ShamanFriend.db.profile.totem.killmsg = v
					end,
					disabled = function() return not ShamanFriend.db.profile.totem.killmsg end,
					validate = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 502,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = ShamanFriend.db.profile.totem.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) ShamanFriend.db.profile.totem.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return ShamanFriend.db.profile.totem.display.scroll end,
							set = function(info,t) ShamanFriend.db.profile.totem.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return ShamanFriend.db.profile.lo.display.frames end,
							set = function(info,t) ShamanFriend.db.profile.totem.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return ShamanFriend.db.profile.totem.display.time end,
							set = function(info,v)
								ShamanFriend.db.profile.totem.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},]]
	}
}

