extends Node3D

var cursor_image: Resource = load("res://assets/images/cursors/pointer.svg")

@onready var camera := $CameraWrapper/Camera
@onready var level := $Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_game_cursor()
	_setup_player()
	_setup_level()

# Updates game cursor with custom skin
func _setup_game_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_image)

func _setup_player() -> void:
	var player = preload("res://scenes/Player/Player.tscn").instantiate()

	player.name = "Player"
	player.camera = camera
	
	# TODO: refactor this for a cleaner way to set the ball.
	#		Avoid changing the node global position or it will break HUD display
	var level_start_position = level.start_point.global_position
	player.get_node("Ball").position = level_start_position + Vector3(0,1.5,0)

	add_child(player)

func _setup_level() -> void:
	level.object_stayed_in_finish_area_until_timer_ran_out_signal.connect(_check_if_level_is_completed)

func _check_if_level_is_completed(rigid_body_in_finish_area: Node3D) -> void:
	print(rigid_body_in_finish_area)
