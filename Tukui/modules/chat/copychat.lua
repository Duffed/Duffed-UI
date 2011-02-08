local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-----------------------------------------------------------------------------
-- Copy on chatframes feature
-----------------------------------------------------------------------------

if C["chat"].enable ~= true then return end

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetTemplate("Transparent")
	frame:Width(TukuiBar1:GetWidth())
	frame:Height(250)
	frame:SetScale(1)
	frame:Point("BOTTOM", TukuiBar1, "BOTTOM", 0, 0)
	frame:CreateShadow("Default")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	if T.lowversion then
		editBox:Width(TukuiBar1:GetWidth() + 10)
	else
		editBox:Width((TukuiBar1:GetWidth() * 2) + 20)
	end
	editBox:Height(250)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

local function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:Size(20, 20)
		button:Point("TOPRIGHT", 0, 24)
		
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(C.media.font,12)
		buttontext:SetText(T.panelcolor.."C")
		buttontext:SetShadowColor(0, 0, 0)
		buttontext:SetShadowOffset(1.25, -1.25)
		buttontext:Point("CENTER", 1, 0)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
				
		button:SetScript("OnMouseUp", function(self, btn)
			if btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
		button:SetScript("OnEnter", function() button:SetAlpha(1) buttontext:SetText("C") end)
		
		if C.chat.background ~= true then
			button:SetAlpha(0.1)
			button:SetScript("OnLeave", function() button:SetAlpha(0.1) buttontext:SetText(T.panelcolor.."C") end)
			button:ClearAllPoints()
			button:SetPoint("TOPRIGHT", 0, 0)
		else
			if i == 2 and GetChannelName("Log") then
				button:Point("TOPRIGHT", 0, 48)
			end
			button:SetAlpha(1)
			button:SetScript("OnLeave", function() buttontext:SetText(T.panelcolor.."C") end)
		end
	end
end
ChatCopyButtons()