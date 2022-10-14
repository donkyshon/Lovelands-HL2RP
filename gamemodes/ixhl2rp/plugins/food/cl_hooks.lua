local PLUGIN = PLUGIN

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if character then
		local hunger = character:GetHunger()
		return hunger / 100, L("barHunger")
	end

	return false
end, Color(233, 149, 6, 255), nil, "hunger")

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if character then
		local thirst = character:GetThirst()
		return thirst / 100, L("barThirst")
	end

	return false
end, Color(108, 199, 219, 255), nil, "thirst")

// мда пососал