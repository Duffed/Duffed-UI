local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--Raid Utility by Elv22
--Create main frame
local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", UIParent)
RaidUtilityPanel:CreatePanel("Transparent", 170, (5*4) + (18*3), "TOP", UIParent, "TOP", -300, 0)
RaidUtilityPanel:CreateShadow("Default")
RaidUtilityPanel:Hide()
 
--Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if (UnitIsRaidOfficer("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end
 
--Change border when mouse is inside the button
local function ButtonEnter(self)
	local r,g,b = unpack(C["datatext"].color)
	self:SetBackdropBorderColor(r,g,b)
end
 
--Change border back to normal when mouse leaves button
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end
 
--Create button for when frame is hidden
local HiddenToggleButton = CreateFrame("Button", nil, UIParent)
HiddenToggleButton:Height(18)
HiddenToggleButton:Width(RaidUtilityPanel:GetWidth() / 1.5)
HiddenToggleButton:SetTemplate("Default")
HiddenToggleButton:Point("TOP", UIParent, "TOP", -300, -1)
HiddenToggleButton:SetScript("OnEnter", ButtonEnter)
HiddenToggleButton:SetScript("OnLeave", ButtonLeave)
HiddenToggleButton:SetScript("OnMouseUp", function(self)
	RaidUtilityPanel:Show()
	HiddenToggleButton:Hide()
end)
 
local HiddenToggleButtonText = HiddenToggleButton:CreateFontString(nil,"OVERLAY",HiddenToggleButton)
HiddenToggleButtonText:SetFont(C.media.font,12,"OUTLINE")
HiddenToggleButtonText:SetText("Raid Utility")
HiddenToggleButtonText:SetPoint("CENTER")
HiddenToggleButtonText:SetJustifyH("CENTER")
 
--Create button for when frame is shown
local ShownToggleButton = CreateFrame("Button", nil, RaidUtilityPanel)
ShownToggleButton:Height(18)
ShownToggleButton:Width(RaidUtilityPanel:GetWidth() / 2.5)
ShownToggleButton:SetTemplate("Default")
ShownToggleButton:Point("TOP", RaidUtilityPanel, "BOTTOM", 0, -1)
ShownToggleButton:SetScript("OnEnter", ButtonEnter)
ShownToggleButton:SetScript("OnLeave", ButtonLeave)
ShownToggleButton:SetScript("OnMouseUp", function(self)
	RaidUtilityPanel:Hide()
	HiddenToggleButton:Show()
end)
 
local ShownToggleButtonText = ShownToggleButton:CreateFontString(nil,"OVERLAY",ShownToggleButton)
ShownToggleButtonText:SetFont(C.media.font,12,"OUTLINE")
ShownToggleButtonText:SetText("Close")
ShownToggleButtonText:SetPoint("CENTER")
ShownToggleButtonText:SetJustifyH("CENTER")
 
--Disband Raid button
local DisbandRaidButton = CreateFrame("Button", nil, RaidUtilityPanel)
DisbandRaidButton:Height(18)
DisbandRaidButton:Width(RaidUtilityPanel:GetWidth() * 0.8)
DisbandRaidButton:SetTemplate("Default")
DisbandRaidButton:Point("TOP", RaidUtilityPanel, "TOP", 0, -5)
DisbandRaidButton:SetScript("OnEnter", ButtonEnter)
DisbandRaidButton:SetScript("OnLeave", ButtonLeave)
DisbandRaidButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		StaticPopup_Show("DISBAND_RAID")
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local DisbandRaidButtonText = DisbandRaidButton:CreateFontString(nil,"OVERLAY",DisbandRaidButton)
DisbandRaidButtonText:SetFont(C.media.font,12,"OUTLINE")
DisbandRaidButtonText:SetText("Disband Group")
DisbandRaidButtonText:SetPoint("CENTER")
DisbandRaidButtonText:SetJustifyH("CENTER")
 
--Role Check button
local RoleCheckButton = CreateFrame("Button", nil, RaidUtilityPanel)
RoleCheckButton:Height(18)
RoleCheckButton:Width(RaidUtilityPanel:GetWidth() * 0.8)
RoleCheckButton:SetTemplate("Default")
RoleCheckButton:Point("TOP", DisbandRaidButton, "BOTTOM", 0, -5)
RoleCheckButton:SetScript("OnEnter", ButtonEnter)
RoleCheckButton:SetScript("OnLeave", ButtonLeave)
RoleCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		InitiateRolePoll()
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local RoleCheckButtonText = RoleCheckButton:CreateFontString(nil,"OVERLAY",RoleCheckButton)
RoleCheckButtonText:SetFont(C.media.font,12,"OUTLINE")
RoleCheckButtonText:SetText(ROLE_POLL)
RoleCheckButtonText:SetPoint("CENTER")
RoleCheckButtonText:SetJustifyH("CENTER")
 
--Ready Check button
local ReadyCheckButton = CreateFrame("Button", nil, RaidUtilityPanel)
ReadyCheckButton:Height(18)
ReadyCheckButton:Width(RoleCheckButton:GetWidth() * 0.75)
ReadyCheckButton:SetTemplate("Default")
ReadyCheckButton:Point("TOPLEFT", RoleCheckButton, "BOTTOMLEFT", 0, -5)
ReadyCheckButton:SetScript("OnEnter", ButtonEnter)
ReadyCheckButton:SetScript("OnLeave", ButtonLeave)
ReadyCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		DoReadyCheck()
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local ReadyCheckButtonText = ReadyCheckButton:CreateFontString(nil,"OVERLAY",ReadyCheckButton)
ReadyCheckButtonText:SetFont(C.media.font,12,"OUTLINE")
ReadyCheckButtonText:SetText(READY_CHECK)
ReadyCheckButtonText:SetPoint("CENTER")
ReadyCheckButtonText:SetJustifyH("CENTER")
 
--World Marker button
local WorldMarkerButton = CreateFrame("Button", nil, RaidUtilityPanel)
WorldMarkerButton:Height(18)
WorldMarkerButton:Width(RoleCheckButton:GetWidth() * 0.2)
WorldMarkerButton:SetTemplate("Default")
WorldMarkerButton:Point("TOPRIGHT", RoleCheckButton, "BOTTOMRIGHT", 0, -5)
 
--Start Hack
--This will fuck up the points of some of the buttons on blizzard's raid frame manager
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAllPoints(WorldMarkerButton)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(WorldMarkerButton)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnEnter", function()
	local r,g,b = unpack(C["datatext"].color)
	WorldMarkerButton:SetBackdropColor(r,g,b, 0.15)
	WorldMarkerButton:SetBackdropBorderColor(r,g,b)
end)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnLeave", function()
	WorldMarkerButton:SetBackdropColor(unpack(C["media"].backdropcolor))
	WorldMarkerButton:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end)
--Remember boys & girls.. put back your toys when your done playing..
--Fix buttons that we screwed up, this isn't necessary but whatever..
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("RIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("RIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT")
--Hack Complete
 
local WorldMarkerButtonTexture = WorldMarkerButton:CreateTexture(nil,"OVERLAY",nil)
WorldMarkerButtonTexture:SetTexture("Interface\\RaidFrame\\Raid-WorldPing")
WorldMarkerButtonTexture:Point("TOPLEFT", WorldMarkerButton, "TOPLEFT", 1, -1)
WorldMarkerButtonTexture:Point("BOTTOMRIGHT", WorldMarkerButton, "BOTTOMRIGHT", -1, 1)
 
--Automatically show/hide the frame if we have RaidLeader or RaidOfficer
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:SetScript("OnEvent", function(self, event)
	if CheckRaidStatus() then
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	else
		--Hide Everything..
		HiddenToggleButton:Hide()
		RaidUtilityPanel:Hide()
	end
end)