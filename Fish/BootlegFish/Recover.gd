extends "res://Fish/FishTemplate/Recover.gd"


func enter(_msg := {}) -> void:
	fish.steering_behaviour.reset_current_velocity()
	fish.fish_sprite.react_when_recovering()


func on_finished_recovering() -> void:
	if state_machine.state.name == self.name:
		if fish.morphed:
			state_machine.transition_to(get_parent().state_after_recover.name)
		else:
			state_machine.transition_to("Morphing")			
