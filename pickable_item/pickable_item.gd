extends Interactable
class_name PickableItem

@export var item_name:String=""
@export var amount:float=0.0


func _ready() -> void:
	if not item_name:
		return
	if amount<=0:
		return
	hover_text="E - pick up: "+item_name

func on_interact(p:Player):
	p.take_item(item_name,amount)
	queue_free()
