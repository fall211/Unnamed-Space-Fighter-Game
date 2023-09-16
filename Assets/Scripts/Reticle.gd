extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# move to where mouse is
	var mouse_pos = get_viewport().get_mouse_position()
	set_position(mouse_pos)
