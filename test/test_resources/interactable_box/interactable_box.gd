extends Interactable


func on_interact(p:Player):
	var item_name:String
	if randf()<0.5:
		item_name="apple"
	else:
		item_name="stone"
	p.take_item(item_name,1.0)
