extends Resource

class_name BackPack

var backpack_max_capacity : int = 5
const MAX_ITEM_EXP : int = 6 

# key pair here is item_name(String) : exp_pts(int)
var held_items = 	{
						# item_A	:	0 (number here refers to exp pts)
						# Lvl1-2 (2 exp needed)
						# Lvl2-3 (4 exp needed) 
						#"Strength"		:	0,
						#"Constitution"	:	2,
						#"FalseGod"		:	0,
						#"NotToday"		:	6,
						#"Cccombo"		:	0,
						#"TimeLordVictorious"	:	0,
						#"BulletTime"	:	2,
						"Arrow"	:	2,
						"AntimatterWave"	:	2
					}



func add_item(item_name : String) -> void:
	if has_space():
		held_items[item_name] = 0 # start off with 0 exp


func has_item(item_name : String) -> bool:
	return held_items.has(item_name)


func item_is_maxed_out(item_name : String) -> bool:
	if !has_item(item_name):
		return false
	else:
		return held_items[item_name] == MAX_ITEM_EXP


func has_space() -> bool:
	return held_items.size() < backpack_max_capacity


func gain_exp(item_name) -> void:
	if has_item(item_name) and !item_is_maxed_out(item_name):
		held_items[item_name] += 1


func item_level(item_name : String) -> int:
	if held_items[item_name] == MAX_ITEM_EXP:
		return 3
	elif held_items[item_name] >= 2:
		return 2
	else:
		return 1


func remove_item_from_backpack(item_name : String) -> void:
	if has_item(item_name):
		held_items.erase(item_name)
