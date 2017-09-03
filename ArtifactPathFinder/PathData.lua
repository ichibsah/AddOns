--[[

Copyright (C) 2016 Yossa <yossa.addons@googlemail.com>
All Rights Reserved unless otherwise explicitly stated.

Artifact trait alternate spell IDs: SethAluma
7.2 update: SethAluma (using icy-veins.com data)

]]--

local pathTable = {
 ["DEATHKNIGHT"] = {
     [128402] = {
           ["Blood"] =  {205223, 221775, {192542, 192543, 192544, 208793, 208794, 208795, 238686}, 192557, 192538, 192464, 192567, 192450, 192457, 193213, 192570, 192447, 192558, 192548, 192514, 192453, 192460, 214903, 241018, 238042, 238078, 238114, {192542, 192543, 192544, 208793, 208794, 208795, 238686}, 192457, 192514, {192453, 192447, 192450, 192464, 192538, 192460}, 239042},
         },
     [128292] = {
           ["Frost"] =  {189186, 218931, 189144, 189179, 204875, 189164, 190778, 189080, 189180, 189092, 189185, 189086, 189154, 189097, 189184, 189147, 205209, 214904, 241047, 238043, 238079, 238115, 189086, 189092, 189080, 189147, 189164, {204875, 189154}, 239042},
         },
     [128403] = {
           ["Unholy"] = {220143, 218280, 208598, 191488, 191637, 191747, 191494, 191584, 191760, 191731, 191485, 191442, 191565, 191741, 191419, {191592, 191593, 191594, 224466, 224467, 224468, 239106}, 191721, 214906, 241050, 191485, 238044, 191488, 191442, 191494, 191419, 208598, 238080, 238116, 191565, {191592, 191593, 191594, 224466, 224467, 224468, 239106}, 191584, 239042},
         },
 },
 ["DEMONHUNTER"] = {
     [127829] = {
           ["Havoc"] =         {201467, 214795, 201457, 201470, 201460, 201469, 201459, 201472, 201455, 201456, 201473, 201458, 201454, 201468, 201463, 201471, 201464, 214907, 241090, 238045, 243188, 238117, 201455, 201458, 201456, 201457, 201454, 201460, {201463, 201464, 201459}, 239042},
         },
     [128831] = {
           ["Vengeance"] =     {207407, 214744, 212827, 218910, 212817, 213017, 207375, 212829, 212816, 207387, 207343, 212894, 207347, 213010, 212821, 212819, 207352, 214909, 241091, 212817, 238046, 238082, 238118, 212816, 207343, 207375, 212821, 207347, 207352, 212827, 239042},
         },
 },
 ["DRUID"] = {
     [128858] = {
           ["Balance"] =       {202767, 214514, 202445, 202918, 203018, 202996, 202384, 202386, 202466, 202940, 202433, 213682, 202890, 202426, 214508, 202464, 202302, 214910, 241099, 238047, 238083, 238119, 202466, 202386, 202433, 202426, 202445, 202384, 202464, 203018, 202302, 239042},
         },
     [128860] = {
           ["Feral"] =         {210722, 214736, 210593, 210650, 210590, 210579, 210570, 210663, 210575, 210702, 210666, 210631, 210676, 210571, 210637, 210557, 210638, 214911, 241100, 210593, 210570, 210579, 210631, 210571, 238048, 238084, 238120, 210575, 210637, {210557, 210590}, 239042},
         },
     [128821] = {
           ["Guardian - Adaptive Fur"] =      {200851, 215061, 200440, 200400, 215799, 200402, 200515, 200409, 200855, 200395, 200850, 200415, 200399, 200854, 200414, 208762, 214996, 214912, 241101, 238049, 238085, 238121, 200409, 200440, 200399, 200400, {200414, 208762, 200415, 200402, 200395}, 239042},
           ["Guardian - Gory Fur"] =          {200851, 215061, 200440, 200400, 215799, 200402, 200515, 200409, 200855, 200415, 200399, 200854, 200395, 200850, 200414, 208762, 214996, 214912, 241101, 238049, 238085, 238121, 200409, 200440, 200399, 200400, {200414, 208762, 200415, 200402, 200395}, 239042},
         },
	 [128306] = {
           ["Restoration - Throughput"] =     {208253, 222644, 186320, 189787, 189760, 189849, 186393, 189754, 189744, 189857, 189757, 186396, 189772, 189870, 189749, 189768, 186372, 214913, 241102, 189772, 189757, 186320, 186396, 238050, 238086, 238122, 189760, 189749, 189744, 189768, 189754, 239042},
           ["Restoration - Mana"] =           {208253, 222644, 189757, 186396, 189772, 189870, 186320, 189787, 186393, 189760, 189849, 189754, 189744, 189857, 189749, 189768, 186372, 214913, 241102, 189772, 189757, 186320, 186396, 238050, 238086, 238122, 189760, 189749, 189744, 189768, 189754, 239042},
         },
 },
 ["HUNTER"] = {
     [128861] = {
           ["Beast Mastery"] = {197344, 215779, 197139, 197160, 197162, 197248, 197047, 206910, 197354, 197343, 197080, 197038, 207068, 197140, 197199, 197138, 197178, 214914, 241110, 238051, 238087, 238123, 197162, 197080, 197047, 206910, 197038, 197140, 197139, {197160, 197138}, 239042},
         },
     [128826] = {
           ["Marksmanship"] =  {204147, 214826, 190467, 204219, 190449, 190567, 191339, 190529, 204089, 190457, 190852, 190520, 191048, 190462, 191328, 190503, 190514, 214915, 241114, 238052, 238088, 238124, 190462, 190457, 190520, 190529, 190449, 190467, {190503, 190567, 190514}, 239042},
         },
     [128808] = {
           ["Survival"] =      {203415, 221773, 203673, 203638, 203670, 203755, 203752, 203578, 203757, 203669, 225092, 224764, 203563, 203566, 203577, 203754, 203749, 214916, 241115, 238053, 238089, 238125, 203566, 203669, 203673, 203577, 203638, 203578, 203670, {203749, 224764}, 239042},
         },
 },
 ["MAGE"] = {
     [127857] = {
           ["Arcane"] =        {224968, 187318, 187258, 187264, 210716, 215463, 187276, 187321, 188006, 187287, 187301, 210725, 187304, 187313, 187310, 187680, 210730, 214917, 241121, 238054, 238090, 238126, 187276, 187321, 187258, 187287, 187313, 187304, 187264, 210716, 187301, 239042},
         },
     [128820] = {
           ["Fire"] =          {194466, 221844, 194318, 194239, 194224, 194331, 194313, 215796, 194314, 215773, 194312, 194431, 194234, 194487, 210182, 194315, 227481, 214918, 241124, 194224, 238055, 194239, 194312, 238091, 238127, 194314, 194234, 194313, 210182, 194318, 194315, 239042},
         },
     [128862] = {
           ["Frost"] =         {214634, 214629, 195322, 195352, 195419, 214626, 214776, 195345, 195351, 220817, 195317, 195448, 195315, 214664, 195354, 195615, 195323, 214919, 241125, 238056, 238092, 238128, 195345, 195322, 195317, 195351, 195315, 195352, 195323, 214626, 195354, 239042},
         },
 },
 ["MONK"] = {
     [128938] = {
           ["Brewmaster"] =    {214326, 214428, 213047, {213049, 227683, 227684, 227685, 227686, 227687, 239304}, 213116, 216424, {213062, 227688, 227689, 227690, 227691, 227692, 239306}, 213050, 213051, 213180, 214372, 213133, 213161, 213136, 213183, 213055, 213340, 214920, 241131, 238057, 238093, 238129, 213116, {213049, 227683, 227684, 227685, 227686, 227687, 239304}, 213136, 213051, 213047, {213062, 227688, 227689, 227690, 227691, 227692, 239306}, 213180, 213133, 213055, 239042},
         },
     [128937] = {
           ["Mistweaver - Dancing Mists"] =         {205406, 214516, 199485, 199384, 199366, 199887, 199563, 199372, 199380, 199365, 199573, 199367, 199665, 199364, 199640, 199377, 199401, 214921, 241134, 238058, 199380, 199372, 199485, 199366, 238094, 238130, 199364, 199367, 199377, 199365, 199384, 239042},
           ["Mistweaver - Blessing of Yu'lon"] =    {205406, 214516, 199485, 199384, 199366, 199887, 199563, 199372, 199367, 199665, 199380, 199365, 199573, 199364, 199640, 199377, 199401, 214921, 241134, 238058, 199380, 199372, 199485, 199366, 238094, 238130, 199364, 199367, 199377, 199365, 199384, 239042},
         },
     [128940] = {
           ["Windwalker - Single Target / Raid"] =  {205320, 195265, 195263, 195266, 195244, 195291, 195298, 195243, 196082, 195300, 218607, 195650, 195399, 195269, 195267, 195380, 195295, 214922, 241136, 238059, 238095, 238131, 195291, 195263, {195244, 195266, 195269, 195267, 195380, 218607, 195243}, 239042},
           ["Windwalker - AoE / Leveling"] =        {205320, 195265, 195269, 195267, 195380, 195650, 218607, 195300, 195243, 196082, 195298, 195291, 195399, 195263, 195266, 195244, 195295, 214922, 241136, 238059, 238095, 238131, 195291, 195263, {195244, 195266, 195269, 195267, 195380, 218607, 195243}, 239042},
         },
 },
 ["PALADIN"] = {
     [128823] = {
           ["Holy"] =          {200652, 222648, 200302, 200315, 200373, 200294, 200474, 200482, 200311, 200326, 200430, 200296, 200298, 200421, 200407, 200327, 200316, 214923, 241145, 200315, 200294, 200482, 238060, 238096, 238132, 200296, 200316, 200326, 200298, 200327, 200302, 239042},
         },
     [128866] = {
           ["Protection"] =    {209202, 221841, {209225, 211912, 211913, 211914, 211915, 211916, 239295}, {209226, 213570, 213571, 213572, 213573, 213574, 239293}, 209229, 209218, 209474, 209224, 209389, 209223, 209220, 209341, 209285, 209216, 209539, 209376, 209217, 214924, 241146, 238061, 238097, 238133, 209218, 209229, 209217, {209226, 213570, 213571, 213572, 213573, 213574, 239293}, 209220, 209223, {209225, 211912, 211913, 211914, 211915, 211916, 239295}, 209224, 209216, 239042},
         },
     [120978] = {
           ["Retribution"] =  {205273, 214081, 186927, 184759, 186945, 186941, 185086, 185368, 179546, 184778, 186788, 186934, 186773, 184843, 182234, 186944, 193058, 207604, 241147, 238062, 238098, 238134, 186945, 186927, 185368, 184843, {184778, 184759, 186934, 186941, 186944}, 239042},
         },
 },
 ["PRIEST"] = {
     [128868] = {
           ["Discipline"] =    {207946, 216122, 197708, 197729, 197781, 216212, 197716, 198068, 197715, 197762, 198074, 197727, 197713, 197815, 197779, 197766, 197711, 214925, 241148, 238063, 238099, 238135, 197708, 197729, 197715, 197762, 197727, 197716, 216212, 197713, 197711, 239042},
         },
     [128825] = {
           ["Holy"] =          {196684, 222646, 196422, 196418, 196430, 196429, 196489, 196578, 196358, 196779, 196416, 208065, 196492, 196437, 196434, 196355, 196419, 214926, 241149, 238064, 238100, 238136, 196430, 196358, 196429, 196489, 196434, 196418, 196422, 196416, 196355, 239042},
         },
     [128827] = {
           ["Shadow"] =        {205065, 215322, 194093, 193644, 194024, 193642, 193643, 194378, 193647, 194007, 193371, 194026, 194002, 194179, 194016, 194018, 193645, 214927, 241150, 238065, 238101, 238137, 194007, 193644, 194002, 194093, 193643, 194016, 193645, 193642, 193647, 239042},
         },
 },
 ["ROGUE"] = {
     [128870] = {
           ["Assassination"] =                 {192759, 214368, 192310, 192384, 192349, 192329, 192923, 192318, 192657, 192376, 192424, 192315, 192428, 192326, 192323, 192422, 192345, 214928, 241152, 238066, 238102, 238138, 192329, 192310, 192318, 192315, 192349, 192326, 192376, 192345, 192323, 239042},
         },
     [128872] = {
           ["Outlaw"] =                        {202665, 202463, 202514, 202524, 202533, 202820, 202753, 202507, 202530, 202522, 202755, 202521, 202897, 216230, 202769, 202628, 202907, 214929, 241153, 238067, 238103, 238139, 202514, 202524, 202530, 202521, 202507, 202522, 216230, 202907, 202533, 239042},
         },
     [128476] = {
           ["Subtlety - Single Target/Raid"] = {209782, 221856, 197234, {197241, 210144, 210145, 210146, 210147, 210148, 239290}, 197244, 197239, 197406, 197256, 197231, 209835, 197233, 197235, 197386, 209781, 197369, 197610, 197604, 214930, 241154, 238068, 242707, 238140, 197239, 197234, 197233, 197235, 197369, 197386, 197231, {197241, 210144, 210145, 210146, 210147, 210148, 239290}, 197244, 239042},
           ["Subtlety - AoE/Dungeon"] =        {209782, 221856, 197234, {197241, 210144, 210145, 210146, 210147, 210148, 239290}, 197244, 197239, 197406, 197256, 197231, 209835, 197386, 209781, 197233, 197235, 197369, 197610, 197604, 214930, 241154, 238068, 242707, 238140, 197239, 197234, 197233, 197235, 197369, 197386, 197231, {197241, 210144, 210145, 210146, 210147, 210148, 239290}, 197244, 239042},
         },
 },
 ["SHAMAN"] = {
     [128935] = {
           ["Elemental"] =     {205495, 215414, 191740, 191512, 191569, 191572, 191861, 191602, 191504, 191493, 191717, 191499, 191598, 192630, 191577, 191647, 191582, 214931, 241202, 238069, 238105, 238141, 191504, 191740, 191572, 191493, 191598, 191577, 191499, 191569, 191582, 239042},
         },
     [128819] = {
           ["Enhancement"] =   {204945, 198228, 198299, 198292, 198434, 198296, 198505, 198367, 198248, 198361, 198238, 198736, 215381, 198247, 198236, 199107, 198349, 214932, 241203, 238070, 238106, 238142, 198292, 198236, 215381, 198247, 198349, 198299, {198296, 198248, 198238}, 239042},
         },
     [128911] = {
           ["Restoration"] =   {207778, 224841, 207088, {207118, 210029, 210030, 210031, 210032, 210033}, 207255, 207358, 207092, 207206, 207285, 207360, 207354, 207357, 207348, 207362, 207355, 207356, 207351, 214933, 241205, 238071, 242652, 238143, 207348, 207092, 207206, {207118, 210029, 210030, 210031, 210032, 210033}, 207255, 207088, 207285, 207354, 207351, 239042},
         },
 },
 ["WARLOCK"] = {
     [128942] = {
           ["Affliction"] =    {216698, 221862, 199152, 199220, 199158, 100472, 199112, 199163, 199471, 199111, 199212, 201424, 199120, 199257, 199153, 199282, 199214, 214934, 241257, 238072, 238108, 238144, 199158, 199163, 199152, 199111, 199112, 199120, 199153, 199214, 199212, 239042},
         },
     [128943] = {
           ["Demonology"] =    {211714, 221882, 211108, 211158, 211144, 211099, 211119, 211219, 218572, 211106, 211530, 211123, 218567, 211131, 211720, 211105, 211126, 214935, 241252, 238073, 238109, 211119, 211106, 238145, 211108, 211123, 211099, 211105, 211126, 211131, 211144, 239042},
         },
     [128941] = {
           ["Destruction"] =   {196586, 215183, 196305, 215273, 196432, 196301, 196227, 219195, 224103, 196211, 215223, 196236, 196217, 219415, 196222, 196258, 196675, 214936, 241253, 238074, 238110, 238146, 196432, 196227, 196217, 196222, 196211, 196236, 196258, 196305, 196301, 239042},
         },
 },
 ["WARRIOR"] = {
     [128910] = {
           ["Arms"] =          {209577, 209480, 209472, 209548, 209494, 209574, 209483, 209492, 209566, 216274, 209554, 209459, 209462, 209481, 209573, 209541, 209559, 214937, 241264, 238075, 238111, 238147, 209494, 209492, 209472, 209459, 209481, 216274, 209462, {209541, 209483}, 239042},
         },
     [128908] = {
           ["Fury"] =          {205545, 200847, 200853, 200860, 200861, 200871, 200849, 200872, 200870, 200846, 200875, 200863, 200857, 200845, 216273, 200856, 200859, 214938, 241269, 200860, 238076, 238112, 238148, 200861, 200849, 200853, 200846, 216273, 200856, {200859, 200857}, 239042},
         },
     [128289] = {
           ["Protection"] =    {203524, 188647, 188639, 203227, 203225, 188672, 203576, 203261, 203230, 189059, 188635, 188683, 188651, 188778, 188632, 216272, 188644, 214939, 241270, 238077, 238113, 238149, 216272, 188644, 188639, 188635, 203225, 188632, 203227, 188683, 203230, 239042},
         },
 },
}

