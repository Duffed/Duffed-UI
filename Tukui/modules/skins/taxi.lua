local T, C, L = unpack(select(2, ...))
if not C.skins.blizzardframes then return end
local function LoadSkin()
	TaxiFrame:StripTextures()
	TaxiFrame:CreateBackdrop("Default")
	TaxiRouteMap:CreateBackdrop("Default")
	TaxiRouteMap.backdrop:SetAllPoints()
	T.SkinCloseButton(TaxiFrameCloseButton)
end

tinsert(T.SkinFuncs["Tukui"], LoadSkin)