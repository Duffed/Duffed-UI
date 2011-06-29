------------------------------------------------------------------------
-- auto-overwrite script config is X mod is found
------------------------------------------------------------------------

-- because users are too lazy to disable feature in config file
-- adding an auto disable if some mods are loaded
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if (IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") or IsAddOnLoaded("ag_UnitFrames")) then
	C["unitframes"].enable = false
end

if (IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft")) then
	C["nameplate"].enable = false
end

if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	C["actionbar"].enable = false
end

if (IsAddOnLoaded("Prat") or IsAddOnLoaded("Chatter")) then
	C["chat"].enable = false
end

if (IsAddOnLoaded("Quartz") or IsAddOnLoaded("AzCastBar") or IsAddOnLoaded("eCastingBar")) then
	C["castbar"].enable = false
end

if (IsAddOnLoaded("TipTac")) then
	C["tooltip"].enable = false
end

if (IsAddOnLoaded("Gladius")) then
	C["arena"].unitframes = false
end

-- doesnt really fit into "disable".lua but anyways
if C.general.normalfont then
	C.media.uffont = [=[Interface\Addons\Tukui\medias\fonts\normal_font.ttf]=]
	if C.unitframes.fontsize == 8 then C.unitframes.fontsize = 11 end
	C.datatext.font = [=[Interface\Addons\Tukui\medias\fonts\normal_font.ttf]=]
	if C.datatext.fontsize == 8 then C.datatext.fontsize = 12 end
	if C.unitframes.auratextscale == 8 then C.unitframes.auratextscale = 11 end
end

if C.general.classcoloredborder then
	C.media.bordercolor = T.oUF_colors.class[T.myclass]
end