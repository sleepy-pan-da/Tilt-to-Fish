extends Node

onready var paused_screen = $PausedScreen

func _ready() -> void:
	paused_screen.connect("hid_ui", self, "resume_game")
	

func _input(event) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and !get_tree().paused:
			pause_game()
			paused_screen.show_ui()


func pause_game() -> void:
	get_tree().paused = true


func resume_game() -> void:
	get_tree().paused = false
