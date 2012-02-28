-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "koKR")
if not L then return end

L["Add this location to Cartographer_Waypoints"] = "현재 위치를 Cartographer_Waypoints에 추가합니다."
L["Add this location to TomTom waypoints"] = "현재 위치를 TomTom 웨이포인트에 추가합니다."
L["Always show"] = "항상 표시"
L["Archaeology"] = "고고학"
L["Archaeology filter"] = "고고학 분류"
L["Are you sure you want to delete all nodes from this database?"] = "현재 데이터베이스의 모든 노드를 삭제하시겠습니까?"
L["Are you sure you want to delete all of the selected node from the selected zone?"] = "선택된 지역으로부터 선택된 모든 노드를 삭제하시겠습니까?"
L["Auto Import"] = "자동 추가"
L["Auto import complete for addon "] = "애드온의 자동 추가 완료: "
L["Automatically import when ever you update your data module, your current import choice will be used."] = "변경된 데이터가 있을 경우 자동으로 현재 데이터에 추가합니다. 추가된 데이터를 바로 사용할 수 있습니다."
L["Cataclysm"] = "대격변"
L["Cleanup Complete."] = "데이터 정리를 완료했습니다."
L["Cleanup Database"] = "데이터 정리"
L["Cleanup_Desc"] = "수집한 데이터가 많아지면 겹칠 수도 있고 알아볼 수 없는 경우도 발생합니다. 이러한 경우 데이터를 정리해야 합니다. 각각의 전문기술 별로 저장된 노드에 대해 인접한 노드를 삭제하여 알아보기 쉽도록 정리합니다."
L["Cleanup radius"] = "근접 노드 삭제"
L["CLEANUP_RADIUS_DESC"] = "현재 반경 내의 중복된 노드를 삭제합니다. 기본값은 가스는 |cffffd20050|r미터, 나머지는 |cffffd20015|r미터 입니다. 이 설정은 노드가 추가될 때도 적용됩니다."
L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "데이터 정리를 통해서 중복된 노드를 삭제합니다. 이 과정은 약간의 시간이 소요됩니다."
L["Clear database selections"] = "데이터베이스 선택을 취소합니다."
L["Clear node selections"] = "노드 선택을 취소합니다."
L["Clear zone selections"] = "지역 선택을 취소합니다."
L["Color of the tracking circle."] = "미니맵에 표시되는 아이콘의 테두리 색상을 설정합니다."
L["Control various aspects of node icons on both the World Map and Minimap."] = "세계 지도와 미니맵에 표시되는 아이콘에 대한 설정입니다."
L["Conversion_Desc"] = "현재 GatherMate 데이터를 GatherMate2 데이터로 변환합니다."
L["Convert Databses"] = "데이터베이스를 변환합니다."
L["Database locking"] = "데이터베이스 잠금"
L["Database Locking"] = "데이터베이스 잠금"
L["DATABASE_LOCKING_DESC"] = "데이터베이스를 잠금 상태로 만듭니다. 일단 잠금 상태가 되면 더 이상 데이터베이스에 추가, 삭제, 또는 수정을 할 수 없습니다. 이것은 완전 삭제나 추가한 것도 포함됩니다."
L["Database Maintenance"] = "데이터베이스 관리"
L["Databases to Import"] = "데이터베이스 추가"
L["Databases you wish to import"] = "원하는 데이터를 추가합니다."
L["Delete"] = "삭제"
L["Delete Entire Database"] = "모든 데이터베이스 삭제"
L["DELETE_ENTIRE_DESC"] = "선택한 데이터베이스에서 모든 지역의 노드를 삭제합니다."
L["Delete selected node from selected zone"] = "해당 지역에서 선택한 노드를 삭제합니다."
L["DELETE_SPECIFIC_DESC"] = "현재 지역의 모든 노드를 삭제합니다. 단 데이터베이스 잠금 상태에서는 삭제할 수 없습니다."
L["Delete Specific Nodes"] = "특정 노드 삭제"
L["Display Settings"] = "표시 설정"
L["Engineering"] = "기계공학"
L["Expansion"] = "확장"
L["Expansion Data Only"] = "확장 데이터만"
L["Failed to load GatherMateData due to "] = "GatherMate 데이터를 불러오는 데 실패: "
L["FAQ"] = "질문과 답변"
L["FAQ_TEXT"] = [=[|cffffd200
GatherMate를 막 설치했지만 제 맵에서는 어떠한 노드도 볼수가 없습니다. 무엇이 잘못된 건가요?
|r
GatherMate는 자신이 데이터를 만들어 갑니다. 약초를 캐거나 채광, 낚시 등을 할 때 지도에 그 정보를 갱신하게 됩니다. 일단은 표시 설정을 체크해 보세요.

|cffffd200
세계 지도에선 보이는 노드가 미니맵에선 보이지 않습니다. 무엇이 잘못된 건가요?
|r
|cffffff78Minimap Button Bag|r (그리고 그와 비슷한 종류의 애드온)은 미니맵의 노드 표시까지 숨기는 경우가 있습니다. 해당 애드온을 비활성화 하세요.

|cffffd200
현재 가지고 있는 데이터를 어디에 그리고 어떻게 이용할 수 있나요?
|r
현재 가지고 계신 데이터는 GatherMate의 여러 방법으로 이용이 가능합니다:

1. |cffffff78GatherMate_Data|r - 이 LoD 애드온은 WowHead사이트에 한주간 수집된 모든 업데이트된 노드를 포함하고 있습니다. 자동 업데이트 설정으로 적용하세요.

2. |cffffff78GatherMate_CartImport|r - 이 애드온은 |cffffff78Cartographer_<Profession>|r 의 데이터를 GatherMate로 가져올 수 있습니다. 이를 위해서는 반드시 |cffffff78Cartographer_<Profession>|r와 GatherMate_CartImport가 둘다 설치되어 있어야 합니다.

GatherMate는 이 데이터 추가 기능이 자동으로 동작하지는 않습니다. 데이터 추가를 위해서는 반드시 "추가" 버튼을 눌러 주셔야 합니다.

|cffffff78Cartographer_Data|r를 선택하여 적용하게 되면 |cffffff78Cartographer_Data|r를 기존 데이터에 단순히 겹쳐쓰게 됨으로서 기존 데이터가 파괴될 가능성을 가지고 있습니다.

|cffffd200
우체통이나 비행 조련사의 위치 표시를 지원할 예정이 있나요?
|r
그럴 계획은 없습니다. 혹시라도 다른 애드온 제작자가 추가 모듈 형식으로 가능할지는 모르지만, 현재 GatherMate 개발진은 그럴 생각이 없습니다.

|cffffd200
버그를 발견했습니다! 어디에 보고하면 되나요?
|r
|cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r 주소로 보고해주시면 됩니다.

또한, |cffffff78irc://irc.freenode.org/wowace|r로 우리를 찾아와 주셔도 됩니다.

버그를 보고할 때는, |cffffff78버그가 어떻게 발생했는가에 대한 것|r, 가능하다면 |cffffff78오류 메시지|r에 대한 스택 트레이스, 문제가 발생된 지역(|cffffff78영문 클라이언트 또는 기타|r)과 GatherMate |cffffff78버전|r을 내용에 포함시켜 주세요.

|cffffd200
누가 이 멋진 애드온을 만들었죠?
|r
Kagaro, Xinhuan, Nevcairiel 그리고 Ammo입니다.]=]
L["Filter_Desc"] = "선택한 노드에 대해서만 세계 지도와 미니맵에 표시합니다. 선택하지 않은 노드는 표시되지는 않지만 데이터베이스에 기록되고 있습니다."
L["Filters"] = "분류 설정"
L["Fishes"] = "낚시"
L["Fish filter"] = "낚시 분류"
L["Fishing"] = "낚시"
L["Frequently Asked Questions"] = "중요한 질문과 답변"
L["Gas Clouds"] = "가스 구름"
L["Gas filter"] = "가스 분류"
L["GatherMate2Data has been imported."] = "GatherMate2 데이터가 추가되었습니다."
L["GatherMate Conversion"] = "GatherMate 변환"
L["GatherMate data has been imported."] = "GatherMate 데이터가 추가되었습니다."
L["GatherMateData has been imported."] = "GatherMate 데이터가 추가되었습니다."
L["GatherMate Pin Options"] = "GatherMate 설정"
L["General"] = "일반 설정"
L["Herbalism"] = "약초채집"
L["Herb Bushes"] = "약초"
L["Herb filter"] = "약초 분류"
L["Icon Alpha"] = "아이콘 투명도"
L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "아이콘의 투명도를 조절합니다. 세계 지도에만 적용됩니다."
L["Icons"] = "아이콘 설정"
L["Icon Scale"] = "아이콘 크기"
L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "세계 지도와 미니맵에 표시되는 아이콘의 크기를 설정합니다."
L["Import Data"] = "데이터 추가"
L["Import GatherMate2Data"] = "GatherMate2 데이터 추가"
L["Import GatherMateData"] = "GatherMate 데이터 추가"
L["Importing_Desc"] = "기존에 저장되어 있는 GatherMate용 데이터를 불러와 현재 데이터에 추가합니다. 데이터를 추가한 후에는 반드시 데이터 정리가 필요합니다."
L["Import Options"] = "데이터 추가 설정"
L["Import Style"] = "추가 방법"
L["Keybind to toggle Minimap Icons"] = "미니맵 아이콘에 단축키를 지정합니다."
L["Load GatherMate2Data and import the data to your database."] = "GatherMate2 데이터를 불러와 현재 데이터에 추가합니다."
L["Load GatherMateData and import the data to your database."] = "GatherMate 데이터를 불러와 현재 데이터에 추가합니다."
L["Merge"] = "합치기"
L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "합치기를 이용해 GatherMate2 데이터를 기존의 데이터베이스에 추가합니다. 덮어쓰기는 기존의 데이터베이스를 GatherMate2 데이터로 교체합니다."
L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "합치기를 이용해 GatherMate 데이터를 기존의 데이터베이스에 추가합니다. 덮어쓰기는 기존의 데이터베이스를 GatherMate 데이터로 교체합니다."
L["Mine filter"] = "채광 분류"
L["Mineral Veins"] = "광맥"
L["Minimap Icon Tooltips"] = "미니맵 아이콘 툴팁"
L["Mining"] = "채광"
L["Never show"] = "항상 숨김"
L["Only import selected expansion data from WoWDB"] = "WoWDB에서 선택한 확장 데이터만 추가합니다."
L["Only import selected expansion data from WoWhead"] = "WoWhead에서 선택한 확장 데이터만 추가합니다."
L["Only while tracking"] = "추적하는 동안에만"
L["Only with digsite"] = "발굴현장이 있는 지역만"
L["Only with profession"] = "전문기술이 있을때만"
L["Overwrite"] = "덮어쓰기"
L["Processing "] = "처리 중 "
L["Select All"] = "모두 선택"
L["Select all databases"] = "모든 데이터베이스를 선택합니다."
L["Select all nodes"] = "모든 노드를 선택합니다."
L["Select all zones"] = "모든 지역을 선택합니다."
L["Select Database"] = "데이터베이스 선택"
L["Select Databases"] = "데이터베이스 선택"
L["Selected databases are shown on both the World Map and Minimap."] = "선택한 데이터베이스를 세계 지도와 미니맵에 표시합니다."
L["Select Node"] = "노드 선택"
L["Select None"] = "선택 취소"
L["Select the archaeology nodes you wish to display."] = "표시할 고고학 노드를 선택합니다."
L["Select the fish nodes you wish to display."] = "표시할 낚시 노드를 선택합니다."
L["Select the gas clouds you wish to display."] = "표시할 가스 구름을 선택합니다."
L["Select the herb nodes you wish to display."] = "표시할 약초 노드를 선택합니다."
L["Select the mining nodes you wish to display."] = "표시할 채광 노드를 선택합니다."
L["Select the treasure you wish to display."] = "표시할 보물상자를 선택합니다."
L["Select Zone"] = "지역 선택"
L["Select Zones"] = "지역 선택"
L["Show Archaeology Nodes"] = "고고학 노드 표시"
L["Show Databases"] = "데이터베이스 표시"
L["Show Fishing Nodes"] = "낚시 노드 표시"
L["Show Gas Clouds"] = "가스 구름 표시"
L["Show Herbalism Nodes"] = "약초채집 노드 표시"
L["Show Minimap Icons"] = "미니맵 아이콘 표시"
L["Show Mining Nodes"] = "채광 노드 표시"
L["Show Nodes on Minimap Border"] = "미니맵 테두리 노드 표시"
L["Shows more Nodes that are currently out of range on the minimap's border."] = "추적 범위 바깥에 있는 노드의 경우 어느 방향에 있는지를 나타내는 아이콘을 미니맵 테두리에 표시합니다."
L["Show Tracking Circle"] = "미니맵 아이콘 테두리 표시"
L["Show Treasure Nodes"] = "보물상자 노드 표시"
L["Show World Map Icons"] = "세계 지도에 아이콘 표시"
L["The Burning Crusades"] = "불타는 성전"
L["The distance in yards to a node before it turns into a tracking circle"] = "저장된 데이터의 노드 아이콘을 미니맵에 표시할 때의 최대 거리를 설정합니다."
L["The Frozen Sea"] = "얼어붙은 바다"
L["The North Sea"] = "북해"
L["Toggle showing archaeology nodes."] = "고고학 노드를 표시합니다."
L["Toggle showing fishing nodes."] = "낚시 노드를 표시합니다."
L["Toggle showing gas clouds."] = "가스 구름을 표시합니다."
L["Toggle showing herbalism nodes."] = "약초채집 노드를 표시합니다."
L["Toggle showing Minimap icons."] = "미니맵에 아이콘을 표시합니다."
L["Toggle showing Minimap icon tooltips."] = "미니맵 아이콘에 툴팁을 표시합니다."
L["Toggle showing mining nodes."] = "채광 노드를 표시합니다."
L["Toggle showing the tracking circle."] = "가까운 노드에 갔을 경우 미니맵 아이콘을 동그라미 테두리로 변경하여 표시합니다."
L["Toggle showing treasure nodes."] = "보물상자 노드를 표시합니다."
L["Toggle showing World Map icons."] = "세계 지도에 아이콘을 표시합니다."
L["Tracking Circle Color"] = "아이콘 테두리 색상"
L["Tracking Distance"] = "추적 거리"
L["Treasure"] = "보물상자"
L["Treasure filter"] = "보물상자 분류"
L["Wrath of the Lich King"] = "리치왕의 분노"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "koKR")
if not NL then return end

