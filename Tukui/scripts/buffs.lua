-- Consolidate buffs moved to map
ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("LEFT", Minimap, "LEFT", TukuiDB.Scale(0), TukuiDB.Scale(0))
ConsolidatedBuffs:SetSize(16, 16)
ConsolidatedBuffsIcon:SetTexture(nil)
ConsolidatedBuffs.SetPoint = TukuiDB.dummy

if TukuiCF.unitframes.playerauras == true then return end

local header = CreateFrame("Frame", "TukuiAurasHeader", UIParent)
header:SetFrameLevel(0)
header:SetFrameStrata("BACKGROUND")
header:SetSize(540, 170)
header:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-157), TukuiDB.Scale(-9))
header:SetClampedToScreen(true)
header:SetMovable(true)
TukuiDB.SetTemplate(header)
header:SetBackdropBorderColor(0,0,0,0)
header:SetBackdropColor(0,0,0,0)
header.text = TukuiDB.SetFontString(header, TukuiCF.media.uffont, 12)
header.text:SetPoint("CENTER")
header.text:SetText("Move Player Auras")
header.text:SetAlpha(0)

local rowbuffs = 16
local revert = false

local function GetOrientation()
	local position = header:GetPoint()
	if position:match("LEFT") then
		revert = true
		TempEnchant1:ClearAllPoints()
		TempEnchant2:ClearAllPoints()
		TempEnchant3:ClearAllPoints()
		TempEnchant1:SetPoint("TOPLEFT", header, 0, 0)
		TempEnchant2:SetPoint("LEFT", TempEnchant1, "RIGHT", TukuiDB.Scale(4), 0)
		TempEnchant3:SetPoint("LEFT", TempEnchant2, "RIGHT", TukuiDB.Scale(4), 0)
		BuffFrame_Update()
	else
		revert = false
		TempEnchant1:ClearAllPoints()
		TempEnchant2:ClearAllPoints()
		TempEnchant3:ClearAllPoints()
		TempEnchant1:SetPoint("TOPRIGHT", header, 0, 0)
		TempEnchant2:SetPoint("RIGHT", TempEnchant1, "LEFT", TukuiDB.Scale(-4), 0)
		TempEnchant3:SetPoint("RIGHT", TempEnchant2, "LEFT", TukuiDB.Scale(-4), 0)
		BuffFrame_Update()
	end
end

header:RegisterEvent("PLAYER_LOGIN")
header:SetScript("OnEvent", function(self)
	GetOrientation()
end)

-- I want buff show over this frame if too many are show
WorldStateAlwaysUpFrame:SetFrameStrata("BACKGROUND")
WorldStateAlwaysUpFrame:SetFrameLevel(0)

-- skin our weapons buffs
for i = 1, 3 do
	local f = CreateFrame("Frame", nil, _G["TempEnchant"..i])
	TukuiDB.CreatePanel(f, 30, 30, "CENTER", _G["TempEnchant"..i], "CENTER", 0, 0)	
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G["TempEnchant"..i.."Icon"]:SetPoint("TOPLEFT", _G["TempEnchant"..i], TukuiDB.Scale(2), TukuiDB.Scale(-2))
	_G["TempEnchant"..i.."Icon"]:SetPoint("BOTTOMRIGHT", _G["TempEnchant"..i], TukuiDB.Scale(-2), TukuiDB.Scale(2))
	_G["TempEnchant"..i]:SetHeight(TukuiDB.Scale(30))
	_G["TempEnchant"..i]:SetWidth(TukuiDB.Scale(30))	
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:SetPoint("BOTTOM", 0, TukuiDB.Scale(-13))
	_G["TempEnchant"..i.."Duration"]:SetFont(TukuiCF["media"].font, 12)
	TukuiDB.CreateShadow(_G["TempEnchant"..i])
end

