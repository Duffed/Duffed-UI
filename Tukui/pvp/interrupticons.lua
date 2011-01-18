if TukuiCF["pvp"].interrupt ~= true then return end

tInterruptIcons = CreateFrame("frame")
tInterruptIcons:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
tInterruptIcons:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tInterruptIcons:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiArena = { ["x"] = 677, ["y"] = 383, ["orientation"] = "VERTICALUP" }
tInterruptIcons.Orientations = { 
	["HORIZONTALRIGHT"] = { ["point"] = "TOPLEFT", ["rpoint"] = "TOPRIGHT", ["x"] = 3, ["y"] = 0 },
	["HORIZONTALLEFT"] = { ["point"] = "TOPRIGHT", ["rpoint"] = "TOPLEFT", ["x"] = -3, ["y"] = 0 }, 
	["VERTICALDOWN"] = { ["point"] = "TOPLEFT", ["rpoint"] = "BOTTOMLEFT", ["x"] = 0, ["y"] = -3 },
	["VERTICALUP"] = { ["point"] = "BOTTOMLEFT", ["rpoint"] = "TOPLEFT", ["x"] = 0, ["y"] = 3 }, 
}

------------------------------------------------------------
-- spell configuration
------------------------------------------------------------

tInterruptIcons.Spells = TukuiDB.interrupt

------------------------------------------------------------
-- end of spell configuration
------------------------------------------------------------

SlashCmdList["tInterruptIcons"] = function(msg) tInterruptIcons.SlashHandler(msg) end
SLASH_tInterruptIcons1 = "/tcdt"
SLASH_tInterruptIcons2 = "/tracker"
SLASH_tInterruptIcons3 = "/kick"
SLASH_tInterruptIcons3 = "/ii"
tInterruptIcons:SetScript("OnEvent", function(this, event, ...) tInterruptIcons[event](...) end)
tInterruptIcons.Icons = { }

local pvpType

function tInterruptIcons.CreateIcon()
	local i = (#tInterruptIcons.Icons)+1
   
	tInterruptIcons.Icons[i] = CreateFrame("frame","tInterruptIconsIcon"..i,UIParent)
	tInterruptIcons.Icons[i]:SetHeight(TukuiDB.Scale(28))
	tInterruptIcons.Icons[i]:SetWidth(TukuiDB.Scale(28))
	tInterruptIcons.Icons[i]:SetFrameStrata("BACKGROUND")
	tInterruptIcons.Icons[i]:SetFrameLevel(20)
	  
	tInterruptIcons.Icons[i]:Hide()

	tInterruptIcons.Icons[i].Texture = tInterruptIcons.Icons[i]:CreateTexture(nil,"LOW")
	tInterruptIcons.Icons[i].Texture:SetTexture("Interface\\Icons\\ability_kick.blp")
	tInterruptIcons.Icons[i].Texture:SetPoint("TOPLEFT", tInterruptIcons.Icons[i], TukuiDB.Scale(2), TukuiDB.Scale(-2))
	tInterruptIcons.Icons[i].Texture:SetPoint("BOTTOMRIGHT", tInterruptIcons.Icons[i], TukuiDB.Scale(-2), TukuiDB.Scale(2))
	tInterruptIcons.Icons[i].Texture:SetTexCoord(.08, .92, .08, .92)
	
	TukuiDB.SetTemplate(tInterruptIcons.Icons[i])

	tInterruptIcons.Icons[i].TimerText = tInterruptIcons.Icons[i]:CreateFontString("tInterruptIconsTimerText","OVERLAY")
	tInterruptIcons.Icons[i].TimerText:SetFont(TukuiCF.media.font,14,"Outline")
	tInterruptIcons.Icons[i].TimerText:SetTextColor(1,0,0)
	tInterruptIcons.Icons[i].TimerText:SetShadowColor(0,0,0)
	tInterruptIcons.Icons[i].TimerText:SetShadowOffset(TukuiDB.mult,-TukuiDB.mult)
	tInterruptIcons.Icons[i].TimerText:SetPoint("CENTER", tInterruptIcons.Icons[i], "CENTER",TukuiDB.mult,0)
	tInterruptIcons.Icons[i].TimerText:SetText(5)
   
	return i
end

tInterruptIcons.CreateIcon()
tInterruptIcons.Icons[1]:RegisterForDrag("LeftButton")
tInterruptIcons.Icons[1]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", TukuiArena.x, TukuiArena.y)
tInterruptIcons.Icons[1]:SetScript("OnDragStart", function() tInterruptIcons.Icons[1]:StartMoving() end)
tInterruptIcons.Icons[1]:SetScript("OnDragStop", function() 
	tInterruptIcons.Icons[1]:StopMovingOrSizing() 
	TukuiArena.x = math.floor(tInterruptIcons.Icons[1]:GetLeft())
	TukuiArena.y = math.floor(tInterruptIcons.Icons[1]:GetTop())
end)

function tInterruptIcons.SlashHandler(msg)
	arg = string.upper(msg)
	if (tInterruptIcons[arg]) then
		tInterruptIcons[arg]()
	else
		tInterruptIcons.Print("Tukui Interrupt Icons Options:")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii unlock")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii lock")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii reset")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii horizontalright")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii horizontalleft")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii verticaldown")
		DEFAULT_CHAT_FRAME:AddMessage(" - /ii verticalup")
	end
