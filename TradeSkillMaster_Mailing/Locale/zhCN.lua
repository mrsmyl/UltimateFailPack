-- TradeSkillMaster_Mailing Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "zhCH")
if not L then return end

L["Add Mail Target"] = "添加收件人"
-- L["After the initial mailing, the auto-mail feature will automatically restart after however many minutes this slider is set to."] = ""
L["Are you sure you want to remove %s as a mail target?"] = "你是否确定想要移除邮件目标 %s ?" -- Needs review
L["Auto mailing will let you setup groups and specific items that should be mailed to another characters."] = "自动邮寄会将你设定的分组和具体物品邮寄到另一个角色."
L["AutoMail Restart Delay (minutes)"] = "自动邮件重启延迟 (秒)" -- Needs review
L["AutoMail Send Delay"] = "自动邮件发送延迟" -- Needs review
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[当你有过多邮件时,将每60秒复查邮件.

当开启此项时你正在拾取全部邮件,插件将等待并复查邮件但保持自动拾取。]=]
L["Automatically Restart AutoMail"] = "自动重启自动邮件" -- Needs review
L["Auto Recheck Mail"] = "自动复查邮件"
-- L["Below you can change an existing mail target to a new one without losing the items."] = ""
L["Cannot finish auto looting, inventory is full or too many unique items."] = "无法完成自动拾取邮件,背包已满或者拥有过多唯一物品."
L["Change Mail Target"] = "修改邮件目标" -- Needs review
L["Checking this will stop TradesSkillMaster_Mailing from displaying money collected from your mailbox after auto looting"] = "不显示在自动打开邮件后从邮件中获取金钱的提示."
L["Check your spelling! If you typo a name, it will send to the wrong person."] = "检查你的输入!如果你输入一个错误的名字,邮件将发给一个错误的收件人."
L["%d mail"] = "%d 邮件"
L["Don't Display Money Received"] = "不显示收到的金钱."
L["How many seconds until the mailbox will retrieve new data and you can continue looting mail."] = "直到信箱检索新的数据若干秒后，你可以继续拾取邮件."
-- L["If checked, after the initial mailing, the auto-mail feature will automatically restart after a certain period of time. This is useful if you're crafting a lot of items and want auto-mail to automatically mail items off while you craft."] = ""
L["Items/Groups to Add:"] = "添加物品/分组:"
L["Items/Groups to remove:"] = "移除物品/分组:"
L["Mailed items off to %s!"] = "物品发送到 %s!"
L["Mailing Options"] = "邮寄选项"
L["New Player Name"] = "新的玩家名字" -- Needs review
L["No player name entered."] = "未输入玩家名."
-- L["Nothing to mail!"] = ""
-- L["Old Player Name"] = ""
L["Open All"] = "打开所有"
L["Opening..."] = "打开中..."
L["Options"] = "选项"
L["Player Name"] = "玩家名"
L["Player \"%s\" is already a mail target."] = "玩家\"%s\"已经是收件人."
-- L["Please wait until you are done opening mail before sending mail."] = ""
L["Remove Mail Target"] = "移除收件人"
-- L["Restarting AutoMail in %s minutes."] = ""
L[ [=[Runs TradeSkillMaster_Mailing's auto mailer, the last patch of mails will take ~10 seconds to send.

[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name.]=] ] = [=[使用TradeSkillMaster_Mailing自动邮寄功能, 只要10秒,邮件轻松发送.

[警告!] 在开始发送邮件前你不会得到任何确认信息.如果您错误输入收件人,一切后果自负.]=]
L["%s Collected"] = "%s 已收集" -- Needs review
-- L["Send Items Individually"] = ""
-- L["Sends each unique item in a seperate mail."] = ""
L[ [=[The name of the player to send items to.

Check your spelling!]=] ] = [=[发送物品的收件人名字.

请确认收件人输入无误!]=]
-- L["This slider controls how long the AutoMailing code waits in between mails. If this is set too low, you will run into internal mailbox errors."] = ""
L["TradeSkillMaster_Mailing: Auto-Mail"] = "TradeSkillMaster_Mailing: 自动邮寄"
--[==[ L[ [=[TradeSkillMaster_Mailing - Sending...

(the last mail may take several moments)]=] ] = "" ]==]
L["Waiting..."] = "等待..."
