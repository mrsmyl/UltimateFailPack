-- TradeSkillMaster_Mailing Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "ruRU")
if not L then return end

L["Add Mail Target"] = "Добавить получателя"
-- L["After the initial mailing, the auto-mail feature will automatically restart after however many minutes this slider is set to."] = ""
-- L["Are you sure you want to remove %s as a mail target?"] = ""
L["Auto mailing will let you setup groups and specific items that should be mailed to another characters."] = "Auto mailing позволяет определить список вещей для отправки другим персонажам."
-- L["AutoMail Restart Delay (minutes)"] = ""
-- L["AutoMail Send Delay"] = ""
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = "Автоматически проверяет почтовый ящик каждые 60 секунд, если у вас больше 50 писем. Если включить эту опцию, то при нажатии на кнопку \"Получить всё\" модуль заберет все письма из почтового ящика, обновит его и продолжит получение писем."
-- L["Automatically Restart AutoMail"] = ""
L["Auto Recheck Mail"] = "Авто проверка почты"
-- L["Below you can change an existing mail target to a new one without losing the items."] = ""
L["Cannot finish auto looting, inventory is full or too many unique items."] = "Невозможно завершить получение почты. Ваши сумки заполнены, или у вас слишком много уникальных предметов."
-- L["Change Mail Target"] = ""
L["Checking this will stop TradesSkillMaster_Mailing from displaying money collected from your mailbox after auto looting"] = "Отметьте этот пункт, чтобы не показывать количество полученного из писем золота."
L["Check your spelling! If you typo a name, it will send to the wrong person."] = "Проверьте, правильно ли введено имя получателя. Письма могут быть отосланы неверному персонажу."
L["%d mail"] = "%d почта"
L["Don't Display Money Received"] = "Не показывать количество полученного золота."
L["How many seconds until the mailbox will retrieve new data and you can continue looting mail."] = "Сколько времени пройдет, прежде чем почтовый ящик обновится и получение почты продолжится."
-- L["If checked, after the initial mailing, the auto-mail feature will automatically restart after a certain period of time. This is useful if you're crafting a lot of items and want auto-mail to automatically mail items off while you craft."] = ""
L["Items/Groups to Add:"] = "Какие предметы/группы добавить:"
L["Items/Groups to remove:"] = "Какие предметы/группы удалить:"
L["Mailed items off to %s!"] = "Предметы отправлены %s!"
L["Mailing Options"] = "Настройки отправки почты"
-- L["New Player Name"] = ""
L["No player name entered."] = "Не введено имя персонажа."
-- L["Nothing to mail!"] = ""
-- L["Old Player Name"] = ""
L["Open All"] = "Получить всё"
L["Opening..."] = "Получение..."
L["Options"] = "Настройки"
L["Player Name"] = "Имя персонажа"
L["Player \"%s\" is already a mail target."] = "Персонаж \"%s\" уже добавлен как получатель."
-- L["Please wait until you are done opening mail before sending mail."] = ""
L["Remove Mail Target"] = "Удалить получателя"
-- L["Restarting AutoMail in %s minutes."] = ""
L[ [=[Runs TradeSkillMaster_Mailing's auto mailer, the last patch of mails will take ~10 seconds to send.

[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name.]=] ] = [=[Запускает авто отправку модуля TSM_Mailing, каждая пачка писем будет оправлена примерно за 10 секунд.

[Внимание!] Никакого подтверждения перед отправкой писем вы не получите. Не ошибитесь в написании имени получателя.]=]
-- L["%s Collected"] = ""
-- L["Send Items Individually"] = ""
-- L["Sends each unique item in a seperate mail."] = ""
L[ [=[The name of the player to send items to.

Check your spelling!]=] ] = [=[Имя получателя.

Проверьте, правильно ли оно введено!]=]
-- L["This slider controls how long the AutoMailing code waits in between mails. If this is set too low, you will run into internal mailbox errors."] = ""
L["TradeSkillMaster_Mailing: Auto-Mail"] = "TradeSkillMaster_Mailing: Авто отправка"
--[==[ L[ [=[TradeSkillMaster_Mailing - Sending...

(the last mail may take several moments)]=] ] = "" ]==]
L["Waiting..."] = "Ожидание..."
