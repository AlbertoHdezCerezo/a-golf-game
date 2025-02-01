extends Node3D

const PLAYER_HUD_SCENE = preload("res://scenes/PlayerHUD/PlayerHUD.tscn")
## Multiplication factor applied to normalized force and
## direction vector to adjust the length of the force and
## direction vector in the HUD
const MAX_MODULE_FOR_SHOT_VECTOR := 0.7
## Multiplication factor applied to normalized force and
## direction vector to adjust the impulse applied to the
## ball when shooting
const MAX_MODULE_FOR_SHOT_IMPULSE := 3.5

var hud: PlayerHUD
var camera: Camera3D # TODO: maybe pass it down from enable?
var drag_and_drop_event_handler: DragAndDropInputHandler

@onready var ball: RigidBody3D = $Ball
@onready var ball_mesh: MeshInstance3D = $Ball/Mesh

func _ready() -> void:
	# TODO: remove this once we have proper game flow.
	#    	the scenes which instantiae this node should
	#		enable it upon request
	enable()

func enable() -> void:
	# Enable HUD
	hud = PLAYER_HUD_SCENE.instantiate()
	hud.player_node = ball_mesh
	hud.name = "HUD"
	add_child(hud)
	
	# Enable Drag & Drop mechanism
	var mouse_raycaster := MouseRaycaster.new(camera, ball, Plane(Vector3.UP, ball_mesh.mesh.radius))
	drag_and_drop_event_handler = DragAndDropInputHandler.new(mouse_raycaster, 0, 2)
	drag_and_drop_event_handler.name = "InputEventHandler"
	drag_and_drop_event_handler.enable()
	drag_and_drop_event_handler.drag_signal.connect(self._aim)
	drag_and_drop_event_handler.drop_signal.connect(self._shoot)
	add_child(drag_and_drop_event_handler)

func disable() -> void:
	# Disable HUD
	hud.queue_free()
	hud = null

	# Disable Drag & Drop mechanism
	drag_and_drop_event_handler.queue_free()
	drag_and_drop_event_handler = null

func _aim(normalized_force_and_direction_vector) -> void:
	if _can_shoot(normalized_force_and_direction_vector):
		hud.draw_hud(normalized_force_and_direction_vector * MAX_MODULE_FOR_SHOT_VECTOR)

func _shoot(normalized_force_and_direction_vector) -> void:
	if _can_shoot(normalized_force_and_direction_vector):
		hud.hide_hud()
		ball.apply_impulse(normalized_force_and_direction_vector * MAX_MODULE_FOR_SHOT_IMPULSE)

func _can_shoot(normalized_force_and_direction_vector) -> bool:
	var ball_stopped := ball.linear_velocity.length() < 0.005
	var can_calculate_shot_from_vector := (normalized_force_and_direction_vector != null)
	return ball_stopped && can_calculate_shot_from_vector
