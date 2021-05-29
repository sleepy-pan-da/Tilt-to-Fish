extends TextureProgress

signal progress_bar_filled

var offset : Vector2 = rect_position



func configure_offset() -> void:
	offset = rect_position


func set_max_value(amount_needed_to_catch : int) -> void:
	max_value = amount_needed_to_catch


func decrement_bar(fish_recovery_amount : int) ->  void:
	value = max(value - fish_recovery_amount, min_value)


func increment_bar(player_attack_amount : int) -> void:
	value = min(value + player_attack_amount, max_value)
	if value >= max_value:
		emit_signal("progress_bar_filled")
	
func relocate(new_position : Vector2) -> void:
	rect_position = new_position + offset
