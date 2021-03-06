extends Control

onready var options_label = $Label
onready var tween = $Label/Tween
var released_button : bool = false
signal clicked_settings

func _on_Settings_button_down() -> void:
	tween.interpolate_property(options_label, "rect_scale", Vector2(1,1), Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Settings_button_up() -> void:
	released_button = true
	tween.interpolate_property(options_label, "rect_scale", Vector2(0.9,0.9), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_settings", name)
