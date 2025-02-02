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
var keyboard_event_handler : KeyboardMenuInputHandler

signal select_level_signal(selected_level_resource)

func _initialize_level_navigator() -> void:
	levels_navigator = LevelNavigator.new(game_level_resources)
	levels_navigator.name = "LevelsNavigator"
	self.add_child(levels_navigator)

func _ready() -> void:
	keyboard_event_handler = KeyboardMenuInputHandler.new()
	keyboard_event_handler.name = "KeyboardEventHandler"
	add_child(keyboard_event_handler)

func enable() -> void:
	keyboard_event_handler.enable()
	keyboard_event_handler.input_event_received_signal.connect(_handle_keyboard_state)

func disable() -> void:
	keyboard_event_handler.disable()

func enabled() -> bool:
	return keyboard_event_handler.enabled

func _handle_keyboard_state(keyboard_state: KeyboardMenuInputHandlerState) -> void:
	if keyboard_state.pad_position_changed() and keyboard_state.current_pad_direction != Vector2.ZERO:
		levels_navigator.navigate_to_adjactent_level(keyboard_state.current_pad_direction)
	
	if keyboard_state.confirmed:
		_select_level(levels_navigator.current_level())

func _select_level(level: Level) -> void:
	emit_signal("select_level_signal", level)
