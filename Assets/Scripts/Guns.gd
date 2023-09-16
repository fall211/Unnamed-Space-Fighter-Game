extends Node3D

var index: int = 0

signal guns_fired

func _ready() -> void:
	connect("guns_fired", fire)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		guns_fired.emit() 


func fire() -> void:
	var particles : CPUParticles3D = get_child(index)
	particles.restart()

	if index == 1: index = 0 
	else: index = 1
