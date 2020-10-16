-- Author      : LintyDruid

-- English Localisation

function LFGShout_Locale_English()

	LFGShout.lang.welcome="welcome.";
	LFGShout.lang.menuRecent="Recent shouts:";
	LFGShout.lang.LFGChannelText="LookingForGroup"; --- used in searching chat channels
	
	-----time Conversion
	
	LFGShout.lang.Seconds="s";
	LFGShout.lang.Minutes="m";
	LFGShout.lang.Hours="h";
	LFGShout.lang.Days="d";
	
	----- Whisper
	LFGShout.lang.wispertitle="Whisper %s";
	LFGShout.lang.wisperok="Send";
	LFGShout.lang.wispercancel="Cancel";
	
	----- General
	
	LFGShout.lang.cmd1="LFGSHOUT"
	LFGShout.lang.cmd2="LFGS"
	
	LFGShout.lang.command1="LFGShout";
	LFGShout.lang.command2="No command Line Options Available";
	LFGShout.lang.command3="Please use Broker menu.";
	LFGShout.lang.command4="Sessions Stats:";
	LFGShout.lang.command_stat1="Messages Processed: ";
	LFGShout.lang.command_stat2="Messages Rejected: ";
	LFGShout.lang.command_stat3="Messages Forwarded: ";
	LFGShout.lang.command_stat4="Messages Added: ";
	LFGShout.lang.command_stat5="Forwards Recvd: ";
	LFGShout.lang.command_stat6="Session Time: ";
	------ Achievment Filters
	--LFGShout.lang.AchTypes={"Dungeons & Raids"};
	LFGShout.lang.Achievments={9707, 9708, 9391, 9423,8988, 8987, 8986,8966, 8968, 8932, 8970, 8972, 8949, 8961, 8963, 8965,8967,8956, 8969,8971,8973,8960,8962,8964,9255,9572,9573,9574,9575,9576,9577,9584,9585,9586,9587,9588,9589,9578,9579,9580,9581,9582,9583,};
	----- Filters and blacklists
	--F1-F5 = filter strings
	--Type = 0 = General, 1 =buy, 2 = sell, 3 = dungeon, 4=quest, 5= guild, 9=Coords
	-- lStart - lEnd - level requierements
	-- score == filter score
	-- SingleWord - If not set or true, the strings in the filter will only be matched if they are a single word. complex filters and sentences should be set to false

	
--|cff71D5ff|Hspell:57423|h[Fish Feast]|h|r

