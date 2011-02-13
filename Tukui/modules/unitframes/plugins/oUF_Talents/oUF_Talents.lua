local _, ns = ...
local oUF = ns.oUF or oUF

if not oUF then return end

local spells =  {
		-- WARRIOR
		[GetSpellInfo(12294)]	= "Arms",			-- Mortal Strike
		[GetSpellInfo(46924)]	= "Arms",			-- Bladestorm
		[GetSpellInfo(23881)]	= "Fury",			-- Bloodthirst
		[GetSpellInfo(12809)]	= "Protection",		-- Concussion Blow
		--[GetSpellInfo(47498)]	= "Protection",		-- Devastate
		-- PALADIN
		[GetSpellInfo(31935)]	= "Protection",		-- Avenger's Shield
		[GetSpellInfo(20473)]	= "Holy",			-- Holy Shock
		[GetSpellInfo(35395)]	= "Retribution",		-- Crusader Strike
		[GetSpellInfo(53385)]	= "Retribution",		-- Divine Storm
		[GetSpellInfo(20066)]	= "Retribution",		-- Repentance
		-- ROGUE
		[GetSpellInfo(1329)]	= "Assassination",	-- Mutilate
		[GetSpellInfo(51690)]	= "Combat",			-- Killing Spree
		[GetSpellInfo(13877)]	= "Combat",			-- Blade Flurry
		[GetSpellInfo(13750)]	= "Combat",			-- Adrenaline Rush
		[GetSpellInfo(16511)]	= "Subtlety",		-- Hemorrhage
		-- PRIEST
		[GetSpellInfo(47540)]	= "Discipline",		-- Penance
		[GetSpellInfo(10060)]	= "Discipline",		-- Power Infusion
		[GetSpellInfo(33206)]	= "Discipline",		-- Pain Suppression
		[GetSpellInfo(34861)]	= "Holy",			-- Circle of Healing
		[GetSpellInfo(724)]		= "Holy",			-- Lightwell
		[GetSpellInfo(15487)]	= "Shadow",			-- Silence
		[GetSpellInfo(34914)]	= "Shadow",			-- Vampiric Touch	
		-- DEATHKNIGHT
		[GetSpellInfo(45902)]	= "Blood",			-- Heart Strike
		[GetSpellInfo(49203)]	= "Frost",			-- Hungering Cold
		[GetSpellInfo(49143)]	= "Frost",			-- Frost Strike
		[GetSpellInfo(49184)]	= "Frost",			-- Howling Blast
		[GetSpellInfo(55090)]	= "Unholy",			-- Scourge Strike
		-- MAGE
		[GetSpellInfo(44425)]	= "Arcane",			-- Arcane Barrage
		[GetSpellInfo(44457)]	= "Fire",			-- Living Bomb
		[GetSpellInfo(31661)]	= "Fire",			-- Dragon's Breath
		[GetSpellInfo(11113)]	= "Fire",			-- Blast Wave
		[GetSpellInfo(44572)]	= "Frost",			-- Deep Freeze
		-- WARLOCK
		[GetSpellInfo(48181)]	= "Affliction",		-- Haunt
		[GetSpellInfo(30108)]	= "Affliction",		-- Unstable Affliction
		[GetSpellInfo(59672)]	= "Demonology",		-- Metamorphosis
		[GetSpellInfo(50769)]	= "Destruction",		-- Chaos Bolt
		[GetSpellInfo(30283)]	= "Destruction",		-- Shadowfury
		-- SHAMAN
		[GetSpellInfo(51490)]	= "Elemental",		-- Thunderstorm
		[GetSpellInfo(16166)]	= "Elemental",		-- Elemental Mastery
		[GetSpellInfo(51533)]	= "Enhancement",		-- Feral Spirit
		[GetSpellInfo(30823)]	= "Enhancement",		-- Shamanistic Rage
		[GetSpellInfo(17364)]	= "Enhancement",		-- Stormstrike
		[GetSpellInfo(61295)]	= "Restoration",		-- Riptide
		[GetSpellInfo(51886)]	= "Restoration",		-- Cleanse Spirit
		-- HUNTER
		[GetSpellInfo(19577)]	= "Beast Mastery",	-- Intimidation
		[GetSpellInfo(34490)]	= "Marksmanship",	-- Silencing Shot
		[GetSpellInfo(53209)]	= "Marksmanship",	-- Chimera Shot
		[GetSpellInfo(53301)]	= "Survival",		-- Explosive Shot
		[GetSpellInfo(19386)]	= "Survival",		-- Wyvern Sting
		-- DRUID
		[GetSpellInfo(48505)]	= "Balance",			-- Starfall
		[GetSpellInfo(50516)]	= "Balance",			-- Typhoon
		[GetSpellInfo(33876)]	= "Feral",			-- Mangle (Cat)
		[GetSpellInfo(33878)]	= "Feral",			-- Mangle (Bear)
		[GetSpellInfo(18562)]	= "Restoration",		-- Swiftmend
}

