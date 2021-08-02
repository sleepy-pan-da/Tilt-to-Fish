extends TextureProgress

onready var tween = $Tween
signal progress_bar_filled
signal progress_bar_emptied


func set_max_value(amount_needed_to_catch : float) -> void:
	max_value = amount_needed_to_catch


func decrement_bar(fish_recovery_amount : float) ->  void:
	value = max(value - fish_recovery_amount, min_value)
	if value <= 0:
		emit_signal("progress_bar_emptied")


func increment_bar(player_attack_amount : float) -> void:
	value = min(value + player_attack_amount, max_value)
	if value >= max_value:
		emit_signal("progress_bar_filled")
		

func appear() -> void:
	show()
	tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(0.25, 0.25), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func disappear() -> void:
	tween.interpolate_property(self, "rect_scale", Vector2(0.25, 0.25), Vector2(0, 0), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()



