extends TextureButton

onready var tween = $Tween
export(bool) var is_big : bool
var released_button : bool = false
signal clicked_next_wave_button

func _on_NextWave_button_up():
	released_button = true
	if is_big:
		tween.interpolate_property(self, "rect_scale", Vector2(1.4, 1.4), Vector2(1.5, 1.5), 0.08, Tween.TRANS_LINEAR)
	else:
		tween.interpolate_property(self, "rect_scale", Vector2(0.9, 0.9), Vector2(1, 1), 0.08, Tween.TRANS_LINEAR)
	tween.start()

func _on_NextWave_button_down():
	if is_big:
		tween.interpolate_property(self, "rect_scale", Vector2(1.5, 1.5), Vector2(1.4, 1.4), 0.08, Tween.TRANS_LINEAR)
	else:
		tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0.9, 0.9), 0.08, Tween.TRANS_LINEAR)
	SfxManager.ui.play("Next round")
	tween.start()


func _on_Tween_tween_all_completed():
	if released_button:
		released_button = false
		emit_signal("clicked_next_wave_button")
