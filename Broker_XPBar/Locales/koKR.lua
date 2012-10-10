--[[ *******************************************************************
Project                 : Broker_XPBar
Description             : Korean translation file (koKR)
Author                  : next96
Translator              : 
Revision                : $Rev: 1 $
********************************************************************* ]]

local ADDON = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON, "koKR")
if not L then return end

L["Bar Properties"] = "바 속성"
L["Set the Bar Properties"] = "바에 대한 설정입니다."

L["Show XP Bar"] = "경험치 바 표시"
L["Show the XP Bar"]  = "경험치 바를 표시합니다."
L["Show Reputation Bar"] = "평판 바 표시"
L["Show the Reputation Bar"] = "평판 바를 표시합니다."
L["Spark intensity"] = "광채 밝기"
L["Brightness level of Spark"] = "현재 경험치/평판 바의 광채의 밝기를 조절합니다."
L["Thickness"] = "두께"
L["Set thickness of the Bars"] = "바의 두께를 조정합니다."
L["Shadow"] = "그림자"
L["Toggle Shadow"] = "바에 그림자 무늬를 넣습니다."
L["Inverse Order"] = "역순"
L["Place reputation bar before XP bar"] = "경험치 바 전에 평판 바를 위치 시킵니다."
L["Other Texture"] = "다른 무늬"
L["Use external texture for bar instead of the one provided with the addon"] = "애드온에 사용할 외부의 다른 무늬를 선택합니다."
L["Bar Texture"] = "바 무늬"
L["Texture of the bars."] = "바 무늬 입니다."
L["If you want more textures, you should install the addon 'SharedMedia'."] = "추가적인 무늬를 원하면, 'SharedMedia' 애드온을 설치해야 합니다."
L["per Tick"] = "(마다)"
L["Ticks"] = "틱"
L["Set number of ticks shown on the bar."] = "바에 표시할 틱의 갯수를 선택합니다."

L["Frame"] = "프레임"
L["Frame Connection Properties"] = "바 연결에 대한 설정입니다."

L["Frame to attach to"] = "바의 종속 프레임"
L["The exact name of the frame to attach to"] = "바를 어느 프레임에 종속하여 표시할 지 프레임의 이름을 입력합니다."
L["Select by Mouse"] = "마우스 선택"
L["Click to activate the frame selector (Left-Click to select frame, Right-Click do deactivate selector)"] = "마우스로 클릭하여 프레임을 선택합니다. (왼쪽 클릭으로 프레임 선택, 오른쪽 클릭으로 선택을 취소합니다.)"
L["This frame has no global name and cannot be used"] = "이 프레임은 프레임 이름이 없어서 바를 위치시킬 수 없습니다."
L["Attach to side"] = "종속 위치"
L["Select side to attach the bars to"] = "바를 선택한 프레임의 어느 위치에 표시할 것인지 선택합니다."
L["X-Offset"] = "X 기준위치"
L["Set x-Offset of the bars"] = "바의 가로 기준위치를 조정합니다."
L["Y-Offset"] = "Y 기준위치"
L["Set y-Offset of the bars"] = "바의 세로 기준위치를 조정합니다."
L["Strata"] = "프레임 레벨"
L["Select the strata of the bars"] = "바의 프레임 레벨을 선택합니다."
L["Inside"] = "안쪽"
L["Attach bars to the inside of the frame"] = "바를 프레임의 안쪽에 위치시킵니다."
L["Inverse Order"] = "순서 변경"
L["Place reputation bar before XP bar"] = "경험치 바 보다 평판 바를 먼저 표시합니다."
L["Jostle"] = "밀어내기"
L["Jostle Blizzard Frames"] = "블리자드 프레임을 겹치지 않도록 이동시킵니다."
L["Refresh"] = "갱신"
L["Refresh Bar Position"] = "바의 위치를 갱신합니다."

L["Colors"] = "색상"
L["Set the Bar Colors"] = "바의 색상에 대한 설정입니다."

