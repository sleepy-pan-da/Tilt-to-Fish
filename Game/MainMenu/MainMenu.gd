extends Node2D

export(String, FILE, "*.tscn") var next_scene 

onready var start = $UI/Labels/Start
onready var screen_transition = $UI/ScreenTransition

func _ready() -> void:
	screen_transition.transition_in()
	start.connect("clicked_start", self, "on_clicked_start")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	screen_metrics()


func on_clicked_start() -> void:
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	get_tree().change_scene(next_scene)


func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
