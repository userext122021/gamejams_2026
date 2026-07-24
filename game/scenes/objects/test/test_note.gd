extends GameObject

@export var text:String
@export var gui_message:GUIMessage

func interact(player:Player):
	if gui_message:
		gui_message.message(text)
	

func get_hover_text(player:Player) -> String:
	return "E - read "+object_name
