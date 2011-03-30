if (select(2, UnitClass("player")) ~= "MAGE") or not TukuiMinimapStatsLeft then return end
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local spells = (UnitFactionGroup("player") == "Horde") and {
	--  Tepelort id, Portal id
	[1] = {53140,53142}, -- Dalaran
	[2] = {3567,11417}, -- Orgrimmar
	[3] = {3563,11418}, -- Undercity
	[4] = {3566,11420}, -- Thunder Bluff
	[5] = {32272,32267}, -- Silvermoon
	[6] = {35715,35717}, -- Shattrath
	[7] = {49358,49361}, -- Stonard
	[8] = {88342,88345}, -- Tol Barad
} or { -- ALLIANCE
	[1] = {53140,53142}, -- Dalaran
	[2] = {3561,10059}, -- Stormwind
	[3] = {3562,11416}, -- Ironforge
	[4] = {3565,11419}, -- Darnassus
	[5] = {32271,32266}, -- Exodar
	[6] = {33690,33691}, -- Shattrath
	[7] = {49359,49360}, -- Theramore
	[8] = {88342,88345}, -- Tol Barad
};
 
local f = CreateFrame("Frame","TukuiTeleportMenu",UIParent)
f:CreatePanel("Default",TukuiMinimap:GetWidth(),(#spells+1)*21+3, "TOPLEFT", TukuiMinimapStatsLeft, "BOTTOMLEFT", 0, -3)
f:SetFrameStrata("HIGH")
f:CreateShadow("Default")
 
local r = CreateFrame("Frame", nil, f)
r:CreatePanel("Default",TukuiMinimap:GetWidth()-4,20,"TOPLEFT",f,"TOPLEFT",2,-2)
local l = r:CreateFontString("TeleportMenuReagentText","OVERLAY")
l:SetFont(C.datatext.font, C.datatext.fontsize, "THINOUTLINE")
l:SetPoint("CENTER",r,"CENTER")
r:SetFrameStrata("HIGH") 
 
for i,spell in pairs(spells) do
	local teleport = GetSpellInfo(spell[1])
 
	local b = CreateFrame("Button",nil,f,"SecureActionButtonTemplate")
	b:CreatePanel("Default",TukuiMinimap:GetWidth()-4,20, "TOPLEFT", f, "TOPLEFT", 2, -(i*21)-2)
	b:SetFrameStrata("HIGH") 
 
	local l = b:CreateFontString(nil,"OVERLAY")
	l:SetFont(C.datatext.font, C.datatext.fontsize, "THINOUTLINE")
	l:SetText(string.sub(teleport, string.find(teleport,":")+1))
	b:SetFontString(l)
 
	b:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	b:SetAttribute("type1","spell")
	b:SetAttribute("spell1",teleport)
	b:SetAttribute("type2","spell")
	b:SetAttribute("spell2",GetSpellInfo(spell[2]))
	
	b:HookScript("OnEnter", function(self)
		local r,g,b = unpack(C["datatext"].color)
		self:SetBackdropColor(r,g,b, 0.15)
		self:SetBackdropBorderColor(r,g,b)
	end)

	b:HookScript("OnLeave", function(self)
		self:SetBackdropColor(unpack(C["media"].backdropcolor))
		self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
	end)
end
f:Hide()
 
local b = CreateFrame("Button", nil, TukuiMinimapStatsLeft)
b:SetAllPoints(TukuiMinimapStatsLeft)
b:SetScript("OnClick", function(self)
	if TukuiTeleportMenu:IsShown() then
		TukuiTeleportMenu:Hide()
	else
		TeleportMenuReagentText:SetText(T.panelcolor.."Teleport|r [ "..GetItemCount(17031).." ]"..T.panelcolor.." Portal|r [ "..GetItemCount(17032).." ]")
		TukuiTeleportMenu:Show()
	end
end)
 
f:RegisterEvent("UNIT_SPELLCAST_START")
f:SetScript("OnEvent",
	function(self)
	if self:IsShown() then
		self:Hide()
	end
end)