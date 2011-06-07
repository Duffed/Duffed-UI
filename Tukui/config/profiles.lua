local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
----------------------------------------------------------------------------
-- Per Class Config (overwrite general)
-- Class need to be UPPERCASE
----------------------------------------------------------------------------

if T.myclass == "PRIEST" then
	-- do some config!
end

----------------------------------------------------------------------------
-- Per Character Name Config (overwrite general and class)
-- Name need to be case sensitive
----------------------------------------------------------------------------

if T.myname == "Sacerdus" then
	C.unitframes.gridvertical = true
end

----------------------------------------------------------------------------
-- Per Character Level Config 
----------------------------------------------------------------------------

if UnitLevel("player") < MAX_PLAYER_LEVEL then
	-- Settings for a Char you are leveling (lvl 1-MaxLevel)
	if C.datatext.reputation == 5 then
		C.datatext.reputation = 0
		C.datatext.experience = 5
	end
end

----------------------------------------------------------------------------
-- Special Configs :o
----------------------------------------------------------------------------

if IsAddOnLoaded("a") or IsAddOnLoaded("b") then
	C.datatext.reputation = 0
	C.datatext.experience = 0
	C.unitframes.priestarmor = true
	C.datatext.mmenu = 5
	C.pvp.ccannouncement = true
	C.castbar.classcolored = false
	C.actionbar.hotkey = false
	C.pvp.dispelannouncement = true
	C.tooltip.showspellid = true
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		C.actionbar.hotkey = true 
	end
end

if IsAddOnLoaded("b") then 
	C.skins.background = true
	C.actionbar.hotkey = true
	C.datatext.classcolored = true
	C.castbar.classcolored = true
	C.unitframes.vengeancebar = true
end