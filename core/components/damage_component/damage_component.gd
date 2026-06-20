extends Node
class_name BaseDamageComponent

var body:BaseEntity

func init_component(entity:BaseEntity):
	body=entity

func take_damage(damage:float,damage_type:String):
	print("DEBUG: DAMAGE COMPONENT: damage taken ",damage)

func update(delta:float):
	pass
