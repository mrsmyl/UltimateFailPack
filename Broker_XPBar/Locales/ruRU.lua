--[[ *******************************************************************
Project                 : Broker_XPBar
Description             : Russian translation file (ruRU)
Author                  : tritium
Translator              : StingerSoft
Revision                : $Rev: 1 $
********************************************************************* ]]

local MODNAME   = "BrokerXPBar"

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(MODNAME, "ruRU")
if not L then return end

L["Bar Properties"] = "Свойства панели"
L["Set the Bar Properties"] = "Свойства панели"

L["Show XP Bar"] = "Показать панель опыта"
L["Show the XP Bar"]  = "Показать панель опыта"
L["Show Rep Bar"] = "Показать панель репутации"
L["Show the Reputation Bar"] = "Показать панель репутации"
L["Spark intensity"] = "Яркость искры"
L["Brightness level of Spark"] = "Уровень яркости искры"
L["Thickness"] = "Толщина"
L["Set thickness of the Bars"] = "Установка толщины панели"
L["Shadow"] = "Тень"
L["Toggle Shadow"] = "Вкл/выкл тень"

L["Frame"] = "Фрейм"
L["Frame Connection Properties"] = "Свойства фрейма подключения"

L["Frame to attach to"] = "Привязка фрейма к"
L["The exact name of the frame to attach to"] = "Точное название фрейма для привязки к"
L["Select by Mouse"] = "Выбор мышкой"
L["Click to activate the frame selector (Left-Click to select frame, Right-Click do deactivate selector)"] = "Нажмите, чтобы активировать выбор фрейма (Левый-клик - выбрать фрейм, Правый-клик - отменить выбор)"
L["This frame has no global name and cannot be used"] = "Этот фрейм не имеет глобального названия и не может быть использован"
L["Attach to side"] = "Привязать к стороне"
L["Select side to attach the bars to"] = "Выберите сторону привязки панели к"
L["X-Offset"] = "Смещение по X"
L["Set x-Offset of the bars"] = "Смещение панелей по X"
L["Y-Offset"] = "Смещение по Y"
L["Set y-Offset of the bars"] = "Смещение панелей по Y"
L["Strata"] = "Слои"
L["Select the strata of the bars"] = "Выберите слой панелей"
L["Inside"] = "Внутри"
L["Attach bars to the inside of the frame"] = "Привязать панели внутри фрейма"
L["Inverse Order"] = "Инверсия порядка"
L["Place reputation bar before XP bar"] = "Размещает панель репутации перед панелью опыта"
L["Jostle"] = "Теснить"
L["Jostle Blizzard Frames"] = "Теснить фреймы Blizzard"
L["Refresh"] = "Обновить"
L["Refresh Bar Position"] = "Обновить расположение панели"

L["Colors"] = "Окраска"
L["Set the Bar Colors"] = "настройка окраски панелей"

L["Current XP"] = "Текущий опыт"
L["Set the color of the XP Bar"] = "Установка цвета для панели опыта"
L["Rested XP"] = "Опыт с отдыха"
L["Set the color of the Rested Bar"] = "Установка цвета для панели опыта в состоянии бодрости"
L["No XP"] = "Без опыта"
L["Set the empty color of the XP Bar"] = "Установка цвета для пустоты панели опыта"
L["Reputation"] = "Репутация"
L["Set the color of the Rep Bar"] = "Установка цвета для панели репутации"
L["No Rep"] = "Без репутации"
L["Set the empty color of the Reputation Bar"] = "Установка цвета для пустоты панели репутации"
L["Blizzard Rep Colors"] = " Blizzard цвета репутации"
L["Toggle Blizzard Reputation Colors"] = "Переключение окраски репутации Blizzard"

L["Broker Label"] = "Ярлык Broker"
L["Broker Label Properties"] = "Свойства ярлыка Broker"

L["Select Label Text"] = "Выберите текст ярлыка"
L["Select label text for Broker display"] = [[Выберите текст ярлыка для отображения на панели:
|cffffff00Нету|r - Отображение заглавия модификации.
|cffffff00Убийств до уровня|r - Показывать сколько примерно нужно убийств для получения следующего уровня.
|cffffff00Времени до уровня|r - Показывать сколько примерно времени потребуется для получения следующего уровня.
|cffffff00Репутация|r - Показывать название фракции отслеживаемой репутации, количество заслуженной репутации, и процент.
|cffffff00Опыт|r - Показывать опыт и его процент.
|cffffff00Репутация выше опыта|r - Показывать по умолчанию репутацию, но если нет отслеживаемой фракции, показать опыт.
|cffffff00Опыт выше репутации|r - Показывать по умолчанию опыт, когда вы ниже максимального уровня, репутацию когда вы максимального уровеня.]]

