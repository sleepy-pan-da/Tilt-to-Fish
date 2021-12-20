extends FishState


func enter(_msg := {}) -> void:
	fish.movement_vector = fish.bounce_off_walls.compute_bounced_off_vector(fish.collision, fish.movement_vector)
	state_machine.transition_to("Swimming")
