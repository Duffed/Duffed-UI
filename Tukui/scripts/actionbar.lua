if not TukuiCF["actionbar"].enable == true then return end
local db = TukuiCF["actionbar"]

------------------------------------------------------------------------------------------
-- the bar holder
------------------------------------------------------------------------------------------

-- create it
local TukuiBar1 = CreateFrame("Frame","TukuiBar1",UIParent) 
local TukuiBar2 = CreateFrame("Frame","TukuiBar2",UIParent) 
local TukuiBar3 = CreateFrame("Frame","TukuiBar3",UIParent) 
local TukuiBar4 = CreateFrame("Frame","TukuiBar4",UIParent) 
local TukuiBar5 = CreateFrame("Frame","TukuiBar5",UIParent)

-- move & set it
TukuiBar1:SetAllPoints(TukuiActionBarBackground)
TukuiBar2:SetAllPoints(TukuiActionBarBackground)
TukuiBar3:SetAllPoints(TukuiActionBarBackground)
TukuiBar4:SetAllPoints(TukuiActionBarBackground)
TukuiBar5:SetAllPoints(TukuiActionBarBackground)

------------------------------------------------------------------------------------------
-- these bars will always exist, on any tukui action bar layout.
------------------------------------------------------------------------------------------

-- main action bar
for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(TukuiBar1)
end

ActionButton1:ClearAllPoints()
if TukuiCF["actionbar"].swapbar1and3 == true then
	ActionButton1:SetPoint("LEFT", ActionBar3Background,4,0)
else
	ActionButton1:SetPoint("BOTTOMLEFT", TukuiDB.Scale(4), TukuiDB.Scale(4))
end
for i=2, 12 do
	local b = _G["ActionButton"..i]
	local b2 = _G["ActionButton"..i-1]
	b:ClearAllPoints()
	b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
end
---------------------------------------------------------------------------
-- Setup Main Action Bar.
-- Now used for stances, Bonus, Vehicle at the same time.
-- Since t12, it's also working for druid cat stealth. (a lot requested)
---------------------------------------------------------------------------

local bar = CreateFrame("Frame", "TukuiMainMenuBar", TukuiActionBarBackground, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetAllPoints(TukuiActionBarBackground)

--[[ 
	Bonus bar classes id

	DRUID: Caster: 0, Cat: 1, Tree of Life: 0, Bear: 3, Moonkin: 4
	WARRIOR: Battle Stance: 1, Defensive Stance: 2, Berserker Stance: 3 
	ROGUE: Normal: 0, Stealthed: 1
	PRIEST: Normal: 0, Shadowform: 1
	
	When Possessing a Target: 5
]]--

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local class = TukuiDB.myclass
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar:RegisterEvent("BAG_UPDATE")
bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])

		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
			
		RegisterStateDriver(self, "page", GetBar())
	elseif event == "PLAYER_ENTERING_WORLD" then
		MainMenuBar_UpdateKeyRing()
		local button
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:SetSize(TukuiDB.buttonsize, TukuiDB.buttonsize)
			button:ClearAllPoints()
			button:SetParent(TukuiMainMenuBar)
			if i == 1 then
				if TukuiCF["actionbar"].swapbar1and3 == true then
					button:SetPoint("LEFT", ActionBar3Background,4,0)
				else
					button:SetPoint("BOTTOMLEFT", TukuiActionBarBackground, TukuiDB.Scale(4), TukuiDB.Scale(4))
				end
			else
				local previous = _G["ActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", TukuiDB.buttonspacing, 0)
			end
		end
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		-- attempt to fix blocked glyph change after switching spec.
		LoadAddOn("Blizzard_GlyphUI")
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

------------------------------------------------------------------------------------------
-- now let's parent, set and hide extras action bar.
------------------------------------------------------------------------------------------

MultiBarBottomLeft:SetParent(TukuiBar2)
TukuiBar2:Hide()

MultiBarBottomRight:SetParent(TukuiBar3)
TukuiBar3:Hide()

MultiBarRight:SetParent(TukuiBar4)
TukuiBar4:Hide()

MultiBarLeft:SetParent(TukuiBar5)
TukuiBar5:Hide()

------------------------------------------------------------------------------------------
-- now let's show what we need by checking our config.lua
------------------------------------------------------------------------------------------

