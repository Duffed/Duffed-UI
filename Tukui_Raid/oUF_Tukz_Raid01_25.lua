local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local font2 = C["media"].uffont
local font1 = C["media"].font
local fontsize = C["media"].uffontsize

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	self:SetBackdropColor(0.1, 0.1, 0.1)
	
	local health = CreateFrame('StatusBar', nil, self)
	health:Height(15)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetStatusBarTexture(C["media"].normTex)
	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture(C["media"].blank)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg
	
	health.PostUpdate = T.PostUpdatePetColor
	health.frequentUpdates = true
	
	if C.unitframes.unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
		health.bg:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
		health.bg:SetTexture(.6, .6, .6)	
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true	
		health.bg:SetTexture(.1, .1, .1)		
	end
	
	local power = CreateFrame("StatusBar", nil, self)
	power:Height(3)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -1)
	power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -1)
	power:SetStatusBarTexture(C["media"].normTex)
	self.Power = power
	
	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(C["media"].normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = 0.4
	self.Power.bg = power.bg
	
	if C.unitframes.unicolor == true then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end
		
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(font2, fontsize*T.raidscale, "THINOUTLINE")
	name:Point("LEFT", self, "RIGHT", 5, 0)
	if C["unitframes"].unicolor == true then
		self:Tag(name, '[Tukui:getnamecolor][Tukui:namemedium] [Tukui:dead][Tukui:afk]')
	else
		self:Tag(name, '[Tukui:namemedium] [Tukui:dead][Tukui:afk]')
	end
	self.Name = name
	
	if C["unitframes"].showsymbols == true then
		RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(14*T.raidscale)
		RaidIcon:Width(14*T.raidscale)
		RaidIcon:SetPoint("CENTER", self, "CENTER")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6*T.raidscale)
    LFDRole:Width(6*T.raidscale)
	LFDRole:Point("TOPLEFT", 2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12*T.raidscale)
	ReadyCheck:Width(12*T.raidscale)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	if C["unitframes"].showsmooth == true then
		health.Smooth = true
	end
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	local border = CreateFrame("Frame", nil, health)
	border:CreatePanel("Default", 1, 1, "TOPLEFT", health, "TOPLEFT", -2, 2)
	border:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2)
	border:CreateShadow("Default")
	self.panel = border

	return self
end

oUF:RegisterStyle('TukuiDpsP05R10R15R25', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsP05R10R15R25")

	local raid = self:SpawnHeader("oUF_TukuiDpsRaid05101525", nil, "custom [@raid26,exists] hide;show", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', T.Scale(140*T.raidscale),
		'initial-height', T.Scale(19*T.raidscale),	
		"showParty", true, "showPlayer", C["unitframes"].showplayerinparty, "showRaid", true, "groupFilter", "1,2,3,4,5,6,7,8", "groupingOrder", "1,2,3,4,5,6,7,8", "groupBy", "GROUP", "yOffset", T.Scale(-8)
	)
	if ChatBG1 then
		raid:SetPoint("BOTTOMLEFT", ChatBG1, "TOPLEFT", 2, 62)
	else
		raid:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 2, 77)
	end
	
	local pets = {} 
		pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
		pets[1]:SetPoint('BOTTOMLEFT', raid, 'TOPLEFT', 0, 24*T.raidscale)
		pets[1]:SetSize(T.Scale(140*T.raidscale), T.Scale(19*T.raidscale))
	for i =2, 4 do 
		pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
		pets[i]:SetPoint('BOTTOM', pets[i-1], 'TOP', 0, 8)
		pets[i]:SetSize(T.Scale(140*T.raidscale), T.Scale(19*T.raidscale))
	end
	
	local RaidMove = CreateFrame("Frame")
	RaidMove:RegisterEvent("PLAYER_LOGIN")
	RaidMove:RegisterEvent("RAID_ROSTER_UPDATE")
	RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
	RaidMove:RegisterEvent("PARTY_MEMBERS_CHANGED")
	RaidMove:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			local numraid = GetNumRaidMembers()
			local numparty = GetNumPartyMembers()
			if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
				for i,v in ipairs(pets) do v:Enable() end
			elseif numraid > 5 and numraid < 11 then
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 10 and numraid < 16 then
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 15 and numraid < 26 then
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 25 then
				for i,v in ipairs(pets) do v:Disable() end
			end
		end
	end)
end)