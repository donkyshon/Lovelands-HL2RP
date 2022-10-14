local PANEL = {}
function PANEL:Init()
	if IsValid(ix.gui.intro) then
		ix.gui.intro:Remove()
	end

	ix.gui.intro = self

	self:SetSize(ScrW(), ScrH())
	self:SetZPos(9999)

	self:MakePopup()
end

function PANEL:addContinue()
	if IsValid(ix.gui.characterMenu) then
		ix.gui.characterMenu:PlayMusic()
	end

	self.info = self:Add("DLabel")
	self.info:Dock(BOTTOM)
	self.info:SetTall(36)
	self.info:DockMargin(0, 0, 0, 32)
	self.info:SetText("PRESS [SPACE] TO CONTINUE...")
	self.info:SetFont("ixIntroSmallFont")
	self.info:SetContentAlignment(2)
	self.info:SetAlpha(0)
	self.info:AlphaTo(255, 1, 0, function()
		self.info.Paint = function(this)
			this:SetAlpha(math.abs(math.cos(RealTime() * 0.8) * 255))
		end
	end)
	self.info:SetExpensiveShadow(1, color_black)
end

function PANEL:Think()
	if IsValid(LocalPlayer()) and !self.beginIntro then
		self.beginIntro = true

		local bLoaded = false

		if ix and ix.option and ix.option.Set then
			bLoaded = true
		end

		if !bLoaded then
			self:Remove()

			if (ix and ix.gui and IsValid(ix.gui.characterMenu)) then
				ix.gui.characterMenu:Remove()
			end

			ErrorNoHalt(
				"[Helix] Something has errored and prevented the framework from loading correctly - check your console for errors!\n")

			return
		end

		self:MoveToFront()
		self:RequestFocus()

		self:addContinue()
	end

	if IsValid(self.info) and input.IsKeyDown(KEY_SPACE) and !self.closing then
		self.closing = true
		self:AlphaTo(0, 2.5, 0, function()
			self:Remove()
		end)
	end
end

function PANEL:OnRemove()
	if self.sound then
		self.sound:Stop()
		self.sound = nil
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("ixIntro", PANEL, "EditablePanel")
