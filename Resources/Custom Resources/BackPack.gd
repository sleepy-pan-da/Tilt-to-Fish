extends Resource

class_name BackPack

var backpack_max_capacity : int = 5
var backpack = 	{
					
				}


func add_item(item_name : String) -> void:
	if has_item(item_name):
		if !item_is_maxed_out(item_name):
			backpack[item_name] += 1
			return
	elif has_space():
		backpack[item_name] = 1


func has_item(item_name : String) -> bool:
	return backpack.has(item_name)


func item_is_maxed_out(item_name : String) -> bool:
	if !has_item(item_name):
		return false
	else:
		return backpack[item_name] == 9 


func has_space() -> bool:
	return backpack.size() < backpack_max_capacity


func item_level(item_name : String) -> int:
	if backpack[item_name] == 9:
		return 3
	elif backpack[item_name] >= 3:
		return 2
	else:
		return 1


func get_keys_of_backpack() -> Array:
	return backpack.keys()


func remove_item_from_backpack(item_name : String) -> void:
	if has_item(item_name):
		var qty_of_item = backpack[item_name]
		qty_of_item -= 1
		if qty_of_item == 0:
			backpack.erase(item_name)
		else:
			backpack[item_name] = qty_of_item
