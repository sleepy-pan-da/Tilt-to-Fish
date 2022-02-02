extends "res://Fish/FishTemplate/Recover.gd"


func enter(_msg := {}) -> void:
	fish.steering_behaviour.reset_current_velocity()
	fish.fish_sprite.react_when_recovering()
