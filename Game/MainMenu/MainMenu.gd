extends Node2D

export(String, FILE, "*.tscn") var next_scene 

onready var start = $UI/Labels/Start
onready var screen_transition = $UI/ScreenTransition

func _ready() -> void:
	screen_transition.transition_in()
	start.connect("clicked_start", self, "on_clicked_start")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	

func on_clicked_start() -> void:
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	get_tree().change_scene(next_scene)
