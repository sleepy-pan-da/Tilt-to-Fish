extends Control

export(String, FILE, "*.tscn") var start_scene 

onready var back = $Back
onready var music_slider = $MusicVolume/MusicSlider
onready var sfx_slider = $SfxVolume/SfxSlider
onready var screen_transition = $ScreenTransition

func _ready() -> void:
	screen_transition.transition_in()
	update_setting_fields()
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	back.connect("clicked_back_button", self, "on_back_pressed")

func update_setting_fields() -> void:
	music_slider.value = db2linear(SongManager.get_music_bus_volume_db())
	sfx_slider.value = db2linear(SfxManager.get_sfx_bus_volume_db())

func on_back_pressed() -> void:
	GameSaver.save_data()
	SfxManager.ui.play("Back")
	screen_transition.transition_out()

func go_to_next_scene() -> void:
	get_tree().change_scene(start_scene)

func _on_MusicSlider_value_changed(value):
	#print("Music volume changed to " + str(value))
	SongManager.set_music_bus_volume_db_from_settings(linear2db(value))

func _on_SfxSlider_value_changed(value):
	#print("Sfx volume changed to " + str(value))
	SfxManager.set_sfx_bus_volume_db_from_settings(linear2db(value))
