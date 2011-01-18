--------------------------------------------------------------------
-- BGScore (original feature by elv22, edited by Tukz)
--------------------------------------------------------------------

if TukuiCF["datatext"].battleground == true then
	-- CUBE AT LEFT, WILL ACT AS A BUTTON
	local cubeleft = CreateFrame("Frame", "TukuiCubeLeft", UIParent)
	TukuiDB.CreatePanel(cubeleft, 6, 17, "BOTTOM", UIParent, 0, 5)

	local bgframe = TukuiInfoLeftBattleGround	
	bgframe:SetScript("OnEnter", function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if ( name ) then
				if ( name == UnitName("player") ) then
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, TukuiDB.Scale(4));
					GameTooltip:ClearLines()
					GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, TukuiDB.Scale(1))
					GameTooltip:ClearLines()
					GameTooltip:AddLine(tukuilocal.datatext_ttstatsfor.."["..panelcolor..name.."|r]")
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttkillingblows, killingBlows,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorkills, honorableKills,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdeaths, deaths,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorgain, format('%d', honorGained),1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdmgdone, damageDone,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthealdone, healingDone,1,1,1)
					--Add extra statistics to watch based on what BG you are in.
					if GetRealZoneText() == tukuilocal.bg_arathi then 
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == tukuilocal.bg_warsong then 
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagsreturned,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == tukuilocal.bg_eye then 
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
					elseif GetRealZoneText() == tukuilocal.bg_alterac then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_graveyardsassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_graveyardsdefended,GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_towersassaulted,GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_towersdefended,GetBattlefieldStatData(i, 4),1,1,1)
					elseif GetRealZoneText() == tukuilocal.bg_strand then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_demolishersdestroyed,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_gatesdestroyed,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == tukuilocal.bg_isle then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					end			
					GameTooltip:Show()
				end
			end
		end
	end) 
	bgframe:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	
	local Text1  = TukuiInfoLeftBattleGround:CreateFontString(nil, "OVERLAY")
	Text1:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	Text1:SetPoint("LEFT", TukuiInfoLeftBattleGround, 30, 0)
	Text1:SetHeight(TukuiInfoLeft:GetHeight())

	local Text2  = TukuiInfoLeftBattleGround:CreateFontString(nil, "OVERLAY")
	Text2:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	Text2:SetPoint("CENTER", TukuiInfoLeftBattleGround, 0, 0)
	Text2:SetHeight(TukuiInfoLeft:GetHeight())

	local Text3  = TukuiInfoLeftBattleGround:CreateFontString(nil, "OVERLAY")
	Text3:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	Text3:SetPoint("RIGHT", TukuiInfoLeftBattleGround, -30, 0)
	Text3:SetHeight(TukuiInfoLeft:GetHeight())

	local int = 2
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local dmgtxt
			RequestBattlefieldScoreData()
			local numScores = GetNumBattlefieldScores()
			for i=1, numScores do
				local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
				if healingDone > damageDone then
					dmgtxt = (tukuilocal.datatext_healing..panelcolor..healingDone)
				else
					dmgtxt = (tukuilocal.datatext_damage..panelcolor..damageDone)
				end
				if ( name ) then
					if ( name == TukuiDB.myname ) then
						Text2:SetText(tukuilocal.datatext_honor..panelcolor..format('%d', honorGained))
						Text1:SetText(dmgtxt)
						Text3:SetText(tukuilocal.datatext_killingblows..panelcolor..killingBlows)
					end   
				end
			end 
			int  = 2
		end
	end
	
	--hide text when not in an bg
	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == "pvp") then
				bgframe:Show()
				cubeleft:Show()
				
				TukuiInfoLeft:SetBackdropColor(0,0,0,0)
			else
				Text1:SetText("")
				Text2:SetText("")
				Text3:SetText("")
				bgframe:Hide()
				cubeleft:Hide()
				
				TukuiInfoLeft:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
			end
		end
	end

	-- this part is to enable left cube as a button for battleground stat panel.
	local function CubeLeftClick(self, event)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			cubeleft:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
			inInstance, instanceType = IsInInstance()
			if TukuiCF["datatext"].battleground == true and (inInstance and (instanceType == "pvp")) then
				cubeleft:EnableMouse(true)
			else
				cubeleft:EnableMouse(false)
			end
		end   
	end
	cubeleft:SetScript("OnMouseDown", function()
		if bgframe:IsShown() then
			bgframe:Hide()
			TukuiInfoLeft:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
			cubeleft:SetBackdropBorderColor(0.78,0.03,0.08)
		else
			cubeleft:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
			bgframe:Show()
			TukuiInfoLeft:SetBackdropColor(0,0,0,0)
		end
	end)
	cubeleft:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	cubeleft:RegisterEvent("PLAYER_ENTERING_WORLD")
	cubeleft:SetScript("OnEvent", CubeLeftClick)
	
	bgframe:SetScript("OnMouseDown", function() ToggleFrame(WorldStateScoreFrame) end)
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 2)
end