extends FishState


func enter(_msg := {}) -> void:
	fish.fish_animation.play("Morph")
	fish.fish_sprite.react_when_proximity_area_first_entered()


func finished_morphing() -> void:
	fish.morphed = true
	state_machine.transition_to("FollowBobber")
