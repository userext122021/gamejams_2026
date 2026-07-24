extends BasePlayer
class_name Player

@export var item_marker:Node3D

@onready var ray:RayCast3D=$Head/RayCast3D
@onready var label:Label3D=$Head/RayCast3D/Label3D

var current_item:GameObject
var hover_object:GameObject

func _ready():
	super._ready()
	
	
	
func check_interact():
	var col=ray.get_collider()
	if not col:
		return
	if col==current_item:
		return
	var o:GameObject
	if col is GameObject:
		o=col
	if col.get_parent() is GameObject:
		o=col.get_parent()
	if o:
		hover_object=o
		if hover_object.is_interactive:
			label.show()
			if hover_object.get_hover_text(self):
				set_hover_text(hover_object.get_hover_text(self))
			else:
				set_hover_text("E - interact with "+o.object_name)
		
func interact():
	if not hover_object:
		return
	if hover_object.is_interactive and not hover_object.is_pickable:
		hover_object.interact(self)
	else:
		if hover_object.is_pickable and hover_object.is_interactive:
			take_item(hover_object)
	hover_object=null
	label.hide()
			
func _physics_process(delta):
	if ray.is_colliding():
		check_interact()
	else:
		hover_object=null
		label.hide()
	if Input.is_action_just_pressed("interact"):
		if not hover_object and current_item:
			drop_current_item()
		else:
			interact()
	if Input.is_action_just_pressed("attack"):
		if current_item:
			if current_item.object_type=="tool":
				if hover_object:
					interact()
			else:
				drop_current_item()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode==Input.MOUSE_MODE_VISIBLE:
			get_tree().quit()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
					
	super._physics_process(delta)

func drop_item(item:GameObject):
	var parent=get_parent()
	
	item.global_position=global_position-global_basis.z*3
	item.enable_object()
	item.reparent(parent)
	item.enable_object()
	item.drop()
	
	
func drop_current_item():
	if not current_item:
		return
	drop_item(current_item)
	current_item=null

func take_item(item:GameObject):
	if current_item:
		drop_item(current_item)
	current_item=item
	current_item.disable_object()
	item.reparent(item_marker)
	item.position=Vector3.ZERO
	item.rotation=Vector3.ZERO
	
	
	current_item.take()

func set_hover_text(text:String):
	label.text=text

	
