extends Node2D

export(PackedScene) var rejuvenate_orb
onready var timer = $Timer

signal created_rejuvenate_orb(rejuvenate_orb)

func _on_Timer_timeout() -> void:
	create_rejuvenate_orb()


func create_rejuvenate_orb() -> void:
	var current_rejuvenate_orb = rejuvenate_orb.instance()
	emit_signal("created_rejuvenate_orb", current_rejuvenate_orb)


func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()
