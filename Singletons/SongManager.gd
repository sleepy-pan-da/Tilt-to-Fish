extends Node

onready var tween = $Tween
onready var fishing_music = $FishingMusic
onready var cave_music = $FishingMusic/CaveMusic
onready var hype_music = $FishingMusic/HypeMusic
onready var daft_punk_inspired_music = $FishingMusic/DaftPunkInspiredMusic
onready var surface_music = $SurfaceMusic
var song_starting_volume : float

func _ready() -> void:
	song_starting_volume = AudioServer.get_bus_volume_db(1)
	cave_music.play()

func play_next_fishing_music() -> void:
	if GameData.round_number >= 6:
		fishing_music.get_child(2).play()
	elif GameData.round_number >= 4:
		fishing_music.get_child(1).play()
	else:
		fishing_music.get_child(0).play()

func _on_CaveMusic_finished() -> void:
	play_next_fishing_music()

func _on_DaftPunkInspiredMusic_finished() -> void:
	play_next_fishing_music()

func _on_HypeMusic_finished() -> void:
	play_next_fishing_music()

func on_restart() -> void:
	for song in fishing_music.get_children():
		if song.playing: 
			song.stop()

func custom_set_bus_volume_db(desired_volume_db : float) -> void:
	AudioServer.set_bus_volume_db(1, desired_volume_db)

func fade_out() -> void:
	tween.interpolate_method(self, "custom_set_bus_volume_db", song_starting_volume, -12, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)	
	tween.start()

func fade_in() -> void:
	tween.interpolate_method(self, "custom_set_bus_volume_db", -12, song_starting_volume, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)	
	tween.start()





