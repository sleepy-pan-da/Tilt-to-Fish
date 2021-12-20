extends FishState

# will be called when bobber spawns due to large detection area
# this starts the firing
func on_detected_bobber(bobber : Bobber) -> void:
	if state_machine.state.name == self.name:
		fish.obtain_bobber_reference(bobber)
		state_machine.transition_to("Firing")
