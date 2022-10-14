local PLUGIN = PLUGIN
PLUGIN.door_ents = nil
do
	local notDrawn = {}
	local cache_phase = {}

	function refreshVirtualEntity(entity)
		local clientSession = LocalPlayer().phase_id
		local entitySession = entity.phase_id

		if !IsValid(entity) then 
			return 
		end

		if !Phase_CanSee(LocalPlayer(), entity) and !notDrawn[entity] then
			notDrawn[entity] = true

			if entity.RenderOverride then 
				entity.ogRO = entity.RenderOverride 
			end

			entity.RenderOverride = function() end
			
			entity:SetCollisionGroup(10)
			entity:DestroyShadow()
			entity:DrawShadow(false)
		elseif notDrawn[entity] and Phase_CanSee(LocalPlayer(), entity) then
			if notDrawn[entity] then 
				notDrawn[entity] = nil 
			end

			entity.RenderOverride = entity.ogRO or nil

			if entity.cg then 
				entity:SetCollisionGroup(entity.cg) 
			end
		end
	end

	function PLUGIN:EntityNetworkedVarChanged(entity, key, old_value, value)
		if key == "phase" then
			if value != "" then
				entity.phase_id = value
			else
				entity.phase_id = nil
			end

			refreshVirtualEntity(entity)

			if entity == LocalPlayer() then
				for k, v in ipairs(ents.GetAll()) do
					refreshVirtualEntity(v)
				end
			end
		end
	end
	function PLUGIN:NotifyShouldTransmit(entity, should)
		if notDrawn[entity] and should then
			refreshVirtualEntity(entity)
		end
	end

	function PLUGIN:OnEntityCreated(entity)
		entity.cg = entity:GetCollisionGroup()

		local phase = entity:GetNW2String("phase")
		entity.phase_id = (phase != "") and phase or nil

		refreshVirtualEntity(entity)
	end

	net.Receive("phase.update", function()
		local entindex = net.ReadUInt(16)

		cache_phase[entindex] = true
	end)

	room_interact = {
		[1] = {
			pos = Vector(7300.738770, 2078.02050, 133.243225),
			actions = {
				[1] = {
					text = "Смыв",
					use = function(data)
						sound.Play("ambient/machines/usetoilet_flush1.wav", data.pos)
					end
				},
			}
		}
	}
	function PLUGIN:PrecacheDoorInteractions()
		self.door_ents = {}

		for k, v in ipairs(ents.FindByClass("apart_door")) do
			v.door = true

			self.door_ents[#self.door_ents + 1] = v
		end

		for k, v in ipairs(ents.FindByClass("apart_exit")) do
			v.exit = true

			self.door_ents[#self.door_ents + 1] = v
		end

		self.door_ents[#self.door_ents + 1] = 1
	end
end

local matrix = Matrix()
matrix:Scale(Vector(1 / 8, 1 / 8, 1))
matrix:Translate(Vector(0, -1.025, 0))

Custom_Walls = {
	[1] = {
		["$basetexture"] = "c24_v3/wallpaper/wallpaper_02",
		["$basetexturetransform"] = matrix,
		["$bumpmap"] = "c24_v3/wallpaper/wallpaper_02n",
		["$bumptransform"] = matrix,
		["$surfaceprop"] = "plaster",
		["$normalmapalphaenvmapmask"] = 1,
		["$detail"] = "c24_v3/detail/concrete_01",
		["$detailscale"] = 4,
		["$detailblendmode"] = 0,
		["$detailtexturetransform"] = matrix
	},
	[2] = {
		["$basetexture"] = "c24_v3/wallpaper/wallpaper_03",
		["$basetexturetransform"] = matrix,
		["$bumpmap"] = "c24_v3/wallpaper/wallpaper_07n",
		["$bumptransform"] = matrix,
		["$surfaceprop"] = "plaster",
		["$normalmapalphaenvmapmask"] = 1,
		["$detail"] = "c24_v3/detail/concrete_01",
		["$detailscale"] = 4,
		["$detailblendmode"] = 0,
		["$detailtexturetransform"] = matrix
	},
	[3] = {
		["$basetexture"] = "c24_v3/wallpaper/wallpaper_01",
		["$basetexturetransform"] = matrix,
		["$bumpmap"] = "c24_v3/wallpaper/wallpaper_01n",
		["$bumptransform"] = matrix,
		["$surfaceprop"] = "plaster",
		["$normalmapalphaenvmapmask"] = 1,
		["$detail"] = "c24_v3/detail/concrete_01",
		["$detailscale"] = 4,
		["$detailblendmode"] = 0,
		["$detailtexturetransform"] = matrix
	}
}

Custom_Floors = {
	[1] = {
		["$basetexture"] = "c24_v3/wood/woodfloor03",
		["$basetexturetransform"] = matrix,
		["$bumpmap"] = "c24_v3/wood/woodfloor02_n",
		["$bumptransform"] = matrix,
		["$surfaceprop"] = "wood",
		["$detail"] = "detail/wood_detail_01",
		["$detailscale"] = 15,
		["$detailblendfactor"] = 0.5,
		["$detailtexturetransform"] = matrix
	},
	[2] = {
		["$basetexture"] = "c24_v3/wood/woodfloor01",
		["$basetexturetransform"] = matrix,
		["$bumpmap"] = "c24_v3/wood/woodfloor01n",
		["$bumptransform"] = matrix,
		["$surfaceprop"] = "wood",
		["$detail"] = "c24_v3/detail/concrete_01",
		["$detailscale"] = 5,
		["$detailblendmode"] = 0,
		["$detailtexturetransform"] = matrix
	}
}

changed_textures = changed_textures or {}
function Room_ChangeTexture(mat, data)
	local MATERIAL = Material(mat)
	changed_textures[MATERIAL] = changed_textures[MATERIAL] or {}

	for k, v in pairs(changed_textures[MATERIAL]) do
		MATERIAL:SetUndefined(k)
	end

	for k, v in pairs(data) do
		changed_textures[MATERIAL][k] = true

		if k == "$basetexture" or k == "$bumpmap" or k == "$detail" then
			MATERIAL:SetTexture(k, v)
			continue
		end

		if ismatrix(v) then
			MATERIAL:SetMatrix(k, v)
		elseif isstring(v) then
			MATERIAL:SetString(k, v)
		elseif isnumber(v) then
			local z, x = math.modf(v)

			if x == 0 then
				MATERIAL:SetInt(k, v)
			else
				MATERIAL:SetFloat(k, v)
			end
		end
	end

	MATERIAL:Recompute()
end

local RT = GetRenderTarget("Test25", ScrW(), ScrH())
local RT_Mat = CreateMaterial("Test75", "UnlitGeneric", {
	["$basetexture"] = "Test25",
	["$translucent"] = "0",
})

room_mesh = room_mesh or nil

local function CreateMesh()
	local planes = {}
	
	for i, surf in ipairs(game.GetWorld():GetBrushSurfaces()) do
		local mat = surf:GetMaterial()
		if mat:GetShader():lower() != "unlitgeneric" then continue end
		
		if mat:GetName():lower() != "toolfake3d" then continue end
		mat:SetTexture("$basetexture", "5")
		mat:SetInt("$translucent", 1)
		mat:SetInt("$alpha", 0)
		mat:Recompute()
		local origin, normal, dist = game.GetWorld():GetBrushPlane(i)

		planes[#planes + 1] = {
			id = i,
			verts = surf:GetVertices(),
			normal = normal,
			origin = origin,
			dist = dist
		}
	end

	room_mesh = Mesh()

	if #planes > 0 then
		mesh.Begin(room_mesh, MATERIAL_QUADS, 3)

		for i = 1, #planes[1].verts do
			mesh.Position(planes[1].verts[i])
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()
		end

		mesh.End()
	end
end

do
	room_type = room_type or nil
	room_data = room_data or nil

	local renderViewTable = {
		origin = Vector(),
		angles = Angle(),
		drawviewmodel = false,
	}

	local function TransformPortal(pos, ang)
		local editedPos = Vector()
		local editedAng = Angle()

		if pos then
			local z, x = WorldToLocal(pos, Angle(), room_type.view_origin, room_type.view_ang) 
			editedPos = z

			local z, x = LocalToWorld(Vector(editedPos[1], editedPos[2], editedPos[3]), Angle(), room_data.view_origin, room_data.view_ang) 
			editedPos = z

			editedPos = editedPos + room_data.view_ang:Up()
		end

		if ang then
			local clonedAngle = Angle(ang[1], ang[2], ang[3]) -- rotatearoundaxis modifies original variable
			clonedAngle:RotateAroundAxis(room_type.view_ang:Forward(), 0)


			local z, x = WorldToLocal(Vector(), clonedAngle, room_type.view_origin, room_type.view_ang)
			local z, x = LocalToWorld(Vector(), x, room_data.view_origin, room_data.view_ang)

			editedAng = x

		end

		return editedPos, editedAng
	end

	function PLUGIN:PostDrawSkyBox(depth, skybox)
		if !room_type or !room_data then return end
		if !room_mesh then return end
		
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )

		render.SetStencilEnable(true)
		render.SetStencilReferenceValue(57)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_KEEP) 
		render.ClearStencil()

		draw.NoTexture()
		room_mesh:Draw()

		render.SetMaterial(RT_Mat)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.DrawScreenQuad()
		
		render.SetStencilEnable(false)
	end

	function PLUGIN:RenderScene(eyePos, eyeAngles, fov)
		if !room_type or !room_data then return end

		local oldrt = render.GetRenderTarget()

		render.SetRenderTarget(RT)
			render.Clear(0, 255, 0, 255, true, true)
			
			local editedPos, editedAng = TransformPortal(eyePos, eyeAngles)

			renderViewTable.origin = editedPos
			renderViewTable.angles = editedAng
			renderViewTable.fov = fov

			render.RenderView(renderViewTable)

		render.SetRenderTarget(oldrt)
	end
end

function PLUGIN:PrePlayerDraw(client)
	local owner = LocalPlayer()

	if owner != client and !Phase_CanSee(owner, client) then
		return true 
	end 
end

function PLUGIN:PlayerFootstep(client, position, foot, soundName, volume)
	if LocalPlayer().phase_id then
		if (client:GetCharacter():GetData("heavy") and client:IsRunning()) then
			client:EmitSound(({[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"})[foot])
			return true
		end

		client:EmitSound(soundName)
		return true
	end
end

function PLUGIN:InitPostEntity()
	for _, entity in ipairs(ents.GetAll()) do
		entity.cg = entity:GetCollisionGroup()
	end
end

function PLUGIN:EntityEmitSound(data)
	if data.Entity.phase_id then
		if !Phase_CanSee(LocalPlayer(), data.Entity) then
			return false 
		end 
	end
end

net.Receive("phase.sound", function()
	local soundname = net.ReadString()
	local level = net.ReadUInt(8) or 75
	local pitch = net.ReadUInt(7) or 100
	local channel = net.ReadInt(9) or CHAN_AUTO
	local volume = net.ReadFloat() or 1
	local entity = net.ReadEntity()

	if IsValid(entity) then
		entity:EmitSound(soundname, level, pitch, volume, channel)
	end
end)


function PLUGIN:GetTypingIndicatorPosition(client)
	if client.phase_id != LocalPlayer().phase_id then
		return vector_origin
	end
end

surface.CreateFont("Session", {
	font = "Roboto",
	size = 64,
	extended = true,
	weight = 400
})

local sessionTextClr = Color(255, 255, 255, 50)

function PLUGIN:HUDPaint()
	surface.SetTextColor(sessionTextClr)
	surface.SetFont("Session")
	surface.SetTextPos(50, 50)
	surface.DrawText(string.format("Phase #%s", LocalPlayer().phase_id or "world"))
end

net.Receive("room.data", function()
	local data = util.JSONToTable(net.ReadString())

	Room_ChangeTexture("customize_wall", Custom_Walls[tonumber(data.wall or 1)])
	Room_ChangeTexture("customize_floor", Custom_Floors[tonumber(data.floor or 1)])
end)

net.Receive("room.set", function()
	local class = net.ReadString()
	local room = net.ReadUInt(4)
	local data = util.JSONToTable(net.ReadString())
	local locked = net.ReadBool()

	CreateMesh()

	Room_ChangeTexture("customize_wall", Custom_Walls[tonumber(data.wall or 1)])
	Room_ChangeTexture("customize_floor", Custom_Floors[tonumber(data.floor or 1)])

	room_type = HouseInfo.RoomTypes[class]
	room_data = HouseInfo.Rooms[room]

	phase_locked = locked
end)

net.Receive("room.reset", function()
	room_type = nil
	room_data = nil
end)

net.Receive("room.entermenu", function(len, client)
	local data = net.ReadTable()

	local frame = vgui.Create("DFrame")
	frame:SetPos(100, 100)
	frame:SetSize(320, 200)
	frame:SetTitle("Войти в апартаменты")
	frame:MakePopup()
	frame:Center()

	local AppList = frame:Add("DListView")
	AppList:Dock( FILL )
	AppList:SetMultiSelect( false )
	AppList:AddColumn("Комната")

	for k, v in ipairs(data) do
		local line = AppList:AddLine(v[1]..(v[3] and (" \""..v[3].."\"") or "")..(v[4] and (" ("..v[4]..")") or ""))
		line.room = v[1]
	end

	AppList.DoDoubleClick = function(self, id, panel)
		net.Start("room.entermenu")
			net.WriteString(panel.room)
		net.SendToServer()
	end

	room_entermenu = frame
end)

net.Receive("room.entermenu.close", function(len, client)
	if IsValid(room_entermenu) then
		room_entermenu:Close()
	end
end)

net.Receive("room.buymenu", function(len, client)
	local data = {
		side = true,
		elevator = 1
	}

	local frame = vgui.Create("DFrame")
	frame:SetPos(100, 100)
	frame:SetSize(320, 200)
	frame:SetTitle("Выбор комнаты")
	frame:MakePopup()
	frame:Center()
	frame.OnClose = function()
		net.Start("room.buymenu")
		net.SendToServer()
	end

	local right = frame:Add("EditablePanel")
	right:Dock(FILL)

	local text = right:Add("DLabel")
	text:Dock(TOP)
	text:SetText("Название (необяз.)")

	local title = right:Add("DTextEntry")
	title:Dock(TOP)

	local text = right:Add("DLabel")
	text:Dock(TOP)
	text:SetText("Вид из окна")

	local side = right:Add("DComboBox")
	side:Dock(TOP)
	side:AddChoice("С левой стороны", true, true)
	side:AddChoice("С правой стороны", false)
	side.OnSelect = function(_, _, _, value)
		value = tobool(value)

		data.side = value
	end

	local elevator = right:Add("DComboBox")
	elevator:Dock(TOP)
	for i = 1, 4 do
		elevator:AddChoice("Этаж "..i, i, i == 1)
	end
	elevator.OnSelect = function(_, _, _, value)
		value = tonumber(value)

		data.elevator = value
	end

	local buy = right:Add("DButton")
	buy:Dock(BOTTOM)
	buy:SetText("Выбрать")
	buy.DoClick = function()
		net.Start("room.buy")
			net.WriteBool(data.side)
			net.WriteUInt(data.elevator, 4)
			net.WriteString(title:GetValue() or "")
		net.SendToServer()

		frame:Close()
	end
end)

local invite_queue = {}
local invite_active

if panel_invite then
	panel_invite:Remove()
	panel_invite = nil
end

net.Receive("room.invite.request", function(len)
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if character then
		if invite_queue[id] then
			return
		end

		invite_queue[id] = true
	end

	if !panel_invite then
		local frame = vgui.Create("DFrame")
		frame:SetPos(ScrW() - 320, 100)
		frame:SetSize(320, 200)
		frame:SetTitle("Кто там? [Y]")
		frame:ShowCloseButton(false)

		local label = frame:Add("DLabel")
		label:Dock(TOP)
		label:SetContentAlignment(5)
		label:SetText("К вам постучался")

		local desc = frame:Add("DLabel")
		desc:Dock(TOP)
		desc:SetWrap(true)
		desc:SetAutoStretchVertical(true)
		desc:SetContentAlignment(5)
		desc:SetText("dsad dsaddsaddsaddsaddsaddsaddsaddsaddsad dsad dsad")

		local label = frame:Add("DLabel")
		label:Dock(TOP)
		label:SetContentAlignment(5)
		label:SetText("Хотите его впустить?")

		local accept = frame:Add("DButton")
		accept:Dock(BOTTOM)
		accept:SetText("Принять")
		
		local decline = frame:Add("DButton")
		decline:Dock(BOTTOM)
		decline:SetText("Отказать")

		local function size()
			frame:SetTall(32 + label:GetTall() + desc:GetTall() + label:GetTall() + accept:GetTall() + decline:GetTall())
		end
		
		local function load(character)
			local name = LocalPlayer():GetCharacter():DoesRecognize(character) and character:GetName() or ("["..character:GetDescription().."]")
			
			desc:SetText(name)

			size()

			accept.DoClick = function()
				invite_queue[id] = nil

				net.Start("room.invite.request")
					net.WriteUInt(character:GetID(), 32)
				net.SendToServer()

				if table.IsEmpty(invite_queue) then
					panel_invite:Remove()
					panel_invite = nil
				else
					local keys = table.GetKeys(invite_queue)
					
					load(keys[1])
				end
			end

			decline.DoClick = function()
				invite_queue[id] = nil

				if table.IsEmpty(invite_queue) then
					panel_invite:Remove()
					panel_invite = nil
				else
					local keys = table.GetKeys(invite_queue)
					
					load(keys[1])
				end
			end
		end

		load(character)

		panel_invite = frame
	end
end)

net.Receive("room.interact.lock", function(len, client)
	local locker = net.ReadEntity()
	local locked = net.ReadBool()

	phase_locked = locked

	locker:EmitSound(phase_locked and "doors/door_latch3.wav" or "doors/door_latch1.wav")
end)

local crit_material = Material("cellar/ui/crit.png")

if file.Exists("door.png", "DATA") then
	crit_material = Material("../data/door.png")
else
	http.Fetch("http://i.imgur.com/UoN0kcV.png", function(b)
		if b then
			file.Write("door.png", b)
			crit_material = Material("../data/door.png")
		end
	end)
end

local size = 32
local mid  = size / 2
local abs = math.abs
local use = string.upper(input.LookupBinding("+use"))

surface.CreateFont("ixCrit", {
	font = "Roboto Lt",
	size = 18,
	weight = 500,
	antialias = true,
	extended = true
})
surface.CreateFont("ixCritBlur", {
	font = "Roboto Lt",
	size = 18,
	weight = 500,
	blursize = 2,
	antialias = true,
	extended = true
})


local function IsOffScreen(scrpos)
	return not scrpos.visible or scrpos.x < 0 or scrpos.y < 0 or scrpos.x > ScrW() or scrpos.y > ScrH()
end

local focus_stick = 0
local focus_range = 25
local focus_ent = nil
local focused_ent = nil
local menu_active
local function UseButton()
	if menu_active and menu_active:IsVisible() then
		focused_ent = nil
		return true
	end
	
	if focused_ent then
		local x, y = input.GetCursorPos()

		if isnumber(focused_ent) then
			local data = room_interact[focused_ent]

			local menu = DermaMenu() 
				for k, v in ipairs(data.actions) do
					menu:AddOption(v.text, function() v.use(data) end)
				end
			menu:Open()

			menu:SetPos(x, y)

			menu_active = menu
		elseif IsValid(focused_ent) then
			if focused_ent.exit then 
				local menu = DermaMenu() 
					if LocalPlayer().phase_id == LocalPlayer():GetCharacter():GetData("house") then
						menu:AddOption(phase_locked and "Открыть" or "Закрыть", function() 
							net.Start("room.interact.lock")
							net.SendToServer()
						end)
					end
					menu:AddOption("Выйти", function() 
						net.Start("room.interact.exit")
						net.SendToServer()
					end)
				menu:Open()

				menu:SetPos(x, y)

				menu_active = menu
			else
				local menu = DermaMenu() 
					menu:AddOption("Пройти", function()
						net.Start("room.interact.use")
						net.SendToServer()
					end)
				menu:Open()

				menu:SetPos(x, y)

				menu_active = menu
			end
		end
	end

	focused_ent = nil
	return true
end


hook.Add("PlayerBindPress", "room", function(client, bind, pressed)
	if !client.phase_id then return end
	
	if focused_ent and focus_stick >= CurTime() then
		if bind:find("+use") and pressed then
			return UseButton()
		end
	end
end)

hook.Add("HUDPaint", "room", function()
	local client = LocalPlayer()

	if !client or !client.phase_id then return end

	if !PLUGIN.door_ents then
		PLUGIN:PrecacheDoorInteractions()
	end
	
	surface.SetMaterial(crit_material)

	local plypos = client:GetPos()
	local midscreen_x = ScrW() / 2
	local midscreen_y = ScrH() / 2

	if vgui.CursorVisible() then
		midscreen_x = gui.MouseX()
		midscreen_y = gui.MouseY()
	end

	local pos, scrpos, d
	local focus_ent = nil
	local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y

	for _, data in ipairs(PLUGIN.door_ents) do
		if isnumber(data) then
			pos = room_interact[data].pos
		else
			pos = data:GetPos() + data:GetRight() * -42 + data:GetUp() * -10
		end
		
		scrpos = pos:ToScreen()

		if !IsOffScreen(scrpos) then
			d = pos - plypos
			d = d:Dot(d) / (100 ^ 2)

			if d < 1 then
				surface.SetDrawColor(255, 255, 255, 255 * (1 - d))
				surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)

				if d > focus_d then
					local x = abs(scrpos.x - midscreen_x)
					local y = abs(scrpos.y - midscreen_y)
					if (x < focus_range and y < focus_range and
						 x < focus_scrpos_x and y < focus_scrpos_y) then

						if focus_stick < CurTime() or data == focused_ent then
							focus_ent = data
						end
					end
				end
			end
		end

		if data == focus_ent then
			focused_ent = focus_ent
			focus_stick = CurTime() + 0.1

			local text = string.format("[%s] ВЗАИМОДЕЙСТВИЕ", use)
			local x = scrpos.x
			local y = scrpos.y + 16
			surface.SetFont("ixCrit")

			local tX, tY = surface.GetTextSize(text)
			x = x - tX/2
			
			surface.SetFont("ixCritBlur")
			surface.SetTextColor(0, 0, 0, 255)
			surface.SetTextPos(x, y)
			surface.DrawText(text)

			surface.SetFont("ixCrit")
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(x, y)
			surface.DrawText(text)
		end
	end
end)
