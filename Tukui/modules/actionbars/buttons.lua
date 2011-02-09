local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- This is the file for our action bars settings in game via mouseover buttons around action bars.
-- I really hope you'll understand the code, because I was totally drunk when I wrote this file.
-- At least, it work fine. :P (lol)

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
				TukuiLineToPetActionBarBackground:Show()
				if bar:GetWidth() > ((T.buttonsize * 1) + (T.buttonspacing * 2)) and bar:GetWidth() < ((T.buttonsize * 2) + (T.buttonspacing * 3)) then
					MultiBarRight:Show()
					db.rightbars = 2
					bar:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
				elseif bar:GetWidth() > ((T.buttonsize * 2) + (T.buttonspacing * 3)) then
					MultiBarRight:Hide()
					db.rightbars = 1
					bar:SetWidth((T.buttonsize * 1) + (T.buttonspacing * 2))
				end
			elseif button == TukuiBar3Button2 then
				TukuiLineToPetActionBarBackground:Hide()
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
				TukuiLineToPetActionBarBackground:Show()
			end
		end
	end
end

local function MoveButtonBar(button, bar)
	local db = TukuiDataPerChar
	
	if button == TukuiBar2Button then
		T.cbPosition()
		if bar:IsShown() then
			button.text:SetText(T.panelcolor.."-|r")
		else
			button.text:SetText(T.panelcolor.."+|r")
		end
	end

	if button == TukuiBar3Button then
		if bar:IsShown() then
			if db.rightbars == 2 and button == TukuiBar3Button then
				button.text:SetText(T.panelcolor..">|r")
				TukuiBar3Button2:Hide()
				button:Height(130)
				button:ClearAllPoints()
				button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
				TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -36 -((T.buttonsize * 2) + (T.buttonspacing * 3)), -14)
			elseif db.rightbars == 1 then
				TukuiBar3Button2:Show()
				button:Height(130/2)
				button:ClearAllPoints()
				button:Point("BOTTOMRIGHT", UIParent, "RIGHT", 1, -14)
				button.text:SetText(T.panelcolor.."<|r")
				TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -36 -((T.buttonsize * 1) + (T.buttonspacing * 2)), -14)
			end
		else
		end
	elseif button == TukuiBar3Button2 then
		if db.rightbars == 0 then
			button:Hide()
			TukuiBar3Button:Height(130)
			TukuiBar3Button:ClearAllPoints()
			TukuiBar3Button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
			TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -23, -14)
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

local TukuiBar2Button = CreateFrame("Button", "TukuiBar2Button", UIParent)
TukuiBar2Button:Point("TOPLEFT", TukuiInfoLeft, "TOPRIGHT", 2, 0)
TukuiBar2Button:Point("BOTTOMRIGHT", TukuiInfoRight, "BOTTOMLEFT", -2, 0)
TukuiBar2Button:SetTemplate("Default")
TukuiBar2Button:CreateShadow("Default")
TukuiBar2Button:RegisterForClicks("AnyUp")
TukuiBar2Button:SetAlpha(0)
TukuiBar2Button:SetScript("OnClick", function(self) DrPepper(self, TukuiBar2) end)
TukuiBar2Button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
TukuiBar2Button:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
TukuiBar2Button.text = T.SetFontString(TukuiBar2Button, C.media.font, 17)
TukuiBar2Button.text:Point("CENTER", 0, -1)
TukuiBar2Button.text:SetText(T.panelcolor.."-|r")

local TukuiBar3Button = CreateFrame("Button", "TukuiBar3Button", UIParent)
TukuiBar3Button:Width(20)
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
TukuiBar3Button.text = T.SetFontString(TukuiBar3Button, C.media.font, 19)
TukuiBar3Button.text:Point("CENTER", 0, 0)
TukuiBar3Button.text:SetText(T.panelcolor..">|r")

