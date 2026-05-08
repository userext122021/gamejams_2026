extends GameObject


func interact(player:BasePlayer):
	if player.global_position.y > $DownMarker.global_position.y:
		player.global_position=$DownMarker.global_position
	else:
		player.global_position=$UpMarker.global_position
