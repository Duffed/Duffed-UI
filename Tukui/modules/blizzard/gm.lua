local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
------------------------------------------------------------------------
--	GM ticket position
------------------------------------------------------------------------

-- create our moving area
local TukuiGMFrameAnchor = CreateFrame("Button", "TukuiGMFrameAnchor", UIParent)
TukuiGMFrameAnchor:SetFrameStrata("TOOLTIP")
TukuiGMFrameAnchor:SetFrameLevel(20)
TukuiGMFrameAnchor:SetHeight(24)
TukuiGMFrameAnchor:SetWidth(60)
TukuiGMFrameAnchor:SetClampedToScreen(true)
TukuiGMFrameAnchor:SetMovable(true)
TukuiGMFrameAnchor:SetTemplate("Default")
TukuiGMFrameAnchor:SetBackdropBorderColor(1,0,0,1)
TukuiGMFrameAnchor:SetBackdropColor(unpack(C.media.backdropcolor))
TukuiGMFrameAnchor:Point("TOPLEFT", 257, -4)
TukuiGMFrameAnchor.text = T.SetFontString(TukuiGMFrameAnchor, C.media.uffont, 12)
TukuiGMFrameAnchor.text:SetPoint("CENTER")
TukuiGMFrameAnchor.text:SetText(L.move_gmframe)
TukuiGMFrameAnchor.text:SetParent(TukuiGMFrameAnchor)
TukuiGMFrameAnchor:Hide()

HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetAllPoints(TukuiGMFrameAnchor)
HelpOpenTicketButton.SetPoint = function() end
HelpOpenTicketButton:SetParent(UIParent)
HelpOpenTicketButton.text = T.SetFontString(HelpOpenTicketButton, C.datatext.font, C.datatext.fontsize)
HelpOpenTicketButton.text:SetPoint("CENTER")
HelpOpenTicketButton.text:SetText("Ticket")
HelpOpenTicketButton:SetScript("OnEnter", function() end)
HelpOpenTicketButton:SetScript("OnLeave", function() end)

------------------------------------------------------------------------
--	GM toggle command
------------------------------------------------------------------------

SLASH_GM1 = "/gm"
SlashCmdList["GM"] = function() ToggleHelpFrame() end