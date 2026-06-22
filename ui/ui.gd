extends Control
class_name UI

func _ready() -> void:
	$MessagePanel.hide()

func say(text:String):
	$MessagePanel.type_message(text)

func clear_messages():
	$MessagePanel.clear()
