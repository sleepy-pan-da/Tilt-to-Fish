extends FishState


func physics_update(_delta: float) -> void:
	fish.movement_vector = fish.follow_bobber.compute_vector_to_move_towards_bobber(fish.bobber_in_proximity_area)
	fish.collision = fish.kinematic_body.move_and_collide(fish.movement_vector * _delta)
	fish.update_fish_sprite_based_on_horizontal_direction(fish.movement_vector)


func on_lost_bobber() -> void:
	if state_machine.state.name == self.name:
		fish.bobber_in_proximity_area = null # need this to solve for null reference 
		state_machine.transition_to("ComputeNewPtToSwimTo")
