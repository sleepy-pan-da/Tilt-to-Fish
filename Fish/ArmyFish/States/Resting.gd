extends FishState


func enter(_msg := {}) -> void:
	fish.rest_timer.start()


# resumes firing after timeout
func _on_RestTimer_timeout():
	if fish.bobber_in_proximity_area != null:
		state_machine.transition_to("Firing")


func _on_ProximityArea_body_entered(body : Bobber) -> void:
	if state_machine.state.name == self.name:
		fish.rest_timer.stop()
		state_machine.transition_to("CannotFire")

