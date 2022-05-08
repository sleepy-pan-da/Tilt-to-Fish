extends Node2D


# how to use this node
# attach this inside fish's kinematicbody as global_position is used here 
# needs to follow fish's kinematicbody
 
export(int) var speed
export(int) var look_ahead_distance


var swimming = false
var direction_to_swim : Vector2
var computed_pt : Vector2


func reached_pt() -> bool:
	var reached_pt : bool = (computed_pt - global_position).length() < 50
	if reached_pt:
		swimming = false
	return reached_pt


func swim() -> Vector2:
	compute_pt_to_swim_to()
	direction_to_swim = (computed_pt - global_position).normalized()
	var velocity : Vector2 = direction_to_swim * speed
	swimming = true
	#print(computed_pt)
	return velocity
	
	
func compute_pt_to_swim_to() -> void:
	randomize()
	var x_coordinate : int = randi() % 1280
	var y_coordinate : int = randi() % 720
	computed_pt = Vector2(x_coordinate, y_coordinate)
	if is_computed_pt_near_to_fish():
		compute_pt_to_swim_to()


func is_computed_pt_near_to_fish() -> bool:
	var vector_from_fish_to_pt : Vector2 = computed_pt - global_position
	var pt_is_near_fish : bool = vector_from_fish_to_pt.length() < look_ahead_distance
	return pt_is_near_fish