-- look for right bars
if db.rightbars == 1 then
	TukuiActionBarBackgroundRight:SetFrameStrata("BACKGROUND")
	TukuiActionBarBackgroundRight:SetFrameLevel(1)
	TukuiBar4:Show()
	MultiBarRightButton1:ClearAllPoints()
	MultiBarRightButton1:SetPoint("TOPRIGHT", TukuiActionBarBackgroundRight, "TOPRIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end
end

if db.rightbars == 2 then
	TukuiActionBarBackgroundRight:SetFrameStrata("BACKGROUND")
	TukuiActionBarBackgroundRight:SetFrameLevel(1)
	TukuiBar4:Show()
	MultiBarRightButton1:ClearAllPoints()
	MultiBarRightButton1:SetPoint("TOPRIGHT", TukuiActionBarBackgroundRight, "TOPRIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end

	TukuiBar5:Show()
	MultiBarLeftButton1:ClearAllPoints()
	MultiBarLeftButton1:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight, "TOPLEFT", TukuiDB.Scale(4), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end  
end

if db.rightbars == 3 then
	TukuiActionBarBackgroundRight:SetFrameStrata("BACKGROUND")
	TukuiActionBarBackgroundRight:SetFrameLevel(1)
	TukuiBar4:Show()
	MultiBarRightButton1:ClearAllPoints()
	MultiBarRightButton1:SetPoint("TOPRIGHT", TukuiActionBarBackgroundRight, "TOPRIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end

	TukuiBar5:Show()
	MultiBarLeftButton1:ClearAllPoints()
	MultiBarLeftButton1:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight, "TOPLEFT", TukuiDB.Scale(4), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end
	
	TukuiBar3:Show()
	MultiBarBottomRightButton1:ClearAllPoints()
	MultiBarBottomRightButton1:SetPoint("TOP", TukuiActionBarBackgroundRight, "TOP", TukuiDB.Scale(0), TukuiDB.Scale(-4))
	for i= 2, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	end  
end

-- 48 Buttons at the Bottom
if TukuiCF["actionbar"].bottom48 == true then
	TukuiBar5:Show()
	MultiBarLeftButton1:ClearAllPoints()
	MultiBarLeftButton1:SetPoint("LEFT", ActionBar3Background, "CENTER", TukuiDB.Scale(4), TukuiDB.Scale(0))
	for i= 2, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
	end
end

-- now look for others shit, if found, set bar or override settings bar above.
if TukuiDB.lowversion == true then
	if db.bottomrows == 2 then
		TukuiBar2:Show()
		MultiBarBottomLeftButton1:ClearAllPoints()
		MultiBarBottomLeftButton1:SetPoint("BOTTOM", ActionButton1, "TOP", 0, TukuiDB.Scale(4))
		for i=2, 12 do
			local b = _G["MultiBarBottomLeftButton"..i]
			local b2 = _G["MultiBarBottomLeftButton"..i-1]
			b:ClearAllPoints()
			b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
		end   
	end
else
	TukuiBar2:Show()
	MultiBarBottomLeftButton1:ClearAllPoints()
	if TukuiCF["actionbar"].swapbar1and3 == true then
		MultiBarBottomLeftButton1:SetPoint("LEFT", MultiBarBottomRightButton12, "RIGHT", TukuiDB.Scale(4), 0)
	else
		MultiBarBottomLeftButton1:SetPoint("LEFT", ActionButton12, "RIGHT", TukuiDB.Scale(4), 0)
	end
	for i=2, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:ClearAllPoints()
		b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
	end 
	if db.bottomrows == 2 then
		TukuiBar3:Show()
		MultiBarBottomRightButton1:ClearAllPoints()
		if TukuiCF["actionbar"].swapbar1and3 == true then
			MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "BOTTOMLEFT", TukuiDB.Scale(4), TukuiDB.Scale(4))
		else
			MultiBarBottomRightButton1:SetPoint("LEFT", ActionBar3Background,4,0)
		end
		for i=2, 12 do
			local b = _G["MultiBarBottomRightButton"..i]
			local b2 = _G["MultiBarBottomRightButton"..i-1]
			b:ClearAllPoints()
			b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
		end 
	end
end

------------------------------------------------------------------------------------------
-- functions and others stuff
------------------------------------------------------------------------------------------

-- bonus bar (vehicle, rogue, etc)
local function BonusBarAlpha(alpha)
	local f = "ActionButton"
	for i=1, 12 do
		_G[f..i]:SetAlpha(alpha)
	end
end
BonusActionBarFrame:HookScript("OnShow", function(self) BonusBarAlpha(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) BonusBarAlpha(1) end)
-- if BonusActionBarFrame:IsShown() then
	-- BonusBarAlpha(0)
-- end

-- hide these blizzard frames
local FramesToHide = {
	MainMenuBar,
	VehicleMenuBar,
} 

for _, f in pairs(FramesToHide) do
	f:SetScale(0.00001)
	f:SetAlpha(0)
end

-- mouseover option
local function mouseoverbarf3(alpha)
	if MultiBarBottomRight:IsShown() then
		ActionBar3Background:SetAlpha(alpha)
		for i=1, 12 do
			local pb = _G["MultiBarBottomRightButton"..i]
			pb:SetAlpha(alpha)
		end
	end	
end

local function mouseoverpet(alpha)
	if (TukuiCF["actionbar"].petbaralwaysvisible == true) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then		
		TukuiLineToPetActionBarBackground:SetAlpha(alpha)
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
			pb:SetAlpha(1)
		end
	elseif (TukuiCF["actionbar"].petbaralwaysvisible == false) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
		TukuiPetActionBarBackground:SetAlpha(alpha)
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
			pb:SetAlpha(alpha)
		end
	end
end

local function rightbaralpha(alpha)
	TukuiActionBarBackgroundRight:SetAlpha(alpha)
	if db.rightbars > 1 then
		if MultiBarLeft:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarLeftButton"..i]
				pb:SetAlpha(alpha)
			end
			MultiBarLeft:SetAlpha(alpha)
		end
	end
	if db.rightbars > 2 then
		if MultiBarBottomRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarBottomRightButton"..i]
				pb:SetAlpha(alpha)
			end
			MultiBarBottomRight:SetAlpha(alpha)
		end
	end
	if db.rightbars > 0 then
		if MultiBarRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarRightButton"..i]
				pb:SetAlpha(alpha)
			end
			MultiBarRight:SetAlpha(alpha)
		end
	end
end

if db.rightbarmouseover == true and db.rightbars > 0 then
	TukuiActionBarBackgroundRight:EnableMouse(true)
	if not TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
		TukuiPetActionBarBackground:EnableMouse(true)
		TukuiPetActionBarBackground:SetScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
		TukuiPetActionBarBackground:SetScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
	end
	TukuiActionBarBackgroundRight:SetAlpha(0)
	if (TukuiCF["actionbar"].petbaralwaysvisible == true) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
		TukuiPetActionBarBackground:SetAlpha(1)
	elseif (TukuiCF["actionbar"].petbaralwaysvisible == false) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
		TukuiPetActionBarBackground:SetAlpha(0)
	end
	
	TukuiActionBarBackgroundRight:SetScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
	TukuiActionBarBackgroundRight:SetScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
	
	if TukuiLineToPetActionBarBackground then
		TukuiLineToPetActionBarBackground:EnableMouse(true)
		TukuiLineToPetActionBarBackground:SetScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
		TukuiLineToPetActionBarBackground:SetScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
	end
	
	righthelp:EnableMouse(true)
	righthelp:SetScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
	righthelp:SetScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
	
	for i=1, 12 do
		local pb = _G["MultiBarRightButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
		pb:HookScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
			if db.rightbars > 2 then
				local pb = _G["MultiBarBottomRightButton"..i]
				pb:SetAlpha(0)
				pb:HookScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
				pb:HookScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
			end
			if db.rightbars > 1 then
				local pb = _G["MultiBarLeftButton"..i]
				pb:SetAlpha(0)
				pb:HookScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
				pb:HookScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
			end
	end
	if not TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
			if TukuiCF["actionbar"].petbaralwaysvisible == true then
				pb:SetAlpha(1)
			else
				pb:SetAlpha(0)
			end
			pb:HookScript("OnEnter", function(self) mouseoverpet(1) rightbaralpha(1) end)
			pb:HookScript("OnLeave", function(self) mouseoverpet(0) rightbaralpha(0) end)
		end
	end
end

if (TukuiCF["actionbar"]["petbarhorizontal"].mouseover == true) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == true)  then
	local function mouseoverpethorizontal(alpha)	
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
			pb:SetAlpha(alpha)
		end
	end
	
	TukuiPetActionBarBackground1:EnableMouse(true)
	TukuiPetActionBarBackground1:SetScript("OnEnter", function(self) mouseoverpethorizontal(1) end)
	TukuiPetActionBarBackground1:SetScript("OnLeave", function(self) mouseoverpethorizontal(0) end)
	
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
				pb:SetAlpha(0)
				pb:HookScript("OnEnter", function(self) mouseoverpethorizontal(1) end)
				pb:HookScript("OnLeave", function(self) mouseoverpethorizontal(0) end)
		end		
end

-----------------------------------------------
if db.bar3mouseover == true then
	ActionBar3Background:EnableMouse(true)
	ActionBar3Background:SetAlpha(0)
	ActionBar3Background:SetScript("OnEnter", function(self) mouseoverbarf3(1) end)
	ActionBar3Background:SetScript("OnLeave", function(self) mouseoverbarf3(0) end)
	for i=1, 12 do
		local pb = _G["MultiBarBottomRightButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) mouseoverbarf3(1) end)
		pb:HookScript("OnLeave", function(self) mouseoverbarf3(0) end)
	end
end