extends CharacterBody3D
class_name Enemy

signal enemy_destroyed(name_of_enemy:String,pos:Vector3)
signal enemy_spawned(name_of_enemy:String,pos:Vector3)


@export var enemy_name:String="test_enemy"
@export var hp:float=10
@export var mass:float=60
@export var rotate_speed:float=3.0
@export var speed:float=3.0
@export var target_distance:float=1.0
@export var attack_distance:float=3.0
@export var ai:AI
@export var detection_radius:float=10.0
@onready var nav_agent:NavigationAgent3D=$NavigationAgent3D
@export var initial_weapon:Weapon
@export var friction := 8.0
@export var anim_player:AnimationPlayer

@export var weapon_marker:Node3D

var game:Game
var weapon:Weapon

var target:Node3D
var target_pos:Vector3
var next_point:Vector3
var is_dying:bool=false


func can_attack():
	if not weapon:
		return false
	if not weapon.can_atatck():
		return false
	return true

func attack():
	if not can_attack():
		return
	weapon.attack()
	play_animation("attack")

func init_enemy(g:Game):
	game=g
	

func _ready() -> void:
	if ai:
		ai.init_ai(self)
	var cyl:CylinderShape3D=$DetectionArea/CollisionShape3D.shape
	cyl.radius=detection_radius
	if not weapon_marker:
		weapon_marker=$WeaponMarker
	if initial_weapon:
		set_weapon(initial_weapon)
	enemy_spawned.emit(enemy_name,global_position)
	

func set_weapon(w:Weapon):
	if weapon:
		weapon.queue_free()
	weapon=w
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	weapon_marker.add_child(weapon)
	weapon.position=Vector3.ZERO	

func is_target_reached() -> bool:
	if nav_agent.is_navigation_finished():
		return true
	return false

		
func set_target_point(point: Vector3):
	target_pos=point
	nav_agent.target_position = point
	

func rotate_to_point(point: Vector3, delta: float):
	var dir = point - global_position
	dir.y = 0

	#if dir.length_squared() < 0.001:
	#	return

	var target_angle = atan2(dir.x, dir.z)+PI
	#print("DEBUG: target angle ", target_angle," rotation.y ",rotation.y )
	rotation.y = lerp_angle(
		rotation.y,
		target_angle,
		rotate_speed * delta
	)


func get_next_point():
	return nav_agent.get_next_path_position()
	
func move_to_target(delta: float):
	if nav_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return

	var old_point:Vector3=next_point
	next_point = get_next_point()
	

	
	

	#rotate_to_point(next_point, delta)

	var dir = next_point - global_position
	dir.y = 0
	if dir.length_squared() < 0.001:
		velocity = Vector3.ZERO
		return
	dir = dir.normalized()

	#velocity.x = dir.x * speed
	#velocity.z = dir.z * speed
	velocity.x = move_toward(velocity.x, dir.x * speed, 2.0*friction * delta)
	velocity.z = move_toward(velocity.z, dir.z * speed, 2.0*friction * delta)
	if velocity.x or velocity.z:
		play_animation("walk")

func _physics_process(delta: float) -> void:
	if ai and not is_dying:
		ai.update(delta)
	if is_dying:
		process_dying(delta)
	
	if not is_on_floor() :
		velocity.y += get_gravity().y * delta
		
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	velocity.z = move_toward(velocity.z, 0, friction * delta)
	move_and_slide()

func check_target(body:Node3D) -> bool:
	if body is Player:
		return true
	return false

func set_target(body:Node3D):
	target=body
	target_pos=body.global_position
	set_target_point(target_pos)

func clear_target():
	target=null
	target_pos=Vector3.ZERO


func _on_detection_area_body_entered(body: Node3D) -> void:
	if check_target(body):
		set_target(body)
		
	pass # Replace with function body.


func _on_detection_area_body_exited(body: Node3D) -> void:
	if body==target:
		clear_target()
	pass # Replace with function body.

func take_damage(damage:float,damage_type:String):
	hp-=damage
	print("DEBUG: taking damage ",damage," hp remaining ",hp)
	if hp<=0:
		die()
	pass
	
func take_hit(damage:float,damage_type:String,force:float,pos:Vector3,dir:Vector3):
	take_damage(damage,damage_type)
	#var dir:Vector3=global_position.direction_to(pos).normalized()
	velocity.x+=dir.x*force/mass
	velocity.z+=dir.z*force/mass
	
	pass
	
func process_dying(delta:float):
	if anim_player:
		if anim_player.is_playing():
			if anim_player.current_animation=="dying":
				return
	destroy()

func destroy():
	enemy_destroyed.emit(enemy_name,global_position)
	queue_free()
		
func die():
	is_dying=true
	play_animation("dying")
	
func play_animation(anim_name:String):
	if not anim_player:
		return
	if anim_player.is_playing():
		if anim_player.current_animation==anim_name:
			return
	if not anim_player.has_animation(anim_name):
		return
	anim_player.play(anim_name)		
	pass
