extends Resource

class_name ItemPool

export(Array, String) var common_items
export(Array, String) var uncommon_items
export(Array, String) var rare_items


func pick_an_item() -> String:
	randomize()
	var luck : int = randi() % 100 # 0-99
	var selected_item : String = ""
	if luck >= 90:
		selected_item =  pick_a_rare_item()
	elif luck >= 70:
		selected_item = pick_an_uncommon_item()
	else:
		selected_item = pick_a_common_item()
	return selected_item

func pick_a_rare_item() -> String:
	var selected_index = randi() % rare_items.size()
	return rare_items[selected_index] + " (" + str(3) + ")"


func pick_an_uncommon_item() -> String:
	var selected_index = randi() % uncommon_items.size()
	return uncommon_items[selected_index] + " (" + str(2) + ")"


func pick_a_common_item() -> String:
	var selected_index = randi() % common_items.size()
	return common_items[selected_index] + " (" + str(1) + ")"


# common items -> 1, uncommon items -> 2, rare items -> 3
func get_cost_of_item(item_name : String) -> int:
	if item_name in common_items:
		return 1
	elif item_name in uncommon_items:
		return 2
	else:
		return 3
