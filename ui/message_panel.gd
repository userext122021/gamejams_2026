extends Panel
class_name MessagePanel

var typing_interval:float=0.1
var waiting_time:float=3.0

var current_text:String
var current_pos:int=0
var is_typing:bool
var is_waiting:bool
var typing_timer:float=0
var waiting_timer:float=0
var message_queue=[]

func type_message(text:String):
	if text==current_text:
		return
	message_queue.append(text)

func clear():
	message_queue.clear()
	if is_typing:
		is_typing=false
		current_pos=0
		current_text=""
		hide()
			
func start_typing_message(text:String):
	current_text=text
	current_pos=0
	is_typing=true
	typing_timer=0
	$Label.text=""

func wait():
	is_waiting=true
	waiting_timer=0

func type_char() -> bool:
	if current_pos>=current_text.length():
		return false
	$Label.text+=current_text[current_pos]
	current_pos+=1
	show()
	return true
	
func _process(delta: float) -> void:
	if is_typing:
		typing_timer+=delta
		if typing_timer>=typing_interval:
			if not type_char():
				is_typing=false
				wait()
				current_text=""
			typing_timer=0
	elif is_waiting:
		waiting_timer+=delta
		if waiting_timer>waiting_time:
			is_waiting=false
	else:
		if message_queue.is_empty():
			hide()
		else:
			var msg:String=message_queue.pop_front()
			start_typing_message(msg)
