local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("FollowerGearOptimizer", "zhCN")
if not L then return end
L["|cff00ff00Optimized Item Level:|r |cff00ffff%d|r"] = "|cff00ff00优化后：|r |cff00ffff%d|r"
--[[Translation missing --]]
--[[ L["Ignore Combat Ally Followers"] = ""--]] 
L["Ignore Inactive Followers"] = "忽略未激活的随从"
--[[Translation missing --]]
--[[ L["Item Level"] = ""--]] 
L["Optimize"] = "优化"
--[[Translation missing --]]
--[[ L["Order Hall Follower Gear Optimizer"] = ""--]] 
L["Set items ignore applied enhancements"] = "优化时忽略套装物品。"
L["Total Count: %d"] = "合计：%d"
L["Upgrade follower only if they meet target item level"] = "仅在追随者满足目标装等时提升"
L["You have no follower upgrade items in your bags."] = "缺少升级物品。"
L["You have no followers eligible to be upgraded."] = "没有符合升级条件的追随者。"
--[[Translation missing --]]
--[[ L["You have no suitable follower upgrade items in your bags."] = ""--]] 

