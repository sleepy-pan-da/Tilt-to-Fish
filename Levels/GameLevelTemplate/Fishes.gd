extends Node2D


var fishes_remaining : int 
signal caught_all_fishes


func _ready() -> void:
	fishes_remaining = get_child_count()


func update_fishes_remaining_upon_successful_catch() -> void:
	fishes_remaining -= 1
	if fishes_remaining <= 0:
		emit_signal("caught_all_fishes")
