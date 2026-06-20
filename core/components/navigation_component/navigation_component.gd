extends Node3D
class_name NavigationComponent

var body: BaseEntity
@export var target_point: Vector3
@export var navigation_agent: NavigationAgent3D

@export var stopping_distance: float = 0.2 # Дистанция остановки при прямом движении

var has_reached:bool


func init_component(entity: BaseEntity) -> void:
	body = entity

func set_target_point(point: Vector3) -> void:
	has_reached=false
	target_point = point
	if navigation_agent:
		navigation_agent.target_position=target_point
			
func update(delta: float) -> void:
	
	if not body:
		return
	
	
	
	# ТОЧКА НАЗНАЧЕНИЯ: Сетка путей или прямая координата
	var next_step_position: Vector3
	
	if navigation_agent:
		if navigation_agent.is_navigation_finished():
			body.velocity = Vector3.ZERO
			has_reached=true
			return
		next_step_position = navigation_agent.get_next_path_position()
	else:
		# Логика прямого движения без агента
		var current_pos := body.global_position
		# Игнорируем Y для точного расчета расстояния на плоскости
		var distance := current_pos.distance_to(Vector3(target_point.x, current_pos.y, target_point.z))
		
		if distance <= stopping_distance:
			body.velocity = Vector3.ZERO
			has_reached=true
			return
		next_step_position = target_point


	
	# Поворот и движение к выбранной точке шага
	rotate_to_point(next_step_position, delta)
	move_to_point(next_step_position, delta)

func rotate_to_point(target_pos:Vector3,delta:float) -> void:
	var angle_to_target = atan2(target_pos.x - body.global_position.x, target_pos.z - body.global_position.z)+PI
	body.rotation.y = lerp_angle(body.rotation.y, angle_to_target, body.rotation_velocity * delta)


func move_to_point(target_pos:Vector3,delta:float) -> void:
	# Вычисляем направление к цели по осям X и Z
	var direction = (target_pos - body.global_position)
	direction.y = 0
	direction = direction.normalized()
	
	# Задаем скорость
	body.velocity.x = direction.x * body.speed
	body.velocity.z = direction.z * body.speed
