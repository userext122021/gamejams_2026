extends AI



func update_target_point():
	if not body.target:
		return
	if body.target.global_position.distance_to(body.target_pos)>1.0:
		body.set_target_point(body.target.global_position)

func update(delta:float):
	if not body.target:
		return

			
	update_target_point()
	
	if body.global_position.distance_to(body.target.global_position)<body.attack_distance:
		body.rotate_to_point(body.target.global_position,delta)
		body.attack()
		
	else:
		body.rotate_to_point(body.get_next_point(),delta)
		body.move_to_target(delta)
		#print("DEBUG: moving")
