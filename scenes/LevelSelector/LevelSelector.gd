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

@onready var game_camera_wrapper := $LevelSelectorCameraWrapper
@onready var game_camera := $LevelSelectorCameraWrapper/LevelSelectorCamera

func _ready() -> void:
	_setup_camera()

func _setup_camera():
	game_camera.size = 9

func _instantiate_game_levels() -> void:
	var index := 1
	var game_level_instance : Level

	for game_level_resource in game_level_resources:
		# TODO: add meta information to level resources (name, number, etc)
		#       and then use this information to name each instance with a concrete name
		game_level_instance = LEVEL_SCENE.instantiate()
		game_level_instance.name = "Level" + str(index)
		game_level_instance.level_resource = game_level_resource

		self.add_child(game_level_instance)

		index += 1
