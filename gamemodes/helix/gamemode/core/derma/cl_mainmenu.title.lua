local scale = ix.UI.Scale

surface.CreateFont("cellar.main.warn", {
	font = "Blender Pro Medium",
	extended = true,
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

local tex = GetRenderTargetEx("ui_mainmenu_glow_rt", ScrW(), ScrH(), RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
local rt_mat = CreateMaterial("ui_mainmenu_glow","UnlitGeneric",{
	["$basetexture"] = "ui_mainmenu_glow_rt",
	["$translucent"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$additive"] = 1,
})
rt_mat:Recompute()

local PANEL = {}
PANEL.css = [[
#logo-container {
	position: absolute;
	width: auto;
	height: auto;
	display: flex;
	flex-flow: row wrap;
	align-items: stretch;
	top: 4.916rem;
	left: 4.916rem;
	animation: logo-opacity 0.5s ease forwards;
}
#logo-name-container {
	padding-left: 2.3rem;
	display: flex;
	flex-flow: column nowrap;
	justify-content: center;
}
#logo-img {
	display: inline-block;
	height: 8.916rem;
}
#logo-name {
	color: #38cff8;
	font-family: Move-X;
	font-weight: bold;
	font-size: min(4.791vw, 3.83rem);
	text-shadow: 0 0 0.025em #38cff8,
		0 0 0.1em rgba(0, 0, 255, 0.5),
		0 0 0.5em rgba(0, 0, 255, 0.5);
}
#logo-desc {
	color: #f83838;
	font-family: Move-X;
	font-style: italic;
	font-size: min(1.5625vw, 1.25rem);
	white-space: pre;
}
@keyframes logo-opacity {
	0% {
		transform: translateX(-2%);
	}
	100% {
		transform: translateX(0px);
	}
}

.hint-container {
	position: absolute;
	font-family: "Blender Pro Medium";
	width: 50%;
	height: auto;
	right: 7.5%;
	bottom: 7.5%;
	color: #a6eada;
	opacity: 0;
	font-size: 1.05rem;
}
.hint-anim-down {
	animation-name: fx-opacity-down;
}
.hint-anim-right {
	animation-name: fx-opacity-right;
}
.hint-fx-container {
	position: relative;
}
.hint-footer {
	position: relative;
}
.hint-footer.news {
	font-size: 1rem;
}
.hint-content {
	margin-top: -0.1rem;
	padding-left: 2.17rem;
	position: relative;
}
.hint-textbox {
	font-family: "Blender Pro";
	font-size: 0.675rem;
	font-weight: 500;
	padding: 0.75rem;
	background: linear-gradient(90deg, rgba(166,234,218,0.1) 0%, rgba(0,0,0,0) 100%);
}
.hint-textbox.news {
	font-size: 0.65rem;
	font-weight: 500;
	color: rgba(166,234,218, 0.75);
	background: rgba(166,234,218,0.1);
}
.hint-textbox.news strong {
	font-size: 0.75rem;
	font-weight: 500;
	color: #a6eada;
}
.hint-textbox.news ul {
	margin-top: 0.1rem;
	margin-bottom: 0.5rem;
	padding-left: 1rem;
}
.hint-content:before, .hint-content:after {
    content: "";
    position: absolute;
    height: 100%;
    width: 0.1rem;
    top: 0px;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 1 1'%3E%3Cpath fill-rule='evenodd' fill='rgb(166,234,218)' d='M0.0,0.0 L1.0,0.0 L1.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3C/svg%3E"), url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 1 1'%3E%3Cpath fill-rule='evenodd' fill='rgb(166,234,218)' d='M0.0,0.0 L1.0,0.0 L1.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3C/svg%3E");
    background-size: 0.1rem 0.1rem;
    background-position: top right, bottom right;
    background-repeat: no-repeat;
}
.hint-content:before {
    left: 2.17rem;
}
.hint-content:after {
    right: 0px;
}
span.hint-footer {
	display: inline-block;
	line-height: 2.17rem;
	width: 100%;
	padding-left: calc(2.17rem + 0.68rem);
}
span.hint-footer:before {
	content: "";
	background-image: url("asset://garrysmod/materials/ui/hint-ico.png");
	background-size: 2rem 2rem;
	width: 2rem;
	height: 2rem;
	position: absolute;
	left: 0;
}
span.hint-footer.news:before {
	background-image: none;
}
.hint-fx-top {
	position: absolute;
	border-bottom: 0.1rem solid rgba(166,234,218, 0.25);
	top: 0px;
	left: 0px;
	bottom: 0px;
	right: 0px;
	width: 0%;
	animation-name: fx-top;
}
@keyframes fx-top {
	2.5% {
		width: 0%;
	}
	7.5% {
		width: calc(100% + 0.34rem);
	}
	100% {
		width: calc(100% + 0.34rem);
	}
}
.hint-fx-left {
	position: absolute;
	border-right: 0.1rem solid rgba(166,234,218, 0.25);
	top: 0px;
	left: 0px;
	bottom: 0px;
	width: 2.17rem;
	height: 0%;
	animation-name: fx-left;
}
@keyframes fx-left {
	2.5% {
		height: 0%;
	}
	7.5% {
		height: calc(100% + 0.34rem);
	}
	100% {
		height: calc(100% + 0.34rem);
	}
}
.hint-fx-bottom {
	position: absolute;
	border-bottom: 0.1rem solid rgba(166,234,218, 0.25);
	top: 0px;
	left: calc(2.17rem - 0.34rem);
	bottom: 0px;
	width: 0%;
	animation-name: fx-bottom;
}
@keyframes fx-bottom {
	7.5% {
		width: 0%;
	}
	14% {
		width: calc(100% - calc(2.17rem - 0.34rem) + 0.34rem);
	}
	100% {
		width: calc(100% - calc(2.17rem - 0.34rem) + 0.34rem);
	}
}
.hint-fx-right {
	position: absolute;
	border-right: 0.1rem solid rgba(166,234,218, 0.25);
	top: -0.34rem;
	right: 0px;
	height: 0%;
	animation-name: fx-right;
}
@keyframes fx-right {
	7.5% {
		height: 0%;
	}
	14% {
		height: calc(100% + 0.68rem);
	}
	100% {
		height: calc(100% + 0.68rem);
	}
}
@keyframes fx-opacity-down {
	0% {
		opacity: 0;
		transform: translateY(50%);
	}
	5% {
		opacity: 1;
		transform: translateY(0px);
	}
	100% {
		opacity: 1;
	}
}
@keyframes fx-opacity-right {
	0% {
		opacity: 0;
		transform: translateX(50%);
	}
	5% {
		opacity: 1;
		transform: translateX(0px);
	}
	100% {
		opacity: 1;
	}
}
.hint-fx {  
	animation-duration: 15s;
	animation-timing-function: ease;
	animation-fill-mode: forwards;
}

