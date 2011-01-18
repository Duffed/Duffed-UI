--[[
	
	Filger
	Copyright (c) 2009, Nils Ruesch
	All rights reserved.
	Edited by Duffed & Karudon, thanks.
	
]]
local configmode = false


local gsi = GetSpellInfo
local spells = {
	["DRUID"] = {
		{
			Name = "Target",
			Richtung = "UP",
			Abstand = 7,
			Mode = "BAR",
			
			-- cat
			{ spellName = gsi(33876) or "Mangle", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(2637) or "Hibernate", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			-- bear
			{ spellName = gsi(33876) or "Mangle", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(1822) or "Rake", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(1079) or "Rip", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(22570) or "Maim", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(339) or "Entangling Roots", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(33786) or "Cyclone", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(770) or "Faerie Fire", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(16857) or "Faerie Fire (Feral)", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(76807) or "Lacerate", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(58855) or "Growl", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(99) or "Demoralizing Roar", size = 18, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(8921) or "Moonfire", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(33763) or "Lifebloom", size = 18, scale = 1, unitId = "target", caster = "player", filter = "BUFF", barWidth = 189 },
			{ spellName = gsi(8936) or "Regrowth", size = 18, scale = 1, unitId = "target", caster = "player", filter = "BUFF", barWidth = 189 },
			{ spellName = gsi(774) or "Rejuvenation", size = 18, scale = 1, unitId = "target", caster = "player", filter = "BUFF", barWidth = 189 },
			--{ spellName = "Abolish Poison", size = 18, scale = 1, unitId = "target", caster = "player", filter = "BUFF", barWidth = 189 },
			{ spellName = gsi(5570) or "Insect Swarm", size = 18, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 189 },
			{ spellName = gsi(48438) or "Wildgrowth", size = 18, scale = 1, unitId = "target", caster = "player", filter = "BUFF", barWidth = 189 },
		},
		{
			Name = "Buffs",
			Richtung = "UP",
			Abstand = 7,
			Mode = "ICON",
			
			{ spellName = gsi(5217) or "Tiger's Fury", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 190 },
			{ spellName = gsi(52610) or "Savage Roar", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 200 },
			{ spellName = gsi(50334) or "Berserk", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			{ spellName = gsi(29166) or "Innervate", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			{ spellName = gsi(94447) or "Lifebloom", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			{ spellName = gsi(8936) or "Regrowth", size =60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			{ spellName = gsi(774) or "Rejuvenation", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			--{ spellName = "Abolish Poison", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
			{ spellName = gsi(48438) or "Wildgrowth", size = 60, scale = 1, unitId = "player", caster = "player", filter = "BUFF", barWidth = 146.5 },
		},
	},
	["WARRIOR"] = {
		{
			Name = "CDs",
			Richtung = "RIGHT",
			Abstand = 7,
			Mode = "ICON",
			{ spellName = "Tödlicher Stoß", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = "Entwaffnen", size = 28.1, scale = 1, filter = "CD" },
			
		},

		{
			Name = "Verwunden",
			Richtung = "RIGHT",
			Abstand = 3,
			Mode = "ICON",
			
			{ spellName = "Verwunden", size = 38, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF"},
			{ spellName = "Rend", size = 38, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "Debuffs",
			Richtung = "DOWN",
			Abstand = 3,
			Mode = "BAR",
			
			{ spellName = "Rüstung zerreißen", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Donnerknall", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Demoralisierender Ruf", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Kniesehne", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Durchdringendes Heulen", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Zerschmetternder Wurf", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
		},
		{
			Name = "Buffs",
			Richtung = "DOWN",
			Abstand = 7,
			Mode = "BAR",
			--{ spellName = "Schlachtruf", size = 14, scale = 1, unitId = "player", caster = "all", filter = "BUFF", barWidth = 131 },
			{ spellName = "Schlachtruf", displayName = "", size = 15, scale = 1, unitId = "player", caster = "all", filter = "BUFF", barWidth = 122},
			{ spellName = "Befehlsruf", displayName = "",size =  15, scale = 1, unitId = "player", caster = "all", filter = "BUFF", barWidth = 122},
		},
		{
			Name = "Charge",
			Richtung = "RIGHT",
			Abstand = 7,
			Mode = "ICON",
			
			{ spellName = "Abfangen", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = "Sturmangriff", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = "Einschreiten", size = 28.1, scale = 1, filter = "CD" },
		},
		-- {
			-- Name = "Proccs",
			-- Richtung = "RIGHT",
			-- Abstand = 12,
			-- Mode = "ICON",
			
			-- { spellName = "Verlangen nach Blut", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Plötzlicher Tod", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Schwert und Schild", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Glyphe 'Rache'", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Zerschmettern!", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
		-- },
			{
			Name = "ICC",
			Richtung = "RIGHT",
			Abstand = 12,
			Mode = "ICON",
			
			{ spellName = "Mystischer Puffer", size = 40, scale = 1, unitId = "player", caster = "target", filter = "DEBUFF",},
		},
	},
	["WARLOCK"] = {
		{
			Name = "All",
			Richtung = "DOWN",
			Abstand = 0,
			Mode = "BAR",
			
			{ spellName = "Feuerbrand", size = 18, scale = 1, unitId = "target", caster = 1, filter = "DEBUFF", barWidth = 201.5 },
			{ spellName = "Verderbnis", size = 18, scale = 1, unitId = "target", caster = 1, filter = "DEBUFF", barWidth = 201.5 },
			{ spellName = "Fluch der Pein", size = 18, scale = 1, unitId = "target", caster = 1, filter = "DEBUFF", barWidth = 201.5 },
			{ spellName = "Fluch der Elemente", size = 18, scale = 1, unitId = "target", caster = 1, filter = "DEBUFF", barWidth = 201.5 },
			{ spellName = "Lebensentzug", size = 18, scale = 1, unitId = "target", caster = 1, filter = "DEBUFF", barWidth = 201.5 },
		},
		-- {
			-- Name = "Proc",
			-- Richtung = "UP",
			-- Abstand = 3,
			-- Mode = "ICON",
			
			-- { spellName = "Schattentrance", size = 32, scale = 1.5, unitId = "player", caster = 1, filter = "BUFF" },
		-- },
	},
	["HUNTER"] = {
		{
			Name = "CC",
			Richtung = "RIGHT",
			Abstand = 3,
			Mode = "ICON",
			
			{ spellName = gsi(19503) or "Scatter Shot", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(60192) or "Freezing Trap", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(65877) or "Wyvern Sting", size = 28.1, scale = 1, filter = "CD" },
		},
		{
			Name = "Dmg",
			Richtung = "RIGHT",
			Abstand = 3,
			Mode = "ICON",
			
			{ spellName = gsi(82928) or "Aimed Shot!", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(53301) or "Explosive Shot", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(53351) or "Kill Shot", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(2643) or "Multi Shot", size = 28.1, scale = 1, filter = "CD" },
			{ spellName = gsi(53209) or "Chimera Shot", size = 28.1, scale = 1, filter = "CD" },
		},
		{
			Name = "Debuffs",
			Richtung = "DOWN",
			Abstand = 1,
			Mode = "BAR",
			
			{ spellName = gsi(82654) or "Widow Venom", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = gsi(3674) or "Black Arrow", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = gsi(1978) or "Serpent Sting", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = gsi(2974) or "Wing Clip", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
		},
	},
	["MAGE"] = {
		-- {
			-- Name = "Proccs",
			-- Richtung = "RIGHT",
			-- Abstand = 12,
			-- Mode = "ICON",
			
			-- { spellName = "Feuerteufel", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Einschlag", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Eisige Finger", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Geschosssalve", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Kampfeshitze", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
			-- { spellName = "Feuerball!", size = 58, scale = 1, unitId = "player", caster = "player", filter = "BUFF",},
		-- },
		{
			Name = "Debuff",
			Richtung = "RIGHT",
			Abstand = 3,
			Mode = "ICON",
			
			{ spellName = "Arkanschlag", size = 38, scale = 1, unitId = "player", caster = "player", filter = "DEBUFF"},
		},
		{
			Name = "Bombe",
			Richtung = "RIGHT",
			Abstand = 7,
			Mode = "ICON",
			
			{ spellName = "Lebende Bombe", size = 38, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF"},
			{ spellName = "Verbessertes Versengen", size = 38, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF"},
			-- { spellName = "Frostfeuerblitz", size = 38, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF"},
			{ spellName = "Meister der Schatten", size = 38, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF"},
		},
		{
			Name = "PVP",
			Richtung = "RIGHT",
			Abstand = 7,
			Mode = "ICON",
			
			{ spellName = "Zauberreflexion", size = 70, scale = 1, unitId = "target", caster = "all", filter = "BUFF"},
			--{ spellName = "Baumrinde", size = 70, scale = 1, unitId = "target", caster = "all", filter = "BUFF"},
			--{ spellName = "Eisbarriere", size = 70, scale = 1, unitId = "target", caster = "all", filter = "BUFF"},
			--{ spellName = "Kampfrausch", size = 70, scale = 1, unitId = "target", caster = "all", filter = "BUFF"},
		},
	},
	["ROGUE"] = {
		{
			Name = "Dots",
			Richtung = "DOWN",
			Abstand = 3,
			Mode = "BAR",
			
			{ spellName = "Verkrüppelndes Gift", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Gedankenbenebelndes Gift", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Tödliches Gift", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Tödlicher Wurf", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Zerlegen", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Vendetta", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Blutung", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
		},	
		{
			Name = "Stuns",
			Richtung = "DOWN",
			Abstand = 3,
			Mode = "BAR",
			
			{ spellName = "Solarplexus", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Kopfnuss", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Blenden", size = 16, scale = 1, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Fieser Trick", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Nierenhieb", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
			{ spellName = "Erdrosseln", size = 16, scale = 1, unitId = "target", caster = "player", filter = "DEBUFF", barWidth = 146.5 },
		},	
		{
			Name = "Wolke",
			Richtung = "UP",
			Abstand = 7,
			Mode = "ICON",
			
			{ spellName = "Rauchbombe", size = 38, scale = 1, unitId = "player", caster = "all", filter = "DEBUFF"},
		},
	},
};

local class = select(2, UnitClass("player"));
local active, bars = {}, {};


local time, Update;
local function OnUpdate(self, elapsed)
	time = self.filter == "CD" and self.expirationTime+self.duration-GetTime() or self.expirationTime-GetTime();
	if ( self:GetParent().Mode == "BAR" ) then
		self.statusbar:SetValue(time);
		--self.time:SetFormattedText(time >= 60 and "%d"..minuten or ( time >= 10 and "%d"..sekunden or "%.1f"..sekunden ), time);
		self.time:SetFormattedText(SecondsToTimeAbbrev(time));
	end
	if ( time < 0 and self.filter == "CD" ) then
		local id = self:GetParent().Id;
		for index, value in ipairs(active[id]) do
			if ( self.spellName == value.data.spellName ) then
				tremove(active[id], index);
				break;
			end
		end
		self:SetScript("OnUpdate", nil);
		Update(self:GetParent());
	end
end

---------- Cross in the Middle
local f = CreateFrame("Frame", nil)
f:ClearAllPoints()
f:SetFrameStrata("BACKGROUND")
f:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "", insets = { left = 0, right = 0, top = 0, bottom = 0 }});
f:SetPoint("CENTER",UiParent,"CENTER")
f:SetHeight(2000)
f:SetWidth(1)

f:Hide()

local d = CreateFrame("Frame", nil)
d:ClearAllPoints()
d:SetFrameStrata("BACKGROUND")
d:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "", insets = { left = 0, right = 0, top = 0, bottom = 0 }});
d:SetPoint("CENTER",UiParent,"CENTER")
d:SetHeight(1)
d:SetWidth(2000)

d:Hide()
---------- Cross in the Middle



function Update(self)
	local id = self.Id;
	if ( not bars[id] ) then
		bars[id] = {};
	end
	for index, value in ipairs(bars[id]) do
		value:Hide();
	end
	local bar;
	for index, value in ipairs(active[id]) do
		bar = bars[id][index];
		if ( not bar ) then
			bar = CreateFrame("Frame", "FilgerAnker"..id.."Frame"..index, self);
			bar:SetWidth(value.data.size);
			bar:SetHeight(value.data.size);
			bar:SetScale(value.data.scale);
			if ( index == 1 ) then
				if ( configmode ) then
					bar:SetFrameStrata("BACKGROUND");
					
				end
				if ( self.Richtung == "UP" ) then
					bar:SetPoint("BOTTOM", self);
				elseif ( self.Richtung == "RIGHT" ) then
					bar:SetPoint("LEFT", self);
				elseif ( self.Richtung == "LEFT" ) then
					bar:SetPoint("RIGHT", self);
				else
					bar:SetPoint("TOP", self);
				end
			else
				if ( self.Richtung == "UP" ) then
					bar:SetPoint("BOTTOM", bars[id][index-1], "TOP", 0, self.Abstand);
				elseif ( self.Richtung == "RIGHT" ) then
					bar:SetPoint("LEFT", bars[id][index-1], "RIGHT", self.Mode == "ICON" and self.Abstand or value.data.barWidth+self.Abstand, 0);
				elseif ( self.Richtung == "LEFT" ) then
					bar:SetPoint("RIGHT", bars[id][index-1], "LEFT", self.Mode == "ICON" and -self.Abstand or -(value.data.barWidth+self.Abstand), 0);
				else
					bar:SetPoint("TOP", bars[id][index-1], "BOTTOM", 0, -self.Abstand);
				end
			end
			if ( self.Mode == "ICON" ) then
				bar.icon = bar:CreateTexture("$parentIcon", "BACKGROUND");
				bar.icon:SetAllPoints();
				bar.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
				
				bar.count = bar:CreateFontString(nil, "ARTWORK", "NumberFontNormal");
				bar.count:SetPoint("TOPRIGHT", -1, -1);
				bar.count:SetJustifyH("RIGHT");
				
				bar.cooldown = CreateFrame("Cooldown", nil, bar, "CooldownFrameTemplate");
				bar.cooldown:SetAllPoints();
				bar.cooldown:SetReverse();
				
				--bar.overlay = bar:CreateTexture(nil, "OVERLEY");
				--bar.overlay:SetTexture("Interface\\AddOns\\Filger\\Textures\\border");
				--bar.overlay:SetPoint("TOPLEFT", -3, 3);
				--bar.overlay:SetPoint("BOTTOMRIGHT", 3, -3);
				--bar.overlay:SetVertexColor(0.3, 0.3, 0.3);
				
				bar.overlay = CreateFrame("Frame",nil,bar)
				bar.overlay:ClearAllPoints()
				bar.overlay:SetFrameStrata("BACKGROUND")
				bar.overlay:SetPoint("TOPLEFT",bar.overlay:GetParent(),"TOPLEFT",-2,2)
				bar.overlay:SetPoint("BOTTOMRIGHT",bar.overlay:GetParent(),"BOTTOMRIGHT",2,-2)
				TukuiDB.SetTemplate(bar.overlay)
							
			else
			
                --[[ style of Bars ]]--
				bar.icon = bar:CreateTexture(nil, "BACKGROUND");
                bar.icon:SetAllPoints();
				bar.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
                bar.icon:ClearAllPoints()
                bar.icon:SetPoint("left",bar,"left",-7,0)
                bar.icon:SetHeight(value.data.size)
                bar.icon:SetWidth(value.data.size)
                
                --[[ edit style of the ICONBAR ]]--
                bar.overlay = CreateFrame("Frame",nil,bar)
				bar.overlay:ClearAllPoints()
				bar.overlay:SetFrameStrata("BACKGROUND")
				bar.overlay:SetPoint("TOPLEFT",bar.icon,"TOPLEFT",-2,2)
				bar.overlay:SetPoint("BOTTOMRIGHT",bar.icon,"BOTTOMRIGHT",2,-2)
				TukuiDB.SetTemplate(bar.overlay)
                bar.overlay:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))

                --[[ edit end ]]--
                
                --[[ count like blooming life ]]--
				bar.count = bar:CreateFontString(nil, "ARTWORK", "NumberFontNormal");
				bar.count:SetPoint("BOTTOMRIGHT",-10,0);
				bar.count:SetJustifyH("RIGHT");
				bar.statusbar = CreateFrame("StatusBar", nil, bar);
				if ( configmode ) then
					bar.statusbar:SetFrameStrata("BACKGROUND");
				end
				
               --[[ statusbar height and Width and statusbar ]]--
               bar.statusbar:SetWidth(value.data.barWidth or 200);
               bar.statusbar:SetHeight(value.data.size);
               bar.statusbar:SetStatusBarTexture("Interface\\AddOns\\Filger\\Textures\\statusbar");
               
               
               --[[ edit style of the bar ]]--
               local overlay = CreateFrame("Frame", "Ileft", bar.statusbar)
               TukuiDB.CreatePanel(overlay,-1,1, "center", bar.statusbar, "center", 0, 0)
               overlay:SetPoint("TOPLEFT",bar.statusbar,"TOPLEFT",-2,2)
               overlay:SetPoint("BOTTOMRIGHT",bar.statusbar,"BOTTOMRIGHT",2,-2)
               overlay:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
                --[[ edit end ]]--

                --[[ Bar config ]]--		
				if TukuiCF["duffed"]["filgerbarcolor"].classcolor == true then
					local class = select(2, UnitClass("player"));
					if class == "DEATHKNIGHT" then
						bar.statusbar:SetStatusBarColor(196/255,  30/255,  60/255 )
					elseif class == "DRUID" then
						bar.statusbar:SetStatusBarColor(255/255, 125/255,  10/255 )
					elseif class == "HUNTER" then
						bar.statusbar:SetStatusBarColor(171/255, 214/255, 116/255 )
					elseif class == "MAGE" then
						bar.statusbar:SetStatusBarColor(104/255, 205/255, 255/255 )
					elseif class == "PALADIN" then
						bar.statusbar:SetStatusBarColor(245/255, 140/255, 186/255 )
					elseif class == "PRIEST" then
						bar.statusbar:SetStatusBarColor(212/255, 212/255, 212/255 )
					elseif class == "ROGUE" then
						bar.statusbar:SetStatusBarColor(255/255, 243/255,  82/255 )
					elseif class == "SHAMAN" then
						bar.statusbar:SetStatusBarColor(41/255, 79/255, 155/255 )
					elseif class == "WARLOCK" then
						bar.statusbar:SetStatusBarColor(148/255, 130/255, 201/255 )
					elseif class == "WARRIOR" then
						bar.statusbar:SetStatusBarColor(194/255, 151/255, 105/255 )
					end
				else
					bar.statusbar:SetStatusBarColor(unpack(TukuiCF["duffed"]["filgerbarcolor"].color))
				end
			
				bar.statusbar:SetPoint("LEFT", bar, "RIGHT");
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(0);
				bar.statusbar.background = bar.statusbar:CreateTexture(nil, "BACKGROUND");
				bar.statusbar.background:SetAllPoints();
				bar.statusbar.background:SetTexture("Interface\\AddOns\\Filger\\Textures\\statusbar");
				bar.statusbar.background:SetVertexColor(0,0,0, 0);
                

				--[[ Time ]]--
				bar.time = bar.statusbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightRight");
				bar.time:SetPoint("RIGHT", bar.statusbar, -2, 1);
				
                --[[ Spellname ]]--
				bar.spellname = bar.statusbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
				bar.spellname:SetPoint("LEFT", bar.statusbar, 2, 1);
				bar.spellname:SetPoint("RIGHT", bar.time, "LEFT");
				bar.spellname:SetJustifyH("CENTER");
			end
			
			tinsert(bars[id], bar);
		end
		
		bar.spellName = value.data.spellName;
		
		bar.icon:SetTexture(value.icon);
		bar.count:SetText(value.count > 1 and value.count or "");
		if ( self.Mode == "BAR" ) then
			bar.spellname:SetText(value.data.displayName or value.data.spellName);
		end
		if ( value.duration > 0 ) then
			if ( self.Mode == "ICON" ) then
				CooldownFrame_SetTimer(bar.cooldown, value.data.filter == "CD" and value.expirationTime or value.expirationTime-value.duration, value.duration, 1);
				if ( value.data.filter == "CD" ) then
					bar.expirationTime = value.expirationTime;
					bar.duration = value.duration;
					bar.filter = value.data.filter;
					bar:SetScript("OnUpdate", OnUpdate);
				end
			else
				bar.statusbar:SetMinMaxValues(0, value.duration);
				bar.expirationTime = value.expirationTime;
				bar.duration = value.duration;
				bar.filter = value.data.filter;
				bar:SetScript("OnUpdate", OnUpdate);
			end
		else
			if ( self.Mode == "ICON" ) then
				bar.cooldown:Hide();
			else
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(1);
				bar.time:SetText("");
				bar:SetScript("OnUpdate", nil);
			end
		end
		
		bar:Show();
	end
end

local function OnEvent(self, event, ...)
	local unit = ...;
	if ( ( unit == "target" or unit == "player" ) or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "SPELL_UPDATE_COOLDOWN" ) then
		local data, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, start, enabled, slotLink;
		local id = self.Id;
		for i=1, #spells[class][id], 1 do
			data = spells[class][id][i];
			if ( data.filter == "BUFF" ) then
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff(data.unitId, data.spellName);
			elseif ( data.filter == "DEBUFF" ) then
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitDebuff(data.unitId, data.spellName);
			else
				if ( type(data.spellName) == "string" ) then
					start, duration, enabled = GetSpellCooldown(data.spellName);
					icon = GetSpellTexture(data.spellName);
				else
					slotLink = GetInventoryItemLink("player", data.spellName);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink);
						if ( not data.displayName ) then
							data.displayName = name;
						end
						start, duration, enabled = GetInventoryItemCooldown("player", data.spellName);
					end
				end
				count = 0;
				caster = "all";
			end
			if ( not active[id] ) then
				active[id] = {};
			end
			for index, value in ipairs(active[id]) do
				if ( data.spellName == value.data.spellName ) then
					tremove(active[id], index);
					break;
				end
			end
			if ( ( name and ( caster == data.caster or data.caster == "all" ) ) or ( ( enabled or 0 ) > 0 and ( duration or 0 ) > 1.5 ) ) then
				table.insert(active[id], { data = data, icon = icon, count = count, duration = duration, expirationTime = expirationTime or start });
			end
		end
		Update(self);
	end
end

if ( spells and spells[class] ) then
	for index in pairs(spells) do
		if ( index ~= class ) then
			spells[index] = nil;
		end
	end
	local data, frame;
	for i=1, #spells[class], 1 do
		data = spells[class][i];
		
		frame = CreateFrame("Frame", "FilgerAnker"..i, UIParent);
		frame.Id = i;
		frame.Richtung = data.Richtung or "DOWN";
		frame.Abstand = data.Abstand or 3;
		frame.Mode = data.Mode or "ICON";
		frame:SetWidth(spells[class][i][1] and spells[class][i][1].size or 100);
		frame:SetHeight(spells[class][i][1] and spells[class][i][1].size or 20);
		frame:SetPoint("CENTER");
		frame:SetMovable(1);
		
		if configmode == true then
			
			f:Show();
			d:Show();
			
			frame:SetFrameStrata("DIALOG");
			frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "", insets = { left = 0, right = 0, top = 0, bottom = 0 }});
			frame:EnableMouse(1);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", function(self)
				if ( IsShiftKeyDown() and IsAltKeyDown() ) then
					self:StartMoving();
				end
			end);
			frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing();
			end);
			
			frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightCenter");
			frame.text:SetPoint("CENTER");
			frame.text:SetText(data.Name and data.Name or "FilgerAnker"..i);
			
			for j=1, #spells[class][i], 1 do
				data = spells[class][i][j];
				if ( not active[i] ) then
					active[i] = {};
				end
				table.insert(active[i], { data = data, icon = "Interface\\Icons\\temp", count = 9, duration = 0, expirationTime = 0 });
			end
			Update(frame);
		else
			for j=1, #spells[class][i], 1 do
				data = spells[class][i][j];
				if ( data.filter == "CD" ) then
					frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
					break;
				end
			end
			frame:RegisterEvent("UNIT_AURA");
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			frame:SetScript("OnEvent", OnEvent);
		end
	end
end
