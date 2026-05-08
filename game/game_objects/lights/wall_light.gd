extends Node3D


@export var energy:float=1.0

@onready var light:Light3D=$OmniLight3D

func _ready() -> void:
	light.light_energy=energy
