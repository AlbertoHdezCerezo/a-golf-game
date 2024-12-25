extends Object

## Implements the drag and drop logic controller to hit
## the ball on a specific direction and with a specific
## force based on the player drag and drop gestures:
##
## 1. User presses the screen to start aiming.
## 2. User moves finger to aim and set the shot force.
## 3. User releases screen to shoot.
##
## The controller transforms input coordinates from the
## 3D space (translated from the screen by the raycaster
## in a normalized vector representing the direction and
## strength of the shot). The game logic can then use
## this information translate this vector into the res-
## pective ball impulse.
class_name DragAndDropController

signal start_drag_signal
signal drag_signal(force_and_direction_normalized_vector)
signal drop_signal(force_and_direction_normalized_vector)

## Coordinate where player gesture starts
var drag_coordinate: Variant
## Coordinate where player gesture ends
var drop_coordinate: Variant
## Is the player drag & dropping?
var dragging: bool

## Used to translate mouse coordinates from viewport to 3D space
var mouse_raycaster: MouseRaycaster
## Min and max values used to normalize vector
## resulting from drag and drop coordinates.
var min_direction_and_force_vector_length
var max_direction_and_force_vector_length

func _init(
	new_mouse_raycaster: MouseRaycaster,
	new_min_direction_and_force_vector_length: float = 0,
	new_max_direction_and_force_vector_length: float = 1
) -> void:
	mouse_raycaster = new_mouse_raycaster
	
	if new_min_direction_and_force_vector_length >= new_max_direction_and_force_vector_length:
		push_error("Drag & Drop controller expects valid min-max range to normalize force and direction vector. Given range min is greater or equal than max value.")
	
	min_direction_and_force_vector_length = new_min_direction_and_force_vector_length
	max_direction_and_force_vector_length = new_max_direction_and_force_vector_length

## Updates drag and drop coordinates based on mouse
## Emits signals based on events kind to notify parent
## nodes about completion of drag & drop gesture
func handle_event(event: InputEvent) -> Variant:
	if event.is_action_pressed("left_mouse_button_down"):
		_start_drag()
	if event is InputEventMouseMotion && dragging:
		_drag()
	elif event.is_action_released("left_mouse_button_down") && dragging:
		_drop()
	
	return normalized_direction_and_force_vector

## Starts tracking drag & drop gesture by storing the initial
## gestures coordinates in the respective attributes
func _start_drag() -> void:
	drag_coordinate = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()
	drop_coordinate = drag_coordinate
	dragging = true
	start_drag_signal.emit()

## Tracks ongoing drag gesture
func _drag() -> void:
	drop_coordinate = mouse_raycaster.mouse_viewport_coordinates_in_3d_space()
	drag_signal.emit(normalized_direction_and_force_vector())

## Finishes drag gesture
func _drop() -> void:
	var force_and_direction_normalized_vector: Variant = normalized_direction_and_force_vector()

	drag_coordinate = null
	drop_coordinate = null
	dragging = false
	drop_signal.emit(force_and_direction_normalized_vector)

## Returns normalized vector representing the force and direction
## the user is aiming to, being the force the length of the vector
## and the direction its respective direction
func normalized_direction_and_force_vector() -> Variant:
	if not _can_determine_normalized_direction_and_force_vector(): return null

	var vector: Vector3 = drop_coordinate - drag_coordinate

	if vector.length() <= min_direction_and_force_vector_length:
		return Vector3.ZERO
	elif vector.length() >= max_direction_and_force_vector_length:
		return -vector.normalized()
	else:
		return -vector.normalized() * ((vector.length() - min_direction_and_force_vector_length) / (max_direction_and_force_vector_length - min_direction_and_force_vector_length))

func _can_determine_normalized_direction_and_force_vector() -> bool:
	return drag_coordinate is Vector3 && drop_coordinate is Vector3
