--[[
	BetterBlizzOptions
	Author: Antiarc
	All rights reserved.
]]

local Centerja = CreateFrame("FRAME")
Centerja:RegisterEvent("PLAYER_ENTERING_WORLD");
Centerja:SetScript("OnEvent", function()
	InterfaceOptionsFrame:SetPoint("CENTER", UIParent,0,0)
	ChatConfigFrame:SetPoint("CENTER", UIParent,0,0)
	AudioOptionsFrame:SetPoint("CENTER", UIParent,0,0)
	GameMenuFrame:SetPoint("CENTER", UIParent,0,0)
	VideoOptionsFrame:SetPoint("CENTER", UIParent,0,0)
end)

local function makeMovable(frame)
	local mover = CreateFrame("Frame", frame:GetName() .. "Mover", frame)
	mover:EnableMouse(true)
	mover:SetPoint("TOP", frame, "TOP", 0, 10)
	mover:SetWidth(160)
	mover:SetHeight(40)
	mover:SetScript("OnMouseDown", function(self)
		self:GetParent():StartMoving()
	end)
	mover:SetScript("OnMouseUp", function(self)
		self:GetParent():StopMovingOrSizing()
	end)
	frame:SetMovable(true)
end

local grip = CreateFrame("Button", "BetterBlizzOptionsResizeGrip", InterfaceOptionsFrame)
grip:SetNormalTexture("Interface\\AddOns\\Duffed\\media\\ResizeGrip")
grip:SetHighlightTexture("Interface\\AddOns\\Duffed\\media\\ResizeGrip")
grip:SetWidth(16)
grip:SetHeight(16)
grip:SetScript("OnMouseDown", function(self)
	self:GetParent():StartSizing()
end)
grip:SetScript("OnMouseUp", function(self)
	self:GetParent():StopMovingOrSizing()
end)

grip:RegisterEvent("PLAYER_LOGIN")
grip:SetPoint("BOTTOMRIGHT", InterfaceOptionsFrame, "BOTTOMRIGHT", -5, 5)

InterfaceOptionsFrameCategories:SetPoint("BOTTOMLEFT", InterfaceOptionsFrame, "BOTTOMLEFT", 22, 50)
InterfaceOptionsFrameAddOns:SetPoint("BOTTOMLEFT", InterfaceOptionsFrame, "BOTTOMLEFT", 22, 50)

InterfaceOptionsFrame:SetResizable(true)
InterfaceOptionsFrame:SetWidth(900)
InterfaceOptionsFrame:SetMinResize(585, 495)

makeMovable(InterfaceOptionsFrame)
makeMovable(ChatConfigFrame)
makeMovable(AudioOptionsFrame)
makeMovable(GameMenuFrame)
makeMovable(VideoOptionsFrame)
if MacOptionsFrame then
   makeMovable(MacOptionsFrame)
end