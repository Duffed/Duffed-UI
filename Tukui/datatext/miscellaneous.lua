--------------------------------------------------------------------
-- Reputation
-- Credits to Eclípsé
--------------------------------------------------------------------
if TukuiCF["datatext"].reputation and TukuiCF["datatext"].reputation > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)

	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")	
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	TukuiDB.PP(TukuiCF["datatext"].reputation, Text)
	
	local function GetHexColor(color)
		return (""..panelcolor..""):format(color.r * 255, color.g * 255, color.b * 255)
	end

	local function OnEvent(self, event)
		local name, standing, max, min, value = GetWatchedFactionInfo()
		local percentage = (max - value) / (max - min) * 100
		
		if standing == 1 or standing == 2 or standing == 3 or standing == 4 or standing == 5 or standing == 6 or standing == 7 or standing == 8 then
			Text:SetText(format(name..": %s%d%%", GetHexColor(FACTION_BAR_COLORS[standing]), percentage))
		else
			Text:SetFormattedText(format(""..panelcolor.."No Faction"))
		end
	
		-- Setup Reputation tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			--if not InCombatLockdown() then
				GameTooltip:SetOwner(Stat, "ANCHOR_TOP", 0, TukuiDB.Scale(6));
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, TukuiDB.mult)
				GameTooltip:ClearLines()
				if standing == 1 or standing == 2 or standing == 3 or standing == 4 or standing == 5 or standing == 6 or standing == 7 or standing == 8 then
					GameTooltip:AddLine(format(""..panelcolor.."Reputation:")) 
					GameTooltip:AddDoubleLine("Faction:", format("|cffffffff"..name), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Standing:", _G['FACTION_STANDING_LABEL'..standing], 1, 1, 1, FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
					GameTooltip:AddDoubleLine("Rep earned:", format("|cffffffff%.f", value - max), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Rep total:", format("|cffffd200%.f", min - max), 1, 1, 1, .65, .65, .65)
				else
					GameTooltip:AddDoubleLine(format(""..panelcolor.."Faction:"))
					GameTooltip:AddLine(format("|cffffffffNo Faction Tracked"))
				end
				GameTooltip:Show()
			--end
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
-- Experience
-- Credits to Eclípsé
--------------------------------------------------------------------
if TukuiCF["datatext"].experience and TukuiCF["datatext"].experience > 0 then
		local Stat = CreateFrame("Frame")
		Stat:EnableMouse(true)

		local Text = TukuiInfoLeft:CreateFontString(nil, "LOW")		
		Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
		TukuiDB.PP(TukuiCF["datatext"].experience, Text)
	
		local function GetPlayerXP()
			return UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		end
		
		local function OnEvent(self, event)
			local min, max, rested = GetPlayerXP()
			local percentage = min / max * 100
			local bars = min / max * 20
		
			if rested ~= nil and rested > 0 then
				Text:SetText(format("XP: |cff0090ff%.2f%%  |cffffffffR: |cff0090ff%.2f%%|cffffffff", percentage, rested / max * 100))
			else
				Text:SetText(format("XP: |cffffd200%.2f%%", percentage))
			end
			
			-- Setup Experience  tooltip
			self:SetAllPoints(Text)
			self:SetScript("OnEnter", function()
				--if not InCombatLockdown() then
					GameTooltip:SetOwner(Stat, "ANCHOR_TOP", 0, TukuiDB.Scale(6));
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, TukuiDB.mult)
					GameTooltip:ClearLines()
					GameTooltip:AddLine(format(""..panelcolor.."Experience:")) 
					GameTooltip:AddDoubleLine("Earned:", format("|cffffffff%.f", min), 1, 1, 1, .65, .65, .65)
					GameTooltip:AddDoubleLine("Total:", format("|cffffd200%.f", max), 1, 1, 1, .65, .65, .65)
					if rested ~= nil and rested > 0 then
						GameTooltip:AddDoubleLine("Rested:", format("|cff0090ff%.f", rested), 1, 1, 1, .65, .65, .65)
					end
					GameTooltip:AddDoubleLine("Bars:", format("|cffffffff%d / 20", bars), 1, 1, 1, .65, .65, .65)
					GameTooltip:Show()
				--end
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
-- Honor
-- Credits to Dricus
--------------------------------------------------------------------
if TukuiCF["datatext"].honor and TukuiCF["datatext"].honor > 0 then
	local Stat = CreateFrame("Frame")
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	TukuiDB.PP(TukuiCF["datatext"].honor, Text)
	
	local function OnEvent(self, event)
		Text:SetText("Honor" .. ":"..panelcolor.." " .. GetHonorCurrency())
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honor changes
	Stat:RegisterEvent("HONOR_CURRENCY_UPDATE")

	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() TogglePVPFrame() end)
end

--------------------------------------------------------------------
-- Honorable Kills
-- Credits to Dricus
--------------------------------------------------------------------
if TukuiCF["datatext"].honorablekills and TukuiCF["datatext"].honorablekills > 0 then
	local Stat = CreateFrame("Frame")
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	TukuiDB.PP(TukuiCF["datatext"].honorablekills, Text)
	
	local function OnEvent(self, event)
		Text:SetText("Kills" .. ":"..panelcolor.." " .. GetPVPLifetimeStats())
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honorable kills changes
	Stat:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")

	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() TogglePVPFrame() end)
end

--------------------------------------------------------------------
-- ZonePanel
--------------------------------------------------------------------
if TukuiCF["datatext"].zonepanel == true then
	local Stat = CreateFrame("Frame")
	local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")		
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	Text:SetPoint("CENTER", ZonePanel, "CENTER", 0, 0)
	Stat:EnableMouse(true)
	Stat:SetAllPoints(Text)
	
	-- Coords Frame inside minimap
	local coordsframe = CreateFrame("Frame", "Coords_Frame", UIParent)
	TukuiDB.CreatePanel(coordsframe, TukuiMinimap:GetWidth() - 4, 18, "BOTTOM", TukuiMinimap, "BOTTOM", 0, TukuiDB.Scale(4))
	coordsframe:SetBackdropColor(unpack(TukuiCF.media.tooltipbackdrop))
	coordsframe:SetFrameLevel(5)
	coordsframe:SetAlpha(0)
	
	local coordsframetext = coordsframe:CreateFontString("CoordsFrame_Text", "LOW")
	coordsframetext:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	coordsframetext:SetPoint("CENTER", coordsframe, "CENTER",0,-1)
	
	local function Update(self, event)	
		Text:SetText(strsub(GetMinimapZoneText(),1,20))
		
		local x, y = GetPlayerMapPosition("player");
		local coords = format("%.1f, %.1f",x*100,y*100)
		self:SetScript("OnEnter", function()
			Coords_Frame:SetAlpha(1)
			CoordsFrame_Text:SetText(panelcolor..coords)
		end)
		self:SetScript("OnLeave", function() Coords_Frame:SetAlpha(0) end)
	end
	
	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your current zone changes
	Stat:SetScript("OnUpdate", Update)
	
	Update(Stat, 10)
	
	Stat:SetScript("OnMouseDown", function() ToggleFrame(WorldMapFrame) end)
end