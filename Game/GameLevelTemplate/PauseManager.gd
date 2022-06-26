extends Node

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			get_tree().paused = !get_tree().paused
