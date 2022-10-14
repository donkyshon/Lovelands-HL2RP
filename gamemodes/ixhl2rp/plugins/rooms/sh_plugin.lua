PLUGIN.name = "Rooms"
PLUGIN.description = ""
PLUGIN.author = "Schwarz Kruppzo"

local ang = Angle(0, 90, 0)

HouseInfo = {
	RoomTypes = {
		["apps_a"] = {view_origin = Vector(7549.968750, 2439.968750, 166.031250), view_ang = ang, origin = Vector(7502.967285, 2094.471924, 166.031250 - 36), ang = ang}
	},
	Rooms = {
		[1] = {left = true, pos = 1, view_origin = Vector(-212, -1176, 272), view_ang = ang},
		[2] = {left = false, pos = 1, view_origin = Vector(40, -1176, 272), view_ang = ang},
		[3] = {left = true, pos = 2, view_origin = Vector(-212, -1176, 272 + 136), view_ang = ang},
		[4] = {left = false, pos = 2, view_origin = Vector(40, -1176, 272 + 136), view_ang = ang},
		[5] = {left = true, pos = 3, view_origin = Vector(-212, -1176, 272 + 136 * 2), view_ang = ang},
		[6] = {left = false, pos = 3, view_origin = Vector(40, -1176, 272 + 136 * 2), view_ang = ang},
		[7] = {left = true, pos = 4, view_origin = Vector(-212, -1176, 272 + 136 * 3), view_ang = ang},
		[8] = {left = false, pos = 4, view_origin = Vector(40, -1176, 272 + 136 * 3), view_ang = ang},
	}
}


function Phase_CanSee(activator, target)
	local phaseA = activator.phase_id
	local phaseB = target.phase_id

	if phaseA and phaseB then
		return phaseA == phaseB
	end

	return true
end

do
	local ENTITY = FindMetaTable("Entity")
	ENTITY.oldSetCustomCollisionCheck = ENTITY.oldSetCustomCollisionCheck or ENTITY.SetCustomCollisionCheck

	function ENTITY:SetCustomCollisionCheck(...)
		self:oldSetCustomCollisionCheck(...)
		self:CollisionRulesChanged()
	end
end

function PLUGIN:ShouldCollide(A, B)
	if A:IsWorld() or B:IsWorld() then
		return
	end
	
	if !Phase_CanSee(A, B) then

		return false
	else
		if A:IsPlayer() and B:IsPlayer() then
			return false
		end
	end
end

ix.util.Include("cl_phase.lua")
ix.util.Include("sv_phase.lua")

function PLUGIN:LoadData()
	local npc = self:GetData()

	if npc then
		for k, v in ipairs(npc) do
			local entity = ents.Create("apart_npc")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
		end
	end

	local data = ix.data.Get("phases") or {}

	for id, phaseData in pairs(data) do
		local phase = Restore_Phase(id, phaseData[1], phaseData[2], phaseData[3], phaseData[4])
		phase.room = phaseData[5]
		phase.data = util.JSONToTable(phaseData[6] or "[]")
		phase:SetLocked(phaseData[7])
		phase.props = util.JSONToTable(phaseData[8] or "[]")
	end
end

function PLUGIN:SaveData()
	local npc = {}

	for _, v in ipairs(ents.FindByClass("apart_npc")) do
		npc[#npc + 1] = {v:GetPos(), v:GetAngles()}
	end

	self:SetData(npc)

	local data = {}

	for id, phase in pairs(phases) do
		data[id] = {
			phase.title,
			phase.name,
			phase.character,
			phase.steamid,
			phase.room,
			util.TableToJSON(phase.data),
			phase.locked,
			util.TableToJSON(phase.props),
		}
	end

	ix.data.Set("phases", data)
end

ix.command.Add("RoomWall", {
	description = "[DEMO] Сменить текстуру стены (от 1 до 3)",
	adminOnly = true,
	arguments = {
		ix.type.number
	},
	OnRun = function(self, client, id)
		if client.phase then
			local phaseData = client.phase

			if phaseData.owner == client then
				client.phase.data.wall = math.Clamp(id, 1, 3)
			end

			for k, v in ipairs(player.GetAll()) do
				if v.phase_id != client.phase_id then continue end
				
				net.Start("room.data")
					net.WriteString(util.TableToJSON(client.phase.data))
				net.Send(v)
			end
		end
	end
})

ix.command.Add("RoomFloor", {
	description = "[DEMO] Сменить текстуру пола (от 1 до 2)",
	adminOnly = true,
	arguments = {
		ix.type.number
	},
	OnRun = function(self, client, id)
		if client.phase then
			local phaseData = client.phase

			if phaseData.owner == client then
				client.phase.data.floor = math.Clamp(id, 1, 2)
			end

			for k, v in ipairs(player.GetAll()) do
				if v.phase_id != client.phase_id then continue end
				
				net.Start("room.data")
					net.WriteString(util.TableToJSON(client.phase.data))
				net.Send(v)
			end
		end
	end
})