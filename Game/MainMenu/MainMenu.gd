extends Node2D

export(String, FILE, "*.tscn") var option_scene 
export(String, FILE, "*.tscn") var index_scene
export(String, FILE, "*.tscn") var settings_scene 

onready var start = $CanvasLayer/UI/Labels/Buttons/Start
onready var index = $CanvasLayer/UI/Labels/Buttons/Index
onready var settings = $CanvasLayer/UI/Labels/Buttons/Settings
onready var screen_transition = $CanvasLayer/UI/ScreenTransition

var button_clicked_to_determine_next_scene : String

func _ready() -> void:
	screen_transition.transition_in()
	start.connect("clicked_start", self, "on_clicked_button")
	index.connect("clicked_index", self, "on_clicked_button")
	settings.connect("clicked_settings", self, 'on_clicked_button')
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	screen_metrics()


func on_clicked_button(button_name : String) -> void:
	SfxManager.ui.play("Confirm")
	button_clicked_to_determine_next_scene = button_name
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	match button_clicked_to_determine_next_scene:
		"Start":
			get_tree().change_scene(option_scene)
		"Index":
			get_tree().change_scene(index_scene)
		"Settings":
			get_tree().change_scene(settings_scene)			


func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
