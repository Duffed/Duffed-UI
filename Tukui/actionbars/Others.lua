if not TukuiCF["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")	
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)	
	if TukuiCF["actionbar"].showgrid == true then
		ActionButton_HideGrid = TukuiDB.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)

-- vehicle button under minimap
local vehicle = CreateFrame("Button", "TukuiExitVehicleButton", UIParent, "SecureHandlerClickTemplate")
vehicle:SetWidth(TukuiDB.Scale(26))
vehicle:SetHeight(TukuiDB.Scale(26))
vehicle:SetPoint("LEFT", ActionBar3Background,"RIGHT", 6, 0)
vehicle:SetNormalTexture("Interface\\AddOns\\Tukui\\media\\textures\\vehicleexit")
vehicle:SetPushedTexture("Interface\\AddOns\\Tukui\\media\\textures\\vehicleexit")
vehicle:SetHighlightTexture("Interface\\AddOns\\Tukui\\media\\textures\\vehicleexit")
TukuiDB.SetTemplate(vehicle)
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)
RegisterStateDriver(vehicle, "visibility", "[target=vehicle,exists] show;hide")

