extends FishState


func enter(_msg := {}) -> void:
	state_machine.transition_to("ComputeNewPtToSwimTo")
