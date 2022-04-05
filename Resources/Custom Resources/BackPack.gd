extends Resource

class_name BackPack

var backpack_max_capacity : int = 5
const ITEM_EXP_FOR_LVL3 : int = 6
const ITEM_EXP_FOR_LVL2 : int = 2


var held_items = 	{
						# key pair here is item_name(String) : exp_pts(int)	
						# e.g. item_A	:	0 (number here refers to exp pts)
						# Lvl1-2 (1 exp needed)
						# Lvl2-3 (2 exp needed) 
						
						#"Strength"		:	0,
						#"Constitution"	:	2,
						#"False God"		:	0,
						#"Not Today"		:	3,
						#"Cccombo"		:	0,
						#"Time Lord Victorious"	:	0,
						#"Bullet Time"	:	2,
						#"Arrow"	:	3,
						#"Antimatter Wave"	:	3,
						#"Five Rounds Rapid"	:	0,
						#"Field Medic"	:	0,
						#"Stun Grenade"	:	6,
						#"Quick Reload"	:	6,
						#"Infinite Power"	:	3,
						#"Piggy Bank"	: 0,
						#"Biscuit Tin"	:	0,
						#"Room For More"	:	0,
						#"Loyalty Card"	:	0,
						#"Retaliation"	:	0,
						#"Long Rest"	:	3,
						#"Invulnerability"	:	6,
						#"Rejuvenation"	:	2,
						#"Sticky Goo"	:	0,
						#"Mjolnir"	:	0,
						#"Plasma Field"	:	0,
						#"Intimidate"	:	3,
						#"Acid"	:	6,
						#"At All Cost"	:	0,
						#"Safe Distancing"	:	0,
						#"Thunder"	:	0,
						#"Static Field"	:	0,
						#"Against All Odds"	:	0
					}


func get_items_of_backpack() -> Array:
	return held_items.keys()


func add_item(item_name : String) -> void:
	if has_space():
		held_items[item_name] = 0 # start off with 0 exp


func get_item_level(item_name : String) -> int:
	if held_items[item_name] == ITEM_EXP_FOR_LVL3:
		return 3
	elif held_items[item_name] >= ITEM_EXP_FOR_LVL2:
		return 2
	else:
		return 1


func remove_item_from_backpack(item_name : String) -> void:
	if has_item(item_name):
		held_items.erase(item_name)


func level_up_all_held_items() -> void:
	var held_items : Array = get_items_of_backpack()
	for item_name in held_items:
		gain_exp(item_name)


func gain_exp(item_name) -> void:
	if has_item(item_name) and !item_is_maxed_out(item_name):
		held_items[item_name] += 1
		

func item_is_maxed_out(item_name : String) -> bool:
	if !has_item(item_name):
		return false
	else:
		return held_items[item_name] == ITEM_EXP_FOR_LVL3		


func has_space() -> bool:
	return held_items.size() < backpack_max_capacity


func has_item(item_name : String) -> bool:
	return held_items.has(item_name)
