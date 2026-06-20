extends CharacterBody3D
class_name BaseEntity

@export var entity_name:String="unknown"
@export var entity_type:String="unknown"
@export var walk_speed:float=5.0
@export var run_speed:float=8.0
@export var jump_velocity:float=4.5
@export var rotation_velocity:float=4.5

@export_category("Components")
@export var stats_component:StatsComponent
@export var control_component:ControlComponent
@export var weapon_component:WeaponComponent
@export var inventory_component:InventoryComponent
@export var battle_component:BattleComponent
@export var animation_component:AnimationComponent
@export var navigation_component:NavigationComponent
@export var damage_component:BaseDamageComponent

var is_running:bool
var is_moving:bool
var is_jumping:bool

var speed:float

func _ready():
	if stats_component:
		stats_component.init_component(self)
	if control_component:
		control_component.init_component(self)
	if weapon_component:
		weapon_component.init_component(self)
	if inventory_component:
		inventory_component.init_component(self)
	if battle_component:
		battle_component.init_component(self)
	if animation_component:
		animation_component.init_component(self)
	if navigation_component:
		navigation_component.init_component(self)
	if damage_component:
		damage_component.init_component(self)
	#Init default values
	speed=walk_speed
		
func _process(delta: float) -> void:
	if stats_component:
		stats_component.update(delta)
	if damage_component:
		damage_component.update(delta)	
				
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta		
	if control_component:
		control_component.update(delta)
	if navigation_component:
		navigation_component.update(delta)
	if weapon_component:
		weapon_component.update(delta)
	if battle_component:
		battle_component.update(delta)
	if animation_component:
		animation_component.update(delta)
	move_and_slide()
