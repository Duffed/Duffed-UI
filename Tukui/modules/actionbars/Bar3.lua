local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarLeft as bar #3 
---------------------------------------------------------------------------

local bar = TukuiBar2
if C["actionbar"].swapbar1and3 then bar = TukuiBar1 end
MultiBarBottomRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("BOTTOMLEFT", bar, T.buttonspacing, T.buttonspacing)
	else
		b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
	end
end