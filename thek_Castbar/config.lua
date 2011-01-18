--[[
--  thekCastbar
--  version: 3.0.cataclysm
--  author:  thek
--
--  configuration
--  notes:
--   textFont        = {FONTNAME/FILE, FONTSIZE, FONTOPTIONS}
--   castbarSize     = {WIDTH, HEIGHT, BORDERSIZE, ICONSPACING}
--   castbarTextures = {BARTEXTURE, BACKGROUND},
--]]
if TukuiCF["unitframes"].enable == true then return end
local c = {};
c["CastingBarFrame"] = {
    enabled             = true,
    textPosition        = {"CENTER", 0, 0},
    textFont            = {TukuiCF["media"].font, 12, ""},
    castbarSize         = {345, 20, 1, 7},
    castbarColor        = {unpack(TukuiCF["castbar"]["color"].player)},
    castbarBGColor      = {.1, .1, .1, 0},
    castbarTextures     = {"Interface\\AddOns\\Tukui\\media\\textures\\normTex.tga"},
    enableLag           = false,
    enableTimer         = true,
	CastbarScale		= 1,
}
c["TargetFrameSpellBar"] = {
    enabled             = false,
    textPosition        = {"CENTER", 0, 0},
    textFont            = {TukuiCF["media"].font, 12, ""},
    castbarSize         = {300, 24, 1, 8},
    castbarColor        = {unpack(TukuiCF["castbar"]["color"].target)},
    castbarBGColor      = {.1, .1, .1, 0},
    castbarTextures     = {"Interface\\AddOns\\Tukui\\media\\textures\\normTex.tga"},
    enableLag           = false,
    enableTimer         = true,
	CastbarScale		= 0.85,
}
c["FocusFrameSpellBar"] = {
    enabled             = false,
    textPosition        = {"CENTER", 0, 0},
    textFont            = {TukuiCF["media"].font, 12, ""},
    castbarSize         = {360, 25, 1, 8},
    castbarColor        = {unpack(TukuiCF["castbar"]["color"].focus)},
    castbarBGColor      = {.1, .1, .1, 0},
    castbarTextures     = {"Interface\\AddOns\\Tukui\\media\\textures\\normTex.tga"},
    enableLag           = false,
    enableTimer         = true,
	CastbarScale		= 0.85,
}
c["MirrorTimer1"] = {
    enabled             = false,
    textPosition        = {"CENTER", 0, 0},
    textFont            = {TukuiCF["media"].font, 12, ""},
    castbarSize         = {240, 20, 1, 7},
    castbarColor        = {0, .9, 0},
    castbarBGColor      = {.1, .1, .1, 0},
    castbarTextures     = {"Interface\\AddOns\\Tukui\\media\\textures\\normTex.tga"},
    enableTimer         = true
}
c["PetCastingBarFrame"] = {
    enabled             = false,
    textPosition        = {"CENTER", 0, 0},
    textFont            = {TukuiCF["media"].font, 12, ""},
    castbarSize         = {345, 20, 1, 7},
    castbarColor        = {unpack(TukuiCF["castbar"]["color"].notplayer)},
    castbarBGColor      = {.1, .1, .1, 0},
    castbarTextures     = {"Interface\\AddOns\\Tukui\\media\\textures\\normTex.tga"},
    enableTimer         = true,
	CastbarScale		= 0.85,
}
thekCastbar_LuaConfig = c;

if TukuiCF["castbar"].classcolor == true then
	local class = select(2, UnitClass("Player"))
		if class == "DEATHKNIGHT" then
			c["CastingBarFrame"].castbarColor = {196/255,  30/255,  60/255 }
		elseif class == "DRUID" then
			c["CastingBarFrame"].castbarColor = {255/255, 125/255,  10/255 }
		elseif class == "HUNTER" then
			c["CastingBarFrame"].castbarColor = {171/255, 214/255, 116/255 }
		elseif class == "MAGE" then
			c["CastingBarFrame"].castbarColor = {104/255, 205/255, 255/255 }
		elseif class == "PALADIN" then
			c["CastingBarFrame"].castbarColor = {245/255, 140/255, 186/255 }
		elseif class == "PRIEST" then
			c["CastingBarFrame"].castbarColor = {212/255, 212/255, 212/255 }
		elseif class == "ROGUE" then
			c["CastingBarFrame"].castbarColor = {255/255, 243/255,  82/255 }
		elseif class == "SHAMAN" then
			c["CastingBarFrame"].castbarColor = {41/255, 79/255, 155/255 }
		elseif class == "WARLOCK" then
			c["CastingBarFrame"].castbarColor = {148/255, 130/255, 201/255 }
		elseif class == "WARRIOR" then
			c["CastingBarFrame"].castbarColor = {194/255, 151/255, 105/255 }
		end
	else
		c["CastingBarFrame"].castbarColor = {unpack(TukuiCF["castbar"]["color"].player)}
