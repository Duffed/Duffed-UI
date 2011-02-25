local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local bar = TukuiBar1
MultiBarBottomLeft:SetParent(bar)

for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(15)
	
	if i == 1 then
		if T.lowversion then
			b:SetPoint("TOPLEFT", bar, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
		else
			b:SetPoint("BOTTOMLEFT", bar, "BOTTOM", T.buttonspacing/2, T.buttonspacing)
		end
	else
		b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
	end
end