extends GameObject

func can_clean(player:Player) -> bool:
	if not player.current_item:
		return false
	if player.current_item.object_type=="tool":
		if player.current_item.object_name=="rag":
			return true
	return false
	

func interact(player:Player):
	if can_clean(player):
		queue_free()
		
func get_hover_text(player:Player) -> String:
	if can_clean(player):
		return "E - Clean "+object_name
	return object_name
