local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "zhCN")
if not L then return end
-- TOC Note: "检测并提醒您附近有敌方玩家。"
 
-- Addon information
L["Spy"] = "Spy 侦测敌方玩家"
L["Version"] = "版本"
--L["LoadDescription"] = "|cff9933ffSpy addon loaded. Type |cffffffff/spy|cff9933ff for options."
L["SpyEnabled"] = "|cff9933ffSpy 侦测敌方玩家插件已启动。"
L["SpyDisabled"] = "|cff9933ffSpy 侦测敌方玩家插件已关闭。 输入 |cffffffff/spy enable|cff9933ff 启动插件。"
L["UpgradeAvailable"] = "|cff9933ff新版Spy 侦测敌方玩家 已有新的版本。 可以从这里下载新版本：\n|cffffffffhttps://www.curseforge.com/wow/addons/spy"
 
-- Configuration frame name
L["Spy Option"] = "Spy 侦测敌方玩家"
 
-- Configuration strings
L["Profiles"] = "Profiles 配置文件"
 
L["GeneralSettings"] = "一般配置"
L["SpyDescription1"] = [[
Spy 侦测敌方玩家 插件可以提醒您附近有敌对玩家出现。
]]
L["SpyDescription2"] = [[
 
|cffffd000附近列表|cffffffff
附近列表会显示已经被侦测到的任何敌方玩家。 在非战斗状态下，点击列表姓名可快速选定目标。 如果在一定时间内未再次侦测到的玩家会被从列表中移除。
 
标题栏中的清除按钮可以立即清空附近列表，按住Ctrl来清空列表时可同时快速启动或暂停Spy插件。
 
|cffffd000近一小时内清单|cffffffff
显示最近1小时内出现的所有敌方玩家。
 
|cffffd000忽略列表|cffffffff
被加入忽略列表的敌对玩家将不会在列表中显示。你可以通过鼠标右键菜单或按住Ctrl点击从列表中添加或删除敌对玩家。
 
|cffffd000KOS即视击杀列表|cffffffff
在该列表中的敌对玩家一旦被侦测会出警报。您可以通过鼠标右键菜单或按住Shift点击从列表中添加或删除敌对玩家。
 
右键菜单也可以添加将某人加入此列表的原因。如果你希望添加不在列表中的说明，可以通过其他列表“自行输入原因...”。
 
 
|cffffd000作者: Slipjack|cffffffff
 
]]
L["EnableSpy"] = "开启Spy"
L["EnableSpyDescription"] = "现在和登陆时启用或禁用Spy。"
L["EnabledInBattlegrounds"] = "战场中启用Spy"
L["EnabledInBattlegroundsDescription"] = "在战场中启用或禁用Spy。"
L["EnabledInArenas"] = "竞技场中启用Spy"
L["EnabledInArenasDescription"] = "在竞技场中启用或禁用Spy。"
L["EnabledInWintergrasp"] = "世界战斗区域中启用Spy"
L["EnabledInWintergraspDescription"] = "在世界战斗区域中启用或禁用Spy，例如诺森德的冬握湖。"
L["DisableWhenPVPUnflagged"] = "非PVP状态时禁用Spy"
L["DisableWhenPVPUnflaggedDescription"] = "根据PVP状态启用或禁用Spy。"
 
