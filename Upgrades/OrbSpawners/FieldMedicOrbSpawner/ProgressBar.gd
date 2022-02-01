extends TextureProgress

var amount_filled_per_tick : float = 1
signal progress_bar_filled

func set_amount_needed_to_fill(new_value : float) -> void:
	max_value = new_value


func increment() -> void:
	value = min(value + amount_filled_per_tick, max_value)
	if value >= max_value:
		emit_signal("progress_bar_filled")
		pass


func reset() -> void:
	value = 0
