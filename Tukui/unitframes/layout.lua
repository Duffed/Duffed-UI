if not TukuiCF["unitframes"].enable == true then return end

------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local db = TukuiCF["unitframes"]
local font1 = TukuiCF["media"].uffont
local font2 = TukuiCF["media"].font
local normTex = TukuiCF["media"].normTex
local glowTex = TukuiCF["media"].glowTex
local bubbleTex = TukuiCF["media"].bubbleTex

local backdrop = {
	bgFile = TukuiCF["media"].blank,
	insets = {top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult},
}

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = TukuiDB.oUF_colors
	
	-- register click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = TukuiDB.SpawnMenu

	-- backdrop for every units
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, 0)
	
	-- Set Player (and target) width here to adjust a lot of things easier
	playerwidth = 220
	
	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------

	-- here we create an invisible frame for all element we want to show over health/power.
	-- because we can only use self here, and self is under all elements.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()

	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 8)
	self.RaidIcon = RaidIcon
	
	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then
		-- create a panel
		local panel = CreateFrame("Frame", nil, self)
		panel:SetHeight(17)
		panel:SetFrameLevel(1)
		panel:SetFrameStrata("BACKGROUND")
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		if TukuiDB.lowversion then
			health:SetHeight(TukuiDB.Scale(20))
		else
			health:SetHeight(TukuiDB.Scale(23))
		end
		health:SetPoint("TOPLEFT",0,TukuiDB.Scale(-16))
		health:SetPoint("TOPRIGHT",0,TukuiDB.Scale(-16))
		health:SetStatusBarTexture(normTex)
				
		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
	
		health.value = TukuiDB.SetFontString(panel, font1, 12, "THINOUTLINE")
		health.value:SetPoint("RIGHT", panel, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(0))
		health.PostUpdate = TukuiDB.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)			
		else
			health.colorTapping = true
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
			healthBG:SetTexture(.1, .1, .1)				
		end

		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:SetHeight(TukuiDB.Scale(2))
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = TukuiDB.SetFontString(panel, font1, 12,"THINOUTLINE")
		power.value:SetPoint("LEFT", panel, "LEFT", TukuiDB.Scale(4), TukuiDB.Scale(0))
		power.PreUpdate = TukuiDB.PreUpdatePower
		power.PostUpdate = TukuiDB.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if db.showsmooth == true then
			power.Smooth = true
		end
		
		if db.unicolor == true then
			power.colorTapping = true
			power.colorClass = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end

		-- Panel position
		panel:SetPoint("BOTTOMLEFT", health, "TOPLEFT", -2, 2)
		panel:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", 2, 2)
		
		-- portraits
		if (db.portraits.enable == true) then
			local portrait = CreateFrame("PlayerModel", "Player_Model", self)
			portrait:SetFrameLevel(8)
			portrait:SetWidth(55)
			portrait:SetAlpha(1)
			if unit == "player" then
				portrait:SetPoint("TOPRIGHT", panel, "TOPLEFT", TukuiDB.Scale(-5),TukuiDB.Scale(-4))
				portrait:SetPoint("BOTTOMRIGHT", power, "BOTTOMLEFT", TukuiDB.Scale(-5),0)
			elseif unit == "target" then
				portrait:SetPoint("TOPLEFT", panel, "TOPRIGHT", TukuiDB.Scale(5),TukuiDB.Scale(-4))
				portrait:SetPoint("BOTTOMLEFT", power, "BOTTOMRIGHT", TukuiDB.Scale(5),0)
			end
			-- table.insert(self.__elements, TukuiDB.HidePortrait)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			TukuiDB.CreatePanel(portrait.bg, 1,1,"BOTTOMLEFT",portrait,"BOTTOMLEFT",TukuiDB.Scale(-2),TukuiDB.Scale(-2))
			portrait.bg:SetPoint("TOPRIGHT",portrait,"TOPRIGHT",TukuiDB.Scale(2),TukuiDB.Scale(2))
			TukuiDB.CreateShadow(portrait.bg)
		end

		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1, "TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		TukuiDB.CreateShadow(health.border)
		-- self.threat = health.border.shadow
		
		-- Powerbar Border
		power.border = CreateFrame("Frame", nil, power)
		TukuiDB.CreatePanel(power.border, 1,1, "TOPLEFT", power, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		power.border:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		
		if (unit == "player") then
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", "TukuiAltPowerBar", self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:SetHeight(3)
			AltPowerBar:SetStatusBarTexture(TukuiCF.media.normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)

			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			
			AltPowerBar:SetBackdrop({
			  bgFile = TukuiCF["media"].blank, 
			  edgeFile = TukuiCF["media"].blank, 
			  tile = false, tileSize = 0, edgeSize = 1, 
			  insets = { left = 0, right = 0, top = 0, bottom = TukuiDB.Scale(-1)}
			})
			AltPowerBar:SetBackdropColor(0, 0, 0)

			self.AltPowerBar = AltPowerBar
		
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:SetHeight(TukuiDB.Scale(19))
			Combat:SetWidth(TukuiDB.Scale(19))
			Combat:SetPoint("LEFT",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "TukuiFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", TukuiDB.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetToplevel(true)
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = TukuiDB.SetFontString(FlashInfo, font1, 12, "THINOUTLINE")
			FlashInfo.ManaLevel:SetPoint("CENTER", panel, "CENTER", 0, 0)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			local status = TukuiDB.SetFontString(panel, font1, 12, "THINOUTLINE")
			status:SetPoint("CENTER", panel, "CENTER", 0, TukuiDB.Scale(0))
			status:SetTextColor(0.69, 0.31, 0.31, 0)
			self.Status = status
			self:Tag(status, "[pvp]")
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:SetHeight(TukuiDB.Scale(14))
			Leader:SetWidth(TukuiDB.Scale(14))
			Leader:SetPoint("TOPLEFT",health, TukuiDB.Scale(2), TukuiDB.Scale(8))
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
			MasterLooter:SetHeight(TukuiDB.Scale(14))
			MasterLooter:SetWidth(TukuiDB.Scale(14))
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", TukuiDB.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", TukuiDB.MLAnchorUpdate)
						
			-- the threat bar on info left panel ? :P
			if (db.showthreat == true) then
				local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', TukuiInfoLeft)
				ThreatBar:SetFrameLevel(5)
				ThreatBar:SetPoint("TOPLEFT", TukuiInfoLeft, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				ThreatBar:SetPoint("BOTTOMRIGHT", TukuiInfoLeft, TukuiDB.Scale(-2), TukuiDB.Scale(2))
			  
				ThreatBar:SetStatusBarTexture(normTex)
				ThreatBar:GetStatusBarTexture():SetHorizTile(false)
				ThreatBar:SetBackdrop(backdrop)
				ThreatBar:SetBackdropColor(0, 0, 0, 0.8)
		   
				ThreatBar.Text = TukuiDB.SetFontString(ThreatBar, font2, 12)
				ThreatBar.Text:SetPoint("RIGHT", ThreatBar, "RIGHT", TukuiDB.Scale(-30), 0)
		
				ThreatBar.Title = TukuiDB.SetFontString(ThreatBar, font2, 12)
				ThreatBar.Title:SetText(tukuilocal.unitframes_ouf_threattext)
				ThreatBar.Title:SetPoint("LEFT", ThreatBar, "LEFT", TukuiDB.Scale(30), 0)
					  
				ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
				ThreatBar.bg:SetAllPoints(ThreatBar)
				ThreatBar.bg:SetTexture(0.1,0.1,0.1)
		   
				ThreatBar.useRawThreat = false
				self.ThreatBar = ThreatBar
			end

			-- experience bar on player via mouseover for player currently levelling a character
			if TukuiDB.level ~= MAX_PLAYER_LEVEL and (db.portraits.enable == true) then
				local Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
				Experience:SetStatusBarTexture(normTex)
				Experience:SetStatusBarColor(0, 0.4, 1, .8)
				Experience:SetBackdrop(backdrop)
				Experience:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
				Experience:SetPoint("TOPLEFT", health)
				Experience:SetPoint("BOTTOMRIGHT", health)
				Experience:SetFrameLevel(10)
				Experience:SetAlpha(0)
				Player_Model:EnableMouse(true)
				Player_Model:HookScript("OnEnter", function()
						Experience:SetAlpha(1) 
				end)
				Player_Model:HookScript("OnLeave", function() Experience:SetAlpha(0) end)
				Experience.noTooltip = true
				
				local Text = Experience:CreateFontString(nil, "LOW")
				Text:SetSize(playerwidth, 18)
				Text:SetFont(TukuiCF["media"].font, 11)
				Text:SetPoint("CENTER", Experience, "CENTER", 0, -2)
				Text:SetShadowColor(0, 0, 0)
				Text:SetShadowOffset(1.25, -1.25)
				
				local function update()
					if GetXPExhaustion() ~= nil and GetXPExhaustion() > 0 then
						Text:SetText(format('|cffefefef%d/%d (%d%%) R: %.2f%%', UnitXP("player"), UnitXPMax("player"),(UnitXP("player")/UnitXPMax("player"))*100, (GetXPExhaustion()/UnitXPMax("player"))*100))
					else
						Text:SetText(format('|cffefefef%d/%d (%d%%)', UnitXP("player"), UnitXPMax("player"),(UnitXP("player")/UnitXPMax("player"))*100))
					end
				end
				self:RegisterEvent("PLAYER_ENTERING_WORLD", update)
				self:RegisterEvent("PLAYER_XP_UPDATE", update)
				self:RegisterEvent("PLAYER_LEVEL_UP", update)
				self:RegisterEvent("UPDATE_EXHAUSTION", update)
				
				-- resting icon
				local Resting = Experience:CreateTexture(nil, "OVERLAY")
				Resting:SetHeight(24)
				Resting:SetWidth(24)
				Resting:SetPoint("BOTTOM",Experience,"TOP", 0, -4)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				Resting:SetAlpha(0.8)
				self.Resting = Resting

				self.Experience = Experience
			end
			
			-- reputation bar for max level character
			if TukuiDB.level == MAX_PLAYER_LEVEL and (db.portraits.enable == true) then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:SetBackdrop(backdrop)
				Reputation:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
				Reputation:SetPoint("TOPLEFT", health)
				Reputation:SetPoint("BOTTOMRIGHT", health)
				Reputation:SetFrameLevel(10)
				Reputation:SetAlpha(0)
				Player_Model:HookScript("OnEnter", function() 
						Reputation:SetAlpha(1) 
				end)
				Player_Model:HookScript("OnLeave", function() Reputation:SetAlpha(0) end)
				
				local Text = Reputation:CreateFontString(nil, "LOW")
				Text:SetSize(playerwidth, 18)
				Text:SetFont(TukuiCF["media"].font, 12)
				Text:SetPoint("CENTER", Reputation, "CENTER", 0, -1)
				Text:SetShadowColor(0, 0, 0)
				Text:SetShadowOffset(1.25, -1.25)
				
				local function update()
					local name, standing, min, max, value = GetWatchedFactionInfo()
					if GetWatchedFactionInfo() ~= nil then
						Player_Model:EnableMouse(true)
						Text:SetText(format('%s - %s/%s (%d%%)', name, value - min, max - min, (value - min) / (max - min) * 100))
					else
						Player_Model:EnableMouse(false)
					end
				end
				self:RegisterEvent('UPDATE_FACTION', update)

				Reputation.PostUpdate = TukuiDB.UpdateReputationColor
				Reputation.Tooltip = false
				self.Reputation = Reputation
			end

			-- show druid mana when shapeshifted in bear, cat or whatever
			if TukuiDB.myclass == "DRUID" then
				CreateFrame("Frame"):SetScript("OnUpdate", function() TukuiDB.UpdateDruidMana(self) end)
				local DruidMana = TukuiDB.SetFontString(health, font1, 12, "THINOUTLINE")
				DruidMana:SetTextColor(1, 0.49, 0.04)
				self.DruidMana = DruidMana
				
				local eclipseBar = CreateFrame('Frame', nil, self)
				eclipseBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, TukuiDB.Scale(7))
				if db.portraits.enable == true then
					eclipseBar:SetSize(TukuiDB.Scale(playerwidth+62), TukuiDB.Scale(5))
				else
					eclipseBar:SetSize(TukuiDB.Scale(playerwidth), TukuiDB.Scale(5))
				end
				eclipseBar:SetFrameStrata("MEDIUM")
				eclipseBar:SetFrameLevel(8)
				TukuiDB.SetTemplate(eclipseBar)
				eclipseBar:SetBackdropBorderColor(0,0,0,0)
				eclipseBar:SetScript("OnShow", function() TukuiDB.EclipseDisplay(self, false) end)
				eclipseBar:SetScript("OnUpdate", function() TukuiDB.EclipseDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
				eclipseBar:SetScript("OnHide", function() TukuiDB.EclipseDisplay(self, false) end)
				
				local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
				lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
				lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
				lunarBar:SetStatusBarTexture(normTex)
				lunarBar:SetStatusBarColor(.30, .52, .90)
				eclipseBar.LunarBar = lunarBar

				local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
				solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
				solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
				solarBar:SetStatusBarTexture(normTex)
				solarBar:SetStatusBarColor(.80, .82,  .60)
				eclipseBar.SolarBar = solarBar

				local eclipseBarText = eclipseBar:CreateFontString(nil, 'OVERLAY')
				eclipseBarText:SetPoint('TOP', panel)
				eclipseBarText:SetPoint('BOTTOM', panel)
				eclipseBarText:SetFont(font1, 12)
				eclipseBar.PostUpdatePower = TukuiDB.EclipseDirection
				
				-- hide "low mana" text on load if eclipseBar is show
				if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end
				
				-- border
				eclipseBar.border = CreateFrame("Frame", nil,eclipseBar)
				TukuiDB.CreatePanel(eclipseBar.border,1,1,"TOPLEFT", eclipseBar, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
				eclipseBar.border:SetPoint("BOTTOMRIGHT", eclipseBar, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
				TukuiDB.CreateShadow(eclipseBar.border)

				self.EclipseBar = eclipseBar
				self.EclipseBar.Text = eclipseBarText
			end

			-- set holy power bar or shard bar
			if (TukuiDB.myclass == "WARLOCK" or TukuiDB.myclass == "PALADIN") then
				local bars = CreateFrame("Frame", nil, self)
				bars:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, TukuiDB.Scale(7))
				if db.portraits.enable == true then
					bars:SetWidth(TukuiDB.Scale(playerwidth+62))
				else
					bars:SetWidth(TukuiDB.Scale(playerwidth))
				end
				bars:SetHeight(TukuiDB.Scale(5))
				TukuiDB.SetTemplate(bars)
				bars:SetBackdropBorderColor(0,0,0,0)
				
				-- border
				bars.border = CreateFrame("Frame", nil,bars)
				TukuiDB.CreatePanel(bars.border,1,1,"TOPLEFT", bars, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
				bars.border:SetPoint("BOTTOMRIGHT", bars, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
				TukuiDB.CreateShadow(bars.border)
				
				for i = 1, 3 do					
					bars[i]=CreateFrame("StatusBar", self:GetName().."_Shard"..i, self)
					bars[i]:SetHeight(TukuiDB.Scale(5))					
					bars[i]:SetStatusBarTexture(normTex)
					bars[i]:GetStatusBarTexture():SetHorizTile(false)

					bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
					
					if TukuiDB.myclass == "WARLOCK" then
						bars[i]:SetStatusBarColor(255/255,101/255,101/255)
						bars[i].bg:SetTexture(255/255,101/255,101/255)
					elseif TukuiDB.myclass == "PALADIN" then
						bars[i]:SetStatusBarColor(228/255,225/255,16/255)
						bars[i].bg:SetTexture(228/255,225/255,16/255)
					end
					
					if i == 1 then
						bars[i]:SetPoint("LEFT", bars)
						bars[i]:SetWidth(TukuiDB.Scale(bars:GetWidth()/3)) -- setting SetWidth here just to fit fit 250 perfectly
						bars[i].bg:SetAllPoints(bars[i])
					else
						bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", TukuiDB.Scale(1), 0)
						bars[i]:SetWidth(TukuiDB.Scale(bars:GetWidth()/3)-1) -- setting SetWidth here just to fit fit 250 perfectly
						bars[i].bg:SetAllPoints(bars[i])
					end
					
					bars[i].bg:SetTexture(normTex)					
					bars[i].bg:SetAlpha(.15)
				end
				
				if TukuiDB.myclass == "WARLOCK" then
					bars.Override = TukuiDB.UpdateShards				
					self.SoulShards = bars
				elseif TukuiDB.myclass == "PALADIN" then
					bars.Override = TukuiDB.UpdateHoly
					self.HolyPower = bars
				end
			end

			-- deathknight runes
			if TukuiDB.myclass == "DEATHKNIGHT" and db.runebar == true then
				local Runes = CreateFrame("Frame", nil, self)
				Runes:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, TukuiDB.Scale(7))
				Runes:SetHeight(TukuiDB.Scale(5))
				if db.portraits.enable == true then
					Runes:SetWidth(TukuiDB.Scale(playerwidth+62))
				else
					Runes:SetWidth(TukuiDB.Scale(playerwidth))
				end
				Runes:SetBackdrop(backdrop)
				Runes:SetBackdropColor(0, 0, 0)

				-- border
				Runes.border = CreateFrame("Frame", nil,Runes)
				TukuiDB.CreatePanel(Runes.border,1,1,"TOPLEFT", Runes, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
				Runes.border:SetPoint("BOTTOMRIGHT", Runes, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
				TukuiDB.CreateShadow(Runes.border)
				
				for i = 1, 6 do
					Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
					Runes[i]:SetHeight(TukuiDB.Scale(5))
					if db.portraits.enable == true then
						Runes[i]:SetWidth(TukuiDB.Scale((playerwidth+62)-5) / 6)
					else
						Runes[i]:SetWidth(TukuiDB.Scale(playerwidth-5) / 6)
					end
					if (i == 1) then
						Runes[i]:SetPoint("LEFT", Runes.border, "LEFT", TukuiDB.Scale(2), TukuiDB.Scale(0))
					else
						Runes[i]:SetPoint("TOPLEFT", Runes[i-1], "TOPRIGHT", TukuiDB.Scale(1), 0)
					end
					Runes[i]:SetStatusBarTexture(normTex)
					Runes[i]:GetStatusBarTexture():SetHorizTile(false)
				end

				self.Runes = Runes
			end
			
			-- shaman totem bar
			if TukuiDB.myclass == "SHAMAN" and db.totemtimer == true then
				local TotemBar = {}
				TotemBar.Destroy = true
				for i = 1, 4 do
					TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
					if (i == 1) then
						if db.portraits.enable == true then
							TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -62, TukuiDB.Scale(7))
						else
							TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, TukuiDB.Scale(7))
						end
					else
					   TotemBar[i]:SetPoint("TOPLEFT", TotemBar[i-1], "TOPRIGHT", TukuiDB.Scale(3), 0)
					end
					TotemBar[i]:SetStatusBarTexture(normTex)
					TotemBar[i]:SetHeight(TukuiDB.Scale(5))
					if db.portraits.enable == true then
						TotemBar[i]:SetWidth(TukuiDB.Scale((playerwidth+62)-9) / 4)
					else
						TotemBar[i]:SetWidth(TukuiDB.Scale(playerwidth-9) / 4)
					end
					TotemBar[i]:SetBackdrop(backdrop)
					TotemBar[i]:SetBackdropColor(0, 0, 0)
					TotemBar[i]:SetMinMaxValues(0, 1)

					TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
					TotemBar[i].bg:SetAllPoints(TotemBar[i])
					TotemBar[i].bg:SetTexture(normTex)
					TotemBar[i].bg.multiplier = 0.2
					
					-- border
					TotemBar[i].border = CreateFrame("Frame", nil, TotemBar[i])
					TukuiDB.CreatePanel(TotemBar[i].border,1,1,"TOPLEFT", TotemBar[i], "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
					TotemBar[i].border:SetPoint("BOTTOMRIGHT", TotemBar[i], "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
					TukuiDB.CreateShadow(TotemBar[i].border)
				end
				self.TotemBar = TotemBar
			end
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:SetAlpha(0) 
				status:SetAlpha(1) 
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:SetAlpha(1)
				status:SetAlpha(0) 
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = TukuiDB.SetFontString(health, font1, 12, "THINOUTLINE")
			Name:SetPoint("LEFT", panel, "LEFT", TukuiDB.Scale(4), 0)
			Name:SetJustifyH("LEFT")

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name
			
			-- combo points on target
			local CPoints = {}
			CPoints.unit = PlayerFrame.unit
			for i = 1, 5 do
				CPoints[i] = health:CreateTexture(nil, "OVERLAY")
				CPoints[i]:SetHeight(TukuiDB.Scale(12))
				CPoints[i]:SetWidth(TukuiDB.Scale(12))
				CPoints[i]:SetTexture(bubbleTex)
				if i == 1 then
					if TukuiDB.lowversion then
						CPoints[i]:SetPoint("TOPRIGHT", TukuiDB.Scale(15), TukuiDB.Scale(1.5))
					else
						CPoints[i]:SetPoint("TOPLEFT", TukuiDB.Scale(-15), TukuiDB.Scale(1.5))
					end
					CPoints[i]:SetVertexColor(0.69, 0.31, 0.31)
				else
					CPoints[i]:SetPoint("TOP", CPoints[i-1], "BOTTOM", TukuiDB.Scale(1))
				end
			end
			CPoints[2]:SetVertexColor(0.69, 0.31, 0.31)
			CPoints[3]:SetVertexColor(0.65, 0.63, 0.35)
			CPoints[4]:SetVertexColor(0.65, 0.63, 0.35)
			CPoints[5]:SetVertexColor(0.33, 0.59, 0.33)
			self.CPoints = CPoints
			self:RegisterEvent("UNIT_COMBO_POINTS", TukuiDB.UpdateCPoints)
		end

		if (unit == "target" and db.targetauras) or (unit == "player" and db.playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			if (TukuiDB.myclass == "SHAMAN" or TukuiDB.myclass == "DEATHKNIGHT" or TukuiDB.myclass == "PALADIN" or TukuiDB.myclass == "WARLOCK") and (db.playerauras) and (unit == "player") then
				if unit == "player" then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 42)
				elseif unit == "target" then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 30)
				end
			else
				buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 30)
			end
			
			buffs:SetHeight(26)
			buffs:SetWidth(252)
			buffs.size = 22
			buffs.num = 9
			
			debuffs:SetHeight(26)
			debuffs:SetWidth(playerwidth+6)
			debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", -4, 1)
			debuffs.size = 22
			debuffs.num = 27
						
			buffs.spacing = 3
			buffs.initialAnchor = 'TOPLEFT'
			buffs.PostCreateIcon = TukuiDB.PostCreateAura
			buffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Buffs = buffs	
						
			debuffs.spacing = 3
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if (db.unitcastbar == true) then
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(normTex)		
			castbar:SetFrameLevel(6)
			castbar:SetHeight(TukuiDB.Scale(21))
			if unit == "player" then
				if (TukuiCF["actionbar"].bottomrows == 2) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
					castbar:SetPoint("BOTTOMLEFT", ActionBar3Background, "TOPLEFT", TukuiDB.Scale(30), TukuiDB.Scale(5))
					castbar:SetPoint("BOTTOMRIGHT", ActionBar3Background, "TOPRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(5))
				elseif (TukuiCF["actionbar"].bottomrows == 1) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
					castbar:SetPoint("TOPLEFT", ActionBar3Background, "TOPLEFT", TukuiDB.Scale(30), TukuiDB.Scale(-13))
					castbar:SetPoint("TOPRIGHT", ActionBar3Background, "TOPRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(-13))
				elseif TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
					castbar:SetPoint("BOTTOMLEFT", TukuiPetActionBarBackground1, "TOPLEFT", TukuiDB.Scale(30), TukuiDB.Scale(5))
					castbar:SetPoint("BOTTOMRIGHT", TukuiPetActionBarBackground1, "TOPRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(5))
				end
			elseif unit == "target" then
				castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0,380)
				castbar:SetHeight(TukuiDB.Scale(18))
				castbar:SetWidth(240)
			end
						
			castbar.CustomTimeText = TukuiDB.CustomCastTimeText
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.CheckCast
			castbar.PostChannelStart = TukuiDB.CheckChannel

			castbar.time = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.time:SetPoint("RIGHT", castbar, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			-- Border
			castbar.border = CreateFrame("Frame", nil, castbar)
			TukuiDB.CreatePanel(castbar.border,1,1,"TOPLEFT", castbar, "TOPLEFT", -2, 2)
			castbar.border:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2)
			TukuiDB.CreateShadow(castbar.border)
			
			if db.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				TukuiDB.SetTemplate(castbar.button)
				TukuiDB.CreateShadow(castbar.button)
				if unit == "player" then
					castbar.button:SetHeight(TukuiDB.Scale(25))
					castbar.button:SetWidth(TukuiDB.Scale(25))
					castbar.button:SetPoint("RIGHT",castbar,"LEFT", TukuiDB.Scale(-5), 0)
				elseif unit == "target" then
					castbar.button:SetHeight(TukuiDB.Scale(27))
					castbar.button:SetWidth(TukuiDB.Scale(27))
					castbar.button:SetPoint("BOTTOM", castbar, "TOP", 0, 5)
				end

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end
			
			-- cast bar latency on player
			if unit == "player" and db.cblatency == true then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(normTex)
				castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
				castbar.SafeZone = castbar.safezone
			end
			
					
			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
		
		-- add combat feedback support
		if db.combatfeedback == true then
			local CombatFeedbackText 
			if TukuiDB.lowversion then
				CombatFeedbackText = TukuiDB.SetFontString(health, font1, 12, "THINOUTLINE")
			else
				CombatFeedbackText = TukuiDB.SetFontString(health, font1, 14, "THINOUTLINE")
			end
			CombatFeedbackText:SetPoint("CENTER", 0, 0)
			CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
			self.CombatFeedbackText = CombatFeedbackText
		end
		
		if db.healcomm then
			local mhpb = CreateFrame('StatusBar', nil, self.Health)
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			mhpb:SetWidth(playerwidth)
			mhpb:SetStatusBarTexture(normTex)
			mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
			mhpb:SetMinMaxValues(0,1)

			local ohpb = CreateFrame('StatusBar', nil, self.Health)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetWidth(oUF_Tukz_player:GetWidth())
			ohpb:SetStatusBarTexture(normTex)
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				maxOverflow = 1,
			}
		end
		
		-- player aggro
		if db.playeraggro == true then
			table.insert(self.__elements, TukuiDB.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
		end
	end
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(16))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)			
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
			healthBG:SetTexture(.1, .1, .1)			
		end
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-4))
		TukuiDB.CreateShadow(health.border)
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		-- power:SetOrientation("VERTICAL")
		power:SetHeight(1)
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, (TukuiDB.Scale(-1)))
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, (TukuiDB.Scale(-1)))
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if db.showsmooth == true then
			power.Smooth = true
		end
		
		self.Power = power
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		if TukuiDB.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
			Name:SetFont(font1, 12)
		else
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
			Name:SetFont(font1, 12)
		end
		Name:SetJustifyH("CENTER")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]  [Tukui:diffcolor][level]')
		self.Name = Name
		
		if db.totdebuffs == true and TukuiDB.lowversion ~= true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 19.5
			debuffs.spacing = 3
			debuffs.num = 6

			debuffs:SetPoint("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- Lines
		if (db.totandpetlines == true) then
			line1 = CreateFrame("Frame", nil, health)
			TukuiDB.CreatePanel(line1, 20, 2, "RIGHT", health.border, "LEFT", -1, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			TukuiDB.CreatePanel(line2, 2, 14, "BOTTOM", line1, "LEFT", 0, -1)
		end
		
		-- portrait
		if (db.portraits.enable == true) and (db.portraits.totandpet == true) then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(8)
			portrait:SetWidth(21)
			portrait:SetAlpha(1)
			portrait:SetPoint("TOPLEFT", health,"TOPRIGHT",TukuiDB.Scale(7),0)
			portrait:SetPoint("BOTTOMLEFT", power,"BOTTOMRIGHT",TukuiDB.Scale(7),0)

			table.insert(self.__elements, TukuiDB.HidePortrait)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			TukuiDB.CreatePanel(portrait.bg,1,1,"BOTTOMLEFT",portrait,"BOTTOMLEFT",TukuiDB.Scale(-2),TukuiDB.Scale(-2))
			portrait.bg:SetPoint("TOPRIGHT",portrait,"TOPRIGHT",TukuiDB.Scale(2),TukuiDB.Scale(2))
			TukuiDB.CreateShadow(portrait.bg)
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(18))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
				
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
			if TukuiDB.myclass == "HUNTER" then
				health.colorHappiness = true
			end
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-4))
		TukuiDB.CreateShadow(health.border)
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		-- power:SetOrientation("VERTICAL")
		power:SetHeight(1)
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, (TukuiDB.Scale(-1)))
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, (TukuiDB.Scale(-1)))
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if db.showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
				
		self.Power = power
		self.Power.bg = powerBG
				
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		if TukuiDB.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
			Name:SetFont(font1, 12)
		else
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
			Name:SetFont(font1, 12)
		end
		Name:SetJustifyH("CENTER")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		if db.unicolor then
			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]  [Tukui:diffcolor][level]')
			self.Name = Name
		else
			self:Tag(Name, '[Tukui:namemedium]  [Tukui:diffcolor][level]')
			self.Name = Name
		end
		
		-- Lines
		if (db.totandpetlines == true) then
			line1 = CreateFrame("Frame", nil, health)
			TukuiDB.CreatePanel(line1, 20, 2, "LEFT", health.border, "RIGHT", 1, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			TukuiDB.CreatePanel(line2, 2, 14, "BOTTOM", line1, "RIGHT", 0, -1)
		end
		
		if (db.unitcastbar == true) then
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(normTex)
			
			if not TukuiDB.lowversion then
				castbar:SetFrameLevel(6)
				castbar:SetHeight(3)
				castbar:SetPoint("TOPLEFT", health, "BOTTOMLEFT", TukuiDB.Scale(0), TukuiDB.Scale(-7))
				castbar:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(0), TukuiDB.Scale(-7))
				
				castbar.CustomTimeText = TukuiDB.CustomCastTimeText
				castbar.CustomDelayText = TukuiDB.CustomCastDelayText
				castbar.PostCastStart = TukuiDB.CheckCast
				castbar.PostChannelStart = TukuiDB.CheckChannel

				castbar.time = TukuiDB.SetFontString(castbar, font1, 12)
				castbar.time:SetPoint("RIGHT", castbar, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
				castbar.time:SetTextColor(0.84, 0.75, 0.65)
				castbar.time:SetJustifyH("RIGHT")

				castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
				castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 1)
				castbar.Text:SetTextColor(0.84, 0.75, 0.65)
				
				self.Castbar = castbar
				self.Castbar.Time = castbar.time
				
				-- Healthbar Border
				castbar.border = CreateFrame("Frame", nil,castbar)
				TukuiDB.CreatePanel(castbar.border,1,1,"TOPLEFT", castbar, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.border:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))

			end
		end
		
		if (db.portraits.enable == true) and (db.portraits.totandpet == true) then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(8)
			portrait:SetWidth(21)
			portrait:SetAlpha(1)
			portrait:SetPoint("TOPRIGHT", health,"TOPLEFT",TukuiDB.Scale(-7),0)
			portrait:SetPoint("BOTTOMRIGHT", power,"BOTTOMLEFT",TukuiDB.Scale(-7),0)

			table.insert(self.__elements, TukuiDB.HidePortrait)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			TukuiDB.CreatePanel(portrait.bg,1,1,"BOTTOMLEFT",portrait,"BOTTOMLEFT",TukuiDB.Scale(-2),TukuiDB.Scale(-2))
			portrait.bg:SetPoint("TOPRIGHT",portrait,"TOPRIGHT",TukuiDB.Scale(2),TukuiDB.Scale(2))
			TukuiDB.CreateShadow(portrait.bg)
		end
		
		if db.totdebuffs == true and TukuiDB.lowversion ~= true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 19.5
			debuffs.spacing = 3
			debuffs.num = 6

			debuffs:SetPoint("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit.
		self:RegisterEvent("UNIT_PET", TukuiDB.UpdatePetInfo)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- create health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(16))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		health:GetStatusBarTexture():SetHorizTile(false)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("LEFT", health, "LEFT", TukuiDB.Scale(4), 0)
		Name:SetJustifyH("LEFT")
		Name:SetFont(font1, 12)
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
		self.Name = Name

		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		TukuiDB.CreateShadow(health.border)
		
		-- create focus debuff feature
		if db.focusdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs:SetHeight(26)
			debuffs.size = 20
			debuffs.spacing = 3
			debuffs.num = 8
			debuffs:SetWidth(debuffs:GetHeight() * debuffs.num)
						
			debuffs:SetPoint("RIGHT", self, "LEFT", -5, 0)
			debuffs.initialAnchor = "RIGHT"
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- focus castbar
		if db.unitcastbar == true then
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetHeight(TukuiDB.Scale(2))
			castbar:SetStatusBarTexture(normTex)
			castbar:SetFrameLevel(10)
			castbar:SetPoint("TOP", UIParent, "TOP", 0,-320)
			-- castbar:SetPoint("TOPRIGHT", health, "TOPRIGHT", -22, 0)	
			-- castbar:SetAlpha(0.6)
			
				-- castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0,380)
				castbar:SetHeight(TukuiDB.Scale(20))
				castbar:SetWidth(240)
				
			castbar.border = CreateFrame("Frame", nil, castbar)
			TukuiDB.CreatePanel(castbar.border,1,1,"TOPLEFT", castbar, "TOPLEFT", -2, 2)
			castbar.border:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2)
			TukuiDB.CreateShadow(castbar.border)
			
			
			castbar.border = CreateFrame("Frame", nil, castbar)
			TukuiDB.SetTemplate(castbar.border)
			castbar.border:SetPoint("TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
			castbar.border:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
			castbar.border:SetFrameLevel(10)

			castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4,0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.CheckCast
			castbar.PostChannelStart = TukuiDB.CheckChannel

			
			if db.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetHeight(TukuiDB.Scale(31))
				castbar.button:SetWidth(TukuiDB.Scale(31))
				castbar.button:SetPoint("BOTTOM", castbar, "TOP",TukuiDB.Scale(0),4)
				TukuiDB.SetTemplate(castbar.button)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(16))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		-- healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
		Name:SetFont(font1, 12)
		Name:SetJustifyH("CENTER")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		TukuiDB.CreateShadow(health.border)
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and TukuiCF["arena"].unitframes == true) or (unit and unit:find("boss%d") and db.showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(22))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints(health)

		health.value = TukuiDB.SetFontString(health, font1,12)
		health.value:SetPoint("LEFT", TukuiDB.Scale(2), 0)
		health.PostUpdate = TukuiDB.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)	
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:SetHeight(TukuiDB.Scale(2))
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if db.showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = TukuiDB.SetFontString(health, font1, 12, "OUTLINE")
		power.value:SetPoint("RIGHT", TukuiDB.Scale(-2), 0)
		power.PreUpdate = TukuiDB.PreUpdatePower
		power.PostUpdate = TukuiDB.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		TukuiDB.CreateShadow(health.border)
		
		power.border = CreateFrame("Frame", nil, power)
		TukuiDB.CreatePanel(power.border,1,1,"TOPLEFT", power, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		power.border:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font1, 12, "OUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		-- create buff at left of unit if they are boss units
		if (unit and unit:find("boss%d")) then
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(26)
			buffs:SetWidth(252)
			buffs:SetPoint("RIGHT", health, "LEFT", TukuiDB.Scale(-4), TukuiDB.Scale(-2))
			buffs.size = 26
			buffs.num = 3
			buffs.spacing = 2
			buffs.initialAnchor = 'RIGHT'
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = TukuiDB.PostCreateAura
			buffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Buffs = buffs
		end

		-- create debuff for arena units
		if (unit and unit:find("arena%d")) then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs:SetHeight(22)
			debuffs:SetWidth(200)
			debuffs:SetPoint('LEFT', health, 'RIGHT', TukuiDB.Scale(4), TukuiDB.Scale(-2))
			debuffs.size = 26
			debuffs.num = 5
			debuffs.spacing = 2
			debuffs.initialAnchor = 'LEFT'
			debuffs["growth-x"] = "RIGHT"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs	
		end
				
		-- trinket feature via trinket plugin
		if (TukuiCF.arena.unitframes) and (unit and unit:find('arena%d')) then
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:SetHeight(26)
			Trinketbg:SetWidth(26)
			Trinketbg:SetPoint("RIGHT", health, "LEFT", -6, TukuiDB.Scale(-2))				
			TukuiDB.SetTemplate(Trinketbg)
			Trinketbg:SetFrameLevel(0)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, Trinketbg)
			Trinket:SetAllPoints(Trinketbg)
			Trinket:SetPoint("TOPLEFT", Trinketbg, TukuiDB.Scale(2), TukuiDB.Scale(-2))
			Trinket:SetPoint("BOTTOMRIGHT", Trinketbg, TukuiDB.Scale(-2), TukuiDB.Scale(2))
			Trinket:SetFrameLevel(1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
		end
		
		-- Arena/Boss castbar
		if db.unitcastbar == true then
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetHeight(TukuiDB.Scale(9))
			castbar:SetStatusBarTexture(normTex)
			castbar:SetFrameLevel(10)
			castbar:SetPoint("TOPLEFT", power, "TOPLEFT", 16, -9)
			castbar:SetPoint("TOPRIGHT", power, "TOPRIGHT", 0, -9)				
			
			castbar.border = CreateFrame("Frame", nil, castbar)
			TukuiDB.CreatePanel(castbar.border,1,1,"TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
			castbar.border:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
			TukuiDB.CreateShadow(castbar.border)

			castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4,0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.CheckCast
			castbar.PostChannelStart = TukuiDB.CheckChannel

			-- if db.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				TukuiDB.CreatePanel(castbar.button, TukuiDB.Scale(13), TukuiDB.Scale(13), "BOTTOMRIGHT", castbar, "BOTTOMLEFT",TukuiDB.Scale(-5),-2)
				TukuiDB.CreateShadow(castbar.button)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			-- end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
	end			
	
	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"oUF_MainTank" or self:GetParent():GetName():match"oUF_MainAssist") then
		-- Right-click focus on maintank or mainassist units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(20))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		-- healthBG:SetTexture(.1, .1, .1)
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(db.healthbarcolor))
			healthBG:SetVertexColor(unpack(db.deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(0))
		Name:SetJustifyH("CENTER")
		Name:SetFont(font1, 12)
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- Border
		health.border = CreateFrame("Frame", nil,health)
		TukuiDB.CreatePanel(health.border,1,1,"TOPLEFT", health, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		health.border:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))	
	end

