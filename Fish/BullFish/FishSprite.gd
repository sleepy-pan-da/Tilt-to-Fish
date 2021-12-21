extends FishTemplateFishSprite

var recovering : bool = false
signal finished_recovering

func react_when_stunned() -> void:
	tween.interpolate_property(self, "scale", Vector2(0.08, 0.08), Vector2(0.063, 0.063), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()


func react_when_recovering() -> void:
	recovering = true
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(0.063, 0.063), 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_completed(object, key):
	if recovering:
		recovering = false
		emit_signal("finished_recovering")
