extends FishState


func enter(_msg := {}) -> void:
	fish.movement_vector = fish.bounce_off_walls.start_initial_movement()
	state_machine.transition_to("Swimming")
