extends BaseEntity

@export var player:BasePlayer


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if player.global_position.distance_to(navigation_component.target_point)>1.0:
		navigation_component.set_target_point(player.global_position)
	
