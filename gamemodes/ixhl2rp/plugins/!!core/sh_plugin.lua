PLUGIN.name = "Core Modifications"
PLUGIN.description = ""
PLUGIN.author = ""

ix.currency.symbol = ""
ix.currency.singular = "token"
ix.currency.plural = "tokens"

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("meta/sh_item.lua")

if CLIENT then
	language.Add("game_player_joined_game", "")
	language.Add("game_player_left_game", "")
end
