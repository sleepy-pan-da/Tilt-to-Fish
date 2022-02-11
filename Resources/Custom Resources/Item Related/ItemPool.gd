extends Resource

class_name ItemPool

export(Array, Resource) var items

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


# Querying a resource by resource_name
func get_item_index(item_name : String) -> int:
	for i in items.size():
		if items[i].resource_name == item_name:
			return i
	return -1


func pick_an_item_randomly() -> ItemTraits:
	randomize()
	
	#var rarity_picked : int = pick_a_rarity_randomly()
	
	var random_index : int = randi() % items.size()
	return items[random_index]


func pick_a_rarity_randomly() -> int:
	randomize()
	
	var rarity_generated : int = randi() % 10
	if rarity_generated >= 8: # 20% chance
		return ItemTraits.RARITY_TYPES.RARE
	elif rarity_generated >= 3: # 30% chance
		return ItemTraits.RARITY_TYPES.UNCOMMON
	else: 
		return ItemTraits.RARITY_TYPES.COMMON
