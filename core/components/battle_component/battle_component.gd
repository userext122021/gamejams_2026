extends Node
class_name BattleComponent

var body:BaseEntity

func init_component(entity:BaseEntity):
	body=entity


func update(delta:float):
	pass

func attack():
	if not body:
		return
	var wc:WeaponComponent=body.weapon_component
	if not wc:
		return
	if body.animation_component:
		body.animation_component.play_animation("attack")
	wc.attack()
