local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Shapeshift Bar
---------------------------------------------------------------------------

-- used for anchor totembar or shapeshiftbar
local TukuiShift = CreateFrame("Frame","TukuiShiftBar",UIParent)
TukuiShift:SetPoint("TOPLEFT", 4, -46)
TukuiShift:SetSize((T.petbuttonsize * 5) + (T.petbuttonsize * 4), 20)
TukuiShift:SetFrameStrata("HIGH")
TukuiShift:SetMovable(true)
TukuiShift:SetClampedToScreen(true)

-- shapeshift command to move totem or shapeshift in-game
local ssmover = CreateFrame("Frame", "TukuiShapeShiftHolder", UIParent)
ssmover:SetAllPoints(TukuiShift)
ssmover:SetTemplate("Transparent")
ssmover:SetFrameStrata("HIGH")
ssmover:SetBackdropColor(0,0,0,.5)
ssmover:SetBackdropBorderColor(1,0,0)
ssmover:SetAlpha(0)
ssmover.text = T.SetFontString(ssmover, C.media.font, 12)
ssmover.text:SetPoint("CENTER")
ssmover.text:SetText(L.move_shapeshift)

-- hide it if not needed and stop executing code
if C.actionbar.hideshapeshift then TukuiShift:Hide() return end

-- create the shapeshift bar if we enabled it
local bar = CreateFrame("Frame", "TukuiShapeShift", TukuiShift, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetAllPoints(TukuiShift)

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
}

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			button:ClearAllPoints()
			button:SetParent(self)
			button:SetFrameStrata("LOW")
			if i == 1 then
				button:Point("BOTTOMLEFT", TukuiShift, 0, 24)
			else
				local previous = _G["ShapeshiftButton"..i-1]
				button:Point("LEFT", previous, "RIGHT", T.buttonspacing, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			end
		end
		RegisterStateDriver(self, "visibility", States[T.myclass] or "hide")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		local button
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
		T.TukuiShiftBarUpdate()
		ShapeShiftBorder:Size(((ShapeshiftButton1:GetWidth()+T.buttonspacing)*GetNumShapeshiftForms() )+ T.buttonspacing, ShapeshiftButton1:GetHeight()+ 2*T.buttonspacing)
	elseif event == "PLAYER_ENTERING_WORLD" then
		T.StyleShift()
		ShapeShiftBorder:Size(((ShapeshiftButton1:GetWidth()+T.buttonspacing)*GetNumShapeshiftForms() )+ T.buttonspacing, ShapeshiftButton1:GetHeight()+ 2*T.buttonspacing)
		
		-- Mouseover
		if C["actionbar"].shapeshiftmouseover == true then
			local function mouseover(alpha)
				for i = 1, NUM_SHAPESHIFT_SLOTS do
					local sb = _G["ShapeshiftButton"..i]
					sb:SetAlpha(alpha)
				end
			end
			
			for i = 1, NUM_SHAPESHIFT_SLOTS do		
				_G["ShapeshiftButton"..i]:SetAlpha(0)
				_G["ShapeshiftButton"..i]:HookScript("OnEnter", function(self) mouseover(1) end)
				_G["ShapeshiftButton"..i]:HookScript("OnLeave", function(self) mouseover(0) end)
			end
			ShapeShiftBorder:EnableMouse(true)
			ShapeShiftBorder:HookScript("OnEnter", function(self) mouseover(1) end)
			ShapeShiftBorder:HookScript("OnLeave", function(self) mouseover(0) end)
		end
	else
		T.TukuiShiftBarUpdate()
	end
end)

-- Border
local ssborder = CreateFrame("Frame", "ShapeShiftBorder", ShapeshiftButton1)
if C["actionbar"].shapeshiftborder ~= true then
	ssborder:SetAlpha(0)
else
	ssborder:SetTemplate("Default")
	ssborder:CreateShadow("Default")
end
ssborder:SetFrameLevel(1)
ssborder:SetFrameStrata("BACKGROUND")
ssborder:Point("LEFT", -T.buttonspacing, 0)