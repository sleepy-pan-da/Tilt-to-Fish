extends FishState


func enter(_msg := {}) -> void:
	fish.steering_behaviour.reset_current_velocity()
	fish.fish_sprite.react_when_recovering()


func on_finished_recovering() -> void:
	if state_machine.state.name == self.name:
		state_machine.transition_to("FollowBobber")
