local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C.unitframes.enable or C.unitframes.layout ~= 1 then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}
------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local font1 = C["media"].uffont
local font2 = C["media"].font
local normTex = C["media"].normTex
local glowTex = C["media"].glowTex
local bubbleTex = C["media"].bubbleTex
local fontsize = C.unitframes.fontsize
local playerwidth = C["unitframes"].framewidth
if T.lowversion and not C.general.overridehightolow then playerwidth = C["unitframes"].framewidth - 25 end 
local nameoffset = 4

local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult},
}

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = T.oUF_colors
	
	-- register click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = T.SpawnMenu

	-- backdrop for every units
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, 0)
	
	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(18)
	RaidIcon:SetWidth(18)
	RaidIcon:SetPoint("TOP", 0, 8)
	self.RaidIcon = RaidIcon
	
	-- Fader
	if C.unitframes.fader then
		if (unit and not unit:find("arena%d")) or (unit and not unit:find("boss%d")) then
			self.Fader = {
				[1] = {Combat = 1, Arena = 1, Instance = 1}, 
				[2] = {PlayerTarget = C.unitframes.fader_alpha, PlayerNotMaxHealth = C.unitframes.fader_alpha, PlayerNotMaxMana = C.unitframes.fader_alpha}, 
				[3] = {Stealth = C.unitframes.fader_alpha},
				[4] = {notCombat = 0, PlayerTaxi = 0},
			}
		end
		self.NormalAlpha = 1
	end
	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then
		-- create a panel
		local panel = CreateFrame("Frame", nil, self)
		panel:Height(17)
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(23)
		health:Point("TOPLEFT", 0, -16)
		health:Point("TOPRIGHT", 0, -16)
		health:SetStatusBarTexture(normTex)
				
		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
	
		health.value = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		if unit == "player" then
			health.value:Point("RIGHT", health, "RIGHT", -4, 0)
		elseif unit == "target" then
			health.value:Point("LEFT", health, "LEFT", 4, 0)
		end
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		-- Raidicon repositioning
		RaidIcon:Point("TOP", health, "TOP", 0, 12)
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end			
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)			
		end

		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(2)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(panel, font1, fontsize, "THINOUTLINE")
		if unit == "player" then
			power.value:Point("LEFT", panel, "LEFT", 4, 0)
		elseif unit == "target" then
			power.value:Point("RIGHT", panel, "RIGHT", -4, 0)
		end
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C.unitframes.powerClasscolored then
			power.colorTapping = true
			power.colorClass = true		
		else
			power.colorPower = true
		end

		-- Panel position
		panel:Point("BOTTOMLEFT", health, "TOPLEFT", -2, 2)
		panel:Point("BOTTOMRIGHT", health, "TOPRIGHT", 2, 2)	
	
		-- portraits
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
			portrait:SetFrameLevel(8)
			portrait:SetWidth(55)
			if unit == "player" then
				portrait:Point("TOPRIGHT", panel, "TOPLEFT", -5, -4)
				portrait:Point("BOTTOMRIGHT", power, "BOTTOMLEFT", -5, 0)
			elseif unit == "target" then
				portrait:Point("TOPLEFT", panel, "TOPRIGHT", 5, -4)
				portrait:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 5, 0)
			end
			-- table.insert(self.__elements, T.HidePortrait)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			portrait.bg:CreatePanel("Default", 1 , 1, "BOTTOMLEFT", portrait, "BOTTOMLEFT", -2, -2)
			portrait.bg:Point("TOPRIGHT", portrait, "TOPRIGHT", 2, 2)
			portrait.bg:CreateShadow("Default")
		end
		
		if T.myclass == "PRIEST" and C["unitframes"].weakenedsoulbar then
			local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
			ws:SetAllPoints(power)
			ws:SetStatusBarTexture(C.media.normTex)
			ws:GetStatusBarTexture():SetHorizTile(false)
			ws:SetBackdrop(backdrop)
			ws:SetBackdropColor(unpack(C.media.backdropcolor))
			ws:SetStatusBarColor(205/255, 20/255, 20/255)
			
			self.WeakenedSoul = ws
		end
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil, health)
		health.border:CreatePanel("Default",1,1, "TOPLEFT", health, "TOPLEFT", -2, 2)
		health.border:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
		health.border:CreateShadow("Default")
		
		-- Powerbar Border
		power:CreateBorder()
		
		if unit == "target" then
			-- alt power bar for target
			local AltPowerBar = CreateFrame("StatusBar", "TukuiAltPowerBar", self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:SetStatusBarTexture(C.media.normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(0, .7, 0)
			AltPowerBar:SetHeight(3)
			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			
			AltPowerBar:SetBackdrop({bgFile = C["media"].blank})
			AltPowerBar:SetBackdropColor(.1, .1, .1)

			self.AltPowerBar = AltPowerBar
		end
			
		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("LEFT",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "TukuiFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = T.SetFontString(FlashInfo, font1, fontsize, "THINOUTLINE")
			FlashInfo.ManaLevel:Point("RIGHT", panel, "RIGHT", -4, 0)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			local status = T.SetFontString(panel, font1, fontsize)
			status:Point("RIGHT", panel, "RIGHT", -4, 0)
			status:SetTextColor(0.69, 0.31, 0.31)
			status:Hide()
			self.Status = status
			self:Tag(status, "[pvp]")
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:Height(14)
			Leader:Width(14)
			Leader:Point("TOPLEFT", 2, -6)
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
			MasterLooter:Height(14)
			MasterLooter:Width(14)
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", T.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", T.MLAnchorUpdate)
			
			-- Vengeance Plugin
			if C.unitframes.vengeancebar then
				local vge = CreateFrame("StatusBar", "VengeanceBar", TukuiInfoRight)
				vge:Point("TOPLEFT", 2, -2)
				vge:Point("BOTTOMRIGHT", -2, 2)
				vge:SetStatusBarTexture(normTex)
				vge:SetStatusBarColor(163/255,  24/255,  24/255)
				
				vge.Text = vge:CreateFontString(nil, "OVERLAY")
				vge.Text:SetFont(font1, fontsize, "THINOUTLINE")
				vge.Text:SetPoint("CENTER")
				
				vge.bg = vge:CreateTexture(nil, 'BORDER')
				vge.bg:SetAllPoints(vge)
				vge.bg:SetTexture(unpack(C.media.backdropcolor))
				
				self.Vengeance = vge
			end
			
			-- Strength of Soul Plugin
			if T.myclass == "PRIEST" then
				local sos = CreateFrame("Frame", nil, self)
				sos:CreatePanel("Default", 32, 32, "BOTTOMLEFT", self, "BOTTOMRIGHT", 6, -2)
				sos:CreateShadow("Default")
				
				sos.icon = sos:CreateTexture(nil, "OVERLAY")
				sos.icon:Point("TOPLEFT", 2, -2)
				sos.icon:Point("BOTTOMRIGHT", -2, 2)
				
				sos.text = T.SetFontString(sos, font2, 14, "THINOUTLINE")
				sos.text:SetPoint("CENTER", sos, 1, 0)
				sos:SetScript("OnUpdate", Priest_SoS_Time)

				self.Priest_SoS = sos
			end
			
			-- SwingTimer
			if C.swingtimer.enable then
				local sh = CreateFrame("Frame", "TukuiSwingtimerHolder", UIParent)
				sh:CreatePanel("", C.swingtimer.width, 13, "CENTER", UIParent, "CENTER", 0, -50)
				sh:SetMovable(true)
				sh:Hide()
				sh:SetBackdropBorderColor(1,0,0)
				sh:SetScript("OnMouseDown", function(self) self:StartMoving() end)
				sh:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
				sh.text = sh:CreateFontString(nil, "OVERLAY")
				sh.text:SetFont(C.datatext.font, C.datatext.fontsize)
				sh.text:SetPoint("CENTER")
				sh.text:SetText("Move SwingTimer")
				sh:CreateShadow("")

				Swing = CreateFrame("Frame", "TukuiSwingtimer", self)
				Swing:Point("TOPLEFT", sh, "BOTTOMLEFT", 0, -5)
				Swing:Point("TOPRIGHT", sh, "BOTTOMRIGHT", 0, -5)
				Swing:Height(C.swingtimer.height)
				Swing.texture = C["media"].normTex 
				Swing.color = C.swingtimer.color
				Swing.textureBG = C["media"].blank
				Swing.colorBG = {0, 0, 0, 0.8}
				Swing.hideOoc = true

				Swing:CreateBorder()
				-- pretty sure there's a better way :/
				Swing.border:Hide()
				Swing.border:RegisterEvent("PLAYER_REGEN_ENABLED")
				Swing.border:RegisterEvent("PLAYER_REGEN_DISABLED")
				Swing.border:SetScript("OnEvent", function(self, event)
					if event == "PLAYER_REGEN_ENABLED" then self:Hide()
					else self:Show()
					end
				end)

				self.Swing = Swing
			end

			-- experience bar on player via mouseover for player currently levelling a character
			if T.level ~= MAX_PLAYER_LEVEL and C["unitframes"].charportrait == true then
				local Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
				Experience:SetStatusBarTexture(normTex)
				Experience:SetStatusBarColor(0, 0.4, 1, .8)
				Experience:SetBackdrop(backdrop)
				Experience:SetBackdropColor(unpack(C["media"].backdropcolor))
				Experience:SetPoint("TOPLEFT", health)
				Experience:SetPoint("BOTTOMRIGHT", health)
				Experience:SetFrameLevel(10)
				Experience:SetAlpha(0)		
				TukuiPlayer_Portrait:EnableMouse(true)
				TukuiPlayer_Portrait:HookScript("OnEnter", function()
						Experience:SetAlpha(1) 
				end)
				TukuiPlayer_Portrait:HookScript("OnLeave", function() Experience:SetAlpha(0) end)
				Experience.noTooltip = true					

				local Text = T.SetFontString(Experience, font1, fontsize)
				Text:SetSize(playerwidth-10, T.Scale(18))
				Text:Point("CENTER", Experience, "CENTER", 0, 0)
				
				local function update()
					if GetXPExhaustion() ~= nil and GetXPExhaustion() > 0 then
						Text:SetText(format('|cffefefef%d/%d (%d%%) R: %.2f%%', UnitXP("player"), UnitXPMax("player"),(UnitXP("player")/UnitXPMax("player"))*100, (GetXPExhaustion()/UnitXPMax("player"))*100))
					else
						Text:SetText(format('|cffefefef%d/%d (%d%%)', UnitXP("player"), UnitXPMax("player"),(UnitXP("player")/UnitXPMax("player"))*100))
					end
				end
				self:RegisterEvent("PLAYER_LOGIN", update)
				self:RegisterEvent("PLAYER_XP_UPDATE", update)
				self:RegisterEvent("PLAYER_LEVEL_UP", update)
				self:RegisterEvent("UPDATE_EXHAUSTION", update)
				
				local Resting = Experience:CreateTexture(nil, "OVERLAY")
				Resting:Size(24, 24)
				Resting:Point("BOTTOM", Experience, "TOP", 0, -4)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				Resting:SetAlpha(0.8)
				self.Resting = Resting
				
				self.Experience = Experience
			end
			
			-- reputation bar for max level character
			if T.level == MAX_PLAYER_LEVEL and C["unitframes"].charportrait == true then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:SetBackdrop(backdrop)
				Reputation:SetBackdropColor(unpack(C["media"].backdropcolor))
				Reputation:SetPoint("TOPLEFT", health)
				Reputation:SetPoint("BOTTOMRIGHT", health)
				Reputation:SetFrameLevel(10)
				Reputation:SetAlpha(0)
				TukuiPlayer_Portrait:HookScript("OnEnter", function() 
						Reputation:SetAlpha(1) 
				end)
				TukuiPlayer_Portrait:HookScript("OnLeave", function() Reputation:SetAlpha(0) end)

				local Text = T.SetFontString(Reputation, font1, fontsize, "THINOUTLINE")
				Text:SetSize(playerwidth-10, health:GetHeight())
				Text:Point("CENTER", Reputation, "CENTER", 0, 0)
				
				local function update()
					local name, standing, min, max, value = GetWatchedFactionInfo()
					if GetWatchedFactionInfo() ~= nil then
						TukuiPlayer_Portrait:EnableMouse(true)
						Text:SetText(format('%s - %s/%s (%d%%)', name, value - min, max - min, (value - min) / (max - min) * 100))
						Reputation:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
					else
						TukuiPlayer_Portrait:EnableMouse(false)
					end
				end
				self:RegisterEvent('UPDATE_FACTION', update)
				self:RegisterEvent("PLAYER_LOGIN", update)

				Reputation.PostUpdate = C["unitframes"].UpdateReputationColor
				Reputation.Tooltip = false
				self.Reputation = Reputation
			end
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if T.myclass == "DRUID" then
				CreateFrame("Frame"):SetScript("OnUpdate", function() T.UpdateDruidMana(self) end)
				local DruidMana = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
				DruidMana:SetTextColor(1, 0.49, 0.04)
				self.DruidMana = DruidMana
			end
			
			if C["unitframes"].classbar then
				if T.myclass == "DRUID" then			
					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
					eclipseBar:Size(playerwidth, 5)
					eclipseBar:SetFrameStrata("MEDIUM")
					eclipseBar:SetFrameLevel(8)
					eclipseBar:SetScript("OnShow", function() T.EclipseDisplay(self, false) end)
					eclipseBar:SetScript("OnUpdate", function() T.EclipseDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
					eclipseBar:SetScript("OnHide", function() T.EclipseDisplay(self, false) end)
					
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

					local eclipseBarText = T.SetFontString(eclipseBar, font1, fontsize, "THINOUTLINE")
					eclipseBarText:Point("RIGHT", panel, "RIGHT", -4, 0)
					eclipseBar.PostUpdatePower = T.EclipseDirection
					
					-- hide "low mana" text on load if eclipseBar is show
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end
					
					-- border
					eclipseBar:CreateBorder("EclipseBarBorder")

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText
				end

				-- set holy power bar or shard bar
				if (T.myclass == "WARLOCK" or T.myclass == "PALADIN") then
					local bars = CreateFrame("Frame", nil, self)
					bars:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
					bars:Size(playerwidth, 5)
					bars:SetTemplate("Default")
					bars:SetBackdropBorderColor(0,0,0,0)
					
					-- border
					bars:CreateBorder("ShardBarBorder")
					
					for i = 1, 3 do					
						bars[i]=CreateFrame("StatusBar", self:GetName().."_Shard"..i, self)
						bars[i]:Height(5)					
						bars[i]:SetStatusBarTexture(normTex)
						bars[i]:GetStatusBarTexture():SetHorizTile(false)

						bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
						
						if T.myclass == "WARLOCK" then
							bars[i]:SetStatusBarColor(205/255,40/255,40/255)
							bars[i].bg:SetTexture(205/255,40/255,40/255)
						elseif T.myclass == "PALADIN" then
							bars[i]:SetStatusBarColor(228/255,225/255,16/255)
							bars[i].bg:SetTexture(228/255,225/255,16/255)
						end
						
						if i == 1 then
							bars[i]:SetPoint("LEFT", bars)
							bars[i]:Width((bars:GetWidth()/3)-1)
							bars[i].bg:SetAllPoints(bars[i])
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", 1, 0)
							bars[i]:Width((bars:GetWidth()/3)-1)
							bars[i].bg:SetAllPoints(bars[i])
						end
						
						bars[i].bg:SetTexture(normTex)					
						bars[i].bg:SetAlpha(.15)
					end
					
					if T.myclass == "WARLOCK" then
						bars.Override = T.UpdateShards				
						self.SoulShards = bars
					elseif T.myclass == "PALADIN" then
						bars.Override = T.UpdateHoly
						self.HolyPower = bars
					end
				end

				-- deathknight runes
				if T.myclass == "DEATHKNIGHT" then
					local Runes = CreateFrame("Frame", nil, self)
					Runes:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
					Runes:Height(5)
					Runes:Size(playerwidth, 5)
					
					-- border
					Runes:CreateBorder("RuneBarBorder")

					for i = 1, 6 do
						Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, health)
						Runes[i]:SetHeight(5)
						if (i == 1) then
							Runes[i]:Width(((playerwidth) / 6)+2)
							Runes[i]:Point("LEFT", Runes.border, "LEFT", 2, 0)
						else
							Runes[i]:Width(((playerwidth) / 6)-1)
							Runes[i]:Point("TOPLEFT", Runes[i-1], "TOPRIGHT", 1, 0)
						end
						Runes[i]:SetStatusBarTexture(normTex)
						Runes[i]:GetStatusBarTexture():SetHorizTile(false)
					end

					self.Runes = Runes
				end
				
				-- shaman totem bar
				if T.myclass == "SHAMAN" then
					local TotemBar = {}
					TotemBar.Destroy = true
					for i = 1, 4 do
						TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
						if (i == 1) then
							TotemBar[i]:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
						else
							TotemBar[i]:Point("TOPLEFT", TotemBar[i-1], "TOPRIGHT", 3, 0)
						end
						TotemBar[i]:SetStatusBarTexture(normTex)
						TotemBar[i]:Height(5)
						TotemBar[i]:Width(((playerwidth) / 4)-3)
						if i == 4 then TotemBar[i]:Width(TotemBar[1]:GetWidth()+1) end
						TotemBar[i]:SetMinMaxValues(0, 1)

						TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
						TotemBar[i].bg:SetAllPoints(TotemBar[i])
						TotemBar[i].bg:SetTexture(normTex)
						TotemBar[i].bg.multiplier = 0.2
						
						-- border
						TotemBar[i].border = CreateFrame("Frame", nil, TotemBar[i])
						TotemBar[i].border:CreatePanel("Default", 1, 1,"TOPLEFT", TotemBar[i], "TOPLEFT", -2, 2)
						TotemBar[i].border:Point("BOTTOMRIGHT", 2, -2)
					end
					-- Shadow
					TotemShadow = CreateFrame("Frame", "TotemBarBorder", TukuiPlayer_TotemBar1)
					TotemShadow:SetPoint("TOPLEFT", -2, 2)
					TotemShadow:SetPoint("BOTTOMRIGHT", TukuiPlayer_TotemBar4, "BOTTOMRIGHT", 2, -2)
					TotemShadow:CreateShadow("Default")
					
					self.TotemBar = TotemBar
				end
			end
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:Hide()
				status:Show()
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				status:Hide()
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
			Name:Point("LEFT", panel, "LEFT", 4, 0)
			Name:SetJustifyH("LEFT")

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name
			
			-- combo points on target
			
			local cp = T.SetFontString(self, font2, 15, "THINOUTLINE")
			cp:SetPoint("RIGHT", health.border, "LEFT", -5, 0)
			
			self.CPoints = cp
		end

		if (unit == "target" and C["unitframes"].targetauras) or (unit == "player" and C["unitframes"].playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			buffs:Point("BOTTOMLEFT", self, "TOPLEFT", -2, 4)
			buffs.size = 22
			buffs.spacing = 3
			buffs:Height((buffs.size+buffs.spacing) * C.unitframes.buffrows)
			buffs:Width(playerwidth+3)
			buffs.num = ( playerwidth/(buffs.size+buffs.spacing) ) * C.unitframes.buffrows
			
			debuffs.size = 22
			debuffs.spacing = 3
			debuffs:Height((debuffs.size+debuffs.spacing) * C.unitframes.debuffrows)
			debuffs:Width(playerwidth+3)
			debuffs:Point("BOTTOMLEFT", buffs, "TOPLEFT", 1, 0)
			if C.classtimer.targetdebuffs then
				debuffs.num = ( playerwidth/(buffs.size+buffs.spacing) )
			else
				debuffs.num = ( playerwidth/(buffs.size+buffs.spacing) ) * C.unitframes.debuffrows
			end
			
			buffs.initialAnchor = 'BOTTOMLEFT'
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs
						
			debuffs.initialAnchor = 'BOTTOMRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			
			-- an option to show only our debuffs on target
			if unit == "target" then
				debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
			end
			
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if (C["castbar"].enable == true) then
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			if unit == "player" then
				castbar:Height(21)
			elseif unit == "target" then
				castbar:Width(240)
				castbar:Height(18)
				castbar:Point("BOTTOM", UIParent, "BOTTOM", 0, C["castbar"]["target-y-offset"])
			end
			
			castbar.CustomTimeText = T.CustomCastTimeText
			castbar.CustomDelayText = T.CustomCastDelayText
			castbar.PostCastStart = T.CheckCast
			castbar.PostChannelStart = T.CheckChannel

			castbar.time = T.SetFontString(castbar, font1, fontsize)
			castbar.time:Point("RIGHT", castbar, "RIGHT", -5, 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = T.SetFontString(castbar, font1, fontsize)
			castbar.Text:Point("LEFT", castbar, "LEFT", 6, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			-- Border
			castbar:CreateBorder()
			
			if C.castbar.cbicons then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetTemplate("Default")
				castbar.button:CreateShadow("Default")
				
				if unit == "player" then
					castbar.button:Size(25)
					castbar.button:Point("RIGHT",castbar,"LEFT", -5, 0)
				elseif unit == "target" then
					castbar.button:Size(27)
					castbar.button:Point("BOTTOM", castbar, "TOP", 0, 5)
				end

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
				castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end
			
			-- cast bar latency on player
			if unit == "player" and C["castbar"].cblatency == true then
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
		if C["unitframes"].combatfeedback == true then
			local CombatFeedbackText 
			CombatFeedbackText = T.SetFontString(health, font2, 14, "THINOUTLINE")
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
		
		if C["unitframes"].healcomm then
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
			ohpb:SetWidth(playerwidth)
			ohpb:SetStatusBarTexture(normTex)
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				maxOverflow = 1,
			}
		end
		
		-- player aggro
		if C["unitframes"].playeraggro == true then
			table.insert(self.__elements, T.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
		end
	end
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(16)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end			
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)			
		end
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		health.border:CreatePanel("Default",1,1,"TOPLEFT", health, "TOPLEFT", -2, 2)
		health.border:Point("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -4)
		health.border:CreateShadow("Default")
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(1)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -1)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end
		
		if C.unitframes.powerClasscolored then
			power.colorTapping = true
			power.colorClass = true		
		else
			power.colorPower = true
		end
		self.Power = power
		
		-- Unit name
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, -1)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 19.5
			debuffs.spacing = 4
			debuffs.num = 6

			debuffs:Point("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- Lines
		if C["unitframes"].totandpetlines == true and playerwidth > 155 then
			line1 = CreateFrame("Frame", nil, health)
			line1:CreatePanel("Default", 15, 2, "RIGHT", health.border, "LEFT", -1, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			line2:CreatePanel("Default", 2, 14, "BOTTOM", line1, "LEFT", 0, -1)
		end
		
		-- portrait
		if C["unitframes"].charportrait == true then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(8)
			portrait:Width(21)
			portrait:Point("TOPLEFT", health,"TOPRIGHT",7,0)
			portrait:Point("BOTTOMLEFT", power,"BOTTOMRIGHT",7,0)

			table.insert(self.__elements, T.HidePortrait)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			portrait.bg:CreatePanel("Default",1,1,"BOTTOMLEFT",portrait,"BOTTOMLEFT",-2,-2)
			portrait.bg:SetPoint("TOPRIGHT",portrait,"TOPRIGHT",2,2)
			portrait.bg:CreateShadow("Default")
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- health bar panel
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(16)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		health.PostUpdate = T.PostUpdatePetColor
				
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end			
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
			if T.myclass == "HUNTER" then
				health.colorHappiness = true
			end
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- Healthbar Border
		health.border = CreateFrame("Frame", nil,health)
		health.border:CreatePanel("Default",1,1,"TOPLEFT", health, "TOPLEFT", -2, 2)
		health.border:Point("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -4)
		health.border:CreateShadow("Default")
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(1)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -1)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
				
		self.Power = power
		self.Power.bg = powerBG
				
		-- Unit name
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, -1)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium] [Tukui:diffcolor][level]')
		self.Name = Name
		
		if C["unitframes"].unicolor then
			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]  [Tukui:diffcolor][level]')
			self.Name = Name
		else
			self:Tag(Name, '[Tukui:namemedium]  [Tukui:diffcolor][level]')
			self.Name = Name
		end
		
		-- Lines
		if (C["unitframes"].totandpetlines == true and playerwidth > 155) then
			line1 = CreateFrame("Frame", nil, health)
			line1:CreatePanel("Default", 15, 2, "LEFT", health.border, "RIGHT", 1, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			line2:CreatePanel("Default", 2, 14, "BOTTOM", line1, "RIGHT", 0, -1)
		end
		
		if (C["castbar"].enable == true) then
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			self.Castbar = castbar
			castbar:Height(3)
			
			castbar:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -7)
			castbar:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -7)

			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetTexture(normTex)
			castbar.bg:SetVertexColor(0.15, 0.15, 0.15)
			castbar:SetFrameLevel(6)
			
			castbar.CustomTimeText = T.CustomCastTimeText
			castbar.CustomDelayText = T.CustomCastDelayText
			castbar.PostCastStart = T.CheckCast
			castbar.PostChannelStart = T.CheckChannel

			castbar.Text = T.SetFontString(castbar, font1, fontsize)
			castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			self.Castbar.Time = castbar.time
			
			-- Border
			castbar:CreateBorder()
		end
		
		if (C["unitframes"].charportrait == true) then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(8)
			portrait:Width(21)
			portrait:Point("TOPRIGHT", health,"TOPLEFT",-7,0)
			portrait:Point("BOTTOMRIGHT", power,"BOTTOMLEFT",-7,0)

			table.insert(self.__elements, T.HidePortrait)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
			
			-- Portrait Border
			portrait.bg = CreateFrame("Frame",nil,portrait)
			portrait.bg:CreatePanel("Default",1,1,"BOTTOMLEFT",portrait,"BOTTOMLEFT",-2,-2)
			portrait.bg:Point("TOPRIGHT",portrait,"TOPRIGHT",2,2)
			portrait.bg:CreateShadow("Default")
		end
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 19.5
			debuffs.spacing = 4
			debuffs.num = 6

			debuffs:Point("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = C["unitframes"].PostCreateAura
			debuffs.PostUpdateIcon = C["unitframes"].PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", T.updateAllElements)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		local lafo = C.unitframes.largefocus
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		if lafo then
			health:Height(19)
			health:Point("TOPLEFT",0 ,-15)
			health:Point("TOPRIGHT",0 ,-15)
		else
			health:Height(16)
			health:SetPoint("TOPLEFT")
			health:SetPoint("TOPRIGHT")
		end
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()

		health.value = T.SetFontString(health, font1,fontsize, "THINOUTLINE")
		if lafo then
			health.value:Point("LEFT", health, "LEFT", 2, 0)
		else
			health.value:Point("RIGHT", -2, 0)
		end
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- names
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		if lafo then
			Name:Point("BOTTOMLEFT", health, "TOPLEFT", 2, nameoffset)
		else
			Name:Point("LEFT", health, "LEFT", 4, 0)
		end
		Name:SetJustifyH("LEFT")
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
		self.Name = Name
	
		-- create castbar
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		-- power
		if lafo then
			local power = CreateFrame('StatusBar', nil, self)
			power:Height(2)
			power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
			power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
			power:SetStatusBarTexture(normTex)
			
			power.frequentUpdates = true
			if C["unitframes"].showsmooth == true then
				power.Smooth = true
			end
			
			if C.unitframes.powerClasscolored then
				power.colorTapping = true
				power.colorClass = true		
			else
				power.colorPower = true
			end

			local powerBG = power:CreateTexture(nil, 'BORDER')
			powerBG:SetAllPoints(power)
			powerBG:SetTexture(normTex)
			powerBG.multiplier = 0.3
			
			power.value = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
			power.value:Point("BOTTOMRIGHT", health, "TOPRIGHT", -2, nameoffset)
			power.PreUpdate = T.PreUpdatePower
			power.PostUpdate = T.PostUpdatePower
					
			self.Power = power
			self.Power.bg = powerBG
			
			-- Border
			health.border = CreateFrame("Frame", nil,health)
			health.border:CreatePanel("Default",1,1,"TOPLEFT", health, "TOPLEFT", -2, 2)
			health.border:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
			health.border:CreateShadow("Default")
			
			power:CreateBorder()
			
			-- Auratracker Frame
			local TrackBorder = CreateFrame("Frame", "TrackBorder", self)
			TrackBorder:CreatePanel("Default", 40, 40, "BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			TrackBorder:CreateShadow("Default")
			
			local AuraTracker = CreateFrame("Frame", nil, self)
			AuraTracker:SetFrameLevel(9)
			self.AuraTracker = AuraTracker
			
			AuraTracker.icon = AuraTracker:CreateTexture(nil, "OVERLAY")
			AuraTracker.icon:Point("TOPLEFT", TrackBorder, 2, -2)
			AuraTracker.icon:Point("BOTTOMRIGHT", TrackBorder, -2, 2)
			AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
			
			AuraTracker.text = T.SetFontString(AuraTracker, font2, 15, "THINOUTLINE")
			AuraTracker.text:SetPoint("CENTER", TrackBorder, 0, 0)
			AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
			
			-- Portrait
			local portrait = CreateFrame("PlayerModel", nil, TrackBorder)
			portrait:SetFrameLevel(8)
			portrait:Point("TOPLEFT", 2, -2)
			portrait:Point("BOTTOMRIGHT", -2, 2)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
		end
		
		-- Border
		if not lafo then
			health:CreateBorder()
		end

		-- create debuffs
		if C.unitframes.focusdebuffs then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs.spacing = 3
			if lafo then
				debuffs.size = 26
				debuffs:SetHeight(22)
				debuffs:Point('LEFT', health, 'RIGHT', 5, -3)
				debuffs.initialAnchor = 'LEFT'
				debuffs["growth-x"] = "RIGHT"
				debuffs.num = 4
			else
				debuffs:Point("RIGHT", self, "LEFT", -5, 0)
				debuffs.initialAnchor = 'RIGHT'
				debuffs["growth-x"] = "LEFT"
				debuffs.num = 4
				debuffs.size = 20
				debuffs:SetHeight(20)
			end
			debuffs:SetWidth((debuffs.size + debuffs.spacing) * debuffs.num)
			debuffs.PostCreateIcon = T.PostCreateAura
			debuffs.PostUpdateIcon = T.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- castbar
		if C["castbar"].enable == true then
			castbar:SetStatusBarTexture(normTex)
			castbar:SetFrameLevel(10)
			castbar:Height(20)
			castbar:Width(240)
			castbar:Point("TOP", UIParent, "TOP", 0, C["castbar"]["focus-y-offset"])
			
			castbar:CreateBorder()
			
			castbar.time = T.SetFontString(castbar, font1, fontsize)
			castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")
			castbar.CustomTimeText = T.CustomCastTimeText

			castbar.Text = T.SetFontString(castbar, font1, fontsize)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomDelayText = T.CustomCastDelayText
			castbar.PostCastStart = T.CheckCast
			castbar.PostChannelStart = T.CheckChannel
	
			if C.castbar.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:Size(31)
				castbar.button:Point("BOTTOM", castbar, "TOP",0,5)
				castbar.button:SetTemplate("Default")
				castbar.button:CreateShadow("Default")
				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
				castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
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
		local lafo = C.unitframes.largefocus
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetPoint("TOPLEFT")
		health:SetPoint("BOTTOMRIGHT")
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)
		end
			
		-- names
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- Border
		health:CreateBorder(self)
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and C["arena"].unitframes == true) or (unit and unit:find("boss%d") and C["unitframes"].showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(19)
		health:Point("TOPLEFT",0 ,-15)
		health:Point("TOPRIGHT",0 ,-15)
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()

		health.value = T.SetFontString(health, font1,fontsize, "THINOUTLINE")
		health.value:Point("LEFT", health, "LEFT", 2, 0)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		-- Raidicon repositioning
		RaidIcon:Point("TOP", health, "TOP", 0, 9)
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(2)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		power.value:Point("BOTTOMRIGHT", health, "TOPRIGHT", -2, nameoffset)
		power.PreUpdate = T.PreUpdatePower
		power.PostUpdate = T.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- Border
		health.border = CreateFrame("Frame", nil,health)
		health.border:CreatePanel("Default",1,1,"TOPLEFT", health, "TOPLEFT", -2, 2)
		health.border:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
		health.border:CreateShadow("Default")
		
		power.border = CreateFrame("Frame", nil, power)
		power.border:CreateLine(power:GetWidth(), 1)
		power.border:Point("BOTTOMLEFT", power, "TOPLEFT", -1, 1)
		power.border:Point("BOTTOMRIGHT", power, "TOPRIGHT", 1, 1)
		
		-- names
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		Name:Point("BOTTOMLEFT", health, "TOPLEFT", 2, nameoffset)
		Name:SetJustifyH("LEFT")
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			power.colorPower = true
		
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:Height(3)
			AltPowerBar:SetStatusBarTexture(C.media.normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)

			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			-- AltPowerBar:SetBackdrop({bgFile = C["media"].blank})
			-- AltPowerBar:SetBackdropColor(.1,.1,.1)
			self.AltPowerBar = AltPowerBar
			
			-- Portrait Border
			local PBorder = CreateFrame("Frame", nil, self)
			PBorder:CreatePanel("Default", 40, 40, "BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			PBorder:CreateShadow("Default")
			
			local portrait = CreateFrame("PlayerModel", nil, PBorder)
			portrait:SetFrameLevel(8)
			portrait:Point("TOPLEFT", 2, -2)
			portrait:Point("BOTTOMRIGHT", -2, 2)
			table.insert(self.__elements, T.HidePortrait)
			portrait.PostUpdate = T.PortraitUpdate --Worgen Fix (Hydra)
			self.Portrait = portrait
			
			-- create buff at left of unit if they are boss units
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(40)
			buffs:SetWidth(252)
			buffs:Point("BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			buffs.size = 40
			buffs.num = 3
			buffs.spacing = 2
			buffs.initialAnchor = 'RIGHT'
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = T.PostCreateAura
			buffs.PostUpdateIcon = T.PostUpdateAura
			self.Buffs = buffs
			
			-- because it appear that sometime elements are not correct.
			self:HookScript("OnShow", T.updateAllElements)
		end

		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(22)
		debuffs:SetWidth(200)
		debuffs:Point('LEFT', health, 'RIGHT', 4, -3)
		debuffs.size = 25
		debuffs.num = 5
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		debuffs.onlyShowPlayer = true
		self.Debuffs = debuffs
				
		-- trinket feature via trinket plugin
		if (C.arena.unitframes) and (unit and unit:find('arena%d')) then
			if C.unitframes.powerClasscolored then
				power.colorTapping = true
				power.colorClass = true		
			else
				power.colorPower = true
			end
		
			RaidIcon:Hide()
			-- Auratracker Frame
			local AuraTracker = CreateFrame("Frame", nil, self)
			AuraTracker:Size(40)
			AuraTracker:Point("BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			AuraTracker:SetTemplate("Default")
			AuraTracker:CreateShadow("Default")
			self.AuraTracker = AuraTracker
			
			AuraTracker.icon = AuraTracker:CreateTexture(nil, "OVERLAY")
			AuraTracker.icon:SetAllPoints(AuraTracker)
			AuraTracker.icon:Point("TOPLEFT", AuraTracker, 2, -2)
			AuraTracker.icon:Point("BOTTOMRIGHT", AuraTracker, -2, 2)
			AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
			
			AuraTracker.text = T.SetFontString(AuraTracker, font2, 15, "THINOUTLINE")
			AuraTracker.text:SetPoint("CENTER", AuraTracker, 0, 0)
			AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
			
			-- ClassIcon			
			local class = AuraTracker:CreateTexture(nil, "ARTWORK")
			class:SetAllPoints(AuraTracker.icon)
			self.ClassIcon = class
		
			-- Trinket Frame
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:Size(9,9)
			Trinketbg:Point("TOPRIGHT", health, "TOPRIGHT", 1,1)
			Trinketbg:SetBackdrop({
				edgeFile = C["media"].blank, 
				tile = false, tileSize = 0, edgeSize = 1, 
				insets = { left = -1, right = -1, top = -1, bottom = -1}
			})
			Trinketbg:SetBackdropBorderColor(0,0,0)
			Trinketbg:SetFrameLevel(health:GetFrameLevel()+1)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, self)
			Trinket:Point("TOPLEFT", Trinketbg, 1, -1)
			Trinket:Point("BOTTOMRIGHT", Trinketbg, -1, 1)
			Trinket:SetFrameLevel(Trinketbg:GetFrameLevel()+1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
			
			-- Spec info
			Talents = T.SetFontString(health.border, font1, fontsize)
			Talents:Point("TOPRIGHT", health.border, "BOTTOMRIGHT", -2, -3)
			Talents:SetTextColor(1,1,1,.6)
			self.Talents = Talents
		end
		
		-- boss & arena frames cast bar!
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)		
		castbar:SetHeight(12)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(10)
		
		castbar:CreateBorder()
		castbar.border:SetFrameLevel(9)

		castbar.Text = T.SetFontString(castbar, font1, fontsize)
		castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		
		castbar.CustomDelayText = T.CustomCastDelayText
		castbar.PostCastStart = T.CheckCast
		castbar.PostChannelStart = T.CheckChannel
		
		local Ax = 0
		if C.castbar.cbicons == true then
			Ax = 19
			castbar.button = CreateFrame("Frame", nil, castbar)
			castbar.button:CreatePanel("Default", 16, 16, "BOTTOMRIGHT", castbar, "BOTTOMLEFT",-5,-2)
			castbar.button:CreateShadow("Default")

			castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
			castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
			castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
			castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
		end
		castbar:Point("TOPLEFT", power, "TOPLEFT", Ax, -9)
		castbar:Point("TOPRIGHT", power, "TOPRIGHT", 0, -9)

		self.Castbar = castbar
		self.Castbar.Icon = castbar.icon
	end

	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"TukuiMainTank" or self:GetParent():GetName():match"TukuiMainAssist") then
		-- Right-click focus on maintank or mainassist units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(20)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C.unitframes.ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)
		end
		
		-- names
		local Name = T.SetFontString(health, font1, fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
		
		-- border
		local border = CreateFrame("Frame", nil, self)
		border:CreatePanel("Default", 1, 1, "TOPLEFT", self, "TOPLEFT", -2, 2)
		border:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
		border:CreateShadow("Default")
	end
	
	return self
end

------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------
oUF:RegisterStyle('Tukui', Shared)

-- player
local player = oUF:Spawn('player', "TukuiPlayer")
if T.lowversion then
	player:Point("BOTTOMLEFT", TukuiBar1, "TOPLEFT", -130,135)
else
	player:Point("BOTTOMLEFT", TukuiBar1, "TOPLEFT", 2,140)
end
player:Size(playerwidth, 44)

-- target
local target = oUF:Spawn('target', "TukuiTarget")
if T.lowversion then
	target:Point("BOTTOMRIGHT", TukuiBar1, "TOPRIGHT", 130,135)
else
	target:Point("BOTTOMRIGHT", TukuiBar1, "TOPRIGHT", -2,140)
end
target:Size(playerwidth, 44)

-- tot
local tot = oUF:Spawn('targettarget', "TukuiTargetTarget")
tot:Point("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0,-7)
tot:Size(125, 18)

-- pet
local pet = oUF:Spawn('pet', "TukuiPet")
if ShardBarBorder or RuneBarBorder or TotemBarBorder then
	pet:Point("TOPLEFT", ShardBarBorder or RuneBarBorder or TotemBarBorder, "BOTTOMLEFT", 2, -5)
else
	pet:Point("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0,-7)
end
pet:Size(125, 18)

-- focus & focustarget
local focus = oUF:Spawn('focus', "TukuiFocus")
local focustarget = oUF:Spawn("focustarget", "TukuiFocusTarget")	
if C.unitframes.largefocus then
	focus:Size(playerwidth-20, 39)
	focus:Point("TOPLEFT", UIParent, "TOPLEFT", 560, -370)
	focustarget:Size(110, 14)
	focustarget:Point("TOPRIGHT", TukuiFocus, "BOTTOMRIGHT", 0, -7)
else
	focustarget:Size(80, 16)
	focustarget:Point("BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0,6)
	focus:Point("BOTTOMRIGHT", TukuiFocusTarget, "BOTTOMLEFT", -7, 0)
	if C["unitframes"].charportrait ~= true then
		focus:Size((playerwidth - 7) - 80, 16)
	else
		focus:Size((playerwidth + 55) - 80, 16)
	end
end

if C.arena.unitframes then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "TukuiArena"..i)
		if i == 1 then
			arena[i]:Point("BOTTOM", UIParent, "BOTTOM", 330, 550)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 27)
		end
		arena[i]:Size(playerwidth-20, 39)
	end
end

if C["unitframes"].showboss then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = T.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "TukuiBoss"..i)
		if i == 1 then
			boss[i]:Point("BOTTOM", UIParent, "BOTTOM", 330, 550)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 27)             
		end
		boss[i]:Size(playerwidth-20, 39)
	end
end

local assisttank_width = 90
local assisttank_height  = 20
if C["unitframes"].maintank == true then
	local tank = oUF:SpawnHeader('TukuiMainTank', nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	tank:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end
 
if C["unitframes"].mainassist == true then
	local assist = oUF:SpawnHeader("TukuiMainAssist", nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINASSIST',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_TukuiMtt'
	)
	if C["unitframes"].maintank == true then
		assist:SetPoint("TOPLEFT", TukuiMainTank, "BOTTOMLEFT", 2, -50)
	else
		assist:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

-- this is just a fake party to hide Blizzard frame if no Tukui raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

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


-- Testui Command
local testui = TestUI or function() end
TestUI = function(msg)
	if msg == "a" or msg == "arena" then
		TukuiArena1:Show(); TukuiArena1.Hide = function() end; TukuiArena1.unit = "player"
		TukuiArena2:Show(); TukuiArena2.Hide = function() end; TukuiArena2.unit = "target"
		TukuiArena3:Show(); TukuiArena3.Hide = function() end; TukuiArena3.unit = "player"
	elseif msg == "boss" or msg == "b" then
		TukuiBoss1:Show(); TukuiBoss1.Hide = function() end; TukuiBoss1.unit = "player"
		TukuiBoss2:Show(); TukuiBoss2.Hide = function() end; TukuiBoss2.unit = "player"
		TukuiBoss3:Show(); TukuiBoss3.Hide = function() end; TukuiBoss3.unit = "player"
	elseif msg == "buffs" then -- better dont test it ^^
		UnitAura = function()
			-- name, rank, texture, count, dtype, duration, timeLeft, caster
			return 139, 'Rank 1', 'Interface\\Icons\\Spell_Holy_Penance', 1, 'Magic', 0, 0, "player"
		end
		if(oUF) then
			for i, v in pairs(oUF.units) do
				if(v.UNIT_AURA) then
					v:UNIT_AURA("UNIT_AURA", v.unit)
				end
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"