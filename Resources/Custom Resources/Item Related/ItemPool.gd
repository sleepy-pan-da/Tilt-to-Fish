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
	var random_index : int = randi() % items.size()
	return items[random_index]
