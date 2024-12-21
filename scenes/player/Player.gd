extends Node3D

# Ball shooting parameters
var cursor_3d_position_on_aim_start: Vector3
var force_and_direction_vector_for_shot: Vector3
var mouse_raycaster := MouseRaycaster.new()

# Dependent nodes
@onready var ball: RigidBody3D = $Ball
@onready var camera: Camera3D = $CameraWrapper/Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_up_mouse_raycaster()

## Configure mouse raycaster. Required for mini-golf ball aiming mechanic
func _set_up_mouse_raycaster() -> void:
	mouse_raycaster.setup(camera, ball, Plane(Vector3.UP))

func _physics_process(delta: float) -> void:
	if aiming: _refresh_force_and_direction_vector_for_shot()

## Input logic
## -----------
#  (!) -> To be moved to a script
var aiming: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_button"):
		_start_aiming()
	elif event.is_action_released("left_mouse_button"):
		_shot()

## Resets aiming parameters and sets aim flag
## to true for tracking mouse coordinates
func _start_aiming() -> void:
	aiming = true
	force_and_direction_vector_for_shot = Vector3()

	var new_cursor_3d_position_on_aim_start: Variant = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()
	
	if new_cursor_3d_position_on_aim_start != null:
		cursor_3d_position_on_aim_start = new_cursor_3d_position_on_aim_start

	print_debug("player started aiming at position %s" % cursor_3d_position_on_aim_start)

## Resets aiming parameter and sets aim flag
## to false to stop tracking mouse coordinates
## and cancel ongoing shot (if not triggered already)
func _stop_aiming() -> void:
	print_debug("player stopped aiming")

	aiming = false
	cursor_3d_position_on_aim_start = Vector3()
	force_and_direction_vector_for_shot = Vector3()

## Hits the ball with the direction and force the
## user is aiming for. Resets aiming coordinates
## for future shots.
func _shot() -> void:
	print_debug("player shots ball")

	if aiming:
		_stop_aiming()

## Updates shot direction and force vector based
## on initial and current rayscasted cursor positions
func _refresh_force_and_direction_vector_for_shot() -> void:
	if aiming:
		var current_cursor_3d_position: Variant = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()

		if current_cursor_3d_position == null || cursor_3d_position_on_aim_start == null: return

		force_and_direction_vector_for_shot = current_cursor_3d_position - cursor_3d_position_on_aim_start
