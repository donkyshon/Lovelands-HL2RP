local langEn = {}
local langRu = {}
langEn["iFemaleMilk"] = "Female Milk"
langRu["iFemaleMilk"] = "Грудное молоко"
langEn["iFemaleMilkDesc"] = "A white aluminum can with the inscription \"Nourishing breast milk, technically processed and sucked from a selected variety of womans\" and Universal Union brand."
langRu["iFemaleMilkDesc"] = "Алюминиевая банка белого цвета с надписью \"Питательное грудное молоко, технически обработанное и высосанное из отборного сорта молодых тружениц\" и фирменным знаком Альянса на ней."
langEn["iCumJuice"] = "Sperm Juice"
langRu["iCumJuice"] = "Семянной сок"
langEn["iCumJuiceDesc"] = "A white aluminum can with the inscription \"Nourishing semen juice, technically processed and sucked from a selected variety of men\" and Universal Union brand."
langRu["iCumJuiceDesc"] = "Алюминиевая банка белого цвета с надписью \"Питательная мужская сперма, технически обработанная и высосанная из отборного сорта мужчин\" и фирменным знаком Альянса на ней."
langEn["iPussyFresh"] = "Pussy Fresh"
langRu["iPussyFresh"] = "Сладкий Фреш"
langEn["iPussyFreshDesc"] = "A yellow aluminum can with the inscription \"Cold wonderful mix of pussy juice and semen\" and Universal Union brand."
langRu["iPussyFreshDesc"] = "Алюминиевая банка яркого желтого цвета с надписью \"Освежающий микс из соков женщин и семени мужчин\" и фирменным знаком Альянса на ней."

local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Female Milk"
	ITEM.PrintName = "iFemaleMilk"
	ITEM.description = "iFemaleMilkDesc"
	ITEM.model = "models/props_nunk/popcan01a.mdl"
	ITEM.cost = 4
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 10
	ITEM.dHunger = 1
	ITEM.dThirst = 8
	ITEM.dHealth = 1

	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Sperm Juice"
	ITEM.PrintName = "iCumJuice"
	ITEM.description = "iCumJuiceDesc"
	ITEM.model = "models/props_nunk/popcan01a.mdl"
	ITEM.cost = 4
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 10
	ITEM.dHunger = 1
	ITEM.dThirst = 8
	ITEM.dHealth = 1

	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Pussy Fresh"
	ITEM.PrintName = "iPussyFresh"
	ITEM.description = "iPussyFreshDesc"
	ITEM.model = "models/props_lunk/popcan01a.mdl"
	ITEM.skin = 3
	ITEM.cost = 4
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 10
	ITEM.dHunger = 4
	ITEM.dThirst = 15
	ITEM.dHealth = 1

	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()



ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)