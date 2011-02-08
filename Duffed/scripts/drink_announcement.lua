if dStuff.drinkannouncement ~= true then return end

-- Drink Announcement
local function Update(self, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, spellName, spellrank, spelline, spellID = ...
		if GetZonePVPInfo() == "arena" then
			if UnitIsEnemy("player", unit) and (spellID == 80167 or spellID == 94468 or spellID == 43183 or spellID == 57073 or spellName == "Trinken") then
				SendChatMessage(UnitName(unit).." is drinking.", "PARTY")
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", Update)