extends Label


func update_item_cost(cost : int) -> void:
	text = "Cost: $" + str(cost)


func get_item_cost() -> int:
	var item_cost : Array = text.split("Cost: $", false)
	return int(item_cost[0])
