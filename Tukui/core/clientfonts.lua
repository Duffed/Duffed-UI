--------------------------------------------------------------------------
-- overwrite font for some language, because default font are incompatible
--------------------------------------------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if T.client == "zhTW" then
	C["media"].uffont = C["media"].tw_uffont
	C["media"].font = C["media"].tw_font
	C["media"].dmgfont = C["media"].tw_dmgfont
	if C["unitframes"].fontsize == 8 then C["unitframes"].fontsize = 11 end
elseif T.client == "koKR" then
	C["media"].uffont = C["media"].kr_uffont
	C["media"].font = C["media"].kr_font
	C["media"].dmgfont = C["media"].kr_dmgfont
	if C["unitframes"].fontsize == 8 then C["unitframes"].fontsize = 11 end
end