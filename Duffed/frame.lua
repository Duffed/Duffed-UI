-- Rala (Mug'thol)
-- Target HP in Percent
local f = CreateFrame("Frame", nil, TargetFrame)
f:SetPoint("RIGHT", "TargetFrameHealthBar", "LEFT", -3, 0)
f:SetHeight(12)
f:SetWidth(30)

local hp = f:CreateFontString("TargetHealthPercentageFontString", "OVERLAY", "GameFontNormalSmall")
hp:SetPoint("CENTER", f, "CENTER")
hp:SetJustifyH("RIGHT")

f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_HEALTH")
f:SetScript("OnEvent", function (self, event, ...)
  if ((event == "UNIT_HEALTH") and ((...) ~= "target")) then

    return
  end

  if (UnitIsDeadOrGhost("target")) then

    hp:SetText(" ")
  else
    local perc = UnitHealth("target") / UnitHealthMax("target") * 100
    hp:SetText(string.format("%u%%", perc))
  end
end)