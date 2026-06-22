extends Node3D
class_name Weapon

@export var attack_time:float=0.2
@export var is_range_weapon:bool=true
@export_group("Mellee weapon")
@export var range:float=2.0
@export var damage:float=1.0
@export var damage_type:String="physical"
@export var force:float

@export var bullet_scene:PackedScene
@export var prepare_time:float=0.0
@export var cooldown_time:float=0.0

var is_attacking:bool
var timer:float=0
var has_hit:bool=false

func _ready() -> void:
	if not is_range_weapon:
		$RayCast3D.target_position.z=-range

func can_atatck() -> bool:
	if is_attacking:
		return false
	return true
		
func attack():
	if is_attacking:
		return
	is_attacking=true
	timer=0
	if is_range_weapon:
		shoot()
	has_hit=false
	
func shoot():
	if not bullet_scene:
		return
	var bullet:Bullet=bullet_scene.instantiate()
	add_child(bullet)
	bullet.position=$BulletMarker.position
	bullet.rotation=rotation
	bullet.top_level=true
	

func stop_attack():
	is_attacking=false
	
func can_hit() -> bool:
	if not is_attacking:
		return false
	if has_hit:
		return false
	if timer<prepare_time:
		return false
	if timer>cooldown_time:
		return false
	return true

func is_cooldown() -> bool:
	if is_range_weapon:
		return false
	if timer>cooldown_time:
		return true
	return false
	
func hit():
	if not $RayCast3D.is_colliding():
		return
	var target:Node3D=$RayCast3D.get_collider()
	if target.has_method("take_hit"):
		target.take_hit(damage,damage_type,force,global_position,-global_basis.z)
		has_hit=true
		
func _process(delta: float) -> void:
	if not is_attacking:
		return
	timer+=delta

	if not is_range_weapon:
		if can_hit():
			hit()
			
	if timer>=attack_time:
		stop_attack()
		return