NL["Abundant Bloodsail Wreckage"] = "풍부한 붉은해적단 잔해"
NL["Abundant Firefin Snapper School"] = "풍부한 불지느러미퉁돔 떼"
NL["Abundant Oily Blackmouth School"] = "풍부한 기름기 많은 아귀 떼"
NL["Adamantite Bound Chest"] = "아다만타이트 궤짝"
NL["Adamantite Deposit"] = "아다만타이트 광맥"
NL["Adder's Tongue"] = "얼레지 꽃"
NL["Albino Cavefish School"] = "백색 동굴어 떼"
NL["Algaefin Rockfish School"] = "심해 총명어 떼"
NL["Ancient Lichen"] = "고대 이끼"
NL["Arcane Vortex"] = "비전 소용돌이"
NL["Arctic Cloud"] = "북극 구름"
NL["Arthas' Tears"] = "아서스의 눈물"
NL["Azshara's Veil"] = "아즈샤라의 신비"
NL["Battered Chest"] = "찌그러진 궤짝"
NL["Battered Footlocker"] = "찌그러진 사물함"
NL["Blackbelly Mudfish School"] = "검은배 미꾸라지 떼"
NL["Black Lotus"] = "검은 연꽃"
NL["Blindweed"] = "실명초"
NL["Blood of Heroes"] = "영웅의 피"
NL["Bloodpetal Sprout"] = "붉은꽃잎 씨앗"
NL["Bloodsail Wreckage"] = "붉은해적단 잔해"
NL["Bloodthistle"] = "피 엉겅퀴"
NL["Bloodvine"] = "피엉겅퀴"
NL["Bluefish School"] = "게르치 떼"
NL["Borean Man O' War School"] = "북풍 해파리 떼"
NL["Bound Adamantite Chest"] = "잠긴 아다만타이트 궤짝" -- Needs review
NL["Bound Fel Iron Chest"] = "잠긴 지옥무쇠 궤짝"
NL["Brackish Mixed School"] = "검은색 물고기 떼"
NL["Briarthorn"] = "찔레가시"
NL["Brightly Colored Egg"] = "알록달록한 알"
NL["Bruiseweed"] = "생채기풀"
NL["Buccaneer's Strongbox"] = "해적의 금고"
NL["Burial Chest"] = "매장된 궤짝"
NL["Cinderbloom"] = "재투성이꽃"
NL["Cinder Cloud"] = "잿더미 구름"
NL["Cobalt Deposit"] = "코발트 광맥"
NL["Copper Vein"] = "구리 광맥"
NL["Dark Iron Deposit"] = "검은무쇠 광맥"
-- NL["Dark Iron Treasure Chest"] = "Dark Iron Treasure Chest"
NL["Deep Sea Monsterbelly School"] = "깊은 바다 뚱뚱보물고기 떼"
-- NL["Deepsea Sagefish School"] = "Deepsea Sagefish School"
NL["Dented Footlocker"] = "움푹 파인 사물함"
NL["Draenei Archaeology Find"] = "드레나이 고고학 발굴품"
NL["Dragonfin Angelfish School"] = "용지느러미 천사돔 떼"
NL["Dragon's Teeth"] = "용 송곳니"
NL["Dreamfoil"] = "꿈풀"
NL["Dreaming Glory"] = "꿈초롱이"
NL["Dwarf Archaeology Find"] = "드워프 고고학 발굴품"
NL["Earthroot"] = "뱀뿌리"
NL["Elementium Vein"] = "엘레멘티움 광맥"
NL["Everfrost Chip"] = "영원의 서리 파편"
NL["Fadeleaf"] = "미명초"
NL["Fangtooth Herring School"] = "송곳니 청어 떼"
NL["Fathom Eel Swarm"] = "심연 뱀장어 떼"
NL["Fel Iron Chest"] = "지옥무쇠 궤짝"
NL["Fel Iron Deposit"] = "지옥무쇠 광맥"
NL["Felmist"] = "지옥 안개"
NL["Felsteel Chest"] = "지옥강철 궤짝"
NL["Feltail School"] = "지옥꼬리퉁돔 떼"
NL["Felweed"] = "지옥풀"
NL["Firebloom"] = "화염초"
NL["Firefin Snapper School"] = "불지느러미퉁돔 떼"
NL["Firethorn"] = "화염가시풀"
NL["Flame Cap"] = "불꽃송이"
NL["Floating Debris"] = "표류하는 파편"
NL["Floating Wreckage"] = "표류하는 잔해"
NL["Floating Wreckage Pool"] = "Floating Wreckage Pool"
NL["Fossil Archaeology Find"] = "화석 고고학 발굴품"
NL["Frost Lotus"] = "서리 연꽃"
NL["Frozen Herb"] = "얼어붙은 약초"
NL["Ghost Mushroom"] = "유령버섯"
NL["Giant Clam"] = "대합"
NL["Glacial Salmon School"] = "빙하연어 떼"
NL["Glassfin Minnow School"] = "유리지느러미 송사리 떼"
NL["Glowcap"] = "초롱버섯"
NL["Goldclover"] = "황금토끼풀"
NL["Golden Sansam"] = "황금 산삼"
NL["Goldthorn"] = "황금가시"
NL["Gold Vein"] = "금 광맥"
NL["Grave Moss"] = "무덤이끼"
NL["Greater Sagefish School"] = "대형 총명어 떼"
NL["Gromsblood"] = "그롬의 피"
NL["Heartblossom"] = "심장꽃"
NL["Heavy Fel Iron Chest"] = "무거운 지옥무쇠 궤짝"
NL["Highland Guppy School"] = "고원 송사리 떼"
NL["Highland Mixed School"] = "고원의 물고기 떼"
-- NL["Huge Obsidian Slab"] = "Huge Obsidian Slab"
NL["Icecap"] = "얼음송이"
NL["Icethorn"] = "얼음가시"
NL["Imperial Manta Ray School"] = "황제 쥐가오리 떼"
NL["Incendicite Mineral Vein"] = "발연 광석 광맥"
NL["Indurium Mineral Vein"] = "인듀리움 광맥"
NL["Iron Deposit"] = "철 광맥"
NL["Khadgar's Whisker"] = "카드가의 수염"
NL["Khorium Vein"] = "코륨 광맥"
NL["Kingsblood"] = "왕꽃잎풀"
NL["Large Battered Chest"] = "낡은 대형 궤짝"
NL["Large Darkwood Chest"] = "Large Darkwood Chest"
NL["Large Iron Bound Chest"] = "큰 철제 궤짝"
NL["Large Mithril Bound Chest"] = "큰 미스릴 궤짝"
NL["Large Obsidian Chunk"] = "풍부한 흑요암 광맥"
NL["Large Solid Chest"] = "크고 단단한 궤짝"
NL["Lesser Bloodstone Deposit"] = "저급 혈석 광맥"
NL["Lesser Firefin Snapper School"] = "소량의 불지느러미퉁돔 떼"
NL["Lesser Floating Debris"] = "소량의 표류하는 파편"
NL["Lesser Oily Blackmouth School"] = "소량의 기름기 많은 아귀 떼"
NL["Lesser Sagefish School"] = "소량의 총명어 떼"
NL["Lichbloom"] = "시체꽃"
NL["Liferoot"] = "생명의 뿌리"
NL["Mageroyal"] = "마법초"
NL["Mana Thistle"] = "마나 엉겅퀴"
-- NL["Maplewood Treasure Chest"] = "Maplewood Treasure Chest"
NL["Mithril Deposit"] = "미스릴 광맥"
NL["Moonglow Cuttlefish School"] = "달빛 오징어 떼"
NL["Mossy Footlocker"] = "이끼투성이 사물함"
NL["Mountain Silversage"] = "은초롱이"
NL["Mountain Trout School"] = "산악 송어 떼"
-- NL["Muddy Churning Water"] = "Muddy Churning Water"
NL["Mudfish School"] = "미꾸라지 떼"
NL["Musselback Sculpin School"] = "조개등 둑중개 떼"
-- NL["Mysterious Camel Figurine"] = "Mysterious Camel Figurine"
NL["Nerubian Archaeology Find"] = "네루비안 고고학 발굴품"
NL["Netherbloom"] = "황천꽃"
NL["Nethercite Deposit"] = "황천연 광맥"
NL["Netherdust Bush"] = "황천티끌 덤불"
NL["Netherwing Egg"] = "황천용 알"
NL["Nettlefish School"] = "해파리 떼"
NL["Night Elf Archaeology Find"] = "나이트 엘프 고고학 발굴품"
NL["Nightmare Vine"] = "악몽의 덩굴"
NL["Obsidian Chunk"] = "흑요암 광맥"
NL["Obsidium Deposit"] = "흑요암 광맥"
NL["Oil Spill"] = "떠다니는 기름"
NL["Oily Blackmouth School"] = "기름기 많은 아귀 떼"
NL["Ooze Covered Gold Vein"] = "진흙으로 덮인 금 광맥"
NL["Ooze Covered Mithril Deposit"] = "진흙으로 덮인 미스릴 광맥"
NL["Ooze Covered Rich Thorium Vein"] = "진흙으로 덮인 풍부한 토륨 광맥"
NL["Ooze Covered Silver Vein"] = "진흙으로 덮인 은 광맥"
NL["Ooze Covered Thorium Vein"] = "진흙으로 덮인 토륨 광맥"
NL["Ooze Covered Truesilver Deposit"] = "진흙으로 덮인 진은 광맥"
NL["Orc Archaeology Find"] = "오크 고고학 발굴품"
NL["Other Archaeology Find"] = "일반 고고학 발굴품"
NL["Patch of Elemental Water"] = "정기가 흐르는 물 웅덩이"
NL["Peacebloom"] = "평온초"
NL["Plaguebloom"] = "역병초"
NL["Pool of Fire"] = "불타는 웅덩이"
NL["Practice Lockbox"] = "연습용 숙련 자물쇠"
NL["Primitive Chest"] = "구식 궤짝"
NL["Pure Saronite Deposit"] = "순수한 사로나이트 광맥"
NL["Pure Water"] = "깨끗한 물"
NL["Purple Lotus"] = "보라 연꽃"
NL["Pyrite Deposit"] = "황철석 광맥"
NL["Ragveil"] = "가림막이버섯"
NL["Rich Adamantite Deposit"] = "풍부한 아다만타이트 광맥"
NL["Rich Cobalt Deposit"] = "풍부한 코발트 광맥"
NL["Rich Elementium Vein"] = "풍부한 엘레멘티움 광맥"
NL["Rich Obsidium Deposit"] = "풍부한 흑요암 광맥"
NL["Rich Pyrite Deposit"] = "풍부한 황철석 광맥"
NL["Rich Saronite Deposit"] = "풍부한 사로나이트 광맥"
NL["Rich Thorium Vein"] = "풍부한 토륨 광맥"
NL["Runestone Treasure Chest"] = "마법석 보물 상자"
NL["Sagefish School"] = "총명어 떼"
NL["Saronite Deposit"] = "사로나이트 광맥"
NL["Scarlet Footlocker"] = "붉은 사물함"
NL["School of Darter"] = "황금 화살고기 떼"
NL["School of Deviate Fish"] = "돌연변이 물고기 떼"
NL["School of Tastyfish"] = "맛둥어 떼"
NL["Schooner Wreckage"] = "범선 잔해"
NL["Shipwreck Debris"] = "난파선 파편"
NL["Silken Treasure Chest"] = "비단결 보물 상자"
NL["Silverbound Treasure Chest"] = "은제 보물 상자"
NL["Silverleaf"] = "은엽수 덤불"
NL["Silver Vein"] = "은 광맥"
NL["'Small Obsidian Chunk"] = "작은 흑요암 광맥"
NL["Small Obsidian Chunk"] = "작은 흑요암 광맥"
NL["Small Thorium Vein"] = "작은 토륨 광맥"
NL["Solid Chest"] = "단단한 궤짝"
NL["Solid Fel Iron Chest"] = "무거운 지옥무쇠 궤짝"
NL["Sorrowmoss"] = "슬픔이끼"
NL["Sparse Firefin Snapper School"] = "드문드문한 불지느러미퉁돔 떼"
NL["Sparse Oily Blackmouth School"] = "드문드문한 기름기 많은 아귀 떼"
NL["Sparse Schooner Wreckage"] = "드문드문한 범선 잔해"
NL["Sporefish School"] = "포자물고기 떼"
NL["Steam Cloud"] = "증기 구름"
NL["Steam Pump Flotsam"] = "증기 양수기 부품"
NL["Stonescale Eel Swarm"] = "돌비늘뱀장어 떼"
NL["Stormvine"] = "폭풍덩굴"
NL["Strange Pool"] = "Strange Pool"
NL["Stranglekelp"] = "갈래물풀"
NL["Sturdy Treasure Chest"] = "튼튼한 보물 상자"
NL["Sungrass"] = "태양풀"
NL["Swamp Gas"] = "늪지대 가스"
NL["Talandra's Rose"] = "탈란드라의 장미"
NL["Tattered Chest"] = "낡은 상자"
NL["Teeming Firefin Snapper School"] = "우글거리는 불지느러미퉁돔 떼"
NL["Teeming Floating Wreckage"] = "우글거리는 표류하는 잔해"
NL["Teeming Oily Blackmouth School"] = "우글거리는 기름기 많은 아귀 떼"
NL["Terocone"] = "테로열매"
NL["Tiger Lily"] = "참나리"
NL["Tin Vein"] = "주석 광맥"
NL["Titanium Vein"] = "티타늄 광맥"
NL["Tol'vir Archaeology Find"] = "톨비르 고고학 발굴품"
NL["Troll Archaeology Find"] = "트롤 고고학 발굴품"
NL["Truesilver Deposit"] = "진은 광맥"
NL["Twilight Jasmine"] = "황혼의 말리꽃"
NL["Un'Goro Dirt Pile"] = "운고로 흙더미"
NL["Vrykul Archaeology Find"] = "브리쿨 고고학 발굴품"
NL["Waterlogged Footlocker"] = "흠뻑 젖은 사물함"
NL["Waterlogged Wreckage"] = "Waterlogged Wreckage"
NL["Whiptail"] = "채찍꼬리"
NL["Wicker Chest"] = "고리버들 상자"
NL["Wild Steelbloom"] = "야생 철쭉"
NL["Windy Cloud"] = "흩어지는 구름"
NL["Wintersbite"] = "겨울서리풀"

