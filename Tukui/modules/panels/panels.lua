local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate") -- Mainbar (24)
TukuiBar1:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 27)
if T.lowversion then
	TukuiBar1:ClearAllPoints()
	TukuiBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 4)
	TukuiBar1:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	TukuiBar1:SetHeight((T.buttonsize * 2) + (T.buttonspacing * 3))
else
	TukuiBar1:SetWidth((T.buttonsize * 24) + (T.buttonspacing * 25))
	TukuiBar1:SetHeight((T.buttonsize * 1) + (T.buttonspacing * 2))
end

local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent, "SecureHandlerStateTemplate") -- Bar on top of Main bar (12)
TukuiBar2:CreatePanel("Default", 1, 1, "BOTTOM", TukuiBar1, "TOP", 0, 4)
TukuiBar2:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
TukuiBar2:SetHeight((T.buttonsize * 1) + (T.buttonspacing * 2))

local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent) -- Rightbars
TukuiBar3:CreatePanel("Default", 1, 1, "RIGHT", UIParent, "RIGHT", -14, -14)
TukuiBar3:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
TukuiBar3:SetHeight((T.buttonsize * 12) + (T.buttonspacing * 13))

local petbg = CreateFrame("Frame", "TukuiPetBar", UIParent, "SecureHandlerStateTemplate")
if C["actionbar"].petbarhorizontal == true then
	petbg:CreatePanel("Default",(T.petbuttonsize * 10) + (T.petbuttonspacing * 11), T.petbuttonsize + (T.petbuttonspacing * 2), "BOTTOM", TukuiBar2, "TOP", 0, 4)
else
	petbg:CreatePanel("Default", T.petbuttonsize + (T.petbuttonspacing * 2), (T.petbuttonsize * 10) + (T.petbuttonspacing * 11), "RIGHT", TukuiBar3, "LEFT", -6, 0)
end

local ltpetbg1 = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", petbg)
ltpetbg1:CreatePanel("Transparent", 24, 265, "LEFT", petbg, "RIGHT", 0, 0)
ltpetbg1:SetFrameLevel(0)
if C["actionbar"].petbarhorizontal == true then ltpetbg1:Hide() end

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "TukuiInfoLeft", TukuiBar1)
ileft:CreatePanel("Default", T.InfoLeftRightWidth, 19, "BOTTOMRIGHT", UIParent, "BOTTOM", -12, 4)
ileft:SetFrameLevel(2)
if T.lowversion then ileft:ClearAllPoints() ileft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 14, 3) end

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", TukuiBar1)
iright:CreatePanel("Default", T.InfoLeftRightWidth, 19, "BOTTOMLEFT", UIParent, "BOTTOM", 12, 4)
iright:SetFrameLevel(2)
if T.lowversion then iright:ClearAllPoints() iright:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -14, 3) end

if C["actionbar"].buttonsize > 26 and not T.lowversion then
	-- HORIZONTAL LINE LEFT
	local ltoabl = CreateFrame("Frame", "TukuiLineToABLeft", TukuiBar1)
	ltoabl:CreatePanel("Default", 10, 2, "RIGHT", ileft, "LEFT", 0, 0)

	-- HORIZONTAL LINE RIGHT
	local ltoabr = CreateFrame("Frame", "TukuiLineToABRight", TukuiBar1)
	ltoabr:CreatePanel("Default", 10, 2, "LEFT", iright, "RIGHT", 0, 0)

	-- LEFT VERTICAL LINE
	local ileftlv = CreateFrame("Frame", "TukuiInfoLeftLineVertical", TukuiBar1)
	ileftlv:CreatePanel("Default", 2, 13, "BOTTOM", ltoabl, "LEFT", 0, -1)

	-- RIGHT VERTICAL LINE
	local irightlv = CreateFrame("Frame", "TukuiInfoRightLineVertical", TukuiBar1)
	irightlv:CreatePanel("Default", 2, 13, "BOTTOM", ltoabr, "RIGHT", 0, -1)
end