end

function tInterruptIcons.UNLOCK()
	if (not tInterruptIcons.Icons[1]:IsMouseEnabled()) then
		tInterruptIcons.StopAllTimers()
		tInterruptIcons.Icons[1]:EnableMouse(true)
		tInterruptIcons.Icons[1]:SetMovable(true)
		tInterruptIcons.StartTimer(1,60,nil)
	end
end

function tInterruptIcons.LOCK()
	if (tInterruptIcons.Icons[1]:IsMouseEnabled()) then
		tInterruptIcons.Icons[1]:EnableMouse(false)
		tInterruptIcons.Icons[1]:SetMovable(false)
		tInterruptIcons.StopTimer(1)
	end
end

function tInterruptIcons.RESET()
	TukuiArena.x = 677
	TukuiArena.y = 383
	tInterruptIcons.Icons[1]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", TukuiArena.x, TukuiArena.y)
	tInterruptIcons.Print("Position reset successfully.")
end

function tInterruptIcons.HORIZONTALRIGHT()
	TukuiArena.orientation = "HORIZONTALRIGHT"
	tInterruptIcons.Print("Icons will now stack horizontally to the right.")
end

function tInterruptIcons.HORIZONTALLEFT()
	TukuiArena.orientation = "HORIZONTALLEFT"
	tInterruptIcons.Print("Icons will now stack horizontally to the left.")
end

function tInterruptIcons.VERTICALDOWN()
	TukuiArena.orientation = "VERTICALDOWN"
	tInterruptIcons.Print("Icons will now stack vertically downwards.")
end

function tInterruptIcons.VERTICALUP()
	TukuiArena.orientation = "VERTICALUP"
	tInterruptIcons.Print("Icons will now stack vertically upwards.")
end

function tInterruptIcons.Print(msg, ...)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF33[Tukui Cooldown Tracker]|r "..format(msg, ...))
end

