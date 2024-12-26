extends Node3D

## Multiplication factor applied to normalized force and
## direction vector to adjust the length of the force and
## direction vector in the HUD
const MAX_MODULE_FOR_SHOT_VECTOR := 0.7
## Multiplication factor applied to normalized force and
## direction vector to adjust the impulse applied to the
## ball when shooting
const MAX_MODULE_FOR_SHOT_IMPULSE := 3.5

# Ball shooting parameters
var cursor_3d_position_on_aim_start: Vector3
var force_and_direction_vector_for_shot: Vector3

# Dependent nodes
var hud: PlayerHUD
@onready var ball: RigidBody3D = $Ball
@onready var ball_mesh: MeshInstance3D = $Ball/Mesh
@onready var camera: Camera3D = $CameraWrapper/Camera

var drag_and_drop_controller: DragAndDropController

func _ready() -> void:
	_setup_hud()
	_setup_drag_and_drop_controller()

## Configures mouse raycaster and drag & drop controller to
## monitor player gestures and listen to in-game events
func _setup_drag_and_drop_controller() -> void:
	var mouse_raycaster := MouseRaycaster.new(camera, ball, Plane(Vector3.UP, ball_mesh.mesh.radius))
	drag_and_drop_controller = DragAndDropController.new(mouse_raycaster, 0, 2)

	# drag_and_drop_controller.start_drag_signal.connect()
	drag_and_drop_controller.drag_signal.connect(self._aim)
	drag_and_drop_controller.drop_signal.connect(self._shoot)

func _setup_hud() -> void:
	hud = preload("res://scenes/player_hud/PlayerHUD.tscn").instantiate()
	hud.player_node = ball_mesh
	add_child(hud)

## Can the player shoot the ball? The player should only
## be able to shoot when the ball is not moving and there
## are no contextual menues interrupting the game flow
func _can_shoot() -> bool:
	# TODO: figure out why there is some velocity when
	# 		ball is stale. Something wrong with physics?
	return true

## Listen to input events and triggers gameplay mechanics on
## player actions.
func _input(event: InputEvent) -> void:
	if _can_shoot(): drag_and_drop_controller.handle_event(event)

## Is the player currently doing a drag & drop gesture?
## This is the equivalent of aiming.
func _aiming() -> bool:
	if drag_and_drop_controller == null: return false
	return drag_and_drop_controller.dragging

## Triggered when the player performs an aim gesture.
## Reads direction and force vector from input controller
## and applies
func _aim(normalized_force_and_direction_vector) -> void:
	if not _can_shoot() || normalized_force_and_direction_vector == null: return

	hud.draw_hud(normalized_force_and_direction_vector * MAX_MODULE_FOR_SHOT_VECTOR)

## Hits the ball with the direction and force the
## user is aiming for. Resets aiming coordinates
## for future shots.
func _shoot(normalized_force_and_direction_vector) -> void:
	if not _can_shoot() || normalized_force_and_direction_vector == null: return

	hud.hide_hud()
	ball.apply_impulse(normalized_force_and_direction_vector * MAX_MODULE_FOR_SHOT_IMPULSE)
