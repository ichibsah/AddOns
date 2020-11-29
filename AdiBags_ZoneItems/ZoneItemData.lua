local addonName, addon = ...	 
-- ZoneID Data	 
addon.arrZoneCodes = {	 
  [1]= { zGroup="Vale", zGroupIds={1530,1570,380,390} },	 
  [2]= { zGroup="Uldum", zGroupIds={1571,249,1527} },	 
  [3]= { zGroup="Vale/Uldum", zGroupIds={1571,249,1527,1530,1570,380} },	 
  [4]= { zGroup="Timeless Isle", zGroupIds={554} },	 
  [5]= { zGroup="Mechagon", zGroupIds={1462} },	 
  [6]= { zGroup="Nazjatar", zGroupIds={1355} },	 
  [7]= { zGroup="BfA Zones", zGroupIds={2161,2162,2160,2156,2103,2158,1504,1462} },	 
  [8]= { zGroup="Horrific Visions", zGroupIds={1469,1470, 1473} },	 
  [9]= { zGroup="Legion Missions", zGroupIds={647,648,626,717,734,735,24,702,695,747,719,831,883,887,726,739} },	 
  [10]= { zGroup="Heart Essence", zGroupIds={1473} },	 
  [11]= { zGroup="Garrison", zGroupIds={582,590,525} },	 
  [12]= { zGroup="REP: Nazjatar", zGroupIds={1355} },	 
  [13]= { zGroup="Reputation", zGroupIds={-1} },	 
  [14]= { zGroup="Pet Battle", zGroupIds={-1} },	 
  [15]= { zGroup="Scourge Invasion", zGroupIds={85,118} } ,}	 
-- Debugging Item field names	 
addon.kGetItemInfoVars = {'itemName', 'itemLink', 'itemRarity', 'itemLevel', 'itemMinLevel', 'itemType', 'itemSubType', 'itemStackCount', 'itemEquipLoc', 'itemIcon', 'itemSellPrice', 'itemClassID', 'itemSubClassID', 'bindType', 'expacID', 'itemSetID', 'isCraftingReagent'}	 
--	-- [id] = { itemId=ID, zoneId=ZoneSetID, qty=Qty, label="Label" }, } --Category: Item
addon.arrEssence= {	[1] = { itemId=169694, zoneId=10, qty=-1, label="" },--Essence: Aqueous Reliquary
	[2] = { itemId=174288, zoneId=10, qty=-1, label="" },--Essence: Breath of Everlasting Spirit
	[3] = { itemId=174279, zoneId=10, qty=-1, label="" },--Essence: Encrypted Ny'alothan Text
	[4] = { itemId=169491, zoneId=10, qty=-1, label="" },--Essence: Focused Life Anima
	[5] = { itemId=174287, zoneId=10, qty=-1, label="" },--Essence: Sparks of Unwavering Strength
	[6] = { itemId=173282, zoneId=10, qty=-1, label="" }, } --Essence: Token of Death's Glee
addon.arrMechagon = {	[1] = { itemId=169868, zoneId=5, qty=-1, label="" },--Mechagon: Anti-Gravity Pack
	[2] = { itemId=167062, zoneId=5, qty=-1, label="" },--Mechagon: Armored Vaultbot Key
	[3] = { itemId=168233, zoneId=5, qty=-1, label="" },--Mechagon: Bawld-371
	[4] = { itemId=168045, zoneId=5, qty=-1, label="" },--Mechagon: Beastbot Power Pack
	[5] = { itemId=167832, zoneId=5, qty=-1, label="" },--Mechagon: Canned Minnows
	[6] = { itemId=168327, zoneId=5, qty=-1, label="" },--Mechagon: Chain Ignitercoil
	[7] = { itemId=166972, zoneId=5, qty=-1, label="" },--Mechagon: Emergency Powerpack
	[8] = { itemId=166973, zoneId=5, qty=-1, label="" },--Mechagon: Emergency Repair Kit
	[9] = { itemId=166971, zoneId=5, qty=-1, label="" },--Mechagon: Empty Energy Cell
	[10] = { itemId=166970, zoneId=5, qty=-1, label="" },--Mechagon: Energy Cell
	[11] = { itemId=168961, zoneId=5, qty=-1, label="" },--Mechagon: Exothermic Evaporator Coil
	[12] = { itemId=168832, zoneId=5, qty=-1, label="" },--Mechagon: Galvanic Oscillator
	[13] = { itemId=168217, zoneId=5, qty=-1, label="" },--Mechagon: Hardened Spring
	[14] = { itemId=168952, zoneId=5, qty=-1, label="" },--Mechagon: Hardened Spring
	[15] = { itemId=167649, zoneId=5, qty=-1, label="" },--Mechagon: Hundred-Fathom Lure
	[16] = { itemId=167562, zoneId=5, qty=-1, label="" },--Mechagon: Ionized Minnow
	[17] = { itemId=169872, zoneId=5, qty=-1, label="" },--Mechagon: Irontide Lockbox Key
	[18] = { itemId=169878, zoneId=5, qty=-1, label="" },--Mechagon: Irradiated Undercoat
	[19] = { itemId=168215, zoneId=5, qty=-1, label="" },--Mechagon: Machined Gear Assembly
	[20] = { itemId=168950, zoneId=5, qty=-1, label="" },--Mechagon: Machined Gear Assembly
	[21] = { itemId=169873, zoneId=5, qty=-1, label="" },--Mechagon: Mechanized Supply Key
	[22] = { itemId=167071, zoneId=5, qty=-1, label="" },--Mechagon: Mechano-Treat
	[23] = { itemId=169218, zoneId=5, qty=-1, label="" },--Mechagon: Old Rusty Key
	[24] = { itemId=169675, zoneId=5, qty=-1, label="" },--Mechagon: Orange Paint Filled Bladder
	[25] = { itemId=169114, zoneId=5, qty=-1, label="" },--Mechagon: Personal Time Displacer
	[26] = { itemId=169470, zoneId=5, qty=-1, label="" },--Mechagon: Pressure Relief Valve
	[27] = { itemId=169610, zoneId=5, qty=-1, label="" },--Mechagon: S.P.A.R.E. Crate
	[28] = { itemId=168262, zoneId=5, qty=-1, label="" },--Mechagon: Sentry Fish
	[29] = { itemId=166846, zoneId=5, qty=-1, label="" },--Mechagon: Spare Parts
	[30] = { itemId=168216, zoneId=5, qty=-1, label="" },--Mechagon: Tempered Plating
	[31] = { itemId=168951, zoneId=5, qty=-1, label="" },--Mechagon: Tempered Plating
	[32] = { itemId=168213, zoneId=5, qty=-1, label="" },--Mechagon: Tensile Driveshaft
	[33] = { itemId=167075, zoneId=5, qty=-1, label="" }, } --Mechagon: Ultrasafe Transporter: Mechagon
