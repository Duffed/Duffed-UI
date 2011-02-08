local menus = {
	InterfaceOptionsFrame,
	ChatConfigFrame,
	AudioOptionsFrame,
	GameMenuFrame,
	VideoOptionsFrame,
}

local reset = CreateFrame("FRAME")
reset:RegisterEvent("PLAYER_ENTERING_WORLD")
reset:SetScript("OnEvent", function()
	for i, frame in pairs(menus) do
		frame:SetPoint("CENTER", UIParent, 0, 0)
	end
end)

for i, frame in pairs(menus) do
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	
	if i == 1 then
		frame:SetResizable(true)
		frame:SetMinResize(585, 520)
		frame:SetWidth(900)
		
		local frameresize = CreateFrame("Frame", nil, frame)
		frameresize:SetSize(20,20)
		frameresize:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
		
		local framet = frameresize:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		framet:SetText("+")
		framet:SetAllPoints(frameresize)
		
		frameresize:SetScript("OnMouseDown", function() frame:StartSizing() end)
		frameresize:SetScript("OnMouseUp", function() frame:StopMovingOrSizing() end)
	end
end