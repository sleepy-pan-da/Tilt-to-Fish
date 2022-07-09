extends Node

var save_path = "user://save.dat"
export(Resource) var control_config = control_config as ControlConfig

# considerations
# since save data format is a dictionary, i need to consider scenarios where
# 1. key name cannot be found (due to renaming or deletion of key)
# 2. new key names (addition of content across patches)

func load_saved_data() -> void:
	var data
	var file = File.new()
	if not file.file_exists(save_path):
		data = get_saved_data_format()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			data = file.get_var()
			print(data)
			file.close()
	map_saved_data_to_resources(data)

func save_data() -> void:
	var data = get_saved_data_format()
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()

func get_saved_data_format():
	var new_load_filedata = {
		"holding_preference": control_config.holding_preference,
		"tilt_sensitivity": control_config.tilt_sensitivity
	}
	return new_load_filedata

func map_saved_data_to_resources(data) -> void:
	if data.has("holding_preference"):
		control_config.holding_preference = data["holding_preference"]
	if data.has("tilt_sensitivity"):
		control_config.tilt_sensitivity = data["tilt_sensitivity"]
