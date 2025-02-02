extends InputHandler

# Used to navigate through UI menues using
# the keyboard directional keys
class_name KeyboardMenuInputHandler

func _handle_event(event: InputEvent) -> void:
	if event.is_action_released("ui_confirm_input"):
		select_level_signal.emit(levels_navigator.current_level())

	var direction_vector = Vector2.ZERO
	
	if event.is_action_released("ui_left_input"):
		direction_vector = Vector2(-1, 0)
	if event.is_action_released("ui_right_input"):
		direction_vector = Vector2(1, 0)

	if last_ui_direction_vector != direction_vector and direction_vector.length() > 0:
		last_ui_direction_vector = direction_vector
		levels_navigator.navigate_to_adjactent_level(direction_vector)