pathTable["DEATHKNIGHT"][128293] = pathTable["DEATHKNIGHT"][128292]
pathTable["DEMONHUNTER"][127830] = pathTable["DEMONHUNTER"][127829]
pathTable["DEMONHUNTER"][128832] = pathTable["DEMONHUNTER"][128831]
pathTable["DRUID"][128859] = pathTable["DRUID"][128860]
pathTable["DRUID"][128822] = pathTable["DRUID"][128821]
pathTable["MAGE"][133959] = pathTable["MAGE"][128820]
pathTable["MONK"][133948] = pathTable["MONK"][128940]
pathTable["PALADIN"][128867] = pathTable["PALADIN"][128866]
pathTable["PRIEST"][133958] = pathTable["PRIEST"][128827]
pathTable["ROGUE"][128869] = pathTable["ROGUE"][128870]
pathTable["ROGUE"][134552] = pathTable["ROGUE"][128872]
pathTable["ROGUE"][128479] = pathTable["ROGUE"][128872]
pathTable["SHAMAN"][128936] = pathTable["SHAMAN"][128935]
pathTable["SHAMAN"][128873] = pathTable["SHAMAN"][128819]
pathTable["SHAMAN"][128934] = pathTable["SHAMAN"][128911]
pathTable["WARLOCK"][137246] = pathTable["WARLOCK"][128943]
pathTable["WARRIOR"][134553] = pathTable["WARRIOR"][128908]
pathTable["WARRIOR"][128288] = pathTable["WARRIOR"][128289]

ArtifactPathFinder.Data = pathTable