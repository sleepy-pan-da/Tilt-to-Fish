extends FishState


func enter(_msg := {}) -> void:
	fish.obtain_bobber_reference(_msg.detected_bobber)
	fish.fish_sprite.react_when_proximity_area_entered()
	state_machine.transition_to("FollowBobber")
