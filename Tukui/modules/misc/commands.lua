local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- enable or disable an addon via command
SlashCmdList.DISABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then DisableAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_DISABLE_ADDON1 = "/disable"
SlashCmdList.ENABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then EnableAddOn(addon) LoadAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_ENABLE_ADDON1 = "/enable"

-- switch to heal layout via a command
SLASH_TUKUIHEAL1 = "/heal"
SlashCmdList.TUKUIHEAL = function()
	DisableAddOn("Tukui_Raid")
	EnableAddOn("Tukui_Raid_Healing")
	ReloadUI()
end

-- switch to dps layout via a command
SLASH_TUKUIDPS1 = "/dps"
SlashCmdList.TUKUIDPS = function()
	DisableAddOn("Tukui_Raid_Healing")
	EnableAddOn("Tukui_Raid")
	ReloadUI()
end

-- fix combatlog manually when it broke
SLASH_CLFIX1 = "/clfix"
SlashCmdList.CLFIX = CombatLogClearEntries

-- disband raid slash command
SLASH_RAIDDISBAND1 = "/rd"
SlashCmdList["RAIDDISBAND"] = function()
	SendChatMessage(L.disband, "RAID" or "PARTY")
	if UnitInRaid("player") then
		for i=1, GetNumRaidMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= T.myname then
				UninviteUnit(name)
			end
		end
	else
		for i=MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end

-- layout via slash command
SLASH_DUFFEDLAYOUT1 = "/layout"
SlashCmdList["DUFFEDLAYOUT"] = function(msg) 
	if not IsAddOnLoaded("Tukui_ConfigUI") then print("|cffff0000Required: Tukui Config UI.") return end
	if TukuiConfigSettings.unitframes == nil then TukuiConfigSettings.unitframes = {} end
	if msg == "1" then
		TukuiConfigSettings.unitframes.layout = 1
		ReloadUI()
	elseif msg == "2" then
		TukuiConfigSettings.unitframes.layout = 2
		ReloadUI()
	else
		print("|cffff0000/layout|r 1 or 2")
	end
end

-- ready check shortcut
SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = "/rc"

-- Leave party chat command
SlashCmdList["LEAVEPARTY"] = function()
	LeaveParty()
end
SLASH_LEAVEPARTY1 = '/leaveparty'

-- dunno where to place this
COPPER_AMOUNT = "%d|cFF954F28"..COPPER_AMOUNT_SYMBOL.."|r"
SILVER_AMOUNT = "%d|cFFC0C0C0"..SILVER_AMOUNT_SYMBOL.."|r"
GOLD_AMOUNT = "%d|cFFF0D440"..GOLD_AMOUNT_SYMBOL.."|r"
YOU_LOOT_MONEY = "+ %s"
YOU_LOOT_MONEY_GUILD = "+ %s (%s)"
LOOT_MONEY_SPLIT = "+ %s"
LOOT_MONEY_SPLIT_GUILD = "+ %s (%s)"