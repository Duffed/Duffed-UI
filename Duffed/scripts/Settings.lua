-- Font
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	GameFontNormalSmall:SetFont(C["media"].font, 12)
else
	GameFontNormalSmall:SetFont("Fonts\\FRIZQT__.TTF", 12)
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
end
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14