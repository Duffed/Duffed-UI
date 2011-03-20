-- Target HP in Percent
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	if C["unitframes"].enable == true then return end
end

local hptext = TargetFrameHealthBar:CreateFontString("TargetHealthPercentageFontString", "OVERLAY")
hptext:SetPoint("RIGHT", TargetFrameHealthBar, "LEFT", -5, 0)
hptext:SetFont(dStuff.font, 12)
hptext:SetShadowColor(0,0,0)
hptext:SetShadowOffset(1,-1)
hptext:SetTextColor(1,1,1)
hptext:SetJustifyH("RIGHT")

TargetFrameHealthBar:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameHealthBar:RegisterEvent("UNIT_HEALTH")

TargetFrameHealthBar:SetScript("OnEvent", function (self, event, ...)
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