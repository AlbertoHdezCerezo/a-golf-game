extends Node3D

class_name Level

signal object_entered_finish_area_signal(rigid_body_in_finish_area)
signal object_left_finish_area_signal(rigid_body_which_left_finish_area)
signal object_stayed_in_finish_area_until_timer_ran_out_signal(rigid_body_in_finish_area)

@export var level_resource : LevelResource

@export var timeout_for_stay := 3
@onready var finish_timer := $FinishTimer # Used to determine when the ball reaches the finish hole
@onready var start_point := $StartPoint # Marks the begining of the level, where the ball will be loaded
@onready var finish_area := $FinishArea # Marks the area representing the finish hole

var body_in_finish_area: Node3D

func _ready() -> void:
	_listen_to_finish_area_events()
	_listen_to_timer_events()

func _listen_to_finish_area_events() -> void:
	finish_area.body_entered.connect(_start_timer_and_notify_body_entered_finish_area)
	finish_area.body_exited.connect(_stop_timer_and_notify_body_left_finish_area)

func _listen_to_timer_events() -> void:
	finish_timer.timeout.connect(_notify_body_stayed_until_timer_timeout)

func _start_timer_and_notify_body_entered_finish_area(body: Node3D) -> void:
	body_in_finish_area = body

	emit_signal("object_entered_finish_area_signal", body_in_finish_area)

	finish_timer.wait_time = timeout_for_stay
	finish_timer.one_shot = true
	finish_timer.start()

func _stop_timer_and_notify_body_left_finish_area(body: Node3D) -> void:
	if body == body_in_finish_area:
		body_in_finish_area = null

		emit_signal("object_left_finish_area_signal", body)

		finish_timer.stop()

func _notify_body_stayed_until_timer_timeout() -> void:
	emit_signal("object_stayed_in_finish_area_until_timer_ran_out_signal", body_in_finish_area)
