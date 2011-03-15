if dStuff.ccannouncement ~= true then return end

-- Buff/Debuff Announcement
local function Update(self, event, ...)
	if not DuffedC.auraannounce then return end
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if UnitInRaid("player") and GetNumRaidMembers() > 5 then channel = "RAID" elseif GetNumPartyMembers() > 0 then channel = "PARTY" else return end
		-- local channel = "SAY"
		local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
		local spellName = select(10, ...)
		for spell, check in pairs(SpellsAN.aura) do
			if (type == "SPELL_AURA_APPLIED") and destName == UnitName("player") then
				if spellName == spell and check == true then
					SendChatMessage("+ "..spell.."!", channel)
				elseif spellName == spell and check ~= true then
					SendChatMessage(spell.."!", channel)
				end
			elseif type == "SPELL_AURA_REMOVED" and destName == UnitName("player") then
				if spellName == spell and check ~= false then
					SendChatMessage("- "..spell.."!", channel) 
				end
			end
		end
		for spell, check in pairs(SpellsAN.cast) do
			if type == "SPELL_CAST_SUCCESS" and sourceName == UnitName("player") and spellName == spell then
				SendChatMessage(spell.."!", channel)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", Update)