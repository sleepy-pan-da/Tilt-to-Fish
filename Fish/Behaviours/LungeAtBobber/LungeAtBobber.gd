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
var lunging : bool = false
var num_of_lunges : int = 0
var can_lunge : bool = true
var stunned : bool = false
signal recovered_from_stun

func reached_pt() -> bool:
	var reached_pt : bool = (computed_pt - global_position).length() < 5
	if reached_pt:
		on_reached_pt()
	return reached_pt


func on_reached_pt() -> void:
	lunging = false
	num_of_lunges += 1
	if num_of_lunges >= num_of_lunges_before_rest:
		rest_timer.start()
		num_of_lunges = 0
	else:
		cooldown_between_lunges.start()


func stunned() -> void:
	stunned = true
	lunging = false
	stunned_timer.start()
	num_of_lunges = 0
	
	
func _on_RestTimer_timeout() -> void:
	can_lunge = true
	

func _on_CooldownBetweenLunges_timeout() -> void:
	can_lunge = true


func _on_StunnedTimer_timeout():
	can_lunge = true
	stunned = false
	emit_signal("recovered_from_stun")

func lunge(bobber : Bobber) -> Vector2:
	var velocity : Vector2
	if can_lunge:
		direction_to_lunge = compute_direction_to_lunge_towards_bobber(bobber)
		computed_pt = compute_pt()
		velocity = direction_to_lunge * speed
		lunging = true
		can_lunge = false
		
	return velocity
	

func compute_direction_to_lunge_towards_bobber(bobber : Bobber):
	var bobber_position : Vector2 = bobber.global_position
	var fish_to_bobber : Vector2 = bobber_position - global_position
	return fish_to_bobber.normalized()


func compute_pt() -> Vector2:
	return global_position + direction_to_lunge * radius



