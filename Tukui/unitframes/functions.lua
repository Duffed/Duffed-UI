------------------------------------------------------------------------
--	unitframes Functions
------------------------------------------------------------------------

do
	if TukuiCF["unitframes"].enable ~= true then return end
	
	TukuiDB.updateAllElements = function(frame)
		for _, v in ipairs(frame.__elements) do
			v(frame, "UpdateElement", frame.unit)
		end
	end
	
	local SetUpAnimGroup = function(self)
		self.anim = self:CreateAnimationGroup("Flash")
		self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
		self.anim.fadein:SetChange(1)
		self.anim.fadein:SetOrder(2)

		self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
		self.anim.fadeout:SetChange(-1)
		self.anim.fadeout:SetOrder(1)
	end

	local Flash = function(self, duration)
		if not self.anim then
			SetUpAnimGroup(self)
		end

		self.anim.fadein:SetDuration(duration)
		self.anim.fadeout:SetDuration(duration)
		self.anim:Play()
	end

	local StopFlash = function(self)
		if self.anim then
			self.anim:Finish()
		end
	end

	function TukuiDB.SpawnMenu(self)
		local unit = self.unit:gsub("(.)", string.upper, 1)
		if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

		if _G[unit.."FrameDropDown"] then
			ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
		elseif (self.unit:match("party")) then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
		else
			FriendsDropDown.unit = self.unit
			FriendsDropDown.id = self.id
			FriendsDropDown.initialize = RaidFrameDropDown_Initialize
			ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
		end
	end

	function TukuiDB.PostUpdatePower(element, unit, min, max)
		element:GetParent().Health:SetHeight(max ~= 0 and 20 or 22)
	end

	local ShortValue = function(value)
		if value >= 1e6 then
			return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
		elseif value >= 1e3 or value <= -1e3 then
			return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
		else
			return value
		end
	end

	local ShortValueNegative = function(v)
		if v <= 999 then return v end
		if v >= 1000000 then
			local value = string.format("%.1fm", v/1000000)
			return value
		elseif v >= 1000 then
			local value = string.format("%.1fk", v/1000)
			return value
		end
	end

	TukuiDB.PostUpdateHealth = function(health, unit, min, max)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
			if not UnitIsConnected(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_offline.."|r")
			elseif UnitIsDead(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_dead.."|r")
			elseif UnitIsGhost(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_ghost.."|r")
			end
		else
			local r, g, b
			
			-- overwrite healthbar color for enemy player (a tukui option if enabled), target vehicle/pet too far away returning unitreaction nil and friend unit not a player. (mostly for overwrite tapped for friendly)
			-- I don't know if we really need to call TukuiCF["unitframes"].unicolor but anyway, it's safe this way.
			if (TukuiCF["unitframes"].unicolor ~= true and TukuiCF["unitframes"].enemyhcolor and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (TukuiCF["unitframes"].unicolor ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
				local c = TukuiDB.oUF_colors.reaction[UnitReaction(unit, "player")]
				if c then 
					r, g, b = c[1], c[2], c[3]
					health:SetStatusBarColor(r, g, b)
				else
					-- if "c" return nil it's because it's a vehicle or pet unit too far away, we force friendly color
					-- this should fix color not updating for vehicle/pet too far away from yourself.
					r, g, b = 75/255,  175/255, 76/255
					health:SetStatusBarColor(r, g, b)
				end					
			end

			if min ~= max then
				local r, g, b
				r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
				if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
					if TukuiCF["unitframes"].showtotalhpmp == true then
						health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
					else
						health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
					end
				elseif unit == "target" or unit == "focus" or (unit and unit:find("boss%d")) then
					if TukuiCF["unitframes"].showtotalhpmp == true then
						health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
					else
						health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
					end
				elseif (unit and unit:find("arena%d")) then
					health.value:SetText("|cff559655"..ShortValue(min).."|r")
				else
					health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
				end
			else
				if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
					health.value:SetText("|cff559655"..max.."|r")
				elseif unit == "target" or unit == "focus" or (unit and unit:find("arena%d")) then
					health.value:SetText("|cff559655"..ShortValue(max).."|r")
				else
					health.value:SetText(" ")
				end
			end
		end
	end

	TukuiDB.PostUpdateHealthRaid = function(health, unit, min, max)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
			if not UnitIsConnected(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_offline.."|r")
			elseif UnitIsDead(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_dead.."|r")
			elseif UnitIsGhost(unit) then
				health.value:SetText("|cffD7BEA5"..tukuilocal.unitframes_ouf_ghost.."|r")
			end
		else
			local r, g, b
			
			-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
			-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
			if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and TukuiCF["unitframes"].unicolor ~= true then
				r, g, b = 75/255,  175/255, 76/255
				health:SetStatusBarColor(r, g, b)
				health.bg:SetTexture(.1, .1, .1)
			end
			
			if min ~= max then
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
	
	TukuiDB.PostUpdatePetColor = function(health, unit, min, max)
		-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
		-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and TukuiCF["unitframes"].unicolor ~= true then
			r, g, b = 75/255,  175/255, 76/255
			health:SetStatusBarColor(r, g, b)
			health.bg:SetTexture(.1, .1, .1)
		end
	end

	TukuiDB.PostNamePosition = function(self)
		self.Name:ClearAllPoints()
		if (self.Power.value:GetText() and UnitIsEnemy("player", "target") and TukuiCF["unitframes"].targetpowerpvponly == true) or (self.Power.value:GetText() and TukuiCF["unitframes"].targetpowerpvponly == false) then
			self.Name:SetPoint("CENTER", self.panel, "CENTER", 0, 0)
		else
			self.Power.value:SetAlpha(0)
			self.Name:SetPoint("LEFT", self.panel, "LEFT", 4, 0)
		end
	end

	TukuiDB.PreUpdatePower = function(power, unit)
		local _, pType = UnitPowerType(unit)
		
		local color = TukuiDB.oUF_colors.power[pType]
		if color then
			power:SetStatusBarColor(color[1], color[2], color[3])
		end
	end

	TukuiDB.PostUpdatePower = function(power, unit, min, max)
		local self = power:GetParent()
		local pType, pToken = UnitPowerType(unit)
		local color = TukuiDB.oUF_colors.power[pToken]

		if color then
			power.value:SetTextColor(color[1], color[2], color[3])
		end

		if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
			power.value:SetText()
		elseif UnitIsDead(unit) or UnitIsGhost(unit) then
			power.value:SetText()
		else
			if min ~= max then
				if pType == 0 then
					if unit == "target" then
						if TukuiCF["unitframes"].showtotalhpmp == true then
							power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
						else
							power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
						end
					elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
						if TukuiCF["unitframes"].showtotalhpmp == true then
							power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
						else
							power.value:SetFormattedText("%d%%", floor(min / max * 100))
						end
					elseif (unit and unit:find("arena%d")) then
						power.value:SetText(ShortValue(min))
					else
						if TukuiCF["unitframes"].showtotalhpmp == true then
							power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
						else
							power.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
						end
					end
				else
					power.value:SetText(max - (max - min))
				end
			else
				if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) then
					power.value:SetText(ShortValue(min))
				else
					power.value:SetText(min)
				end
			end
		end
		if self.Name then
			if unit == "target" then TukuiDB.PostNamePosition(self, power) end
		end
	end

	TukuiDB.CustomCastTimeText = function(self, duration)
		self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
	end

	TukuiDB.CustomCastDelayText = function(self, duration)
		self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
	end

	local FormatTime = function(s)
		local day, hour, minute = 86400, 3600, 60
		if s >= day then
			return format("%dd", ceil(s / hour))
		elseif s >= hour then
			return format("%dh", ceil(s / hour))
		elseif s >= minute then
			return format("%dm", ceil(s / minute))
		elseif s >= minute / 12 then
			return floor(s)
		end
		return format("%.1f", s)
	end

	local function HideBuffFrame()
		if TukuiCF["unitframes"].playerauras ~= true then return end
		-- hide buff
		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:Hide()
		TemporaryEnchantFrame:Hide()
		InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
		InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)
	end
	HideBuffFrame()

	local CreateAuraTimer = function(self, elapsed)
		if self.timeLeft then
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed >= 0.1 then
				if not self.first then
					self.timeLeft = self.timeLeft - self.elapsed
				else
					self.timeLeft = self.timeLeft - GetTime()
					self.first = false
				end
				if self.timeLeft > 0 then
					local time = FormatTime(self.timeLeft)
					self.remaining:SetText(time)
					if self.timeLeft <= 5 then
						self.remaining:SetTextColor(0.99, 0.31, 0.31)
					else
						self.remaining:SetTextColor(1, 1, 1)
					end
				else
					self.remaining:Hide()
					self:SetScript("OnUpdate", nil)
				end
				self.elapsed = 0
			end
		end
	end

	local CancelAura = function(self, button)
		if button == "RightButton" and not self.debuff then
			-- CancelUnitBuff("player", self:GetID()) -- protected in cata?
		end
	end

	function TukuiDB.PostCreateAura(element, button)
		TukuiDB.SetTemplate(button)
		
		button.remaining = TukuiDB.SetFontString(button, TukuiCF["media"].font, TukuiCF["unitframes"].auratextscale, "THINOUTLINE")
		button.remaining:SetPoint("CENTER", TukuiDB.Scale(1), 0)
		
		button.cd.noOCC = true		 	-- hide OmniCC CDs
		button.cd.noCooldownCount = true	-- hide CDC CDs
		
		button.cd:SetReverse()
		button.icon:SetPoint("TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		button.icon:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon:SetDrawLayer('ARTWORK')
		
		button.count:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(3), TukuiDB.Scale(1.5))
		button.count:SetJustifyH("RIGHT")
		button.count:SetFont(TukuiCF["media"].font, 9, "THICKOUTLINE")
		button.count:SetTextColor(0.84, 0.75, 0.65)
		
		button.overlayFrame = CreateFrame("frame", nil, button, nil)
		button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
		button.cd:ClearAllPoints()
		button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
		button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
		button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
		button.overlay:SetParent(button.overlayFrame)
		button.count:SetParent(button.overlayFrame)
		button.remaining:SetParent(button.overlayFrame)
	end

	function TukuiDB.PostUpdateAura(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
		local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

		if(icon.debuff) then
			if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
				icon:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
				icon.icon:SetDesaturated(true)
			else
				local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
				icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
				icon.icon:SetDesaturated(false)
			end
		end
		
		if duration and duration > 0 then
			if TukuiCF["unitframes"].auratimer == true then
				icon.remaining:Show()
			else
				icon.remaining:Hide()
			end
		else
			icon.remaining:Hide()
		end
	 
		icon.duration = duration
		icon.timeLeft = expirationTime
		icon.first = true
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end

	TukuiDB.HidePortrait = function(self, unit)
		if self.unit == "target" then
			if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
				self.Portrait:SetAlpha(0)
			else
				self.Portrait:SetAlpha(1)
			end
		end
	end

	local CheckInterrupt = function(self, unit)
		if unit == "vehicle" then unit = "player" end
		if self.interrupt and UnitCanAttack("player", unit) then
			self:SetStatusBarColor(unpack(TukuiCF["castbar"].color.notinterruptable))
		else
			if UnitIsPlayer(unit) then
				if ( TukuiCF.castbar.classcolor ) then
					self:SetStatusBarColor(unpack(oUF.colors.class[select(2, UnitClass(unit))]))
				else
					self:SetStatusBarColor(unpack(TukuiCF["castbar"]["color"].player))
				end
			else
				self:SetStatusBarColor(unpack(TukuiCF["castbar"]["color"].notplayer))
			end
		end
	end

	TukuiDB.CheckCast = function(self, unit, name, rank, castid)
		CheckInterrupt(self, unit)
	end

	TukuiDB.CheckChannel = function(self, unit, name, rank)
		CheckInterrupt(self, unit)
	end

	TukuiDB.UpdateShards = function(self, event, unit, powerType)
		if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
		local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
		for i = 1, SHARD_BAR_NUM_SHARDS do
			if(i <= num) then
				self.SoulShards[i]:SetAlpha(1)
			else
				self.SoulShards[i]:SetAlpha(.2)
			end
		end
	end
	
	TukuiDB.Phasing = function(self, event)
		local inPhase = UnitInPhase(self.unit)
		local picon = self.PhaseIcon
		
		-- I don't want this icon show on non-player unit
		-- also fix bug where phase icon is always show on pet/vehicle very far away from you
		if not UnitIsPlayer(self.unit) then picon:Hide() return end

		if(inPhase) then
			picon:Hide()
			if self:GetName():match("oUF_TukuiHealRaid2540") then self.Health.value:SetAlpha(1) end
		else
			picon:Show()
			if self:GetName():match("oUF_TukuiHealRaid2540") then self.Health.value:SetAlpha(0) end
		end
	end

	TukuiDB.UpdateHoly = function(self, event, unit, powerType)
		if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
		local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
		for i = 1, MAX_HOLY_POWER do
			if(i <= num) then
				self.HolyPower[i]:SetAlpha(1)
			else
				self.HolyPower[i]:SetAlpha(.2)
			end
		end
	end

	TukuiDB.EclipseDirection = function(self)
		if ( GetEclipseDirection() == "sun" ) then
				self.Text:SetText("|cffE5994C"..BALANCE_POSITIVE_ENERGY.."|r")
		elseif ( GetEclipseDirection() == "moon" ) then
				self.Text:SetText("|cff4478BC"..BALANCE_NEGATIVE_ENERGY.."|r")
		else
		        self.Text:SetText("")
		end
	end
	
	TukuiDB.EclipseDisplay = function(self, login)
		local eb = self.EclipseBar
		local txt = self.EclipseBar.Text

		if login then
			eb:SetScript("OnUpdate", nil)
		end
		
		if eb:IsShown() then
			txt:Show()
			self.FlashInfo:Hide()
			if TukuiDB.lowversion then
				if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34) end
			else
				if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38) end
			end				
		else
			txt:Hide()
			self.FlashInfo:Show()
			if TukuiDB.lowversion then
				if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26) end
			else
				if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 30) end
			end
		end
	end

	TukuiDB.MLAnchorUpdate = function (self)
		if self.Leader:IsShown() then
			self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
		else
			self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
		end
	end

	TukuiDB.UpdateReputationColor = function(self, event, unit, bar)
		local name, id = GetWatchedFactionInfo()
		bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
	end

	TukuiDB.UpdateName = function(self,event)
		if self.Name then self.Name:UpdateTag(self.unit) end
	end

	local delay = 0
	
	local ifire = GetSpellInfo(588)
	local iwill = GetSpellInfo(73413)
	
	TukuiDB.UpdateManaLevel = function(self, elapsed)
		delay = delay + elapsed
		if self.parent.unit ~= "player" or delay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
		delay = 0

		local percMana = UnitMana("player") / UnitManaMax("player") * 100

		if percMana <= TukuiCF.unitframes.lowThreshold then
			self.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_lowmana.."|r")
			Flash(self, 0.3)
		else
			StopFlash(self)
			
			-- need this for armor swap in arena
			if TukuiDB.myclass == "PRIEST" then
				if UnitBuff("player", ifire) then
					self.ManaLevel:SetText(ifire)
				elseif UnitBuff("player", iwill) then
					self.ManaLevel:SetText(iwill)
				else
					self.ManaLevel:SetText()
				end
			else
			self.ManaLevel:SetText()
			end
		end
	end

	TukuiDB.UpdateDruidMana = function(self)
		if self.unit ~= "player" then return end

		local num, str = UnitPowerType("player")
		if num ~= 0 then
			local min = UnitPower("player", 0)
			local max = UnitPowerMax("player", 0)

			local percMana = min / max * 100
			if percMana <= TukuiCF["unitframes"].lowThreshold then
				self.FlashInfo.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_lowmana.."|r")
				Flash(self.FlashInfo, 0.3)
			else
				self.FlashInfo.ManaLevel:SetText()
				StopFlash(self.FlashInfo)
			end

			if min ~= max then
				if self.Power.value:GetText() then
					self.DruidMana:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
					self.DruidMana:SetFormattedText("|cffD7BEA5-|r  %d%%|r", floor(min / max * 100))
				else
					self.DruidMana:SetPoint("LEFT", self.panel, "LEFT", 4, 1)
					self.DruidMana:SetFormattedText("%d%%", floor(min / max * 100))
				end
			else
				self.DruidMana:SetText()
			end

			self.DruidMana:SetAlpha(1)
		else
			self.DruidMana:SetAlpha(0)
		end
	end

	function TukuiDB.UpdateThreat(self, event, unit)
		if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
		local threat = UnitThreatSituation(self.unit)
		if (threat == 3) then
			if self.panel then
				self.panel:SetBackdropBorderColor(1,.31,.31,1)
			else
				self.Name:SetTextColor(1,0.1,0.1)
			end
		else
			if self.panel then
				self.panel:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
			else
				self.Name:SetTextColor(1,1,1)
			end
		end 
	end

	--------------------------------------------------------------------------------------------
	-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
	--------------------------------------------------------------------------------------------

	TukuiDB.countOffsets = {
		TOPLEFT = {6*TukuiCF["unitframes"].gridscale, 1},
		TOPRIGHT = {-6*TukuiCF["unitframes"].gridscale, 1},
		BOTTOMLEFT = {6*TukuiCF["unitframes"].gridscale, 1},
		BOTTOMRIGHT = {-6*TukuiCF["unitframes"].gridscale, 1},
		LEFT = {6*TukuiCF["unitframes"].gridscale, 1},
		RIGHT = {-6*TukuiCF["unitframes"].gridscale, 1},
		TOP = {0, 0},
		BOTTOM = {0, 0},
	}

	function TukuiDB.CreateAuraWatchIcon(self, icon)
		TukuiDB.SetTemplate(icon)
		icon.icon:SetPoint("TOPLEFT", TukuiDB.Scale(1), TukuiDB.Scale(-1))
		icon.icon:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(-1), TukuiDB.Scale(1))
		icon.icon:SetTexCoord(.08, .92, .08, .92)
		icon.icon:SetDrawLayer("ARTWORK")
		if (icon.cd) then
			icon.cd:SetReverse()
		end
		icon.overlay:SetTexture()
	end

	function TukuiDB.createAuraWatch(self, unit)
		local auras = CreateFrame("Frame", nil, self)
		auras:SetPoint("TOPLEFT", self.Health, 2, -2)
		auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
		auras.presentAlpha = 1
		auras.missingAlpha = 0
		auras.icons = {}
		auras.PostCreateIcon = TukuiDB.CreateAuraWatchIcon

		if (not TukuiCF["unitframes"].auratimer) then
			auras.hideCooldown = true
		end

		local buffs = {}

		if (TukuiDB.buffids["ALL"]) then
			for key, value in pairs(TukuiDB.buffids["ALL"]) do
				tinsert(buffs, value)
			end
		end

		if (TukuiDB.buffids[TukuiDB.myclass]) then
			for key, value in pairs(TukuiDB.buffids[TukuiDB.myclass]) do
				tinsert(buffs, value)
			end
		end

		-- "Cornerbuffs"
		if (buffs) then
			for key, spell in pairs(buffs) do
				local icon = CreateFrame("Frame", nil, auras)
				icon.spellID = spell[1]
				icon.anyUnit = spell[4]
				icon:SetWidth(TukuiDB.Scale(6*TukuiCF["unitframes"].gridscale))
				icon:SetHeight(TukuiDB.Scale(6*TukuiCF["unitframes"].gridscale))
				icon:SetPoint(spell[2], 0, 0)

				local tex = icon:CreateTexture(nil, "OVERLAY")
				tex:SetAllPoints(icon)
				tex:SetTexture([=[Interface\AddOns\Tukui\media\textures\blank]=])
				if (spell[3]) then
					tex:SetVertexColor(unpack(spell[3]))
				else
					tex:SetVertexColor(0.8, 0.8, 0.8)
				end

				local count = icon:CreateFontString(nil, "OVERLAY")
				count:SetFont(TukuiCF["media"].uffont, 8*TukuiCF["unitframes"].gridscale, "THINOUTLINE")
				count:SetPoint("CENTER", unpack(TukuiDB.countOffsets[spell[2]]))
				icon.count = count

				auras.icons[spell[1]] = icon
			end
		end
		
		self.AuraWatch = auras
	end
	
	function updateAuraTrackerTime(self, elapsed)
		if (self.active) then
			self.timeleft = self.timeleft - elapsed

			if (self.timeleft <= 5) then
				self.text:SetTextColor(1, 0, 0) -- red
			else
				self.text:SetTextColor(1, 1, 1) -- white
			end
			
			if (self.timeleft <= 0) then
				self.icon:SetTexture("")
				self.text:SetText("")
			end	
			self.text:SetFormattedText("%.1f", self.timeleft)
		end
	end
end
