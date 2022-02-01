extends FishState


func enter(_msg := {}) -> void:
	fish.lunge_at_bobber.collided_timer.start()
	fish.fish_sprite.react_when_stunned()
	fish.movement_vector = Vector2.ZERO


func _on_CollidedTimer_timeout():
	state_machine.transition_to("Recover")
