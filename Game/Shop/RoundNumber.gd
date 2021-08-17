extends Label


func update_round_number(round_number : int) -> void:
	text = "Round " + str(round_number - 1) + " complete"