end

------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------

-- for lower reso
local adjustXY = 0
local totdebuffs = 0
if TukuiDB.lowversion then adjustXY = 24 end
if db.totdebuffs then totdebuffs = 24 end

oUF:RegisterStyle('Tukz', Shared)

-- player
local player = oUF:Spawn('player', "oUF_Tukz_player")
player:SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "TOPLEFT", 0,150)
player:SetSize(TukuiDB.Scale(playerwidth), TukuiDB.Scale(44))

-- target
local target = oUF:Spawn('target', "oUF_Tukz_target")
target:SetPoint("BOTTOMRIGHT", TukuiActionBarBackground, "TOPRIGHT", 0,150)
target:SetSize(TukuiDB.Scale(playerwidth), TukuiDB.Scale(44))

-- tot
local tot = oUF:Spawn('targettarget', "oUF_Tukz_targettarget")
tot:SetPoint("TOPRIGHT", oUF_Tukz_target, "BOTTOMRIGHT", 0,-7)
tot:SetSize(TukuiDB.Scale(125), TukuiDB.Scale(18))

-- pet
local pet = oUF:Spawn('pet', "oUF_Tukz_pet")
pet:SetPoint("TOPLEFT", oUF_Tukz_player, "BOTTOMLEFT", 0,-7)
pet:SetSize(TukuiDB.Scale(125), TukuiDB.Scale(18))

