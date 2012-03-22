
-- courtesy of nandini


do
	LSW.cooldownGroups = {
	 Alchemy = {
	  ["Transmute"] = {
	   duration = 72000 , -- 20 hours, in seconds
	   spells = {
		11479 , -- Transmute: Iron to Gold
		11480 , -- Transmute: Mithril to Truesilver
		60350 , -- Transmute: Titanium

		17559 , -- Transmute: Air to Fire
		17560 , -- Transmute: Fire to Earth
		17561 , -- Transmute: Earth to Water
		17562 , -- Transmute: Water to Air
		17563 , -- Transmute: Undeath to Water
		17565 , -- Transmute: Life to Earth
		17566 , -- Transmute: Earth to Life

		28585 , -- Transmute: Primal Earth to Life
		28566 , -- Transmute: Primal Air to Fire
		28567 , -- Transmute: Primal Earth to Water
		28568 , -- Transmute: Primal Fire to Earth
		28569 , -- Transmute: Primal Water to Air
		28580 , -- Transmute: Primal Shadow to Water
		28581 , -- Transmute: Primal Water to Shadow
		28582 , -- Transmute: Primal Mana to Fire
		28583 , -- Transmute: Primal Fire to Mana
		28584 , -- Transmute: Primal Life to Earth
		53771 , -- Transmute: Eternal Life to Shadow
		53773 , -- Transmute: Eternal Life to Fire
		53774 , -- Transmute: Eternal Fire to Water
		53775 , -- Transmute: Eternal Fire to Life
		53776 , -- Transmute: Eternal Air to Water
		53777 , -- Transmute: Eternal Air to Earth
		53779 , -- Transmute: Eternal Shadow to Earth
		53780 , -- Transmute: Eternal Shadow to Life
		53781 , -- Transmute: Eternal Earth to Air
		53782 , -- Transmute: Eternal Earth to Shadow
		53783 , -- Transmute: Eternal Water to Air
		53784 , -- Transmute: Eternal Water to Fire

		66658 , -- Transmute: Ametrine
		66659 , -- Transmute: Cardinal Ruby
		66660 , -- Transmute: King's Amber
		66662 , -- Transmute: Dreadstone
		66663 , -- Transmute: Majestic Zircon
		66664 , -- Transmute: Eye of Zul
	   } ,
	  } ,
	 } ,
	 Mining = {
	  ["Titansteel"] = {
	   duration = 72000 , -- 20 hours, in seconds
	   spells = {
		52208 , -- Smelt Titansteel
	   } ,
	  } ,
	 } ,
	 Inscription = {
	  ["Minor research"]  = {
	   duration = 72000 , -- 20 hours, in seconds
	   spells = {
		61288 , -- Minor Inscription Research
	   } ,
	  } ,
	  ["Northrend research"] = {
	   duration = 72000 , -- 20 hours, in seconds
	   spells = {
		61177 , -- Northrend Inscription Research
	   } ,
	  } ,
	 } ,
	 Enchanting = {
	  ["Void Sphere"] = {
	   duration = 172800 , -- 48 hours, in seconds
	   spells = {
		28028 , -- Void Sphere
	   } ,
	  } ,
	 } ,
	}

	LSW.spellCooldown = {}

	for tradeSkill, cooldownGroup in pairs(LSW.cooldownGroups) do
		for groupName, data in pairs(cooldownGroup) do
			for i=1,#data.spells do
				LSW.spellCooldown[data.spells[i]] = cooldownGroup
			end
		end
	end
end
