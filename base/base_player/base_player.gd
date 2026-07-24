extends CharacterBody3D
class_name BasePlayer



@export var walk_speed:float=5.0
@export var run_speed:float=walk_speed*1.5
@export var mouse_sensitivity = 0.002
@export var jump_velocity:float=5.0

var speed:float=walk_speed
@onready var head:Node3D=$Head



var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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

	# Браузер разрешает Pointer Lock ТОЛЬКО внутри нативного события клика мышкой!
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




					
func _physics_process(delta):
	if Input.is_action_pressed("run"):
		speed=run_speed
		is_running=true
	else:
		speed=walk_speed
		is_running=false		
	
						
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
	
