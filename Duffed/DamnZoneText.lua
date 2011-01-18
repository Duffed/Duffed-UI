--[[
	
	Damn Zone Text
	Copyright (c) 2009, level12wizard
	All rights reserved.
	
]]
ZoneTextFrame:UnregisterAllEvents()
ZoneTextFrame:SetScript("OnShow", function() this:Hide() end)
ZoneTextFrame:Hide()
SubZoneTextFrame:UnregisterAllEvents()
SubZoneTextFrame:SetScript("OnShow", function() this:Hide() end)
SubZoneTextFrame:Hide()