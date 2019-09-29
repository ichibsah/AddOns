-- English localization file for enUS and enGB.
if (OHFGO_DEBUG_ENGLISH_LOADED) then return; end

local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("OrderHallFollowerGearOptimizer", "enUS", true);
if not L then return; end
L["|cff00ff00Optimized Item Level:|r |cff00ffff%d|r"] = true
L["Order Hall Follower Gear Optimizer"] = true
L["Ignore Inactive Followers"] = true
L["Ignore Combat Ally Followers"] = true
L["Optimize"] = true
L["Set items ignore applied enhancements"] = true
L["Total Count: %d"] = true
L["Upgrade follower only if they meet target item level"] = true
L["Item Level"] = true
L["You have no followers eligible to be upgraded."] = true
L["You have no follower upgrade items in your bags."] = true
L["You have no suitable follower upgrade items in your bags."] = true
