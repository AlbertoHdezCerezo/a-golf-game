extends Node3D

## Defines the logic to render the HUD around the
## player golf ball. This HUD provides information
## on the force and direction players are aiming
## when hitting the ball during the game
class_name PlayerHUD

const FORCE_AND_DIRECTION_VECTOR_OFFSET := 0.16

@onready var force_and_direction_vector_mesh: ForceAndDirectionVector = $ForceAndDirectionVectorMesh

## Node around which HUD will be rendered
var player_node: Node3D

## Player mass center coordinates
func player_origin_coordinates() -> Vector3:
	return player_node.global_position - Vector3(0, player_node.mesh.radius, 0)

## Draws all HUD elements.
func draw_hud(force_and_direction_vector: Vector3) -> void:
	draw_force_and_direction_vector_for_shot(force_and_direction_vector)

## Hides all HUD elements.
func hide_hud() -> void:
	hide_force_and_direction_vector_for_shot()

## Renders vector representing the force and direction the
## player is aiming at, taking HUD configuration into account
func draw_force_and_direction_vector_for_shot(force_and_direction_vector: Vector3) -> void:
	force_and_direction_vector_mesh.draw(player_origin_coordinates(), force_and_direction_vector, FORCE_AND_DIRECTION_VECTOR_OFFSET)

func hide_force_and_direction_vector_for_shot() -> void:
	force_and_direction_vector_mesh.erase()
