extends Node
class_name StatsComponent

@export var walk_speed:float=5.0


var body:BaseEntity


func init_component(entity:BaseEntity):
	body=entity

func update(delta:float):
	pass
