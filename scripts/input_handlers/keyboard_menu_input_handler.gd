extends InputHandler

# Used to navigate through UI menues using
# the keyboard directional keys
class_name KeyboardMenuInputHandler

signal input_event_received_signal(input_handler_state)

var previous_state: KeyboardMenuInputHandlerState

func _handle_event(event: InputEvent) -> void:
	var event_handled := false

	var new_state := KeyboardMenuInputHandlerState.new()

	new_state.original_event = event

	if previous_state == null:
		new_state.previous_pad_direction = Vector2.ZERO
	else:
		new_state.previous_pad_direction = previous_state.current_pad_direction

	if event.is_action("ui_confirm_input"):
		_handle_confirmation(new_state, event)
		event_handled = true

	if event.is_action("ui_left_input") or event.is_action("ui_right_input"):
		_handle_pad_movement(new_state, event)
		event_handled = true

	if event_handled:
		previous_state = new_state
		emit_signal("input_event_received_signal", new_state)

func _handle_confirmation(new_state: KeyboardMenuInputHandlerState, event: InputEvent) -> void:
	if event.is_released():
		new_state.confirmed = true

func _handle_pad_movement(new_state: KeyboardMenuInputHandlerState, event: InputEvent) -> void:
	new_state.current_pad_direction = Input.get_vector("ui_left_input", "ui_right_input", "ui_down_input", "ui_up_input")