end
		c["TargetFrameSpellBar"].castbarColor = {unpack(TukuiCF["castbar"]["color"].target)}
		c["FocusFrameSpellBar"].castbarColor = {unpack(TukuiCF["castbar"]["color"].focus)}
	
-- 	Position of Player Castbar
if (TukuiCF["actionbar"].bottomrows == 2) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
	CastingBarFrame:SetPoint("BOTTOM", ActionBar3Background,"TOP", 0, 10)
elseif (TukuiCF["actionbar"].bottomrows == 1) and (TukuiCF["actionbar"]["petbarhorizontal"].enable == false) then
	CastingBarFrame:SetPoint("BOTTOM", TukuiActionBarBackground,"TOP", 0, 10)
elseif TukuiCF["actionbar"]["petbarhorizontal"].enable == true then
	c["CastingBarFrame"].castbarSize[1] = 283
	CastingBarFrame:SetPoint("BOTTOM", TukuiPetActionBarBackground1,"TOP", 0, 10)
end


-------------------------------
-- Border
-------------------------------

-- Player Castbar Border
if (c.CastingBarFrame.enabled) then
	local f = CreateFrame("Frame",nil,CastingBarFrame)
	TukuiDB.CreatePanel(f, 1,1, "TOPLEFT",f:GetParent(),"TOPLEFT",-2,2)
	f:SetPoint("BOTTOMRIGHT",f:GetParent(),"BOTTOMRIGHT",2,-2)
	TukuiDB.CreateShadow(f)

	local v = CreateFrame("Frame",nil,CastingBarFrame)
	TukuiDB.CreatePanel(v,(c.CastingBarFrame.castbarSize[2])+4, (c.CastingBarFrame.castbarSize[2])+4, "RIGHT",CastingBarFrame,"LEFT",(-(c.CastingBarFrame.castbarSize[4])+2),0)
	TukuiDB.CreateShadow(v)
end
	
-- Target Castbar Border
if (c.TargetFrameSpellBar.enabled) then
	local e = CreateFrame("Frame",nil,TargetFrameSpellBar)
	TukuiDB.CreatePanel(e,1,1,"TOPLEFT",e:GetParent(),"TOPLEFT",-2,2)
	e:SetPoint("BOTTOMRIGHT",e:GetParent(),"BOTTOMRIGHT",2,-2)
	TukuiDB.CreateShadow(e)
	
	local v = CreateFrame("Frame",nil,TargetFrameSpellBar)
	TukuiDB.CreatePanel(v, (c.TargetFrameSpellBar.castbarSize[2])+4, (c.TargetFrameSpellBar.castbarSize[2])+4, "RIGHT",TargetFrameSpellBar,"LEFT",-6,0)
	TukuiDB.CreateShadow(v)
end

-- Focus Castbar Border
if (c.FocusFrameSpellBar.enabled) then
	local d = CreateFrame("Frame",nil,FocusFrameSpellBar)
	TukuiDB.CreatePanel(d,1,1,"TOPLEFT",d:GetParent(),"TOPLEFT",-2,2)
	d:SetPoint("BOTTOMRIGHT",d:GetParent(),"BOTTOMRIGHT",2,-2)
	TukuiDB.CreateShadow(d)
	
	local v = CreateFrame("Frame",nil,FocusFrameSpellBar)
	TukuiDB.CreatePanel(v,(c.FocusFrameSpellBar.castbarSize[2])+4, (c.FocusFrameSpellBar.castbarSize[2])+4, "RIGHT",FocusFrameSpellBar,"LEFT",-6,0)
	TukuiDB.CreateShadow(v)
end

-- Mirror Bar Border 
if (c.MirrorTimer1.enabled) then
	local c = CreateFrame("Frame",nil,MirrorTimer1)
	TukuiDB.CreatePanel(c,1,1,"TOPLEFT",c:GetParent(),"TOPLEFT",-2,2)
	c:SetPoint("BOTTOMRIGHT",c:GetParent(),"BOTTOMRIGHT",36,4)
	TukuiDB.CreateShadow(c)
end