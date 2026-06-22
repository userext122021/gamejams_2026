extends CharacterBody3D
class_name Player

var game:Game

func init_player(g:Game):
	game=g

@export var hp:float=20
@export var mass:float=60.0
@export var friction := 8.0

@export var walk_speed:float=5.0
@export var run_speed:float=8.0	
@export var speed:float = 5.0
@export var jump_velocity:float = 8.0
@export var mouse_sensitivity := 0.002
@export var initial_weapon:Weapon
@onready var weapon_marker:Node3D=$Head/Hand
@onready var head = $Head

@onready var ray:RayCast3D=$Head/RayCast3D
@onready var label:Label3D=$Head/Label3D
@onready var inventory:Inventory=$Inventory

var rotation_x := 0.0
var weapon:Weapon
var interactable:Interactable

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if initial_weapon:
		equip_weapon(initial_weapon)
	
		
func unequip_weapon():
	if not weapon:
		return
	weapon.queue_free()
	weapon=null
	
func equip_weapon(w:Weapon):
	unequip_weapon()
	weapon=w
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	weapon_marker.add_child(weapon)
	weapon.position=Vector3.ZERO
	
func attack():
	if not weapon:
		return
	weapon.attack()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Поворот игрока по горизонтали
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Поворот камеры по вертикали
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))
		head.rotation.x = rotation_x

	if event.is_action_pressed("ui_cancel"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		game.exit()

func check_interactable():
	var body=ray.get_collider()
	if not body is Interactable:
		return
	interactable=body
	label.text=interactable.hover_text
	label.show()
	pass

func interact():
	if not interactable:
		return
	interactable.interact(self)

func take_item(item_name:String, amount:float):
	inventory.add_item(item_name,amount)
	game.ui.say("You've got: "+item_name)
	
func show_inventory():
	if inventory.items.is_empty():
		game.ui.say("You have nothing in your inventory")
		return
	var text:String="You have: "
	for key in inventory.items.keys():
		text+=key+":"+str(inventory.items[key])+" "
	
	game.ui.clear_messages()	
	game.ui.say(text)
	pass

func _physics_process(delta):
	var input_dir = Vector2.ZERO
	
	if ray.is_colliding():
		check_interactable()
	else:
		if label.visible:
			label.hide()
		if interactable:
			interactable=null
	
	if not is_on_floor() :
		velocity.y += get_gravity().y * delta

	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("run"):
		speed=run_speed
	else:
		speed=walk_speed
	if Input.is_action_pressed("fire"):
		attack()
	if Input.is_action_just_pressed("interact"):
		interact()
	if Input.is_action_just_pressed("inventory"):
		show_inventory()		
	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.y += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	var direction = (
		transform.basis.z * input_dir.y +
		transform.basis.x * input_dir.x
	).normalized()

	#velocity.x = direction.x * speed
	#velocity.z = direction.z * speed
	velocity.x = move_toward(velocity.x, direction.x * speed, 2.0*friction * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, 2.0*friction * delta)
	
	move_and_slide()

func take_damage(damage:float,damage_type:String):
	hp-=damage
	print("DEBUG: PLAYER:  taking damage ",damage," hp remaining ",hp)
	if hp<=0:
		die()
	pass
	
func take_hit(damage:float,damage_type:String,force:float,pos:Vector3,dir:Vector3):
	take_damage(damage,damage_type)
	#var dir:Vector3=global_position.direction_to(pos).normalized()

	velocity.x+=dir.x*force/mass
	velocity.z+=dir.z*force/mass
	
	pass

func die():
	print("DEBUG: dying")
	queue_free()
