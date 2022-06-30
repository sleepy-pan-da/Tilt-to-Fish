extends VBoxContainer

export(Resource) var control_config = control_config as ControlConfig
onready var topdown_button = $Topdown
onready var regular_button = $Regular
onready var tilt_sensitivity = $TiltSensitivity
onready var music_slider = $MusicVolume/MusicSlider
onready var sfx_slider = $SfxVolume/SfxSlider

func _ready() -> void:
	topdown_button.connect("clicked_topdown_button", self, "on_clicked_holding_preference_button")
	regular_button.connect("clicked_regular_button", self, "on_clicked_holding_preference_button")
	
func update_setting_fields() -> void:
	music_slider.value = db2linear(SongManager.get_music_bus_volume_db())
	sfx_slider.value = db2linear(SfxManager.get_sfx_bus_volume_db())
	tilt_sensitivity.set_slider_value(control_config.tilt_sensitivity)
	update_holding_preference_ui()

func on_clicked_holding_preference_button(holding_preference : String) -> void:
	control_config.holding_preference = holding_preference
	print("holding preference: " + control_config.holding_preference)
	update_holding_preference_ui()

func update_holding_preference_ui() -> void:
	topdown_button.set_button_colour_to_disabled()
	regular_button.set_button_colour_to_disabled()
	match control_config.holding_preference:
		"topdown":
			topdown_button.set_button_colour_to_enabled()
		"regular":
			regular_button.set_button_colour_to_enabled()

func _on_HSlider_value_changed(_value):
	save_tilt_sensitivity()
	
func save_tilt_sensitivity() -> void:
	control_config.tilt_sensitivity = tilt_sensitivity.get_slider_value()
	print("tilt sensitivity: " + str(control_config.tilt_sensitivity))

func _on_MusicSlider_value_changed(value):
	SongManager.set_music_bus_volume_db_from_settings(linear2db(value))

func _on_SfxSlider_value_changed(value):
	SfxManager.set_sfx_bus_volume_db_from_settings(linear2db(value))
