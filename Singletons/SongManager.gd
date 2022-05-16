extends Node

onready var tween = $Tween
onready var cave_music = $CaveMusic
onready var hype_music = $HypeMusic
onready var surface_music = $SurfaceMusic

var song_starting_volume : float

func _ready() -> void:
	song_starting_volume = AudioServer.get_bus_volume_db(1)
	cave_music.play()

func _on_CaveMusic_finished() -> void:
	if GameData.round_number >= 5:
		hype_music.play()
	else:
		cave_music.play()

func _on_HypeMusic_finished() -> void:
	hype_music.play()

func custom_set_bus_volume_db(desired_volume_db : float) -> void:
	AudioServer.set_bus_volume_db(1, desired_volume_db)

func fade_out() -> void:
	tween.interpolate_method(self, "custom_set_bus_volume_db", song_starting_volume, -12, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)	
	tween.start()

func fade_in() -> void:
	tween.interpolate_method(self, "custom_set_bus_volume_db", -12, song_starting_volume, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)	
	tween.start()


