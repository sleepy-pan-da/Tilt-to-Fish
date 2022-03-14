extends TextureProgress

signal progress_bar_filled

func set_total_time_to_completion(new_total_time : float) -> void:
	max_value = new_total_time


func increment() -> void:
	value = min(value + 1, max_value)
	if value >= max_value:
		emit_signal("progress_bar_filled")
