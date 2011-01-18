--[[
--  thekCastbar
--  version: 3.0.cataclysm
--  author:  thek
--]]
if TukuiCF["unitframes"].enable == true then return end

local c = thekCastbar_LuaConfig;
local d = {};
local find = string.find;
local floor = math.floor;

-- doing some border math (taken from tukui)
local m = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")));
local scale = function(v) return m * floor(v/m+.5) end;

local function Set(a, k)
    a:SetFrameLevel(_G[k]:GetFrameLevel() - 1);
    if find(k, "MirrorTimer") then
        _G[k.."StatusBar"]:SetStatusBarColor(unpack(c[k].castbarColor));
        _G[k.."StatusBar"]:SetWidth(c[k].castbarSize[1]);
        _G[k.."StatusBar"]:SetHeight(c[k].castbarSize[2]);
        _G[k]:ClearAllPoints();
        _G[k]:SetPoint("TOPLEFT", a, "TOPLEFT", scale(_G[k].d.x), -scale(_G[k].d.y));
        _G[k.."StatusBar"]:ClearAllPoints();
        _G[k.."StatusBar"]:SetPoint("TOPLEFT", a, "TOPLEFT", scale(c[k].castbarSize[3]), -scale(_G[k].d.y));
    else
        _G[k]:SetStatusBarColor(unpack(c[k].castbarColor));
        _G[k]:SetWidth(c[k].castbarSize[1]);
        _G[k]:SetHeight(c[k].castbarSize[2]);
        _G[k]:ClearAllPoints();
        _G[k]:SetPoint("TOPLEFT", a, "TOPLEFT", scale(_G[k].d.x), -scale(_G[k].d.y));
		_G[k]:SetScale(c[k].CastbarScale);
    end;
    if c[k].enableLag then
        local d, u, l = GetNetStats();
		local min, max = _G[k]:GetMinMaxValues();
		local lv = ( l / 1000 ) / ( max - min );
		if ( lv < 0 ) then lv = 0; elseif ( lv > 1 ) then lv = 1 end;
		if ( _G[k].channeling ) then
			_G[k].lag:ClearAllPoints();
			_G[k].lag:SetPoint("LEFT", _G[k], "LEFT", 0, 0);
		else
			_G[k].lag:ClearAllPoints();
			_G[k].lag:SetPoint("RIGHT", _G[k], "RIGHT", 0, 0);
		end;
		_G[k].lag:SetWidth(_G[k]:GetWidth() * lv);
    end
end;

if c["TargetFrameSpellBar"].enabled then
    function Target_Spellbar_AdjustPosition()
        Set(_G["TargetFrameSpellBar"].df, "TargetFrameSpellBar");
    end;
end;
if c["FocusFrameSpellBar"].enabled then
    function Focus_Spellbar_AdjustPosition()
        Set(_G["FocusFrameSpellBar"].df, "FocusFrameSpellBar");
    end;
end

