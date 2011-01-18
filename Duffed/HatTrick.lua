---------------------
-- HatTrick
-- Author: Tekkub
---------------------
local GameTooltip = GameTooltip

local loc = {
	helmtip = "Toggles helmet model.",
	cloaktip = "Toggles cloak model.",
}


local hcheck = CreateFrame("CheckButton", "HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
hcheck:ClearAllPoints()
hcheck:SetWidth(22)
hcheck:SetHeight(22)
hcheck:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 5)
hcheck:SetScript("OnClick", function () ShowHelm(not ShowingHelm()) end)
hcheck:SetScript("OnEnter", function ()
 	GameTooltip:SetOwner(hcheck, "ANCHOR_RIGHT")
	GameTooltip:SetText(loc.helmtip)
end)
hcheck:SetScript("OnLeave", function () GameTooltip:Hide() end)
hcheck:SetToplevel(true)


local ccheck = CreateFrame("CheckButton", "CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
ccheck:ClearAllPoints()
ccheck:SetWidth(22)
ccheck:SetHeight(22)
ccheck:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 5)
ccheck:SetScript("OnClick", function () ShowCloak(not ShowingCloak()) end)
ccheck:SetScript("OnEnter", function ()
	GameTooltip:SetOwner(ccheck, "ANCHOR_RIGHT")
	GameTooltip:SetText(loc.cloaktip)
end)
ccheck:SetScript("OnLeave", function () GameTooltip:Hide() end)
ccheck:SetToplevel(true)


hcheck:SetChecked(ShowingHelm())
ccheck:SetChecked(ShowingCloak())


hooksecurefunc("ShowHelm", function(v)
	hcheck:SetChecked(v)
end)

hooksecurefunc("ShowCloak", function(v)
	ccheck:SetChecked(v)
end)