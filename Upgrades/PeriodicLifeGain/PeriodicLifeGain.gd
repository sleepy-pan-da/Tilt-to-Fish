extends Node2D

export(PackedScene) var hook
onready var timer = $Timer

signal created_hook(hook)

func _on_Timer_timeout() -> void:
	create_hook()


func create_hook() -> void:
	var current_hook = hook.instance()
	add_child(current_hook)
	current_hook.connect("bobber_touched_hook", self, "start_timer")
	emit_signal("created_hook", current_hook)


func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()