L["DisplayOptions"] = "显示"
L["DisplayOptionsDescription"] = [[
自动显示或隐藏Spy。
]]
L["ShowOnDetection"] = "侦测到敌对玩家时显示Spy"
L["ShowOnDetectionDescription"] = "当侦测到敌对玩家时，自动显示隐藏的Spy菜单和附近列表。"
L["HideSpy"] = "未侦测到敌对玩家时隐藏"
L["HideSpyDescription"] = "当附近列表为空列表时隐藏Spy，手动清空列表不会隐藏Spy。"
L["ShowOnlyPvPFlagged"] = "只显示PVP状态的敌对玩家"
L["ShowOnlyPvPFlaggedDescription"] = "在附近列表中只显示PVP状态的敌对玩家。"
L["ShowKoSButton"] = "在敌对玩家头像上显示KOS按钮"
L["ShowKoSButtonDescription"] = "设置敌对玩家头像上显示KOS按钮。"
L["LockSpy"] = "锁定Spy窗口"
L["LockSpyDescription"] = "锁定Spy窗口无法移动。"
L["InvertSpy"] = "翻转Spy窗口"
L["InvertSpyDescription"] = "上下翻转Spy窗口。"
L["Reload"] = "重新载入"
L["ReloadDescription"] = "调整Spy窗口大小后需重新载入。"
L["ResizeSpy"] = "自动调整Spy窗口大小"
L["ResizeSpyDescription"] = "新增或删除敌对玩家时自动调整窗口大小。"
L["ResizeSpyLimit"] = "列表限制"
L["ResizeSpyLimitDescription"] = "限制窗口中显示的敌对玩家数量。"
L["TooltipDisplayWinLoss"] = "鼠标提示中显示胜率统计"
L["TooltipDisplayWinLossDescription"] = "设置鼠标提示中显示胜率统计。"
L["TooltipDisplayKOSReason"] = "在鼠标提示中显示KOS原因"
L["TooltipDisplayKOSReasonDescription"] = "设置在鼠标提示中显示KOS原因。"
L["TooltipDisplayLastSeen"] = "在鼠标提示中显示上次遇到的详情"
L["TooltipDisplayLastSeenDescription"] = "设置在鼠标提示中显示上次遇到的详情。"
L["SelectFont"] = "选择字体"
L["SelectFontDescription"] = "为Spy选择字体。"
L["RowHeight"] = "选择列高"
L["RowHeightDescription"] = "为Spy设置列高度。"
 
L["AlertOptions"] = "警告设置"
L["AlertOptionsDescription"] = [[
您可以在遭遇敌对玩家时发送详细情况到聊天频道，同时设置如何发送警告信息。
]]
L["Announce"] = "通报到:"
L["None"] = "无"
L["NoneDescription"] = "侦测到敌对玩家时不通报。"
L["Self"] = "自己"
L["SelfDescription"] = "侦测到敌对玩家时通报给自己。"
L["Party"] = "队伍"
L["PartyDescription"] = "侦测到敌对玩家时通报到队伍频道。"
L["Guild"] = "公会"
L["GuildDescription"] = "侦测到敌对玩家时通报到公会频道。"
L["Raid"] = "团队"
L["RaidDescription"] = "侦测到敌对玩家时通报到团队频道。"
L["LocalDefense"] = "本地防务"
L["LocalDefenseDescription"] = "侦测到敌对玩家时通报到本地防务频道。"
L["OnlyAnnounceKoS"] = "只通报在KOS列表中的敌对玩家"
L["OnlyAnnounceKoSDescription"] = "设置只通报在KOS列表中的敌对玩家。"
L["WarnOnStealth"] = "潜行侦测警告"
L["WarnOnStealthDescription"] = "设置敌对玩家潜行侦测警告。"
L["WarnOnKOS"] = "KOS列表玩家侦测警告"
L["WarnOnKOSDescription"] = "设置KOS列表玩家侦测警告"
L["WarnOnKOSGuild"] = "KOS公家侦测警告"
L["WarnOnKOSGuildDescription"] = "设置侦测与KOS列表中的玩家在同一公会时警告。"
L["WarnOnRace"] = "种家侦测警告"
L["WarnOnRaceDescription"] = "设置侦测到设定种族时警告。"
L["SelectWarnRace"] = "选家侦测的种族"
L["SelectWarnRaceDescription"] = "选择特定种族发出警告。"
L["WarnRaceNote"] = "提示：您必须选择过该敌对玩家至少一次该种族信息才会被添加，在下次侦测时才会发出警告。与侦测附近敌对玩家一样，在战斗中无法进行设置。"
L["DisplayWarningsInErrorsFrame"] = "以错误信息提示显示警告"
L["DisplayWarningsInErrorsFrameDescription"] = "设置错误信息提示来取代图形化弹出窗口。"
L["EnableSound"] = "启用声音警告"
L["EnableSoundDescription"] = "设置当检测到敌对玩家时声音警告。 潜行或者KOS列表中的敌对玩家会有不同的声音提示。"
L["OnlySoundKoS"] = "仅开启KOS列表中敌对玩家的声音警告"
L["OnlySoundKoSDescription"] = "设置仅开启KOS列表中敌对玩家的声音警告。"
 
