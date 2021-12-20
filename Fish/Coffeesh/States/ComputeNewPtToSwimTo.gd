extends FishState


func enter(_msg := {}) -> void:
	fish.movement_vector = fish.swim_to_random_pt_based_on_radius.swim()
	state_machine.transition_to("Swimming")
