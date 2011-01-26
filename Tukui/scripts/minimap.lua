--------------------------------------------------------------------
-- Tukui Minimap Script
--------------------------------------------------------------------

local TukuiMinimap = CreateFrame("Frame", "TukuiMinimap", UIParent)
TukuiDB.CreatePanel(TukuiMinimap, 1, 1, "CENTER", UIParent, "CENTER", 0, 0)
TukuiMinimap:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiMinimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", TukuiDB.Scale(-9), TukuiDB.Scale(-9))
TukuiMinimap:SetSize(TukuiDB.Scale(144), TukuiDB.Scale(144))
TukuiMinimap:SetClampedToScreen(true)
TukuiMinimap:SetMovable(true)
TukuiDB.Kill(MinimapCluster)
TukuiMinimap.text = TukuiDB.SetFontString(TukuiMinimap, TukuiCF.media.uffont, 12)
TukuiMinimap.text:SetPoint("CENTER")
TukuiMinimap.text:SetText("Move Minimap")
TukuiDB.CreateShadow(TukuiMinimap)

-- Parent Minimap into our Map frame.
Minimap:SetParent(TukuiMinimap)
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
Minimap:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(2))

-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Tracking Button
MiniMapTracking:Hide()

-- Hide Calendar Button
GameTimeFrame:Hide()

-- Hide Mail Button
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, TukuiDB.Scale(3), TukuiDB.Scale(4))
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\mail")

-- Move battleground icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, TukuiDB.Scale(3), 0)
MiniMapBattlefieldBorder:Hide()

-- Hide world map button
MiniMapWorldMapButton:Hide()

-- shitty 3.3 flag to move
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- Reposition lfg icon at bottom-left
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(1))
	MiniMapLFGFrameBorder:Hide()
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)

-- reskin LFG dropdown
TukuiDB.SetTemplate(LFDSearchStatus)

-- for t13+, if we move map we need to point LFDSearchStatus according to our Minimap position.
local function UpdateLFGTooltip()
	local position = TukuiMinimap:GetPoint()
	LFDSearchStatus:ClearAllPoints()
	if position:match("BOTTOMRIGHT") then
		LFDSearchStatus:SetPoint("BOTTOMRIGHT", MiniMapLFGFrame, "BOTTOMLEFT", 0, 0)
	elseif position:match("BOTTOM") then
		LFDSearchStatus:SetPoint("BOTTOMLEFT", MiniMapLFGFrame, "BOTTOMRIGHT", 0, 0)
	elseif position:match("LEFT") then		
		LFDSearchStatus:SetPoint("TOPLEFT", MiniMapLFGFrame, "TOPRIGHT", 0, 0)
	else
		LFDSearchStatus:SetPoint("TOPRIGHT", MiniMapLFGFrame, "TOPLEFT", 0, 0)	
	end
end

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

-- Set Square Map Mask
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

-- For others mods with a minimap button, set minimap buttons position in square mode.
function GetMinimapShape() return 'SQUARE' end

-- do some stuff on addon loaded or player login event
TukuiMinimap:RegisterEvent("PLAYER_LOGIN")
TukuiMinimap:RegisterEvent("ADDON_LOADED")
TukuiMinimap:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_LOGIN" then
		UpdateLFGTooltip()
	elseif addon == "Blizzard_TimeManager" then
		-- Hide Game Time
		TukuiDB.Kill(TimeManagerClockButton)
	end
end)

----------------------------------------------------------------------------------------
-- Right click menu, used to show micro menu
----------------------------------------------------------------------------------------

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
    func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end if not GlyphFrame then LoadAddOn("Blizzard_GlyphUI") end PlayerTalentFrame_Toggle() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPFrame) end},
    {text = ACHIEVEMENTS_GUILD_TAB,
    func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)

----------------------------------------------------------------------------------------
-- Animation Coords and Current Zone. Awesome feature by AlleyKat.
----------------------------------------------------------------------------------------

-- Set Anim func
local set_anim = function (self,k,x,y)
	self.anim = self:CreateAnimationGroup("Move_In")
	self.anim.in_a = self.anim:CreateAnimation("Translation")
	self.anim.in_a:SetDuration(0)
	self.anim.in_a:SetOrder(1)
	self.anim.in_b = self.anim:CreateAnimation("Translation")
	self.anim.in_b:SetDuration(.3)
	self.anim.in_b:SetOrder(2)
	self.anim.in_b:SetSmoothing("OUT")
	self.anim_o = self:CreateAnimationGroup("Move_Out")
	self.anim_o.b = self.anim_o:CreateAnimation("Translation")
	self.anim_o.b:SetDuration(.3)
	self.anim_o.b:SetOrder(1)
	self.anim_o.b:SetSmoothing("IN")
	self.anim.in_a:SetOffset(x,y)
	self.anim.in_b:SetOffset(-x,-y)
	self.anim_o.b:SetOffset(x,y)
	if k then self.anim_o:SetScript("OnFinished",function() self:Hide() end) end
