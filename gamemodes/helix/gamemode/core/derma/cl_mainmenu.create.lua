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

local function Scale(px)
	return math.ceil(math.max(480, ScrH()) * (px / 1080))
end

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



local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",			"Entity" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )
local xDeg, yDeg = 0, 0

function PANEL:Init()
	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos(Vector( 50, 50, 50))
	self:SetLookAt(Vector( 0, 0, 40))
	self:SetFOV(80)

	self:SetText("")
	self:SetAnimSpeed(0.5)
	self:SetAnimated(false)

	self:SetAmbientLight(Color(0, 0, 0))

	self:SetColor( color_white )
	self:SetModel("models/player/hla/metropolice_npc.mdl")

	self:SetCursor("sizeall")
end

function PANEL:SetModel(strModelName)
	if IsValid(self.Entity) then
		self.Entity:Remove()
		self.Entity = nil
	end

	if !ClientsideModel then return end

	self.Entity = ClientsideModel(strModelName, RENDERGROUP_OTHER)
	if !IsValid(self.Entity) then return end

	self.Entity:SetNoDraw(true)
	self.Entity:SetIK(false)

	-- Try to find a nice sequence to play
	local iSeq = self.Entity:SelectWeightedSequence(ACT_IDLE)
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end
	
end

function PANEL:GetModel()
	if !IsValid(self.Entity) then return end

	return self.Entity:GetModel()
end

function PANEL:DrawModel()
	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	-- Causes issues with stencils, but only for some people?
	-- render.ClearDepth()

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModel( self.Entity )
	if ( ret != false ) then
		self.Entity:DrawModel()
		self:PostDrawModel( self.Entity )
	end

	render.SetScissorRect(0, 0, 0, 0, false)
end


function PANEL:PreDrawModel( ent ) return true end
function PANEL:PostDrawModel(ent) end

local tabs = {
	[1] = {
		type = MATERIAL_LIGHT_DIRECTIONAL,
		color = Vector(0.5, 0.8, 1) * 4,
		dir = Vector(-1, -1, -1),
		range = 1,
	},
	[2] = {
		type = MATERIAL_LIGHT_DIRECTIONAL,
		color = Vector(1, 0.8, 0.5),
		dir = Vector(1, 1, 0),
		range = 1,
	},
}


local radial = Material("helix/gui/radial-gradient.png", "smooth")
local radial_clr = Color(50, 60, 65)
local bg_clr = Color(40, 44, 42)
local angles = Angle()
local rotation_ang = Angle()
local curAng

local function RotateBehindTarget()
	local targetRotationAngle = LocalPlayer():EyeAngles().y
	local currentRotationAngle = angles.y
	
	local targetAng = quat(Angle(-yDeg, xDeg, 0))
	curAng = quat(rotation_ang)

	curAng = nlerp(30 * FrameTime(), curAng, targetAng)

	rotation_ang = toAngle(curAng)
end

local function ClampAngle(angle, min, max)
	if angle < -360 then
		angle = angle + 360
	end

	if angle > 360 then
  		angle = angle - 360
  	end
  	
	return math.Clamp(angle, min, max)
end

function PANEL:Paint(w, h)
	if !IsValid(self.Entity) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end

	if self.dragging then
		local x, y = gui.MousePos()
		xDeg = xDeg + (self.dragX - x)
		yDeg = yDeg + (self.dragY - y)

		self.dragX = x
		self.dragY = y
	end

	yDeg = ClampAngle(yDeg, -90, 16)
	RotateBehindTarget()
	local rotation = rotation_ang

	local vTargetOffset = Vector(0, 0, -40)
    local position = -(rotation:Forward() * 120 + vTargetOffset) 

    angles = rotation

	cam.Start3D(position, angles, 75, x, y, w, h, 5, self.FarZ )
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
		render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
		render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()

		render.SetMaterial( radial ) -- If you use Material, cache it!
		render.DrawQuadEasy( Vector( 0, 0, 1 ), Vector( 0, 0, 1 ), 1024, 1024, radial_clr, 0)
		render.DrawQuadEasy( Vector( 0, 0, 1 ), Vector( 0, 0, 1 ), 196, 196, Color(142, 156, 160, 100), 0)
		
		render.DrawQuadEasy( Vector( 0, 0, 1 ), Vector( 0, 0, 1 ), 64, 64, Color(30, 40, 45, 255), 0)
		render.DrawQuadEasy( Vector( 0, 0, 1 ), Vector( 0, 0, 1 ), 32, 32, Color(0, 0, 0, 128), 0)
		
		render.ResetModelLighting(0.25, 0.25, 0.25)
			render.SetLocalModelLights(tabs)
			self:DrawModel()
		render.SuppressEngineLighting( false )
	cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
