extends Control

onready var index_label = $Label
onready var tween = $Label/Tween
var released_button : bool = false
signal clicked_index

func _on_IndexButton_button_down():
	tween.interpolate_property(index_label, "rect_scale", Vector2(1,1), Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_IndexButton_button_up():
	released_button = true
	tween.interpolate_property(index_label, "rect_scale", Vector2(0.9,0.9), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_index", name)