-- style our "normal" buffs/debuffs
local function StyleBuffs(buttonName, index, debuff)
	local buff		= _G[buttonName..index]
	local icon		= _G[buttonName..index.."Icon"]
	local border	= _G[buttonName..index.."Border"]
	local duration	= _G[buttonName..index.."Duration"]
	local count 	= _G[buttonName..index.."Count"]
	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("TOPLEFT", buff, TukuiDB.Scale(2), TukuiDB.Scale(-2))
		icon:SetPoint("BOTTOMRIGHT", buff, TukuiDB.Scale(-2), TukuiDB.Scale(2))
		
		buff:SetHeight(TukuiDB.Scale(30))
		buff:SetWidth(TukuiDB.Scale(30))
		TukuiDB.CreateShadow(buff)
				
		duration:ClearAllPoints()
		duration:SetPoint("BOTTOM", 0, TukuiDB.Scale(-13))
		duration:SetFont(TukuiCF["media"].font, 12)
		
		count:ClearAllPoints()
		count:SetPoint("TOPLEFT", TukuiDB.Scale(1), TukuiDB.Scale(-2))
		count:SetFont(TukuiCF["media"].font, 12, "OUTLINE")
		
		local panel = CreateFrame("Frame", buttonName..index.."Panel", buff)
		TukuiDB.CreatePanel(panel, 30, 30, "CENTER", buff, "CENTER", 0, 0)
		panel:SetFrameLevel(buff:GetFrameLevel() - 1)
		panel:SetFrameStrata(buff:GetFrameStrata())
	end
	if border then border:Hide() end
end

-- find how much weapon buffs we have
local function GetNumberWeaponBuff()
	local mainhand, _, _, offhand, _, _, hand3 = GetWeaponEnchantInfo()
	local number
	
	if (mainhand and offhand and hand3) and not UnitHasVehicleUI("player") then 
		number = 3
	elseif ((mainhand and offhand) or (mainhand and hand3) or (offhand and hand3)) and not UnitHasVehicleUI("player") then 
		number = 2
	elseif ((mainhand and not offhand and not hand3) or (offhand and not mainhand and not hand3) or (hand3 and not mainhand and not offhand)) and not UnitHasVehicleUI("player") then 
		number = 1
	else
		number = 0
	end

	return number
end

-- align
local function UpdateBuffAnchors()
	local buttonName = "BuffButton"
	local buff, previousBuff, aboveBuff
	local numBuffs = 0;
	for i=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G[buttonName..i]
		StyleBuffs(buttonName, i, false)
				
		if ( buff.consolidated ) then
			if ( buff.parent == BuffFrame ) then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numBuffs = numBuffs + 1
			buff:ClearAllPoints()
			if ( (numBuffs > 1) and (mod(numBuffs, rowbuffs) == 1) ) then
				if revert then
					if ( numBuffs == rowbuffs+1 ) then
						buff:SetPoint("TOPLEFT", header, 0, TukuiDB.Scale(-69))
					else
						buff:SetPoint("TOPLEFT", header)
					end
				else
					if ( numBuffs == rowbuffs+1 ) then
						buff:SetPoint("TOPRIGHT", header, 0, TukuiDB.Scale(-69))
					else
						buff:SetPoint("TOPRIGHT", header)
					end				
				end
				aboveBuff = buff
			elseif ( numBuffs == 1 ) then
				local weaponbuffs = GetNumberWeaponBuff()
		
				if revert then
					if weaponbuffs == 3 then
						buff:SetPoint("LEFT", TempEnchant3, "RIGHT", TukuiDB.Scale(4), 0)
					elseif weaponbuffs == 2 then
						buff:SetPoint("LEFT", TempEnchant2, "RIGHT", TukuiDB.Scale(4), 0)
					elseif weaponbuffs == 1 then
						buff:SetPoint("LEFT", TempEnchant1, "RIGHT", TukuiDB.Scale(4), 0)
					else
						buff:SetPoint("TOPLEFT", header)
					end				
				else
					if weaponbuffs == 3 then
						buff:SetPoint("RIGHT", TempEnchant3, "LEFT", TukuiDB.Scale(-4), 0)
					elseif weaponbuffs == 2 then
						buff:SetPoint("RIGHT", TempEnchant2, "LEFT", TukuiDB.Scale(-4), 0)
					elseif weaponbuffs == 1 then
						buff:SetPoint("RIGHT", TempEnchant1, "LEFT", TukuiDB.Scale(-4), 0)
					else
						buff:SetPoint("TOPRIGHT", header)
					end
				end
			else
				if revert then
					buff:SetPoint("LEFT", previousBuff, "RIGHT", TukuiDB.Scale(4), 0)
				else
					buff:SetPoint("RIGHT", previousBuff, "LEFT", TukuiDB.Scale(-4), 0)
				end
			end
			previousBuff = buff
		end		
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)

