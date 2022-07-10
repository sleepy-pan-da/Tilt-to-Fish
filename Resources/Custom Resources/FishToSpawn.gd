extends Resource

class_name FishToSpawn
export(Array, PackedScene) var fishes


func generate_random_index_for_fish() -> int:
	randomize()
	var start_index : int
	var end_index : int
	match RunManager.round_number:
		1:
			# slothfish and scrubfish, just to teach basic mechanics
			start_index = 0
			end_index = 1
		2:
			start_index = 0
			end_index = 3 # sea urchin is added to teach players that some fish can't be touched
		3:
			start_index = 1
			end_index = 5 # dvdfish and babyshark are added
		4:
			start_index = 1
			end_index = 6 # armyfish is added
		5:
			start_index = 1
			end_index = 7 # bullfish is added
		_:
			start_index = 2
			end_index = 8 # bootlegfish is added
			

	var current_indexes : Array = range(start_index, end_index + 1)
	var index : int = current_indexes[randi() % current_indexes.size()]
	return index
