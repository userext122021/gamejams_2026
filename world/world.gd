extends Node3D
class_name World

var game:Game
var player:Player

func init_world(g:Game):
	print("DEBUG: world init")
	game=g
	
