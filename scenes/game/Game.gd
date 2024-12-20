extends Node3D

var cursor_image: Resource = load("res://assets/images/cursors/pointer.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_game_cursor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Updates game cursor with custom skin
func _set_game_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_image)
