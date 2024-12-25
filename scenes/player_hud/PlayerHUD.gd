extends Node3D

## Defines the logic to render the HUD around the
## player golf ball. This HUD provides information
## on the force and direction players are aiming
## when hitting the ball during the game
class_name PlayerHUD

const FORCE_AND_DIRECTION_VECTOR_OFFSET := 0.16

@onready var force_and_direction_vector_mesh: ForceAndDirectionVector = $ForceAndDirectionVectorMesh

## Origin coordinates for rendering HUD
var origin_coordinates: Vector3

func _init(new_origin_coordinates: Vector3 = Vector3.ZERO) -> void:
	origin_coordinates = new_origin_coordinates

## Draws all HUD elements.
func draw_hud(force_and_direction_vector: Vector3) -> void:
	draw_force_and_direction_vector_for_shot(force_and_direction_vector)

## Hides all HUD elements.
func hide_hud() -> void:
	hide_force_and_direction_vector_for_shot()

## Renders vector representing the force and direction the
## player is aiming at, taking HUD configuration into account
func draw_force_and_direction_vector_for_shot(force_and_direction_vector: Vector3) -> void:
	force_and_direction_vector_mesh.draw(origin_coordinates, force_and_direction_vector, FORCE_AND_DIRECTION_VECTOR_OFFSET)

func hide_force_and_direction_vector_for_shot() -> void:
	force_and_direction_vector_mesh.erase()
