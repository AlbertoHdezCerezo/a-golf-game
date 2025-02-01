extends Object

# Generic logic for all game-related controllers:
#
# - UI controllers
# - In-Game controllers
# - Debug controllers
# - ...
#
# Provides mechanics required in all controllers,
# such as the enable and disable input at will.
class_name GameController

var enabled: bool = false

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false
