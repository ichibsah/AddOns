local L = LibStub("AceLocale-3.0"):NewLocale("IceHUD", "koKR")
if not L then return end

L["(De)Buff watcher"] = "(디)버프 감시"
L["|cff8888ffIceHUD|r: Combat lockdown restriction. Leave combat and try again."] = "|cff8888ffIceHUD|r: 전투 잠금 제한. 전투에서 벗어난 후 다시 시도하세요."
L["1 combo point: yellow, max combo points: red"] = "연계 점수 1점: 노랑, 최대 연계 점수: 빨강"
L["1 lacerate: yellow, 5 lacerates: red"] = "가르기 1중첩: 노랑, 가르기 5중첩: 빨강"
L["1 maelstrom: yellow, 5 maelstroms: red"] = "소용돌이치는 무기 1중첩: 노랑, 소용돌이치는 무기 5중첩: 빨강"
L["1 sunder: yellow, 5 sunders: red"] = "방어구 가르기 1중첩: 노랑, 방어구 가르기 5중첩: 빨강"
L["A custom bar has been created and can be configured through Module Settings => MyCustomBar. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 바가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomBar. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["A custom cooldown bar has been created and can be configured through Module Settings => MyCustomCD. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 재사용 대기시간 바가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomCD. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["A custom counter bar has been created and can be configured through Module Settings => MyCustomCounterBar. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 카운터 바가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomCounterBar. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["A custom counter has been created and can be configured through Module Settings => MyCustomCounter. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 카운터가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomCounter. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["A custom health bar has been created and can be configured through Module Settings => MyCustomHealth. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 생명력 바가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomHealth. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["A custom mana bar has been created and can be configured through Module Settings => MyCustomMana. It is highly recommended that you change the bar name of this module so that it's easier to identify."] = "사용자 마나바가 생성되었으며 모듈 설정을 통해 구성 할 수 있습니다 => MyCustomMana. 보다 쉽게 ​​식별 할 수 있도록 이 모듈의 바 이름을 변경하는 것이 좋습니다."
L["Abbreviate estimated health"] = "추정 생명력 간소화"
L["Abbreviate health"] = "생명력 간소화"
L["Absorb bar alpha"] = "중첩 바 투명도"
L["Adjust the horizontal position of the aura icon"] = "아이콘의 수평 위치 조정"
L["Adjust the vertical placement of this bar"] = "이 바의 수직 배치를 조정"
L["Adjust the vertical position of the aura icon"] = "아이콘의 수직 위치 조정"
L["Adjusts the size of the aura icon for this bar"] = "이 바의 아이콘 크기를 조정"
L["Advanced Bar Settings"] = "고급 바 설정"
L["Aggro Indicator alpha"] = "어그로 지시기 투명도"
L["Aggro indicator alpha (0 is disabled)"] = "어그로 지시기 투명도 (0은 사용안함)"
L["Alert Party"] = "파티원 경보"
L["Allow click casting"] = "클릭 시전 허용"
L["Allow click-targeting"] = "겨냥 대상 클릭 허용"
L["Allow click-targeting in combat"] = "전투중 겨냥 대상 클릭 허용"
L["Allow mouse interaction"] = "마우스 상호 작용 허용"
L["Alpha in combat"] = "전투 중 투명도"
L["Alpha OOC and not full"] = "비전투 및 생명력 손실 시 투명도"
L["Alpha OOC and Target"] = "비전투 시 및 대상의 투명도"
L["Alpha out of combat"] = "비전투 시 투명도"
L["Also show numeric"] = "숫자도 보기"
L["Always display bar"] = "바 항상 표시"
L["Always show at 100% alpha"] = "항상 100% 투명도로 보기"
L["Animate changes"] = "애니메이션 변경"
L["Animation Duration"] = "애니메이션 지속시간"
L["Animation Settings"] = "애니메이션 설정"
L["Answers to questions that are frequently asked."] = "자주 묻는 질문에 대한 답변."
L[ [=[Any valid unit id such as: party1, raid14, targettarget, etc. Not guaranteed to work with all unit ids.

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[다음과 같은 유효한 유닛ID: party1, raid14, targettarget 등. 모든 유닛ID가 작동하는 것은 아닙니다.

이 공간을 원하는 이름으로 채운 후 Enter 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Are you sure you want to delete this module? This will remove all settings associated with it and cannot be un-done."] = "이 모듈을 삭제할까요? 이렇게 하면 관련된 모든 설정이 제거되며 실행을 취소 할 수 없습니다."
L["Aura icon horizontal offset"] = "아이콘 수평 위치"
L["Aura icon scale"] = "아이콘 크기"
L["Aura icon vertical offset"] = "아이콘 수직 위치"
L["Aura settings"] = "오라 설정"
L["Aura to track"] = "추적할 오라"
L["Automatically size this module to the addon's 'gap' setting"] = "애드온의 '간격' 설정으로 이 모듈의 크기를 자동 조정"
L["Background Alpha"] = "배경 투명도"
L["Background alpha for bars IC"] = "전투 중 배경 투명도"
L["Background alpha for bars OOC and bar not full (Target takes precedence over this)"] = "비전투 중과 손실된 바에 대한 배경 투명도 (대상이 이것보다 우선)"
L["Background alpha for bars OOC and target accuired (takes precedence over Not Full)"] = "비전투 중과 선택한 대상에 대한 배경 투명도 (손실보다 우선)"
L["Background alpha for bars OOC without target"] = "대상이 없는 비전투 중 바에 대한 배경 투명도"
L["Background Color"] = "배경 색상"
L["Bar Alpha"] = "바 투명도"
L["Bar alpha In Combat"] = "전투 중 바 투명도"
L["Bar alpha Out Of Combat with target accuired (takes precedence over Not Full)"] = "선택한 대상과 함께 비전투 중 바 투명도 (손실보다 우선)"
L["Bar alpha Out Of Combat with target accuired or bar not full (Target takes precedence over this)"] = "선택한 대상 또는 손실된 바와 함께 비전투 중 바 투명도 (대상이 이것보다 우선)"
L["Bar alpha Out Of Combat without target"] = "대상이 없는 비전투 중의 바 투명도"
L["Bar Background Blend Mode"] = "바의 배경 혼합 방식"
L["Bar background visible"] = "바 배경 보이기"
L["Bar Blend Mode"] = "바 혼합 모드"
L["Bar color"] = "바 색상"
L["Bar Font Bold"] = "바 글꼴 굵게"
L["Bar Font Size"] = "바 글꼴 크기"
L["Bar Height"] = "바 높이"
L["Bar horizontal adjust"] = "바 수평 조정"
L["Bar name"] = "바 이름"
L["Bar Proportion"] = "바 비율"
L["Bar Settings"] = "바 설정"
L["Bar Space"] = "바 간격"
L["Bar Texture"] = "바 무늬"
L["Bar texture height (not the actual bar!)"] = "바 무늬 높이 (실제 바는 아님!)"
L["Bar Texture Override"] = "바 질감 재정의"
L["Bar texture width (not the actual bar!)"] = "바 무늬 너비 (실제 바는 아님!)"
L["Bar vertical offset"] = "바 수직 보정값"
L["Bar visible"] = "바 보이기"
L["Bar Width"] = "바 너비"
L["Bar width modifier"] = "바 너비 수정"
L["BG Alpha in combat"] = "전투 중 배경 투명도"
L["BG Alpha OOC and not Full"] = "비전투 시 및 손실 바 배경 투명도"
L["BG Alpha OOC and Target"] = "비전투 시 및 대상의 배경 투명도"
L["BG Alpha out of combat"] = "비전투 시 배경 투명도"
L["Blizzard currently does not provide a proper way to right-click dismiss a pet with custom unit frames."] = "블리자드는 현재 사용자 유닛 프레임의 소환수 소환해제를 마우스 우클릭으로 하는 적절한 방법을 제공하고 있지 않습니다."
L["Blizzard currently does not provide a proper way to right-click focus with custom unit frames."] = "블리자드는 현재 사용자 유닛 프레임의 주시대상을 마우스 우클릭으로 하는 적절한 방법을 제공하고 있지 않습니다."
L["Blizzard currently does not provide a proper way to right-click report someone AFK with custom unit frames."] = "블리자드는 현재 사용자 유닛 프레임의 누군가 자리비움 보고를 마우스 우클릭으로 하는 적절한 방법을 제공하고 있지 않습니다."
L["Broadcasts crowd control effects you apply to your target via the party chat channel"] = "파티 채팅 채널을 통해 대상에 적용한 군중 제어 효과를 방송합니다."
L["Buff anchor to"] = "버프 고정점"
L["Buff grow direction"] = "버프 성장 방향"
L["Buff horizontal offset"] = "버프 수평 위치"
L["Buff or debuff?"] = "버프 또는 디버프?"
L["Buff placement settings"] = "버프 배치 설정"
L["Buff Settings"] = "버프 설정"
L["Buff size"] = "버프 크기"
L["Buff timer display"] = "버프 시간 표시"
L["Buff vertical offset"] = "버프 수직 위치"
L["Buff zoom"] = "버프 확대."
L["Buff/debuff icon size"] = "버프/디버프 아이콘 크기"
L["Buff/debuff icon zoom"] = "버프/디버프 아이콘 확대"
L["Buff/Debuff Settings"] = "버프/디버프 설정"
L["Buff/debuff size for buffs/debuffs that were applied by you, the player"] = "플레이어인 사용자가 적용한 버프/디버프에 대한 버프/디버프 크기"
L["Buffs / row"] = "버프 / 열"
L["Cannot report AFK from addons"] = "애드온에서 자리비움 보고를 할 수 없습니다"
L["Change color"] = "색상 변경"
L["Change color when not in range"] = "유효 거리 밖일 때 색상 변경"
L["Changes the bar color to the CastNotInRange color when the target goes out of range for the current spell."] = "대상이 현재 주문의 범위를 벗어날 때 바의 색상을 '시전 범위 내 없음' 색상으로 변경합니다."
L[ [=[Changes the color of this bar to be the minimum health or mana color when it's below the low threshold. See the 'MinHealthColor' and 'MinManaColor' colors in the 'Colors' option page.

This option only applies to health and mana bars.]=] ] = [=[이 바의 색상이 낮은 입계값 미만인 경우 최소 체력 또는 마나 색상으로 변경핳빈다. '색상' 설정 페이지에서 'MinHealthColor' 및 'MinManaColor' 색상을 참조하십시오.

이 설정은 체력과 마나 바에만 적용됩니다.]=]
L["Checking this means that only buffs or debuffs that the player applied will trigger this bar"] = "이 항목을 선택하면 플레이어가 적용한 버프 또는 디버프 만이 바를 작동시킨다는 것을 의미합니다"
L["Choose a marker to edit. This will place the marker's settings in the fields above here."] = "편집할 표식을 선택하십시오. 이렇게 하면 이 위의 필드에 표식 설정이 배치됩니다."
L["Choose whether the runes use a cooldown-style wipe, simply an alpha fade to show availability or both."] = "룬을 재사용 대기시간-방식으로 사용할지, 단순히 투명도 사라짐 방식으로 할지, 아니면 둘 다 표시할지 선택합니다."
L["Choose whether the totems use a cooldown-style wipe or simply an alpha fade to show availability."] = "토템을 재사용 대기시간-방식으로 사용할지, 단순히 투명도 사라짐 방식으로 표시할지 선택합니다."
L[ [=[Choose whether you'd like a graphical or numeric representation of the runes.

NOTE: The color of 'Numeric' mode can be controlled by the HolyPowerNumeric color.]=] ] = [=[룬을 그래픽으로 표시할지 숫자로 표시할지 선택하십시오.

참고: '숫자' 방식의 색상은 HolyPowerNumeric 색상으로 제어할 수 있습니다.]=]
L[ [=[Choose whether you'd like a graphical or numeric representation of the runes.

NOTE: The color of 'Numeric' mode can be controlled by the ShardCounterNumeric color.]=] ] = [=[룬을 그래픽으로 표시할지 숫자로 표시할지 선택하십시오.

참고: '숫자' 방식의 색상은 ShardCounterNumeric 색상으로 제어할 수 있습니다.]=]
L["Class color bar"] = "직업 색상 바"
L["Classification icon"] = "분류 아이콘"
L[ [=[Click the + next to |cffffdc42Module Settings|r to see the available modules that you can tweak.

Also notice that some modules have a + next to them. This will open up additional settings such as text tweaks and icon tweaks on that module.]=] ] = [=[조정할 수 있는 사용 가능한 모듈을 보려면 모듈 설정 옆에 있는 +를 클릭하십시오.

또한 일부 모듈에는 옆에 +가 있습니다. 해당 모듈의 글자 조정 및 아이콘 조정과 같은 추가 설정이 열립니다.]=]
L["Click to open IceHUD options."] = "클릭하면 IceHUD 옵션을 엽니다."
L["Color"] = "색상"
L["Color bar by health %"] = "생명력 %에 대한 색상 바"
L["Color bar by mana %"] = "마나 %에 대한 색상 바"
L["Color NPC by hostility"] = "적대적인 NPC 색상"
L["Colors"] = "색상"
L["Colors the health bar from MaxHealthColor to MinHealthColor based on current health %"] = "현재 생명력 %에 기반하여 생명력 바를 최대 생명력 색상에서 최저 생명력 색상으로 색상화합니다."
L[ [=[Colors the health bar from MaxHealthColor to MinHealthColor based on current health %

(Note: This overrides the 'class color bar' setting. Disable this to use class coloring)]=] ] = [=[현재 생명력 %에 기반하여 생명력 바를 최대 생명력 색상에서 최저 생명력 색상으로 색상화합니다.

(참고 : 이것은 '직업 색상 바' 설정보다 우선합니다. 직업 색상화를 사용하려면 이것을 비활성화하세요.)]=]
L["Colors the mana bar from MaxManaColor to MinManaColor based on current mana %"] = "현재 마나 %에 기반하여 마나 바를 최대 마나 색상에서 최저 마나 색상으로 색상화합니다."
L["Combo gap"] = "연계 간격"
L["Combo Points Font Size"] = "연계 점수 글꼴 크기"
L["Configuration Mode"] = "환경설정 모드"
L["Contextual Background"] = "상황별 배경"
L["Controls what it means for the bar to be filled. A normal bar will grow larger as the value grows from 0% to 100%. A reversed bar will shrink as the value grows from 0% to 100%."] = "바가 채워지는 것이 무엇을 의미하는지 제어합니다. 값이 0%에서 100%로 증가함에 따라 일반 바가 커집니다. 값이 0%에서 100%로 증가함에 따라 반전 된 바가 줄어 듭니다."
L["Controls which direction the bar fills up. With this checked, the bar will fill opposite from normal (e.g. for health: 0% at the top, 100% at the bottom)."] = "바가 채워지는 방향을 조정합니다. 이 옵션을 선택하면 바가 정상과 반대 방향으로 채워집니다 (예 : 생명력: 상단 0%, 하단 100%)."
L["Cooldown"] = "재사용 대기시간"
L["Cooldown timer display"] = "재사용 대기시간 표시"
L["Cooldown type"] = "재사용 대기시간 형태"
L["Count color"] = "숫자 색상"
L["Count minimum color"] = "최소 색상 수"
L["Counter"] = "중첩"
L["Counter look and feel"] = "중첩 모양과 느낌"
L["Counter name"] = "중첩 이름"
L["CounterBar"] = "중첩바"
L["Create"] = "생성"
L["Create custom module"] = "사용자 모듈 생성"
L["Create marker"] = "마커 생성"
L["Create or remove markers at various points along the bar here"] = "여기서 바에 따라 다양한 지점에 표식을 생성 또는 제거"
L["Creates a new marker with the chosen settings."] = "선택한 설정으로 새 표식을 생성합니다."
L["Creates a new module of this same type and with all the same settings."] = "같은 유형 및 모두 같은 설정으로 새 모듈을 생성합니다."
L["Creates the selected custom module"] = "선택한 사용자 정의 모듈을 생성"
L["Custom bar settings"] = "사용자 바 설정"
L["Custom CD settings"] = "사용자 재사용 대기시간 설정"
L["Custom color"] = "사용자 색상"
L["Custom minimum color"] = "사용자 최소 색상"
L["Custom unit"] = "사용자 유닛"
L["Debuff anchor to"] = "디버프 기준점"
L["Debuff grow direction"] = "디버프 확장 방향"
L["Debuff horizontal offset"] = "디버프 수평 보정값"
L["Debuff placement settings"] = "디버프 배치 설정"
L["Debuff Settings"] = "디버프 설정"
L["Debuff size"] = "디버프 크기"
L["Debuff vertical offset"] = "디버프 수직 보정값"
L["Debugging"] = "디버깅"
L["Defines when cast bar should flash on failed spells"] = "실패한 주문에서 시전바가 반짝이는 시기를 정의합니다"
L["Defines when cast bar should flash on instant spells"] = "즉시시전 주문에서 시전바가 반짝이는 시기를 정의합니다"
L["Delete me"] = "삭제하기"
L["Deletes this custom module and all associated settings. Cannot be undone!"] = "사용자 모듈 및 모든 관련 설정을 삭제합니다. 돌이킬 수 없음!"
L["Determines the bar width compared to the whole texture width"] = "전체 질감 너비와 비교하여 바 너비를 결정합니다"
L["Display aura icon"] = "아이콘 표시"
L["Display mode"] = "모드 표시"
L["Display Mode"] = "모드 표시"
L["Display non-interruptible color"] = "차단 불가 색상 표시"
L["Display target details"] = "대상 상세 표시"
L["Display target guild"] = "대상 길드 표시"
L["Display target name"] = "대상 이름 표시"
L["Display when empty"] = "비워있을 때 표시"
L["Display when targeting"] = "겨냥중일때 표시"
L["Distance between the left and right bars"] = "왼쪽과 오른쪽 바 사이의 거리"
L[ [=[DogTag-formatted string to use for the bottom text line (leave blank to revert to old behavior)

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[하단 텍스트 행에 사용할 DogTag 형식 문자열 (이전 동작으로 되돌리려면 공백으로 두세요.)

사용 가능한 태그 목록을 보려면 /dogtag을 입력하세요.

이 공간을 채운 후 승인을 눌러야합니다. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[DogTag-formatted string to use for the left side of the bar.

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[바의 좌측 면에 사용할 DogTag 형식 문자열입니다.

사용 가능한 태그 목록을 보려면 /dogtag을 입력하세요.

이 공간을 채운 후 승인을 눌러야합니다. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[DogTag-formatted string to use for the range display (only available if LibDogTag is being used)

Type /dogtag for a list of available tags]=] ] = [=[거리 표시에 사용할 DogTag 형식 문자열 (LibDogTag을 사용중인 경우에만 사용 가능)

사용 가능한 태그 목록을 보려면 /dogtag을 입력하세요.]=]
L[ [=[DogTag-formatted string to use for the right side of the bar.

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[바의 우측 면에 사용할 DogTag 형식 문자열.

사용 가능한 태그 목록을 보려면 /dogtag을 입력하세요.

이 공간을 채운 후 승인을 눌러야합니다. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[DogTag-formatted string to use for the second text line (leave blank to revert to old behavior)

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[두 번째 글자 줄에 사용할 DogTag-형식 문자열 (기존 동작으로 되돌리려면 공백으로 두십시오)

사용 가능한 태그 목록을 보려면 /dogtag를 입력하십시오.

이 상자를 채운 후 수락을 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[DogTag-formatted string to use for the third text line (leave blank to revert to old behavior)

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[세 번째 글자 줄에 사용할 DogTag-형식 문자열 (기존 동작으로 되돌리려면 공백으로 두십시오)

사용 가능한 태그 목록을 보려면 /dogtag를 입력하십시오.

이 상자를 채운 후 수락을 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[DogTag-formatted string to use for the top text line (leave blank to revert to old behavior)

Type /dogtag for a list of available tags.

Remember to press Accept after filling out this box or it will not save.]=] ] = [=[상단 글자 줄에 사용할 DogTag-형식 문자열 (기존 동작으로 되돌리려면 공백으로 두십시오)

사용 가능한 태그 목록을 보려면 /dogtag를 입력하십시오.

이 상자를 채운 후 수락을 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Draw Elite Icon On Top"] = "앞쪽에 정예 아이콘 그리기"
L["Draw PVP Icon on top"] = "앞쪽에 PVP 아이콘 그리기"
L["Draw Raid Icon On Top"] = "앞쪽에 전술 목표 아이콘 그리기"
L["Duplicate me"] = "복사본 만들기"
L["Edit Marker"] = "마커 편집"
L["Elite Icon Scale"] = "정예 아이콘 크기"
L["Elite Icon X Offset"] = "정예 아이콘 X 좌표"
L["Elite Icon Y Offset"] = "정예 아이콘 Y 좌표"
L["Enable/disable debug messages"] = "디버그 메세지 사용함/사용안함"
L["Enable/disable IceHUD"] = "IceHUD 사용함/사용안함"
L["Enable/disable module"] = "모듈 사용함/사용안함"
L["Enabled"] = "사용함"
L["Energy Ticker Alpha"] = "기력 눈끔 투명도"
L[ [=[Enter which unit that this bar should be monitoring the health of (e.g.: focustarget, pettarget, etc.)

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 바가 체력을 감시할 유닛(예: focustarget, pettarget 등)을 입력하십시오.

이 상자에 원하는 이름으로 채운 후 ENTER 키 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[Enter which unit that this bar should be monitoring the mana of (e.g.: focustarget, pettarget, etc.)

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 바가 마나를 감시할 유닛(예: focustarget, pettarget 등)을 입력하십시오.

이 상자에 원하는 이름으로 채운 후 ENTER 키 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Error: IceHUD database not loaded correctly.  Please exit out of WoW and delete the database file (IceHUD.lua) found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\"] = "오류: IceHUD 데이터베이스를 올바르게 불러오지 못했습니다.  'WoW를 종료하고 \\\\World of Warcraft\\\\WTF\\\\Account\\\\<계정 이름>\\\\SavedVariables\\\\'에 있는 데이터베이스 파일(IceHUD.lua)를 찾아 삭제하십시오."
L["Exact match only"] = "정확히 일치하는 것만"
L["Export profile"] = "프로필 내보내기"
L["Exports your active profile to something you can copy and paste to another user or use on another account."] = "활성 프로필을 다른 계정에서 사용하거나 다른 사용자에게 복사하고 붙여넣기 할 수 있도록 내보냅니다."
L["FAQs"] = "자주 묻는 질문"
L["Flash bar below Low Threshold"] = "수치 아래의 반짝임 바"
L["Flash Instant Spells"] = "즉시시전 주문 반짝임"
L["Flash on Spell Failures"] = "주문 실패 시 반짝임"
L["Flash when ready"] = "준비되면 반짝임"
L["Flashes the bar when it is below the Low Threshold specified above"] = "위에 지정된 최저 수치 아래에 있을 때 바가 반짝입니다."
L["Font"] = "글꼴"
L["Font Size"] = "글꼴 크기"
L["Force Text Justification"] = "강제 문자 맞춤"
L["Friendly OOC alpha"] = "우호적 비전투 투명도"
L["Gap"] = "간격"
L["Gap between Upper and Lower text vertically"] = "수직 문자의 위 아래 사이의 간격"
L["General Settings"] = "일반 설정"
L["Height"] = "높이"
L["Hide Blizzard Buffs"] = "블리자드 버프 숨김"
L["Hide Blizzard Frame"] = "블리자드 프레임 숨김"
L["Hide Blizzard Party"] = "블리자드 파티 프레임  숨김"
L["Hide during pet battles"] = "애완동물 대전 중 숨김"
L["Hide during shell game"] = "껍질놀이 중 숨김"
L["Hide in barbershops"] = "미용실에서 숨김"
L[ [=[Hides Blizzard Arcane Charges frame and disables all events related to it.

NOTE: Blizzard attaches the arcane charges UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 비전 충전물 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다.

참고: 블리자드의 비전 충전물 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L["Hides Blizzard Focus frame and disables all events related to it"] = "블리자드 주시 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다"
L[ [=[Hides Blizzard frame and disables all events related to it.

NOTE: Blizzard attaches this UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다.

참고: 블리자드의 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L[ [=[Hides Blizzard Harmony Power frame and disables all events related to it.

NOTE: Blizzard attaches the harmony power UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 자연 친화 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다.

참고: 블리자드의 자연 친화 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L[ [=[Hides Blizzard Holy Power frame and disables all events related to it.

NOTE: Blizzard attaches the holy power UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 신성한 힘 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다.

참고: 블리자드의 신성한 힘 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L["Hides Blizzard Player frame and disables all events related to it"] = "블리자드의 플레이어 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다"
L["Hides Blizzard Rune frame and disables all events related to it"] = "블리자드의 룬 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다"
L[ [=[Hides Blizzard Shadow Orb frame and disables all events related to it.

NOTE: Blizzard attaches the shadow orb UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 어둠의 구슬 프레임을 숨기고 관련된 모든 이벤트를 비활성화합니다.

참고: 블리자드의 어둠의 구슬 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L[ [=[Hides Blizzard shard frame and disables all events related to it.

NOTE: Blizzard attaches the shard UI to the player's unitframe, so if you have that hidden in PlayerHealth, then this won't do anything.]=] ] = [=[블리자드의 조각 프레임을 숨기고 관련되 모든 이벤트를 비활성화합니다.

참고: 블리자드의 조각 UI는 플레이어의 유닛 프레임에 붙어 있으며, 따라서 PlayerHealth가 숨겨져 있으면, 아무것도 하지 않습니다.]=]
L["Hides Blizzard Target frame and disables all events related to it"] = "블리자드 대상 프레임 숨기고 관련된 모든 이벤트를 비활성화합니다"
L["Hides Blizzard's default buffs frame and disables all events related to it"] = "블리자드의 기본 버프 프레임 숨기고 관련된 모든 이벤트를 비활성화합니다"
L["Hides Blizzard's default party frame and disables all events related to them"] = "블리자드의 기본 파티 프레임 숨기고 관련된 모든 이벤트를 비활성화합니다"
L["Horizontal Position"] = "수평 위치"
L["Horizontal position"] = "수평 위치"
L["Horizontal position (for you dual screen freaks)"] = "수평 위치 (듀얼 스크린 사용자용)"
L["How far horizontally the buff frame should be offset from the anchor"] = "버프 프레임을 기준점으로부터 보정할 수평 거리 값"
L["How far horizontally the debuff frame should be offset from the anchor"] = "디버프 프레임을 기준점으로부터 보정할 수평 거리 값"
L["How far to offset the numeric display up or down."] = "숫자 표시를 상하로 보정할 거리 값"
L["How far to push the elite icon right or left"] = "정예 아이콘을 좌우로 밀어낼 거리 값"
L["How far to push the elite icon up or down"] = "정예 아이콘을 상하로 밀어낼 거리 값"
L["How far to push the raid icon right or left"] = "전술 목표 아이콘을 좌우로 밀어낼 거리 값"
L["How far to push the raid icon up or down"] = "전술 목표 아이콘을 상하로 밀어낼 거리 값"
L["How far vertically the buff frame should be offset from the anchor"] = "버프 프레임을 기준점으로부터 보정할 수직 거리 값"
L["How far vertically the debuff frame should be offset from the anchor"] = "디버프 프레임을 기준점으로부터 보정할 수직 거리 값"
L["How long the animation should take to play"] = "애니메이션이 재생되는데 소요되는 시간"
L["How many buffs/debuffs is shown on each row"] = " 행에 표시되는 버프/디버프 개수"
L[ [=[How many total applications of this buff/debuff can be applied. For example, only 5 sunders can ever be on a target, so this would be set to 5 for tracking Sunder.

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 버프/디버프에 적용 가능한 중첩 수는. 예로, 가르기 5중첩만 대상에 있을 수 있으므로, 이것은 가르기를 추적하기 위해 5로 설정됩니다.

이 상자에 원하는 이름으로 채운 후 ENTER 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["How much space should be between each buff or debuff icon."] = "각 버프 또는 디버프 아이콘 사이의 공간 수치입니다."
L["How much to offset the leader icon from the bar horizontally"] = "바에서 리더 아이콘을 수평으로 보정할 수치"
L["How much to offset the leader icon from the bar vertically"] = "바에서 리더 아이콘을 수직으로 보정할 수치"
L["How much to offset the loot master icon from the bar horizontally"] = "바에서 전리품 담당 아이콘을 수평으로 보정할 수치"
L["How much to offset the loot master icon from the bar vertically"] = "바에서 전리품 담당 아이콘을 수직으로 보정할 수치"
L["How much to offset the Party Role icon from the bar horizontally"] = "바에서 파티 역할 아이콘을 수평으로 보정할 수치"
L["How much to offset the Party Role icon from the bar vertically"] = "바에서 파티 역할 아이콘을 수직으로 보정할 수치"
L["How much to offset the PvP icon from the bar horizontally"] = "바에서 PvP 아이콘을 수평으로 보정할 수치"
L["How much to offset the PvP icon from the bar vertically"] = "바에서 PvP 아이콘을 수직으로 보정할 수치"
L["How much to offset the status icon (resting/combat) from the bar horizontally"] = "바에서 상태 아이콘(휴식/전투)을 수평으로 보정할 수치"
L["How much to offset the status icon (resting/combat) from the bar vertically"] = "바에서 상태 아이콘(휴식/전투)을 수직으로 보정할 수치"
L["How much to scale the elite icon"] = "정예 아이콘 비율의 수치"
L["How much to scale the leader icon"] = "리더 아이콘 비율의 수치"
L["How much to scale the loot master icon"] = "전리품 담당 아이콘 비율의 수치"
L["How much to scale the Party Role icon"] = "파티 역할 아이콘 비율의 수치"
L["How much to scale the PvP icon"] = "PvP 아이콘 비율의 수치"
L["How much to scale the raid icon"] = "대상 표시기 아이콘 비율의 수치"
L["How much to scale the status icon"] = "상태 아이콘 비율의 수치"
L["How the graphical combo points should be displayed"] = "그래픽으로 연계 점수를 표시하는 방식"
L["How the graphical counter should be displayed"] = "그래픽으로 중첩을 표시하는 방식"
L["How to display the buff timer next to the name of the buff on the bar"] = "바의 버프 이름 다음에 버프 타이머를 표시하는 방식"
L["HUD scale"] = "HUD 크기 비율"
L["IceHUD"] = "IceHUD"
L["IceHUD Bar Background Blend mode"] = "IceHUD 바 배경 혼합 방식"
L["IceHUD Bar Blend mode"] = "IceHUD 바 혼합 방식"
L["IceHUD Bar Texture"] = "IceHUD 바 질감"
L["IceHUD Font"] = "IceHUD 글꼴"
L["Icon config mode"] = "아이콘 구성 방식"
L["Icon gap"] = "아이콘 간격"
L["Icon set"] = "아이콘 세트"
L["Icon Settings"] = "아이콘 설정"
L["Icon size"] = "아이콘 크기"
L["Icon size for auras that were applied by you, the player"] = "본인이 사용한 오라의 아이콘 크기 설정"
L["If the selected ability has a max range or only works on friendly units, this will ignore that check. Meaning you can use a CD bar for buff spells and it will display when you have an enemy targeted."] = "선택한 능력이 최대 범위를 가지고 있거나 아군 유닛에서만 작동하는 경우 해당 검사를 무시합니다. 버프 주문에는 CD바를 사용할 수 있으며, 적을 대상으로 할 때 표시됩니다."
L["If this is checked, then a health value of 1100 will display as 1.1k, otherwise it shows the number"] = "이것을 선택하면, 1100의 체력 값이 1.1k로 표시되고, 그렇지 않으면 숫자가 표시됩니다"
L[ [=[If this is checked, then a health value of 1100 will display as 1.1k, otherwise it shows the number

Note: this only applies if you are NOT using DogTag]=] ] = [=[이것을 선택하면, 1100의 체력 값이 1.1k로 표시되고, 그렇지 않으면 숫자가 표시됩니다

참고: DogTag를 사용하지 않는 경우에만 적용됩니다]=]
L["If this is checked, then the bar uses different colors depending on how many RtB buffs you have"] = "이것을 선택하면, 바의 '뼈주사위' 버프 수에 따라 바가 다른 색상을 사용합니다"
L["If this is checked, then the buff name must be entered exactly as the full buff name. Otherwise, you can use only a portion of the name such as 'Sting' to track all stings."] = "이것을 선택하면, 버프 이름을 전체 버프 이름과 동일하게 입력해야 합니다. 그렇지 않으면, '찌르기'와 같은 이름의 일부만 사용하여 모든 찌르기를 추적할 수 있습니다."
L["If this is checked, then the counter will use your 'out of target' alpha when targeting someone who is friendly."] = "이것을 선택하면, 중첩은 아군인 누군가를 대상으로 할 때 당신의 '범위 밖 대상남' 투명도를 사용합니다."
L["If this is checked, then the RtB buff time shows as a percent of the maximum attainable (taking set bonuses and talents into account). Otherwise, the bar always goes from full to empty when applying RtB no matter the duration."] = "이것을 선택하면, '뼈주사위' 버프 시간이 최대 달성 가능 시간의 백분율로 표시됩니다 (설정된 보너스 및 재능을 고려). 그렇지 않으면, 지속시간에 관계없이 '뼈주사위'를 적용할 때 바가 항상 가득 찬 상태에서 비어 있는 상태로 전환됩니다."
L["If this is checked, then the SnD buff time shows as a percent of the maximum attainable (taking set bonuses and talents into account). Otherwise, the bar always goes from full to empty when applying SnD no matter the duration."] = "이것을 선택하면, '난도질' 버프 시간이 최대 달성 가능 시간의 백분율로 표시됩니다 (설정된 보너스 및 재능을 고려). 그렇지 않으면, 지속시간에 관계없이 '난도질'을 적용할 때 바가 항상 가득 찬 상태에서 비어 있는 상태로 전환됩니다."
L["If this is checked, then whenever the counter is maxed out it will gently pulsate to let you know it's ready to be used."] = "이것을 선택하면, 중첩이 최대가 될 때마다 사용할 준비가 되었음을 알려주기 위해 부드럽게 진동합니다."
L["If this is disabled, then targeting a friendly will use the 'Alpha out of combat' setting instead of 'Alpha OOC and Target'."] = "이 기능을 사용하지 않으면 아군을 대상으로 '비전투 중과 대상 투명도' 대신 '비전투 중 투명도' 설정이 사용됩니다."
L["If this is set, the numeric value of the current rune count will show on top of the runes display."] = "이것이 설정되면, 룬 표시기 위에 현재 룬 중첩의 숫자 값이 표시됩니다."
L["If you are using the 'class color bar' setting above, then enabling this will color NPC's by their hostility toward you since NPC class isn't very helpful or applicable information."] = "위의 '직업 색상 바' 설정을 사용하는 경우, NPC의 직업은 별로 도움이 되지 않거나 적용 가능한 정보가 아니기 때문에, 이 설정을 사용하면 NPC가 적대적인 색상이 됩니다."
L["If you have game default font selected, this option has no effect"] = "게임 기본 글꼴을 선택한 경우, 이 설정은 영향을 받지 않습니다"
L["If your class power is not full (or not empty in the case of Holy Power) then the module will always be displayed on your screen using the In Combat alpha setting. Otherwise it will fade to the OOC alpha when you leave combat."] = "직업 자원이 가득 차지 않을 경우(신성한 힘의 경우 비어있지 않을 때), 모듈은 항상 '전투 중 투명도' 설정을 사용하여 화면에 표시됩니다. 그렇지 않으면 전투를 떠날 때 '비전투 중 투명도'로 흐려집니다."
L["Ignore range"] = "거리 무시"
L["Import profile"] = "프로필 가져오기"
L["Imports a profile as exported from another user's IceHUD."] = "다른 사용자의 IceHUD에서 내보낸 프로필을 가져옵니다."
L["Inactive mode"] = "비활성화 모드"
L["Incoming heal bar alpha"] = "들어오는 치료 바의 투명도"
L["Invert bar"] = "바 반전"
L["Item to track"] = "추적할 항목"
L["Lacerate Count Font Size"] = "가르기 중첩 글꼴 크기"
L["Lacerate gap"] = "가르기 간격"
L["Lag Indicator alpha"] = "렉 표시기 투명도"
L["Lag indicator alpha (0 is disabled)"] = "렉 표시기 투명도 (0은 미사용)"
L["Layout"] = "레이아웃"
L["Leader icon"] = "리더 아이콘"
L["Leader Icon Horizontal Offset"] = "리더 아이콘 수평 보정값"
L["Leader Icon Scale"] = "리더 아이콘 비율"
L["Leader Icon Vertical Offset"] = "리더 아이콘 수직 보정값"
L["Left Tag"] = "왼쪽 태그"
L["Line 1 tag"] = "첫 번째 줄 태그"
L["Line 2 tag"] = "두 번째 줄 태그"
L["Line 3 tag"] = "세 번째 줄 태그"
L["Line 4 tag"] = "네 번째 줄 태그"
L["Lock all icons to 100% alpha"] = "모든 아이콘 투명도를 100%로 고정합니다"
L["Lock Bar Text Alpha"] = "바의 문자 투명도 고정"
L["Lock Lower Text Alpha"] = "아래쪽 글자 투명도 고정"
L["Lock raid icon to 100% alpha"] = "전술 목표 아이콘 투명도를 100%로 고정합니다"
L["Lock Upper Text Alpha"] = "위쪽 글자 투명도 알파 고정"
L["Locks lower text alpha to 100%"] = "아래쪽 글자의 투명도를 100%로 고정합니다"
L["Locks text alpha to 100%"] = "글자 투명도 100%로 고정"
L["Locks upper text alpha to 100%"] = "위쪽 글자의 투명도를 100%로 고정합니다"
L["Look and Feel"] = "모양과 느낌"
L["Loot Master icon"] = "전리품 담당 아이콘"
L["Loot Master Icon Horizontal Offset"] = "전리품 담당 아이콘 수평 보정값"
L["Loot Master Icon Scale"] = "전리품 담당 아이콘 비율"
L["Loot Master Icon Vertical Offset"] = "전리품 담당 아이콘 수직 보정값"
L["Low Threshold"] = "낮은 임계값"
L["Low Threshold color"] = "낮은 임계값 색상"
L["Lower Text"] = "아래쪽 글자"
L["Lower Text Color"] = "아래쪽 글자 색상"
L["Lower text visible"] = "아래쪽 글자 보이기"
L["Maelstrom Count Font Size"] = "소용돌이치는 무기 중첩 글꼴 크기"
L["Maelstrom gap"] = "소용돌이치는 무기 간격"
L["Make this bar wider or thinner than others"] = "이 바를 다른 것 보다 넓거나 얇게 만듭니다"
L["Makes all modules visible so you can see where they're placed and find any that are overlapping."] = "모든 모듈을 표시하여 배치된 위치를 보고 겹치는 부분을 찾을 수 있습니다."
L["Marker Settings"] = "표식 설정"
L["Maximum applications"] = "최대 적용"
L["Maximum duration"] = "최대 지속 시간"
L[ [=[Maximum Duration for the bar (the bar will remained full if it has longer than maximum remaining).  Leave 0 for spell duration.

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[바의 최대 지속 시간 (남은 최대 시간보다 길면 바가 가득 찬 상태로 유지됨). 주문 지속 시간을 0으로 두십시오.

이 상자에 원하는 이름으로 채운 후 ENTER 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Minimum stacks to show"] = "표시할 최소 중첩"
L["Module color configuration options"] = "모듈 색상 구성 설정"
L["Module configuration options"] = "모듈 구성 설정"
L["Module options"] = "모듈 선택"
L["Module Settings"] = "모듈 설정"
L["Module type:"] = "모듈 유형:"
L["Mouse settings"] = "마우스 설정"
L["Mouseover"] = "마우스오버"
L["Mouseover for buffs"] = "버프에 마우스오버"
L["Mouseover for target"] = "대상에 마우스오버"
L["No decoration"] = "장식 없음"
L["Number of updates per second. The higher this number is, the smoother bars will animate. However, higher settings will also use more CPU, so balance it to your liking. 30 is the recommended setting."] = "초당 업데이트 수. 숫자가 높을수록 바가 더 부드럽게 나타나지만, 높은 설정일수록 CPU 소모가 큽니다. 따라서, 적정한 숫자를 설정하십시오. 30은 추천 설정."
L["Numeric vertical offset"] = "숫자 수직 보정값"
L["Offset"] = "보정값"
L["Offset of the bar"] = "바의 보정값"
L["Offset of the text from the bar horizontally"] = "바에서 수평의 글자 보정값"
L["Offset of the text from the bar vertically (negative is farther below)"] = "바에서 수직의 글자 보정값 (음수는 더 아래)"
L["Only show buffs by me"] = "내가 시전한 버프만 보여주기"
L["Only show debuffs by me"] = "내가 시전한 디버프만 보여주기"
L["Only show for my debuffs"] = "나의 디버프만 보여주기"
L["Only show if target uses mana"] = "대상이 마나를 소모할 때만 보여주기"
L["Only show in groups"] = "파티 안에서만 표시"
L["Only show the bar when the number of applications of this buff or debuff exceeds this number"] = "이 버프 또는 디버프의 적용 횟수가 이 수를 초과할 경우 바를 표시합니다"
L["Only show the threat bar if you are in a group or you have an active pet"] = "파티에 있거나 소환수가 있을 경우에만 위협바를 표시합니다."
L["Only show with a target selected"] = "대상이 선택된 경우에만 표시"
L["Only track auras by me"] = "내가 사용한 효과만 추적"
L["Other"] = "기타"
L["Outline"] = "외곽선"
L["Override alpha when not full"] = "가득 차지 않을 때 투명도 재정의"
L["Override global texture"] = "역 질감 재정의"
L["Own buff size"] = "자신의 버프 크기"
L["Own debuff size"] = "자신의 디버프 크기"
L["Party Role icon"] = "파티 역할 아이콘"
L["Party Role Icon Horizontal Offset"] = "파티 역할 아이콘 수평 보정값"
L["Party Role Icon Scale"] = "파티 역할 아이콘 비율"
L["Party Role Icon Vertical Offset"] = "파티 역할 아이콘 수직 보정값"
L["Position (percent)"] = "위치 (백분율)"
L["Positioning Settings"] = "자리 배치 설정"
L["Potential RtB time bar alpha"] = "잠재적 뼈 주사위 타이머 바 투명도"
L["Potential SnD time bar alpha"] = "잠재적 난도질 타이머 바 투명도"
L["Predefined settings for different bars"] = "다른 바에 대한 사전 정의된 설정"
L["Presets"] = "사전 설정"
L["Pulse when full"] = "가득 차면 맥박"
L["PvP icon"] = "PvP 아이콘"
L["PvP Icon Horizontal Offset"] = "PvP 아이콘 수평 보정값"
L["PvP Icon Scale"] = "PvP 아이콘 비율"
L["PvP Icon Vertical Offset"] = "PvP 아이콘 수직 보정값"
L["Raid icon"] = "대상 표시기 아이콘"
L["Raid Icon Scale"] = "대상 표시기 아이콘 비율"
L["Raid Icon X Offset"] = "대상 표시기 아이콘 X 보정값"
L["Raid Icon Y Offset"] = "대상 표시기 아이콘 Y 보정값"
L["Range string"] = "거리 문자"
L["Remove"] = "제거"
L["Respect lag tolerance"] = "지연 오차 허용"
L["Reverse channeling"] = "채널링 뒤집기"
L["Reverse direction"] = "방향 뒤집기"
L["Right Tag"] = "우측 태그"
L["Rotate 90 degrees"] = "90도 회전하기"
L["Rune cooldown mode"] = "룬 재사용 대기시간 방식"
L["Rune display mode"] = "룬 표시 방식"
L["Rune gap"] = "룬 간격"
L["Rune orientation"] = "룬 방향"
L["Scale"] = "비율"
L["Scale for non-mana users"] = "비마나 유저에 대한 비율"
L["Scale of the bar"] = "바의 비율"
L["Scale of the element"] = "요소의 비율"
L["Second place threat alpha"] = "2위 위협 투명도"
L["Select a custom module that you want to create here, then press the 'Create' button."] = "여기에서 생성할 사용자 모듈을 선택한 다음 '생성' 버튼을 누르십시오."
L["Select which unit that this bar should be looking for buffs/debuffs on"] = "이 바가 버프/디버프를 찾아야하는 유닛을 선택합니다"
L["Self Color"] = "자신 색상"
L["Self Display Mode"] = "자신 표시 방식"
L["Set the color of the TargetTarget bar if you are your target's target."] = "대상의 대상인 경우 TargetTarget 바의 색상을 설정합니다."
L["Sets the height of this module."] = "이 모듈의 높이를 설정합니다."
L["Sets the width of this module if 'size to gap' is not set"] = "'간격에 크기'가 설정되지 않은 경우 이 모듈의 너비를 설정합니다"
L["Settings for bar transparencies"] = "바 투명도에 대한 설정"
L["Settings related to bars"] = "바에 관련된 설정"
L["Settings related to icons"] = "아이콘에 관련된 설정"
L["Settings related to positioning and alpha"] = "위치와 투명도에 관련된 설정"
L["Settings related to texts"] = "글자에 관련된 설정"
L["Shadow"] = "그림자"
L["Show absorbs"] = "흡수 표시"
L["Show Anticipation"] = "예측 표시"
L["Show bar as % of maximum"] = "바를 최대값의 %로 표시"
L["Show buffs"] = "버프 표시"
L["Show combat status"] = "전투 상태 표시"
L["Show debuffs"] = "디버프 표시"
L["Show default cast bar"] = "기본 시전 바 표시"
L["Show during cast"] = "시전 중 표시"
L["Show Elite Icon"] = "정예 아이콘 표시"
L["Show graphical or numeric combo points"] = "그래픽 또는 숫자 연계 점수 표시"
L["Show graphical or numeric counts"] = "그래픽 또는 중첩 숫자 표시"
L["Show graphical or numeric lacerates"] = "그래픽 또는 가르기 숫자 표시"
L["Show graphical or numeric maelstroms"] = "그래픽 또는 소용돌이치는 무기 숫자 표시"
L["Show graphical or numeric sunders"] = "그래픽 또는 방어구 가르기 숫자 표시"
L["Show incoming heals"] = "받는 치유 표시"
L["Show leader icon"] = "리더 아이콘 표시"
L["Show loot master icon"] = "전리품 담당 아이콘 표시"
L["Show Minimap Icon"] = "미니맵 아이콘 표시"
L["Show Party Role icon"] = "파티 역할 아이콘 표시"
L["Show points stored by the Anticipation talent"] = "선견지명 특성으로 저장된 연계 점수를 표시합니다"
L["Show PvP icon"] = "PvP 아이콘 표시"
L["Show Raid Icon"] = "대상 표시기 아이콘 표시"
L["Show raid icon"] = "대상 표시기 아이콘 표시"
L["Show resting status"] = "휴식 상태 표시"
L["Show rogue/cat energy ticker"] = "도적/표범 기력 틱 표시"
L["Show scaled threat"] = "확대된 위협 표시"
L["Show second highest threat"] = "두 번째로 높은 위협 표시"
L["Show spell cast time"] = "주문 시전 시간 표시"
L["Show spell rank"] = "주문 레벨 표시"
L["Show stacking debuffs"] = "디버프 중첩 표시"
L["Show stacking debuffs in ToT info"] = "ToT 정보에 대한 디버프 중첩 표시"
L["Show status icon"] = "상태 아이콘 표시"
L["Show tank name"] = "탱커 이름 표시"
L["Show the tooltip for this unit when the mouse is hovering over it."] = "마우스오버된 유닛에 툴팁을 표시합니다."
L["Show tooltip"] = "툴팁 표시"
L["Show when not full"] = "가득 차치 않을 때 표시"
L["Show when zero"] = "0일 때 표시"
L["Show with no target"] = "대상이 없을 때 표시"
L["Shows a flash behind each holy rune when it becomes available."] = "용할 수 있게 되면 각 신성 룬 뒤에 반짝임을 표시합니다."
L["Shows a flash behind each shard when it becomes available."] = "사용할 수 있게 되면 각 조각 뒤에 반짝임을 표시합니다."
L["Shows the name of the threat holder colorized by his or her role"] = "자신의 역할에 따라 색칠된 위협 보유자의 이름을 표시합니다"
L["Side"] = "표시할 위치"
L["Side of the HUD where the bar appears"] = "HUD에 바를 표시할 때의 위치"
L["Since the last time you updated IceHUD, many significant CPU and memory optimizations have been made. If bar animation looks jumpy to you, open the /icehud configuration page and raise the 'Update Period' slider. This will cause higher CPU usage but will look nicer. Enjoy IceHUD!"] = "IceHUD를 마지막으로 갱신한 이후로 많은 CPU 및 메모리 최적화가 이루어졌습니다. 바 애니메이션이 튀어 나오면 /icehud 구정 페이지를 열고 '갱신 주기' 슬라이더를 올리십시오. CPU 사용률은 높아지지만 더 좋게 보여집니다. IceHUD를 즐기세요!"
L["Size and Placement"] = "크기 및 배치"
L["Size to gap"] = "간격의 크기"
L["Sort by expiration"] = "만료 순으로 정렬"
L["Space between bars on the same side"] = "같은 쪽의 바 사이의 공간"
L["Space between buffs"] = "버프 사이의 공간"
L["Spacing between each combo point (only works for graphical mode)"] = "각 연계 점수 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each icon (only works for graphical mode)"] = "각 아이콘 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each lacerate count (only works for graphical mode)"] = "각 가르기 중첩 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each maelstrom point (only works for graphical mode)"] = "각 소용돌이치는 무기 점수 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each rune (only works for graphical mode)"] = "각 룬 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each sunder count (only works for graphical mode)"] = "각 방어구 가르기 중첩 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spacing between each totem (only works for graphical mode)"] = "각 토템 사이의 간격 (그래픽 모드에 대해서만 작동)"
L["Spell cast text visible"] = "주문 시전 글자 보이기"
L["Spell to track"] = "추적할 주문"
L["Stack Font Size"] = "중첩 글꼴 크기"
L["Status icon"] = "상태 아이콘"
L["Status Icon Horizontal Offset"] = "상태 아이콘 수평 보정값"
L["Status Icon Scale"] = "상태 아이콘 비율"
L["Status Icon Vertical Offset"] = "상태 아이콘 수직 보정값"
L["Sunder Count Font Size"] = "방어구 가르기 중첩 글꼴 크기"
L["Sunder gap"] = "방어구 가르기 간격"
L["Text appearance"] = "글자 모양"
L["Text Horizontal Offset"] = "글자 수평 보정값"
L["Text Settings"] = "글자 설정"
L["Text Vertical Gap"] = "글자 수직 간격"
L["Text Vertical Offset"] = "글자 수직 보정값"
L["Texture"] = "질감"
L["The alpha value for the second-place threat bar to be (this is multiplied by the bar's alpha so it's always proportionate)"] = "두 번째 위협 바에 대한 투명도 값 (이것은 바의 투명도에 곱하여 항상 비례합니다)"
L["The color for this bar"] = "이 바를 위한 색상"
L["The color for this counter"] = "이 중첩을 위한 색상"
L["The color this marker should be."] = "이 표시의 색상"
L["The height of the marker on the bar."] = "바에 있는 표식의 높이입니다."
L[ [=[The lower text to display under this bar (accepts LibDogTag formatting)

See http://www.wowace.com/wiki/LibDogTag-2.0/ or type /dogtag for tag info.

Remember to press ENTER after filling out this box or it will not save.]=] ] = [=[이 바 아래에 표시할 아래쪽 글자입니다 (LibDogTag 형식 허용)

http://www.wowace.com/wiki/LibDogTag-2.0/ or type /dogtag for tag info 참조.

이 상자를 채운 후 ENTER 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[The lower text to display under this bar.

NOTE: this text block does NOT support DogTags.

Remember to press ENTER/Accept after filling out this box or it will not save.]=] ] = [=[이 바 아래에 표시할 아래쪽 글자입니다.

참고: 이 글자 블록은 DogTag를 지원하지 않습니다.

이 상자를 채운 후 ENTER/수락 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["The minimum color for this counter (only used if Change Color is enabled)"] = "이 중첩의 최소 색상입니다 (색상 변경이 활성화된 경우에만 사용)"
L[ [=[The name of this bar (must be unique!).

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 바의 이름 (고유해야 합니다!).

이 상자에 원하는 이름으로 채운 후 ENTER 키 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[The name of this counter (must be unique!). 

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 중첩의 이름 (고유해야 합니다!). 

이 상자에 원하는 이름으로 채운 후 ENTER 키 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["The point on the TargetInfo frame that the buff frame gets connected to"] = "버프 프레임이 연결되는 TargetInfo 프레임의 지점"
L["The point on the TargetInfo frame that the debuff frame gets connected to"] = "디버프 프레임이 연결되는 TargetInfo 프레임의 지점"
L["The type of thing to track the cooldown of"] = "재사용 대기시간을 추적하는 유형"
L[ [=[The upper text to display under this bar (accepts LibDogTag formatting)

See http://www.wowace.com/wiki/LibDogTag-2.0/ or type /dogtag for tag info.

Remember to press ENTER after filling out this box or it will not save.]=] ] = [=[이 바 아래에 표시할 위쪽 글자입니다 (LibDogTag 형식 허용)

http://www.wowace.com/wiki/LibDogTag-2.0/ or type /dogtag for tag info 참조.

이 상자를 채운 후 ENTER 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[The upper text to display under this bar.

NOTE: this text block does NOT support DogTags.

Remember to press ENTER/Accept after filling out this box or it will not save.]=] ] = [=[이 바 아래에 표시할 위쪽 글자입니다.

참고: 이 글자 블록은 DogTag를 지원하지 않습니다.

이 상자를 채운 후 ENTER/수락 키를 누르십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Thick outline"] = "두꺼운 외곽선"
L[ [=[This controls how all non-DogTag text on all modules appears.

NOTE: Requires a UI reload to take effect.]=] ] = [=[이것은 모든 모듈에서 DogTag가 아닌 글자가 어떻게 나타나는지를 제어합니다.

참고: UI를 다시 불러와야 적용됩니다.]=]
L["This controls what happens to runes that are inactive. Darkened means they are visible but colored black, Hidden means they are not displayed."] = "이것은 비활성 룬에 발생하는 상황을 제어합니다. 어둡다는 것은 보이기는 하지만 검은색으로 칠해져 있다는 것을 의미하고, 숨겨진 것은 표시되지 않는다는 것을 의미합니다."
L["This is a per-pixel horizontal adjustment. You should probably use the 'offset' setting above as it is designed to snap bars together. This may be used in the case of a horizontal bar needing to be positioned outside the normal bar locations."] = "이것은 픽셀 당 수평을 조정합니다. 위의 '보정값' 설정은 바를 서로 맞추도록 설계되어 반드시 사용해야 합니다. 이것은 일반적인 바 위치 외부에 배치해야 하는 수평 바의 경우에 사용될 수 있습니다."
L["This option requires the UI to be reloaded. Do you wish to reload it now?"] = "이 설정을 사용하려면 UI를 재시작해야 합니다. 지금 재시작 하시겠습니까?"
L["This sets the alignment for the text on this bar"] = "이 바의 글자에 대한 정렬을 설정합니다"
L[ [=[This specifies at what point along the bar this marker should be displayed. Remember to press ENTER when you are done typing.

Example: if you wanted a marker at 40 energy and you have 100 total energy, then this would be 40. If you want it at 40 energy and you have 120 total energy, then this would be 33.]=] ] = [=[바를 따라 이 표식을 표시 할 지점을 지정합니다. 입력이 끝나면 ENTER 키를 눌려야합니다.

참고: 자원 40에 표식을 원하고 총 자원이 100이면 40이 됩니다. 자원 40에 표식을 원하고 총 자원이 120이면 33이 됩니다.]=]
L[ [=[This will fade the bars or numeric representation from the min color specified to the regular color

(e.g. if the min color is yellow, the color is red, and there are 3 total applications, then the first would be yellow, second orange, and third red)]=] ] = [=[지정된 최소 색상에서 일반 색상으로 바 또는 숫자 표시가 변화합니다.

(예: 최소 색상이 노란색이고 색상이 붉은색이며 총 3개의 적용이 있으면, 첫 번째는 노란색, 두 번째는 주황색이고 세 번째는 빨간색입니다)]=]
L[ [=[This will fade the graphical representation from the min color specified to the regular color

(e.g. if the min color is yellow, the color is red, and there are 3 total applications, then the first would be yellow, second orange, and third red)]=] ] = [=[지정된 최소 색상에서 일반 색상으로 그래픽 표현이 변화합니다.

(예: 최소 색상이 노란색이고 색상이 붉은색이며 총 3개의 적용이 있으면, 첫 번째는 노란색, 두 번째는 주황색이고 세 번째는 빨간색입니다)]=]
L["This will hide the entire mod during pet battles."] = "애완동물 대전 중에는 전체 모드를 숨깁니다."
L["This will hide the entire mod when interacting with a barbershop."] = "미용실 이용 중에는 전체 모드를 숨깁니다."
L["This will hide the entire mod when playing the BfA Tortollan shell game world quest."] = "'격적의 아제로스' 토르톨란 껍질 놀이 전역 퀘스트를 할 때 전체 모드를 숨깁니다."
L["This will override the global bar texture setting for this bar with the one specified below."] = "이 바의 전역 바 질감 설정이 아래에 지정된 것보다 우선합니다."
L["This will override the global bar texture setting for this bar."] = "이 바에 대한 전역 바 질감 설정을 재정의합니다."
L["This will remove the marker selected in the 'edit marker' box. This action is irreversible."] = "'표식 편집' 상자에서 선택한 표식이 제거됩니다. 이 행동은 돌이킬 수 없습니다."
L[ [=[This will rotate this module by 90 degrees to give a horizontal orientation.

WARNING: This feature is brand new and a bit rough around the edges. You will need to greatly adjust the vertical and horizontal offset of this bar plus move the text around in order for it to look correct.

And I mean greatly.]=] ] = [=[이 모듈을 수평 방향으로 90도 회전시킵니다.

경고: 이 기능은 새롭고 가장자리가 약간 거칩니다. 이 바의 수직 및 수평 보정값을 크게 조정하고 글자가 올바르게 보이도록 글자를 이동해야합니다.

And I mean greatly.]=]
L["This will update the marker selected in the 'edit marker' box with the values specified."] = "'표식 편집' 상자에서 선택된 표식이 지정된 값으로 갱신됩니다."
L["Toggle bar background visibility"] = "바 배경의 가시성을 전환합니다"
L["Toggle bar visibility"] = "바의 가시성을 전환합니다"
L["Toggle lower text visibility"] = "아래쪽 글자의 가시성을 전환합니다"
L["Toggle mouseover on/off"] = "마우스오버의 켬/끔을 전환합니다"
L["Toggle mouseover on/off for buffs/debuffs"] = "버프/디버프에 대한 마우스오버의 켬/끔을 전환합니다"
L["Toggle mouseover on/off for target"] = "대상에 대한 마우스오버에 켬/끔을 전환합니다"
L["Toggle spell cast text visibility"] = "주문 시전 글자의 가시성을 전환합니다"
L["Toggle upper text visibility"] = "위쪽 글자의 가시성을 전환합니다"
L["Toggles contextual background coloring"] = "상황별 배경 색상을 전환합니다"
L["Toggles whether or not buffs are displayed at all"] = "버프를 전부 표시할지 말지 여부 전환합니다"
L["Toggles whether or not debuffs are displayed at all"] = "디버프를 전부 표시할지 말지 여부 전환합니다"
L["Toggles whether or not to show the CastNonInterruptible color for this bar when a cast is non-interruptible"] = "시전이 차단 불가능한 경우, 이 바의 CastNonInterruptible 색상을 표시할지 말지의 여부를 전화합니다"
L["Toggles whether or not to sort by expiration time (otherwise they're sorted how the game sorts them - by application time)"] = "만료 시간 순으로 정렬할지 말지의 여부를 전환합니다 (그렇지 않으면 게임의 정렬 방식으로 정렬됨 - 적용 시간으로)"
L["ToT frame texture"] = "ToT 프레임 질감"
L["Totem cooldown mode"] = "토템 재사용 대기시간 방식"
L["Totem gap"] = "토템 간격"
L["Totem orientation"] = "토템 방향"
L["Transparency Settings"] = "투명도 설정"
L["Type %s to clear focus"] = "주시를 해제하려면 %s 입력"
L["Type %s to set focus"] = "주시를 설정하려면 %s 입력"
L["Unit to track"] = "추적 유닛"
L["Update"] = "갱신"
L["Update Period"] = "갱신 주기"
L["Upper Text"] = "위쪽 글자"
L["Upper Text Color"] = "위쪽 글자 색상"
L["Upper text visible"] = "위쪽 글자 보이기"
L["Use class color as the bar color instead of default color"] = "기본 색상 대신 직업 색상을 바 색상으로 사용"
L["Use class color as the bar color instead of reaction color"] = "반응 색상 대신 직업 색상을 바 색상으로 사용"
L[ [=[Use class color as the bar color instead of reaction color

(Note: The 'color bar by health %' setting overrides this)]=] ] = [=[반응 색상 대신 직업 색상을 바 색상으로 사용

(참고: '체력 %에 따른 바 색상' 설정이 이를 재정의합니다)]=]
L["Use Dog Tags"] = "Dog Tag 사용"
L["Use multiple buff colors"] = "여러 버프 색상 사용"
L["Use normal alpha"] = "일반 투명도 사용"
L["Use 'Target' alpha for friendlies"] = "아군에 대해 '대상' 투명도 사용"
L["Use this for abilities that don't require a target to cast, but you only want to see them when you have a target"] = "대상에 시전할 필요는 없지만, 대상이 있을 때만 보고 싶은 능력을 사용합니다"
L["Use your Dismiss Pet spell to dismiss a pet"] = "소환수를 해제하려면 소환해제 주문을 사용합니다"
L["Uses the 'color bar by mana %' setting/colors even for classes that don't use Mana"] = "마나를 사용하지 않는 직업에도 '마나 %에 따른 바 색상'의 설정/색상을 사용합니다"
L["Usually CD bars will always display if they're set to 'When Ready' or 'Always' mode regardless of your other transparency settings. If you'd rather this bar show/hide as per normal transparency rules, then check this box."] = "일반적으로 CD 바는 다른 투명도 설정에 관계없이 '준비될 때' 또는 '항상' 방식으로 설정되어 있으면 항상 표시됩니다. 일반 투명도 규칙에 따라 이 바를 표시하거나 숨기려면, 이 확인란을 선택하십시오."
L["Vertical Position"] = "수직 위치"
L["Vertical position"] = "수직 위치"
L["Visibility Settings"] = "가시성 설정"
L["What alpha value to use for the bar that displays how long your RtB will last if you activate it. (This gets multiplied by the bar's current alpha to stay in line with the bar on top of it)"] = "'뼈주사위'를 활성화하면 지속 시간이 표시되는 바에 사용할 투명도 값입니다. (이것은 바의 현재 알파를 곱하여 그 위에 있는 바와 줄을 유지합니다)"
L["What alpha value to use for the bar that displays how long your SnD will last if you activate it. (This gets multiplied by the bar's current alpha to stay in line with the bar on top of it)"] = "'난도질'을 활성화하면 지속 시간이 표시되는 바에 사용할 투명도 값입니다. (이것은 바의 현재 알파를 곱하여 그 위에 있는 바와 줄을 유지합니다)"
L["What alpha value to use for the bar that displays how much effective health you have including absorbs (This gets multiplied by the bar's current alpha to stay in line with the bar on top of it)"] = "흡수에 포함된 체력의 양을 표시하는 바에 사용할 투명도 값입니다. (이것은 바의 현재 알파를 곱하여 그 위에 있는 바와 줄을 유지합니다)"
L["What alpha value to use for the bar that displays how much health you'll have after an incoming heal (This gets multiplied by the bar's current alpha to stay in line with the bar on top of it)"] = "들어오는 힐 후에 얼마나 많은 체력을 가질지 보여주는 바에 사용할 투명도 값입니다. (이것은 바의 현재 알파를 곱하여 그 위에 있는 바와 줄을 유지합니다)"
L["What graphical representation each rune should have. When setting to anything other than 'graphical', the module will behave more like combo points and simply show how many are active."] = "각 룬의 그래픽 표현. '그래픽' 이외의 다른 것으로 설정하면 모듈은 연계 점수처럼 작동하며 활성 상태를 보여줍니다."
L["What this bar should do whenever the player is the TargetOfTarget"] = "플레이어가 TargetOfTarget 일 때에 이 바가 수행해야 하는 작업"
L[ [=[What this bar should do whenever the player is the TargetOfTarget

NOTE: When this is set to 'hide', then click-targeting is not available due to Blizzard's restrictions]=] ] = [=[플레이어가 TargetOfTarget 일 때에 이 바가 수행해야 하는 작업

참고: '숨기기'로 설정된 경우 블리자드의 제한으로 인해 '클릭으로 대상선택'을 사용할 수 없습니다.]=]
L["When checked, if a 'Custom Lag Tolerance' is set in the game's Combat options, the lag indicator will always use that tolerance value. Otherwise, it uses the computed latency."] = "선택하면, 게임의 전투 설정에 '사용자 지연 허용 오차'가 설정되어 있으면 지연 표시기는 항상 해당 허용 오차 값을 사용합니다. 그렇지 않으면 계산된 지연 시간을 사용합니다."
L["When tanking, this toggles whether or not the second-highest threat value found in your party or raid is displayed on top of your actual threat value"] = "탱킹 할 때, 파티 또는 공격대에서 찾은 두 번째로 높은 위협 값이 실제 위협 값 위에 표시되는지 여부를 전환합니다"
L["When the bar drops below this amount, it will start flashing (0 means never). For the 'mana' bar this only applies to mana and not rage/energy/focus/runic power."] = "바가 이 수치 아래로 떨어지면 깜박이기 시작합니다 (0은 절대 없음). '마나' 바의 경우 마나에만 적용되며 분노/기력/집중/룬 마력에는 적용되지 않습니다."
L["When to display this bar."] = "이 바를 표시할 시기."
L[ [=[Whether or not the addon should use the DogTag library (this will increase the CPU usage of the mod). DogTag controls all text displayed around bars such as health or mana amounts. Type |cffffff78/dog|r to see all DogTag options.

NOTE: after changing this option, you must reload the UI or else bad things happen]=] ] = [=[애드온이 DogTag 라이브러리를 사용할지 말지 여부 (모드의 CPU 사용량 증가). DogTag는 체력이나 마나량과 같은 바 주변에 표시되는 모든 글자를 제어합니다. |cffffff78/dog|r 입력하여 모든 DogTag 설정을 확인하십시오.

참고: 이 설정을 변경 후 UI를 다시 불러와야 하며 그렇지 않으면 안 좋은 일이 발생합니다]=]
L["Whether or not to allow click casting of Hunger For Blood"] = "피의 갈망의 클릭 시전을 허용할지 말지 여부"
L["Whether or not to allow click targeting/casting and the player drop-down menu for this bar (Note: does not work properly with HiBar, have to click near the base of the bar)"] = "클릭 대상 선택/시전 및 이 바의 플레이어 드롭다운 메뉴를 허용할지 말지 여부 (참고: HiBar에서는 제대로 작동하지 않습니다, 바 하단 근처를 클릭해야 합니다)"
L["Whether or not to allow click targeting/casting and the player drop-down menu for this bar while the player is in combat (Note: does not work properly with HiBar, have to click near the base of the bar)"] = "플레이어가 전투 중인 동안 클릭 대상 선택/시전 및 이 바의 플레이어 드롭다운 메뉴를 허용할지 말지 여부 (참고: HiBar에서는 제대로 작동하지 않습니다, 바 하단 근처를 클릭해야 합니다)"
L["Whether or not to allow click targeting/casting and the target drop-down menu for this bar (Note: does not work properly with HiBar, have to click near the base of the bar)"] = "이 바의 클릭 대상 선택/시전 및 대상 드롭다운 메뉴를 허용할지 말지 여부 (참고: HiBar에서는 제대로 작동하지 않습니다, 바 하단 근처를 클릭해야 합니다)"
L["Whether or not to allow click targeting/casting for this bar (Note: does not work properly with HiBar, have to click near the base of the bar)"] = "이 바의 클릭 대상 선택/시전을 허용할지 말지 여부 (참고: HiBar에서는 제대로 작동하지 않습니다, 바 하단 근처를 클릭해야 합니다)"
L["Whether or not to allow the mouse to interact with the totems. If this is enabled, then right-clicking a totem will cancel it. Otherwise mouse clicks will not get caught by the totems and no tooltips will be shown."] = "마우스가 토템과 상호 작용하도록 허용할지 말지 여부. 이것을 활성화하면, 우-클릭으로 토템이 취소됩니다. 그렇지 않으면 마우스 클릭이 토템에 걸리지 않고 툴팁이 표시되지 않습니다."
L["Whether or not to animate the bar falloffs/gains"] = "바 감소/증가 애니메이션 표시할지 말지 여부"
L["Whether or not to display an icon for the aura that this bar is tracking"] = "이 바가 추적 중인 오라나 아이템을 표시할지 말지 여부"
L["Whether or not to display the first line of text on this module which is the target's name."] = "이 모듈에 대상의 이름을 글의 첫 번째 즐에 표시할지 말지 여부."
L["Whether or not to display the second line of text on this module which is the target's details (level, class, PvP status, etc.)."] = "이 모듈에 대상의 세부사항(레벨, 직업, PvP상태 등)을 글의 두 번째 줄에 표시할지 말지 여부."
L["Whether or not to display the third line of text on this module which is the target's guild and realm (if they are from another realm)."] = "이 모듈에 대상의 길드와 서버(다른 서버에서 온 경우)를 글의 세 번째 줄에 표시할지 말지 여부."
L["Whether or not to display this bar even if the buff/debuff specified is not present."] = "지정한 버프/디버프가 없을 때에도 이 바를 표시할지 말지 여부."
L["Whether or not to display when you have no target selected but have combo points available"] = "선택한 대상이 없어도 사용 가능한 연계 점수가 있을 때 표시할지 말지 여부"
L["Whether or not to reverse the direction of the cast bar when a spell is being channeled. For example, if a normal cast causes this bar to fill up, then checking this option will cause a channeled spell to empty the bar instead."] = "채널링 주문일 때 시전 바의 방향을 바꿀지 말지 여부. 예를 들어, 일반 시전은 바를 채운다면, 이 설정을 선택하면 채널링 주문은 바를 비웁니다."
L["Whether or not to show absorb amounts as a lighter-colored bar on top of your current health."] = "현재 체력의 상단에 밝은 색의 바로 흡수량을 표시할지 말지 여부."
L["Whether or not to show an IceHUD icon on the minimap."] = "미니맵에 IceHUD 아이콘을 표시할지 말지 여부"
L["Whether or not to show incoming heals as a lighter-colored bar on top of your current health (requires LibHealComm-4.0 or official patch 4.0)"] = "들어오는 힐을 현재 체력의 상단에 더 밝은 색의 바로 표시할지 말지 여부 (LibHealComm-4.0이나 공식 패치 4.0 필요)"
L["Whether or not to show the combat status portion of the status icon (for example, if you only care when you're resting, not when you're in combat)"] = "상태 아이콘의 전투 상태 부분을 표시할지 말지 여부 (예: 휴식 중일 때에만 관여하고, 전투 중일 때에는 그렇지 않은 경우)"
L["Whether or not to show the counter when the value is zero. This will cause a 0 to be displayed at all times for Numeric mode and faded markers for graphical mode."] = "값이 0 일 때 중첩을 표시할지 말지 여무. 이 경우 숫자 방식의 경우 항상 0이 표시되고, 그래픽 방식의 경우 색이 바랜 표식이 표시됩니다."
L["Whether or not to show the default cast bar."] = "기본 시전 바를 표시할지 말지 여부."
L["Whether or not to show the loot master icon"] = "전리품 담당 아이콘 표시할지 말지 여부"
L["Whether or not to show the party leader icon above this bar"] = "이 바 위에 파티장 아이콘을 표시할지 말지 여부."
L["Whether or not to show the Party Role icon"] = "파티 역할 아이콘을 표시할지 말지 여부"
L["Whether or not to show the PvP icon"] = "PvP 아이콘을 표시할지 말지 여부"
L["Whether or not to show the raid icon above this bar"] = "이 바 위에 전술 목표 아이콘을 표시할지 말지 여부"
L["Whether or not to show the raid icon for this unit."] = "이 유닛에 대한 전술 목표 아이콘을 표시할지 말지 여부."
L["Whether or not to show the rank of a spell being cast."] = "시전되는 주문의 레벨을 표시할지 말지 여부."
L["Whether or not to show the rare/elite icon above this bar"] = "이 바 위에 희귀/정예 아이콘을 표시할지 말지 여부"
L["Whether or not to show the remaining cast time of a spell being cast."] = "시전되는 주문의 남은 시전 시간을 표시할지 말지 여부."
L["Whether or not to show the resting status portion of the status icon (for example, if you only care when you're in combat, but not when you're resting)"] = "상태 아이콘의 휴식 상태 부분을 표시할지 말지 여부 (예: 전투 중 때에만 관여하고, 휴식 중일 때에는 그렇지 않은 경우)"
L[ [=[Whether or not to show the status icon (resting/combat) above this bar

Note: You can configure resting/combat separately below, but disabling both resting and combat is the same as disabling the icon altogether]=] ] = [=[이 바 위에 상태 아이콘(휴식/전투)을 표시할지 말지 여부

참고: 아래에서 휴식/전투를 별로도 구성할 수 있지만, 휴식과 전투를 비활성화하는 것은 아이콘을 모두 비활성화하는 것과 같습니다]=]
L["Whether the runes should draw side-by-side or on top of one another"] = "룬이 나란히 또는 서로 위에 그려져야하는지의 대한 여부"
L["Whether the totems should draw side-by-side or on top of one another"] = "토템이 나란히 또는 서로 위에 그려져야하는지의 대한 여부"
L["Whether this bar should hide when the player has 0 combo points or stay visible"] = "플레이어가 0 연계 점수 또는 그냥 보여질 때 이 바를 숨길지 말지 여부"
L["Whether to always show this module at 100% alpha or not"] = "이 모듈을 항상 100%의 투명도로 표시할지 말지 여부"
L["Whether to display this bar when you target a unit, even if the buff/debuff specified is not present."] = "지정한 버프/디버프가 없는 경우에도 유닛을 대상으로 할 때 이 바를 표시할지 말지 여부."
L["Whether to draw the elite icon in front of or behind this bar"] = "이 바의 앞 또는 뒤에 정예 아이콘을 그릴지 말지 여부"
L["Whether to draw the PvP icon in front of or behind this bar"] = "이 바의 앞 또는 뒤에 PvP 아이콘을 그릴지 말지 여부"
L["Whether to draw the raid icon in front of or behind this bar"] = "이 바의 앞 또는 뒤에 전술 목표 아이콘을 그릴지 말지 여부"
L["Whether to show the Runes module any time the player has fewer than max runes available (regardless of combat/target status)."] = "플레이어가 사용 가능한 최대 룬보다 적어도 룬 모듈을 항상 표시할지 말지 여부 (전투/대상 상태에 관계없이)."
L["Whether to show this bar when a spellcast longer than the global cooldown is being cast."] = "전역 재사용 대기시간보다 긴 주문이 시전될 때, 이 바를 표시할지 여부."
L["Whether to show threat in scaled values or raw values. Scaled threat means that you will pull aggro when it hits 100%. Raw threat means you will pull aggro at either 110% (melee) or 130% (ranged). Omen uses raw threat which can cause this mod to disagree with Omen if it is in scaled mode."] = "확장된 값이나 원시 값으로 위협을 표시할지 여부. 확장된 위협은 100%가 되면 어그로를 끈다는 것을 의미합니다. 원시 위협이란 100%(근접) 또는 130%(원거리)의 어그로를 끈다는 것을 의미합니다. Omen은 원시 위협을 사용하는데, 이 모드는 확장된 모드일 경우 Omen과 불일치할 수 있습니다."
L["Whether we are tracking a buff or debuff"] = [=[버프, 디버프, 충전, 중첩을 추적하는지 여부.

점화와 같은 일부 주문은 소비된 후 다시 모아야하는 부담이 있습니다. 화력 집중과 같은 다른 주문들은 꼭 버프와/디버프와 일지하지 않는 중첩을 가지고 있습니다.]=]
L[ [=[Which buff/debuff this bar will be tracking.

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 바가 추적할 버프/디버프.

이 상자에 원하는 이름을 채운 후 ENTER 키 누르는 것을 잊지 마십시오. 그렇지 않으면 저장되지 않습니다.]=]
L[ [=[Which buff/debuff this counter will be tracking. 

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 중첩이 추적할 버프/디버프. 

이 상자에 원하는 이름을 채운 후 ENTER 키 누르는 것을 잊지 마십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Which direction the buffs should grow from the anchor point"] = "버프가 기준점에서 성장하는 방향"
L["Which direction the debuffs should grow from the anchor point"] = "디버프가 기준점에서 성장하는 방향"
L["Which icon set to use for elite/rare elite/rare textures. This simply changes the look of the classification icon."] = "정예/희귀 정예/희귀 질감에 사용되는 아이콘을 설정합니다. 이것은 단순히 분류 아이콘의 모양을 변경합니다."
L["Which item cooldown this bar will be tracking."] = "이 바에서 추적할 아이템 재사용 대기시간."
L[ [=[Which spell cooldown this bar will be tracking.

Remember to press ENTER after filling out this box with the name you want or it will not save.]=] ] = [=[이 바에서 추적할 주문 재사용 대기시간.

이 상자에 원하는 이름을 채운 후 ENTER 키 누르는 것을 잊지 마십시오. 그렇지 않으면 저장되지 않습니다.]=]
L["Width"] = "너비"
L["Will only show buffs that you cast instead of all buffs active"] = "활성화된 모든 버프 대신 자신이 시전한 버프만 표시합니다"
L["Will only show debuffs that you cast instead of all debuffs active"] = "활성화된 모든 디버프 대신 자신이 시전한 디버프만 표시합니다"
L["Will only show this bar if the target uses mana (as opposed to rage, energy, runic power, etc.)"] = "대상이 마나를 사용할 경우만 보이기 (분노, 기력, 룬마력 등등은 보이지 않음)"
L["With this checked, the bar will only activate for your own CC spells and not those of others."] = "이것을 선택하면, 바는 자신의 군중제어 주문에 대해서만 활성화되고 다른 군중제어 주문에는 활성화되지 않습니다."
L[ [=[With this enabled, all icons draw so you can configure their placement

Note: the combat and status icons are actually the same texture so you'll only see combat in config mode (unless you're already resting)]=] ] = [=[이 기능을 활성화하면, 모든 아이콘이 그려져 배치를 구성할 수 있습니다

참고: 전투 및 상태 아이콘은 실제로 동일한 질감으로, 구성 모드에서만 전투를 볼 수 있습니다(이미 쉬고 있지 않는 한)]=]
L["With this enabled, all icons will be 100% visible regardless of the alpha settings for this bar."] = "이 기능을 활성화하면, 이 바의 투명도 설정에 관계없이 모든 아이콘이 100%로 표시됩니다."
L["With this enabled, the raid icon is always 100% alpha, regardless of the bar's alpha. Otherwise, it assumes the bar's alpha level."] = "이 기능을 활성화하면, 공격대 아이콘이 바의 투명도와 관계없이 항상 100%의 투명도로 표시됩니다. 그렇지 않으면 바의 투명도 단계를 추정해 표시합니다."
L["You have changed IceHUD profiles while in combat. This can cause problems due to Blizzard's secure frame policy. You may need to reload your UI to repair IceHUD."] = "전투 중에 IceHUD 프로필을 바꿨습니다. 블리자드의 프레임 정책에 의거하여 문제가 발생할 수 있습니다. UI를 재시작하여 IceHUD 설정을 고쳐야할 지도 모릅니다."

