extends Node3D

class_name MinigolfGame

var cursor_image: Resource = load("res://assets/images/cursors/pointer.svg")

var level: Level: 
	set(new_level):
		level = new_level

		add_child(level)

		_setup_player()
		# level.object_stayed_in_finish_area_until_timer_ran_out_signal.connect(_check_if_level_is_completed)

@onready var game_camera := $CameraWrapper/Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_game_cursor()

	if level != null: _setup_player()

# Updates game cursor with custom skin
func _setup_game_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_image)

func _setup_player() -> void:
	var player = preload("res://scenes/Player/Player.tscn").instantiate()

	player.name = "Player"
	player.camera = game_camera
	
	# TODO: refactor this for a cleaner way to set the ball.
	#		Avoid changing the node global position or it will break HUD display
	var level_start_position = level.level_start_point.position
	player.get_node("Ball").position = level_start_position + Vector3(0,1.5,0)

	add_child(player)
