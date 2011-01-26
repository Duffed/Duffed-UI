if not TukuiCF["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Shapeshift Bar
---------------------------------------------------------------------------

-- used for anchor totembar or shapeshiftbar
local TukuiShift = CreateFrame("Frame","TukuiShiftBar",UIParent)
TukuiShift:SetPoint("TOPLEFT", 2, -2)
TukuiShift:SetWidth(29)
TukuiShift:SetHeight(58)

-- shapeshift command to move totem or shapeshift in-game
local ssmover = CreateFrame("Frame", "ssmoverholder", UIParent)
ssmover:SetAllPoints(TukuiShift)
TukuiDB.SetTemplate(ssmover)
ssmover:SetBackdropBorderColor(1,0,0)
ssmover:SetAlpha(0)
TukuiShift:SetMovable(true)
TukuiShift:SetClampedToScreen(true) 

-- hide it if not needed and stop executing code
if TukuiCF.actionbar.hideshapeshift then TukuiShift:Hide() return end

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
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", TukuiShift, 0, TukuiDB.Scale(29))
			else
				local previous = _G["ShapeshiftButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", TukuiDB.buttonspacing, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			end		
		end
		RegisterStateDriver(self, "visibility", States[TukuiDB.myclass] or "hide")
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
		TukuiDB.TukuiShiftBarUpdate()
		ShapeShiftBorder:SetSize(((ShapeshiftButton1:GetWidth()+TukuiDB.buttonspacing)*GetNumShapeshiftForms())+TukuiDB.Scale(4), ShapeshiftButton1:GetHeight()+TukuiDB.Scale(8))
	elseif event == "PLAYER_ENTERING_WORLD" then
		TukuiDB.StyleShift()
		ShapeShiftBorder:SetSize(((ShapeshiftButton1:GetWidth()+TukuiDB.buttonspacing)*GetNumShapeshiftForms())+TukuiDB.Scale(4), ShapeshiftButton1:GetHeight()+TukuiDB.Scale(8))

		-- Mouseover
		if TukuiCF["actionbar"].shapeshiftmouseover == true then
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
		TukuiDB.TukuiShiftBarUpdate()
	end
end)

-- Border
local ssborder = CreateFrame("Frame", "ShapeShiftBorder", ShapeshiftButton1)
if TukuiCF["actionbar"].shapeshiftborder ~= true then -- this config entry isnt added yet ..you can if u want and ..read this :>
	ssborder:SetAlpha(0)
else
	TukuiDB.SetTemplate(ssborder)
	TukuiDB.CreateShadow(ssborder)
end
ssborder:SetFrameLevel(1)
ssborder:SetFrameStrata("BACKGROUND")
ssborder:SetPoint("LEFT", TukuiDB.Scale(-4), 0)
-----------------------------------------------------------
-- make shapeshift bar movable
-----------------------------------------------------------

local move = false
function TukuiMoveShapeshift(msg)
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	TukuiShift:SetUserPlaced(true)
	
	if msg == "reset" then
		TukuiShift:ClearAllPoints()
		TukuiShift:SetPoint("TOPLEFT", UIParent, 2, -2)
	else
		if move == false then
			move = true
			ssmover:SetAlpha(1)
			TukuiShift:EnableMouse(true)
			TukuiShift:RegisterForDrag("LeftButton", "RightButton")
			TukuiShift:SetScript("OnDragStart", function(self) self:StartMoving() end)
			TukuiShift:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		elseif move == true then
			move = false
			ssmover:SetAlpha(0)
			TukuiShift:EnableMouse(false)
			
			-- used for shaman totembar update
			if TukuiDB.myclass == "SHAMAN" then
				TukuiDB.TotemOrientationDown = TukuiDB.TotemBarOrientation()
			end
		end
	end
end
SLASH_SHOWMOVEBUTTON1 = "/mss"
SlashCmdList["SHOWMOVEBUTTON"] = TukuiMoveShapeshift