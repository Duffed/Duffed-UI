local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarRight as bar #4
---------------------------------------------------------------------------

local bar = TukuiBar3
MultiBarLeft:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarLeftButton"..i]
	local b2 = _G["MultiBarLeftButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, T.buttonspacing, -T.buttonspacing)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
	end
end

---------------------------------------------------------------------------
-- setup MultiBarBottomRight as bar #5
---------------------------------------------------------------------------

local bar = TukuiBar3
MultiBarRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarRightButton"..i]
	local b2 = _G["MultiBarRightButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(13)
	
	if i == 1 then
		b:SetPoint("TOPRIGHT", bar, -T.buttonspacing, -T.buttonspacing)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
	end
end

---------------------------------------------------------------------------
-- Mouseover
---------------------------------------------------------------------------
if C["actionbar"].rightbarsmouseover ~= true then return end

-- Frame i created cause mouseover rightbars sux if it fades out when ur mouse is behind (right) of them .. 
local rbmoh = CreateFrame("Frame", nil, TukuiBar3)
rbmoh:Point("RIGHT", UIParent, "RIGHT", 0, -14)
rbmoh:SetSize(24, (T.buttonsize * 12) + (T.buttonspacing * 13))

function TukuiRightBarsMouseover(alpha)
	TukuiBar3:SetAlpha(alpha)
	TukuiBar3Button2:SetAlpha(alpha)
	TukuiBar3Button:SetAlpha(alpha)
	MultiBarRight:SetAlpha(alpha)
	MultiBarLeft:SetAlpha(alpha)
	if C["actionbar"].petbarhorizontal ~= true then TukuiLineToPetActionBarBackground:SetAlpha(alpha) end
	if C["actionbar"].petbaralwaysvisible ~= true and C["actionbar"].petbarhorizontal ~= true then
		TukuiPetBar:SetAlpha(alpha)
		for i=1, NUM_PET_ACTION_SLOTS do
			_G["PetActionButton"..i]:SetAlpha(alpha)
		end
	end
end

local function mouseover(f)
	f:EnableMouse(true)
	f:SetAlpha(0)
	f:HookScript("OnEnter", function() TukuiRightBarsMouseover(1) end)
	f:HookScript("OnLeave", function() TukuiRightBarsMouseover(0) end)
end
mouseover(TukuiBar3)
mouseover(rbmoh)
if C["actionbar"].petbarhorizontal ~= true then mouseover(TukuiLineToPetActionBarBackground) end

for i = 1, 12 do
	_G["MultiBarRightButton"..i]:EnableMouse(true)
	_G["MultiBarRightButton"..i]:HookScript("OnEnter", function() TukuiRightBarsMouseover(1) end)
	_G["MultiBarRightButton"..i]:HookScript("OnLeave", function() TukuiRightBarsMouseover(0) end)
	
	_G["MultiBarLeftButton"..i]:EnableMouse(true)
	_G["MultiBarLeftButton"..i]:HookScript("OnEnter", function() TukuiRightBarsMouseover(1) end)
	_G["MultiBarLeftButton"..i]:HookScript("OnLeave", function() TukuiRightBarsMouseover(0) end)
end

if C["actionbar"].petbaralwaysvisible ~= true and C["actionbar"].petbarhorizontal ~= true then
	for i = 1, NUM_PET_ACTION_SLOTS do
		_G["PetActionButton"..i]:EnableMouse(true)
		_G["PetActionButton"..i]:HookScript("OnEnter", function() TukuiRightBarsMouseover(1) end)
		_G["PetActionButton"..i]:HookScript("OnLeave", function() TukuiRightBarsMouseover(0) end)
	end
	mouseover(TukuiPetBar)
else
	TukuiLineToPetActionBarBackground:Hide()
end