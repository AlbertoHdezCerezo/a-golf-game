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
	_reset_level()

	if not Engine.is_editor_hint():
		_listen_to_finish_area_events()
		_listen_to_timer_events()

		if level_resource != null:
			_load_level_from_level_resource()
		else:
			_reset_level()

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
	
	if not _level_ready_to_be_loaded():
		push_warning("Problem when loading Level scene: level is not yet ready to be loaded ...")
		return

	# Load mesh library in grid map
	level_map_grid.mesh_library = level_resource.map_mesh_library

	# Update start point marker global position
	level_start_point.position = level_resource.start_point_position

	level_resource.load_level_in_grid_map(level_map_grid)

# Resets all variables in Level scene
func _reset_level() -> void:
	if not _level_ready_to_be_loaded():
		push_warning("Problem when resetting Level scene: level is not yet ready to be resetted ...")
		return

	level_map_grid.mesh_library = null
	level_map_grid.clear()
	level_start_point.position = Vector3(0,0,0)

func _level_ready_to_be_loaded() -> bool:
	return level_map_grid != null and level_start_point != null
