local ignore_missing = true
--[===[@debug@
ignore_missing = false
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("ShamanFriend", "enUS", true, ignore_missing)
if not L then return end

-- Options
L["Options for ShamanFriend"] = true

L["Show UI"] = true
L["Shows the Graphical User Interface"] = true

L["Show version"] = true

-- Generic for many spells
-- These should be some of the first to translate as they will effect many strings.
L["Toggle %s information."] = true
L["%s message"] = true
L["%s text"] = true
L["%s chat"] = true
L["Send a message when %s is cast."] = true
L["The text in the message when %s is cast."] = true
L["Chat for the %s message."] = true
L["Announce %s"] = true
L["Announce %s message to the following chat. (Above option must be enabled)"] = true

L["Alerts"] = true
L["Settings for Elemental Shields."] = true
L["Elemental Shield"] = true
L["Toggle check for Elemental Shield."] = true
L["Toggle Earth Shield tracking on other targets than yourself."] = true
L["Ready Check"] = true
L["Notify on ready check."] = true
L["Enter Combat"] = true
L["Notify when entering combat."] = true
L["After Combat"] = true
L["Notify after the end of combat."] = true
L["No Mounted"] = true
L["No Vehicle"] = true
L["Disable notifications when mounted."] = true
L["Disable notifications when in a vehicle."] = true
L["Sound"] = true
L["Play a sound when a buff is missing."] = true
L["Alert when lightning shield hits X stacks."] = true
L["Play a sound when a proc occurs."] = true
L["Number of stacks"] = true
L["Alert when buff reaches number of stacks."] = true
L["Alert when buff reaches number of stacks (0 = autodetect)."] = true
L["Ding"] = true
L["Dong"] = true
L["Dodo"] = true
L["Bell"] = true
L["None"] = true
		
L["Display"] = true
L["Settings for how to display the message."] = true
L["Color"] = true
L["Sets the color of the text when displaying messages."] = true
L["Scroll output"] = true
L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"] = true
L["Frames output"] = true
L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"] = true
L["Time to display message"] = true
L["Set the time the message will be displayed (5=default)"] = true
						
L["Spells"] = true
L["Settings regarding different spells."] = true
L["Raid"] = true
L["Party"] = true
L["Battleground"] = true
L["Raid Warning"] = true
L["Interrupt"] = true
L["Toggle message when Grounding Totem absorbs a spell."] = true
L["Ground self only"] = true
L["Only show grounding message for your own Grounding Totem"] = true
L["Add target"] = true
L["Add the target to the end of the message when broadcasting."] = true
L["Yell"] = true
L["Say"] = true
L["Dispel"] = true
L["Toggle message when dispel is cast."] = true
		
L["General"] = true
L["General Display settings and options for the Custom Message Frame."] = true
L["In Chat"] = true
L["Display message in Chat Frame."] = true
L["Chat number"] = true
L["Choose which chat to display the messages in (0=default)."] = true
L["On Screen"] = true
L["Display message in Blizzard UI Error Frame."] = true
L["Custom Frame"] = true
L["Display message in Custom Message Frame."] = true
L["Font Size"] = true
L["Set the font size in the Custom Message Frame."] = true
L["Font Face"] = true
L["Set the font face in the Custom Message Frame."] = true
L["Font Effect"] = true
L["Set the font effect in the Custom Message Frame."] = true
L["OUTLINE"] = true
L["THICKOUTLINE"] = true
L["MONOCHROME"] = true
L["Lock"] = true
L["Toggle locking of the Custom Message Frame."] = true
L["BG Announce"] = true
L["Announce when in battlegrounds."] = true
L["Arena Announce"] = true
L["Announce when in arena."] = true
L["5-man Announce"] = true
L["Announce when in a 5-man instance."] = true
L["Raid Announce"] = true
L["Announce when in a raid instance."] = true
L["World Announce"] = true
L["Announce when not in instances."] = true

L["Sound Channel"] = true
L["Channel to play sounds"] = true
L["Effects"] = true
L["Music"] = true
L["Ambience"] = true
L["Master"] = true

L["Settings for Windfury counter."] = true
L["Enable"] = true
L["Enable WF hit counter."] = true
L["Crit"] = true
L["Enable display of WF crits."] = true
L["Miss"] = true
L["Enable display of WF misses."] = true
L["Hand"] = true
L["Show which hand the proc comes from"] = true
L["Show Lava Lash damage"] = true

L["Elemental Overload"] = true
L["Settings for Elemental Overload."] = true
L["Toggle whether to show a message when Elemental Overload procs."] = true
L["Use alternative method"] = true
L["Uses an alternative method to detect LO procs. (Works better in raids, but can be delayed, and damage will probably break)"] = true
L["Damage"] = true
L["Enable display of Elemental Overload total damage."] = true
L["Enable display of Elemental Overload misses."] = true
L["Enable display of Elemental Overload crits."] = true
L["No Lightning Capacitator"] = true
L["Attempt to remove procs coming from the Lightning Capacitator trinket. (Does not always work, and can cause the damage from dual procs to be a bit off)"] = true

L["Settings for Earth Shield."] = true
L["Toggle Earth Shield tracker"] = true
L["Lock tracker"] = true
L["Lock Earth Shield tracker."] = true
L["Disable tooltip"] = true
L["Disable Earth Shield tracker tooltip."] = true
L["Button only"] = true
L["Show only the Earth Shield button."] = true
L["Change the color of the background."] = true
L["Flash"] = true
L["Flash frame when expired."] = true
L["Alert when fading"] = true
L["Alert me when Earth Shield fades from my target."] = true
L["Play a sound when Earth Shield fades from my target."] = true
L["Reset Position"] = true

L["CC"] = true
L["Settings for Crowd Control."] = true
L["Success"] = true
L["Display when successfully CCing a target."] = true
L["Success text"] = true
L["TARGET = CC target"] = true
L["The text in the message when CC succeeds."] = true
L["Fail"] = true
L["Display when CCing a target fails."] = true
L["Fail text"] = true
L["The text in the message when CC fails."] = true
L["Remove"] = true
L["Display when CC is removed from a target."] = true
L["Remove text"] = true
L["The text in the message when CC is removed."] = true
L["Broken CC"] = true
L["Display when CC is broken."] = true
L["The text in the message when CC is broken."] = true
L["Tank break time"] = true
L["Do not warn if the tank breaks CC after this time"] = true
L["Play a sound when CC fades from my target."] = true
L["SOURCE = Source of break, TARGET = CC target"] = true
L[" faded from "] = true
L[" broke SPELL on "] = true

-- L["Totems"] = true
-- L["Settings for Totems."] = true
-- L["Warn on kill"] = true
-- L["Shows a message whenether one of your totems are killed."] = true
-- L["Broadcast on kill"] = true
-- L["Broadcast to the following chat when one of your totems are killed. (Above option must be enabled)"] = true

L["Miscellaneous"] = true
L["Various other small notices/usefull functions."] = true
L["Elemental T5 2-piece bonus"] = true
L["Show a message when you get the proc from the Elemental Tier5 2-piece bonus"] = true
L["Enhancement T5 2-piece bonus"] = true
L["Show a message when you get the proc from the Enhancement Tier5 2-piece bonus"] = true
L["Restoration T5 4-piece bonus"] = true
L["Show a message when you get the proc from the Restoration Tier5 4-piece bonus"] = true

-- More
L[" faded"] = true
L["Your Earth Shield faded from %s"] = true

L["Interrupted: %s"] = true
L["Killed: "] = true

-- LO
L["%s Overload"] = true
L["DOUBLE Lightning Overload"] = true
L["DOUBLE Chain Lightning Overload"] = true
L["TRIPLE Chain Lightning Overload"] = true
L[" CRIT"] = true
L[" DOUBLE CRIT"] = true
L["Electrical Charge"] = true

-- WF
L["MH Windfury"] = true
L["OH Windfury"] = true
L[" Single crit: "] = true
L[" DOUBLE crit: "] = true
L[" TRIPLE crit: "] = true
L[" QUADRUPLE crit: "] = true
L[" QUINTUPLE crit: "] = true
L[" miss"] = true
L[" proc kill"] = true

-- Purge
L["Purge: "] = true
L["Dispel: "] = true

-- Grounding Totem
L["Ground: " ] = true

-- Cooldowns
--L["Elemental Mastery"] = true
--L["Spirit Link Totem"] = true
--L["Bloodlust"] = true
--L["Windfury"] = true
--L["Nature's Swiftness"] = true
--L["Reincarnation"] = true
--L["Chain Lightning"] = true
--L["Shocks"] = true
--L["Fire Elemental Totem"] = true
--L["Earth Elemental Totem"] = true
--L["Grounding Totem"] = true
--L["Eartbind Totem"] = true
--L["Stoneclaw Totem"] = true
--L["Fire Nova Totem"] = true
--L["Astral Recall"] = true
--L["Healthstone"] = true
--L["Potions"] = true
--L["Stormstrike"] = true

-- Missing
L["Missing: Elemental Shield"] = true
L["Missing: Earth Shield"] = true

-- T5 2-piece set bonus
L["Gained set bonus"] = true

-- Earth Shield frame
L["Charges: "] = true
L["Target: "] = true
L["Time: "] = true
L["Outside group"] = true
L[" min"] = true
L["Shaman Friend ES Tracker"] = true
L["Earth Shield faded from "] = true
L["Killed: "] = true

-- Font Face
-- Default font
L["Friz Quadrata TT"] = true

