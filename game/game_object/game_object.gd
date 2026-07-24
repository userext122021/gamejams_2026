extends Node3D
class_name GameObject

signal item_taken(item:GameObject)

@export var object_name:String
@export var object_type:String
@export var object_size:Vector3=Vector3.ONE

@export var drop_ray:RayCast3D

@export var is_interactive:bool=false
@export var is_pickable:bool=false
@export var hover_text:String

var is_taken:bool


func disable_object():
	process_mode=Node.PROCESS_MODE_DISABLED
func enable_object():
	process_mode=Node.PROCESS_MODE_INHERIT
	
func interact(player:Player):
	pass
	
func take():
	item_taken.emit(self)
	is_taken=true
	
func drop():
	if drop_ray:
		disable_object()
		drop_ray.collide_with_areas=true
		if drop_ray.is_colliding():
			var point:Vector3=drop_ray.get_collision_point()
			print(point)
			global_position=point
			rotation=Vector3.ZERO
		enable_object()
	is_taken=false
	
func get_hover_text(player:Player) -> String:
	if is_pickable and is_interactive:
		return "E  - pick up "+object_name
	return hover_text
