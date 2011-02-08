-- Target HP in Percent
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	if C["unitframes"].enable == true then return end
end

local targethp = CreateFrame("Frame", nil, TargetFrame)
targethp:SetPoint("RIGHT", "TargetFrameHealthBar", "LEFT", -3, 0)
targethp:SetSize(30, 12)

local hptext = targethp:CreateFontString("TargetHealthPercentageFontString", "OVERLAY", "GameFontNormalSmall")
hptext:SetPoint("CENTER", targethp, "CENTER")
hptext:SetJustifyH("RIGHT")

targethp:RegisterEvent("PLAYER_TARGET_CHANGED")
targethp:RegisterEvent("UNIT_HEALTH")

targethp:SetScript("OnEvent", function (self, event, ...)
	if ((event == "UNIT_HEALTH") and ((...) ~= "target")) then
		return
	end
	if (UnitIsDeadOrGhost("target")) then
		hptext:SetText("")
	else
		local perc = UnitHealth("target") / UnitHealthMax("target") * 100
		hptext:SetText(string.format("%u%%", perc))
	end
end)