
local PLUGIN = PLUGIN

PLUGIN.name = "Better Local Event"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds a better /localevent command for events in a specfic radius."
PLUGIN.license = [[
Copyright 2020 wowm0d
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ix.lang.AddTable("english", {
	cmdLocalEvent = "Make something perform an action that can be seen at a specified radius."
})
ix.lang.AddTable("russian", {
	cmdLocalEvent = "Выполнить действие, которое увидят на определенном расстоянии."
})

if (CLIENT) then
	function PLUGIN:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
		if (bDrawingDepth or bDrawingSkybox) then
			return
		end

		if (ix.chat.currentCommand == "localevent") then
			local arguments = ix.chat.currentArguments
			local chatRange = ix.config.Get("chatRange", 280)
			local range = -math.Clamp(tonumber(arguments[2]) or chatRange * 4, 30, chatRange * 8)
			local position = LocalPlayer():GetPos()
			local color = ColorAlpha(ix.config.Get("color"), 100)

			render.SetColorMaterial()
			render.DrawSphere(position, range, 30, 30, color)
		end
	end
end

do
	ix.command.Add("LocalEvent", {
		description = "@cmdLocalEvent",
		arguments = {
			ix.type.string,
			bit.bor(ix.type.number, ix.type.optional)
		},
		adminOnly = true,
		OnRun = function(self, client, text, radius)
			local chatRange = ix.config.Get("chatRange", 280)

			radius = math.Clamp(radius or chatRange * 4, 30, chatRange * 8)
			radius = radius * radius

			ix.chat.Send(client, "localevent", text, false, nil, {range = radius})
		end
	})

	local CLASS = {}
	CLASS.deadCanChat = true
	CLASS.indicator = "chatPerforming"
	CLASS.color = Color(255, 150, 0)

	function CLASS:CanHear(speaker, listener, data)
		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= data.range
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, text)
	end

	ix.chat.Register("localevent", CLASS)
end
