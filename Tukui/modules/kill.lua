-- here we kill all shit stuff on default UI that we don't need!

local k = TukuiDB.Kill

local Kill = CreateFrame("Frame")
Kill:RegisterEvent("ADDON_LOADED")
Kill:RegisterEvent("PLAYER_LOGIN")
Kill:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_LOGIN" then
		if IsAddOnLoaded("Tukui_Dps_Layout") or IsAddOnLoaded("Tukui_Heal_Layout") then
			InterfaceOptionsFrameCategoriesButton10:SetScale(0.00001)
			InterfaceOptionsFrameCategoriesButton10:SetAlpha(0)		
			InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
			InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)
			k(CompactPartyFrame)
			k(CompactRaidFrameManager)
			k(CompactRaidFrameContainer)
		end	
	else
		if addon == "Blizzard_AchievementUI" then
			if TukuiCF.tooltip.enable then
				hooksecurefunc("AchievementFrameCategories_DisplayButton", function(button) button.showTooltipFunc = nil end)
			end
		end
		
		if addon ~= "Tukui" then return end
		
		k(StreamingIcon)
		k(Advanced_UseUIScale)
		k(Advanced_UIScaleSlider)
		k(PartyMemberBackground)
		k(TutorialFrameAlertButton)
		
		k(InterfaceOptionsUnitFramePanelPartyBackground)

		-- make sure boss or arena frame is always disabled when running tukui
		SetCVar("showArenaEnemyFrames", 0)
		
		if TukuiCF.arena.unitframes then
			k(InterfaceOptionsUnitFramePanelArenaEnemyFrames)
			k(InterfaceOptionsUnitFramePanelArenaEnemyCastBar)
			k(InterfaceOptionsUnitFramePanelArenaEnemyPets)
		end
		
		if TukuiCF.chat.enable then
			SetCVar("WholeChatWindowClickable", 0)
			SetCVar("ConversationMode", "inline")
			k(InterfaceOptionsSocialPanelWholeChatWindowClickable)
			k(InterfaceOptionsSocialPanelConversationMode)
		end
		
		if TukuiCF.unitframes.enable then
			InterfaceOptionsFrameCategoriesButton9:SetScale(0.00001)
			InterfaceOptionsFrameCategoriesButton9:SetAlpha(0)	
			InterfaceOptionsFrameCategoriesButton9:SetScale(0.00001)
			InterfaceOptionsFrameCategoriesButton9:SetAlpha(0)
		end
		
		if TukuiCF.actionbar.enable then
			k(InterfaceOptionsActionBarsPanelBottomLeft)
			k(InterfaceOptionsActionBarsPanelBottomRight)
			k(InterfaceOptionsActionBarsPanelRight)
			k(InterfaceOptionsActionBarsPanelRightTwo)
			k(InterfaceOptionsActionBarsPanelAlwaysShowActionBars)
		end
	end
end)