L["Current XP"] = "현재 경험치"
L["Set the color of the XP Bar"] = "경험치 바의 색상을 변경합니다."
L["Rested XP"] = "휴식 경험치"
L["Set the color of the Rested Bar"] = "휴식 경험치 바의 색상을 변경합니다."
L["No XP"] = "경험치 없음"
L["Set the empty color of the XP Bar"] = "경험치가 없는 경우 바의 색상을 변경합니다."
L["Reputation"] = "평판"
L["Set the color of the Rep Bar"] = "평판 바의 색상을 변경합니다."
L["No Rep"] = "평판 없음"
L["Set the empty color of the Reputation Bar"] = "선택한 평판이 없거나 획득할 평판이 없는 경우 바의 색상을 변경합니다."
L["Blizzard Rep Colors"] = "블리자드 평판 색상"
L["Toggle Blizzard Reputation Colors"] = "블리자드 평판 색상으로 전환합니다."

L["Broker Label"] = "브로커 표시"
L["Broker Label Properties"] = "브로커의 표시 항목에 대한 설정입니다."

L["Select Label Text"] = "표시 항목 선택"
L["Select label text for Broker display"] = [[브로커에 표시할 항목을 선택합니다.:
|cffffff00없음|r - 애드온 이름을 표시합니다..
|cffffff00다음레벨까지 필요한 킬 수|r - 다음 레벨까지 잡아야하는 몬스터의 수를 표시합니다..
|cffffff00다음레벨까지 시간|r - 다음 레벨까지 올리는데 필요한 시간을 표시합니다..
|cffffff00평판|r - 평판의 이름과 현재 평판 상태 및 백분율을 표시합니다.
|cffffff00경험치|r - 경험치와 백분율을 표시합니다.
|cffffff00경험치보다 평판|r - 평판을 기본으로 표시하고 평판이 없으면 경험치를 표시합니다.
|cffffff00평판보다 경험치|r - 경험치를 기본으로 표시하고 최대 레벨이 되었을 때 평판을 표시합니다.]]

L["XP/Rep to go"] = "다음 레벨까지 경험치/평판"
L["Show XP/Rep to go in label"] = "다음 레벨까지 필요한 경험치 또는 평판을 표시합니다."
L["Percentage only"] = "백분율"
L["Show percentage only"] = "백분율로만 표시합니다."
L["Show faction name"] = "평판 이름 표시"
L["Show faction name when reputation is selected as label text."] = "평판 이름을 표시합니다."
L["Colored Label"] = "색상화된 글자"
L["Color label text based on percentages"] = "백분율에 따라 글자를 색상화하여 표시합니다."
L["Separators"] = "천단위 구분"
L["Use separators for numbers to improve readability"] = "숫자를 천단위로 구분하여 표시합니다."
L["Abbreviations"] = "축약 표시"
L["Use abbreviations to shorten numbers"] = "숫자를 백만 단위로 축약하여 표시합니다."
L["Tip Abbreviations"] = "툴팁 축약 표시"
L["Use abbreviations in tooltip"] = "툴팁의 숫자를 백만 단위로 축약하여 표시합니다."
L["Decimal Places"] = "소수점 표시"
L["Number of decimal places when using abbreviations"] = "축약 표시시에 소수점 자리를 선택합니다."

L["Faction Tracking"] = "평판"
L["Auto-switch watched faction on reputation gains/losses."] = "평판을 획득하거나 잃어버릴 경우 자동으로 해당 평판으로 바를 변경합니다."

L["Switch on rep gain"] = "획득 시 자동 변경"
L["Auto-switch watched faction on reputation gain."] = "평판을 획득 시에 자동으로 바에 표시합니다."
L["Switch on rep loss"] = "손실 시 자동 변경"
L["Auto-switch watched faction on reputation loss."] = "평판을 손실 시에 자동으로 바에 표시합니다."

L["Leveling"] = "레벨"
L["Leveling Properties"] = "레벨에 대한 설정입니다."

L["Time Frame"] = "시간 프레임"
L["Time frame for dynamic TTL calculation."] = "다음 레벨까지 걸리는 시간을 위한 프레임입니다."
L["Weight"] = "가중치"
L["Weight time frame vs. session average for dynamic TTL calculation."] = "다음 레벨까지 걸리는 시간을 측정하는데 필요한 평균 접속 시간에 대한 가중치입니다."

