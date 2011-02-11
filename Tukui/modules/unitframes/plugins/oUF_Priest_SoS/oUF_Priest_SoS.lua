local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if select(2, UnitClass('player')) ~= "PRIEST" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Strength of Soul Priest Plugin was unable to locate oUF install')

local spells = { 96219, 96266 }
local function Update(self, event, unit)
	if self.unit ~= unit then return end
	
	local sos = self.Priest_SoS
	
	sos.hasBuff = false
	for i, spell in pairs(spells) do
		if UnitAura("player", GetSpellInfo(spell)) then
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura("player", GetSpellInfo(spell))
			sos.icon:SetTexture(select(3, GetSpellInfo(spell)))
			sos:Show()
			sos.hasBuff = true
			sos.timeleft = expirationTime-GetTime()
		else
			if not sos.hasBuff then
				sos:Hide()
			end
		end
	end
end

local function Enable(self)
	if self.Priest_SoS then
		self.Priest_SoS:Hide()
		self.Priest_SoS.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		
		self:RegisterEvent("UNIT_AURA", Update)
	end
end

local function Disable(self)
	if self.Priest_SoS then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement('Priest_SoS', Update, Enable, Disable)