local function UpdateDebuffAnchors(buttonName, index)
	local debuff = _G[buttonName..index]
	
	-- style it!
	StyleBuffs(buttonName, index, true)
	
	-- color it by debuffType!
	local dtype = select(5, UnitDebuff("player",index))      
	local color
	if (dtype ~= nil) then
		color = DebuffTypeColor[dtype]
	else
		color = DebuffTypeColor["none"]
	end
	_G[buttonName..index.."Panel"]:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
	
	-- now move it!
	debuff:ClearAllPoints()
	if revert then
		if index == 1 then
			debuff:SetPoint("TOPLEFT", header, 0, TukuiDB.Scale(-136))
		else
			debuff:SetPoint("LEFT", _G[buttonName..(index-1)], "RIGHT", TukuiDB.Scale(4), 0)
		end	
	else
		if index == 1 then
			debuff:SetPoint("TOPRIGHT", header, 0, TukuiDB.Scale(-136))
		else
			debuff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", TukuiDB.Scale(-4), 0)
		end
	end
	
end
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)

-- format
SecondsToTimeAbbrev = function(time)
	local hr, m, s, text
	if time <= 0 then text = ""
	elseif(time < 3600 and time > 60) then
		hr = floor(time / 3600)
		m = floor(mod(time, 3600) / 60 + 1)
		text = format("%d"..""..panelcolor.."m", m)
	elseif(time < 60 and time > 10) then
		m = floor(time / 60)
		s = mod(time, 60)
		text = (m == 0 and format("%d", s))
	elseif time < 10 then
		s = mod(time, 60)
		text = (format("|cffce3a19%d", s))
	else
		hr = floor(time / 3600 + 1)
		text = format("%dh", hr)
	end
	text = format("|cffffffff".."%s", text)
	return text
end

------------------------------------------------------------------------
-- make auras movable on screen
------------------------------------------------------------------------

local move = false
function TukuiMovePlayerAuras(msg)
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local anchor = header
	local text = header.text
	anchor:SetUserPlaced(true)
	
	if msg == "reset" then
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPRIGHT", UIParent, TukuiDB.Scale(-157), TukuiDB.Scale(-9))
		GetOrientation()
	else		
		if move == false then
			move = true
			anchor:SetBackdropBorderColor(1,0,0,1)
			anchor:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
			text:SetAlpha(1)
			anchor:EnableMouse(true)
			anchor:RegisterForDrag("LeftButton", "RightButton")
			anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
			anchor:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		elseif move == true then
			move = false
			anchor:SetBackdropBorderColor(0,0,0,0)
			anchor:SetBackdropColor(0,0,0,0)
			text:SetAlpha(0)
			anchor:EnableMouse(false)
			GetOrientation()
			BuffFrame_Update()
		end
	end
end
SLASH_MOVEPLAYERAURA1 = "/maura"
SlashCmdList["MOVEPLAYERAURA"] = TukuiMovePlayerAuras
