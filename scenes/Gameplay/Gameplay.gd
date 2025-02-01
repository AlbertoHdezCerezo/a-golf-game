extends Node3D

class_name Gameplay

const LEVEL_SELECTOR_SCENE = preload("res://scenes/LevelSelector/LevelSelector.tscn")
const MINIGOLF_GAME_SCENE = preload("res://scenes/Game/Game.tscn")

var camera_tween : Tween
var current_level : Level
var minigolf_game : MinigolfGame
var level_selector : LevelSelector

@onready var camera_wrapper := $CameraWrapper
@onready var camera := $CameraWrapper/Camera

func _ready() -> void:
	_initialize_minigolf_hole_game()
	_initialize_level_selector()
	enter_level_selection_mode()

func _initialize_minigolf_hole_game() -> void:
	minigolf_game = MINIGOLF_GAME_SCENE.instantiate()
	minigolf_game.name = "MinigolfGame"
	add_child(minigolf_game)

func _initialize_level_selector() -> void:
	level_selector = LEVEL_SELECTOR_SCENE.instantiate()
	level_selector.name = "LevelSelector"
	level_selector.disable
	add_child(level_selector)
	
	level_selector.select_level_signal.connect(enter_gameplay_mode)

func enter_level_selection_mode() -> void:
	_disable_game()
	_enable_level_selector()

func enter_gameplay_mode(level_to_play: Level) -> void:
	minigolf_game.level = level_to_play

	_disable_level_selector()
	_enable_game()

func _enable_level_selector() -> void:
	camera_tween = create_tween().set_parallel()
	camera_tween.tween_property(camera, "size", level_selector.game_camera.size, 1).set_trans(Tween.TRANS_SINE)
	await camera_tween.finished

	level_selector.enable()

func _disable_level_selector() -> void:
	level_selector.disable()

func _enable_game() -> void:
	camera_tween = create_tween().set_parallel()
	camera_tween.tween_property(camera, "size", minigolf_game.game_camera.size, 1).set_trans(Tween.TRANS_SINE)
	await camera_tween.finished

func _disable_game() -> void:
	pass

