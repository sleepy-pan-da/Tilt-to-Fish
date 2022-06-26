extends Control

onready var start_label = $Label
onready var tween = $Label/Tween
var released_button : bool = false
signal clicked_start

func _on_StartButton_button_down() -> void:
	tween.interpolate_property(start_label, "rect_scale", Vector2(1,1), Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_StartButton_button_up() -> void:
	released_button = true
	tween.interpolate_property(start_label, "rect_scale", Vector2(0.9,0.9), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_start", name)
