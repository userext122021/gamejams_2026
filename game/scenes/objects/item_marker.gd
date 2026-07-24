extends Node3D
class_name ItemMarker

var item:GameObject

func can_put_item(item:GameObject) -> bool:
	if self.item:
		return false
	return true

func put_item(item:GameObject):
	if not can_put_item(item):
		return
	
	self.item=item
	item.reparent(self)
	item.position=Vector3.ZERO
	item.rotation=Vector3.ZERO
	item.disable_object()

func is_free() -> bool:
	if item:
		return false
	return true

func remove_item():
	item=null
	
