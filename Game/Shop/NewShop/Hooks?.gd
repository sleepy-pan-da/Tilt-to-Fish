extends Button

var current_cost : int = 1

func get_current_cost() -> int:
	return current_cost

func update_label_on_successful_purchase() -> void:
	current_cost *= 2
	text = "Hooks? (" + str(current_cost) + ")"
