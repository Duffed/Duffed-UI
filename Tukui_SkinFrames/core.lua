local T, C, L = unpack(Tukui)

local FONT = C["media"].font
local FONTSIZE = 18
local FONTFLAG = "THINOUTLINE"

local function SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r, color.g, color.b, 0.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local function SkinButton(f, strip)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.SetNormalTexture then f:SetNormalTexture("") end
	
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	
	if f.SetPushedTexture then f:SetPushedTexture("") end
	
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	
	if strip then f:StripTextures() end
	
	f:SetTemplate("Default", true)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local function SkinScrollBar(frame)
	if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
	if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end
	
	if _G[frame:GetName().."Top"] then
		_G[frame:GetName().."Top"]:SetTexture(nil)
		_G[frame:GetName().."Bottom"]:SetTexture(nil)
		_G[frame:GetName().."Middle"]:SetTexture(nil)
	end
end

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

local function SkinTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		tex:SetTexture(nil)
	end
	tab:GetHighlightTexture():SetTexture(nil)
	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate("Default")
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 10, -3)
	tab.backdrop:Point("BOTTOMRIGHT", -10, 3)				
end

local function SkinNextPrevButton(btn, horizonal)
	btn:SetTemplate("Default")
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)	
	
	if horizonal then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)	
	else
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():Point("TOPLEFT", 2, -2)
	btn:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
	btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

local function SkinRotateButton(btn)
	btn:SetTemplate("Default")
	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)	
	
	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)	
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():Point("TOPLEFT", 2, -2)
	btn:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())	
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

local function SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
	if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
	frame:CreateBackdrop("Default")
end

local function SkinDropDownBox(frame, width)
	local button = _G[frame:GetName().."Button"]
	if not width then width = 155 end
	
	frame:StripTextures()
	frame:Width(width)
	
	_G[frame:GetName().."Text"]:ClearAllPoints()
	_G[frame:GetName().."Text"]:Point("RIGHT", button, "LEFT", -2, 0)

	
	button:ClearAllPoints()
	button:Point("RIGHT", frame, "RIGHT", -10, 3)
	button.SetPoint = T.dummy
	
	SkinNextPrevButton(button, true)
	
	frame:CreateBackdrop("Default")
	frame.backdrop:Point("TOPLEFT", 20, -2)
	frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

local function SkinCheckBox(frame)
	frame:StripTextures()
	frame:CreateBackdrop("Default")
	frame.backdrop:Point("TOPLEFT", 4, -4)
	frame.backdrop:Point("BOTTOMRIGHT", -4, 4)
	
	if frame.SetCheckedTexture then
		frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end
	frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
end