if C["chat"].background == true then
	-- Chat 1 Background
	local chatbg = CreateFrame("Frame", "ChatBG1", UIParent)
	if not T.lowversion then
		chatbg:CreatePanel("Transparent", 430, 126, "TOPLEFT", ChatFrame1, "TOPLEFT", -5, 29)
		chatbg:Point("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 5, -5)
	else
		chatbg:CreatePanel("Transparent", 430, 126, "TOPLEFT", ChatFrame1, "TOPLEFT", -5, 29)
		chatbg:Point("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 5, -16)
	end
	chatbg:CreateShadow("Default")
	
	local tabchat1 = CreateFrame("Frame", "ChatBG1Tabs", chatbg)
	tabchat1:CreatePanel("Transparent", 1, 20, "TOPLEFT", chatbg, "TOPLEFT", 5, -5)
	tabchat1:Point("TOPRIGHT", chatbg, "TOPRIGHT", -28, -5)
	tabchat1:CreateShadow("Default")
	
	local copy1 = CreateFrame("Frame", nil, tabchat1)
	copy1:CreatePanel("Transparent", 20, 20, "LEFT", tabchat1, "RIGHT", 3, 0)
	copy1:CreateShadow("Default")

	-- Chat 4 Background
	local chatbg2 = CreateFrame("Frame", "ChatBG2", UIParent)
	chatbg2:CreatePanel("Transparent", 430, 126, "CENTER", UIParent, "CENTER", 0,0)
	chatbg2:CreateShadow("Default")
	chatbg2:Hide()
	
	local tabchat2 = CreateFrame("Frame", "ChatBG2Tabs", chatbg2)
	tabchat2:CreatePanel("Transparent", 1, 20, "TOPLEFT", chatbg2, "TOPLEFT", 5, -5)
	tabchat2:Point("TOPRIGHT", chatbg2, "TOPRIGHT", -28, -5)
	tabchat2:CreateShadow("Default")
	
	local copy2 = CreateFrame("Frame", nil, tabchat2)
	copy2:CreatePanel("Transparent", 20, 20, "LEFT", tabchat2, "RIGHT", 3, 0)
	copy2:CreateShadow("Default")
end

if TukuiMinimap then
	local minimapstatsleft = CreateFrame("Frame", "TukuiMinimapStatsLeft", TukuiMinimap)
	local minimapstatsright = CreateFrame("Frame", "TukuiMinimapStatsRight", TukuiMinimap)
	
	if C["datatext"].zonepanel == true then
		local zonepanel = CreateFrame("Frame", "TukuiZonePanel", TukuiMinimap)
		zonepanel:CreatePanel("Default", TukuiMinimap:GetWidth(), 19, "TOP", TukuiMinimap, "BOTTOM", 0, -2)
		zonepanel:CreateShadow("Default")
		
		minimapstatsleft:CreatePanel("Default", (TukuiMinimap:GetWidth()/ 2) - 1, 19, "TOPLEFT", TukuiZonePanel, "BOTTOMLEFT", 0, -2)
		minimapstatsright:CreatePanel("Default", (TukuiMinimap:GetWidth()/ 2) - 1, 19, "TOPRIGHT", TukuiZonePanel, "BOTTOMRIGHT", 0, -2)
	else
		minimapstatsleft:CreatePanel("Default", (TukuiMinimap:GetWidth()/ 2) - 1, 19, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -2)
		minimapstatsright:CreatePanel("Default", (TukuiMinimap:GetWidth()/ 2) - 1, 19, "TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", 0, -2)
	end
	
	minimapstatsleft:CreateShadow("Default")
	minimapstatsright:CreateShadow("Default")
end

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(3)
	bgframe:EnableMouse(true)
end

-- BNToastFrame Anchorframe
local bnet = CreateFrame("Frame", "TukuiBnetHolder", UIParent)
bnet:CreatePanel("Default", BNToastFrame:GetWidth(), BNToastFrame:GetHeight(), "BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 10)
if ChatBG1 then	bnet:Point("BOTTOMLEFT", ChatBG1, "TOPLEFT", 0, 4) end
bnet:SetClampedToScreen(true)
bnet:SetMovable(true)
bnet:SetBackdropBorderColor(1,0,0)
bnet.text = T.SetFontString(bnet, C.media.font, 12)
bnet.text:SetPoint("CENTER")
bnet.text:SetText("Move BnetFrame")
bnet:SetAlpha(0)

-- Omen Skin
if IsAddOnLoaded("Omen") then
	local omenbg = CreateFrame("Frame", "Omen_Background", OmenBarList)
	omenbg:CreatePanel("Transparent", 1, 1, "TOPRIGHT", OmenBarList, "TOPRIGHT", -1, 1)
	omenbg:SetPoint("BOTTOMLEFT", OmenBarList, "BOTTOMLEFT", 1, 1)
	omenbg:CreateShadow("Default")
end

-- Recount Skin
if IsAddOnLoaded("Recount") then
	local recountbg = CreateFrame("Frame", "Recount_Background", Recount.MainWindow)
	recountbg:CreatePanel("Transparent", 1, 1, "TOPRIGHT", Recount.MainWindow, "TOPRIGHT", 0, -10)
	recountbg:SetPoint("BOTTOMLEFT", Recount.MainWindow, "BOTTOMLEFT", 0, 1)
	recountbg:CreateShadow("Default")
end

-- Addons Background (same size as right chat background)
if C["chat"].addonborder == true then
	local bg = CreateFrame("Frame", nil, UIParent)
	bg:CreatePanel("Transparent", 376, 152, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4)
	bg:CreateShadow("Default")

	local bgtab = CreateFrame("Frame", nil, bg)
	bgtab:CreatePanel("Transparent", 1, 20, "TOPLEFT", bg, "TOPLEFT", 5, -5)
	bgtab:Point("TOPRIGHT", bg, "TOPRIGHT", -5, -5)
	bgtab:CreateShadow("Default")
end

-- Shadows
iright:CreateShadow("Default")
ileft:CreateShadow("Default")
TukuiBar1:CreateShadow("Default")
TukuiBar2:CreateShadow("Default")
TukuiBar3:CreateShadow("Default")
petbg:CreateShadow("Default")
BNToastFrame:CreateShadow("Default")