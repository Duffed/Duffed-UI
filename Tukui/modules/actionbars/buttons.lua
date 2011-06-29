local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- This is the file for our action bars settings in game via mouseover buttons around action bars.
-- I really hope you'll understand the code, because I was totally drunk when I wrote this file.
-- At least, it work fine. :P (lol)
local cp = "|cff319f1b" -- +
local cm = "|cff9a1212" -- -
local function ShowOrHideBar(bar, button)
	local db = TukuiDataPerChar
	
	if bar:IsShown() then
		if bar == TukuiBar2 then
			if button == TukuiBar2Button then
				bar:Hide()
				db.hidebar2 = true
			end
		end
		if bar == TukuiBar3 then
			if button == TukuiBar3Button then
				if C["actionbar"].petbarhorizontal ~= true then TukuiLineToPetActionBarBackground:Show() end
				if db.rightbars == 1 then
					MultiBarRight:Show()
					db.rightbars = 2
					bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
				elseif db.rightbars == 2 then
					MultiBarRight:Hide()
					db.rightbars = 1
					bar:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
				end
			elseif button == TukuiBar3Button2 then
				if C["actionbar"].petbarhorizontal ~= true then TukuiLineToPetActionBarBackground:Hide() end
				db.rightbars = 0
				bar:Hide()
			end
		end
	else
		bar:Show()
		if bar == TukuiBar2 then
			db.hidebar2 = false
		end
		if bar == TukuiBar3 then
			if button == TukuiBar3Button then
				bar:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
				MultiBarRight:Hide()
				db.rightbars = 1
				if C["actionbar"].petbarhorizontal ~= true then TukuiLineToPetActionBarBackground:Show() end
			end
		end
	end
end

local function MoveButtonBar(button, bar)
	local db = TukuiDataPerChar
	
	if button == TukuiBar2Button then
		T.petBarPosition()
		T.cbPosition()
		if bar:IsShown() then
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
		end
	end

	if button == TukuiBar3Button then
		if bar:IsShown() then
			if db.rightbars == 2 and button == TukuiBar3Button then
				button.text:SetText(cm..">|r")
				TukuiBar3Button2:Hide()
				button:Height(130)
				button:ClearAllPoints()
				button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
				if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((T.buttonsize * 2) + (T.buttonspacing * 3)), -14) end
			elseif db.rightbars == 1 then
				TukuiBar3Button2:Show()
				button:Height(130/2)
				button:ClearAllPoints()
				button:Point("BOTTOMRIGHT", UIParent, "RIGHT", 1, -14)
				button.text:SetText(cp.."<|r")
				if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((T.buttonsize * 1) + (T.buttonspacing * 2)), -14) end
			end
		else
		end
	elseif button == TukuiBar3Button2 then
		if db.rightbars == 0 then
			button:Hide()
			TukuiBar3Button:Height(130)
			TukuiBar3Button:ClearAllPoints()
			TukuiBar3Button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
			if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -14, -14) end
		end
	end
end

local function DrPepper(self, bar) -- guess what! :P
	-- yep, you cannot drink DrPepper while in combat. :(
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local button = self
	
	ShowOrHideBar(bar, button)
	MoveButtonBar(button, bar)
end

-- +/-
local TukuiBar2Button = CreateFrame("Button", "TukuiBar2Button", UIParent)
TukuiBar2Button:SetTemplate("Default")
TukuiBar2Button:CreateShadow("Default")
TukuiBar2Button:RegisterForClicks("AnyUp")
TukuiBar2Button.text = T.SetFontString(TukuiBar2Button, C.datatext.font, C.datatext.fontsize)
TukuiBar2Button:SetScript("OnClick", function(self, btn)
	if btn == "RightButton" then
		if TukuiInfoLeftBattleGround and UnitInBattleground("player") then
			ToggleFrame(TukuiInfoLeftBattleGround)
		end
	else
		DrPepper(self, TukuiBar2)
	end
end)
if T.lowversion then
	TukuiBar2Button:Size(TukuiInfoLeft:GetHeight())
	TukuiBar2Button:Point("LEFT", TukuiInfoLeft, "RIGHT", 3, 0)
	TukuiBar2Button.text:Point("CENTER", 1, 0)
else
	TukuiBar2Button:Point("TOPLEFT", TukuiInfoLeft, "TOPRIGHT", 2, 0)
	TukuiBar2Button:Point("BOTTOMRIGHT", TukuiInfoRight, "BOTTOMLEFT", -2, 0)
	TukuiBar2Button.text:Point("CENTER", 0, 0)
end
if C["actionbar"].hideplusminus == true then
	TukuiBar2Button:SetAlpha(0)
else
	TukuiBar2Button:SetAlpha(1)
end
TukuiBar2Button:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(C.datatext.color)) end)
TukuiBar2Button:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
TukuiBar2Button.text:SetText(cm.."-|r")

-- >/< 1
local TukuiBar3Button = CreateFrame("Button", "TukuiBar3Button", UIParent)
TukuiBar3Button:Width(12)
TukuiBar3Button:Height(130)
TukuiBar3Button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
TukuiBar3Button:SetTemplate("Default")
TukuiBar3Button:RegisterForClicks("AnyUp")
TukuiBar3Button:SetAlpha(0)
TukuiBar3Button:SetScript("OnClick", function(self) DrPepper(self, TukuiBar3) end)
if C["actionbar"].rightbarsmouseover == true then
	TukuiBar3Button:SetScript("OnEnter", function(self) TukuiRightBarsMouseover(1) end)
	TukuiBar3Button:SetScript("OnLeave", function(self) TukuiRightBarsMouseover(0) end)
