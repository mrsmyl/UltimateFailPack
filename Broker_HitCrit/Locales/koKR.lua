--[[
************************************************************************
Project				: Broker_HitCrit
Author				: zhinjio
Project Revision	: 2.6-release
Project Date		: 20081228205256

File				: Locales\koKR.lua
Commit Author		: zhinjio
Commit Revision		: 51
Commit Date			: 20081228205256
************************************************************************
Description	:
	Korean translation strings
TODO		:
************************************************************************
(see bottom of file for changelog)
************************************************************************
--]]
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale("HitCrit", "koKR")
if not L then return end

L["%s for %s against %s"] = "%s : %s (%s)"
L["ALERT_CHATFRAME_DESC"] = "기록이 갱신되면 대화창에 일립니다."
L["ALERT_MSBTAREA_DESC"] = "MSBT 메시지에 표시합니다."
L["ALERT_MSBT_DESC"] = "MSBT가 설치되어 있다면 메시지를 MSBT에 표시합니다."
L["ALERT_NOTIFY_DESC"] = "기록이 갱신되면 화면에 알립니다."
L["ALERT_OPTIONS_DESC"] = "기록 갱신시 화면 표시에 관한 설정입니다."
L["ALERT_PARROTAREA_DESC"] = "Parrot 메시지에 표시합니다."
L["ALERT_PARROT_DESC"] = "Parrot이 설치되어 있다면 메시지를 Parrot에 표시합니다."
L["ALERT_SCREENIE_DESC"] = "기록이 갱신되었을 때 자동으로 스크린샷을 찍습니다."
L["ALERT_SELECTMSBTAREA_DESC"] = "사용할 MSBT 메시지 영역을 선택합니다."
L["ALERT_SELECTPARROTAREA_DESC"] = "사용할 Parrot 메시지 영역을 선택합니다."
L["ALERT_SOUND_DESC"] = "기록이 갱신되면 소리로 알립니다."
L["ALERT_SUPERBUFF_TOGGLE"] = "선택하면 대화창에 이상 강화 효과를 알리지 않습니다."
L["ARGENT_TOGGLE_DESC"] = "마상 시합의 주문을 기록하지 않습니다."
L["Against"] = "몬스터 이름"
L["Alert Options"] = "경보 설정"
L["Alert in Chat Frame"] = "대화창 경보"
L["Alert in MSBT Scroll Area"] = "MSBT로 표시"
L["Alert in Parrot Scroll Area"] = "Parrot으로 표시"
L["Alert with Notify"] = "알림 경보"
L["Alert with Sound"] = "소리 경보"
L["Alt-Left-click to delete values"] = "Alt-왼쪽 클릭으로 값을 삭제합니다."
L["Alt-Right-click for to see Alternate Spec"] = "Alt+오른쪽 클릭으로 다른 특성을 봅니다."
L["Alt-Right-click to see Active Spec"] = "Alt+오른쪽 클릭으려 현재 활성화된 특성을 봅니다."
L["Alt-Right-click to see Inactive Spec"] = "Alt+오른쪽 클릭으로 비활성화된 특성을 봅니다."
L["Argent Tourney"] = "마상 시합"
L["Author : "] = "제작자: "
L["Avg"] = "평균"
L["Broker_HitCrit"] = "HitCrit"
L["Build Date : "] = "제작일: "
L["Color Label Text"] = "라벨 글자 색상화표시"
L["Crit"] = "치명타"
L["Critical Heal"] = "치유 극대화"
L["Critical Hit"] = "치명타 공격"
L["DISPLAY_AVG_DESC"] = "기록 정보의 평균 값을 표시합니다."
L["DISPLAY_COLORLABEL_DESC"] = "LDB에 표시되는 글자를 색상화 합니다."
L["DISPLAY_CRIT_DESC"] = "기록 정보의 치명타 값을 표시합니다."
L["DISPLAY_DEBUG_DESC"] = "화면에 디버그 정보를 표시합니다."
L["DISPLAY_ENEMYNAME_DESC"] = "대상의 이름을 표시합니다."
L["DISPLAY_HIT_DESC"] = "기록 정보의 공격력 값을 표시합니다."
L["DISPLAY_LABELDMG_DESC"] = "LDB라벨에 공격력을 표시합니다."
L["DISPLAY_LABELHEAL_DESC"] = "LDB 라벨에 치유량을 표시합니다."
L["DISPLAY_LABEL_DESC"] = "라벨에 공격 및 치명타의 가장 최고값을 표시합니다."
L["DISPLAY_OPTIONS_DESC"] = "화면 표시에 관한 설정입니다."
L["DISPLAY_SORTSCHOOL_DESC"] = "주문의 속성에 따라 정렬합니다."
L["DMG_GLOBAL_TOGGLE_DESC"] = "즉시 모든 속성에 영향을 미치도록 전환합니다."
L["DMG_SCHOOLS_DESC"] = "기록에 공격 속성을 포함합니다."
L["Damage"] = "공격"
L["Damage Schools"] = "공격 속성"
L["Database Version : "] = "DB 버전: "
L["Database upgraded to %s"] = "DB가 %s로 갱신되었습니다."
L["Detect Superbuffs"] = "이상 강화 효과 감지"
L["Display Avg"] = "평균 표시"
L["Display Crit"] = "치명타 표시"
L["Display Debug"] = "디버그 표시"
L["Display Dmg in Label"] = "라벨에 공격력 표시"
L["Display Enemy Name"] = "대상 이름 표시"
L["Display Heal in Label"] = "라벨에 치유 표시"
L["Display Hit"] = "공격력 표시"
L["Display Options"] = "표시 설정"
L["Display Top Values"] = "라벨에 큰값 표시"
L["Draws the icon on the minimap."] = "미니맵에 아이콘을 표시합니다." -- Needs review
L["Effect"] = "기술"
L["Error occurred in the tooltip. I could not report for category (%s) and spell (%s)."] = "툴팁에 오류가 발생했습니다. (%s) 카테고리와 (%s) 주문에 대한 알림을 할 수 없습니다."
L["GENERAL_INFO_DESC"] = "버전 및 제작자 정보"
L["General Information"] = "애드온 정보"
L["Global Damage Toggle"] = "전체 공격 전환"
L["Global Healing Toggle"] = "전체 치유 전환"
L["HEAL_GLOBAL_TOGGLE_DESC"] = "즉시 모든 석송에 영향을 미치도록 전환합니다."
L["HEAL_SCHOOLS_DESC"] = "기록에 치유 속성을 포함합니다."
L["Heal"] = "치유"
L["Healing"] = "치유"
L["Healing Schools"] = "치유 속성"
L["Helpful Translators (thank you) : %s"] = "한글화 : %s"
L["Hit"] = "공격"
L["HitCrit Data Browser"] = "HitCrit 데이터 브라우저"
-- L["If you notice errors or values not updating, try clearing out values."] = "If you notice errors or values not updating, try clearing out values."
L["Inactive Spec"] = "비활성화된 특성"
L["LDB Text Display Options"] = "LDB 글자 표시 설정"
L["LDBDISPLAY_OPTIONS_DESC"] = "LDB에 표시할 값을 변경합니다."
L["Left-click for Data Browser"] = "왼쪽-클릭으로 데이터 브라우저를 엽니다."
L["Left-click to Report values in chat"] = "왼쪽 클릭으로 대화창에 값을 표시합니다."
L["MINIMAP_OPTIONS_DESC"] = "미니맵 아이콘 설정입니다." -- Needs review
L["MISCDISPLAY_OPTIONS_DESC"] = "기타 표시 설정입니다."
L["MSBT Integration"] = "MSBT에 표시"
L["Melee"] = "근접"
L["Minimap Icon Options"] = "미니맵 아이콘 설정" -- Needs review
L["Miscellaneous"] = "기타"
L["Miscellaneous Display Options"] = "기타 설정"
L["New Record %s! %s %s %s for %d"] = "새 |CFF00DDFF%s|r 기록! %s : |CFFFFFF00%s|r %s *|CFFFF0000%d|r*"
L["No"] = "아니오"
L["Notes"] = "노트"
L["Parrot Integration"] = "Parrot에 표시"
L["Please note: All spell suppression, tracking and expansion toggles have been reset."] = "참고: 모든 주문을 제외, 추적, 확장으로 전환이 초기화 되었습니다." -- Needs review
-- L["Please note: Due to changes in 4.2, you may need to clear data."] = "Please note: Due to changes in 4.2, you may need to clear data."
L["Please report this error on the project webpage."] = "애드온 홈페이지에 오류를 보고 해주십시오."
L["RESETALL_TOOLTIP"] = "저장된 모든 데이터를 삭제합니다."
L["RESETCATEGORY_TOOLTIP"] = "현재 선택한 데이터를 삭제합니다."
L["RESETENTRY_TOOLTIP"] = "현재 선택한 기술 데이터를 삭제합니다."
L["RESETSCHOOL_TOOLTIP"] = "현재 선택한 속성 데이터를 삭제합니다."
L["RESETSPECIFIC_TOOLTIP"] = "현재 선택한 기술중 특정 데이터를 삭제합니다."
L["Reset ALL data for '%s'. Are you sure?"] = "%s의 모든 데이터를 삭제하시겠습니까?"
L["Reset All Data"] = "모든 데이터 삭제"
L["Reset Category Data"] = "선택 데이터 삭제"
L["Reset Category: %s, School: %s. Are you sure?"] = "분류 초기화: %s, 속성: %s. 초기화하시겠습니까?"
L["Reset Category: %s. Are you sure?"] = "분류 초기화: %s. 초기화 하시겠습니까?"
L["Reset Entry Data"] = "기술 데이터 삭제"
L["Reset School Data"] = "속성 데이터 삭제"
L["Reset Specific Data"] = "특정 데이터 삭제"
L["Reset all entries for spell: %s. Are you sure?"] = "모든 주문에 대한 목록을 초기화 : %s. 초기화 하시겠습니까?"
L["Reset data for '%s' - '%s'. Are you sure?"] = "%s의 '%s'를 삭제하시겠습니까?"
L["Reset data for '%s' - Category: %s, School: %s. Are you sure?"] = "%s의 %s에 대한 속성: %s 데이터를 삭제하시겠습니까?"
L["Reset data for '%s' - Category: %s. Are you sure?"] = "%s의 %s에 대한 데이터를 삭제하시겠습니까?"
L["Reset data for '%s' - Spell: %s. Are you sure?"] = "%s의 %s에 대한 데이터를 삭제하시겠습니까?"
L["Reset first %s entry for spell: %s. Are you sure?"] = "주문에 대한 첫번째 %s 초기화: %s. 초기화 하시겠습니까?"
L["Right-click for Configuration"] = "오른쪽-클릭으로 설정창을 엽니다."
L["SUPPRESS_DMG_DESC"] = "선택한 주문 공격 속성을 툴팁에 포함할 수 없습니다."
L["SUPPRESS_HEAL_DESC"] = "선택한 치유 주문 속성을 툴팁에 포함할 수 없습니다."
L["SUPPRESS_MISC_DESC"] = "이외의 다른 주문을 기록하지 않습니다."
L["SUPPRESS_NOTES_DESC"] = "보기 설정에서 속성 별로 정렬로 표시했을 때 선택한 속성을 숨길 수 있습니다. 모든 속성을 켜고 끌 수 있습니다."
L["SUPPRESS_OPTIONS_DESC"] = "툴팁에 주문 속성의 숨김을 선택할 수 있는 설정입니다. 수집한 데이터의 속성이 없다면 개별적으로 선택해야 합니다."
L["Select MSBT Scroll Area"] = "MSBT 표시 영역"
L["Select Parrot Scroll Area"] = "Parrot 표시 영역"
L["Show Minimap Icon"] = "미니맵 아이콘 표시" -- Needs review
L["Sort by School"] = "속성 정렬"
L["Suppression Options"] = "숨김 설정"
L["TOOLTIP_DELAY_DESC"] = "툴팁이 표시되는 시간을 설정합니다."
L["TOOLTIP_SCALE_DESC"] = "툴팁의 크기를 변경합니다."
L["TRACKING_OPTIONS_DESC"] = "데이터 수집을 위한 설정입니다."
L["TRACK_AGAINSTME_DESC"] = "상대방으로부터 공격 받은 것을 기록합니다."
L["TRACK_DAMAGE_DESC"] = "공격력을 기록합니다."
L["TRACK_DETECT_SP"] = "선택하면 HitCrit은 이상 강화 효과나 탈 것 사용시 기록을 하지 않습니다."
L["TRACK_ENVIRONMENTAL_DESC"] = "낙하, 화염 등의 환경 공격력을 기록합니다."
L["TRACK_HEALING_DESC"] = "치유량을 기록합니다."
L["TRACK_LOWLEVEL_DESC"] = "낮은 레벨의 몬스터에 대한 정보를 기록합니다."
L["TRACK_PVP_DESC"] = "PvP 정보를 수집합니다."
L["TRACK_VULNERABLE_DESC"] = "대상의 약점에 저항함을 기록합니다."
L["Take Screenshot"] = "스크린샷 찍기"
L["Tooltip Auto-hide Delay"] = "툴팁 숨김 지연시간"
L["Tooltip Scale"] = "툴팁 크기"
L["Track Damage"] = "공격력 기록하기"
L["Track Environmental"] = "환경 기록하기"
L["Track Healing"] = "치유량 기록하기"
L["Track Hits Against Me"] = "공격 받음 기록하기"
L["Track Low Level"] = "저레벨 기록하기"
L["Track PvP"] = "PvP 기록하기"
L["Track Vulnerable"] = "약점 기록하기"
L["Tracking Options"] = "기록 설정"
L["Turn off Superbuff Alerts"] = "이상 강화 효과 경고 끄기"
L["Version : "] = "버전: "
L["Yes"] = "네"
L["You are no longer in a vehicle, but are still superbuffed. HitCrit remains disabled."] = "탈 것을 사용하지 않더라도 이상 강화 효과로 감지합니다. HitCrit는 기록하지 않습니다."
L["You are no longer in a vehicle. HitCrit re-enabled."] = "더 이상 탈 것을 사용하지 않습니다. HitCrit를 재시작 하세요."
L["You are no longer superbuffed. HitCrit re-enabled."] = "캐릭터의 공격력이 정상적으로 측정되었습니다. HitCrit를 다시 사용합니다."
L["You are now in a vehicle (doing higher than normal damage). HitCrit disabled."] = "현재 탈 것 사용중입니다(보통 보다 더 많은 공격력을 가지고 있습니다.) HitCrit에 기록하지 않습니다."
L["You are now superbuffed (doing higher than normal damage). HitCrit disabled."] = "캐릭터의 공격력이 높게 측정되었습니다. HitCrit를 사용하지 않습니다."
L["arcane"] = "비전"
L["casts"] = "시전"
L["chaos"] = "chaos" -- Needs review
L["chromatic"] = "절반" -- Needs review
L["divine"] = "신성" -- Needs review
L["elemental"] = "원소" -- Needs review
L["fire"] = "화염"
L["firestorm"] = "화염폭풍" -- Needs review
L["flamestrike"] = "화염강타" -- Needs review
L["for"] = "for"
L["frost"] = "냉기"
L["frostfire"] = "냉기불꽃"
L["froststorm"] = "냉기폭풍"
L["froststrike"] = "냉기강타" -- Needs review
L["healed"] = "치유받음"
L["holy"] = "신성"
L["holyfire"] = "신성화염" -- Needs review
L["holyfrost"] = "신성냉기" -- Needs review
L["holystorm"] = "신성폭풍" -- Needs review
L["holystrike"] = "신성강타" -- Needs review
L["magic"] = "마법" -- Needs review
L["nature"] = "자연"
L["physical"] = "물리"
L["shadow"] = "암흑"
L["shadowflame"] = "암흑화염" -- Needs review
L["shadowfrost"] = "암흑냉기" -- Needs review
L["shadowlight"] = "암흑빛" -- Needs review
L["shadowstorm"] = "암흑폭풍"
L["shadowstrike"] = "암흑강타" -- Needs review
L["spellfire"] = "주문화염" -- Needs review
L["spellfrost"] = "주문냉기" -- Needs review
L["spellshadow"] = "주문암흑" -- Needs review
L["spellstorm"] = "주문폭풍" -- Needs review
L["spellstrike"] = "주문강타" -- Needs review
L["stormstrike"] = "폭풍강타" -- Needs review
L["with"] = "with"


--[[
************************************************************************
CHANGELOG:

Date : 1/15/08
	switched to using wowace's auto-localization stuff
************************************************************************
]]--