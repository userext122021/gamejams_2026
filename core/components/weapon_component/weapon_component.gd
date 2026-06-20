extends Node3D
class_name  WeaponComponent

enum WeaponState {NONE,PREPARING,ATTACKING,COOLDOWN}

@export var weapon_marker:Node3D
@export var initial_weapon_item:ItemData
@onready var ray:RayCast3D=$RayCast3D

@export var damage:float=1.0
@export var damage_type:String="physical"

@export var preparing_time:float=0.0
@export var attacking_time:float=0.5
@export var cooldown_time:float=0.0


var state:WeaponState=WeaponState.NONE

var has_hit:bool=false
 
var body:BaseEntity
var item_data:ItemData
var weapon_data:WeaponData
var model:Node3D
var animation_player:AnimationPlayer
var timer:float

func init_component(entity:BaseEntity):
	body=entity
	if initial_weapon_item:
		set_weapon_by_item_data(initial_weapon_item)


func update(delta:float):
	if state==WeaponState.NONE:
		return
	timer+=delta
	if timer>preparing_time and timer<(preparing_time+attacking_time):
		state=WeaponState.ATTACKING
	elif timer>(preparing_time+attacking_time):
		state=WeaponState.COOLDOWN
	if state==WeaponState.ATTACKING:
		if ray.is_colliding() and not has_hit:
			var enemy:Node3D=ray.get_collider()
			hit(enemy)
	if timer>(preparing_time+attacking_time+cooldown_time):
		state=WeaponState.NONE
	pass

func hit(enemy:Node3D):
	#if not enemy.has_method("take_hit"):
	#	return
	#enemy.take_hit(damage,damage_type)
	#has_hit=true
	if not enemy.has_node("DamageComponent"):
		return
	var dc:BaseDamageComponent=enemy.get_node("DamageComponent")
	dc.take_damage(damage,damage_type)
	has_hit=true

func attack():
	if not state==WeaponState.NONE:
		return
	#if animation_player:
	#	if animation_player.has_animation("attack"):
	#		animation_player.play("attack")
	state=WeaponState.PREPARING
	timer=0
	has_hit=false
	pass

func load_weapon_data(data:WeaponData):
	preparing_time=data.preparing_time
	attacking_time=data.attacking_time
	cooldown_time=data.cooldown_time
	damage=data.damage
	damage_type=data.damage_type
	ray.target_position.z=-data.range
	
func set_weapon_by_item_data(idata:ItemData):
	if not weapon_marker:
		return
	if not idata.item_scene:
		return
	if model:
		model.queue_free()
	model=idata.item_scene.instantiate()
	weapon_marker.add_child(model)
	model.position=Vector3.ZERO
	model.rotation=Vector3.ZERO
	if model.has_node("AnimationPlayer"):
		animation_player=model.get_node("AnimationPlayer")
	item_data=idata
	if item_data.data_path:
		weapon_data=load(item_data.data_path)
	
	if weapon_data:
		load_weapon_data(weapon_data)
