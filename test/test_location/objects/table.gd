extends GameObject
var is_opened:bool=false
@onready var stored_object:GameObject=$table2/box/TestCup

func _ready() -> void:
	stored_object.disable_collisions()
	
	
func interact(player:BasePlayer):
	if is_opened:
		return
	super.interact(player)
	$table2/AnimationPlayer.play("interaction")
	stored_object.enable_collisions()
	stored_object=null
	is_interactive=false
