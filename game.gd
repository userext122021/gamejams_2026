extends Node
class_name Game

@export var player:Player
@export var world:World
@onready var ui:UI=$UI

func _ready() -> void:
	world.init_world(self)
	player.init_player(self)
	pause_game()
	

func pause_game():
	world.process_mode=Node.PROCESS_MODE_DISABLED
	player.process_mode=Node.PROCESS_MODE_DISABLED
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE

func start_game():
	world.process_mode=Node.PROCESS_MODE_INHERIT
	player.process_mode=Node.PROCESS_MODE_INHERIT
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func exit():
	get_tree().quit()


func _on_start_button_pressed() -> void:
	$Menu.hide()
	start_game()
	pass # Replace with function body.
