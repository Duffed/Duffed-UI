-- Font
if IsAddOnLoaded("Tukui") then
	GameFontNormalSmall:SetFont(TukuiCF["media"].font, 12)
else
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
end
GameFontNormalSmall:SetTextColor(1,1,1)
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14