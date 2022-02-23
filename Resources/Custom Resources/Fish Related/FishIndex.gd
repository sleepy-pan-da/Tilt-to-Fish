extends Resource

class_name FishIndex

export(Array, Resource) var fishes

func get_fish_info(fish_name : String) -> Resource:
	var fish_index : int = get_fish_index(fish_name)
	if fish_index == -1:
		return null
	return fishes[fish_index]


# Querying a resource by fish_name
func get_fish_index(fish_name : String) -> int:
	for i in fishes.size():
		if fishes[i].name == fish_name:
			return i
	return -1
