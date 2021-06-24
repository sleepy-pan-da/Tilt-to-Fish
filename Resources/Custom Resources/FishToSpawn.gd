extends Resource

class_name FishToSpawn
export(Array, PackedScene) var fishes


func generate_random_index_for_fish() -> int:
	randomize()
	var index : int = randi() % fishes.size()
	return index
