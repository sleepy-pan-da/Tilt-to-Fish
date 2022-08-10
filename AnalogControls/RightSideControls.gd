extends Control

signal pressed_interact_button

func toggle_visibility(is_visible : bool) -> void:
	visible = is_visible

func _on_InteractButton_pressed() -> void:
	emit_signal("pressed_interact_button")
	Input.vibrate_handheld(50)
