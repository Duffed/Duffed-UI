if dStuff.dispelannouncement.enable ~= true then return end

-- Create movable frame for dispel announcements
local f = CreateFrame("MessageFrame", "dDispelFrame", UIParent)
f:SetPoint("TOP", 0, -220)
f:SetSize(200, 100)
f:SetFont(dStuff.font, dStuff.dispelannouncement.fontsize)
f:SetShadowOffset(1, -1)
f:SetShadowColor(0,0,0)
f:SetTimeVisible(2)
f:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
f:SetBackdropColor(0,0,0,0)
f:SetMovable(true)
f:SetFrameStrata("HIGH")
f:SetInsertMode("TOP")
f:SetJustifyH(dStuff.dispelannouncement.justify)
f:SetClampedToScreen(true)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", function(self, event, ...)
	local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...
	if (eventType == "SPELL_DISPEL" or eventType == "SPELL_STOLEN") and sourceName == UnitName("player") then
		f:AddMessage("- "..dStuff.dispelannouncement.textcolor..select(16, ...), 1, 1, 1)
	end
end)