L["XP/Rep to go"] = "Необходимо опыта/репутации"
L["Show XP/Rep to go in label"] = "Показать необходимое количество опыты/репутации в ярлыке"
L["Percentage only"] = "Только процентное значение"
L["Show percentage only"] = "Отображать только процентное значение"
L["Show faction name"] = "Название фракции"
L["Show faction name when reputation is selected as label text."] = "Отображение названия фракции, когда репутация выбрана как текст ярлыка."

L["Leveling"] = "Продвижение по уровням"
L["Leveling Properties"] = "Свойства продвижения по уровням"

L["Time Frame"] = "Фрейм времени"
L["Time frame for dynamic TTL calculation."] = "Фрейм времени для динамического расчета времени до следующего уровня (ВДСУ)."
L["Weight"] = "Значимость"
L["Weight time frame vs. session average for dynamic TTL calculation."] = "Значимость фрейма времени против среднего времени сессии для динамического расчета времени до следующего уровня (ВДСУ)."

L["Max. XP/Rep"] = "Макс опыта/репутации"
L["Display settings at maximum level/reputation"] = "Настройки отображения на макс уровне/репутацие"

L["No XP label"] = "Нет ярлыка опыта"
L["Don't show XP label text at maximum level. Affects XP, TTL and KTL option only."] = "Не показывать текст ярлыка при максимальном уровне персонажа. Влияет только на опыт, ВДСУ и УДУ."
L["No XP bar"] = "Нет панели опыта"
L["Don't show XP bar at maximum level."] = "Не показывать панель опыта при максимальном уровне персонажа."
L["No Rep label"] = "Нет ярлыка репутации"
L["Don't show label text at maximum Reputation. Affects Rep option only."] = "Не показывать текст ярлыка при максимальном уровне репутации. Влияет только на репутацию."
L["No Rep bar"] = "Нет панели репутации"
L["Don't show Rep bar at maximum Reputation."] = "Не показывать панель репутации при максимальном уровне репутации."

L["Faction"] = "Фракция"
L["Select Faction"] = "Выберите фракцию"
L["Blizzard Bars"] = "Панели Blizzard"
L["Show default Blizzard Bars"] = "Показать стандартные панели Blizzard"
L["Minimap Button"] = "Кнопка у мини-карты"
L["Show Minimap Button"] = "Показать кнопку у мини-карты"
L["Hide Hint"] = "Скрыть советы"
L["Hide usage hint in tooltip"] = "Скрыть советы по использованию в подсказках"

L["Max Level"] = "Макс. уровень"
L["No watched faction"] = "Нет отслеживаемой фракции"
				
L["%s: %3.0f%% (%s/%s) %s left"] = "%s: %3.0f%% (%s/%s) %s осталось"

L["Current XP"] = "Текущий опыт"
L["To Level"] = "До уровня"
L["Rested XP"] = "Бодрости"

L["Rep to next standing"] = "Репутации до след. ранга"
L["Current rep"] = "Текущая репутация"

L["Session XP"] = "Опыт за сессию"
L["XP per hour"] = "Опыта за час"
L["Kills per hour"] = "Убийств за час"
L["Time to level"] = "Времени до уровня"
L["Kills to level"] = "Убийств до уровня"

L["Click"] = "Клик"
L["Shift-Click"] = "Shift-Клик"
L["Right-Click"] = "Правый-Клик"
L["Send current XP to an open editbox."] = "Отправить текущий опыт в поле ввода чата."
L["Send current reputation to an open editbox."] = "Отправить текущую репутации в поле ввода чата."
L["Open option menu."] = "Открыть меню настроек."

L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"] = "%s/%s (%3.0f%%) %d необходимо (%3.0f%% бодрости)"
L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"] = "%s: %s/%s (%3.2f%%) Сейчас %s с %d необходимо"

L["Usage:"] = "Использование:"
L["/brokerxpbar arg"] = "/brokerxpbar arg"
L["/bxb arg"] = "/bxb arg"
L["Args:"] = "Арг:"
L["version - display version information"] = "version - информация о версии"
L["menu - display options menu"] = "menu - меню настроек"
L["help - display this help"] = "help - справка"

L["Maximum level reached."] = "Достигнут максимальный уровень."
L["Currently no faction tracked."] = "В текущий момент нет отслеживаемой фракции."
L["Version"] = "Версия"

L["Top"] = "Верху" 
L["Bottom"] = "Внизу"
L["Left"] = "Слева" 
L["Right"] = "Справа" 

L["XP"] = "Опыт"
L["Rep"] = "Репутация"
L["None"] = "Нету"
L["Kills to Level"] = "Убийств до уровня"
L["Time to Level"] = "Времени до уровня"
L["XP over Rep"] = "Репутация выше опыта"
L["Rep over XP"] = "Опыт выше репутации"
