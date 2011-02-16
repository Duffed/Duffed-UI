local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- Petbar horizontal
if C["actionbar"].petbarhorizontal == true then
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_CONTROL_LOST")
	f:RegisterEvent("PLAYER_CONTROL_GAINED")
	f:RegisterEvent("PET_BAR_UPDATE_USABLE")
	f:RegisterEvent("PET_BAR_UPDATE")
	f:RegisterEvent("UNIT_PET")
	f:RegisterEvent("PET_BAR_HIDE")
	f:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	f:SetScript("OnEvent", function()
		T.petBarPosition()
		if C["unitframes"].enable == true and C["castbar"].enable == true then
			T.cbPosition()
		end
	end)
end

-- debug mode
-- local e = CreateFrame("Frame")
-- e:RegisterAllEvents()
-- e:SetScript("OnEvent", function(self, event)
	-- print(T.panelcolor.."Event: |r"..event)
-- end)