end
 
--Style Zone and Coord panels
local m_zone = CreateFrame("Frame",nil,UIParent)
TukuiDB.CreatePanel(m_zone, 0, 20, "TOPLEFT", Minimap, "TOPLEFT", TukuiDB.Scale(2),TukuiDB.Scale(-2))
m_zone:SetFrameLevel(5)
m_zone:SetFrameStrata("LOW")
m_zone:SetPoint("TOPRIGHT",Minimap,TukuiDB.Scale(-2),TukuiDB.Scale(-2))

set_anim(m_zone,true,0,TukuiDB.Scale(30))
m_zone:Hide()

local m_zone_text = m_zone:CreateFontString(nil,"Overlay")
m_zone_text:SetFont(TukuiCF["media"].font,12)
m_zone_text:SetPoint("TOP", 0, -TukuiDB.mult)
m_zone_text:SetPoint("BOTTOM")
m_zone_text:SetHeight(TukuiDB.Scale(12))
m_zone_text:SetWidth(m_zone:GetWidth()-6)

local m_coord = CreateFrame("Frame",nil,UIParent)
TukuiDB.CreatePanel(m_coord, 40, 20, "BOTTOMLEFT", Minimap, "BOTTOMLEFT", TukuiDB.Scale(2),TukuiDB.Scale(2))
m_coord:SetFrameStrata("LOW")

set_anim(m_coord,true,TukuiDB.Scale(90),0)
m_coord:Hide()	

local m_coord_text = m_coord:CreateFontString(nil,"Overlay")
m_coord_text:SetFont(TukuiCF["media"].font,12)
m_coord_text:SetPoint("Center",TukuiDB.Scale(-1),0)
m_coord_text:SetJustifyH("CENTER")
m_coord_text:SetJustifyV("MIDDLE")
 
-- Set Scripts and etc.
Minimap:SetScript("OnEnter",function()
	m_zone.anim_o:Stop()
	m_coord.anim_o:Stop()
	m_zone:Show()
	local x,y = GetPlayerMapPosition("player")
	if x ~= 0 and y ~= 0 then
		m_coord:Show()
		m_coord.anim:Play()
	end
	m_zone.anim:Play()
end)
 
Minimap:SetScript("OnLeave",function()
	m_coord.anim:Stop()
	m_coord.anim_o:Play()
	m_zone.anim:Stop()
	m_zone.anim_o:Play()
end)
 
m_coord_text:SetText("00,00")
 
local ela,go = 0,false
 
m_coord.anim:SetScript("OnFinished",function() go = true end)
m_coord.anim_o:SetScript("OnPlay",function() go = false end)
 
local coord_Update = function(self,t)
	ela = ela - t
	if ela > 0 or not(go) then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		m_coord_text:SetText("X _ X")
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		m_coord_text:SetText(xt..","..yt)
	end
	ela = .2
end
 
m_coord:SetScript("OnUpdate",coord_Update)
 
local zone_Update = function()
	local pvp = GetZonePVPInfo()
	m_zone_text:SetText(GetMinimapZoneText())
	if pvp == "friendly" then
		m_zone_text:SetTextColor(0.1, 1.0, 0.1)
	elseif pvp == "sanctuary" then
		m_zone_text:SetTextColor(0.41, 0.8, 0.94)
	elseif pvp == "arena" or pvp == "hostile" then
		m_zone_text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvp == "contested" then
		m_zone_text:SetTextColor(1.0, 0.7, 0.0)
	else
		m_zone_text:SetTextColor(1.0, 1.0, 1.0)
	end
end
 
m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent",zone_Update) 
 
local a,k = CreateFrame("Frame"),4
a:SetScript("OnUpdate",function(self,t)
	k = k - t
	if k > 0 then return end
	self:Hide()
	zone_Update()
end)

------------------------------------------------------------------------
-- make Minimap movable on screen
------------------------------------------------------------------------

local move = false
function TukuiMoveMinimap(msg)
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local anchor = TukuiMinimap
	anchor:SetUserPlaced(true)
	
	if msg == "reset" then
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", TukuiDB.Scale(-9), TukuiDB.Scale(-9))
	else
		if move == false then
			move = true
			Minimap:Hide()
			anchor:SetBackdropBorderColor(1,0,0,1)
			anchor:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
			anchor:EnableMouse(true)
			anchor:RegisterForDrag("LeftButton", "RightButton")
			anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
			anchor:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		elseif move == true then
			move = false
			Minimap:Show()
			anchor:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor))
			anchor:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
			anchor:EnableMouse(false)
			UpdateLFGTooltip()
		end
	end
end
SLASH_MOVEMINIMAP1 = "/mmm"
SlashCmdList["MOVEMINIMAP"] = TukuiMoveMinimap