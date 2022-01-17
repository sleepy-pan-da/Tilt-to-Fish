extends Node

class_name OrbSpawner

export(PackedScene) var orb
onready var timer = $Timer

func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()


func _on_Timer_timeout():
	spawn_orb()


# to be overridden
func spawn_orb() -> void:
	pass
