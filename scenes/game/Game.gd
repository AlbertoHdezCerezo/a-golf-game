extends Node3D

var cursor_image: Resource = load("res://assets/images/cursors/pointer.svg")

@onready var camera = $CameraWrapper/Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_game_cursor()
	_setup_player()

# Updates game cursor with custom skin
func _setup_game_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_image)

func _setup_player() -> void:
	var player = preload("res://scenes/Player/Player.tscn").instantiate()

	player.name = "Player"
	player.camera = camera
	
	# TODO: refactor this for a cleaner way to set the ball.
	#		Avoid changing the node global position or it will break HUD display
	player.get_node("Ball").position = player.get_node("Ball").position + Vector3(0,1.5,0)

	add_child(player)
