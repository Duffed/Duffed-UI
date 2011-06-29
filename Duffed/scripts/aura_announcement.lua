if dStuff.ccannouncement ~= true then return end

-- Buff/Debuff Announcement
local f = CreateFrame("Frame")
local function Update(self, event, ...)
	if not DuffedC.auraannounce then return end
	
	local pvpType = GetZonePVPInfo()
	if dStuff.arenaonly then
		if pvpType ~= "arena" then return end
	else
		f:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if UnitInRaid("player") and GetNumRaidMembers() > 5 then channel = "RAID" elseif GetNumPartyMembers() > 0 then channel = "PARTY" else return end
		-- local channel = "SAY"
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags = ...
		local spellName = select(13, ...)
		for spell, check in pairs(SpellsAN.aura) do
			if (eventType == "SPELL_AURA_APPLIED") and destName == UnitName("player") then
				if spellName == spell and check == true then
					SendChatMessage("+ "..spell.."!", channel)
				elseif spellName == spell and check ~= true then
					SendChatMessage(spell.."!", channel)
				end
			elseif eventType == "SPELL_AURA_REMOVED" and destName == UnitName("player") then
				if spellName == spell and check ~= false then
					SendChatMessage("- "..spell.."!", channel) 
				end
			end
		end
		for spell, check in pairs(SpellsAN.cast) do
			if eventType == "SPELL_CAST_SUCCESS" and sourceName == UnitName("player") and spellName == spell then
				SendChatMessage(spell.."!", channel)
			end
		end
	end
end
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", Update)