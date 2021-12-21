extends FishState


func enter(_msg := {}) -> void:
	fish.lunge_at_bobber.stunned_timer.start()
	fish.fish_sprite.react_when_stunned()
	fish.movement_vector = Vector2.ZERO


func _on_StunnedTimer_timeout():
	state_machine.transition_to("RecoverFromStun")
