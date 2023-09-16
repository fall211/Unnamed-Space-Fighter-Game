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

var left_str: float
var right_str: float

var side_str: float



func _ready() -> void:
	mouse_sens = sensitivity

func _physics_process(delta: float) -> void:

	# always move forward, when press shift, go faster
	var move_speed = speed * delta * 100
	if Input.is_action_pressed("boost"):
		velocity = -global_transform.basis.z * move_speed * boost_multiplier
	else:
		velocity = -global_transform.basis.z * move_speed


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




	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			return
			
		var mouse_event = event as InputEventMouseMotion

		goal_rotation.y += (-mouse_event.relative.x * mouse_sens * get_process_delta_time())
		goal_rotation.x += (-mouse_event.relative.y * mouse_sens * get_process_delta_time())


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

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

