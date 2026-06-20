extends Node
class_name ControlComponent

var body:BaseEntity
var stats:StatsComponent

func init_component(entity:BaseEntity):
	body=entity
	if body.stats_component:
		stats=body.stats_component


func update(delta:float):
	pass
