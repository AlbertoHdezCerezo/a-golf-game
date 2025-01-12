extends Resource

class_name LevelResource

@export var start_point_position: Vector3
# Mesh library used to draw maps
@export var map_mesh_library: MeshLibrary
# Grid-map coordinates where tiles are placed
@export var map_grid_coordinates: Array[Vector3i]
# Tile index from mesh library.
@export var map_grid_mesh_indexes: Array[int]
# Orientation of each tile in the grid map
@export var map_grid_mesh_orientations: Array[int]

# TODO: we might need to implement a validation system in future
func can_save() -> bool:
	var can_save_level_resource := true

	if (map_mesh_library == null):
		can_save_level_resource = false
		push_warning("Level in editor cannot be saved: missing grid map mesh library")

	if (map_grid_coordinates == null) || (map_grid_coordinates.size() == 0):
		can_save_level_resource = false
		push_warning("Level in editor cannot be saved: level grid map is empty")

	if (start_point_position == null):
		can_save_level_resource = false
		push_warning("Level in editor cannot be saved: missing level start point marker")
	
	return can_save_level_resource

# Dumps information from LevelEditor instance in the
# LevelResource instance loaded within the scene.
func dump_changes_to_resource_file() -> void:
	if not can_save():
		push_error("Failed to dump work from Level Editor in level resource")
	else:
		ResourceSaver.save(self, self.resource_path)
