extends FishState


func enter(_msg := {}) -> void:
	fish.fish_sprite.react_when_hit_wall()
	state_machine.transition_to("ComputeNewPtToSwimTo")
