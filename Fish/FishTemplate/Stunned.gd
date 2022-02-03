extends FishState


func enter(_msg := {}) -> void:
	fish.stunned_timer.start(_msg.stun_duration)
	fish.fish_sprite.react_when_stunned()


func _on_StunnedTimer_timeout():
	state_machine.transition_to("Recover")
