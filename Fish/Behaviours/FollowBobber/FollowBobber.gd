extends Node2D

# how to use node
# attach it into fish's kinematic body as global_position used here
# needs to follow fish's kinematicbody
export(int) var speed : float
	

func compute_vector_to_move_towards_bobber(bobber : Bobber) -> Vector2:
	var velocity : Vector2 = Vector2.ZERO
	
	var bobber_position : Vector2 = bobber.global_position
	var fish_to_bobber : Vector2 = bobber_position - global_position
	
	var far_from_bobber = fish_to_bobber.length() > 5
	if far_from_bobber:
		var direction_to_bobber : Vector2 = fish_to_bobber.normalized()
		velocity = direction_to_bobber * speed
		
	return velocity
