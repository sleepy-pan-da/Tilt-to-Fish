extends FishState


func enter(_msg := {}) -> void:
	fish.collided_timer.start()
	fish.fish_sprite.react_when_stunned()


func _on_CollidedTimer_timeout():
	state_machine.transition_to("Recover")
