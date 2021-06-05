extends TextureProgress


func set_max_value(flow_progress_bar_max_value : float) -> void:
	max_value = flow_progress_bar_max_value


func decrement_bar(bobber_decrement_amount : float) ->  void:
	value = max(value - bobber_decrement_amount, min_value)


func increment_bar(bobber_increment_amount : float) -> void:
	value = min(value + bobber_increment_amount, max_value)
	if value >= max_value:
		emit_signal("progress_bar_filled")
	
