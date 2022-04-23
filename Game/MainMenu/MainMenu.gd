extends Node2D

export(String, FILE, "*.tscn") var option_scene 
export(String, FILE, "*.tscn") var index_scene 

onready var start = $CanvasLayer/UI/Labels/VBoxContainer/StartButton
onready var index = $CanvasLayer/UI/Labels/VBoxContainer/IndexButton
onready var screen_transition = $CanvasLayer/UI/ScreenTransition

var button_clicked_to_determine_next_scene : String
var buttons = ["start", "index"]

func _ready() -> void:
	screen_transition.transition_in()
	start.connect("clicked_start", self, "on_clicked_start")
	index.connect("clicked_index", self, "on_clicked_index")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	screen_metrics()


func on_clicked_start() -> void:
	button_clicked_to_determine_next_scene = buttons[0]
	screen_transition.transition_out()


func on_clicked_index() -> void:
	button_clicked_to_determine_next_scene = buttons[1]
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	match button_clicked_to_determine_next_scene:
		"start":
			get_tree().change_scene(option_scene)
		"index":
			get_tree().change_scene(index_scene)


func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
