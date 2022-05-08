extends Label


func update_item_cost(cost : int) -> void:
	text = str(cost)


func get_item_cost() -> int:
	#var item_cost : Array = text.split("Cost: $", false)
	return int(text)
