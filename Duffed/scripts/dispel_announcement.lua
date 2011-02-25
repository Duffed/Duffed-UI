if dStuff.dispelannouncement ~= true then return end

-- Create movable frame for dispel announcements
local f = CreateFrame("MessageFrame", "dDispelFrame", UIParent)
f:SetPoint("TOP", 0, -220)
f:SetSize(200, 100)
f:SetFont(dStuff.font, 14)
f:SetShadowOffset(1, -1)
f:SetShadowColor(0,0,0)
f:SetTimeVisible(2)
f:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
f:SetBackdropColor(0,0,0,0)
f:SetMovable(true)
f:SetFrameStrata("HIGH")
f:SetInsertMode("TOP")
f:SetJustifyH(dStuff.dispelannouncement_justify)
f:SetClampedToScreen(true)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", function(self, event, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	if (type == "SPELL_DISPEL" or type == "SPELL_STOLEN") and sourceName == UnitName("player") then
		f:AddMessage("- |cffce3a19"..select(13, ...), 1, 1, 1)
	end
end)

-- slash command
local move = false
SLASH_DUFFEDDISPELLYEAH1 = "/ddispel"
SlashCmdList.DUFFEDDISPELLYEAH = function()
	if not move then
		move = true
		f:AddMessage("- |cffce3a19around!", 1, 1, 1)
		f:AddMessage("- |cffce3a19Dispelframe", 1, 1, 1)
		f:AddMessage("- |cffce3a19Move", 1, 1, 1)
		f:SetTimeVisible(999)
		f:EnableMouse(true)
		f:SetScript("OnMouseDown", function() f:StartMoving() end)
		f:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)
		f:SetBackdropColor(0.1, 0.1, 0.1, 0.6)
		print("|cffce3a19dStuff|r - Frame unlocked.")
	else
		f:SetTimeVisible(2)
		move = false
		f:EnableMouse(false)
		f:SetBackdropColor(0,0,0,0)
		print("|cffce3a19dStuff|r - Frame locked.")
	end
end