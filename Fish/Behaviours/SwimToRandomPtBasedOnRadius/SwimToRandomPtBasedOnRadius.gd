extends Node2D


# how to use this node
# attach this inside fish's kinematicbody as global_position is used here 
# needs to follow fish's kinematicbody
 
export(int) var speed
export(int) var radius


var swimming : bool = false
var direction_to_swim : Vector2
var computed_pt : Vector2


func reached_pt() -> bool:
	var reached_pt : bool = (computed_pt - global_position).length() < 50
	if reached_pt:
		swimming = false
	return reached_pt


func swim() -> Vector2:
	direction_to_swim = compute_random_direction()
	compute_pt_to_swim_to()
	var velocity : Vector2 = direction_to_swim * speed
	swimming = true
	print(computed_pt)
	return velocity


func compute_random_direction():
	randomize()
	var random_angle : float = rand_range(0, 2*PI)
	var x : float = cos(random_angle)
	var y : float = sin(random_angle)
	var computed_direction : Vector2 = Vector2(x, y).normalized()
	return computed_direction

	
func compute_pt_to_swim_to() -> void:
	computed_pt = direction_to_swim * radius + global_position

