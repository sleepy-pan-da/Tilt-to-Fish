extends Node

class_name OrbSpawner
export(PackedScene) var orb

func spawn_orb(node_to_add_to : Node) -> void:
	var orb_instance = orb.instance()
	node_to_add_to.add_child(orb_instance)
	node_to_add_to.global_position = generate_random_pt_on_screen()


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
