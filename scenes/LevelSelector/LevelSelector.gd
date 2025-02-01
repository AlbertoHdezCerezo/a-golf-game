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

var enabled := false
var levels_navigator : LevelNavigator
var last_ui_direction_vector : Vector2

signal select_level_signal(selected_level_resource)

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

# TODO: move this to its own UI controller
func _input(event: InputEvent) -> void:
	if enabled:
		if event.is_action_released("ui_confirm_input"):
			select_level_signal.emit(levels_navigator.current_level())

		var direction_vector = Vector2.ZERO
		
		if event.is_action_released("ui_left_input"):
			direction_vector = Vector2(-1, 0)
		if event.is_action_released("ui_right_input"):
			direction_vector = Vector2(1, 0)

		if last_ui_direction_vector != direction_vector and direction_vector.length() > 0:
			last_ui_direction_vector = direction_vector
			levels_navigator.navigate_to_adjactent_level(direction_vector)

func _select_level(level: Level) -> void:
	emit_signal("select_level_signal", level)

func _initialize_level_navigator() -> void:
	levels_navigator = LevelNavigator.new(game_level_resources)
	levels_navigator.name = "LevelsNavigator"
	self.add_child(levels_navigator)
