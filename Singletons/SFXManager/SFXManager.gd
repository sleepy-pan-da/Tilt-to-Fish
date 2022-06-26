extends Node

onready var ui = $UI
onready var bobber = $Bobber
onready var fish = $Fish

func play(sfx_name : String) -> void:
	if !sfx_name: return
	get_node(sfx_name).play()

func set_sfx_bus_volume_db_from_settings(desired_volume_db : float) -> void:
	AudioServer.set_bus_volume_db(2, desired_volume_db)

func get_sfx_bus_volume_db() -> float:
	return AudioServer.get_bus_volume_db(2)
