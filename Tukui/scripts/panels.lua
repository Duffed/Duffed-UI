-- ACTION BAR PANEL
TukuiDB.buttonsize = TukuiDB.Scale(27)
TukuiDB.buttonspacing = TukuiDB.Scale(4)
if TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
	TukuiDB.petbuttonsize = TukuiDB.Scale(27)
else
	TukuiDB.petbuttonsize = TukuiDB.Scale(29)
end
TukuiDB.petbuttonspacing = TukuiDB.Scale(4)

-- set left and right info panel width
TukuiCF["panels"] = {["tinfowidth"] = 350}

local barbg = CreateFrame("Frame", "TukuiActionBarBackground", UIParent)
TukuiDB.CreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(27))
if TukuiDB.lowversion == true then
	barbg:SetWidth((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13))
	if TukuiCF["actionbar"].bottomrows == 2 then
		barbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 3))
	else
		barbg:SetHeight(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
	end
else
	barbg:SetWidth((TukuiDB.buttonsize * 24) + (TukuiDB.buttonspacing * 25))
	barbg:SetHeight(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
end
barbg:SetFrameStrata("BACKGROUND")
barbg:SetFrameLevel(1)

-- bar 3 Border
local barf3 = CreateFrame("Frame", "ActionBar3Background", UIParent)
TukuiDB.CreatePanel(barf3, 1, 1, "BOTTOM", TukuiActionBarBackground, "TOP", 0,TukuiDB.Scale(4))
barf3:SetWidth((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13))
barf3:SetHeight((TukuiDB.buttonsize * 1) + (TukuiDB.buttonspacing * 2))
barf3:Hide()

if TukuiCF["actionbar"].bottomrows == 2 then
	barf3:Show()
end

-- Chat background
if TukuiCF["chat"].enable == true then
	if TukuiCF["chat"].leftchatborder == true then
		local chatbg = CreateFrame("Frame", "ChatBG1", UIParent)
		TukuiDB.CreatePanel(chatbg, TukuiDB.Scale(430), TukuiDB.Scale(126), "TOPLEFT",ChatFrame1,"TOPLEFT",-5,29)
		chatbg:SetPoint("BOTTOMRIGHT",ChatFrame1,"BOTTOMRIGHT",5,-5)
		chatbg:SetBackdropColor(unpack(TukuiCF["media"].tooltipbackdrop))
		TukuiDB.CreateShadow(chatbg)
		
		local tabchat1 = CreateFrame("Frame", "ChatBG1Tabs", UIParent)
		TukuiDB.CreatePanel(tabchat1, 1, TukuiDB.Scale(20), "TOPLEFT", chatbg, "TOPLEFT", TukuiDB.Scale(5), TukuiDB.Scale(-5))
		tabchat1:SetPoint("TOPRIGHT", chatbg, "TOPRIGHT", TukuiDB.Scale(-28), TukuiDB.Scale(-5))
		TukuiDB.CreateShadow(tabchat1)
		
		local copy1 = CreateFrame("Frame", nil, tabchat1)
		TukuiDB.CreatePanel(copy1, TukuiDB.Scale(20), TukuiDB.Scale(20), "LEFT", tabchat1, "RIGHT", TukuiDB.Scale(3), 0)
		TukuiDB.CreateShadow(copy1)
	end
	if TukuiCF["chat"].rightchatborder == true then
		local chatbg2 = CreateFrame("Frame", "ChatBG2", UIParent)
		TukuiDB.CreatePanel(chatbg2,TukuiDB.Scale(430), TukuiDB.Scale(126), "TOPLEFT",ChatFrame4,"TOPLEFT",-5,29)
		chatbg2:SetPoint("BOTTOMRIGHT",ChatFrame4,"BOTTOMRIGHT",5,-5)
		chatbg2:SetBackdropColor(unpack(TukuiCF["media"].tooltipbackdrop))
		TukuiDB.CreateShadow(chatbg2)
		
		local tabchat2 = CreateFrame("Frame", "ChatBG2Tabs", UIParent)
		TukuiDB.CreatePanel(tabchat2, 1, TukuiDB.Scale(20), "TOPLEFT", chatbg2, "TOPLEFT", TukuiDB.Scale(5), TukuiDB.Scale(-5))
		tabchat2:SetPoint("TOPRIGHT", chatbg2, "TOPRIGHT", TukuiDB.Scale(-28), TukuiDB.Scale(-5))
		TukuiDB.CreateShadow(tabchat2)
		
		local copy2 = CreateFrame("Frame", nil, tabchat2)
		TukuiDB.CreatePanel(copy2, TukuiDB.Scale(20), TukuiDB.Scale(20), "LEFT", tabchat2, "RIGHT", TukuiDB.Scale(3), 0)
		TukuiDB.CreateShadow(copy2)
	end
end

-- HORIZONTAL LINE LEFT
local ltoabl = CreateFrame("Frame", "TukuiLineToABLeft", barbg)
TukuiDB.CreatePanel(ltoabl, 11, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabl:ClearAllPoints()
ltoabl:SetPoint("RIGHT", UIParent, "BOTTOM", -355, 12, TukuiDB.Scale(-1), TukuiDB.Scale(17))

-- HORIZONTAL LINE RIGHT
local ltoabr = CreateFrame("Frame", "TukuiLineToABRight", barbg)
TukuiDB.CreatePanel(ltoabr, 11, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabr:ClearAllPoints()
ltoabr:SetPoint("LEFT", UIParent, "BOTTOM", 355, 12, TukuiDB.Scale(1), TukuiDB.Scale(17))

-- LEFT VERTICAL LINE
local ileftlv = CreateFrame("Frame", "TukuiInfoLeftLineVertical", barbg)
TukuiDB.CreatePanel(ileftlv, 2, 15, "BOTTOMLEFT", ltoabl,"BOTTOMLEFT",0,0, TukuiDB.Scale(22), TukuiDB.Scale(30))

-- RIGHT VERTICAL LINE
local irightlv = CreateFrame("Frame", "TukuiInfoRightLineVertical", barbg)
TukuiDB.CreatePanel(irightlv, 2, 15, "BOTTOMRIGHT", ltoabr, "BOTTOMRIGHT",0,0, TukuiDB.Scale(-22), TukuiDB.Scale(30))

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "TukuiInfoLeft", barbg)
TukuiDB.CreatePanel(ileft, TukuiCF["panels"].tinfowidth, 19, "bottom",UIParent, -180,4)
ileft:SetFrameLevel(2)

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", barbg)
TukuiDB.CreatePanel(iright, TukuiCF["panels"].tinfowidth, 19, "bottom",UIParent, 180,4)
iright:SetFrameLevel(2)

if TukuiMinimap then
	local minimapstatsleft = CreateFrame("Frame", "TukuiMinimapStatsLeft", TukuiMinimap)	
	local minimapstatsright = CreateFrame("Frame", "TukuiMinimapStatsRight", TukuiMinimap)
	
	if TukuiCF["datatext"].zonepanel == true then
		local zonepanel = CreateFrame("Frame", "ZonePanel", TukuiMinimap)
		TukuiDB.CreatePanel(zonepanel, TukuiMinimap:GetWidth(), 19, "TOP", TukuiMinimap, "BOTTOM", 0, TukuiDB.Scale(-3))
		TukuiDB.CreateShadow(ZonePanel)
		
		TukuiDB.CreatePanel(minimapstatsleft, (TukuiMinimap:GetWidth() / 2) - 1, 19, "TOPLEFT", ZonePanel, "BOTTOMLEFT", 0, TukuiDB.Scale(-3))
		TukuiDB.CreatePanel(minimapstatsright, (TukuiMinimap:GetWidth() / 2) -1, 19, "TOPRIGHT", ZonePanel, "BOTTOMRIGHT", 0, TukuiDB.Scale(-3))
	else
		TukuiDB.CreatePanel(minimapstatsleft, (TukuiMinimap:GetWidth() / 2) - 1, 19, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, TukuiDB.Scale(-3))
		TukuiDB.CreatePanel(minimapstatsright, (TukuiMinimap:GetWidth() / 2) -1, 19, "TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", 0, TukuiDB.Scale(-3))
	end
	TukuiDB.CreateShadow(minimapstatsright)
	TukuiDB.CreateShadow(minimapstatsleft)
end

--RIGHT BAR BACKGROUND
if TukuiCF["actionbar"].enable == true or not (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	local barbgr = CreateFrame("Frame", "TukuiActionBarBackgroundRight", MultiBarRight)
	TukuiDB.CreatePanel(barbgr, 1, (TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13), "RIGHT", UIParent, "RIGHT", TukuiDB.Scale(-7), TukuiDB.Scale(-13.5))
	if TukuiCF["actionbar"].rightbars == 1 then
		barbgr:SetWidth(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
	elseif TukuiCF["actionbar"].rightbars == 2 then
		barbgr:SetWidth((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 3))
	elseif TukuiCF["actionbar"].rightbars == 3 then
		barbgr:SetWidth((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 4))
	else
		barbgr:Hide()
	end

	if not TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
		local petbg = CreateFrame("Frame", "TukuiPetActionBarBackground", PetActionButton1)
		TukuiDB.CreateShadow(petbg)
		if TukuiCF["actionbar"].rightbars > 0 then
			TukuiDB.CreatePanel(petbg, TukuiDB.petbuttonsize + (TukuiDB.petbuttonspacing * 2), (TukuiDB.petbuttonsize * 10) + (TukuiDB.petbuttonspacing * 11), "RIGHT", barbgr, "LEFT", TukuiDB.Scale(-6), 0)
		else
			TukuiDB.CreatePanel(petbg, TukuiDB.petbuttonsize + (TukuiDB.petbuttonspacing * 2), (TukuiDB.petbuttonsize * 10) + (TukuiDB.petbuttonspacing * 11), "RIGHT", UIParent, "RIGHT", TukuiDB.Scale(-6), TukuiDB.Scale(-13.5))
		end
	else
		local petbg = CreateFrame("Frame", "TukuiPetActionBarBackground1", PetActionButton1)
		TukuiDB.CreateShadow(petbg)
		if TukuiCF["actionbar"].bottomrows == 1 then
			TukuiDB.CreatePanel(petbg,(TukuiDB.buttonsize * 10) + (TukuiDB.buttonspacing * 11),TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2), "BOTTOM", TukuiActionBarBackground, "TOP", 0,TukuiDB.Scale(5))
		else
			TukuiDB.CreatePanel(petbg, (TukuiDB.buttonsize * 10) + (TukuiDB.buttonspacing * 11),TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2) , "BOTTOM", ActionBar3Background, "TOP", 0, TukuiDB.Scale(5))
		end
	end

	if not TukuiCF["actionbar"].petbarhorizontal.enable == true then
		local ltpetbg1 = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", PetActionButton1)
		TukuiDB.CreatePanel(ltpetbg1, 30, 265, "RIGHT", barbgr, "LEFT", TukuiDB.Scale(5), 0)
		ltpetbg1:SetFrameLevel(0)
		if TukuiCF["actionbar"].petbaralwaysvisible == true and TukuiCF["actionbar"].rightbarmouseover == true then
			ltpetbg1:SetAlpha(0)
		else
			ltpetbg1:SetAlpha(.8)
		end
	end
	
	TukuiDB.CreateShadow(barbgr)
end

--BATTLEGROUND STATS FRAME
if TukuiCF["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	TukuiDB.CreatePanel(bgframe, 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(3)
	bgframe:EnableMouse(true)
end

-- Frame i created cause mouseover rightbars sux if it fades out when ur mouse is behind (right) of them .. 
if TukuiCF["actionbar"].rightbarmouseover == true then
	local rbmoh = CreateFrame("Frame", "righthelp", MultiBarRight)
	rbmoh:SetPoint("LEFT", UIParent, "RIGHT", TukuiDB.Scale(-23), TukuiDB.Scale(-13.5))
	rbmoh:SetWidth(100)
	rbmoh:SetHeight((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13))
	rbmoh:SetFrameLevel(0)
	rbmoh:SetAlpha(0)
end

-- OMEN
if IsAddOnLoaded("Omen") then
	local omenbg = CreateFrame("Frame", "Omen_Background", OmenBarList)
	TukuiDB.CreatePanel(omenbg, 1, 1, "TOPRIGHT", OmenBarList, "TOPRIGHT", -1, 1)
	omenbg:SetPoint("BOTTOMLEFT", OmenBarList, "BOTTOMLEFT", 1, 1)
	omenbg:SetBackdropColor(unpack(TukuiCF["media"].tooltipbackdrop))
	TukuiDB.CreateShadow(omenbg)
end

-- RECOUNT
if IsAddOnLoaded("Recount") then
	local recountbg = CreateFrame("Frame", "Recount_Background", Recount.MainWindow)
	TukuiDB.CreatePanel(recountbg, 1, 1, "TOPRIGHT", Recount.MainWindow, "TOPRIGHT", 0, -10)
	recountbg:SetPoint("BOTTOMLEFT", Recount.MainWindow, "BOTTOMLEFT", 0, 1)
	recountbg:SetBackdropColor(unpack(TukuiCF["media"].tooltipbackdrop))
	TukuiDB.CreateShadow(recountbg)
end

-- Shadows
TukuiDB.CreateShadow(iright)
TukuiDB.CreateShadow(ileft)
TukuiDB.CreateShadow(barbg)
TukuiDB.CreateShadow(barf3)