html, body {
	height: 100%;
	padding: 0;
	margin: 0;
	font-size: 2.22vh;
	overflow: hidden;
	user-select: none;
	opacity: 0;
	animation: all-opacity 10s ease forwards;
}
@keyframes all-opacity {
	0% {
		opacity: 0;
	}
	3% {
		opacity: 0.3;
	}
	4% {
		opacity: 0.7;
	}
	5% {
		opacity: 0.4;
	}
	9% {
		opacity: 1;
	}
	100% {
		opacity: 1;
	}
}
#fx-border {
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1876.5px' height='1003.5px'%3E%3Cpath fill-rule='evenodd' stroke='rgb(69, 82, 82)' stroke-width='3px' stroke-linecap='butt' stroke-linejoin='miter' opacity='1' fill='none' d='M1873.499,889.499 L1855.499,889.499 L1746.500,998.500 L865.499,998.500 L850.500,983.500 L36.500,983.500 L3.500,950.500 L3.500,84.500 L84.499,3.499 L1213.500,3.499 L1236.499,26.499 L1873.499,26.499 '/%3E%3C/svg%3E");
	background-size: 100% 92.91%;
	background-repeat: no-repeat;
	background-position: center;
	position: absolute;
	width: 97.734375%;
	height: 100%;
	right: -1px;
}
div.main-btn {
	background-color: rgba(19, 19, 19, 0.25);
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='285px' height='40px'%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='rgb(82, 82, 82)' d='M0.0,38.999 L285.0,38.999 L285.0,40.0 L0.0,40.0 L0.0,38.999 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='rgb(82, 82, 82)' d='M0.0,0.0 L285.0,0.0 L285.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='rgb(82, 82, 82)' d='M283.999,0.0 L285.0,0.0 L285.0,39.999 L283.999,39.999 L283.999,0.0 Z'/%3E%3C/svg%3E");
	background-size: 100% 100%;
	background-repeat: no-repeat;
	margin-left: 0%;
	animation: moveToRight 0.5s ease-in-out;
	animation-fill-mode: forwards;
	opacity: 0;
	position: relative;
	display: flex;
	flex-flow: row nowrap;
	align-items: center;
	justify-content: left;
	width: 11.875rem;
	height: 1.67rem;
	margin-top: 0.1rem;
	transition: background-image 100ms, background-color 100ms ease-in-out;
}
div.main-btn:nth-child(1) {
	animation-delay: 300ms;
}
div.main-btn:nth-child(2) {
	animation-delay: 200ms;
}
div.main-btn:nth-child(3) {
	animation-delay: 100ms;
}
div.main-btn:nth-child(4) {
	animation-delay: 0ms;
	background-color: rgba(19, 0, 19, 0.25);
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='285px' height='40px'%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23800027' d='M0.0,38.999 L285.0,38.999 L285.0,40.0 L0.0,40.0 L0.0,38.999 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23800027' d='M0.0,0.0 L285.0,0.0 L285.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23800027' d='M283.999,0.0 L285.0,0.0 L285.0,39.999 L283.999,39.999 L283.999,0.0 Z'/%3E%3C/svg%3E");
}
div.main-btn:hover {
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='285px' height='40px'%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23a6eada' d='M0.0,38.999 L285.0,38.999 L285.0,40.0 L0.0,40.0 L0.0,38.999 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23a6eada' d='M0.0,0.0 L285.0,0.0 L285.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23a6eada' d='M283.999,0.0 L285.0,0.0 L285.0,39.999 L283.999,39.999 L283.999,0.0 Z'/%3E%3C/svg%3E");
	background-color: rgba(166, 234, 218, 0.25);
}
div.main-btn:nth-child(4):hover {
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='285px' height='40px'%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23f20049' d='M0.0,38.999 L285.0,38.999 L285.0,40.0 L0.0,40.0 L0.0,38.999 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23f20049' d='M0.0,0.0 L285.0,0.0 L285.0,1.0 L0.0,1.0 L0.0,0.0 Z'/%3E%3Cpath fill-rule='evenodd' opacity='0.502' fill='%23f20049' d='M283.999,0.0 L285.0,0.0 L285.0,39.999 L283.999,39.999 L283.999,0.0 Z'/%3E%3C/svg%3E");
	background-color: rgba(242, 0, 73, 0.25);
}
div.main-btn:hover .main-btn-ico {
	background-color: #a6eada;
}
div.main-btn:hover a.main-btn {
	color: #a6eada;
	text-shadow: 0 0 0.1rem #a6eada,
		0 0 0.25rem #a6eada;
}
div.main-btn:nth-child(4) .main-btn-ico {
	background-color: #800027;
}
div.main-btn:nth-child(4) a.main-btn {
	color: #800027;
	text-shadow: 0 0 0.1rem #800027,
		0 0 0.25rem #800027;
}
div.main-btn:nth-child(4):hover .main-btn-ico {
	background-color: #f20049;
}
div.main-btn:nth-child(4):hover a.main-btn {
	color: #f20049;
	text-shadow: 0 0 0.1rem #f00,
		0 0 0.25rem #f00;
}
div.main-btn:last-of-type {
  margin-top: auto;
}
.main-btn-ico {
	background-color: #7fa299;
	width: 1.34rem;
	height: 100%;
	transition: background-color 100ms ease-in-out;
}
div.main-btn2 {
	display: inline-block;
	padding-left: 0.4rem;
}
a.main-btn {
	position: absolute;
	width: calc(100% - 1.74rem);
	height: 1.67rem;
	line-height: 1.67rem;
	padding-left: 1.74rem;
	color: #7fa299;
	font-family: "Blender Pro";
	transition: color 100ms, text-shadow 100ms ease-in-out;
}
a.main-btn:after {

}
a:link, a:visited, a:hover, a:active {
	text-decoration: none;
}
#test2 {
	position: absolute;
	top: 55.7vh;
	bottom: 8.79vh;
	width: 11.2vh;
	display: flex;
	flex-flow: column wrap;
	justify-content: flex-start;
}
@keyframes moveToRight {
	0% {
		margin-left: 0%;
		opacity: 0;
	}
	100% {
		margin-left: 100%;
		opacity: 1;
	}
}
.warning {
	font-family: "Blender Pro";
	font-weight: 600;
	font-size: 0.7rem;
	color: #78E837;
	display: flex;
	align-items: center;
	position: absolute;
	top: 50vh;
	left: 11.2vh;
	animation: warning 1.25s ease-in-out infinite;
	text-shadow: 0 0 0.75em rgba(0, 255, 0, 0.75);
}
@keyframes warning {
	0% {
		opacity: 1;
	}
	50% {
		opacity: 0.75;
	}
	100% {
		opacity: 1;
	}
}
.credits {
	font-family: "Blender Pro";
	font-weight: 100;
	font-size: 0.75rem;
	color: rgba(100, 200, 200, 0.25);
	display: flex;
	align-items: center;
	justify-content: center;
	position: absolute;
	bottom: 0;
	height: 2.5rem;
	padding-bottom: 0.25rem;
	width: 45%;
	letter-spacing: 0.05rem
}
]]
PANEL.html = [[
<div id="fx-border"></div>
<div class="credits">LOVE RP SEASON 5: СЕРВЕР ТЕСТИРОВАНИЯ СПЕЦИАЛЬНОГО НАЗНАЧЕНИЯ</div>

<div class="hint-container hint-fx hint-anim-right" style="top: 25%; right: 1%; width: 27.5%;">
	<div class="hint-fx-container">
		<div class="hint-footer ">
			<span class="hint-footer news">СЕЗОН 5</span>
			<div class="hint-fx-top hint-fx"></div>
		</div>
		<div class="hint-content">
			<div class="hint-textbox news">
<strong>АНОНИМНОСТЬ ВЕРСИИ 5:</strong>
<ul style="list-style: none;">
	<li>— Доступна игра в несколько окон через ярлык '-multirun'.</li>
	<li>— Установка модуля позволяет полностью скрыться из истории Steam и списка игроков оверлея.</li>
</ul>
<strong>ЛИЧНАЯ СРЕДА ИГРЫ:</strong>
<ul style="list-style: none;">
	<li>— Мы тестируем систему фазирования и теперь игрокам стала доступна возможность получить личные апартаменты, которые они сами смогут обустроить. Технически игроки находятся в одной комнате но разделены между собой: вы можете одновременно взаимодействовать лишь с гостями своей комнаты, другие вас не услышат и не увидят.</li>
</ul>
			</div>
			<div class="hint-fx-bottom hint-fx"></div>
			<div class="hint-fx-right hint-fx"></div>
		</div>
		<div class="hint-fx-left hint-fx"></div>
	</div>
</div>
<div class="warning">Защищено системой анонимности версии 5. Для полного режима требуется установить модуль.</div>
<div id="test2">
	<div class="main-btn">
		<div class="main-btn-ico" src="#" alt=""></div>
		<a class="main-btn" href="#" onclick="menu.Button(1);" onmouseover="menu.Hover()">НОВОЕ ПРИБЫТИЕ</a>
	</div>
	<div class="main-btn">
		<div class="main-btn-ico" src="#" alt=""></div>
		<a class="main-btn" href="#" onclick="menu.Button(2);" onmouseover="menu.Hover()">ПЕРСОНАЖИ</a>
	</div>
	<div class="main-btn">
		<div class="main-btn-ico" src="#" alt=""></div>
		<a class="main-btn" href="#" onclick="menu.Button(3);" onmouseover="menu.Hover()">КОНТЕНТ</a>
	</div>
	<div class="main-btn" id="exit">
		<div class="main-btn-ico" src="#" alt=""></div>
		<a class="main-btn" href="#" onclick="menu.Button(5);" onmouseover="menu.Hover()">ВЫХОД</a>
	</div>
</div>]]
PANEL.java = [[
const restart_anim = ($el) => {
	$el.getAnimations().forEach((anim) => {
		anim.cancel();
		anim.play();
	});
};


function reload_animations() {
	restart_anim(document.documentElement);

	document.querySelectorAll('div.main-btn').forEach((el) => {
		restart_anim(el);
	});

	document.querySelectorAll('.hint-fx').forEach((el) => {
		restart_anim(el);
	});
};
]]

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:SetAlpha(255)
	self:SetAllowLua(true)
	self:SetHTML([[<html>
		<body oncontextmenu="return false">
			<style>
				@font-face {
					font-family: BlenderProBook; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-Book.ttf");
				}
				@font-face {
					font-family: BlenderProBook; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-BookItalic.ttf");
					font-style: italic;
				}
				@font-face {
					font-family: BlenderProBold; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-Bold.ttf");
				}
				@font-face {
					font-family: BlenderProBold; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-BoldItalic.ttf");
					font-style: italic;
				}
				@font-face {
					font-family: BlenderProMedium; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-Medium.ttf");
				}
				@font-face {
					font-family: BlenderProMedium; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-MediumItalic.ttf");
					font-style: italic;
				}
				@font-face {
					font-family: BlenderProThin; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-Thin.ttf");
				}
				@font-face {
					font-family: BlenderProThin; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-ThinItalic.ttf");
					font-style: italic;
				}
				@font-face {
					font-family: BlenderProHeavy; 
					src: url("asset://garrysmod/resource/fonts/BlenderPro-Heavy.ttf");
				}

			]]..self.css..[[</style>]]..self.html..[[<script>]]..self.java..[[</script>
		</body>
	</html>]])

	self:AddFunction("menu", "Button", function(id)
		self:MenuClick(tonumber(id))

		LocalPlayer():EmitSound("Helix.Press")
	end)

	self:AddFunction("menu", "Hover", function()
		LocalPlayer():EmitSound("Helix.Rollover")
	end)
end

function PANEL:MenuClick(id)
	local parent = self:GetParent()

	parent:MenuClick(id, self)
end

function PANEL:Show()
	local function render_glow()
		render.PushRenderTarget(tex)
			render.Clear(0, 0, 0, 150)
		
			cam.Start2D()
				if IsValid(self) then
					self.paint_manual = true
					--self:SetPaintedManually(true)
					self:PaintManual()
					--self:SetPaintedManually(false)
					self.paint_manual = false
				end
			cam.End2D()
			render.BlurRenderTarget(tex, 8, 2, 10)
		render.PopRenderTarget()
	end

	hook.Add("HUDPaint", "ui.mainmenu.glow", render_glow)

	ix.UI:Scanline(true)

	self:QueueJavascript("reload_animations();")
end

function PANEL:Paint(w, h)
	if !self.paint_manual then
		surface.SetMaterial(rt_mat)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

vgui.Register("ui.mainmenu", PANEL, "DHTML")