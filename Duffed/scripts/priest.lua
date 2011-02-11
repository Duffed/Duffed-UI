if dStuff.priest_SoS ~= true then return end

local p = CreateFrame("Frame", nil, UIParent)
p:SetSize(40,40)
p:SetPoint("CENTER", 0, 150)

p.icon = p:CreateTexture(nil, "OVERLAY")
p.icon:SetPoint("CENTER", 0, 0)
p.icon:SetSize(40,40)
p.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

local spells = { 89489, 96219 }
p:SetScript("OnEvent", function()
	local hasBuff = false
	for i, spell in pairs(spells) do
		if UnitAura("player", GetSpellInfo(spell)) then
			p.icon:SetTexture(select(3, GetSpellInfo(spell)))
			p:Show()
			hasBuff = true
		else
			if not hasBuff then
				p:Hide()
			end
		end
	end
end)
p:RegisterEvent("UNIT_AURA")