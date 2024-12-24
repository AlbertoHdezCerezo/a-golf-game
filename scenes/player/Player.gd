extends Node3D

# Max distance (in meters) for force and direction vector for
# shot. Limits how long the force & direction indicator can be
const MAX_MODULE_FOR_SHOT_VECTOR := 0.7

# Ball shooting parameters
var cursor_3d_position_on_aim_start: Vector3
var force_and_direction_vector_for_shot: Vector3

# Dependent nodes
@onready var hud := $Ball/PlayerHUD
@onready var ball: RigidBody3D = $Ball
@onready var camera: Camera3D = $CameraWrapper/Camera
@onready var mouse_raycaster := MouseRaycaster.new(camera, ball, Plane(Vector3.UP))

func _physics_process(_delta: float) -> void:
	if aiming && _can_shoot():
		_refresh_force_and_direction_vector_for_shot()

## Input logic
## -----------
#  (!) -> To be moved to a script
var aiming: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_button_down"):
		_start_aiming()
	elif event.is_action_released("left_mouse_button_down"):
		_shot()

func _can_shoot() -> bool:
	# TODO: figure out why there is some velocity when
	# 		ball is stale. Something wrong with physics?
	return true

## Resets aiming parameters and sets aim flag
## to true for tracking mouse coordinates
func _start_aiming() -> void:
	if _can_shoot():
		aiming = true
		force_and_direction_vector_for_shot = Vector3()

		var new_cursor_3d_position_on_aim_start: Variant = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()
		
		if new_cursor_3d_position_on_aim_start != null:
			cursor_3d_position_on_aim_start = new_cursor_3d_position_on_aim_start

## Resets aiming parameter and sets aim flag
## to false to stop tracking mouse coordinates
## and cancel ongoing shot (if not triggered already)
func _stop_aiming() -> void:
	if aiming:
		aiming = false
		cursor_3d_position_on_aim_start = Vector3()
		force_and_direction_vector_for_shot = Vector3()

## Hits the ball with the direction and force the
## user is aiming for. Resets aiming coordinates
## for future shots.
func _shot() -> void:
	if aiming && _can_shoot():
		hud.hide_hud()
		ball.apply_impulse(-force_and_direction_vector_for_shot * 5)
		_stop_aiming()

## Updates shot direction and force vector based
## on initial and current rayscasted cursor positions
func _refresh_force_and_direction_vector_for_shot() -> void:
	if not aiming: return

	var current_cursor_3d_position: Variant = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()

	if current_cursor_3d_position == null || cursor_3d_position_on_aim_start == null: return

	force_and_direction_vector_for_shot = (current_cursor_3d_position - cursor_3d_position_on_aim_start).limit_length(MAX_MODULE_FOR_SHOT_VECTOR)

	hud.draw_hud(force_and_direction_vector_for_shot)
