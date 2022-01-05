extends Resource

class_name BackPack

var backpack_max_capacity : int = 5
const MAX_ITEM_EXP : int = 6 

var backpack = 	{
					# skill_A	:	0 (number here refers to exp pts)
					# Lvl1-2 (2 exp needed)
					# Lvl2-3 (4 exp needed) 
				}

func add_item(item_name : String) -> void:
	if has_space():
		backpack[item_name] = 0 # start off with 0 exp


func has_item(item_name : String) -> bool:
	return backpack.has(item_name)


func item_is_maxed_out(item_name : String) -> bool:
	if !has_item(item_name):
		return false
	else:
		return backpack[item_name] == MAX_ITEM_EXP


func has_space() -> bool:
	return backpack.size() < backpack_max_capacity


func gain_exp(item_name) -> void:
	if has_item(item_name) and !item_is_maxed_out(item_name):
		backpack[item_name] += 1


func item_level(item_name : String) -> int:
	if backpack[item_name] == MAX_ITEM_EXP:
		return 3
	elif backpack[item_name] >= 2:
		return 2
	else:
		return 1


func get_keys_of_backpack() -> Array:
	return backpack.keys()


func remove_item_from_backpack(item_name : String) -> void:
	if has_item(item_name):
		backpack.erase(item_name)
