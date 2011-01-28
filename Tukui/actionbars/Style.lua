if not TukuiCF["actionbar"].enable == true then return end

local _G = _G
local media = TukuiCF["media"]
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

local function style(self)
	local name = self:GetName()
	
	--> fixing a taint issue while changing totem flyout button in combat.
	if name:match("MultiCastActionButton") then return end 
	
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
 
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 
	Border:Hide()
	Border = TukuiDB.dummy
 
	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 0, TukuiDB.Scale(2))
	Count:SetFont(TukuiCF["media"].font, 12, "OUTLINE")
 
	if not _G[name.."Panel"] then
		-- resize all button not matching TukuiDB.buttonsize
		if self:GetHeight() ~= TukuiDB.buttonsize then
			self:SetSize(TukuiDB.buttonsize, TukuiDB.buttonsize)
		end

		-- create the bg/border panel
		local panel = CreateFrame("Frame", name.."Panel", self)
		TukuiDB.CreatePanel(panel, TukuiDB.buttonsize, TukuiDB.buttonsize, "CENTER", self, "CENTER", 0, 0)
 
		panel:SetFrameStrata(self:GetFrameStrata())
		panel:SetFrameLevel(self:GetFrameLevel() - 1)
 
		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:SetPoint("TOPLEFT", Button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
		Icon:SetPoint("BOTTOMRIGHT", Button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
	end

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 0, TukuiDB.Scale(-3))
	HotKey:SetFont(TukuiCF["media"].font, 12, "OUTLINE")
	HotKey.ClearAllPoints = TukuiDB.dummy
	HotKey.SetPoint = TukuiDB.dummy
 
	if not TukuiCF["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Hide()
		HotKey.Show = TukuiDB.dummy
	end
	if not TukuiCF["actionbar"].macrotext == true then
		Btname:SetText("")
		Btname:Hide()
		Btname.Show = TukuiDB.dummy
	end
 
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
	
	-- color border if equipped
    -- if IsEquippedAction(action) then
        -- _G[name.."Panel"]:SetBackdropBorderColor(0.55, 0.2, 0.2);
    -- else
        -- _G[name.."Panel"]:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor));
    -- end
end

