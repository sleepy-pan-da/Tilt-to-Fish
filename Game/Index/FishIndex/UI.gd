extends Control

export(String, FILE, "*.tscn") var start_scene 

onready var screen_transition = $ScreenTransition

func _ready() -> void:
	screen_transition.transition_in()
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")


func _on_Back_pressed() -> void:
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	get_tree().change_scene(start_scene)
