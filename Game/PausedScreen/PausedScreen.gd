extends Node

onready var ui = $CanvasLayer/UI
onready var resume_button = ui.get_node("LeftVBoxContainer/Resume")
onready var restart_button = ui.get_node("LeftVBoxContainer/Restart")
onready var quit_button = ui.get_node("LeftVBoxContainer/Quit")

signal hid_ui

func _ready() -> void:
	ui.hide()
	resume_button.connect("clicked_resume_button", self, "hide_ui")
	restart_button.connect("clicked_restart_button", self, "to_restart_game")
	quit_button.connect("clicked_quit_button", self, "to_quit_game")	
	
func show_ui() -> void:
	ui.show()

func hide_ui() -> void:
	ui.hide()
	emit_signal("hid_ui")


func to_restart_game() -> void:
	GameEvents.emit_signal("to_restart_game_from_paused_screen")


func to_quit_game() -> void:
	GameEvents.emit_signal("to_quit_game_from_paused_screen")
