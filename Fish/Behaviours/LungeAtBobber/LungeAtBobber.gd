extends Node2D

# how to use node
# attach it into fish's kinematic body as global_position used here
# needs to follow fish's kinematicbody
export(int) var speed 
export(int) var num_of_lunges_before_rest 	
export(int) var radius

onready var cooldown_between_lunges = $CooldownBetweenLunges
onready var rest_timer = $RestTimer
onready var stunned_timer = $StunnedTimer

var direction_to_lunge : Vector2
var computed_pt : Vector2
var num_of_lunges : int = 0


func lunge(bobber : Bobber) -> Vector2:
	var velocity : Vector2
	
	direction_to_lunge = compute_direction_to_lunge_towards_bobber(bobber)
	computed_pt = compute_pt()
	velocity = direction_to_lunge * speed
		
	return velocity
	

func compute_direction_to_lunge_towards_bobber(bobber : Bobber):
	var bobber_position : Vector2 = bobber.global_position
	var fish_to_bobber : Vector2 = bobber_position - global_position
	return fish_to_bobber.normalized()


func compute_pt() -> Vector2:
	return global_position + direction_to_lunge * radius





func reached_pt() -> bool:
	var reached_pt : bool = (computed_pt - global_position).length() < 5
	return reached_pt
	

# timer logic should be settled by the fish's states since states settle all the logic
# if timer is settled here, it gets damn confusing

#func on_reached_pt() -> void:
#	num_of_lunges += 1
#	if num_of_lunges >= num_of_lunges_before_rest:
#		rest_timer.start()
#		num_of_lunges = 0
#	else:
#		cooldown_between_lunges.start()



