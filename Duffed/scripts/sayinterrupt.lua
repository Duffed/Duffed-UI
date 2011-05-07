if dStuff.sayinterrupt ~= true then return end

-- Say interrupt
local function Update(self, event, ...)
	if not DuffedC.sayinterrupt then return end
	
	local pvpType = GetZonePVPInfo()
	if dStuff.arenaonly then
		if pvpType ~= "arena" then return end
	else
		UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
	
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if UnitInRaid("player") and GetNumRaidMembers() > 5 then channel = "RAID" elseif GetNumPartyMembers() > 0 then channel = "PARTY" else return end
		-- local channel = "SAY"
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, _, extraskillID, extraSkillName = ...
		if eventType == "SPELL_INTERRUPT" and sourceName == UnitName("player") then
			SendChatMessage("Interrupted -> "..GetSpellLink(extraskillID).."!", channel)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", Update)