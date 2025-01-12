@tool
extends Node3D

class_name LevelEditor

# When selecting a level resource in the editor, trigger the logic
# to load the grid-map in the current node linstance
@export var level_resource: LevelResource: 
	set(new_level_resource):
		level_resource = new_level_resource

		# This method will be called when we run the scene, thus we
		# need to add the flag for this to happen (it should only run
		# in the editor)
		if Engine.is_editor_hint():
			if new_level_resource != null:
				_load_level_from_level_resource()
			else:
				_reset_level_editor()

@onready var level_start_point := $StartPoint
@onready var level_map_grid := $Map

# When running the scene, the level information edited in the editor
# will be dumped in the selected resource, if there is a resource selected.
# This is the way to export and save your progress on levels.
func _ready() -> void:
	# This code runs both when you open the scene in the editor and in the
	# game. We just want to trigger the logic when we run the scene, hence
	# this flag
	if not(Engine.is_editor_hint()):
		_save_level_to_level_resource()

# Extracts level information from current scene nodes
# and dumps it into the LevelResource set for the scene.
func _save_level_to_level_resource() -> void:
	if level_resource == null:
		push_error("Failed to dump progress from Level Editor, no resource was specified ...")
	else:
		_update_level_resource_with_editor_information()
		level_resource.dump_changes_to_resource_file()

# Updates the Editor Level resource information with the
# changes made in the editor scene (map, start position, etc).
func _update_level_resource_with_editor_information() -> void:
	level_resource.map_mesh_library = level_map_grid.mesh_library
	level_resource.start_point_position = level_start_point.position
	level_resource.map_grid_coordinates = level_map_grid.get_used_cells()
	level_resource.map_grid_mesh_orientations = []
	level_resource.map_grid_mesh_indexes = []

	for used_cell_coordinate in level_resource.map_grid_coordinates:
		level_resource.map_grid_mesh_indexes.append(level_map_grid.get_cell_item(used_cell_coordinate))
		level_resource.map_grid_mesh_orientations.append(level_map_grid.get_cell_item_orientation(used_cell_coordinate))

# Recreates the level described by a LevelResource instance
# in the editor, so it can be further worked by the designer.
func _load_level_from_level_resource() -> void:
	_reset_level_editor()

	# Load mesh library in grid map
	if level_resource.map_mesh_library != null:
		level_map_grid.mesh_library = level_resource.map_mesh_library
	# Update start point marker global position
	if level_resource.start_point_position != null:
		level_start_point.position = level_resource.start_point_position
	
	if _can_load_grid_map_from_level_resource():
		level_resource.load_level_in_grid_map(level_map_grid)

func _can_load_grid_map_from_level_resource() -> bool:
	return level_resource.map_grid_coordinates != null \
		and level_resource.map_grid_coordinates.size() > 0 \
		and level_resource.map_grid_mesh_indexes != null \
		and level_resource.map_grid_mesh_indexes.size() > 0

# Resets all variables in Level Editor scene
func _reset_level_editor() -> void:
	level_map_grid.mesh_library = null
	level_start_point.position = Vector3(0,0,0)
	level_map_grid.clear()
