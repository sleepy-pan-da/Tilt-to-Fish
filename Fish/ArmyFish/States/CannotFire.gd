extends FishState

func _on_ProximityArea_body_exited(body : Bobber) -> void:
	if state_machine.state.name == self.name:
		state_machine.transition_to("Resting")