local function stylesmallbutton(normal, button, icon, name, pet)
	local Flash	 = _G[name.."Flash"]
	button:SetNormalTexture("")
	
	-- another bug fix reported by Affli in t12 beta
	button.SetNormalTexture = TukuiDB.dummy
	
	Flash:SetTexture(media.buttonhover)
	
	if not _G[name.."Panel"] then
		button:SetWidth(TukuiDB.petbuttonsize)
		button:SetHeight(TukuiDB.petbuttonsize)
		
		local panel = CreateFrame("Frame", name.."Panel", button)
		TukuiDB.CreatePanel(panel, TukuiDB.petbuttonsize, TukuiDB.petbuttonsize, "CENTER", button, "CENTER", 0, 0)
		panel:SetBackdropColor(unpack(media.backdropcolor))
		panel:SetFrameStrata(button:GetFrameStrata())
		panel:SetFrameLevel(button:GetFrameLevel() - 1)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		if pet then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetWidth(TukuiDB.Scale(41))
			autocast:SetHeight(TukuiDB.Scale(40))
			autocast:ClearAllPoints()
			autocast:SetPoint("CENTER", button, 0, 0)
			icon:SetPoint("TOPLEFT", button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
			icon:SetPoint("BOTTOMRIGHT", button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
		else
			icon:SetPoint("TOPLEFT", button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
			icon:SetPoint("BOTTOMRIGHT", button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
		end
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function TukuiDB.StyleShift()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		stylesmallbutton(normal, button, icon, name)
		if TukuiCF["actionbar"].shapeshiftborder == true then
			button:SetSize(TukuiDB.buttonsize, TukuiDB.buttonsize)
		end
	end
end

function TukuiDB.StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		stylesmallbutton(normal, button, icon, name, true)
	end
end

local function updatehotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = replace(text, '(s%-)', 'S')
	text = replace(text, '(a%-)', 'A')
	text = replace(text, '(c%-)', 'C')
	text = replace(text, '(Mouse Button )', 'M')
	text = replace(text, '(Middle Mouse)', 'M3')
	text = replace(text, '(Num Pad )', 'N')
	text = replace(text, '(Page Up)', 'PU')
	text = replace(text, '(Page Down)', 'PD')
	text = replace(text, '(Spacebar)', 'SpB')
	text = replace(text, '(Insert)', 'Ins')
	text = replace(text, '(Home)', 'Hm')
	text = replace(text, '(Delete)', 'Del')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

-- rescale cooldown spiral to fix texture.
local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton", "MultiCastActionButton"}
for _, name in ipairs( buttonNames ) do
	for index = 1, 12 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]
 
		if ( button == nil or cooldown == nil ) then
			break
		end
		
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			style(_G["SpellFlyoutButton"..i])
			TukuiDB.StyleButton(_G["SpellFlyoutButton"..i], true)
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

-- Reposition flyout buttons depending on what tukui bar the button is parented to
local function FlyoutButtonPos(self, buttons, direction)
	for i=1, buttons do
		local parent = SpellFlyout:GetParent()
		if not _G["SpellFlyoutButton"..i] then return end
		
		if InCombatLockdown() then return end
 
		if direction == "LEFT" then
			if i == 1 then
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("RIGHT", parent, "LEFT", -4, 0)
			else
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("RIGHT", _G["SpellFlyoutButton"..i-1], "LEFT", -4, 0)
			end
		else
			if i == 1 then
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("BOTTOM", parent, "TOP", 0, 4)
			else
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("BOTTOM", _G["SpellFlyoutButton"..i-1], "TOP", 0, 4)
			end
		end
	end
end
 
--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function styleflyout(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
			arrowDistance = 5
	else
			arrowDistance = 2
	end
	
	if (self:GetParent() == MultiBarBottomRight and TukuiCF.actionbar.rightbars > 1) then
		self.FlyoutArrow:ClearAllPoints()
		self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
		SetClampedTextureRotation(self.FlyoutArrow, 270)
		FlyoutButtonPos(self,buttons,"LEFT")
	elseif (self:GetParent() == MultiBarLeft and not TukuiDB.lowversion and TukuiCF.actionbar.bottomrows == 2) then
		self.FlyoutArrow:ClearAllPoints()
		self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
		SetClampedTextureRotation(self.FlyoutArrow, 0)
		FlyoutButtonPos(self,buttons,"UP")	
	elseif not self:GetParent():GetParent() == "SpellBookSpellIconsFrame" then
		FlyoutButtonPos(self,buttons,"UP")
	end
end

-- rework the mouseover, pushed, checked texture to match Tukui theme.
do
	for i = 1, 12 do
		TukuiDB.StyleButton(_G["ActionButton"..i], true)
	end
	
	for i = 1, 12 do
		TukuiDB.StyleButton(_G["MultiBarBottomLeftButton"..i], true)
	end
	
	for i = 1, 12 do
		TukuiDB.StyleButton(_G["MultiBarBottomRightButton"..i], true)
	end
	
	for i = 1, 12 do
		TukuiDB.StyleButton(_G["MultiBarLeftButton"..i], true)
	end
	
	for i = 1, 12 do
		TukuiDB.StyleButton(_G["MultiBarRightButton"..i], true)
	end
	 
	for i=1, 10 do
		TukuiDB.StyleButton(_G["ShapeshiftButton"..i], true)
	end
	 
	for i=1, 10 do
		TukuiDB.StyleButton(_G["PetActionButton"..i], true)
	end
end

hooksecurefunc("ActionButton_Update", style)
hooksecurefunc("ActionButton_UpdateHotkeys", updatehotkey)
hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)

---------------------------------------------------------------
-- Totem Style, they need a lot more work than "normal" buttons
-- Because of this, we skin it via separate styling codes
-- Special thank's to DarthAndroid
---------------------------------------------------------------

-- don't continue executing code in this file is not playing a shaman.
if not TukuiDB.myclass == "SHAMAN" then return end

local TotemBar = CreateFrame("Frame")
TotemBar:RegisterEvent("PLAYER_LOGIN")
TotemBar:SetScript("OnEvent", function(self)
	TukuiDB.TotemOrientationDown = TukuiDB.TotemBarOrientation()
end)

-- Tex Coords for empty buttons
SLOT_EMPTY_TCOORDS = {
	[EARTH_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 3 / 256,
		bottom	= 33 / 256,
	},
	[FIRE_TOTEM_SLOT] = {
		left	= 67 / 128,
		right	= 97 / 128,
		top		= 100 / 256,
		bottom	= 130 / 256,
	},
	[WATER_TOTEM_SLOT] = {
		left	= 39 / 128,
		right	= 69 / 128,
		top		= 209 / 256,
		bottom	= 239 / 256,
	},
	[AIR_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 36 / 256,
		bottom	= 66 / 256,
	},
}

local function StyleTotemFlyout(flyout)
	-- remove blizzard flyout texture
	flyout.top:SetTexture(nil)
	flyout.middle:SetTexture(nil)
	
	-- Skin buttons
	local last = nil
	
	for _,button in ipairs(flyout.buttons) do
		TukuiDB.SetTemplate(button)
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:SetPoint("TOPLEFT",button,"TOPLEFT",TukuiDB.Scale(2),TukuiDB.Scale(-2))
		icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",TukuiDB.Scale(-2),TukuiDB.Scale(2))			
		if not InCombatLockdown() then
			button:SetSize(TukuiDB.Scale(30),TukuiDB.Scale(30))
			button:ClearAllPoints()
			if TukuiDB.TotemOrientationDown then
				button:SetPoint("TOP",last,"BOTTOM",0,TukuiDB.Scale(-4))
			else
				button:SetPoint("BOTTOM",last,"TOP",0,TukuiDB.Scale(4))
			end
		end			
		if button:IsVisible() then last = button end
		button:SetBackdropBorderColor(flyout.parent:GetBackdropBorderColor())
		TukuiDB.StyleButton(button)
	end
	
	if TukuiDB.TotemOrientationDown then
		flyout.buttons[1]:SetPoint("TOP",flyout,"TOP")
	else
		flyout.buttons[1]:SetPoint("BOTTOM",flyout,"BOTTOM")
	end
	
	if flyout.type == "slot" then
		local tcoords = SLOT_EMPTY_TCOORDS[flyout.parent:GetID()]
		flyout.buttons[1].icon:SetTexCoord(tcoords.left,tcoords.right,tcoords.top,tcoords.bottom)
	end
	
	-- Skin Close button
	local close = MultiCastFlyoutFrameCloseButton
	TukuiDB.SetTemplate(close)	
	close:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	close:GetHighlightTexture():SetPoint("TOPLEFT",close,"TOPLEFT",TukuiDB.Scale(1),TukuiDB.Scale(-1))
	close:GetHighlightTexture():SetPoint("BOTTOMRIGHT",close,"BOTTOMRIGHT",TukuiDB.Scale(-1),TukuiDB.Scale(1))
	close:GetNormalTexture():SetTexture(nil)
	close:ClearAllPoints()
	if TukuiDB.TotemOrientationDown then
		close:SetPoint("TOPLEFT",last,"BOTTOMLEFT",0,TukuiDB.Scale(-4))
		close:SetPoint("TOPRIGHT",last,"BOTTOMRIGHT",0,TukuiDB.Scale(-4))
	else
		close:SetPoint("BOTTOMLEFT",last,"TOPLEFT",0,TukuiDB.Scale(4))
		close:SetPoint("BOTTOMRIGHT",last,"TOPRIGHT",0,TukuiDB.Scale(4))	
	end
	close:SetHeight(4*2)
	
	flyout:ClearAllPoints()
	if TukuiDB.TotemOrientationDown then
		flyout:SetPoint("TOP",flyout.parent,"BOTTOM",0,TukuiDB.Scale(-4))
	else
		flyout:SetPoint("BOTTOM",flyout.parent,"TOP",0,TukuiDB.Scale(4))
	end
end
hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout",function(self) StyleTotemFlyout(self) end)
	
local function StyleTotemOpenButton(button, parent)
	button:GetHighlightTexture():SetTexture(nil)
	button:GetNormalTexture():SetTexture(nil)
	button:SetHeight(TukuiDB.Scale(16))
	button:ClearAllPoints()
	if TukuiDB.TotemOrientationDown then
		button:SetPoint("TOPLEFT", parent, "BOTTOMLEFT")
		button:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT")	
	else
		button:SetPoint("BOTTOMLEFT", parent, "TOPLEFT")
		button:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT")
	end
	if not button.visibleBut then
		button.visibleBut = CreateFrame("Frame",nil,button)
		button.visibleBut:SetHeight(TukuiDB.Scale(8))
		button.visibleBut:SetWidth(TukuiDB.Scale(button:GetWidth() + 2))
		button.visibleBut:SetPoint("CENTER")
		button.visibleBut.highlight = button.visibleBut:CreateTexture(nil,"HIGHLIGHT")
		button.visibleBut.highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		button.visibleBut.highlight:SetPoint("TOPLEFT",button.visibleBut,"TOPLEFT",TukuiDB.Scale(1),TukuiDB.Scale(-1))
		button.visibleBut.highlight:SetPoint("BOTTOMRIGHT",button.visibleBut,"BOTTOMRIGHT",TukuiDB.Scale(-1),TukuiDB.Scale(1))
		TukuiDB.SetTemplate(button.visibleBut)
	end	
end
hooksecurefunc("MultiCastFlyoutFrameOpenButton_Show",function(button,_, parent) StyleTotemOpenButton(button, parent) end)

-- the color we use for border
local bordercolors = {
	{.23,.45,.13},   -- Earth
	{.58,.23,.10},   -- Fire
	{.19,.48,.60},   -- Water
	{.42,.18,.74},   -- Air
}

local function StyleTotemSlotButton(button, index)
	TukuiDB.SetTemplate(button)
	button.overlayTex:SetTexture(nil)
	button.background:SetDrawLayer("ARTWORK")
	button.background:ClearAllPoints()
	button.background:SetPoint("TOPLEFT",button,"TOPLEFT",TukuiDB.Scale(2),TukuiDB.Scale(-2))
	button.background:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",TukuiDB.Scale(-2),TukuiDB.Scale(2))
	button:SetSize(30, 30)
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	TukuiDB.StyleButton(button)
end
hooksecurefunc("MultiCastSlotButton_Update",function(self, slot) StyleTotemSlotButton(self,tonumber( string.match(self:GetName(),"MultiCastSlotButton(%d)"))) end)

-- Skin the actual totem buttons
local function StyleTotemActionButton(button, index)
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:SetPoint("TOPLEFT",button,"TOPLEFT",TukuiDB.Scale(2),TukuiDB.Scale(-2))
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",TukuiDB.Scale(-2),TukuiDB.Scale(2))
	button.overlayTex:SetTexture(nil)
	button.overlayTex:Hide()
	button:GetNormalTexture():SetTexture(nil)
	button.SetNormalTexture = TukuiDB.dummy
	if not InCombatLockdown() and button.slotButton then
		button:ClearAllPoints()
		button:SetAllPoints(button.slotButton)
		button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
	end
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	button:SetBackdropColor(0,0,0,0)
	TukuiDB.StyleButton(button, true)
end
hooksecurefunc("MultiCastActionButton_Update",function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton,actionIndex) end)

-- Skin the summon and recall buttons
local function StyleTotemSpellButton(button, index)
	if not button then return end
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:SetPoint("TOPLEFT",button,"TOPLEFT",TukuiDB.Scale(2),TukuiDB.Scale(-2))
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",TukuiDB.Scale(-2),TukuiDB.Scale(2))
	TukuiDB.SetTemplate(button)
	button:GetNormalTexture():SetTexture(nil)
	if not InCombatLockdown() then button:SetSize(TukuiDB.Scale(30), TukuiDB.Scale(30)) end
	_G[button:GetName().."Highlight"]:SetTexture(nil)
	_G[button:GetName().."NormalTexture"]:SetTexture(nil)
	TukuiDB.StyleButton(button)
end
hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) StyleTotemSpellButton(self,0) end)
hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) StyleTotemSpellButton(self,5) end)