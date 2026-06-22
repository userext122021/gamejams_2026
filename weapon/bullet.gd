extends Node3D
class_name Bullet

@export var speed:float=50.0
@export var damage:float=1.0
@export var force=100.0
@export var damage_type:String="physical"
@export var max_distance:float=40

var distance:float

func destroy():
	queue_free()

func hit(body:Node3D):
	if body.has_method("take_hit"):
		body.take_hit(damage,damage_type,force,global_position,-global_basis.z)
	destroy()
		
func _on_area_body_entered(body: Node3D) -> void:
	hit(body)
	pass # Replace with function body.

func _process(delta: float) -> void:
	global_position += -global_basis.z * speed * delta

	distance+=speed*delta
	if distance>max_distance:
		destroy()
