extends Resource

class_name FishPaths
export(Array, PackedScene) var array_of_paths
export var path_index : int = 0
#max number of specific fish type that can be generated in pond = number of possible paths
#path index is incremented each time path is chosen to ensure 2 fish don't take the same path

func choose_path() -> PackedScene:
	return array_of_paths[path_index % array_of_paths.size()]


func update_path_index() -> void:
	path_index += 1