end

function PANEL:DragMousePress()
	self.dragX, self.dragY = gui.MousePos()
	self.dragging = true
end

function PANEL:DragMouseRelease() 
	self.dragging = false
end

function PANEL:LayoutEntity(Entity)
	self:RunAnimation()
end

function PANEL:OnRemove()
	if IsValid(self.Entity) then
		self.Entity:Remove()
	end
end
vgui.Register("ui.character.model", PANEL, "DButton")


do
	surface.CreateFont("char.create.title", {
		font = "Blender Pro Book",
		extended = true,
		size = Scale(48),
		weight = 500,
		antialias = true,
	})
	surface.CreateFont("char.create.subtitle", {
		font = "Blender Pro Medium",
		extended = true,
		size = Scale(30),
		weight = 500,
		antialias = true,
	})
	surface.CreateFont("char.create.container", {
		font = "Blender Pro Medium",
		extended = true,
		size = Scale(20),
		weight = 500,
		antialias = true,
	})
	surface.CreateFont("char.create.text", {
		font = "Blender Pro Book",
		extended = true,
		size = Scale(19),
		weight = 500,
		antialias = true,
	})
	surface.CreateFont("char.create.button", {
		font = "Blender Pro Book",
		extended = true,
		size = Scale(30),
		weight = 500,
		antialias = true,
	})
end

local PANEL = {}
function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:SetText("")
	self:SetCursor("hand")

	self.padding = Scale(5)

	self:Dock(TOP)
	self:DockPadding(self.padding, 0, 0, 0)

	self.title = self:Add("DLabel")
	self.title:SetFont("char.create.container")
	self.title:SetTextColor(ColorAlpha(color_white, 255 * 0.5))
	self.title:Dock(LEFT)

	self.value = self:Add("DLabel")
	self.value:SetFont("char.create.container")
	self.value:SetTextColor(ColorAlpha(color_white, 255))
	self.value:Dock(FILL)

	self:SetAlpha(255 * 0.5)

	self.format = nil
	self.max_width = 0
	self.entered = false
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then return end
	
	self:AlphaTo(255, 0.25, 0)
	self.entered = true
end
function PANEL:OnCursorExited()
	if self:GetDisabled() then return end

	self:AlphaTo(255 * 0.5, 0.25, 0)
	self.entered = false
end

function PANEL:SetTitle(title)
	self.title:SetText(title)
	self.title:SizeToContents()

	self.max_width = self.title:GetWide() + self.value:GetWide()

	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end

function PANEL:SetValue(value, format)
	self.format = format and format or self.format

	self.var = value
	self.value:SetText(self.format and string.format(self.format, value) or value)
	self.value:SizeToContents()

	self.max_width = self.title:GetWide() + self.value:GetWide()

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

function PANEL:GetValue(value)
	return self.var
end

function PANEL:DoClick()
	if self:GetDisabled() then return end

	local menu = DermaMenu()

	if self.CreateMenu then
		self.CreateMenu(self, menu)
	end

	menu:Open()
end

function PANEL:SetValueColor(clr)
	self.value:SetTextColor(clr)
end

function PANEL:Paint(w, h) 
	if self.entered then
		DisableClipping(true)
			surface.SetDrawColor(ColorAlpha(color_white, self:GetAlpha()))
			surface.DrawRect(self.padding, h, self.max_width, 1)
		DisableClipping(false)
	end
end

vgui.Register("ui.character.selector", PANEL, "DLabel")

local PANEL = {}
function PANEL:Init()
	self:SetFont("char.create.button")
	self:SetTextColor(color_white)
	self:SetPaintBackground(false)

	self.entered = false
	self.currentAlpha = 0.5
	self:SetAlpha(255 * 0.5)
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then return end
	
	self.entered = true
	self:CreateAnimation(0.25, {
		target = {currentAlpha = 1},
		Think = function(animation, panel)
			panel:SetAlpha(255 * panel.currentAlpha)
		end
	})

	LocalPlayer():EmitSound("Helix.Rollover")
end

function PANEL:OnCursorExited()
	if self:GetDisabled() then return end

	self.entered = false
	self:CreateAnimation(0.25, {
		target = {currentAlpha = 0.5},
		Think = function(animation, panel)
			panel:SetAlpha(255 * panel.currentAlpha)
		end
	})
