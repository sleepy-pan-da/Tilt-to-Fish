extends FishState


func enter(_msg := {}) -> void:
	fish.call_deferred("fire_projectiles")
	#fish.fire_projectiles()
	state_machine.transition_to("Resting")
