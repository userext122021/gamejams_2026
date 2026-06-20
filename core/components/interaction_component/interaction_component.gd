extends Node3D
class_name InteractionComponent

var player:BasePlayer

@onready var ray:RayCast3D=$RayCast3D
@onready var label:Label3D=$RayCast3D/Label3D


func interact():
	if not ray.is_colliding():
		return
	var node:Node3D=ray.get_collider()
	if node is InteractableComponent:
		var ic:InteractableComponent=node
		ic.interact(player)



func init_component(player_body:BasePlayer):
	player=player_body


func check_colliding(node:Node3D):
	if node is InteractableComponent:
		var ic:InteractableComponent=node
		label.text=ic.interact_text
		label.show()
	else:
		label.hide()
	pass
	
func update(delta:float):
	if ray.is_colliding():
		var node:Node3D=ray.get_collider()
		check_colliding(node)
	else:
		label.hide()	
	pass
