extends Resource

class_name ItemPool

export(Array, Resource) var items

var common_items : Array
var uncommon_items : Array
var rare_items : Array 

func update_on_first_round() -> void:
	if GameData.round_number == 1:
		common_items.clear()
		uncommon_items.clear()
		rare_items.clear()
		for item in items:
			if item.rarity == ItemTraits.RARITY_TYPES.COMMON:
				common_items.append(item)
			elif item.rarity == ItemTraits.RARITY_TYPES.UNCOMMON:
				uncommon_items.append(item)
			else:
				rare_items.append(item)


func get_item(item_name : String) -> Resource:
	var item_index : int = get_item_index(item_name)
	if item_index == -1:
		return null
	return items[item_index]


func has_item(item_name : String) -> bool:
	var item_index : int = get_item_index(item_name)
	if item_index == -1:
		return false
	return true


func get_item_index(item_name : String) -> int:
	for i in items.size():
		if items[i].display_name == item_name:
			return i
	return -1


func pick_an_item_randomly() -> ItemTraits:
	randomize()
	var current_rarity_distribution : Array = get_rarity_distribution()
	var rarity_picked : int = pick_a_rarity_randomly(current_rarity_distribution)
	
	if rarity_picked == ItemTraits.RARITY_TYPES.COMMON:
		return common_items[randi() % common_items.size()]
	elif rarity_picked == ItemTraits.RARITY_TYPES.UNCOMMON:
		return uncommon_items[randi() % uncommon_items.size()]
	else:
		return rare_items[randi() % rare_items.size()]


func get_rarity_distribution() -> Array:
	var current_round_number : int = GameData.round_number
	if current_round_number >= 8:
		return [10, 40, 50] 
	elif current_round_number >= 4:
		return [30, 50, 20]
	else:
		return [60, 40, 0]
	

func pick_a_rarity_randomly(rarity_distribution : Array) -> int:
	randomize()
	var random_int : int = randi() % 100 # 0-99
	var rare_threshold : int = 100 - rarity_distribution[2]
	var uncommon_threshold : int = rarity_distribution[0]
	if random_int >= rare_threshold:
		return ItemTraits.RARITY_TYPES.RARE
	elif random_int >= uncommon_threshold:
		return ItemTraits.RARITY_TYPES.UNCOMMON
	else: 
		return ItemTraits.RARITY_TYPES.COMMON
