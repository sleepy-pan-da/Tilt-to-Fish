extends FishState


func enter(_msg := {}) -> void:
	if fish.bobber_in_proximity_area != null: 
		fish.movement_vector = fish.lunge_at_bobber.lunge(fish.bobber_in_proximity_area)
		state_machine.transition_to("Lunging")