local function SkinCloseButton(f, point)
	if f.SetNormalTexture then f:SetNormalTexture("") end

	if f.SetHighlightTexture then f:SetHighlightTexture("") end

	if f.SetPushedTexture then f:SetPushedTexture("") end

	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	f:SetTemplate("Default", true)
	f:Size(18,18)

	local text = f:FontString(nil, FONT, FONTSIZE, FONTFLAG)
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")
	
	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", -4, -4)
	else
		f:Point("TOPRIGHT", -4, -4)
	end
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local TukuiSkin = CreateFrame("Frame")
TukuiSkin:RegisterEvent("ADDON_LOADED")
TukuiSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end

	--Guild Control
	if addon == "Blizzard_GuildControlUI" then
		GuildControlUI:StripTextures()
		GuildControlUIHbar:StripTextures()
		GuildControlUI:SetTemplate("Default")
		GuildControlUI:CreateShadow("Default")
		
		local function SkinGuildRanks()
			for i=1, GuildControlGetNumRanks() do
				local rankFrame = _G["GuildControlUIRankOrderFrameRank"..i]
				if rankFrame then
					SkinButton(rankFrame.downButton)
					SkinButton(rankFrame.upButton)
					SkinButton(rankFrame.deleteButton)
					
					if not rankFrame.nameBox.backdrop then
						SkinEditBox(rankFrame.nameBox)
					end
					
					rankFrame.nameBox.backdrop:Point("TOPLEFT", -2, -4)
					rankFrame.nameBox.backdrop:Point("BOTTOMRIGHT", -4, 4)
				end
			end				
		end
		hooksecurefunc("GuildControlUI_RankOrder_Update", SkinGuildRanks)
		GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", function()
			T.Delay(1, SkinGuildRanks)
		end)
		
		SkinDropDownBox(GuildControlUINavigationDropDown)
		SkinDropDownBox(GuildControlUIRankSettingsFrameRankDropDown, 180)
		GuildControlUINavigationDropDownButton:Width(20)
		GuildControlUIRankSettingsFrameRankDropDownButton:Width(20)
		
		for i=1, NUM_RANK_FLAGS do
			if _G["GuildControlUIRankSettingsFrameCheckbox"..i] then
				SkinCheckBox(_G["GuildControlUIRankSettingsFrameCheckbox"..i])
			end
		end
		
		SkinButton(GuildControlUIRankOrderFrameNewButton)
		
		SkinEditBox(GuildControlUIRankSettingsFrameGoldBox)
		GuildControlUIRankSettingsFrameGoldBox.backdrop:Point("TOPLEFT", -2, -4)
		GuildControlUIRankSettingsFrameGoldBox.backdrop:Point("BOTTOMRIGHT", 2, 4)
		GuildControlUIRankSettingsFrameGoldBox:StripTextures()
		
		GuildControlUIRankBankFrame:StripTextures()
		
		local once = false
		hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
			local numTabs = GetNumGuildBankTabs()
			if numTabs < MAX_BUY_GUILDBANK_TABS then
				numTabs = numTabs + 1
			end
			for i=1, numTabs do
				local tab = _G["GuildControlBankTab"..i.."Owned"]
				local icon = tab.tabIcon
				local editbox = tab.editBox
				
				icon:SetTexCoord(.08, .92, .08, .92)
				
				if once == false then
					SkinButton(_G["GuildControlBankTab"..i.."BuyPurchaseButton"])
					_G["GuildControlBankTab"..i.."OwnedStackBox"]:StripTextures()
				end
			end
			once = true
		end)
		
		SkinDropDownBox(GuildControlUIRankBankFrameRankDropDown, 180)
		GuildControlUIRankBankFrameRankDropDownButton:Width(20)
	end
	
	--Guild
	if addon == "Blizzard_GuildUI" then
		GuildFrame:StripTextures(true)
		GuildFrame:SetTemplate("Default")
		GuildFrame:CreateShadow("Default")
		GuildLevelFrame:Kill()
		
		SkinCloseButton(GuildMemberDetailCloseButton)
		SkinCloseButton(GuildFrameCloseButton)
		
		local striptextures = {
			"GuildNewPerksFrame",
			"GuildFrameInset",
			"GuildFrameBottomInset",
			"GuildAllPerksFrame",
			"GuildMemberDetailFrame",
			"GuildMemberNoteBackground",
			"GuildInfoFrameInfo",
			"GuildLogContainer",
			"GuildLogFrame",
			"GuildRewardsFrame",
			"GuildMemberOfficerNoteBackground",
			"GuildTextEditContainer",
			"GuildTextEditFrame",
			"GuildRecruitmentRolesFrame",
			"GuildRecruitmentAvailabilityFrame",
			"GuildRecruitmentInterestFrame",
			"GuildRecruitmentLevelFrame",
			"GuildRecruitmentCommentFrame",
			"GuildRecruitmentCommentInputFrame",
			"GuildInfoFrameApplicantsContainer",
			"GuildInfoFrameApplicants",
			"GuildNewsBossModel",
			"GuildNewsBossModelTextFrame",
		}
		
		for _, frame in pairs(striptextures) do
			_G[frame]:StripTextures()
		end
		
		GuildNewsBossModel:CreateBackdrop("Default")
		GuildNewsBossModelTextFrame:CreateBackdrop("Default")
		GuildNewsBossModelTextFrame.backdrop:Point("TOPLEFT", GuildNewsBossModel.backdrop, "BOTTOMLEFT", 0, -1)
		GuildNewsBossModel:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)
		
		local buttons = {
			"GuildPerksToggleButton",
			"GuildMemberRemoveButton",
			"GuildMemberGroupInviteButton",
			"GuildAddMemberButton",
			"GuildViewLogButton",
			"GuildControlButton",
			"GuildRecruitmentListGuildButton",
			"GuildTextEditFrameAcceptButton",
			"GuildRecruitmentInviteButton",
			"GuildRecruitmentMessageButton",
			"GuildRecruitmentDeclineButton",
		}
		
		for i, button in pairs(buttons) do
			if i == 1 then
				SkinButton(_G[button])
			else
				SkinButton(_G[button], true)
			end
		end
		
		local checkbuttons = {
			"Quest", 
			"Dungeon",
			"Raid",
			"PvP",
			"RP",
			"Weekdays",
			"Weekends",
			"LevelAny",
			"LevelMax",
		}
		
		for _, frame in pairs(checkbuttons) do
			SkinCheckBox(_G["GuildRecruitment"..frame.."Button"])
		end
		
		SkinCheckBox(GuildRecruitmentTankButton:GetChildren())
		SkinCheckBox(GuildRecruitmentHealerButton:GetChildren())
		SkinCheckBox(GuildRecruitmentDamagerButton:GetChildren())
		
		for i=1,5 do
			SkinTab(_G["GuildFrameTab"..i])
		end
		GuildXPFrame:ClearAllPoints()
		GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)
		
		SkinScrollBar(GuildPerksContainerScrollBar)
		
		GuildFactionBar:StripTextures()
		GuildFactionBar.progress:SetTexture(C["media"].normTex)
		GuildFactionBar:CreateBackdrop("Default")
		GuildFactionBar.backdrop:Point("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -2, 2)
		GuildFactionBar.backdrop:Point("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", -2, 0)
		
		GuildXPBar:StripTextures()
		GuildXPBar.progress:SetTexture(C["media"].normTex)
		GuildXPBar:CreateBackdrop("Default")
		GuildXPBar.backdrop:Point("TOPLEFT", GuildXPBar.progress, "TOPLEFT", -2, 2)
		GuildXPBar.backdrop:Point("BOTTOMRIGHT", GuildXPBar, "BOTTOMRIGHT", -2, 2)
		
		GuildLatestPerkButton:StripTextures()
		GuildLatestPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		GuildLatestPerkButtonIconTexture:ClearAllPoints()
		GuildLatestPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
		GuildLatestPerkButton:CreateBackdrop("Default")
		GuildLatestPerkButton.backdrop:Point("TOPLEFT", GuildLatestPerkButtonIconTexture, "TOPLEFT", -2, 2)
		GuildLatestPerkButton.backdrop:Point("BOTTOMRIGHT", GuildLatestPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
		
		GuildNextPerkButton:StripTextures()
		GuildNextPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		GuildNextPerkButtonIconTexture:ClearAllPoints()
		GuildNextPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
		GuildNextPerkButton:CreateBackdrop("Default")
		GuildNextPerkButton.backdrop:Point("TOPLEFT", GuildNextPerkButtonIconTexture, "TOPLEFT", -2, 2)
		GuildNextPerkButton.backdrop:Point("BOTTOMRIGHT", GuildNextPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
		
		--Guild Perk buttons list
		for i=1, 8 do
			local button = _G["GuildPerksContainerButton"..i]
			button:StripTextures()
			
			if button.icon then
				button.icon:SetTexCoord(.08, .92, .08, .92)
				button.icon:ClearAllPoints()
				button.icon:Point("TOPLEFT", 2, -2)
				button:CreateBackdrop("Default")
				button.backdrop:Point("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
				button.backdrop:Point("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
				button.icon:SetParent(button.backdrop)
			end
		end
		
		--Roster
		SkinScrollBar(GuildRosterContainerScrollBar)
		SkinCheckBox(GuildRosterShowOfflineButton)
		
		
		for i=1, 4 do
			_G["GuildRosterColumnButton"..i]:StripTextures(true)
		end
		
		SkinDropDownBox(GuildRosterViewDropdown, 200)
		
		for i=1, 14 do
			SkinButton(_G["GuildRosterContainerButton"..i.."HeaderButton"], true)
		end
		
		--Detail Frame
		GuildMemberDetailFrame:SetTemplate("Default")
		GuildMemberNoteBackground:SetTemplate("Default")
		GuildMemberOfficerNoteBackground:SetTemplate("Default")
		GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel() + 5)
		SkinDropDownBox(GuildMemberRankDropdown, 175)

		--News
		GuildNewsFrame:StripTextures()
		for i=1, 17 do
			_G["GuildNewsContainerButton"..i].header:Kill()
		end
		
		GuildNewsFiltersFrame:StripTextures()
		GuildNewsFiltersFrame:SetTemplate("Default")
		SkinCloseButton(GuildNewsFiltersFrameCloseButton)
		
		for i=1, 7 do
			SkinCheckBox(_G["GuildNewsFilterButton"..i])
		end
		
		GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
		SkinScrollBar(GuildNewsContainerScrollBar)
		
		--Info Frame
		SkinScrollBar(GuildInfoDetailsFrameScrollBar)
		
		for i=1, 3 do
			_G["GuildInfoFrameTab"..i]:StripTextures()
		end
		
		local backdrop1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
		backdrop1:SetTemplate("Default")
		backdrop1:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
		backdrop1:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
		backdrop1:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
		
		local backdrop2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
		backdrop2:SetTemplate("Default")
		backdrop2:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
		backdrop2:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
		backdrop2:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)	

		local backdrop3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
		backdrop3:SetTemplate("Default")
		backdrop3:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
		backdrop3:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
		backdrop3:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)	
		
		GuildRecruitmentCommentInputFrame:SetTemplate("Default")
		
		for _, button in next, GuildInfoFrameApplicantsContainer.buttons do
			button.selectedTex:Kill()
			button:GetHighlightTexture():Kill()
			button:SetBackdrop(nil)
		end
		
		--Text Edit Frame
		GuildTextEditFrame:SetTemplate("Default")
		SkinScrollBar(GuildTextEditScrollFrameScrollBar)
		GuildTextEditContainer:SetTemplate("Default")
		for i=1, GuildTextEditFrame:GetNumChildren() do
			local child = select(i, GuildTextEditFrame:GetChildren())
			if child:GetName() == "GuildTextEditFrameCloseButton" and child:GetWidth() == 32 then
				SkinCloseButton(child)
			elseif child:GetName() == "GuildTextEditFrameCloseButton" then
				SkinButton(child, true)
			end
		end
		
		--Guild Log
		SkinScrollBar(GuildLogScrollFrameScrollBar)
		GuildLogFrame:SetTemplate("Default")

		--Blizzard has two buttons with the same name, this is a fucked up way of determining that it isn't the other button
		for i=1, GuildLogFrame:GetNumChildren() do
			local child = select(i, GuildLogFrame:GetChildren())
			if child:GetName() == "GuildLogFrameCloseButton" and child:GetWidth() == 32 then
				SkinCloseButton(child)
			elseif child:GetName() == "GuildLogFrameCloseButton" then
				SkinButton(child, true)
			end
		end
		
		--Rewards
		SkinScrollBar(GuildRewardsContainerScrollBar)
		
		for i=1, 8 do
			local button = _G["GuildRewardsContainerButton"..i]
			button:StripTextures()
			
			if button.icon then
				button.icon:SetTexCoord(.08, .92, .08, .92)
				button.icon:ClearAllPoints()
				button.icon:Point("TOPLEFT", 2, -2)
				button:CreateBackdrop("Default")
				button.backdrop:Point("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
				button.backdrop:Point("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
				button.icon:SetParent(button.backdrop)
			end
		end
	end
	
	if addon == "Blizzard_TradeSkillUI" then
		TradeSkillFrame:StripTextures(true)
		TradeSkillListScrollFrame:StripTextures()
		TradeSkillDetailScrollFrame:StripTextures()
		TradeSkillFrameInset:StripTextures()
		TradeSkillExpandButtonFrame:StripTextures()
		TradeSkillDetailScrollChildFrame:StripTextures()
		
		TradeSkillFrame:SetTemplate("Default")
		TradeSkillFrame:CreateShadow("Default")
		TradeSkillFrame:Height(TradeSkillFrame:GetHeight() + 12)
		TradeSkillRankFrame:StripTextures()
		TradeSkillRankFrame:CreateBackdrop("Default")
		TradeSkillRankFrame:SetStatusBarTexture(C["media"].normTex)
		
		SkinButton(TradeSkillCreateButton, true)
		SkinButton(TradeSkillCancelButton, true)
		SkinButton(TradeSkillFilterButton, true)
		SkinButton(TradeSkillCreateAllButton, true)
		SkinButton(TradeSkillViewGuildCraftersButton, true)
		
		TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75)
		TradeSkillLinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)
		TradeSkillLinkButton:GetHighlightTexture():Kill()
		TradeSkillLinkButton:CreateBackdrop("Default")
		TradeSkillLinkButton:Size(17, 14)
		TradeSkillLinkButton:Point("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
		SkinEditBox(TradeSkillFrameSearchBox)
		SkinEditBox(TradeSkillInputBox)
		SkinNextPrevButton(TradeSkillDecrementButton)
		SkinNextPrevButton(TradeSkillIncrementButton)
		TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
		
		SkinCloseButton(TradeSkillFrameCloseButton)
		
		local once = false
		hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
			TradeSkillSkillIcon:StyleButton()
			if TradeSkillSkillIcon:GetNormalTexture() then
				TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				TradeSkillSkillIcon:GetNormalTexture():ClearAllPoints()
				TradeSkillSkillIcon:GetNormalTexture():Point("TOPLEFT", 2, -2)
				TradeSkillSkillIcon:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
			end
			TradeSkillSkillIcon:SetTemplate("Default")

			for i=1, MAX_TRADE_SKILL_REAGENTS do
				local button = _G["TradeSkillReagent"..i]
				local icon = _G["TradeSkillReagent"..i.."IconTexture"]
				local count = _G["TradeSkillReagent"..i.."Count"]
				
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				if not icon.backdrop then
					icon.backdrop = CreateFrame("Frame", nil, button)
					icon.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)
					icon.backdrop:SetTemplate("Default")
					icon.backdrop:Point("TOPLEFT", icon, "TOPLEFT", -2, 2)
					icon.backdrop:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
				end
				
				icon:SetParent(icon.backdrop)
				count:SetParent(icon.backdrop)
				count:SetDrawLayer("OVERLAY")
				
				if i > 2 and once == false then
					local point, anchoredto, point2, x, y = button:GetPoint()
					button:ClearAllPoints()
					button:Point(point, anchoredto, point2, x, y - 3)
					once = true
				end
				
				_G["TradeSkillReagent"..i.."NameFrame"]:Kill()
			end
		end)

		--Guild Crafters
		TradeSkillGuildFrame:StripTextures()
		TradeSkillGuildFrame:SetTemplate("Default")
		TradeSkillGuildFrame:Point("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
		TradeSkillGuildFrameContainer:StripTextures()
		TradeSkillGuildFrameContainer:SetTemplate("Default")
		SkinCloseButton(TradeSkillGuildFrameCloseButton)		
	end
	
	--Raid Frame
	if addon == "Blizzard_RaidUI" then
		local buttons = {
			"RaidFrameRaidBrowserButton",
			"RaidFrameRaidInfoButton",
			"RaidFrameReadyCheckButton",
		}

		for i = 1, #buttons do
			SkinButton(_G[buttons[i]])
		end

		local StripAllTextures = {
			"RaidGroup1",
			"RaidGroup2",
			"RaidGroup3",
			"RaidGroup4",
			"RaidGroup5",
			"RaidGroup6",
			"RaidGroup7",
			"RaidGroup8",
		}

		for _, object in pairs(StripAllTextures) do
			_G[object]:StripTextures()
		end

		local function raidskinupdate()
			nummembers = GetNumRaidMembers();

			for i=1,nummembers do
				SkinButton(_G["RaidGroupButton"..i])
			end
		end
		raidskinupdate()
		RaidFrame:HookScript("OnShow", raidskinupdate)
		hooksecurefunc("RaidGroupFrame_OnEvent", raidskinupdate)

		for i=1,8 do
			for j=1,5 do
				_G["RaidGroup"..i.."Slot"..j]:StripTextures()
				_G["RaidGroup"..i.."Slot"..j]:SetTemplate("Default")
			end
		end
	end	
	
	-- Talent Trees
	if addon == "Blizzard_TalentUI" then
		--PLAYER TALENTS
		local buttons = {
			"PlayerTalentFrameToggleSummariesButton",
			"PlayerTalentFrameActivateButton",
		}
		PlayerTalentFrameToggleSummariesButton:Point("BOTTOM", PlayerTalentFrame, "BOTTOM",0,5)

		for i = 1, #buttons do
			_G[buttons[i]]:StripTextures()
			SkinButton(_G[buttons[i]])
		end

		local StripAllTextures = {
			"PlayerTalentFrame",
			"PlayerTalentFrameInset",
			"PlayerTalentFrameTalents",
			"PlayerTalentFramePanel1",
			"PlayerTalentFramePanel2",
			"PlayerTalentFramePanel3",	
			"PlayerTalentFramePanel1HeaderIcon",
			"PlayerTalentFramePanel2HeaderIcon",
			"PlayerTalentFramePanel3HeaderIcon",
			"PlayerTalentFramePetTalents",
			"PlayerTalentFramePetPanel"
		}

		for _, object in pairs(StripAllTextures) do
			_G[object]:StripTextures()
		end
		
		for i=1, 3 do
			_G["PlayerTalentFramePanel"..i.."SelectTreeButton"]:SetFrameLevel(_G["PlayerTalentFramePanel"..i.."SelectTreeButton"]:GetFrameLevel() + 5)
			_G["PlayerTalentFramePanel"..i.."SelectTreeButton"]:StripTextures(true)
			SkinButton(_G["PlayerTalentFramePanel"..i.."SelectTreeButton"])
		end

		local KillTextures = {
			"PlayerTalentFramePanel1InactiveShadow",
			"PlayerTalentFramePanel2InactiveShadow",
			"PlayerTalentFramePanel3InactiveShadow",
			"PlayerTalentFramePanel1Arrow",
			"PlayerTalentFramePanel2Arrow",
			"PlayerTalentFramePanel3Arrow",
			"PlayerTalentFramePetPanelArrow",
			"PlayerTalentFramePanel1SummaryRoleIcon",
			"PlayerTalentFramePanel2SummaryRoleIcon",
			"PlayerTalentFramePanel3SummaryRoleIcon",
			"PlayerTalentFramePetShadowOverlay",
		}

		for _, texture in pairs(KillTextures) do
			_G[texture]:Kill()
		end

		PlayerTalentFrame:SetTemplate("Default")
		PlayerTalentFramePanel1:CreateBackdrop("Default")
		PlayerTalentFramePanel1.backdrop:Point( "TOPLEFT", PlayerTalentFramePanel1, "TOPLEFT", 3, -3 )
		PlayerTalentFramePanel1.backdrop:Point( "BOTTOMRIGHT", PlayerTalentFramePanel1, "BOTTOMRIGHT", -3, 3 )
		PlayerTalentFramePanel2:CreateBackdrop("Default")
		PlayerTalentFramePanel2.backdrop:Point( "TOPLEFT", PlayerTalentFramePanel2, "TOPLEFT", 3, -3 )
		PlayerTalentFramePanel2.backdrop:Point( "BOTTOMRIGHT", PlayerTalentFramePanel2, "BOTTOMRIGHT", -3, 3 )
		PlayerTalentFramePanel3:CreateBackdrop("Default")
		PlayerTalentFramePanel3.backdrop:Point( "TOPLEFT", PlayerTalentFramePanel3, "TOPLEFT", 3, -3 )
		PlayerTalentFramePanel3.backdrop:Point( "BOTTOMRIGHT", PlayerTalentFramePanel3, "BOTTOMRIGHT", -3, 3 )
		PlayerTalentFrame:CreateShadow("Default")
		SkinCloseButton(PlayerTalentFrameCloseButton)

		function talentpairs(inspect,pet)
		   local tab,tal=1,0
		   return function()
			  tal=tal+1
			  if tal>GetNumTalents(tab,inspect,pet) then
				 tal=1
				 tab=tab+1
			  end
			  if tab<=GetNumTalentTabs(inspect,pet) then
				 return tab,tal
			  end
		   end
		end

		--Skin TalentButtons
		local function TalentButtons(self, first, i, j)
			local button = _G["PlayerTalentFramePanel"..i.."Talent"..j]
			local icon = _G["PlayerTalentFramePanel"..i.."Talent"..j.."IconTexture"]

			if first then
				button:StripTextures()
			end
			
			if button.Rank then
				button.Rank:SetFont(FONT, 12, FONTFLAG)
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT")
			end
			
			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				button:StyleButton()
				button.SetHighlightTexture = T.dummy
				button.SetPushedTexture = T.dummy
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				button:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
				button:GetHighlightTexture():SetAllPoints(icon)
				button:GetPushedTexture():SetAllPoints(icon)
				
				icon:ClearAllPoints()
				icon:SetAllPoints()
				button:SetFrameLevel(button:GetFrameLevel() +1)
				button:CreateBackdrop("Default", true)
			end
		end

		local function TalentSummaryButtons(self, first, active, i, j)
			if active then
				button = _G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1"]
				icon = _G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1Icon"]
			else
				button = _G["PlayerTalentFramePanel"..i.."SummaryBonus"..j]
				icon = _G["PlayerTalentFramePanel"..i.."SummaryBonus"..j.."Icon"]
			end

			if first then
				button:StripTextures()
			end

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				button:SetFrameLevel(button:GetFrameLevel() +1)
				local frame = CreateFrame("Frame",nil, button)
				frame:CreateBackdrop("Default", true)
				frame:SetFrameLevel(button:GetFrameLevel() -1)
				frame:ClearAllPoints()
				frame:Point( "TOPLEFT", icon, "TOPLEFT", 0, 0 )
				frame:Point( "BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0 )
			end
		end

		for i=1, 2 do
			local tab = _G["PlayerSpecTab"..i]
			if tab then
				local a = tab:GetRegions()
				a:Hide()
				tab:StripTextures()
				tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				
				tab:GetNormalTexture():ClearAllPoints()
				tab:GetNormalTexture():Point("TOPLEFT", 2, -2)
				tab:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)

				tab:CreateBackdrop("Default")
				tab.backdrop:SetAllPoints()
				tab:StyleButton(true)
			end
		end

		--Reposition tabs
		PlayerSpecTab1:ClearAllPoints()
		PlayerSpecTab1:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPRIGHT", 2, -32)
		PlayerSpecTab1.SetPoint = T.dummy
		
		local function TalentSummaryClean(i)
			frame = _G["PlayerTalentFramePanel"..i.."Summary"]
			frame:CreateBackdrop("Default")
			frame:SetFrameLevel(frame:GetFrameLevel() +1)
			local a,b,_,d,_,_,_,_,_,_,_,_,m,_ = frame:GetRegions()
			a:Hide()
			b:Hide()
			d:Hide()
			m:Hide()
		end

		local function TalentHeaderIcon(self, first, i)
			local button = _G["PlayerTalentFramePanel"..i.."HeaderIcon"]
			local icon = _G["PlayerTalentFramePanel"..i.."HeaderIconIcon"]
			local panel = _G["PlayerTalentFramePanel"..i]
			local text = _G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpent"]

			if first then
				button:StripTextures()
			end
			
			_G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpent"]:SetFont(FONT, 12, FONTFLAG)

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				button:SetFrameLevel(button:GetFrameLevel() +1)
				button:ClearAllPoints()
				button:Point("TOPLEFT",panel,"TOPLEFT", 4, -4)
				text:SetFont(FONT, 12, FONTFLAG)
				text:Point("BOTTOMRIGHT",button, "BOTTOMRIGHT", -1, 2)
				local frame = CreateFrame("Frame",nil, button)
				frame:CreateBackdrop("Default", true)
				frame:SetFrameLevel(button:GetFrameLevel() +1)
				frame:ClearAllPoints()
				frame:Point( "TOPLEFT", icon, "TOPLEFT", 0, 0 )
				frame:Point( "BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0 )
			end
		end		

		for i=1, 3 do
			TalentSummaryClean(i)
			TalentHeaderIcon(nil, true, i)
			for j=1, 2 do
				TalentSummaryButtons(nil, true, true, i, j)
				TalentSummaryButtons(nil, true, false, i, j)
			end
		end

		for tab,talent in talentpairs() do
			TalentButtons(nil, true, tab, talent)
		end

		for i=1, 3 do
			SkinTab(_G["PlayerTalentFrameTab"..i])
		end

		--PET TALENTS
		SkinRotateButton(PlayerTalentFramePetModelRotateLeftButton)
		SkinRotateButton(PlayerTalentFramePetModelRotateRightButton)
		PlayerTalentFramePetModelRotateLeftButton:Point("BOTTOM", PlayerTalentFramePetModel, "BOTTOM", -4, 4)
		PlayerTalentFramePetModelRotateRightButton:Point("TOPLEFT", PlayerTalentFramePetModelRotateLeftButton, "TOPRIGHT", 4, 0)
		PlayerTalentFramePetPanel:CreateBackdrop("Default")
		PlayerTalentFramePetPanel.backdrop:Point( "TOPLEFT", PlayerTalentFramePetPanel, "TOPLEFT", 3, -3 )
		PlayerTalentFramePetPanel.backdrop:Point( "BOTTOMRIGHT", PlayerTalentFramePetPanel, "BOTTOMRIGHT", -3, 3 )
		PlayerTalentFramePetModel:CreateBackdrop("Default")
		PlayerTalentFramePetModel.backdrop:Point( "TOPLEFT", PlayerTalentFramePetModel, "TOPLEFT")
		PlayerTalentFramePetModel.backdrop:Point( "BOTTOMRIGHT", PlayerTalentFramePetModel, "BOTTOMRIGHT")
		SkinButton(PlayerTalentFrameLearnButton, true)
		SkinButton(PlayerTalentFrameResetButton, true)
		
		local function PetHeaderIcon(self, first)
			local button = _G["PlayerTalentFramePetPanelHeaderIcon"]
			local icon = _G["PlayerTalentFramePetPanelHeaderIconIcon"]
			local panel = _G["PlayerTalentFramePetPanel"]
			local d = select(4, button:GetRegions())

			if first then
				button:StripTextures()
			end

			if icon then
				d:ClearAllPoints()
				pointsSpent = select(5,GetTalentTabInfo( 1, Partycheck, true, 1 ))
				icon:SetTexCoord(.08, .92, .08, .92)
				button:SetFrameLevel(button:GetFrameLevel() +1)
				button:ClearAllPoints()
				button:Point("TOPLEFT",panel,"TOPLEFT", 5, -5)
				local text = button:FontString(nil, FONT, 12, FONTFLAG)
				text:Point("BOTTOMRIGHT",button, "BOTTOMRIGHT", -1, 2)
				text:SetText(pointsSpent)
				local frame = CreateFrame("Frame",nil, button)
				frame:CreateBackdrop("Default", true)
				frame:SetFrameLevel(button:GetFrameLevel() +1)
				frame:ClearAllPoints()
				frame:Point( "TOPLEFT", icon, "TOPLEFT", 0, 0 )
				frame:Point( "BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0 )
			end
		end

		local function PetInfoIcon(self, first)
			local button = _G["PlayerTalentFramePetInfo"]
			local icon = _G["PlayerTalentFramePetIcon"]
			local panel = _G["PlayerTalentFramePetModel"]

			PlayerTalentFramePetDiet:Hide();

			local petFoodList = { GetPetFoodTypes() };
			if #petFoodList > 0 then
				diet = petFoodList[1]
			else
				diet = "None"
			end

			if first then
				button:StripTextures()
			end

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				button:SetFrameLevel(button:GetFrameLevel() +1)
				button:ClearAllPoints()
				button:Point("BOTTOMLEFT",panel,"TOPLEFT", 0, 10)
				local text = button:FontString(nil, FONT, 12, FONTFLAG)
				text:Point("TOPRIGHT",button, "TOPRIGHT", 0, -10)
				text:SetText(diet)
				local frame = CreateFrame("Frame",nil, button)
				frame:CreateBackdrop("Default", true)
				frame:SetFrameLevel(button:GetFrameLevel() +1)
				frame:ClearAllPoints()
				frame:Point( "TOPLEFT", icon, "TOPLEFT", 0, 0 )
				frame:Point( "BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0 )
			end
		end	

		local function PetTalentButtons(self, first, i)
			local button = _G["PlayerTalentFramePetPanelTalent"..i]
			local icon = _G["PlayerTalentFramePetPanelTalent"..i.."IconTexture"]

			if first then
				button:StripTextures()
			end
			
			if button.Rank then
				button.Rank:SetFont(FONT, 12, FONTFLAG)
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT")
			end
			
			if icon then
				button:StyleButton()
				button.SetHighlightTexture = T.dummy
				button.SetPushedTexture = T.dummy
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				button:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
				button:GetHighlightTexture():SetAllPoints(icon)
				button:GetPushedTexture():SetAllPoints(icon)
				
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetAllPoints()
				button:SetFrameLevel(button:GetFrameLevel() +1)
				button:CreateBackdrop("Default", true)
			end
		end	

		PetInfoIcon(nil, true)
		PetHeaderIcon(nil, true)
		for i=1,GetNumTalents(1,false,true) do
			PetTalentButtons(nil,true,i)
		end
	end

	if addon == "Blizzard_DebugTools" then
		local noscalemult = T.mult * C["general"].uiscale
		local bg = {
		  bgFile = C["media"].blank, 
		  edgeFile = C["media"].blank, 
		  tile = false, tileSize = 0, edgeSize = noscalemult, 
		  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
		}
		
		ScriptErrorsFrame:SetBackdrop(bg)
		ScriptErrorsFrame:SetBackdropColor(unpack(C.media.backdropcolor))
		ScriptErrorsFrame:SetBackdropBorderColor(unpack(C.media.bordercolor))	

		EventTraceFrame:SetTemplate("Default")
		
		local texs = {
			"TopLeft",
			"TopRight",
			"Top",
			"BottomLeft",
			"BottomRight",
			"Bottom",
			"Left",
			"Right",
			"TitleBG",
			"DialogBG",
		}
		
		for i=1, #texs do
			_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
			_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
		end
		
		local bg = {
		  bgFile = C["media"].blank, 
		  edgeFile = C["media"].blank, 
		  tile = false, tileSize = 0, edgeSize = noscalemult, 
		  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
		}
		
		for i=1, ScriptErrorsFrame:GetNumChildren() do
			local child = select(i, ScriptErrorsFrame:GetChildren())
			if child:GetObjectType() == "Button" and not child:GetName() then
				
				SkinButton(child)
				child:SetBackdrop(bg)
				child:SetBackdropColor(unpack(C.media.backdropcolor))
				child:SetBackdropBorderColor(unpack(C.media.bordercolor))	
			end
		end	
	end
	
	if addon == "Blizzard_TrainerUI" then

		--Class Trainer Frame
		local StripAllTextures = {
			"ClassTrainerFrame",
			"ClassTrainerScrollFrameScrollChild",
			"ClassTrainerFrameSkillStepButton",
			"ClassTrainerFrameBottomInset",
		}

		local buttons = {
			"ClassTrainerTrainButton",
		}

		local KillTextures = {
			"ClassTrainerFrameInset",
			"ClassTrainerFramePortrait",
			"ClassTrainerScrollFrameScrollBarBG",
			"ClassTrainerScrollFrameScrollBarTop",
			"ClassTrainerScrollFrameScrollBarBottom",
			"ClassTrainerScrollFrameScrollBarMiddle",
		}

		for i=1,8 do
			_G["ClassTrainerScrollFrameButton"..i]:StripTextures()
			_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G["ClassTrainerScrollFrameButton"..i]:CreateBackdrop()
			_G["ClassTrainerScrollFrameButton"..i].backdrop:Point("TOPLEFT", _G["ClassTrainerScrollFrameButton"..i.."Icon"], "TOPLEFT", -2, 2)
			_G["ClassTrainerScrollFrameButton"..i].backdrop:Point("BOTTOMRIGHT", _G["ClassTrainerScrollFrameButton"..i.."Icon"], "BOTTOMRIGHT", 2, -2)
			_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetParent(_G["ClassTrainerScrollFrameButton"..i].backdrop)
		end

		for _, object in pairs(StripAllTextures) do
			_G[object]:StripTextures()
		end

		for _, texture in pairs(KillTextures) do
			_G[texture]:Kill()
		end

		for i = 1, #buttons do
			_G[buttons[i]]:StripTextures()
			SkinButton(_G[buttons[i]])
		end
		
		SkinDropDownBox(ClassTrainerFrameFilterDropDown, 155)

		ClassTrainerFrame:CreateBackdrop("Default")
		ClassTrainerFrame.backdrop:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
		ClassTrainerFrame.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")
		SkinCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)
		ClassTrainerFrameSkillStepButton.icon:SetTexCoord(.08, .92, .08, .92)
		ClassTrainerFrameSkillStepButton:CreateBackdrop("Default")
		ClassTrainerFrameSkillStepButton.backdrop:Point("TOPLEFT", ClassTrainerFrameSkillStepButton.icon, "TOPLEFT", -2, 2)
		ClassTrainerFrameSkillStepButton.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrameSkillStepButton.icon, "BOTTOMRIGHT", 2, -2)
		ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.backdrop)
		
		ClassTrainerStatusBar:StripTextures()
		ClassTrainerStatusBar:SetStatusBarTexture(C["media"].normTex)
		ClassTrainerStatusBar:CreateBackdrop("Default")
	end
	
	if addon == "Blizzard_GlyphUI" then

		--GLYPHS TAB
		GlyphFrameSparkleFrame:CreateBackdrop("Default")
		GlyphFrameSparkleFrame.backdrop:Point( "TOPLEFT", GlyphFrameSparkleFrame, "TOPLEFT", 3, -3 )
		GlyphFrameSparkleFrame.backdrop:Point( "BOTTOMRIGHT", GlyphFrameSparkleFrame, "BOTTOMRIGHT", -3, 3 )
		SkinEditBox(GlyphFrameSearchBox)
		SkinDropDownBox(GlyphFrameFilterDropDown, 212)
		
		GlyphFrameBackground:SetParent(GlyphFrameSparkleFrame)
		GlyphFrameBackground:SetPoint("TOPLEFT", 4, -4)
		GlyphFrameBackground:SetPoint("BOTTOMRIGHT", -4, 4)
		
		for i=1, 9 do
			_G["GlyphFrameGlyph"..i]:SetFrameLevel(_G["GlyphFrameGlyph"..i]:GetFrameLevel() + 5)
		end
		
		for i=1, 3 do
			_G["GlyphFrameHeader"..i]:StripTextures()
		end

		local function Glyphs(self, first, i)
			local button = _G["GlyphFrameScrollFrameButton"..i]
			local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

			if first then
				button:StripTextures()
			end

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				SkinButton(button)
			end
		end

		for i=1, 10 do
			Glyphs(nil, true, i)
		end

		GlyphFrameClearInfoFrameIcon:SetTexCoord(.08, .92, .08, .92)
		GlyphFrameClearInfoFrameIcon:ClearAllPoints()
		GlyphFrameClearInfoFrameIcon:Point("TOPLEFT", 2, -2)
		GlyphFrameClearInfoFrameIcon:Point("BOTTOMRIGHT", -2, 2)
		
		GlyphFrameClearInfoFrame:CreateBackdrop("Default", true)
		GlyphFrameClearInfoFrame.backdrop:SetAllPoints()
		GlyphFrameClearInfoFrame:StyleButton()
		GlyphFrameClearInfoFrame:Size(25, 25)
		
		SkinScrollBar(GlyphFrameScrollFrameScrollBar)

		local StripAllTextures = {
			"GlyphFrameScrollFrame",
			"GlyphFrameSideInset",
			"GlyphFrameScrollFrameScrollChild",
		}

		for _, object in pairs(StripAllTextures) do
			_G[object]:StripTextures()
		end

	end
	
	--Auction House
	if addon == "Blizzard_AuctionUI" then
		AuctionFrame:StripTextures(true)
		AuctionFrame:SetTemplate("Default")
		AuctionFrame:CreateShadow("Default")
		
		BrowseFilterScrollFrame:StripTextures()
		BrowseScrollFrame:StripTextures()
		AuctionsScrollFrame:StripTextures()
		BidScrollFrame:StripTextures()
		
		SkinDropDownBox(BrowseDropDown)
		SkinDropDownBox(PriceDropDown)
		SkinDropDownBox(DurationDropDown)
		
		SkinCheckBox(IsUsableCheckButton)
		SkinCheckBox(ShowOnPlayerCheckButton)
		
		--Dress Up Frame
		AuctionDressUpFrame:StripTextures()
		AuctionDressUpFrame:SetTemplate("Default")
		AuctionDressUpFrame:Point("TOPLEFT", AuctionFrame, "TOPRIGHT", 2, 0)
		SkinButton(AuctionDressUpFrameResetButton)
		AuctionDressUpFrameCloseButton:StripTextures()
		AuctionDressUpFrameCloseButton:SetNormalTexture(AuctionFrameCloseButton:GetNormalTexture():GetTexture())
		AuctionDressUpFrameCloseButton:SetPushedTexture(AuctionFrameCloseButton:GetPushedTexture():GetTexture())
		AuctionDressUpFrameCloseButton:SetHighlightTexture(AuctionFrameCloseButton:GetHighlightTexture():GetTexture())
		AuctionDressUpFrameCloseButton:SetDisabledTexture(AuctionFrameCloseButton:GetDisabledTexture():GetTexture())
		
		SkinRotateButton(AuctionDressUpModelRotateLeftButton)
		SkinRotateButton(AuctionDressUpModelRotateRightButton)
		AuctionDressUpModelRotateRightButton:Point("TOPLEFT", AuctionDressUpModelRotateLeftButton, "TOPRIGHT", 4, 0)
		
		--Progress Frame
		AuctionProgressFrame:StripTextures()
		AuctionProgressFrame:SetTemplate("Default")
		AuctionProgressFrame:CreateShadow("Default")
		AuctionProgressFrameCancelButton:StyleButton()
		AuctionProgressFrameCancelButton:SetTemplate("Default")
		AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
		AuctionProgressFrameCancelButton:GetNormalTexture():ClearAllPoints()
		AuctionProgressFrameCancelButton:GetNormalTexture():Point("TOPLEFT", 2, -2)
		AuctionProgressFrameCancelButton:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
		AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
		AuctionProgressFrameCancelButton:Size(28, 28)
		AuctionProgressFrameCancelButton:Point("LEFT", AuctionProgressBar, "RIGHT", 8, 0)
		
		AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)
		
		local backdrop = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
		backdrop:Point("TOPLEFT", AuctionProgressBarIcon, "TOPLEFT", -2, 2)
		backdrop:Point("BOTTOMRIGHT", AuctionProgressBarIcon, "BOTTOMRIGHT", 2, -2)
		backdrop:SetTemplate("Default")
		AuctionProgressBarIcon:SetParent(backdrop)
		
		AuctionProgressBarText:ClearAllPoints()
		AuctionProgressBarText:SetPoint("CENTER")
		
		AuctionProgressBar:StripTextures()
		AuctionProgressBar:CreateBackdrop("Default")
		AuctionProgressBar:SetStatusBarTexture(C["media"].normTex)
		AuctionProgressBar:SetStatusBarColor(1, 1, 0)
		
		SkinNextPrevButton(BrowseNextPageButton)
		SkinNextPrevButton(BrowsePrevPageButton)
		
		local buttons = {
			"BrowseBidButton",
			"BidBidButton",
			"BrowseBuyoutButton",
			"BidBuyoutButton",
			"BrowseCloseButton",
			"BidCloseButton",
			"BrowseSearchButton",
			"AuctionsCreateAuctionButton",
			"AuctionsCancelAuctionButton",
			"AuctionsCloseButton",
			"BrowseResetButton",
			"AuctionsStackSizeMaxButton",
			"AuctionsNumStacksMaxButton",
		}
		
		for _, button in pairs(buttons) do
			SkinButton(_G[button])
		end
		
		--Fix Button Positions
		AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)
		BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
		BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)
		BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
		BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)		
		AuctionsItemButton:StripTextures()
		AuctionsItemButton:StyleButton()
		AuctionsItemButton:SetTemplate("Default", true)
		BrowseResetButton:Point("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 81, -74)
		BrowseSearchButton:Point("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)
		
		AuctionsItemButton:SetScript("OnUpdate", function()
			if AuctionsItemButton:GetNormalTexture() then
				AuctionsItemButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				AuctionsItemButton:GetNormalTexture():ClearAllPoints()
				AuctionsItemButton:GetNormalTexture():Point("TOPLEFT", 2, -2)
				AuctionsItemButton:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
			end
		end)
		
		local sorttabs = {
			"BrowseQualitySort",
			"BrowseLevelSort",
			"BrowseDurationSort",
			"BrowseHighBidderSort",
			"BrowseCurrentBidSort",
			"BidQualitySort",
			"BidLevelSort",
			"BidDurationSort",
			"BidBuyoutSort",
			"BidStatusSort",
			"BidBidSort",
			"AuctionsQualitySort",
			"AuctionsDurationSort",
			"AuctionsHighBidderSort",
			"AuctionsBidSort",
		}
		
		for _, sorttab in pairs(sorttabs) do
			_G[sorttab.."Left"]:Kill()
			_G[sorttab.."Middle"]:Kill()
			_G[sorttab.."Right"]:Kill()
		end
		
		for i=1, 3 do
			SkinTab(_G["AuctionFrameTab"..i])
		end
		
		for i=1, NUM_FILTERS_TO_DISPLAY do
			local tab = _G["AuctionFilterButton"..i]
			tab:StripTextures()
			tab:StyleButton()
		end
		
		local editboxs = {
			"BrowseName",
			"BrowseMinLevel",
			"BrowseMaxLevel",
			"BrowseBidPriceGold",
			"BrowseBidPriceSilver",
			"BrowseBidPriceCopper",
			"BidBidPriceGold",
			"BidBidPriceSilver",
			"BidBidPriceCopper",
			"AuctionsStackSizeEntry",
			"AuctionsNumStacksEntry",
			"StartPriceGold",
			"StartPriceSilver",
			"StartPriceCopper",
			"BuyoutPriceGold",
			"BuyoutPriceSilver",
			"BuyoutPriceCopper"			
		}
		
		for _, editbox in pairs(editboxs) do
			SkinEditBox(_G[editbox])
			_G[editbox]:SetTextInsets(1, 1, -1, 1)
			if editbox:find("Silver") or editbox:find("Copper") then
				_G[editbox].backdrop:Point("BOTTOMRIGHT", -12, -2)
			end
		end
		BrowseMaxLevel:Point("LEFT", BrowseMinLevel, "RIGHT", 8, 0)
		AuctionsStackSizeEntry.backdrop:SetAllPoints()
		AuctionsNumStacksEntry.backdrop:SetAllPoints()
		
		for i=1, NUM_BROWSE_TO_DISPLAY do
			local button = _G["BrowseButton"..i]
			local icon = _G["BrowseButton"..i.."Item"]
			
			_G["BrowseButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G["BrowseButton"..i.."ItemIconTexture"]:ClearAllPoints()
			_G["BrowseButton"..i.."ItemIconTexture"]:Point("TOPLEFT", 2, -2)
			_G["BrowseButton"..i.."ItemIconTexture"]:Point("BOTTOMRIGHT", -2, 2)
			
			icon:StyleButton()
			--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
			icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
			
			icon:CreateBackdrop("Default")
			icon.backdrop:SetAllPoints()

			button:StripTextures()
			button:StyleButton()
			_G["BrowseButton"..i.."Highlight"] = button:GetHighlightTexture()
			button:GetHighlightTexture():ClearAllPoints()
			button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
			button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
			button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
		end
		
		for i=1, NUM_AUCTIONS_TO_DISPLAY do
			local button = _G["AuctionsButton"..i]
			local icon = _G["AuctionsButton"..i.."Item"]
			
			_G["AuctionsButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G["AuctionsButton"..i.."ItemIconTexture"].SetTexCoord = T.dummy
			_G["AuctionsButton"..i.."ItemIconTexture"]:ClearAllPoints()
			_G["AuctionsButton"..i.."ItemIconTexture"]:Point("TOPLEFT", 2, -2)
			_G["AuctionsButton"..i.."ItemIconTexture"]:Point("BOTTOMRIGHT", -2, 2)
			
			icon:StyleButton()
			--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
			icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
			
			icon:CreateBackdrop("Default")
			icon.backdrop:SetAllPoints()

			button:StripTextures()
			button:StyleButton()
			_G["AuctionsButton"..i.."Highlight"] = button:GetHighlightTexture()
			button:GetHighlightTexture():ClearAllPoints()
			button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
			button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
			button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())		
		end
		
		for i=1, NUM_BIDS_TO_DISPLAY do
			local button = _G["BidButton"..i]
			local icon = _G["BidButton"..i.."Item"]
			
			_G["BidButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G["BidButton"..i.."ItemIconTexture"]:ClearAllPoints()
			_G["BidButton"..i.."ItemIconTexture"]:Point("TOPLEFT", 2, -2)
			_G["BidButton"..i.."ItemIconTexture"]:Point("BOTTOMRIGHT", -2, 2)
			
			icon:StyleButton()
			icon:HookScript("OnUpdate", function() icon:GetNormalTexture():Kill() end)
			
			icon:CreateBackdrop("Default")
			icon.backdrop:SetAllPoints()

			button:StripTextures()
			button:StyleButton()
			_G["BidButton"..i.."Highlight"] = button:GetHighlightTexture()
			button:GetHighlightTexture():ClearAllPoints()
			button:GetHighlightTexture():Point("TOPLEFT", icon, "TOPRIGHT", 2, 0)
			button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
			button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())			
		end
		

	end
	
	--BarberShop
	if addon == "Blizzard_BarbershopUI" then
		local buttons = {
			"BarberShopFrameOkayButton",
			"BarberShopFrameCancelButton",
			"BarberShopFrameResetButton",
		}
		BarberShopFrameOkayButton:Point("RIGHT", BarberShopFrameSelector4, "BOTTOM", 2, -50)
		
		for i = 1, #buttons do
			_G[buttons[i]]:StripTextures()
			SkinButton(_G[buttons[i]])
		end
		

		for i = 1, 4 do
			local f = _G["BarberShopFrameSelector"..i]
			local f2 = _G["BarberShopFrameSelector"..i-1]
			SkinNextPrevButton(_G["BarberShopFrameSelector"..i.."Prev"])
			SkinNextPrevButton(_G["BarberShopFrameSelector"..i.."Next"])
			
			if i ~= 1 then
				f:ClearAllPoints()
				f:Point("TOP", f2, "BOTTOM", 0, -3)			
			end
			
			if f then
				f:StripTextures()
			end
		end
		
		BarberShopFrameSelector1:ClearAllPoints()
		BarberShopFrameSelector1:Point("TOP", 0, -12)
		
		BarberShopFrameResetButton:ClearAllPoints()
		BarberShopFrameResetButton:Point("BOTTOM", 0, 12)
	
		BarberShopFrame:StripTextures()
		BarberShopFrame:SetTemplate("Default")
		BarberShopFrame:Size(BarberShopFrame:GetWidth() - 30, BarberShopFrame:GetHeight() - 56)
		
		BarberShopFrameMoneyFrame:StripTextures()
		BarberShopFrameBackground:Kill()
		
		BarberShopBannerFrameBGTexture:Kill()
		BarberShopBannerFrame:Kill()
		
		BarberShopAltFormFrameBorder:StripTextures()
		BarberShopAltFormFrame:Point( "BOTTOM", BarberShopFrame, "TOP", 0, 5 )
		BarberShopAltFormFrame:StripTextures()
		BarberShopAltFormFrame:CreateBackdrop("Default")
	end
	
	--Macro Frame
	if addon == "Blizzard_MacroUI" then
		SkinCloseButton(MacroFrameCloseButton)
		
		local buttons = {
			"MacroDeleteButton",
			"MacroNewButton",
			"MacroExitButton",
			"MacroEditButton",
			"MacroFrameTab1",
			"MacroFrameTab2",
			"MacroPopupOkayButton",
			"MacroPopupCancelButton",
		}
		
		for i = 1, #buttons do
			_G[buttons[i]]:StripTextures()
			SkinButton(_G[buttons[i]])
		end
		
		for i = 1, 2 do
			tab = _G[format("MacroFrameTab%s", i)]
			tab:Height(22)
		end
		MacroFrameTab1:Point("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
		MacroFrameTab2:Point("LEFT", MacroFrameTab1, "RIGHT", 4, 0)
		
	
		-- General
		MacroFrame:StripTextures()
		MacroFrame:SetTemplate("Default")
		MacroFrameTextBackground:StripTextures()
		MacroFrameTextBackground:CreateBackdrop()
		MacroButtonScrollFrame:CreateBackdrop()
		MacroPopupFrame:StripTextures()
		MacroPopupFrame:SetTemplate("Default")
		MacroPopupScrollFrame:StripTextures()
		MacroPopupScrollFrame:CreateBackdrop()
		MacroPopupScrollFrame.backdrop:Point("TOPLEFT", 51, 2)
		MacroPopupScrollFrame.backdrop:Point("BOTTOMRIGHT", -4, 4)
		MacroPopupEditBox:CreateBackdrop()
		MacroPopupEditBox:StripTextures()
		
		--Reposition edit button
		MacroEditButton:ClearAllPoints()
		MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)
		
		-- Regular scroll bar
		SkinScrollBar(MacroButtonScrollFrame)
		
		MacroPopupFrame:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:Point("TOPLEFT", MacroFrame, "TOPRIGHT", 5, -2)
		end)
		
		-- Big icon
		MacroFrameSelectedMacroButton:StripTextures()
		MacroFrameSelectedMacroButton:StyleButton(true)
		MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil)
		MacroFrameSelectedMacroButton:SetTemplate("Default")
		MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)
		MacroFrameSelectedMacroButtonIcon:ClearAllPoints()
		MacroFrameSelectedMacroButtonIcon:Point("TOPLEFT", 2, -2)
		MacroFrameSelectedMacroButtonIcon:Point("BOTTOMRIGHT", -2, 2)
		
		-- temporarily moving this text
		MacroFrameCharLimitText:ClearAllPoints()
		MacroFrameCharLimitText:Point("BOTTOM", MacroFrameTextBackground, 0, -70)
		
		-- Skin all buttons
		for i = 1, MAX_ACCOUNT_MACROS do
			local b = _G["MacroButton"..i]
			local t = _G["MacroButton"..i.."Icon"]
			local pb = _G["MacroPopupButton"..i]
			local pt = _G["MacroPopupButton"..i.."Icon"]
			
			if b then
				b:StripTextures()
				b:StyleButton(true)
				
				b:SetTemplate("Default", true)
			end
			
			if t then
				t:SetTexCoord(.08, .92, .08, .92)
				t:ClearAllPoints()
				t:Point("TOPLEFT", 2, -2)
				t:Point("BOTTOMRIGHT", -2, 2)
			end

			if pb then
				pb:StripTextures()
				pb:StyleButton(true)
				
				pb:SetTemplate("Default")					
			end
			
			if pt then
				pt:SetTexCoord(.08, .92, .08, .92)
				pt:ClearAllPoints()
				pt:Point("TOPLEFT", 2, -2)
				pt:Point("BOTTOMRIGHT", -2, 2)
			end
		end
	end
	
	-- stuff not in Blizzard load-on-demand
	if addon == "Tukui" then
		--Gossip Frame
		do

			local StripAllTextures = {
				"GossipFrameGreetingPanel",
			}			

			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end

			local KillTextures = {
				"GossipFramePortrait",
			}

			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			local buttons = {
				"GossipFrameGreetingGoodbyeButton",
			}

			for i = 1, #buttons do
				_G[buttons[i]]:StripTextures()
				SkinButton(_G[buttons[i]])
			end


			for i = 1, NUMGOSSIPBUTTONS do
				obj = select(3,_G["GossipTitleButton"..i]:GetRegions())
				obj:SetTextColor(1,1,1)
			end

			GossipGreetingText:SetTextColor(1,1,1)
			GossipFrame:CreateBackdrop("Default")
			GossipFrame.backdrop:Point("TOPLEFT", GossipFrame, "TOPLEFT", 15, -20)
			GossipFrame.backdrop:Point("BOTTOMRIGHT", GossipFrame, "BOTTOMRIGHT", -30, 65)
			SkinCloseButton(GossipFrameCloseButton,GossipFrame.backdrop)
			
			
			--Extreme hackage, blizzard makes button text on quest frame use hex color codes for some reason
			hooksecurefunc("GossipFrameUpdate", function()
				for i=1, NUMGOSSIPBUTTONS do
					local button = _G["GossipTitleButton"..i]
					
					if button:GetFontString() then
						if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
							button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
						end
					end
				end
			end)
		end
		
		--LFD frame
		do
			local StripAllTextures = {
				"LFDParentFrame",
				"LFDQueueFrame",
				"LFDQueueFrameSpecific",
				"LFDQueueFrameRandom",
				"LFDQueueFrameRandomScrollFrame",
				"LFDQueueFrameCapBar",
				"LFDDungeonReadyDialog",
			}

			local KillTextures = {
				"LFDQueueFrameBackground",
				"LFDParentFrameInset",
				"LFDParentFrameEyeFrame",
				"LFDQueueFrameRoleButtonTankBackground",
				"LFDQueueFrameRoleButtonHealerBackground",
				"LFDQueueFrameRoleButtonDPSBackground",
				"LFDDungeonReadyDialogBackground",
			}
			local buttons = {
				"LFDQueueFrameFindGroupButton",
				"LFDQueueFrameCancelButton",
			}
			
			local checkButtons = {
				"LFDQueueFrameRoleButtonTank",
				"LFDQueueFrameRoleButtonHealer",
				"LFDQueueFrameRoleButtonDPS",
				"LFDQueueFrameRoleButtonLeader",
			}
			
			for _, object in pairs(checkButtons) do
				_G[object]:GetChildren():SetFrameLevel(_G[object]:GetChildren():GetFrameLevel() + 2)
				SkinCheckBox(_G[object]:GetChildren())
			end
			
			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end

			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			for i = 1, #buttons do
				_G[buttons[i]]:StripTextures()
				SkinButton(_G[buttons[i]])
			end	

			for i= 1,15 do
				SkinCheckBox(_G["LFDQueueFrameSpecificListButton"..i.."EnableButton"])
			end
			
			LFDQueueFrameRandom:HookScript("OnShow", function()
				for i=1, LFD_MAX_REWARDS do
					local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
					local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
					local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon1"]
					local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon2"]
					local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon3"]
					
					if button then
						button:StripTextures()
						icon:SetTexCoord(.08, .92, .08, .92)
						icon:Point("TOPLEFT", 2, -2)
						icon:SetDrawLayer("OVERLAY")
						count:SetDrawLayer("OVERLAY")
						if not button.backdrop then
							button:CreateBackdrop("Default")
							button.backdrop:Point("TOPLEFT", icon, "TOPLEFT", -2, 2)
							button.backdrop:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
							icon:SetParent(button.backdrop)
							icon.SetPoint = E.dummy
							
							if count then
								count:SetParent(button.backdrop)
							end
							if role1 then
								role1:SetParent(button.backdrop)
							end
							if role2 then
								role2:SetParent(button.backdrop)
							end
							if role3 then
								role3:SetParent(button.backdrop)
							end							
						end
					end
				end
			end)
			
			LFDQueueFrameSpecificListScrollFrame:StripTextures()
			LFDQueueFrameSpecificListScrollFrame:Height(LFDQueueFrameSpecificListScrollFrame:GetHeight() - 8)
			LFDParentFrame:CreateBackdrop("Default")
			LFDParentFrame.backdrop:Point( "TOPLEFT", LFDParentFrame, "TOPLEFT")
			LFDParentFrame.backdrop:Point( "BOTTOMRIGHT", LFDParentFrame, "BOTTOMRIGHT")
			SkinCloseButton(LFDParentFrameCloseButton,LFDParentFrame)
			SkinCloseButton(LFDDungeonReadyDialogCloseButton,LFDDungeonReadyDialog)
			SkinDropDownBox(LFDQueueFrameTypeDropDown, 300)
			LFDQueueFrameTypeDropDown:Point("RIGHT",-10,0)
			LFDQueueFrameCapBar:CreateBackdrop("Default")
			LFDQueueFrameCapBar.backdrop:Point( "TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", 1, -1)
			LFDQueueFrameCapBar.backdrop:Point( "BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", -1, 1 )
			LFDQueueFrameCapBarProgress:SetTexture(C["media"].normTex)
			LFDQueueFrameCapBarCap1:SetTexture(C["media"].normTex)
			LFDQueueFrameCapBarCap2:SetTexture(C["media"].normTex)
			SkinScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)
		end
		
		--Quest Frame
		do
			QuestFrame:StripTextures(true)
			QuestFrameDetailPanel:StripTextures(true)
			QuestFrameProgressPanel:StripTextures(true)
			QuestFrameRewardPanel:StripTextures(true)
			QuestFrame:CreateBackdrop("Default")
			QuestFrame.backdrop:Point("TOPLEFT", 6, -8)
			QuestFrame.backdrop:Point("BOTTOMRIGHT", -20, 65)
			QuestFrame.backdrop:CreateShadow("Default")
			SkinButton(QuestFrameAcceptButton, true)
			SkinButton(QuestFrameDeclineButton, true)
			SkinButton(QuestFrameCompleteButton, true)
			SkinButton(QuestFrameGoodbyeButton, true)
			SkinButton(QuestFrameCompleteQuestButton, true)
			SkinCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)
			
			for i=1, 6 do
				local button = _G["QuestProgressItem"..i]
				local texture = _G["QuestProgressItem"..i.."IconTexture"]
				button:StripTextures()
				button:StyleButton()
				button:Width(_G["QuestInfoItem"..i]:GetWidth() - 4)
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				texture:SetTexCoord(.08, .92, .08, .92)
				texture:SetDrawLayer("OVERLAY")
				texture:Point("TOPLEFT", 2, -2)
				texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
				button:SetTemplate("Default")				
			end
			
			hooksecurefunc("QuestFrameProgressItems_Update", function()
				QuestProgressTitleText:SetTextColor(1, 1, 0)
				QuestProgressText:SetTextColor(1, 1, 1)
				QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
				QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
			end)
			
			QuestNPCModel:StripTextures()
			QuestNPCModel:CreateBackdrop("Default")
			QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)
			QuestNPCModelTextFrame:StripTextures()
			QuestNPCModelTextFrame:CreateBackdrop("Default")
			QuestNPCModelTextFrame.backdrop:Point("TOPLEFT", QuestNPCModel.backdrop, "BOTTOMLEFT", 0, -2)
			QuestLogDetailFrame:StripTextures()
			QuestLogDetailFrame:SetTemplate("Default")
			QuestLogDetailScrollFrame:StripTextures()
			SkinCloseButton(QuestLogDetailFrameCloseButton)
			
			hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
				QuestNPCModel:ClearAllPoints();
				QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y);			
			end)
		end
		
		--Petition Frame
		do
			PetitionFrame:StripTextures(true)
			PetitionFrame:SetTemplate("Default")
			PetitionFrame:CreateShadow("Default")
			
			SkinButton(PetitionFrameRequestButton)
			SkinButton(PetitionFrameRenameButton)
			SkinButton(PetitionFrameCancelButton)
			SkinCloseButton(PetitionFrameCloseButton)
			
			PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
			PetitionFrameCharterName:SetTextColor(1, 1, 1)
			PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
			PetitionFrameMasterName:SetTextColor(1, 1, 1)
			PetitionFrameMemberTitle:SetTextColor(1, 1, 0)
			
			for i=1, 9 do
				_G["PetitionFrameMemberName"..i]:SetTextColor(1, 1, 1)
			end
			
			PetitionFrameInstructions:SetTextColor(1, 1, 1)
			
			PetitionFrameRenameButton:Point("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
			PetitionFrameRenameButton:Point("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
			PetitionFrame:Height(PetitionFrame:GetHeight() - 80)
			
			PetitionFrameCancelButton:Point("BOTTOMRIGHT", PetitionFrame, "BOTTOMRIGHT", -40, 20)
			PetitionFrameRequestButton:Point("BOTTOMLEFT", PetitionFrame, "BOTTOMLEFT", 22, 20)
		end
		
		--Quest Log
		do
			SkinCloseButton(QuestLogFrameCloseButton)
			QuestLogFrame:StripTextures()
			QuestLogFrame:SetTemplate("Default")
			QuestLogFrame:CreateShadow("Default")
			QuestLogCount:StripTextures()
			EmptyQuestLogFrame:StripTextures()
			
			local buttons = {
				"QuestLogFrameAbandonButton",
				"QuestLogFramePushQuestButton",
				"QuestLogFrameTrackButton",
				"QuestLogFrameCancelButton",
			}
			
			for _, button in pairs(buttons) do
				SkinButton(_G[button])
			end
			QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
			QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)
		
			for i=1, MAX_NUM_ITEMS do
				_G["QuestInfoItem"..i]:StripTextures()
				_G["QuestInfoItem"..i]:StyleButton()
				_G["QuestInfoItem"..i]:Width(_G["QuestInfoItem"..i]:GetWidth() - 4)
				_G["QuestInfoItem"..i]:SetFrameLevel(_G["QuestInfoItem"..i]:GetFrameLevel() + 2)
				_G["QuestInfoItem"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				_G["QuestInfoItem"..i.."IconTexture"]:SetDrawLayer("OVERLAY")
				_G["QuestInfoItem"..i.."IconTexture"]:Point("TOPLEFT", 2, -2)
				_G["QuestInfoItem"..i.."IconTexture"]:Size(_G["QuestInfoItem"..i.."IconTexture"]:GetWidth() - 2, _G["QuestInfoItem"..i.."IconTexture"]:GetHeight() - 2)
				_G["QuestInfoItem"..i]:SetTemplate("Default")
			end
			
			QuestInfoItemHighlight:StripTextures()
			QuestInfoItemHighlight:SetTemplate("Default")
			QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
			QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
			QuestInfoItemHighlight:Size(142, 40)
			
			hooksecurefunc("QuestInfoItem_OnClick", function(self)
				QuestInfoItemHighlight:ClearAllPoints()
				QuestInfoItemHighlight:SetAllPoints(self)
			end)
			
			--Everything here to make the text a readable color
			local function QuestObjectiveText()
				local numObjectives = GetNumQuestLeaderBoards()
				local objective
				local type, finished
				local numVisibleObjectives = 0
				for i = 1, numObjectives do
					_, type, finished = GetQuestLogLeaderBoard(i)
					if (type ~= "spell") then
						numVisibleObjectives = numVisibleObjectives+1
						objective = _G["QuestInfoObjective"..numVisibleObjectives]
						if ( finished ) then
							objective:SetTextColor(1, 1, 0)
						else
							objective:SetTextColor(0.6, 0.6, 0.6)
						end
					end
				end			
			end
			
			hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material)								
				local textColor = {1, 1, 1}
				local titleTextColor = {1, 1, 0}
				
				-- headers
				QuestInfoTitleHeader:SetTextColor(unpack(titleTextColor))
				QuestInfoDescriptionHeader:SetTextColor(unpack(titleTextColor))
				QuestInfoObjectivesHeader:SetTextColor(unpack(titleTextColor))
				QuestInfoRewardsHeader:SetTextColor(unpack(titleTextColor))
				-- other text
				QuestInfoDescriptionText:SetTextColor(unpack(textColor))
				QuestInfoObjectivesText:SetTextColor(unpack(textColor))
				QuestInfoGroupSize:SetTextColor(unpack(textColor))
				QuestInfoRewardText:SetTextColor(unpack(textColor))
				-- reward frame text
				QuestInfoItemChooseText:SetTextColor(unpack(textColor))
				QuestInfoItemReceiveText:SetTextColor(unpack(textColor))
				QuestInfoSpellLearnText:SetTextColor(unpack(textColor))
				QuestInfoXPFrameReceiveText:SetTextColor(unpack(textColor))	
				
				QuestObjectiveText()
			end)
			
			hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
				local requiredMoney = GetQuestLogRequiredMoney()
				if ( requiredMoney > 0 ) then
					if ( requiredMoney > GetMoney() ) then
						-- Not enough money
						QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
					else
						QuestInfoRequiredMoneyText:SetTextColor(1, 1, 0)
					end
				end			
			end)			
		end
		
		
		--Dressing Room Frame
		do
			DressUpFrame:StripTextures(true)
			DressUpFrame:CreateBackdrop("Default")
			DressUpFrame.backdrop:CreateShadow("Default")
			DressUpFrame.backdrop:Point("TOPLEFT", 6, 0)
			DressUpFrame.backdrop:Point("BOTTOMRIGHT", -32, 70)
			
			SkinButton(DressUpFrameResetButton)
			SkinButton(DressUpFrameCancelButton)
			SkinCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)
			SkinRotateButton(DressUpModelRotateLeftButton)
			SkinRotateButton(DressUpModelRotateRightButton)
			DressUpModelRotateRightButton:Point("TOPLEFT", DressUpModelRotateLeftButton, "TOPRIGHT", 2, 0)
			DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
		end
		
		--Honor/Conquest Pane
		do
			local buttons = {
				"PVPFrameLeftButton",
				"PVPFrameRightButton",
				"PVPHonorFrameWarGameButton",
				"PVPColorPickerButton1",
				"PVPColorPickerButton2",
				"PVPColorPickerButton3",
				"PVPBannerFrameAcceptButton",
			}

			for i = 1, #buttons do
				_G[buttons[i]]:StripTextures()
				SkinButton(_G[buttons[i]])
			end

			local KillTextures = {
				"PVPHonorFrameBGTex",
				"PVPHonorFrameInfoScrollFrameScrollBar",
				"PVPConquestFrameInfoButtonInfoBG",
				"PVPConquestFrameInfoButtonInfoBGOff",
				"PVPTeamManagementFrameFlag2GlowBG",
				"PVPTeamManagementFrameFlag3GlowBG",
				"PVPTeamManagementFrameFlag5GlowBG",
				"PVPTeamManagementFrameFlag2HeaderSelected",
				"PVPTeamManagementFrameFlag3HeaderSelected",
				"PVPTeamManagementFrameFlag5HeaderSelected",
				"PVPTeamManagementFrameFlag2Header",
				"PVPTeamManagementFrameFlag3Header",
				"PVPTeamManagementFrameFlag5Header",
				"PVPTeamManagementFrameWeeklyDisplayLeft",
				"PVPTeamManagementFrameWeeklyDisplayRight",
				"PVPTeamManagementFrameWeeklyDisplayMiddle",
				"PVPBannerFramePortrait",
				"PVPBannerFramePortraitFrame",
				"PVPBannerFrameInset",
				"PVPBannerFrameEditBoxLeft",
				"PVPBannerFrameEditBoxRight",
				"PVPBannerFrameEditBoxMiddle",
				"PVPBannerFrameCancelButton_LeftSeparator",
			}

			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			local StripAllTextures = {
				"PVPFrame",
				"PVPFrameInset",
				"PVPHonorFrame",
				"PVPConquestFrame",
				"PVPTeamManagementFrame",
				"PVPHonorFrameTypeScrollFrame",
				"PVPFrameTopInset",
				"PVPTeamManagementFrameInvalidTeamFrame",
				"PVPBannerFrame",
				"PVPBannerFrameCustomization1",
				"PVPBannerFrameCustomization2",
				"PVPBannerFrameCustomizationFrame",
			}

			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end

			local function ArenaHeader(self, first, i)
				local button = _G["PVPTeamManagementFrameHeader"..i]

				if first then
					button:StripTextures()
				end
			end

			for i=1, 4 do
				ArenaHeader(nil, true, i)
			end	

			PVPBannerFrameEditBox:CreateBackdrop("Default")
			PVPBannerFrameEditBox.backdrop:Point( "TOPLEFT", PVPBannerFrameEditBox, "TOPLEFT" ,-5,-5)
			PVPBannerFrameEditBox.backdrop:Point( "BOTTOMRIGHT", PVPBannerFrameEditBox, "BOTTOMRIGHT",5,5)
			PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(1,1,1)
			PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(1,1,1)
			PVPTeamManagementFrameInvalidTeamFrame:CreateBackdrop("Default")
			PVPTeamManagementFrameInvalidTeamFrame:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel()+1)
			PVPTeamManagementFrameInvalidTeamFrame.backdrop:Point( "TOPLEFT", PVPTeamManagementFrameInvalidTeamFrame, "TOPLEFT")
			PVPTeamManagementFrameInvalidTeamFrame.backdrop:Point( "BOTTOMRIGHT", PVPTeamManagementFrameInvalidTeamFrame, "BOTTOMRIGHT")
			PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel())
			PVPFrameConquestBar:StripTextures()
			PVPFrameConquestBar:SetStatusBarTexture(C["media"].normTex)
			PVPFrameConquestBar:CreateBackdrop("Default")
			PVPBannerFrame:CreateBackdrop("Default")
			PVPBannerFrame.backdrop:Point( "TOPLEFT", PVPBannerFrame, "TOPLEFT")
			PVPBannerFrame.backdrop:Point( "BOTTOMRIGHT", PVPBannerFrame, "BOTTOMRIGHT")
			PVPBannerFrameCustomization1:CreateBackdrop("Default")
			PVPBannerFrameCustomization1.backdrop:Point( "TOPLEFT", PVPBannerFrameCustomization1LeftButton, "TOPRIGHT" ,2,0)
			PVPBannerFrameCustomization1.backdrop:Point( "BOTTOMRIGHT", PVPBannerFrameCustomization1RightButton, "BOTTOMLEFT",-2,0)
			PVPBannerFrameCustomization2:CreateBackdrop("Default")
			PVPBannerFrameCustomization2.backdrop:Point( "TOPLEFT", PVPBannerFrameCustomization2LeftButton, "TOPRIGHT",2,0)
			PVPBannerFrameCustomization2.backdrop:Point( "BOTTOMRIGHT", PVPBannerFrameCustomization2RightButton, "BOTTOMLEFT",-2,0)
			SkinCloseButton(PVPBannerFrameCloseButton,PVPBannerFrame)
			SkinNextPrevButton(PVPBannerFrameCustomization1LeftButton)
			PVPBannerFrameCustomization1LeftButton:Height(PVPBannerFrameCustomization1:GetHeight())
			SkinNextPrevButton(PVPBannerFrameCustomization1RightButton)
			PVPBannerFrameCustomization1RightButton:Height(PVPBannerFrameCustomization1:GetHeight())
			SkinNextPrevButton(PVPBannerFrameCustomization2LeftButton)
			PVPBannerFrameCustomization2LeftButton:Height(PVPBannerFrameCustomization1:GetHeight())
			SkinNextPrevButton(PVPBannerFrameCustomization2RightButton)
			PVPBannerFrameCustomization2RightButton:Height(PVPBannerFrameCustomization1:GetHeight())
			PVPFrame:CreateBackdrop("Default")
			PVPFrame.backdrop:Point( "TOPLEFT", PVPFrame, "TOPLEFT")
			PVPFrame.backdrop:Point( "BOTTOMRIGHT", PVPFrame, "BOTTOMRIGHT")
			SkinCloseButton(PVPFrameCloseButton,PVPFrame)
			SkinNextPrevButton(PVPTeamManagementFrameWeeklyToggleLeft)
			SkinNextPrevButton(PVPTeamManagementFrameWeeklyToggleRight)
			PVPColorPickerButton1:Height(PVPColorPickerButton1:GetHeight()-5)
			PVPColorPickerButton2:Height(PVPColorPickerButton1:GetHeight())
			PVPColorPickerButton3:Height(PVPColorPickerButton1:GetHeight())

			--Freaking gay Cancel Button FFSlocal
			local f = PVPBannerFrameCancelButton
			local l = _G[f:GetName().."Left"]
			local m = _G[f:GetName().."Middle"]
			local r = _G[f:GetName().."Right"]
			if l then l:SetAlpha(0) end
			if m then m:SetAlpha(0) end
			if r then r:SetAlpha(0) end
			f:CreateBackdrop("Default")
			f:SetFrameLevel(PVPBannerFrameAcceptButton:GetFrameLevel()+1)
			f.backdrop:Point( "TOPLEFT", PVPBannerFrameAcceptButton, "TOPLEFT", PVPBannerFrame:GetWidth()-PVPBannerFrameAcceptButton:GetWidth()-10,0)
			f.backdrop:Point( "BOTTOMRIGHT", PVPBannerFrameAcceptButton, "BOTTOMRIGHT", PVPBannerFrame:GetWidth()-PVPBannerFrameAcceptButton:GetWidth()-10, 0)
			f.backdrop:SetFrameLevel(f:GetFrameLevel()-1)
			
			--Bottom Tabs
			for i=1,3 do
				SkinTab(_G["PVPFrameTab"..i])
			end
		end	
	
		--NonRaid Frame
		do
			local StripAllTextures = {
				"RaidInfoFrame",
				"RaidInfoInstanceLabel",
				"RaidInfoIDLabel",
			}

			local KillTextures = {
				"RaidInfoScrollFrameScrollBarBG",
				"RaidInfoScrollFrameScrollBarTop",
				"RaidInfoScrollFrameScrollBarBottom",
				"RaidInfoScrollFrameScrollBarMiddle",
			}
			local buttons = {
				"RaidFrameConvertToRaidButton",
				"RaidFrameRaidInfoButton",
				"RaidFrameNotInRaidRaidBrowserButton",
				"RaidInfoExtendButton",
				"RaidInfoCancelButton",
			}

			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end

			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			for i = 1, #buttons do
				SkinButton(_G[buttons[i]])
			end
			RaidInfoScrollFrame:StripTextures()
			RaidInfoFrame:CreateBackdrop("Default")
			RaidInfoFrame.backdrop:Point( "TOPLEFT", RaidInfoFrame, "TOPLEFT")
			RaidInfoFrame.backdrop:Point( "BOTTOMRIGHT", RaidInfoFrame, "BOTTOMRIGHT")
			SkinCloseButton(RaidInfoCloseButton,RaidInfoFrame)

		end
		
		--Social Frame
		local function SkinSocialHeaderTab(tab)
			if not tab then return end
			for _, object in pairs(tabs) do
				local tex = _G[tab:GetName()..object]
				tex:SetTexture(nil)
			end
			tab:GetHighlightTexture():SetTexture(nil)
			tab.backdrop = CreateFrame("Frame", nil, tab)
			tab.backdrop:SetTemplate("Default")
			tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
			tab.backdrop:Point("TOPLEFT", 3, -8)
			tab.backdrop:Point("BOTTOMRIGHT", -6, 0)
		end

		--Friends/Social Pane
		do
			local StripAllTextures = {
				"FriendsFrame",
				"FriendsListFrame",
				"FriendsTabHeader",
				"FriendsFrameFriendsScrollFrame",
				"WhoFrameColumnHeader1",
				"WhoFrameColumnHeader2",
				"WhoFrameColumnHeader3",
				"WhoFrameColumnHeader4",
				"ChannelListScrollFrame",
				"ChannelRoster",
				"FriendsFramePendingButton1",
				"FriendsFramePendingButton2",
				"FriendsFramePendingButton3",
				"FriendsFramePendingButton4",
				"ChannelFrameDaughterFrame",
				"AddFriendFrame",
				"AddFriendNoteFrame",
			}			

			local KillTextures = {
				"FriendsFrameTopLeft",
				"FriendsFrameTopRight",
				"FriendsFrameBottomLeft",
				"FriendsFrameBottomRight",
				"ChannelFrameVerticalBar",
				"FriendsFrameBroadcastInputLeft",
				"FriendsFrameBroadcastInputRight",
				"FriendsFrameBroadcastInputMiddle",
				"ChannelFrameDaughterFrameChannelNameLeft",
				"ChannelFrameDaughterFrameChannelNameRight",
				"ChannelFrameDaughterFrameChannelNameMiddle",
				"ChannelFrameDaughterFrameChannelPasswordLeft",
				"ChannelFrameDaughterFrameChannelPasswordRight",
				"ChannelFrameDaughterFrameChannelPasswordMiddle",
			}

			local buttons = {
				"FriendsFrameAddFriendButton",
				"FriendsFrameSendMessageButton",
				"WhoFrameWhoButton",
				"WhoFrameAddFriendButton",
				"WhoFrameGroupInviteButton",
				"ChannelFrameNewButton",
				"FriendsFrameIgnorePlayerButton",
				"FriendsFrameUnsquelchButton",
				"FriendsFramePendingButton1AcceptButton",
				"FriendsFramePendingButton1DeclineButton",
				"FriendsFramePendingButton2AcceptButton",
				"FriendsFramePendingButton2DeclineButton",
				"FriendsFramePendingButton3AcceptButton",
				"FriendsFramePendingButton3DeclineButton",
				"FriendsFramePendingButton4AcceptButton",
				"FriendsFramePendingButton4DeclineButton",
				"ChannelFrameDaughterFrameOkayButton",
				"ChannelFrameDaughterFrameCancelButton",
				"AddFriendEntryFrameAcceptButton",
				"AddFriendEntryFrameCancelButton",
				"AddFriendInfoFrameContinueButton",
			}			

			for _, button in pairs(buttons) do
				SkinButton(_G[button])
			end
			--Reposition buttons
			WhoFrameWhoButton:Point("RIGHT", WhoFrameAddFriendButton, "LEFT", -2, 0)
			WhoFrameAddFriendButton:Point("RIGHT", WhoFrameGroupInviteButton, "LEFT", -2, 0)
			WhoFrameGroupInviteButton:Point("BOTTOMRIGHT", WhoFrame, "BOTTOMRIGHT", -44, 82)
			--Resize Buttons
			WhoFrameWhoButton:Size(WhoFrameWhoButton:GetWidth() - 4, WhoFrameWhoButton:GetHeight())
			WhoFrameAddFriendButton:Size(WhoFrameAddFriendButton:GetWidth() - 4, WhoFrameAddFriendButton:GetHeight())
			WhoFrameGroupInviteButton:Size(WhoFrameGroupInviteButton:GetWidth() - 4, WhoFrameGroupInviteButton:GetHeight())
			SkinEditBox(WhoFrameEditBox)
			WhoFrameEditBox:Height(WhoFrameEditBox:GetHeight() - 15)
			WhoFrameEditBox:Point("BOTTOM", WhoFrame, "BOTTOM", -10, 108)
			WhoFrameEditBox:Width(WhoFrameEditBox:GetWidth() + 17)
			
			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end
			
			SkinEditBox(AddFriendNameEditBox)
			AddFriendFrame:SetTemplate("Default") 
			
			--Who Frame
			local function UpdateWhoSkins()
				WhoListScrollFrame:StripTextures()
			end
			--Channel Frame
			local function UpdateChannel()
				ChannelRosterScrollFrame:StripTextures()
			end
			--BNet Frame
			FriendsFrameBroadcastInput:CreateBackdrop("Default")
			ChannelFrameDaughterFrameChannelName:CreateBackdrop("Default")
			ChannelFrameDaughterFrameChannelPassword:CreateBackdrop("Default")			

			ChannelFrame:HookScript("OnShow", UpdateChannel)
			hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

			WhoFrame:HookScript("OnShow", UpdateWhoSkins)
			hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

			ChannelFrameDaughterFrame:CreateBackdrop("Default")
			FriendsFrame:CreateBackdrop("Default")
			FriendsFrame.backdrop:Point( "TOPLEFT", FriendsFrame, "TOPLEFT", 11,-12)
			FriendsFrame.backdrop:Point( "BOTTOMRIGHT", FriendsFrame, "BOTTOMRIGHT", -35, 76)
			SkinCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)
			SkinCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)
			SkinDropDownBox(WhoFrameDropDown,150)
			SkinDropDownBox(FriendsFrameStatusDropDown,70)

			--Bottom Tabs
			for i=1, 4 do
				SkinTab(_G["FriendsFrameTab"..i])
			end

			for i=1, 3 do
				SkinSocialHeaderTab(_G["FriendsTabHeaderTab"..i])
			end

			local function Channel()
				for i=1, MAX_DISPLAY_CHANNEL_BUTTONS do
					local button = _G["ChannelButton"..i]
					if button then
						button:StripTextures()
						button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
						
						_G["ChannelButton"..i.."Text"]:SetFont(FONT, 12)
					end
				end
			end
			hooksecurefunc("ChannelList_Update", Channel)
		end
		
		--Spellbook
		do
			SkinCloseButton(SpellBookFrameCloseButton)
			
			local StripAllTextures = {
				"SpellBookFrame",
				"SpellBookFrameInset",
				"SpellBookSpellIconsFrame",
				"SpellBookSideTabsFrame",
				"SpellBookPageNavigationFrame",
			}
			
			local KillTextures = {
				"SpellBookPage1",
				"SpellBookPage2",
			}
			
			for _, object in pairs(StripAllTextures) do
				_G[object]:StripTextures()
			end
			
			for _, texture in pairs(KillTextures) do
				_G[texture]:Kill()
			end

			SkinNextPrevButton(SpellBookPrevPageButton)
			SkinNextPrevButton(SpellBookNextPageButton)
			
			--Skin SpellButtons
			local function SpellButtons(self, first)
				for i=1, SPELLS_PER_PAGE do
					local button = _G["SpellButton"..i]
					local icon = _G["SpellButton"..i.."IconTexture"]
					
					if first then
						button:StripTextures()
					end
					
					if _G["SpellButton"..i.."Highlight"] then
						_G["SpellButton"..i.."Highlight"]:SetTexture(1, 1, 1, 0.3)
						_G["SpellButton"..i.."Highlight"]:ClearAllPoints()
						_G["SpellButton"..i.."Highlight"]:SetAllPoints(icon)
					end

					if icon then
						icon:SetTexCoord(.08, .92, .08, .92)
						icon:ClearAllPoints()
						icon:SetAllPoints()
						
						button:SetFrameLevel(button:GetFrameLevel() + 2)
						if not button.backdrop then
							button:CreateBackdrop("Default", true)	
						end
					end

					_G["SpellButton"..i.."SubSpellName"]:SetTextColor(0.6, 0.6, 0.6)
				end
			end
			SpellButtons(nil, true)
			hooksecurefunc("SpellButton_UpdateButton", SpellButtons)
			
			--Skill Line Tabs
			for i=1, MAX_SKILLLINE_TABS do
				local tab = _G["SpellBookSkillLineTab"..i]
				if tab then
					tab:StripTextures()
					tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
					tab:GetNormalTexture():ClearAllPoints()

					tab:GetNormalTexture():Point("TOPLEFT", 2, -2)
					tab:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
					
					tab:CreateBackdrop("Default")
					tab.backdrop:SetAllPoints()
					tab:StyleButton(true)				
					
					local point, relatedTo, point2, x, y = tab:GetPoint()
					tab:Point(point, relatedTo, point2, 2, y)
				end
			end
			
			SpellBookFrame:SetTemplate("Default")
			SpellBookFrame:CreateShadow("Default")
			
			--Profession Tab
			local professionbuttons = {
				"PrimaryProfession1SpellButtonTop",
				"PrimaryProfession1SpellButtonBottom",
				"PrimaryProfession2SpellButtonTop",
				"PrimaryProfession2SpellButtonBottom",
				"SecondaryProfession1SpellButtonLeft",
				"SecondaryProfession1SpellButtonRight",
				"SecondaryProfession2SpellButtonLeft",
				"SecondaryProfession2SpellButtonRight",
				"SecondaryProfession3SpellButtonLeft",
				"SecondaryProfession3SpellButtonRight",
				"SecondaryProfession4SpellButtonLeft",
				"SecondaryProfession4SpellButtonRight",		
			}
			
			for _, button in pairs(professionbuttons) do
				local icon = _G[button.."IconTexture"]
				local button = _G[button]
				button:StripTextures()
				
				if icon then
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:ClearAllPoints()
					icon:Point("TOPLEFT", 2, -2)
					icon:Point("BOTTOMRIGHT", -2, 2)
					
					button:SetFrameLevel(button:GetFrameLevel() + 2)
					if not button.backdrop then
						button:CreateBackdrop("Default", true)	
						button.backdrop:SetAllPoints()
					end
				end					
			end
			
			local professionstatusbars = {
				"PrimaryProfession1StatusBar",	
				"PrimaryProfession2StatusBar",	
				"SecondaryProfession1StatusBar",	
				"SecondaryProfession2StatusBar",	
				"SecondaryProfession3StatusBar",	
				"SecondaryProfession4StatusBar",
			}
			
			for _, statusbar in pairs(professionstatusbars) do
				local statusbar = _G[statusbar]
				statusbar:StripTextures()
				statusbar:SetStatusBarTexture(C["media"].normTex)
				statusbar:SetStatusBarColor(0, 220/255, 0)
				statusbar:CreateBackdrop("Default")
				
				statusbar.rankText:ClearAllPoints()
				statusbar.rankText:SetPoint("CENTER")
			end
			
			--Mounts/Companions
			for i = 1, NUM_COMPANIONS_PER_PAGE do
				local button = _G["SpellBookCompanionButton"..i]
				local icon = _G["SpellBookCompanionButton"..i.."IconTexture"]
				button:StripTextures()
				button:StyleButton(false)
				
				if icon then
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:ClearAllPoints()
					icon:Point("TOPLEFT", 2, -2)
					icon:Point("BOTTOMRIGHT", -2, 2)
					
					button:SetFrameLevel(button:GetFrameLevel() + 2)
					if not button.backdrop then
						button:CreateBackdrop("Default", true)	
						button.backdrop:SetAllPoints()
					end
				end					
			end
			
			SkinButton(SpellBookCompanionSummonButton)
			SpellBookCompanionModelFrame:StripTextures()
			SpellBookCompanionModelFrameShadowOverlay:StripTextures()
			SpellBookCompanionsModelFrame:Kill()
			SpellBookCompanionModelFrame:SetTemplate("Default")
			
			SkinRotateButton(SpellBookCompanionModelFrameRotateRightButton)
			SkinRotateButton(SpellBookCompanionModelFrameRotateLeftButton)
			
			--Bottom Tabs
			for i=1, 5 do
				SkinTab(_G["SpellBookFrameTabButton"..i])
			end
		end
		
		--Character Frame
		do
			SkinCloseButton(CharacterFrameCloseButton)
			
			local slots = {
				"HeadSlot",
				"NeckSlot",
				"ShoulderSlot",
				"BackSlot",
				"ChestSlot",
				"ShirtSlot",
				"TabardSlot",
				"WristSlot",
				"HandsSlot",
				"WaistSlot",
				"LegsSlot",
				"FeetSlot",
				"Finger0Slot",
				"Finger1Slot",
				"Trinket0Slot",
				"Trinket1Slot",
				"MainHandSlot",
				"SecondaryHandSlot",
				"RangedSlot",
			}
			for _, slot in pairs(slots) do
				local icon = _G["Character"..slot.."IconTexture"]
				local slot = _G["Character"..slot]
				slot:StripTextures()
				slot:StyleButton(false)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				
				slot:SetFrameLevel(slot:GetFrameLevel() + 2)
				slot:CreateBackdrop("Default")
				slot.backdrop:SetAllPoints()
			end
			
			--Strip Textures
			local charframe = {
				"CharacterFrame",
				"CharacterModelFrame",
				"CharacterFrameInset", 
				"CharacterStatsPane",
				"CharacterFrameInsetRight",
				"PaperDollSidebarTabs",
				"PaperDollEquipmentManagerPane",
				"PaperDollFrameItemFlyout",
			}
			
			CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
			SkinNextPrevButton(CharacterFrameExpandButton)
			
			SkinRotateButton(CharacterModelFrameRotateLeftButton)
			SkinRotateButton(CharacterModelFrameRotateRightButton)
			CharacterModelFrameRotateLeftButton:Point("TOPLEFT", CharacterModelFrame, "TOPLEFT", 4, -4)
			CharacterModelFrameRotateRightButton:Point("TOPLEFT", CharacterModelFrameRotateLeftButton, "TOPRIGHT", 4, 0)
			
			--Swap item flyout frame (shown when holding alt over a slot)
			PaperDollFrameItemFlyout:HookScript("OnShow", function()
				PaperDollFrameItemFlyoutButtons:StripTextures()
				
				for i=1, PDFITEMFLYOUT_MAXITEMS do
					local button = _G["PaperDollFrameItemFlyoutButtons"..i]
					local icon = _G["PaperDollFrameItemFlyoutButtons"..i.."IconTexture"]
					if button then
						button:StyleButton(false)
						
						icon:SetTexCoord(.08, .92, .08, .92)
						button:GetNormalTexture():SetTexture(nil)
						
						icon:ClearAllPoints()
						icon:Point("TOPLEFT", 2, -2)
						icon:Point("BOTTOMRIGHT", -2, 2)	
						button:SetFrameLevel(button:GetFrameLevel() + 2)
						if not button.backdrop then
							button:CreateBackdrop("Default")
							button.backdrop:SetAllPoints()			
						end
					end
				end
			end)
			
			--Icon in upper right corner of character frame
			CharacterFramePortrait:Kill()
			CharacterModelFrame:CreateBackdrop("Default")

			local scrollbars = {
				"PaperDollTitlesPaneScrollBar",
				"PaperDollEquipmentManagerPaneScrollBar",
			}
			
			for _, scrollbar in pairs(scrollbars) do
				SkinScrollBar(_G[scrollbar])
			end
			
			for _, object in pairs(charframe) do
				_G[object]:StripTextures()
			end
			
			--Titles
			PaperDollTitlesPane:HookScript("OnShow", function(self)
				for x, object in pairs(PaperDollTitlesPane.buttons) do
					object.BgTop:SetTexture(nil)
					object.BgBottom:SetTexture(nil)
					object.BgMiddle:SetTexture(nil)

					object.Check:SetTexture(nil)
					object.text:SetFont(C["media"].font,12)
					object.text.SetFont = T.dummy
				end
			end)
			
			--Equipement Manager
			SkinButton(PaperDollEquipmentManagerPaneEquipSet)
			SkinButton(PaperDollEquipmentManagerPaneSaveSet)
			PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
			PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)
			PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
			PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
			PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
			PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
				for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
					object.BgTop:SetTexture(nil)
					object.BgBottom:SetTexture(nil)
					object.BgMiddle:SetTexture(nil)

					object.Check:SetTexture(nil)
					object.icon:SetTexCoord(.08, .92, .08, .92)
					
					if not object.backdrop then
						object:CreateBackdrop("Default")
					end
					
					object.backdrop:Point("TOPLEFT", object.icon, "TOPLEFT", -2, 2)
					object.backdrop:Point("BOTTOMRIGHT", object.icon, "BOTTOMRIGHT", 2, -2)
					object.icon:SetParent(object.backdrop)

					--Making all icons the same size and position because otherwise BlizzardUI tries to attach itself to itself when it refreshes
					object.icon:SetPoint("LEFT", object, "LEFT", 4, 0)
					object.icon.SetPoint = T.dummy
					object.icon:Size(36, 36)
					object.icon.SetSize = T.dummy
				end
				GearManagerDialogPopup:StripTextures()
				GearManagerDialogPopup:SetTemplate("Default")
				GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 4, 0)
				GearManagerDialogPopupScrollFrame:StripTextures()
				GearManagerDialogPopupEditBox:StripTextures()
				GearManagerDialogPopupEditBox:SetTemplate("Default")
				SkinButton(GearManagerDialogPopupOkay)
				SkinButton(GearManagerDialogPopupCancel)
				
				for i=1, NUM_GEARSET_ICONS_SHOWN do
					local button = _G["GearManagerDialogPopupButton"..i]
					local icon = button.icon
					
					if button then
						button:StripTextures()
						button:StyleButton(true)
						
						icon:SetTexCoord(.08, .92, .08, .92)
						_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)
						
						icon:ClearAllPoints()
						icon:Point("TOPLEFT", 2, -2)
						icon:Point("BOTTOMRIGHT", -2, 2)	
						button:SetFrameLevel(button:GetFrameLevel() + 2)
						if not button.backdrop then
							button:CreateBackdrop("Default")
							button.backdrop:SetAllPoints()			
						end
					end
				end
			end)
			
			--Handle Tabs at bottom of character frame
			for i=1, 4 do
				SkinTab(_G["CharacterFrameTab"..i])
			end
			
			--Buttons used to toggle between equipment manager, titles, and character stats
			local function FixSidebarTabCoords()
				for i=1, #PAPERDOLL_SIDEBARS do
					local tab = _G["PaperDollSidebarTab"..i]
					if tab then
						tab.Highlight:SetTexture(1, 1, 1, 0.3)
						tab.Highlight:Point("TOPLEFT", 3, -4)
						tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
						tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
						tab.Hider:Point("TOPLEFT", 3, -4)
						tab.Hider:Point("BOTTOMRIGHT", -1, 0)
						tab.TabBg:Kill()
						
						if i == 1 then
							for i=1, tab:GetNumRegions() do
								local region = select(i, tab:GetRegions())
								region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
								region.SetTexCoord = T.dummy
							end
						end
						tab:CreateBackdrop("Default")
						tab.backdrop:Point("TOPLEFT", 1, -2)
						tab.backdrop:Point("BOTTOMRIGHT", 1, -2)	
					end
				end
			end
			hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
			
			--Stat panels, atm it looks like 7 is the max
			for i=1, 7 do
				_G["CharacterStatsPaneCategory"..i]:StripTextures()
			end
			
			--Reputation
			local function UpdateFactionSkins()
				ReputationListScrollFrame:StripTextures()
				for i=1, GetNumFactions() do
					local statusbar = _G["ReputationBar"..i.."ReputationBar"]

					if statusbar then
						statusbar:SetStatusBarTexture(C["media"].normTex)
						
						if not statusbar.backdrop then
							statusbar:CreateBackdrop("Default")
						end
						
						_G["ReputationBar"..i.."Background"]:SetTexture(nil)
						_G["ReputationBar"..i.."LeftLine"]:SetTexture(nil)
						_G["ReputationBar"..i.."BottomLine"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
						_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
					end		
				end
				ReputationDetailFrame:StripTextures()
				ReputationDetailFrame:SetTemplate("Default")
				ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)			
			end	
			ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
			hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)
			
			--Currency
			TokenFrame:HookScript("OnShow", function()
				for i=1, GetCurrencyListSize() do
					local button = _G["TokenFrameContainerButton"..i]
					
					if button then
						button.highlight:Kill()
						button.categoryMiddle:Kill()	
						button.categoryLeft:Kill()	
						button.categoryRight:Kill()
						
						if button.icon then
							button.icon:SetTexCoord(.08, .92, .08, .92)
						end
					end
				end
				TokenFramePopup:StripTextures()
				TokenFramePopup:SetTemplate("Default")
				TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)				
			end)
			
			--Pet
			PetModelFrame:CreateBackdrop("Default")
			PetPaperDollFrameExpBar:StripTextures()
			PetPaperDollFrameExpBar:SetStatusBarTexture(C["media"].normTex)
			PetPaperDollFrameExpBar:CreateBackdrop("Default")
			SkinRotateButton(PetModelFrameRotateRightButton)
			SkinRotateButton(PetModelFrameRotateLeftButton)
			PetModelFrameRotateRightButton:ClearAllPoints()
			PetModelFrameRotateRightButton:Point("LEFT", PetModelFrameRotateLeftButton, "RIGHT", 4, 0)
			
			local xtex = PetPaperDollPetInfo:GetRegions()
			xtex:SetTexCoord(.12, .63, .15, .55)
			PetPaperDollPetInfo:CreateBackdrop("Default")
			PetPaperDollPetInfo:Size(24, 24)
			
			CharacterFrame:SetTemplate("Default")
			CharacterFrame:CreateShadow("Default")
		end
		
		-- Blizzard frame we want to reskin
		local skins = {
			"StaticPopup1",
			"StaticPopup2",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"AutoCompleteBox", -- this is the /w *nickname* box, press tab
			"ReadyCheckFrame",
			"GhostFrameContentsFrame",
			"ColorPickerFrame",
			"StackSplitFrame",
			"ChannelPullout",
			"ChannelPulloutTab",
			"RolePollPopup",
		}

		-- reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		for i = 1, getn(skins) do
			_G[skins[i]]:SetTemplate("Default")
			if _G[skins[i]] ~= _G["AutoCompleteBox"] and _G[skins[i]] ~= _G["BNToastFrame"] then -- frame to blacklist from create shadow function
				_G[skins[i]]:CreateShadow("Default")
			end
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default") self:ClearAllPoints() self:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default") end)
			end
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
			"MacOptions",
			"Help",
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local TukuiMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if TukuiMenuButtons then
				SkinButton(TukuiMenuButtons)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Left"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Middle"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Right"]:SetAlpha(0)
			end
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
			"ColorPickerFrame"
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
			"VideoOptionsFrameOkay", 
			"VideoOptionsFrameCancel", 
			"VideoOptionsFrameDefaults", 
			"VideoOptionsFrameApply", 
			"AudioOptionsFrameOkay", 
			"AudioOptionsFrameCancel", 
			"AudioOptionsFrameDefaults", 
			"InterfaceOptionsFrameDefaults", 
			"InterfaceOptionsFrameOkay", 
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"ColorPickerOkayButton",
			"ColorPickerCancelButton",
			"StackSplitOkayButton",
			"StackSplitCancelButton",
			"RolePollPopupAcceptButton"
		}
		
		for i = 1, getn(BlizzardButtons) do
		local TukuiButtons = _G[BlizzardButtons[i]]
			if TukuiButtons then
				SkinButton(TukuiButtons)
			end
		end
		
		-- if a button position or text is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:ClearAllPoints()
		_G["ReadyCheckFrameNoButton"]:ClearAllPoints()
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", 0, -22)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -6, 6)
		_G["ColorPickerOkayButton"]:SetPoint("RIGHT",_G["ColorPickerCancelButton"],"LEFT", -4,0)
		_G["ChannelPulloutTab"]:SetHeight(20)
		_G["ChannelPulloutTabText"]:ClearAllPoints()
		_G["ChannelPulloutTabText"]:SetPoint("TOP",0,-6)
				
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator
		_G["StackSplitFrame"]:GetRegions():Hide()
		_G["StaticPopup1EditBox"]:SetTemplate("Default")
		_G["StaticPopup1EditBoxLeft"]:SetTexture(nil)
		_G["StaticPopup1EditBoxMid"]:SetTexture(nil)
		_G["StaticPopup1EditBoxRight"]:SetTexture(nil)
		_G["ChannelPulloutBackground"]:Kill()
		_G["ChannelPulloutTabLeft"]:SetTexture(nil)
		_G["ChannelPulloutTabMiddle"]:SetTexture(nil)
		_G["ChannelPulloutTabRight"]:SetTexture(nil)
	end
	
	-- mac menu/option panel, made by affli.
	if IsMacClient() then
		-- Skin main frame and reposition the header
		MacOptionsFrame:SetTemplate("Default")
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		--Skin internal frames
		MacOptionsFrameMovieRecording:SetTemplate("Default")
		MacOptionsITunesRemote:SetTemplate("Default")
 
		--Skin buttons
		SkinButton(_G["MacOptionsFrameCancel"])
		SkinButton(_G["MacOptionsFrameOkay"])
		SkinButton(_G["MacOptionsButtonKeybindings"])
		SkinButton(_G["MacOptionsFrameDefaults"])
		SkinButton(_G["MacOptionsButtonCompress"])
 
		--Reposition and resize buttons
		local tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsButtonCompress"]:GetPoint()
		_G["MacOptionsButtonCompress"]:SetWidth(136)
		_G["MacOptionsButtonCompress"]:ClearAllPoints()
		_G["MacOptionsButtonCompress"]:Point(tPoint, tRTo, tRP, 4, tY)
 
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsFrameCancel"]:GetPoint()
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:Point(tPoint, tRTo, tRP, -14, tY)
 
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:Point("LEFT",_G["MacOptionsFrameCancel"],-99,0)
 
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:Point("LEFT",_G["MacOptionsFrameOkay"],-99,0)
 
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
		
		-- why these buttons is using game menu template? oO
		_G["MacOptionsButtonCompressLeft"]:SetAlpha(0)
		_G["MacOptionsButtonCompressMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonCompressRight"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsLeft"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsRight"]:SetAlpha(0)
	end
end)