function tInterruptIcons.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID)
	if (event == "SPELL_CAST_SUCCESS" and not tInterruptIcons.Icons[1]:IsMouseEnabled() and (bit.band(sourceFlags,COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)) then			
		if (sourceName ~= UnitName("player")) then
			if (tInterruptIcons.Spells[spellID]) then
				local _,_,texture = GetSpellInfo(spellID)
				tInterruptIcons.StartTimer(tInterruptIcons.NextAvailable(),tInterruptIcons.Spells[spellID],texture,spellID)
			end
		end
	end
end

function tInterruptIcons.NextAvailable()
	for i=1,#tInterruptIcons.Icons do
		if (not tInterruptIcons.Timers[i]) then
			return i
		end
	end
	return tInterruptIcons.CreateIcon()
end

tInterruptIcons.Timers = { }
function tInterruptIcons.StartTimer(icon, duration, texture, spellID)			
	tInterruptIcons.Timers[(icon)] = {
		["Start"] = GetTime(),
		["Duration"] = duration,
		["SpellID"] = spellID,
	}
	UIFrameFadeIn(tInterruptIcons.Icons[icon],0.2,0.0,1.0)
	if (texture) then
		tInterruptIcons.Icons[(active or icon)].Texture:SetTexture(texture)
		tInterruptIcons.Icons[(active or icon)].Texture:SetPoint("TOPLEFT", tInterruptIcons.Icons[(active or icon)], TukuiDB.Scale(2), TukuiDB.Scale(-2))
		tInterruptIcons.Icons[(active or icon)].Texture:SetPoint("BOTTOMRIGHT", tInterruptIcons.Icons[(active or icon)], TukuiDB.Scale(-2), TukuiDB.Scale(2))
		tInterruptIcons.Icons[(active or icon)].Texture:SetTexCoord(.08, .92, .08, .92)
		TukuiDB.SetTemplate(tInterruptIcons.Icons[(active or icon)])
	end
	tInterruptIcons.Reposition()
	tInterruptIcons:SetScript("OnUpdate", function(this, arg1) tInterruptIcons.OnUpdate(arg1) end)
end

function tInterruptIcons.StopTimer(icon)
	if (tInterruptIcons.Icons[icon]:IsMouseEnabled()) then
		tInterruptIcons.LOCK()
	end
	UIFrameFadeOut(tInterruptIcons.Icons[icon],0.2,1.0,0.0)
	tInterruptIcons.Timers[icon] = nil
	tInterruptIcons.Reposition()
	if (#tInterruptIcons.Timers == 0) then
		tInterruptIcons:SetScript("OnUpdate", nil)
	end
end

function tInterruptIcons.StopAllTimers()
	for i in pairs(tInterruptIcons.Timers) do
		tInterruptIcons.StopTimer(i)
	end
end

function tInterruptIcons.Reposition()
	local sorttable = { }
	local indexes = { }
	
	for i in pairs(tInterruptIcons.Timers) do
		tinsert(sorttable, tInterruptIcons.Timers[i].Start)
		indexes[tInterruptIcons.Timers[i].Start] = i
	end

	table.sort(sorttable)

	local currentactive = 0
	for k=1,#sorttable do
		local v = sorttable[k]
		local i = indexes[v]
		tInterruptIcons.Icons[i]:ClearAllPoints()
		if (currentactive == 0) then
			tInterruptIcons.Icons[i]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", TukuiArena.x, TukuiArena.y)
		else
			tInterruptIcons.Icons[i]:SetPoint(tInterruptIcons.Orientations[TukuiArena.orientation].point, 
				tInterruptIcons.Icons[currentactive], 
				tInterruptIcons.Orientations[TukuiArena.orientation].rpoint, 
				tInterruptIcons.Orientations[TukuiArena.orientation].x, 
				tInterruptIcons.Orientations[TukuiArena.orientation].y)
		end
		currentactive = i
	end
end

function tInterruptIcons.OnUpdate(elapsed)
	for i in pairs(tInterruptIcons.Timers) do
		local timeleft = tInterruptIcons.Timers[i].Duration+1-(GetTime()-tInterruptIcons.Timers[i].Start)
		if (timeleft < 0) then
			tInterruptIcons.StopTimer(i)
		else
			tInterruptIcons.Icons[i].TimerText:SetText(math.floor(timeleft))
		end
	end
end

function tInterruptIcons:PLAYER_ENTERING_WORLD()
	pvpType = GetZonePVPInfo()
end

function tInterruptIcons:ZONE_CHANGED_NEW_AREA()
	pvpType = GetZonePVPInfo()
	
	if pvpType == "Arena" then
		for i in pairs(tInterruptIcons.Timers) do
			tInterruptIcons.StopTimer(i)
		end
	end
end