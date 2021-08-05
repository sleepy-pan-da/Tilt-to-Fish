extends Node2D

export(PackedScene) var long_rest_orb
onready var timer = $Timer

signal created_long_rest_orb(long_rest_orb)

func _on_Timer_timeout() -> void:
	create_long_rest_orb()


func create_long_rest_orb() -> void:
	var current_long_rest_orb = long_rest_orb.instance()
	add_child(current_long_rest_orb)
	current_long_rest_orb.connect("bobber_touched_long_rest_orb", self, "start_timer")
	emit_signal("created_long_rest_orb", current_long_rest_orb)


func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()
