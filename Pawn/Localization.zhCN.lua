-- Pawn by Vger-Azjol-Nerub
-- www.vgermods.com
-- © 2006-2013 Green Eclipse.  This mod is released under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 license.
-- See Readme.htm for more information.

-- 
-- Chinese (Simplified) resources
------------------------------------------------------------

if GetLocale() == "zhCN" then

PawnLocal =
{
	AsteriskTooltipLine = "|TInterface\\AddOns\\Pawn\\Textures\\Question:0|t 特殊效果不包含在数值中。",
	AverageItemLevelIgnoringRarityTooltipLine = "平均物品等级",
	BackupCommand = "备份",
	BaseValueWord = "基础",
	CogwheelName = "齿轮",
	CopyScaleEnterName = "为你的新比重起个名字,  %s 的备份名称为:",
	CorrectGemsValueCalculationMessage = "   -- 正确有价值的宝石: %g",
	CrystalOfFearName = "Crystal of Fear",
	DebugOffCommand = "侦错 关",
	DebugOnCommand = "侦错 开",
	DeleteScaleConfirmation = "你确定你要删除 %s? 这将不能复原. 确定输入 \"%s\" :",
	DidntUnderstandMessage = "   (?) 无法识别 \"%s\".",
	EnchantedStatsHeader = "(当前值)",
	EngineeringName = "工程师",
	ExportAllScalesMessage = "按 Ctrl+C 复制你的比重标签，然后按 Ctrl+V 来粘贴到你电脑的文件里以作备份。", -- Needs review
	ExportScaleMessage = "按 Ctrl+C 为 |cffffffff%s|r 复制下面的比重标签, 然后按 Ctrl+V 粘贴.",
	FailedToGetItemLinkMessage = "从提示栏获取物品连接失败，这可能缘于一次模组冲突。", -- Needs review
	FailedToGetUnenchantedItemMessage = "获取基本物品数值失败，这可能缘于一次模组冲突。", -- Needs review
	FoundStatMessage = "   %d %s",
	GemColorList1 = "%d %s",
	GemColorList2 = "%d %s or %s",
	GemColorList3 = "任何颜色中的 %d ",
	GenericGemLink = "|Hitem:%d|h[宝石 %d]|h",
	GenericGemName = "(宝石 %d)",
	HiddenScalesHeader = "其它比重",
	ImportScaleMessage = "按 Ctrl+V to 粘贴一个你从别处复制的比重标签于此处:",
	ImportScaleTagErrorMessage = "Pawn 不明白这个标签.  你的复制是完整的吗?  尝试重新复制一遍:",
	ItemIDTooltipLine = "物品 ID",
	ItemLevelTooltipLine = "物品等级",
	LootUpgradeAdvisorHeader = "点击来同你的物品比较。|n",
	LootUpgradeAdvisorHeaderMany = "|TInterface\\AddOns\\Pawn\\Textures\\UpgradeArrow:0|t 对于 %d 比重来说这件物品是个提升.点击来同你的物品进行比较.",
	MissocketWorthwhileMessage = "   -- 但是这最好只用  %s 宝石:",
	NeedNewerVgerCoreMessage = "Pawn 需要一个新版本的 VgerCore. 请使用Pawn内置的VgerCore",
	NewScaleDuplicateName = "这个名字已存在.  重新为你的比重起个名字:",
	NewScaleEnterName = "为你的比重起个名字:",
	NewScaleNoQuotes = "比重不能有 \" 在他的名字中.  重新为你的比重起个名字:",
	NormalizationMessage = "   ---- 规范化通过除以 %g",
	NoScale = "(无)",
	NoScalesDescription = "准备开始, 导入一个比重或者啟用一个新的.",
	NoStatDescription = "从左侧列表选择一个属性.",
	Or = "或 ",
	ReforgeCappedStatWarning = "当您要重铸掉命中或校准属性时，请务必注意保证您的未命中概率不会超过0%.",
	ReforgeDebugMessage = "   ---- 通过重铸装备获得 +%g",
	ReforgeInstructions = "重铸 %s 为 %s",
	ReforgeInstructionsNoReforge = "不要重铸",
	RenameScaleEnterName = "%s 的新名为:",
	SocketBonusValueCalculationMessage = "   -- 插槽加成是值得的: %g",
	StatNameText = "1 |cffffffff%s|r 价值:",
	TooltipBestAnnotation = "%s  |cff8ec3e6(最佳)|r", -- Needs review
	TooltipBestAnnotationSimple = "%s  插槽最佳", -- Needs review
	TooltipBigUpgradeAnnotation = "%s  |TInterface\\AddOns\\Pawn\\Textures\\UpgradeArrow:0|t|cff00ff00 提升%s|r",
	TooltipSecondBestAnnotation = "%s  |cff8ec3e6(次佳)|r", -- Needs review
	TooltipSecondBestAnnotationSimple = "%s  次佳", -- Needs review
	TooltipUpgradeAnnotation = "%s  |TInterface\\AddOns\\Pawn\\Textures\\UpgradeArrow:0|t|cff00ff00+%.0f%% 提升%s|r",
	TooltipUpgradeFor1H = " 对于单手来说",
	TooltipUpgradeFor2H = " 对于双手来说",
	TooltipVersusLine = "%s|n  vs. %s%s|r",
	TotalValueMessage = "   ---- 总计: %g",
	UnenchantedStatsHeader = "(基本值)",
	Unusable = "(不能用)",
	UnusableStatMessage = "   -- %s 为无用的, 所以停止.",
	Usage = [=[
Pawn by Vger-Azjol-Nerub
www.vgermods.com
 
/pawn -- show or hide the Pawn UI
/pawn debug [ on | off ] -- spam debug messages to the console
/pawn backup -- backup all of your scales to scale tags
 
For more information on customizing Pawn, please see the help file (Readme.htm) that comes with the mod.
]=], -- Needs review
	ValueCalculationMessage = "   %g %s x %g each = %g",
	VisibleScalesHeader = "%s的比重",
	Stats = {
		AgilityInfo = "主要属性，敏捷。", -- Needs review
		Ap = "攻击强度", -- Needs review
		ApInfo = "攻击强度，现在不会直接出现在装备属性中，不包括从力量、敏捷获得的攻击强度。", -- Needs review
		ArmorInfo = "护甲值, 无论物品类型。有获得额外护甲技能的职业将指定一个数值来代替基础护甲和额外护甲。", -- Needs review
		ArmorTypes = "护甲类型", -- Needs review
		CasterStats = "法术属性", -- Needs review
		Cloth = "布甲", -- Needs review
		ClothInfo = "物品类型为布甲。", -- Needs review
		Crit = "爆击", -- Needs review
		CritInfo = "爆击等级，影响近战、远程和法术的爆击几率。", -- Needs review
		DodgeInfo = "躲闪等级。", -- Needs review
		DpsInfo = "武器的每秒伤害。(如果你想要给不同类型的武器估分，前往 \"特殊武器属性\" 部分。)", -- Needs review
		ExpertiseInfo = "精准属性。", -- Needs review
		HasteInfo = "急速等级，影响近战、远程和法术的攻击速度", -- Needs review
		Hit = "命中", -- Needs review
		HitInfo = "命中等级，影响近战远程和法术的命中。", -- Needs review
		HybridStats = "混合属性", -- Needs review
		IntellectInfo = "主要属性，智力。", -- Needs review
		Leather = "皮甲", -- Needs review
		LeatherInfo = "物品类型为皮甲。", -- Needs review
		Mail = "锁甲", -- Needs review
		MailInfo = "物品类型为锁甲。", -- Needs review
		MasteryInfo = "精通等级，从你投入点数最多的天赋树中获得的奖励。", -- Needs review
		MetaSocket = "多彩:特效", -- Needs review
		MetaSocketInfo = "多彩插槽，不管宝石是否镶嵌，只计算多彩宝石触发后的特效价值。", -- Needs review
		ParryInfo = "招架等级。", -- Needs review
		PhysicalStats = "物理攻击属性", -- Needs review
		Plate = "板甲", -- Needs review
		PlateInfo = "物品类型为板甲。", -- Needs review
		PrimaryStats = "基础属性",
		PvPPower = "PvP强度", -- Needs review
		PvPPowerInfo = "PvP强度. 使你的能力，给其他玩家（但不包括生物）造成更多的伤害，并在某些PVP的情况下，你的治疗法术治疗其他玩家。", -- Needs review
		PvPResilience = "PvP韧性", -- Needs review
		PvPResilienceInfo = "PvP韧性. 减少您受到的损害从其他玩家的攻击。", -- Needs review
		PvPStats = "PvP属性", -- Needs review
		Shield = "盾牌", -- Needs review
		ShieldInfo = "物品类型为盾牌。", -- Needs review
		Sockets = "插槽", -- Needs review
		SpecialWeaponStats = "特殊武器属性", -- Needs review
		SpeedBaseline = "速度基线", -- Needs review
		SpeedBaselineInfo = "不是实际属性，该数字在乘以均衡标准前要减去速度属性。\", \"|cffffffff速度基线|r 是", -- Needs review
		SpeedBaselineIs = "|cffffffff速度基线|r:", -- Needs review
		SpeedInfo = "武器攻击速度，武器挥动时间间隔。(如果你喜欢快速武器，此数字应该为负数。前往 \\\"特殊武器属性\\\" 中的 \\\"速度基线\\\" 部分。)", -- Needs review
		SpeedIs = "1 second |cffffffffswing speed|r is worth:", -- Needs review
		SpellPower = "法术强度", -- Needs review
		SpellPowerInfo = "法术强度.  出现在部分施法者武器/装备中.  不包括从智力获得的法术强度。", -- Needs review
		SpiritInfo = "主要属性，精神。", -- Needs review
		StaminaInfo = "主要属性，耐力。", -- Needs review
		StrengthInfo = "主要属性，力量。", -- Needs review
		TankStats = "防御属性", -- Needs review
		WeaponMainHandDps = "主手:每秒伤害", -- Needs review
		WeaponMainHandDpsInfo = "主手武器每秒伤害。", -- Needs review
		WeaponMainHandMaxDamage = "主手:伤害上限", -- Needs review
		WeaponMainHandMaxDamageInfo = "主手武器伤害上限。", -- Needs review
		WeaponMainHandMinDamage = "主手:伤害下限", -- Needs review
		WeaponMainHandMinDamageInfo = "主手武器伤害下限。", -- Needs review
		WeaponMainHandSpeed = "主手:攻速", -- Needs review
		WeaponMainHandSpeedInfo = "主手武器攻击速度。", -- Needs review
		WeaponMaxDamage = "主手:伤害上限", -- Needs review
		WeaponMaxDamageInfo = "主手武器伤害上限。", -- Needs review
		WeaponMeleeDps = "近战:每秒伤害", -- Needs review
		WeaponMeleeDpsInfo = "近战武器每秒伤害。", -- Needs review
		WeaponMeleeMaxDamage = "近战:伤害上限", -- Needs review
		WeaponMeleeMaxDamageInfo = "近战武器伤害上限。", -- Needs review
		WeaponMeleeMinDamage = "近战:伤害下限", -- Needs review
		WeaponMeleeMinDamageInfo = "近战武器伤害下限。", -- Needs review
		WeaponMeleeSpeed = "近战:攻速", -- Needs review
		WeaponMeleeSpeedInfo = "近战武器攻击速度。", -- Needs review
		WeaponMinDamage = "伤害下限", -- Needs review
		WeaponMinDamageInfo = "武器伤害下限。", -- Needs review
		WeaponOffHandDps = "副手:每秒伤害", -- Needs review
		WeaponOffHandDpsInfo = "副手武器每秒伤害。", -- Needs review
		WeaponOffHandMaxDamage = "副手:伤害上限", -- Needs review
		WeaponOffHandMaxDamageInfo = "副手武器伤害上限。", -- Needs review
		WeaponOffHandMinDamage = "副手:伤害下限", -- Needs review
		WeaponOffHandMinDamageInfo = "副手武器伤害下限。", -- Needs review
		WeaponOffHandSpeed = "副手:攻速", -- Needs review
		WeaponOffHandSpeedInfo = "副手武器攻击速度。", -- Needs review
		WeaponOneHandDps = "单手:每秒伤害", -- Needs review
		WeaponOneHandDpsInfo = "单手武器每秒伤害，不包括主手或副手武器。", -- Needs review
		WeaponOneHandMaxDamage = "单手:伤害上限", -- Needs review
		WeaponOneHandMaxDamageInfo = "单手武器伤害上限，不包括主手或副手武器。", -- Needs review
		WeaponOneHandMinDamage = "单手:伤害下限", -- Needs review
		WeaponOneHandMinDamageInfo = "单手武器伤害下限，不包括主手或副手武器。", -- Needs review
		WeaponOneHandSpeed = "单手:攻速", -- Needs review
		WeaponOneHandSpeedInfo = "单手武器攻击速度，不包括主手或副手武器。", -- Needs review
		WeaponRangedDps = "远程:每秒伤害", -- Needs review
		WeaponRangedDpsInfo = "远程武器每秒伤害。", -- Needs review
		WeaponRangedMaxDamage = "远程:伤害上限", -- Needs review
		WeaponRangedMaxDamageInfo = "远程武器伤害上限。", -- Needs review
		WeaponRangedMinDamage = "远程:伤害下限", -- Needs review
		WeaponRangedMinDamageInfo = "远程武器伤害下限。", -- Needs review
		WeaponRangedSpeed = "远程:攻速", -- Needs review
		WeaponRangedSpeedInfo = "远程武器攻击速度。", -- Needs review
		WeaponStats = "特殊武器属性", -- Needs review
		WeaponTwoHandDps = "双手:每秒伤害", -- Needs review
		WeaponTwoHandDpsInfo = "双手武器每秒伤害。", -- Needs review
		WeaponTwoHandMaxDamage = "双手:伤害上限", -- Needs review
		WeaponTwoHandMaxDamageInfo = "双手武器伤害上限。", -- Needs review
		WeaponTwoHandMinDamage = "双手:伤害下限", -- Needs review
		WeaponTwoHandMinDamageInfo = "双手武器伤害下限。", -- Needs review
		WeaponTwoHandSpeed = "双手:攻速", -- Needs review
		WeaponTwoHandSpeedInfo = "双手武器攻击速度。", -- Needs review
		WeaponType1HAxe = "单手斧", -- Needs review
		WeaponType1HAxeInfo = "物品类型为单手斧。", -- Needs review
		WeaponType1HMace = "单手锤", -- Needs review
		WeaponType1HMaceInfo = "物品类型为单手锤。", -- Needs review
		WeaponType1HSword = "单手剑", -- Needs review
		WeaponType1HSwordInfo = "物品类型为单手剑。", -- Needs review
		WeaponType2HAxe = "双手斧", -- Needs review
		WeaponType2HAxeInfo = "物品类型为双手斧。", -- Needs review
		WeaponType2HMace = "双手锤", -- Needs review
		WeaponType2HMaceInfo = "物品类型为双手锤。", -- Needs review
		WeaponType2HSword = "双手剑", -- Needs review
		WeaponType2HSwordInfo = "物品类型为双手剑。", -- Needs review
		WeaponTypeBow = "弓", -- Needs review
		WeaponTypeBowInfo = "物品类型为弓。", -- Needs review
		WeaponTypeCrossbow = "驽", -- Needs review
		WeaponTypeCrossbowInfo = "物品类型为驽。", -- Needs review
		WeaponTypeDagger = "匕首", -- Needs review
		WeaponTypeDaggerInfo = "物品类型为匕首。", -- Needs review
		WeaponTypeFistWeapon = "拳套", -- Needs review
		WeaponTypeFistWeaponInfo = "物品类型为拳套。", -- Needs review
		WeaponTypeFrill = "副手物品", -- Needs review
		WeaponTypeFrillInfo = "物品类型为副手，通常为施法者装备的副手位置的物品，不是武器或盾牌。", -- Needs review
		WeaponTypeGun = "枪械", -- Needs review
		WeaponTypeGunInfo = "物品类型为枪械。", -- Needs review
		WeaponTypeOffHand = "副手武器", -- Needs review
		WeaponTypeOffHandInfo = "物品类型为副手。只能装备在副手位置的副手物品，而不是盾牌或者可以装备在这个位置的单手武器。", -- Needs review
		WeaponTypePolearm = "长柄武器", -- Needs review
		WeaponTypePolearmInfo = "物品类型为长柄武器。", -- Needs review
		WeaponTypes = "武器类型", -- Needs review
		WeaponTypeStaff = "法杖", -- Needs review
		WeaponTypeStaffInfo = "物品类型为法杖。", -- Needs review
		WeaponTypeWand = "魔杖", -- Needs review
		WeaponTypeWandInfo = "物品类型为魔杖。", -- Needs review
	},
	TooltipParsing = {
		Agility = "^%+?([-%d%.,]+) 敏捷$", -- Needs review
		AllStats = "^%+?([%d%.,]+) 所有属性$", -- Needs review
		Ap = "^%+?([%d%.,]+) 攻击强度$", -- Needs review
		Armor = "^([%d%.,]+)点护甲$", -- Needs review
		Armor2 = "^UNUSED$", -- Needs review
		Axe = "^斧$", -- Needs review
		BagSlots = "^%d+格容器 .+$", -- Needs review
		BladesEdgeMountains = "^刀锋山$", -- Needs review
		Bow = "^弓$", -- Needs review
		ChanceOnHit = "击中时可能：", -- Needs review
		Charges = "^.+ Charges?$", -- Needs review
		Cloth = "^布甲$", -- Needs review
		CooldownRemaining = "^冷却时间剩余：", -- Needs review
		Crit = "^%+?([%d%.,]+) 爆击$", -- Needs review
		Crit2 = "^UNUSED$", -- Needs review
		Crossbow = "^弩$", -- Needs review
		Dagger = "^匕首$", -- Needs review
		Design = "设计图：", -- Needs review
		DisenchantingRequires = "^分解需要", -- Needs review
		Dodge = "^%+?([%d%.,]+) 躲闪$", -- Needs review
		Dodge2 = "^UNUSED$", -- Needs review
		Dps = "^%（每秒伤害([%d%.,]+)）$", -- Needs review
		DpsAdd = "^Adds ([%d%.,]+) damage per second$", -- Needs review
		Duration = "^耐久度:", -- Needs review
		EnchantmentAccuracy = "^精确$", -- Needs review
		EnchantmentArmorKit = "^%+([%d%.,]+) 护甲$", -- Needs review
		EnchantmentCounterweight = "^平衡锤 %(%+([%d%.,]+) 急速%", -- Needs review
		EnchantmentFieryWeapon = "^灼热武器$", -- Needs review
		EnchantmentGreaterVitality = "^每5秒恢复([%d%.,]+)点法力及生命力$", -- Needs review
		EnchantmentHealth = "^%+([%d%.,]+) 生命$", -- Needs review
		EnchantmentHealth2 = "^%+([%d%.,]+) 生命值$", -- Needs review
		EnchantmentPotency = "^潜能$", -- Needs review
		EnchantmentSurefooted = "^稳固$", -- Needs review
		EnchantmentTitaniumWeaponChain = "^泰坦神铁武器链$", -- Needs review
		Equip = "装备：", -- Needs review
		Expertise = "^%+?([%d%.,]+) 精准$", -- Needs review
		Expertise2 = "^UNUSED$", -- Needs review
		FistWeapon = "^拳套$", -- Needs review
		Formula = "公式：", -- Needs review
		Gun = "^枪械$", -- Needs review
		Haste = "^%+?([%d%.,]+) 急速$", -- Needs review
		Haste2 = "^UNUSED$", -- Needs review
		HeirloomLevelRange = "^需要等级 %d+ 到 (%d+)", -- Needs review
		HeirloomXpBoost = "^装备： 获得的经验值提高", -- Needs review
		Hit = "^%+?([%d%.,]+) 命中$", -- Needs review
		Hit2 = "^UNUSED$", -- Needs review
		Hp5 = "^装备: 每5秒恢复([%d%.,]+)生命力。$", -- Needs review
		Hp52 = "^装备: 每5秒恢复([%d%.,]+)生命力。$", -- Needs review
		Hp53 = "^每5秒恢复([%d%.,]+)生命力$", -- Needs review
		Hp54 = "^每5秒恢复([%d%.,]+)生命力。$", -- Needs review
		Intellect = "^%+?([-%d%.,]+) 智力$", -- Needs review
		Leather = "^皮甲$", -- Needs review
		Mace = "^锤$", -- Needs review
		Mail = "^锁甲$", -- Needs review
		Manual = "配方：", -- Needs review
		Mastery = "^%+?([%d%.,]+) 精通$\"", -- Needs review
		Mastery2 = "^UNUSED$", -- Needs review
		MetaGemRequirements = "|cff%x%x%x%x%x%xRequires", -- Needs review
		MobInfoCompatibility = "^|cff00e0ff掉落于", -- Needs review
		Mp5 = "^每5秒恢复([%d%.,]+)法力。$", -- Needs review
		Mp52 = "^每5秒恢复([%d%.,]+)法力$", -- Needs review
		Mp53 = "^%法力恢复每5秒([%d%.,]+)。$", -- Needs review
		Mp54 = "^UNUSED$", -- Needs review
		Mp55 = "^UNUSED$", -- Needs review
		MultiStatSeparator1 = "和", -- Needs review
		NormalizationEnchant = "^附魔：(.*)$", -- Needs review
		NormalizationReforge = "^(.*)%（由(.*)重铸而来%）$", -- Needs review
		OnlyFitsInMetaGemSlot = "^\"只能镶嵌在多彩宝石插槽中%。\"$", -- Needs review
		OutfitterCompatibility = "^Used by outfits:", -- Needs review
		Parry = "^%+?([%d%.,]+) 招架$", -- Needs review
		Parry2 = "^UNUSED$", -- Needs review
		Pattern = "图样：", -- Needs review
		Plans = "食谱：", -- Needs review
		Plate = "^板甲$", -- Needs review
		Polearm = "^长柄武器$", -- Needs review
		PvPPower = "^%+?([%d%.,]+) PvP强度$", -- Needs review
		Recipe = "食谱：", -- Needs review
		Requires2 = "^UNUSED$", -- Needs review
		Resilience = "^%+?([%d%.,]+) PvP韧性$", -- Needs review
		Schematic = "结构图：", -- Needs review
		Scope = "^瞄准镜%（%+([%d%.,]+) 伤害%）$", -- Needs review
		ScopeCrit = "^瞄准镜 %(%+([%d%.,]+) 爆击%)$", -- Needs review
		ScopeRangedCrit = "^%+?([%d%.,]+) 远程爆击$", -- Needs review
		Season = "^赛季", -- Needs review
		ShadowmoonValley = "^影月谷$", -- Needs review
		Shield = "^盾牌$", -- Needs review
		SocketBonusPrefix = "镶孔奖励：", -- Needs review
		Speed = "^速度 ([%d%.,]+)$", -- Needs review
		Speed2 = "^UNUSED$", -- Needs review
		SpellPower = "^%+?([%d%.,]+) 法术强度$", -- Needs review
		SpellPowerArcane = "^%+([%d%.,]+) 奥术法术伤害$", -- Needs review
		SpellPowerFire = "^%+([%d%.,]+) 火焰法术伤害$", -- Needs review
		SpellPowerFrost = "^%+([%d%.,]+) 冰霜法术伤害$", -- Needs review
		SpellPowerNature = "^%+([%d%.,]+) 自然法术伤害$", -- Needs review
		SpellPowerShadow = "^%+([%d%.,]+) 暗影法术伤害$", -- Needs review
		Spirit = "^%+?([-%d%.,]+) 精神$", -- Needs review
		Staff = "^法杖$", -- Needs review
		Stamina = "^%+?([-%d%.,]+) 耐力$", -- Needs review
		Strength = "^%+?([-%d%.,]+) 力量$", -- Needs review
		Sword = "^剑$", -- Needs review
		TempestKeep = "^风暴要塞$", -- Needs review
		TemporaryBuffMinutes = "^.+%(%d+ 分钟%)$", -- Needs review
		TemporaryBuffSeconds = "^.+%(%d+ 秒%)$", -- Needs review
		UpgradeLevel = "^升级：", -- Needs review
		Use = "使用：", -- Needs review
		Wand = "^魔杖$", -- Needs review
		WeaponDamage = "^([%d%.,]+) %- ([%d%.,]+)点伤害$", -- Needs review
		WeaponDamageArcane = "^%+?([%d%.,]+) %- ([%d%.,]+)点火焰伤害$", -- Needs review
		WeaponDamageEnchantment = "^%+?([%d%.,]+) 武器伤害$", -- Needs review
		WeaponDamageEquip = "^装备： %+?([%d%.,]+) 武器伤害%。", -- Needs review
		WeaponDamageExact = "^%+?([%d%.,]+) 伤害$", -- Needs review
		WeaponDamageFire = "^%+?([%d%.,]+) %- ([%d%.,]+)点火焰伤害$", -- Needs review
		WeaponDamageFrost = "^%+?([%d%.,]+) %- ([%d%.,]+)点冰霜伤害$", -- Needs review
		WeaponDamageHoly = "^%+?([%d%.,]+) %- ([%d%.,]+)点神圣伤害$", -- Needs review
		WeaponDamageNature = "^%+?([%d%.,]+) %- ([%d%.,]+)点自然伤害$", -- Needs review
		WeaponDamageShadow = "^%+?([%d%.,]+) %- ([%d%.,]+)点暗影伤害$", -- Needs review
	},
	UI = {
		AboutHeader = "关于 Pawn", -- Needs review
		AboutReadme = "New to Pawn?  See the getting started tab for a basic introduction.", -- Needs review
		AboutTab = "关于", -- Needs review
		AboutTranslation = "简体中文by：贫僧法号智障 三区 阿扎达斯", -- Needs review
		AboutVersion = "版本 %s", -- Needs review
		AboutWebsite = [=[For other mods by Vger, visit vgermods.com.

Wowhead stat weights used with permission—please direct feedback on the default scale values to Wowhead.]=], -- Needs review
		CompareClearItems = "清除", -- Needs review
		CompareClearItemsTooltip = "移除两件对照的物品.", -- Needs review
		CompareCogwheelSockets = "齿轮插槽", -- Needs review
		CompareColoredSockets = "彩色插槽", -- Needs review
		CompareEquipped = "已装备", -- Needs review
		CompareGemTotalValue = "宝石的价值", -- Needs review
		CompareHeader = "用 %s 进行对比", -- Needs review
		CompareMetaSockets = "多彩插槽", -- Needs review
		CompareOtherHeader = "其他", -- Needs review
		CompareReforgingPotential = "重铸潜力", -- Needs review
		CompareShaTouchedSockets = "染煞", -- Needs review
		CompareSlotEmpty = "(空)", -- Needs review
		CompareSocketBonus = "镶孔奖励", -- Needs review
		CompareSocketsHeader = "插槽", -- Needs review
		CompareSpecialEffects = "特殊效果", -- Needs review
		CompareSwap = "< 对调 >", -- Needs review
		CompareSwapTooltip = "将两边物品对调.", -- Needs review
		CompareTab = "比较", -- Needs review
		CompareVersus = "—vs.—", -- Needs review
		CompareWelcomeLeft = "首先, 从列表左边选择一个比重.", -- Needs review
		CompareWelcomeRight = [=[然后, 将一个物品放入此栏.

Pawn 会将它与你装备的物品进行对比.]=], -- Needs review
		CompareYourBest = "最好的槽", -- Needs review
		GemsColorHeader = "%s 宝石", -- Needs review
		GemsHeader = "适合 %s 的宝石", -- Needs review
		GemsNoneFound = "没有相应的宝石被发现。", -- Needs review
		GemsQualityLevel = "宝石的品质", -- Needs review
		GemsQualityLevelTooltip = [=[以物品等级来推荐宝石。

例如，如果选择 "463" 等级，Pawn将显示的宝石，适合使用在463等级：熊猫人之谜英雄副本战利品。]=], -- Needs review
		GemsShowBest = "显示最好的宝石", -- Needs review
		GemsShowBestTooltip = "显示了目前可以选择的最好的宝石。有些低级装备可能显示过于高级的宝石。", -- Needs review
		GemsShowForItemLevel = "输入物品等级以推荐适合的宝石：", -- Needs review
		GemsShowForItemLevelTooltip = "为输入的物品等级显示适合的宝石。", -- Needs review
		GemsTab = "珠宝", -- Needs review
		GemsWelcome = "Select a scale on the left to see the gems that Pawn recommends.", -- Needs review
		HelpHeader = "欢迎使用 Pawn!", -- Needs review
		HelpTab = "准备开始", -- Needs review
		HelpText = [=[Pawn 通过计算分数来帮你更加简单的选出哪个物品更适合你。 这些分数显示在你所有物品提示栏的底部。

Each item will get one score for each “scale” that is active for your character.  A scale lists the stats that are important to you, and how many points each stat is worth.  You usually have one scale for each of your class's specs or roles.  The scores are normally hidden, but you can see the scores that Pawn assigns your items by choosing the "Show scale values and upgrade %" option on the Options tab.

Pawn comes with scales from Wowhead for each class and spec.  You can turn scales on and off, create your own by assigning point values to each stat, import scales from Rawr or other popular tools, or share scales on the internet.

|cff8ec3e6尝试这些功能，一旦你掌握基础:|r
 • 用 Pawn 的比较页面来比较两件物品的属性。
 • 用在一件物品链接窗口上点击右键来查看它比你当前的物品如何。
 • 用Shift加右键点击一件有插槽的物品，可让 Pawn 为它提供宝石相关的建议。
 • 在比重页面上为你的一个比重做备份，并在编辑页面上自定义属性值。
 • 在网路上为你职业寻找更多的比重，或者用 Rawr 自建一个。
 • 查看读我文档体会更多 Pawn 的高级功能相关。]=], -- Needs review
		InterfaceOptionsBody = "点击 Pawn 按钮到达此处。  你也可从插件页面打开 Pawn ，或者为它绑定一个按键。", -- Needs review
		InterfaceOptionsWelcome = "Pawn 设置位于 Pawn 介面处.", -- Needs review
		InventoryButtonTooltip = "点击显示Pawn介面.", -- Needs review
		InventoryButtonTotalsHeader = "所有已装备物品之总计:", -- Needs review
		KeyBindingCompareItemLeft = "比较物品 (左)", -- Needs review
		KeyBindingCompareItemRight = "比较物品 (右)", -- Needs review
		KeyBindingShowUI = "显示 Pawn 介面", -- Needs review
		OptionsAdvisorHeader = "建议选项", -- Needs review
		OptionsAlignRight = "排列数值到提示栏右边.", -- Needs review
		OptionsAlignRightTooltip = "Enable this option to align your Pawn values and upgrade information to the right edge of the tooltip instead of the left.", -- Needs review
		OptionsBlankLine = "数值前加一个空白行", -- Needs review
		OptionsBlankLineTooltip = "Keep your item tooltips extra tidy by enabling this option, which adds a blank line before the Pawn values.", -- Needs review
		OptionsButtonHidden = "隐藏", -- Needs review
		OptionsButtonHiddenTooltip = "不在角色属性面板显示.", -- Needs review
		OptionsButtonPosition = "显示Pawn按键:", -- Needs review
		OptionsButtonPositionLeft = "于左侧", -- Needs review
		OptionsButtonPositionLeftTooltip = "在角色属性面板左下侧显示 Pawn 按键.", -- Needs review
		OptionsButtonPositionRight = "于右侧", -- Needs review
		OptionsButtonPositionRightTooltip = "在角色属性面板右下侧显示 Pawn 按键.", -- Needs review
		OptionsColorBorder = "可升级的著色提示外框", -- Needs review
		OptionsColorBorderTooltip = "Enable this option to change the color of the tooltip border of items that are upgrades to green.  Disable this option if it interferes with other mods that change tooltip borders.", -- Needs review
		OptionsCurrentValue = "同时显示目前与基础的数值", -- Needs review
		OptionsCurrentValueTooltip = [=[Enable this option to have Pawn show two values for items: the current value, which reflects the current state of an item with the actual gems, enchantments, and reforging that the item has at the moment, with empty sockets providing no benefit, in addition to the base value, which is what Pawn normally displays.  The current value will be displayed before the base value.  This option has no effect unless you turn on item value display on tooltips.

You should still use the base value for determining between two items at endgame, but the current value can be helpful when leveling and to make it easier to decide whether it's worth immediately equipping a new item before it has gems or enchantments.]=], -- Needs review
		OptionsDebug = "显示侦错讯息", -- Needs review
		OptionsDebugTooltip = [=[If you're not sure how Pawn is calculating the values for a particular item, enable this option to make Pawn spam all sorts of 'useful' data to the chat console whenever you hover over an item.  This information includes which stats Pawn thinks the item has, which parts of the item Pawn doesn't understand, and how it took each one into account for each of your scales.

This option will fill up your chat log quickly, so you'll want to turn it off once you're finished investigating.

Shortcuts:
/pawn debug on
/pawn debug off]=], -- Needs review
		OptionsHeader = "调整 Pawn 选项", -- Needs review
		OptionsInventoryIcon = "显示物品图标", -- Needs review
		OptionsInventoryIconTooltip = "Enable this option to show inventory icons next to item link windows.", -- Needs review
		OptionsItemIDs = "显示物品ID", -- Needs review
		OptionsItemIDsTooltip = [=[Enable this option to have Pawn display the item ID of every item you come across, as well as the IDs of all enchantments and gems.

Every item in World of Warcraft has an ID number associated with it.  This information is generally only useful to mod authors.]=], -- Needs review
		OptionsLootAdvisor = "显示装备掉落升级建议", -- Needs review
		OptionsLootAdvisorTooltip = "When loot drops in a dungeon and it's an upgrade for your character, Pawn will show a popup attached to the loot roll box telling you about the upgrade.", -- Needs review
		OptionsOtherHeader = "其它选项", -- Needs review
		OptionsQuestUpgradeAdvisor = "显示任务奖励升级建议", -- Needs review
		OptionsQuestUpgradeAdvisorTooltip = "In your quest log and when talking to NPCs, if one of the quest reward choices is an upgrade for your current gear, Pawn will show a green arrow icon on that item.  If none of the items is an upgrade, Pawn will show a pile of coins on the item that is worth the most when sold to a vendor.", -- Needs review
		OptionsReforgingAdvisor = "显示重铸建议", -- Needs review
		OptionsReforgingAdvisorTooltip = "当访问重铸商时候，将显示一个弹出的统计框，提示重铸的建议。", -- Needs review
		OptionsResetUpgrades = "重新扫描装备", -- Needs review
		OptionsResetUpgradesTooltip = [=[Pawn will forget what it knows about the best items you've ever equipped and re-scan your gear in order to provide more up-to-date upgrade information in the future.

Use this feature if you find that Pawn is making poor upgrade suggestions as a result of items that you've vendored, destroyed, or otherwise do not use anymore.  This will affect all of your characters that use Pawn.]=], -- Needs review
		OptionsSocketingAdvisor = "显示插槽建议", -- Needs review
		OptionsSocketingAdvisorTooltip = "When adding gems to an item, Pawn will show a popup suggesting gems that you can add to the item that will maximize its power.  (To see the full list of gem suggestions for each color, see the Gems tab, where you can also customize the quality of gems to use.)", -- Needs review
		OptionsTab = "设置", -- Needs review
		OptionsTooltipHeader = "提示栏设置", -- Needs review
		OptionsTooltipUpgradesOnly = "只显示升级", -- Needs review
		OptionsTooltipUpgradesOnlyTooltip = [=[这是最简化的设置.  只显示 Pawn 数值和升级百分比 for items that are an upgrade to your current gear, and indicate which items are the best items you own for each scale.  Don't show anything at all for lesser items.

|cff8ec3e6Fire:|r  |TInterface\AddOns\Pawn\Textures\UpgradeArrow:0|t |cff00ff00+10% upgrade|r

...or...

|cff8ec3e6Fire:  your best|r]=], -- Needs review
		OptionsTooltipValuesAndUpgrades = "显示比重数值和升级%", -- Needs review
		OptionsTooltipValuesAndUpgradesTooltip = [=[Show Pawn values for all of your visible scales on all items, except those that have a value of zero.  In addition, indicate which items are an upgrade to your current gear.

|cff8ec3e6Frost:  123.4
Fire:  156.7 |TInterface\AddOns\Pawn\Textures\UpgradeArrow:0|t |cff00ff00+10% upgrade|r]=], -- Needs review
		OptionsTooltipValuesOnly = "只显示比重数值,不显示升级 %", -- Needs review
		OptionsTooltipValuesOnlyTooltip = [=[Show Pawn values for all of your visible scales on all items, except those that have a value of zero.  Don't indicate which items are an upgrade to your current gear.  This option reflects the default behavior of older versions of Pawn.

|cff8ec3e6Frost:  123.4
Fire:  156.7|r]=], -- Needs review
		OptionsUpgradeHeader = "在提示栏显示 |TInterface\\AddOns\\Pawn\\Textures\\UpgradeArrow:0|t 升级:", -- Needs review
		OptionsUpgradesForBothWeaponTypes = "同时显示双手武器和双持武器的提升建议", -- Needs review
		OptionsUpgradesForBothWeaponTypesTooltip = [=[Pawn升级顾问会同时跟踪记录和显示双手武器或者双持武器（魔杖、主副手武器等）的提升。

如果选中，你依旧可以看到分开的提升数值提示，最好的双手武器，最好的双持武器。

如果不选中，你只能看到针对于你已经装备的武器的提升。（译者注：建议选上。）]=], -- Needs review
		OptionsWelcome = "按照你的偏好配置 Pawn.  更改会马上生效.", -- Needs review
		ReforgingAdvisorHeader = "Pawn 重铸建议:", -- Needs review
		ScaleChangeColor = "调整顏色", -- Needs review
		ScaleChangeColorTooltip = "调整物品提示栏中比重名称和数值的顏色.", -- Needs review
		ScaleCopy = "复制", -- Needs review
		ScaleCopyTooltip = "创建一个新比重从此比重复制而来.", -- Needs review
		ScaleDefaults = "预设", -- Needs review
		ScaleDefaultsTooltip = "创建一个新比重从预设比重复制过来.", -- Needs review
		ScaleDeleteTooltip = [=[将这个比重删除.

这个命令不能被撤销!]=], -- Needs review
		ScaleEmpty = "创建", -- Needs review
		ScaleEmptyTooltip = "创建一个新比重从零开始.", -- Needs review
		ScaleExport = "导出", -- Needs review
		ScaleExportTooltip = "在网路上同别人分享你的比重.", -- Needs review
		ScaleHeader = "管理你的Pawn均衡值", -- Needs review
		ScaleImport = "导入", -- Needs review
		ScaleImportTooltip = "通过网路粘贴一个比重标签，来添加一个新比重.", -- Needs review
		ScaleNewHeader = "创建一个新比重", -- Needs review
		ScaleRename = "重命名", -- Needs review
		ScaleRenameTooltip = "为这个比重重命名.", -- Needs review
		ScaleSelectorHeader = "选择一个比重:", -- Needs review
		ScaleSelectorShowScale = "在提示栏中显示比重", -- Needs review
		ScaleSelectorShowScaleTooltip = "当这个选项被选中时，此比重值将显示在此角色的物品工具提示上。每个比重可以显示在一个角色，多个角色，或没有角色。", -- Needs review
		ScaleShareHeader = "共享你的比重", -- Needs review
		ScaleTab = "比重", -- Needs review
		ScaleTypeNormal = "你可以在编辑页面中调整这个比重.", -- Needs review
		ScaleTypeReadOnly = "若要自定义这个比重，你应该先为它做个备份.", -- Needs review
		ScaleWelcome = "比重是设定属性和价值，这是用来分配物品的EP值。你可以定制你自己的或别人已经创造的比重值。", -- Needs review
		SocketingAdvisorButtonTooltip = "点击显示Pawn珠宝介面, 此处你可看到 Pawn 为每种比重推荐的宝石,和更换至更高或更低品质的宝石.", -- Needs review
		SocketingAdvisorHeader = "Pawn 插槽建议:", -- Needs review
		ValuesDoNotShowUpgradesFor1H = "请不要显示单手装备的提升", -- Needs review
		ValuesDoNotShowUpgradesFor2H = "请不要显示双手装备的提升", -- Needs review
		ValuesDoNotShowUpgradesTooltip = "啟用该选项来隐藏此类型装备的提升。比如，虽然坦骑可以用双手武器，但是对坦骑设定来说一件双手武器从来都不是一个\\\"提升\\\"，因此Pawn将不会为它们显示提升信息。同样，惩戒骑可以使用单手武器，但它们从不是一个提升。", -- Needs review
		ValuesFollowSpecialization = "只有显示50等以后我最佳护甲类型的提升", -- Needs review
		ValuesFollowSpecializationTooltip = "啟用该选项来隐藏50等以后非职业专精的护甲类型。比如，神圣圣骑士在50等学到了鎧甲专精, 当只装备鎧甲时增加智力5%。当此选项选择时Pawn将不会考虑布、皮及锁甲对50+神圣圣骑士的提升", -- Needs review
		ValuesHeader = "调整 %s 分值", -- Needs review
		ValuesIgnoreStat = "带此属性的物品没有用处。", -- Needs review
		ValuesIgnoreStatTooltip = "啟用这个选项造成任何物品与这个属性没有得到这个比重的值。 例如, 萨满不能装备鎧甲, 所以为萨满设计的比重值可以标记鎧甲为不可用的, 所以鎧甲的护甲不能从这比重中得到一个值。", -- Needs review
		ValuesNormalize = "校正数值 (比如 Wowhead)", -- Needs review
		ValuesNormalizeTooltip = "启用此选项以校正优化你的评分，使装备的评分不至于过大。", -- Needs review
		ValuesRemove = "移除", -- Needs review
		ValuesRemoveTooltip = "从比重中移除此属性。", -- Needs review
		ValuesTab = "数值", -- Needs review
		ValuesWelcome = "你可以为该比重自定义分配给每项属性的数值.  若要管理你的那些比重和增加新比重,请用比重页面.", -- Needs review
		ValuesWelcomeNoScales = "你还未选择比重. 若要啟动,请去比重页面并啟动一个新比重或者从网上粘贴一个.", -- Needs review
		ValuesWelcomeReadOnly = "已被选择的该比重不能被更改.若你想改变这些数值,请去比重页面并生成一份该比重的备份或者啟动一个新比重.", -- Needs review
	},
	Wowhead = {
		DeathKnightBloodTank = "死亡骑士:鲜血", -- Needs review
		DeathKnightFrostDps = "死亡骑士:冰霜", -- Needs review
		DeathKnightUnholyDps = "死亡骑士:邪恶", -- Needs review
		DruidBalance = "德鲁伊:平衡", -- Needs review
		DruidFeralDps = "德鲁伊:猎豹", -- Needs review
		DruidFeralTank = "德鲁伊:熊", -- Needs review
		DruidRestoration = "德鲁伊:恢复", -- Needs review
		HunterBeastMastery = "猎人:野兽控制", -- Needs review
		HunterMarksman = "猎人:射击", -- Needs review
		HunterSurvival = "猎人:生存", -- Needs review
		MageArcane = "法师:奥术", -- Needs review
		MageFire = "法师:火焰", -- Needs review
		MageFrost = "法师:冰霜", -- Needs review
		MonkBrewmaster = "武僧：酒仙", -- Needs review
		MonkMistweaver = "武僧：织雾者", -- Needs review
		MonkWindwalker = "武僧：风行", -- Needs review
		PaladinHoly = "圣骑士:神圣", -- Needs review
		PaladinRetribution = "圣骑士:惩戒", -- Needs review
		PaladinTank = "圣骑士:防护", -- Needs review
		PriestDiscipline = "牧师:戒律", -- Needs review
		PriestHoly = "牧师:神圣", -- Needs review
		PriestShadow = "牧师:暗影", -- Needs review
		Provider = "Wowhead 尺度标准", -- Needs review
		RogueAssassination = "潜行者:刺杀", -- Needs review
		RogueCombat = "潜行者:战斗", -- Needs review
		RogueSubtlety = "潜行者:敏锐", -- Needs review
		ShamanElemental = "萨满祭司:元素", -- Needs review
		ShamanEnhancement = "萨满祭司:增强", -- Needs review
		ShamanRestoration = "萨满祭司:恢复", -- Needs review
		WarlockAffliction = "术士:痛苦", -- Needs review
		WarlockDemonology = "术士:恶魔学识", -- Needs review
		WarlockDestruction = "术士:毁灭", -- Needs review
		WarriorArms = "战士:武器", -- Needs review
		WarriorFury = "战士:狂怒", -- Needs review
		WarriorTank = "战士:防御", -- Needs review
	},
}

end