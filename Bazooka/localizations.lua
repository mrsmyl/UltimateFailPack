local AppName = ...
local AL = LibStub("AceLocale-3.0")
local L = AL:NewLocale(AppName, "enUS", true)

L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fDrag|r to move the frame"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fLeft Click|r to lock/unlock frames"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fRight Click|r to open the configuration window"
L["Disable %s plugin?"] = "Disable %s plugin?"
L["Bar"] = "Bar"
L["Bar#%d"] = "Bar#%d"
L["left"] = "Left"
L["cleft"] = "Center-Left"
L["center"] = "Center"
L["cright"] = "Center-Right"
L["right"] = "Right"
L["top"] = "Top"
L["bottom"] = "Bottom"
L["none"] = "None"

-----------------------------------------------------------------------------

L = AL:NewLocale(AppName, "deDE")
if L then
L["Bar#%d"] = "Leiste#%d"
L["bottom"] = "Unten"
L["center"] = "Mitte"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fZiehen|r um das Fenster zu verschieben"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fLinksklick|r um die Fenster zu sperren/entsperren"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fRechtsklick|r um das Konfigurationsmenü zu öffnen"
L["cleft"] = "Mitte links"
L["cright"] = "Mitte rechts"
L["Disable %s plugin?"] = "%s-Plugin deaktivieren?"
L["left"] = "Links"
L["none"] = "Nichts"
L["right"] = "Rechts"
L["top"] = "Oben"

end

L = AL:NewLocale(AppName, "esES")
if L then
L["Bar#%d"] = "Barra#%d"
L["bottom"] = "Abajo"
L["center"] = "Centro"
L["|cffeda55fDrag|r to move the frame"] = " |cffeda55fArrastra|r para mover el marco"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fClick Izquierdo|r para bloquear/desbloquear los marcos"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fClick Derecho|r para abrir la ventana de configuración"
L["cleft"] = "Centro-Izquierda"
L["cright"] = "Centro-Derecha"
L["Disable %s plugin?"] = "¿Desactivar el plugin %s?"
L["left"] = "Izquierda"
L["none"] = "Nada"
L["right"] = "Derecha"
L["top"] = "Arriba"

end

L = AL:NewLocale(AppName, "esMX")
if L then
L["Bar#%d"] = "Barra#%d"
L["bottom"] = "Abajo"
L["center"] = "Centro"
L["|cffeda55fDrag|r to move the frame"] = " |cffeda55fArrastra|r para mover el marco"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fClick Izquierdo|r para bloquear/desbloquear los marcos"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fClick Derecho|r para abrir la ventana de configuración"
L["cleft"] = "Centro-Izquierda"
L["cright"] = "Centro-Derecha"
L["Disable %s plugin?"] = "¿Desactivar el plugin %s?"
L["left"] = "Izquierda"
L["none"] = "Nada"
L["right"] = "Derecha"
L["top"] = "Arriba"

end

L = AL:NewLocale(AppName, "frFR")
if L then
L["Bar#%d"] = "Barre#%d"
L["bottom"] = "Bas"
L["center"] = "Centre"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fSaisir|r pour déplacer le cadre."
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fClic gauche|r pour (dé)verouiller les cadres."
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fClic droit|r pour ouvrir la fenêtre de configuration."
L["cleft"] = "Centre-gauche"
L["cright"] = "Centre-droite"
L["Disable %s plugin?"] = "Désactiver le plugin %s ?"
L["left"] = "Gauche"
L["none"] = "Aucun"
L["right"] = "Droite"
L["top"] = "Haut"

end

L = AL:NewLocale(AppName, "koKR")
if L then
L["Bar#%d"] = "바#%d"
L["bottom"] = "아래"
L["center"] = "가운데"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f드레그|r 프레임 이동"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "| cffeda55fLeft 클릭 | r에 잠금 / 잠금 해제 프레임"
L["|cffeda55fRight Click|r to open the configuration window"] = "| cffeda55fRight 클릭 | r에 구성 창을 엽니다"
L["cleft"] = "중좌"
L["cright"] = "중우"
L["Disable %s plugin?"] = "%s 플러그인 해제?"
L["left"] = "좌"
L["none"] = "없음"
L["right"] = "우"
L["top"] = "위"

end

L = AL:NewLocale(AppName, "ruRU")
if L then
L["Bar#%d"] = "Панель#%d"
L["bottom"] = "Снизу"
L["center"] = "В центре"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fТащите|r для перемещения фрейма"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fЛевый клик|r - разблокирова/блокировать фрейм"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fПравый клик|r - открываетокно настроек"
L["cleft"] = "В центре-слева"
L["cright"] = "В центре-справа"
L["Disable %s plugin?"] = "Отключит плагин %s?"
L["left"] = "Слева"
L["none"] = "Нету"
L["right"] = "Справа"
L["top"] = "Сверху"

end

L = AL:NewLocale(AppName, "zhCN")
if L then
L["Bar#%d"] = "栏#%d"
L["bottom"] = "底部"
L["center"] = "居中"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f拖拽|r移动该框"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f点击|r锁定/解锁该框"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f右键|r打开设置窗口"
L["cleft"] = "中偏左"
L["cright"] = "中偏右"
L["Disable %s plugin?"] = "关闭组件 %s ？"
L["left"] = "居左"
L["none"] = "无"
L["right"] = "居右"
L["top"] = "顶部"

end

L = AL:NewLocale(AppName, "zhTW")
if L then
L["Bar#%d"] = "條列#%d"
L["bottom"] = "底部"
L["center"] = "中心"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f拖曳|r移動框架"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f左鍵點擊|r鎖定/解鎖框架"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f右鍵點擊|r開啟配置視窗"
L["cleft"] = "中左"
L["cright"] = "中右"
L["Disable %s plugin?"] = "停用 %s 插件?"
L["left"] = "左"
L["none"] = "無"
L["right"] = "右"
L["top"] = "頂部"

end

L = AL:NewLocale(AppName, "ptBR")
if L then
L["Bar#%d"] = "Barra#%d"
L["bottom"] = "Baixo"
L["center"] = "Centro"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fArraste|r para mover o quadro"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fBotão Esquerdo do Mouse|r Para travar/destravar quadros"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fBotão Direito do Mouse|r Para abrir a janela de configuração"
L["cleft"] = "Centro-Esquerda"
L["cright"] = "Centro-Direita"
L["Disable %s plugin?"] = "Desativar Plug?" -- Needs review
L["left"] = "Esquerda"
L["none"] = "Nenhum"
L["right"] = "Direita"
L["top"] = "Cima"

end

L = AL:NewLocale(AppName, "itIT")
if L then

end

