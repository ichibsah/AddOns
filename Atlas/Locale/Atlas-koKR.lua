-- $Id: Atlas-koKR.lua 270 2017-06-29 14:22:48Z arith $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert at gmail dot com>
	Copyright 2010 - Lothaer <lothayer at gmail dot com>, Atlas Team
	Copyright 2011 ~ 2017 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("Atlas", "koKR", false);

-- Atlas Spanish Localization
if ( GetLocale() == "koKR" ) then
-- Define the leading strings to be ignored while sorting
-- Ex: The Stockade
AtlasSortIgnore = {
	--"the (.+)",
};

-- Syntax: ["real_zone_name"] = "localized map zone name"
AtlasZoneSubstitutions = {
--	["Ahn'Qiraj"] = "Templo de Ahn'Qiraj";
--	["The Temple of Atal'Hakkar"] = "El Templo de Atal'Hakkar";
--	["Throne of Tides"] = "Fauce Abisal: Trono de las Mareas";
};
end


if L then
L[" 1/2"] = " 1/2"
L[" 2/2"] = " 2/2"
L["%s Dungeons"] = "%s 던전"
L["%s Instances"] = "%s 인스턴스"
L["%s Raids"] = "%s 공격대"
L["Adult"] = "성인"
L["AKA"] = "또는"
L["Alexston Chrome <Tavern of Time>"] = "알렉스턴 크롬 <시간의 선술집>"
L["Alurmi <Keepers of Time Quartermaster>"] = "알룰미 <시간의 수호자 병참장교>"
L["Anachronos <Keepers of Time>"] = "아나크로노스 <시간의 수호자>"
L["Andormu <Keepers of Time>"] = "안도르무 <시간의 수호자>"
L["Arazmodu <The Scale of Sands>"] = "아라즈모두 <시간의 중재자>"
L["Arcane Container"] = "마법 단지"
L["Arms Warrior"] = "무기 전사"
L["ATLAS_BUTTON_CLOSE"] = "닫기"
L["ATLAS_CLICK_TO_OPEN"] = "Atlas 지도 창을 열려면 클릭하세요."
L["ATLAS_CLOSE_ATLASLOOT_WINDOW"] = "AtlasLoot 창을 닫으려면 우클릭하세요."
L["ATLAS_COLLAPSE_BUTTON"] = "Atlas 일러두기를 닫으려면 클릭하세요."
L["ATLAS_DDL_CONTINENT"] = "대륙"
L["ATLAS_DDL_CONTINENT_BROKENISLES"] = "부서진 섬 인스턴스"
L["ATLAS_DDL_CONTINENT_BROKENISLES1"] = "부서진 섬 던전"
L["ATLAS_DDL_CONTINENT_BROKENISLES2"] = "부서진 섬 공격대"
L["ATLAS_DDL_CONTINENT_DEEPHOLM"] = "심원의 영지 인스턴스"
L["ATLAS_DDL_CONTINENT_DRAENOR"] = "드레노어 인스턴스"
L["ATLAS_DDL_CONTINENT_EASTERN"] = "동부 왕국 인스턴스"
L["ATLAS_DDL_CONTINENT_KALIMDOR"] = "칼림도어 인스턴스"
L["ATLAS_DDL_CONTINENT_NORTHREND"] = "노스렌드 인스턴스"
L["ATLAS_DDL_CONTINENT_OUTLAND"] = "아웃랜드 인스턴스"
L["ATLAS_DDL_CONTINENT_PANDARIA"] = "판다리아 인스턴스"
L["ATLAS_DDL_EXPANSION"] = "확장"
L["ATLAS_DDL_EXPANSION_BC"] = "불타는 성전 인스턴스"
L["ATLAS_DDL_EXPANSION_CATA"] = "대격변 인스턴스"
L["ATLAS_DDL_EXPANSION_LEGION"] = "군단 인스턴스"
L["ATLAS_DDL_EXPANSION_LEGION1"] = "군단 던전"
L["ATLAS_DDL_EXPANSION_LEGION2"] = "군단 공격대"
L["ATLAS_DDL_EXPANSION_MOP"] = "판다리아의 안개 인스턴스"
L["ATLAS_DDL_EXPANSION_OLD"] = "구세계 인스턴스"
L["ATLAS_DDL_EXPANSION_WOD"] = "드레노어의 군주 인스턴스"
L["ATLAS_DDL_EXPANSION_WOTLK"] = "리치왕의 분노 인스턴스"
L["ATLAS_DDL_LEVEL"] = "레벨"
L["ATLAS_DDL_LEVEL_100PLUS"] = "인스턴스 레벨 100+"
L["ATLAS_DDL_LEVEL_100TO110"] = "인스턴스 레벨 100-110"
L["ATLAS_DDL_LEVEL_110PLUS"] = "인스턴스 레벨 110+"
L["ATLAS_DDL_LEVEL_45TO60"] = "인스턴스 레벨 45-60"
L["ATLAS_DDL_LEVEL_60TO70"] = "인스턴스 레벨 60-70"
L["ATLAS_DDL_LEVEL_70TO80"] = "인스턴스 레벨 70-80"
L["ATLAS_DDL_LEVEL_80TO85"] = "인스턴스 레벨 80-85"
L["ATLAS_DDL_LEVEL_85TO90"] = "인스턴스 레벨 85-90"
L["ATLAS_DDL_LEVEL_90TO100"] = "인스턴스 레벨 90-100"
L["ATLAS_DDL_LEVEL_UNDER45"] = "인스턴스 레벨 45 아래"
L["ATLAS_DDL_PARTYSIZE"] = "파티 크기"
L["ATLAS_DDL_PARTYSIZE_10"] = "10인 인스턴스"
L["ATLAS_DDL_PARTYSIZE_20TO40"] = "20-40인 인스턴스"
L["ATLAS_DDL_PARTYSIZE_5"] = "5인 인스턴스"
L["ATLAS_DDL_TYPE"] = "유형"
L["ATLAS_DDL_TYPE_ENTRANCE"] = "입구"
L["ATLAS_DDL_TYPE_INSTANCE"] = "인스턴스"
L["ATLAS_DEP_MSG1"] = "Atlas가 오래된 모듈을 감지했습니다."
L["ATLAS_DEP_MSG2"] = "이 캐릭터에 대해서 비활성화됨."
L["ATLAS_DEP_MSG3"] = "AddOns 폴더에서 이들을 삭제하세요."
L["ATLAS_DEP_OK"] = "확인"
L["ATLAS_ENTRANCE_BUTTON"] = "입구"
L["ATLAS_EXPAND_BUTTON"] = "Atlas 일러두기 패널을 열려면 클릭하세요."
L["ATLAS_INFO"] = "Atlas 정보"
L["ATLAS_INFO_12200"] = [=[중요 공지:

애드온 파일의 크기가 증가함에 따라, 던전 지도 및 내부 플러그인을 별도의 애드온 패키지로 옮겼습니다.

유명 게임 웹사이트에서 애드온을 다운로드 받으신 분들은
Atlas의 핵심 기능과 WoW의 가장 최근 확장팩 지도만을 포함하고 있는 코어 애드온 만을 받으셨을 수 있습니다.

만약 옛 확장팩의 지도 또는 Atlas의 모든 플러그인을 사용하고 싶으신 분들은 별도의 애드온을 설치하셔야 합니다.

어디서 받는지 확인하시려면 다음 웹페이지를 확인하시거나:
|cff6666ffhttp://www.atlasmod.com/phpBB3/viewtopic.php?t=1522|cffffffff

Atlas 홈페이지를 방문하십시요:
|cff6666ffhttp://www.atlasmod.com/|cffffffff]=]
L["ATLAS_INFO_12201"] = [=[[Wow 5.0에서 추가된 새로운 시나리오 지도를 제공하기 위해, 새로운 플러그인 - |cff6666ffAtlas Scenarios|cffffffff 를 제작하였습니다.

Atlas 홈페이지에서 더 자세한 사항을 확인하시고, 플러그인을 따로 다운로드 / 설치 하는것을 잊지 마십시오.
|cff6666ffhttp://www.atlasmod.com/|cffffffff]=]
L["ATLAS_INSTANCE_BUTTON"] = "인스턴스"
L["ATLAS_LDB_HINT"] = [=[좌클릭 - Atlas 열기.
우클릭 - Atlas 옵션.]=]
L["ATLAS_MINIMAPLDB_HINT"] = [=[좌클릭은 Atlas 열기.
우클릭은 Atlas 옵션.
좌클릭 끌기는 이 버튼 이동. ]=]
L["ATLAS_MISSING_MODULE"] = [=[Atlas가 일부 빠진 모듈 / 플러그인을 감지했습니다.  

Atlas에 의해 중지된 오래된 모듈 / 플러그인일 수 있습니다. 
막 최신 버전을 모두 설치한 경우, 모두 활성화되어 있는지 확인하기 위해 애드온 목록으로 이동하세요. 

이런 "빠진" 모듈 / 플러그인이 필요하지 않고 이 메시지를 다시 보고싶지 않은 경우, 알림을 중지하기 위해 옵션 패널로 이동할 수 있습니다. 

빠진 모듈 / 플러그인 목록:]=]
L["ATLAS_OPEN_ACHIEVEMENT"] = "상세 업적을 열려면 클릭하세요."
L["ATLAS_OPEN_ADDON_LIST"] = "애드온 목록 열기"
L["ATLAS_OPEN_ADVENTURE"] = "모험 안내서 창을 열려면 클릭하세요."
L["ATLAS_OPEN_ATLASLOOT_WINDOW"] = "AtlasLoot 창을 열려면 클릭하세요."
L["ATLAS_OPEN_WOWMAP_WINDOW"] = "모험 안내서 지도 창을 열려면 클릭하세요."
L["ATLAS_OPTIONS_ACRONYMS"] = "약어 표시"
L["ATLAS_OPTIONS_ACRONYMS_TIP"] = "지도 상세에 인스턴스의 약어를 표시합니다."
L["ATLAS_OPTIONS_AUTOSEL"] = "인스턴스 지도 자동 선택"
L["ATLAS_OPTIONS_AUTOSEL_TIP"] = "Atlas가 위치를 감지하여 가장 나은 인스턴스 지도를 자동 선택합니다."
L["ATLAS_OPTIONS_BOSS_DESC"] = "가능한 경우 보스 설명 표시"
L["ATLAS_OPTIONS_BOSS_DESC_SCALE"] = "보스 설명 지도 툴팁 크기"
L["ATLAS_OPTIONS_BOSS_DESC_TIP"] = "마우스를 보스 번호 위에 올리면, 관련 정보를 이용할 수 있는 경우 보스 설명을 표시합니다."
L["ATLAS_OPTIONS_BOSS_POTRAIT"] = "가능한 경우 보스 초상화 표시"
L["ATLAS_OPTIONS_BUTPOS"] = "버튼 위치"
L["ATLAS_OPTIONS_BUTRAD"] = "버튼 반지름"
L["ATLAS_OPTIONS_BUTTON"] = "옵션"
L["ATLAS_OPTIONS_CATDD"] = "인스턴스 지도 정렬 방식:"
L["ATLAS_OPTIONS_CHECKMODULE"] = "빠진 모듈 / 플러그인 알림."
L["ATLAS_OPTIONS_CHECKMODULE_TIP"] = "WoW가 로드된 후 빠진 Atlas 모듈 / 플러그인이 있는지 검사를 수행할 수 있습니다."
L["ATLAS_OPTIONS_CLAMPED"] = "창을 화면에 가둠"
L["ATLAS_OPTIONS_CLAMPED_TIP"] = "게임 화면 밖으로 마우스로 끌 수 없도록 Atlas 창을 화면에 가둡니다."
L["ATLAS_OPTIONS_COLORINGDROPDOWN"] = "던전 드롭다운 목록 색상 표시"
L["ATLAS_OPTIONS_COLORINGDROPDOWN_TIP"] = "인스턴스의 최소 권장 레벨과 플레이어의 레벨에 따라, 인스턴스 난이도를 색상으로 표시합니다. "
L["ATLAS_OPTIONS_CTRL"] = "툴팁을 보기위해 Control키 사용"
L["ATLAS_OPTIONS_CTRL_TIP"] = "Control 키를 누르면서 마우스를 이용하여 지도 정보의 툴팁을 보기 위해서 활성화 하세요. 창에 표시하기 너무 길 때 유용합니다."
L["ATLAS_OPTIONS_DONTSHOWAGAIN"] = "같은 정보를 다시 표시하지 않음."
L["ATLAS_OPTIONS_HEADER_ADDONCONFIG"] = "애드온 구성"
L["ATLAS_OPTIONS_HEADER_DISPLAY"] = "표시 옵션"
L["ATLAS_OPTIONS_LOCK"] = "Atlas 창 잠금"
L["ATLAS_OPTIONS_LOCK_TIP"] = "Atlas 창을 잠그거나 잠금 해제합니다."
L["ATLAS_OPTIONS_MAXMENUITEMS"] = "최대 메뉴 항목 수"
L["ATLAS_OPTIONS_RCLICK"] = "우클릭 세계 지도"
L["ATLAS_OPTIONS_RCLICK_TIP"] = "Atlas 창에서 우클릭하면 WoW 세계 지도로 전환할 수 있습니다."
L["ATLAS_OPTIONS_RESETPOS"] = "초기화 위치"
L["ATLAS_OPTIONS_SCALE"] = "Atlas 프레임 크기"
L["ATLAS_OPTIONS_SHOWBUT"] = "미니맵에 버튼 표시"
L["ATLAS_OPTIONS_SHOWBUT_TIP"] = "미니맵 주변에 Atlas 버튼을 보입니다."
L["ATLAS_OPTIONS_SHOWWMBUT"] = "세계 지도 창에 버튼을 표시합니다."
L["ATLAS_OPTIONS_TRANS"] = "투명도"
L["ATLAS_ROPEN_ATLASLOOT_WINDOW"] = "AtlasLoot 창을 열려면 우클릭하세요."
L["ATLAS_SEARCH_UNAVAIL"] = "검색 불가"
L["ATLAS_SLASH"] = "/atlas"
L["ATLAS_SLASH_OPTIONS"] = "옵션"
L["ATLAS_STRING_CLEAR"] = "지우기"
L["ATLAS_STRING_LEVELRANGE"] = "레벨 범위"
L["ATLAS_STRING_LOCATION"] = "위치"
L["ATLAS_STRING_MINGEARLEVEL"] = "최소 장비 레벨"
L["ATLAS_STRING_MINLEVEL"] = "최소 레벨"
L["ATLAS_STRING_PLAYERLIMIT"] = "플레이어 수 제한"
L["ATLAS_STRING_RECLEVELRANGE"] = "추천 레벨"
L["ATLAS_STRING_SEARCH"] = "검색"
L["ATLAS_STRING_SELECT_CAT"] = "카테고리 선택"
L["ATLAS_STRING_SELECT_MAP"] = "지도 선택"
L["ATLAS_TITLE"] = "Atlas"
L["ATLAS_TOGGLE_LOOT"] = "전리품 패널을 켜고 끄려면 우클릭하세요."
L["Back"] = "뒤쪽"
L["Basement"] = "지하"
L["BINDING_HEADER_ATLAS_TITLE"] = "Atlas 단축키 설정"
L["BINDING_NAME_ATLAS_AUTOSEL"] = "자동 선택"
L["BINDING_NAME_ATLAS_OPTIONS"] = "옵션 켜기/끄기"
L["BINDING_NAME_ATLAS_TOGGLE"] = "Atlas 켜기/끄기"
L["Blacksmithing Plans"] = "대장기술 도면"
L["Bodley"] = "보들리"
L["Bortega <Reagents & Poison Supplies>"] = "보르테가 <마법 재료 및 독극물 상인>"
L["Brewfest"] = "가을 축제"
L["Child"] = "아이"
L["Colon"] = ":"
L["Comma"] = ","
L["Connection"] = "연결됨"
L["East"] = "동쪽"
L["Elevator"] = "승강기"
L["End"] = "끝"
L["Engineer"] = "공병"
L["Entrance"] = "입구"
L["Event"] = "이벤트"
L["Exalted"] = "확고한 동맹"
L["Exit"] = "출구"
L["Fourth Stop"] = "네 번째 대기"
L["Front"] = "앞쪽"
L["Galgrom <Provisioner>"] = "갈그롬 <배급원>"
L["Ghost"] = "유령"
L["Graveyard"] = "무덤"
L["Hallow's End"] = "할로윈 축제"
L["Heroic"] = "영웅"
L["Heroic_Symbol"] = "(영)"
L["Holy Paladin"] = "신성 기사"
L["Holy Priest"] = "신성 사제"
L["Hyphen"] = " - "
L["Imp"] = "임프"
L["Key"] = "열쇠"
L["L-DQuote"] = "\""
L["Lothos Riftwaker"] = "로소스 리프트웨이커"
L["Love is in the Air"] = "온누리에 사랑을"
L["Lower"] = "하층"
L["L-Parenthesis"] = " ("
L["L-SBracket"] = "["
L["Lunar Festival"] = "달의 축제"
L["MapA"] = " [A]"
L["MapB"] = " [B]"
L["MapC"] = " [C]"
L["MapD"] = " [D]"
L["MapE"] = " [E]"
L["MapF"] = " [F]"
L["MapG"] = " [G]"
L["MapH"] = " [H]"
L["MapI"] = " [I]"
L["MapJ"] = " [J]"
L["MapsNotFound"] = [=[현재 선택된 던전에 해당하는 지도 이미지가 없습니다.

관련 Atlas 지도 모듈을 설치했는지 확인 바랍니다.]=]
L["Meeting Stone"] = "만남의 돌"
L["Midsummer Festival"] = "한여름 불꽃축제"
L["Moonwell"] = "달샘"
L["Mythic"] = "신화"
L["Mythic_Symbol"] = "(신)"
L["North"] = "북쪽"
L["Nozari <Keepers of Time>"] = "노자리 <시간의 수호자>"
L["Optional"] = "선택"
L["Orange"] = "주황색"
L["Orb of Command"] = "지배의 보주"
L["Outside"] = "야외"
L["Period"] = ". "
L["Portal"] = "차원문"
L["PossibleMissingModule"] = "이 지도는 다음 모듈에 있습니다:"
L["Profile Options"] = "프로필 옵션"
L["Protection Warrior"] = "방어 전사"
L["Purple"] = "보라색"
L["Random"] = "무작위"
L["Rare"] = "희귀"
L["R-DQuote"] = "\""
L["Repair"] = "수리"
L["Retribution Paladin"] = "징벌 기사"
L["Rewards"] = "보상"
L["R-Parenthesis"] = ") "
L["R-SBracket"] = "]"
L["Scale and Transparency"] = "크기 및 투명도"
L["Scarshield Quartermaster <Scarshield Legion>"] = "방패부대 병참장교 <방패 부대>"
L["Second Stop"] = "두 번째 대기"
L["Semicolon"] = "; "
L["Shadow Priest"] = "암흑 사제"
L["Slash"] = " / "
L["Soridormi <The Scale of Sands>"] = "소리도르미 <시간의 중재자>"
L["South"] = "남쪽"
L["Spawn Point"] = "스폰 장소"
L["Start"] = "시작"
L["Steward of Time <Keepers of Time>"] = "시간의 청지기 <시간의 수호자>"
L["Summon"] = "소환"
L["Teleporter"] = "순간이동기"
L["Teleporter destination"] = "순간이동 목적지"
L["The Behemoth"] = "거수"
L["Third Stop"] = "세 번째 대기"
L["Top"] = "정상"
L["Tunnel"] = "터널"
L["Underwater"] = "수중"
L["Upper"] = "상층"
L["Upper floor"] = "상층"
L["Varies"] = "위치 바뀜"
L["West"] = "서쪽"
L["Yarley <Armorer>"] = "야를리 <방어구 제작자>"
L["Zaladormu"] = "잘라도르무"

-- ToC
L["Description"] = "인스턴스 지도 탐색기"
L["Title"] = "Atlas"

end
