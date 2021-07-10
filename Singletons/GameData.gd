extends Node

var highest_wave_number_reached : int = 0

func beat_high_score(current_wave_number : int) -> bool:
	return current_wave_number > highest_wave_number_reached


func update_high_score(current_wave_number : int) -> void:
	highest_wave_number_reached = current_wave_number
