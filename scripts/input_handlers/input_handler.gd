extends Node

# Handles input events. Can be extended to implement
# different game control mechanics within the game.
#
# It requires to be instantiated as a node within a
# scene to work. Otherwise, the _input method won't
# be triggered when the system detects events
class_name InputHandler

var enabled: bool = false

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

# If a controller object is not enabled, it will not
# perform any logic when input events are detected
func _input(event: InputEvent) -> void:
	if enabled: _handle_event(event)

# Method expected to be extended by classes
# extending the InputHandler class. Here is
# the logic for manipulating events will go
func _handle_event(event: InputEvent) -> void:
	pass
