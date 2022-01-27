extends Node

class_name OrbSpawner
export(PackedScene) var orb
var incremented_values

func set_incremented_values(new_incremented_values) -> void:
	incremented_values = new_incremented_values


func spawn_orb(node_to_add_to : Node) -> void:
	var orb_instance : Orb = orb.instance()
	node_to_add_to.add_child(orb_instance)
	orb_instance.global_position = generate_random_pt_on_screen()
	orb_instance.set_incremented_values(incremented_values)
	print(name + ": " + str(node_to_add_to.global_position))


func generate_random_pt_on_screen() -> Vector2:
	# width = 1280
	# height = 720
	
	randomize()
	#var x_coordinate : int = rand_range(320, 960)
	#var y_coordinate : int = rand_range(256, 512)
	var x_coordinate : int
	var y_coordinate : int
	
	x_coordinate = rand_range(100, 1180)
	if x_coordinate >= 320 and x_coordinate <= 960:
		y_coordinate = rand_range(100, 620)
	else:
		y_coordinate = rand_range(256, 512)
	 
	var computed_pt : Vector2 = Vector2(x_coordinate, y_coordinate)
	return computed_pt