end

function PANEL:OnMousePressed(code)
	if self:GetDisabled() then
		return
	end

	LocalPlayer():EmitSound("Helix.Press")

	if code == MOUSE_LEFT and self.DoClick then
		self:DoClick(self)
	elseif code == MOUSE_RIGHT and self.DoRightClick then
		self:DoRightClick(self)
	end
end

function PANEL:Paint(w, h) 
	if self.entered then
		DisableClipping(true)
			surface.SetDrawColor(ColorAlpha(color_white, 255 * self.currentAlpha))
			surface.DrawRect(0, h, w, 2)
		DisableClipping(false)
	end
end

vgui.Register("ui.character.button", PANEL, "DButton")

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

local CITIZEN_MODELS = {
	[1] = {"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group02/male_01.mdl",
	"models/humans/group02/male_03.mdl",
	"models/humans/group02/male_05.mdl",
	"models/humans/group02/male_07.mdl",
	"models/humans/group02/male_09.mdl"},
	[2] = {
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl",
	"models/humans/group02/female_01.mdl",
	"models/humans/group02/female_03.mdl",
	"models/humans/group02/female_06.mdl",
	"models/humans/group01/female_04.mdl"}
}

DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}
local gradient = Material("vgui/gradient-u")
local vignette = Material("helix/gui/vignette.png", "smooth")
function PANEL:Init()
	local w, h = ScrW(), ScrH()

	self.view = self:Add("ui.character.model")
	self.view:SetPos(0, 0)
	self.view:SetSize(w, h)
	self.view.PaintOver = function(this, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(vignette)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local padding = Scale(24)
	local title = self:Add("DLabel")
	title:SetFont("char.create.title")
	title:SetTextColor(ColorAlpha(color_white, 255 * 0.05))
	title:SetContentAlignment(6)
	title:SetText(L"charcreate")
	title:SizeToContents()
	title:AlignRight(padding)
	title:AlignTop(padding)

	self.container_width = Scale(400)

	local padding_x = Scale(40)
	local padding_y = Scale(138)

	self.left = self:Add("DLabel")
	self.left:SetFont("char.create.subtitle")
	self.left:SetTextColor(ColorAlpha(color_white, 255 * 0.25))
	self.left:SetText(L"charcreate_left")
	self.left:SizeToContents()
	self.left:AlignLeft(padding_x)
	self.left:AlignTop(padding_y)

	self.right = self:Add("DLabel")
	self.right:SetFont("char.create.subtitle")
	self.right:SetTextColor(ColorAlpha(color_white, 255 * 0.25))
	self.right:SetText(L"charcreate_right")
	self.right:SizeToContents()
	self.right:AlignRight(padding_x)
	self.right:AlignTop(padding_y)

	self.last_left = self.left
	self.last_right = self.right

	self.containers = {
		[1] = {},
		[2] = {}
	}

	self.data = {}

	self:CreateContainer(1, L"charcreate_name", function(container)
		local entry = container:Add("DTextEntry")
		entry:Dock(TOP)
		entry:DockMargin(0, Scale(8), 0, 0)
		entry:SetFont("char.create.text")
		entry:SetTextColor(ColorAlpha(color_white, 255 * 0.5))
		entry:SetPaintBackground(false)
		entry:SetTall(Scale(32))
		entry.OnChange = function(this)
			self.data.name = this:GetValue()
		end
		entry.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 255 * 0.5)
			surface.DrawRect(0, 0, w, h)

			this:DrawTextEntryText(this:GetTextColor(), this:GetHighlightColor(), color_white)
		end

		self.SetCharName = function(this, value)
			self.data.name = value
			entry:SetValue(value)
		end

		local randomize = container:Add("ui.character.selector")
		randomize:SetTitle(L"charcreate_random")
		randomize:SetValue(0, "")
		randomize.DoClick = function()
			local name = GetHumanFirstNames(self.data.pronoun == 1)[math.random(self.data.pronoun == 1 and HUMAN_NAMES_MALE or HUMAN_NAMES_FEMALE)]
			local lastname = GetHumanLastNames()[math.random(HUMAN_LASTNAMES)]
			local result = name:utf8sub(1, 1)..name:utf8sub(2):utf8lower().." "..lastname:utf8sub(1, 1)..lastname:utf8sub(2):utf8lower()

			entry:SetValue(result)
			self.data.name = result
		end
	end)

	self:CreateContainer(1, L"charcreate_visual", function(container)
		local entry = container:Add("DTextEntry")
		entry:Dock(TOP)
		entry:DockMargin(0, Scale(8), 0, 0)
		entry:SetFont("char.create.text")
		entry:SetTall(Scale(150))
		entry:SetTextColor(ColorAlpha(color_white, 255 * 0.5))
		entry:SetPaintBackground(false)
		entry:SetMultiline(true)
		entry.OnChange = function(this)
			self.data.description = this:GetValue()
		end
		entry.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 255 * 0.5)
			surface.DrawRect(0, 0, w, h)

			this:DrawTextEntryText(this:GetTextColor(), this:GetHighlightColor(), color_white)
		end

		self.SetCharDesc = function(this, value)
			self.data.description = value
			entry:SetValue(value)
		end
	end)

	self:CreateContainer(1, L"charcreate_phys", function(container)
		container.title:DockMargin(0, 0, 0, Scale(18))

		local age = container:Add("ui.character.selector")
		age:SetTitle(L"char_age")
		age.CreateMenu = function(this, menu)
			local value = vgui.Create("DNumberWang", menu)
			value:SetMin(18)
			value:SetMax(40)
			value:SetValue(this:GetValue())
			value.OnValueChanged = function(this)
				self:SetAge(this:GetValue())
			end

			menu:AddPanel(value)
		end

		self.SetAge = function(this, value)
			age:SetValue(value)

			self.data.age = value
		end

		local height = container:Add("ui.character.selector")
		height:SetTitle(L"char_height")
		height:SetValue(0, "%s cm")
		height.CreateMenu = function(this, menu)
			local value = vgui.Create("DNumberWang", menu)
			value:SetMin(150)
			value:SetMax(195)
			value:SetValue(this:GetValue())
			value.OnValueChanged = function(this)
				self:SetPhysHeight(this:GetValue())
			end

			menu:AddPanel(value)
		end

		self.SetPhysHeight = function(this, value)
			height:SetValue(value)

			self.data.height = value
		end

		local eyes = container:Add("ui.character.selector")
		eyes:SetTitle(L"char_eye")
		eyes:SetValue("BLUE")
		eyes:SetValueColor(Color(64, 64, 255))
		eyes.CreateMenu = function(this, menu)
			for k, v in ipairs(EyeColors) do
				local id = v[1]

				menu:AddOption(L(id), function()
					self:SetEyes(k)
				end)
			end
		end

		self.SetEyes = function(this, value)
			local data = EyeColors[value]

			eyes:SetValue(L(data[1]):utf8upper())
			eyes:SetValueColor(data[2])

			self.data.eyes = value
		end

		local hair = container:Add("ui.character.selector")
		hair:SetTitle(L"char_hair")
		hair:SetValue("BROWN")
		hair:SetValueColor(Color(128, 64, 32))
		hair.CreateMenu = function(this, menu)
			for k, v in ipairs(HairColors) do
				local id = v[1]

				menu:AddOption(L(id), function()
					self:SetHair(k)
				end)
			end
		end

		self.SetHair = function(this, value)
			local data = HairColors[value]

			hair:SetValue(L(data[1]):utf8upper())
			hair:SetValueColor(data[2])

			self.data.hair = value
		end

		local shape = container:Add("ui.character.selector")
		shape:SetTitle(L"char_shape")
		shape.CreateMenu = function(this, menu)
			local shape_types = {"shape1", "shape2", "shape3", "shape4"}

			for z, v in ipairs(BodyShapes) do
				local sub = menu:AddSubMenu(L(shape_types[z]))

				for k, v in ipairs(v) do
					sub:AddOption(L(v), function()
						self:SetBodyShape(z, k)
					end)
				end
			end
		end

		self.SetBodyShape = function(this, category, value)
			local data = BodyShapes[category]
			local frac = 192 * (value / 4)

			shape:SetValue(L(data[value]):utf8upper())
			shape:SetValueColor(Color(63 + frac, 63 + frac, 63 + frac))

			self.data.bodyshape = {category, value}
		end
	end)

	self:CreateContainer(1, L"charcreate_gender", function(container)
		container.title:DockMargin(0, 0, 0, Scale(18))
		
		local function update_gender()
			local pronoun = container.pronoun:GetValue()

			container.result:SetValue(L(Names[pronoun][container.features:GetValue()]):utf8upper())
			container.result:SetValueColor(Pronoun[pronoun][2])

			self.data.gender = container.result:GetValue()
		end
	
		local features = container:Add("ui.character.selector")
		features:SetTitle(L"charcreate_feature")
		features:SetValue(1, "MALE")
		features.CreateMenu = function(this, menu)
			for k, v in pairs(FeatureSet[self.data.bodytype]) do
				local id = Features[v]

				menu:AddOption(L(id), function()
					self.data.features = v
					self:SetFeatureSet(v)
				end)
			end
		end

		self.SetFeatureSet = function(this, v)
			self.data.features = v

			local id = Features[v]

			features:SetValue(v, L(id):utf8upper())

			update_gender()
		end

		container.features = features

		local pronoun = container:Add("ui.character.selector")
		pronoun:SetTitle(L"charcreate_pronoun")
		pronoun:SetValue(1, "MASCULINE")
		pronoun:SetValueColor(Color(32, 225, 255))
		pronoun.CreateMenu = function(this, menu)
			for k, v in ipairs(Pronoun) do
				local id = v[1]

				menu:AddOption(L(id), function()
					self.data.pronoun = k
					self:SetPronoun(k)
				end)
			end
		end

		self.SetPronoun = function(this, v)
			self.data.pronoun = v

			local data = Pronoun[v]

			pronoun:SetValue(v, L(data[1]):utf8upper())
			pronoun:SetValueColor(data[2])

			update_gender()
		end


		container.pronoun = pronoun

		local result = container:Add("ui.character.selector")
		result:SetTitle(L"char_gender")
		result:SetCursor("arrow")
		result:SetValue("MALE")
		result:SetValueColor(Color(32, 225, 255))
		result:SetDisabled(true)

		container.result = result

		self.UpdateAvailableGenders = function(this)
			local feature = FeatureSet[self.data.bodytype][1]

			self:SetFeatureSet(feature)
			self:SetPronoun(self.data.bodytype)

			update_gender()
		end
	end)

	self:CreateContainer(2, L"charcreate_type", function(container)
		container.title:DockMargin(0, 0, 0, Scale(18))

		local panel = container:Add("EditablePanel")
		panel:Dock(TOP)
		panel:SetTall(32)
		
		local body2 = panel:Add("DButton")
		body2:Dock(RIGHT)
		body2:SetWide(32)
		body2:SetText("<FEMALE ICON>")
		body2:SizeToContents()
		body2.DoClick = function()
			self:SelectBodyType(2)
		end

		local body1 = panel:Add("DButton")
		body1:Dock(RIGHT)
		body1:SetWide(32)
		body1:SetText("<MALE ICON>")
		body1:SizeToContents()
		body1.DoClick = function()
			self:SelectBodyType(1)
		end

		self.SelectBodyType = function(this, type)
			self.data.bodytype = type

			local models = self:GetAvailableModels()
			local model = table.KeyFromValue(models, models[math.random(#models)])
			
			if self.data.bodytype == 2 then
				self.data.model = 13 +  model
			else
				self.data.model = model
			end

			self:SetModel(models[model])

			this:UpdateAvailableModels(self.data.faction, type)
			this:UpdateAvailableGenders()
		end
	end)

	self:CreateContainer(2, L"charcreate_model", function(container)
		container.title:DockMargin(0, 0, 0, Scale(18))

		local scroller = container:Add("DHorizontalScroller")
		scroller:Dock(TOP)
		scroller:SetTall(64)
		scroller:SetOverlap(-4)

		
		
		self.UpdateAvailableModels = function(this)
			scroller:Clear()

			--local faction = ix.faction.indices[payload.faction]
			--if faction then
				local models = self:GetAvailableModels()

				for k, v in SortedPairs(models) do
					local icon = scroller:Add("SpawnIcon")
					icon:SetSize(64, 64)
					icon:InvalidateLayout(true)
					icon.DoClick = function(this)
						if self.data.bodytype == 2 then
							self.data.model = 13 +  k
						else
							self.data.model = k
						end
						
						self:SetModel(v)
					end
					icon.PaintOver = function(this, w, h)
						if (self.data.model == k) then
							local color = color_white --ix.config.Get("color", color_white)

							surface.SetDrawColor(color.r, color.g, color.b, 200)

							for i = 1, 3 do
								local i2 = i * 2
								surface.DrawOutlinedRect(i, i, w - i2, h - i2)
							end
						end
					end

					if isstring(v) then
						icon:SetModel(v)
					else
						icon:SetModel(v[1], v[2] or 0, v[3])
					end

					scroller:AddPanel(icon)
				end
			--end
		end
	end)

	self:Prepare()

	local parent = self:GetParent()
	local padding = Scale(80)

	self.back = self:Add("ui.character.button")
	self.back:SetText(L"charcreate_back")
	self.back:SizeToContents()
	self.back:AlignLeft(padding)
	self.back:AlignBottom(padding)
	self.back.DoClick = function()
		parent.mainPanel:Undim()
	end

	self.proceed = self:Add("ui.character.button")
	self.proceed:SetText(L"charcreate_apply")
	self.proceed:SizeToContents()
	self.proceed:AlignRight(padding)
	self.proceed:AlignBottom(padding)
	self.proceed.DoClick = function()
		self:SendPayload()
	end

	-- setup character creation hooks
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()
			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			parent.mainPanel:Undim()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		print(fault)
		parent:ShowNotice(3, L(fault or "unknownError", unpack(args)))
	end)
end

function PANEL:Prepare()
	self:SetCharName("")
	self:SetCharDesc("")
	self.data.bodytype = math.random(1, 2)

	self:SetAge(math.random(18, 40))
	self:SetPhysHeight(math.random(150, 195))
	self:SetEyes(math.random(#EyeColors))
	self:SetHair(math.random(#HairColors))
	self:SetBodyShape(math.random(1, 4), math.random(1, 5))

	self:SelectBodyType(self.data.bodytype)

	local feature = FeatureSet[self.data.bodytype]

	self:SetFeatureSet(feature[math.random(#feature)])
	self:SetPronoun(math.random(1, 2))
end

function PANEL:SetModel(model)
	self.view:SetModel(model)
end

function PANEL:GetAvailableModels()
	--local factionData = ix.faction.indices[self.data.faction]
	--if factionData then
		return CITIZEN_MODELS[self.data.bodytype]
	--end
end

function PANEL:SendPayload()
	local payload = {
		faction = FACTION_CITIZEN,
		name = self.data.name,
		model = self.data.model,
		description = self.data.description,
		phys = {self.data.age, self.data.height, self.data.eyes, self.data.hair, self.data.bodyshape, self.data.features, self.data.pronoun, self.data.gender},
	}

	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		local value = payload[k]

		if !v.bNoDisplay or v.OnValidate then
			if v.OnValidate then
				local result = {v:OnValidate(value, payload, LocalPlayer())}

				if result[1] == false then
					self:GetParent():ShowNotice(3, L(result[2] or "unknownError", result[3]))
					return false
				end
			end

			payload[k] = value
		end
	end

	if self.awaitingResponse then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if IsValid(self) and self.awaitingResponse then
			local parent = self:GetParent()

			self.awaitingResponse = false
			
			parent.mainPanel:Undim()
			parent:ShowNotice(3, L("unknownError"))
		end
	end)
	
	net.Start("ixCharacterCreate")
		net.WriteUInt(table.Count(payload), 8)

		for k, v in pairs(payload) do
			net.WriteString(k)
			net.WriteType(v)
		end
	net.SendToServer()
end

function PANEL:CreateContainer(side, title, callback)
	local padding_x = Scale(40)
	local padding_y = #self.containers[side] < 1 and Scale(40) or Scale(25)

	local container = self:Add("EditablePanel")
	container:SetWide(self.container_width)
	container:SetTall(100)

	local text = container:Add("DLabel")
	text:SetFont("char.create.container")
	text:SetTextColor(ColorAlpha(color_white, 255 * 0.5))
	text:SetText(title or "TITLE")
	text:Dock(TOP)
	text:SizeToContents()

	container.title = text

	if callback then
		callback(container)
	end
	
	container:InvalidateLayout(true)
	container:SizeToChildren(false, true)

	self.containers[side][#self.containers[side] + 1] = container

	if side == 1 then
		container:MoveLeftOf(self.left, -container:GetWide() - padding_x)
		container:MoveBelow(self.last_left, padding_y)

		self.last_left = container
	else
		text:SetContentAlignment(9)
		container:MoveRightOf(self.right, -container:GetWide(),  padding_x)
		container:MoveBelow(self.last_right, padding_y)

		self.last_right = container
	end
end

function PANEL:OnSlideUp()
	self:Prepare()
end

function PANEL:OnSlideDown()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(30, 40, 45)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(60, 70, 75)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(0, 0, w, h / 2)

	BaseClass.Paint(self, w, h)
end

vgui.Register("ui.character.create", PANEL, "ixCharMenuPanel")
// мда пососал