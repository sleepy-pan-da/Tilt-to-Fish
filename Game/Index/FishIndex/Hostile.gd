extends Label

func update_label(can_touch: bool) -> void:
	if can_touch:
		text = "Friendly"
	else:
		text = "Hostile"
