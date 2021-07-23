extends Node2D

export(PackedScene) var iron
onready var timer = $Timer
signal created_iron(iron)

func _on_Timer_timeout():
	create_iron()


func create_iron() -> void:
	var current_iron = iron.instance()
	add_child(current_iron)
	current_iron.connect("bobber_touched_iron", self, "start_timer")
	emit_signal("created_iron", current_iron)


func set_timer(new_time) -> void:
	timer.wait_time = new_time


func start_timer() -> void:
	timer.start()
