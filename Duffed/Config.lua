dStuff = {						-- true/false
	ccannouncement = true,		-- Announce CC/Buffs/Debuffs
	drinkannouncement = true,	-- drink announcement for arena
	sayinterrupt = true,		-- Announce interrupt in /p or /ra
	priest_SoS = true,			-- Priest Soul of Strength Icon
	tbtimer = false,			-- Show Watchframe when entering tb (abuse :<)
	
	arenaonly = true,
	
	["dispelannouncement"] = {
		enable = true,			-- Announce dispels in a movable frame
		justify = "CENTER",
		fontsize = 16,
		textcolor = "|cff00ff00", -- |cff + HEX-Code
	},

	font = "Fonts\\FRIZQT__.ttf",
}

-- spelllist for the buff/debuff/spell announcement
SpellsAN = {
	aura = { -- true means you announce start and end of aura; false only start
		-- [GetSpellInfo(139)]		= false, 	-- test (renew)
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
	},
	
	-- casts that doesnt apply a buff or debuff (true/false doesnt do anything here)
	cast = {
		[GetSpellInfo(16190)]	= true, 	-- Mana Tide Totem
	},
}

-- Tukui support
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	if T.Duffed then
		dStuff.drinkannouncement = C["pvp"].drinkannouncement
		dStuff.ccannouncement = C["pvp"].ccannouncement
		dStuff.sayinterrupt = C["pvp"].sayinterrupt
		dStuff.dispelannouncement.enable = C["pvp"].dispelannouncement
		dStuff.priest_SoS = false
		dStuff.arenaonly = C["pvp"].arenaonly
	end
	dStuff.font = C.media.font
end