local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- ptr
T.IsPTRVersion = function()
	local _, version = GetBuildInfo()
	if tonumber(version) > 14007 then
		return true
	else
		return false
	end
end

-- just for creating text
T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

-- datatext panel position
T.PP = function(p, obj)
	local left = TukuiInfoLeft
	local right = TukuiInfoRight
	local mapleft = TukuiMinimapStatsLeft
	local mapright = TukuiMinimapStatsRight
	
	if p == 1 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint("LEFT", left, 20, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 2 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 3 then
		obj:SetParent(left)
		obj:SetHeight(left:GetHeight())
		obj:SetPoint("RIGHT", left, -20, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 4 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint("LEFT", right, 20, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 5 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 6 then
		obj:SetParent(right)
		obj:SetHeight(right:GetHeight())
		obj:SetPoint("RIGHT", right, -20, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	end
	
	if TukuiMinimap then
		if p == 7 then
			obj:SetParent(mapleft)
			obj:SetHeight(mapleft:GetHeight())
			obj:SetPoint('TOP', mapleft)
			obj:SetPoint('BOTTOM', mapleft)
		elseif p == 8 then
			obj:SetParent(mapright)
			obj:SetHeight(mapright:GetHeight())
			obj:SetPoint('TOP', mapright)
			obj:SetPoint('BOTTOM', mapright)
		end
	end
end

T.DataTextTooltipAnchor = function(self)
	local panel = self:GetParent()
	local anchor = "ANCHOR_TOP"
	local xoff = 0
	local yoff = T.Scale(4)
	
	if panel == TukuiMinimapStatsLeft or panel == TukuiMinimapStatsRight then
		local position = TukuiMinimap:GetPoint()
		if position:match("LEFT") then
			anchor = "ANCHOR_BOTTOMRIGHT"
			yoff = T.Scale(-6)
			xoff = 0 - TukuiMinimapStatsRight:GetWidth()
		elseif position:match("RIGHT") then
			anchor = "ANCHOR_BOTTOMLEFT"
			yoff = T.Scale(-6)
			xoff = TukuiMinimapStatsRight:GetWidth()
		else
			anchor = "ANCHOR_BOTTOM"
			yoff = T.Scale(-6)
		end
	end
	
	return anchor, panel, xoff, yoff
end

T.TukuiShiftBarUpdate = function()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		icon = _G["ShapeshiftButton"..i.."Icon"]
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
			icon:SetTexture(texture)
			
			cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			
			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

T.TukuiPetBarUpdate = function(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		
		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
		
		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end			
		end
		
		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end
		
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end
		
		-- grid display
		if name then
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(1)
			end			
		else
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(0)
			end
		end
		
		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end
		
		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

-- Define action bar buttons size
T.buttonsize = T.Scale(C.actionbar.buttonsize)
T.buttonspacing = T.Scale(C.actionbar.buttonspacing)
T.petbuttonsize = T.Scale(C.actionbar.petbuttonsize)
T.petbuttonspacing = T.Scale(C.actionbar.buttonspacing)

T.TotemBarOrientation = function(revert)
	local position = TukuiShiftBar:GetPoint()
	if position:match("TOP") then
		revert = true
	else
		revert = false
	end
	
	return revert
end

T.Round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

T.RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--Check Player's Role
local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true
	else
		resilience = false
	end
	if ((T.myclass == "PALADIN" and tree == 2) or
	(T.myclass == "WARRIOR" and tree == 3) or
	(T.myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(T.myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		T.Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (T.myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or T.myclass == "ROGUE" or T.myclass == "HUNTER" or (T.myclass == "SHAMAN" and tree == 2) then
			T.Role = "Melee"
		else
			T.Role = "Caster"
		end
	end
end
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()

--Return short value of a number
function T.ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

-- Classcolored Datatext
if C["datatext"].classcolored == true then
	C["datatext"].color = T.oUF_colors.class[T.myclass]
end

-- convert datatext color from rgb decimal to hex 
local dr, dg, db = unpack(C["datatext"].color)
T.panelcolor = ("|cff%.2x%.2x%.2x"):format(dr * 255, dg * 255, db * 255)

-- Castbar Size
T.cbSize = function()
	if C["unitframes"].enable ~= true or C["castbar"].enable ~= true then return end

	local x = 4
	if C.castbar.cbicons then x = 32 end
	if C["actionbar"].petbarhorizontal == true then
		if TukuiPetBar:IsShown() then
			TukuiPlayerCastBar:Width(TukuiPetBar:GetWidth() - x)
		else
			TukuiPlayerCastBar:Width(TukuiBar2:GetWidth() - x)
		end
	else
		TukuiPlayerCastBar:Width(TukuiBar2:GetWidth() - x)
	end
end

-- Castbar Position
T.cbPosition = function()
	if C["unitframes"].enable ~= true or C["castbar"].enable ~= true then return end

	T.cbSize()
	local x = 0
	local y = 5
	if C.castbar.cbicons then x = 14 end
	if TukuiDataPerChar.hidebar2 == true then
		TukuiPlayerCastBar:ClearAllPoints()
		if C["actionbar"].petbarhorizontal == true then
			if TukuiPetBar:IsShown() then
				TukuiPlayerCastBar:Point("BOTTOMRIGHT", TukuiPetBar, "TOPRIGHT", -2, y)
			else
				TukuiPlayerCastBar:Point("BOTTOM", TukuiBar1, "TOP", x, y)
			end
		else
			TukuiPlayerCastBar:Point("BOTTOM", TukuiBar1, "TOP", x, y)
		end
	else
		TukuiPlayerCastBar:ClearAllPoints()
		if C["actionbar"].petbarhorizontal == true then
			if TukuiPetBar:IsShown() then
				TukuiPlayerCastBar:Point("BOTTOMRIGHT", TukuiPetBar, "TOPRIGHT", -2, y)
			else
				TukuiPlayerCastBar:Point("BOTTOMRIGHT", TukuiBar2, "TOPRIGHT", -2, y)
			end
		else
			TukuiPlayerCastBar:Point("BOTTOMRIGHT", TukuiBar2, "TOPRIGHT", -2, y)
		end
	end
end

-- Petbarposition
T.petBarPosition = function()
if C["actionbar"].petbarhorizontal ~= true or InCombatLockdown() then return end
	TukuiPetBar:ClearAllPoints()
	if TukuiDataPerChar.hidebar2 == true then
		TukuiPetBar:Point("BOTTOM", TukuiBar1, "TOP", 0, 4)
	else
		TukuiPetBar:Point("BOTTOM", TukuiBar2, "TOP", 0, 4)
	end
end
------------------------------------------------------------------------
--	unitframes Functions
------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

T.updateAllElements = function(frame)
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

T.SpawnMenu = function(self)
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

T.PostUpdatePower = function(element, unit, min, max)
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

T.PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
	else
		local r, g, b
		
		-- overwrite healthbar color for enemy player (a tukui option if enabled), target vehicle/pet too far away returning unitreaction nil and friend unit not a player. (mostly for overwrite tapped for friendly)
		-- I don't know if we really need to call C["unitframes"].unicolor but anyway, it's safe this way.
		if (C["unitframes"].unicolor ~= true and C["unitframes"].enemyhcolor and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C["unitframes"].unicolor ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
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
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r - |cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), ShortValue(min), ShortValue(max))
				else
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), ShortValue(min))
				end
			elseif unit == "target" or unit == "focus" or (unit and unit:find("boss%d")) then
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r - |cff%02x%02x%02x%d%%|r", ShortValue(min), ShortValue(max), r * 255, g * 255, b * 255, floor(min / max * 100))
				else
					health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%s%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			elseif (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(min).."|r")
			else
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			end
		else
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			elseif unit == "target" or unit == "focus" or (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
end

T.PostUpdateHealthRaid = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
	else
		-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
		-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
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

T.PostUpdatePetColor = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
		local c = T.oUF_colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]

		if health then health:SetStatusBarColor(r, g, b) end
		if health.bg then health.bg:SetTexture(.1, .1, .1) end
	end
end

T.PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = T.oUF_colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken, altR, altG, altB = UnitPowerType(unit)
	local color = T.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	else
		power.value:SetTextColor(altR, altG, altB, 1)
	end

	if (not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit)) and not (self.unit and self.unit:find("boss%d")) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s%% |cffD7BEA5-|r %s |cffD7BEA5|||r %s", floor(min / max * 100), ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%s%%", floor(min / max * 100))
					end
				elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
					power.value:SetText(ShortValue(min))
				else
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s |cffD7BEA5-|r %s%%", ShortValue(max - (max - min)), ShortValue(max), floor(min / max * 100))
					else
						power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", ShortValue(max - (max - min)), floor(min / max * 100))
					end
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			power.value:SetText(min)
		end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / day))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

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

T.PostCreateAura = function(element, button)
	button:SetTemplate("Default")
	
	button.remaining = T.SetFontString(button, C["media"].uffont, C["unitframes"].auratextscale, "THINOUTLINE")
	button.remaining:Point("CENTER", 1, 0)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:Point("TOPLEFT", 2, -2)
	button.icon:Point("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:Point("BOTTOMRIGHT", 3, 3)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C["media"].uffont, 8, "THICKOUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)
	
	button:CreateShadow("Default")
end

T.PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			icon.icon:SetDesaturated(false)
		end
	else 
		if (isStealable or ((T.myclass == "MAGE" or T.myclass == "PRIEST" or T.myclass == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then 
			icon:SetBackdropBorderColor(1, 0.85, 0, 1)
		else
			icon:SetBackdropBorderColor(unpack(C.media.bordercolor))
		end
	end
	
	if duration and duration > 0 then
		if C["unitframes"].auratimer == true then
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

T.HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end

T.PortraitUpdate = function(self, unit)
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end
end	

local CheckInterrupt = function(self, unit)
	if unit == "vehicle" then unit = "player" end
	if self.interrupt and UnitCanAttack("player", unit) then
		self:SetStatusBarColor(1, 0, 0, 0.5)	
	else
		if unit == "player" then
			r,g,b = unpack(C["datatext"].color)
			self:SetStatusBarColor(r, g, b, .7)
		elseif unit then
			if C.castbar.classcolored then
				self:SetStatusBarColor(unpack(T.oUF_colors.class[select(2, UnitClass(unit))]))
			else
				self:SetStatusBarColor(unpack(C.castbar.color))
			end
		else
			self:SetStatusBarColor(unpack(T.castbar.color))
		end
	end
end

T.CheckCast = function(self, unit, name, rank, castid)
	CheckInterrupt(self, unit)
end

T.CheckChannel = function(self, unit, name, rank)
	CheckInterrupt(self, unit)
end

T.UpdateShards = function(self, event, unit, powerType)
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

T.Phasing = function(self, event)
	local inPhase = UnitInPhase(self.unit)
	local picon = self.PhaseIcon

	if not UnitIsPlayer(self.unit) then picon:Hide() return end

	-- TO BE COMPLETED
end

T.UpdateHoly = function(self, event, unit, powerType)
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

T.EclipseDirection = function(self)
	if ( GetEclipseDirection() == "sun" ) then
		self.Text:SetText("|cffE5994C"..L.unitframes_ouf_starfirespell.."|r")
	elseif ( GetEclipseDirection() == "moon" ) then
		self.Text:SetText("|cff4478BC"..L.unitframes_ouf_wrathspell.."|r")
	else
		self.Text:SetText("")
	end
end

T.EclipseDisplay = function(self, login)
	local eb = self.EclipseBar
	local txt = self.EclipseBar.Text

	if login then
		eb:SetScript("OnUpdate", nil)
	end
	
	if eb:IsShown() then
		txt:Show()
		self.FlashInfo:Hide()
		if T.lowversion then
			if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34) end
		else
			if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38) end
		end				
	else
		txt:Hide()
		self.FlashInfo:Show()
		if T.lowversion then
			if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26) end
		else
			if self.Buffs then self.Buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 30) end
		end
	end
end

T.MLAnchorUpdate = function (self)
	if C.unitframes.layout ~= 2 then
		if self.Leader:IsShown() then
			self.MasterLooter:Point("TOPLEFT", 14, -5)
		else
			self.MasterLooter:Point("TOPLEFT", 2, -5)
		end
	else
		if self.Leader:IsShown() then
			self.MasterLooter:Point("LEFT", self, "TOPLEFT", 14, -2)
		else
			self.MasterLooter:Point("LEFT", self, "TOPLEFT", 2, -2)
		end
	end
end

T.UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end

T.UpdateName = function(self,event)
	if self.Name then self.Name:UpdateTag(self.unit) end
end

local UpdateManaLevelDelay = 0
local ifire = GetSpellInfo(588)
local iwill = GetSpellInfo(73413)
T.UpdateManaLevel = function(self, elapsed)
	UpdateManaLevelDelay = UpdateManaLevelDelay + elapsed
	if self.parent.unit ~= "player" or UpdateManaLevelDelay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	UpdateManaLevelDelay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana <= C.unitframes.lowThreshold then
		self.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
		Flash(self, 0.3)
	else
		StopFlash(self)
		-- need this for armor swap in arena
		if T.myclass == "PRIEST" and C["unitframes"].priestarmor then
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

T.UpdateDruidMana = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= C["unitframes"].lowThreshold then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidMana:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
				self.DruidMana:SetFormattedText("|cffD7BEA5-|r  |cff4693FF%d%%|r|r", floor(min / max * 100))
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

T.UpdateThreat = function(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		if self.panel then
			self.panel:SetBackdropBorderColor(.85,.31,.31,1)
		else
			self.Name:SetTextColor(1,0.1,0.1)
		end
		if self.panel2 then
			self.panel2:SetBackdropColor(.85,.31,.31,1)
		end
	else
		if self.panel then
			self.panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		else
			self.Name:SetTextColor(1,1,1)
		end
		if self.panel2 then
			self.panel2:SetBackdropColor(unpack(C["media"].bordercolor))
		end
	end 
end

function updateAuraTrackerTime(self, elapsed)
	if (self.active) then
		self.timeleft = self.timeleft - elapsed

		if (self.timeleft <= 5) then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		
		if (self.timeleft <= 0) then
			self.icon:SetTexture("")
			self.text:SetText("")
		end	
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

function Priest_SoS_Time(self, elapsed)
	if (self.hasBuff) then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 0 then
			self.text:SetText("0")
		end
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

--------------------------------------------------------------------------------------------
-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
--------------------------------------------------------------------------------------------

T.countOffsets = {
	TOPLEFT = {6*C["unitframes"].gridscale, 1},
	TOPRIGHT = {-6*C["unitframes"].gridscale, 1},
	BOTTOMLEFT = {6*C["unitframes"].gridscale, 1},
	BOTTOMRIGHT = {-6*C["unitframes"].gridscale, 1},
	LEFT = {6*C["unitframes"].gridscale, 1},
	RIGHT = {-6*C["unitframes"].gridscale, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

T.CreateAuraWatchIcon = function(self, icon)
	icon:SetTemplate("Default")
	icon.icon:Point("TOPLEFT", 1, -1)
	icon.icon:Point("BOTTOMRIGHT", -1, 1)
	icon.icon:SetTexCoord(.08, .92, .08, .92)
	icon.icon:SetDrawLayer("ARTWORK")
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	icon.overlay:SetTexture()
end

T.createAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 2, -2)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if (not C["unitframes"].auratimer) then
		auras.hideCooldown = true
	end

	local buffs = {}

	if (T.buffids["ALL"]) then
		for key, value in pairs(T.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (T.buffids[T.myclass]) then
		for key, value in pairs(T.buffids[T.myclass]) do
			tinsert(buffs, value)
		end
	end

	-- "Cornerbuffs"
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:Width(6*C["unitframes"].gridscale)
			icon:Height(6*C["unitframes"].gridscale)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C.media.blank)
			if (spell[3]) then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["media"].uffont, 8*C["unitframes"].gridscale, "THINOUTLINE")
			count:SetPoint("CENTER", unpack(T.countOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	
	self.AuraWatch = auras
end

if C["unitframes"].raidunitdebuffwatch == true then
	-- Classbuffs { spell ID, position [, {r,g,b,a}][, anyUnit] }
	-- For oUF_AuraWatch
	do
		T.buffids = {
			PRIEST = {
				{6788, "TOPLEFT", {1, 0, 0}, true}, -- Weakened Soul
				{33076, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Prayer of Mending
				{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Renew
				{17, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true}, -- Power Word: Shield
			},
			DRUID = {
				{774, "TOPLEFT", {0.8, 0.4, 0.8}}, -- Rejuvenation
				{8936, "TOPRIGHT", {0.2, 0.8, 0.2}}, -- Regrowth
				{33763, "BOTTOMLEFT", {0.4, 0.8, 0.2}}, -- Lifebloom
				{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}}, -- Wild Growth
			},
			PALADIN = {
				{53563, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Beacon of Light
			},
			SHAMAN = {
				{61295, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Riptide 
				{51945, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Earthliving
				{16177, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
				{974, "BOTTOMRIGHT", {0.7, 0.4, 0}, true}, -- Earth Shield
			},
			ALL = {
				{14253, "RIGHT", {0, 1, 0}}, -- Abolish Poison
				{23333, "LEFT", {1, 0, 0}}, -- Warsong flag xD
			},
		}
	end
		local _, ns = ...
	-- Raid debuffs (now using it with oUF_RaidDebuff instead of oUF_Aurawatch)
	do
		local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

		if not ORD then return end
		
		ORD.ShowDispelableDebuff = true
		ORD.FilterDispellableDebuff = true
		ORD.MatchBySpellName = true
		
		local function SpellName(id)
			local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
			return name	
		end

		T.debuffids = {
		-- Other debuff
			SpellName(67479), -- Impale

		--CATA DEBUFFS
		--Baradin Hold
			SpellName(95173), -- Consuming Darkness

		--Blackwing Descent
			--Magmaw
			SpellName(91911), -- Constricting Chains
			SpellName(94679), -- Parasitic Infection
			SpellName(94617), -- Mangle

			--Omintron Defense System
			SpellName(79835), --Poison Soaked Shell
			SpellName(91433), --Lightning Conductor
			SpellName(91521), --Incineration Security Measure
			SpellName(92051), --Shadow Conductor
			SpellName(79501), --Acquiring Target
			SpellName(92048), --Shadow Infusion

			--Maloriak
			SpellName(77699), -- Flash Freeze
			SpellName(77760), -- Biting Chill
			SpellName(77786), -- Consuming Flames

			--Atramedes
			SpellName(92423), -- Searing Flame
			SpellName(92485), -- Roaring Flame
			SpellName(92407), -- Sonic Breath
			SpellName(92685), -- Pestered
			SpellName(78092), -- Tracking

			--Chimaeron
			SpellName(82881), -- Break
			SpellName(89084), -- Low Health

			--Nefarian
			SpellName(79339), --Explosive Cinders
			SpellName(79318), --Dominion

			--Sinestra
			SpellName(92956), --Wrack

		--The Bastion of Twilight
			--Valiona & Theralion
			SpellName(92878), -- Blackout
			SpellName(86840), -- Devouring Flames
			SpellName(95639), -- Engulfing Magic

			--Halfus Wyrmbreaker
			SpellName(39171), -- Malevolent Strikes

			--Twilight Ascendant Council
			SpellName(92511), -- Hydro Lance
			SpellName(82762), -- Waterlogged
			SpellName(92505), -- Frozen
			SpellName(92518), -- Flame Torrent
			SpellName(83099), -- Lightning Rod
			SpellName(92075), -- Gravity Core
			SpellName(92488), -- Gravity Crush
			SpellName(92067), -- Static Overload

			--Cho'gall
			SpellName(86028), -- Cho's Blast
			SpellName(86029), -- Gall's Blast
			SpellName(93133), -- Debilitating Beam

		--Throne of the Four Winds
			--Conclave of Wind
				--Nezir <Lord of the North Wind>
				SpellName(93131), --Ice Patch
				--Anshal <Lord of the West Wind>
				SpellName(86206), --Soothing Breeze
				SpellName(93122), --Toxic Spores
				--Rohash <Lord of the East Wind>
				SpellName(93058), --Slicing Gale
			--Al'Akir
			SpellName(93260), -- Ice Storm
			SpellName(93295), -- Lightning Rod
			SpellName(87856), -- Squall Line
			
			-- SpellName(6788), --test
		}

		T.ReverseTimer = {
			[92956] = true, -- Sinestra (Wrack)
			-- [6788] = true,--test
		},
		
		ORD:RegisterDebuffs(T.debuffids)
	end
end