extends Node3D


var guns_audio : AudioStreamPlayer
var fire_audio = preload("res://Assets/Sounds/laserSmall_002.ogg")

var ship_audio : AudioStreamPlayer
var engine_on_audio = preload("res://Assets/Sounds/thrusterFire_000.ogg")
var engine_off_audio = preload("res://Assets/Sounds/engineOff.ogg")


func _ready() -> void:
	var guns = get_node("../Guns")
	guns_audio = get_node("GunsAudio")
	guns.connect("guns_fired", fire)


	var player = get_parent()
	ship_audio = get_node("ShipAudio")
	player.connect("engine_toggled", engine)
	player.connect("boost_toggled", boost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func fire() -> void:
	guns_audio.stream = fire_audio
	guns_audio.play()


func engine(on : bool):
	if on:
		ship_audio.volume_db = 0.0
		ship_audio.stream = engine_on_audio
	else:
		ship_audio.volume_db = -5.0
		ship_audio.stream = engine_off_audio
	ship_audio.play()

func boost(on : bool):
	if on:
		ship_audio.volume_db = 5.0
	else:
		ship_audio.volume_db = 0.0