L["ListOptions"] = "附近列表选项"
L["ListOptionsDescription"] = [[
您可以设置Spy如何从附近列表中添加或删除敌对玩家。
]]
L["RemoveUndetected"] = "多久后删除附近列表中的敌对玩家："
L["1Min"] = "1 分钟"
L["1MinDescription"] = "删除1分钟内未被检测的敌对玩家。"
L["2Min"] = "2 分钟"
L["2MinDescription"] = "删除2分钟内未被检测的敌对玩家。"
L["5Min"] = "5 分钟"
L["5MinDescription"] = "删除5分钟内未被检测的敌对玩家。"
L["10Min"] = "10 分钟"
L["10MinDescription"] = "删除10分钟内未被检测的敌对玩家。"
L["15Min"] = "15 分钟"
L["15MinDescription"] = "删除15分钟内未被检测的敌对玩家。"
L["Never"] = "永不删除"
L["NeverDescription"] = "永不删除敌对玩家。但附近列表仍然可以被手动清除。"
L["ShowNearbyList"] = "遭遇敌对玩家时自动切换至附近列表。"
L["ShowNearbyListDescription"] = "设置侦测到敌对玩家时显示附近列表，如果原本没有显示。"
L["PrioritiseKoS"] = "在附近列表中优先显示KOS列表中的敌对玩家"
L["PrioritiseKoSDescription"] = "设置总在附近列表中优先显示KOS列表中的敌对玩家。"
 
L["MinimapOptions"] = "小地图选项"
L["MinimapOptionsDescription"] = [[
给能够追踪人型生物的玩家提供额外的功能。
]]
L["MinimapTracking"] = "启用小地图追踪"
L["MinimapTrackingDescription"] = "设置启用小地图中对敌对玩家的追踪和侦测. 在小地图中检测的已知敌对玩家添加到附近列表。"
L["MinimapDetails"] = "在鼠标提示中显示等级/职业信息"
L["MinimapDetailsDescription"] = "设置更新小地图的提示信息，显示敌对玩家名字时显示等级/职业信息。"
L["DisplayOnMap"] = "在地图上显示敌人位置信息"
L["DisplayOnMapDescription"] = "设置在世界地图和小地图上显示由公会、队伍或团队其他Spy玩家侦测到的敌对玩家位置信息。"
L["SwitchToZone"] = "侦测到敌对玩家时切换到当前区域地图"
L["SwitchToZoneDescription"] = "当侦测到敌对玩家且世界地图打开时，将自动切换至玩家当前区域地图。"
L["MapDisplayLimit"] = "限制地图标记显示:"
L["LimitNone"] = "任何地方"
L["LimitNoneDescription"] = "无视自己当前位置，在地图上显示所有侦测到的敌对玩家。"
L["LimitSameZone"] = "相同区域"
L["LimitSameZoneDescription"] = "只显示和自己在相同区域中的侦测到的敌对玩家。"
L["LimitSameContinent"] = "相同大陆"
L["LimitSameContinentDescription"] = "只显示和自己在相同大陆中的侦测到的敌对玩家。"
 
