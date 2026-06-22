extends Interactable
class_name Box

@export var item_scene:PackedScene
var is_opened:bool=false
var is_empty:bool

func _ready() -> void:
	if not item_scene:
		is_empty=true
	pass

func _process(delta: float) -> void:
	if is_empty:
		return
	if is_opened:
		if anim_player:
			if anim_player.is_playing():
				return
		$CollisionShape3D.disabled=true
		
		if item_scene:
			var item:Node3D=item_scene.instantiate()
			get_parent().add_child(item)
			item.global_position=$Marker3D.global_position
		is_empty=true

func on_interact(p:Player):
	is_opened=true
	pass
