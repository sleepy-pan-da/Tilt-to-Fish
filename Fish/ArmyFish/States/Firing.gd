extends FishState


func enter(_msg := {}) -> void:
	fish.fire_projectiles()
	state_machine.transition_to("Resting")