L["DataOptions"] = "数据管理选项"
L["DataOptionsDescription"] = [[
您可以设置Spy如何收集和维护数据。
]]
L["PurgeData"] = "多久后删除未被侦测的敌对玩家信息:"
L["OneDay"] = "1 天"
L["OneDayDescription"] = "删除超过1天未被侦测的敌对玩家信息。"
L["FiveDays"] = "5 天"
L["FiveDaysDescription"] = "删除超过5天未被侦测的敌对玩家信息。"
L["TenDays"] = "10 天"
L["TenDaysDescription"] = "删除超过10天未被侦测的敌对玩家信息。"
L["ThirtyDays"] = "30 天"
L["ThirtyDaysDescription"] = "删除超过30天未被侦测的敌对玩家信息。"
L["SixtyDays"] = "60 天"
L["SixtyDaysDescription"] = "删除超过60天未被侦测的敌对玩家信息。"
L["NinetyDays"] = "90 天"
L["NinetyDaysDescription"] = "删除超过90天未被侦测的敌对玩家信息。"
L["PurgeKoS"] = "同时删除KOS列表中敌对玩家信息。"
L["PurgeKoSDescription"] = "设置相同时间未被侦测时，删除KOS列表中的敌对玩家。"
L["PurgeWinLossData"] = "同时删除胜率统计数据"
L["PurgeWinLossDataDescription"] = "设置相同时间未被侦测时，删除胜率统计数据。"
L["ShareData"] = "与其他Spy用户分享数据"
L["ShareDataDescription"] = "设置与队伍、团队或公会中的其他Spy用户分享数据。"
L["UseData"] = "使用其他Spy用户的数据"
L["UseDataDescription"] = [[使用队伍、团队或公会中的其他Spy用户的数据。
 
如果列表还有空间，其他Spy用户侦测到的敌对玩家信息也会添加进您的附近列表中。
]]
L["ShareKOSBetweenCharacters"] = "在您的角色中共享KOS敌对玩家列表"
L["ShareKOSBetweenCharactersDescription"] = "设置在相同服务器和阵营的角色共享KOS敌对玩家列表。"
 
L["SlashCommand"] = "聊天窗口命令"
L["SpySlashDescription"] = "这些按钮会执行在聊天窗口中输入/spy 命令一样的功能。"
L["Enable"] = "启用"
L["EnableDescription"] = "启用Spy并显示窗口。"
L["Show"] = "显示"
L["ShowDescription"] = "显示Spy主窗口"
L["Reset"] = "重置"
L["ResetDescription"] = "恢复Spy窗口和外观默认设置"
L["ClearSlash"] = "清除"
L["ClearSlashDescription"] = "删除被侦测敌对玩家的列表"
L["Config"] = "配置"
L["ConfigDescription"] = "打开Spy窗口的配置菜单"
L["KOS"] = "KOS即视击杀"
L["KOSDescription"] = "从KOS敌对玩家列表中添加或删除敌对玩家"
L["InvalidInput"] = "输入错误"
L["Ignore"] = "忽略"
L["IgnoreDescription"] = "从忽略列表中添加或删除敌对玩家"
 
-- Lists
L["Nearby"] = "附近"
L["LastHour"] = "最近"
L["Ignore"] = "忽略"
L["KillOnSight"] = "KOS即视击杀"
 
--Stats
L["Time"] = "时间"   
L["List"] = "列表"
L["Filter"] = "过滤"
L["Show Only"] = "仅显示"
L["KOS"] = "KOS即视击杀"
L["Won/Lost"] = "胜/负"
L["Reason"] = "原因"   
L["HonorKills"] = "荣誉击杀"
L["PvPDeaths"] = "PvP 死亡"
 
