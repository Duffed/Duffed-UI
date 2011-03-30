-- Font
if not IsAddOnLoaded("Tukui") then
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
end
GameFontNormalSmall:SetFont(dStuff.font, 12)
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14

-- Scale some default blizz frames up
local scale = 1.1
PlayerFrame:SetScale(scale)
TargetFrame:SetScale(scale)
FocusFrame:SetScale(scale)
PartyMemberFrame4:SetScale(scale)
PartyMemberFrame3:SetScale(scale)
PartyMemberFrame2:SetScale(scale)
PartyMemberFrame1:SetScale(scale)

-- [[Interface\TargetingFrame\UI-Statusbar]] = [[Interface\BUTTONS\WHITE8X8]]

-- Name in classcolor
hooksecurefunc("UnitFrame_Update", function(self)
	if UnitIsPlayer(self.unit) then
		local classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(self.unit))]
		self.name:SetTextColor(classcolor.r,classcolor.g,classcolor.b,1)
		self.name:SetFont(dStuff.font, 12)
	end
end)