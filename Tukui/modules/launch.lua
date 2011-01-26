------------------------------------------------------------------------
--	First Time Launch and On Login file
------------------------------------------------------------------------

local function install()
	SetCVar("buffDurations", 1)
	SetCVar("consolidateBuffs", 0)
	SetCVar("lootUnderMouse", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("scriptErrors", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyPets", 0)
	SetCVar("nameplateShowFriendlyGuardians", 0)
	SetCVar("nameplateShowFriendlyTotems", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowEnemyPets", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "im")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("CombatDamage", 1)
	SetCVar("CombatHealing", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("Maxfps", 120)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("showVKeyCastbar", 1)
	SetCVar("colorblindMode", 0)
	SetCVar("autoLootDefault", 1)
	
	-- setting this the creator or tukui only, because a lot of people don't like this change.		
	if TukuiDB.myname == "Tukz" then	
		SetCVar("secureAbilityToggle", 0)
	end
	
	-- Var ok, now setting chat frames if using Tukui chats.	
	if (TukuiCF.chat.enable == true) and (not IsAddOnLoaded("Prat") or not IsAddOnLoaded("Chatter")) then					
		FCF_ResetChatWindows()
		FCF_SetLocked(ChatFrame1, 1)
		FCF_DockFrame(ChatFrame2)
		FCF_SetLocked(ChatFrame2, 1)
		FCF_OpenNewWindow(tukuilocal.chat_general)
		FCF_SetLocked(ChatFrame3, 1)
		FCF_DockFrame(ChatFrame3)

		FCF_OpenNewWindow("Loot/Trade")
		FCF_UnDockFrame(ChatFrame4)
		FCF_SetLocked(ChatFrame4, 1)
		ChatFrame4:Show()

		for i = 1, NUM_CHAT_WINDOWS do
			local frame = _G[format("ChatFrame%s", i)]
			local chatFrameId = frame:GetID()
			local chatName = FCF_GetChatWindowInfo(chatFrameId)
			
			-- this is the default width and height of tukui chats.
			SetChatWindowSavedDimensions(chatFrameId, 370, TukuiDB.Scale(80))

			-- move general bottom left or Loot (if found) on right.
			if i == 1 then
				frame:ClearAllPoints()
				frame:SetSize(TukuiDB.Scale(402), TukuiDB.Scale(117))
				frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 9, 9)
			elseif i == 4 then
				frame:ClearAllPoints()
				frame:SetSize(TukuiDB.Scale(402), TukuiDB.Scale(117))
				frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -9, 9)
				frame:SetJustifyH("RIGHT")
			end
				
			-- save new default position and dimension
			FCF_SavePositionAndDimensions(frame)
			
			-- set default tukui font size
			FCF_SetChatWindowFontSize(nil, frame, 13)
			
			-- rename windows general and combat log
			if i == 1 then FCF_SetWindowName(frame, "G, S & W") end
			if i == 2 then FCF_SetWindowName(frame, "Log") end
		end
		
		ChatFrame_RemoveAllMessageGroups(ChatFrame1)
		ChatFrame_RemoveChannel(ChatFrame1, tukuilocal.chat_trade) -- erf, it seem we need to localize this now
		ChatFrame_RemoveChannel(ChatFrame1, tukuilocal.chat_defense) -- erf, it seem we need to localize this now
		ChatFrame_RemoveChannel(ChatFrame1, tukuilocal.chat_recrutment) -- erf, it seem we need to localize this now
		ChatFrame_RemoveChannel(ChatFrame1, tukuilocal.chat_lfg) -- erf, it seem we need to localize this now
		ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
		ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
		ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
		ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
		ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
		ChatFrame_AddMessageGroup(ChatFrame1, "DND")
		ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
		ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
					
		-- Setup the spam chat frame
		ChatFrame_RemoveAllMessageGroups(ChatFrame3)
		ChatFrame_AddChannel(ChatFrame3, tukuilocal.chat_trade) -- erf, it seem we need to localize this now
		ChatFrame_AddChannel(ChatFrame3, tukuilocal.chat_general) -- erf, it seem we need to localize this now
		ChatFrame_AddChannel(ChatFrame3, tukuilocal.chat_defense) -- erf, it seem we need to localize this now
		ChatFrame_AddChannel(ChatFrame3, tukuilocal.chat_recrutment) -- erf, it seem we need to localize this now
		ChatFrame_AddChannel(ChatFrame3, tukuilocal.chat_lfg) -- erf, it seem we need to localize this now
				
		-- Setup the right chat
		ChatFrame_RemoveAllMessageGroups(ChatFrame4);
		ChatFrame_AddChannel(ChatFrame4, tukuilocal.chat_trade) -- erf, it seem we need to localize this now
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
		ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
				
		-- enable classcolor automatically on login and on each character without doing /configure each time.
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	end
	
	-- reset unitframe position
	if TukuiCF["unitframes"].positionbychar == true then
		TukuiUFpos = {}
	else
		TukuiData.ufpos = {}
	end
	
	-- reset movable stuff into original position
	TukuiMinimap:SetUserPlaced(false)
	if TukuiCF.unitframes.playerauras ~= true then TukuiAurasHeader:SetUserPlaced(false) end
	TukuiWatchFrameAnchor:SetUserPlaced(false)
	if TukuiCF["tooltip"].enable == true then TukuiTooltipAnchor:SetUserPlaced(false) end
	TukuiShiftBar:SetUserPlaced(false)
	
	-- reset saved variables on char
	TukuiDataPerChar = {}
	
	-- tell savedvariable that we installed Tukui perfectly
	TukuiDataPerChar.install = true
	
	ReloadUI()
end

local function DisableTukui()
	DisableAddOn("Tukui")
	ReloadUI()
end

------------------------------------------------------------------------
--	Popups
------------------------------------------------------------------------

StaticPopupDialogs["DISABLE_UI"] = {
	text = tukuilocal.popup_disableui,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = DisableTukui,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["INSTALL_UI"] = {
	text = tukuilocal.popup_install,
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = install,
	OnCancel = function() TukuiDataPerChar.install = true end,
    timeout = 0,
    whileDead = 1,
}

StaticPopupDialogs["DISABLE_RAID"] = {
	text = tukuilocal.popup_2raidactive,
	button1 = "DPS - TANK",
	button2 = "HEAL",
	OnAccept = function() DisableAddOn("Tukui_Heal_Layout") EnableAddOn("Tukui_Dps_Layout") ReloadUI() end,
	OnCancel = function() EnableAddOn("Tukui_Heal_Layout") DisableAddOn("Tukui_Dps_Layout") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

------------------------------------------------------------------------
--	On login function, look for some infos!
------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- create empty saved vars if they doesn't exist.
	if (TukuiData == nil) then TukuiData = {} end
	if (TukuiDataPerChar == nil) then TukuiDataPerChar = {} end

	if TukuiDB.getscreenresolution == "800x600"
		or TukuiDB.getscreenresolution == "1024x768"
		or TukuiDB.getscreenresolution == "720x576"
		or TukuiDB.getscreenresolution == "1024x600" -- eeepc reso
		or TukuiDB.getscreenresolution == "1152x864" then
			SetCVar("useUiScale", 0)
			StaticPopup_Show("DISABLE_UI")
	else
		SetCVar("useUiScale", 1)
		if TukuiCF["general"].multisampleprotect == true then
			SetMultisampleFormat(1)
		end
		if TukuiCF["general"].uiscale > 1 then TukuiCF["general"].uiscale = 1 end
		if TukuiCF["general"].uiscale < 0.64 then TukuiCF["general"].uiscale = 0.64 end
		SetCVar("uiScale", TukuiCF["general"].uiscale)
		if not TukuiDataPerChar.install then
			StaticPopup_Show("INSTALL_UI")
		end
	end
	
	if (IsAddOnLoaded("Tukui_Dps_Layout") and IsAddOnLoaded("Tukui_Heal_Layout")) then
		StaticPopup_Show("DISABLE_RAID")
	end
	
	print(tukuilocal.core_welcome1..TukuiDB.version)
	print(tukuilocal.core_welcome2)
	if IsAddOnLoaded("thek_Castbar") and TukuiCF["unitframes"].enable == false then
		print("Move Castbar with |cffce3a19/tcb")
	end
end)

------------------------------------------------------------------------
--	UI HELP
------------------------------------------------------------------------

-- Print Help Messages
local function UIHelp()
	print(" ")
	print(tukuilocal.core_uihelp1)
	print(tukuilocal.core_uihelp2)
	print(tukuilocal.core_uihelp5)
	print(tukuilocal.core_uihelp6)
	print(tukuilocal.core_uihelp7)
	print(tukuilocal.core_uihelp8)
	print(tukuilocal.core_uihelp9)
	print(tukuilocal.core_uihelp10)
	print(tukuilocal.core_uihelp15)
	print("|cffFF0000/moveui|r - Unlock Minimap, Buffs, Shapeshiftbar, Unitframes, Tooltip & Watchframe")
	print("|cffFF0000/moveui reset|r - Reset Positions (/moveui except Unitframes).")
	print(" ")
	print(tukuilocal.core_uihelp14)
end

SLASH_UIHELP1 = "/UIHelp"
SlashCmdList["UIHELP"] = UIHelp

SLASH_CONFIGURE1 = "/resetui"
SlashCmdList.CONFIGURE = function() StaticPopup_Show("INSTALL_UI") end