-- Output messages
L["AlertStealthTitle"] = "侦测到潜行敌人！"
L["AlertKOSTitle"] = "侦测到KOS敌对玩家！"
L["AlertKOSGuildTitle"] = "侦测到KOS敌对公会！"
L["AlertTitle_kosaway"] = "KOS敌对玩家被发现，由 "
L["AlertTitle_kosguildaway"] = "KOS敌对工会被发现，由 "
L["StealthWarning"] = "|cff9933ff侦测到潜行敌人：|cffffffff"
L["KOSWarning"] = "|cffff0000侦测到KOS敌对玩家：|cffffffff"
L["KOSGuildWarning"] = "|cffff0000侦测到KOS敌对公会：|cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "侦测到敌对玩家：|cffffffff"
L["PlayersDetectedColored"] = "侦测到敌对玩家：|cffffffff"
L["KillOnSightDetectedColored"] = "侦测到KOS敌对玩家：|cffffffff"
L["PlayerAddedToIgnoreColored"] = "添加玩家到忽略列表：|cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "从忽略列表中删除玩家：|cffffffff"
L["PlayerAddedToKOSColored"] = "添加玩家到KOS列表：|cffffffff"
L["PlayerRemovedFromKOSColored"] = "从KOS列表中删除玩家：|cffffffff"
L["PlayerDetected"] = "[Spy] 侦测到的玩家："
L["KillOnSightDetected"] = "[Spy] 侦测到的KOS敌对玩家："
L["Level"] = "等级"
L["LastSeen"] = "上次遇到"
L["LessThanOneMinuteAgo"] = "1分钟前"
L["MinutesAgo"] = "分钟前"
L["HoursAgo"] = "小时前"
L["DaysAgo"] = "天前"
L["Close"] = "关闭"
L["CloseDescription"] = "|cffffffff隐藏Spy窗口。默认在下次侦测到敌对玩家时显示。"
L["Left/Right"] = "左/右"
L["Left/RightDescription"] = "|cffffffff在附近，最近，忽略和KOS列表切换。"
L["Clear"] = "清除"
L["ClearDescription"] = "|cffffffff清楚已就侦测敌对玩家列表。显示时按住Ctrl点击可以启用或禁用Spy。"
L["NearbyCount"] = "附近数量统计"
L["NearbyCountDescription"] = "|cffffffff统计附近敌对玩家数量。"
L["Statistics"] = "数据统计"
L["StatsDescription"] = "|cffffffff显示遇到过的敌对玩家，胜/负记录以及上次遇到的位置。"
L["AddToIgnoreList"] = "添加到忽略列表"
L["AddToKOSList"] = "添加到KOS列表"
L["RemoveFromIgnoreList"] = "从忽略列表中删除"
L["RemoveFromKOSList"] = "从KOS列表中删除"
L["RemoveFromStatsList"] = "从数据统计列表中删除"   --++
L["AnnounceDropDownMenu"] = "通报"
L["KOSReasonDropDownMenu"] = "设置KOS原因"
L["PartyDropDownMenu"] = "队伍"
L["RaidDropDownMenu"] = "团队"
L["GuildDropDownMenu"] = "公会"
L["LocalDefenseDropDownMenu"] = "本地防务"
L["Player"] = " （玩家）"
L["KOSReason"] = "KOS即视击杀"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "自行输入原因..."
L["KOSReasonClear"] = "清除"
L["StatsWins"] = "|cff40ff00获胜："
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070dd失败："
L["Located"] = "位置："
L["Yards"] = "码"
 
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
    [1] = {
        ["title"] = "战斗起因";
        ["content"] = {
            "毫无理由攻击我",
            "接任务时攻击我",
            "和NPC战斗时攻击我",
            "副本门口攻击我",
            "暂离时攻击我",
            "在我骑马或者飞行时攻击我",
            "在我低血量或低魔法时攻击我",
        };
    },
    [2] = {
        ["title"] = "战斗方式";
        ["content"] = {
            "偷袭我",
            "见我就打",
            "用高等级人物杀我",
            "一群人蹂躏我",
            "没人支援就不打我",
            "总叫人帮忙",
            "频繁使用控场技能",
        };
    },
    [3] = {
        ["title"] = "守尸";
        ["content"] = {
            "守我尸体",
            "小号守我",
            "守低等级玩家",
            "潜行守尸",
            "工会成员一起守",
            "守游戏NPC或者任务点和怪",
            "在城市或者一片区域守",
        };
    },
    [4] = {
        ["title"] = "阻碍任务";
        ["content"] = {
            "做任务的时候攻击我",
            "帮忙做任务后攻击我",
            "破坏任务物品和npc",
            "抢我的任务",
            "杀我方阵营npc",
            "杀任务npv",
        };
    },
    [5] = {
        ["title"] = "偷抢资源";
        ["content"] = {
            "抢我草药",
            "抢我矿",
            "抢我资源",
            "杀我然后抢我的东西/稀有怪",
            "抢我的剥皮",
            "偷我的怪",
            "抢我的钓鱼点",
        };
    },
    [6] = {
        ["title"] = "其他";
        ["content"] = {
            "就是喜欢pvp",
            "把我推下悬崖",
            "用工程物品",
            "总是逃跑",
            "使用物品或技能逃跑",
            "乱用游戏bug",
            "自行输入原因...",
        };
    },
}
 
StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
    preferredIndex=STATICPOPUPS_NUMDIALOGS,  -- http://forums.wowace.com/showthread.php?p=320956
    text = "输入 %s 的KOS原因:",
    button1 = "设置",
    button2 = "取消",
    timeout = 120,
    hasEditBox = 1,
    editBoxWidth = 260,
    whileDead = 1,
    hideOnEscape = 1,
    OnShow = function(self)
        self.editBox:SetText("");
    end,
        OnAccept = function(self)
        local reason = self.editBox:GetText()
        Spy:SetKOSReason(self.playerName, "自行输入原因...", reason)
    end,
    };

--++ Class descriptions
L["DEATHKNIGHT"] = "死亡騎士"
L["DEMONHUNTER"] = "惡魔獵人"
L["DRUID"] = "德魯伊"
L["HUNTER"] = "獵人"
L["MAGE"] = "法師"
L["MONK"] = "武僧"
L["PALADIN"] = "聖騎士"
L["PRIEST"] = "牧師"
L["ROGUE"] = "盜賊"
L["SHAMAN"] = "薩滿"
L["WARLOCK"] = "術士"
L["WARRIOR"] = "戰士"
L["UNKNOWN"] = "未知"

--++ Race descriptions
L["HUMAN"] = "人类"
L["ORC"] = "兽人"
L["DWARF"] = "矮人"
L["NIGHT ELF"] = "暗夜精灵"
L["UNDEAD"] = "亡灵"
L["TAUREN"] = "牛头人"
L["GNOME"] = "侏儒"
L["TROLL"] = "巨魔"
L["GOBLIN"] = "地精"
L["BLOOD ELF"] = "血精灵"
L["DRAENEI"] = "德莱尼"
L["WORGEN"] = "狼人"
L["PANDAREN"] = "熊猫人"
L["NIGHTBORNE"] = "夜之子"
L["HIGHMOUNTAIN TAUREN"] = "至高岭牛头人"
L["VOID ELF"] = "虚空精灵"
L["LIGHTFORGED DRAENEI"] = "光铸德莱尼"
L["ZANDALARI TROLL"] = "赞达拉巨魔"
L["KUL TIRAN"] = "库尔提拉斯人"
L["DARK IRON DWARF"] = "黑铁矮人"
L["MAG'HAR ORC"] = "玛格汉兽人"

--++ Font descriptions
L["2002"] = "2002"
L["2002 BOLD"] = "2002 Bold"
L["ARIAL NARROW"] = "Arial Narrow" -- default chat font
L["AR ZhongkaiGBK Medium"] = "AR ZhongkaiGBK Medium"
L["BIG NOODLE TITLING"] = "Big Noodle Titling"
L["FRIZ QUADRATA TT"] = "Friz Quadrata TT" -- default main UI font
L["FRIZQUADRATACTT"] = "Friz Quadrata CTT"
L["MOK"] = "MoK"
L["MORPHEUS"] = "Morpheus" -- default in game mail font
L["NIMROD MT"] = "Nimrod MT"
L["SKURRI"] = "Skurri" -- default unit frame combat font
						
-- Stealth abilities
L["Stealth"] = "隱形"
L["Prowl"] = "潛行"

-- Channel names
L["LocalDefenseChannelName"] = "本地防務"

--++ Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDEMONHUNTER"] = "|cffa330c9"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

Spy_IgnoreList = {
	["邮箱"]=true, ["Shred Master Mk1"]=true, ["Scrap-O-Matic 1000"]=true,
	["前往暴风城的船"]=true, ["前往伯拉勒斯港（提拉加德海峡）的船"]=true,
	["Treasure Chest"]=true, ["Small Treasure Chest"]=true,
	["阿昆达之噬"]=true, ["锚草"]=true, ["流波花苞"]=true,    
	["海潮茎杆"]=true, ["海妖花粉"]=true, ["星光苔"]=true,   
	["凛冬之吻"]=true, ["战争指挥部（PvP）"]=true,
	["联盟刺客"]=true, ["部落刺客"]=true,
	["秘法师鸟羽帽"]=true, ["表弟慢热手"]=true,	
	["联盟的艾泽里特"]=true, ["部落的艾泽里特"]=true,	
};
