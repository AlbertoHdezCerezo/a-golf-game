@tool
extends Node3D

class_name Level

signal object_entered_finish_area_signal(rigid_body_in_finish_area)
signal object_left_finish_area_signal(rigid_body_which_left_finish_area)
signal object_stayed_in_finish_area_until_timer_ran_out_signal(rigid_body_in_finish_area)

@export var level_resource : LevelResource: 
	set(new_level_resource):
		level_resource = new_level_resource

		if new_level_resource != null:
			_load_level_from_level_resource()
		else:
			_reset_level()

@export var timeout_for_stay := 3

@onready var level_start_point := $StartPoint # Marks the begining of the level, where the ball will be loaded
@onready var finish_timer := $FinishTimer # Used to determine when the ball reaches the finish hole
@onready var finish_area := $FinishArea # Marks the area representing the finish hole
@onready var level_map_grid := $Map

var body_in_finish_area: Node3D

func _ready() -> void:
	# Whenever the scene is loaded, either in the game or in the
	# editor, clear all level information. Let the game or the
	# developer set the level to play, and then proceed to set it up
	level_resource = null
	_reset_level()

	if not Engine.is_editor_hint():
		_listen_to_finish_area_events()
		_listen_to_timer_events()

func _listen_to_finish_area_events() -> void:
	finish_area.body_entered.connect(_start_timer_and_notify_body_entered_finish_area)
	finish_area.body_exited.connect(_stop_timer_and_notify_body_left_finish_area)

func _listen_to_timer_events() -> void:
	finish_timer.timeout.connect(_notify_body_stayed_until_timer_timeout)

func _start_timer_and_notify_body_entered_finish_area(body: Node3D) -> void:
	body_in_finish_area = body

	emit_signal("object_entered_finish_area_signal", body_in_finish_area)

	finish_timer.wait_time = timeout_for_stay
	finish_timer.one_shot = true
	finish_timer.start()

func _stop_timer_and_notify_body_left_finish_area(body: Node3D) -> void:
	if body == body_in_finish_area:
		body_in_finish_area = null
		emit_signal("object_left_finish_area_signal", body)
		finish_timer.stop()

func _notify_body_stayed_until_timer_timeout() -> void:
	emit_signal("object_stayed_in_finish_area_until_timer_ran_out_signal", body_in_finish_area)

# Recreates the level described by a LevelResource instance in the game level
# TODO: very similar codewise to the LevelEditor logic, maybe worth exploring refactoring?
func _load_level_from_level_resource() -> void:
	_reset_level()

	# Load mesh library in grid map
	if level_resource.map_mesh_library != null:
		level_map_grid.mesh_library = level_resource.map_mesh_library

	# Update start point marker global position
	if level_resource.start_point_position != null:
		level_start_point.position = level_resource.start_point_position

	# Draw grid map according to level tiles information
	for index in level_resource.map_grid_coordinates.size():
		var grid_tile_coordinate := level_resource.map_grid_coordinates[index]
		var grid_tile_mesh_index := level_resource.map_grid_mesh_indexes[index]
		var grid_tile_mesh_orientation := level_resource.map_grid_mesh_orientations[index]
		level_map_grid.set_cell_item(grid_tile_coordinate, grid_tile_mesh_index, grid_tile_mesh_orientation)

# Resets all variables in Level scene
func _reset_level() -> void:
	level_map_grid.mesh_library = null
	level_start_point.position = Vector3(0,0,0)
	level_map_grid.clear()
