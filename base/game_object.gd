extends Node3D
class_name GameObject

@export var object_name:String="unknown"
@export var is_interactive:bool=false
@export var focus_text:String="E - interact"
@export var is_pickable:bool=false
@export var is_equipable:bool=false
#@export var need_collision:bool=false

@onready var interact_collision:CollisionShape3D=$InteractionBody/CollisionShape3D
var collision

#func _ready() -> void:
	#if need_collision:
		#collision=$StaticBody3D/CollisionShape3D
	
func disable_collisions():
	interact_collision.disabled=true
	#if need_collision:
		#collision.disabled=true
func enable_collisions():
	interact_collision.disabled=false
	#if need_collision:
		#collision.disabled=false
	
	
func interact(player:BasePlayer):
	print("DEBUG: BaseObject interact")

func on_equip(player:BasePlayer):
	disable_collisions()
	print("DEBUG: BaseObject on equip")

func on_drop(player:BasePlayer):
	enable_collisions()
func can_use() -> bool:
	return true
	
func use(player:BasePlayer):
	if not can_use():
		return
	print("DEBUG: base object using")