local TukuiBar3Button2 = CreateFrame("Button", "TukuiBar3Button2", UIParent)
TukuiBar3Button2:Width(20)
TukuiBar3Button2:Height(132/2)
TukuiBar3Button2:Point("TOPRIGHT", UIParent, "RIGHT", 1, -13)
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
TukuiBar3Button2.text = T.SetFontString(TukuiBar3Button2, C.media.font, 19)
TukuiBar3Button2.text:Point("CENTER", 0, 0)
TukuiBar3Button2.text:SetText(T.panelcolor..">|r")

-- exit vehicle button on right side of bottom action bar
local exitvehicle = CreateFrame("Button", "TukuiExitVehicleButton", UIParent, "SecureHandlerClickTemplate")
exitvehicle:CreatePanel("Default", T.buttonsize, T.buttonsize, "LEFT", TukuiBar1, "RIGHT", 5, 0)
exitvehicle:SetBackdropBorderColor(unpack(C["datatext"].color))
exitvehicle:RegisterForClicks("AnyUp")
exitvehicle:SetScript("OnClick", function() VehicleExit() end)
exitvehicle:CreateShadow("Default")
exitvehicle.text = T.SetFontString(exitvehicle, C.media.font, 19)
exitvehicle.text:Point("CENTER", 1, 1)
exitvehicle.text:SetText(T.panelcolor.."v|r")
RegisterStateDriver(exitvehicle, "visibility", "[target=vehicle,exists] show;hide")

local exitvehicle2 = CreateFrame("Button", "TukuiExitVehicleButton2", UIParent, "SecureHandlerClickTemplate")
exitvehicle2:CreatePanel("Default", T.buttonsize, T.buttonsize, "RIGHT", TukuiBar1, "LEFT", -5, 0)
exitvehicle2:SetBackdropBorderColor(unpack(C["datatext"].color))
exitvehicle2:RegisterForClicks("AnyUp")
exitvehicle2:SetScript("OnClick", function() VehicleExit() end)
exitvehicle2:CreateShadow("Default")
exitvehicle2.text = T.SetFontString(exitvehicle2, C.media.font, 19)
exitvehicle2.text:Point("CENTER", 1, 1)
exitvehicle2.text:SetText(T.panelcolor.."v|r")
RegisterStateDriver(exitvehicle2, "visibility", "[target=vehicle,exists] show;hide")

--------------------------------------------------------------
-- DrPepper taste is really good with Vodka. 
--------------------------------------------------------------

local init = CreateFrame("Frame")
init:RegisterEvent("VARIABLES_LOADED")
init:SetScript("OnEvent", function(self, event)
	if not TukuiDataPerChar then TukuiDataPerChar = {} end
	local db = TukuiDataPerChar
	
	-- Castbar Position
	T.cbPosition = function()
		if not C["unitframes"].enable == true then return end
		if TukuiDataPerChar.hidebar2 == true then
			TukuiPlayerCastBar:ClearAllPoints()
			TukuiPlayerCastBar:Point("BOTTOM", TukuiBar1, "TOP", 14, 6)
		else
			TukuiPlayerCastBar:ClearAllPoints()
			TukuiPlayerCastBar:Point("BOTTOMRIGHT", TukuiBar2, "TOPRIGHT", -2, 6)
		end
	end
	T.cbPosition()
	
	-- Rightbars on startup
	if db.rightbars == 1 then
		DrPepper(TukuiBar3Button, TukuiBar3)
		MultiBarRight:Hide()
		TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -36 -((T.buttonsize * 1) + (T.buttonspacing * 2)), -14)
	elseif db.rightbars == 0 then
		TukuiLineToPetActionBarBackground:Hide()
		TukuiBar3Button.text:SetText(T.panelcolor.."<|r")
		TukuiBar3:Hide()
		TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -26, -14)
	elseif db.rightbars == 2 or db.rightbars == nil then
		TukuiPetBar:Point("RIGHT", UIParent, "RIGHT", -36 -((T.buttonsize * 2) + (T.buttonspacing * 3)), -14)
	end
	
	-- Third Bar at the bottom
	if db.hidebar2 then
		DrPepper(TukuiBar2Button, TukuiBar2)
	end
end)