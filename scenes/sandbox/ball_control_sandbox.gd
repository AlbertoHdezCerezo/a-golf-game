extends Node3D

# Sandbox scene to experiment with ball controls
class_name BallControlSandbox

const PLAYER_SCENE = preload("res://scenes/Player/Player.tscn")

@onready var camera_wrapper := $Composition/CameraWrapper
@onready var camera := $Composition/CameraWrapper/Camera
@onready var player := $Composition/Player
@onready var composition := $Composition

func _ready() -> void:
	_initialize_player()

func _initialize_player() -> void:
	var player := PLAYER_SCENE.instantiate()

	player.name = "Player"
	player.camera = camera
	player.get_node("Ball").position = Vector3.ZERO + Vector3(0,1.5,0)

	composition.add_child(player)
