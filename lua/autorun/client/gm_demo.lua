
concommand.Add( "gm_demo", function( ply, cmd, arg )

	if ( engine.IsRecordingDemo() ) then
		RunConsoleCommand( "stop" )
		return
	end

	local dynamic_name = game.GetMap() .." ".. util.DateStamp()

	RunConsoleCommand( "record", "demos/" .. dynamic_name .. ".dem" )
	RunConsoleCommand( "record_screenshot", dynamic_name )

end )

local matRecording = nil
local drawicon = CreateClientConVar( "gm_demo_icon", 1, true )
hook.Add( "HUDPaint", "DrawRecordingIcon", function()

	if ( !engine.IsRecordingDemo() || !drawicon:GetBool() ) then return end

	if ( !matRecording ) then
		matRecording = Material( "gmod/recording.png" )
	end

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( matRecording )
	surface.DrawTexturedRect( ScrW() - 512, 0, 512, 256, 0 )

end )





Launcher = Launcher or {}
Launcher.discordTime = Launcher.discordTime or -1
Launcher.status = Launcher.status or false

local data = {}

function DiscordUpdate()
	data.details = ""
	data.state = "Playing"
	data.partySize = player.GetCount()
	data.partyMax = game.MaxPlayers()
	data.largeImageKey = "main"
	data.largeImageText = game.GetMap()
	data.startTimestamp = Launcher.discordTime

	if !game.SinglePlayer() then
		local ip = game.GetIPAddress()

		if ip != "loopback" then
			data.btn1 = true
			data.btn1Label = "Join Server"
			data.btn1Url = "steam://connect/"..ip
		end
	else
		data.partyMax = 0
	end
	
	DiscordUpdateRPC(data)

	SetSteamPresence("В игре")
end

if Launcher.status then
	return
end

if !file.Find("lua/bin/gmcl_lovelands_*.dll", "GAME")[1] then 
	return 
end

timer.Simple(0, function()
	local result, b = pcall(require, "lovelands")

	Launcher.status = result

	if result then
		Launcher.discordTime = os.time()

		DiscordRPCInitialize("995630707365904434")

		DiscordUpdate()
		
		timer.Create("rp.discord.rpc", 30, 0, function()
			DiscordUpdate()
		end)

		timer.Simple(5, DiscordRPCRunCallbacks)
	end
end)


