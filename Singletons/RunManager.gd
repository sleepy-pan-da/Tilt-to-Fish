extends Node

export(Resource) var player_statistics = player_statistics as PlayerStatistics
var current_wave_number : int = 1
var round_number : int = 1
var difficulty_modifier : int = 0
var seconds_elapsed_in_current_run : float

func beat_high_score() -> bool:
	return round_number > player_statistics.highest_round_reached


func update_high_score() -> void:
	player_statistics.highest_round_reached = round_number


func reset_game_upon_new_run() -> void:
	reset_wave_number()
	reset_round_number()
	reset_difficulty_modifier()


func reset_wave_number() -> void:
	current_wave_number = 1


func reset_round_number() -> void:
	round_number = 1
	

func reset_difficulty_modifier() -> void:
	difficulty_modifier = 0


func increment_wave_number() -> void:
	current_wave_number += 1


func increment_round_number() -> void:
	round_number += 1
	if (round_number - 6) % 3 == 0 and round_number >= 6:
		increment_difficulty()
#	if round_number % 5 == 1 and round_number != 1:
#		increment_difficulty()


func increment_difficulty() -> void:
	difficulty_modifier += 1


func on_new_run() -> void:
	seconds_elapsed_in_current_run = 0


func _process(delta : float) -> void:
	seconds_elapsed_in_current_run += delta


func get_time_elapsed_in_current_run() -> String:
	var readable_time : String = convert_time_to_readable_format(int(seconds_elapsed_in_current_run))
	return readable_time


func convert_time_to_readable_format(time_in_seconds : int) -> String:
	var seconds = time_in_seconds % 60
	var minutes = (time_in_seconds / 60) % 60
	return "%s:%02d" % [minutes, seconds]
