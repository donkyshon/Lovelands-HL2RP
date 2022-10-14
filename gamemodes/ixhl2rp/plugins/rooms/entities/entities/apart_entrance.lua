ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:StartTouch(activator)
	if IsValid(activator) and activator:IsPlayer() then
		hook.Run("PlayerEnteredEntrance", activator)
	end
end

function ENT:EndTouch(activator)
	if IsValid(activator) and activator:IsPlayer() then
		hook.Run("PlayerExitedEntrance", activator)
	end
end

function ENT:KeyValue(key, value)
	if key == "area" then
		self.area = value
	end
end

// мда пососал