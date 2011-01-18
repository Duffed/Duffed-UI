-- some shit plugins i need for priest, it require tukz unitframes.
if TukuiCF["unitframes"].enable ~= true or TukuiDB.myclass ~= "PRIEST" then return end

local font = TukuiCF["media"].font
local ws = GetSpellInfo(6788)
local sos = GetSpellInfo(89488)

local function BarPanel(height, width, x, y, anchorPoint, anchorPointRel, anchor, level, parent, strata)
	local Panel = CreateFrame("Frame", _, parent)
	Panel:SetFrameLevel(level)
	Panel:SetFrameStrata(strata)
	Panel:SetHeight(height)
	Panel:SetWidth(width)
	Panel:SetPoint(anchorPoint, anchor, anchorPointRel, x, y)
	Panel:SetBackdrop( { 
	bgFile = TukuiCF["media"].blank, 
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	Panel:SetBackdropColor(0.1, 0.1, 0.1, 1)
	Panel:Show()
	return Panel
end 

-- Function to update each bar
local function UpdateBar(self)
	local duration = self.Duration
	local timeLeft = self.EndTime-GetTime()
	local roundedt = math.floor(timeLeft*10.5)/10
	self.Bar:SetValue(timeLeft/duration)
	
	-- for 4.0.6 priest changes of strength of soul, color the weakened soul bar.
	-- if priest is immune to interrupt/silence/dispel, color it green.
	-- if priest is not immune to interrupt/silence/dispel, color it red.
	if (self.Player and UnitBuff("player", sos)) or (self.Target and UnitBuff("target", sos)) then
		self.Bar:SetStatusBarColor(89/255, 157/255, 30/255)
	else
		self.Bar:SetStatusBarColor(81/255, 13/255, 13/255)
	end
	
	if roundedt % 1 == 0 then 
		self.Time:SetText(roundedt .. ".0")
	else 
		self.Time:SetText(roundedt)
	end

	if timeLeft < 0 or (UnitHasVehicleUI("player") and self.Player) or (self.Player and not UnitDebuff("player", ws)) or (self.Target and not UnitDebuff("target", ws)) then
		self.Panel:Hide()
		self:SetScript("OnUpdate", nil)
	end
end

-- Configures the Bar
local function ConfigureBar(f)
	f.Bar = CreateFrame("StatusBar", _, f.Panel)
	f.Bar:SetStatusBarTexture(TukuiCF["media"].blank)
	f.Bar:SetStatusBarColor(81/255, 13/255, 13/255)
	f.Bar:SetPoint("BOTTOMLEFT", 0, 0)
	f.Bar:SetPoint("TOPRIGHT", 0, 0)
	f.Bar:SetMinMaxValues(0, 1)

	f.Time = f.Bar:CreateFontString(nil, "OVERLAY")
	f.Time:SetPoint("LEFT", 2, 1)
	f.Time:SetShadowOffset(1, -1)
	f.Time:SetShadowColor(0.1, 0.1, 0.1, 1)
	f.Time:SetFont(font, 10)
	f.Time:SetJustifyH("LEFT")

	if TukuiCF["unitframes"].ws_show_time == true then
		f.Time:Show()
	else
		f.Time:Hide()
	end

	f.Panel:Hide()
end

--------------------------------------------------------
--  Weakened Soul Bar codes
--------------------------------------------------------

local ws = GetSpellInfo(6788)

if (TukuiCF["unitframes"].ws_show_target) then
	local WeakenedTargetFrame = CreateFrame("Frame", _, oUF_Tukz_target)
	WeakenedTargetFrame.Panel = BarPanel(TukuiDB.Scale(2), oUF_Tukz_target:GetWidth(), TukuiDB.Scale(0), TukuiDB.Scale(0), "BOTTOMLEFT", "BOTTOMLEFT", oUF_Tukz_target, 1, WeakenedTargetFrame, "HIGH")
	WeakenedTargetFrame.Panel:SetFrameLevel(10)

	ConfigureBar(WeakenedTargetFrame)

	-- On Target Change or Weakened Soul check on the friendly target
	local function WeakenedTargetCheck(self, event, unit, spell)
		if (event == "PLAYER_TARGET_CHANGED") or (unit == "target" and UnitIsFriend("player", "target") and UnitDebuff("target", ws)) then      
			local name, _, _, _, _, duration, expirationTime, unitCaster = UnitDebuff("target", ws)
			if (event == "PLAYER_TARGET_CHANGED" and (not name)) or not UnitIsFriend("player", "target") then
				self.Panel:Hide()
			elseif name then
				self.EndTime = expirationTime
				self.Duration = duration
				self.Panel:Show()
				self.Target = true
				self:SetScript("OnUpdate", UpdateBar)
			end
		end
	end


	WeakenedTargetFrame:SetScript("OnEvent", WeakenedTargetCheck)
	WeakenedTargetFrame:RegisterEvent("UNIT_AURA")
	WeakenedTargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
end

-- Weakened Soul bar on player when active.
if (TukuiCF["unitframes"].ws_show_player) then
	local WeakenedPlayerFrame = CreateFrame("Frame", _, oUF_Tukz_player)
	WeakenedPlayerFrame.Panel = BarPanel(TukuiDB.Scale(2), oUF_Tukz_player:GetWidth(), TukuiDB.Scale(0), TukuiDB.Scale(0), "BOTTOMLEFT", "BOTTOMLEFT",  oUF_Tukz_player, 1, WeakenedPlayerFrame, "HIGH")

	ConfigureBar(WeakenedPlayerFrame)
	-- Check for Weakened Soul on me and show bar if it is
	local function WeakenedPlayerCheck(self, event, unit, spell)
		if (unit == "player" and UnitDebuff("player", ws)) then
			local name, _, _, _, _, duration, expirationTime, unitCaster = UnitDebuff("player", ws)
			if name then
				self.EndTime = expirationTime
				self.Duration = duration
				self.Panel:Show()
				self.Player = true
				self:SetScript("OnUpdate", UpdateBar)
			end
		end
	end


	WeakenedPlayerFrame:SetScript("OnEvent", WeakenedPlayerCheck)
	WeakenedPlayerFrame:RegisterEvent("UNIT_AURA")
end
