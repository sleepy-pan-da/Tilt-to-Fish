extends Node2D

class_name FishManager

var fishes_remaining : int 
signal caught_all_fishes

func update_fishes_remaining_upon_successful_catch() -> void:
	yield(get_tree(), "idle_frame") # queue free only happens at end of frame, need wait for one frame
	update_fishes_remaining()
	if fishes_remaining <= 0: 
		emit_signal("caught_all_fishes")


func update_fishes_remaining() -> void:
	# wave timer is a child of fishes as well, need to minus wave timer
	fishes_remaining = get_child_count() - 1  
