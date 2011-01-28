local bnet = CreateFrame("Frame", "TukuiBnetHolder", UIParent)
TukuiDB.CreatePanel(bnet, BNToastFrame:GetWidth(), BNToastFrame:GetHeight(), "BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, TukuiDB.Scale(10))
if ChatBG1 then	bnet:SetPoint("BOTTOMLEFT", ChatBG1, "TOPLEFT", 0, TukuiDB.Scale(1)) end
bnet:SetClampedToScreen(true)
bnet:SetMovable(true)
bnet:SetBackdropBorderColor(1,0,0)
bnet.text = TukuiDB.SetFontString(bnet, TukuiCF.media.uffont, 12)
bnet.text:SetPoint("CENTER")
bnet.text:SetText("Move BnetFrame")
bnet:SetAlpha(0)

-- reposition battle.net popup 
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", bnet, "BOTTOMLEFT")
end)

------------------------------------------------------------------------
-- make BNET Notification movable on screen
------------------------------------------------------------------------

local move = false
function TukuiMoveBnetFrame(msg)
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end

	bnet:SetUserPlaced(true)
	if msg == "reset" then
		bnet:ClearAllPoints()
		if ChatBG1 then
			bnet:SetPoint("BOTTOMLEFT", ChatBG1, "TOPLEFT", 0, TukuiDB.Scale(1))
		else
			bnet:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, TukuiDB.Scale(10))
		end
	else		
		if move == false then
			move = true
			bnet:SetAlpha(1)
			bnet:EnableMouse(true)
			bnet:RegisterForDrag("LeftButton", "RightButton")
			bnet:SetScript("OnDragStart", function(self) self:StartMoving() end)
			bnet:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		elseif move == true then
			move = false
			bnet:SetAlpha(0)
			bnet:EnableMouse(false)
		end
	end
end
SLASH_MOVEBNET1 = "/mbnet"
SlashCmdList["MOVEBNET"] = TukuiMoveBnetFrame