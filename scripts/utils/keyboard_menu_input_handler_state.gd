extends Object

# Holds information on KeyboardMenuInputHandler status, allowing
# other objects to better understand the player actions when
# navigating through menues
class_name KeyboardMenuInputHandlerState

var confirmed: bool
var original_event: InputEvent
var current_pad_direction: Vector2 = Vector2.ZERO
var previous_pad_direction: Vector2 = Vector2.ZERO

func pad_released() -> bool:
	return current_pad_direction == Vector2.ZERO

func pad_just_released() -> bool:
	return pad_released() and previous_pad_direction != Vector2.ZERO

func pad_position_changed() -> bool:
	return current_pad_direction != previous_pad_direction
