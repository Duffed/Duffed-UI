local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

--------------------------------------------------------------------
-- ZonePanel
--------------------------------------------------------------------
if C["datatext"].zonepanel == true then
	local Stat = CreateFrame("Frame")
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(C["datatext"].font, C["datatext"].fontsize)
	Text:SetPoint("CENTER", TukuiZonePanel, "CENTER", 0, 0)
	Stat:EnableMouse(true)
	Stat:SetAllPoints(Text)
	
	-- Coords Frame inside minimap
	local coordsframe = CreateFrame("Frame", "Coords_Frame", UIParent)
	coordsframe:CreatePanel("Transparent", TukuiMinimap:GetWidth() - 8, 18, "BOTTOM", TukuiMinimap, "BOTTOM", 0, 4)
	coordsframe:SetFrameLevel(5)
	coordsframe:SetAlpha(0)
	
	local coordsframetext = coordsframe:CreateFontString("CoordsFrame_Text", "LOW")
	coordsframetext:SetFont(C.datatext.font, C.datatext.fontsize)
	coordsframetext:Point("CENTER", coordsframe, "CENTER",0,-1)
	
	local function Update(self, event)	
		Text:SetText(strsub(GetMinimapZoneText(),1,22))
		
		local x, y = GetPlayerMapPosition("player");
		local coords = format("%.1f, %.1f",x*100,y*100)
		self:SetScript("OnEnter", function()
			Coords_Frame:SetAlpha(1)
			CoordsFrame_Text:SetText(T.panelcolor..coords)
		end)
		self:SetScript("OnLeave", function() Coords_Frame:SetAlpha(0) end)
	end
	
	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your current zone changes
	Stat:SetScript("OnUpdate", Update)
	
	Stat:SetScript("OnMouseDown", function() ToggleFrame(WorldMapFrame) end)
end

--------------------------------------------------------------------
-- Experience
--------------------------------------------------------------------
if C["datatext"].experience and C["datatext"].experience > 0 then
		local Stat = CreateFrame("Frame")
		Stat:EnableMouse(true)

		local Text = TukuiInfoLeft:CreateFontString(nil, "LOW")		
		Text:SetFont(C.datatext.font, C.datatext.fontsize)
		T.PP(C["datatext"].experience, Text)
	
		local function GetPlayerXP()
			return UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		end
		
		local function OnEvent(self, event)
			local min, max, rested = GetPlayerXP()
			local percentage = min / max * 100
			local bars = min / max * 20
		
			Text:SetText(format("XP: "..T.panelcolor.."%.2f%%", percentage))
			
			-- Setup Experience  tooltip
			self:SetAllPoints(Text)
			self:SetScript("OnEnter", function()
				if not InCombatLockdown() then
					local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
					if panel == TukuiMinimapStatsLeft or panel == TukuiMinimapStatsRight then
						GameTooltip:SetOwner(panel, anchor, xoff, yoff)
					else
						GameTooltip:SetOwner(self, anchor, xoff, yoff)
					end
					GameTooltip:ClearLines()
					GameTooltip:AddLine(format(T.panelcolor.."Experience")) 
					GameTooltip:AddDoubleLine("Earned:", format(T.panelcolor.."%.f", min), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Total:", format(T.panelcolor.."%.f", max), 1, 1, 1, .65, .65, .65)
					if rested ~= nil and rested > 0 then
						GameTooltip:AddDoubleLine("Rested:", format("|cff0090ff%.f", rested), 1, 1, 1, .65, .65, .65)
					end
					GameTooltip:AddDoubleLine("Bars:", format(T.panelcolor.."%d / 20", bars), 1, 1, 1, .65, .65, .65)
					GameTooltip:Show()
				end
			end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("PLAYER_XP_UPDATE")
	Stat:RegisterEvent("PLAYER_LEVEL_UP")
	Stat:RegisterEvent("UPDATE_EXHAUSTION")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", OnEnter)	
end

--------------------------------------------------------------------
-- Reputation
--------------------------------------------------------------------
if C["datatext"].reputation and C["datatext"].reputation > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")	
	Text:SetFont(C.datatext.font, C.datatext.fontsize)
	T.PP(C["datatext"].reputation, Text)


	local function OnEvent(self, event)
		local name, standing, max, min, value = GetWatchedFactionInfo()
		local percentage = (max - value) / (max - min) * 100
		
		if GetWatchedFactionInfo() ~= nil then
			Text:SetText(format(name..": %s%d%%", T.panelcolor, percentage))
		else
			Text:SetFormattedText(T.panelcolor.."No Faction")
		end
	
		-- Setup Reputation tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
				if panel == TukuiMinimapStatsLeft or panel == TukuiMinimapStatsRight then
					GameTooltip:SetOwner(panel, anchor, xoff, yoff)
				else
					GameTooltip:SetOwner(self, anchor, xoff, yoff)
				end
				GameTooltip:ClearLines()
				if GetWatchedFactionInfo() ~= nil then
					GameTooltip:AddLine(T.panelcolor.."Reputation")
					GameTooltip:AddDoubleLine("Faction:", format("|cffffffff"..name), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Standing:", _G['FACTION_STANDING_LABEL'..standing], 1, 1, 1, FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
					GameTooltip:AddDoubleLine("Rep earned:", format("|cffffffff%.f", value - max), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Rep total:", format("|cffffd200%.f", min - max), 1, 1, 1, .65, .65, .65)
				else
					GameTooltip:AddDoubleLine("|cffffffffFaction:|r")
					GameTooltip:AddLine(T.panelcolor.."No Faction Tracked")
				end
				GameTooltip:Show()
			end
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("UPDATE_FACTION")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", OnEnter)
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)
end

--------------------------------------------------------------------
-- Honor
--------------------------------------------------------------------
if C["datatext"].honor and C["datatext"].honor > 0 then
	local Stat = CreateFrame("Frame")	
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(C.datatext.font, C.datatext.fontsize)
	T.PP(C["datatext"].honor, Text)
	
	local function OnEvent(self, event)
		local _, amount, _ = GetCurrencyInfo(392)
		Text:SetText("Honor: "..T.panelcolor..amount)
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honor changes
	Stat:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

	Stat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- Honorable Kills
--------------------------------------------------------------------
if C["datatext"].honorablekills and C["datatext"].honorablekills > 0 then
	local Stat = CreateFrame("Frame")	
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(C.datatext.font, C.datatext.fontsize)
	T.PP(C["datatext"].honorablekills, Text)
	
	local function OnEvent(self, event)
		Text:SetText("Kills: "..T.panelcolor..GetPVPLifetimeStats())
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honorable kills changes
	Stat:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")

	Stat:SetScript("OnEvent", OnEvent)
end