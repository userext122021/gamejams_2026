extends Control
class_name UIComponent

var player:BasePlayer
var stats:StatsComponent

func init_component(player_body:BasePlayer):
	player=player_body
	if player.stats_component:
		stats=player.stats_component


func update(delta:float):
	pass
