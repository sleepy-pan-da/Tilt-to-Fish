extends TextureProgress

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
	

