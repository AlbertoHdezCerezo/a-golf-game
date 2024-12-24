extends Object

## Implement the logic to transform mouse coordinates
## in the viewport to its equivalent in the 3D space.
##
## Given a 3D infinite plane and a 3D camera, the script
## uses the cursor viewport coordinates to calculate its
## equivalent position in the 3D space as the intersection
## of a ray projected from the camera to the plane.
class_name MouseRaycaster

var raycast_camera: Camera3D
var raycast_plane: Plane
var raycast_body_reference: Node3D

func _init(camera: Camera3D, body_reference: Node3D, plane: Plane = Plane(Vector3.UP)) -> void:
	raycast_body_reference = body_reference
	raycast_camera = camera
	raycast_plane = plane

## Returns the position of the cursor in the 3D space, result
## of projecting it from the given rayscast camera to the given
## 3D plane.
## 
## (!) Only compatible for orthogonal cameras. In perspective camera
##     our view is composed by a set of vectors, originated from the
##     same point in space (hence its "perspective" name) and with
##     different directions. For an orthogonal cameras, all vectors
##     composing the actual view share the same direction, but with
##     different origins. Thus, this method relies on the camera
##     basis direction and the project_ray_origin instead of the
##     project_ray_normal method.
func mouse_viewport_coordinates_in_3d_space() -> Variant:
	raycast_plane.d = raycast_body_reference.global_position.y

	# Viewport 2D cursor coordinates
	var mouse_position_2d := raycast_body_reference.get_viewport().get_mouse_position()
	# 3D camera direction (always the same for orthogonal cameras)
	var camera_direction := -raycast_camera.global_transform.basis.z.normalized()
	# 3D point corresponding to orthogonal projection of viewport mouse position
	var raycast_mouse_position := raycast_camera.project_ray_origin(mouse_position_2d)

	# Intersection of ray with camera direction and origin set to the
	# projection of the cursor viewport coordinates in the 3D space
	var raycast_intersection_point = raycast_plane.intersects_ray(raycast_mouse_position, camera_direction)

	return raycast_intersection_point