-- focus target
if db.showfocustarget then 
	local focustarget = oUF:Spawn("focustarget", "oUF_Tukz_focustarget")
	if TukuiDB.myclass == "SHAMAN" or TukuiDB.myclass == "DEATHKNIGHT" or TukuiDB.myclass == "PALADIN" or TukuiDB.myclass == "WARLOCK" or TukuiDB.myclass == "DRUID" then
		focustarget:SetPoint("BOTTOMRIGHT", oUF_Tukz_player, "TOPRIGHT", 0,19)
	else
		focustarget:SetPoint("BOTTOMRIGHT", oUF_Tukz_player, "TOPRIGHT", 0,7)
	end
	focustarget:SetSize(TukuiDB.Scale(80), TukuiDB.Scale(16))
end

-- focus
local focus = oUF:Spawn('focus', "oUF_Tukz_focus")
focus:SetPoint("RIGHT", oUF_Tukz_focustarget, "LEFT", -7, 0)
if db.portraits.enable ~= true then
	focus:SetSize((player:GetWidth()-6) - 80, TukuiDB.Scale(16))
else
	focus:SetSize((player:GetWidth()+55) - 80, TukuiDB.Scale(16))
end

if TukuiCF.arena.unitframes then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			arena[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 260, 590)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 10)
		end
		arena[i]:SetSize(TukuiDB.Scale(200), TukuiDB.Scale(43))
	end
