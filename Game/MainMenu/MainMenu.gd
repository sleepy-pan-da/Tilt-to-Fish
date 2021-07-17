extends Node2D

export(String, FILE, "*.tscn") var game_scene 
export(PackedScene) var option_scene 

onready var start = $UI/Labels/Start
onready var options = $UI/Labels/Options
onready var screen_transition = $UI/ScreenTransition
var button_clicked : String
var buttons = ["start", "options"]
#var loaded_game_scene : PackedScene

func _ready() -> void:
	screen_transition.transition_in()
	start.connect("clicked_start", self, "on_clicked_start")
	options.connect("clicked_options", self, "on_clicked_options")
	screen_transition.connect("transitioned_out", self, "go_to_next_scene")
	#loaded_game_scene = game_scene.instance()

func on_clicked_start() -> void:
	button_clicked = buttons[0]
	screen_transition.transition_out()


func on_clicked_options() -> void:
	button_clicked = buttons[1]
	screen_transition.transition_out()


func go_to_next_scene() -> void:
	match button_clicked:
		"start":
			start_game()
		"options":
			go_to_options_page()

func start_game() -> void:
	get_tree().change_scene(game_scene)


func go_to_options_page() -> void:
	get_tree().change_scene_to(option_scene)
