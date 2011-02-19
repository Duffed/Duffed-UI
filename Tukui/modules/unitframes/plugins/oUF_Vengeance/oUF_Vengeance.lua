local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C.unitframes.vengeancebar then return end
--[[
	Project.: oUF_Vengeance
	File....: oUF_Vengeance.lua
	Version.: 40000.4
	Rev Date: 05/12/2010
	Authors.: Shandrela [EU-Baelgun] <Bloodmoon>
]]

--[[
	Elements handled:
	 .Vengeance [frame]
	 .Vengeance.Text [fontstring]
		
	Code Example:
	 .Vengeance = CreateFrame("StatusBar", nil, self)
	 .Vengeance:SetWidth(400)
	 .Vengeance:SetHeight(20)
	 .Vengeance:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 100)
	 .Vengeance:SetStatusBarTexture(normTex)
	 .Vengeance:SetStatusBarColor(1,0,0)
	 
	Functions that can be overridden from within a layout:
	 - :OverrideText(value)
--]]

local addon, ns = ...
local oUF = oUF or ns.oUF

local _, class = UnitClass("player")
local vengeance = GetSpellInfo(93098)

local tooltip = CreateFrame("GameTooltip", "VengeanceTooltip", UIParent, "GameTooltipTemplate")
tooltip:SetOwner(UIParent, "ANCHOR_NONE")				

local function getTooltipText(...)
	local text = ""
	for i=1,select("#",...) do
		local rgn = select(i,...)
		if rgn and rgn:GetObjectType() == "FontString" then
			text = text .. (rgn:GetText() or "")
		end
	end
	return text
end

local function maxChanged(self, event, unit)
	if not unit == "player" then return end
	local bar = self.Vengeance
	
	local health = UnitHealthMax("player")
	local _, stamina = UnitStat("player", 3)
	
	bar.max = 0.1 * (health - 15 * stamina) + stamina
	bar:SetMinMaxValues(0, bar.max)
end

local lastdebugprint = 0
local function valueChanged(self)
	local bar = self.Vengeance
	
	if not bar.isTank then
		bar:Hide()
		return
	end
	
	local name = UnitAura("player", vengeance)
	
	if name then
		tooltip:ClearLines()
		tooltip:SetUnitBuff("player", name)
		local text = getTooltipText(tooltip:GetRegions())
		local value = tonumber(string.match(text,"%d+")) or 0
		
		if value > 0 then
			if value > bar.max then value = bar.max end
			
			bar:SetMinMaxValues(0, bar.max)
			bar:SetValue(value)
			bar:Show()
			TukuiThreatBar:Hide()
			
			if bar.Text then
				if bar.OverrideText then
					bar.Text:OverrideText(value)
				else
					bar.Text:SetText(value)
				end
			end
		else
			bar:Hide()
		end
	else
		bar:Hide()
	end
end

local function isTank(self, event)
	local masteryIndex = GetPrimaryTalentTree()
	local bar = self.Vengeance
	
	if masteryIndex then
		if class == "DRUID" and masteryIndex == 2 then
			local form = GetShapeshiftFormID()
			if form and form == BEAR_FORM then
				bar.isTank = true
			else
				bar.isTank = false
				bar:Hide()
			end
		elseif class == "DEATHKNIGHT" and masteryIndex == 1 then
			bar.isTank = true
		elseif class == "PALADIN" and masteryIndex == 2 then
			bar.isTank = true
		elseif class == "WARRIOR" and masteryIndex == 3 then
			bar.isTank = true
		else
			bar.isTank = false
			bar:Hide()
		end
	else
		bar.isTank = false
		bar:Hide()
	end
	
	-- little hack (for a bug i mentioned with my druid -.-)
	if event == "PLAYER_LOGIN" then bar:Hide() end
end

local function Enable(self, unit)
	local bar = self.Vengeance
	
	if bar and unit == "player" then
		self:RegisterEvent("UNIT_AURA", valueChanged)
		
		self:RegisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", maxChanged)
		
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", isTank)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", isTank)
		self:RegisterEvent("PLAYER_LOGIN", isTank)
		
		if class == "DRUID" then
			self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", isTank)
		end
		
		bar:Hide()
		
		return true
	end
end

local function Disable(self)
	local bar = self.Vengeance
	
	if bar then
		self:UnregisterEvent("UNIT_AURA", valueChanged)
		
		self:UnregisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", maxChanged)
		
		self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", isTank)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", isTank)
		self:UnregisterEvent("PLAYER_LOGIN", isTank)
		
		if class == "DRUID" then
			self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM", isTank)
		end
	end
end

oUF:AddElement("Vengeance", nil, Enable, Disable)