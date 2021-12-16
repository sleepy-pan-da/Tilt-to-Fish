extends FishTemplate

onready var kinematic_body = $KinematicBody
onready var swim_to_random_pt_based_on_radius = $KinematicBody/SwimToRandomPtBasedOnRadius
var movement_vector : Vector2
var collision : KinematicCollision2D


func _physics_process(delta) -> void:
	if !swim_to_random_pt_based_on_radius.swimming:
		movement_vector = swim_to_random_pt_based_on_radius.swim()
	elif swim_to_random_pt_based_on_radius.reached_pt():
		pass
		
	collision = kinematic_body.move_and_collide(movement_vector * delta)
	if collision and collision.collider.is_in_group("PondBoundary"): 
		movement_vector = swim_to_random_pt_based_on_radius.swim()
		
	update_fish_sprite_based_on_horizontal_direction(movement_vector)
