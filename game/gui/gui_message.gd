extends Control
class_name GUIMessage

@export var waiting_time:float=3.0
@export var type_interval:float=0.2

@onready var label:Label=$VBoxContainer/Label
var text:String
var pos:int
var is_typing:bool=false
var timer:float
var type_timer:float
var message_query:Array[String]=[]

func process_query():
	if message_query.is_empty():
		return
	self.text=message_query.pop_front()
	pos=0
	label.text=""
	is_typing=true
	label.show()
	
func message(text:String):
	if not message_query.has(text):
		message_query.append(text)
	
	
	
func _process(delta: float) -> void:
	if not is_typing and timer<=0:
		if label.visible:
			label.hide()
		process_query()
		return
	timer-=delta
	type_timer-=delta
	if is_typing:
		if pos>=text.length():
			is_typing=false
			timer=waiting_time
			return
		else:
			if type_timer<=0:
				label.text+=text[pos]
				pos+=1
				type_timer=type_interval
