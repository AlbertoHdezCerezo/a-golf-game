extends MeshInstance3D

## Logic to render vector representing the direction and
## strenght with which the user will hit the ball after
## shooting. Part of the Player HUD.
class_name ForceAndDirectionVector

@onready var geometry_drawer := GeometryDrawer.new(self)

## Renders vector representing the force and direction the
## player is aiming at, taking HUD configuration into account
func draw(origin_coordinates: Vector3, force_and_direction_vector: Vector3, offset: float = 0) -> void:
	# Re-draw entire mesh on each pass
	erase()
	
	var normalized_force_and_direction_vector = force_and_direction_vector.normalized()
	var from: Vector3 = origin_coordinates + (normalized_force_and_direction_vector * offset)
	var to: Vector3 = from + force_and_direction_vector

	geometry_drawer.draw_line(from, to)

func erase() -> void:
	mesh.clear_surfaces()
