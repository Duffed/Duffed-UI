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

if T.myname == "yournamehere" then
	-- do some config!
end

----------------------------------------------------------------------------
-- Per Character Level Config 
----------------------------------------------------------------------------

if UnitLevel("player") < MAX_PLAYER_LEVEL then
	-- Settings for a Char you are leveling (lvl 1-MaxLevel)
	C["datatext"].reputation = 0
	C["datatext"].experience = 5
	C["actionbar"].hotkey = true
end

if IsAddOnLoaded("a") then -- my config for every char
	C["datatext"].reputation = 0
	C["datatext"].experience = 0
	C["unitframes"].priestarmor = true
	C["datatext"].mmenu = 5
	C["pvp"].ccannouncement = true
	C["media"].uffont = [[Fonts\1.ttf]]
	C["media"].uffontsize = 8
end