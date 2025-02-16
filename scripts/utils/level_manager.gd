extends Object

# Handles LevelResource resources, providing an
# interface to navigating between levels according
# to their indexes
class_name LevelManager

const LEVEL_RESOURCES_PATH = "res://assets/resources/levels"

var current_level_resource_index : int
var level_resources : Array[LevelResource]

func load_all_levels_resources() -> void:
	level_resources = []

	var dir := DirAccess.open(LEVEL_RESOURCES_PATH)
	
	for filepath in dir.get_files():
		var level_resource := ResourceLoader.load(LEVEL_RESOURCES_PATH + "/" + filepath)
		if level_resource != null: level_resources.append(level_resource)

	if level_resources.size() > 1:
		level_resources.sort_custom(
			func(lra: LevelResource, lrb: LevelResource) -> bool:
				if lra.world_index == lrb.world_index:
					return lra.index <= lrb.index
				else:
					return lra.world_index <= lrb.world_index
		)

	current_level_resource_index = 0

func select_previous_level_resource() -> LevelResource:
	if current_level_resource_index > 0: current_level_resource_index -= 1
	
	return current_level_resource()

func select_next_level_resource() -> LevelResource:
	if current_level_resource_index < level_resources.size() - 1: current_level_resource_index += 1

	return current_level_resource()

func current_level_resource() -> LevelResource:
	return level_resources[current_level_resource_index]
