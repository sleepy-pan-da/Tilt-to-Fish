extends Label

onready var sensitivity_slider = $HSlider

func set_slider_value(new_value : int) -> void:
	sensitivity_slider.value = new_value


func get_slider_value() -> int:
	return sensitivity_slider.value
