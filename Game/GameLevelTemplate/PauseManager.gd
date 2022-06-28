extends Node

onready var paused_screen = $PausedScreen
var can_pause : bool = true

func _ready() -> void:
	paused_screen.connect("hid_ui", self, "resume_game")

func _input(event) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and !get_tree().paused and can_pause:
			pause_game()
			paused_screen.show_ui()

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false

func enable_pause() -> void:
	can_pause = true

func disable_pause() -> void:
	can_pause = false