local buffs = { -- credits Proditor, Rinu
		-- WARRIOR
		[GetSpellInfo(56638)]	= "Arms",			-- Taste for Blood
		[GetSpellInfo(64976)]	= "Arms",			-- Juggernaut
		[GetSpellInfo(29801)]	= "Fury",			-- Rampage
		[GetSpellInfo(50227)]	= "Protection",		-- Sword and Board
		-- PALADIN
		[GetSpellInfo(68020)]	= "Retribution",	-- If you are using Seal of Command, I hate you so much (NEEDS REVISION)
		--[GetSpellInfo()]		= "Holy",			-- WE NEED A NEW HOLY PALADIN BUFF!
		-- ROGUE
		[GetSpellInfo(36554)]	= "Subtlety",		-- Shadowstep
		[GetSpellInfo(31223)]	= "Subtlety",		-- Master of Subtlety
		-- PRIEST
		[GetSpellInfo(47788)]	= "Holy",			-- Guardian Spirit
		[GetSpellInfo(52795)]	= "Discipline",		-- Borrowed Time
		[GetSpellInfo(15473)]	= "Shadow",			-- Shadowform
		[GetSpellInfo(15286)]	= "Shadow",			-- Vampiric Embrace
		-- DEATHKNIGHT
		[GetSpellInfo(49222)]	= "Unholy",			-- Bone Shield
		[GetSpellInfo(49016)]	= "Blood",			-- Hysteria
		[GetSpellInfo(53138)]	= "Blood",			-- Abomination's Might
		[GetSpellInfo(55610)]	= "Frost",			-- Imp. Icy Talons
		-- MAGE
		[GetSpellInfo(11426)]	= "Frost",			-- Ice Barrier
		[GetSpellInfo(11129)]	= "Fire",			-- Combustion
		[GetSpellInfo(31583)]	= "Arcane",			-- Arcane Empowerment
		-- WARLOCK
		[GetSpellInfo(30299)]	= "Destruction",		-- Nether Protection
		-- SHAMAN
		[GetSpellInfo(974)]	= "Restoration",		-- Earth Shield
		[GetSpellInfo(51470)]	= "Elemental",		-- Elemental Oath
		[GetSpellInfo(30802)]	= "Enhancement",		-- Unleashed Rage
		-- HUNTER
		[GetSpellInfo(20895)]	= "Beast Mastery",	-- Spirit Bond
		[GetSpellInfo(19506)]	= "Marksmanship",	-- Trueshot Aura
		-- DRUID
		[GetSpellInfo(24932)]	= "Feral",			-- Leader of the Pack
		[GetSpellInfo(33891)]	= "Restoration",		-- Tree of Life
		[GetSpellInfo(24907)]	= "Balance",			-- Moonkin Aura
		[GetSpellInfo(48438)]	= "Restoration",		-- Wild Growth
}

local function Update(object, event, unit)
  if object.unit ~= unit or unit == "player" or unit:find("pet") then return end
  object.Talents:SetText("")
  for index=1, 40 do
     local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, "HELPFUL")
     if name ~= nil and unitCaster==unit then
        if buffs[name] then
           object.Talents:SetText(buffs[name])
           return
        end
     end
  end
  local spell = select(1, UnitCastingInfo(unit))
  if spell then
     if spells[spell] then
        object.Talents:SetText(spells[spell])
        return
     end
  end
end

local function Enable(object)
	if not object.Talents then return end
	object:RegisterEvent("UNIT_AURA", Update)
	object:RegisterEvent("UNIT_SPELLCAST_START", Update)
	return true
end

local function Disable(object)
	if object.Talents then
		object:UnregisterEvent("UNIT_AURA", Update)
		object:UnregisterEvent("UNIT_SPELLCAST_START", Update)
	end
end

oUF:AddElement("Talents", Update, Enable, Disable)
for i, frame in ipairs(oUF.objects) do Enable(frame) end