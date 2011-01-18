if (select(2, UnitClass("player")) ~= "MAGE") then return end
 
-- grab skin function out of skin.lua
local function SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[TukuiDB.myclass]
	self:SetBackdropColor(color.r, color.g, color.b, 0.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
end

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
TukuiDB.CreatePanel(f,TukuiMinimap:GetWidth()+4,(#spells+1)*21+3, "TOPLEFT", TukuiMinimapStatsLeft, "BOTTOMLEFT", 0, -3)
f:SetFrameStrata("HIGH") --add
-- f:SetBackdropColor(0,0,0,0)
-- f:SetBackdropBorderColor(0,0,0,0)
 
local r = CreateFrame("Frame", nil, f)
TukuiDB.CreatePanel(r,TukuiMinimap:GetWidth(),20,"TOPLEFT",f,"TOPLEFT",2,-2)
local l = r:CreateFontString("TeleportMenuReagentText","OVERLAY",nil)
l:SetFont(TukuiCF["media"]["uffont"],12,"OUTLINE")
l:SetPoint("CENTER",r,"CENTER")
r:SetFrameStrata("HIGH") --add
 
for i,spell in pairs(spells) do
	local teleport = GetSpellInfo(spell[1])
 
	local b = CreateFrame("Button",nil,f,"SecureActionButtonTemplate")
	TukuiDB.CreatePanel(b,TukuiMinimap:GetWidth(),20, "TOPLEFT", f, "TOPLEFT", 2, -(i*21)-2)
	b:SetFrameStrata("HIGH") --add
 
	local l = b:CreateFontString(nil,"OVERLAY",nil)
	l:SetFont(TukuiCF["media"]["uffont"],12,"OUTLINE")
	l:SetText(string.sub(teleport, string.find(teleport,":")+1))
	b:SetFontString(l)
 
	b:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	b:SetAttribute("type1","spell")
	b:SetAttribute("spell1",teleport)
	b:SetAttribute("type2","spell")
	b:SetAttribute("spell2",GetSpellInfo(spell[2]))
	
	b:HookScript("OnEnter", SetModifiedBackdrop)
	b:HookScript("OnLeave", SetOriginalBackdrop)
end
f:Hide()
 
local b = CreateFrame("Button", nil, TukuiMinimapStatsLeft)
b:SetAllPoints(_G["TukuiMinimapStatsLeft"])
b:SetScript("OnClick",
	function(self)
		if _G["TukuiTeleportMenu"]:IsShown() then
			_G["TukuiTeleportMenu"]:Hide()
		else
			_G["TeleportMenuReagentText"]:SetText(panelcolor.."Teleport|r [ "..GetItemCount(17031).." ]"..panelcolor.." Portal|r [ "..GetItemCount(17032).." ]")
			_G["TukuiTeleportMenu"]:Show()
		end
	end);
 
f:RegisterEvent("UNIT_SPELLCAST_START")
f:SetScript("OnEvent",
	function(self)
		if self:IsShown() then
			self:Hide()
		end
	end)