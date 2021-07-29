extends Node

var highest_round_reached : int = 1
var current_wave_number : int = 1
var round_number : int = 1
var difficulty_modifier : int = 0

func beat_high_score() -> bool:
	return round_number > highest_round_reached


func update_high_score() -> void:
	highest_round_reached = round_number


func reset_game_upon_new_run() -> void:
	reset_wave_number()
	reset_round_number()
	reset_difficulty_modifier()

func reset_wave_number() -> void:
	current_wave_number = 1


func increment_wave_number() -> void:
	current_wave_number += 1


func reset_round_number() -> void:
	round_number = 1

func increment_round_number() -> void:
	round_number += 1
	if round_number % 5 == 1 and round_number != 1:
		increment_difficulty()


func reset_difficulty_modifier() -> void:
	difficulty_modifier = 0


func increment_difficulty() -> void:
	difficulty_modifier += 1
