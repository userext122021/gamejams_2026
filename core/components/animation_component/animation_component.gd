extends Node
class_name AnimationComponent

@export var animation_player:AnimationPlayer

var body:BaseEntity

func init_component(entity:BaseEntity):
	body=entity


func update(delta:float):
	pass

func play_animation(animation_name:String):
	if animation_player:
		if animation_player.has_animation(animation_name):
			animation_player.play(animation_name)
