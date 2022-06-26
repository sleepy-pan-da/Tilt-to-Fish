extends Button

onready var tween = $Tween
var released_button : bool = false
signal clicked_back_button

func _on_Back_button_down():
	tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0.9, 0.9), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_Back_button_up():
	released_button = true
	tween.interpolate_property(self, "rect_scale", Vector2(0.9, 0.9), Vector2(1, 1), 0.08, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed():
	if released_button:
		released_button = false
		emit_signal("clicked_back_button")
