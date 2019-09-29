--v0.1

local handyRepairNSell = CreateFrame("Frame", "HandyRepairNSell");
handyRepairNSell:RegisterEvent("MERCHANT_SHOW");

local string repair_Failure = "Not enough gold";
local string repair_Sucess = "Sucessfully repaired for ";
local string junk_Price = "All items sold for ";

if GetLocale() == "deDE" then
	repair_Failure = "Nicht genug Gold vorhanden"
	repair_Sucess = "Erfolgreich repariert für "
	junk_Price = "Alle Gegenstände wurden verkauft für ";
end

local function Repair(self, event, ...)
	if (CanMerchantRepair()) then
		repairCost = GetRepairAllCost();
		curMoney = GetMoney();
		if (0 < repairCost) then
			if (repairCost <= curMoney) then
				RepairAllItems(false);
				print(repair_Sucess .. GetCoinText(repairCost, " "));
			else
				print(repair_Failure);
			end
		end
	end
end

local function SellJunk(self, event, ...)
	OpenAllBags();
	sumSellPrice = 0;
	for bag = 0,4 do
		for bagSlot = 1,GetContainerNumSlots(bag) do
			_, itemCount, _, itemQuality, _, _, itemLink = GetContainerItemInfo(bag, bagSlot);		
			if (itemQuality == 0) then
				print(itemLink);
				_, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink);
				sumSellPrice = sumSellPrice + (itemCount * itemSellPrice);
				UseContainerItem(bag, bagSlot);
			end
		end
	end
	if (sumSellPrice > 0) then
		print(junk_Price .. GetCoinText(sumSellPrice, " "));
	end
end

handyRepairNSell:HookScript("OnEvent", SellJunk);
handyRepairNSell:HookScript("OnEvent", Repair);