--|cffFFCC00|Hitem:43015:0:0:0:0:0:0:0|h[Fish Feast]|h|r
	
	LFGShout.lang.Filters={
				----- Co-ords in Chat
				{F1=".*%d+%p%d+",F2=".*%d+ %d+",F3=".*%d+%p %d+",F4="",F5="", Type=9, lStart=0, lEnd=999, Score=75},
				{F1=".*%d+%.%d+%p%d+",F2=".*%d+%.%d+ %d+",F3=".*%d+%.%d+%p %d+",F4="",F5="", Type=9, lStart=0, lEnd=999, Score=75},
				{F1=".*%d+%p%d+%.%d+",F2=".*%d+ %d+%.%d+",F3=".*%d+%p %d+%.%d+",F4="",F5="", Type=9, lStart=0, lEnd=999, Score=75},
				{F1=".*%d+%.%d%p%d+%.%d+",F2=".*%d+%.%d+ %d+%.%d+",F3=".*%d+%.%d+%p %d+%.%d+",F4="",F5="", Type=9, lStart=0, lEnd=999, Score=75},
				
				---------------------------------------------General-----------------------------------------------
				{F1="LFG",F2="LF%dM",F3="LF%d2%dM",F4="LFM",F5="", Type=3, lStart=0, lEnd=999, Score=75},
				{F1="LOOKING",F2="LF",F3="NEED HELP",F4="HELP",F5="GARRISON", Type=0, lStart=0, lEnd=999, Score=25},
				{F1="HEAL",F2="HEALZ",F3="HEALS",F4="HEALER",F5="RDPS", Type=3, lStart=0, lEnd=999, Score=25},
				{F1="TANK",F2="OT",F3="MT",F4="DPS",F5="MDPS", Type=3, lStart=0, lEnd=999, Score=25},
				{F1="RANDOM",F2="RAMDOMS",F3="",F4="",F5="", Type=3, lStart=0, lEnd=999, Score=25},
				{F1="DAILY",F2="WEEKLY",F3="HEROIC",F4="",F5="", Type=3, lStart=0, lEnd=999, Score=50},
				{F1="|%x+|HACHIEVEMENT:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=3, lStart=0, lEnd=999, Score=25,SingleWord=false},
				{F1="|%x+|HSPELL:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=1, lStart=0, lEnd=999, Score=25, SingleWord=false},
				{F1="|%x+|HENCHANT:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=1, lStart=0, lEnd=999, Score=50,SingleWord=false},
				{F1="|%x+|HTRADE:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=2, lStart=0, lEnd=999, Score=75, SingleWord=false},
				{F1="|%x+|HGLYPH:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=1, lStart=0, lEnd=999, Score=25,SingleWord=false},
				{F1="|%x+|HITEM:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=1, lStart=0, lEnd=999, Score=50,SingleWord=false},
				{F1="SELLING",F2="WTS",F3="SELL",F4="WTT",F5="LFW", Type=2, lStart=0, lEnd=999, Score=75},
				{F1="WTB",F2="WTB",F3="BUY",F4="WTB",F5="", Type=1, lStart=0, lEnd=999, Score=75},
				{F1="|%x+|HQUEST:.-|H.-|H|R",F2="",F3="",F4="",F5="", Type=4, lStart=0, lEnd=999, Score=50,SingleWord=false},
				
				{F1="PORT",F2="PORTAL",F3="",F4="",F5="", Type=0, lStart=0, lEnd=999, Score=50}, -- POrts : tracker 0000066 

				{F1="GUILD",F2="RECRUIT",F3="RECRUITING",F4="",F5="", Type=5, lStart=0, lEnd=999, Score=75},

				------------------------------------------------Classic-----------------------------------------------------
				
				----------Dungeons
				{F1="DEADMINES",F2="VC",F3="DM",F4="",F5="", Type=3, lStart=7, lEnd=50, Score=50},
				{F1="HEROIC DEADMINES",F2="HVC",F3="HDM",F4="H-DM",F5="H-VC", Type=3, lStart=40, lEnd=50, Score=50},
				{F1="SHADOWFANG KEEPS",F2="SFK",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SHADOWFANG KEEPS",F2="HSFK",F3="H-SFK",F4="",F5="", Type=3, lStart=40, lEnd=50, Score=50},
				{F1="STOCKADE",F2="STOCKS",F3="STK",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SCARLET MONASTRY",F2="SM",F3="SM-GY",F4="SM-LIB",F5="SM-ARM", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SM-CATH",F2="SMGY",F3="SMLIB",F4="SMARM",F5="SMCATH", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="ULDAMAN",F2="ULD",F3="ULDA",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="ATAL'HAKkAR",F2="ST",F3="SUNKEN TEMPLE",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="BLACKROCK DEPTHS",F2="BRD",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="LOWER BLACKROCK SPIRE",F2="LBRS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="STRATHOLME",F2="STRATH",F3="STRAT",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SCHOLOMANCE",F2="SCHOLO",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="WAILING CAVERNS",F2="WC",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="BLACKFATHOM",F2="BFD",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="RAZORFEN KRAUL",F2="RFK",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="RAZORFEN DOWNS",F2="RFD",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="ZUL'FARRAK",F2="ZF",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="MARAUDON",F2="MARA",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="DIRE MAUL",F2="DME",F3="DIME",F4="DM",F5="DMW", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="DIMW",F2="DMN",F3="DIMN",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="RAGEFIRE",F2="RFC",F3="",F4="",F5="", Type=3, lStart=7, lEnd=50, Score=50},

				----------Raids

				{F1="ZUL'GRURUB",F2="ZG",F3="ZG%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="MOLTEN CORE",F2="MC",F3="MC%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="BLACKWING",F2="BWL",F3="BWL%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="ZUL'AMAN",F2="ZA",F3="ZA%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="ONYXIA",F2="ONY",F3="ONY%d%d",F4="",F5="", Type=3, lStart=80, lEnd=999, Score=50},
				{F1="AHN'QIRAJ",F2="AQ",F3="AQ20",F4="RAQ",F5="AQ40", Type=3, lStart=60, lEnd=999, Score=50},
				{F1="TAQ",F2="",F3="",F4="",F5="", Type=3, lStart=60, lEnd=999, Score=50},
				

				------------------------------------------------BC-----------------------------------------------------
				
				----------Raids
				{F1="MAGISTERS",F2="MGT",F3="MAG TERRACE",F4="SPLAT-5",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="SUNWELL",F2="SP",F3="SP%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="MOUNT HYJAL",F2="HYJAL",F3="MH",F4="MH%d%d",F5="HYJAL%d%d", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="KARAZHAN",F2="KARA",F3="KZ",F4="KARA%d%d",F5="KX%d%d", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="GRUUL",F2="GRULL%d%d",F3="",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="MAGTHERIDON",F2="MAG",F3="MAG%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="SERPENTSHRINE",F2="SSC",F3="SCC%d%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="THE EYE",F2="TK",F3="EYE",F4="TEMPEST KEEP",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="EYE%d%d",F2="TK%d%d",F3="",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},
				{F1="BLACK TEMPLE",F2="BT",F3="BT%d",F4="",F5="", Type=3, lStart=50, lEnd=999, Score=50},

				----------Dungeons
				{F1="DURNHOLDE",F2="DURN",F3="COT",F4="COT1",F5="OHB", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="DARK PORTAL",F2="BLACK MORASS",F3="COT2",F4="BM",F5="COT-BM", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="CULLING OF",F2="COS",F3="COSTRAT",F4="HCOS",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="RAMPARTS",F2="RAMPS",F3="RAMP",F4="HFR",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="BLOOD FURNACE",F2="BF",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SLAVE PENS",F2="SP",F3="SPENS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="UNDERBOG",F2="UB",F3="BOG",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="MANA TOMBS",F2="TOMBS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="AUCHENAI",F2="AC",F3="CRYPTS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SETHEKK",F2="",F3="SETH",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="STEAM VAULT",F2="SV",F3="VAULTS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SHADOW LABS",F2="SLABS",F3="SL",F4="S-LABS",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="MECHANAR",F2="MECH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="BOTANICA",F2="BOT",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="ARCATRAZ",F2="ARC",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SHATTERED HALLS",F2="SH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=502, Score=50},
				{F1="HRAMPS",F2="HRAMP",F3="HHFR",F4="HBF",F5="HSP", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HUB",F2="HBOG",F3="HMT",F4="HTOMBS",F5="HAC", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HCRYPTS",F2="HSETH",F3="HSV",F4="SVAULTS",F5="HSL", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HSLABS",F2="HS_SLABS",F3="HMECH",F4="HBOT",F5="HARC", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HSH",F2="",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				---------------------------------------------PVP-----------------------------------------------------

				{F1="ARATHI BASIN",F2="AB",F3="AB%d%d",F4="",F5="", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="WARSONG",F2="WSG",F3="WSG%d%d",F4="",F5="", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="ALTERAC",F2="AV",F3="AV%d%d",F4="",F5="", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="EYE OF THE STORM",F2="EOS",F3="EOTS",F4="EOS%d%d",F5="EOTS%d%d", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="STRAND OF THE ANCIENTS",F2="SOTA",F3="SOA",F4="SOTA%d%d",F5="SOA%d%d", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="WINTERGRASP",F2="WG",F3="WG%d%d",F4="",F5="", Type=3, lStart=10, lEnd=999, Score=50},
				{F1="ISLE OF CONQUEST",F2="IOC",F3="IOC%d%d",F4="",F5="", Type=3, lStart=10, lEnd=999, Score=50},
				
				
				---------------------------------------------Wrath-----------------------------------------------------
				----------Raids
				{F1="OBSIDIAN SANCTUM",F2="OS",F3="OS%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="EYE OF ERTERNITY",F2="EOE",F3="MALI",F4="MALIGOS",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="MALIGOS%d%d",F2="EOE%d%d",F3="MALI%d%d",F4="",F5="", Type=3, lStart=50, lEnd=609, Score=50},
				{F1="ARCHAVON",F2="VOA",F3="VOA%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ULDUAR",F2="ULD",F3="ULDU",F4="ULD%d%d",F5="ULD%d%d", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TRIAL OF THE CRUSADER",F2="TOTC",F3="GRAND CRUSADER",F4="TOGC",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TOGC%d%d",F2="TOTC%d%d",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="RUBY SANCTUM",F2="RS",F3="RS%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ICC",F2="ICECROWN CITADEL",F3="ICC%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				----------Dungeons

				{F1="UTGARDE",F2="UK",F3="KEEP",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="NEXUS",F2="NEX",F3="",F4="NXS",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="AZIOL",F2="",F3="NERUB",F4="",F5="HAN", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="AHN'KAHET",F2="AK",F3="KAHET",F4="OK",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HOK",F2="HAK",F3="HUK",F4="HNXS",F5="HNEX", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HAN",F2="HEROIC",F3="HDTK",F4="HVH",F5="HGUN", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HHOS",F2="HUP",F3="HPINN",F4="HOCU",F5="HHOL", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HFOS",F2="HHOR",F3="HTOC",F4="HPOS",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="DRAK'THARON",F2="DTK",F3="DRAK",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="VIOLET HOLD",F2="VH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="GUNDRAK",F2="GUN",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HALLS OF STONE",F2="HOS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HALLS OF LIGHTNING",F2="HOL",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="OCULUS",F2="OCU",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="UPGARDE PINNACLE",F2="PINN",F3="UP",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="TRIAL OF CHAMPION",F2="TOC",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="FORGE OF SOULS",F2="FOS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="PIT OF SARON",F2="POS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="REFLECTION",F2="HOR",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="NAXXRAMAS",F2="NAXX",F3="NAX",F4="NAXX%d%d",F5="NAX%d%d", Type=3, lStart=80, lEnd=999, Score=50},


				---------------------------------------------CAta-----------------------------------------------------
				----------Raids


				----------Dungeons
				{F1="THRONE OF TIDES",F2="TOT",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="BLACKROCK CAVERNS",F2="BC",F3="",F4="",F5="", Type=3, lStart=10, lEnd=502, Score=50},
				{F1="STONECORE",F2="SC",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="VORTEX PINACLE",F2="VP",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="GRIM BATOL",F2="GBD",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HALLS OR ORIGINATION",F2="HOO",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="LOST CITY OF THE TOL'VIR",F2="LCOT",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC THRONE OF TIDES",F2="HTOT",F3="H-TOT",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC BLACKROCK CAVERNS",F2="HBC",F3="H-BC",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC STONECORE",F2="HSC",F3="H-SC",F4="",F5="", Type=3, lStart=10, lEnd=508, Score=50},
				{F1="HEROIC VORTEX PINACLE",F2="HVP",F3="H-VP",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC GRIM BATOL",F2="HGBD",F3="H-GBD",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC HALLS OR ORIGINATION",F2="HHOO",F3="H-HOO",F4="",F5="", Type=3, lStart=10, lEnd=508, Score=50},
				{F1="HEROIC LOST CITY OF THE TOL'VIR",F2="HLCOT",F3="H-LCOT",F4="",F5="", Type=3, lStart=10, lEnd=508, Score=50},
				
				{F1="BASTION OF TWILIGHT",F2="BOT",F3="BOT10",F4="BOT25",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="THRONE OF THE FOUR WINDS",F2="TFW",F3="TFW10",F4="TFW25",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="BLACKWING DESCENT",F2="BD10",F3="BD25",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="FIRELANDS",F2="FL10",F3="FL25",F4="FIRE10",F5="FIRE25", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="WAR OF THE ANCIENTS",F2="WA10",F3="WA25",F4="WOA10",F5="WOA25", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="BARADIN HOLD",F2="BH",F3="BH10",F4="BH25",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				{F1="HEROIC ZUL'GRURUB",F2="HZG",F3="ZG5",F4="H-ZG",F5="", Type=3, lStart=50, lEnd=609, Score=50},
				{F1="HEROIC ZUL'AMAN",F2="HZA",F3="ZA5",F4="H-ZA",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="DRAGON SOUL",F2="DS",F3="DS10",F4="DS25",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				
				---------------------------------------------Pandaria-----------------------------------------------------
	
				----------Dungeons
			
				{F1="HEROIC SCARLET MONASTRY",F2="SMH",F3="HSM",F4="H-SM",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SCARLET HALLS",F2="SHH",F3="HSH",F4="H-SM",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SCHOLOMANCE",F2="HSCHOLO",F3="H-SCHOLO",F4="",F5="", Type=3, lStart=10, lEnd=502, Score=50},
				
				{F1="TEMPLE OF THE JADE SERPENT",F2="TJS",F3="JS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="STORMSOUT BREWERY",F2="BREW",F3="SB",F4="SSB",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="MOGU'SHAN PALACE",F2="MOGU",F3="MSP",F4="MP",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="SHADOW-PAN MONASTRY",F2="SPM",F3="SHADOWPAN",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				
				
				{F1="HEROIC TEMPLE OF THE JADE SERPENT",F2="HTJS",F3="HJS",F4="H-TJS",F5="H-JS", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC STORMSOUT BREWERY",F2="HBREW",F3="HSB",F4="HSSB",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="",F2="H-BREW",F3="H-SB",F4="H-SSB",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC MOGU'SHAN PALACE",F2="HMOGU",F3="HMSP",F4="HMP",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="",F2="H-MOGU",F3="H-MSP",F4="H-MP",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SHADOW-PAN MONASTRY",F2="HSPM",F3="HSHADOWPAN",F4="H-SPM",F5="H-SHADOWPAN", Type=3, lStart=10, lEnd=50, Score=50},
				
				{F1="SIEGE OF NIUZAO TEMPLE",F2="SIEGE OF NIUZAO ",F3="SNT",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SIEGE OF NIUZAO TEMPLE",F2="HEROIC SIEGE OF NIUZAO ",F3="HSNT",F4="H-SNT",F5="", Type=3,lStart=10, lEnd=50, Score=50},
				{F1="GATE OF THE SETTING SUN",F2="GATE",F3="GSS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC GATE OF THE SETTING SUN",F2="HGATE",F3="HGSS",F4="H-GATE",F5="H-GSS", Type=3, lStart=10, lEnd=50, Score=50},
				
				
				-- raids
				{F1="MOGU'SHAN VAULTS",F2="MV",F3="MSV",F4="MVAULTS",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="MOGU'SHAN VAULTS %d%d",F2="MV%d%d",F3="MSV%d%d",F4="MVAULTS%d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TERRACE OF ENDLESS SPRING",F2="TES",F3="TOES",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TERRACE OF ENDLESS SPRING %d%d",F2="TES%d%d",F3="TOES%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},		
				{F1="HEART OF FEAR",F2="HF",F3="HEART",F4="HOF",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="HEART OF FEAR %d%d",F2="HF%d%d",F3="HEART%d%d",F4="HOF%d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="THRONE OF THUNDER",F2="TOT",F3="THUNDER THRONE",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="THRONE OF THUNDER %d%d",F2="HTOT%d%d",F3="TOT%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="SIEGE OF ORGRIMMAR",F2="SOO",F3="ORGRIMMAR",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="SIEGE OF ORGRIMMAR %d%d",F2="SOO%d%d",F3="ORGRIMMAR%d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				-- Scenarios
				{F1="SCENARIO",F2="SCENARIOS",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50}, -- generic
				{F1="THERAMORE'S FALL",F2="TFA",F3="TFH",F4="THERAMORES FALL",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="A BREWING STORM",F2="ABS",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ARENA OF ANNIHILATION",F2="AOA",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="BROOMOON FESTIVAL",F2="BMF",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="CRYPT OF FORGOTTEN KINGS",F2="COFK",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="GREENSTONE VILLAGE",F2="GSV",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="UNGA INGOO",F2="UNGA",F3="",F4="",F5="", Type=3, lStart=50, lEnd=609, Score=50},
				{F1="A LITTLE PATIENCE",F2="ALP",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ASSAULT ON ZAN'VESS",F2="ASSAULT ON ZANVESS",F3="AOZV",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="DAGGER IN THE DARK",F2="DITD",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="DOMINATION POINT",F2="DP",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="LION'S LANDING",F2="LIONS LANDING",F3="LL",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				---------------------------------------------------Draenor------------------------------------------------
				-- Dungeons
				{F1="AUCHINDOUN",F2="AUCH",F3="ADOWN",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="BLOODMAUL SLAG MINES",F2="SLAG",F3="BSM",F4="BLOODMAUL",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="THE EVERBLOOM",F2="EVERBLOOM",F3="EB",F4="BLOOM",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="GRIMRAIL DEPOT",F2="GRIMRAIL",F3="DEPOT",F4="GRD",F5="GD", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="IRON DOCKS",F2="ID",F3="DOCKS",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="SHADOWMOON BURIAL GROUNDS",F2="SBG",F3="BURIAL GROUNDS",F4="SHADOWMOON",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="SKYREACH",F2="SKY",F3="SR",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="UPPER BLACKROCK SPIRE",F2="UBRS",F3="",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				
				{F1="HEROIC AUCHINDOUN",F2="HAUCH",F3="HADOWN",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="HEROIC BLOODMAUL SLAG MINES",F2="HSLAG",F3="HBSM",F4="HBLOODMAUL",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="HEROIC THE EVERBLOOM",F2="HEROIC EVERBLOOM",F3="HEB",F4="HBLOOM",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="GRIMRAIL DEPOT",F2="GRIMRAIL",F3="DEPOT",F4="GRD",F5="GD", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="HEROIC IRON DOCKS",F2="HID",F3="HDOCKS",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="HEROIC SHADOWMOON BURIAL GROUNDS",F2="HSBG",F3="HEROIC BURIAL GROUNDS",F4="HEROIC SHADOWMOON",F5="", Type=3,lStart=10, lEnd=60, Score=50},
				{F1="HEROIC SKYREACH",F2="HSKY",F3="HSR",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				{F1="HEROIC UPPER BLACKROCK SPIRE",F2="HUBRS",F3="HBRS",F4="",F5="", Type=3, lStart=10, lEnd=60, Score=50},
				

				--raids
				
				{F1="HIGHMAUL",F2="HM",F3="HIGHMAUL %d%d",F4="HM %d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="BLACKROCK FOUNDRY",F2="BRF",F3="BLACKROCK %d%d",F4="BRF %d%d",F5="BLACKROCK", Type=3, lStart=50, lEnd=60, Score=50},
				
				--World boss
				
				{F1="ECHIDNA",F2="",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				-- Word Bosses
				
				{F1="SALYIS'S WARBAND",F2="SALYISS WARBAND",F3="GALLEON",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="SHA OF ANGER",F2="SHA",F3="SOA",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="NALAK",F2="",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="OONDASTA",F2="",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				----------------------------------------------Legion----------------------------------------------------------
                -- Dungeons
				{F1="EYE OF AZSHARA",F2="AZSHARA",F3="EOA",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC EYE OF AZSHARA",F2="HAZSHARA",F3="HEOA",F4="",F5="", Type=3, lStart=10, lEnd=502, Score=50},

				{F1="DARKHEART THICKET",F2="DT",F3="DARKHEART",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC DARKHEART THICKET",F2="HDARKHEART",F3="HDT",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="NELTHARIONS LAIR",F2="NLAIR",F3="NL",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC NELTHARIONS LAIR",F2="HNLAIR",F3="HNL",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="HALLS OF VALOR",F2="HALLS",F3="HOV",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC HALLS OF VALOR",F2="HHALLS",F3="HHOV",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="ASSAULT ON VIOLET HOLD",F2="AVH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC ASSAULT ON VIOLET HOLD",F2="AVH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="VAULT OF THE WARDENS",F2="VOTW",F3="WARDENS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC VAULT OF THE WARDENS",F2="HVOTW",F3="HWARDENS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="BLACK ROOK HOLD",F2="BRH",F3="ROOK",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC BLACK ROOK HOLD",F2="HBRH",F3="HROOK",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="MAW OF SOULS",F2="MAW",F3="SOULS",F4="MOS",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC MAW OF SOULS",F2="HMAW",F3="HSOULS",F4="HMOS",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="THE ARCWAY",F2="ARCWAY",F3="TA",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC THE ARCWAY",F2="HARCWAY",F3="HTA",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="COURT OF STARS",F2="COURT",F3="COS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC COURT OF STARS",F2="HCOURT",F3="HCOS",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="RETURN TO KARAZHAN",F2="KARAZHAN",F3="RTK",F4="KARA",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC RETURN TO KARAZHAN",F2="HKARAZHAN",F3="HRTK",F4="HKARA",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="CATHERDRAL OF ERTERNAL NIGHT",F2="ETERNAL NIGHT",F3="CATH",F4="COEN",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC CATHERDRAL OF ERTERNAL NIGHT",F2="HEROIC ETERNAL NIGHT",F3="HCATH",F4="HCOEN",F5="", Type=3, lStart=10, lEnd=50, Score=50},

				{F1="SEAT OF THE TRIUMVIRATE",F2="TRIUMVIRATE",F3="SOTT",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SEAT OF THE TRIUMVIRATE",F2="HEROIC TRIUMVIRATE",F3="HTRIUMVIRATE",F4="HSOTT",F5="", Type=3, lStart=10, lEnd=50, Score=50},


				--raids
				
				{F1="EMERALD NIGHTMARE",F2="EN",F3="EMERALD %d%d",F4="EN %d%d",F5="EMERALD", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TRIAL OF VALOR",F2="TOV",F3="TRIAL %d%d",F4="TOV %d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="THE NIGHTHOLD",F2="NH",F3="NIGHTHOLD %d%d",F4="NH %d%d",F5="NIGHTHOLD", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="TOMB OF SARGERAS",F2="TOS",F3="SARGERAS %d%d",F4="TOS %d%d",F5="SARGERAS", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ANTORUS THE BURNING THRONE",F2="ABT",F3="ANTORUS %d%d",F4="ABT %d%d",F5="ANTORUS", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ANTORUS THE BURNING THRONE",F2="BURNING THRONE",F3="BURNING THRONE %d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				
				--World boss
				
				{F1="ANA-MOUZ",F2="CALMIR",F3="DRUGON",F4="DRUGON THE FROSTBLOOD",F5="FROSTBLOOD", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="FLOTSAM",F2="HUMONGRIS",F3="LEVANTUS",F4="NAZAK THE FIEND",F5="NAZAK", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ANAMOUZ",F2="NA'ZAK",F3="NITHOGG",F4="SHAR'THOS",F5="SHARTHOS", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="WITHERED J'IM",F2="J'IM",F3="WITHERED JIM",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				
				---------------------------------------------Battle for Azeroth-----------------------------------------------
                -- Dungeons
				{F1="KINGS' REST",F2="KINGS REST",F3="KR",F4="KREST",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC KINGS' REST",F2="HEROIC KINGS REST",F3="HKR",F4="HKREST",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="UNDERROT",F2="UROT",F3="",F4="",F5="", Type=3, lStart=25, lEnd=50, Score=50},
				{F1="HEROIC UNDERROT",F2="HUROT",F3="HUR",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="TEMPLE OF SETHRALISS",F2="SETHRALISS",F3="TOS",F4="",F5="", Type=3, lStart=35, lEnd=50, Score=50},
				{F1="HEROIC TEMPLE OF SETHRALISS",F2="HEROIC SETHRALISS",F3="HTOS",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="TOL DAGOR",F2="DAGOR",F3="TD",F4="",F5="", Type=3, lStart=30, lEnd=50, Score=50},
				{F1="HEROIC TOL DAGOR",F2="HDAGOR",F3="HTD",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="THE MOTHERLODE",F2="MOTHERLODE",F3="TML",F4="ML",F5="THE MOTHERLODE!!", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC MOTHERLODE",F2="HTML",F3="HML",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="ATAL'DAZAR",F2="DAZAR",F3="AD",F4="ATALDAZAR",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC ATAL'DAZAR",F2="HEROIC ATALDAZAR",F3="HDAZAR",F4="HAD",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="WAYCREAST MANOR",F2="WAYCREAST",F3="MANOR",F4="WCM",F5="WM", Type=3, lStart=25, lEnd=50, Score=50},
				{F1="HEROIC WAYCREAST MANOR",F2="HEROIC MANOR",F3="HEROIC WAYCREAST",F4="HWCM",F5="HWM", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="SEIGE OF BORALUS",F2="BORALUS",F3="SOB",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC SEIGE OF BORALUS",F2="HBORALUS",F3="HSOB",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="FREEHOLD",F2="FH",F3="",F4="",F5="", Type=3, lStart=10, lEnd=50, Score=50},
				{F1="HEROIC FREEHOLD",F2="HFH",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="SHRINE OF THE STORM",F2="SOS",F3="SHRINE",F4="",F5="", Type=3, lStart=35, lEnd=50, Score=50},
				{F1="HEROIC SHRINE OF THE STORM",F2="HSOS",F3="HSHRINE",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				{F1="OPERATION: MECHAGON",F2="OPERATION MECHAGON",F3="MECHAGON",F4="MECH",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="HEROIC OPERATION: MECHAGON",F2="HEROIC OPERATION MECHAGO",F3="HMECHAGON",F4="HMECH",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="JUNKYARD",F2="WORKSHOP",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},



				--raids
				
				{F1="ULDIR",F2="ULD",F3="ULDIR %d%d",F4="ULD %d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="BATTLE OF DAZAR'ALOR",F2="BOD",F3="BOD %d%d",F4="DAZAR'ALOR %d%d",F5="DAZAR'ALOR", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="CRUCIBLE OF STORMS",F2="CRUCIBLE",F3="CRUCIBLE %d%d",F4="COS %d%d",F5="COS", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="ETERNAL PALACE",F2="EP",F3="EP %d%d",F4="ETERNAL PALACE %d%d",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="NY'ALOTHA, THE WAKING CITY",F2="WAKING CITY",F3="WAKING CITY %d%d",F4="",F5="", Type=3, lStart=50, lEnd=602, Score=50},
				{F1="NY'ALOTHA",F2="NY'ALOTHA",F3="NY'ALOTHA %d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="WC",F2="N",F3="WC %d%d",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				
				--World boss
				
				{F1="DUNEGORGER KRAULOK",F2="DUNEGORGER",F3="KRAULOK",F4="JI'ARAK",F5="JIARAK", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="T'ZANE",F2="TZANE",F3="WARBRINGER YENAJZ",F4="WARBRINGER",F5="YENAJZ", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="AZURETHOS THE WINGED TYPHOON",F2="TYPHOON",F3="AZURETHOS",F4="HAILSTONE CONSTRUCT",F5="HAILSTONE", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="THE LIONS ROAR",F2="LION",F3="LIONS ROAR",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="DOOM'S HOWL",F2="DOOMS HOWL",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
				{F1="WORLD BOSS",F2="WORLD QUEST",F3="",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},

				---------------------------------------------Shadowlands-----------------------------------------------
                -- Dungeons
                {F1="DE OTHER SIDE",F2="DOS",F3="",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},
            	{F1="HEROIC DE OTHER SIDE",F2="HDOS",F3="",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="THE NECROTIC WAKE",F2="WAKE",F3="TNW",F4="NW",F5="", Type=3, lStart=51, lEnd=60, Score=50},
                {F1="HEROIC.+NECROTIC WAKE",F2="HWAKE",F3="HTNW",F4="HNW",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="MISTS OF TURNA SCITHE",F2="TURNA SCITHE",F3="SCITHE",F4="MOTS",F5="MTS", Type=3, lStart=55, lEnd=60, Score=50},
                {F1="HEROIC MISTS OF TURNA SCITHE",F2="HEROIC TURNA SCITHE",F3="HSCITHE",F4="HMOTS",F5="HMTS", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="SANGUINE DEPTHS",F2="DEPTHS",F3="SD",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},
                {F1="HEROIC SANGUINE DEPTHS",F2="HDEPTHS",F3="HSD",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},


                {F1="PLAGUEFALL",F2="PF",F3="",F4="",F5="", Type=3, lStart=53, lEnd=60, Score=50},
                {F1="HEROIC PLAGUEFALL",F2="HPF",F3="",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="SPIRES OF ASCENSION",F2="SPIRES",F3="ASCENSION",F4="SOA",F5="", Type=3, lStart=60, lEnd=65, Score=50},
                {F1="HEROIC SPIRES OF ASCENSION",F2="HSPIRES",F3="HASCENSION",F4="HSOA",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="HALLS OF ATONEMENT",F2="ATONEMENT",F3="HOA",F4="",F5="", Type=3, lStart=57, lEnd=62, Score=50},
                {F1="HALLS OF ATONEMENT",F2="ATONEMENT",F3="HOA",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="THEATER OF PAIN",F2="THEATER",F3="TOP",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},
                {F1="HEROIC THEATER OF PAIN",F2="HTHEATER",F3="HTOP",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},

                {F1="DARKMAUL CITADEL",F2="DMC",F3="CITADEL",F4="",F5="", Type=3, lStart=15, lEnd=30, Score=50},

                --- SCENARIOS
                {F1="QUEEN.*S CONSEVATORY",F2="CONSEVATORY",F3="QS",F4="",F5="", Type=3, lStart=50, lEnd=60, Score=50},
                
                {F1="MALDRAXXUS",F2="",F3="",F4="",F5="", Type=3, lStart=60, lEnd=65, Score=50},
                {F1="TORGHAST.* TOWER OF THE DAMNED",F2="TOWER OF THE DAMNED",F3="TORGHAST",F4="TTOD",F5="TOD", Type=3, lStart=50, lEnd=60, Score=50},
                {F1="THE FRACTURE CHAMBERS",F2="FRACTURE",F3="FRACTURE CHAMBERS",F4="TFC",F5="", Type=3, lStart=50, lEnd=60, Score=50},
                {F1="ARDENWEALD",F2="",F3="",F4="",F5="", Type=3, lStart=58, lEnd=60, Score=50},

                --raids


                {F1="CASTLE NATHRIA",F2="CASTLE",F3="NATHRIA",F4="CR",F5="", Type=3, lStart=60, lEnd=65, Score=50},
                {F1="HEROIC CASTLE NATHRIA",F2="HCASTLE",F3="HNATHRIA",F4="HCR",F5="", Type=3, lStart=60, lEnd=65, Score=50},


                --World boss

				
				---------------------------------------------Black List-----------------------------------------------
				
				{F1="WWW.-GOLD",F2="",F3="GOLD.-WWW",F4="",F5="$.-WWW", Type=0, lStart=0, lEnd=999, Score=-500, SingleWord=false}, --filter out gold adverts
				{F1="WWW.-$",F2="WTS.-WWW",F3="SELL.-WWW",F4="WWW.-SELL",F5="", Type=0, lStart=0, lEnd=999, Score=-500, SingleWord=false}, -- filter out gold adverts
				{F1="GOLD.-$",F2="$.-GOLD",F3="$.-COM",F4="COM.-$",F5="", Type=0, lStart=0, lEnd=999, Score=-500, SingleWord=false}, -- filter out gold adverts
			}
	
end


	