extends Object

class_name GeometryDrawer

var mesh_instance: MeshInstance3D

func _init(new_mesh_instance: MeshInstance3D) -> void:
	mesh_instance = new_mesh_instance

func draw_line(from: Vector3, to: Vector3, color: Color = Color.WHITE) -> void:
	# Set mesh to draw lines from coordinates
	mesh_instance.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	# Set mesh color
	mesh_instance.mesh.surface_set_color(Color.WHITE)
	# Set line points
	mesh_instance.mesh.surface_add_vertex(from)
	mesh_instance.mesh.surface_add_vertex(to)
	# Render line
	mesh_instance.mesh.surface_end()

func draw_circumference(origin: Vector3, radius: float, color: Color = Color.WHITE) -> void:
	pass