end

if db.showboss then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = TukuiDB.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
		if i == 1 then
			boss[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 260, 590)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
		end
		boss[i]:SetSize(TukuiDB.Scale(200), TukuiDB.Scale(43))
		
		--Special PowerBar for Boss frames
		local pf = _G["Boss"..i.."TargetFramePowerBarAlt"]
		pf:ClearAllPoints()
		pf:SetPoint("LEFT", _G["oUF_Boss"..i], "RIGHT", 10, 0)
		pf:SetParent(_G["oUF_Boss"..i])
		pf.ClearAllPoints = TukuiDB.dummy
		pf.SetPoint = TukuiDB.dummy
		pf.SetParent = TukuiDB.dummy
	end
end

local assisttank_width  = 100
local assisttank_height  = 20
if TukuiCF["unitframes"].maintank == true then
	local tank = oUF:SpawnHeader('oUF_MainTank', nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_tukzMtt'
	)
	tank:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

if TukuiCF["unitframes"].mainassist == true then
	local assist = oUF:SpawnHeader("oUF_MainAssist", nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINASSIST',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_tukzMtt'
	)
	if TukuiCF["unitframes"].maintank == true then
		assist:SetPoint("TOPLEFT", oUF_MainTank, "BOTTOMLEFT", 2, -50)
	else
		assist:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

-- this is just a fake party to hide Blizzard frame if no Tukui raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
--	Just a command to test buffs/debuffs alignment
------------------------------------------------------------------------

local testui = TestUI or function() end
TestUI = function()
	testui()
	UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return 'penancelol', 'Rank 2', 'Interface\\Icons\\Spell_Holy_Penance', random(5), 'Magic', 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if(v.UNIT_AURA) then
				v:UNIT_AURA("UNIT_AURA", v.unit)
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end