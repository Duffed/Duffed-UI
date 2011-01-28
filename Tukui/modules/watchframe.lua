local TukuiWatchFrame = CreateFrame("Frame", "TukuiWatchFrame", UIParent)
TukuiWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- to be compatible with blizzard option
local wideFrame = GetCVar("watchFrameWidth")

-- create our moving area
local TukuiWatchFrameAnchor = CreateFrame("Button", "TukuiWatchFrameAnchor", UIParent)
TukuiWatchFrameAnchor:SetFrameStrata("TOOLTIP")
TukuiWatchFrameAnchor:SetFrameLevel(20)
TukuiWatchFrameAnchor:SetHeight(20)
TukuiWatchFrameAnchor:SetClampedToScreen(true)
TukuiWatchFrameAnchor:SetMovable(true)
TukuiDB.SetTemplate(TukuiWatchFrameAnchor)
TukuiWatchFrameAnchor:SetBackdropBorderColor(0,0,0,0)
TukuiWatchFrameAnchor:SetBackdropColor(0,0,0,0)
TukuiWatchFrameAnchor.text = TukuiDB.SetFontString(TukuiWatchFrameAnchor, TukuiCF.media.uffont, 12)
TukuiWatchFrameAnchor.text:SetPoint("CENTER")
TukuiWatchFrameAnchor.text:SetText("Move WatchFrame")
TukuiWatchFrameAnchor.text:SetAlpha(0)

-- set default position according to how many right bars we have
if TukuiCF.actionbar.rightbars == 3 then
	TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-150), TukuiDB.Scale(-230))
elseif TukuiCF.actionbar.rightbars == 2 then
	TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-120), TukuiDB.Scale(-230))
elseif TukuiCF.actionbar.rightbars == 1 then
	TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-90), TukuiDB.Scale(-230))
else
	TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-30), TukuiDB.Scale(-230))
end

-- width of the watchframe according to our Blizzard cVar.
if wideFrame == "1" then
	TukuiWatchFrame:SetWidth(350)
	TukuiWatchFrameAnchor:SetWidth(350)
else
	TukuiWatchFrame:SetWidth(250)
	TukuiWatchFrameAnchor:SetWidth(250)
end

local screenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
TukuiWatchFrame:SetParent(TukuiWatchFrameAnchor)
TukuiWatchFrame:SetHeight(screenheight / 1.6)
TukuiWatchFrame:ClearAllPoints()
TukuiWatchFrame:SetPoint("TOP")

local function init()
	TukuiWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	TukuiWatchFrame:RegisterEvent("CVAR_UPDATE")
	TukuiWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
		if cvar == "WATCH_FRAME_WIDTH_TEXT" then
			if not WatchFrame.userCollapsed then
				if value == "1" then
					TukuiWatchFrame:SetWidth(350)
					TukuiWatchFrameAnchor:SetWidth(350)
				else
					TukuiWatchFrame:SetWidth(250)
					TukuiWatchFrameAnchor:SetWidth(250)
				end
			end
			wideFrame = value
		end
	end)
end

local function setup()	
	WatchFrame:SetParent(TukuiWatchFrame)
	WatchFrame:SetFrameStrata("MEDIUM")
	WatchFrame:SetFrameLevel(3)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32,-2.5)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = TukuiDB.dummy

	WatchFrameTitle:SetParent(TukuiWatchFrame)
	WatchFrameCollapseExpandButton:SetParent(TukuiWatchFrame)
	WatchFrameTitle:Hide()
	WatchFrameTitle.Show = TukuiDB.dummy
end

------------------------------------------------------------------------
-- Execute setup after we enter world
------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed > .5 then
		setup()
		f:Hide()
	end
end)
TukuiWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)

------------------------------------------------------------------------
-- make WatchFrame movable on screen
------------------------------------------------------------------------

local move = false

function TukuiMoveWatchFrame(msg)
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local anchor = TukuiWatchFrameAnchor
	anchor:SetUserPlaced(true)
	
	if msg == "reset" then
		if TukuiCF.actionbar.rightbars == 3 then
			anchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-150), TukuiDB.Scale(-230))
		elseif TukuiCF.actionbar.rightbars == 2 then
			anchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-120), TukuiDB.Scale(-230))
		elseif TukuiCF.actionbar.rightbars == 1 then
			anchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-90), TukuiDB.Scale(-230))
		else
			anchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-30), TukuiDB.Scale(-230))
		end
	else
		if move == false then
			move = true
			anchor:SetBackdropBorderColor(1,0,0,1)
			anchor:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
			anchor.text:SetAlpha(1)
			anchor:EnableMouse(true)
			anchor:RegisterForDrag("LeftButton", "RightButton")
			anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
			anchor:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		elseif move == true then
			move = false
			anchor:SetBackdropBorderColor(0,0,0,0)
			anchor:SetBackdropColor(0,0,0,0)
			anchor.text:SetAlpha(0)
			anchor:EnableMouse(false)
		end
	end
end
SLASH_MOVEWATCHFRAME1 = "/mwf"
SLASH_MOVEWATCHFRAME2 = "/wf"
SlashCmdList["MOVEWATCHFRAME"] = TukuiMoveWatchFrame
