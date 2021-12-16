extends Node2D

# This strictly manages the no. of remaining fish

class_name FishManager

var fishes_remaining : int 
var num_of_fishes_caught : int = 0 # for items that trigger for every x fish caught
signal caught_all_fishes

func update_fishes_remaining_upon_successful_catch() -> void:
	num_of_fishes_caught += 1
	yield(get_tree(), "idle_frame") # queue free only happens at end of frame, need wait for one frame
	update_fishes_remaining()
	if fishes_remaining <= 0: 
		emit_signal("caught_all_fishes")
	

func update_fishes_remaining() -> void:
	fishes_remaining = get_child_count()
