extends Node

onready var cave_music = $CaveMusic
onready var hype_music = $HypeMusic
onready var surface_music = $SurfaceMusic

var number_of_times_to_play_cave_music : int = 2
var number_of_times_cave_music_is_played : int = 0

func _ready() -> void:
	cave_music.play()
	number_of_times_cave_music_is_played += 1


func _on_CaveMusic_finished():
	if number_of_times_cave_music_is_played < number_of_times_to_play_cave_music:
		cave_music.play()
		number_of_times_cave_music_is_played += 1
	else:
		hype_music.play()


func _on_HypeMusic_finished():
	hype_music.play()