else
	TukuiBar3Button:SetScript("OnEnter", function(self) self:SetAlpha(1) TukuiBar3Button2:SetAlpha(1) end)
	TukuiBar3Button:SetScript("OnLeave", function(self) self:SetAlpha(0) TukuiBar3Button2:SetAlpha(0) end)
end
TukuiBar3Button.text = T.SetFontString(TukuiBar3Button, C.media.font, 14)
TukuiBar3Button.text:Point("CENTER", 0, 0)
TukuiBar3Button.text:SetText(cm..">|r")

-- >/< 2
local TukuiBar3Button2 = CreateFrame("Button", "TukuiBar3Button2", UIParent)
TukuiBar3Button2:Width(TukuiBar3Button:GetWidth())
TukuiBar3Button2:Height((TukuiBar3Button:GetHeight()/2)+1)
TukuiBar3Button2:Point("TOP", TukuiBar3Button, "BOTTOM", 0, 1)
TukuiBar3Button2:SetTemplate("Default")
TukuiBar3Button2:RegisterForClicks("AnyUp")
TukuiBar3Button2:SetAlpha(0)
TukuiBar3Button2:Hide()
TukuiBar3Button2:SetScript("OnClick", function(self) DrPepper(self, TukuiBar3) end)
if C["actionbar"].rightbarsmouseover == true then
	TukuiBar3Button2:SetScript("OnEnter", function(self) TukuiRightBarsMouseover(1) end)
	TukuiBar3Button2:SetScript("OnLeave", function(self) TukuiRightBarsMouseover(0) end)
else
	TukuiBar3Button2:SetScript("OnEnter", function(self) self:SetAlpha(1) TukuiBar3Button:SetAlpha(1) end)
	TukuiBar3Button2:SetScript("OnLeave", function(self) self:SetAlpha(0) TukuiBar3Button:SetAlpha(0) end)
end
TukuiBar3Button2.text = T.SetFontString(TukuiBar3Button2, C.media.font, 14)
TukuiBar3Button2.text:Point("CENTER", 0, 0)
TukuiBar3Button2.text:SetText(cm..">|r")

-- exit vehicle button on right side of bottom action bar
local exitvehicle = CreateFrame("Button", "TukuiExitVehicleButton", UIParent, "SecureHandlerClickTemplate")
exitvehicle:CreatePanel("Default", T.buttonsize, T.buttonsize, "LEFT", TukuiBar1, "RIGHT", 5, 0)
exitvehicle:RegisterForClicks("AnyUp")
exitvehicle:SetScript("OnClick", function() VehicleExit() end)
exitvehicle:CreateShadow("Default")
exitvehicle.text = T.SetFontString(exitvehicle, C.media.font, 19)
exitvehicle.text:Point("CENTER", 1, 1)
exitvehicle.text:SetText(cm.."v|r")
RegisterStateDriver(exitvehicle, "visibility", "[target=vehicle,exists] show;hide")

local exitvehicle2 = CreateFrame("Button", "TukuiExitVehicleButton2", UIParent, "SecureHandlerClickTemplate")
exitvehicle2:CreatePanel("Default", T.buttonsize, T.buttonsize, "RIGHT", TukuiBar1, "LEFT", -5, 0)
exitvehicle2:RegisterForClicks("AnyUp")
exitvehicle2:SetScript("OnClick", function() VehicleExit() end)
exitvehicle2:CreateShadow("Default")
exitvehicle2.text = T.SetFontString(exitvehicle2, C.media.font, 19)
exitvehicle2.text:Point("CENTER", 1, 1)
exitvehicle2.text:SetText(cm.."v|r")
RegisterStateDriver(exitvehicle2, "visibility", "[target=vehicle,exists] show;hide")

--------------------------------------------------------------
-- DrPepper taste is really good with Vodka. 
--------------------------------------------------------------

local init = CreateFrame("Frame")
init:RegisterEvent("VARIABLES_LOADED")
init:SetScript("OnEvent", function(self, event)
	if not TukuiDataPerChar then TukuiDataPerChar = {} end
	local db = TukuiDataPerChar
	if db.hidebar2 == nil and T.lowversion then db.hidebar2 = true end
	
	T.cbPosition()
	T.petBarPosition()
	
	-- Third Bar at the bottom
	if db.hidebar2 then
		DrPepper(TukuiBar2Button, TukuiBar2)
	end
	
	-- Rightbars on startup
	if db.rightbars == nil then db.rightbars = 2 end
	if db.rightbars == 1 then
		MoveButtonBar(TukuiBar3Button, TukuiBar3)
		TukuiBar3:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
		if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((T.buttonsize * 1) + (T.buttonspacing * 2)), -14) TukuiLineToPetActionBarBackground:Show() end
	elseif db.rightbars == 0 then
		TukuiBar3Button.text:SetText(cp.."<|r")
		TukuiBar3:Hide()
		if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -14, -14) TukuiLineToPetActionBarBackground:Hide() end
	elseif db.rightbars == 2 then
		if C["actionbar"].petbarhorizontal ~= true then TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((T.buttonsize * 2) + (T.buttonspacing * 3)), -14) TukuiLineToPetActionBarBackground:Show() end
	end
end)