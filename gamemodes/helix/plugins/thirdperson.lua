
local PLUGIN = PLUGIN

PLUGIN.name = "Third Person"
PLUGIN.author = "Black Tea"
PLUGIN.description = "Enables third person camera usage."

ix.config.Add("thirdperson", false, "Allow Thirdperson in the server.", nil, {
	category = "server"
})

if (CLIENT) then
	local function isHidden()
		return !ix.config.Get("thirdperson")
	end


	ix.option.Add("thirdpersonEnabled", ix.type.bool, false, {
		category = "thirdperson",
		hidden = isHidden,
		OnChanged = function(oldValue, value)
			if value == true then
				gui.EnableScreenClicker(true)
			end
			
			hook.Run("ThirdPersonToggled", oldValue, value)
		end
	})


	concommand.Add("ix_togglethirdperson", function()
		local bEnabled = !ix.option.Get("thirdpersonEnabled", false)

		if !bEnabled then
			gui.EnableScreenClicker(false)
		end

		ix.option.Set("thirdpersonEnabled", bEnabled)
	end)

	local function isAllowed()
		return ix.config.Get("thirdperson")
	end

	local playerMeta = FindMetaTable("Player")
	local traceMin = Vector(-10, -10, -10)
	local traceMax = Vector(10, 10, 10)

	function playerMeta:CanOverrideView()
		local entity = Entity(self:GetLocalVar("ragdoll", 0))

		if (IsValid(ix.gui.characterMenu) and !ix.gui.characterMenu:IsClosing() and ix.gui.characterMenu:IsVisible()) then
			return false
		end

		if (IsValid(ix.gui.menu) and ix.gui.menu:GetCharacterOverview()) then
			return false
		end

		if (ix.option.Get("thirdpersonEnabled", false) and
			!IsValid(self:GetVehicle()) and
			isAllowed() and
			IsValid(self) and
			self:GetCharacter() and
			!self:GetNetVar("actEnterAngle") and
			!IsValid(entity) and
			LocalPlayer():Alive() and
			LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP) then
			return true
		end
	end

	local abs   = math.abs
	local Round = math.Round
	local sqrt  = math.sqrt
	local exp   = math.exp
	local log   = math.log
	local sin   = math.sin
	local cos   = math.cos
	local sinh  = math.sinh
	local cosh  = math.cosh
	local acos  = math.acos

	local deg2rad = math.pi/180
	local rad2deg = 180/math.pi

	local function qNormalize(q)
		local len = sqrt(q[1]^2 + q[2]^2 + q[3]^2 + q[4]^2)
		q[1] = q[1]/len
		q[2] = q[2]/len
		q[3] = q[3]/len
		q[4] = q[4]/len
	end

	local function qDot(q1, q2)
		return q1[1]*q2[1] + q1[2]*q2[2] + q1[3]*q2[3] + q1[4]*q2[4]
	end

	local function qmul(lhs, rhs)
		local lhs1, lhs2, lhs3, lhs4 = lhs[1], lhs[2], lhs[3], lhs[4]
		local rhs1, rhs2, rhs3, rhs4 = rhs[1], rhs[2], rhs[3], rhs[4]
		return {
			lhs1 * rhs1 - lhs2 * rhs2 - lhs3 * rhs3 - lhs4 * rhs4,
			lhs1 * rhs2 + lhs2 * rhs1 + lhs3 * rhs4 - lhs4 * rhs3,
			lhs1 * rhs3 + lhs3 * rhs1 + lhs4 * rhs2 - lhs2 * rhs4,
			lhs1 * rhs4 + lhs4 * rhs1 + lhs2 * rhs3 - lhs3 * rhs2
		}
	end

	local function quat(ang)
		local p, y, r = ang[1], ang[2], ang[3]
		p = p*deg2rad*0.5
		y = y*deg2rad*0.5
		r = r*deg2rad*0.5
		local qr = {cos(r), sin(r), 0, 0}
		local qp = {cos(p), 0, sin(p), 0}
		local qy = {cos(y), 0, 0, sin(y)}
		return qmul(qy,qmul(qp,qr))
	end

	local function nlerp(t, q0, q1)
		local t1 = 1 - t
		local q2
		if qDot(q0, q1) < 0 then
			q2 = { q0[1] * t1 - q1[1] * t, q0[2] * t1 - q1[2] * t, q0[3] * t1 - q1[3] * t, q0[4] * t1 - q1[4] * t }
		else
			q2 = { q0[1] * t1 + q1[1] * t, q0[2] * t1 + q1[2] * t, q0[3] * t1 + q1[3] * t, q0[4] * t1 + q1[4] * t }
		end

		qNormalize(q2)
		return q2
	end

	local function toAngle(this)
		local l = sqrt(this[1]*this[1]+this[2]*this[2]+this[3]*this[3]+this[4]*this[4])
		if l == 0 then return {0,0,0} end
		local q1, q2, q3, q4 = this[1]/l, this[2]/l, this[3]/l, this[4]/l

		local x = Vector(q1*q1 + q2*q2 - q3*q3 - q4*q4,
			2*q3*q2 + 2*q4*q1,
			2*q4*q2 - 2*q3*q1)

		local y = Vector(2*q2*q3 - 2*q4*q1,
			q1*q1 - q2*q2 + q3*q3 - q4*q4,
			2*q2*q1 + 2*q3*q4)

		local ang = x:Angle()
		if ang.p > 180 then ang.p = ang.p - 360 end
		if ang.y > 180 then ang.y = ang.y - 360 end

		local yyaw = Vector(0,1,0)
		yyaw:Rotate(Angle(0,ang.y,0))

		local roll = acos(math.Clamp(y:Dot(yyaw), -1, 1))*rad2deg

		local dot = q2*q1 + q3*q4
		if dot < 0 then roll = -roll end

		return Angle(ang.p, ang.y, roll)
	end


	local targetHeight = 0
	local yMinLimit = -80
	local yMaxLimit = 80
	local distance = 100

	local ft = FrameTime()
	local angles = Angle()
	local xDeg = angles.x
	local yDeg = angles.y
	currentDistance = distance
	desiredDistance = distance
	correctedDistance = distance;
	local rotateBehind = false

	local function ClampAngle(angle, min, max)
		if angle < -360 then
			angle = angle + 360
		end

		if angle > 360 then
	  		angle = angle - 360
	  	end
	  	
		return math.Clamp(angle, min, max)
	end

	local input_
	function PLUGIN:StartCommand(ply, command, x, y, angle)
		if ply:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() then
			if (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) and vgui.CursorVisible() then
				gui.EnableScreenClicker(false)
			elseif (!input.IsMouseDown(MOUSE_LEFT) and !input.IsMouseDown(MOUSE_RIGHT)) then
				gui.EnableScreenClicker(true)
			end

			command:SetSideMove(0)
			local angle = command:GetViewAngles()

			if input.IsMouseDown(MOUSE_RIGHT) then
				angle.y = angles.y

				angle:Normalize()
				command:SetViewAngles(angle)
			else
				angles.y = angles.y + ft * 200 * (command:KeyDown(IN_MOVELEFT) and 1 or 0)
				angles.y = angles.y - ft * 200 * (command:KeyDown(IN_MOVERIGHT) and 1 or 0)

				angle.y = angle.y + ft * 200 * (command:KeyDown(IN_MOVELEFT) and 1 or 0)
				angle.y = angle.y - ft * 200 * (command:KeyDown(IN_MOVERIGHT) and 1 or 0)
				angle:Normalize()
				command:SetViewAngles(angle)
			end
		end
	end
	function PLUGIN:CreateMove(ply, command, x, y, angle)
	end

	local function AnyMovement(client)
		return client:KeyDown(IN_FORWARD) or client:KeyDown(IN_MOVELEFT) or client:KeyDown(IN_MOVERIGHT) or client:KeyDown(IN_BACK) or client:KeyDown(IN_JUMP)
	end

	local curAng
	local function RotateBehindTarget()
		local targetRotationAngle = LocalPlayer():EyeAngles().y
		local currentRotationAngle = angles.y
		
		local targetAng = quat(Angle(0, LocalPlayer():EyeAngles().y, 0))
		curAng = quat(Angle(0, angles.y, 0))

		curAng = nlerp(3 * ft, curAng, targetAng)

		local c = toAngle(curAng)

		xDeg = c.y

		if (targetRotationAngle == currentRotationAngle) then
			rotateBehind = false
	    else
	    	rotateBehind = true
	    end
	end

	if mouse_hook then
		mouse_hook:Remove()
	end

	local minDistance, maxDistance = 1, 512
	mouse_hook = vgui.Create("Panel")
	mouse_hook:SetSize(ScrW(), ScrH())
	mouse_hook.OnMouseWheeled = function(self, scrollDelta)
		desiredDistance = desiredDistance - scrollDelta * ft * math.abs(desiredDistance) * 40
		desiredDistance = math.Clamp(desiredDistance, minDistance, maxDistance)
	end

    local traceData
    local traceResult 
    
    local correctedDistance = 0
	function PLUGIN:CalcView(client, origin, angles2, fov)
		if client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() then
			ft = FrameTime()

			if (!input.IsMouseDown(MOUSE_LEFT) and !input.IsMouseDown(MOUSE_RIGHT)) and AnyMovement(client) or rotateBehind then
				RotateBehindTarget()
			end

			yDeg = ClampAngle(yDeg, yMinLimit, yMaxLimit)

			local rotation = Angle(yDeg, xDeg, 0)

			local vTargetOffset = Vector(0, 0, targetHeight)
		    local position = origin - (rotation:Forward() * desiredDistance) + vTargetOffset

		    local truePos = origin + vTargetOffset
		    local isCorrected = false

		    traceData = {}
			traceData.start = truePos
			traceData.endpos = position
			traceData.filter = client

			local traceResult = util.TraceLine(traceData)

			correctedDistance = desiredDistance

			if traceResult.Hit then
				correctedDistance = traceResult.HitPos:Distance(truePos) - 5
				isCorrected = true
			end
			
		    // For smoothing, lerp distance only if either distance wasn't corrected, or correctedDistance is more than currentDistance
		    currentDistance = (!isCorrected or correctedDistance > currentDistance) and Lerp(ft * 5, currentDistance, correctedDistance) or correctedDistance
		         
		   	currentDistance = math.Clamp(currentDistance, minDistance, maxDistance)

		    position = origin - (rotation:Forward() * currentDistance) + vTargetOffset

		    angles = rotation

			view = {}
			view.origin = position
			view.angles = angles

			return view
		end
	end

	function PLUGIN:InputMouseApply(command, x, y, ang)
		owner = LocalPlayer()

		if !owner:CanOverrideView() or LocalPlayer():GetViewEntity() != LocalPlayer() then
			return
		end

		if !vgui.CursorVisible() then
			if input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT) then
				xDeg = xDeg + -x * 0.02
				yDeg = yDeg - -y * 0.02

				rotateBehind = false
			end
		end

		command:SetMouseX( 0 )
		command:SetMouseY( 0 )

		return true
	end

	function PLUGIN:ShouldDrawLocalPlayer()
		if LocalPlayer():GetViewEntity() == LocalPlayer() and !IsValid(LocalPlayer():GetVehicle()) then
			return LocalPlayer():CanOverrideView()
		end
	end
end

// мда пососал