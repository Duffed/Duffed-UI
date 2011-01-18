if TukuiCF["actionbar"].enable ~= true then return end

-- we just use default totem bar for shaman
-- we parent it to our shapeshift bar.
-- This is approx the same script as it was in WOTLK Tukui version.

if TukuiDB.myclass == "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(TukuiShiftBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", TukuiShiftBar, 0, TukuiDB.Scale(23))
 
		hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
 
		MultiCastActionBarFrame.SetParent = TukuiDB.dummy
		MultiCastActionBarFrame.SetPoint = TukuiDB.dummy
		MultiCastRecallSpellButton.SetPoint = TukuiDB.dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405
	end
end


local function mouseoverstance(alpha)
	if TukuiDB.myclass == "SHAMAN" then
		for i=1, 12 do
			local pb = _G["MultiCastActionButton"..i]
			pb:SetAlpha(alpha)
		end
		for i=1, 4 do
			local pb = _G["MultiCastSlotButton"..i]
			pb:SetAlpha(alpha)
		end
	end
end

-- Mouseover (temp disabled)
-- if TukuiCF["actionbar"].shapeshiftmouseover == true then
	-- if TukuiDB.myclass == "SHAMAN" then
		-- TukuiShiftBar:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
		-- TukuiShiftBar:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)
		-- MultiCastSummonSpellButton:SetAlpha(0)
		-- MultiCastSummonSpellButton:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
		-- MultiCastSummonSpellButton:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)
		-- MultiCastRecallSpellButton:SetAlpha(0)
		-- MultiCastRecallSpellButton:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
		-- MultiCastRecallSpellButton:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)
		-- MultiCastFlyoutFrameOpenButton:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
		-- MultiCastFlyoutFrameOpenButton:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)		

		-- for i=1, 4 do
			-- local pb = _G["MultiCastSlotButton"..i]
			-- pb:SetAlpha(0)
			-- pb:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
			-- pb:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)
		-- end
		-- for i=1, 4 do
			-- local pb = _G["MultiCastActionButton"..i]
			-- pb:SetAlpha(0)
			-- pb:HookScript("OnEnter", function(self) MultiCastSummonSpellButton:SetAlpha(1) MultiCastRecallSpellButton:SetAlpha(1) mouseoverstance(1) end)
			-- pb:HookScript("OnLeave", function(self) MultiCastSummonSpellButton:SetAlpha(0) MultiCastRecallSpellButton:SetAlpha(0) mouseoverstance(0) end)
		-- end
	-- end
-- end