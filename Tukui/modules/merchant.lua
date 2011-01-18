local db = TukuiCF["merchant"]

local filter = {
	[6289]  = true, -- Raw Longjaw Mud Snapper
	[6291]  = true, -- Raw Brilliant Smallfish
	[6308]  = true, -- Raw Bristle Whisker Catfish
	[6309]  = true, -- 17 Pound Catfish
	[6310]  = true, -- 19 Pound Catfish
	[41808] = true, -- Bonescale Snapper
	[42336] = true, -- Bloodstone Band
	[42337] = true, -- Sun Rock Ring
	[43244] = true, -- Crystal Citrine Necklace
	[43571] = true, -- Sewer Carp
	[43572] = true, -- Magic Eater		
}

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	if db.sellgrays or db.sellmisc then
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l,lid = GetContainerItemLink(b, s), GetContainerItemID(b, s)
				if l and lid then
					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if db.sellgrays and select(3, GetItemInfo(l))==0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
					if db.sellmisc and filter[ lid ] then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage(tukuilocal.merchant_trashsell.." |cffffffff"..g..tukuilocal.goldabbrev.." |cffffffff"..s..tukuilocal.silverabbrev.." |cffffffff"..c..tukuilocal.copperabbrev..".",255,255,0)
		end
	end
	if not IsShiftKeyDown() then
		if CanMerchantRepair() and db.autorepair then
			local cost, possible = GetRepairAllCost()
			if cost>0 then
				if possible then
					RepairAllItems()
					local c = cost%100
					local s = math.floor((cost%10000)/100)
					local g = math.floor(cost/10000)
					DEFAULT_CHAT_FRAME:AddMessage(tukuilocal.merchant_repaircost.." |cffffffff"..g..tukuilocal.goldabbrev.." |cffffffff"..s..tukuilocal.silverabbrev.." |cffffffff"..c..tukuilocal.copperabbrev..".",255,255,0)
				else
					DEFAULT_CHAT_FRAME:AddMessage(tukuilocal.merchant_repairnomoney,255,0,0)
				end
			end
		end
	end
end)
f:RegisterEvent("MERCHANT_SHOW")

-- buy max number value with alt
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(self:GetID())
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end
