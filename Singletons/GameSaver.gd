extends Node

var save_path = "user://save.dat"
export(Resource) var control_config = control_config as ControlConfig
export(Resource) var player_statistics = player_statistics as PlayerStatistics

# considerations
# since save data format is a dictionary, i need to consider scenarios where
# 1. key name cannot be found (due to renaming or deletion of key)
# 2. new key names (addition of content across patches)

func _ready():
	load_saved_data() # this will temporarily be here

func load_saved_data() -> void:
	var data
	var file = File.new()
	if not file.file_exists(save_path):
		data = get_saved_data_format() # creation of new file
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			data = file.get_var()
			print(data)
			file.close()
	map_loaded_data(data)

func save_data() -> void:
	var data = get_saved_data_format()
	print(data)
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data) # this will override the save file's previous version
		file.close()

func get_saved_data_format():
	var new_load_filedata = {
		"control_config": {
			"holding_preference": control_config.holding_preference,
			"tilt_sensitivity": control_config.tilt_sensitivity
		},
		"sound_config": {
			"music_volume": SongManager.get_music_bus_volume_db(),
			"sfx_volume": SfxManager.get_sfx_bus_volume_db()
		},
		"player_statistics": {
			"highest_round_reached": player_statistics.highest_round_reached
		}
	}
	return new_load_filedata

func map_loaded_data(data) -> void:
	if data.has("control_config"):
		load_data_to_control_config_resource(data["control_config"])
	if data.has("sound_config"):
		load_data_to_sound_config(data["sound_config"])
	if data.has("player_statistics"):
		load_data_to_player_statistics_resource(data["player_statistics"])

func load_data_to_control_config_resource(data) -> void:
	if data.has("holding_preference"):
		control_config.holding_preference = data["holding_preference"]
	if data.has("tilt_sensitivity"):
		control_config.tilt_sensitivity = data["tilt_sensitivity"]

func load_data_to_sound_config(data) -> void:
	if data.has("music_volume"):
		SongManager.set_music_bus_volume_db_from_settings(data["music_volume"])
	if data.has("sfx_volume"):
		SfxManager.set_sfx_bus_volume_db_from_settings(data["sfx_volume"])

func load_data_to_player_statistics_resource(data) -> void:
	if data.has("highest_round_reached"):
		player_statistics.highest_round_reached = data["highest_round_reached"]
