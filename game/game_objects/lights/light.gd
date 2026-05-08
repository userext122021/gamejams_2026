extends Node3D

var max_dl:float=0.01

var t:float=0
var energy:float=2.0
func _process(delta: float) -> void:
	var dl=max_dl*randf()
	$OmniLight3D.light_energy=energy+dl	
