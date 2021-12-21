extends FishState


func physics_update(_delta: float) -> void:
	if fish.bobber_in_proximity_area != null: 
		fish.movement_vector = fish.steering_behaviour.compute_new_velocity(fish.bobber_in_proximity_area)
		fish.collision = fish.kinematic_body.move_and_collide(fish.movement_vector * _delta)
		fish.update_fish_sprite_based_on_horizontal_direction(fish.movement_vector)
		
		if fish.collision and fish.collision.collider.is_in_group("PondBoundary"): 
			state_machine.transition_to("Stunned")
	else:
		state_machine.transition_to("ComputeNewPtToSwimTo")
