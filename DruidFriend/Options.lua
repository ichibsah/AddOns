--[[
$Id: Options.lua 60 2016-07-20 09:40:21Z stassart $

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

-- Prevent LUA error with blank WTF
-- Disable DruidFriend if the player is not a druid
if select(2, UnitClass('player')) ~= "DRUID" then
	DisableAddOn("DruidFriend")
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("DruidFriend")

local lN = DruidFriend.lN

local LSM = LibStub("LibSharedMedia-3.0")

DruidFriend.options = {
	name = L["Options for DruidFriend"],
	handler = DruidFriend,
	type ='group',
	childGroups ='tree',
	desc = L["Options for DruidFriend"],
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
		check = {
			name = L["Perform checks"],
			type = "execute",
			desc = L["Perform checks"],
			func = "PerformChecks",
			guiHidden = true,
			order = 997,
		},
		display = {
			name = L["General"],
			type = 'group',
			desc = L["General settings and options for the Custom Message Frame."],
			order = 100, 
			args = {
				info = {
					type = "description",
					order = 101,
					name = "Version "..DruidFriend.DisplayVersion.."\n\n".. L["This addon provides tools for Druids."],
				},
				chatheader = {
					order = 109,
					type = "header",
					name = L["Chat Window Options"],
				},
				chat = {
					name = L["Chat Message"],
					type = "toggle",
					desc = L["Display message in Chat Frame."],
					get = function(info) return DruidFriend.db.profile.display.chat end,
					set = function(info,v) DruidFriend.db.profile.display.chat = v end,
					order = 110,
				},
				number= {
					name = L["Chat number"],
					type = "range",
					desc = L["Choose which chat to display the messages in (0=default)."],
					get = function(info)
						return DruidFriend.db.profile.display.number end,
					set = function(info,v)
						DruidFriend.db.profile.display.number = v
					end,
					step = 1,
					min = 0,
					max = 10,
					order = 111,
				},
				frameheader = {
					name = L["Message Frame"],
					type = "header",
					order = 112
				},
				frame = {
					name = L["Message Frame"],
					type = "toggle",
					desc = L["Display message in Custom Message Frame."],
					get = function(info) return DruidFriend.db.profile.display.frame end,
					set = function(info,v)
						DruidFriend.db.profile.display.frame = v
						DruidFriend:LoadEvents()
					end,
					order = 130,
				},
				lock = {
					name = L["Lock"],
					type = "toggle",
					desc = L["Toggle locking of the Custom Message Frame."],
					get = function(info) return DruidFriend.db.profile.display.lock end,
					set = function(info,v)
						DruidFriend.db.profile.display.lock = v
						DruidFriend:UpdateLock()
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
					get = function(info)
						return DruidFriend.db.profile.display.fontSize end,
					set = function(info,v)
						DruidFriend.db.profile.display.fontSize = v
						DruidFriend:UpdateFont()
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
					get = function(info)
						return DruidFriend.db.profile.display.fontEffect end,
					set = function(info,v)
						DruidFriend.db.profile.display.fontEffect = v
						DruidFriend:UpdateFont()
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
					get = function(info) return DruidFriend.db.profile.display.fontFace end,
					set = function(info,v)
						DruidFriend.db.profile.display.fontFace = v
						DruidFriend:UpdateFont()
					end,
					values = LSM:HashTable("font"),
					order = 135,
				},
				soundheader = {
					name = L["Sound Channel"],
					type = "header",
					order = 136,
				},
				SoundChannel = {
					name = L["Sound Channel"],
					type = "select",
					desc = L["Channel to play sounds"],
					get = function(info) return DruidFriend.db.profile.soundchannel end,
					set = function(info,v)
						DruidFriend.db.profile.soundchannel = v
						DruidFriend:LoadEvents()
					end,
					values = {
						["SFX"] = L["Effects"],
						["Music"] = L["Music"],
						["Ambience"] = L["Ambience"],
						["Master"] = L["Master"],
					},
					order = 137,
				},
			}
		},
		-- buff = {
		-- 	name = L["Buff"],
		-- 	type = 'group',
		-- 	desc = L["Alerts for buff."],
		-- 	order = 200, 
		-- 	args = {
		-- 		info = {
		-- 			type = "description",
		-- 			order = 201,
		-- 			name = L["Alerts for buff."],
		-- 		},
		-- 		enable = {
		-- 			name = L["Enable"],
		-- 			type = "toggle",
		-- 			desc = L["Enable checking buffs."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.enable end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.enable = v
		-- 				DruidFriend:LoadEvents()
		-- 			end,
		-- 			order = 202, 
		-- 		},
		-- 		whenheader = {
		-- 			order = 203,
		-- 			type = "header",
		-- 			name = L["When to check"],
		-- 		},
		-- 		readycheck = {
		-- 			name = L["Ready Check"],
		-- 			type = "toggle",
		-- 			desc = L["Notify on ready check."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.readycheck end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.readycheck = v
		-- 				DruidFriend:LoadEvents()
		-- 			end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 204, 
		-- 		},
		-- 		entercombat = {
		-- 			name = L["Enter Combat"],
		-- 			type = "toggle",
		-- 			desc = L["Notify when entering combat."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.entercombat end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.entercombat = v
		-- 				DruidFriend:LoadEvents()
		-- 			end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 205,
		-- 		},
		-- 		aftercombat = {
		-- 			name = L["After Combat"],
		-- 			type = "toggle",
		-- 			desc = L["Notify after the end of combat."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.aftercombat end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.aftercombat = v
		-- 				DruidFriend:LoadEvents()
		-- 			end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 206,
		-- 		},
		-- 		disableheader = {
		-- 			order = 207,
		-- 			type = "header",
		-- 			name = L["Disable checks"],
		-- 		},
		-- 		mounted = {
		-- 			name = L["No Mounted"],
		-- 			type = "toggle",
		-- 			desc = L["Disable notifications when mounted."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.mounted end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.mounted = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 208,
		-- 		},
		-- 		vehicle = {
		-- 			name = L["No Vehicle"],
		-- 			type = "toggle",
		-- 			desc = L["Disable notifications when in a vehicle."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.vehicle end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.vehicle = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 209,
		-- 		},
		-- 		combat = {
		-- 			name = L["No Combat"],
		-- 			type = "toggle",
		-- 			desc = L["Disable notifications when in combat."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.combat end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.combat = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 210,
		-- 		},
		-- 		pvp = {
		-- 			name = L["No PvP"],
		-- 			type = "toggle",
		-- 			desc = L["Disable notifications when PvP flagged."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.pvp end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.pvp = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 211,
		-- 		},
		-- 		locationheader = {
		-- 			order = 212,
		-- 			type = "header",
		-- 			name = L["Location"],
		-- 		},
		-- 		bg = {
		-- 			name = L["Battleground"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when in battlegrounds."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.bg end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.bg = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 213,
		-- 		},
		-- 		arena = {
		-- 			name = L["Arena"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when in arena."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.arena end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.arena = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 214,
		-- 		},
		-- 		pvpzone = {
		-- 			name = L["PvP Zone"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when in Tol Barad/Wintergrasp."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.wg end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.wg = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 215,
		-- 		},
		-- 		instance = {
		-- 			name = L["5-man"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when in a 5-man instance."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.instance end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.instance = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 216,
		-- 		},
		-- 		raid = {
		-- 			name = L["Raid"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when in a raid instance."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.raid end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.raid = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 217,
		-- 		},
		-- 		world = {
		-- 			name = L["Other"],
		-- 			type = "toggle",
		-- 			desc = L["Warn when not in an instance, arena, or battleground."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.world end,
		-- 			set = function(info,v) DruidFriend.db.profile.buff.world = v end,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 218,
		-- 		},
		-- 		otherheader = {
		-- 			order = 219,
		-- 			type = "header",
		-- 			name = L["Other Options"],
		-- 		},
		-- 		time = {
		-- 			name = L["Frequency"],
		-- 			type = "range",
		-- 			desc = L["Do not warn more often than (5=default)"],
		-- 			get = function(info) return DruidFriend.db.profile.buff.frequency end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.frequency = v
		-- 				end,
		-- 			step = 1,
		-- 			min = 0,
		-- 			max = 30,
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 220,
		-- 		},
		-- 		sound = {
		-- 			name = L["Sound"],
		-- 			type = "select",
		-- 			desc = L["Play a sound when a buff is missing."],
		-- 			get = function(info) return DruidFriend.db.profile.buff.sound end,
		-- 			set = function(info,v)
		-- 				DruidFriend.db.profile.buff.sound = v
		-- 				-- DruidFriend:Play(v)
		-- 				end,
		-- 			dialogControl = "LSM30_Sound",
		-- 			values = LSM:HashTable("sound"),
		-- 			disabled = function() return not DruidFriend.db.profile.buff.enable end,
		-- 			order = 221,
		-- 		},
		-- 		display = {
		-- 			name = L["Display"],
		-- 			type = 'group',
		-- 			desc = L["Settings for how to display the message."], 
		-- 			args = {
		-- 				color = {
		-- 					name = L["Color"],
		-- 					type = 'color',
		-- 					desc = L["Sets the color of the text when displaying messages."],
		-- 					get = function(info)
		-- 					local v = DruidFriend.db.profile.buff.display.color
		-- 						return v.r,v.g,v.b
		-- 						end,
		-- 					set = function(info,r,g,b) DruidFriend.db.profile.buff.display.color = {r=r,g=g,b=b} end
		-- 				},
		-- 				scroll = {
		-- 					type = 'toggle',
		-- 					name = L["Scroll output"],
		-- 					desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
		-- 					get = function(info) return DruidFriend.db.profile.buff.display.scroll end,
		-- 					set = function(info,t) DruidFriend.db.profile.buff.display.scroll = t end,
		-- 				},
		-- 				frames = {
		-- 					type = 'toggle',
		-- 					name = L["Frames output"],
		-- 					desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
		-- 					get = function(info) return DruidFriend.db.profile.buff.display.frames end,
		-- 					set = function(info,t) DruidFriend.db.profile.buff.display.frames = t end,
		-- 				},
		-- 				time = {
		-- 					--hidden = true,
		-- 					name = L["Time to display message"],
		-- 					type = "range",
		-- 					desc = L["Set the time the message will be displayed (5=default)"],
		-- 					get = function(info) return DruidFriend.db.profile.buff.display.time end,
		-- 					set = function(info,v)
		-- 						DruidFriend.db.profile.buff.display.time = v
		-- 					end,
		-- 					step = 1,
		-- 					min = 1,
		-- 					max = 20,
		-- 					order = 111,
		-- 				},
		-- 			}
		-- 		},
		-- 	}
		-- },
		announce = {
			name = L["Announcements"],
			type = 'group',
			childGroups = 'tab',
			desc = L["Announce different spells."],
			order = 300,
			args = {
				spells = {
					name = L["Spells"],
					type = 'group',
					desc = L["Spells to announce."], 
					order = 100,
					args = {
						intheader = {
							order = 101,
							type = "header",
							name = L["Interrupt"],
						},
						interrupt = {
							name = L["Interrupt"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],L["Interrupt"]),
							get = function(info) return DruidFriend.db.profile.announce.interrupt end,
							set = function(info,v)
								DruidFriend.db.profile.announce.interrupt = v
								DruidFriend:LoadEvents()
							end,
							order = 102,
						},
						intchan = {
							name = string.format(L["Announce %s"],L["Interrupt"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],L["Interrupt"]),
							get = function(info) return DruidFriend.db.profile.announce.intchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.intchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.interrupt end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 103,
						},
						dispelheader = {
							order = 104,
							type = "header",
							name = L["Dispel"],
						},
						dispel = {
							name = L["Dispel"],
							type = "toggle",
							desc = L["Toggle message when dispel is cast."],
							get = function(info) return DruidFriend.db.profile.announce.dispel end,
							set = function(info,v)
								DruidFriend.db.profile.announce.dispel = v
								DruidFriend:LoadEvents()
							end,
							order = 105,
						},
						dispelpm = {
							name = L["Whisper"],
							type = "toggle",
							desc = string.format(L["Toggle %s whisper."],L["Dispel"]),
							get = function(info) return DruidFriend.db.profile.announce.dispelpm end,
							set = function(info,v)
								DruidFriend.db.profile.announce.dispelpm = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.dispel end,
							order = 106,
						},
						dispelchan = {
							name = string.format(L["Announce %s"],L["Dispel"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],L["Dispel"]),
							get = function(info) return DruidFriend.db.profile.announce.dispelchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.dispelchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.dispel end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 107,
						},
						ironheader = {
							order = 113,
							type = "header",
							name = lN["Ironbark"],
						},
						iron = {
							name = lN["Ironbark"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Ironbark"]),
							get = function(info) return DruidFriend.db.profile.announce.iron end,
							set = function(info,v)
								DruidFriend.db.profile.announce.iron = v
								DruidFriend:LoadEvents()
							end,
							order = 114,
						},
						ironpm = {
							name = L["Whisper"],
							type = "toggle",
							desc = string.format(L["Toggle %s whisper."],lN["Ironbark"]),
							get = function(info) return DruidFriend.db.profile.announce.ironpm end,
							set = function(info,v)
								DruidFriend.db.profile.announce.ironpm = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.iron end,
							order = 115,
						},
						ironchan = {
							name = string.format(L["Announce %s"],lN["Ironbark"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Ironbark"]),
							get = function(info) return DruidFriend.db.profile.announce.ironchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.ironchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.iron end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 116,
						},
						irontext = {
							name = string.format(L["%s text"],lN["Ironbark"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Ironbark"]),
							get = function(info) return DruidFriend.db.profile.announce.irontext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.irontext = v
							end,
							usage = L["SPELL = spell cast, TARGET = target of spell"],
							disabled = function() return not DruidFriend.db.profile.announce.iron end,
							order = 117,
						},
						tranqheader = {
							order = 118,
							type = "header",
							name = lN["Tranquility"],
						},
						tranquility = {
							name = lN["Tranquility"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Tranquility"]),
							get = function(info) return DruidFriend.db.profile.announce.tranquility end,
							set = function(info,v)
								DruidFriend.db.profile.announce.tranquility = v
								DruidFriend:LoadEvents()
							end,
							order = 119,
						},
						tranqchan = {
							name = string.format(L["Announce %s"],lN["Tranquility"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Tranquility"]),
							get = function(info) return DruidFriend.db.profile.announce.tranqchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.tranqchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.tranquility end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 120,
						},
						tranqtext = {
							name = string.format(L["%s text"],lN["Tranquility"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Tranquility"]),
							get = function(info) return DruidFriend.db.profile.announce.tranqtext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.tranqtext = v
							end,
							usage = L["SPELL = spell cast"],
							disabled = function() return not DruidFriend.db.profile.announce.tranquility end,
							order = 121,
						},
						starheader = {
							order = 122,
							type = "header",
							name = lN["Starfall"],
						},
						starfall = {
							name = lN["Starfall"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Starfall"]),
							get = function(info) return DruidFriend.db.profile.announce.starfall end,
							set = function(info,v)
								DruidFriend.db.profile.announce.starfall = v
								DruidFriend:LoadEvents()
							end,
							order = 123,
						},
						starchan = {
							name = string.format(L["Announce %s"],lN["Starfall"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Starfall"]),
							get = function(info) return DruidFriend.db.profile.announce.starchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.starchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.starfall end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 124,
						},
						startext = {
							name = string.format(L["%s text"],lN["Starfall"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Starfall"]),
							get = function(info) return DruidFriend.db.profile.announce.startext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.startext = v
							end,
							usage = L["SPELL = spell cast"],
							disabled = function() return not DruidFriend.db.profile.announce.starfall end,
							order = 125,
						},
						zerkheader = {
							order = 126,
							type = "header",
							name = lN["Berserk"],
						},
						berserk = {
							name = lN["Berserk"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Berserk"]),
							get = function(info) return DruidFriend.db.profile.announce.berserk end,
							set = function(info,v)
								DruidFriend.db.profile.announce.berserk = v
								DruidFriend:LoadEvents()
							end,
							order = 127,
						},
						zerkchan = {
							name = string.format(L["Announce %s"],lN["Berserk"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Berserk"]),
							get = function(info) return DruidFriend.db.profile.announce.zerkchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.zerkchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.berserk end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 128,
						},
						zerktext = {
							name = string.format(L["%s text"],lN["Berserk"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Berserk"]),
							get = function(info) return DruidFriend.db.profile.announce.zerktext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.zerktext = v
							end,
							usage = L["SPELL = spell cast"],
							disabled = function() return not DruidFriend.db.profile.announce.berserk end,
							order = 129,
						},
					}
				},
				tank = {
					name = L["Tank"],
					type = 'group',
					desc = L["Spells to announce."], 
					order = 200,
					args = {
						tankheader = {
							order = 201,
							type = "header",
							name = L["Tank"],
						},
						balspec = {
							name = L["Enable in Balance"],
							type = "toggle",
							desc = L["Announce tank cooldowns by spec."],
							get = function(info) return DruidFriend.db.profile.tank.balspec end,
							set = function(info,v)
				 				DruidFriend.db.profile.absorb.balspec = v
				 				DruidFriend:LoadEvents()
							end,
							order = 202,
						},
						feralspec = {
							name = L["Enable in Feral"],
							type = "toggle",
							desc = L["Announce tank cooldowns by spec."],
							get = function(info) return DruidFriend.db.profile.tank.feralspec end,
							set = function(info,v)
				 				DruidFriend.db.profile.absorb.feralspec = v
				 				DruidFriend:LoadEvents()
							end,
							order = 203,
						},
						guardspec = {
							name = L["Enable in Guardian"],
							type = "toggle",
							desc = L["Announce tank cooldowns by spec."],
							get = function(info) return DruidFriend.db.profile.tank.guardspec end,
							set = function(info,v)
				 				DruidFriend.db.profile.absorb.guardspec = v
				 				DruidFriend:LoadEvents()
							end,
							order = 204,
						},
						restospec = {
							name = L["Enable in Resto"],
							type = "toggle",
							desc = L["Announce tank cooldowns by spec."],
							get = function(info) return DruidFriend.db.profile.tank.restospec end,
							set = function(info,v)
				 				DruidFriend.db.profile.absorb.guardspec = v
				 				DruidFriend:LoadEvents()
							end,
							order = 205,
						},
						-- tankspec = {
						-- 	name = L["Spec Check"],
						-- 	type = "select",
						-- 	width = "double",
						-- 	desc = L["Announce tank cooldowns by spec."],
						-- 	get = function(info) return DruidFriend.db.profile.announce.tankspec end,
						-- 	set = function(info,v)
						-- 		DruidFriend.db.profile.announce.tankspec = v
						-- 	end,
						-- 	values = {
						-- 		-- ["both"] = L["Both specs"],
						-- 		["feral"] = L["Only in Feral spec"],
						-- 		["guardian"] = L["Only in Guardian spec"],
						-- 		-- ["primary"] = L["Only in primary spec"],
						-- 		-- ["secondary"] = L["Only in secondary spec"],
						-- 		["none"] = L["Disable tank cooldown announcements"],
						-- 	},
						-- 	order = 202,
						-- },
						barkheader = {
							order = 206,
							type = "header",
							name = lN["Barkskin"],
						},
						barkskin = {
							name = lN["Barkskin"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Barkskin"]),
							get = function(info) return DruidFriend.db.profile.announce.barkskin end,
							set = function(info,v)
								DruidFriend.db.profile.announce.barkskin = v
								DruidFriend:LoadEvents()
							end,
							order = 207,
						},
						barkchan = {
							name = string.format(L["Announce %s"],lN["Barkskin"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Barkskin"]),
							get = function(info) return DruidFriend.db.profile.announce.barkchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.barkchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.barkskin end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 208,
						},
						barktext = {
							name = string.format(L["%s text"],lN["Barkskin"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Barkskin"]),
							get = function(info) return DruidFriend.db.profile.announce.barktext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.barktext = v
							end,
							usage = L["SPELL = spell cast"],
							disabled = function() return not DruidFriend.db.profile.announce.barkskin end,
							order = 209,
						},
						survheader = {
							order = 211,
							type = "header",
							name = lN["Survival Instincts"],
						},
						survival = {
							name = lN["Survival Instincts"],
							type = "toggle",
							desc = string.format(L["Toggle %s information."],lN["Survival Instincts"]),
							get = function(info) return DruidFriend.db.profile.announce.survival end,
							set = function(info,v)
								DruidFriend.db.profile.announce.survival = v
								DruidFriend:LoadEvents()
							end,
							order = 212,
						},
						survchan = {
							name = string.format(L["Announce %s"],lN["Survival Instincts"]),
							type = "select",
							desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],lN["Survival Instincts"]),
							get = function(info) return DruidFriend.db.profile.announce.survchan end,
							set = function(info,v)
								DruidFriend.db.profile.announce.survchan = v
							end,
							disabled = function() return not DruidFriend.db.profile.announce.survival end,
							values = {
								["RAID"] = L["Raid"],
								["PARTY"] = L["Party"],
								["RAID_WARNING"] = L["Raid Warning"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 213,
						},
						survtext = {
							name = string.format(L["%s text"],lN["Survival Instincts"]),
							type = "input",
							width = "full",
							desc = string.format(L["%s announcement text."],lN["Survival Instincts"]),
							get = function(info) return DruidFriend.db.profile.announce.survtext end,
							set = function(info,v)
								DruidFriend.db.profile.announce.survtext = v
							end,
							usage = L["SPELL = spell cast"],
							disabled = function() return not DruidFriend.db.profile.announce.survival end,
							order = 214,
						},
						-- cdheader = {
						-- 	order = 215,
						-- 	type = "header",
						-- 	name = L["Expirations"],
						-- },
						-- savage = {
						-- 	name = L["Savage Defense Expire"],
						-- 	type = "toggle",
						-- 	desc = L["Notify on Savage Defense Expire"],
						-- 	get = function(info) return DruidFriend.db.profile.announce.savage end,
						-- 	set = function(info,v)
						-- 		DruidFriend.db.profile.announce.savage = v
						-- 		DruidFriend:LoadEvents()
						-- 	end,
						-- 	order = 216,
						-- },
						-- frenz = {
						-- 	name = L["Frenzied Regeneration Glyph Expire"],
						-- 	type = "toggle",
						-- 	desc = L["Notify on Frenzied Regeneration Glyph Expire"],
						-- 	get = function(info) return DruidFriend.db.profile.announce.frenz end,
						-- 	set = function(info,v)
						-- 		DruidFriend.db.profile.announce.frenz = v
						-- 		DruidFriend:LoadEvents()
						-- 	end,
						-- 	order = 217,
						-- },
					}
				},
				announceloc = {
					name = L["Where"],
					type = 'group',
					desc = L["Where to display the announcements."], 
					order = 300,
					args = {
						BGAnnounce = {
							name = L["BG Announce"],
							type = "select",
							width = "double",
							desc = L["Announce when in battlegrounds."],
							get = function(info) return DruidFriend.db.profile.announce.loc.bgannounce end,
							set = function(info,v)
								DruidFriend.db.profile.announce.loc.bgannounce = v
								DruidFriend:LoadEvents()
							end,
							values = {
								["BATTLEGROUND"] = L["Battleground"],
								["PARTY"] = L["Party"],
								["YELL"] = L["Yell"],
								["SAY"] = L["Say"],
								["none"] = L["None"],
							},
							order = 351,
						},
						ArenaAnnounce = {
							name = L["Arena Announce"],
							type = "toggle",
							width = "double",
							desc = L["Announce when in arena."],
							get = function(info) return DruidFriend.db.profile.announce.loc.arenaannounce end,
							set = function(info,v)
								DruidFriend.db.profile.announce.loc.arenaannounce = v
								DruidFriend:LoadEvents()
							end,
							order = 352,
						},
						PartyAnnounce = {
							name = L["5-man Announce"],
							type = "toggle",
							width = "double",
							desc = L["Announce when in a 5-man instance."],
							get = function(info) return DruidFriend.db.profile.announce.loc.partyannounce end,
							set = function(info,v)
								DruidFriend.db.profile.announce.loc.partyannounce = v
								DruidFriend:LoadEvents()
							end,
							order = 353,
						},
						RaidAnnounce = {
							name = L["Raid Announce"],
							type = "toggle",
							width = "double",
							desc = L["Announce when in a raid instance."],
							get = function(info) return DruidFriend.db.profile.announce.loc.raidannounce end,
							set = function(info,v)
								DruidFriend.db.profile.announce.loc.raidannounce = v
								DruidFriend:LoadEvents()
							end,
							order = 354,
						},
						WorldAnnounce = {
							name = L["World Announce"],
							type = "toggle",
							width = "double",
							desc = L["Announce when not in instances."],
							get = function(info) return DruidFriend.db.profile.announce.loc.worldannounce end,
							set = function(info,v)
								DruidFriend.db.profile.announce.loc.worldannounce = v
								DruidFriend:LoadEvents()
							end,
							order = 355,
						},
					}
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					order = 400,
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							width = "double",
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = DruidFriend.db.profile.announce.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) DruidFriend.db.profile.announce.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							width = "double",
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return DruidFriend.db.profile.announce.display.scroll end,
							set = function(info,t) DruidFriend.db.profile.announce.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							width = "double",
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return DruidFriend.db.profile.announce.display.frames end,
							set = function(info,t) DruidFriend.db.profile.announce.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							width = "double",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return DruidFriend.db.profile.announce.display.time end,
							set = function(info,v)
								DruidFriend.db.profile.announce.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
						},
					}
				},
				other = {
					name = L["Other Options"],
					type = 'group',
					desc = L["Other Options"], 
					order = 500,
					args = {
						target = {
							name = L["Add target"],
							type = "toggle",
							width = "double",
							desc = L["Add the target to the end of the message when announcing."],
							get = function(info) return DruidFriend.db.profile.announce.target end,
							set = function(info,v)
								DruidFriend.db.profile.announce.target = v
							end,
							order = 501,
						},
						frequency = {
							name = L["Frequency"],
							type = "range",
							width = "double",
							desc = L["Do not warn more often than (5=default)"],
							get = function(info) return DruidFriend.db.profile.announce.frequency end,
							set = function(info,v)
								DruidFriend.db.profile.announce.frequency = v
								end,
							step = 1,
							min = 0,
							max = 30,
							order = 502,
						},
					}
				},
			}
		},
		cc = {
			name = L["CC"],
			type = 'group',
			desc = L["Settings for Crowd Control."],
			order = 400,
			args = {
				success = {
					name = L["Success"],
					type = "toggle",
					desc = L["Display when successfully CCing a target."],
					get = function(info) return DruidFriend.db.profile.cc.success end,
					set = function(info,v)
						DruidFriend.db.profile.cc.success = v
						DruidFriend:LoadEvents()
					end,
					order = 402,
				},
				successtext = {
					name = L["Success text"],
					type = "input",
					width = "double",
					desc = L["The text in the message when CC succeeds."],
					get = function(info) return DruidFriend.db.profile.cc.successtext end,
					set = function(info,v)
						DruidFriend.db.profile.cc.successtext = v
						-- DruidFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not DruidFriend.db.profile.cc.success end,
					order = 403,
				},
				fail = {
					name = L["Fail"],
					type = "toggle",
					desc = L["Display when CCing a target fails."],
					get = function(info) return DruidFriend.db.profile.cc.fail end,
					set = function(info,v)
						DruidFriend.db.profile.cc.fail = v
						DruidFriend:LoadEvents()
					end,
					order = 404,
				},
				failtext = {
					name = L["Fail text"],
					type = "input",
					width = "double",
					desc = L["The text in the message when CC fails."],
					get = function(info) return DruidFriend.db.profile.cc.failtext end,
					set = function(info,v)
						DruidFriend.db.profile.cc.failtext = v
						-- DruidFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not DruidFriend.db.profile.cc.fail end,
					order = 405,
				},
				fade = {
					name = L["Fade"],
					type = "toggle",
					desc = L["Display when CC fades from a target."],
					get = function(info) return DruidFriend.db.profile.cc.fade end,
					set = function(info,v)
						DruidFriend.db.profile.cc.fade = v
						DruidFriend:LoadEvents()
					end,
					order = 406,
				},
				fadetext = {
					name = L["Fade text"],
					type = "input",
					width = "double",
					desc = L["The text in the message when CC fades."],
					get = function(info) return DruidFriend.db.profile.cc.fadetext end,
					set = function(info,v)
						DruidFriend.db.profile.cc.fadetext = v
						-- DruidFriend:LoadEvents()
					end,
					usage = L["TARGET = CC target"],
					disabled = function() return not DruidFriend.db.profile.cc.fade end,
					order = 407,
				},
				ccchat = {
					name = L["CC Channel"],
					type = "select",
					desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],L["CC"]),
					get = function(info) return DruidFriend.db.profile.cc.ccchan end,
					set = function(info,v)
						DruidFriend.db.profile.cc.ccchan = v
					end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 408,
				},
				brokenheader = {
					order = 409,
					type = "header",
					name = L["Broken CC"],
				},
				broken = {
					name = L["Broken CC"],
					type = "toggle",
					desc = L["Display when CC is broken."],
					get = function(info) return DruidFriend.db.profile.cc.broken end,
					set = function(info,v)
						DruidFriend.db.profile.cc.broken = v
						DruidFriend:LoadEvents()
					end,
					order = 410,
				},
				brokentext = {
					name = string.format(L["%s text"],L["Broken CC"]),
					type = "input",
					width = "double",
					desc = L["The text in the message when CC is broken."],
					get = function(info) return DruidFriend.db.profile.cc.brokentext end,
					set = function(info,v)
						DruidFriend.db.profile.cc.brokentext = v
						-- DruidFriend:LoadEvents()
					end,
					usage = L["SOURCE = Source of break, TARGET = CC target"],
				 	disabled = function() return not DruidFriend.db.profile.cc.broken end,
					order = 411,
				},
				brokenchat = {
					name = L["Broken CC Channel"],
					type = "select",
					desc = string.format(L["Announce %s message to the following channel (Above option must be enabled)."],L["Broken CC"]),
					get = function(info) return DruidFriend.db.profile.cc.brokenchan end,
					set = function(info,v)
						DruidFriend.db.profile.cc.brokenchan = v
					end,
					values = {
						["RAID"] = L["Raid"],
						["PARTY"] = L["Party"],
						["YELL"] = L["Yell"],
						["SAY"] = L["Say"],
						["RAID_WARNING"] = L["Raid Warning"],
						["none"] = L["None"],
					},
					order = 412,
				},
				tanktime = {
					name = L["Tank break time"],
					type = "range",
					desc = L["Do not warn if the tank breaks CC after this time"],
					get = function(info) return DruidFriend.db.profile.cc.tanktime end,
					set = function(info,v)
						DruidFriend.db.profile.cc.tanktime = v
						end,
					step = 1,
					min = 0,
					max = 60,
					order = 413,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when CC fades from my target."],
					get = function(info) return DruidFriend.db.profile.cc.sound end,
					set = function(info,v)
						DruidFriend.db.profile.cc.sound = v
						-- DruidFriend:Play(v)
						end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					order = 414,
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
							local v = DruidFriend.db.profile.cc.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) DruidFriend.db.profile.cc.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return DruidFriend.db.profile.cc.display.scroll end,
							set = function(info,t) DruidFriend.db.profile.cc.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return DruidFriend.db.profile.cc.display.frames end,
							set = function(info,t) DruidFriend.db.profile.cc.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return DruidFriend.db.profile.cc.display.time end,
							set = function(info,v)
								DruidFriend.db.profile.cc.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
						},
					}
				},
			}
		},
		absorb = {
			name = L["Absorb Tracker"],
			type = 'group',
			desc = L["Settings for Absorb Tracker."],
			order = 500,
			args = {
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Toggle Absorb tracker"],
					get = function(info) return DruidFriend.db.profile.absorb.enable end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.enable = v
						DruidFriend:LoadEvents()
					end,
					order = 501,
				},
				lock = {
					name = L["Lock tracker"],
					type = "toggle",
					desc = L["Lock Absorb tracker."],
					get = function(info) return DruidFriend.db.profile.absorb.lock end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.lock = v
						DruidFriend:AbsorbFrameUpdate()
					end,
					order = 502,
				},
				icon = {
					name = L["Icon"],
					type = "toggle",
					desc = L["Show most powerful absorb spell icon."],
					get = function(info) return DruidFriend.db.profile.absorb.icon end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.icon = v
						DruidFriend:AbsorbFrameUpdate()
					end,
					order = 503,
				},
				time = {
					name = L["Time"],
					type = "toggle",
					desc = L["Show remaining time on the current absorb amount."],
					get = function(info) return DruidFriend.db.profile.absorb.time end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.time = v
						DruidFriend:AbsorbUpdate()
					end,
					order = 504,
				},
				resetpos = {
					name = L["Reset Position"],
					type = "execute",
					desc = L["Reset Position"],
					func = "ResetAbsorbPos",
					order = 506,
				},
				condheader = {
					order = 507,
					type = "header",
					name = L["Visible Conditions"],
				},
				combat = {
					name = L["Combat Only"],
					type = "toggle",
					desc = L["Only show in combat?"],
					get = function(info) return DruidFriend.db.profile.absorb.combat end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.combat = v
						DruidFriend:AbsorbUpdate()
					end,
					order = 508,
				},
				zero = {
					name = L["Absorbs Only"],
					type = "toggle",
					desc = L["Only show when there are absorbs?"],
					get = function(info) return DruidFriend.db.profile.absorb.zero end,
					set = function(info,v)
						DruidFriend.db.profile.absorb.zero = v
						DruidFriend:AbsorbUpdate()
					end,
					order = 509,
				},
				balspec = {
					name = L["Enable in Balance"],
					type = "toggle",
				 	desc = L["Absorb tracker by spec."],
					get = function(info) return DruidFriend.db.profile.absorb.balspec end,
					set = function(info,v)
				 		DruidFriend.db.profile.absorb.balspec = v
				 		DruidFriend:LoadEvents()
					end,
					order = 510,
				},
				feralspec = {
					name = L["Enable in Feral"],
					type = "toggle",
				 	desc = L["Absorb tracker by spec."],
					get = function(info) return DruidFriend.db.profile.absorb.feralspec end,
					set = function(info,v)
				 		DruidFriend.db.profile.absorb.feralspec = v
				 		DruidFriend:LoadEvents()
					end,
					order = 511,
				},
				guardspec = {
					name = L["Enable in Guardian"],
					type = "toggle",
				 	desc = L["Absorb tracker by spec."],
					get = function(info) return DruidFriend.db.profile.absorb.guardspec end,
					set = function(info,v)
				 		DruidFriend.db.profile.absorb.guardspec = v
				 		DruidFriend:LoadEvents()
					end,
					order = 512,
				},
				restospec = {
					name = L["Enable in Resto"],
					type = "toggle",
				 	desc = L["Absorb tracker by spec."],
					get = function(info) return DruidFriend.db.profile.absorb.restospec end,
					set = function(info,v)
				 		DruidFriend.db.profile.absorb.guardspec = v
				 		DruidFriend:LoadEvents()
					end,
					order = 512,
				},
				-- spec = {
				-- 	name = L["Spec Check"],
				-- 	type = "select",
				-- 	width = "double",
				-- 	desc = L["Absorb tracker by spec."],
				-- 	get = function(info) return DruidFriend.db.profile.absorb.spec end,
				-- 	set = function(info,v)
				-- 		DruidFriend.db.profile.absorb.spec = v
				-- 		DruidFriend:LoadEvents()
				-- 	end,
				-- 	values = {
				-- 		-- ["both"] = L["Both specs"],
				-- 		["feral"] = L["Only in Feral spec"],
				-- 		["guardian"] = L["Only in Guardian spec"],
				-- 		-- ["primary"] = L["Only in primary spec"],
				-- 		-- ["secondary"] = L["Only in secondary spec"],
				-- 	},
				-- 	order = 510,
				-- },
			}
		},
		cooldown = {
			name = L["Cooldowns"],
			type = 'group',
			desc = L["Cooldown Output Information."],
			order = 600,
			args = {
				tranq = {
					name = lN["Tranquility"],
					type = "toggle",
					desc = L["Display how much healing Tranquility did"],
					get = function(info) return DruidFriend.db.profile.cd.tranq end,
					set = function(info,v)
						DruidFriend.db.profile.cd.tranq = v
					end,
					order = 601,
				},
				starfall = {
					name = lN["Starfall"],
					type = "toggle",
					desc = L["Display how much damage Starfall did"],
					get = function(info) return DruidFriend.db.profile.cd.starfall end,
					set = function(info,v)
						DruidFriend.db.profile.cd.starfall = v
					end,
					order = 602,
				},
				berserk = {
					name = L["Bear Berserk"],
					type = "toggle",
					desc = L["Display how much damage Mangle(Bear) did during Berserk"],
					get = function(info) return DruidFriend.db.profile.cd.berserk end,
					set = function(info,v)
						DruidFriend.db.profile.cd.berserk = v
					end,
					order = 603,
				},
				otherheader = {
					order = 604,
					type = "header",
					name = L["Other Options"],
				},
				crits = {
					name = L["Crits"],
					type = "toggle",
					desc = L["Display how many crits"],
					get = function(info) return DruidFriend.db.profile.cd.crits end,
					set = function(info,v)
						DruidFriend.db.profile.cd.crits = v
					end,
					order = 605,
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
							local v = DruidFriend.db.profile.cd.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) DruidFriend.db.profile.cd.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return DruidFriend.db.profile.cd.display.scroll end,
							set = function(info,t) DruidFriend.db.profile.cd.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return DruidFriend.db.profile.cd.display.frames end,
							set = function(info,t) DruidFriend.db.profile.cd.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return DruidFriend.db.profile.cd.display.time end,
							set = function(info,v)
								DruidFriend.db.profile.cd.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
						},
					}
				},
			}
		},
		taunt = {
			name = L["Taunts"],
			type = 'group',
			desc = L["Taunt Tracker"],
			order = 700,
			args = {
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Toggle Taunt tracker"],
					get = function(info) return DruidFriend.db.profile.taunt.enable end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.enable = v
						DruidFriend:LoadEvents()
					end,
					order = 701,
				},
				own = {
					name = L["Own"],
					type = "toggle",
					desc = L["Track own taunts"],
					get = function(info) return DruidFriend.db.profile.taunt.own end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.own = v
					end,
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 702,
				},
				other = {
					name = L["Other"],
					type = "toggle",
					desc = L["Track other player's taunts"],
					get = function(info) return DruidFriend.db.profile.taunt.other end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.other = v
					end,
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 703,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when someone taunts."],
					get = function(info) return DruidFriend.db.profile.taunt.sound end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.sound = v
						-- DruidFriend:Play(v)
						end,
					dialogControl = "LSM30_Sound",
					values = LSM:HashTable("sound"),
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 704,
				},
				petheader = {
					order = 705,
					type = "header",
					name = L["Pet Taunts"],
				},
				pet = {
					name = L["Pet Taunts"],
					type = "toggle",
					desc = L["Track pet actual taunts"],
					get = function(info) return DruidFriend.db.profile.taunt.pet end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.pet = v
					end,
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 706,
				},
				petaggro = {
					name = L["Pet Aggro"],
					type = "toggle",
					desc = L["Track pet aggro abilities"],
					get = function(info) return DruidFriend.db.profile.taunt.petaggro end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.petaggro = v
					end,
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 707,
				},
				noisypet = {
					name = L["Noisy Pet"],
					type = "toggle",
					desc = L["Notify each time instead of once per combat"],
					get = function(info) return DruidFriend.db.profile.taunt.noisypet end,
					set = function(info,v)
						DruidFriend.db.profile.taunt.noisypet = v
					end,
					disabled = function() return not DruidFriend.db.profile.taunt.enable end,
					order = 708,
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
							local v = DruidFriend.db.profile.taunt.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) DruidFriend.db.profile.taunt.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return DruidFriend.db.profile.taunt.display.scroll end,
							set = function(info,t) DruidFriend.db.profile.taunt.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return DruidFriend.db.profile.taunt.display.frames end,
							set = function(info,t) DruidFriend.db.profile.taunt.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return DruidFriend.db.profile.taunt.display.time end,
							set = function(info,v)
								DruidFriend.db.profile.taunt.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
						},
					}
				},
			}
		},
	}
}

