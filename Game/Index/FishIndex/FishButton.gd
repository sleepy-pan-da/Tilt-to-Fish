extends TextureButton

var fish_name : String

func _on_FishButton_pressed() -> void:
	GameEvents.emit_signal("pressed_fish_button_in_index", fish_name)
