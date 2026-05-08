extends CharacterBody3D
class_name BasePlayer


signal object_dropped(object:GameObject,position:Vector3)
signal interaction_started(object:GameObject)

@export var walk_speed:float=5.0
@export var run_speed:float=walk_speed*1.5
@export var mouse_sensitivity = 0.002
@export var jump_velocity:float=5.0

var speed:float=walk_speed
@onready var head:Node3D=$Head
@onready var look_ray:RayCast3D=$Head/RayCast3D
@onready var focus_label:Label3D=$Head/RayCast3D/FocusLabel
@onready var right_hand_marker:Marker3D=$Hands/RightHand/RightHandMarker

@onready var step_sound:AudioStreamPlayer3D=$Sounds/StepSound

var right_hand_object:GameObject

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_looking_on_something:bool=false
var focus_object:GameObject

var is_moving:bool=false
var is_running:bool=false


func _ready():
	# Захватываем курсор мыши
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	# Вращение мышью
	if event is InputEventMouseMotion:
		# Поворот всего тела влево-вправо (по оси Y)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Поворот только головы вверх-вниз (по оси X)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		# Ограничиваем угол наклона головы, чтобы не делать "сальто"
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# Выход из режима захвата мыши по нажатию Esc
	if event.is_action_pressed("ui_cancel"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()

func  check_collision(delta:float,body:Node3D):
	if is_looking_on_something:
		if focus_object:
			if focus_object==body:
				return
	print("DEBUG:check collision")
	var object:GameObject=null
	
	if body is GameObject:
		object=body
	if body.get_parent():
		if body.get_parent() is GameObject:
			object=body.get_parent()
	
	if object:
		print("DEBUG:this is a game object with name ",object.name)
		focus_object=object
		if focus_object.is_interactive:
			focus_label.text=object.focus_text
			focus_label.show()
	is_looking_on_something=true

func equip_object(object:GameObject):
	if object.get_parent():
		object.get_parent().remove_child(focus_object)
	right_hand_marker.add_child(object)
	object.position=Vector3.ZERO
	object.rotation=Vector3.ZERO
	object.on_equip(self)
	right_hand_object=object
	

	
func drop_object(object:GameObject):
	if right_hand_object:
		var pos:Vector3=right_hand_object.global_position	
		right_hand_marker.remove_child(right_hand_object)
		object_dropped.emit(right_hand_object,pos)
		right_hand_object.on_drop(self)
		right_hand_object=null

func attack():
	if right_hand_object:
		if right_hand_object.can_use():
			right_hand_object.use(self)

func pickup_object(object:GameObject):
	print("DEBUG: object pciked up ",object.object_name)
	if not right_hand_object:
		equip_object(object)
		return
	else:
		put_to_inventory(object)

func put_to_inventory(object:GameObject):
	print("DEBUG: putting object to inventory",object.object_name)
	object.queue_free()
	
func interact():
	if not is_looking_on_something:
		return
	if not focus_object:
		return
	if focus_object.is_interactive and focus_object.is_pickable:
		pickup_object(focus_object)
		focus_object=null
		is_looking_on_something=false
		return
	if focus_object.is_interactive:
		focus_object.interact(self)
		interaction_started.emit(focus_object)
		stop_interation()

func stop_interation():
	is_looking_on_something=false
	focus_object=null
	focus_label.hide()
					
func _physics_process(delta):
	
	
	if look_ray.is_colliding():
		check_collision(delta,look_ray.get_collider())
	else:
		is_looking_on_something=false
		focus_object=null
		focus_label.hide()
	
	if Input.is_action_pressed("run"):
		speed=run_speed
		is_running=true
	else:
		speed=walk_speed
		is_running=false		
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_pressed("attack"):
		attack()
						
	if Input.is_action_just_pressed("drop"):
		if right_hand_object:
			drop_object(right_hand_object)
			
		
	# Добавляем гравитацию
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Получаем направление движения на основе ввода
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# Трансформируем направление относительно взгляда персонажа
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		is_moving=true
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		is_moving=false
		# Плавная остановка
		velocity.x = move_toward(velocity.x, 0, speed/10)
		velocity.z = move_toward(velocity.z, 0, speed/10)

	move_and_slide()
	update_sounds()


func update_sounds():
	if is_moving:		
		if not step_sound.playing:
			if is_running:
				step_sound.pitch_scale=1.8
			else:
				step_sound.pitch_scale=1.2
			step_sound.play()
