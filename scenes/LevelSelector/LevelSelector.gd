extends Node3D

class_name LevelSelector

const LEVEL_NAVIGATOR_SCENE = preload("res://scenes/LevelNavigator/LevelNavigator.tscn")

# Collection of games that compose the game
# TODO: to be optimized in the future when I have more levels
@export var game_level_resources : Array[LevelResource]:
	set(new_game_level_resources):
		game_level_resources = new_game_level_resources

		if game_level_resources.size() == 0:
			push_error("Error when loading game levels in selector: no levels were loaded")
			return
		
		_initialize_level_navigator()

@onready var game_camera := $LevelSelectorCameraWrapper/LevelSelectorCamera
@onready var game_camera_wrapper := $LevelSelectorCameraWrapper

var levels_navigator : LevelNavigator

func _ready() -> void:
	_setup_camera()

func _input(event: InputEvent) -> void:
	var ui_direction_vector := Input.get_vector("ui_left_input", "ui_right_input", "ui_up_input", "ui_down_input")
	levels_navigator.navigate_to_adjactent_level(ui_direction_vector)

func _setup_camera():
	game_camera.size = 9

func _initialize_level_navigator() -> void:
	levels_navigator = LevelNavigator.new(game_level_resources)
	levels_navigator.name = "LevelsNavigator"
	self.add_child(levels_navigator)
