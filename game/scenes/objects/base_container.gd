extends GameObject
class_name BaseContainer

@export var area:Area3D


var markers:Array[ItemMarker]

func _ready() -> void:
	for child in get_children():
		if child is ItemMarker:
			markers.append(child)
	if area:
		area.body_entered.connect(on_body_entered)
		area.area_entered.connect(on_area_entered)

func get_free_marker(item:GameObject):
	for marker:ItemMarker in markers:
		if marker.can_put_item(item):
			return marker


func has_item(item:GameObject) -> bool:
	for marker:ItemMarker in markers:
		if not marker.is_free():
			if marker.item==item:
				return true
	return false
	
func can_put_item(item:GameObject) -> bool:
	if has_item(item):
		return false
	if get_free_marker(item):
		return true
	return false
	
func put_item(item:GameObject):
	var marker:ItemMarker=get_free_marker(item)
	if not marker:
		return
	if not can_put_item(item):
		return
	
	marker.put_item(item)
	item.item_taken.connect(on_item_taken)	
	

func  get_first_marker_with_item() -> ItemMarker:
	for marker:ItemMarker in markers:
		if not marker.is_free():
			return marker
	return null

func  is_empty() -> bool:
	for marker:ItemMarker in markers:
		if not marker.is_free():
			return false
	return true
	
func give_item(player:Player):
	if is_empty():
		return
	var marker:ItemMarker=get_first_marker_with_item()
	if not marker:
		return
	var item:GameObject=marker.item
	remove_item(item)
	player.take_item(item)
	

func place_item(item:GameObject):
	var marker:ItemMarker=get_free_marker(item)
	if not marker:
		return
	marker.put_item(item)

func get_item_marker(item:GameObject) -> ItemMarker:
	for marker:ItemMarker in markers:
		if not marker.is_free():
			if marker.item==item:
				return marker
	return null
	
func remove_item(item:GameObject):
	var marker:ItemMarker=get_item_marker(item)
	if marker:
		marker.remove_item()
	item.item_taken.disconnect(on_item_taken)
		
func interact(player:Player):
	if not player.current_item:
		if not is_empty():
			give_item(player)
		return
	var item:GameObject=player.current_item
	if can_put_item(item):
		player.drop_current_item()
		put_item(item)
		
	
func on_item_taken(item:GameObject):
	remove_item(item)
	

func get_hover_text(player:Player) -> String:
	if player.current_item:
		if can_put_item(player.current_item):
			return "E - put item"
	elif not is_empty():
		return "E - get item"
	
	return object_name
		
func on_body_entered(body:Node3D):
	if body==self:
		return
	var obj:GameObject
	if body is GameObject:
		obj=body
	if body.get_parent() is GameObject: 
		obj=body.get_parent()
	if not obj:
		return
	if obj.is_taken:
		return
	if not obj.is_pickable:
		return
	if not can_put_item(obj):
		return
	put_item(obj)
	pass

func on_area_entered(area:Area3D):
	on_body_entered(area)
