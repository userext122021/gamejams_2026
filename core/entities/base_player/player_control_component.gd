extends ControlComponent
class_name PlayerControlComponent

var player_body:BasePlayer

func init_component(entity:BaseEntity):
	super.init_component(entity)
	player_body=entity

func update(delta:float):
	
	if body.is_jumping and body.is_on_floor():
		body.is_jumping=false
		
	if Input.is_action_just_pressed("jump") and body.is_on_floor():
		body.velocity.y = body.jump_velocity
		body.is_jumping=true
	
	if Input.is_action_just_pressed("interact"):
		if 	player_body.interaction_component:
			player_body.interaction_component.interact()
	if Input.is_action_pressed("attack"):
		if body.battle_component:
			body.battle_component.attack()
	if Input.is_action_pressed("run"):
		body.is_running=true
		body.speed=body.run_speed
	else:
		body.is_running=false
		body.speed=body.walk_speed		
			
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var current_speed := body.speed
	
	if direction:
		body.velocity.x = direction.x * current_speed
		body.velocity.z = direction.z * current_speed
		body.is_moving=true
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, current_speed)
		body.velocity.z = move_toward(body.velocity.z, 0, current_speed)
		body.is_moving=false
