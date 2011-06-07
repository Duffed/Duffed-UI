-- Credits to Dajova :-*
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not IsAddOnLoaded("TinyDPS") or not C.skins.TinyDPS then return end

local TinyDPS = CreateFrame("Frame")
TinyDPS:RegisterEvent("ADDON_LOADED")
TinyDPS:SetScript("OnEvent", function(self, event, addon)
	if not addon == "TinyDPS" then return end
	tdps.barHeight = 16
	tdpsFont.name = C.datatext.font
	tdpsPosition = {x = 0, y = -6}
	tdpsFrame:SetHeight(tdps.barHeight + 4)
	tdpsFrame:SetTemplate("Default")
	tdpsFrame:CreateShadow("Default")
	if TukuiMinimap then
		tdps.width = TukuiMinimap:GetWidth()
		tdpsAnchor:SetPoint('BOTTOMLEFT', TukuiMinimapStatsLeft or TukuiReputation or TukuiMinimap, 'BOTTOMLEFT', 0, -6)
	end
	if tdpsStatusBar then
		tdpsStatusBar:SetStatusBarTexture(C["media"].normTex)
	end
	self:UnregisterEvent("ADDON_LOADED")
end)