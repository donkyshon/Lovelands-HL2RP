ix.lang.AddTable("russian", {
	eyes1 = "голубой",
	eyes2 = "зеленый",
	eyes3 = "коричневый",
	eyes4 = "карий",
	eyes5 = "янтарный",
	eyes6 = "серый",

	hair1 = "темно-коричневый",
	hair2 = "светлый",
	hair3 = "черный",
	hair4 = "темно-рыжий",
	hair5 = "каштановый", 
	hair6 = "рыжий",
	hair7 = "седина",
	hair8 = "белый",
	hair9 = "лысый",

	feature1 = "МУЖЧИНА",
	feature2 = "ЖЕНЩИНА",
	feature3 = "НАПОЛОВИНУ (ОНО)",
	feature4 = "ВСЕ (ФУТАНАРИ)",

	pronoun1 = "он",
	pronoun2 = "она",

	gender1_ynn = "мужской",
	gender1_nyy = "мужеподобный",
	gender1_yny = "транссексуал",
	gender1_yyy = "гермафродит",

	gender2_ynn = "трап",
	gender2_nyy = "женский",
	gender2_yny = "транссексуал",
	gender2_yyy = "футанари",

	shape1_1 = "исхудалое",
	shape1_2 = "изящное",
	shape1_3 = "гибкое",
	shape1_4 = "худощавое",
	shape1_5 = "гимнастическое",

	shape2_1 = "стройное",
	shape2_2 = "утонченное",
	shape2_3 = "подвижное",
	shape2_4 = "гибкое",
	shape2_5 = "аэробное",

	shape3_1 = "пухлое",
	shape3_2 = "среднее",
	shape3_3 = "здоровое",
	shape3_4 = "подтянутое",
	shape3_5 = "атлетичное",
	
	shape4_1 = "толстое",
	shape4_2 = "пухлое",
	shape4_3 = "крепкое",
	shape4_4 = "сильное",
	shape4_5 = "крепчайшее",

	shape1 = "тощее",
	shape2 = "стройное",
	shape3 = "среднее",
	shape4 = "крупное",

	charcreate = "НОВОЕ ПРИБЫТИЕ",
	charcreate_left = "ПЕРСОНАЖ",
	charcreate_right = "ВНЕШНОСТЬ",

	charcreate_name = "ИМЯ",
	charcreate_random = "СЛУЧАЙНОЕ ИМЯ",
	charcreate_visual = "ВНЕШНЕЕ ОПИСАНИЕ",
	charcreate_phys = "ФИЗИЧЕСКОЕ ОПИСАНИЕ",

	char_age = "ВОЗРАСТ: ",
	char_height = "РОСТ: ",
	char_eye = "ЦВЕТ ГЛАЗ: ",
	char_hair = "ЦВЕТ ВОЛОС: ",
	char_shape = "ТЕЛОСЛОЖЕНИЕ: ",
	char_gender = "ПОЛ: ",

	charcreate_feature = "ОСОБЕННОСТИ: ",
	charcreate_pronoun = "ПРИНАДЛЕЖНОСТЬ: ",
	charcreate_type = "ТИП ТЕЛА",
	charcreate_model = "ВНЕШНИЙ ВИД",
	charcreate_gender = "ОПРЕДЕЛЕНИЕ ПОЛА",

	charcreate_back = "НАЗАД",
	charcreate_apply = "СОЗДАТЬ ПЕРСОНАЖА",

	phys_desc = "%s ТЕЛОСЛОЖЕНИЕ | %s | ВОЗРАСТ: %s | ЦВЕТ ГЛАЗ: %s | ЦВЕТ ВОЛОС: %s | ПОЛ: %s",
})

