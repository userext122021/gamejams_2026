extends GameObject


func interact(player:Player):
	if player.current_item:
		if player.current_item.object_name=="rag":
			player.current_item.object_state="clean"
