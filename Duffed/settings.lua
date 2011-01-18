-- Move Player Target and Party Frame ..if u want :)
--[[Player Frame
PlayerFrame:ClearAllPoints()
PlayerFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", -180, 185)

-- Target Frame
TargetFrame:ClearAllPoints()
TargetFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 180, 185)

-- Party Frame
PartyMemberFrame1:ClearAllPoints()
PartyMemberFrame1:SetPoint("LEFT", UIParent, "LEFT", 350,-130)
]]

--Increase Scale of LootFrame
GroupLootFrame1:SetScale(1.1)
GroupLootFrame2:SetScale(1.1)
GroupLootFrame3:SetScale(1.1)
GroupLootFrame4:SetScale(1.1)
GroupLootFrame1:SetPoint("BOTTOM", 0, 210)

-- some frame changes
PlayerFrame:SetScale(1.15)
TargetFrame:SetScale(1.15)
FocusFrame:SetScale(1.15)
PartyMemberFrame4:SetScale(1.15)
PartyMemberFrame3:SetScale(1.15)
PartyMemberFrame2:SetScale(1.15)
PartyMemberFrame1:SetScale(1.15)

-- Bossframe Position
Boss1TargetFrame:SetPoint("TOP",Minimap,"BOTTOM",-60,-90)

-- Font
GameFontNormalSmall:SetFont("Interface\\AddOns\\Duffed\\Fonts\\CalibriBold.ttf",11)
GameFontNormalSmall:SetTextColor(1,1,1)
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14
CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}

ChatFontNormal:SetShadowColor(0, 0, 0, 0.8)
ChatFrame1:SetShadowColor(0, 0, 0, 0.8)
ChatFrame2:SetShadowColor(0, 0, 0, .8)
ChatFrame3:SetShadowColor(0, 0, 0, .8)

-- get parent
SlashCmdList["GETPARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"
SLASH_GETPARENT2 = "/parent"

-- Classcolored Names on blizz frame
--[[ disabled
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	hooksecurefunc("UnitFrame_Update", function(self)
		if UnitIsPlayer(self.unit) then
			local classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(self.unit))]
			self.name:SetTextColor(classcolor.r,classcolor.g,classcolor.b,1)
		end
	end)

	hooksecurefunc("UnitFrame_OnEvent", function(self, event, unit)
		if event == "UNIT_PORTRAIT_UPDATE" and UnitIsPlayer(self.unit) then
			local classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(self.unit))]
			self.name:SetTextColor(classcolor.r,classcolor.g,classcolor.b,1)
		end
	end)
end)
]]