ix.lang.AddTable("english", {
	eyes1 = "blue",
	eyes2 = "green",
	eyes3 = "brown",
	eyes4 = "hazel",
	eyes5 = "amber",
	eyes6 = "gray",

	hair1 = "dark brown",
	hair2 = "blonde",
	hair3 = "black",
	hair4 = "auburn",
	hair5 = "chestnut", 
	hair6 = "ginger",
	hair7 = "gray",
	hair8 = "white",
	hair9 = "bald",

	feature1 = "MALE",
	feature2 = "FEMALE",
	feature3 = "HALF (SHEMALE)",
	feature4 = "ALL (FUTANARI)",

	pronoun1 = "masculine",
	pronoun2 = "feminine",

	gender1_ynn = "male",
	gender1_nyy = "butch",
	gender1_yny = "bustyboy",
	gender1_yyy = "hermaphrodite",

	gender2_ynn = "trap",
	gender2_nyy = "female",
	gender2_yny = "shemale",
	gender2_yyy = "futanari",

	shape1_1 = "gaunt",
	shape1_2 = "petite",
	shape1_3 = "willowy",
	shape1_4 = "lean",
	shape1_5 = "gymnastic",

	shape2_1 = "slim",
	shape2_2 = "thin",
	shape2_3 = "spry",
	shape2_4 = "lithe",
	shape2_5 = "aerobicised",

	shape3_1 = "chubby",
	shape3_2 = "average",
	shape3_3 = "healthly",
	shape3_4 = "fit",
	shape3_5 = "athletic",
	
	shape4_1 = "fat",
	shape4_2 = "plump",
	shape4_3 = "burly",
	shape4_4 = "powerful",
	shape4_5 = "buff",

	shape1 = "skinny",
	shape2 = "slender",
	shape3 = "average",
	shape4 = "large",

	charcreate = "CHARACTER CREATION",
	charcreate_left = "CHARACTER BIO",
	charcreate_right = "VISUAL LOOK",

	charcreate_name = "NAME",
	charcreate_random = "RANDOMIZE NAME",
	charcreate_visual = "VISUAL DESCRIPTION",
	charcreate_phys = "PHYSICAL DESCRIPTION",

	char_age = "AGE: ",
	char_height = "HEIGHT: ",
	char_eye = "EYE COLOR: ",
	char_hair = "HAIR COLOR: ",
	char_shape = "BODY SHAPE: ",
	char_gender = "GENDER: ",

	charcreate_feature = "FEATURE SET: ",
	charcreate_pronoun = "PRONOUN: ",
	charcreate_type = "BODY TYPE",
	charcreate_model = "APPEARANCE",
	charcreate_gender = "GENDER IDENTIFIER",

	charcreate_back = "BACK",
	charcreate_apply = "CREATE CHARACTER",

	phys_desc = "%s BODY SHAPE | %s | ~%s AGE | EYE COLOR: %s | HAIR COLOR: %s | GENDER: %s",
})

local EyeColors = {
	{"eyes1", Color(15, 178, 242)},
	{"eyes2", Color(67, 117, 18)},
	{"eyes3", Color(128, 72, 28)},
	{"eyes4", Color(189, 149, 102)},
	{"eyes5", Color(232, 162, 21)},
	{"eyes6", Color(128, 128, 128)}
}

local HairColors = {
	{"hair1", Color(102, 58, 23)},
	{"hair2", Color(254, 229, 126)},
	{"hair3", Color(16, 16, 16)},
	{"hair4", Color(200, 48, 0)},
	{"hair5", Color(160, 120, 85)},
	{"hair6", Color(255, 96, 0)},
	{"hair7", Color(128, 128, 128)},
	{"hair8", color_white},
	{"hair9", color_white},
}

local Features = {
	"feature1",
	"feature2",
	"feature3",
	"feature4"
}

local FeatureSet = {
	[1] = {1, 3},
	[2] = {2, 3, 4}
}

local Pronoun = {
	{"pronoun1", Color(138, 190, 255)},
	{"pronoun2", Color(255, 189, 255)},
}

local Names = {
	[1] = { -- masculine
		[1] = "gender1_ynn", -- YNN
		[2] = "gender1_nyy", -- NYY
		[3] = "gender1_yny", -- YNY
		[4] = "gender1_yyy", -- YYY
	},
	[2] = { -- feminine
		[1] = "gender2_ynn", -- YNN
		[2] = "gender2_nyy", -- NYY
		[3] = "gender2_yny", -- YNY
		[4] = "gender2_yyy", -- YYY
	},
}

local BodyShapes = {
	[1] = {"shape1_1", "shape1_2", "shape1_3", "shape1_4", "shape1_5"}, -- skinny
	[2] = {"shape2_1", "shape2_2", "shape2_3", "shape2_4", "shape2_5"}, -- slender
	[3] = {"shape3_1", "shape3_2", "shape3_3", "shape3_4", "shape3_5"}, -- average
	[4] = {"shape4_1", "shape4_2", "shape4_3", "shape4_4", "shape4_5"}, -- large
}

if !ix.char then
	include("sh_character.lua")
end

do
	local charMeta = ix.meta.character

	function charMeta:GetAge()
		local age = self:GetPhysData()[1] or 18
		
		return age
	end

	function charMeta:GetHeight()
		local height = self:GetPhysData()[2] or 175
		
		return string.format("%s cm", height)
	end

	function charMeta:GetEyeColor()
		local eye = self:GetPhysData()[3]
		local data = EyeColors[eye]

		if data then
			return data[1], data[2]
		end

		return EyeColors[1][1], EyeColors[1][2]
	end

	function charMeta:GetHairColor()
		local hair = self:GetPhysData()[4]
		local data = HairColors[hair]

		if data then
			return data[1], data[2]
		end

		return HairColors[1][1], HairColors[1][2]
	end

	function charMeta:GetBodyShape()
		local shapeData = self:GetPhysData()[5]

		if shapeData then
			local data = BodyShapes[shapeData[1]]

			if data then
				return data[shapeData[2]] or "shape3_3"
			end
		end
		
		return "shape3_3"
	end

	function charMeta:GetGenderName()
		local pronoun = self:GetPhysData()[7] or 1
		local gender = self:GetPhysData()[8]

		return gender, Pronoun[pronoun][2]
	end
end
