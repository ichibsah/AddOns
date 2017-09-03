local ignore_missing = true
--[===[@debug@
ignore_missing = false
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("DruidFriend", "enUS", true, ignore_missing)
if not L then return end

----------------------------------------
-- These are required for functionality
----------------------------------------

-- Font Face
-- Default font for language
L["Friz Quadrata TT"] = true

-------------------------------------------
-- These are not required for functionality
-------------------------------------------

L["Options for DruidFriend"] = true
L["This addon provides tools for Druids."] = true

L["Show UI"] = true
L["Shows the Graphical User Interface"] = true

L["Show version"] = true
L["Perform checks"] = true

L["DruidFriend Display"] = true
L[" Loaded. Use /df for options."] = true

L["General"] = true
L["General settings and options for the Custom Message Frame."] = true
L["Chat Window Options"] = true
L["Chat Message"] = true
L["Display message in Chat Frame."] = true
L["Chat number"] = true
L["Choose which chat to display the messages in (0=default)."] = true
L["Message Frame"] = true
L["Display message in Custom Message Frame."] = true
L["Lock"] = true
L["Reset Position"] = true
L["Toggle locking of the Custom Message Frame."] = true
L["Font Size"] = true
L["Set the font size in the Custom Message Frame."] = true
L["Font Face"] = true
L["Set the font face in the Custom Message Frame."] = true
L["Font Effect"] = true
L["Set the font effect in the Custom Message Frame."] = true

L["None"] = true
L["OUTLINE"] = true
L["THICKOUTLINE"] = true
L["MONOCHROME"] = true

L["Sound Channel"] = true
L["Channel to play sounds"] = true

L["Effects"] = true
L["Music"] = true
L["Ambience"] = true
L["Master"] = true

L["Battleground"] = true
L["Raid"] = true
L["Raid Warning"] = true
L["Party"] = true
L["Yell"] = true
L["Say"] = true

L["Buff"] = true
L["Alerts for buff."] = true
L["Enable checking buffs."] = true

L["Enable"] = true

L["When to check"] = true
L["Ready Check"] = true
L["Notify on ready check."] = true
L["Enter Combat"] = true
L["Notify when entering combat."] = true
L["After Combat"] = true
L["Notify after the end of combat."] = true

L["Disable checks"] = true
L["No Mounted"] = true
L["Disable notifications when mounted."] = true
L["No Vehicle"] = true
L["Disable notifications when in a vehicle."] = true
L["No Combat"] = true
L["Disable notifications when in combat."] = true
L["No PvP"] = true
L["Disable notifications when PvP flagged."] = true

L["Location"] = true
L["Battleground"] = true
L["Warn when in battlegrounds."] = true
L["Arena"] = true
L["Warn when in arena."] = true
L["PvP Zone"] = true
L["Warn when in Tol Barad/Wintergrasp."] = true
L["5-man"] = true
L["Warn when in a 5-man instance."] = true
L["Raid"] = true
L["Warn when in a raid instance."] = true
L["Other"] = true
L["Warn when not in an instance, arena, or battleground."] = true

L["Other Options"] = true
L["Frequency"] = true
L["Do not warn more often than (5=default)"] = true
L["Sound"] = true
L["Play a sound when a buff is missing."] = true
L["Ding"] = true
L["Dong"] = true
L["Dodo"] = true
L["Bell"] = true

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

L[" faded from "] = true
L["Missing "] = true
L["Unknown"] = true

L["Players missing MOTW: "] = true
L["Players out of range: "] = true

L["Announcements"] = true
L["Announce different spells."] = true

L["SPELL = spell cast"] = true
L["SPELL = spell cast, TARGET = target of spell"] = true
L["Whisper"] = true
L["you"] = true

L["Add target"] = true
L["Add the target to the end of the message when announcing."] = true

L["Spells"] = true
L["Spells to announce."] = true

L["Toggle %s information."] = true
L["Toggle %s whisper."] = true
L["Announce %s"] = true
L["%s text"] = true
L["%s announcement text."] = true
L["Announce %s message to the following channel (Above option must be enabled)."] = true

L["Interrupt"] = true

L["Interrupted"] = true

L["Dispel"] = true
L["Toggle message when dispel is cast."] = true
L["Dispel: "] = true

L["Tank"] = true

L["Spec Check"] = true
L["Announce tank cooldowns by spec."] = true
L["Both specs"] = true
L["Only in Feral spec"] = true
L["Only in Guardian spec"] = true
L["Only in primary spec"] = true
L["Only in secondary spec"] = true
L["Disable tank cooldown announcements"] = true

L["Expirations"] = true
L["Savage Defense Expire"] = true
L["Notify on Savage Defense Expire"] = true
L["Frenzied Regeneration Glyph Expire"] = true
L["Notify on Frenzied Regeneration Glyph Expire"] = true
L["expired"] = true

L["Where"] = true
L["Where to display the announcements."] = true
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
L["Fade"] = true
L["Display when CC fades from a target."] = true
L["Fade text"] = true
L["The text in the message when CC fades."] = true
L["CC Channel"] = true
L["Broken CC"] = true
L["Display when CC is broken."] = true
L["The text in the message when CC is broken."] = true
L["Broken CC Channel"] = true
L["Tank break time"] = true
L["Do not warn if the tank breaks CC after this time"] = true
L["Play a sound when CC fades from my target."] = true
L["SOURCE = Source of break, TARGET = CC target"] = true
L[" faded from "] = true
L[" broke SPELL on "] = true

L["Absorb Tracker"] = true
L["Settings for Absorb Tracker."] = true
L["Toggle Absorb tracker"] = true
L["Lock tracker"] = true
L["Lock Absorb tracker."] = true
L["Icon"] = true
L["Show most powerful absorb spell icon."] = true
L["Time"] = true
L["Show remaining time on the current absorb amount."] = true
L["Visible Conditions"] = true
L["Combat Only"] = true
L["Only show in combat?"] = true
L["Absorbs Only"] = true
L["Only show when there are absorbs?"] = true
L["Absorb tracker by spec."] = true

L["Cooldowns"] = true
L["Cooldown Output Information."] = true
L["Display how much healing Tranquility did"] = true
L["Display how much damage Starfall did"] = true
L["Bear Berserk"] = true
L["Display how much damage Mangle(Bear) did during Berserk"] = true
L["Crits"] = true
L["Display how many crits"] = true

L["Taunts"] = true
L["Taunt Tracker"] = true
L["Toggle Taunt tracker"] = true
L["Own"] = true
L["Track own taunts"] = true
L["Other"] = true
L["Track other player's taunts"] = true
L["Play a sound when someone taunts."] = true
L["Pet Taunts"] = true
L["Track pet actual taunts"] = true
L["Pet Aggro"] = true
L["Track pet aggro abilities"] = true
L["Noisy Pet"] = true
L["Notify each time instead of once per combat"] = true

L["%s AoE taunted using %s"] = true
L["%s taunted %s using %s"] = true

