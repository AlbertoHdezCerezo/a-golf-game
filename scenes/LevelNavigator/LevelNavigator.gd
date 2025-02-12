extends Node3D

# Auxiliary scene used by the LevelSelector to display
# the game levels and navigate between them. Handles
# all the logic related to the level display in the UI
class_name LevelNavigator

const DISTANCE_BETWEEN_LEVELS := 6
const DIRECTION_FROM_ADJACENT_LEVELS_IN_SAME_WORLD := Vector3(1, 0, -1)
const LEVEL_SCENE = preload("res://scenes/Level/Level.tscn")

var slider_tween : Tween
var level_slider : Node3D
var level_manager : LevelManager

func _init() -> void:
	level_manager = LevelManager.new()
	level_manager.load_all_levels_resources()

	_initialize_level_slider()

func navigate_to_adjactent_level(direction_for_adjacent_level: Vector2) -> void:
	if direction_for_adjacent_level.x < 0:
		level_manager.select_previous_level_resource()
	if direction_for_adjacent_level.x > 0:
		level_manager.select_next_level_resource()

	# Rotates the slider in the oposite direction in which levels
	# were rendered to face the adjacent level requested by the input
	var new_level_slider_position := -1 * _position_for_level_index(level_manager.current_level_resource_index)

	if level_slider.position != new_level_slider_position:
		slider_tween = level_slider.create_tween()
		slider_tween.tween_property(level_slider, "position", new_level_slider_position, 0.5).set_trans(Tween.TRANS_SINE)

func current_level() -> Level:
	return level_slider.get_child(level_manager.current_level_resource_index)

func _initialize_level_slider() -> void:
	level_slider = Node3D.new()
	level_slider.name = "LevelSlider"
	self.add_child(level_slider)

	var index := 0
	var level_instance : Level

	for level_resource in level_manager.level_resources:
		level_instance = LEVEL_SCENE.instantiate()
		level_instance.name = "Level" + str(index)
		level_instance.level_resource = level_resource
		level_instance.position = _position_for_level_index(index)
		level_slider.add_child(level_instance)

		index += 1

func _position_for_level_index(level_index: int) -> Vector3:
	return level_index * DISTANCE_BETWEEN_LEVELS * DIRECTION_FROM_ADJACENT_LEVELS_IN_SAME_WORLD
