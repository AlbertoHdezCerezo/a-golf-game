extends Node3D

class_name LevelSelector

const LEVEL_SCENE = preload("res://scenes/Level/Level.tscn")

# Collection of games that compose the game
# TODO: to be optimized in the future when I have more levels
@export var game_level_resources : Array[LevelResource]:
	set(new_game_level_resources):
		game_level_resources = new_game_level_resources

		if game_level_resources.size() == 0:
			push_error("Error when loading game levels in selector: no levels were loaded")
			return
		
		_instantiate_game_levels()

@onready var game_camera := $LevelSelectorCameraWrapper/LevelSelectorCamera
@onready var game_camera_wrapper := $LevelSelectorCameraWrapper

# Node holding all level instances. We apply transformations to this
# node in order to put each different level in front of the camera.
var levels_carrousel : Node3D

func _ready() -> void:
	_setup_camera()

func _setup_camera():
	game_camera.size = 9

func _instantiate_game_levels() -> void:
	var index := 1
	var game_level_instance : Level
	var next_game_level_position := Vector3.ZERO
	
	levels_carrousel = Node3D.new()
	self.add_child(levels_carrousel)

	for game_level_resource in game_level_resources:
		# TODO: add meta information to level resources (name, number, etc)
		#       and then use this information to name each instance with a concrete name
		game_level_instance = LEVEL_SCENE.instantiate()
		game_level_instance.name = "Level" + str(index)
		game_level_instance.level_resource = game_level_resource
		game_level_instance.position = next_game_level_position

		levels_carrousel.add_child(game_level_instance)

		index += 1
		next_game_level_position = _level_position_in_selector(game_level_instance)

# Determines where each one of the levels being rendered by the selector
# need to be rendered in the global 3D space. Otherwise all levels would
# appear overlapped.
func _level_position_in_selector(last_game_level_instantiated) -> Vector3:
	return last_game_level_instantiated.position + Vector3(7, 0, -7)