L["Max. XP/Rep"] = "최대 경험치/평판"
L["Display settings at maximum level/reputation"] = "최대 레벨이 되거나 평판이 확고한 동맹일 경우 표시할 항목에 대한 설정입니다."

L["No XP label"] = "경험치 표시 안함"
L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."] = "최대 레벨에 도달하면 경험치를 표시하지 않습니다."
L["No XP bar"] = "경험치 바 표시 안함"
L["Don't show XP bar at maximum level."] = "최대 레벨에 도달하면 경험치 바를 표시하지 않습니다."
L["No Rep label"] = "평판 표시 안함"
L["Don't show label text at maximum Reputation. Affects Rep option only."] = "확고한 동맹이 되면 평판을 표시하지 않습니다."
L["No Rep bar"] = "평판 바 표시 안함"
L["Don't show Rep bar at maximum Reputation."] = "확고한 동맹이 되면 평판 바를 표시하지 않습니다."

L["Faction"] = "평판"
L["Select Faction"] = "평판을 표시합니다."
L["Blizzard Bars"] = "블리자드 바"
L["Show default Blizzard Bars"] = "블리자드 기본 바를 표시합니다."
L["Minimap Button"] = "미니맵 버튼"
L["Show Minimap Button"] = "미니맵 버튼을 표시합니다."
L["Hide Hint"] = "힌트 숨김"
L["Hide usage hint in tooltip"] = "툴팁에 힌트를 숨깁니다."

L["Max Level"] = "최대 레벨"
L["No watched faction"] = "추적하는 평판이 없습니다."
				
L["%s: %3.0f%% (%s/%s) %s left"] = "%s: %3.0f%% (%s/%s) %s 남음"

L["Level"] = "레벨"
L["Current XP"] = "현재 경험치"
L["Rested XP"] = "휴식 경험치"
L["To next level"] = "필요 경험치"
L["Session XP"] = "현재 접속 경험치"
L["Session kills"] = "현재 접속 죽인 수"
L["XP per hour"] = "시간당 경험치"
L["Kills per hour"] = "시간당 죽인수"
L["Time to level"] = "레벨당 시간"
L["Kills to level"] = "필요한 킬수"

L["Faction"] = "평판"
L["Standing"] = "등급"
L["Current reputation"] = "현재 평판"
L["To next standing"] = "다음 등급"
L["Session rep"] = "현재 접속 평판"
L["Rep per hour"] = "시간당 평판"

L["Click"] = "클릭"
L["Shift-Click"] = "쉬프트+클릭"
L["Right-Click"] = "오른쪽+클릭"
L["Send current XP to an open editbox."] = "대화창에 현재 레벨의 경험치를 입력합니다."
L["Send current reputation to an open editbox."] = "대화창에 현재 평판을 입력합니다."
L["Open option menu."] = "설정 메뉴를 엽니다."

L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"] = "%s/%s (%3.0f%%) %d 남음 (%3.0f%% 휴식 경험치)"
L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"] = "%s: %s/%s (%3.2f%%) 현재 상태 %s %d 남음"

L["Usage:"] = "사용법"
L["/brokerxpbar arg"] = "/brokerxpbar 명령어"
L["/bxp arg"] = "/bxp 명령어"
L["Args:"] = "명령어:"
L["version - display version information"] = "version - 현재 버전의 정보를 표시합니다."
L["menu - display options menu"] = "menu - 설정 메뉴를 엽니다."
L["help - display this help"] = "help - 현재 보고 있는 도움말을 표시합니다."

L["Maximum level reached."] = "최대 레벨이 되었습니다."
L["Currently no faction tracked."] = "현재 추적하고 있는 평판이 없습니다."
L["Version"] = "버전"

L["Top"] = "상" 
L["Bottom"] = "하"
L["Left"] = "좌" 
L["Right"] = "우" 

L["None"] = "없음"
L["XP"] = "경험치"
L["Kills to Level"] = "다음레 벨까지 필요 킬 수"
L["Time to Level"] = "다음 레벨까지 시간"
L["Rep"] = "평판"
L["Time to Level Rep"] = "다음 평판까지 시간"
L["XP over Rep"] = "평판보다 경험치"
L["Rep over XP"] = "경험치보다 평판"

L[","] = true
L["."] = true

L["k"] = true
L["m"] = true
L["bn"] = true
