-- TradeSkillMaster_Auctioning Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Auctioning/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Auctioning", "zhCH")
if not L then return end

-- L[""] = ""
L["12 hours"] = "12小时" -- Needs review
L["24 hours"] = "24小时" -- Needs review
L["48 hours"] = "48小时" -- Needs review
L["A category contains groups with similar settings and acts like an organizational folder. You may override default settings by category (and then override category settings by group)."] = "分类像文件夹一样包含具有相似条件的分组。你可以在分类中覆盖默认设置(然后在分组设置中覆盖分类设置)。" -- Needs review
L["Add a new player to your blacklist."] = "添加一个玩家到黑名单" -- Needs review
L["Add a new player to your whitelist."] = "添加一个新玩家进白名单" -- Needs review
L["Add category"] = "新建分类" -- Needs review
-- L["Added %s items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = ""
-- L["Added the following items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = ""
L["Add group"] = "新建分组" -- Needs review
-- L["Add Item to New Group"] = ""
-- L["Add Item to Selected Group"] = ""
-- L["Add Item to TSM_Auctioning"] = ""
L["Add player"] = "添加玩家" -- Needs review
L["Add/Remove"] = "添加/移除" -- Needs review
L["Add/Remove Groups"] = "添加/删除分组" -- Needs review
L["Add/Remove Items"] = "添加/移除 物品" -- Needs review
L["Advanced"] = "高级模式" -- Needs review
-- L["Advanced Price Settings (Reset Method)"] = ""
L["A group contains items that you wish to sell with similar conditions (stack size, fallback price, etc).  Default settings may be overridden by a group's individual settings."] = "分组包含具有相同拍卖条件(堆叠、回跌价等)的物品。你可以在分组设置中覆盖默认设置。"
-- L["All auctions of this duration and below will be canceled when you press the \"Cancel Low Duration Auctions\" button"] = ""
L["ALT"] = "ALT"
L["Any auctions at or below the selected duration will be ignored. Selecting \"<none>\" will cause no auctions to be ignored based on duration."] = "处于或低于所选择持续时间内的拍卖品将会被忽略。选择\\\"<空>\\\"将不会使用拍卖品基于其持续时间而被忽略。" -- Needs review
-- L["Are you SURE you want to delete all the groups in this category?"] = ""
L["Are you sure you want to delete the selected profile?"] = "你确定要删除选定的配置文件吗?" -- Needs review
L["Are you SURE you want to delete this category?"] = "你确定要删除这个分类吗?" -- Needs review
L["Are you SURE you want to delete this group?"] = "你确定要删除这个分组吗?" -- Needs review
-- L["At fallback price and not undercut."] = ""
-- L["Auction Buyout"] = ""
-- L["Auction Buyout (Stack Price):"] = ""
L["Auction Defaults"] = "拍卖行默认" -- Needs review
-- L["Auction has been bid on."] = ""
L["Auctioning Group:"] = "拍卖组：" -- Needs review
L["Auctioning Groups/Options"] = "拍卖分组/选项" -- Needs review
-- L["Auctioning has found %s group(s) with an invalid threshold/fallback. Check your chat log for more info. Would you like Auctioning to fix these groups for you?"] = ""
L["Auctioning will follow the 'Advanced Price Settings' when the market goes below %s."] = "当市场价格低于 %s 时拍卖将会遵照 '高级价格设置'" -- Needs review
L["Auctioning will never post your auctions for below %s."] = "Auctioning 不发布低于%s的货物" -- Needs review
L["Auctioning will post at %s when you are the only one posting below %s."] = "当没有竞争者时低于 %s 发布时拍卖将会以 %s 发布" -- Needs review
-- L["Auctioning will reset items where you can make a profit of at least %s per item by buying at most %s items for a maximum of %s, paying no more than %s for any single item."] = ""
L["Auctioning will undercut your competition by %s. When posting, the bid of your auctions will be set to %s percent of the buyout."] = "拍卖将压价 %s 发布.发布时,竞标价将设为一口价的百分之 %s." -- Needs review
-- L["Auctions"] = ""
L["Auctions will be posted at %s when the market goes below your threshold."] = "当市场底价低于你的最低门槛价时,拍卖将以 %s 发布." -- Needs review
L["Auctions will be posted at your fallback price of %s when the market goes below your threshold."] = "当市场底价低于你的最低门槛价时,拍卖将会以你的回跌价 %s 发布." -- Needs review
L["Auctions will be posted at your threshold price of %s when the market goes below your threshold."] = "当市场底价低于你的最低门槛价时,拍卖将会以你的最低门槛价 %s 发布." -- Needs review
L["Auctions will be posted for %s hours in stacks of %s. A maximum of %s auctions will be posted."] = "按 %s 小时拍卖时间,每堆叠 %s 发布商品.最高发布数量为 %s ." -- Needs review
L["Auctions will be posted for %s hours in stacks of up to %s. A maximum of %s auctions will be posted."] = "按 %s 小时拍卖时间,每堆叠最高 %s 发布商品.最高发布数量为 %s ." -- Needs review
L["Auctions will not be posted when the market goes below your threshold."] = "当市场底价低于你的最低门槛价时,拍卖将不会发布" -- Needs review
L["Beginner"] = "初级模式" -- Needs review
-- L["Bid:"] = ""
L["Bid percent"] = "竞价百分比" -- Needs review
L["Blacklist"] = "黑名单" -- Needs review
-- L["(blacklisted)"] = ""
L["Blacklists allows you to undercut a competitor no matter how low their threshold may be. If the lowest auction of an item is owned by somebody on your blacklist, your threshold will be ignored for that item and you will undercut them regardless of whether they are above or below your threshold."] = "黑名单允许你忽略你设置的门槛价, 不顾一切压低在你黑名单上玩家所上架的任何物品。" -- Needs review
L["Block Auctioneer while scanning"] = "在扫描时屏蔽 Auctioneer" -- Needs review
-- L["Buyout"] = ""
-- L["Buyout:"] = ""
L["Cancel"] = "取消" -- Needs review
-- L["Cancel ALL Current Auctions"] = ""
-- L["Cancel Auctions"] = ""
-- L["Cancel Auctions Matching Filter"] = ""
L["Cancel auctions with bids"] = "取消只使用竞标价发布的拍卖." -- Needs review
-- L["Cancel Filter"] = ""
L["Canceling"] = "取消中" -- Needs review
-- L["Canceling all auctions."] = ""
-- L["Canceling auction which you've undercut."] = ""
-- L["Canceling %s / %s"] = ""
-- L["Canceling to repost at higher price."] = ""
-- L["Canceling to repost at reset price."] = ""
-- L["Cancel Low Duration Auctions"] = ""
-- L["Cancels auctions you've been undercut on according to the rules setup in Auctioning."] = ""
-- L["Cancel Scan Finished"] = ""
-- L["Cancel to repost higher"] = ""
L["Categories / Groups"] = "分类/分组" -- Needs review
L["Category name"] = "分类名" -- Needs review
L["Category Overrides"] = "覆盖分类" -- Needs review
-- L["Cheapest auction below threshold."] = ""
-- L["Check this box to include this group in the scan."] = ""
-- L["Click on the \"Fix\" button to have Auctioning turn this group into a category and create appropriate groups inside the category to fix this issue. This is recommended unless you'd like to fix the group yourself. You will only be prompted with this popup once per session."] = ""
-- L["Click to reset this item to this target price."] = ""
-- L["Click to show auctions for this item."] = ""
-- L["Common Search Term"] = ""
L["Completely disables this group. This group will not be scanned for and will be effectively invisible to Auctioning."] = "完全禁用该组. 该组将不会被扫描到, 相当于在Auctioning中隐形。" -- Needs review
L["Copy From"] = "复制于" -- Needs review
L["Copy the settings from one existing profile into the currently active profile."] = "从已有的配置文件复制到当前配置文件." -- Needs review
-- L["Could not find item's group."] = ""
L["Create a new empty profile."] = "新建新配置文件" -- Needs review
L["Create Category / Group"] = "新建分类/分组" -- Needs review
L["Create Macro and Bind ScrollWheel (with selected options)"] = "创建宏和绑定鼠标滚轮(配合选定的选项)" -- Needs review
-- L["CTRL"] = ""
L["Current Profile:"] = "当前配置文件" -- Needs review
L["Custom market reset price. If the market goes below your threshold, items will be posted at this price."] = "自定义门槛价,如果市场价低于你的门槛价,货物将以这个价格发布." -- Needs review
L["Custom Reset Price (gold)"] = "自定义门槛价格(金)" -- Needs review
L["Custom Value"] = "自定义价" -- Needs review
L["Data Imported to Group: %s"] = "导入数据到分组: %s" -- Needs review
L["Default"] = "默认" -- Needs review
L["Delete"] = "删除" -- Needs review
-- L["Delete All Groups In Category"] = ""
-- L["Delete all groups inside this category. This cannot be undone!"] = ""
L["Delete a Profile"] = "删除一个配置文件" -- Needs review
-- L["Delete category"] = ""
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "从数据库中删除现有未使用的配置文件并清理SavedVariables以节省空间." -- Needs review
L["Delete group"] = "删除分组" -- Needs review
L["Delete this category, this cannot be undone!"] = "删除分类,该操作无法撤销!" -- Needs review
L["Delete this group, this cannot be undone!"] = "删除分组,该操作无法撤销!" -- Needs review
L["Determines which order the group / category settings tabs will appear in."] = "设置分类/分组选项页面的标签显示顺序" -- Needs review
L["Did not post %s because your fallback (%s) is invalid. Check your settings."] = "无法发布 %s 因为你的回跌价(%s)无效.检查你的设置." -- Needs review
L["Did not post %s because your fallback (%s) is lower than your threshold (%s). Check your settings."] = "无法发布 %s 因为你的回跌价(%s)低于门槛价(%s).检查你的设置." -- Needs review
L["Did not post %s because your threshold (%s) is invalid. Check your settings."] = "无法发布 %s 因为你的门槛价(%s)无效.检查你的设置." -- Needs review
-- L["Disable All"] = ""
L["Disable auto cancelling"] = "关闭自动取消" -- Needs review
L["Disable automatically cancelling of items in this group if undercut."] = "禁止该分组物品的被压价自动取消功能." -- Needs review
L["Disable posting and canceling"] = "禁用发布和取消" -- Needs review
-- L["Disables canceling of auctions which can not be reposted (ie the market price is below your threshold)."] = ""
L["Done Canceling"] = "取消完成" -- Needs review
--[==[ L[ [=[Done Posting

Total value of your auctions: %s
Incoming Gold: %s]=] ] = "" ]==]
--[==[ L[ [=[Done Scanning!

Could potentially reset %d items for %s profit.]=] ] = "" ]==]
L["Don't Import Already Grouped Items"] = "不导入已分组物品" -- Needs review
L["Don't Post Items"] = "不发布物品" -- Needs review
L["Down"] = "降低" -- Needs review
-- L["Duration"] = ""
-- L["Edit Post Price"] = ""
-- L["Enable All"] = ""
L["Enable sounds"] = "开启声音" -- Needs review
-- L["Enter a filter into this box and click the button below it to cancel all of your auctions that contain that filter (without scanning)."] = ""
-- L["Error with scan. Scanned item multiple times unexpectedly. You can try restarting the scan. Item:"] = ""
L["Existing Profiles"] = "当前配置文件" -- Needs review
L["Export"] = "导出" -- Needs review
L["Export Group Data"] = "导出分组数据" -- Needs review
L["Exports the data for this group. This allows you to share your group data with other TradeSkillMaster_Auctioning users."] = "导出这些分组的数据.你可以将你的分组数据分享给其他TradeSkillMaster_Auctioning用户." -- Needs review
-- L["Fallback:"] = ""
L["Fallback price"] = "回跌价" -- Needs review
-- L["First Tab in Group / Category Settings"] = ""
L["Fixed Gold Amount"] = "固定金额" -- Needs review
-- L["Fixed invalid groups."] = ""
-- L["Fix (Recommended)"] = ""
L["General"] = "常规" -- Needs review
L["General Price Settings (Undercut / Bid)"] = "一般价设定(底价/竞标价)" -- Needs review
L["General Settings"] = "常规设定" -- Needs review
-- L["Group:"] = ""
L["Group/Category named \"%s\" already exists!"] = "\"%s\"分组/分类已存在!" -- Needs review
L["Group Data"] = "分组数据" -- Needs review
L["Group name"] = "分组名" -- Needs review
L["Group named \"%s\" already exists! Item not added."] = "\"%s\"分组已存在!物品未添加." -- Needs review
L["Group named \"%s\" does not exist! Item not added."] = "\"%s\"分组不存在!物品未添加." -- Needs review
L["Group Overrides"] = "分组设置" -- Needs review
L["Groups in this Category:"] = "这个分类中的分组" -- Needs review
L["Help"] = "帮助" -- Needs review
L["Hide advanced options"] = "隐藏高级选项" -- Needs review
L["Hide help text"] = "隐藏帮助文字" -- Needs review
L["Hide poor quality items"] = "隐藏灰色品质物品" -- Needs review
L["Hides advanced auction settings. Provides for an easier learning curve for new users."] = "隐藏高级拍卖设定.让新手能更好的循序渐进." -- Needs review
L["Hides all poor (gray) quality items from the 'Add items' pages."] = "隐藏\"添加物品\"页面中的所有灰色品质物品." -- Needs review
L["Hides auction setting help text throughout the options."] = "隐藏所有的选项的帮组文字." -- Needs review
L["How long auctions should be up for."] = "拍卖时长为" -- Needs review
L["How low the market can go before an item should no longer be posted. The minimum price you want to post an item for."] = "当市场价为多少时不在发布该物品的拍卖.即你所能接受的要发布商品的最低价格." -- Needs review
L["How many auctions at the lowest price tier can be up at any one time."] = "同一时间可以有多少笔最低价级别的拍卖." -- Needs review
L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."] = "一次拍卖发布多少个物品,20意味着物品将以20个为堆叠发布." -- Needs review
L[ [=[How much of a difference between auction prices should be allowed before posting at the second highest value.

For example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold.]=] ] = [=[当你的所发布的物品是第二高价格时,所允许的与最高价间的差价.

例如. 如果小苹以50G将符文赤玉石摆到拍卖行, 小桔30g摆的而你以29g也摆了一个, 过了一会小桔的过期了. 如果你设置的价格门槛是30%插件会取消你29G摆上去的符文赤玉石然后重新以49g丢到拍卖行里, 因为差价达到了42%超过了允许的阀值.]=] -- Needs review
L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."] = "压价幅度是多少,格式以\"#g#s#c\",可以已任何顺序输入,\"50g30s\"代表50金30银,以此类推." -- Needs review
-- L["If all items in this group have the same phrase in their name, use this phrase instead to speed up searches. For example, if this group contains only glyphs, you could put \"glyph of\" and Auctioning will search for that instead of each glyph name individually. Leave empty for default behavior."] = ""
-- L["If checked, the items in this group will be included when running a reset scan and the reset scan options will be shown."] = ""
-- L["If checked, will cancel auctions that can be reposted for a higher amount (ie you haven't been undercut and the auction you originally undercut has expired)."] = ""
-- L["If enabled, when the lowest auction is by somebody on your whitelist, it will post your auction at the same price. If disabled, it won't post the item at all."] = ""
-- L["If enabled, when you create a new group, your bags will be scanned for items with names that include the name of the new group. If such items are found, they will be automatically added to the new group."] = ""
--[==[ L[ [=[If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.

Effective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g.]=] ] = "" ]==]
-- L["If you are using a % of something for threshold / fallback, every item in a group must evalute to the exact same amount. For example, if you are using % of crafting cost, every item in the group must have the same mats. If you are using % of auctiondb value, no items will ever have the same market price or min buyout. So, these items must be split into separate groups."] = ""
L["If you don't have enough items for a full post, it will post with what you have."] = "如果你拥有商品不足一组,那么将以你拥有数量发布." -- Needs review
-- L["Ignore"] = ""
L["Ignore low duration auctions"] = "忽略低时间的拍卖" -- Needs review
L["Ignore stacks over"] = "忽略超过堆叠" -- Needs review
L["Ignore stacks under"] = "忽略低于堆叠" -- Needs review
L["Import Auctioning Group"] = "导入拍卖分组" -- Needs review
L["Import Group Data"] = "导入分组数据" -- Needs review
-- L["Include in reset scan"] = ""
-- L["Info"] = ""
L["Invalid category name."] = "无效的分类名称." -- Needs review
L["Invalid group name."] = "无效的分组名称." -- Needs review
-- L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = ""
L["Invalid percent format entered, should be \"#%\", \"105%\" is 105 percent."] = "无效的百分比格式,必须是\"#%\",比如\"105%\"是百分之105." -- Needs review
-- L["Invalid scan data for item %s. Skipping this item."] = ""
-- L["Invalid search term for group %s. Searching for items individually instead."] = ""
-- L["Invalid seller data returned by server."] = ""
-- L["Item"] = ""
L["Item failed to add to group."] = "物品添加到分组失败." -- Needs review
-- L["Item/Group is invalid."] = ""
L["Items in this group:"] = "该分组内物品:" -- Needs review
L["Items in this group will not be posted or canceled automatically."] = "这个分组的商品不会被自动发布或取消." -- Needs review
L["Items not in any group:"] = "未分组物品:" -- Needs review
-- L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = ""
-- L["Log Info:"] = ""
-- L["Long (12 hours)"] = ""
L["long (2 - 12 hours)"] = "长(2-12小时)" -- Needs review
-- L["Lowest auction by whitelisted player."] = ""
-- L["Lowest Buyout"] = ""
-- L["Lowest Buyout:"] = ""
L["Macro created and keybinding set!"] = "宏的创建和绑定按键设置!" -- Needs review
L["Macro Help"] = "宏命令帮助" -- Needs review
-- L["Make another after this one."] = ""
L["Management"] = "管理" -- Needs review
-- L["% Market Value"] = ""
-- L["Match whitelist prices"] = ""
-- L["Maximum amount already posted."] = ""
L["Maximum price"] = "最高价格" -- Needs review
L["Maximum price gap"] = "最高价格差" -- Needs review
L["Maximum Price Settings (Fallback)"] = "最高价格设定(回跌价)" -- Needs review
-- L["Max price per item"] = ""
-- L["Max quantity to buy"] = ""
-- L["Max reset cost"] = ""
-- L["Max Scan Retries (Advanced)"] = ""
-- L["Medium (2 hours)"] = ""
L["medium (30 minutes - 2 hours)"] = "中(30分钟-2小时)" -- Needs review
L["Minimum Price Settings (Threshold)"] = "最低价格(门槛价)" -- Needs review
-- L["Min reset profit"] = ""
L["Modifiers:"] = "功能键:" -- Needs review
-- L["Must wait for scan to finish before starting to reset."] = ""
-- L["Name of New Group to Add Item to:"] = ""
L["Name of the new category, this can be whatever you want and has no relation to how the category itself functions."] = "新分类名称,分类名称与分类自身功能无关." -- Needs review
L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."] = "新分组名称,分组名称与分组自身功能无关." -- Needs review
L["New"] = "新建配置文件" -- Needs review
L["New category name"] = "新分类名称" -- Needs review
L["New group name"] = "新分组名称" -- Needs review
-- L["No Items to Reset"] = ""
L["No name entered."] = "没有输入名称." -- Needs review
-- L["<none>"] = ""
-- L["Not canceling auction at reset price."] = ""
-- L["Not canceling auction below threshold."] = ""
-- L["Not enough items in bags."] = ""
-- L["%% of %s"] = ""
L["Options"] = "选项" -- Needs review
L["Overrides"] = "分组设置" -- Needs review
L["Per auction"] = "每笔拍卖" -- Needs review
L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."] = "一口价与竞标价的百分比.如果你设置为90%,那么100金的一口价的商品将有90g的竞标价." -- Needs review
L["Player name"] = "玩家名称" -- Needs review
-- L["Plays the ready check sound when a post / cancel scan is complete and items are ready to be posting / canceled (the gray bar is all the way across)."] = ""
-- L["Please don't move items around in your bags while a post scan is running! The item was skipped to avoid an incorrect item being posted."] = ""
-- L["Post"] = ""
L["Post at Fallback"] = "在回跌价发布" -- Needs review
L["Post at Threshold"] = "在门槛价发布" -- Needs review
-- L["Post Auctions"] = ""
L["Post cap"] = "发布数量" -- Needs review
-- L["Posting at fallback."] = ""
-- L["Posting at reset price."] = ""
-- L["Posting at whitelisted player's price."] = ""
-- L["Posting at your current price."] = ""
-- L["Posting %s / %s"] = ""
-- L["Posting this item."] = ""
-- L["Post Scan Finished"] = ""
L["Post Settings (Quantity / Duration)"] = "发布设定 (数量 / 时间)" -- Needs review
-- L["Posts items on the auction house according to the rules setup in Auctioning."] = ""
L["Post time"] = "发布时限" -- Needs review
-- L["Price gap too high."] = ""
-- L["Price Per Item"] = ""
-- L["Price Per Stack"] = ""
-- L["Price resolution"] = ""
L["Price threshold"] = "门槛价" -- Needs review
L["Price to fallback too if there are no other auctions up, the lowest market price is too high."] = "你是该物品唯一卖家，或市场价过低，该物品将以回跌价拍卖。" -- Needs review
-- L["Processing Items..."] = ""
L["Profiles"] = "配置文件" -- Needs review
-- L["Profit:"] = ""
-- L["Profit Per Item"] = ""
-- L["Quantity (Yours)"] = ""
L["Rename"] = "重命名" -- Needs review
L["Rename this category to something else!"] = "重命名该分类!" -- Needs review
L["Rename this group to something else!"] = "重命名该分组!" -- Needs review
-- L["Reset Auctions"] = ""
-- L["Reset Method"] = ""
L["Reset Profile"] = "重置配置文件" -- Needs review
-- L["Reset Scan Finished"] = ""
-- L["Reset Scan Settings"] = ""
-- L["Resets the price of items according to the rules setup in Auctioning by buying other's auctions and canceling your own as necessary."] = ""
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = "如果你配置错误或者想重新开始配置,可以重置当前配置文件到默认值." -- Needs review
-- L["Return to Summary"] = ""
-- L["Right-Click to add %s to your friends list."] = ""
-- L["Right click to do a custom cancel scan."] = ""
-- L["Right click to do a custom post scan."] = ""
-- L["Right click to do a custom reset scan."] = ""
L["Right click to override this setting."] = "鼠标右击修改该设置" -- Needs review
L["Right click to remove the override of this setting."] = "鼠标右击取消修改并恢复到默认设置。" -- Needs review
-- L["Running Scan..."] = ""
-- L["Save New Price"] = ""
L["Scanning"] = "扫描中" -- Needs review
-- L["Scanning Item %s / %s"] = ""
L["ScrollWheel Direction (both recommended):"] = "滚轮方向 (建议都选):" -- Needs review
L["Select Matches:"] = "选择匹配:" -- Needs review
L["Selects all items in either list matching the entered filter. Entering \"Glyph of\" will select any item with \"Glyph of\" in the name."] = "选择所有匹配过滤器的物品.输入\"雕文\"将选择任何名字带\"雕文\"的物品." -- Needs review
L["Seller"] = "卖家" -- Needs review
-- L["Seller name of lowest auction for item %s was not returned from server. Skipping this item."] = ""
L["Set fallback as a"] = "设置回跌价" -- Needs review
-- L["Set max reset cost as a"] = ""
-- L["Set min reset price as a"] = ""
L["Set threshold as a"] = "设置门槛价" -- Needs review
-- L["SHIFT"] = ""
-- L["Shift-Right-Click to show the options for this item's Auctioning group."] = ""
-- L["Short (30 minutes)"] = ""
L["short (less than 30 minutes)"] = "短(少于30分钟)" -- Needs review
-- L["Show All Auctions"] = ""
L["Show group name in tooltip"] = "在提示信息上显示分组名称" -- Needs review
-- L["Show Item Auctions"] = ""
-- L["Show Log"] = ""
L["Shows the name of the group an item belongs to in that item's tooltip."] = "在物品的鼠标提示信息上显示该物品所属的分组名" -- Needs review
-- L["%s item(s) to buy/cancel"] = ""
-- L["Skip"] = ""
L["Skip Item"] = "跳过物品" -- Needs review
-- L["Smart canceling"] = ""
-- L["Smart group creation"] = ""
-- L["Stack Size"] = ""
-- L["Start Scan of Selected Groups"] = ""
-- L["Stop Scan"] = ""
-- L["Target Price"] = ""
-- L["Target Price:"] = ""
L[ [=[The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.

Warning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g.]=] ] = "以下是分组的通用设置，如果你不修改任何一个分组的配置文件，系统将默认下面的设置为各分组的配置。\\n\\n警告：所有拍卖物品的价格都是单价并非为一组或者所有物品的价格。例如你设置发布价为默认1金，发布堆叠为20个，那么发布价将默认为20金" -- Needs review
L["The data you are trying to import is invalid."] = "你试图导入的数据无效。" -- Needs review
-- L["The maximum amount that you want to spend in order to reset a particular item. This is the total amount, not a per-item amount."] = ""
-- L["The minimum profit you would want to make from doing a reset. This is a per-item price where profit is the price you reset to minus the average price you spent per item."] = ""
L["The player \"%s\" is already on your blacklist."] = "玩家 \\\"%s\\\" 已经在你的黑名单中" -- Needs review
L["The player \"%s\" is already on your whitelist."] = "玩家\"%s\"已经在你的白名单里." -- Needs review
-- L["There are two ways of making clicking the Post / Cancel Auction button easier. You can put %s and %s in a macro (on separate lines), or use the utility below to have a macro automatically made and bound to scrollwheel for you."] = ""
-- L["This controls how many times Auctioning will retry a query before giving up and moving on. Each retry takes about 2-3 seconds."] = ""
-- L["This determines what size range of prices should be considered a single price point for the reset scan. For example, if this is set to 1s, an auction at 20g50s20c and an auction at 20g49s45c will both be considered to be the same price level."] = ""
-- L["This dropdown determines what Auctioning will do when the market for an item goes below your threshold value. You can either not post the items or post at your fallback/threshold/a custom value."] = ""
L["This feature can be used to import groups from outside of the game. For example, if somebody exported their group onto a blog, you could use this feature to import that group and Auctioning would create a group with the same settings / items."] = "这个功能可以帮助你导入其他玩家/角色的分组和相应的设置" -- Needs review
-- L["This is the maximum amount you want to pay for a single item when reseting."] = ""
-- L["This is the maximum number of items you're willing to buy in order to perform a reset."] = ""
-- L["This item does not have any seller data."] = ""
-- L["This item is already in the \"%s\" Auctioning group."] = ""
-- L["This item will not be included in the reset scan."] = ""
-- L["Threshold:"] = ""
-- L["Time Left"] = ""
-- L["Toggle this box to enable / disable all groups in this category."] = ""
-- L["Total Cost"] = ""
-- L["TSM_Auctioning Group to Add Item to:"] = ""
L["<Uncategorized Groups>"] = "<未归类分组>" -- Needs review
L["Uncategorized Groups:"] = "未分类的分组" -- Needs review
L["Undercut by"] = "被压价" -- Needs review
-- L["Undercut by whitelisted player."] = ""
-- L["Undercutting competition."] = ""
-- L["Up"] = ""
-- L["Use per auction as cap"] = ""
-- L["Use the checkboxes to the left to select which groups you'd like to include in this scan."] = ""
-- L["When posting and canceling, ignore auctions with more than %s item(s) or less than %s item(s) in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s."] = ""
-- L["When posting, ignore auctions with more than %s items or less than %s items in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s. Items in this group will not be canceled automatically."] = ""
-- L["Which group in TSM_Auctioning to add this item to."] = ""
L["Whitelist"] = "白名单" -- Needs review
-- L["(whitelisted)"] = ""
L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."] = "白名单可以设置除了你自己以外的玩家为不压价对象，但是如果白名单的玩家商品一口价和你一样，拍卖价比你低，照样对他压价。" -- Needs review
L["Will bind ScrollWheelDown (plus modifiers below) to the macro created."] = "将向下滚轮(加下面的辅助键)绑定到创建的宏" -- Needs review
L["Will bind ScrollWheelUp (plus modifiers below) to the macro created."] = "将向上滚轮(加下面的辅助键)绑定到创建的宏" -- Needs review
L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."] = "即使拍卖品被竞拍也撤消，撤消一个被竞拍的拍卖品你将要为此付出额外的费用。" -- Needs review
L["Would you like to load these options in beginner or advanced mode? If you have not used APM, QA3, or ZA before, beginner is recommended. Your selection can always be changed using the \"Hide advanced options\" checkbox in the \"Options\" page."] = "你想载入初级模式还是高级模式？如果之前没有使用过APM,QA3或ZA，建议使用初级模式。你可以随时在“选项”界面中开/关“隐藏高级选项”" -- Needs review
L["You can change the active database profile, so you can have different settings for every character."] = "选择其他的配置文件。" -- Needs review
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "输入一个名称用以创建新的配置文件，或选择一个已经存在的配置文件。" -- Needs review
L["You can not blacklist characters whom are on your whitelist."] = "你不能将在白名单里的角色添加到黑名单." -- Needs review
L["You can not blacklist yourself."] = "你不能将自己添加到黑名单." -- Needs review
L["You can not whitelist characters whom are on your blacklist."] = "你不能将在黑名单里的角色添加到白名单." -- Needs review
L["You can set a fixed fallback price for this group, or have the fallback price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = "可以为该组设置一个固定的回跌价，或设置一个比率来自动计算回跌价。如果该分组的有多个不同的物品和比率，最高值将用于整个分组。" -- Needs review
-- L["You can set a fixed max reset cost, or have it be a percentage of some other value."] = ""
-- L["You can set a fixed min reset price, or have it be a percentage of some other value."] = ""
-- L["You can set a fixed threshold, or have it be a percentage of some other value."] = ""
L["You do not have any players on your blacklist yet."] = "你的黑名单为空." -- Needs review
L["You do not have any players on your whitelist yet."] = "你的白名单是空的" -- Needs review
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "你不需要添加\"%s\",因为自己的小号默认在白名单中" -- Needs review
-- L["You don't any groups set to be included in a reset scan."] = ""
-- L["You don't any groups set up."] = ""
-- L["Your auction has not been undercut."] = ""
-- L["You've been undercut."] = ""