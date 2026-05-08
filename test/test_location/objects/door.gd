extends GameObject

var is_opened:bool=false

func interact(player:BasePlayer):
	if not is_opened:
		$door/AnimationPlayer.play("interact")
		focus_text="E - close"
	else:
		$door/AnimationPlayer.play_backwards("interact")	
		focus_text="E - open"
	is_opened=not is_opened
