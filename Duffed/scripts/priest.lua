if dStuff.priest_SoS ~= true or select(2, UnitClass("player")) ~= "PRIEST" then return end

local p = CreateFrame("Frame", "dPriest_Frame", UIParent)
p:SetSize(40,40)
p:SetPoint("CENTER", 0, 150)
p:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tileSize = 0, edgeSize = 1, 
	insets = { left = -1, right = -1, top = -1, bottom = -1}
})
p:SetBackdropColor(.05, .05, .05)
p:SetBackdropBorderColor(.25, .25, .25)
p:SetMovable(true)
p:Hide()

p.icon = p:CreateTexture(nil, "ARTWORK")
p.icon:SetPoint("TOPLEFT", 2, -2)
p.icon:SetPoint("BOTTOMRIGHT", -2, 2)
p.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

p.text = p:CreateFontString(nil, "OVERLAY")
p.text:SetFont(dStuff.font, 14, "THINOUTLINE")
p.text:SetPoint("CENTER", 0, 0)

local spells = { 89489, 96219 }
p:SetScript("OnEvent", function(self)
	p.hasBuff = false
	for i, spell in pairs(spells) do
		if UnitAura("player", GetSpellInfo(spell)) then
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura("player", GetSpellInfo(spell))
			p.icon:SetTexture(select(3, GetSpellInfo(spell)))
			p:Show()
			p.hasBuff = true
			p.timeleft = expirationTime-GetTime()
		else
			if not p.hasBuff then
				p:Hide()
			end
		end
	end
end)
p:RegisterEvent("UNIT_AURA")

p:SetScript("OnUpdate", function(self, elapsed)
	if p.hasBuff then
		p.timeleft = p.timeleft - elapsed
		p.text:SetFormattedText("%.1f", p.timeleft)
	end
end)
