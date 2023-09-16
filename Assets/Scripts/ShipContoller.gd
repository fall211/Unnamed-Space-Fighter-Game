extends CharacterBody3D


@onready var camera: Camera3D = $Camera3D
@export var speed: float
@export var boost_multiplier: float

@export var side_acceleration: float
@export var side_deceleration: float
@export var max_side_speed: float

@export var sensitivity: float

var mouse_sens: float
var mouse_pos: Vector2
var goal_rotation: Vector2 = Vector2(0, 0)


var side_str: float = 0
var boost_str: float = 1.0

var is_engine_on : bool = false
signal engine_toggled(on : bool)



func _ready() -> void:
	mouse_sens = sensitivity
	connect("engine_toggled", toggle_engine)

func _physics_process(delta: float) -> void:

	var move_speed = speed * delta * 100
	
	if is_engine_on:
		velocity = Vector3(0.0, 0.0, 0.0)

		if Input.is_action_pressed("boost"):
			boost_str += 0.1
			boost_str = clamp(boost_str, 1.0, boost_multiplier)
		else:
			boost_str = lerp(boost_str, 1.0, 0.1)
		velocity += -global_transform.basis.z * move_speed * boost_str


		# move left and right
		if Input.is_action_pressed("move_left"):
			side_str -= side_acceleration
		if Input.is_action_pressed("move_right"):
			side_str += side_acceleration
		
		if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			side_str = lerp(side_str, 0.0, side_deceleration)
		else:
			side_str = clamp(side_str, -max_side_speed, max_side_speed)

		velocity += global_transform.basis.x * move_speed * side_str
	else:
		velocity = velocity.lerp(Vector3(0, 0, 0), 0.01)


	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_engine"):
		engine_toggled.emit(!is_engine_on)

	if event is InputEventMouseMotion:
		if not is_engine_on:
			return
			
		var mouse_event = event as InputEventMouseMotion

		goal_rotation.y += (-mouse_event.relative.x * mouse_sens * get_process_delta_time())
		goal_rotation.x += (-mouse_event.relative.y * mouse_sens * get_process_delta_time())


func _process(_delta: float) -> void:


	var rot = Vector2(deg_to_rad(goal_rotation.x), deg_to_rad(goal_rotation.y))
	lerp_angle(rot.x, 0, 0.1)
	lerp_angle(rot.y, 0, 0.1)
	
	rotate(global_transform.basis.y.normalized(), rot.y)
	rotate(global_transform.basis.x.normalized(), rot.x)
	goal_rotation -= rot

	var dist_to_goal = Vector2(0, 0).distance_to(goal_rotation)
	var scalar: float
	if dist_to_goal == 0:
		scalar = 1
	else:
		scalar = clamp((1 / pow(dist_to_goal, 4)), 0, 1)
	mouse_sens = scalar * sensitivity

func toggle_engine(on : bool):
	is_engine_on = on
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_engine_on else Input.MOUSE_MODE_VISIBLE
