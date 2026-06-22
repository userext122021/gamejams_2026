extends StaticBody3D
class_name Interactable

signal interacted(p:Player)


@export var hover_text:String="E - interact"
@export var anim_player:AnimationPlayer

func _ready() -> void:
	pass

func on_interact(p:Player):
	pass
	
func interact(p:Player):
	print("DEBUG: interact")
	interacted.emit(p)
	on_interact(p)
	if anim_player:
		if anim_player.has_animation("interact"):
			anim_player.play("interact")
