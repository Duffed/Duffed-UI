------------------------------------------------------------------------
-- prevent action bar users config errors
------------------------------------------------------------------------

if TukuiCF["actionbar"].bottomrows == 0 or TukuiCF["actionbar"].bottomrows > 2 then
	TukuiCF["actionbar"].bottomrows = 1
end

if TukuiCF["actionbar"].rightbars > 3 then
	TukuiCF["actionbar"].rightbars = 3
end

if TukuiCF["actionbar"].rightbars == 3 then
	TukuiCF["actionbar"].bottomrows = 1
end

if TukuiCF["actionbar"].swapbar1and3 == true then
	TukuiCF["actionbar"].bottomrows = 2
	TukuiCF["actionbar"].bar3mouseover = false
end

------------------------------------------------------------------------
-- Everything classcolored
------------------------------------------------------------------------

if TukuiCF["duffed"].everythingclasscolored == true then
	TukuiCF["duffed"]["filgerbarcolor"].classcolor = true
	TukuiCF["castbar"].classcolor = true
	TukuiCF["datatext"]["panelcolor"].classcolor = true
end

--------------------------------------------------------------------------
-- overwrite font for some language, because default font are incompatible
--------------------------------------------------------------------------

if TukuiDB.client == "ruRU" then
	TukuiCF["media"].uffont = TukuiCF["media"].ru_uffont
	TukuiCF["media"].font = TukuiCF["media"].ru_font
	TukuiCF["media"].dmgfont = TukuiCF["media"].ru_dmgfont
elseif TukuiDB.client == "zhTW" then
	TukuiCF["media"].uffont = TukuiCF["media"].tw_uffont
	TukuiCF["media"].font = TukuiCF["media"].tw_font
	TukuiCF["media"].dmgfont = TukuiCF["media"].tw_dmgfont
elseif TukuiDB.client == "koKR" then
	TukuiCF["media"].uffont = TukuiCF["media"].kr_uffont
	TukuiCF["media"].font = TukuiCF["media"].kr_font
	TukuiCF["media"].dmgfont = TukuiCF["media"].kr_dmgfont
elseif TukuiDB.client == "frFR" then
	TukuiCF["media"].uffont = TukuiCF["media"].fr_uffont
	TukuiCF["media"].font = TukuiCF["media"].fr_font
	TukuiCF["media"].dmgfont = TukuiCF["media"].fr_dmgfont
end

------------------------------------------------------------------------
-- auto-overwrite script config is X mod is found
------------------------------------------------------------------------

-- because users are too lazy to disable feature in config file
-- adding an auto disable if some mods are loaded

if (IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") or IsAddOnLoaded("ag_UnitFrames")) then
	TukuiCF["unitframes"].enable = false
end

if (IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft")) then
	TukuiCF["nameplate"].enable = false
end

if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	TukuiCF["actionbar"].enable = false
end

if (IsAddOnLoaded("Mapster")) then
	TukuiCF["map"].enable = false
end

if (IsAddOnLoaded("Prat") or IsAddOnLoaded("Chatter")) then
	TukuiCF["chat"].enable = false
end

if (IsAddOnLoaded("Quartz") or IsAddOnLoaded("AzCastBar") or IsAddOnLoaded("eCastingBar")) then
	TukuiCF["unitframes"].unitcastbar = false
end

if (IsAddOnLoaded("Afflicted3") or IsAddOnLoaded("InterruptBar")) then
	TukuiCF["arena"].spelltracker = false
end

if (IsAddOnLoaded("TipTac")) then
	TukuiCF["tooltip"].enable = false
end

if (IsAddOnLoaded("Gladius")) then
	TukuiCF["arena"].unitframes = false
end

------------------------------------------------------------------------
-- Others
------------------------------------------------------------------------
