extends FishState


func physics_update(_delta: float) -> void:
	fish.collision = fish.kinematic_body.move_and_collide(fish.movement_vector * _delta)
	fish.update_fish_sprite_based_on_horizontal_direction(fish.movement_vector)
	
	if fish.collision:
		state_machine.transition_to("Collided")

