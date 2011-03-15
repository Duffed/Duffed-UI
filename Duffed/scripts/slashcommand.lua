DuffedC = {
	["auraannounce"] = true,
	["sayinterrupt"] = true,
	["priest"] = true,
	["dispel"] = true,
}
local dc = DuffedC

SLASH_DUFFED1 = "/duffed"
SLASH_DUFFED2 = "/duff"
SlashCmdList["DUFFED"] = function(msg)
	if (msg == "aura" or msg == "a") and dStuff.ccannouncement then
		if dc.auraannounce then
			dc.auraannounce = false
			print("Aura announcement |cffff0000disabled.")
		else
			dc.auraannounce = true
			print("Aura announcement |cff00ff00enabled.")
		end
	elseif (msg == "interrupt" or msg == "i") and dStuff.sayinterrupt then
		if dc.sayinterrupt then
			dc.sayinterrupt = false
			print("Interrupt announcement |cffff0000disabled.")
		else
			dc.sayinterrupt = true
			print("Interrupt announcement |cff00ff00enabled.")
		end
	elseif (msg == "priest" or msg == "p") and dPriest_Frame then
		if dc.priest then
			dc.priest = false
			dPriest_Frame:Show()
			dPriest_Frame:EnableMouse(true)
			dPriest_Frame:SetScript("OnMouseDown", function() p:StartMoving() end)
			dPriest_Frame:SetScript("OnMouseUp", function() p:StopMovingOrSizing() end)
			print("Frame |cffff0000unlocked.")
			dPriest_Frame:UnregisterEvent("UNIT_AURA")
		else
			dc.priest = true
			dPriest_Frame:Hide()
			dPriest_Frame:EnableMouse(false)
			dPriest_Frame:RegisterEvent("UNIT_AURA")
			print("Frame |cff00ff00locked.")
		end
	elseif (msg == "dispel" or msg == "d") and dStuff.dispelannouncement.enable then
		if dc.dispel then
			dc.dispel = false
			dDispelFrame:AddMessage("- "..dStuff.dispelannouncement.textcolor.."around!", 1, 1, 1)
			dDispelFrame:AddMessage("- "..dStuff.dispelannouncement.textcolor.."Dispelframe", 1, 1, 1)
			dDispelFrame:AddMessage("- "..dStuff.dispelannouncement.textcolor.."Move", 1, 1, 1)
			dDispelFrame:SetTimeVisible(999)
			dDispelFrame:EnableMouse(true)
			dDispelFrame:SetScript("OnMouseDown", function() f:StartMoving() end)
			dDispelFrame:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)
			dDispelFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.6)
			print("Frame |cffff0000unlocked.")
		else
			dc.dispel = true
			dDispelFrame:SetTimeVisible(2)
			dDispelFrame:EnableMouse(false)
			dDispelFrame:SetBackdropColor(0,0,0,0)
			print("Frame |cff00ff00locked.")
		end
	else
		print(" ")
		print("Duffed Slash commands:")
		if dStuff.ccannouncement then print("   |cffce3a19/duffed aura|r - enable/disable Aura announcement.") end
		if dStuff.sayinterrupt then print("   |cffce3a19/duffed interrupt|r - enable/disable Interrupt announcement.") end
		if dStuff.priest_SoS then print("   |cffce3a19/duffed priest|r - unlock/lock Strength of Soul Frame.") end
		if dStuff.dispelannouncement.enable then print("   |cffce3a19/duffed dispel|r - unlock/lock Dispel Frame.") end
	end
end