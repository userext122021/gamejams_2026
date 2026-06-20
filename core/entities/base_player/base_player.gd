extends BaseEntity
class_name BasePlayer

@export_group("Mouse Settings")
@export var mouse_sensitivity: float = 0.002
@export var min_pitch: float = -85.0 # Минимальный угол обзора (в градусах)
@export var max_pitch: float = 85.0  # Максимальный угол обзора (в градусах)

@onready var head:Node3D=$Head

@export_group("Components")

@export var interaction_component:InteractionComponent
@export var ui_component:UIComponent


func _ready():
	super._ready()
	# Захватываем курсор мыши
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if interaction_component:
		interaction_component.init_component(self)

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

func _process(delta: float) -> void:
	super._process(delta)
	if interaction_component:
		interaction_component.update(delta)
	if ui_component:
		ui_component.update(delta)
