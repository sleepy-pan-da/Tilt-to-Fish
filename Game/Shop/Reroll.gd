extends TextureButton

onready var tween = $Tween
var released_button : bool = false
signal clicked_reroll

func _on_Reroll_button_down() -> void:
	tween.interpolate_property(self, "rect_scale", Vector2(0.075, 0.075), Vector2(0.065, 0.065), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Reroll_button_up() -> void:
	released_button = true
	tween.interpolate_property(self, "rect_scale", Vector2(0.065, 0.065), Vector2(0.075, 0.075), 0.1, Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	if released_button:
		released_button = false
		emit_signal("clicked_reroll")