for k, _ in pairs(c) do
    if c[k].enabled then
        local a = CreateFrame("Frame", "thek_Castbar_"..k, UIParent);
        d.w, d.h, d.x, d.y = nil, nil, nil, nil;

        _G[k.."Border"]:SetTexture("");
        _G[k.."Text"]:ClearAllPoints("");
        _G[k.."Text"]:SetPoint(unpack(c[k].textPosition));
        _G[k.."Text"]:SetFont(unpack(c[k].textFont));

        if find(k, "MirrorTimer") then
            d.w = c[k].castbarSize[1] + (c[k].castbarSize[3] * 2);
            d.h = c[k].castbarSize[2] + (c[k].castbarSize[3] * 2);
            d.x = c[k].castbarSize[3];
            d.y = c[k].castbarSize[4];
            
            _G[k.."StatusBar"]:SetStatusBarTexture(c[k].castbarTextures[1]);
        else
            d.w = c[k].castbarSize[1] + c[k].castbarSize[2] + (c[k].castbarSize[3] * 2) + c[k].castbarSize[4];
            d.h = c[k].castbarSize[2] + (c[k].castbarSize[3] * 2);
            d.x = c[k].castbarSize[2] + c[k].castbarSize[3] + c[k].castbarSize[4];
            d.y = c[k].castbarSize[4];

            _G[k]:SetStatusBarTexture(c[k].castbarTextures[1]);
            _G[k.."Flash"].Show = _G[k.."Flash"].Hide;
            _G[k.."Spark"].Show = _G[k.."Spark"].Hide;
            
            if _G[k.."BorderShield"] then
                _G[k.."BorderShield"].Show = _G[k.."BorderShield"].Hide;
            end;
            
            if _G[k.."Icon"] then
                _G[k.."Icon"]:Show();
                _G[k.."Icon"]:ClearAllPoints();
                _G[k.."Icon"]:SetPoint("RIGHT", _G[k], "LEFT", -(c[k].castbarSize[4]), 0);
                _G[k.."Icon"]:SetWidth(c[k].castbarSize[2]);
                _G[k.."Icon"]:SetHeight(c[k].castbarSize[2]);
                _G[k.."Icon"]:SetTexCoord(.08, .92, .08, .92);
            end;
            
            _G[k]:HookScript("OnSizeChanged", function() 
                _G[k].reset = true;
            end);
            _G[k]:HookScript("OnValueChanged", function()
                if _G[k].reset then
                    Set(a, k);
                    _G[k].reset = false;
                end;
            end);
            
            if c[k].enableLag then
                _G[k].lag = _G[k]:CreateTexture(nil, "BACKGROUND")
                _G[k].lag:SetHeight(c[k].castbarSize[2])
                _G[k].lag:SetWidth(0)
                _G[k].lag:SetPoint("RIGHT", _G[k], "RIGHT", 0, 0)
                _G[k].lag:SetTexture(1, 0, 0, 1)
            end;
        end;    
             
        if c[k].enableTimer then
            _G[k].timer = _G[k]:CreateFontString(nil);
            _G[k].timer:SetFont(unpack(c[k].textFont));
            _G[k].timer:SetPoint("RIGHT", _G[k], "RIGHT", -5, 2);
            _G[k].update = .1;
        end;
        
        if not _G[k]:GetPoint() then
            a:SetPoint("CENTER", UIParent, "CENTER")
        else
            a:SetPoint(unpack({_G[k]:GetPoint()}))
        end
            
        a:SetWidth(d.w); a:SetHeight(d.h);
        a:SetBackdrop({bgFile = c[k].castbarTextures[2]});
        a:SetBackdropColor(unpack(c[k].castbarBGColor));
        a:SetParent(_G[k]);
        a:SetMovable(true);
        a:EnableMouse(false);
        a:RegisterForDrag("LeftButton");
        a:SetScript("OnDragStart", function(self) self:StartMoving() end);
        a:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
        a.name = a:CreateFontString(nil, "OVERLAY");
        a.name:SetFont(unpack(c[k].textFont));
        a.name:SetPoint("CENTER", a);
        _G[k].d = d; _G[k].df = a; _G[k].name = a.name; _G[k].l = true;
       
        hooksecurefunc(_G[k], "Show", function() Set(a, k) end);
    end;
end;

hooksecurefunc("CastingBarFrame_OnUpdate", function(self, elapsed)
	if not self.timer then return end
	if self.update and self.update < elapsed then
		if self.casting then
			self.timer:SetText(format("(%.1f)", max(self.maxValue - self.value, 0)))
		elseif self.channeling then
			self.timer:SetText(format("(%.1f)", max(self.value, 0)))
		else
			self.timer:SetText("")
		end
		self.update = .1
	else
		self.update = self.update - elapsed
	end
end)

SLASH_thek_Castbar1 = "/tcb";
SlashCmdList["thek_Castbar"] = function()
	for k, _ in pairs(c) do
		if c[k].enabled then
			_G[k].l = not _G[k].l
			if _G[k].l then
				_G[k].df:SetParent(_G[k])
				_G[k].df:EnableMouse(false)
				_G[k].df:SetFrameLevel(_G[k]:GetFrameLevel() - 1)
				_G[k].name:SetText("")
			else
				_G[k].df:SetParent("UIParent")
				_G[k].df:EnableMouse(true)
				_G[k].name:SetText(k)
			end
		end
	end
end
UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil;