local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

T.dummy = function() return end
T.myname = select(1, UnitName("player"))
T.myrealm = GetRealmName()
T.myclass = select(2, UnitClass("player"))
T.client = GetLocale() 
T.resolution = GetCurrentResolution()
T.getscreenresolution = select(T.resolution, GetScreenResolutions())
T.getscreenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
T.getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"))
T.version = GetAddOnMetadata("Tukui", "Version")
T.versionnumber = tonumber(T.version)
T.incombat = UnitAffectingCombat("player")
T.patch, T.build, T.releasedate, T.toc = GetBuildInfo()
T.level = UnitLevel("player")
T.TotemOrientationDown = false
T.Duffed = true
if T.getscreenwidth < 1600 and T.lowversion ~= true then
	T.InfoLeftRightWidth = 340
else
	T.InfoLeftRightWidth = 345
end