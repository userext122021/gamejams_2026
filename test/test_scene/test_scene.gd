extends Node3D


func _on_base_player_object_dropped(object: GameObject,position:Vector3) -> void:
	add_child(object)
	object.global_position=position
	object.global_position.y=0
	pass # Replace with function body.




func _on_base_player_interaction_started(object: GameObject) -> void:
	print("DEBUG: player started to interact with object: ",object.object_name)
	pass # Replace with function body.
