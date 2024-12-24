extends MeshInstance3D

## Logic to render vector representing the direction and
## strenght with which the user will hit the ball after
## shooting. Part of the Player HUD.
class_name ForceAndDirectionVector

## Renders vector representing the force and direction the
## player is aiming at, taking HUD configuration into account
func draw(origin_coordinates: Vector3, force_and_direction_vector: Vector3, offset: float = 0) -> void:
	mesh.clear_surfaces()
	
	var normalized_force_and_direction_vector = force_and_direction_vector.normalized()
	var from: Vector3 = origin_coordinates
	var to: Vector3 = -(from + force_and_direction_vector)

	_draw_line(from, to)

func _draw_line(from: Vector3, to: Vector3, color: Color = Color.WHITE) -> void:
	# Set mesh to draw lines from coordinates
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	# Set mesh color
	mesh.surface_set_color(Color.WHITE)
	# Set line points
	mesh.surface_add_vertex(from)
	mesh.surface_add_vertex(to)
	# Render line
	mesh.surface_end()
