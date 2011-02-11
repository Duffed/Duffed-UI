dStuff = {
	ccannouncement = false,		-- Announce CC/Buffs/Debuffs
	tbtimer = false,			-- Show Watchframe when entering tb (abuse :<)
	drinkannouncement = true,	-- drink announcement for arena
	sayinterrupt = true,		-- Announce interrupt in /p or /ra
	priest_SoS = false,			-- Priest Soul of Strength Icon
}

-- spelllist for the buff/debuff announcement
SpellsAN = {				-- true means you announce start and end of buff/debuff; false only start
	-- CC
	[GetSpellInfo(6770)] 	= false, 	-- Sap
	[GetSpellInfo(118)] 	= false, 	-- Polymorph
	[GetSpellInfo(61305)] 	= false, 	-- Polymorph (Black Cat)
	[GetSpellInfo(28272)] 	= false, 	-- Polymorph (Pig)
	[GetSpellInfo(61721)] 	= false, 	-- Polymorph (Rabbit)
	[GetSpellInfo(61780)] 	= false, 	-- Polymorph (Turkey)
	[GetSpellInfo(28271)] 	= false, 	-- Polymorph (Turtle)
	[GetSpellInfo(61025)] 	= false, 	-- Polymorph (Serpent)
	[GetSpellInfo(33786)] 	= false, 	-- Cyclone
	[GetSpellInfo(5782)] 	= false, 	-- Fear
	[GetSpellInfo(2094)] 	= false, 	-- Blind
	[GetSpellInfo(51514)] 	= false, 	-- Hex
	[GetSpellInfo(5246)] 	= false,	-- Intimidating Shout
	[GetSpellInfo(65543)] 	= false,	-- Psychic Scream
	[GetSpellInfo(60192)]	= false,	-- Freezing Trap
	[GetSpellInfo(19386)]	= false,	-- Wyvern Sting
	[GetSpellInfo(6358)]	= false,	-- Seduction
	[GetSpellInfo(710)]		= false,	-- Banish
	[GetSpellInfo(2637)]	= false,	-- Hibernate
	
	-- Def Skills
	[GetSpellInfo(22812)] 	= true, 	-- Barkskin
	[GetSpellInfo(871)] 	= true, 	-- Shield Wall
	[GetSpellInfo(5277)] 	= true, 	-- Evasion
	[GetSpellInfo(74001)] 	= true, 	-- Combat Readiness
	[GetSpellInfo(33206)]	= true,		-- Pain Suppression
	[GetSpellInfo(48707)]	= true,		-- Anti-Magic Shell
	[GetSpellInfo(19263)]	= true,		-- Deterrence
	[GetSpellInfo(31224)]	= true,		-- Cloak of Shadows
}

if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	dStuff.drinkannouncement = C["pvp"].drinkannouncement
	dStuff.ccannouncement = C["pvp"].ccannouncement
	dStuff.sayinterrupt = C["pvp"].sayinterrupt
end