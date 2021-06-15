extends Node2D

# How to use node?
# Attach directly to fish node

export(int) var speed : float
var direction : Vector2 


func start_initial_movement():
	generate_initial_direction()
	return direction * speed

func generate_initial_direction():
	randomize()
	var x_direction : float = rand_range(-1, 1)
	var y_direction : float = rand_range(-1, 1)
	direction = Vector2(x_direction, y_direction).normalized()
	

func compute_bounced_off_vector(collision : KinematicCollision2D, movement_vector : Vector2) -> Vector2:
	var bounced_off_vector : Vector2 =  movement_vector.bounce(collision.normal)
	return bounced_off_vector