addon.arrMissions = {	[1] = { itemId=127889, zoneId=11, qty=-1, label="" },--Missions: Ammo Reserves
	[2] = { itemId=118344, zoneId=11, qty=-1, label="" },--Missions: Arcane Crystal
	[3] = { itemId=120301, zoneId=11, qty=-1, label="" },--Missions: Armor Enhancement Token
	[4] = { itemId=114116, zoneId=11, qty=-1, label="" },--Missions: Bag of Salvaged Goods
	[5] = { itemId=114128, zoneId=11, qty=-1, label="" },--Missions: Balanced Weapon Enhancement
	[6] = { itemId=113821, zoneId=11, qty=-1, label="" },--Missions: Battered Iron Horde Helmet
	[7] = { itemId=125787, zoneId=11, qty=-1, label="" },--Missions: Bilge Pump
	[8] = { itemId=125787, zoneId=11, qty=-1, label="" },--Missions: Bilge Pump
	[9] = { itemId=124099, zoneId=11, qty=-1, label="" },--Missions: Blackfang Claw
	[10] = { itemId=114806, zoneId=11, qty=-1, label="" },--Missions: Blackrock Armor Set
	[11] = { itemId=114081, zoneId=11, qty=-1, label="" },--Missions: Blackrock Weaponry
	[12] = { itemId=127882, zoneId=11, qty=-1, label="" },--Missions: Blast Furnace
	[13] = { itemId=114745, zoneId=11, qty=-1, label="" },--Missions: Braced Armor Enhancement
	[14] = { itemId=147348, zoneId=11, qty=-1, label="" },--Missions: Bulky Armor Set
	[15] = { itemId=113823, zoneId=11, qty=-1, label="" },--Missions: Crusted Iron Horde Pauldrons
	[16] = { itemId=118340, zoneId=11, qty=-1, label="" },--Missions: Cyclical Power Converter
	[17] = { itemId=128308, zoneId=11, qty=-1, label="" },--Missions: Draenic Armor Set
	[18] = { itemId=128307, zoneId=11, qty=-1, label="" },--Missions: Draenic Weaponry
	[19] = { itemId=127891, zoneId=11, qty=-1, label="" },--Missions: Extra Quarters
	[20] = { itemId=127884, zoneId=11, qty=-1, label="" },--Missions: Felsmoke Launcher
	[21] = { itemId=122272, zoneId=11, qty=-1, label="" },--Missions: Follower Ability Retraining Manual
	[22] = { itemId=118354, zoneId=11, qty=-1, label="" },--Missions: Follower Retraining Certificate
	[23] = { itemId=122273, zoneId=11, qty=-1, label="" },--Missions: Follower Trait Retraining Guide
	[24] = { itemId=114808, zoneId=11, qty=-1, label="" },--Missions: Fortified Armor Enhancement
	[25] = { itemId=128314, zoneId=11, qty=-1, label="" },--Missions: Frozen Arms of a Hero
	[26] = { itemId=128257, zoneId=11, qty=-1, label="" },--Missions: Ghostly Spyglass
	[27] = { itemId=139419, zoneId=11, qty=-1, label="" },--Missions: Golden Banana
	[28] = { itemId=114746, zoneId=11, qty=-1, label="" },--Missions: Goredrenched Armor Set
	[29] = { itemId=114622, zoneId=11, qty=-1, label="" },--Missions: Goredrenched Weaponry
	[30] = { itemId=118099, zoneId=11, qty=-1, label="" },--Missions: Gorian Artifact Fragment
	[31] = { itemId=122583, zoneId=11, qty=-1, label="" },--Missions: Grease Monkey Guide
	[32] = { itemId=122582, zoneId=11, qty=-1, label="" },--Missions: Guide to Arakkoa Relations
	[33] = { itemId=127881, zoneId=11, qty=-1, label="" },--Missions: Gyroscopic Internal Stabilizer
	[34] = { itemId=118475, zoneId=11, qty=-1, label="" },--Missions: Hearthstone Strategy Guide
	[35] = { itemId=114822, zoneId=11, qty=-1, label="" },--Missions: Heavily Reinforced Armor Enhancement
	[36] = { itemId=127662, zoneId=11, qty=-1, label="" },--Missions: High Intensity Fog Lights
	[37] = { itemId=128313, zoneId=11, qty=-1, label="" },--Missions: Huge Ogre Cache
	[38] = { itemId=127880, zoneId=11, qty=-1, label="" },--Missions: Ice Cutter
	[39] = { itemId=113681, zoneId=11, qty=-1, label="" },--Missions: Iron Horde Scraps
	[40] = { itemId=140590, zoneId=11, qty=-1, label="" },--Missions: Large Crate of Salvage
	[41] = { itemId=140760, zoneId=11, qty=-1, label="" },--Missions: Libram of Truth
	[42] = { itemId=128659, zoneId=11, qty=-1, label="" },--Missions: Merry Supplies
	[43] = { itemId=118897, zoneId=11, qty=-1, label="" },--Missions: Miner's Coffee
	[44] = { itemId=122514, zoneId=11, qty=-1, label="" },--Missions: Mission Completion Orders
	[45] = { itemId=122580, zoneId=11, qty=-1, label="" },--Missions: Ogre Buddy Handbook
	[46] = { itemId=117491, zoneId=11, qty=-1, label="" },--Missions: Ogre Waystone
	[47] = { itemId=114131, zoneId=11, qty=-1, label="" },--Missions: Power Overrun Weapon Enhancement
	[48] = { itemId=118903, zoneId=11, qty=-1, label="" },--Missions: Preserved Mining Pick
	[49] = { itemId=127892, zoneId=11, qty=-1, label="" },--Missions: Q-43 Noisemaker Mines
	[50] = { itemId=113822, zoneId=11, qty=-1, label="" },--Missions: Ravaged Iron Horde Belt
	[51] = { itemId=122576, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Alchemy Lab
	[52] = { itemId=122590, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Enchanter's Study
	[53] = { itemId=122591, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Engineering Works
	[54] = { itemId=122592, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Gem Boutique
	[55] = { itemId=122593, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Scribe's Quarters
	[56] = { itemId=128373, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Shipyard
	[57] = { itemId=122594, zoneId=11, qty=-1, label="" },--Missions: Rush Order: Tailoring Emporium
	[58] = { itemId=122595, zoneId=11, qty=-1, label="" },--Missions: Rush Order: The Forge
	[59] = { itemId=122596, zoneId=11, qty=-1, label="" },--Missions: Rush Order: The Tannery
	[60] = { itemId=139593, zoneId=11, qty=-1, label="" },--Missions: Sack of Salvaged Goods
	[61] = { itemId=139594, zoneId=11, qty=-1, label="" },--Missions: Salvage Crate
	[62] = { itemId=118723, zoneId=11, qty=-1, label="" },--Missions: Secrets of Draenor Jewelcrafting
	[63] = { itemId=114129, zoneId=11, qty=-1, label="" },--Missions: Striking Weapon Enhancement
	[64] = { itemId=127883, zoneId=11, qty=-1, label="" },--Missions: True Iron Rudder
	[65] = { itemId=127894, zoneId=11, qty=-1, label="" },--Missions: Tuskarr Fishing Net
	[66] = { itemId=127886, zoneId=11, qty=-1, label="" },--Missions: Unsinkable
	[67] = { itemId=114807, zoneId=11, qty=-1, label="" },--Missions: War Ravaged Armor Set
	[68] = { itemId=114616, zoneId=11, qty=-1, label="" },--Missions: War Ravaged Weaponry
	[69] = { itemId=120302, zoneId=11, qty=-1, label="" },--Missions: Weapon Enhancement Token
	[70] = { itemId=122584, zoneId=11, qty=-1, label="" },--Missions: Winning the Wildlings
	[71] = { itemId=139428, zoneId=9, qty=-1, label="" },--Missions: A Master Plan
	[72] = { itemId=140924, zoneId=9, qty=-1, label="" },--Missions: Ashtongue Beacon
	[73] = { itemId=139802, zoneId=9, qty=-1, label="" },--Missions: Auspicious Fetish
	[74] = { itemId=140582, zoneId=9, qty=-1, label="" },--Missions: Bottomless Flast
	[75] = { itemId=152444, zoneId=9, qty=-1, label="" },--Missions: Exalted Xenedar Hammer
	[76] = { itemId=139418, zoneId=9, qty=-1, label="" },--Missions: Healing Stream Totem
	[77] = { itemId=139376, zoneId=9, qty=-1, label="" },--Missions: Healing Well
	[78] = { itemId=140749, zoneId=9, qty=-1, label="" },--Missions: Horn of Winter
	[79] = { itemId=138412, zoneId=9, qty=-1, label="" },--Missions: Iresoul's Healthstone
	[80] = { itemId=139867, zoneId=9, qty=-1, label="" },--Missions: Justice Hammer
	[81] = { itemId=152095, zoneId=9, qty=-1, label="" },--Missions: Krokul Ridgestalker
	[82] = { itemId=152447, zoneId=9, qty=-1, label="" },--Missions: Lightburst Charge
	[83] = { itemId=152097, zoneId=9, qty=-1, label="" },--Missions: Lightforged Bulwark
	[84] = { itemId=139801, zoneId=9, qty=-1, label="" },--Missions: Lucky Doodad
	[85] = { itemId=152445, zoneId=9, qty=-1, label="" },--Missions: Memento of the Lightforged
	[86] = { itemId=138883, zoneId=9, qty=-1, label="" },--Missions: Meryl's Conjured Refreshment
	[87] = { itemId=140767, zoneId=9, qty=-1, label="" },--Missions: Pile of Bits and Bones
	[88] = { itemId=140656, zoneId=9, qty=-1, label="" },--Missions: Rod of the Ascended
	[89] = { itemId=152932, zoneId=9, qty=-1, label="" },--Missions: Runewarded Lightblade
	[90] = { itemId=152443, zoneId=9, qty=-1, label="" },--Missions: Sanctified Armaments of the Light
	[91] = { itemId=147553, zoneId=9, qty=-1, label="" },--Missions: Shard of Twisting Nether
	[92] = { itemId=139177, zoneId=9, qty=-1, label="" },--Missions: Shattered Soul
	[93] = { itemId=143605, zoneId=9, qty=-1, label="" },--Missions: Strange Ball of Energy
	[94] = { itemId=143605, zoneId=9, qty=-1, label="" },--Missions: Strange Ball of Energy
	[95] = { itemId=143850, zoneId=9, qty=-1, label="" },--Missions: Summon Grimtotem Warrior
	[96] = { itemId=138410, zoneId=9, qty=-1, label="" },--Missions: Summoning Portal
	[97] = { itemId=141332, zoneId=9, qty=-1, label="" },--Missions: The Annals of Light and Shadow
	[98] = { itemId=152096, zoneId=9, qty=-1, label="" },--Missions: Void-Purged Krokul
	[99] = { itemId=139420, zoneId=9, qty=-1, label="" },--Missions: Wild Mushroom
	[100] = { itemId=152446, zoneId=9, qty=-1, label="" },--Missions: Writ of Holy Orders
	[101] = { itemId=152931, zoneId=9, qty=-1, label="" }, } --Missions: Xenic Tincture
addon.arrNazjatar = {	[1] = { itemId=170186, zoneId=6, qty=-1, label="" },--Nazjatar: Abyss Pearl
	[2] = { itemId=167910, zoneId=6, qty=-1, label="" },--Nazjatar: Bag of Who-Knows-What
	[3] = { itemId=169782, zoneId=6, qty=-1, label="" },--Nazjatar: Beckoner's Rosetta Stone
	[4] = { itemId=170189, zoneId=6, qty=-1, label="" },--Nazjatar: Blind Eye
	[5] = { itemId=167012, zoneId=6, qty=-1, label="" },--Nazjatar: Brinestone Pickaxe
	[6] = { itemId=168081, zoneId=6, qty=-1, label="" },--Nazjatar: Brinestone Pickaxe
	[7] = { itemId=167059, zoneId=6, qty=-1, label="" },--Nazjatar: Chum
	[8] = { itemId=167060, zoneId=6, qty=-1, label="" },--Nazjatar: Chum
	[9] = { itemId=168155, zoneId=6, qty=-1, label="" },--Nazjatar: Chum
	[10] = { itemId=168159, zoneId=6, qty=-1, label="" },--Nazjatar: Chum
	[11] = { itemId=167923, zoneId=6, qty=-1, label="" },--Nazjatar: Clean Murloc Sock
	[12] = { itemId=169783, zoneId=6, qty=-1, label="" },--Nazjatar: Cultist Pinky Finger
	[13] = { itemId=167905, zoneId=6, qty=-1, label="" },--Nazjatar: Curious Murloc Horn
	[14] = { itemId=167916, zoneId=6, qty=-1, label="" },--Nazjatar: Dirty Murloc Sock
	[15] = { itemId=167903, zoneId=6, qty=-1, label="" },--Nazjatar: Disintegrating Sand Sculpture
	[16] = { itemId=170472, zoneId=6, qty=-1, label="" },--Nazjatar: Encrusted Coin
	[17] = { itemId=167907, zoneId=6, qty=-1, label="" },--Nazjatar: Extra-Slimy Snail
	[18] = { itemId=168094, zoneId=6, qty=-1, label="" },--Nazjatar: Faintly Humming Sea Stones
	[19] = { itemId=167906, zoneId=6, qty=-1, label="" },--Nazjatar: Flatulent Fish
	[20] = { itemId=166888, zoneId=6, qty=-1, label="" },--Nazjatar: Germinating Seed
	[21] = { itemId=167786, zoneId=6, qty=-1, label="" },--Nazjatar: Germinating Seed
	[22] = { itemId=167909, zoneId=6, qty=-1, label="" },--Nazjatar: Ghost Food
	[23] = { itemId=167913, zoneId=6, qty=-1, label="" },--Nazjatar: Healthy Murloc Lunch
	[24] = { itemId=168666, zoneId=6, qty=-1, label="" },--Nazjatar: Hefty Glimmershell
	[25] = { itemId=170100, zoneId=6, qty=-1, label="" },--Nazjatar: Hungry Herald's Tentacle Taco
	[26] = { itemId=167914, zoneId=6, qty=-1, label="" },--Nazjatar: Jar of Fish Faces
	[27] = { itemId=167911, zoneId=6, qty=-1, label="" },--Nazjatar: Just Regular Butter
	[28] = { itemId=170512, zoneId=6, qty=-1, label="" },--Nazjatar: Lesser Benthic Arcanocrystal
	[29] = { itemId=170547, zoneId=6, qty=-1, label="" },--Nazjatar: Mardivas's Arcane Cache Key
	[30] = { itemId=168161, zoneId=6, qty=-1, label="" },--Nazjatar: Molted Shell
	[31] = { itemId=168232, zoneId=6, qty=-1, label="" },--Nazjatar: Murloco's 'Fish' Tacos
	[32] = { itemId=170153, zoneId=6, qty=-1, label="" },--Nazjatar: Ominous Looking Tome
	[33] = { itemId=169781, zoneId=6, qty=-1, label="" },--Nazjatar: Overwhelmingly-Alluring Idol
	[34] = { itemId=167902, zoneId=6, qty=-1, label="" },--Nazjatar: Particularly Dense Rock
	[35] = { itemId=168097, zoneId=6, qty=-1, label="" },--Nazjatar: Pilfered Armor Crate
	[36] = { itemId=167893, zoneId=6, qty=-1, label="" },--Nazjatar: Prismatic Crystal
	[37] = { itemId=169780, zoneId=6, qty=-1, label="" },--Nazjatar: Pulsating Blood Stone
	[38] = { itemId=170180, zoneId=6, qty=-1, label="" },--Nazjatar: Razorshell
	[39] = { itemId=168261, zoneId=6, qty=-1, label="" },--Nazjatar: Reinforced Cache Key
	[40] = { itemId=167077, zoneId=6, qty=-1, label="" },--Nazjatar: Scrying Stone
	[41] = { itemId=167908, zoneId=6, qty=-1, label="" },--Nazjatar: Sea Giant Foot Dust
	[42] = { itemId=170191, zoneId=6, qty=-1, label="" },--Nazjatar: Skeletal Hand
	[43] = { itemId=167896, zoneId=6, qty=-1, label="" },--Nazjatar: Slimy Naga Eyeball
	[44] = { itemId=167904, zoneId=6, qty=-1, label="" },--Nazjatar: Smelly Pile of Gloop
	[45] = { itemId=169332, zoneId=6, qty=-1, label="" },--Nazjatar: Strange Mineralized Water
	[46] = { itemId=169334, zoneId=6, qty=-1, label="" },--Nazjatar: Strange Oceanic Sediment
	[47] = { itemId=169333, zoneId=6, qty=-1, label="" },--Nazjatar: Strange Volcanic Rock
	[48] = { itemId=167915, zoneId=6, qty=-1, label="" },--Nazjatar: Sweet Sea Vegetable
	[49] = { itemId=170181, zoneId=6, qty=-1, label="" },--Nazjatar: Tidal Guard
	[50] = { itemId=167912, zoneId=6, qty=-1, label="" },--Nazjatar: Unidentified Mass
	[51] = { itemId=170158, zoneId=6, qty=-1, label="" },--Nazjatar: Unspeakable Pearl Idol
	[52] = { itemId=168053, zoneId=6, qty=-1, label="" },--Nazjatar: Unusually Wise Hermit Crab
	[53] = { itemId=170162, zoneId=6, qty=-1, label="" },--Nazjatar: Waterlogged Toolbox
	[54] = { itemId=170502, zoneId=6, qty=-1, label="" },--Nazjatar: Waterlogged Toolbox
	[55] = { itemId=170079, zoneId=12, qty=-1, label="" },--Nazjatar: Abyssal Conch
	[56] = { itemId=170184, zoneId=12, qty=-1, label="" },--Nazjatar: Ancient Reefwalker Bark
	[57] = { itemId=170167, zoneId=12, qty=-1, label="" },--Nazjatar: Eel Fillet
	[58] = { itemId=170176, zoneId=12, qty=-1, label="" },--Nazjatar: Fathom Ray Wing
	[59] = { itemId=170171, zoneId=12, qty=-1, label="" },--Nazjatar: Giant Crab Leg
	[60] = { itemId=170085, zoneId=12, qty=-1, label="" },--Nazjatar: Naga Deployment Orders
	[61] = { itemId=170183, zoneId=12, qty=-1, label="" },--Nazjatar: Reefwalker Bark
	[62] = { itemId=170161, zoneId=12, qty=-1, label="" },--Nazjatar: Unusually Wise Hermit Crab
	[63] = { itemId=169942, zoneId=12, qty=-1, label="" }, } --Nazjatar: Vibrant Sea Blossom
addon.arrPatch8_3 = {	[1] = { itemId=174352, zoneId=8, qty=-1, label="" },--Patch8_3: Baked Voidfin
	[2] = { itemId=167788, zoneId=8, qty=-1, label="" },--Patch8_3: Detoxifying Vial
	[3] = { itemId=174350, zoneId=8, qty=-1, label="" },--Patch8_3: Dubious Delight
	[4] = { itemId=172072, zoneId=8, qty=-1, label="" },--Patch8_3: Experimental Vial
	[5] = { itemId=172947, zoneId=8, qty=-1, label="" },--Patch8_3: Faceless Mask of Dark Imagination
	[6] = { itemId=174349, zoneId=8, qty=-1, label="" },--Patch8_3: Ghastly Goulash
	[7] = { itemId=174348, zoneId=8, qty=-1, label="" },--Patch8_3: Grilled Gnasher
	[8] = { itemId=171335, zoneId=9, qty=-1, label="" },--Patch8_3: Horrific Core
	[9] = { itemId=171352, zoneId=9, qty=-1, label="" },--Patch8_3: Horrific Core
	[10] = { itemId=174351, zoneId=8, qty=-1, label="" },--Patch8_3: K'Bab
	[11] = { itemId=174045, zoneId=8, qty=-1, label="" },--Patch8_3: Orb of Dark Portents
	[12] = { itemId=174046, zoneId=8, qty=-1, label="" },--Patch8_3: Orb of Visions
	[13] = { itemId=167027, zoneId=8, qty=-1, label="" },--Patch8_3: Portable Clarity Beam
	[14] = { itemId=169294, zoneId=8, qty=-1, label="" },--Patch8_3: Resilient Soul
	[15] = { itemId=171212, zoneId=8, qty=-1, label="" },--Patch8_3: Sanity Restoration Orb
	[16] = { itemId=173888, zoneId=8, qty=-1, label="" },--Patch8_3: Shard of Self Sacrifice
	[17] = { itemId=173363, zoneId=8, qty=-1, label="" },--Patch8_3: Vessel of Horrific Visions
	[18] = { itemId=173293, zoneId=8, qty=-1, label="" },--Patch8_3: Vial of Self Preservation
	[19] = { itemId=172494, zoneId=3, qty=-1, label="" },--Patch8_3: Baruk Idol
	[20] = { itemId=171347, zoneId=8, qty=-1, label="" },--Patch8_3: Corrupted Bone Fragment
	[21] = { itemId=174768, zoneId=3, qty=-1, label="" },--Patch8_3: Cursed Relic
	[22] = { itemId=175150, zoneId=2, qty=-1, label="" },--Patch8_3: Self-Shaping Amber
	[23] = { itemId=171334, zoneId=8, qty=-1, label="" },--Patch8_3: Void-Touched Cloth
	[24] = { itemId=174761, zoneId=2, qty=-1, label="" },--Patch8_3: Aqir Relic
	[25] = { itemId=174756, zoneId=2, qty=6, label="Combine Fragments Now!" },--Patch8_3: Aqir Relic Fragment
	[26] = { itemId=174837, zoneId=2, qty=-1, label="" },--Patch8_3: Decaying Fusion Core
	[27] = { itemId=174325, zoneId=2, qty=-1, label="" },--Patch8_3: Fire Bomb
	[28] = { itemId=174858, zoneId=2, qty=-1, label="" },--Patch8_3: Gersahl Greens
	[29] = { itemId=168160, zoneId=2, qty=-1, label="" },--Patch8_3: Jeweled Scarab Figurine
	[30] = { itemId=174867, zoneId=2, qty=-1, label="" },--Patch8_3: Shard of Corruption
	[31] = { itemId=168271, zoneId=2, qty=-1, label="" },--Patch8_3: Stolen Ramkahen Banner
	[32] = { itemId=171208, zoneId=2, qty=-1, label="" },--Patch8_3: Suntouched Amulet
	[33] = { itemId=168267, zoneId=2, qty=-1, label="" },--Patch8_3: Suntouched Figurine
	[34] = { itemId=174765, zoneId=2, qty=-1, label="" },--Patch8_3: Tol'vir Relic
	[35] = { itemId=174764, zoneId=2, qty=6, label="Combine Fragments Now!" },--Patch8_3: Tol'vir Relic Fragment
	[36] = { itemId=172495, zoneId=1, qty=-1, label="" },--Patch8_3: Anima Orb
	[37] = { itemId=174766, zoneId=1, qty=-1, label="" },--Patch8_3: Mantid Relic
	[38] = { itemId=174760, zoneId=1, qty=6, label="Combine Fragments Now!" },--Patch8_3: Mantid Relic Fragment
	[39] = { itemId=174767, zoneId=1, qty=-1, label="" },--Patch8_3: Mogu Relic
	[40] = { itemId=174759, zoneId=1, qty=6, label="Combine Fragments Now!" },--Patch8_3: Mogu Relic Fragment
	[41] = { itemId=86547, zoneId=1, qty=-1, label="" },--Patch8_3: Skyshard
	[42] = { itemId=174758, zoneId=1, qty=6, label="Combine Fragments Now!" },--Patch8_3: Voidwarped Relic Fragment
	[43] = { itemId=174927, zoneId=1, qty=-1, label="" }, } --Patch8_3: Zan-Tien Lasso
addon.arrReputation = {	[1] = { itemId=152957, zoneId=13, qty=-1, label="" },--Reputation: Army of the Light Insignia
	[2] = { itemId=146943, zoneId=13, qty=-1, label="" },--Reputation: Court of Farondis Insignia
	[3] = { itemId=146942, zoneId=13, qty=-1, label="" },--Reputation: Dreamweaver Insignia
	[4] = { itemId=152955, zoneId=13, qty=-1, label="" },--Reputation: Greater Army of the Light Insignia
	[5] = { itemId=150927, zoneId=13, qty=-1, label="" },--Reputation: Greater Court of Farondis Insignia
	[6] = { itemId=150926, zoneId=13, qty=-1, label="" },--Reputation: Greater Dreamweaver Insignia
	[7] = { itemId=150928, zoneId=13, qty=-1, label="" },--Reputation: Greater Highmountain Tribe Insignia
	[8] = { itemId=152464, zoneId=13, qty=-1, label="" },--Reputation: Greater Legionfall Insignia
	[9] = { itemId=150930, zoneId=13, qty=-1, label="" },--Reputation: Greater Nightfallen Insignia
	[10] = { itemId=150925, zoneId=13, qty=-1, label="" },--Reputation: Greater Valarjar Insignia
	[11] = { itemId=150929, zoneId=13, qty=-1, label="" },--Reputation: Greater Wardens Insignia
	[12] = { itemId=146944, zoneId=13, qty=-1, label="" },--Reputation: Highmountain Tribe Insignia
	[13] = { itemId=146950, zoneId=13, qty=-1, label="" },--Reputation: Legionfall Insignia
	[14] = { itemId=146946, zoneId=13, qty=-1, label="" },--Reputation: Nightfallen Insignia
	[15] = { itemId=117492, zoneId=13, qty=-1, label="" },--Reputation: Relic of Rukhmar
	[16] = { itemId=94225, zoneId=13, qty=-1, label="" },--Reputation: Stolen Celestial Insignia
	[17] = { itemId=94227, zoneId=13, qty=-1, label="" },--Reputation: Stolen Golden Lotus Insignia
	[18] = { itemId=94226, zoneId=13, qty=-1, label="" },--Reputation: Stolen Klaxxi Insignia
	[19] = { itemId=94223, zoneId=13, qty=-1, label="" },--Reputation: Stolen Shado-Pan Insignia
	[20] = { itemId=146941, zoneId=13, qty=-1, label="" },--Reputation: Valarjar Insignia
	[21] = { itemId=146945, zoneId=13, qty=-1, label="" }, } --Reputation: Wardens Insignia
addon.arrTimeless = {	[1] = { itemId=103642, zoneId=4, qty=-1, label="" },--Timeless: Book of the Ages
	[2] = { itemId=103643, zoneId=4, qty=-1, label="" },--Timeless: Dew of Eternal Morning
	[3] = { itemId=104346, zoneId=4, qty=-1, label="" },--Timeless: Golden Glider
	[4] = { itemId=103641, zoneId=4, qty=-1, label="" },--Timeless: Singing Crystal
	[5] = { itemId=104287, zoneId=4, qty=-1, label="" }, } --Timeless: Windfeather Plume
addon.arrScourge = {	[1] = { itemId=183200, zoneId=15, qty=-1, label="" },--Scourge: Pitch Black Scourgestone
	[2] = { itemId=180720, zoneId=15, qty=-1, label="" },--Scourge: Darkened Scourgestone
	[3] = { itemId=180454, zoneId=15, qty=-1, label="" }, } --Scourge: Anti-Doom Broom
	
	
--<GLOBALS      
local _G = _G      
local GetLocale = _G.GetLocale      
local pairs = _G.pairs      
local rawset = _G.rawset      
local setmetatable = _G.setmetatable      
local tostring = _G.tostring      
--GLOBALS>      
      
local L = setmetatable({}, {      
  __index = function(self, key)    
    if key ~= nil then  
      --[===[@debug@

      addon:Debug('Missing locale', tostring(key))
      --@end-debug@]===]
      rawset(self, key, tostring(key))
    end  
    return tostring(key)  
  end,    
})      
addon.L = L      

local locale = GetLocale()
----enUS
	 
   L["Zone Specific Items"] = true	 
   L["Group zone specific items together."] = true	 
   L["Current Zone First in Bags"] = true	 
   L["Group items relevant for the current zone(s) to top of bags for quicker access."] = true	 
   L["Enable"] = true	 
   L["Only a monster would disable this feature. You aren't a monster now, are you?"] = true	 
   L["Battle for Azeroth Groups,"] = true	 
   L["Select optional additional sub-groupings."] = true	 
   L["Mechagon"] = true	 
   L["Group items specific to Mechagon seperately.,"] = true	 
   L["Nazjatar"] = true	 
   L["Group items specific to Nazjatar seperately."] = true	 
   L["Heart Essence"] = true	 
   L["Group Heart of Azeroth essences seperately."] = true	 
   L["Uldum, Vale, Visions"] = true	 
   L["Group items added in Patch 8.3 for Uldum, Horrific Visions, and Vale of Eternal Blossoms."] = true	 
   L["Group corrupted items."] = true	 
   L["Current Zone Item"] = true	 
   L["Current Zone"] = true	 
   L["Current BoA"] = true	 
   L["Horrific Visions"] = true	 
   L["Garrison"] = true	 
	 
----deDE	 
if locale=="deDE" then 	 
   L["Zone Specific Items"] = "Zonenspezifische Gegenstände"	 
   L["Group zone specific items together."] = "Zonenspezifische Gegenstände gruppieren."	 
   L["Current Zone First in Bags"] = "Aktuelle Zone zuerst anzeigen"	 
   L["Group items relevant for the current zone(s) to top of bags for quicker access."] = "Gruppiert relevante Gegenstände für die aktuelle Zone und zeigt diese für schnelleren Zugriff zuerst an."	 
   L["Enable"] = "Aktivieren"	 
   L["Only a monster would disable this feature. You aren't a monster now, are you?"] = "Nur ein Monster würde diese Funktion deaktivieren. Du bist doch kein Monster, oder?"	 
   L["Battle for Azeroth Groups,"] = "Battle for Azeroth Gruppen,"	 
   L["Select optional additional sub-groupings."] = "Wähle optionale zusätzliche Untergruppen aus."	 
   L["Mechagon"] = "Mechagon"	 
   L["Group items specific to Mechagon seperately.,"] = "Gruppiere Gegenstände aus Mechagon getrennt.,"	 
   L["Nazjatar"] = "Nazjatar"	 
   L["Group items specific to Nazjatar seperately."] = "Gruppiere Gegenstände aus Nazjatar getrennt."	 
   L["Heart Essence"] = "Herzessenzen"	 
   L["Group Heart of Azeroth essences seperately."] = "Gruppiere Essenzen für das Herz von Azeroth getrennt."	 
   L["Uldum, Vale, Visions"] = "Uldum, Tal, Visionen"	 
   L["Group items added in Patch 8.3 for Uldum, Horrific Visions, and Vale of Eternal Blossoms."] = "Gruppiere Gegenstände, die in Patch 8.3 für Uldum, verstörende Visionen und dem Tal der ewigen Blüten, hinzugefügt wurden."	 
   L["Group corrupted items."] = "Gruppiere verderbte Gegenstände"	 
   L["Current Zone Item"] = "Aktuelle Zonengegenstände"	 
   L["Current Zone"] = "Aktuelle Zone"	 
   L["Current BoA"] = "Aktuelle BoA"	 
   L["Horrific Visions"] = "TBD"	 
   L["Garrison"] = "TBD"	 
end	 
----esMX	 
if locale=="esMX" then 	 
   L["Zone Specific Items"] = "Artículos Específicos de la Zona"	 
   L["Group zone specific items together."] = "Agrupe elementos específicos de la zona."	 
   L["Current Zone First in Bags"] = "Zona actual primero en bolsas"	 
   L["Group items relevant for the current zone(s) to top of bags for quicker access."] = "Agrupe los elementos relevantes para las zonas actuales en la parte superior de las bolsas para un acceso más rápido."	 
   L["Enable"] = "Habilitar"	 
   L["Only a monster would disable this feature. You aren't a monster now, are you?"] = "Solo un monstruo deshabilitaría esta función. No eres un monstruo ahora, ¿verdad?"	 
   L["Battle for Azeroth Groups,"] = "Batalla por los grupos de Azeroth,"	 
   L["Select optional additional sub-groupings."] = "Seleccione subgrupos adicionales opcionales."	 
   L["Mechagon"] = "Mechagon"	 
   L["Group items specific to Mechagon seperately.,"] = "Agrupe elementos específicos de Mechagon por separado."	 
   L["Nazjatar"] = "Nazjatar"	 
   L["Group items specific to Nazjatar seperately."] = "Agrupe elementos específicos de Nazjatar por separado."	 
   L["Heart Essence"] = "Esencias del corazón"	 
   L["Group Heart of Azeroth essences seperately."] = "Agrupe las esencias de Corazón de Azeroth por separado."	 
   L["Uldum, Vale, Visions"] = "Uldum, Valle, Visiones"	 
   L["Group items added in Patch 8.3 for Uldum, Horrific Visions, and Vale of Eternal Blossoms."] = "Agrupe los elementos agregados en el Parche 8.3 para Uldum,Visiones horribles y valleof Flores Eternas."	 
   L["Group corrupted items."] = "Agrupar elementos corruptos."	 
   L["Current Zone Item"] = "Elemento de zona actual"	 
   L["Current Zone"] = "Zona actual"	 
   L["Current BoA"] = "BoA actual"	 
   L["Horrific Visions"] = "Visiones Horribles"	 
   L["Garrison"] = "La Fortaleza"	 
end	 
	
for k,v in pairs(L) do if v == true then L[k] = k end end	
	
	
	
	
	